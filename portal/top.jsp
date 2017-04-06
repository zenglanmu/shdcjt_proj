<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<%
// RecordSet.executeProc("Sys_Slogan_Select","");
// RecordSet.next();
String username = user.getUsername() ;
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentyear = (timestamp.toString()).substring(0,4) ;
String currentmonth = ""+Util.getIntValue((timestamp.toString()).substring(5,7)) ;
String currentdate = ""+Util.getIntValue((timestamp.toString()).substring(8,10));
String currenthour = (timestamp.toString()).substring(11,13) ;

int targetid = Util.getIntValue(request.getParameter("targetid"),0) ;
if(targetid==0) targetid=1;
String targetidstr = "" + targetid ;
String bodybgcolor = "";
String searchlink = "" ;
String newslink = "" ;
String orglink = "" ;
String reportlink = "" ;
String maintenancelink = "" ;
String systemlink = "/system/SystemMaintenance.jsp" ;
String targetname = "" ;

switch(targetid) {
	case 1:													// 文档  - 新闻
		bodybgcolor = "#e7e3bd" ;
		searchlink = "/docs/search/DocSearch.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=1" ;
		orglink = "/org/OrgChart.jsp?charttype=D" ;
		reportlink = "/docs/report/DocRp.jsp" ;
		maintenancelink = "/docs/DocMaintenance.jsp" ;
		break ;
	case 2:													// 人力资源 - 新闻
		bodybgcolor = "#FFDFAF" ;
		searchlink = "/hrm/search/HrmResourceSearch.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=2" ;
		orglink = "/org/OrgChart.jsp?charttype=H" ;
		reportlink = "/hrm/report/HrmRp.jsp" ;
		maintenancelink = "/hrm/HrmMaintenance.jsp" ;
		break ;
	case 3:													// 财务 - 组织结构
		bodybgcolor = "#BEE0DE" ;
		searchlink = "" ;
		newslink = "/docs/news/NewsDsp.jsp?id=3" ;
		orglink = "/org/OrgChart.jsp?charttype=F" ;
		reportlink = "/fna/report/FnaReport.jsp" ;
		maintenancelink = "/fna/FnaMaintenance.jsp" ;
		break ;
	case 4:													// 物品 - 搜索页面
		bodybgcolor = "#FFEBAD" ;
		searchlink = "/lgc/search/LgcSearch.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=4" ;
		orglink = "/org/OrgChart.jsp?charttype=I" ;
		reportlink = "/lgc/report/LgcRp.jsp" ;
		maintenancelink = "/lgc/LgcMaintenance.jsp" ;
		break ;
	case 5:													// CRM - 我的客户
		bodybgcolor = "#CEEBFF" ;
		searchlink = "/CRM/search/SearchSimple.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=5" ;
		orglink = "/org/OrgChart.jsp?charttype=C" ;
		reportlink = "/CRM/CRMReport.jsp" ;
		maintenancelink = "/CRM/CRMMaintenance.jsp" ;
		break ;
	case 6:													// 项目 - 我的项目
		bodybgcolor = "#FDDACA" ;
		searchlink = "/proj/search/Search.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=6" ;
		orglink = "/org/OrgChart.jsp?charttype=R" ;
		reportlink = "/proj/ProjReport.jsp" ;
		maintenancelink = "/proj/ProjMaintenance.jsp" ;
		break ;
	case 7:													// 工作流 - 我的工作流
		bodybgcolor = "#EADCC5" ;
		searchlink = "/workflow/search/WFSearch.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=7" ;
		orglink = "" ;
		reportlink = "/workflow/WFReport.jsp" ;
		maintenancelink = "/workflow/WFMaintenance.jsp" ;
		break ;
	case 9:													// 资产-搜索页面
		bodybgcolor = "#FFEBAD" ;
		searchlink = "/Cpt/search/CptSearch.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=4" ;
		orglink = "/org/OrgChart.jsp?charttype=P" ;
		reportlink = "/cpt/report/CptRp.jsp" ;
		maintenancelink = "/cpt/CptMaintenance.jsp" ;
		break ;
}
%>

<html>
<head>
<title>高效源于协同</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<base target="mainFrame">
<link rel="stylesheet" href="/css/frame.css" type="text/css">
</head>

<body>
<table width="100%" border="0" height="100%" cellpadding="0" cellspacing="0" height="75">
<tr>
<td width="180" align="center">
<table width="100%" border="0" cellpadding="0" cellspacing="0" >
  <tr>
    <td valign="middle" height="71" align="center"><img src="/images_frame/portal/logo.gif"></td>
  </tr>
  <tr>
    <td height="4" bgcolor="555553"></td>
  </tr>
</table>

</td>
<td width="76"><img src="/images_frame/portal/portal_top1.gif"></td>
<td>
 <table width="100%" border="0" cellpadding="0" cellspacing="0" >
  <tr>
    <td background="/images_frame/portal/portal_bg1.gif" height="40" align="left" valign="bottom">
	 <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="500" height="40">
			  <param name=movie value="/images_frame/portal/mission.swf">
			  <param name=quality value=high>
			  <embed src="/images_frame/portal/mission.swf" quality=high pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="500" height="40">
			  </embed> 
	</object> 
	</td>
  </tr>
  <tr>
    <td height="4" bgcolor="555553"></td>
  </tr>
  <tr>
    <td height="31" background="/images_frame/portal/bg_2.gif">
      <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
	    <form name="form1" method="post" action="/system/QuickSearchOperation.jsp">
        <tr>
          <td width="5" align="center">|</td>		 
          <td width="50" align="center" nowrap><a class=zlm1 href="/login/Logout.jsp"><font color="#FFFFFF"><%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%></font></a></td>
          <td width="5" align="center">|</td>
		  <td width="10" align="center"></td>
		  <td width="40">
				 <select name="searchtype" >
                <option value=1><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>	
				<%if(!logintype.equals("2")){%>				
                <option value=2><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				<%}%>
				<%if(Customertype.equals("3") || Customertype.equals("4") || !logintype.equals("2") ){%>	
                <option value=3>CRM</option>
				<%}%>
				<%if(!logintype.equals("2")){%>	
                <option value=4><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
				<%}%>
                <option value=5><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></option>

                <option value=6><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>

              </select>
		  </td>
          <td width="100" align="center">
            <input type="text" name="searchvalue" class="submit" size="12">
          </td>
          <td width="20"><img src="/images_frame/portal/search.gif" alt="快速搜索" border="0" onclick="form1.submit()" style="CURSOR:HAND"></td>         
		  <td align="right">
				<img src="/images_face/ecologyFace_1/toolBarIcon/Plugin.gif" onclick="javascript:goUrl('/weaverplugin/PluginMaintenance.jsp')" title="<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage())%>" style="cursor:hand">
		  </td>
          <td width=20>
			&nbsp;
          </td>  
        </tr>
		</form>
      </table>
    </td>
  </tr>
</table>


</td>
</tr>
</table>
<script language="javascript">
function goUrl(url){
	parent.document.getElementById("mainFrame").src = url;
}
</script>
</body>
</html>
