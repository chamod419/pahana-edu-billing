<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Generate Bill - PahanaEdu</title>
  <style>
    :root{
      /* Brand palette */
      --deep-navy:#1e3a8a; --forest:#166534; --midnight:#1e293b; --teal:#0f766e; --royal:#2563eb;
      --gold:#f59e0b; --emerald:#059669; --orange:#ea580c;
      --white:#ffffff; --cream:#fefbf3; --lg:#f8fafc; --off:#fafaf9;
      --charcoal:#374151; --dark:#1f2937; --slate:#475569; --graphite:#111827;

      --border:#e5e7eb; --muted:#94a3b8;
      --radius-xl:24px; --radius-lg:16px; --radius-md:12px;

      /* Button tokens */
      --btn-h:40px; --btn-radius:10px; --btn-pad-x:14px;
      --btn-shadow:0 5px 12px rgba(2, 6, 23, .14);
      --btn-shadow-hover:0 9px 18px rgba(2, 6, 23, .2);
      --btn-shadow-inset:inset 0 1px 0 rgba(255,255,255,.25);
      --btn-border:1px solid rgba(0,0,0,.06);

      --focus:0 0 0 3px rgba(15,118,110,.16);
      --shadow-1:0 10px 25px rgba(0,0,0,.08), 0 0 0 1px rgba(0,0,0,.02);
    }

    *{box-sizing:border-box;margin:0;padding:0}
    body{
      font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color:var(--charcoal);
      background:linear-gradient(135deg, var(--lg) 0%, #e2e8f0 100%);
      min-height:100vh; padding:24px; overflow-x:hidden;
    }
    body::before{
      content:''; position:fixed; inset:0; pointer-events:none; z-index:-1;
      background:url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60"><defs><pattern id="p" width="22" height="22" patternUnits="userSpaceOnUse"><circle cx="11" cy="11" r="1" fill="rgba(15,118,110,0.05)"/></pattern></defs><rect width="100%" height="100%" fill="url(%23p)"/></svg>');
    }
    .container{max-width:1250px;margin:0 auto}

    /* ===== Header ===== */
    .header{
      background:linear-gradient(135deg, var(--midnight) 0%, var(--teal) 55%, var(--deep-navy) 100%);
      color:#fff; border-radius:var(--radius-xl); padding:22px 24px; margin-bottom:18px;
      position:relative; overflow:hidden; box-shadow:0 10px 25px rgba(30,41,59,.15), 0 0 0 1px rgba(255,255,255,.08) inset;
    }
    .header::before{
      content:''; position:absolute; inset:0;
      background:linear-gradient(45deg,transparent 30%,rgba(255,255,255,.10) 50%,transparent 70%);
      animation:shimmer 3s ease-in-out infinite;
    }
    @keyframes shimmer{0%,100%{transform:translateX(-100%)}50%{transform:translateX(100%)}}
    .header-content{position:relative; z-index:1; display:flex; justify-content:space-between; align-items:center; gap:10px; flex-wrap:wrap}
    .title{font-size:26px; font-weight:800; display:flex; align-items:center; gap:10px}
    .header-actions{display:flex; gap:10px; flex-wrap:wrap}

    /* === Common glass button (header Dashboard) === */
    .btn{
      appearance:none; height:var(--btn-h); line-height:calc(var(--btn-h) - 2px);
      padding:0 var(--btn-pad-x); border-radius:var(--btn-radius); border:var(--btn-border);
      background:rgba(255,255,255,.18); color:#fff; font-weight:700; font-size:14px;
      text-decoration:none; display:inline-flex; align-items:center; justify-content:center; gap:8px;
      cursor:pointer; transition:transform .12s ease, box-shadow .18s ease, background .18s ease;
      box-shadow:0 8px 20px rgba(0,0,0,.15), inset 0 0 0 1px rgba(255,255,255,.25);
      backdrop-filter: blur(8px);
    }
    .btn:hover{ transform:translateY(-2px); box-shadow:0 12px 26px rgba(0,0,0,.22), inset 0 0 0 1px rgba(255,255,255,.3); }
    .btn:focus-visible{ outline:none; box-shadow:var(--focus), 0 8px 20px rgba(0,0,0,.15); }

    .logo-wrap{position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); z-index:1; pointer-events:none}
    .logo{width:60px;height:60px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 8px 20px rgba(0,0,0,.25);padding:7px}
    .logo img{max-width:46px;max-height:46px;object-fit:contain}

    /* ===== Layout / Cards / Table ===== */
    .row{display:flex; gap:10px; align-items:center; flex-wrap:wrap}
    .grid{display:grid; grid-template-columns:1fr; gap:16px}
    .layout{ display:grid; grid-template-columns: minmax(0, 1fr) 360px; gap:16px; }
    @media (max-width: 1024px){ .layout{grid-template-columns:1fr} }
    .card{ background:#fff; border:1px solid var(--border); border-radius:16px; padding:16px; box-shadow:var(--shadow-1); }
    .section-title{margin:0 0 10px 0; font-weight:800; color:var(--midnight); display:flex; align-items:center; gap:8px}
    .muted{color:var(--slate); font-size:12px}
    .divider{height:1px; background:#eef2f7; margin:10px 0}
    input,select,textarea{
      padding:10px 12px; border:1px solid var(--border); border-radius:10px; font-size:14px;
      outline:none; transition:.18s; background:#fff;
    }
    input:focus,select:focus,textarea:focus{box-shadow:var(--focus); border-color:var(--teal)}
    .chip{display:inline-flex; align-items:center; gap:6px; padding:6px 10px; border-radius:999px; font-weight:700; font-size:12px; border:1px solid #dbeafe; background:#eef2ff; color:var(--deep-navy)}

    .table-card{padding:0; overflow:hidden}
    .table-head{padding:12px 14px; background:#f8fafc; border-bottom:1px solid var(--border); display:flex; align-items:center; justify-content:space-between}
    .table-wrap{max-height:52vh; overflow:auto}
    table{width:100%; border-collapse:collapse}
    thead th{
      background:#f8fafc; color:#374151; font-weight:800; text-transform:uppercase; letter-spacing:.5px; font-size:12px;
      padding:12px 14px; border-bottom:2px solid #e5e7eb; text-align:left; position:sticky; top:0; z-index:1;
    }
    tbody td{padding:12px 14px; border-top:1px solid #f1f5f9; vertical-align:middle; font-size:14px}
    th.right, td.right{text-align:right; white-space:nowrap}
    tbody tr:hover{background:#fbfdff}
    tfoot th, tfoot td{padding:12px 14px; border-top:2px solid #e5e7eb; background:#fcfdfd}

    .qty-group{display:inline-flex; align-items:center; border:1px solid var(--border); border-radius:10px; overflow:hidden}
    .qty-group input{width:70px; border:0; text-align:center; height:34px}
    .qty-btn{height:34px; width:34px; border:0; background:#f8fafc; cursor:pointer; font-size:16px}
    .qty-btn:hover{background:#eef2f7}

    .sticky{position:sticky; top:16px}
    .summary-row{display:flex; justify-content:space-between; align-items:center; margin:8px 0}
    .summary-row strong{font-size:16px}
    .total-figure{font-size:22px; font-weight:800; color:var(--midnight)}
    .note{font-size:12px; color:var(--muted)}

    .flash{padding:10px 12px;border-radius:12px;font-weight:700;display:flex;gap:10px;align-items:center;margin:12px 0}
    .ok{background:linear-gradient(135deg,#dcfce7,#bbf7d0); color:#166534; border:1px solid #bbf7d0}
    .err{background:linear-gradient(135deg,#fee2e2,#fecaca); color:#dc2626; border:1px solid #fecaca}

    /* ===== Payment Summary: Professional CTA buttons ===== */
    .cta{
      height:46px; padding:0 16px; border-radius:12px; font-weight:800; letter-spacing:.2px;
      display:inline-flex; align-items:center; justify-content:center; gap:10px; width:auto;
      border:1px solid transparent; cursor:pointer; text-decoration:none; user-select:none;
      transition:transform .12s ease, box-shadow .2s ease, filter .2s ease, opacity .2s ease, background .2s ease;
    }
    .cta-block{width:100%}
    .cta .icon{width:20px; display:inline-flex; align-items:center; justify-content:center}

    .cta-primary{
      color:#fff;
      background:
        radial-gradient(120% 120% at 30% 20%, rgba(255,255,255,.18), transparent),
        linear-gradient(135deg, var(--teal), var(--emerald));
      box-shadow:0 10px 22px rgba(15,118,110,.28);
    }
    .cta-primary:hover{ transform:translateY(-1px); filter:saturate(1.05); box-shadow:0 14px 28px rgba(15,118,110,.34) }
    .cta-primary:disabled{
      background:linear-gradient(#e5e7eb,#e5e7eb); color:#9ca3af; box-shadow:none; cursor:not-allowed; transform:none;
    }

    .cta-outline{
      color:var(--dark);
      background:linear-gradient(#fff,#fff) padding-box,
                 linear-gradient(135deg, rgba(30,41,59,.18), rgba(37,99,235,.28)) border-box;
      border:1px solid transparent;
      box-shadow:0 6px 16px rgba(2,6,23,.06);
    }
    .cta-outline:hover{
      transform:translateY(-1px);
      background:linear-gradient(#f8fafc,#f8fafc) padding-box,
                 linear-gradient(135deg, rgba(30,41,59,.22), rgba(37,99,235,.34)) border-box;
      box-shadow:0 10px 20px rgba(2,6,23,.12);
    }

    .cta-danger{
      color:#fff;
      background:
        radial-gradient(120% 120% at 30% 20%, rgba(255,255,255,.16), transparent),
        linear-gradient(135deg, #dc2626, #ef4444);
      box-shadow:0 10px 22px rgba(220,38,38,.24);
    }
    .cta-danger:hover{ transform:translateY(-1px); box-shadow:0 14px 28px rgba(220,38,38,.30) }

    .ps-actions{ display:grid; grid-template-columns:1fr 1fr; gap:10px; }
    @media (max-width:520px){ .ps-actions{ grid-template-columns:1fr; } }
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="container">
  <!-- Header -->
  <div class="header">
    <div class="header-content">
      <h1 class="title">🧾 Generate Bill</h1>
      <div class="header-actions">
        <a class="btn" href="${ctx}/dashboard">🏠 Dashboard</a>
      </div>
    </div>
    <div class="logo-wrap">
      <div class="logo">
        <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu"
             onerror="this.style.display='none'; this.parentNode.innerHTML='<strong style=&quot;color:#1e293b&quot;>PE</strong>';">
      </div>
    </div>
  </div>

  <!-- Messages -->
  <c:if test="${not empty param.msg}"><div class="flash ok">✅ <strong><c:out value="${param.msg}"/></strong></div></c:if>
  <c:if test="${not empty param.error}"><div class="flash err">❌ <strong><c:out value="${param.error}"/></strong></div></c:if>

  <!-- Main Layout -->
  <div class="layout">
    <div class="left-col">
      <div class="grid">
        <!-- Customer -->
        <div class="card">
          <h3 class="section-title">👤 Customer</h3>
          <c:choose>
            <c:when test="${not empty customer}">
              <div>
                <strong style="font-size:16px"><c:out value="${customer.name}"/></strong>
                <span class="chip" title="Account Number">${customer.accountNumber}</span>
                <div class="muted" style="margin-top:6px">
                  <c:out value="${customer.phone}"/> • <c:out value="${customer.email}"/><br/>
                  <c:out value="${customer.address}"/>
                </div>
              </div>
              <form action="${ctx}/billing/setCustomer" method="post" style="margin-top:10px">
                <input type="hidden" name="clear" value="1"/>
                <button class="cta cta-outline" type="submit"><span class="icon">🧹</span>Clear Customer</button>
              </form>
            </c:when>
            <c:otherwise>
              <div class="row">
                <label>Account #</label>
                <form action="${ctx}/billing/setCustomer" method="post" class="row">
                  <input name="accountNumber" placeholder="C-0001" required/>
                  <button class="cta cta-primary" type="submit"><span class="icon">➕</span>Attach</button>
                </form>
                <a class="cta cta-outline" href="${ctx}/customers/new" target="_blank">+ New Customer</a>
              </div>

              <div class="divider"></div>

              <form class="row" action="${ctx}/billing" method="get">
                <input name="q" value="${searchQ}" placeholder="Search by name, phone, account…" style="min-width:280px"/>
                <button class="cta cta-outline" type="submit"><span class="icon">🔎</span>Search</button>
                <span class="muted">Tip: Focus search with <span style="border:1px solid var(--border); padding:0 6px; border-radius:6px; background:#fff; font-family:ui-monospace,Menlo,Consolas,monospace">/</span></span>
              </form>

              <c:if test="${not empty matches}">
                <div class="muted" style="margin:8px 0 6px 0">Results for “<c:out value="${searchQ}"/>”</div>
                <div style="max-height:240px; overflow:auto; border:1px solid var(--border); border-radius:12px">
                  <table>
                    <thead>
                    <tr><th>Account</th><th>Name</th><th>Phone</th><th>Email</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="m" items="${matches}">
                      <tr>
                        <td>${m.accountNumber}</td>
                        <td><c:out value="${m.name}"/></td>
                        <td><c:out value="${m.phone}"/></td>
                        <td><c:out value="${m.email}"/></td>
                        <td>
                          <form action="${ctx}/billing/setCustomer" method="post" class="row">
                            <input type="hidden" name="customerId" value="${m.customerId}"/>
                            <button class="cta cta-primary" type="submit"><span class="icon">➕</span>Attach</button>
                          </form>
                        </td>
                      </tr>
                    </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:if>
            </c:otherwise>
          </c:choose>
        </div>

        <!-- Add Item -->
        <div class="card">
          <h3 class="section-title">➕ Add Item</h3>
          <form class="row" action="${ctx}/billing/add" method="post">
            <input id="itemFilter" placeholder="Type to filter items…" style="min-width:240px"/>
            <select id="itemSelect" name="itemId" required style="min-width:340px">
              <c:forEach var="it" items="${activeItems}">
                <option value="${it.itemId}">
                  ${it.name} — Rs. ${it.unitPrice} (Stock: ${it.stockQty}) [${it.category}]
                </option>
              </c:forEach>
            </select>
            <label>Qty</label>
            <input type="number" min="1" name="qty" value="1" style="width:90px"/>
            <button class="cta cta-primary" type="submit"><span class="icon">➕</span>Add</button>
          </form>
          <div class="muted" style="margin-top:6px">Use “/” to focus item filter quickly.</div>
        </div>
      </div>

      <!-- Items Table -->
      <div class="card table-card" style="margin-top:16px">
        <div class="table-head">
          <div class="section-title" style="margin:0">🧺 Items</div>
          <div class="muted">Qty quick edit: use − / +</div>
        </div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>#</th>
                <th>Item</th>
                <th class="right">Price</th>
                <th class="right">Qty</th>
                <th class="right">Total</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="li" items="${bill.items}" varStatus="s">
                <tr>
                  <td>${s.index+1}</td>
                  <td><c:out value="${li.itemName}"/></td>
                  <td class="right">Rs. ${li.unitPrice}</td>
                  <td class="right">
                    <form action="${ctx}/billing/updateQty" method="post" class="row" style="justify-content:flex-end; gap:8px">
                      <input type="hidden" name="billItemId" value="${li.billItemId}"/>
                      <div class="qty-group">
                        <button class="qty-btn" type="button" aria-label="Decrease" onclick="stepQty(this,-1)">−</button>
                        <input type="number" min="1" name="qty" value="${li.qty}" />
                        <button class="qty-btn" type="button" aria-label="Increase" onclick="stepQty(this,1)">+</button>
                      </div>
                      <button class="cta cta-outline" type="submit">Update</button>
                    </form>
                  </td>
                  <td class="right">Rs. ${li.lineTotal}</td>
                  <td>
                    <form action="${ctx}/billing/remove" method="post"
                          onsubmit="return confirm('Remove this line?');">
                      <input type="hidden" name="billItemId" value="${li.billItemId}">
                      <button class="cta cta-danger" type="submit"><span class="icon">🗑️</span>Remove</button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty bill.items}">
                <tr><td colspan="6" class="muted" style="text-align:center">No items yet. Add items above.</td></tr>
              </c:if>
            </tbody>
            <tfoot>
              <tr>
                <th colspan="4" class="right">Sub Total</th>
                <th class="right">Rs. ${bill.subTotal}</th>
                <th></th>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>

      <!-- Notes -->
      <div class="card" style="margin-top:16px">
        <h3 class="section-title">📝 Notes</h3>
        <form action="${ctx}/billing/setNotes" method="post">
          <textarea name="notes" rows="4" style="width:100%" placeholder="Add notes for the receipt…">${bill.notes}</textarea>
          <div class="muted" style="margin-top:6px">Shown on the PDF receipt.</div>
          <div style="margin-top:10px">
            <button class="cta cta-outline" type="submit">Save Notes</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Sticky Payment -->
    <div class="right-col">
      <div class="card sticky">
        <h3 class="section-title">💳 Payment Summary</h3>

        <div class="summary-row">
          <span>Sub Total</span>
          <strong id="subtotalVal" data-val="${bill.subTotal}">Rs. ${bill.subTotal}</strong>
        </div>

        <div class="divider"></div>

        <div>
          <label style="display:block; font-weight:700; margin-bottom:6px">Discount</label>
          <div class="row">
            <label><input type="radio" name="discountMode" value="AMT" checked> Amount (Rs.)</label>
            <label style="margin-left:12px"><input type="radio" name="discountMode" value="PCT"> Percentage (%)</label>
          </div>
          <div class="row" style="margin-top:8px">
            <input id="discAmt" type="number" step="0.01" min="0" placeholder="0.00" style="width:150px"
                   value="${bill.discountAmt}"/>
            <c:set var="prefPct" value="${bill.subTotal gt 0 ? (bill.discountAmt * 100.0 / bill.subTotal) : 0}"/>
            <input id="discPct" type="number" step="0.01" min="0" max="100" placeholder="0.00"
                   style="width:130px; display:none" value="${prefPct}"/>
          </div>
          <div class="note" style="margin-top:6px">Choose one mode. We’ll prevent discount exceeding subtotal.</div>
        </div>

        <div class="divider"></div>

        <div>
          <label style="display:block; font-weight:700; margin-bottom:6px">Payment Method</label>
          <select id="payMethod" style="min-width:100%">
            <option ${bill.paymentMethod=='CASH'?'selected':''}>CASH</option>
            <option ${bill.paymentMethod=='CARD'?'selected':''}>CARD</option>
            <option ${bill.paymentMethod=='ONLINE'?'selected':''}>ONLINE</option>
          </select>
        </div>

        <div class="divider"></div>

        <div class="summary-row">
          <span>Estimated Net Total</span>
          <span class="total-figure" id="netEst">Rs. ${bill.netTotal}</span>
        </div>

        <div class="muted" style="margin-top:6px">Finalize quickly with Ctrl + Enter</div>

        <form action="${ctx}/billing/finalize" method="post" style="margin-top:12px">
          <input type="hidden" name="paymentMethod" id="pmHidden" value="${bill.paymentMethod}"/>
          <input type="hidden" name="discountAmt" id="discAmtHidden" value="${bill.discountAmt}"/>
          <input type="hidden" name="discountPct" id="discPctHidden" value="${prefPct}"/>
          <button id="finalizeBtn" class="cta cta-primary cta-block" type="submit" ${empty bill.items ? 'disabled' : ''}>
            <span class="icon">✅</span>Finalize
          </button>
        </form>

        <div class="ps-actions" style="margin-top:10px">
          <a class="cta cta-outline cta-block" href="${ctx}/billing/new"><span class="icon">🔄</span>New Bill</a>
          <a class="cta cta-outline cta-block" href="${ctx}/dashboard"><span class="icon">↩</span>Back</a>
        </div>

        <form action="${ctx}/billing/cancel" method="post" style="margin-top:10px"
              onsubmit="return confirm('Cancel this bill?');">
          <button class="cta cta-danger cta-block" type="submit"><span class="icon">✖</span>Cancel</button>
        </form>

        <label class="note" style="display:block; margin-top:8px">
          <input type="checkbox" id="goDash" /> Go to Dashboard after finalize
        </label>
      </div>
    </div>
  </div>
</div>

<script>
  function stepQty(btn, delta){
    const wrap = btn.closest('.qty-group');
    const input = wrap.querySelector('input[name="qty"]');
    const v = Math.max(1, (parseInt(input.value || '1', 10) + delta));
    input.value = v;
  }
  function fmtRs(v){ return 'Rs. ' + Number(v||0).toFixed(2); }

  // Item filter
  (function(){
    const filter = document.getElementById('itemFilter');
    const select = document.getElementById('itemSelect');
    if (!filter || !select) return;
    const all = Array.from(select.options).map(o => ({value:o.value, text:o.text}));
    filter.addEventListener('input', () => {
      const q = filter.value.toLowerCase();
      select.innerHTML = '';
      all.filter(o => o.text.toLowerCase().includes(q)).forEach(o => {
        const opt = document.createElement('option'); opt.value=o.value; opt.text=o.text; select.appendChild(opt);
      });
    });
  })();

  // Discount / Net total preview
  (function(){
    const subtotal = parseFloat(document.getElementById('subtotalVal').dataset.val || '0') || 0;
    const netEst = document.getElementById('netEst');
    const discAmt = document.getElementById('discAmt');
    const discPct = document.getElementById('discPct');
    const radios = document.querySelectorAll('input[name="discountMode"]');
    const pm = document.getElementById('payMethod');
    const pmHidden = document.getElementById('pmHidden');
    const discAmtHidden = document.getElementById('discAmtHidden');
    const discPctHidden = document.getElementById('discPctHidden');

    function setMode() {
      const mode = Array.from(radios).find(r => r.checked)?.value || 'AMT';
      if (mode === 'PCT') {
        discPct.style.display = '';
        discAmt.style.display = 'none';
      } else {
        discPct.style.display = 'none';
        discAmt.style.display = '';
      }
      recalcNet();
    }
    function recalcNet(){
      const mode = Array.from(radios).find(r => r.checked)?.value || 'AMT';
      let discount = 0;
      if (mode === 'PCT') {
        const p = Math.max(0, Math.min(100, parseFloat(discPct.value || '0')));
        discount = subtotal * (p/100.0);
        discPctHidden.value = p;
        discAmtHidden.value = '';
      } else {
        const a = Math.max(0, parseFloat(discAmt.value || '0'));
        discount = a;
        discAmtHidden.value = a;
        discPctHidden.value = '';
      }
      if (discount > subtotal) discount = subtotal;
      const net = subtotal - discount;
      netEst.textContent = fmtRs(net);
    }
    radios.forEach(r => r.addEventListener('change', setMode));
    discAmt.addEventListener('input', recalcNet);
    discPct.addEventListener('input', recalcNet);
    pm.addEventListener('change', () => pmHidden.value = pm.value);
    setMode();
  })();

  // Keyboard shortcuts
  (function(){
    const itemFilter = document.getElementById('itemFilter');
    const searchQ = document.querySelector('input[name="q"]');
    const finalizeBtn = document.getElementById('finalizeBtn');
    document.addEventListener('keydown', function(e){
      if (e.key === '/' && !e.metaKey && !e.ctrlKey && !e.altKey) {
        e.preventDefault();
        if (itemFilter) itemFilter.focus();
        else if (searchQ) searchQ.focus();
      }
      if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
        if (finalizeBtn && !finalizeBtn.disabled) finalizeBtn.click();
      }
    });
  })();
</script>
</body>
</html>
	