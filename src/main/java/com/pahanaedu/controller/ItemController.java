//package com.pahanaedu.controller;
//
//import com.pahanaedu.model.Item;
//import com.pahanaedu.model.User;
//import com.pahanaedu.service.DeleteResult;
//import com.pahanaedu.service.ItemService;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.MultipartConfig;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import javax.servlet.http.Part;
//import java.io.File;
//import java.io.IOException;
//import java.io.InputStream;
//import java.nio.file.*;
//import java.util.List;
//import java.util.Optional;
//import java.util.UUID;
//
//@MultipartConfig(
//        fileSizeThreshold = 1 * 1024 * 1024,
//        maxFileSize = 5 * 1024 * 1024,
//        maxRequestSize = 10 * 1024 * 1024
//)
//@WebServlet(urlPatterns = { "/items", "/items/new", "/items/edit", "/items/save", "/items/delete" })
//public class ItemController extends HttpServlet {
//    private final ItemService svc = new ItemService();
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
//            throws ServletException, IOException {
//        String path = req.getServletPath();
//        switch (path) {
//            case "/items":
//                List<Item> all = svc.list();
//                req.setAttribute("list", all);
//                req.getRequestDispatcher("/items/list.jsp").forward(req, resp);
//                break;
//            case "/items/new":
//                req.setAttribute("mode", "create");
//                req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
//                break;
//            case "/items/edit":
//                int id = parseInt(req.getParameter("id"));
//                Optional<Item> i = svc.get(id);
//                if (i.isEmpty()) {
//                    resp.sendRedirect(req.getContextPath() + "/items?error=Not+found");
//                    return;
//                }
//                req.setAttribute("mode", "edit");
//                req.setAttribute("i", i.get());
//                req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
//                break;
//            default: resp.sendError(HttpServletResponse.SC_NOT_FOUND);
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
//            throws IOException, ServletException {
//        String path = req.getServletPath();
//
//        switch (path) {
//            case "/items/save": {
//                Item i = new Item();
//                i.setItemId(parseInt(req.getParameter("itemId")));
//                i.setName(trim(req.getParameter("name")));
//                i.setUnitPrice(parseDouble(req.getParameter("unitPrice")));
//                i.setStockQty(parseInt(req.getParameter("stockQty")));
//                i.setCategory(trim(req.getParameter("category")));
//                i.setDescription(trim(req.getParameter("description")));
//
//                // auto status by stock
//                i.setActive(i.getStockQty() > 0);
//
//                String err = validate(i);
//                if (err != null) {
//                    req.setAttribute("error", err);
//                    req.setAttribute("i", i);
//                    req.setAttribute("mode", (i.getItemId()==0) ? "create" : "edit");
//                    req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
//                    return;
//                }
//
//                Part part = null;
//                try { part = req.getPart("imageFile"); } catch (Exception ignored) {}
//                if (part != null && part.getSize() > 0) {
//                    String submitted = part.getSubmittedFileName();
//                    String ext = getExt(submitted);
//                    String mime = part.getContentType();
//                    if (!isAllowed(ext, mime)) {
//                        req.setAttribute("error", "Only JPG/PNG/GIF images allowed (max 5MB).");
//                        req.setAttribute("i", i);
//                        req.setAttribute("mode", (i.getItemId()==0) ? "create" : "edit");
//                        req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
//                        return;
//                    }
//                    Path base = getUploadBase(req).resolve("items");
//                    Files.createDirectories(base);
//                    String filename = "item_" + UUID.randomUUID() + ext;
//                    Path target = base.resolve(filename);
//                    try (InputStream in = part.getInputStream()) {
//                        Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
//                    }
//                    i.setImageUrl("items/" + filename);
//                } else {
//                    String keep = trim(req.getParameter("existingImage"));
//                    i.setImageUrl((keep == null || keep.isBlank()) ? null : keep);
//                }
//
//                boolean ok = svc.save(i);
//                resp.sendRedirect(req.getContextPath() + "/items?" + (ok ? "msg=Saved" : "error=Save+failed"));
//                break;
//            }
//
//            case "/items/delete": {
//                // ✅ allow ADMIN or STAFF
//                HttpSession s = req.getSession(false);
//                User u = (s==null) ? null : (User) s.getAttribute("user");
//                if (u == null || !( "ADMIN".equals(u.getRole()) || "STAFF".equals(u.getRole()) )) {
//                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
//                    return;
//                }
//                int id = parseInt(req.getParameter("id"));
//
//                // keep image path to remove after DB delete
//                String imgRel = svc.get(id).map(Item::getImageUrl).orElse(null);
//
//                DeleteResult r = svc.deleteSafe(id);
//                String q;
//                switch (r) {
//                    case OK:
//                        if (imgRel != null && !imgRel.isBlank()) {
//                            try {
//                                Path base = getUploadBase(req);
//                                Path f = base.resolve(imgRel).normalize();
//                                if (Files.exists(f)) Files.delete(f);
//                            } catch (Exception ignore) {}
//                        }
//                        q = "msg=Deleted";
//                        break;
//                    case IN_USE:
//                        q = "error=Cannot+delete:+item+used+in+bills.+Mark+INACTIVE+instead.";
//                        break;
//                    default:
//                        q = "error=Delete+failed";
//                }
//                resp.sendRedirect(req.getContextPath() + "/items?" + q);
//                break;
//            }
//
//            default: resp.sendError(HttpServletResponse.SC_NOT_FOUND);
//        }
//    }
//
//    // helpers
//    private int parseInt(String s){ try { return Integer.parseInt(s); } catch(Exception e){ return 0; } }
//    private double parseDouble(String s){ try { return Double.parseDouble(s); } catch(Exception e){ return -1; } }
//    private String trim(String s){ return (s==null)? null : s.trim(); }
//    private String validate(Item i){
//        if (i.getName()==null || i.getName().isBlank()) return "Name is required";
//        if (i.getUnitPrice() < 0) return "Unit Price must be 0 or more";
//        if (i.getStockQty() < 0) return "Stock Qty must be 0 or more";
//        return null;
//    }
//    private Path getUploadBase(HttpServletRequest req){
//        String conf = req.getServletContext().getInitParameter("upload.dir");
//        if (conf == null || conf.isBlank()) {
//            conf = System.getProperty("user.home") + File.separator + "pahanaedu_uploads";
//        }
//        return Paths.get(conf).toAbsolutePath().normalize();
//    }
//    private String getExt(String name){
//        if (name == null) return "";
//        int dot = name.lastIndexOf('.');
//        return (dot>=0) ? name.substring(dot).toLowerCase() : "";
//    }
//    private boolean isAllowed(String ext, String mime){
//        if (mime == null) mime = "";
//        boolean typeOk = mime.startsWith("image/");
//        boolean extOk = ext.matches("\\.(jpg|jpeg|png|gif)");
//        return typeOk && extOk;
//    }
//}




package com.pahanaedu.controller;

import com.pahanaedu.model.Item;
import com.pahanaedu.model.User;
import com.pahanaedu.service.ItemService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@WebServlet(urlPatterns = {
        "/items", "/items/new", "/items/edit", "/items/save", "/items/delete"
})
@MultipartConfig(
        fileSizeThreshold = 1 * 1024 * 1024, // 1MB
        maxFileSize      = 5 * 1024 * 1024, // 5MB per file
        maxRequestSize   = 10 * 1024 * 1024 // 10MB total
)
public class ItemController extends HttpServlet {
    private final ItemService svc = new ItemService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        switch (path) {
            case "/items": {
                List<Item> all = svc.list();
                req.setAttribute("list", all);
                req.getRequestDispatcher("/items/list.jsp").forward(req, resp);
                break;
            }
            case "/items/new": {
                req.setAttribute("mode", "create");
                req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
                break;
            }
            case "/items/edit": {
                int id = parseInt(req.getParameter("id"));
                Optional<Item> i = svc.get(id);
                if (i.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/items?error=Not+found");
                    return;
                }
                req.setAttribute("mode", "edit");
                req.setAttribute("i", i.get());
                req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
                break;
            }
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String path = req.getServletPath();
        switch (path) {
            case "/items/save": {
                Item i = new Item();
                i.setItemId(parseInt(req.getParameter("itemId")));
                i.setName(trim(req.getParameter("name")));
                i.setUnitPrice(parseDouble(req.getParameter("unitPrice")));
                i.setStockQty(parseInt(req.getParameter("stockQty")));
                i.setCategory(trim(req.getParameter("category")));
                i.setDescription(trim(req.getParameter("description")));

                // Auto-sync active with stock (DB triggers do this too; we mirror in UI)
                i.setActive(i.getStockQty() > 0);

                // Validate BEFORE file write
                String err = validate(i);
                if (err != null) {
                    req.setAttribute("error", err);
                    req.setAttribute("i", i);
                    req.setAttribute("mode", (i.getItemId()==0) ? "create" : "edit");
                    req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
                    return;
                }

                // Handle file upload (optional)
                Part part = null;
                try { part = req.getPart("imageFile"); } catch (Exception ignored) {}
                if (part != null && part.getSize() > 0) {
                    String submitted = part.getSubmittedFileName();
                    String ext  = getExt(submitted);
                    String mime = part.getContentType();

                    if (!isAllowed(ext, mime)) {
                        req.setAttribute("error", "Only JPG/PNG/GIF images allowed (max 5MB).");
                        req.setAttribute("i", i);
                        req.setAttribute("mode", (i.getItemId()==0) ? "create" : "edit");
                        req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
                        return;
                    }

                    Path base = getUploadBase(req).resolve("items");
                    Files.createDirectories(base);
                    String filename = "item_" + UUID.randomUUID() + ext.toLowerCase();
                    Path target = base.resolve(filename);

                    try (InputStream in = part.getInputStream()) {
                        Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
                    }
                    // Save RELATIVE path (served by /uploads/*)
                    i.setImageUrl("items/" + filename);
                } else {
                    // Keep existing image (hidden field from form) if any
                    String keep = trim(req.getParameter("existingImage"));
                    i.setImageUrl((keep == null || keep.isBlank()) ? null : keep);
                }

                boolean ok = svc.save(i);
                resp.sendRedirect(req.getContextPath() + "/items?" + (ok ? "msg=Saved" : "error=Save+failed"));
                break;
            }

            case "/items/delete": {
                // Allow ADMIN or STAFF
                HttpSession s = req.getSession(false);
                User u = (s==null) ? null : (User) s.getAttribute("user");
                if (u == null) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                String role = u.getRole();
                if (!"ADMIN".equals(role) && !"STAFF".equals(role)) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN); return;
                }

                int id = parseInt(req.getParameter("id"));

                // If your ItemService exposes deleteSafe: use it (shows friendly message if in-use)
                ItemService.DeleteResult r = svc.deleteSafe(id);
                switch (r) {
                    case OK:
                        resp.sendRedirect(req.getContextPath()+"/items?msg=Deleted");
                        break;
                    case IN_USE:
                        // If your schema uses ON DELETE SET NULL with snapshots, you can allow deletion.
                        // In that case, change ItemService to delete() directly or adapt logic.
                        resp.sendRedirect(req.getContextPath()+"/items?error=Cannot+delete:+item+used+in+bills");
                        break;
                    default:
                        resp.sendRedirect(req.getContextPath()+"/items?error=Delete+failed");
                }
                break;
            }

            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ---- helpers ----
    private int parseInt(String s){ try { return Integer.parseInt(s); } catch(Exception e){ return 0; } }
    private double parseDouble(String s){ try { return Double.parseDouble(s); } catch(Exception e){ return -1; } }
    private String trim(String s){ return (s==null)? null : s.trim(); }

    private String validate(Item i){
        if (i.getName()==null || i.getName().isBlank()) return "Name is required";
        if (i.getUnitPrice() < 0) return "Unit Price must be 0 or more";
        if (i.getStockQty() < 0) return "Stock Qty must be 0 or more";
        return null;
    }

    private Path getUploadBase(HttpServletRequest req){
        String conf = req.getServletContext().getInitParameter("upload.dir");
        if (conf == null || conf.isBlank()) {
            conf = System.getProperty("user.home") + File.separator + "pahanaedu_uploads";
        }
        return Paths.get(conf).toAbsolutePath().normalize();
    }

    private String getExt(String name){
        if (name == null) return "";
        int dot = name.lastIndexOf('.');
        return (dot>=0) ? name.substring(dot) : "";
    }

    private boolean isAllowed(String ext, String mime){
        if (mime == null) mime = "";
        boolean typeOk = mime.startsWith("image/");
        boolean extOk  = ext.toLowerCase().matches("\\.(jpg|jpeg|png|gif)");
        return typeOk && extOk;
    }
}
