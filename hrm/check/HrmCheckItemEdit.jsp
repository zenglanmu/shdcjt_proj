<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String id = request.getParameter("id");
//System.out.println("id:"+id);

String checkitemname="";
String checkitemexplain="";
RecordSet.executeProc("HrmCheckItem_SByid",id);
if(RecordSet.next()){
checkitemname = RecordSet.getString("checkitemname");
checkitemexplain = Util.toScreenToEdit(RecordSet.getString("checkitemexplain"),user.getLanguage());
}


String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6117,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;

if(!HrmUserVarify.checkUserRight("HrmCheckItemEdit:Edit", user)){
	titlename = SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6117,user.getLanguage());
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCheckItemEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCheckItemAdd:Add",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/check/HrmCheckItemAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCheckItemEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/check/HrmCheckItem.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=frmMain name=frmMain action="HrmCheckItemOperation.jsp" method=post>
<%
String isdisable = "";
if(!canEdit)
	isdisable = " disabled";
%>
<TABLE class=ViewFORM>
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR class=HEADER>
      <TH align=left><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%>
      </TH>    
  </TR>
  <TR class=Spacing  style="height:2px">
    <TD class=Line1></TD>    
  </TR>
  <TR>
  <TD vAlign=top>
  <TABLE class=ViewFORM>
   <TBODY>
    <TR>
      <TD width="20%"><%=SystemEnv.getHtmlLabelName(15753,user.getLanguage())%></TD>
      <TD class=Field><%if(canEdit){%>
      <input class=inputstyle type=text size=30 name="checkitemname" value="<%=checkitemname%>" onchange='checkinput("checkitemname","checkitemnameimage")'>
      <%}else{%><%=checkitemname%><%}%>
      <SPAN id=checkitemnameimage></SPAN></TD>
    </tr>   
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR>
      <TD  width="20%"><%=SystemEnv.getHtmlLabelName(15754,user.getLanguage())%></TD>
      <TD class=Field> <%if(canEdit){%>
      <TEXTAREA class=inputstyle style="WIDTH: 50%" name="checkitemexplain" rows=6><%=checkitemexplain%></TEXTAREA><%}else{%><%=checkitemexplain%><%}%>
      <SPAN id=checkitemexplain></SPAN></TD>
    </tr>     
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>  </TBODY>
 </TABLE>
 </TD> 
   <input class=inputstyle type="hidden" name=operation value="edit">
   <input class=inputstyle type="hidden" name=id value="<%=id%>">
 </form> 
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
 <script language=javascript>
 var canDelete="<%=Util.null2String(request.getParameter("isDelete"))%>";
 if(canDelete=="no")alert("<%=SystemEnv.getHtmlLabelName(21151,user.getLanguage())%>");
 function onSave(){
	if(check_form(frmMain,'checkitemname')){
	 	
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
</BODY>
</HTML>