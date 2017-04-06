<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<%@ include file="/cowork/uploader.jsp" %>
<%
//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
char flag=Util.getSeparator() ;
String ProcPara = "";
String meetingname = "";
String meetingtype = Util.null2String(request.getParameter("meetingtype"));
String roomid = Util.null2String(request.getParameter("roomid"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String starttime = Util.null2String(request.getParameter("starttime"));
String endtime = Util.null2String(request.getParameter("endtime"));
String roomname = "";
String getroomsql = "select * from MeetingRoom where id=";
if (null != roomid && !"".equals(roomid))
{
	RecordSet.executeSql(getroomsql + roomid);
	while (RecordSet.next())
	{
		roomname = RecordSet.getString("name");
	}
}
RecordSet.execute("select * from Meeting_Type where id = "+meetingtype);
if(RecordSet.next()){
    meetingname = Util.null2String(RecordSet.getString("name"));
}
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
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</HEAD>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
String needfav ="1";
String needhelp ="";
int topicrows=0;
String needcheck="name,caller,contacter,begindate,begintime,enddate,endtime,totalmember";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self} " ;
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
<input class=inputstyle type="hidden" name="method" value="add">
<input class=inputstyle type="hidden" name="meetingtype" value="<%=meetingtype%>">
<input class=inputstyle type="hidden" name="topicrows" value="0">
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
        <TR class=title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputStyle size=28 name="name" value="<%=Util.forHtml(meetingname)%>" onchange='checkinput("name","nameimage")'><SPAN id=nameimage></SPAN></TD>
        </TR>
		<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
<%
//生成召集人的where子句
RecordSet.executeProc("MeetingCaller_SByMeeting",meetingtype) ;
String whereclause="where ( " ;
int ishead=0 ;
int isset=0;//是否有设置召集人标识，0没有，1有
while(RecordSet.next()){
    String callertype=RecordSet.getString("callertype") ;
    String seclevel=RecordSet.getString("seclevel") ;
    String rolelevel=RecordSet.getString("rolelevel") ;
    String thisuserid=RecordSet.getString("userid") ;
    String departmentid=RecordSet.getString("departmentid") ;
    String roleid=RecordSet.getString("roleid") ;
    String foralluser=RecordSet.getString("foralluser") ;
    isset=1;

    if(callertype.equals("1")){
        if(ishead==0)
            whereclause+=" t1.id="+thisuserid ;
        if(ishead==1)
            whereclause+=" or t1.id="+thisuserid ;
    }
    if(callertype.equals("2")){
        if(ishead==0)
            whereclause+=" t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" )" ;
        if(ishead==1)
            whereclause+=" or t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" )" ;
    }
    if(callertype.equals("3")){
        if(ishead==0)
            whereclause+=" t1.id in (select resourceid from hrmrolemembers where roleid="+roleid+" and rolelevel >="+rolelevel+" )" ;
        if(ishead==1)
            whereclause+=" or t1.id in (select resourceid from hrmrolemembers where roleid="+roleid+" and rolelevel >="+rolelevel+" )" ;
    }
    if(callertype.equals("4")){
        if(ishead==0)
            whereclause+=" t1.id in (select id from hrmresource where seclevel >="+seclevel+" )" ;
        if(ishead==1)
            whereclause+=" or t1.id in (select id from hrmresource where seclevel >="+seclevel+" )" ;
    }
    if(ishead==0)   ishead=1;
}
if(!whereclause.equals(""))  whereclause+=" )" ;

%>

    <%if(isset==0){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TD>
          <TD class=Field><button type="button" class=Browser id=SelectCaller onclick="onShowHrmCaller('Callerspan','caller','1')"></BUTTON><SPAN id=Callerspan> <IMG src='/images/BacoError.gif' align=absMiddle></SPAN><INPUT id="caller" type="hidden" name="caller"></TD>
        </TR>
   <% }else{%>

  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TD>        
	  <TD class=Field><button type="button" class=Browser onClick="onShowCaller()"></button>
      <SPAN id=Callerspan><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
      <INPUT id="caller" type="hidden" name="caller"></TD>	
  </TR>
    <%}%>


        <TR style="height:1px;"><TD class=Line colSpan=6 ></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field><button type="button" class=Browser id=SelectContacter onclick="onShowHrm('Contacterspan','contacter','1')"></BUTTON> <span   id=Contacterspan><%=user.getUsername()%></span><INPUT class=inputStyle type=hidden name="contacter" value="<%=user.getUID()%>"></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
		<%if(isgoveproj==0){%>
<%if(software.equals("ALL") || software.equals("CRM")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
          <TD class=Field style="word-break:break-all;"> <button type="button" class=Browser onClick="onShowProjectID(1)"></button></BUTTON>  <span id=projectidspan></span> <input class=inputstyle type=hidden  name=projectid value=></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
<%}%>
<%}%>
		<!--================ 提醒方式  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) checked><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</TD>
		</TR>
		<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
		
		<!--================ 提醒时间  ================-->
		<TR id="remindTime" style="display:none">
			<TD><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT id="remindBeforeStart" type="checkbox" name="remindBeforeStart" value="0">
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT id="remindDateBeforeStart" class="InputStyle" type="input" name="remindDateBeforeStart" onchange="checkint('remindDateBeforeStart')" size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT id="remindTimeBeforeStart" class="InputStyle" type="input" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size=5 value="10">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				<br/>
				<INPUT id="remindBeforeEnd" type="checkbox" name="remindBeforeEnd" value="0">
					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT id="remindDateBeforeEnd" class="InputStyle" type="input" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT id="remindTimeBeforeEnd" class="InputStyle" type="input" name="remindTimeBeforeEnd" onchange="checkint('remindTimeBeforeEnd')"  size=5 value="10">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</TD>
		</TR>
		<TR id="remindTimeLine" style="display:none;height:1px">
			<TD class="Line" colSpan="6"></TD>
		</TR>
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
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
          <TD class=Field> <button type="button" class=Calendar onclick="onShowDate(BeginDatespan,begindate)"></BUTTON> <SPAN id=BeginDatespan ><%if("".equals(startdate)){ %><IMG src='/images/BacoError.gif' align=absMiddle><%}else{ %><%=startdate %><%} %></SPAN> <input class=inputstyle type="hidden" name="begindate" value="<%=startdate%>"></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
          <TD class=Field><button type="button" class=Clock onclick="onshowMeetingTime(BeginTimespan,begintime)"></button> <span id="BeginTimespan"><%if("".equals(starttime)){ %><IMG src='/images/BacoError.gif' align=absMiddle><%}else{ %><%=starttime %><%} %></span><input class=inputstyle type=hidden name="begintime" value="<%=starttime%>"></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field> <button type="button" class=Calendar onclick="onShowDate(EndDatespan,enddate)"></BUTTON> <SPAN id=EndDatespan ><%if("".equals(enddate)){ %><IMG src='/images/BacoError.gif' align=absMiddle><%}else{ %><%=enddate %><%} %></SPAN> <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>"></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
          <TD class=Field><button type="button" class=Clock onclick="onshowMeetingTime(EndTimespan,endtime)"></button> <span id="EndTimespan"><%if("".equals(endtime)){ %><IMG src='/images/BacoError.gif' align=absMiddle><%}else{ %><%=endtime %><%} %></span><input class=inputstyle type=hidden name="endtime" value="<%=endtime%>"></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
        
        <!--================ 会议地点 ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></TD>
			<TD class=Field>	       
				<button type="button" class=Browser id=SelectAddress onclick="CheckOnShowAddress();checkaddress(customizeAddress);checkinput3(customizeAddress, customizeAddressspan, customizeAddress.getAttribute('viewtype'))"></BUTTON> 
				<SPAN id=addressspan><%if("".equals(roomid)&&"".equals(roomname)) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}else{ %><A href='/meeting/Maint/MeetingRoom.jsp'><%=roomname %></A><%} %></SPAN> 
				<INPUT type=hidden class=inputstyle id=address name=address value="<%=roomid%>">
				<A href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193,user.getLanguage())%></A>
			</TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
        
        <!--================ 自定义会议地点 ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(20392, user.getLanguage())%></TD>
			<TD class=Field>
				<INPUT class=inputStyle size=28 id="customizeAddress"  onmousedown="omd()" viewtype=1 name="customizeAddress" value=""  onBlur="checkaddress(this);checkinput3(customizeAddress, customizeAddressspan, this.getAttribute('viewtype'))">
				<span id="customizeAddressspan"><%if("".equals(roomid)&&"".equals(roomname)) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
			</TD>
		</TR>
        <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
        
        </TBODY>
	  </TABLE>
	</TD>
        </TR>
        </TBODY>
	  </TABLE>

	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(2166,user.getLanguage())%> <input class=inputstyle type=text name="totalmember" size=5 onKeyPress="ItemCount_KeyPress_Plus()" value="0" onBlur="checkcount1(this);checkinput('totalmember','totalmemberspan')">
			<%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>)
            <span id="totalmemberspan"></span></TH>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1></TD></TR>
        <TR>
          <TD class=Field> 

<%
RecordSet.executeProc("Meeting_Member_SelectByType",meetingtype+flag+"1");
while(RecordSet.next()){
%>
			<input class=inputstyle type=checkbox name=hrmids01 value="<%=RecordSet.getString("memberid")%>" onclick="countAttend()"><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("memberid")%>' target="_blank"><%=ResourceComInfo.getResourcename(RecordSet.getString("memberid"))%></a>&nbsp&nbsp
<%}%>		  
		  </TD>
        </TR>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>: 
             <button class=Browser type="button" onclick="onShowMeetingHrm('hrmids02span','hrmids02');countAttend()"></button>
			<input class=inputstyle type=hidden name="hrmids02" value="">
			<span id="hrmids02span"><IMG src='/images/BacoError.gif' align=absMiddle></span> 
           
           <!--
			<button type="button" class=Browser onclick="onShowMeetingHrm('hrmids02span','hrmids02');countAttend()"></button>
			<input class=inputstyle type=hidden name="hrmids02" value="">
			<span id="hrmids02span"><IMG src='/images/BacoError.gif' align=absMiddle></span> 
		   -->	
		  </TD>
        </TR>
<%if(software.equals("ALL") || software.equals("CRM")){%>
        <TR>
          <TD class=Field>
<%
RecordSet.executeProc("Meeting_Member_SelectByType",meetingtype+flag+"2");
while(RecordSet.next()){
%>
			<input class=inputstyle type=checkbox name=crmids01 value="<%=RecordSet.getString("memberid")%>" onclick="countAttend()"><A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("memberid")%>'><%=CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))%></a>&nbsp&nbsp
<%}%>		  
		  </TD>
        </TR>
		<%if(isgoveproj==0){%>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(2167,user.getLanguage())%>: 
			<button type="button" class=Browser onclick="onShowMCrm('crmids02span','crmids02'), countAttend()"></button>
			<%}%>
			<input class=inputstyle type=hidden name="crmids02" value="">
			<%if(isgoveproj==0){%>
			<span id="crmids02span"></span> 
		  </TD>
        </TR>
		<%}%>
<%}%>
        <tr>
          <td class=field><%=SystemEnv.getHtmlLabelName(2168,user.getLanguage())%>: 
          <input class=inputstyle type=text name="othermembers" size=70>
          <td>
        <tr>
        </TBODY>
	  </TABLE>

	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2169,user.getLanguage())%></TH>
            <Td align=right>
				<A href="javascript:addRow();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
				<A href="javascript:if(isdel()){deleteRow1();}"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>	
			</Td>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colspan=2></TD></TR>
        <tr><td colspan=2>
          <table class=liststyle cellspacing=1>
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
	  <TABLE class=viewForm cellpadding=1  cols=6 id="oTable">
      	<COLGROUP>
      	<COL width="4%">
		<COL width="40%">
		<COL width="20%">
		<COL width="15%">
		<COL width="15%">
		<COL width="6%">
        <TBODY>
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
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(2107,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing>
          <TD class=Sep1 colspan=2></TD></TR>
<%
while(RecordSet.next()){
%>
        <TR>
		  <td><%=RecordSet.getString("name")%></td>
          <TD> 
		  <input class=inputstyle type=hidden name=servicename_<%=servicerows%> value="<%=RecordSet.getString("name")%>">
		  <input class=inputstyle type=hidden name=servicehrm_<%=servicerows%> value="<%=RecordSet.getString("hrmid")%>">
	  <TABLE class=viewForm>
        <TBODY>
        <TR>
          <TD class=Field>
<%
	ArrayList serviceitems = Util.TokenizerString(RecordSet.getString("desc_n"),",");
	for(int i=0;i<serviceitems.size();i++){
		//String id = RecordSet.getString("id");	
%>
		  <input class=inputstyle type=checkbox name=serviceitem_<%=servicerows%> value="<%=serviceitems.get(i)%>" ><%=serviceitems.get(i)%>&nbsp&nbsp
<%
	}
%>
		  </TD>
        </TR>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%>：<input class=inputstyle name=serviceother_<%=servicerows%> maxlength="255" onchange="checkLength()"  style="width:90%"></TD>
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
          <TR class=spacing style="height:1px;">
          	<TD class=line1 colspan=2></TD></TR>
          <TR>
          <TR>
            <td></td>
		    <td class=field colspan=4 id="divAccessory" name="divAccessory">
            	<%if(!"".equals(secId)){ %>
		          <input type=hidden id="accessory_num" name="accessory_num" value="1">
				    <div id="uploadDiv" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
		     <%}else{%>   
		        <font color=red>(<%=SystemEnv.getHtmlLabelName(20476,user.getLanguage())%>)</font>
		      <%}%>
		        </td>
          </TR>
          <TR style="height:1px;"><TD class=Line colspan=2></TD></TR>
	  </TABLE>
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colspan=2></TD></TR>
        <TR>
		  <td colspan=2>
		  <textarea class=inputstyle rows=5 style="width:100%" name="desc"></textarea>
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
  //绑定附件上传
   if(jQuery("#uploadDiv").length>0)
     bindUploaderDiv(jQuery("#uploadDiv"),"relatedacc"); 

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
function submitData() {
 window.history.back();
}
var rowColor="" ;
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

function checkuse(){
    <%
    String tempbegindate="";
    String tempenddate="";
    String tempbegintime="";
    String tempendtime="";
    String tempAddress="0";
	RecordSet.executeSql("select Address,begindate,enddate,begintime,endtime from meeting where meetingstatus=2 and isdecision<2 and (cancel is null or cancel<>'1') and    (begindate>='"+currentdate+"' or EndDate >= '"+currentdate+"') AND address <> 0 AND address IS NOT null");
    while(RecordSet.next()){
        tempAddress=RecordSet.getString("Address");
        tempbegindate=RecordSet.getString("begindate");
        tempenddate=RecordSet.getString("enddate");
        tempbegintime=RecordSet.getString("begintime");
        tempendtime=RecordSet.getString("endtime");
   %>
   if(document.weaver.address.value=="<%=tempAddress%>"){
       if(!(document.weaver.begindate.value+" "+document.weaver.begintime.value>"<%=tempenddate+' '+tempendtime%>" || document.weaver.enddate.value+" "+document.weaver.endtime.value<"<%=tempbegindate+' '+tempbegintime%>")){
           return true;
       }
   }
   <%
    }
    %>
    return false;
}

function doSave(obj){
	if(check_form(document.weaver,'<%=needcheck%>')&&checkAddress()&&checkDateValidity(weaver.begindate.value,weaver.begintime.value,weaver.enddate.value,weaver.endtime.value,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")){
		if(($GetEle("hrmids02").value!="" && $GetEle("hrmids02").value.length>0) || ($GetEle("crmids02").value!="" && $GetEle("crmids02").value.length>0) || checkHrm() || checkCrm()){
		var hashrmids=false;
        var lens = document.forms[0].elements.length;
        for(var i=0; i < lens;i++) {
            if ((document.forms[0].elements[i].name=='hrmids01' || document.forms[0].elements[i].name=='crmids01') && document.forms[0].elements[i].checked==true){
                hashrmids=true;
                break;
            }
        }
		if(document.weaver.hrmids02.value!="" || document.weaver.crmids02.value!="" || hashrmids){
	        enableAllmenu();
			document.weaver.topicrows.value=rowindex;
			setRemindData();
			//document.weaver.submit();
			 doUpload();
		}else{
            alert("<%=SystemEnv.getHtmlLabelName(20118,user.getLanguage())%>");
        }
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		}
	}
}

function doSubmit(obj){
    if(check_form(document.weaver,'<%=needcheck%>')&&checkAddress()&&checkDateValidity(weaver.begindate.value,weaver.begintime.value,weaver.enddate.value,weaver.endtime.value,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")){
		if(($GetEle("hrmids02").value!="" && $GetEle("hrmids02").value.length>0) || ($GetEle("crmids02").value!="" && $GetEle("crmids02").value.length>0) || checkHrm() || checkCrm()){
	         var hashrmids=false;
	        var lens = document.weaver.elements.length;
	        for(var i=0; i < lens;i++) {
	            if ((document.weaver.elements[i].name=='hrmids01' || document.weaver.elements[i].name=='crmids01') && document.weaver.elements[i].checked==true){
	                hashrmids=true;
	                break;
	            }
	        }
	        if(checkuse()){
	            if(confirm("<%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>")){
	                if(document.weaver.hrmids02.value!="" || document.weaver.crmids02.value!="" || hashrmids){
	                enableAllmenu();
	                document.weaver.topicrows.value=rowindex;
	                document.weaver.method.value = "addSubmit";
	                setRemindData();
	                document.weaver.submit();
	                }else{
	                    alert("<%=SystemEnv.getHtmlLabelName(20118,user.getLanguage())%>");
	                }
	            }
	        }else{
	            if(document.weaver.hrmids02.value!="" || document.weaver.crmids02.value!="" || hashrmids || document.weaver.hrmids01.value!=""){
	                enableAllmenu();
	                document.weaver.topicrows.value=rowindex;
	                document.weaver.method.value = "addSubmit";
	                setRemindData();
	                //document.weaver.submit();
	                doUpload();
	                }else{
	                    alert("<%=SystemEnv.getHtmlLabelName(20118,user.getLanguage())%>");
	                }
	        }
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
	if("" == $GetEle("address").value && "" == $GetEle("customizeAddress").value)
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
	//if(hascheckhrm == true){
		//if($GetEle("crmids02").value==null || $GetEle("crmids02").value==""){
			//$GetEle("crmids02span").innerHTML = "";
		//}
	//}else{
		//if($GetEle("crmids02").value==null || $GetEle("crmids02").value==""){
			//$GetEle("crmids02span").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		//}
	//}
	if(hascheckhrm==true || hascheckcrm==true || ($GetEle("hrmids02").value!="" && $GetEle("hrmids02").value.length>0) || ($GetEle("crmids02").value!="" && $GetEle("crmids02").value.length>0)){
		if($GetEle("hrmids02").value==null || $GetEle("hrmids02").value==""){
			$GetEle("hrmids02Span").innerHTML = "";
		}
	}else{
		$GetEle("hrmids02Span").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
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
	if(count<1)
		$GetEle("totalmemberspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	else
		$GetEle("totalmemberspan").innerHTML = "";
	$GetEle("totalmember").value = count;
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
</html>
<script language="javascript">

function  onShowHrmCaller(spanname,inputename,needinput){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere=<%=whereclause%>")
	if (datas){
		if (datas.id){
			$($GetEle(spanname)).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>");
			$GetEle(inputename).value=datas.id;
		}else {
			if (needinput = "1" ){
				$($GetEle(spanname)).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			}else{
				$($GetEle(spanname)).html("");
			}
			$GetEle(inputename).value="";
		}
	}
}

function onShowMProj(spanname,inputname){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if (datas){
	if(datas.id){
		$($GetEle(spanname)).html("<A href='/proj/data/ViewProject.jsp?ProjID="+datas.id+"'>"+datas.name+"</A>");
		$GetEle(inputname).value=id(0);
	}else {
		$($GetEle(spanname)).empty();
		$GetEle(inputname).value="0"
	}}
}
function onShowCaller(){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/CallerBrowser.jsp?sqlwhere=<%=whereclause%>"); 	
	 if (datas){
		 if(datas.id){
		     $($GetEle("Callerspan")).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>");
		      $GetEle("caller").value=datas.id
		 }else{
			$($GetEle("Callerspan")).html( "<IMG src='/images/BacoError.gif' align=absMiddle>");
			$GetEle("caller").value = ""
		 }
	 }
} 

function onShowHrm(spanname,inputename,needinput){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (datas){
		if(datas.id){
			$($GetEle(spanname)).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>");
			$GetEle(inputename).value=datas.id;
		}else{ 
			if(needinput == "1"){
				$($GetEle(spanname)).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			}else{
				$($GetEle(spanname)).html("");
			}
		
			$GetEle(inputename).value=""
		}
	}
}
function onShowProjectID(objval){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if (datas){
		if(datas.id){
			$("#projectidspan").html("<A href='/proj/data/ViewProject.jsp?ProjID="+datas.id+"'>"+datas.name+"</A>");
			weaver.projectid.value=datas.id;
		}else{ 
			if(objval=="2"){
				$("#projectidspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			}else{
				$("#projectidspan").html("");
			}
			weaver.projectid.value="0";
		}
	}
}
function onShowAddress(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp");
	if (datas){
		if (datas.id!=""){
			$("#addressspan").html("<A href='/meeting/Maint/MeetingRoom.jsp'>"+datas.name+"</A>");
			weaver.address.value=datas.id;
			$("#customizeAddressspan").html("");
		}else{
			$("#addressspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			weaver.address.value="";
			$("#customizeAddressspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		}	
	}
}
function onShowMeetingHrm(spanname,inputename){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
	    if(datas){
	        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
		         	alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
					return;
			 }else if(datas.id){
				resourceids = datas.id;
				resourcename =datas.name;
				sHtml = "";
				resourceids=resourceids.substr(1);
				resourceids =resourceids.split(",");
				$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr(1):resourceids;
				resourcename =resourcename.substr(1);
				resourcename =resourcename.split(",");
				for(var i=0;i<resourceids.length;i++){
					if(resourceids[i]&&resourcename[i]){
						sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
					}
				}
				$("#"+spanname).html(sHtml);
	        }else{
				$GetEle(inputename).value="";
				$($GetEle(spanname)).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	        }
	    }
}
function onShowMHrm(spanname,inputename){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
    if(datas){
        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
	         	alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
				return;
		 }else if(datas.id){
			resourceids = datas.id;
			resourcename =datas.name;
			sHtml = "";
			resourceids =resourceids.split(",");
			$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr("1"):resourceids;
			resourcename =resourcename.split(",");
			for(var i=0;i<resourceids.length;i++){
				if(resourceids[i]&&resourcename[i]){
					sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
				}
			}
			$("#"+spanname).html(sHtml);
        }else{
			$GetEle(inputename).value="";
			$($GetEle(spanname)).html("");
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


function onShowMHrm(spanname,inputename){
			tmpids = $GetEle(inputename).value;
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
		    if(datas){
		        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
			         	alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
						return;
				 }else if(datas.id){
					resourceids = datas.id;
					resourcename =datas.name;
					sHtml = "";
					resourceids =resourceids.split(",");
					$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr("1"):resourceids;
					resourcename =resourcename.split(",");
					for(var i=0;i<resourceids.length;i++){
						if(resourceids[i]&&resourcename[i]){
							sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
						}
					}
					$("#"+spanname).html(sHtml);
		        }else{
					$GetEle(inputename).value="";
					$($GetEle(spanname)).html("");
		        }
		    }
}

   function CheckOnShowAddress(){
	 if((document.weaver.customizeAddress.value!="")&&(document.getElementById("addressspan").innerHTML=="")){
     alert("<%=SystemEnv.getHtmlLabelName(20888, user.getLanguage())%>");   
	 }
	 onShowAddress();		 
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