package com.pahanaedu.controller;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name="LogoutController", urlPatterns={"/logout"})
public class LogoutController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s != null) s.invalidate();

        // (Optional) clear JSESSIONID cookie for good measure
        Cookie c = new Cookie("JSESSIONID", "");
        String ctx = req.getContextPath();
        c.setPath((ctx == null || ctx.isEmpty()) ? "/" : ctx);
        c.setMaxAge(0);
        resp.addCookie(c);

        resp.sendRedirect((ctx == null ? "" : ctx) + "/login.jsp?msg=Logged+out");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doGet(req, resp);
    }
}
