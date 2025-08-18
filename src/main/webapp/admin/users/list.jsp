<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Manage Users</title>
  <style>
    body{font-family:Arial, sans-serif; margin:28px;}
    table{border-collapse:collapse; width:100%;}
    th,td{border:1px solid #e3e3e3; padding:8px; text-align:left;}
    .top{display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;}
    .btn{padding:6px 10px; border:1px solid #ccc; border-radius:8px; text-decoration:none; background:#fff}
    .msg{color:#006400} .err{color:#b00020}
    form.inline{display:inline;}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="top">
  <h2>Users</h2>
  <div>
    <a class="btn" href="${ctx}/admin/users/new">+ New User</a>
    <a class="btn" href="${ctx}/dashboard">Back</a>
  </div>
</div>

<c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>
<c:if test="${not empty param.error}"><div class="err">${param.error}</div></c:if>

<table>
  <thead>
  <tr><th>ID</th><th>Username</th><th>Role</th><th>Actions</th></tr>
  </thead>
  <tbody>
  <c:forEach var="u" items="${list}">
    <tr>
      <td>${u.userId}</td>
      <td><c:out value="${u.username}"/></td>
      <td><c:out value="${u.role}"/></td>
      <td>
        <a class="btn" href="${ctx}/admin/users/edit?id=${u.userId}">Edit</a>
        <form class="inline" action="${ctx}/admin/users/delete" method="post"
              onsubmit="return confirm('Delete this user?');">
          <input type="hidden" name="id" value="${u.userId}"/>
          <button class="btn" type="submit"
                  ${sessionScope.user.userId==u.userId ? 'disabled' : ''}>
            Delete
          </button>
        </form>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>

<c:if test="${empty list}">
  <p>No users yet.</p>
</c:if>
</body>
</html>
