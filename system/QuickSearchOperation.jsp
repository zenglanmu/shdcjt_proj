<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<%
session.removeAttribute("RequestViewResource");   //查看下属代办后，防止下次搜索还是下属的流程  requestview.jsp   set 进去的
int searchtype=Util.getIntValue(request.getParameter("searchtype"),0);
String searchvalue=Util.fromScreen2(request.getParameter("searchvalue"),user.getLanguage());
String searchvalue2=Util.null2String(request.getParameter("searchvalue"));
String whereclause="";
String orderclause="";
BaseBean baseBean = new BaseBean();
String date2durings = "";
int olddate2during = 0;
if(searchtype==1){//docs
%>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<%
	DocSearchComInfo.resetSearchInfo();
	DocSearchComInfo.setDocsubject(searchvalue2);
	DocSearchComInfo.addDocstatus("1");
	DocSearchComInfo.addDocstatus("2");
	DocSearchComInfo.addDocstatus("5");
	DocSearchComInfo.addDocstatus("7");
	
	try
	{
		date2durings = Util.null2String(baseBean.getPropValue("docdateduring", "date2during"));
	}
	catch(Exception e)
	{}
	String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
	if(date2duringTokens.length>0)
	{
		olddate2during = Util.getIntValue(date2duringTokens[0],0);
	}
	if(olddate2during<0||olddate2during>36)
	{
		olddate2during = 0;
	}
	String redirecturl = "/docs/search/DocSearch.jsp?date2during="+olddate2during+"&isinit=false";
	response.sendRedirect(redirecturl);		
}
if(searchtype==2){//hrm
%>
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<%
	HrmSearchComInfo.resetSearchInfo();
	HrmSearchComInfo.setResourcename(searchvalue);
	HrmSearchComInfo.setOrderby("id");


	int userid=user.getUID();
	RecordSet.executeSql("select dspperpage from HrmUserDefine where userid="+userid);
	RecordSet.next();
	String perpage=RecordSet.getString("dspperpage");
	if(perpage.equals(""))	perpage="10";
	response.sendRedirect("/hrm/search/HrmResourceSearchResult.jsp");
}
if(searchtype==3){//crm
%>
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<%	
	CRMSearchComInfo.resetSearchInfo();
	searchvalue=Util.null2String(request.getParameter("searchvalue"));
	CRMSearchComInfo.setCustomerName(searchvalue);
	response.sendRedirect("/CRM/search/SearchResult.jsp?start=1&perpage=10");
}

if(searchtype==4){//cpt
%>
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<%	String isdata = "2";
	CptSearchComInfo.resetSearchInfo();
	CptSearchComInfo.setName(searchvalue);
	CptSearchComInfo.setIsData(isdata);
	response.sendRedirect("/cpt/search/CptSearchResult.jsp?start=1");  
	//response.sendRedirect("/lgc/search/LgcSearchOperation.jsp?operation=search&assetname="+searchvalue);
}
if(searchtype==5){//request
%>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<%  session.removeAttribute("branchid");
	SearchClause.resetClause();
	SearchClause.setRequestName(searchvalue);
	//response.sendRedirect("/workflow/search/WFSearchTemp.jsp?reqeustname="+searchvalue);
	whereclause+=" requestname like '%"+searchvalue+"%' and t2.islasttimes=1 and t2.workflowid in (select id from workflow_base where isvalid='1') ";
	orderclause="t2.receivedate ,t2.receivetime";
	SearchClause.setOrderClause(orderclause);
	SearchClause.setWhereClause(whereclause);
	boolean isUseOldWfMode=sysInfo.isUseOldWfMode();
	try
	{
		date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
	}
	catch(Exception e)
	{}
	String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
	if(date2duringTokens.length>0)
	{
		olddate2during = Util.getIntValue(date2duringTokens[0],0);
	}
	if(olddate2during<0||olddate2during>36)
	{
		olddate2during = 0;
	}
	String redirecturl = "/workflow/search/WFSearch.jsp?date2during="+olddate2during+"&isinit=false";
	if(false){
		response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10");
	}else{
		response.sendRedirect(redirecturl);
	}
}
if(searchtype==6){//project
%>
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<%
	SearchComInfo1.resetSearchInfo();
	SearchComInfo1.setnameopt("1");
	SearchComInfo1.setname(searchvalue2);
	response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage=10");
}
if(searchtype==7){//email
%>
<jsp:useBean id="mailSearchComInfo" class="weaver.email.search.MailSearchComInfo" scope="session" />
<%
	mailSearchComInfo.resetSearchInfo();
	mailSearchComInfo.setSubject(searchvalue2);
	response.sendRedirect("/email/MailFrame.jsp?act=search");
}
if(searchtype==8){
	response.sendRedirect("/cowork/coworkview.jsp?flag=search&quickSearch=true&name="+URLEncoder.encode(searchvalue));
}
if(searchtype==99){
	response.sendRedirect("/messager/MsgSearch.jsp?msg="+URLEncoder.encode(searchvalue));
}
%>