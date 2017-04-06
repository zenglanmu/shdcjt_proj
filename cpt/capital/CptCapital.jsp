<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DepreMethodComInfo" class="weaver.cpt.maintenance.DepreMethodComInfo" scope="page"/>
<% //jsp:useBean id="CapitalDepre" class="weaver.cpt.capital.CapitalDepre" scope="page" /%>
<jsp:useBean id="CapitalCurPrice" class="weaver.cpt.capital.CapitalCurPrice" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CapitalRelateWFComInfo" class="weaver.cpt.capital.CapitalRelateWFComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />

<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String capitalid = Util.null2String(request.getParameter("id"));

RecordSet.executeProc("CptCapital_SelectByID",capitalid);
RecordSet.next();
String mark = Util.toScreen(RecordSet.getString("mark"),user.getLanguage()) ;			/*编号*/
String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;			/*名称*/
String barcode = Util.toScreen(RecordSet.getString("barcode"),user.getLanguage()) ;			/*条形码*/
String startdate = Util.toScreen(RecordSet.getString("startdate"),user.getLanguage()) ;			/*生效日*/
String enddate= Util.toScreen(RecordSet.getString("enddate"),user.getLanguage()) ;				/*生效至*/
String seclevel= Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage()) ;				/*安全级别*/
String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;/*部门*/
String costcenterid = Util.toScreen(RecordSet.getString("costcenterid"),user.getLanguage()) ;			/*成本中心*/
String resourceid = Util.toScreen(RecordSet.getString("resourceid"),user.getLanguage()) ;		/*人力资源*/
String currencyid = Util.toScreen(RecordSet.getString("currencyid"),user.getLanguage()) ;	/*币种*/
String capitalcost = Util.toScreen(RecordSet.getString("capitalcost"),user.getLanguage()) ;	/*成本*/
if(capitalcost.equals("")){
    capitalcost="0";
}
String startprice = Util.toScreen(RecordSet.getString("startprice"),user.getLanguage()) ;	/*开始价格*/
if(startprice.equals("")){
    startprice="0";
}
String capitaltypeid = Util.toScreen(RecordSet.getString("capitaltypeid"),user.getLanguage()) ;			/*资产类型*/
String capitalgroupid = Util.toScreen(RecordSet.getString("capitalgroupid"),user.getLanguage()) ;			/*资产组*/
String unitid = Util.toScreen(RecordSet.getString("unitid"),user.getLanguage()) ;				/*计量单位*/
String capitalnum = Util.toScreen(RecordSet.getString("capitalnum"),user.getLanguage()) ;			/*数量*/
String replacecapitalid = Util.toScreen(RecordSet.getString("replacecapitalid"),user.getLanguage()) ;				/*替代*/
String version = Util.toScreen(RecordSet.getString("version"),user.getLanguage()) ;			/*版本*/
String itemid = "0";//Util.toScreen(RecordSet.getString("itemid"),user.getLanguage()) ;			/*物品*/
String remark = Util.toScreen(RecordSet.getString("remark"),user.getLanguage()) ;			/*备注*/
String depremethod1 = Util.toScreen(RecordSet.getString("depremethod1"),user.getLanguage()) ;			/*折旧法一*/
String depremethod2 = Util.toScreen(RecordSet.getString("depremethod2"),user.getLanguage()) ;			/*折旧法二*/
String deprestartdate = Util.toScreen(RecordSet.getString("deprestartdate"),user.getLanguage()) ;		/*折旧开始日期*/
String depreenddate = Util.toScreen(RecordSet.getString("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
String customerid= Util.toScreen(RecordSet.getString("customerid"),user.getLanguage()) ;			/*供应商id*/
String attribute= Util.toScreen(RecordSet.getString("attribute"),user.getLanguage()) ;
String Invoice = Util.toScreen(RecordSet.getString("Invoice"),user.getLanguage()) ;         /*发票号码*/
String StockInDate = Util.toScreen(RecordSet.getString("StockInDate"),user.getLanguage()) ;         /*入库日期*/
String SelectDate = Util.toScreen(RecordSet.getString("SelectDate"),user.getLanguage()) ;         /*购置日期*/
String depreyear  = Util.toScreen(RecordSet.getString("depreyear"),user.getLanguage()) ;			/*折旧年限*/
String deprerate  = Util.toScreen(RecordSet.getString("deprerate"),user.getLanguage()) ;			/*折旧率*/
if(deprerate.equals("")) deprerate="0";
/*属性:
0:自制
1:采购
2:租赁
3:出租
4:维护
5:租用
6:其它
*/
String stateid = Util.toScreen(RecordSet.getString("stateid"),user.getLanguage()) ;	/*资产状态*/
String location = Util.toScreen(RecordSet.getString("location"),user.getLanguage()) ;			/*存放地点*/
String createrid = Util.toScreen(RecordSet.getString("createrid"),user.getLanguage()) ;					/*创建人id*/
String createdate = Util.toScreen(RecordSet.getString("createdate"),user.getLanguage()) ;					/*创建日期*/
String createtime = Util.toScreen(RecordSet.getString("createtime"),user.getLanguage()) ;					/*创建时间*/
String lastmoderid = Util.toScreen(RecordSet.getString("lastmoderid"),user.getLanguage()) ;					/*最后修改人id*/
String lastmoddate = Util.toScreen(RecordSet.getString("lastmoddate"),user.getLanguage()) ;					/*修改日期*/
String lastmodtime = Util.toScreen(RecordSet.getString("lastmodtime"),user.getLanguage()) ;					/*修改时间*/
/*new add*/
String depreendprice = Util.toScreen(RecordSet.getString("depreendprice"),user.getLanguage()) ;	/*折旧底价*/
if(depreendprice.equals("")){
    depreendprice="0";
}
String capitalspec = Util.toScreen(RecordSet.getString("capitalspec"),user.getLanguage()) ;	/*规格型号*/
String capitallevel = Util.toScreen(RecordSet.getString("capitallevel"),user.getLanguage()) ;	/*资产等级*/
String manufacturer = Util.toScreen(RecordSet.getString("manufacturer"),user.getLanguage()) ;	/*制造厂商*/
String manudate = Util.toScreen(RecordSet.getString("manudate"),user.getLanguage()) ;	/*出厂日期*/
String currentnum = Util.toScreen(RecordSet.getString("currentnum"),user.getLanguage()) ;	/*当前数量*/
String sptcount = Util.toScreen(RecordSet.getString("sptcount"),user.getLanguage()) ;	/*单独核算*/
//String crmid = Util.toScreen(RecordSet.getString("crmid"),user.getLanguage()) ;	/*单独核算*/
String alertnum= Util.toScreenToEdit(RecordSet.getString("alertnum"),user.getLanguage()) ;	/*报警数量*/
String fnamark= Util.toScreenToEdit(RecordSet.getString("fnamark"),user.getLanguage()) ;	/*财务编号*/
String isinner= Util.toScreenToEdit(RecordSet.getString("isinner"),user.getLanguage()) ;	/*财务编号*/
String blongsubcompany = Util.null2String(RecordSet.getString("blongsubcompany"));/*所属分部*/
String blongdepartment = Util.null2String(RecordSet.getString("blongdepartment"));/*所属部门*/
String issupervision = Util.null2String(RecordSet.getString("issupervision"));/*是否海关检查*/
String amountpay = Util.null2String(RecordSet.getString("amountpay")); /*已付金额*/
String purchasestate = Util.null2String(RecordSet.getString("purchasestate"));/*采购状态*/
String contractno = Util.null2String(RecordSet.getString("contractno"));/*合同号*/
String equipmentpower = Util.null2String(RecordSet.getString("equipmentpower"));/*设备功率*/

String isdata = Util.toScreen(RecordSet.getString("isdata"),user.getLanguage()) ;	/*资产资料判断:1:资料2:资产*/
String capitalimageid = ""; /*照片id 由SequenceIndex表得到，和使用它的表相关联*/
if("2".equals(isdata)){
	rs.executeSql("select capitalimageid from CptCapital where id = "+Util.null2String(RecordSet.getString("datatype")));
	if(rs.next()){
	   capitalimageid = Util.getFileidOut(rs.getString("capitalimageid")) ;
	}
}else{
	capitalimageid = Util.getFileidOut(RecordSet.getString("capitalimageid")) ;
}
/*2002-9-23*/
String relatewfid = Util.toScreen(RecordSet.getString("relatewfid"),user.getLanguage()) ;	/*资产相关工作流*/
if(relatewfid.equals("")){
	relatewfid = "0";
}
//如果是资料,则不做折旧计算
boolean dataornot = true;//false if is not data;
if(isdata.equals("2")){
	dataornot = false;
}

/*information which need calculate*/
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     			Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
today.roll(Calendar.MONTH,-1);
/*String amonthbefore = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     			Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;*/

/*显示权限判断*/


boolean displayAll = false;
boolean canedit = false;
boolean canview = false;
boolean canDelete = false;
boolean canviewlog = false;

/*有显示权限的可以查看所有资产*/
if(HrmUserVarify.checkUserRight("CptCapital:Display",user))  {
	displayAll		=	true;
} 
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int userid = user.getUID();
String logintype = ""+user.getLogintype();
boolean isurger=WFUrgerManager.UrgerHaveCrmViewRight(requestid,userid,Util.getIntValue(logintype),capitalid);
boolean ismoitor=WFUrgerManager.getMonitorViewObjRight(requestid,userid,""+capitalid,"3");
boolean onlyview=false;
if(!(user.getLogintype()).equals("1")) {
    if(!isurger && !ismoitor){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }else{
        onlyview=true;
    }
}
/*未生效的资产只有有查看权限的人才可以查看*/
if(!((currentdate.compareTo(startdate)>=0 || startdate.equals(""))&& (currentdate.compareTo(enddate)<=0 || enddate.equals("")))){
	if (!displayAll){
        if(!isurger && !ismoitor){
            response.sendRedirect("/notice/noright.jsp") ;
            return ;
        }else{
            onlyview=true;
        }
    }
}


/*可否编辑*/
/*由于现在资产资料和资产的权限控制完全不同所以需做以下区分*/
if (isdata.equals("1")) {
    // added by lupeng 2204-07-21 for TD558
    if (HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
        canview = true;
		canedit = true;
		canDelete = true;
		canviewlog	= true;/*可否查看日志*/
	}
    // end

} else {
	if (HrmUserVarify.checkUserRight("CptCapitalEdit:Delete",user)) {
		canDelete = true;
	}
	/*共享权限判断*/
	RecordSetShare.executeSql(" select max(sharelevel) from cptsharedetail WHERE USERid = " + user.getUID() + " and cptid = " + capitalid);

	if( RecordSetShare.next() ) {
		int sharelevel = Util.getIntValue(RecordSetShare.getString(1), 0) ;
		if( sharelevel == 2 ) {
			canedit     =   true;
			canviewlog	 = true;
		}
		canview    =   true ;
	}
}

RecordSetShare.executeProc("CptCapitalShareInfo_SbyRelated",capitalid);
RecordSetShare.beforFirst();

// modify by dongping for 1296 in 2004.11.05
//只有资产资料维护权限者才能查看资产资料，修改为所有用户有权查看资产资料
if (!(displayAll || canview || canedit||(isdata.equals("1")))) {
    if(!isurger && !ismoitor){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }else{
        onlyview=true;
    }
}
/*权限判断结束*/

//String deprerate = "";       /*残值率*/
//String monthdepre = "";   /*月折旧率*/
String currentprice = startprice;    /*当前价值*/
String usedyear = "0";			/*使用年限*/
String usedmonth = "0";		/*使用月份*/
if(!dataornot){ //资产
/*计算当前价值*/
    CapitalCurPrice.setSptcount(sptcount);
    CapitalCurPrice.setStartprice(startprice);
    CapitalCurPrice.setCapitalnum(capitalnum);
    CapitalCurPrice.setDeprestartdate(deprestartdate);
    CapitalCurPrice.setDepreyear(depreyear);
    CapitalCurPrice.setDeprerate(deprerate);
    
    usedyear=CapitalCurPrice.getUsedYear();
    currentprice=CapitalCurPrice.getCurPrice();
}

/*自定义字段*/
String datefield[] = new String[5] ;
String numberfield[] = new String[5] ;
String textfield[] = new String[5] ;
String tinyintfield[] = new String[5] ;
String docff[] = new String[5] ; 
String depff[] = new String[5] ; 
String crmff[] = new String[5] ; 
String reqff[] = new String[5] ; 

for(int k=1 ; k<6;k++) datefield[k-1] = RecordSet.getString("datefield"+k) ;
for(int k=1 ; k<6;k++) numberfield[k-1] = RecordSet.getString("numberfield"+k) ;
for(int k=1 ; k<6;k++) textfield[k-1] = RecordSet.getString("textfield"+k) ;
for(int k=1 ; k<6;k++) tinyintfield[k-1] = RecordSet.getString("tinyintfield"+k) ;
for(int k=1 ; k<6;k++) docff[k-1] = RecordSet.getString("docff0"+k+"name") ;
for(int k=1 ; k<6;k++) depff[k-1] = RecordSet.getString("depff0"+k+"name") ;
for(int k=1 ; k<6;k++) crmff[k-1] = RecordSet.getString("crmff0"+k+"name") ;
for(int k=1 ; k<6;k++) reqff[k-1] = RecordSet.getString("reqff0"+k+"name") ;

// 文档的总数
DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setAssetid(capitalid);
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
DocSearchManage.getSelectResultCount(whereclause,user) ;
String doccount=""+DocSearchManage.getRecordersize();




String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
if(dataornot){
	titlename = SystemEnv.getHtmlLabelName(1509,user.getLanguage())+" : "+name;
}else{
	titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : "+name;
}
String newtitlename = titlename;
titlename +="&nbsp; <B>"+SystemEnv.getHtmlLabelName(125,user.getLanguage())+":&nbsp;</B>"+createdate+"&nbsp;"+createtime ;
titlename +="&nbsp; <B>"+SystemEnv.getHtmlLabelName(271,user.getLanguage())+":&nbsp;</B>"+Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage()) ;
titlename += "&nbsp; <B>"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":&nbsp;</B>"+lastmoddate+"&nbsp;"+lastmodtime ;
titlename += "&nbsp; <B>"+SystemEnv.getHtmlLabelName(424,user.getLanguage())+":&nbsp;</B>"+Util.toScreen(ResourceComInfo.getResourcename(lastmoderid),user.getLanguage()) ;

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
	session.setAttribute("fav_pagename" , newtitlename ) ;	
%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
if(!onlyview){
if(canedit && isdata.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",CptCapitalEdit.jsp?id="+capitalid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(canDelete){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(canviewlog){
   if (isdata.equals("1")){
	if(RecordSet.getDBType().equals("db2")){
   RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=51 and relatedid="+capitalid+",_self} " ;
    }else{
   RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=51 and relatedid="+capitalid+",_self} " ;

    }
	RCMenuHeight += RCMenuHeightStep ;
   }
}

if(HrmUserVarify.checkUserRight("CptCapital:FlowView",user,departmentid)){
	if(!stateid.equals("")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1380,user.getLanguage())+",javascript:onFlowViewClick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-2),_self} ";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<DIV class=Btnbar>
<%
//dismiss all these button
if(false){
if(HrmUserVarify.checkUserRight("CptCapital:InStock",user,departmentid)){
if(stateid.equals("")||(stateid.equals("1")&&!sptcount.equals("1"))){
%>
<button type=button  class=Btn id=button3  accessKey=S onclick='onInStockClick()' name=button3 ><U>S</U>-<%=SystemEnv.getHtmlLabelName(1375,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:MoveIn",user,departmentid)){
if(stateid.equals("1")&&!sptcount.equals("1")){
%>
<button type=button  class=Btn id=button12  accessKey=I onclick='onMoveInClick()' name=button12 ><U>I</U>-<%=SystemEnv.getHtmlLabelName(1376,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:MoveOut",user,departmentid)){
if(stateid.equals("1")&&!sptcount.equals("1")){
%>
<button type=button  class=Btn id=button13  accessKey=V onclick='onMoveOutClick()' name=button13 ><U>V</U>-<%=SystemEnv.getHtmlLabelName(1377,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:Use",user,departmentid)){
if((stateid.equals("")&&sptcount.equals("1"))||stateid.equals("1")){
%>
<button type=button  class=Btn id=button4  accessKey=U onclick='onUseClick()' name=button4 ><U>U</U>-<%=SystemEnv.getHtmlLabelName(1378,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:Lend",user,departmentid)){
if((stateid.equals("")||stateid.equals("1")||stateid.equals("2"))&&sptcount.equals("1")){
%>
<button type=button  class=Btn id=button5  accessKey=D onclick='onLendClick()' name=button5 ><U>D</U>-<%=SystemEnv.getHtmlLabelName(1379,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:Other",user,departmentid)){
if(stateid.equals("")||stateid.equals("1")){
%>
<button type=button  class=Btn id=button6  accessKey=O onclick='onOtherClick()' name=button6 ><U>O</U>-<%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:FlowView",user,departmentid)){
if(!stateid.equals("")){
%>
<button type=button  class=Btn id=button7  accessKey=V onclick='onFlowViewClick()' name=button7 ><U>V</U>-<%=SystemEnv.getHtmlLabelName(1380,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:HandOver",user,departmentid)){
if(stateid.equals("2")){
%>
<button type=button  class=Btn id=button8  accessKey=H onclick='onHandOverClick()' name=button8 ><U>H</U>-<%=SystemEnv.getHtmlLabelName(1381,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:Mend",user,departmentid)){
if(stateid.equals("2")){
%>
<button type=button  class=Btn id=button9  accessKey=M onclick='onMendClick()' name=button9 ><U>M</U>-<%=SystemEnv.getHtmlLabelName(1382,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:Return",user,departmentid)){
if(stateid.equals("2")||stateid.equals("3")||stateid.equals("4")){
%>
<button type=button  class=Btn id=button10 accessKey=R onclick='onReturnClick()' name=button10 ><U>R</U>-<%=SystemEnv.getHtmlLabelName(1384,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:Loss",user,departmentid)){
if(stateid.equals("1")||stateid.equals("2")){
%>
<button type=button  class=Btn id=button11 accessKey=C onclick='onLossClick()' name=button11 ><U>C</U>-<%=SystemEnv.getHtmlLabelName(1385,user.getLanguage())%></BUTTON>
<% }
}
if(HrmUserVarify.checkUserRight("CptCapital:Discard",user,departmentid)){
if(stateid.equals("2")){
%>
<button type=button  class=Btn id=button11 accessKey=C onclick='onDiscardClick()' name=button11 ><U>C</U>-<%=SystemEnv.getHtmlLabelName(1386,user.getLanguage())%></BUTTON>
<% }
}
}
%>
</DIV>
<SCRIPT LANGUAGE="JavaScript">
function onInStockClick(){
  <%  if(stateid.equals("1")&&!sptcount.equals("1")){
  %>
        window.location.href="CptCapitalInStock2.jsp?capitalid=<%=capitalid%>";
  <%}
    else{
   %>
        window.location.href="CptCapitalInStock1.jsp?capitalid=<%=capitalid%>&sptcount=<%=sptcount%>";
   <% }
   %>
    return;
}
function onUseClick(){
    window.location.href="CptCapitalUse.jsp?capitalid=<%=capitalid%>&sptcount=<%=sptcount%>";
    return;
}
function onLendClick(){
    window.location.href="CptCapitalLend.jsp?capitalid=<%=capitalid%>";
    return;
}
function onOtherClick(){
    window.location.href="CptCapitalOther.jsp?capitalid=<%=capitalid%>&sptcount=<%=sptcount%>";
    return;
}
function onFlowViewClick(){
    window.location.href="CptCapitalFlowView.jsp?capitalid=<%=capitalid%>";
    return;
}
function onHandOverClick(){
    window.location.href="CptCapitalHandOver.jsp?capitalid=<%=capitalid%>";
    return;
}
function onMendClick(){
    window.location.href="CptCapitalMend.jsp?capitalid=<%=capitalid%>";
    return;
}
function onReturnClick(){
    window.location.href="CptCapitalReturn.jsp?capitalid=<%=capitalid%>&stateid=<%=stateid%>";
    return;
}
function onDiscardClick(){
    window.location.href="CptCapitalDiscard.jsp?capitalid=<%=capitalid%>";
    return;
}
function onDiscardClick(){
    window.location.href="CptCapitalDiscard.jsp?capitalid=<%=capitalid%>";
    return;
}
function onLossClick(){
    window.location.href="CptCapitalLoss.jsp?capitalid=<%=capitalid%>&sptcount=<%=sptcount%>";
    return;
}
function onMoveInClick(){
    window.location.href="CptCapitalMoveIn.jsp?capitalid=<%=capitalid%>";
    return;
}
function onMoveOutClick(){
    window.location.href="CptCapitalMoveOut.jsp?capitalid=<%=capitalid%>";
    return;
}
</SCRIPT>

<FORM name=frmain id=frmain action=CptCapitalOperation.jsp method=post enctype="multipart/form-data">
<input type=hidden name=operation value="deletecapital">
<input type=hidden name="id" value="<%=capitalid%>">
<input type=hidden name="name" value="<%=name%>">

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

			<table class=ViewForm>
			  <colgroup> <col width="49%"> <col width=10> <col width="49%"> <tbody>
			  <tr>
				<td valign=top>
				  <table width="100%">
					<colgroup> <col width=30%> <col width=70%><tbody>
					<tr class=Title>
					  <th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
					</tr>
					<tr class=Spacing style="height:1px;">
					  <td class=Line1 colspan=2></td>
					</tr>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
					  <td class=Field> <%=mark%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				  <% if((displayAll||canview)&&!dataornot){%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%></td>
					  <td class=Field> <%=fnamark%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				  <%}%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
					  <td class=Field> <%=name%></td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%if(!dataornot){%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%></td>
					  <td class=Field> <%=barcode%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}%>
					<%if(!dataornot){%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></td>
					  <td class=Field><%=startdate%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></td>
					  <td class=Field><%=enddate%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}%>
					<!--tr>
					  <td><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
					  <td class=Field> <%=seclevel%> </td>
					</tr-->
					<%if(!dataornot){%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%></td>
					  <td class=Field><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<!--tr>
					  <td><%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(426,user.getLanguage())%></td>
					  <td class=Field><%=Util.toScreen(CostcenterComInfo.getCostCentername(costcenterid),user.getLanguage())%>
					  </td>
					</tr-->
					<%}%>
					<tr>
					  <td>
					  <%if(!dataornot){%>
					  <%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%>
					  <%}else{%>
					  <%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%>
					  <%}%>
					  </td>
					  <td class=Field><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
					  <td class=Field> <%=SubCompanyComInfo.getSubCompanyname(blongsubcompany)%></td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					
					<%if(!dataornot){%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></td>
					  <td class=Field> <%=DepartmentComInfo.getDepartmentname(blongdepartment)%></td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}%>
					
					<TR>
						  <td><%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%></td>
							<TD class=Field>
							  <%if (sptcount.equals("1")){%>
							  <IMG src="/images/BacoCheck.gif" border=0>
							  <%} else {%>
							  <IMG src="/images/BacoCross.gif" border=0>
							  <%}%>
							</TD>
					 </TR>
					 <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				  <% if((displayAll||canview)&&!sptcount.equals("1")&&!dataornot){%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(15294,user.getLanguage())%></td>
					  <td class=Field> <%=alertnum%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				  <%}%>
					<% if(!dataornot&&false){%>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></td>
						<td class=Field>
						<%=Util.toScreen(CapitalRelateWFComInfo.getCapitalRelateWFname(relatewfid),user.getLanguage())%>
						</td>
					  </tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <%}%>
					</tbody>
				  </table>
			  <%if(!dataornot){%>
				  <table class=ViewForm>
					<tbody>
					<tr class=Title>
					  <th><%=SystemEnv.getHtmlLabelName(15296,user.getLanguage())%></th>
					</tr>
					<tr class=Spacing style="height:1px;">
					  <td class=Line1></td>
					</tr>
					<TR>
					  <TD>
						<TABLE class="ViewForm">
						<COLGROUP> <COL width="30%"> <COL width="70%">
						  <TBODY>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
								<TD class=Field>
								 <a href='../../docs/search/DocSearchTemp.jsp?assetid=<%=capitalid%>&docstatus=6'><%=doccount%></a>
								</TD>
							</TR>
							<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
							<% if(!relatewfid.equals("0")){%>
							<!--TR>
								<TD><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
								<TD class=Field>
								 <a href="CptCapitalUsePlan.jsp?relatedid=<%=capitalid%>&relatewfid=<%=relatewfid%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>
								</TD>
							</TR>
							<TR><TD class=Line colSpan=2></TD></TR-->
							  <%} else {%>
							<!--TR>
								<TD><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
								<TD class=Field>
								  <a href="/workflow/search/WFRelatedSearch.jsp?relatedid=<%=capitalid%>&relatedtype=itemusage"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>
								</TD>
							</TR>
							<TR><TD class=Line colSpan=2></TD></TR-->
							<%}%>
						  </tbody>
						</table>
					  </td>
					</tr>
					</tbody>
				  </table>
			   <%}%>
				</td>
				<td valign=top width="100%">
				  <table width="100%">
					<tbody>
					<tr class=Title>
					  <th><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></th>
					</tr>
					<tr class=Spacing style="height:1px;">
					  <td class=Line1></td>
					</tr>
					<tr>
					  <TD width="100%"  id = imagetd >
						<% if(!capitalimageid.equals("") && !capitalimageid.equals("0")) {%>
						<img border=0   id=capitalimage  width=400 src="/weaver/weaver.file.FileDownload?fileid=<%=capitalimageid%>">
						<% } %>
					  </TD>
					</tr>
					</tbody>
				  </table>
				</td>
			  </tr>
			  <tr>
				<td valign=top>
				  <table width="100%">
					<colgroup> <col width=30%> <col width=70%> <tbody>
					<tr class=Title>
					  <th colspan=2 ><%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%></th>
					</tr>
					<tr class=Spacing style="height:1px;">
					  <td class=Line1 colspan=2></td>
					</tr>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
					  <td class=Field> <%=capitalspec%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></td>
					  <td class=Field> <%=capitallevel%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(1364,user.getLanguage())%></td>
					  <td class=Field> <%=manufacturer%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%if(!dataornot){%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(1365,user.getLanguage())%></td>
					  <td class=Field><%=manudate%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></td>
					  <td class=Field><%=Util.toScreen(CapitalTypeComInfo.getCapitalTypename(capitaltypeid),user.getLanguage())%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
					  <td class=Field>
					  <%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>					
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></td>
					  <td class=Field> <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid),user.getLanguage())%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
					  <td class=Field>
						<% if(attribute.equals("0")) {%>
						<%=SystemEnv.getHtmlLabelName(1366,user.getLanguage())%>
						<%}%>
						<% if(attribute.equals("1")) {%>
						<%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())%>
						<%}%>
						<% if(attribute.equals("2")) {%>
						<%=SystemEnv.getHtmlLabelName(1368,user.getLanguage())%>
						<%}%>
						<% if(attribute.equals("3")) {%>
						<%=SystemEnv.getHtmlLabelName(1369,user.getLanguage())%>
						<%}%>
						<% if(attribute.equals("4")) {%>
						<%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%>
						<%}%>
						<% if(attribute.equals("5")) {%>
						<%=SystemEnv.getHtmlLabelName(1370,user.getLanguage())%>
						<%}%>
						<% if(attribute.equals("6")) {%>
						<%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%>
						<%}%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%if(!dataornot){%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
					  <td class=Field>  <% if(stateid.equals("-7")) {%>
						<%=SystemEnv.getHtmlLabelName(1385,user.getLanguage())%>
						<%} else if(stateid.equals("-6")) {%>
						<%=SystemEnv.getHtmlLabelName(1381,user.getLanguage())%>
						<%} else if(stateid.equals("-5")) {%>
						<%=SystemEnv.getHtmlLabelName(1377,user.getLanguage())%>
						<%} else if(stateid.equals("-4")) {%>
						<%=SystemEnv.getHtmlLabelName(1376,user.getLanguage())%>
						<%} else if(stateid.equals("-3")) {%>
						<%=SystemEnv.getHtmlLabelName(1396,user.getLanguage())%>
						<%} else if(stateid.equals("-2")) {%>
						<%=SystemEnv.getHtmlLabelName(1397,user.getLanguage())%>
						<%} else if(stateid.equals("-1")) {%>
						<%=SystemEnv.getHtmlLabelName(1398,user.getLanguage())%>
						<%} else if(stateid.equals("0")) {%>
						<%=SystemEnv.getHtmlLabelName(1384,user.getLanguage())%>
						<%} else if(stateid.equals("1")) {%>
						<%=SystemEnv.getHtmlLabelName(1375,user.getLanguage())%>
						<%} else if(stateid.equals("2")) {%>
						<%=SystemEnv.getHtmlLabelName(1378,user.getLanguage())%>
						<%} else if(stateid.equals("3")) {%>
						<%=SystemEnv.getHtmlLabelName(1379,user.getLanguage())%>
						<%} else if(stateid.equals("4")) {%>
						<%=SystemEnv.getHtmlLabelName(1382,user.getLanguage())%>
						<%} else if(stateid.equals("5")) {%>
						<%=SystemEnv.getHtmlLabelName(1386,user.getLanguage())%>
						<%} else{%>
						<%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(stateid),user.getLanguage())%>
						<%}%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
					  <td class=Field> <%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%if(!dataornot){%>
                    <!--存放地点-->
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
					  <td class=Field> <%=location%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                    <!--入库日期-->
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></td>
					  <td class=Field> <%=StockInDate%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}%>
					<%if(displayAll||canview){%>
					<%if(!dataornot){%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
					  <td class=Field> <%=capitalnum%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<tr>
						<td><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></td>
						<td class=Field><% if(isinner.equals("1")) {%><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%><%} else if(isinner.equals("2")) {%><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%> <%}%>
						</td>
					  </tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}%>
					<!--
					<tr>
					  <td>当前数量</td>
					  <td class=Field> <%=currentnum%></td>
					</tr>
				   -->
				   <%}%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%></td>
					  <td class=Field> <%=Util.toScreen(CapitalComInfo.getCapitalname(replacecapitalid),user.getLanguage())%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></td>
					  <td class=Field> <%=version%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					</tbody>
				  </table>

<!-- 
					<!-- 附属设备 begin--//>
					<table width="100%" class=liststyle id=equipment>
					  <tr> 
						<th align="left" colspan=6><%=SystemEnv.getHtmlLabelName(22341,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px;"> 
						<td class=Line1 colspan=6></td>
					  </tr>
					  <tr class=header> 						
						<td width="15%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(16314,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(22349,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(22350,user.getLanguage())%></td>
					  </tr>
					  <TR> 
						<TD class=Line colSpan=6></TD>
					  </TR>
						<%
							String sql = "select * from cptcapitalequipment where cptid = " + capitalid;
							rs.executeSql(sql);
							boolean trcolor = false;
							while(rs.next()){
								trcolor = !trcolor;
						%>
						<tr <%if(trcolor){%>class=datalight<%}else{%>class=DataDark<%}%>> 
							<td><%=rs.getString("equipmentname")%></td>
							<td><%=rs.getString("equipmentspec")%></td>
							<td><%=rs.getString("equipmentsum")%></td>
							<td><%=rs.getString("equipmentpower")%></td>
							<td><%=rs.getString("equipmentvoltage")%></td>
						</tr>
						<TR> 
							<TD class=Line colSpan=6></TD>
						</TR>               					
					  <%}%>
					</table>
					<!-- 附属设备 end--//>
					
					<!-- 备品配件 begin--//>
					<table width="100%" class=liststyle id=parts>
					  <tr> 
						<th align="left" colspan=6><%=SystemEnv.getHtmlLabelName(22342,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px;"> 
						<td class=Line1 colspan=6></td>
					  </tr>
					  <tr class=header> 
						<td width="15%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(16314,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(22351,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(22352,user.getLanguage())%></td>
					  </tr>
					  <TR> 
						<TD class=Line colSpan=6></TD>
					  </TR>
						<%
							sql = "select * from cptcapitalparts where cptid = " + capitalid;
							rs.executeSql(sql);							
							trcolor = false;
							while(rs.next()){
								trcolor = !trcolor;
						%>
						<tr <%if(trcolor){%>class=datalight<%}else{%>class=DataDark<%}%>> 
							<td><%=rs.getString("partsname")%></td>
							<td><%=rs.getString("partsspec")%></td>
							<td><%=rs.getString("partssum")%></td>
							<td><%=rs.getString("partsweight")%></td>
							<td><%=rs.getString("partssize")%></td>
						</tr>
						<TR> 
							<TD class=Line colSpan=6></TD>
						</TR>
						<%}%>
					</table>
					<!-- 备品配件 end--//>
-->

					<%if (isdata.equals("2")) {%>
				  <table class=ViewForm>
					<colgroup> <col width="30%"> <col width="60%"> <col width="10%"> <tbody>
					<tr class=Title>
					  <th ><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th>
					  <td align=right colspan=2 >
					  <% if(canedit){%><a href="/cpt/capital/CptCapitalAddShare.jsp?capitalid=<%=capitalid%>&capitalname=<%=name%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
					  <%}%>
					  </td>
					</tr>
					<tr class=Spacing style="height:1px;">
					  <td class=Line1 colspan=3></td>
					</tr>
					<%while(RecordSetShare.next()){
				if(RecordSetShare.getInt("sharetype")==1)	{
			%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
					  <td class=Field> <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetShare.getString("userid")%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%></a>/
						<% if(RecordSetShare.getInt("sharelevel")==1){%>
						<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<%}%>
						<% if(RecordSetShare.getInt("sharelevel")==2){%>
						<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						<%}%> </td>
					  <td class=Field>
						<% if(canedit){%>
						<a href="/cpt/capital/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&capitalid=<%=capitalid%>&capitalname=<%=name%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
						<%}%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=3></TD></TR>
					<%}else if(RecordSetShare.getInt("sharetype")==2)	{%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
					  <td class=Field> <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSetShare.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/
						<% if(RecordSetShare.getInt("sharelevel")==1){%>
						<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<%}%>
						<% if(RecordSetShare.getInt("sharelevel")==2){%>
						<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						<%}%> </td>
					 <td class=Field>
						<% if(canedit){%>
						<a href="/cpt/capital/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&capitalid=<%=capitalid%>&capitalname=<%=name%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
						<%}%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=3></TD></TR>
					<%}else if(RecordSetShare.getInt("sharetype")==3)	{%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
					  <td class=Field> <%=Util.toScreen(RolesComInfo.getRolesname(RecordSetShare.getString("roleid")),user.getLanguage())%>/
						<% if(RecordSetShare.getInt("rolelevel")==0) {%>
						<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
						<%} if(RecordSetShare.getInt("rolelevel")==1) {%>
						<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
						<%} if(RecordSetShare.getInt("rolelevel")==2) {%>
						<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><%}%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/
						<% if(RecordSetShare.getInt("sharelevel")==1){%>
						<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<%}%>
						<% if(RecordSetShare.getInt("sharelevel")==2){%>
						<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						<%}%></td>
					  <td class=Field>
						<% if(canedit){%>
						<a href="/cpt/capital/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&capitalid=<%=capitalid%>&capitalname=<%=name%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
						<%}%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=3></TD></TR>
					<%}else if(RecordSetShare.getInt("sharetype")==4)	{%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></td>
					  <td class=Field> <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/
						<% if(RecordSetShare.getInt("sharelevel")==1){%>
						<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<%}%>
						<% if(RecordSetShare.getInt("sharelevel")==2){%>
						<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						<%}%> </td>
					  <td class=Field>
						<%if(canedit){%>
						<a href="/cpt/capital/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&capitalid=<%=capitalid%>&capitalname=<%=name%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
						<%}%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=3></TD></TR>
					<%}%>
					<%}%>
					</tbody>
				  </table>
				  <%}%>
				</td>
				<td valign=top>
				<%if(displayAll||canview){%>
				  <table width="100%">
					<colgroup> <col width=30%> <col width=70%> <tbody>
					<tr class=Title>
					  <th colspan=2><%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></th>
					</tr>
					<tr class=Spacing style="height:1px;">
					  <td class=Line1 colspan=2></td>
					</tr>
					<%if(isdata.equals("2")){%>
                    <!--购置日期-->
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></td>
					  <td class=Field> <%=SelectDate%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<!--合同号-->
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%></td>
					  <td class=Field> <%=contractno%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					
					<%}%>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
					  <td class=Field><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>
					  </td>

					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					 <!--
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%></td>
					  <td class=Field> <%=capitalcost%> </td>
					</tr>
					-->
					<tr>
					  <td>
					  <% if(isdata.equals("1")){ %>
					  <%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%>
					  <% }else{ %>
					  <%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%>
					  <% } %>
					  </td>
					  <td class=Field> <%=startprice%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

                    <% if(isdata.equals("2")){ %>
                    <!--发票号码-->
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></td>
					  <td class=Field><%=Invoice%></td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                    <%}%>
					</tbody>
				  </table>
				  <%}%>

                  <%if(displayAll||canview){%>
                  <%if (!dataornot || sptcount.equals("1")){%>
                  <table width="100%">
                  <colgroup> <col width=30%> <col width=70%> <tbody>
                  <!--折旧信息-->
                  <tr class=Title>
                    <th colspan=2><%=SystemEnv.getHtmlLabelName(1374,user.getLanguage())%></th>
                  </tr>
                  <tr class=Spacing style="height:1px;"><td class=Line1 colspan=2></td></tr>

                  <!--单独核算时显示-->
                  <%if(sptcount.equals("1")){%>
                  <!--折旧年限-->
                  <tr>
                      <td><%=SystemEnv.getHtmlLabelName(19598,user.getLanguage())%></td>
                      <td class=Field><%=depreyear%> </td>
                  </tr>
                  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                  <!--残值率-->
                  <tr>
                      <td><%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%></td>
                      <td class=Field><%=deprerate%>%</td>
                  </tr>
                  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                  <%}%>

                  <!--单独核算且资产时显示-->
                  <% if(!dataornot && sptcount.equals("1")){%>
                  <!--领用日期-->
                  <tr>
                      <td><%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%></td>
                      <td class=Field><%=deprestartdate%> </td>
                  </tr>
                  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                  <!--已用年限，月份-->
                  <tr>
                      <td><%=SystemEnv.getHtmlLabelName(1388,user.getLanguage())%></td>
                      <td class=Field><%=usedyear%></td>
                  </tr>
                  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                  <%}%>

                  <!--资产时显示-->
                  <% if(!dataornot){%>
                  <!--当前价值-->
                  <tr>
                      <td><%=SystemEnv.getHtmlLabelName(1389,user.getLanguage())%></td>
                      <td class=Field> <%=currentprice%> </td>
                  </tr>
                  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                  <%}%>
                  </tbody>
                  </table>
                  <%}}%>
					<table width="100%">
					<colgroup> <col width=30%> <col width=70%> <tbody>
					<tr class=Title>
					  <th colspan=2><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></th>
					</tr>
					<tr class=Spacing style="height:1px;">
					  <td class=Line1 colspan=2></td>
					</tr>
					<tr>
					  <td> <%=remark%> </td>
					</tr>
					</tbody>
				  </table>
				  <table width="100%">
					<colgroup> <col width="30%"> <col width=70%> <tbody>
					<tr class=Title>
					  <th colspan=2><%=SystemEnv.getHtmlLabelName(17088,user.getLanguage())%></th>
					</tr>
					<tr class=Spacing style="height:1px;">
					  <td class=Line1 colspan=2></td>
					</tr>
<!-- 
		  				<!-- 设备功率 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22340,user.getLanguage())%></td>
						<td class=Field><%=equipmentpower%></td>
					  </tr>
						<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>


		  				<!-- 是否海关监管 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22339,user.getLanguage())%></td>
						<td class=Field> 
						<%
							if(issupervision.equals("1")) out.println(SystemEnv.getHtmlLabelName(161,user.getLanguage()));
							else if(issupervision.equals("2")) out.println(SystemEnv.getHtmlLabelName(163,user.getLanguage()));
						%>
						</td>
					  </tr>
						<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>


						<!-- 已付金额 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22338,user.getLanguage())%></td>
						<td class=Field><%=amountpay%></td>
					  </tr>
						<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					
						<!-- 采购状态 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22333,user.getLanguage())%></td>
						<td class=Field> 
						<%
							if(purchasestate.equals("1")) out.println(SystemEnv.getHtmlLabelName(22334,user.getLanguage()));
							else if(purchasestate.equals("2")) out.println(SystemEnv.getHtmlLabelName(22335,user.getLanguage()));
							else if(purchasestate.equals("3")) out.println(SystemEnv.getHtmlLabelName(22336,user.getLanguage()));
							else if(purchasestate.equals("4")) out.println(SystemEnv.getHtmlLabelName(22337,user.getLanguage()));														
						%>	
						</td>
					  </tr>
						<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>
-->
					<%
			boolean hasFF = true;
			RecordSet.executeProc("Base_FreeField_Select","cp");
			if(RecordSet.getCounts()<=0)
				hasFF = false;
			else
				RecordSet.first();

			if(hasFF)
			{
				for(int i=1;i<=5;i++)
				{
					if(RecordSet.getString(i*2+1).equals("1"))
					{%>
					<tr>
					  <td><%=Util.toScreen(RecordSet.getString(i*2),user.getLanguage())%></td>
					  <td class=Field> <%=datefield[i-1]%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}
				}
				for(int i=1;i<=5;i++)
				{
					if(RecordSet.getString(i*2+11).equals("1"))
					{%>
					<tr>
					  <td><%=Util.toScreen(RecordSet.getString(i*2+10),user.getLanguage())%></td>
					  <td class=Field> <%=numberfield[i-1]%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}
				}
				for(int i=1;i<=5;i++)
				{
					if(RecordSet.getString(i*2+21).equals("1"))
					{%>
					<tr>
					  <td><%=Util.toScreen(RecordSet.getString(i*2+20),user.getLanguage())%></td>
					  <td class=Field> <%=Util.toScreen(textfield[i-1],user.getLanguage())%>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}
				}
				for(int i=1;i<=5;i++)
				{
					if(RecordSet.getString(i*2+31).equals("1"))
					{%>
					<tr>
					  <td><%=Util.toScreen(RecordSet.getString(i*2+30),user.getLanguage())%></td>
					  <td class=Field>
						<input type=checkbox name="bff0<%=i%>" value="1" <%if(tinyintfield[i-1].equals("1")){%> checked<%}%> disabled>
					  </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}
				}
				for(int i=1;i<=5;i++)
				{//多文档
					if(RecordSet.getString(i*2+41).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+40)%></td>
						<td class=Field>
						  <span name="docff0<%=i%>span" id="docff0<%=i%>span">
						  <%
						  	String tempdoc[] = Util.TokenizerString2(docff[i-1],",");
						  	if(tempdoc!=null){
						  		for(int j=0;j<tempdoc.length;j++)
						  		out.println("<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+tempdoc[j]+"')>"+DocComInfo.getDocname(tempdoc[j])+"</a> ");
						  	}
						  %>						  
						  </span>
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
				for(int i=1;i<=5;i++)
				{//多部门
					if(RecordSet.getString(i*2+51).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+50)%></td>
						<td class=Field>
						  <SPAN id="depff0<%=i%>span" name="depff0<%=i%>span">
						  <%
						  	String tempdep[] = Util.TokenizerString2(depff[i-1],",");
						  	if(tempdep!=null){
						  		for(int j=0;j<tempdep.length;j++)
						  		out.println(DepartmentComInfo.getDepartmentname(tempdep[j])+" ");
						  	}
						  %>						  
						  </SPAN>
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
				for(int i=1;i<=5;i++)
				{//多客户
					if(RecordSet.getString(i*2+61).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+60)%></td>
						<td class=Field> 
						  <span id="crmff0<%=i%>span" name="crmff0<%=i%>span">
						  <%
						  	String tempcrm[] = Util.TokenizerString2(crmff[i-1],",");
						  	if(tempcrm!=null){
						  		for(int j=0;j<tempcrm.length;j++)
						  		out.println("<a href=javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID="+tempcrm[j]+"')>"+CustomerInfoComInfo.getCustomerInfoname(tempcrm[j])+"</a> ");
						  	}
						  %>
						  </span>
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
				for(int i=1;i<=5;i++)
				{//多请求
					if(RecordSet.getString(i*2+71).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+70)%></td>
						<td class=Field>
						  <span id="reqff0<%=i%>span" name="reqff0<%=i%>span">
						  <%
						  	String tempreq[] = Util.TokenizerString2(reqff[i-1],",");
						  	if(tempreq!=null){
						  		for(int j=0;j<tempreq.length;j++)
						  		out.println("<a href=javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="+tempreq[j]+"')>"+WorkflowRequestComInfo.getRequestName(tempreq[j])+"</a> ");
						  	}
						  %>
						  </span>
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
			}
			%>
					</tbody>
				  </table>
				</td>
			  </tr>
			  </tbody>
			</table>

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
</form>

<Script language="javascript">

function onDelete(obj){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			jQuery("input[name=operation]").val("deletecapital");
			document.forms[0].submit();
            obj.disabled=true;
		}
}
</Script>

</BODY>
</HTML>
