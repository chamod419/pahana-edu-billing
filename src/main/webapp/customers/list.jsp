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
    th,td{border:1px solid #e3e3e3; padding:8px; text-align:left; vertical-align:top;}
    .top{display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;}
    .msg{color:#006400} .err{color:#b00020}
    .btn{padding:6px 10px; border:1px solid #ccc; border-radius:8px; text-decoration:none; background:#fff;}
    form.inline{display:inline;}
    .pill{font-size:12px; border-radius:999px; padding:2px 8px; display:inline-block;}
    .pill.green{background:#e9f7ef; color:#0b6b2c; border:1px solid #cfe9d8;}
    .pill.gray{background:#f1f1f1; color:#555; border:1px solid #e1e1e1;}
    .search{display:flex; gap:8px; align-items:center;}
    .search input{padding:8px; border:1px solid #ccc; border-radius:8px;}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="top">
  <h2>Customers</h2>
  <div class="search">
    <form action="${ctx}/customers" method="get">
      <input name="q" placeholder="Search name / phone / email / account #" value="${q}"/>
      <button class="btn" type="submit">Search</button>
      <a class="btn" href="${ctx}/customers">Clear</a>
    </form>
    <a class="btn" href="${ctx}/customers/new">+ New Customer</a>
    <a class="btn" href="${ctx}/dashboard">Back</a>
  </div>
</div>

<c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>
<c:if test="${not empty param.error}"><div class="err">${param.error}</div></c:if>

<table>
  <thead>
    <tr>
      <th>ID</th>
      <th>Account #</th>
      <th>Name</th>
      <th>Phone</th>
      <th>Email</th>
      <th>Address</th>  <!-- NEW -->
      <th>Status</th>
      <th>Actions</th>
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
      <td><c:out value="${cst.address}"/></td>
      <td>
        <c:choose>
          <c:when test="${cst.status=='ACTIVE'}"><span class="pill green">ACTIVE</span></c:when>
          <c:otherwise><span class="pill gray">INACTIVE</span></c:otherwise>
        </c:choose>
      </td>
      <td>
        <a class="btn" href="${ctx}/customers/edit?id=${cst.customerId}">Edit</a>
        <form class="inline" action="${ctx}/customers/delete" method="post"
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
  <p>No customers found.</p>
</c:if>

</body>
</html>
