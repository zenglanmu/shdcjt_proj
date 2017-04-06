<%@ include file="/page/element/settingCommon.jsp"%>
<%@ include file="common.jsp"%>
<%@page import="java.util.ArrayList;"%>
<%
String pictureheight = (String)valueList.get(nameList.indexOf("pictureheight"));
String picturewidth = (String)valueList.get(nameList.indexOf("picturewidth"));
String height = (String)valueList.get(nameList.indexOf("height"));
String width = (String)valueList.get(nameList.indexOf("width"));
String highopen = (String)valueList.get(nameList.indexOf("highopen"));
String needbutton = (String)valueList.get(nameList.indexOf("needbutton"));

String picturewordcount = (String)valueList.get(nameList.indexOf("picturewordcount"));
String pictureShowType = (String)valueList.get(nameList.indexOf("pictureShowType"));
String autoShow = (String)valueList.get(nameList.indexOf("autoShow"));
String autoShowSpeed = (String)valueList.get(nameList.indexOf("autoShowSpeed"));
if("".equals(height)){
	height ="75";
}
if("".equals(width)){
	width = "75";
}
%>


		
		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(24051,user.getLanguage())%></TD>
			<!--弹出设置-->
			<TD class="field" style='padding-left:5px'>
				<INPUT type="checkbox"
					title="<%=SystemEnv.getHtmlLabelName(24052,user.getLanguage())%>"
					style="WIDTH: 24px" name="highopen_<%=eid %>"
					value="<%=highopen %>" <%if("1".equals(highopen)) out.print("checked");%> onclick="if(this.checked){this.value='1';}else{this.value='0';}"/>&nbsp;<%=SystemEnv.getHtmlLabelName(24052,user.getLanguage())%>
			</TD>
		</TR>
		<TR>
			<TD class="LINE" colSpan="2"></TD>
		</TR>
		<TR vAlign="top">
			<td>&nbsp;<%=SystemEnv.getHtmlLabelName(21653,user.getLanguage())%></td>
			<TD class="field" style='padding-left:7px'>
				<INPUT id="pictureShowType_<%=eid%>" type="radio" <%if(pictureShowType.equals("1")) out.print("checked");%>
									name="pictureShowType_<%=eid%>" selecttype="1" value='1'
									onclick="if(this.checked){singlePicture_<%=eid%>.style.display='';singlePicture_<%=eid%>.nextSibling.style.display;mutilPicture_<%=eid%>.style.display='none';mutilPicture_<%=eid%>.nextSibling.style.display='';}else{singlePicture_<%=eid%>.style.display='none';singlePicture_<%=eid%>.nextSibling.style.display='none';mutilPicture_<%=eid%>.style.display='';mutilPicture_<%=eid%>.nextSibling.style.display='';}"/>
									&nbsp;<%=SystemEnv.getHtmlLabelName(22920,user.getLanguage())%>&nbsp;		
				<INPUT id="pictureShowType_<%=eid%>" type="radio" <%if(pictureShowType.equals("2")) out.print("checked");%>
									name="pictureShowType_<%=eid%>" selecttype="1" value='2' 
									onclick="if(this.checked){mutilPicture_<%=eid%>.style.display='';mutilPicture_<%=eid%>.nextSibling.style.display='';singlePicture_<%=eid%>.style.display='none';singlePicture_<%=eid%>.nextSibling.style.display='none';}else{mutilPicture_<%=eid%>.style.display='none';mutilPicture_<%=eid%>.nextSibling.style.display='none';singlePicture_<%=eid%>.style.display='';singlePicture_<%=eid%>.nextSibling.style.display='';}"/>
									&nbsp;<%=SystemEnv.getHtmlLabelName(22921,user.getLanguage())%>
			</TD>
		</TR>
		<TR vAlign="top">
			<TD class="line" colSpan="2"></TD>
		</TR>
		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></TD>
			<!--宽度设置-->
			<TD class="field" style='padding-left:10px'>
				<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>:
				<INPUT class="inputstyle"
					title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
					style="WIDTH: 24px" name="width_<%=eid %>"
					value="<%=width %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
					ondragenter="return false"
					style="ime-mode:Disabled"
					>
				&nbsp;
				<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
				<INPUT class="inputstyle"
					title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
					style="WIDTH: 24px" name="height_<%=eid %>"
					value="<%=height %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
					ondragenter="return false"
					style="ime-mode:Disabled"
					>
				&nbsp;
			</TD>
		</TR>
		<TR>
			<TD class="LINE" colSpan="2"></TD>
		</TR>
		<TR vAlign="top" style="display:<%if(pictureShowType.equals("1")){ %><%}else{ %>none<%} %>" id="singlePicture_<%=eid%>">
			<TD>&nbsp;<%=SystemEnv.getHtmlLabelName(22930,user.getLanguage())%></TD>
			<!--picture来源-->
			<TD>
				<table class="viewform" width="100%">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<TBODY>
						<TR>
							<td class="field" style='padding-left:8px'>
								<BUTTON type='button' class=btnSetting id=BacoAddFavorite title="<%=SystemEnv.getHtmlLabelName(22922,user.getLanguage())%>" 
									onclick="window.showModalDialog('/page/element/Picture/SettingBrowser.jsp?picturetype=1&eid=<%=eid%>')" >
								</BUTTON>
								<a href="javascript:void(0);" title="<%=SystemEnv.getHtmlLabelName(22922,user.getLanguage())%>" onclick="window.showModalDialog('/page/element/Picture/SettingBrowser.jsp?picturetype=1&eid=<%=eid%>');"><%=SystemEnv.getHtmlLabelName(22923,user.getLanguage())%></a>
							</td>
							<td class="field"></td>
						</TR>
					</TBODY>
				</TABLE>
			</TD>
		</TR>
		
		<TR style="display:<%if(pictureShowType.equals("1")){ %><%}else{ %>none<%} %>">
			<TD class="LINE" colSpan="2" ></TD>
		</TR>
		<TR vAlign="top" style="display:<%if(pictureShowType.equals("2")){ %><%}else{ %>none<%} %>" id="mutilPicture_<%=eid%>">
			<TD>&nbsp;<%=SystemEnv.getHtmlLabelName(22930,user.getLanguage())%></TD>
			<!--picture来源-->
			<TD style='padding:0'>
				<TABLE class="viewform" width="100%">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<TBODY>
						<TR style='display:none'>
							<td class="field">
								&nbsp;<%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%>:
								<INPUT class="inputstyle"
									title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
									style="WIDTH: 30px" name="picturewidth_<%=eid%>"
									value="<%=picturewidth %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
									ondragenter="return false"
									style="ime-mode:Disabled"
									>
							</td>
							<td class="field">
								<%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%>:
								<INPUT class="inputstyle"
									title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
									style="WIDTH: 30px" name="pictureheight_<%=eid %>"
									value="<%=pictureheight %>"  onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
									ondragenter="return false"
									style="ime-mode:Disabled"
									>
								&nbsp;
							</td>
						</TR>
						<TR style='display:none'>
							<TD class="LINE" colSpan="2"></TD>
						</TR>
						<TR vAlign="top">
							<td class="field" style='padding-left:4px'>
								<INPUT type=checkbox
									title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
									style="WIDTH: 24px" name="autoShow_<%=eid%>" <%if("1".equals(autoShow)) out.print("checked");%>
									value="<%=autoShow %>" onclick="if(this.checked){this.value='1';}else{this.value='';}"/><%=SystemEnv.getHtmlLabelName(22926,user.getLanguage())%>
								&nbsp;
							</td>
							<TD class="field" style='padding-left:4px'>
								<%=SystemEnv.getHtmlLabelName(22927,user.getLanguage())%>:
								<INPUT class="inputstyle"
									title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
									style="WIDTH: 24px" name="autoShowSpeed_<%=eid %>"
									value="<%=autoShowSpeed %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
									ondragenter="return false"
									style="ime-mode:Disabled"
									>
								&nbsp;
							</TD>
						</TR>
						<TR>
							<TD class="LINE" colSpan="2"></TD>
						</TR>
						<TR>
							<td class="field" style='padding-left:4px'>
								<INPUT type=checkbox
									title="<%=SystemEnv.getHtmlLabelName(22928,user.getLanguage())%>"
									style="WIDTH: 24px" name="needbutton_<%=eid%>" <%if("1".equals(needbutton)) out.print("checked");%>
									value="<%=needbutton %>" onclick="if(this.checked){this.value='1';}else{this.value='';}"/><%=SystemEnv.getHtmlLabelName(22928,user.getLanguage())%>
								&nbsp;
							</td>
							<td class="field" style='padding-left:4px'>
								<%=SystemEnv.getHtmlLabelName(22929,user.getLanguage())%>:
								<INPUT class="inputstyle"
									title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
									style="WIDTH: 24px" name="picturewordcount_<%=eid %>"
									value="<%=picturewordcount %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
									ondragenter="return false"
									style="ime-mode:Disabled"
									>
							</td>
						</TR>
						<TR>
							<TD class="LINE" colSpan="2"></TD>
						</TR>
						<TR>
							<td class="field" style='padding-left:8px' >
								<BUTTON type='button' class=btnSetting id=BacoAddFavorite title="<%=SystemEnv.getHtmlLabelName(22922,user.getLanguage())%>" 
									onclick="window.showModalDialog('/page/element/Picture/SettingBrowser.jsp?picturetype=2&eid=<%=eid%>')" >
								</BUTTON>
								<a href="javascript:void(0);" title="<%=SystemEnv.getHtmlLabelName(22922,user.getLanguage())%>" onclick="window.showModalDialog('/page/element/Picture/SettingBrowser.jsp?picturetype=2&eid=<%=eid%>');"><%=SystemEnv.getHtmlLabelName(22923,user.getLanguage()) %></a>
							</td>
							<td class="field"></td>
						</TR>
					</TBODY>
				</TABLE>
			</TD>
		</TR>
		<TR  style="display:<%if(pictureShowType.equals("2")){ %><%}else{ %>none<%} %>">
			<TD class="LINE" colSpan="2"></TD>
		</TR>
		
	</TABLE>
</form>
