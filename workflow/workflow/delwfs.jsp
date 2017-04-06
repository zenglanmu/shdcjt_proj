<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<!--add by xhheng @ 2004/12/07 for TDID 1317-->
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="WFMainManager" class="weaver.workflow.workflow.WFMainManager" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<%
  //modify by xhheng @ 2004/12/07 for TDID 1317 start
  //删除工作流日志
  String del_ids[]=request.getParameterValues("delete_wf_id");
  int typeid=Util.getIntValue(request.getParameter("typeid"),0);
  String isTemplate=Util.null2String(request.getParameter("isTemplate"));

  for(int i=0;i<del_ids.length;i++){
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId((new Integer(del_ids[i])).intValue());
    //modify by xhheng @20050104 for TD 1317
    WFManager.setWfid((new Integer(del_ids[i])).intValue());
    WFManager.getWfInfo();
    SysMaintenanceLog.setRelatedName(WFManager.getWfname());
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("WrokFlow_delete");
    SysMaintenanceLog.setOperateItem("85");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setIstemplate(Util.getIntValue(isTemplate));    
    SysMaintenanceLog.setSysLogInfo();
  }
  //modify by xhheng @20050104 for TD 1317
  WFMainManager.DeleteWf(del_ids);
  //modify by xhheng @ 2004/12/07 for TDID 1317 end

  WorkflowComInfo.removeWorkflowCache();
  response.sendRedirect("managewf.jsp?typeid="+typeid+"&isTemplate="+isTemplate);
%>
