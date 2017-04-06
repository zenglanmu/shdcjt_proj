<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addcurrencies")){
  	String currencyname = Util.fromScreen(request.getParameter("currencyname"),user.getLanguage()).toUpperCase();
	String currencydesc = Util.fromScreen(request.getParameter("currencydesc"),user.getLanguage());
	String activable = Util.null2String(request.getParameter("activable"));
	String isdefault = Util.null2String(request.getParameter("isdefault"));
	if(activable.equals("")) activable ="0" ;
	if(isdefault.equals("")) isdefault ="0" ;

	String para = currencyname + separator + currencydesc + separator + activable + separator + isdefault ;

	RecordSet.executeProc("FnaCurrency_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1) {
		response.sendRedirect("FnaCurrenciesAdd.jsp?msgid=12");
		return ;
	}
	
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(currencyname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("FnaCurrency_Insert,"+para);
	SysMaintenanceLog.setOperateItem("39");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	CurrencyComInfo.removeCurrencyCache();
	response.sendRedirect("FnaCurrencies.jsp");
 }
else if(operation.equals("editcurrencies")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String currencyname = Util.fromScreen(request.getParameter("currencyname"),user.getLanguage());
	String currencydesc = Util.fromScreen(request.getParameter("currencydesc"),user.getLanguage());
	String activable = Util.null2String(request.getParameter("activable"));
	String isdefault = Util.null2String(request.getParameter("isdefault"));
	String isdefaultold = Util.null2String(request.getParameter("isdefaultold"));
	
	if(activable.equals("")) activable ="0" ;
	if(isdefaultold.equals("1")) isdefault ="1" ;
	String para = ""+id + separator + currencyname + separator + currencydesc +  separator + activable +  separator + isdefault;
	RecordSet.executeProc("FnaCurrency_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(currencyname);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaCurrency_Update,"+para);
    SysMaintenanceLog.setOperateItem("39");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
	CurrencyComInfo.removeCurrencyCache();
 	response.sendRedirect("FnaCurrencies.jsp");
 }
 
 else if(operation.equals("addcurrencyexchange")){
	String defcurrencyid = Util.null2String(request.getParameter("defcurrencyid"));
	String thecurrencyid = Util.null2String(request.getParameter("thecurrencyid"));
	String fnayear = Util.null2String(request.getParameter("fnayear"));
	String periodsid = Util.null2String(request.getParameter("periodsid"));
	String fnayearperiodsid = fnayear + Util.add0(Util.getIntValue(periodsid),2);
	String avgexchangerate = Util.null2String(request.getParameter("avgexchangerate"));
	String endexchangerage = Util.null2String(request.getParameter("endexchangerage"));

	String para = defcurrencyid + separator + thecurrencyid +  separator + fnayear 
				   + separator + periodsid +  separator + fnayearperiodsid  
				   + separator + avgexchangerate +  separator + endexchangerage ;

	RecordSet.executeProc("FnaCurrencyExchange_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1) {
		response.sendRedirect("FnaCurrencyExchangeAdd.jsp?id="+thecurrencyid+"&msgid=12");
		return ;
	}
	if(id == -2) {
		response.sendRedirect("FnaCurrencyExchangeAdd.jsp?id="+thecurrencyid+"&msgid=21");
		return ;
	}

	String currencyname = Util.null2String(CurrencyComInfo.getCurrencyname(thecurrencyid));

    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(thecurrencyid));
    SysMaintenanceLog.setRelatedName(currencyname);
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("FnaCurrencyExchange_Insert,"+para);
    SysMaintenanceLog.setOperateItem("40");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
 	response.sendRedirect("FnaCurrenciesView.jsp?id="+thecurrencyid);
 }

 else if(operation.equals("editcurrencyexchange")){
	int id = Util.getIntValue(request.getParameter("id"));
	String thecurrencyid = Util.null2String(request.getParameter("thecurrencyid"));
	String fnayear = Util.null2String(request.getParameter("fnayear"));
	String periodsid = Util.null2String(request.getParameter("periodsid"));
	String avgexchangerate = Util.null2String(request.getParameter("avgexchangerate"));
	String endexchangerage = Util.null2String(request.getParameter("endexchangerage"));

	String para = ""+id + separator + avgexchangerate +  separator + endexchangerage 
				   + separator + fnayear +  separator + periodsid ;  

	RecordSet.executeProc("FnaCurrencyExchange_Update",para);
	if(RecordSet.next()) {
		response.sendRedirect("FnaCurrencyExchangeEdit.jsp?id="+id+"&msgid=21");
		return ;
	}

	String currencyname = Util.null2String(CurrencyComInfo.getCurrencyname(thecurrencyid));

    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(thecurrencyid));
    SysMaintenanceLog.setRelatedName(currencyname);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("FnaCurrencyExchange_Update,"+para);
    SysMaintenanceLog.setOperateItem("40");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
 	response.sendRedirect("FnaCurrenciesView.jsp?id="+thecurrencyid);
 }
 
 else if(operation.equals("deletecurrencyexchange")){
	int id = Util.getIntValue(request.getParameter("id"));
	String thecurrencyid = Util.null2String(request.getParameter("thecurrencyid"));
	String fnayear = Util.null2String(request.getParameter("fnayear"));
	String periodsid = Util.null2String(request.getParameter("periodsid"));

	String para = ""+ id + separator + fnayear +  separator + periodsid ;  

	RecordSet.executeProc("FnaCurrencyExchange_Delete",para);
	if(RecordSet.next()) {
		response.sendRedirect("FnaCurrencyExchangeEdit.jsp?id="+id+"&msgid=21");
		return ;
	}

	String currencyname = Util.null2String(CurrencyComInfo.getCurrencyname(thecurrencyid));

    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(thecurrencyid));
    SysMaintenanceLog.setRelatedName(currencyname);
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("FnaCurrencyExchange_Delete,"+para);
    SysMaintenanceLog.setOperateItem("40");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
 	response.sendRedirect("FnaCurrenciesView.jsp?id="+thecurrencyid);
 }

%>