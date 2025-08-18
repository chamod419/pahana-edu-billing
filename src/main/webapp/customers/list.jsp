<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Customers</title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    table{border-collapse: collapse; width:100%;}
    th,td{border:1px solid #e3e3e3; padding:8px; text-align:left;}
    .top{display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;}
    .msg{color:#006400} .err{color:#b00020}
    .btn{padding:6px 10px; border:1px solid #ccc; border-radius:8px; text-decoration:none;}
    form.inline{display:inline;}
  </style>
</head>
<body>
<div class="top">
  <h2>Customers</h2>
  <div>
    <a class="btn" href="${pageContext.request.contextPath}/customers/new">+ New Customer</a>
    <a class="btn" href="${pageContext.request.contextPath}/dashboard">Back</a>
  </div>
</div>

<c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>
<c:if test="${not empty param.error}"><div class="err">${param.error}</div></c:if>

<table>
  <thead>
    <tr>
      <th>ID</th><th>Account #</th><th>Name</th><th>Phone</th><th>Email</th><th>Status</th><th>Actions</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach var="cst" items="${list}">
    <tr>
      <td>${cst.customerId}</td>
      <td><c:out value="${cst.accountNumber}"/></td>
      <td><c:out value="${cst.name}"/></td>
      <td><c:out value="${cst.phone}"/></td>
      <td><c:out value="${cst.email}"/></td>
      <td><c:out value="${cst.status}"/></td>
      <td>
        <a class="btn" href="${pageContext.request.contextPath}/customers/edit?id=${cst.customerId}">Edit</a>
        <!-- Delete via POST; visible to everyone, but server enforces ADMIN -->
        <form class="inline" action="${pageContext.request.contextPath}/customers/delete" method="post"
              onsubmit="return confirm('Delete this customer?');">
          <input type="hidden" name="id" value="${cst.customerId}">
          <button class="btn" type="submit">Delete</button>
        </form>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>

<c:if test="${empty list}">
  <p>No customers yet.</p>
</c:if>

</body>
</html>
