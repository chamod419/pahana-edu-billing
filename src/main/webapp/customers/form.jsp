<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title><c:out value="${mode=='edit' ? 'Edit Customer' : 'New Customer'}"/></title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    .card{max-width:560px; border:1px solid #e3e3e3; border-radius:12px; padding:16px;}
    label{display:block; margin-top:10px;}
    input,select,textarea{width:100%; padding:10px; margin-top:4px;}
    .row{display:grid; grid-template-columns:1fr 1fr; gap:12px;}
    .actions{margin-top:16px;}
    .btn{padding:8px 12px; border:1px solid #ccc; border-radius:8px; text-decoration:none;}
    .err{color:#b00020}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<h2><c:out value="${mode=='edit' ? 'Edit Customer' : 'New Customer'}"/></h2>

<c:if test="${not empty error}"><div class="err">${error}</div></c:if>

<div class="card">
  <form action="${ctx}/customers/save" method="post">
    <input type="hidden" name="customerId" value="${c.customerId}"/>

    <label>Account Number (optional)</label>
    <input name="accountNumber" value="${c.accountNumber}" placeholder="Leave blank to auto-generate (e.g., C-0007)"/>

    <label>Name *</label>
    <input name="name" required value="${c.name}"/>

    <div class="row">
      <div>
        <label>Phone</label>
        <input name="phone" value="${c.phone}"/>
      </div>
      <div>
        <label>Email</label>
        <input name="email" value="${c.email}"/>
      </div>
    </div>

    <label>Address</label>
    <textarea name="address" rows="3">${c.address}</textarea>

    <label>Status</label>
    <select name="status">
      <option value="ACTIVE"  ${c.status=='ACTIVE' || empty c.status ? 'selected' : ''}>ACTIVE</option>
      <option value="INACTIVE"${c.status=='INACTIVE' ? 'selected' : ''}>INACTIVE</option>
    </select>

    <div class="actions">
      <button class="btn" type="submit">Save</button>
      <a class="btn" href="${ctx}/customers">Cancel</a>
    </div>
  </form>
</div>
</body>
</html>
