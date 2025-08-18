<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Login - PahanaEdu</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css"/>
  <style>
    body{font-family: Arial, sans-serif; margin:40px;}
    .card{max-width:380px; margin:auto; padding:24px; border:1px solid #ddd; border-radius:12px;}
    .error{color:#b00020; margin:8px 0;}
    .msg{color:#006400; margin:8px 0;}
    label{display:block; margin:8px 0 4px;}
    input{width:100%; padding:10px; margin-bottom:12px;}
    button{padding:10px 16px;}
  </style>
</head>
<body>
<div class="card">
  <h2>Login</h2>

  <c:if test="${not empty param.msg}"><div class="msg">${param.msg}</div></c:if>
  <c:if test="${not empty param.error}"><div class="error">${param.error}</div></c:if>
  <c:if test="${not empty error}"><div class="error">${error}</div></c:if>

  <form action="${pageContext.request.contextPath}/login" method="post">
    <input type="hidden" name="next" value="${param.next}"/>

    <label for="username">Username</label>
    <input id="username" name="username" required />

    <label for="password">Password</label>
    <input id="password" type="password" name="password" required />

    <button type="submit">Sign in</button>
  </form>
</div>
</body>
</html>
