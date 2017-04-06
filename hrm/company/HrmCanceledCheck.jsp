<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<%
	String cancelFlag = request.getParameter("cancelFlag");
	int deptorsupid = Util.getIntValue(request.getParameter("deptorsupid"));
	int userid = Util.getIntValue(request.getParameter("userid"));
	String operation = Util.null2String(request.getParameter("operation"));
	String deptorsubname = "";
	String sqlname = "";
	if ("subcompany".equals(operation)) {
	    sqlname = "select subcompanyname from HrmSubCompany where id = "+deptorsupid;
	    rs.executeSql(sqlname);
	    if(rs.next()) deptorsubname = rs.getString("subcompanyname");
	    
		if ("1".equals(cancelFlag)) {
			
			RecordSet.executeSql("select id from HrmSubCompany where canceled ='1' and id = (select supsubcomid from HrmSubCompany where id ="+deptorsupid+")");
			if(RecordSet.next()) {
				out.println("0");
			} else {
				RecordSet.executeSql("update HrmSubCompany set canceled = '0' where id ="+ deptorsupid);
				SubCompanyComInfo.removeCompanyCache();
				
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(deptorsupid);
				SysMaintenanceLog.setRelatedName(deptorsubname);
				SysMaintenanceLog.setOperateType("11");
				SysMaintenanceLog.setOperateItem("11");
				SysMaintenanceLog.setOperateUserid(userid);
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
				
				OrganisationCom.addSubCompany(deptorsupid);//分部解封时同步到RTX
				
				out.println("1");
			}
		} else {
			String sqlstr = "select id from hrmdepartment where (canceled = '0' or canceled is null) "
			+ " and exists (select 1 from hrmsubcompany b where hrmdepartment.subcompanyid1 = b.id and b.id ="
			+ deptorsupid
			+ ")"
			+ " union"
			+ " select id from hrmsubcompany where (canceled = '0' or canceled is null) and id in (select id from hrmsubcompany where supsubcomid ="
			+ deptorsupid + ")";
			RecordSet.executeSql(sqlstr);
			if (RecordSet.next()) {
				out.println("0");
			} else {
				RecordSet.executeSql("update HrmSubCompany set canceled = '1' where id ="+ deptorsupid);
				SubCompanyComInfo.removeCompanyCache();
				
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(deptorsupid);
				SysMaintenanceLog.setRelatedName(deptorsubname);
				SysMaintenanceLog.setOperateType("10");
				SysMaintenanceLog.setOperateItem("11");
				SysMaintenanceLog.setOperateUserid(userid);
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
				
				OrganisationCom.deleteSubCompany(deptorsupid);//分部封存时同步到RTX
				
				out.println("1");
			}
		}
	} else {
	    sqlname = "select departmentname from hrmdepartment where id = "+deptorsupid;
	    rs.executeSql(sqlname);
	    if(rs.next()) deptorsubname = rs.getString("departmentname");
	    
		if ("1".equals(cancelFlag)) {
			RecordSet.executeSql("select id from HrmSubCompany where canceled ='1' and id = (select subcompanyid1 from hrmdepartment where id = "+deptorsupid+")");
			if(RecordSet.next()){
				out.println("0");
			} else {
				RecordSet.executeSql("select id from hrmdepartment where canceled ='1' and id = (select supdepid from hrmdepartment where id = "+deptorsupid+")");
				if(RecordSet.next()) {
					out.println("2");
				} else {
					RecordSet.executeSql("update hrmdepartment set canceled = '0' where id ="+ deptorsupid);
					DepartmentComInfo.removeCompanyCache();
		
					SysMaintenanceLog.resetParameter();
					SysMaintenanceLog.setRelatedId(deptorsupid);
					SysMaintenanceLog.setRelatedName(deptorsubname);
					SysMaintenanceLog.setOperateType("11");
					SysMaintenanceLog.setOperateItem("12");
					SysMaintenanceLog.setOperateUserid(userid);
					SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
					SysMaintenanceLog.setSysLogInfo();
					
					OrganisationCom.addDepartment(deptorsupid);//部门解封时同步到RTX
		
					out.println("1");
				}
			}
		} else {
			String sqlstr = "select id from hrmresource where status in (0,1,2,3)"
			+ " and EXISTS (select 1 from hrmdepartment b where hrmresource.departmentid=b.id and b.id = "
			+ deptorsupid
			+ ")"
			+ " union"
			+ " select id from hrmdepartment where (canceled = '0' or canceled is null) and id in (select id from hrmdepartment where supdepid = "
			+ deptorsupid + ")";
			RecordSet.executeSql(sqlstr);
			if (RecordSet.next()) {
		        out.println("0");
			} else {
				RecordSet.executeSql("update hrmdepartment set canceled = '1' where id ="+ deptorsupid);
				DepartmentComInfo.removeCompanyCache();
		
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(deptorsupid);
				SysMaintenanceLog.setRelatedName(deptorsubname);
				SysMaintenanceLog.setOperateType("10");
				SysMaintenanceLog.setOperateItem("12");
				SysMaintenanceLog.setOperateUserid(userid);
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
				
				OrganisationCom.deleteDepartment(deptorsupid);//部门封存时同步到RTX
		
				out.println("1");
			}
		}
	}
	RecordSet.executeSql("update orgchartstate set needupdate=1");
%>
