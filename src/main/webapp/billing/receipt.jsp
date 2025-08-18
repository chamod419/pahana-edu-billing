<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Receipt #${bill.billId}</title>
  <style>
    body{font-family: Arial, sans-serif; margin:24px;}
    .head{display:flex; justify-content:space-between; align-items:flex-start;}
    table{width:100%; border-collapse:collapse; margin-top:12px;}
    th,td{border:1px solid #eaeaea; padding:8px; text-align:left; vertical-align:top;}
    .right{text-align:right;}
    .big{font-size:20px; font-weight:800;}
    .muted{color:#777; font-size:12px;}
    .noprint a, .noprint button, .noprint input{margin-left:6px;}
    form.inline{display:inline;}
    @media print {.noprint{display:none}}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!-- compute discount % safely from gross/discount -->
<c:set var="discountPct" value="${bill.grossTotal > 0 ? (bill.discount * 100.0 / bill.grossTotal) : 0}"/>

<div class="head">
  <div>
    <h2>PahanaEdu — Receipt</h2>
    <div>Bill #${bill.billId}</div>
    <div>Customer: <c:out value="${customer.name}"/></div>
  </div>
  <div class="noprint">
    <a href="${ctx}/billing/new">New Bill</a> |
    <a href="${ctx}/billing/receipt.pdf?id=${bill.billId}">Open PDF</a> |
    <a href="${ctx}/billing/receipt.pdf?id=${bill.billId}&dl=download">Download PDF</a> |
    <form class="inline" action="${ctx}/billing/print" method="get">
      <input type="hidden" name="id" value="${bill.billId}"/>
      <input name="printer" placeholder="Printer name (optional)"/>
      <button type="submit">Print to POS</button>
    </form> |
    <a href="#" onclick="window.print();return false;">Print (Browser)</a>
    <div class="muted">Tip: If POS direct print doesn't work, use “Open PDF” → print to POS from browser.</div>
  </div>
</div>

<table>
  <thead>
    <tr>
      <th>Item</th>
      <th class="right">Qty</th>
      <th class="right">Unit</th>
      <th class="right">Line Disc.</th>
      <th class="right">Subtotal</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach var="bi" items="${bill.items}">
    <tr>
      <td><c:out value="${bi.itemName}"/></td>
      <td class="right">${bi.qty}</td>
      <td class="right">Rs. <fmt:formatNumber value="${bi.unitPrice}" minFractionDigits="2" maxFractionDigits="2"/></td>
      <td class="right">Rs. <fmt:formatNumber value="${bi.lineDiscount}" minFractionDigits="2" maxFractionDigits="2"/></td>
      <td class="right">Rs. <fmt:formatNumber value="${bi.subTotal}" minFractionDigits="2" maxFractionDigits="2"/></td>
    </tr>
  </c:forEach>
  </tbody>
  <tfoot>
    <tr>
      <th colspan="4" class="right">Gross</th>
      <th class="right">Rs. <fmt:formatNumber value="${bill.grossTotal}" minFractionDigits="2" maxFractionDigits="2"/></th>
    </tr>
    <tr>
      <th colspan="4" class="right">
        Discount
        (<fmt:formatNumber value="${discountPct}" minFractionDigits="0" maxFractionDigits="2"/>%)
      </th>
      <th class="right">Rs. <fmt:formatNumber value="${bill.discount}" minFractionDigits="2" maxFractionDigits="2"/></th>
    </tr>
    <tr>
      <th colspan="4" class="right big">Net Total</th>
      <th class="right big">Rs. <fmt:formatNumber value="${bill.netTotal}" minFractionDigits="2" maxFractionDigits="2"/></th>
    </tr>
  </tfoot>
</table>

<p>Notes: <c:out value="${bill.notes}"/></p>
</body>
</html>
