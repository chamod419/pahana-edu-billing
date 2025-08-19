package com.pahanaedu.dao;

import com.pahanaedu.model.Customer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CustomerDAO {

    public List<Customer> findAll() {
        String sql = "SELECT customerId,accountNumber,name,address,phone,email,status FROM customers ORDER BY customerId DESC";
        List<Customer> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return out;
    }

    public List<Customer> findActive() {
        String sql = "SELECT customerId,accountNumber,name,address,phone,email,status FROM customers WHERE status='ACTIVE' ORDER BY name";
        List<Customer> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return out;
    }

    /** Search by name OR phone OR accountNumber (case-insensitive) */
    public List<Customer> search(String q) {
        if (q == null) q = "";
        String like = "%" + q.toLowerCase().trim() + "%";
        String sql = "SELECT customerId,accountNumber,name,address,phone,email,status " +
                "FROM customers " +
                "WHERE LOWER(name) LIKE ? OR LOWER(phone) LIKE ? OR LOWER(email) LIKE ? OR LOWER(accountNumber) LIKE ? " +
                "ORDER BY customerId DESC";
        List<Customer> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return out;
    }

    public Optional<Customer> findById(int id) {
        String sql = "SELECT customerId,accountNumber,name,address,phone,email,status FROM customers WHERE customerId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return Optional.empty();
    }

    public Optional<Customer> findByAccountNumber(String acc) {
        if (acc == null || acc.isBlank()) return Optional.empty();
        String sql = "SELECT customerId,accountNumber,name,address,phone,email,status FROM customers WHERE accountNumber=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, acc.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return Optional.empty();
    }

    // --- mutations & helpers (unchanged from earlier) ---
    public boolean insert(Customer x) {
        try (Connection c = DBConnection.getInstance().getConnection()) {
            for (int attempt = 0; attempt < 3; attempt++) {
                if (x.getAccountNumber() == null || x.getAccountNumber().isBlank()) {
                    x.setAccountNumber(nextAccountNumber(c));
                }
                String sql = "INSERT INTO customers(accountNumber,name,address,phone,email,status) VALUES(?,?,?,?,?,?)";
                try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, x.getAccountNumber());
                    ps.setString(2, x.getName());
                    ps.setString(3, nullIfBlank(x.getAddress()));
                    ps.setString(4, nullIfBlank(x.getPhone()));
                    ps.setString(5, nullIfBlank(x.getEmail()));
                    ps.setString(6, (x.getStatus()==null||x.getStatus().isBlank()) ? "ACTIVE" : x.getStatus());
                    int n = ps.executeUpdate();
                    if (n>0) {
                        try (ResultSet keys = ps.getGeneratedKeys()) {
                            if (keys.next()) x.setCustomerId(keys.getInt(1));
                        }
                        return true;
                    }
                } catch (SQLException e) {
                    if ("23000".equals(e.getSQLState())) { x.setAccountNumber(null); continue; }
                    e.printStackTrace(); return false;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); return false; }
        return false;
    }

    public boolean update(Customer x) {
        if (x.getAccountNumber() == null || x.getAccountNumber().isBlank()) {
            try (Connection c = DBConnection.getInstance().getConnection()) {
                x.setAccountNumber(nextAccountNumber(c));
            } catch (SQLException e) { e.printStackTrace(); return false; }
        }
        String sql = "UPDATE customers SET accountNumber=?, name=?, address=?, phone=?, email=?, status=? WHERE customerId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, x.getAccountNumber());
            ps.setString(2, x.getName());
            ps.setString(3, nullIfBlank(x.getAddress()));
            ps.setString(4, nullIfBlank(x.getPhone()));
            ps.setString(5, nullIfBlank(x.getEmail()));
            ps.setString(6, (x.getStatus()==null||x.getStatus().isBlank()) ? "ACTIVE" : x.getStatus());
            ps.setInt(7, x.getCustomerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteSafe(int id) {
        try (Connection c = DBConnection.getInstance().getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement p1 = c.prepareStatement("UPDATE bills SET customerId=NULL WHERE customerId=?");
                 PreparedStatement p2 = c.prepareStatement("DELETE FROM customers WHERE customerId=?")) {
                p1.setInt(1, id); p1.executeUpdate();
                p2.setInt(1, id);
                int n = p2.executeUpdate();
                c.commit();
                return n > 0;
            } catch (SQLException ex) {
                c.rollback(); ex.printStackTrace(); return false;
            } finally { c.setAutoCommit(true); }
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM customers WHERE customerId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int countUsageInBills(int customerId) {
        String sql = "SELECT COUNT(*) FROM bills WHERE customerId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Customer map(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setCustomerId(rs.getInt("customerId"));
        c.setAccountNumber(rs.getString("accountNumber"));
        c.setName(rs.getString("name"));
        c.setAddress(rs.getString("address"));
        c.setPhone(rs.getString("phone"));
        c.setEmail(rs.getString("email"));
        c.setStatus(rs.getString("status"));
        return c;
    }

    private String nullIfBlank(String s) { return (s==null || s.isBlank()) ? null : s; }

    private String nextAccountNumber(Connection c) throws SQLException {
        String sql = "SELECT LPAD(COALESCE(MAX(CAST(SUBSTRING(accountNumber,3) AS UNSIGNED)),0) + 1, 4, '0') AS nxt " +
                     "FROM customers WHERE accountNumber LIKE 'C-%'";
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return "C-" + rs.getString("nxt");
        }
        return "C-0001";
    }
}
