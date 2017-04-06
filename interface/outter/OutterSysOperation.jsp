<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String sysid = Util.fromScreen(request.getParameter("sysid"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String iurl = Util.fromScreen(request.getParameter("iurl"),user.getLanguage());
String ourl = Util.fromScreen(request.getParameter("ourl"),user.getLanguage());
String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());//单点登录的类型，1：NC
String accountcode = Util.fromScreen(request.getParameter("accountcode"),user.getLanguage());//NC账套
String baseparam1 = Util.fromScreen(request.getParameter("baseparam1"),user.getLanguage());
String baseparam2 = Util.fromScreen(request.getParameter("baseparam2"),user.getLanguage());
String basetype1 = Util.fromScreen(request.getParameter("basetype1"),user.getLanguage());
String basetype2 = Util.fromScreen(request.getParameter("basetype2"),user.getLanguage());
String paramnames[] = request.getParameterValues("paramnames");
String paramtypes[] = request.getParameterValues("paramtypes");
String paramvalues[] = request.getParameterValues("paramvalues");
String labelnames[] = request.getParameterValues("labelnames");
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	RecordSet.executeSql("select * from outter_sys where sysid='"+sysid+"'");
    if(RecordSet.next()){
     response.sendRedirect("OutterSysAdd.jsp?msgid=21011");
	 return;
	}
	RecordSet.executeSql("insert into outter_sys(sysid,name,iurl,ourl,baseparam1,baseparam2,basetype1,basetype2,typename,ncaccountcode) values('"+sysid+"','"+name+"','"+iurl+"','"+ourl+"','"+baseparam1+"','"+baseparam2+"',"+basetype1+","+basetype2+",'"+typename+"','"+accountcode+"')");
	if(paramnames!=null){
		for(int i=0;i<paramnames.length;i++){
			String paramname=paramnames[i];
			String paramvalue=paramvalues[i];
			String paramtype=paramtypes[i];
			String labelname=labelnames[i];
			if(!paramname.equals(""))
			RecordSet.executeSql("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid) values('"+sysid+"','"+paramname+"','"+paramvalue+"','"+labelname+"',"+paramtype+","+i+")");
		}
	}
	if("1".equals(typename)) { //如果类型是NC，则新增公司名称
		String paramnames_nc = request.getParameter("paramnames_nc");
		String paramtypes_nc = request.getParameter("paramtypes_nc");
		String labelnames_nc = request.getParameter("labelnames_nc");
		RecordSet.executeSql("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid) values('"+sysid+"','"+paramnames_nc+"','','"+labelnames_nc+"',"+paramtypes_nc+",0)");
	}
	
 	response.sendRedirect("OutterSys.jsp");

 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
    RecordSet.executeSql("update outter_sys set sysid='"+sysid+"',name='"+name+"',iurl='"+iurl+"',ourl='"+ourl+"',baseparam1='"+baseparam1+"',baseparam2='"+baseparam2+"',basetype1="+basetype1+",basetype2="+basetype2+",ncaccountcode='"+accountcode+"' where sysid='"+sysid+"'");
    RecordSet.executeSql("delete from outter_sysparam where sysid='"+sysid+"'");
    if(paramnames!=null){     
		for(int i=0;i<paramnames.length;i++){
			String paramname=paramnames[i];
			String paramvalue=paramvalues[i];
			String paramtype=paramtypes[i];
			String labelname=labelnames[i];
			if(!paramname.equals(""))
			RecordSet.executeSql("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid) values('"+sysid+"','"+paramname+"','"+paramvalue+"','"+labelname+"',"+paramtype+","+i+")");
		}
	}	
 	response.sendRedirect("OutterSys.jsp");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
        RecordSet.executeSql("delete from outter_sys where sysid='"+sysid+"'");
		RecordSet.executeSql("delete from outter_sysparam where sysid='"+sysid+"'");
 	response.sendRedirect("OutterSys.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">