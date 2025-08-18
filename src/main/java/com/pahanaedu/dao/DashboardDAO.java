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

    public int getTodayBillsCount() {
        String sql = "SELECT COUNT(*) FROM bills WHERE DATE(billDate) = CURDATE()";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) { e.printStackTrace(); return 0; }
    }

    public double getTodayRevenue() {
        String sql = "SELECT COALESCE(SUM(netTotal),0) FROM bills WHERE DATE(billDate) = CURDATE()";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        } catch (SQLException e) { e.printStackTrace(); return 0.0; }
    }

    // --- Staff-scoped ---
    public int getTodayBillsCountByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM bills WHERE createdBy = ? AND DATE(billDate) = CURDATE()";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) { e.printStackTrace(); return 0; }
    }

    public double getTodayRevenueByUser(int userId) {
        String sql = "SELECT COALESCE(SUM(netTotal),0) FROM bills WHERE createdBy = ? AND DATE(billDate) = CURDATE()";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0.0;
            }
        } catch (SQLException e) { e.printStackTrace(); return 0.0; }
    }
}
