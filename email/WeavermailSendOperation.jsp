<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.MailUserData" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="WeavermailSend" class="weaver.email.WeavermailSend" scope="page" />



<%
    boolean sendok = WeavermailSend.sendMail( request, user ) ;
    if(sendok) response.sendRedirect("WeavermailIndex.jsp?message=1");
    else response.sendRedirect("WeavermailIndex.jsp?message=2");

%>

