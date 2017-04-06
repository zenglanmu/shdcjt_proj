<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<html>
<%
String searchcon="";
	searchcon = Util.fromScreen(request.getParameter("searchcon"),user.getLanguage());
%>
<head>
<LINK href="/css/BacoSystem.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function CheckAll(checked) {
len = document.frmSearch.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.frmSearch.elements[i].name=='delete_errormsg_id') {
document.frmSearch.elements[i].checked=(checked==true?true:false);
} } }


function unselectall()
{
    if(document.frmSearch.checkall0.checked){
	document.frmSearch.checkall0.checked =0;
    }
}
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
    <TD align=left width=55><IMG height=24 src="/images/hdDOCSearch.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>搜索: 错误信息</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmSearch method=post action="ErrorMsgOperation.jsp">
    <BUTTON class=btn id=btnSearch accessKey=S name=btnSearch type=submit onclick="searcherrormsg()"><U>S</U>-搜索</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="adderrormsg()"><U>A</U>-添加</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleteerrormsg()"><U>D</U>-删除</BUTTON>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="5%"> <COL width="32%"> <COL width=1> <COL width="10%"> <COL width="32%"> <TBODY> 
          <TR class=Section> 
            <TH colSpan=5>搜索条件</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=5></TD>
          </TR>
          <TR> 
            <TD>错误信息描叙</TD>
            <TD Class=Field colspan=4> 
              <INPUT class=FieldxLong name="searchcon" value="<%=Util.toScreen(request.getParameter("searchcon"),user.getLanguage(),"0")%>">
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
        <br>
        <TABLE class=ListShort>
          <COLGROUP> <COL width="10%"> <COL width="30%"> <COL width="30%"> <COL width="30%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=5>搜索结果</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2 colSpan=4></TD>
          </TR>
          <TR class=Header> 
            <Td Class=Field></Td>
            <Td Class=Field>标识</Td>
            <Td Class=Field>描叙</Td>
            <Td Class=Field>细节</Td>
          </TR>
<%
String SearchSql="";
if (searchcon.equalsIgnoreCase("")){
SearchSql="select * from ErrorMsgIndex order by id asc";
}
else
{
SearchSql="select * from ErrorMsgIndex where indexdesc like '%" +searchcon+"%' order by id asc"; 
}
RecordSet.executeSql(SearchSql);
boolean isLight = false;
if(RecordSet.last())
{
do
{
if(isLight)
		{%>	
	<TR CLASS="DataDark">
<%}else{%>
	<TR CLASS="DataLight">
<%}%>
    
            <TD><input type="checkbox" name="delete_errormsg_id" value="<%=RecordSet.getInt("id")%>" onClick=unselectall()></TD>
            <TD><%=RecordSet.getInt("id")%></TD>
            <TD><%=RecordSet.getString("indexdesc")%></TD>
            <TD><a href="ViewErrorMsg.jsp?id=<%=RecordSet.getInt("id")%>&indexdesc=<%=RecordSet.getString("indexdesc")%>"><img src="/images/iedit.gif" width="16" height="16" border="0"></a></TD>
          </TR>
    
<%
isLight = !isLight;
}while(RecordSet.previous());
}

%>
<TR class=Separator> 
            <TD class=sep2 colSpan=4>
            <input type="hidden" name="operation" value="search">
            </TD>
          </TR>
<tr>
          </TBODY> 
        </TABLE>
        <br>
        <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">全部选中
      </FORM>
<script>
function adderrormsg() {	
	location="AddErrorMsg.jsp";
}
function searcherrormsg() {
	document.frmSearch.operation.value="search";
	document.frmSearch.submit();
}
function deleteerrormsg() {
	document.frmSearch.operation.value="deleteerrormsg";
	if(confirmdel())
		document.frmSearch.submit();
}
</script>
      </BODY>
      </HTML>
