<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.docs.category.security.AclManager" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<html><head>

<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String wtid = Util.null2String(request.getParameter("wtid"));

	RecordSet.execute("select useapprovewf, approvewf from worktask_base where id="+wtid);
	RecordSet.next();

	int useapprovewf = Util.getIntValue(RecordSet.getString("useapprovewf"), 0);
	int approvewf = Util.getIntValue(RecordSet.getString("approvewf"), 0);

%>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.reload(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM METHOD="POST" name="frmMain" id="frmMain" ACTION="WTApproveWfOperation.jsp">
<INPUT TYPE="hidden" NAME="operation">
<INPUT TYPE="hidden" NAME="wtid" value="<%=wtid%>">
<INPUT TYPE="hidden" NAME="approvewf" id="approvewf" value="<%=approvewf%>">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<table class="viewForm">
			<COLGROUP>
			<COL width="40%">
			<COL width="60%">
			<TBODY>
			<TR class=Title>
				<TH colSpan=2><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())+SystemEnv.getHtmlLabelName(18436,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height:2px">
            	<TD class=Line1 colSpan=2></TD>
			</TR>
			<TR>
	            <TD><%=SystemEnv.getHtmlLabelName(19540,user.getLanguage())%></TD>
	            <TD class=Field><input class="inputStyle" type="checkbox" name="useapprovewf" value="1" <%if (useapprovewf == 1){out.println("checked");}%>  onclick="showContent(this)" ></TD>
			</TR>
			<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
			<TR  name="approvewftr1" id="approvewftr1" style="display:<%if (useapprovewf == 0){out.println("none");}%>">
				<TD><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></TD>
				<TD class=Field>
					<button type="button" class=browser onclick="onShowWorkflow(approvewf, approvewfSpan)"></button>
					<span id="approvewfSpan">
					<%
					if(useapprovewf == 1){
						out.println(Util.toScreen(WorkflowComInfo.getWorkflowname(""+approvewf), user.getLanguage()));
					}else{
						out.println("<IMG src='/images/BacoError.gif' align=absMiddle>");
					}%>
					</span>
				</TD>
			</TR>
			<TR  name="approvewftr2" id="approvewftr2" style="height:1px;display:<%if (useapprovewf == 0){out.println("none");}%>"><TD class=Line colSpan=2></TD></TR>
            <TR>
                <TD height="15" colspan="2"></TD>
            </TR>
			</TBODY>
		</table>
      <DIV id="contentDiv" 
<%
    if(useapprovewf == 1) { 
%> style="display:block" 
<%
    } else {
%> style="display:none" 
<%
    }
%>
    >
	<%
int languageId=user.getLanguage();
%>
		<table class="viewForm">
			<COLGROUP>
			<COL width="100%">
			<TBODY>
			<TR class=Title>
				<TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="heiht:1px">
            	<TD class=Line1 ></TD>
			</TR>
			<TR>
	            <TD>
                    <ul>
					  <li><%=SystemEnv.getHtmlLabelName(21966, user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(21967, user.getLanguage())%></li>
                    </ul>

				</TD>
			</TR>
			<TR style="height:1px"><TD class=Line></TD></TR>
            <TR>
                <TD height="15" colspan="2"></TD>
            </TR>
			</TBODY>
		</table>
      </DIV>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="0" colspan="3"></td>
</tr>
</table>
</FORM>
</BODY>
</html>

<SCRIPT LANGUAGE="JavaScript">

function onSave(obj){
    if($GetEle("useapprovewf").checked&&jQuery("#approvewf").val()=="0") {
        alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
		return ;
	}
	obj.disabled=true;
	document.frmMain.operation.value="editapprovewf";
	document.frmMain.submit();
}

function showContent(obj){
	if(obj.checked == true){
		jQuery("#contentDiv").show();
		jQuery("#approvewftr1").show();
		jQuery("#approvewftr2").show();
	}else{
		jQuery("#contentDiv").hide();
		jQuery("#approvewftr1").hide();
		jQuery("#approvewftr2").hide();
	}
}

function onShowWorkflow(inputName, spanName){
	url=encode("/workflow/workflow/WorkflowBrowser.jsp?isValid=1&sqlwhere=where isbill=1 and formid=207 ");
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	
	if (data!=null){ 
	    if (data.id!= 0){
	    	jQuery(spanName).html(data.name);
			jQuery(inputName).val(data.id);
		} else {
			jQuery(spanName).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery(inputName).val("0");
	    }
	}
}

function encode(str){
    return escape(str);
}

function useSetto(){
	url=escape("/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=4&useapprovewf=<%=useapprovewf%>&approvewf=<%=approvewf%>");
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, window);
}
</SCRIPT>

