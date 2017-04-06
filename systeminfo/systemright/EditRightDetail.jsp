<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<html>
<%
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("SystemRightDetail_SelectByID",id);
	RecordSet.next();
	String rightdetailname = Util.toScreenToEdit(RecordSet.getString("rightdetailname"),user.getLanguage()) ;
	String rightdetail = Util.toScreenToEdit(RecordSet.getString("rightdetail"),user.getLanguage()) ;
	String rightid = Util.null2String(RecordSet.getString("rightid")) ;
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOC.gif"></TD>
      <TD align=left><SPAN id=BacoTitle class=titlename>编辑: 权限详细</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=right method=post action="RightDetailOperation.jsp">
    <input type="hidden" name="operation" value="updaterightdetail">
    <input type="hidden" name="id" value="<%=id%>">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>E</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
   
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2>权限详细信息</TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD>名称</TD>
      <TD Class=Field> 
        <input accesskey=Z name=rightdetailname size="30" value="<%=rightdetailname%>">
      </TD>
    </TR>
    <tr> 
      <td>详细</td>
      <td class=Field> 
        <input type="text" accesskey="Z" name="rightdetail" size="60" value="<%=rightdetail%>">
      </td>
    </tr>
    <tr> 
      <td>所属权限</td>
      <td class=Field>
	  <BUTTON class=Browser id=SelectRightID onClick="onShowRightID()"></BUTTON> 
        <SPAN id=rightidspan><%=Util.toScreen(RightComInfo.getRightname(rightid,""+user.getLanguage()),user.getLanguage())%></SPAN> 
        <INPUT id=rightid type=hidden name=rightid value="<%=rightid%>" >
	  </td>
    </tr>
    </TBODY> 
  </TABLE>
  </FORM>
<script language=vbs>
sub onShowRightID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/systemright/SystemRightBrowser.jsp")
	if (Not IsEmpty(id))  then
	if id(0)<> "" then
	rightidspan.innerHtml = id(1)
	right.rightid.value=id(0)
	else 
	rightidspan.innerHtml = ""
	right.rightid.value=""
	end if
	end if
end sub
</script> 
</BODY>
</HTML>
