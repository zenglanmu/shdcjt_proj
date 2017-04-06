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
    //×ÓÄ¿Â¼id
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();

	String subcategoryid=RecordSet.getString("subcategoryid");
	String isOpenApproveWf=Util.null2String(RecordSet.getString("isOpenApproveWf"));
	String validityWfId=Util.null2String(RecordSet.getString("validityApproveWf"));
	String invalidityWfId=Util.null2String(RecordSet.getString("invalidityApproveWf"));

	String approveWorkflowId=Util.null2String(RecordSet.getString("approveWorkflowId"));

	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);


	boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	AclManager am = new AclManager();
	hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
	hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);

    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSubManageRight || hasSecManageRight) {
		canEdit = true ;   
	}
%>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
  //²Ëµ¥
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;

	  RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM METHOD="POST" name="frmMain" ACTION="DocSecCategoryApproveWfOperation.jsp">
<INPUT TYPE="hidden" NAME="operation">
<INPUT TYPE="hidden" NAME="id" value="<%=id%>">
<INPUT TYPE="hidden" NAME="hisValidityWfId" value="<%=validityWfId%>">
<INPUT TYPE="hidden" NAME="hisInvalidityWfId" value="<%=invalidityWfId%>">


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
		<table class="viewForm">
			<COLGROUP>
			<COL width="40%">
			<COL width="60%">
			<TBODY>
			<TR class=Title>
				<TH colSpan=2><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height: 1px!important;">
            	<TD class=Line1 colSpan=2 style="height: 1px!important;padding: 0"></TD>
			</TR>
			<TR>
	            <TD><%=SystemEnv.getHtmlLabelName(19540,user.getLanguage())%></TD>
	            <TD class=Field><input class="inputStyle" type="radio" name="isOpenApproveWf" value="1" <%if ("1".equals(isOpenApproveWf)) out.println("checked");%>  onclick="showContent(1)" <%if(!canEdit){%>disabled<%}%>></TD>
			</TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=3 style="padding:0;"></TD></TR>
			<TR>
	            <TD><%=SystemEnv.getHtmlLabelName(19758,user.getLanguage())%></TD>
	            <TD class=Field><input class="inputStyle" type="radio" name="isOpenApproveWf" value="2" <%if ("2".equals(isOpenApproveWf)) out.println("checked");%>  onclick="showContent(2)" <%if(!canEdit){%>disabled<%}%>></TD>
			</TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=3 style="padding:0;"></TD></TR>
            <TR>
                <TD height="15" colspan="3" style="padding:0;"></TD>
            </TR>
			</TBODY>
		</table>
      <DIV id="contentDiv" 
<%
    if("1".equals(isOpenApproveWf)) { 
%> style="display:block" 
<%
    } else {
%> style="display:none" 
<%
    }
%>
    >
		<TABLE class=ListStyle cellspacing=1 >
			<COLGROUP> 
			  <COL width="40%">
			  <COL width="40%">
			  <COL width="20%">
			<TBODY>
			<TR class=Title>
				<TH colSpan=2><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height: 1px!important;">
            	<TD class=Line1 colSpan=3 style="height: 1px!important;padding: 0"></TD>
			</TR>
            <TR class=Header>
                <TH><%=SystemEnv.getHtmlLabelName(19535,user.getLanguage())%></TH>
                <TH><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage())%></TH>
                <TH><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></TH>
            </TR>
			<TR class=DataLight>
				<TD><%=SystemEnv.getHtmlLabelName(19536,user.getLanguage())%></TD>
				<TD>
<%
    if(canEdit){
%>
			<input  class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1" _callBack="addMoeSpanText1"  _displayText="<%=Util.toScreen(WorkflowComInfo.getWorkflowname(validityWfId),user.getLanguage())%>" type=hidden name="validityWfId" value="<%=validityWfId%>">
<%
    }else{
%>
                     <span id=validityWfSpan><%=Util.toScreen(WorkflowComInfo.getWorkflowname(validityWfId),user.getLanguage())%></span>
<%} %>
              ¡¡¡¡¡¡¡¡

			  ¡¡</TD>
				<TD><span id=validityMoreSpan>
<%
    if(validityWfId!=null&&!validityWfId.equals("")&&!validityWfId.equals("0")){
%>
				<a href="DocSecCategoryApproveWfDetailEdit.jsp?id=<%=id%>&approveType=1&approveWfId=<%=validityWfId%>"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>
<%
	}else{
%>
				<a><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>
<%
    }	
%>

				</span></TD>
			</TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=3 style="padding:0;"></TD></TR>
			<TR class=DataDark>
		        <TD><%=SystemEnv.getHtmlLabelName(19537,user.getLanguage())%></TD>
			    <TD>
<%
    if(canEdit){
%>
			<input  class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1" _callBack="addMoeSpanText2"  _displayText="<%=Util.toScreen(WorkflowComInfo.getWorkflowname(invalidityWfId),user.getLanguage())%>" type=hidden name="invalidityWfId" value="<%=invalidityWfId%>">
<%
	}else{
%>
			<span id=invalidityWfSpan><%=Util.toScreen(WorkflowComInfo.getWorkflowname(invalidityWfId),user.getLanguage())%></span>
<%} %>              ¡¡¡¡¡¡
                </TD>
			    <TD><span id=invalidityMoreSpan>
<%
    if(invalidityWfId!=null&&!invalidityWfId.equals("")&&!invalidityWfId.equals("0")){
%>
				<a href="DocSecCategoryApproveWfDetailEdit.jsp?id=<%=id%>&approveType=2&approveWfId=<%=invalidityWfId%>"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>
<%
    }else{	
%>
				<a  ><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>
<%
    }	
%>

				</span></TD>
			</TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=3 style="padding:0;"></TD></TR>
            <TR>
                <TD height="15" colspan="3"></TD>
            </TR>
			</TBODY>
		</table>

      </DIV>

      <DIV id="contentDivHis" 
<%
    if("2".equals(isOpenApproveWf)) { 
%> style="display:block" 
<%
    } else {
%> style="display:none" 
<%
    }
%>
    >
		<TABLE class=ListStyle cellspacing=1 >
			<COLGROUP> 
			  <COL width="40%">
			  <COL width="60%">
			<TBODY>
			<TR class=Title>
				<TH colSpan=2><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height: 1px!important;">
            	<TD class=Line1 colSpan=3 style="height: 1px!important;padding: 0"></TD>
			</TR>
            <TR class=Header>
                <TH><%=SystemEnv.getHtmlLabelName(19761,user.getLanguage())%></TH>
                <TH><%=SystemEnv.getHtmlLabelName(19762,user.getLanguage())%></TH>
            </TR>

			<TR class=DataLight>
				<TD><%=SystemEnv.getHtmlLabelName(1003,user.getLanguage())%></TD>
				<TD>
<%
    if(canEdit){
%>
   ¡¡¡¡<input class="wuiBrowser" type=hidden name="approveWorkflowId" _beforeShow="encodeUrl" _url="/workflow/workflow/WorkflowBrowser.jsp?isValid=1&sqlwhere=where isbill=1 and formid=28" _displayText="<%=Util.toScreen(WorkflowComInfo.getWorkflowname(approveWorkflowId),user.getLanguage())%>" value="<%=approveWorkflowId%>">
<%
    }else{
%>    
<span id="approveWorkflowIdSpan"><%=Util.toScreen(WorkflowComInfo.getWorkflowname(approveWorkflowId),user.getLanguage())%></span>
             ¡¡¡¡<%} %>
			  ¡¡</TD>
			</TR>
            <TR style="height:1px;">
                <TD height="15" colspan="2" style="padding:0;"></TD>
            </TR>
			</TBODY>
		</table>
      </DIV>
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
			<TR class=Spacing style="height: 1px!important;">
            	<TD class=Line1 colSpan=3 style="height: 1px!important;padding: 0"></TD>
			</TR>
			<TR>
	            <TD>
                    <p><strong><%=SystemEnv.getHtmlLabelName(19540,user.getLanguage())%>£º</strong></p>
                    <ul>
					  <li><%=SystemEnv.getHtmlLabelName(20291,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(20292,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(20293,user.getLanguage())%></li>
                    </ul>

				</TD>
			</TR>
			<TR style="height: 1px!important;"><TD class=Line></TD></TR>
			<TR>
	            <TD>
                    <p><strong><%=SystemEnv.getHtmlLabelName(19758,user.getLanguage())%>£º</strong></p>
                    <ul>
					  <li><%=SystemEnv.getHtmlLabelName(20294,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(20295,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(20296,user.getLanguage())%></li>
                    </ul>
				</TD>
			</TR>
			<TR style="height: 1px!important;"><TD class=Line></TD></TR>
            <TR style="height: 15px!important;">
                <TD height="15" colspan="3" style="padding:0;"></TD>
            </TR>
			</TBODY>
		</table>



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
</html>

<SCRIPT LANGUAGE="JavaScript">

function onSave(obj){
	obj.disabled=true;
	document.frmMain.operation.value="editApproveWf";
	document.frmMain.submit();
}
 
function onClear(obj){
	obj.disabled=true;

	document.frmMain.isOpenApproveWf[0].checked=false;
	document.frmMain.isOpenApproveWf[1].checked=false;
    document.all("contentDiv").style.display = "none";
    document.all("contentDivHis").style.display = "none";

	document.frmMain.operation.value="editApproveWf";
	document.frmMain.submit();
}

function showContent(objId)
{
	if(objId==1){
        document.all("contentDiv").style.display = "block";
    	document.all("contentDivHis").style.display = "none";
	}else if(objId==2){
        document.all("contentDiv").style.display = "none";
    	document.all("contentDivHis").style.display = "block";
	}
}

function encode(str){
    return escape(str);
}

function addMoeSpanText1(data,e){
	if(data.id!=""){
		jQuery("#validityMoreSpan").html("<a HREF='DocSecCategoryApproveWfDetailEdit.jsp?id=<%=id%>&approveType=1&approveWfId="+data.id+"' ><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
	}else{
		jQuery("#validityMoreSpan").html("<a><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
	}
}
function addMoeSpanText2(data,e){
	if(data.id!=""){
		jQuery("#invalidityMoreSpan").html("<a HREF='DocSecCategoryApproveWfDetailEdit.jsp?id=<%=id%>&approveType=2&approveWfId="+data.id+"' ><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
	}else{
		jQuery("#invalidityMoreSpan").html("<a><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>");
	}
}

function encodeUrl(option,e){
}
</SCRIPT>