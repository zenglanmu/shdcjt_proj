<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="createWorkplanByWorkflow" class="weaver.WorkPlan.CreateWorkplanByWorkflow" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />


<HTML>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24086, user.getLanguage()) + SystemEnv.getHtmlLabelName(19342, user.getLanguage());
    String needfav = "";
    String needhelp = "";

	String sql = "";
	int id = Util.getIntValue(request.getParameter("id"), -1);
	int workflowid = Util.getIntValue(request.getParameter("wfid"), -1);
	String formID = "";
	String isbill = "";
	rs.execute("select * from workflow_base where id="+workflowid);
	if(rs.next()){
		formID = Util.null2o(rs.getString("formid"));
		isbill = Util.null2o(rs.getString("isbill"));
	}

%>
    <HEAD>
        <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver.js"></script>
    </HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:saveCreateWPDetail(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+",javascript:comebackCreateWP("+workflowid+", "+formID+", "+isbill+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
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

	if(operateLevel>0 && id!=-1){
		int creatertype = 0;
		int wffieldid = 0;
		int plantypeid = 0;
		int nodeid = 0;
		int remindType = 1;
		int remindBeforeStart = 0;
		int remindDateBeforeStart = 0;
		int remindTimeBeforeStart = 0;
		int remindBeforeEnd = 0;
		int remindDateBeforeEnd = 0;
		int remindTimeBeforeEnd = 0;
		rs.execute("select * from workflow_createplan where id="+id);
		if(rs.next()){
			creatertype = Util.getIntValue(rs.getString("creatertype"), 1);
			wffieldid = Util.getIntValue(rs.getString("wffieldid"), 0);
			plantypeid = Util.getIntValue(rs.getString("plantypeid"), 0);
			nodeid = Util.getIntValue(rs.getString("nodeid"), 0);
			remindType = Util.getIntValue(rs.getString("remindType"), 1);
			remindBeforeStart = Util.getIntValue(rs.getString("remindBeforeStart"), 0);
			remindDateBeforeStart = Util.getIntValue(rs.getString("remindDateBeforeStart"), 0);
			remindTimeBeforeStart = Util.getIntValue(rs.getString("remindTimeBeforeStart"), 0);
			remindBeforeEnd = Util.getIntValue(rs.getString("remindBeforeEnd"), 0);
			remindDateBeforeEnd = Util.getIntValue(rs.getString("remindDateBeforeEnd"), 0);
			remindTimeBeforeEnd = Util.getIntValue(rs.getString("remindTimeBeforeEnd"), 0);
		}
		Hashtable createtaskdetail_hs = new Hashtable();
		sql = "select * from workflow_createplandetail where createplanid="+id;
		rs.execute(sql);
		while(rs.next()){
			int groupid_tmp = Util.getIntValue(rs.getString("groupid"), 0);
			int wffieldid_tmp = Util.getIntValue(rs.getString("wffieldid"), 0);
			String planfieldname_tmp = Util.null2String(rs.getString("planfieldname"));
			int isdetail_tmp = Util.getIntValue(rs.getString("isdetail"), 0);
			createtaskdetail_hs.put("wffield_"+planfieldname_tmp+"_"+groupid_tmp, ""+wffieldid_tmp+"_"+isdetail_tmp);
		}
		Hashtable creategroup_hs = new Hashtable();
		sql = "select * from workflow_createplangroup where createplanid="+id;
		rs.execute(sql);
		while(rs.next()){
			int groupid_tmp = Util.getIntValue(rs.getString("groupid"), 0);
			int isused_tmp = Util.getIntValue(rs.getString("isused"), 0);
			creategroup_hs.put("groupid_"+groupid_tmp, ""+isused_tmp);
		}
%>

<FORM name="CreateWorkplanByWorkflowDetail" method="post" action="CreateWorkplanByWorkflowDetailOperation.jsp" >
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
										<TD colSpan=2><b><%=SystemEnv.getHtmlLabelName(2211, user.getLanguage()) + SystemEnv.getHtmlLabelName(616, user.getLanguage())%></b></TD>
									</TR>
									<TR class=Spacing>
										<TD class=Line1 colSpan=2></TD>
									</TR>
									<TR>
									<TD><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage()) + SystemEnv.getHtmlLabelName(882, user.getLanguage())%></TD>                                            
                                    <TD class="field">                                           
										<input class="inputStyle" type="radio" name="creatertype" value="1" <%if(creatertype==1){out.println("checked");}%>  onclick="showWFfield2(0)">
									</TD>
									</TR>
									<TR class=Spacing>
										<TD class=Line colSpan=2></TD>
									</TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage()) + SystemEnv.getHtmlLabelName(15555, user.getLanguage())%></TD>
										<TD class="field">
											<input class="inputStyle" type="radio" name="creatertype" value="2" <%if(creatertype==2){out.println("checked");}%>  onclick="showWFfield2(1)">
											&nbsp;&nbsp;
											<select id="wffield" name="wffield" style="display:<%if(creatertype!=2){out.println("none");}%>" >
											<%
												if(isbill.equals("0")){
													sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 1 or workflow_formdict.type=165) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formID;		//不包括多人力资源字段
												}else{
													sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formID+ " and fieldhtmltype = '3' and (type=1 or type=165) and viewtype = 0 " ;
												}
												rs.execute(sql);
												while(rs.next()){
													int fieldid_tmp = Util.getIntValue(rs.getString("id"), 0);
													int fieldlabel_tmp = Util.getIntValue(rs.getString("name"), 0);
													String fieldname_tmp = "";
													if(isbill.equals("0")){
														fieldname_tmp = Util.null2String(rs.getString("name"));
													}else{
														fieldname_tmp = SystemEnv.getHtmlLabelName(fieldlabel_tmp, user.getLanguage());
													}
													String selectStr = "";
													if(wffieldid>0 && wffieldid==fieldid_tmp){
														selectStr = " selected ";
													}
													out.println("<option value=\""+fieldid_tmp+"\" "+selectStr+">"+fieldname_tmp+"</option>");
												}
											%>
											</select>
										</TD>
									</TR>
									<TR class=Spacing>
										<TD class=Line colSpan=2></TD>
									</TR>
                            </TABLE>
							<br/>
							<TABLE class="ViewForm">
								<COLGROUP>
									<COL width="25%">
							  		<COL width="75%">
								</COLGROUP>
							    <TBODY>
								<TR class="Title">
									<TD colSpan=2><b><%=SystemEnv.getHtmlLabelName(21976, user.getLanguage())%></b></TD>
								</TR>
								<TR class=Spacing>
									<TD class=Line1 colSpan=2></TD>
								</TR>
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></TD>
									<TD class="Field">
										<INPUT type="radio" value="1" name="remindType" onclick="showRemindTime_wp(this)" <%if (remindType==1) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
										<INPUT type="radio" value="2" name="remindType" onclick="showRemindTime_wp(this)" <%if (remindType==2) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
										<INPUT type="radio" value="3" name="remindType" onclick="showRemindTime_wp(this)" <%if (remindType==3) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
									</TD>
								</TR>
								<TR>
									<TD class="Line" colSpan="2"></TD>
								</TR>
								<!--================ 日程提醒时间  ================-->
								<TR id="remindTimeTR" name="remindTimeTR" style="display:<%if(remindType==1){%>none<%}%>">
									<TD><%=SystemEnv.getHtmlLabelName(19783,user.getLanguage())%></TD>
									<TD class="Field">
										<INPUT type="checkbox" name="remindBeforeStart" value="1" <%if(remindBeforeStart==1){%>checked<%}%>>
											<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
											<INPUT class="InputStyle" type="input" name="remindDateBeforeStart" onchange="checkint('remindDateBeforeStart')" size="5" value="<%=remindDateBeforeStart%>">
											<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
											<INPUT class="InputStyle" type="input" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size="5" value="<%=remindTimeBeforeStart%>">
											<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
											<br/>
										<INPUT type="checkbox" name="remindBeforeEnd" value="1" <% if(remindBeforeEnd==1) { %>checked<% } %>>
											<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
											<INPUT class="InputStyle" type="input" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size="5" value="<%=remindDateBeforeEnd%>">
											<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
											<INPUT class="InputStyle" type="input" name="remindTimeBeforeEnd"  onchange="checkint('remindTimeBeforeEnd')" size="5" value="<%=remindTimeBeforeEnd%>">
											<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
									</TD>
								</TR>
								<TR id="remindTimeLineTR" name="remindTimeLineTR" style="display:<%if(remindType==1){%>none<%}%>">
									<TD class="Line" colSpan="2"></TD>
								</TR>
								</TBODY>
								</TABLE>

							<br/>
						<%
							Hashtable ret_hs = createWorkplanByWorkflow.getWorkplanField(user.getLanguage());
							ArrayList plan_nameList = (ArrayList)ret_hs.get("plan_nameList");
							ArrayList plan_fieldnameLiat = (ArrayList)ret_hs.get("plan_fieldnameLiat");
							for(int i=0; i<plan_fieldnameLiat.size(); i++){
								String planfieldname_tmp = Util.null2String((String)plan_fieldnameLiat.get(i));
								out.println("<input type=\"hidden\" name=\"planfieldname\" id=\"planfieldname"+i+"\" value=\""+planfieldname_tmp+"\" >");
							}
							int detailCount = 0;
							ArrayList groupidList = new ArrayList();
							ArrayList detailTableList = new ArrayList();
							if(isbill.equals("0")){
								sql = "select groupid from workflow_formfield where formid="+formID+" and isdetail=1 group by groupid order by groupid";
								rs.execute(sql);
								while(rs.next()){
									detailCount++;
									String groupid_tmp = Util.null2o(rs.getString("groupid"));
									groupidList.add(groupid_tmp);
								}
							}else{
								sql = "select orderid,tablename from Workflow_billdetailtable where billid="+formID+" order by orderid";
								rs.execute(sql);
								while(rs.next()){
									detailCount++;
									String groupid_tmp = ""+Util.getIntValue(rs.getString("orderid"), 0);
									String detailTable_tmp = Util.null2String(rs.getString("tablename"));
									groupidList.add(groupid_tmp);
									detailTableList.add(detailTable_tmp);
								}
							}
							//获得所有流程主字段
							ArrayList wf_idList = new ArrayList();
							ArrayList wf_nameList = new ArrayList();
							wf_idList.add("-1");
							wf_nameList.add(SystemEnv.getHtmlLabelName(18015, user.getLanguage())+SystemEnv.getHtmlLabelName(229, user.getLanguage()));
							wf_idList.add("-2");
							wf_nameList.add(SystemEnv.getHtmlLabelName(15534, user.getLanguage()));
							wf_idList.add("-3");
							wf_nameList.add(SystemEnv.getHtmlLabelName(17582, user.getLanguage()));
							rs.execute("select n.id, n.nodename from workflow_flownode f left join workflow_nodebase n on n.id=f.nodeid where workflowid="+workflowid);
							while(rs.next()){
								int nodeid_tmp = Util.getIntValue(rs.getString(1), 0);
								String nodename_tmp = Util.null2String(rs.getString(2));
								wf_idList.add(""+(nodeid_tmp*(-1)-10));
								wf_nameList.add(nodename_tmp + SystemEnv.getHtmlLabelName(15586, user.getLanguage())+SystemEnv.getHtmlLabelName(17482, user.getLanguage()));
							}
							//wf_idList.add("-4");
							//wf_nameList.add(SystemEnv.getHtmlLabelName(22244, user.getLanguage())+SystemEnv.getHtmlLabelName(17482, user.getLanguage()));
							if(isbill.equals("0")){
								sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formID;
							}else{
								sql = "select id as id , fieldlabel as name from workflow_billfield where viewtype=0 and billid="+ formID;
							}
							rs.execute(sql);
							while(rs.next()){
								String wf_id_tmp = Util.null2o(rs.getString("id"));
								String wf_name_tmp = Util.null2String(rs.getString("name"));
								if(!isbill.equals("0")){
									wf_name_tmp = SystemEnv.getHtmlLabelName(Util.getIntValue(wf_name_tmp, 0), user.getLanguage());
								}
								wf_idList.add(wf_id_tmp);
								wf_nameList.add(wf_name_tmp);
							}
							for(int i=0; (i<detailCount || i==0); i++){
								String wf_groupid = "-1";
								if(isbill.equals("0")){
									try{
										wf_groupid = ""+Util.getIntValue((String)groupidList.get(i), -1);
									}catch(Exception e){}
								}else{
									try{
										wf_groupid = Util.null2String((String)groupidList.get(i));
									}catch(Exception e){}
								}
								boolean hasNoDeatil = false;
								if(wf_groupid.equals("-1")){
									hasNoDeatil = true;
									wf_groupid = "0";
								}
						%>
                            <TABLE class=viewform >
								<colgroup>
								<col width="40%">
								<col width="60%">
								<TR class="title">
								<td align="left"><b><%=SystemEnv.getHtmlLabelName(22129, user.getLanguage())+"("+ (i+1)+SystemEnv.getHtmlLabelName(2026, user.getLanguage())+"--"+SystemEnv.getHtmlLabelName(22131, user.getLanguage())+")"%></b>
								<input type="hidden" name="groupid" id="groupid" value="<%=wf_groupid%>" >
								</td>
								<td align="left">
								<%
									String isused_tmp = Util.null2String((String)creategroup_hs.get("groupid_"+wf_groupid));
									String checkStr = "";
									if("1".equals(isused_tmp)){
										checkStr = " checked ";
									}
									out.println(SystemEnv.getHtmlLabelName(22132, user.getLanguage())+"&nbsp;&nbsp;<input type=\"checkbox\" name=\"isused_"+wf_groupid+"\" id=\"isused_"+wf_groupid+"\" value=\"1\" "+checkStr+">");
								%>
								</td>
								</TR>
								<TR class=spacing> 
									<TD class=line1 colspan=2></TD>
								</TR>
							</TABLE>
							<table class="ListStyle">
							<COLGROUP>
								<COL width="50%">
								<COL width="50%">
								<tr class="Header">
									<td><%=SystemEnv.getHtmlLabelName(2211, user.getLanguage()) + SystemEnv.getHtmlLabelName(261, user.getLanguage())%></td>
									<td><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage()) + SystemEnv.getHtmlLabelName(261, user.getLanguage())%></td>
								</tr>
								<tr class="line2"><td colspan="3"></td>
								</tr>
								<%
									boolean isLight = true;
									String classStr = " class=\"datalight\"";
									for(int cx=0; cx<plan_nameList.size(); cx++){
										String plan_crmname_tmp = (String)plan_nameList.get(cx);
										String plan_fieldname_tmp = (String)plan_fieldnameLiat.get(cx);
										String wffieldselectStr2 = "<select name=\"wffield_"+plan_fieldname_tmp+"_"+(wf_groupid)+"\" id=\"wffield_"+plan_fieldname_tmp+"_"+(wf_groupid)+"\" style=\"width:80%\">\n<option value=\"-1\"></option>";
										String valueStr = Util.null2String((String)createtaskdetail_hs.get("wffield_"+plan_fieldname_tmp+"_"+(wf_groupid)));
										String wffieldselectStr = "";
										for(int ax=0; ax<wf_idList.size(); ax++){
											String wf_id_tmp = (String)wf_idList.get(ax);
											String wf_name_tmp = (String)wf_nameList.get(ax);
											String selectStr = "";
											if(!"".equals(valueStr) && valueStr.equals(""+wf_id_tmp+"_0")){
												selectStr = " selected ";
											}
											wffieldselectStr += ("<option value=\""+wf_id_tmp+"_0\""+selectStr+">"+wf_name_tmp+"</option>\n");
										}
										wffieldselectStr2 += wffieldselectStr;
										if(hasNoDeatil == false){
											if(isbill.equals("0")){
												sql = "select workflow_formdictdetail.id as id,workflow_fieldlable.fieldlable as name from workflow_formdictdetail,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdictdetail.id and workflow_formfield.isdetail='1' and workflow_formfield.formid="+formID+" and workflow_formfield.groupid="+wf_groupid;
											}else{
												String detailTable = (String)detailTableList.get(i);
												sql = "select id as id , fieldlabel as name from workflow_billfield where viewtype=1 and billid="+ formID+" and detailtable='"+detailTable+"'";
											}
											rs.execute(sql);
											while(rs.next()){
												String wf_id_tmp = Util.null2o(rs.getString("id"));
												String wf_name_tmp = Util.null2String(rs.getString("name"));
												if(!isbill.equals("0")){
													wf_name_tmp = SystemEnv.getHtmlLabelName(Util.getIntValue(wf_name_tmp, 0), user.getLanguage());
												}
												String selectStr = "";
												if(!"".equals(valueStr) && valueStr.equals(wf_id_tmp+"_1")){
													selectStr = " selected ";
												}
												wffieldselectStr2 += ("<option value=\""+wf_id_tmp+"_1\" "+selectStr+">"+wf_name_tmp+"("+SystemEnv.getHtmlLabelName(17463, user.getLanguage())+")"+(i+1)+"</option>\n");
											}
										}
										wffieldselectStr2 += "</select>";
										checkStr = "";
										out.println("<tr"+classStr+">");
										out.println("<td>"+plan_crmname_tmp+"</td>");
										out.println("<td>"+wffieldselectStr2+"</td>");
										out.println("</tr>");
										out.println("<TR class=\"Spacing\"><TD class=\"Line\" colSpan=\"3\"></TD></TR>");
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
							<%}%>
                        </TD>
                        <TD></TD>
                    </TR>
                    <TR>
                        <TD height="10" colspan="3"></TD>
                    </TR>
                    <INPUT type=hidden id="workflowid" name="workflowid" value=<%=workflowid%>>
					<INPUT type=hidden id="wfid" name="wfid" value=<%=workflowid%>>
                    <INPUT type=hidden id="formID" name="formID" value=<%=formID%>>
                    <INPUT type=hidden id="isbill" name="isbill" value=<%=isbill%>>
					<INPUT type=hidden id="id" name="id" value="<%=id%>">
					<input type="hidden" id="operationType" name="operationType" value="">
					<input type="hidden" id="plantypeid" name="plantypeid" value="<%=plantypeid%>">
					<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid%>">
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
<script language="javascript">


</script>
</BODY>
</HTML>