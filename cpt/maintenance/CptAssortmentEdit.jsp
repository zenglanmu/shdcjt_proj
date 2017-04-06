<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String paraid = Util.null2String(request.getParameter("paraid")) ;
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String assortmentid = paraid;

RecordSet.executeProc("CptCapitalAssortment_SByID",assortmentid);
RecordSet.next();

String assortmentname = RecordSet.getString("assortmentname");
String assortmentmark = RecordSet.getString("assortmentmark");
String supassortmentid = RecordSet.getString("supassortmentid");
String supassortmentstr = RecordSet.getString("supassortmentstr");
String assortmentremark= RecordSet.getString("assortmentremark");
String subassortmentcount= RecordSet.getString("subassortmentcount");
String capitalcount= RecordSet.getString("capitalcount");
String roleid= RecordSet.getString("roleid");

boolean canedit = HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(831,user.getLanguage())+" : "+ Util.toScreen(assortmentname,user.getLanguage());
if(msgid!=-1){
titlename += "<font color=red size=2>" + SystemEnv.getErrorMsgName(msgid,user.getLanguage()) +"</font>" ;
}
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<% if(canedit) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("CptAssortment:Log", user)){
if(RecordSet.getDBType().equals("db2")){
 RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) = 43 and relatedid="+assortmentid+",_self} " ;  
}else{

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem = 43 and relatedid="+assortmentid+",_self} " ;
}
	
	RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM name=frmMain action=CptAssortmentOperation.jsp method=post >

<input type="hidden" name="assortmentid" value="<%=assortmentid%>">
<input type="hidden" name="supassortmentid" value="<%=supassortmentid%>">
<input type="hidden" name="supassortmentstr" value="<%=supassortmentstr%>">
<input type="hidden" name="operation">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<TABLE class=ViewForm>
			  <TBODY>
			  <TR>
				<TD vAlign=top><!-- General -->
					<TABLE class=ViewForm>
					 <TBODY> 
					  <TR class=Title> 
						<TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
					  </TR>
					  <TR class=Spacing style="height:2px"> 
						<TD class=Line1 colSpan=2></TD>
					  </TR>
					  <TR> 
						<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
						<td class=FIELD>
						<input accesskey=Z name=assortmentname size="30" onChange='checkinput("assortmentname","assortmentnameimage")' value="<%=Util.toScreenToEdit(assortmentname,user.getLanguage())%>" class="InputStyle">
						<span id=assortmentnameimage></span> </td>
					  </TR>
					  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
					  <TR> 
						<td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
						<td class=FIELD>
						<input accesskey=Z name=assortmentmark size="30" onChange='checkinput("assortmentmark","assortmentmarkimage")' value="<%=Util.toScreenToEdit(assortmentmark,user.getLanguage())%>" class="InputStyle">
						<span id=assortmentmarkimage></span> </td>
					  </TR>
					  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>          
					  </TBODY> 
					</TABLE>
				  </TD>
				</TR>
				<TR><TD>
				<TABLE class=Form>
				<TR class=Title> 
				  <TH><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px"> 
				  <TD class=Line1></TD>
				</TR>
				<TR><TD> 
				<TEXTAREA class="InputStyle" style="WIDTH: 100%" name=Remark rows=8><%=Util.toScreenToEdit(assortmentremark,user.getLanguage())%></TEXTAREA>
				</TD>
				</TR>
				</TBODY> 
			  </TABLE>
				</TD>
				</TR>
				</TBODY>
				</TABLE>
			 </FORM>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>

<script language=javascript>
 function onEdit(){
 	if(check_form(document.frmMain,'assortmentmark,assortmentname')){
 		document.frmMain.operation.value="editassortment";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="deleteassortment";
			document.frmMain.submit();
		}
}
 </script>

<SCRIPT language=VBS>
sub onShowRole(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub 
</script>
</BODY></HTML>
