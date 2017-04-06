<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/page/element/settingCommon.jsp"%>
<%@ include file="common.jsp"%>
<%@page import="java.util.ArrayList;"%>
<%
String weathersrc = (String)valueList.get(nameList.indexOf("weathersrc"));
String autoScroll= (String)valueList.get(nameList.indexOf("autoScroll"));
String width= (String)valueList.get(nameList.indexOf("width"));
%>

		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(15246,user.getLanguage())%>
			</TD>
			<!--显示设置-->
			<TD class="field">
				<input name="weathersrc_<%=eid%>" class="InputStyle" value=<%=weathersrc %>>
				&nbsp;<img src='/images/icon.gif' title='<%=SystemEnv.getHtmlLabelName(24956,user.getLanguage()) %>' class='vtip'/><br>
				<%=SystemEnv.getHtmlLabelName(25899,user.getLanguage())%>
			</TD>
		</TR>
		<TR>
			<TD class="LINE" colSpan="2"></TD>
		</TR>
		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(24548,user.getLanguage())%>
			</TD>
			<!--显示设置-->
			<TD class="field">
			    <input type="radio" name="autoScroll_<%=eid%>" value="1" <%if(autoScroll.equals("1")){%>checked=checked<%} %>><%=SystemEnv.getHtmlLabelName(24598,user.getLanguage())%>
			    <input type="radio" name="autoScroll_<%=eid%>" value="0" <%if(autoScroll.equals("0")){%>checked=checked<%} %>><%=SystemEnv.getHtmlLabelName(24599,user.getLanguage())%>
				&nbsp;
			</TD>
		</TR>
		<TR>
			<TD class="LINE" colSpan="2"></TD>
		</TR>
		<TR vAlign="top">
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(24561,user.getLanguage())%>
			</TD>
			<!--显示设置-->
			<TD class="field">
			    <input type="text"  class="InputStyle" name="width_<%=eid%>" onkeypress="ItemCount_KeyPress(event)" value="<%=width%>">
				&nbsp;
			</TD>
		</TR>
		<TR>
			<TD class="LINE" colSpan="2"></TD>
		</TR>
	</TABLE>
</form>
