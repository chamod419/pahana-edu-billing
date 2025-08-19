<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>Receipt <c:out value="${(not empty bill.billId) ? bill.billId : param.id}"/></title>
  <style>
    :root{
      --deep-navy:#1e3a8a; --forest:#166534; --midnight:#1e293b; --teal:#0f766e; --royal:#2563eb;
      --lg:#f8fafc; --border:#e5e7eb; --text:#111827; --slate:#475569;
      --shadow:0 10px 25px rgba(0,0,0,.08), 0 0 0 1px rgba(0,0,0,.02);
      --radius:16px;
    }
    *{box-sizing:border-box}
    html,body{height:100%}
    body{
      font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color:var(--text); background:linear-gradient(135deg, var(--lg) 0%, #e2e8f0 100%);
      margin:0; padding:28px;
    }
    .container{max-width:880px;margin:0 auto}

    .bar{
      background:linear-gradient(135deg, var(--midnight) 0%, var(--teal) 55%, var(--deep-navy) 100%);
      color:#fff; border-radius:24px; padding:18px 22px; position:relative; overflow:hidden;
      box-shadow:0 10px 25px rgba(30,41,59,.15), 0 0 0 1px rgba(255,255,255,.08) inset;
    }
    .bar::before{
      content:''; position:absolute; inset:0;
      background:linear-gradient(45deg,transparent 30%,rgba(255,255,255,.10) 50%,transparent 70%);
      animation:shimmer 3s ease-in-out infinite;
    }
    @keyframes shimmer{0%,100%{transform:translateX(-100%)}50%{transform:translateX(100%)}}
    .bar-inner{position:relative; z-index:1; display:flex; align-items:center; justify-content:space-between; gap:16px; flex-wrap:wrap}
    .brand{display:flex; align-items:center; gap:12px}
    .logo{width:56px;height:56px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 8px 20px rgba(0,0,0,.22)}
    .logo img{max-width:42px;max-height:42px;object-fit:contain}
    .title{font-size:22px; font-weight:800; letter-spacing:.2px}
    .meta-small{opacity:.9; font-size:12px}

    .actions{display:flex; gap:10px; flex-wrap:wrap; margin-top:14px}
    .btn{appearance:none; border:1px solid transparent; border-radius:12px; padding:10px 16px;
      font-weight:800; letter-spacing:.2px; cursor:pointer; text-decoration:none; display:inline-flex; align-items:center; gap:8px;
      transition:transform .12s ease, box-shadow .2s ease;}
    .btn:hover{transform:translateY(-1px)}
    .btn-primary{color:#fff; background:linear-gradient(135deg, var(--teal), #059669); box-shadow:0 10px 22px rgba(15,118,110,.28)}
    .btn-outline{color:#1f2937; background:#fff; border:1px solid var(--border); box-shadow:var(--shadow)}
    .btn-danger{color:#fff; background:linear-gradient(135deg,#dc2626,#ef4444); box-shadow:0 10px 22px rgba(220,38,38,.24)}

    .card{background:#fff; border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow); overflow:hidden; margin-top:18px}
    .receipt-head{display:flex; justify-content:space-between; align-items:flex-start; gap:16px; padding:18px 20px; background:#f8fafc; border-bottom:1px solid var(--border)}
    .block h4{margin:0 0 4px 0; font-size:14px; font-weight:800; color:#1e293b}
    .block div{font-size:13px; color:#374151}
    .badge{display:inline-block; padding:4px 10px; border-radius:999px; font-size:12px; font-weight:800; border:1px solid #bbf7d0; color:#166534; background:#dcfce7}

    .tbl{width:100%; border-collapse:collapse}
    .tbl thead th{background:#f8fafc; border-bottom:2px solid var(--border); padding:12px 14px; text-align:left; font-size:12px; text-transform:uppercase; letter-spacing:.4px; color:#374151}
    .tbl tbody td{border-bottom:1px solid #f1f5f9; padding:12px 14px; vertical-align:top; font-size:14px}
    .right{text-align:right; white-space:nowrap}
    .totals{background:#fcfdfd}
    .notes{padding:14px 20px; color:var(--slate); font-size:13px}
    .foot{padding:14px 20px; text-align:center; color:#374151}

    @media print{
      body{background:#fff; padding:0}
      .bar, .actions{display:none !important}
      .card{border:0; border-radius:0; box-shadow:none; margin:0}
      .receipt-head{border-bottom:1px solid #ddd; background:#fff}
      .notes, .foot{page-break-inside:avoid}
    }
  </style>
</head>
<body>
<jsp:useBean id="now" class="java.util.Date" />
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="rid" value="${(not empty bill.billId) ? bill.billId : param.id}"/>

<!-- Robust date fallback: try multiple fields, else 'now' -->
<c:set var="billDateText"
       value="${not empty bill.billDate ? bill.billDate :
               (not empty bill.createdAt ? bill.createdAt :
               (not empty bill.createdOn ? bill.createdOn :
               (not empty bill.issuedAt ? bill.issuedAt :
               (not empty bill.timestamp ? bill.timestamp : now))))}"/>

<c:set var="cashierName" value="${not empty sessionScope.user.username ? sessionScope.user.username : '—'}"/>

<div class="container">
  <!-- Top Bar -->
  <div class="bar">
    <div class="bar-inner">
      <div class="brand">
        <div class="logo">
          <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu" onerror="this.style.display='none'">
        </div>
        <div>
          <div class="title">PahanaEdu • Receipt</div>
          <div class="meta-small">Receipt #<strong>${rid}</strong></div>
        </div>
      </div>
      <div class="meta-small" style="text-align:right">
        <!-- FIX: no direct bill.date access -->
        <div><c:out value="${billDateText}"/></div>
        <div>Cashier: <c:out value="${cashierName}"/></div>
      </div>
    </div>

    <!-- Actions (screen only) -->
    <div class="actions">
      <button class="btn btn-primary" onclick="window.print()">🖨️ Print</button>
      <a class="btn btn-outline" target="_blank" href="${ctx}/billing/receipt.pdf?id=${rid}">👁️ Preview PDF</a>
      <a class="btn btn-outline" href="${ctx}/billing/receipt.pdf?id=${rid}&dl=download">⬇️ Download PDF</a>
      <a class="btn btn-outline" href="${ctx}/billing/new">🔄 New Bill</a>
      <a class="btn btn-outline" href="${ctx}/dashboard">🏠 Dashboard</a>
      <form action="${ctx}/billing/print" method="get" style="margin-left:auto; display:flex; gap:8px; align-items:center">
        <input type="hidden" name="id" value="${rid}"/>
        <input name="printer" placeholder="Printer name (optional)"
               style="padding:10px 12px;border:1px solid #e5e7eb;border-radius:10px"/>
        <button class="btn btn-danger" type="submit">🧾 Print to POS</button>
      </form>
    </div>
  </div>

  <!-- Receipt -->
  <div class="card">
    <div class="receipt-head">
      <div class="block">
        <h4>Customer</h4>
        <div><c:out value="${customer.name}"/></div>
        <div class="meta-small"><c:out value="${customer.accountNumber}"/></div>
      </div>
      <div class="block">
        <h4>Contact</h4>
        <div class="meta-small">
          <c:out value="${customer.phone}"/> • <c:out value="${customer.email}"/><br/>
          <c:out value="${customer.address}"/>
        </div>
      </div>
      <div class="block" style="text-align:right">
        <h4>Payment</h4>
        <div><span class="badge"><c:out value="${bill.paymentMethod}"/></span></div>
      </div>
    </div>

    <table class="tbl">
      <thead>
        <tr>
          <th style="width:56px">#</th>
          <th>Item</th>
          <th class="right">Price</th>
          <th class="right">Qty</th>
          <th class="right">Total</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="li" items="${bill.items}" varStatus="s">
          <tr>
            <td>${s.index+1}</td>
            <td><c:out value="${li.itemName}"/></td>
            <td class="right">Rs. ${li.unitPrice}</td>
            <td class="right">${li.qty}</td>
            <td class="right">Rs. ${li.lineTotal}</td>
          </tr>
        </c:forEach>
        <c:if test="${empty bill.items}">
          <tr><td colspan="5" style="text-align:center; color:#6b7280">No line items.</td></tr>
        </c:if>
      </tbody>
      <tfoot>
        <tr class="totals">
          <th colspan="4" class="right">Sub Total</th>
          <th class="right">Rs. ${bill.subTotal}</th>
        </tr>
        <tr class="totals">
          <th colspan="4" class="right">Discount</th>
          <th class="right">Rs. ${bill.discountAmt}</th>
        </tr>
        <tr class="totals">
          <th colspan="4" class="right">Net Total</th>
          <th class="right" style="font-size:16px">Rs. ${bill.netTotal}</th>
        </tr>
      </tfoot>
    </table>

    <c:if test="${not empty bill.notes}">
      <div class="notes">
        <strong>Notes:</strong>
        <div style="white-space:pre-wrap; margin-top:6px"><c:out value="${bill.notes}"/></div>
      </div>
    </c:if>

    <div class="foot">Thank you for your purchase!</div>
  </div>
</div>

<script>
  // Auto-print if ?autoprint=1 ; after print go to dashboard if ?goDash=1
  window.addEventListener('load', function(){
    const q = new URLSearchParams(location.search);
    if (q.get('autoprint') === '1') {
      setTimeout(() => window.print(), 300);
    }
  });
  window.addEventListener('afterprint', function(){
    const q = new URLSearchParams(location.search);
    if (q.get('goDash') === '1') {
      location.href = '<c:out value="${ctx}"/>/dashboard';
    }
  });
</script>
</body>
</html>
