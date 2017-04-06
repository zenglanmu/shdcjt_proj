<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSets" class="weaver.conn.RecordSet" scope="page" />
<%
 
char flag=Util.getSeparator();
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String settype=Util.null2String(request.getParameter("types"));   //个人设置还是系统设置
String method = Util.null2String(request.getParameter("method"));
String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));  //共享对象
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));

String sharelevel = Util.null2String(request.getParameter("sharelevel")); //共享级别 0：查看 1：编辑


String srelatedshareid = Util.null2String(request.getParameter("relatedshareided")); //被共享对象
String ssharetype = Util.null2String(request.getParameter("sharetyped")); 
String srolelevel = Util.null2String(request.getParameter("roleleveled")); 
String sseclevel = Util.null2String(request.getParameter("secleveled"));

String planType= Util.null2String(request.getParameter("planType")); //共享日程类型

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

%>
<%  if (settype.equals("0")) {
    if(!HrmUserVarify.checkUserRight("WorkPlanTypeSet:Set", user))
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }	
}
%>
<%
if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) subcompanyid = relatedshareid ;
if(sharetype.equals("3")) departmentid = relatedshareid ;
if(sharetype.equals("4")) roleid = relatedshareid ;
if(sharetype.equals("5")) foralluser = "1" ;
if (settype.equals("0"))
{
if(ssharetype.equals("1")) suserid = srelatedshareid ;
if(ssharetype.equals("2")) ssubcompanyid = srelatedshareid ;
if(ssharetype.equals("3")) sdepartmentid = srelatedshareid ;
if(ssharetype.equals("4")) sroleid = srelatedshareid ;
if(ssharetype.equals("5")) sforalluser = "1" ;
}
else
{
ssharetype="1";
suserid=""+user.getUID();
}
if(method.equals("delete"))
{

	RecordSet.execute("delete from WorkPlanShareSet where id="+id);
    //response.sendRedirect("WorkPlanShareSet.jsp");
}


else if(method.equals("add"))
{   if (!planType.equals("-1"))
    
    {
    //reportid=String.valueOf(i);
    ProcPara="";
    ProcPara = planType;
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
    RecordSet.executeProc("WorkPlanShareSet_Insert",ProcPara);
    }
    else
    {
     RecordSets.execute("SELECT * FROM WorkPlanType where (workPlanTypeID=0 or workPlanTypeID>6) and available=1 order by workPlanTypeID ");
	 while (RecordSets.next())
	{
	 String plantypeNew=RecordSets.getString("workPlanTypeID");
    ProcPara="";
    ProcPara = plantypeNew;
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
    RecordSet.executeProc("WorkPlanShareSet_Insert",ProcPara);
	 }
    }
    
}

if (settype.equals("0")) response.sendRedirect("WorkPlanShareSet.jsp");
if (settype.equals("1")) response.sendRedirect("WorkPlanSharePersonal.jsp");
%>
