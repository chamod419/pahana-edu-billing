package com.pahanaedu.dao;

import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillingDAO {

    // -------------------- Bill create / draft --------------------
    public int createDraft(Integer customerId, int createdBy) throws SQLException {
        final String nextNoSql =
                "SELECT LPAD(IFNULL(MAX(billId)+1,1),5,'0') FROM bills";
        final String insertSql =
                "INSERT INTO bills (billNo, billDate, customerId, createdBy, subTotal, discountAmt, netTotal, paidAmount, paymentMethod) " +
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
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    /** Optional helper to change the draft's customer (null allowed). */
    public void setCustomer(int billId, Integer customerId) throws SQLException {
        final String sql = "UPDATE bills SET customerId=? WHERE billId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (customerId == null) ps.setNull(1, Types.INTEGER); else ps.setInt(1, customerId);
            ps.setInt(2, billId);
            ps.executeUpdate();
        }
    }

    // -------------------- Items on a bill --------------------
    public void addLine(int billId, int itemId, int qty) throws SQLException {
        // Friendly guards before triggers run
        final String check = "SELECT isActive, stockQty, name FROM items WHERE itemId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement cp = c.prepareStatement(check)) {
            cp.setInt(1, itemId);
            try (ResultSet rs = cp.executeQuery()) {
                if (!rs.next()) throw new SQLException("Item not found");
                boolean active = rs.getBoolean("isActive");
                int stock = rs.getInt("stockQty");
                String nm = rs.getString("name");
                if (!active) throw new SQLException("Item '" + nm + "' is INACTIVE");
                if (qty <= 0) throw new SQLException("Quantity must be > 0");
                if (stock < qty) throw new SQLException("Not enough stock for '" + nm + "'");
            }
        }

        // Triggers fill itemName/unitPrice, compute lineTotal, and adjust stock
        final String ins = "INSERT INTO bill_items (billId, itemId, qty) VALUES (?,?,?)";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(ins)) {
            ps.setInt(1, billId);
            ps.setInt(2, itemId);
            ps.setInt(3, qty);
            ps.executeUpdate();
        }
    }

    public void removeLine(int billItemId) throws SQLException {
        // Stock is restored via AFTER DELETE trigger
        final String del = "DELETE FROM bill_items WHERE billItemId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(del)) {
            ps.setInt(1, billItemId);
            ps.executeUpdate();
        }
    }

    public List<BillItem> listLines(int billId) throws SQLException {
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

    // -------------------- Totals / finalize --------------------
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

    public Bill getBill(int billId) throws SQLException {
        final String sql = "SELECT billId,billNo,billDate,customerId,createdBy,subTotal,discountAmt,netTotal,paidAmount,paymentMethod " +
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
                    b.setItems(listLines(billId));
                    return b;
                }
            }
        }
        return null;
    }

    /** Alias required by some controllers/utilities that call loadBill(...). */
    public Bill loadBill(int billId) throws SQLException {
        return getBill(billId);
    }

    public void cancelBill(int billId) throws SQLException {
        try (Connection c = DBConnection.getInstance().getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement p1 = c.prepareStatement("DELETE FROM bill_items WHERE billId=?");
                 PreparedStatement p2 = c.prepareStatement("DELETE FROM bills WHERE billId=?")) {
                p1.setInt(1, billId); p1.executeUpdate();
                p2.setInt(1, billId); p2.executeUpdate();
                c.commit();
            } catch (SQLException ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }
}
