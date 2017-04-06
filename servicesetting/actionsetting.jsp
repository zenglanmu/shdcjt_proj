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


String paraactionid = Util.null2String(request.getParameter("actionid"));

ArrayList pointArrayList = ActionXML.getPointArrayList();
Hashtable dataHST = ActionXML.getDataHST();
String moduleid = ActionXML.getModuleId();
String classname = "";

String checkString = "";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",actionsettingnew.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="actionsetting.jsp">
<input type="hidden" id="operation" name="operation">
<input type="hidden" id="method" name="method">
<input type="hidden" id="atnums" name="atnums" value="<%=pointArrayList.size()%>">
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
					<COL width="26%"> 
					<COL width="70%">
				<TBODY>
					
				<TR class=Title>
				  <TH colSpan=3><%=titlename%></TH>
				</TR>
				<TR class=Spacing style="height:1px;">
				  <TD class=Line colSpan=3></TD>
				</TR>
				<TR class=Header>
				  <td></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23681,user.getLanguage())%></nobr></td>
				</TR>
				
				<%
				int colorindex = 0;
				int rowindex = 0;
				for(int i=0;i<pointArrayList.size();i++){
				    String pointid = (String)pointArrayList.get(i);
				    if(pointid.equals("")) continue;
				    checkString += "actionid_"+rowindex+",";
				    classname = (String)dataHST.get(pointid);
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
				    	<input class="inputstyle" type=text size=30 id="actionid_<%=rowindex%>" name="actionid_<%=rowindex%>" value="<%=pointid%>" onChange="checkinput('actionid_<%=rowindex%>','actionidspan_<%=rowindex%>')" onblur="checkATName(this.value,<%=rowindex%>)">
				    	<span id="actionidspan_<%=rowindex%>"></span>
				    	<input class="inputstyle" type=hidden id="oldactionid_<%=rowindex%>" name="oldactionid_<%=rowindex%>" value="<%=pointid%>">
				    </td>
				    <td>
				    	<input class="inputstyle" type=text size=90 id="classname_<%=rowindex%>" name="classname_<%=rowindex%>" value="<%=classname%>">
				    </td>
				<%
				    rowindex++;
				}
				%>
				
				<TR><TD height=20 colspan="3"></TD></TR>

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
    if(check_form(frmMain,"<%=checkString%>")){
        frmMain.action="XMLFileOperation.jsp";
        frmMain.operation.value="action";
        frmMain.method.value="edit";
        frmMain.submit();
    }
}

function onDelete(){
    if(isdel()){
        frmMain.action="XMLFileOperation.jsp";
        frmMain.operation.value="action";
        frmMain.method.value="delete";
        frmMain.submit();
    }
}

function checkATName(thisvalue,rowindex){
    atnums = document.getElementById("atnums").value;
    if(thisvalue!=""){
        for(var i=0;i<atnums;i++){
            if(i!=rowindex){
                otherdsname = document.getElementById("actionid_"+i).value;
                if(thisvalue==otherdsname){
                    alert("¸ÃactionÒÑ´æÔÚ£¡");
                    document.getElementById("actionid_"+rowindex).value = "";
                }
            }
        }
    }
}
</script>

</HTML>
