package com.pahanaedu.service;

import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;

import java.util.Optional;

public class AuthService {
    private final UserDAO userDAO = new UserDAO();

    public Optional<User> login(String username, String password) {
        // If later using BCrypt, fetch by username then check hash here.
        return userDAO.findByCredentials(username, password);
    }
}