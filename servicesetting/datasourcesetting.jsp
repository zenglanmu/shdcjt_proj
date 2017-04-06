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

String moduleid = DataSourceXML.getModuleId();
ArrayList pointArrayList = DataSourceXML.getPointArrayList();
Hashtable dataHST = DataSourceXML.getDataHST();
String dsOPTIONS = "";
String thisType = "";
String thisHost = "";
String thisPort = "";
String thisDBname = "";
String thisUser = "";
String thisPassword = "";
String thisMinconn = "";
String thisMaxconn = "";

String checkString = "";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",datasourcesettingnew.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="datasourcesetting.jsp">
<input type="hidden" id="operation" name="operation">
<input type="hidden" id="method" name="method">
<input type="hidden" id="dsnums" name="dsnums" value="<%=pointArrayList.size()%>">
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
					<COL width="4%">
					<COL width="10%"> 
					<COL width="10%">
					<COL width="15%"> 
					<COL width="6%">
					<COL width="14%"> 
					<COL width="12%">
					<COL width="13%"> 
					<COL width="8%">
					<COL width="8%">
				</COLGROUP>
				<TBODY>
					
				<TR class=Title>
				  <TH colSpan=10><%=titlename%></TH>
				</TR>
				<TR style="height:1px;">
				  <TD class=Line colSpan=10></TD>
				</TR>
				<TR class=Header>
				  <td></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(15025,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%>ip</nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(15026,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(23671,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(20522,user.getLanguage())%></nobr></td>
				</TR>
				
				<TR style="height:1px;"><TD class=Line colSpan=10></TD></TR>
				
				<%
				int colorindex = 0;
				int rowindex = 0;
				for(int i=0;i<pointArrayList.size();i++){
				    String pointid = (String)pointArrayList.get(i);
				    if(pointid.equals("")) continue;
				    checkString += "datasource_"+rowindex+",";
				    Hashtable thisDetailHST = (Hashtable)dataHST.get(pointid);
				    if(thisDetailHST!=null){
				        thisType = (String)thisDetailHST.get("type");
				        thisHost = (String)thisDetailHST.get("host");
				        thisPort = (String)thisDetailHST.get("port");
				        thisDBname = (String)thisDetailHST.get("dbname");
				        thisUser = (String)thisDetailHST.get("user");
				        thisPassword = (String)thisDetailHST.get("password");
				        thisMinconn = (String)thisDetailHST.get("minconn");
				        thisMaxconn = (String)thisDetailHST.get("maxconn");
				    }
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
				    <td><input type="checkbox" id="del_<%=rowindex%>" name="del_<%=rowindex%>" value="0" onchange="if(this.checked){this.value=1;}else{this.value=0;}"></td>
				    <td>
				    	<!--<span><%=pointid%></span>-->
				    	<input class="inputstyle" type=text size=12 id="datasource_<%=rowindex%>" name="datasource_<%=rowindex%>" value="<%=pointid%>" onChange="checkinput('datasource_<%=rowindex%>','datasourcespan_<%=rowindex%>')" onblur="checkDSName(this.value,<%=rowindex%>)">
				    	<span id="datasourcespan_<%=rowindex%>"></span>
				    	<input class="inputstyle" type=hidden size=12 id="olddatasource_<%=rowindex%>" name="olddatasource_<%=rowindex%>" value="<%=pointid%>">
				    </td>
				    <td class=Field>
							<select id="dbtype_<%=rowindex%>" name="dbtype_<%=rowindex%>">
								<option value="sqlserver" <%if(thisType.equals("sqlserver")){%>selected<%}%>>sqlserver2000</option>
								<option value="sqlserver2005" <%if(thisType.equals("sqlserver2005")){%>selected<%}%>>sqlserver2005</option>
								<option value="sqlserver2008" <%if(thisType.equals("sqlserver2008")){%>selected<%}%>>sqlserver2008</option>
								<option value="oracle" <%if(thisType.equals("oracle")){%>selected<%}%>>oracle</option>
								<option value="mysql" <%if(thisType.equals("mysql")){%>selected<%}%>>mysql</option>
								<option value="db2" <%if(thisType.equals("db2")){%>selected<%}%>>db2</option>
								<option value="sybase" <%if(thisType.equals("sybase")){%>selected<%}%>>sybase</option>
								<option value="informix" <%if(thisType.equals("informix")){%>selected<%}%>>informix</option>
							</select>
						</td>
				    <td><input class="inputstyle" type=text size=16 id="HostIP_<%=rowindex%>" name="HostIP_<%=rowindex%>" value="<%=thisHost%>"></td>
				    <td><input class="inputstyle" type=text size=6 id="Port_<%=rowindex%>" name="Port_<%=rowindex%>" value="<%=thisPort%>"></td>
				    <td><input class="inputstyle" type=text size=15 id="DBname_<%=rowindex%>" name="DBname_<%=rowindex%>" value="<%=thisDBname%>"></td>
				    <td><input class="inputstyle" type=text size=13 id="user_<%=rowindex%>" name="user_<%=rowindex%>" value="<%=thisUser%>"></td>
				    <td><input class="inputstyle" type=text size=14 id="password_<%=rowindex%>" name="password_<%=rowindex%>" value="<%=thisPassword%>"></td>
				    <td><input class="inputstyle" type=text size=7 id="minconn_<%=rowindex%>" name="minconn_<%=rowindex%>" value="<%=thisMinconn%>"></td>
				    <td><input class="inputstyle" type=text size=7 id="maxconn_<%=rowindex%>" name="maxconn_<%=rowindex%>" value="<%=thisMaxconn%>"></td>
				    </tr>
				<% 
				    rowindex++;       
				}
				%>
				
				<TR><TD class="Line" height=20 colspan="10"></TD></TR>

<tr>
<td colSpan="10">
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>：&nbsp;</B>
<BR>
1、<%=SystemEnv.getHtmlLabelName(23960,user.getLanguage())%>；
<BR>
2、<%=SystemEnv.getHtmlLabelName(23961,user.getLanguage())%>：
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;weaver.interfaces.datasource.DataSource ds = (weaver.interfaces.datasource.DataSource) StaticObj.getServiceByFullname(("datasource.<%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%>"), weaver.interfaces.datasource.DataSource.class)；
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;java.sql.Connection conn = ds.getConnection()；
<BR>
3、<%=SystemEnv.getHtmlLabelName(23962,user.getLanguage())%>。
<BR>
4、<%=SystemEnv.getHtmlLabelName(24406,user.getLanguage())%>。
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
    if(check_form(frmMain,"<%=checkString%>")){
        frmMain.action="XMLFileOperation.jsp";
        frmMain.operation.value="datasource";
        frmMain.method.value="edit";
        frmMain.submit();
    }
}

function onDelete(){
    if(isdel()){
        frmMain.action="XMLFileOperation.jsp";
        frmMain.operation.value="datasource";
        frmMain.method.value="delete";
        frmMain.submit();
    }
}

function checkDSName(thisvalue,rowindex){
    dsnums = document.getElementById("dsnums").value;
    if(thisvalue!=""){
        for(var i=0;i<dsnums;i++){
            if(i!=rowindex){
                otherdsname = document.getElementById("datasource_"+i).value;
                if(thisvalue==otherdsname){
                    alert("该数据源已存在！");
                    document.getElementById("datasource_"+rowindex).value = "";
                }
            }
        }
    }
}
</script>

</HTML>
