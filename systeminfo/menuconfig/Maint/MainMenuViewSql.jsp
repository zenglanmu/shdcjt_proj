<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
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
    <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: 主菜单 SQL</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>
 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=mainMenuViewSqlform method=post>

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

    int maxLevelMenuCount = 4;
    String insertSql = "" ;

    for(int i=0;i<maxLevelMenuCount;i++){
        String sql = "SELECT * FROM MainMenuInfo " + 
                     " WHERE id IN(" + idsStr +")" +
                     "   AND defaultLevel = "+i;
        rs.executeSql(sql);
        while(rs.next()){

            String labelId = Util.null2String(rs.getString("labelId"));
            String menuName = Util.null2String(rs.getString("menuName"));
            String linkAddress = Util.null2String(rs.getString("linkAddress"));
            String parentFrame = Util.null2String(rs.getString("parentFrame"));
            String defaultParentId = Util.null2String(rs.getString("defaultParentId"));
            String defaultLevel = Util.null2String(rs.getString("defaultLevel"));
            String defaultIndex = Util.null2String(rs.getString("defaultIndex"));

            String needRightToView = Util.null2String(rs.getString("needRightToView"));
            String rightDetailToView = Util.null2String(rs.getString("rightDetailToView"));

            String needRightToVisible = Util.null2String(rs.getString("needRightToVisible"));
            String rightDetailToVisible = Util.null2String(rs.getString("rightDetailToVisible"));

            String needSwitchToVisible = Util.null2String(rs.getString("needSwitchToVisible"));
            String switchClassNameToVisible = Util.null2String(rs.getString("switchClassNameToVisible"));
            String switchMethodNameToVisible = Util.null2String(rs.getString("switchMethodNameToVisible"));

            String needSwitchToView = Util.null2String(rs.getString("needSwitchToView"));
            String switchClassNameToView = Util.null2String(rs.getString("switchClassNameToView"));
            String switchMethodNameToView = Util.null2String(rs.getString("switchMethodNameToView"));

            String relatedModuleId = Util.null2String(rs.getString("relatedModuleId"));

            if(defaultIndex.equalsIgnoreCase("")){
                defaultIndex = "1";
            }
            if(needRightToView.equalsIgnoreCase("")){
                needRightToView = "0";
            }
            if(needRightToVisible.equalsIgnoreCase("")){
                needRightToVisible = "0";
            }
            if(needSwitchToVisible.equalsIgnoreCase("")){
                needSwitchToVisible = "0";
            }
            if(needSwitchToView.equalsIgnoreCase("")){
                needSwitchToView = "0";
            }

            insertSql += "EXECUTE MainMenuConfig_U_ByInfoInsert  " + defaultParentId + "," + defaultIndex + "," + "''" + "," + "''" + "<br>GO<br>";

            insertSql += "EXECUTE MainMenuInfo_Insert  " + labelId + ",'" + menuName + "','" + linkAddress + "','" + parentFrame + "'," + defaultParentId + "," + defaultLevel + "," + defaultIndex + "," + needRightToVisible + ",'" + rightDetailToVisible + "'," + needRightToView + ",'" + rightDetailToView + "'," + needSwitchToVisible + ",'" + switchClassNameToVisible + "','" + switchMethodNameToVisible + "'," + needSwitchToView + ",'" + switchClassNameToView + "','" + switchMethodNameToView + "'," + relatedModuleId +"," + "''" + "," + "''" + "<br>GO<br><br>";
        }
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
    location = "ManageMainMenu.jsp";
}
</script>
</html>