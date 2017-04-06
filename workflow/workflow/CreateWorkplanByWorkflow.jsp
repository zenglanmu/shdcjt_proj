<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.Constants"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24086, user.getLanguage());
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
		Hashtable typename_hs =  new Hashtable();
%>

<FORM name="CreateWorkplanByWorkflow" method="post" action="CreateWorkplanByWorkflowOperation.jsp" >
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
										out.println("<select id=\"nodeid\" name=\"nodeid\" onChange=\"onchangeNodeid2(this, CreateWorkplanByWorkflow)\">");
										//流程转日程的时候，自由流转节点不显示修正 2010/04/20  start
										//recordSet.execute("select n.id, n.nodename, f.nodetype from workflow_nodebase n, workflow_flownode f where f.nodeid=n.id  and f.workflowid="+workflowid);
										recordSet.execute("select n.id, n.nodename, f.nodetype from workflow_nodebase n, workflow_flownode f where f.nodeid=n.id and (n.isfreenode != '1' or n.isfreenode is null) and f.workflowid="+workflowid);
										//流程转日程的时候，自由流转节点不显示修正 2010/04/20  end
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
											<select id="changetime" name="changetime" <%=disabledStr%>>
												<option value="1" <%=select1Str%>><%=SystemEnv.getHtmlLabelName(22123, user.getLanguage())%></option>
												<option value="2" <%=select2Str%>><%=SystemEnv.getHtmlLabelName(22124, user.getLanguage())%></option>
											</select>
											<input type="hidden" name="changetimeinput" id="changetimeinput" value="<%=changetimeinputValue%>">
										</TD>
									</TR>
									<TR class=Spacing>
										<TD class=Line colSpan=2></TD>
									</TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(16094, user.getLanguage())%></TD>
										<TD class="field">
										<%
											out.println("<select id=\"plantypeid\" name=\"plantypeid\" >");
											recordSet.execute("select * from workPlanType "+Constants.WorkPlan_Type_Query_By_Menu);
											while(recordSet.next()){
												int id_tmp = Util.getIntValue(recordSet.getString("workplantypeid"), 0);
												String name_tmp = Util.forHtml(Util.null2String(recordSet.getString("workplantypename")));
												typename_hs.put("typename_"+id_tmp, name_tmp);
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
								<td align="center">
									<img src="/images/arrow_d.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addWPRow()" border="0">
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="delWPRow()" border="0">
								</td>
								</TR>
								<TR class="title">
								<td align="left"><b><%=SystemEnv.getHtmlLabelName(22125, user.getLanguage())%></b>
								</td>
								</TR>
								<TR class=spacing> 
									<TD class=line1 colspan=2></TD>
								</TR>
							</TABLE>
							<table class="ListStyle">
							<COLGROUP>
								<COL width="8%">
								<COL width="23%">
								<COL width="23%">
								<COL width="23%">
								<COL width="23%">
								<tr class="Header">
									<td></td>
									<td><%=SystemEnv.getHtmlLabelName(22121, user.getLanguage())%></td>
									<td><%=SystemEnv.getHtmlLabelName(22122, user.getLanguage())%></td>
									<td><%=SystemEnv.getHtmlLabelName(16094, user.getLanguage())%></td>
									<td><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage())%></td>
								</tr>
								<tr class="line2"><td colspan="5"></td></tr>
								<%
									boolean isLight = true;
									String classStr = " class=\"datalight\"";
									recordSet.execute("select * from workflow_createplan where wfid="+workflowid);
									while(recordSet.next()){
										int id_tmp = Util.getIntValue(recordSet.getString("id"), 0);
										int changetime_tmp = Util.getIntValue(recordSet.getString("changetime"), 0);
										int typeid_tmp = Util.getIntValue(recordSet.getString("plantypeid"), 0);
										int nodeid_tmp = Util.getIntValue(recordSet.getString("nodeid"), 0);
										String nodename_tmp = Util.null2String((String)nodename_hs.get("nodename_"+nodeid_tmp));
										String typename_tmp = Util.null2String((String)typename_hs.get("typename_"+typeid_tmp));
										String changetimeStr = "";
										if(changetime_tmp == 1){
											changetimeStr = SystemEnv.getHtmlLabelName(22123, user.getLanguage());//到达节点
										}else if(changetime_tmp == 2){
											changetimeStr = SystemEnv.getHtmlLabelName(22124, user.getLanguage());//离开节点
										}
										if("".equals(nodename_tmp.trim()) || "".equals(typename_tmp.trim())){
											//清空冗余数据，如果该节点已不属于该流程或日程类型已不存在
											//rs.execute("delete from workflow_createplan where id="+id_tmp);
											continue;
										}
										out.println("<tr"+classStr+">");
										out.println("<td><input type=\"checkbox\" id=\"checkbox1\" name=\"checkbox1\" value=\""+id_tmp+"\"></td>");
										out.println("<td>"+nodename_tmp+"</td>");
										out.println("<td>"+changetimeStr+"</td>");
										out.println("<td>"+typename_tmp+"</td>");
										out.println("<td><a href=\"#\" onClick=\"detailConfig_wp("+id_tmp+", "+workflowid+")\" >"+SystemEnv.getHtmlLabelName(19342, user.getLanguage())+"</a></td>");
										out.println("</tr>");
										out.println("<TR class=\"Spacing\"><TD class=\"Line\" colSpan=\"5\"></TD></TR>");
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
                    <INPUT type="hidden" id="workflowid" name="workflowid" value="<%=workflowid%>">
					<INPUT type="hidden" id="wfid" name="wfid" value="<%=workflowid%>">
                    <INPUT type="hidden" id="formID" name="formID" value="<%=formID%>">
                    <INPUT type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
					<input type="hidden" id="operationType" name="operationType" value="">
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