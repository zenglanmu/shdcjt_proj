<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<body>
<%
String from = Util.null2String(request.getParameter("from"));
if(from.equals("tree") || from.equals("location")){
	CptSearchComInfo.resetSearchInfo();
}
boolean hasRight = false;
String rightStr = "";
if(HrmUserVarify.checkUserRight("Capital:Maintenance",user)){
	hasRight = true ;
	rightStr = "Capital:Maintenance";
}
if(!hasRight){
		response.sendRedirect("/notice/noright.jsp");
		return;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

String CurrentUser = ""+user.getUID();

String mark =Util.toScreenToEdit(CptSearchComInfo.getMark(),user.getLanguage());/*编号*/
String name = Util.toScreenToEdit(CptSearchComInfo.getName(),user.getLanguage());/*名称*/
String startdate =  Util.toScreenToEdit(CptSearchComInfo.getStartdate(),user.getLanguage());/*生效日从*/
String startdate1 = Util.toScreenToEdit(CptSearchComInfo.getStartdate1(),user.getLanguage());/*生效日到*/
String enddate= Util.toScreenToEdit(CptSearchComInfo.getEnddate(),user.getLanguage());/*生效至从*/
String enddate1= Util.toScreenToEdit(CptSearchComInfo.getEnddate1(),user.getLanguage());/*生效至到*/
String blongsubcompany = Util.null2String(request.getParameter("blongsubcompany"));//所属分部

String departmentid = Util.toScreenToEdit(CptSearchComInfo.getDepartmentid(),user.getLanguage());/*部门*/
//System.out.println(" 部门:"+Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage()));
String subcompanyid=Util.toScreenToEdit(CptSearchComInfo.getSubcompanyid(),user.getLanguage());//所属分部
//System.out.println("所属分部:"+SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid)));
String resourceid = Util.toScreenToEdit(CptSearchComInfo.getResourceid(),user.getLanguage());		/*人力资源*/
String isinner = Util.toScreenToEdit(CptSearchComInfo.getIsInner(),user.getLanguage());		/*帐内或帐外*/
String capitaltypeid = Util.toScreenToEdit(CptSearchComInfo.getCapitaltypeid(),user.getLanguage());/*资产类型*/
String capitalgroupid = Util.toScreenToEdit(CptSearchComInfo.getCapitalgroupid(),user.getLanguage());/*资产组*/

String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));//分部ID
/*
if("".equals(departmentid) && !from.equals("tree") && !	from.equals("")){
	departmentid = Util.null2String((String)session.getAttribute("HrmContract_departmentid_"+user.getUID()));
}
*/
if(subcompanyid1.equals("") && !from.equals("location") && !from.equals("search") && detachable==1 )
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing style=\"height:1px;\"><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(21922,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}

int ishead=0;
String sqlWhere = "";
CptSearchComInfo.setIsData("1");
if(detachable == 1){
	CptSearchComInfo.setCapblsubid(subcompanyid1);
}
String tempsearchsql = CptSearchComInfo.FormatSQLSearch();
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
if(perpage<=1 )	perpage=10;

//String sqlwhere = "";

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1509,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
    int deplevel=0;
    if(detachable==1){
       deplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Capital:Maintenance",Util.getIntValue(DepartmentComInfo.getSubcompanyid1(departmentid)));
    }else{
      if(HrmUserVarify.checkUserRight("Capital:Maintenance", user))
        deplevel=2;
    }
    //if(deplevel>0){
		//if(HrmUserVarify.checkUserRight("Capital:Maintenance", user)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(22357,user.getLanguage())+",/cpt/capital/CptCapitalAdd.jsp?departmentid="+departmentid+",_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		//}
	//}
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+51+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
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
<FORM id=frmain name=frmain action="CptCapitalMaintenance.jsp" method=post>
<input class=inputstyle type="hidden" name="from">
<input class=inputstyle type="hidden" name="subcompanyid1" value="<%=subcompanyid1%>">
<input class=inputstyle type="hidden" name="blongsubcompany" value="<%=blongsubcompany%>">
<table class=Viewform>
  <tbody>
  <COLGROUP>
    <COL width="15%">
    <COL width="35%">
    <COL width="15%">
    <COL width="35%">

  <TR class=Title>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing style="height:1px;">
    <TD class=Line1 colSpan=4 ></TD>
  </TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
					<td class=Field> 
					<input class=InputStyle maxlength=60 size=30 name="mark" value="<%=mark%>">
					</td>	
    <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
					 <td class=Field> 
					  <input class=InputStyle maxlength=60 name="name" size=30 value="<%=name%>">
					 </td>
  </tr>
	<TR style="height:1px;"> 
						<TD class=Line colSpan=4></TD>
					  </TR>
<tr>
    <td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
					   <td class=Field> <button type=button  class=Browser onClick="onShowCapitalgroupid()"></button> 
					  <span id=capitalgroupidspan ><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%>
					 </span> 
					 <input type=hidden name=capitalgroupid value="<%=capitalgroupid%>">
					 </td>
    <td><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></td>
					  <td class=Field> <button type=button  class=Browser onClick="onShowCapitaltypeid()"></button> 
						 <span id=capitaltypeidspan><%=Util.toScreen(CapitalTypeComInfo.getCapitalTypename(capitaltypeid),user.getLanguage())%></span> 
					   <input type=hidden name=capitaltypeid value="<%=capitaltypeid%>">
					 </td>
  </tr>
<TR style="height:1px;"> 
						<TD class=Line colSpan=4></TD>
					  </TR>
<tr>
    <td><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></td>
					  <td class=Field> 
						<select class=InputStyle id=isinner name=isinner>
						<option value=0 <% if(isinner.equals("")) {%>selected<%}%>></option>
						  <option value=1 <% if(isinner.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%></option>
						  <option value=2 <% if(isinner.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%></option>
						</select>
					  </td>
<td><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Calendar id=selectstartdate onClick="getDate(startdatespan,startdate)"></button> 
						<span id=startdatespan ><%=startdate%></span> 
						<input type="hidden" name="startdate" value="<%=startdate%>">
						- &nbsp;<button type=button  class=Calendar id=selectstartdate1 onClick="getDate(startdate1span,startdate1)"></button> 
						<span id=startdate1span ><%=startdate1%></span> 
						<input type="hidden" name="startdate1" value="<%=startdate1%>">
					  </td>
  </tr>
<TR style="height:1px;"> 
						<TD class=Line colSpan=4></TD>
					  </TR>
<tr>
    
   	 <td><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Calendar id=selectenddate onClick="getDate(enddatespan,enddate)"></button> 
						<span id=enddatespan ><%=enddate%></span> 
						<input type="hidden" name="enddate" value="<%=enddate%>">
						- &nbsp;<button type=button  class=Calendar id=selectenddate1 onClick="getDate(enddate1span,enddate1)"></button> 
						<span id=enddate1span ><%=enddate1%></span> 
						<input type="hidden" name="enddate1" value="<%=enddate1%>">
					  </td>
		<td><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
                 <td class=field >
                <button type=button  class=Browser id=SelectSubCompany onclick="onShowSubcompany()"></BUTTON>
            <SPAN id=subcompanyidspan><%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%></SPAN>
		    <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
        </td>
  		</tr>
<TR style="height:1px;"> 
						<TD class=Line colSpan=4></TD>
					  </TR>
 		 <tr>
    		<td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Browser id=SelectResourceID onClick="onShowResourceID()"></button> 
						<span id=resourceidspan><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>
					</span> 
						<input class=InputStyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
					  </td>
			<!--<td><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></td>
					  <td class=Field><button type=button  class=Browser id=SelectDeparment onClick="onShowDepartment('departmentid', 'departmentspan')"></button> 
						<span id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
						<input id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
					  </td>
					  -->
  </tr>
   <TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
</table>
<br>

<TABLE class=ListStyle cellspacing=1 >
<TBODY>
  <TR>

  </TR>
    <!--TR class=Spacing>
        <TD class=Line1 colSpan=2></TD-->
<%
String backfields = "t1.id,t1.mark,t1.fnamark,t1.location,t1.name,t1.capitalspec,t1.capitalgroupid,t1.resourceid,t1.departmentid,t1.stateid,t1.stockindate,t1.sptcount,t1.depreyear,t1.deprerate,t1.selectdate";
String fromSql  = "";
//String sqlWhere = "";
int resourceLabel =0;
    fromSql  = " from CptCapital  t1 ";
    sqlWhere =  tempsearchsql;
    resourceLabel= 1507;

String orderby = "mark" ;
String tableString = "";
    tableString =" <table instanceid=\"cptcapitalDetailTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                         "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                         "			<head>"+
                         "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"mark\" orderkey=\"mark\" />"+
                         "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\"  orderkey=\"name\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/cpt/capital/CptCapital.jsp\" target=\"_fullwindow\" />"+
                       	 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(831,user.getLanguage())+"\" column=\"capitalgroupid\" orderkey=\"capitalgroupid\"  transmethod=\"weaver.cpt.maintenance.CapitalAssortmentComInfo.getAssortmentName\" />"+
                       	 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(resourceLabel,user.getLanguage())+"\" column=\"resourceid\"  orderkey=\"resourceid\" linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp\" target=\"_fullwindow\" />"+
                         "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(904,user.getLanguage())+"\" column=\"capitalspec\"  />"+
						 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1363,user.getLanguage())+"\" column=\"sptcount\" orderkey=\"sptcount\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.cpt.capital.CapitalComInfo.getIsSptCount\"/>"+
						 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19598,user.getLanguage())+"\" column=\"depreyear\" orderkey=\"depreyear\" />"+
						 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1390,user.getLanguage())+"\" column=\"deprerate\" orderkey=\"deprerate\" />"+
                         "			</head>"+
                         "</table>";
	                   %>
					   <TABLE width="100%" height="100%">
	                         <TR>
	                             <TD valign="top">
	                                 <wea:SplitPageTag isShowTopInfo="true" tableString="<%=tableString%>"   mode="run"/>
	                             </TD>
	                         </TR>
	                     </TABLE>

</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</BODY>
<script language=javascript>
function onSearch(){
	document.frmain.action="/cpt/search/SearchOperation.jsp?from=search";
	$GetEle("frmain").submit();
}
function onReSearch(){
	//document.frmain.from.value = "location";
	//alert(document.frmain.from.value);
	location.href="/cpt/capital/CptCapitalMaintenance.jsp?from=location&subcompanyid1=<%=subcompanyid1%>";
}
</script>

<script type="text/javascript">
function onShowCapitalgroupid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	if (id != undefined || id != null) {
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

function onShowCapitaltypeid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	if (id != undefined || id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			$GetEle("capitaltypeidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitaltypeid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitaltypeidspan").innerHTML = "";
			$GetEle("capitaltypeid").value = "";
		}
	}
}

function onShowSubcompany() {
	var id = null;
	var detachable = <%=detachable%>;
	if (detachable != 1) {
		id = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								+ $GetEle("subcompanyid").value, "",
						"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	} else {
		id = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=<%=rightStr%>&selectedids="
								+ $GetEle("subcompanyid").value, "",
						"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	}
	var issame = false;
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			if (wuiUtil.getJsonValueByIndex(id, 0) == $GetEle("subcompanyid").value) {
				issame = true;
			}
			$GetEle("subcompanyidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("subcompanyid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("subcompanyidspan").innerHTML = "";
			$GetEle("subcompanyid").value = "";
		}
	}
}

function onShowResourceID() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	if (id != undefined || id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("resourceidspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="
					+ wuiUtil.getJsonValueByIndex(id, 0)
					+ "'>"
					+ wuiUtil.getJsonValueByIndex(id, 1);
			+"</A>";
			$GetEle("resourceid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("resourceidspan").innerHTML = "";
			$GetEle("resourceid").value = "";
		}
	}
}

function onShowDepartment(inputname, spanname) {
	var retValue = null;
	if (<%=detachable%> != 1) {
		retValue = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								+ $GetEle(inputname).value, "",
								"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	} else {
		retValue = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr=<%=rightStr%>&selectedids="
								+ $GetEle(inputname).value, "",
						"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	}
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$GetEle(spanname).innerHTML = "<A href=/hrm/company/HrmDepartmentDsp.jsp?id="
					+ wuiUtil.getJsonValueByIndex(retValue, 0)
					+ ">"
					+ wuiUtil.getJsonValueByIndex(retValue, 1) + "</A>";
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(retValue,
					0);
		} else {
			$GetEle(inputname).value = "";
			$GetEle(spanname).innerHTML = "";
		}
	}
}

</script>

<SCRIPT language="VBS" src="/js/browser/LgcAssetUnitBrowser.vbs"></SCRIPT>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>