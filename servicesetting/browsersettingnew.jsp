<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
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
String titlename = SystemEnv.getHtmlLabelName(23661,user.getLanguage());
String needfav ="1";
String needhelp ="";

ArrayList pointArrayList = BrowserXML.getPointArrayList();
String pointids = ",";
for(int i=0;i<pointArrayList.size();i++){
    String pointid = (String)pointArrayList.get(i);
    pointids += pointid+",";
}

ArrayList dsPointArrayList = DataSourceXML.getPointArrayList();
String dsOptions = "";
for(int i=0;i<dsPointArrayList.size();i++){
    String pointid = (String)dsPointArrayList.get(i);
    dsOptions += "<option value='"+pointid+"'>"+"datasource."+pointid+"</option>";
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",browsersetting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="XMLFileOperation.jsp">
<input type="hidden" id="operation" name="operation" value="browser">
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
				<TR class=Spacing style="height:1px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23675,user.getLanguage())%></td>
				  <td class=Field>
						<input class="inputstyle" type=text id="browserid" name="browserid" onChange="checkinput('browserid','browseridspan')" onblur="isExist(this.value)">
						<span id="browseridspan"><img src="/images/BacoError.gif" align=absmiddle></span>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></td>
				  <td class=Field>
						<select id="ds" name="ds">
							<%=dsOptions%>
						</select>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23676,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="search" name="search" size="80">
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23677,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="searchById" name="searchById" size="80">
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23678,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="searchByName" name="searchByName" size="80">
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23679,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="nameHeader" name="nameHeader">
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23680,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="descriptionHeader" name="descriptionHeader">
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(28144,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="outPageURL" name="outPageURL" size="80">
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="href" name="href" size="80">
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
1¡¢<%=SystemEnv.getHtmlLabelName(23953,user.getLanguage())%>£»
<BR>
2¡¢<%=SystemEnv.getHtmlLabelName(23954,user.getLanguage())%>£»
<BR>
3¡¢<%=SystemEnv.getHtmlLabelName(23955,user.getLanguage())%>£»
<BR>
4¡¢<%=SystemEnv.getHtmlLabelName(23956,user.getLanguage())%>£»
<BR>
5¡¢<%=SystemEnv.getHtmlLabelName(23957,user.getLanguage())%>£»
<BR>
6¡¢<%=SystemEnv.getHtmlLabelName(23958,user.getLanguage())%>£»
<BR>
7¡¢<%=SystemEnv.getHtmlLabelName(23959,user.getLanguage())%>¡£
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
    if(check_form(frmMain,"browserid")) frmMain.submit();
}
function isExist(newvalue){
    var pointids = "<%=pointids%>";
    if(pointids.indexOf(","+newvalue+",")>0){
        alert("<%=SystemEnv.getHtmlLabelName(23992,user.getLanguage())%>");
        document.getElementById("browserid").value = "";
    }
}
</script>

</HTML>
