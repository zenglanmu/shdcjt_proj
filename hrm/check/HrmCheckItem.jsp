<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(6117,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCheckItemAdd:Add",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/check/HrmCheckItemAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+96+",_self} " ;
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
  <COL width="50%">
  <COL width="50%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15753,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15754,user.getLanguage())%></TD>
  </TR>

<%  
    
    int temp=0;
    String sql = "select * from HrmCheckItem order by id";
    rs.executeSql(sql);
    boolean isLight = false;
    
    while(rs.next()){   
    isLight = !isLight ;   
%> 
   <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD>
    <a href = "/hrm/check/HrmCheckItemEdit.jsp?id=<%=Util.null2String(rs.getString("id"))%>">
    <%=Util.toScreen(rs.getString("checkitemname"),user.getLanguage())%></a></TD>
    <TD><%=Util.toScreen(rs.getString("checkitemexplain"),user.getLanguage())%></TD> 
        
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