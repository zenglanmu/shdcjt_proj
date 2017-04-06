<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<%
	String indexdesc="";
	int id;
	indexdesc = Util.toScreen(request.getParameter("indexdesc"),user.getLanguage(),"0");
	id = Util.getIntValue(request.getParameter("id"),0);
%>
<head>
<LINK href="/css/BacoSystem.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOC.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>编辑: 提示</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="NoteOperation.jsp">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>E</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=5>提示信息</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=5></TD>
          </TR>
          <TR> 
            <TD>标识</TD>
            <TD Class=Field><%=id%><input type="hidden" name="id" value="<%=id%>"></TD>
          </TR>
          <TR> 
            <TD>描叙</TD>
            <TD Class=Field><INPUT class=FieldxLong name=indexdesc value="<%=indexdesc%>"></TD>
          </TR>
          </TBODY> 
        </TABLE>
        <br>
        <TABLE class=Form>
          <COLGROUP><COL width="50%"> <COL width="50%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=2>提示名称</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2 colSpan=2></TD>
          </TR>
          <TR> 
            <Td Class=Field>语言</Td>
            <Td Class=Field>提示名称</Td>
          </TR>
<%
String noteIfoSql="select HtmlNoteInfo.*,syslanguage.language,syslanguage.id from HtmlNoteInfo inner join syslanguage on HtmlNoteInfo.languageid=syslanguage.id where indexid=" + id;
rs.executeSql(noteIfoSql);
/*
NoteInfoManager.resetParameter();
NoteInfoManager.setIndexid(id);
NoteInfoManager.selectNoteInfo();
*/
while(rs.next())
{
	String notename = rs.getString("notename");
	int languageid=rs.getInt("id");
%>
          <TR> 
            <Td><%=rs.getString("language")%></Td>
            <Td><INPUT class=FieldLong name="notename<%=languageid%>" value="<%=notename%>"></Td>
          </TR>
<%
}
%>
<input type="hidden" name="operation" value="editnote">

      </FORM>
      </BODY>
      </HTML>
