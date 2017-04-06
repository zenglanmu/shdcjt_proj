<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="java.math.BigDecimal" %>


<jsp:useBean id="DocSearchForMonitorComInfo" class="weaver.docs.search.DocSearchForMonitorComInfo" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/docs/common.jsp" %>

<HTML>
<head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(16757,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String isFromLeftMenu="0";//是否从左方菜单进入，如果是的话得清除session里的查询条件
String operation = Util.null2String(request.getParameter("operation"));
String needSubmit=Util.null2String(request.getParameter("needSubmit"));
if(operation.equals("")){
	isFromLeftMenu="1";//操作为空则可认为是从左方菜单进入
	//operation="publishDoc";//操作默认为发布
	operation="deleteDoc";//操作默认为删除
}

String loginType = user.getLogintype() ;
String fromSearch = Util.null2String(request.getParameter("fromSearch"));


String docSubject = "";
String mainCategory = "";
String subCategory = "";
String secCategory = "";
String departmentId = "";
String docCreaterId = "";
String userType = "1";//1:员工  2:外部用户
String docCreateDateFrom = ""; 
String docCreateDateTo = "";
String path= Util.null2String(request.getParameter("path"));

double sizeOfAllAccessoryBegin=-1;
double sizeOfAllAccessoryEnd=-1;
double sizeOfSingleAccessoryBegin=-1;
double sizeOfSingleAccessoryEnd=-1;
String docStatusSearch="";

String includeHistoricalVersion="0";//是否包含文档历史版本    1：是  0:否
String includeAccessoryHistoricalVersion="0";//是否包含附件历史版本    1：是  0:否
String checkOutStatus="0";//签出状态    1：自动签出  2：强制签出 0或其它:未签出

if( isFromLeftMenu.equals("0") ) {

	if(fromSearch.equals("1")){

		docSubject = Util.toScreenToEdit(request.getParameter("docSubject"),user.getLanguage());
		mainCategory = Util.null2String(request.getParameter("mainCategory"));
		subCategory= Util.null2String(request.getParameter("subCategory"));
		secCategory= Util.null2String(request.getParameter("secCategory"));
		departmentId= Util.null2String(request.getParameter("departmentId"));
		docCreaterId = Util.null2String(request.getParameter("docCreaterIdSelected"));
		userType = Util.null2String(request.getParameter("userType"));
		docCreateDateFrom = Util.null2String(request.getParameter("docCreateDateFrom"));
		docCreateDateTo = Util.null2String(request.getParameter("docCreateDateTo"));
		if (!secCategory.equals("")) path = "/"+CategoryUtil.getCategoryPath(Util.getIntValue(secCategory));

		sizeOfAllAccessoryBegin = Util.getDoubleValue(request.getParameter("sizeOfAllAccessoryBegin"),-1);
		sizeOfAllAccessoryEnd = Util.getDoubleValue(request.getParameter("sizeOfAllAccessoryEnd"),-1);
        sizeOfSingleAccessoryBegin = Util.getDoubleValue(request.getParameter("sizeOfSingleAccessoryBegin"),-1);
        sizeOfSingleAccessoryEnd = Util.getDoubleValue(request.getParameter("sizeOfSingleAccessoryEnd"),-1);

		docStatusSearch = Util.null2String(request.getParameter("docStatusSearch"));

		includeHistoricalVersion = Util.null2String(request.getParameter("includeHistoricalVersion"));
		includeAccessoryHistoricalVersion = Util.null2String(request.getParameter("includeAccessoryHistoricalVersion"));
		checkOutStatus = Util.null2String(request.getParameter("checkOutStatus"));

		DocSearchForMonitorComInfo.resetSearchInfo() ;
		DocSearchForMonitorComInfo.setDocsubject(docSubject);
		DocSearchForMonitorComInfo.setMaincategory(mainCategory);
		DocSearchForMonitorComInfo.setSubcategory(subCategory);
		DocSearchForMonitorComInfo.setSeccategory(secCategory);
		DocSearchForMonitorComInfo.setDoccreaterid(docCreaterId);
		DocSearchForMonitorComInfo.setDocdepartmentid(departmentId);
		DocSearchForMonitorComInfo.setUsertype(userType);
		//DocSearchForMonitorComInfo.setUserID(""+user.getUID());
		//DocSearchForMonitorComInfo.setLoginType(loginType) ;
		DocSearchForMonitorComInfo.setDoccreatedateFrom(docCreateDateFrom);
		DocSearchForMonitorComInfo.setDoccreatedateTo(docCreateDateTo);
		DocSearchForMonitorComInfo.setSizeOfAllAccessoryBegin(sizeOfAllAccessoryBegin);
		DocSearchForMonitorComInfo.setSizeOfAllAccessoryEnd(sizeOfAllAccessoryEnd);
		DocSearchForMonitorComInfo.setSizeOfSingleAccessoryBegin(sizeOfSingleAccessoryBegin);
		DocSearchForMonitorComInfo.setSizeOfSingleAccessoryEnd(sizeOfSingleAccessoryEnd);
		//DocSearchForMonitorComInfo.setDocStatusSearch(docStatusSearch);

		if(operation.equals("publishDoc")){//操作为发布时,显示状态为"6:待发布"的文档
			DocSearchForMonitorComInfo.addDocstatus("6");
			if(!docStatusSearch.equals("6")){
				docStatusSearch="";
			}
		}

		if(operation.equals("archiveDoc")){//操作为归档时,显示状态为"1:生效/正常  2:生效/正常  "的文档
			DocSearchForMonitorComInfo.addDocstatus("1");
			DocSearchForMonitorComInfo.addDocstatus("2");
			if(!docStatusSearch.equals("1,2")){
				docStatusSearch="";
			}
		}

		if(operation.equals("invalidDoc")){//操作为失效时,显示状态为"1:生效/正常  2:生效/正常  "的文档
			DocSearchForMonitorComInfo.addDocstatus("1");
			DocSearchForMonitorComInfo.addDocstatus("2");
			if(!docStatusSearch.equals("1,2")){
				docStatusSearch="";
			}
		}

		if(operation.equals("cancelDoc")){//操作为作废时,显示状态为"1:生效/正常  2:生效/正常 5:归档 7:失效  "的文档
			DocSearchForMonitorComInfo.addDocstatus("1");
			DocSearchForMonitorComInfo.addDocstatus("2");
			DocSearchForMonitorComInfo.addDocstatus("5");
			DocSearchForMonitorComInfo.addDocstatus("7");
			if(!docStatusSearch.equals("1,2")&&!docStatusSearch.equals("5")&&!docStatusSearch.equals("7")){
				docStatusSearch="";
			}
		}

		if(operation.equals("reopenFromArchiveDoc")){//操作为重新打开归档时,显示状态为"5:归档"的文档
			DocSearchForMonitorComInfo.addDocstatus("5");
			if(!docStatusSearch.equals("5")){
				docStatusSearch="";
			}
		}

		if(operation.equals("reopenFromCancellationDoc")){//操作为重新打开作废时,显示状态为"8:作废"的文档
			DocSearchForMonitorComInfo.addDocstatus("8");
			if(!docStatusSearch.equals("8")){
				docStatusSearch="";
			}
		}

		if(operation.equals("deleteDoc")){//操作为删除时,显示任何状态的文档

		}

		DocSearchForMonitorComInfo.setDocStatusSearch(docStatusSearch);

		DocSearchForMonitorComInfo.setIncludeHistoricalVersion(includeHistoricalVersion);
		DocSearchForMonitorComInfo.setIncludeAccessoryHistoricalVersion(includeAccessoryHistoricalVersion);
		DocSearchForMonitorComInfo.setCheckOutStatus(checkOutStatus);

	}else{


		docSubject = DocSearchForMonitorComInfo.getDocsubject();
		mainCategory = DocSearchForMonitorComInfo.getMaincategory();
		subCategory = DocSearchForMonitorComInfo.getSubcategory();
		secCategory= DocSearchForMonitorComInfo.getSeccategory();
		departmentId= DocSearchForMonitorComInfo.getDocdepartmentid();
		docCreaterId = DocSearchForMonitorComInfo.getDoccreaterid();
		userType = DocSearchForMonitorComInfo.getUsertype();
		docCreateDateFrom = DocSearchForMonitorComInfo.getDoccreatedateFrom();
		docCreateDateTo = DocSearchForMonitorComInfo.getDoccreatedateTo();

		sizeOfAllAccessoryBegin=DocSearchForMonitorComInfo.getSizeOfAllAccessoryBegin();
		sizeOfAllAccessoryEnd=DocSearchForMonitorComInfo.getSizeOfAllAccessoryEnd();
		sizeOfSingleAccessoryBegin=DocSearchForMonitorComInfo.getSizeOfSingleAccessoryBegin();
		sizeOfSingleAccessoryEnd=DocSearchForMonitorComInfo.getSizeOfSingleAccessoryEnd();

        docStatusSearch=DocSearchForMonitorComInfo.getDocStatusSearch();

		if (!secCategory.equals("")) path = "/"+CategoryUtil.getCategoryPath(Util.getIntValue(secCategory));

        includeHistoricalVersion=DocSearchForMonitorComInfo.getIncludeHistoricalVersion();
        includeAccessoryHistoricalVersion=DocSearchForMonitorComInfo.getIncludeAccessoryHistoricalVersion();
        checkOutStatus=DocSearchForMonitorComInfo.getCheckOutStatus();
	}
}else{
    DocSearchForMonitorComInfo.resetSearchInfo() ;
    DocSearchForMonitorComInfo.setUsertype(userType);
	////从左方菜单进入.操作默认为发布,文档状态为'6',待发布.
    //DocSearchForMonitorComInfo.addDocstatus("6");
	//从左方菜单进入.操作默认为删除,文档状态为全部
}


String whereclause = " where " + DocSearchForMonitorComInfo.FormatSQLSearch(user.getLanguage()) ;

boolean  isDocAdmin=false;//当前用户是否为文档管理员
if(HrmUserVarify.checkUserRight("DocEdit:Delete",user)) {//如果具有删除文档的权限,则认为是文档管理员
	isDocAdmin=true ;
}

if(!isDocAdmin){//如果不为系统管理员,则只能查询到当前用户有管理权限的主目录或分目录下的文档

    String userTypeSql=null;
	if(loginType!=null&&loginType.equals("1")){//当前用户为内部用户
	    userTypeSql="    and usertype=0 ";
	}else{
	    userTypeSql="    and usertype>0 ";
	}

    StringBuffer sb=new StringBuffer();
	sb.append(" and exists ( ")
	  .append(" select 1 ")
	  .append("   from DirAccessControlDetail ")
	  .append("  where sourceid=t1.mainCategory ")
	  .append("    and sourcetype=0 ")
	  .append("    and sharelevel=1 ")
	  .append("    and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+ShareManager.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+"))")
	  //.append(userTypeSql)
	  .append("  union  ")
	  .append(" select 1 ")
	  .append("   from DirAccessControlDetail ")
	  .append("  where sourceid=t1.subCategory ")
	  .append("    and sourcetype=1 ")
	  .append("    and sharelevel=1 ")
	  .append("    and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+ShareManager.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+"))")
	  //.append(userTypeSql)
	  .append(" ) ");

	whereclause+=sb.toString();

}

//TD.6662 added by wdl
//whereclause+=" and not exists (select 1 from docdetail where doceditionid > 0 and id<>t1.id and doceditionid = (select doceditionid from docdetail where id = t1.id) and (docstatus <= 0 or docstatus in (3,4,6)) ) ";
//TD.6662 end

if(operation.equals("checkInCompellablyDoc")){
	//whereclause+=" and t1.checkOutStatus='1' ";
	if("1".equals(checkOutStatus)||"2".equals(checkOutStatus)){
		whereclause+=" and t1.checkOutStatus='"+checkOutStatus+"' ";
	}else{
		whereclause+=" and (t1.checkOutStatus='1' or t1.checkOutStatus='2') ";
	}
}

/* td.6856 added by wdl */
//whereclause+=" and (t1.ishistory is null or t1.ishistory = 0) ";
if(operation.equals("deleteDoc")&&"1".equals(includeHistoricalVersion)){

}else{
    whereclause+=" and (t1.ishistory is null or t1.ishistory = 0) ";
}

if(Util.null2String(request.getParameter("docCreateDateFrom")).equals("")) {
	whereclause += " and 1=2 ";
}
//out.println(whereclause);
/*
if(operation.equals("cancelDoc")){
	whereclause+=" and (t1.ishistory is null or t1.ishistory = 0) ";
}
*/
/* added end */

/*
//add by fanggsh 2006-12-06 for TD5514  begin
double sizeOfAllAccessoryBegin = Util.getDoubleValue(request.getParameter("sizeOfAllAccessoryBegin"),-1);
double sizeOfAllAccessoryEnd = Util.getDoubleValue(request.getParameter("sizeOfAllAccessoryEnd"),-1);


if(sizeOfAllAccessoryBegin!=-1||sizeOfAllAccessoryEnd!=-1){
	StringBuffer sb=new StringBuffer();
	sb.append(" and exists ")
	  .append(" (select 1 ")
	  .append("    from ")
	  .append("       ( ")
	  .append("          select b.docId,sum(CAST (a.fileSize as int)) as sumFileSize ")
	  .append("            from imageFile a,DocImageFile b ")
	  .append("           where a.imageFileId=b.imageFileId ")
	  .append("           group by b.docId ")
	  .append("        )docSumFileSize ")
	  .append("    where docId=t1.id ");
	if(sizeOfAllAccessoryBegin!=-1){
		BigDecimal sizeBigDecimal=new BigDecimal(sizeOfAllAccessoryBegin);
		BigDecimal rateBigDecimal=new BigDecimal(1024);
		sizeBigDecimal=sizeBigDecimal.multiply(rateBigDecimal);
		sb.append(" and sumFileSize>= "+sizeBigDecimal.toString());
	}
	if(sizeOfAllAccessoryEnd!=-1){
		BigDecimal sizeBigDecimal=new BigDecimal(sizeOfAllAccessoryEnd);
		BigDecimal rateBigDecimal=new BigDecimal(1024);
		sizeBigDecimal=sizeBigDecimal.multiply(rateBigDecimal);
		sb.append(" and sumFileSize<= "+sizeBigDecimal.toString());
	}
	sb.append(" )");
	whereclause+=sb.toString();
}

double sizeOfSingleAccessoryBegin = Util.getDoubleValue(request.getParameter("sizeOfSingleAccessoryBegin"),-1);
double sizeOfSingleAccessoryEnd = Util.getDoubleValue(request.getParameter("sizeOfSingleAccessoryEnd"),-1);


if(sizeOfSingleAccessoryBegin!=-1||sizeOfSingleAccessoryEnd!=-1){
	StringBuffer sb=new StringBuffer();
	sb.append(" and exists ")
	  .append(" (select 1 ")
	  .append("    from imageFile a,DocImageFile b ")
	  .append("   where a.imageFileId=b.imageFileId ")
	  .append("     and b.docId=t1.id ");
	if(sizeOfSingleAccessoryBegin!=-1){
		BigDecimal sizeBigDecimal=new BigDecimal(sizeOfSingleAccessoryBegin);
		BigDecimal rateBigDecimal=new BigDecimal(1024);
		sizeBigDecimal=sizeBigDecimal.multiply(rateBigDecimal);
		sb.append(" and a.fileSize>= "+sizeBigDecimal.toString());
	}
	if(sizeOfSingleAccessoryEnd!=-1){
		BigDecimal sizeBigDecimal=new BigDecimal(sizeOfSingleAccessoryEnd);
		BigDecimal rateBigDecimal=new BigDecimal(1024);
		sizeBigDecimal=sizeBigDecimal.multiply(rateBigDecimal);
		sb.append(" and a.fileSize<= "+sizeBigDecimal.toString());
	}
	sb.append(" )");
	whereclause+=sb.toString();
}


//add by fanggsh 2006-12-06 for TD5514  end
*/
%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:formreset(),_top}} " ;
RCMenuHeight += RCMenuHeightStep ;

if(operation.equals("publishDoc")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(114,user.getLanguage())+",javascript:publishDoc(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(operation.equals("archiveDoc")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(251,user.getLanguage())+",javascript:archiveDoc(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(operation.equals("invalidDoc")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15750,user.getLanguage())+",javascript:invalidDoc(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(operation.equals("cancelDoc")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15358,user.getLanguage())+",javascript:cancelDoc(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(operation.equals("reopenFromArchiveDoc")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(19686,user.getLanguage())+",javascript:reopenFromArchiveDoc(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(operation.equals("reopenFromCancellationDoc")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(19687,user.getLanguage())+",javascript:reopenFromCancellationDoc(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(operation.equals("deleteDoc")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteDoc(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}


if(operation.equals("checkInCompellablyDoc")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(19688,user.getLanguage())+",javascript:checkInCompellablyDoc(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}




%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=weaver method=post action="DocMonitor.jsp">
<input name=fromSearch type=hidden value="1">
<input name="isInit" id="isInit" type=hidden value="1">

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
  <colgroup>
  <col width="12%">
  <col width="20%">
  <col width="2%">
  <col width="12%">
  <col width="20%">
  <col width="2%">
  <col width="12%">
  <col width="20%">
  <tbody>

    <TR class="Title">
        <TH colSpan=8><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TH>
    </TR>                                
    <TR class="Spacing" style="height:1px;">
        <TD class="Line1" colSpan=8></TD>
    </TR>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
    <td class="field"  colSpan=7>
	  <select class=inputstyle  name=operation onchange="javascript:$('#isInit').val(0);weaver.submit();">
	      <option value="publishDoc" <%if(operation.equals("publishDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></option>
	      <option value="archiveDoc" <%if(operation.equals("archiveDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
	      <option value="invalidDoc" <%if(operation.equals("invalidDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
	      <option value="cancelDoc" <%if(operation.equals("cancelDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
	      <option value="reopenFromArchiveDoc" <%if(operation.equals("reopenFromArchiveDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19686,user.getLanguage())%></option>
	      <option value="reopenFromCancellationDoc" <%if(operation.equals("reopenFromCancellationDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19687,user.getLanguage())%></option>
	      <option value="deleteDoc" <%if(operation.equals("deleteDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></option>
	      <option value="checkInCompellablyDoc" <%if(operation.equals("checkInCompellablyDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19688,user.getLanguage())%></option>
	  </select>
    </td>
    </tr>

    <TR>
        <TD height="10" colspan="2"></TD>
    </TR>

    <TR class="Title">
        <TH colSpan=8><%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%></TH>
    </TR>                                
    <TR class="Spacing" style="height:1px;">
        <TD class="Line1" colSpan=8></TD>
    </TR>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
    <td class="field"  >
      <input type="text"  class=InputStyle  name="docSubject" value="<%=docSubject%>">
    </td>
    <td>&nbsp;</td>
    <td height=22><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td class="field"  ><button type="button"  class=Browser onClick="onShowDept('deptname','departmentId')"></button>
      <span id=deptname>
      <%if(!departmentId.equals("")){%>
      <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentId+""),user.getLanguage())%>
      <%}%>
      </span>
      <input type="hidden" name="departmentId" id="departmentId" value="<%=departmentId%>">
    </td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
    <td class="field"  >
	  <select class=inputstyle  name=userType id="userType" onChange="onChangeUserType()">
	      <%if(isgoveproj==0){%>
		  <option value="1" <%if(userType.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></option>
	      <option value="2" <%if(userType.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
	  <%}else{%>
	  <option value="1" <%if(userType.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
	  <%}%>
	  </select>
      <button type="button"  class=Browser onClick="onShowCreater('docCreaterIdSpan','docCreaterIdSelected')"></button>
      <span id=docCreaterIdSpan>
      <%if(!docCreaterId.equals("") && userType.equals("1") ){%>
      <%=Util.toScreen(ResourceComInfo.getResourcename(docCreaterId+""),user.getLanguage())%>
      <%}else if(!docCreaterId.equals("") && userType.equals("2")){%>
      <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(docCreaterId+""),user.getLanguage())%>
	  <%}%>
      </span>
      <input type="hidden" name="docCreaterIdSelected" id="docCreaterIdSelected" value="<%=docCreaterId%>">

    </td>
  </tr>

  <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>

 <tr>
    <td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
    <td align=left class="field"><button type="button"  class=calendar id=SelectDate onClick="getDateForDocMonitor()"></button>&nbsp;
      <span id=doccreatedatefromspan><%if(Util.null2String(docCreateDateFrom).equals("")){%>
		    	<img src="/images/BacoError.gif" align=absMiddle>
		<%}else{%>
			<%=docCreateDateFrom %>
		<%} %>
		</span>
      <span id="doccreatedatefromspanspan">
		
		    </span>
      -<button type="button"  class=calendar
      id=SelectDate2 onClick="getDate(doccreatedatetospan,docCreateDateTo)"></button>&nbsp;
      <span id=doccreatedatetospan><%=docCreateDateTo%></span>
      <input type="hidden" id="docCreateDateFrom" name="docCreateDateFrom" value="<%=docCreateDateFrom%>" onPropertyChange="checkinput('docCreateDateFrom','doccreatedatefromspan');">
      <input type="hidden" name="docCreateDateTo" value="<%=docCreateDateTo%>">
    </td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></td>
    <td class=field>
    <button type="button"  class=Browser onClick="onSelectCategory()" name=selectCategory></BUTTON>
    <span id=path name=path><%=path%></span>
    <input type=hidden name=mainCategory value="<%=mainCategory%>">
    <INPUT type=hidden name=subCategory value="<%=subCategory%>">
    <INPUT type=hidden name=secCategory value="<%=secCategory%>">
    </td>
    <td>&nbsp;</td>
   <td>
<!--
   <%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%>
-->
   <%=SystemEnv.getHtmlLabelName(19544,user.getLanguage())%>
   </td>
   <td class=field>
<!--
	  <select class=inputstyle  name=operation onchange="javascript:weaver.submit();">
	      <option value="publishDoc" <%if(operation.equals("publishDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></option>
	      <option value="archiveDoc" <%if(operation.equals("archiveDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
	      <option value="invalidDoc" <%if(operation.equals("invalidDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
	      <option value="cancelDoc" <%if(operation.equals("cancelDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
	      <option value="reopenFromArchiveDoc" <%if(operation.equals("reopenFromArchiveDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19686,user.getLanguage())%></option>
	      <option value="reopenFromCancellationDoc" <%if(operation.equals("reopenFromCancellationDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19687,user.getLanguage())%></option>
	      <option value="deleteDoc" <%if(operation.equals("deleteDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></option>
	      <option value="checkInCompellablyDoc" <%if(operation.equals("checkInCompellablyDoc")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19688,user.getLanguage())%></option>
	  </select>
-->
<%
    if(operation.equals("publishDoc")){//操作为发布时,显示状态为"6:待发布"的文档
%>
	  <select class=inputstyle  name=docStatusSearch>
	      <option value=""></option>
	      <option value="6" <%if(docStatusSearch.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
	  </select>
<%
	}else if(operation.equals("archiveDoc")){//操作为归档时,显示状态为"1:生效/正常  2:生效/正常  "的文档
%>
	  <select class=inputstyle  name=docStatusSearch>
	      <option value=""></option>
	      <option value="1,2" <%if(docStatusSearch.equals("1,2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></option>
	  </select>
<%
	}else if(operation.equals("invalidDoc")){//操作为失效时,显示状态为"1:生效/正常  2:生效/正常  "的文档
%>
	  <select class=inputstyle  name=docStatusSearch>
	      <option value=""></option>
	      <option value="1,2" <%if(docStatusSearch.equals("1,2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></option>
	  </select>
<%
	}else if(operation.equals("cancelDoc")){//操作为作废时,显示状态为"1:生效/正常  2:生效/正常 5:归档 7:失效  "的文档
%>
	  <select class=inputstyle  name=docStatusSearch>
	      <option value=""></option>
	      <option value="1,2" <%if(docStatusSearch.equals("1,2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></option>
	      <option value="5" <%if(docStatusSearch.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
	      <option value="7" <%if(docStatusSearch.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
	  </select>
<%
	}else if(operation.equals("reopenFromArchiveDoc")){//操作为重新打开归档时,显示状态为"5:归档"的文档
%>
	  <select class=inputstyle  name=docStatusSearch>
	      <option value=""></option>
	      <option value="5" <%if(docStatusSearch.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
	  </select>
<%
	}else if(operation.equals("reopenFromCancellationDoc")){//操作为重新打开作废时,显示状态为"8:作废"的文档
%>
	  <select class=inputstyle  name=docStatusSearch>
	      <option value=""></option>
	      <option value="8" <%if(docStatusSearch.equals("8")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
	  </select>
<%
	}else if(operation.equals("deleteDoc")){//操作为删除时,显示状态为"1:生效/正常  2:生效/正常 5:归档 7:失效 8:作废"的文档
%>
	  <select class=inputstyle  name=docStatusSearch>
	      <option value=""></option>
	      <option value="0" <%if(docStatusSearch.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
	      <option value="1,2" <%if(docStatusSearch.equals("1,2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></option>
	      <option value="3" <%if(docStatusSearch.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
	      <option value="4" <%if(docStatusSearch.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
	      <option value="5" <%if(docStatusSearch.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
	      <option value="6" <%if(docStatusSearch.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
	      <option value="7" <%if(docStatusSearch.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
	      <option value="8" <%if(docStatusSearch.equals("8")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
	      <option value="9" <%if(docStatusSearch.equals("9")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21556,user.getLanguage())%></option>
	  </select>
<%
	}else if(operation.equals("checkInCompellablyDoc")){//操作为强制签入时,显示状态为"0:草稿   1:生效/正常  2:生效/正常  7:失效 "的文档
%>
	  <select class=inputstyle  name=docStatusSearch>
	      <option value=""></option>
	      <option value="0" <%if(docStatusSearch.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
	      <option value="1,2" <%if(docStatusSearch.equals("1,2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></option>
	      <option value="3" <%if(docStatusSearch.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
	      <option value="4" <%if(docStatusSearch.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
	      <option value="5" <%if(docStatusSearch.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
	      <option value="6" <%if(docStatusSearch.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
	      <option value="7" <%if(docStatusSearch.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
	      <option value="8" <%if(docStatusSearch.equals("8")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
	      <option value="9" <%if(docStatusSearch.equals("9")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21556,user.getLanguage())%></option>
	  </select>
<%
	}
%>
   </td>
  </tr>

  <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>

 <tr>
    <td><%=SystemEnv.getHtmlLabelName(20011,user.getLanguage())%></td>
    <td class="field">
	    <input class=InputStyle  size=6 name="sizeOfAllAccessoryBegin" value="<%=sizeOfAllAccessoryBegin==-1?"":String.valueOf(sizeOfAllAccessoryBegin)%>" onKeyPress="ItemNum_KeyPress('sizeOfAllAccessoryBegin')" onBlur="checknumber1(sizeOfAllAccessoryBegin)">&nbsp;K
		&nbsp;-&nbsp;
		<input class=InputStyle  size=6 name="sizeOfAllAccessoryEnd" value="<%=sizeOfAllAccessoryEnd==-1?"":String.valueOf(sizeOfAllAccessoryEnd)%>" onKeyPress="ItemNum_KeyPress('sizeOfAllAccessoryEnd')" onBlur="checknumber1(sizeOfAllAccessoryEnd)">&nbsp;K
    </td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(20012,user.getLanguage())%></td>
    <td class="field">
	    <input class=InputStyle  size=6 name="sizeOfSingleAccessoryBegin" value="<%=sizeOfSingleAccessoryBegin==-1?"":String.valueOf(sizeOfSingleAccessoryBegin)%>" onKeyPress="ItemNum_KeyPress('sizeOfSingleAccessoryBegin')" onBlur="checknumber1(sizeOfSingleAccessoryBegin)">&nbsp;K
		&nbsp;-&nbsp;
		<input class=InputStyle  size=6 name="sizeOfSingleAccessoryEnd" value="<%=sizeOfSingleAccessoryEnd==-1?"":String.valueOf(sizeOfSingleAccessoryEnd)%>" onKeyPress="ItemNum_KeyPress('sizeOfSingleAccessoryEnd')" onBlur="checknumber1(sizeOfSingleAccessoryEnd)">&nbsp;K
    </td>
    <td>&nbsp;</td>
   <td>
   <%=SystemEnv.getHtmlLabelName(23931,user.getLanguage())%>
   </td>
   <td class=field>
	  <select class=inputstyle  name=includeAccessoryHistoricalVersion>
	      <option value="0" <%if(includeAccessoryHistoricalVersion.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
	      <option value="1" <%if(includeAccessoryHistoricalVersion.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	  </select>

   </td>
  </tr>

  <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>

<%if(operation.equals("deleteDoc")){%>
 <tr>
   <td>
   <%=SystemEnv.getHtmlLabelName(23930,user.getLanguage())%>
   </td>
   <td class=field>
	  <select class=inputstyle  name=includeHistoricalVersion>
	      <option value="0" <%if(includeHistoricalVersion.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
	      <option value="1" <%if(includeHistoricalVersion.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	  </select>

   </td>
    <td>&nbsp;</td>
    <td></td>
    <td>
    </td>
    <td>&nbsp;</td>
    <td></td>
    <td>
    </td>
  </tr>

  <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
<%}else if(operation.equals("checkInCompellablyDoc")){%>
 <tr>
   <td>
   <%=SystemEnv.getHtmlLabelName(21824,user.getLanguage())%>
   </td>
   <td class=field>
	  <select class=inputstyle  name=checkOutStatus>
	      <option value="0"></option>
	      <option value="1" <%if(checkOutStatus.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21807,user.getLanguage())%></option>
	      <option value="1" <%if(checkOutStatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21806,user.getLanguage())%></option>
	  </select>

   </td>
    <td>&nbsp;</td>
    <td></td>
    <td>
    </td>
    <td>&nbsp;</td>
    <td></td>
    <td>
    </td>
  </tr>

  <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
<%}%>

  </tbody>
</table>


                          <%


                            //分页
                            UserDefaultManager.setUserid(user.getUID());
                            UserDefaultManager.selectUserDefault();
                            int perpage = UserDefaultManager.getNumperpage();
                            if(perpage <2) perpage=10;                       
                            
							String backfields="";
							String sqlOrderBy="";
							if(operation.equals("checkInCompellablyDoc")){
								backfields ="t1.id, t1.checkOutUserId,t1.checkOutUserType,t1.checkOutDate,t1.checkOutTime,t1.checkOutStatus,t1.docSubject,t1.maincategory,t1.subCategory,t1.secCategory,t1.docextendname,t1.ownerid,t1.ownerType ";
								sqlOrderBy="checkOutDate,checkOutTime";

							}else{
								backfields ="t1.id, t1.docCreaterId,t1.userType,t1.doccreatedate,t1.doccreatetime,t1.docStatus,t1.docSubject,t1.maincategory,t1.subCategory,t1.secCategory,t1.docextendname,t1.ownerid,t1.ownerType ";
								sqlOrderBy="doccreatedate,doccreatetime";
							}
                           
                            String fromSql = " from docdetail t1  ";

                            String sqlWhere = whereclause;


                            String tableString =" <table instanceid=\"DocMonitorTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+sqlOrderBy+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
                                                 "			<head>"+
                                                 "        <col width=\"3%\"  text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>"+
                                                 "				<col width=\"28%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" otherpara=\"column:docSubject\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameForDocMonitor\"  orderkey=\"docSubject\"/>";

							if(operation.equals("checkInCompellablyDoc")){
                                   tableString+= "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19690,user.getLanguage())+"\" column=\"checkOutUserId\" orderkey=\"checkOutUserId\" otherpara=\"column:checkOutUserType\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\"/>";
							}else{
                                   tableString+= "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" otherpara=\"column:ownerType\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\"/>";
							}												 

												 
							tableString+=        "				<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory,subCategory,secCategory\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
							if(operation.equals("checkInCompellablyDoc")){
                                   tableString+= "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19691,user.getLanguage())+"\" column=\"checkOutDate\" orderkey=\"checkOutDate,checkOutTime\"  otherpara=\"column:checkOutTime\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getCreateTimeForDocMonitor\"/>"+
                                                 "			    <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(21824,user.getLanguage())+"\" column=\"checkOutStatus\" orderkey=\"checkOutStatus\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getCheckOutStatusForDocMonitor\" />";
							}else{
                                   tableString+= "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"docCreateDate,docCreateTime\"  otherpara=\"column:docCreateTime\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getCreateTimeForDocMonitor\"/>"+
                                                 "			    <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docStatus\" orderkey=\"docStatus\" otherpara=\""+user.getLanguage()+"+column:id"+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" />";
							}												 

												 
							tableString+=        "				<col width=\"23%\"  text=\""+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"\" column=\"id\" otherpara=\""+includeAccessoryHistoricalVersion+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAccessoryForDocMonitor\"/>"+
                                                 "			</head>"+   			
                                                 "</table>"; 
                          %>
                          <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run"/>       
                          <TEXTAREA  name="docIdSelected" style="display:none;"></TEXTAREA>
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
<br>
</form>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>



<script language="javascript">
var needSubmit="<%=needSubmit%>";
//提交
function doSubmit() {
	if(check_form(document.weaver,'docCreateDateFrom'))
		document.weaver.submit();
}
if(needSubmit=="1"){
	doSubmit();
}
//发布
function publishDoc(){

	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}

}

//归档
function archiveDoc(){
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}

//失效
function invalidDoc(){
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}

//作废
function cancelDoc(){
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}

//重新打开归档
function reopenFromArchiveDoc(){
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}

//重新打开作废
function reopenFromCancellationDoc(){
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}


//删除
function deleteDoc(){
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
	    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {

            document.weaver.docIdSelected.value=checkedCheckboxId; 
            document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
            document.weaver.submit();
	    }
	}


}

//强制签入
function checkInCompellablyDoc(){
	var checkedCheckboxId=_xtable_CheckedCheckboxId();
    if(checkedCheckboxId==null||checkedCheckboxId==""){
		alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
    }else{
		document.weaver.docIdSelected.value=checkedCheckboxId; 
		document.weaver.action='/system/systemmonitor/docs/DocMonitorOperation.jsp';
		document.weaver.submit();
	}
}
 


function onSelectCategory() {
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas) {
        if(datas.id!=""){
			$("input[name=secCategory]").val(datas.id);
			$("#path").html(datas.path);
        }else{
        	$("input[name=secCategory]").val("");
			$("#path").html("");
        }
	}
}

function onChangeUserType() {
	document.all("docCreaterIdSelected").value="";
	document.all("docCreaterIdSpan").innerHTML ="";
}

function formreset(){
	if(jQuery($GetEle("deptname")).text()){
		jQuery($GetEle("deptname")).text("");
	}
	if(jQuery($GetEle("docCreaterIdSpan")).text()){
		jQuery($GetEle("docCreaterIdSpan")).text("");
	}
	
	if(jQuery($GetEle("doccreatedatetospan")).text()){
		jQuery($GetEle("doccreatedatetospan")).text("");
	}
	if(jQuery($GetEle("doccreatedatefromspan")).text()!=""){
		jQuery($GetEle("doccreatedatefromspan")).html("<img src='/images/BacoError.gif' align=absMiddle>");
	}
	if(jQuery($GetEle("path")).text()){
		jQuery($GetEle("path")).text("");
	}
	
	
	if($GetEle("userType").value!="1"){
		$GetEle("userType").value="1";
	}
	if($GetEle("docStatusSearch").value!=""){
		$GetEle("docStatusSearch").value="";
	}
	if($GetEle("includeAccessoryHistoricalVersion").value!="0"){
		$GetEle("includeAccessoryHistoricalVersion").value="0";
	}
	if($GetEle("includeHistoricalVersion")!=null){
		if($GetEle("includeHistoricalVersion").value!="0"){
			$GetEle("includeHistoricalVersion").value="0";
		}	
	}
	if($GetEle("checkOutStatus")!=null){
		if($GetEle("checkOutStatus").value!="0"){
			$GetEle("checkOutStatus").value="0";
		}	
	}

	if($GetEle("docSubject").value!=""){
		$GetEle("docSubject").value="";
	}
	
	if($GetEle("departmentId").value!=""){
		$GetEle("departmentId").value="";
	}
	if($GetEle("docCreaterIdSelected").value!=""){
		$GetEle("docCreaterIdSelected").value="";
	}
	if($GetEle("docCreateDateFrom").value!=""){
		$GetEle("docCreateDateFrom").value="";
	}
	if($GetEle("docCreateDateTo").value!=""){
		$GetEle("docCreateDateTo").value="";
	}
	if($GetEle("mainCategory").value!=""){
		$GetEle("mainCategory").value="";
	}
	if($GetEle("subCategory").value!=""){
		$GetEle("subCategory").value="";
	}
	if($GetEle("secCategory").value!=""){
		$GetEle("secCategory").value="";
	}
	//alert($GetEle("sizeOfAllAccessoryBegin")!=null);
	if($GetEle("sizeOfAllAccessoryBegin").value!=""){
		$GetEle("sizeOfAllAccessoryBegin").value="";
	}
	if($GetEle("sizeOfAllAccessoryEnd").value!=""){
		$GetEle("sizeOfAllAccessoryEnd").value="";
	}
	if($GetEle("sizeOfSingleAccessoryBegin").value!=""){
		$GetEle("sizeOfSingleAccessoryBegin").value="";
	}
	if($GetEle("sizeOfSingleAccessoryEnd").value!=""){
		$GetEle("sizeOfSingleAccessoryEnd").value="";
	}
	
}

</script>

<script language=javascript>
function onShowDept(tdName,inputName){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("#"+inputName).val())
	if (datas){
	    if (datas.id!= "" ){
			jQuery("#"+tdName).html(datas.name);
			jQuery("#"+inputName).val(datas.id);
		}
		else{
			jQuery("#"+tdName).html("");
			jQuery("#"+inputName).val("");
		}
	}
}



function onShowCreater(tdname,inputename){
	var userType = jQuery("#userType").val();
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	if (userType == "1" )
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	else 
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas) {
	    if (datas.id!=""){
	        jQuery("#"+tdname).html(datas.name);
	        jQuery("#"+inputename).val(datas.id);
		}
	    else{
	        jQuery("#"+tdname).html("");
	        jQuery("#"+inputename).val("");
	    }
	}
}

function getDateForDocMonitor(){
	WdatePicker({el:$('#doccreatedatefromspan')[0],onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		$dp.$($('input[name=docCreateDateFrom]')[0]).value = returnvalue;
		$('#doccreatedatefromspan').html(returnvalue)
	},oncleared:function(dp){
		$dp.$($('input[name=docCreateDateFrom]')[0]).value="";
		$('#doccreatedatefromspan').html("<img src=\"/images/BacoError.gif\" align=\"absMiddle\">");
		
	}});
}

</script>

