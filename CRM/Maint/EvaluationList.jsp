<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
boolean canedit = HrmUserVarify.checkUserRight("CRM_EvaluationAdd:Add",user);
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6070,user.getLanguage())+SystemEnv.getHtmlLabelName(101,user.getLanguage());
String needfav ="1";
String needhelp ="";

String name="";
String proportionstr="";
String id=Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	RecordSet.executeProc("CRM_Evaluation_SelectById",id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 proportionstr=Util.null2String(RecordSet.getString("proportion"));
	}
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(canedit){
	if(id.equals("")){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doSave1(),_top} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}else{
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave1(),_top} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:document.weaverD.submit(),_top} " ;
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
<%
if(canedit){
%>
<FORM id=weaver action="/CRM/Maint/EvaluationOperation.jsp" method=post >
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
		</TD></TR>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD>
	    </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")' value="<%=name%>"><SPAN id=nameimage><%if(name.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=3 size=10 name="proportion" onchange='checkinput("proportion","proportionimage")' value="<%=proportionstr%>"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("proportion")'>%<SPAN id=proportionimage><%if(proportionstr.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
</FORM>
<FORM id=weaverD name="weaverD" action="/CRM/Maint/EvaluationOperation.jsp" method=post>
<input type="hidden" name="method" value="delete">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
           <TR>
          <TD colSpan=2>
		  <BUTTON class=btnDelete id=Delete accessKey=D type=submit style="display:none" onclick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
	  
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
  <th><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></th>
  </tr>
<TR class=Line><TD colSpan=3 style="padding: 0"></TD></TR>
<%
int proportionint = 0;
RecordSet.executeProc("CRM_Evaluation_Select","");
boolean isLight = false;
	while(RecordSet.next())
	{	proportionint += Util.getIntValue(RecordSet.getString("proportion"),0);
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
		<th width=10><%if(canedit){%><input type=checkbox name=CRM_EvaluationIDs value="<%=RecordSet.getString("id")%>"><%}%></th>
		<TD><a href="/CRM/Maint/EvaluationList.jsp?id=<%=RecordSet.getString("id")%>"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString("proportion"),user.getLanguage())%>%</TD>
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
	var proportionint=0;
	var proportionint1=0;
	proportionstr = "<%=proportionstr%>"
	proportionint = <%=proportionint%> ;
	proportionint1 = eval(document.all("proportion").value) ;
	proportionint = proportionint + proportionint1;
	if (proportionstr!="") proportionint = proportionint - eval(proportionstr); 
	if (check_form(document.forms[0],"name,proportion")) {
    if(proportionint>100){
        alert("<%=SystemEnv.getHtmlLabelName(15223,user.getLanguage())%>100%");
        return;}
	else
	document.forms[0].submit();
	}
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
</BODY>
</HTML>
