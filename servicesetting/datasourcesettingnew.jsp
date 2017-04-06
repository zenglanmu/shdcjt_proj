<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
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
String titlename = SystemEnv.getHtmlLabelName(23660,user.getLanguage());
String needfav ="1";
String needhelp ="";

ArrayList pointArrayList = DataSourceXML.getPointArrayList();
String pointids = ",";
for(int i=0;i<pointArrayList.size();i++){
    pointids += (String)pointArrayList.get(i)+",";
}

%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",datasourcesetting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="XMLFileOperation.jsp">
<input type="hidden" id="operation" name="operation" value="datasource">
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
				  <td><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="datasource" name="datasource" onChange="checkinput('datasource','datasourcespan')" onblur="isExist(this.value)">
				  	<span id="datasourcespan"><img src="/images/BacoError.gif" align=absmiddle></span>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15025,user.getLanguage())%></td>
				  <td class=Field>
						<select id="dbtype" name="dbtype">
							<option value="sqlserver">sqlserver2000</option>
							<option value="sqlserver2005">sqlserver2005</option>
							<option value="sqlserver2008">sqlserver2008</option>
							<option value="oracle">oracle</option>
							<option value="mysql">mysql</option>
							<option value="db2">db2</option>
							<option value="sybase">sybase</option>
							<option value="informix">informix</option>
						</select>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%>ip</td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="HostIP" name="HostIP">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="Port" name="Port">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15026,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="DBname" name="DBname">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="user" name="user">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="password" name="password">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23671,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="minconn" name="minconn">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20522,user.getLanguage())%></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="maxconn" name="maxconn">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td colSpan="10">
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>£º&nbsp;</B>
<BR>
1¡¢<%=SystemEnv.getHtmlLabelName(23960,user.getLanguage())%>£»
<BR>
2¡¢<%=SystemEnv.getHtmlLabelName(23961,user.getLanguage())%>£º
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;weaver.interfaces.datasource.DataSource ds = (weaver.interfaces.datasource.DataSource) StaticObj.getServiceByFullname(("datasource.<%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%>"), weaver.interfaces.datasource.DataSource.class)£»
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;java.sql.Connection conn = ds.getConnection()£»
<BR>
3¡¢<%=SystemEnv.getHtmlLabelName(23962,user.getLanguage())%>¡£
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
    if(check_form(frmMain,"datasource")) frmMain.submit();
}

function isExist(newvalue){
    var pointids = "<%=pointids%>";
    if(pointids.indexOf(","+newvalue+",")>0){
        alert("<%=SystemEnv.getHtmlLabelName(23993,user.getLanguage())%>");
        document.getElementById("datasource").value = "";
    }
}
</script>

</HTML>
