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
</head>
<BODY>

<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOC.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>搜索: 工作流单据</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
 <%
 String temptable = "prjstemptable"+ Util.getRandom() ;
 String SearchSql;
int pageNum=Util.getIntValue(request.getParameter("pageNum"),1);
int perPage=Util.getIntValue(request.getParameter("perPage"),1);
if(perPage<=1 )	perPage=150;
%>
  <FORM style="MARGIN-TOP: 0px" name=workflowbillform method=post action="WorkflowbillOperation.jsp">
    <BUTTON class=btn id=btnSearch accessKey=S name=btnSearch type=submit onclick="searchworkflowbill()"><U>S</U>-搜索</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
	<%if(Util.getIntValue(user.getSeclevel(),0)>=20){%>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addworkflowbill()"><U>A</U>-添加</BUTTON>  
    <input type=hidden name=operation>  
	<%}%>	
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
            <TD>标签描叙</TD>
            <TD Class=Field colspan=4> 
              <input class=text name=searchcon accessKey=Z value="<%=Util.toScreen(request.getParameter("searchcon"),user.getLanguage(),"0")%>">
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
        <br>
        <TABLE class=ListShort>
          <COLGROUP> <COL width="5%"> <COL width="10%"> <COL width="10%"> <COL width="10%"><COL width="10%"><COL width="10%"><COL width="10%"><COL width="10%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=8>搜索结果</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2 colSpan=8></TD>
          </TR>
          <TR class=Header>             
            <Td >标识</Td>
            <Td >描叙</Td>
            <Td >主数据库表名</Td>
            <Td>附数据库表名</Td>
            <TD>新建页面</TD>
            <TD>查看页面</TD>
            <TD>编辑页面</TD>
            <TD>后台处理页面</TD>
          </TR>
<%
  SearchSql = "SELECT distinct workflow_bill.*, HtmlLabelIndex.indexdesc FROM workflow_bill INNER JOIN HtmlLabelIndex ON workflow_bill.namelabel = HtmlLabelIndex.id order by workflow_bill.id ";  
  RecordSet.executeSql(SearchSql);    
  while(RecordSet.next()){
%>
     <TR>
        <Td><a href="ViewWorkflowbill.jsp?id=<%=Util.getIntValue(RecordSet.getString("id"),0)%>"><%= Util.getIntValue(RecordSet.getString("id"),0)%></a></Td>	
	<Td><a href="ViewWorkflowbill.jsp?id=<%=Util.getIntValue(RecordSet.getString("id"),0)%>"><%= RecordSet.getString("indexdesc")%></a></Td>	
	<Td><%=RecordSet.getString("tablename")%></Td>
	<Td><%=RecordSet.getString("detailtablename")%></Td>
	<Td><%=RecordSet.getString("createpage")%></Td>
	<Td><%=RecordSet.getString("viewpage")%></Td>
	<Td><%=RecordSet.getString("managepage")%></Td>
    <Td><%=RecordSet.getString("operationpage")%></Td>
     </TR>	
<%    
  }
%>
</form>
<script>
function addworkflowbill() {        
	location="AddWorkflowbill.jsp";
}
function searchworkflowbill() {               
	document.workflowbillform.operation.value="search";
	document.workflowbillform.submit();
}
</script>
</body>
</html>
