<%@ include file="/page/element/settingCommon.jsp"%>
<%@ include file="common.jsp"%>
<%@page import="java.util.ArrayList;"%>
<%
String flashSrcType = (String)valueList.get(nameList.indexOf("flashSrcType"));
String flashSrc = (String)valueList.get(nameList.indexOf("flashSrc"));
String width = (String)valueList.get(nameList.indexOf("width"));
String height = (String)valueList.get(nameList.indexOf("height"));
%>


		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></TD>
			<!--显示设置-->
			<TD class="field" style='padding-left:3px'>
				<!-- <%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>: -->
				<INPUT class="inputstyle" style="display:none"
					title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
					style="WIDTH: 24px" name="width_<%=eid%>"
					value="<%=width %>" />
				
				<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
				<INPUT class="inputstyle"
					title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
					style="WIDTH: 30px" name="height_<%=eid %>"
					value="<%=height %>" onkeypress="ItemCount_KeyPress(event)" />
				&nbsp;
			</TD>
		</TR>
		<TR vAlign="top">
			<TD class="line" colSpan="2"></TD>
		</TR>
		<TR vAlign="top">
			<TD>
				&nbsp;Flash<%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%></TD>
			<!--Flash来源-->
			<TD class="field" style='padding:0px'>
				<TABLE class="viewform" width="100%">
					<col width="80" />
					<col width="*" />
					<TBODY>
						<TR>
							<TD>
								<INPUT id="flashSrcType_<%=eid%>" type="radio"
									<%if(flashSrcType.equals("1")) out.print("checked");%>
									name="flashSrcType_<%=eid%>" selecttype="1" value='1' />
								<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>
							</TD>
							<td>
								<input width="60%" name="flashSrc_<%=eid%>"
									id="flashSrc_<%=eid%>" class="filetree" type="text"
									value="<%if(flashSrcType.equals("1")) out.print(flashSrc);%>" />
							</td>
						</TR>
						<TR>
							<TD>
								<INPUT id="flashSrcType_<%=eid%>" type="radio"
									<%if(flashSrcType.equals("2")) out.print("checked");%>
									name="flashSrcType_<%=eid%>" selecttype="2" value="2" />
								URL<%=SystemEnv.getHtmlLabelName(18499,user.getLanguage())%>
								&nbsp;&nbsp;
							</TD>
							<TD>
								<input name="flashUrl_<%=eid%>"
									value="<%if(flashSrcType.equals("2")) out.print(flashSrc); %>"
									class="inputStyle" style="WIDTH:90%" onKeyPress= "CheckNum()">
							</TD>
						</TR>
					</TBODY>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD class="LINE" colSpan="2"></TD>
		</TR>
		</TBODY>
	</TABLE>
</form>
<SCRIPT LANGUAGE="JavaScript">
	$("#flashSrc_<%=eid%>").filetree();
	//不让输入单引号
		function   CheckNum() 
		{ 
			if (Window.event.keyCode==39) 
				{ 
    			window.event.keyCode=0; 
				} 
		} 
</SCRIPT>
