
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
String typecode = Util.fromScreen(request.getParameter("typecode"),user.getLanguage());
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("CptCapitalTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;

	String para = name + separator + description;
	RecordSet.executeProc("CptCapitalType_Insert",para);
	int id=0;

	RecordSet.executeSql("select max(id) from CptCapitalType");
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}

	RecordSet.executeSql("update CptCapitalType set typecode = '" + typecode + "' where id = " + id);

    // uncommented and modified the "operate item" to 44 by lupeng 2004-07-21 for TD546.
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("CptCapitalType_Insert,"+para);
      SysMaintenanceLog.setOperateItem("44");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
    // end.

	CapitalTypeComInfo.removeCapitalTypeCache();
 	response.sendRedirect("CptCapitalType.jsp");
 }

else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id + separator + name + separator + description;
	RecordSet.executeProc("CptCapitalType_Update",para);

	RecordSet.executeSql("update CptCapitalType set typecode = '" + typecode + "' where id = " + id);

    // uncommented and modified the "operate item" to 44 by lupeng 2004-07-21 for TD546.
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("CptCapitalType_Update,"+para);
      SysMaintenanceLog.setOperateItem("44");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
    // end.

		CapitalTypeComInfo.removeCapitalTypeCache();
 	response.sendRedirect("CptCapitalType.jsp");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	RecordSet.executeProc("CptCapitalType_Delete",para);

	//added by lupeng for TD547.
	if (RecordSet.next() && (Util.null2String(RecordSet.getString(1))).equals("-1")) {
		response.sendRedirect("CptCapitalTypeEdit.jsp?id="+para+"&msgid=20");
    	return;
	}
	//end

     // uncommented and modified the "operate item" to 44 by lupeng 2004-07-21 for TD546.
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("CptCapitalType_Delete,"+para);
      SysMaintenanceLog.setOperateItem("44");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
     // end.

	CapitalTypeComInfo.removeCapitalTypeCache();
 	response.sendRedirect("CptCapitalType.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">