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


String parabrowserid = Util.null2String(request.getParameter("browserid"));

String moduleid = BrowserXML.getModuleId();
ArrayList pointArrayList = BrowserXML.getPointArrayList();
Hashtable dataHST = BrowserXML.getDataHST();
String browserOPTIONS = "";
String thisServiceId = "";
String thisSearch = "";
String thisSearchById = "";
String thisSearchByName = "";
String thisNameHeader = "";
String thisDescriptionHeader = "";
String outPageURL = "";
String href = "";
String from = "";

ArrayList dsPointArrayList = DataSourceXML.getPointArrayList();
String dsOptions = "";
for(int i=0;i<dsPointArrayList.size();i++){
    String pointid = (String)dsPointArrayList.get(i);
    dsOptions += "<option value='datasource."+pointid+"'>"+"datasource."+pointid+"</option>";
}

String checkString = "";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",browsersettingnew.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="browsersetting.jsp">
<input type="hidden" id="operation" name="operation">
<input type="hidden" id="method" name="method">
<input type="hidden" id="bsnums" name="bsnums" value="<%=pointArrayList.size()%>">
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
					<COL width="8%">
					<COL width="8%"> 
					<COL width="18%">
					<COL width="18%"> 
					<COL width="18%">
					<COL width="8%">
					<COL width="8%">
					<COL width="*">
					<COL width="*">
				<TBODY>
					
				<TR class=Title>
				  <TH colSpan=10><%=titlename%></TH>
				</TR>
				<TR class=Spacing style="height:1px;">
				  <TD class=Line colSpan=10></TD>
				</TR>
				
				<TR class=Header>
				  <td></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(23675,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(23676,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(23677,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(23678,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(23679,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(23680,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(28144,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></nobr></td>
				</TR>
				
				<%
				int colorindex = 0;
				int rowindex = 0;
				for(int i=0;i<pointArrayList.size();i++){
				    String pointid = (String)pointArrayList.get(i);
				    if(pointid.equals("")) continue;
				    checkString += "browserid_"+rowindex+",";
				    Hashtable thisDetailHST = (Hashtable)dataHST.get(pointid);
				    if(thisDetailHST!=null){
				        thisServiceId = (String)thisDetailHST.get("ds");
				        thisSearch = (String)thisDetailHST.get("search");
				        thisSearchById = (String)thisDetailHST.get("searchById");
				        thisSearchByName = (String)thisDetailHST.get("searchByName");
				        thisNameHeader = (String)thisDetailHST.get("nameHeader");
				        thisDescriptionHeader = (String)thisDetailHST.get("descriptionHeader");
				        outPageURL = Util.null2String((String)thisDetailHST.get("outPageURL"));
				        href = Util.null2String((String)thisDetailHST.get("href"));
				        from = Util.null2String((String)thisDetailHST.get("from"));
				    }
				    String thisDsOptions = Util.replace(dsOptions,"<option value='"+thisServiceId+"'>"+thisServiceId+"</option>","<option value='"+thisServiceId+"' selected>"+thisServiceId+"</option>",0);
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
				    <td valign="top"><input type="checkbox" id="del_<%=rowindex%>" name="del_<%=rowindex%>" value="0" onchange="if(this.checked){this.value=1;}else{this.value=0;}"></td>
				    <td valign="top">
				    	<input class="inputstyle" type=text size=12 id="browserid_<%=rowindex%>" name="browserid_<%=rowindex%>" value="<%=pointid%>" onChange="checkinput('browserid_<%=rowindex%>','browseridspan_<%=rowindex%>')" onblur="checkBSName(this.value,<%=rowindex%>)">
				    	<span id="browseridspan_<%=rowindex%>"></span>
				    	<input class="inputstyle" type=hidden id="oldbrowserid_<%=rowindex%>" name="oldbrowserid_<%=rowindex%>" value="<%=pointid%>">
				    </td>
				    <td valign="top">
				    	<select id="ds_<%=rowindex%>" name="ds_<%=rowindex%>">
								<%=thisDsOptions%>
							</select>
						</td>
						<!--
						<td><input class="inputstyle" type=text id="search_<%=rowindex%>" name="search_<%=rowindex%>" size="22" value="<%=thisSearch%>">
						<td><input class="inputstyle" type=text id="searchById_<%=rowindex%>" name="searchById_<%=rowindex%>" size="22" value="<%=thisSearchById%>"></td>
						<td><input class="inputstyle" type=text id="searchByName_<%=rowindex%>" name="searchByName_<%=rowindex%>" size="22" value="<%=thisSearchByName%>"></td></td>
						-->
						<td><textarea style="overflow-y: auto;" id="search_<%=rowindex%>" name="search_<%=rowindex%>" rows=3 cols=30><%=thisSearch%></textarea></td>
						<td><textarea style="overflow-y: auto;" id="searchById_<%=rowindex%>" name="searchById_<%=rowindex%>" rows=3 cols=30><%=thisSearchById%></textarea></td>
						<td><textarea style="overflow-y: auto;" id="searchByName_<%=rowindex%>" name="searchByName_<%=rowindex%>" rows=3 cols=30><%=thisSearchByName%></textarea></td>
						<td valign="top"><input class="inputstyle" type=text id="nameHeader_<%=rowindex%>" name="nameHeader_<%=rowindex%>" size="7" value="<%=thisNameHeader%>"></td>
						<td valign="top"><input class="inputstyle" type=text id="descriptionHeader_<%=rowindex%>" name="descriptionHeader_<%=rowindex%>" size="7" value="<%=thisDescriptionHeader%>"></td>
						<td valign="top"><input class="inputstyle" type=text id="outPageURL_<%=rowindex%>" name="outPageURL_<%=rowindex%>" value="<%=outPageURL%>"></td>
						<td valign="top">
							<input class="inputstyle" type=text id="href_<%=rowindex%>" name="href_<%=rowindex%>" value="<%=href%>">
							<input class="inputstyle" type=hidden id="from_<%=rowindex%>" name="from_<%=rowindex%>" value="<%=from%>">
						</td>
						</tr>
				<%
				    rowindex++;
				}
				%>
				
				<TR><TD height=20 colspan="10"></TD></TR>

<tr>
<td colSpan="10">
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>：&nbsp;</B>
<BR>
1、<%=SystemEnv.getHtmlLabelName(23953,user.getLanguage())%>；
<BR>
2、<%=SystemEnv.getHtmlLabelName(23954,user.getLanguage())%>；
<BR>
3、<%=SystemEnv.getHtmlLabelName(23955,user.getLanguage())%>；
<BR>
4、<%=SystemEnv.getHtmlLabelName(23956,user.getLanguage())%>；
<BR>
5、<%=SystemEnv.getHtmlLabelName(23957,user.getLanguage())%>；
<BR>
6、<%=SystemEnv.getHtmlLabelName(23958,user.getLanguage())%>；
<BR>
7、<%=SystemEnv.getHtmlLabelName(23959,user.getLanguage())%>。
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
        frmMain.operation.value="browser";
        frmMain.method.value="edit";
        frmMain.submit();
    }
}
function onDelete(){
    if(isdel()){
        frmMain.action="XMLFileOperation.jsp";
        frmMain.operation.value="browser";
        frmMain.method.value="delete";
        frmMain.submit();
    }
}
function checkBSName(thisvalue,rowindex){
    bsnums = document.getElementById("bsnums").value;
    if(thisvalue!=""){
        for(var i=0;i<bsnums;i++){
            if(i!=rowindex){
                otherdsname = document.getElementById("browserid_"+i).value;
                if(thisvalue==otherdsname){
                    alert("该自定义浏览框已存在！");
                    document.getElementById("browserid_"+rowindex).value = "";
                }
            }
        }
    }
}
</script>

</HTML>
