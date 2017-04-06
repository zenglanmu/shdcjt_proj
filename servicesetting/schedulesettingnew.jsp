<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ScheduleXML" class="weaver.servicefiles.ScheduleXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("ServiceFile:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(23663,user.getLanguage());
String needfav ="1";
String needhelp ="";

ArrayList pointArrayList = ScheduleXML.getPointArrayList();
String pointids = ",";
for(int i=0;i<pointArrayList.size();i++){
    String pointid = (String)pointArrayList.get(i);
    pointids += pointid+",";
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",schedulesetting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="XMLFileOperation.jsp">
<input type="hidden" id="operation" name="operation" value="schedule">
<input type="hidden" id="method" name="method" value="add">
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
				<COLGROUP> <COL width="20%"> <COL width="80%">
				<TBODY>
					
				<TR class=Title>
				  <TH colSpan=2><%=titlename%></TH>
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="scheduleid" name="scheduleid" onChange="checkinput('scheduleid','scheduleidspan')" onblur="isExist(this.value)">
				  	<span id="scheduleidspan"><img src="/images/BacoError.gif" align=absmiddle></span>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23673,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="ClassName" name="ClassName" size=50>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23674,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="CronExpr" name="CronExpr" size=50>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>

<tr>
<td colSpan="8">
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>£º&nbsp;</B>
<BR>
1¡¢<%=SystemEnv.getHtmlLabelName(23970,user.getLanguage())%>£»
<BR>
2¡¢<%=SystemEnv.getHtmlLabelName(23971,user.getLanguage())%>£»
<BR>
3¡¢<%=SystemEnv.getHtmlLabelName(23972,user.getLanguage())%>¡£
</TD>
</TR>
</TBODY>
</table>
</td>
</tr>
				
				</TBODY>
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
  </FORM>
</BODY>
<script language="javascript">
function onSubmit(){
    if(check_form(frmMain,"scheduleid")) frmMain.submit();
}
function isExist(newvalue){
    var pointids = "<%=pointids%>";
    if(pointids.indexOf(","+newvalue+",")>0){
        alert("<%=SystemEnv.getHtmlLabelName(23994,user.getLanguage())%>");
        document.getElementById("scheduleid").value = "";
    }
}
</script>

</HTML>
