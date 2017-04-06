<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("LogView:View", user))  {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(730,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(679,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>


<%
/*
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
String resourcename=ResourceComInfo.getResourcename(resource+"");

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());

String sql="select * into searchtemp from Prj_ViewLog1";
String where="";
if(resource!=0){
	if(where.equals(""))	where+=" where viewer="+resource;
	else	where+=" and viewer="+resource;
}
if(!fromdate.equals("")){
	if(where.equals(""))	where+=" where viewdate>='"+fromdate+"'";
	else 	where+=" and viewdate>='"+fromdate+"'";
}
sql+=where;
sql+=" order by viewdate desc,viewtime desc";

RecordSet.executeSql(sql);
String sqltemp="delete from searchtemp where id in(select top "+((pagenum-1)*perpage)+" id from searchtemp)"+
		" and viewer in(select top "+((pagenum-1)*perpage)+" viewer from searchtemp)"+
		" and viewdate in(select top "+((pagenum-1)*perpage)+" viewdate from searchtemp)"+
		" and viewtime in(select top "+((pagenum-1)*perpage)+" viewtime from searchtemp)";
RecordSet.executeSql(sqltemp);
sqltemp="select top "+(perpage+1)+" * from searchtemp";
*/
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
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.viewdate>='"+enddate+"'";
	else 	sqlwhere+=" and t1.viewdate<='"+enddate+"'";
}
if(!sqlwhere.equals("")){
	sqlwhere = sqlwhere +" and t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
}else{
	sqlwhere = " where t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
}

String sqlstr = "";
String temptable = "temptable"+ Util.getRandom() ;

if(RecordSet.getDBType().equals("oracle")){
	sqlstr = "create table "+temptable+"  as select * from (select  t1.* from Prj_ViewLog1  t1, PrjShareDetail  t2  "+ sqlwhere+" order by t1.viewdate desc,t1.viewtime desc ) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
	sqlstr = "create table "+temptable+"  as  (select  t1.* from Prj_ViewLog1  t1, PrjShareDetail  t2 ) definition only ";

    RecordSet.executeSql(sqlstr);

    sqlstr = "insert into "+temptable+" (select  t1.*  from Prj_ViewLog1  t1, PrjShareDetail  t2  "+ sqlwhere+" order by t1.viewdate desc,t1.viewtime desc fetch first  "+(pagenum*perpage+1)+" rows only )" ;
}else{
	sqlstr = "select top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from Prj_ViewLog1  t1, PrjShareDetail  t2  "+ sqlwhere+" order by t1.viewdate desc,t1.viewtime desc" ;
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
    	sqltemp="select * from "+temptable+"  order by viewdate,viewtime fetch first  "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by viewdate,viewtime";
}

RecordSet.executeSql(sqltemp);

%>
<form name=frmmain method=post action="ProjectViewLogRp.jsp">

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

<table class=viewform>
  <colgroup>
  <col width="10%">
  <col width="40%">
  <col width="10%">
  <col width="40%">
  <tbody>
  <TR class=spacing><TD colspan=4 class=sep2></TD></TR>
  <tr>
  <%if(!user.getLogintype().equals("2")){%>
  <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
  <td class=field> 
   <input  class=wuiBrowser  type=hidden name=viewer value="<%=resource%>"
   _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
   _displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
   _displayText="<%=resourcename%>" >
  </td>
  <%}%>
  <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
  <td class=field>
  <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
  <input type="hidden" name="fromdate" value=<%=fromdate%>>
  гн<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
  <input type="hidden" name="enddate" value=<%=enddate%>>
  
  </td>
  </tr>
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
<table class=liststyle cellspacing=1 >
<colgroup>
  <col width="25%">
  <col width="25%">
  <col width="25%">
  <col width="25%">
  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(1272,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1353,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1273,user.getLanguage())%></td>
  <td>IP Address</td>
  </tr>
  <TR class=Line><TD colspan="4" ></TD></TR>
<%
boolean islight=true;
int totalline=1;
if(RecordSet.last()){
	do{
	String projectid=RecordSet.getString("id");
	String viewdate=RecordSet.getString("viewdate");
	String viewtime=RecordSet.getString("viewtime");
	String viewer=RecordSet.getString("viewer");
	String clientip=RecordSet.getString("ipaddress");
	
	String viewername=ResourceComInfo.getResourcename(viewer);
	String projectname=ProjectInfoComInfo.getProjectInfoname(projectid);
%>
<tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	<td><%=Util.toScreen(viewdate,user.getLanguage())%>&nbsp;<%=Util.toScreen(viewtime,user.getLanguage())%></td>
	<td><a href="/Proj/data/ViewProject.jsp?ProjID=<%=projectid%>"><%=Util.toScreen(projectname,user.getLanguage())%></a></td>
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
<tr>
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
<tr>
   <td colspan=2 >&nbsp;</td>
   <td><%if(pagenum>1){%>
   
   <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",ProjectViewLogRp.jsp?pagenum="+(pagenum-1)+"&viewer="+resource+"&fromdate="+fromdate+"&enddate="+enddate+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%></td>
   <td><%if(hasNextPage){%>
   <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",ProjectViewLogRp.jsp?pagenum="+(pagenum+1)+"&viewer="+resource+"&fromdate="+fromdate+"&enddate="+enddate+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%><%}%></td>
   </tr>
</table>

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
<%@ include file="/systeminfo/RightClickMenu.jsp"%>
</form>
<script language="javascript">
function submitData()
{
		frmmain.submit();
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>