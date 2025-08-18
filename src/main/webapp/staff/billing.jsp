<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Generate Bill</title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    .row{display:flex; gap:12px; align-items:center;}
    .card{border:1px solid #e3e3e3; border-radius:12px; padding:16px; margin-top:12px;}
    table{border-collapse: collapse; width:100%;}
    th,td{border:1px solid #eee; padding:8px; text-align:left;}
    th.right, td.right{text-align:right}
    .right{text-align:right}
    .btn{padding:8px 12px; border:1px solid #ccc; border-radius:8px; background:#fff; cursor:pointer;}
    .msg{color:#006400} .err{color:#b00020}
    input,select{padding:8px}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>
<c:if test="${not empty param.error}"><div class="err">${param.error}</div></c:if>

<h2>Generate Bill</h2>

<!-- Add item -->
<div class="card">
  <form class="row" action="${ctx}/billing/add" method="post">
    <label>Item</label>
    <select name="itemId" required>
      <c:forEach var="it" items="${activeItems}">
        <option value="${it.itemId}">
          ${it.name} (Rs. ${it.unitPrice} | Stock: ${it.stockQty})
        </option>
      </c:forEach>
    </select>
    <label>Qty</label>
    <input type="number" min="1" name="qty" value="1" style="width:80px"/>
    <button class="btn" type="submit">Add</button>
    <a class="btn" href="${ctx}/dashboard">Back</a>
  </form>
</div>

<!-- Lines -->
<div class="card">
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
        <td class="right">${li.qty}</td>
        <td class="right">Rs. ${li.lineTotal}</td>
        <td>
          <form action="${ctx}/billing/remove" method="post" onsubmit="return confirm('Remove line?');">
            <input type="hidden" name="billItemId" value="${li.billItemId}">
            <button class="btn" type="submit">Remove</button>
          </form>
        </td>
      </tr>
    </c:forEach>

    <c:if test="${empty bill.items}">
      <tr><td colspan="6">No items yet.</td></tr>
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

<!-- Finalize + Cancel (separate forms; no nesting) -->
<div class="card" style="max-width:560px">
  <form action="${ctx}/billing/finalize" method="post">
    <div class="row" style="justify-content:space-between; align-items:flex-start">
      <div>
        <div>Sub Total: <strong>Rs. ${bill.subTotal}</strong></div>

        <div style="margin-top:8px">
          <label>Discount (Rs.)</label><br/>
          <input type="number" step="0.01" min="0" name="discountAmt"
                 value="${bill.discountAmt}" style="width:140px"/>
        </div>

        <div style="margin-top:8px">
          <label>Payment</label><br/>
          <select name="paymentMethod">
            <option ${bill.paymentMethod=='CASH'?'selected':''}>CASH</option>
            <option ${bill.paymentMethod=='CARD'?'selected':''}>CARD</option>
            <option ${bill.paymentMethod=='ONLINE'?'selected':''}>ONLINE</option>
          </select>
        </div>
      </div>

      <div class="right">
        <div>Net Total: <strong>Rs. ${bill.netTotal}</strong></div>
        <div style="margin-top:12px">
          <button class="btn" type="submit" ${empty bill.items ? 'disabled' : ''}>Finalize</button>
        </div>
      </div>
    </div>
  </form>

  <form action="${ctx}/billing/cancel" method="post" style="margin-top:10px"
        onsubmit="return confirm('Cancel this bill?');">
    <button class="btn" type="submit">Cancel</button>
  </form>
</div>

</body>
</html>
