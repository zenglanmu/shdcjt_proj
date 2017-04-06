<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage());
String needfav ="1";
String needhelp ="";

int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
//int userId = 0;
//int userDeptId = 0;
//userId = user.getUID();
//userDeptId = user.getUserDepartment();

if(!HrmUserVarify.checkUserRight("SystemTemplate:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String sql = "";

int defaultTemplateId = -1;
sql = "SELECT templateId FROM SystemTemplateSubComp WHERE subcompanyid="+subCompanyId+"";
rs.executeSql(sql);
if(rs.next()){
	defaultTemplateId = rs.getInt("templateId");
}

if(subCompanyId!=-1)
	sql= "SELECT * FROM SystemTemplate WHERE companyId=0 OR companyId="+subCompanyId;
else
	sql= "SELECT * FROM SystemTemplate WHERE companyId="+subCompanyId;

rs.executeSql(sql);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<script type="text/javascript">
var radios;
var oSelectedIndex = -1;
var isClear = false;

window.onload = function(){
	radios = document.getElementsByName("tId");
	for(var i=0;i<radios.length;i++){
		if(radios[i].checked){
			oSelectedIndex = i;
			break;
		}
	}
}

function detectRadioStatus(){
	var e = window.event.srcElement;
	if(oSelectedIndex==e.id && !isClear){
		clearRadioSelected();	
	}else{
		oSelectedIndex = e.id;
		isClear = false;
	}
}

function clearRadioSelected(){
	for(var i=0;i<radios.length;i++){
		radios[i].checked = false;
	}
	isClear = true;
}

function detectTemplateStatus(){
	var e = window.event.srcElement;
	var e2 = e;
	while(e.tagName!="TR"){
		e = e.parentElement;
	}
	if(document.getElementById(e.rowIndex-2).checked){
		alert("<%=SystemEnv.getHtmlLabelName(18990,user.getLanguage())%>!");
		e2.checked = true;
	}
}
</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name="frmMain" method="post" action="templateOperation.jsp">
<input type="hidden" name="subCompanyId" value="<%=subCompanyId%>"/>
<input type="hidden" name="operationType" value="open"/>
<input type="hidden" id="openStr" name="openStr"/>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
<TABLE class="Shadow">
<tr>
<td valign="top">
		
<!--=================================-->
<TABLE class=ListStyle cellspacing=1>
<TR class=Header>
	<th width="40">ID</th>
	<TH><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></TH>
	<th width="150"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></th>
	<th width="60"><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></th>
	<th width="60"><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())%></th>
</TR>
<TR class=Line>
	<TD colSpan=4></TD>
</TR>
<%
int i = 0;
while(rs.next()){
		 String extendtempletUrl="";
		 int extendtempletid=Util.getIntValue(rs.getString("extendtempletid"),0);
		 if(extendtempletid>0){
			 rsExtend.executeSql("select extendurl from extendHomepage where id="+extendtempletid);
			 if(rsExtend.next()) extendtempletUrl=Util.null2String(rsExtend.getString(1));			
		 }
%>
<TR>
	<TD><%=rs.getInt("id")%></TD>
	<td>
		<a href="templateEdit.jsp?id=<%=rs.getInt("id")%>&subCompanyId=<%=subCompanyId%>"><%=rs.getString("templateName")%></a>
	</td>
	<td><a href="javascript:void(0);" onclick="preview(<%=rs.getInt("id")%>,'<%=extendtempletUrl%>','<%=extendtempletid%>');"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></a></td>
	<td>
		<input 
			type="checkbox" 
			id="c<%=rs.getInt("id")%>" 
			name="isOpen" 
			value="<%=rs.getInt("id")%>" 
			<%if(rs.getString("isOpen").equals("1")){out.println("checked onclick='detectTemplateStatus()'");}%> 
			<%if(rs.getInt("id")==1){out.println("disabled");}%>
		>
	</td>
	<td>
		<%if(rs.getString("isOpen").equals("1")){%>
		<input type="radio" id="<%=i%>" name="tId" value="<%=rs.getInt("id")%>" <%if(defaultTemplateId==rs.getInt("id")){out.println("checked");}%> onclick="detectRadioStatus()">
		<%}%>
	</td>
</TR>
<%
	i++;
}
%>
</TABLE>
<!--=================================-->

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
</body>
</html>

<script language="javascript">
function checkSubmit(){
	var notLessThanOne = false;
	var strIDs = "";
	var strValues = "";
	var o = document.getElementsByName("isOpen");
	for(var i=0;i<o.length;i++){
		strIDs += o[i].id.substr(1,o[i].id.length) +",";
		if(o[i].checked){
			strValues += "1,";
			notLessThanOne = true;
		}else{
			strValues += "0,";
		}
	}
	document.getElementById("openStr").value = strIDs.substr(0,strIDs.length-1)+"*"+strValues.substr(0,strValues.length-1);
	if(notLessThanOne){
		document.frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(18969,user.getLanguage())%>");
		return false;
	}
}

function preview(id,url,extendtempletid){	
	if(url!=""){
		//alert(url+"/index.jsp?from=preview&userSubcompanyId=<%=subCompanyId%>&templateId="+id+"&extendtempletid="+extendtempletid)
		openFullWindowForXtable(url+"/index.jsp?from=preview&userSubcompanyId=<%=subCompanyId%>&templateId="+id+"&extendtempletid="+extendtempletid);
	} else  {
		openFullWindowForXtable('templatePreview.jsp?id='+id);
	}
	
}
</script>