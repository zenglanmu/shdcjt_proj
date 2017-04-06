<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="Resource" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<%
/*
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(431,user.getLanguage());
String needfav ="1";
String needhelp ="";
*/
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String operationType=Util.null2String(request.getParameter("operationType"));

String id=Util.null2String(request.getParameter("id"));//½ÇÉ«ID
String para=""+id;
rs.execute("hrmroles_selectSingle",para);
rs.next();

String rolesmark=rs.getString(1);
String rolesname=rs.getString(2);
int docid=Util.getIntValue(rs.getString(3),0);
int roletype=Util.getIntValue(rs.getString(4),0);
String structureid=rs.getString(5);

int operatelevel=0;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmRolesAdd:Add",Integer.parseInt(structureid));
}else{
    if(HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user))
        operatelevel=2;
}
%>

<!--%@ include file="/systeminfo/TopTitle.jsp" %-->
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
/*
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(193,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
*/
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doReturn(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
if(operatelevel>0){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+32+" and relatedid="+id+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+32+" and relatedid="+id+",_self} " ;
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

<form name=showMember action=HrmRolesMembersAdd.jsp method="post">
<input type=hidden name="operationType" value="MutiDelete">
<input type=hidden id=roleID name="roleID" value="<%=id%>">
<%//deleted cause bad performance,td5796,xiaofeng
//add by zhouquan delete role member not in valid resource id
/*ArrayList memberIds = new ArrayList() ;
String sql = "select id from hrmrolemembers where resourceid > 2 and resourceid not in (select id from Hrmresource where status = 0 or status = 1 or status = 2 or status = 3 union select id from hrmresourcemanager) ";

rs.executeSql(sql);
while(rs.next()){
    String memberIdToDelete = rs.getString("id");
    memberIds.add(memberIdToDelete);
}


Iterator toDeleteIterator = memberIds.iterator();
while(toDeleteIterator.hasNext()){
	String toDeleteId = toDeleteIterator.next().toString();
	sql = "delete hrmrolemembers where id = "+toDeleteId;
	Record.executeSql(sql);
}*/
//end
%>
<TABLE class=ViewForm>
    <col width='20%'>
    <col width='80%'>
    <TR class=Title><TD COLSPAN=4><B><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></B></TD></TR>
    <TR class=Title  style="height:1px;"><TD COLSPAN=4 class=Line1  style="height:1px;"></TD></TR>
    
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TD>
        <TD CLASS=FIELD><%=Util.forHtml(Util.toScreen(rolesmark,user.getLanguage()))%></TD>
    </TR>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
        <TD CLASS=FIELD ><%=Util.forHtml(Util.toScreen(rolesname,user.getLanguage()))%></TD>
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
    <input class=inputstyle type=hidden name=id value=<%=id%>>
</TABLE>

<BR>
		<TABLE class=ViewForm>
<TR class=Title>
	<TD>
		<B><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></B>
	</TD>
	
	<TD align=right colSpan=3>
		<% if(operatelevel>0) {%>
		<button type=button  class=Btn id=button1 accessKey=1 
				  onclick="onAdd()"
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
<%
	
	char separator = Util.getSeparator() ;
	boolean tableindex1 = true ;
	int i =0;
	para=id+separator+"2";
	rs.execute("hrmroles_selectbyrole",para);
	String memeberid="";
	String rolememberid ="" ;
	while(rs.next()){
		memeberid=rs.getString("resourceid");
		rolememberid = rs.getString("id") ;
	 	if(tableindex1) {
			tableindex1 = false ;
	%>
<TABLE class=ListStyle cellspacing=1 >
	<COL WIDTH=10%>
	<COL WIDTH=30%>
	<COL WIDTH=30%>
	<COL WIDTH=30%> 
  <TR class=Header>
    <TH COLSPAN=4><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></TH>
  </TR>
  <TR CLASS=Header>
	<TD><input type="checkbox" name="checkall2" onClick="CheckAlls(checkall2.checked)" value="ON"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
  </TR>
  <TR  style="height:1px;" class=Line><TD colspan="4" ></TD></TR> 
<% }if(i==0){
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
	<TD><input type="checkbox" name="ids1" value="<%=rolememberid%>"></TD>
    <TD><A HREF="HrmRolesMembersEdit.jsp?id=<%=rolememberid%>"><%=Util.toScreen(Resource.getLastname(memeberid),user.getLanguage())%></A></TD>
    <TD><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(Resource.getJobTitle(memeberid)),user.getLanguage())%></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Resource.getDepartmentID(memeberid)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(Resource.getDepartmentID(memeberid)),user.getLanguage())%></a></TD>
  </TR>

<%
}
if(!tableindex1) {
	tableindex1 = true ;
%>
</table>
<% 
}
	i =0;
	para=id+separator+"1";
	rs.execute("hrmroles_selectbyrole",para);
	while(rs.next()){
		memeberid=rs.getString("resourceid");
		rolememberid = rs.getString("id") ;
	 	if(tableindex1) {
			tableindex1 = false ;
	%>
		<br>	

 <TABLE class=ListStyle cellspacing=1 >
	<COL WIDTH=10%>
	<COL WIDTH=30%>
	<COL WIDTH=30%>
	<COL WIDTH=30%> 
  <TR class=Header>
    <TH COLSPAN=4><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH>
  </TR>
 <TR CLASS=Header>
	<TD><input type="checkbox" name="checkall1" onClick="CheckAlla(checkall1.checked)" value="ON"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
  </TR>
<TR class=Line style="height:1px;"><TD colspan="4" ></TD></TR> 
<% }if(i==0){
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
	<TD><input type="checkbox" name="ids2" value="<%=rolememberid%>"></TD>
    <TD><A HREF="HrmRolesMembersEdit.jsp?id=<%=rolememberid%>"><%=Util.toScreen(Resource.getLastname(memeberid),user.getLanguage())%></A></TD>
    <TD><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(Resource.getJobTitle(memeberid)),user.getLanguage())%></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Resource.getDepartmentID(memeberid)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(Resource.getDepartmentID(memeberid)),user.getLanguage())%></a></TD>
  </TR>
<%
}
if(!tableindex1) {
	tableindex1 = true ;
%>
</table>
<% }
	i =0;
	para=id+separator+"0";
	rs.execute("hrmroles_selectbyrole",para);
	while(rs.next()){
		memeberid=rs.getString("resourceid");
		rolememberid = rs.getString("id") ;
	 	if(tableindex1) {
			tableindex1 = false ;
	%>
	<br>	
	
 <TABLE class=ListStyle cellspacing=1 >
	<COL WIDTH=10%>
	<COL WIDTH=30%>
	<COL WIDTH=30%>
	<COL WIDTH=30%> 
  <TR class=Header>
    <TH COLSPAN=4><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
  </TR>
 <TR CLASS=Header>
	<TD><input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
  </TR>
  <TR class=Line style="height:1px;"><TD colspan="4" ></TD></TR> 
<% }if(i==0){
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
	<TD><input type="checkbox" name="ids" value="<%=rolememberid%>"></TD>
    <TD><A HREF="HrmRolesMembersEdit.jsp?id=<%=rolememberid%>"><%=Util.toScreen(Resource.getLastname(memeberid),user.getLanguage())%></A></TD>
    <TD><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(Resource.getJobTitle(memeberid)),user.getLanguage())%></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Resource.getDepartmentID(memeberid)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(Resource.getDepartmentID(memeberid)),user.getLanguage())%></a></TD>
  </TR>
<%
}
if(!tableindex1) {
	tableindex1 = true ;
%>
</table>
<% 
}
%>
</form>
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

<script language=javascript>
function CheckAll(checked) {
len = document.showMember.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.showMember.elements[i].name=='ids') {
    if(document.showMember.elements[i].disabled == false){
    document.showMember.elements[i].checked=(checked==true?true:false);
    }
} } }
function CheckAlls(checked) {
len = document.showMember.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.showMember.elements[i].name=='ids1') {
    if(document.showMember.elements[i].disabled == false){
    document.showMember.elements[i].checked=(checked==true?true:false);
    }
} } }
function CheckAlla(checked) {
len = document.showMember.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.showMember.elements[i].name=='ids2') {
    if(document.showMember.elements[i].disabled == false){
    document.showMember.elements[i].checked=(checked==true?true:false);
    }
} } }

function unselectall()
{
    if(document.showMember.checkall0.checked){
	document.showMember.checkall0.checked =0;
    }
}
function onAdd(){
	document.showMember.roleID.value="<%=id%>";
	document.showMember.submit();
}
function onDelete(){
	var i=0;
	var result = false;
	var ids = document.getElementsByName("ids");
	var ids1 = document.getElementsByName("ids1");
	var ids2 = document.getElementsByName("ids2");
	try{
		for(i=0;i<ids.length;i++){
			if(ids[i].checked){
				result = true;
				break;
			}
		}
	}catch(e){}
	try{
		for(i=0;i<ids1.length;i++){
			if(ids1[i].checked){
				result = true;
				break;
			}
		}
	}catch(e){}
	try{
		for(i=0;i<ids2.length;i++){
			if(ids2[i].checked){
				result = true;
				break;
			}
		}
	}catch(e){}
	if(!result){
	   alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
	   return;
	}
	if(isdel()) {
		
			document.showMember.action = "HrmRolesMembersOperation.jsp";
			document.showMember.operationType.value = "MutiDelete";
			document.showMember.submit();
	}
}
function doReturn(){
	window.parent.location="/hrm/roles/HrmRoles.jsp";
}

if("<%=operationType%>"=="New"||"<%=operationType%>"=="MutiDelete"){
    parent.refreshWindow();
}

</script>
</BODY>
</HTML>