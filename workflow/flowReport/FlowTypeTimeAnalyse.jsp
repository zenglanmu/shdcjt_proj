<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
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
    String userRights=shareRights.getUserRights("-3",user);//得到用户查看范围
    session.setAttribute("flowReport_userRights",userRights);
    int totalcount=0;
    String typeId=Util.null2String(request.getParameter("flowType"));//得到传入条件
    String flowId=Util.null2String(request.getParameter("flowId"));//得到传入条件
    session.setAttribute("flowReport_flowId",flowId);
    String tempNodeCounts=Util.null2String(request.getParameter("nodeCounts"));//得到传入条件
  
    String subsqlstr = Util.null2String(request.getParameter("subsqlstr"));
    
    String tempNodeIdd=Util.null2String(request.getParameter("nodeIds"));//得到传入条件
  // out.print(tempNodeIdd);
    String sqlCondition="";
    String objIds=Util.null2String(request.getParameter("objId"));
	String objNames=Util.null2String(request.getParameter("objNames"));
	String flowStatus=Util.null2String(request.getParameter("flowStatus"));
	
	 if(!"".equals(subsqlstr)) sqlCondition += subsqlstr;
	
	 if (userRights.equals(""))
    {sqlCondition+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
    //sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+")  and hrmresource.status in (0,1,2,3) )";
    //if (!typeId.equals(""))  sqlCondition+=" and workflow_currentoperator.workflowtype="+typeId;
    if (!flowId.equals(""))  sqlCondition+=" and workflow_currentoperator.workflowid="+flowId+" ";
    if (flowStatus.equals("1")) sqlCondition+=" and workflow_requestbase.currentnodetype<3 ";
    if (flowStatus.equals("2")) sqlCondition+=" and workflow_requestbase.currentnodetype=3 ";
    if (!objIds.equals(""))  sqlCondition+=" and workflow_requestbase.requestid in ("+objIds+")  " ;
	//得到各个节点的平均时间
	//得到节点名称
	String tempNodeIddstr=tempNodeIdd+"-1";
    ArrayList nodeNamehead=new ArrayList();
	RecordSet.execute("select nodename from workflow_nodebase where id in ("+tempNodeIddstr+") order by id ");
    while (RecordSet.next())
	{
	nodeNamehead.add(RecordSet.getString(1));
	}
    ArrayList requestIds=new ArrayList();
    ArrayList workFlowNodeCounts=new ArrayList();
    ArrayList nodeIds=new ArrayList();
    ArrayList tempNodeIds=new ArrayList();
    ArrayList tempCounts=new ArrayList();
    ArrayList nodeNames=new ArrayList();
    ArrayList nodeNametemps=new ArrayList();
    ArrayList requestNames=new ArrayList();
	 if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
   {  
String sqls="select workflow_currentoperator.requestid, workflow_currentoperator.nodeid,(select requestname from workflow_requestbase where "+ 
	" requestid=workflow_currentoperator.requestid ),(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "+ 
"24*avg(case when isremark=0 then to_date(NVL2(workflow_currentoperator.operatedate,workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')),'YYYY-MM-DD HH24:MI:SS')"+
" when isremark=2 and workflow_currentoperator.operatedate is not null "+
" then to_date(workflow_currentoperator.operatedate||' '||workflow_currentoperator.operatetime,'YYYY-MM-DD HH24:MI:SS') end "+
" -to_date(workflow_currentoperator.receivedate||' '||workflow_currentoperator.receivetime,'YYYY-MM-DD HH24:MI:SS')) "+
" from workflow_currentoperator,workflow_requestbase,workflow_requestLog "+ 
" where workflow_requestbase.requestid=workflow_currentoperator.requestid " +
" and workflow_requestbase.requestid=workflow_requestLog.requestid " +
" and workflow_requestLog.operatedate is not null " +
" and workflow_requestbase.status is not null "+  
" and workflowtype>1  and isremark<>4 and preisremark='0' "+sqlCondition+
" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and   "+
" workflowid=workflow_currentoperator.workflowid and nodetype<>3) "+  
" group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid"+ 
" order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid";
RecordSet.execute(sqls);
//out.print(sqls);
   }
   else
   { RecordSet.executeProc("WorkFlowTypeNodeTime_Get",sqlCondition);
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
       nodeNametemps.add(nodeName);
       nodeNames.set(flowIndex,nodeNametemps);
      }
      else
      {tempNodeIds=new ArrayList();
       tempNodeIds=new ArrayList();
       tempCounts=new ArrayList();
       nodeNametemps=new ArrayList();
       requestIds.add(""+requestId);
       requestNames.add(""+requestName);
       tempNodeIds.add(nodeId);
       nodeIds.add(tempNodeIds);
       tempCounts.add(""+avgNode);
       workFlowNodeCounts.add(tempCounts);
       nodeNametemps.add(nodeName);
       nodeNames.add(nodeNametemps);
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
<FORM id=frmMain name=frmMain action=FlowTypeTimeAnalyse.jsp method=post>
<!--查询条件-->
<table  class="viewform">
<tr>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td width="15%" class=field><%=WorkTypeComInfo.getWorkTypename(typeId)%></td>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
    <td width="15%" class=field><%=WorkflowComInfo.getWorkflowname(flowId)%></td>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(19061,user.getLanguage())%></td>
    <td width="10%" class=field><select name="flowStatus">
    <option></option>
    <option value="1" <%if (flowStatus.equals("1")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(19062,user.getLanguage())%></option>
    <option value="2" <%if (flowStatus.equals("2")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></option>
    </select></td>
	</tr>  
	<TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=6></TD></TR>
	<tr><td width="10%"><%=SystemEnv.getHtmlLabelName(19060,user.getLanguage())%></td><td width="90%" class=field colspan=5><BUTTON type='button' class=Browser onClick="onShowRequest('objId','objName')" name=showrequest></BUTTON>
	<SPAN id=objName>
	<%=objNames%>
	</SPAN>
	<input type=hidden name="objId" id="objId" value="<%=objIds%>">
	<input type=hidden name="objNames" id="objNames" value="<%=objNames%>"></td></tr>
<TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=6></TD></TR>
</table>
<input type="hidden" name="nodeCounts" value="<%=tempNodeCounts%>">
<input type="hidden" name="nodeIds" value="<%=tempNodeIdd%>">
<input type="hidden" name="flowId" value="<%=flowId%>">
<input type="hidden" name="flowType" value="<%=typeId%>">
<input type="hidden" name="subsqlstr" value="<%=subsqlstr%>">
</FORM>
<%
ArrayList nodeCounts=Util.TokenizerString(tempNodeCounts,",");
ArrayList nodeTemps=Util.TokenizerString(tempNodeIdd,",");
%>
<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->  
  <TR class=Header align=left>
  <TD rowspan="2" width="200"><%=SystemEnv.getHtmlLabelName(19060,user.getLanguage())%></TD><!-- 具体流程-->
  <TD  colspan="<%=nodeCounts.size()%>"><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></TD><!--节点-->
  </TR>
  <TR class=Header align=left>
  <%for (int m=0;m<nodeCounts.size();m++) {%>
  <TD width="170"><span id="header<%=m%>"></span></TD>
  <%}%>
  </TR>
</TABLE>
<fieldset style="overflow:auto;height:85%;border-width:0px;">
<TABLE class=ListStyle cellspacing=1>
<tr><td></td>
<%for (int m=0;m<nodeCounts.size();m++) {%>
  <TD width="170"></TD>
  <%}%>
</tr>
  <%  boolean isLight = false ;
      for(int i=0;i<requestIds.size();i++){
       isLight = !isLight ; 
       requestIdd=(String)requestIds.get(i);   
 %>
 <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
 <td width="200"><%=requestNames.get(i)%></td>
 <%
 ArrayList nodeIda=(ArrayList)nodeIds.get(i);
 ArrayList nodeNamea=(ArrayList)nodeNames.get(i);
 ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(i);

for (int tempnodeIndex=0;tempnodeIndex<nodeTemps.size();tempnodeIndex++)
		  {
            String tempnode=(String)nodeTemps.get(tempnodeIndex);
			//String temmrequestnode=(String)nodeIda.get(k);
			int k=nodeIda.indexOf(tempnode);
			
			if (k!=-1) 
		 // }

 //for (int k=0;k<nodeIda.size();k++)
{
  int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIda.get(k)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIda.get(k)),0);
  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIda.get(k)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIda.get(k)),0)/24;
  boolean  overT=false;
  
  if ((Util.getFloatValue(""+nodeCounta.get(k),0)>overTimes)&&overTimesb!=0) overT=!overT;
 %>
 <td width="170"><%if (overT) {%><font color="red"><% }%><%=Util.round(""+nodeCounta.get(k),1)%>(<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>)
 <%if (overT) {%>(<%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%>)</font><%}%></td>
 <%
 }
 else {%>
<td width="170"></td>
<%}
		  }%>
</tr>
 <TR class=Line><TD colspan="<%=nodeCounts.size()+1%>" ></TD></TR>
 <%

 }
  isLight=!isLight;
 %>
 <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
 <td><%=SystemEnv.getHtmlLabelName(19059,user.getLanguage())%></td>
  <%for (int j=0;j<nodeCounts.size();j++) {
  int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeTemps.get(j)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeTemps.get(j)),0);
  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeTemps.get(j)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeTemps.get(j)),0)/24;
  boolean  overT=false;
  
  if ((Util.getFloatValue(""+nodeCounts.get(j),0)>overTimes)&&overTimesb!=0) overT=!overT;
  %>
  <TD>
  <%if (overT) {%><font color="red"><% }%><%=Util.round(""+nodeCounts.get(j),1)%>(<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>)
  <%if (overT) {%>(<%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%>)</font><%}%></TD>
  <%}%>
 </tr>
 <TR class=Line><TD colspan="<%=nodeCounts.size()+1%>" ></TD></TR>
</TABLE>
</fieldse>
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

<script>
<% if (requestIds.size()>0) {
//ArrayList nodeNamet=(ArrayList)nodeNames.get(0);
 for (int n=0;n<nodeNamehead.size();n++)
 {
%>
document.all("header"+<%=n%>).innerHTML="<%=nodeNamehead.get(n)%>";
<%}
}%>
function submitData()
{
   frmMain.submit();
}
function encode(str){
  return escape(str);
}
</script>
<script type="text/javascript">
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
