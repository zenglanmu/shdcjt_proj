<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page"/>
<html>
<%
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("SystemRightDetail_SelectByID",id);
	RecordSet.next();
	String rightdetailname = Util.toScreen(RecordSet.getString("rightdetailname"),user.getLanguage()) ;
	String rightdetail = Util.toScreen(RecordSet.getString("rightdetail"),user.getLanguage()) ;
	String rightid = Util.null2String(RecordSet.getString("rightid")) ;
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
      <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: 权限详细</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="RightDetailOperation.jsp">
    <input type="hidden" name="operation" value="deleterightdetail">
    <input type="hidden" name="delete_rightdetail_id" value="<%=id%>">
    <BUTTON class=btn id=btnEdit accessKey=E name=btnEdit onclick="editrightdetail()"><U>E</U>-编辑</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleterightdetail()"><U>D</U>-删除</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addrightdetail()"><U>A</U>-添加</BUTTON>
    <br>
        
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2>权限详细信息</TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD>名称</TD>
      <TD Class=Field><%=rightdetailname%></TD>
    </TR>
    <tr> 
      <td>详细</td>
      <td class=Field><%=rightdetail%></td>
    </tr>
    <tr> 
      <td>所属权限</td>
      <td class=Field><%=Util.toScreen(RightComInfo.getRightname(rightid,""+user.getLanguage()),user.getLanguage())%></td>
    </tr>
    </TBODY> 
  </TABLE>
      </FORM>
<script>
function deleterightdetail(){
	if(confirmdel()) {
		document.frmView.submit();
	}
}
function addrightdetail() {	
	location="AddRightDetail.jsp";
}
function editrightdetail() {	
	location="EditRightDetail.jsp?id=<%=id%>";
}
</script>
      </BODY>
      </HTML>
