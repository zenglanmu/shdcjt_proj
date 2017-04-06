<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />

<%
	/**get parameter*/
	String operationType = request.getParameter("operationType");
	String roleId = request.getParameter("roleId");
	String rightId = request.getParameter("rightId");

	/**separator for sql procedure param*/
	char separator = Util.getSeparator();


	if(operationType.equals("addRoleRight")){
		String roleLevel = request.getParameter("roleLevel");
        int rightcount = Util.getIntValue(request.getParameter("rightcount"),0);
		
        for(int i=0; i<rightcount; i++){
            String ischecked=request.getParameter("chk_"+i);
            if(ischecked!=null && ischecked.equals("1")){
                String rightid_tmp=request.getParameter("rightid_"+i);
				String rightname_tmp=request.getParameter("rightname_"+i);

                rs.execute("SystemRightRoles_Delete",rightid_tmp);
                String para=rightid_tmp+separator+roleId+separator+roleLevel;
                rs.execute("SystemRightRoles_Insert",para);

                SysMaintenanceLog.resetParameter();
                SysMaintenanceLog.setRelatedId(Util.getIntValue(roleId));
                SysMaintenanceLog.setRelatedName(RolesComInfo.getRolesRemark(roleId)+":"+rightname_tmp);
                SysMaintenanceLog.setOperateType("1");
                SysMaintenanceLog.setOperateDesc("SystemRightRoles_Insert,"+para);
                SysMaintenanceLog.setOperateItem("102");
                SysMaintenanceLog.setOperateUserid(user.getUID());
                SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
                SysMaintenanceLog.setSysLogInfo();

                CheckUserRight.updateRoleRightdetail(roleId , rightid_tmp , roleLevel) ;
                CheckUserRight.removeMemberRoleCache();
                CheckUserRight.removeRoleRightdetailCache();
            }
        }
        response.sendRedirect("HrmRolesFucRightSet.jsp?id="+roleId);
	}
	if(operationType.equals("editRoleRight")){
		
		String id=request.getParameter("id");//roleRightId in table systemrightroles;
		String roleLevel = request.getParameter("roleLevel");

		String para=id+separator+roleLevel;
		rs.execute("SystemRightRoles_Update",para);

		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(roleId));
		SysMaintenanceLog.setRelatedName(RolesComInfo.getRolesRemark(roleId));
		SysMaintenanceLog.setOperateType("2");
		SysMaintenanceLog.setOperateDesc("SystemRightRoles_Update,"+para);
		SysMaintenanceLog.setOperateItem("16");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();

		CheckUserRight.updateRoleRightdetail(roleId , rightId , roleLevel) ;
		CheckUserRight.removeMemberRoleCache();
        CheckUserRight.removeRoleRightdetailCache();
		response.sendRedirect("HrmRolesFucRightSet.jsp?id="+roleId);
	}
	if(operationType.equals("deleteRoleRight")){
		String id=request.getParameter("id");//roleRightId in table systemrightroles;
		int rightcount = Util.getIntValue(request.getParameter("rightcount"),0);
		for(int i=0; i<rightcount; i++){
		String rightname_tmp=request.getParameter("rightname_"+i);
		rs.execute("SystemRightRoles_Delete",id);
		
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(roleId));
		SysMaintenanceLog.setRelatedName(RolesComInfo.getRolesRemark(roleId)+":"+rightname_tmp);
		SysMaintenanceLog.setOperateType("3");
		SysMaintenanceLog.setOperateDesc("SystemRightRoles_Delete");
		SysMaintenanceLog.setOperateItem("102");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		
		CheckUserRight.deleteRoleRightdetail(roleId , rightId) ;
		CheckUserRight.removeMemberRoleCache();
        CheckUserRight.removeRoleRightdetailCache();
		response.sendRedirect("HrmRolesFucRightSet.jsp?id="+roleId);
		}
	}


%>