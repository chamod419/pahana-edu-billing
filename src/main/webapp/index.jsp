<%@ page session="false" %>
<%
  response.sendRedirect(request.getContextPath() + "/login");
  return;
%>