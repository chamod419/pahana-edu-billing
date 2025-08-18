package com.pahanaedu.controller;

import com.pahanaedu.model.Item;
import com.pahanaedu.model.User;
import com.pahanaedu.service.ItemService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

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
                i.setCategory(trim(req.getParameter("category")));
                i.setDescription(trim(req.getParameter("description")));
                i.setImageUrl(trim(req.getParameter("imageUrl")));
                i.setActive("ACTIVE".equalsIgnoreCase(trim(req.getParameter("status"))));

                String err = validate(i);
                if (err != null) {
                    req.setAttribute("error", err);
                    req.setAttribute("i", i);
                    req.setAttribute("mode", (i.getItemId()==0) ? "create" : "edit");
                    req.getRequestDispatcher("/items/form.jsp").forward(req, resp);
                    return;
                }

                boolean ok = svc.save(i);
                resp.sendRedirect(req.getContextPath() + "/items?" + (ok ? "msg=Saved" : "error=Save+failed"));
                break;
            }

            case "/items/delete": {
                // Admin-only delete
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

    // --- helpers ---
    private int parseInt(String s){ try { return Integer.parseInt(s); } catch(Exception e){ return 0; } }
    private double parseDouble(String s){ try { return Double.parseDouble(s); } catch(Exception e){ return -1; } }
    private String trim(String s){ return (s==null)? null : s.trim(); }

    private String validate(Item i){
        if (i.getName()==null || i.getName().isBlank()) return "Name is required";
        if (i.getUnitPrice() < 0) return "Unit Price must be 0 or more";
        if (i.getStockQty() < 0) return "Stock Qty must be 0 or more";
        return null;
    }
}
