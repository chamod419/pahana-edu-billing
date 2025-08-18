<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title><c:out value="${mode=='edit' ? 'Edit User' : 'New User'}"/></title>
  <style>
    body{font-family:Arial, sans-serif; margin:28px;}
    .card{max-width:520px; border:1px solid #e3e3e3; border-radius:12px; padding:16px;}
    label{display:block; margin-top:10px;}
    input,select{width:100%; padding:10px; margin-top:4px;}
    .btn{padding:8px 12px; border:1px solid #ccc; border-radius:8px; background:#fff; text-decoration:none;}
    .actions{margin-top:16px;}
    .err{color:#b00020}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<h2><c:out value="${mode=='edit' ? 'Edit User' : 'New User'}"/></h2>
<c:if test="${not empty error}"><div class="err">${error}</div></c:if>

<div class="card">
  <form action="${ctx}/admin/users/save" method="post">
    <input type="hidden" name="userId" value="${u.userId}"/>

    <label>Username *</label>
    <input name="username" required value="${u.username}"/>

    <label>Role *</label>
    <select name="role" required>
      <option value="ADMIN" ${u.role=='ADMIN' ? 'selected':''}>ADMIN</option>
      <option value="STAFF" ${u.role=='STAFF' ? 'selected':''}>STAFF</option>
    </select>

    <c:choose>
      <c:when test="${mode=='create'}">
        <label>Password *</label>
        <input type="password" name="password" required/>
        <label>Confirm Password *</label>
        <input type="password" name="confirm" required/>
      </c:when>
      <c:otherwise>
        <label>New Password (optional)</label>
        <input type="password" name="password"/>
        <label>Confirm New Password</label>
        <input type="password" name="confirm"/>
      </c:otherwise>
    </c:choose>

    <div class="actions">
      <button class="btn" type="submit">Save</button>
      <a class="btn" href="${ctx}/admin/users">Cancel</a>
    </div>
  </form>
</div>
</body>
</html>
