<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<html>
<%
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("SystemRights_SelectByID",id);
	RecordSet.next()  ;
	String righttype = RecordSet.getString("righttype");
	String rightdescown = Util.toScreenToEdit(RecordSet.getString("rightdesc"),user.getLanguage());
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
      <TD align=left><SPAN id=BacoTitle class=titlename>编辑:权限</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="RightOperation.jsp">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>E</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
        
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2>权限信息</TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD>标识</TD>
      <TD Class=Field><%=id%>
        <input type="hidden" name="id" value="<%=id%>">
      </TD>
    </TR>
    <tr> 
      <td>种类</td>
      <td class=Field> 
        <select name="righttype">
          <option value="0" <% if(righttype.equals("0")) {%>selected<%}%>>CRM</option>
          <option value="1" <% if(righttype.equals("1")) {%>selected<%}%>>文档</option>
          <option value="2" <% if(righttype.equals("2")) {%>selected<%}%>>财务</option>
          <option value="3" <% if(righttype.equals("3")) {%>selected<%}%>>人力资源</option>
          <option value="4" <% if(righttype.equals("4")) {%>selected<%}%>>物流</option>
          <option value="5" <% if(righttype.equals("5")) {%>selected<%}%>>工作流</option>
          <option value="6" <% if(righttype.equals("6")) {%>selected<%}%>>项目</option>
          <option value="7" <% if(righttype.equals("7")) {%>selected<%}%>>系统</option>
        </select>
      </td>
    </tr>
    <TR> 
      <TD>描叙</TD>
      <TD Class=Field>
        <INPUT class=FieldxLong name=rightdescown value="<%=rightdescown%>">
      </TD>
    </TR>
    </TBODY> 
  </TABLE>
        <br>
        
  <TABLE class=Form>
    <COLGROUP><COL width="30%"> <COL width="70%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=3>详细信息</TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep2 colSpan=3></TD>
    </TR>
    <TR> 
      <Td Class=Field>语言</Td>
      <Td Class=Field colspan="2">权限</Td>
    </TR>
    <%
RecordSet.executeProc("SystemRightsLanguage_SByID",id);
while(RecordSet.next())
{
	String rightname = Util.toScreen(RecordSet.getString("rightname"),user.getLanguage());
	String rightdesc = Util.toScreen(RecordSet.getString("rightdesc"),user.getLanguage());
	String languageid= RecordSet.getString("languageid") ;
%>
    <TR> 
      <Td rowspan="2" valign="top"><%=Util.toScreen(LanguageComInfo.getLanguagename(""+languageid),user.getLanguage())%></Td>
      <Td>名称</Td>
      <Td>
        <input type="text" name="rightname<%=languageid%>" value="<%=rightname%>">
      </Td>
    </TR>
    <TR> 
      <Td>描述</Td>
      <Td>
        <input type="text" name="rightdesc<%=languageid%>" size="30" value="<%=rightdesc%>">
      </Td>
    </TR>
    <%
}
%>
  </table>
<input type="hidden" name="operation" value="editright">
      </FORM>
      </BODY>
      </HTML>
