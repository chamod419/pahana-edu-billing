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

@MultipartConfig(
        fileSizeThreshold = 1 * 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
@WebServlet(urlPatterns = {
        "/items", "/items/new", "/items/edit", "/items/save", "/items/delete"
})
public class ItemController extends HttpServlet {
    private final ItemService svc = new ItemService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        switch (path) {
            case "/items":
                List<Item> all = svc.list();
                req.setAttribute("list", all);
                req.getRequestDispatcher("/items/list.jsp").forward(req, resp);
                break;

            case "/items/new":
                req.setAttribute("mode", "create");
                req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
                break;

            case "/items/edit":
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
                i.setCategory(trim(req.getParameter("category"))); // from dropdown
                i.setDescription(trim(req.getParameter("description")));
                i.setActive("ACTIVE".equalsIgnoreCase(trim(req.getParameter("status"))));

                // validate first
                String err = validate(i);
                if (err != null) {
                    req.setAttribute("error", err);
                    req.setAttribute("i", i);
                    req.setAttribute("mode", (i.getItemId()==0) ? "create" : "edit");
                    req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
                    return;
                }

                // file upload only (no manual URL)
                Part part = null;
                try { part = req.getPart("imageFile"); } catch (Exception ignored) {}
                if (part != null && part.getSize() > 0) {
                    String submitted = part.getSubmittedFileName();
                    String ext = getExt(submitted);
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
                    String filename = "item_" + UUID.randomUUID() + ext;
                    Path target = base.resolve(filename);

                    try (InputStream in = part.getInputStream()) {
                        Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
                    }
                    i.setImageUrl("items/" + filename); // stored relative to /uploads
                } else {
                    // keep current file (edit mode) if provided
                    String keep = trim(req.getParameter("existingImage"));
                    i.setImageUrl((keep == null || keep.isBlank()) ? null : keep);
                }

                boolean ok = svc.save(i);
                resp.sendRedirect(req.getContextPath() + "/items?" + (ok ? "msg=Saved" : "error=Save+failed"));
                break;
            }

            case "/items/delete": {
                HttpSession s = req.getSession(false);
                User u = (s==null) ? null : (User) s.getAttribute("user");
                if (u == null || !"ADMIN".equals(u.getRole())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                int id = parseInt(req.getParameter("id"));
                boolean ok = svc.delete(id);
                resp.sendRedirect(req.getContextPath() + "/items?" + (ok ? "msg=Deleted" : "error=Delete+failed"));
                break;
            }

            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // helpers
    private int parseInt(String s){ try { return Integer.parseInt(s); } catch(Exception e){ return 0; } }
    private double parseDouble(String s){ try { return Double.parseDouble(s); } catch(Exception e){ return -1; } }
    private String trim(String s){ return (s==null)? null : s.trim(); }

    private String validate(Item i){
        if (i.getName()==null || i.getName().isBlank()) return "Name is required";
        if (i.getUnitPrice() < 0) return "Unit Price must be 0 or more";
        if (i.getStockQty() < 0) return "Stock Qty must be 0 or more";
        // category optional, but you can enforce one of the 5 if you like
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
        return (dot>=0) ? name.substring(dot).toLowerCase() : "";
    }
    private boolean isAllowed(String ext, String mime){
        if (mime == null) mime = "";
        boolean typeOk = mime.startsWith("image/");
        boolean extOk = ext.matches("\\.(jpg|jpeg|png|gif)");
        return typeOk && extOk;
    }
}
