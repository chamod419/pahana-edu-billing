package com.pahanaedu.controller;

import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.model.Customer;
import com.pahanaedu.model.Item;
import com.pahanaedu.model.User;
import com.pahanaedu.model.Bill;
import com.pahanaedu.service.BillingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@WebServlet(urlPatterns = {
        "/billing",           // screen
        "/billing/new",       // start fresh draft
        "/billing/start",     // alias of /billing/new
        "/billing/add",
        "/billing/remove",
        "/billing/updateQty",
        "/billing/setCustomer",
        "/billing/setNotes",
        "/billing/finalize",
        "/billing/cancel"
})
public class BillingController extends HttpServlet {

    private final BillingService svc = new BillingService();
    private final ItemDAO itemDAO = new ItemDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    // ---------- GET ----------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        switch (path) {
            case "/billing":
                show(req, resp);
                return;
            case "/billing/new":
            case "/billing/start":
                startNew(req, resp);
                return;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /** Start a brand-new draft bill and go to /billing */
    private void startNew(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        HttpSession s = req.getSession(false);
        User u = (s == null) ? null : (User) s.getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        try {
            int billId = svc.startBill(null, u.getUserId());
            req.getSession(true).setAttribute("draftBillId", billId);
            resp.sendRedirect(req.getContextPath() + "/billing?msg=New+bill");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void show(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User u = (s==null) ? null : (User) s.getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        Integer billId = (Integer) ((s!=null)? s.getAttribute("draftBillId") : null);

        try {
            if (billId == null) {
                billId = svc.startBill(null, u.getUserId());
                req.getSession(true).setAttribute("draftBillId", billId);
            }
            Bill b = svc.get(billId);

            // Load current customer details (to show on JSP)
            Customer current = null;
            if (b != null && b.getCustomerId() != null) {
                current = customerDAO.findById(b.getCustomerId()).orElse(null);
            }

            List<Item> active = itemDAO.findActive();
            req.setAttribute("bill", b);
            req.setAttribute("customer", current);
            req.setAttribute("activeItems", active);
            req.getRequestDispatcher("/staff/billing.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // ---------- POST ----------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String path = req.getServletPath();
        HttpSession s = req.getSession(false);
        if (s == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        Integer billId = (Integer) s.getAttribute("draftBillId");
        if (billId == null) { resp.sendRedirect(req.getContextPath()+"/billing"); return; }

        try {
            switch (path) {
                case "/billing/add": {
                    int itemId = parseInt(req.getParameter("itemId"));
                    int qty = Math.max(1, parseInt(req.getParameter("qty")));
                    try {
                        svc.addItem(billId, itemId, qty);
                        resp.sendRedirect(req.getContextPath()+"/billing?msg=Added");
                    } catch (SQLException ex) {
                        resp.sendRedirect(req.getContextPath()+"/billing?error="+url(ex.getMessage()));
                    }
                    return;
                }
                case "/billing/remove": {
                    int billItemId = parseInt(req.getParameter("billItemId"));
                    svc.removeLine(billItemId, billId);
                    resp.sendRedirect(req.getContextPath()+"/billing?msg=Removed");
                    return;
                }
                case "/billing/updateQty": {
                    int billItemId = parseInt(req.getParameter("billItemId"));
                    int qty = Math.max(1, parseInt(req.getParameter("qty")));
                    try {
                        svc.updateQty(billItemId, qty, billId);
                        resp.sendRedirect(req.getContextPath()+"/billing?msg=Updated");
                    } catch (SQLException ex) {
                        resp.sendRedirect(req.getContextPath()+"/billing?error="+url(ex.getMessage()));
                    }
                    return;
                }
                case "/billing/setCustomer": {
                    String acc = trim(req.getParameter("accountNumber"));
                    String clear = req.getParameter("clear");
                    Integer customerId = null;
                    if (clear == null) {
                        Optional<Customer> cx = customerDAO.findByAccountNumber(acc);
                        if (cx.isEmpty()) {
                            resp.sendRedirect(req.getContextPath()+"/billing?error="+url("Customer not found"));
                            return;
                        }
                        customerId = cx.get().getCustomerId();
                    }
                    svc.setCustomer(billId, customerId);
                    resp.sendRedirect(req.getContextPath()+"/billing?msg=Customer+set");
                    return;
                }
                case "/billing/setNotes": {
                    String notes = req.getParameter("notes");
                    svc.setNotes(billId, notes);
                    resp.sendRedirect(req.getContextPath()+"/billing?msg=Notes+saved");
                    return;
                }
                case "/billing/finalize": {
                    double discount = parseDouble(req.getParameter("discountAmt"));
                    String method = trim(req.getParameter("paymentMethod"));
                    svc.finalizeBill(billId, discount, method);
                    s.removeAttribute("draftBillId");
                    resp.sendRedirect(req.getContextPath()+"/dashboard?msg=Bill+saved");
                    return;
                }
                case "/billing/cancel": {
                    svc.cancel(billId);
                    s.removeAttribute("draftBillId");
                    resp.sendRedirect(req.getContextPath()+"/dashboard?msg=Bill+cancelled");
                    return;
                }
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // ---------- helpers ----------
    private int parseInt(String s){ try { return Integer.parseInt(s); } catch(Exception e){ return 0; } }
    private double parseDouble(String s){ try { return Double.parseDouble(s); } catch(Exception e){ return 0; } }
    private String trim(String s){ return (s==null)? null : s.trim(); }
    private String url(String s){
        return java.net.URLEncoder.encode(s==null?"":s, java.nio.charset.StandardCharsets.UTF_8);
    }
}
