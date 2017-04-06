<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="java.sql.Timestamp,weaver.conn.*,weaver.crm.Maint.CustomerInfoComInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<%!
/**
 * Charoes Huang ,June 4,2004
 */
private String getCustomerLinkStr(CustomerInfoComInfo comInfo,String crmids){
	String returnStr ="";
	ArrayList a_crmids = Util.TokenizerString(crmids,",");
	for(int i=0;i<a_crmids.size();i++){
		String id = (String)a_crmids.get(i);
		returnStr += "<a href=\"/CRM/data/ViewCustomer.jsp?CustomerID="+id+"\">"+comInfo.getCustomerInfoname(id)+"</a> ";
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
String isdecision=RecordSet.getString("isdecision");
String decision=RecordSet.getString("decision");
String decisiondocid=RecordSet.getString("decisiondocid");

String projectid=RecordSet.getString("projectid");//获得项目id
String totalmember=RecordSet.getString("totalmember");
String othermembers=RecordSet.getString("othermembers");
String othersremark=RecordSet.getString("othersremark");
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




String sqlStr="Select approveby,approvedate from bill_meeting where ApproveID="+meetingid;
rs.executeSql(sqlStr);
if(rs.next()){
approver = rs.getString("approveby");
approvedate = rs.getString("approvedate");
}
//System.out.println("approver =="+approver) ;
//System.out.println("approvedate =="+approvedate);
/*如果会议状态不为正常*/
if(!meetingstatus.equals("2")){
	response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+meetingid) ;
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

String Sql="";
boolean canview=false;
boolean ismanager=false;
boolean iscontacter=false;
boolean ismember=false;
boolean isservicer=false;
boolean isdecisioner=false;

if(userid.equals(caller) || userid.equals(approver) ){
	canview=true;
	ismanager=true;
}
if(userid.equals(contacter)||userid.equals(creater)){
    canview=true;
}
//modified by Charoes Huang On July 23,2004
if(meetingstatus.equals("2")){
	if(RecordSet.getDBType().equals("oracle")){
		Sql="select memberid from Meeting_Member2 where meetingid="+meetingid+" and ( membermanager="+userid+" or concat(concat(',',othermember),',') like '%,"+userid+",%' )";
	}else{
		Sql="select memberid from Meeting_Member2 where meetingid="+meetingid+" and ( membermanager="+userid+" or ','+othermember+',' like '%,"+userid+",%' )";
	}
	//System.out.println("sql = "+Sql);
	RecordSet.executeSql(Sql);
	if(RecordSet.next()) {
		canview=true;
		ismember=true;
	}
}

if(!canview){
	Sql="select hrmid from Meeting_Service2 where meetingid="+meetingid+" and hrmid="+userid;
	RecordSet.executeSql(Sql);
	if(RecordSet.next()) {
		canview=true;
		isservicer=true;
	}
}

/***检查通过审批流程查看会议***/
rs.executeSql("select userid from workflow_currentoperator where requestid = (select requestid from Bill_Meeting where approveid ="+meetingid+") and userid = "+userid) ;
if(rs.next()){
	canview=true;
}

if(!canview && (isapproved.equals("3")||isapproved.equals("4"))){
	if(RecordSet.getDBType().equals("oracle")){
		Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( concat(concat(',',hrmid01),',') like '%,"+userid+",%' or hrmid02="+userid+" )";
	}else if(RecordSet.getDBType().equals("db2")){
        Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( concat(concat(',',hrmid01),',') like '%,"+userid+",%' or hrmid02="+userid+" )";
	}else{
		Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( ','+hrmid01+',' like '%,"+userid+",%' or hrmid02="+userid+" )";
	}	
	RecordSet.executeSql(Sql);
	if(RecordSet.next()) {
		canview=true;
		isdecisioner=true;
	}
}

if(userid.equals(contacter)&&(!ismember||!isdecisioner))
    iscontacter=true;


RecordSet.executeSql("Select * From Meeting_ShareDetail WHERE meetingid="+meetingid+" and userid ="+userid+" and sharelevel in (1,2,3,4)");
	if(RecordSet.next()) canview = true;

//代理人在提醒流程和会议室报表中有查看会议的权限 MYQ 2007.12.10 开始
RecordSet.executeSql("Select * From workflow_agent Where workflowid=1 and agenttype=1 and agenterId ="+userid+" and beagenterId in (select memberid from Meeting_Member2 where meetingid="+meetingid+")");
if(RecordSet.next()) canview = true;
//代理人在提醒流程和会议室报表中有查看会议的权限 MYQ 2007.12.10 结束

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(2103,user.getLanguage())+":"+Util.forHtml(meetingname);
String needfav ="1";
String needhelp ="";

titlename += "<B>"+SystemEnv.getHtmlLabelName(401,user.getLanguage())+":</B>"+createdate+"<B> "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>";
if(user.getLogintype().equals("1"))
titlename +=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage());
titlename +="<B>"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+":</B>"+approvedate+"<B> "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>" ;
if(user.getLogintype().equals("1"))
titlename +=Util.toScreen(ResourceComInfo.getResourcename(approver),user.getLanguage());

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//System.out.println("ismember ="+ismember);
if((ismanager) && (!isdecision.equals("2"))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(2194,user.getLanguage())+",javascript:onShowDecision("+meetingid+"),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

//结束的会议不允许取消 modify by MYQ 2008.3.4 start
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
boolean isover = false;//会议是否结束
//该会议的meetingstatus=2,并且结束时间不在当前时间之后或者该会议已产生会议决议，该会议即为结束
if((enddate+":"+endtime).compareTo(CurrentDate+":"+CurrentTime)<=0 || isdecision.equals("2")) isover=true;
//当状态为待审批、正常，召集人可取消会议
if(("1".equals(meetingstatus) || ("2".equals(meetingstatus) && !isover)) && userid.equals(caller))
{
	RCMenu += "{" + SystemEnv.getHtmlLabelName(20115, user.getLanguage()) + ",javascript:cancelMeeting(this),_self}";
	RCMenuHeight += RCMenuHeightStep;
}
//结束的会议不允许取消 modify by MYQ 2008.3.4 end
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

<TABLE class=viewform>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>
	<TD vAlign=top>
          <TABLE class=viewForm>
            <COLGROUP>
            <COL width="30%">
            <COL width="70%">
            <TBODY>
            <TR class=Title>
                <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
              </TR>
            <TR class=spacing style="height:2px">
              <TD class=line1 colSpan=2></TD></TR>
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></TD>
              <TD class=Field><%=Util.forHtml(meetingname)%></TD>
            </TR>
            <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TD>
              <TD class=Field><A href='/hrm/resource/HrmResource.jsp?id=<%=caller%>'><%=ResourceComInfo.getResourcename(caller)%></a></TD>
            </TR>
            <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
              <TD class=Field><A href='/hrm/resource/HrmResource.jsp?id=<%=contacter%>'><%=ResourceComInfo.getResourcename(contacter)%></a></TD>
            </TR>
                    <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
	<%if(isgoveproj==0){%>
    <%if(software.equals("ALL") || software.equals("CRM")){%>
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
              <TD class=Field style="word-break:break-all;">
                        <A href='/proj/data/ViewProject.jsp?ProjID=<%=projectid%>'>
              <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%>
              </a></TD>
            </TR>
          <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
		
		
    <%}%>
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
					</TD>
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
			<TR id="remindTimeLine" style="display:none">
				<TD class="Line" colSpan="2"></TD>
			</TR>
			<%} %>
            </TBODY>
          </TABLE>
	</TD>
    <TD></TD>
	<TD vAlign=top>
          <TABLE class=viewForm>
            <COLGROUP>
            <COL width="30%">
            <COL width="70%">
            <TBODY>
            <TR class=title>
                <TH colSpan=2><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TH>
              </TR>
            <TR class=spacing style="height:2px">
              <TD class=line1 colSpan=2></TD></TR>
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
              <TD class=Field><%=begindate%></TD>
            </TR>
            <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
              <TD class=Field><%=begintime%></TD>
            </TR>
             <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
              <TD class=Field><%=enddate%></TD>
            </TR>
             <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
              <TD class=Field><%=endtime%></TD>
            </TR>
             <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></TD>
              <TD class=Field>
              <A href='/meeting/Maint/MeetingRoom.jsp'><%=MeetingRoomComInfo.getMeetingRoomInfoname(address)%></a>
              </TD>
            </TR>
             <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
             
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

	  <TABLE  class=ListStyle cellspacing=1>
        <TBODY>
        <TR class=Header>
            <TH colspan=9><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(2166,user.getLanguage())%> <%=totalmember%> <%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>)</TH>
          </TR>
        <TR class=Header>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(2195,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(2196,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(2197,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(2198,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(2199,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(2200,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(2182,user.getLanguage())%></TH>
          <TH  align=left></TH>
		</TR>
<%
int hrmnum=0;
int crmnum=0;
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
while(RecordSet.next()){

%>
        <TR class=datadark>
          <TD class=Field> 
			<input class=inputstyle type=checkbox  checked disabled><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("memberid")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("memberid"))%></a>
		  </TD>
          <TD class=Field> 
			<%if(RecordSet.getString("isattend").equals("1")){hrmnum+=1;%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("isattend").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("isattend").equals("3")){%><%=SystemEnv.getHtmlLabelName(2188,user.getLanguage())%><%}%>
		  </TD>
          <TD class=Field> 
			<%=RecordSet.getString("begindate")%> <%=RecordSet.getString("begintime")%>
		  </TD>
          <TD class=Field> 
			<%if(RecordSet.getString("bookroom").equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("bookroom").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
		  </TD>
          <TD class=Field> 
			<%=RecordSet.getString("roomstander")%>
		  </TD>
          <TD class=Field> 
			<%if(RecordSet.getString("bookticket").equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("bookticket").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
		  </TD>
          <TD class=Field> 
			<%=RecordSet.getString("enddate")%> <%=RecordSet.getString("endtime")%>
		  </TD>
          <TD class=Field> 
			<%if(RecordSet.getString("ticketstander").equals("1")){%><%=SystemEnv.getHtmlLabelName(2201,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("2")){%><%=SystemEnv.getHtmlLabelName(2202,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("3")){%><%=SystemEnv.getHtmlLabelName(2203,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("4")){%><%=SystemEnv.getHtmlLabelName(2204,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("5")){%><%=SystemEnv.getHtmlLabelName(2205,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("6")){%><%=SystemEnv.getHtmlLabelName(2206,user.getLanguage())%><%}%>
		  </TD>
		  <td class=Field  width="5%">
			<%if((ismanager || RecordSet.getString("membermanager").equals(userid)) && (!isdecision.equals("1") && !isdecision.equals("2"))){%><button type="button" class=adddoc onClick="onShowReHrm(<%=RecordSet.getString("id")%>,<%=meetingid%>)" style="width:60px"><%=SystemEnv.getHtmlLabelName(2108,user.getLanguage())%></button><%}%>
		  </td>

        </TR>
		<%if(!RecordSet.getString("othermember").equals("")){%>
        <TR class=datalight>
          
    <TD class=Field colspan=9> <img border=0 src="/images/ArrowRightBlue.gif" align=middle>&nbsp 
      <%
				ArrayList arrayothermember = Util.TokenizerString(RecordSet.getString("othermember"),",");
				for(int i=0;i<arrayothermember.size();i++){
					hrmnum+=1;
			%>
      <A href='/hrm/resource/HrmResource.jsp?id=<%=""+arrayothermember.get(i)%>'><%=ResourceComInfo.getResourcename(""+arrayothermember.get(i))%></a>&nbsp 
      <%}%>
    </TD>
		</TR>
		<%}%>	
<%}%>
<%if(software.equals("ALL") || software.equals("CRM")){%>
<%
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"2");
while(RecordSet.next()){
%>
		  <TR class=datadark>
          <TD class=Field>
			<input class=inputstyle type=checkbox  checked disabled><A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("memberid")%>'><%=CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))%></a>(<A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("membermanager")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("membermanager"))%></a>)
		  </TD>
          <TD class=Field> 
			<%if(RecordSet.getString("isattend").equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("isattend").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("isattend").equals("3")){%><%=SystemEnv.getHtmlLabelName(2188,user.getLanguage())%><%}%>
		  </TD>
          <TD class=Field> 
			<%=RecordSet.getString("begindate")%> <%=RecordSet.getString("begintime")%>
		  </TD>
          <TD class=Field> 
			<%if(RecordSet.getString("bookroom").equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("bookroom").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
		  </TD>
          <TD class=Field> 
			<%=RecordSet.getString("roomstander")%>
		  </TD>
          <TD class=Field> 
			<%if(RecordSet.getString("bookticket").equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("bookticket").equals("2")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
		  </TD>
          <TD class=Field> 
			<%=RecordSet.getString("enddate")%> <%=RecordSet.getString("endtime")%>
		  </TD>
          <TD class=Field> 
			<%if(RecordSet.getString("ticketstander").equals("1")){%><%=SystemEnv.getHtmlLabelName(2201,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("2")){%><%=SystemEnv.getHtmlLabelName(2202,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("3")){%><%=SystemEnv.getHtmlLabelName(2203,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("4")){%><%=SystemEnv.getHtmlLabelName(2204,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("5")){%><%=SystemEnv.getHtmlLabelName(2205,user.getLanguage())%><%}%>
			<%if(RecordSet.getString("ticketstander").equals("6")){%><%=SystemEnv.getHtmlLabelName(2206,user.getLanguage())%><%}%>
		  </TD>
		  <td class=Field  width="5%">
			<%if((ismanager || RecordSet.getString("membermanager").equals(userid)) && (!isdecision.equals("1") && !isdecision.equals("2"))){%><button type="button" class=adddoc onClick="onShowReCrm(<%=RecordSet.getString("id")%>,<%=meetingid%>)" style="width:60px"><%=SystemEnv.getHtmlLabelName(2108,user.getLanguage())%></button><%}%>
		  </td>
        </TR>
	<%
	RecordSet2.executeProc("Meeting_MemberCrm_SelectAll",RecordSet.getString("id"));
	while(RecordSet2.next()){
		crmnum+=1;
	%>		
			  <TR class=datalight>
			  
    <TD class=Field> <img border=0 src="/images/ArrowRightBlue.gif" align=middle>&nbsp<%=RecordSet2.getString("name")%> 
    </TD>
			  <TD class=Field> 
				<%if(RecordSet2.getString("sex").equals("1")){%><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%><%}%>
				<%if(RecordSet2.getString("sex").equals("2")){%><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%><%}%>
			  </TD>
			  <TD class=Field>
				<%=RecordSet2.getString("occupation")%>
			  </TD>
			  <TD class=Field>
				<%=RecordSet2.getString("tel")%>
			  </TD>
			  <TD class=Field>
				<%=RecordSet2.getString("handset")%>
			  </TD>
			  <TD class=Field colspan=4>
				<%=RecordSet2.getString("desc_n")%>
			  </TD>
			</TR>
	<%}%>	
<%}%>	
<%}%>
            <tr class=datalight>
                <td><%=SystemEnv.getHtmlLabelName(2168,user.getLanguage())%>:<%=Util.toScreen(othermembers,user.getLanguage())%></td>
                <td colspan=7><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>:<%=Util.toScreen(othersremark,user.getLanguage())%></td>
                <td><%if(ismanager && !isdecision.equals("1") && !isdecision.equals("2")){%><button type="button" class=adddoc onClick="onShowReOthers(<%=meetingid%>)" style="width:60px"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></button><%}%></td>
            <tr>
			  <TR class=datadark>
			  <TD class=Field colspan=9>
				<%=SystemEnv.getHtmlLabelName(2207,user.getLanguage())%><font class=fontred><%=hrmnum+crmnum%></font><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(2208,user.getLanguage())%><font class=fontred><%=hrmnum%></font><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(2209,user.getLanguage())%><font class=fontred><%=crmnum%></font><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
			  </TD>
			</TR>
        </TBODY>
	  </TABLE>

	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2169,user.getLanguage())%></TH>
			<td class=Field valign=top  width="5%" nowrap><%if(ismanager && !isdecision.equals("1") && !isdecision.equals("2")){%><button type="button" class=adddoc accesskey=Y onClick="onShowTopic(<%=meetingid%>)" style="width:60px"><%=SystemEnv.getHtmlLabelName(2210,user.getLanguage())%></button><%}%></td>
        </TR>
        <TR class=spacing style="height:2px">
          <TD class=line1 colspan=2></TD></TR>
        <tr><td colspan=2>
          <table class=liststyle cellspacing=1 cellpadding=1 style="margin-bottom: 0px;">
            <COLGROUP>
    		<COL width="21%">
    		<COL width="17%">
    		<COL width="20%">
    		<COL width="12%">
    		<COL width="12%">
    		<COL width="7%">
    		<COL width="11%">
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
		  
	  <TABLE class=liststyle cellspacing=1 cellpadding=1  cols=7 id="oTable" style="margin-top: 0px;">
        <TBODY>
<%
RecordSet.executeProc("Meeting_Topic_SelectAll",meetingid);
while(RecordSet.next()){
	ArrayList arrayhrmids = Util.TokenizerString(RecordSet.getString("hrmids"),",");
	if(ismanager || arrayhrmids.contains(userid) || iscontacter || ( RecordSet.getString("isopen").equals("1") && ismember )){
%>
		<tr>
			<td class=Field valign=top width="21%" style="word-break:break-all;"><%=RecordSet.getString("subject")%></td>
			<td class=Field valign=top width="17%" style="word-break:break-all;">
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

			<td class=Field valign=top width="20%" style="word-break:break-all;">
<%
	for(int i=0;i<arrayhrmids.size();i++){
%>
			<A href='/hrm/resource/HrmResource.jsp?id=<%=""+arrayhrmids.get(i)%>'><%=ResourceComInfo.getResourcename(""+arrayhrmids.get(i))%></a>&nbsp
<%	
	}
%>		
			</td>
			<td class=Field valign=top width="12%" style="word-break:break-all;"><%if(software.equals("ALL") || software.equals("CRM")){%><a href="/proj/data/ViewProject.jsp?ProjID=<%=RecordSet.getString("projid")%>"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(RecordSet.getString("projid")),user.getLanguage())%></a><%}%>&nbsp</td>
			<td class=Field valign=top width="12%" style="word-break:break-all;"><%if(software.equals("ALL") || software.equals("CRM")){%>
				  <%=getCustomerLinkStr(CustomerInfoComInfo,RecordSet.getString("crmids"))%>
			<%}%>&nbsp</td>
			<td class=Field valign=top width="7%"><%if(RecordSet.getString("isopen").equals("1")){%><input class=inputstyle type=checkbox  checked disabled><%}else{%><input class=inputstyle type=checkbox  disabled><%}%><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></td>
			<td class=Field valign=top  width="11%" nowrap><%if(!isdecision.equals("1") && !isdecision.equals("2")){%><button type="button" class=adddoc accesskey=Y onClick="onShowTopicDoc(<%=RecordSet.getString("id")%>)" style="width:60px"><%=SystemEnv.getHtmlLabelName(2212,user.getLanguage())%></button><%}%><%if(ismanager && !isdecision.equals("1") && !isdecision.equals("2")){%><button type="button" class=adddoc accesskey=Y onClick="onShowTopicDate(<%=RecordSet.getString("id")%>,<%=meetingid%>)" style="width:60px"><%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%></button><%}%></td>
		</tr>

		<%
			ProcPara = meetingid + flag + RecordSet.getString("id");
			RecordSet2.executeProc("Meeting_TopicDoc_SelectAll",ProcPara);
			while(RecordSet2.next()){
		%>
		<tr>
        <td class=Field colspan=2><img border=0 src="/images/ArrowRightBlue.gif" align=middle>&nbsp<a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet2.getString("docid")%>"><%=Util.toScreen(RecordSet2.getString("docsubject"),user.getLanguage())%></a></td>
	    <td class=Field colspan=4><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet2.getString("hrmid")%>'><%=ResourceComInfo.getResourcename(RecordSet2.getString("hrmid"))%></a></td>
		<td class=Field><%if(!isdecision.equals("1") && !isdecision.equals("2") && (ismanager || iscontacter || userid.equals(RecordSet2.getString("hrmid")))){%><a href="TopicDocOperation.jsp?method=delete&meetingid=<%=meetingid%>&id=<%=RecordSet2.getString("id")%>"  onclick="return isdel()"><img border=0 src="/images/icon_delete.gif"></a><%}%></td>
		</tr>
		<%}%>

<%
	}
}
%>     </TBODY>
	  </TABLE>		  
	  </TD></TR>
	</TBODY>
</TABLE>
<%if((isdecision.equals("1") || isdecision.equals("2")) && (ismanager || ismember || isdecisioner )){%>
	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2194,user.getLanguage())%></TH>
            <Td align=right>
			</Td>
          </TR>
        <TR class=spacing>

        <TR>
          <TD colspan=2> 
 
	  <TABLE class=liststyle cellspacing=1 cellpadding=1  cols=4 id="oTable">
      	<COLGROUP>
		<COL width="6%">
		<COL>
		<COL>
		<COL>
		<COL width="12%">
		<COL width="12%">
		<COL width="10%">
        <TBODY>
        <TR class=Header>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(2172,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(2173,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TH>
          <TH  align=left><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TH>
		</TR>
        <TR>
          <TD class=field nowrap><%=SystemEnv.getHtmlLabelName(2170,user.getLanguage())%>：</TD>
		  <TD class=field colspan=6><%=Util.toScreen(decision,user.getLanguage())%></TD></TR>
        <TR>
          <TD class=field><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>：</TD>
		  <TD class=field colspan=6><a href="/docs/docs/DocDsp.jsp?id=<%=decisiondocid%>"><%=Util.toScreen(DocComInfo.getDocname(decisiondocid),user.getLanguage())%></a></TD></TR>
<%
RecordSet.executeProc("Meeting_Decision_SelectAll",meetingid);
while(RecordSet.next()){
if(ismanager || ismember || (","+RecordSet.getString("hrmid01")+",").indexOf(","+userid+",")!=-1 || RecordSet.getString("hrmid02").equals(userid)){
	String decisionview = "";
	String decisionrealizedate = "";
	String decisionrealizetime = "";
	if(!RecordSet.getString("requestid").equals("0")){
		String sqlview="select * from workflow_requestviewlog where id = "+RecordSet.getString("requestid");
		if(!RecordSet.getString("hrmid01").equals("")){
			sqlview += " and viewer = "+RecordSet.getString("hrmid01");
		}
		//System.out.println("sqlview = " + sqlview);
		String sqlrealize="select customizestr1,customizestr2 from bill_HrmTime where requestid ="+RecordSet.getString("requestid");
		RecordSet2.executeSql(sqlview);
		if(RecordSet2.next()){
			decisionview = "已查阅" ; //文字
		}
		RecordSet2.executeSql(sqlrealize);
		if(RecordSet2.next()){
			decisionrealizedate=RecordSet2.getString("customizestr1");
			decisionrealizetime=RecordSet2.getString("customizestr2");
		}
	}

%>
		<tr>
			<td class=Field><%=RecordSet.getString("coding")%></td>
			<td class=Field><%=RecordSet.getString("subject")%></td>
			<td class=Field>
			<%
			ArrayList hrms = Util.TokenizerString(RecordSet.getString("hrmid01"),",");
			for(int i=0;i<hrms.size();i++){
			
			%>
			<A href='/hrm/resource/HrmResource.jsp?id=<%=hrms.get(i)%>'><%=ResourceComInfo.getResourcename(String.valueOf(hrms.get(i)))%></a>&nbsp
			<%}%>
			
			
			</td>
			<td class=Field><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid02")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid02"))%></a></td>
			<td class=Field><%=RecordSet.getString("begindate")%> <%=RecordSet.getString("begintime")%></td>
			<td class=Field><%=RecordSet.getString("enddate")%> <%=RecordSet.getString("endtime")%></td>
			<td class=Field>
				<a href="/workflow/request/ViewRequest.jsp?requestid=<%=RecordSet.getString("requestid")%>"><%if(!decisionrealizedate.equals("")){%><%=SystemEnv.getHtmlLabelName(2213,user.getLanguage())%><%}else{%><%=Util.toScreen(decisionview,user.getLanguage(),"0")%><%}%></a>
			</td>
		</tr>
<%
}
}
%>
        </TBODY>
	  </TABLE>		  
		  
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>
<%}%>
<%
RecordSet.executeProc("Meeting_Service2_SelectAll",meetingid);
if(RecordSet.getCounts()>0){
%>
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(2107,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:2px">
          <TD class=line1 colspan=2></TD></TR>
<%
while(RecordSet.next()){
%>
        <TR>
		  <td><%=RecordSet.getString("name")%>(<A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid"))%></a>)</td>
          <TD> 
	  <TABLE class=viewForm>
        <TBODY>
        <TR>
          <TD class=Field>
<%
	ArrayList serviceitems = Util.TokenizerString(RecordSet.getString("desc_n"),",");
	for(int i=0;i<serviceitems.size();i++){
%>
		  <input class=inputstyle type=checkbox checked disabled><%=serviceitems.get(i)%>&nbsp&nbsp
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
	  <TABLE id=AccessoryTable class="ViewForm" style="">
	  	<COLGROUP>
		<COL width="15%">
  		<COL width="85%">
	  	<TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TH><!-- 相关附件 -->
          </TR>
          <TR class=spacing style="height:2px">
          	<TD class=line1 colspan=2></TD></TR>
          <TR>
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
	                  <button type="button" class=adddoc accessKey=1  onclick="downloads('<%=docImagefileid%>')">
	                    <%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
	                  </button>
	                <%//}%>
	              </span>	
			</td>
		</tr>
		<TR style="height:1px"><TD class=Line colspan=2></TD></TR><TR>
		<%
					}
          		}
          	}
		%>
	  </TABLE>
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:2px">
          <TD class=line1 colspan=2></TD></TR>
        <TR>
		  <td  class=Field colspan="2">
		  <%=desc%>
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>


<FORM id=Exchange name=Exchange action="/discuss/ExchangeOperation.jsp" method=post>
<input class=inputstyle type="hidden" name="method1" value="add">
<input class=inputstyle type="hidden" name="types" value="MP">	
<input class=inputstyle type="hidden" name="sortid" value="<%=meetingid%>">
<TABLE class=ListStyle cellspacing=1 cellpadding=1  >
    <TR class=Header>
    <TH >相关交流</TH>
        <Td align=right >		
        <a href="javascript:if(check_form(Exchange,'ExchangeInfo')){Exchange.submit();}"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp&nbsp
        </Td>         
    </TR>
       <TR >
        <TD class=Field colSpan="2">
        <TEXTAREA class=inputStyle NAME=ExchangeInfo ROWS=3 STYLE="width:100%"></TEXTAREA>
        </TD>
    </TR>
    <TR class=datadark>
        <TD width="20%">相关文档</TD>
        <TD class=field>
        <input class=wuiBrowser type=hidden name="docids" 
        _url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp"
        _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>&nbsp;">	
        <span id="docidsspan"></span> 
        </TD>
    </TR>
</TABLE>
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
<tr><td colspan=3>
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
        if(PnLogCount>=4) { %>	
        </TBODY>
        </TABLE>
        </div>
        </td>
        </tr>
        <%}%>
        </TBODY>
        </TABLE>
        <table class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
          <tbody> 
          <tr> 
            <td> </td>
            <td> </td>
            <% if (PnLogCount>=4) { %>
            <td align=right><SPAN id=WorkFlowspan><a href='/discuss/ViewExchange.jsp?types=MP&sortid=<%=meetingid%>' >全部</a></span></td>
            <%}%>
          </tr>
         </tbody> 
        </table>


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
<!--
<script language=vbs>
sub onShowMDoc(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&tmpids)
         if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					docids = id1(0)
					docname = id1(1)
					sHtml = ""
					docids = Mid(docids,2,len(docids))
					document.all(inputename).value= docids
					docname = Mid(docname,2,len(docname))
					while InStr(docids,",") <> 0
						curid = Mid(docids,1,InStr(docids,",")-1)
						curname = Mid(docname,1,InStr(docname,",")-1)
						docids = Mid(docids,InStr(docids,",")+1,Len(docids))
						docname = Mid(docname,InStr(docname,",")+1,Len(docname))
						sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&docids&">"&docname&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
        end if
end sub

sub onShowTopicDoc1(topicid)
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" and id(0)<>"0" then
		window.location = "TopicDocOperation.jsp?method=add&meetingid=<%=meetingid%>&topicid=" & topicid & "&docid=" & id(0)
	end if
	end if
end sub

sub onShowReHrm(recorderid,meetingid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingReHrm.jsp?recorderid="&recorderid&"&meetingid="&meetingid)
	window.location = "ProcessMeeting.jsp?meetingid=" & meetingid
end sub

sub onShowReCrm(recorderid,meetingid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingReCrm.jsp?recorderid="&recorderid&"&meetingid="&meetingid)
	window.location = "ProcessMeeting.jsp?meetingid=" & meetingid
end sub

sub onShowReOthers(meetingid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingReOthers.jsp?meetingid="&meetingid)
	window.location = "ProcessMeeting.jsp?meetingid=" & meetingid
end sub

sub onShowDecision(meetingid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingDecision.jsp?meetingid="&meetingid,,"dialogHeight:500px;dialogwidth:700px")
	window.location = "ProcessMeeting.jsp?meetingid=" & meetingid
end sub

sub onShowTopicDate1(recorderid,meetingid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingTopicDate.jsp?recorderid="&recorderid&"&meetingid="&meetingid)
	window.location = "ProcessMeeting.jsp?meetingid=" & meetingid
end sub

sub onShowTopic(meetingid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingTopic.jsp?meetingid="&meetingid)
	window.location = "ProcessMeeting.jsp?meetingid=" & meetingid
end sub
</script>
-->
<script language=javascript>
function onShowTopic(meetingid){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingTopic.jsp?meetingid="+meetingid);
	window.location = "ProcessMeeting.jsp?meetingid=" + meetingid;
}
function onShowReOthers(meetingid){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingReOthers.jsp?meetingid="+meetingid);
	window.location = "ProcessMeeting.jsp?meetingid=" +meetingid;
}
function onShowReCrm(recorderid,meetingid){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingReCrm.jsp?recorderid="+recorderid+"&meetingid="+meetingid);
	window.location = "ProcessMeeting.jsp?meetingid="+ meetingid;
}


function onShowReHrm(recorderid,meetingid){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingReHrm.jsp?recorderid="+recorderid+"&meetingid="+meetingid);
	window.location = "ProcessMeeting.jsp?meetingid="+meetingid;
}

function onShowDecision(meetingid){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingDecision.jsp?meetingid="+meetingid);
	window.location = "ProcessMeeting.jsp?meetingid=" + meetingid;
}

function onShowTopicDate(recorderid,meetingid){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/MeetingTopicDate.jsp?recorderid="+recorderid+"&meetingid="+meetingid);
	window.location = "ProcessMeeting.jsp?meetingid="+meetingid;
}

function onShowTopicDoc(topicid){
	var results= window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp");
	if(results){
	   if(results.id!=""){
	     window.location = "TopicDocOperation.jsp?method=add&meetingid=<%=meetingid%>&topicid="+topicid+"&docid="+results.id;
	   }
	}
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
function submitData() {
window.history.back();
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

<FORM id=cancelMeeting name=cancelMeeting action="/meeting/data/MeetingOperation.jsp" method=post enctype="multipart/form-data">
	<INPUT type="hidden" name="method" value="cancelMeeting">
	<INPUT type="hidden" name="meetingId" value="<%=meetingid%>">
</FORM>
</body>
</html>

