package com.pahanaedu.dao;

import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillingDAO {

    // ---------- Create draft ----------
    public int createDraft(Integer customerId, int createdBy) throws SQLException {
        final String nextNoSql = "SELECT LPAD(IFNULL(MAX(billId)+1,1),5,'0') FROM bills";
        final String insertSql = "INSERT INTO bills " +
                "(billNo, billDate, customerId, createdBy, subTotal, discountAmt, netTotal, paidAmount, paymentMethod) " +
                "VALUES (?, NOW(), ?, ?, 0.00, 0.00, 0.00, 0.00, 'CASH')";

        try (Connection c = DBConnection.getInstance().getConnection()) {
            c.setAutoCommit(false);
            try (Statement st = c.createStatement();
                 ResultSet rs = st.executeQuery(nextNoSql)) {

                rs.next();
                String billNo = "B-" + rs.getString(1);

                try (PreparedStatement ps = c.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, billNo);
                    if (customerId == null) ps.setNull(2, Types.INTEGER); else ps.setInt(2, customerId);
                    ps.setInt(3, createdBy);
                    ps.executeUpdate();

                    try (ResultSet gk = ps.getGeneratedKeys()) {
                        gk.next();
                        int billId = gk.getInt(1);
                        c.commit();
                        return billId;
                    }
                }
            } catch (SQLException ex) {
                c.rollback(); throw ex;
            } finally { c.setAutoCommit(true); }
        }
    }

    // ---------- Customer / Notes ----------
    public void setCustomer(int billId, Integer customerId) throws SQLException {
        final String sql = "UPDATE bills SET customerId=? WHERE billId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (customerId == null) ps.setNull(1, Types.INTEGER); else ps.setInt(1, customerId);
            ps.setInt(2, billId);
            ps.executeUpdate();
        }
    }

    public void setNotes(int billId, String notes) throws SQLException {
        final String sql = "UPDATE bills SET notes=? WHERE billId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, notes);
            ps.setInt(2, billId);
            ps.executeUpdate();
        }
    }

    // ---------- Items on bill (no DB triggers; Java manages stock + snapshots) ----------
    public void addLine(int billId, int itemId, int qty) throws SQLException {
        final String getItem = "SELECT name, unitPrice, isActive, stockQty FROM items WHERE itemId=?";
        final String decStock = "UPDATE items SET stockQty = stockQty - ? WHERE itemId=? AND stockQty >= ?";
        final String insLine  = "INSERT INTO bill_items (billId,itemId,itemName,unitPrice,qty,lineTotal) VALUES (?,?,?,?,?,?)";

        try (Connection c = DBConnection.getInstance().getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement gp = c.prepareStatement(getItem)) {
                gp.setInt(1, itemId);
                try (ResultSet rs = gp.executeQuery()) {
                    if (!rs.next()) throw new SQLException("Item not found");
                    String name = rs.getString("name");
                    double price = rs.getDouble("unitPrice");
                    boolean active = rs.getBoolean("isActive");
                    int stock = rs.getInt("stockQty");

                    if (!active) throw new SQLException("Item '" + name + "' is INACTIVE");
                    if (qty <= 0) throw new SQLException("Quantity must be > 0");
                    if (stock < qty) throw new SQLException("Not enough stock for '" + name + "'");

                    try (PreparedStatement us = c.prepareStatement(decStock)) {
                        us.setInt(1, qty);
                        us.setInt(2, itemId);
                        us.setInt(3, qty);
                        if (us.executeUpdate() != 1) throw new SQLException("Stock update failed");
                    }

                    try (PreparedStatement ins = c.prepareStatement(insLine)) {
                        ins.setInt(1, billId);
                        ins.setInt(2, itemId);
                        ins.setString(3, name);
                        ins.setDouble(4, price);
                        ins.setInt(5, qty);
                        ins.setDouble(6, price * qty);
                        ins.executeUpdate();
                    }
                }
            }
            c.commit();
        } catch (SQLException ex) {
            throw ex;
        }
    }

    public void removeLine(int billItemId) throws SQLException {
        final String getLine = "SELECT itemId, qty FROM bill_items WHERE billItemId=?";
        final String delLine = "DELETE FROM bill_items WHERE billItemId=?";
        final String incStock = "UPDATE items SET stockQty = stockQty + ? WHERE itemId=?";

        try (Connection c = DBConnection.getInstance().getConnection()) {
            c.setAutoCommit(false);
            Integer itemId = null;
            int qty = 0;

            try (PreparedStatement g = c.prepareStatement(getLine)) {
                g.setInt(1, billItemId);
                try (ResultSet rs = g.executeQuery()) {
                    if (rs.next()) {
                        int iid = rs.getInt("itemId");
                        if (!rs.wasNull()) itemId = iid;
                        qty = rs.getInt("qty");
                    } else {
                        c.rollback(); return; // nothing to delete
                    }
                }
            }

            try (PreparedStatement d = c.prepareStatement(delLine)) {
                d.setInt(1, billItemId);
                d.executeUpdate();
            }

            if (itemId != null && qty > 0) {
                try (PreparedStatement up = c.prepareStatement(incStock)) {
                    up.setInt(1, qty);
                    up.setInt(2, itemId);
                    up.executeUpdate();
                }
            }

            c.commit();
        } catch (SQLException ex) { throw ex; }
    }

    public void updateQty(int billItemId, int newQty, int billId) throws SQLException {
        final String getLine = "SELECT itemId, qty, unitPrice FROM bill_items WHERE billItemId=? AND billId=?";
        final String setQty  = "UPDATE bill_items SET qty=?, lineTotal=? WHERE billItemId=?";
        final String incStock = "UPDATE items SET stockQty = stockQty + ? WHERE itemId=?";
        final String decStock = "UPDATE items SET stockQty = stockQty - ? WHERE itemId=? AND stockQty >= ?";

        if (newQty <= 0) throw new SQLException("Quantity must be > 0");

        try (Connection c = DBConnection.getInstance().getConnection()) {
            c.setAutoCommit(false);

            Integer itemId = null;
            int oldQty = 0;
            double unitPrice = 0;

            try (PreparedStatement g = c.prepareStatement(getLine)) {
                g.setInt(1, billItemId);
                g.setInt(2, billId);
                try (ResultSet rs = g.executeQuery()) {
                    if (!rs.next()) { c.rollback(); throw new SQLException("Line not found"); }
                    int iid = rs.getInt("itemId");
                    if (!rs.wasNull()) itemId = iid;
                    oldQty = rs.getInt("qty");
                    unitPrice = rs.getDouble("unitPrice");
                }
            }

            int diff = newQty - oldQty;
            if (itemId != null && diff != 0) {
                if (diff > 0) {
                    try (PreparedStatement d = c.prepareStatement(decStock)) {
                        d.setInt(1, diff);
                        d.setInt(2, itemId);
                        d.setInt(3, diff);
                        if (d.executeUpdate() != 1) { c.rollback(); throw new SQLException("Not enough stock"); }
                    }
                } else {
                    try (PreparedStatement i = c.prepareStatement(incStock)) {
                        i.setInt(1, -diff);
                        i.setInt(2, itemId);
                        i.executeUpdate();
                    }
                }
            }

            try (PreparedStatement s = c.prepareStatement(setQty)) {
                s.setInt(1, newQty);
                s.setDouble(2, unitPrice * newQty);
                s.setInt(3, billItemId);
                s.executeUpdate();
            }

            c.commit();
        } catch (SQLException ex) { throw ex; }
    }

    // ---------- Totals / finalize ----------
    public void recomputeTotals(int billId) throws SQLException {
        final String up =
                "UPDATE bills b SET " +
                " subTotal = (SELECT COALESCE(SUM(lineTotal),0) FROM bill_items bi WHERE bi.billId=b.billId), " +
                " netTotal = subTotal - discountAmt, " +
                " paidAmount = netTotal " +
                "WHERE b.billId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(up)) {
            ps.setInt(1, billId);
            ps.executeUpdate();
        }
    }

    public void applyDiscountAndMethod(int billId, double discountAmt, String method) throws SQLException {
        final String up = "UPDATE bills SET discountAmt=?, paymentMethod=? WHERE billId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(up)) {
            ps.setDouble(1, Math.max(0, discountAmt));
            ps.setString(2, (method == null || method.isBlank()) ? "CASH" : method);
            ps.setInt(3, billId);
            ps.executeUpdate();
        }
        recomputeTotals(billId);
    }

    // ---------- Load bill ----------
    public Bill getBill(int billId) throws SQLException {
        final String sql = "SELECT billId,billNo,billDate,customerId,createdBy,subTotal,discountAmt,netTotal,paidAmount,paymentMethod,notes " +
                           "FROM bills WHERE billId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, billId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Bill b = new Bill();
                    b.setBillId(rs.getInt("billId"));
                    b.setBillNo(rs.getString("billNo"));
                    Timestamp ts = rs.getTimestamp("billDate");
                    b.setBillDate(ts == null ? null : ts.toLocalDateTime());
                    int cid = rs.getInt("customerId"); b.setCustomerId(rs.wasNull() ? null : cid);
                    int uid = rs.getInt("createdBy");  b.setCreatedBy(rs.wasNull() ? null : uid);
                    b.setSubTotal(rs.getDouble("subTotal"));
                    b.setDiscountAmt(rs.getDouble("discountAmt"));
                    b.setNetTotal(rs.getDouble("netTotal"));
                    b.setPaidAmount(rs.getDouble("paidAmount"));
                    b.setPaymentMethod(rs.getString("paymentMethod"));
                    b.setNotes(rs.getString("notes"));
                    b.setItems(listLines(billId));
                    return b;
                }
            }
        }
        return null;
    }

    private List<BillItem> listLines(int billId) throws SQLException {
        final String sql = "SELECT billItemId,billId,itemId,itemName,unitPrice,qty,lineTotal " +
                           "FROM bill_items WHERE billId=? ORDER BY billItemId";
        List<BillItem> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, billId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BillItem bi = new BillItem();
                    bi.setBillItemId(rs.getInt("billItemId"));
                    bi.setBillId(rs.getInt("billId"));
                    int iid = rs.getInt("itemId");
                    bi.setItemId(rs.wasNull() ? null : iid);
                    bi.setItemName(rs.getString("itemName"));
                    bi.setUnitPrice(rs.getDouble("unitPrice"));
                    bi.setQty(rs.getInt("qty"));
                    bi.setLineTotal(rs.getDouble("lineTotal"));
                    out.add(bi);
                }
            }
        }
        return out;
    }

    // ---------- Cancel ----------
    public void cancelBill(int billId) throws SQLException {
        final String getLines = "SELECT itemId, qty FROM bill_items WHERE billId=?";
        final String incStock = "UPDATE items SET stockQty = stockQty + ? WHERE itemId=?";
        final String delItems = "DELETE FROM bill_items WHERE billId=?";
        final String delBill  = "DELETE FROM bills WHERE billId=?";

        try (Connection c = DBConnection.getInstance().getConnection()) {
            c.setAutoCommit(false);
            // restore stock
            try (PreparedStatement g = c.prepareStatement(getLines)) {
                g.setInt(1, billId);
                try (ResultSet rs = g.executeQuery()) {
                    while (rs.next()) {
                        int iid = rs.getInt("itemId");
                        if (!rs.wasNull()) {
                            int qty = rs.getInt("qty");
                            try (PreparedStatement up = c.prepareStatement(incStock)) {
                                up.setInt(1, qty);
                                up.setInt(2, iid);
                                up.executeUpdate();
                            }
                        }
                    }
                }
            }
            try (PreparedStatement d1 = c.prepareStatement(delItems)) { d1.setInt(1, billId); d1.executeUpdate(); }
            try (PreparedStatement d2 = c.prepareStatement(delBill )) { d2.setInt(1, billId); d2.executeUpdate(); }
            c.commit();
        } catch (SQLException ex) { throw ex; }
    }

    // convenience alias
    public Bill loadBill(int billId) throws SQLException { return getBill(billId); }
}
