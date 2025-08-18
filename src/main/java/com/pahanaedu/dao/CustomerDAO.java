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

    public boolean insert(Customer x) {
        String sql = "INSERT INTO customers(accountNumber,name,address,phone,email,status) VALUES(?,?,?,?,?,?)";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, nullIfBlank(x.getAccountNumber()));
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
            }
            return n>0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean update(Customer x) {
        String sql = "UPDATE customers SET accountNumber=?, name=?, address=?, phone=?, email=?, status=? WHERE customerId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, nullIfBlank(x.getAccountNumber()));
            ps.setString(2, x.getName());
            ps.setString(3, nullIfBlank(x.getAddress()));
            ps.setString(4, nullIfBlank(x.getPhone()));
            ps.setString(5, nullIfBlank(x.getEmail()));
            ps.setString(6, (x.getStatus()==null||x.getStatus().isBlank()) ? "ACTIVE" : x.getStatus());
            ps.setInt(7, x.getCustomerId());
            return ps.executeUpdate() > 0;
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

    // Helpers
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
}
