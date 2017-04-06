<%@ page language="java" contentType="text/html; charset=GBK" %>
<%
//request.getRequestDispatcher("/wui/page/main.jsp").forward(request, response);
response.sendRedirect("/wui/page/main.jsp?templateId=" + request.getParameter("templateId"));
%>