<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="StridePageManagerUtil" class="weaver.general.StridePageManagerUtil" scope="session" />
<jsp:useBean id="MeetingSearchComInfo" class="weaver.meeting.search.SearchComInfo" scope="session" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<%@ page import="java.sql.Timestamp" %>
<%	
    if(!HrmUserVarify.checkUserRight("meetingmonitor:Edit", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(17625, user.getLanguage());
	String needfav ="1";
	String needhelp ="";

    String mstatus1=Util.null2String(request.getParameter("mstatus1"));
    String mstatus2=Util.null2String(request.getParameter("mstatus2"));
    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
       
    //构建where语句
    String SqlWhere = MeetingSearchComInfo.FormatSQLSearch1(user.getLanguage())  ;  
    
    if(mstatus1.equals("5")&&!mstatus2.equals("2")){
      SqlWhere +=" and ( enddate<'"+CurrentDate+"' or (endDate = '"+CurrentDate+"' AND endTime < '"+CurrentTime+"') or isdecision=2) ";
    }
    if(mstatus2.equals("2")&&!mstatus1.equals("5")){
      SqlWhere +=" and ( enddate>'"+CurrentDate+"' or (endDate = '"+CurrentDate+"' AND endTime >= '"+CurrentTime+"')) and isdecision<>2 ";
    }
    
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<% 

    RCMenu += "{"+SystemEnv.getHtmlLabelName(364, user.getLanguage())+",javascript:onSearch(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:OnMultiSubmit(this)',_top} " ;
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

				<TABLE width="100%">
                    <tr>
                      <td valign="top">
                          <%

                          	int  perpage=50;
                            String backfields = "id,name,address,customizeaddress,caller,contacter,meetingstatus,begindate,begintime,enddate,endtime,isdecision";
                            String fromSql  = " from  meeting  ";
                            if(SqlWhere.length()>1){
                                int indx=SqlWhere.indexOf("where");
                                if(indx>-1)
                                    SqlWhere=SqlWhere.substring(indx+5);
                            }
                            String sqlWhere = SqlWhere;

                            String orderby = " enddate,endtime ,id " ;
                            String tableString = "";
                          	tableString =" <table instanceid=\"meetingTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                                                 //" <checkboxpopedom    popedompara=\"column:fromUser\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getCanCheckBox\" />"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
                                                 "			<head>"+
                                                 "				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(2151,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" transmethod=\"weaver.splitepage.transform.SptmForMeeting.getMeetingName\" otherpara=\"column:id+column:status\" />"+
                                                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(2105,user.getLanguage())+"\" column=\"address\" orderkey=\"address\" otherpara=\"column:customizeaddress\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingAddress\" />"+
                                                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(2152,user.getLanguage())+"\" column=\"caller\" orderkey=\"caller\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
                                               	 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(572,user.getLanguage())+"\" column=\"contacter\" orderkey=\"contacter\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
                                               	 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"meetingstatus\" otherpara=\""+user.getLanguage()+"+column:endDate+column:endTime+column:isdecision\" orderkey=\"meetingstatus\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingStatus\" />"+
                                  				 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"begindate\"  orderkey=\"begindate,begintime\" otherpara=\"column:begintime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
                                                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"enddate\"  orderkey=\"enddate,endtime\" otherpara=\"column:endtime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
                                                  "			</head>"+
                                                 "</table>";
                         %>
                         <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
                      </td>
                    </tr>
                  </TABLE>
		<form id="frmmain" name="frmmain" method="post" action="MeetMonitorOperation.jsp">
		<input id="operation" name="operation" type="hidden">
		<input id="meetingids" name="meetingids" type="hidden">
		</form>
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
function onSearch(obj) {
    obj.disabled = true ;
    window.location = '/meeting/search/Search.jsp?from=monitor';
}
function OnMultiSubmit(obj){
	 if(_xtable_CheckedCheckboxId()==""){
     	alert("您没指定要删除的会议！");
     }
     else  if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")) {
		        document.frmmain.operation.value='delMeeting';
		        document.frmmain.meetingids.value=_xtable_CheckedCheckboxId();
		        document.frmmain.submit();
                obj.disabled=true;
             }
}
</SCRIPT>