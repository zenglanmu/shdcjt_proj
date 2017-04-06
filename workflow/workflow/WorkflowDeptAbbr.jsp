<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

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

    String departmentNameOfSearch = Util.null2String(request.getParameter("departmentNameOfSearch"));
    String subCompanyIds = Util.null2String(request.getParameter("subCompanyIds"));
	if(subCompanyIds.equals("")){
		int[] subCompanyIdArray=CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"WorkflowManage:All");

        for(int i=0;i<subCompanyIdArray.length;i++){
            subCompanyIds+=","+subCompanyIdArray[i];
        }
        if(subCompanyIds.length()>1){
            subCompanyIds=subCompanyIds.substring(1);
        }
	}
	if(subCompanyIds.equals("")){
		subCompanyIds="0";
	}
	String subCompanyNames="";
    ArrayList subCompanyIdList=Util.TokenizerString(subCompanyIds,",");
	for(int i=0;i<subCompanyIdList.size();i++){
		subCompanyNames+=" "+SubCompanyComInfo.getSubCompanyname((String)subCompanyIdList.get(i));
	}
	if(subCompanyNames.equals("")){
		subCompanyNames=subCompanyNames.substring(1);
	}
 %>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(22216,user.getLanguage())+"£º"+SystemEnv.getHtmlLabelName(124,user.getLanguage());

String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearchDeptAbbr(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveDeptAbbr(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

if(ajax.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onCancelDeptAbbr(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>


<form id="formDeptAbbr" name="formDeptAbbr" method=post action="WorkflowDeptAbbrOperation.jsp" >
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
     	<COL width="25%">
        <COL width="25%">
        <COL width="25%">
     	<COL width="25%">

        <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
            <td class=field><input type=text name=departmentNameOfSearch class=Inputstyle value="<%=departmentNameOfSearch%>"></td>
            <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
            <td class=field>
			    <button class=browser onClick="onShowMultiSubcompanyBrowserByDec('subCompanyIds','subCompanyIdsSpan',0)"></button>
				<span id=subCompanyIdsSpan><%=subCompanyNames%></span>
				<input name=subCompanyIds type=hidden  value="<%=subCompanyIds%>">
			</td>
        </tr>
        <TR>
		    <TD height="10" colspan="4"></TD>
        </TR>
     </table>

<table class=liststyle cellspacing=1   cols=2 >
    <COLGROUP>

  	<COL width="50%">
  	<COL width="50%">
	  <tr class=header>
	    <td><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%></td>
	  </tr>
	  <tr class="Line"><td colspan="2"> </td></tr>
<%
if(fieldId>0||fieldId<=-2){
int tempFieldValue=0;
String tempAbbr =null;

Map deptAbbrDefMap=new HashMap();
RecordSet.executeSql("select * from workflow_deptAbbrDef");
while(RecordSet.next()){
	tempFieldValue=Util.getIntValue(RecordSet.getString("departmentId"));
	tempAbbr=Util.null2String(RecordSet.getString("abbr"));
	deptAbbrDefMap.put(""+tempFieldValue,tempAbbr);
}

String trClass="DataLight";

String tempFieldValueName=null;
int tempRecordId=0;


StringBuffer abbrSb=new StringBuffer();
if(isWorkflowSeqAlone){
   abbrSb.append(" select HrmDepartment.id as fieldValue,HrmDepartment.departmentName as fieldValueName ,workflow_deptAbbr.id as recordId,workflow_deptAbbr.abbr ")
		 .append("   from HrmDepartment ")
		 .append("   left join (select * from workflow_deptAbbr ")
		 .append(" 	             where fieldId=").append(fieldId)
		 .append(" 				 and workflowId=").append(workflowId)
		 .append(" 			    )workflow_deptAbbr ")
		 .append("    on	HrmDepartment.id=workflow_deptAbbr.fieldValue  ")
		 .append(" where (HrmDepartment.canceled is null or HrmDepartment.canceled='0') ")
	     .append("   and HrmDepartment.subCompanyId1 in(").append(subCompanyIds).append(") ");
    if(!departmentNameOfSearch.equals("")){
		abbrSb
		 .append("   and HrmDepartment.departmentName like '%").append(departmentNameOfSearch).append("%' ");
	}
   abbrSb.append(" order by HrmDepartment.showOrder asc,HrmDepartment.id asc  ");
}else{
   abbrSb.append(" select HrmDepartment.id as fieldValue,HrmDepartment.departmentName as fieldValueName ,workflow_deptAbbr.id as recordId,workflow_deptAbbr.abbr ")
		 .append("   from HrmDepartment ")
		 .append("   left join (select * from workflow_deptAbbr ")
		 .append(" 	             where fieldId=").append(fieldId)
		 .append(" 				   and formId=").append(formId)
		 .append(" 				   and isBill='").append(isBill).append("' ")
		 .append(" 			    )workflow_deptAbbr ")
		 .append("    on	HrmDepartment.id=workflow_deptAbbr.fieldValue  ")
		 .append(" where (HrmDepartment.canceled is null or HrmDepartment.canceled='0') ")
	     .append("   and HrmDepartment.subCompanyId1 in(").append(subCompanyIds).append(") ");  
    if(!departmentNameOfSearch.equals("")){
		abbrSb
		 .append("   and HrmDepartment.departmentName like '%").append(departmentNameOfSearch).append("%' ");
	}
   abbrSb.append(" order by HrmDepartment.showOrder asc,HrmDepartment.id asc  ");
}

    RecordSet.executeSql(abbrSb.toString());
    while(RecordSet.next()){
	    tempFieldValue     =Util.getIntValue(RecordSet.getString("fieldValue"),0);
	    tempFieldValueName   =Util.null2String(RecordSet.getString("fieldValueName"));
	    tempRecordId  =Util.getIntValue(RecordSet.getString("recordId"),0);
	    tempAbbr=Util.null2String(RecordSet.getString("abbr"));
		if(tempAbbr.equals("")){
			tempAbbr=Util.null2String((String)deptAbbrDefMap.get(""+tempFieldValue));
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

function onSaveDeptAbbr(obj) {
	obj.disabled = true;
	document.formDeptAbbr.action="WorkflowDeptAbbrOperation.jsp" ;
	document.formDeptAbbr.submit();
}

function onSearchDeptAbbr(obj) {
	obj.disabled = true;
	document.formDeptAbbr.action="WorkflowDeptAbbr.jsp" ;
	document.formDeptAbbr.submit();
}
</script>
<%}%>