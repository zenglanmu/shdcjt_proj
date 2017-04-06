<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>

<%
String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String logintype = Util.null2String(request.getParameter("logintype")) ;
String loginid = Util.null2String(request.getParameter("loginid")) ;
String userpassword = Util.null2String(request.getParameter("userpassword"));
String gopage=Util.null2String(request.getParameter("gopage"));

URLDecoder URLDecoder = new URLDecoder();
response.sendRedirect("VerifyLogin.jsp?loginfile"+URLDecoder.decode(loginfile)+"&logintype="+logintype+"&loginid="+loginid+"&userpassword="+userpassword+"&gopage="+URLDecoder.decode(gopage));
%>