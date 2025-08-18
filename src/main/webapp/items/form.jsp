<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    .err{color:#b00020}
  </style>
</head>
<body>
<h2><c:out value="${mode=='edit' ? 'Edit Item' : 'New Item'}"/></h2>

<c:if test="${not empty error}"><div class="err">${error}</div></c:if>

<div class="card">
  <form action="${pageContext.request.contextPath}/items/save" method="post">
    <input type="hidden" name="itemId" value="${i.itemId}"/>

    <label>Name *</label>
    <input name="name" required value="${i.name}"/>

    <div class="row">
      <div>
        <label>Unit Price *</label>
        <input type="number" step="0.01" min="0" name="unitPrice" required value="${i.unitPrice}"/>
      </div>
      <div>
        <label>Stock Qty *</label>
        <input type="number" min="0" name="stockQty" required value="${i.stockQty}"/>
      </div>
    </div>

    <div class="row">
      <div>
        <label>Category</label>
        <input name="category" value="${i.category}"/>
      </div>
      <div>
        <label>Status</label>
        <select name="status">
          <option value="ACTIVE"  ${i.active ? 'selected' : ''}>ACTIVE</option>
          <option value="INACTIVE" ${!i.active ? 'selected' : ''}>INACTIVE</option>
        </select>
      </div>
    </div>

    <label>Description</label>
    <textarea name="description" rows="3">${i.description}</textarea>

    <label>Image URL (optional)</label>
    <input name="imageUrl" value="${i.imageUrl}"/>

    <div class="actions">
      <button class="btn" type="submit">Save</button>
      <a class="btn" href="${pageContext.request.contextPath}/items">Cancel</a>
    </div>
  </form>
</div>
</body>
</html>
