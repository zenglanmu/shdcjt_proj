<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="crmComInfo1" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@page import="weaver.search.SearchClause"%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
session.removeAttribute("RequestViewResource");
Enumeration em = request.getParameterNames();
boolean isinit = true;
while(em.hasMoreElements())
{
	String paramName = (String)em.nextElement();
	if(!paramName.equals("")&&!paramName.equals("date2during"))
	{
		isinit = false;
		break;
	}
}
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统

String fromdate2 = Util.null2String(request.getParameter("fromdate2"));
String todate2 = Util.null2String(request.getParameter("todate2"));

String createrid=Util.null2String(request.getParameter("createrid"));
String docids=Util.null2String(request.getParameter("docids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String hrmids=Util.null2String(request.getParameter("hrmids"));
String prjids=Util.null2String(request.getParameter("prjids"));
String creatertype=Util.null2String(request.getParameter("creatertype"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodetype=Util.null2String(request.getParameter("nodetype"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
String lastfromdate=Util.null2String(request.getParameter("lastfromdate"));
String lasttodate=Util.null2String(request.getParameter("lasttodate"));
String requestmark=Util.null2String(request.getParameter("requestmark"));
String branchid=Util.null2String(request.getParameter("branchid"));
String cdepartmentid=Util.null2String(request.getParameter("cdepartmentid"));
int date2during= Util.getIntValue(request.getParameter("date2during"),0) ;
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
String cdepartmentidspan = "";
ArrayList cdepartmentidArr = Util.TokenizerString(cdepartmentid,",");
for(int i=0;i<cdepartmentidArr.size();i++){
    String tempcdepartmentid = (String)cdepartmentidArr.get(i);
    if(cdepartmentidspan.equals("")) cdepartmentidspan += DepartmentComInfo.getDepartmentname(tempcdepartmentid);
    else cdepartmentidspan += ","+DepartmentComInfo.getDepartmentname(tempcdepartmentid);
}
int during=Util.getIntValue(request.getParameter("during"),0);
int order=Util.getIntValue(request.getParameter("order"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"),0);

String requestname="";
if(request.getParameter("requestname")!=null){
	requestname=Util.fromScreen2(request.getParameter("requestname"),user.getLanguage());
}else{
	requestname = SearchClause.getRequestName();
}
requestname=requestname.trim();

int subday1=Util.getIntValue(request.getParameter("subday1"),0);
int subday2=Util.getIntValue(request.getParameter("subday2"),0);
int maxday=Util.getIntValue(request.getParameter("maxday"),0);
int state=Util.getIntValue(request.getParameter("state"),0);
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());

%>
<BODY>

<%	boolean isUseOldWfMode=sysInfo.isUseOldWfMode();
	if(true){
		int perpage=10;
		boolean hascreatetime =true;
		boolean hascreater =true;
		boolean hasworkflowname =true;
		boolean hasrequestlevel =true;
		boolean hasrequestname =true;
		boolean hasreceivetime =true;
		boolean hasstatus =true;
		boolean hasreceivedpersons =true;
		boolean hascurrentnode =true;
		RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
		if(RecordSet.next()){
		    if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
		    if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
		    if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
		    if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
		    if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
		    if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
		    if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
		    if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
		    if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
		    perpage= RecordSet.getInt("numperpage");
		}else{
		    RecordSet.executeProc("workflow_RUserDefault_Select","1");
		    if(RecordSet.next()){
		        if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
		        if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
		        if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
		        if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
		        if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
		        if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
		        if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
		        if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
		        if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
		        perpage= RecordSet.getInt("numperpage");
		    }
		}
		//boolean hasSubWorkflow =false;

		/*如果所有的列都不显示，那么就显示所有的，避免页面出错*/
		if(!hascreatetime&&!hascreater&&!hasworkflowname&&!hasrequestlevel&&!hasrequestname&&!hasreceivetime&&!hasstatus&&!hasreceivedpersons&&!hascurrentnode){
			hascreatetime =true;
			hascreater =true;
			hasworkflowname =true;
			hasrequestlevel =true;
			hasrequestname =true;
			hasreceivetime =true;
			hasstatus =true;
			hasreceivedpersons =true;
			hascurrentnode =true;			
		}

		/****
		if(workflowid!=null&&!workflowid.equals("")&&workflowid.indexOf(",")==-1){
			RecordSet.executeSql("select id from Workflow_SubWfSet where mainWorkflowId="+workflowid);
			if(RecordSet.next()){
				hasSubWorkflow=true;
			}

			RecordSet.executeSql("select id from Workflow_TriDiffWfDiffField where mainWorkflowId="+workflowid);
			if(RecordSet.next()){
				hasSubWorkflow=true;
			}
		}

		******/
		
		int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;


		String colsTableBaseParas = "";
		String para4=user.getLanguage()+"+"+user.getUID();
		if(hascreatetime)
			//colsTableBaseParas+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
			colsTableBaseParas+="{'para_1':'column:createdate','para_2':'column:createtime','para_3':'','hideable':true,'sortable':true,'flex':0.1,'dataIndex':'createdate,createtime','header':'"+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'createdate','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime','href':''},";
		if(hascreater)
			//colsTableBaseParas+="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
			colsTableBaseParas+="{'para_1':'column:creater','para_2':'column:creatertype','para_3':'','hideable':true,'sortable':true,'flex':0.06,'dataIndex':'creater','header':'"+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'creater','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getWFSearchResultName','href':''},";
		if(hasworkflowname)
			//colsTableBaseParas+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
			colsTableBaseParas+="{'para_1':'column:workflowid','para_2':'','para_3':'','hideable':true,'sortable':true,'flex':0.1,'dataIndex':'t1$&$workflowid','header':'"+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'workflowid','target':'','transmethod':'weaver.workflow.workflow.WorkflowComInfo.getWorkflowname','href':''},";
		if(hasrequestlevel)
			//colsTableBaseParas+="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
			colsTableBaseParas+="{'para_1':'column:requestlevel','para_2':'"+user.getLanguage()+"','para_3':'','hideable':true,'sortable':true,'flex':0.08,'dataIndex':'requestlevel','header':'"+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'requestlevel','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree','href':''},";
		if(hasrequestname){
			//colsTableBaseParas+="				<col width=\"19%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""+para2+"\"/>";

		String para2="column:requestid+column:workflowid+column:viewtype+"+isovertime+"+"+user.getLanguage()+"+column:nodeid+column:isremark+"+String.valueOf(user.getUID())+"+column:agentorbyagentid+column:agenttype";
		String paraAgent="column:requestid+column:agentorbyagentid+column:agenttype";
		colsTableBaseParas+="{'para_1':'column:requestname','para_2':'"+para2+"','para_3':'','hideable':true,'sortable':true,'flex':0.14,'dataIndex':'requestname','header':'"+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"','linkkey':'requestid','linkvaluecolumn':'requestid','column':'requestname','target':'requestid','transmethod':'weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle','href':''},";
		//colsTableBaseParas+="{'para_1':'column:viewtype','para_2':'"+paraAgent+"','para_3':'','hideable':true,'sortable':true,'width':0.06,'resizable':false,'dataIndex':'viewtype','header':'"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'viewtype','target':'requestid','transmethod':'weaver.general.WorkFlowTransMethod.getWfViewTypeExtIncludeAgent','href':''},";			
		
		}
		if(hascurrentnode)
			//colsTableBaseParas+="				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(15586,user.getLanguage())+"\" column=\"currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
			colsTableBaseParas+="{'para_1':'column:currentnodeid','para_2':'','para_3':'','hideable':true,'sortable':true,'flex':0.08,'dataIndex':'currentnodeid','header':'"+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(15586,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'currentnodeid','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getCurrentNode','href':''},";
		if(hasreceivetime)
			//colsTableBaseParas+="			    <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"t2.receivedate,t2.receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
			colsTableBaseParas+="{'para_1':'column:receivedate','para_2':'column:receivetime','para_3':'','hideable':true,'sortable':true,'flex':0.1,'dataIndex':'receivedate,receivetime','header':'"+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'receivedate','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime','href':''},";
		if(hasstatus)
			//colsTableBaseParas+="			    <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" />";
			colsTableBaseParas+="{'para_1':'','para_2':'','para_3':'','hideable':true,'sortable':true,'flex':0.08,'dataIndex':'status','header':'"+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'status','target':'','transmethod':'','href':''},";
		if(hasreceivedpersons)
			//colsTableBaseParas+="			    <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16354,user.getLanguage())+"\" column=\"requestid\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
			colsTableBaseParas+="{'para_1':'column:requestid','para_2':'"+para4+"','para_3':'','hideable':true,'sortable':true,'flex':0.15,'dataIndex':'t1$&$requestid','header':'"+SystemEnv.getHtmlLabelName(16354,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'requestid','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getUnOperators','href':''},";
		//colsTableBaseParas+="{'para_1':'column:workflowid','para_2':'','para_3':'','hideable':true,'sortable':false,'width':0.01,'dataIndex':'multiSubmit','header':'','linkkey':'','linkvaluecolumn':'','column':'multiSubmit','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getWFSearchResultCheckBox','href':''},";
		colsTableBaseParas = colsTableBaseParas.substring(0,colsTableBaseParas.length()-1);

 
			String multiSubmit="{'para_1':'column:workflowid','para_2':'column:isremark','flex':0.02,'para_3':'column:requestid','hideable':true,'sortable':false,'flex':0.01,'dataIndex':'multiSubmit','header':'','linkkey':'','linkvaluecolumn':'','column':'multiSubmit','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getCanMultiSubmitExt','href':''}"; 
	 
		String allColumns =  colsTableBaseParas+","+multiSubmit;
		allColumns = "["+allColumns+"]";
		colsTableBaseParas = "["+colsTableBaseParas+"]";
%>

	<div id='simpleSearchDiv' style="display:none">
	 <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<form id="frmmain" method="post" action="WFSearchTemp.jsp">
	            <TABLE class=ViewForm  valign="top">
	                    <TR valign="top">	
							<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
	                         <TD CLASS="Field">
	                         
								<input type=text value="<%=requestname%>" name="requestname" class = 'InputStyle' style="width:60%"> 
								 <SPAN id=remind style='cursor:hand'>
								<IMG src='/images/remind.png' align=absMiddle>
								</SPAN>
	                         </TD>
							
	                        <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></TD>
	                         <TD CLASS="Field">
	                            
							  <select class=inputstyle  name=creatertype>
						<%if(!user.getLogintype().equals("2")){%>
							<%if(isgoveproj==0){%>
							  <option value="0" <%if (creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							 <%}else{%>
							 <option value="0"><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
							 <%}%>
						<%}%>
							<%if(isgoveproj==0){%>
							  <option value="1" <%if (creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
							  <%}%>
							  </select>
							  &nbsp
							  <button type=button  class=browser onClick="onShowResource()"></button>
							<span id=resourcespan>
							<%=ResourceComInfo.getResourcename(createrid)%>
							</span>
							<input name=createrid type=hidden value="<%=createrid%>">
		                   </TD>
		                   
						</TR>
						<TR style="height:1px;"><td colspan=4 class="line"></td></TR>
	  					<TR valign="top">	
	                         <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></TD>
	                         <TD  WIDTH="20%" CLASS="Field">
	                         <select class=inputstyle  name=requestlevel style=width:60% size=1>
							    <option value=""> </option>
								  <option value="0" <% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
								  <option value="1" <% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
								  <option value="2" <% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
								</select>
							           
	                         </TD>
	                         <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(17994,user.getLanguage())%></TD>
	                         <TD width ="20%" CLASS="Field"> 
	                            <button type=button  class=calendar id=SelectDate3  onclick="gettheDate(fromdate2,fromdatespan2)"></BUTTON>
							      <SPAN id=fromdatespan2 ><%=fromdate2%></SPAN>
							      -&nbsp;&nbsp;<button type=button  class=calendar id=SelectDate4 onclick="gettheDate(todate2,todatespan2)"></BUTTON>
							      <SPAN id=todatespan2 ><%=todate2%></SPAN>
								  <input type="hidden" name="fromdate2" value="<%=fromdate2%>"><input type="hidden" name="todate2" value="<%=todate2%>">
	                         </TD>
	                    </TR>
	                    <TR style="height:1px;"><td colspan=4 class="line"></td></TR>
	                    <%if(date2duringTokens.length>0){ %>
		                 <tr>
	                        <!-- 接收期间 -->
        					<td class="lable"><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
						    <td class="field">
						     <select class=inputstyle  size=1 id=date2during name=date2during style=width:40%>
						     	<option value="">&nbsp;</option>
						     	<%
						     	for(int i=0;i<date2duringTokens.length;i++)
						     	{
						     		int tempdate2during = Util.getIntValue(date2duringTokens[i],0);
						     		if(tempdate2during>36||tempdate2during<1)
						      		{
						      			continue;
						      		}
						     	%>
						     	<!-- 最近个月 -->
	     						<option value="<%=tempdate2during %>" <%if (date2during==tempdate2during) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
						     	<%
						     	} 
						     	%>
						     	<!-- 全部 -->
	     						<option value="38" <%if (date2during==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						     </select>
						    </td>
						    <TD colSpan=2>&nbsp;</TD>
	                      </tr>
						  <TR style="height:1px;">
							<TD class=Line colSpan=4></TD>
						  </TR>
	                    <%} %>

								 
								
	                    
	                </TABLE> 
	                
                <div id='advicedSearchDiv' style="display:none">
								
							<TABLE class=ViewForm  valign="top">

								 <tr>
			 	               		<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
								     <TD WIDTH="20%"  class=field>
								     <input type=text name=requestmark  style=width:60%  value="<%=requestmark%>" class="InputStyle">
								    </td> 							
								    
									    <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
									    <TD WIDTH="20%"  class=field><button type=button  class=calendar id=SelectDate onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>&nbsp;
									      <SPAN id=fromdatespan ><%=fromdate%></SPAN>
									      -&nbsp;&nbsp;<button type=button  class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>&nbsp;
									      <SPAN id=todatespan ><%=todate%></SPAN>
										  <input type="hidden" name="fromdate" class=Inputstyle value="<%=fromdate%>"><input type="hidden" name="todate" class=Inputstyle  value="<%=todate%>">
									    </td> 
									
								 </tr>
								 <TR  style="height:1px;" class=Separartor><TD class="Line" COLSPAN=4></TD></TR>
								
								  
									  <tr>
									  	<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></td>
								     <TD WIDTH="20%"  class=field>
								     <select class=inputstyle  size=1 name=isdeleted style=width:60%>
								     	<option value="0" <%if (isdeleted==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
								     	<option value="1" <%if (isdeleted==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
								     	<option value="2" <%if (isdeleted==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								     </select>
								    </td>
									    <td><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
									    <td class=field>
									     <select class=inputstyle  size=1 name=during style=width:60%>
									     	<option value="">&nbsp;</option>
									     	<option value="1" <%if (during==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
									     	<option value="2" <%if (during==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15538,user.getLanguage())%></option>
									     	<option value="3" <%if (during==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
									     	<option value="4" <%if (during==4) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15540,user.getLanguage())%>7</option>
									     	<option value="5" <%if (during==5) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
									     	<option value="6" <%if (during==6) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15540,user.getLanguage())%>30</option>
									     	<option value="7" <%if (during==7) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15542,user.getLanguage())%></option>
									     	<option value="8" <%if (during==8) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15540,user.getLanguage())%>365</option>
									     </select>
									    </td>
									  </tr>
								
			 						 <TR style="height:1px;"><TD class="Line" COLSPAN=4></TD></TR>
									 <tr>
								    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
								    <td class=field>
								    
								    <button type=button  class=browser onClick="onShowWorkFlowSerach('workflowid','workflowspan')"></button>
									<span id=workflowspan>
									<%=WorkflowComInfo.getWorkflowname(""+workflowid)%>
									</span>
									<input name=workflowid type=hidden value=<%=workflowid%>>
								    </td>
								    <td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
								    <td class=field>
								     <select class=inputstyle  size=1 name=nodetype style=width:60%>
								     	<option value="">&nbsp;</option>
								     	<option value="0" <%if (nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
								     	<option value="1" <%if (nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
								     	<option value="2" <%if (nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
								     	<option value="3" <%if (nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
								     </select>
								    </td>
								  </tr>
								  
								  
								  <TR  style="height:1px;" class=Separartor><TD class="Line" COLSPAN=4></TD></TR>
									   <tr>
									    <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
									    <td class=field><button type=button  class=browser onClick="onShowDocids()"></button>
										<span id=docidsspan><%=(!docids.equals(""))?DocComInfo1.getDocname(docids):""%></span>
										<input name=docids type=hidden value="<%=docids%>">
									    </td>
									<%if(isgoveproj==0){%>
									    <td><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></td>
									    <td class=field><button type=button  class=browser onClick="onShowCrmids()"></button>
										<span id=crmidsspan><%=crmComInfo1.getCustomerInfoname(crmids)%></span>
										<input name=crmids type=hidden value="<%=crmids%>"></td>
									<%}else{%>
									<%if(!user.getLogintype().equals("2")){%>
									    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
									    <td class=field><button type=button  class=browser onClick="onShowHrmids()"></button>
										<span id=hrmidsspan></span>
										<input name=hrmids type=hidden >
									    </td>
									<%}%>
									<%}%>
									  </tr>
  
  
								<TR style="height:1px;"><TD class="Line" COLSPAN=4></TD></TR>
								 <%if(isgoveproj==0){%>
								  <tr>
								    <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
								    <td class=field><button type=button  class=browser onClick="onShowPrjids()"></button>
									<span id=prjidsspan><%=ProjectInfoComInfo1.getProjectInfoname(prjids)%></span>
									<input name=prjids type=hidden value="<%=prjids%>"></td>
								    
								<%if(!user.getLogintype().equals("2")){%>
								    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
								    <td class=field><button type=button  class=browser onClick="onShowHrmids()"></button>
									<span id=hrmidsspan><%=ResourceComInfo.getResourcename(hrmids)%></span>
									<input name=hrmids type=hidden value="<%=hrmids%>">
								    </td>
								<%}else{%>
								<td colspan=2></td>
								<%} %>
								</tr>
								<TR style="height:1px;"><TD class="Line" COLSPAN=4></TD></TR>
								  
								  <%}%>
								
								  
								  	 <tr>
									     
									 <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
									    <td class=field>
									      <button type=button  class=browser onClick="onShowBranch()"></button>
										<span id=branchspan><%=SubCompanyComInfo.getSubCompanyname(branchid)%></span>
										<input name=branchid type=hidden  value="<%=branchid%>">
									    </td> 
									<td ><%=SystemEnv.getHtmlLabelName(19225,user.getLanguage())%></td>
                                         <td class=field>
									      <button type=button  class=browser onClick="onShowDepartment('cdepartmentidspan','cdepartmentid')"></button>
										<span id=cdepartmentidspan><%=cdepartmentidspan%></span>
										<input name=cdepartmentid type=hidden  value="<%=cdepartmentid%>">
									    </td>  
									    </tr>   
								      <TR style="height:1px;"><td colspan=4 class="line"></td></TR>
								 
								  
								  </TABLE>
			   				    </div> 
                                <TABLE class=ViewForm  valign="top">
                                    <tr>
                                        <td colspan='4' align ='right'>
                                        <a id="searchAdviceHref"  href="#" onClick="showSearchAdvice(this)"><img name="searchAdviceImg" src="/images/down.png" align=absMiddle><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></a>
                                        </td>
                                    </tr>
                                </TABLE>
                  
                <input type="hidden" id="isinit" name="isinit" value="<%=isinit%>">
                </form>
	</div>
	 <div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
	</div>
				
	
	
	<%
	BaseBean baseBean_self = new BaseBean();
	int userightmenu_self = 1;
	String topButton="";
	try{
		userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
	}catch(Exception e){}
	%>
	
	<%
	//userightmenu_self = 0;
	if(userightmenu_self==1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:firstPage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:prePage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript: nextPage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:lastPage(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:location.href='/workflow/request/RequestUserDefault.jsp',_top}} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}else{
		topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+"',handler:function(){onBtnSearchClick();}},";
		topButton +="'-',";
		topButton +="{iconCls:'btn_first',text:'"+SystemEnv.getHtmlLabelName(18363, user.getLanguage())+"',handler:function(){firstPage();}},";
		topButton +="'-',";
		topButton +="{iconCls:'btn_previous',text:'"+SystemEnv.getHtmlLabelName(1258, user.getLanguage())+"',handler:function(){prePage();}},";
		topButton +="'-',";
		topButton +="{iconCls:'btn_next',text:'"+SystemEnv.getHtmlLabelName(1259, user.getLanguage())+"',handler:function(){nextPage();}},";
		topButton +="'-',";
		topButton +="{iconCls:'btn_end',text:'"+SystemEnv.getHtmlLabelName(18362, user.getLanguage())+"',handler:function(){lastPage();}},";
		topButton +="'-',";
		if(isSysadmin!=1){
			topButton +="{iconCls:'btn_custom',text:'"+SystemEnv.getHtmlLabelName(73, user.getLanguage())+"',handler:function(){location.href='/workflow/request/RequestUserDefault.jsp'}}";
		}else{
			topButton +="{iconCls:'btn_custom',text:'"+SystemEnv.getHtmlLabelName(73, user.getLanguage())+"',handler:function(){location.href='/workflow/request/RequestUserDefault.jsp'}},";
			topButton +="'-',";
			topButton +="{iconCls:'btn_viewUrl',text:'"+SystemEnv.getHtmlLabelName(21682, user.getLanguage())+"',handler:function(){viewSourceUrl()}}";
		}
		topButton = "["+topButton+"]";
	}
%>
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>
	
	
	<%@ include file="/docs/docs/DocCommExt.jsp"%>
				
	<%@ include file="/systeminfo/TopTitleExt.jsp"%>
	<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid.css" />	
	<script type="text/javascript">
		
		
		var imagefilename = '<%=imagefilename%>';
		var titlename = '<%=titlename%>'
		var colsTableBaseParas = <%=colsTableBaseParas%>;
		 //alert(colsTableBaseParas);
   		var isFirst =true;
	    var TableBaseParas={
	    				"multiSubmit":false,
	    				"gridId":'',
						"sqlwhere":"receivedate",
						"sort":"receivedate,receivetime",
						"operates":[],
						"excerpt":"",
						"sqlisprintsql":"",
						"backfields":"",
						"columns":colsTableBaseParas,
						"pageSize":<%=perpage%>,					
						"poolname":"","sqlgroupby":"",
						"dir":"desc",
						"sqlisdistinct":"",
						"sqlprimarykey":"",
						"sqlform":"",
						"popedom":{"otherpara":"","otherpara2":"","transmethod":""}
		};
		
		var multiSubmit = <%=multiSubmit%>;
		var allColumns = <%=allColumns%>;
		var gridUrl=' /weaver/weaver.common.util.taglib.SplitPageXmlServletNew';
		
		 new Ext.ToolTip({
		        target: 'remind',
		        title: wmsg.wf.searchRemind,
		        //width:350,
		         anchor: 'top',
		        html: wmsg.wf.searchRemindMsg,
		        trackMouse:false,
		        autoHide: true,
		        closable: false,
		        dismissDelay: 20000
		    });
		 
		 
		
		_isViewPort=true;
		_pageId="ExtWfSearch";  
		_divSearchDiv='simpleSearchDiv'; 
		
		_defaultSearchStatus='show';  //close //show //more		
		//_divSearchDivHeight=180; 2012-08-23 ypc  修改  原来的180 高度有点小 导致右键菜单屏蔽之后 显示有问题
		_divSearchDivHeight=196;	
		
		userightmenu_self = '<%=userightmenu_self%>';
		if(userightmenu_self!=1){
			_divSearchDivHeightNo = 61;
			<%if(userightmenu_self!=1){%>
			eval(rightMenuBarItem = <%=topButton%>);
			<%}%>
		}else{
			_divSearchDivHeightNo = 33;
		}
		
		function URLencode(sStr) 
		{
			return myescapecode(sStr);
		    //return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
		}
				
		function search(){  //确认搜索提交按钮
			var wfSearchForm = document.getElementById('frmmain');
			
			var searchPara ='';
		
			for(i=0;i<wfSearchForm.elements.length;i++)
			{
		
				if(wfSearchForm.elements[i].name!= ''){
		
					if(wfSearchForm.elements[i].value!=''){
						if(wfSearchForm.elements[i].name=='requestname'){
							searchPara+='&'+wfSearchForm.elements[i].name+'='+URLencode(wfSearchForm.elements[i].value);
						}else{
							searchPara+='&'+wfSearchForm.elements[i].name+'='+wfSearchForm.elements[i].value;
						}
					}
				}
			}
			var isinit = document.getElementById("isinit").value;
			if(searchPara!='' && searchPara!='&creatertype=0')
			{
				searchPara+='&fromself=1&isfirst=1&isovertime=0';
				//if(isinit=="false")
				loadGrid(searchPara);
				
			}else{
				//if(isinit=="false")
				loadGrid('');
			}
		}	
		
		function onBtnSearchClick(){
			try
			{
				var isinit = document.getElementById("isinit").value;
				if(isinit=="true")
				{
					//var wfsearchtab = Ext.getCmp('wfsearchtab');
					//wfsearchtab.show();
					//wfsearchtab.setHeight(wfsearchtab.getHeight()-1);
					document.getElementById("isinit").value = "false";
				}
			}
			catch(e)
			{
			}
			if(_btnSearchStatusShow)  search();
       		 else _onShowOrHidenSearch();    					
		}
		 
	</script>
	<script type='text/javascript' src='/js/WeaverTablePlugins.js'></script>
	<script type="text/javascript" src="/js/wfsearch.js"></script>
	<script type="text/javascript">
			var isgoveproj = '<%=isgoveproj%>';
			function showSearchAdvice(obj){
				var searchPanel = panelTitle.findById('searchPanel');
				if(Ext.getDom("advicedSearchDiv").style.display=='none'){
					
					document.searchAdviceImg.src = '/images/up.png';
					if(isgoveproj=='0'){
						_divSearchDivHeight=245;	
						if(userightmenu_self!=1){
							searchPanel.setHeight(205-25);
						}else{
							searchPanel.setHeight(205);
						}
					}else{
						_divSearchDivHeight=225;
						if(userightmenu_self!=1){
							searchPanel.setHeight(185-25);
						}else{
							searchPanel.setHeight(185);
						}
						
					}
					Ext.getDom("advicedSearchDiv").style.display='';
					//_divSearchDivHeight=315;	
					//searchPanel.setHeight(275);
				}else{
					Ext.getDom("advicedSearchDiv").style.display='none';
					document.searchAdviceImg.src = '/images/down.png';
					_divSearchDivHeight=135;
					searchPanel.setHeight(105);
				}
				//var row=obj.parentNode.parentNode;
				//var line = row.previousSibling;
				//row.parentNode.removeChild(row);
				//line.parentNode.removeChild(line);
				panelTitle.setHeight(_divSearchDivHeight);
				viewport.doLayout();
			}
			//暂时没用这个函数
			function showreceiviedPopup(content){
					//alert(content+"测试");
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
			
			
				function ajaxinit(){
				    var ajax=false;
				    try {
				        ajax = new ActiveXObject("Msxml2.XMLHTTP");
				    } catch (e) {
				        try {
				            ajax = new ActiveXObject("Microsoft.XMLHTTP");
				        } catch (E) {
				            ajax = false;
				        }
				    }
				    if (!ajax && typeof XMLHttpRequest!='undefined') {
				    ajax = new XMLHttpRequest();
				    }
				    return ajax;
				}
			
				var showTableDiv  = document.getElementById('divshowreceivied');
				var oIframe = document.createElement('iframe');
				function showallreceived(requestid,returntdid){
					//var content = "<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>";
					//alert(content);
				    //showreceiviedPopup(content); //2012-07-31 ypc 修改
				    var ajax=ajaxinit();
				    ajax.open("POST", "/workflow/search/WorkflowUnoperatorPersons.jsp", true);
				    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
				    //获取执行状态
				    //alert(ajax.readyState);
					//alert(ajax.status);
				    ajax.onreadystatechange = function() {
				        //如果执行状态成功，那么就把返回信息写到指定的层里
				        if (ajax.readyState==4&&ajax.status == 200) {
				            try{
				            document.all(returntdid).innerHTML = ajax.responseText.trim();
				            document.all(returntdid).title = ajax.responseText.trim();
				            }catch(e){}
				            showTableDiv.style.display='none';
				            oIframe.style.display='none';
				        } 
				    } 
				}
				
	</script>
<%		
	}
	else{
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
String topButton ="";
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
%>

<%
userightmenu_self = 0;
if(userightmenu_self==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:frmmain.reset(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:location.href='/workflow/request/RequestUserDefault.jsp',_top}} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
}else{
	topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+"',handler:function(){submitData();}},";
	topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(199, user.getLanguage())+"',handler:function(){frmmain.reset();}},";
	topButton +="{iconCls:'btn_custom',text:'"+SystemEnv.getHtmlLabelName(73, user.getLanguage())+"',handler:function(){location.href='/workflow/request/RequestUserDefault.jsp';}}";
	topButton = "["+topButton+"]";
}
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="frmmain" method="post" action="WFSearchTemp.jsp">
<input name=iswaitdo type=hidden value="<%=iswaitdo%>">

<br>

<table width=100% height=94% border="0" cellspacing="0" cellpadding="0">
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
  <col width="39%">
  <col width="8">
  <col width="10%">
  <col width="39%">
  <tbody>
  <TR class="Title"><th COLSPAN=5><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%></th></TR>
  <TR class=Separartor><TD class="Line1" COLSPAN=5></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
    <td class=field>
     <input type=text name=requestmark  style="width:240px;" class=Inputstyle value="<%=requestmark%>">
    </td>  <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></td>
    <td class=field>
     <select class=inputstyle  size=1 name=isdeleted style=width:240>
     	<option value="0" <%if (isdeleted==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
     	<option value="1" <%if (isdeleted==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
     	<option value="2" <%if (isdeleted==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
     </select>
    </td>

  </tr>
   <TR class=Separartor  style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td class=field>
    
    <button type=button  class=browser onClick="onShowWorkFlowSerach('workflowid','workflowspan')"></button>
	<span id=workflowspan>
	<%=WorkflowComInfo.getWorkflowname(""+workflowid)%>
	</span>
	<input name=workflowid type=hidden value=<%=workflowid%>>
    </td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
    <td class=field>
     <select class=inputstyle  size=1 name=nodetype style=width:240>
     	<option value="">&nbsp;</option>
     	<option value="0" <%if (nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
     	<option value="1" <%if (nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
     	<option value="2" <%if (nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
     	<option value="3" <%if (nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
     </select>
    </td>
  </tr><TR style="height:1px;" class=Separartor><TD class="Line" COLSPAN=5></TD></TR>
  
  <!--TR class=Separartor><TD class="Line1" COLSPAN=5></TD></TR-->
  <tr><td class=5>&nbsp;</td></tr>
  <TR class="Title"><th COLSPAN=5><%=SystemEnv.getHtmlLabelName(401,user.getLanguage())%></th></TR>
  <TR class=Separartor style="height:1px;"><TD class="Line1" COLSPAN=5></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
    <td class=field><button type=button  class=calendar id=SelectDate onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>&nbsp;
      <SPAN id=fromdatespan ><%=fromdate%></SPAN>
      -&nbsp;&nbsp;<button type=button  class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>&nbsp;
      <SPAN id=todatespan ><%=todate%></SPAN>
	  <input type="hidden" name="fromdate" class=Inputstyle value="<%=fromdate%>"><input type="hidden" name="todate" class=Inputstyle  value="<%=todate%>">
    </td> 
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
    <td class=field>
     <select class=inputstyle  size=1 name=during style=width:240>
     	<option value="">&nbsp;</option>
     	<option value="1" <%if (during==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
     	<option value="2" <%if (during==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15538,user.getLanguage())%></option>
     	<option value="3" <%if (during==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
     	<option value="4" <%if (during==4) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15540,user.getLanguage())%>7</option>
     	<option value="5" <%if (during==5) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
     	<option value="6" <%if (during==6) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15540,user.getLanguage())%>30</option>
     	<option value="7" <%if (during==7) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15542,user.getLanguage())%></option>
     	<option value="8" <%if (during==8) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15540,user.getLanguage())%>365</option>
     </select>
    </td>
  </tr>
  <TR style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>
  <tr>
      <td ><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
	  <td class=field>
	  <select class=inputstyle  name=creatertype>
<%if(!user.getLogintype().equals("2")){%>
	<%if(isgoveproj==0){%>
	  <option value="0" <%if (creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
	 <%}else{%>
	 <option value="0"><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
	 <%}%>
<%}%>
	<%if(isgoveproj==0){%>
	  <option value="1" <%if (creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
	  <%}%>
	  </select>
	  &nbsp
	  <button type=button  class=browser onClick="onShowResource()"></button>
	<span id=resourcespan>
	<%=ResourceComInfo.getResourcename(createrid)%>
	</span>
	<input name=createrid type=hidden value="<%=createrid%>"></td>
	<td>&nbsp;</td>
 <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><br><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
    <td class=field>
      <button type=button  class=browser onClick="onShowBranch()"></button>
	<span id=branchspan><%=SubCompanyComInfo.getSubCompanyname(branchid)%></span>
	<input name=branchid type=hidden  value="<%=branchid%>">
    </td> 
 
    </tr> 
	<TR style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>

<!--tr><TD class="Line1" COLSPAN=5></TD></TR-->
 <tr><td>&nbsp;</td></tr>

 <TR class="Title"><th COLSPAN=5><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%></th></TR>
  <TR class=Separartor style="height:1px;"><TD class="Line1" COLSPAN=5></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
    <td class=field><button type=button  class=browser onClick="onShowDocids()"></button>
	<span id=docidsspan><%=(!docids.equals(""))?DocComInfo1.getDocname(docids):""%></span>
	<input name=docids type=hidden value="<%=docids%>">
    </td>
    <td>&nbsp;</td>
<%if(isgoveproj==0){%>
    <td><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></td>
    <td class=field><button type=button  class=browser onClick="onShowCrmids()"></button>
	<span id=crmidsspan><%=crmComInfo1.getCustomerInfoname(crmids)%></span>
	<input name=crmids type=hidden value="<%=crmids%>"></td>
<%}else{%>
<%if(!user.getLogintype().equals("2")){%>
    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
    <td class=field><button type=button  class=browser onClick="onShowHrmids()"></button>
	<span id=hrmidsspan></span>
	<input name=hrmids type=hidden >
    </td>
<%}%>
<%}%>
  </tr><TR style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>

<%if(isgoveproj==0){%>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
    <td class=field><button type=button  class=browser onClick="onShowPrjids()"></button>
	<span id=prjidsspan><%=ProjectInfoComInfo1.getProjectInfoname(prjids)%></span>
	<input name=prjids type=hidden value="<%=prjids%>"></td>
    <td>&nbsp;</td>
<%if(!user.getLogintype().equals("2")){%>
    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
    <td class=field><button type=button  class=browser onClick="onShowHrmids()"></button>
	<span id=hrmidsspan><%=ResourceComInfo.getResourcename(hrmids)%></span>
	<input name=hrmids type=hidden value="<%=hrmids%>">
    </td>
<%}%>

  </tr>
  
  
<TR style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>
  <tr><td>&nbsp;</td></tr>
  <%}%>


 <TR class="Title"><th COLSPAN=5><%=SystemEnv.getHtmlLabelName(19533,user.getLanguage())%></th></TR>
  <TR class=Separartor style="height:1px;"><TD class="Line1" COLSPAN=5></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
    <td class=field><input type=text name=requestname size=30  class=Inputstyle value="<%=requestname%>"></td>
	<td>&nbsp;</td>
     <td ><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>

	<td class=field>
	<select class=inputstyle  name=requestlevel style=width:240 size=1>
	  <option value=""> </option>
	  <option value="0" <%if (requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
	  <option value="1" <%if (requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
	  <option value="2" <%if (requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
	</select>
	</td>
    <td >
    </td>
  </tr>
   <TR class=Separartor style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>

  <input type="hidden" name="ifcustom">
 
  </tbody>
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

</form>
<% }%>
<script language="javascript" src="/js/browser/WorkFlowBrowser.js"></script>

<script language="javascript">
function enablemenuall()
{
for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++)
		{
		window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
}
//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
}
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function ifCustom(workflowid){
    var ajax=ajaxinit();
	
    ajax.open("POST", "SearchCustomCon.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("workflowid="+workflowid);
    //获取执行状态
    //alert(ajax.readyState);
	//alert(ajax.status);
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState==4&&ajax.status == 200) {
            try{
            
            document.all("ifcustom").value= ajax.responseText;
            }catch(e){
			document.all("ifcustom").value= 1;
			}
           
        } 
    } 
}




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

<script type="text/javascript">

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}
function onShowResource() {
	var tmpval = $G("creatertype").value;
	if (tmpval == "0") { 
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	} else {
		url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	}
	disModalDialog(url, $G("resourcespan"), $G("createrid"), false);
}

function onShowBranch() {
	url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $G("branchid").value;
	disModalDialog(url, $G("branchspan"), $G("branchid"), false);
}

function onShowDocids() {
	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1";
	disModalDialog(url, $G("docidsspan"), $G("docids"), false);
}

function onShowCrmids() {
	url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	disModalDialog(url, $G("crmidsspan"), $G("crmids"), false);
	
}

function onShowHrmids() {
	url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	disModalDialog(url, $G("hrmidsspan"), $G("hrmids"), false);
}

function onShowPrjids() {
	url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	disModalDialog(url, $G("prjidsspan"), $G("prjids"), false);
}

function onShowDepartment(tdname, inputename) {
	url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + $G(inputename).value;
	disModalDialog(url, $G(tdname), $G(inputename), false);
	if ($G(inputename).value != "") {
		$G(inputename).value = $G(inputename).value.substr(1);
		$G(tdname).innerHTML = $G(tdname).innerHTML.substr(1); 
	}
}
function onShowWorkFlowSerach(inputname, spanname) {
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp";
	disModalDialog(url, $G(spanname), $G(inputname), false);
}
</script>



</body>

<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>