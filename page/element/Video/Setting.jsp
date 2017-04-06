<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/page/element/settingCommon.jsp"%>
<%@ include file ="common.jsp" %>
<%@page import="java.util.ArrayList;"%>

			
			<TR vAlign="top">
				<TD>&nbsp;<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></TD>
				<!--显示设置-->
				<TD class="field" style='padding-left:3px'> <!-- <%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>: --><INPUT style='display:none'
					class="inputstyle" title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>" style="WIDTH: 24px"
					name="width_<%=eid%>" value="<%=valueList.get(nameList.indexOf("width")) %>"/> 
				<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:<INPUT class="inputstyle" title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
					style="WIDTH: 27px" name="height_<%=eid %>" onkeypress="ItemCount_KeyPress(event)" value="<%=valueList.get(nameList.indexOf("height")) %>" />&nbsp; 
				<input type='hidden' name= "quality_<%=eid%>" value='9'>
				
				<INPUT type="checkbox" <% if(valueList.get(nameList.indexOf("fullScreen")).equals("on")) out.print("checked"); else out.print(""); %> name="fullScreen_<%=eid%>" />
				<%=SystemEnv.getHtmlLabelName(22839,user.getLanguage())%>
				<BR />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT type="checkbox" <% if(valueList.get(nameList.indexOf("autoPlay")).equals("on")) out.print("checked"); else out.print(""); %> name="autoPlay_<%=eid%>" />
				<%=SystemEnv.getHtmlLabelName(22840,user.getLanguage())%> <BR />
				</TD>
			</TR>
			<TR vAlign="top">
				<TD class="line" colSpan="2"></TD>
			</TR>
			<TR vAlign="top">
				<TD>&nbsp;<%=SystemEnv.getHtmlLabelName(22841,user.getLanguage())%></TD>
				<!--视频来源-->
				<TD class="field" style='padding:0px'>
				<TABLE class="viewform" width="100%">
						<col width="80"/>
						<col width="*"/>
					<TBODY>
						<TR>
							<TD>
							<INPUT id="videoSrcType_<%=eid%>" type="radio"
								<%if(valueList.get(nameList.indexOf("videoSrcType")).equals("1")) out.print("checked");%> name="videoSrcType_<%=eid%>" selecttype="1" value='1' />
							<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>
							</TD>
							<td>
							<input width="60%" name="videoSrc_<%=eid%>" id="videoSrc_<%=eid%>"  class="filetree" type="text" value="<%if(valueList.get(nameList.indexOf("videoSrcType")).equals("1")) out.print(valueList.get(nameList.indexOf("videoSrc")));%>"/>
							</td>
						</TR>
						<TR>
							<TD><INPUT id="videoSrcType_<%=eid%>" type="radio"
								<%if(valueList.get(nameList.indexOf("videoSrcType")).equals("2")) out.print("checked");%> name="videoSrcType_<%=eid%>" selecttype="2" value="2" /> URL<%=SystemEnv.getHtmlLabelName(18499,user.getLanguage())%><!--文档目录-->&nbsp;&nbsp;
								</TD>
								<TD>
								<input name = "videoUrl_<%=eid%>" value="<%if(valueList.get(nameList.indexOf("videoSrcType")).equals("2")) out.print(valueList.get(nameList.indexOf("videoSrc"))); %>"  onKeyPress= "CheckNum()" class="inputStyle" style='width:90%'>
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
		$("#videoSrc_<%=eid%>").filetree();
		function   CheckNum() 
		{ 
			if (Window.event.keyCode==39) 
				{ 
    			window.event.keyCode=0; 
				} 
		} 
  	</SCRIPT>
	