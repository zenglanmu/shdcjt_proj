<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<%!
/*
*Added by Charoes Huang
*Check if the department level equals 10, if true,this department can't have sub department
*
*/
private boolean ifDeptLevelEquals10(int departmentid){
	boolean isEquals10 = false;
	RecordSet rs = new RecordSet();
	String sqlStr ="Select  COUNT(d1.id) from 	HrmDepartment d1,HrmDepartment d2,HrmDepartment d3,HrmDepartment d4,HrmDepartment d5,HrmDepartment d6,HrmDepartment d7,HrmDepartment d8,HrmDepartment d9 WHERE   d1.supdepid = d2.id and d2.supdepid = d3.id and	d3.supdepid = d4.id and	d4.supdepid = d5.id and	d5.supdepid = d6.id and	d6.supdepid = d7.id and	d7.supdepid = d8.id and	d8.supdepid = d9.id and  d1.id <> d2.id and d1.id = "+departmentid ;

	rs.executeSql(sqlStr);
	if(rs.next()){
		if(rs.getInt(1) > 0){
			isEquals10 = true ;
		}
	}
	return isEquals10;
}

%>
<%
application.removeAttribute("organlist");//update for hrm broser,xiaofeng
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());

String departmentmark = Util.fromScreen(request.getParameter("departmentmark"),user.getLanguage());
String departmentname = Util.fromScreen(request.getParameter("departmentname"),user.getLanguage());
String subcompanyid1 = Util.fromScreen(request.getParameter("subcompanyid1"),user.getLanguage());
if(Util.getIntValue(subcompanyid1,0)<=0&&!operation.equals("delete")) 
throw new Exception("invalid subcompanyid:"+subcompanyid1);
String supdepid = Util.fromScreen(request.getParameter("supdepid"),user.getLanguage());
String showorder = Util.fromScreen(request.getParameter("showorder"),user.getLanguage());
String allsupdepid = "";
String sURL="";
String departmentcode = Util.fromScreen(request.getParameter("departmentcode"),user.getLanguage());
int coadjutant=Util.getIntValue(request.getParameter("coadjutant"),0);     
String zzjgbmfzr = Util.null2String(request.getParameter("zzjgbmfzr"));//组织机构部门负责人
String zzjgbmfgld = Util.null2String(request.getParameter("zzjgbmfgld"));//组织机构部门分管领导
String jzglbmfzr = Util.null2String(request.getParameter("jzglbmfzr"));//矩阵管理部门负责人
String jzglbmfgld = Util.null2String(request.getParameter("jzglbmfgld"));//矩阵管理部分分管领导
if(operation.equals("add")){
	/*
	* Added by Charoes Huang
	* 判断是否10级部门
	*/
	int supdepartmentid = Util.getIntValue(supdepid,0);
	if(supdepartmentid > 0){
		if(ifDeptLevelEquals10(supdepartmentid)){
            sURL="HrmCompany_frm.jsp?gotopage=/hrm/company/HrmDepartmentAdd.jsp&parments=subcompanyid="+subcompanyid1+"_supdepid="+supdepid+"_msgid=56_departmentmark="+departmentmark+"_departmentname="+departmentname+"_showorder="+showorder;
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
			return;
		}
	}
   char separator = Util.getSeparator() ;
   //allsupdepid = DepartmentComInfo.getAllSupDepId(Util.getIntValue(supdepid))+supdepid+",";


	String para =  departmentmark + separator + departmentname + separator +
	                supdepid+separator+allsupdepid+separator+subcompanyid1 + separator+ showorder+separator+coadjutant;
	RecordSet.executeProc("HrmDepartment_Insert",para);
	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
	RecordSet.executeSql("update hrmdepartment set departmentcode = '" + departmentcode + "',zzjgbmfzr='"+zzjgbmfzr+"',zzjgbmfgld='"+zzjgbmfgld+"',jzglbmfzr='"+jzglbmfzr+"',jzglbmfgld='"+jzglbmfgld+"' where id = " + id);
	//xiaofeng
        int flag=RecordSet.getFlag();
	//System.out.println(flag);
        if(flag==2){
            sURL="/hrm/company/HrmDepartmentAdd.jsp&parments=subcompanyid="+subcompanyid1+"_supdepid="+supdepid+"_msgid=41_departmentmark="+departmentmark+"_departmentname="+departmentname+"_showorder="+showorder;
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
            //response.sendRedirect("/hrm/company/HrmDepartmentAdd.jsp?msgid=41");
        return;
        }
        if(flag==3){
            sURL="/hrm/company/HrmDepartmentAdd.jsp&parments=subcompanyid="+subcompanyid1+"_supdepid="+supdepid+"_msgid=44_departmentmark="+departmentmark+"_departmentname="+departmentname+"_showorder="+showorder;
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmDepartmentAdd.jsp?msgid=44");
        return;
        }

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(departmentname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmDepartment_Insert,"+para);
      SysMaintenanceLog.setOperateItem("12");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	DepartmentComInfo.removeCompanyCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");

    //add by wjy
    //同步RTX端部门信息
    OrganisationCom.addDepartment(id);

    //response.sendRedirect("HrmCompany_frm.jsp?subcomid="+subcompanyid1+"&deptid="+id);
    String nodeid = "dept_"+subcompanyid1+"_"+id;
    %>
	<SCRIPT LANGUAGE='JavaScript'>
		var parentPage = parent.location.href;
		if(parentPage.indexOf("HrmCompany_frm") > -1){
			parent.location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}else{
			location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}
	</SCRIPT>
	<%
    return;
 }
 else if(operation.equals("edit")){
	int id = Util.getIntValue(request.getParameter("id"),0);

	/*
	* Added by Charoes Huang
	* 判断是否10级部门
	*/
	int supdepartmentid = Util.getIntValue(supdepid,0);
	if(supdepartmentid > 0){
		if(ifDeptLevelEquals10(supdepartmentid)){
            sURL="HrmCompany_frm.jsp?gotopage=/hrm/company/HrmDepartmentEdit.jsp&parments=subcompanyid="+subcompanyid1+"_supdepid="+supdepid+"_id="+id+"_msgid=56_departmentmark="+departmentmark+"_departmentname="+departmentname+"_showorder="+showorder;
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
            //response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&message=1");
			return;
		}
	}

// allsupdepid不再使用
/*	String oldallsupid = DepartmentComInfo.getAllSupDepId(id);
	allsupdepid = DepartmentComInfo.getAllSupDepId(Util.getIntValue(supdepid))+supdepid+",";


    String sql = "select id,allsupdepid from HrmDepartment where allsupdepid like '"+oldallsupid+"%'";
	rs.executeSql(sql);
	while(rs.next()){
          String alldepid = Util.null2String(rs.getString("allsupdepid"));
	  String depid = rs.getString("id");
	  alldepid = Util.StringReplaceOnce(alldepid,oldallsupid,allsupdepid);
	  sql = "update HrmDepartment set allsupdepid = '"+alldepid+"' where id="+depid;
	  rs2.executeSql(sql);
        }*/


    char separator = Util.getSeparator() ;
	String para = ""+id +separator+ departmentmark + separator + departmentname + separator +
	                supdepid+separator+allsupdepid+separator+subcompanyid1 + separator+ showorder+separator+coadjutant;
	RecordSet.executeProc("HrmDepartment_Update",para);
	RecordSet.executeSql("update hrmdepartment set departmentcode = '" + departmentcode + "',zzjgbmfzr='"+zzjgbmfzr+"',zzjgbmfgld='"+zzjgbmfgld+"',jzglbmfzr='"+jzglbmfzr+"',jzglbmfgld='"+jzglbmfgld+"' where id = " + id);
//xiaofeng
        int flag=RecordSet.getFlag();
	//System.out.println(flag);
        if(flag==2){
            sURL="HrmCompany_frm.jsp?gotopage=/hrm/company/HrmDepartmentEdit.jsp&parments=subcompanyid="+subcompanyid1+"_supdepid="+supdepid+"_id="+id+"_msgid=41_departmentmark="+departmentmark+"_departmentname="+departmentname+"_showorder="+showorder;
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmDepartmentEdit.jsp?id="+id+"&msgid=41");
        return;
        }
        if(flag==3){
            sURL="HrmCompany_frm.jsp?gotopage=/hrm/company/HrmDepartmentEdit.jsp&parments=subcompanyid="+subcompanyid1+"_supdepid="+supdepid+"_id="+id+"_msgid=44_departmentmark="+departmentmark+"_departmentname="+departmentname+"_showorder="+showorder;
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmDepartmentEdit.jsp?id="+id+"&msgid=44");
        return;
        }
        
        ArrayList departmentlist = new ArrayList();
        //departmentlist.add(id+"");
        //rs.execute("select id from HrmDepartment where supdepid="+id);
        //while(rs.next()){
        //	int childdepartmenttmp = Util.getIntValue(rs.getString(1), 0);
        //	departmentlist.add(childdepartmenttmp+"");
        //	RecordSet.execute("update HrmDepartment set subcompanyid1="+subcompanyid1+" where id="+childdepartmenttmp);
        //}
        departmentlist = DepartmentComInfo.getAllChildDeptByDepId(departmentlist,id+"");
        departmentlist.add(id+"");
        
        for(int i=0;i<departmentlist.size();i++){
        	String listdepartmenttemp = (String)departmentlist.get(i);
        	RecordSet.execute("update HrmDepartment set subcompanyid1="+subcompanyid1+" where id="+listdepartmenttemp);
	        //TD16048改为逐条修改
			rs.execute("select id, subcompanyid1,managerid,seclevel,managerstr from hrmresource where departmentid="+listdepartmenttemp);
	        while(rs.next()){
	        	int resourceid_tmp = Util.getIntValue(rs.getString(1), 0);
	        	int oldsubcompanyid1 = Util.getIntValue(rs.getString(2), 0);
	        	int oldmanagerid = Util.getIntValue(rs.getString(3), 0);
	        	int seclevel = Util.getIntValue(rs.getString(4), 0);
	        	String oldmanagerstr = Util.null2String(rs.getString(5));
	        	RecordSet.execute("update hrmresource set subcompanyid1="+subcompanyid1+" where id="+resourceid_tmp);
	        	para = ""+resourceid_tmp + separator + listdepartmenttemp + separator + subcompanyid1 + separator + oldmanagerid + separator + seclevel + separator + oldmanagerstr + separator + listdepartmenttemp + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + seclevel + separator + oldmanagerstr + separator + "1";
	        	RecordSet.executeProc("HrmResourceShare",para);
	        }
	      //add by wjy
	        //同步RTX端部门信息
	        OrganisationCom.editDepartment(Util.getIntValue(listdepartmenttemp));
        }

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(departmentname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmDepartment_Update,"+para);
      SysMaintenanceLog.setOperateItem("12");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	DepartmentComInfo.removeCompanyCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");

    String nodeid = "dept_"+subcompanyid1+"_"+id;
    //response.sendRedirect("HrmCompany_frm.jsp?subcomid="+subcompanyid1+"&deptid="+id);
    %>
	<SCRIPT LANGUAGE='JavaScript'>
		var parentPage = parent.location.href;
		//alert(location.href);
		//alert(parentPage.indexOf("HrmCompany_frm"));
		if(parentPage.indexOf("HrmCompany_frm") > -1){
			parent.location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}else{
			location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}
	</SCRIPT>
	<%
    return;
    
 }
 else if(operation.equals("delete")){
	boolean canDelete = true;
	int id = Util.getIntValue(request.getParameter("id"),0);
     char separator = Util.getSeparator() ;
	String para = ""+id;
/*
    原有的判断数据中心删除部门去掉
    String sql = "select count(id) from HrmCostcenter where departmentid = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
		response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
	} */

	String sql = "select count(id) from HrmJobTitles where jobdepartmentid ="+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
        sURL="HrmCompany_frm.jsp?gotopage=/hrm/company/HrmDepartmentEdit.jsp&parments=subcompanyid="+subcompanyid1+"_supdepid="+supdepid+"_id="+id+"_msgid=20_departmentmark="+departmentmark+"_departmentname="+departmentname+"_showorder="+showorder;
        session.setAttribute("subcompanyid",subcompanyid1);
        session.setAttribute("supdepid",supdepid);
        session.setAttribute("departmentmark",departmentmark);
        session.setAttribute("departmentname",departmentname);
        session.setAttribute("showorder",""+showorder);
        //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
        response.sendRedirect(sURL);
        //response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
        return ;
	}

/*
    原有的判断部门工作时间删除部门去掉
	 sql = "select count(id) from HrmSchedule where relatedid ="+id+" and scheduletype = 1";
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
		response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
	} */

/*
    原有的判断部门下面人力资源删除部门去掉，由控制岗位来实现
	 sql = "select count(id) from HrmResource where departmentid ="+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
		response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
	} */

	if(canDelete){
	    RecordSet.executeProc("HrmDepartment_Delete",para);
        //add by wjy
        //同步RTX端部门信息
        OrganisationCom.deleteDepartment(id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(departmentname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmDepartment_Delete,"+para);
      SysMaintenanceLog.setOperateItem("12");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
    String supid=DepartmentComInfo.getDepartmentsupdepid(""+id);
	DepartmentComInfo.removeCompanyCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");
    String nodeid = "";
    //response.sendRedirect("HrmCompany_frm.jsp?subcomid="+subcompanyid1+"&deptid="+supid);
    %>
	<SCRIPT LANGUAGE='JavaScript'>
		var parentPage = parent.location.href;
		if(parentPage.indexOf("HrmCompany_frm") > -1){
			parent.location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}else{
			location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}
	</SCRIPT>
	<%
    return;    
 }
%>
