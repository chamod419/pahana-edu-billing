package com.pahanaedu.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    // --- DTOs with getters (EL-friendly) ---
    public static class ReportSummary {
        public long bills;
        public long items;
        public double gross;
        public double discount;
        public double net;

        public long getBills() { return bills; }
        public long getItems() { return items; }
        public double getGross() { return gross; }
        public double getDiscount() { return discount; }
        public double getNet() { return net; }
    }

    public static class SalesPoint {
        public String day;
        public double net;

        public String getDay() { return day; }
        public double getNet() { return net; }
    }

    public static class PaymentSlice {
        public String method;
        public double amount;

        public String getMethod() { return method; }
        public double getAmount() { return amount; }
    }

    public static class TopItemRow {
        public int itemId;
        public String name;
        public int qty;
        public double revenue;

        public int getItemId() { return itemId; }
        public String getName() { return name; }
        public int getQty() { return qty; }
        public double getRevenue() { return revenue; }
    }

    public static class LowStockRow {
        public int itemId;
        public String name;
        public int stockQty;
        public double unitPrice;

        public int getItemId() { return itemId; }
        public String getName() { return name; }
        public int getStockQty() { return stockQty; }
        public double getUnitPrice() { return unitPrice; }
    }

    // --- Queries ---
    public ReportSummary summary(Timestamp from, Timestamp toEx){
        String sql =
            "SELECT COUNT(*) AS bills, " +
            "  COALESCE((SELECT SUM(qty) FROM bill_items bi JOIN bills b2 ON bi.billId=b2.billId " +
            "           WHERE b2.billDate >= ? AND b2.billDate < ?),0) AS items, " +
            "  COALESCE(SUM(subTotal),0)  AS gross, " +
            "  COALESCE(SUM(discountAmt),0) AS discount, " +
            "  COALESCE(SUM(netTotal),0)  AS net " +
            "FROM bills b WHERE b.billDate >= ? AND b.billDate < ?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)){
            ps.setTimestamp(1, from);
            ps.setTimestamp(2, toEx);
            ps.setTimestamp(3, from);
            ps.setTimestamp(4, toEx);
            try (ResultSet rs = ps.executeQuery()){
                ReportSummary s = new ReportSummary();
                if (rs.next()){
                    s.bills = rs.getLong("bills");
                    s.items = rs.getLong("items");
                    s.gross = rs.getDouble("gross");
                    s.discount = rs.getDouble("discount");
                    s.net = rs.getDouble("net");
                }
                return s;
            }
        } catch (SQLException e){ throw new RuntimeException(e); }
    }

    public List<SalesPoint> salesByDay(Timestamp from, Timestamp toEx){
        String sql =
            "SELECT DATE(b.billDate) AS d, COALESCE(SUM(b.netTotal),0) AS net " +
            "FROM bills b WHERE b.billDate >= ? AND b.billDate < ? " +
            "GROUP BY DATE(b.billDate) ORDER BY DATE(b.billDate)";
        List<SalesPoint> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)){
            ps.setTimestamp(1, from);
            ps.setTimestamp(2, toEx);
            try (ResultSet rs = ps.executeQuery()){
                while (rs.next()){
                    SalesPoint p = new SalesPoint();
                    p.day = rs.getString("d");
                    p.net = rs.getDouble("net");
                    out.add(p);
                }
            }
        } catch (SQLException e){ throw new RuntimeException(e); }
        return out;
    }

    public List<PaymentSlice> paymentBreakdown(Timestamp from, Timestamp toEx){
        String sql =
            "SELECT paymentMethod AS method, COALESCE(SUM(netTotal),0) AS amount " +
            "FROM bills WHERE billDate >= ? AND billDate < ? " +
            "GROUP BY paymentMethod ORDER BY amount DESC";
        List<PaymentSlice> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)){
            ps.setTimestamp(1, from);
            ps.setTimestamp(2, toEx);
            try (ResultSet rs = ps.executeQuery()){
                while (rs.next()){
                    PaymentSlice p = new PaymentSlice();
                    p.method = rs.getString("method");
                    p.amount = rs.getDouble("amount");
                    out.add(p);
                }
            }
        } catch (SQLException e){ throw new RuntimeException(e); }
        return out;
    }

    public List<TopItemRow> topItems(Timestamp from, Timestamp toEx, int limit){
        String sql =
            "SELECT bi.itemId, bi.itemName AS name, SUM(bi.qty) AS qty, SUM(bi.lineTotal) AS revenue " +
            "FROM bill_items bi JOIN bills b ON bi.billId=b.billId " +
            "WHERE b.billDate >= ? AND b.billDate < ? " +
            "GROUP BY bi.itemId, bi.itemName " +
            "ORDER BY revenue DESC LIMIT ?";
        List<TopItemRow> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)){
            ps.setTimestamp(1, from);
            ps.setTimestamp(2, toEx);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()){
                while (rs.next()){
                    TopItemRow r = new TopItemRow();
                    r.itemId = rs.getInt("itemId");
                    r.name = rs.getString("name");
                    r.qty = rs.getInt("qty");
                    r.revenue = rs.getDouble("revenue");
                    out.add(r);
                }
            }
        } catch (SQLException e){ throw new RuntimeException(e); }
        return out;
    }

    public List<LowStockRow> lowStock(int threshold){
        String sql = "SELECT itemId, name, stockQty, unitPrice FROM items " +
                     "WHERE stockQty <= ? ORDER BY stockQty ASC, name ASC";
        List<LowStockRow> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)){
            ps.setInt(1, threshold);
            try (ResultSet rs = ps.executeQuery()){
                while (rs.next()){
                    LowStockRow r = new LowStockRow();
                    r.itemId = rs.getInt("itemId");
                    r.name = rs.getString("name");
                    r.stockQty = rs.getInt("stockQty");
                    r.unitPrice = rs.getDouble("unitPrice");
                    out.add(r);
                }
            }
        } catch (SQLException e){ throw new RuntimeException(e); }
        return out;
    }
}
