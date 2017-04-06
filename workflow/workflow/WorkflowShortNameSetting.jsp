<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<html>
<%


boolean canEdit=false;
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	canEdit=true;
}

    String ajax=Util.null2String(request.getParameter("ajax"));
	int workflowId=Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
	int formId=Util.getIntValue(Util.null2String(request.getParameter("formId")),0);
	String isBill=Util.null2String(request.getParameter("isBill"));
	int fieldId=Util.getIntValue(request.getParameter("fieldId"),0);

    CodeBuild codeBuild = new CodeBuild(formId,isBill,workflowId);
	boolean isWorkflowSeqAlone=codeBuild.isWorkflowSeqAlone(RecordSet,workflowId);

 %>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(22216,user.getLanguage());

String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveShortNameSetting(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

if(ajax.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onCancelShortNameSetting(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>


<form id="formShortNameSetting" name="formShortNameSetting" method=post action="WorkflowShortNameSettingOperation.jsp" >
<input name=ajax type=hidden value="<%=ajax%>">
<input name=workflowId type=hidden value="<%=workflowId%>">
<input name=formId type=hidden value="<%=formId%>">
<input name=isBill type=hidden value="<%=isBill%>">
<input name=fieldId type=hidden value="<%=fieldId%>">

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

<%
int rowNum=0;
%>



<table class=liststyle cellspacing=1   cols=2 >
    <COLGROUP>

  	<COL width="50%">
  	<COL width="50%">
	  <tr class=header>
	    <td><%=SystemEnv.getHtmlLabelName(22217,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%></td>
	  </tr>
	  <tr class="Line"><td colspan="2"> </td></tr>
<%

String trClass="DataLight";

int tempFieldValue=0;
String tempFieldValueName=null;
int tempRecordId=0;
String tempShortNameSetting =null;

String shortNameSettingSql=null;
StringBuffer shortNameSettingSb=new StringBuffer();
if(isWorkflowSeqAlone){
   shortNameSettingSb.append(" select workflow_selectitem.selectValue as fieldValue,selectName as fieldValueName ,workflow_shortNameSetting.id as recordId,workflow_shortNameSetting.shortNameSetting ")
			         .append(" from workflow_selectitem ")
			         .append("      left join (select * from workflow_shortNameSetting ")
			         .append(" 	             where fieldId=").append(fieldId)
			         .append(" 				 and workflowId=").append(workflowId)
			         .append(" 			    )workflow_shortNameSetting ")
			         .append("   on	workflow_selectitem.selectValue=workflow_shortNameSetting.fieldValue  ")
			         .append(" 	    where workflow_selectitem.fieldId=").append(fieldId)
			         .append(" 	      and workflow_selectitem.isBill='").append(isBill).append("'")
			         .append(" order by listOrder,workflow_selectitem.id  ");
}else{
   shortNameSettingSb.append(" select workflow_selectitem.selectValue as fieldValue,selectName as fieldValueName ,workflow_shortNameSetting.id as recordId,workflow_shortNameSetting.shortNameSetting ")
			         .append(" from workflow_selectitem ")
			         .append("      left join (select * from workflow_shortNameSetting ")
			         .append(" 	             where fieldId=").append(fieldId)
			         .append(" 				   and formId=").append(formId)
			         .append(" 				   and isBill='").append(isBill).append("' ")
			         .append(" 			    )workflow_shortNameSetting ")
			         .append("   on	workflow_selectitem.selectValue=workflow_shortNameSetting.fieldValue  ")
			         .append(" 	    where workflow_selectitem.fieldId=").append(fieldId)
			         .append(" 	      and workflow_selectitem.isBill='").append(isBill).append("'")
			         .append(" order by listOrder,workflow_selectitem.id  ");
}
shortNameSettingSql=shortNameSettingSb.toString();
  RecordSet.executeSql(shortNameSettingSql);
  while(RecordSet.next()){
	tempFieldValue     =Util.getIntValue(RecordSet.getString("fieldValue"),0);
	tempFieldValueName   =Util.null2String(RecordSet.getString("fieldValueName"));
	tempRecordId  =Util.getIntValue(RecordSet.getString("recordId"),0);
	tempShortNameSetting=Util.null2String(RecordSet.getString("shortNameSetting"));

%>
<TR class="<%=trClass%>">

    <td  height="23" align="left"><%=tempFieldValueName%>
      <input type="hidden" name="shortNameSetting<%=rowNum%>_fieldValue" value="<%=tempFieldValue%>">
    </td>
      <input type="hidden" name="shortNameSetting<%=rowNum%>_recordId" value="<%=tempRecordId%>">
    <td  height="23" align="left">
<%if(canEdit){%>
		<input class=Inputstyle type="text" name="shortNameSetting<%=rowNum%>_shortNameSetting" value="<%=tempShortNameSetting%>" maxlength=20 >
<%}else{%>
		<%=tempShortNameSetting%>
<%}%>
	</td>
</tr>

<%
    rowNum+=1;
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

<input type="hidden" value="<%=rowNum%>" name="rowNumShortNameSetting">

</form>



</body>
</html>
<%if(!ajax.equals("1")){%>

<Script language=javascript>

function onSaveShortNameSetting(obj) {
	obj.disabled = true;
	document.formShortNameSetting.action="WorkflowShortNameSettingOperation.jsp" ;
	document.formShortNameSetting.submit();
}

</script>
<%}%>