package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.DeleteResult;
import com.pahanaedu.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(urlPatterns = {
        "/admin/users", "/admin/users/new", "/admin/users/edit",
        "/admin/users/save", "/admin/users/delete"
})
public class UserAdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService svc = new UserService();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/admin/users": {
                List<User> list = svc.list();
                req.setAttribute("list", list);
                req.getRequestDispatcher("/admin/users/list.jsp").forward(req, resp);
                break;
            }
            case "/admin/users/new": {
                req.setAttribute("mode", "create");
                req.getRequestDispatcher("/admin/users/form.jsp").forward(req, resp);
                break;
            }
            case "/admin/users/edit": {
                int id = parseInt(req.getParameter("id"));
                Optional<User> u = svc.get(id);
                if (u.isEmpty()) {
                    resp.sendRedirect(req.getContextPath()+"/admin/users?error=Not+found");
                    return;
                }
                req.setAttribute("mode", "edit");
                req.setAttribute("u", u.get());
                req.getRequestDispatcher("/admin/users/form.jsp").forward(req, resp);
                break;
            }
            default: resp.sendError(404);
        }
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String path = req.getServletPath();
        switch (path) {
            case "/admin/users/save": {
                int id = parseInt(req.getParameter("userId"));
                String username = trim(req.getParameter("username"));
                String role = trim(req.getParameter("role"));
                String pwd = trim(req.getParameter("password"));
                String confirm = trim(req.getParameter("confirm"));

                if (username==null || username.isBlank() || role==null || role.isBlank()) {
                    req.setAttribute("error", "Username and role are required");
                    req.setAttribute("mode", (id==0?"create":"edit"));
                    req.setAttribute("u", bindUser(id, username, role));
                    req.getRequestDispatcher("/admin/users/form.jsp").forward(req, resp);
                    return;
                }

                boolean ok;
                if (id == 0) {
                    if (pwd==null || pwd.isBlank() || !pwd.equals(confirm)) {
                        req.setAttribute("error", "Password & confirm required and must match");
                        req.setAttribute("mode", "create");
                        req.setAttribute("u", bindUser(0, username, role));
                        req.getRequestDispatcher("/admin/users/form.jsp").forward(req, resp);
                        return;
                    }
                    ok = svc.create(username, pwd, role);
                } else {
                    ok = svc.update(id, username, role);
                    // Optional reset at the same time:
                    if (ok && pwd != null && !pwd.isBlank()) {
                        if (!pwd.equals(confirm)) {
                            resp.sendRedirect(req.getContextPath()+"/admin/users/edit?id="+id+"&error=Password+mismatch");
                            return;
                        }
                        ok = svc.resetPassword(id, pwd);
                    }
                }
                resp.sendRedirect(req.getContextPath()+"/admin/users?"+(ok?"msg=Saved":"error=Save+failed"));
                break;
            }

            case "/admin/users/delete": {
                int id = parseInt(req.getParameter("id"));

                // Prevent self-delete
                HttpSession s = req.getSession(false);
                User me = (s==null) ? null : (User) s.getAttribute("user");
                if (me != null && me.getUserId() == id) {
                    resp.sendRedirect(req.getContextPath()+"/admin/users?error=Cannot+delete+your+own+account");
                    return;
                }

                DeleteResult r = svc.deleteSafe(id);
                String q = (r==DeleteResult.OK) ? "msg=Deleted"
                        : (r==DeleteResult.IN_USE) ? "error=Cannot+delete:+user+has+bills"
                        : "error=Delete+failed";
                resp.sendRedirect(req.getContextPath()+"/admin/users?"+q);
                break;
            }

            default: resp.sendError(404);
        }
    }

    // helpers
    private int parseInt(String s){ try { return Integer.parseInt(s);} catch(Exception e){ return 0; } }
    private String trim(String s){ return (s==null)? null : s.trim(); }
    private User bindUser(int id, String username, String role){
        User u = new User();
        u.setUserId(id);
        u.setUsername(username);
        u.setRole(role);
        return u;
    }
}
