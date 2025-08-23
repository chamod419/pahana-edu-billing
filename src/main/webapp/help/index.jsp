<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>PahanaEdu — Help</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    :root{
      /* Brand */
      --deep:#1e3a8a; --mid:#1e293b; --teal:#0f766e; --royal:#2563eb; --emerald:#059669; --gold:#f59e0b;
      /* UI */
      --bg:#f8fafc; --panel:#ffffff; --border:#e5e7eb; --muted:#64748b; --text:#111827;
      /* Effects */
      --radius-xl:20px; --radius-lg:14px; --radius-md:10px;
      --sh1:0 12px 30px rgba(2,6,23,.10), 0 0 0 1px rgba(15,118,110,.06);
      --sh2:0 22px 50px rgba(2,6,23,.16), 0 0 0 1px rgba(30,41,59,.06);
      --focus:0 0 0 3px rgba(15,118,110,.18);
    }
    *{box-sizing:border-box;margin:0;padding:0}
    body{
      font-family:system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,Calibri,sans-serif;
      color:var(--text); background:linear-gradient(135deg, var(--bg) 0%, #e2e8f0 100%);
      padding:24px;
    }
    .container{max-width:1100px;margin:0 auto}
    .hero{
      position:relative; color:#fff; background:linear-gradient(135deg,var(--mid),var(--teal) 55%,var(--deep));
      border-radius:var(--radius-xl); padding:26px 28px; box-shadow:var(--sh1); overflow:hidden;
    }
    .hero::after{
      content:''; position:absolute; inset:0;
      background:linear-gradient(45deg,transparent 30%,rgba(255,255,255,.10) 50%,transparent 70%);
      animation:shimmer 3.2s ease-in-out infinite;
    }
    @keyframes shimmer{0%,100%{transform:translateX(-100%)}50%{transform:translateX(100%)}}
    .hero h1{font-size:28px; letter-spacing:.2px}
    .hero p{opacity:.95; margin-top:6px}
    .logo{
      position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); pointer-events:none;
      width:66px;height:66px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;
      box-shadow:0 10px 26px rgba(0,0,0,.22); padding:10px;
    }
    .grid{display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-top:16px}
    @media (max-width:900px){ .grid{grid-template-columns:1fr} }
    .card{
      background:var(--panel); border:1px solid var(--border); border-radius:16px; padding:18px; box-shadow:var(--sh1);
      transition:transform .15s ease, box-shadow .2s ease;
    }
    .card:hover{ transform:translateY(-2px); box-shadow:var(--sh2); }
    .card h3{font-size:18px; margin-bottom:6px}
    .card p{color:var(--muted)}
    .actions{display:flex; gap:10px; flex-wrap:wrap; margin-top:10px}
    .btn{
      appearance:none; border:1px solid var(--border); background:#fff; color:var(--mid); font-weight:800;
      padding:10px 14px; border-radius:12px; text-decoration:none; display:inline-flex; align-items:center; gap:8px;
      transition:box-shadow .15s ease, transform .1s ease; box-shadow:0 6px 16px rgba(0,0,0,.05);
    }
    .btn:hover{box-shadow:0 10px 24px rgba(0,0,0,.10); transform:translateY(-1px)}
    .btn.primary{color:#fff; border-color:transparent; background:linear-gradient(135deg,var(--teal),var(--emerald))}
    .list{display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:12px}
    @media (max-width:900px){ .list{grid-template-columns:1fr 1fr} }
    @media (max-width:640px){ .list{grid-template-columns:1fr} }
    .chip{display:inline-flex; align-items:center; gap:8px; border:1px solid var(--border); border-radius:999px; padding:10px 12px; font-weight:700; background:#fff}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<div class="container">
  <section class="hero" aria-label="Help">
    <h1>Help Center</h1>
    <p>Clear, practical guidance for Admins and Staff. Searchable, accessible, and quick to scan.</p>
    <div class="logo">
      <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu logo" onerror="this.style.display='none'">
    </div>
  </section>

  <section class="grid" aria-label="Guides">
    <article class="card">
      <h3>Staff Guide</h3>
      <p>Billing workflow, discounts, printing/PDF, and day-to-day tasks. Optimized for speed and clarity.</p>
      <div class="actions">
        <a class="btn primary" href="${ctx}/help/staff.jsp">Open Staff Guide</a>
        <a class="btn" href="${ctx}/billing/new">Go to Billing</a>
      </div>
    </article>
    <article class="card">
      <h3>Admin Guide</h3>
      <p>Users, items, customers, backups, APIs, printers, and deployment checklists.</p>
      <div class="actions">
        <a class="btn primary" href="${ctx}/help/admin.jsp">Open Admin Guide</a>
        <a class="btn" href="${ctx}/dashboard">Dashboard</a>
      </div>
    </article>
  </section>

  <section class="card" style="margin-top:16px" aria-label="Quick links">
    <h3 style="margin-bottom:8px">Quick Links</h3>
    <div class="list">
      <a class="chip" href="${ctx}/items">Items</a>
      <a class="chip" href="${ctx}/customers">Customers</a>
    </div>
  </section>
</div>
</body>
</html>
