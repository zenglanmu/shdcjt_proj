<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17088,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    int parentid = Util.getIntValue(request.getParameter("parentid"),0);
    RecordSet.executeSql("select * from cus_treeform where scope='HrmCustomFieldByInfoType' and parentid="+parentid);
%>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",AddHrmCustomField.jsp?parentid="+parentid+",_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
%>


<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr style="height:1px;">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">


<TABLE class=liststyle cellspacing=1  >
  <COLGROUP>
  <COL width="100%">
  <%--<COL width="30%">--%>
  <%--<COL width="60%">--%>
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(17549,user.getLanguage())%></th>
  <%--<th>类型</th>--%>
  <%--<th>顺序</th>--%>
  </tr>
<%
    boolean isLight = false;
	while(RecordSet.next()){
		if(isLight = !isLight){%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="EditHrmCustomField.jsp?id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("formlabel")%></a></TD>
		<%--<TD><%=RecordSet.getString("viewtype").equals("0")?"单条记录":"多条记录"%></TD>--%>
		<%--<TD><%=Util.getIntValue(RecordSet.getString("scopeorder"),0)%></TD>--%>
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
	<td height="0" colspan="3"></td>
</tr>
</table>

</BODY>
</HTML>
