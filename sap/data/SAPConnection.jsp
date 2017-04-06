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
String titlename = SystemEnv.getHtmlLabelName(28579,user.getLanguage());
String needfav ="1";
String needhelp ="";


RecordSet.execute("select * from SAPConn");
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",SAPConnectionNew.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="datasourcesetting.jsp">
<input type="hidden" id="operation" name="operation">
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
			  <TABLE class="liststyle" cellspacing=1>
				<COLGROUP> 
					<COL width="10%"> 
					<COL width="15%">
					<COL width="15%"> 
					<COL width="15%">
					<COL width="10%"> 
					<COL width="6%">
					<COL width="6%"> 
					<COL width="7%"> 
					<COL width="13%"> 
				<TBODY>
					
				<TR class=Title>
				  <TH colSpan=10><%=titlename%></TH>
				</TR>
				<TR>
				  <TD class=Line1 colSpan=10></TD>
				</TR>
				<TR class=Header>
				  <td><nobr>SAP连接名称</nobr></td>
				  <td><nobr>SAP服务器IP地址</nobr></td>
				  <td><nobr>SAP客户端</nobr></td>
				  <td><nobr>SAP用户名</nobr></td>
				  <td><nobr>SAP密码</nobr></td>
				  <td><nobr>SAP语言</nobr></td>
				  <td><nobr>SAP系统编号</nobr></td>
				  <td><nobr>是否默认</nobr></td>
				  <td><nobr>操作</nobr></td>
				</TR>
				
				<TR><TD class=Line colSpan=10></TD></TR>
				
				<%
				int colorindex = 0;
				while(RecordSet.next()){
				    if(colorindex==0){
				    %>
				    <tr class="datadark">
				    <%
				        colorindex=1;
				    }else{
				    %>
				    <tr class="datalight">
				    <%
				        colorindex=0;
				    }%>
				    <td>
				    	<%=RecordSet.getString("code")%>
				    </td>
				    <td>
							<%=RecordSet.getString("HostName")%>
					</td>
				    <td><%=RecordSet.getString("SAPClient")%></td>
				    <td><%=RecordSet.getString("Userid")%></td>
				    <td>******</td>
				    <td><%=RecordSet.getString("Language")%></td>
				    <td><%=RecordSet.getString("SystemNumber")%></td>
				    <td><%if("1".equals(RecordSet.getString("isdefault"))){ %>是<%}else{ %>否<%} %></td>
				    <td><a href='/sap/data/SAPConnectionEdit.jsp?_code=<%=RecordSet.getString("code")%>' target="_self">编辑</a>&nbsp;<a href='/sap/data/SAPConnectionOperation.jsp?operation=delete&code=<%=RecordSet.getString("code")%>'>删除</a>&nbsp;<a href='/sap/data/SAPConnectionOperation.jsp?operation=default&code=<%=RecordSet.getString("code")%>'>设为默认</a></td>
				    </tr>
				<% 
				}
				%>
				
<!--				<TR><TD height=20></TD></TR>-->

<tr>
<td colSpan="10">
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
	
}

</script>

</HTML>
