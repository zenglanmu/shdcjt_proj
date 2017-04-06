<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
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
String titlename = SystemEnv.getHtmlLabelName(19030 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ; 
String userRights=shareRights.getUserRights("-4",user);//得到用户查看范围
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

<%
    OverTime.removeBrowserCache();
    String typeid="";
	//String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
	String workflowname="";
    ArrayList temp=new ArrayList();  
    ArrayList wftypes=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();     //总计
	ArrayList nodeTypes=new ArrayList();           //节点类型
    ArrayList userIds=new ArrayList();
    ArrayList wftypess=new ArrayList();
    ArrayList wfUsers=new ArrayList();
    ArrayList flowUsers=new ArrayList();
    
   //得到各个节点的平均时间
	
    ArrayList workFlowNodes=new ArrayList();
    ArrayList workFlowUserIds=new ArrayList();
    ArrayList workFlowNodeCounts=new ArrayList();
    ArrayList nodeIds=new ArrayList();
    ArrayList tempNodeIds=new ArrayList();
    ArrayList tempCounts=new ArrayList();
     //系统平耗时

    ArrayList tempCountsx=new ArrayList();
    ArrayList tempSum=new ArrayList();
    ArrayList nodeNames=new ArrayList();
    ArrayList nodeNametemps=new ArrayList();
    ArrayList nodeUserIds=new ArrayList();

    int totalcount=0;
    String typeId=Util.null2String(request.getParameter("typeId"));//得到搜索条件
    String flowId=Util.null2String(request.getParameter("flowId"));//得到搜索条件
    String objIds=Util.null2String(request.getParameter("objId"));//得到搜索条件
    
    String fromcredate = Util.null2String(request.getParameter("fromcredate"));//得到创建时间搜索条件
	String tocredate = Util.null2String(request.getParameter("tocredate"));//得到创建时间搜索条件
    String fromadridate = Util.null2String(request.getParameter("fromadridate"));//得到到达搜索条件
	String toadridate = Util.null2String(request.getParameter("toadridate"));//得到到达搜索条件
	String objStatueType = Util.null2String(request.getParameter("objStatueType"));//得到流程状态搜索条件
   
    String showObj="none";
	
    String subsqlstr = "";
    
    String tempsql="";
    String tempsql1="";
    int objType1=Util.getIntValue(request.getParameter("objType"),0);
	String objNames=Util.null2String(request.getParameter("objNames"));
    String sqlCondition=" and 1=1";
    int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
    int	perpage=10;
   
    boolean hasNextPage=false;
	int RecordSetCounts = 0;
   if (objType1!=0)
   {
    switch (objType1){
	        case 1:
	        //tempsql="select id from hrmresource where  id in ("+objIds+") ";
			sqlCondition=" and userid in (select id from hrmresource where  userid in ("+objIds+") )"  ;
	        break;
	        case 2:
	        //tempsql=" select id from hrmresource where departmentid in ("+objIds+") ";
	        sqlCondition=" and userid in  (select id from hrmresource where  departmentid in ("+objIds+") )" ;
	        break;
	        case 3:
	        //tempsql=" select id from hrmresource where  subcompanyid1 in ("+objIds+") ";
	        sqlCondition=" and userid in (select id from hrmresource where  subcompanyid1 in ("+objIds+") )" ;
	        break;
	}
	
	if (userRights.equals(""))
    {sqlCondition+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition+=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
   
	if (!typeId.equals("")&&!typeId.equals("0")){
		sqlCondition+=" and workflow_currentoperator.workflowtype="+typeId;
		subsqlstr += " and workflow_currentoperator.workflowtype ="+typeId;
	}
    if (!flowId.equals("")){
		sqlCondition+=" and workflow_currentoperator.workflowid="+flowId;
		subsqlstr += " and workflow_currentoperator.workflowid ="+flowId;
	}
    
    if(!"".equals(fromcredate)) {
	    sqlCondition += " and workflow_requestbase.createdate >='" +fromcredate+ "'";
		subsqlstr += " and workflow_requestbase.createdate >='" +fromcredate+ "'";
	}
	if(!"".equals(tocredate)) {
	    sqlCondition += " and workflow_requestbase.createdate <='" +tocredate+ "'";
        subsqlstr += " and workflow_requestbase.createdate <='" +tocredate+ "'";
	}
	if(!"".equals(fromadridate)) {
		sqlCondition += " and workflow_currentoperator.receivedate >='" +fromadridate+ "'";
		subsqlstr += " and workflow_currentoperator.receivedate >='" +fromadridate+ "'";
	}
	if(!"".equals(toadridate)) {
		sqlCondition += " and workflow_currentoperator.receivedate <='" +toadridate+ "'";
		subsqlstr += " and workflow_currentoperator.receivedate <='" +toadridate+ "'";
	}
	if(!"".equals(objStatueType)) {
		if("1".equals(objStatueType)) {
			sqlCondition += " and workflow_requestbase.currentnodetype ='3'";
            subsqlstr += " and workflow_requestbase.currentnodetype ='3'";
		} else {
			sqlCondition += " and workflow_requestbase.currentnodetype <>'3'";
            subsqlstr += " and workflow_requestbase.currentnodetype <>'3'";
		}
	}

     if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2")){
	 
	   String sql="select workflow_currentoperator.userid,workflow_currentoperator.workflowtype,workflow_currentoperator.workflowid,  "+
    " count(distinct workflow_requestbase.requestid) workflowcount from "+
    " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "+
    " and (workflow_requestbase.status is not null ) and workflow_currentoperator.workflowtype>1  "+sqlCondition+" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and workflowid=workflow_currentoperator.workflowid and nodetype<>3) group by "+ 
	" workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "+
    " order by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
	
	RecordSet.executeSql(sql) ;
	 }
	 else
	   {
	String sql="select workflow_currentoperator.userid,workflow_currentoperator.workflowtype,workflow_currentoperator.workflowid,  "+
    " count(distinct workflow_requestbase.requestid) workflowcount from "+
    " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "+
    " and (workflow_requestbase.status is not null and workflow_requestbase.status!='') and workflow_currentoperator.workflowtype>1 and preisremark='0' and isremark<>4 "+sqlCondition+" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and workflowid=workflow_currentoperator.workflowid and nodetype<>3) group by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid "+
    " order by workflow_currentoperator.userid,workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";

	RecordSet.executeSql(sql) ;
	   }
	while(RecordSet.next()){       
        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
        String userid=Util.null2String(RecordSet.getString("userid")) ;
		int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
		
        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
            workflows.add(theworkflowid) ;
            workflowcounts.add(""+theworkflowcount);
            flowUsers.add(""+userid);
            int userIndex=userIds.indexOf(userid);
            int tempIndex=temp.indexOf(userid+"$"+theworkflowtype);
            if (userIndex!=-1)
            {
            if(tempIndex != -1) 
            {}
            else
            {
            temp.add(userid+"$"+theworkflowtype); 
            wftypes.add(theworkflowtype) ;
            wfUsers.add(userid);
            }
           }
           else
           {
           userIds.add(""+userid);
           temp.add(userid+"$"+theworkflowtype);
           wftypes.add(theworkflowtype) ;
           wfUsers.add(userid);
          
          }
        }
	}
if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2")){
RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where trim(operatedate)='' ");
	
String sql="select workflow_currentoperator.userid,workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid),"+
"24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
"-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "+
" from workflow_currentoperator,workflow_requestbase "+
" where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null  "+        
"  ) and workflowtype>1 and workflow_currentoperator.isremark <> 0 and isremark<>4 and preisremark='0' "+sqlCondition +
" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  "+  
" workflowid=workflow_currentoperator.workflowid and nodetype<>3) "+ 
"group by  workflow_currentoperator.userid,workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "+
"order by  workflow_currentoperator.userid,workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid ";
RecordSet.execute(sql);

}
else
	   {
	RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where rtrim(ltrim(operatedate))='' ");

    RecordSet.executeProc("PersonNodeTime_Get",sqlCondition);
	   }
    while (RecordSet.next())
    { String userId=Util.null2String(RecordSet.getString("userid")) ; 
      String workFlowId = Util.null2String(RecordSet.getString("workflowid")) ;        
      String nodeId = Util.null2String(RecordSet.getString("nodeid")) ;
      String nodeName=Util.null2String(RecordSet.getString(4)) ;
      float avgNode = Util.getFloatValue(RecordSet.getString(5),0) ;
      int flowIndex=workFlowUserIds.indexOf(userId+"$"+workFlowId);
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
       workFlowUserIds.add(userId+"$"+workFlowId);
       tempNodeIds.add(nodeId);
       nodeIds.add(tempNodeIds);
       tempCounts.add(""+avgNode);
       workFlowNodeCounts.add(tempCounts);
       nodeNametemps.add(nodeName);
       nodeNames.add(nodeNametemps);
      }     
     
    } 
     //系统平均耗时   (是否考虑在其他页面操作，点击时才出现???,by ben 太耗性能了！:（  )
if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2")){
	
	String sql=" select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), "+
"24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
"-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) "+
" from workflow_currentoperator,workflow_requestbase "+
" where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null ) "+
"	and workflowtype>1 and workflow_currentoperator.isremark <> 0 and isremark<>4 and preisremark='0' "+
" and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and "+ " workflowid=workflow_currentoperator.workflowid and nodetype<>3) "+
" group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid "+
" order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid ";
	RecordSet.execute(sql);
}
else {
       RecordSet.executeProc("WorkFlowSysNodeTime_Get",sqlCondition);
}
       while (RecordSet.next())
      {

       workFlowNodes.add(""+Util.null2String(RecordSet.getString("nodeid"))); 
       tempCountsx.add(""+Util.getFloatValue(RecordSet.getString(4),0));
     
      }     
    
    }
   
    //System.out.println(sqlCondition);
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
<FORM id=frmMain name=frmMain action=HandleRequestAnalyse.jsp method=post>
<input type="hidden" name="pagenum" value=''>
<!--查询条件-->
<table  class="viewform">
<tr>
    <td width="10%">
    <select class=inputstyle  name=objType onchange="onChangeType()">
    <option value="1" <%if (objType1==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
    <option value="2" <%if (objType1==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
    <option value="3" <%if (objType1==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
    </select>
    </td>
    <td class=field width="30%">
    
    <BUTTON type=button class=Browser <%if (objType1==2||objType1==3) {%>  style="display:none"  <%}%> onClick="onShowResource('objId','objName', 'objNames')" name=showresource></BUTTON> 
	<BUTTON type=button class=Browser <%if (objType1==0||objType1==1||objType1==3) {%> style="display:none" <%}%> onClick="onShowDepartment('objId','objName', 'objNames')" name=showdepartment></BUTTON> 
    <BUTTON type=button class=Browser <%if (objType1==0||objType1==1||objType1==2) {%> style="display:none"  <%}%> onclick="onShowBranch('objId','objName', 'objNames')" name=showBranch></BUTTON>
	<SPAN id=objName>
	<%=objNames%>
	</SPAN><SPAN id=nameimage>
	<%if (objIds.equals("")) {%>
	<IMG src='/images/BacoError.gif' align=absMiddle></IMG>
	<%}%>
	</SPAN> 
	<input type=hidden name="objId" id="objId" value="<%=objIds%>">
	<input type=hidden name="objNames" id="objNames" value="<%=objNames%>">
	</td>
	
	<td width="10%">
	 <%=SystemEnv.getHtmlLabelName(19061,user.getLanguage())%>
	</td>
	<td class=field width="40%">
    <select class=inputstyle name=objStatueType>
    <option value=""></option>
    <option value="1" <%if("1".equals(objStatueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18800,user.getLanguage())%></option>
    <option value="2" <%if("2".equals(objStatueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></option>   
    </select>
	</td>
	
</tr>
<TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=4></TD></TR>
<tr>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></td>
    <td class=field width="40%">
    <BUTTON type=button class=calendar id=SelectDate1 onclick=getDate(fromcredatespan,fromcredate)></BUTTON>
	<SPAN id=fromcredatespan><%=fromcredate%></SPAN> 										
	&nbsp;- &nbsp;
	<BUTTON type=button class=calendar id=SelectDate2 onclick=getDate(tocredatespan,tocredate)></BUTTON>
	<SPAN id=tocredatespan><%=tocredate%></SPAN>
	<input type="hidden" name="fromcredate" value="<%=fromcredate%>">
	<input type="hidden" name="tocredate" value="<%=tocredate%>">
	</td>
    
    <td width="10%"><%=SystemEnv.getHtmlLabelName(2196,user.getLanguage())%></td>
    <td class=field width="40%">
    <BUTTON type=button class=calendar id=SelectDate3 onclick=getDate(fromadridatespan,fromadridate)></BUTTON>
	<SPAN id=fromadridatespan><%=fromadridate%></SPAN> 										
	&nbsp;- &nbsp;
	<BUTTON type=button class=calendar id=SelectDate4 onclick=getDate(toadridatespan,toadridate)></BUTTON>
	<SPAN id=toadridatespan><%=toadridate%></SPAN>
	<input type="hidden" name="fromadridate" value="<%=fromadridate%>">
	<input type="hidden" name="toadridate" value="<%=toadridate%>">
	</td>
</tr>  
<TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=4></TD></TR>
<tr>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field width="30%">
	<input class=wuiBrowser type=hidden name="typeId" id="typeId" value="<%=typeId%>"
	_url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
	_displayText="<%=WorkTypeComInfo.getWorkTypename(""+typeId)%>"
	>
    <!-- select class=inputstyle name=typeId onchange="chageFlowType(this,flowIds,flowId)">
    <option value=""></option>
    <%
         while(WorkTypeComInfo.next()){
         if (!WorkTypeComInfo.getWorkTypeid().equals("1"))
         {
     	String checktmp = "";
     	if(typeId.equals(WorkTypeComInfo.getWorkTypeid()))
     		checktmp=" selected";
		%>
		<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=checktmp%>><%=WorkTypeComInfo.getWorkTypename()%></option>
		<%
		}
		}
		%>
		</select-->
		</td>
    
    <td width="10%"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
    <td class=field width="30%">
	<BUTTON type="button" class=Browser onClick="onShow2('flowId','flowName')" name=showflow></BUTTON>
    <SPAN id=flowName>
	<%=WorkflowComInfo.getWorkflowname(""+flowId)%>
	</SPAN>
	<input type=hidden name="flowId" id="flowId" value="<%=flowId%>">
	
    <!-- select class=inputstyle name=flowId style="width:200">
    <option value=""></option>
    </select>
    <select class=inputstyle name=flowIds style="display:none">
    <%
    while(WorkflowComInfo.next()){
         
     	String tempFlow = WorkflowComInfo.getWorkflowid();
     	String tempType=WorkflowComInfo.getWorkflowtype(tempFlow);
     		
	%>
	<option value="<%=tempType+"$"+WorkflowComInfo.getWorkflowid()%>"><%=WorkflowComInfo.getWorkflowname()%></option>
	<%
	}
	
	%>
	</select-->
	</td>
</tr>  
<TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=4></TD></TR>
</table>

	
	<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
  
  <TR class=Header align=left>
  <TD width="80"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></TD><!-- 人员-->
  <TD width="200"><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></TD><!-- 流程类型-->
  <TD width="150"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18561,user.getLanguage())%>)
  </TD><!--工作流-->
  <TD width="500"><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></TD><!--节点-->
  </TR>
   <TR class=Line><TD colspan="4" ></TD></TR>
<!-- /TABLE-->
<!-- fieldset style="overflow:auto;height:90%;border-width:0px;">
<TABLE class=ListStyle cellspacing=1 -->
  <%if (objType1!=0) {%>
  <%  boolean isLight = false ;
      boolean isLight1 = false ;
      boolean isLight2 = false ;
      for(int i=0;i<userIds.size();i++){
       isLight = !isLight ; 
       String objId=(String)userIds.get(i);
      
       //typename=WorkTypeComInfo.getWorkTypename(typeid);
 %>
 <tr><td></td><td></td><td></td><td></td></tr>
 <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
 <td valign="top" width="80"><a href="javaScript:openhrm(<%=objId%>);" onclick='pointerXY(event);'><%=resourceComInfo.getLastname(objId)%></a></td>
 <td colspan="3">
 <table class=ListStyle cellspacing=0 >
 <%for(int j=0;j<wftypes.size();j++){
 isLight2 = !isLight2 ; 
 String tempObjId=""+wfUsers.get(j);
 String wfId=""+wftypes.get(j);
 if (!tempObjId.equals(objId)) continue;
 //isLight=!isLight;
 %>
<tr><td></td><td></td><td></td></tr>
<tr class='<%=( isLight2 ? "datalight" : "datadark" )%>'>
<td valign="top" width="170"><%=WorkTypeComInfo.getWorkTypename(wfId)%></td>
<td colspan="2">
<table class=ListStyle cellspacing=1>
 <%for(int k=0;k<workflows.size();k++){
     isLight1 = !isLight1 ;
     workflowid=(String)workflows.get(k);
     String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
	 String tempUser=""+flowUsers.get(k);
	 if(!curtypeid.equals(wfId)||!tempUser.equals(objId))	continue;		
     workflowname=WorkflowComInfo.getWorkflowname(workflowid); 
     String tempNodeCounts=""; 
     String tempNodeIdSend="";
     String tempNodeNameSend="";
     int indexId=workFlowUserIds.indexOf(tempUser+"$"+workflowid);
     if (indexId!=-1)
     {
      ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
	  ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
	  ArrayList nodeNameas=(ArrayList)nodeNames.get(indexId);
	  for (int l=0;l<nodeIda.size();l++)
	  {
	  tempNodeCounts+=nodeCounta.get(l)+",";
	  tempNodeIdSend+=nodeIda.get(l)+",";
	  tempNodeNameSend+=nodeNameas.get(l)+",";
	  }
     }
     
 %>
 
 <tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
 <td width="150"><a href="HandleTypeTimeAnalyse.jsp?tempNodeId=<%=tempNodeIdSend%>&tempNodeName=<%=tempNodeNameSend%>&tempCount=<%=tempNodeCounts%>&flowId=<%=workflowid%>&userId=<%=objId%>&subsqlstr=<%=subsqlstr%>"><%=workflowname%></a>(<%=workflowcounts.get(k)%>)</td>
 <td width="500">
 <table class=ListStyle cellspacing=0>
 <tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
 <%
 if (indexId!=-1)
 {
 ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
 ArrayList nodeNamea=(ArrayList)nodeNames.get(indexId);
 for (int m=0;m<nodeIda.size();m++)
 {
 %>
 <td width="170"><%=nodeNamea.get(m)%></td>
 <%
 }%>
 <%}
 %>
</tr>
 </table>
 </td>
 </tr>
<%isLight1=!isLight1;%>
 <tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
 <td width="150"><%=SystemEnv.getHtmlLabelName(19059,user.getLanguage())%></td>
 <td width="500">
 <table class=ListStyle cellspacing=1 >
 <tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
<%
 if (indexId!=-1)
 {
 ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
 ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
 for (int l=0;l<nodeIda.size();l++)
 { int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIda.get(l)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIda.get(l)),0);
  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIda.get(l)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIda.get(l)),0)/24;
  boolean  overT=false;
  
  if ((Util.getFloatValue(""+nodeCounta.get(l),0)>overTimes)&&overTimesb!=0) overT=!overT;
 %>
 <td width="170"><%if (overT) {%><font color="red"><% }%><%=Util.round(""+nodeCounta.get(l),1)%>(<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>)
 <%if (overT) {%>(<%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%>)</font><%}%></td>
 <%
 }%>
 
<% }
 %>
</tr>
 </table>
 </td>
 </tr>
  
  <%isLight1=!isLight1;%>
 <tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
 <td width="150"><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19059,user.getLanguage())%></td>
 <td width="500">
 <table class=ListStyle cellspacing=1 >
 <tr class='<%=( isLight1 ? "datalight" : "datadark" )%>'>
<%
 if (indexId!=-1)
 {
 ArrayList nodeIda=(ArrayList)nodeIds.get(indexId);
 ArrayList nodeCounta=(ArrayList)workFlowNodeCounts.get(indexId);
 for (int b=0;b<nodeIda.size();b++)
 {int indexIds=workFlowNodes.indexOf(""+nodeIda.get(b));
 if (indexIds!=-1) {
 
  int overTimesb=Util.getIntValue(OverTime.getOverHour(""+nodeIda.get(b)),0)+Util.getIntValue(OverTime.getOverTime(""+nodeIda.get(b)),0);
  float overTimes=Util.getFloatValue(OverTime.getOverHour(""+nodeIda.get(b)),0)+Util.getFloatValue(OverTime.getOverTime(""+nodeIda.get(b)),0)/24;
  boolean  overT=false;
  
  if ((Util.getFloatValue(""+tempCountsx.get(indexIds),0)>overTimes)&&overTimesb!=0) overT=!overT;
 %>
 <td width="170"><%if (overT) {%><font color="red"><% }%><%=Util.round(""+tempCountsx.get(indexIds),1)%>(<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>)
 <%if (overT) {%>(<%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%>)</font><%}%></td>
 <%
 
 }
 }%>
 
<% }
 %>
</tr>
 </table>
 </td>
  </tr>
 <!-- TR class=Line><TD colspan="2" ></TD></TR-->
 <%
 workflows.remove(k);
 workflowcounts.remove(k);
 flowUsers.remove(k);
 k--;
 }%>

 </table>
</td>
</tr>
<!-- TR class=Line><TD colspan="1" ></TD></TR-->
 <%
  wftypes.remove(j);
  wfUsers.remove(j);
  j--;
 }%>
 </table>
 </td>
 </tr>
 <TR class=Line><TD colspan="4" ></TD></TR>
 <%
 
 }
 }%>
 	<!-- <%if(pagenum>1){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:frmMain.prepage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
						<button type=submit  style="display:none" class=btn accessKey=P id=prepage onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
						<%}%>
						<%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:frmMain.nextpage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
						<button type=submit style="display:none" class=btn accessKey=N  id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
						<%}%>
						-->

</TABLE>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>	
<!-- /fieldset-->
<!--详细内容结束-->

</td>
</tr>
</TABLE>
</FORM>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

<script>

  function chageFlowType(eventobj,list_obj,target_obj)
  {
	var oOption ;
	var tempstr = eventobj.value +"$";
	target_obj.options.length = 0 ;
	
	oOption = document.createElement("OPTION");
	oOption.text = "";
	oOption.value = "";
	target_obj.options.add(oOption);
	
	if (eventobj.value.length > 0)
	{
	for (var i=0; i< list_obj.options.length; i++)
	{
		if (list_obj.options(i).value.indexOf(tempstr)>=0)
		{
		oOption = document.createElement("OPTION");
		oOption.text=list_obj.options(i).text;
		oOption.value=list_obj.options(i).value.substr(list_obj.options(i).value.indexOf('$')+1,list_obj.options(i).value.length) ;
		target_obj.options.add(oOption);
		}
	
	 }
    }
     
  
  }
  function onChangeType(){
 
	thisvalue=document.frmMain.objType.value;
	$G("objId").value="";
	$G("objName").innerHTML ="";
	$G("objNames").value ="";
	document.all("nameimage").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>";
	if(thisvalue==3){
 		$G("showBranch").style.display='';
	}
	else{
		$G("showBranch").style.display='none';
	}
	if(thisvalue==2){
 		$G("showdepartment").style.display='';
		
	}
	else{
		$G("showdepartment").style.display='none';
	}
	if(thisvalue==1){
 		$G("showresource").style.display='';
		
	}
	else{
		$G("showresource").style.display='none';
		
    }
	
}
function submitData()
{
	   if (check_form($G("frmMain"),'objId'))
		$G("frmMain").submit();
}
function onShowResource(inputename,tdname, tdnames){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.substr(1).split(",");
	    	var names=datas.name.substr(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a href=javaScript:openhrm("+ids[i]+"); onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
            }
            jQuery("#" + tdnames).val(strs);
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.substr(1));
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#" + tdnames).val("");
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
		}
	}
}
function onShowDepartment(inputename,tdname,tdnames){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids="+ids+"&selectedDepartmentIds="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.slice(1).split(",");
	    	var names=datas.name.slice(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a target='_blank' href=/hrm/company/HrmDepartmentDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
            }
            jQuery("#" + tdnames).val(strs);
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.slice(1));
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#" + tdnames).val("");
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
		}
	}
}
function onShowBranch(inputename,tdname,tdnames){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+ids+"&selectedDepartmentIds="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.slice(1).split(",");
	    	var names=datas.name.slice(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a target='_blank' href=/hrm/company/HrmSubCompanyDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
            }
            jQuery("#" + tdnames).val(strs);
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.slice(1));
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#" + tdnames).val("");
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
		}
	}
}

function onShow2(inputename,showname){
   typeid=$G("typeId").value;
   results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid="+typeid)
   if (results){
        if (results.id){
          $G(showname).innerHTML = results.name;
		  $G(inputename).value=results.id;
        }else{
		  $G(showname).innerHTML ="";
          $G(inputename).value="";
        }
   }
}


</script>
<SCRIPT language=VBS>
sub onShowDepartment1(inputename,showname)
    tmpids = document.all(inputename).value
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids="&document.all(inputename).value&"&selectedDepartmentIds="&tmpids)
   if (Not IsEmpty(id)) then
        if id(0)<> "" then
          resourceids = id(0)
          resourcename = id(1)
          sHtml = ""
          resourceids = Mid(resourceids,2,len(resourceids))
          
          document.all(inputename).value= resourceids
          resourcename = Mid(resourcename,2,len(resourcename))
          while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
		  document.all("objNames").value=sHtml
        else
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
          document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
         end if
         end if
end sub


sub onShowResource1(inputename,showname)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
        if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
          resourceids = id1(0)
          resourcename = id1(1)
          sHtml = ""
          
          resourceids = Mid(resourceids,2,len(resourceids))
         
          document.all(inputename).value= resourceids
          resourcename = Mid(resourcename,2,len(resourcename))
          while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
		  document.all("objNames").value=sHtml
        else
          document.all(inputename).value=""
		  document.all(showname).innerHtml =""
		  document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
        end if
         end if
end sub
	
	
sub onShowBranch1(inputename,showname)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&document.all(inputename).value&"&selectedDepartmentIds="&tmpids)
   
		if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
          resourceids = id1(0)
          resourcename = id1(1)
          sHtml = ""
         
          resourceids = Mid(resourceids,2,len(resourceids))
          document.all(inputename).value= resourceids
          resourcename = Mid(resourcename,2,len(resourcename))
          while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
	      document.all("objNames").value=sHtml
        else
		
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
		  document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
        end if
         end if
end sub


sub onShow(inputename,showname)

   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp")
   if (Not IsEmpty(id)) then
        if id(0)<> "0" then

          document.all(showname).innerHtml = id(1)
		  document.all(inputename).value=id(0)
        else
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
         end if
      
		  document.all("flowName").innerHtml =""
          document.all("flowId").value="" 
         end if
end sub

sub onShow21(inputename,showname)
   typeid=document.all("typeId").value
   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid="&typeid)
   if (Not IsEmpty(id)) then
        if id(0)<> "" then

          document.all(showname).innerHtml = id(1)
		  document.all(inputename).value=id(0)
        else
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
         end if
         end if
end sub

</SCRIPT>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</body></html>
