<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("LogView:View", user))  {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(730,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(679,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

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
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

String sqlwhere="";
if(resource!=0){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.viewer="+resource;
	else	sqlwhere+=" and t1.viewer="+resource;
}
if(!fromdate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.viewdate>='"+fromdate+"'";
	else 	sqlwhere+=" and t1.viewdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.viewdate<='"+enddate+"'";
	else 	sqlwhere+=" and t1.viewdate<='"+enddate+"'";
}
/*
if(user.getLogintype().equals("2")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.submitertype='2'";
	else 	sqlwhere+=" and  t1.submitertype='2'";
}
*/
if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}
String sqlstr = "";
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String temptable = "temptable"+ Util.getRandom() ;
if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
		sqlstr = "create table "+temptable+"  as select * from (select distinct t1.* from CRM_ViewLog1  t1,"+leftjointable+"  t2  "+ sqlwhere+" and t1.id = t2.relateditemid order by t1.viewdate desc,t1.viewtime desc) where rownum<"+ (pagenum*perpage+2);
	}else{
		sqlstr = "create table "+temptable+"  as select * from (select t1.* from CRM_ViewLog1  t1 "+ sqlwhere+" and t1.agent="+user.getUID() + " order by t1.viewdate desc,t1.viewtime desc) where rownum<"+ (pagenum*perpage+2);
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
		sqlstr = "create table "+temptable+"  as (select distinct t1.* from CRM_ViewLog1  t1,"+leftjointable+"  t2  ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" (select distinct t1.* from CRM_ViewLog1  t1,"+leftjointable+"  t2  "+ sqlwhere+" and t1.id = t2.relateditemid order by t1.viewdate desc,t1.viewtime desc fetch first "+(pagenum*perpage+1)+"  rows only)";
    }else{
		sqlstr = "create table "+temptable+"  as (select t1.* from CRM_ViewLog1  t1  ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" (select t1.* from CRM_ViewLog1  t1 "+ sqlwhere+" and t1.agent="+user.getUID() + " order by t1.viewdate desc,t1.viewtime desc fetch first "+(pagenum*perpage+1)+"  rows only)";
    }
}else{
	if(user.getLogintype().equals("1")){
		sqlstr = "select distinct top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from CRM_ViewLog1  t1,"+leftjointable+"  t2  "+ sqlwhere+" and t1.id = t2.relateditemid order by t1.viewdate desc,t1.viewtime desc" ;
	}else{
		sqlstr = "select top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from CRM_ViewLog1  t1 "+ sqlwhere+" and t1.agent="+user.getUID() + " order by t1.viewdate desc,t1.viewtime desc" ;
	}
}

RecordSet.executeSql(sqlstr);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by viewdate,viewtime) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select * from "+temptable+"  order by viewdate,viewtime fetch first  "+(RecordSetCounts-(pagenum-1)*perpage)+"  rows only";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by viewdate,viewtime";
}

RecordSet.executeSql(sqltemp);
%>
<form id=weaver name=frmmain method=post action="CRMViewLogRp.jsp">

<table class=ViewForm>
  <colgroup>
  <col width="10%">
  <col width="40%">
  <col width="10%">
  <col width="40%">
  <tbody>
<TR style="height:2px" ><TD class=Line colSpan=4></TD></TR>
  <tr>
  <%if(!user.getLogintype().equals("2")){%>
  <td><%=SystemEnv.getHtmlLabelName(1273,user.getLanguage())%></td>
  <td class=field><input class=wuiBrowser  type=hidden name=viewer value="<%=resource%>"
  _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name} </a>"
  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
  _displayText="<%=resourcename%>"
  ></td>
  <%}%>
  <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
  <td class=field>
  <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
  <input type="hidden" name="fromdate" value=<%=fromdate%>>
  гн<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
  <input  type="hidden" name="enddate" value=<%=enddate%>>
  
  </td>
  </TR><tr style="height:2px" ><td class=Line colspan=4></td></tr>
<script language=vbs>
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	viewerspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.viewer.value=id(0)
	else 
	viewerspan.innerHtml = ""
	frmmain.viewer.value=""
	end if
	end if
end sub
</script>
</tbody>
</table>
<table class=ListStyle cellspacing=1>
<colgroup>
  <col width="25%">
  <col width="25%">
  <col width="25%">
  <col width="25%">
  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(1272,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1273,user.getLanguage())%></td>
  <td>IP Address</td>
  </tr>
  <TR class=Line><TD colSpan=4></TD></TR>
<%
boolean islight=true;
int totalline=1;
if(RecordSet.last()){
	do{
	String customerid=RecordSet.getString("id");
	String viewdate=RecordSet.getString("viewdate");
	String viewtime=RecordSet.getString("viewtime");
	String viewer=RecordSet.getString("viewer");
	String clientip=RecordSet.getString("ipaddress");
	
	String viewername=ResourceComInfo.getResourcename(viewer);
	String customername=CustomerInfoComInfo.getCustomerInfoname(customerid);
%>
<tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	<td><%=Util.toScreen(viewdate,user.getLanguage())%>&nbsp;<%=Util.toScreen(viewtime,user.getLanguage())%></td>
	<td><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=customerid%>"><%=Util.toScreen(customername,user.getLanguage())%></a></td>
	<td>
		<%if(!user.getLogintype().equals("2")) {%>
			<%if(!RecordSet.getString("submitertype").equals("2")) {%>		  
				<a href="/hrm/resource/HrmResource.jsp?id=<%=viewer%>"><%=Util.toScreen(viewername,user.getLanguage())%></a>
			<%}else{%>
				<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=viewer%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(viewer),user.getLanguage())%></a>		
			<%}%>
		<%}else{%>
			<%if(!RecordSet.getString("submitertype").equals("2")) {%>		  
				<%=Util.toScreen(viewername,user.getLanguage())%>
			<%}else{%>
				<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=viewer%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(viewer),user.getLanguage())%></a>		
			<%}%>	
		<%}%>	
	</td>
	<td><%=Util.toScreen(clientip,user.getLanguage())%></td>
<%
	islight=!islight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}while(RecordSet.previous());
}
RecordSet.executeSql("drop table "+temptable);
%>

<%if(pagenum>1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>    
   <button style="display:none" class=btn accessKey=P id=prepage  onclick="location.href='CRMViewLogRp.jsp?pagenum=<%=pagenum-1%>&viewer=<%=resource%>&fromdate=<%=fromdate%>&enddate=<%=enddate%>'"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button><%}%>
<%if(hasNextPage){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>    
   <button  style="display:none" class=btn accessKey=N id=nextpage  onclick="location.href='CRMViewLogRp.jsp?pagenum=<%=pagenum+1%>&viewer=<%=resource%>&fromdate=<%=fromdate%>&enddate=<%=enddate%>'"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button><%}%>
</table>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</body>
<script type="text/javascript">
  function doSearch(){
    jQuery("#weaver").submit();
  }
</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>