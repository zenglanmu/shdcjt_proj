<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="BudgetModuleComInfo" class="weaver.fna.maintenance.BudgetModuleComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addtransaction")){
	
	String trandepartmentid = Util.null2String(request.getParameter("trandepartmentid"));

	if(!HrmUserVarify.checkUserRight("FnaTransactionAdd:Add",user,trandepartmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String tranmark = Util.fromScreen(request.getParameter("tranmark"),user.getLanguage());
	String trandate = Util.null2String(request.getParameter("trandate"));
	String trancostercenterid = Util.null2String(request.getParameter("trancostercenterid"));
	String trancurrencyid = Util.null2String(request.getParameter("trancurrencyid"));
	String trandefcurrencyid = Util.null2String(request.getParameter("trandefcurrencyid"));
	String tranexchangerate = Util.null2String(request.getParameter("tranexchangerate"));
	String tranaccessories = Util.null2String(request.getParameter("tranaccessories"));
	String tranresourceid = Util.null2String(request.getParameter("tranresourceid"));
	String trancrmid = Util.null2String(request.getParameter("trancrmid"));
	String tranitemid = Util.null2String(request.getParameter("tranitemid"));
	String trandocid = Util.null2String(request.getParameter("trandocid"));
	String tranprojectid = Util.null2String(request.getParameter("tranprojectid"));
	String tranremarks = Util.fromScreen(request.getParameter("tranremark"),user.getLanguage());
	String transtatus = "0" ;
	String createrid = ""+ user.getUID();
	String createdate = Util.null2String(request.getParameter("createdate"));
	int totaldetail = Util.getIntValue(request.getParameter("totaldetail"));


	String ledgerid[] = new String[totaldetail] ;
	String tranaccount[] = new String[totaldetail] ;
	String trandefaccount[] = new String[totaldetail] ;
	String tranbalance[] = new String[totaldetail] ;
	String tranremark[] = new String[totaldetail] ;
	BigDecimal  trandaccounts = new BigDecimal("0") ;
	BigDecimal  trancaccounts = new BigDecimal("0") ;
	BigDecimal  trandefdaccounts = new BigDecimal("0") ;
	BigDecimal  trandefcaccounts = new BigDecimal("0") ;
	BigDecimal  tranexchangerates = new BigDecimal(tranexchangerate) ;
	if(tranexchangerates.compareTo(trandaccounts) == 0) {
		tranexchangerates = new BigDecimal("1") ;
		tranexchangerate = "1.000" ;
	}

	for(int i=0 ; i< totaldetail ; i++)  {
		ledgerid[i] = Util.null2String(request.getParameter("ledgerid"+i)) ;
		tranaccount[i] = Util.null2String(request.getParameter("tranaccount"+i)) ;
		tranbalance[i] = Util.null2String(request.getParameter("tranbalance"+i)) ;
		tranremark[i] = Util.fromScreen(request.getParameter("tranremark"+i),user.getLanguage()) ;
		if(!tranaccount[i].equals("")) {
			BigDecimal tmpaccount = new BigDecimal(tranaccount[i]) ;
			BigDecimal tmpdefaccount = tmpaccount.divide(tranexchangerates,BigDecimal.ROUND_HALF_EVEN) ;
			trandefaccount[i] = tmpdefaccount.toString();
			if(tranbalance[i].equals("1")) trandaccounts = trandaccounts.add(tmpaccount);
			else trancaccounts = trancaccounts.add(tmpaccount);
		}
	}

	trandefdaccounts = trandaccounts.divide(tranexchangerates,BigDecimal.ROUND_HALF_EVEN) ;
	trandefcaccounts = trancaccounts.divide(tranexchangerates,BigDecimal.ROUND_HALF_EVEN) ;


	String para = tranmark + separator + trandate + separator + trandepartmentid + separator + trancostercenterid + separator + trancurrencyid + separator + trandefcurrencyid + separator +
	tranexchangerate + separator + tranaccessories + separator + tranresourceid + separator +
	trancrmid + separator + tranitemid + separator + trandocid + separator + tranprojectid +
	separator + trandaccounts.toString() + separator + trancaccounts.toString() + separator + trandefdaccounts.toString() + separator + trandefcaccounts.toString() +separator +
	tranremarks + separator + transtatus + separator + createrid + separator + createdate ;


	RecordSet.executeProc("FnaTransaction_Insert",para);
	RecordSet.next() ;
	String id = RecordSet.getString(1);
	String pyear = RecordSet.getString(2);

	if(id.equals("-1")) {
		response.sendRedirect("FnaTransactionAdd.jsp?departmentid="+trandepartmentid+"&msgid=12");
		return ;
	}

	if(id.equals("-2")) {
		response.sendRedirect("FnaTransactionAdd.jsp?departmentid="+trandepartmentid+"&msgid=21");
		return ;
	}

	for(int i=0 ; i< totaldetail ; i++)  {
		if(!tranaccount[i].equals("")) {
			para = id+ separator + ledgerid[i] + separator + tranaccount[i] + separator +
					trandefaccount[i]+separator+tranbalance[i] + separator + tranremark[i] ;
			RecordSet.executeProc("FnaTransactionDetail_Insert",para);
		}
	}
	response.sendRedirect("FnaTransactionDetail.jsp?departmentid="+trandepartmentid+
		"&tranperiods="+pyear+"&transtatus=0");
 }

 if(operation.equals("edittransaction")){
	
	String trandepartmentid = Util.null2String(request.getParameter("trandepartmentid"));

	if(!HrmUserVarify.checkUserRight("FnaTransactionEdit:Edit",user,trandepartmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	String id = Util.null2String(request.getParameter("id"));
	String trandate = Util.null2String(request.getParameter("trandate"));
	String trancostercenterid = Util.null2String(request.getParameter("trancostercenterid"));
	String trancurrencyid = Util.null2String(request.getParameter("trancurrencyid"));
	String trandefcurrencyid = Util.null2String(request.getParameter("trandefcurrencyid"));
	String tranexchangerate = Util.null2String(request.getParameter("tranexchangerate"));
	String tranaccessories = Util.null2String(request.getParameter("tranaccessories"));
	String tranresourceid = Util.null2String(request.getParameter("tranresourceid"));
	String trancrmid = Util.null2String(request.getParameter("trancrmid"));
	String tranitemid = Util.null2String(request.getParameter("tranitemid"));
	String trandocid = Util.null2String(request.getParameter("trandocid"));
	String tranprojectid = Util.null2String(request.getParameter("tranprojectid"));
	String tranremarks = Util.fromScreen(request.getParameter("tranremark"),user.getLanguage());
	String transtatus = "0" ;
	String createrid = ""+ user.getUID();
	String createdate = Util.null2String(request.getParameter("createdate"));
	int totaldetail = Util.getIntValue(request.getParameter("totaldetail"));


	String ledgerid[] = new String[totaldetail] ;
	String tranaccount[] = new String[totaldetail] ;
	String trandefaccount[] = new String[totaldetail] ;
	String tranbalance[] = new String[totaldetail] ;
	String tranremark[] = new String[totaldetail] ;
	BigDecimal  trandaccounts = new BigDecimal("0") ;
	BigDecimal  trancaccounts = new BigDecimal("0") ;
	BigDecimal  trandefdaccounts = new BigDecimal("0") ;
	BigDecimal  trandefcaccounts = new BigDecimal("0") ;
	BigDecimal  tranexchangerates = new BigDecimal(tranexchangerate) ;
	if(tranexchangerates.compareTo(trandaccounts) == 0) {
		tranexchangerates = new BigDecimal("1") ;
		tranexchangerate = "1.000" ;
	}

	for(int i=0 ; i< totaldetail ; i++)  {
		ledgerid[i] = Util.null2String(request.getParameter("ledgerid"+i)) ;
		tranaccount[i] = Util.null2String(request.getParameter("tranaccount"+i)) ;
		tranbalance[i] = Util.null2String(request.getParameter("tranbalance"+i)) ;
		tranremark[i] = Util.fromScreen(request.getParameter("tranremark"+i),user.getLanguage()) ;
		if(!tranaccount[i].equals("")) {
			BigDecimal tmpaccount = new BigDecimal(tranaccount[i]) ;
			BigDecimal tmpdefaccount = tmpaccount.divide(tranexchangerates,BigDecimal.ROUND_HALF_EVEN) ;
			trandefaccount[i] = tmpdefaccount.toString();
			if(tranbalance[i].equals("1")) trandaccounts = trandaccounts.add(tmpaccount);
			else trancaccounts = trancaccounts.add(tmpaccount);
		}
	}

	trandefdaccounts = trandaccounts.divide(tranexchangerates,BigDecimal.ROUND_HALF_EVEN) ;
	trandefcaccounts = trancaccounts.divide(tranexchangerates,BigDecimal.ROUND_HALF_EVEN) ;


	String para = id + separator + trandate + separator + trandepartmentid + separator + trancostercenterid + separator + trancurrencyid + separator + trandefcurrencyid + separator +
	tranexchangerate + separator + tranaccessories + separator + tranresourceid + separator +
	trancrmid + separator + tranitemid + separator + trandocid + separator + tranprojectid +
	separator + trandaccounts.toString() + separator + trancaccounts.toString() + separator + trandefdaccounts.toString() + separator + trandefcaccounts.toString() +separator +
	tranremarks + separator + transtatus + separator + createrid + separator + createdate ;


	RecordSet.executeProc("FnaTransaction_Update",para);
	RecordSet.next() ;
	String	ids = RecordSet.getString(1);
	if(ids.equals("-2")) {
		response.sendRedirect("FnaTransactionEdit.jsp?id="+id+"&msgid=21");
		return ;
	}

	for(int i=0 ; i< totaldetail ; i++)  {
		if(!tranaccount[i].equals("")) {
			para = id+ separator + ledgerid[i] + separator + tranaccount[i] + separator +
					trandefaccount[i]+separator+tranbalance[i] + separator + tranremark[i] ;
			RecordSet.executeProc("FnaTransactionDetail_Insert",para);
		}
	}
	
	response.sendRedirect("FnaTransactionDetail.jsp?departmentid="+trandepartmentid+
		"&tranperiods="+ids+"&transtatus=0");
 }
 
 
 if(operation.equals("deletetransaction")){
	
	String trandepartmentid = Util.null2String(request.getParameter("olddepartmentid"));

	if(!HrmUserVarify.checkUserRight("FnaTransactionEdit:Delete",user,trandepartmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String id = Util.null2String(request.getParameter("id"));

	RecordSet.executeProc("FnaTransaction_Delete",id);
	RecordSet.next() ;
	String pyear = RecordSet.getString(1);

	response.sendRedirect("FnaTransactionDetail.jsp?departmentid="+trandepartmentid+
		"&tranperiods="+pyear+"&transtatus=0");
 }

 if(operation.equals("approvetransaction")){
	
	String trandepartmentid = Util.null2String(request.getParameter("olddepartmentid"));

	if(!HrmUserVarify.checkUserRight("FnaTransaction:Approve",user,trandepartmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String id = Util.null2String(request.getParameter("id"));
	String approverid = ""+ user.getUID();
	String approvedate = Util.null2String(request.getParameter("createdate"));

	String para = id + separator + approverid + separator + approvedate ;
	
	RecordSet.executeProc("FnaTransaction_Approve",para);
	RecordSet.next();
	String	ids = RecordSet.getString(1);
	
	if(ids.equals("-1")) {
		response.sendRedirect("FnaTransactionEdit.jsp?id="+id+"&msgid=23");
		return ;
	}

	if(ids.equals("-2")) {
		response.sendRedirect("FnaTransactionEdit.jsp?id="+id+"&msgid=22");
		return ;
	}

	response.sendRedirect("FnaTransactionDetail.jsp?departmentid="+trandepartmentid+
		"&tranperiods="+ids+"&transtatus=1");

	
 }

 if(operation.equals("reopentransaction")){
	
	String trandepartmentid = Util.null2String(request.getParameter("olddepartmentid"));

	if(!HrmUserVarify.checkUserRight("FnaTransaction:Approve",user,trandepartmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String id = Util.null2String(request.getParameter("id"));

	RecordSet.executeProc("FnaTransaction_Reopen",id);
	RecordSet.next() ;
	String pyear = RecordSet.getString(1);

	response.sendRedirect("FnaTransactionDetail.jsp?departmentid="+trandepartmentid+
		"&tranperiods="+pyear+"&transtatus=0");
 }

 if(operation.equals("processtransaction")){
	
	String trandepartmentid = Util.null2String(request.getParameter("departmentid"));

	if(!HrmUserVarify.checkUserRight("FnaTransaction:Process",user,trandepartmentid)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String tranperiods = Util.null2String(request.getParameter("tranperiods"));
	String para = trandepartmentid + separator + tranperiods ;

	RecordSet.executeProc("FnaAccountList_Process",para);
	if(RecordSet.next()) {
		response.sendRedirect("FnaTransactionDetail.jsp?departmentid="+trandepartmentid+
		"&tranperiods="+tranperiods+"&transtatus=1&&msgid=25");
		return ;
	}

	response.sendRedirect("FnaTransactionDetail.jsp?departmentid="+trandepartmentid+
		"&tranperiods="+tranperiods+"&transtatus=2");

		
 }
%>
