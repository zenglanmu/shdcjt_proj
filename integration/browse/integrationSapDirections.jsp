<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<script language=javascript src="/js/weaver.js"></script>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
int language=user.getLanguage();
String w_type=Util.null2String(Util.getIntValue(request.getParameter("w_type"),0)+"");//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息
%>
<body>

<br>

<p><strong><%=SystemEnv.getHtmlLabelName(19010 ,user.getLanguage())%></strong></p>
<ul> 
 
 
 	 <li>&nbsp;&nbsp;1、<%=SystemEnv.getHtmlLabelName(30627 ,user.getLanguage())%>【<%=SystemEnv.getHtmlLabelName(30657 ,user.getLanguage())%>】，<%=SystemEnv.getHtmlLabelName(30629 ,user.getLanguage())%>。</li>
	<%
		if("0".equals(w_type)){
	%>
		<li>&nbsp;&nbsp;2、【<%=SystemEnv.getHtmlLabelName(30630 ,user.getLanguage())%>】<%=SystemEnv.getHtmlLabelName(30631 ,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(30634 ,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(30637 ,user.getLanguage())%>。</li>
	<%	
		}else{
	%>
		
		<li>&nbsp;&nbsp;2、【<%=SystemEnv.getHtmlLabelName(18624 ,user.getLanguage())%>】<%=SystemEnv.getHtmlLabelName(30631 ,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(30633 ,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(30635 ,user.getLanguage())%>。</li>
	<%
		
		}
	 %>
  
  
  
</ul>


</body>
</html>