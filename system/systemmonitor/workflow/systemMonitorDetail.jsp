<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.GCONST" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18759,user.getLanguage());
String needfav ="1";
String needhelp ="";

String isOpenWorkflowStopOrCancel=GCONST.getWorkflowStopOrCancel();//是否开启流程暂停或取消配置

String monitorhrmid = (String)request.getParameter("monitorhrmid");
int typeid = Util.getIntValue(request.getParameter("typeid"),0);
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
int operatelevel=0;
RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
}
if (detachable == 1)
{
	//if (subcompanyid<=0)
	//{
	//	subcompanyid = Util.getIntValue(String.valueOf(session.getAttribute("managemonitor_subcompanyid")), -1);
	//}
	//if (subcompanyid == -1)
	//{
	//	subcompanyid = user.getUserSubCompany1();
	//}
	//session.setAttribute("managemonitor_subcompanyid", String.valueOf(subcompanyid));
	if(subcompanyid>0)
		operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowMonitor:All", subcompanyid);
}
else
{
	if (HrmUserVarify.checkUserRight("WorkflowMonitor:All", user))
		operatelevel = 2;
	else
	{
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}
//sql id modified by xwj for td2903 20051020

%>


<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
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

<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <TR>
    <TH align="left">
    <%=SystemEnv.getHtmlLabelName(18560,user.getLanguage())%>: 
    <a href='javaScript:openhrm(<%=monitorhrmid%>);' onclick='pointerXY(event);'>
    <%=Util.toScreen(ResourceComInfo.getResourcename(monitorhrmid),user.getLanguage())%>
    </a>
    </TH></TR>
</TBODY></TABLE>



<%
int perpage=20;
String tableString = "";
if(perpage <2) perpage=10;                                 
String backfields = " a.workflowid, "+
	                "b.workflowname, "+
	                "max(a.operatordate) as operatordate, "+
	                "max(a.operatortime) as operatortime, "+
	                "sum(convert(INT,isnull(a.isview,0))) as isview, "+
	                "sum(convert(INT,isnull(a.isintervenor,0))) as isintervenor, "+
	                "sum(convert(INT,isnull(a.isdelete,0))) as isdelete, "+
	                "sum(convert(INT,isnull(a.isForceDrawBack,0))) as isForceDrawBack, "+
	                "sum(convert(INT,isnull(a.isForceOver,0))) as isForceOver, "+
	                "sum(convert(INT,isnull(a.issooperator,0))) as issooperator ";
if(RecordSet.getDBType().equals("oracle"))
{
	backfields = " a.workflowid, "+
	                "b.workflowname, "+
	                "max(a.operatordate) as operatordate, "+
	                "max(a.operatortime) as operatortime, "+
	                "sum(to_number(nvl(a.isview,0))) as isview, "+
	                "sum(to_number(nvl(a.isintervenor,0))) as isintervenor, "+
	                "sum(to_number(nvl(a.isdelete,0))) as isdelete, "+
	                "sum(to_number(nvl(a.isForceDrawBack,0))) as isForceDrawBack, "+
	                "sum(to_number(nvl(a.isForceOver,0))) as isForceOver, "+
	                "sum(to_number(nvl(a.issooperator,0))) as issooperator ";
}
String fromSql  = " workflow_monitor_bound a,workflow_base b ";
String sqlWhere = "where a.monitorhrmid = " + monitorhrmid + " and a.workflowid = b.id ";
if(detachable==1)
{
	if(RecordSet.getDBType().equals("oracle"))
		sqlWhere += " and nvl(b.subcompanyid,0) = "+subcompanyid;
	else
		sqlWhere += " and isnull(b.subcompanyid,0) = "+subcompanyid;
	if(subcompanyid<1)
	{
		operatelevel = 2;
	}
}

if(RecordSet.getDBType().equals("oracle"))
	sqlWhere += " and nvl(a.monitortype,0) = "+typeid;
else
	sqlWhere += " and isnull(a.monitortype,0) = "+typeid;
String para2=monitorhrmid+"+"+user.getLanguage()+"+"+user.getUID()+"+"+operatelevel+"+"+detachable+"+"+typeid+"+"+subcompanyid;
String para3=monitorhrmid+"+column:workflowid+"+user.getLanguage()+"+"+user.getUID()+"+"+operatelevel+"+"+detachable;
String orderby=" b.workflowname";
String sqlgroupby = " a.workflowid,b.workflowname ";
boolean wfintervenor= GCONST.getWorkflowIntervenorByMonitor();
tableString =   " <table instanceid=\"workflowMoniterListTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\" sqlgroupby=\""+sqlgroupby+"\"  sqlprimarykey=\"workflowid\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18104,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\" />"+
                "           <col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"operatordate\" orderkey=\"operatordate,operatortime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" otherpara=\"column:operatortime\" />"+
                "        <col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(201,user.getLanguage())+SystemEnv.getHtmlLabelName(665,user.getLanguage())+"\" column=\"workflowid\" otherpara=\""+para2+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getCancleMoniter\" />"+
                "        <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21231,user.getLanguage())+"\" column=\"isview\" orderkey=\"isview\" otherpara=\""+para3+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getViewWorkflow\" />";
if(wfintervenor) tableString+="        <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21925,user.getLanguage())+"\" column=\"isintervenor\" orderkey=\"isintervenor\" otherpara=\""+para3+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getIntervenorWorkflow\" />";
   tableString+="        <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22284,user.getLanguage())+"\" column=\"isdelete\" orderkey=\"isdelete\" otherpara=\""+para3+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getDelWorkflow\" />"+
                "        <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22286,user.getLanguage())+"\" column=\"isForceDrawBack\" orderkey=\"isForceDrawBack\" otherpara=\""+para3+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getFBWorkflow\" />"+
                "        <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22285,user.getLanguage())+"\" column=\"isForceOver\" orderkey=\"isForceOver\" otherpara=\""+para3+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getFOWorkflow\" />";
if(isOpenWorkflowStopOrCancel.equals("1")){ 
   //是否开启流程暂停或取消配置	
   tableString+="        <col width=\"10%\"  text=\"暂停撤销启用权限\" column=\"issooperator\" orderkey=\"issooperator\" otherpara=\""+para3+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getSOWorkflow\" />";
}
   tableString+="       </head>"+
                " </table>";
%>
<TABLE width="100%">
    <tr>
        <td valign="top">
            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
        </td>
    </tr>
</TABLE>
<iframe  id="frmmain" name="frmmain" src="systemMonitorOperation.jsp" frameborder="0" style="height:0px;"></iframe>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

<script language="JavaScript">
function goBack() {
	document.location.href="/system/systemmonitor/workflow/systemMonitorStatic.jsp?typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>";
}
var showTableDiv  = document.getElementById('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("<div>");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = document.getElementById("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.posTop=pTop;
     message_Div1.style.posLeft=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
}
function setisview(ohrmid,oworkflowid,oisview){
    //showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%>");
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=upview&isview="+oisview+"&flowid="+oworkflowid+"&monitorhrmid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function setisIntervenor(ohrmid,oworkflowid,oisintervenor){
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=upintervenor&isintervenor="+oisintervenor+"&flowid="+oworkflowid+"&monitorhrmid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function setisDel(ohrmid,oworkflowid,oisdelete){
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=updel&isdelete="+oisdelete+"&flowid="+oworkflowid+"&monitorhrmid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function setisFB(ohrmid,oworkflowid,oisForceDrawBack){
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=upfb&isForceDrawBack="+oisForceDrawBack+"&flowid="+oworkflowid+"&monitorhrmid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function setisFO(ohrmid,oworkflowid,oisForceOver){
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=upfo&isForceOver="+oisForceOver+"&flowid="+oworkflowid+"&monitorhrmid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function setisSO(ohrmid,oworkflowid,oissooperator){
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=upso&issooperator="+oissooperator+"&flowid="+oworkflowid+"&monitorhrmid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function hiddenreceiviedPopup(){
    showTableDiv.style.display='none';
    oIframe.style.display='none';
}
function changecolor(obj,color){
    obj.style.color=color;
}
</script>

</BODY>
</HTML>