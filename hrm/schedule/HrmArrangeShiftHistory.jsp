<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file = "/systeminfo/init.jsp" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
</head>

<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16255 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 

boolean CanAdd = true ; // HrmUserVarify.checkUserRight("HrmScheduleDiff:Add" , user) ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmArrangeShiftList.jsp,_self} " ;
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
  <TABLE class=ListStyle cellspacing=1>
  <COLGROUP>  
  <COL width="20%">
  <COL width="30%">  
  <COL width="30%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
  <TH colSpan=4><%=SystemEnv.getHtmlLabelName(16691 , user.getLanguage())%></TH></TR>
  <TR class=Header>    
    <TD><%=SystemEnv.getHtmlLabelName(195 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(742 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(743 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15030 , user.getLanguage())%></TD>
  </TR>

   <%
    
	RecordSet.executeProc("HrmArrangeShift_SelectAll" , "1") ; 	
	while(RecordSet.next()){ 
		String id = Util.null2String( RecordSet.getString("id") ) ; 
        String shiftname = Util.null2String( RecordSet.getString("shiftname") ) ; 
        String shiftbegintime = Util.null2String( RecordSet.getString("shiftbegintime") ) ; 
        String shiftendtime = Util.null2String( RecordSet.getString("shiftendtime") ) ; 
        String validedatefrom = Util.null2String( RecordSet.getString("validedatefrom") ) ;
        String validedateto = Util.null2String( RecordSet.getString("validedateto") ) ;
   %>
<tr>
 <TD><%=shiftname%></a>
         </TD>
   <TD><%=shiftbegintime%></a>
         </TD>  
   <TD><%=shiftendtime%></a>
   </TD> 
    <TD><%=validedatefrom%>~<%=validedateto%></a>
   </TD> 
   </TR>
<%} %>
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
</body>
</html>