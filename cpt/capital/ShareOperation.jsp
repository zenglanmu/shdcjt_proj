<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<%
char flag = 2;
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String capitalid = Util.null2String(request.getParameter("capitalid")); 
String capitalname = Util.fromScreen(request.getParameter("capitalname"),user.getLanguage());
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String userid = "0" ;
String departmentid = "0" ;
String roleid = "0" ;
String foralluser = "0" ;

if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) departmentid = relatedshareid ;
if(sharetype.equals("3")) roleid = relatedshareid ;
if(sharetype.equals("4")) foralluser = "1" ;

String name = "";
if(method.equals("delete"))
{

	RecordSet.executeProc("CptCapitalShareInfo_Delete",id);

	name = SystemEnv.getHtmlLabelName(535,user.getLanguage())+SystemEnv.getHtmlLabelName(119,user.getLanguage())+":"+capitalname;

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    SysMaintenanceLog.setOperateItem("51");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setRelatedName(name);
	SysMaintenanceLog.setOperateType("3");
	SysMaintenanceLog.setOperateDesc("CptCapitalShareInfo_Delete,"+id);
	SysMaintenanceLog.setSysLogInfo();
CptShare.setCptShareByCpt(capitalid);
	response.sendRedirect("/cpt/capital/CptCapital.jsp?id="+capitalid);
	return;
}


if(method.equals("add"))
{
	ProcPara = capitalid;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;
	
	RecordSet.executeProc("CptCapitalShareInfo_Insert",ProcPara);
	RecordSet.next();
	String tempid = RecordSet.getString("id");

	name = SystemEnv.getHtmlLabelName(535,user.getLanguage())+SystemEnv.getHtmlLabelName(119,user.getLanguage())+":"+capitalname;
	
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(tempid));
    SysMaintenanceLog.setOperateItem("51");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setRelatedName(name);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("CptCapitalShareInfo_Insert,"+tempid);
	SysMaintenanceLog.setSysLogInfo();
/*
String usertype="1";
String Para=capitalid;
Para+=flag+usertype;
Para+=flag+sharelevel;
if(!userid.equals("0")){
Para+=flag+userid;
RecordSet.executeProc("CptShareDetail_Insert",Para);
}else if(!departmentid.equals("0")){
rs.executeSql("SELECT id FROM HrmResource WHERE departmentid ="+departmentid);
while(rs.next()){
userid=rs.getString("id");
String Para1=new String();
Para1=Para+flag+userid;
RecordSet.executeProc("CptShareDetail_Insert",Para1);
}
}else if(!roleid.equals("0")){
rs.executeSql("SELECT resourceid FROM HrmRoleMembers WHERE roleid ="+roleid);
while(rs.next()){
userid=rs.getString("resourceid");
String Para1=new String();
Para1=Para+flag+userid;
RecordSet.executeProc("CptShareDetail_Insert",Para1);
}
}

*/

CptShare.setCptShareByCpt(capitalid);

	response.sendRedirect("/cpt/capital/CptCapital.jsp?id="+capitalid);
	return;
}

if(method.equals("edit"))
{
	ProcPara = id;
	ProcPara += capitalid;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;

	RecordSet.executeProc("CptCapitalShareInfo_Update",ProcPara);
CptShare.setCptShareByCpt(capitalid);
	response.sendRedirect("/cpt/capital/CptCapital.jsp?id="+capitalid);
	return;
}
%>
