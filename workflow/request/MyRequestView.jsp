<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@page import="org.json.JSONObject"%> 
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>

<%
Enumeration em = request.getParameterNames();
boolean isinit = true;
while(em.hasMoreElements())
{
	String paramName = (String)em.nextElement();
	if(!paramName.equals(""))
		isinit = false;
	break;
}
int date2during = Util.getIntValue(request.getParameter("date2during"),0);
String imagefilename = "/images/hdReport.gif";
String titlename =  SystemEnv.getHtmlLabelName(1210,user.getLanguage()) +":"+SystemEnv.getHtmlLabelName(367,user.getLanguage());
String needfav ="1";
String needhelp ="";

String resourceid=""+user.getUID();
session.removeAttribute("RequestViewResource");
String logintype = ""+user.getLogintype();
int usertype = 0; 

/* edited by wdl 2006-06-14 left menu advanced menu */
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
String menuType = Util.null2String(request.getParameter("menuType"));
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
if(selectedContent!=null && selectedContent.startsWith("key_")){
	String menuid = selectedContent.substring(4);
	RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
	selectedContent = "";
	while(RecordSet.next()){
		String keyVal = RecordSet.getString(2);
		selectedContent += keyVal +"|";
	}
	if(selectedContent.indexOf("|")!=-1)
		selectedContent = selectedContent.substring(0,selectedContent.length()-1);
}
	if(fromAdvancedMenu == 1){
		response.sendRedirect("/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&infoId="+infoId+"&selectedContent="+selectedContent+"&menuType="+menuType);
		return;
	}
String selectedworkflow = "";
LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectedworkflow = info.getSelectedContent();
}
if(!"".equals(selectedContent))
{
	selectedworkflow = selectedContent;
}
selectedworkflow+="|";
/* edited end */    

if(logintype.equals("2"))
	usertype= 1;
char flag = Util.getSeparator();

int olddate2during = 0;
BaseBean baseBean = new BaseBean();
String date2durings = "";
try
{
	date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
}
catch(Exception e)
{}
String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
if(date2duringTokens.length>0)
{
	olddate2during = Util.getIntValue(date2duringTokens[0],0);
}
if(olddate2during<0||olddate2during>36)
{
	olddate2during = 0;
}
if(isinit)
{
	date2during = olddate2during;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
var date2during = '<%=date2during %>';
function changeShowType()
{
	if(date2during=='0')
	{
		location.href="/workflow/request/MyRequestView.jsp?date2during=<%=olddate2during%>";
	}
	else
	{
		location.href="/workflow/request/MyRequestView.jsp?date2during=0";
	}
}
</script>
</head>

<body>



<% //  if(HrmUserVarify.checkUserRight("requestview:Add", user)){ %>


<% //  }%>

<%
	ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList wftypecountsy=new ArrayList();
	ArrayList workflowcounts=new ArrayList();
	ArrayList workflowcountsy=new ArrayList();
	
	int totalcount=0;
	int totalcounty=0;
	String currworkflowtype="";
	
	String currworkflowid="";
	String currentnodetype="";
	StringBuffer sqlsb = new StringBuffer();
	sqlsb.append("select count(distinct t1.requestid) typecount, ");
	sqlsb.append("      t2.workflowtype, ");
	sqlsb.append("      t1.workflowid, ");
	sqlsb.append("      t1.currentnodetype ");
	sqlsb.append(" from workflow_requestbase t1, workflow_base t2 ");
	sqlsb.append("where t1.creater = ").append(resourceid);
	sqlsb.append("  and t1.creatertype = ").append(usertype);
	sqlsb.append("  and t1.workflowid = t2.id ");
	sqlsb.append("  and t2.isvalid = '1' ");
	if(RecordSet.getDBType().equals("oracle"))
	{
		sqlsb.append(" and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
	}
	else
	{
		sqlsb.append(" and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
	}
	sqlsb.append("  and exists ");
	sqlsb.append("		(select 1 ");
	sqlsb.append("         from workflow_currentoperator ");
	sqlsb.append("        where workflow_currentoperator.requestid = t1.requestid ");
	sqlsb.append("          and workflow_currentoperator.userid = " + resourceid + WorkflowComInfo.getDateDuringSql(date2during) +") ");
	sqlsb.append("group by t2.workflowtype, t1.workflowid, t1.currentnodetype");
	RecordSet.executeSql(sqlsb.toString());
	
    //RecordSet.executeProc("workflow_requestbase_MyRequest",resourceid+flag+usertype);
	while (RecordSet.next())
	{
	 currworkflowtype = RecordSet.getString("workflowtype");
	 currworkflowid = RecordSet.getString("workflowid");
	 currentnodetype=RecordSet.getString("currentnodetype");
	 int theworkflowcount=RecordSet.getInt("typecount");
	 if(selectedworkflow.indexOf("T"+currworkflowtype+"|")==-1 && fromAdvancedMenu==1) continue;
	 if(selectedworkflow.indexOf("W"+currworkflowid+"|")==-1 && fromAdvancedMenu==1) continue;
	 int temps=wftypes.indexOf(currworkflowtype);
	 if (temps!=-1)
	 {
	 if (currentnodetype.equals("3"))
	 {
	 wftypecountsy.set(temps,""+(Util.getIntValue((String)wftypecountsy.get(temps),0)+theworkflowcount));
	 
	 }
	 else
	 {
	  wftypecounts.set(temps,""+(Util.getIntValue((String)wftypecounts.get(temps),0)+theworkflowcount));
	 }
	 }
	 else
	 {
	 wftypes.add(currworkflowtype);
	 if (currentnodetype.equals("3"))
	 {
	 wftypecountsy.add(""+RecordSet.getString("typecount"));
	 wftypecounts.add(""+0);
	 }
	 else
	 {
	 wftypecounts.add(""+RecordSet.getString("typecount"));
	 wftypecountsy.add(""+0);
	 }
	 }
	 temps=workflows.indexOf(currworkflowid);
	 if (temps!=-1)
	 {
	 if (currentnodetype.equals("3"))
	 {
	 workflowcountsy.set(temps,""+(Util.getIntValue((String)workflowcountsy.get(temps),0)+theworkflowcount));
	 
	 }
	 else
	 {
	 workflowcounts.set(temps,""+(Util.getIntValue((String)workflowcounts.get(temps),0)+theworkflowcount));
	 }
	 }
	 else
	 {
	 workflows.add(currworkflowid);
	 if (currentnodetype.equals("3"))
	 {
	 workflowcountsy.add(""+RecordSet.getString("typecount"));
	 workflowcounts.add(""+0);
	 }
	 else
	 {
	 workflowcounts.add(""+RecordSet.getString("typecount"));
	 workflowcountsy.add(""+0);
	 }
	 }
	 
	 if (currentnodetype.equals("3"))
	 {
	 totalcounty+=theworkflowcount;
	 }
	 else
	 {
	 totalcount+=theworkflowcount;
	 }
	}
	
	boolean isUseOldWfMode=sysInfo.isUseOldWfMode();
	if(!isUseOldWfMode){
		String typeid="";
		String typecount="";
		String typename="";
		String workflowid="";
		String workflowcount="";
		String workflowname="";
		int typerowcounts=wftypes.size();
		
		JSONArray jsonFinishedWfTypeArray = new JSONArray();
		JSONArray jsonUnFinishedWfTypeArray = new JSONArray();
		 
	    for(int i=0;i<typerowcounts;i++){
	    	             
		   	JSONObject jsonWfType = new JSONObject();
		    jsonWfType.put("draggable",false);
			jsonWfType.put("leaf",false);
			
			typeid=(String)wftypes.get(i);
			typecount=(String)wftypecounts.get(i);
			typename=WorkTypeComInfo.getWorkTypename(typeid);
			if (!typecount.equals("0"))
			{
				if(fromAdvancedMenu==1){
					jsonWfType.put("paras","method=myreqeustbywftype&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=0&selectedContent="+selectedContent+"&menuType="+menuType);
				}
				else{
					jsonWfType.put("paras","method=myreqeustbywftype&wftype="+typeid+"&complete=0");
				}
				jsonWfType.put("text","<a href=# onClick=javaScript:loadGrid('"+jsonWfType.get("paras").toString()+"',true) >"+typename+"&nbsp;</a>("+typecount+")");
				jsonWfType.put("cls","wfTreeFolderNode");	
							                      			
				//if(typeid.equals("24")) continue;
				
		        JSONArray jsonWfTypeChildrenArray = new JSONArray();
		        for(int j=0;j<workflows.size();j++){
		        	String wfText = "";
		        	workflowid=(String)workflows.get(j);
					String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
					if(!curtypeid.equals(typeid))	continue;
		        	
					JSONObject jsonWfTypeChild = new JSONObject();
		        	jsonWfTypeChild.put("draggable",false);
		        	jsonWfTypeChild.put("leaf",true);
		        	
		        	workflowcount=(String)workflowcounts.get(j);
					workflowname=WorkflowComInfo.getWorkflowname(workflowid);
					if (!workflowcount.equals("0")){
						
						jsonWfTypeChild.put("paras","method=myreqeustbywfid&workflowid="+workflowid+"&complete=0");
						wfText +="<a  href=# onClick=javaScript:loadGrid('"+jsonWfTypeChild.get("paras").toString()+"',true) >"+workflowname+" </a>&nbsp(";
						
						wfText+=Util.toScreen(workflowcount,user.getLanguage())+")";						
						
						jsonWfTypeChild.put("text",wfText);
						jsonWfTypeChild.put("iconCls","btn_dot");
						jsonWfTypeChild.put("cls","wfTreeLeafNode");
						jsonWfTypeChildrenArray.put(jsonWfTypeChild);
					}
				}	
		                                                
		        jsonWfType.put("children",jsonWfTypeChildrenArray);
		        jsonUnFinishedWfTypeArray.put(jsonWfType);
			}
	    }
	     
	    for(int i=0;i<typerowcounts;i++){
            
		   	JSONObject jsonWfType = new JSONObject();
		    jsonWfType.put("draggable",false);
			jsonWfType.put("leaf",false);
			
			typeid=(String)wftypes.get(i);
			typecount=(String)wftypecountsy.get(i);
			typename=WorkTypeComInfo.getWorkTypename(typeid);
			if (!typecount.equals("0"))
			{
				if(fromAdvancedMenu==1){
					jsonWfType.put("paras","method=myreqeustbywftype&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=1&selectedContent="+selectedContent+"&menuType="+menuType);
				}
				else{
					jsonWfType.put("paras","method=myreqeustbywftype&wftype="+typeid+"&complete=1");
				}
				jsonWfType.put("text","<a href=# onClick=javaScript:loadGrid('"+jsonWfType.get("paras").toString()+"',true) >"+typename+"&nbsp;</a>("+typecount+")");
				jsonWfType.put("cls","wfTreeFolderNode");		
							                      			
				//if(typeid.equals("24")) continue;
				
		        JSONArray jsonWfTypeChildrenArray = new JSONArray();
		        for(int j=0;j<workflows.size();j++){
		        	String wfText = "";
		        	workflowid=(String)workflows.get(j);
					String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
					if(!curtypeid.equals(typeid))	continue;
		        	
					JSONObject jsonWfTypeChild = new JSONObject();
		        	jsonWfTypeChild.put("draggable",false);
		        	jsonWfTypeChild.put("leaf",true);
		        	
		        	workflowcount=(String)workflowcountsy.get(j);
					workflowname=WorkflowComInfo.getWorkflowname(workflowid);
					if (!workflowcount.equals("0")){
						
						jsonWfTypeChild.put("paras","method=myreqeustbywfid&workflowid="+workflowid+"&complete=1");
						wfText +="<a href = # onClick=javaScript:loadGrid('"+jsonWfTypeChild.get("paras").toString()+"',true) >"+workflowname+" </a>&nbsp(";
						
						wfText+=Util.toScreen(workflowcount,user.getLanguage())+")";						
						
						jsonWfTypeChild.put("text",wfText);
						jsonWfTypeChild.put("iconCls","btn_dot");
						jsonWfTypeChild.put("cls","wfTreeLeafNode");
						jsonWfTypeChildrenArray.put(jsonWfTypeChild);
					}
				}	
		                                                
		        jsonWfType.put("children",jsonWfTypeChildrenArray);
		        jsonFinishedWfTypeArray.put(jsonWfType);
			}
	    }
	   
	    session.setAttribute("finished",jsonFinishedWfTypeArray);
	    session.setAttribute("unfinished",jsonUnFinishedWfTypeArray);
	    session.setAttribute("finishedCount",""+totalcounty);
	    session.setAttribute("unfinishedCount",""+totalcount);
		
	    response.sendRedirect("/workflow/request/ext/Request.jsp?type=myrequest");  //type: view,表待办 handled表已办
		
		return;	
	}
	
%>
<%@ include file="/systeminfo/TopTitle.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>



<%
/* edited by wdl 2006-06-14 left menu advanced menu */
if(date2during==0)
{
	//显示部分
   	RCMenu += "{"+SystemEnv.getHtmlLabelName(89,user.getLanguage())+SystemEnv.getHtmlLabelName(15154,user.getLanguage())+",javascript:changeShowType(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
else
{
	//显示全部
   	RCMenu += "{"+SystemEnv.getHtmlLabelName(89,user.getLanguage())+SystemEnv.getHtmlLabelName(332,user.getLanguage())+",javascript:changeShowType(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(fromAdvancedMenu!=1){

	RCMenuWidth = 160;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16342,user.getLanguage())+",/workflow/search/WFSearchTemp.jsp?method=myall&complete=0&viewType=4,_self} " ;
	RCMenuHeight += RCMenuHeightStep;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(16343,user.getLanguage())+",/workflow/search/WFSearchTemp.jsp?method=myall&complete=1&viewType=4,_self} " ;
	RCMenuHeight += RCMenuHeightStep;

}
/* edited end */    
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr style="height:5px">
	<td height="5" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<table class="viewform">
<colgroup><col width="49%"><col width=10><col width="49%"></colgroup>
<tr>
<td valign=top>
  <table class="viewform">
  <tr class="Title">
  		  <!-- 最近个月 -->
          <th><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%>:<%=totalcount%><%if(date2during>0){ %>(<%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=date2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%>)<%} %></th>
        </tr>
  <tr class="Spacing" style="height:1px;"><td class="Line1"></td></tr>
  <tr style="height:5px;">
                    	<td class="space"></td>
                    </tr>
  <tr><td>
  
<%	
	String typeid="";
	String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
	String workflowname="";
	for(int i=0;i<wftypes.size();i++){
		typeid=(String)wftypes.get(i);
		typecount=(String)wftypecounts.get(i);
		typename=WorkTypeComInfo.getWorkTypename(typeid);
		if (!typecount.equals("0"))
		{
		%>
	<div class=listbox >
                                                <table width="100%" height="25px" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td class="t-center"><span class="flag_1"></span><span	class="title_1">
       	<% /* edited by wdl 2006-06-14 left menu advanced menu */ 
       	if(fromAdvancedMenu==1){
       	%>
           <a href="/workflow/search/WFSearchTemp.jsp?method=myreqeustbywftype&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&wftype=<%=typeid%>&complete=0&selectedContent=<%=selectedContent %>&menuType=<%=menuType %>&date2during=<%=date2during %>&viewType=4">
       	<% } else { %>
           <a href="/workflow/search/WFSearchTemp.jsp?method=myreqeustbywftype&wftype=<%=typeid%>&complete=0&date2during=<%=date2during %>&viewType=4">
       	<% } /* edited end */ %>
		<%=Util.toScreen(typename,user.getLanguage())%></a>&nbsp;<b>(<%=typecount%>)</b>
		</span></td>
			</tr>
		</table>
		<UL>
		<%
		//if(typeid.equals("24")) continue;
		for(int j=0;j<workflows.size();j++){
			workflowid=(String)workflows.get(j);
			String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
			if(!curtypeid.equals(typeid))	continue;
			
			workflowcount=(String)workflowcounts.get(j);
			workflowname=WorkflowComInfo.getWorkflowname(workflowid);
			if (!workflowcount.equals("0"))
			{
			%>
		<LI><a href="/workflow/search/WFSearchTemp.jsp?method=myreqeustbywfid&workflowid=<%=workflowid%>&complete=0&date2during=<%=date2during %>&viewType=4">
			<%=Util.toScreen(workflowname,user.getLanguage())%></a>&nbsp;(<%=workflowcount%>)
			<%
		}
		} 
		%>
	</UL></div>
		<%
	}
	}
%>
   </td></tr></table>
</td>
<td>&nbsp;</td>
<%
	
%>
<td valign=top>
  <table class="viewform">
  <!-- 最近个月 -->
  <tr class="Title"><th><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%>:<%=totalcounty%><%if(date2during>0){ %>(<%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=date2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%>)<%} %></th></tr>
  <tr class="Spacing" style="height:1px;"><td class="Line1"></td></tr>
  <tr style="height:5px;">
                    	<td class="space"></td>
                    </tr>
  <tr><td>
<%	
	for(int i=0;i<wftypes.size();i++){
		typeid=(String)wftypes.get(i);
		typecount=(String)wftypecountsy.get(i);
		typename=WorkTypeComInfo.getWorkTypename(typeid);
		if (!typecount.equals("0"))
		{
		%>
	 <div class=listbox >
                                                <table width="100%" height="25px" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td class="t-center"><span class="flag_1"></span><span	class="title_1">
                                           	
       	<% /* edited by wdl 2006-06-14 left menu advanced menu */ 
       	if(fromAdvancedMenu==1){
       	%>
           <a href="/workflow/search/WFSearchTemp.jsp?method=myreqeustbywftype&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&wftype=<%=typeid%>&complete=1&selectedContent=<%=selectedContent %>&menuType=<%=menuType %>&date2during=<%=date2during %>&viewType=4">
       	<% } else { %>
           <a href="/workflow/search/WFSearchTemp.jsp?method=myreqeustbywftype&wftype=<%=typeid%>&complete=1&date2during=<%=date2during %>&viewType=4">
       	<% } /* edited end */ %>
		<%=Util.toScreen(typename,user.getLanguage())%></a>&nbsp;<b>(<%=typecount%>)</b>
		</span></td>
	</tr>
</table>
		<UL>
		<%
		//if(typeid.equals("24")) continue;
		for(int j=0;j<workflows.size();j++){
			workflowid=(String)workflows.get(j);
			String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
			if(!curtypeid.equals(typeid))	continue;
			workflowcount=(String)workflowcountsy.get(j);
			workflowname=WorkflowComInfo.getWorkflowname(workflowid);
			if (!workflowcount.equals("0"))
			{
			%>
		<LI><a href="/workflow/search/WFSearchTemp.jsp?method=myreqeustbywfid&workflowid=<%=workflowid%>&complete=1&date2during=<%=date2during %>&viewType=4">
			<%=Util.toScreen(workflowname,user.getLanguage())%></a>&nbsp;(<%=workflowcount%>)
			<%
		}}
		%>
	</UL></div>
		<%
	}
	}
%>
 </td></tr></table>
</td></tr></table>
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

</body>
</html>
