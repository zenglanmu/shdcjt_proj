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

boolean CanAdd = HrmUserVarify.checkUserRight("HrmArrangeShift:Maintance" , user) ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/schedule/HrmArrangeShiftAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1477,user.getLanguage())+",/hrm/schedule/HrmArrangeShiftHistory.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
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
  <COL width="40%">  
  <COL width="40%">
  <TBODY>
  <TR class=Header><TH colSpan=3><%=SystemEnv.getHtmlLabelName(16255 , user.getLanguage())%></TH></TR>
  
  <TR class=Header>    
    <TD><%=SystemEnv.getHtmlLabelName(195 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(742 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(743 , user.getLanguage())%></TD>
  </TR>
   <%
    boolean isLight = false ; 
	RecordSet.executeProc("HrmArrangeShift_SelectAll" , "0") ; 	
	while(RecordSet.next()){ 
		String id = Util.null2String( RecordSet.getString("id") ) ; 
        String shiftname = Util.null2String( RecordSet.getString("shiftname") ) ; 
        String shiftbegintime = Util.null2String( RecordSet.getString("shiftbegintime") ) ; 
        String shiftendtime = Util.null2String( RecordSet.getString("shiftendtime") ) ; 
        if(isLight = !isLight)
		{%>	
 <TR CLASS = DataLight>
        <%}else{ %>
 <TR CLASS = DataDark>
        <%} %>
 <TD>
 <a href="/hrm/schedule/HrmArrangeShift.jsp?id=<%=id%>"><%=shiftname%></a>
           </TD>
   <TD><%=shiftbegintime%></a>
         </TD>  
   <TD><%=shiftendtime%></a>
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
<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>