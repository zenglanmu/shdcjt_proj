<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
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
String titlename = SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(264,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(679,user.getLanguage());
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
int resource=Util.getIntValue(request.getParameter("submiter"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

String sqlwhere="";
if(resource!=0){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.submiter="+resource;
	else	sqlwhere+=" and t1.submiter="+resource;
}
if(!fromdate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.submitdate>='"+fromdate+"'";
	else 	sqlwhere+=" and t1.submitdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.submitdate<='"+enddate+"'";
	else 	sqlwhere+=" and t1.submitdate<='"+enddate+"'";
}
/*
if(user.getLogintype().equals("2")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.submitertype='2'";
	else 	sqlwhere+=" and  t1.submitertype='2'";
}
*/
if(sqlwhere.equals("")){
		sqlwhere += " where t1.customerid != 0 " ;
}
String sqlstr = "";
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String temptable = "temptable"+ Util.getRandom() ;
if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
		sqlstr = "create table "+temptable+"  as select * from (select distinct t1.* from CRM_Log  t1,"+leftjointable+"  t2 "+ sqlwhere +"  and t1.customerid = t2.relateditemid order by t1.submitdate desc,t1.submittime desc) where rownum<"+ (pagenum*perpage+2);
	}else{
		sqlstr = "create table "+temptable+"  as select * from (select t1.* from CRM_Log  t1,CRM_CustomerInfo  t3 "+ sqlwhere +" and t1.customerid = t3.id and t3.agent="+user.getUID() + " order by t1.submitdate desc,t1.submittime desc) where rownum<"+ (pagenum*perpage+2);
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
		sqlstr = "create table "+temptable+"  as (select distinct t1.* from CRM_Log  t1,"+leftjointable+"  t2 ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" ( select distinct t1.* from CRM_Log  t1,"+leftjointable+"  t2 "+ sqlwhere +"  and t1.customerid = t2.relateditemid order by t1.submitdate desc,t1.submittime desc fetch first "+(pagenum*perpage+1)+"  rows only)";

    }else{
		sqlstr = "create table "+temptable+"  as (select distinct t1.* from CRM_Log  t1,"+leftjointable+"  t2 ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" ( select distinct t1.* from CRM_Log  t1,"+leftjointable+"  t2 "+ sqlwhere +"  and t1.customerid = t2.relateditemid order by t1.submitdate desc,t1.submittime desc fetch first "+(pagenum*perpage+1)+"  rows only)";
    }
}else{
	if(user.getLogintype().equals("1")){
		sqlstr = "select top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from CRM_Log  t1,"+leftjointable+"  t2 "+ sqlwhere +"  and t1.customerid = t2.relateditemid order by t1.submitdate desc,t1.submittime desc";
	}else{
		sqlstr = "select top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from CRM_Log  t1,CRM_CustomerInfo  t3 "+ sqlwhere +" and t1.customerid = t3.id and t3.agent="+user.getUID() + " order by t1.submitdate desc,t1.submittime desc";
	}
}

RecordSet.executeSql(sqlstr);
RecordSet.executeSql("Select count(customerid) RecordSetCounts from "+temptable);
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
	sqltemp="select * from (select * from  "+temptable+" order by submitdate,submittime) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select  * from "+temptable+"  order by submitdate,submittime fetch first  "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by submitdate,submittime";
}

RecordSet.executeSql(sqltemp);
%>
<form id=weaver name=frmmain method=post action="CRMModifyLogRp.jsp">
  <input type="hidden" name="pagenum" value=''>
<table class=ViewForm>
  <colgroup>
  <col width="10%">
  <col width="40%">
  <col width="10%">
  <col width="40%">
  <tbody>
<TR style="height:2px"><TD class=Line1 colSpan=4></TD></TR>
  <tr>
  <%if(!user.getLogintype().equals("2")){%>
  <td><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></td>
  <td class=field>
  <input class=wuiBrowser  type=hidden name=submiter value="<%=resource%>"
  _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name} </a>"
  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
  _displayText="<%=resourcename%>"
  ></td>
  <%}%>
  <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
  <td class=field>
  <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
  <input  type="hidden" name="fromdate" value=<%=fromdate%>>
  гн<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
  <input type="hidden" name="enddate" value=<%=enddate%>>
  
  </td>
  </TR><tr style="height:2px" ><td class=Line colspan=4></td></tr>

</tbody>
</table>
<table class=ListStyle cellspacing=1>
  <TR class=Header>
	  <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>&nbsp&nbsp<%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	  <th><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></th>
	  <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
	  <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>
	  <th><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></th>
	  <th><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></th>
  </TR>
<TR class=Line><TD colSpan=6></TD></TR>
<%
boolean islight=true;
int totalline=1;
if(RecordSet.last()){
	do{
%>
	<TR <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	      <TD><%=RecordSet.getString("submitdate")%>&nbsp&nbsp<%=RecordSet.getString("submittime")%></TD>
          <TD>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("customerid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("customerid")),user.getLanguage())%></a>		  
		  </TD>
		  <TD>
<%
	String strTemp1 = RecordSet.getString("logtype");
	String strTemp2 = "";
	if(strTemp1.substring(0,1).equals("n"))
	{
		%><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%
	}
		else if(strTemp1.substring(0,1).equals("d"))
	{
		%><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%
	}
	else if(strTemp1.substring(0,1).equals("a"))
	{
		%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%><%
	}
	else if(strTemp1.substring(0,1).equals("p"))
	{
		%><%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%><%
	}
	else if(strTemp1.substring(0,1).equals("u"))
	{
		%><%=SystemEnv.getHtmlLabelName(216,user.getLanguage())%><%
	}
	else
	{
		%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%
	}
	if(strTemp1.length()>1)
	{
		if(strTemp1.substring(1).equals("c"))
		{
			%>: <%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%
		}
	}
		%>&nbsp;<%
%>
		  </TD>
          <TD>
	<%if(!user.getLogintype().equals("2")) {%>
		<%if(!RecordSet.getString("submitertype").equals("2")) {%>		  
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("submiter")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("submiter")),user.getLanguage())%></a>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("submiter")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("submiter")),user.getLanguage())%></a>		
		<%}%>
	<%}else{%>
		<%if(!RecordSet.getString("submitertype").equals("2")) {%>		  
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("submiter")),user.getLanguage())%>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("submiter")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("submiter")),user.getLanguage())%></a>		
		<%}%>	
	<%}%>
		  </TD>

          <TD><a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("documentid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("documentid")),user.getLanguage())%></a></TD>
          <TD>
			<a href="/CRM/data/ViewModify.jsp?CustomerID=<%=RecordSet.getString("customerid")%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>		  
		  </TD>
        </TR>
	<TR <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
		  <TD colSpan=7><%=Util.toScreen(RecordSet.getString("logcontent"),user.getLanguage())%></TD>
	</TR>
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
</table>
<table align=right>
<tr style="display:none">
   <td>&nbsp;</td>
   <td>
	   <%if(pagenum>1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%> 
			<button type=submit class=btn accessKey=P id=prepage  onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>
	   <%if(hasNextPage){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%> 
			<button type=submit class=btn accessKey=N id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>&nbsp;</td>
</tr>
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
<script type="text/javascript">
  function doSearch(){
     jQuery("#weaver").submit();
  }
</script>
<script language=vbs>
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	submiterspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.submiter.value=id(0)
	else 
	submiterspan.innerHtml = ""
	frmmain.submiter.value=""
	end if
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>