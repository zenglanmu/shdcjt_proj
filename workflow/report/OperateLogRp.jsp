<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
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
String titlename = SystemEnv.getHtmlLabelName(104,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(679,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>


<%
int userid=user.getUID();
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();

int operator=Util.getIntValue(request.getParameter("operator"),0);
if(operator==0)	operator=userid;
String operatorname=ResourceComInfo.getResourcename(operator+"");

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String sql="";
String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sql="create table searchtemp as select t1.clientip, t1.logtype,t1.operatedate,t1.operatetime,t1.workflowid,t1.operator,t1.requestid, t2.creater, t2.requestname from workflow_requestLog t1,workflow_requestbase t2"+
	" where t1.requestid=t2.requestid and t1.operator="+operator;
	if(!fromdate.equals(""))	sql+=" and operatedate>='"+fromdate+"'";
	sql+=" order by operatedate desc,operatetime desc ";

	RecordSet.executeSql(sql);
	sqltemp="delete from searchtemp where requestid in(select requestid from searchtemp where rownum <"+((pagenum-1)*perpage+1)+")"+
			" and operator in(select operator from searchtemp where rownum <"+((pagenum-1)*perpage+1)+")"+
			" and operatedate in(select operatedate from searchtemp where rownum <"+((pagenum-1)*perpage+1)+")"+
			" and operatetime in(select operatetime from searchtemp where rownum <"+((pagenum-1)*perpage+1)+")";
	RecordSet.executeSql(sqltemp);
	sqltemp="select * from searchtemp where rownum <"+(perpage+2);
}else{
	sql="select t1.*,t2.creater,t2.requestname into searchtemp from workflow_requestLog t1,workflow_requestbase t2"+
		" where t1.requestid=t2.requestid and t1.operator="+operator;
	if(!fromdate.equals(""))	sql+=" and operatedate>='"+fromdate+"'";
	sql+=" order by operatedate desc,operatetime desc";

	RecordSet.executeSql(sql);
	sqltemp="delete from searchtemp where requestid in(select top "+((pagenum-1)*perpage)+" requestid from searchtemp)"+
			" and operator in(select top "+((pagenum-1)*perpage)+" operator from searchtemp)"+
			" and operatedate in(select top "+((pagenum-1)*perpage)+" operatedate from searchtemp)"+
			" and operatetime in(select top "+((pagenum-1)*perpage)+" operatetime from searchtemp)";
	RecordSet.executeSql(sqltemp);
	sqltemp="select top "+(perpage+1)+" * from searchtemp";
}
%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<form name=frmmain method=post action="OperateLogRp.jsp">

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
  <col width="40%">
  <col width="10%">
  <col width="40%">
  <tbody>
  
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></td>
  <td class=field>
  
  <input class="wuiBrowser" type=hidden name=operator value="<%=operator%>"
  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
     _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name} </a>"
   _displayText="<%=Util.toScreen(operatorname,user.getLanguage())%>"
  ></td>
  <td><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%></td>
  <td class=field><BUTTON type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
  <input type="hidden" name="fromdate" value=<%=fromdate%>></td>
  </tr>
<script language=vbs>
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	operatorspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.operator.value=id(0)
	else 
	operatorspan.innerHtml = ""
	frmmain.operator.value=""
	end if
	end if
end sub
</script>
</tbody>
</table>
<table class=liststyle cellspacing=1  >
<colgroup>
  <col width="20%">
  <col width="20%">
  <col width="20%">
  <col width="15%">
  <col width="10%">
  <col width="15%">
  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(17484,user.getLanguage())%></td>
  </tr>
<TR class=Line><TD colspan="6" ></TD></TR> 
<%
boolean islight=true;
int totalline=0;
RecordSet.executeSql(sqltemp);
while(RecordSet.next()){
	totalline+=1;
	if(totalline==(perpage+1))	break;
	String creater=RecordSet.getString("creater");
	String operatedate=RecordSet.getString("operatedate");
	String operatetime=RecordSet.getString("operatetime");
	String workflowid=RecordSet.getString("workflowid");
	String requestid=RecordSet.getString("requestid");
	String requestname=RecordSet.getString("requestname");
	String clientip=RecordSet.getString("clientip");
	String logtype=RecordSet.getString("logtype");
	
	String creatername=ResourceComInfo.getResourcename(creater);
	String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
%>
<tr<%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	<td><%=Util.toScreen(operatedate,user.getLanguage())%>&nbsp;<%=Util.toScreen(operatetime,user.getLanguage())%></td>
	<td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>"><%=Util.toScreen(requestname,user.getLanguage())%></a></td>
	<td><%=Util.toScreen(workflowname,user.getLanguage())%></td>
	<td><a href="javaScript:openhrm(<%=creater%>);" onclick='pointerXY(event);'><%=Util.toScreen(creatername,user.getLanguage())%></a></td>
	<td>
	<%if(logtype.equals("1")){%><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%><%}%>
	<%if(logtype.equals("2")){%><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%><%}%>
	<%if(logtype.equals("3")){%><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%><%}%>
	<%if(logtype.equals("4")){%><%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%><%}%>
	<%if(logtype.equals("5")){%><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%}%>
	<%if(logtype.equals("6")){%><%=SystemEnv.getHtmlLabelName(737,user.getLanguage())%><%}%>
	<%if(logtype.equals("7")){%><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%><%}%>
	<%if(logtype.equals("9")){%><%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%><%}%>
	<%if(logtype.equals("0")){%><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%><%}%>
	<%if(logtype.equals("e")){%><%=SystemEnv.getHtmlLabelName(18360,user.getLanguage())%><%}%>
	<%if(logtype.equals("t")){%><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%><%}%>
	<%if(logtype.equals("s")){%><%=SystemEnv.getHtmlLabelName(21223,user.getLanguage())%><%}%>
	</td>
	<td><%=Util.toScreen(clientip,user.getLanguage())%></td>
</tr>
<%
	islight=!islight;
}
RecordSet.executeSql("drop table searchtemp");
%>
<tr>
   <td colspan=4 >&nbsp;</td>
   <td><%if(pagenum>1){%>
   
      <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",OperateLogRp.jsp?pagenum="+(pagenum-1)+"&operator="+operator+"&fromdate="+fromdate+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%><%}%>
</td>
  
   <td><%if(totalline>perpage){%>
       <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",OperateLogRp.jsp?pagenum="+(pagenum+1)+"&operator="+operator+"&fromdate="+fromdate+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%><%}%>

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


<%@ include file="/systeminfo/RightClickMenu.jsp" %>

</form>
<script language="javascript">
function submitData()
{
	if (check_form(frmmain,''))
		frmmain.submit();
}

function submitClear()
{
	btnclear_onclick();
}

</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</body>
</html>