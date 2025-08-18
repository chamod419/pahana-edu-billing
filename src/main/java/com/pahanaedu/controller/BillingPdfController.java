package com.pahanaedu.controller;

import com.pahanaedu.dao.BillingDAO;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.Customer;
import com.pahanaedu.model.User;
import com.pahanaedu.service.CustomerService;
import com.pahanaedu.util.PdfReceiptUtil;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.printing.PDFPageable;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.awt.print.PrinterJob;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = { "/billing/receipt.pdf", "/billing/print" })
public class BillingPdfController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BillingDAO billingDAO = new BillingDAO();
    private final CustomerService customerService = new CustomerService();

    /** Load a bill or throw IOException if missing/invalid. Also wraps SQL errors. */
    private Bill requireBill(HttpServletRequest req) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            throw new IOException("Missing bill id");
        }

        final int billId;
        try {
            billId = Integer.parseInt(idStr);
        } catch (Exception e) {
            throw new IOException("Invalid bill id");
        }

        try {
            // DAO returns Bill and may throw SQLException
            Bill b = billingDAO.loadBill(billId);
            if (b == null) throw new IOException("Bill not found");
            return b;
        } catch (SQLException e) {
            throw new IOException("Database error while loading bill", e);
        }
    }

    private Customer loadCustomer(Integer customerId) {
        if (customerId == null) return null;
        return customerService.get(customerId).orElse(null);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // require login
        var s = req.getSession(false);
        User u = (s == null) ? null : (User) s.getAttribute("user");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();

        // 1) Show / download PDF
        if ("/billing/receipt.pdf".equals(path)) {
            Bill bill = requireBill(req);
            Customer c = loadCustomer(bill.getCustomerId());
            byte[] pdf = PdfReceiptUtil.buildReceiptPdf(bill, c);

            resp.setContentType("application/pdf");
            String filename = "receipt-" + bill.getBillId() + ".pdf";
            String disposition = ("download".equals(req.getParameter("dl"))) ? "attachment" : "inline";
            resp.setHeader("Content-Disposition", disposition + "; filename=\"" + filename + "\"");
            resp.setContentLength(pdf.length);
            resp.getOutputStream().write(pdf);
            return;
        }

        // 2) Send PDF to default / named printer
        if ("/billing/print".equals(path)) {
            Bill bill = requireBill(req);
            Customer c = loadCustomer(bill.getCustomerId());
            byte[] pdf = PdfReceiptUtil.buildReceiptPdf(bill, c);

            String preferredPrinter = req.getParameter("printer");
            PrintService svc = chooseService(preferredPrinter);
            if (svc == null) {
                resp.sendRedirect(req.getContextPath() + "/billing/receipt?id=" + bill.getBillId() + "&error=Printer+not+found");
                return;
            }

            try (PDDocument doc = Loader.loadPDF(pdf)) {
                PrinterJob job = PrinterJob.getPrinterJob();
                job.setPageable(new PDFPageable(doc));
                job.setPrintService(svc);
                job.print();
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/billing/receipt?id=" + bill.getBillId() + "&error=Print+failed");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/billing/receipt?id=" + bill.getBillId() + "&msg=Sent+to+printer");
            return;
        }

        // Unknown path
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    /** Pick a printer service by name (if given) else default/first available. */
    private PrintService chooseService(String preferred) {
        PrintService[] services = PrintServiceLookup.lookupPrintServices(null, null);
        if (services == null || services.length == 0) return null;

        if (preferred != null && !preferred.isBlank()) {
            for (PrintService ps : services) {
                if (preferred.equalsIgnoreCase(ps.getName())) {
                    return ps;
                }
            }
        }

        PrintService def = PrintServiceLookup.lookupDefaultPrintService();
        return (def != null) ? def : services[0];
    }
}
