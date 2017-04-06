<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
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
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="DepreMethodComInfo" class="weaver.cpt.maintenance.DepreMethodComInfo" scope="page"/>
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CapitalRelateWFComInfo" class="weaver.cpt.capital.CapitalRelateWFComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String rightStr = "";
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

RecordSet.executeProc("CptCapital_SelectByID",id);
RecordSet.next();
String mark = Util.toScreenToEdit(RecordSet.getString("mark"),user.getLanguage()) ;			/*编码*/
String name = Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage()) ;			/*名称*/
String barcode = Util.toScreenToEdit(RecordSet.getString("barcode"),user.getLanguage()) ;			/*条形码*/
String startdate = Util.toScreenToEdit(RecordSet.getString("startdate"),user.getLanguage()) ;			/*生效日*/
String enddate= Util.toScreenToEdit(RecordSet.getString("enddate"),user.getLanguage()) ;				/*生效至*/
String seclevel= Util.toScreenToEdit(RecordSet.getString("seclevel"),user.getLanguage()) ;				/*安全级别*/
String currencyid = Util.toScreenToEdit(RecordSet.getString("currencyid"),user.getLanguage()) ;	/*币种*/
String capitalcost = Util.toScreenToEdit(RecordSet.getString("capitalcost"),user.getLanguage()) ;	/*成本*/
String startprice = Util.toScreenToEdit(RecordSet.getString("startprice"),user.getLanguage()) ;	/*开始价格*/
String capitaltypeid = Util.toScreenToEdit(RecordSet.getString("capitaltypeid"),user.getLanguage()) ;			/*资产类型*/
String capitalgroupid = Util.toScreenToEdit(RecordSet.getString("capitalgroupid"),user.getLanguage()) ;			/*资产组*/
String unitid = Util.toScreenToEdit(RecordSet.getString("unitid"),user.getLanguage()) ;				/*计量单位*/
String replacecapitalid = Util.toScreenToEdit(RecordSet.getString("replacecapitalid"),user.getLanguage()) ;				/*替代*/
String version = Util.toScreenToEdit(RecordSet.getString("version"),user.getLanguage()) ;			/*版本*/
String itemid = Util.toScreenToEdit(RecordSet.getString("itemid"),user.getLanguage()) ;			/*物品*/
String remark = Util.toScreenToEdit(RecordSet.getString("remark"),user.getLanguage()) ;			/*备注*/
String capitalimageid = Util.getFileidOut(RecordSet.getString("capitalimageid")) ;				/*照片id由SequenceIndex表得到，和使用它的表相关联*/
String depremethod1 = Util.toScreenToEdit(RecordSet.getString("depremethod1"),user.getLanguage()) ;			/*折旧法一*/
String depremethod2 = Util.toScreenToEdit(RecordSet.getString("depremethod2"),user.getLanguage()) ;			/*折旧法二*/
String deprestartdate = Util.toScreenToEdit(RecordSet.getString("deprestartdate"),user.getLanguage()) ;		/*折旧开始日期*/
String depreenddate = Util.toScreenToEdit(RecordSet.getString("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
String customerid= Util.toScreenToEdit(RecordSet.getString("customerid"),user.getLanguage()) ;			/*供应商id*/
String attribute= Util.toScreenToEdit(RecordSet.getString("attribute"),user.getLanguage()) ;
/*属性:
0:自制
1:采购
2:租赁
3:出租
4:维护
5:租用
6:其它
*/
/*new add*/
String depreendprice = Util.toScreenToEdit(RecordSet.getString("depreendprice"),user.getLanguage()) ;	/*折旧底价*/
String capitalspec = Util.toScreenToEdit(RecordSet.getString("capitalspec"),user.getLanguage()) ;	/*规格型号*/
String capitallevel = Util.toScreenToEdit(RecordSet.getString("capitallevel"),user.getLanguage()) ;	/*资产等级*/
String manufacturer = Util.toScreenToEdit(RecordSet.getString("manufacturer"),user.getLanguage()) ;	/*制造厂商*/
String manudate = Util.toScreenToEdit(RecordSet.getString("manudate"),user.getLanguage()) ;	/*出厂日期*/
String sptcount = Util.toScreenToEdit(RecordSet.getString("sptcount"),user.getLanguage()) ;	/*单独核算*/
String stateid = Util.toScreenToEdit(RecordSet.getString("stateid"),user.getLanguage()) ;	/*状态*/
String resourceid= Util.toScreenToEdit(RecordSet.getString("resourceid"),user.getLanguage()) ;	/*相关人力资源*/
String location= Util.toScreenToEdit(RecordSet.getString("location"),user.getLanguage()) ;	/*存放地点*/
String isdata= Util.toScreenToEdit(RecordSet.getString("isdata"),user.getLanguage()) ;	/*资产资料判断*/
String datatype= Util.toScreenToEdit(RecordSet.getString("datatype"),user.getLanguage()) ;	/*资产所属资料*/
String relatewfid= Util.toScreenToEdit(RecordSet.getString("relatewfid"),user.getLanguage()) ;	/*相关工作流*/
String alertnum= Util.toScreenToEdit(RecordSet.getString("alertnum"),user.getLanguage()) ;	/*报警数量*/
String fnamark= Util.toScreenToEdit(RecordSet.getString("fnamark"),user.getLanguage()) ;	/*财务编号*/
String isinner = Util.null2String(RecordSet.getString("isinner")) ;	/*帐内帐外*/
String Invoice = Util.toScreenToEdit(RecordSet.getString("Invoice"),user.getLanguage()) ;			/*发票号码*/
String StockInDate = Util.toScreenToEdit(RecordSet.getString("StockInDate"),user.getLanguage()) ;			/*采购日期*/
String depreyear  = Util.toScreen(RecordSet.getString("depreyear"),user.getLanguage()) ;			/*折旧年限*/
String deprerate  = Util.toScreen(RecordSet.getString("deprerate"),user.getLanguage()) ;			/*折旧率*/
String blongsubcompany = Util.null2String(RecordSet.getString("blongsubcompany"));/*所属分部*/
String blongdepartment = Util.null2String(RecordSet.getString("blongdepartment"));/*所属部门*/
String issupervision = Util.null2String(RecordSet.getString("issupervision"));/*是否海关检查*/
String amountpay = Util.null2String(RecordSet.getString("amountpay")); /*已付金额*/
String purchasestate = Util.null2String(RecordSet.getString("purchasestate"));/*采购状态*/
String departmentid = Util.null2String(RecordSet.getString("departmentid"));/*使用部门*/
String mequipmentpower = Util.null2String(RecordSet.getString("equipmentpower"));/*设备功率*/

String SelectDate= Util.toScreenToEdit(RecordSet.getString("SelectDate"),user.getLanguage()) ; /*购置日期*/
String contractno = Util.toScreenToEdit(RecordSet.getString("contractno"),user.getLanguage());//合同号

if(deprerate.equals("")) deprerate="0";

//added by lupeng 2004.2.19
//avoid sptcount is null
if (sptcount == null || sptcount.equals("") || sptcount.length() == 0)
    sptcount =String.valueOf("0");
//end

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


/*权限判断*/
boolean canedit = false;
RecordSetShare.executeProc("CptCapitalShareInfo_SbyRelated",id);
while(RecordSetShare.next()){
	if(RecordSetShare.getInt("sharetype")==1){
	  if(RecordSetShare.getInt("userid")==user.getUID()){
		if(RecordSetShare.getInt("sharelevel")==2){
			canedit=true;
		}
	  }
	}else if(RecordSetShare.getInt("sharetype")==2){
	  if(RecordSetShare.getInt("departmentid")==user.getUserDepartment()){
		  if(RecordSetShare.getInt("seclevel")<=Util.getIntValue(user.getSeclevel())){
			if(RecordSetShare.getInt("sharelevel")==2){
				canedit=true;
			}
		  }
	  }
	}else if(RecordSetShare.getInt("sharetype")==3){
		if(CheckUserRight.checkUserRight(""+user.getUID(),RecordSetShare.getString("roleid"),RecordSetShare.getString("rolelevel"))){
			if((RecordSetShare.getString("rolelevel").equals("0") && user.getUserDepartment()==RecordSet.getInt("department")) || (RecordSetShare.getString("rolelevel").equals("1") && user.getUserSubCompany1()==RecordSet.getInt("subcompanyid1")) || (RecordSetShare.getString("rolelevel").equals("2")) ){
				  if(RecordSetShare.getInt("seclevel")<=Util.getIntValue(user.getSeclevel())){
					if(RecordSetShare.getInt("sharelevel")==2){
						canedit=true;
					}
				  }
			}
	   }
	}else if(RecordSetShare.getInt("sharetype")==4){
		if(RecordSetShare.getInt("seclevel")<=Util.getIntValue(user.getSeclevel())){
			if(RecordSetShare.getInt("sharelevel")==2){
				canedit=true;
			}
		}
	}
}

RecordSetShare.first();

if(HrmUserVarify.checkUserRight("CptCapitalEdit:Edit",user))  {
	canedit = true;
	rightStr="CptCapitalEdit:Edit";
}

// added by lupeng 2204-07-21 for TD558
boolean canDelete = false;
if (HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
    canDelete = true;
    canedit = true;
    rightStr="Capital:Maintenance";
}
// end

/*可否编辑*/
if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限判断结束*/

String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
if(isdata.equals("1")){
	titlename = SystemEnv.getHtmlLabelName(1509,user.getLanguage())+" : "+name;
}else{
	titlename = SystemEnv.getHtmlLabelName(6055,user.getLanguage())+" : "+name;
}
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

//modify by dongping for TD1371
//在资产被删除以后，在报表中心--资产报表--流转情况里，名称那一栏就变成了空白
//解决方案为: 不让用户去删除资产与资产资料.屏避掉用户的删除按钮

//if(((HrmUserVarify.checkUserRight("CptCapitalEdit:Delete", user))&&stateid.equals("")) || canDelete){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>

<FORM name=frmain id=frmain action=CptCapitalOperation.jsp method=post enctype="multipart/form-data">
	<input type=hidden name=operation value="editcapital">
	<input type=hidden name=id value="<%=id%>">
	<%if(!sptcount.equals("1")){%>
	<input type=hidden value="<%=depreyear%>" name="depreyear">
	<input type=hidden value="<%=deprerate%>" name="deprerate">
	<%}%>
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

			  <table class=ViewForm>
				<colgroup> <col width="49%"> <col width=10> <col width="49%"> <tbody>
				<tr>
				  <td valign=top>
					<table width="100%">
					  <colgroup> <col width=30%> <col width=70%><tbody>
					  <tr class=Title>
						<th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px">
						<td class=Line1 colspan=2></td>
					  </tr>
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
					  <td class=Field> <%=mark%> </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
						<td class=Field>
						  <input class=InputStyle maxlength=60 name="name" size=30
						onChange='checkinput("name","nameimage")' value="<%=name%>">
						  <span id=nameimage><%if (name.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span></td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <% if(!isdata.equals("1")){%>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%></td>
						<td class=Field><input class=InputStyle maxlength=60 name="fnamark" size=30 value="<%=fnamark%>"></td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <%}%>
					  <% if(!isdata.equals("1")){%>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%></td>
						<td class=Field>
						  <input class=InputStyle maxlength=30 size=30
						name="barcode" value="<%=barcode%>">
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <%}%>
					  
					  <tr>
						<td>
						  <%if(!isdata.equals("1")){%>
						  <%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%>
						  <%}else{%>
						  <%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%>
						  <%}%>
						</td>
						<td class=Field><button type=button  class=Browser id=SelectResourceID onClick="onShowResourceID()"></button>
						  <span id=resourceidspan>
						   <%if (resourceid.equals("")) {%>
						     <IMG src='/images/BacoError.gif' align=absMiddle>
						   <%}else{%>
						      <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>
						   <%}%>
						  </span>
						  <input id=resourceid type=hidden name=resourceid value=<%=resourceid%>>
						</td>
					  </tr>
					 <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

					<%if(isdata.equals("2")){%>
					  <tr>
						<td>
						  <%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%>
						</td>
						<td class=Field><button type=button  class=Browser id=Selectdepartmentid onClick="onShowDepartment()"></button>
						  <span id=departmentidspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%><%if (departmentid.equals("")) {%><%}%></span>
						  <input id=departmentid type=hidden name=departmentid value=<%=departmentid%>>
						</td>
					  </tr>
					 <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<%}%>
					
					  <!-- 所属分部 -->
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
						<td class=Field>
						<%if(isdata.equals("1")){%>
						<button type=button  class=Browser onClick="onShowSubcompany('blongsubcompanyspan', 'blongsubcompany')"></button>
						  <span id=blongsubcompanyspan>
						   
						  		<%if(blongsubcompany.equals("")){%>
						  		<IMG src='/images/BacoError.gif' align=absMiddle>
						  		<%}else{%>
						
						  		<%=SubCompanyComInfo.getSubCompanyname(blongsubcompany)%>
						   	<%}%>
						  </span> 
						<%}else{%>
							<%=SubCompanyComInfo.getSubCompanyname(blongsubcompany)%>
						<%}%>
						  <input class=InputStyle id=blongsubcompany value="<%=blongsubcompany%>" type=hidden name=blongsubcompany>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>					

					<% if(isdata.equals("2")){%>	
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></td>
						<td class=Field><%=DepartmentComInfo.getDepartmentname(blongdepartment)%>
						  <input class=InputStyle id=blongdepartment value="<%=blongdepartment%>" type=hidden name=blongdepartment>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					<%}%>
					  <% if(!isdata.equals("1")){%>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></td>
						<td class=Field><button type=button  class=Calendar id=selectstartdate onClick="getstartDate()"></button>
						  <span id=startdatespan style="FONT-SIZE: x-small"><%=startdate%></span>
						  <input type="hidden" name="startdate" value="<%=startdate%>">
						</td>
					  </tr>
						<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></td>
						<td class=Field><button type=button  class=Calendar id=selectenddate onClick="getendDate()"></button>
						  <span id=enddatespan style="FONT-SIZE: x-small"><%=enddate%></span>
						  <input type="hidden" name="enddate" value="<%=enddate%>">
						</td>
					  </tr>
						<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <%}%>
					  
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%></td>						
						  <TD class=Field>
							  <%if (sptcount.equals("1")){%>
							  <IMG src="/images/BacoCheck.gif" border=0>
							  <%} else {%>
							  <IMG src="/images/BacoCross.gif" border=0>
							  <%}%>
							  <input type="hidden" name="sptcount" value="<%=sptcount%>">
							</TD>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <% if(!sptcount.equals("1")&&!isdata.equals("1")){%>
					 <tr>
						<td><%=SystemEnv.getHtmlLabelName(15294,user.getLanguage())%></td>
						<td class=Field>
						  <input class=InputStyle
						maxlength=16 size=10 value="<%=alertnum%>" name="alertnum" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("alertnum");checkinput("alertnum","alertnumimage")'>
						  <span id=alertnumimage><%if (alertnum.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span> </td>
					  </tr>
						<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <%}%>
					  <% if(!isdata.equals("1")&&false){%>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></td>
						<td class=Field><button type=button  class=Browser id=SelectRelateWFID onClick="onShowRelateWFID(relatewfid,relatewfidspan)"></button>
						  <span id=relatewfidspan><%=Util.toScreen(CapitalRelateWFComInfo.getCapitalRelateWFname(relatewfid),user.getLanguage())%></span>
						  <input class=InputStyle type=hidden id=relatewfid name=relatewfid value="<%=relatewfid%>">
						</td>
					  </tr>
						<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <%}%>
					  </tbody>
					</table>
				  </td>
				  <td valign=top width="100%">
					<table width="100%"><tbody>
					  <tr class=Title>
						<th><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px">
						<td class=Line1></td>
					  </tr>
					  <TR>
						<TD class=Field>
						  <% if(capitalimageid.equals("") || capitalimageid.equals("0")) {%>
						  <input type="file" name="capitalimage" class="InputStyle">
						  <%} else {%>
						  <img border=0  width=200 src="/weaver/weaver.file.FileDownload?fileid=<%=capitalimageid%>">
						  <button type=button  class=btnDelete id=Delete accessKey=P onclick="onDelPic()"><U>P</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></BUTTON>
						  <% } %>
						  <input type="hidden" name="oldcapitalimage" value="<%=capitalimageid%>">
						</TD>
					  </TR>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
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
					  <tr class=Spacing style="height:1px">
						<td class=Line1 colspan=2></td>
					  </tr>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
						<td class=Field>
						  <input class=InputStyle maxlength=60 size=30 value="<%=capitalspec%>" name="capitalspec" >
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></td>
						<td class=Field>
						  <input class=InputStyle maxlength=30 size=30 value="<%=capitallevel%>" name="capitallevel" >
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(1364,user.getLanguage())%></td>
						<td class=Field>
						  <input class=InputStyle maxlength=100 size=30 value="<%=manufacturer%>" name="manufacturer" >
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <%if(!isdata.equals("1")){%>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(1365,user.getLanguage())%></td>
						<td class=Field><button type=button  class=Calendar id=selectmanudate onClick="getDate(manudatespan,manudate)"></button>
						  <span id=manudatespan style="FONT-SIZE: x-small"><%=manudate%></span>
						  <input type="hidden" name="manudate" value="<%=manudate%>" >
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <%}%>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></td>
						<td class=Field> <button type=button  class=Browser onClick="onShowCapitaltypeid()"></button>
						  <span id=capitaltypeidspan><%=Util.toScreen(CapitalTypeComInfo.getCapitalTypename(capitaltypeid),user.getLanguage())%><%if (capitaltypeid.equals("") || capitaltypeid.equals("0")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
						  <input type=hidden name=capitaltypeid value="<%if (!capitaltypeid.equals("0")) out.print(capitaltypeid); %>">
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
						<td class=Field> <!--button class=Browser onClick="onShowCapitalgroupid()"></button-->
						  <span id=capitalgroupidspan><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%><%if (capitalgroupid.equals("") || capitalgroupid.equals("0")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
						  <input type=hidden name=capitalgroupid value="<%=capitalgroupid%>">
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></td>
						<td class=Field> <button type=button  class=Browser onClick="onShowCustomerid()"></button>
						  <span id=customeridspan><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid),user.getLanguage())%></span>
						  <input type=hidden name=customerid value="<%=customerid%>">
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
						<td class=Field>
						  <select class=InputStyle id=attribute name=attribute>
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
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
						<td class=Field> <button type=button  class=Browser onClick="onShowUnitid()"></button>
						  <span id=unitidspan><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())%><%if (unitid.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
						  <input type=hidden name=unitid value="<%=unitid%>">
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%></td>
						<td class=Field> <button type=button  class=Browser onClick="onShowReplacecapitalid()"></button>
						  <span id=replacecapitalidspan><%=Util.toScreen(CapitalComInfo.getCapitalname(replacecapitalid),user.getLanguage())%></span>
						  <input type=hidden name=replacecapitalid value="<%=replacecapitalid%>">
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <%if(!isdata.equals("1")){%>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
						<td class=Field>
						  <input class=InputStyle maxlength=100 size=30 value="<%=location%>"
						name="location">
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                    <!--入库日期-->
                    <tr>
                      <td><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></td>
                      <td class=Field>
                          <button type=button  class=Calendar id=selectStockInDate onClick="getDate(StockInDatespan,StockInDate)"></button>
                          <span id=StockInDatespan style="FONT-SIZE: x-small"><%=StockInDate%></span>
                          <input type="hidden" name="StockInDate" value="<%=StockInDate%>">
                        </td>
                    </tr>
                    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></td>
						<td class=Field>
						  <select class=InputStyle id=isinner name=isinner>
							  <option value=1 <% if(isinner.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%></option>
							  <option value=2 <% if(isinner.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%></option>
							</select>
						</td>
					  </tr>
						<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					 <%}%>
					  <!--
					  <tr>
						<td>物品</td>
						<td class=Field> <button type=button  class=Browser onClick="onShowItemid()"></button>
						  <span id=itemidspan><%=Util.toScreen(AssetComInfo.getAssetName(itemid),user.getLanguage())%></span>
						  <input type=hidden name=itemid value="<%=itemid%>">
						</td>
					  </tr>
			 -->
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></td>
						<td class=Field>
						  <input class=InputStyle maxlength=60 size=30 name=version value="<%=version%>">
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  </tbody>
					</table>

<!-- 
					<!-- 附属设备 --//>
					<table width="100%" class=liststyle id=equipment>
					  <tr> 
						<th align="left" colspan=3><%=SystemEnv.getHtmlLabelName(22341,user.getLanguage())%></th>
						<th align="right" colspan=3>
							<button type=button  Class=BtnFlow type=button accessKey=A onclick="addRow1()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
				            <button type=button  Class=BtnFlow type=button accessKey=E onclick="if(isdel()){deleteRow1();}"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
				        </th>
					  </tr>
					  <tr class=Spacing style="height:1px"> 
						<td class=Line1 colspan=6></td>
					  </tr>
					  <tr class=header> 
						<td width="5%"><input type=checkbox class=inputstyle name="equipment_select_all" id="equipment_select_all" onclick="selectall1(this)"></td>
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
							String sql = "select * from cptcapitalequipment where cptid = " + id;
							rs.executeSql(sql);
							boolean trcolor = false;
							while(rs.next()){
								trcolor = !trcolor;
						%>
						<tr class=datalight> 
							<td><input type="checkbox" class=inputstyle name="equipment_select"></td>
							<td><input type=text name="equipmentname" value="<%=rs.getString("equipmentname")%>" class=inputstyle size="10"></td>
							<td><input type=text name="equipmentspec" value="<%=rs.getString("equipmentspec")%>" class=inputstyle size="10"></td>
							<td><input type=text name="equipmentsum" value="<%=rs.getString("equipmentsum")%>" class=inputstyle size="10" onKeyPress="ItemNum_KeyPress()" onchange="checkinputnumber(this)"></td>
							<td><input type=text name="equipmentpower" value="<%=rs.getString("equipmentpower")%>" class=inputstyle size="10"></td>
							<td><input type=text name="equipmentvoltage" value="<%=rs.getString("equipmentvoltage")%>" class=inputstyle size="10"></td>
						</tr>
						<TR> 
							<TD class=Line colSpan=6></TD>
						</TR>               					
					  <%}%>
						<tr style="display:none"></tr>                 					
					</table>

					<!-- 用于复制 --//>
					<table id=equipmenttable style="display:none">
						<tr class=datalight> 
							<td><input type="checkbox" class=inputstyle name="equipment_select"></td>
							<td><input type=text name="equipmentname" class=inputstyle size="10"></td>
							<td><input type=text name="equipmentspec" class=inputstyle size="10"></td>
							<td><input type=text name="equipmentsum" class=inputstyle size="10" onKeyPress="ItemNum_KeyPress()" onchange="checkinputnumber(this)"></td>
							<td><input type=text name="equipmentpower" class=inputstyle size="10"></td>
							<td><input type=text name="equipmentvoltage" class=inputstyle size="10"></td>
						</tr>
						<TR> 
							<TD class=Line colSpan=6></TD>
						</TR>
					</table>
					<!-- 用于复制 --//>

					<!-- 备品配件 --//>
					<table width="100%" class=liststyle id=parts>
					  <tr> 
						<th align="left" colspan=3><%=SystemEnv.getHtmlLabelName(22342,user.getLanguage())%></th>
						<th align="right" colspan=3>
							<button type=button  Class=BtnFlow type=button accessKey=A onclick="addRow2()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
				            <button type=button  Class=BtnFlow type=button accessKey=E onclick="if(isdel()){deleteRow2();}"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
				        </th>
					  </tr>
					  <tr class=Spacing style="height:1px"> 
						<td class=Line1 colspan=6></td>
					  </tr>
					  <tr class=header> 
						<td width="5%"><input type=checkbox class=inputstyle name="parts_select_all" id="parts_select_all" onclick="selectall2(this)"></td>
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
							sql = "select * from cptcapitalparts where cptid = " + id;
							rs.executeSql(sql);							
							trcolor = false;
							while(rs.next()){
								trcolor = !trcolor;
						%>
						<tr class=datalight> 
							<td><input type="checkbox" class=inputstyle name="parts_select"></td>
							<td><input type=text name="partsname" value="<%=rs.getString("partsname")%>" class=inputstyle size="10"></td>
							<td><input type=text name="partsspec" value="<%=rs.getString("partsspec")%>" class=inputstyle size="10"></td>
							<td><input type=text name="partssum" value="<%=rs.getString("partssum")%>" class=inputstyle size="10" onKeyPress="ItemNum_KeyPress()" onchange="checkinputnumber(this)"></td>
							<td><input type=text name="partsweight" value="<%=rs.getString("partsweight")%>" class=inputstyle size="10"></td>
							<td><input type=text name="partssize" value="<%=rs.getString("partssize")%>" class=inputstyle size="10"></td>
						</tr>
						<TR> 
							<TD class=Line colSpan=6></TD>
						</TR>
						<%}%>
						<tr style="display:none"></tr>
					</table>

					<!-- 用于复制 --//>
					<table id=partstable style="display:none">
						<tr class=datalight> 
							<td><input type="checkbox" class=inputstyle name="parts_select"></td>
							<td><input type=text name="partsname" class=inputstyle size="10"></td>
							<td><input type=text name="partsspec" class=inputstyle size="10"></td>
							<td><input type=text name="partssum" class=inputstyle size="10" onKeyPress="ItemNum_KeyPress()" onchange="checkinputnumber(this)"></td>
							<td><input type=text name="partsweight" class=inputstyle size="10"></td>
							<td><input type=text name="partssize" class=inputstyle size="10"></td>
						</tr>
						<TR> 
							<TD class=Line colSpan=6></TD>
						</TR>
					</table>
					<!-- 用于复制 --//>
-->

					<table width="100%">
					  <colgroup> <col width=30%> <col width=70%> <tbody>
					  <tr class=Title>
						<th colspan=2><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px">
						<td class=Line1 colspan=2></td>
					  </tr>
					  <tr>
						<td class=Field>
						  <textarea class=InputStyle  style="width:100%" name=remark rows="6"><%=remark%></textarea>
						</td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  </tbody>
					</table>
				  </td>
				  <td valign=top>
				  <table width="100%">
					  <colgroup> <col width=30%> <col width=70%> <tbody>
					  <tr class=Title>
						<th colspan=2><%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px">
						<td class=Line1 colspan=2></td>
					  </tr>
					  
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></td>
						<td class=Field>
							<button type=button  class=Browser onClick="getDate(SelectDateSpan,SelectDate)"></button>
							<span id="SelectDateSpan"><%=SelectDate%></span>
						  <input id=SelectDate type=hidden name=SelectDate value="<%=SelectDate%>">
						</td>
						<!-- -->
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					<!--合同号-->
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%></td>
					  <td class=Field>
						  <input class=InputStyle
						maxlength=20 size=15 value="<%=contractno%>" name="contractno"></td>
					</tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					  
					  <tr>
						<td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
						<td class=Field><button type=button  class=Browser
						id=SelectCurrencyID onClick="onShowCurrencyID()"></button> <span 
						id=currencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%><%if (currencyid.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
						  <input id=currencyid type=hidden name=currencyid value="<%=currencyid%>">
						</td>
						<!-- -->
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                      <!--价格-->
					  <tr>
					  <td>
					  <% if(isdata.equals("1")){ %>
					  <%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%>
					  <% }else{ %>
					  <%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%>
					  <% } %>
					  </td>
						<td class=Field>
						  <input class=InputStyle
						maxlength=16 size=10 value="<%=startprice%>" name="startprice" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startprice")' value="0"></td>
					  </tr>
					  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                    <!--发票号码-->
					<tr>
					  <td><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></td>
					  <td class=Field>
                        <input class=InputStyle maxlength=30 size=30 value="<%=Invoice%>" name="Invoice">
                      </td>
					</tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

					  </tbody>
					</table>

					<table width="100%">
					  <colgroup> <col width=30%> <col width=70%> <tbody>
                      <!--折旧信息-->
					  <tr class=Title>
						<th colspan=2><%=SystemEnv.getHtmlLabelName(1374,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px">
						<td class=Line1 colspan=2></td>
					  </tr>
                      <!--单独核算时显示-->
                      <%if(sptcount.equals("1")){%>
                      <!--折旧年限-->
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(19598,user.getLanguage())%></td>
						<td class=Field id=txtLocation>
                          <input class=InputStyle maxlength=16 size=10 value="<%=depreyear%>" name="depreyear" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("depreyear")'>
						</td>
					  </tr>
						<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                      <!--残值率-->
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%></td>
						<td class=Field id=txtLocation>
                            <input class=InputStyle maxlength=16 size=10 value="<%=deprerate%>" name="deprerate" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("deprerate")'>%
						</td>
					  </tr>
                      <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                      <%}%>  
                    <!--领用日期-->
                    <tr>
                      <td><%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%></td>
                      <td class=Field>
                          <button type=button  class=Calendar id=selectdeprestartdate onClick="getDate(deprestartdatespan,deprestartdate)"></button>
                          <span id=deprestartdatespan style="FONT-SIZE: x-small"><%=deprestartdate%></span>
                          <input type="hidden" name="deprestartdate" value="<%=deprestartdate%>">
                        </td>
                    </tr>
                    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

					  </tbody>
					</table>
					<table width="100%">
					  <colgroup> <col width="30%"> <col width=70%> <tbody>
					  <tr class=Title>
						<th colspan=2><%=SystemEnv.getHtmlLabelName(17088,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px">
						<td class=Line1 colspan=2></td>
					  </tr>

					<!--
		  				<!-- 设备功率 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22340,user.getLanguage())%></td>
						<td class=Field><input type=text name=mequipmentpower value="<%=mequipmentpower%>" class=inputstyle></td>
					  </tr>
						<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>

 
					  <!-- 是否海关监管 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22339,user.getLanguage())%></td>
						<td class=Field> 
							<select name="issupervision">
								<option value="1" <%if(issupervision.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
								<option value="2" <%if(issupervision.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
							</select>
						</td>
					  </tr>
						<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>


						<!-- 已付金额 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22338,user.getLanguage())%></td>
						<td class=Field> 
						  <input class=InputStyle 
						maxlength=16 size=10 value="<%=amountpay%>" name="amountpay" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("amountpay")'>
					    </td>
					  </tr>
						<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					
						<!-- 采购状态 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22333,user.getLanguage())%></td>
						<td class=Field> 
							<SELECT name="purchasestate">
								<OPTION value="1" <%if(purchasestate.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22334,user.getLanguage())%></OPTION>
								<OPTION value="2" <%if(purchasestate.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22335,user.getLanguage())%></OPTION>
								<OPTION value="3" <%if(purchasestate.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22336,user.getLanguage())%></OPTION>
								<OPTION value="4" <%if(purchasestate.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22337,user.getLanguage())%></OPTION>
							</SELECT>
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
						<td class=Field> <button type=button  class=Calendar onClick="getProjdate(<%=i%>)"></button>
						  <span id=datespan<%=i%> style="FONT-SIZE: x-small"><%=datefield[i-1]%></span>
						  <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=datefield[i-1]%>">
						</td>
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
						<td class=Field>
						  <input class=InputStyle maxlength=30 size=30 name="nff0<%=i%>" value="<%=numberfield[i-1]%>">
						</td>
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
						<td class=Field>
						  <input class=InputStyle maxlength=100 size=30 name="tff0<%=i%>" value="<%=Util.toScreen(textfield[i-1],user.getLanguage())%>">
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
						  <input type=checkbox name="bff0<%=i%>" value="1" <%if(tinyintfield[i-1].equals("1")){%> checked<%}%>>
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
						  <button type=button  class=Browser onClick='onShowMDocid("docff0<%=i%>","docff0<%=i%>span")'></button>
						  <span name="docff0<%=i%>span" id="docff0<%=i%>span">
						  <%
						  	String tempdoc[] = Util.TokenizerString2(docff[i-1],",");
						  	if(tempdoc!=null){
						  		for(int j=0;j<tempdoc.length;j++)
						  		out.println("<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+tempdoc[j]+"')>"+DocComInfo.getDocname(tempdoc[j])+"</a> ");
						  	}
						  %>
						  </span>
						  <input type=hidden name="docff0<%=i%>" value="<%=docff[i-1]%>" class=inputstyle>
						</td>
					  </tr>
						<TR style="height:1px"> 
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
						  <button type=button  class=Browser onClick='onShowDepartmentMutil("depff0<%=i%>span","depff0<%=i%>")'></button>
						  <SPAN id="depff0<%=i%>span" name="depff0<%=i%>span">
						  <%
						  	String tempdep[] = Util.TokenizerString2(depff[i-1],",");
						  	if(tempdep!=null){
						  		for(int j=0;j<tempdep.length;j++)
						  		out.println(DepartmentComInfo.getDepartmentname(tempdep[j])+" ");
						  	}
						  %>						  
						  </SPAN>
						  <input type=hidden name="depff0<%=i%>" value="<%=depff[i-1]%>" class=inputstyle>
						</td>
					  </tr>
						<TR style="height:1px"> 
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
						  <button type=button  class=Browser onClick='onShowCRM("crmff0<%=i%>","crmff0<%=i%>span")'></button>
						  <span id="crmff0<%=i%>span" name="crmff0<%=i%>span">
						  <%
						  	String tempcrm[] = Util.TokenizerString2(crmff[i-1],",");
						  	if(tempcrm!=null){
						  		for(int j=0;j<tempcrm.length;j++)
						  		out.println("<a href=javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID="+tempcrm[j]+"')>"+CustomerInfoComInfo.getCustomerInfoname(tempcrm[j])+"</a> ");
						  	}
						  %>						  
						  </span>
						  <input type=hidden name="crmff0<%=i%>" value="<%=crmff[i-1]%>" class=inputstyle>
						</td>
					  </tr>
						<TR style="height:1px"> 
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
						  <button type=button  class=Browser onClick='onShowRequest("reqff0<%=i%>","reqff0<%=i%>span")'></button>
						  <span id="reqff0<%=i%>span" name="reqff0<%=i%>span">
						  <%
						  	String tempreq[] = Util.TokenizerString2(reqff[i-1],",");
						  	if(tempreq!=null){
						  		for(int j=0;j<tempreq.length;j++)
						  		out.println("<a href=javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="+tempreq[j]+"')>"+WorkflowRequestComInfo.getRequestName(tempreq[j])+"</a> ");
						  	}
						  %>						  
						  </span>
						  <input type=hidden name="reqff0<%=i%>" value="<%=reqff[i-1]%>" class=inputstyle>
						</td>
					  </tr>
						<TR style="height:1px"> 
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
				<tr>
				  <td valign=top>
					</td>
				  <td valign=top>&nbsp; </td>
				</tr>


				</tbody>
			  </table>
<tr>
<td>
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(21777,user.getLanguage())%>&nbsp;</B>
<Br>
<%=SystemEnv.getHtmlLabelName(21769,user.getLanguage())%>&nbsp;
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(21770,user.getLanguage())%>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(21771,user.getLanguage())%>&nbsp;
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(21772,user.getLanguage())%>&nbsp;
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(21773,user.getLanguage())%>&nbsp;
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(21774,user.getLanguage())%>&nbsp;
<BR>
</TD>
</TR>
</TBODY>
</table>
</td>
</tr>
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

</FORM>

<script type="text/javascript">
function onShowCRM(inputname, spanname) {
	var temp = $GetEle(inputname).value;
	id1 = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
							+ temp, "", "dialogWidth:550px;dialogHeight:550px;");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0).length > 500) { // '500为表结构相关客户字段的长度
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
		if (wuiUtil.getJsonValueByIndex(id1, 0).length > 500) { // '500为表结构相关流程字段的长度
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
							+ $GetEle("departmentid").value, "",
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
			$GetEle("resourceidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
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
		if (wuiUtil.getJsonValueByIndex(id, 0) != ""&&wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle("capitaltypeidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitaltypeid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitaltypeidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
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
			"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type=2",
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
	var result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=Capital:Maintenance&selectedids="+$G(inputename).value);
	if(result){
	    if(result.id!=""&&result.id!="0"){
			$G(tdname).innerHTML=result.name;
			$G(inputename).value=result.id;
		}else{
			$G(tdname).innerHTML= "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$G(inputename).value="";
		}
	}
}


function onShowUnitid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("unitidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 2);
			$GetEle("unitid").value = wuiUtil.getJsonValueByIndex(id,
					0);
		} else {
			$GetEle("unitidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$GetEle("unitid").value = "";
		}
	}
}

function onShowItemid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("itemidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("itemid").value = wuiUtil.getJsonValueByIndex(id,
					0);
		} else {
			$GetEle("itemidspan").innerHTML = "";
			$GetEle("itemid").value = "";
		}
	}
}

</script>

<Script language="javascript">
function onDelPic(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(8,user.getLanguage())%>")) {
		$GetEle("operation").value="delpic";
		$GetEle("frmain").submit();
	}
}
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			$GetEle("operation").value="deletecapital";
			$GetEle("frmain").submit();
		}
}
</Script>
<script language="javascript">

function   addRow1(){ //增加附属设备明细   
   
	var   alltbDetailUsed=    $GetEle("equipment").rows;   
	var   theFirstSelectedDetail=alltbDetailUsed.length;   	
	var   newRow   =    $GetEle("equipmenttable").rows[0].cloneNode(true);   
	var   desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );
  
	alltbDetailUsed=    $GetEle("equipment").rows;   
	theFirstSelectedDetail=alltbDetailUsed.length;   	
	newRow   =    $GetEle("equipmenttable").rows[1].cloneNode(true);   
	desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );       
}   
    
function   deleteRow1(){ //删除附属设备明细     
	var   alltbDetailUsed=    $GetEle("equipment").rows;   
	for(var   i=4;i<alltbDetailUsed.length-1;i=i+2){   
		if (alltbDetailUsed[i].all("equipment_select").checked==true){   
			 $GetEle("equipment").deleteRow(i);   
			 $GetEle("equipment").deleteRow(i);   
			i=i-2;   
		}   
	}   
	 $GetEle("equipment_select_all").checked=false;
}

function selectall1(obj){//附属设备全选    
	var   tureorfalse=obj.checked;   
	var   theDetail=equipment.rows;   
	for(var   i=4;i<theDetail.length-1;i=i+2){   
		theDetail[i].all("equipment_select").checked=tureorfalse;   
	}    	
}

function   addRow2(){ //增加备品配件明细   
   
	var   alltbDetailUsed=    $GetEle("parts").rows;   
	var   theFirstSelectedDetail=alltbDetailUsed.length;   	
	var   newRow   =    $GetEle("partstable").rows[0].cloneNode(true);   
	var   desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );
  
	alltbDetailUsed=    $GetEle("parts").rows;   
	theFirstSelectedDetail=alltbDetailUsed.length;   	
	newRow   =    $GetEle("partstable").rows[1].cloneNode(true);   
	desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );       
}   
    
function   deleteRow2(){ //删除备品配件明细     
	var   alltbDetailUsed=    $GetEle("parts").rows;   
	for(var   i=4;i<alltbDetailUsed.length-1;i=i+2){   
		if (alltbDetailUsed[i].all("parts_select").checked==true){   
			 $GetEle("parts").deleteRow(i);   
			 $GetEle("parts").deleteRow(i);   
			i=i-2;   
		}   
	}   
	 $GetEle("parts_select_all").checked=false;
}

function selectall2(obj){//备品配件全选    
	var   tureorfalse=obj.checked;   
	var   theDetail=parts.rows;   
	for(var   i=4;i<theDetail.length-1;i=i+2){   
		theDetail[i].all("parts_select").checked=tureorfalse;   
	}    	
}

function checkinputnumber(obj){
	
	valuechar = obj.value.split("");
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { 
	    charnumber = parseInt(valuechar[i]) ; 
	    if( isNaN(charnumber)&& valuechar[i]!="." && valuechar[i]!="-") 
	    isnumber = true ;
	}
	if(isnumber) obj.value="";
}

function submitData()
{
	//var isStateNull=0;
	var checkStr = "name," ;
	var isdataTemp = <%=isdata%> ;
	var sptcountTemp = <%=sptcount%> ;
	var stateidTemp = "" ;
	<%if (!stateid.equals("")) {%>
		stateidTemp = <%=stateid%>
	<%}%>
	if (isdataTemp!=1)
		if(sptcountTemp!=1) checkStr += "alertnum," ;

	if(stateidTemp!=1) checkStr += "resourceid," ;
	checkStr += "currencyid,capitaltypeid,capitalgroupid,unitid" ;
	if("<%=isdata%>"=="1") checkStr += ",blongsubcompany";
	if (check_form(frmain,checkStr))
		frmain.submit();
}

function onShowDepartmentMutil(spanname, inputname) {
    
    url=escape("/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+ $GetEle(inputname).value);
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth:550px;dialogHeight:550px;");
    try {
    	jsid = new Array();jsid[0] = wuiUtil.getJsonValueByIndex(id, 0); jsid[1] = wuiUtil.getJsonValueByIndex(id, 1);
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

</script>
<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentidspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentidspan.innerHtml = ""
	frmain.departmentid.value=""
	end if
	end if
end sub
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
