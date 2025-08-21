<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>PahanaEdu API Help</title>
  <style>
    body{font-family:system-ui,Segoe UI,Arial; margin:24px; color:#1f2937; background:#f8fafc}
    h1{margin:0 0 6px 0}
    .muted{color:#64748b}
    .card{background:#fff; border:1px solid #e5e7eb; border-radius:12px; padding:16px; margin:12px 0;}
    code,pre{background:#0f172a; color:#e2e8f0; padding:10px; border-radius:8px; display:block; overflow:auto}
    kbd{border:1px solid #cbd5e1; padding:2px 6px; border-radius:6px; background:#f1f5f9}
    table{border-collapse:collapse; width:100%; margin-top:8px}
    th,td{border:1px solid #e5e7eb; padding:8px; text-align:left}
    .tag{display:inline-block; font-size:12px; padding:2px 8px; border-radius:999px; background:#dbeafe; color:#1d4ed8; margin-left:6px}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<h1>PahanaEdu API <span class="tag">v1</span></h1>
<p class="muted">Base URL: <strong>${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/api</strong></p>

<div class="card">
  <h3>Authentication</h3>
  <p>Most endpoints require a logged-in session (uses the same web login). Public endpoints: <code>GET /api/ping</code>, this help page.</p>
  <p>To test protected endpoints quickly: login in a browser tab, then open endpoints in the same browser.</p>
</div>

<div class="card">
  <h3>Endpoints</h3>
  <table>
    <thead><tr><th>Method</th><th>Path</th><th>Description</th><th>Query / Notes</th></tr></thead>
    <tbody>
      <tr><td>GET</td><td>/ping</td><td>Health check (public)</td><td>-</td></tr>
      <tr><td>GET</td><td>/status</td><td>KPIs (global for ADMIN / scoped for STAFF)</td><td>-</td></tr>
      <tr><td>GET</td><td>/items</td><td>List items</td><td><code>?active=true|false</code>, <code>?q=</code>, <code>?limit=</code></td></tr>
      <tr><td>GET</td><td>/items/{id}</td><td>Get single item</td><td>-</td></tr>
      <tr><td>GET</td><td>/customers</td><td>List/search customers</td><td><code>?q=</code>, <code>?limit=</code></td></tr>
      <tr><td>GET</td><td>/customers/{id}</td><td>Get single customer</td><td>-</td></tr>
      <tr><td>GET</td><td>/bills/{id}</td><td>Get bill + items</td><td>-</td></tr>
      <tr><td>GET</td><td>/reports/summary</td><td>Sales summary</td><td><code>?from=YYYY-MM-DD&amp;to=YYYY-MM-DD</code></td></tr>
    </tbody>
  </table>
</div>

<div class="card">
  <h3>Quick Examples (curl)</h3>
<pre>curl -s ${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/api/ping

# after logging in (cookie session)
curl -s "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/api/items?active=true&amp;limit=5"
curl -s "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/api/bills/1"
curl -s "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/api/reports/summary?from=2025-01-01&amp;to=2025-01-31"
</pre>
</div>

<div class="card">
  <h3>Notes</h3>
  <ul>
    <li>All numbers are returned with 2-decimal precision where relevant.</li>
    <li>Date/time fields use ISO-8601.</li>
    <li>CORS is enabled for <code>/api/*</code> so you can call from a mobile/SPA.</li>
  </ul>
</div>

</body>
</html>
