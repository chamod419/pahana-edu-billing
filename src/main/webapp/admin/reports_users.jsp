<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Reports · Users</title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    .top{display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap;}
    table{width:100%; border-collapse:collapse; margin-top:12px;}
    th,td{border:1px solid #eee; padding:8px; text-align:left;}
    th.right, td.right{text-align:right}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="top">
  <h2>Per-User Sales</h2>
  <form method="get" action="${ctx}/admin/reports/users" style="display:flex; gap:8px; align-items:end;">
    <div><label>From</label><br/><input type="date" name="from" value="${from}" required/></div>
    <div><label>To</label><br/><input type="date" name="to" value="${to}" required/></div>
    <div><button type="submit">Apply</button>
        <a href="${ctx}/admin/reports" style="margin-left:6px">Back</a></div>
  </form>
</div>

<table>
  <thead>
    <tr>
      <th>User</th>
      <th class="right">Bills</th>
      <th class="right">Items</th>
      <th class="right">Gross</th>
      <th class="right">Discount</th>
      <th class="right">Net</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
  <c:forEach var="r" items="${rows}">
    <tr>
      <td><c:out value="${r.username}"/></td>
      <td class="right">${r.bills}</td>
      <td class="right">${r.itemsSold}</td>
      <td class="right">Rs. <fmt:formatNumber value="${r.gross}" minFractionDigits="2" maxFractionDigits="2"/></td>
      <td class="right">Rs. <fmt:formatNumber value="${r.discount}" minFractionDigits="2" maxFractionDigits="2"/></td>
      <td class="right">Rs. <fmt:formatNumber value="${r.net}" minFractionDigits="2" maxFractionDigits="2"/></td>
      <td><a href="${ctx}/admin/reports/users/detail?userId=${r.userId}&from=${from}&to=${to}">View bills</a></td>
    </tr>
  </c:forEach>
  <c:if test="${empty rows}">
    <tr><td colspan="7">No data for this period.</td></tr>
  </c:if>
  </tbody>
</table>

</body>
</html>
