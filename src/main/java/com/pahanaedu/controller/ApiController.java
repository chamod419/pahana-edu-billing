package com.pahanaedu.controller;

import com.pahanaedu.model.*;
import com.pahanaedu.service.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@WebServlet(urlPatterns = {"/api/*"})
public class ApiController extends HttpServlet {

    private static final DateTimeFormatter ISO = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    private final ItemService itemSvc = new ItemService();
    private final CustomerService custSvc = new CustomerService();
    private final BillingService billSvc = new BillingService();
    private final DashboardService dashSvc = new DashboardService();
    private final ReportService reportSvc = new ReportService();

    // ---- GET ----
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        resp.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();            // e.g. /items, /items/12
        if (path == null) path = "/";

        // Public endpoints (AuthFilter will also allow /api/ping, /api/help)
        if ("/ping".equals(path)) {
            json(resp, 200, "{\"ok\":true,\"service\":\"PahanaEdu API\",\"time\":\"" + java.time.LocalDateTime.now() + "\"}");
            return;
        }
        if ("/help".equals(path) || "/".equals(path)) {
            // Human docs
            req.getRequestDispatcher("/api/help.jsp").forward(req, resp);
            return;
        }

        // Require login via session for the rest
        HttpSession s = req.getSession(false);
        User u = (s==null) ? null : (User) s.getAttribute("user");
        if (u == null) { json(resp, 401, "{\"error\":\"Unauthorized\"}"); return; }

        try {
            // -------- Routing --------
            if (path.startsWith("/items")) {
                handleItems(req, resp, path);
            } else if (path.startsWith("/customers")) {
                handleCustomers(req, resp, path);
            } else if (path.startsWith("/bills")) {
                handleBills(req, resp, path);
            } else if (path.startsWith("/reports/summary")) {
                // /api/reports/summary?from=YYYY-MM-DD&to=YYYY-MM-DD
                java.time.LocalDate today = java.time.LocalDate.now();
                java.time.LocalDate from = parseDate(req.getParameter("from"), today.minusDays(6));
                java.time.LocalDate to   = parseDate(req.getParameter("to"),   today);
                var sum = reportSvc.summary(from, to);
                var pay = reportSvc.paymentBreakdown(from, to);
                var series = reportSvc.salesByDay(from, to);
                StringBuilder sb = new StringBuilder();
                sb.append("{\"range\":{\"from\":\"").append(from).append("\",\"to\":\"").append(to).append("\"},");
                sb.append("\"summary\":{")
                  .append("\"bills\":").append(sum.getBills()).append(',')
                  .append("\"items\":").append(sum.getItems()).append(',')
                  .append("\"gross\":").append(fmt(sum.getGross())).append(',')
                  .append("\"discount\":").append(fmt(sum.getDiscount())).append(',')
                  .append("\"net\":").append(fmt(sum.getNet())).append("},");
                // series
                sb.append("\"salesByDay\":[");
                for (int i=0;i<series.size();i++){
                    var p = series.get(i);
                    if (i>0) sb.append(',');
                    sb.append("{\"day\":\"").append(esc(p.getDay())).append("\",\"net\":").append(fmt(p.getNet())).append('}');
                }
                sb.append("],");
                // pay
                sb.append("\"paymentBreakdown\":[");
                for (int i=0;i<pay.size();i++){
                    var p = pay.get(i);
                    if (i>0) sb.append(',');
                    sb.append("{\"method\":\"").append(esc(p.getMethod())).append("\",\"amount\":").append(fmt(p.getAmount())).append('}');
                }
                sb.append("]}");
                json(resp, 200, sb.toString());
            } else if (path.startsWith("/status")) {
                // Admin sees global; Staff sees own
                if ("ADMIN".equals(u.getRole())) {
                    String body = "{\"scope\":\"GLOBAL\",\"todayBills\":"+dashSvc.todayBills()+"," +
                            "\"todayRevenue\":"+fmt(dashSvc.todayRevenue())+"," +
                            "\"totalCustomers\":"+dashSvc.totalCustomers()+"," +
                            "\"activeItems\":"+dashSvc.activeItems()+"}";
                    json(resp, 200, body);
                } else {
                    String body = "{\"scope\":\"USER\",\"userId\":"+u.getUserId()+"," +
                            "\"todayBills\":"+dashSvc.todayBillsByUser(u.getUserId())+"," +
                            "\"todayRevenue\":"+fmt(dashSvc.todayRevenueByUser(u.getUserId()))+"," +
                            "\"customersServed\":"+dashSvc.todayCustomersServedByUser(u.getUserId())+"}";
                    json(resp, 200, body);
                }
            } else {
                json(resp, 404, "{\"error\":\"Not found\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            json(resp, 500, "{\"error\":\"Server error\"}");
        }
    }

    // ---- Handlers ----
    private void handleItems(HttpServletRequest req, HttpServletResponse resp, String path) throws IOException {
        // /api/items or /api/items/{id}
        String[] parts = path.split("/");
        if (parts.length == 3 && isInt(parts[2])) {
            int id = Integer.parseInt(parts[2]);
            Optional<Item> oi = itemSvc.get(id);
            if (oi.isEmpty()) { json(resp, 404, "{\"error\":\"Item not found\"}"); return; }
            json(resp, 200, itemJson(oi.get()));
            return;
        }
        boolean onlyActive = "true".equalsIgnoreCase(req.getParameter("active"));
        String q = trim(req.getParameter("q"));
        int limit = parseInt(req.getParameter("limit"), 100);

        List<Item> list = (q!=null && !q.isBlank())
                ? itemSvc.searchBillable(q, limit)     // good for POS search
                : (onlyActive ? itemSvc.active() : itemSvc.list());
        StringBuilder sb = new StringBuilder("[");
        for (int i=0;i<list.size();i++){
            if (i>0) sb.append(',');
            sb.append(itemJsonObj(list.get(i)));
        }
        sb.append("]");
        json(resp, 200, sb.toString());
    }

    private void handleCustomers(HttpServletRequest req, HttpServletResponse resp, String path) throws IOException {
        // /api/customers or /api/customers/{id}
        String[] parts = path.split("/");
        if (parts.length == 3 && isInt(parts[2])) {
            int id = Integer.parseInt(parts[2]);
            Optional<Customer> oc = custSvc.get(id);
            if (oc.isEmpty()) { json(resp, 404, "{\"error\":\"Customer not found\"}"); return; }
            json(resp, 200, customerJson(oc.get()));
            return;
        }
        String q = trim(req.getParameter("q"));
        int limit = parseInt(req.getParameter("limit"), 200);
        List<Customer> list = (q==null || q.isBlank()) ? custSvc.list() : custSvc.search(q);
        // soft limit
        if (list.size() > limit) list = list.subList(0, limit);

        StringBuilder sb = new StringBuilder("[");
        for (int i=0;i<list.size();i++){
            if (i>0) sb.append(',');
            sb.append(customerJsonObj(list.get(i)));
        }
        sb.append("]");
        json(resp, 200, sb.toString());
    }

    private void handleBills(HttpServletRequest req, HttpServletResponse resp, String path) throws IOException {
        // /api/bills/{id}
        String[] parts = path.split("/");
        if (parts.length == 3 && isInt(parts[2])) {
            int id = Integer.parseInt(parts[2]);
            try {
                Bill b = billSvc.get(id);
                if (b == null) { json(resp, 404, "{\"error\":\"Bill not found\"}"); return; }
                json(resp, 200, billJson(b));
            } catch (Exception e) {
                json(resp, 500, "{\"error\":\"Failed to load bill\"}");
            }
            return;
        }
        json(resp, 400, "{\"error\":\"Bill id required\"}");
    }

    // ---- JSON builders (manual, dependency-free) ----
    private String itemJson(Item i){ return itemJsonObj(i); }
    private String itemJsonObj(Item i){
        return new StringBuilder("{")
                .append("\"itemId\":").append(i.getItemId()).append(',')
                .append("\"name\":\"").append(esc(i.getName())).append("\",")
                .append("\"unitPrice\":").append(fmt(i.getUnitPrice())).append(',')
                .append("\"stockQty\":").append(i.getStockQty()).append(',')
                .append("\"category\":\"").append(esc(nz(i.getCategory()))).append("\",")
                .append("\"description\":\"").append(esc(nz(i.getDescription()))).append("\",")
                .append("\"imageUrl\":\"").append(esc(nz(i.getImageUrl()))).append("\",")
                .append("\"active\":").append(i.isActive())
                .append("}").toString();
    }

    private String customerJson(Customer c){ return customerJsonObj(c); }
    private String customerJsonObj(Customer c){
        return new StringBuilder("{")
                .append("\"customerId\":").append(c.getCustomerId()).append(',')
                .append("\"accountNumber\":\"").append(esc(nz(c.getAccountNumber()))).append("\",")
                .append("\"name\":\"").append(esc(nz(c.getName()))).append("\",")
                .append("\"address\":\"").append(esc(nz(c.getAddress()))).append("\",")
                .append("\"phone\":\"").append(esc(nz(c.getPhone()))).append("\",")
                .append("\"email\":\"").append(esc(nz(c.getEmail()))).append("\",")
                .append("\"status\":\"").append(esc(nz(c.getStatus()))).append("\"")
                .append("}").toString();
    }

    private String billJson(Bill b){
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"billId\":").append(b.getBillId()).append(',')
          .append("\"billNo\":\"").append(esc(nz(b.getBillNo()))).append("\",")
          .append("\"billDate\":").append(b.getBillDate()==null ? "null" : "\""+esc(b.getBillDate().format(ISO))+"\"").append(',')
          .append("\"customerId\":").append(b.getCustomerId()==null ? "null" : b.getCustomerId()).append(',')
          .append("\"createdBy\":").append(b.getCreatedBy()==null ? "null" : b.getCreatedBy()).append(',')
          .append("\"subTotal\":").append(fmt(b.getSubTotal())).append(',')
          .append("\"discountAmt\":").append(fmt(b.getDiscountAmt())).append(',')
          .append("\"netTotal\":").append(fmt(b.getNetTotal())).append(',')
          .append("\"paidAmount\":").append(fmt(b.getPaidAmount())).append(',')
          .append("\"paymentMethod\":\"").append(esc(nz(b.getPaymentMethod()))).append("\",")
          .append("\"notes\":\"").append(esc(nz(b.getNotes()))).append("\",")
          .append("\"items\":[");
        List<BillItem> items = b.getItems();
        for (int i=0;i<items.size();i++){
            BillItem bi = items.get(i);
            if (i>0) sb.append(',');
            sb.append("{")
              .append("\"billItemId\":").append(bi.getBillItemId()).append(',')
              .append("\"itemId\":").append(bi.getItemId()==null? "null" : bi.getItemId()).append(',')
              .append("\"itemName\":\"").append(esc(nz(bi.getItemName()))).append("\",")
              .append("\"unitPrice\":").append(fmt(bi.getUnitPrice())).append(',')
              .append("\"qty\":").append(bi.getQty()).append(',')
              .append("\"subTotal\":").append(fmt(bi.getSubTotal()))
              .append("}");
        }
        sb.append("]}");
        return sb.toString();
    }

    // ---- small helpers ----
    private static void json(HttpServletResponse resp, int code, String body) throws IOException {
        resp.setStatus(code);
        resp.setContentType("application/json");
        resp.getWriter().write(body);
    }
    private static String esc(String s){ return (s==null) ? "" : s.replace("\\","\\\\").replace("\"","\\\""); }
    private static String nz(String s){ return (s==null)? "" : s; }
    private static boolean isInt(String s){ try{ Integer.parseInt(s); return true; }catch(Exception e){return false;} }
    private static int parseInt(String s, int def){ try{ return Integer.parseInt(s);}catch(Exception e){return def;} }
    private static String trim(String s){ return (s==null)? null : s.trim(); }
    private static java.time.LocalDate parseDate(String s, java.time.LocalDate def){
        try { return (s==null||s.isBlank())? def : java.time.LocalDate.parse(s); }
        catch(Exception e){ return def; }
    }
    private static String fmt(double v){
        // keep raw double for easier client math, but format to 2dp string if you prefer.
        // Here we keep numeric (no quotes) with 2dp rounding:
        return String.format(java.util.Locale.US, "%.2f", v);
    }
}
