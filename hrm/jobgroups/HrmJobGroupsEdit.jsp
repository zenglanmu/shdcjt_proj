<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
 rs.executeProc("HrmJobGroups_SelectById",""+id);
 
 	String jobgroupname = "";	
	String jobgroupremark = "";
 if(rs.next()){	
	jobgroupname = Util.toScreenToEdit(rs.getString("jobgroupname"),user.getLanguage());	
	jobgroupremark = Util.toScreenToEdit(rs.getString("jobgroupremark"),user.getLanguage());
}

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(805,user.getLanguage())+":"+jobgroupname;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmJobGroupsEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobGroupsAdd:Add", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/jobgroups/HrmJobGroupsAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobGroupsEdit:Delete", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobGroups:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=24 and relatedid="+id+",_self} " ;
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

<FORM id=weaver name=frmMain action="JobGroupsOperation.jsp" method=post>

<%
String isdisable = "";
if(!canEdit)
	isdisable = " disabled";
%>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD></TR>
    <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
          <TD class=Field>
          <%if(canEdit){%><INPUT class=inputstyle type=text  name="jobgroupname"   value="<%=jobgroupname%>" onchange='checkinput("jobgroupname","jobgroupnameimage")'>
          <%}else{%><%=jobgroupname%><%}%><SPAN id=jobgroupnameimage></SPAN></TD>
    </TR>
              <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
      <TD class=FIELD>
      <%if(canEdit){%><input class=inputstyle type=text name=jobgroupremark value="<%=jobgroupremark%>">
      <%}else{%><%=jobgroupremark%><%}%>
      </TD>
    </TR>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        
 </TBODY></TABLE>
 
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=id value="<%=id%>">
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

 <script language=vbs>
sub showDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		frmMain.docid.value=id(0)&""
		docidname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"	
	end if	
end sub
</script>

 <script language=javascript>
 function onSave(){
	if(check_form(document.frmMain,'jobgroupmark,jobgroupname')){
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script>
</BODY></HTML>
