<%@ include file="/page/element/settingCommon.jsp"%>
<%@ include file="common.jsp"%>
<%@page import="java.util.ArrayList;"%>
<%
String width = (String)valueList.get(nameList.indexOf("width"));
String height = (String)valueList.get(nameList.indexOf("height"));
String actionpage = (String)valueList.get(nameList.indexOf("actionpage"));
String userparamname = (String)valueList.get(nameList.indexOf("userparamname"));
String userparampass = (String)valueList.get(nameList.indexOf("userparampass"));
%>

		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></TD>
			<!--显示设置-->
			<TD class="field">
				<INPUT class="inputstyle" type="hidden"
					title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
					style="WIDTH: 24px" name="width_<%=eid%>"
					value="<%=width %>" />
				<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
				<INPUT class="inputstyle"
					title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
					style="WIDTH: 24px" name="height_<%=eid %>"
					value="<%=height %>" />
			</TD>
		</TR>
		<TR vAlign="top">
			<TD class="line" colSpan="2"></TD>
		</TR>
		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(24963,user.getLanguage())%></TD>
			<!--跳转页面-->
			<TD class="field">
				<input title="<%=SystemEnv.getHtmlLabelName(24963,user.getLanguage())%>" style="width:80%;"name="actionpage_<%=eid %>" id="actionpage_<%=eid %>" class="inputstyle" type="text" value="<%=actionpage %>" />
			</TD>
		</TR>
		<TR vAlign="top">
			<TD class="line" colSpan="2"></TD>
		</TR>
		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(24463,user.getLanguage())%></TD><!-- 登录ID参数名 -->
			<!--跳转页面-->
			<TD class="field">
				<input title="<%=SystemEnv.getHtmlLabelName(22911,user.getLanguage())%>" style="width:80%;"name="userparamname_<%=eid %>" id="userparamname_<%=eid %>" class="inputstyle" type="text" value="<%=userparamname %>" />
			</TD>
		</TR>
		<TR vAlign="top">
			<TD class="line" colSpan="2"></TD>
		</TR>
		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(24464,user.getLanguage())%></TD><!-- 登录ID密码参数名 -->
			<!--跳转页面-->
			<TD class="field">
				<input title="<%=SystemEnv.getHtmlLabelName(22911,user.getLanguage())%>" style="width:80%;"name="userparampass_<%=eid %>" id="userparampass_<%=eid %>" class="inputstyle" type="text" value="<%=userparampass %>" />
			</TD>
		</TR>
		<TR vAlign="top">
			<TD class="line" colSpan="2"></TD>
		</TR>
	</TABLE>
</form>