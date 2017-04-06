<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>

<%@ page import = "weaver.general.TimeUtil"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSetA" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891 --%>
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>

<%
String isview = Util.null2String(request.getParameter("isview")) ;
String fromFlowDoc = Util.null2String(request.getParameter("fromFlowDoc")) ;
int modeid = Util.getIntValue(request.getParameter("modeid"),0) ;
String requestid = Util.null2String(request.getParameter("requestid")) ;
String workflowid = Util.null2String(request.getParameter("workflowid")) ;

String nodeid = "";
String status = "";
String requestmark = "";
rs.executeSql("select currentnodeid,status,requestmark from workflow_requestbase where requestid='"+requestid+"'");
if(rs.next()){
	nodeid = rs.getString("currentnodeid");
	status = rs.getString("status");
	requestmark = rs.getString("requestmark");
}
String workflowname = "";
rs.executeSql("select workflowname from workflow_base where id='"+workflowid+"'");
if(rs.next()){
	workflowname = rs.getString("workflowname");
}

String isbill = Util.null2String(request.getParameter("isbill")) ;
String formid = Util.null2String(request.getParameter("formid")) ;
String sql = "" ;
// add by xhheng @20050206 for TD 1544
String userid=new Integer(user.getUID()).toString();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 内部用户  2:外部用户

String imagefilename = "/images/hdReport.gif";
String titlename =  SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())
	                +" - "+Util.toScreen(workflowname,user.getLanguage())
	                +" - " + status + " "+requestmark;
String needfav ="1";
String needhelp ="";

boolean isOldWf_ = false;
RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSetOld.next()){
	if(RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))){
			isOldWf_ = true;
	}
}
if(isOldWf_){
String url = "/workflow/request/WorkflowManageRequestPicture_old.jsp?requestid=" + requestid + "&workflowid="+workflowid+"&nodeid="+nodeid+"&isbill="+isbill+"&formid="+formid;
response.sendRedirect(url);

}
%>

<HTML>
	<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<style>
.wordSpan{font-family:MS Shell Dlg,Arial;CURSOR: hand;font-weight:bold;FONT-SIZE: 10pt}
#divTopMenu {
	background:#fff!important;
}
</style>
</HEAD>
<BODY>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_self}" ;
	//RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
  <table width=100% height=94% border="0" cellspacing="0" cellpadding="0">
  	<tr>
			<td height="10"></td>
		</tr>
  	<tr>
			<td width=10></td>
			<td valign="top">
		
				<TABLE class=Shadow>
				<TR>
				    <TD>
					    <!-- 
					    <div style="display:none">
								<iframe ID="picInnerFrame" BORDER=0 FRAMEBORDER=no height="0%" width="0%" scrolling="NO" src="/workflow/request/WorkflowRequestPictureInner.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&temptopsize=52"></iframe>
					    </div>
					    -->					   
						<div style="height:100%;">
							<jsp:include page="WorkflowRequestPictureInner.jsp" flush="true">
							<jsp:param name="requestid" value="<%=requestid%>" />
							<jsp:param name="workflowid" value="<%=workflowid%>" />
							<jsp:param name="nodeid" value="<%=nodeid%>" />
							<jsp:param name="isbill" value="<%=isbill%>" />
							<jsp:param name="formid" value="<%=formid%>" />
							<jsp:param name="isfromdirection" value="1" />
							<jsp:param name="wfd" value="1" />
							</jsp:include>		
				        </div>
				  	</TD>				    			        
			       <TR>						
			  </TABLE>
			 </td>
			 <td width=10></td>
			</tr>
		</table>
</BODY>
</HTML>
<SCRIPT language=javascript>
//setTimeout("chckImageTdInnerValue();",100);

jQuery(document).ready(function () {
	if (window.ActiveXObject) {
		chckImageTdInnerValue();
	} else {
		jQuery("#wfRstPicImg").bind("load", function () {
			chckImageTdInnerValue();
		});
	}
});

function chckImageTdInnerValue(){
	//if(document.getElementById("ImageTdInner").innerHTML!=""){
		alert("<%=SystemEnv.getHtmlLabelName(21430,user.getLanguage())%>");
		window.close();
	//}else{
		//setTimeout("chckImageTdInnerValue();",100);
	//}
}
</SCRIPT>
<SCRIPT language=VBS>
Sub oc_CurrentMenuOnMouseOut(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = "hidden"
End Sub

Sub oc_CurrentMenuOnClick(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = ""
End Sub
</SCRIPT>