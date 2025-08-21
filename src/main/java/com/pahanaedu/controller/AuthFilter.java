package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Set;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final Set<String> PUBLIC_PATHS = Set.of(
        "/", "/index.jsp", "/login", "/login.jsp", "/logout", "/favicon.ico",
        // API docs & health are public
        "/api/help", "/api/ping"
    );

    private static final String[] PUBLIC_PREFIXES = {
        "/css/", "/js/", "/images/", "/assets/", "/webjars/", "/uploads/",
        // if you ever add more public JSON under here
        "/api/public/"
    };

    private boolean isPublicSimple(String path) {
        if (PUBLIC_PATHS.contains(path)) return true;
        for (String p : PUBLIC_PREFIXES) if (path.startsWith(p)) return true;
        return false;
    }

    private static void writeJson(HttpServletResponse resp, int code, String body) throws IOException {
        resp.setStatus(code);
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.getWriter().write(body);
    }

    private static void corsHeaders(HttpServletResponse resp) {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        final String method = req.getMethod();
        final String ctx    = req.getContextPath();                 // e.g. /pahana-edu-billing-system
        String path         = req.getServletPath();                 // e.g. /api, /login, /admin/...
        if (path == null || path.isEmpty()) path = "/";
        final String uri    = req.getRequestURI().substring(ctx.length()); // e.g. /api/ping, /admin/users

        // Handle CORS preflight for API
        if ("OPTIONS".equalsIgnoreCase(method) && (uri.equals("/api") || uri.startsWith("/api/"))) {
            corsHeaders(resp);
            resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
            return;
        }

        // Public (static + login + api/help + api/ping)
        if (isPublicSimple(uri) || isPublicSimple(path)) {
            // If already logged in and trying to access login/index, push to dashboard
            HttpSession session = req.getSession(false);
            User u = (session == null) ? null : (User) session.getAttribute("user");
            boolean logoutViaLogin = "/login".equals(path) && "logout".equals(req.getParameter("action"));
            if (u != null && !logoutViaLogin &&
                ("/".equals(uri) || "/index.jsp".equals(uri) || "/login".equals(uri) || "/login.jsp".equals(uri))) {
                resp.sendRedirect(ctx + "/dashboard");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Session user
        HttpSession session = req.getSession(false);
        User u = (session == null) ? null : (User) session.getAttribute("user");

        // If it's an API call (but not public), respond JSON 401 instead of redirecting
        boolean isApi = uri.equals("/api") || uri.startsWith("/api/");
        if (u == null) {
            if (isApi) {
                corsHeaders(resp);
                writeJson(resp, HttpServletResponse.SC_UNAUTHORIZED, "{\"error\":\"Unauthorized\"}");
                return;
            } else {
                String next = req.getRequestURI().substring(ctx.length());
                String qs = req.getQueryString();
                if (qs != null) next += "?" + qs;
                String encNext = java.net.URLEncoder.encode(next, StandardCharsets.UTF_8);
                resp.sendRedirect(ctx + "/login?next=" + encNext);
                return;
            }
        }

        // Role-based guards for web UIs
        if (uri.startsWith("/admin/") && !"ADMIN".equals(u.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (uri.startsWith("/staff/") && !("STAFF".equals(u.getRole()) || "ADMIN".equals(u.getRole()))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Allow through
        chain.doFilter(request, response);
    }
}
