<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<%
	String operationType=request.getParameter("operationType");
	int groupID=Util.getIntValue(request.getParameter("groupID"),0);
	char separator = Util.getSeparator() ;
	if(operationType.equals("addgroup")){
		
		
		String mark=Util.fromScreen(request.getParameter("mark"),user.getLanguage());
		String description=Util.fromScreen(request.getParameter("description"),user.getLanguage());
		String notes=Util.fromScreen(request.getParameter("notes"),user.getLanguage());
		
		//add by zhouquan 权限组添加重复提醒
		
		String sql = "select rightgroupname from SystemRightGroups";
		rs.executeSql(sql);
		boolean hasRecord = false;
		while(rs.next()){
			String rightgroupname = rs.getString("rightgroupname");
			if(rightgroupname.equals(description)){
				hasRecord = true;
				break;
			}
		}
		
		if(hasRecord){
			response.sendRedirect("SystemRightGroupAdd.jsp?hasRecord=1");
		}
		else{
			String para=mark+separator+description+separator+notes;
			rs.execute("SystemRightGroups_Insert",para);
			rs.next();
			groupID = rs.getInt(1);
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(groupID);
			SysMaintenanceLog.setRelatedName(description);
			SysMaintenanceLog.setOperateType("1");
			SysMaintenanceLog.setOperateDesc("SystemRightGroups_Insert,"+para);
			SysMaintenanceLog.setOperateItem("28");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
			response.sendRedirect("SystemRightGroup.jsp");
		}
		
		
	}
	if(operationType.equals("editgroup")){
		String mark=Util.fromScreen(request.getParameter("mark"),user.getLanguage());
		String description=Util.fromScreen(request.getParameter("description"),user.getLanguage());
		String notes=Util.fromScreen(request.getParameter("notes"),user.getLanguage());

		//add by zhouquan 权限组添加重复提醒
		
		String sql = "select rightgroupname from SystemRightGroups where id != "+groupID;
		rs.executeSql(sql);
		boolean hasRecord = false;
		while(rs.next()){
			String rightgroupname = rs.getString("rightgroupname");
			if(rightgroupname.equals(description)){
				hasRecord = true;
				break;
			}
		}
		if(hasRecord){
			response.sendRedirect("SystemRightGroupEdit.jsp?id="+groupID+"&hasRecord=1");
		}
		else{
			String para=groupID+""+separator+mark+separator+description+separator+notes;
			rs.execute("SystemRightGroup_Update",para);
			
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(groupID);
			SysMaintenanceLog.setRelatedName(description);
			SysMaintenanceLog.setOperateType("2");
			SysMaintenanceLog.setOperateDesc("SystemRightGroup_Update,"+para);
			SysMaintenanceLog.setOperateItem("28");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
			response.sendRedirect("SystemRightGroup.jsp");
		}
	}
	if(operationType.equals("deletegroup")){
		rs.execute("SystemRightGroup_Delete",""+groupID);
		rs.next();
		String description=rs.getString(1);

		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(groupID);
		SysMaintenanceLog.setRelatedName(description);
		SysMaintenanceLog.setOperateType("3");
		SysMaintenanceLog.setOperateDesc("SystemRightGroup_Delete,"+groupID);
		SysMaintenanceLog.setOperateItem("28");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		response.sendRedirect("SystemRightGroup.jsp");
	}
	if(operationType.equals("deleteright")){
		String rightid=request.getParameter("rightid");
		String para= ""+groupID+separator+rightid ;
		rs.execute("SystemRightToGroup_Delete",para);
		response.sendRedirect("SystemRightGroupEdit.jsp?id="+groupID);
	}
	if(operationType.equals("addright")){
		String rightid=request.getParameter("rightid");
		String para=""+groupID+separator+rightid;
		rs.execute("SystemRightToGroup_Insert",para);
		response.sendRedirect("SystemRightGroupEdit.jsp?id="+groupID);
	}
	if(operationType.equals("addrightroles")){
		String rightid=request.getParameter("rightid");
		String roleid=request.getParameter("roleid"); 
		String rolelevel=request.getParameter("rolelevel");
		String para=rightid+separator+roleid+separator+rolelevel;
		rs.execute("SystemRightRoles_Insert",para);
		CheckUserRight.updateRoleRightdetail(roleid , rightid , rolelevel) ;
		response.sendRedirect("SystemRightRoles.jsp?id="+rightid+"&groupID="+groupID);
	}
	if(operationType.equals("editrightroles")){
		String id=request.getParameter("id");
		String rightid=request.getParameter("rightid");
		String roleid=request.getParameter("roleid"); 
		String rolelevel=request.getParameter("rolelevel");
		String para=id+separator+rolelevel;
		rs.execute("SystemRightRoles_Update",para);
		CheckUserRight.updateRoleRightdetail(roleid , rightid , rolelevel) ;
		response.sendRedirect("SystemRightRoles.jsp?id="+rightid+"&groupID="+groupID);
	}
	if(operationType.equals("deleterightroles")){
		String id=request.getParameter("id");
		String rightid=request.getParameter("rightid");
		String roleid=request.getParameter("roleid"); 
		rs.execute("SystemRightRoles_Delete",id);
		CheckUserRight.deleteRoleRightdetail(roleid , rightid) ;
		response.sendRedirect("SystemRightRoles.jsp?id="+rightid+"&groupID="+groupID);
	}
%>