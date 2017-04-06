<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<script language=javascript src="/js/weaver.js"></script>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
int language=user.getLanguage();
 //1数据源管理，2注册服务管理
 String showtype=Util.null2String(request.getParameter("showtype"));
%>
<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<br>
<%if(language!=8){%>
<p><strong>操作说明</strong></p>
<ul>
 
  	<%
  		if("1".equals(showtype)){
  	 %>
		  <li>点击左边树中的异构系统，本页会显示该系统下的所有的数据源</li>
		  <li>系统管理员可以对每一种系统下的数据源进行维护</li>
  <%}else{ %>
  	 	 <li>点击左边树中的异构系统，本页会显示该系统下的所有注册的服务</li>
 		 <li>系统管理员可以对每一种系统下的服务进行维护</li>
  	<%} %>
</ul>
<%}else{ %>
<p><strong>Operation Instruction</strong></p>
<ul>

	<%
  		if("1".equals(showtype)){
  	 %>
	  <li>Click on the left tree products, this page will display all of the products under the data source</li>
	  <li>The system administrator can service each data source maintenance</li>
  <%}else{ %>
	 	<li>Click on the left tree products, this page will display all of the products under the registered service</li>
	 	 <li>The system administrator can service each product maintenance</li>
  <%} %>
</ul>
<%}%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</body>
</html>