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
    <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: 左侧菜单 SQL</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>
 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=leftMenuViewSqlform method=post>

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
<%
    String singleId = request.getParameter("menuId");
    String[] idsArry = request.getParameterValues("deleteMenuId");

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

    String sql = "SELECT * FROM LeftMenuInfo " + 
                 " WHERE id IN(" + idsStr +")" +
                 "   AND menuLevel = 1";
    String insertSql = "" ;

    rs.executeSql(sql);
    while(rs.next()){
        String menuLevel = rs.getString("menuLevel") ;
        String parentId = rs.getString("parentId");
        String defaultIndex = rs.getString("defaultIndex");

        String labelId = rs.getString("labelId");
        String iconUrl = rs.getString("iconUrl");
        String linkAddress = rs.getString("linkAddress");
        String relatedModuleId = rs.getString("relatedModuleId");

        insertSql += "EXECUTE LeftMenuConfig_U_ByInfoInsert  " + menuLevel + ","
                     + "NULL" + "," + defaultIndex + "," + "''" + "," + "''" + "<br>GO<br>";

        insertSql += "EXECUTE LeftMenuInfo_Insert  " + labelId + "," + "NULL" + "," + "NULL" + "," 
                    + menuLevel + "," + "NULL" + "," + defaultIndex + "," + relatedModuleId +"," 
                    + "''" + "," + "''" + "<br>GO<br><br>";
    }


    sql = "SELECT * FROM LeftMenuInfo " + 
                 " WHERE id IN(" + idsStr +")" +
                 "   AND menuLevel = 2";

    rs.executeSql(sql);
    while(rs.next()){
        String menuLevel = rs.getString("menuLevel") ;
        String parentId = rs.getString("parentId");
        String defaultIndex = rs.getString("defaultIndex");

        String labelId = rs.getString("labelId");
        String iconUrl = rs.getString("iconUrl");
        String linkAddress = rs.getString("linkAddress");
        String relatedModuleId = rs.getString("relatedModuleId");

        insertSql += "EXECUTE LeftMenuConfig_U_ByInfoInsert  " + menuLevel + ","
                     + parentId + "," + defaultIndex + "," + "''" + "," + "''" +"<br>GO<br>";

        insertSql += "EXECUTE LeftMenuInfo_Insert  " + labelId + ",'" + iconUrl + "','" + linkAddress + "'," 
                    + menuLevel + "," + parentId + "," + defaultIndex + "," + relatedModuleId +"," 
                    + "'', '' <br>GO<br><br>";
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
    location = "ManageLeftMenu.jsp";
}
</script>
</html>