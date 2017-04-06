<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
int formid = Util.getIntValue(request.getParameter("formid"), 0);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int ajax = Util.getIntValue(request.getParameter("ajax"), 0);
int design = Util.getIntValue(request.getParameter("design"), 0);
int viewtypeall = 0;
int vtapprove = 0;
int vtrealize = 0;
int vtforward = 0;
int vtpostil = 0;
int vtrecipient = 0;
int vtreject = 0;
int vtsuperintend = 0;
int vtover = 0;
int vtintervenor=0;
int viewdescall = 0;
int vdcomments = 0;
int vddeptname = 0;
int vdoperator = 0;
int vddate = 0;
int vdtime = 0;
int showtype = 0;
int stnull = 0;
int vsigndoc = 0;
int vsignworkflow = 0;
int vsignupload = 0;
rs.execute("select * from workflow_flownode where nodeid="+nodeid+" and workflowid="+wfid);
if(rs.next()){
	viewtypeall = Util.getIntValue(rs.getString("viewtypeall"), 0);
	vtapprove = Util.getIntValue(rs.getString("vtapprove"), 0);
	vtrealize = Util.getIntValue(rs.getString("vtrealize"), 0);
	vtforward = Util.getIntValue(rs.getString("vtforward"), 0);
	vtpostil = Util.getIntValue(rs.getString("vtpostil"), 0);
	vtrecipient = Util.getIntValue(rs.getString("vtrecipient"), 0);
	vtreject = Util.getIntValue(rs.getString("vtreject"), 0);
	vtsuperintend = Util.getIntValue(rs.getString("vtsuperintend"), 0);
	vtover = Util.getIntValue(rs.getString("vtover"), 0);
    vtintervenor = Util.getIntValue(rs.getString("vtintervenor"), 0);
	viewdescall = Util.getIntValue(rs.getString("viewdescall"), 0);
	vdcomments = Util.getIntValue(rs.getString("vdcomments"), 0);
	vddeptname = Util.getIntValue(rs.getString("vddeptname"), 0);
	vdoperator = Util.getIntValue(rs.getString("vdoperator"), 0);
	vddate = Util.getIntValue(rs.getString("vddate"), 0);
	vdtime = Util.getIntValue(rs.getString("vdtime"), 0);
	showtype = Util.getIntValue(rs.getString("showtype"), 0);
	stnull = Util.getIntValue(rs.getString("stnull"), 0);
	vsigndoc = Util.getIntValue(rs.getString("vsigndoc"), 0);
	vsignworkflow = Util.getIntValue(rs.getString("vsignworkflow"), 0);
	vsignupload = Util.getIntValue(rs.getString("vsignupload"), 0);
}
int showhtmlid = 0;
String showhtmlname = "";
int printhtmlid = 0;
String printhtmlname = "";
int modbieid = 0;
String modbiename = "";
rs.execute("select * from workflow_nodehtmllayout where nodeid="+nodeid+" and workflowid="+wfid);
while(rs.next()){
	int type_tmp = Util.getIntValue(rs.getString("type"), 0);
	int id_tmp = Util.getIntValue(rs.getString("id"), 0);
	String layoutname_tmp = Util.null2String(rs.getString("layoutname"));
	if(type_tmp == 0){//显示模板
		showhtmlid = id_tmp;
		showhtmlname = layoutname_tmp;
	}else if(type_tmp == 1){//打印模板
		printhtmlid = id_tmp;
		printhtmlname = layoutname_tmp;
	}else if(type_tmp == 2) { //Mobile模板
		modbieid = id_tmp;
		modbiename = layoutname_tmp;
	}
}
    boolean indmouldtype = true;
    if (isbill==1) {
        rs.executeSql("select indmouldtype from workflow_billfunctionlist where billid=" + formid);
        if (rs.next()) {
            indmouldtype = Util.null2String(rs.getString("indmouldtype")).equals("1") ? true : false;
        }
    }
boolean isHaveMessager=Prop.getPropValue("Mobile","IsUseMobileHtmlLayout").equalsIgnoreCase("1");
%>
<table class="viewform">
	<COLGROUP>
	<COL width="20%">
	<COL width="80%">
	<TR height="10">
		<TD colSpan=2></TD>
	</TR>
	<TR class="Title">
		<Th><%=SystemEnv.getHtmlLabelName(23682,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage())%></Th>
		<td align="right">
		<%if(ajax==1){%>
			<a href="javascript:nodefieldbatchset('<%=nodeid%>','<%=ajax%>')"><%=SystemEnv.getHtmlLabelName(23689,user.getLanguage())%></a>
		<%}else{%>
			<a href="/workflow/workflow/edithtmlnodefield.jsp?nodeid=<%=nodeid%>&ajax=<%=ajax%>&design=<%=design%>&wfid=<%=wfid%>"><%=SystemEnv.getHtmlLabelName(23689,user.getLanguage())%></a>
		<%}%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</TR>
	<TR class="Spacing" style="height:1px;"><TD class="Line1" colSpan=2></TD></TR>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%></td>
		<td class=field>
			<button type="button"  class=AddDoc onclick="onShowBrowser4html('<%=formid%>','<%=nodeid%>','<%=isbill%>','0')" <%if(!indmouldtype){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
			<button type="button"  class=AddDoc onclick="openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?iscreate=1&formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=0&isbill=<%=isbill%>&layouttype=0&modeid=0&ajax=<%=ajax%>')" <%if(!indmouldtype){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
			<span id="showhtmlspan"><a href="#" onclick="openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=0&isbill=<%=isbill%>&layouttype=0&modeid=<%=showhtmlid%>&ajax=<%=ajax%>')"><%=showhtmlname%></a></span>
			<span><%=SystemEnv.getHtmlLabelName(27966,user.getLanguage())%><button class="Browser" onclick="onShowNodes4html('<%=wfid%>','<%=nodeid %>','syncNodes','syncNodesSpan')"></button><input id="syncNodes" name="syncNodes" type="hidden" value=""><span id="syncNodesSpan"></span></span>
			<input type="hidden" id="showhtmlid" name="showhtmlid" value="<%=showhtmlid%>">
			<input type="hidden" id="showhtmlname" name="showhtmlname" value="<%=showhtmlname%>">
			<input type="hidden" id="showhtmlisform" name="showhtmlisform" value="">
		</td>
	</tr>
	<%if(isHaveMessager){%>
	<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
	<tr>
		<td>Mobile<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%></td>
		<td class=field>
			<button type="button"  class=AddDoc onclick="onShowBrowser5html('<%=formid%>','<%=nodeid%>','<%=isbill%>','2')" <%if(!indmouldtype){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
			<button type="button"  class=AddDoc onclick="openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?iscreate=1&formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=0&isbill=<%=isbill%>&layouttype=2&modeid=0&ajax=<%=ajax%>')" <%if(!indmouldtype){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
			<span id="mobilehtmlspan"><a href="#" onclick="openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=0&isbill=<%=isbill%>&layouttype=2&modeid=<%=modbieid%>&ajax=<%=ajax%>')"><%=modbiename%></a></span>
			<span><%=SystemEnv.getHtmlLabelName(27966,user.getLanguage())%><button class="Browser" onclick="onShowNodes4html('<%=wfid%>','<%=nodeid %>','printsyncNodes','printsyncNodesSpan')"></button><input name="printsyncNodes" id="printsyncNodes" value="" type="hidden"><span id="printsyncNodesSpan"></span></span>
			<input type="hidden" id="mobileid" name="mobilehtmlid" value="<%=modbieid%>">
			<input type="hidden" id="mobilename" name="mobilehtmlname" value="<%=modbiename%>">
			<input type="hidden" id="mobilehtmlisform" name="mobilehtmlisform" value="">
		</td>
	</tr>
	<%}%>
	<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>  
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></td>
		<td class=field>
			<button type="button"  class=AddDoc onclick="onShowBrowser4html('<%=formid%>','<%=nodeid%>','<%=isbill%>','1')"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
			<button type="button"  class=AddDoc onclick="openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?iscreate=1&formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=0&isbill=<%=isbill%>&layouttype=1&modeid=0&ajax=<%=ajax%>')"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
			<span id="printhtmlspan"><a href="#" onclick="openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=0&isbill=<%=isbill%>&layouttype=1&modeid=<%=printhtmlid%>&ajax=<%=ajax%>')"><%=printhtmlname%></a></span>
			<input type="hidden" id="printhtmlid" name="printhtmlid" value="<%=printhtmlid%>">
			<input type="hidden" id="printhtmlname" name="printhtmlname" value="<%=printhtmlname%>">
			<input type="hidden" id="printhtmlisform" name="printhtmlisform" value="">
		</td>
	</tr>
	<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>  
	<TR class="Title"><Th><%=SystemEnv.getHtmlLabelName(21652,user.getLanguage())%></Th></TR>
	<TR class="Spacing" style="height:1px;"><TD class="Line1" colSpan=2></TD></TR>
	<TR class="Title">
	<Th><%=SystemEnv.getHtmlLabelName(17139,user.getLanguage())%></Th>
	<TD><input type="checkbox" name="viewtype_all2" value="1" onclick="selectviewall2('viewtype',this.checked)" <%if(viewtypeall==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></TD>
	</TR>
	<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
	<TR>
	<Td colspan="2">
		<table class="viewform" id="viewtypetab2">
			<tr>
			<TD width="50%"><input type="checkbox" name="viewtype_approve2" value="1" <%if(vtapprove==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></TD>
			<TD width="50%"><input type="checkbox" name="viewtype_realize2" value="1" <%if(vtrealize==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></TD>
			</tr>
			<tr>
			<TD width="50%"><input type="checkbox" name="viewtype_forward2" value="1" <%if(vtforward==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></TD>
			<TD width="50%"><input type="checkbox" name="viewtype_postil2" value="1" <%if(vtpostil==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%></TD>
			</tr>
			<tr>
			<TD width="50%"><input type="checkbox" name="viewtype_recipient2" value="1" <%if(vtrecipient==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%></TD>
			<TD width="50%"><input type="checkbox" name="viewtype_reject2" value="1" <%if(vtreject==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></TD>
			</tr>
			<tr>
			<TD width="50%"><input type="checkbox" name="viewtype_superintend2" value="1" <%if(vtsuperintend==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21223,user.getLanguage())%></TD>
			<TD width="50%"><input type="checkbox" name="viewtype_over2" value="1" <%if(vtover==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18360,user.getLanguage())%></TD>
			</tr>
            <tr>
			<TD width="50%"><input type="checkbox" name="viewtype_intervenor2" value="1" <%if(vtintervenor==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%></TD>
			</tr>
		</table>
	</Td>
	</TR>
	<TR class="Title">
	<Th><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></Th>
	<TD><input type="checkbox" name="viewdesc_all2" value="1" onclick="selectviewall2('viewdesc',this.checked)" <%if(viewdescall==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></TD>
	</TR>
	<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
	<TR>
	<Td colspan="2">
		<table class="viewform" id="viewdesctab2">
			<tr>
			<TD width="50%"><input type="checkbox" name="viewdesc_comments2" value="1" <%if(vdcomments==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21662,user.getLanguage())%></TD>
			<TD width="50%"><input type="checkbox" name="viewdesc_deptname2" value="1" <%if(vddeptname==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></TD>
			</tr>
			<tr>
			<TD width="50%"><input type="checkbox" name="viewdesc_operator2" value="1" <%if(vdoperator==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></TD>
			<TD width="50%"><input type="checkbox" name="viewdesc_date2" value="1" <%if(vddate==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21663,user.getLanguage())%></TD>
			</tr>
			<tr>
			<TD width="50%"><input type="checkbox" name="viewdesc_time2" value="1" <%if(vdtime==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></TD>
            <TD width="50%"><input type="checkbox" name="viewdesc_signdoc2" value="1" <%if(vsigndoc==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
            </tr>
            <tr>
            <TD width="50%"><input type="checkbox" name="viewdesc_signworkflow2" value="1" <%if(vsignworkflow==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
            <TD width="50%"><input type="checkbox" name="viewdesc_signupload2" value="1" <%if(vsignupload==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TD>    
            </tr>
		</table>
	</Td>
	</TR>
	<TR class="Title">
	<Th><%=SystemEnv.getHtmlLabelName(21653,user.getLanguage())%></Th>
	<TD>
	<table class="viewform" id="viewmodetab2">
			<tr>
			<TD width="37%">
				<select class=inputstyle  name="showtype2" >
				<option value="0" <%if(showtype!=1){%> selected <%}%>><STRONG><%=SystemEnv.getHtmlLabelName(21654,user.getLanguage())%></strong>
				<option value="1" <%if(showtype==1){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21655,user.getLanguage())%></strong>
				</select>
			</TD>
			<TD width="63%"><input type="checkbox" name="showtype_null2" value="1" <%if(stnull==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(21678,user.getLanguage())%></TD>
			</tr>
	 </table>
	</TD>
	</TR>
	<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>  
</table>