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
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<LINK href="/css/BacoSystem.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function confirmdel() {
	return confirm("确定删除选定的信息吗?") ;
}
</script>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdReport.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: 错误信息</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="ErrorMsgOperation.jsp">
    <BUTTON class=btn id=btnEdit accessKey=E name=btnEdit onclick="editerrormsg()"><U>E</U>-编辑</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleteerrormsg()"><U>D</U>-删除</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="adderrormsg()"><U>A</U>-添加</BUTTON>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=5>错误信息信息</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=5></TD>
          </TR>
          <TR> 
            <TD>标识</TD>
            <TD Class=Field><%=id%></TD>
          </TR>
          <TR> 
            <TD>描叙</TD>
            <TD Class=Field><%=indexdesc%></TD>
          </TR>
          </TBODY> 
        </TABLE>
        <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="30%"> <COL width="30%"> <COL width="30%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=5>错误信息名称</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2 colSpan=3></TD>
          </TR>
          <TR> 
            <Td Class=Field>标识</Td>
            <Td Class=Field>语言</Td>
            <Td Class=Field>错误信息名称</Td>
          </TR>
<%
String errIfoSql="select ErrorMsgInfo.*,syslanguage.language from ErrorMsgInfo inner join syslanguage on ErrorMsgInfo.languageid=syslanguage.id where indexid=" + id;
rs.executeSql(errIfoSql);
/*
ErrorMsgInfoManager.resetParameter();
ErrorMsgInfoManager.setIndexid(id);
ErrorMsgInfoManager.selectErrorMsgInfo();
*/
while(rs.next())
{
	
	String msgname = rs.getString("msgname");
	int languageid=rs.getInt("id");
	
	
%>
         <TR> 
            <TD><%=id%></TD>
            <TD><%=rs.getString("language")%></TD>
            <TD><%=msgname%></TD>
          </TR>
<%
}
//ErrorMsgInfoManager.closeStatement();
%>
<input type="hidden" name="operation" value="deleteerrormsg">
<input type="hidden" name="delete_errormsg_id" value="<%=id%>">
      </FORM>
<script>
function deleteerrormsg(){
	if(confirmdel()) {
		document.frmView.submit();
	}
}
function adderrormsg() {	
	location="AddErrorMsg.jsp";
}
function editerrormsg() {	
	location="EditErrorMsg.jsp?id=<%=id%>&indexdesc=<%=indexdesc%>";
}
</script>
      </BODY>
      </HTML>
