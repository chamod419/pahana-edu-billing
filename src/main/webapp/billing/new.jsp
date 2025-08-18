<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Generate Bill</title>
  <style>
    body{font-family: Arial, sans-serif; margin:24px; background:#fafafa;}
    .topbar{display:flex; justify-content:space-between; align-items:center;}
    .wrap{display:grid; grid-template-columns: 1.2fr 2fr 1fr; gap:16px; margin-top:16px;}
    .card{background:#fff; border:1px solid #e8e8e8; border-radius:12px; padding:16px; box-shadow:0 1px 2px rgba(0,0,0,.03);}
    .title{font-weight:700; margin-bottom:8px;}
    input, select, textarea { width:100%; padding:10px; border:1px solid #ddd; border-radius:8px; }
    table{width:100%; border-collapse:collapse;}
    th,td{border-bottom:1px solid #f1f1f1; padding:8px; text-align:left; vertical-align:top;}
    th{background:#fcfcfc;}
    .right{text-align:right;}
    .actions{display:flex; gap:8px; align-items:center;}
    .btn{display:inline-block; padding:8px 12px; border:1px solid #ccc; border-radius:8px; background:#fff; text-decoration:none; cursor:pointer;}
    .btn.primary{background:#0d6efd; border-color:#0d6efd; color:#fff;}
    .btn.danger{background:#b00020; border-color:#b00020; color:white;}
    .muted{color:#777; font-size:12px;}
    .pill{font-size:12px; background:#f0f0f5; border-radius:999px; padding:3px 8px; display:inline-block;}
    .msg{color:#006400;margin-bottom:8px;}
    .err{color:#b00020;margin-bottom:8px;}
    .totalbox{font-size:14px;}
    .totalbox .row{display:flex; justify-content:space-between; margin:6px 0;}
    .totalbox .big{font-size:22px; font-weight:800;}
    .scroll{max-height:360px; overflow:auto;}
    .label{margin-top:6px; margin-bottom:4px; display:block; font-size:12px; color:#555;}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="cart" value="${cart}"/>

<div class="topbar">
  <h2>Generate Bill</h2>
  <div>
    <a class="btn" href="${ctx}/dashboard">Back</a>
  </div>
</div>

<c:if test="${not empty param.error}"><div class="err">${param.error}</div></c:if>
<c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>

<div class="wrap">

  <!-- LEFT: Customer + Totals -->
  <div class="card">
    <div class="title">Customer</div>
    <form action="${ctx}/billing/save" method="post">
      <label class="label">Select customer *</label>
      <select name="customerId" required>
        <option value="">— Select —</option>
        <c:forEach var="cst" items="${customers}">
          <option value="${cst.customerId}" ${cart.customerId==cst.customerId ? 'selected' : ''}>
            ${cst.accountNumber} — ${cst.name}
          </option>
        </c:forEach>
      </select>

      <label class="label">Notes</label>
      <textarea name="notes" rows="3">${cart.notes}</textarea>

      <label class="label"><input type="checkbox" name="decreaseStock" checked/> Decrease stock on save</label>

      <div class="title" style="margin-top:16px;">Totals</div>
      <div class="totalbox">
        <div class="row"><span>Gross</span><span>Rs. ${cart.grossTotal}</span></div>
        <div class="row"><span>Discount (<strong>${cart.discountPct}%</strong>)</span><span>Rs. ${cart.discount}</span></div>
        <div class="row big"><span>Net Total</span><span>Rs. ${cart.netTotal}</span></div>
      </div>

      <div style="margin-top:12px">
        <button class="btn primary" type="submit">Save &amp; Print</button>
      </div>
    </form>
  </div>

  <!-- CENTER: Bill Items + Discount % setter -->
  <div class="card">
    <div class="title">Bill Items</div>

    <!-- Discount as PERCENT -->
    <form action="${ctx}/billing/discount" method="post" style="margin-bottom:8px">
      <div class="actions">
        <span class="muted">Discount %:</span>
        <input style="width:160px" name="discountPct" type="number" step="0.01" min="0" max="100" value="${cart.discountPct}"/>
        <button class="btn" type="submit">Apply</button>
      </div>
      <div class="muted">Discount amount is auto-calculated from gross.</div>
    </form>

    <div class="scroll">
      <table>
        <thead>
          <tr>
            <th>Item</th>
            <th class="right">Qty</th>
            <th class="right">Unit</th>
            <th class="right">Line Disc.</th>
            <th class="right">Subtotal</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="bi" items="${cart.items}">
          <tr>
            <td>
              <div><strong><c:out value="${bi.itemName}"/></strong></div>
              <div class="muted">#${bi.itemId}</div>
            </td>
            <td class="right">
              <form action="${ctx}/billing/update" method="post">
                <input type="hidden" name="itemId" value="${bi.itemId}"/>
                <input name="qty" type="number" min="1" value="${bi.qty}" style="width:80px; text-align:right"/>
                <button class="btn" type="submit">Set</button>
              </form>
            </td>
            <td class="right">Rs. ${bi.unitPrice}</td>
            <td class="right">Rs. ${bi.lineDiscount}</td>
            <td class="right"><strong>Rs. ${bi.subTotal}</strong></td>
            <td class="right">
              <form action="${ctx}/billing/remove" method="post" onsubmit="return confirm('Remove item?');">
                <input type="hidden" name="itemId" value="${bi.itemId}"/>
                <button class="btn danger" type="submit">Remove</button>
              </form>
            </td>
          </tr>
        </c:forEach>

        <c:if test="${empty cart.items}">
          <tr><td colspan="6" class="muted">No items added yet.</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>

  <!-- RIGHT: Search & Add -->
  <div class="card">
    <div class="title">Add Item</div>
    <form action="${ctx}/billing/new" method="get">
      <input name="q" placeholder="Search items by name..." value="${q}"/>
      <div style="margin-top:8px"><button class="btn" type="submit">Search</button></div>
    </form>

    <c:if test="${not empty search}">
      <div class="muted" style="margin-top:8px">${fn:length(search)} results</div>
      <div class="scroll" style="max-height:260px">
        <table>
          <thead>
            <tr><th>Name</th><th class="right">Price</th><th></th></tr>
          </thead>
          <tbody>
          <c:forEach var="it" items="${search}">
            <tr>
              <td><c:out value="${it.name}"/><br/><span class="pill">${it.category}</span></td>
              <td class="right">Rs. ${it.unitPrice}</td>
              <td class="right">
                <form action="${ctx}/billing/add" method="post" style="white-space:nowrap">
                  <input type="hidden" name="itemId" value="${it.itemId}"/>
                  <input type="number" name="qty" value="1" min="1" style="width:64px; text-align:right"/>
                  <button class="btn primary" type="submit">Add</button>
                </form>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </c:if>

    <c:if test="${empty search and not empty q}">
      <div class="muted" style="margin-top:8px">No results for "<strong>${q}</strong>"</div>
    </c:if>
  </div>

</div>
</body>
</html>
