<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ActionXML" class="weaver.servicefiles.ActionXML" scope="page" />
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
String titlename = SystemEnv.getHtmlLabelName(23662,user.getLanguage());
String needfav ="1";
String needhelp ="";

ArrayList pointArrayList = ActionXML.getPointArrayList();
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",actionsetting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="XMLFileOperation.jsp">
<input type="hidden" id="operation" name="operation" value="action">
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
				<TR class=Spacing style="height:1px;">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="actionid" name="actionid" onChange="checkinput('actionid','actionidspan')" onblur="isExist(this.value)">
				  	<span id="actionidspan"><img src="/images/BacoError.gif" align=absmiddle></span>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23681,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="classname" name="classname" size=80>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td colSpan="3">
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>£º&nbsp;</B>
<BR>
1¡¢<%=SystemEnv.getHtmlLabelName(23951,user.getLanguage())%>£»
<BR>
2¡¢<%=SystemEnv.getHtmlLabelName(23952,user.getLanguage())%>¡£
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
    if(check_form(frmMain,"actionid")) frmMain.submit();
}

function isExist(newvalue){
    var pointids = "<%=pointids%>";
    if(pointids.indexOf(","+newvalue+",")>0){
        alert("<%=SystemEnv.getHtmlLabelName(23991,user.getLanguage())%>");
        document.getElementById("actionid").value = "";
    }
}
</script>

</HTML>
