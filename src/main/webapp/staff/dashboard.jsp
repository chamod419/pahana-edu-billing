<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Staff Dashboard</title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    .grid{display:grid; grid-template-columns: repeat(2, minmax(180px,1fr)); gap:16px; margin-top:16px;}
    .card{border:1px solid #e3e3e3; border-radius:12px; padding:16px;}
    .num{font-size:28px; font-weight:700; margin-top:6px;}
  </style>
</head>
<body>
  <h2>Staff Dashboard</h2>
  <p>Welcome, <strong>${sessionScope.user.username}</strong></p>
  <div class="grid">
    <div class="card">
      <div>Your Bills Today</div>
      <div class="num">${todayBills}</div>
    </div>
    <div class="card">
      <div>Your Revenue Today</div>
      <div class="num">Rs. <c:out value="${todayRevenue}"/></div>
    </div>
  </div>

  <p style="margin-top:20px;">
    <a href="${pageContext.request.contextPath}/staff/billing.jsp">Generate Bill</a> |
    <a href="${pageContext.request.contextPath}/customers">Customers</a>
    <a href="${pageContext.request.contextPath}/items">Manage Items</a>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
    
    
  </p>
</body>
</html>
