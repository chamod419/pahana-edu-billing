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
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Optional;
import java.awt.print.PrinterJob;

@WebServlet(urlPatterns = { "/billing/receipt.pdf", "/billing/print" })
public class BillingPdfController extends HttpServlet {

    private final BillingDAO billingDAO = new BillingDAO();
    private final CustomerService customerService = new CustomerService();

    private Bill requireBill(HttpServletRequest req) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) throw new IOException("Missing bill id");
        int billId;
        try { billId = Integer.parseInt(idStr); } catch (Exception e) { throw new IOException("Invalid bill id"); }
        Optional<Bill> b = billingDAO.loadBill(billId);
        if (b.isEmpty()) throw new IOException("Bill not found");
        return b.get();
    }

    private Customer loadCustomer(Integer customerId){
        if (customerId == null) return null;
        return customerService.get(customerId).orElse(null);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        User u = (s==null) ? null : (User) s.getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        String path = req.getServletPath();

        if ("/billing/receipt.pdf".equals(path)) {
            Bill bill = requireBill(req);
            Customer c = loadCustomer(bill.getCustomerId());
            byte[] pdf = PdfReceiptUtil.buildReceiptPdf(bill, c);

            resp.setContentType("application/pdf");
            String filename = "receipt-" + bill.getBillId() + ".pdf";
            String disposition = ("download".equals(req.getParameter("dl"))) ? "attachment" : "inline";
            resp.setHeader("Content-Disposition", disposition+"; filename=\"" + filename + "\"");
            resp.setContentLength(pdf.length);
            resp.getOutputStream().write(pdf);
            return;
        }

        if ("/billing/print".equals(path)) {
            Bill bill = requireBill(req);
            Customer c = loadCustomer(bill.getCustomerId());
            byte[] pdf = PdfReceiptUtil.buildReceiptPdf(bill, c);

            String preferred = req.getParameter("printer");
            PrintService svc = chooseService(preferred);
            if (svc == null) {
                resp.sendRedirect(req.getContextPath()+"/billing/receipt?id="+bill.getBillId()+"&error=Printer+not+found");
                return;
            }

            try (PDDocument doc = Loader.loadPDF(pdf)) { // PDFBox 3
                PrinterJob job = PrinterJob.getPrinterJob();
                job.setPageable(new PDFPageable(doc));
                job.setPrintService(svc);
                job.print();
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath()+"/billing/receipt?id="+bill.getBillId()+"&error=Print+failed");
                return;
            }

            resp.sendRedirect(req.getContextPath()+"/billing/receipt?id="+bill.getBillId()+"&msg=Sent+to+printer");
        }
    }

    private PrintService chooseService(String preferred) {
        PrintService[] services = PrintServiceLookup.lookupPrintServices(null, null);
        if (services == null || services.length == 0) return null;
        if (preferred != null && !preferred.isBlank()) {
            for (PrintService ps : services) {
                if (preferred.equalsIgnoreCase(ps.getName())) return ps;
            }
        }
        PrintService def = PrintServiceLookup.lookupDefaultPrintService();
        return (def != null) ? def : services[0];
    }
}
