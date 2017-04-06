<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="DepreMethodComInfo" class="weaver.cpt.maintenance.DepreMethodComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
//String userid =""+user.getUID();
int userid =user.getUID();


int advanced=Util.getIntValue(request.getParameter("advanced"),0); //是否是高级搜索 0:否;1:是
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);   //是否应用模板  0:无模板,>0:模板id
String from = Util.fromScreen(request.getParameter("from"),user.getLanguage()) ;				/*查询走向*/

String mark = "";			/*编号*/
String name = "";			/*名称*/
String startdate = "";			/*生效日从*/
String startdate1 = "";			/*生效日到*/
String enddate= "";				/*生效至从*/
String enddate1= "";				/*生效至到*/
String seclevel= "";				/*安全级别从*/
String seclevel1= "";				/*安全级别到*/
String subcompanyid = "";           /*分部*/
String departmentid = "";/*部门*/
String costcenterid = "";			/*成本中心*/
String resourceid = "";		/*人力资源*/
String currencyid = "";	/*币种*/
String capitalcost = "";	/*成本从*/
String capitalcost1 = "";	/*成本到*/
String startprice = "";	/*开始价格从*/
String startprice1 = "";	/*开始价格到*/
String depreendprice = ""; /*折旧底价(新)从*/
String depreendprice1 = ""; /*折旧底价(新)到*/
String capitalspec = "";			/*规格型号(新)*/
String capitallevel = "";	/*资产等级(新)*/
String manufacturer	= "";			/*制造厂商(新)*/
String manudate	= "";			/*出厂日期(新)从*/
String manudate1	= "";			/*出厂日期(新)到*/
String capitaltypeid = "";			/*资产类型*/
String capitalgroupid = "";			/*资产组*/
String unitid = "";				/*计量单位*/
String capitalnum = "";			/*数量从*/
String capitalnum1 = "";			/*数量到*/
String currentnum = "";			/*当前数量从*/
String currentnum1 = "";			/*当前数量到*/
String replacecapitalid ="";				/*替代*/
String version = "" ;			/*版本*/
String itemid ="";			/*物品*/
String depremethod1 ="";			/*折旧法一*/
String depremethod2 ="";			/*折旧法二*/
String deprestartdate ="";		/*折旧开始日期从*/
String deprestartdate1 ="";		/*折旧开始日期到*/
String depreenddate ="" ;			/*折旧结束日期从*/
String depreenddate1 ="" ;			/*折旧结束日期到*/
String customerid="";			/*客户id*/
String attribute= "";
/*属性:
0:自制
1:采购
2:租赁
3:出租
4:维护
5:租用
6:其它
*/
String stateid = "";	/*资产状态*/
String location = "";			/*存放地点*/
String isdata = "";			/*资产或资料*/
String counttype = "";		/*固资或低耗*/
String isinner = "";		/*帐内或帐外*/
String type="";
String stockindate	= "";			/*入库日期从*/
String stockindate1	= "";		    /*入库日期到*/

String fnamark = ""; /*财务编号*/
String barcode = ""; /*条形码*/
String blongdepartment = "";/*所属部门*/
String blongsubcompany = "";/*所属分部*/
String sptcount = "";/*单独核算*/
String relatewfid = ""; /*相关工作流*/
String SelectDate = "";/*购置日期*/
String SelectDate1 = "";/*购置日期1*/
String contractno = "";/*合同号*/
String Invoice = "";/*发票号*/
String depreyear = "";/*折旧年限*/
String deprerate = "";/*残值率*/
String depreyear1 = "";/*折旧年限*/
String deprerate1 = "";/*残值率*/
String issupervision = "";/*是否海关监管*/
String amountpay = "";/*已付金额*/
String amountpay1 = "";/*已付金额*/
String purchasestate = "";/*采购状态*/

String datafield1 = "";/*自定义日期类型*/
String datafield11 = "";/*自定义日期类型*/
String datafield2 = "";/*自定义日期类型*/
String datafield22 = "";/*自定义日期类型*/
String datafield3 = "";/*自定义日期类型*/
String datafield33 = "";/*自定义日期类型*/
String datafield4 = "";/*自定义日期类型*/
String datafield44 = "";/*自定义日期类型*/
String datafield5 = "";/*自定义日期类型*/
String datafield55 = "";/*自定义日期类型*/	
	
String numberfield1 = "";/*自定义浮点数*/
String numberfield11 = "";/*自定义浮点数*/
String numberfield2 = "";/*自定义浮点数*/
String numberfield22 = "";/*自定义浮点数*/
String numberfield3 = "";/*自定义浮点数*/
String numberfield33 = "";/*自定义浮点数*/
String numberfield4 = "";/*自定义浮点数*/
String numberfield44 = "";/*自定义浮点数*/
String numberfield5 = "";/*自定义浮点数*/
String numberfield55 = "";/*自定义浮点数*/
	
String textfield1 = "";/*自定义文本*/
String textfield2 = "";/*自定义文本*/
String textfield3 = "";/*自定义文本*/
String textfield4 = "";/*自定义文本*/
String textfield5 = "";/*自定义文本*/

String tinyintfield1 = "";/*自定义check框*/
String tinyintfield2 = "";/*自定义check框*/
String tinyintfield3 = "";/*自定义check框*/
String tinyintfield4 = "";/*自定义check框*/
String tinyintfield5 = "";/*自定义check框*/
	
String docff01name = "";/*自定义多文档*/
String docff02name = "";/*自定义多文档*/
String docff03name = "";/*自定义多文档*/
String docff04name = "";/*自定义多文档*/
String docff05name = "";/*自定义多文档*/
	
String depff01name = "";/*自定义多部门*/
String depff02name = "";/*自定义多部门*/
String depff03name = "";/*自定义多部门*/
String depff04name = "";/*自定义多部门*/
String depff05name = "";/*自定义多部门*/
	
String crmff01name = "";/*自定义多客户*/
String crmff02name = "";/*自定义多客户*/
String crmff03name = "";/*自定义多客户*/
String crmff04name = "";/*自定义多客户*/
String crmff05name = "";/*自定义多客户*/
	
String reqff01name = "";/*自定义多请求*/
String reqff02name = "";/*自定义多请求*/
String reqff03name = "";/*自定义多请求*/
String reqff04name = "";/*自定义多请求*/
String reqff05name = "";/*自定义多请求*/

if(mouldid!=0){
	RecordSet.executeProc("CptSearchMould_SelectByID",""+mouldid);
	RecordSet.next();
	mark = Util.toScreenToEdit(RecordSet.getString("mark"),user.getLanguage()) ;				/*编号*/
	name = Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage());			/*名称*/
	startdate = Util.toScreenToEdit(RecordSet.getString("startdate"),user.getLanguage());			/*生效日*/
	startdate1 = Util.toScreenToEdit(RecordSet.getString("startdate1"),user.getLanguage());			/*生效日*/
	enddate= Util.toScreenToEdit(RecordSet.getString("enddate"),user.getLanguage());				/*生效至*/
	enddate1= Util.toScreenToEdit(RecordSet.getString("enddate1"),user.getLanguage());				/*生效至*/
	seclevel= Util.toScreenToEdit(RecordSet.getString("seclevel"),user.getLanguage());				/*安全级别*/
	seclevel1= Util.toScreenToEdit(RecordSet.getString("seclevel1"),user.getLanguage());				/*安全级别*/
	departmentid = Util.toScreenToEdit(RecordSet.getString("departmentid"),user.getLanguage());/*部门*/
	costcenterid = Util.toScreenToEdit(RecordSet.getString("costcenterid"),user.getLanguage());			/*成本中心*/
	resourceid = Util.toScreenToEdit(RecordSet.getString("resourceid"),user.getLanguage());		/*人力资源*/
	currencyid = Util.toScreenToEdit(RecordSet.getString("currencyid"),user.getLanguage());	/*币种*/
	capitalcost = Util.toScreenToEdit(RecordSet.getString("capitalcost"),user.getLanguage());	/*成本*/
	capitalcost1 = Util.toScreenToEdit(RecordSet.getString("capitalcost1"),user.getLanguage());	/*成本*/
	startprice = Util.toScreenToEdit(RecordSet.getString("startprice"),user.getLanguage());	/*开始价格*/
	startprice1 = Util.toScreenToEdit(RecordSet.getString("startprice1"),user.getLanguage());	/*开始价格*/
	depreendprice = Util.toScreenToEdit(RecordSet.getString("depreendprice"),user.getLanguage()); /*折旧底价(新)*/
	depreendprice1 = Util.toScreenToEdit(RecordSet.getString("depreendprice1"),user.getLanguage()); /*折旧底价(新)*/
	capitalspec = Util.toScreenToEdit(RecordSet.getString("capitalspec"),user.getLanguage());			/*规格型号(新)*/
	capitallevel = Util.toScreenToEdit(RecordSet.getString("capitallevel"),user.getLanguage());	/*资产等级(新)*/
	manufacturer = Util.toScreenToEdit(RecordSet.getString("manufacturer"),user.getLanguage());			/*制造厂商(新)*/
	manudate	= Util.toScreenToEdit(RecordSet.getString("manudate"),user.getLanguage());			/*出厂日期(新)*/
	manudate1	= Util.toScreenToEdit(RecordSet.getString("manudate1"),user.getLanguage());			/*出厂日期(新)*/
	capitaltypeid = Util.toScreenToEdit(RecordSet.getString("capitaltypeid"),user.getLanguage());			/*资产类型*/
	capitalgroupid = Util.toScreenToEdit(RecordSet.getString("capitalgroupid"),user.getLanguage());			/*资产组*/
	unitid = Util.toScreenToEdit(RecordSet.getString("unitid"),user.getLanguage());				/*计量单位*/
	capitalnum = Util.toScreenToEdit(RecordSet.getString("capitalnum"),user.getLanguage());			/*数量*/
	capitalnum1 = Util.toScreenToEdit(RecordSet.getString("capitalnum1"),user.getLanguage());			/*数量*/
	currentnum = Util.toScreenToEdit(RecordSet.getString("currentnum"),user.getLanguage());			/*当前数量*/
	currentnum1 = Util.toScreenToEdit(RecordSet.getString("currentnum1"),user.getLanguage());			/*当前数量*/
	replacecapitalid =Util.toScreenToEdit(RecordSet.getString("replacecapitalid"),user.getLanguage());				/*替代*/
	version =Util.toScreenToEdit(RecordSet.getString("version"),user.getLanguage()) ;			/*版本*/
	itemid =Util.toScreenToEdit(RecordSet.getString("itemid"),user.getLanguage());			/*物品*/
	depremethod1 =Util.toScreenToEdit(RecordSet.getString("depremethod1"),user.getLanguage());			/*折旧法一*/
	depremethod2 =Util.toScreenToEdit(RecordSet.getString("depremethod2"),user.getLanguage());			/*折旧法二*/
	deprestartdate =Util.toScreenToEdit(RecordSet.getString("deprestartdate"),user.getLanguage());		/*折旧开始日期*/
	deprestartdate1 =Util.toScreenToEdit(RecordSet.getString("deprestartdate1"),user.getLanguage());		/*折旧开始日期*/
	depreenddate = Util.toScreenToEdit(RecordSet.getString("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
	depreenddate1 = Util.toScreenToEdit(RecordSet.getString("depreenddate1"),user.getLanguage()) ;			/*折旧结束日期*/
	customerid=Util.toScreenToEdit(RecordSet.getString("customerid"),user.getLanguage());			/*客户id*/
	attribute= Util.toScreenToEdit(RecordSet.getString("attribute"),user.getLanguage());
	stateid = Util.toScreenToEdit(RecordSet.getString("stateid"),user.getLanguage());	/*资产状态*/
	location = Util.toScreenToEdit(RecordSet.getString("location"),user.getLanguage()) ;			/*存放地点*/
	isdata = Util.toScreenToEdit(RecordSet.getString("isdata"),user.getLanguage()) ;			/*资产或资料*/
	counttype = Util.toScreenToEdit(RecordSet.getString("counttype"),user.getLanguage()) ;			/*固资或低耗*/
	isinner = Util.toScreenToEdit(RecordSet.getString("isinner"),user.getLanguage()) ;			/*帐内或帐外*/
    stockindate	    = Util.toScreenToEdit(RecordSet.getString("stockindate"),user.getLanguage()) ;			/*入库日期从*/
    stockindate1	= Util.toScreenToEdit(RecordSet.getString("stockindate1"),user.getLanguage()) ;		    /*入库日期到*/


	fnamark = Util.toScreenToEdit(RecordSet.getString("fnamark"),user.getLanguage()); /*财务编号*/
	barcode = Util.toScreenToEdit(RecordSet.getString("barcode"),user.getLanguage()); /*条形码*/
	blongdepartment = Util.toScreenToEdit(RecordSet.getString("blongdepartment"),user.getLanguage());/*所属部门*/
	sptcount = Util.toScreenToEdit(RecordSet.getString("sptcount"),user.getLanguage());/*单独核算*/
	relatewfid = Util.toScreenToEdit(RecordSet.getString("relatewfid"),user.getLanguage()); /*相关工作流*/
	SelectDate = Util.toScreenToEdit(RecordSet.getString("SelectDate"),user.getLanguage());/*购置日期*/
	SelectDate1 = Util.toScreenToEdit(RecordSet.getString("SelectDate1"),user.getLanguage());/*购置日期1*/
	contractno = Util.toScreenToEdit(RecordSet.getString("contractno"),user.getLanguage());/*合同号*/
	Invoice = Util.toScreenToEdit(RecordSet.getString("Invoice"),user.getLanguage());/*发票号*/
	depreyear = Util.toScreenToEdit(RecordSet.getString("depreyear"),user.getLanguage());/*折旧年限*/
	deprerate = Util.toScreenToEdit(RecordSet.getString("deprerate"),user.getLanguage());/*残值率*/
	depreyear1 = Util.toScreenToEdit(RecordSet.getString("depreyear1"),user.getLanguage());/*折旧年限*/
	deprerate1 = Util.toScreenToEdit(RecordSet.getString("deprerate1"),user.getLanguage());/*残值率*/
	issupervision = Util.toScreenToEdit(RecordSet.getString("issupervision"),user.getLanguage());/*是否海关监管*/
	amountpay = Util.toScreenToEdit(RecordSet.getString("amountpay"),user.getLanguage());/*已付金额*/
	amountpay1 = Util.toScreenToEdit(RecordSet.getString("amountpay1"),user.getLanguage());/*已付金额*/
	purchasestate = Util.toScreenToEdit(RecordSet.getString("purchasestate"),user.getLanguage());/*采购状态*/
	
	datafield1 = Util.toScreenToEdit(RecordSet.getString("datafield1"),user.getLanguage());/*自定义日期类型*/
	datafield11 = Util.toScreenToEdit(RecordSet.getString("datafield11"),user.getLanguage());/*自定义日期类型*/
	datafield2 = Util.toScreenToEdit(RecordSet.getString("datafield2"),user.getLanguage());/*自定义日期类型*/
	datafield22 = Util.toScreenToEdit(RecordSet.getString("datafield22"),user.getLanguage());/*自定义日期类型*/
	datafield3 = Util.toScreenToEdit(RecordSet.getString("datafield3"),user.getLanguage());/*自定义日期类型*/
	datafield33 = Util.toScreenToEdit(RecordSet.getString("datafield33"),user.getLanguage());/*自定义日期类型*/
	datafield4 = Util.toScreenToEdit(RecordSet.getString("datafield4"),user.getLanguage());/*自定义日期类型*/
	datafield44 = Util.toScreenToEdit(RecordSet.getString("datafield44"),user.getLanguage());/*自定义日期类型*/
	datafield5 = Util.toScreenToEdit(RecordSet.getString("datafield5"),user.getLanguage());/*自定义日期类型*/
	datafield55 = Util.toScreenToEdit(RecordSet.getString("datafield55"),user.getLanguage());/*自定义日期类型*/	
		
	numberfield1 = Util.toScreenToEdit(RecordSet.getString("numberfield1"),user.getLanguage());/*自定义浮点数*/
	numberfield11 = Util.toScreenToEdit(RecordSet.getString("numberfield11"),user.getLanguage());/*自定义浮点数*/
	numberfield2 = Util.toScreenToEdit(RecordSet.getString("numberfield2"),user.getLanguage());/*自定义浮点数*/
	numberfield22 = Util.toScreenToEdit(RecordSet.getString("numberfield22"),user.getLanguage());/*自定义浮点数*/
	numberfield3 = Util.toScreenToEdit(RecordSet.getString("numberfield3"),user.getLanguage());/*自定义浮点数*/
	numberfield33 = Util.toScreenToEdit(RecordSet.getString("numberfield33"),user.getLanguage());/*自定义浮点数*/
	numberfield4 = Util.toScreenToEdit(RecordSet.getString("numberfield4"),user.getLanguage());/*自定义浮点数*/
	numberfield44 = Util.toScreenToEdit(RecordSet.getString("numberfield44"),user.getLanguage());/*自定义浮点数*/
	numberfield5 = Util.toScreenToEdit(RecordSet.getString("numberfield5"),user.getLanguage());/*自定义浮点数*/
	numberfield55 = Util.toScreenToEdit(RecordSet.getString("numberfield55"),user.getLanguage());/*自定义浮点数*/
		
	textfield1 = Util.toScreenToEdit(RecordSet.getString("textfield1"),user.getLanguage());/*自定义文本*/
	textfield2 = Util.toScreenToEdit(RecordSet.getString("textfield2"),user.getLanguage());/*自定义文本*/
	textfield3 = Util.toScreenToEdit(RecordSet.getString("textfield3"),user.getLanguage());/*自定义文本*/
	textfield4 = Util.toScreenToEdit(RecordSet.getString("textfield4"),user.getLanguage());/*自定义文本*/
	textfield5 = Util.toScreenToEdit(RecordSet.getString("textfield5"),user.getLanguage());/*自定义文本*/
	
	tinyintfield1 = Util.toScreenToEdit(RecordSet.getString("tinyintfield1"),user.getLanguage());/*自定义check框*/
	tinyintfield2 = Util.toScreenToEdit(RecordSet.getString("tinyintfield2"),user.getLanguage());/*自定义check框*/
	tinyintfield3 = Util.toScreenToEdit(RecordSet.getString("tinyintfield3"),user.getLanguage());/*自定义check框*/
	tinyintfield4 = Util.toScreenToEdit(RecordSet.getString("tinyintfield4"),user.getLanguage());/*自定义check框*/
	tinyintfield5 = Util.toScreenToEdit(RecordSet.getString("tinyintfield5"),user.getLanguage());/*自定义check框*/
		
	docff01name = Util.toScreenToEdit(RecordSet.getString("docff01name"),user.getLanguage());/*自定义多文档*/
	docff02name = Util.toScreenToEdit(RecordSet.getString("docff02name"),user.getLanguage());/*自定义多文档*/
	docff03name = Util.toScreenToEdit(RecordSet.getString("docff03name"),user.getLanguage());/*自定义多文档*/
	docff04name = Util.toScreenToEdit(RecordSet.getString("docff04name"),user.getLanguage());/*自定义多文档*/
	docff05name = Util.toScreenToEdit(RecordSet.getString("docff05name"),user.getLanguage());/*自定义多文档*/
		
	depff01name = Util.toScreenToEdit(RecordSet.getString("depff01name"),user.getLanguage());/*自定义多部门*/
	depff02name = Util.toScreenToEdit(RecordSet.getString("depff02name"),user.getLanguage());/*自定义多部门*/
	depff03name = Util.toScreenToEdit(RecordSet.getString("depff03name"),user.getLanguage());/*自定义多部门*/
	depff04name = Util.toScreenToEdit(RecordSet.getString("depff04name"),user.getLanguage());/*自定义多部门*/
	depff05name = Util.toScreenToEdit(RecordSet.getString("depff05name"),user.getLanguage());/*自定义多部门*/
		
	crmff01name = Util.toScreenToEdit(RecordSet.getString("crmff01name"),user.getLanguage());/*自定义多客户*/
	crmff02name = Util.toScreenToEdit(RecordSet.getString("crmff02name"),user.getLanguage());/*自定义多客户*/
	crmff03name = Util.toScreenToEdit(RecordSet.getString("crmff03name"),user.getLanguage());/*自定义多客户*/
	crmff04name = Util.toScreenToEdit(RecordSet.getString("crmff04name"),user.getLanguage());/*自定义多客户*/
	crmff05name = Util.toScreenToEdit(RecordSet.getString("crmff05name"),user.getLanguage());/*自定义多客户*/
		
	reqff01name = Util.toScreenToEdit(RecordSet.getString("reqff01name"),user.getLanguage());/*自定义多请求*/
	reqff02name = Util.toScreenToEdit(RecordSet.getString("reqff02name"),user.getLanguage());/*自定义多请求*/
	reqff03name = Util.toScreenToEdit(RecordSet.getString("reqff03name"),user.getLanguage());/*自定义多请求*/
	reqff04name = Util.toScreenToEdit(RecordSet.getString("reqff04name"),user.getLanguage());/*自定义多请求*/
	reqff05name = Util.toScreenToEdit(RecordSet.getString("reqff05name"),user.getLanguage());/*自定义多请求*/

} else {
	isdata = Util.null2String(request.getParameter("isdata"));
    resourceid = Util.null2String(request.getParameter("resourceid"));
    type = Util.null2String(request.getParameter("type"));
    if(type.equals("")) type="search";
}

String datafields[] = {datafield1,datafield11,datafield2,datafield22,datafield3,datafield33,datafield4,datafield44,datafield5,datafield55};
String numberfield[] = {numberfield1,numberfield11,numberfield2,numberfield22,numberfield3,numberfield33,numberfield4,numberfield44,numberfield5,numberfield55};
String textfield[] = {textfield1,textfield2,textfield3,textfield4,textfield5};
String tinyintfield[] = {tinyintfield1,tinyintfield2,tinyintfield3,tinyintfield4,tinyintfield5};
String docffs[] = {docff01name,docff02name,docff03name,docff04name,docff05name};
String depffs[] = {depff01name,depff02name,depff03name,depff04name,depff05name};
String crmffs[] = {crmff01name,crmff02name,crmff03name,crmff04name,crmff05name};
String reqffs[] = {reqff01name,reqff02name,reqff03name,reqff04name,reqff05name};

int rownum = 0;
int halfnum = 0;
if (isdata.equals(""))
	isdata = "1";

String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":";

if (isdata.equals("1")) 
	titlename = titlename + SystemEnv.getHtmlLabelName(1509,user.getLanguage());
else
	titlename = titlename + SystemEnv.getHtmlLabelName(535,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(advanced==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(342,user.getLanguage())+",javascript:onAdvanced(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(347,user.getLanguage())+",javascript:onAdvanced(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;
if(mouldid==0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:onSaveas(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
} 
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">

		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<FORM action=CptSearch.jsp method=post name=frmain>
			<input type=hidden name=type value="<%=type%>">
            <input type=hidden name=from value="<%=from%>">
			<TABLE border=0 cellPadding=0 cellSpacing=0 width="100%">
			<TBODY>
			<TR>
			<TD vAlign=top width="84%">
			<input type="hidden" name="advanced" value="<%=advanced%>">
			<input type="hidden" name="mouldid" value="<%=mouldid%>"> 
			<input type="hidden" name="operation">
			<TABLE class=ViewForm>
			<COLGROUP>
			<COL width="49%">
			<COL width=10>
			<COL width="49%">
			<TBODY>
			<TR>
			  <TD vAlign=top>
				  <TABLE width="100%">
					<COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
					<TR class=Title> 
					  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
					</TR>
					<TR class=Spacing style="height:1px;"> 
					  <TD class=Line1 colSpan=2></TD>
					</TR>

					 <!-- 资产或资料 -->
					 <%if(mouldid==0||!(isdata.equals("0"))){%>
                     <%if(!from.equals("cptmodify")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(15361,user.getLanguage())%></td>
					  <td class=Field> 
                        <select class=InputStyle id=isdata name=isdata>
						  <option value=2 <% if(isdata.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
						  <option value=1 <% if(isdata.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1509,user.getLanguage())%></option>
						</select>
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <%}else{%>
                           <input id=isdata type=hidden name=isdata value="2">
                      <%}%>
					<%}%> 

				<%
					if(mouldid==0){
						rs.executeSql("select * from CptSearchDefinition where isconditions = 1 and isseniorconditions = 0 and mouldid=-1 order by displayorder asc");	
					}else{
						rs.executeSql("select * from CptSearchDefinition where isconditions = 1 and isseniorconditions = 0 and mouldid="+mouldid+" order by displayorder asc");	
					}
					rownum = rs.getCounts();
					while(rs.next()){
						String fieldname = rs.getString("fieldname");
						halfnum++;
				%>		
					 

				<!-- 分段开始 分段代码-->
			<%if(halfnum==(rownum+2)/2){%>	
					</TBODY> 
				  </TABLE>
				</TD>
			  <TD vAlign=top width="100%">
				  <TABLE width="100%">
					<COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
					<TR class=Title> 
					  <TH colSpan=2>&nbsp;</TH>
					</TR>
					<TR class=Spacing style="height:1px;"> 
					  <TD class=Line1 colSpan=2></TD>
					</TR>
			<%}%>	
				<!-- 分段结束 -->

					
					<!-- 编号 -->
					<%if((mouldid==0||!(mark.equals("")))&&fieldname.equals("mark")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name="mark" value="<%=mark%>">
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%>  

					<!-- 财务编号 -->
					<%if((mouldid==0||!(fnamark.equals("")))&&fieldname.equals("fnamark")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name="fnamark" value="<%=fnamark%>">
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%>  


					<!-- 合同号 -->
					<%if((mouldid==0||!(contractno.equals("")))&&fieldname.equals("contractno")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name="contractno" value="<%=contractno%>">
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%> 

					<!-- 发票号码 -->
					<%if((mouldid==0||!(Invoice.equals("")))&&fieldname.equals("Invoice")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name="Invoice" value="<%=Invoice%>">
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%> 					

					<!-- 名称 -->
					 <%if((mouldid==0||!(name.equals("")))&&fieldname.equals("name")){%>
					<tr> 
					 <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
					 <td class=Field> 
					 	<input class=InputStyle maxlength=60 name="name" size=30 value="<%=name%>">
					 </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
					<%}%>

					<!-- 条形码 -->
					<%if((mouldid==0||!(barcode.equals("")))&&fieldname.equals("barcode")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name="barcode" value="<%=barcode%>">
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%> 

					<!-- 折旧年限 -->					
					<%if((mouldid==0||!(depreyear.equals(""))||!(depreyear1.equals("")))&&fieldname.equals("depreyear")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(19598,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=16 size=10 value="<%=depreyear%>" name="depreyear" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("depreyear")'>
					   -<input class=InputStyle maxlength=16 size=10 value="<%=depreyear1%>" name="depreyear1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("depreyear1")'>
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%> 					
					
					<!-- 残值率 -->					
					<%if((mouldid==0||!(deprerate.equals(""))||!(deprerate1.equals("")))&&fieldname.equals("deprerate")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%></td>
					<td class=Field>  
						<input class=InputStyle maxlength=16 size=10 value="<%=deprerate%>" name="deprerate" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("deprerate")'>
					   -<input class=InputStyle maxlength=16 size=10 value="<%=deprerate1%>" name="deprerate1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("deprerate1")'>
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%> 

					<!-- 是否海关监管 -->					
					<%if((mouldid==0||!(issupervision.equals("")))&&fieldname.equals("issupervision")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(22339,user.getLanguage())%></td>
					<td class=Field> 
						<select name="issupervision">
							<option value="1" <%if(issupervision.equals("0")){%>selected<%}%>></option>
							<option value="1" <%if(issupervision.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
							<option value="2" <%if(issupervision.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
						</select>
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%>					

					<!-- 资产组 -->
					<%if((mouldid==0||!(capitalgroupid.equals("0")||capitalgroupid.equals("")))&&fieldname.equals("capitalgroupid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
					   <td class=Field> <button type=button  class=Browser onClick="onShowCapitalgroupid()"></button> 
					  <span id=capitalgroupidspan ><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%>
					 </span> 
					 <input type=hidden name=capitalgroupid value="<%=capitalgroupid%>">
					 </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
					<%}%>

					<!-- 币种 -->
					<%if((mouldid==0||!(currencyid.equals("0")||currencyid.equals("")))&&fieldname.equals("currencyid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
					   <td class=Field> <button type=button  class=Browser onClick="onShowCurrencyID()"></button> 
					  <span id=currencyidspan ><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>
					 </span> 
					 <input type=hidden name=currencyid value="<%=currencyid%>">
					 </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
					<%}%>
					
					<!-- 价格/参考价格 -->
					<%if((mouldid==0||!(startprice.equals(""))||!(startprice1.equals("")))&&fieldname.equals("startprice")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=16 size=10 value="<%=startprice%>" name="startprice" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startprice")'>
					   -<input class=InputStyle maxlength=16 size=10 value="<%=startprice1%>" name="startprice1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startprice1")'>
						</td>
					</tr>
					<%}%>

					<!-- 已付金额 -->
					<%if((mouldid==0||!(amountpay.equals(""))||!(amountpay1.equals("")))&&fieldname.equals("amountpay")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(22338,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=16 size=10 value="<%=amountpay%>" name="amountpay" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("amountpay")'>
					   -<input class=InputStyle maxlength=16 size=10 value="<%=amountpay1%>" name="amountpay1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("amountpay1")'>
						</td>
					</tr>
					<%}%>
										
					<!-- 资产类型 -->
					<%if((mouldid==0||!(capitaltypeid.equals("0")||capitaltypeid.equals("")))&&fieldname.equals("capitaltypeid")){%>
				   <tr> 
					  <td><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowCapitaltypeid()"></button> 
						 <span id=capitaltypeidspan><%=Util.toScreen(CapitalTypeComInfo.getCapitalTypename(capitaltypeid),user.getLanguage())%></span> 
					   	 <input type=hidden name=capitaltypeid value="<%=capitaltypeid%>">
					 </td>
				   </tr>
				   <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
				   <%}%>

					<!-- 单独核算 -->
					<%if((mouldid==0||!(sptcount.equals("")))&&fieldname.equals("sptcount")){%>
				   <tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%></td>
					  <td class=Field>
					  	<input type=checkbox name=sptcount value="1" <%if(sptcount.equals("1")){%>checked<%}%>>
					 </td>
				   </tr>
				   <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
				   <%}%>

				<!-- 相关工作流 -->
					<%if((mouldid==0||!(relatewfid.equals("")||relatewfid.equals("0")))&&fieldname.equals("relatewfid")){%>
				   <tr> 
					  <td><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></td>
					  <td class=Field>
					  	  <button type=button  class=Browser onClick='onShowRequest("relatewfid","relatewfidspan")'></button>
						  <span id="relatewfidspan" name="relatewfidspan"></span>
						  <input type=hidden name="relatewfid" class=inputstyle>
					 </td>
				   </tr>
				   <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
				   <%}%>					

				<!-- 采购状态 -->
				<%if((mouldid==0||!(purchasestate.equals("")||purchasestate.equals("0")))&&fieldname.equals("purchasestate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(22333,user.getLanguage())%></td>
					  <td class=Field> 
							<SELECT name="purchasestate">
								<OPTION value="0" <%if(purchasestate.equals("0")){%>selected<%}%>></OPTION>
								<OPTION value="1" <%if(purchasestate.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22334,user.getLanguage())%></OPTION>
								<OPTION value="2" <%if(purchasestate.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22335,user.getLanguage())%></OPTION>
								<OPTION value="3" <%if(purchasestate.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22336,user.getLanguage())%></OPTION>
								<OPTION value="4" <%if(purchasestate.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22337,user.getLanguage())%></OPTION>
							</SELECT>
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					
				<!-- 帐内或帐外 -->
				<%if((mouldid==0||!(isinner.equals("0")||isinner.equals("")))&&fieldname.equals("isinner")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></td>
					  <td class=Field> 
						<select class=InputStyle id=isinner name=isinner>
						<option value=0 <% if(isinner.equals("")) {%>selected<%}%>></option>
						  <option value=1 <% if(isinner.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%></option>
						  <option value=2 <% if(isinner.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%></option>
						</select>
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>

					<!-- 生效日 -->
					<%if((mouldid==0||!(startdate.equals(""))||!(startdate1.equals("")))&&fieldname.equals("startdate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></td>
					  <td class=Field>
					  	<button type=button  class=Calendar id=selectstartdate onClick="getDate(startdatespan,startdate)"></button> 
						<span id=startdatespan ><%=startdate%></span> 
						<input type="hidden" name="startdate" value="<%=startdate%>">
					   -<button type=button  class=Calendar id=selectstartdate1 onClick="getDate(startdate1span,startdate1)"></button> 
						<span id=startdate1span ><%=startdate1%></span> 
						<input type="hidden" name="startdate1" value="<%=startdate1%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 生效至 -->
					<%if((mouldid==0||!(enddate.equals(""))||!(enddate1.equals("")))&&fieldname.equals("enddate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Calendar id=selectenddate onClick="getDate(enddatespan,enddate)"></button> 
						<span id=enddatespan ><%=enddate%></span> 
						<input type="hidden" name="enddate" value="<%=enddate%>">
						-<button type=button  class=Calendar id=selectenddate1 onClick="getDate(enddate1span,enddate1)"></button> 
						<span id=enddate1span ><%=enddate1%></span> 
						<input type="hidden" name="enddate1" value="<%=enddate1%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
					<%}%>
                    
                    <!-- 使用分部
					<%if((mouldid==0||!(departmentid.equals("0")||departmentid.equals("")))&&fieldname.equals("departmentid")){%>
                    <tr> 
                      <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
                      <td class=Field><button type=button  class=Browser id=SelectSubCompanyID onClick="onShowSubcompany('subcompanyidspan','subcompanyid')"></button> 
                        <span id="subcompanyidspan"></span> 
                        <input id=subcompanyid type=hidden name=subcompanyid>
                      </td>
                    </tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
                    -->

                    <!-- 使用部门-->
					<%if((mouldid==0||!(departmentid.equals("0")||departmentid.equals("")))&&fieldname.equals("departmentid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Browser id=SelectDeparment onClick="onShowDepartment('departmentid', 'departmentspan')"></button> 
						<span class=InputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
						<input id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>

                    <!-- 所属分部-->
					<%if((mouldid==0||!(blongsubcompany.equals("0")||blongsubcompany.equals("")))&&fieldname.equals("blongsubcompany")){%>
                    <tr> 
                      <td><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
                      <td class=Field><button type=button  class=Browser id=SelectSubCompanyID onClick="onShowSubcompany('blongsubcompanyspan','blongsubcompany')"></button> 
                        <span id="blongsubcompanyspan"></span> 
                        <input id=blongsubcompany type=hidden name=blongsubcompany>
                      </td>
                    </tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
                    
                    <!-- 所属部门-->
					<%if((mouldid==0||!(blongdepartment.equals("0")||blongdepartment.equals("")))&&fieldname.equals("blongdepartment")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Browser id=SelectDeparment onClick="onShowDepartment('blongdepartment', 'blongdepartmentspan')"></button> 
						<span class=InputStyle id=blongdepartmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(blongdepartment),user.getLanguage())%></span> 
						<input id=blongdepartment type=hidden name=blongdepartment value="<%=blongdepartment%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
										 
					 <!-- 人力资源/使用人/管理员 -->
					 <%if((mouldid==0||!(resourceid.equals("0")||resourceid.equals("")))&&fieldname.equals("resourceid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Browser id=SelectResourceID onClick="onShowResourceID()"></button> 
						<span id=resourceidspan><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></span> 
						<input class=InputStyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%>
            
						<!-- 计量单位 -->
						<%if((mouldid==0||!(stateid.equals("0")||stateid.equals("")))&&fieldname.equals("unitid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowLgcAssetUnit('unitid', 'unitidspan')"></button> 
						<span id=unitidspan><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())%></span> 
						<input type=hidden name=unitid value="<%=unitid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 数量 -->
					<%if((mouldid==0||!(capitalnum.equals(""))||!(capitalnum1.equals("")))&&fieldname.equals("capitalnum")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=10 size=10 value="<%=capitalnum%>" name="capitalnum" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("capitalnum")'>
					   -<input class=InputStyle maxlength=10 size=10 value="<%=capitalnum1%>" name="capitalnum1" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("capitalnum1")'>
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 当前数量 -->
					<%if((mouldid==0||!(currentnum.equals(""))||!(currentnum1.equals("")))&&fieldname.equals("currentnum")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1451,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=10 size=10 value="<%=currentnum%>" name="currentnum" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("currentnum")'>
					   -<input class=InputStyle maxlength=10 size=10 value="<%=currentnum1%>" name="currentnum1" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("currentnum1")'>
				</td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>

					<!-- 规格型号 -->
					<%if((mouldid==0||!(capitalspec.equals("")))&&fieldname.equals("capitalspec")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=60 size=30 value="<%=capitalspec%>" name="capitalspec">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 等级 -->
					<%if((mouldid==0||!(capitallevel.equals("")))&&fieldname.equals("capitallevel")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=30 size=30 value="<%=capitallevel%>" name="capitallevel">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 制造厂商 -->
					<%if((mouldid==0||!(manufacturer.equals("")))&&fieldname.equals("manufacturer")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1364,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=100 size=30 value="<%=manufacturer%>" name="manufacturer">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 出厂日期 -->
					<%if((mouldid==0||!(manudate.equals(""))||!(manudate1.equals("")))&&fieldname.equals("manudate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1365,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Calendar id=selectmanudate onClick="getDate(manudatespan,manudate)"></button> 
						<span id=manudatespan ><%=manudate%></span> 
						<input type="hidden" name="manudate" value="<%=manudate%>" >
					  -<button type=button  class=Calendar id=selectmanudate1 onClick="getDate(manudate1span,manudate1)"></button> 
						<span id=manudate1span ><%=manudate1%></span> 
						<input type="hidden" name="manudate1" value="<%=manudate1%>" >
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 供应商 -->
					<%if((mouldid==0||!(customerid.equals("0")||customerid.equals("")))&&fieldname.equals("customerid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowCustomerid()"></button> 
						<span id=customeridspan><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid),user.getLanguage())%></span> 
						<input type=hidden name=customerid value="<%=customerid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 属性 -->
					<%if((mouldid==0||!(attribute.equals("")))&&fieldname.equals("attribute")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
					  <td class=Field> 
						<select class=InputStyle id=attribute name=attribute>
						  <option></option>
						  <option value=0 <% if(attribute.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1366,user.getLanguage())%></option>
						  <option value=1 <% if(attribute.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())%></option>
						  <option value=2 <% if(attribute.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1368,user.getLanguage())%></option>
						  <option value=3 <% if(attribute.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1369,user.getLanguage())%></option>
						  <option value=4 <% if(attribute.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%></option>
						  <option value=5 <% if(attribute.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1370,user.getLanguage())%></option>
						  <option value=6 <% if(attribute.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
						</select>
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 状态 -->
					<%if((mouldid==0||!(stateid.equals("0")||stateid.equals("")))&&fieldname.equals("stateid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowStateid()"></button> 
						<span id=stateidspan><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(stateid),user.getLanguage())%></span> 
						<input type=hidden name=stateid value="<%=stateid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>

                    <!--入库日期-->
					<%if((mouldid==0||!(stockindate.equals(""))||!(stockindate1.equals("")))&&fieldname.equals("StockInDate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Calendar id=selectstockindate onClick="getDate(stockindatespan,stockindate)"></button> 
						<span id=stockindatespan ><%=stockindate%></span> 
						<input type="hidden" name="stockindate" value="<%=stockindate%>" >
					  -<button type=button  class=Calendar id=selectstockindate1 onClick="getDate(stockindate1span,stockindate1)"></button> 
						<span id=stockindate1span ><%=stockindate1%></span> 
						<input type="hidden" name="stockindate1" value="<%=stockindate1%>" >
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>

                    <!--购置日期-->
					<%if((mouldid==0 || !(SelectDate.equals("")) || !(SelectDate1.equals("")))&&fieldname.equals("SelectDate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></td>
					  <td class=Field>
					    <button type=button  class=Calendar id=bSelectDate onClick="getDate(SelectDatespan,SelectDate)"></button> 
						<span id=SelectDatespan ><%=SelectDate%></span> 
						<input type="hidden" name="SelectDate" value="<%=SelectDate%>" >
					  
					   -<button type=button  class=Calendar id=bSelectDate1 onClick="getDate(SelectDate1span,SelectDate1)"></button> 
						<span id=SelectDate1span ><%=SelectDate1%></span> 
						<input type="hidden" name="SelectDate1" value="<%=SelectDate1%>" >
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 替代 -->
					<%if((mouldid==0||!(replacecapitalid.equals("0")||replacecapitalid.equals("")))&&fieldname.equals("replacecapitalid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowReplacecapitalid()"></button> 
						<span id=replacecapitalidspan><%=Util.toScreen(CapitalComInfo.getCapitalname(replacecapitalid),user.getLanguage())%></span> 
						<input type=hidden name=replacecapitalid value="<%=replacecapitalid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 物品 -->
					<%if((mouldid==0||!(itemid.equals("0")))&&fieldname.equals("itemid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowLgcAsset('itemid', 'itemidspan')"></button> 
						<span id=itemidspan><%=Util.toScreen(AssetComInfo.getAssetName(itemid),user.getLanguage())%></span> 
						<input type=hidden name=itemid value="<%=itemid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
						<%}%>
					
					<!-- 存放地点 -->
					<%if((mouldid==0||!(location.equals("")))&&fieldname.equals("location")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=100 size=30 name=location value="<%=location%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 版本 -->
					<%if((mouldid==0||!(version.equals("")))&&fieldname.equals("version")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name=version value="<%=version%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
                    
                    <!--领用日期-->
					<%if((mouldid==0||!(deprestartdate.equals(""))||!(deprestartdate1.equals("")))&&fieldname.equals("deprestartdate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Calendar id=selectdeprestartdate onClick="getDate(deprestartdatespan,deprestartdate)"></button> 
						<span id=deprestartdatespan ><%=deprestartdate%></span> 
						<input type="hidden" name="deprestartdate" value="<%=deprestartdate%>" >
					  -<button type=button  class=Calendar id=selectdeprestartdate1 onClick="getDate(deprestartdate1span,deprestartdate1)"></button> 
						<span id=deprestartdate1span ><%=deprestartdate1%></span> 
						<input type="hidden" name="deprestartdate1" value="<%=deprestartdate1%>" >
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>


					<%
					
					RecordSet.executeProc("Base_FreeField_Select","cp");
					boolean hasFF = true;
					if(RecordSet.getCounts()<=0)
						hasFF = false;
					else
						RecordSet.first();
					
					if(hasFF)
					{
						for(int i=1;i<=5;i++)
						{//日期
							if(RecordSet.getString(i*2+1).equals("1")&&fieldname.equals("datefield"+i))
							{
							if(mouldid>0&&datafields[2*i-2].equals("")&&datafields[2*i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2)%></td>
								<td class=Field>
									<button type=button  class=Calendar id="selectdatafield<%=i%>" onClick="getDate(datafield<%=i%>span,datafield<%=i%>)"></button> 
									<span id="datafield<%=i%>span"><%=datafields[2*i-2]%></span> 
									<input type="hidden" name="datafield<%=i%>" value="<%=datafields[2*i-2]%>">
								   -<button type=button  class=Calendar id="selectdatafield<%=i%>1" onClick="getDate(datafield<%=i%>1span,datafield<%=i%>1)"></button> 
									<span id="datafield<%=i%>1span" ><%=datafields[2*i-1]%></span> 
									<input type="hidden" name="datafield<%=i%>1" value="<%=datafields[2*i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//数字
							if(RecordSet.getString(i*2+11).equals("1")&&fieldname.equals("numberfield"+i))
							{
							if(mouldid>0&&numberfield[2*i-2].equals("")&&numberfield[2*i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+10)%></td>
								<td class=Field> 
								  <input class=InputStyle maxlength=16 size=10 value="<%=numberfield[2*i-2]%>" name="numberfield<%=i%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numberfield<%=i%>")'>
					             -<input class=InputStyle maxlength=16 size=10 value="<%=numberfield[2*i-1]%>" name="numberfield<%=i%>1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numberfield<%=i%>1")'>
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>			
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//文本
							if(RecordSet.getString(i*2+21).equals("1")&&fieldname.equals("textfield"+i))
							{
							if(mouldid>0&&textfield[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+20)%></td>
								<td class=Field> 
								  <input class=InputStyle maxlength=100 size=30 name="textfield<%=i%>" value="<%=textfield[i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//checkbox
							if(RecordSet.getString(i*2+31).equals("1")&&fieldname.equals("tinyintfield"+i))
							{
							if(mouldid>0&&tinyintfield[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+30)%></td>
								<td class=Field> 
								  <input type=checkbox  name="tinyintfield<%=i%>" value="1" <%if(tinyintfield[i-1].equals("1")){%>checked<%}%>>
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//多文档
							if(RecordSet.getString(i*2+41).equals("1")&&fieldname.equals("docff0"+i+"name"))
							{
							if(mouldid>0&&docffs[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+40)%></td>
								<td class=Field> 
								  <button type=button  class=Browser onClick='onShowMDocid("docff0<%=i%>name","docff0<%=i%>namespan")'></button>
								  <span name="docff0<%=i%>namespan" id="docff0<%=i%>namespan">
									<%
									  	String tempdoc[] = Util.TokenizerString2(docffs[i-1],",");
									  	if(tempdoc!=null){
									  		for(int j=0;j<tempdoc.length;j++)
									  		out.println("<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+tempdoc[j]+"')>"+DocComInfo.getDocname(tempdoc[j])+"</a> ");
									  	}
								   %>
								  </span>
								  <input type=hidden name="docff0<%=i%>name" class=inputstyle value="<%=docffs[i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//多部门
							if(RecordSet.getString(i*2+51).equals("1")&&fieldname.equals("depff0"+i+"name"))
							{
							if(mouldid>0&&depffs[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+50)%></td>
								<td class=Field> 
								  <button type=button  class=Browser onClick='onShowDepartmentMutil("depff0<%=i%>namespan","depff0<%=i%>name")'></button>
								  <SPAN id="depff0<%=i%>namespan" name="depff0<%=i%>namespan">
								  <%
								  	String tempdep[] = Util.TokenizerString2(depffs[i-1],",");
								  	if(tempdep!=null){
								  		for(int j=0;j<tempdep.length;j++)
								  		out.println(DepartmentComInfo.getDepartmentname(tempdep[j])+" ");
								  	}
								  %>
								  </SPAN>
								  <input type=hidden name="depff0<%=i%>name" class=inputstyle value="<%=depffs[i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//多客户
							if(RecordSet.getString(i*2+61).equals("1")&&fieldname.equals("crmff0"+i+"name"))
							{
							if(mouldid>0&&crmffs[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+60)%></td>
								<td class=Field> 
								  <button type=button  class=Browser onClick='onShowCRM("crmff0<%=i%>name","crmff0<%=i%>namespan")'></button>
								  <span id="crmff0<%=i%>namespan" name="crmff0<%=i%>namespan">
								  <%
								  	String tempcrm[] = Util.TokenizerString2(crmffs[i-1],",");
								  	if(tempcrm!=null){
								  		for(int j=0;j<tempcrm.length;j++)
								  		out.println("<a href=javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID="+tempcrm[j]+"')>"+CustomerInfoComInfo.getCustomerInfoname(tempcrm[j])+"</a> ");
								  	}
								  %>								  
								  </span>
								  <input type=hidden name="crmff0<%=i%>name" class=inputstyle value="<%=crmffs[i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//多请求
							if(RecordSet.getString(i*2+71).equals("1")&&fieldname.equals("reqffo"+i+"name"))
							{
							if(mouldid>0&&reqffs[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+70)%></td>
								<td class=Field> 
								  <button type=button  class=Browser onClick='onShowRequest("reqff0<%=i%>name","reqff0<%=i%>namespan")'></button>
								  <span id="reqff0<%=i%>namespan" name="reqff0<%=i%>namespan">
								  <%
								  	String tempreq[] = Util.TokenizerString2(reqffs[i-1],",");
								  	if(tempreq!=null){
								  		for(int j=0;j<tempreq.length;j++)
								  		out.println("<a href=javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="+tempreq[j]+"')>"+WorkflowRequestComInfo.getRequestName(tempreq[j])+"</a> ");
								  	}
								  %>								  
								  </span>
								  <input type=hidden name="reqff0<%=i%>name" class=inputstyle value="<%=reqffs[i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
					}
			%>


			<%}%>



					</TBODY> 
				  </TABLE>
				</TD></TR>

<!-- ===========高级=========== -->

			<%if(advanced==1){ //高级%>

			<TR>
			  <TD vAlign=top>
				  <TABLE width="100%">
					<COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
					<TR class=Title> 
					  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%></TH>
					</TR>
					<TR class=Spacing style="height:1px;"> 
					  <TD class=Line1 colSpan=2></TD>
					</TR>
					

					
				<%
					if(mouldid==0){
						rs.executeSql("select * from CptSearchDefinition where isconditions = 1 and isseniorconditions = 1 and mouldid=-1 order by displayorder asc");	
					}else{
						rs.executeSql("select * from CptSearchDefinition where isconditions = 1 and isseniorconditions = 1 and mouldid="+mouldid+" order by displayorder asc");	
					}
					rownum = rs.getCounts();
					halfnum = 0;
					while(rs.next()){
						String fieldname = rs.getString("fieldname");
						halfnum++;
				%>		
					 
				<!-- 分段开始 分段代码-->
			<%if(halfnum==(rownum+3)/2){%>	
					</TBODY> 
				  </TABLE>
				</TD>
			  <TD vAlign=top>
				  <TABLE width="100%">
					<COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
					<TR class=Title> 
					  <TH colSpan=2>&nbsp;</TH>
					</TR>
					<TR class=Spacing style="height:1px;"> 
					  <TD class=Line1 colSpan=2></TD>
					</TR>
			<%}%>	
				<!-- 分段结束 -->

					
					<!-- 编号 -->
					<%if((mouldid==0||!(mark.equals("")))&&fieldname.equals("mark")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name="mark" value="<%=mark%>">
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%>  

					<!-- 财务编号 -->
					<%if((mouldid==0||!(fnamark.equals("")))&&fieldname.equals("fnamark")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name="fnamark" value="<%=fnamark%>">
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%>  


					<!-- 合同号 -->
					<%if((mouldid==0||!(contractno.equals("")))&&fieldname.equals("contractno")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name="contractno" value="<%=contractno%>">
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%> 

					<!-- 发票号码 -->
					<%if((mouldid==0||!(Invoice.equals("")))&&fieldname.equals("Invoice")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name="Invoice" value="<%=Invoice%>">
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%> 					

					<!-- 名称 -->
					 <%if((mouldid==0||!(name.equals("")))&&fieldname.equals("name")){%>
					<tr> 
					 <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
					 <td class=Field> 
					 	<input class=InputStyle maxlength=60 name="name" size=30 value="<%=name%>">
					 </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
					<%}%>

					<!-- 条形码 -->
					<%if((mouldid==0||!(barcode.equals("")))&&fieldname.equals("barcode")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name="barcode" value="<%=barcode%>">
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%> 

					<!-- 折旧年限 -->					
					<%if((mouldid==0||!(depreyear.equals(""))||!(depreyear1.equals("")))&&fieldname.equals("depreyear")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(19598,user.getLanguage())%></td>
					<td class=Field> 
						<input class=InputStyle maxlength=16 size=10 value="<%=depreyear%>" name="depreyear" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("depreyear")'>
					   -<input class=InputStyle maxlength=16 size=10 value="<%=depreyear1%>" name="depreyear1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("depreyear1")'>
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%> 					
					
					<!-- 残值率 -->					
					<%if((mouldid==0||!(deprerate.equals(""))||!(deprerate1.equals("")))&&fieldname.equals("deprerate")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%></td>
					<td class=Field>  
						<input class=InputStyle maxlength=16 size=10 value="<%=deprerate%>" name="deprerate" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("deprerate")'>
					   -<input class=InputStyle maxlength=16 size=10 value="<%=deprerate1%>" name="deprerate1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("deprerate1")'>
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%> 

					<!-- 是否海关监管 -->					
					<%if((mouldid==0||!(issupervision.equals("")))&&fieldname.equals("issupervision")){%>
					<tr> 
					<td><%=SystemEnv.getHtmlLabelName(22339,user.getLanguage())%></td>
					<td class=Field> 
						<select name="issupervision">
							<option value="1" <%if(issupervision.equals("0")){%>selected<%}%>></option>
							<option value="1" <%if(issupervision.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
							<option value="2" <%if(issupervision.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
						</select>
					</td>
					 </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%>					

					<!-- 资产组 -->
					<%if((mouldid==0||!(capitalgroupid.equals("0")))&&fieldname.equals("capitalgroupid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
					   <td class=Field> <button type=button  class=Browser onClick="onShowCapitalgroupid()"></button> 
					  <span id=capitalgroupidspan ><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%>
					 </span> 
					 <input type=hidden name=capitalgroupid value="<%=capitalgroupid%>">
					 </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
					<%}%>

					<!-- 币种 -->
					<%if((mouldid==0||!(currencyid.equals("0")))&&fieldname.equals("currencyid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
					   <td class=Field> <button type=button  class=Browser onClick="onShowCurrencyID()"></button> 
					  <span id=currencyidspan ><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>
					 </span> 
					 <input type=hidden name=currencyid value="<%=currencyid%>">
					 </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
					<%}%>
					
					<!-- 价格/参考价格 -->
					<%if((mouldid==0||!(startprice.equals(""))||!(startprice1.equals("")))&&fieldname.equals("startprice")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=16 size=10 value="<%=startprice%>" name="startprice" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startprice")'>
					   -<input class=InputStyle maxlength=16 size=10 value="<%=startprice1%>" name="startprice1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startprice1")'>
						</td>
					</tr>
					<%}%>

					<!-- 已付金额 -->
					<%if((mouldid==0||!(amountpay.equals(""))||!(amountpay1.equals("")))&&fieldname.equals("amountpay")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(22338,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=16 size=10 value="<%=amountpay%>" name="amountpay" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("amountpay")'>
					   -<input class=InputStyle maxlength=16 size=10 value="<%=amountpay1%>" name="amountpay1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("amountpay1")'>
						</td>
					</tr>
					<%}%>
										
					<!-- 资产类型 -->
					<%if((mouldid==0||!(capitaltypeid.equals("0")))&&fieldname.equals("capitaltypeid")){%>
				   <tr> 
					  <td><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowCapitaltypeid()"></button> 
						 <span id=capitaltypeidspan><%=Util.toScreen(CapitalTypeComInfo.getCapitalTypename(capitaltypeid),user.getLanguage())%></span> 
					   	 <input type=hidden name=capitaltypeid value="<%=capitaltypeid%>">
					 </td>
				   </tr>
				   <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
				   <%}%>

					<!-- 单独核算 -->
					<%if((mouldid==0||!(sptcount.equals("")))&&fieldname.equals("sptcount")){%>
				   <tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%></td>
					  <td class=Field>
					  	<input type=checkbox name=sptcount value="1" <%if(sptcount.equals("1")){%>checked<%}%>>
					 </td>
				   </tr>
				   <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
				   <%}%>

				<!-- 相关工作流 -->
					<%if((mouldid==0||!(relatewfid.equals("")))&&fieldname.equals("relatewfid")){%>
				   <tr> 
					  <td><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></td>
					  <td class=Field>
					  	  <button type=button  class=Browser onClick='onShowRequest("relatewfid","relatewfidspan")'></button>
						  <span id="relatewfidspan" name="relatewfidspan"></span>
						  <input type=hidden name="relatewfid" class=inputstyle>
					 </td>
				   </tr>
				   <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
				   <%}%>					

				<!-- 采购状态 -->
				<%if((mouldid==0||!(purchasestate.equals("")))&&fieldname.equals("purchasestate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(22333,user.getLanguage())%></td>
					  <td class=Field> 
							<SELECT name="purchasestate">
								<OPTION value="0" <%if(purchasestate.equals("0")){%>selected<%}%>></OPTION>
								<OPTION value="1" <%if(purchasestate.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22334,user.getLanguage())%></OPTION>
								<OPTION value="2" <%if(purchasestate.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22335,user.getLanguage())%></OPTION>
								<OPTION value="3" <%if(purchasestate.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22336,user.getLanguage())%></OPTION>
								<OPTION value="4" <%if(purchasestate.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22337,user.getLanguage())%></OPTION>
							</SELECT>
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					
				<!-- 帐内或帐外 -->
				<%if((mouldid==0||!(isinner.equals("0")))&&fieldname.equals("isinner")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></td>
					  <td class=Field> 
						<select class=InputStyle id=isinner name=isinner>
						<option value=0 <% if(isinner.equals("")) {%>selected<%}%>></option>
						  <option value=1 <% if(isinner.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%></option>
						  <option value=2 <% if(isinner.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%></option>
						</select>
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>

					<!-- 生效日 -->
					<%if((mouldid==0||!(startdate.equals(""))||!(startdate1.equals("")))&&fieldname.equals("startdate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></td>
					  <td class=Field>
					  	<button type=button  class=Calendar id=selectstartdate onClick="getDate(startdatespan,startdate)"></button> 
						<span id=startdatespan ><%=startdate%></span> 
						<input type="hidden" name="startdate" value="<%=startdate%>">
					   -<button type=button  class=Calendar id=selectstartdate1 onClick="getDate(startdate1span,startdate1)"></button> 
						<span id=startdate1span ><%=startdate1%></span> 
						<input type="hidden" name="startdate1" value="<%=startdate1%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 生效至 -->
					<%if((mouldid==0||!(enddate.equals(""))||!(enddate1.equals("")))&&fieldname.equals("enddate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Calendar id=selectenddate onClick="getDate(enddatespan,enddate)"></button> 
						<span id=enddatespan ><%=enddate%></span> 
						<input type="hidden" name="enddate" value="<%=enddate%>">
						-<button type=button  class=Calendar id=selectenddate1 onClick="getDate(enddate1span,enddate1)"></button> 
						<span id=enddate1span ><%=enddate1%></span> 
						<input type="hidden" name="enddate1" value="<%=enddate1%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					</TR>
					<%}%>
                    
                    <!-- 使用分部
					<%if(mouldid==0&&fieldname.equals("departmentid")){%>
                    <tr> 
                      <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
                      <td class=Field><button type=button  class=Browser id=SelectSubCompanyID onClick="onShowSubcompany('subcompanyidspan','subcompanyid')"></button> 
                        <span id="subcompanyidspan"></span> 
                        <input id=subcompanyid type=hidden name=subcompanyid>
                      </td>
                    </tr>
					<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
                    -->
                    
                    <!-- 使用部门-->
					<%if((mouldid==0||!(departmentid.equals("0")))&&fieldname.equals("departmentid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Browser id=SelectDeparment onClick="onShowDepartment('departmentid', 'departmentspan')"></button> 
						<span class=InputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
						<input id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>

                    <!-- 所属分部-->
					<%if((mouldid==0||!(blongsubcompany.equals("0")||blongsubcompany.equals("")))&&fieldname.equals("blongsubcompany")){%>
                    <tr> 
                      <td><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
                      <td class=Field><button type=button  class=Browser id=SelectSubCompanyID onClick="onShowSubcompany('blongsubcompanyspan','blongsubcompany')"></button> 
                        <span id="blongsubcompanyspan"></span> 
                        <input id=blongsubcompany type=hidden name=blongsubcompany>
                      </td>
                    </tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
                    
                    <!-- 所属部门-->
					<%if((mouldid==0||!(blongdepartment.equals("0")||blongdepartment.equals("")))&&fieldname.equals("blongdepartment")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Browser id=SelectDeparment onClick="onShowDepartment('blongdepartment', 'blongdepartmentspan')"></button> 
						<span class=InputStyle id=blongdepartmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(blongdepartment),user.getLanguage())%></span> 
						<input id=blongdepartment type=hidden name=blongdepartment value="<%=blongdepartment%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
										 
					 <!-- 人力资源/使用人/管理员 -->
					 <%if((mouldid==0||!(resourceid.equals("0")))&&fieldname.equals("resourceid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Browser id=SelectResourceID onClick="onShowResourceID()"></button> 
						<span id=resourceidspan><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></span> 
						<input class=InputStyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					 <%}%>
            
						<!-- 计量单位 -->
						<%if((mouldid==0||!(stateid.equals("0")))&&fieldname.equals("unitid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowLgcAssetUnit('unitid', 'unitidspan')"></button> 
						<span id=unitidspan><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())%></span> 
						<input type=hidden name=unitid value="<%=unitid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 数量 -->
					<%if((mouldid==0||!(capitalnum.equals(""))||!(capitalnum1.equals("")))&&fieldname.equals("capitalnum")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=10 size=10 value="<%=capitalnum%>" name="capitalnum" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("capitalnum")'>
					   -<input class=InputStyle maxlength=10 size=10 value="<%=capitalnum1%>" name="capitalnum1" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("capitalnum1")'>
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 当前数量 -->
					<%if((mouldid==0||!(currentnum.equals(""))||!(currentnum1.equals("")))&&fieldname.equals("currentnum")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1451,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=10 size=10 value="<%=currentnum%>" name="currentnum" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("currentnum")'>
					   -<input class=InputStyle maxlength=10 size=10 value="<%=currentnum1%>" name="currentnum1" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("currentnum1")'>
				</td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>

					<!-- 规格型号 -->
					<%if((mouldid==0||!(capitalspec.equals("")))&&fieldname.equals("capitalspec")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=60 size=30 value="<%=capitalspec%>" name="capitalspec">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 等级 -->
					<%if((mouldid==0||!(capitallevel.equals("")))&&fieldname.equals("capitallevel")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=30 size=30 value="<%=capitallevel%>" name="capitallevel">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 制造厂商 -->
					<%if((mouldid==0||!(manufacturer.equals("")))&&fieldname.equals("manufacturer")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1364,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=100 size=30 value="<%=manufacturer%>" name="manufacturer">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 出厂日期 -->
					<%if((mouldid==0||!(manudate.equals(""))||!(manudate1.equals("")))&&fieldname.equals("manudate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1365,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Calendar id=selectmanudate onClick="getDate(manudatespan,manudate)"></button> 
						<span id=manudatespan ><%=manudate%></span> 
						<input type="hidden" name="manudate" value="<%=manudate%>" >
					  -<button type=button  class=Calendar id=selectmanudate1 onClick="getDate(manudate1span,manudate1)"></button> 
						<span id=manudate1span ><%=manudate1%></span> 
						<input type="hidden" name="manudate1" value="<%=manudate1%>" >
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 供应商 -->
					<%if((mouldid==0||!(customerid.equals("0")))&&fieldname.equals("customerid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowCustomerid()"></button> 
						<span id=customeridspan><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid),user.getLanguage())%></span> 
						<input type=hidden name=customerid value="<%=customerid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 属性 -->
					<%if((mouldid==0||!(attribute.equals("")))&&fieldname.equals("attribute")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
					  <td class=Field> 
						<select class=InputStyle id=attribute name=attribute>
						  <option></option>
						  <option value=0 <% if(attribute.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1366,user.getLanguage())%></option>
						  <option value=1 <% if(attribute.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())%></option>
						  <option value=2 <% if(attribute.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1368,user.getLanguage())%></option>
						  <option value=3 <% if(attribute.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1369,user.getLanguage())%></option>
						  <option value=4 <% if(attribute.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%></option>
						  <option value=5 <% if(attribute.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1370,user.getLanguage())%></option>
						  <option value=6 <% if(attribute.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
						</select>
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 状态 -->
					<%if((mouldid==0||!(stateid.equals("0")))&&fieldname.equals("stateid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowStateid()"></button> 
						<span id=stateidspan><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(stateid),user.getLanguage())%></span> 
						<input type=hidden name=stateid value="<%=stateid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>

                    <!--入库日期-->
					<%if((mouldid==0 || !(stockindate.equals("")) || !(stockindate1.equals("")))&&fieldname.equals("StockInDate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Calendar id=selectstockindate onClick="getDate(stockindatespan,stockindate)"></button> 
						<span id=stockindatespan ><%=stockindate%></span> 
						<input type="hidden" name="stockindate" value="<%=stockindate%>" >
					  -<button type=button  class=Calendar id=selectstockindate1 onClick="getDate(stockindate1span,stockindate1)"></button> 
						<span id=stockindate1span ><%=stockindate1%></span> 
						<input type="hidden" name="stockindate1" value="<%=stockindate1%>" >
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>

                    <!--购置日期-->
					<%if((mouldid==0 || !(SelectDate.equals("")) || !(SelectDate1.equals("")))&&fieldname.equals("SelectDate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></td>
					  <td class=Field>
					    <button type=button  class=Calendar id=bSelectDate onClick="getDate(SelectDatespan,SelectDate)"></button> 
						<span id=SelectDatespan ><%=SelectDate%></span> 
						<input type="hidden" name="SelectDate" value="<%=SelectDate%>" >
					  
					   -<button type=button  class=Calendar id=bSelectDate1 onClick="getDate(SelectDate1span,SelectDate1)"></button> 
						<span id=SelectDate1span ><%=SelectDate1%></span> 
						<input type="hidden" name="SelectDate1" value="<%=SelectDate1%>" >
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 替代 -->
					<%if((mouldid==0||!(replacecapitalid.equals("0")))&&fieldname.equals("replacecapitalid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowReplacecapitalid()"></button> 
						<span id=replacecapitalidspan><%=Util.toScreen(CapitalComInfo.getCapitalname(replacecapitalid),user.getLanguage())%></span> 
						<input type=hidden name=replacecapitalid value="<%=replacecapitalid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 物品 -->
					<%if((mouldid==0||!(itemid.equals("0")))&&fieldname.equals("itemid")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowLgcAsset('itemid', 'itemidspan')"></button> 
						<span id=itemidspan><%=Util.toScreen(AssetComInfo.getAssetName(itemid),user.getLanguage())%></span> 
						<input type=hidden name=itemid value="<%=itemid%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
						<%}%>
					
					<!-- 存放地点 -->
					<%if((mouldid==0||!(location.equals("")))&&fieldname.equals("location")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=100 size=30 name=location value="<%=location%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					
					<!-- 版本 -->
					<%if((mouldid==0||!(version.equals("")))&&fieldname.equals("version")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></td>
					  <td class=Field> 
						<input class=InputStyle maxlength=60 size=30 name=version value="<%=version%>">
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
                    
                    <!--领用日期-->
					<%if((mouldid==0||!(deprestartdate.equals(""))||!(deprestartdate1.equals("")))&&fieldname.equals("deprestartdate")){%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Calendar id=selectdeprestartdate onClick="getDate(deprestartdatespan,deprestartdate)"></button> 
						<span id=deprestartdatespan ><%=deprestartdate%></span> 
						<input type="hidden" name="deprestartdate" value="<%=deprestartdate%>" >
					  -<button type=button  class=Calendar id=selectdeprestartdate1 onClick="getDate(deprestartdate1span,deprestartdate1)"></button> 
						<span id=deprestartdate1span ><%=deprestartdate1%></span> 
						<input type="hidden" name="deprestartdate1" value="<%=deprestartdate1%>" >
					  </td>
					</tr>
					<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>


					<%
					
					RecordSet.executeProc("Base_FreeField_Select","cp");
					boolean hasFF = true;
					if(RecordSet.getCounts()<=0)
						hasFF = false;
					else
						RecordSet.first();
					
					if(hasFF)
					{
						for(int i=1;i<=5;i++)
						{//日期
							if(RecordSet.getString(i*2+1).equals("1")&&fieldname.equals("datefield"+i))
							{
							if(mouldid>0&&datafields[2*i-2].equals("")&&datafields[2*i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2)%></td>
								<td class=Field>
									<button type=button  class=Calendar id="selectdatafield<%=i%>" onClick="getDate(datafield<%=i%>span,datafield<%=i%>)"></button> 
									<span id="datafield<%=i%>span"><%=datafields[2*i-2]%></span> 
									<input type="hidden" name="datafield<%=i%>" value="<%=datafields[2*i-2]%>">
								   -<button type=button  class=Calendar id="selectdatafield<%=i%>1" onClick="getDate(datafield<%=i%>1span,datafield<%=i%>1)"></button> 
									<span id="datafield<%=i%>1span" ><%=datafields[2*i-1]%></span> 
									<input type="hidden" name="datafield<%=i%>1" value="<%=datafields[2*i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//数字
							if(RecordSet.getString(i*2+11).equals("1")&&fieldname.equals("numberfield"+i))
							{
							if(mouldid>0&&numberfield[2*i-2].equals("")&&numberfield[2*i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+10)%></td>
								<td class=Field> 
								  <input class=InputStyle maxlength=16 size=10 value="<%=numberfield[2*i-2]%>" name="numberfield<%=i%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numberfield<%=i%>")'>
					             -<input class=InputStyle maxlength=16 size=10 value="<%=numberfield[2*i-1]%>" name="numberfield<%=i%>1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numberfield<%=i%>1")'>
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>			
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//文本
							if(RecordSet.getString(i*2+21).equals("1")&&fieldname.equals("textfield"+i))
							{
							if(mouldid>0&&textfield[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+20)%></td>
								<td class=Field> 
								  <input class=InputStyle maxlength=100 size=30 name="textfield<%=i%>" value="<%=textfield[i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//checkbox
							if(RecordSet.getString(i*2+31).equals("1")&&fieldname.equals("tinyintfield"+i))
							{
							if(mouldid>0&&tinyintfield[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+30)%></td>
								<td class=Field> 
								  <input type=checkbox  name="tinyintfield<%=i%>" value="1" <%if(tinyintfield[i-1].equals("1")){%>checked<%}%>>
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//多文档
							if(RecordSet.getString(i*2+41).equals("1")&&fieldname.equals("docff0"+i+"name"))
							{
							if(mouldid>0&&docffs[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+40)%></td>
								<td class=Field> 
								  <button type=button  class=Browser onClick='onShowMDocid("docff0<%=i%>name","docff0<%=i%>namespan")'></button>
								  <span name="docff0<%=i%>namespan" id="docff0<%=i%>namespan">
									<%
									  	String tempdoc[] = Util.TokenizerString2(docffs[i-1],",");
									  	if(tempdoc!=null){
									  		for(int j=0;j<tempdoc.length;j++)
									  		out.println("<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+tempdoc[j]+"')>"+DocComInfo.getDocname(tempdoc[j])+"</a> ");
									  	}
								   %>
								  </span>
								  <input type=hidden name="docff0<%=i%>name" class=inputstyle value="<%=docffs[i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//多部门
							if(RecordSet.getString(i*2+51).equals("1")&&fieldname.equals("depff0"+i+"name"))
							{
							if(mouldid>0&&depffs[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+50)%></td>
								<td class=Field> 
								  <button type=button  class=Browser onClick='onShowDepartmentMutil("depff0<%=i%>namespan","depff0<%=i%>name")'></button>
								  <SPAN id="depff0<%=i%>namespan" name="depff0<%=i%>namespan">
								  <%
								  	String tempdep[] = Util.TokenizerString2(depffs[i-1],",");
								  	if(tempdep!=null){
								  		for(int j=0;j<tempdep.length;j++)
								  		out.println(DepartmentComInfo.getDepartmentname(tempdep[j])+" ");
								  	}
								  %>
								  </SPAN>
								  <input type=hidden name="depff0<%=i%>name" class=inputstyle value="<%=depffs[i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//多客户
							if(RecordSet.getString(i*2+61).equals("1")&&fieldname.equals("crmff0"+i+"name"))
							{
							if(mouldid>0&&crmffs[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+60)%></td>
								<td class=Field> 
								  <button type=button  class=Browser onClick='onShowCRM("crmff0<%=i%>name","crmff0<%=i%>namespan")'></button>
								  <span id="crmff0<%=i%>namespan" name="crmff0<%=i%>namespan">
								  <%
								  	String tempcrm[] = Util.TokenizerString2(crmffs[i-1],",");
								  	if(tempcrm!=null){
								  		for(int j=0;j<tempcrm.length;j++)
								  		out.println("<a href=javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID="+tempcrm[j]+"')>"+CustomerInfoComInfo.getCustomerInfoname(tempcrm[j])+"</a> ");
								  	}
								  %>								  
								  </span>
								  <input type=hidden name="crmff0<%=i%>name" class=inputstyle value="<%=crmffs[i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
						for(int i=1;i<=5;i++)
						{//多请求
							if(RecordSet.getString(i*2+71).equals("1")&&fieldname.equals("reqffo"+i+"name"))
							{
							if(mouldid>0&&reqffs[i-1].equals("")) continue;
							%>
							  <tr> 
								<td><%=RecordSet.getString(i*2+70)%></td>
								<td class=Field> 
								  <button type=button  class=Browser onClick='onShowRequest("reqff0<%=i%>name","reqff0<%=i%>namespan")'></button>
								  <span id="reqff0<%=i%>namespan" name="reqff0<%=i%>namespan">
								  <%
								  	String tempreq[] = Util.TokenizerString2(reqffs[i-1],",");
								  	if(tempreq!=null){
								  		for(int j=0;j<tempreq.length;j++)
								  		out.println("<a href=javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="+tempreq[j]+"')>"+WorkflowRequestComInfo.getRequestName(tempreq[j])+"</a> ");
								  	}	
								  %>								  
								  </span>
								  <input type=hidden name="reqff0<%=i%>name" class=inputstyle value="<%=reqffs[i-1]%>">
								</td>
							  </tr>
								<TR style="height:1px;"> 
								<TD class=Line colSpan=2></TD>
							  </TR>
							  <%}
						}
					}
			%>


			<%}%>	









					</TBODY> 
				  </TABLE>
				</TD></TR>
							 <%}//end of advanced judgement%>
				</TBODY></TABLE><!-- Columns --></TD>
			<TD style="BACKGROUND-COLOR: rgb(216,236,239)" vAlign=top width="16%">
			<TABLE class=ListShort>
			<TBODY>
			<TR>
			  <TH><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></TH></TR>
			 <TR class=DataLight>
			  <TD><a href="CptSearch.jsp?mouldid=0"><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></a></TD></TR>
			<% 
			int i=0;
			userid =user.getUID();
			RecordSet.executeProc("CptSearchMould_SelectByUserID",""+userid);
			while(RecordSet.next()){
			String tempid = RecordSet.getString("id");
			String tempmouldname = RecordSet.getString("mouldname");
				if(i==0){%><TR class=DataDark><%i=1;}
				else{%><TR class=DataLight><%i=0;}%>
			  <td><a href="CptSearch.jsp?mouldid=<%=tempid%>&advanced=1"><%=Util.toScreen(tempmouldname,user.getLanguage())%></a></td>
			</TR>
			<%}
			if(mouldid==0){%>
			<TR>
			  <TD><INPUT type="text" name="newmould"  size=15 onChange="checkinput('newmould','newmouldspan')" class="InputStyle">
			  <span id=newmouldspan><IMG src="/images/BacoError.gif" align=absMiddle></span></TD>
			</TR>
			<%}%>  
			</TBODY>
			</TABLE>
			</TD></TR>
			</TBODY>
			</TABLE>
			</FORM>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<SCRIPT language=javascript>
function onSearch(){
	document.frmain.action="SearchOperation.jsp";
	frmain.submit();
}
function onAdvanced(){
	if(document.frmain.advanced.value=='1'){
		document.frmain.advanced.value='0';
		frmain.submit();
	}
	else {
		document.frmain.advanced.value='1';
		frmain.submit();
	}
}
function onSaveas(){
	if(check_form(document.frmain,'newmould')){
	document.frmain.operation.value="add";
	document.frmain.action="SearchMouldOperation.jsp";
	document.frmain.submit();
	}
}        
function onSave(){
	document.frmain.operation.value="edit";
	document.frmain.action="SearchMouldOperation.jsp";
	document.frmain.submit();
}
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
	document.frmain.operation.value="delete";
	document.frmain.action="SearchMouldOperation.jsp";
	document.frmain.submit();
	}
}

function onShowDepartmentMutil(spanname, inputname) {
    
    url=escape("/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+ $GetEle(inputname).value);
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
             $GetEle(spanname).innerHTML = jsid[1].substring(1);
             $GetEle(inputname).value = jsid[0].substring(1);
        }else {
             $GetEle(spanname).innerHTML = "";
             $GetEle(inputname).value = "";
        }
    }
}

</SCRIPT>
<SCRIPT language="javascript" src="/js/browser/LgcAssetBrowser.js"></SCRIPT>

<script type="text/javascript">

function onShowCRM(inputname, spanname) {
	var temp = $GetEle(inputname).value;
	id1 = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
							+ temp, "", "dialogWidth:550px;dialogHeight:550px;");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0).length() > 500) { // '500为表结构相关客户字段的长度
			alert("您选择的相关客户数量太多，数据库将无法保存所有的相关客户，请重新选择！");
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		} else if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
			var sHtml = "";

			$GetEle(inputname).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");

			for ( var _i = 0; _i < resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];

				sHtml = sHtml
						+ "<a href=javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID="
						+ curid + "')>" + curname + "</a>&nbsp";
			}

			$GetEle(spanname).innerHTML = sHtml;
		} else {
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		}
	}
}

function onShowRequest(inputname, spanname) {
	var temp = $GetEle(inputname).value;
	id1 = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
							+ temp, "", "dialogWidth:550px;dialogHeight:550px;");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0).length() > 500) { // '500为表结构相关流程字段的长度
			alert("您选择的相关流程数量太多，数据库将无法保存所有的相关流程，请重新选择！");
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		} else if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
			var sHtml = "";

			$GetEle(inputname).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");

			for ( var _i = 0; _i < resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];

				sHtml = sHtml
						+ "<a href=javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="
						+ curid + "')>" + curname + "</a>&nbsp";
			}

			$GetEle(spanname).innerHTML = sHtml;
		} else {
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		}
	}
}

function onShowMDocid(inputename, spanname) {
	var tmpids = $GetEle(inputename).value;
	var id1 = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="
					+ tmpids, "", "dialogWidth:550px;dialogHeight:550px;");
	if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
		var DocIds = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
		var DocName = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
		var sHtml = "";

		$GetEle(inputename).value = DocIds;

		var docIdArray = DocIds.split(",");
		var DocNameArray = DocName.split(",");

		for ( var _i = 0; _i < docIdArray.length; _i++) {
			var curid = docIdArray[_i];
			var curname = DocNameArray[_i];

			sHtml = sHtml + "<a href=/docs/docs/DocDsp.jsp?id=" + curid + ">"
					+ curname + "</a>&nbsp";
		}

		$GetEle(spanname).innerHTML = sHtml;

	} else {
		$GetEle(spanname).innerHTML = "";
		$GetEle(inputename).value = "";
	}
}

function onShowCostCenter() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="
							+ frmain.departmentid.value, "",
					"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			$GetEle("costcenterspan").innerHTML = wuiUtil.getJsonValueByIndex(
					id, 1);
			$GetEle("costcenterid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("costcenterspan").innerHTML = "";
			$GetEle("costcenterid").value = "";
		}
	}
}

function onShowResourceID() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("resourceidspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="
					+ wuiUtil.getJsonValueByIndex(id, 0)
					+ "'>"
					+ wuiUtil.getJsonValueByIndex(id, 1) + "</A>";
			$GetEle("resourceid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("resourceidspan").innerHTML = "";
			$GetEle("resourceid").value = "";
		}
	}
}

function onShowCurrencyID() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("currencyidspan").innerHTML = wuiUtil.getJsonValueByIndex(
					id, 1);
			$GetEle("currencyid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("currencyidspan").innerHTML = "";
			$GetEle("currencyid").value = "";
		}
	}
}

function onShowDepremethod1() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/DepremethodBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 1) != "") {
			$GetEle("depremethod1span").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("depremethod1").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("depremethod1span").innerHTML = "";
			$GetEle("depremethod1").value = "";
		}
	}
}

function onShowDepremethod2() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/DepremethodBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("depremethod2span").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("depremethod2").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("depremethod2span").innerHTML = "";
			$GetEle("depremethod2").value = "";
		}
	}
}

function onShowCapitaltypeid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("capitaltypeidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitaltypeid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitaltypeidspan").innerHTML = "";
			$GetEle("capitaltypeid").value = "";
		}
	}
}

function onShowCapitalgroupid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("capitalgroupidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitalgroupid").value = wuiUtil
					.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitalgroupidspan").innerHTML = "";
			$GetEle("capitalgroupid").value = "";
		}
	}
}

function onShowCustomerid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("customeridspan").innerHTML = wuiUtil.getJsonValueByIndex(
					id, 1);
			$GetEle("customerid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("customeridspan").innerHTML = "";
			$GetEle("customerid").value = "";
		}
	}
}

function onShowStateid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=search",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 1) != "") {
			$GetEle("Stateidspan").innerHTML = wuiUtil.getJsonValueByIndex(id,
					1);
			$GetEle("Stateid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("Stateidspan").innerHTML = "";
			$GetEle("Stateid").value = "";
		}
	}
}

function onShowReplacecapitalid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("replacecapitalidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("replacecapitalid").value = wuiUtil.getJsonValueByIndex(id,
					0);
		} else {
			$GetEle("replacecapitalidspan").innerHTML = "";
			$GetEle("replacecapitalid").value = "";
		}
	}
}

function onShowSubcompany(tdname, inputename) {
	var linkurl = "/hrm/company/HrmSubCompanyDsp.jsp?id=";
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
							+ $GetEle(inputename).value, "",
					"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var resourceids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var resourcename = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
			var sHtml = "";

			$GetEle(inputename).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");

			for ( var _i = 0; _i < resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];

				sHtml = sHtml + "<a href=" + linkurl + curid + ">" + curname
						+ "</a>&nbsp";
			}

			$GetEle(tdname).innerHTML = sHtml;

		} else {
			$GetEle(tdname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$GetEle(inputename).value = "";
		}
	}
}

</script>

<SCRIPT language="javascript" src="/js/browser/DepartmentBrowser.js"></SCRIPT>
<SCRIPT language="javascript" src="/js/browser/LgcAssetUnitBrowser.js"></SCRIPT>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
