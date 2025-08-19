package com.pahanaedu.service;

import com.pahanaedu.dao.ReportDAO;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class ReportService {
    private final ReportDAO dao = new ReportDAO();

    // Inclusive [from..to] -> half-open [start, endExclusive)
    private Timestamp[] range(LocalDate from, LocalDate to){
        LocalDateTime start = from.atStartOfDay();
        LocalDateTime endEx = to.plusDays(1).atStartOfDay();
        return new Timestamp[]{ Timestamp.valueOf(start), Timestamp.valueOf(endEx) };
    }

    public ReportDAO.ReportSummary summary(LocalDate from, LocalDate to){
        Timestamp[] r = range(from, to);
        return dao.summary(r[0], r[1]);
    }

    public List<ReportDAO.SalesPoint> salesByDay(LocalDate from, LocalDate to){
        Timestamp[] r = range(from, to);
        return dao.salesByDay(r[0], r[1]);
    }

    public List<ReportDAO.PaymentSlice> paymentBreakdown(LocalDate from, LocalDate to){
        Timestamp[] r = range(from, to);
        return dao.paymentBreakdown(r[0], r[1]);
    }

    public List<ReportDAO.TopItemRow> topItems(LocalDate from, LocalDate to, int limit){
        Timestamp[] r = range(from, to);
        return dao.topItems(r[0], r[1], limit);
    }

    public List<ReportDAO.LowStockRow> lowStock(int threshold){
        return dao.lowStock(threshold);
    }

    // Tiny JSON helper (no extra libs)
    public static String toJson(Object obj){
        if (obj == null) return "null";
        if (obj instanceof java.util.List<?> list){
            StringBuilder sb = new StringBuilder("[");
            boolean first=true;
            for (Object o : list){
                if (!first) sb.append(',');
                sb.append(toJson(o));
                first=false;
            }
            return sb.append(']').toString();
        }
        if (obj instanceof ReportDAO.SalesPoint sp){
            return String.format("{\"d\":\"%s\",\"net\":%.2f}", sp.day, sp.net);
        }
        if (obj instanceof ReportDAO.PaymentSlice p){
            return String.format("{\"method\":\"%s\",\"amount\":%.2f}",
                    esc(p.method), p.amount);
        }
        if (obj instanceof ReportDAO.TopItemRow t){
            return String.format("{\"itemId\":%d,\"name\":\"%s\",\"qty\":%d,\"revenue\":%.2f}",
                    t.itemId, esc(t.name), t.qty, t.revenue);
        }
        return "\"\"";
    }
    private static String esc(String s){ return s==null?"":s.replace("\"","\\\""); }
}
