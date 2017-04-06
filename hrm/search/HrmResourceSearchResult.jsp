<%--
@modified by Charoes Huang
@Date July 8,2004
@Description For Bug 616 去掉成本中心
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.hrm.appdetach.*" %>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="getAccountType" class="weaver.general.AccountType" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String mode = Prop.getPropValue(GCONST.getConfigFile(), "authentic");
String from = Util.null2String(request.getParameter("from"));
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String sqlwhere = HrmSearchComInfo.FormatSQLSearch();
    //System.out.println("sqlwhere = " + sqlwhere);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);

RecordSet.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(RecordSet.next()){
	perpage =Util.getIntValue(RecordSet.getString(36),-1);
}

if(perpage<=1 )	perpage=10;

/*String temptable = "hrmtemptable"+ Util.getRandom() ;
String Hrm_SearchSql = "";

int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0)*/;

String tempsearchsql = HrmSearchComInfo.FormatSQLSearch();
String dbtype=RecordSet.getDBType() ;
// modify  yangdacheng 2011-12-02 
//注释掉这部分代码是为了兼容自定义字段查询和非自定义字段查询后都能导出EXCEL数据
//if(tempsearchsql.indexOf("cus_fielddata")>0){ //inner join
//tempsearchsql=Util.replace(tempsearchsql,"where"," ",1);
//}

//启用这段代码使用oracle数据库连接时用EXCEL导出数据会出现数据导不出的问题
//else{//left join
    //if(dbtype.equalsIgnoreCase("oracle"))
 //tempsearchsql=Util.replace(tempsearchsql,"where"," ",1);
//}
//去掉"order by"子句,防止下面的查询语句出现错误

String tempstr = "" ;
if(tempsearchsql.length() > 0 && tempsearchsql.indexOf("order by") >=0 ) tempstr = tempsearchsql.substring(0,tempsearchsql.indexOf("order by"));

AppDetachComInfo adci = new AppDetachComInfo();
String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"");
if(!"".equals(tempstr)) tempstr += (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
else tempstr = appdetawhere;

/*if(TotalCount==0){
	if (tempsearchsql.equals("")){
		Hrm_SearchSql = "select count(*) from HrmResource  t1 "+ tempstr;
	}else{
		Hrm_SearchSql = "select count(*) from HrmResource  t1 "+ tempstr;
	}
	RecordSet.executeSql(Hrm_SearchSql);

	if(RecordSet.next()){
	TotalCount = RecordSet.getInt(1);
	}
}
out.println(tempstr);
//tempsearchsql from HrmSearchComInfo will always has a order by clause
if(RecordSet.getDBType().equals("oracle")){
	Hrm_SearchSql = "create table "+temptable+"  as select * from (select t1.* from HrmResource  t1 "+ tempsearchsql+" desc) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
    Hrm_SearchSql = "create table "+temptable+"  as (select t1.* from HrmResource  t1) definition only ";
    RecordSet.executeSql(Hrm_SearchSql);
    Hrm_SearchSql ="insert into "+temptable+ "  (select t1.* from HrmResource  t1 "+ tempsearchsql+" desc fetch first  "+(pagenum*perpage+1)+" rows only)";
}else{
	Hrm_SearchSql = "select top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from HrmResource  t1 "+ tempsearchsql+" desc";
}

//out.print(Hrm_SearchSql) ;
    //System.out.println("Hrm_SearchSql = " + Hrm_SearchSql);
	//System.out.println("HrmSearchComInfo.getDepartment() = "+HrmSearchComInfo.getDepartment());
RecordSet.executeSql(Hrm_SearchSql);

RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by "+HrmSearchComInfo.getOrderby()+") where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select * from  "+temptable+" order by "+HrmSearchComInfo.getOrderby()+" fetch first "+(RecordSetCounts-(pagenum-1)*perpage+1)+" rows only"; 
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by "+HrmSearchComInfo.getOrderby();
}

RecordSet.executeSql(sqltemp);*/

String jobtitleid = Util.null2String(HrmSearchComInfo.getJobtitle());
String departmentid = Util.null2String(HrmSearchComInfo.getDepartment());
String costcenterid = Util.null2String(HrmSearchComInfo.getCostcenter());
String resourcetype = Util.null2String(HrmSearchComInfo.getResourcetype());
String empstatus = Util.null2String(HrmSearchComInfo.getStatus());

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
int subcompanyid=-1;
if(!DepartmentComInfo.getSubcompanyid1(departmentid).equals(""))
    subcompanyid=Integer.parseInt(DepartmentComInfo.getSubcompanyid1(departmentid));

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceAdd:Add",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add", user))
        operatelevel=2;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",/hrm/search/HrmResourceSearch.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",/sendmail/HrmChoice.jsp?issearch="+1+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(from.equals("hrmorg")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:onRefresh(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",/hrm/userdefine/HrmUserDefine.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:onNewResource("+departmentid+"),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"-Excel,javascript:exportExcel(),_self} ";
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

String backfields = "hrmresource.id,lastname,workcode,departmentid,email,telephone,mobile,jobtitle,managerid,dsporder,subcompanyid1,accounttype";
String sqlWhere = " "+tempstr;
String fromSql  = " from HrmResource left join cus_fielddata on hrmresource.id=cus_fielddata.id and cus_fielddata.scopeid=1 ";
String orderby = " dsporder,lastname" ;
String tableString = "";
boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
int isHaveMessagerRight = PluginUserCheck.checkPluginUserRight("messager",user.getUID()+"");


if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
	if(mode != null && mode.equals("ldap")){
		backfields += ",account,seclevel";
	}else{
		backfields += ",loginid,seclevel";
	}
    tableString =" <table instanceid=\"hrmDetailTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"hrmresource.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                 "			<head>"+
                 "				<col width=\"4%\"  text=\""+SystemEnv.getHtmlLabelName(547,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.isOnline\" />";
                 if(flagaccount){
    				 tableString += "				<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(17745,user.getLanguage())+"\" column=\"accounttype\" transmethod=\"weaver.general.AccountType.getAccountType\"  />";                 
                 }
                 tableString +="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"workcode\" orderkey=\"workcode\" />";
                 
                 if(isHaveMessager&&user.getUID()!=1&&isHaveMessagerRight==1){   //是否具有即时通讯功能               
                	 tableString +="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForHR.getMessageName3\" otherpara=\""+user.getUID()+"\" />";
                 }else{
                	 tableString +="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/hrm/resource/HrmResource.jsp?1=1\" target=\"_fullwindow\" />";
                 }
                 
                 tableString +="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" href=\"/hrm/company/HrmDepartment.jsp\"  linkkey=\"subcompanyid\" target=\"_fullwindow\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />"+
                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" linkkey=\"id\" href=\"/hrm/company/HrmDepartmentDsp.jsp\"  target=\"_fullwindow\" />"+
                 "				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(2120,user.getLanguage())+"\" column=\"managerid\" orderkey=\"managerid\"  linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp?1=1\" target=\"_fullwindow\" />"+
                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\" linkkey=\"id\"  transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\" href=\"/hrm/jobtitles/HrmJobTitlesEdit.jsp\" target=\"_fullwindow\"/>"+
                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(421,user.getLanguage())+"\" column=\"telephone\"  />"+
				 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(620,user.getLanguage())+"\"      column=\"mobile\"  />"+
                 "				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(477,user.getLanguage())+"\" column=\"email\"  />";
                 if(mode != null && mode.equals("ldap")){
                	tableString += "<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(412,user.getLanguage())+"\" column=\"account\"  />";
             	}else{
             		tableString += "<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(412,user.getLanguage())+"\" column=\"loginid\"  />";
             	}
                 tableString += "<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\"  />"+
                 "			</head>"+
                 "     <operates width=\"8%\">" +
                 "          <operate href=\"/hrm/resource/HrmResourceSystemView.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(15804,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>" +
                 "     </operates>" +
                 " </table>";
}else{
    tableString =" <table instanceid=\"hrmDetailTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"hrmresource.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                 "			<head>"+
                 "				<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(547,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.isOnline\" />";
                 if(flagaccount){
    				 tableString += "				<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(17745,user.getLanguage())+"\" column=\"accounttype\" transmethod=\"weaver.general.AccountType.getAccountType\"  />";                 
                 }
                 tableString +="				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"workcode\" orderkey=\"workcode\" />";
                 if(isHaveMessager&&user.getUID()!=1&&isHaveMessagerRight==1){   //是否具有即时通讯功能               
                	 tableString +="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForHR.getMessageName3\" otherpara=\""+user.getUID()+"\" />";
                 }else{
                	 tableString +="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/hrm/resource/HrmResource.jsp?1=1\" target=\"_fullwindow\" />";
                 }
                 tableString +="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" href=\"/hrm/company/HrmDepartment.jsp\"  linkkey=\"subcompanyid\" target=\"_fullwindow\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />"+
                 "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" linkkey=\"id\" href=\"/hrm/company/HrmDepartmentDsp.jsp\"  target=\"_fullwindow\" />"+
                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(2120,user.getLanguage())+"\" column=\"managerid\" orderkey=\"managerid\"  linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp?1=1\" target=\"_fullwindow\" />"+
                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\" linkkey=\"id\"  transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\" href=\"/hrm/jobtitles/HrmJobTitlesEdit.jsp\" target=\"_fullwindow\"/>"+
                 "				<col width=\"14%\"   text=\""+SystemEnv.getHtmlLabelName(421,user.getLanguage())+"\" column=\"telephone\"  />"+
				 "				<col width=\"12%\"   text=\""+SystemEnv.getHtmlLabelName(620,user.getLanguage())+"\"      column=\"mobile\"  />"+
				 "				<col width=\"16%\"   text=\""+SystemEnv.getHtmlLabelName(477,user.getLanguage())+"\" column=\"email\"  />"+
                 "			</head>"+
                 " </table>";
}
String sql = "SELECT distinct " + backfields + " " + fromSql + " " + sqlWhere + " ORDER BY " + orderby;
sql = URLEncoder.encode(Util.null2String(sql),"GBK");
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">

    <tr><td height="10" colspan="3"></td></tr>
    <tr>
        <td ></td>
        <td valign="top">
        <TABLE class=Shadow>
            <tr>
                <td valign="top">
                    <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
                    <FORM id=weaver name=frmMain action="HrmResourceSearchResult.jsp" method=post>
                        <input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere%>" >
                    </FORM>
                    <% if(HrmUserVarify.isUserOnline(RecordSet.getString("id"))) {%>
                        <img src="/images/State_LoggedOn.gif">
                    <%}%>
                </td>
            </tr>
        </TABLE>
        </td>
        <td></td>
    </tr>
    <tr><td height="10" colspan="3"></td></tr>
</table>

<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.department.value)
	if Not isempty(id) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmMain.department.value=id(0)
	costcenterspan.innerHtml = ""
	frmMain.costcenter.value=""
	else
	departmentspan.innerHtml = ""
	frmMain.department.value=""
	end if
	end if
end sub

sub onShowCostCenter()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="&frmMain.department.value)
	if Not isempty(id) then
	if id(0)<> 0 then
	costcenterspan.innerHtml = id(1)
	frmMain.costcenter.value=id(0)
	else
	costcenterspan.innerHtml = ""
	frmMain.costcenter.value=""
	end if
	end if
end sub
</script>

<script language=javascript>
function onRefresh(){
	document.frmMain.submit();
}

function onNewResource(departmentid){
	location.href="../resource/HrmResourceAdd.jsp?departmentid="+departmentid;
}
function exportExcel()
{
    document.getElementById("excels").src = "HrmResourceSearchResultExcel.jsp?export=true&sql=<%=sql%>";
}
</script>

</BODY>
</HTML>
