<%@ page import="weaver.general.Util,weaver.hrm.User" %>
<%@ page import="java.net.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;

String username = "" ;
String userid = "" ;

String initsrcpage = "" ;
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;
int targetid = Util.getIntValue(request.getParameter("targetid"),0) ;
//String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String loginfile = Util.getCookie(request , "loginfileweaver") ;
String message = Util.null2String(request.getParameter("message")) ;
String logmessage = Util.null2String(request.getParameter("logmessage")) ;
if(targetid == 0) {
	if(!logintype.equals("2")){
		initsrcpage="/system/HomePage.jsp";
	}else{
		initsrcpage="/docs/news/NewsDsp.jsp";
	}
}

String gopage = Util.null2String(request.getParameter("gopage"));
if(!gopage.equals("")){
	gopage=URLDecoder.decode(gopage);
	initsrcpage = gopage;
}
else if(user != null) {
	username = user.getUsername() ;
	userid = ""+user.getUID() ;
	if(logintype.equals("2")){
		switch(targetid) {
			case 1:													// 文档  - 新闻
				initsrcpage = "/docs/news/NewsDsp.jsp?id=1" ;
				break ;
			case 2:													// 人力资源 - 新闻
				initsrcpage = "/docs/news/NewsDsp.jsp?id=2" ;
				break ;
			case 3:													// 财务 - 组织结构
				initsrcpage = "/org/OrgChart.jsp?charttype=F" ;
				break ;
			case 4:													// 物品 - 搜索页面
				initsrcpage = "/lgc/catalog/LgcCatalogsView.jsp" ;
				break ;
			case 5:													// CRM - 我的客户
				initsrcpage = "/CRM/data/ViewCustomer.jsp?CustomerID="+userid ;
				break ;
			case 6:													// 项目 - 我的项目
				initsrcpage = "/proj/search/SearchOperation.jsp" ;
				break ;
			case 7:													// 工作流 - 我的工作流
				initsrcpage = "/workflow/request/RequestView.jsp" ;
				break ;
			case 8:													// 工作流 - 我的工作流
				initsrcpage = "/system/SystemMaintenance.jsp" ;
				break ;
			case 9:													// 工作流 - 我的工作流
				initsrcpage = "/cpt/CptMaintenance.jsp" ;
				break ;
	
		}
	}else{
		switch(targetid) {
			case 1:													// 文档  - 新闻
				initsrcpage = "/docs/report/DocRp.jsp" ;
				break ;
			case 2:													// 人力资源 - 新闻
				initsrcpage = "/hrm/report/HrmRp.jsp" ;
				break ;
			case 3:													// 财务 - 组织结构
				initsrcpage = "/fna/report/FnaReport.jsp" ;
				break ;
			case 4:													// 物品 - 搜索页面
				initsrcpage = "/lgc/report/LgcRp.jsp" ;
				break ;
			case 5:													// CRM - 我的客户
				initsrcpage = "/CRM/CRMReport.jsp" ;
				break ;
			case 6:													// 项目 - 我的项目
				initsrcpage = "/proj/ProjReport.jsp" ;
				break ;
			case 7:													// 工作流 - 我的工作流
				initsrcpage = "/workflow/WFReport.jsp" ;
				break ;
			case 8:													// 工作流 - 我的工作流
				initsrcpage = "/system/SystemMaintenance.jsp" ;
				break ;
			case 9:													// 工作流 - 我的工作流
				initsrcpage = "/cpt/report/CptRp.jsp" ;
				break ;
	
		}
	}

	
}
else {
	response.sendRedirect(loginfile+"&message="+message) ;
	return ;
}
boolean NoCheck=false;
RecordSet.executeSql("select NoCheckPlugin from SysActivexCheck where NoCheckPlugin='1' and logintype='2' and userid="+user.getUID());
if(RecordSet.next()) NoCheck=true;
if(!NoCheck){
%>
<script language="javascript" src="/js/activex/ActiveX.js"></script>
<script>
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
checkWeaverActiveX(<%=user.getLanguage()%>);
</script>
<%
}
if(!logmessage.equals("")){
%>
<script language=javascript>
	alert("您已经登陆系统!\n登陆信息:"+"<%=logmessage%>");	
</script>
<%}%>
<html>
<head>
<title>高效源于协同 - <%=username%></title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>

<frameset rows="75,*" cols="*" frameborder="NO" border="0" framespacing="0" id=Main> 
  <frame name="topFrame" scrolling="NO" noresize src="top.jsp?targetid=<%=targetid%>" target="Main">
  <frameset cols="162,8,*,8" frameborder="NO" border="0" framespacing="0" id=MainBottom> 
    <frame name="leftFrame" scrolling="yes" src="left.jsp" target="mainFrame">
	<frame name="mainleftFrame" noresize scrolling="NO" src="mainleft.jsp">
	<frameset rows="42,*,8" frameborder="NO" border="0" framespacing="0">
       <frame name="maintopFrame" noresize scrolling="NO" src="maintop.jsp">		       
	   <frame name="mainFrame" scrolling="yes" src="<%=initsrcpage%>">   
	    <frame name="mainbottomFrame" noresize scrolling="NO" src="mainbottom.jsp">
	</frameset>
	<frame name="mainrightFrame" noresize scrolling="NO" src="mainright.jsp">
  </frameset>
</frameset>
<noframes><body bgcolor="#FFFFFF" text="#000000">

</body></noframes>
</html>
