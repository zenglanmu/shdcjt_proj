<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<DIV class=HdrProps></DIV>
<%
char separator = Util.getSeparator();
String wftype=Util.null2String(request.getParameter("wftype"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
String userid=Util.null2String(request.getParameter("userid"));
String complete=Util.null2String(request.getParameter("complete"));
%>
<div>
<BUTTON class=btnNew accessKey=N onclick="location='RequestType.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>
</BUTTON><BUTTON class=btn accessKey=R onclick="javascript:history.back()"><U>R</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>
</BUTTON></div>
<br>
<table class=liststyle cellspacing=1  >
     <COLGROUP>
     <COL width="18%">
     <COL width="8%">
     <COL width="18%">
     <COL width="9%">
     <COL width="22%">
     <COL width="10%">
     <COL width="10%">
      <COL width="8%">
     <TR class="Title">
    	  <TH colSpan=8><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%></TH></TR>
     <TR class="Spacing">
    	  <TD class="Line1" colSpan=8></TD></TR>
     <tr class=header>
     	<td><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></td> 
    	<td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
    	<td><%=SystemEnv.getHtmlLabelName(2078,user.getLanguage())%></td>
    	<td><%=SystemEnv.getHtmlLabelName(16341,user.getLanguage())%></td>
    	<td><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%></td>
    	<td><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></td>
    	<td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
    	<td><%=SystemEnv.getHtmlLabelName(1501,user.getLanguage())%></td>
     </tr>
          
<%
int linecolor=0;
RecordSet.executeProc("workflow_requestbase_SByUser",userid+separator+wftype+separator+workflowid+separator+complete);
while(RecordSet.next()){
	String requestid=Util.null2String(RecordSet.getString("requestid"));
	String curworkflowid=Util.null2String(RecordSet.getString("workflowid"));
	String workflowname=Util.null2String(WorkflowComInfo.getWorkflowname(curworkflowid));
	String createdate=Util.null2String(RecordSet.getString("createdate"));
	String createtime=Util.null2String(RecordSet.getString("createtime"));
	String creater=Util.null2String(RecordSet.getString("creater"));
	String lastoperatedate=Util.null2String(RecordSet.getString("lastoperatedate"));
	String lastoperatetime=Util.null2String(RecordSet.getString("lastoperatetime"));
	String lastoperator=Util.null2String(RecordSet.getString("lastoperator"));
	String status=Util.null2String(RecordSet.getString("status"));
	String requestname=Util.null2String(RecordSet.getString("requestname"));
%>			
<tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%>> 
    <td><%=createdate%> <%=createtime%></td>
    <td><a href="javaScript:openhrm(<%=creater%>);" onclick='pointerXY(event);'>
    	<%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%></a></td>
    <td><%=lastoperatedate%> <%=lastoperatetime%></td>
    <td><a href="javaScript:openhrm(<%=lastoperator%>);" onclick='pointerXY(event);'>
    <%=Util.toScreen(ResourceComInfo.getResourcename(lastoperator),user.getLanguage())%></a></td>
    <td><a href="ViewRequest.jsp?requestid=<%=requestid%>">
    	<%=Util.toScreen(requestname,user.getLanguage())%></a></td>
    <td><%=Util.toScreen(workflowname,user.getLanguage())%></td>
    <td><%=Util.toScreen(status,user.getLanguage())%></td>
    <td><a href="/workflow/request/ViewRequestInfo.jsp?requestid=<%=requestid%>"><img src="/images/icon_request.gif" border=0></a></td>
   
</tr>
<%			
	if(linecolor==0)	linecolor=1;
	else linecolor=0;
	}
%>
</table>
</body>