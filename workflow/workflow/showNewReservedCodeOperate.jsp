<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowCodeSeqReservedManager" class="weaver.workflow.workflow.WorkflowCodeSeqReservedManager" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<%
Calendar today = Calendar.getInstance();
int yearIdToday = today.get(Calendar.YEAR);
int monthIdToday = today.get(Calendar.MONTH) + 1;  
int dateIdToday = today.get(Calendar.DAY_OF_MONTH);

int design = Util.getIntValue(request.getParameter("design"),0);
int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
String isBill = Util.null2String(request.getParameter("isBill"));
int yearId = Util.getIntValue(request.getParameter("yearId"),0);
if(yearId<=0){
	yearId=yearIdToday;
}

int monthId = Util.getIntValue(request.getParameter("monthId"),0);
if(monthId<=0){
	monthId=monthIdToday;
}

int dateId = Util.getIntValue(request.getParameter("dateId"),0);
if(dateId<=0){
	dateId=dateIdToday;
}

int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
int fieldValue = Util.getIntValue(request.getParameter("fieldValue"),-1);
int supSubCompanyId = Util.getIntValue(request.getParameter("supSubCompanyId"),0);
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);

    WorkflowCodeSeqReservedManager.setYearIdDefault(yearId);
    WorkflowCodeSeqReservedManager.setMonthIdDefault(monthId);
    WorkflowCodeSeqReservedManager.setDateIdDefault(dateId);
    WorkflowCodeSeqReservedManager.setFieldIdDefault(fieldId);
    WorkflowCodeSeqReservedManager.setFieldValueDefault(fieldValue);
    WorkflowCodeSeqReservedManager.setSupSubCompanyIdDefault(supSubCompanyId);
    WorkflowCodeSeqReservedManager.setSubCompanyIdDefault(subCompanyId);
    WorkflowCodeSeqReservedManager.setDepartmentIdDefault(departmentId);

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
	}else{
		RecordSet.executeSql("insert into workflow_codeSeq(yearId,sequenceId,formId,isBill,monthId,dateId,workflowId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId)" +
		" values("+tempYearId+","+tempSequenceId+","+tempFormId+",'"+tempIsBill+"',"+tempMonthId+","+tempDateId+","+tempWorkflowId+","+tempFieldId+","+tempFieldValue+","+tempSupSubCompanyId+","+tempSubCompanyId+","+tempDepartmentId+")");
	    RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

	    if(RecordSet.next()){
		    tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
		    tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
	    }
        if(tempRecordId>0){
		    recordId = tempRecordId;
		    sequenceId = tempSequenceId;
	    }
	}
}else{
	RecordSet.executeSql("select sequenceId from workflow_codeSeq where id="+recordId);

	if(RecordSet.next()){
		sequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
	}
}

    String src = Util.null2String(request.getParameter("src"));
    if(src.equals("save")){
	    String reservedIdStr=Util.null2String(request.getParameter("reservedIdStr"));//格式为：5,6-10,23,34,37,45
		String reservedCode="";
	    String reservedDesc=Util.null2String(request.getParameter("reservedDesc"));
	    reservedDesc=Util.toHtml100(reservedDesc);

		int reservedId=-1;
		int reservedIdBegin=-1;
		int reservedIdEnd=-1;	
		List hisReservedIdList=new ArrayList();
		StringBuffer hisReservedIdSb=new StringBuffer();
		hisReservedIdSb.append(" select reservedId ")
		               .append("   from workflow_codeSeqReserved ")
		               .append("  where codeSeqId=").append(recordId)
		               .append("    and (hasDeleted is null or hasDeleted='0') ")
		               .append("  order by reservedId asc,id asc ")		               
		               ;
		RecordSet.executeSql(hisReservedIdSb.toString());
		while(RecordSet.next()){
			reservedId=Util.getIntValue(RecordSet.getString("reservedId"),-1);
			if(reservedId>0&&hisReservedIdList.indexOf(""+reservedId)==-1){
				hisReservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
			}
		}

		RecordSet.executeSql("select distinct sequenceId from workflow_codeSeqRecord where codeSeqId="+recordId);
		while(RecordSet.next()){
			reservedId=Util.getIntValue(RecordSet.getString("sequenceId"),-1);
			if(reservedId>0&&hisReservedIdList.indexOf(""+reservedId)==-1){
				hisReservedIdList.add(Util.null2String(RecordSet.getString("sequenceId")));
			}
		}
		
		List reservedIdList=Util.TokenizerString(reservedIdStr,",");
		String reservedIdStrPart=null;
		List reservedIdStrPartList=null;
		for(int i=0;i<reservedIdList.size();i++){
			reservedIdStrPart=Util.null2String((String)reservedIdList.get(i));
			reservedIdStrPartList=Util.TokenizerString(reservedIdStrPart,"-");
			if(reservedIdStrPartList.size()>=2){
				reservedIdBegin=reservedId=Util.getIntValue((String)reservedIdStrPartList.get(0),-1);
				reservedIdEnd=reservedId=Util.getIntValue((String)reservedIdStrPartList.get(1),-1);
				if(reservedIdBegin>0&&reservedIdBegin<=reservedIdEnd){
					for(reservedId=reservedIdBegin;reservedId<=reservedIdEnd;reservedId++){
						if(hisReservedIdList.indexOf(""+reservedId)==-1){
							hisReservedIdList.add(""+reservedId);
							reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,recordId,-1,reservedId);
							reservedCode=Util.toHtml100(reservedCode);
							RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+reservedId+",'"+reservedCode+"','"+reservedDesc+"','0','0')");
						}						
					}
				}
				
				
			}else{
				reservedId=Util.getIntValue(reservedIdStrPart,-1);
				if(reservedId>0&&hisReservedIdList.indexOf(""+reservedId)==-1){
					hisReservedIdList.add(""+reservedId);
					reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,recordId,-1,reservedId);
					reservedCode=Util.toHtml100(reservedCode);
					RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+reservedId+",'"+reservedCode+"','"+reservedDesc+"','0','0')");
				}
			}
		}
    }

%>

<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(22783,user.getLanguage()) ;
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showNewReservedCodeOperate.jsp" method="post">
<input type="hidden" value="" name="src">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" value="<%=workflowId%>" name="workflowId">
<input type="hidden" value="<%=formId%>" name="formId">
<input type="hidden" value="<%=isBill%>" name="isBill">
<input type="hidden" value="<%=yearId%>" name="yearId">
<input type="hidden" value="<%=monthId%>" name="monthId">
<input type="hidden" value="<%=dateId%>" name="dateId">
<input type="hidden" value="<%=fieldId%>" name="fieldId">
<input type="hidden" value="<%=fieldValue%>" name="fieldValue">
<input type="hidden" value="<%=supSubCompanyId%>" name="supSubCompanyId">
<input type="hidden" value="<%=subCompanyId%>" name="subCompanyId">
<input type="hidden" value="<%=departmentId%>" name="departmentId">
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
                                        <TH colspan=2><%=SystemEnv.getHtmlLabelName(22783,user.getLanguage())%></TH>
                                    </TR>                                
                                    <TR class="Spacing" style="height: 1px">
                                        <TD class="Line1" colSpan=2></TD>
                                    </TR>

                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(15196,user.getLanguage())%></TD>
                                        <TD class=Field>
										<%=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,recordId,-1,-1)%>
                                        </TD>
                                    </TR>
                                     <TR class="Spacing" style="height: 1px">
                                        <TD class="Line" colSpan=2></TD>
                                    </TR>
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></TD>
                                        <TD class=Field>
										<%=sequenceId%>
                                        </TD>
                                    </TR>
                                     <TR class="Spacing" style="height: 1px">
                                        <TD class="Line" colSpan=2></TD>
                                    </TR>
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(22779,user.getLanguage())%></TD>
                                        <TD class=Field>
 									        <input type="text" class=inputstyle name="reservedIdStr" value="" maxlength="60" size="30">
											<br>
											<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%>：5,6-10,23,34,37,45   
                                        </TD>
                                    </TR>
                                     <TR class="Spacing" style="height: 1px">
                                        <TD class="Line" colSpan=2></TD>
                                    </TR>
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
                                        <TD class=Field>
 									        <input type="text" class=inputstyle name="reservedDesc" value="" maxlength="100" size="40">
                                        </TD>
                                    </TR>
                                     <TR class="Spacing" style="height: 1px">
                                        <TD class="Line" colSpan=2></TD>
                                    </TR>

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


</form>

</body>
</html>

<script language=javascript>


function onSave(){
	document.all("src").value="save";
	document.SearchForm.submit();
}


function onClose(){
	window.parent.close();
}

//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('showFormSignatureOperate');
}
</script>



