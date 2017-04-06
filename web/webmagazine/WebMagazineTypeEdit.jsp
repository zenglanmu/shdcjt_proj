<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = "ÆÚ¿¯";
String needfav ="1";
String needhelp ="";
String typeID = ""+Util.getIntValue(request.getParameter("typeID"),0);
String typeName = "";
String typeRemark = "";
RecordSet.executeSql("select * from WebMagazineType where id = " + typeID);
if (RecordSet.next()) 
{
	typeName = Util.null2String(RecordSet.getString("name"));
	typeRemark = Util.fromHtmlToEdit(Util.null2String(RecordSet.getString("remark")));
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/web/webmagazine/WebMagazineList.jsp?typeID="+typeID+",_self} " ;
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
			  
			<TABLE class=ViewForm>
			<FORM name="Magazine"  action="WebMagazineOperation.jsp" method="post">
			<input type="hidden" name="method" value="TypeUpdate">
			<input type="hidden" name="typeID" value="<%=typeID%>">
			<COLGROUP><COL width="10%"><COL width="90%">
			<TBODY>
			<tr> 
				<td>
					¿¯Ãû
				</td>
				<td class=Field>
					<INPUT class="InputStyle" type="text" name="name" value="<%=typeName%>" onChange="checkinput('name','nameSpan')">
					<span id="nameSpan"></span>
				</td>
			</tr>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR> 
			<TR>
				<TD>
					<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>
				</TD>
				<TD class=Field>
					<textarea class="InputStyle" name="remark" cols="50"><%=typeRemark%></textarea>
				</TD>
			</TR>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR>
			</FORM>
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
</BODY>
</HTML>
<script language="javascript">
function submitData()
{
	if (check_form(Magazine,'name'))
		Magazine.submit();
}
</script>