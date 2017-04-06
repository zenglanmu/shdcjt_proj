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
    String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17864,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
	*/
    int id=Util.getIntValue(request.getParameter("id"),0);//角色ID
    int flag=Util.getIntValue(request.getParameter("flag"),0);
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

    String para=""+id;//重要变量
    rs.execute("hrmroles_selectSingle",para);
    rs.next();

    String rolesmark=rs.getString(1);
    String rolesname=rs.getString(2);
    int docid=Util.getIntValue(rs.getString(3),0);
    int roletype=Util.getIntValue(rs.getString(4),0);
    String structureid=rs.getString(5);

    session.setAttribute("role_type",String.valueOf(roletype));

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
	/*
	if(HrmUserVarify.checkUserRight("HrmRolesEdit:Delete", user)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}*/
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doReturn(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	if(operatelevel>0){
		if(rs.getDBType().equals("db2")){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+102+" and relatedid="+id+",_self} " ;
		}else{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+102+" and relatedid="+id+",_self} " ;
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
<form  name=hrmrolesedit action=HrmRolesFucRightOperation.jsp method=post>
<input type=hidden name=operationType > 
<input type=hidden name=id value="<%=id%>" > 
<input type=hidden name=detachable value="<%=detachable%>"> 

<TABLE class=ViewForm>
    <col width='20%'>
    <col width='80%'>
    <TR class=Title><TD COLSPAN=4><B><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></B></TD></TR>
    <TR class=Title style="height:1px;"><TD COLSPAN=4 class=Line1></TD></TR>
    
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TD>
        <TD CLASS=FIELD><%=Util.forHtml(Util.toScreen(rolesmark,user.getLanguage()).replaceAll("'","\\'"))%></TD>
    </TR>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
        <TD CLASS=FIELD ><%=Util.forHtml(Util.toScreen(rolesname,user.getLanguage()).replaceAll("'","\\'"))%></TD>
    </TR>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 

    <%if(detachable==1){%>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
            <TD class=Field ><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(structureid),user.getLanguage())%>
            <span id=structureid value=<%=structureid%>></span></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
            <%if(roletype==0){%>
                <TD class=Field ><%=SystemEnv.getHtmlLabelName(17866,user.getLanguage())%></TD>
            <%}if(roletype==1){%>
                <TD class=Field ><%=SystemEnv.getHtmlLabelName(17867,user.getLanguage())%></TD>
            <%}%>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
    <%}%>
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
        <TD class=Field >
            <SPAN ID=relativedocid><a href='/docs/docs/DocDsp.jsp?id=<%=docid%>'><%=DocComInfo.getDocname(""+docid)%></a></SPAN>
            <INPUT class=inputStyle type=hidden name=docid value="<%=docid%>">
        </TD>
    </TR>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
</TABLE>

<BR>

<TABLE class=ViewForm>
<TR class=Title>
	<TD>
		<B><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></B>
	</TD>
	
	<TD align=right colSpan=3>
		<% if(operatelevel>0) {%>
		<button type=button  class=Btn id=button1 accessKey=1 
				  onclick='location.href="HrmRoleRightAdd.jsp?id=<%=id%>"' 
				  name=button1><U>1</U>-<%=SystemEnv.getHtmlLabelName(193,user.getLanguage())%>
		</BUTTON>
		<button type=button  class=Btn id=button2 accessKey=2 
				  onclick="onDelete()"
				  name=button2><U>2</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
		</BUTTON>
		<%}%> 
	</TD>
</TR>
<TR class=Spacing><TD CLASS=Sep3></TD></TR>
</TABLE>

<TABLE class=ListStyle cellspacing=1 >
	<COL WIDTH=10%>
	<COL WIDTH=45%>
	<COL WIDTH=15%>
	<COL WIDTH=30%> 
<TR CLASS=Header>
<TD><input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></TD>
<TD><%=SystemEnv.getHtmlLabelName(492,user.getLanguage())%></TD>
<TD><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
<TD><%=SystemEnv.getHtmlLabelName(440,user.getLanguage())%></TD>
</TR>
<TR class=Line><TD colspan="4" ></TD></TR> 
<%	rs.executeSql("select t3.rightgroupname,t1.rolelevel,t1.rightid from systemrightroles t1 left join SystemRightToGroup t2 on t1.rightid = t2.rightid left join SystemRightGroups t3 on t2.groupid = t3.id where t1.roleid = "+id+" order by t3.id");
	String rightgroup="",rightid="",rightlevel="";
	String bufrightgroup="  ",bufrightlevel="";
	int level;
	int i =0;
	while(rs.next()){
		rightgroup=Util.toScreen(rs.getString(1),user.getLanguage());
		level=rs.getInt(2);
		rightid=Util.toScreen(rs.getString(3),user.getLanguage());
		switch(level){
			case 0:rightlevel=SystemEnv.getHtmlLabelName(124,user.getLanguage());
				break;
			case 1:rightlevel=SystemEnv.getHtmlLabelName(141,user.getLanguage());
				break;
			case 2:rightlevel=SystemEnv.getHtmlLabelName(140,user.getLanguage());
		}
		String tempSql = "select id from systemrightroles where roleid = " + id 
													   + " and rightid = " + rightid
													   + " and rolelevel = '"+ level+"'";
							   	
		RecordSet.executeSql(tempSql);
		RecordSet.next();
		int roleRightId = RecordSet.getInt("id");
		if(i==0){
			i=1;
		%>
	<TR class=DataLight>
		<%
		}else{
			i=0;
		%>
	<TR class=DataDark>
		<%
		}
		%>
		<TD><input type="checkbox" name="ids" value="<%=roleRightId%>"></TD>
		<input type="hidden" name="rightid" value="<%=rightid%>">
		<TD>
		<%if(!bufrightgroup.equals(rightgroup)) {
		  	if(rightgroup.equals("")) out.println(SystemEnv.getHtmlLabelName(332,user.getLanguage()));
		  	else  out.println(rightgroup);
			bufrightgroup = rightgroup ;bufrightlevel="";
		  }
		%>
		</TD>
		<TD>
		<%if(!bufrightlevel.equals(""+level)) {
			out.println(rightlevel);
			bufrightlevel = ""+level;
		  }
		%>
		</TD>
		<TD>
			<%if(operatelevel>0){%>
				<a href="HrmRoleRightEdit.jsp?id=<%=roleRightId%>&roleId=<%=id%>&rightId=<%=rightid%>&roleLevel=<%=level%>&detachable=<%=detachable%>"><%=Util.toScreen(RightComInfo.getRightname(rightid,""+user.getLanguage()),user.getLanguage())%></a>
			<%}else{%>
				<%=Util.toScreen(RightComInfo.getRightname(rightid,""+user.getLanguage()),user.getLanguage())%>
			<%}%>
		</TD>
	</TR>

<%
}
%>
</TABLE>
</FORM>
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
</script>

<script>
function CheckAll(checked) {
len = document.hrmrolesedit.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.hrmrolesedit.elements[i].name=='ids') {
    if(document.hrmrolesedit.elements[i].disabled == false){
    document.hrmrolesedit.elements[i].checked=(checked==true?true:false);
    }
} } }

function unselectall()
{
    if(document.hrmrolesedit.checkall0.checked){
	document.hrmrolesedit.checkall0.checked =0;
    }
}

function onDelete(){
	var result = false;
	var ids = document.getElementsByName("ids");
	for(var i=0;i<ids.length;i++){
		if(ids[i].checked){
			result = true;
			break;
		}
	}
	if(isdel()) {
		if(!result){
			alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		}else{
			document.hrmrolesedit.operationType.value="Delete";
			document.hrmrolesedit.submit();
		}
	}
}	
function onEdit(){
	if(check_form(document.hrmrolesedit,'idname,description')){
		document.hrmrolesedit.operationType.value="Edit";
		document.hrmrolesedit.submit();
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