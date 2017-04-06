<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="java.sql.Timestamp,weaver.crm.Maint.CustomerInfoComInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<%@ include file="/cowork/uploader.jsp" %>
<%!
/**
 * Charoes Huang ,June 4,2004
 */
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
String projectid=RecordSet.getString("projectid");//将项目id值取出来

String totalmember=RecordSet.getString("totalmember");
String othermembers=RecordSet.getString("othermembers");
String addressdesc=RecordSet.getString("addressdesc");
String customizeAddress = Util.null2String(RecordSet.getString("customizeAddress"));
String remindType = RecordSet.getString("remindType");
String remindBeforeStart = RecordSet.getString("remindBeforeStart");
String remindBeforeEnd = RecordSet.getString("remindBeforeEnd");
String remindTimesBeforeStart = RecordSet.getString("remindTimesBeforeStart");
String remindTimesBeforeEnd = RecordSet.getString("remindTimesBeforeEnd");
String accessorys = RecordSet.getString("accessorys");
String mainId = "";
String subId = "";
String secId = "";
String maxsize = "";
if(!meetingtype.equals(""))
{
	RecordSet.executeProc("Meeting_Type_SelectByID",meetingtype);
	if(RecordSet.next())
	{
		String category = Util.null2String(RecordSet.getString("catalogpath"));
	    if(!category.equals(""))
	    {
	    	String[] categoryArr = Util.TokenizerString2(category,",");
	    	mainId = categoryArr[0];
	    	subId = categoryArr[1];
	    	secId = categoryArr[2];
	    }
    }
	if(!secId.equals(""))
	{
		RecordSet.executeSql("select maxUploadFileSize from DocSecCategory where id="+secId);
		RecordSet.next();
	    maxsize = Util.null2String(RecordSet.getString(1));
	}
}

int customizeAddressViewtype = 0;
if("".equals(address.trim()) && "".equals(customizeAddress.trim())){
	customizeAddressViewtype = 1;
}






RecordSet.executeProc("Meeting_Type_SelectByID",meetingtype);
RecordSet.next();
String canapprover=RecordSet.getString("approver");

boolean canedit=false;
boolean cansubmit=false;
boolean candelete=false;
boolean canview=false;
boolean canapprove=false;
boolean canschedule=false;
if((userid.equals(caller) || userid.equals(contacter) || userid.equals(creater))){
	canedit=true;
	cansubmit=true;
	candelete=true;
}

/***检查是否会议室管理员****
rs.executeSql("select resourceid from hrmrolemembers where roleid=11 and resourceid="+userid) ;
if(rs.next()&& isapproved.equals("2")){
    canschedule=true;
}
if(canschedule){
	response.sendRedirect("/meeting/data/MeetingSchedule.jsp?meetingid="+meetingid) ;
	return;
}
*/
if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+Util.forHtml(meetingname);
String needfav ="1";
String needhelp ="";

int topicrows=0;
String needcheck="name,caller,contacter,begindate,begintime,enddate,endtime,totalmember";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onreturn(),_self} " ;
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
<FORM id=weaver name=weaver action="/meeting/data/MeetingOperation.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type="hidden" name="method" value="edit">
<input class=inputstyle type="hidden" name="meetingid" value="<%=meetingid%>">
<input class=inputstyle type="hidden" name="topicrows" value="0">
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
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle size=28 name="name" value="<%=Util.forHtml(meetingname)%>" onchange='checkinput("name","nameimage")'><SPAN id=nameimage></SPAN></TD>
        </TR>
         <TR style='height:1px'><TD class=Line colSpan=2></TD></TR> 
<%
//生成召集人的where子句
RecordSet.executeProc("MeetingCaller_SByMeeting",meetingtype) ;
String whereclause="where ( " ;
int ishead=0 ;
while(RecordSet.next()){
    String callertype=RecordSet.getString("callertype") ;
    String seclevel=RecordSet.getString("seclevel") ;
    String rolelevel=RecordSet.getString("rolelevel") ;
    String thisuserid=RecordSet.getString("userid") ;
    String departmentid=RecordSet.getString("departmentid") ;
    String roleid=RecordSet.getString("roleid") ;
    String foralluser=RecordSet.getString("foralluser") ;
    
    if(callertype.equals("1")){
        if(ishead==0)
            whereclause+=" HrmResource.id="+thisuserid ;
        if(ishead==1)
            whereclause+=" or HrmResource.id="+thisuserid ;
    }
    if(callertype.equals("2")){
        if(ishead==0)
            whereclause+=" HrmResource.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" )" ;
        if(ishead==1)
            whereclause+=" or HrmResource.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" )" ;
    }
    if(callertype.equals("3")){
        if(ishead==0)
            whereclause+=" HrmResource.id in (select resourceid from hrmrolemembers where roleid="+roleid+" and rolelevel >="+rolelevel+" )" ;
        if(ishead==1)
            whereclause+=" or HrmResource.id in (select resourceid from hrmrolemembers where roleid="+roleid+" and rolelevel >="+rolelevel+" )" ;
    }
    if(callertype.equals("4")){
        if(ishead==0)
            whereclause+=" HrmResource.id in (select id from hrmresource where seclevel >="+seclevel+" )" ;
        if(ishead==1)
            whereclause+=" or HrmResource.id in (select id from hrmresource where seclevel >="+seclevel+" )" ;
    }
    if(ishead==0)   ishead=1;
}
if(!whereclause.equals(""))  whereclause+=" )" ;
%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser id=SelectCaller type="button" onclick="onShowHrmCaller('Callerspan','caller','1')"></BUTTON><SPAN id=Callerspan><A href='/hrm/resource/HrmResource.jsp?id=<%=caller%>'><%=ResourceComInfo.getResourcename(caller)%></a></SPAN><input class=inputstyle id=caller type=hidden name=caller value="<%=caller%>"></TD>
        </TR>
         <TR style='height:1px'><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser id=SelectContacter type="button" onclick="onShowHrm('Contacterspan','contacter','1')"></BUTTON> <span   id=Contacterspan><A href='/hrm/resource/HrmResource.jsp?id=<%=contacter%>'><%=ResourceComInfo.getResourcename(contacter)%></a></span><INPUT class=InputStyle type=hidden name="contacter" value="<%=contacter%>"></TD>
        </TR>
         <TR style='height:1px'><TD class=Line colSpan=2></TD></TR> 
<%if(software.equals("ALL") || software.equals("CRM")){%>          
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
           <TD class=Field>
			<button class=Browser type="button" onClick="onShowProjectID(1)"></BUTTON>  <span id=projectidspan>
			 <A href='/proj/data/ViewProject.jsp?ProjID=<%=projectid%>'><%=ProjectInfoComInfo.getProjectInfoname(projectid)%></a>
			</span> <input class=inputstyle type=hidden name=projectid value="<%=projectid%>">
			</TD>
        </TR>
         <TR style='height:1px'><TD class=Line colSpan=2></TD></TR> 
<%}%>
		<!--================ 提醒方式  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) <%if ("1".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this) <%if ("2".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this) <%if ("3".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</TD>
		</TR>
		<TR style='height:1px'><TD class=Line colSpan=6></TD></TR> 
		
		<!--================ 提醒时间  ================-->
		<%
		
		int temmhour=Util.getIntValue(remindTimesBeforeStart,0)/60;
		int temptinme=Util.getIntValue(remindTimesBeforeStart,0)%60;
		int temmhourend=Util.getIntValue(remindTimesBeforeEnd,0)/60;
		int temptinmeend=Util.getIntValue(remindTimesBeforeEnd,0)%60;
		%>
		<TR id="remindTime" <% if("1".equals(remindType)) {%> style="display:none" <% } %>>
			<TD><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT id="remindBeforeStart" type="checkbox" name="remindBeforeStart" value="<%=remindBeforeStart %>" <% if("1".equals(remindBeforeStart)) { %>checked<% } %>>
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT id="remindDateBeforeStart" class="InputStyle" type="input" name="remindDateBeforeStart" onchange="checkint('remindDateBeforeStart')" size=5 value="<%= temmhour %> ">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT id="remindTimeBeforeStart" class="InputStyle" type="input" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size=5 value="<%= temptinme %>">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				<br>
				<INPUT id="remindBeforeEnd" type="checkbox" name="remindBeforeEnd" value="<%=remindBeforeEnd %>" <% if("1".equals(remindBeforeEnd)) { %>checked<% } %>>

					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT id="remindDateBeforeEnd" class="InputStyle" type="input" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="<%= temmhourend%>">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT id="remindTimeBeforeEnd" class="InputStyle" type="input" name="remindTimeBeforeEnd"  onchange="checkint('remindTimeBeforeEnd')" size=5 value="<%= temptinmeend %>">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</TD>
		</TR>
		<TR id="remindTimeLine" <% if("1".equals(remindType)) {%> style="display:none" <% } %>>
			<TD class="Line" colSpan="2"></TD>
		</TR>
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
       <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
          <TD class=Field> <BUTTON class=Calendar type="button" onclick="onShowDate(BeginDatespan,begindate)"></BUTTON> <SPAN id=BeginDatespan ><%=begindate%></SPAN> <input class=inputstyle type="hidden" name="begindate" value="<%=begindate%>"></TD>
        </TR>
        <TR style='height:1px'><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
          <TD class=Field><button class=Clock type="button" onclick="onWorkFlowShowTime(BeginTimespan,begintime,1)"></button><span id="BeginTimespan"><%=begintime%></span><input class=inputstyle type=hidden name="begintime" value="<%=begintime%>"></TD>
        </TR>
         <TR style='height:1px'><TD class=Line colSpan=2></TD></TR> 
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field> <BUTTON class=Calendar type="button" onclick="onShowDate(EndDatespan,enddate)"></BUTTON> <SPAN id=EndDatespan ><%=enddate%></SPAN> <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>"></TD>
        </TR>
         <TR style='height:1px'><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
          <TD class=Field><button class=Clock type="button" onclick="onWorkFlowShowTime(EndTimespan,endtime,1)"></button><span id="EndTimespan"><%=endtime%></span><input class=inputstyle type=hidden name="endtime" value="<%=endtime%>"></TD>
        </TR>
         <TR style='height:1px'><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectAddress type="button" onclick="onShowAddress();checkaddress(customizeAddress);checkinput3(customizeAddress, customizeAddressspan, customizeAddress.getAttribute('viewtype'))"></BUTTON> 
              <SPAN id=addressspan><%=MeetingRoomComInfo.getMeetingRoomInfoname(address)%></SPAN> 
              <input class=inputstyle id=address type=hidden id=address name=address value="<%=address%>">&nbsp;&nbsp;<a href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193,user.getLanguage())%></a>
		  </TD>
        </TR>
         <TR style='height:1px'><TD class=Line colSpan=2></TD></TR> 
         
		<!--================ 自定义会议地点 ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(20392, user.getLanguage())%></TD>
			<TD class=Field>
				<INPUT class=inputStyle size=28 id="customizeAddress"  onmousedown="omd()" viewtype=<%=customizeAddressViewtype%> name="customizeAddress" value="<%=customizeAddress%>"  onBlur="checkaddress(this);checkinput3(customizeAddress, customizeAddressspan, this.getAttribute('viewtype'))">
				<span id="customizeAddressspan"></span>
			</TD>
		</TR>
        <TR style='height:1px'><TD class=Line colSpan=6></TD></TR> 
         
        </TBODY>
	  </TABLE>
	</TD>
        </TR>
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <TBODY>
        <TR class=Title>
			<TH>
				<%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(2166,user.getLanguage())%> 
				<input class=inputstyle type=text name="totalmember" size=5 onKeyPress="ItemCount_KeyPress_Plus()" onBlur="checkcount1(this);checkinput('totalmember','totalmemberspan')" value=<%=totalmember%>>
				<%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>)
				<span id="totalmemberspan"></span>
			</TH>
		</TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1></TD></TR>
<%
//td4693
//modified by hubo,2006-07-19
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
if(RecordSet.next()){
%>
        <TR>
          <TD class=Field> 
<%RecordSet.beforFirst();while(RecordSet.next()){%>
			<input class=inputstyle type=checkbox name=hrmids01 value="<%=RecordSet.getString("memberid")%>"  onclick="countAttend()" checked><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("memberid")%>' target="_blank"><%=ResourceComInfo.getResourcename(RecordSet.getString("memberid"))%></a>&nbsp&nbsp
<%}%>		  
		  </TD>
        </TR>
     <TR style='height:1px'><TD class=Line colSpan=6></TD></TR> 
<%}%>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>:
			<button class=Browser type="button" onclick="onShowMeetingHrm('hrmids02span','hrmids02'), countAttend()"></button>
			<input class=inputstyle type=hidden name="hrmids02" value="">
			<span id="hrmids02span"></span> 
		  </TD>
        </TR>
     <TR style='height:1px'><TD class=Line colSpan=6></TD></TR> 
<%if(software.equals("ALL") || software.equals("CRM")){%>
<%
//td4693
//modified by hubo,2006-07-19
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"2");
if(RecordSet.next()){
%>
        <TR>
          <TD class=Field>
<%RecordSet.beforFirst();while(RecordSet.next()){%>
			<input class=inputstyle type=checkbox name=crmids01 value="<%=RecordSet.getString("memberid")%>" onclick="countAttend()" checked><A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("memberid")%>'><%=CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))%></a>&nbsp&nbsp
<%}%>		  
		  </TD>
        </TR>
     <TR style='height:1px'><TD class=Line colSpan=6></TD></TR>
<%}%>
<%if(isgoveproj==0){%>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(2167,user.getLanguage())%>:
			<button class=Browser type="button" onclick="onShowMCrm('crmids02span','crmids02'), countAttend()"></button>
			<%}%>
			<input class=inputstyle type=hidden name="crmids02" value="">
			<%if(isgoveproj==0){%>
			<span id="crmids02span"></span> 
		  </TD>
        </TR>
		<%}%>
<%}%>
     <TR style='height:1px'><TD class=Line colSpan=6></TD></TR> 
        <tr>
          <td class=field><%=SystemEnv.getHtmlLabelName(2168,user.getLanguage())%>: 
          <input class=inputstyle type=text name="othermembers" size=70 value="<%=Util.toScreenToEdit(othermembers,user.getLanguage())%>">
          <td>
        <tr>
     <TR style='height:1px'><TD class=Line colSpan=6></TD></TR> 
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(2169,user.getLanguage())%></TH>
            <Td align=right>
				<A href="javascript:addRow();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
				<A href="javascript:if(isdel()){deleteRow1();}"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>	
			</Td>
          </TR>
           <tr><td colspan=2>
          <table class=ListStyle cellspacing=1>
            <COLGROUP>
    		<COL width="44%">
    		<COL width="20%">
    		<COL width="15%">
    		<COL width="15%">
    		<COL width="6%">
    		<tr class=header>
    		   <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
    		   <td><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
				<%if(isgoveproj==0){%>
    		   <td><%if(software.equals("ALL") || software.equals("CRM")){%><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%><%}%>&nbsp</td>
    		   <td><%if(software.equals("ALL") || software.equals("CRM")){%><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%><%}%>&nbsp</td>
    		   <%}else{%>
			   <td>&nbsp</td>
    		   <td>&nbsp</td>
			   <%}%>
			   <td><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></td>
    		</tr>
          </table>
        </td></tr>
        <TR>
          <TD colspan=2> 
	  <TABLE class=ViewForm cellpadding=1  cols=6 id="oTable">
      	<COLGROUP>
      	<COL width="4%">
		<COL width="40%">
		<COL width="20%">
		<COL width="15%">
		<COL width="15%">
		<COL width="6%">
        <TBODY>
<%
RecordSet.executeProc("Meeting_Topic_SelectAll",meetingid);
while(RecordSet.next()){
%>
		<tr>
			<td class=Field><input class=inputstyle type='checkbox' name='check_node' value='0'><input class=inputstyle type='hidden' name='recordsetid_<%=topicrows%>' value='<%=RecordSet.getString("id")%>'></td>
			<td class=Field style="word-break:break-all"><input class=inputstyle type='input' size="55"  name='topicsubject_<%=topicrows%>' value="<%=RecordSet.getString("subject")%>"></td>
			<td class=Field><button class=Browser type="button" onClick=onShowMHrm('topichrmids_<%=topicrows%>span','topichrmids_<%=topicrows%>')></button> <span class=InputStyle id=topichrmids_<%=topicrows%>span>
<%
	ArrayList arrayhrmids = Util.TokenizerString(RecordSet.getString("hrmids"),",");
	for(int i=0;i<arrayhrmids.size();i++){
%>
			<A href='/hrm/resource/HrmResource.jsp?id=<%=""+arrayhrmids.get(i)%>'><%=ResourceComInfo.getResourcename(""+arrayhrmids.get(i))%></a>&nbsp
<%	
	}
%>				
			</span><input class=inputstyle type='hidden' name='topichrmids_<%=topicrows%>' id='topichrmids_<%=topicrows%>' value="<%=RecordSet.getString("hrmids")%>"></td>
			<%if(isgoveproj==0){%>
			<td class=Field><%if(software.equals("ALL") || software.equals("CRM")){%><button class=browser type="button" onclick=onShowMProj('topicprojid_<%=topicrows%>span','topicprojid_<%=topicrows%>')></button>
    			<span id="topicprojid_<%=topicrows%>span"><a href="/proj/data/ViewProject.jsp?ProjID=<%=RecordSet.getString("projid")%>"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(RecordSet.getString("projid")),user.getLanguage())%></a></span>
    			<input class=inputstyle type='hidden' name='topicprojid_<%=topicrows%>' id='topicprojid_<%=topicrows%>' value="<%=RecordSet.getString("projid")%>"><%}%>
			</td>
			<td class=Field><%if(software.equals("ALL") || software.equals("CRM")){%><button class=browser type="button" onclick=onShowMCrm('topiccrmid_<%=topicrows%>span','topiccrmid_<%=topicrows%>')></button>
    			<span id="topiccrmid_<%=topicrows%>span">
					  <%=getCustomerLinkStr(CustomerInfoComInfo,RecordSet.getString("crmids"))%>
				</span>
    			<input class=inputstyle type='hidden' name='topiccrmid_<%=topicrows%>' id='topiccrmid_<%=topicrows%>' value="<%=RecordSet.getString("crmids")%>"><%}%>
			</td>
			<%}else{%>
			<td class=Field></td>
			<td class=Field></td>
			<%}%>
			<td class=Field><%if(RecordSet.getString("isopen").equals("1")){%><input class=inputstyle type=checkbox  checked  name='topicopen_<%=topicrows%>' value='1'><%}else{%><input class=inputstyle type=checkbox  name='topicopen_<%=topicrows%>' value='1'><%}%><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></td>

		</tr>
<%
topicrows = topicrows +1;
}
%>
        </TBODY>
	  </TABLE>		  
		  
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>
<%
int servicerows=0;
RecordSet.executeProc("Meeting_Service_SelectAll",meetingtype);
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
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colspan=2></TD></TR>
<%
while(RecordSet.next()){
    String tmpservicename=RecordSet.getString("name") ;
    String tmpsql="select * from Meeting_Service2 where meetingid="+ meetingid +" and name='"+Util.fromScreen2(tmpservicename,user.getLanguage())+"'";
	String tmpservicedesc= "" ;
	rs.executeSql(tmpsql) ;
    if(rs.next())   
        tmpservicedesc=rs.getString("desc_n");
    ArrayList serviceitems2=Util.TokenizerString(tmpservicedesc,",");
%>
        <TR>
		  <td><%=RecordSet.getString("name")%></td>
          <TD> 
		  <input class=inputstyle type=hidden name=servicename_<%=servicerows%> value="<%=RecordSet.getString("name")%>">
		  <input class=inputstyle type=hidden name=servicehrm_<%=servicerows%> value="<%=RecordSet.getString("hrmid")%>">
	  <TABLE class=ViewForm>
        <TBODY>
        <TR>
          <TD class=Field>
<%
	int pos=0 ;
	ArrayList serviceitems = Util.TokenizerString(RecordSet.getString("desc_n"),",");
	for(int i=0;i<serviceitems.size();i++){
	    String tmpserviceitem = (String) serviceitems.get(i) ;
	    String checked="" ;
	    //String id = RecordSet.getString("id");
	    if(tmpservicedesc.indexOf(tmpserviceitem)!=-1){
	        checked="checked" ;
	        pos++;
	    }
%>
		  <input class=inputstyle type=checkbox name=serviceitem_<%=servicerows%> value="<%=tmpserviceitem%>" <%=checked%> ><%=serviceitems.get(i)%>&nbsp&nbsp
<%
	}
	String tmpserviceother="" ;
	if(pos<serviceitems2.size())
	    tmpserviceother=(String) serviceitems2.get(pos);
	    String value = tmpserviceother;
		//字符转换 by lihaibo for td19947  
	    if (value == null || value.length() == 0) {
            value = "";
        }
        StringBuffer result = null;
        String filtered = null;
        for(int i = 0; i < value.length(); i++) {
            filtered = null;
            switch (value.charAt(i)) {
                case '<':
                    filtered = "<";
                    break;
                case '>':
                    filtered = ">";
                    break;
                case '&':
                    filtered = "&";
                    break;
                case '"':
                    filtered = "&quot";
                    break;
                case '\'':
                    filtered = "'";
                    break;
            }

            if (result == null) {
                if (filtered != null) {
                    result = new StringBuffer(value.length() + 50);
                    if (i > 0) {
                        result.append(value.substring(0, i));
                    }
                    result.append(filtered);
                }
            } else {
                if (filtered == null) {
                    result.append(value.charAt(i));
                } else {
                    result.append(filtered);
                }
            }
        }
        value = (result == null ? value : result.toString());
%>
		  </TD>
        </TR>
        <TR>
          <TD class=Field><%if(!RecordSet.getString("desc_n").equals("")){%><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%>：<%}%><input class=inputstyle name=serviceother_<%=servicerows%> maxlength="255" onchange="checkLength()"  style="width:90%" value="<%=Util.toScreenToEdit(value,user.getLanguage())%>"></TD>
        </TR>
        </TBODY>
	  </TABLE>		  
		  
		  </TD>
        </TR>
<%
	servicerows+=1;
}
%>
        </TBODY>
	  </TABLE>
<%}%>
	  <input class=inputstyle type="hidden" name="servicerows" value="<%=servicerows%>">
	  <TABLE id=AccessoryTable class="ViewForm" style="margin-top:10px;">
	  	<COLGROUP>
		<COL width="15%">
  		<COL width="85%">
	  	<TR class=title>
          <TH colspan=2><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TH><!-- 相关附件 -->
        </TR>
        <TR class=Spacing style="height: 1px">
          	<TD class=line1 colspan=2></TD>
        </TR>
          <%
          	String display = "0";
    		if(!accessorys.equals("")) {
    			display = "1";
	            String sql="select id,docsubject,accessorycount from docdetail where id in ("+accessorys+") order by id asc";
	            rs.executeSql(sql);
	            int linknum=-1;
	            while(rs.next()){
	              linknum++;
	              String showid = Util.null2String(rs.getString(1)) ;
	              String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
	              int accessoryCount=rs.getInt(3);
	
	              DocImageManager.resetParameter();
	              DocImageManager.setDocid(Integer.parseInt(showid));
	              DocImageManager.selectDocImageInfo();
	
	              String docImagefileid = "";
	              long docImagefileSize = 0;
	              String docImagefilename = "";
	              String fileExtendName = "";
	              int versionId = 0;
	
	              if(DocImageManager.next()){
	                //DocImageManager会得到doc第一个附件的最新版本
	                docImagefileid = DocImageManager.getImagefileid();
	                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
	                docImagefilename = DocImageManager.getImagefilename();
	                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
	                versionId = DocImageManager.getVersionId();
	              }
	              if(accessoryCount>1){
	              	fileExtendName ="htm";
	              }

              	  String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              %>
	          <tr>
	            <input type=hidden name="field_del_<%=linknum%>" value="0" >
	            <td></td>
	            <td class=field>
	              <%=imgSrc%>
	              <%
	              if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx")))
	              {
	              %>
	                <a style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
	              <%
	              }
	              else
	              {
	              %>
	                <a style="cursor:hand" onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp;
	              <%
	              }
	              %>
	              <input type=hidden name="field_id_<%=linknum%>" value=<%=showid%>>
                  <BUTTON class=btn type="button" accessKey=1  onclick='onChangeSharetype("span_id_<%=linknum%>","field_del_<%=linknum%>","<%=0%>")'><U><%=linknum%></U>-删除
	                  <span id="span_id_<%=linknum%>" name="span_id_<%=linknum%>" style="visibility:hidden">
	                    <B><FONT COLOR="#FF0033">√</FONT></B>
	                  <span>
                  </BUTTON>
	            </td>
	          </tr>
	          <TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>
	          <%
	          }
	          %>
             <input type=hidden name="field_idnum" value=<%=linknum+1%>>
             <input type=hidden name="field_idnum_1" value=<%=linknum+1%>>
          <%}%> 
          <TR>
            <td></td>
             <td class=field colspan=4 id="divAccessory" name="divAccessory">
            <%if(!"".equals(secId)){ %>
            	      <input type=hidden id="accessory_num" name="accessory_num" value="1">
            	   <div id="uploadDiv" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
		     <%}else{%>
		        <font color=red><%=SystemEnv.getHtmlLabelName(20476,user.getLanguage())%></font>
		     <%}%>
    		</td>
          </TR>
          <TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>
	  </TABLE>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=Title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colspan=2></TD></TR>
        <TR>
		  <td style="width:100%;">
		  
		  <textarea class=inputstyle rows=5 style="width:100%;" name="desc"><%=Util.StringReplace(desc,"<br>","\n")%></textarea>
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>
</FORM>

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

<script language="JavaScript" src="/js/addRowBg.js" >   
</script>  
<script language="JavaScript">  
  //绑定附件上传
   if(jQuery("#uploadDiv").length>0)
     bindUploaderDiv(jQuery("#uploadDiv"),"relatedacc"); 


function checkLength(){
    var items = <%=servicerows%>;
    var tmpvalue;
    for(var i=0;i<items;i++){
        tmpvalue = document.getElementById("serviceother_"+i).value;
        if(realLength(tmpvalue)>255){
		alert("<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)");
		while(true){
			tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);
			if(realLength(tmpvalue)<=255){
				document.getElementById("serviceother_"+i).value = tmpvalue;
				return;
			}
		}
		break;
	   }
    }
}
</script>
<script language=javascript>
function onChangeSharetype(delspan,delid,ismand){
fieldid=delid.substr(0,delid.indexOf("_"));
fieldidnum=fieldid+"_idnum_1";
fieldidspan=fieldid+"span";
fieldidspans=fieldid+"spans";
fieldid=fieldid+"_1";
   if($GetEle(delspan).style.visibility=='visible'){
     $GetEle(delspan).style.visibility='hidden';
     $GetEle(delid).value='0';
  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
   }else{
     $GetEle(delspan).style.visibility='visible';
     $GetEle(delid).value='1';
  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
   }
 }
function opendoc(showid,versionid,docImagefileid)
{
	openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&from=accessory&wpflag=workplan&meetingid=<%=meetingid%>");
}
function opendoc1(showid)
{
	openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&wpflag=workplan&meetingid=<%=meetingid%>");
}
accessorynum = 2 ;
function addannexRow(){
	var nrewardTable = document.getElementById("AccessoryTable");
	var maxsize = document.getElementById("maxsize").value;
	oRow = nrewardTable.insertRow(-1);
	oRow.height=20;
	for(j=0; j<2; j++) {
		oCell = oRow.insertCell(-1);
		switch(j) {
    		case 0:
				var sHtml = "";
				oCell.innerHTML = sHtml;
				break;
	        case 1:
	       		oCell.className = "field";
	            var sHtml = "<input class=InputStyle  type=file name='accessory"+accessorynum+"' onchange='accesoryChanage(this)'>(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:"+maxsize+"M)";
				oCell.innerHTML = sHtml;
				break;
		}
	}
	document.getElementById("accessory_num").value = accessorynum ;
	accessorynum = accessorynum*1 +1;
	oRow1 = nrewardTable.insertRow(-1);
	oCell1 = oRow1.insertCell(-1);
    oCell1.colSpan = 2
    oCell1.className = "Line";
    $(oRow1).css("height","1px");
}
function accesoryChanage1(obj){
	var secId = '<%=secId%>';
	if(secId=="")
	{
		alert("<%=SystemEnv.getHtmlLabelName(24429,user.getLanguage())%>!");
		obj.value = "";
		createAndRemoveObj(obj);
		return;
	}
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        try{
        	fileLenth=parseInt(obj.files[0].size);
        }catch (e) {
        	if(e.message=="Type mismatch")
                alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
                else
                alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
                createAndRemoveObj(obj);
                return  ;
		}
    	
    }
  
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    //var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    var fileLenthByK =  fileLenth/1024;
		var fileLenthByM =  fileLenthByK/1024;
	
		var fileLenthName;
		if(fileLenthByM>=0.1){
			fileLenthName=fileLenthByM.toFixed(1)+"M";
		}else if(fileLenthByK>=0.1){
			fileLenthName=fileLenthByK.toFixed(1)+"K";
		}else{
			fileLenthName=fileLenth+"B";
		}
		maxsize = document.getElementById("maxsize").value;
    if (fileLenthByM>maxsize) {
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+",<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxsize+"M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>!");
        createAndRemoveObj(obj);
    }
}
function createAndRemoveObj(obj){
    objName = obj.name;
    var  newObj = document.createElement("input");
    newObj.name=objName;
    newObj.className="InputStyle";
    newObj.type="file";
    newObj.onchange=function(){accesoryChanage(this);};

    var objParentNode = obj.parentNode;
    var objNextNode = obj.nextSibling;
    obj.removeNode();
    objParentNode.insertBefore(newObj,objNextNode);
}
function countAttend()
{
	var count = 0;
	var pageArray = new Array();
	var countArray = new Array();
	var finalArray = new Array();
	var hascheckhrm = false;
	var hascheckcrm = false;
	
	if("" != $GetEle("hrmids02").value)
	{
		pageArray = $GetEle("hrmids02").value.split(",");
		countArray = countArray.concat(pageArray);
	}
	pageArray = document.getElementsByName("hrmids01");
	for(var i = 0; i < pageArray.length; i++)
	{
		if(pageArray[i].checked)
		{
			hascheckhrm = true;
			countArray.push(pageArray[i].value);
		}
	}
	for(var i = 0; i < countArray.length; i++)
	{
		var flag = true;
		var countString = countArray[i];
		for(var j = 0; j < finalArray.length; j++)
		{
			var finalString = finalArray[j];
			if(countString == finalString)
			{
				flag = false;
				break;
			}

		}
		if(flag)
		{
			finalArray.push(countString);
		}
	}
	count += finalArray.length;
	
	pageArray = new Array();
	countArray = new Array();
	finalArray = new Array();
	if("" != $GetEle("crmids02").value)
	{
		pageArray = $GetEle("crmids02").value.split(",");
		countArray = countArray.concat(pageArray);
	}
	pageArray = document.getElementsByName("crmids01");
	for(var i = 0; i < pageArray.length; i++)
	{
		if(pageArray[i].checked)
		{
			hascheckcrm = true;
			countArray.push(pageArray[i].value);
		}
	}
	if(hascheckhrm==true || hascheckcrm==true || ($GetEle("hrmids02").value!="" && $GetEle("hrmids02").value.length>0) || ($GetEle("crmids02").value!="" && $GetEle("crmids02").value.length>0)){
		if($GetEle("hrmids02").value==null || $GetEle("hrmids02").value==""){
			$GetEle("hrmids02span").innerHTML = "";
		}
	}else{
		$GetEle("hrmids02span").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	}
	for(var i = 0; i < countArray.length; i++)
	{
		var flag = true;
		var countString = countArray[i];
		for(var j = 0; j < finalArray.length; j++)
		{
			var finalString = finalArray[j];
			if(countString == finalString)
			{
				flag = false;
				break;
			}

		}
		if(flag)
		{
			finalArray.push(countString);
		}
	}
	count += finalArray.length;

	$GetEle("totalmemberspan").innerHTML = "";
	$GetEle("totalmember").value = count;
}

function onreturn() {
 window.history.back();
}
function submitData() {
 if(isdel()){
 location.href="/meeting/data/MeetingOperation.jsp?meetingid=<%=meetingid%>&method=delete"}
 setRemindData();
 weaver.submit();
}

function setRemindData()
{
	var remindBeforeStart = document.getElementById("remindBeforeStart");
	var remindDateBeforeStart = document.getElementById("remindDateBeforeStart");
	var remindTimeBeforeStart = document.getElementById("remindTimeBeforeStart");
	
	var remindBeforeEnd = document.getElementById("remindBeforeEnd");
	var remindDateBeforeEnd = document.getElementById("remindDateBeforeEnd");
	var remindTimeBeforeEnd = document.getElementById("remindTimeBeforeEnd");
	if(remindBeforeStart&&remindBeforeStart.checked)
	{
		remindBeforeStart.value = 1;
	}
	else if(remindBeforeStart&&!remindBeforeStart.checked)
	{
		remindBeforeStart.value = 0;
		if(remindDateBeforeStart)
		{
			remindDateBeforeStart.value=0;
		}
		if(remindTimeBeforeStart)
		{
			remindTimeBeforeStart.value=10;
		}
	}
	if(remindBeforeEnd&&remindBeforeEnd.checked)
	{
		remindBeforeEnd.value = 1;
	}
	else if(remindBeforeEnd&&!remindBeforeEnd.checked)
	{
		remindBeforeEnd.value = 0;
		if(remindDateBeforeEnd)
		{
			remindDateBeforeEnd.value=0;
		}
		if(remindTimeBeforeEnd)
		{
			remindTimeBeforeEnd.value=10;
		}
	}	
}
rowindex = "<%=topicrows%>";
function addRow()
{
	ncol = oTable.attributes.cols.nodeValue;
	rowColor = getRowBg();
	oRow = oTable.insertRow(-1);
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		oCell.style.wordBreak = "break-all";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_node' value='0'>"; 
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' maxlength='200' style=width:99%  name='topicsubject_"+rowindex+"'>";
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv);
				break;			
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button type=\"button\" class=Browser onClick=onShowMHrm('topichrmids_"+rowindex+"span','topichrmids_"+rowindex+"')></button> " + 
        					"<span class=inputStyle id=topichrmids_"+rowindex+"span></span> "+
        					"<input class=inputstyle type='hidden' name='topichrmids_"+rowindex+"' id='topichrmids_"+rowindex+"'>";
        					$(oDiv).html(sHtml);
        					oCell.appendChild(oDiv); 
				break;
            case 3: 
				var oDiv = document.createElement("div"); 
				<%if(isgoveproj==0){%>
				var sHtml = "<button type=\"button\" class=Browser onClick=onShowMProj('topicprojid_"+rowindex+"span','topicprojid_"+rowindex+"')></button> " + 
        		<%}else{%>
				var sHtml = " " + 
				<%}%>
				"<span class=inputStyle id=topicprojid_"+rowindex+"span></span> "+
        					"<input class=inputstyle type='hidden' name='topicprojid_"+rowindex+"' id='topicprojid_"+rowindex+"'>";
<%if(software.equals("ALL") || software.equals("CRM")){%>
$(oDiv).html(sHtml);  
<%}%>
oCell.appendChild(oDiv);  
				break;
		    case 4: 
				var oDiv = document.createElement("div"); 
				<%if(isgoveproj==0){%>
				var sHtml = "<button type=\"button\" class=Browser onClick=onShowMCrm('topiccrmid_"+rowindex+"span','topiccrmid_"+rowindex+"')></button> " + 
        		<%}else{%>
					var sHtml = " " + 
					<%}%>
				"<span class=inputStyle id=topiccrmid_"+rowindex+"span></span> "+
        					"<input class=inputstyle type='hidden' name='topiccrmid_"+rowindex+"' id='topiccrmid_"+rowindex+"'>";
<%if(software.equals("ALL") || software.equals("CRM")){%>
$(oDiv).html(sHtml);  
<%}%>
oCell.appendChild(oDiv);  
				break;
			case 5: 
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='topicopen_"+rowindex+"' value='1'>公开"; //文字
				$(oDiv).html(sHtml);
				oCell.appendChild(oDiv); 
				break;
	
		}
	}
	rowindex = rowindex*1 +1;
	
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	
	}	
}	

function doSave(obj){
	if(check_form(document.weaver,'<%=needcheck%>')&&checkAddress()&&checkDateValidity(weaver.begindate.value,weaver.begintime.value,weaver.enddate.value,weaver.endtime.value,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")){
			if(($GetEle("hrmids02").value!="" && $GetEle("hrmids02").value.length>0) || ($GetEle("crmids02").value!="" && $GetEle("crmids02").value.length>0) || checkHrm() || checkCrm()){
	        obj.disabled = true;
			document.weaver.topicrows.value=rowindex;
			setRemindData();
			//document.weaver.submit();
			 doUpload();
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		}
	}
}

function doSubmit(obj){
    if(check_form(document.weaver,'<%=needcheck%>')&&checkAddress()&&checkDateValidity(weaver.begindate.value,weaver.begintime.value,weaver.enddate.value,weaver.endtime.value,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")){
	    	if(($GetEle("hrmids02").value!="" && $GetEle("hrmids02").value.length>0) || ($GetEle("crmids02").value!="" && $GetEle("crmids02").value.length>0) || checkHrm() || checkCrm()){
		        obj.disabled = true;
		        document.weaver.method.value = "editSubmit";
				document.weaver.topicrows.value=rowindex;
				setRemindData();
				//document.weaver.submit();
				 doUpload();
	    }else{
	    	alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
	    }
	    }
}
function doUpload(){
	var oUploader=window[jQuery("#uploadDiv").attr("oUploaderIndex")];
    try{
       if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
         doSaveAfterAccUpload();  //保存协作
       else 
     	 oUploader.startUpload();
	}catch(e){
	     doSaveAfterAccUpload(); //保存协作
	 }
}

function doSaveAfterAccUpload(){
	document.weaver.submit();
}




function checkHrm(){
	var hashrmchecked = new Array();
	var hashrmid = false;
	hashrmchecked = document.getElementsByName("hrmids01");
	for(var i = 0; i < hashrmchecked.length; i++)
	{
		if(hashrmchecked[i].checked)
		{
			hashrmid = true;
		}
	}
	return hashrmid;
}
function checkCrm(){
	var hascrmchecked = new Array();
	var hascrmid = false;
	hascrmchecked = document.getElementsByName("crmids01");
	for(var i = 0; i < hascrmchecked.length; i++)
	{
		if(hascrmchecked[i].checked)
		{
			hascrmid = true;
		}
	}
	return hascrmid;
}
function checkDateValidity(begindate,begintime,enddate,endtime,errormsg){
	var isValid = true;
	if(compareDate(begindate,begintime,enddate,endtime) == 1){
		alert(errormsg);
		isValid = false;
	}
	return isValid;
}

function checkAddress()
{
	if(("" == $GetEle("address").value || 0 == $GetEle("address").value) && "" == $GetEle("customizeAddress").value)
	{
		alert("<%=SystemEnv.getHtmlLabelName(20393, user.getLanguage())%>");
		return false;
	}
	
	return true;
}

/*Check Date */
function compareDate(date1,time1,date2,time2){

	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0] + " " +time1;
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0] + " " +time2;

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}

function ItemCount_KeyPress_Plus()
{
	if(!(window.event.keyCode >= 48 && window.event.keyCode <= 57))
	{
		window.event.keyCode = 0;
	}
}
</script>
<script language=vbs>










</script>
</body>
<script language="javascript">
function onShowHrmCaller(spanname,inputename,needinput){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere=<%=whereclause%>")
	if (data){
		if (data.id!=""){
			$GetEle(spanname).innerHTML= "<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>"
			$GetEle(inputename).value=data.id
		}else{ 
			if (needinput == "1"){
				$GetEle(spanname).innerHTML= "<IMG src='/images/BacoError.gif' align=absMiddle>"
			}else{
				$GetEle(spanname).innerHTML= ""
			}
			$GetEle(inputename).value=""
		}
	}
}

function onShowHrm(spanname,inputename,needinput){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data){
		if (data.id!=""){
			$GetEle(spanname).innerHTML= "<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>"
			$GetEle(inputename).value=data.id
		}else{ 
			if (needinput =="1"){
				$GetEle(spanname).innerHTML= "<IMG src='/images/BacoError.gif' align=absMiddle>"
			}else{
				$GetEle(spanname).innerHTML= ""
			}
			$GetEle(inputename).value=""
		}
	}
}
function onShowMProj(spanname,inputname){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (data){
		if (data.id!=""){
			$GetEle(spanname).innerHTML = "<A href='/proj/data/ViewProject.jsp?ProjID="+data.id+"'>"+data.name+"</A>"
			$GetEle(inputname).value=data.id
		}else{ 
			$GetEle(spanname).innerHTML =""
			$GetEle(inputname).value="0"
		}
	}
}
function onShowMeetingHrm(spanname,inputename){
	tmpids = $GetEle(inputename).value
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids)
        if ((tmpids+data.id).lenght > 2000){ //500为表结构文档字段的长度
	        alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>")
        }else if(data.id!=""){
        	resourceids = data.id
			resourcename = data.name
			var sHtml = ""
			
			resourceids = resourceids.substring(1);
			$GetEle(inputename).value= resourceids
			resourcename = resourcename.substring(1);
			 var ids = resourceids.split(",");
			  var  names =resourcename.split(",");
			  for( var i=0;i<ids.length;i++){
			      if(ids[i]!=""){
			       sHtml = sHtml+"<a href='/hrm/resource/HrmResource.jsp?id="+ids[i]+"' target=_blank >"+names[i]+"</a>&nbsp";
			      }
			 }
			
			$GetEle(spanname).innerHTML = sHtml
			
        }else{
			$GetEle(spanname).innerHTML =""
			$GetEle(inputename).value=""
        }
}


function onShowMHrm(spanname,inputename){
    tmpids = $GetEle(inputename).value
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids)
	if (data){
		if(data.id!=""){
			resourceids = data.id
			resourcename = data.name
			var sHtml = ""
			
			resourceids = resourceids.substring(1);
			$GetEle(inputename).value= resourceids
			resourcename = resourcename.substring(1);
			  var ids = resourceids.split(",");
			  var  names =resourcename.split(",");
			  for( var i=0;i<ids.length;i++){
			      if(ids[i]!=""){
			       sHtml = sHtml+"<a href='/hrm/resource/HrmResource.jsp?id="+ids[i]+"'  >"+names[i]+"</a>&nbsp";
			      }
			 }
			$GetEle(spanname).innerHTML = sHtml
			
		}else{
			$GetEle(spanname).innerHTML =""
			$GetEle(inputename).value=""
		}
	}
}
function onShowMCrm(spanname,inputename){
			tmpids = $GetEle(inputename).value;
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+tmpids);
		    if(datas){
		        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
			         	alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
						return;
				 }else if(datas.id!=""){
					resourceids = datas.id.substr(1);
					resourcename =datas.name.substr(1);
					sHtml = "";
					$GetEle(inputename).value= resourceids;
					//$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr(1):resourceids;
					resourceids =resourceids.split(",");
					resourcename =resourcename.split(",");
					for(var i=0;i<resourceids.length;i++){
						if(resourceids[i]&&resourcename[i]){
							sHtml = sHtml+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+resourceids[i]+">"+resourcename[i]+"</a>&nbsp"
						}
					}
					$("#"+spanname).html(sHtml);
		        }else{
					$GetEle(inputename).value="";
					$($GetEle(spanname)).html("");
		        }
		    }
}

function onShowAddress(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp")
	if (data){
		if (data.id!=0){
			addressspan.innerHTML ="<A href='/meeting/Maint/MeetingRoom.jsp?'>"+data.name+"</A>"
			weaver.address.value=data.id
			customizeAddressspan.innerHTML = ""
		}else{
			addressspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			weaver.address.value=""
			customizeAddressspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		}
	}
}
function onShowProjectID(objval){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (data) {
		if(data.id!=""){
			projectidspan.innerHTML = "<A href='/proj/data/ViewProject.jsp?ProjID="+data.id+"'>"+data.name+"</A>"
			weaver.projectid.value=data.id
		}else {
			if (objval=="2"){
				projectidspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			}else{
				projectidspan.innerHTML =""
			}
			weaver.projectid.value="0"
		}
	}
}
  function omd(){
	  var addressspan = document.getElementById("addressspan").innerHTML;
      if(document.getElementById("addressspan").innerHTML!="" && addressspan.indexOf("BacoError")<=0 && document.weaver.customizeAddress.value==""){
          alert("<%=SystemEnv.getHtmlLabelName(20889, user.getLanguage())%>");
	}
}
function checkaddress(obj){
	var addressspan = document.getElementById("addressspan").innerHTML;
    if(document.getElementById("addressspan").innerHTML!="" && addressspan.indexOf("BacoError")<=0 && document.weaver.customizeAddress.value==""){
        document.getElementById("customizeAddress").setAttribute('viewtype',0);
	}else{
		if((document.getElementById("addressspan").innerHTML!="" && addressspan.indexOf("BacoError")>0) || document.getElementById("addressspan").innerHTML==""){
			document.getElementById("customizeAddress").setAttribute('viewtype',1);
		}
	}
	if(obj.value!=""){
		if(addressspan.indexOf("BacoError") > 0){
			document.getElementById("addressspan").innerHTML = "";
		}
	}else{
		if(addressspan=="" || addressspan.indexOf("BacoError")>0){
			document.getElementById("addressspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		}
	}
}
function showRemindTime(obj)
{
	if("1" == obj.value)
	{
		$GetEle("remindTime").style.display = "none";
		$GetEle("remindTimeLine").style.display = "none";
	}
	else
	{
		$GetEle("remindTime").style.display = "";
		$GetEle("remindTimeLine").style.display = "";
	}
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</html>