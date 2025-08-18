package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.DashboardService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {
    private final DashboardService svc = new DashboardService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User u = (s == null) ? null : (User) s.getAttribute("user");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("ADMIN".equals(u.getRole())) {
            req.setAttribute("totalCustomers", svc.totalCustomers());
            req.setAttribute("activeItems", svc.activeItems());
            req.setAttribute("todayBills", svc.todayBills());
            req.setAttribute("todayRevenue", svc.todayRevenue());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        } else {
            req.setAttribute("todayBills", svc.todayBillsByUser(u.getUserId()));
            req.setAttribute("todayRevenue", svc.todayRevenueByUser(u.getUserId()));
            req.getRequestDispatcher("/staff/dashboard.jsp").forward(req, resp);
        }
    }
}
