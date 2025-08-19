<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Items - PahanaEdu</title>
  <style>
    :root{
      --deep-navy:#1e3a8a; --forest:#166534; --midnight:#1e293b; --teal:#0f766e; --royal:#2563eb;
      --gold:#f59e0b; --emerald:#059669; --orange:#ea580c;
      --lg:#f8fafc; --border:#e5e7eb; --muted:#94a3b8;
      --charcoal:#374151; --dark:#1f2937;
      --radius-xl:24px; --radius-lg:16px;
      --shadow-1:0 10px 25px rgba(0,0,0,.08), 0 0 0 1px rgba(0,0,0,.02);
    }
    *{box-sizing:border-box;margin:0;padding:0}
    body{
      font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color:var(--charcoal);
      background:linear-gradient(135deg, var(--lg) 0%, #e2e8f0 100%);
      min-height:100vh; padding:24px; position:relative; overflow-x:hidden;
    }
    body::before{
      content:''; position:fixed; inset:0; pointer-events:none; z-index:-1;
      background:url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60"><defs><pattern id="p" width="22" height="22" patternUnits="userSpaceOnUse"><circle cx="11" cy="11" r="1" fill="rgba(15,118,110,0.05)"/></pattern></defs><rect width="100%" height="100%" fill="url(%23p)"/></svg>');
    }
    .container{max-width:1200px;margin:0 auto}

    /* Header */
    .header{
      background:linear-gradient(135deg, var(--midnight) 0%, var(--teal) 50%, var(--deep-navy) 100%);
      color:#fff;border-radius:var(--radius-xl);padding:24px 28px;margin-bottom:18px;position:relative;overflow:hidden;
      box-shadow:0 10px 25px rgba(30,41,59,.15), 0 0 0 1px rgba(255,255,255,.08) inset;
    }
    .header::before{content:'';position:absolute;inset:0;background:linear-gradient(45deg,transparent 30%,rgba(255,255,255,.10) 50%,transparent 70%);animation:shimmer 3s ease-in-out infinite}
    @keyframes shimmer{0%,100%{transform:translateX(-100%)}50%{transform:translateX(100%)}}
    .header-content{position:relative;z-index:1;display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap}
    .title{font-size:28px;font-weight:800;display:flex;align-items:center;gap:12px}
    .stats-badge{background:rgba(245,158,11,.15);color:#f59e0b;font-size:14px;font-weight:700;padding:4px 12px;border-radius:20px;border:1px solid rgba(245,158,11,.3)}
    .btn{appearance:none;border:1px solid rgba(255,255,255,.35);background:rgba(255,255,255,.18);color:#fff;border-radius:12px;padding:12px 18px;font-weight:700;text-decoration:none;display:inline-flex;align-items:center;gap:8px;transition:.2s;backdrop-filter:blur(8px)}
    .btn:hover{transform:translateY(-1px)}
    .btn-primary{background:linear-gradient(135deg,#1e293b 0%,#0f766e 60%,#2563eb 100%);color:#fff;border:none;box-shadow:0 6px 16px rgba(15,118,110,.30)}
    .header-center{position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);z-index:2;pointer-events:none}
    .logo{width:64px;height:64px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 8px 20px rgba(0,0,0,.25);padding:8px}
    .logo img{max-width:48px;max-height:48px;display:block;object-fit:contain}

    /* Toolbar */
    .controlbar{background:#fff;border:1px solid var(--border);border-radius:16px;padding:12px;display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;box-shadow:0 10px 25px rgba(0,0,0,.04);margin-bottom:14px}
    .cb-left,.cb-right{display:flex;gap:12px;flex-wrap:wrap;align-items:center}
    .input-group{display:flex;align-items:center;height:46px;border:1px solid var(--border);border-radius:12px;background:#fff;overflow:hidden}
    .ig-icon{display:inline-flex;align-items:center;justify-content:center;width:46px;height:46px;border-right:1px solid var(--border);color:#475569;background:#fafafa}
    .ig-input{border:0;outline:0;height:46px;padding:0 14px;min-width:320px;font-size:14px;color:#1f2937}
    .ig-input::placeholder{color:var(--muted)}
    .ig-btn{height:46px;border:0;padding:0 16px;font-weight:700;background:#f8fafc;color:#1f2937;cursor:pointer;border-left:1px solid var(--border)}
    .ig-btn:hover{background:#f1f5f9}
    .ig-btn.ghost{background:#fff}
    .ig-btn.ghost:hover{background:#f8fafc}
    .seg{display:inline-flex;border:1px solid var(--border);border-radius:12px;overflow:hidden;background:#fff;height:46px}
    .seg button{appearance:none;border:0;padding:0 16px;font-weight:700;background:#fff;color:#1f2937;cursor:pointer;border-right:1px solid var(--border)}
    .seg button:last-child{border-right:0}
    .seg button.active{background:#f0fdfa;color:#0f766e}
    .select{height:46px;border:1px solid var(--border);border-radius:12px;padding:0 12px;font-weight:700;background:#fff;color:#1f2937}

    /* Messages */
    .flash{padding:12px 14px;border-radius:12px;font-weight:700;display:flex;gap:12px;align-items:center;margin:12px 0}
    .ok{background:linear-gradient(135deg,#dcfce7,#bbf7d0);color:#166534;border:1px solid #bbf7d0}
    .err{background:linear-gradient(135deg,#fee2e2,#fecaca);color:#dc2626;border:1px solid #fecaca}

    /* Table card */
    .card{background:#fff;border:1px solid var(--border);border-radius:20px;box-shadow:var(--shadow-1);overflow:hidden;position:relative}
    .card::before{content:'';position:absolute;left:0;right:0;top:0;height:3px;background:linear-gradient(90deg,#1e293b,#0f766e,#1e3a8a,#166534);background-size:200% 100%;animation:bar 4s ease infinite}
    @keyframes bar{0%,100%{background-position:0% 50%}50%{background-position:100% 50%}}
    .table-wrap{overflow:auto}
    table{width:100%;border-collapse:collapse}
    thead th{background:#f8fafc;color:#374151;font-weight:800;text-transform:uppercase;letter-spacing:.5px;font-size:12px;padding:18px 20px;border-bottom:2px solid #e5e7eb;position:sticky;top:0;z-index:1;text-align:left}
    tbody td{padding:18px 20px;border-top:1px solid #f1f5f9;font-size:14px;vertical-align:middle}
    tbody tr:nth-child(even){background:#fcfdff}
    tbody tr:hover{background:#f7fafc}
    .cell-right{text-align:right;white-space:nowrap}
    .id-chip{font-family:ui-monospace,Menlo,Monaco,Consolas,monospace;background:#f1f5f9;color:#64748b;padding:6px 10px;border-radius:8px;font-size:12px;font-weight:800;border:1px solid #e2e8f0}
    .pill{display:inline-flex;align-items:center;gap:6px;border:1px solid;padding:6px 10px;border-radius:999px;font-weight:800;font-size:12px}
    .on{background:#eaf7ef;border-color:#cfe9d8;color:#0b6b2c}
    .off{background:#f3f4f6;border-color:#e5e7eb;color:#374151}
    .cat-pill{background:#eef2ff;border:1px solid #dbeafe;color:#1e3a8a;border-radius:999px;padding:6px 10px;font-weight:700;font-size:12px;display:inline-block}
    .stock-badge{border-radius:10px;padding:6px 10px;font-weight:800;font-size:12px;display:inline-block}
    .stock-badge.ok{background:#ecfdf5;color:#065f46;border:1px solid #a7f3d0}
    .stock-badge.warn{background:#fff7ed;color:#9a3412;border:1px solid #fed7aa}
    .stock-badge.low{background:#fef2f2;color:#991b1b;border:1px solid #fecaca}
    .thumb{width:44px;height:44px;border-radius:10px;object-fit:cover;border:1px solid #e5e7eb;background:#f8fafc;cursor:pointer;transition:transform .15s ease}
    .thumb:hover{transform:scale(1.06)}
    .desc{max-width:460px;white-space:pre-wrap}
    .row-actions{display:flex;gap:10px;flex-wrap:wrap}
    .row-actions a{text-decoration:none}
    .btn-edit{appearance:none;border:none;color:#fff;font-weight:700;cursor:pointer;background:linear-gradient(135deg,#0f766e 0%,#059669 100%);padding:10px 14px;border-radius:10px;display:inline-flex;align-items:center;gap:8px;box-shadow:0 4px 12px rgba(15,118,110,.25);transition:.2s}
    .btn-edit:hover{transform:translateY(-1px);box-shadow:0 6px 16px rgba(15,118,110,.32)}
    .btn-delete{appearance:none;border:none;color:#fff;font-weight:700;cursor:pointer;background:linear-gradient(135deg,#dc2626 0%,#ef4444 100%);padding:10px 14px;border-radius:10px;display:inline-flex;align-items:center;gap:8px;box-shadow:0 4px 12px rgba(220,38,38,.25);transition:.2s}
    .btn-delete:hover{transform:translateY(-1px);box-shadow:0 6px 16px rgba(220,38,38,.32)}
    .btn-delete:disabled{background:#e5e7eb;color:#9ca3af;cursor:not-allowed;box-shadow:none;transform:none}

    /* Lightbox */
    .lightbox{position:fixed;inset:0;background:rgba(0,0,0,.6);display:none;align-items:center;justify-content:center;z-index:50}
    .lightbox img{max-width:90vw;max-height:85vh;border-radius:14px;box-shadow:0 20px 60px rgba(0,0,0,.4);background:#fff}
    .lightbox.show{display:flex}

    @media (max-width:900px){
      body{padding:16px}
      .title{font-size:24px}
      .ig-input{min-width:220px}
      .table-wrap{overflow:auto}
      table{min-width:1100px}
    }
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="role" value="${sessionScope.user.role}"/>

<div class="container">
  <!-- Header -->
  <div class="header">
    <div class="header-content">
      <h1 class="title">📦 Items
        <c:if test="${not empty list}">
        <!-- OLD: <span class="stats-badge">${fn:length(list)} Total</span> -->
        <span class="stats-badge" id="itemsCount">${fn:length(list)}</span>
        </c:if>
      </h1>
      <div class="header-actions">
        <a class="btn btn-primary" href="${ctx}/items/new">✨ New Item</a>
        <a class="btn" href="${ctx}/dashboard">🏠 Dashboard</a>
      </div>
    </div>
    <div class="header-center">
      <div class="logo">
        <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu Logo"
             onerror="this.style.display='none'; this.parentNode.innerHTML='<strong>PE</strong>';">
      </div>
    </div>
  </div>

  <!-- Toolbar -->
  <div class="controlbar">
    <div class="cb-left">
      <form id="searchForm" action="${ctx}/items" method="get">
        <div class="input-group">
          <span class="ig-icon" aria-hidden="true">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M21 21l-4.35-4.35m1.1-4.4a6.75 6.75 0 1 1-13.5 0 6.75 6.75 0 0 1 13.5 0Z" stroke="#475569" stroke-width="1.8" stroke-linecap="round"/></svg>
          </span>
          <input id="q" class="ig-input" name="q" value="<c:out value='${param.q}'/>" placeholder="Search items by name / category / description…"/>
          <button class="ig-btn" type="submit">Search</button>
          <button class="ig-btn ghost" type="button" id="clearBtn">Clear</button>
        </div>
      </form>
    </div>
    <div class="cb-right">
      <div class="seg" id="statusSeg">
        <button type="button" data-val="" class="active">All</button>
        <button type="button" data-val="ACTIVE">Active</button>
        <button type="button" data-val="INACTIVE">Inactive</button>
      </div>
      <select id="catFilter" class="select" aria-label="Filter by category">
        <option value="">All Categories</option>
      </select>
    </div>
  </div>

  <!-- Messages -->
  <c:if test="${not empty param.msg}">
    <div class="flash ok">✅ <span><c:out value="${param.msg}"/></span></div>
  </c:if>
  <c:if test="${not empty param.error}">
    <div class="flash err">❌ <span><c:out value="${param.error}"/></span></div>
  </c:if>

  <!-- Table -->
  <c:choose>
    <c:when test="${not empty list}">
      <section class="card">
        <div class="table-wrap">
          <table id="itemsTable" aria-label="Items">
            <thead>
              <tr>
                <th>ID</th>
                <th>Name</th>
                <th class="cell-right">Price</th>
                <th class="cell-right">Stock</th>
                <th>Category</th>
                <th>Status</th>
                <th>Image</th>
                <th>Description</th>
                <th style="width:200px">Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="it" items="${list}">
                <tr>
                  <td><span class="id-chip">#${it.itemId}</span></td>
                  <td class="name"><c:out value="${it.name}"/></td>
                  <td class="cell-right">Rs. <fmt:formatNumber value="${it.unitPrice}" type="number" minFractionDigits="2"/></td>
                  <td class="cell-right">
                    <span class="stock-badge ${it.stockQty <= 5 ? 'low' : (it.stockQty <= 20 ? 'warn' : 'ok')}">
                      <c:out value="${it.stockQty}"/>
                    </span>
                  </td>
                  <td class="cat"><span class="cat-pill"><c:out value="${it.category}"/></span></td>
                  <td class="status-cell">
                    <span class="pill ${it.active ? 'on' : 'off'}">
                      <c:out value="${it.active ? 'ACTIVE' : 'INACTIVE'}"/>
                    </span>
                  </td>
                  <td>
                    <c:if test="${not empty it.imageUrl}">
                      <img class="thumb" src="${ctx}/uploads/${it.imageUrl}" alt="item image"/>
                    </c:if>
                  </td>
                  <td class="desc" title="${it.description}">
                    <c:choose>
                      <c:when test="${not empty it.description and fn:length(it.description) > 120}">
                        <c:out value="${fn:substring(it.description,0,120)}"/>…
                      </c:when>
                      <c:otherwise><c:out value="${it.description}"/></c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <div class="row-actions">
                      <a class="btn-edit" href="${ctx}/items/edit?id=${it.itemId}">✏️ Edit</a>
                      <c:if test="${role == 'ADMIN' || role == 'STAFF'}">
                        <form class="inline" action="${ctx}/items/delete" method="post"
                              onsubmit="return confirm('Delete this item? If it is used in bills, deletion will be blocked.');">
                          <input type="hidden" name="id" value="${it.itemId}">
                          <button class="btn-delete" type="submit">🗑️ Delete</button>
                        </form>
                      </c:if>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </section>
    </c:when>
    <c:otherwise>
      <div class="flash err" style="justify-content:center">No items yet.</div>
    </c:otherwise>
  </c:choose>
</div>

<!-- Lightbox -->
<div id="lightbox" class="lightbox" role="dialog" aria-modal="true" aria-label="Image preview">
  <img alt="preview"/>
</div>

<script>
(function(){
  const table = document.getElementById('itemsTable');
  const searchForm = document.getElementById('searchForm');
  const searchInput = document.getElementById('q');
  const clearBtn = document.getElementById('clearBtn');
  const statusSeg = document.getElementById('statusSeg');
  const catSel = document.getElementById('catFilter');
  const badge = document.getElementById('itemsCount');

  if (!table) return;

  // Build categories
  (function buildCategories(){
    const set = new Set();
    table.querySelectorAll('tbody td.cat').forEach(td => {
      const v = (td.textContent || '').trim();
      if (v) set.add(v);
    });
    Array.from(set).sort().forEach(v => {
      const opt = document.createElement('option'); opt.value = v; opt.textContent = v;
      catSel.appendChild(opt);
    });
  })();

  function applyFilters(){
    const q = (searchInput.value || '').trim().toLowerCase();
    const statusBtn = statusSeg.querySelector('button.active');
    const statusVal = statusBtn ? statusBtn.dataset.val : '';
    const catVal = catSel.value;
    let visible = 0;

    const rows = table.tBodies[0].rows;
    for (let i=0;i<rows.length;i++){
      const r = rows[i];
      const statusText = (r.querySelector('.status-cell')?.innerText || '').toUpperCase();
      const catText = (r.querySelector('.cat')?.innerText || '').trim();
      const hay = (
        (r.querySelector('.name')?.innerText || '') + ' ' +
        catText + ' ' +
        (r.querySelector('.desc')?.innerText || '') + ' ' +
        (r.cells[0]?.innerText || '')
      ).toLowerCase();

      const okQuery  = !q || hay.includes(q);
      const okStatus = !statusVal || statusText.includes(statusVal);
      const okCat    = !catVal || catText === catVal;

      const show = okQuery && okStatus && okCat;
      r.style.display = show ? '' : 'none';
      if (show) visible++;
    }
    if (badge){ badge.textContent = String(visible); }
  }

  // client-side search
  if (searchForm){ searchForm.addEventListener('submit', e => { e.preventDefault(); applyFilters(); }); }
  if (searchInput){ searchInput.addEventListener('input', applyFilters); }
  if (clearBtn){
    clearBtn.addEventListener('click', () => {
      searchInput.value=''; catSel.value=''; statusSeg.querySelectorAll('button').forEach(b=>b.classList.remove('active'));
      statusSeg.querySelector('button[data-val=""]').classList.add('active'); applyFilters();
    });
  }
  if (statusSeg){ statusSeg.addEventListener('click', e=>{ const b=e.target.closest('button'); if(!b)return; statusSeg.querySelectorAll('button').forEach(x=>x.classList.remove('active')); b.classList.add('active'); applyFilters(); }); }
  if (catSel){ catSel.addEventListener('change', applyFilters); }
  applyFilters();

  // Lightbox
  const lb = document.getElementById('lightbox'); const lbImg = lb.querySelector('img');
  table.querySelectorAll('.thumb').forEach(img => {
    img.addEventListener('click', () => { lbImg.src = img.src; lb.classList.add('show'); });
  });
  lb.addEventListener('click', () => lb.classList.remove('show'));
  document.addEventListener('keydown', e => { if(e.key==='Escape') lb.classList.remove('show'); });
})();
</script>
</body>
</html>
