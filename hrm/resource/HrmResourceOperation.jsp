    <%@ page language="java" contentType="text/html; charset=GBK" %>
    <%@ page import="java.security.*,weaver.general.Util,weaver.hrm.settings.RemindSettings,weaver.file.Prop,weaver.rtx.RTXConfig" %>
	<%@ page import="java.lang.reflect.*" %>
    <%@ page import="weaver.file.FileUpload" %>
    <%@ page import="java.util.*" %>
    <%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerVO" %>
    <%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerDAO" %>
    <%@ page import="weaver.workflow.msg.PoppupRemindInfoUtil"%>
    <%@ page import="weaver.conn.RecordSet"%>
   <%@ page import="weaver.conn.RecordSetTrans" %>
<%@page import="weaver.login.TokenUtil"%>
    <jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
    <%@ include file="/systeminfo/init.jsp" %>
	<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
	<jsp:useBean id="GCONST" class="weaver.general.GCONST" scope="page" />
    <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
	<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
	<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
	<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsdb2" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="RecordSetDB" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
    <jsp:useBean id="HrmDateCheck" class="weaver.hrm.tools.HrmDateCheck" scope="page" />
    <jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
    <jsp:useBean id="SalaryManager" class="weaver.hrm.finance.SalaryManager" scope="page" />
    <jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
    <jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
    <jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
    <jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
    <jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
    <jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
    <jsp:useBean id="LN" class="ln.LN" scope="page" />
    <jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
    <jsp:useBean id="WorkPlanShareBase" class="weaver.WorkPlan.WorkPlanShareBase" scope="page"/>
    <jsp:useBean id="VerifyPasswdCheck" class="weaver.login.VerifyPasswdCheck" scope="page" />
    <jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
    <%
      String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
	  String bbsLingUrl=BaseBean.getPropValue(GCONST.getConfigFile() , "ecologybbs.linkUrl");
      FileUpload fu = new FileUpload(request);
      char separator = Util.getSeparator() ;

      int userid = user.getUID();
      Calendar todaycal = Calendar.getInstance ();
      String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
      String userpara = ""+userid+separator+today;

      String operation = Util.null2String(fu.getParameter("operation"));
      String view=Util.null2String(fu.getParameter("view"));
      boolean isfromtab =  Util.null2String(fu.getParameter("isfromtab")).equals("true")?true:false;
      String para="";

      int isView = Util.getIntValue(fu.getParameter("isView"));

//update by fanggsh TD4233 begin
      HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
      String hrmResourceManagerId = Util.null2String(fu.getParameter("id")) ;
      HrmResourceManagerVO vo = dao.getHrmResourceManagerByID(hrmResourceManagerId);	  
//update by fanggsh TD4233 end

if(operation.equalsIgnoreCase("maindactylogram")){
	String id = Util.null2String(fu.getParameter("id")) ;
	String maindactylogram = Util.null2String(fu.getParameter("maindactylogram")) ;
	rs.executeSql("update HrmResource set dactylogram='"+maindactylogram+"' where id="+id);
	rs.executeSql("update HrmResourceManager set dactylogram='"+maindactylogram+"' where id="+id);
	String topage = Util.null2String(fu.getParameter("topage")) ;
	if(topage.equals(""))
		response.sendRedirect("HrmResourcePassword.jsp?id="+id);
	else
		response.sendRedirect(topage+"?id="+id);
	return;
}
if(operation.equalsIgnoreCase("assistantdactylogram")){
	String id = Util.null2String(fu.getParameter("id")) ;
	String assistantdactylogram = Util.null2String(fu.getParameter("assistantdactylogram")) ;
	rs.executeSql("update HrmResource set assistantdactylogram='"+assistantdactylogram+"' where id="+id);
	rs.executeSql("update HrmResourceManager set assistantdactylogram='"+assistantdactylogram+"' where id="+id);
	String topage = Util.null2String(fu.getParameter("topage")) ;
	if(topage.equals(""))
		response.sendRedirect("HrmResourcePassword.jsp?id="+id);
	else
		response.sendRedirect(topage+"?id="+id);
	return;
}

      if(operation.equalsIgnoreCase("changepassword")) {
        String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
        String id = Util.null2String(fu.getParameter("id")) ;
		String frompage = Util.null2String(fu.getParameter("frompage"));
		String RedirectFile = Util.null2String(request.getParameter("RedirectFile"));
        if("2".equals(logintype)||!id.equals(String.valueOf(userid))){
            response.sendRedirect("HrmResource.jsp?id="+id);
            return ;
        }

        int usertype = 0;
        if(logintype.equals("1")) usertype = 0;
        if(logintype.equals("2")) usertype = 1;
        PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,6,(logintype).equals("1") ? "0" : "1",-1);
    //	String id = ""+user.getUID() ;
    	
    	String passwordold= Util.getEncrypt(Util.fromScreen3(fu.getParameter("passwordold"),user.getLanguage()));
    	String passwordnew= Util.getEncrypt(Util.fromScreen3(fu.getParameter("passwordnew"),user.getLanguage()));
    	
    	/*String oldpassword1 = "";
    	String oldpassword2 = "";
    	String oldpassword3 = "";
    	rs.executeSql("select password ,oldpassword1,oldpassword2 from hrmresource where id = "+id);
    	if(rs.next()){
    		oldpassword1 = rs.getString(1);
    		oldpassword2 = rs.getString(2);
    		oldpassword3 = rs.getString(3);
    	}
    	if(passwordnew.equals(oldpassword1)||passwordnew.equals(oldpassword2)||passwordnew.equals(oldpassword3)){
    		response.sendRedirect("HrmResourcePassword.jsp?message=3&id="+id+"&frompage="+frompage);
    		return;
    	}*/
    	
    	String procedurepara = id+separator+passwordold+separator+passwordnew ;
    	rs.executeProc("HrmResource_UpdatePassword",procedurepara);

    	if (rs.next()){
			user.setPwd(passwordnew);
			session.setAttribute("weaver_user@bean", user);
    		//rs4.executeSql("update hrmresource set oldpassword1 = '"+oldpassword1+"',oldpassword2='"+oldpassword2+"' where id = "+id);
		if (!bbsLingUrl.equals("")) {
		try
		{
		 Class s=Class.forName("weaver.bbs.UserOAToBBS");
		if (s!=null) {
        Class partypes[] = new Class[2];
        partypes[0]=String.class;
        partypes[1] = String.class;
        Method  meh=s.getMethod("changBBSUser",partypes);
        
         
        Object arglist[] = new Object[2];
        arglist[0] = new String(user.getLastname());
        arglist[1] = new String(passwordnew);
          //Object retobj = meth.invoke(methobj, arglist);    
        meh.invoke(s.newInstance(), arglist);
	
		//  userbbs.changBBSUser(loginid,password);	  //同步BBS用户
		  }
          //weaver.bbs.UserOAToBBS userbbs=new weaver.bbs.UserOAToBBS();
		  //userbbs.changBBSUser(user.getLoginid(),passwordnew);	  //同步BBS用户
		}
		catch (Exception ee)
			{}
		     }
		}

        RTXConfig rtxConfig = new RTXConfig();
	    String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
	    if("ELINK".equals(RtxOrElinkType)){   //修改密码同步到ELINK中
			OrganisationCom.editUser(Integer.parseInt(id));
		}

    	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
            SysMaintenanceLog.setOperateItem("29");
            SysMaintenanceLog.setOperateUserid(user.getUID());
            SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResource_UpdatePassword,"+procedurepara);
    	SysMaintenanceLog.setSysLogInfo();
        
    	if(rs.getString(1).equals("2")){                   
		    response.sendRedirect("HrmResourcePassword.jsp?message=2&id="+id+"&frompage="+frompage+"&isfromtab="+isfromtab);
		}
        else if( id.equals("1") ){
			response.sendRedirect("HrmResourcePassword.jsp?message=1&id="+id);
		}
//update by fanggsh TD4233 begin
        else if(vo.getId()!=null&&!(vo.getId()).equals("")&&vo.getId().equals(String.valueOf(id))){
			response.sendRedirect("HrmResourcePassword.jsp?message=1&id="+id);
		}     
//update by fanggsh TD4233 end
    	else{
    		if(frompage.length()<=0){
			//response.sendRedirect("HrmResource.jsp?id="+id);
    		response.sendRedirect("HrmResourcePassword.jsp?isfromtab="+isfromtab+"&message=1&id="+id);
    		}else{
    			request.getSession().setAttribute("changepwd","y");
    			String gotourl = "";
    			if(RedirectFile.indexOf("templateId")>0){
    				gotourl = RedirectFile+"&gopage=/hrm/resource/HrmResourcePassword.jsp?isfromtab=false&frompage="+frompage;
    			}else{
    				gotourl = RedirectFile+"?gopage=/hrm/resource/HrmResourcePassword.jsp?isfromtab=false&frompage="+frompage;
    			}
    			response.sendRedirect(gotourl);
    		}
		}
    	return ;
      }

      if(operation.equalsIgnoreCase("delpic")) {
    	String id = Util.null2String(fu.getParameter("id")) ;
    	String oldresourceimageid= Util.null2String(fu.getParameter("oldresourceimage"));
    	String firstname = Util.fromScreen3(fu.getParameter("firstname"),user.getLanguage());
    	String lastname = Util.fromScreen3(fu.getParameter("lastname"),user.getLanguage());
    	rs.executeProc("HrmResource_UpdatePic",id+separator+oldresourceimageid);

    	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(firstname+" "+lastname);
            SysMaintenanceLog.setOperateItem("29");
            SysMaintenanceLog.setOperateUserid(user.getUID());
            SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResource_UpdatePic,"+id+separator+oldresourceimageid);
    	SysMaintenanceLog.setSysLogInfo();

    	if(view.equals("contactinfo")){
			response.sendRedirect("HrmResourceContactEdit.jsp?id="+id+"&isView="+isView);
		}else{
    		response.sendRedirect("HrmResourceBasicEdit.jsp?id="+id+"&isView="+isView);
		}
    	return ;
      }

	//新增基本信息xiao
    if(operation.equalsIgnoreCase("addresourcebasicinfo")){

      String id = Util.null2String(fu.getParameter("id"));
      String workcode = Util.fromScreen3(fu.getParameter("workcode"),user.getLanguage());
      String lastname = Util.fromScreen3(fu.getParameter("lastname"),user.getLanguage());
      String sex = Util.fromScreen3(fu.getParameter("sex"),user.getLanguage());
      String resourceimageid= Util.null2String(fu.uploadFiles("photoid"));
      String departmentid = Util.fromScreen3(fu.getParameter("departmentid"),user.getLanguage());
      String costcenterid = Util.fromScreen3(fu.getParameter("costcenterid"),user.getLanguage());
      String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle"),user.getLanguage());
      String joblevel = Util.fromScreen3(fu.getParameter("joblevel"),user.getLanguage());
      String jobactivitydesc = Util.fromScreen3(fu.getParameter("jobactivitydesc"),user.getLanguage());
      String managerid = Util.fromScreen3(fu.getParameter("managerid"),user.getLanguage());
      String assistantid = Util.fromScreen3(fu.getParameter("assistantid"),user.getLanguage());
      String status = Util.fromScreen3(fu.getParameter("status"),user.getLanguage());
      String locationid = Util.fromScreen3(fu.getParameter("locationid"),user.getLanguage());
      String workroom = Util.fromScreen3(fu.getParameter("workroom"),user.getLanguage());
      String telephone = Util.fromScreen3(fu.getParameter("telephone"),user.getLanguage());
      String mobile = Util.fromScreen3(fu.getParameter("mobile"),user.getLanguage());
      String mobilecall = Util.fromScreen3(fu.getParameter("mobilecall"),user.getLanguage());
      String fax = Util.fromScreen3(fu.getParameter("fax"),user.getLanguage());
      String jobcall = Util.fromScreen3(fu.getParameter("jobcall"),user.getLanguage());
	  String accounttype = Util.fromScreen3(fu.getParameter("accounttype"),user.getLanguage());
	  String systemlanguage = Util.null2String(fu.getParameter("systemlanguage"));
      if(systemlanguage.equals("")||systemlanguage.equals("0")) systemlanguage = "7";
      String belongto = Util.fromScreen3(fu.getParameter("belongto"),user.getLanguage());
      if(accounttype.equals("0")){
	      belongto="-1";
      }
      //Td9325,解决多账号次账号没有登陆Id在浏览框组织结构中无法显示的问题。
      boolean falg = false;
	  String loginid = "";
		if(accounttype.equals("1")){
			rs.executeSql("select loginid from HrmResource where id ="+belongto);
			if(rs.next()){
				loginid = rs.getString(1);
			}
			if(LN.CkHrmnum() >= 0){
	    		response.sendRedirect("HrmResourceAdd.jsp?ifinfo=y&isfromtab=true");
	    		return;
			}
			if(!loginid.equals("")){
				String maxidsql = "select max(id) as id from HrmResource where loginid like '"+loginid+"%'";
				rs.executeSql(maxidsql);
				if(rs.next()){
					loginid = loginid+(rs.getInt("id")+1);
					falg = true;
				}
			}
		}
      rs.executeProc("HrmResourceMaxId_Get","");
      rs.next();
      id = ""+rs.getInt(1);

      String sql = "select managerstr, seclevel from HrmResource where id = "+Util.getIntValue(managerid);
      rs.executeSql(sql);
      String managerstr = "";
	  String seclevel = "";
      while(rs.next()){
          managerstr += rs.getString("managerstr");
          managerstr =","+managerid+managerstr;
          managerstr=managerstr.endsWith(",")?managerstr:(managerstr+",");
		  seclevel = rs.getString("seclevel");
      }
      
      String subcmpanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{

			para = ""+id+separator+workcode+separator+lastname+separator+sex+separator+resourceimageid+separator+
             departmentid+separator+ costcenterid+separator+jobtitle+separator+joblevel+separator+jobactivitydesc+separator+
             managerid+separator+assistantid+separator+status+separator+locationid+separator+workroom+separator+telephone+
             separator+mobile+separator+mobilecall+separator+fax+separator+jobcall+separator+subcmpanyid1+separator+managerstr+separator+accounttype+separator+belongto+separator+systemlanguage;

			rst.executeProc("HrmResourceBasicInfo_Insert",para);
			rst.executeSql("update hrmresource set countryid=(select countryid from HrmLocations where id="+locationid+") where id="+id);
			if(falg){
				String logidsql = "update HrmResource set loginid = '"+loginid+"' where id = "+id;
				rst.executeSql(logidsql);
			}
			if(seclevel == null || "".equals(seclevel)){
				seclevel = "0";
			}
			String p_para = id + separator + departmentid + separator + subcmpanyid1 + separator + managerid + separator + seclevel + separator + managerstr + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0";

			//System.out.println(p_para);
			//rst.executeProc("HrmResourceShare", p_para);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}

      para = ""+id;
      for(int i = 0;i<5;i++){
        String datefield = Util.null2String(fu.getParameter("datefield"+i));
        String numberfield = ""+Util.getDoubleValue(fu.getParameter("numberfield"+i),0);
        String textfield = Util.null2String(fu.getParameter("textfield"+i));
        String tinyintfield = ""+Util.getIntValue(fu.getParameter("tinyintfield"+i),0);
        para += separator+datefield + separator+numberfield+separator+textfield+separator+tinyintfield;
      }
      rs.executeProc("HrmResourceDefine_Update",para);

      rs.executeProc("HrmResource_CreateInfo",""+id+separator+userpara+separator+userpara);

      // 改为只进行该人缓存信息的添加
      ResourceComInfo.addResourceInfoCache(id);

      SalaryManager.initResourceSalary(id);
    /*
      String sql = "select managerstr from HrmResource where id = "+Util.getIntValue(managerid);

      rs.executeSql(sql);
      String managerstr = "";
      while(rs.next()){
          managerstr += rs.getString("managerstr");
          managerstr +=   managerid + "," ;
      }
      para = ""+id+separator+ managerstr;

      rs.executeProc("HrmResource_UpdateManagerStr",para);

      //String subcmpanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
      para = ""+id+separator+subcmpanyid1;
      rs.executeProc("HrmResource_UpdateSubCom",para);
    */


      para = ""+id+separator+managerid+separator+departmentid+separator+subcmpanyid1+separator+"0"+separator+managerstr;
      rs.executeProc("HrmResource_Trigger_Insert",para);

      String sql_1=("insert into HrmInfoStatus (itemid,hrmid) values(1,"+id+")");
      rs.executeSql(sql_1);
      String sql_2=("insert into HrmInfoStatus (itemid,hrmid) values(2,"+id+")");
      rs.executeSql(sql_2);
      String sql_3=("insert into HrmInfoStatus (itemid,hrmid) values(3,"+id+")");
      rs.executeSql(sql_3);
    /*
    String sql_4=("insert into HrmInfoStatus (itemid,hrmid) values(4,"+id+")");
    rs.executeSql(sql_4);
    String sql_5=("insert into HrmInfoStatus (itemid,hrmid) values(5,"+id+")");
    rs.executeSql(sql_5);
    String sql_6=("insert into HrmInfoStatus (itemid,hrmid) values(6,"+id+")");
    rs.executeSql(sql_6);
    String sql_7=("insert into HrmInfoStatus (itemid,hrmid) values(7,"+id+")");
    rs.executeSql(sql_7);
    String sql_8=("insert into HrmInfoStatus (itemid,hrmid) values(8,"+id+")");
    rs.executeSql(sql_8);
    String sql_9=("insert into HrmInfoStatus (itemid,hrmid) values(9,"+id+")");
    rs.executeSql(sql_9);
    */
      String sql_10=("insert into HrmInfoStatus (itemid,hrmid) values(10,"+id+")");
      rs.executeSql(sql_10);

     String name = lastname;

    String CurrentUser = ""+user.getUID();
    String CurrentUserName = ""+user.getUsername();

    String SWFAccepter="";
    String SWFTitle="";
    String SWFRemark="";
    String SWFSubmiter="";
    String Subject="";
    Subject= SystemEnv.getHtmlLabelName(15670,user.getLanguage()) ;
    Subject+=":"+name;

    String thesql="select distinct hrmid from HrmInfoMaintenance where id<4 or id = 10";
    rs.executeSql(thesql);
    String members="";
    while(rs.next()){
		int hrmid_tmp = Util.getIntValue(rs.getString("hrmid"));//TD9392
		if(hrmid_tmp > 0 && user.getUID() != hrmid_tmp){
			members += ","+rs.getString("hrmid");
		}
    }
    if(!members.equals("")){
        members = members.substring(1);

        SWFAccepter=members;
        SWFTitle= SystemEnv.getHtmlLabelName(15670,user.getLanguage()) ;
        SWFTitle += ":"+name;
        SWFTitle += "-"+CurrentUserName;
        SWFTitle += "-"+today ;
        SWFRemark="<a href=/hrm/employee/EmployeeManage.jsp?hrmid="+id+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
        SWFSubmiter=CurrentUser;

        SysRemindWorkflow.setPrjSysRemind(SWFTitle,0,Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
    }

            SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(lastname);
            SysMaintenanceLog.setOperateItem("29");
            SysMaintenanceLog.setOperateUserid(user.getUID());
            SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("1");
    	SysMaintenanceLog.setOperateDesc("HrmResourceBasicInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();

      if(software.equals("KM") || software.equals("CRM")){
    	response.sendRedirect("HrmResource.jsp?id="+id);
      }else{
    	response.sendRedirect("HrmResourceAddTwo.jsp?id="+id);
      }
      return;
    }

    if(operation.equalsIgnoreCase("addresourcepersonalinfo")){
      String id = Util.null2String(fu.getParameter("id"));
      String birthday = Util.fromScreen3(fu.getParameter("birthday"),user.getLanguage());
      String folk = Util.fromScreen3(fu.getParameter("folk"),user.getLanguage()) ;	 /*民族*/
      String nativeplace = Util.fromScreen3(fu.getParameter("nativeplace"),user.getLanguage()) ;	/*籍贯*/
      String regresidentplace = Util.fromScreen3(fu.getParameter("regresidentplace"),user.getLanguage()) ;	/*户口所在地*/
      String maritalstatus = Util.fromScreen3(fu.getParameter("maritalstatus"),user.getLanguage());
      String policy = Util.fromScreen3(fu.getParameter("policy"),user.getLanguage()) ; /*政治面貌*/
      String bememberdate = Util.fromScreen3(fu.getParameter("bememberdate"),user.getLanguage()) ;	/*入团日期*/
      String bepartydate = Util.fromScreen3(fu.getParameter("bepartydate"),user.getLanguage()) ;	/*入党日期*/
      String islabourunion = Util.fromScreen3(fu.getParameter("islabourunion"),user.getLanguage()) ;
      String educationlevel = Util.fromScreen3(fu.getParameter("educationlevel"),user.getLanguage()) ;/*学历*/
      String degree = Util.fromScreen3(fu.getParameter("degree"),user.getLanguage()) ; /*学位*/
      String healthinfo = Util.fromScreen3(fu.getParameter("healthinfo"),user.getLanguage()) ;/*健康状况*/
      String height = Util.null2o(fu.getParameter("height")) ;/*身高*/
      String weight = Util.null2o(fu.getParameter("weight")) ;
      String residentplace = Util.fromScreen3(fu.getParameter("residentplace"),user.getLanguage()) ;	/*现居住地*/
      String homeaddress = Util.fromScreen3(fu.getParameter("homeaddress"),user.getLanguage()) ;
      String tempresidentnumber = Util.fromScreen3(fu.getParameter("tempresidentnumber"),user.getLanguage()) ;
      String certificatenum = Util.fromScreen3(fu.getParameter("certificatenum"),user.getLanguage()) ;/*证件号码*/
      certificatenum=certificatenum.trim();
      String tempcertificatenum=certificatenum;
        int msg=0;
        if(!certificatenum.equals("")){
            rs.executeSql("select id from HrmResource where id<>"+id+" and certificatenum='"+certificatenum+"'");
            if(rs.next()){
                msg=1;
				rs.executeSql("select certificatenum from HrmResource where id="+id);
				if(rs.next()){
					tempcertificatenum=Util.null2String(rs.getString("certificatenum"));
				}
            }            
        }
      para = ""+id+	separator+birthday+separator+folk+separator+nativeplace+separator+regresidentplace+separator+
             maritalstatus+	separator+policy+separator+bememberdate+separator+bepartydate+separator+islabourunion+
             separator+educationlevel+separator+degree+separator+healthinfo+separator+height+separator+weight+
             separator+residentplace+separator+homeaddress+separator+tempresidentnumber+separator+tempcertificatenum;

      rs.executeProc("HrmResourcePersonalInfo_Insert",para);
      rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);

      int rownum = Util.getIntValue(fu.getParameter("rownum"),user.getLanguage()) ;
      for(int i = 0;i<rownum;i++){
        String member = Util.fromScreen3(fu.getParameter("member_"+i),user.getLanguage());
        String title = Util.fromScreen3(fu.getParameter("title_"+i),user.getLanguage());
        String company = Util.fromScreen3(fu.getParameter("company_"+i),user.getLanguage());
        String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle_"+i),user.getLanguage());
        String address = Util.fromScreen3(fu.getParameter("address_"+i),user.getLanguage());
        String info = member+title+company+jobtitle+address;
        if(!(info.trim().equals(""))){
        para = ""+id+separator+member+separator+title+separator+company+separator+jobtitle+separator+address;
        rs.executeProc("HrmFamilyInfo_Insert",para);
        }
      }

            SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
            SysMaintenanceLog.setOperateItem("29");
            SysMaintenanceLog.setOperateUserid(user.getUID());
            SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("1");
    	SysMaintenanceLog.setOperateDesc("HrmResourcePersonalInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();

        //处理自定义字段 add by wjy
        CustomFieldTreeManager.editCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
        CustomFieldTreeManager.editMutiCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));

      if(msg==1)
            response.sendRedirect("HrmResourcePersonalEdit.jsp?id="+id+"&isView="+isView+"&msg=1&iscreate=1&certificatenum="+certificatenum);
      else
            response.sendRedirect("HrmResourceAddThree.jsp?id="+id);
      return;
    }

    if(operation.equalsIgnoreCase("addresourceworkinfo")){
      String id = Util.null2String(fu.getParameter("id"));
      String usekind = Util.fromScreen3(fu.getParameter("usekind"),user.getLanguage()) ;
      String startdate = Util.fromScreen3(fu.getParameter("startdate"),user.getLanguage()) ;
      String probationenddate = Util.fromScreen3(fu.getParameter("probationenddate"),user.getLanguage()) ;
      String enddate = Util.fromScreen3(fu.getParameter("enddate"),user.getLanguage()) ;

      para = ""+id+	separator+usekind+separator+startdate+separator+probationenddate+separator+ enddate;
      rs.executeProc("HrmResourceWorkInfo_Insert",para);
      rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);

      para=""+id+separator+"0";
      //rs.executeProc("DocUserCategory_InsertByUser",para);

      int edurownum = Util.getIntValue(fu.getParameter("edurownum"),0);
      for(int i = 0;i<edurownum;i++){
        String school = Util.fromScreen3(fu.getParameter("school_"+i),user.getLanguage()) ;
        String speciality = Util.fromScreen3(fu.getParameter("speciality_"+i),user.getLanguage()) ;
        String edustartdate = Util.fromScreen3(fu.getParameter("edustartdate_"+i),user.getLanguage()) ;
        String eduenddate = Util.fromScreen3(fu.getParameter("eduenddate_"+i),user.getLanguage()) ;
        String educationlevel = Util.fromScreen3(fu.getParameter("educationlevel_"+i),user.getLanguage()) ;
        String studydesc = Util.fromScreen3(fu.getParameter("studydesc_"+i),user.getLanguage()) ;

        String info = school+speciality+edustartdate+eduenddate+educationlevel+studydesc;
        if(!info.trim().equals("")){
        para = ""+id+separator+edustartdate+separator+eduenddate+separator+school+separator+speciality+
        	    separator+educationlevel+separator+studydesc;
        rs.executeProc("HrmEducationInfo_Insert",para);
        }
      }

      int lanrownum = Util.getIntValue(fu.getParameter("lanrownum"),0);
      for(int i = 0;i<lanrownum;i++){
        String language = Util.fromScreen3(fu.getParameter("language_"+i),user.getLanguage()) ;
        String level = Util.fromScreen3(fu.getParameter("level_"+i),user.getLanguage()) ;
        String memo = Util.fromScreen3(fu.getParameter("memo_"+i),user.getLanguage()) ;
    	String info = language+memo;
    	if(!info.trim().equals("")){
        para = ""+id+separator+language+separator+level+separator+memo;
        rs.executeProc("HrmLanguageAbility_Insert",para);
    	}
      }

      int workrownum = Util.getIntValue(fu.getParameter("workrownum"),0);
      for(int i = 0;i<workrownum;i++){
        String company = Util.fromScreen3(fu.getParameter("company_"+i),user.getLanguage()) ;
        String workstartdate = Util.fromScreen3(fu.getParameter("workstartdate_"+i),user.getLanguage()) ;
        String workenddate = Util.fromScreen3(fu.getParameter("workenddate_"+i),user.getLanguage()) ;
        String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle_"+i),user.getLanguage()) ;
        String workdesc = Util.fromScreen3(fu.getParameter("workdesc_"+i),user.getLanguage()) ;
        String leavereason = Util.fromScreen3(fu.getParameter("leavereason_"+i),user.getLanguage()) ;

        String info = company+workstartdate+workenddate+jobtitle+workdesc+leavereason;
        if(!info.trim().equals("")){
        para = ""+id+separator+workstartdate+separator+workenddate+separator+company+separator+jobtitle+
        	    separator+workdesc+separator+leavereason;
        rs.executeProc("HrmWorkResume_Insert",para);
        }
      }

      int trainrownum = Util.getIntValue(fu.getParameter("trainrownum"),0);
      for(int i = 0;i<workrownum;i++){
        String trainname = Util.fromScreen3(fu.getParameter("trainname_"+i),user.getLanguage()) ;
        String trainstartdate = Util.fromScreen3(fu.getParameter("trainstartdate_"+i),user.getLanguage()) ;
        String trainenddate = Util.fromScreen3(fu.getParameter("trainenddate_"+i),user.getLanguage()) ;
        String trainresource = Util.fromScreen3(fu.getParameter("trainresource_"+i),user.getLanguage()) ;
        String trainmemo = Util.fromScreen3(fu.getParameter("trainmemo_"+i),user.getLanguage()) ;

        String info = trainname+trainstartdate+trainenddate+trainresource+trainmemo;
        if(!info.trim().equals("")){
        para = ""+id+separator+trainname+separator+trainresource+separator+trainstartdate+separator+trainenddate+
        	    separator+trainmemo;

        rs.executeProc("HrmTrainBeforeWork_Insert",para);
        }
      }

      int rewardrownum = Util.getIntValue(fu.getParameter("rewardrownum"),0);
      for(int i = 0;i<rewardrownum;i++){
        String rewardname = Util.fromScreen3(fu.getParameter("rewardname_"+i),user.getLanguage()) ;
        String rewarddate = Util.fromScreen3(fu.getParameter("rewarddate_"+i),user.getLanguage()) ;
        String rewardmemo = Util.fromScreen3(fu.getParameter("rewardmemo_"+i),user.getLanguage()) ;
        String info = rewardname+rewarddate+rewardmemo;
        if(!info.trim().equals("")){
        para = ""+id+separator+rewardname+separator+rewarddate+separator+rewardmemo;

        rs.executeProc("HrmRewardBeforeWork_Insert",para);
        }
      }

      int cerrownum = Util.getIntValue(fu.getParameter("cerrownum"),0);

      for(int i = 0;i<cerrownum;i++){
        String cername = Util.fromScreen3(fu.getParameter("cername_"+i),user.getLanguage()) ;
        String cerstartdate = Util.fromScreen3(fu.getParameter("cerstartdate_"+i),user.getLanguage()) ;
        String cerenddate = Util.fromScreen3(fu.getParameter("cerenddate_"+i),user.getLanguage()) ;
        String cerresource = Util.fromScreen3(fu.getParameter("cerresource_"+i),user.getLanguage()) ;

        String info = cername+cerstartdate+cerenddate+cerresource;
        if(!info.trim().equals("")){
        para = ""+id+separator+cerstartdate +separator+cerenddate +separator+cername+separator+cerresource;

        rs.executeProc("HrmCertification_Insert",para);
        }
      }


    // 工作信息不需要清理缓存 ResourceComInfo.removeResourceCache();

        //处理自定义字段 add by wjy
        CustomFieldTreeManager.editCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
        CustomFieldTreeManager.editMutiCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));


        SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("1");
    	SysMaintenanceLog.setOperateDesc("HrmResourceWorkInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();
        String isNewAgain = Util.fromScreen3(fu.getParameter("isNewAgain"),user.getLanguage()) ;
        if(isNewAgain.equals("1")){
            String deptid=ResourceComInfo.getDepartmentID(id);
            response.sendRedirect("/hrm/resource/HrmResourceAdd.jsp?departmentid="+deptid);
            return ;
        }
        response.sendRedirect("/hrm/resource/HrmResource.jsp?id="+id);
        return;
    }

    if(operation.equalsIgnoreCase("addresourcefinanceinfo")){
        String id = Util.null2String(fu.getParameter("id"));

        String bankid1 = Util.null2String(fu.getParameter("bankid1"));
        String accountid1 = Util.null2String(fu.getParameter("accountid1"));
        String accumfundaccount = Util.null2String(fu.getParameter("accumfundaccount"));

        para = ""+id+	separator+bankid1+separator+accountid1+separator+accumfundaccount;
        rs.executeProc("HrmResourceFinanceInfo_Insert",para);
        rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);
        rs.executeProc("HrmInfoStatus_UpdateFinance",""+id);

        rs.executeProc("HrmInfoStatus_UpdateFinance",""+id);
        // 财务信息不需要清理人力资源缓存 ResourceComInfo.removeResourceCache();

        SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("1");
    	SysMaintenanceLog.setOperateDesc("HrmResourceFinanceInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();

        response.sendRedirect("/hrm/resource/HrmResourceFinanceView.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView);
        return;
    }

//增加系统信息xiao
    if(operation.equalsIgnoreCase("addresourcesysteminfo")){
      String id = Util.null2String(fu.getParameter("id"));

        String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户  
        boolean iss = ResourceComInfo.isSysInfoView(userid,id);
        int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
        int operatelevel=0;
        if(detachable==1){
            String deptid=ResourceComInfo.getDepartmentID(id);
            String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ; 
			if(subcompanyid==null||"".equals(subcompanyid)){
				rs.executeSql("select Subcompanyid1 from hrmresource where id = "+id);
				if(rs.next()) subcompanyid = Util.null2String(rs.getString("Subcompanyid1"));
			}
			//if(subcompanyid!=null&&!"".equals(subcompanyid))
			operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ResourcesInformationSystem:All",Integer.parseInt(subcompanyid));
        }else{
            if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All", user))
                operatelevel=2;
        }
        if("2".equals(logintype)||!(iss || operatelevel>0)){  
           rs.writeLog("illegal attack user"); response.sendRedirect("/hrm/resource/HrmResourceSystemView.jsp?id="+id+"&isView="+isView);
            return ;
        }

      String loginid = Util.null2String(fu.getParameter("loginid"));
      int passwordlock = Util.getIntValue(Util.null2String(fu.getParameter("passwordlock")),0);
      String account = Util.null2String(fu.getParameter("account"));

      String enc_account="";
      if(!account.equals(""))
      enc_account=Util.getEncrypt(account);
      String password = Util.fromScreen3(fu.getParameter("password"),user.getLanguage());
      if(!password.equals("qwertyuiop"))  password = Util.getEncrypt(password);
      else password = "0" ;
      String systemlanguage = Util.null2String(fu.getParameter("systemlanguage"));
      if(systemlanguage.equals("")||systemlanguage.equals("0")) systemlanguage = "7";

      int seclevel = Util.getIntValue(fu.getParameter("seclevel"),0);
      String email = Util.null2String(fu.getParameter("email"));
      String needdynapass= String.valueOf(Util.null2String(fu.getParameter("needdynapass"))); 
	  String passwordstate= String.valueOf(Util.null2String(fu.getParameter("passwordstate"))); 	
      //int passwordstate = Util.getIntValue(fu.getParameter("passwordstate"),1);
	  //System.out.println(passwordstate.equals("0")||passwordstate.equals("2"));
	  if(passwordstate.equals("0")||passwordstate.equals("2")){
	        needdynapass = "1";
	  }else{
	        needdynapass="0";  
	  }
      //if(!needdynapass.equals("1"))
    	  
      //TD20803
      rs.executeSql("update HrmResource set needdynapass="+needdynapass+" where id="+id);  

		//Start 手机接口功能 by alan
		rs.executeSql("DELETE FROM workflow_mgmsusers WHERE userid="+id);
		if(!Util.null2String(request.getParameter("isMgmsUser")).equals("")){
			rs.executeSql("INSERT INTO workflow_mgmsusers(userid) VALUES ("+id+")");
		}	
		//End 手机接口功能 by alan
	  	
      //xiaofeng
      String needusb= Util.null2String(fu.getParameter("needusb"));
      if(!needusb.equals("1"))
      needusb="0";
      String old_needusb= Util.null2String(fu.getParameter("old_needed"));
      if(!old_needusb.equals("1"))
      old_needusb="0";
      String serial= Util.null2String(fu.getParameter("serial"));
	  String username = Util.null2String(fu.getParameter("username"));

	  RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
	  String usbType = settings.getUsbType();
	  String userUsbType=Util.null2String(fu.getParameter("userUsbType"));
	  String tokenkey=Util.null2String(fu.getParameter("tokenKey"));
	  if(loginid.equals("")&&needusb.equals("0")&&!userUsbType.equals("2")){
			loginid=account;
		  }
	  if("".equals(account)||(needusb.equals("1") && userUsbType.equals("2"))){
		  account = username;
	  }
	  //System.out.println("loginid2 = " + loginid);
      if((needusb.equals("1")&&old_needusb.equals("1")&&serial.equals(""))||(!needusb.equals("1")&&!old_needusb.equals("1"))) serial="0"; //如果该用户的序列号不做变更

      String oldLoginid="";
      if("".equals(loginid)&&mode.equals("ldap")){
    	  loginid=account;
      }
      para = ""+id+	separator+loginid+separator+password+separator+systemlanguage+separator+seclevel+separator+email+separator+needusb+separator+serial+separator+account+separator+enc_account+separator+needdynapass+separator+passwordstate;
      //System.out.println("para = " + para);
      ResourceComInfo.setTofirstRow();
      while(!account.equals("")&&ResourceComInfo.next()){
          if(ResourceComInfo.getAccount().equals(account)&&!ResourceComInfo.getResourceid().equals(id)){
              response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=1");
             return ;
          }
      }
//      HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
      if(!loginid.equals("")&&dao.ifHaveSameLoginId(loginid,id)){
          response.sendRedirect("HrmResourceSystemEdit.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView+"&errmsg=1");
          return ;
      }else{

		rs.executeSql("select * from HrmResource where id = "+Util.getIntValue(id));
		String olddepartmentid = "";
		String oldmanagerid = "";
		String oldsubcompanyid1 = "";
		String oldseclevel = "";
		String oldmanagerstr = "";
		
		String lastname="";
		String oldTokenKey="";
		
		while(rs.next()){
		olddepartmentid = rs.getString("departmentid");
		oldmanagerid = rs.getString("managerid");
		oldsubcompanyid1 = rs.getString("subcompanyid1");
		oldseclevel = rs.getString("seclevel");
		oldmanagerstr = rs.getString("managerstr");
		lastname=rs.getString("lastname");
		
		oldLoginid = rs.getString("loginid");
		oldTokenKey = rs.getString("tokenKey");
		}
		
		String falgtmp = "1";//"1"表示修改,"0"表示新增
		if("".equals(oldLoginid) && !"".equals(loginid)) {  //使用登陆名的情况下，将会在Rtx中新增一用户
			falgtmp = "0";
			if(!loginid.equals(oldLoginid)) {//修改用户名的情况下新添加用户
				OrganisationCom.deleteUser2(oldLoginid);
			}
		}

		//修改用户名的情况下Rtx中去除这一用户用户
		if(!"".equals(oldLoginid) && !"".equals(loginid) && !oldLoginid.equals(loginid)) {
			OrganisationCom.deleteUser2(oldLoginid);
		}

		boolean ret = false;
		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{
			ret=rst.executeProc("HrmResourceSystemInfo_Insert",para);
			
			//保存指定的usbType和tokenkey
			if(needusb.equals("1")){
				rst.execute("update hrmresource set userUsbType="+userUsbType+",tokenkey='"+tokenkey+"' where id="+id);
			}
			if(user.getLoginid().equals(loginid)){
				String languid = String.valueOf(systemlanguage); 
				Cookie syslanid = new Cookie("Systemlanguid",languid);
				syslanid.setMaxAge(-1);
				syslanid.setPath("/");
				response.addCookie(syslanid);
			}
		
		 if (!password.equals("0")) {
				  if (!bbsLingUrl.equals("")) {
				  
				try
				{
				Class s=Class.forName("weaver.bbs.UserOAToBBS");
				
				if (s!=null) {
				Class partypes[] = new Class[2];
				partypes[0]=String.class;
				partypes[1] = String.class;
				Method  meh=s.getMethod("changBBSUser",partypes);
				
				 
				Object arglist[] = new Object[2];
				arglist[0] = new String(lastname);
				arglist[1] = new String(password);
				  //Object retobj = meth.invoke(methobj, arglist);    
				meh.invoke(s.newInstance(), arglist);
			
				//  userbbs.changBBSUser(loginid,password);	  //同步BBS用户
				  }
					  }
					  catch (Exception e)
					  {}
				  }
			  }


			String p_para = id + separator + olddepartmentid + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + seclevel + separator + oldmanagerstr + separator + olddepartmentid + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + oldseclevel + separator + oldmanagerstr + separator + falgtmp;

			//System.out.println(p_para);
			rst.executeProc("HrmResourceShare", p_para);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}
		VerifyPasswdCheck.unlockOrLockPassword(id,passwordlock);
      if(ret){
          if(needdynapass.equals("1")){
            rs.executeSql("select id from hrmpassword where id='"+id+"'") ;
              if(rs.next()) ;
              else{                 
              rs.executeSql("insert into hrmpassword(id,loginid) values("+id+",'"+loginid+"')") ;
              }
          }

      }else{

      }
      }
      //db2
      //rsdb2.executeProc("Tri_UMMInfo_ByHrmResourceManager",""+id);
      if (RecordSetDB.getDBType().equals("db2")){
        rsdb2.executeProc("Tri_UMMInfo_ByHrmResource",""+id); //主菜单

        String departmentid=ResourceComInfo.getDepartmentID(id);

        //System.out.println(""+id+separator+loginid+separator+departmentid+separator+seclevel);
        //rsdb2.executeProc("Tri_U_workflow_createlist_1",""+id+separator+loginid+separator+departmentid+separator+seclevel); //工作流菜单
        /*

        CREATE procedure Tri_U_W_createl
        (
        in id int,
        in loginid varchar(60),
        in departmentid int ,
        in seclevel int
        )*/


		//文档菜单
		/*
		CREATE procedure Tri_U_HrmresourceShare_ini
		(
		in id integer ,
		in departmentid integer,
		in olddepartmentid integer,
		in subcompanyid1 integer,
		in seclevel integer,
		in oldseclevel integer,
		in managerstr varchar(200)
		)
		*/
		String oldSeclevel =ResourceComInfo.getSeclevel(id);
		String managerid=ResourceComInfo.getManagerID(id);

		String sql = "select managerstr from HrmResource where id = "+Util.getIntValue(managerid);
		rs.executeSql(sql);
		String managerstr = "";
		while(rs.next()){
		managerstr += rs.getString("managerstr");
		managerstr +=   managerid + "," ;
		};

	//rsdb2.executeProc("Tri_U_HrmresourceShare_ini",""+id+separator+departmentid+separator+departmentid+DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(id))+separator+seclevel+separator+oldSeclevel+separator+managerstr);




      }


      rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);
      rs.executeProc("HrmInfoStatus_UpdateSystem",""+id);

      para = ""+id+	separator+loginid+separator+"1";
      rs.executeProc("Ycuser_Insert",para);

      para = ""+seclevel+separator+ResourceComInfo.getDepartmentID(id)+separator+DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(id))+separator+id;
      rs.executeProc("MailShare_InsertByUser",para);
      //log usb setting
      if(!old_needusb.equals("1")&&needusb.equals("1")){
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
      SysMaintenanceLog.setOperateItem("89");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setOperateType("7");
      SysMaintenanceLog.setOperateDesc("HrmResourceSystemInfo_USB");
      SysMaintenanceLog.setSysLogInfo();
      }
      if(old_needusb.equals("1")&&!needusb.equals("1")){
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
      SysMaintenanceLog.setOperateItem("89");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setOperateType("8");
      SysMaintenanceLog.setOperateDesc("HrmResourceSystemInfo_USB");
      SysMaintenanceLog.setSysLogInfo();
      }
      //add by wjy
      //同步RTX端的用户信息.
      boolean isAdd = false;
      OrganisationCom.checkUser(Integer.parseInt(id));
      if(("".equals(oldLoginid) && !"".equals(loginid))||(!loginid.equals(oldLoginid)&&!"".equals(loginid))) {  //使用登陆名的情况下，将会在Rtx中新增一用户
			if(!loginid.equals(oldLoginid)) {//修改用户名的情况下新添加用户
				OrganisationCom.addUser(Util.getIntValue(id));
				isAdd=true;
			}

		} else if(!"".equals(oldLoginid) && "".equals(loginid)) {  //去除登陆名的情况下，将会在Rtx中去除这一用户
			OrganisationCom.deleteUser2(oldLoginid);
		}
      if(!isAdd)
      {
      	OrganisationCom.editUser(Integer.parseInt(id));
      }
	// 改为自进行修正
      ResourceComInfo.updateResourceInfoCache(id);

      PluginUserCheck.clearPluginUserCache("messager");

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
      SysMaintenanceLog.setOperateItem("29");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmResourceSystemInfo_Insert");
      SysMaintenanceLog.setSysLogInfo();






      response.sendRedirect("/hrm/resource/HrmResourceSystemView.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView);
      return;
    }

	//修改基本信息xiao
    if(operation.equalsIgnoreCase("editbasicinfo")){
    	
        String id = Util.null2String(fu.getParameter("id"));
        String workcode = Util.fromScreen3(fu.getParameter("workcode"),user.getLanguage());
        String lastname = Util.fromScreen3(fu.getParameter("lastname"),user.getLanguage());
        String sex = Util.fromScreen3(fu.getParameter("sex"),user.getLanguage());

        String resourceimageid= Util.null2String(fu.uploadFiles("photoid"));
        String oldresourceimageid= Util.null2String(fu.getParameter("oldresourceimage"));
        if(resourceimageid.equals("")) resourceimageid=oldresourceimageid ;

        String departmentid = Util.fromScreen3(fu.getParameter("departmentid"),user.getLanguage());
        String costcenterid = Util.fromScreen3(fu.getParameter("costcenterid"),user.getLanguage());
        String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle"),user.getLanguage());
        String joblevel = Util.fromScreen3(fu.getParameter("joblevel"),user.getLanguage());
        String jobactivitydesc = Util.fromScreen3(fu.getParameter("jobactivitydesc"),user.getLanguage());
        String managerid = Util.fromScreen3(fu.getParameter("managerid"),user.getLanguage());
        String assistantid = Util.fromScreen3(fu.getParameter("assistantid"),user.getLanguage());
        String status = Util.fromScreen3(fu.getParameter("status"),user.getLanguage());
        String locationid = Util.fromScreen3(fu.getParameter("locationid"),user.getLanguage());
        String workroom = Util.fromScreen3(fu.getParameter("workroom"),user.getLanguage());
        String telephone = Util.fromScreen3(fu.getParameter("telephone"),user.getLanguage());
        String mobile = Util.fromScreen3(fu.getParameter("mobile"),user.getLanguage());
        String mobilecall = Util.fromScreen3(fu.getParameter("mobilecall"),user.getLanguage());
        String fax = Util.fromScreen3(fu.getParameter("fax"),user.getLanguage());
        String jobcall = Util.fromScreen3(fu.getParameter("jobcall"),user.getLanguage());
        String systemlanguage = Util.fromScreen3(fu.getParameter("systemlanguage"),user.getLanguage());
        if(systemlanguage.equals("")||systemlanguage.equals("0")){
         systemlanguage = "7";
        }
		String accounttype = Util.fromScreen3(fu.getParameter("accounttype"),user.getLanguage());
        String belongto = Util.fromScreen3(fu.getParameter("belongto"),user.getLanguage());
		if(accounttype.equals("0")){
		belongto="-1";
		}
		
		//Td9325,解决多账号次账号没有登陆Id在浏览框组织结构中无法显示的问题。
	    boolean falg = false;
		String loginid = "";
		rs3.executeSql("select * from HrmResource where id ="+id);
		if(rs3.next()){
					loginid = rs3.getString("loginid");
				}
		if(accounttype.equals("1") && loginid.equalsIgnoreCase("")){
				rs.executeSql("select loginid from HrmResource where id ="+belongto);
				if(rs.next()){
					loginid = rs.getString(1);
				}
				if(LN.CkHrmnum() >= 0){
		    		response.sendRedirect("HrmResourceBasicEdit.jsp?id="+id+"&ifinfo=y&isfromtab=true");
		    		return;
				}
				if(!loginid.equals("")){
					//String maxidsql = "select max(id) as id from HrmResource where loginid like '"+loginid+"%'";
					//rs.executeSql(maxidsql);
					//if(rs.next()){
						loginid = loginid+(id + 1);
						falg = true;
					//}
				}
		}	
		String sql = "select * from HrmResource where id = "+Util.getIntValue(id);
		rs.executeSql(sql);
		String olddepartmentid = "";
		String oldmanagerid = "";
		String oldsubcompanyid1 = "";
		String oldseclevel = "";
		String oldmanagerstr = "";
		while(rs.next()){
		olddepartmentid = rs.getString("departmentid");
		oldmanagerid = rs.getString("managerid");
		oldsubcompanyid1 = rs.getString("subcompanyid1");
		oldseclevel = rs.getString("seclevel");
		oldmanagerstr = rs.getString("managerstr");
		}

        para =""+id+separator+workcode+separator+lastname+separator+sex+separator+resourceimageid
          +separator+ departmentid+separator+ costcenterid+separator+jobtitle+separator+joblevel+separator+jobactivitydesc+separator+managerid+separator+assistantid+separator+status+separator+locationid+separator+workroom+separator+telephone+separator+mobile+separator+mobilecall+separator+fax+separator+jobcall+separator+systemlanguage+separator+accounttype+separator+belongto;

		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{

			rst.executeProc("HrmResourceBasicInfo_Update",para);
			rst.executeSql("update hrmresource set countryid=(select countryid from HrmLocations where id="+locationid+") where id="+id);
			if(falg){
				String logidsql = "update HrmResource set loginid = '"+loginid+"' where id = "+id;
				rst.executeSql(logidsql);
			}
			String p_para = id + separator + departmentid + separator + oldsubcompanyid1 + separator + managerid + separator + oldseclevel + separator + oldmanagerstr + separator + olddepartmentid + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + oldseclevel + separator + oldmanagerstr + separator + "1";

			//System.out.println(p_para);
			rst.executeProc("HrmResourceShare", p_para);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}

        rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);
        String managerstr = "";
        if(!id.equals(managerid)){
	        sql = "select managerstr from HrmResource where id = "+Util.getIntValue(managerid);
	        rs.executeSql(sql);
	        while(rs.next()){
	          managerstr = rs.getString("managerstr");
		      managerstr =","+managerid+managerstr; 
		      managerstr =managerstr.endsWith(",")?managerstr:(managerstr+",");
	        }
        }else{
        	managerstr =","+managerid+",";
        }
        
        
		rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{
			para = ""+id+separator+ managerstr;
			rst.executeProc("HrmResource_UpdateManagerStr",para);

			String p_para = id + separator + departmentid + separator + oldsubcompanyid1 + separator + managerid + separator + oldseclevel + separator + managerstr + separator + departmentid + separator + oldsubcompanyid1 + separator + managerid + separator + oldseclevel + separator + oldmanagerstr + separator + "1";

			//System.out.println(p_para);
			rst.executeProc("HrmResourceShare", p_para);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}

		String temOldmanagerstr=","+id +oldmanagerstr;
		temOldmanagerstr=temOldmanagerstr.endsWith(",")?temOldmanagerstr:(temOldmanagerstr+",");

        sql = "select id,departmentid,subcompanyid1,managerid,seclevel,managerstr from HrmResource where managerstr like '%"+temOldmanagerstr+ "'";
        rs.executeSql(sql);
        while(rs.next()){
			String nowmanagerstr = Util.null2String(rs.getString("managerstr"));
			String resourceid = rs.getString("id");
			//指定上级为自身的情况，不更新自身上级
			if(id.equals(resourceid))
				continue;
			//String nowmanagerstr2 = Util.StringReplaceOnce(nowmanagerstr,oldmanagerstr ,managerstr);
			String nowmanagerstr2="";
			int index=nowmanagerstr.lastIndexOf(oldmanagerstr);
			if(index!=-1){
				if(!"".equals(managerstr)){
				       nowmanagerstr2=nowmanagerstr.substring(0,index)+("".equals(oldmanagerstr)?managerstr.substring(1):managerstr);
				}   
				else{
				   nowmanagerstr2=nowmanagerstr.substring(0,index)+("".equals(oldmanagerstr)?"":",");
				} 
				
			}
			String nowdepartmentid = rs.getString("departmentid");
			String nowsubcompanyid1 = rs.getString("subcompanyid1");
			String nowmanagerid = rs.getString("managerid");
			String nowseclevel = rs.getString("seclevel");
			rst=new RecordSetTrans();
			rst.setAutoCommit(false);
			try{
				para = resourceid + separator + nowmanagerstr2;
				rst.executeProc("HrmResource_UpdateManagerStr",para);

				String p_para = resourceid + separator + nowdepartmentid + separator + nowsubcompanyid1 + separator + nowmanagerid + separator + nowseclevel + separator + nowmanagerstr2 + separator + nowdepartmentid + separator + nowsubcompanyid1 + separator + nowmanagerid + separator + nowseclevel + separator + nowmanagerstr + separator + "1";

				//System.out.println(p_para);
				rst.executeProc("HrmResourceShare", p_para);
				rst.commit();
			}catch(Exception e){
				rst.rollback();
				e.printStackTrace();
			}

        }

        String subcmpanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
        para = ""+id+separator+subcmpanyid1;
		rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{
			 rst.executeProc("HrmResource_UpdateSubCom",para);

			String p_para = id + separator + departmentid + separator + subcmpanyid1 + separator + managerid + separator + oldseclevel + separator + managerstr + separator + departmentid + separator + oldsubcompanyid1 + separator + managerid + separator + oldseclevel + separator + managerstr + separator + "1";

			//System.out.println(p_para);
			rst.executeProc("HrmResourceShare", p_para);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}
		
		if(!oldmanagerid.equals(managerid)){//修改人力资源经理，对客户和日程共享重新计算
		    CrmShareBase.setShareForNewManager(id);
		    //WorkPlanShareBase.setShareForNewManager(id);
		}

        para = ""+id;
        for(int i = 0;i<5;i++){
        String datefield = Util.null2String(fu.getParameter("datefield"+i));
        String numberfield = ""+Util.getDoubleValue(fu.getParameter("numberfield"+i),0);
        String textfield = Util.null2String(fu.getParameter("textfield"+i));
        String tinyintfield = ""+Util.getIntValue(fu.getParameter("tinyintfield"+i),0);
        para += separator+datefield + separator+numberfield+separator+textfield+separator+tinyintfield;
        }
        rs.executeProc("HrmResourceDefine_Update",para);


    if (RecordSetDB.getDBType().equals("db2")){
        //db2 trigger
        int seclevel = Util.getIntValue(fu.getParameter("seclevel"),0);
        String nowmanagerstr = Util.null2String(rs.getString("managerstr"));
        //rs.executeProc("Tri_U_HrmresourceShare",""+id+separator+departmentid+separator+subcmpanyid1+separator+seclevel+separator+nowmanagerstr);
    }

        /*
        CREATE procedure Tri_U_HrmresourceShare
        (
        in id integer ,
        in departmentid integer,
        in subcompanyid1 integer,
        in seclevel integer,
        in managerstr varchar(200)
        )
        */
		String oldloginid = "";
		rs.executeSql("select loginid from HrmResource where id = "+id);
		if(rs.next())
		{
			oldloginid = Util.null2String(rs.getString("loginid"));
		}
        //add by wjy
        //同步RTX端的用户信息.
		boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在
        if(checkrtxuser){   //存在就编辑，不存在就新增
        	OrganisationCom.editUser(Integer.parseInt(id));//编辑
        } else {
			if(Integer.parseInt(status)<4&&!oldloginid.equals("")){  //如果这个人状态不是 0：试用1：正式2：临时3：试用延期，或者没有OA登录名,则不进行人员同步操作
        		OrganisationCom.addUser(Integer.parseInt(id));//新增
			}
        }

        // 改为自进行修正
        ResourceComInfo.updateResourceInfoCache(id);

        SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResourceBasicInfo_Update");
    	SysMaintenanceLog.setSysLogInfo();

        if(isView == 0){
            response.sendRedirect("HrmResourceBasicInfo.jsp?id="+id);
        }else{
        	//response.sendRedirect("HrmResource.jsp?id="+id);
        	response.sendRedirect("HrmResourceBase.jsp?id="+id);
            
        }
        return;
    }

    if(operation.equalsIgnoreCase("editcontactinfo")){

        String id = Util.null2String(fu.getParameter("id"));
        String locationid = Util.fromScreen3(fu.getParameter("locationid"),user.getLanguage());
        String workroom = Util.fromScreen3(fu.getParameter("workroom"),user.getLanguage());
        String telephone = Util.fromScreen3(fu.getParameter("telephone"),user.getLanguage());
        String mobile = Util.fromScreen3(fu.getParameter("mobile"),user.getLanguage());
        String mobilecall = Util.fromScreen3(fu.getParameter("mobilecall"),user.getLanguage());
        String fax = Util.fromScreen3(fu.getParameter("fax"),user.getLanguage());
        String systemlanguage = Util.fromScreen3(fu.getParameter("systemlanguage"),user.getLanguage());
		String resourceimageid= Util.null2String(fu.uploadFiles("photoid"));
		String oldresourceimageid= Util.null2String(fu.getParameter("oldresourceimage"));
		if(resourceimageid.equals("")) resourceimageid=oldresourceimageid ;
        if(systemlanguage.equals("")||systemlanguage.equals("0")){
         systemlanguage = "7";
        }
        String email = Util.fromScreen3(fu.getParameter("email"),user.getLanguage());

        para =""+id    +separator+locationid+separator+workroom  +separator+
            telephone+separator+ mobile   +separator+mobilecall+separator+
            fax+separator+systemlanguage+separator+email;
        rs.executeProc("HrmResourceContactInfo_Update",para);
		//added by zfh 
		//增加上传头像的功能
		String sql="update HrmResource set resourceimageid='"+resourceimageid+"' where id="+id;
		rs.execute(sql);

        //add by wjy
        //同步RTX端的用户信息.
        boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在
        if(checkrtxuser){   //存在就编辑，不存在就新增
        	OrganisationCom.editUser(Integer.parseInt(id));//编辑
        } else {
        	OrganisationCom.addUser(Integer.parseInt(id));//新增
        }
        
        // 改为自进行修正
        ResourceComInfo.updateResourceInfoCache(id);

      	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResourceContactInfo_Update");
    	SysMaintenanceLog.setSysLogInfo();

      if(isView == 0){
        response.sendRedirect("HrmResourceBasicInfo.jsp?id="+id);
      }else{
    	if(isfromtab){
    		response.sendRedirect("HrmResourceBase.jsp?id="+id);
    	}else{  
    		response.sendRedirect("HrmResourceBase.jsp?id="+id);
    	}
      }
      return;
    }

    if(operation.equalsIgnoreCase("editpersonalinfo")){
        String id = Util.null2String(fu.getParameter("id"));
        String birthday = Util.fromScreen3(fu.getParameter("birthday"),user.getLanguage());
        String folk = Util.fromScreen3(fu.getParameter("folk"),user.getLanguage()) ;	 /*民族*/
        String nativeplace = Util.fromScreen3(fu.getParameter("nativeplace"),user.getLanguage()) ;	/*籍贯*/
        String regresidentplace = Util.fromScreen3(fu.getParameter("regresidentplace"),user.getLanguage()) ;	/*户口所在地*/
        String maritalstatus = Util.fromScreen3(fu.getParameter("maritalstatus"),user.getLanguage());
        String policy = Util.fromScreen3(fu.getParameter("policy"),user.getLanguage()) ; /*政治面貌*/
        String bememberdate = Util.fromScreen3(fu.getParameter("bememberdate"),user.getLanguage()) ;	/*入团日期*/
        String bepartydate = Util.fromScreen3(fu.getParameter("bepartydate"),user.getLanguage()) ;	/*入党日期*/
        String islabourunion = Util.fromScreen3(fu.getParameter("islabouunion"),user.getLanguage()) ;
        String educationlevel = Util.fromScreen3(fu.getParameter("educationlevel"),user.getLanguage()) ;/*学历*/
        String degree = Util.fromScreen3(fu.getParameter("degree"),user.getLanguage()) ; /*学位*/
        String healthinfo = Util.fromScreen3(fu.getParameter("healthinfo"),user.getLanguage()) ;/*健康状况*/
        String height = Util.null2o(fu.getParameter("height")) ;/*身高*/
        String weight = Util.null2o(fu.getParameter("weight")) ;
        String residentplace = Util.fromScreen3(fu.getParameter("residentplace"),user.getLanguage()) ;	/*现居住地*/
        String homeaddress = Util.fromScreen3(fu.getParameter("homeaddress"),user.getLanguage()) ;
        String tempresidentnumber = Util.fromScreen3(fu.getParameter("tempresidentnumber"),user.getLanguage()) ;
        String certificatenum = Util.fromScreen3(fu.getParameter("certificatenum"),user.getLanguage()) ;/*证件号码*/
        int iscreate = Util.getIntValue(fu.getParameter("iscreate"),0);
        certificatenum=certificatenum.trim();
        String tempcertificatenum=certificatenum;
        int msg=0;
        if(!certificatenum.equals("")){
            rs.executeSql("select id from HrmResource where id<>"+id+" and certificatenum='"+certificatenum+"'");
            if(rs.next()){
                msg=1;
				rs.executeSql("select certificatenum from HrmResource where id="+id);
				if(rs.next()){
					tempcertificatenum=Util.null2String(rs.getString("certificatenum"));
				}
            }            
        }
        para = ""+id+	separator+birthday+separator+folk+separator+nativeplace+separator+regresidentplace+separator+
             maritalstatus+	separator+policy+separator+bememberdate+separator+bepartydate+separator+islabourunion+
             separator+educationlevel+separator+degree+separator+healthinfo+separator+height+separator+weight+
             separator+residentplace+separator+homeaddress+separator+tempresidentnumber+separator+tempcertificatenum;

        rs.executeProc("HrmResourcePersonalInfo_Insert",para);
        rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);

        int rownum = Util.getIntValue(fu.getParameter("rownum"),user.getLanguage()) ;
        rs.executeProc("HrmFamilyInfo_Delete",""+id);
        for(int i = 0;i<rownum;i++){
            String member = Util.fromScreen3(fu.getParameter("member_"+i),user.getLanguage());
            String title = Util.fromScreen3(fu.getParameter("title_"+i),user.getLanguage());
            String company = Util.fromScreen3(fu.getParameter("company_"+i),user.getLanguage());
            String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle_"+i),user.getLanguage());
            String address = Util.fromScreen3(fu.getParameter("address_"+i),user.getLanguage());
            String info = member+title+company+jobtitle+address;
            if(!info.trim().equals("")){
                para = ""+id+separator+member+separator+title+separator+company+separator+jobtitle+separator+address;

                rs.executeProc("HrmFamilyInfo_Insert",para);
            }
        }

        //处理自定义字段 add by wjy
        CustomFieldTreeManager.editCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
        CustomFieldTreeManager.editMutiCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));

        // 个人信息不需要清理人力资源缓存 ResourceComInfo.removeResourceCache();

      	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResourcePersonalInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();
        if(msg==1)
            response.sendRedirect("HrmResourcePersonalEdit.jsp?id="+id+"&isView="+isView+"&msg=1&iscreate="+iscreate+"&certificatenum="+certificatenum);
        else if(iscreate==1)
            response.sendRedirect("HrmResourceAddThree.jsp?id="+id);
        else
            response.sendRedirect("HrmResourcePersonalView.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView);
        return;
    }

    if(operation.equalsIgnoreCase("editwork")){

        String id = Util.null2String(fu.getParameter("id"));
		//System.out.println("id:"+id);
        String name = "";
        String sql = "select lastname from HrmResource where id ="+id;
        rs.executeSql(sql);
        while(rs.next()){
            name = rs.getString("lastname");
        }

        String usekind = Util.fromScreen3(fu.getParameter("usekind"),user.getLanguage()) ;
        String startdate = Util.fromScreen3(fu.getParameter("startdate"),user.getLanguage()) ;
        String probationenddate = Util.fromScreen3(fu.getParameter("probationenddate"),user.getLanguage()) ;
        String enddate = Util.fromScreen3(fu.getParameter("enddate"),user.getLanguage()) ;

        para = ""+id+	separator+usekind+separator+startdate+separator+probationenddate+separator+ enddate;
        rs.executeProc("HrmResourceWorkInfo_Insert",para);
        rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);
        
		String contracttypeid = "";
		String ishirecontract = "";
		String sqltype = "select * from HrmContract where ContractMan = "+id;
		rs.executeSql(sqltype);
		while(rs.next()){
				contracttypeid = rs.getString("contracttypeid");
				String ishirecontractsql = "select * from HrmContracttype where ishirecontract = 1 and id ="+contracttypeid;
				rs2.executeSql(ishirecontractsql);
				while(rs2.next()){
					  ishirecontract = rs2.getString("ishirecontract");	 
				if(ishirecontract.equals("1")){		
						para = ""+id+separator+contracttypeid+separator+startdate+separator+enddate+separator+ probationenddate;	
						rs.executeProc("HrmContract_UpdateByHrm",para);
						}
				}
		}
		
        sql = "delete from HrmLanguageAbility where resourceid = "+id;
        rs.executeSql(sql);
        int lanrownum = Util.getIntValue(fu.getParameter("lanrownum"),0);
        for(int i = 0;i<lanrownum;i++){
            String language = Util.fromScreen3(fu.getParameter("language_"+i),user.getLanguage()) ;
            String level = Util.fromScreen3(fu.getParameter("level_"+i),user.getLanguage()) ;
            String memo = Util.fromScreen3(fu.getParameter("memo_"+i),user.getLanguage()) ;
            String info = language+memo;
            if(!info.trim().equals("")){
                para = ""+id+separator+language+separator+level+separator+memo;
                rs.executeProc("HrmLanguageAbility_Insert",para);
            }
        }

        sql = "delete from HrmEducationInfo where resourceid = "+id;
        rs.executeSql(sql);
        int edurownum = Util.getIntValue(fu.getParameter("edurownum"),0);
        for(int i = 0;i<edurownum;i++){
            String school = Util.fromScreen3(fu.getParameter("school_"+i),user.getLanguage()) ;
            String speciality = Util.fromScreen3(fu.getParameter("speciality_"+i),user.getLanguage()) ;
            String edustartdate = Util.fromScreen3(fu.getParameter("edustartdate_"+i),user.getLanguage()) ;
            String eduenddate = Util.fromScreen3(fu.getParameter("eduenddate_"+i),user.getLanguage()) ;
            String educationlevel = Util.fromScreen3(fu.getParameter("educationlevel_"+i),user.getLanguage()) ;
            String studydesc = Util.fromScreen3(fu.getParameter("studydesc_"+i),user.getLanguage()) ;
            String info = school+speciality+edustartdate+eduenddate+studydesc;
            if(!info.trim().equals("")){
                para = ""+id+separator+edustartdate+separator+eduenddate+separator+school+separator+speciality+
                        separator+educationlevel+separator+studydesc;
                rs.executeProc("HrmEducationInfo_Insert",para);
            }
        }

        int workrownum = Util.getIntValue(fu.getParameter("workrownum"));
        sql = "delete from HrmWorkResume where resourceid = "+id;
        rs.executeSql(sql);
        for(int i = 0;i<workrownum;i++){
            String company = Util.fromScreen3(fu.getParameter("company_"+i),user.getLanguage()) ;
            String workstartdate = Util.fromScreen3(fu.getParameter("workstartdate_"+i),user.getLanguage()) ;
            String workenddate = Util.fromScreen3(fu.getParameter("workenddate_"+i),user.getLanguage()) ;
            String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle_"+i),user.getLanguage()) ;
            String workdesc = Util.fromScreen3(fu.getParameter("workdesc_"+i),user.getLanguage()) ;
            String leavereason = Util.fromScreen3(fu.getParameter("leavereason_"+i),user.getLanguage()) ;
            String info = company+workstartdate+workenddate+jobtitle+workdesc+leavereason;
            if(!info.trim().equals("")){
                para = ""+id+separator+workstartdate+separator+workenddate+separator+company+separator+jobtitle+
                        separator+workdesc+separator+leavereason;
                rs.executeProc("HrmWorkResume_Insert",para);
            }
        }

        int trainrownum = Util.getIntValue(fu.getParameter("trainrownum"),0);
        sql = "delete from HrmTrainBeforeWork where resourceid = "+id;
        rs.executeSql(sql);
        for(int i = 0;i<trainrownum;i++){
            String trainname = Util.fromScreen3(fu.getParameter("trainname_"+i),user.getLanguage()) ;
            String trainstartdate = Util.fromScreen3(fu.getParameter("trainstartdate_"+i),user.getLanguage()) ;
            String trainenddate = Util.fromScreen3(fu.getParameter("trainenddate_"+i),user.getLanguage()) ;
            String trainresource = Util.fromScreen3(fu.getParameter("trainresource_"+i),user.getLanguage()) ;
            String trainmemo = Util.fromScreen3(fu.getParameter("trainmemo_"+i),user.getLanguage()) ;
            String info = trainname+trainstartdate+trainenddate+trainresource+trainmemo;
            if(!info.trim().equals("")){
                para = ""+id+separator+trainname+separator+trainresource+separator+trainstartdate+separator+trainenddate+
                        separator+trainmemo;
                rs.executeProc("HrmTrainBeforeWork_Insert",para);
            }
        }

        int cerrownum = Util.getIntValue(fu.getParameter("cerrownum"),0);

        sql = "delete from HrmCertification where resourceid = "+id;
        rs.executeSql(sql);
        for(int i = 0;i<cerrownum;i++){
            String cername = Util.fromScreen3(fu.getParameter("cername_"+i),user.getLanguage()) ;
            String cerstartdate = Util.fromScreen3(fu.getParameter("cerstartdate_"+i),user.getLanguage()) ;
            String cerenddate = Util.fromScreen3(fu.getParameter("cerenddate_"+i),user.getLanguage()) ;
            String cerresource = Util.fromScreen3(fu.getParameter("cerresource_"+i),user.getLanguage()) ;

            String info = cername+cerstartdate+cerenddate+cerresource;
            if(!info.trim().equals("")){
                para = ""+id+separator+cerstartdate+separator+cerenddate +separator+cername+separator+cerresource;

                rs.executeProc("HrmCertification_Insert",para);
            }
        }

        int rewardrownum = Util.getIntValue(fu.getParameter("rewardrownum"),0);
        sql = "delete from HrmRewardBeforeWork where resourceid = "+id;
        rs.executeSql(sql);
        for(int i = 0;i<rewardrownum;i++){
            String rewardname = Util.fromScreen3(fu.getParameter("rewardname_"+i),user.getLanguage()) ;
            String rewarddate = Util.fromScreen3(fu.getParameter("rewarddate_"+i),user.getLanguage()) ;
            String rewardmemo = Util.fromScreen3(fu.getParameter("rewardmemo_"+i),user.getLanguage()) ;
            String info = rewardname+rewarddate+rewardmemo;
            if(!info.trim().equals("")){
                para = ""+id+separator+rewardname+separator+rewarddate+separator+rewardmemo;
                rs.executeProc("HrmRewardBeforeWork_Insert",para);
            }
        }

        // 工作信息不需要清理缓存 ResourceComInfo.removeResourceCache();

        //处理自定义字段 add by wjy
        CustomFieldTreeManager.editCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
        CustomFieldTreeManager.editMutiCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));

     	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResourceWorkInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();
		
        response.sendRedirect("HrmResourceWorkView.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView);
        return;
    }

    if(operation.equalsIgnoreCase("finish")) {
        String id = Util.null2String(fu.getParameter("id")) ;
        rs.executeProc("HrmInfoStatus_Finish",id);

        SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmInfoStatus_Finish");
    	SysMaintenanceLog.setSysLogInfo();

        response.sendRedirect("/hrm/employee/EmployeeManage.jsp?hrmid="+id);
        return;
    }

    if(operation.equalsIgnoreCase("info")) {
        String id = Util.null2String(fu.getParameter("id"));
        String probationenddate = Util.fromScreen3(fu.getParameter("probationenddate"),user.getLanguage()) ;
        String enddate = Util.fromScreen3(fu.getParameter("enddate"),user.getLanguage()) ;
        String name = ResourceComInfo.getResourcename(id);
        String infoman = HrmDateCheck.getHrmId(id);

        String accepter="";
        String title="";
        String remark="";
        String submiter="";
        String subject="";

        if(!HrmDateCheck.hasContract(id)){
          if(Util.dayDiff(today,enddate)==3){
              ArrayList al = Util.TokenizerString(infoman,",");
              for(int i = 0; i<al.size();i++){
                accepter = (String)al.get(i);
                subject= SystemEnv.getHtmlLabelName(15783,user.getLanguage()) ;
                subject += ":"+name;
                title = SystemEnv.getHtmlLabelName(15783,user.getLanguage());
                title += ":System Remind ";
    //          title += "-"+ResourceComInfo.getResourcename(accepter);
                title += "-"+name;
                title += "-"+today;
                remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
                submiter="0";
                SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
              }
            }
            if(Util.dayDiff(today,probationenddate)==3){
              ArrayList al = Util.TokenizerString(infoman,",");
              for(int i = 0; i<al.size();i++){
                accepter = (String)al.get(i);
                subject= SystemEnv.getHtmlLabelName(15784,user.getLanguage()) ;
                subject += ":"+name;
                title = SystemEnv.getHtmlLabelName(15784,user.getLanguage()) ;
                title += ":System Remind ";
    //          title += "-"+ResourceComInfo.getResourcename(accepter);
                title += "-"+name;
                title += "-"+today;
                remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
                submiter="0";
                SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
            }
        }
      }
      response.sendRedirect("/hrm/resource/HrmResource.jsp?id="+id);
    }

    if(operation.equalsIgnoreCase("delete")) {
        String id = Util.null2String(fu.getParameter("id"));
        String sql = "update HrmResource set status = 10 where id = "+id;
        rs.executeSql(sql);

        //add by wjy
        //同步RTX端的用户信息.
        //OrganisationCom.checkUser(Integer.parseInt(id));

        // 改为自进行修正
        ResourceComInfo.deleteResourceInfoCache(id);

        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setOperateType("3");
        SysMaintenanceLog.setOperateDesc("HrmResource_Delete");
        SysMaintenanceLog.setSysLogInfo();

        response.sendRedirect("/hrm/resource/HrmResource.jsp?id="+id);
    }

%>