<jsp:useBean id="dnc" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<%@ include file="/page/element/settingCommon.jsp"%>
<%@ include file="common.jsp"%>
<%@page import="java.util.ArrayList;"%>
<%
	String ftitle = (String)valueList.get(nameList.indexOf("ftitle"));
	String ftype = (String)valueList.get(nameList.indexOf("ftype"));
	String flevel = (String)valueList.get(nameList.indexOf("flevel"));
	String fdate = (String)valueList.get(nameList.indexOf("fdate"));	
	String wordcount = (String)valueList.get(nameList.indexOf("wordcount"));
%>


			<TR vAlign=top>
				<TD>
					&nbsp;<%=SystemEnv.getHtmlLabelName(19495,user.getLanguage())%>
				</TD>
				<!--ÏÔÊ¾×Ö¶Î-->
				<TD class=field>
				
					<INPUT type=checkbox <%if("7".equals(ftitle)){ %>checked<%} %> value="<%=ftitle %>" name=_ftitle_<%=eid%> onclick="if(this.checked){this.value='7';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(19524,user.getLanguage())%>:
					<INPUT class=inputstyle title=<%=SystemEnv.getHtmlLabelName(19524,user.getLanguage())%> style="WIDTH: 24px" value="<%=wordcount %>" name="_wordcount_<%=eid%>" basefield="7" onkeypress="ItemCount_KeyPress(event)">
					<BR>
					<INPUT type=checkbox <%if("8".equals(ftype)){ %>checked<%} %> value="<%=ftype %>" name="_ftype_<%=eid%>" onclick="if(this.checked){this.value='8';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%>
					<BR>
					<INPUT type=checkbox <%if("9".equals(flevel)){ %>checked<%} %> value="<%=flevel %>" name="_flevel_<%=eid%>" onclick="if(this.checked){this.value='9';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(18178,user.getLanguage())%>
					<BR>
					<INPUT type=checkbox <%if("10".equals(fdate)){ %>checked<%} %> value="<%=fdate %>" name="_fdate_<%=eid%>" onclick="if(this.checked){this.value='10';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(24951,user.getLanguage())%>
					<BR>
					
				</TD>
			</TR>
			<TR vAlign=top>
				<TD class=line colSpan=2></TD>
			</TR>
			
		</TBODY>
	</TABLE>
</form>