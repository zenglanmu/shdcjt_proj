<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<LINK href="/css/BacoSystem.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdReport.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: Label SQL</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>
 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=workflowbillViewSqlform method=post action="WorkflowbillOperation.jsp">

  <BUTTON class=btn id=btnBack accessKey=D name=btnBack onclick="backSubmit()"><U>D</U>-返回</BUTTON>
  <br>
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
    <TR class=Section>
      <TH colSpan=2>SQL语句</TH>
    </TR>
    <TR class=Separator>
      <TD class=sep1 colSpan=2></TD>
    </TR>

  <input type=hidden name=operation>
<%
    String singleId = request.getParameter("id");
    String[] idsArry = request.getParameterValues("delete_label_id");
    String idsStr = "";
    if(idsArry==null){
        idsArry = new String[1];
        idsArry[0] = singleId;
    }
    for(int i=0; i<idsArry.length; i++){
        idsStr += ","+idsArry[i];
    }
    if(!idsStr.equals("")){
        idsStr = idsStr.substring(1);
    }else{
        idsStr = "-1";
    }

    String sql = "select *  from HtmlLabelIndex where id in(" + idsStr +")";
    String insertSql = "" ;
    rs.executeSql(sql);
    while(rs.next()){
        String id = rs.getString("id") ;
        String indexdesc = rs.getString("indexdesc");
        insertSql += "INSERT INTO HtmlLabelIndex values(" + id + ",'" + indexdesc + "') <br>GO<br>";
    }
    sql = "select *  from HtmlLabelInfo where indexid in(" + idsStr +")";
    rs.executeSql(sql);
    while(rs.next()){
        String indexid = rs.getString("indexid");
        String labelname = rs.getString("labelname") ;
        String languageid = rs.getString("languageid");
        insertSql += "INSERT INTO HtmlLabelInfo  VALUES("+indexid+",'"+labelname+"',"+languageid+") <br>GO<br>";
    }

%>
<TR>
<TD Class=Field bgcolor="#00ccbb" colspan=2>
     <%=insertSql%>
     </TD>
     </TR>
</table>
</body>
<script language=javascript>
function backSubmit(){
<%if(singleId!=null){%>
    location = 'ViewLabel.jsp?id=<%=singleId%>';
<%}else{%>
    location = "ManageLabel.jsp";
<%}%>
}
</script>
</html>