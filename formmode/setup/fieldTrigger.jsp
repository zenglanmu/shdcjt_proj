<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.system.code.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<html>
<%
	String ajax=Util.null2String(request.getParameter("ajax"));
	int modeId=Util.getIntValue(Util.null2String(request.getParameter("modeId")),0); 
	String message=Util.null2String(request.getParameter("message"));
	if(message.equals("reset")) message = SystemEnv.getHtmlLabelName(22428,user.getLanguage());
	
	
	String ischecked = "";
	int triggerNum = 0;
	RecordSet.executeSql("select * from modeDataInputentry where modeid="+modeId);
	while(RecordSet.next()){
		triggerNum++;
		ischecked = " checked ";
	}
%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(21848,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form id="frmTrigger" name="frmTrigger" method=post action="triggerOperation.jsp" >
	<input type="hidden" id="triggerNum" name="triggerNum" value="<%=triggerNum%>">
	<input type="hidden" id="modeId" name="modeId" value="<%=modeId%>">
	<div style="display:none">
	<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
	</table>
	</div>
<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
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
						<table class="viewform">
	   					<COLGROUP>
	   					<COL width="30%">
							<COL width="70%">
							<TR class="Title">
								<TH colspan=2><%=SystemEnv.getHtmlLabelName(21804,user.getLanguage())%>&nbsp;&nbsp;<font color="red"><%=message%></font></TH>
		   				</TR>
	       			<TR class="Spacing"><TD class="Line1" colSpan=2></TD></TR>
	       			<TR>
								<TD><%=SystemEnv.getHtmlLabelName(21804,user.getLanguage())%></TD>
								<TD class="Field"> 
								<input class="inputStyle" type="checkbox" name="txtUserUse" <%=ischecked%> value="1" onclick="if(this.checked){setting.style.display='';}else{setting.style.display='none';}">
								</TD>
	       			</TR>
	       			<TR><TD class=Line colSpan=2></TD></TR>
						</table>
						<div id=setting <%if(ischecked.equals("")){%>style="display:none"<%}else{%>style="display:''"<%}%>>
							<table class="viewform" >
	   					<COLGROUP>
	   					<COL width="30%">
							<COL width="70%">
								<TR>
									<td><b><%=SystemEnv.getHtmlLabelName(21683,user.getLanguage())%></b></td>
									<td align=right>
										<a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="addRowOfFieldTriggerPop()"><img src="/js/swfupload/add.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></a>
										<a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="deleteRowOfFieldTrigger()"><img src="/js/swfupload/delete.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></a>
									</td>
			   				</TR>
			   				<TR><TD class=Line1 colSpan=2></TD></TR>
							</table>
							<table id=LinkageTable class="viewform" cols=2>
		   					<COLGROUP>
			   					<COL width="10%">
								<COL width="90%">
								<%
								int index = 0;
								RecordSet.executeSql("select * from modeDataInputentry where modeid="+modeId);
								while(RecordSet.next()){
									int entryID = RecordSet.getInt("id");
									String TriggerName = RecordSet.getString("TriggerName");
									String TriggerFieldName = RecordSet.getString("TriggerFieldName");
									String fieldid = TriggerFieldName.substring(5,TriggerFieldName.length());
									String fieldname = "";
									String isbill = "";
									String formid = "";
									rs1.executeSql("select formid from modeinfo where id="+modeId);
									if(rs1.next()){
										formid = rs1.getString("formid");
									}
									rs1.executeSql("select fieldlabel,viewtype from workflow_billfield where id="+fieldid+" and billid="+formid);
									if(rs1.next()){
										fieldname = SystemEnv.getHtmlLabelName(rs1.getInt("fieldlabel"), user.getLanguage());
									}
									TriggerName = "".equals(TriggerName)?("".equals(fieldname)?TriggerFieldName:fieldname):TriggerName;
								%>
								<tr>
									<td class=field>
										<input type="checkbox" name="checkbox_TriggerField" value="<%=entryID%>">
										<input type="hidden" name="fieldEntryID" value="<%=entryID%>">
									</td>
									<td class=field><a href="#" onclick="showRowOfFieldTriggerPop('<%=entryID %>');"><%=TriggerName %></a></td>
								</tr>
								<%
									index++;
								}
								%>
							</table>
						</div>
					</td>
				</tr>
			</TABLE>
		</td>
		<td ></td>
	</tr>
</table>
</form>
<script type="text/javascript">
$(document).ready(function(){//onloadÊÂ¼þ
	$(".loading", window.parent.document).hide(); //Òþ²Ø¼ÓÔØÍ¼Æ¬
})
var iTop=(window.screen.height-580)/2;
var iLeft=(window.screen.width-900)/2;

function addRowOfFieldTriggerPop(){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/fieldTriggerEntry.jsp?modeId=<%=modeId%>",window,"dialogWidth:900px;dialogHeight:580px;dialogTop: "+iTop+"; dialogLeft: "+iLeft)
	if(id == undefined || id =='undefined')
		window.location.reload();
}

function showRowOfFieldTriggerPop(entryID){
	urls = escape("/formmode/setup/fieldTriggerEntry.jsp?modeId=<%=modeId%>&entryID="+entryID);
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+urls,window,"dialogWidth:900px;dialogHeight:580px;dialogTop: "+iTop+"; dialogLeft: "+iLeft)
	if(id == undefined || id =='undefined')
		window.location.reload();
}

function deleteRowOfFieldTrigger(){
    var oTable=$G('LinkageTable');
    curindex=0;
    len = document.frmTrigger.elements.length;
    var i=0;
    var rowsum1 = 0;
    var delsum=0;
    for(i=len-1; i >= 0;i--) {
        if (document.frmTrigger.elements[i].name=='checkbox_TriggerField'){
            rowsum1 += 1;
            if(document.frmTrigger.elements[i].checked==true) delsum+=1;
        }
    }
    if(delsum<1){
    	alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
    }else{
        if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
            for(i=len-1; i >= 0;i--) {
                if (document.frmTrigger.elements[i].name=='checkbox_TriggerField'){
                    if(document.frmTrigger.elements[i].checked==true) {
                        oTable.deleteRow(rowsum1-1);
                        curindex--;
                    }
                    rowsum1 -=1;
                }

            }
        }
    }
    frmTrigger.submit();
}

function flowTriggerSave(obj){
	var triggerNum = $G("triggerNum").value;
	for(var tempTriggerIndex=0;tempTriggerIndex<triggerNum;tempTriggerIndex++){
		if($G("triggerField"+tempTriggerIndex)){
			var triggerfield = $G("triggerField"+tempTriggerIndex).value;
			if(triggerfield==""){
				alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
				return;
			}
		}
	}
	obj.disabled=true;
	doPost(frmTrigger,tab000002);
}
</script>
</body>
</html>