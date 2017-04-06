<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page import="weaver.Constants" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="MainCCI" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCCI" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCCI" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>

<script language=javascript src="/js/weaver.js"></script>

<html>
<%
	String message = "";
	int error = Util.getIntValue(request.getParameter("error"), 0);
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
	if(error == 1){
		message = SystemEnv.getHtmlLabelName(21943, user.getLanguage());
	}else if(error == 2){
		message = SystemEnv.getHtmlLabelName(22213, user.getLanguage());
	}
	int canDel = 0;//0，能删除；1，系统级，不可删除；2，被引用，不可删除
	int orderid = 0;
	String name = "";
	int isvalid = 1;
	int autotoplan = 0;
	int workplantypeid = 0;
	int annexmaincategory = 0;
	int annexsubcategory = 0;
	int annexseccategory = 0;
	int issystem = 0;
	if(wtid != 0){
		rs.execute("select * from worktask_base where id="+wtid);
		if(rs.next()){
			name = Util.null2String(rs.getString("name"));
			orderid = Util.getIntValue(rs.getString("orderid"), 0);
			isvalid = Util.getIntValue(rs.getString("isvalid"), 0);
			autotoplan = Util.getIntValue(rs.getString("autotoplan"), 0);
			workplantypeid = Util.getIntValue(rs.getString("workplantypeid"), 0);
			annexmaincategory = Util.getIntValue(rs.getString("annexmaincategory"), 0);
			annexsubcategory = Util.getIntValue(rs.getString("annexsubcategory"), 0);
			annexseccategory = Util.getIntValue(rs.getString("annexseccategory"), 0);
			issystem = Util.getIntValue(rs.getString("issystem"), 0);
		}
		if(issystem == 0){//判断该类型的计划任务是否被引用过
			rs.execute("select requestid from worktask_requestbase where taskid="+wtid);
			if(rs.next()){
				canDel = 2;
			}
		}else{
			canDel = 1;
		}
	}
	String displayStr = "";
	if(autotoplan != 1){
		displayStr = " none ";
	}
	String annexdocPath = "";
	if(annexmaincategory!=0 && annexsubcategory!=0 && annexseccategory!=0){
		annexdocPath = "/"+MainCCI.getMainCategoryname(""+annexmaincategory)+"/"+SubCCI.getSubCategoryname(""+annexsubcategory)+"/"+SecCCI.getSecCategoryname(""+annexseccategory);
	}

%>

<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

</head>

<body>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(wtid == 0){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
    //RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(-1),_self} " ;
    //RCMenuHeight += RCMenuHeightStep;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveData(this),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(21930, user.getLanguage())+",javascript:newworktask(),_self}" ;
	RCMenuHeight += RCMenuHeightStep;
	if(canDel == 0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:doDel(),_self}" ;
		RCMenuHeight += RCMenuHeightStep;
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name="weaver" id="weaver" method="post" action="wt_Operation.jsp">
<input type="hidden" name="src" value="" >
<input type="hidden" name="wtid" value="<%=wtid%>" >
<input type="hidden" id="annexmaincategory" name="annexmaincategory" value="<%=annexmaincategory%>">
<input type="hidden" id="annexsubcategory" name="annexsubcategory" value="<%=annexsubcategory%>">
<input type="hidden" id="annexseccategory" name="annexseccategory" value="<%=annexseccategory%>">
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
			<TR class="Title"><TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></TH></TR>
			<TR class="Spacing" style="height:2px"><TD class="Line1" colSpan=2></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(15795,user.getLanguage())%></td>
				<td class=field><input class=Inputstyle type="text" name="name" size="40" onChange="checkinput('name','namespan')" maxlength="25" value="<%=Util.forHtml(name)%>">
				<span id=namespan><%if("".equals(name)){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span><font color="red"><%=message%></font>
				</td>
			</tr>
			<TR class="Spacing" style="height:1px"><TD class="Line" colSpan=2></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(18624, user.getLanguage())%></td>
				<td class=field><INPUT type="checkbox" name="isvalid" value="1" <%if(isvalid == 1){%>checked<%}%> >
				</td>
			</tr>
			<TR class="Spacing" style="height:1px"><TD class="Line" colSpan=2></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(22001, user.getLanguage())%></td>
				<td class=field><INPUT type="checkbox" name="autotoplan" onclick="changeAutotoplan(this);" value="1" <%if(autotoplan == 1){%>checked<%}%> >
				</td>
			</tr>
			<TR class="Spacing" style="height:1px"><TD class="Line" colSpan=2></TD></TR>
			<tr id="workplantypediv" style="display:<%=displayStr%>">
				<td colSpan="2">
				<div>
				<table class="liststyle" cellspacing="1">
				<COLGROUP>
				<COL width="20%">
				<COL width="80%">
					<tr>
						<td><%=SystemEnv.getHtmlLabelName(16094, user.getLanguage())%></td>
						<td class=field>
							<SELECT name="workplantypeid">
								<%
									rs.execute("SELECT * FROM WorkPlanType " + Constants.WorkPlan_Type_Query_By_Menu);
									while(rs.next()){
										int workplantypeid_tmp = Util.getIntValue(rs.getString("workPlanTypeID"), 0);
										String workplantypename_tmp = Util.null2String(rs.getString("workPlanTypeName"));
										String selectStr = "";
										if(workplantypeid == workplantypeid_tmp){
											selectStr = " selected ";
										}
										out.println("<OPTION value=\""+workplantypeid_tmp+"\" "+selectStr+">"+workplantypename_tmp+"</OPTION>");
									}
								%>
							</SELECT>
						</td>
					</tr>
					
				</table>
				</div>
			</td>
			</tr>
			<TR id="workplantypedivLine" class="Spacing" style="height:1px;display:<%=displayStr%>"><TD class="Line" colSpan=2 style="padding: 0px;"></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></td>
				<td class=field><input class=Inputstyle type="text" name="orderid" size="6" onKeyPress="ItemCount_KeyPress_self()" maxlength="2" value="<%=orderid%>" >
				</td>
			</tr>
			<TR class="Spacing" style="height:1px"><TD class="Line" colSpan=2></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(22210,user.getLanguage())%></td>
				<td class=field>
					<BUTTON class="Browser" type=button id="selectannexCategoryid" onClick="onShowAnnexCatalog(annexpath)"  name="selectannxtCategory" ></BUTTON>
					<span id="annexpath" ><%=annexdocPath%></span>
				</td>
			</tr>
			<TR class="Spacing" style="height:1px"><TD class="Line" colSpan=2 "></TD></TR>
			<%if(wtid != 0){%>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%>ID（wtid）</td>
				<td class=field><%=wtid%></td>
			</tr>
			<TR class="Spacing" style="height:1px"><TD class="Line" colSpan=2></TD></TR>
			<%}%>
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

function doDel(){
	if(isdel()){
		weaver.src.value="delwt";
		weaver.submit();
		enableAllmenu();
	}
}
function submitData(obj){
	if (check_form(weaver, 'name')){
		weaver.src.value="addwt";
		weaver.submit();
		enableAllmenu();
	}
}
function saveData(obj){
	if (check_form(weaver, 'name')){
		weaver.src.value="editwt";
		weaver.submit();
		enableAllmenu();
	}
}
function ItemCount_KeyPress_self(){
	if(!((window.event.keyCode>=48) && (window.event.keyCode<=57))){
		window.event.keyCode=0;
	}
}
function newworktask(){
	parent.location.href = "worktaskAdd.jsp?isnew=1";
}
function onShowAnnexCatalog(spanName) {
	//tag:"1",id:""+id, path:""+path, mainid:""+mainid, subid:""+subid,path2:""+parth2
	var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
	if (result != null) {
		if (result.tag > 0)  {
			jQuery(spanName).html(result.path);
			jQuery("#annexmaincategory").val(result.mainid);
			jQuery("#annexsubcategory").val(result.subid);
			jQuery("#annexseccategory").val(result.id);
		}else{
			jQuery(spanName).html("");
			jQuery("#annexmaincategory").val("");
			jQuery("#annexsubcategory").val("");
			jQuery("#annexseccategory").val("");
		}
	}
}
function changeAutotoplan(obj){
	var playType = "";
	if(obj.checked == false){
		playType = "none";
	}
	//var wfdiv = document.getElementByID("wfdiv");
	workplantypediv.style.display = playType;
	workplantypedivLine.style.display = playType;
}
</script>
</body>
</html>