<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/weaver.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdHRMCard.gif";
		String titlename = SystemEnv.getHtmlLabelName(16527, user.getLanguage());
		String needfav = "1";
		String needhelp = "";

		String roleid = "";
		String rolename = "";
		String zhurolename = "";
		String resourceid = Util.null2String(request.getParameter("resourceid"));
		rs.executeSql("select id,rolesmark from hrmroles where id in (select roleid from hrmrolemembers where resourceid = "+ resourceid + ")");
		while (rs.next()) {
			roleid += rs.getString("id") + ",";
			rolename += rs.getString("rolesmark") + ",";
		}
		if (!"".equals(rolename))
			rolename = rolename.substring(0, rolename.length() - 1);
		if (!"".equals(roleid))
			roleid = roleid.substring(0, roleid.length() - 1);
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle.jsp"%>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		<%
			if (HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)) {
				RCMenu += "{"
				+ SystemEnv.getHtmlLabelName(86, user.getLanguage())
				+ ",javascript:submitData(this),_self} ";
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(91, user.getLanguage())
					+ ",javascript:onAllDel(this),_self} ";
					RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		<table width=100% height=100% border="0" cellspacing="0"
			cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tr style="height:1px;">
				<td height="0" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">
								<form method=post name=hrmrolesadd action="HrmRolesMembersOperation.jsp">
									<input type=hidden name=operationType>
									<input type=hidden name=employeeID value="<%=resourceid%>">
									<input type=hidden name=roleID>
									<input type=hidden name=rolelevel2>
									<input type=hidden name=topagetmp value="hrmsingle">
									<input type=hidden name=id>
									<input type=hidden name=idtmps>
									<input type=hidden name=roleIDtmps>
									<input type=hidden name=rolelevel2tmps>
									<TABLE class=ViewForm>
										<col width='20%'>
										<col width='80%'>
										<TR>
											<TD class=lable>
												<%=SystemEnv.getHtmlLabelName(24055, user.getLanguage())%>
											</TD>
											<TD class=Field>
												<BUTTON class=Browser type="button" onclick="onShowRole('rolespan','rolesid')"></BUTTON>
												<SPAN ID=rolespan></SPAN>
												<INPUT class=inputStyle type=hidden name=rolesid>
											</TD>
										</TR>
										<TR style="height:1px">
											<TD class=Line colSpan=2></TD>
										</TR>
										<TR>
											<TD class=lable>
												<%=SystemEnv.getHtmlLabelName(139, user.getLanguage())%>
											</TD>
											<TD class=Field>
												<SELECT class=inputstyle name=rolelevel>
													<option value="0">
														<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%>
													</option>
													<option value="1" selected>
														<%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%>
													</option>
													<option value="2">
														<%=SystemEnv.getHtmlLabelName(140, user.getLanguage())%>
													</option>
												</SELECT>
											</TD>
										</TR>
										<TR style="height:1px">
											<TD class=Line colSpan=2></TD>
										</TR>
										<TR class=Title>
											<TH colSpan=2>
												<%=SystemEnv.getHtmlLabelName(24055, user.getLanguage())%>
											</TH>
										</TR>
										<TR style="height:1px">
											<TD  colSpan=2>
												<TABLE width=100% class=ListStyle cellspacing=1>
													<COLGROUP>
														<COL width="10%">
														<COL width="30%">
														<COL width="30%">
														<COL width="30%">
													<TBODY>
														<TR class=Header>
															<TD>
																<input type='checkbox' name='allcheck' onclick='checkall()'/>
															</TD>
															<TD>
																<%=SystemEnv.getHtmlLabelName(15068, user.getLanguage())%>
															</TD>
															<TD>
																<%=SystemEnv.getHtmlLabelName(21958, user.getLanguage())%>
															</TD>
															<TD>
																<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%>
															</TD>
														</TR>
														
														<%
														int needchange = 0;
														String checks = "";
														rs.executeProc("HrmRoleMembers_SByResourceID", resourceid);
														while (rs.next()) {
															zhurolename = Util.toScreen(RolesComInfo.getRolesRemark(rs.getString("roleid")), user.getLanguage());
															try {
																if (needchange == 0) {
															     needchange = 1;
														%>
														<TR class=datalight>
															<%
																} else {
																 needchange = 0;
															%>
														
														<TR class=datadark>
															<%
															    }
															%>
															<td>
															<input type='checkbox' value='<%=rs.getString("id")+"-"+rs.getString("roleid")+"-"+rs.getString("rolelevel")%>' name='check_<%=rs.getString("id") %>'/>
															</td>
															<TD>
																<%=zhurolename%>
															</TD>
															<TD>
															<%
															String rolelevel = rs.getString("rolelevel");
															String levelname = "";
															if (rolelevel.equals("2"))
															  levelname = SystemEnv.getHtmlLabelName(140, user.getLanguage());
															if (rolelevel.equals("1"))
															  levelname = SystemEnv.getHtmlLabelName(141, user.getLanguage());
															if (rolelevel.equals("0"))
															  levelname = SystemEnv.getHtmlLabelName(124, user.getLanguage());
															%>
															<%=levelname%>
															</TD>
															<TD>
															<%
																checks = checks + "check_"+rs.getString("id")+",";
															%>
																<a href="javascript:onDelete('<%=rs.getString("id")%>','<%=rs.getString("roleid")%>','<%=rolelevel%>')"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>
															</TD>
														</TR>
														<%
																} catch (Exception e) {
																System.out.println(e.toString());
															}
														}
														if(!"".equals(checks)){
															checks = checks.substring(0,checks.length()-1);
														}
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
									</TABLE>
								</FORM>
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
			<tr>
				<td height="0" colspan="3"></td>
			</tr>
		</table>
		<script language=javascript>
			function submitData(obj) {
			     document.hrmrolesadd.operationType.value="newRoles";
			     hrmrolesadd.submit();
			     obj.disabled = true;		      
			}
			
			function onShowRole(spanname, inputname){
			   var hrm_id = "<%=user.getUID()%>";
			    tmpids = jQuery("input[name="+inputname+"]").val();
			    if(tmpids!="-1"){ 
			      url="/hrm/roles/MutiRolesBrowser.jsp?resourceids="+tmpids+"&hrm_id="+hrm_id;
			    }else{
			      url="/hrm/roles/MutiRolesBrowser.jsp?hrm_id="+hrm_id;
			    }
				var data;
			    try {
			        data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
			    } catch(e) {
			        //return;
			    }
			    if (data != null) {
			        if (data.id != "0" && data.name!="") {
				        var name = "";
				        var id = "";
				        if(data.name.length>1){
				        	name = data.name.substring(1);
				        	id = data.id.substring(1)
					    }
			            jQuery("#"+spanname).html(name);
			            jQuery("input[name="+inputname+"]").val(id);
					}else{
						 jQuery("#"+spanname).html("");
				         jQuery("input[name="+inputname+"]").val("");
					}
				}
			    
			}
			
		    function onDelete(id,rolesid,rolelevel){
				if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
				    document.hrmrolesadd.operationType.value="Delete";
				    document.hrmrolesadd.roleID.value=rolesid;
				    document.hrmrolesadd.rolelevel2.value=rolelevel;
				    document.hrmrolesadd.id.value=id;
				    document.hrmrolesadd.submit();
				}
		    }
		    function checkall(){
		    	var checkboxtmp = "<%=checks%>";
				var checktmp = checkboxtmp.split(",");
				if(document.getElementById("allcheck").checked){
					for(var n=0;n<checktmp.length;n++){
						document.getElementById(checktmp[n]).checked=true;
					}
				}else{
					for(var n=0;n<checktmp.length;n++){
						document.getElementById(checktmp[n]).checked=false;
					}
				}
			}
			function onAllDel(obj){
				var checkboxtmp = "<%=checks%>";
				var checktmp = checkboxtmp.split(",");
				var checkedstr = false;
				var idtmpsvalue = "";
				var roleIDtmpsvalue = "";
				var rolelevel2tmpsvalue = "";
				for(var n=0;n<checktmp.length;n++){
					if(document.getElementById(checktmp[n]).checked){
						var checktmpvalue = document.getElementById(checktmp[n]).value;
						var checktmpvalues = checktmpvalue.split("-");
						idtmpsvalue = idtmpsvalue + "," + checktmpvalues[0];
						roleIDtmpsvalue = roleIDtmpsvalue + "," + checktmpvalues[1];
						rolelevel2tmpsvalue = rolelevel2tmpsvalue + "," + checktmpvalues[2];
						checkedstr = true;
					}
				}
				if(checkedstr){
					if(confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>")) {
						document.hrmrolesadd.operationType.value="allDelete";
						document.hrmrolesadd.idtmps.value = idtmpsvalue;
						document.hrmrolesadd.roleIDtmps.value = roleIDtmpsvalue;
						document.hrmrolesadd.rolelevel2tmps.value = rolelevel2tmpsvalue;
						document.hrmrolesadd.submit();
						obj.disabled = true;
					}
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(24788, user.getLanguage())%>");
					return;
				}
			}
		</script>
	</BODY>
</HTML>
