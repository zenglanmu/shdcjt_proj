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
	int fieldId=Util.getIntValue(request.getParameter("fieldId"),-1);

    CodeBuild codeBuild = new CodeBuild(formId,isBill,workflowId);
	boolean isWorkflowSeqAlone=codeBuild.isWorkflowSeqAlone(RecordSet,workflowId);

    String subCompanyNameOfSearch = Util.null2String(request.getParameter("subCompanyNameOfSearch"));
 %>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(22216,user.getLanguage())+"£º"+SystemEnv.getHtmlLabelName(141,user.getLanguage());

String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearchSubComAbbr(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveSubComAbbr(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

if(ajax.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onCancelSubComAbbr(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>


<form id="formSubComAbbr" name="formSubComAbbr" method=post action="WorkflowSubComAbbrOperation.jsp" >
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

     <table class=viewform cellspacing=1  >
     	<COLGROUP>
     	<COL width="20%">
        <COL width="20%">
     	<COL width="10%">
        <COL width="20%">
     	<COL width="20%">
        <COL width="10%">

        <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1878,user.getLanguage())%></td>
            <td class=field><input type=text name=subCompanyNameOfSearch class=Inputstyle value="<%=subCompanyNameOfSearch%>"></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <TR>
		    <TD height="10" colspan="6"></TD>
        </TR>
     </table>

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
if(fieldId>0||fieldId<=-2){
int tempFieldValue=0;
String tempAbbr =null;

Map subComAbbrDefMap=new HashMap();
RecordSet.executeSql("select * from workflow_subComAbbrDef");
while(RecordSet.next()){
	tempFieldValue=Util.getIntValue(RecordSet.getString("subCompanyId"));
	tempAbbr=Util.null2String(RecordSet.getString("abbr"));
	subComAbbrDefMap.put(""+tempFieldValue,tempAbbr);
}

String trClass="DataLight";

String tempFieldValueName=null;
int tempRecordId=0;


StringBuffer abbrSb=new StringBuffer();
if(isWorkflowSeqAlone){
   abbrSb.append(" select HrmSubCompany.id as fieldValue,HrmSubCompany.subCompanyName as fieldValueName ,workflow_subComAbbr.id as recordId,workflow_subComAbbr.abbr ")
		 .append("   from HrmSubCompany ")
		 .append("      left join (select * from workflow_subComAbbr ")
		 .append(" 	             where fieldId=").append(fieldId)
		 .append(" 				 and workflowId=").append(workflowId)
		 .append(" 			    )workflow_subComAbbr ")
		 .append("     on HrmSubCompany.id=workflow_subComAbbr.fieldValue  ")
		 .append("  where (HrmSubCompany.canceled is null or HrmSubCompany.canceled='0') ");
    if(!subCompanyNameOfSearch.equals("")){
		abbrSb
		 .append("    and HrmSubCompany.subCompanyName like '%").append(subCompanyNameOfSearch).append("%' ");
	}
   abbrSb.append(" order by HrmSubCompany.showOrder asc,HrmSubCompany.id asc ");
}else{
   abbrSb.append(" select HrmSubCompany.id as fieldValue,HrmSubCompany.subCompanyName as fieldValueName ,workflow_subComAbbr.id as recordId,workflow_subComAbbr.abbr ")
		 .append(" from HrmSubCompany ")
		 .append("      left join (select * from workflow_subComAbbr ")
		 .append(" 	             where fieldId=").append(fieldId)
		 .append(" 				   and formId=").append(formId)
		 .append(" 				   and isBill='").append(isBill).append("' ")
		 .append(" 			    )workflow_subComAbbr ")
		 .append("   on	HrmSubCompany.id=workflow_subComAbbr.fieldValue  ")
		 .append("  where (HrmSubCompany.canceled is null or HrmSubCompany.canceled='0') ");
    if(!subCompanyNameOfSearch.equals("")){
		abbrSb
		 .append("    and HrmSubCompany.subCompanyName like '%").append(subCompanyNameOfSearch).append("%' ");
	}
   abbrSb.append(" order by HrmSubCompany.showOrder asc,HrmSubCompany.id asc ");
}

    RecordSet.executeSql(abbrSb.toString());
    while(RecordSet.next()){
	    tempFieldValue     =Util.getIntValue(RecordSet.getString("fieldValue"),0);
	    tempFieldValueName   =Util.null2String(RecordSet.getString("fieldValueName"));
	    tempRecordId  =Util.getIntValue(RecordSet.getString("recordId"),0);
	    tempAbbr=Util.null2String(RecordSet.getString("abbr"));
		if(tempAbbr.equals("")){
			tempAbbr=Util.null2String((String)subComAbbrDefMap.get(""+tempFieldValue));
		}

%>
<TR class="<%=trClass%>">

    <td  height="23" align="left"><%=tempFieldValueName%>
      <input type="hidden" name="abbr<%=rowNum%>_fieldValue" value="<%=tempFieldValue%>">
    </td>
      <input type="hidden" name="abbr<%=rowNum%>_recordId" value="<%=tempRecordId%>">
    <td  height="23" align="left">
<%if(canEdit){%>
		<input class=Inputstyle type="text" name="abbr<%=rowNum%>_abbr" value="<%=tempAbbr%>" maxlength=20 >
<%}else{%>
		<%=tempAbbr%>
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

<input type="hidden" value="<%=rowNum%>" name="rowNum">

</form>



</body>
</html>
<%if(!ajax.equals("1")){%>

<Script language=javascript>

function onSaveSubComAbbr(obj) {
	obj.disabled = true;
	document.formSubComAbbr.action="WorkflowSubComAbbrOperation.jsp" ;
	document.formSubComAbbr.submit();
}

function onSearchSubComAbbr(obj) {
	obj.disabled = true;
	document.formSubComAbbr.action="WorkflowSubComAbbr.jsp" ;
	document.formSubComAbbr.submit();
}
</script>
<%}%>