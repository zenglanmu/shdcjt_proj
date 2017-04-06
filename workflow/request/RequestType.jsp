<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="java.util.Date" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<link href="/css/request.css" type="text/css" rel="STYLESHEET"> 
</head>
<%!
	public String getRandom(){
		return ""+(((int)(Math.random()*1000000)%3)+1);
	}
%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(365,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
//String seclevel = "";
if(logintype.equals("2")){
	usertype = 1;
	//seclevel = ResourceComInfo.getSeclevel(""+user.getUID());
}
//else if (logintype.equals("1")){
//	seclevel = user.getSeclevel();
//}
//if(seclevel.equals("")){
//	seclevel="0";
//}
String seclevel = user.getSeclevel();

String selectedworkflow="";
String isuserdefault="";

/* edited by wdl 2006-05-24 left menu new requirement ?fromadvancedmenu=1&infoId=-140 */
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String needPopupNewPage = Util.null2String(request.getParameter("needPopupNewPage"));//是否需要弹出新页面  true:需要   false或其它：不需要
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

if(fromAdvancedMenu==1){
	needPopupNewPage="true";
}

boolean navigateTo = false;
int navigateToWfid = 0;
int navigateToIsagent = 0;
int navigateToAgenter = 0;
String commonuse = "";
if(fromAdvancedMenu==1){//目录选择来自高级菜单设置
	LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	if(info!=null){
		selectedworkflow = info.getSelectedContent();
		
		List workflowNum = Util.TokenizerString(selectedworkflow,"|");
		int tnum = 0;
		for(Iterator it = workflowNum.iterator();it.hasNext();){
			if(((String)it.next()).startsWith("W")) tnum++;
		}
		if(tnum==1) navigateTo = true;
	}
} else {
	//ArrayList selectArr=new ArrayList();
	RecordSet.executeProc("workflow_RUserDefault_Select",""+userid);
	if(RecordSet.next()){
	    selectedworkflow=RecordSet.getString("selectedworkflow");
	    isuserdefault=RecordSet.getString("isuserdefault");
	    commonuse = RecordSet.getString("commonuse");
	}
}   

/* edited end */
if(!"".equals(selectedContent))
{
	selectedworkflow = selectedContent;
}
if(!selectedworkflow.equals(""))    selectedworkflow+="|";
String needall=Util.null2String(request.getParameter("needall"));
if(needall.equals("1")) {
	isuserdefault="0";
	fromAdvancedMenu=0;
}

%>
<body>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%//
if(isuserdefault.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16346,user.getLanguage())+",javascript:onuserdefault(0),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
} else if(needall.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:onuserdefault(1),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
} else if(fromAdvancedMenu==1){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(16346,user.getLanguage())+",javascript:onuserdefault(0),_self} " ;
	//RCMenuHeight += RCMenuHeightStep;

	//RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:onuserdefault(1),_self} " ;
	//RCMenuHeight += RCMenuHeightStep;
}
if(usertype==0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:location.href='/workflow/request/RequestUserDefault.jsp',_top} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form id="subform" name="subform" method="get" action="RequestType.jsp">
	<input type="hidden" id=workflowid name=workflowid>
	<input type="hidden" id=isagent name=isagent>
	<input type="hidden" id=beagenter name=beagenter>
	<input type="hidden" id=needPopupNewPage name=needPopupNewPage>
	<input type="hidden" id=isec name=isec>

<%
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));

String isec = Util.null2String(request.getParameter("isec"));
if("1".equals(isec)){
topage = URLEncoder.encode(topage);
}
//获取流程新建权限体系sql条件
String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");

ArrayList NewWorkflowTypes = new ArrayList();

String sql = "select distinct workflowtype from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and t1.usertype = " + usertype + " and " + wfcrtSqlWhere;
RecordSet.executeSql(sql);
while(RecordSet.next()){
	NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
}


//所有可创建流程集合
ArrayList NewWorkflows = new ArrayList();

sql = "select * from ShareInnerWfCreate t1 where " +  wfcrtSqlWhere;
RecordSet.executeSql(sql);
while(RecordSet.next()){
	NewWorkflows.add(RecordSet.getString("workflowid"));
}

/*modify by mackjoe at 2005-09-14 增加流程代理创建权限*/
ArrayList AgentWorkflows = new ArrayList();
ArrayList Agenterids = new ArrayList();
//TD13554
Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
	                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
	                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
	                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
	                     Util.add0(today.get(Calendar.SECOND), 2) ;
if (usertype == 0) {
	//获得当前的日期和时间
	
	String begindate="";
	String begintime="";
	String enddate="";
	String endtime="";
	int agentworkflowtype=0;
	int agentworkflow=0;
	int beagenterid=0;
	sql = "select distinct t1.workflowtype,t.workflowid,t.beagenterid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agent t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid="+userid+" order by t1.workflowtype,t.workflowid";
	
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    boolean isvald=false;
	    begindate=Util.null2String(RecordSet.getString("begindate"));
	    begintime=Util.null2String(RecordSet.getString("begintime"));
	    enddate=Util.null2String(RecordSet.getString("enddate"));
	    endtime=Util.null2String(RecordSet.getString("endtime"));
	    agentworkflowtype=Util.getIntValue(RecordSet.getString("workflowtype"),0);
	    agentworkflow=Util.getIntValue(RecordSet.getString("workflowid"),0);
	    beagenterid=Util.getIntValue(RecordSet.getString("beagenterid"),0);
	    if(!begindate.equals("")){
	        if((begindate+" "+begintime).compareTo(currentdate+" "+currenttime)>0)
	            continue;
	    }
	    if(!enddate.equals("")){
	        if((enddate+" "+endtime).compareTo(currentdate+" "+currenttime)<0)
	            continue;
	    }
		
		boolean haswfcreateperm = shareManager.hasWfCreatePermission(beagenterid, agentworkflow);
		if(haswfcreateperm){
	        if(NewWorkflowTypes.indexOf(agentworkflowtype+"")==-1){
	            NewWorkflowTypes.add(agentworkflowtype+"");
	        }
	        
	        int indx=AgentWorkflows.indexOf(""+agentworkflow);
	        if(indx==-1){
	            AgentWorkflows.add(""+agentworkflow);
	            Agenterids.add(""+beagenterid);
	        }else{
	            String tempagenter=(String)Agenterids.get(indx);
	            if (tempagenter.indexOf(beagenterid + "") == -1) {
	            	tempagenter += "," + beagenterid;
		            Agenterids.set(indx,tempagenter);	
	            }
	        }
	    }
	}
	//end
}

List inputReportFormIdList=new ArrayList();
String tempWorkflowId=null;
String tempFormId=null;
String tempIsBill=null;
for(int i=0;i<NewWorkflows.size();i++){
	tempWorkflowId=(String)NewWorkflows.get(i);
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

for(int i=0;i<AgentWorkflows.size();i++){
	tempWorkflowId=(String)AgentWorkflows.get(i);
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

String dataCenterWorkflowTypeId="";
RecordSet.executeSql("select currentId from sequenceindex where indexDesc='dataCenterWorkflowTypeId'");
if(RecordSet.next()){
	dataCenterWorkflowTypeId=Util.null2String(RecordSet.getString("currentId"));
}

this.rs=RecordSet;
List inputReportList=this.getAllInputReport(String.valueOf(userid));
//if(inputReportList.size()>0){
//	NewWorkflowTypes.add(dataCenterWorkflowTypeId);
//}
if(inputReportList.size()>0&&NewWorkflowTypes.indexOf(dataCenterWorkflowTypeId)==-1){
	NewWorkflowTypes.add(dataCenterWorkflowTypeId);
}
ArrayList NewInputReports = new ArrayList();
Map inputReportMap=null;
String inprepId=null;
String inprepName=null;
for(int i=0;i<inputReportList.size();i++){
	inputReportMap=(Map)inputReportList.get(i);
	inprepId=Util.null2String((String)inputReportMap.get("inprepId"));
	if(!inprepId.equals("")&&inputReportFormIdList.indexOf(InputReportComInfo.getbillid(inprepId))==-1){
		NewInputReports.add(inprepId);
	}
}

int wftypetotal=WorkTypeComInfo.getWorkTypeNum();
int wftotal=WorkflowComInfo.getWorkflowNum();
int rownum=0;
//System.out.println("========wftotal:"+wftotal+"===========wftypetotal="+wftypetotal+"======================rownum="+rownum);
//rownum=6;

while(WorkTypeComInfo.next()){
		String wftypename=WorkTypeComInfo.getWorkTypename();
		String wftypeid = WorkTypeComInfo.getWorkTypeid();

		if(NewWorkflowTypes.indexOf(wftypeid)==-1){
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
 			continue;            
		}
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")){
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
			continue;
		}
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1 && fromAdvancedMenu==1){
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
			continue;
		}
	 	if(dataCenterWorkflowTypeId.equals(wftypeid)&&true) {
			wftypetotal--;
			rownum=(wftypetotal+2)/3;
			continue;
		}
}
WorkTypeComInfo.setTofirstRow();
%>

<table height=100% width="100%" border="0" cellspacing="0" cellpadding="0">
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
								<table class="ViewForm">
								   <tr class=field>
								        <td width="30%" align=left valign=top num=1>
								        <!-- 2012-09-21 ypc -->
								        <%if(fromAdvancedMenu!=1 && usertype==0&&!commonuse.equals("0")){ %> 
								        <!-- 常用流程  开始 -->
								        <%
								        	String agentWfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");
									        if(RecordSet.getDBType().equals("oracle")){
									        	RecordSet.execute("SELECT * FROM (select * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and t1.usertype = " + usertype+ " and " + agentWfcrtSqlWhere + ") or wfid in( select distinct t.workflowid from workflow_agent t,workflow_base t1 where exists (select * from HrmResource b where t.beagenterId=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid="+userid+" and t.beginDate+t.beginTime+':00'<='"+currentdate+currenttime+"' and t.endDate+t.endTime+':00'>='"+currentdate+currenttime+"')) order by count desc) WHERE ROWNUM <= 10 ORDER BY ROWNUM ASC");
									        }else{
									        	RecordSet.execute("select top 10 * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and " + agentWfcrtSqlWhere +" and t1.usertype = " + usertype+") or wfid in( select distinct t.workflowid from workflow_agent t,workflow_base t1 where exists (select * from HrmResource b where t.beagenterId=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid="+userid+" and t.beginDate+t.beginTime+':00'<='"+currentdate+currenttime+"' and t.endDate+t.endTime+':00'>='"+currentdate+currenttime+"')) order by count desc");
									        }
								        	
								            
								        	if(RecordSet.getCounts()>0){
								        %>
								        <div class="listbox2" >
								        <table width=100% height="20px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td class="t-left">&nbsp;</td>
						<td class="t-center"><span class="flag_1"></span><span	class="title_1"><%=SystemEnv.getHtmlLabelName(28184,user.getLanguage()) %></span></td>
						<td class="t-right">&nbsp;</td>
					</tr>
				</table>
				<ul>
				<%
					while(RecordSet.next()){
						String wfid= RecordSet.getString("wfid");
						 if(AgentWorkflows.indexOf(wfid)==-1){
							 %>
		                        <li  style="height:100%;">
		                         <label class="listbox-item-style-<%=getRandom()%>">&nbsp;</label>
		                          <a href="javascript:onNewRequest(<%=wfid%>,0,0);">
		                            <%=Util.toScreen(WorkflowComInfo.getWorkflowname(wfid),user.getLanguage())%>
		                          </a>
		                        </li>
		                    <%
				            }else{
				               ArrayList agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
				               int isagent=1;
				                for(int k=0;k<agenterlist.size();k++){
				                   int beagenter=Util.getIntValue((String)agenterlist.get(k),0);
				                   String  agentname="("+ResourceComInfo.getResourcename((String)agenterlist.get(k))+"->"+user.getUsername()+")";
				                    %>
				                        <li  style="height:100%;">
				                         <label class="listbox-item-style-<%=getRandom()%>">&nbsp;</label>
				                          <a href="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);">
				                            <%=Util.toScreen(WorkflowComInfo.getWorkflowname(wfid),user.getLanguage())%>
				                          </a><%=agentname%>
				                        </li>
				                    <%
				                }
				            }
				%>
				
                        <%} %>
					</ul>
					</div>
					<%}%>
					<%} %>
								        <!-- 常用流程  结束 -->
								        
<%
	int i=0;
	int needtd=rownum;
	int numRows=0;
	while(WorkTypeComInfo.next()){	
		String wftypename=WorkTypeComInfo.getWorkTypename();
		String wftypeid = WorkTypeComInfo.getWorkTypeid();

		if(NewWorkflowTypes.indexOf(wftypeid)==-1){
			
 			continue;            
		}
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")){
			
			continue;
		}
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1 && fromAdvancedMenu==1){
			
			continue;
		}
	 	if(dataCenterWorkflowTypeId.equals(wftypeid)&&true) {
			
			continue;
		}
	 		numRows++;
			needtd--;
		%>
 	<div class="listbox2" >
 	<%
 	int isfirst = 1;
	if(dataCenterWorkflowTypeId.equals(wftypeid)){
				
			while(InputReportComInfo.next()){
		
			 	inprepId = InputReportComInfo.getinprepid();
				inprepName=InputReportComInfo.getinprepname();
			 	if(NewInputReports.indexOf(inprepId)==-1){
			 		    continue;
		        }
			 	//check right
			 	if(selectedworkflow.indexOf("R"+inprepId+"|")==-1&& isuserdefault.equals("1")) continue;
			 	if(selectedworkflow.indexOf("R"+inprepId+"|")==-1&& fromAdvancedMenu==1) continue;
			 	i++;
			 	
			 	if(isfirst ==1){
			 		isfirst = 0;
				%>
				<!-- this1 start -->
				<table width=100% height="20px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td class="t-left">&nbsp;</td>
						<td class="t-center"><span class="flag_1"></span><span	class="title_1"><%=Util.toScreen(wftypename,user.getLanguage())%></span></td>
						<td class="t-right">&nbsp;</td>
					</tr>
				</table>
				<ul>
				<!-- this1 end -->	
				<%
				
				
				}
				%>
					<li  style="height:100%;"><a href="javascript:onNewWindow('/datacenter/input/InputReportDate.jsp?inprepid=<%=inprepId%>');">
					<%=inprepName%></a></li>
				<%
			}
			InputReportComInfo.setTofirstRow();
  }
	
	while(WorkflowComInfo.next()){
		String wfname=WorkflowComInfo.getWorkflowname();
	 	String wfid = WorkflowComInfo.getWorkflowid();
	 	String curtypeid = WorkflowComInfo.getWorkflowtype();
        int isagent=0;
        int beagenter=0;
        String agentname="";
        ArrayList agenterlist=new ArrayList();
        //String isvalid=WorkflowComInfo.getIsValid();
	 	if(!curtypeid.equals(wftypeid)) continue;

	 	//check right
	 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
	 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& fromAdvancedMenu==1) continue;

	 	
	 	if(isfirst ==1){
	 		isfirst = 0;
	%>
	<!-- this2 start -->
	<table width="100%" height="20px" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="t-left">&nbsp;</td>
			<td class="t-center"><span class="flag_1"></span><span	class="title_1"><%=Util.toScreen(wftypename,user.getLanguage())%></span></td>
			<td class="t-right">&nbsp;</td>
		</tr>
	</table>

	<ul>
	<!-- this2 end -->
	<%}
        if(NewWorkflows.indexOf(wfid)==-1){
            if(AgentWorkflows.indexOf(wfid)==-1){
	 		    continue;
            }else{
                agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
                isagent=1;
                for(int k=0;k<agenterlist.size();k++){
                    beagenter=Util.getIntValue((String)agenterlist.get(k),0);
                    agentname="("+ResourceComInfo.getResourcename((String)agenterlist.get(k))+"->"+user.getUsername()+")";
                    %>
                        <li  style="height:100%;">
                         <label class="listbox-item-style-<%=getRandom()%>">&nbsp;</label>
                          <a href="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);">
                            <%=Util.toScreen(wfname,user.getLanguage())%>
                          </a><%=agentname%>
                        </li>
                    <%
                }
            }
        }else{
	%>
		<li  style="height:100%;">  <label class="listbox-item-style-<%=getRandom()%>"  >&nbsp;</label>  <a href="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);">
		<%=Util.toScreen(wfname,user.getLanguage())%></a><%=agentname%></li>
	<%
        }
        navigateToWfid = Util.getIntValue(wfid);
	 	navigateToIsagent = isagent;
        navigateToAgenter = beagenter;
		}
		WorkflowComInfo.setTofirstRow();
	%>
		<!-- this3 start -->
		
		<!-- this3 end -->
		  
		<!-- dddd -->
	</div>
	<%
		if(needtd==0){
			needtd=rownum;
	%>
	</td><td width="15px">&nbsp;</td><td width="33%" align=left valign=top>
	<%
		}
	}
	%>		
	</td>
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
<input type="hidden" id="needall" name ="needall" value="">
<input type=hidden name ="prjid" value="<%=prjid%>">
<input type=hidden name ="docid" value="<%=docid%>">
<input type=hidden name ="crmid" value="<%=crmid%>">
<input type=hidden name ="hrmid" value="<%=hrmid%>">
<input type=hidden name ="topage" value="<%=topage%>">
</form>
</body>

</html>


<script language=javascript>

<%
    if(navigateTo){
	    if("true".equals(needPopupNewPage)){
%>
	        var redirectUrl =  "AddRequest.jsp?workflowid="+<%=navigateToWfid%>+"&isagent="+<%=navigateToIsagent%>+"&beagenter=<%=navigateToAgenter%>";
	        var width = screen.availWidth-10 ;
	        var height = screen.availHeight-50 ;
	        var szFeatures = "top=0," ;
	        szFeatures +="left=0," ;
	        szFeatures +="width="+width+"," ;
	        szFeatures +="height="+height+"," ;
	        szFeatures +="directories=no," ;
	        szFeatures +="status=yes,toolbar=no,location=no," ;
	        szFeatures +="menubar=no," ;
	        szFeatures +="scrollbars=yes," ;
	        szFeatures +="resizable=yes" ; //channelmode
	        window.open(redirectUrl,"",szFeatures) ;
<%
	    }else{
%>
	        document.getElementById("workflowid").value="<%=navigateToWfid%>";
	        document.getElementById("isagent").value="<%=navigateToIsagent%>";
	        document.getElementById("beagenter").value="<%=navigateToAgenter%>";
	        document.subform.action = "AddRequest.jsp";
	        document.subform.submit();
<%
	    }
    }
%>

function onuserdefault(flag){
	if(flag==0){
		$G("needall").value = 1;
	}else{
		$G("needall").value = 0;
	}
	$G("needPopupNewPage").value="<%=needPopupNewPage%>";
	$G("isec").value="1";
	$G("topage").value="<%=topage%>";
	$G("subform").action = "/workflow/request/RequestType.jsp";
	$G("subform").submit();
}

function onNewRequest(wfid,agent,beagenter){
	jQuery.post('AddWorkflowUseCount.jsp',{wfid:wfid});
<%
	if("true".equals(needPopupNewPage)){
%>
	    var redirectUrl =  "AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&beagenter="+beagenter;
	    var width = screen.availWidth-10 ;
	    var height = screen.availHeight-50 ;
	    var szFeatures = "top=0," ;
 	    szFeatures +="left=0," ;
	    szFeatures +="width="+width+"," ;
	    szFeatures +="height="+height+"," ;
	    szFeatures +="directories=no," ;
	    szFeatures +="status=yes,toolbar=no,location=no," ;
	    szFeatures +="menubar=no," ;
	    szFeatures +="scrollbars=yes," ;
	    szFeatures +="resizable=yes" ; //channelmode
	    window.open(redirectUrl,"",szFeatures) ;
<%
	}else{
%>
	    document.getElementById("workflowid").value=wfid;
	    document.getElementById("isagent").value=agent;
	    document.getElementById("beagenter").value=beagenter;
	    document.subform.action="AddRequest.jsp";
	    document.subform.submit();
<%
	}
%>
}

function onNewWindow(redirectUrl){
	    var width = screen.availWidth-10 ;
	    var height = screen.availHeight-50 ;
	    var szFeatures = "top=0," ;
 	    szFeatures +="left=0," ;
	    szFeatures +="width="+width+"," ;
	    szFeatures +="height="+height+"," ;
	    szFeatures +="directories=no," ;
	    szFeatures +="status=yes,toolbar=no,location=no," ;
	    szFeatures +="menubar=no," ;
	    szFeatures +="scrollbars=yes," ;
	    szFeatures +="resizable=yes" ; //channelmode
	    window.open(redirectUrl,"",szFeatures) ;
}
</script>