<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(586,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    if(HrmUserVarify.checkUserRight("AddProjectType:add", user)){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/proj/Maint/AddProjectType.jsp,_self} " ;
        RCMenuHeight += RCMenuHeightStep;
    }

    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
    RCMenuHeight += RCMenuHeightStep;

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
            String canEdit="false";
            String canDel="false";
            if(HrmUserVarify.checkUserRight("EditProjectType:Edit", user)){
                canEdit="true";
            }
            if(HrmUserVarify.checkUserRight("EditProjectType:Delete", user)){
                canDel="true";
            }
            String popedomOtherpara=canEdit+"_"+canDel;

            String tableString=""+
                       "<table  pagesize=\"10\" tabletype=\"none\">"+
                       "<sql backfields=\"type.id,fullname,description,wfid,protypecode,workflowname\" sqlform=\"Prj_ProjectType type LEFT JOIN Workflow_base base ON (type.wfid = base.id)\" sqlprimarykey=\"type.id\" sqlsortway=\"Desc\" sqldistinct=\"true\" />"+
                       "<head>"+                             
                             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15795,user.getLanguage())+"\" column=\"fullname\" href=\"EditProjectType.jsp\" target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"id\" orderkey=\"fullname\"/>"+
                             "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"description\" orderkey=\"description\"/>"+
                             "<col width=\"23%\"  text=\""+SystemEnv.getHtmlLabelName(15057,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\"/>"+
                             "<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(64,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForProj.getTemletCount\"/>"+                             
                       "</head>"+
                       "<operates width=\"12%\">"+
                        "   <popedom transmethod=\"weaver.splitepage.operate.SpopForProj.getProjPope\"  otherpara=\""+popedomOtherpara+"\"></popedom>"+
                       "    <operate href=\"javascript:doEdit()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"0\"/>"+
                       "    <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+
                       "</operates>"+
                       "</table>"; 
            
            %>
            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="false"/> 
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
function doEdit(projTypeId){
    window.location='EditProjectType.jsp?id='+projTypeId;
}
function doDel(projTypeId){
    window.location='ProjectTypeOperation.jsp?method=delete&id='+projTypeId;
}
//-->
</SCRIPT>