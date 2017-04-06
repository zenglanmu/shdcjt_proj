<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<%

boolean canEdit=false;
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	canEdit=true;
}

int design = Util.getIntValue(request.getParameter("design"),0);

int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
String isBill = Util.null2String(request.getParameter("isBill"));
int yearId = Util.getIntValue(request.getParameter("yearId"),0);
int monthId = Util.getIntValue(request.getParameter("monthId"),0);
int dateId = Util.getIntValue(request.getParameter("dateId"),0);
int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
int fieldValue = Util.getIntValue(request.getParameter("fieldValue"),0);
int supSubCompanyId = Util.getIntValue(request.getParameter("supSubCompanyId"),0);
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);

int recordId = Util.getIntValue(request.getParameter("recordId"),0);
int sequenceId=1;
if(recordId<=0){
	int tempWorkflowId=-1;
	int tempFormId=-1;
	String tempIsBill="0";
	int tempYearId=-1;
	int tempMonthId=-1;
	int tempDateId=-1;
	
	int tempFieldId=-1;
	int tempFieldValue=-1;
	
	int tempSupSubCompanyId=-1;
	int tempSubCompanyId=-1;
	int tempDepartmentId=-1;
	
	int tempRecordId=-1;
	int tempSequenceId=1;
	
	CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);	
	CoderBean cb = cbuild.getFlowCBuild();
	
	String workflowSeqAlone=cb.getWorkflowSeqAlone();
	String dateSeqAlone=cb.getDateSeqAlone();
	String dateSeqSelect=cb.getDateSeqSelect();
	String fieldSequenceAlone=cb.getFieldSequenceAlone();
	String struSeqAlone=cb.getStruSeqAlone();
	String struSeqSelect=cb.getStruSeqSelect();
	
	if("1".equals(workflowSeqAlone)){
		tempWorkflowId=workflowId;
	}else{
		tempFormId=formId;
	    tempIsBill=isBill;
	}
	
	if("1".equals(dateSeqAlone)&&"1".equals(dateSeqSelect)){
		tempYearId=yearId;
	}else if("1".equals(dateSeqAlone)&&"2".equals(dateSeqSelect)){
		tempYearId=yearId;
		tempMonthId=monthId;						
	}else if("1".equals(dateSeqAlone)&&"3".equals(dateSeqSelect)){
		tempYearId=yearId;						
		tempMonthId=monthId;	
		tempDateId=dateId;							
	}
					
	if("1".equals(fieldSequenceAlone)&&fieldId>0 ){
		tempFieldId=fieldId;
		tempFieldValue=fieldValue;
	}
					
	if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){
		tempSupSubCompanyId=supSubCompanyId;
		tempSubCompanyId=-1;
		tempDepartmentId=-1;						
	}
	if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){
		tempSupSubCompanyId=-1;
		tempSubCompanyId=subCompanyId;
		tempDepartmentId=-1;						
	}
	if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){
		tempSupSubCompanyId=-1;
		tempSubCompanyId=-1;
		tempDepartmentId=departmentId;						
	}

	RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

	if(RecordSet.next()){
		tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
		tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
	}

    if(tempRecordId>0){
		recordId = tempRecordId;
		sequenceId = tempSequenceId;
	}
}else{
	RecordSet.executeSql("select sequenceId from workflow_codeSeq where id="+recordId);

	if(RecordSet.next()){
		sequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
	}
}

String src = Util.null2String(request.getParameter("src"));

if(src.equals("delete")){
	String[] checkids = request.getParameterValues("check_node");
	if(checkids!=null){
		for(int i=0;i<checkids.length;i++){
			RecordSet.executeSql("update workflow_codeSeqReserved set hasDeleted=1  where id="+checkids[i]);
		}
	}
}

%>

<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(22782,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
%>

<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}
if(design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showViewReservedCodeOperate.jsp" method="post">

<input type="hidden" value="" name="src">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" value="<%=workflowId%>" name="workflowId">
<input type="hidden" value="<%=formId%>" name="formId">
<input type="hidden" value="<%=isBill%>" name="isBill">
<input type="hidden" value="<%=recordId%>" name="recordId">


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
                                       <COL width="25%">
                                       <COL width="75%">
                                    <TR class="Title">
                                        <TH colspan=2><%=SystemEnv.getHtmlLabelName(22782,user.getLanguage())%></TH>
                                    </TR>                                
                                    <TR class="Spacing">
                                        <TD class="Line1" colSpan=2></TD>
                                    </TR>
                                    <TR>
                                        <TD height="10" colspan="2"></TD>
                                    </TR>
                                </TABLE>
            <table class=liststyle cellspacing=1   cols=2 >
            <COLGROUP>
  	        <COL width="10%">
  	        <COL width="40%">
  	        <COL width="50%">
  	        <tr class=header>
  	           <td></td>
  	           <td><%=SystemEnv.getHtmlLabelName(22779,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
  	        </tr>
  	        <tr class="Line"><td colspan="3"> </td></tr>
<%
    String trClass="DataLight";

    int id=-1;
	int reservedId=-1;
	String reservedCode=null;
	String reservedDesc=null;
	StringBuffer codeSeqReservedSb=new StringBuffer();
	codeSeqReservedSb.append(" select * ")
	                 .append("   from workflow_codeSeqReserved  ")
					 .append("  where codeSeqId= ").append(recordId)
					 .append("    and (hasUsed is null or hasUsed='0') ")
					 .append("    and (hasDeleted is null or hasDeleted='0') ")
					 .append("  order by reservedId asc,id asc ")
					 ;
    RecordSet.executeSql(codeSeqReservedSb.toString());
    while(RecordSet.next()){
		id=Util.getIntValue(RecordSet.getString("id"),-1);
		reservedId=Util.getIntValue(RecordSet.getString("reservedId"),-1);
		reservedCode=Util.null2String(RecordSet.getString("reservedCode"));
		reservedDesc=Util.null2String(RecordSet.getString("reservedDesc"));
%>
	    <tr  class="<%=trClass%>">
            <td  height="23" align="left"><input type='checkbox' name='check_node' value="<%=id%>" ></td>
            <td  height="23" align="left"><%=reservedCode%></td>
            <td  height="23" align="left"><%=reservedDesc%></td>
	    </tr>
<%
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	}
%>

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


</form>

</body>
</html>

<script language=javascript>


function onDelete(){
	document.all("src").value="delete";
	document.SearchForm.submit();
}

function onClose(){
	window.parent.close();
}

//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('showViewReservedCodeOperate');
}
</script>



