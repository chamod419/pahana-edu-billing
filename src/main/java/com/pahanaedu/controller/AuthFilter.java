package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Set;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final Set<String> PUBLIC_PATHS = Set.of(
        "/", "/index.jsp", "/login", "/login.jsp", "/favicon.ico"
    );

    private static final String[] PUBLIC_PREFIXES = {
        "/css/", "/js/", "/images/", "/assets/", "/webjars/"
    };

    private boolean isPublic(String path) {
        if (PUBLIC_PATHS.contains(path)) return true;
        for (String p : PUBLIC_PREFIXES) if (path.startsWith(p)) return true;
        return false; // IMPORTANT: keep false here
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String ctx = req.getContextPath();
        String path = req.getServletPath();
        if (path == null || path.isEmpty()) path = "/";

        HttpSession session = req.getSession(false);
        User u = (session == null) ? null : (User) session.getAttribute("user");

        // Public resources
        if (isPublic(path)) {
            if (u != null && ("/".equals(path) || "/index.jsp".equals(path) || "/login".equals(path) || "/login.jsp".equals(path))) {
                resp.sendRedirect(ctx + "/dashboard");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Require login
        if (u == null) {
            String next = req.getRequestURI().substring(ctx.length());
            String qs = req.getQueryString();
            if (qs != null) next += "?" + qs;
            resp.sendRedirect(ctx + "/login?next=" + java.net.URLEncoder.encode(next, java.nio.charset.StandardCharsets.UTF_8));
            return;
        }

        // Role checks
        if (path.startsWith("/admin/") && !"ADMIN".equals(u.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (path.startsWith("/staff/") && !("STAFF".equals(u.getRole()) || "ADMIN".equals(u.getRole()))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }
}