<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
String imagefilename = "/images/hdHRM.gif";

String currentYear=TimeUtil.getCurrentDateString().substring(0,4);
String CurrentUser = ""+user.getUID();
//要创建的计划的所有者类型  "0"：总部；"1"：分部；"2":部门；"3"：人力资源
String type_d=Util.null2String(request.getParameter("type_d")); 
//左侧组织结构树所选中的单位的ID
String objId=Util.null2String(request.getParameter("objId")); 


//来源于提醒 
String type=Util.null2String(request.getParameter("type"));
if("".equals(type)){
	type = "2";
}
String planDate=Util.null2String(request.getParameter("planDate")); 
String years=Util.null2String(request.getParameter("years"));
String months=Util.null2String(request.getParameter("months"));
String currentMonth = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).MONTH)+1);
if(years.equals("")){
	years = currentYear;
}
if(months.equals("")){
	months = currentMonth;
}
String weeks=Util.null2String(request.getParameter("weeks"));
String quarters=Util.null2String(request.getParameter("quarters"));
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
int worktaskStatus = Util.getIntValue(request.getParameter("worktaskStatus"), 5);

if (objId.equals("")) 
{
objId=CurrentUser;
type_d="3";
}

String objName="";
if (type_d.equals("1"))
{
objName=SubCompanyComInfo.getSubCompanyname(objId);
}
else if (type_d.equals("2"))
{
objName=DepartmentComInfo.getDepartmentname(objId);
}
else if (type_d.equals("3"))
{
objName=ResourceComInfo.getLastname(objId);
}

SessionOper.setAttribute(session,"hrm.objId",objId);
SessionOper.setAttribute(session,"hrm.objName",objName);
SessionOper.setAttribute(session,"hrm.type_d",type_d);

%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
</HEAD>
<script language=javascript>
function resetbanner(objid, typeid){
	var years = document.all("years").value;
	var wtid = document.all("wtid").value;
	var worktaskStatus = document.all("worktaskStatus").value;
	if(objid != "5" && objid != "6"){
		document.all("typeid").value = typeid;
		for(i=0; i<=4; i++){
			document.all("oTDtype_"+i).background="/images/tab2.png";
			document.all("oTDtype_"+i).className="cycleTD";
		}
		document.all("oTDtype_"+objid).background="/images/tab.active2.png";
		document.all("oTDtype_"+objid).className="cycleTDCurrent";
	}else{
		typeid = document.all("typeid").value;
	}
	var o = parent.contentframe.iframes.document;
	//alert("RequestExecuteList.jsp?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+typeid+"&type_d=<%=type_d%>&objId=<%=objId%>&years="+years);
	o.location="RequestExecuteList.jsp?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+typeid+"&type_d=<%=type_d%>&objId=<%=objId%>&years="+years;
}
function init(objid,typeid){
	if(objid != "5" && objid != "6"){
		document.all("typeid").value = typeid;
		for(i=0; i<=4; i++){
			document.all("oTDtype_"+i).background="/images/tab2.png";
			document.all("oTDtype_"+i).className="cycleTD";
		}
		document.all("oTDtype_"+objid).background="/images/tab.active2.png";
		document.all("oTDtype_"+objid).className="cycleTDCurrent";
	}else{
		typeid = document.all("typeid").value;
	}
	var o = parent.contentframe.iframes.document;
	o.location="RequestExecuteList.jsp?wtid=<%=wtid%>&worktaskStatus=<%=worktaskStatus%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&months=<%=months%>&quarters=<%=quarters%>&weeks=<%=weeks%>";
}
 </script>
<body style="overflow:auto" <%if (!type.equals("")) {%>onload="init('<%=type%>','<%=type%>')" <%}%> >
<form name=weaver id=weaver>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr>
<td height="100%">


<input type="hidden" name="typeid" value="<%=type%>">
<table style="width:98%;height:95%" border=0 cellspacing=0 cellpadding=0  scrolling=no id="tabPane">
	<colgroup>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="*"></col>
	</colgroup>
	<TBODY>
		<tr align=left height="20">
		<td class="cycleTD" nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'"  onclick="resetbanner(0,0)"><b>
			<select name="years" onchange="resetbanner(0,0)">
			<%for (int i=Util.getIntValue(currentYear)-10; i<Util.getIntValue(currentYear)+11;i++) {%>
				<option value="<%=i%>" <%if (String.valueOf(i).equals(currentYear)) {%>selected<%}%>><%=i%></option>
			<%}%>
			</select>
			<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></b>
		</td>
		<td class="cycleTD" nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,1)" ><b><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></b></td>
		<td class="cycleTDCurrent" nowrap name="oTDtype_2" id="oTDtype_2"  background="/images/tab.active2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2,2)"><b><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></b></td>

		<td class="cycleTD" nowrap name="oTDtype_3"  id="oTDtype_3" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(3,3)" ><b><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></b></td>
		<td class="cycleTD" nowrap name="oTDtype_4"  id="oTDtype_4" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(4,4)" ><b><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></b></td>
		<td name="oTDtype_5"  id="oTDtype_5">
			<select name="wtid" onchange="resetbanner(5,5)" style="width:100%">
				<option value="0" <%if(wtid == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21979, user.getLanguage())%></option>
		<%
			RecordSet.execute("select * from worktask_base where isvalid=1 order by orderid");
			while(RecordSet.next()){
				String wtname_tmp = Util.null2String(RecordSet.getString("name"));
				int wtid_tmp = Util.getIntValue(RecordSet.getString("id"), 0);
		%>
				<option value="<%=wtid_tmp%>" <%if(wtid_tmp == wtid){%>selected<%}%>><%=wtname_tmp%></option>
			<%}%>
			</select>
		</td>
		<td name="oTDtype_6"  id="oTDtype_6">
			<select name="worktaskStatus" onchange="resetbanner(6,6)" style="width:100%">
			<%
				RecordSet.execute("select * from SysPubRef where masterCode='WorkTaskStatus' and flag=1 and detailCode in (0,5,6,7,8,9,10)");
				while(RecordSet.next()){
					int detailCode = Util.getIntValue(RecordSet.getString("detailCode"), 0);
					int detailLabel = Util.getIntValue(RecordSet.getString("detailLabel"), 0);
			%>
			<option value="<%=detailCode%>" <%if (worktaskStatus == detailCode){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(detailLabel, user.getLanguage())%></option>
			<%}%>
			</select>
		</td>
		<td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
		</tr>
		<tr>
			<td  colspan="8" style="padding:0;">
		<%if (!type.equals("")) {%>
			<iframe src="" ID="iframes" name="iframes" frameborder="0" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"/>
		<%}else{%>
			<iframe src="RequestExecuteList.jsp?wtid=<%=wtid%>&worktaskStatus=<%=worktaskStatus%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=currentYear%>&months=<%=months%>&planDate=<%=planDate%>&quarters=<%=quarters%>&weeks=<%=weeks%>" ID="iframes" name="iframes" frameborder="0" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"/>
		<%}%>
			</td>
		</tr>
		</TBODY>
		</table>
 
</td>
</tr>

</table>
</form>
</body>