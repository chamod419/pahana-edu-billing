<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Items</title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    table{border-collapse: collapse; width:100%;}
    th,td{border:1px solid #e3e3e3; padding:8px; text-align:left;}
    .top{display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;}
    .msg{color:#006400} .err{color:#b00020}
    .btn{padding:6px 10px; border:1px solid #ccc; border-radius:8px; text-decoration:none;}
    img.thumb{max-height:40px;}
    form.inline{display:inline;}
  </style>
</head>
<body>
<div class="top">
  <h2>Items</h2>
  <div>
    <a class="btn" href="${pageContext.request.contextPath}/items/new">+ New Item</a>
    <a class="btn" href="${pageContext.request.contextPath}/dashboard">Back</a>
  </div>
</div>

<c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>
<c:if test="${not empty param.error}"><div class="err">${param.error}</div></c:if>

<table>
  <thead>
  <tr>
    <th>ID</th><th>Name</th><th>Price</th><th>Stock</th><th>Category</th><th>Status</th><th>Image</th><th>Actions</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="it" items="${list}">
    <tr>
      <td>${it.itemId}</td>
      <td><c:out value="${it.name}"/></td>
      <td>Rs. ${it.unitPrice}</td>
      <td>${it.stockQty}</td>
      <td><c:out value="${it.category}"/></td>
      <td><c:out value="${it.active ? 'ACTIVE' : 'INACTIVE'}"/></td>
      <td>
        <c:if test="${not empty it.imageUrl}">
          <img class="thumb" src="${it.imageUrl}" alt="img"/>
        </c:if>
      </td>
      <td>
        <a class="btn" href="${pageContext.request.contextPath}/items/edit?id=${it.itemId}">Edit</a>
        <form class="inline" action="${pageContext.request.contextPath}/items/delete" method="post"
              onsubmit="return confirm('Delete this item? (Admin only)');">
          <input type="hidden" name="id" value="${it.itemId}">
          <button class="btn" type="submit">Delete</button>
        </form>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>

<c:if test="${empty list}">
  <p>No items yet.</p>
</c:if>
</body>
</html>
