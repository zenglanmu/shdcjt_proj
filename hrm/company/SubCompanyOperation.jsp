<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<%!
/*
*Check if the subcompany level equals 10, if true,this subcompany can't have sub subcompany
*
*/
private boolean ifDeptLevelEquals10(int subcompanyid){
	boolean isEquals10 = false;
    RecordSet rs = new RecordSet();

	String sqlStr ="Select COUNT(d1.id) from Hrmsubcompany d1,Hrmsubcompany d2,Hrmsubcompany d3,Hrmsubcompany d4,Hrmsubcompany d5,Hrmsubcompany d6,Hrmsubcompany d7,Hrmsubcompany d8,Hrmsubcompany d9 WHERE   d1.supsubcomid = d2.id and d2.supsubcomid = d3.id and d3.supsubcomid = d4.id and d4.supsubcomid = d5.id and d5.supsubcomid = d6.id and d6.supsubcomid = d7.id and d7.supsubcomid = d8.id and d8.supsubcomid = d9.id and d1.id <> d2.id and d1.id ="+subcompanyid ;

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
  int companyid = 1;
//int companyid = Util.getIntValue(request.getParameter("companyid"));
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String subcompanyname = Util.fromScreen(request.getParameter("subcompanyname"),user.getLanguage());
String subcompanydesc = Util.fromScreen(request.getParameter("subcompanydesc"),user.getLanguage());
int supsubcomid=Util.getIntValue(request.getParameter("supsubcomid"),0);
String url=Util.null2String(request.getParameter("url"));
int showorder=Util.getIntValue(request.getParameter("showorder"),0);
String sURL="";
String subcompanycode = Util.fromScreen(request.getParameter("subcompanycode"),user.getLanguage());
if(operation.equals("addsubcompany")){
     char separator = Util.getSeparator() ;

	/*
	* 判断是否10级分部
	*/
	if(supsubcomid > 0){
		if(ifDeptLevelEquals10(supsubcomid)){
            sURL="HrmCompany_frm.jsp?gotopage=/hrm/company/HrmSubCompanyAdd.jsp&parments=companyid="+companyid+"_supsubcomid="+supsubcomid+"_msgid=56";
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            session.setAttribute("subcompanyname",subcompanyname);
            session.setAttribute("subcompanydesc",subcompanydesc);
            session.setAttribute("url",url);
            session.setAttribute("showorder",""+showorder);
            response.sendRedirect(sURL);
            //response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&message=1");
			return;
		}
	}

	String para = subcompanyname + separator + subcompanydesc + separator + companyid+ separator + supsubcomid+ separator + url+ separator + showorder;
	RecordSet.executeProc("HrmSubCompany_Insert",para);

	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
	RecordSet.executeSql("update HrmSubCompany set subcompanycode = '" + subcompanycode + "' where id = " + id);
	int flag=RecordSet.getFlag();
	//System.out.println(flag);
        if(flag==2){
            sURL="HrmCompany_frm.jsp?&gotopage=/hrm/company/HrmSubCompanyAdd.jsp&parments=companyid="+companyid+"_supsubcomid="+supsubcomid+"_msgid=40";
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            session.setAttribute("subcompanyname",subcompanyname);
            session.setAttribute("subcompanydesc",subcompanydesc);
            session.setAttribute("url",url);
            session.setAttribute("showorder",""+showorder);
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmSubCompanyAdd.jsp?msgid=40");
        return;
        }
        if(flag==3){
            sURL="HrmCompany_frm.jsp?&gotopage=/hrm/company/HrmSubCompanyAdd.jsp&parments=companyid="+companyid+"_supsubcomid="+supsubcomid+"_msgid=43";
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
		    session.setAttribute("subcompanyname",subcompanyname);
            session.setAttribute("subcompanydesc",subcompanydesc);
            session.setAttribute("url",url);
            session.setAttribute("showorder",""+showorder);
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmSubCompanyAdd.jsp?msgid=43");
        return;
        }

    //更新机构权限数据：新增加的分部默认继承上级分部的所有机构权限。
    para = String.valueOf(id) + separator + String.valueOf(supsubcomid);
	RecordSet.executeProc("HrmRoleSRT_AddByNewSc",para);

	//更新左侧菜单，新增的分部继承上级分部的左侧菜单
	String strWhere=" where resourcetype=2 and resourceid="+supsubcomid; 
	if(supsubcomid==0) strWhere=" where resourcetype=1  and resourceid=1 "; 
	String strSql="insert into leftmenuconfig (userid,infoid,visible,viewindex,resourceid,resourcetype,locked,lockedbyid,usecustomname,customname,customname_e)  select  distinct  userid,infoid,visible,viewindex,"+id+",2,locked,lockedbyid,usecustomname,customname,customname_e from leftmenuconfig "+strWhere;
	//System.out.println(strSql);
	RecordSet.executeSql(strSql);



	//更新顶部菜单，新增的分部继承上级分部的顶部菜单
	strWhere=" where resourcetype=2 and resourceid="+supsubcomid; 
	if(supsubcomid==0) strWhere=" where resourcetype=1  and resourceid=1 "; 
	strSql="insert into mainmenuconfig (userid,infoid,visible,viewindex,resourceid,resourcetype,locked,lockedbyid,usecustomname,customname,customname_e)  select  distinct  userid,infoid,visible,viewindex,"+id+",2,locked,lockedbyid,usecustomname,customname,customname_e from mainmenuconfig "+strWhere;
	//System.out.println(strSql);
	RecordSet.executeSql(strSql);

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(subcompanyname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmSubCompany_Insert,"+para);
      SysMaintenanceLog.setOperateItem("11");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	SubCompanyComInfo.removeCompanyCache();
     RecordSet.executeSql("update orgchartstate set needupdate=1");

     //add by wjy
    //同步RTX端的分部信息.
    OrganisationCom.addSubCompany(id);

     response.sendRedirect("HrmCompany_frm.jsp?subcomid="+id);
 }
else if(operation.equals("editsubcompany")){
	char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));

	/*
	* 判断是否10级分部
	*/
	if(supsubcomid > 0){
		if(ifDeptLevelEquals10(supsubcomid)){
            sURL="HrmCompany_frm.jsp?gotopage=/hrm/company/HrmSubCompanyEdit.jsp&parments=companyid="+companyid+"_supsubcomid="+supsubcomid+"_id="+id+"_msgid=56";
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            session.setAttribute("subcompanyname",subcompanyname);
            session.setAttribute("subcompanydesc",subcompanydesc);
            session.setAttribute("url",url);
            session.setAttribute("showorder",""+showorder);
            response.sendRedirect(sURL);
            //response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&message=1");
			return;
		}
	}

	String para = ""+id + separator + subcompanyname + separator + subcompanydesc + separator + companyid+ separator + supsubcomid+ separator + url+ separator + showorder;
	RecordSet.executeProc("HrmSubCompany_Update",para);
	int flag=RecordSet.getFlag();
	RecordSet.executeSql("update HrmSubCompany set subcompanycode = '" + subcompanycode + "' where id = " + id);

	if(flag==2){
		sURL="HrmCompany_frm.jsp?gotopage=/hrm/company/HrmSubCompanyEdit.jsp&parments=companyid="+companyid+"_supsubcomid="+supsubcomid+"_id="+id+"_msgid=40";
		//sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
		session.setAttribute("subcompanyname",subcompanyname);
		session.setAttribute("subcompanydesc",subcompanydesc);
		session.setAttribute("url",url);
		session.setAttribute("showorder",""+showorder);
		response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmSubCompanyEdit.jsp?id="+id+"&msgid=40");
        return;
	}
	if(flag==3){
		sURL="HrmCompany_frm.jsp?gotopage=/hrm/company/HrmSubCompanyEdit.jsp&parments=companyid="+companyid+"_supsubcomid="+supsubcomid+"_id="+id+"_msgid=43";
		//sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
		session.setAttribute("subcompanyname",subcompanyname);
		session.setAttribute("subcompanydesc",subcompanydesc);
		session.setAttribute("url",url);
		session.setAttribute("showorder",""+showorder);
		response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmSubCompanyEdit.jsp?id="+id+"&msgid=43");
        return;
	}

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(subcompanyname);
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("HrmSubCompany_Update,"+para);
	SysMaintenanceLog.setOperateItem("11");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	SubCompanyComInfo.removeCompanyCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");

    //add by wjy
    //同步RTX端的分部信息.
    OrganisationCom.editSubCompany(id);

	response.sendRedirect("HrmCompany_frm.jsp?subcomid="+id);
}else if(operation.equals("deletesubcompany")){
	char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	RecordSet.executeProc("HrmSubCompany_Delete",para);

    //更新分级管理数据至默认分部
    RecordSet.executeSql("select detachable,dftsubcomid from SystemSet");
    String detachable = "";
    String dftsubcomid = "";
    if(RecordSet.next()){
    	detachable = Util.null2String(RecordSet.getString("detachable"));
        dftsubcomid = Util.null2String(RecordSet.getString("dftsubcomid"));
    }
    if(detachable.equals("1")&&!dftsubcomid.equals("")&&!dftsubcomid.equals("0")){
        RecordSet.executeProc("SystemSet_DftSCUpdate",""+dftsubcomid);
    }

	//add by wjy
	//同步RTX端的分部信息.
	  RecordSet rs = new RecordSet();
     rs.executeSql("select count(id) from HrmDepartment where subcompanyid1 ="+id); 
     if(rs.next()){
          if(rs.getInt(1)>0){
             logger.info("subcompany delete fail");
          }else{
               OrganisationCom.deleteSubCompany(id);
          }
     }

	if(RecordSet.next()){
		if(RecordSet.getString(1).equals("20")){
            sURL="HrmCompany_frm.jsp?gotopage=/hrm/company/HrmSubCompanyEdit.jsp&parments=companyid="+companyid+"_supsubcomid="+supsubcomid+"_id="+id+"_msgid=20";
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            session.setAttribute("subcompanyname",subcompanyname);
            session.setAttribute("subcompanydesc",subcompanydesc);
            session.setAttribute("url",url);
            session.setAttribute("showorder",""+showorder);
            response.sendRedirect(sURL);
            //response.sendRedirect("HrmSubCompanyEdit.jsp?id="+id+"&msgid=20");
			return ;
		}
	}
	else {
	    SubCompanyComInfo.removeCompanyCache();
 	    response.sendRedirect("HrmCompany_frm.jsp");
		//return ;
	}


      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(subcompanyname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmSubCompany_Delete,"+para);
      SysMaintenanceLog.setOperateItem("11");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
    String sql="update hrmsubcompany set supsubcomid=0 where supsubcomid="+id;
    RecordSet.executeSql(sql);
	SubCompanyComInfo.removeCompanyCache();

    RecordSet.executeSql("update orgchartstate set needupdate=1");
	response.sendRedirect("HrmCompany_frm.jsp");
}
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">