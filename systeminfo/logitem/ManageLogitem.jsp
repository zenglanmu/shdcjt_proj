<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<html>
<%
	String searchcon="";
	searchcon = Util.fromScreen(request.getParameter("searchcon"),user.getLanguage());
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function CheckAll(checked) {
len = document.frmDelete.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.frmDelete.elements[i].name=='delete_logitem_id') {
document.frmDelete.elements[i].checked=(checked==true?true:false);
} } }


function unselectall()
{
    if(document.frmDelete.checkall0.checked){
	document.frmDelete.checkall0.checked =0;
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
      <TD align=left><SPAN id=BacoTitle class=titlename>搜索: 日志项目</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
    <FORM style="MARGIN-TOP: 0px" name=frmSearch method=post action="ManageLogitem.jsp">
    <BUTTON class=btn id=btnSearch accessKey=S name=btnSearch type=submit onclick="searchlogitem()"><U>S</U>-搜索</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addlogitem()"><U>A</U>-添加</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deletelogitem()"><U>D</U>-删除</BUTTON>
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
            
      <TD>日志项目名称</TD>
            <TD Class=Field colspan=4> 
              <INPUT class=FieldxLong name=searchcon accessKey=Z value="<%=searchcon%>">
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
	  </form>
      <br>
	  <FORM style="MARGIN-TOP: 0px" name=frmDelete method=post action="LogitemOperation.jsp">
	  <input type="hidden" name="operation" value="deletelogitem">
        <TABLE  class=ListShort>
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
RecordSet.executeProc("SystemLogItem_Select","%"+searchcon+"%");
boolean isLight = false;
if (RecordSet.last()){
do
{
		String id = RecordSet.getString(1);
		String itemname = Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
if(isLight)
		{%>	
	<TR CLASS="DataDark">
<%}else{%>
	<TR CLASS="DataLight">
<%}%>
            <TD><input type="checkbox" name="delete_logitem_id" value="<%=id%>" onClick=unselectall()></TD>
            <TD><%=id%></TD>
            <TD><%=itemname%></TD>
            <TD><a href="ViewLogitem.jsp?id=<%=id%>"><img src="/images/iedit.gif" width="16" height="16" border="0"></a></TD>
          </TR>
    
<%
isLight = !isLight;
}while(RecordSet.previous());
}
%>
		  <TR class=Separator> 
            <TD class=sep2 colSpan=4></TD>
          </TR>
          </TBODY> 
        </TABLE>
        <br>
        <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">全部选中
      </FORM>
<script>
function addlogitem() {	
	location="AddLogitem.jsp";
}
function searchlogitem() {
	document.frmSearch.submit();
}
function deletelogitem() {
	if(confirmdel())
		document.frmDelete.submit();
}
</script>
      </BODY>
      </HTML>
