package com.pahanaedu.dao;

import com.pahanaedu.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserDAO {

    // ---- Login: bcrypt + plain fallback ----
    public Optional<User> findByCredentials(String username, String password) {
        String sql = "SELECT userId, username, userRole, password FROM users WHERE username=?";
        try (Connection con = DBConnection.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String stored = rs.getString("password");
                    boolean ok;
                    if (stored != null && stored.startsWith("$2a$")) {
                        ok = BCrypt.checkpw(password, stored);
                    } else {
                        ok = stored != null && stored.equals(password);
                    }
                    if (ok) {
                        User u = new User();
                        u.setUserId(rs.getInt("userId"));
                        u.setUsername(rs.getString("username"));
                        u.setRole(rs.getString("userRole"));
                        return Optional.of(u);
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return Optional.empty();
    }

    // ---- Admin: list / read ----
    public List<User> findAll() {
        String sql = "SELECT userId, username, userRole FROM users ORDER BY userId DESC";
        List<User> out = new ArrayList<>();
        try (Connection con = DBConnection.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setUsername(rs.getString("username"));
                u.setRole(rs.getString("userRole"));
                out.add(u);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return out;
    }

    public Optional<User> findById(int id) {
        String sql = "SELECT userId, username, userRole FROM users WHERE userId=?";
        try (Connection con = DBConnection.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("userId"));
                    u.setUsername(rs.getString("username"));
                    u.setRole(rs.getString("userRole"));
                    return Optional.of(u);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return Optional.empty();
    }

    // ---- Admin: create / update / reset ----
    public boolean create(String username, String rawPassword, String role) {
        String hash = BCrypt.hashpw(rawPassword, BCrypt.gensalt());
        String sql = "INSERT INTO users(username, password, userRole) VALUES (?,?,?)";
        try (Connection con = DBConnection.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, hash);
            ps.setString(3, role);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean update(int userId, String username, String role) {
        String sql = "UPDATE users SET username=?, userRole=? WHERE userId=?";
        try (Connection con = DBConnection.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, role);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean resetPassword(int userId, String rawPassword) {
        String hash = BCrypt.hashpw(rawPassword, BCrypt.gensalt());
        String sql = "UPDATE users SET password=? WHERE userId=?";
        try (Connection con = DBConnection.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, hash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ---- Admin: delete (safe) ----
    public int countUsageInBills(int userId) {
        String sql = "SELECT COUNT(*) FROM bills WHERE createdBy = ?";
        try (Connection con = DBConnection.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) { e.printStackTrace(); return -1; }
    }

    public boolean delete(int userId) {
        String sql = "DELETE FROM users WHERE userId=?";
        try (Connection con = DBConnection.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // FK violation => returns false (handled in service/controller)
            return false;
        }
    }
}
