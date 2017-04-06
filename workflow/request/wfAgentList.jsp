<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
 <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>


<%
String info = (String)request.getParameter("infoKey");
%>
<script language="JavaScript">
<%if(info!=null && !"".equals(info)){

  if("1".equals(info)){%>
   alert("<%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>")
 <%}
  else if("2".equals(info)){%>
  alert("<%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%>")
 <%}
 else{
 
 }
 }%>
</script>


<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(18462,user.getLanguage());
String needfav ="1";
String needhelp ="";

//td2483 xwj 20050811
boolean haveAgentAllRight=false;
if(HrmUserVarify.checkUserRight("WorkflowAgent:All", user)){
  haveAgentAllRight=true;
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(20839,user.getLanguage())+SystemEnv.getHtmlLabelName(18666,user.getLanguage())+",javascript:OnCountermand(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/workflow/request/wfAgentAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/request/wfAgentStatistic.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

ArrayList arr = new ArrayList();
//added by xwj fortd2483 20050812
String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
%>

<%
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String fromtime = Util.null2String(request.getParameter("fromtime"));
String todate = Util.null2String(request.getParameter("todate"));
String totime = Util.null2String(request.getParameter("totime"));
String beagentid = Util.null2String(request.getParameter("beagentid"));
String agentid = Util.null2String(request.getParameter("agentid"));
String agenttype = Util.null2String(request.getParameter("agenttype"));
String sqlwhere=" where a.workflowId = b.id and b.workflowtype = t.id ";
String newsql="";

	if(!workflowtype.equals("") && workflowtype != null){
	newsql+=" and b.workflowtype = " + workflowtype ;
  }
  if(!workflowid.equals("") && workflowid != null){
	newsql+=" and a.workflowId = " + workflowid ;
  }
  /** td16820
   if(!fromdate.equals("") && fromdate != null){
	newsql+=" and a.beginDate >= '" + fromdate + "'" ;
  }
  */
   if(!beagentid.equals("") && beagentid != null){
	newsql+=" and a.beagenterid = " + beagentid ;
  }
  if(!agentid.equals("") && agentid != null){
	newsql+=" and a.agenterid = " + agentid ;
  }
  	/* td16820 开始 开始时间、结束时间条件 */
  	boolean isOracle = (RecordSet.getDBType()).equals("oracle");
	if((!fromdate.equals("") && fromdate != null) || (!fromtime.equals("") && fromtime != null)){
		String fromdatetmp = fromdate;
		String fromtimetmp = fromtime;
		if("".equals(fromdate)) fromdatetmp = "0000-00-00";
		if("".equals(fromtime)) fromtimetmp = "00:00   ";
		if(fromtime.length() == 5) fromtimetmp += "   ";
		if(!isOracle) {
			newsql+=" and ( (CASE when begindate=' ' then '0000-00-00' else begindate end) + ' ' + (CASE when begintime=' ' then '00:00   ' else begintime end) ) >= '" + fromdatetmp + " " + fromtimetmp + "'" ;
		} else {
			newsql+=" and ( DECODE(begindate,null,'0000-00-00', begindate,begindate) || ' ' || DECODE(begintime,null,'00:00   ', begintime,begintime) ) >= '" + fromdatetmp + " " + fromtimetmp + "'" ;
		}
	}
	if((!totime.equals("") && totime != null) || (!todate.equals("") && todate != null)){
		String todatetmp = todate;
		String totimetmp = totime;
		if("".equals(todate)) todatetmp = "9999-99-99";
		if("".equals(totime)) totimetmp = "23:59   ";
		if(totime.length() == 5) totimetmp += "   ";
		if(!isOracle) {
			newsql+=" and ( (CASE when enddate=' ' then '9999-99-99' else enddate end) + ' ' + (CASE when endtime=' ' then '23:59   ' else endtime end) ) <= '" + todatetmp + " " + totimetmp + "'" ;
		} else {
			newsql+=" and ( DECODE(enddate,null,'9999-99-99', enddate,enddate) || ' ' || DECODE(endtime,null,'23:59   ', endtime,endtime)) <= '" + todatetmp + " " + totimetmp + "'" ;
		}
	}
  	/* td16820 结束 开始时间、结束时间条件 */
  /*
  if(!agenttype.equals("") && agenttype != null){
     
     if("1".equals(agenttype)){//有效
      newsql += " and agenttype = '1' " +  
    " and ( ( (endDate = '" + currentDate + "' and (endTime='' or endTime is null))" + 
    " or (endDate = '" + currentDate + "' and endTime > '" + currentTime + "' ) ) " + 
    " or endDate > '" + currentDate + "' or endDate = '' or endDate is null)" ;
   //" and ( ( (beginDate = '" + currentDate + "' and (beginTime='' or beginTime is null))" + 
	//  " or (beginDate = '" + currentDate + "' and beginTime < '" + currentTime + "' ) ) " + 
	//  " or beginDate < '" + currentDate + "' or beginDate = '' or beginDate is null) " +
       /*
        if(todate.equals("") || todate == null){
        newsql+=" and a.agenttype = '1' and (a.endDate >= '" + currentDate + "' or a.endDate = '' or a.endDate is null)";
       }
       else{
        newsql+=" and a.agenttype = '1' and ( (a.endDate >= '" + currentDate + "' and  a.endDate <= '" + todate + "') or a.endDate = '' or a.endDate is null)";
       }
       
     }
     else if("0".equals(agenttype)){//无效
      
       
       //if(todate.equals("") || todate == null){
        //newsql+="  and (a.agenttype = '0' or a.endDate <= '" + currentDate + "')";
      // }
      // else{
       // newsql+=" and (a.agenttype = '0' or (a.endDate <= '" + currentDate + "' and a.endDate <= '" + todate + "'))";
      // }
      
         newsql += " and agenttype = '0' " +  
    " and ( ( (endDate = '" + currentDate + "' and (endTime<>'' or endTime is not null))" + 
    " or (endDate = '" + currentDate + "' and endTime < '" + currentTime + "' ) ) " + 
    " or endDate < '" + currentDate + "' or endDate = '' or endDate is null)" ;
    //" and ( ( (beginDate = '" + currentDate + "' and (beginTime='' or beginTime is null))" + 
	//  " or (beginDate = '" + currentDate + "' and beginTime < '" + currentTime + "' ) ) " + 
	//  " or beginDate < '" + currentDate + "' or beginDate = '' or beginDate is null) " +
	   
     }
     else{//全部
      
       if(!todate.equals("") && todate != null){
	       newsql+=" and a.endDate <= '" + todate + "'" ;
       }
      
     }

	}*/
 
//added by xwj for td2483 20050815
String orderby = "";
String orderby2 = "";
orderby=" order by t.id desc,a.workflowid desc";
orderby2=" order by id,workflowid";

sqlwhere +=" "+newsql ;


String tablename = "wrktablename"+ Util.getRandom() ;

String sql="";

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

boolean hasNextPage=false;
if(totalcounts==0){
	sql="select count(*) from workflow_agent a,workflow_type t,workflow_base b ";
	sql+=sqlwhere;
	RecordSet.executeSql(sql);
	if(RecordSet.next())
		totalcounts = RecordSet.getInt(1);
}

if(RecordSet.getDBType().equals("oracle")){
	sql="create table "+tablename+"  as select * from ( select t.id,t.typename,b.workflowname,a.beagenterid,a.agenterid,a.operatorid, a.beginDate,a.endDate,a.agenttype,a.workflowid,a.agentid,a.beginTime,a.endTime,a.operatordate,a.operatortime from workflow_agent a,workflow_type t,workflow_base b ";
	sql+=sqlwhere; // modified by xwj for td2483 20050812
	sql+= " "+orderby;//added by xwj for td2483 20050815
	sql+= " ) ";
}else if(RecordSet.getDBType().equals("db2")){
	sql="create table "+tablename+"  as ( select t.typename,b.workflowname,a.beagenterid,a.agenterid,a.operatorid, a.beginDate,a.endDate,a.agenttype,a.workflowid,a.agentid,a.beginTime,a.endTime,a.operatordate,a.operatortime from workflow_agent a,workflow_type t,workflow_base b ) definition only ";

    RecordSet.executeSql(sql);

    sql="insert into "+tablename+" (select t.typename,b.workflowname,a.beagenterid,a.agenterid,a.operatorid, a.beginDate,a.endDate,a.agenttype,a.workflowid,a.agentid,a.beginTime,a.endTime,a.operatordate,a.operatortime  from workflow_agent a,workflow_type t,workflow_base b ";
	sql+=sqlwhere; 
	sql+= " "+orderby+"  )";
}else{
	sql="select  t.id,t.typename,b.workflowname,a.beagenterid,a.agenterid,a.operatorid, a.beginDate,a.endDate,a.agenttype,a.workflowid,a.agentid,a.beginTime,a.endTime,a.operatordate,a.operatortime into "+tablename+" from workflow_agent a,workflow_type t,workflow_base b ";
	sql+=sqlwhere; // modified by xwj for td2483 20050812
	sql+= " "+orderby;//added by xwj for td2483 20050815
}


RecordSet.executeSql(sql);

//out.println(sql);

int RecordSetCounts = 0;

String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+tablename+" t1 "+orderby2+")  ";//"orderby2" is added by xwj for td2483 20050815
}else if(RecordSet.getDBType().equals("db2")){
	sqltemp="select  * from "+tablename+" t1 " + orderby2+" " ;
}else{
	sqltemp="select  * from "+tablename+" t1 " + orderby2;//"orderby2" is added by xwj for td2483 20050815
}

//System.out.println("sqltemp==="+sqltemp);
RecordSet.executeSql(sqltemp);

%>


<FORM id=weaver name=frmmain method=post action="wfAgentList.jsp">
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

<table class="viewform">
  <colgroup>
  <col width="10%">
  <col width="20%">
  <col width="5">
  <col width="10%">
  <col width="20%">
  <col width="3%">
  <col width="6%">
  <col width="15">
  <tbody>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td>
     <select class=inputstyle  size=1 name=workflowid style=width:220>
     	<option value="">&nbsp;</option>
     	<%
     	while(WorkflowComInfo.next()){
     		String curwfids=WorkflowComInfo.getWorkflowid();
     		String workflownames=WorkflowComInfo.getWorkflowname();
     	%>
     	<option value="<%=curwfids%>" <% if(workflowid.equals(curwfids)) {%>selected<%}%> ><%=Util.toScreen(workflownames,user.getLanguage())%></option>
     	<%}%>
     </select>
    </td>

    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
    <td  colspan=4>
      <select class=inputstyle  size=1 name=agenttype>
     <option value="2" <% if(!agenttype.equals("1") || !agenttype.equals("0")) {%>selected<%}%>> -- </option>
     <option value="0" <% if(agenttype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
     	<option value="1" <% if(agenttype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
     	
     </select>
    </td>
  </tr>
  <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
 <tr>
    <td><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></td>
    <td>
    
      
      <INPUT type="hidden" name="agentid" class="wuiBrowser"  id ="agentid"  value='<%=agentid%>'  _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(agentid),user.getLanguage())%>"
      	_displayTemplate="<A href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name} </A>"
      	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">

    </td>

      <td>&nbsp;</td>
      <td ><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></td>
	  <td>
	    
      <INPUT type="hidden" name="beagentid" class="wuiBrowser"  id ="beagentid"  value='<%=beagentid%>'  _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(beagentid),user.getLanguage())%>"
      	_displayTemplate="<A href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name} </A>"
      	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
	 </td>
	 <td></td>
	<td> </td>
	<td >
	  
	</td>
  </tr> <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>

 <tr>
    <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
    <td >
    
        <button type="button"  class="Calendar" id="SelectBeginDate" onclick="onlistAgentBDate()"></BUTTON> 
      <SPAN id="begindatespan"><%if (!fromdate.equals("")) {%><%=fromdate%><%}%></SPAN> 
      &nbsp;&nbsp;&nbsp;
      <button type="button"  class="Clock" id="SelectBeginTime" onclick="onlistAgentTime(begintimespan,fromtime)"></BUTTON>
      <SPAN id="begintimespan"><%if (!fromtime.equals("")) {%><%=fromtime%><%}%></SPAN></TD>
  
       <INPUT type="hidden" name="fromdate" value=<%=fromdate%>>
       <INPUT type="hidden" name="fromtime" value=<%=fromtime%>>

	 	 	 <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
	  <td colspan=4>
	       <button type="button"  class="Calendar" id="SelectEndDate" onclick="onlistAgentEDate()"></BUTTON> 
      <SPAN id="enddatespan"><%if (!todate.equals("")) {%><%=todate%><%}%></SPAN> 
      &nbsp;&nbsp;&nbsp;
      <button type="button"  class="Clock" id="SelectEndTime" onclick="onlistAgentTime(endtimespan,totime)"></BUTTON>
      <SPAN id="endtimespan"><%if (!totime.equals("")) {%><%=totime%><%}%></SPAN> </TD>
    
       <INPUT type="hidden" name="todate" value=<%=todate%>>
       <INPUT type="hidden" name="totime" value=<%=totime%>>

  </tr> <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
  
  
  </tbody>
</table>

<input name=start type=hidden value="<%=start%>">
</form>
<%
totalcounts = 0;
RecordSet.afterLast() ;
while(RecordSet.previous()){
  	String agentid_rs=RecordSet.getString("agentid");
	String typename_rs=RecordSet.getString("typename");
	String workflowname_rs=RecordSet.getString("workflowname");
	String beagenterid_rs=RecordSet.getString("beagenterid");
	String agenterid_rs=RecordSet.getString("agenterid");
  	String operatorid_rs=RecordSet.getString("operatorid");
	String beginDate_rs=RecordSet.getString("beginDate");
	String endDate_rs=RecordSet.getString("endDate");
	String agenttype_rs=RecordSet.getString("agenttype");
	String workflowid_rs=RecordSet.getString("workflowid");
	String beginTime_rs=RecordSet.getString("beginTime");
	String endTime_rs=RecordSet.getString("endTime");
	boolean isvalid = (
	      "1".equals(agenttype_rs)
	      && 
	      (endDate_rs == null || "".equals(endDate_rs) || endDate_rs.compareTo(currentDate)>0 || 
	          ((endDate_rs.compareTo(currentDate)==0 &&  ("".equals(endTime_rs) || endTime_rs == null)) ||
	          (endDate_rs.compareTo(currentDate)==0 &&  endTime_rs.compareTo(currentTime)>0)))
	      &&
	      (beginDate_rs == null || "".equals(beginDate_rs) || beginDate_rs.compareTo(currentDate)<0 || 
	         ((beginDate_rs.compareTo(currentDate)==0 &&  ("".equals(beginTime_rs) || beginTime_rs == null)) ||
	         (beginDate_rs.compareTo(currentDate)==0 &&  beginTime_rs.compareTo(currentTime)<0)))
	      
	      );
	if((isvalid==true && agenttype.equals("0")) || (isvalid==false && agenttype.equals("1"))){
		continue;
	}
	totalcounts ++;
}
%>


<FORM id=weaver name=frmmain1 method=post action="wfAgentOperatorNew.jsp">
<input type="hidden" value="" name="method">
<table class=liststyle cellspacing=1   id=tblReport>
    <colgroup>
    <!--Modified by xwj for td2483 20050812-->
    <col valign=top align=left width="9%">
    <col valign=top align=left width="14%">
    <col valign=top align=left width="7%">
    <col valign=top align=left width="6%">
    <col valign=top align=left width="6%">
    <col valign=top align=left width="15%">
    <col valign=top align=left width="15%">
    <col valign=top align=left width="8%">
    <col valign=top align=left width="20%">
    <tbody>     <TR class="Header">
	<TH colspan=9><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%>:<%=totalcounts%></TH></TR>
    <tr class=Header>
      <th><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(15591,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(18458,user.getLanguage())%></th>
    </tr>
<%
boolean islight=true;
int totalline=1;
String tempName = "";
RecordSet.afterLast() ;
int cx = 0;
while(RecordSet.previous()){
  String agentid_rs=RecordSet.getString("agentid");
	String typename_rs=RecordSet.getString("typename");
	String workflowname_rs=RecordSet.getString("workflowname");
	String beagenterid_rs=RecordSet.getString("beagenterid");
	String agenterid_rs=RecordSet.getString("agenterid");
  String operatorid_rs=RecordSet.getString("operatorid");
	String beginDate_rs=RecordSet.getString("beginDate");
	String endDate_rs=RecordSet.getString("endDate");
	String agenttype_rs=RecordSet.getString("agenttype");
	String workflowid_rs=RecordSet.getString("workflowid");
	//added by xwj for td2483 on 20050812
	String beginTime_rs=RecordSet.getString("beginTime");
	String endTime_rs=RecordSet.getString("endTime");
	
	
	
	boolean isvalid = (
		      "1".equals(agenttype_rs)
		      && 
		      (endDate_rs == null || "".equals(endDate_rs) || endDate_rs.compareTo(currentDate)>0 || 
		          ((endDate_rs.compareTo(currentDate)==0 &&  ("".equals(endTime_rs) || endTime_rs == null)) ||
		          (endDate_rs.compareTo(currentDate)==0 &&  endTime_rs.compareTo(currentTime)>0)))
		      &&
		      (beginDate_rs == null || "".equals(beginDate_rs) || beginDate_rs.compareTo(currentDate)<0 || 
		         ((beginDate_rs.compareTo(currentDate)==0 &&  ("".equals(beginTime_rs) || beginTime_rs == null)) ||
		         (beginDate_rs.compareTo(currentDate)==0 &&  beginTime_rs.compareTo(currentTime)<0)))
		      
		      );
	if((isvalid==true && agenttype.equals("0")) || (isvalid==false && agenttype.equals("1"))){
		continue;
	}
	cx++;
	if(cx <= (start-1)*perpage){
		continue;
	}
	if(cx > start*perpage){
		hasNextPage = true;
		break;
	}
%>

    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
      <td>
      <%if(!typename_rs.equals(tempName)){%>
      <%=typename_rs%>
      <%}%>
      <%tempName = typename_rs;%>
      </td>
      <td>
      <%
     if(
      "1".equals(agenttype_rs)
      && 
      (endDate_rs == null || "".equals(endDate_rs) || endDate_rs.compareTo(currentDate)>0 || 
          ((endDate_rs.compareTo(currentDate)==0 &&  ("".equals(endTime_rs) || endTime_rs == null)) ||
          (endDate_rs.compareTo(currentDate)==0 &&  endTime_rs.compareTo(currentTime)>0)))
     // &&
     // (beginDate_rs == null || "".equals(beginDate_rs) || beginDate_rs.compareTo(currentDate)<0 || 
       //  ((beginDate_rs.compareTo(currentDate)==0 &&  ("".equals(beginTime_rs) || beginTime_rs == null)) ||
       //  (beginDate_rs.compareTo(currentDate)==0 &&  beginTime_rs.compareTo(currentTime)<0))
	 //  )
      
      )
      {%>
      <A href = "wfAgentEdit.jsp?agentid=<%=agentid_rs%>">
      <%=workflowname_rs%>
      </A>
      <%}
      else{%>
       <A href = "wfAgentNoEdit.jsp?agentid=<%=agentid_rs%>">
      <%=workflowname_rs%>
      </A>
      <%}%>
      </td>
      <td>
       <a href="javaScript:openhrm(<%=beagenterid_rs%>);" onclick='pointerXY(event);'><%=ResourceComInfo.getResourcename(beagenterid_rs)%></a>
      </td>
      <td>
       <a href="javaScript:openhrm(<%=agenterid_rs%>);" onclick='pointerXY(event);'><%=ResourceComInfo.getResourcename(agenterid_rs)%></a>
      </td>
       <td>
       <a href="javaScript:openhrm(<%=operatorid_rs%>);" onclick='pointerXY(event);'><%=ResourceComInfo.getResourcename(operatorid_rs)%></a>
      </td>
      <%--added by xwj for td2483 on 20050812--%>
      <td><%=beginDate_rs%> <%=beginTime_rs%></td>
      <td><%=endDate_rs%> <%=endTime_rs%></td>
      <td>
      <%
       if(isvalid==true){%>
     	<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
      <%}else{%>
      <%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
      <%}%>
      </td>
      <td>
 
     
      <%//td2483 xwj 20050811
      if(
      "1".equals(agenttype_rs)
      && 
      (endDate_rs == null || "".equals(endDate_rs) || endDate_rs.compareTo(currentDate)>0 || 
          ((endDate_rs.compareTo(currentDate)==0 &&  ("".equals(endTime_rs) || endTime_rs == null)) ||
          (endDate_rs.compareTo(currentDate)==0 &&  endTime_rs.compareTo(currentTime)>0)))
    //  &&
     // (beginDate_rs == null || "".equals(beginDate_rs) || beginDate_rs.compareTo(currentDate)<0 || 
     //    ((beginDate_rs.compareTo(currentDate)==0 &&  ("".equals(beginTime_rs) || beginTime_rs == null)) ||
     //    (beginDate_rs.compareTo(currentDate)==0 &&  beginTime_rs.compareTo(currentTime)<0)))
      
      )
      
      { 
      if(beagenterid_rs.equals(String.valueOf(user.getUID())) || haveAgentAllRight ){
         arr.add(agentid_rs);%>
          <input type="checkbox" name="cm<%=agentid_rs%>" value="cm<%=agentid_rs%>" onclick="countermand('<%=agentid_rs%>')">
		<%=SystemEnv.getHtmlLabelName(18459,user.getLanguage())%>
          <input type="checkbox" name="rm<%=agentid_rs%>" value="rm<%=agentid_rs%>" disabled = "true">
     <%=SystemEnv.getHtmlLabelName(18460,user.getLanguage())%>
    <%}
    }%>
      </td>
      
       </tr>
<%
	islight=!islight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}
%>
</table>

</form>

<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td>
   <%if(start>1){%>
   <%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:OnChangePage("+(start-1)+"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
     <%}%>
 <td><%if(hasNextPage){%>
      <%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:OnChangePage("+(start+1)+"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>     <%}%>
 <td>&nbsp;</td>
   </tr>
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

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
RecordSet.executeSql("drop table "+tablename);
%>
</body>
<SCRIPT language="javascript">
function OnCountermand(obj){
var flag = false;
var key;
<%for(int a=0; a<arr.size(); a++){%>
key = <%=arr.get(a)%>;
if(document.all("cm"+key).checked){
flag = true;
}
<%}%>
if(flag){
document.frmmain1.method.value = "listountermand";
document.frmmain1.submit();
obj.disabled = true;
}
else{
alert("<%=SystemEnv.getHtmlNoteName(80,user.getLanguage())%>");
}
}


function countermand(agentid){
	var cmFlag = document.all("cm"+agentid).checked;
	if(cmFlag == true){
		document.all("rm"+agentid).disabled = false;
		document.all("rm"+agentid).checked = true;
	}else{
		document.all("rm"+agentid).checked = false;
		document.all("rm"+agentid).disabled = true;
	}
}

function OnChangePage(start){
        document.frmmain.start.value = start;
		document.frmmain.submit();
}

function OnSearch(){
       
    document.frmmain.start.value="1";
		document.frmmain.submit();
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</html>