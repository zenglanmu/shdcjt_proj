<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD> 
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
/*
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
*/
int id=Util.getIntValue(request.getParameter("id"),0);//角色ID

String para=""+id;//重要变量
rs.execute("hrmroles_selectSingle",para);
rs.next();
String rolesmark=rs.getString(1);
String rolesname=rs.getString(2);
String subcompanyid = Util.null2String(rs.getString(5));
int docid=Util.getIntValue(rs.getString(3),0);
int type=Util.getIntValue(rs.getString("type"),0);
int flag=Util.getIntValue(request.getParameter("flag"),0);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
session.setAttribute("role_type",String.valueOf(type));

String structureid ="";
if(request.getParameter("subCompanyId")==null){
    structureid=String.valueOf(session.getAttribute("role_subCompanyId"));
}else{
    structureid=Util.null2String(request.getParameter("subCompanyId"));
}

if(!"".equals(subcompanyid)){
   structureid = subcompanyid;
}

int operatelevel=0;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmRolesAdd:Add",Integer.parseInt(structureid));
}else{
    if(HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user))
        operatelevel=2;
}
%>

<BODY>
<!--%@ include file="/systeminfo/TopTitle.jsp" %-->
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
String tempSql = "select isdefault from HrmRoles where id = "+id;
rs.executeSql(tempSql);
rs.next();
int isDefault = rs.getInt("isdefault");

if(operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(operatelevel>1&&isDefault!=1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doReturn(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
if(operatelevel>0){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+16+" and relatedid="+id+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+16+" and relatedid="+id+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<% if(flag==11) {%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(flag,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%
if(errorcode == 10) {
%>
	<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage())%></font></div>
<%}%>
<form method=post name=hrmrolesedit action=HrmRolesOperation.jsp>
<input class=inputstyle type=hidden name=operationType > 
<input class=inputstyle type=hidden name=id value="<%=id%>" > 
<input class=inputstyle type=hidden name=roletype value="<%=type%>" > 
  <TABLE class=ViewForm>
<col width='20%'>
<col width='80%'>
<TR class=Title><TD COLSPAN=4><B><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></B></TD></TR>
<TR class=Title style="height:1px;"><TD COLSPAN=4 class=Line1></TD></TR>
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TD>
	<TD CLASS=FIELD>
	<%if(operatelevel>0){%>
       	<INPUT TYPE=TEXT class=inputStyle NAME=idname SIZE=50 MAXLENGTH=60 VALUE="<%=rolesmark%>" onChange="checkinput('idname','idnamespan')" onblur='javascript:checkMaxLength(this)' alt='<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>60(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)'>
       	<span id=idnamespan></span>
    <%} else {
        %><%=Util.toScreen(rolesmark,user.getLanguage())%>
    <%}%>
    </TD>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
	<TD CLASS=FIELD >
	<%if(operatelevel>0){%>
		<INPUT TYPE=TEXT class=inputStyle NAME=description SIZE=60 MAXLENGTH=100 VALUE="<%=rolesname%>" onChange="checkinput('description','descspan')">
		<span id=descspan></span>
	<%} else {
        %><%=Util.toScreen(rolesname,user.getLanguage())%>
    <%}%>
	</TD>
</TR>

<%if(detachable==1){%>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD> 
        <TD class=Field >
            <%if(operatelevel>0){%>
                <button type=button  class=Browser id=SelectSubCompany onclick="onShowSubcompany()"></BUTTON>
            <%}%>
            <SPAN id=subcompanyspan>
                <%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(structureid),user.getLanguage())%>
                <%if(String.valueOf(structureid).equals("")){%>
                    <IMG src="/images/BacoError.gif" align=absMiddle>
                <%}%>
            </SPAN>
            <input type=hidden id=structureid name=structureid value="<%=structureid%>">
        </TD>
    </TR>
<%}%>

<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD> 
	<TD class=Field >
    <%if(operatelevel>0){%>
    	<button type=button  class=Browser onclick="showHeaderDoc()"></BUTTON>
    <%}%>
		<SPAN ID=relativedocid><a href='/docs/docs/DocDsp.jsp?id=<%=docid%>'><%=DocComInfo.getDocname(""+docid)%></a></SPAN>
       	<INPUT class=inputStyle type=hidden name=docid value="<%=docid%>">        
    </TD>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<input class=inputstyle type=hidden name=id value=<%=id%>>
</TABLE>
</FORM>
<BR>
<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function showHeaderDoc() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
			, $GetEle("relativedocid")
			, $GetEle("docid")
			, false
			, "/docs/docs/DocDsp.jsp?id=");
}

function onShowSubcompany() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmRolesAdd:Add&isedit=1&selectedids=" + $GetEle("structureid").value
			, $GetEle("subcompanyspan")
			, $GetEle("structureid")
			, true);
}
</script>

<script>
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.hrmrolesedit.operationType.value="Delete";
		document.hrmrolesedit.submit();
		enableAllmenu();
	}
}	
function onEdit(){
	if(check_form(document.hrmrolesedit,'idname,description,structureid')){
		document.hrmrolesedit.operationType.value="Edit";
		document.hrmrolesedit.submit();
		enableAllmenu();
	}
}
function doReturn(){
	window.parent.location="/hrm/roles/HrmRoles.jsp";
}
</script>
<BR>
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

</BODY>

</HTML>