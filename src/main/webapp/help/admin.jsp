<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>Admin Help — PahanaEdu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <style>
    :root{
      /* Brand */
      --deep-navy:#1e3a8a; --forest:#166534; --midnight:#1e293b; --teal:#0f766e; --royal:#2563eb;
      --gold:#f59e0b; --emerald:#059669;
      /* UI */
      --ink:#111827; --muted:#64748b; --bg:#f8fafc; --panel:#ffffff; --border:#e5e7eb;
      /* Effects */
      --radius-xl:24px; --radius-lg:16px; --radius-md:12px;
      --shadow-1:0 12px 28px rgba(2,6,23,.10), 0 0 0 1px rgba(30,41,59,.06);
      --shadow-2:0 20px 48px rgba(2,6,23,.16), 0 0 0 1px rgba(30,41,59,.06);
      --focus:0 0 0 3px rgba(15,118,110,.18);
    }

    *{box-sizing:border-box;margin:0;padding:0}
    body{
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Calibri, sans-serif;
      color:var(--ink);
      background: linear-gradient(135deg, var(--bg) 0%, #e2e8f0 100%);
      min-height:100vh; padding:24px;
    }
    a{color:var(--royal); text-decoration:none}
    a:hover{text-decoration:underline}

    .container{max-width:1200px;margin:0 auto}

    /* Header */
    .header{
      position:relative; overflow:hidden; color:#fff;
      background: linear-gradient(135deg, var(--midnight) 0%, var(--teal) 55%, var(--deep-navy) 100%);
      border-radius:var(--radius-xl); padding:22px 24px;
      box-shadow:0 10px 25px rgba(30,41,59,.15), 0 0 0 1px rgba(255,255,255,.08) inset;
    }
    .header::before{
      content:''; position:absolute; inset:0;
      background:linear-gradient(45deg,transparent 30%,rgba(255,255,255,.10) 50%,transparent 70%);
      animation:shimmer 3s ease-in-out infinite;
    }
    @keyframes shimmer{0%,100%{transform:translateX(-100%)}50%{transform:translateX(100%)}}
    .h-inner{position:relative; z-index:1; display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap}
    .title{font-size:24px; font-weight:800; letter-spacing:.2px; display:flex; align-items:center; gap:10px}
    .header-actions{display:flex; gap:8px; flex-wrap:wrap}
    .btn{
      appearance:none; border:1px solid rgba(255,255,255,.35); background:rgba(255,255,255,.18);
      color:#fff; border-radius:12px; padding:10px 14px; font-weight:700; text-decoration:none;
      display:inline-flex; align-items:center; gap:8px; transition:.2s; backdrop-filter: blur(8px);
    }
    .btn:hover{transform:translateY(-1px)}

    .logo-wrap{position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); z-index:0; pointer-events:none}
    .logo{width:64px;height:64px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 8px 20px rgba(0,0,0,.25);padding:8px}
    .logo img{max-width:48px;max-height:48px;display:block;object-fit:contain}

    /* Layout */
    .grid{display:grid; grid-template-columns:2fr 1fr; gap:16px; margin-top:16px}
    @media (max-width: 980px){ .grid{grid-template-columns:1fr} }

    /* Cards */
    .card{
      background:var(--panel); border:1px solid var(--border); border-radius:var(--radius-lg);
      box-shadow:var(--shadow-1); padding:16px; transition:transform .15s ease, box-shadow .2s ease;
    }
    .card:hover{ transform:translateY(-1px); box-shadow:var(--shadow-2); }
    .card h3{margin:0 0 8px 0; font-size:18px; font-weight:800; color:#1e293b}
    .muted{color:var(--muted); font-size:13px}

    /* Enhanced Admin Overview Card */
    .admin-overview {
      background: var(--panel);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-2);
      padding: 24px;
      transition: transform .15s ease, box-shadow .2s ease;
    }

    .admin-overview:hover {
      transform: translateY(-2px);
      box-shadow: 0 25px 50px rgba(2,6,23,.20), 0 0 0 1px rgba(30,41,59,.06);
    }

    .admin-overview h3 {
      margin: 0 0 12px 0;
      font-size: 22px;
      font-weight: 800;
      color: var(--midnight);
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .admin-overview .muted {
      color: var(--muted);
      font-size: 15px;
      margin-bottom: 24px;
      line-height: 1.6;
    }

    /* Enhanced Accordions */
    .enhanced-details {
      border: 1px solid var(--border);
      border-radius: 14px;
      padding: 0;
      margin: 14px 0;
      background: #fff;
      box-shadow: 0 4px 12px rgba(2,6,23,.08), 0 0 0 1px rgba(30,41,59,.03);
      overflow: hidden;
      transition: all .2s ease;
    }

    .enhanced-details:hover {
      border-color: var(--teal);
      box-shadow: 0 8px 20px rgba(2,6,23,.12), 0 0 0 1px var(--teal);
    }

    .enhanced-summary {
      list-style: none;
      cursor: pointer;
      font-weight: 700;
      color: var(--midnight);
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 18px 20px;
      background: linear-gradient(135deg, #fff 0%, #f8fafc 100%);
      border-bottom: 1px solid var(--border);
      transition: all .2s ease;
      user-select: none;
    }

    .enhanced-summary:hover {
      background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    }

    .enhanced-summary::-webkit-details-marker { display: none; }

    .summary-icon {
      width: 36px;
      height: 36px;
      background: linear-gradient(135deg, var(--teal) 0%, var(--deep-navy) 100%);
      color: #fff;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 16px;
      flex-shrink: 0;
      box-shadow: 0 4px 8px rgba(15,118,110,.3);
    }

    .summary-chevron {
      margin-left: auto;
      transition: transform .2s ease;
      color: var(--teal);
      font-size: 14px;
    }

    .enhanced-details[open] .summary-chevron {
      transform: rotate(90deg);
    }

    .enhanced-content {
      padding: 20px;
      background: #fefefe;
    }

    .enhanced-content ul {
      margin: 0;
      margin-left: 0;
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .enhanced-content li {
      margin: 0;
      padding: 14px 16px;
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 10px;
      display: flex;
      align-items: flex-start;
      gap: 12px;
      transition: all .2s ease;
      box-shadow: 0 1px 3px rgba(0,0,0,.05);
    }

    .enhanced-content li:hover {
      border-color: var(--teal);
      box-shadow: 0 2px 8px rgba(15,118,110,.15);
      transform: translateX(4px);
    }

    .enhanced-content li::before {
      content: '●';
      color: var(--teal);
      font-weight: bold;
      flex-shrink: 0;
      margin-top: 2px;
    }

    /* Enhanced Quick Links Sidebar */
    .enhanced-sidebar {
      background: var(--panel);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-2);
      padding: 0;
      overflow: hidden;
      transition: transform .15s ease, box-shadow .2s ease;
    }

    .enhanced-sidebar:hover {
      transform: translateY(-2px);
      box-shadow: 0 25px 50px rgba(2,6,23,.20), 0 0 0 1px rgba(30,41,59,.06);
    }

    .sidebar-header {
      background: linear-gradient(135deg, var(--teal) 0%, var(--deep-navy) 100%);
      color: #fff;
      padding: 20px;
      font-size: 18px;
      font-weight: 800;
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .sidebar-content {
      padding: 20px;
    }

    .enhanced-links {
      list-style: none;
      margin: 0;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .enhanced-links li {
      margin: 0;
    }

    .enhanced-links a {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 14px 16px;
      color: var(--midnight);
      text-decoration: none;
      border-radius: 12px;
      transition: all .2s ease;
      font-weight: 600;
      background: #fff;
      border: 1px solid var(--border);
    }

    .enhanced-links a:hover {
      background: linear-gradient(135deg, var(--teal) 0%, var(--deep-navy) 100%);
      color: #fff;
      transform: translateX(6px);
      box-shadow: 0 4px 12px rgba(15,118,110,.3);
    }

    .enhanced-links a i {
      width: 20px;
      color: var(--teal);
      transition: color .2s ease;
    }

    .enhanced-links a:hover i {
      color: #fff;
    }

    /* Code blocks / labels */
    pre, code{
      background:#0b1220; color:#e2e8f0; border-radius:10px; overflow:auto;
      font-family: ui-monospace, Menlo, Consolas, monospace;
    }
    pre{padding:12px; font-size:13px; line-height:1.5}
    code.inline{padding:2px 6px}

    .pill{
      display:inline-block; padding:4px 10px; border-radius:999px; font-weight:800; font-size:12px;
      background:#eef2ff; border:1px solid #dbeafe; color:#1e3a8a;
    }

    /* Regular accordions (keep original style for others) */
    details{
      border:1px solid var(--border); border-radius:12px; padding:12px; margin:10px 0; background:#fff;
      box-shadow:0 1px 0 rgba(2,6,23,.02);
    }
    summary{
      list-style:none; cursor:pointer; font-weight:800; color:#0f172a; display:flex; align-items:center; gap:8px;
    }
    summary::-webkit-details-marker{display:none}
    summary::after{content:'▸'; margin-left:auto; transition: transform .2s ease}
    details[open] summary::after{transform:rotate(90deg)}

    /* Lists */
    ul{margin-top:8px; margin-left:18px}
    li{margin:6px 0}

    /* Utilities */
    .space-y > * + *{margin-top:12px}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="container">
  <!-- Header -->
  <header class="header" aria-label="Admin Help header">
    <div class="h-inner">
      <div class="title">🛠️ Admin Help Center</div>
      <nav class="header-actions" aria-label="Header actions">
        <a class="btn" href="${ctx}/help/index.jsp">❓ Help Home</a>
        <a class="btn" href="${ctx}/dashboard">🏠 Dashboard</a>
      </nav>
    </div>
    <div class="logo-wrap">
      <div class="logo">
        <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu"
             onerror="this.style.display='none'; this.parentNode.innerHTML='<strong>PE</strong>';">
      </div>
    </div>
  </header>

  <!-- Content -->
  <div class="grid">
    <!-- MAIN -->
    <main class="admin-overview" id="main">
      <h3><i class="fas fa-traffic-light"></i> Admin Overview</h3>
      <p class="muted">A comprehensive guide for daily operations, configuration, and troubleshooting with enhanced professional interface.</p>

      <section class="space-y" aria-label="Admin topics">
        <details open id="items-stock" class="enhanced-details">
          <summary class="enhanced-summary">
            <div class="summary-icon">
              <i class="fas fa-boxes"></i>
            </div>
            Items & Stock — best practices
            <i class="fas fa-chevron-right summary-chevron"></i>
          </summary>
          <div class="enhanced-content">
            <ul>
              <li><strong>Auto status:</strong> <code class="inline">stockQty &gt; 0</code> → <span class="pill">ACTIVE</span>; <code class="inline">stockQty = 0</code> → Inactive UI state.</li>
              <li><strong>Images:</strong> upload ≤ <strong>5 MB</strong> (JPG/PNG/GIF). Shown in lists and receipts.</li>
              <li><strong>Categories:</strong> Stationery / Accessories / Books / Printing / Services (can be updated in the JSP source).</li>
            </ul>
          </div>
        </details>

        <details id="customers" class="enhanced-details">
          <summary class="enhanced-summary">
            <div class="summary-icon">
              <i class="fas fa-users"></i>
            </div>
            Customers — data quality
            <i class="fas fa-chevron-right summary-chevron"></i>
          </summary>
          <div class="enhanced-content">
            <ul>
              <li>Validate phone numbers (digits, <code class="inline">+</code>, <code class="inline">-</code>, spaces; 7–20 chars).</li>
              <li>Account Number is optional. If left blank, the backend can auto-generate (e.g., <code class="inline">C-0007</code>).</li>
              <li>Status filtering: <strong>ACTIVE</strong> / <strong>INACTIVE</strong> available in list pages.</li>
            </ul>
          </div>
        </details>

        <details id="billing" class="enhanced-details">
          <summary class="enhanced-summary">
            <div class="summary-icon">
              <i class="fas fa-receipt"></i>
            </div>
            Billing — finalize & receipts
            <i class="fas fa-chevron-right summary-chevron"></i>
          </summary>
          <div class="enhanced-content">
            <ul>
              <li><strong>Discount:</strong> choose <em>Amount</em> or <em>Percentage</em>; discount is capped at Subtotal.</li>
              <li><strong>Payment methods:</strong> CASH, CARD, ONLINE.</li>
              <li><strong>Receipts:</strong> Browser Print / Preview PDF / Download PDF / Print to POS.</li>
            </ul>
          </div>
        </details>

        <details id="reports" class="enhanced-details">
          <summary class="enhanced-summary">
            <div class="summary-icon">
              <i class="fas fa-chart-bar"></i>
            </div>
            KPIs & Reports (API)
            <i class="fas fa-chevron-right summary-chevron"></i>
          </summary>
          <div class="enhanced-content">
            <div style="margin-top:8px">
              <p>Common, read-only endpoints (authenticated session required):</p>
<pre>
GET ${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/api/status
GET ${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/api/reports/summary?from=YYYY-MM-DD&amp;to=YYYY-MM-DD
</pre>
              <p class="muted">Full reference: <a href="${ctx}/api/help" target="_blank" rel="noopener">API Help</a></p>
            </div>
          </div>
        </details>

        <details id="printing" class="enhanced-details">
          <summary class="enhanced-summary">
            <div class="summary-icon">
              <i class="fas fa-print"></i>
            </div>
            POS & PDF printing
            <i class="fas fa-chevron-right summary-chevron"></i>
          </summary>
          <div class="enhanced-content">
            <ul>
              <li><strong>POS Print:</strong> the printer name must match the OS printer queue on the server.</li>
              <li>If POS printing isn't available, use the PDF endpoints as a reliable fallback.</li>
            </ul>
          </div>
        </details>

        <details id="server-config" class="enhanced-details">
          <summary class="enhanced-summary">
            <div class="summary-icon">
              <i class="fas fa-cog"></i>
            </div>
            Server configuration (uploads & logo)
            <i class="fas fa-chevron-right summary-chevron"></i>
          </summary>
          <div class="enhanced-content">
            <ul>
              <li><strong>Uploads base folder:</strong> set in <span class="pill">WEB-INF/web.xml</span> via
                <code class="inline">&lt;param-name&gt;upload.dir&lt;/param-name&gt;</code>.</li>
              <li><strong>Logo path:</strong> <code class="inline">/images/Pahanaedu.png</code>.
                If missing, the UI shows the "PE" fallback badge automatically.</li>
            </ul>
          </div>
        </details>

        <details id="roles" class="enhanced-details">
          <summary class="enhanced-summary">
            <div class="summary-icon">
              <i class="fas fa-shield-alt"></i>
            </div>
            Roles & sessions
            <i class="fas fa-chevron-right summary-chevron"></i>
          </summary>
          <div class="enhanced-content">
            <ul>
              <li>UI roles: <span class="pill">ADMIN</span> and <span class="pill">STAFF</span> (see <code class="inline">sessionScope.user.role</code> usage in JSPs).</li>
              <li>For stricter access control, ensure your Auth Filter blocks unauthenticated access to protected JSP routes.</li>
            </ul>
          </div>
        </details>

        <details id="troubleshooting" class="enhanced-details">
          <summary class="enhanced-summary">
            <div class="summary-icon">
              <i class="fas fa-wrench"></i>
            </div>
            Troubleshooting
            <i class="fas fa-chevron-right summary-chevron"></i>
          </summary>
          <div class="enhanced-content">
            <ul>
              <li><strong>Images not loading:</strong> verify <code class="inline">upload.dir</code> exists, the app has read permissions, and the saved filename is correct.</li>
              <li><strong>MySQL connectivity:</strong> confirm JDBC URL/credentials and that the MySQL driver (mysql-connector-j) is present.</li>
              <li><strong>PDF errors:</strong> iText 7 is included; verify fonts and write permissions. Consider PDFBox/OpenPDF if license requirements differ.</li>
            </ul>
          </div>
        </details>
      </section>
    </main>

    <!-- SIDE -->
    <aside class="enhanced-sidebar" aria-label="Quick resources">
      <div class="sidebar-header">
        <i class="fas fa-link"></i> Quick Links
      </div>
      <div class="sidebar-content">
        <ul class="enhanced-links">
          <li><a href="${ctx}/items"><i class="fas fa-box"></i>Manage Items</a></li>
          <li><a href="${ctx}/customers"><i class="fas fa-users"></i>Manage Customers</a></li>
          <li><a href="${ctx}/billing/new"><i class="fas fa-file-invoice"></i>Generate Bill</a></li>
          <li><a href="${ctx}/api/help" target="_blank" rel="noopener"><i class="fas fa-code"></i>API Help</a></li>
        </ul>

        <div style="margin-top:20px">
          <h3 style="display:flex;align-items:center;gap:8px;color:var(--midnight);font-size:16px;margin-bottom:12px;">
            <i class="fas fa-terminal" style="color:var(--teal);"></i> cURL Samples
          </h3>
<pre>
# Use while authenticated (same browser session cookie)
curl -s "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/api/items?active=true&amp;limit=5"
curl -s "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/api/reports/summary?from=2025-01-01&amp;to=2025-01-31"
</pre>
        </div>

        <div style="margin-top:20px">
          <h3 style="display:flex;align-items:center;gap:8px;color:var(--midnight);font-size:16px;margin-bottom:12px;">
            <i class="fas fa-question-circle" style="color:var(--teal);"></i> FAQ
          </h3>
          <details>
            <summary>Is API CORS enabled?</summary>
            <div style="margin-top:6px">Yes. See <a href="${ctx}/api/help" target="_blank" rel="noopener">API Help</a> for details.</div>
          </details>
          <details>
            <summary>How do I change the logo?</summary>
            <div style="margin-top:6px">Replace <code class="inline">/images/Pahanaedu.png</code>. The UI will fall back to "PE" text if the image is not found.</div>
          </details>
          <details>
            <summary>Where is the upload folder?</summary>
            <div style="margin-top:6px">Configured in <code class="inline">WEB-INF/web.xml</code> under
              <code class="inline">&lt;param-name&gt;upload.dir&lt;/param-name&gt;</code>.</div>
          </details>
        </div>
      </div>
    </aside>
  </div>
</div>
</body>
</html>