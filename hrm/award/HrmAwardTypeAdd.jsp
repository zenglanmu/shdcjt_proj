<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<% if(!HrmUserVarify.checkUserRight("HrmRewardsTypeAdd:Add",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(6099,user.getLanguage());
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

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/award/HrmAwardType.jsp,_self} " ;
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
<FORM name="frmMain" id="frmMain" action="HrmAwardTypeOperation.jsp" method=post >
<input class=inputstyle type=hidden name=operation value="add">
<TABLE class=ViewForm>
  <COLGROUP> <COL width="15%"><COL width="85%"> <TBODY> 
  <TR class=Title> 
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing style="height:2px"> 
    <TD class=Line1 colSpan=2></TD>
  </TR>
  <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%></TD>
    <TD class=Field> 
      <INPUT class=InputStyle maxLength=60 size=30 name="name" onchange='checkinput("name","namespan")'>
      <SPAN id=namespan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> 
    </TD>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr> 
    <td><%=SystemEnv.getHtmlLabelName(808,user.getLanguage())%></td>
    <td class=Field> 
      <select class=InputStyle name=awardtype value="0">
        <option value="0"><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%></option>
        <option value="1"><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%></option>
      </select>
    </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
    <TD><%=SystemEnv.getHtmlLabelName(15667,user.getLanguage())%></TD>
    <td  class=Field > 
     <textarea class=InputStyle style="WIDTH: 50%" name="description" rows=4></textarea>
    </td>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <TR> 
    <TD height="47"><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></TD>
    <td  class=Field >
      <textarea class=InputStyle style="WIDTH: 50%" name="transact" rows=4></textarea>
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
 var maxlength= 100;
 if(check_form(frmMain,'name')&&checkTextLength(frmMain.description,maxlength)&&checkTextLength(frmMain.transact,maxlength)){
 frmMain.submit();
 }
}

function checkTextLength(textObj,maxlength){
    var len = trim(jQuery(textObj).html()).length
    if(len >  maxlength){
        alert("文本筐的文本长度不能超过"+maxlength);
        return false;
    }
    return true;
  }
 /**
 * trim function ,add by Huang Yu
 */
 function trim(value) {
   var temp = value;
   
   var obj = /^(\s*)([\W\w]*)(\b\s*$)/;
   if (obj.test(temp)) { temp = temp.replace(obj, '$2'); }
   return temp;
}


</script>
</BODY>
</HTML>