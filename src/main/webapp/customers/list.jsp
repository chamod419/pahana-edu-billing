<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customers - PahanaEdu</title>
  <style>
    :root{
      /* Brand palette */
      --deep-navy:#1e3a8a; --forest:#166534; --midnight:#1e293b; --teal:#0f766e; --royal:#2563eb;
      --gold:#f59e0b; --emerald:#059669; --orange:#ea580c;
      --white:#ffffff; --cream:#fefbf3; --lg:#f8fafc; --off:#fafaf9;
      --charcoal:#374151; --dark:#1f2937; --slate:#475569; --graphite:#111827;

      --radius-xl:24px; --radius-lg:16px; --radius-md:12px;
      --border:#e5e7eb; --muted:#94a3b8;
      --shadow-1:0 10px 25px rgba(0,0,0,.08), 0 0 0 1px rgba(0,0,0,.02);
      --focus:0 0 0 3px rgba(15,118,110,.15);
    }

    *{box-sizing:border-box;margin:0;padding:0}
    html,body{height:100%}
    body{
      font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color:var(--charcoal);
      /* ✅ Revert to the classic light background */
      background: linear-gradient(135deg, var(--lg) 0%, #e2e8f0 100%);
      min-height:100vh; padding:24px; position:relative; overflow-x:hidden;
    }
    /* subtle background dots */
    body::before{
      content:''; position:fixed; inset:0; pointer-events:none; z-index:-1;
      background:url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60"><defs><pattern id="p" width="22" height="22" patternUnits="userSpaceOnUse"><circle cx="11" cy="11" r="1" fill="rgba(15,118,110,0.05)"/></pattern></defs><rect width="100%" height="100%" fill="url(%23p)"/></svg>');
    }

    /* container: no glass, just width */
    .container{max-width:1200px;margin:0 auto}

    /* ===== Header (same as earlier pages) ===== */
    .header{
      background: linear-gradient(135deg, var(--midnight) 0%, var(--teal) 50%, var(--deep-navy) 100%);
      color:#fff; border-radius:var(--radius-xl); padding:24px 28px; margin-bottom:18px;
      position:relative; overflow:hidden; box-shadow:0 10px 25px rgba(30,41,59,.15), 0 0 0 1px rgba(255,255,255,.08) inset;
    }
    .header::before{
      content:''; position:absolute; inset:0;
      background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,.10) 50%, transparent 70%);
      animation: shimmer 3s ease-in-out infinite;
    }
    @keyframes shimmer{0%,100%{transform:translateX(-100%)}50%{transform:translateX(100%)}}
    .header-content{position:relative; z-index:1; display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap}
    .title{font-size:28px; font-weight:800; letter-spacing:.2px; display:flex; align-items:center; gap:12px}
    .stats-badge{background:rgba(245,158,11,.15); color:var(--gold); font-size:14px; font-weight:700; padding:4px 12px; border-radius:20px; margin-left:8px; border:1px solid rgba(245,158,11,.3);}
    .header-actions{display:flex; gap:12px; flex-wrap:wrap}
    .btn{
      appearance:none; border:1px solid rgba(255,255,255,.35); background:rgba(255,255,255,.18);
      color:#fff; border-radius:12px; padding:12px 18px; font-weight:700; text-decoration:none;
      display:inline-flex; align-items:center; gap:8px; transition:.2s; backdrop-filter: blur(8px);
    }
    .btn:hover{transform:translateY(-1px)}
    .btn-primary{
      background:linear-gradient(135deg, var(--midnight) 0%, var(--teal) 60%, var(--royal) 100%);
      color:#fff; border:none; box-shadow:0 6px 16px rgba(15,118,110,.30);
    }
    .header-center{position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); z-index:2; pointer-events:none;}
    .logo{width:64px;height:64px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 8px 20px rgba(0,0,0,.25);padding:8px}
    .logo img{max-width:48px;max-height:48px;display:block;object-fit:contain}
    .logo-fallback{display:none;color:var(--midnight);font-weight:800;font-size:20px}

    /* ===== Toolbar: Search + Status filter ===== */
    .controlbar{
      background:#fff; border:1px solid var(--border); border-radius:16px;
      padding:12px; display:flex; justify-content:space-between; align-items:center;
      gap:12px; flex-wrap:wrap; box-shadow:0 10px 25px rgba(0,0,0,.04);
      margin-bottom:14px;
    }
    .cb-left,.cb-right{display:flex; gap:12px; flex-wrap:wrap; align-items:center}

    .input-group{
      display:flex; align-items:center; height:46px;
      border:1px solid var(--border); border-radius:12px; background:#fff; overflow:hidden;
    }
    .ig-icon{display:inline-flex; align-items:center; justify-content:center; width:46px; height:46px; border-right:1px solid var(--border); color:#475569; background:#fafafa;}
    .ig-input{border:0; outline:0; height:46px; padding:0 14px; min-width:320px; font-size:14px; color:var(--graphite)}
    .ig-input::placeholder{color:var(--muted)}
    .ig-btn{height:46px; border:0; padding:0 16px; font-weight:700; background:#f8fafc; color:var(--dark); cursor:pointer; border-left:1px solid var(--border)}
    .ig-btn:hover{background:#f1f5f9}
    .ig-btn.ghost{background:#fff}
    .ig-btn.ghost:hover{background:#f8fafc}

    /* Segmented status filter */
    .seg{display:inline-flex; border:1px solid var(--border); border-radius:12px; overflow:hidden; background:#fff; height:46px}
    .seg button{appearance:none; border:0; padding:0 16px; font-weight:700; background:#fff; color:var(--dark); cursor:pointer; border-right:1px solid var(--border)}
    .seg button:last-child{border-right:0}
    .seg button.active{background:#f0fdfa; color:#0f766e}

    /* messages */
    .flash{padding:12px 14px;border-radius:12px;font-weight:700;display:flex;gap:12px;align-items:center;margin:12px 0}
    .ok{background:linear-gradient(135deg,#dcfce7,#bbf7d0); color:#166534; border:1px solid #bbf7d0}
    .err{background:linear-gradient(135deg,#fee2e2,#fecaca); color:#dc2626; border:1px solid #fecaca}

    /* ===== Table card ===== */
    .card{background:#fff;border:1px solid var(--border);border-radius:20px;box-shadow:var(--shadow-1);overflow:hidden; position:relative}
    .card::before{content:''; position:absolute; left:0; right:0; top:0; height:3px; background: linear-gradient(90deg, var(--midnight), var(--teal), var(--deep-navy), var(--forest)); background-size:200% 100%; animation: bar 4s ease infinite;}
    @keyframes bar{0%,100%{background-position:0% 50%}50%{background-position:100% 50%}}

    .table-wrap{overflow:auto}
    table{width:100%;border-collapse:collapse}
    thead th{background:#f8fafc; color:#374151; font-weight:800; text-transform:uppercase; letter-spacing:.5px; font-size:12px; padding:18px 20px; border-bottom:2px solid #e5e7eb; position:sticky; top:0; z-index:1; text-align:left}
    tbody td{padding:20px; border-top:1px solid #f1f5f9; vertical-align:top; font-size:14px}
    tbody tr:hover{background:#fafafa}

    .id-chip{font-family:ui-monospace,Menlo,Monaco,Consolas,monospace;background:#f1f5f9;color:#64748b;padding:6px 10px;border-radius:8px;font-size:12px;font-weight:800;border:1px solid #e2e8f0}
    .status{display:inline-flex;align-items:center;gap:6px;border:1px solid; padding:8px 12px;border-radius:999px;font-weight:800;font-size:12px}
    .active{background:#eaf7ef;border-color:#cfe9d8;color:#0b6b2c}
    .inactive{background:#f3f4f6;border-color:#e5e7eb;color:#374151}

    .row-actions{display:flex;gap:10px;flex-wrap:wrap}

    /* === ACTION BUTTONS (match earlier design; no underline/no shine) === */
    .btn-edit,
    .btn-delete,
    .row-actions a{ text-decoration:none }  /* ✅ remove underline */

    .btn-edit{
      appearance:none; border:none; color:#fff; font-weight:700; cursor:pointer;
      background:linear-gradient(135deg, var(--teal) 0%, var(--emerald) 100%);
      padding:10px 14px; border-radius:10px; display:inline-flex; align-items:center; gap:8px;
      box-shadow:0 4px 12px rgba(15,118,110,.25); transition:.2s;
    }
    .btn-edit:hover{transform:translateY(-1px); box-shadow:0 6px 16px rgba(15,118,110,.32)}

    .btn-delete{
      appearance:none; border:none; color:#fff; font-weight:700; cursor:pointer;
      background:linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
      padding:10px 14px; border-radius:10px; display:inline-flex; align-items:center; gap:8px;
      box-shadow:0 4px 12px rgba(220,38,38,.25); transition:.2s;
    }
    .btn-delete:hover{transform:translateY(-1px); box-shadow:0 6px 16px rgba(220,38,38,.32)}
    .btn-delete:disabled{background:#e5e7eb; color:#9ca3af; cursor:not-allowed; box-shadow:none; transform:none}

    .empty{background:#fff;border:1px dashed var(--border);border-radius:var(--radius-lg);padding:60px 24px;text-align:center;color:var(--slate)}
    .empty .ico{font-size:48px;opacity:.6;margin-bottom:8px}
    .empty .lead{font-weight:800;color:var(--midnight);margin-bottom:6px}

    @media (max-width:900px){
      body{padding:16px}
      .title{font-size:24px}
      .ig-input{min-width:220px}
      .table-wrap{overflow:auto}
      table{min-width:900px}
    }
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="container">
  <!-- Header -->
  <div class="header">
    <div class="header-content">
      <h1 class="title">
        📇 Customers 
        <c:if test="${not empty list}"><span class="stats-badge">${fn:length(list)} Total</span></c:if>
      </h1>
      <div class="header-actions">
        <a class="btn btn-primary" href="${ctx}/customers/new">✨ New Customer</a>
        <a class="btn" href="${ctx}/dashboard">🏠 Dashboard</a>
      </div>
    </div>
    <div class="header-center">
      <div class="logo">
        <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu Logo"
             onerror="this.style.display='none'; this.parentNode.querySelector('.logo-fallback').style.display='block';">
        <div class="logo-fallback">PE</div>
      </div>
    </div>
  </div>

  <!-- Toolbar -->
  <div class="controlbar">
    <div class="cb-left">
      <form id="searchForm" action="${ctx}/customers" method="get">
        <div class="input-group">
          <span class="ig-icon" aria-hidden="true">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
              <path d="M21 21l-4.35-4.35m1.1-4.4a6.75 6.75 0 1 1-13.5 0 6.75 6.75 0 0 1 13.5 0Z" stroke="#475569" stroke-width="1.8" stroke-linecap="round"/>
            </svg>
          </span>
          <input class="ig-input" name="q" value="<c:out value='${q}'/>" placeholder="Search: name / phone / email / account #"/>
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
          <table id="customersTable" aria-label="Customers">
            <thead>
              <tr>
                <th>ID</th>
                <th>Account #</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Address</th>
                <th>Status</th>
                <th style="width:200px">Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="cst" items="${list}">
                <tr>
                  <td><span class="id-chip">#${cst.customerId}</span></td>
                  <td><c:out value="${cst.accountNumber}"/></td>
                  <td><c:out value="${cst.name}"/></td>
                  <td><c:out value="${cst.phone}"/></td>
                  <td><c:out value="${cst.email}"/></td>
                  <td><c:out value="${cst.address}"/></td>
                  <td>
                    <c:choose>
                      <c:when test="${cst.status=='ACTIVE'}"><span class="status active">ACTIVE</span></c:when>
                      <c:otherwise><span class="status inactive">INACTIVE</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <div class="row-actions">
                      <a class="btn-edit" href="${ctx}/customers/edit?id=${cst.customerId}">✏️ Edit</a>
                      <form class="inline" action="${ctx}/customers/delete" method="post"
                            onsubmit="return confirm('Delete this customer?\\n\\nName: ${cst.name}\\nAccount: ${cst.accountNumber || ''}');">
                        <input type="hidden" name="id" value="${cst.customerId}">
                        <button class="btn-delete" type="submit">🗑️ Delete</button>
                      </form>
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
      <div class="empty">
        <div class="ico">🗂️</div>
        <div class="lead">No customers found</div>
        <p>Try clearing the search or create a new customer.</p>
        <a class="btn btn-primary" href="${ctx}/customers/new" style="display:inline-flex">➕ Create Customer</a>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<script>
  (function(){
    // Clear -> base list
    const clearBtn = document.getElementById('clearBtn');
    if (clearBtn){
      clearBtn.addEventListener('click', function(){
        window.location.href = '${ctx}/customers';
      });
    }

    // Client-side status segmented filter
    const seg = document.getElementById('statusSeg');
    const table = document.getElementById('customersTable');
    if (seg && table){
      seg.addEventListener('click', (e)=>{
        const btn = e.target.closest('button'); if(!btn) return;
        seg.querySelectorAll('button').forEach(b=>b.classList.remove('active'));
        btn.classList.add('active');

        const val = btn.dataset.val; // "" | "ACTIVE" | "INACTIVE"
        const rows = table.tBodies[0].rows;
        for (let i=0;i<rows.length;i++){
          const statusCell = rows[i].cells[6];
          const text = (statusCell?.innerText || '').trim().toUpperCase();
          rows[i].style.display = (!val || text === val) ? '' : 'none';
        }
      });
    }

    // Auto-hide success message
    document.querySelectorAll('.ok').forEach(function(m){
      setTimeout(function(){ m.style.opacity = '0'; m.style.transform='translateY(-6px)'; setTimeout(()=>m.remove(),300); }, 4000);
    });
  })();
</script>
</body>
</html>
