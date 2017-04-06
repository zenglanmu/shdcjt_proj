<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>

<%
String method = Util.null2String(request.getParameter("method"));
AclManager am = new AclManager();

int secid = Util.getIntValue(request.getParameter("secCategoryId"),0);
int subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secid),0);
if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !am.hasPermission(subid, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

if(method.equalsIgnoreCase("save") ){
	int editionIsOpen =  Util.getIntValue(request.getParameter("editionIsOpen"),0);
	String editionPrefix = Util.null2String(request.getParameter("editionPrefix"));
	int readerCanViewHistoryEdition=  Util.getIntValue(request.getParameter("readerCanViewHistoryEdition"),0);
	int isNotDelHisAtt = Util.getIntValue(request.getParameter("isNotDelHisAtt"),0);
	
	RecordSet.executeSql("update DocSecCategory set editionIsOpen="+editionIsOpen+",editionPrefix='"+editionPrefix+"',readerCanViewHistoryEdition="+readerCanViewHistoryEdition+",isNotDelHisAtt="+isNotDelHisAtt+" where id="+secid);
	response.sendRedirect("DocSecCategoryEdit.jsp?id="+secid+"&tab=2");
}
%>