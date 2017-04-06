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
String userRights=shareRights.getUserRights("-3",user);//得到用户查看范围
  if (userRights.equals("-100"))
    {
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

    String typeid="";
	String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
    String newremarkwfcount0="";
    String newremarkwfcount1="";
	String workflowname="";
   
    ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();     //总计
	ArrayList workflowcountst=new ArrayList();     //总计流程类型
	ArrayList nodeTypes=new ArrayList();           //节点类型
    ArrayList newremarkwfcounts0=new ArrayList(); 
    ArrayList wftypecounts0=new ArrayList(); 
 
    ArrayList wftypess=new ArrayList();
  
    int totalcount=0;
    String typeId=Util.null2String(request.getParameter("typeId"));//得到搜索条件
    String crefromdate = Util.null2String(request.getParameter("crefromdate"));//得到搜索条件
	String cretodate = Util.null2String(request.getParameter("cretodate"));//得到搜索条件
	String guifromdate = Util.null2String(request.getParameter("guifromdate"));//得到搜索条件
	String guitodate = Util.null2String(request.getParameter("guitodate"));//得到搜索条件
    String sqlCondition="";
    String sqlCondition_t="";
   
    String operationtemp = Util.null2String(request.getParameter("operation"));
	if("".equals(operationtemp)) sqlCondition += " and 1=2";
    
    if (userRights.equals(""))
    {sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
     sqlCondition_t=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";   
    }
    else
    {sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
     sqlCondition_t=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";   
    }
    
    if (!typeId.equals("")){
		sqlCondition += " and workflow_currentoperator.workflowtype=" + typeId;
		sqlCondition_t += " and workflow_currentoperator.workflowtype=" + typeId;
	}
	String subsqlstr = "";
	
	//创建时间
	if(!"".equals(crefromdate)){
	    sqlCondition += " and workflow_requestbase.createdate >='" +crefromdate+ "'";
		subsqlstr += " and workflow_requestbase.createdate >='" +crefromdate+ "'";
	}
	if(!"".equals(cretodate)){
	    sqlCondition += " and workflow_requestbase.createdate <='" +cretodate+ "'";
		subsqlstr += " and workflow_requestbase.createdate <='" +cretodate+ "'";
	}
	
	//归档时间
	if (!guifromdate.equals("")||!guitodate.equals("")) {
	   sqlCondition+=" and workflow_requestbase.currentnodetype='3'";
	   subsqlstr += " and workflow_requestbase.currentnodetype='3'";
	}
	if(!"".equals(guifromdate)){
	    sqlCondition += " and workflow_requestbase.lastoperatedate >='" +guifromdate+ "'";
		subsqlstr += " and workflow_requestbase.lastoperatedate >='" +guifromdate+ "'";
	}
	if(!"".equals(guitodate)){
	    sqlCondition += " and workflow_requestbase.lastoperatedate <='" +guitodate+ "'";
		subsqlstr += " and workflow_requestbase.lastoperatedate <='" +guitodate+ "'";
	}
	
    String sql="select workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid,  "+
    " count(distinct workflow_requestbase.requestid) workflowcount from "+
    " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "+
    " and (workflow_requestbase.status is not null and workflow_requestbase.status != ' ') and workflow_currentoperator.workflowtype>1  and preisremark='0' and isremark<>4 "+sqlCondition+" group by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "+
    " order by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
	//out.print(sql);
	RecordSet.executeSql(sql) ;

	while(RecordSet.next()){       
        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
       
		int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
            int wfindex = workflows.indexOf(theworkflowid) ;
            if(wfindex != -1) {
                workflowcounts.set(wfindex,""+(Util.getIntValue((String)workflowcounts.get(wfindex),0)+theworkflowcount)) ;
            }else{
                workflows.add(theworkflowid) ;
                workflowcounts.add(""+theworkflowcount) ;	
            }

            int wftindex = wftypes.indexOf(theworkflowtype) ;
            if(wftindex != -1) {
            wftypecounts.set(wftindex,""+(Util.getIntValue((String)wftypecounts.get(wftindex),0)+theworkflowcount)) ;
            }
            else {
                wftypes.add(theworkflowtype) ;
                wftypecounts.add(""+theworkflowcount) ;
            }

           
        }
	}
	
	//得到各个节点的平均时间
	
    ArrayList workFlowIds=new ArrayList();
    ArrayList workFlowNodeCounts=new ArrayList();
    ArrayList nodeIds=new ArrayList();
    ArrayList tempNodeIds=new ArrayList();
    ArrayList tempCounts=new ArrayList();
    ArrayList nodeNames=new ArrayList();
    ArrayList nodeNametemps=new ArrayList();
   if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
   { 
	   
RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where trim(operatedate)='' "+sqlCondition_t);
	   
String sqls="select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,"+
"(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "+
"24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
"-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "+
"from workflow_currentoperator,workflow_requestbase  where workflow_requestbase.requestid=workflow_currentoperator.requestid "+
"and (workflow_requestbase.status is not null) and workflowtype>1 and isremark<>4 and preisremark='0' "+ sqlCondition+
"and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  "+
"workflowid=workflow_currentoperator.workflowid and nodetype<>3) "+
"group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "+
"order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid";
RecordSet.execute(sqls);

   }
   else
   {
	   RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where rtrim(ltrim(operatedate))='' "+sqlCondition_t); 
	   RecordSet.executeProc("WorkFlowNodeTime_Get",sqlCondition);
   }
    while (RecordSet.next())
    { String workFlowId = Util.null2String(RecordSet.getString("workflowid")) ;        
      String nodeId = Util.null2String(RecordSet.getString("nodeid")) ;
      String nodeName=Util.null2String(RecordSet.getString(3)) ;
      float avgNode = Util.getFloatValue(RecordSet.getString(4),0) ;
      int flowIndex=workFlowIds.indexOf(workFlowId);
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
       workFlowIds.add(""+workFlowId);
       tempNodeIds.add(nodeId);
       nodeIds.add(tempNodeIds);
       tempCounts.add(""+avgNode);
       workFlowNodeCounts.add(tempCounts);
       nodeNametemps.add(nodeName);
       nodeNames.add(nodeNametemps);
      }      
    
    
    
    }
    //System.out.print(sqlCondition);
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
<FORM id=frmMain name=frmMain action=FlowTimeAnalyse.jsp method=post>
<input type="hidden" name="operation" value="search">
<!--查询条件-->
<table class="viewform">
	<tr>
		<td width="8%">
			<%=SystemEnv.getHtmlLabelName(15433, user.getLanguage())%>
		</td>
		<td class=field width="25%">
			<select class=inputstyle name=typeId>
				<option value=""></option>
				<%
				while (WorkTypeComInfo.next()) {
				  if (!WorkTypeComInfo.getWorkTypeid().equals("1")) {
					String checktmp = "";
				    if (typeId.equals(WorkTypeComInfo.getWorkTypeid()))
						checktmp = " selected";
				%>
				<option value="<%=WorkTypeComInfo.getWorkTypeid()%>"
					<%=checktmp%>>
					<%=WorkTypeComInfo.getWorkTypename()%>
				</option>
				<%
					}
				}
				%>
			</select>
		</td>
		<td width="5%">
		<%=SystemEnv.getHtmlLabelName(1339, user.getLanguage())%>
		</td>
		<td class=field width="25%">
		    <BUTTON type="button" class=calendar onclick=getDate(crefromdatespan,crefromdate)></BUTTON>
			<SPAN id=crefromdatespan><%=crefromdate%></SPAN> 										
			&nbsp;- &nbsp;
			<BUTTON type="button" class=calendar onclick=getDate(cretodatespan,cretodate)></BUTTON>
			<SPAN id=cretodatespan><%=cretodate%></SPAN>
			<input type="hidden" name="crefromdate" value="<%=crefromdate%>">
			<input type="hidden" name="cretodate" value="<%=cretodate%>">
		</td>
		<td width="5%">
		<%=SystemEnv.getHtmlLabelName(251, user.getLanguage())+SystemEnv.getHtmlLabelName(277, user.getLanguage())%>
		</td>
		<td class=field width="25%">
		    <BUTTON type="button" class=calendar  onclick=getDate(guifromdatespan,guifromdate)></BUTTON>
			<SPAN id=guifromdatespan><%=guifromdate%></SPAN> 										
			&nbsp;- &nbsp;
			<BUTTON type="button" class=calendar onclick=getDate(guitodatespan,guitodate)></BUTTON>
			<SPAN id=guitodatespan><%=guitodate%></SPAN>
			<input type="hidden" name="guifromdate" value="<%=guifromdate%>">
			<input type="hidden" name="guitodate" value="<%=guitodate%>">
		</td>
		</tr>
		<TR class=Separartor style="height:2px">
			<TD class="Line" COLSPAN=6></TD>
		</TR>
	</table>
</FORM>
<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
  <COLGROUP> 
  <col width="20%"> 
  <col width="20%"> 
  <col width="60%"> 
  <TR class=Header align=left>
  <TD><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></TD><!-- 流程类型-->
  <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18561,user.getLanguage())%>)
  </TD><!--工作流-->
  <TD><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></TD><!--节点-->
  </TR>
</TABLE>
<fieldset style="overflow:auto;height:90%;border-width:0px;">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP> 
  <col width="20%"> 
  <col width="20%"> 
  <col width="60%"> 
  <%  boolean isLight = false ;
      for(int i=0;i<wftypes.size();i++){
       isLight = !isLight ; 
       typeid=(String)wftypes.get(i);
       typecount=(String)wftypecounts.get(i);
       typename=WorkTypeComInfo.getWorkTypename(typeid);
 %>
 <tr><td style="padding:1px;"></td><td style="padding:1px;"></td><td style="padding:1px;"></td></tr>
 <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
 <td valign="top"><%=typename%></td>
 <td colspan="2" style="padding:0px;">
 <table class=ListStyle cellspacing=1>
 <%for(int j=0;j<workflows.size();j++){
     isLight = !isLight ;
     workflowid=(String)workflows.get(j);
     String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
     if(!curtypeid.equals(typeid))	continue;
     workflowname=WorkflowComInfo.getWorkflowname(workflowid); 
     String tempNodeCounts=""; 
     String tempNodeIdd="";
     int indexId=workFlowIds.indexOf(workflowid);
     if (indexId!=-1)
     {
      ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
	  ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
	  for (int l=0;l<nodeIda.size();l++)
	  {
	  tempNodeCounts+=nodeCounta.get(l)+",";
	  tempNodeIdd+=nodeIda.get(l)+",";
	  }
     }
 %>
 
 <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
 <td width="26%"><a href="FlowTypeTimeAnalyse.jsp?nodeIds=<%=tempNodeIdd%>&flowType=<%=curtypeid%>&flowId=<%=workflowid%>&nodeCounts=<%=tempNodeCounts%>&subsqlstr=<%=subsqlstr%>" ><%=workflowname%></a>(<%=workflowcounts.get(j)%>)</td>
 <td width="74%">
 <table class=ListStyle cellspacing=1 >
 <tr class='<%=( isLight ? "datalight" : "datadark" )%>' >
 <%
 if (indexId!=-1)
 {
 ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
 ArrayList nodeNamea=(ArrayList)nodeNames.get(indexId);
 for (int k=0;k<nodeIda.size();k++)
 {
 %>
 <td width="170"><%=nodeNamea.get(k)%></td>
 <%
 }%>
 
 <%}
 %>
</tr>
 </table>
 </td>
 </tr>
  <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
  <td width="26%"><%=SystemEnv.getHtmlLabelName(19059,user.getLanguage())%></td>
  <td width="74%">
 <table class=ListStyle cellspacing=1 >
 <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
<%
 if (indexId!=-1)
 {
 ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
 ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
 for (int k=0;k<nodeIda.size();k++)
 {int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIda.get(k)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIda.get(k)),0);
  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIda.get(k)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIda.get(k)),0)/24;
  boolean  overT=false;
  
  if ((Util.getFloatValue(""+nodeCounta.get(k),0)>overTimes)&&overTimesb!=0) overT=!overT;
 %>
 <td width="170"><%if (overT) {%><font color="red"><% }%><%=Util.round(""+nodeCounta.get(k),1)%>(<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>)
 <%if (overT) {%>(<%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%>)</font><%}%></td>
 <%
 }%>
 
<% }
 %>
</tr>
 </table>
 </td>
  </tr>
 <TR class=Line><TD style="padding:1px;" colspan="2" ></TD></TR>
 <%
 workflows.remove(j);
 workflowcounts.remove(j);
 j--;
 }%>

 </table>
 </td>
 </tr>
 <TR class=Line><TD style="padding:1px;" colspan="3" ></TD></TR>
 <%
 
 
 }%>
</TABLE>
</fieldset>
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
function submitData()
{
   frmMain.submit();
}
</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</body></html>
