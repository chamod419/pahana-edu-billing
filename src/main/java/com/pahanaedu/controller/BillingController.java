package com.pahanaedu.controller;

import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.model.Customer;
import com.pahanaedu.model.Item;
import com.pahanaedu.model.User;
import com.pahanaedu.model.Bill;
import com.pahanaedu.service.BillingService;
import com.pahanaedu.util.PdfReceiptUtil;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.printing.PDFPageable;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.nio.file.*;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;
import java.awt.print.PrinterJob;

@WebServlet(urlPatterns = {
        "/billing",
        "/billing/new",
        "/billing/start",
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

    private void startNew(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        HttpSession s = req.getSession(false);
        User u = (s == null) ? null : (User) s.getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        try {
            int billId = svc.startBill(null, u.getUserId());
            req.getSession(true).setAttribute("draftBillId", billId);
            resp.sendRedirect(req.getContextPath() + "/billing?msg=New+bill");
        } catch (SQLException e) { throw new ServletException(e); }
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

            Customer current = null;
            if (b != null && b.getCustomerId() != null) {
                current = customerDAO.findById(b.getCustomerId()).orElse(null);
            }

            // optional: quick search for customers (name/phone/account/email)
            String q = trim(req.getParameter("q"));
            if (q != null && q.length() >= 2) {
                req.setAttribute("matches", customerDAO.search(q));
                req.setAttribute("searchQ", q);
            }

            List<Item> active = itemDAO.findActive();
            req.setAttribute("bill", b);
            req.setAttribute("customer", current);
            req.setAttribute("activeItems", active);
            req.getRequestDispatcher("/staff/billing.jsp").forward(req, resp);
        } catch (SQLException e) { throw new ServletException(e); }
    }

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
                    Integer customerId = null;
                    int cid = parseInt(req.getParameter("customerId"));
                    if (cid > 0) {
                        customerId = cid;
                    } else {
                        String acc = trim(req.getParameter("accountNumber"));
                        if (acc != null && !acc.isBlank()) {
                            Optional<Customer> cx = customerDAO.findByAccountNumber(acc);
                            if (cx.isEmpty()) {
                                resp.sendRedirect(req.getContextPath()+"/billing?error="+url("Customer not found"));
                                return;
                            }
                            customerId = cx.get().getCustomerId();
                        }
                    }
                    if (req.getParameter("clear") != null) customerId = null;

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
                    // --- NEW: amount vs percentage discount handling ---
                    Bill current = svc.get(billId);
                    double subtotal = (current != null) ? current.getSubTotal() : 0.0;

                    String mode = trim(req.getParameter("discountMode")); // "AMT" or "PCT"
                    double amtInput = parseDouble(req.getParameter("discountAmt"));
                    double pctInput = parseDouble(req.getParameter("discountPct"));

                    double discountAmt;
                    if ("PCT".equalsIgnoreCase(mode) && pctInput > 0) {
                        discountAmt = round2(subtotal * (pctInput / 100.0));
                    } else {
                        discountAmt = amtInput;
                    }
                    // guard rails
                    if (discountAmt < 0) discountAmt = 0;
                    if (discountAmt > subtotal) discountAmt = subtotal;

                    String method = trim(req.getParameter("paymentMethod"));
                    svc.finalizeBill(billId, discountAmt, method);

                    // Build PDF & try printing or at least save to uploads
                    Bill b = svc.get(billId);
                    Customer c = (b.getCustomerId()==null) ? null :
                            customerDAO.findById(b.getCustomerId()).orElse(null);
                    byte[] pdf = PdfReceiptUtil.buildReceiptPdf(b, c);

                    savePdfToUploads(req, b, pdf);
                    boolean printed = tryPrint(pdf, req.getParameter("printer"));

                    s.removeAttribute("draftBillId");
                    // After finalize, go to dashboard if requested; else show receipt
                    String goDash = req.getParameter("goDashboard");
                    if ("1".equals(goDash)) {
                        resp.sendRedirect(req.getContextPath()+"/dashboard?msg=Bill+saved");
                    } else {
                        resp.sendRedirect(req.getContextPath()+"/billing/receipt.pdf?id="+b.getBillId()+"&msg="+(printed?"Printed":"Saved+PDF"));
                    }
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
        } catch (SQLException e) { throw new ServletException(e); }
    }

    // ----- helpers -----
    private int parseInt(String s){ try { return Integer.parseInt(s); } catch(Exception e){ return 0; } }
    private double parseDouble(String s){ try { return Double.parseDouble(s); } catch(Exception e){ return 0; } }
    private String trim(String s){ return (s==null)? null : s.trim(); }
    private String url(String s){ return java.net.URLEncoder.encode(s==null?"":s, java.nio.charset.StandardCharsets.UTF_8); }
    private double round2(double x){ return Math.round(x*100.0)/100.0; }

    private Path getUploadBase(HttpServletRequest req){
        String conf = req.getServletContext().getInitParameter("upload.dir");
        if (conf == null || conf.isBlank()) {
            conf = System.getProperty("user.home") + java.io.File.separator + "pahanaedu_uploads";
        }
        return Paths.get(conf).toAbsolutePath().normalize();
    }
    private void savePdfToUploads(HttpServletRequest req, Bill b, byte[] pdf) throws IOException {
        Path base = getUploadBase(req).resolve("receipts");
        Files.createDirectories(base);
        String name = (b.getBillNo()!=null && !b.getBillNo().isBlank())
                ? ("receipt-" + b.getBillNo() + ".pdf")
                : ("receipt-" + b.getBillId() + ".pdf");
        Path out = base.resolve(name);
        Files.write(out, pdf, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
    }
    private boolean tryPrint(byte[] pdf, String preferredPrinter){
        try (PDDocument doc = Loader.loadPDF(pdf)) {
            PrintService svc = chooseService(preferredPrinter);
            if (svc == null) return false;
            PrinterJob job = PrinterJob.getPrinterJob();
            job.setPageable(new PDFPageable(doc));
            job.setPrintService(svc);
            job.print();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    private PrintService chooseService(String preferred) {
        PrintService[] services = PrintServiceLookup.lookupPrintServices(null, null);
        if (services == null || services.length == 0) return null;
        if (preferred != null && !preferred.isBlank()) {
            for (PrintService ps : services) if (preferred.equalsIgnoreCase(ps.getName())) return ps;
        }
        PrintService def = PrintServiceLookup.lookupDefaultPrintService();
        return (def != null) ? def : services[0];
    }
}
