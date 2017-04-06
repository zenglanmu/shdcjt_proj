<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<script language=javascript src="/js/weaver.js"></script>

<html>
<%
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
	int remindtype = 0;
	int beforestart = 0;
	int beforestarttime = 0;
	int beforestarttype = 0;
	int beforestartper = 0;
	int beforeend = 0;
	int beforeendtime = 0;
	int beforeendtype = 0;
	int beforeendper = 0;
	rs.execute("select * from worktask_base where id="+wtid);
	if(rs.next()){
		remindtype = Util.getIntValue(rs.getString("remindtype"), 0);
		beforestart = Util.getIntValue(rs.getString("beforestart"), 0);
		beforestarttime = Util.getIntValue(rs.getString("beforestarttime"), 0);
		beforestarttype = Util.getIntValue(rs.getString("beforestarttype"), 0);
		beforestartper = Util.getIntValue(rs.getString("beforestartper"), 0);
		beforeend = Util.getIntValue(rs.getString("beforeend"), 0);
		beforeendtime = Util.getIntValue(rs.getString("beforeendtime"), 0);
		beforeendtype = Util.getIntValue(rs.getString("beforeendtype"), 0);
		beforeendper = Util.getIntValue(rs.getString("beforeendper"), 0);
	}
	String url_pra = "remindtype="+remindtype+"&beforestart="+beforestart+"&beforestarttime="+beforestarttime+"&beforestarttype="+beforestarttype+"&beforestartper="+beforestartper+"&beforeend="+beforeend+"&beforeendtime="+beforeendtime+"&beforeendtype="+beforeendtype+"&beforeendper="+beforeendper;
	//System.out.println(url_pra);
	String startTimeType = "";
	String endTimeType = "";
	if(beforestarttype == 0){
		startTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
	}else if(beforestarttype == 1){
		startTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
	}else{
		startTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
	}
	if(beforeendtype == 0){
		endTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
	}else if(beforeendtype == 1){
		endTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
	}else{
		endTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
	}
%>

<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

</head>

<body>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveData(this),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name="frmmain" id="frmmain" method="post" action="wt_Operation.jsp">
<input type="hidden" name="src" value="" >
<input type="hidden" name="wtid" value="<%=wtid%>" >
 <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<table class="viewform">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TR class="Title"><TH colSpan=2><%=SystemEnv.getHtmlLabelName(21976, user.getLanguage())%></TH></TR>
			<TR class="Spacing" style="height:2px"><TD class="Line1" colSpan=2></TD></TR>
			<TR>
				<TD><%=SystemEnv.getHtmlLabelName(18713, user.getLanguage())%></TD>
				<TD class="Field">
					<INPUT type="radio" value="0" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 0) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
					<INPUT type="radio" value="1" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 1) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
					<INPUT type="radio" value="2" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 2) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
				</TD>
			</TR>
			<TR style="height:1px">
				<TD class="Line" colSpan="2"></TD>
			</TR>
			<!--开始前提醒-->
			<TR id="startTime" style="display:<%if(remindtype == 0) {%>none<%}%>">
				<TD><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></TD>
				<TD class="Field">
					<INPUT type="checkbox" name="beforestart" value="1" <% if(beforestart == 1) { %>checked<% } %>>
						<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforestarttime" size=5 onKeyPress="ItemCount_KeyPress_self(event)" value="<%= beforestarttime%>" onChange="document.all('beforestart').checked=true">
						<select name="beforestarttype" id="beforestarttype" onChange="onChangeStartTimeType()" style="display:<%if(remindtype == 0) {%>none<%}%>">
							<option value="0" <%if(beforestarttype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforestarttype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforestarttype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
				</TD>
			</TR>
			<TR id="startTimeLine" style="height:1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line" colSpan="2"></TD>
			</TR>
			<TR id="startTime2" style="display:<%if(remindtype == 0) {%>none<%}%>">
				<TD><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></TD>
				<TD class="Field">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforestartper"  size=5 onKeyPress="ItemCount_KeyPress_self(event)" value="<%=beforestartper%>">
					<span id="beforestarttypespan" name="beforestarttypespan"><%=startTimeType%></span>
				</TD>
			</TR>
			<TR id="startTimeLine2" style="height:1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line" colSpan="2"></TD>
			</TR>
			<!--结束前提醒-->
			<TR id="endTime" style="display:<%if(remindtype == 0) {%>none<%}%>">
				<TD><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></TD>
				<TD class="Field">
					<INPUT type="checkbox" name="beforeend" value="1" <% if(beforeend == 1) { %>checked<% } %>>
						<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforeendtime" size=5 onKeyPress="ItemCount_KeyPress_self(event)" value="<%= beforeendtime%>"  onChange="document.all('beforeend').checked=true">
						<select name="beforeendtype" id="beforeendtype" onChange="onChangeEndTimeType()" style="display:<%if(remindtype == 0) {%>none<%}%>">
							<option value="0" <%if(beforeendtype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforeendtype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforeendtype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
				</TD>
			</TR>
			<TR id="endTimeLine" style="height:1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line" colSpan="2"></TD>
			</TR>
			<TR id="endTime2" style="display:<%if(remindtype == 0) {%>none<%}%>">
				<TD><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></TD>
				<TD class="Field">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforeendper"  size=5 onKeyPress="ItemCount_KeyPress_self()" value="<%=beforeendper%>">
					<span id="beforeendtypespan" name="beforeendtypespan"><%=endTimeType%></span>
				</TD>
			</TR>
			<TR id="endTimeLine2" style="height:1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line" colSpan="2"></TD>
			</TR>
		</table>
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

</form>

<script language=javascript>

function saveData(obj){
	if(checkWorkPlanRemind()){
		frmmain.src.value="saveremind";
		frmmain.submit();
		enableAllmenu();
	}
}
function ItemCount_KeyPress_self(event){
	event = jQuery.event.fix(event);
	if(!((event.keyCode>=48) && (event.keyCode<=57))){
		event.keyCode=0;
	}
}

function showRemindTime(obj){
	//alert(document.all("remindTime").style);
	if("0" == obj.value){
		jQuery("#startTime").hide();
		jQuery("#startTimeLine").hide();
		jQuery("#startTime2").hide();
		jQuery("#startTimeLine2").hide();
		jQuery("#beforestarttype").hide();
		jQuery("#endTime").hide();
		jQuery("#endTimeLine").hide();
		jQuery("#endTime2").hide();
		jQuery("#endTimeLine2").hide();
		jQuery("#beforeendtype").hide();
	}else{
		jQuery("#startTime").show();
		jQuery("#startTimeLine").show();
		jQuery("#startTime2").show();
		jQuery("#startTimeLine2").show();
		jQuery("#beforestarttype").show();
		jQuery("#endTime").show();
		jQuery("#endTimeLine").show();
		jQuery("#endTime2").show();
		jQuery("#endTimeLine2").show();
		jQuery("#beforeendtype").show();
	}
}

function checkWorkPlanRemind(){
	//alert(document.frmmain.remindtype);
	if(document.frmmain.remindtype[0].checked == false){
		if(document.frmmain.beforestart.checked || document.frmmain.beforeend.checked){
			return true;
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21978, user.getLanguage())%>");
			return false;
		}
	}else{
		document.frmmain.beforestart.checked = false;
		document.frmmain.beforeend.checked = false;
		document.frmmain.beforestarttime.value = 0;
		document.frmmain.beforeendtime.value = 0;
		document.frmmain.beforestartper.value = 0;
		document.frmmain.beforeendper.value = 0;
		return true;
	}
}
function onChangeStartTimeType(){
	var timeTypeText = jQuery("select[name=beforestarttype] option:selected").html();
	document.getElementById("beforestarttypespan").innerHTML = timeTypeText;
}
function onChangeEndTimeType(){
	var timeTypeText = jQuery("select[name=beforeendtype] options:selected").html();
	document.getElementById("beforeendtypespan").innerHTML = timeTypeText;
}

function useSetto(){
	url=escape("/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=6&<%=url_pra%>");
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, window);
}
</script>
</body>
</html>
