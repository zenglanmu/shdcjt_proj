<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<STYLE TYPE="text/css">
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />


<HTML>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(22118, user.getLanguage());
    String needfav = "";
    String needhelp = "";
%>
    <HEAD>
        <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver.js"></script>
    </HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu1.jsp" %>

<%

    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID = -1;
    int operateLevel = 0;

    if(1 == detachable){
        if(null == request.getParameter("subCompanyID")){
            subCompanyID=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")), -1);
        }else{
            subCompanyID=Util.getIntValue(request.getParameter("subCompanyID"),-1);
        }
        if(-1 == subCompanyID){
            subCompanyID = user.getUserSubCompany1();
        }

        session.setAttribute("managefield_subCompanyId", String.valueOf(subCompanyID));

        operateLevel= checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowManage:All", subCompanyID);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
            operateLevel=2;
        }
    }

	if(operateLevel > 0){
		int workflowid = Util.getIntValue(request.getParameter("wfid"),-1);
        String formID = request.getParameter("formid");
        String isbill = request.getParameter("isbill");
		int errorMessage = Util.getIntValue(request.getParameter("errorMessage"), 0);
		String errorStr = "";
		if(errorMessage == 1){
			errorStr = "<font color=\"#FF0000\">"+SystemEnv.getHtmlLabelName(22119, user.getLanguage())+"</font>";
		}

		if(formID==null||formID.trim().equals("")){
			formID=WorkflowComInfo.getFormId(""+workflowid);
		}
 		if(isbill==null||isbill.trim().equals("")){
			isbill=WorkflowComInfo.getIsBill(""+workflowid);
		}
		if(!"1".equals(isbill)){
			isbill="0";
		}

		Hashtable nodename_hs = new Hashtable();
		Hashtable taskname_hs =  new Hashtable();
%>

<FORM name="CreateWorktaskByWorkflow" method="post" action="CreateWorktaskByWorkflowOperation.jsp" >
    <TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <COLGROUP>
            <COL width="10">
            <COL width="">
            <COL width="10">
        <TR>
            <TD height="10" colspan="3"></TD>
        </TR>
        <TR>
            <TD ></TD>
            <TD valign="top">
                <TABLE class=Shadow>
                    <TR>
                        <TD valign="top">
                            <TABLE class="viewform">
                                <COLGROUP>
                                   <COL width="25%">
                                   <COL width="75%">
									<TR class="Title">
										<TD colSpan=2><b><%=SystemEnv.getHtmlLabelName(22120, user.getLanguage())%></b></TD>
									</TR>
									<TR class=Spacing>
										<TD class=Line1 colSpan=2></TD>
									</TR>
									<TR>
									<TD><%=SystemEnv.getHtmlLabelName(22121, user.getLanguage())%></TD>                                            
                                    <TD class="field">                                           
									<%
										String disabledStr = "";
										String select1Str = "";
										String select2Str = "";
										String changetimeinputValue = "1";
										int c = 0;
										out.println("<select id=\"nodeid\" name=\"nodeid\" onChange=\"onchangeNodeid(this, CreateWorktaskByWorkflow)\">");
										recordSet.execute("select n.id, n.nodename, f.nodetype from workflow_nodebase n, workflow_flownode f where (n.IsFreeNode is null or n.IsFreeNode!='1') and f.nodeid=n.id and f.workflowid="+workflowid+" order by f.nodetype,n.id");
										while(recordSet.next()){
											int id_tmp = Util.getIntValue(recordSet.getString("id"), 0);
											String nodename_tmp = Util.null2String(recordSet.getString("nodename"));
											if(id_tmp == 0){
												continue;
											}
											int nodetype_tmp = Util.getIntValue(recordSet.getString("nodetype"), 0);
											if(c==0 && (nodetype_tmp==0 || nodetype_tmp==3)){
												disabledStr = " disabled ";
												if(nodetype_tmp == 0){
													select2Str = " selected ";
													changetimeinputValue = "2";
												}else if(nodetype_tmp == 3){
													select1Str = " selected ";
													changetimeinputValue = "1";
												}
											}
											nodename_hs.put("nodename_"+id_tmp, nodename_tmp);
											out.println("<option value=\""+id_tmp+"\" nodeType=\""+nodetype_tmp+"\">"+nodename_tmp+"</option>");
											c++;
										}
										out.println("</select>");
									%>
									</TD>
									</TR>
									<TR class=Spacing>
										<TD class=Line colSpan=2></TD>
									</TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(22122, user.getLanguage())%></TD>
										<TD class="field">
											<select id="changetime" name="changetime" onchange="dochangeChangeTime(this)" <%=disabledStr%>>
												<option value="1" <%=select1Str%>><%=SystemEnv.getHtmlLabelName(22123, user.getLanguage())%></option>
												<option value="2" <%=select2Str%>><%=SystemEnv.getHtmlLabelName(22124, user.getLanguage())%></option>
											</select>
											<input type="hidden" name="changetimeinput" id="changetimeinput" value="<%=changetimeinputValue%>">
										</TD>
									</TR>
									<TR class=Spacing>
										<TD class=Line colSpan=2></TD>
									</TR>
									<TR id="changemodetr1" style="display:none">
										<TD><%=SystemEnv.getHtmlLabelName(22053, user.getLanguage())%></TD>
										<TD class="field">
											<select id="changemode" name="changemode" style="display:none">
												<option value="0" ></option>
												<option value="1" ><%=SystemEnv.getHtmlLabelName(25361, user.getLanguage())%></option>
												<option value="2" ><%=SystemEnv.getHtmlLabelName(25362, user.getLanguage())%></option>
											</select>
										</TD>
									</TR>
									<TR id="changemodetr0" style="display:none">
										<TD><%=SystemEnv.getHtmlLabelName(22053, user.getLanguage())%></TD>
										<TD class="field">
											<select id="changemode0" name="changemode0" style="display:none">
												<option value="0" ></option>
												<option value="1" ><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%></option>
												<option value="2" ><%=SystemEnv.getHtmlLabelName(236, user.getLanguage())%></option>
											</select>
										</TD>
									</TR>
									<TR class="Spacing" id="changemodetr2" style="display:none">
										<TD class=Line colSpan=2></TD>
									</TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(18177, user.getLanguage())%></TD>
										<TD class="field">
										<%
											out.println("<select id=\"taskid\" name=\"taskid\" >");
											recordSet.execute("select * from worktask_base");
											while(recordSet.next()){
												int id_tmp = Util.getIntValue(recordSet.getString("id"), 0);
												String name_tmp = Util.null2String(recordSet.getString("name"));
												if(id_tmp == 0){
													continue;
												}
												taskname_hs.put("taskname_"+id_tmp, name_tmp);
												out.println("<option value=\""+id_tmp+"\">"+name_tmp+"</option>");
											}
											out.println("</select>");
										%>
										</TD>
									</TR>
									<TR class=Spacing>
										<TD class=Line colSpan=2></TD>
									</TR>
                            </TABLE>
							<br/>
							<span in="errorMessage" name="errorMessage" style="display:<%if(errorMessage==0){%>none<%}%>"><%=errorStr%></span>
                            <TABLE class=viewform >
								<TR class="title">
								<td align="left"><b><%=SystemEnv.getHtmlLabelName(22125, user.getLanguage())%></b>
								</td>
								<td align="right">
								<BUTTON Class="btn_RequestSubmitList" type="button" onclick="addWTRow();"><%=SystemEnv.getHtmlLabelName(456, user.getLanguage())%></BUTTON>
								&nbsp;&nbsp;
								<BUTTON Class="btn_RequestSubmitList" type="button" onclick="delWTRow();"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></BUTTON>
								</td>
								</TR>
								<TR class=spacing> 
									<TD class=line1 colspan=2></TD>
								</TR>
							</TABLE>
							<table class="ListStyle">
							<COLGROUP>
								<COL width="4%">
								<COL width="20%">
								<COL width="20%">
								<COL width="20%">
								<COL width="20%">
								<COL width="16%">
								<tr class="Header">
									<td></td>
									<td><%=SystemEnv.getHtmlLabelName(22121, user.getLanguage())%></td>
									<td><%=SystemEnv.getHtmlLabelName(22122, user.getLanguage())%></td>
									<td><%=SystemEnv.getHtmlLabelName(22053, user.getLanguage())%></td>
									<td><%=SystemEnv.getHtmlLabelName(18177, user.getLanguage())%></td>
									<td><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage())%></td>
								</tr>
								<tr class="line2"><td colspan="6"></td></tr>
								<%
									boolean isLight = true;
									String classStr = " class=\"datalight\"";
									recordSet.execute("select * from workflow_createtask where wfid="+workflowid);
									while(recordSet.next()){
										int id_tmp = Util.getIntValue(recordSet.getString("id"), 0);
										int changetime_tmp = Util.getIntValue(recordSet.getString("changetime"), 0);
										int taskid_tmp = Util.getIntValue(recordSet.getString("taskid"), 0);
										int nodeid_tmp = Util.getIntValue(recordSet.getString("nodeid"), 0);
										String nodename_tmp = Util.null2String((String)nodename_hs.get("nodename_"+nodeid_tmp));
										String taskname_tmp = Util.null2String((String)taskname_hs.get("taskname_"+taskid_tmp));
										String changetimeStr = "";
										if(changetime_tmp == 1){
											changetimeStr = SystemEnv.getHtmlLabelName(22123, user.getLanguage());//到达节点
										}else if(changetime_tmp == 2){
											changetimeStr = SystemEnv.getHtmlLabelName(22124, user.getLanguage());//离开节点
										}
										int changemode_tmp = Util.getIntValue(recordSet.getString("changemode"), 0);
										String changemodeStr_tmp = "";
										if(changetime_tmp == 1){
											if(changemode_tmp == 1){
												changemodeStr_tmp = SystemEnv.getHtmlLabelName(25361, user.getLanguage());
											}else if(changemode_tmp == 2){
												changemodeStr_tmp = SystemEnv.getHtmlLabelName(25362, user.getLanguage());
											}
										}else{
											if(changemode_tmp == 1){
												changemodeStr_tmp = SystemEnv.getHtmlLabelName(142, user.getLanguage());
											}else if(changemode_tmp == 2){
												changemodeStr_tmp = SystemEnv.getHtmlLabelName(236, user.getLanguage());
											}
										}
										if("".equals(nodename_tmp.trim()) || "".equals(taskname_tmp.trim())){
											//清空冗余数据，如果该节点已不属于该流程或计划任务类型已不存在
											//rs.execute("delete from workflow_createtask where id="+id_tmp);
											continue;
										}
										out.println("<tr"+classStr+">");
										out.println("<td><input type=\"checkbox\" id=\"checkbox1\" name=\"checkbox1\" value=\""+id_tmp+"\"></td>");
										out.println("<td>"+nodename_tmp+"</td>");
										out.println("<td>"+changetimeStr+"</td>");
										out.println("<td>"+changemodeStr_tmp+"</td>");
										out.println("<td>"+taskname_tmp+"</td>");
										out.println("<td><a href=\"#\" onClick=\"detailConfig_wt("+id_tmp+", "+workflowid+")\" >"+SystemEnv.getHtmlLabelName(19342, user.getLanguage())+"</a></td>");
										out.println("</tr>");
										out.println("<TR class=\"Spacing\"><TD class=\"Line\" colSpan=\"6\"></TD></TR>");
										if(isLight == true){
											isLight = false;
											classStr = " class=\"datadark\"";
										}else{
											isLight = true;
											classStr = " class=\"datalight\"";
										}
									}
								%>
							</table>
                        </TD>
                        <TD></TD>
                    </TR>
                    <TR>
                        <TD height="10" colspan="3"></TD>
                    </TR>
                    <INPUT type=hidden id='workflowid' name='workflowid' value=<%=workflowid%>>
					<INPUT type=hidden id="wfid" name="wfid" value=<%=workflowid%>>
                    <INPUT type=hidden id='formID' name='formID' value=<%=formID%>>
                    <INPUT type=hidden id='isbill' name='isbill' value=<%=isbill%>>
					<input type="hidden" id="operationType" name="operationType">
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    
</FORM>
<%
	}else{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
</BODY>
</HTML>