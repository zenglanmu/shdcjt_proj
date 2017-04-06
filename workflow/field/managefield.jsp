<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<%
	/*
	 关于字段的数据库类型的中文表述没完成，需要另外添加标签

	 */
%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.lang.*"%>

<jsp:useBean id="FieldInfo" class="weaver.workflow.field.FieldManager"
	scope="page" />
<jsp:useBean id="FieldMainManager"
	class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="BrowserComInfo"
	class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight"
	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />


<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(684,
			user.getLanguage());
	String needfav = "1";
	String needhelp = "";

	String fieldhtmltypeForSearch = Util.null2String(request
			.getParameter("fieldhtmltypeForSearch"));
	String type = Util.null2String(request.getParameter("type"));
	String type1 = Util.null2String(request.getParameter("type1"));
	String type2 = Util.null2String(request.getParameter("type2"));
	String type3 = Util.null2String(request.getParameter("type3"));
	String fieldnameForSearch = Util.null2String(request.getParameter("fieldnameForSearch"));
	String fielddec = Util.null2String(request.getParameter("fielddec"));
	//System.out.println(fieldnameForSearch+"AAA");
	//2012-08-10 ypc 添加以下代码
	if(fieldnameForSearch.equals("undefined")){
		fieldnameForSearch="";
	}
	if(fielddec.equals("undefined")){
		fielddec="";
	}
%>
<%
	if (Util.null2String(request.getParameter("srcType")).equals(
			"detailfield")) {
%>
<script language="javascript">
     location = "managedetailfield.jsp?fieldhtmltypeForSearch=<%=fieldhtmltypeForSearch%>&type=<%=type%>&type1=<%=type1%>&fieldnameForSearch=<%=fieldnameForSearch%>&fielddec=<%=fielddec%>";    
  </script>
<%
	}
%>
<script language="javascript">
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_field_id') {
if(!document.form2.elements[i].disabled){
    document.form2.elements[i].checked=(checked==true?true:false);
}
} } }


function unselectall()
{
    if(document.form2.checkall0.checked){
	document.form2.checkall0.checked =0;
    }
}
function confirmdel() {
	len=document.form2.elements.length;
	var i=0;
	for(i=0;i<len;i++){
		if (document.form2.elements[i].name=='delete_field_id')
			if(document.form2.elements[i].checked)
				break;
	}
	if(i==len){
		alert("<%=SystemEnv.getHtmlLabelName(15445, user.getLanguage())%>");
		return false;
	}
	return confirm("<%=SystemEnv.getHtmlNoteName(7, user.getLanguage())%>") ;
}

</script>
<body>
	<%@ include file="/systeminfo/TopTitle.jsp"%>

	<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>



	<br>
	<%
		String fieldid = ""
				+ Util.getIntValue(request.getParameter("fieldid"), 0);
		String fieldname = Util.null2String(request
				.getParameter("fieldname"));
		String fielddbtype = Util.null2String(request
				.getParameter("fielddbtype"));
		String fieldhtmltype = Util.null2String(request
				.getParameter("fieldhtmltype"));

		String sql = "select distinct fieldid from workflow_formfield ";
		String useids = "";
		RecordSet.executeSql(sql);
		while (RecordSet.next()) {
			useids += "," + RecordSet.getString(1);
		}
		//获得系统默认工作流所使用的字段ID TD9092
		sql = "select distinct fieldid from workflow_formfield where formid=14";
		String sysusedids = "";
		RecordSet.executeSql(sql);
		while (RecordSet.next()) {
			sysusedids += "," + RecordSet.getString(1);
		}
		//int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
		int detachable = 0;//字段管理不分权，TD10331
		int subCompanyId = -1;
		int operatelevel = 0;

		if (detachable == 1) {
			if (request.getParameter("subCompanyId") == null) {
				subCompanyId = Util.getIntValue(String.valueOf(session
						.getAttribute("managefield_subCompanyId")), -1);
			} else {
				subCompanyId = Util.getIntValue(
						request.getParameter("subCompanyId"), -1);
			}
			if (subCompanyId == -1) {
				subCompanyId = user.getUserSubCompany1();
			}
			session.setAttribute("managefield_subCompanyId",
					String.valueOf(subCompanyId));
			operatelevel = CheckSubCompanyRight
					.ChkComRightByUserRightCompanyId(user.getUID(),
							"FieldManage:All", subCompanyId);
		} else {
			if (HrmUserVarify.checkUserRight("FieldManage:All", user))
				operatelevel = 2;
		}
	%>
	<form name="form2" method="post" action="delfields.jsp">
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())
					+ ",javascript:searchData(),_self}";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(199, user.getLanguage())
					+ ",javascript:doReset(),_self}";
			RCMenuHeight += RCMenuHeightStep;
			if (operatelevel > 0) {
		%>
		<%
			RCMenu += "{"
						+ SystemEnv.getHtmlLabelName(82, user.getLanguage())
						+ ",addfield.jsp?srcType=mainfield,_self}";
				RCMenuHeight += RCMenuHeightStep;
		%>

		<%
			}
			if (operatelevel > 1) {
		%>
		<%
			RCMenu += "{"
						+ SystemEnv.getHtmlLabelName(91, user.getLanguage())
						+ ",javascript:submitData(),_self}";
				RCMenuHeight += RCMenuHeightStep;
		%>

		<%
			}
		%>


		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		<table width=100% height=100% border="0" cellspacing="0"
			cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">

								<table class=liststyle cellspacing=1>
									<COLGROUP>
										<!--xwj for td3344 20051208 begin-->
										<COL width="5%">
										<COL width="5%">
										<COL width="20%">
										<COL width="10%">
										<COL width="20%">
										<COL width="10%">
										<COL width="10%">
										<COL width="10%">
										<COL width="10%">
										<!--xwj for td3344 20051208 end-->
									<TR class="Header">
										<TH colSpan=9><%=SystemEnv.getHtmlLabelName(684, user.getLanguage())%></TH>
									</TR>
									<!--xwj for td3344 20051208-->
									<TR class="Header">
										<TH colSpan=9><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%><!--xwj for td3344 20051208-->
											<input type="radio" name=srcType value="mainfield" checked><%=SystemEnv.getHtmlLabelName(18549, user.getLanguage())%>
											<input type="radio" name=srcType value="detailfield"
											onclick="location='managedetailfield.jsp'"><%=SystemEnv.getHtmlLabelName(18550, user.getLanguage())%>
										</TH>
									</TR>
									<tr class="Header">
										<td colspan="2"><nobr><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></nobr></td>
										<td class=field><input type=text name=fieldnameForSearch
											class=Inputstyle value="<%=fieldnameForSearch%>"></td>
										<td><nobr><%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></nobr></td>
										<td class=field><input type=text name=fielddec
											class=Inputstyle value="<%=fielddec%>"></td>
										<td><nobr><%=SystemEnv.getHtmlLabelName(687, user.getLanguage())%></nobr></td>
										<td class=field><select class=inputstyle size="1"
											name="fieldhtmltypeForSearch" onchange="showType()">
												<option value="0"></option>
												<option value="1"
													<%if (fieldhtmltypeForSearch.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(688, user.getLanguage())%></option>
												<option value="2"
													<%if (fieldhtmltypeForSearch.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(689, user.getLanguage())%></option>
												<option value="3"
													<%if (fieldhtmltypeForSearch.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(695, user.getLanguage())%></option>
												<option value="4"
													<%if (fieldhtmltypeForSearch.equals("4")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(691, user.getLanguage())%></option>
												<option value="5"
													<%if (fieldhtmltypeForSearch.equals("5")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(690, user.getLanguage())%></option>
												<option value="6"
													<%if (fieldhtmltypeForSearch.equals("6")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17616, user.getLanguage())%></option>
												<option value="7"
													<%if (fieldhtmltypeForSearch.equals("7")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21691, user.getLanguage())%></option>
										</select></td>
										<td><span id=typename> <%
 	if (fieldhtmltypeForSearch.equals("1")
 			|| fieldhtmltypeForSearch.equals("3")
 			|| fieldhtmltypeForSearch.equals("7")) {
 %>
												<%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%> <%
 	}
 %>
										</span></td>
										<td class=field><select class=inputstyle size="1"
											name="type" <%if (fieldhtmltypeForSearch.equals("1")) {%>
											style="display: ''" <%} else {%> style="display:none" <%}%>>
												<option value="0"></option>
												<option value="1" <%if (type.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></option>
												<option value="2" <%if (type.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(696, user.getLanguage())%></option>
												<option value="3" <%if (type.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(697, user.getLanguage())%></option>
												<option value="4" <%if (type.equals("4")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18004, user.getLanguage())%></option>
												<option value="5" <%if (type.equals("5")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(22395, user.getLanguage())%></option>
										</select> <select class=inputstyle size="1" name="type1"
											<%if (fieldhtmltypeForSearch.equals("3")) {%>
											style="display: ''" <%} else {%> style="display:none" <%}%>>
												<option value="0"></option>
												<%
													while (BrowserComInfo.next()) {
														String browserid = Util.null2String(BrowserComInfo
																.getBrowserid());
														int browserlableid = Util.getIntValue(
																BrowserComInfo.getBrowserlabelid(), 0);
												%>
												<option value="<%=browserid%>"
													<%if (type1.equals(browserid)) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(browserlableid,
						user.getLanguage())%></option>
												<%
													}
												%>
										</select> <select class=inputstyle size="1" name="type2"
											<%if (fieldhtmltypeForSearch.equals("7")) {%>
											style="display: ''" <%} else {%> style="display:none" <%}%>>
												<option value="0"></option>
												<option value="1" <%if (type2.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21692, user.getLanguage())%></option>
												<option value="2" <%if (type2.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21693, user.getLanguage())%></option>
										</select> <select class=inputstyle size="1" name="type3"
											<%if (fieldhtmltypeForSearch.equals("6")) {%>
											style="display: ''" <%} else {%> style="display:none" <%}%>>
												<option value="0"></option>
												<option value="1" <%if (type3.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20798, user.getLanguage())%></option>
												<option value="2" <%if (type3.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20001, user.getLanguage())%></option>
										</select></td>
										</div>
									</tr>
									<input type=hidden name=fieldid value="<%=fieldid%>">
									<input type=hidden name=fieldname value="<%=fieldname%>">
									<input type=hidden name=fielddbtype value="<%=fielddbtype%>">
									<tr class=header>
										<td><%=SystemEnv.getHtmlLabelName(172, user.getLanguage())%></td>
										<td colspan="2"><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></td>
										<td colspan="2"><%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></td>
										<!--added by xwj for td3344 20051208-->
										<td colspan="2"><%=SystemEnv.getHtmlLabelName(687, user.getLanguage())%></td>
										<td colspan="2"><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></td>
									</tr>
									<TR class=Line>
										<TD colspan="9"></TD>
									</TR>
									<!--xwj for td3344 20051208-->
									<%
										if (operatelevel > -1) {
											FieldMainManager.resetParameter();
											FieldMainManager.setSubCompanyId(subCompanyId);
											FieldMainManager.setFieldNameForSearch(fieldnameForSearch);
											FieldMainManager.setFieldDec(fielddec);
											FieldMainManager.setHtmlType(fieldhtmltypeForSearch);
											FieldMainManager.setFieldType(type);
											FieldMainManager.setFieldType1(type1);
											if (fieldhtmltypeForSearch.equals("6"))
												FieldMainManager.setFieldType(type3);
											if (fieldhtmltypeForSearch.equals("7"))
												FieldMainManager.setFieldType(type2);
											FieldMainManager.selectField();
											int htmltype = 0;
											int linecolor = 0;
											int fieldtype = 0;
											String dbtype = "";
											String strlength = "";
											String dbtypedesc = "";
											while (FieldMainManager.next()) {
												FieldInfo = FieldMainManager.getFieldManager();
												if (FieldInfo.getFieldhtmltype().equals("1"))
													htmltype = 688;
												else if (FieldInfo.getFieldhtmltype().equals("2"))
													htmltype = 689;
												else if (FieldInfo.getFieldhtmltype().equals("3"))
													htmltype = 695;
												else if (FieldInfo.getFieldhtmltype().equals("4"))
													htmltype = 691;
												else if (FieldInfo.getFieldhtmltype().equals("5"))
													htmltype = 690;
												//add by xhheng @20050309 for 附件上传
												else if (FieldInfo.getFieldhtmltype().equals("6"))
													htmltype = 17616;
												else if (FieldInfo.getFieldhtmltype().equals("7"))
													htmltype = 21691;
												fieldtype = FieldInfo.getType();
												dbtype = FieldInfo.getFielddbtype();
												if (FieldInfo.getFieldhtmltype().equals("1")
														&& fieldtype == 1)
													strlength = dbtype.substring(8, dbtype.length() - 1);

												if (FieldInfo.getFieldhtmltype().equals("1")) {
													if (fieldtype == 1)
														dbtypedesc = strlength + "bits string";
													if (fieldtype == 2)
														dbtypedesc = "integer";
													if (fieldtype == 3)
														dbtypedesc = "float";
												}
												if (FieldInfo.getFieldhtmltype().equals("2")) {
													dbtypedesc = "textarea";
												}
												if (FieldInfo.getFieldhtmltype().equals("3")) {
													dbtypedesc = SystemEnv.getHtmlLabelName(Util
															.getIntValue(BrowserComInfo
																	.getBrowserlabelid(fieldtype + ""), 0),
															user.getLanguage())
															+ "browser button";
												}
												if (FieldInfo.getFieldhtmltype().equals("4")) {
													dbtypedesc = "check box";
												}
												if (FieldInfo.getFieldhtmltype().equals("5")) {
													dbtypedesc = "integer";
												}
												//add by xhheng @20050309 for 附件上传
												if (FieldInfo.getFieldhtmltype().equals("6")) {
													dbtypedesc = "text";
												}
												if (FieldInfo.getFieldhtmltype().equals("7")) {
													dbtypedesc = "text";
												}
									%>
									<tr <%if (linecolor == 0) {%> class=datalight <%} else {%>
										class=datadark <%}%>>
										<td>
											<%
												if (!Util.toScreen(FieldInfo.getFieldname(),
																user.getLanguage()).equals("manager")
																&& !Util.toScreen(FieldInfo.getFieldname(),
																		user.getLanguage()).equals("president")
																&& sysusedids.indexOf("" + FieldInfo.getFieldid()) == -1) {
											%>
											<input type="checkbox" name="delete_field_id"
											value="<%=FieldInfo.getFieldid()%>" onClick=unselectall()
											<%=(useids.indexOf("" + FieldInfo.getFieldid()) != -1)
								? "disabled"
								: ""%>>
											<%
												} else {
											%> Sys <%
												}
											%>
										</td>
										<td colspan="2">
											<%
												if (!Util.toScreen(FieldInfo.getFieldname(),
																user.getLanguage()).equals("manager")
																&& !Util.toScreen(FieldInfo.getFieldname(),
																		user.getLanguage()).equals("president")
																&& sysusedids.indexOf("" + FieldInfo.getFieldid()) == -1) {
											%>
											<!--modify by xhheng @ 20041213 for TDID 1230--> <a
											href="addfield.jsp?fieldnameForSearch=<%=fieldnameForSearch%>&fielddec=<%=fielddec%>&fieldhtmltypeForSearch=<%=fieldhtmltypeForSearch%>&type=<%=type%>&type1=<%=type1%>&srcType=mainfield&src=editfield&fieldid=<%=FieldInfo.getFieldid()%>&isused=<%=(useids.indexOf("" + FieldInfo.getFieldid()) != -1)
								? "true"
								: "false"%>">
												<%
													}
												%> <%=Util.toScreen(FieldInfo.getFieldname(),
							user.getLanguage())%></a>
										</td>
										<td colspan="2"><%=Util.toScreen(FieldInfo.getDescription(),
							user.getLanguage())%></td>
										<!--xwj for td3344 20051208-->
										<td colspan="2"><%=SystemEnv.getHtmlLabelName(htmltype,
							user.getLanguage())%>
											<%
												if (FieldInfo.getFieldhtmltype().equals("3")) {
											%> - <%=SystemEnv.getHtmlLabelName(Util.getIntValue(
								BrowserComInfo
										.getBrowserlabelid(fieldtype + ""), 0),
								user.getLanguage())%>
											<%
												}
											%></td>
										<td colspan="2"><%=Util.toScreen(dbtype + "", user.getLanguage())%></td>
									</tr>
									<%
										if (linecolor == 0)
													linecolor = 1;
												else
													linecolor = 0;
											}
											FieldMainManager.closeStatement();
										}
									%>
									<tr class="header">
										<td colspan=9><input type="checkbox" name="checkall0"
											onClick="CheckAll(checkall0.checked)" value="ON"> <%=SystemEnv.getHtmlLabelName(694, user.getLanguage())%></td>
									</tr>
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
function submitData()
{
	if (confirmdel())
	{
	    if(confirm("<%=SystemEnv.getHtmlLabelName(22288, user.getLanguage())%>"))
	    {
	        form2.submit();
	    }
    }
}
function searchData(){
	para4 = $("input[name=fieldnameForSearch]").val();
	para5 =$("input[name=fielddec]").val();
	para1 =$("select[name=fieldhtmltypeForSearch]").val();
	para3 = $("select[name=type1]").val();
	para2 = $("select[name=type]").val();
	para6 = $("select[name=type2]").val();
	para7 = $("select[name=type3]").val();
	
	window.location="managefield.jsp?fieldhtmltypeForSearch="+para1+"&type="+para2+"&type1="+para3+"&fieldnameForSearch="+para4+"&fielddec="+para5+"&type2="+para6+"&type3="+para7;
	//form2.action="managefield.jsp";
	//form2.submit();
}
function doReset(){
		$("input[name=fieldnameForSearch]").val("");
		$("input[name=fielddec]").val("");
		$("select[name=fieldhtmltypeForSearch]").val("0");
		$("select[name=type1]").val('0');
		$("select[name=type2]").val('0');
		$("select[name=type3]").val('0');
		//$("select[name=type]").show(); //右键菜单 重新设置 的 重置函数doReset() 在重置的时候对字段类型下拉框的做了显示动作show()
		//2012-08-10 ypc 修改
		$("select[name=type]").hide();
		$("select[name=type3]").hide();
		$("select[name=type1]").hide();
		$("select[name=type2]").hide();
		$("#typename").html('');
}
function showType(){
	
	//点击重置后 此处应该用getElementById去获取选中先的id值
	//2012-08-13 ypc 修改
	//tmltype=document.all("fieldhtmltypeForSearch").value;
	htmltype=document.getElementById("fieldhtmltypeForSearch").value;
	if(htmltype==1){
		$("#typename").html('<%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%>');
		
		$("select[name=type1]").val('0');
		$("select[name=type2]").val('0');
		$("select[name=type3]").val('0');
		$("select[name=type]").show();
		$("select[name=type3]").hide();
		$("select[name=type1]").hide();
		$("select[name=type2]").hide();
	}else if(htmltype==3){
		$("#typename").html('<%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%>');
        $("select[name=type]").hide();
		$("select[name=type1]").val('0');
		$("select[name=type2]").val('0');
		$("select[name=type3]").val('0');
		$("select[name=type3]").hide();
		$("select[name=type1]").show();
		$("select[name=type2]").hide();
		
	}else if(htmltype==6){
		$("#typename").html('<%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%>');
	       
        $("select[name=type1]").val('0');
		$("select[name=type2]").val('0');
		$("select[name=type3]").val('0');
		$("select[name=type]").hide();
		$("select[name=type3]").show();
		$("select[name=type1]").hide();
		$("select[name=type2]").hide();
	}else if(htmltype==7){
		typename.innerHTML='<%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%>';
				$("select[name=type1]").val('0');
				$("select[name=type2]").val('0');
				$("select[name=type3]").val('0');
				$("select[name=type]").hide();
				//$("select[name=type3]").hide();
				//该字段属性改为show 才能带出 属性使用错误
				//2012-08-10 ypc 修改
				$("select[name=type3]").show();
				$("select[name=type1]").hide();
				$("select[name=type2]").hide();
			} else {
				$("#typename").html('');
				$("select[name=type1]").val('0');
				$("select[name=type2]").val('0');
				$("select[name=type3]").val('0');
				$("select[name=type]").hide();
				$("select[name=type3]").hide();
				$("select[name=type1]").hide();
				$("select[name=type2]").hide();
			}
		}
		function submitClear() {
			btnclear_onclick();
		}
	</script>
</body>
</html>