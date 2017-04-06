<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	int templateId = Util.getIntValue(request.getParameter("templateId"));
	int extendtempletid = Util.getIntValue(request.getParameter("extendtempletid"));


	//System.out.println("extendtempletid:"+extendtempletid);
	
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";   

	int userid= user.getUID();
%>
<html>
<head>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"...,javascript:saveAs(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(templateId!=1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM name="frmAdd" method="post"   action="operation.jsp">
<input  name="method" type="hidden" value="edit"/>
<input name="templateId" type="hidden" value="<%=templateId%>"/>
<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId%>"/>
<input type="hidden" name="extendtempletid"  value="<%=extendtempletid%>"/>
<input type="hidden" name="fieldname"/>


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

<TABLE class="Shadow">
	<tr>
		<td valign="top">
			<TABLE class=ViewForm>
				<COLGROUP>
				<COL width="30%">
				<COL width="70%">
				<TBODY>

				<TR>
					<TD>
					<b><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></b>
					</TD>
					<TD class="tdExtend">
					<%   
						rsExtend.executeSql("select id,extendname,extendurl from extendHomepage order by extendname,id");
						while(rsExtend.next()){
							int id=Util.getIntValue(rsExtend.getString("id"));
							String extendname=Util.null2String(rsExtend.getString("extendname"));	
							String extendurl=Util.null2String(rsExtend.getString("extendurl"));	
					
							String strChecked="";
							
							if(extendtempletid==id) {
								strChecked=" checked ";
							}
							
							if (id == 3) {
								out.println("<input type='radio' value="+id+" onclick=\"chkExtendClick(this,'"+extendurl+"/setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+id+"')\"   name='extendtempletid' style=\"width:18px\" "+strChecked+">"+extendname+"(<span style=\"color:red;\">推荐</span>)&nbsp;&nbsp;");
								out.println("<input type='radio' onclick=\"chkExtendClick(this,'/systeminfo/template/templateEdit.jsp?id=" + templateId + "&subCompanyId=" + subCompanyId + "&commonTemplet=1')\" value=\"0\" name=\"extendtempletid\" style=\"width:18px\""  + ((extendtempletid==0) ? " checked " : "") + ">" + SystemEnv.getHtmlLabelName(20621,user.getLanguage()) + "(<span style=\"color:red;\">不推荐</span>)&nbsp;&nbsp;");
							} else {
								out.println("<input type='radio' value="+id+" onclick=\"chkExtendClick(this,'"+extendurl+"/setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+id+"')\"   name='extendtempletid' style=\"width:18px\" "+strChecked+">"+extendname+"(<span style=\"color:red;\">不推荐</span>)&nbsp;&nbsp;");								
							}
						}
					%>
					</TD>
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>	

				<TR>
					<TD COLSPAN=2>
						<%
							
							String templateName="",templateTitle="",logo="",isOpen="";
							int extendHpWeb1Id=0;

							boolean saved=false;
							String sql = "SELECT * FROM SystemTemplate WHERE id="+templateId;
							rs.executeSql(sql);
							
							if(rs.next()){
								templateName = rs.getString("templateName");
								templateTitle = rs.getString("templateTitle");								
								isOpen = rs.getString("isOpen").equals("1") ? "1" : "0";

								String tempextendtempletid = Util.null2String(rs.getString("extendtempletid"));	
								String tempextendtempletvalueid = Util.null2String(rs.getString("extendtempletvalueid"));	

								//System.out.println("tempextendtempletid:"+tempextendtempletid);
								//System.out.println("tempextendtempletvalueid:"+tempextendtempletvalueid);
								if("1".equals(tempextendtempletid)&&!"".equals(tempextendtempletvalueid)) saved=true;
							}

							
							String extendHpWebCustomId="";
							String pagetemplateid="";;	
							String menuid="";
							String menustyleid="";
							String menutype="";
							String useVoting="";
							String useRTX="";
							String useWfNote="";
							String useBirthdayNote="";
							String defaultshow  ="";
							String floatwidth="";
							String floatheight ="";
							String docId ="";
							String docName="";
							String leftmenuid="";
							String leftmenustyleid="";
							String useDoc="";
							rsExtend.executeSql("select * from extendHpWebCustom where templateId="+templateId);
							
							if(rsExtend.next()){
								extendHpWebCustomId=Util.null2String(rsExtend.getString("id"));
								pagetemplateid=Util.null2String(rsExtend.getString("pagetemplateid"));
								menuid=Util.null2String(rsExtend.getString("menuid"));
								menustyleid=Util.null2String(rsExtend.getString("menustyleid"));
								menutype = Util.null2String(rsExtend.getString("menutype"));
								useVoting=Util.null2String(rsExtend.getString("useVoting"));
								useRTX=Util.null2String(rsExtend.getString("useRTX"));
								useWfNote=Util.null2String(rsExtend.getString("useWfNote"));
								useBirthdayNote=Util.null2String(rsExtend.getString("useBirthdayNote"));
								defaultshow = Util.null2String(rsExtend.getString("defaultshow"));
								floatwidth = Util.null2String(rsExtend.getString("floatWidth"));
								floatheight = Util.null2String(rsExtend.getString("floatHeight"));
								docId = Util.null2String(rsExtend.getString("docId"));
								leftmenuid = Util.null2String(rsExtend.getString("leftmenuid"));
								leftmenustyleid = Util.null2String(rsExtend.getString("leftmenustyleid"));
                                useDoc = Util.null2String(rsExtend.getString("useDoc"));
								
								if(!docId.equals("")){
									docName = DocComInfo.getDocname(docId);
								}
							}
							
							
							%>	
							<input type="hidden" name="extendHpWebCustomId"  value="<%=extendHpWebCustomId%>"/>
						
									<TABLE class=ViewForm>
										<COLGROUP>
										<COL width="30%">									
										<COL width="70%">
										<tr>
										<td><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
										<td class=Field>
										    <input type="hidden" id="oldTemplateName" value="<%=templateName%>">											
											<INPUT class=InputStyle  style="width:50%" id="templateName" name="templateName" value="<%=templateName%>" onchange="checkinput('templateName','templateNameImage')">
											<SPAN id="templateNameImage"></SPAN>
										</td>
										</tr>
										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

										<td><%=SystemEnv.getHtmlLabelName(18795,user.getLanguage())%></td>
										<td class=Field>
											<INPUT class=InputStyle  style="width:50%"  id="templateTitle" name="templateTitle" value="<%=templateTitle%>">
										</td>
										</tr>
										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
										<TR>
											<TD><%=SystemEnv.getHtmlLabelName(23140,user.getLanguage())%><!--选择模板--></TD>
											<TD class="field">
												<select name="pagetemplateid" style="width:50%" >
													<%
													rs.executeSql("select * from pagetemplate order by id");
													while (rs.next()){
													%>
													<option value="<%=rs.getString("id")%>" <%=rs.getString("id").equals(pagetemplateid)?" selected ":""%> ><%=rs.getString("templatename")%></option>
													<%}%>
												</select>
												<%
													if(rs.getCounts()==0){
														%>
														<SPAN id=pagetemplateidSpan><IMG align=absMiddle src="/images/BacoError.gif"></SPAN>
														<%
													}
												%>
											</TD>										
										</TR>
										
										<TR style="height:1px;"><TD colspan=2 class=line>
										<TR>
											<TD><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())%><!--顶部导航菜单--></TD>
											<TD class="field">
												<select name="menuid" style="width:50%" >
													<%
													MenuCenterCominfo.setTofirstRow();						
													while(MenuCenterCominfo.next()){												
													%>
													<option value="<%=MenuCenterCominfo.getId()%>" <%=MenuCenterCominfo.getId().equals(menuid)?" selected ":""%>><%=MenuCenterCominfo.getMenuname()%></option>
													<%}%>
												</select>
											
											</TD>										
										</TR>
										<TR style="height:1px;"><TD colspan=2 class=line>
										
										
										</TD></TR>

										<TR>
											<TD><%=SystemEnv.getHtmlLabelName(22916,user.getLanguage())%><!--菜单样式--></TD>

											<TD class="field">
									
												<INPUT id="tempMenuType" type=hidden value="menuh" name="tempMenuType">
												<INPUT id="menustyleid" class="wuiBrowser" type=hidden value="<%=menustyleid %>" name="menustyleid"
													_displayTemplate="<a href='/page/maint/style/MenuStyleEditH.jsp?styleid=#b{id}&type=menuh&from=list' target='_blank'>#b{name}</a>"
													_url="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type=menuh"
													_displayText="<%=mhsc.getTitle(menustyleid) %>"
													>
											</TD>	
											
										</TR>
										<TR style="height:1px;"><TD colspan=2 class=line>
										<TR>
											<TD><%=SystemEnv.getHtmlLabelName(17596,user.getLanguage())%><!--左侧菜单--></TD>
											<TD class="field">
												<select name="leftmenuid" style="width:50%" >
													<%
													MenuCenterCominfo.setTofirstRow();						
													while(MenuCenterCominfo.next()){	
														if(MenuCenterCominfo.getMenutype().equals("sys")){
															continue;
														}
													%>
													<option value="<%=MenuCenterCominfo.getId()%>" <%=MenuCenterCominfo.getId().equals(leftmenuid)?" selected ":""%>><%=MenuCenterCominfo.getMenuname()%></option>
													<%}%>
												</select>
											
											</TD>										
										</TR>
										<TR style="height:1px;"><TD colspan=2 class=line>
										
										
										</TD></TR>

										<TR>
											<TD><%=SystemEnv.getHtmlLabelName(22916,user.getLanguage())%><!--左侧菜单样式--></TD>

											<TD class="field">			
												<INPUT id="templeftMenuType" type=hidden value="menuv" name="templeftMenuType">
												<INPUT id="leftmenustyleid" class="wuiBrowser" type=hidden value="<%=leftmenustyleid %>" name="leftmenustyleid"
													_displayTemplate="<a href='/page/maint/style/MenuStyleEditV.jsp?styleid=#b{id}&type=menuh&from=list' target='_blank'>#b{name}</a>"
													_url="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type=menuv"
													_displayText="<%=mvsc.getTitle(leftmenustyleid) %>"
													>
											</TD>	
											
										</TR>
										<TR style="height:1px;"><TD colspan=2 class=line>
										</TD></TR>
										<TR>
										<!-- TODO -->
											<TD><%=SystemEnv.getHtmlLabelName(23103,user.getLanguage())%><!--默认显示页--></TD>


											<TD class="field">
												    <input type="text" id="defaultshow" name="defaultshow" class='inputstyle' value="<%=defaultshow %>" style="width: 260;">
													<BUTTON class=Browser onclick=onShowHpPages(defaultshow,defaultshowSpan,"")></BUTTON>
													<span id=defaultshowSpan name=defaultshowSpan></span>								
											</TD>										
										</TR>
										<TR style="display:none;height:1px;"><TD class=Line colSpan=2></TD></TR>
										<tr style="display:none">
											<td valign="top"><%=SystemEnv.getHtmlLabelName(23085,user.getLanguage())%></td>
											<td>
												<TABLE class="viewform" width="100%">
													<colgroup>
														<col width="100%" />
													</colgroup>
													<TBODY>
														<TR>
															<td class="field">
																<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>:
																<INPUT class="inputstyle"
																	title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
																	style="WIDTH: 100px" name="floatwidth"
																	value="<%=floatwidth %>"  onchange="javascript:checkMumber(this);"/>
																<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
																<INPUT class="inputstyle"
																	title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
																	style="WIDTH: 100px" name="floatheight"
																	value="<%=floatheight %>"  onchange="javascript:checkMumber(this);"/>
																&nbsp;
															</td>
														</TR>
														<TR style="height:1px;">
															<TD class="LINE" colSpan="1"></TD>
														</TR>
														<TR>
															<td class="field">
																<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%>:
																<INPUT id="docId" type=hidden value="<%=docId %>" name="docId">
																<button type="button"  class=Browser onclick=onShowDocs(docId,spanDocId)></BUTTON>
																<SPAN id=spanDocId>
																	<%
																	if(!"".equals(docId))
																	{ 
																	%>
																	<a href="/docs/docs/DocDsp.jsp?id=<%=docId %>" target="_blank"><%=docName %></a>
																	<%
																	}
																	%>
																</SPAN>
															</td>
														</TR>
													</TBODY>
												</TABLE>
											</td>
										</tr>
										<TR style="height:1px;"><TD colspan=2 class=line></TD></TR>
										<TR>
										<!-- TODO -->
											<TD><%=SystemEnv.getHtmlLabelName(23835,user.getLanguage())%></TD>


											<TD class="field">
												<input type="checkbox" name="useVoting" value="1"  <%=useVoting.equals("1")?" checked ":""%>><%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%><!--网上调查-->
												<input type="checkbox"  name="useRTX" value="1" <%=useRTX.equals("1")?" checked ":""%>><%=SystemEnv.getHtmlLabelName(23041,user.getLanguage())%><!--RTX自启动-->
												<input type="checkbox"  name="useWfNote" value="1" <%=useWfNote.equals("1")?" checked ":""%>><%=SystemEnv.getHtmlLabelName(23042,user.getLanguage())%><!--流程提醒-->
												<input type="checkbox"  name="useBirthdayNote"  value="1" <%=useBirthdayNote.equals("1")?" checked ":""%>><%=SystemEnv.getHtmlLabelName(17534,user.getLanguage())%><!--生日提醒-->								
												<input type="checkbox"  name="useDoc"  value="1" <%=useDoc.equals("1")?" checked ":""%>><%=SystemEnv.getHtmlLabelName(25881,user.getLanguage())%><!--文档弹出框-->			
											</TD>										
										</TR>
										<TR style="height:1px;"><TD colspan=2 class=line></TD></TR>
									</TABLE>
									</form>

					</TD>
				</TR>

     	</TABLE>

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
</FORM>

</body>
</html>
<script language="javascript">
function checkMumber(o)
{
	var value = o.value;
	var r = /^-?[0-9]+$/g;　　//整数 
    var flag = r.test(value);
    if(!flag)
    {
    	alert("<%=SystemEnv.getHtmlLabelName(23086,user.getLanguage())%>!");
    	o.value="";
    	o.focus(true,100);
		return;
    }
}
function chkExtendClick(obj,url){
	if(obj.checked){
		window.location=url;	
	}
}

function checkSubmit(obj){
	if(check_form(frmAdd,"templateName,pagetemplateid")){
		obj.disabled=true;
		document.frmAdd.submit();	
	}
}
function saveAs(obj){
	if(check_form(frmAdd,"templateName,pagetemplateid")){
		//document.getElementById("method").value = "saveas";
		//obj.disabled=true;
		//document.frmAdd.submit();
		if(document.getElementById("templateName").value==document.getElementById("oldTemplateName").value){
			var str="<%=SystemEnv.getHtmlLabelName(18971,user.getLanguage())%>";
			if(confirm(str)){
				document.getElementById("method").value = "saveas";
				obj.disabled=true;
				document.frmAdd.submit();
			}
		}else{
			document.getElementById("method").value = "saveas";
			obj.disabled=true;
			document.frmAdd.submit();
		}		
	}
}
function del(obj){
	if(<%=isOpen%>=="1"){
		alert("<%=SystemEnv.getHtmlLabelName(18970,user.getLanguage())%>");
		return false;
	}else{
		if(isdel()){
			document.getElementById("method").value = "delete";
			obj.disabled=true;
			document.frmAdd.submit();
		}		
	}
}
function clearMenuType(o)
{	
	var menuType = document.getElementById("menustyleid");
	var spanMenuType = document.getElementById("spanMenuTypeId");
	var tempMenuType = document.getElementById("tempMenuType");
	var mTypes = document.getElementById("menuType");

	menuType.value = "";
	spanMenuType.innerHTML = "";
	tempMenuType.value = o.value;
}
function onShowHpPages(input,span,eid){
     datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=2");
	 if(datas){
		  if(datas.id!= ""){
			   span.innerHTML = "<a href='"+datas.name+"' target='_blank'>" + datas.id +"</a>";
			   input.value=datas.name;
		  }else{
			   span.innerHTML = "";
			   input.value="#";
		  }
	 }
}
function onShowDocs(input,span){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp");
	 if(datas){
		  if(datas.id!= ""){
			   span.innerHTML = "<a href='/docs/docs/DocDsp.jsp?id="+datas.id+"' target='_blank'>" + datas.name +"</a>";
			   input.value=datas.id;
		  }else{
			   span.innerHTML = "";
			   input.value="0";
		  }
	 }
}

</script>
<!--  
<script language=vbs>
sub onShowHpPages(input,span,eid)
		
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=2")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			span.innerHtml = "<a href='"&id(1)&"' target='_blank'>" & id(0) &"</a>"
			input.value=id(1)
		else 
			span.innerHtml = ""
			input.value="#"
		end if
	end if
end sub
sub onShowDocs(input,span)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			span.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"' target='_blank'>" & id(1) &"</a>"
			input.value=id(0)
		else 
			span.innerHtml = ""
			input.value="0"
		end if
	end if
end sub
sub onShowMenuTypes(input,span,menutype)
		menutype = menutype.value
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type="&menutype)
		menulink = ""
		if menutype = "element" then
			menulink = "ElementStyleEdit.jsp"
		ElseIf menutype = "menuh" Then
			menulink = "MenuStyleEditH.jsp"
		else
			menulink = "MenuStyleEditV.jsp"
		end if
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "MenuStyleEditH.jsp<a href='/page/maint/style/"&menulink&"?styleid="&id(0)&"&type="&menutype&"&from=list' target='_blank'>"&id(1)&"</a>"
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub
</script>
-->