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

String parascheduleid = Util.null2String(request.getParameter("scheduleid"));

String moduleid = ScheduleXML.getModuleId();
ArrayList pointArrayList = ScheduleXML.getPointArrayList();
Hashtable dataHST = ScheduleXML.getDataHST();
String scheduleOPTIONS = "";
String thisClass = "";
String thisCronExpr = "";

String checkString = "";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",schedulesettingnew.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="schedulesetting.jsp">
<input type="hidden" id="operation" name="operation">
<input type="hidden" id="method" name="method">
<input type="hidden" id="sdnums" name="sdnums" value="<%=pointArrayList.size()%>">
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
					<COL width="40%">
					<COL width="30%">
				<TBODY>
					
				<TR class=Title>
				  <TH colSpan=4><%=titlename%></TH>
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=4></TD>
				</TR>
				
				<TR class=Header>
				  <td></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(23673,user.getLanguage())%></nobr></td>
				  <td><nobr><%=SystemEnv.getHtmlLabelName(23674,user.getLanguage())%></nobr></td>
				</TR>
				
				<%
				int colorindex = 0;
				int rowindex = 0;
				for(int i=0;i<pointArrayList.size();i++){
				    String pointid = (String)pointArrayList.get(i);
				    if(pointid.equals("")) continue;
				    checkString += "scheduleid_"+rowindex+",";
				    Hashtable thisDetailHST = (Hashtable)dataHST.get(pointid);
				    if(thisDetailHST!=null){
				        thisClass = (String)thisDetailHST.get("construct");
				        thisCronExpr = (String)thisDetailHST.get("cronExpr");
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
				    	<input class="inputstyle" type=text id="scheduleid_<%=rowindex%>" name="scheduleid_<%=rowindex%>" size=20 value="<%=pointid%>" onChange="checkinput('scheduleid_<%=rowindex%>','scheduleidspan_<%=rowindex%>')" onblur="checkSID(this.value,<%=rowindex%>)">
				    	<span id="scheduleidspan_<%=rowindex%>"></span>
				    	<input class="inputstyle" type=hidden id="oldscheduleid_<%=rowindex%>" name="oldscheduleid_<%=rowindex%>"value="<%=pointid%>">
				    </td>
				    <td><input class="inputstyle" type=text id="ClassName_<%=rowindex%>" name="ClassName_<%=rowindex%>" size=40 value="<%=thisClass%>"></td>
				    <td><input class="inputstyle" type=text id="CronExpr_<%=rowindex%>" name="CronExpr_<%=rowindex%>" size=30 value="<%=thisCronExpr%>"></td>
				  	</tr>
				<%
				    rowindex++; 
				}
				%>
				
				<TR><TD height=20></TD></TR>

<tr>
<td colSpan="8">
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>：&nbsp;</B>
<BR>
1、<%=SystemEnv.getHtmlLabelName(23970,user.getLanguage())%>；
<BR>
2、<%=SystemEnv.getHtmlLabelName(23971,user.getLanguage())%>；
<BR>
3、<%=SystemEnv.getHtmlLabelName(23972,user.getLanguage())%>。
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
        frmMain.operation.value="schedule";
        frmMain.method.value="edit";
        frmMain.submit();
    }
}

function onDelete(){
    if(isdel()){
        frmMain.action="XMLFileOperation.jsp";
        frmMain.operation.value="schedule";
        frmMain.method.value="delete";
        frmMain.submit();
    }
}
function checkSID(thisvalue,rowindex){
    sdnums = document.getElementById("sdnums").value;
    if(thisvalue!=""){
        for(var i=0;i<sdnums;i++){
            if(i!=rowindex){
                otherdsname = document.getElementById("scheduleid_"+i).value;
                if(thisvalue==otherdsname){
                    alert("该计划任务已存在！");
                    document.getElementById("scheduleid_"+rowindex).value = "";
                }
            }
        }
    }
}
</script>

</HTML>
