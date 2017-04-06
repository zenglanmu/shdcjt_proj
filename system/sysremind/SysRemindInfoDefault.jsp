<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ include file="/systeminfo/init.jsp" %>

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18121,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
</HEAD>
</HTML>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
    <td height="10" colspan="3"></td>
</tr>
<tr>
    <td ></td>
    <td valign="top">
        <TABLE class=Shadow>
        <tr>
        <td valign="top">
        <TABLE class=ViewForm>
        <COLGROUP>
        <COL width="30px">
        <COL>
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%= SystemEnv.getHtmlLabelName(19010,user.getLanguage()) %>
            </TH>
        </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD>
        </TR>
        <TR>
          <TD height="5" colSpan=2></TD>
        </TR>
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD><%= SystemEnv.getHtmlLabelName(19091,user.getLanguage()) %></TD>
        </TR>
        <TR>
          <TD>&nbsp</TD>
        </TR>
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD><%= SystemEnv.getHtmlLabelName(19092,user.getLanguage()) %></TD>
        </TR>
        <TR>
          <TD>&nbsp</TD>
        </TR>       
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD><%= SystemEnv.getHtmlLabelName(19093,user.getLanguage()) %></TD>
        </TR>
        </table>
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
