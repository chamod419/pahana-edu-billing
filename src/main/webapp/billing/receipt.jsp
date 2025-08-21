<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>Receipt #${bill.billId}</title>
  <style>
    :root{
      --deep-navy:#1e3a8a; --midnight:#1e293b; --teal:#0f766e; --emerald:#059669;
      --border:#e5e7eb; --muted:#64748b; --ink:#111827; --lg:#f8fafc;
    }
    *{box-sizing:border-box}
    body{
      font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color:var(--ink); margin:24px; background:#fff;
    }

    .receipt{
      max-width:820px; margin:0 auto; border:1px solid var(--border); border-radius:16px; overflow:hidden;
      box-shadow:0 12px 28px rgba(0,0,0,.08);
    }

    /* Header */
    .head{
      background:linear-gradient(135deg, var(--midnight) 0%, var(--teal) 55%, var(--deep-navy) 100%);
      color:#fff; padding:18px 20px; position:relative;
    }
    .head-inner{display:flex; justify-content:space-between; align-items:flex-start; gap:12px}
    .brand{font-weight:800; font-size:20px; display:flex; align-items:center; gap:10px}
    .logo{width:44px; height:44px; border-radius:50%; background:#fff; display:flex; align-items:center; justify-content:center; box-shadow:0 8px 20px rgba(0,0,0,.25); overflow:hidden}
    .logo img{max-width:34px; max-height:34px; object-fit:contain}
    .meta{font-size:13px; opacity:.95; text-align:right}

    .meta small{display:block; color:rgba(255,255,255,.85)}
    .section{padding:16px 20px}

    /* Info grid */
    .grid{display:grid; grid-template-columns:1fr 1fr; gap:16px}
    .box{background:#fff; border:1px solid var(--border); border-radius:12px; padding:12px 14px}
    .label{font-size:11px; color:var(--muted); text-transform:uppercase; letter-spacing:.4px; font-weight:800}
    .value{font-size:14px; font-weight:700}

    /* Table */
    table{width:100%; border-collapse:collapse; margin-top:6px}
    thead th{
      background:#f8fafc; border-bottom:2px solid var(--border); text-align:left; padding:10px 12px;
      text-transform:uppercase; letter-spacing:.5px; font-size:12px; color:#334155
    }
    td{padding:10px 12px; border-bottom:1px solid #f1f5f9; vertical-align:top; font-size:14px}
    td.right{text-align:right; white-space:nowrap}
    tfoot th, tfoot td{padding:10px 12px; border-top:2px solid var(--border); font-size:14px}
    .big{font-size:20px; font-weight:800; color:var(--midnight)}

    .note{margin-top:8px; color:#475569; font-size:13px}
    .actions{padding:14px 20px; display:flex; gap:8px; align-items:center; border-top:1px dashed var(--border); background:#fff}
    .btn{appearance:none; padding:10px 14px; border-radius:10px; border:1px solid var(--border); background:#fff; cursor:pointer; font-weight:800; text-decoration:none; color:#1f2937}
    .btn.primary{color:#fff; border-color:transparent; background:linear-gradient(135deg, var(--teal), var(--emerald))}
    .muted{color:#64748b}

    @media print{
      body{margin:0; background:#fff}
      .receipt{box-shadow:none; border:none; border-radius:0}
      .actions{display:none !important}
    }
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!-- Safe derived values -->
<c:set var="gross"    value="${bill.grossTotal}"/>
<c:set var="discAmt"  value="${bill.discount}"/>
<c:set var="discountPct" value="${gross > 0 ? (discAmt * 100.0 / gross) : 0}"/>

<div class="receipt">
  <!-- Header -->
  <div class="head">
    <div class="head-inner">
      <div style="display:flex; align-items:center; gap:10px">
        <div class="logo">
          <img src="${ctx}/images/Pahanaedu.png" alt="Logo"
               onerror="this.style.display='none'; this.parentNode.innerHTML='<strong style=&quot;color:#1e293b&quot;>PE</strong>';">
        </div>
        <div class="brand">PahanaEdu — Receipt</div>
      </div>

      <div class="meta">
        <small>Bill No:</small>
        <div class="value">#${bill.billId}</div>
        <small style="margin-top:6px">Date/Time:</small>
        <div class="value">
          <c:choose>
            <c:when test="${not empty bill.createdAtStr}"><c:out value="${bill.createdAtStr}"/></c:when>
            <c:when test="${not empty bill.createdAt}"><fmt:formatDate value="${bill.createdAt}" pattern="yyyy-MM-dd HH:mm"/></c:when>
            <c:when test="${not empty bill.createdDate}"><fmt:formatDate value="${bill.createdDate}" pattern="yyyy-MM-dd HH:mm"/></c:when>
            <c:otherwise>—</c:otherwise>
          </c:choose>
        </div>
        <small style="margin-top:6px">Cashier:</small>
        <div class="value"><c:out value="${sessionScope.user.username}"/></div>
      </div>
    </div>
  </div>

  <!-- Customer & Payment -->
  <div class="section">
    <div class="grid">
      <div class="box">
        <div class="label">Customer</div>
        <div class="value" style="margin-top:4px">
          <c:choose>
            <c:when test="${not empty customer}">
              <c:out value="${customer.name}"/> <span class="muted">(${customer.accountNumber})</span><br/>
              <span class="muted"><c:out value="${customer.phone}"/> · <c:out value="${customer.email}"/></span>
            </c:when>
            <c:otherwise>-</c:otherwise>
          </c:choose>
        </div>
      </div>
      <div class="box">
        <div class="label">Payment Method</div>
        <div class="value" style="margin-top:4px"><c:out value="${bill.paymentMethod}"/></div>
      </div>
    </div>
  </div>

  <!-- Items -->
  <div class="section" style="padding-top:10px">
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
        <c:set var="computedSub"      value="${bi.subTotal}"/>
        <c:set var="computedLineDisc" value="${(bi.unitPrice * bi.qty) - computedSub}"/>
        <tr>
          <td><c:out value="${bi.itemName}"/></td>
          <td class="right">${bi.qty}</td>
          <td class="right">Rs. <fmt:formatNumber value="${bi.unitPrice}" minFractionDigits="2" maxFractionDigits="2"/></td>
          <td class="right">Rs. <fmt:formatNumber value="${computedLineDisc}" minFractionDigits="2" maxFractionDigits="2"/></td>
          <td class="right">Rs. <fmt:formatNumber value="${computedSub}" minFractionDigits="2" maxFractionDigits="2"/></td>
        </tr>
      </c:forEach>
      </tbody>
      <tfoot>
        <tr>
          <th colspan="4" class="right">Gross</th>
          <th class="right">Rs. <fmt:formatNumber value="${gross}" minFractionDigits="2" maxFractionDigits="2"/></th>
        </tr>
        <tr>
          <th colspan="4" class="right">
            Discount (<fmt:formatNumber value="${discountPct}" minFractionDigits="0" maxFractionDigits="2"/>%)
          </th>
          <th class="right">Rs. <fmt:formatNumber value="${discAmt}" minFractionDigits="2" maxFractionDigits="2"/></th>
        </tr>
        <tr>
          <th colspan="4" class="right big">Net Total</th>
          <th class="right big">Rs. <fmt:formatNumber value="${bill.netTotal}" minFractionDigits="2" maxFractionDigits="2"/></th>
        </tr>
      </tfoot>
    </table>

    <div class="note"><strong>Notes:</strong> <c:out value="${bill.notes}"/></div>
  </div>

  <!-- Actions (hidden on print) -->
  <div class="actions">
    <a class="btn" href="${ctx}/billing/new">New Bill</a>
    <a class="btn" href="${ctx}/billing/receipt.pdf?id=${bill.billId}">Open PDF</a>
    <a class="btn" href="${ctx}/billing/receipt.pdf?id=${bill.billId}&dl=download">Download PDF</a>
    <form action="${ctx}/billing/print" method="get" style="display:inline-flex; gap:6px; align-items:center">
      <input type="hidden" name="id" value="${bill.billId}"/>
      <input style="padding:8px 10px; border-radius:8px; border:1px solid var(--border)" name="printer" placeholder="Printer (optional)"/>
      <button class="btn primary" type="submit">Print to POS</button>
    </form>
    <button class="btn" onclick="window.print()">Print (Browser)</button>
    <span class="muted" style="margin-left:auto">If POS print fails on the server, use the PDF options above.</span>
  </div>
</div>
</body>
</html>
