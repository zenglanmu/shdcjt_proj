<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
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
      <TD align=left><SPAN id=BacoTitle class=titlename>添加: 权限</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="RightOperation.jsp">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>S</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
        
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2>权限描述</TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
    <tr> 
      <td>种类</td>
      <td class=Field>
        <select name="righttype">
          <option value="0">CRM</option>
		  <option value="1">文档</option>
		  <option value="2">财务</option>
		  <option value="3">人力资源</option>
		  <option value="4">物流</option>
		  <option value="5">工作流</option>
		  <option value="6">项目</option>
		  <option value="7">系统</option>
        </select>
      </td>
    </tr>
    <TR> 
      <td>描叙</td>
      <td class=Field> 
        <input accesskey=Z name=rightdescown>
      </td>
    </TR>
    </TBODY> 
  </TABLE>
		<br>
        
  <TABLE class=Form>
    <COLGROUP><COL width="30%"> <COL width="70%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=3>权限细节</TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep2 colSpan=3></TD>
    </TR>
    <TR> 
      <Td Class=Field>语言</Td>
      <Td Class=Field colspan="2">权限</Td>
    </TR>
    <%
while(LanguageComInfo.next()){
	String langid = LanguageComInfo.getLanguageid();
	String langname = Util.toScreen(LanguageComInfo.getLanguagename(),user.getLanguage());
%>
    <TR> 
      <Td rowspan="2" valign="top"><%=langname%></Td>
      <Td width="15%">名称</Td>
      <Td class=Field>
        <input type="text" name="rightname<%=langid%>">
      </Td>
    </TR>
    <TR> 
      <Td width="15%">描述</Td>
      <Td class=Field>
        <input type="text" name="rightdesc<%=langid%>" size="30">
      </Td>
    </TR>
    <%
}
%>
  </table>
<input type="hidden" name="operation" value="addright">

      </FORM>
      </BODY>
      </HTML>
