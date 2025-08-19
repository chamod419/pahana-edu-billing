<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Admin Dashboard</title>
  <style>
    body{font-family: Arial, sans-serif; margin:28px;}
    .topbar{display:flex; justify-content:space-between; align-items:center;}
    .grid{display:grid; grid-template-columns: repeat(4, minmax(180px,1fr)); gap:16px; margin-top:16px;}
    .card{border:1px solid #e3e3e3; border-radius:12px; padding:16px;}
    .num{font-size:28px; font-weight:700; margin-top:6px;}
    .links{margin-top:24px;}
    .links a{display:inline-block; margin-right:12px;}
  </style>
</head>
<body>
  <div class="topbar">
    <h2>Admin Dashboard</h2>
    <div>
      <strong>${sessionScope.user.username}</strong> | 
      <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
  </div>

  <div class="grid">
    <div class="card">
      <div>Total Customers</div>
      <div class="num">${totalCustomers}</div>
    </div>
    <div class="card">
      <div>Active Items</div>
      <div class="num">${activeItems}</div>
    </div>
    <div class="card">
      <div>Bills Today</div>
      <div class="num">${todayBills}</div>
    </div>
    <div class="card">
      <div>Revenue Today</div>
      <div class="num">Rs. <c:out value="${todayRevenue}"/></div>
    </div>
  </div>

  <div class="links">
    <a href="${pageContext.request.contextPath}/items">Manage Items</a>
    <a class="btn" href="${pageContext.request.contextPath}/billing/new">Generate Bill</a>
    <a href="${pageContext.request.contextPath}/admin/reports.jsp">Reports</a>
    <a href="${pageContext.request.contextPath}/admin/users">Manage Users</a>

    
    <a href="${pageContext.request.contextPath}/customers">Manage Customers</a>
    
  </div>
</body>
</html>
