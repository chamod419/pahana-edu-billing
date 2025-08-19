<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>User Report · ${username}</title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    .top{display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap;}
    .kpis{display:grid; grid-template-columns: repeat(5, minmax(160px,1fr)); gap:12px; margin-top:12px;}
    .card{border:1px solid #e3e3e3; border-radius:12px; padding:16px;}
    .kpi .label{color:#666; font-size:12px;}
    .kpi .value{font-size:20px; font-weight:700; margin-top:4px;}
    .grid{display:grid; grid-template-columns: 2fr 1fr; gap:16px; margin-top:16px;}
    table{width:100%; border-collapse:collapse;}
    th,td{border:1px solid #eee; padding:8px; text-align:left;}
    th.right, td.right{text-align:right}
    @media (max-width: 1100px){ .grid{grid-template-columns: 1fr;} .kpis{grid-template-columns: repeat(2,1fr);} }
  </style>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="top">
  <h2>User · <span style="font-weight:700"><c:out value="${username}"/></span></h2>
  <form method="get" action="${ctx}/admin/reports/users/detail" style="display:flex; gap:8px; align-items:end;">
    <input type="hidden" name="userId" value="${userId}"/>
    <div><label>From</label><br/><input type="date" name="from" value="${from}" required/></div>
    <div><label>To</label><br/><input type="date" name="to" value="${to}" required/></div>
    <div><button type="submit">Apply</button>
      <a href="${ctx}/admin/reports/users?from=${from}&to=${to}" style="margin-left:6px">Back</a></div>
  </form>
</div>

<!-- KPIs -->
<div class="kpis">
  <div class="card kpi"><div class="label">Bills</div><div class="value">${sum.bills}</div></div>
  <div class="card kpi"><div class="label">Items Sold</div><div class="value">${sum.itemsSold}</div></div>
  <div class="card kpi"><div class="label">Gross</div><div class="value">Rs. <fmt:formatNumber value="${sum.subTotal}" minFractionDigits="2" maxFractionDigits="2"/></div></div>
  <div class="card kpi"><div class="label">Discount</div><div class="value">Rs. <fmt:formatNumber value="${sum.discount}" minFractionDigits="2" maxFractionDigits="2"/></div></div>
  <div class="card kpi"><div class="label">Net</div><div class="value">Rs. <fmt:formatNumber value="${sum.net}" minFractionDigits="2" maxFractionDigits="2"/></div></div>
</div>

<div class="grid">
  <!-- Sales by Day -->
  <div class="card">
    <h3 style="margin-top:0">Sales by Day</h3>
    <canvas id="salesChart" height="120"></canvas>
  </div>

  <!-- Payment Breakdown -->
  <div class="card">
    <h3 style="margin-top:0">Payment Breakdown</h3>
    <table>
      <thead><tr><th>Method</th><th class="right">Amount (Rs.)</th></tr></thead>
      <tbody>
      <c:forEach var="p" items="${pay}">
        <tr><td>${p.method}</td>
          <td class="right"><fmt:formatNumber value="${p.total}" minFractionDigits="2" maxFractionDigits="2"/></td></tr>
      </c:forEach>
      <c:if test="${empty pay}"><tr><td colspan="2">No data.</td></tr></c:if>
      </tbody>
    </table>
  </div>
</div>

<div class="card" style="margin-top:16px;">
  <h3 style="margin-top:0">Bills by <c:out value="${username}"/></h3>
  <table>
    <thead>
      <tr>
        <th>ID</th><th>No</th><th>Date/Time</th><th>Customer</th>
        <th class="right">Gross</th><th class="right">Disc</th><th class="right">Net</th>
        <th>Method</th><th>Receipt</th>
      </tr>
    </thead>
    <tbody>
    <c:forEach var="b" items="${bills}">
      <tr>
        <td>${b.billId}</td>
        <td><c:out value="${b.billNo}"/></td>
        <td><fmt:formatDate value="${b.billDate}" pattern="yyyy-MM-dd HH:mm"/></td>
        <td><c:out value="${b.customerName}"/></td>
        <td class="right">Rs. <fmt:formatNumber value="${b.subTotal}" minFractionDigits="2" maxFractionDigits="2"/></td>
        <td class="right">Rs. <fmt:formatNumber value="${b.discountAmt}" minFractionDigits="2" maxFractionDigits="2"/></td>
        <td class="right">Rs. <fmt:formatNumber value="${b.netTotal}" minFractionDigits="2" maxFractionDigits="2"/></td>
        <td>${b.paymentMethod}</td>
        <td><a href="${ctx}/billing/receipt.pdf?id=${b.billId}" target="_blank">PDF</a></td>
      </tr>
    </c:forEach>
    <c:if test="${empty bills}">
      <tr><td colspan="9">No bills for this user in range.</td></tr>
    </c:if>
    </tbody>
  </table>
</div>

<script>
  // sales series
  const labels = [
    <c:forEach var="p" items="${series}" varStatus="s">"${p.day}"<c:if test="${!s.last}">,</c:if></c:forEach>
  ];
  const dataNet = [
    <c:forEach var="p" items="${series}" varStatus="s">${p.net}<c:if test="${!s.last}">,</c:if></c:forEach>
  ];
  const ctx = document.getElementById('salesChart').getContext('2d');
  new Chart(ctx, {
    type: 'line',
    data: { labels, datasets: [{ label: 'Net (Rs.)', data: dataNet, tension: 0.25 }] },
    options: { responsive:true, plugins:{ legend:{ display:true } }, scales:{ y:{ beginAtZero:true } } }
  });
</script>
</body>
</html>
