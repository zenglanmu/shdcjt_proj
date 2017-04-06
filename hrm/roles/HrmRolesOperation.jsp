<%@ page import="weaver.general.Util,weaver.conn.RecordSet,java.io.*" %>

<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%
RecordSet rs=new RecordSet();
String operationtype=Util.null2String(request.getParameter("operationType"));
String id=Util.null2String(request.getParameter("id"));
int roleaddin =0;
	if(operationtype.equals("Add")){
		if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
		}
		String idname=Util.convertInput2DB(Util.null2String(request.getParameter("idname")));
		String description=Util.convertInput2DB(Util.null2String(request.getParameter("description")));
		int docid=Util.getIntValue(request.getParameter("docid"),0);	
        int type=Util.getIntValue(request.getParameter("roletype"),0);	
        String structureid=Util.null2String(request.getParameter("structureid"));
        //½ÇÉ«Ãû³ÆÖØ¸´ÅÐ¶Ï
        String checkSql = "select count(id) from HrmRoles where  rolesmark ='"+idname+"'";
        //System.out.println("******"+checkSql);
        RecordSet.executeSql(checkSql);
        if(RecordSet.next()){
            if(RecordSet.getInt(1)>0){
                response.sendRedirect("HrmRolesAdd.jsp?errorcode=10");
                return;
            }
        }
		char flag=Util.getSeparator();
		String cmd=idname+flag+description+flag+docid+flag+type+flag+structureid;
		rs.execute("HrmRoles_insert_name",cmd);
		if(rs.next()){
		roleaddin =rs.getInt("id");
		}
		

        SysMaintenanceLog.resetParameter();
		String Sql1 = "select id from HrmRoles  where   rolesmark ='"+idname+"'";
        RecordSet.executeSql(Sql1);
        String rolseid="";
        if(RecordSet.next()){
            rolseid=RecordSet.getString(1);
        }

		SysMaintenanceLog.setRelatedId(Util.getIntValue(rolseid));
		SysMaintenanceLog.setRelatedName(idname);
		SysMaintenanceLog.setOperateType("1");
		SysMaintenanceLog.setOperateDesc("HrmRoles_insert,"+cmd);
		SysMaintenanceLog.setOperateItem("16");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		RolesComInfo.removeRolesCache();
	}
	if(operationtype.equals("Edit")){
		if(!HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
		}
		String idname=Util.convertInput2DB3(Util.null2String(request.getParameter("idname")));
		String description=Util.convertInput2DB3(Util.null2String(request.getParameter("description")));
		int docid=Util.getIntValue(request.getParameter("docid"),0);	
		String oldname= RolesComInfo.getRolesRemark(""+id);
	    int type=Util.getIntValue(request.getParameter("roletype"),0);	
	    int structureid=Util.getIntValue(request.getParameter("structureid"),0);	
    	//½ÇÉ«Ãû³ÆÖØ¸´ÅÐ¶Ï
        String checkSql = "select count(id) from HrmRoles where  rolesmark ='"+idname+"'";
        //System.out.println("------"+checkSql);
        RecordSet.executeSql(checkSql);
        if(RecordSet.next()){
            if(RecordSet.getInt(1)>0 && !oldname.equalsIgnoreCase(idname)){
                response.sendRedirect("HrmRolesEdit.jsp?errorcode=10&id="+id+"");
                return;
            }
        }
		char flag=Util.getSeparator();
		String cmd=id+flag+idname+flag+description+flag+docid+flag+type+flag+structureid;
		rs.execute("HrmRoles_update",cmd);
	
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
		SysMaintenanceLog.setRelatedName(idname);
		SysMaintenanceLog.setOperateType("2");
		SysMaintenanceLog.setOperateDesc("HrmRoles_update,"+cmd);
		SysMaintenanceLog.setOperateItem("16");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		RolesComInfo.removeRolesCache();

		response.sendRedirect("/hrm/roles/HrmRolesEdit.jsp?id="+id);
		return;
	}
	if(operationtype.equals("Delete")){
		if(!HrmUserVarify.checkUserRight("HrmRolesEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
		}
		rs.execute("HrmRoles_deleteSingle",id);
        String idname = Util.null2String(request.getParameter("idname"));
        String description = Util.null2String(request.getParameter("description"));
        int type = Util.getIntValue(request.getParameter("roletype"), 0);
        int structureid = Util.getIntValue(request.getParameter("structureid"), 0);
        int docid=Util.getIntValue(request.getParameter("docid"),0);
        char separator=Util.getSeparator();
        SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        String cmd=id+separator+idname+separator+description+separator+docid+separator+type+separator+structureid;
        SysMaintenanceLog.setRelatedName(idname);
		SysMaintenanceLog.setOperateType("3");
		SysMaintenanceLog.setOperateDesc("HrmRoles_delete,"+cmd);
		SysMaintenanceLog.setOperateItem("16");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
        rs.next();
		int flag=rs.getInt(1);
		if(flag==11){
			response.sendRedirect("HrmRolesEdit.jsp?flag="+flag+"&id="+id);
		}
	%>
		<script>window.parent.opener._table.reLoad(); 
	            window.parent.open('','_self');
				window.parent.close();</script>
	<%}
	
	RolesComInfo.removeRolesCache();
	String returnStr="/hrm/roles/HrmRoles.jsp";
	if(operationtype.equals("Add")){
			
			
			%>
		<script>window.open("/hrm/roles/HrmRolesShowEdit.jsp?id=<%=roleaddin%>&type=0");
				window.location="/hrm/roles/HrmRoles.jsp";	
		</script>	

		
	<%
	} else {
		out.println("<SCRIPT LANGUAGE='JavaScript'>parent.location='"+returnStr+"';</SCRIPT>");
	}
%>