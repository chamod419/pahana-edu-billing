package com.pahanaedu.controller;

import com.pahanaedu.dao.ItemDAO;
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

@WebServlet(urlPatterns = {
        "/billing",            // GET screen
        "/billing/start",      // POST start new bill (optional)
        "/billing/add",        // POST add item
        "/billing/remove",     // POST remove line
        "/billing/finalize",   // POST finalize (discount/method)
        "/billing/cancel"      // POST cancel draft
})
public class BillingController extends HttpServlet {
    private final BillingService svc = new BillingService();
    private final ItemDAO itemDAO = new ItemDAO(); // for dropdown

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/billing".equals(path)) {
            show(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
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
            List<Item> active = itemDAO.findActive(); // dropdown
            req.setAttribute("bill", b);
            req.setAttribute("activeItems", active);
            req.getRequestDispatcher("/staff/billing.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String path = req.getServletPath();
        HttpSession s = req.getSession(true);
        Integer billId = (Integer) s.getAttribute("draftBillId");
        if (billId == null) {
            resp.sendRedirect(req.getContextPath()+"/billing"); return;
        }

        try {
            switch (path) {
                case "/billing/add": {
                    int itemId = parseInt(req.getParameter("itemId"));
                    int qty = Math.max(1, parseInt(req.getParameter("qty")));
                    try {
                        svc.addItem(billId, itemId, qty);
                        resp.sendRedirect(req.getContextPath()+"/billing?msg=Added");
                    } catch (SQLException ex) {
                        resp.sendRedirect(req.getContextPath()+"/billing?error=" +
                                url(ex.getMessage()));
                    }
                    break;
                }
                case "/billing/remove": {
                    int billItemId = parseInt(req.getParameter("billItemId"));
                    svc.removeLine(billItemId, billId);
                    resp.sendRedirect(req.getContextPath()+"/billing?msg=Removed");
                    break;
                }
                case "/billing/finalize": {
                    double discount = parseDouble(req.getParameter("discountAmt"));
                    String method = trim(req.getParameter("paymentMethod"));
                    svc.finalizeBill(billId, discount, method);
                    // clear draft
                    s.removeAttribute("draftBillId");
                    resp.sendRedirect(req.getContextPath()+"/dashboard?msg=Bill+saved");
                    break;
                }
                case "/billing/cancel": {
                    svc.cancel(billId);
                    s.removeAttribute("draftBillId");
                    resp.sendRedirect(req.getContextPath()+"/dashboard?msg=Bill+cancelled");
                    break;
                }
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // helpers
    private int parseInt(String s){ try { return Integer.parseInt(s); } catch(Exception e){ return 0; } }
    private double parseDouble(String s){ try { return Double.parseDouble(s); } catch(Exception e){ return 0; } }
    private String trim(String s){ return (s==null)? null : s.trim(); }
    private String url(String s){ return java.net.URLEncoder.encode(s==null?"":s, java.nio.charset.StandardCharsets.UTF_8); }
}
