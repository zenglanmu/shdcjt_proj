<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOC.gif"></TD>
      <TD align=left><SPAN id=BacoTitle class=titlename>添加: 日志项目</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="LogitemOperation.jsp">
    <input type="hidden" name="operation" value="addlogitem">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>S</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
        
  <TABLE class=Form>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2>日志项目信息</TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
    <tr> 
      <td>标识</td>
   
      <td class=Field> 
        <input name=itemid size="10">
      </td>
    </tr>
    <tr> 
      <td>标签标识</td>
      <td class=Field> 
        <input type="text" name="lableid" size="10" value="">
      </td>
    </tr>
    <tr> 
      <td>描叙</td>
      <td class=Field> 
        <input type="text" name="itemdesc" size="30" value="">
      </td>
    </tr>
    </TBODY> 
  </TABLE>
</FORM>
      </BODY>
      </HTML>
