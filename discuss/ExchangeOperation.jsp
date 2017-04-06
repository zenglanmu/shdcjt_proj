<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.WorkPlan.WorkPlanExchange" %>
<%@ page import="weaver.discuss.ExchangeHandler" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
String method = Util.null2String(request.getParameter("method1"));
String sortid =  Util.null2String(request.getParameter("sortid"));  //日程Id
String ExchangeInfo = Util.fromScreen(request.getParameter("ExchangeInfo"), user.getLanguage());  //相关交流

String docids = Util.null2String(request.getParameter("docids"));
String types = request.getParameter("types"); 
String para = "";
String CustomerID ="";
String creater =""+user.getUID();

if(user.getLogintype().equals("2"))
{
	creater="-"+user.getUID();
}

char flag=Util.getSeparator() ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;

if (method.equals("add")&& types.equals("CS"))
//销售机会交流的添加
{
    CustomerID = Util.null2String(request.getParameter("CustomerID"));
	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/CRM/sellchance/ViewSellChance.jsp?CustomerID="+CustomerID+"&id="+sortid);
}

if (method.equals("add")&& types.equals("CC"))
//客户交流的添加
{
	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+sortid);
}

if (method.equals("add")&& types.equals("CT"))
//客户联系交流的添加
{

	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/CRM/data/ViewContactLogDetail.jsp?CLogID="+sortid);
}

if (method.equals("add")&& types.equals("CH"))
//合同交流的添加
{
    CustomerID = request.getParameter("CustomerID");
	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	
	
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/CRM/data/ContractView.jsp?CustomerID="+CustomerID+"&id="+sortid);
}

if (method.equals("add")&& types.equals("PP"))
//项目交流的添加
{	

	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+sortid);
}

if (method.equals("add")&& types.equals("PT")) 
//任务交流的添加
{	
	String sign=request.getParameter("sign");
	String relatedprj = Util.null2String(request.getParameter("relatedprj"));
	String relatedcus = Util.null2String(request.getParameter("relatedcus"));
	String relatedwf = Util.null2String(request.getParameter("relatedwf"));
	String relateddoc = Util.null2String(request.getParameter("relateddoc"));
	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+relatedprj ;
	para += flag+relatedcus ;
	para += flag+relatedwf ;
	para += flag+relateddoc ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
	if(sign.equals("process")) 
	{    
		response.sendRedirect("/proj/process/ViewTask.jsp?taskrecordid="+sortid);
	}
	else
	{
		response.sendRedirect("/proj/plan/ViewTask.jsp?taskrecordid="+sortid);
	}
}

if (method.equals("add")&& types.equals("WP")) 
//工作计划交流的添加
{
	String createrType = user.getLogintype();
	ExchangeHandler exHandler = new ExchangeHandler();

	String crmIds = Util.null2String(request.getParameter("excrmIDs"));
	String projectIds = Util.null2String(request.getParameter("exPrjIDs"));
	String requestIds = Util.null2String(request.getParameter("exReqeustIDs"));

	String[] params = new String[] {sortid, "", ExchangeInfo, creater, createrType, 
								docids, crmIds, projectIds, requestIds};
	exHandler.add(params, ExchangeHandler.EX_WORKPLAN);  //添加相关交流内容

	//added by lupeng 2004-07-05 for myplan part.
	WorkPlanExchange exchange = new WorkPlanExchange();
	exchange.exchangeAdd(Integer.parseInt(sortid), creater, createrType);  //更改日程交流统计表
	//end
    
	response.sendRedirect("/workplan/data/WorkPlanDetail.jsp?workid="+sortid);
}

if (method.equals("add")&& types.equals("MP"))
//会议的相关交流
{
    
	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+""+user.getUID();
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/meeting/data/ProcessMeeting.jsp?meetingid="+sortid);
}
%>