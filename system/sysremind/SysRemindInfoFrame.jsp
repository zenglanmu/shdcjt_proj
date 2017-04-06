<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/systeminfo/template/templateCss.jsp" %>

<%
    String username = user.getUsername();
%>

<html>
  <head>
  <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>   
    <title><%=SystemEnv.getHtmlLabelName(18121, user.getLanguage())%> - <%=username%></title>
    <link rel="stylesheet" href="/css/Weaver.css" type="text/css">
    <style></style>    
  </head>
  
  <frameset id="sysRemindInfoFrameSet" name="sysRemindInfoFrameSet" ROWS="," COLS="180,*" frameborder="no" border="1">
    <frame SRC="SysRemindInfoTree.jsp" scrolling="NO" id="treeFrame" NAME="treeFrame" target="optFrame" style="cursor:col-resize">
    <frame SRC="SysRemindInfoDefault.jsp" id="optFrame" NAME="mainFrame">
  </frameset>
  <noframes>
    <body>No Frame.
    </body>
  </noframes>  
</html>