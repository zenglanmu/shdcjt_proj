<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%	
	if(!HrmUserVarify.checkUserRight("newstype:maint", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19859,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("newstype:maint", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/docs/news/type/newstypeAdd.jsp',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+100+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
			<%
				//得到pageNum 与 perpage
				int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
				
				//设置好搜索条件				
				
				String tableString=""+
					   "<table  pagesize=\"20\" tabletype=\"none\">"+
					   "<sql backfields=\"*\" sqlform=\"newstype\" sqlorderby=\"dspnum\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   "<head>"+							 
							 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"typename\"  orderkey=\"typename\" href=\"newstypeAdd.jsp?type=edit\"  linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_self\"/>"+
							 "<col width=\"60%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"typedesc\" orderkey=\"typedesc\"/>"+
							 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dspnum\" orderkey=\"dspnum\"/>"+						
					   "</head>"+
					   "</table>";                                             
			  %>
				<TABLE  width="100%">		
					<TR>
						<TD valign="top">                
							<wea:SplitPageTag  tableString="<%=tableString%>" isShowTopInfo="false"  mode="run"/> 
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
