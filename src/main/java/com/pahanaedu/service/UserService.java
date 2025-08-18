package com.pahanaedu.service;

import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;

import java.util.List;
import java.util.Optional;

public class UserService {
    private final UserDAO dao = new UserDAO();

    public List<User> list() { return dao.findAll(); }
    public Optional<User> get(int id) { return dao.findById(id); }

    public boolean create(String username, String password, String role) {
        return dao.create(username, password, role);
    }
    public boolean update(int id, String username, String role) {
        return dao.update(id, username, role);
    }
    public boolean resetPassword(int id, String newPassword) {
        return dao.resetPassword(id, newPassword);
    }

    public DeleteResult deleteSafe(int id) {
        int uses = dao.countUsageInBills(id);
        if (uses > 0) return DeleteResult.IN_USE;
        if (uses < 0) return DeleteResult.ERROR;
        return dao.delete(id) ? DeleteResult.OK : DeleteResult.ERROR;
    }
}
