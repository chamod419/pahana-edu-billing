<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Items</title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    table{border-collapse: collapse; width:100%;}
    th,td{border:1px solid #e3e3e3; padding:8px; text-align:left; vertical-align: top;}
    .top{display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;}
    .msg{color:#006400} .err{color:#b00020}
    .btn{padding:6px 10px; border:1px solid #ccc; border-radius:8px; text-decoration:none;}
    img.thumb{max-height:40px;}
    form.inline{display:inline;}
    .desc{max-width:360px; white-space:pre-wrap;}
    .badge{display:inline-block; padding:2px 8px; border-radius:999px; border:1px solid #ddd; font-size:12px;}
    .badge.on{background:#e6ffed; border-color:#b7f0c3;}
    .badge.off{background:#fff1f0; border-color:#ffc7c2;}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="role" value="${sessionScope.user.role}"/>

<div class="top">
  <h2>Items</h2>
  <div>
    <a class="btn" href="${ctx}/items/new">+ New Item</a>
    <a class="btn" href="${ctx}/dashboard">Back</a>
  </div>
</div>

<c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>
<c:if test="${not empty param.error}"><div class="err">${param.error}</div></c:if>

<table>
  <thead>
  <tr>
    <th>ID</th>
    <th>Name</th>
    <th>Price</th>
    <th>Stock</th>
    <th>Category</th>
    <th>Status</th>
    <th>Image</th>
    <th>Description</th>
    <th>Actions</th>
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
      <td>
        <span class="badge ${it.active ? 'on' : 'off'}">
          <c:out value="${it.active ? 'ACTIVE' : 'INACTIVE'}"/>
        </span>
      </td>
      <td>
        <c:if test="${not empty it.imageUrl}">
          <img class="thumb" src="${ctx}/uploads/${it.imageUrl}" alt="img"/>
        </c:if>
      </td>
      <td class="desc" title="${it.description}">
        <c:choose>
          <c:when test="${not empty it.description and fn:length(it.description) > 120}">
            <c:out value="${fn:substring(it.description,0,120)}"/>…
          </c:when>
          <c:otherwise>
            <c:out value="${it.description}"/>
          </c:otherwise>
        </c:choose>
      </td>
      <td>
        <a class="btn" href="${ctx}/items/edit?id=${it.itemId}">Edit</a>
        <!-- 🔐 Delete button visible only to STAFF or ADMIN -->
        <c:if test="${role == 'ADMIN' || role == 'STAFF'}">
          <form class="inline" action="${ctx}/items/delete" method="post"
                onsubmit="return confirm('Delete this item? If it is used in bills, deletion will be blocked.');">
            <input type="hidden" name="id" value="${it.itemId}">
            <button class="btn" type="submit">Delete</button>
          </form>
        </c:if>
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
