<%@ include file="/page/element/settingCommon.jsp"%>
<%@ include file ="common.jsp" %>
<%@page import="java.util.ArrayList;"%>


		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></TD>
			<!--ÏÔÊ¾ÉèÖÃ-->
			<TD class="field">
				<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
				<INPUT class="inputstyle"
					title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
					style="WIDTH: 24px" name="height_<%=eid %>"
					value="<%=valueList.get(nameList.indexOf("height")) %> " onkeypress="ItemCount_KeyPress(event)" />
			</TD>
		</TR>
		<TR vAlign="top">
			<TD class="line" colSpan="2"></TD>
		</TR>
	</TABLE>
</form>