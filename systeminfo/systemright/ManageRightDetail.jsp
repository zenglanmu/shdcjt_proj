<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function CheckAll(checked) {
len = document.frmDelete.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.frmDelete.elements[i].name=='delete_rightdetail_id') {
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
<%
	String searchcon="";
    String searchkey="";
	searchcon = Util.toScreen(request.getParameter("searchcon"),user.getLanguage());
    searchkey = Util.toScreen(request.getParameter("searchkey"),user.getLanguage());
%>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOCSearch.gif"></TD>
      <TD align=left><SPAN id=BacoTitle class=titlename>搜索: 权限详细</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
    <FORM style="MARGIN-TOP: 0px" name=frmSearch method=post action="ManageRightDetail.jsp">
    <BUTTON class=btn id=btnSearch accessKey=S name=btnSearch type=submit><U>S</U>-搜索</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addrightdetail()"><U>A</U>-添加</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleterightdetail()"><U>D</U>-删除</BUTTON>
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
                <TD>权限详细名称</TD>
                <TD Class=Field colspan=4>
                  <INPUT class=FieldxLong name=searchcon accessKey=Z value="<%=searchcon%>">
                </TD>
            </TR>
            <TR>
                <TD>权限详细关键字</TD>
                <TD Class=Field colspan=4>
                  <INPUT class=FieldxLong name=searchkey accessKey=Z value="<%=searchkey%>">
                </TD>
            </TR>
          </TBODY>
        </TABLE>
	  </form>
      <br>
	  <FORM style="MARGIN-TOP: 0px" name=frmDelete method=post action="RightDetailOperation.jsp">
	  <input type="hidden" name="operation" value="deleterightdetail">
        <TABLE class=Form>
          <COLGROUP> <COL width="8%"> <COL width="22%"> <COL width="22%"> <COL width="22%"><COL width="22%"><TBODY>
          <TR class=Section>
            <TH colSpan=7>搜索结果</TH>
          </TR>
          <TR class=Separator>
            <TD class=sep2 colSpan=7></TD>
          </TR>
          <TR>
            <Td Class=Field></Td>
            <Td Class=Field>标识</Td>
            <Td Class=Field>名称</Td>
            <Td Class=Field>权限详细关键字</Td>
            <Td Class=Field>所属权限</Td>
          </TR>
<%
String sqlStr="";
searchkey=searchkey.trim() ;
searchcon=searchcon.trim() ;
sqlStr="select * from SystemRightDetail ";
sqlStr+=" where rightdetailname like '%"+searchcon+"%' ";
if (!searchkey.equals(""))   sqlStr+=" and rightdetail like '%"+searchkey+"%' ";
sqlStr+=" order by rightid ";
RecordSet.executeSql(sqlStr);
while(RecordSet.next())
{
		String id = RecordSet.getString("id");
		String rightdetailname = Util.toScreen(RecordSet.getString("rightdetailname"),user.getLanguage()) ;
        String rightdetail = Util.toScreen(RecordSet.getString("rightdetail"),user.getLanguage()) ;
        String rightname = RightComInfo.getRightname(RecordSet.getString("rightid"),""+user.getLanguage()) ;
%>
         <TR>
            <TD><input type="checkbox" name="delete_rightdetail_id" value="<%=id%>" onClick=unselectall()></TD>
            <TD><%=id%></TD>
            <TD><%=rightdetailname%></TD>
            <TD><%=rightdetail%></TD>
            <TD><%=rightname%></TD>
          </TR>

<%
}
%>
          <TR class=Separator>
            <TD class=sep2 colSpan=7></TD>
          </TR>
		  </TBODY>
        </TABLE>
        <br>
        <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">全部选中
      </FORM>
<script>
function addrightdetail() {
	location="AddRightDetail.jsp";
}

function deleterightdetail() {
	if(confirmdel())
		document.frmDelete.submit();
}
</script>
      </BODY>
      </HTML>
