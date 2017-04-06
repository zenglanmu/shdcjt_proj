<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver.js"></script>
		<style>
		#loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
		</style>
	</head>
	<%
		if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user))
		{
			response.sendRedirect("/notice/noright.jsp");
	    	
			return;
		}
		String imagefilename = "/images/hdSystem.gif";
		String titlename = SystemEnv.getHtmlLabelName(24771,user.getLanguage());//"流程导入";24771
		String needfav = "1";
		String needhelp = "";
		
		String workflowid = Util.null2String(request.getParameter("workflowid"));
		String importtype = Util.null2String(request.getParameter("importtype"));
		String type = Util.null2String(request.getParameter("type"));
		String checkresult = Util.null2String(request.getParameter("checkresult"));
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle.jsp"%>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		
		<div id="loading">
			<span><img src="/images/loading2.gif" align="absmiddle"></span>
			<!-- 数据导入中，请稍等... -->
			<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(28210,user.getLanguage())%></span>
		</div>

		<div id="content">
		<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="WfImportOperation.jsp" enctype="multipart/form-data">
			<table width=100% height=100% border="0" cellspacing="0"
				cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
								<%
									if(checkresult.equals("1")){//流程类型不相等
										out.println("<span><font color=red>"+SystemEnv.getHtmlLabelName(28211,user.getLanguage())+"<font></span>");
										out.println("<br/>");
									}else if(checkresult.equals("2")){//
										out.println("<span><font color=red>"+SystemEnv.getHtmlLabelName(28212,user.getLanguage())+"<font></span>");
										out.println("<br/>");
									}
								%>

									<TABLE class=ViewForm>
										<COLGROUP>
											<COL width="20%">
											<COL width="80%">
										<TBODY>
											<TR class=Title>
												<TH colSpan=2>
													<!-- 必要信息 -->
													<%=SystemEnv.getHtmlLabelName(25645,user.getLanguage())%>
												</TH>
											</TR>
											<TR class=Spacing style="height:1px;">
												<TD class=Line1 colSpan=2></TD>
											</TR>
											<tr>
												<td>
													<!-- 导入 -->
													<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>
												</td>
												<td class=Field>
													<button type=BUTTON  class=btnSave onclick="importwf();" title="<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>">
														<!-- 开始导入-->
														<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>
													</button>
												</td>
											</tr>
											<TR class=Spacing style="height:1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
											<tr>
												<td>
													<!-- 导入类型 -->
													<%=SystemEnv.getHtmlLabelName(24863,user.getLanguage())%>
												</td>
												<td class=Field>
													<select id="importtype" name="importtype" onchange="importTypeChange(this)">
														<option value="0" <%if(importtype.equals("0")) out.println("selected");%>>
															<!-- 新增 -->
															<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%>
														</option>
														<option value="1" <%if(importtype.equals("1")) out.println("selected");%>>
															<!-- 更新-->
															<%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%>
														</option>
													</select>
												</td>
											</tr>
											<TR class=Spacing style="height:1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
											
											<tr id="type_tr">
												<td>
													<!-- 系统一致性 -->
													<%=SystemEnv.getHtmlLabelName(25646,user.getLanguage())%>
												</td>
												<td class=Field>
													<select id=type name=type>
														<option value="0" <%if(type.equals("0")) out.println("selected");%>>
															<!-- 系统一致 -->
															<%=SystemEnv.getHtmlLabelName(25647,user.getLanguage())%>
														</option>
														<option value="1" <%if(type.equals("1")) out.println("selected");%>>
															<!-- 系统不一致-->
															<%=SystemEnv.getHtmlLabelName(25648,user.getLanguage())%>
														</option>
													</select>
												</td>
											</tr>
											<TR class=Spacing style="height:1px;" id="type_line_tr">
												<TD class=Line colSpan=2></TD>
											</TR>
											<tr id="workflow_tr">
												<td>
													<!-- 选择被更新的流程类型 -->
													<%=SystemEnv.getHtmlLabelName(28127,user.getLanguage())%>
												</td>
												<td class=Field>
													<input class="wuiBrowser" name="workflowid" type="hidden" _required="yes" value="<%=workflowid%>" _displayText="<%=WorkflowComInfo.getWorkflowname(workflowid)%>" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp">
												</td>
											</tr>
											<TR id="workflow_line_tr" class=Spacing style="height:1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
											<tr>
												<td>
													<!-- 文件-->
													XML<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>
												</td>
												<td class=Field>
													<input class=InputStyle  type=file size=40 name="filename" id="filename" onChange="checkinput('filename','filenamespan')">
													<span id="filenamespan"><img src="/images/BacoError.gif" align=absmiddle></span> 
												</td>
											</tr>
											<TR style="height:1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
										</TBODY>
									</TABLE>
									<br>
									<div id="returnMSg" name="returnMSg">
										<BR>
										<BR>
										<BR>
										<table class=ReportStyle>
											<TBODY>
												<TR>
													<TD>
														<B><%=SystemEnv.getHtmlLabelName(19010, user.getLanguage())%></B>：
														<BR>
														<!-- 先选择系统一致性后,选择要导入的xml文件后,点击“开始导入”按钮即可进行导入，导入内容中各项说明如下：-->
														<%=SystemEnv.getHtmlLabelName(25650,user.getLanguage())%>
														<BR>
														<B><!-- 系统一致性--><%=SystemEnv.getHtmlLabelName(25646,user.getLanguage())%>：<!--系统一致--><%=SystemEnv.getHtmlLabelName(25647,user.getLanguage())%>  </B>
														<BR>
														<!-- 流程xml文件导出的系统与xml文件导入的系统完全一致(人员，组织结构，角色等一致)-->
														<%=SystemEnv.getHtmlLabelName(25651,user.getLanguage())%>
														<BR>
														<B><!-- 系统一致性--><%=SystemEnv.getHtmlLabelName(25646,user.getLanguage())%>：<!--系统不一致--><%=SystemEnv.getHtmlLabelName(25648,user.getLanguage())%>  </B>
														<BR>
														<!--流程xml文件导出的系统与流程xml文件导入的系统可能不一致(人员，组织结构，角色等不一致)。不一致的情况下，流程操作者，出口条件,以及与其他模块相关功能(比如高级设置，联动设置等)将不会导入，需要重新设置-->
														<%=SystemEnv.getHtmlLabelName(25652,user.getLanguage())%>
														<BR>
														<B><!-- 导入类型--><%=SystemEnv.getHtmlLabelName(24863,user.getLanguage())%>：<!--新增--><%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%>  </B>
														<BR>
														<%=SystemEnv.getHtmlLabelName(28213,user.getLanguage())%>
														<BR>
														<B><!-- 导入类型--><%=SystemEnv.getHtmlLabelName(24863,user.getLanguage())%>：<!--更新--><%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%>  </B>
														<BR>
														<%=SystemEnv.getHtmlLabelName(28214,user.getLanguage())%>
														<BR>
													</TD>
												</TR>
											</TBODY>
										</table>
									</div>

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
			<div id='divshowreceivied'
				style="background: #FFFFFF; padding: 3px; width: 100%; display: none"
				valign='top'>
			</div>
		</FORM>
		</div>
	</BODY>
	
	<script type="text/javascript">
	function importTypeChange(obj){
		if(obj.value=="1"){//更新
			jQuery("#workflow_tr").show();
			jQuery("#workflow_line_tr").show();			
			jQuery("#type").val("0");
			jQuery("#type").attr("disabled",true);
		}else{//新增，需要把流程类型的数据清空
			jQuery("#type").attr("disabled",false);
			jQuery("#workflow_tr").hide();
			jQuery("#workflow_line_tr").hide();
			jQuery("#workflowid").val("");
			jQuery("#workflowidSpan").html("<img src=\"/images/BacoError.gif\" align=\"absmiddle\">");
		}
	}

	jQuery(document).ready(function(){
		importTypeChange($GetEle("importtype"));
		jQuery("#loading").hide();
	})

	function importwf()
	{
		var parastr="filename";
		var filename = document.frmMain.filename.value;
		//如果导入类型为
		if($GetEle("importType").value=="1"){
			if(!check_form(document.frmMain,"workflowid")){
				return;
			}
			jQuery("#type").val("0");
			document.frmMain.action = "/workflow/import/WfUpdateOperation.jsp";
		}else{
			document.frmMain.action = "/workflow/import/WfImportOperation.jsp";
		}

		if(check_form(document.frmMain,parastr))
		{
			var pos = filename.length-4;
			if(filename.lastIndexOf(".xml")==pos)
			{
				jQuery("#type").attr("disabled",false);
				jQuery("#loading").show();
				jQuery("#content").hide();
				document.frmMain.submit();
			}
			else
			{
				alert("<%=SystemEnv.getHtmlLabelName(25644,user.getLanguage())%>");//选择文件格式不正确,请选择xml文件25644
				return;
			}
		}
	}
	</script>
</HTML>