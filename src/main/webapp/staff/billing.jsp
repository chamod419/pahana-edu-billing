<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Billing</title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    .row{display:grid; grid-template-columns: 1fr 1fr; gap:16px; align-items:end;}
    .card{border:1px solid #e3e3e3; border-radius:12px; padding:16px;}
    table{border-collapse: collapse; width:100%;}
    th,td{border:1px solid #e3e3e3; padding:8px; text-align:left;}
    .right{text-align:right;}
    .btn{padding:6px 10px; border:1px solid #ccc; border-radius:8px; text-decoration:none;}
    .msg{color:#006400} .err{color:#b00020}
    input,select,textarea{padding:8px; width:100%;}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<h2>Billing</h2>

<c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>
<c:if test="${not empty param.error}"><div class="err">${param.error}</div></c:if>

<div class="row">
  <!-- Add item -->
  <div class="card">
    <h3>Add Item</h3>
    <form action="${ctx}/billing/add" method="post">
      <label>Item</label>
      <select name="itemId" required>
        <c:forEach var="it" items="${items}">
          <option value="${it.itemId}">
            ${it.name} (Rs. ${it.unitPrice} | Stock ${it.stockQty})
          </option>
        </c:forEach>
      </select>

      <label style="margin-top:8px;">Quantity</label>
      <input type="number" name="qty" min="1" value="1" required />

      <div style="margin-top:10px;">
        <button class="btn" type="submit">Add</button>
      </div>
    </form>
  </div>

  <!-- Checkout details -->
  <div class="card">
    <h3>Checkout</h3>
    <form action="${ctx}/billing/checkout" method="post">
      <label>Customer</label>
      <select name="customerId" required>
        <option value="">-- Select --</option>
        <c:forEach var="cst" items="${customers}">
          <option value="${cst.customerId}">${cst.name} - ${cst.accountNumber}</option>
        </c:forEach>
      </select>

      <label style="margin-top:8px;">Discount (Rs)</label>
      <input type="number" name="discount" min="0" step="0.01" value="0"/>

      <label style="margin-top:8px;">Notes</label>
      <textarea name="notes" rows="2"></textarea>

      <div style="margin-top:10px;">
        <button class="btn" type="submit">Save Bill</button>
        <a class="btn" href="${ctx}/billing/clear">Clear</a>
        <a class="btn" href="${ctx}/dashboard">Back</a>
      </div>
    </form>
  </div>
</div>

<!-- Cart -->
<div class="card" style="margin-top:16px;">
  <h3>Cart</h3>
  <table>
    <thead>
      <tr>
        <th>Item</th>
        <th class="right">Unit Price</th>
        <th class="right">Qty</th>
        <th class="right">Sub Total</th>
        <th>Action</th>
      </tr>
    </thead>
    <tbody>
    <c:forEach var="li" items="${cart}">
      <tr>
        <td>${li.itemName}</td>
        <td class="right">Rs. ${li.unitPrice}</td>
        <td class="right">
          <form action="${ctx}/billing/update" method="post" style="display:inline">
            <input type="hidden" name="itemId" value="${li.itemId}"/>
            <input type="number" min="0" name="qty" value="${li.qty}" style="width:80px;"/>
            <button class="btn" type="submit">Update</button>
          </form>
        </td>
        <td class="right">Rs. ${li.subTotal}</td>
        <td>
          <a class="btn" href="${ctx}/billing/remove?itemId=${li.itemId}">Remove</a>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty cart}">
      <tr><td colspan="5">Cart is empty.</td></tr>
    </c:if>
    </tbody>
    <tfoot>
      <tr>
        <th colspan="3" class="right">Gross Total</th>
        <th class="right">Rs. ${gross}</th>
        <th></th>
      </tr>
    </tfoot>
  </table>
</div>

</body>
</html>
