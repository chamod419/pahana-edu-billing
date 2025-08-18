<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title><c:out value="${mode=='edit' ? 'Edit Item' : 'New Item'}"/></title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    .card{max-width:680px; border:1px solid #e3e3e3; border-radius:12px; padding:16px;}
    label{display:block; margin-top:10px;}
    input,select,textarea{width:100%; padding:10px; margin-top:4px;}
    .row{display:grid; grid-template-columns:1fr 1fr; gap:12px;}
    .actions{margin-top:16px;}
    .btn{padding:8px 12px; border:1px solid #ccc; border-radius:8px; text-decoration:none;}
    .note{color:#555; font-size:12px}
    img.preview{max-height:140px; border:1px solid #eee; border-radius:8px; margin-top:8px;}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="categoriesCSV" value="Stationery,Accessories,Books,Printing,Services"/>
<c:set var="cats" value="${fn:split(categoriesCSV, ',')}"/>

<h2><c:out value="${mode=='edit' ? 'Edit Item' : 'New Item'}"/></h2>
<c:if test="${not empty error}"><div style="color:#b00020">${error}</div></c:if>

<div class="card">
  <form action="${ctx}/items/save" method="post" enctype="multipart/form-data">
    <input type="hidden" name="itemId" value="${i.itemId}"/>
    <input type="hidden" name="existingImage" value="${i.imageUrl}"/>

    <label>Name *</label>
    <input name="name" required value="${i.name}"/>

    <div class="row">
      <div>
        <label>Unit Price *</label>
        <input type="number" step="0.01" min="0" name="unitPrice" required value="${i.unitPrice}"/>
      </div>
      <div>
        <label>Stock Qty *</label>
        <input id="stockQty" type="number" min="0" name="stockQty" required value="${i.stockQty}"
               oninput="updateStatus()"/>
      </div>
    </div>

    <div class="row">
      <div>
        <label>Category *</label>
        <select name="category" required>
          <c:forEach var="cat" items="${cats}">
            <option value="${fn:trim(cat)}" ${i.category==fn:trim(cat) ? 'selected' : ''}>${fn:trim(cat)}</option>
          </c:forEach>
        </select>
      </div>
      <div>
        <label>Auto Status</label>
        <div id="autoStatus" style="padding:10px;border:1px solid #eee;border-radius:8px;">
          <c:out value="${(i.stockQty gt 0) ? 'ACTIVE' : 'INACTIVE'}"/>
        </div>
        <div class="note">Status auto-calculated by stock: qty&gt;0 → ACTIVE, qty=0 → INACTIVE.</div>
      </div>
    </div>

    <label>Description</label>
    <textarea name="description" rows="3">${i.description}</textarea>

    <label>Image File (JPG/PNG/GIF, ≤5MB)</label>
    <input type="file" name="imageFile" accept="image/*"/>

    <c:if test="${not empty i.imageUrl}">
      <p style="margin-top:12px">Current image:</p>
      <img class="preview" src="${ctx}/uploads/${i.imageUrl}" alt="current"/>
    </c:if>

    <div class="actions">
      <button class="btn" type="submit">Save</button>
      <a class="btn" href="${ctx}/items">Cancel</a>
    </div>
  </form>
</div>

<script>
function updateStatus(){
  var v = parseInt(document.getElementById('stockQty').value || '0', 10);
  document.getElementById('autoStatus').textContent = (v > 0) ? 'ACTIVE' : 'INACTIVE';
}
</script>
</body>
</html>
