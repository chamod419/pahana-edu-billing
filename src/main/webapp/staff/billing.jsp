<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Generate Bill</title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    .row{display:flex; gap:12px; align-items:center; flex-wrap:wrap;}
    .grid{display:grid; grid-template-columns: 1fr; gap:16px;}
    .card{border:1px solid #e3e3e3; border-radius:12px; padding:16px;}
    table{border-collapse: collapse; width:100%;}
    th,td{border:1px solid #eee; padding:8px; text-align:left; vertical-align:middle;}
    th.right, td.right{text-align:right}
    .btn{padding:8px 12px; border:1px solid #ccc; border-radius:8px; background:#fff; cursor:pointer; text-decoration:none;}
    .msg{color:#006400} .err{color:#b00020}
    input,select,textarea{padding:8px}
    .pill{display:inline-block; padding:2px 8px; border-radius:999px; background:#f2f2f2; margin-left:8px;}
    .muted{color:#666; font-size:12px;}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>
<c:if test="${not empty param.error}"><div class="err">${param.error}</div></c:if>

<h2>Generate Bill</h2>

<div class="grid">

  <!-- Customer attach / detach -->
  <div class="card">
    <h3 style="margin-top:0">Customer</h3>
    <c:choose>
      <c:when test="${not empty customer}">
        <div>
          <strong>${customer.name}</strong>
          <span class="pill">${customer.accountNumber}</span>
          <div class="muted">
            <c:out value="${customer.phone}"/> • <c:out value="${customer.email}"/> <br/>
            <c:out value="${customer.address}"/>
          </div>
        </div>
        <form action="${ctx}/billing/setCustomer" method="post" style="margin-top:10px">
          <input type="hidden" name="clear" value="1"/>
          <button class="btn" type="submit">Clear Customer</button>
        </form>
      </c:when>
      <c:otherwise>
        <form class="row" action="${ctx}/billing/setCustomer" method="post">
          <label>Account #</label>
          <input name="accountNumber" placeholder="C-0001" required/>
          <button class="btn" type="submit">Attach</button>
          <a class="btn" href="${ctx}/customers/new" target="_blank">+ New Customer</a>
        </form>
        <div class="muted" style="margin-top:6px">Tip: use account number to attach customer to this bill.</div>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- Add item -->
  <div class="card">
    <h3 style="margin-top:0">Add Item</h3>
    <form class="row" action="${ctx}/billing/add" method="post">
      <input id="itemFilter" placeholder="Type to filter items…" style="min-width:260px"/>
      <select id="itemSelect" name="itemId" required style="min-width:360px">
        <c:forEach var="it" items="${activeItems}">
          <option value="${it.itemId}">
            ${it.name} — Rs. ${it.unitPrice} (Stock: ${it.stockQty}) [${it.category}]
          </option>
        </c:forEach>
      </select>
      <label>Qty</label>
      <input type="number" min="1" name="qty" value="1" style="width:100px"/>
      <button class="btn" type="submit">Add</button>
      <a class="btn" href="${ctx}/items/new" target="_blank">+ New Item</a>
    </form>
  </div>

  <!-- Lines -->
  <div class="card">
    <h3 style="margin-top:0">Items</h3>
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
            <form action="${ctx}/billing/updateQty" method="post" class="row" style="justify-content:flex-end">
              <input type="hidden" name="billItemId" value="${li.billItemId}"/>
              <input type="number" min="1" name="qty" value="${li.qty}" style="width:90px"/>
              <button class="btn" type="submit">Update</button>
            </form>
          </td>
          <td class="right">Rs. ${li.lineTotal}</td>
          <td>
            <form action="${ctx}/billing/remove" method="post" onsubmit="return confirm('Remove this line?');">
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

  <!-- Notes + Totals / Finalize -->
  <div class="card">
    <div class="row" style="justify-content:space-between; align-items:flex-start; gap:24px">
      <form action="${ctx}/billing/setNotes" method="post" style="flex:1">
        <h3 style="margin-top:0">Notes</h3>
        <textarea name="notes" rows="3" style="width:100%" placeholder="Add notes for the receipt…">${bill.notes}</textarea>
        <div class="muted">Shown on the PDF receipt.</div>
        <div style="margin-top:8px">
          <button class="btn" type="submit">Save Notes</button>
        </div>
      </form>

      <form action="${ctx}/billing/finalize" method="post" style="flex:1">
        <h3 style="margin-top:0">Payment</h3>
        <div style="margin:6px 0">
          Sub Total: <strong>Rs. ${bill.subTotal}</strong>
        </div>
        <div style="margin:6px 0">
          <label>Discount (Rs.)</label><br/>
          <input type="number" step="0.01" min="0" name="discountAmt" value="${bill.discountAmt}" style="width:160px"/>
        </div>
        <div style="margin:6px 0">
          <label>Payment Method</label><br/>
          <select name="paymentMethod">
            <option ${bill.paymentMethod=='CASH'?'selected':''}>CASH</option>
            <option ${bill.paymentMethod=='CARD'?'selected':''}>CARD</option>
            <option ${bill.paymentMethod=='ONLINE'?'selected':''}>ONLINE</option>
          </select>
        </div>
        <div style="margin:10px 0">
          Net Total: <strong>Rs. ${bill.netTotal}</strong>
        </div>
        <button class="btn" type="submit" ${empty bill.items ? 'disabled' : ''}>Finalize</button>
        <a class="btn" href="${ctx}/billing/new" style="margin-left:6px">New Bill</a>
        <form action="${ctx}/billing/cancel" method="post" style="display:inline" onsubmit="return confirm('Cancel this bill?');">
          <button class="btn" type="submit">Cancel</button>
        </form>
      </form>
    </div>
  </div>

</div>

<script>
// simple client-side filter for the item dropdown
const filter = document.getElementById('itemFilter');
const select = document.getElementById('itemSelect');
if (filter && select) {
  const all = Array.from(select.options).map(o => ({value:o.value, text:o.text}));
  filter.addEventListener('input', () => {
    const q = filter.value.toLowerCase();
    select.innerHTML = '';
    all
      .filter(o => o.text.toLowerCase().includes(q))
      .forEach(o => {
        const opt = document.createElement('option');
        opt.value = o.value; opt.text = o.text;
        select.appendChild(opt);
      });
  });
}
</script>

</body>
</html>
