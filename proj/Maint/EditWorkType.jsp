<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = request.getParameter("id");
	String referenced = request.getParameter("referenced");

	RecordSet.executeProc("Prj_WorkType_SelectByID",id);
	
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/proj/DBError.jsp?type=FindData");
		return;
	}
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/proj/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();

boolean canedit = HrmUserVarify.checkUserRight("EditWorkType:Edit",user);

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" ;
if (canedit) {
  titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(432,user.getLanguage());
} else {
  titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(432,user.getLanguage());
}
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<FORM id=weaver action="/proj/Maint/WorkTypeOperation.jsp" method=post onsubmit='return check_form(this,"type,desc")'>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("EditWorkType:Edit", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
}

if(HrmUserVarify.checkUserRight("EditWorkType:Delete", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="id" value="<%=id%>">
  
  
  
  
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

<TABLE class=viewform>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=inputstyle maxLength=50 size=20 name="type" onchange='checkinput("type","typeimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"><SPAN id=typeimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%>  <%}%></TD>
        </TR>
	<TR class=spacing style="height:1px;">
          <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=inputstyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><SPAN id=descimage></SPAN><%}else {%> <%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%> <%}%></TD>
         </TR> 
		 <TR style="height:1px;">
          <TD class=line colSpan=2></TD></TR>       
          
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(18632,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=inputstyle maxLength=150 size=50 name="txtWorktypecode"  value="<%=Util.null2String(RecordSet.getString("worktypeCode"))%>"><SPAN id=spanWorktypecode></SPAN><%}else {%> <%=Util.null2String(RecordSet.getString("worktypeCode"))%> <%}%></TD>
         </TR> 
		 <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>     

        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
	
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

</FORM>
<script language="javascript">
if ("<%=referenced%>"=="yes") {
	alert("<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>") ;
 }
function submitData()
{
	if (check_form(weaver,'type,desc'))
		weaver.submit();
}

function submitDel()
{
	if(isdel()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}
</script>
</BODY>
</HTML>
