package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.ReportService;
import com.pahanaedu.dao.ReportDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(urlPatterns = { "/admin/reports" })
public class AdminReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ReportService svc = new ReportService();
    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Require login (AuthFilter තිබ්බත් safety)
        HttpSession s = req.getSession(false);
        User u = (s==null) ? null : (User) s.getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        LocalDate today = LocalDate.now();
        LocalDate defFrom = today.minusDays(6); // last 7 days
        LocalDate from = parseDateOr(req.getParameter("from"), defFrom);
        LocalDate to   = parseDateOr(req.getParameter("to"),   today);
        int threshold  = parseIntOr(req.getParameter("threshold"), 12);

        try {
            ReportDAO.ReportSummary sum = svc.summary(from, to);
            List<ReportDAO.SalesPoint> series = svc.salesByDay(from, to);
            List<ReportDAO.PaymentSlice> pay  = svc.paymentBreakdown(from, to);
            List<ReportDAO.TopItemRow> top   = svc.topItems(from, to, 10);
            List<ReportDAO.LowStockRow> lowStock = svc.lowStock(threshold);

            req.setAttribute("from", DF.format(from));
            req.setAttribute("to", DF.format(to));
            req.setAttribute("threshold", threshold);

            req.setAttribute("sum", sum);
            req.setAttribute("series", series);
            req.setAttribute("pay", pay);
            req.setAttribute("top", top);
            req.setAttribute("lowStock", lowStock);

            // chart JSON
            req.setAttribute("seriesJson", ReportService.toJson(series));
            req.setAttribute("payJson", ReportService.toJson(pay));

            req.getRequestDispatcher("/admin/reports.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private LocalDate parseDateOr(String s, LocalDate def){
        try { return (s==null||s.isBlank()) ? def : LocalDate.parse(s, DF); }
        catch(Exception e){ return def; }
    }
    private int parseIntOr(String s, int def){
        try { return Integer.parseInt(s); } catch(Exception e){ return def; }
    }
}
