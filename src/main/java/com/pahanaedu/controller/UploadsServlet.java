package com.pahanaedu.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@WebServlet("/uploads/*")
public class UploadsServlet extends HttpServlet {
    private Path baseDir;

    @Override
    public void init() throws ServletException {
        String conf = getServletContext().getInitParameter("upload.dir");
        if (conf == null || conf.isBlank()) {
            conf = System.getProperty("user.home") + File.separator + "pahanaedu_uploads";
        }
        baseDir = Paths.get(conf).toAbsolutePath().normalize();
        try { Files.createDirectories(baseDir); } catch (IOException ignored) {}
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String rel = req.getPathInfo(); // /items/abc.jpg
        if (rel == null || rel.contains("..")) { resp.sendError(404); return; }
        Path file = baseDir.resolve(rel.substring(1)).normalize(); // strip leading '/'
        if (!file.startsWith(baseDir) || !Files.exists(file)) { resp.sendError(404); return; }

        String mime = getServletContext().getMimeType(file.getFileName().toString());
        if (mime == null) mime = "application/octet-stream";
        resp.setContentType(mime);
        resp.setHeader("Cache-Control", "public, max-age=86400");
        try (OutputStream os = resp.getOutputStream()) { Files.copy(file, os); }
    }
}
