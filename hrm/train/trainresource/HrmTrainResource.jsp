<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<%
/*if(!HrmUserVarify.checkUserRight("HrmTrainPlanAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}*/
%>	
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6105,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainResourceAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/train/trainresource/HrmTrainResourceAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrainResource:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+68+",_self} " ;
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
  <COL width="40%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
  </TR>

<% 
String sql = "select * from HrmTrainResource"; 
rs.executeSql(sql); 
int needchange = 0; 
while(rs.next()){ 
String	name=rs.getString("name"); 
String	fare=rs.getString("fare"); 
String  time = rs.getString("time"); 
int  type = Util.getIntValue(rs.getString("type_n"));
try{ 
  if(needchange ==0){ 
  needchange = 1; 
%> 
  <TR class=datalight> 
<% 
}else{ needchange=0; 
%>
  <TR class=datadark> 
<%
} 
%> 
   <TD><a href="HrmTrainResourcetEdit.jsp?id=<%=rs.getString("id")%>"><%=name%></a>
   </TD> 
   <TD><%=fare%>
   </TD> 
   <TD><%=time%>
   </TD> 
   <td>
     <%if(type == 1){%><%=SystemEnv.getHtmlLabelName(16165,user.getLanguage())%><%}%>
     <%if(type == 0){%><%=SystemEnv.getHtmlLabelName(16166,user.getLanguage())%><%}%>
   </td>
  </TR>
<% 
  }catch(Exception e){ 
  System.out.println(e.toString()); } } 
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