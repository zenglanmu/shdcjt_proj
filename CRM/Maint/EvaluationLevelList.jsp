<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
boolean canedit = HrmUserVarify.checkUserRight("CRM_EvaluationAdd:Add",user);
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript">
function checkSubmit(){
    if(isdel()){
        weaverD.submit();
    }
}
</script>
</HEAD>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6070,user.getLanguage())+SystemEnv.getHtmlLabelName(324,user.getLanguage());
String needfav ="1";
String needhelp ="";

String name="";
String levelvalue="";
String id=Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	RecordSet.executeProc("CRM_Evaluation_L_SelectById",id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 levelvalue=Util.null2String(RecordSet.getString("levelvalue"));
	}
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


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

<%
if(msgid!=-1) {
%>
<DIV>
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</FONT>
</DIV >
<%}%>

<%
if(canedit){
%>
<FORM id=weaver action="/CRM/Maint/EvaluationLevelOperation.jsp" method=post >
<%if(id.equals("")){%>
	<input type="hidden" name="method" value="add">
<%}else{%>
	<input type="hidden" name="method" value="edit">
<%}%>
<input type="hidden" name="id" value="<%=id%>">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
		<TR >
        <TD colSpan=2>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave1(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
		</TD></TR>
        
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD>
	    </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")' value="<%=name%>"><SPAN id=nameimage><%if(name.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6072,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=3 size=10 name="levelvalue" onchange='checkinput("levelvalue","levelvalueimage")' value="<%=levelvalue%>"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("levelvalue")'><SPAN id=levelvalueimage><%if(levelvalue.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
</FORM>
<FORM id=weaverD action="/CRM/Maint/EvaluationLevelOperation.jsp" method=post>
<input type="hidden" name="method" value="delete">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
           <TR>
          <TD colSpan=2>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	  
		  </TD>
        </TR>
  </TBODY>
</TABLE>
<%}%>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="5%">
  <COL width="25%">
  <COL width="70%">
  <TBODY>
  <TR class=Header>
  <th></th>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6072,user.getLanguage())%></th>
  </tr>
<TR class=Line><TD colSpan=3 style="padding: 0"></TD></TR>
<%
RecordSet.executeProc("CRM_Evaluation_L_Select","");
boolean isLight = false;
	while(RecordSet.next())	{	
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
		<th width=10><%if(canedit){%><input type=checkbox name=CRM_EvaluationIDs value="<%=RecordSet.getString("id")%>"><%}%></th>
		<TD><a href="/CRM/Maint/EvaluationLevelList.jsp?id=<%=RecordSet.getString("id")%>"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString("levelvalue"),user.getLanguage())%></TD>
	</TR>
<%
	}
%>
 </TABLE>
<%if(canedit){
%>
</FORM>
<%}%>
<script language=javascript>
function doSave1(){	
	if (check_form(document.forms[0],"name,proportion")) 
	document.forms[0].submit();
	}
</script>

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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY>
</HTML>
