<%@ page import="java.util.*" %>
<%@page import="org.json.JSONObject"%> 
<%@page import="org.json.JSONArray"%>
<%@ page import="weaver.general.*,weaver.workflow.request.WFWorkflows,weaver.workflow.request.WFWorkflowTypes"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

<link href="/zfh/wui.css" type="text/css" rel="STYLESHEET"> 
</head>

<%
    String imagefilename = "/images/hdReport.gif";
    String titlename =  SystemEnv.getHtmlLabelName(21218,user.getLanguage()) + ": "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>

<body>


<%
    int logintype = Util.getIntValue(user.getLogintype());
    int userID = user.getUID();
    WFUrgerManager.setLogintype(logintype);
    WFUrgerManager.setUserid(userID); 
    ArrayList wftypes=WFUrgerManager.getWrokflowTree();
    int totalcount=WFUrgerManager.getTotalcounts();
%>


<%

boolean isUseOldWfMode=sysInfo.isUseOldWfMode();
if(!isUseOldWfMode){
	int typerowcounts=wftypes.size();
	//typerowcounts=(wftypes.size()+1)/2;
	JSONArray jsonWfTypeArray = new JSONArray();
    for(int i=0;i<typerowcounts;i++){
    	             
	   	JSONObject jsonWfType = new JSONObject();
	    jsonWfType.put("draggable",false);
		jsonWfType.put("leaf",false);
		
		 WFWorkflowTypes wftype=(WFWorkflowTypes)wftypes.get(i);
         ArrayList workflows=wftype.getWorkflows();
         String typeid=""+wftype.getWftypeid();
         String typename=WorkTypeComInfo.getWorkTypename(typeid);
         int counts=wftype.getCounts();
        
      
		jsonWfType.put("paras","method=type&objid="+typeid);
		jsonWfType.put("cls","wfTreeFolderNode");	
		
		int newrequestsCount = 0;
        JSONArray jsonWfTypeChildrenArray = new JSONArray();
        for(int j=0;j<workflows.size();j++){
        	String wfText = "";
        	 WFWorkflows wfworkflow=(WFWorkflows)workflows.get(j);
             ArrayList requests=wfworkflow.getReqeustids();
             ArrayList newrequests=wfworkflow.getNewrequestids();
             String workflowname=wfworkflow.getWorkflowname();
             int workflowid=wfworkflow.getWorkflowid();
        	        	            
            JSONObject jsonWfTypeChild = new JSONObject();
        	jsonWfTypeChild.put("draggable",false);
        	jsonWfTypeChild.put("leaf",true);
			
			jsonWfTypeChild.put("paras","method=workflow&objid="+workflowid);
			wfText +="<a  href=# onClick=javaScript:loadGrid('"+jsonWfTypeChild.get("paras").toString()+"',true) >"+workflowname+" </a>&nbsp(";
			
			if(newrequests.size()>0){
				String paras = "method=request&objid="+workflowid;
				//wfText+="<span onClick='javaScript:loadGrid(method=reqeustbywfidNode&workflowid="+workflowid+"&nodeids="+t_nodeids+"&complete=3)' >"+Util.toScreen(newremarkwfcount0,user.getLanguage())+"<IMG src='/images/BDNew.gif' align=center BORDER=0></span> &nbsp;/&nbsp;";
				wfText+="<a  href =# onClick=javaScript:loadGrid('"+paras+"',true)  >"+newrequests.size()+"</a><IMG src='/images/BDNew.gif' align=center BORDER=0> &nbsp;/&nbsp;";
				newrequestsCount = newrequestsCount+newrequests.size();
			}
			
			wfText+=requests.size()+")";
			jsonWfTypeChild.put("iconCls","btn_dot");
			jsonWfTypeChild.put("cls","wfTreeLeafNode");
			jsonWfTypeChild.put("text",wfText);
			jsonWfTypeChildrenArray.put(jsonWfTypeChild);

		}	
        String wfText ="";
		if(newrequestsCount>0){
			wfText+=newrequestsCount+"<IMG src='/images/BDNew.gif' align=center BORDER=0> &nbsp;/&nbsp;";
		}
		jsonWfType.put("text","<a href=# onClick=javaScript:loadGrid('"+jsonWfType.get("paras").toString()+"',true)>"+typename+"&nbsp;</a>("+wfText+counts+")");
		
        jsonWfType.put("children",jsonWfTypeChildrenArray);
        jsonWfTypeArray.put(jsonWfType);
	}
    
    session.setAttribute("supervise",jsonWfTypeArray);

    response.sendRedirect("/workflow/request/ext/Request.jsp?type=supervise");  //type: view,表待办 handled表已办
    
	return;	
}

%>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<form name=frmmain method=post action="RequestSupervise.jsp">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</form>

<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr style="height:1px;">
	<td height="5"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
            <tr>
                <td valign="top">

                <table class="viewform">
                    <colgroup>
                    <col width="49%">
                    <col width="">
                    <col width="49%">
                    <tr class="Title" ><th colspan="3"><%=SystemEnv.getHtmlLabelName(21218,user.getLanguage())%>:<%=totalcount%></th></tr>
                    <tr class="Spacing" style="height:1px;"><td class="Line1" colspan="3" style="padding:0;"></td></tr>
                    <tr style="height:1px;">
                    	<td height="5"></td>
                    </tr>
                    <% int typerowcounts=(wftypes.size()+1)/2; %>
                    <tr>
                        <!--左边table-->
                        <td valign=top>
                            <table class="viewform">
                                <tr>
                                    <td>
                                       
                                            <%
                                            for(int i=0;i<typerowcounts;i++){
                                                WFWorkflowTypes wftype=(WFWorkflowTypes)wftypes.get(i);
                                                ArrayList workflows=wftype.getWorkflows();
                                                String typeid=""+wftype.getWftypeid();
                                                String typename=WorkTypeComInfo.getWorkTypename(typeid);
                                                int counts=wftype.getCounts();
                                                %>
                                                <div class=listbox >
                                                <table width="100%" height="39px" border="0" cellspacing="0" cellpadding="0">
													<tr>
														
														<td class="t-center"><span class="flag_1"></span><span	class="title_1">
                                                <a href="WFSuperviseList.jsp?method=type&objid=<%=typeid%>">
                                                <%=Util.toScreen(typename,user.getLanguage())%></a>&nbsp;<b>(<%=counts%>)</b>
                                                </span></td>
														<td class="t-right">&nbsp;</td>
													</tr>
												</table>
                                                <UL>
                                                    <%
                                                    for(int j=0;j<workflows.size();j++){
                                                        WFWorkflows wfworkflow=(WFWorkflows)workflows.get(j);
                                                        ArrayList requests=wfworkflow.getReqeustids();
                                                        ArrayList newrequests=wfworkflow.getNewrequestids();
                                                        String workflowname=wfworkflow.getWorkflowname();
                                                        int workflowid=wfworkflow.getWorkflowid();
                                                        %>
                                                        <LI><a href="WFSuperviseList.jsp?method=workflow&objid=<%=workflowid%>">
                                                        <%=Util.toScreen(workflowname,user.getLanguage())%></a>&nbsp;
                                                        (
                                                            <%if(newrequests.size()>0){%>
                                                            <a href="WFSuperviseList.jsp?method=request&objid=<%=workflowid%>">
                                                            <%=newrequests.size()%></a><IMG src="/images/BDNew.gif" align=absbottom BORDER=0>
                                                            &nbsp;/
                                                         <%}%>
                                                         <%=requests.size()%>)
                                                        <%
                                                    }%>
                                                </UL></div>
                                            <%}%>
                                        
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <!--中间空白-->
                        <td></td>
                        <!--右边table-->
                        <td valign=top>
                        <table class="viewform">
                            <tr>
                                <td>
                                    
                                        <%
                                        for(int i=typerowcounts;i<wftypes.size();i++){
                                            WFWorkflowTypes wftype=(WFWorkflowTypes)wftypes.get(i);
                                            ArrayList workflows=wftype.getWorkflows();
                                            String typeid=""+wftype.getWftypeid();
                                            String typename=WorkTypeComInfo.getWorkTypename(typeid);
                                            int counts=wftype.getCounts();
                                            %>
                                            <div class=listbox >
                                                <table width="100%" height="39px" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td class="t-center"><span class="flag_1"></span><span	class="title_1">
                                            <a href="WFSuperviseList.jsp?method=type&objid=<%=typeid%>">
                                            <%=Util.toScreen(typename,user.getLanguage())%></a>&nbsp;<b>(<%=counts%>)</b>
                                            </span></td>
														<td class="t-right">&nbsp;</td>
													</tr>
												</table>
                                            <UL>
                                            <%
                                            for(int j=0;j<workflows.size();j++){
                                                WFWorkflows wfworkflow=(WFWorkflows)workflows.get(j);
                                                ArrayList requests=wfworkflow.getReqeustids();
                                                ArrayList newrequests=wfworkflow.getNewrequestids();
                                                String workflowname=wfworkflow.getWorkflowname();
                                                int workflowid=wfworkflow.getWorkflowid();
                                                %>
                                                <LI><a href="WFSuperviseList.jsp?method=workflow&objid=<%=workflowid%>">
                                                <%=Util.toScreen(workflowname,user.getLanguage())%></a>&nbsp;
                                                (
                                                    <%if(newrequests.size()>0){%>
                                                    <a href="WFSuperviseList.jsp?method=request&objid=<%=workflowid%>">
                                                    <%=newrequests.size()%></a><IMG src="/images/BDNew.gif" align=absbottom BORDER=0>
                                                    &nbsp;/
                                                 <%}%>
                                                 <%=requests.size()%>)
                                                <%
                                            }%>
                                            </UL></div>
                                        <%}%>
                                   
                                </td>
                            </tr>
                        </table>
                        </td>
                    </tr>
                </table>

                </td>
            </tr>
            <tr>
                <td height="10"></td>
            </tr>
        </table>
    <td ></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</body>
</html>
