package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "AuthController", urlPatterns = {"/login"})
public class AuthController extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if ("logout".equals(req.getParameter("action"))) {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=Logged+out");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String next = req.getParameter("next"); // may be null

        Optional<User> user = authService.login(username, password);

        if (user.isPresent()) {
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user.get());
            session.setMaxInactiveInterval(30 * 60);

            if (next != null && !next.isBlank()) {
                resp.sendRedirect(req.getContextPath() + next);
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } else {
            req.setAttribute("error", "Invalid username or password");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}