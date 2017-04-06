<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>    
</head>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(30185,user.getLanguage());
String needfav ="1";
String needhelp ="";

int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
String customname = Util.null2String(request.getParameter("customname"));
String modeid=Util.null2String(request.getParameter("modeid"));
String modename = "";
String sql = "";
if(!modeid.equals("")){
	sql = "select modename from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		modename = Util.null2String(rs.getString("modename"));
	}
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javaScript:doAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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

<form name="frmSearch" method="post" action="/formmode/interfaces/WorkflowToModeList.jsp">
	<table class="ViewForm">
		<COLGROUP>
			<COL width="15%">
			<COL width="35%">
			<COL width="15%">
			<COL width="35%">
		</COLGROUP>
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>
			</td>
			<td class=Field>
				<input class="wuiBrowser" name="workflowid" type="hidden" value="<%=workflowid%>" _displayText="<%=WorkflowComInfo.getWorkflowname(String.valueOf(workflowid))%>" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isbill=1 and formid<0 ">
			</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%>
			</td>
			<td class="Field">
		  		 <button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></BUTTON>
		  		 <span id=modeidspan><%=modename%></span>
		  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
	</table>
</form>

<%
String SqlWhere = " where a.modeid = b.id";
if(workflowid>0){
	SqlWhere += " and a.workflowid = "+workflowid+" ";
}
if(!modeid.equals("")){
	SqlWhere += " and a.modeid = '"+modeid+"'";
}

String perpage = "10";
String backFields = "a.id,a.modeid,a.workflowid,a.modecreater,a.modecreaterfieldid,a.triggerNodeId,a.triggerType,a.isenable,b.modename,'œÍœ∏…Ë÷√' detail";
String sqlFrom = " from mode_workflowtomodeset a,modeinfo b";
//out.println("select " + backFields + "	"+sqlFrom + "	"+ SqlWhere);
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
				  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
				  "<head>"+                             
						  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\"/>"+
						  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(28485,user.getLanguage())+"\" column=\"modename\" orderkey=\"modename\"/>"+
						  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18624,user.getLanguage())+"\" column=\"isenable\" orderkey=\"isenable\" transmethod=\"weaver.formmode.interfaces.WfToModeTransmethod.getIsEnable\" otherpara=\""+user.getLanguage()+"\"/>"+
						  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19346,user.getLanguage())+"\" column=\"triggerNodeId\" orderkey=\"triggerNodeId\" transmethod=\"weaver.formmode.interfaces.WfToModeTransmethod.getTriggerNodeId\"/>"+
						  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19347,user.getLanguage())+"\" column=\"triggerType\" orderkey=\"triggerType\" transmethod=\"weaver.formmode.interfaces.WfToModeTransmethod.getTriggerType\" otherpara=\""+user.getLanguage()+"\"/>"+
						  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19342,user.getLanguage())+"\" column=\"detail\" orderkey=\"detail\"  target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"/formmode/interfaces/WorkflowToModeSet.jsp?initmodeid="+modeid+"&amp;initworkflowid="+workflowid+"\"/>"+
				  "</head>"+
			  "</table>";


%>

<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>

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
<script type="text/javascript">
	$(document).ready(function(){//onload ¬º˛
		$(".loading", window.parent.document).hide(); //“˛≤ÿº”‘ÿÕº∆¨
	})

    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function doAdd(){
		enableAllmenu();
        location.href="/formmode/interfaces/WorkflowToModeSet.jsp?isadd=1&initmodeid=<%=modeid%>&initworkflowid=<%=workflowid%>";
    }
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
</script>

</BODY>
</HTML>