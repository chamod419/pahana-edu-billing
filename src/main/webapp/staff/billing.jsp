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
    .btn.primary{background:#0b5; color:#fff; border-color:#0b5;}
    .btn.ghost{background:transparent;}
    .msg{color:#006400} .err{color:#b00020}
    input,select,textarea{padding:8px}
    .pill{display:inline-block; padding:2px 8px; border-radius:999px; background:#f2f2f2; margin-left:8px;}
    .muted{color:#666; font-size:12px;}
    .section-title{margin:0 0 8px 0; font-weight:bold;}
    .field{margin:6px 0}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>
<c:if test="${not empty param.error}"><div class="err">${param.error}</div></c:if>

<h2>Generate Bill</h2>

<div class="grid">

  <!-- Customer (unchanged) -->
  <div class="card">
    <h3 class="section-title">Customer</h3>
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

        <form class="row" action="${ctx}/billing" method="get" style="margin-top:10px">
          <input name="q" value="${searchQ}" placeholder="Search by name, phone, account…" style="min-width:280px"/>
          <button class="btn" type="submit">Search</button>
        </form>

        <c:if test="${not empty matches}">
          <div class="muted" style="margin-top:6px">
            Results for "<c:out value="${searchQ}"/>"
          </div>
          <table style="margin-top:8px">
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
                    <button class="btn" type="submit">Attach</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </c:if>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- Add item (unchanged) -->
  <div class="card">
    <h3 class="section-title">Add Item</h3>
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
    </form>
  </div>

  <!-- Items (unchanged) -->
  <div class="card">
    <h3 class="section-title">Items</h3>
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

  <!-- Notes + Payment (UPDATED) -->
  <div class="card">
    <div class="row" style="justify-content:space-between; align-items:flex-start; gap:24px">

      <!-- Notes (unchanged) -->
      <form action="${ctx}/billing/setNotes" method="post" style="flex:1; min-width:320px">
        <h3 class="section-title">Notes</h3>
        <textarea name="notes" rows="3" style="width:100%" placeholder="Add notes for the receipt…">${bill.notes}</textarea>
        <div class="muted">Shown on the PDF receipt.</div>
        <div class="field">
          <button class="btn" type="submit">Save Notes</button>
        </div>
      </form>

      <!-- Payment (improved) -->
      <form action="${ctx}/billing/finalize" method="post" style="flex:1; min-width:360px">
        <h3 class="section-title">Payment</h3>

        <div class="field">
          <div>Sub Total:
            <strong id="subtotalVal" data-val="${bill.subTotal}">Rs. ${bill.subTotal}</strong>
          </div>
        </div>

        <c:set var="prefPct" value="${bill.subTotal gt 0 ? (bill.discountAmt * 100.0 / bill.subTotal) : 0}"/>

        <div class="field">
          <label style="display:block; margin-bottom:4px">Discount</label>
          <label><input type="radio" name="discountMode" value="AMT" checked> Amount (Rs.)</label>
          <label style="margin-left:12px"><input type="radio" name="discountMode" value="PCT"> Percentage (%)</label>

          <div class="row" style="margin-top:6px">
            <input id="discAmt" name="discountAmt" type="number" step="0.01" min="0"
                   value="${bill.discountAmt}" placeholder="0.00" style="width:140px"/>
            <input id="discPct" name="discountPct" type="number" step="0.01" min="0" max="100"
                   value="${prefPct}" placeholder="0.0" style="width:120px; display:none"/>
          </div>
          <div class="muted">Tip: choose one mode. We’ll prevent discount exceeding subtotal.</div>
        </div>

        <div class="field">
          <label>Payment Method</label><br/>
          <select name="paymentMethod">
            <option ${bill.paymentMethod=='CASH'?'selected':''}>CASH</option>
            <option ${bill.paymentMethod=='CARD'?'selected':''}>CARD</option>
            <option ${bill.paymentMethod=='ONLINE'?'selected':''}>ONLINE</option>
          </select>
        </div>

        <div class="field">
          <div>Estimated Net Total: <strong id="netEst">Rs. ${bill.netTotal}</strong></div>
        </div>

        <div class="row" style="margin-top:6px">
          <button class="btn primary" type="submit" ${empty bill.items ? 'disabled' : ''}>Finalize</button>
          <a class="btn ghost" href="${ctx}/billing/new">New Bill</a>
          <a class="btn ghost" href="${ctx}/dashboard">Back to Dashboard</a>
          <label class="muted" style="margin-left:6px">
            <input type="checkbox" name="goDashboard" value="1"/> Go to Dashboard after finalize
          </label>
          <form action="${ctx}/billing/cancel" method="post" style="display:inline" onsubmit="return confirm('Cancel this bill?');">
            <button class="btn" type="submit">Cancel</button>
          </form>
        </div>
      </form>
    </div>
  </div>

</div>

<script>
// item filter (unchanged)
const filter = document.getElementById('itemFilter');
const select = document.getElementById('itemSelect');
if (filter && select) {
  const all = Array.from(select.options).map(o => ({value:o.value, text:o.text}));
  filter.addEventListener('input', () => {
    const q = filter.value.toLowerCase();
    select.innerHTML = '';
    all.filter(o => o.text.toLowerCase().includes(q)).forEach(o => {
      const opt = document.createElement('option');
      opt.value = o.value; opt.text = o.text;
      select.appendChild(opt);
    });
  });
}

// payment UX
const subtotal = parseFloat(document.getElementById('subtotalVal').dataset.val || '0') || 0;
const netEst = document.getElementById('netEst');
const discAmt = document.getElementById('discAmt');
const discPct = document.getElementById('discPct');
const radios = document.querySelectorAll('input[name="discountMode"]');

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
radios.forEach(r => r.addEventListener('change', setMode));
discAmt.addEventListener('input', recalcNet);
discPct.addEventListener('input', recalcNet);

function fmt(v){ return 'Rs. ' + (Number(v).toFixed(2)); }
function recalcNet(){
  const mode = Array.from(radios).find(r => r.checked)?.value || 'AMT';
  let discount = 0;
  if (mode === 'PCT') {
    const p = Math.max(0, Math.min(100, parseFloat(discPct.value || '0')));
    discount = subtotal * (p/100.0);
  } else {
    discount = Math.max(0, parseFloat(discAmt.value || '0'));
  }
  if (discount > subtotal) discount = subtotal;
  const net = subtotal - discount;
  netEst.textContent = fmt(net);
}
setMode();
</script>

</body>
</html>
