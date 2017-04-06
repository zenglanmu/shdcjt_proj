<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="LabelInfoManager" class="weaver.systeminfo.label.LabelInfoManager" scope="page"/>
<jsp:useBean id="LabelMainManager" class="weaver.systeminfo.label.LabelMainManager" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
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
    <TD align=left><SPAN id=BacoTitle class=titlename>编辑: 标签</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="LabelOperation.jsp">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>E</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=5>标签信息</TH>
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
            <TH colSpan=2>标签名称</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2 colSpan=2></TD>
          </TR>
          <TR> 
            <Td Class=Field>语言</Td>
            <Td Class=Field>标签名称</Td>
          </TR>
<%
LabelInfoManager.resetParameter();
LabelInfoManager.setIndexid(id);
LabelInfoManager.selectLabelInfo();
while(LabelInfoManager.next())
{
	String labelname = Util.toScreenToEdit(LabelInfoManager.getLabelname(),user.getLanguage());
	int languageid=LabelInfoManager.getLanguageid();
%>
          <TR> 
            <Td><%=Util.toScreen(LanguageComInfo.getLanguagename(""+languageid),user.getLanguage())%></Td>
            <Td><INPUT class=FieldLong name="labelname<%=languageid%>" value="<%=labelname%>"></Td>
          </TR>
<%
}
%>
<input type="hidden" name="operation" value="editlabel">

      </FORM>
      </BODY>
      </HTML>
