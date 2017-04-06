<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="OverTime" class="weaver.workflow.report.OverTimeComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>
<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(19029 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ; 
String userRights=shareRights.getUserRights("-3",user);//得到用户查看范围
if (userRights.equals("-100")){
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
    }
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%

    String requestIdd="";
  
    session.setAttribute("flowReport_userRights",userRights);
    int totalcount=0;
    String userId=Util.null2String(request.getParameter("userId"));//得到传入条件
    String flowId=Util.null2String(request.getParameter("flowId"));//得到传入条件
    session.setAttribute("flowReport_flowId",flowId);
    String tempNodeCounts=Util.null2String(request.getParameter("tempCount"));//得到传入条件
    String tempNodeId=Util.null2String(request.getParameter("tempNodeId"));//得到传入条件
    String tempNodeName=Util.null2String(request.getParameter("tempNodeName"));//得到传入条件
    String sqlCondition="";
    String objIds=Util.null2String(request.getParameter("objId"));
	String objNames=Util.null2String(request.getParameter("objNames"));
	
	String subsqlstr = Util.null2String(request.getParameter("subsqlstr"));
	
	//String flowStatus=Util.null2String(request.getParameter("flowStatus"));
    sqlCondition=" and workflow_currentoperator.userid="+userId;
    //if (!typeId.equals(""))  sqlCondition+=" and workflow_currentoperator.workflowtype="+typeId;
    if (!flowId.equals(""))  sqlCondition+=" and workflow_currentoperator.workflowid="+flowId+" ";
    //if (flowStatus.equals("1")) sqlCondition+=" and workflow_requestbase.currentnodetype<3 ";
    //if (flowStatus.equals("2")) sqlCondition+=" and workflow_requestbase.currentnodetype=3 ";
    if (!objIds.equals(""))  sqlCondition+=" and workflow_requestbase.requestid in ("+objIds+")  " ;
	//得到各个节点的平均时间
	
	if (!"".equals(subsqlstr)) {
		sqlCondition += subsqlstr;
	}
	    
    ArrayList requestIds=new ArrayList();
    ArrayList workFlowNodeCounts=new ArrayList();
    ArrayList nodeIds=new ArrayList();
    ArrayList tempNodeIds=new ArrayList();
    ArrayList tempCounts=new ArrayList();
    //ArrayList nodeNames=new ArrayList();
    ArrayList nodeNametemps=new ArrayList();
    ArrayList requestNames=new ArrayList();
if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2")){

String sql=" select workflow_currentoperator.requestid, workflow_currentoperator.nodeid,(select requestname from workflow_requestbase where "+ " requestid=workflow_currentoperator.requestid ),(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "+
"24*avg(case when isremark=0 then to_date(NVL2(workflow_currentoperator.operatedate,workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')),'YYYY-MM-DD HH24:MI:SS')"+
" when isremark=2 and workflow_currentoperator.operatedate is not null "+
" then to_date(workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,'YYYY-MM-DD HH24:MI:SS') end "+
" -to_date(workflow_currentoperator.receivedate||' '||workflow_currentoperator.receivetime,'YYYY-MM-DD HH24:MI:SS')) "+
" from workflow_currentoperator,workflow_requestbase,workflow_requestLog "+ 
" where workflow_requestbase.requestid=workflow_currentoperator.requestid " +
" and workflow_requestbase.requestid=workflow_requestLog.requestid " +
" and workflow_requestLog.operatedate is not null " +
" and workflow_requestbase.status is not null "+  
" and workflowtype>1 and workflow_currentoperator.isremark <> 0 and isremark<>4 and preisremark='0' "+sqlCondition+
" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid "+
" and  nodetype<3) "+
" group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid "+
" order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid ";
RecordSet.execute(sql);
}
else
	{
    RecordSet.executeProc("WorkFlowTypeNodeTime_Get",sqlCondition);
	}
    while (RecordSet.next())
    { String requestId = Util.null2String(RecordSet.getString("requestid")) ;        
      String nodeId = Util.null2String(RecordSet.getString("nodeid")) ;
      String nodeName=Util.null2String(RecordSet.getString(4)) ;
      String requestName=Util.null2String(RecordSet.getString(3)) ;
      float avgNode = Util.getFloatValue(RecordSet.getString(5),0) ;
    
      int flowIndex=requestIds.indexOf(requestId);
      if (flowIndex!=-1)
      {
       tempNodeIds.add(nodeId);
       tempCounts.add(""+avgNode);
       workFlowNodeCounts.set(flowIndex,tempCounts);
       nodeIds.set(flowIndex,tempNodeIds);
       //nodeNametemps.add(nodeName);
       //nodeNames.set(flowIndex,nodeNametemps);
      }
      else
      {tempNodeIds=new ArrayList();
       tempNodeIds=new ArrayList();
       tempCounts=new ArrayList();
       //nodeNametemps=new ArrayList();
       requestIds.add(""+requestId);
       requestNames.add(""+requestName);
       tempNodeIds.add(nodeId);
       nodeIds.add(tempNodeIds);
       tempCounts.add(""+avgNode);
       workFlowNodeCounts.add(tempCounts);
       //nodeNametemps.add(nodeName);
       //nodeNames.add(nodeNametemps);
      }      
    
    
    
    }
    //out.print(sqlCondition);
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
<FORM id=frmMain name=frmMain action=HandleTypeTimeAnalyse.jsp method=post>
<!--查询条件-->
<table  class="viewform">
<tr>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
    <td width="20%" class=field><a href="javaScript:openhrm(<%=userId%>);" onclick='pointerXY(event);'><%=resourceComInfo.getLastname(userId)%></a></td>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td width="20%" class=field><%=WorkTypeComInfo.getWorkTypename(WorkflowComInfo.getWorkflowtype(flowId))%></td>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
    <td width="20%" class=field><%=WorkflowComInfo.getWorkflowname(flowId)%></td>
    </tr> 
    <TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=8></TD></TR>
    <tr>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(19060,user.getLanguage())%></td>
   
    <td width="90%" class=field colspan="5">
    <BUTTON type='button' class=Browser onClick="onShowRequest('objId','objName')" name=showrequest></BUTTON>
    <SPAN id=objName>
	<%=objNames%>
	</SPAN>
	<input type=hidden name="objId" id="objId" value="<%=objIds%>">
	<input type=hidden name="objNames" id="objNames" value="<%=objNames%>"></td>

</tr>  
<TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=8></TD></TR>
</table>
<input type="hidden" name="tempCount" value="<%=tempNodeCounts%>">
<input type="hidden" name="tempNodeId" value="<%=tempNodeId%>">
<input type="hidden" name="tempNodeName" value="<%=tempNodeName%>">
<input type="hidden" name="flowId" value="<%=flowId%>">
<input type="hidden" name="userId" value="<%=userId%>">
<input type="hidden" name="subsqlstr" value="<%=subsqlstr%>">
</FORM>
<%
ArrayList nodeCounts=Util.TokenizerString(tempNodeCounts,",");
ArrayList nodeNames=Util.TokenizerString(tempNodeName,",");
ArrayList nodeIdss=Util.TokenizerString(tempNodeId,",");
boolean isLight = false ;
%>

<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
   
  <TR class=Header align=left>
  <TD rowspan="2" width="50"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></TD><!-- 具体流程-->
  <TD rowspan="2" width="200"><%=SystemEnv.getHtmlLabelName(19060,user.getLanguage())%></TD><!-- 具体流程-->
  <TD  colspan="<%=nodeNames.size()%>"><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></TD><!--节点-->
  </TR>
  <TR class=Header align=left>
  <%for (int m=0;m<nodeNames.size();m++) {%>
  <TD width="170"><%=nodeNames.get(m)%></TD>
  <%}%>
  </TR>
<!-- /TABLE>

<fieldset style="overflow:auto;height:80%;border-width:0px;">
<TABLE class=ListStyle cellspacing=1 border=1-->
 <tr class='<%=( isLight ? "datalight" : "datadark" )%>'><td width="50"><a href="javaScript:openhrm(<%=userId%>);" onclick='pointerXY(event);'><%=resourceComInfo.getLastname(userId)%></a></td><td width="200" colspan="<%=nodeCounts.size()+1%>"></td>
</tr>
  <%  
      for(int i=0;i<requestIds.size();i++){
       isLight = !isLight ; 
       requestIdd=(String)requestIds.get(i);   
 %>
 <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
 <td width="50">&nbsp;</td>
 <td width="200"><%=requestNames.get(i)%></td>
 <%
 ArrayList nodeIda=(ArrayList)nodeIds.get(i);
 ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(i);
 for (int k=0;k<nodeIdss.size();k++)
 {    int tempIdIndex=nodeIda.indexOf(""+nodeIdss.get(k));
      
 %>
 <td>
 <%if (tempIdIndex!=-1) {
  int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIdss.get(k)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIdss.get(k)),0);
  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIdss.get(k)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIdss.get(k)),0)/24;
  boolean  overT=false;
  
  if ((Util.getFloatValue(""+nodeCounta.get(tempIdIndex),0)>overTimes)&&overTimesb!=0) overT=!overT;
 %>
 <%if (overT) {%><font color="red"><% }%><%=Util.round(""+nodeCounta.get(tempIdIndex),1)%>(<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>)
 <%if (overT) {%>(<%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%>)</font><%}%>
 <%}%>&nbsp;
 </td>
 <%
 }%>
</tr>
 <TR class=Line><TD colspan="<%=nodeNames.size()+2%>" ></TD></TR>
 <%

 }
  isLight=!isLight;
 %>
 <%if("".equals(objIds)){%>
 <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
 <td width="50">&nbsp;</td>
 <td><%=SystemEnv.getHtmlLabelName(19059,user.getLanguage())%></td>
  <%for (int j=0;j<nodeCounts.size();j++) {
  
   int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIdss.get(j)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIdss.get(j)),0);
   float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIdss.get(j)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIdss.get(j)),0)/24;
   boolean  overT=false;
  
   if ((Util.getFloatValue(""+nodeCounts.get(j),0)>overTimes)&&overTimesb!=0) overT=!overT;
  %>
  <TD><%if (overT) {%><font color="red"><% }%><%=Util.round(""+nodeCounts.get(j),1)%>(<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>)
  <%if (overT) {%>(<%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%>)</font><%}%></TD>
  <%}%>
 </tr>
 <TR class=Line><TD colspan="<%=nodeNames.size()+2%>" ></TD></TR>
  <%}%>
<!-- /TABLE>
</fieldse-->
<!--详细内容结束-->

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

<script type="text/javascript">
function submitData()
{
   frmMain.submit();
}
function encode(str){
  return escape(str);
}
function onShowRequest(inputename,showname){
    var tmpids = "<%=objIds%>";
    var flowid = "<%=flowId%>";
    url=encode("/workflow/request/MultiRequestBrowserRight.jsp?resourceids="+tmpids+"&flowReport_flowId="+flowid);
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
            resourceids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
            resourcename = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
            sHtml = "";
            $G(inputename).value = resourceids;
            var idArray = resourceids.split(",");
            var nameArray = resourcename.split(",");
            for (var i=0; i<idArray.length; i++ ) {
	            var curid = idArray[i];
	            var curname = nameArray[i];
	            sHtml = sHtml + "<a href=/workflow/request/ViewRequest.jsp?requestid="+curid+">"+curname+"</a>&nbsp";
            }
            $G(showname).innerHTML = sHtml;
            $G("objNames").value = sHtml
        } else {
            $G(showname).innerHTML = "";
            $G(inputename).value = "";
            $G("objNames").value = "";
        }
    }
}
</script>
</body></html>