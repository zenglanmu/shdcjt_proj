<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String departmentid = Util.null2String(request.getParameter("departmentid"));
String subcompanyid= Util.null2String(request.getParameter("subcompanyid"));
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(6086,user.getLanguage());
String needfav ="1";
String needhelp ="";

String businessKind = Util.null2String(request.getParameter("businessKind"));
String business = Util.null2String(request.getParameter("business"));
String stationShort = Util.null2String(request.getParameter("stationShort"));
String stationAll = Util.null2String(request.getParameter("stationAll"));

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:document.frmSearch.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
if(!departmentid.equals("")){    
    int deplevel=0;
    if(detachable==1){
       deplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmJobTitlesAdd:Add",Util.getIntValue(DepartmentComInfo.getSubcompanyid1(departmentid)));
    }else{
      if(HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user))
        deplevel=2;
    }
	if(deplevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/jobtitles/HrmJobTitlesAdd.jsp?departmentid="+departmentid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
    }
}
if(HrmUserVarify.checkUserRight("HrmJobTitles:Log", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+26+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%

   String sqlwhere =" where a.id =b.jobgroupid" +
				   " and b.id = c.jobactivityid "  ;
   String searchSql = "" ;


  if (!"".equals(businessKind)) {
  	searchSql = searchSql + " and a.id = "+businessKind ;
  }
  if (!"".equals(business)) {
  	searchSql = searchSql + " and b.id = "+business ;
  }
  if (!"".equals(stationShort)) {
  	searchSql = searchSql + " and c.jobtitlemark like '%"+stationShort+"%'" ;
  }
  if (!"".equals(stationAll)) {
     searchSql = searchSql + " and c.jobtitlename like '%"+stationAll+"%'" ;
  }
  if (!"".equals(departmentid)) {
     searchSql = searchSql + " and c.jobdepartmentid ="+departmentid ;
  }
  
  if (detachable == 1 && "".equals(subcompanyid) && "".equals(departmentid)){
		if(request.getParameter("subCompanyId")==null){
				subcompanyid=String.valueOf(session.getAttribute("role_subCompanyId"));
		}else{
        subcompanyid=Util.null2String(request.getParameter("subCompanyId"));
    }
    if ("".equals(subcompanyid)){
			subcompanyid = "-1";
		}    
	}
	
  if (!"".equals(subcompanyid)) {
     searchSql = searchSql + " and c.jobdepartmentid =d.id and d.subcompanyid1="+subcompanyid ;
  }
  if (!"".equals(searchSql)) {
  	 sqlwhere = sqlwhere + searchSql ;
  }


  	int needchange = 0;
  	String tempBusinessKindId = "";
  	String tempBusinessId = "" ;
int perpage=Util.getIntValue(request.getParameter("perpage"),0);

if(perpage<=1 )	perpage=10;
String backfields = "a.id as groupid,b.id as activityid ,c.id as id, a.jobgroupname,b.jobactivityname,c.jobtitlemark,c.jobtitlename";
String fromSql  = " from HrmJobGroups a,HrmJobActivities b,HrmJobTitles c ";
if (!"".equals(subcompanyid))
fromSql  = " from HrmJobGroups a,HrmJobActivities b,HrmJobTitles c,hrmdepartment d ";
String orderby = " groupid,activityid " ;
String tableString =" <table instanceid=\"hrmJobTitlesTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                 "	   <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\" sqlprimarykey=\"c.id\"   sqlsortway=\"Asc\" />"+
                 "			<head>"+
                 "				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(399,user.getLanguage())+"\" column=\"jobtitlemark\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"/hrm/jobtitles/HrmJobTitlesEdit.jsp\"  target=\"_fullwindow\"/>"+
                 "				<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(15767,user.getLanguage())+"\" column=\"jobtitlename\"  />"+
                 "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(805,user.getLanguage())+"\" column=\"jobgroupname\" linkvaluecolumn=\"groupid\"  linkkey=\"id\" href=\"/hrm/jobgroups/HrmJobGroupsEdit.jsp\" target=\"_fullwindow\"/>"+
                 "				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(1915,user.getLanguage())+"\" column=\"jobactivityname\"  linkvaluecolumn=\"activityid\"  linkkey=\"id\" href=\"/hrm/jobactivities/HrmJobActivitiesEdit.jsp\" target=\"_fullwindow\"/>"+               
                 "			</head>"+
                 " </table>";
  %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<!--add by dongping for fiveStar request-->

<form name="frmSearch" method="post" action="">
	<table class="ViewForm">
	  <COLGROUP>
	  <COL width="15%">
	  <COL width="30%">
	  <COL width="10%">
	   <COL width="15%">
	  <COL width="30%">
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%>
			</td>
			<td class="Field">

				<input class="wuiBrowser" type="hidden" name="businessKind" class="inputStyle" value="<%=businessKind%>"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp"
				_displayText="<%=JobGroupsComInfo.getJobGroupsname(businessKind)%>">
			</td>
			<td></td>
			<td>
				<%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>
			</td>
			<td class="Field">				

				<input type="hidden" name="business" class="wuiBrowser" value="<%=business%>"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp"
				_displayTemplate="<a target='_blank' href='/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id=#b{id}'>#b{name}</a>"
				_displayText="<%=JobActivitiesComInfo.getJobActivitiesname(business)%>">
                <input type="hidden" name="departmentid" class="inputStyle" value=<%=departmentid%>>
            </td>
		</tr>
		<TR style="height:1px"><TD class=Line colSpan=5></TD></TR> 
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(399,user.getLanguage())%>
			</td>
			<td class="Field">
				<input type="text" name="stationShort" class="inputStyle" value=<%=stationShort%>>
			</td>
			<td></td>
			<td>
				<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(15767,user.getLanguage())%>
			</td>
			<td class="Field">
				<input type="text" name="stationAll" class="inputStyle" value=<%=stationAll%>>
			</td>	
		</tr>
        <TR style="height:1px"><TD class=Line colSpan=5></TD></TR>   
        <tr><td colSpan=5> <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" /></td></tr>
    </table>
</form>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=vbScript>
 sub onShowJobGroup()
        id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp")
        if Not isempty(id) then 
                if id(0)<> 0 then
                        businessKindSpan.innerHtml = id(1)
                        frmSearch.businessKind.value=id(0)
                else
                        businessKindSpan.innerHtml = ""
                        frmSearch.businessKind.value=""
                end if
        end if
end sub
sub onShowJobActivity()
        id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp")
        if Not isempty(id) then 
                if id(0)<> 0 then
                        businessSpan.innerHtml = "<a href='/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id="&id(0)&"'>"&id(1)&"</a>"
                        frmSearch.business.value=id(0)
                else
                        businessSpan.innerHtml = ""
                        frmSearch.business.value=""
                end if
        end if
end sub
</script> 
 
</BODY></HTML>