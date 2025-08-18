package com.pahanaedu.dao;

import com.pahanaedu.model.User;

import java.sql.*;
import java.util.Optional;

public class UserDAO {

    public Optional<User> findByCredentials(String username, String password) {
        String sql = "SELECT userId, username, userRole FROM users WHERE username=? AND password=?";
        try (Connection con = DBConnection.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("userId"));
                    u.setUsername(rs.getString("username"));
                    u.setRole(rs.getString("userRole"));
                    return Optional.of(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }
}