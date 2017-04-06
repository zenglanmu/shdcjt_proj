<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<% if(!HrmUserVarify.checkUserRight("HrmCheckItemAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(6117,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
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
<FORM name=awardtype id=awardtype action="HrmCheckItemOperation.jsp" method=post >
<input class=inputstyle type=hidden name=operation value="add">
<TABLE class=ViewForm>
  <COLGROUP> <COL width="15%"><COL width="85%"> <TBODY> 
  <TR class=Title> 
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing style="height:2px"> 
    <TD class=Line1 colSpan=2></TD>
  </TR>
  <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(15753,user.getLanguage())%></TD>
    <TD class=Field> 
      <INPUT class=InputStyle maxLength=30 size=30 name="checkitemname" onchange='checkinput("checkitemname","checkitemnamespan")'>
      <SPAN id=checkitemnamespan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> 
    </TD>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <TR> 
    <TD height="47"><%=SystemEnv.getHtmlLabelName(15754,user.getLanguage())%></TD>
    <td  class=Field > 
      <textarea class=InputStyle style="WIDTH: 50%" name=checkitemexplain rows=4></textarea>
    </td>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  </TBODY> 
</TABLE>      
</FORM>
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
function submitData() {
 if(check_form(awardtype,'checkitemname')){
 awardtype.submit();
 }
}
function doBack(){
	location = "HrmCheckItem.jsp";
  }
</script>
</BODY>
</HTML>