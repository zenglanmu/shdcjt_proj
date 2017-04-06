<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page" />
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid = user.getUID();
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();//账号类型
boolean issys = false;
boolean isfin = false;
boolean ishr  = false;
String sql = "select hrmid from HrmInfoMaintenance where id = 1";
rs.executeSql(sql);
while(rs.next()){
  int hrmid = Util.getIntValue(rs.getString(1));
  if(userid == hrmid){
    issys = true;
    break;
  }
}
sql = "select hrmid from HrmInfoMaintenance where id = 2";
rs.executeSql(sql);
while(rs.next()){
  int hrmid = Util.getIntValue(rs.getString(1));
  if(userid == hrmid){
    isfin = true;
    break;
  }
}
if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
  ishr = true;
}


String hasresourceid="";
String hasresourcename="";
String hasjobtitle    ="";
String hasactivitydesc="";
String hasjobgroup    ="";
String hasjobactivity ="";
String hascostcenter  ="";
String hascompetency  ="";
String hasresourcetype="";
String hasstatus      ="";
String hassubcompany  ="";
String hasdepartment  ="";
String haslocation    ="";
String hasmanager     ="";
String hasassistant   ="";
String hasroles       ="";
String hasseclevel    ="";
String hasjoblevel    ="";
String hasworkroom    ="";
String hastelephone   ="";
String hasstartdate   ="";
String hasenddate     ="";
String hascontractdate="";
String hasbirthday    ="";
String hassex         ="";
String hasaccounttype = "";
String hasage         ="";
String projectable    ="";
String crmable        ="";
String itemable       ="";
String docable        ="";
String workflowable   ="";
String subordinateable="";
String trainable      ="";
String budgetable     ="";
String fnatranable    ="";
String dspperpage     ="";

String hasworkcode = "";
String hasjobcall = "";
String hasmobile = "";
String hasmobilecall = "";
String hasfax = "";
String hasemail = "";
String hasfolk = "";
String hasnativeplace = "";
String hasregresidentplace = "";
String hasmaritalstatus = "";
String hascertificatenum = "";
String hastempresidentnumber = "";
String hasresidentplace = "";
String hashomeaddress = "";
String hashealthinfo = "";
String hasheight = "";
String hasweight = "";
String haseducationlevel = "";
String hasdegree = "";
String hasusekind = "";
String haspolicy = "";
String hasbememberdate = "";
String hasbepartydate = "";
String hasislabouunion = "";
String hasbankid1 = "";
String hasaccountid1 = "";
String hasaccumfundaccount = "";
String hasloginid = "";
String hassystemlanguage = "";
String departmentStr = "";

RecordSet.executeProc("HrmUserDefine_SelectByID",""+userid);

if(RecordSet.next()){
       hasresourceid=RecordSet.getString(2);
       hasresourcename=RecordSet.getString(3);
       hasjobtitle    =RecordSet.getString(4);
       hasactivitydesc=RecordSet.getString(5);
       hasjobgroup    =RecordSet.getString(6);
       hasjobactivity =RecordSet.getString(7);
       hascostcenter  =RecordSet.getString(8);
       hascompetency  =RecordSet.getString(9);
       hasresourcetype=RecordSet.getString(10);
       hasstatus      =RecordSet.getString(11);
       hassubcompany  =RecordSet.getString(12);
       hasdepartment  =RecordSet.getString(13);
       haslocation    =RecordSet.getString(14);
       hasmanager     =RecordSet.getString(15);
       hasassistant   =RecordSet.getString(16);
       hasroles       =RecordSet.getString(17);
       hasseclevel    =RecordSet.getString(18);
       hasjoblevel    =RecordSet.getString(19);
       hasworkroom    =RecordSet.getString(20);
       hastelephone   =RecordSet.getString(21);
       hasstartdate   =RecordSet.getString(22);
       hasenddate     =RecordSet.getString(23);
       hascontractdate=RecordSet.getString(24);
       hasbirthday    =RecordSet.getString(25);
       hasage         =RecordSet.getString("hasage");
       hassex         =RecordSet.getString(26);
       hasaccounttype = RecordSet.getString("hasaccounttype");
   	 hasworkcode = RecordSet.getString("hasworkcode");
	 hasjobcall = RecordSet.getString("hasjobcall");
	 hasmobile = RecordSet.getString("hasmobile");
	 hasmobilecall = RecordSet.getString("hasmobilecall");
	 hasfax = RecordSet.getString("hasfax");
	 hasemail = RecordSet.getString("hasemail");
	 hasfolk = RecordSet.getString("hasfolk");
	 hasnativeplace = RecordSet.getString("hasnativeplace");
	 hasregresidentplace = RecordSet.getString("hasregresidentplace");
	 hasmaritalstatus = RecordSet.getString("hasmaritalstatus");
	 hascertificatenum = RecordSet.getString("hascertificatenum");
	 hastempresidentnumber = RecordSet.getString("hastempresidentnumber");
	 hasresidentplace = RecordSet.getString("hasresidentplace");
	 hashomeaddress = RecordSet.getString("hashomeaddress");
	 hashealthinfo = RecordSet.getString("hashealthinfo");
	 hasheight = RecordSet.getString("hasheight");
	 hasweight = RecordSet.getString("hasweight");
	 haseducationlevel = RecordSet.getString("haseducationlevel");
	 hasdegree = RecordSet.getString("hasdegree");
	 hasusekind = RecordSet.getString("hasusekind");
	 haspolicy = RecordSet.getString("haspolicy");
	 hasbememberdate = RecordSet.getString("hasbememberdate");
	 hasbepartydate = RecordSet.getString("hasbepartydate");
	 hasislabouunion = RecordSet.getString("hasislabouunion");
	 hasbankid1 = RecordSet.getString("hasbankid1");
	 hasaccountid1 = RecordSet.getString("hasaccountid1");
	 hasaccumfundaccount = RecordSet.getString("hasaccumfundaccount");
	 hasloginid = RecordSet.getString("hasloginid");
	 hassystemlanguage = RecordSet.getString("hassystemlanguage");

}
	String resourceid ="";
	String resourcename ="";
	String jobtitle   ="";
	String activitydesc="";
	String jobgroup   ="";
	String jobactivity="";
	String costcenter ="";
	String competency ="";
	String resourcetype ="";
	String status       ="";
	String subcompany1 ="";
	String subcompany2 ="";
	String subcompany3 ="";
	String subcompany4 ="";
	String department ="";
	String departments ="";
	String location   ="";
	String manager    ="";
	String assistant  ="";
	String roles      ="";
	String seclevel  ="";
	String seclevelTo  ="";
	String joblevel  ="";
   	String joblevelTo  ="";
	String workroom     ="";
	String telephone    ="";
	String startdate  ="";
	String startdateTo  ="";
	String enddate    ="";
	String enddateTo    ="";
	String contractdate ="";
	String contractdateTo ="";
	String birthday   ="";
	String birthdayTo   ="";
	String birthdayYear   ="";
	String birthdayMonth   ="";
	String birthdayDay   ="";
        String age        ="";
        String ageTo        ="";
	String sex          ="";
	int accounttype = -1;
	String resourceidfrom = "";
	String resourceidto = "";
	String workcode = "";
	String jobcall = "";
	String mobile = "";
	String mobilecall = "";
	String fax = "";
	String email = "";
	String folk = "";
	String nativeplace = "";
	String regresidentplace = "";
	String maritalstatus = "";
	String certificatenum = "";
	String tempresidentnumber = "";
	String residentplace = "";
	String homeaddress = "";
	String healthinfo = "";
	String heightfrom = "";
	String heightto = "";
	String weightfrom = "";
	String weightto = "";
	String educationlevel = "";
	String educationlevelTo = "";
	String degree = "";
	String usekind = "";
	String policy = "";
	String bememberdatefrom = "";
	String bememberdateto = "";
	String bepartydatefrom = "";
	String bepartydateto = "";
	String islabouunion = "";
	String bankid1 = "";
	String accountid1 = "";
	String accumfundaccount = "";
	String loginid = "";
	String systemlanguage = "";
	//自定义字段Begin
	/*日期型Begin*/
	String dff01name ="";
	String dff02name ="";
	String dff03name ="";
	String dff04name ="";
	String dff05name ="";
	String dff01nameto ="";
	String dff02nameto ="";
	String dff03nameto ="";
	String dff04nameto ="";
	String dff05nameto ="";
	/*日期型End*/
	/*数字型Begin*/
	String nff01name = "";
	String nff02name = "";
	String nff03name = "";
	String nff04name = "";
	String nff05name = "";
	String nff01nameto = "";
	String nff02nameto = "";
	String nff03nameto = "";
	String nff04nameto = "";
	String nff05nameto = "";
	/*数字型End*/
	/*文本型Begin*/
	String tff01name = "";
	String tff02name = "";
	String tff03name = "";
	String tff04name = "";
	String tff05name = "";
	/*文本型End*/
	/*booleanBegin*/
	String bff01name = "";
	String bff02name = "";
	String bff03name = "";
	String bff04name = "";
	String bff05name = "";
	/*booleanEnd*/
	//自定义字段End
	
	rs1.executeSql("select * from HrmSearchMould where 1=2");
	String[] hrmsearchcol = rs1.getColumnName();
	ArrayList hrmsearchList = new ArrayList();
	for(int i=0;i<hrmsearchcol.length;i++){
		hrmsearchList.add(hrmsearchcol[i]);
	}
	
	int scopeId = 1;
	CustomFieldManager cfm1 = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
	cfm1.getCustomFields();
	String mouldcolname = "";
	Map customFieldMap=new HashMap();
	ArrayList customFieldList = new ArrayList();
	while(cfm1.next()){
		mouldcolname = "column_"+cfm1.getId();
		customFieldList.add(mouldcolname);
		if(hrmsearchList.contains(mouldcolname) || hrmsearchList.contains(mouldcolname.toUpperCase())){
			continue;
		}else{
			if("oracle".equals(rs1.getDBType())){
				rs1.executeSql("ALTER TABLE HrmSearchMould ADD " + mouldcolname + " varchar2(200) NULL");
			}else{
				rs1.executeSql("ALTER TABLE HrmSearchMould ADD " + mouldcolname + " varchar(200) NULL");
			}
		}
	}
	for(int i=0;i<hrmsearchList.size();i++){
		String searchcolname = (String)hrmsearchList.get(i);
		if(searchcolname.startsWith("column_")){
			//System.out.println("searchcolname:"+searchcolname);
			if(!customFieldList.contains(searchcolname)){
				rs1.executeSql("ALTER TABLE HrmSearchMould DROP COLUMN  " + searchcolname );
			}
		}
	}
	
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);
RecordSet.executeProc("HrmSearchMould_SelectByID",""+mouldid);
if(RecordSet.next()){

	 resourceid   =Util.toScreenToEdit(RecordSet.getString("resourceid"),user.getLanguage());
	 resourcename =Util.toScreenToEdit(RecordSet.getString("resourcename"),user.getLanguage());
	 jobtitle     =Util.toScreenToEdit(RecordSet.getString("jobtitle"),user.getLanguage());
	 activitydesc =Util.toScreenToEdit(RecordSet.getString("activitydesc"),user.getLanguage());
	 jobgroup     =Util.toScreenToEdit(RecordSet.getString("jobgroup"),user.getLanguage());
	 jobactivity  =Util.toScreenToEdit(RecordSet.getString("jobactivity"),user.getLanguage());
	 costcenter   =Util.toScreenToEdit(RecordSet.getString("costcenter"),user.getLanguage());
	 competency   =Util.toScreenToEdit(RecordSet.getString("competency"),user.getLanguage());
	 resourcetype =Util.toScreenToEdit(RecordSet.getString("resourcetype"),user.getLanguage());
	 status       =Util.toScreenToEdit(RecordSet.getString("status"),user.getLanguage());
	 subcompany1  =Util.toScreenToEdit(RecordSet.getString("subcompany1"),user.getLanguage());
	 departments = Util.toScreenToEdit(RecordSet.getString("department"),user.getLanguage());
	 ArrayList departmentlist = Util.TokenizerString(departments,",");
		for(int i=0;i<departmentlist.size();i++){
			department += ((String)departmentlist.get(i) + ",");
			departmentStr += DepartmentComInfo.getDepartmentname((String)departmentlist.get(i)) + "&nbsp;,";
		}
		if(!"".equals(department)){
			department = department.substring(0, department.length()-1);
			departmentStr = departmentStr.substring(0, departmentStr.length()-1);
		}
	 location     =Util.toScreenToEdit(RecordSet.getString("location"),user.getLanguage());
	 manager      =Util.toScreenToEdit(RecordSet.getString("manager"),user.getLanguage());
	 assistant    =Util.toScreenToEdit(RecordSet.getString("assistant"),user.getLanguage());
	 roles        =Util.toScreenToEdit(RecordSet.getString("roles"),user.getLanguage());
	 seclevel     =Util.toScreenToEdit(RecordSet.getString("seclevel"),user.getLanguage());
	 seclevelTo   =Util.toScreenToEdit(RecordSet.getString("seclevelTo"),user.getLanguage());
	 joblevel     =Util.toScreenToEdit(RecordSet.getString("joblevel"),user.getLanguage());
	 joblevelTo   =Util.toScreenToEdit(RecordSet.getString("joblevelTo"),user.getLanguage());
	 workroom     =Util.toScreenToEdit(RecordSet.getString("workroom"),user.getLanguage());
	 telephone    =Util.toScreenToEdit(RecordSet.getString("telephone"),user.getLanguage());
	 startdate    =Util.toScreenToEdit(RecordSet.getString("startdate"),user.getLanguage());
	 startdateTo  =Util.toScreenToEdit(RecordSet.getString("startdateTo"),user.getLanguage());
	 enddate      =Util.toScreenToEdit(RecordSet.getString("enddate"),user.getLanguage());
	 enddateTo    =Util.toScreenToEdit(RecordSet.getString("enddateTo"),user.getLanguage());
	 contractdate =Util.toScreenToEdit(RecordSet.getString("contractdate"),user.getLanguage());//试用期结束日期
	 contractdateTo =Util.toScreenToEdit(RecordSet.getString("contractdateTo"),user.getLanguage());
	 birthday       =Util.toScreenToEdit(RecordSet.getString("birthday"),user.getLanguage());
         birthdayTo     =Util.toScreenToEdit(RecordSet.getString("birthdayTo"),user.getLanguage());
         birthdayYear     =Util.toScreenToEdit(RecordSet.getString("birthdayyear"),user.getLanguage());
         birthdayMonth     =Util.toScreenToEdit(RecordSet.getString("birthdaymonth"),user.getLanguage());
         birthdayDay     =Util.toScreenToEdit(RecordSet.getString("birthdayday"),user.getLanguage());
         age            =Util.toScreenToEdit(RecordSet.getString("age"),user.getLanguage());
         ageTo          =Util.toScreenToEdit(RecordSet.getString("ageTo"),user.getLanguage());
	 sex            =Util.toScreenToEdit(RecordSet.getString("sex"),user.getLanguage());
	 accounttype =  RecordSet.getInt("accounttype");
	 resourceidfrom     = Util.toScreenToEdit(RecordSet.getString("resourceidfrom"),user.getLanguage());
	 resourceidto       = Util.toScreenToEdit(RecordSet.getString("resourceidto"),user.getLanguage());
	 workcode           = Util.toScreenToEdit(RecordSet.getString("workcode"),user.getLanguage());
	 jobcall            = Util.toScreenToEdit(RecordSet.getString("jobcall"),user.getLanguage());
	 mobile             = Util.toScreenToEdit(RecordSet.getString("mobile"),user.getLanguage());
	 mobilecall         = Util.toScreenToEdit(RecordSet.getString("mobilecall"),user.getLanguage());
	 fax                = Util.toScreenToEdit(RecordSet.getString("fax"),user.getLanguage());
	 email              = Util.toScreenToEdit(RecordSet.getString("email"),user.getLanguage());
	 folk               = Util.toScreenToEdit(RecordSet.getString("folk"),user.getLanguage());
	 nativeplace        = Util.toScreenToEdit(RecordSet.getString("nativeplace"),user.getLanguage());
	 regresidentplace   = Util.toScreenToEdit(RecordSet.getString("regresidentplace"),user.getLanguage());
	 maritalstatus      = Util.toScreenToEdit(RecordSet.getString("maritalstatus"),user.getLanguage());
	 certificatenum     = Util.toScreenToEdit(RecordSet.getString("certificatenum"),user.getLanguage());
	 tempresidentnumber = Util.toScreenToEdit(RecordSet.getString("tempresidentnumber"),user.getLanguage());
	 residentplace      = Util.toScreenToEdit(RecordSet.getString("residentplace"),user.getLanguage());
	 homeaddress        = Util.toScreenToEdit(RecordSet.getString("homeaddress"),user.getLanguage());
	 healthinfo         = Util.toScreenToEdit(RecordSet.getString("healthinfo"),user.getLanguage());
	 heightfrom         = Util.toScreenToEdit(RecordSet.getString("heightfrom"),user.getLanguage());
	 heightto           = Util.toScreenToEdit(RecordSet.getString("heightto"),user.getLanguage());
	 weightfrom         = Util.toScreenToEdit(RecordSet.getString("weightfrom"),user.getLanguage());
	 weightto           = Util.toScreenToEdit(RecordSet.getString("weightto"),user.getLanguage());
	 educationlevel     = Util.toScreenToEdit(RecordSet.getString("educationlevel"),user.getLanguage());
	 educationlevelTo   = Util.toScreenToEdit(RecordSet.getString("educationlevelto"),user.getLanguage());
	 degree             = Util.toScreenToEdit(RecordSet.getString("degree"),user.getLanguage());
	 usekind            = Util.toScreenToEdit(RecordSet.getString("usekind"),user.getLanguage());
	 policy             = Util.toScreenToEdit(RecordSet.getString("policy"),user.getLanguage());
	 bememberdatefrom   = Util.toScreenToEdit(RecordSet.getString("bememberdatefrom"),user.getLanguage());
	 bememberdateto     = Util.toScreenToEdit(RecordSet.getString("bememberdateto"),user.getLanguage());
	 bepartydatefrom    = Util.toScreenToEdit(RecordSet.getString("bepartydatefrom"),user.getLanguage());
	 bepartydateto      = Util.toScreenToEdit(RecordSet.getString("bepartydateto"),user.getLanguage());
	 islabouunion       = Util.toScreenToEdit(RecordSet.getString("islabouunion"),user.getLanguage());
	 bankid1            = Util.toScreenToEdit(RecordSet.getString("bankid1"),user.getLanguage());
	 accountid1         = Util.toScreenToEdit(RecordSet.getString("accountid1"),user.getLanguage());
	 accumfundaccount   = Util.toScreenToEdit(RecordSet.getString("accumfundaccount"),user.getLanguage());
	 loginid            = Util.toScreenToEdit(RecordSet.getString("loginid"),user.getLanguage());
	 systemlanguage     = Util.toScreenToEdit(RecordSet.getString("systemlanguage"),user.getLanguage());
	 
	  dff01name = Util.toScreenToEdit(RecordSet.getString("datefield1"),user.getLanguage());
	 dff02name = Util.toScreenToEdit(RecordSet.getString("datefield2"),user.getLanguage());
	 dff03name = Util.toScreenToEdit(RecordSet.getString("datefield3"),user.getLanguage());
	 dff04name = Util.toScreenToEdit(RecordSet.getString("datefield4"),user.getLanguage());
	 dff05name = Util.toScreenToEdit(RecordSet.getString("datefield5"),user.getLanguage());
	 dff01nameto = Util.toScreenToEdit(RecordSet.getString("datefieldto1"),user.getLanguage());
	 dff02nameto = Util.toScreenToEdit(RecordSet.getString("datefieldto2"),user.getLanguage());
	 dff03nameto = Util.toScreenToEdit(RecordSet.getString("datefieldto3"),user.getLanguage());
	 dff04nameto = Util.toScreenToEdit(RecordSet.getString("datefieldto4"),user.getLanguage());
	 dff05nameto = Util.toScreenToEdit(RecordSet.getString("datefieldto5"),user.getLanguage());
	 nff01name = Util.toScreenToEdit(RecordSet.getString("numberfield1"),user.getLanguage());
	 nff02name = Util.toScreenToEdit(RecordSet.getString("numberfield2"),user.getLanguage());
	 nff03name = Util.toScreenToEdit(RecordSet.getString("numberfield3"),user.getLanguage());
	 nff04name = Util.toScreenToEdit(RecordSet.getString("numberfield4"),user.getLanguage());
	 nff05name = Util.toScreenToEdit(RecordSet.getString("numberfield5"),user.getLanguage());
	 nff01nameto = Util.toScreenToEdit(RecordSet.getString("numberfieldto1"),user.getLanguage());
	 nff02nameto = Util.toScreenToEdit(RecordSet.getString("numberfieldto2"),user.getLanguage());
	 nff03nameto = Util.toScreenToEdit(RecordSet.getString("numberfieldto3"),user.getLanguage());
	 nff04nameto = Util.toScreenToEdit(RecordSet.getString("numberfieldto4"),user.getLanguage());
	 nff05nameto = Util.toScreenToEdit(RecordSet.getString("numberfieldto5"),user.getLanguage());
	 tff01name = Util.toScreenToEdit(RecordSet.getString("textfield1"),user.getLanguage());
	 tff02name = Util.toScreenToEdit(RecordSet.getString("textfield2"),user.getLanguage());
	 tff03name = Util.toScreenToEdit(RecordSet.getString("textfield3"),user.getLanguage());
	 tff04name = Util.toScreenToEdit(RecordSet.getString("textfield4"),user.getLanguage());
	 tff05name = Util.toScreenToEdit(RecordSet.getString("textfield5"),user.getLanguage());
	 bff01name = Util.toScreenToEdit(RecordSet.getString("tinyintfield1"),user.getLanguage());
	 bff02name = Util.toScreenToEdit(RecordSet.getString("tinyintfield2"),user.getLanguage());
	 bff03name = Util.toScreenToEdit(RecordSet.getString("tinyintfield3"),user.getLanguage());
	 bff04name = Util.toScreenToEdit(RecordSet.getString("tinyintfield4"),user.getLanguage());
	 bff05name = Util.toScreenToEdit(RecordSet.getString("tinyintfield5"),user.getLanguage());
	 
	 String customFieldvalue = "";
	 String columnName = "";
	 for(int i=0;i<customFieldList.size();i++){
		 columnName = customFieldList.get(i).toString();
		 customFieldvalue = Util.toScreenToEdit(RecordSet.getString(columnName),user.getLanguage());
		 customFieldMap.put(columnName,customFieldvalue);
	 }
	 
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",/hrm/userdefine/HrmUserDefine.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;
if(mouldid==0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:onSaveas(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top}} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<form class=ViewForm name="resource" method="post" action="HrmResourceSearchTmp.jsp?searchForm=hrmResource"  onsubmit="return false">
<TABLE cellPadding=0 cellSpacing=0 width="100%" class=ViewForm>
  <TBODY>
  <TR>
    <TD vAlign=top width="84%">
    <TABLE class=ViewForm width="100%">
        <COLGROUP>
        <COL width="49%">
        <COL width=24>
        <COL width="49%">
        <TBODY>
        <TR class=Title>
          <TH colSpan=3><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
        <TR class=Spacing style="height:2px">
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
          <TD vAlign=top>
            <TABLE class=ViewForm>
              <COLGROUP>
              <COL width="30%">
              <COL width="70%">
              <TBODY>
              <%
              if(hasresourceid.equals("1") && (mouldid==0||!(resourceidfrom.equals("0"))||!(resourceidto.equals("0")))){
              %>
<!--              <TR>
                <TD>标识</TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=resourceidfrom  size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("resourceidfrom")' value="<%=resourceidfrom%>">-
                  <INPUT name=resourceidto  size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("resourceidto")' value="<%=resourceidto%>">
                 </TD>
                </TR>
-->
              <%}%>

              <%
              if(hasworkcode.equals("1") &&(mouldid==0||!(workcode.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=workcode  value="<%=workcode%>"></TD></TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasresourcename.equals("1") && (mouldid==0||!(resourcename.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=resourcename size=20 value="<%=resourcename%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hassex.equals("1") && (mouldid==0||!(sex.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></td>
                <TD class=Field>
                  <select class=inputstyle id=sex name=sex>
                 	<option value="" <% if(sex.equals("")) {%>selected<%}%>></option>
                        <option value=0 <% if(sex.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
                        <option value=1 <% if(sex.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
                        <option value=2 <% if(sex.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%></option>
                  </select>
                </TD>
              </TR>
                  <TR  style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>
              <%
              if(hasstatus.equals("1") && (mouldid==0||!(status.equals("")))){
              %>
              <TR>
                 <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
                 <TD class=Field>
                  <SELECT class=inputstyle id=status name=status value="<%=status%>">
<%
  //if(ishr){
    if(status.equals("")){
      status = "8";
    }
  //}
%>
                   <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
                   <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
                   <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
                   <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
                   <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
                   <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
                   <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
                   <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
                   <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
                   <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>
                 </SELECT>
                 </TD>
                </TR>
                     <TR  style="height:1px"><TD class=Line colSpan=2></TD></TR>
               <%}%>
			<%
              if(flagaccount && hasaccounttype.equals("1") && (mouldid ==0 || !(hasaccounttype.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></td>
                <TD class=Field>
                  <select class=inputstyle id=accounttype name=accounttype>
                 	<option value="" <% if(sex.equals("")) {%>selected<%}%>></option>
                        <option value=0 <% if(accounttype ==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></option>
                        <option value=1 <% if(accounttype ==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage())%></option>
                  </select>
                </TD>
              </TR>
                  <TR  style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>
              <%
              if(hasdepartment.equals("1") && (mouldid==0||!(department.equals("0")))){
              %>
              <TR>
               <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
               <TD class=Field>
                 <button class=Browser type="button" onClick="onShowDepartment()"></button>
                 <span  id=departmentspan><%=Util.toScreen(departmentStr,user.getLanguage())%></span>
                 <input class=inputstyle id=department type=hidden name=department value="<%=department%>">
               </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hassubcompany.equals("1") && (mouldid==0||!(subcompany1.equals("0")))){
              %>
              <tr>
                <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
                <td class=FIELD>
                	  <button class=Browser type="button" onClick="onShowSubcompany('subcompany1','showrelatedsharename')"></button>
               		  <INPUT type=hidden name='subcompany1'  class='inputstyle' id="subcompany1">
                 	  <input type='hidden' name='shareid' value='0'>
                 	  <span id="showrelatedsharename" class='showrelatedsharename'  name='showrelatedsharename'></span>
                </td>
               </tr>
              <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
               <%}%>
<%if(software.equals("ALL") || software.equals("HRM")){%>
              <%
              if(hascostcenter.equals("1") && (mouldid==0||!(costcenter.equals("0")))){
              %>
              <!--<TR>
                 <TD>成本中心 </TD>
                 <TD class=Field>
                  <button class=Browser onClick="onShowCostCenter()"></button>
                  <span class=inputstyle id=costcenterspan><%=Util.toScreen(CostcenterComInfo.getCostCentername(costcenter),user.getLanguage())%></span>
                  <input id=costcenter type=hidden name=costcenter value="<%=costcenter%>">
                </TD>
              </TR>-->
              <%}%>
<%}%>
              <%
              if(hasresourcetype.equals("1") && (mouldid==0||!(resourcetype.equals("")))){
              %>
<!--              <TR>
                 <TD>类型</TD>
                 <TD class=Field>
                   <SELECT class=inputstyle id=resourcetype name=resourcetype>
              	     <OPTION value="" <% if(resourcetype.equals("")) {%>selected<%}%>></OPTION>
                     <OPTION value=F <% if(resourcetype.equals("F")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%></OPTION>
                     <OPTION value=H <% if(resourcetype.equals("H")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></OPTION>
                     <OPTION value=D <% if(resourcetype.equals("D")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></OPTION>
                     <OPTION value=T <% if(resourcetype.equals("T")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
                  </SELECT>
                </TD>
              </TR>
-->
              <%}%>

               <%
              if(hasjobtitle.equals("1") && (mouldid==0||!(jobtitle.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
                <TD class=Field>
                
                 <INPUT class="wuiBrowser" id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>"
				 _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
				 _displayText="<%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasactivitydesc.equals("1") && (mouldid==0||!(activitydesc.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></TD>
                <TD class=field><INPUT class=inputstyle name=activitydesc size=20 value="<%=activitydesc%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

               <%
              if(hasjobgroup.equals("1") && (mouldid==0||!(jobgroup.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15854,user.getLanguage())%></TD>
                <TD class=Field>
                 <INPUT class=wuiBrowser id=jobgroup type=hidden name=jobgroup value="<%=jobgroup%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp">
                  <SPAN class=inputstyle id=jobgroupspan>
                   <%=JobGroupsComInfo.getJobGroupsname(jobgroup)%>
                 </SPAN>
               </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

              <%
              if(hasjobactivity.equals("1") && (mouldid==0||!(jobactivity.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TD>
                <TD class=Field>
                 <INPUT class=wuiBrowser id=jobactivity type=hidden name=jobactivity value="<%=jobactivity%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp">
                 <SPAN class=inputstyle id=jobactivityspan>
                 <%=JobActivitiesComInfo.getJobActivitiesname(jobactivity)%>
                 </SPAN>
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>
			  <%
String dff01use = "";
String dff02use = "";
String dff03use = "";
String dff04use = "";
String dff05use = "";
String tff01use = "";
String tff02use = "";
String tff03use = "";
String tff04use = "";
String tff05use = "";
String nff01use = "";
String nff02use = "";
String nff03use = "";
String nff04use = "";
String nff05use = "";
String bff01use = "";
String bff02use = "";
String bff03use = "";
String bff04use = "";
String bff05use = "";

boolean hasFF = true;
rs2.executeProc("Base_FreeField_Select","hr");
if(rs2.getCounts()<=0){
	hasFF = false;
}else{
	rs2.first();
	dff01use=rs2.getString("dff01use");
	dff02use=rs2.getString("dff02use");
	dff03use=rs2.getString("dff03use");
	dff04use=rs2.getString("dff04use");
	dff05use=rs2.getString("dff05use");
	tff01use=rs2.getString("tff01use");
	tff02use=rs2.getString("tff02use");
	tff03use=rs2.getString("tff03use");
	tff04use=rs2.getString("tff04use");
	tff05use=rs2.getString("tff05use");
	bff01use=rs2.getString("bff01use");
	bff02use=rs2.getString("bff02use");
	bff03use=rs2.getString("bff03use");
	bff04use=rs2.getString("bff04use");
	bff05use=rs2.getString("bff05use");
	nff01use=rs2.getString("nff01use");
	nff02use=rs2.getString("nff02use");
	nff03use=rs2.getString("nff03use");
	nff04use=rs2.getString("nff04use");
	nff05use=rs2.getString("nff05use");
	
}
if(hasFF || mouldid==0){
%>
	<%
              if((dff01use.equals("1")) && (mouldid==0|| !(dff01name.equals("")) || !(dff01nameto.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("dff01name")%></td>
                <TD class=Field>
                  <BUTTON class=Calendar id=selectdff01name onclick="getDate(dff01namespan,dff01name)"></BUTTON>
                  <SPAN id=dff01namespan ><%=dff01name%></SPAN> －
                  <BUTTON class=Calendar id=selectdff01nameto onclick="getDate(dff01nametospan,dff01nameto)"></BUTTON>
                  <SPAN id=dff01nametospan ><%=dff01nameto%></SPAN>
                  <input class=inputstyle type="hidden" name=dff01name value="<%=dff01name%>">
                  <input class=inputstyle type="hidden" name=dff01nameto value="<%=dff01nameto%>">
                </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}
             if((dff02use.equals("1")) && (mouldid==0|| !(dff02name.equals(""))||!(dff02nameto.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("dff02name")%></td>
                <TD class=Field>
                  <BUTTON class=Calendar id=selectdff02name onclick="getDate(dff02namespan,dff02name)"></BUTTON>
                  <SPAN id=dff02namespan ><%=dff02name%></SPAN> －
                  <BUTTON class=Calendar id=selectdff02nameto onclick="getDate(dff02nametospan,dff02nameto)"></BUTTON>
                  <SPAN id=dff02nametospan ><%=dff02nameto%></SPAN>
                  <input class=inputstyle type="hidden" name=dff02name value="<%=dff02name%>">
                  <input class=inputstyle type="hidden" name=dff02nameto value="<%=dff02nameto%>">
                </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}
             if((dff03use.equals("1")) && (mouldid==0|| !(dff03name.equals(""))||!(dff03nameto.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("dff03name")%></td>
                <TD class=Field>
                  <BUTTON class=Calendar id=selectdff03name onclick="getDate(dff03namespan,dff03name)"></BUTTON>
                  <SPAN id=dff03namespan ><%=dff03name%></SPAN> －
                  <BUTTON class=Calendar id=selectdff03nameto onclick="getDate(dff03nametospan,dff03nameto)"></BUTTON>
                  <SPAN id=dff03nametospan ><%=dff03nameto%></SPAN>
                  <input class=inputstyle type="hidden" name=dff03name value="<%=dff03name%>">
                  <input class=inputstyle type="hidden" name=dff03nameto value="<%=dff03nameto%>">
                </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}
             if((dff04use.equals("1")) && (mouldid==0|| !(dff04name.equals(""))||!(dff04nameto.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("dff04name")%></td>
                <TD class=Field>
                  <BUTTON class=Calendar id=selectdff04name onclick="getDate(dff04namespan,dff04name)"></BUTTON>
                  <SPAN id=dff04namespan ><%=dff04name%></SPAN> －
                  <BUTTON class=Calendar id=selectdff04nameto onclick="getDate(dff04nametospan,dff04nameto)"></BUTTON>
                  <SPAN id=dff04nametospan ><%=dff04nameto%></SPAN>
                  <input class=inputstyle type="hidden" name=dff04name value="<%=dff04name%>">
                  <input class=inputstyle type="hidden" name=dff04nameto value="<%=dff04nameto%>">
                </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}
             if((dff05use.equals("1")) && (mouldid==0|| !(dff05name.equals(""))||!(dff05nameto.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("dff05name")%></td>
                <TD class=Field>
                  <BUTTON class=Calendar id=selectdff05name onclick="getDate(dff05namespan,dff05name)"></BUTTON>
                  <SPAN id=dff05namespan ><%=dff05name%></SPAN> －
                  <BUTTON class=Calendar id=selectdff05nameto onclick="getDate(dff05nametospan,dff05nameto)"></BUTTON>
                  <SPAN id=dff05nametospan ><%=dff05nameto%></SPAN>
                  <input class=inputstyle type="hidden" name=dff05name value="<%=dff05name%>">
                  <input class=inputstyle type="hidden" name=dff05nameto value="<%=dff05nameto%>">
                </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}
	//数字范围搜索
              if((nff01use.equals("1")) && (mouldid==0|| !(nff01name.equals(""))||!(nff01nameto.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("nff01name")%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=nff01name size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff01name")' value="<%=nff01name%>">
                  －<INPUT class=inputstyle name=nff01nameto size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff01nameto")' value="<%=nff01nameto%>">
                </TD>
              </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}
             if((nff02use.equals("1")) && (mouldid==0|| !(nff02name.equals(""))||!(nff02nameto.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("nff02name")%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=nff02name size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff02name")' value="<%=nff02name%>">
                  －<INPUT class=inputstyle name=nff02nameto size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff02nameto")' value="<%=nff02nameto%>">
                </TD>
              </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}
             if((nff03use.equals("1")) && (mouldid==0|| !(nff03name.equals(""))||!(nff03nameto.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("nff03name")%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=nff03name size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff03name")' value="<%=nff03name%>">
                  －<INPUT class=inputstyle name=nff03nameto size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff03nameto")' value="<%=nff03nameto%>">
                </TD>
              </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}
             if((nff04use.equals("1")) && ( mouldid==0||!(nff04name.equals(""))||!(nff04nameto.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("nff04name")%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=nff04name size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff04name")' value="<%=nff04name%>">
                  －<INPUT class=inputstyle name=nff04nameto size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff04nameto")' value="<%=nff04nameto%>">
                </TD>
              </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}
             if((nff05use.equals("1")) && (mouldid==0|| !(nff05name.equals(""))||!(nff05nameto.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("nff05name")%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=nff05name size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff05name")' value="<%=nff05name%>">
                  －<INPUT class=inputstyle name=nff05nameto size=4   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff05nameto")' value="<%=nff05nameto%>">
                </TD>
              </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}
             //自定义文本框
              if(tff01use.equals("1") && (mouldid==0 || !(tff01name.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("tff01name")%></td>
                <TD class=Field><INPUT class=inputstyle name=tff01name value="<%=tff01name%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
             if(tff02use.equals("1") && (mouldid==0|| !(tff02name.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("tff02name")%></td>
                <TD class=Field><INPUT class=inputstyle name=tff02name value="<%=tff02name%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
              if(tff03use.equals("1") && (mouldid==0|| !(tff03name.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("tff03name")%></td>
                <TD class=Field><INPUT class=inputstyle name=tff03name value="<%=tff03name%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
              if(tff04use.equals("1") && (mouldid==0|| !(tff04name.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("tff04name")%></td>
                <TD class=Field><INPUT class=inputstyle name=tff04name value="<%=tff04name%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
              if(tff05use.equals("1") && ( mouldid==0||!(tff05name.equals("")))){
              %>
              <TR>
                <TD><%=rs2.getString("tff05name")%></td>
                <TD class=Field><INPUT class=inputstyle name=tff05name value="<%=tff05name%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
                  //自定义boolean
		if((bff01use.equals("1")) && (mouldid==0||!(bff01name.equals("0"))))
		{
			%>
              <TR>
                <TD><%=rs2.getString("bff01name")%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle type=checkbox  name=bff01name value="1" <%if(bff01name.equals("1")){%> checked <%}%> >
                </TD>
              </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
              if((bff02use.equals("1")) && (mouldid==0||!(bff02name.equals("0"))))
		{
			%>
              <TR>
                <TD><%=rs2.getString("bff02name")%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle type=checkbox  name=bff02name value="1" <%if(bff02name.equals("1")){%> checked <%}%> >
                </TD>
              </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
              if((bff03use.equals("1")) && (mouldid==0||!(bff03name.equals("0"))))
		{
			%>
              <TR>
                <TD><%=rs2.getString("bff03name")%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle type=checkbox  name=bff03name value="1" <%if(bff03name.equals("1")){%> checked <%}%> >
                </TD>
              </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
              if((bff04use.equals("1")) && (mouldid==0||!(bff04name.equals("0"))))
		{
			%>
              <TR>
                <TD><%=rs2.getString("bff04name")%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle type=checkbox  name=bff04name value="1" <%if(bff04name.equals("1")){%> checked <%}%> >
                </TD>
              </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
              if((bff05use.equals("1")) && (mouldid==0||!(bff05name.equals("0"))))
		{
			%>
              <TR>
                <TD><%=rs2.getString("bff05name")%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle type=checkbox  name=bff05name value="1" <%if(bff05name.equals("1")){%> checked <%}%> >
                </TD>
              </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
	
}

%>
         </TBODY>
        </TABLE>
       </TD>
       <TD>
       </TD>
       <TD align=left vAlign=top>
          <TABLE class=ViewForm>
            <COLGROUP>
            <COL width="30%">
            <COL width="70%">
            <TBODY>
              <%
              if(hasjobcall.equals("1") && (mouldid==0||!(jobcall.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></TD>
                <TD class=Field>
                <INPUT class=wuiBrowser id=jobcall type=hidden name=jobcall value="<%=jobcall%>"
                _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp">
                <SPAN class=inputstyle id=jobcallspan>
                <%=JobCallComInfo.getJobCallname(jobcall)%></SPAN>
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasjoblevel.equals("1") && (mouldid==0||!(joblevel.equals("0"))||!(joblevelTo.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=joblevel size=5 maxlength=2  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")' value="<%=joblevel%>">
                  -<INPUT class=inputstyle name=joblevelTo size=5 maxlength=2  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelTo")' value="<%=joblevelTo%>">
                </TD>
              </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasmanager.equals("1") && (mouldid==0||!(manager.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></TD>
                <TD class=Field>
                 <input class=wuiBrowser id=manager type=hidden name=manager value="<%=manager%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
                 <span id=manageridspan><%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%>
                 </span>
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

                             <%
              if(hasassistant.equals("1") && (mouldid==0||!(assistant.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></TD>
                <TD class=Field id=txtAss>
                <INPUT id=assistantid class=wuiBrowser type=hidden name=assistant value="<%=assistant%>"
                _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
                <SPAN  id=assistantidspan><%=Util.toScreen(ResourceComInfo.getResourcename(assistant),user.getLanguage())%>
                </SPAN>
                </TD>
               </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
               <%}%>

               <%
              if(haslocation.equals("1") && (mouldid==0||!(location.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></TD>
                <TD class=Field>
                 <input class=wuiBrowser id=location type=hidden name=location value="<%=location%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp">
                 <span class=inputstyle id=locationspan><%=Util.toScreen(LocationComInfo.getLocationname(location),user.getLanguage())%>
                 </span>
               </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasworkroom.equals("1") && (mouldid==0||!(workroom.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=workroom  value="<%=workroom%>"></TD>
                  </TR>
                   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
               <%}%>

              <%
              if(hastelephone.equals("1") && (mouldid==0||!(telephone.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=telephone   value="<%=telephone%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

               <%
              if(hasmobile.equals("1") && (mouldid==0||!(mobile.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=mobile   value="<%=mobile%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

               <%
              if(hasmobilecall.equals("1") && (mouldid==0||!(mobilecall.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=mobilecall   value="<%=mobilecall%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

               <%
              if(hasfax.equals("1") && (mouldid==0||!(fax.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=fax  value="<%=fax%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

               <%
              if(hasemail.equals("1") && (mouldid==0||!(email.equals("")))){
              %>
              <TR>
                <TD>E-mail</td>
                <TD class=Field><INPUT class=inputstyle name=email   value="<%=email%>"></TD></TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
               <%}%>

              </TBODY>
            </TABLE>
          </TD>
        </TR>
<%if(software.equals("ALL") || software.equals("HRM")){%>
<%
  if(ishr){
%>
	<TR class=Title>
          <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%></TH></TR>
        <TR class=Spacing style="height:2px">
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
          <TD vAlign=top>
            <TABLE class=ViewForm>
              <COLGROUP>
              <COL width="30%">
              <COL width="70%">
              <TBODY>
              <%
      //System.out.println("birthdayYear = " + birthdayYear);
      //System.out.println("birthdayMonth = " + birthdayMonth);
      //System.out.println("birthdayDay = " + birthdayDay);
              if(hasbirthday.equals("1") && (mouldid==0||!(birthdayYear.equals("0"))||!(birthdayMonth.equals("0"))||!(birthdayDay.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></td>
                <TD class=Field>
                年
                  <select class=inputstyle name="birthdayyear">
                  <option value="">
<%
                  for(int i=1900; i<2050; i++){
%>
                    <option value="<%=i%>" <%=(""+i).equals(birthdayYear)?"selected":""%>><%=i%>
<%
                  }
%>
                  </select>
                  月
                  <select class=inputstyle name="birthdaymonth">
                  <option value="">
<%
                  for(int i=1; i<13; i++){
%>
                    <option value="<%=("0"+i).substring(("0"+i).length()-2)%>" <%=(""+i).equals(birthdayMonth)?"selected":""%>><%=i%>
<%
                  }
%>
                  </select>
                  日
                  <select class=inputstyle name="birthdayday">
                  <option value="">
<%
                  for(int i=1; i<32; i++){
%>
                    <option value="<%=("0"+i).substring(("0"+i).length()-2)%>" <%=(""+i).equals(birthdayDay)?"selected":""%>><%=i%>
<%
                  }
%>
                  </select>
                </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

              <%
              if(hasage.equals("1") && (mouldid==0||!(age.equals("0"))||!(ageTo.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=age size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("age")' value="<%=age%>"><%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%>－
                <INPUT class=inputstyle name=ageTo size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("ageTo")' value="<%=ageTo%>"><%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%>
                </TD>
              </TR>
                    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasfolk.equals("1") && (mouldid==0||!(folk.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=folk value="<%=folk%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasnativeplace.equals("1") && (mouldid==0||!(nativeplace.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=nativeplace value="<%=nativeplace%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasregresidentplace.equals("1") && (mouldid==0||!(regresidentplace.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></td>
                <TD class=Field>
                <INPUT class=inputstyle type=text name=regresidentplace value="<%=regresidentplace%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasmaritalstatus.equals("1") &&(mouldid==0||!(maritalstatus.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></td>
                <TD class=Field>
                <select class=inputstyle id=maritalstatus name=maritalstatus>
              	  <option value="" <% if(maritalstatus.equals("")) {%>selected<%}%>></option>
                  <option value=0 <% if(maritalstatus.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></option>
                  <option value=1 <% if(maritalstatus.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></option>
                  <option value=2 <% if(maritalstatus.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%></option> </select>
               </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hascertificatenum.equals("1") && (mouldid==0||!(certificatenum.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=certificatenum value="<%=certificatenum%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hastempresidentnumber.equals("1") && (mouldid==0||!(tempresidentnumber.equals("")))){
              %>
              <TR>

                <TD><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></td>
                <TD class=Field><INPUT class=inputstyle name=tempresidentnumber value="<%=tempresidentnumber%>">
                </TD>
              </TR>
                    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasresidentplace.equals("1") && (mouldid==0||!(residentplace.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=residentplace size=20 value="<%=residentplace%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hashomeaddress.equals("1") && (mouldid==0||!(homeaddress.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(16018,user.getLanguage())%></TD>
                <TD class=field><INPUT class=inputstyle name=homeaddress size=20 value="<%=homeaddress%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hashealthinfo.equals("1") && (mouldid==0||!(healthinfo.equals("")))){
              %>
              <TR>
               <TD><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></TD>
               <TD class=Field>
               <select class=inputstyle id=healthinfo name=healthinfo value="<%=healthinfo%>">
                 <option value="" <%if(healthinfo.equals("")){%> selected <%}%>></option>
                 <option value=0 <%if(healthinfo.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%></option>
                 <option value=1 <%if(healthinfo.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
                 <option value=2 <%if(healthinfo.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
                 <option value=3 <%if(healthinfo.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%></option>
               </select>
               </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

			<%
    	
	    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
	    cfm.getCustomFields();
	    while(cfm.next()){
	        String fieldvalue = Util.null2String((String)customFieldMap.get("column_"+cfm.getId()));
	        if(mouldid==0||!("").equals(fieldvalue)){
%>
    <tr>
      <td> <%=cfm.getLable()%> </td>
      <td class=field >
      <%
        if(cfm.getHtmlType().equals("1")){
            if(cfm.getType()==1){
      %>
        <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="column_<%=cfm.getId()%>" value="" size=20>
      <%
            }else if(cfm.getType()==2){
      %>
      <input  datatype="int" type=text  value="<%=fieldvalue%>" class=Inputstyle name="column_<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
      <%
            }else if(cfm.getType()==3){
      %>
        <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="column_<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
      <%
            }
        }else if(cfm.getHtmlType().equals("2")){
      %>
      	<input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="column_<%=cfm.getId()%>" value="" size=20>
      <%
        }else if(cfm.getHtmlType().equals("3")){

            String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值

            String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
            String newdocid = Util.null2String(request.getParameter("docid"));

            if( fieldtype.equals("37") && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                fieldvalue += newdocid ;
            }

            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                sql = "";

                HashMap temRes = new HashMap();

                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }

                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    showid = Util.null2String(RecordSet.getString(1)) ;
                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                        temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                    else{
                        //showname += tempshowname ;
                        temRes.put(String.valueOf(showid),tempshowname);
                    }
                }
                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                String temstkvalue = "";
                while(temstk.hasMoreTokens()){
                    temstkvalue = temstk.nextToken();

                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                        showname += temRes.get(temstkvalue);
                    }
                }

            }


       if(fieldtype.equals("2") ||fieldtype.equals("19")){
	   %>
        <button class=Calendar 
		<%if(fieldtype.equals("2")){%>
		  onclick="onRpDateShow(column_<%=cfm.getId()%>startspan,column_<%=cfm.getId()%>start,'0')" 
		<%}else{%>
		  onclick="onRpTimeShow(column_<%=cfm.getId()%>startspan,column_<%=cfm.getId()%>start,'0')" 
		<%}%>
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="column_<%=cfm.getId()%>start" value="<%=fieldvalue%>">
        <span id="column_<%=cfm.getId()%>startspan"><%=Util.toScreen(showname,user.getLanguage())%>
        </span> －
		<button class=Calendar 
		<%if(fieldtype.equals("2")){%>
		  onclick="onRpDateShow(column_<%=cfm.getId()%>endspan,column_<%=cfm.getId()%>end,'0')" 
		<%}else{%>
		  onclick="onRpTimeShow(column_<%=cfm.getId()%>endspan,column_<%=cfm.getId()%>end,'0')" 
		<%}%>
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="column_<%=cfm.getId()%>end" value="<%=fieldvalue%>">
        <span id="column_<%=cfm.getId()%>endspan"><%=Util.toScreen(showname,user.getLanguage())%>
        </span>
      <%}else{%>
        <button class=Browser type="button" onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','0')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="column_<%=cfm.getId()%>" value="<%=fieldvalue%>">
        <span id="column_<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
        </span>
       <%}
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="column_<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <select class=InputStyle name="column_<%=cfm.getId()%>" class=InputStyle>
       <option></option>    
       <%
            while(cfm.nextSelect()){
       %>
            <option value="<%=cfm.getSelectValue()%>" <%=cfm.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm.getSelectName()%>
       <%
            }
       %>
       </select>
       <%
        }
       %>
            </td>
        </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD>
  </TR>
       <%
    }
	    }
       %>

         </TBODY>
       </TABLE>
      </TD>

      <TD></TD>

      <TD align=left vAlign=top>
        <TABLE class=ViewForm>
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
              <%
              if(hasheight.equals("1") && (mouldid==0||!(heightfrom.equals("0"))||!(heightto.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=heightfrom size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("heightfrom")' value="<%=heightfrom%>">cm
                  －<INPUT class=inputstyle name=heightto size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("heightto")' value="<%=heightto%>">cm
                </TD>
              </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>
              <%
              if(hasweight.equals("1") && (mouldid==0||!(weightfrom.equals("0"))||!(weightto.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=weightfrom size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("weightfrom")' value="<%=weightfrom%>">kg
                  －<INPUT class=inputstyle name=weightto size=5   onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("weightto")' value="<%=weightto%>">kg
                </TD>
              </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(haseducationlevel.equals("1") && (mouldid==0||!(educationlevel.equals("0"))||!(educationlevelTo.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%> </TD>
                <TD class=field>
                <select class=inputstyle id=educationlevel name=educationlevel value="<%=educationlevel%>">
                <option value=""></option>
                <%
                  EducationLevelComInfo.setTofirstRow();
                  while(EducationLevelComInfo.next()){
                %>
                <option value="<%=EducationLevelComInfo.getEducationLevelid()%>" <%if(educationlevel.equals(EducationLevelComInfo.getEducationLevelid())){%> selected <%}%>><%=EducationLevelComInfo.getEducationLevelname()%></option>
                <%
                  }
                %>
              </select>
              --
              <select class=inputstyle id=educationlevelto name=educationlevelto value="<%=educationlevelTo%>">
                <option value=""></option>
                <%
                  EducationLevelComInfo.setTofirstRow();
                  while(EducationLevelComInfo.next()){
                %>
                <option value="<%=EducationLevelComInfo.getEducationLevelid()%>" <%if(educationlevelTo.equals(EducationLevelComInfo.getEducationLevelid())){%> selected <%}%>><%=EducationLevelComInfo.getEducationLevelname()%></option>
                <%
                  }
                %>
              </select>
                </TD>
              </TR>
                    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasdegree.equals("1") && (mouldid==0||!(degree.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></TD>
                <TD class=field><INPUT class=inputstyle name=degree size=20 value="<%=degree%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
			  if(hasusekind.equals("1") && (mouldid==0||!(usekind.equals("")))){
              %>
              <TR>
               <TD ><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></TD>
               <TD class=Field>
                <BUTTON class=Browser onclick="onShowUsekind()"></BUTTON>
                <SPAN id=usekindspan><%=UseKindComInfo.getUseKindname(usekind)%></SPAN>
                <INPUT class=inputstyle type=hidden name=usekind value="<%=usekind%>">
              </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

             <%
              if(hasroles.equals("1") && (mouldid==0||!(roles.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
               <TD class=Field id=txtAss>
                 <BUTTON class=Browser id=SelectAssistantID onClick="onShowRolesID()"></BUTTON>
                 <SPAN class=inputstyle id=rolesspan><%=Util.toScreen(RolesComInfo.getRolesname(roles),user.getLanguage())%>
                 </SPAN>
                 <INPUT class=inputstyle id=roles type=hidden name=roles value="<%=roles%>">
               </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

             <%
              if(haspolicy.equals("1") && (mouldid==0||!(policy.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></TD>
                <TD class=field><INPUT class=inputstyle name=policy size=20 value="<%=policy%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasbememberdate.equals("1") && (mouldid==0||!(bememberdatefrom.equals(""))||!(bememberdateto.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></td>
                <TD class=Field>
                  <BUTTON class=Calendar id=selectbememberdatefrom onclick="getDate(bememberdatefromspan,bememberdatefrom)"></BUTTON>
                  <SPAN id=bememberdatefromspan ><%=bememberdatefrom%></SPAN> －
                  <BUTTON class=Calendar id=selectbememberdateto onclick="getDate(bememberdatetospan,bememberdateto)"></BUTTON>
                  <SPAN id=bememberdatetospan ><%=bememberdateto%></SPAN>
                  <input class=inputstyle type="hidden" name="bememberdatefrom" value="<%=bememberdatefrom%>">
                  <input class=inputstyle type="hidden" name="bememberdateto" value="<%=bememberdateto%>">
                </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

              <%
              if(hasbepartydate.equals("1") && (mouldid==0||!(bepartydatefrom.equals(""))||!(bepartydateto.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></td>
                <TD class=Field>
                  <BUTTON class=Calendar id=selectbepartydatefrom onclick="getDate(bepartydatefromspan,bepartydatefrom)"></BUTTON>
                  <SPAN id=bepartydatefromspan ><%=bepartydatefrom%></SPAN> －
                  <BUTTON class=Calendar id=selectbpartydateto onclick="getDate(bepartydatetospan,bepartydateto)"></BUTTON>
                  <SPAN id=bepartydatetospan ><%=bepartydateto%></SPAN>
                  <input class=inputstyle type="hidden" name="bepartydatefrom" value="<%=bepartydatefrom%>">
                  <input class=inputstyle type="hidden" name="bepartydateto" value="<%=bepartydateto%>">
                </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

             <%
              if(hasislabouunion.equals("1") && (mouldid==0||!(islabouunion.equals("")))){
              %>
              <TR>
               <TD><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></TD>
               <TD class=Field>
               <select class=inputstyle id=islabouunion name=islabouunion value="<%=islabouunion%>">
                <option value="" <%if(islabouunion.equals("")){%> selected <%}%>></option>
                <option value=1 <%if(islabouunion.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
                <option value=0 <%if(islabouunion.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
               </select>
              </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

             <%
              if(hasstartdate.equals("1") && (mouldid==0||!(startdate.equals(""))||!(startdateTo.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></td>
                <TD class=Field>
                  <BUTTON class=Calendar id=selectstartdate onclick="getstartDate()"></BUTTON>
                  <SPAN id=startdatespan ><%=startdate%></SPAN>－
                  <BUTTON class=Calendar id=selectstartdateTo onclick="getstartDateTo()"></BUTTON>
                  <SPAN id=startdateTospan ><%=startdateTo%></SPAN>
                  <input class=inputstyle type="hidden" name="startdate" value="<%=startdate%>">
                  <input class=inputstyle type="hidden" name="startdateTo" value="<%=startdateTo%>">
                </td>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasenddate.equals("1") && (mouldid==0||!(enddate.equals(""))||!(enddateTo.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></td>
                <TD class=Field>
                 <BUTTON class=Calendar id=selectenddate onclick="getendDate()"></BUTTON>
                 <SPAN id=enddatespan ><%=enddate%></SPAN>－
                 <BUTTON class=Calendar id=selectenddateTo onclick="getendDateTo()"></BUTTON>
                 <SPAN id=enddateTospan ><%=enddateTo%></SPAN>
                 <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">
                 <input class=inputstyle type="hidden" name="enddateTo" value="<%=enddateTo%>">
               </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

              <%
              if(hascontractdate.equals("1") && (mouldid==0||!(contractdate.equals(""))||!(contractdateTo.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></td>
                <TD class=Field>
                 <BUTTON class=Calendar id=selectcontractdate onclick="getcontractDate()"></BUTTON>
                 <SPAN id=contractdatespan ><%=contractdate%></SPAN>－
                 <BUTTON class=Calendar id=selectcontractdateTo onclick="getcontractDateTo()"></BUTTON>
                 <SPAN id=contractdateTospan ><%=contractdateTo%></SPAN>
                 <input class=inputstyle type="hidden" name="contractdate" value="<%=contractdate%>">
                 <input class=inputstyle type="hidden" name="contractdateTo" value="<%=contractdateTo%>">
		</TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

            </TBODY>
          </TABLE>
        </TD>
      </TR>
<%
}
%>
<%
	if(isgoveproj==0){
  if( ishr || isfin ) {
%>
        <TR class=Title>
          <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH></TR>
        <TR class=Spacing  style="height:2px">
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
          <TD vAlign=top>
            <TABLE class=ViewForm>
              <COLGROUP>
              <COL width="30%">
              <COL width="70%">
              <TBODY>
              <%
              if(hasbankid1.equals("1") && (mouldid==0||!(bankid1.equals("")))){
              %>
              <TR>
               <TD><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></TD>
               <TD class=Field>
                 <button class=Browser id=SelectBank onClick="onShowBank(bankid1span,bankid1)"></button>
                 <span class=inputstyle id=bankid1span><%=BankComInfo.getBankname(bankid1)%></span>
                 <input class=inputstyle id=bankid1 type=hidden name=bankid1 value="<%=bankid1%>">
               </TD>
             </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>


              <%
              if(hasaccountid1.equals("1") && (mouldid==0||!(accountid1.equals("")))){
              %>
               <TR>
                <TD><%=SystemEnv.getHtmlLabelName(16016,user.getLanguage())%></TD>
                <TD class=Field>
                 <input class=inputstyle type=text name="accountid1" value="<%=accountid1%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
               <%}%>

         </TBODY>
       </TABLE>
      </TD>
      <TD></TD>
      <TD align=left vAlign=top>
        <TABLE class=ViewForm>
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
               <%
              if(hasaccumfundaccount.equals("1") && (mouldid==0||!(accumfundaccount.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(1939,user.getLanguage())%></TD>
                <TD class=Field><INPUT class=inputstyle name=accumfundaccount size=20  value="<%=accumfundaccount%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              </TBODY>
            </TABLE>
          </TD>
        </TR>
<%
  }
}
}
%>
<%
  if(ishr || issys){
%>
        <TR class=Title>
          <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%></TH></TR>
        <TR class=Spacing style="height:2px">
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
          <TD vAlign=top>
            <TABLE class=ViewForm>
              <COLGROUP>
              <COL width="30%">
              <COL width="70%">
              <TBODY>

              <%
              if(hasseclevel.equals("1") && (mouldid==0||!(seclevel.equals("0"))||!(seclevelTo.equals("0")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle name=seclevel size=5 maxlength=3  onKeyPress="ItemPlusCount_KeyPress()" onBlur='checknumber("seclevel")' value="<%=seclevel%>">-<INPUT class=inputstyle name=seclevelTo size=5 maxlength=3  onKeyPress="ItemPlusCount_KeyPress()" onBlur='checknumber("seclevelTo")' value="<%=seclevelTo%>">
                </TD>
              </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>

              <%
              if(hasloginid.equals("1") && (mouldid==0||!(loginid.equals("")))){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(16017,user.getLanguage())%></TD>
                <TD class=field>
                  <INPUT class=inputstyle name=loginid size=20 value="<%=loginid%>">
                </TD>
              </TR>
                  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>
         </TBODY>
       </TABLE>
     </TD>
     <TD></TD>
     <TD align=left vAlign=top>
       <TABLE class=ViewForm>
         <COLGROUP>
         <COL width="30%">
         <COL width="70%">
         <TBODY>
               <%
              if(hassystemlanguage.equals("1") && (mouldid==0||!(systemlanguage.equals("0")))){
              %>
              <TR>
               <TD><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></TD>
               <TD class=Field>
                 <select class=inputstyle name=systemlanguage value="<%=systemlanguage%>">
                  <option value="" <%if(systemlanguage.equals("")){%>selected<%}%>></option>
                  <option value="7" <%if(systemlanguage.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%></option>
                  <option value="8" <%if(systemlanguage.equals("8")){%>selected<%}%>>English</option>
                 </select>
               </TD>
             </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <%}%>

              </TBODY>
            </TABLE>
          </TD>
        </TR>
<%
}
%>
      </TBODY>
     </TABLE>
    </TD>
    <TD vAlign=top width="16%"><!-- Template -->
      <TABLE class=ListStyle cellspacing=1 >
        <TBODY>
        <TR class=header>
          <TH><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></TH></TR>
        <TR class=DataLight>
          <TD>
            <a href="HrmResourceSearch.jsp?mouldid=0"><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></a>
          </TD>
        </TR>
        <%
        int i=0;
        RecordSet.executeProc("HrmSearchMould_SelectByUserID",""+userid);
	while(RecordSet.next()){
        	if(i==0){%>
        	  <TR class=DataDark>
        	 <%i=1;}
        	else{%>
        	  <TR class=DataLight>
        	<%i=0;}%>
          <td>
            <a href="HrmResourceSearch.jsp?mouldid=<%=RecordSet.getString(1)%>"><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%>
            </a>
          </td>
        </TR>
        <%
        }
        if(mouldid==0){
        %>
        <TR id=oTrname style="display:none">
          <TD>
            <font color=red><%=SystemEnv.getHtmlLabelName(554,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></font></TD>
        </TR>
        <TR>
          <TD>
            <INPUT class=inputstyle type="text" name="mouldname" value="" style="width:90% !important"
			onChange="checkinput('mouldname','mouldnamespan')">
          <span id=mouldnamespan><IMG src="/images/BacoError.gif" align=absMiddle></span></TD>
          </TD>
        </TR>
        <%
        }else{
        %>
        <tr>
          <td align=center>

          <td>
        </tr>
        <!--tr>
          <td align=center>
            <BUTTON class=btnDelete accessKey=D onClick="if(isdel()){onDelete();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
          <td>
        </tr-->
        <%}%>

        </TBODY>
       </TABLE>
      </TD>
     </TR>
    </TBODY>
   </TABLE>

<input class=inputstyle type="hidden" name="opera">
<input class=inputstyle type="hidden" name="mouldid" value="<%=mouldid%>">
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>

<script language=javascript>
function onNumberBlur(f,id){
	checknumber(id+"_"+f);
	var o=document.getElementById(id);
	var iStart=document.all(id+"_start").value;
	iStart=(iStart!="")?parseInt(iStart):'A';

	var iEnd=document.all(id+"_end").value;
	iEnd=(iEnd!="")?parseInt(iEnd):'A';

	o.value=iStart+","+iEnd;
	//alert(o.value);
}
function customDateAction(realInputDate,span1,date1){
	
	var inputDate=document.getElementById(realInputDate);
	
	var strDate=date1+"_dateSpan";
	var objDate=document.getElementById(strDate);

	var dates=inputDate.value.split(",");
	var prefixStr=span1.id.substring(0,3);
	if(prefixStr=="sta"){
		objDate.value=dates[0];
	}else if(prefixStr=="end"){
		objDate.value=dates[1];
	}	
	getDate(span1,objDate);//getDate
	if(prefixStr=="sta"){
		dates[0]=objDate.value;
		dates[0]=(dates[0]=="")?"A":dates[0];
	}else if(prefixStr=="end"){
		dates[1]=objDate.value;
		dates[1]=(dates[1]=="")?"A":dates[1];
	}
	inputDate.value=dates.join(",");

	//alert(inputDate.value);
}

function checkNewmould(){
	if(document.resource.mouldname.value==''){
		oTrname.style.display='';
		return false;
		}
	return true;
}
function onSaveas(){
	if(check_form(document.resource,'mouldname')){
	//if(checkNewmould()){
	document.resource.opera.value="insert";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.submit();
	}
}
function onSave(){
	document.resource.opera.value="update";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.submit();
}
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
	document.resource.opera.value="delete";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.submit();
	}
}
function submitData() {
 resource.submit();
}


function onShowBrowser(id,url,linkurl,type1,ismand){
    spanname = "column_"+id+"span";
	inputname = "column_"+id;
	if (type1== 2 || type1 == 19){
		if (type1 == 2){
		 onShowADTDate(id);
		}else{
		 onShowTime(spanname,inputname);
		}
	}else{
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170){
			id1 = window.showModalDialog(url);
		}else if (type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            tmpids = jQuery("input[name=column_"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
		}else{
			tmpids = jQuery("input[name=column_"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
		}
			//alert(id1.id+"  "+id1.name)
		if (id1!=null){
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65){
				if (id1.id!= ""  && id1.id!= "0"){
					ids = id1.id.split(",");
					names =id1.name.split(",");
					sHtml = "";
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
					
							sHtml = sHtml+"<a href="+linkurl+curid+">"+curname+"</a>&nbsp;";
						}
					}
					
					jQuery("#column_"+id+"span").html(sHtml);
					
				}else{
					if (ismand==0){
						jQuery("#column_"+id+"span").html("");
					}else{
						jQuery("#column_"+id+"span").html("<img src='/images/BacoError.gif' align=absmiddle>");
						}
					jQuery("input[name=column_"+id+"]").val("");
				}
			}else{
			   if  (id1.id!="" && id1.id!= "0"){
			        if (linkurl == ""){
						jQuery("#column_"+id+"span").html(id1.name);
					}else{
						jQuery("#column_"+id+"span").html("<a href="+linkurl+id1.id+">"+id1.name+"</a>");
					}
					jQuery("input[name=column_"+id+"]").val(id1.id);
			   }else{
					if (ismand==0){
						jQuery("#column_"+id+"span").html("");
					}else{
						jQuery("#column_"+id+"span").html("<img src='/images/BacoError.gif' align=absmiddle>");
					}
					jQuery("input[name=column_"+id+"]").val("");
				}
			}
		}
	}

}


function onShowDepartment(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#department").val());    
    if (data!=null){
		if (data.id != "" ){
			ids = data.id.split(",");
			names =data.name.split(",");
			sHtml = "";
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
					sHtml = sHtml+names[i]+"&nbsp;&nbsp;";
				}
			}
			jQuery("#departmentspan").html(sHtml);
			jQuery("input[name=department]").val(data.id.substr(1));
		}else{
			jQuery("#departmentspan").html("");
			jQuery("input[name=department]").val("");
		}
	}
}
  function onShowSubcompany(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/company/HrmSubCompanyDsp.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}

</script>
<!--
<script language=vbs>
sub onShowDefaultLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	defaultlanguagespan.innerHtml = id(1)
	resource.defaultlanguage.value=id(0)
end sub

sub onShowSystemLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	systemlanguagespan.innerHtml = id(1)
	resource.systemlanguage.value=id(0)
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&document.getElementById("department").value)    
    if Not isempty(id) then
	if id(0)<> "" then
	departmentspan.innerHtml = Mid(id(1),2)
	resource.department.value=Mid(id(0),2)
	else
	departmentspan.innerHtml = ""
	resource.department.value=""
	end if
	end if
end sub

sub onShowCostCenter()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	costcenterspan.innerHtml = id(1)
	resource.costcenter.value=id(0)
	else
	costcenterspan.innerHtml = ""
	resource.costcenter.value=""
	end if
	end if
end sub

sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&id(0)&"')>"&id(1)&"</A>"
	resource.manager.value=id(0)
	else
	manageridspan.innerHtml = ""
	resource.manager.value=""
	end if
	end if
end sub

sub onShowAssistantID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> "" then
	assistantidspan.innerHtml = "<A href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&id(0)&"')>"&id(1)&"</A>"
	resource.assistant.value=id(0)
	else
	assistantidspan.innerHtml = ""
	resource.assistant.value=""
	end if
	end if
end sub

sub onShowRolesID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> "" then
	rolesspan.innerHtml = id(1)
	resource.roles.value=id(0)
	else
	rolesspan.innerHtml = ""
	resource.roles.value=""
	end if
	end if
end sub

sub onShowJobTitles()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	resource.jobtitle.value=id(0)
	else
	jobtitlespan.innerHtml = ""
	resource.jobtitle.value=""
	end if
	end if
end sub

sub onShowJobGroups()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	jobgroupspan.innerHtml = id(1)
	resource.jobgroup.value= id(0)
	else
	jobgroupspan.innerHtml = ""
	resource.jobgroup.value=""
	end if
	end if
end sub

sub onShowJobActivities()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	jobactivityspan.innerHtml = id(1)
	resource.jobactivity.value=id(0)
	else
	jobactivityspan.innerHtml = ""
	resource.jobactivity.value=""
	end if
	end if
end sub

sub onShowJobCall()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	jobcallspan.innerHtml = id(1)
	resource.jobcall.value=id(0)
	else
	jobcallspan.innerHtml = ""
	resource.jobcall.value=""
	end if
	end if
end sub

sub onShowLocation()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	locationspan.innerHtml = id(1)
	resource.location.value=id(0)
	else
	locationspan.innerHtml = ""
	resource.location.value=""
	end if
	end if
end sub

sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	resource.usekind.value=id(0)
	else
	usekindspan.innerHtml = ""
	resource.usekind.value=""
	end if
	end if
end sub


sub onShowBank(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/bank/BankBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowBrowser1(id,url,linkurl,type1,ismand)
	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("column_"+id+"span").innerHtml = id1
		document.all("column_"+id).value=id1
	else
		if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("column_"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = document.all("column_"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("column_"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("column_"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						document.all("column_"+id+"span").innerHtml = empty
					else
						document.all("column_"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					document.all("column_"+id).value=""
				end if

			else
			   if  id1(0)<>""   and id1(0)<> "0"  then
			        if linkurl = "" then
						document.all("column_"+id+"span").innerHtml = id1(1)
					else
						document.all("column_"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
					end if
					document.all("column_"+id).value=id1(0)
				else
					if ismand=0 then
						document.all("column_"+id+"span").innerHtml = empty
					else
						document.all("column_"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					document.all("column_"+id).value=""
				end if
			end if
		end if
	end if

end sub
</script>
-->
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
