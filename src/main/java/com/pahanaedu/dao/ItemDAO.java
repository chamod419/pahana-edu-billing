//package com.pahanaedu.dao;
//
//import com.pahanaedu.model.Item;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.Optional;
//
//public class ItemDAO {
//
//    /** All items (for admin manage page) */
//    public List<Item> findAll() {
//        String sql = "SELECT itemId,name,unitPrice,stockQty,category,description,imageUrl,isActive " +
//                     "FROM items ORDER BY itemId DESC";
//        List<Item> out = new ArrayList<>();
//        try (Connection c = DBConnection.getInstance().getConnection();
//             PreparedStatement ps = c.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) out.add(map(rs));
//        } catch (SQLException e) { e.printStackTrace(); }
//        return out;
//    }
//
//    /** Active+in-stock items only (for billing item dropdown) */
//    public List<Item> findActive() {
//        String sql = "SELECT itemId,name,unitPrice,stockQty,category,description,imageUrl,isActive " +
//                     "FROM items WHERE isActive=TRUE AND stockQty>0 ORDER BY name";
//        List<Item> out = new ArrayList<>();
//        try (Connection c = DBConnection.getInstance().getConnection();
//             PreparedStatement ps = c.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) out.add(map(rs));
//        } catch (SQLException e) { e.printStackTrace(); }
//        return out;
//    }
//
//    /** Fetch by id (no billable filter) */
//    public Optional<Item> findById(int id) {
//        String sql = "SELECT itemId,name,unitPrice,stockQty,category,description,imageUrl,isActive " +
//                     "FROM items WHERE itemId=?";
//        try (Connection c = DBConnection.getInstance().getConnection();
//             PreparedStatement ps = c.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) return Optional.of(map(rs));
//            }
//        } catch (SQLException e) { e.printStackTrace(); }
//        return Optional.empty();
//    }
//
//    /** NEW: Only return if billable (active AND stock>0) */
//    public Optional<Item> findBillableById(int id) {
//        String sql = "SELECT itemId,name,unitPrice,stockQty,category,description,imageUrl,isActive " +
//                     "FROM items WHERE itemId=? AND isActive=TRUE AND stockQty>0";
//        try (Connection c = DBConnection.getInstance().getConnection();
//             PreparedStatement ps = c.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) return Optional.of(map(rs));
//            }
//        } catch (SQLException e) { e.printStackTrace(); }
//        return Optional.empty();
//    }
//
//    public boolean insert(Item x) {
//        String sql = "INSERT INTO items(name,unitPrice,stockQty,category,description,imageUrl,isActive) " +
//                     "VALUES (?,?,?,?,?,?,?)";
//        try (Connection c = DBConnection.getInstance().getConnection();
//             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//            ps.setString(1, x.getName());
//            ps.setDouble(2, x.getUnitPrice());
//            ps.setInt(3, x.getStockQty());
//            ps.setString(4, nullIfBlank(x.getCategory()));
//            ps.setString(5, nullIfBlank(x.getDescription()));
//            ps.setString(6, nullIfBlank(x.getImageUrl()));
//            ps.setBoolean(7, x.isActive());
//            int n = ps.executeUpdate();
//            if (n > 0) {
//                try (ResultSet keys = ps.getGeneratedKeys()) {
//                    if (keys.next()) x.setItemId(keys.getInt(1));
//                }
//            }
//            return n > 0;
//        } catch (SQLException e) { e.printStackTrace(); return false; }
//    }
//
//    public boolean update(Item x) {
//        String sql = "UPDATE items SET name=?, unitPrice=?, stockQty=?, category=?, description=?, imageUrl=?, isActive=? " +
//                     "WHERE itemId=?";
//        try (Connection c = DBConnection.getInstance().getConnection();
//             PreparedStatement ps = c.prepareStatement(sql)) {
//            ps.setString(1, x.getName());
//            ps.setDouble(2, x.getUnitPrice());
//            ps.setInt(3, x.getStockQty());
//            ps.setString(4, nullIfBlank(x.getCategory()));
//            ps.setString(5, nullIfBlank(x.getDescription()));
//            ps.setString(6, nullIfBlank(x.getImageUrl()));
//            ps.setBoolean(7, x.isActive());
//            ps.setInt(8, x.getItemId());
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) { e.printStackTrace(); return false; }
//    }
//
//    public boolean delete(int id) {
//        String sql = "DELETE FROM items WHERE itemId=?";
//        try (Connection c = DBConnection.getInstance().getConnection();
//             PreparedStatement ps = c.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) { e.printStackTrace(); return false; }
//    }
//
//    /** NEW: how many bill_items rows reference this item (for safe delete logic) */
//    public long countUsageInBills(int itemId) {
//        String sql = "SELECT COUNT(*) FROM bill_items WHERE itemId = ?";
//        try (Connection c = DBConnection.getInstance().getConnection();
//             PreparedStatement ps = c.prepareStatement(sql)) {
//            ps.setInt(1, itemId);
//            try (ResultSet rs = ps.executeQuery()) {
//                return rs.next() ? rs.getLong(1) : 0L;
//            }
//        } catch (SQLException e) { e.printStackTrace(); return 0L; }
//    }
//
//    // ---- helpers ----
//    private Item map(ResultSet rs) throws SQLException {
//        Item i = new Item();
//        i.setItemId(rs.getInt("itemId"));
//        i.setName(rs.getString("name"));
//        i.setUnitPrice(rs.getDouble("unitPrice"));
//        i.setStockQty(rs.getInt("stockQty"));
//        i.setCategory(rs.getString("category"));
//        i.setDescription(rs.getString("description"));
//        i.setImageUrl(rs.getString("imageUrl"));
//        i.setActive(rs.getBoolean("isActive"));
//        return i;
//    }
//
//    private String nullIfBlank(String s) { return (s == null || s.isBlank()) ? null : s; }
//}



package com.pahanaedu.dao;

import com.pahanaedu.model.Item;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ItemDAO {

    public List<Item> findAll() {
        String sql = "SELECT itemId,name,unitPrice,stockQty,category,description,imageUrl,isActive " +
                     "FROM items ORDER BY itemId DESC";
        List<Item> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return out;
    }

    public List<Item> findActive() {
        String sql = "SELECT itemId,name,unitPrice,stockQty,category,description,imageUrl,isActive " +
                     "FROM items WHERE isActive=TRUE ORDER BY name";
        List<Item> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return out;
    }

    public Optional<Item> findById(int id) {
        String sql = "SELECT itemId,name,unitPrice,stockQty,category,description,imageUrl,isActive " +
                     "FROM items WHERE itemId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return Optional.empty();
    }

    /** Billable guard: active + stock > 0 */
    public Optional<Item> findBillableById(int id) {
        String sql = "SELECT itemId,name,unitPrice,stockQty,category,description,imageUrl,isActive " +
                     "FROM items WHERE itemId=? AND isActive=TRUE AND stockQty>0";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return Optional.empty();
    }

    /** Type-ahead search for billing (active only). */
    public List<Item> searchBillable(String term, int limit) {
        String q = (term == null) ? "" : term.trim();
        String sql =
            "SELECT itemId,name,unitPrice,stockQty,category,description,imageUrl,isActive " +
            "FROM items " +
            "WHERE isActive=TRUE AND (name LIKE ? OR category LIKE ?) " +
            "ORDER BY name LIMIT ?";
        List<Item> out = new ArrayList<>();
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            String like = "%" + q + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setInt(3, (limit<=0)? 10 : limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return out;
    }

    /** How many bills reference this item (for safe delete rules). */
    public int countUsageInBills(int itemId) {
        String sql = "SELECT COUNT(*) FROM bill_items WHERE itemId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next()? rs.getInt(1) : 0;
            }
        } catch (SQLException e) { e.printStackTrace(); return -1; }
    }

    public boolean insert(Item x) {
        String sql = "INSERT INTO items(name,unitPrice,stockQty,category,description,imageUrl,isActive) " +
                     "VALUES (?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, x.getName());
            ps.setDouble(2, x.getUnitPrice());
            ps.setInt(3, x.getStockQty());
            ps.setString(4, nullIfBlank(x.getCategory()));
            ps.setString(5, nullIfBlank(x.getDescription()));
            ps.setString(6, nullIfBlank(x.getImageUrl()));
            ps.setBoolean(7, x.isActive());
            int n = ps.executeUpdate();
            if (n>0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) x.setItemId(keys.getInt(1));
                }
            }
            return n>0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean update(Item x) {
        String sql = "UPDATE items SET name=?, unitPrice=?, stockQty=?, category=?, description=?, imageUrl=?, isActive=? " +
                     "WHERE itemId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, x.getName());
            ps.setDouble(2, x.getUnitPrice());
            ps.setInt(3, x.getStockQty());
            ps.setString(4, nullIfBlank(x.getCategory()));
            ps.setString(5, nullIfBlank(x.getDescription()));
            ps.setString(6, nullIfBlank(x.getImageUrl()));
            ps.setBoolean(7, x.isActive());
            ps.setInt(8, x.getItemId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM items WHERE itemId=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Item map(ResultSet rs) throws SQLException {
        Item i = new Item();
        i.setItemId(rs.getInt("itemId"));
        i.setName(rs.getString("name"));
        i.setUnitPrice(rs.getDouble("unitPrice"));
        i.setStockQty(rs.getInt("stockQty"));
        i.setCategory(rs.getString("category"));
        i.setDescription(rs.getString("description"));
        i.setImageUrl(rs.getString("imageUrl"));
        i.setActive(rs.getBoolean("isActive"));
        return i;
    }
    private String nullIfBlank(String s){ return (s==null || s.isBlank()) ? null : s; }
}
