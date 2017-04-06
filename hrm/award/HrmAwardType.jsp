<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(6099,user.getLanguage());
String needfav ="1";
String needhelp ="";


%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmRewardsTypeAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/award/HrmAwardTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmRewardsType:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=94,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%"> 
  <COL width="10%">
  <COL width="35%">
  <COL width="40%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=34><%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%></TH></TR>
    <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(808,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15667,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></TD>
  </TR>

<%  
    int temp=0;
    String sql = "select * from HrmAwardType order by id";
    rs.executeSql(sql);
    boolean isLight = false;
    while(rs.next()){  
        isLight = !isLight ;    
%> 
   <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
     <td> 
      <a href="/hrm/award/HrmAwardTypeEdit.jsp?id=<%=Util.null2String(rs.getString("id"))%>"><%=Util.toScreen(rs.getString("name"),user.getLanguage())%></a>
    </td>
      
    <TD>
    <% if(rs.getString("awardtype").equals("0")){ %><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%>
    <% } else {%><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%><% } %>
    </TD>
    <TD><%=Util.toScreen(rs.getString("description"),user.getLanguage())%></TD>
    <TD><%=Util.toScreen(rs.getString("transact"),user.getLanguage())%></TD>    
  </TR>
<%       
   }
%>  
 </TBODY>
 </TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table> 
</BODY>
</HTML>