<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.security.*,weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="weaver.conn.RecordSetTrans" %>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SalaryManager" class="weaver.hrm.finance.SalaryManager" scope="page" />

<%
FileUpload fu = new FileUpload(request);
char separator = Util.getSeparator() ;
int userid = user.getUID();
Calendar todaycal = Calendar.getInstance ();

String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
String userpara = ""+userid+separator+today;
String operation = Util.null2String(fu.getParameter("operation"));
String para="";

String id = Util.null2String(fu.getParameter("id"));

if(operation.equalsIgnoreCase("add")){
  String sql = "select lastname,sex from HrmCareerApply where id = "+id;
  rs.executeSql(sql);
  rs.next();
  String lastname = Util.null2String(rs.getString("lastname"));
  String sex = Util.null2String(rs.getString("sex"));

  String workcode = Util.fromScreen(fu.getParameter("workcode"),user.getLanguage());
  String resourceimageid= Util.null2String(fu.uploadFiles("photoid"));
  String departmentid = Util.fromScreen(fu.getParameter("departmentid"),user.getLanguage());

  String costcenterid = Util.fromScreen(fu.getParameter("costcenterid"),user.getLanguage());
  String jobtitle = Util.fromScreen(fu.getParameter("jobtitle"),user.getLanguage());
  String joblevel = Util.fromScreen(fu.getParameter("joblevel"),user.getLanguage());

  String jobactivitydesc = Util.fromScreen(fu.getParameter("jobactivitydesc"),user.getLanguage());
  String managerid = Util.fromScreen(fu.getParameter("managerid"),user.getLanguage());
  String assistantid = Util.fromScreen(fu.getParameter("assistantid"),user.getLanguage());
  String status = Util.fromScreen(fu.getParameter("status"),user.getLanguage());

  String locationid = Util.fromScreen(fu.getParameter("locationid"),user.getLanguage());
  String workroom = Util.fromScreen(fu.getParameter("workroom"),user.getLanguage());
  String telephone = Util.fromScreen(fu.getParameter("telephone"),user.getLanguage());
  String mobile = Util.fromScreen(fu.getParameter("mobile"),user.getLanguage());

  String mobilecall = Util.fromScreen(fu.getParameter("mobilecall"),user.getLanguage());
  String fax = Util.fromScreen(fu.getParameter("fax"),user.getLanguage());
  String jobcall = Util.fromScreen(fu.getParameter("jobcall"),user.getLanguage());
 
  String systemlanguage = Util.null2String(fu.getParameter("systemlanguage"));
  if(systemlanguage.equals("")||systemlanguage.equals("0")) systemlanguage = "7";
  String accounttype = Util.fromScreen(fu.getParameter("accounttype"),user.getLanguage());
  String belongto = Util.fromScreen(fu.getParameter("belongto"),user.getLanguage());
  if(accounttype.equals("0"))
  belongto="-1";
  
  sql = "select managerstr, seclevel from HrmResource where id = "+Util.getIntValue(managerid);
  rs.executeSql(sql);
  String managerstr = "";
  String seclevel = "";
  while(rs.next()){
      managerstr += rs.getString("managerstr");
      managerstr +=   managerid + "," ;
	  seclevel = rs.getString("seclevel");
  }
  String subcmpanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);

  para = ""+id+separator+workcode+separator+lastname+separator+sex+separator+resourceimageid+separator+
         departmentid+separator+ costcenterid+separator+jobtitle+separator+joblevel+separator+jobactivitydesc+separator+
         managerid+separator+assistantid+separator+status+separator+locationid+separator+workroom+separator+telephone+
         separator+mobile+separator+mobilecall+separator+fax+separator+jobcall+separator+subcmpanyid1+separator+managerstr+separator+accounttype+separator+belongto+separator+systemlanguage;

	RecordSetTrans rst=new RecordSetTrans();
	rst.setAutoCommit(false);
	try{
		rst.executeProc("HrmResourceBasicInfo_Insert",para);

		if(seclevel == null || "".equals(seclevel)){
			seclevel = "0";
		}
		String p_para = id + separator + departmentid + separator + subcmpanyid1 + separator + managerid + separator + seclevel + separator + managerstr + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0";

		//System.out.println(p_para);
		rst.executeProc("HrmResourceShare", p_para);
		rst.commit();
	}catch(Exception e){
		rst.rollback();
		e.printStackTrace();
	}

  rs.executeProc("HrmResource_CreateInfo",""+id+separator+userpara+separator+userpara);

  //ADD By Charoes Huang On MAY 26,2004 FOR BUG 519
   para = ""+id;
   for(int i = 0;i<5;i++){
        String datefield = Util.null2String(fu.getParameter("datefield"+i));
        String numberfield = ""+Util.getDoubleValue(fu.getParameter("numberfield"+i),0);
        String textfield = Util.null2String(fu.getParameter("textfield"+i));
        String tinyintfield = ""+Util.getIntValue(fu.getParameter("tinyintfield"+i),0);
        para += separator+datefield + separator+numberfield+separator+textfield+separator+tinyintfield;
      }
      rs.executeProc("HrmResourceDefine_Update",para);
  // 改为只进行该人缓存信息的添加
  ResourceComInfo.addResourceInfoCache(id);

  SalaryManager.initResourceSalary(id);

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
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

String SWFAccepter="";
String SWFTitle="";
String SWFRemark="";
String SWFSubmiter="";
String Subject="";

Subject= SystemEnv.getHtmlLabelName(15670,user.getLanguage());
Subject+=":"+name;

String thesql="select hrmid from HrmInfoMaintenance where id<4 or id = 10";
rs.executeSql(thesql);
String members="";
while(rs.next()){
  if(user.getUID() != Util.getIntValue(rs.getString("hrmid")))
   members += ","+rs.getString("hrmid");
}
if(!members.equals("")){
    members = members.substring(1);

    SWFAccepter=members;
    SWFTitle= SystemEnv.getHtmlLabelName(15670,user.getLanguage());
    SWFTitle += ":"+name;
    SWFTitle += "-"+CurrentUserName;
    SWFTitle += "-"+CurrentDate;
    SWFRemark="<a href=/hrm/employee/EmployeeManage.jsp?hrmid="+id+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
    SWFSubmiter=CurrentUser;

    SysRemindWorkflow.setPrjSysRemind(SWFTitle,0,Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
}

    sql = "select * from HrmCareerApply where id = "+id;
    rs.executeSql(sql);
    rs.next();
    String birthday = Util.null2String(rs.getString("birthday"));
    String folk = Util.null2String(rs.getString("folk"));
    String nativeplace = Util.null2String(rs.getString("nativeplace"));
    String regresidentplace = Util.null2String(rs.getString("regresidentplace"));

    String certificatenum = Util.null2String(rs.getString("certificatenum"));
    String maritalstatus = Util.null2String(rs.getString("maritalstatus"));
    String policy = Util.null2String(rs.getString("policy"));
    String bememberdate = Util.null2String(rs.getString("bememberdate"));

    String bepartydate = Util.null2String(rs.getString("bepartydate"));
    String islabouunion = Util.null2String(rs.getString("islabouunion"));
    String educationlevel = Util.null2String(rs.getString("educationlevel"));
    String degree = Util.null2String(rs.getString("degree"));

    String healthinfo = Util.null2String(rs.getString("healthinfo"));
    
    String height = Util.null2String(rs.getString("height"));
    if(height.indexOf(".")!=-1)height=height.substring(0,height.indexOf("."));
    String weight = Util.null2String(rs.getString("weight"));
    if(weight.indexOf(".")!=-1)weight=weight.substring(0,weight.indexOf("."));

    String residentplace = Util.null2String(rs.getString("residentplace"));

    String homeaddress = Util.null2String(rs.getString("homeaddress"));
    String tempresidentnumber = Util.null2String(rs.getString("tempresidentnumber"));

    para = "" + id + separator + birthday + separator + folk + separator + nativeplace + separator + regresidentplace + separator + maritalstatus + separator + policy + separator + bememberdate + separator + bepartydate + separator + islabouunion + separator + educationlevel + separator + degree + separator + healthinfo + separator + height + separator+weight + separator + residentplace + separator + homeaddress + separator + tempresidentnumber + separator + certificatenum ;

    rs.executeProc("HrmResourcePersonalInfo_Insert",para);
	rs.executeSql("update cus_fielddata set scope='HrmCustomFieldByInfoType' where scope='CareerCustomFieldByInfoType' and id="+id);
    rs.executeProc("HrmCareerApplyHire",id);
    response.sendRedirect("/hrm/resource/HrmResource.jsp?id="+id);
}
%>