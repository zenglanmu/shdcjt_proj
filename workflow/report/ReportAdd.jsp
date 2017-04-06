<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<%
 if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage());
String needfav ="1";
String needhelp ="";
String reportType = Util.null2String(request.getParameter("reportType"));
reportType = (Util.getIntValue(reportType,0)<=0)?"":reportType;
String subcompanyid= Util.null2String(request.getParameter("subcompanyid"));
subcompanyid = (Util.getIntValue(subcompanyid,0)<=0)?"":subcompanyid;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/report/ReportManage.jsp?subcompanyid="+subcompanyid+"&otype="+reportType+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<iframe id="workFlowIFrame" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<FORM id=weaver name=frmMain action="ReportOperation.jsp" method=post onsubmit="return false">

<%
 // if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
%>


<%
// }
%>

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

<TABLE class="viewform">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class="Title">
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></TH>
    </TR>
  <TR class="Spacing" style="height:1px;">
    <TD class="Line1" colSpan=2 ></TD></TR>
  <TR>
          
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
        <INPUT type=text class=Inputstyle size=30 name="reportname" onchange='checkinput("reportname","reportnameimage")'>
          <SPAN id=reportnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>  <TR class="Spacing" style="height:1px;">
    <TD class="Line" colSpan=2 ></TD></TR>
        <TR>
          
      <TD><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></TD>
          
      <TD class=Field>
      
              <INPUT type=hidden class="wuiBrowser" name=reportType id=reportType value="<%=reportType%>" _displayText="<%=Util.toScreen(ReportTypeComInfo.getReportTypename(reportType),user.getLanguage()) %>"
              	_url="/systeminfo/BrowserMain.jsp?url=/workflow/report/ReportTypeBrowser.jsp?rightStr=WorkflowReportManage:All&isedit=1" _required="yes"
              >
           </TD>
        </TR>  <TR class="Spacing"  style="height:1px;">
    <TD class="Line" colSpan=2 ></TD></TR>
  	<% if(detachable==1){ %>
	 <tr>
       	 <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
         <td class=field >
           	<BUTTON class=Browser type="button" id=SelectSubCompany onclick="onShowSubcompany()"></BUTTON>
        	<SPAN id=subcompanyspan><% if(subcompanyid.equals("")){ %>
        												<IMG src="/images/BacoError.gif" align=absMiddle>
        												<%}else{
        													out.print(SubComanyComInfo.getSubCompanyname(subcompanyid)); 
        												}%></SPAN>
            <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid %>">
         </td>
    </tr>
    <TR class="Spacing"  style="height:1px;">
		 <TD class="Line" colSpan=2 ></TD>
    </TR>
   <% } %>
  
    <TR>          
        <TD><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></TD>          
        <TD class=Field>
            <BUTTON type='button' class=Browser onclick="onShowFormOrBill(isBill, formID, reportWorkFlowIDImage)"></BUTTON> 
            <SPAN id=reportWorkFlowIDImage><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> 
            <INPUT type=hidden name=isBill id=isBill value="">
            <INPUT type=hidden name=formID id=formID value="">
        </TD>
    </TR>
            
    <TR  style="height:1px;"><TD class="Line" colSpan=2 ></TD></TR>
  
    <TR>
    	<TD colSpan=2>
	    	<DIV id = "workFlowIDDIV" style="display:none">  
				<TABLE class="listStyle" id="oTable" name="oTable">
					<TR>
			        	<TD width="20%"><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></TD>          
			        	<TD width="80%" class=Field>
				        	<INPUT type=hidden class="wuiBrowser" name=workflowID id=workflowID value=""
                                   	_url="/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
                                   	_beforeShow="WorkFlowBeforeShow" _required="yes"
                                   >
				        </TD>
				    </TR>
				        <TR class="Spacing"  style="height:1px;">
					        <TD class="Line" colSpan=2 style="padding:0;"></TD>
					    </TR>
				</TABLE>
	        </DIV>    	
    	</TD>
    </TR>  
   		     


    <TR>          
        <TD><%=SystemEnv.getHtmlLabelName(20832,user.getLanguage())%></TD>          
        <TD class=Field>
		    <INPUT type=checkbox name="isShowOnReportOutput" value="1" >
        </TD>
    </TR>
            
    <TR  style="height:1px;"><TD class="Line" colSpan=2 ></TD></TR>	
    
    <input type="hidden" name=operation value=reportadd>
 </TBODY></TABLE>
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

 </form>
 
<SCRIPT LANGUAGE="javascript">

function onShowFormOrBill(isBill, inputName, spanName){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/FormBillBrowser.jsp");
	if (datas){
		if (datas.id!=""){
			$(isBill).val(datas.isBill);
			$(inputName).val(datas.id);
			$(spanName).html(datas.name);
			showDiv("1");
			$("#workflowID").val("");
			$("#workflowIDSpan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			
	}else{
			$(spanName).html( "<IMG src='/images/BacoError.gif' align=absMiddle>");
			$(isBill).val( "");
			$(inputName).val( "");
			showDiv("0");
	}
	}
}

function WorkFlowBeforeShow(opts,e){
	isBill = document.all("isBill").value
	formID = document.all("formID").value
	workflowID = document.all("workflowID").value
	opts._url=opts._url+"?value="+isBill+"_"+formID+"_"+workflowID;
}

function submitData()
{
	var checkfields = "";
	<%if(detachable==1){%>
        checkfields = 'reportname,reportType,formID,workflowID,subcompanyid';
    <%}else{%>
    	checkfields = 'reportname,reportType,formID,workflowID';
    <%}%>
	if (check_form(frmMain,checkfields))
		frmMain.submit();
}

function submitIFrame()
{
	document.all("workFlowIFrame").src = "WorkFlowofFormIFrame.jsp?isBill=" + document.all("isBill").value + "&formID=" + document.all("formID").value;
}

function showDiv(isShow)
{
	if("1" == isShow)	
	{
		document.all("workFlowIDDIV").style.display = "block";
	}
	else
	{
		document.all("workFlowIDDIV").style.display = "none";
	}
}
function onShowSubcompany(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowReportManage:All&isedit=1&selectedids="+$("input[name=subcompanyid").val());
	
	issame = false
	if (data){
		if (data.id!="0"&&data.id){
			if(data.id== $("input[name=subcompanyid").val()){
				issame = true;
			}
			$("#subcompanyspan").html(data.name);
			$("input[name=subcompanyid]").val(data.id);
		}else{
			$("#subcompanyspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			$("input[name=subcompanyid]").val(data.id);
		}
	}
	}
</SCRIPT>

</BODY></HTML>
