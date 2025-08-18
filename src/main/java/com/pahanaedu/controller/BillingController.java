package com.pahanaedu.controller;

import com.pahanaedu.model.Bill;
import com.pahanaedu.model.User;
import com.pahanaedu.service.BillingService;
import com.pahanaedu.service.CustomerService;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@WebServlet(urlPatterns = {
        "/billing/new",
        "/billing/add",
        "/billing/update",
        "/billing/remove",
        "/billing/discount",   // expects discountPct
        "/billing/save",
        "/billing/receipt"
})
public class BillingController extends HttpServlet {

    private final BillingService billing = new BillingService();
    private final CustomerService customers = new CustomerService();
    private final ItemDAO itemDAO = new ItemDAO();

    private Bill getCart(HttpServletRequest req, int userId) {
        HttpSession s = req.getSession(true);
        Bill cart = (Bill) s.getAttribute("billCart");
        cart = billing.ensureCart(cart, userId);
        s.setAttribute("billCart", cart);
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        HttpSession s = req.getSession(false);
        User u = (s==null) ? null : (User) s.getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        switch (path) {
            case "/billing/new": {
                req.setAttribute("customers", customers.list());

                String q = trim(req.getParameter("q"));
                if (q != null && !q.isBlank()) {
                    List<Item> search = itemDAO.findAll().stream()
                            .filter(it -> it.getName() != null && it.getName().toLowerCase().contains(q.toLowerCase()))
                            .limit(20).toList();
                    req.setAttribute("search", search);
                    req.setAttribute("q", q);
                }

                Bill cart = getCart(req, u.getUserId());
                req.setAttribute("cart", cart);
                req.getRequestDispatcher("/billing/new.jsp").forward(req, resp);
                break;
            }

            case "/billing/receipt": {
                String idStr = req.getParameter("id");
                if (idStr == null) { resp.sendError(400); return; }
                int billId = parseInt(idStr);
                Optional<com.pahanaedu.model.Bill> loaded =
                        new com.pahanaedu.dao.BillingDAO().loadBill(billId);
                if (loaded.isEmpty()) { resp.sendError(404); return; }
                req.setAttribute("bill", loaded.get());
                req.setAttribute("customer", customers.get(loaded.get().getCustomerId()).orElse(null));
                req.getRequestDispatcher("/billing/receipt.jsp").forward(req, resp);
                break;
            }

            default: resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String path = req.getServletPath();
        HttpSession s = req.getSession(false);
        User u = (s==null) ? null : (User) s.getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        Bill cart = getCart(req, u.getUserId());

        switch (path) {
            case "/billing/add": {
                int itemId = parseInt(req.getParameter("itemId"));
                int qty    = parseInt(req.getParameter("qty"));
                String err = billing.addItem(cart, itemId, qty);
                redirectBack(req, resp, err);
                break;
            }
            case "/billing/update": {
                int itemId = parseInt(req.getParameter("itemId"));
                int qty    = parseInt(req.getParameter("qty"));
                String err = billing.updateQty(cart, itemId, qty);
                redirectBack(req, resp, err);
                break;
            }
            case "/billing/remove": {
                int itemId = parseInt(req.getParameter("itemId"));
                billing.removeItem(cart, itemId);
                redirectBack(req, resp, null);
                break;
            }
            case "/billing/discount": {
                double pct = parseDouble(req.getParameter("discountPct"));
                if (pct < 0) pct = 0;
                if (pct > 100) pct = 100;
                billing.applyDiscount(cart, pct);
                redirectBack(req, resp, null);
                break;
            }
            case "/billing/save": {
                int customerId = parseInt(req.getParameter("customerId"));
                String notes   = trim(req.getParameter("notes"));
                boolean decreaseStock = "on".equals(req.getParameter("decreaseStock"));

                if (cart.getItems().isEmpty()) { redirectBack(req, resp, "No items in bill"); return; }
                if (customerId <= 0) { redirectBack(req, resp, "Please select a customer"); return; }

                try {
                    int billId = billing.save(cart, customerId, u.getUserId(), notes, decreaseStock);
                    req.getSession().removeAttribute("billCart");
                    resp.sendRedirect(req.getContextPath()+"/billing/receipt?id="+billId);
                } catch (SQLException e) {
                    e.printStackTrace();
                    redirectBack(req, resp, "Saving bill failed");
                }
                break;
            }
            default: resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // helpers
    private String trim(String s){ return (s==null)? null : s.trim(); }
    private int parseInt(String s){ try { return Integer.parseInt(s); } catch(Exception e){ return 0; } }
    private double parseDouble(String s){ try { return Double.parseDouble(s); } catch(Exception e){ return 0; } }

    private void redirectBack(HttpServletRequest req, HttpServletResponse resp, String err) throws IOException {
        String base = req.getContextPath()+"/billing/new";
        if (err != null) base += "?error="+java.net.URLEncoder.encode(err, java.nio.charset.StandardCharsets.UTF_8);
        resp.sendRedirect(base);
    }
}
