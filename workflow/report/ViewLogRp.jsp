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
String titlename = SystemEnv.getHtmlLabelName(730,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(679,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%
int viewer=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();

String viewername=ResourceComInfo.getResourcename(viewer+"");

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String sql="";
String where="";
String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sql="create table searchtemp  as select t1.*,t2.creater,t2.workflowid,t2.requestname from workflow_requestViewLog t1,workflow_requestbase t2";
	where=" where t1.id=t2.requestid";

	if(viewer!=0){
		if(where.equals(""))	where+=" viewer="+viewer;
		else	where+=" and viewer="+viewer;
	}
	if(!fromdate.equals("")){
		if(where.equals(""))	where+=" viewdate>='"+fromdate+"'";
		else 	where+=" and viewdate>='"+fromdate+"'";
	}
	sql+=where;
	sql+=" order by viewdate desc,viewtime desc";
	RecordSet.executeSql(sql);
	sqltemp="delete from searchtemp where id in(select id from searchtemp where rownum <"+((pagenum-1)*perpage+1)+")"+
			" and viewer in(select viewer from searchtemp where rownum <"+((pagenum-1)*perpage+1)+")"+
			" and viewdate in(select viewdate from searchtemp where rownum <"+((pagenum-1)*perpage+1)+")"+
			" and viewtime in(select viewtime from searchtemp where rownum <"+((pagenum-1)*perpage+1)+")";
	RecordSet.executeSql(sqltemp);
	sqltemp="select * from searchtemp where rownum <"+(perpage+2);
}else{
	sql="select t1.*,t2.creater,t2.workflowid,t2.requestname into searchtemp from workflow_requestViewLog t1,workflow_requestbase t2";
	where=" where t1.id=t2.requestid";

	if(viewer!=0){
		if(where.equals(""))	where+=" viewer="+viewer;
		else	where+=" and viewer="+viewer;
	}
	if(!fromdate.equals("")){
		if(where.equals(""))	where+=" viewdate>='"+fromdate+"'";
		else 	where+=" and viewdate>='"+fromdate+"'";
	}
	sql+=where;
	sql+=" order by viewdate desc,viewtime desc";
	RecordSet.executeSql(sql);
	sqltemp="delete from searchtemp where id in(select top "+((pagenum-1)*perpage)+" id from searchtemp)"+
			" and viewer in(select top "+((pagenum-1)*perpage)+" viewer from searchtemp)"+
			" and viewdate in(select top "+((pagenum-1)*perpage)+" viewdate from searchtemp)"+
			" and viewtime in(select top "+((pagenum-1)*perpage)+" viewtime from searchtemp)";
	RecordSet.executeSql(sqltemp);
	sqltemp="select top "+(perpage+1)+" * from searchtemp";
}

%>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>



<form name=frmmain method=post action="ViewLogRp.jsp">

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
  <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
  <td class=field><BUTTON type=button  class=browser onClick="onShowResource()"></button>
  <span id=viewerspan><a href="javaScript:openhrm(<%=viewer%>);" onclick='pointerXY(event);'><%=Util.toScreen(viewername,user.getLanguage())%></a></span>
  <input type=hidden name=viewer value="<%=viewer%>"></td>
  <td><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%></td>
  <td class=field><BUTTON type=button  class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
  <input type="hidden" name="fromdate" value=<%=fromdate%>></td>
  </tr>
  
<script type="text/javascript">
function onShowResource() {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) !=  "") {
			$G("viewerspan").innerHTML = "<A href='HrmResource.jsp?id=" + wuiUtil.getJsonValueByIndex(id, 0) + "'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</A>";
			$G("viewer").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else { 
			$G("viewerspan").innerHTML = ""
			$G("viewer").value=""
		}
	}
}
</script>
  
</tbody>
</table>
<table class=liststyle cellspacing=1  >
<colgroup>
  <col width="20%">
  <col width="20%">
  <col width="20%">
  <col width="10%">
  <col width="10%">
  <col width="20%">
 
  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(1272,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(15530,user.getLanguage())%></td>
  <td>IP Address</td>
  </tr><TR class=Line><TD colspan="6" ></TD></TR> 
  
<%
boolean islight=true;
int totalline=0;
RecordSet.executeSql(sqltemp);
while(RecordSet.next()){
	totalline+=1;
	if(totalline==(perpage+1))	break;
	String creater=RecordSet.getString("creater");
	String viewdate=RecordSet.getString("viewdate");
	String viewtime=RecordSet.getString("viewtime");
	String workflowid=RecordSet.getString("workflowid");
	String requestid=RecordSet.getString("id");
	String requestname=RecordSet.getString("requestname");
	String curviewer=RecordSet.getString("viewer");
	String clientip=RecordSet.getString("ipaddress");
	
	String curviewername=ResourceComInfo.getResourcename(curviewer);
	String creatername=ResourceComInfo.getResourcename(creater);
	String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
%>
<tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	<td><%=Util.toScreen(viewdate,user.getLanguage())%>&nbsp;<%=Util.toScreen(viewtime,user.getLanguage())%></td>
	<td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>"><%=Util.toScreen(requestname,user.getLanguage())%></a></td>
	<td><%=Util.toScreen(workflowname,user.getLanguage())%></td>
	<td><a href="javaScript:openhrm(<%=creater%>);" onclick='pointerXY(event);'><%=Util.toScreen(creatername,user.getLanguage())%></a></td>
	<td><a href="javaScript:openhrm(<%=curviewer%>);" onclick='pointerXY(event);'><%=Util.toScreen(curviewername,user.getLanguage())%></a></td>
	<td><%=Util.toScreen(clientip,user.getLanguage())%></td>
</tr>
<%
	islight=!islight;
}

%>
</table>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>

</table>
<%RecordSet.executeSql("drop table searchtemp");%>
<%if(pagenum>1){%>
   
   <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",ViewLogRp.jsp?pagenum="+(pagenum-1)+"&viewer="+viewer+"&fromdate="+fromdate+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%><%}%><%if(totalline>perpage){%>
      <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",ViewLogRp.jsp?pagenum="+(pagenum+1)+"&viewer="+viewer+"&fromdate="+fromdate+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
   <%}%>
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
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>