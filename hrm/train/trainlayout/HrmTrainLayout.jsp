<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6101,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainLayoutAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/train/trainlayout/HrmTrainLayoutAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrainLayout:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+67+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
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
  <COL width="40%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> </TD>
    <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%> </TD>
    <TD><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%> </TD>
  </TR> 
 
<% 
String sql = "select * from HrmTrainLayout order by id desc"; 
rs.executeSql(sql); 
int needchange = 0; 
while(rs.next()){ 
String	layoutname=rs.getString("layoutname"); 
String	typeid=rs.getString("typeid"); 
String  layouttestdate = rs.getString("layouttestdate"); 
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
   <TD><a href="HrmTrainLayoutEdit.jsp?id=<%=rs.getString("id")%>"><%=layoutname%></a>
   </TD> 
   <TD><%=TrainTypeComInfo.getTrainTypename(typeid)%>
   </TD> 
   <TD><%=layouttestdate%>
   </TD> 
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
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>