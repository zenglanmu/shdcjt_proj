<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
String paraid = Util.null2String(request.getParameter("paraid")) ;
String optFrameSrc="";
if(!paraid.equals(""))
    optFrameSrc = "CptAssortmentView.jsp?paraid="+paraid;
else
    optFrameSrc = "CptAssortmentInfo.jsp";
%>
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=GBK">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
</head>
<FRAMESET id="cptAssortmentFrameSet" name="cptAssortmentFrameSet" ROWS="," COLS="220,*" frameborder="no" border="1">
	<FRAME SRC="CptAssortmentTreeFra.jsp?paraid=<%=paraid%>" scrolling="NO" id="treeFrame" NAME="treeFrame" target="optFrame" style="cursor:col-resize">
	<FRAME SRC="<%=optFrameSrc%>" id="optFrame" NAME="optFrame">
</FRAMESET>
</HTML>