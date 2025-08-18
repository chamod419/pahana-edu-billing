package com.pahanaedu.controller;

import com.pahanaedu.model.Customer;
import com.pahanaedu.model.User;
import com.pahanaedu.service.CustomerService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(urlPatterns = {
        "/customers",
        "/customers/new",
        "/customers/edit",
        "/customers/save",
        "/customers/delete"
})
public class CustomerController extends HttpServlet {
    private final CustomerService svc = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        switch (path) {
            case "/customers": {
                String q = trim(req.getParameter("q"));
                List<Customer> all = (q == null) ? svc.list() : svc.search(q);
                req.setAttribute("list", all);
                req.setAttribute("q", q);
                req.getRequestDispatcher("/customers/list.jsp").forward(req, resp);
                break;
            }
            case "/customers/new":
                req.setAttribute("mode", "create");
                req.getRequestDispatcher("/customers/form.jsp").forward(req, resp);
                break;

            case "/customers/edit": {
                int id = parseInt(req.getParameter("id"));
                Optional<Customer> c = svc.get(id);
                if (c.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/customers?error=Not+found");
                    return;
                }
                req.setAttribute("mode", "edit");
                req.setAttribute("c", c.get());
                req.getRequestDispatcher("/customers/form.jsp").forward(req, resp);
                break;
            }

            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String path = req.getServletPath();

        switch (path) {
            case "/customers/save": {
                Customer c = new Customer();
                c.setCustomerId(parseInt(req.getParameter("customerId")));
                c.setAccountNumber(trim(req.getParameter("accountNumber")));
                c.setName(req.getParameter("name"));
                c.setAddress(trim(req.getParameter("address")));
                c.setPhone(trim(req.getParameter("phone")));
                c.setEmail(trim(req.getParameter("email")));
                c.setStatus(trim(req.getParameter("status")));

                if (c.getName() == null || c.getName().isBlank()) {
                    req.setAttribute("error", "Name is required");
                    req.setAttribute("c", c);
                    req.setAttribute("mode", (c.getCustomerId()==0) ? "create" : "edit");
                    req.getRequestDispatcher("/customers/form.jsp").forward(req, resp);
                    return;
                }

                boolean ok = svc.save(c);
                String q = ok ? "msg=Saved" : "error=Save+failed";
                resp.sendRedirect(req.getContextPath() + "/customers?" + q);
                break;
            }

            case "/customers/delete": {
                // Allow both ADMIN and STAFF to delete (login is enforced by AuthFilter)
                // If you want Admin-only, re-enable the role check here.
                int id = parseInt(req.getParameter("id"));
                boolean ok = svc.delete(id);
                String q = ok ? "msg=Deleted" : "error=Delete+failed";
                resp.sendRedirect(req.getContextPath() + "/customers?" + q);
                break;
            }

            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private int parseInt(String s) { try { return Integer.parseInt(s); } catch (Exception e) { return 0; } }
    private String trim(String s) { return (s==null)? null : s.trim(); }
}
