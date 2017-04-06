<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportShare" class="weaver.workflow.report.ReportShare" scope="page"/>
<%

char flag=Util.getSeparator();
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String reportid = Util.null2String(request.getParameter("reportid")); 
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));
String departmentids = Util.null2String(request.getParameter("departmentids"));

String userid = "0" ;
String departmentid = "0" ;
String subcompanyid="0";
String roleid = "0" ;
String foralluser = "0" ;
int crmid=0;

if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) subcompanyid = relatedshareid ;
if(sharetype.equals("3")) departmentid = relatedshareid ;
if(sharetype.equals("4")) roleid = relatedshareid ;
if(sharetype.equals("5")) foralluser = "1" ;



if(method.equals("delete"))
{

	RecordSet.executeProc("WorkflowReportShare_Delete",id);

	ReportShare.setReportShareByReport(reportid);

	
    response.sendRedirect("ReportShare.jsp?id="+reportid);
}


else if(method.equals("add"))
{
	ProcPara = reportid;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+subcompanyid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;
	ProcPara += flag+"0" ;              //  crmid
    ProcPara +=flag+departmentids;              //增加多部门

    RecordSet.executeProc("WorkflowReportShare_Insert",ProcPara);


	ReportShare.setReportShareByReport(reportid);

    response.sendRedirect("ReportShare.jsp?id="+reportid);
}
%>
