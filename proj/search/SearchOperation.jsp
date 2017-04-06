<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<%
SearchComInfo1.resetSearchInfo();
int perpage = Util.getIntValue(request.getParameter("perpage"),10);
String msg=Util.null2String(request.getParameter("msg"));
if(msg.equals("report")){
	String settype=Util.null2String(request.getParameter("settype"));	
	String id=Util.null2String(request.getParameter("id"));
	if(settype.equals("projecttype")){
		SearchComInfo1.setprjtype(id);
		response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
		return;
	}
	if(settype.equals("worktype")){
		SearchComInfo1.setworktype(id);
		response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
		return;
	}
	if(settype.equals("projectstatus")){
		SearchComInfo1.setstatus(id);
		response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
		return;
	}
	if(settype.equals("manager")){
		SearchComInfo1.setmanager(id);
		response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
		return;
	}
	if(settype.equals("department")){
		SearchComInfo1.setdepartment(id);
		response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
		return;
	}
	response.sendRedirect("/notice/noright.jsp");//返回到一个出错页面，待定义
	return;
}

String destination = Util.null2String(request.getParameter("destination"));

if(destination.equals("prjindept"))
{
	SearchComInfo1.setdepartment(Util.null2String(request.getParameter("depid")));
	response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
	return ;
}

if(destination.equals("myProject"))
{
	SearchComInfo1.setmanager("" + user.getUID());
	response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
	return ;
}

SearchComInfo1.setname(Util.null2String(request.getParameter("name")));

if(destination.equals("QuickSearch"))
{
	response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
	return ;
}

String prjtypes[]=request.getParameterValues("prjtype");
String worktypes[]=request.getParameterValues("worktype");
String statuss[]=request.getParameterValues("status");

String prjtype="";
if(prjtypes != null)
{
	for(int i=0;i<prjtypes.length;i++)
	{
		prjtype +=","+prjtypes[i];
	}
	prjtype = prjtype.substring(1);
}

String worktype="";
if(worktypes != null)
{
	for(int i=0;i<worktypes.length;i++)
	{
		worktype +=","+worktypes[i];
	}
	worktype = worktype.substring(1);
}

String status="";
if(statuss != null)
{
	for(int i=0;i<statuss.length;i++)
	{
		status +=","+statuss[i];
	}
	status = status.substring(1);
}


SearchComInfo1.setprjtype(prjtype);
SearchComInfo1.setworktype(worktype);
SearchComInfo1.setstatus(status);
SearchComInfo1.setnameopt(Util.null2String(request.getParameter("nameopt")));
SearchComInfo1.setdescription(Util.null2String(request.getParameter("description")));
SearchComInfo1.setcustomer(Util.null2String(request.getParameter("customer")));
SearchComInfo1.setparent(Util.null2String(request.getParameter("parent")));
SearchComInfo1.setsecurelevel(Util.null2String(request.getParameter("securelevel")));
SearchComInfo1.setdepartment(Util.null2String(request.getParameter("department")));
SearchComInfo1.setmanager(Util.null2String(request.getParameter("manager")));
SearchComInfo1.setmember(Util.null2String(request.getParameter("member")));
SearchComInfo1.setProcode(Util.null2String(request.getParameter("procode")));

SearchComInfo1.setStartDate(Util.null2String(request.getParameter("startdate")));
SearchComInfo1.setStartDateTo(Util.null2String(request.getParameter("startdateTo")));
SearchComInfo1.setEndDate(Util.null2String(request.getParameter("enddate")));
SearchComInfo1.setEndDateTo(Util.null2String(request.getParameter("enddateTo")));


response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
%>
