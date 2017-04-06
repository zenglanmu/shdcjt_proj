<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 

.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}

.vis1	{ visibility:"visible" }
.vis2	{ visibility:"hidden" }
.vis3   { display:"" }
.vis4   { display:"none" }
</STYLE>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%
session.setAttribute("relaterequest", "new");
int canCreateHistoryWorktask = Util.getIntValue(BaseBean.getPropValue("worktask", "canCreateHistoryWorktask"), 1);
int isRefash = Util.getIntValue(request.getParameter("isRefash"), 0);
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
String worktaskName = "";
String hasCanCreateTasks = "false";

WTRequestManager wtRequestManager = new WTRequestManager(wtid);
wtRequestManager.setLanguageID(user.getLanguage());
wtRequestManager.setUserID(user.getUID());
Hashtable canCreateTasks_hs = wtRequestManager.getCanCreateTasks(false);
hasCanCreateTasks = (String)canCreateTasks_hs.get("hasCanCreateTasks");
if(!"true".equals(hasCanCreateTasks)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
worktaskName = (String)canCreateTasks_hs.get("tasks_"+wtid);
String tasksSelectStr = (String)canCreateTasks_hs.get("tasksSelectStr");

Hashtable ret_hs_1 = wtRequestManager.getCreateTemplateFieldInfo();
ArrayList textheightList = (ArrayList)ret_hs_1.get("textheightList");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList fieldnameList = (ArrayList)ret_hs_1.get("fieldnameList");
ArrayList crmnameList = (ArrayList)ret_hs_1.get("crmnameList");
ArrayList ismandList = (ArrayList)ret_hs_1.get("ismandList");
ArrayList fieldhtmltypeList = (ArrayList)ret_hs_1.get("fieldhtmltypeList");
ArrayList typeList = (ArrayList)ret_hs_1.get("typeList");
ArrayList iseditList = (ArrayList)ret_hs_1.get("iseditList");
ArrayList defaultvalueList = (ArrayList)ret_hs_1.get("defaultvalueList");
ArrayList defaultvaluecnList = (ArrayList)ret_hs_1.get("defaultvaluecnList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");

//提醒设置
int remindtype = 0;
int beforestart = 0;
int beforestarttime = 0;
int beforestarttype = 0;
int beforestartper = 0;
int beforeend = 0;
int beforeendtime = 0;
int beforeendtype = 0;
int beforeendper = 0;
int annexmaincategory = 0;
int annexsubcategory = 0;
int annexseccategory = 0;
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
	annexmaincategory = Util.getIntValue(rs.getString("annexmaincategory"), 0);
	annexsubcategory = Util.getIntValue(rs.getString("annexsubcategory"), 0);
	annexseccategory = Util.getIntValue(rs.getString("annexseccategory"), 0);
}

int maxUploadImageSize = 5;
maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexseccategory), 5);
if(maxUploadImageSize<=0){
	maxUploadImageSize = 5;
}

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

String checkStr = "";
%>
<HTML><HEAD>
<title><%=Util.toScreen(worktaskName, user.getLanguage())%></title>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver.js"></script>
<script language=javascript src="/js/xmlextras.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
</HEAD>
<%@ include file="/cowork/uploader.jsp" %>
<%
String needfav ="1";
String needhelp ="";
String titlename = SystemEnv.getHtmlLabelName(82, user.getLanguage())+SystemEnv.getHtmlLabelName(64, user.getLanguage())+": "+worktaskName;
String imagefilename = "/images/hdMaintenance.gif";
%>
<BODY id="taskbody">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javaScript:OnSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<form name="taskform" method="post" action="AddWorktask.jsp" enctype="multipart/form-data">
<input type="hidden" name="wtid" id="wtid" value="<%=wtid%>">
<input type="hidden" name="operationType">
<input type="hidden" id="isCreate" name="isCreate" value="1">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="functionPage" name="functionPage" value="AddWorktask.jsp" >
<input type="hidden" id="isRefash" name="isRefash" value="<%=isRefash%>" >
<input type="hidden" id="istemplate" name="istemplate" value="1" >
<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
	<tr>
		<td height="10" colspan="3">
			<br>
			<div align="center">
				<font style="font-size:14pt;FONT-WEIGHT: bold"><%=worktaskName%></font>
			</div>
			<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
			</div>
			</td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
		<TABLE class="Shadow">
		<tr>
			<td valign="top">
			<!--table class="ViewForm" style="border:1px solid #FF0000"-->
			<table class="ViewForm">
			<colgroup>
			<col width="20%">
			<col width="80%">
			<tr style="height: 1px;"><td class=Line2 colSpan=2></td></tr>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(18177, user.getLanguage())%></td>
				<td class="Field"><%=tasksSelectStr%></td>
			</tr>
			<tr style="height: 1px;"><td class=Line2 colSpan=2></td></tr>
			<%
				String needcheckField = "";
				String checkorField = "";
				for(int i=0; i<idList.size(); i++){
					int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
					int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
					String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
					String crmname_tmp = Util.null2String((String)crmnameList.get(i));
					String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
					String type_tmp = Util.null2String((String)typeList.get(i));
					int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
					int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
					String defaultvalue_tmp = Util.null2String((String)defaultvalueList.get(i));
					String defaultvaluecn_tmp = Util.null2String((String)defaultvaluecnList.get(i));
					String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
					String sHtml = "";
					if(ismand_tmp == 1 && !"4".equals(fieldhtmltype_tmp)){
						checkStr += (",field" + fieldid_tmp + "_0");
					}
					if("plandays".equalsIgnoreCase(fieldname_tmp)){
						if("".equals(defaultvalue_tmp.trim())){
							defaultvalue_tmp = "0";
							defaultvaluecn_tmp = "0";
						}
					}else if("needcheck".equalsIgnoreCase(fieldname_tmp)){
						needcheckField = "field"+fieldid_tmp+"_";
					}else if("checkor".equalsIgnoreCase(fieldname_tmp)){
						checkorField = "field"+fieldid_tmp+"_";
					}
					sHtml = wtRequestManager.getCellHtml(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, isedit_tmp, ismand_tmp, defaultvalue_tmp, defaultvaluecn_tmp);
					out.println("<tr><td>"+crmname_tmp+"</td><td class=\"field\">"+sHtml+"</td></tr>");
					out.println("<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>");
				}
			%>
			<TR>
				<TD><%=SystemEnv.getHtmlLabelName(18713, user.getLanguage())%></TD>
				<TD class="Field">
					<INPUT type="radio" value="0" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 0) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
					<INPUT type="radio" value="1" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 1) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
					<INPUT type="radio" value="2" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 2) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
				</TD>
			</TR>
			<TR style='height: 1px;'>
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<!--开始前提醒-->
			<TR id="startTime" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></TD>
				<TD class="Field">
					<INPUT type="checkbox" name="beforestart" value="1" <% if(beforestart == 1) { %>checked<% } %>>
						<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforestarttime" size=5 onKeyPress="ItemCount_KeyPress_self(event)" value="<%= beforestarttime%>" onChange="document.all('beforestart').checked=true">
						<select name="beforestarttype" id="beforestarttype" onChange="onChangeStartTimeType()" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
							<option value="0" <%if(beforestarttype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforestarttype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforestarttype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
				</TD>
			</TR>
			<TR id="startTimeLine" style="height: 1px;display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<TR id="startTime2" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></TD>
				<TD class="Field">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforestartper"  size=5 onKeyPress="ItemCount_KeyPress_self(event)" value="<%=beforestartper%>">
					<span id="beforestarttypespan" name="beforestarttypespan"><%=startTimeType%></span>
				</TD>
			</TR>
			<TR id="startTimeLine2" style="height: 1px;display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<!--结束前提醒-->
			<TR id="endTime" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></TD>
				<TD class="Field">
					<INPUT type="checkbox" name="beforeend" value="1" <% if(beforeend == 1) { %>checked<% } %>>
						<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforeendtime" size=5 onKeyPress="ItemCount_KeyPress_self(event)" value="<%= beforeendtime%>"  onChange="document.all('beforeend').checked=true">
						<select name="beforeendtype" id="beforeendtype" onChange="onChangeEndTimeType()" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
							<option value="0" <%if(beforeendtype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforeendtype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforeendtype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
				</TD>
			</TR>
			<TR id="endTimeLine" style="height: 1px;display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<TR id="endTime2" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></TD>
				<TD class="Field">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforeendper"  size=5 onKeyPress="ItemCount_KeyPress_self(event)" value="<%=beforeendper%>">
					<span id="beforeendtypespan" name="beforeendtypespan"><%=endTimeType%></span>
				</TD>
			</TR>
			<TR id="endTimeLine2" style="height: 1px;display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<TR>
				<TD colspan="2">
				<br>
											<TABLE width="100%">
											<COLGROUP> 
												<COL width="20%">
												<COL width="80%"> 
											<TBODY>
											<TR class=title> 
									        	<TH colspan=2><%=SystemEnv.getHtmlLabelName(18221,user.getLanguage())%></TH>
											</TR>
											<TR class=spacing style='height: 1px;'> 
									  			<TD class=line1 colSpan=2></TD>
											</TR>
											<!--================== 定期模式 ==================-->  
											<TR> 
												<TD><%=SystemEnv.getHtmlLabelName(18221, user.getLanguage())%></TD>
												<TD class=Field> 										   
											    	<SELECT id="wakemode" name="wakemode" onchange="showFre(this.value)">
											       		<OPTION value="9" ><%=SystemEnv.getHtmlLabelName(18223,user.getLanguage())%></OPTION><!--不定期建立计划-->
														<OPTION value="3" ><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION><!--天-->
														<OPTION value="0" ><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></OPTION><!--周-->
														<OPTION value="1" ><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></OPTION><!--月-->
														<OPTION value="4" ><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18280,user.getLanguage())%></OPTION><!--季-->
														<OPTION value="2" ><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></OPTION><!--年-->
													</SELECT>
													<%
														String a="vis4";
												  		String b="vis4";
												  		String c="vis4";
												  		String d="vis4";
												  		String e="vis4";
													%>
													&nbsp;&nbsp;&nbsp;
													<!--================== 天 ==================-->
													<SPAN id="show_3" class="<%=d%>" >
														<%=SystemEnv.getHtmlLabelName(539,user.getLanguage())%>
														&nbsp;
														<SELECT name="daytime">
														<%
														for(int i = 0; i < 24; i++){
															out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" >"+Util.add0(i, 2)+":00</OPTION>");
														}
														%>
													  	</SELECT>
													  	<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
													</SPAN>
													<!--================== 周 ==================-->
													<SPAN id="show_0" class="<%=a%>" ><%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%>																												
														<SELECT name="fer_0">
											 				<OPTION value="1" ><%=SystemEnv.getHtmlLabelName(16100, user.getLanguage())%></OPTION>
											 				<OPTION value="2" ><%=SystemEnv.getHtmlLabelName(16101, user.getLanguage())%></OPTION>
											 				<OPTION value="3" ><%=SystemEnv.getHtmlLabelName(16102, user.getLanguage())%></OPTION>
											 				<OPTION value="4" ><%=SystemEnv.getHtmlLabelName(16103, user.getLanguage())%></OPTION>
											 				<OPTION value="5" ><%=SystemEnv.getHtmlLabelName(16104, user.getLanguage())%></OPTION>
											 				<OPTION value="6" ><%=SystemEnv.getHtmlLabelName(16105, user.getLanguage())%></OPTION>
											 				<OPTION value="7" ><%=SystemEnv.getHtmlLabelName(16106, user.getLanguage())%></OPTION>											 				
														</SELECT>														
														&nbsp;
														<SELECT name="weektime">
														<%
														for(int i = 0; i < 24; i++){
															out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" >"+Util.add0(i, 2)+":00</OPTION>");
														}
														%>
													  	</SELECT>
													  	<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
													</SPAN>
													<!--================== 月 ==================-->
													<SPAN id="show_1" class="<%=b%>">
														<%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%>
														<SELECT name="monthtype">
															<OPTION value="0" ><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
															<OPTION value="1" ><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
														</SELECT>														
														<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
														<SELECT name="fer_1">
														<%
															for(int i = 1; i <= 31; i++){
																out.println("<OPTION value=\""+i+"\" >"+i+"</OPTION>");
															}
														%>
														</SELECT>
														<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
														&nbsp;
														<SELECT name="monthtime">
														<%
														for(int i = 0; i < 24; i++){
															out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" >"+Util.add0(i, 2)+":00</OPTION>");
														}
														%>
													  	</SELECT>
														<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
													</SPAN>
													<!--================== 季 ==================-->
													<SPAN id="show_4" class="<%=e%>">
														<%=SystemEnv.getHtmlLabelName(22266,user.getLanguage())%>
														<SELECT name="fer_4">
													 	<%
													 		for(int i = 1; i <= 3; i++){
													 			out.println("<OPTION value=\""+Util.add0(i, 2)+"\" >"+Util.add0(i, 2)+"</OPTION>");
															}
														%>
														</SELECT>
														<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
														<SELECT name="seasontype">														
															<OPTION value="0" ><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
															<OPTION value="1" ><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
														</SELECT>														
														<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
														<SELECT name="fres">
														<%
															for (int i = 1; i <= 31; i++) {
																out.println("<OPTION value=\""+i+"\" >"+i+"</OPTION>");
															}
														%>
														</SELECT>
														<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
														&nbsp;
														<SELECT name="seasontime">
														<%
														for(int i = 0; i < 24; i++){
															out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" >"+Util.add0(i, 2)+":00</OPTION>");
														}
														%>
													  	</SELECT>
														<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
													</SPAN>
													<!--================== 年 ==================-->
													<SPAN id="show_2" class="<%=c%>"><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%>
														<SELECT name="fer_2">
													 	<%
													 		for(int i = 1; i <= 12; i++){
													 			out.println("<OPTION value=\""+Util.add0(i, 2)+"\" >"+Util.add0(i, 2)+"</OPTION>");
															}
														%>
														</SELECT>
														<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
														<SELECT name="yeartype">														
															<OPTION value="0" ><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
															<OPTION value="1" ><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
														</SELECT>														
														<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
														<SELECT name="frey">
														<%
															for (int i = 1; i <= 31; i++) {
																out.println("<OPTION value=\""+i+"\" >"+i+"</OPTION>");
															}
														%>
														</SELECT>
														<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
														&nbsp;
														<SELECT name="yeartime">
														<%
														for(int i = 0; i < 24; i++){
															out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" >"+Util.add0(i, 2)+":00</OPTION>");
														}
														%>
													  	</SELECT>
													  	<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
													</SPAN>
												</TD>
											</TR>
											<TR style='height: 1px;'><TD class="Line2" colSpan="2"></TD></TR>
											<TR>
												<TD colspan=2>
													<DIV id="generateSet" name="generateSet" class="vis4">
													<TABLE width="100%">
														<COLGROUP> 
															<COL width="20%">
															<COL width="80%"> 
														<TBODY>
														<!--================ 持续时间  ================-->	
														<TR>          
															<TD>
																<%=SystemEnv.getHtmlLabelName(19798,user.getLanguage())%>
															</TD>
															<TD class="Field">
																<INPUT type="text" id="times" name="times" size=5 maxlength="4" class=inputStyle value="" onKeyPress="ItemCount_KeyPress_self(event)">
																<SPAN id="timesSpan" name="timesSpan">
																</SPAN>
																<SELECT class="inputStyle" name="timetype" id="timetype">									            
												            		<OPTION value="1" ><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION>
												            		<OPTION value="2" ><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></OPTION>
												            		<OPTION value="3" ><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></OPTION>
												            	</SELECT>	
															</TD>
														</TR>
														<TR style='height: 1px;'><TD class="Line2" colSpan="2"></TD></TR>
														<!--================ 有效期  ================-->	
														<TR>          
															<TD>
																<%=SystemEnv.getHtmlLabelName(15030,user.getLanguage())%>
															</TD>
															<TD class="Field">
																<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>
																<BUTTON  type="button" class="Calendar" id="selectBeginDate" onclick="onSearchWFDate('beginDateSpan', 'wakebegindate')"></BUTTON> 
																<SPAN id="beginDateSpan"></SPAN> 
															  	<INPUT type="hidden" name="wakebegindate" value="">  
																&nbsp;&nbsp;&nbsp;
																<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>
																<BUTTON  type="button" class="Calendar" id="selectEndDate" onclick="onSearchWFDate('endDateSpan', 'wakeenddate')"></BUTTON> 
																<SPAN id="endDateSpan"></SPAN> 
															  	<INPUT type="hidden" name="wakeenddate" value="">
																&nbsp;&nbsp;&nbsp;
																<%=SystemEnv.getHtmlLabelName(22135,user.getLanguage())%>
															</TD>
														</TR>
														<TR style='height: 1px;'><TD class="Line2" colSpan="2"></TD></TR>
														</TBODY>
													</TABLE>
													</DIV>	
												</TD>
											</TR>
											</TBODY>
										</TABLE>
					</TD>
				</TR>




			</table>
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
</form>
<script language="javascript">
function doChangeWorktask(obj){
	var selectedIndex = 0;
	var i = 0;
	var length = document.all("selectWorktask").options.length;
	for(i=0; i<length; i++){
		if("<%=wtid%>" == document.all("selectWorktask").options[i].value){
			selectedIndex = i;
		}
	}
	if(confirm("<%=SystemEnv.getHtmlLabelName(18691, user.getLanguage())%>")){
		var wtid = obj.value;
		location.href="/worktask/request/AddWorktaskTemplate.jsp?wtid="+wtid;
	}else{
		for(i=0; i<length; i++){
			document.all("selectWorktask").options[i].selected = false;
		}
		document.all("selectWorktask").options[selectedIndex].selected = true;
	}
}

function OnSave(){
	//alert(document.all("needcheck").value);
	document.all("needcheck").value += "<%=checkStr%>";
	if(check_form(document.taskform, document.all("needcheck").value) && checkWorkPlanRemind()){
		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value="savetemplate";
		showPrompt("<%=SystemEnv.getHtmlLabelName(22060, user.getLanguage())%>");
		//document.taskform.submit();
		doUpload();
		enableAllmenu;
	}else{
		document.all("needcheck").value = "wtid";
	}
}

function doUpload(){

	jQuery(".uploadfield").each(function(){
		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued != 0){ //判断是否需要上传
	     	 oUploader.startUpload(); 
	    }
	});
	doSaveAfterAccUpload();
}

function afterChooseFile(uploaddiv,totalnumFiles){

	var ismand=jQuery(uploaddiv).attr("ismand");
	var field=jQuery(uploaddiv).attr("field");
	
	if(ismand=="1"){
	   if(totalnumFiles>0)
	      jQuery("#field"+field+"span").html("");
	   else
	      jQuery("#field"+field+"span").html("<IMG align=absMiddle src='/images/BacoError.gif'>");   
	}
	
}
function doSaveAfterAccUpload(){
	var isuploaded=true;
	jQuery(".uploadfield").each(function(){
		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued != 0){ //判断上传是否完成
	     	 isuploaded=false; 
	    }
	});
	if(isuploaded){
		document.taskform.submit();
	}
}

function showPrompt(content){
     var showTableDiv  = document.getElementById('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     //message_table_Div.style.posTop=pTop;
     //message_table_Div.style.posLeft=pLeft;
     message_table_Div.style.top = pTop;
     message_table_Div.style.left = pLeft;
     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}
</script>
<script language="vbs">
sub onShowBrowser31(id,url,linkurl,type1,ismand)

	if type1= 2 or type1 = 19 then
	    spanname = "field"+id+"span"
	    inputname = "field"+id
		if type1 = 2 then
		  onFlownoShowDate spanname,inputname,ismand
        else
	      onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		if  type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		else
            if type1=135 then
			tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
			elseif type1=37 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
            elseif type1=142 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
            elseif type1=165 or type1=166 or type1=167 or type1=168 then
            index=InStr(id,"_")
            if index>0 then
            tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            else
            tmpids=uescape("?fieldid="&id&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            end if
            else
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
            end if
		end if
		if NOT isempty(id1) then
			if  type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceidss = Mid(resourceids,2,len(resourceids))
					resourceids = Mid(resourceids,2,len(resourceids))

					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					document.all("field"+id).value= resourceidss
				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if

			else
			   if  id1(0)<>""  and id1(0)<> "0"  then
                   if type1=162 then
				     ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,2,len(ids))
					document.all("field"+id).value= ids
					names = Mid(names,2,len(names))
					descs = Mid(descs,2,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1=161 then
				     name = id1(1)
					desc = id1(2)
				    document.all("field"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
			        if linkurl = "" then
						document.all("field"+id+"span").innerHtml = id1(1)
					else
						document.all("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
					end if
					document.all("field"+id).value=id1(0)

				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if
			end if
		end if
	end if
	onChangeCheckor(id)
end sub
</script>
<script language="javascript">
function onChangeCheckor(id){
	try{
		var ids = id.split("_");
		var fieldid = ids[0];
		var rowindex = ids[1];
		var fieldname1 = "field"+id;
		var fieldname2 = "<%=checkorField%>"+rowindex;
		if(fieldname1 == fieldname2){
			if(document.getElementById("<%=checkorField%>"+rowindex).value==null || document.getElementById("<%=checkorField%>"+rowindex).value==""){
				document.getElementById("<%=needcheckField%>"+rowindex).checked = false;
			}else{
				document.getElementById("<%=needcheckField%>"+rowindex).checked = true;
			}
		}
	}catch(e){}
}
function ItemCount_KeyPress_self(event){
    event = event || window.event
	if(!((event.keyCode>=48) && (event.keyCode<=57))){
		event.keyCode=0;
	}
}

function showRemindTime(obj){
	//alert(document.all("remindTime").style);
	if("0" == obj.value){
		document.all("startTime").style.display = "none";
		document.all("startTimeLine").style.display = "none";
		document.all("startTime2").style.display = "none";
		document.all("startTimeLine2").style.display = "none";
		document.all("beforestarttype").style.display = "none";
		document.all("endTime").style.display = "none";
		document.all("endTimeLine").style.display = "none";
		document.all("endTime2").style.display = "none";
		document.all("endTimeLine2").style.display = "none";
		document.all("beforeendtype").style.display = "none";
	}else{
		document.all("startTime").style.display = "";
		document.all("startTimeLine").style.display = "";
		document.all("startTime2").style.display = "";
		document.all("startTimeLine2").style.display = "";
		document.all("beforestarttype").style.display = "";
		document.all("endTime").style.display = "";
		document.all("endTimeLine").style.display = "";
		document.all("endTime2").style.display = "";
		document.all("endTimeLine2").style.display = "";
		document.all("beforeendtype").style.display = "";
	}
}

function checkWorkPlanRemind(){
	//alert(document.frmmain.remindtype);
	if(document.taskform.remindtype[0].checked == false){
		if(document.taskform.beforestart.checked || document.taskform.beforeend.checked){
			return true;
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21978, user.getLanguage())%>");
			return false;
		}
	}else{
		document.taskform.beforestart.checked = false;
		document.taskform.beforeend.checked = false;
		document.taskform.beforestarttime.value = 0;
		document.taskform.beforeendtime.value = 0;
		document.taskform.beforestartper.value = 0;
		document.taskform.beforeendper.value = 0;
		return true;
	}
}
function onChangeStartTimeType(){
	var timeTypeText = document.all("beforestarttype").options.item(document.all("beforestarttype").selectedIndex).innerText;
	document.getElementById("beforestarttypespan").innerHTML = timeTypeText;
}

function onChangeEndTimeType(){
	var timeTypeText = document.all("beforeendtype").options.item(document.all("beforeendtype").selectedIndex).innerText;
	document.getElementById("beforeendtypespan").innerHTML = timeTypeText;
}

function getnumber(date1,date2){
	//默认格式为"20030303",根据自己需要改格式和方法
	var year1 =  date1.substr(0,4);
	var year2 =  date2.substr(0,4);

	var month1 = date1.substr(5,2);
	var month2 = date2.substr(5,2);

	var day1 = date1.substr(8,2);
	var day2 = date2.substr(8,2);

	temp1 = year1+"/"+month1+"/"+day1;
	temp2 = year2+"/"+month2+"/"+day2;

	var dateaa= new Date(temp1); 
	var datebb = new Date(temp2); 
	var date = datebb.getTime() - dateaa.getTime(); 
	var time = Math.floor(date / (1000 * 60 * 60 * 24)+1);
	return time;
	//alert(time);
}
function showFre(mode){
	for(i = 0; i < 5; i++){
		document.all("show_" + i).className = "vis4";
		document.all("generateSet").className = "vis4";
	}
	if("9" != mode){
		document.all("show_" + mode).className = "vis3";
		document.all("generateSet").className = "vis3";
	}
}
//附件相关JS Start

function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        //alert('<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>');
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM><%=maxUploadImageSize%>) {
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}
  function addannexRow(accname,maxsize)
  {
    document.all(accname+'_num').value=parseInt(document.all(accname+'_num').value)+1;
    ncol = document.all(accname+'_tab').cols;
    oRow = document.all(accname+'_tab').insertRow();
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell();
      oCell.style.height=24;
      switch(j) {
        case 1:
          var oDiv = document.createElement("div");
          var sHtml = "";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 0:
          var oDiv = document.createElement("div");
          <%----- Modified by xwj for td3323 20051209  ------%>
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
}
function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=60 >";  
    document.getElementById(objName).outerHTML=outerHTML;       
    document.getElementById(objName).onchange=tempObjonchange;
}
function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}

function returnTrue(o){
	return;
}
function downloads(files){
	taskbody.onbeforeunload=null;
	document.location.href="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1";
}
 function onChangeSharetype(delspan,delid,ismand,maxUploadImageSize){
	fieldid=delid.substr(0,delid.indexOf("_"));
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
	fieldidspans=fieldid+"spans";
	fieldid=fieldid+"_1";
	 var sHtml = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange='accesoryChanage(this,"+maxUploadImageSize+")'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
	 var sHtml1 = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange=\"accesoryChanage(this,"+maxUploadImageSize+");checkinput(\'"+fieldid+"\',\'"+fieldidspan+"\')\"> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";

    if(document.all(delspan).style.visibility=='visible'){
      document.all(delspan).style.visibility='hidden';
      document.all(delid).value='0';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)+1;
    }else{
      document.all(delspan).style.visibility='visible';
      document.all(delid).value='1';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)-1;
    }
	//alert(document.all(fieldidnum).value);
	if (ismand=="1")
	  {
	if (document.all(fieldidnum).value=="0")
	  {
	    document.all("needcheck").value=document.all("needcheck").value+","+fieldid;
		document.all(fieldidspan).innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";

		document.all(fieldidspans).innerHTML=sHtml1;
	  }
	  else
	  {   if (document.all("needcheck").value.indexOf(","+fieldid)>0)
		  {
	     document.all("needcheck").value=document.all("needcheck").value.substr(0,document.all("needcheck").value.indexOf(","+fieldid));
		 document.all(fieldidspan).innerHTML="";
		 document.all(fieldidspans).innerHTML=sHtml;
		  }
	  }
	  }
  }
  //附件相关JS End
  
  function onShowBrowser3(id,url,linkurl,type1,ismand){
	if(type1==2||type1 ==19){
	    spanname = "field"+id+"span";
	    inputname = "field"+id;
		if(type1 ==2)
		  onFlownoShowDate(spanname,inputname,ismand);
        else
	      onWorkFlowShowTime(spanname,inputname,ismand);
	}else{
		if(type1!=152 && type1 !=142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170)
		{
			id1 = window.showModalDialog(url);
		}else{
            if(type1==135){
			    tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?projectids="+tmpids)
			}else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
                tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?selectedids="+tmpids);
			}else if(type1==37) {
            tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?documentids="+tmpids);
            }else if (type1==142){
            tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?receiveUnitIds="+tmpids);
            }else if( type1==165 || type1==166 || type1==167 || type1==168){
                //index=InStr(id,"_");
                index=id.indexOf("_");
	            if (index!=-1){
		            //Mid(id,1,index-1)
		            tmpids=uescape("?isdetail=1&fieldid="+substr(id,0,index-1)+"&resourceids="+document.all("field"+id).value)
		            id1 = window.showModalDialog(url+tmpids);
	            }else{
		            tmpids=uescape("?fieldid="+id+"&resourceids="+document.all("field"+id).value);
		            id1 = window.showModalDialog(url+tmpids);
	            }
            }else{
               tmpids = document.all("field"+id).value;
			   id1 = window.showModalDialog(url+"?resourceids="+tmpids);
			}
           }
		
		if(id1){
			if  (type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) 
			{
				if (id1.id!==""  && id1.id!=="0"){
					resourceids = id1.id;
					resourcename = id1.name;
					sHtml = "";
					resourceidss =resourceids.substr(1);
					resourceids = resourceids.substr(1);

					resourcename =resourcename.substr(1);
					
					ids=resourceids.split(",");
					names=resourcename.split(",");
					for(var i=0;i<ids.length;i++){
					   if(ids[i]!="")
					      sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_blank'>"+names[i]+"</a>&nbsp";
					}
					//$GetEle("field"+id+"span").innerHTML = sHtml;
					document.all("field"+id+"span").innerHTML = sHtml;
					document.all("field"+id).value= resourceidss;
				}else{
					if (ismand==0)
						document.all("field"+id+"span").innerHTML ="";
					else
						document.all("field"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>";
					document.all("field"+id).value="";
				}
			}else{
			   if  (id1.id!=""  && id1.id!="0"){
                   if (type1==162){
				     ids = id1.id;
					names = id1.name;
					descs = wuiUtil.getJsonValueByIndex(id1,2);
					sHtml = "";
					ids =ids.substr(1);
					document.all("field"+id).value= ids;
					names =names.substr(1).split(",");
					descs =descs.substr(1).split(",");
					for(var i=0;i<names.length;i++){
					   sHtml = sHtml+"<a title='"+descs[i]+"' >"+names[i]+"</a>&nbsp";
					}
					document.all("field"+id+"span").innerHTML = sHtml;
					return;
				   }
				   if (type1==161){
				     name =wuiUtil.getJsonValueByIndex(id1,1);
					 desc = wuiUtil.getJsonValueByIndex(id1,2);
				     document.all("field"+id).value=wuiUtil.getJsonValueByIndex(id1,0);
					 sHtml = "<a title='"+desc+"'>"+name+"</a>&nbsp";
					 document.all("field"+id+"span").innerHTML = sHtml;
					 return;
				   }
			        if (linkurl == "") 
						document.all("field"+id+"span").innerHTML =wuiUtil.getJsonValueByIndex(id1,1);
					else
						document.all("field"+id+"span").innerHTML = "<a href="+linkurl+id1.id+" target='_blank'>"+id1.name+"</a>";
					document.all("field"+id).value=id1.id;

				}else{
					if (ismand==0)
						document.all("field"+id+"span").innerHTML ="";
					else
						document.all("field"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>"
					
					document.all("field"+id).value=""
				}
              }  			
		}
	 }	
	onChangeCheckor(id);
}
jQuery(document).ready(function(){
	jQuery(".uploadfield").each(function(){
		var fieldid=jQuery(this).attr("field");
		bindUploaderDiv(jQuery(this),"field"+fieldid+"_1"); 
	});
	jQuery(".progressCancel").live("click",function(){
		var uploaddiv=jQuery(this).parents(".uploadfield");
		var totalnumFiles=window[uploaddiv.attr("oUploaderIndex")].getStats().files_queued;
		afterChooseFile(uploaddiv,totalnumFiles);
	});
	jQuery(".btnCancel_upload").live("click",function(){
		var uploaddiv=jQuery(this).parents(".uploadfield");
		var totalnumFiles=window[uploaddiv.attr("oUploaderIndex")].getStats().files_queued;
		afterChooseFile(uploaddiv,totalnumFiles);
	});
});   
  
  
</script>

</BODY>
</HTML>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
