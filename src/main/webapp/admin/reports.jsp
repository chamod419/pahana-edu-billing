<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Reports - PahanaEdu</title>
  <style>
    :root{
      /* Primary */
      --deep-navy:#1e3a8a; --forest:#166534; --midnight:#1e293b; --teal:#0f766e; --royal:#2563eb;
      /* Accent */
      --gold:#f59e0b; --emerald:#059669; --orange:#ea580c;
      /* Backgrounds */
      --white:#ffffff; --cream:#fefbf3; --light-gray:#f8fafc; --off-white:#fafaf9;
      /* Text */
      --charcoal:#374151; --dark:#1f2937; --slate:#475569; --graphite:#111827;
      /* Shadows */
      --shadow-lg:0 20px 45px rgba(17,24,39,.12);
      --shadow:0 10px 25px rgba(17,24,39,.10), 0 0 0 1px rgba(30,41,59,.06);
      --shadow-sm:0 6px 16px rgba(17,24,39,.08), 0 0 0 1px rgba(30,41,59,.05);
      /* Radius */
      --r-xl:24px; --r-lg:16px; --r:12px;
      /* Focus */
      --focus:0 0 0 3px rgba(15,118,110,.14);
    }

    *{box-sizing:border-box;margin:0;padding:0}
    html,body{height:100%}
    body{
      font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color:var(--charcoal);
      background:linear-gradient(180deg, var(--off-white) 0%, var(--cream) 100%);
      min-height:100vh; overflow-x:hidden;
    }
    body::before{
      content:''; position:fixed; inset:0; z-index:-2;
      background:
        url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='96' height='96' viewBox='0 0 96 96'%3E%3Cdefs%3E%3Cpattern id='p' width='96' height='96' patternUnits='userSpaceOnUse'%3E%3Cg transform='translate(8,10)'%3E%3Crect x='0' y='0' rx='2' ry='2' width='22' height='30' fill='%231e3a8a' fill-opacity='0.08'/%3E%3Crect x='2' y='4' width='18' height='22' fill='%232563eb' fill-opacity='0.06'/%3E%3Cline x1='6' y1='6' x2='16' y2='6' stroke='%231e293b' stroke-opacity='0.10' stroke-width='1'/%3E%3Cline x1='6' y1='10' x2='16' y2='10' stroke='%231e293b' stroke-opacity='0.10' stroke-width='1'/%3E%3C/g%3E%3Cg transform='translate(38,6) rotate(-20)'%3E%3Crect x='0' y='8' width='26' height='6' rx='3' fill='%23f59e0b' fill-opacity='0.10'/%3E%3Crect x='20' y='7' width='5' height='8' rx='1' fill='%232563eb' fill-opacity='0.10'/%3E%3Cpolygon points='-3,11 0,8 0,14' fill='%23ea580c' fill-opacity='0.12'/%3E%3C/g%3E%3Cg transform='translate(60,44) rotate(10)'%3E%3Crect x='0' y='0' width='28' height='8' rx='2' fill='%23059669' fill-opacity='0.08'/%3E%3Cg stroke='%23166534' stroke-opacity='0.18' stroke-width='1'%3E%3Cline x1='4' y1='1' x2='4' y2='7'/%3E%3Cline x1='8' y1='1' x2='8' y2='6'/%3E%3Cline x1='12' y1='1' x2='12' y2='7'/%3E%3Cline x1='16' y1='1' x2='16' y2='6'/%3E%3Cline x1='20' y1='1' x2='20' y2='7'/%3E%3Cline x1='24' y1='1' x2='24' y2='6'/%3E%3C/g%3E%3Cg transform='translate(16,56)'%3E%3Crect x='0' y='0' width='26' height='30' rx='3' fill='%230f766e' fill-opacity='0.06'/%3E%3Cline x1='4' y1='8' x2='22' y2='8' stroke='%231e293b' stroke-opacity='0.12'/%3E%3Cline x1='4' y1='13' x2='22' y2='13' stroke='%231e293b' stroke-opacity='0.12'/%3E%3Cline x1='4' y1='18' x2='22' y2='18' stroke='%231e293b' stroke-opacity='0.12'/%3E%3C/g%3E%3Cg transform='translate(70,74) rotate(30)'%3E%3Crect x='0' y='0' width='14' height='10' rx='2' fill='%23166534' fill-opacity='0.08'/%3E%3Ccircle cx='4' cy='5' r='1.5' fill='%23f59e0b' fill-opacity='0.30'/%3E%3C/g%3E%3C/pattern%3E%3C/defs%3E%3Crect width='96' height='96' fill='%23f8fafc'/%3E%3Crect width='96' height='96' fill='url(%23p)'/%3E%3C/svg%3E");
      animation: drift 60s linear infinite;
    }
    @keyframes drift{0%{transform:translate3d(0,0,0)}100%{transform:translate3d(-96px,-96px,0)}}

    .container{max-width:1400px;margin:0 auto;padding:24px}

    /* ===== Header ===== */
    .header{
      background:linear-gradient(135deg, var(--midnight) 0%, var(--teal) 55%, var(--deep-navy) 100%);
      color:#fff; padding:24px 28px; border-radius:var(--r-xl); position:relative; overflow:hidden;
      box-shadow:var(--shadow-lg);
    }
    .header::before{
      content:''; position:absolute; inset:0;
      background:linear-gradient(45deg, transparent 30%, rgba(255,255,255,.10) 50%, transparent 70%);
      animation:shimmer 3s ease-in-out infinite;
    }
    @keyframes shimmer{0%,100%{transform:translateX(-100%)}50%{transform:translateX(100%)}}
    .header-inner{position:relative; z-index:1; display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap}
    .title{font-size:28px; font-weight:800; letter-spacing:.2px}
    .crumbs{display:flex; align-items:center; gap:10px; opacity:.9}
    .crumbs a{color:rgba(255,255,255,.85); text-decoration:none}
    .crumbs a:hover{color:#fff}
    .logo-center{position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); z-index:0; pointer-events:none}
    .logo{width:64px;height:64px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 8px 20px rgba(0,0,0,.25);padding:8px}
    .logo img{max-width:48px;max-height:48px;object-fit:contain}

    /* ===== Filters ===== */
    .filters{
      background:#fff; border-radius:var(--r-xl); padding:20px; margin-top:16px; box-shadow:var(--shadow);
    }
    .filters .row{display:flex; gap:12px; flex-wrap:wrap; align-items:end}
    .fg{display:flex; flex-direction:column; gap:6px}
    label{font-size:13px; font-weight:800; color:var(--slate)}
    input[type="date"], input[type="number"]{
      padding:10px 12px; border:2px solid var(--light-gray); border-radius:12px; font-size:14px; outline:none; transition:.2s
    }
    input[type="date"]:focus, input[type="number"]:focus{border-color:var(--teal); box-shadow:var(--focus)}
    .btn{
      appearance:none; border:1px solid transparent; border-radius:12px; padding:12px 16px; font-weight:800; cursor:pointer;
      transition:transform .12s ease, box-shadow .2s ease, filter .2s ease; display:inline-flex; align-items:center; gap:8px
    }
    .btn:hover{transform:translateY(-1px)}
    .btn-primary{color:#fff;background:linear-gradient(135deg, var(--teal), var(--emerald)); box-shadow:0 12px 24px rgba(15,118,110,.25)}
    .btn-ghost{background:#fff; border:2px solid var(--light-gray); color:var(--dark); box-shadow:var(--shadow-sm)}
    .chips{display:flex; gap:8px; flex-wrap:wrap}
    .chip{
      padding:8px 12px; border-radius:999px; background:#f8fafc; border:1px solid #e2e8f0; cursor:pointer; font-weight:700; color:#1f2937;
      transition:.2s
    }
    .chip:hover{background:#eef2ff; border-color:#c7d2fe; color:#1e3a8a}
    .chip.active{background:linear-gradient(135deg, var(--midnight), var(--teal)); color:#fff; border-color:transparent}

    .period{
      margin-left:auto; font-size:12px; color:#fff; background:rgba(255,255,255,.12); border:1px solid rgba(255,255,255,.25);
      padding:6px 10px; border-radius:999px; font-weight:700
    }

    /* ===== Stats ===== */
    .stats{display:grid; grid-template-columns:repeat(auto-fit, minmax(240px,1fr)); gap:16px; margin-top:20px}
    .stat{
      background:#fff; border-radius:18px; padding:18px 18px 18px 18px; position:relative; overflow:hidden; box-shadow:var(--shadow);
      transition:.25s ease transform, .25s ease box-shadow;
    }
    .stat:hover{transform:translateY(-3px); box-shadow:var(--shadow-lg)}
    .stat::before{
      content:''; position:absolute; left:0; right:0; top:0; height:4px;
      background:linear-gradient(90deg, var(--midnight), var(--teal), var(--gold), var(--emerald)); background-size:200% 100%; animation:band 5s ease infinite;
    }
    @keyframes band{0%,100%{background-position:0% 50%}50%{background-position:100% 50%}}
    .label{font-size:12px; font-weight:800; letter-spacing:.4px; text-transform:uppercase; color:#6b7280}
    .value{font-size:32px; font-weight:800; margin-top:6px; background:linear-gradient(135deg, var(--midnight), var(--teal)); -webkit-background-clip:text; background-clip:text; -webkit-text-fill-color:transparent}
    .sub{font-size:12px; color:#64748b}

    /* ===== Grid (Charts & Tables) ===== */
    .grid{display:grid; grid-template-columns:1fr 1fr; gap:18px; margin-top:18px}
    .card{
      background:#fff; border-radius:18px; box-shadow:var(--shadow); overflow:hidden;
    }
    .card-head{padding:16px 18px; border-bottom:1px solid #eef2f7; display:flex; align-items:center; justify-content:space-between}
    .card-title{font-weight:800; color:var(--midnight)}
    .card-body{padding:16px 18px}

    /* Chart */
    .chart-wrap{position:relative}
    #salesChart{
      width:100%; height:260px; background:linear-gradient(180deg, var(--off-white), var(--light-gray));
      border:2px solid rgba(15,118,110,.10); border-radius:14px;
    }
    .legend{font-size:12px; color:var(--slate); margin-top:8px}

    /* Payment bars */
    .bars{display:grid; gap:10px; margin-top:10px}
    .bar{height:12px; border-radius:999px; background:#eef2f7; position:relative; overflow:hidden}
    .bar > span{
      position:absolute; left:0; top:0; bottom:0; width:0%;
      background:linear-gradient(135deg, var(--royal), var(--deep-navy)); transition:width .6s ease; box-shadow:inset 0 0 0 1px rgba(255,255,255,.3)
    }
    .bar-row{display:flex; align-items:center; gap:10px; font-weight:700; color:#1f2937}
    .bar-row small{color:#64748b; font-weight:600}

    /* Table */
    table{width:100%; border-collapse:collapse}
    th{background:linear-gradient(135deg, var(--midnight), var(--teal)); color:#fff; padding:12px 14px; text-align:left; font-weight:800}
    th:first-child{border-radius:8px 0 0 0} th:last-child{border-radius:0 8px 0 0}
    td{padding:12px 14px; border-bottom:1px solid #eef2f7; color:#1f2937}
    td.right{text-align:right; font-weight:700}
    tbody tr:hover{background:rgba(15,118,110,.05)}
    .empty{padding:18px; text-align:center; color:#64748b}

    /* Footer actions */
    .footer-actions{
      position:sticky; bottom:20px; display:flex; gap:10px; justify-content:flex-end; margin-top:18px
    }

    /* Responsive */
    @media (max-width:992px){ .grid{grid-template-columns:1fr} }
    @media (max-width:680px){
      .filters .row{flex-direction:column; align-items:stretch}
      .period{margin-left:0; margin-top:8px}
      .title{font-size:24px}
      .value{font-size:28px}
    }

    @media print{
      body{background:#fff}
      .header, .filters, .footer-actions{display:none !important}
      .card{box-shadow:none}
    }
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="container">
  <!-- Header -->
  <div class="header">
    <div class="header-inner">
      <div class="title">📊 Admin Reports</div>
      <div class="crumbs">
        <a href="${ctx}/dashboard">Dashboard</a><span>→</span><span>Reports</span>
      </div>
      <c:choose>
        <c:when test="${not empty from or not empty to}">
          <div class="period">
            Period:
            <c:out value="${empty from ? '—' : from}"/> → <c:out value="${empty to ? '—' : to}"/>
          </div>
        </c:when>
        <c:otherwise>
          <div class="period">Period: All time</div>
        </c:otherwise>
      </c:choose>
    </div>
    <div class="logo-center">
      <div class="logo">
        <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu" onerror="this.style.display='none'; this.parentNode.innerHTML='<strong style=&quot;color:#1e293b&quot;>PE</strong>';">
      </div>
    </div>
  </div>

  <!-- Filters -->
  <div class="filters">
    <form class="row" method="get" action="${ctx}/admin/reports" id="filterForm">
      <div class="fg">
        <label>From</label>
        <input type="date" name="from" id="from" value="${from}"/>
      </div>
      <div class="fg">
        <label>To</label>
        <input type="date" name="to" id="to" value="${to}"/>
      </div>
      <div class="fg">
        <label>Low Stock Threshold</label>
        <input type="number" name="threshold" id="threshold" min="0" max="100000" value="${threshold}"/>
      </div>
      <div class="fg">
        <button class="btn btn-primary" type="submit">Apply Filters</button>
      </div>
      <div class="fg">
        <button class="btn btn-ghost" type="button" id="clearBtn">Clear</button>
      </div>
    </form>
    <div class="chips" style="margin-top:12px">
      <button class="chip" data-range="today">Today</button>
      <button class="chip" data-range="7">Last 7 days</button>
      <button class="chip" data-range="30">Last 30 days</button>
      <button class="chip" data-range="month">This month</button>
    </div>
  </div>

  <!-- Stats -->
  <div class="stats">
    <div class="stat">
      <div class="label">Total Bills</div>
      <div class="value"><fmt:formatNumber value="${sum.bills}"/></div>
      <div class="sub">Count of invoices in period</div>
    </div>
    <div class="stat">
      <div class="label">Items Sold</div>
      <div class="value"><fmt:formatNumber value="${sum.items}"/></div>
      <div class="sub">Total quantity</div>
    </div>
    <div class="stat">
      <div class="label">Gross Revenue</div>
      <div class="value">Rs. <fmt:formatNumber value="${sum.gross}" minFractionDigits="0" maxFractionDigits="0"/></div>
      <div class="sub">Before discounts</div>
    </div>
    <div class="stat">
      <div class="label">Discount</div>
      <div class="value">Rs. <fmt:formatNumber value="${sum.discount}" minFractionDigits="0" maxFractionDigits="0"/></div>
      <div class="sub">Total given</div>
    </div>
    <div class="stat">
      <div class="label">Net Revenue</div>
      <div class="value">Rs. <fmt:formatNumber value="${sum.net}" minFractionDigits="0" maxFractionDigits="0"/></div>
      <div class="sub">After discounts</div>
    </div>
    <div class="stat">
      <div class="label">Avg Bill Value</div>
      <div class="value">
        Rs.
        <fmt:formatNumber value="${sum.bills gt 0 ? (sum.net / sum.bills) : 0}" minFractionDigits="0" maxFractionDigits="0"/>
      </div>
      <div class="sub">Net / bills</div>
    </div>
  </div>

  <!-- Charts & Payment -->
  <div class="grid">
    <div class="card">
      <div class="card-head">
        <div class="card-title">📈 Sales by Day</div>
        <small style="color:#64748b">Net total per day</small>
      </div>
      <div class="card-body">
        <div class="chart-wrap">
          <canvas id="salesChart"></canvas>
        </div>
        <div class="legend">Bars represent daily net revenue within the selected period.</div>
      </div>
    </div>

    <div class="card">
      <div class="card-head">
        <div class="card-title">💳 Payment Breakdown</div>
        <small style="color:#64748b">Method share</small>
      </div>
      <div class="card-body">
        <table>
          <thead>
            <tr>
              <th>Method</th>
              <th class="right">Amount (Rs.)</th>
            </tr>
          </thead>
          <tbody id="payTbody">
            <c:choose>
              <c:when test="${empty pay}">
                <tr><td colspan="2" class="empty">No payment data</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="p" items="${pay}">
                  <tr>
                    <td><c:out value="${p.method}"/></td>
                    <td class="right" data-amt="${p.amount}">Rs. <fmt:formatNumber value="${p.amount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>

        <div class="bars" id="payBars" aria-hidden="true"></div>
      </div>
    </div>
  </div>

  <!-- Top Items & Low Stock -->
  <div class="grid" style="margin-top:18px">
    <div class="card">
      <div class="card-head">
        <div class="card-title">🏆 Top Items</div>
        <small style="color:#64748b">By quantity & revenue</small>
      </div>
      <div class="card-body">
        <table>
          <thead>
            <tr>
              <th style="width:80px">ID</th>
              <th>Item</th>
              <th class="right">Qty</th>
              <th class="right">Revenue (Rs.)</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty top}">
                <tr><td colspan="4" class="empty">No sales data</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="r" items="${top}">
                  <tr>
                    <td>#${r.itemId}</td>
                    <td><c:out value="${r.name}"/></td>
                    <td class="right">${r.qty}</td>
                    <td class="right">Rs. <fmt:formatNumber value="${r.revenue}" minFractionDigits="2" maxFractionDigits="2"/></td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>

    <div class="card">
      <div class="card-head">
        <div class="card-title">⚠️ Low Stock (≤ <c:out value="${threshold}"/>)</div>
        <small style="color:#64748b">Restock suggested</small>
      </div>
      <div class="card-body">
        <table>
          <thead>
            <tr>
              <th style="width:80px">ID</th>
              <th>Item</th>
              <th class="right">Stock</th>
              <th class="right">Unit Price (Rs.)</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty lowStock}">
                <tr><td colspan="4" class="empty">All items are well stocked 🎉</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="r" items="${lowStock}">
                  <tr>
                    <td>#${r.itemId}</td>
                    <td><c:out value="${r.name}"/></td>
                    <td class="right" style="color:#ea580c; font-weight:800">${r.stockQty}</td>
                    <td class="right">Rs. <fmt:formatNumber value="${r.unitPrice}" minFractionDigits="2" maxFractionDigits="2"/></td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Footer actions -->
  <div class="footer-actions">
    <button class="btn btn-ghost" onclick="location.href='${ctx}/dashboard'">← Back to Dashboard</button>
    <button class="btn btn-primary" onclick="window.print()">🖨️ Print Report</button>
  </div>
</div>

<script>
  // ---------- Chart (Daily Net Revenue) ----------
  const series = ${empty seriesJson ? '[]' : seriesJson};

  (function drawChart(){
    const cv = document.getElementById('salesChart');
    if(!cv || !series || !series.length){ return; }
    const ctx = cv.getContext('2d');
    const W = cv.width = cv.clientWidth;
    const H = cv.height = cv.clientHeight;

    const values = series.map(p => +p.net || 0);
    const labels = series.map(p => p.d || '');
    const max = Math.max(1, ...values);
    const pad = 44, gap = 8;
    const n = values.length;
    const barW = Math.max(10, (W - pad*2 - (n-1)*gap)/n);

    // bg gradient
    const g = ctx.createLinearGradient(0,0,0,H);
    g.addColorStop(0,'#fafaf9'); g.addColorStop(1,'#f8fafc');
    ctx.fillStyle = g; ctx.fillRect(0,0,W,H);

    // grid
    ctx.strokeStyle = 'rgba(15,118,110,0.10)'; ctx.lineWidth = 1;
    for(let i=1;i<=5;i++){
      const y = pad + (i/5)*(H-pad*2);
      ctx.beginPath(); ctx.moveTo(pad,y); ctx.lineTo(W-pad,y); ctx.stroke();
    }

    // axes
    ctx.strokeStyle = 'rgba(30,41,59,0.35)'; ctx.lineWidth = 2;
    ctx.beginPath(); ctx.moveTo(pad,pad-6); ctx.lineTo(pad,H-pad); ctx.lineTo(W-pad,H-pad); ctx.stroke();

    // bars
    const bgBar = ctx.createLinearGradient(0,pad,0,H-pad);
    bgBar.addColorStop(0,'#0f766e'); bgBar.addColorStop(1,'#14b8a6');
    ctx.fillStyle = bgBar;

    values.forEach((v,i)=>{
      const x = pad + i*(barW+gap);
      const h = Math.round((v/max)*(H-pad*2));
      const y = H - pad - h;
      // rounded bars
      const r = Math.min(8, barW/2, h);
      ctx.beginPath();
      ctx.moveTo(x, y+r);
      ctx.arcTo(x, y, x+r, y, r);
      ctx.lineTo(x+barW-r, y);
      ctx.arcTo(x+barW, y, x+barW, y+r, r);
      ctx.lineTo(x+barW, y+h);
      ctx.lineTo(x, y+h);
      ctx.closePath();
      ctx.shadowColor='rgba(0,0,0,0.10)'; ctx.shadowBlur=4; ctx.shadowOffsetY=2;
      ctx.fill();
      ctx.shadowColor='transparent'; ctx.shadowBlur=0; ctx.shadowOffsetY=0;
    });

    // y labels
    ctx.fillStyle='#475569'; ctx.font='bold 11px Segoe UI';
    for(let i=0;i<=5;i++){
      const val = (max/5)*i;
      const y = H - pad - (i/5)*(H-pad*2);
      ctx.fillText('Rs. ' + Math.round(val).toLocaleString(), 6, y+4);
    }

    // x labels
    ctx.fillStyle='#64748b'; ctx.font='10px Segoe UI';
    labels.forEach((d,i)=>{
      if(n<=14 || i % Math.ceil(n/10) === 0){
        const x = pad + i*(barW+gap) + barW/2;
        ctx.save(); ctx.translate(x, H - pad + 14); ctx.rotate(-Math.PI/6);
        ctx.fillText(d, 0, 0); ctx.restore();
      }
    });
  })();

  // ---------- Payment bars ----------
  (function(){
    const tbody = document.getElementById('payTbody');
    const wrap = document.getElementById('payBars');
    if(!tbody || !wrap) return;
    const rows = Array.from(tbody.querySelectorAll('tr')).filter(r=>r.children.length>=2 && r.querySelector('[data-amt]'));
    if(!rows.length) return;
    const amounts = rows.map(r => parseFloat(r.querySelector('[data-amt]').dataset.amt||'0'));
    const total = amounts.reduce((a,b)=>a+b,0) || 1;

    rows.forEach((r,i)=>{
      const method = r.children[0].textContent.trim();
      const amt = amounts[i];
      const pct = Math.round((amt/total)*1000)/10; // one decimal
      const row = document.createElement('div');
      row.className = 'bar-row';
      row.innerHTML = `<div style="width:120px">${method}</div>
                       <div class="bar" style="flex:1"><span style="width:${pct}%;"></span></div>
                       <small>${pct}%</small>`;
      wrap.appendChild(row);
    });
  })();

  // ---------- Quick ranges ----------
  (function(){
    const chips = document.querySelectorAll('.chip');
    const from = document.getElementById('from');
    const to = document.getElementById('to');
    const form = document.getElementById('filterForm');
    const clearBtn = document.getElementById('clearBtn');

    function fmt(d){ return d.toISOString().slice(0,10); }
    function startOfMonth(d){ return new Date(d.getFullYear(), d.getMonth(), 1); }
    function endOfMonth(d){ return new Date(d.getFullYear(), d.getMonth()+1, 0); }

    chips.forEach(ch=>{
      ch.addEventListener('click', ()=>{
        chips.forEach(x=>x.classList.remove('active'));
        ch.classList.add('active');
        const now = new Date();
        const r = ch.dataset.range;
        if(r==='today'){
          from.value = fmt(now); to.value = fmt(now);
        }else if(r==='7'){
          const s = new Date(now); s.setDate(now.getDate()-6);
          from.value = fmt(s); to.value = fmt(now);
        }else if(r==='30'){
          const s = new Date(now); s.setDate(now.getDate()-29);
          from.value = fmt(s); to.value = fmt(now);
        }else if(r==='month'){
          from.value = fmt(startOfMonth(now)); to.value = fmt(endOfMonth(now));
        }
        form.requestSubmit();
      });
    });

    if(clearBtn){
      clearBtn.addEventListener('click', ()=>{
        from.value=''; to.value='';
        document.getElementById('threshold').value='';
        chips.forEach(x=>x.classList.remove('active'));
        form.requestSubmit();
      });
    }
  })();

  // Subtle entrance animation
  document.addEventListener('DOMContentLoaded', ()=>{
    document.querySelectorAll('.stat .value').forEach((el,i)=>{
      el.style.opacity='0'; el.style.transform='translateY(8px)';
      setTimeout(()=>{ el.style.transition='all .5s ease'; el.style.opacity='1'; el.style.transform='translateY(0)'; }, i*80);
    });
  });
</script>
</body>
</html>
