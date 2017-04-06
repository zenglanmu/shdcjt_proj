<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.workflow.request.RequestInfo,weaver.crm.Maint.CustomerInfoComInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />  
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<%!  
/**
 * Charoes Huang ,June 4,2004
 */
//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
private String getCustomerLinkStr(CustomerInfoComInfo comInfo,String crmids){
	String returnStr ="";
	ArrayList a_crmids = Util.TokenizerString(crmids,",");
	for(int i=0;i<a_crmids.size();i++){  
		String id = (String)a_crmids.get(i);
		returnStr += "<a href=\"/CRM/data/ViewCustomer.jsp?CrmID="+id+"\">"+comInfo.getCustomerInfoname(id)+"</a> ";
	}
	return returnStr ;
}
%>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

char flag=Util.getSeparator() ;
String ProcPara = "";

String meetingid = Util.null2String(request.getParameter("meetingid"));


RecordSet.executeProc("Meeting_SelectByID",meetingid);
RecordSet.next();
String meetingtype=RecordSet.getString("meetingtype");
String meetingname=RecordSet.getString("name");
String caller=RecordSet.getString("caller");
String contacter=RecordSet.getString("contacter");
String address=RecordSet.getString("address");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");
String desc=RecordSet.getString("desc_n");
String creater=RecordSet.getString("creater");
String createdate=RecordSet.getString("createdate");
String createtime=RecordSet.getString("createtime");
String approver=RecordSet.getString("approver");
String approvedate=RecordSet.getString("approvedate");
String approvetime=RecordSet.getString("approvetime");
String isapproved=RecordSet.getString("isapproved");
String projectid=RecordSet.getString("projectid");//获得项目id
String totalmember=RecordSet.getString("totalmember");
String othermembers=RecordSet.getString("othermembers");
String addressdesc=RecordSet.getString("addressdesc");
String meetingstatus=RecordSet.getString("meetingstatus");
int requestid = RecordSet.getInt("requestid");
//获取提醒相关信息
String remindType = RecordSet.getString("remindType");
String remindBeforeStart = RecordSet.getString("remindBeforeStart");
String remindBeforeEnd = RecordSet.getString("remindBeforeEnd");
String remindTimesBeforeStart = RecordSet.getString("remindTimesBeforeStart");
String remindTimesBeforeEnd = RecordSet.getString("remindTimesBeforeEnd");
String accessorys = RecordSet.getString("accessorys");
	
int temmhourb=Util.getIntValue(remindTimesBeforeStart,0)/60;
int temptimeb=Util.getIntValue(remindTimesBeforeStart,0)%60;
int temmhoure=Util.getIntValue(remindTimesBeforeEnd,0)/60;
int temptimee=Util.getIntValue(remindTimesBeforeEnd,0)%60;
String customizeAddress = Util.null2String(RecordSet.getString("customizeAddress"));

RequestInfo rqInfo = null;
if(requestid!=0){
	rqInfo = new RequestInfo(requestid,user);
	//System.out.println("requestInfo.getWorkflowid() = "+requestInfo.getWorkflowid());
}else{
	rqInfo = new RequestInfo();
}


if(meetingstatus.equals("2")){
	response.sendRedirect("/meeting/data/ProcessMeeting.jsp?meetingid="+meetingid) ;
	return;
}

//标识会议已看
StringBuffer stringBuffer = new StringBuffer();
stringBuffer.append("UPDATE Meeting_View_Status SET status = '1'");		
stringBuffer.append(" WHERE meetingId = ");
stringBuffer.append(meetingid);
stringBuffer.append(" AND userId = ");
stringBuffer.append(userid);
RecordSet.executeSql(stringBuffer.toString());

boolean canedit=false;
boolean cansubmit=false;
boolean candelete=false;
boolean canview=false;
boolean canapprove=false;
boolean canschedule=false;

/*Add by Huang Yu On*/
/***检查是否会议室管理员****/
rs.executeSql("select resourceid from hrmrolemembers where roleid = 11 and resourceid="+userid) ;
if(rs.next()){
    canschedule=true;
	canview=true;
}

/***检查通过审批流程查看会议***/
rs.executeSql("select userid from workflow_currentoperator where requestid = (select requestid from Bill_Meeting where approveid ="+meetingid+") and userid = "+userid) ;
if(rs.next()){
	canview=true;
}

RecordSet.executeProc("Meeting_Type_SelectByID",meetingtype);
RecordSet.next();
String canapprover=RecordSet.getString("approver");
int approvewfid =RecordSet.getInt("approver");
if(approvewfid<0) approvewfid = 0 ;



if(userid.equals(caller) || userid.equals(creater) ||  userid.equals(contacter) && !meetingstatus.equals("2")){
	canedit=true;
	cansubmit=true;
	candelete=true;
}

if(userid.equals(caller) || userid.equals(contacter) || userid.equals(creater) ){
	canview=true;
}
stringBuffer = new StringBuffer();
stringBuffer.append("SELECT * From Meeting, Meeting_ShareDetail");
stringBuffer.append(" WHERE Meeting.id = Meeting_ShareDetail.meetingId");
stringBuffer.append(" AND Meeting.id = ");
stringBuffer.append(meetingid);
stringBuffer.append(" AND((Meeting_ShareDetail.userid =");
stringBuffer.append(userid);
stringBuffer.append(" AND Meeting_ShareDetail.shareLevel in (1, 4))");
stringBuffer.append(" OR (Meeting.meetingStatus = 4");
stringBuffer.append(" AND Meeting_ShareDetail.userId = ");
stringBuffer.append(userid);
stringBuffer.append("))");

RecordSet.executeSql(stringBuffer.toString());
	if(RecordSet.next()){ 
		canview = true;
	}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%

String titlename="";
titlename+= "<B>"+SystemEnv.getHtmlLabelName(401,user.getLanguage())+":</B>"+createdate;
/*
if(user.getLogintype().equals("1"))
titlename +=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage());

titlename +="<B>"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+":</B>"+approvedate+"<B> "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>" ;
if(user.getLogintype().equals("1"))
titlename +=Util.toScreen(ResourceComInfo.getResourcename(approver),user.getLanguage());
*/

String imagefilename = "/images/hdMaintenance.gif";
titlename = SystemEnv.getHtmlLabelName(2103,user.getLanguage())+":"+Util.forHtml(meetingname)+"   "+titlename;
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


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


<DIV style="display:none">
<%
	//编辑
	if(canedit&&!meetingstatus.equals("1") && !meetingstatus.equals("4"))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnEdit id=Edit accessKey=E onclick='doEdit()'><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></BUTTON>
<%
	}
	//删除
	if(candelete&&!meetingstatus.equals("1") && !meetingstatus.equals("4"))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btn accessKey=D id=myfun1  onclick='doDelete()'><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%
	}

	//返回
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	//批准
	if(rqInfo.getHasright()==1&&!rqInfo.getIsend().equals("1")&&!rqInfo.getNodetype().equals("0") && !meetingstatus.equals("4"))
	{
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
	}
	
	//提交审批
	if(rqInfo.getHasright()==1&&!rqInfo.getIsend().equals("1")&&rqInfo.getNodetype().equals("0") && !meetingstatus.equals("4"))
	{
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:doSubmit2(this),_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
	}
	
	//退回
	if(rqInfo.getHasright()==1&&rqInfo.getIsreject().equals("1") && !meetingstatus.equals("4"))
	{
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:doReject(this),_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
	}

	//审批退回后，工作流被删除，重新提交工作流
	if(requestid==0&&!meetingstatus.equals("2")&&approvewfid != 0&&canedit && !meetingstatus.equals("4"))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:reSubmit(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	//提交
	if(approvewfid==0&&canedit && !meetingstatus.equals("4"))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:reSubmit2(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	//当状态为待审批、正常，召集人可取消会议
	if(("1".equals(meetingstatus) || "2".equals(meetingstatus)) && userid.equals(caller))
	{
		RCMenu += "{" + SystemEnv.getHtmlLabelName(20115, user.getLanguage()) + ",javascript:cancelMeeting(this),_self}";
		RCMenuHeight += RCMenuHeightStep;
	}
%>
	<BUTTON class=btn accessKey=C id=myfun4  onclick='doBack()'><U>C</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>
</DIV>

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>

	<TD vAlign=top>
	
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height:2px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></TD>
          <TD class=Field><%=Util.forHtml(meetingname)%></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TD>
          <TD class=Field><A href='/hrm/resource/HrmResource.jsp?id=<%=caller%>'><%=ResourceComInfo.getResourcename(caller)%></a></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field><A href='/hrm/resource/HrmResource.jsp?id=<%=contacter%>'><%=ResourceComInfo.getResourcename(contacter)%></a></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
<%if(software.equals("ALL") || software.equals("CRM")){%>
		<%if(isgoveproj==0){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
          <TD class=Field style="word-break:break-all;">
          
          <A href='/proj/data/ViewProject.jsp?ProjID=<%=projectid%>'>
          <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%>
          </a></TD>
		  <%}%>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
          <TD class=Field>
                <%if(meetingstatus.equals("0")){%>
					<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>
				<%}%>

				<%if(meetingstatus.equals("1")){%>
					<%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%>
				<%}%>
				<%if(meetingstatus.equals("2")){%>
					<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
				<%}%>
				<%if(meetingstatus.equals("3")){%>
					<%=SystemEnv.getHtmlLabelName(1010,user.getLanguage())%>
				<%}%>
				<%if(meetingstatus.equals("4")){%>
					<%=SystemEnv.getHtmlLabelName(20114,user.getLanguage())%>
				<%}%>
	      </TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
<%}%>
		<!--================ 提醒方式  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></TD>
			<TD class="Field">
			<%
				if("1".equals(remindType))
				{
			%>
				<%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
			<%
				}
				else if("2".equals(remindType))
				{
			%>
				<%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
			<%
				}
				else if("3".equals(remindType))
				{
			%>
				<%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			<%
				}
			%>
		</TR>
		<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<%
			if(!"1".equals(remindType))
			{
		%>
		<!--================ 提醒时间  ================-->
		<TR id="remindTime">
			<TD><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></TD>
			<TD class="Field">
     		<%
     			if("1".equals(remindBeforeStart))
     			{	int temmhour=Util.getIntValue(remindTimesBeforeStart,0)/60;
		            int temptinme=Util.getIntValue(remindTimesBeforeStart,0)%60;
     		%>
          		<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
                   <%= temmhour %>
				<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<%= temptinme %>
				<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				&nbsp&nbsp&nbsp
			<%
     			}
	     		if("1".equals(remindBeforeEnd))
	 			{   int temmhour=Util.getIntValue(remindTimesBeforeEnd,0)/60;
		            int temptinme=Util.getIntValue(remindTimesBeforeEnd,0)%60;
			%>
				<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
				 <%= temmhour %>
				<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<%= temptinme %>
				<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			<%
	 			}
			%>
          	</TD>
		</TR>
		<TR id="remindTimeLine">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		<%} %>
        </TBODY>
	  </TABLE>

	</TD>

	<TD></TD>

	<TD vAlign=top>
      
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height:2px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
          <TD class=Field><%=begindate%></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
          <TD class=Field><%=begintime%></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
		 <TR>
          <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field><%=enddate%></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
          <TD class=Field><%=endtime%></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></TD>
          <TD class=Field>
              <SPAN id=addressspan><%=MeetingRoomComInfo.getMeetingRoomInfoname(address)%></SPAN> 
              &nbsp;&nbsp;<a href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193,user.getLanguage())%></a>
		  </TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
        
        <!--================ 自定义会议地点 ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(20392, user.getLanguage())%></TD>
			<TD class=Field><%= customizeAddress %></TD>
		</TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        
        </TBODY>
	  </TABLE>
	</TD>
        </TR>
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(2166,user.getLanguage())%> <%=totalmember%> <%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>)</TH>
          </TR>
        <TR class=Spacing style="height:2px">
          <TD class=Line1></TD></TR>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>:  

<%
int MeetingMemberCount=0;
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
MeetingMemberCount = RecordSet.getCounts();
while(RecordSet.next()){
%>
			<input type=checkbox  checked disabled><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("memberid")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("memberid"))%></a>&nbsp&nbsp
<%}%>		  
		  </TD>
        </TR>
<%if(isgoveproj==0){%>
<%if(software.equals("ALL") || software.equals("CRM")){%>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(2167,user.getLanguage())%>: 
<%
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"2");
while(RecordSet.next()){
%>
			<input type=checkbox  checked disabled><A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("memberid")%>'><%=CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))%></a>(<A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("membermanager")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("membermanager"))%></a>)&nbsp&nbsp
<%}%>		  
		  </TD>
        </TR>
<%}%>
<%}%>
        <tr>
          <td class=field><%=SystemEnv.getHtmlLabelName(2168,user.getLanguage())%>: 
          <%=Util.toScreen(othermembers,user.getLanguage())%>
          <td>
        <tr>
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <TBODY>

        <tr><td colspan=2>
          <table class=ListStyle cellspacing=1 style="margin-bottom: 0px;">
            <COLGROUP>
    		<COL width="26%">
    		<COL width="17%">
    		<COL width="20%">
    		<COL width="12%">
    		<COL width="12%">
    		<COL width="7%">
    		<COL width="6%">
        <TR class=header>
            <TH colspan=8><%=SystemEnv.getHtmlLabelName(2169,user.getLanguage())%></TH>
            <Td align=right>
			</Td>
          </TR>
    		<tr class=header>
    		   <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
    		   <td><%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%></td>
    		   <td><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
    		   <%if(isgoveproj==0){%>
			   <td><%if(software.equals("ALL") || software.equals("CRM")){%><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%><%}%>&nbsp</td>
    		   <td><%if(software.equals("ALL") || software.equals("CRM")){%><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%><%}%>&nbsp</td>
    		   <%}else{%>
			   <td>&nbsp</td>
    		   <td>&nbsp</td>
			   <%}%>
			   <td><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></td>
    		   <td>&nbsp;</td>
    		</tr>
          </table>
        </td></tr>
        
        <TR>
          <TD colspan=2>   
	  <TABLE class=ViewForm cellspacing=1  cols=7 id="oTable">
        <COLGROUP>
		<COL width="26%">
		<COL width="17%">
		<COL width="20%">
		<COL width="12%">
		<COL width="12%">
		<COL width="7%">
		<COL width="6%">
        <TBODY>
<%
RecordSet.executeProc("Meeting_Topic_SelectAll",meetingid);
while(RecordSet.next()){
%>
		<tr>
			<td class=Field valign=top style="word-break:break-all;"><%=RecordSet.getString("subject")%></td>
			<td class=Field valign=top style="word-break:break-all;">
	<table>
	<%
	RecordSet2.executeProc("Meeting_TopicDate_SelectAll",meetingid+flag+RecordSet.getString("id"));
	while(RecordSet2.next()){
	%>
		<tr><td>
			<%=RecordSet2.getString("begindate")%> <%=RecordSet2.getString("begintime")%> - <%=RecordSet2.getString("enddate")%> <%=RecordSet2.getString("endtime")%>
		</td></tr>

	<%}%>
	</table>
			</td>
			<td class=Field valign=top style="word-break:break-all;">
<%
	ArrayList arrayhrmids = Util.TokenizerString(RecordSet.getString("hrmids"),",");
	for(int i=0;i<arrayhrmids.size();i++){
%>
			<A href='/hrm/resource/HrmResource.jsp?id=<%=""+arrayhrmids.get(i)%>'><%=ResourceComInfo.getResourcename(""+arrayhrmids.get(i))%></a>&nbsp
<%	
	}
%>		
			</td>
			<%if(isgoveproj==0){%>
			<td class=Field valign=top style="word-break:break-all;"><%if(software.equals("ALL") || software.equals("CRM")){%><a href="/proj/data/ViewProject.jsp?ProjID=<%=RecordSet.getString("projid")%>"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(RecordSet.getString("projid")),user.getLanguage())%></a><%}%></td>
			<td class=Field valign=top style="word-break:break-all;"><%if(software.equals("ALL") || software.equals("CRM")){%>
			   <%=getCustomerLinkStr(CustomerInfoComInfo,RecordSet.getString("crmids"))%>
				<%}%>
			</td>
			<%}else{%>
			<td class=Field valign=top></td>
			<td class=Field valign=top></td>
			<%}%>
			<td class=Field valign=top><%if(RecordSet.getString("isopen").equals("1")){%><input type=checkbox  checked disabled><%}else{%><input type=checkbox  disabled><%}%><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></td>
			<td class=Field valign=top width=5%><%if(canedit){%><button class=adddoc accesskey=Y onClick="onShowTopicDate(<%=RecordSet.getString("id")%>,<%=meetingid%>)" style="width:60px"><%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%></button><%}%></td>

		</tr>
		<tr style="height: 1px;">
		   <td colspan="8" class="line"></td>
		</tr>
<%}%>
        </TBODY>
	  </TABLE>		  
		  
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>

<%
RecordSet.executeProc("Meeting_Service2_SelectAll",meetingid);
if(RecordSet.getCounts()>0){
%>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=Title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(2107,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height:2px">
          <TD class=Line1 colspan=2></TD></TR>
<%
while(RecordSet.next()){
%>
        <TR>
		  <td><%=RecordSet.getString("name")%>(<A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid"))%></a>)</td>
          <TD> 
	  <TABLE class=ViewForm>
        <TBODY>
        <TR>
          <TD class=Field>
<%
	ArrayList serviceitems = Util.TokenizerString(RecordSet.getString("desc_n"),",");
	for(int i=0;i<serviceitems.size();i++){
%>
		  <input type=checkbox checked disabled><%=serviceitems.get(i)%>&nbsp&nbsp
<%
	}
%>&nbsp
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>		  
		  
		  </TD>
        </TR>
<%
}
%>
        </TBODY>
	  </TABLE>
<%}%>
	  <TABLE id=AccessoryTable class="ViewForm" style="margin-top:10px;">
	  	<COLGROUP>
		<COL width="15%">
  		<COL width="85%">
	  	<TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TH><!-- 相关附件 -->
          </TR>
          <TR class=spacing style="height:1px">
          	<TD class=line1 colspan=2></TD>
          </TR>
          <%
	        ArrayList arrayaccessorys = Util.TokenizerString(accessorys,",");
	        for(int i=0;i<arrayaccessorys.size();i++)
	        {
	        	String accessoryid = (String)arrayaccessorys.get(i);
	        	//System.out.println("accessoryid : "+accessoryid);
	        	if(accessoryid.equals(""))
	        	{
	        		continue;
	        	}
	            RecordSet.executeSql("select id,docsubject,accessorycount from docdetail where id="+accessoryid);
	            int linknum=-1;
	          	if(RecordSet.next())
	          	{
	      %>
			<TR CLASS=DataDark>
				<td></td>
				<td class=field>
		  <%
          		    linknum++;
          			String showid = Util.null2String(RecordSet.getString(1)) ;
	                String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
	                int accessoryCount=RecordSet.getInt(3);
	
	                DocImageManager.resetParameter();
	                DocImageManager.setDocid(Integer.parseInt(showid));
	                DocImageManager.selectDocImageInfo();
	
	                String docImagefileid = "";
	                long docImagefileSize = 0;
	                String docImagefilename = "";
	                String fileExtendName = "";
	                int versionId = 0;
	
	                if(DocImageManager.next())
	                {
		                //DocImageManager会得到doc第一个附件的最新版本
		                docImagefileid = DocImageManager.getImagefileid();
		                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
		                docImagefilename = DocImageManager.getImagefilename();
		                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
		                versionId = DocImageManager.getVersionId();
	                }
	                if(accessoryCount>1)
	                {
	                	fileExtendName ="htm";
	                }
             	    String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
			%>
					<%=imgSrc%>
					<%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx")))
					{
					%>
		            <a style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp;
          <%
			        }
					else
			        {
          %>
            		<a style="cursor:hand" onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp;
		  <%
				    }
		            if(accessoryCount==1)
		            {
          %>
	              <span id = "selectDownload">
	                <%
	                  //boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
	                  //if(!isLocked){
	                %>
	                  <button class=btn accessKey=1  onclick="downloads('<%=docImagefileid%>')">
	                    <%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
	                  </button>
	                <%//}%>
	              </span>	
			</td>
		</tr>
		<TR style="height:1px"><TD class=Line colspan=2></TD></TR>
		<%
					}
          		}
          	}
		%>
	  </TABLE>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=Title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height:2px">
          <TD class=Line1 colspan=2></TD></TR>
        <TR>
		  <td  class=Field colspan=2>
		  <%=desc%>&nbsp;
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>

<FORM id=Exchange name=Exchange action="/discuss/ExchangeOperation.jsp" method=post>
<input type="hidden" name="method1" value="add">
<input type="hidden" name="types" value="MP">	
<input type="hidden" name="sortid" value="<%=meetingid%>">
<TABLE class=ListStyle cellspacing=1  >
    <TR class=header>
    <TH> 相关交流 </TH>
        <Td align=right >		
        <a href="javascript:if(check_form(Exchange,'ExchangeInfo')){Exchange.submit();}"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp&nbsp
        </Td>         
    </TR>
    <TR >
        <TD class=Field colSpan="2">
        <TEXTAREA class=InputStyle NAME=ExchangeInfo ROWS=3 STYLE="width:100%"></TEXTAREA>
        </TD>
        </TR>

</TABLE>

  <TABLE class=ViewForm>
        <COLGROUP>
        <COL width="20%">
        <COL width="80%"><tr class=title>
        <TD> 相关文档 </TD>
        <TD class=field>
        <input type=hidden class=wuiBrowser name="docids" value=""
        _url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp"
        _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>&nbsp;">	
        <span id="docidsspan"></span> 
        </TD></tr>
  </table>

  </FORM>

  <FORM id=weaver name=weaver action="/workflow/request/BillMeetingOperation.jsp" method=post>
	<%if(requestid!=0){%>
	  <%if(rqInfo.getHasright()==1||rqInfo.getIsremark()==1){%>
			<input type=hidden name="requestid" value=<%=rqInfo.getRequestid()%>>
			<input type=hidden name="workflowid" value=<%=rqInfo.getWorkflowid()%>>
			<input type=hidden name="nodeid" value=<%=rqInfo.getNodeid()%>>
			<input type=hidden name="nodetype" value=<%=rqInfo.getNodetype()%>>
			<input type=hidden name="src">
			<input type=hidden name="iscreate" value="0">
			<input type=hidden name="formid" value=<%=rqInfo.getFormid()%>>
			<input type=hidden name="billid" value=<%=rqInfo.getBillid()%>>
			<input type=hidden name="requestname" value="<%=rqInfo.getRequestname()%>">
			<input type=hidden name="isfrommeeting" value="1">
			<input type=hidden name="isremark" value="<%=rqInfo.getIsremark()%>">
			<input type="hidden" name="MeetingID" value="<%=meetingid%>"/>
			<input type="hidden" name="approve"/>
			<input type="hidden" name="approvemeeting"/>
		<%}%>
	<%}%>

  </FORM>

  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="20%">
  		<COL width="30%">
  		<COL width="40%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>
          
	    </TR>
<%
boolean isLight = false;
char flag0=2;
int PnLogCount=0;
RecordSetEX.executeProc("ExchangeInfo_SelectBID",meetingid+flag0+"MP");
while(RecordSetEX.next())
{
PnLogCount++;
if (PnLogCount==4) {
%>
</tbody></table>
<div  id=WorkFlowDiv style="display:none">
    <table class=ListStyle cellspacing=1>
           <COLGROUP>
		<COL width="20%">
  		<COL width="30%">
  		<COL width="40%">
       
    <tbody> 
<%}
		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetEX.getString("createDate")%></TD>
          <TD><%=RecordSetEX.getString("createTime")%></TD>
          <TD>
			<%if(Util.getIntValue(RecordSetEX.getString("creater"))>0){%>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetEX.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetEX.getString("creater")),user.getLanguage())%></a>
			<%}else{%>
			<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetEX.getString("creater").substring(1)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+RecordSetEX.getString("creater").substring(1))%></a>
			<%}%>
		  </TD>
        </TR>
<%		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD colSpan=3><%=Util.toScreen(RecordSetEX.getString("remark"),user.getLanguage())%></TD>

        </TR>
<%		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
<%
        String docids_0=  Util.null2String(RecordSetEX.getString("docids"));
        String docsname="";
        if(!docids_0.equals("")){

            ArrayList docs_muti = Util.TokenizerString(docids_0,",");
            int docsnum = docs_muti.size();

            for(int i=0;i<docsnum;i++){
                docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a><br>" +" ";               
            }
        }
        
 %>
     <td >相关文档: </td> <td  colSpan=2> <%=docsname%></td>
         </TR>
         
     </tr>
<%
	isLight = !isLight;
}
%>	  </TBODY>
	  </TABLE>
<% if (PnLogCount>=4) { %> </div> <%}%>
        <table class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
          <tbody> 
          <tr class=header> 
            <% if (PnLogCount>=4) { %>
            <td colspan=3 align=right><SPAN id=WorkFlowspan><a href='/discuss/ViewExchange.jsp?types=MP&sortid=<%=meetingid%>' >全部</a></span></td>
            <%}%>
          </tr>
         </tbody> 
        </table>

<script language=vbs>
sub onShowMDoc(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&tmpids)
         if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					tempdocids = id1(0)
					docname = id1(1)
					sHtml = ""
					tempdocids = Mid(tempdocids,2,len(tempdocids))
					document.all(inputename).value= tempdocids
					docname = Mid(docname,2,len(docname))
					while InStr(tempdocids,",") <> 0
						curid = Mid(tempdocids,1,InStr(tempdocids,",")-1)
						curname = Mid(docname,1,InStr(docname,",")-1)
						tempdocids = Mid(tempdocids,InStr(tempdocids,",")+1,Len(tempdocids))
						docname = Mid(docname,InStr(docname,",")+1,Len(docname))
						sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&tempdocids&">"&docname&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
        end if
end sub

sub onShowTopicDate1(recorderid,meetingid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingTopicDate.jsp?recorderid="&recorderid&"&meetingid="&meetingid)
	window.location = "ViewMeeting.jsp?meetingid=" & meetingid
end sub
</script>
<script language=javascript>

function doEdit(){
   location.href="/meeting/data/EditMeeting.jsp?meetingid=<%=meetingid%>";
}

function doDelete(){
   if(isdel()){
      location.href="/meeting/data/MeetingOperation.jsp?meetingid=<%=meetingid%>&method=delete"
    }
}

function doBack(){
    history.back();
}

function onShowTopicDate(recorderid,meetingid){
   var results=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingTopicDate.jsp?recorderid="+recorderid+"&meetingid="+meetingid);
   window.location = "ViewMeeting.jsp?meetingid="+meetingid;
}

function opendoc(showid,versionid,docImagefileid)
{
	openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&meetingid=<%=meetingid%>&isFromAccessory=true");
}
function opendoc1(showid)
{
	openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&meetingid=<%=meetingid%>");
}
function downloads(files)
{
	document.location.href="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&meetingid=<%=meetingid%>";
}
function checkuse(){
    <%
    String tempbegindate="";
    String tempenddate="";
    String tempbegintime="";
    String tempendtime="";
    String tempAddress="0";
    RecordSet.executeSql("select Address,begindate,enddate,begintime,endtime from meeting where meetingstatus=2 and isdecision<2 and (cancel is null or cancel<>'1') and begindate>='"+currentdate+"' AND address <> 0 AND address IS NOT null");
    while(RecordSet.next()){
        tempAddress=RecordSet.getString("Address");
        tempbegindate=RecordSet.getString("begindate");
        tempenddate=RecordSet.getString("enddate");
        tempbegintime=RecordSet.getString("begintime");
        tempendtime=RecordSet.getString("endtime");
   %>
   if("<%=address%>"=="<%=tempAddress%>"){
       if(!("<%=begindate+' '+begintime%>">"<%=tempenddate+' '+tempendtime%>" || "<%=enddate+' '+endtime%>"<"<%=tempbegindate+' '+tempbegintime%>")){
           return true;
       }
   }
   <%
    }
    %>
    return false;
}
var meetingmembercount = <%=MeetingMemberCount%>;
	function doSubmit(obj){
	 // if(confirm("你确定要批准吗？")){
	    //document.weaver.approve.value='1';
        if(checkuse()){
            if(confirm("<%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>")){
                obj.disabled = true;
                document.weaver.approvemeeting.value='1';
                document.weaver.src.value='submit';
                document.weaver.submit();
            }
        }else{
            obj.disabled = true;
            document.weaver.src.value='submit';
            document.weaver.submit();
        }		
	//  }
	}
	function doReject(obj){
		if(confirm("你确定要退回吗？")){
		obj.disabled = true;
		document.weaver.src.value='reject';
		document.weaver.submit();
		}
	}
	
	function doSubmit2(obj){
	if(meetingmembercount<=0){
		alert("请选择参会人员！");
		return;
	}
	if(confirm("你确定要提交吗？")){
		if(checkuse() ){
            if(confirm("<%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>")){
                obj.disabled = true;
                document.weaver.src.value='submit';
                document.weaver.submit();
            }
        }else{
            obj.disabled = true;
            document.weaver.src.value='submit';
            document.weaver.submit();
        }
	}
}

	function reSubmit(obj){
	if(meetingmembercount<=0){
		alert("请选择参会人员！");
		return;
	}
		if(confirm("你确定要提交吗？")){
            if(checkuse()){
            if(confirm("<%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>")){
                obj.disabled = true;
			    document.location ="/workflow/request/BillMeetingOperation.jsp?src=submit&viewmeeting=1&iscreate=1&MeetingID=<%=meetingid%>&approvewfid=<%=approvewfid%>";
            }
            }else{
                obj.disabled = true;
			    document.location ="/workflow/request/BillMeetingOperation.jsp?src=submit&viewmeeting=1&iscreate=1&MeetingID=<%=meetingid%>&approvewfid=<%=approvewfid%>";
            }
			
		}
	}

    function reSubmit2(obj){
	if(meetingmembercount<=0){
		alert("请选择参会人员！");
		return;
	}
		if(confirm("你确定要提交吗？")){
            if(checkuse()){
            if(confirm("<%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>")){
                obj.disabled = true;
			    document.location ="/meeting/data/MeetingOperation.jsp?method=editSubmit&meetingid=<%=meetingid%>";
            }
            }else{
                obj.disabled = true;
			    document.location ="/meeting/data/MeetingOperation.jsp?method=editSubmit&meetingid=<%=meetingid%>";
            }			
		}
	}
 function doSave1(){
	if(check_form(document.Exchange,"ExchangeInfo")){
		document.Exchange.submit();
	}
}

function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()>全部</a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()>部分</a>";
			WorkFlowDiv.style.display = "";
		}
	}

function cancelMeeting(obj)
{
	if(confirm("<%=SystemEnv.getHtmlLabelName(20117, user.getLanguage())%>"))
	{
		obj.disabled = true;
        document.cancelMeeting.submit();
	}
}
function showRemindTime(obj)
{
	if("1" == obj.value)
	{
		document.all("remindTime").style.display = "none";
		document.all("remindTimeLine").style.display = "none";
	}
	else
	{
		document.all("remindTime").style.display = "";
		document.all("remindTimeLine").style.display = "";
	}
}
</script>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=cancelMeeting name=cancelMeeting action="/meeting/data/MeetingOperation.jsp" method=post enctype="multipart/form-data">
	<INPUT type="hidden" name="method" value="cancelMeeting">
	<INPUT type="hidden" name="meetingId" value="<%=meetingid%>">
</FORM>

</body>
</html>

