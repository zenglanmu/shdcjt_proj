<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.file.Prop" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="AccountType" class="weaver.general.AccountType" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
String mode = Prop.getPropValue(weaver.general.GCONST.getConfigFile(), "authentic");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();
String strSql = Util.null2String(request.getParameter("sql"));
//RecordSet.writeLog("================================================"+strSql);
RecordSet.executeSql(strSql);
ExcelFile.init();
ExcelSheet es = new ExcelSheet();
ExcelStyle excelStyle = ExcelFile.newExcelStyle("Border");
excelStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelStyle excelStyle1 = ExcelFile.newExcelStyle("Header");
excelStyle1.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
excelStyle1.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
excelStyle1.setFontbold(ExcelStyle.WeaverHeaderFontbold);
excelStyle1.setAlign(ExcelStyle.WeaverHeaderAlign);
excelStyle1.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelRow er = es.newExcelRow();
if(flagaccount){
	er.addStringValue(SystemEnv.getHtmlLabelName(17745,user.getLanguage()), "Header");
}
er.addStringValue(SystemEnv.getHtmlLabelName(714,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(141,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(2120,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(6086,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(421,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(620,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(477,user.getLanguage()), "Header");
if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
	er.addStringValue(SystemEnv.getHtmlLabelName(412,user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(683,user.getLanguage()), "Header");
}
while(RecordSet.next()){
	er = es.newExcelRow();
	if(flagaccount){
		er.addStringValue(AccountType.getAccountType(Util.null2String(RecordSet.getString("accounttype"))), "Border");
	}
	er.addStringValue(Util.null2String(RecordSet.getString("workcode")), "Border");
	er.addStringValue(Util.null2String(RecordSet.getString("lastname")), "Border");
	er.addStringValue(SubCompanyComInfo.getSubCompanyname(Util.null2String(RecordSet.getString("subcompanyid1"))), "Border");
	er.addStringValue(DepartmentComInfo.getDepartmentname(Util.null2String(RecordSet.getString("departmentid"))), "Border");
	er.addStringValue(ResourceComInfo.getResourcename(Util.null2String(RecordSet.getString("managerid"))), "Border");
	er.addStringValue(JobTitlesComInfo.getJobTitlesname(Util.null2String(RecordSet.getString("jobtitle"))), "Border");
	er.addStringValue(Util.null2String(RecordSet.getString("telephone")), "Border");
	er.addStringValue(Util.null2String(RecordSet.getString("mobile")), "Border");
	er.addStringValue(Util.null2String(RecordSet.getString("email")), "Border");
	if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){

         

if(mode != null && mode.equals("ldap")){
		er.addStringValue(Util.null2String(RecordSet.getString("account")), "Border");
		er.addStringValue(Util.null2String(RecordSet.getString("seclevel")), "Border");
	}else{
		er.addStringValue(Util.null2String(RecordSet.getString("loginid")), "Border");
		er.addStringValue(Util.null2String(RecordSet.getString("seclevel")), "Border");
	}

		
	}
}
ExcelFile.setFilename(SystemEnv.getHtmlLabelName(15929,user.getLanguage()));
ExcelFile.addSheet(SystemEnv.getHtmlLabelName(15929,user.getLanguage()), es);
%>
<iframe name="ExcelOut" id="ExcelOut" src="/weaver/weaver.file.ExcelOut" style="display:none" ></iframe>