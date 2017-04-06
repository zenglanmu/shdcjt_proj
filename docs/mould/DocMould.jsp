<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"£º"+SystemEnv.getHtmlLabelName(16450,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


<%
if(HrmUserVarify.checkUserRight("DocMouldAdd:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16388,user.getLanguage())+",javascript:location='/docs/mould/DocMouldAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
if(HrmUserVarify.checkUserRight("DocMould:log", user)){
%>
<%
    if(RecordSet.getDBType().equals("db2")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) =5',_top} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =5',_top} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
%>

<%}
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

 <TABLE class=liststyle cellspacing=1  >
  <COLGROUP>
  <COL width="30%">
  <COL width="30%">
  <COL width="40%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></th>
  </tr>
  <tr class=Line><th></th><th></th><th ></th></tr>
<%
	int id=0;
    String mouldName=null;
	String mouldType=null;

    RecordSet.executeSql("SELECT * from DocMould where issysdefault='0' order by mouldType asc,id  asc");

    boolean isLight = false;
	while(RecordSet.next()){
		id=Util.getIntValue(RecordSet.getString("id"));
		mouldName=Util.null2String(RecordSet.getString("mouldName"));
		mouldType=Util.null2String(RecordSet.getString("mouldType"));

		if(isLight = !isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>

		<TD>
<%
		if(mouldType.equals("0")){
%>
		    <a href="DocMouldDsp.jsp?id=<%=id%>"><%=id%></a>
<%
		}else{	
%>
		    <a href="DocMouldDspExt.jsp?id=<%=id%>"><%=id%></a>
<%
		}	
%>

		</TD>
		<TD>
<%
		if(mouldType.equals("0")){
%>
		    <a href="DocMouldDsp.jsp?id=<%=id%>"><%=mouldName%></a>
<%
		}else{	
%>
		    <a href="DocMouldDspExt.jsp?id=<%=id%>"><%=mouldName%></a>
<%
		}	
%>
		</TD>
		<TD>
<%
		if(mouldType.equals("0")){
%>
	        HTML&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
<%
		}else if(mouldType.equals("2")){
%>
	        WORD&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
<%
		}else if(mouldType.equals("3")){
%>
	        EXCEL&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
<%
		}else if(mouldType.equals("4")){
%>
	        <%=SystemEnv.getHtmlLabelName(22359,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
<%
		}
%>
		</TD>
	</TR>
<%
	}
%>
 </TABLE>


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

 </BODY></HTML>
