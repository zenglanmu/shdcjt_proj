<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(6118,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCheckKindAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/check/HrmCheckKindAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+97+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
  <COL width="25%">
  <COL width="25%">
  <COL width="25%">
  <COL width="25%">
  
  <TBODY>
  <TR class=Header>
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(6118,user.getLanguage())%></TH>
  </TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15755,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15756,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15757,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15758,user.getLanguage())%></TD>
    </TR>

<%  
    
    int temp=0;
    String sql = "select * from HrmCheckKind order by id";
    rs.executeSql(sql);
    boolean isLight = false;
   
    while(rs.next()){   
    isLight = !isLight ;   
%> 
   <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD>
    <a href = "/hrm/check/HrmCheckKindView.jsp?id=<%=Util.null2String(rs.getString("id"))%>">
    <%=Util.toScreen(rs.getString("kindname"),user.getLanguage())%></a></TD>
    <TD>
    <% if(rs.getString("checkcycle").equals("1")){ %><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%>
    <% } else if(rs.getString("checkcycle").equals("2")){%><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%>
    <% } else if(rs.getString("checkcycle").equals("3")){%><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%>
    <% } else if(rs.getString("checkcycle").equals("4")){%><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%><% } %>
    
    </TD> 
    <TD><%=Util.toScreen(rs.getString("checkexpecd"),user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></TD> 
    <TD><%=Util.toScreen(rs.getString("checkstartdate"),user.getLanguage())%></TD> 
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
<script language=javascript>  
function submitData() {
 frmMain.submit();
}
</script>
</BODY>
</HTML>