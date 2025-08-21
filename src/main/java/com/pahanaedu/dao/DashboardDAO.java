package com.pahanaedu.dao;

import java.sql.*;

public class DashboardDAO {

    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM customers";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) { e.printStackTrace(); return 0; }
    }

    public int getActiveItems() {
        String sql = "SELECT COUNT(*) FROM items WHERE isActive = TRUE";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) { e.printStackTrace(); return 0; }
    }

    // -------- Admin scope (all users) --------
    public int getTodayBillsCount() {
        String sql = """
            SELECT COUNT(*)
            FROM bills b
            WHERE DATE(b.billDate) = CURDATE()
              AND EXISTS (SELECT 1 FROM bill_items bi WHERE bi.billId = b.billId)
            """;
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) { e.printStackTrace(); return 0; }
    }

    public double getTodayRevenue() {
        String sql = """
            SELECT COALESCE(SUM(b.netTotal),0)
            FROM bills b
            WHERE DATE(b.billDate) = CURDATE()
              AND EXISTS (SELECT 1 FROM bill_items bi WHERE bi.billId = b.billId)
            """;
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        } catch (SQLException e) { e.printStackTrace(); return 0.0; }
    }

    // -------- Staff scope (by createdBy) --------
    public int getTodayBillsCountByUser(int userId) {
        String sql = """
            SELECT COUNT(*)
            FROM bills b
            WHERE b.createdBy = ?
              AND DATE(b.billDate) = CURDATE()
              AND EXISTS (SELECT 1 FROM bill_items bi WHERE bi.billId = b.billId)
            """;
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) { e.printStackTrace(); return 0; }
    }

    public double getTodayRevenueByUser(int userId) {
        String sql = """
            SELECT COALESCE(SUM(b.netTotal),0)
            FROM bills b
            WHERE b.createdBy = ?
              AND DATE(b.billDate) = CURDATE()
              AND EXISTS (SELECT 1 FROM bill_items bi WHERE bi.billId = b.billId)
            """;
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0.0;
            }
        } catch (SQLException e) { e.printStackTrace(); return 0.0; }
    }

    /** Distinct non-null customers served today by this staff member. */
    public int getTodayCustomersServedByUser(int userId) {
        String sql = """
            SELECT COUNT(DISTINCT b.customerId)
            FROM bills b
            WHERE b.createdBy = ?
              AND b.customerId IS NOT NULL
              AND DATE(b.billDate) = CURDATE()
              AND EXISTS (SELECT 1 FROM bill_items bi WHERE bi.billId = b.billId)
            """;
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) { e.printStackTrace(); return 0; }
    }
}
