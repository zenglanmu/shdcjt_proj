<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
if(perpage<=1 )	perpage=10;

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

String backfields = " id,fromid,frominfoid,fromtype,fromcontent,fromseclevel,toid,toinfoid,totype,tocontent,toseclevel ";
String sqlWhere = " ";
String fromSql  = " from SysDetachReport ";
String orderby = " id " ;
String tableString = "";
    tableString =" <table instanceid=\"sysDetachDetail\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"id\" sqlorderby=\""+orderby+"\"  sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                 "			<head>"+
                 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(431,user.getLanguage())+"\" column=\"fromid\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.hrm.appdetach.AppDetachComInfo.getMemberInfo\" />"+
    			 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19467,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"toid\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.hrm.appdetach.AppDetachComInfo.getScopeSubcompanyInfo\" />"+
                 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19467,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"toid\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.hrm.appdetach.AppDetachComInfo.getScopeDepartmentInfo\" />"+
				 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19467,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(122,user.getLanguage())+"\" column=\"toid\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.hrm.appdetach.AppDetachComInfo.getScopeRoleInfo\" />"+
				 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19467,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(179,user.getLanguage())+"\" column=\"toid\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.hrm.appdetach.AppDetachComInfo.getScopeResourceInfo\" />"+
                 "			</head>"+
                 " </table>";
String sql = "SELECT " + backfields + " " + fromSql + " " + sqlWhere + " ORDER BY " + orderby;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">

    <tr><td height="10" colspan="3"></td></tr>
    <tr>
        <td ></td>
        <td valign="top">
        <TABLE class=Shadow>
            <tr>
                <td valign="top">
                    <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
                    <FORM id=weaver name=frmMain action="AppDetachReport.jsp" method=post>
                    </FORM>
                    <% if(HrmUserVarify.isUserOnline(RecordSet.getString("id"))) {%>
                        <img src="/images/State_LoggedOn.gif">
                    <%}%>
                </td>
            </tr>
        </TABLE>
        </td>
        <td></td>
    </tr>
    <tr><td height="10" colspan="3"></td></tr>
</table>

</BODY>
</HTML>
