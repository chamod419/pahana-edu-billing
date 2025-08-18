package com.pahanaedu.dao;

import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;

import java.sql.*;
import java.util.Optional;

public class BillingDAO {

    public int insertBill(Bill bill) throws SQLException {
        String sql = "INSERT INTO bills(customerId, createdBy, billDate, grossTotal, discount, netTotal, notes) " +
                     "VALUES (?, ?, NOW(), ?, ?, ?, ?)";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bill.getCustomerId());
            ps.setInt(2, bill.getCreatedBy());
            ps.setDouble(3, bill.getGrossTotal());
            ps.setDouble(4, bill.getDiscount());
            ps.setDouble(5, bill.getNetTotal());
            ps.setString(6, bill.getNotes());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return 0;
    }

    public void insertBillItem(int billId, BillItem bi) throws SQLException {
        String sql = "INSERT INTO bill_items(billId, itemId, qty, unitPrice, lineDiscount, subTotal) " +
                     "VALUES(?,?,?,?,?,?)";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, billId);
            ps.setInt(2, bi.getItemId());
            ps.setInt(3, bi.getQty());
            ps.setDouble(4, bi.getUnitPrice());
            ps.setDouble(5, bi.getLineDiscount());
            ps.setDouble(6, bi.getSubTotal());
            ps.executeUpdate();
        }
    }

    // Optional: adjust stock on save
    public void decreaseStock(int itemId, int qty) throws SQLException {
        String sql = "UPDATE items SET stockQty = stockQty - ? WHERE itemId = ? AND stockQty >= ?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, qty);
            ps.setInt(2, itemId);
            ps.setInt(3, qty);
            ps.executeUpdate();
        }
    }

    // Load bill for receipt (simple join)
    public Optional<Bill> loadBill(int billId) {
        String billSql = "SELECT billId, customerId, createdBy, grossTotal, discount, netTotal, notes " +
                         "FROM bills WHERE billId=?";
        String itemsSql = "SELECT bi.itemId, i.name, bi.qty, bi.unitPrice, bi.lineDiscount, bi.subTotal " +
                          "FROM bill_items bi JOIN items i ON i.itemId = bi.itemId WHERE bi.billId=?";

        Bill b = null;
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps1 = c.prepareStatement(billSql)) {
            ps1.setInt(1, billId);
            try (ResultSet rs = ps1.executeQuery()) {
                if (rs.next()) {
                    b = new Bill();
                    b.setBillId(rs.getInt("billId"));
                    b.setCustomerId(rs.getInt("customerId"));
                    b.setCreatedBy(rs.getInt("createdBy"));
                    b.setGrossTotal(rs.getDouble("grossTotal"));
                    b.setDiscount(rs.getDouble("discount"));
                    b.setNetTotal(rs.getDouble("netTotal"));
                    b.setNotes(rs.getString("notes"));
                }
            }
            if (b == null) return Optional.empty();

            try (PreparedStatement ps2 = c.prepareStatement(itemsSql)) {
                ps2.setInt(1, billId);
                try (ResultSet rs2 = ps2.executeQuery()) {
                    while (rs2.next()) {
                        BillItem it = new BillItem();
                        it.setItemId(rs2.getInt(1));
                        it.setItemName(rs2.getString(2));
                        it.setQty(rs2.getInt(3));
                        it.setUnitPrice(rs2.getDouble(4));
                        it.setLineDiscount(rs2.getDouble(5));
                        it.setSubTotal(rs2.getDouble(6));
                        b.getItems().add(it);
                    }
                }
            }
            return Optional.of(b);
        } catch (SQLException e) { e.printStackTrace(); return Optional.empty(); }
    }
}
