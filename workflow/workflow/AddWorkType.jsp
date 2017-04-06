<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16579,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver action="WorkTypeOperation.jsp" method=post >



  <input type="hidden" name="method" value="add">

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

<TABLE class="viewform">
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class="viewform">
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR class="Title">
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class="Spacing" style="height:1px;">
          <TD class="Line1" colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=Inputstyle maxLength=50 size=20 name="type" onchange='checkinput("type","typeimage")'><SPAN id=typeimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR> <TR class="Spacing" style="height:1px;">
          <TD class="Line" colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=Inputstyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")'><SPAN id=descimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
         </TR>   <TR class="Spacing" style="height:1px;">
          <TD class="Line" colSpan=2></TD></TR>
          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=Inputstyle maxLength=3 size=20 name="dsporder" value="0" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'></TD>
         </TR>   <TR class="Spacing" style="height:1px;">
          <TD class="Line1" colSpan=2></TD></TR>
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
<iframe id="checkType" src="" style="display: none"></iframe>
</FORM>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'type,desc')){
	    //通过iframe验证类型名称是否重复
		document.getElementById("checkType").src="/workflow/workflow/WorkTypeOperation.jsp?method=valRepeat&type="+myescapecode(document.all("type").value);
    }
}
function onReturn(){
	location="/workflow/workflow/ListWorkType.jsp";
}

//类型名称已经存在
function typeExist(){
    alert("<%=SystemEnv.getHtmlLabelName(24256,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
    return ;
}

//提交表单
function submitForm(){
    weaver.submit();
}

</script>
</BODY>
</HTML>
