<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = "期刊";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/web/webmagazine/WebMagazineTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		 <!--列表部分-->
		  <%
				//得到pageNum 与 perpage
				int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
				int perpage =10;
				//设置好搜索条件
				String backFields ="id , name , remark ";
				String fromSql = " WebMagazineType ";                              
				String orderBy="id";
				
				String tableString=""+
					   "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
					   "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\"  sqldistinct=\"true\" />"+
					   "<head>"+                                           
							 "<col width=\"30%\"  text=\"刊名\" target=\"_self\" column=\"name\" orderkey=\"name\" linkvaluecolumn=\"id\"  href =\"WebMagazineList.jsp\" linkkey=\"typeID\"/>"+
							 "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"remark\" orderkey=\"remark\"/>"+                                           
					   "</head>"+
					   "<operates width=\"20%\">"+
					   "	<operate href=\"/tom_magazine.jsp\" linkkey=\"typeID\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" />"+
					   "	<operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" />"+
					   "</operates>"+
					   "</table>";                                             
			  %>
				<TABLE  width="100%">		
					<TR>
						<TD valign="top">                
							<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="false" isShowBottomInfo="true"/> 
						</TD>  
					</TR>      
				</TABLE>    		 
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--	
	function doDel(typeid){
		if(isdel()){
			window.location='/web/webmagazine/WebMagazineOperation.jsp?method=typedel&typeid='+typeid;
		}
	}
//-->
</SCRIPT>