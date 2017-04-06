<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSets" class="weaver.conn.RecordSet" scope="page" />
<%
 
char flag=Util.getSeparator();
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
String settype=Util.null2String(request.getParameter("types"));   //个人设置还是系统设置
String method = Util.null2String(request.getParameter("method"));
String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));  //共享对象
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));

String sharelevel = Util.null2String(request.getParameter("sharelevel")); //共享级别 0：查看 1：反馈


String srelatedshareid = Util.null2String(request.getParameter("relatedshareided")); //被共享对象
String ssharetype = Util.null2String(request.getParameter("sharetyped")); 
String srolelevel = Util.null2String(request.getParameter("roleleveled")); 
String sseclevel = Util.null2String(request.getParameter("secleveled"));

String taskstatus= Util.null2String(request.getParameter("taskstatus")); //共享任务类型

String userid = "" ;
String departmentid = "" ;
String subcompanyid="";
String roleid = "0" ;
String foralluser = "" ;

String suserid = "" ;
String sdepartmentid = "" ;
String ssubcompanyid="";
String sroleid = "0" ;
String sforalluser = "" ;

if (settype.equals("0")) {
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
}

if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) subcompanyid = relatedshareid ;
if(sharetype.equals("3")) departmentid = relatedshareid ;
if(sharetype.equals("4")) roleid = relatedshareid ;
if(sharetype.equals("5")) foralluser = "1" ;
if (settype.equals("0")){
	if(ssharetype.equals("1")) suserid = srelatedshareid ;
	if(ssharetype.equals("2")) ssubcompanyid = srelatedshareid ;
	if(ssharetype.equals("3")) sdepartmentid = srelatedshareid ;
	if(ssharetype.equals("4")) sroleid = srelatedshareid ;
	if(ssharetype.equals("5")) sforalluser = "1" ;
}else{
	ssharetype="1";
	suserid=""+user.getUID();
}
if(method.equals("delete")){
	RecordSet.execute("delete from worktaskshareset where id="+id);
    //response.sendRedirect("WorkPlanShareSet.jsp");
}else if(method.equals("add")){
	if (!taskstatus.equals("-1")){
		//reportid=String.valueOf(i);
		ProcPara=""+wtid+flag;
		ProcPara += taskstatus;
		ProcPara += flag+sharetype;
		ProcPara += flag+seclevel;
		ProcPara += flag+rolelevel;
		ProcPara += flag+sharelevel;
		ProcPara += flag+userid;
		ProcPara += flag+subcompanyid;
		ProcPara += flag+departmentid;
		ProcPara += flag+roleid;
		ProcPara += flag+foralluser;
		ProcPara += flag+ssharetype;
		ProcPara += flag+sseclevel;
		ProcPara += flag+srolelevel;
		ProcPara += flag+suserid;
		ProcPara += flag+ssubcompanyid;
		ProcPara += flag+sdepartmentid;
		ProcPara += flag+sroleid;
		ProcPara += flag+sforalluser;
		ProcPara += flag+settype;
		RecordSet.executeProc("WorkTaskShareSet_Insert",ProcPara);
    }else{
		for(int taskstatusNew=1; taskstatusNew<=2; taskstatusNew++){
			ProcPara=""+wtid+flag;
			ProcPara += taskstatusNew;
			ProcPara += flag+sharetype;
			ProcPara += flag+seclevel;
			ProcPara += flag+rolelevel;
			ProcPara += flag+sharelevel;
			ProcPara += flag+userid;
			ProcPara += flag+subcompanyid;
			ProcPara += flag+departmentid;
			ProcPara += flag+roleid;
			ProcPara += flag+foralluser;
			ProcPara += flag+ssharetype;
			ProcPara += flag+sseclevel;
			ProcPara += flag+srolelevel;
			ProcPara += flag+suserid;
			ProcPara += flag+ssubcompanyid;
			ProcPara += flag+sdepartmentid;
			ProcPara += flag+sroleid;
			ProcPara += flag+sforalluser;
			ProcPara += flag+settype;
			RecordSet.executeProc("WorkTaskShareSet_Insert",ProcPara);
		}
	}
}

if (settype.equals("0")){
	response.sendRedirect("WorkTaskShareSet.jsp?wtid="+wtid);
}
if(settype.equals("1")){
	response.sendRedirect("WorkTaskSharePersonal.jsp?wtid="+wtid);
}
%>
