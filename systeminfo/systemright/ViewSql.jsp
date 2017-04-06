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
    <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: 权限 SQL</SPAN></TD>
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
  String id = Util.null2String(request.getParameter("id"));  
  rs.executeProc("SystemRights_SelectByID",id);
  rs.next()  ;
  String righttype = rs.getString("righttype");
  String rightdesc = Util.toScreen(rs.getString("rightdesc"),user.getLanguage());
  String insertSql = "insert into SystemRights (id,rightdesc,righttype) values (" + id + ",'" + rightdesc + "','"+ righttype + "') <br>GO<br><br>" ;

  rs.executeProc("SystemRightsLanguage_SByID",id);
  while(rs.next()) {
	String rightname = Util.toScreen(rs.getString("rightname"),user.getLanguage());
	String therightdesc = Util.toScreen(rs.getString("rightdesc"),user.getLanguage());
	String languageid= rs.getString("languageid") ;		

    insertSql += "insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values ("+id+","+languageid+",'"+rightname+"','"+therightdesc+"') <br>GO<br>";
  }

  insertSql += "<br>" ;


  rs.executeSql("select * from SystemRightDetail where rightid="+id);
  while( rs.next() ) {
      String rightdetailname = Util.toScreen(rs.getString("rightdetailname"),user.getLanguage()) ;
      String rightdetail = Util.toScreen(rs.getString("rightdetail"),user.getLanguage()) ;
      String rightid = Util.null2String(rs.getString("id")) ;
      
      insertSql += "insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values ("+rightid+",'"+rightdetailname+"','"+rightdetail+"',"+id+") <br>GO<br>";

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
    location = 'ViewRight.jsp?id=<%=id%>';
  }
</script>
</html>