<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetR" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetRight" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="workPlanSearch" class="weaver.WorkPlan.WorkPlanSearch" scope="session" />

<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
String message = Util.null2String(request.getParameter("message"))  ;
/*查看项目成员*/
String sql_mem="select members,contractids,accessory from Prj_ProjectInfo where id= "+ProjID ;
RecordSet.executeSql(sql_mem);
RecordSet.next();
String Members=Util.null2String(RecordSet.getString("members"));
String project_accessory = Util.null2String(RecordSet.getString("accessory"));//相关附件
String Memname="";
int projidss=1;//为区别项目报表和项目卡片的返回，项目卡片为1

ArrayList Members_proj = Util.TokenizerString(Members,",");
int Membernum = Members_proj.size();

for(int i=0;i<Membernum;i++){
    Memname= Memname+"<a href=\"/hrm/resource/HrmResource.jsp?id="+Members_proj.get(i)+"\">"+Util.toScreen(ResourceComInfo.getResourcename(""+Members_proj.get(i)),user.getLanguage())+"</a>";
    Memname+=" ";
}


/*合同－－项目收入*/
String contractids_prj="";
String sql_conids="select id from CRM_Contract where projid ="+ProjID;
RecordSet.executeSql(sql_conids);
while(RecordSet.next()){
    contractids_prj += ","+ Util.null2String(RecordSet.getString("id"));
}
if(!contractids_prj.equals("")) contractids_prj =contractids_prj.substring(1);



/*项目支出*/
//判断有关项目的费用是否为支出
String projfee = ""; //总支出
String sql_feeid="select * from FnaAccountLog where projectid = "+ProjID;
RecordSet.executeSql(sql_feeid);
String feeids="";
while(RecordSet.next()){
    String prjfeeid = Util.null2String(RecordSet.getString("feetypeid"));
    String sql_check="select feetype from FnaBudgetfeeType where id ="+prjfeeid ;//是否为支出
    rs.executeSql(sql_check);
    rs.next();
    int feetypeid = rs.getInt(1);
    if(feetypeid==1){
        feeids += "," + Util.null2String(RecordSet.getString("id")); //相关项目支出的所有的财务表的id
    }
}
if(!feeids.equals("")){//如果项目有支出的话才算总的支出
    feeids = feeids.substring(1);
    String sql_countfee="select sum(amount) projfee from FnaAccountLog where id in("+feeids+")";
    RecordSet.executeSql(sql_countfee);
    RecordSet.next();
    projfee = Util.null2String(RecordSet.getString(1));//总支出
}
try{
	String fnayear = TimeUtil.getCurrentDateString().substring(0,4);
	String fnayearstartdate = "";
	String fnayearenddate = "";
	RecordSet.executeSql("select startdate, enddate , Periodsid from FnaYearsPeriodsList where fnayear= '"+fnayear+"' and ( Periodsid = 1 or Periodsid = 12 ) ");
	while( RecordSet.next() ) {
	    String Periodsid = Util.null2String(RecordSet.getString( "Periodsid" ) ) ;
	    if( Periodsid.equals("1") ){
	    	fnayearstartdate = Util.null2String(RecordSet.getString( "startdate" ) ) ;
	    }
	    if( Periodsid.equals("12") ){
	    	fnayearenddate = Util.null2String(RecordSet.getString( "enddate" ) ) ;
	    }
	}
	double projfee_ext = BudgetHandler.getExpenseRecursion(fnayearstartdate,fnayearenddate,0,0,0,Util.getIntValue(ProjID),0,0).getRealExpense();
	projfee = ""+(projfee_ext + Util.getDoubleValue(projfee, 0));
}catch(Exception e){}


/*项目状态*/
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID;
RecordSet.executeSql(sql_tatus);
RecordSet.next();
String isactived=Util.null2String(RecordSet.getString("isactived"));

// added by lupeng 2004-08-26.
RecordSet.executeSql("SELECT SUM(realManDays) FROM Prj_TaskProcess WHERE prjid = " + ProjID);
RecordSet.next();
float totalWorkTime = Util.getFloatValue(RecordSet.getString(1), 0);
// end.



//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划

String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
RecordSet.executeSql(sql_prjstatus);
RecordSet.next();
String status_prj=Util.null2String(RecordSet.getString("status"));
if(status_prj.equals("1")||status_prj.equals("2")||status_prj.equals("3")||status_prj.equals("4")||status_prj.equals("5")) isactived="2";
//status_prj=5&&isactived=2,立项批准
//status_prj=1,正常
//status_prj=2,延期
//status_prj=3,完成
//status_prj=4,冻结

String ProcPara = "";
int userid = user.getUID();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;

char flag=Util.getSeparator() ;

//get doc count
DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setProjectid(ProjID);
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
DocSearchManage.getSelectResultCount(whereclause,user) ;
String doccount=""+DocSearchManage.getRecordersize();

//get cowork count
int allCount = CoworkDAO.getAllCoworkCountByProjectId(ProjID);
//get request count
int tempid=Util.getIntValue(ProjID,0);
RelatedRequestCount.resetParameter();
RelatedRequestCount.setUserid(userid);
RelatedRequestCount.setUsertype(usertype);
RelatedRequestCount.setRelatedid(tempid);
RelatedRequestCount.setRelatedtype("proj");
RelatedRequestCount.selectRelatedCount();

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

//get crm count
CRMSearchComInfo.resetSearchInfo();
CRMSearchComInfo.setPrjID(ProjID);
String CRM_SearchSql="";
String crmcount="0";
if(logintype.equals("1")){
	CRM_SearchSql = "select count(distinct t1.id) from CRM_CustomerInfo  t1,"+leftjointable+" t2 "+ CRMSearchComInfo.FormatSQLSearch(user.getLanguage())+" and t1.id = t2.relateditemid";
}else{
	CRM_SearchSql = "select count(*) from CRM_CustomerInfo  t1 "+ CRMSearchComInfo.FormatSQLSearch(user.getLanguage())+" and t1.agent="+user.getUID();
}
RecordSet.executeSql(CRM_SearchSql);
if(RecordSet.next()){
	crmcount = ""+RecordSet.getInt(1);
}

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","p1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();

RecordSet.executeProc("PRJ_Find_LastModifier",ProjID);
RecordSet.first();
String Modifier = Util.null2String(RecordSet.getString(1));
String ModifyDate = Util.null2String(RecordSet.getString(2));


RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/proj/DBError.jsp?type=FindData_VP");
RecordSet.first();

String Creater = Util.null2String(RecordSet.getString("creater"));
String CreateDate = Util.null2String(RecordSet.getString("createdate"));


/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

String ViewSql="select * from PrjShareDetail where prjid="+ProjID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);
//out.print(ViewSql);
if(RecordSetV.next())
{
	 canview=true;
	 if(RecordSetV.getString("usertype").equals("2")){
	 	iscustomer=RecordSetV.getString("sharelevel");
	 }else{
		 if(RecordSetV.getString("sharelevel").equals("2")){
			canedit=true;
			ismanager=true;
		 }else if (RecordSetV.getString("sharelevel").equals("3")){
			canedit=true;
			ismanagers=true;
		 }else if (RecordSetV.getString("sharelevel").equals("4")){
			canedit=true;
			isrole=true;
		 }else if (RecordSetV.getString("sharelevel").equals("5")){
			ismember=true;
		 }else if (RecordSetV.getString("sharelevel").equals("1")){
			isshare=true;
		 }
	 }
}
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
boolean onlyview=false;
if(!canview){
    if(!WFUrgerManager.UrgerHavePrjViewRight(requestid,userid,Util.getIntValue(logintype),ProjID) && !WFUrgerManager.getMonitorViewObjRight(requestid,userid,""+ProjID,"2")){
        response.sendRedirect("/notice/noright.jsp") ;
        return;
    }else{
        onlyview=true;
    }
}
/*权限－end*/

//写viewlog表
String needlog = Util.null2String(request.getParameter("log"));
if(!needlog.equals("n"))
{


String clientip=request.getRemoteAddr();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
RecordSetLog.executeProc("Prj_ViewLog1_Insert",ProjID+""+flag+userid+""+flag+user.getLogintype()+""+flag+CurrentDate+flag+CurrentTime+flag+clientip);
}

//added by lupeng 2004-07-08
String[] params = new String[] {String.valueOf(userid), ProjID};
ArrayList results = new ArrayList();
int resultCount = workPlanSearch.getProjAssociatedCount(params);
//end



%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript"  type='text/javascript' src="/js/weaver.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTaskUtil.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript'src="/js/projTask/TaskNodeXmlDoc.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/TaskDrag.js"></SCRIPT>  
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(610,user.getLanguage())+" - "+Util.null2String(RecordSet.getString("name"));
String newtitlename = titlename;
titlename += " <B>" + SystemEnv.getHtmlLabelName(401,user.getLanguage()) + ":</B>"+CreateDate ;
titlename += " <B>" + SystemEnv.getHtmlLabelName(623,user.getLanguage()) + ":</B>";
if(user.getLogintype().equals("1"))
	titlename += " <A href=/hrm/resource/HrmResource.jsp?id=" + Creater + ">" + Util.null2String(ResourceComInfo.getResourcename(Creater)) + "</a>";
titlename += " <B>" + SystemEnv.getHtmlLabelName(103,user.getLanguage()) + ":</B>"+ModifyDate ;
titlename += " <B>" + SystemEnv.getHtmlLabelName(623,user.getLanguage()) + ":</B>";
if(user.getLogintype().equals("1"))
	titlename += " <A href=/hrm/resource/HrmResource.jsp?id=" + Modifier + ">" + Util.null2String(ResourceComInfo.getResourcename(Modifier)) + "</a>";

String needfav ="1";
String needhelp ="";
%>
<BODY>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
	session.setAttribute("fav_pagename" , newtitlename ) ;	
%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%


 //modify by dongping  当其为项目的中的项目经理和项目某任务的负责人时都可以进

 //TD4078	项目成员可以进入项目卡片编辑页面编辑自己负责的任务
 //modified by hubo,2006-04-05
 //modified by mackjoe,2007-01-04 TD5672 只有项目经理才能编辑卡片和任务
if(!onlyview){
 if((canedit)&&!status_prj.equals("6")&&!status_prj.equals("3")&&!status_prj.equals("4")){ //项目状态为3：完成，4：冻结时;6:待审批，不能编辑
	RCMenu += "{"+SystemEnv.getHtmlLabelName(19770,user.getLanguage())+",/proj/data/EditProject.jsp?ProjID="+ProjID+"&from=viewProject&isManager="+canedit+",_self}";
	RCMenuHeight += RCMenuHeightStep;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(19771,user.getLanguage())+",/proj/data/EditProjectTask.jsp?ProjID="+ProjID+"&from=viewProject&isManager="+canedit+",_self}";
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20521,user.getLanguage())+", /weaver/weaver.file.ExcelOut, ExcelOut} " ;
    RCMenuHeight += RCMenuHeightStep;
};

RCMenu += "{"+SystemEnv.getHtmlLabelName(1332,user.getLanguage())+",/proj/process/ViewProcess.jsp?log=n&ProjID="+ProjID+",_self}";
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1297,user.getLanguage())+",/proj/report/PlanAndProcess.jsp?ProjID="+ProjID+",_self}";
RCMenuHeight += RCMenuHeightStep;


RCMenu += "{"+SystemEnv.getHtmlLabelName(1239,user.getLanguage())+",javascript:document.workflow.submit(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1986,user.getLanguage())+",javascript:document.doc.submit(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;

if(!user.getLogintype().equals("2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(926,user.getLanguage())+",/meeting/search/SearchOperation.jsp?log=n&projectid="+ProjID+",_self}";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",/proj/data/AddShare.jsp?prjid="+ProjID+",_self}";
RCMenuHeight += RCMenuHeightStep;
};
RCMenu += "{"+SystemEnv.getHtmlLabelName(618,user.getLanguage())+",/proj/data/ViewLog.jsp?log=n&ProjID="+ProjID+",_self}";
RCMenuHeight += RCMenuHeightStep;

if(isactived.equals("2")  && ismanager){

RCMenu += "{"+SystemEnv.getHtmlLabelName(2228,user.getLanguage())+",/proj/plan/PlanOperation.jsp?ProjID="+ProjID+"&method=normal,_self}";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2229,user.getLanguage())+",/proj/plan/PlanOperation.jsp?ProjID="+ProjID+"&method=delay,_self}";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2230,user.getLanguage())+",/proj/plan/PlanOperation.jsp?ProjID="+ProjID+"&method=complete,_self}";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2231,user.getLanguage())+",/proj/plan/PlanOperation.jsp?ProjID="+ProjID+"&method=freeze,_self}";
RCMenuHeight += RCMenuHeightStep;
};

/* added by hubo 2005-08-29*/
if(ismanager){
RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())+",javascript:saveAsTemplet(),_self}";
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+",/docs/docs/DocList.jsp?prjid="+ProjID+"&isExpDiscussion=y,_self}";
RCMenuHeight += RCMenuHeightStep;
}
}
/*
//TD2518
//modified by hubo,2006-03-15
if(!status_prj.equals("4")){
RCMenu += "{-}";
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+",javascript:submitData(),_top}";
RCMenuHeight += RCMenuHeightStep;
}
*/
%>





	<%
	String topage= URLEncoder.encode("/proj/data/ViewProject.jsp?ProjID="+ProjID);
	%>
	<form name=workflow method=get action="/workflow/request/RequestType.jsp" target="_blank">
		<input type=hidden name=topage value='<%=topage%>'>
		<input type=hidden name=prjid value='<%=ProjID%>'>
	</form>
	<form name=doc method=post action="/docs/docs/DocList.jsp" target="_blank">
		<input type=hidden name=topage value='<%=topage%>'>
		<input type=hidden name=prjid value='<%=ProjID%>'>
	</form>

<!--added by hubo, 2005/09/01-->
<form name="formProjInfo" id="formProjInfo" method="post" style="display:">
	<!--ProjectBaseInfo-->
	<input type="hidden" name="templetName">
	<input type="hidden" name="txtPrjType" value="<%=RecordSet.getString("prjtype")%>">
	<input type="hidden" name="workType" value="<%=RecordSet.getString("worktype")%>">
	<input type="hidden" name="members" value="<%=RecordSet.getString("members")%>">
	<input type="hidden" name="isMemberSee" value="<%=RecordSet.getString("isblock")%>">
	<input type="hidden" name="crms" value="<%=RecordSet.getString("description")%>">
	<input type="hidden" name="isCrmSee" value="<%=RecordSet.getString("managerview")%>">
	<input type="hidden" name="parentProId" value="<%=RecordSet.getString("parentid")%>">
	<input type="hidden" name="commentDoc" value="<%=RecordSet.getString("envaluedoc")%>">
	<input type="hidden" name="confirmDoc" value="<%=RecordSet.getString("confirmdoc")%>">
	<input type="hidden" name="adviceDoc" value="<%=RecordSet.getString("proposedoc")%>">
	<input type="hidden" name="manager" value="<%=RecordSet.getString("manager")%>">


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
        <%if(message.equals("1")){%>
            <table width="100%">
            <tr><td width="80%" align=left>
                <font color="red">
                    找不到对应的工作流，无法提交审批！
                </font>
            </td></tr>
            </table>
        <%}%>
<TABLE class=viewform>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>

	<TD vAlign=top>

	  <TABLE class=viewform id="tblProjBaseInfo">
        <thead>
        <TR class=title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
		  </thead>
		<tbody>
        <TR>
          <TD width="30%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD width="70%" class=Field><%=RecordSet.getString("name")%></TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>

        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(17852,user.getLanguage())%></TD>
            <TD class=Field><%=RecordSet.getString("proCode")%></TD>
        </TR>
        <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(ProjectTypeComInfo.getProjectTypename(RecordSet.getString("prjtype")),user.getLanguage())%></TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>

        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(18375,user.getLanguage())%></TD>
            <TD class=Field>
            <%
                String templetId = RecordSet.getString("proTemplateId");
                if (!"".equals(templetId)) {
                    rs.executeSql("select templetName from Prj_Template where id="+templetId);
                    if (rs.next()){
                        out.println(rs.getString(1));
                    }
                }            
            %>
            
            </TD>
        </TR>
        <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(WorkTypeComInfo.getWorkTypename(RecordSet.getString("worktype")),user.getLanguage())%></TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></TD>
          <TD class=Field>         
		   <%if(status_prj.equals("0")){%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%>
		  <%if(status_prj.equals("7")){%><%=SystemEnv.getHtmlLabelName(1010,user.getLanguage())%><%}%>
		   <%if(status_prj.equals("6")){%><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%><%}%>
          <%if(status_prj.equals("5")){%><%=SystemEnv.getHtmlLabelName(2243,user.getLanguage())%><%}%>
          <%if(status_prj.equals("1")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%><%}%>
          <%if(status_prj.equals("2")){%><%=SystemEnv.getHtmlLabelName(2244,user.getLanguage())%><%}%>
          <%if(status_prj.equals("3")){%><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%><%}%>
          <%if((status_prj.equals("4"))){%><%=SystemEnv.getHtmlLabelName(1232,user.getLanguage())%><%}%>
          </TD>
        </TR>
   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>


         <TR>
          <TD>
		  	<%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%>
		  </TD>
          <TD class=Field><%=Memname%></TD>
        </TR>
            <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(624,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT type=checkbox  value=1 <%if(RecordSet.getString("isblock").equals("1")){%> checked <%}%> disabled >
          </TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
          <TD class=Field>

			<%if(!RecordSet.getString("description").equals("")){
				ArrayList arraycrmids = Util.TokenizerString(RecordSet.getString("description"),",");
				for(int i=0;i<arraycrmids.size();i++){
			%>
						<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=""+arraycrmids.get(i)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+arraycrmids.get(i))%></a>&nbsp
			<%}}%>

		  </TD>
        </TR>
            <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15263,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT type=checkbox  value=1 <%if(RecordSet.getString("ManagerView").equals("1")){%> checked <%}%> disabled >
          </TD>
        </TR>   
        <%
	      String[] fjmultiID = Util.TokenizerString2(project_accessory,",");
          String fjnamestr = "";
		  int linknum=-1;
		  for(int j=0;j<fjmultiID.length;j++){			  									
			String sql = "select id,docsubject,accessorycount from docdetail where id ="+fjmultiID[j]+" order by id asc";
			rs.executeSql(sql);
			linknum++;
			if(rs.next()){
			  String showid = Util.null2String(rs.getString(1)) ;
			  String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
			  int accessoryCount=rs.getInt(3);
			  DocImageManager.resetParameter();
			  DocImageManager.setDocid(Integer.parseInt(showid));
			  DocImageManager.selectDocImageInfo();
			  String docImagefilename = "";
			  if(DocImageManager.next()){
				//DocImageManager会得到doc第一个附件的最新版本
				docImagefilename = DocImageManager.getImagefilename();
			  }
			  fjnamestr += "<a href='/docs/docs/DocDsp.jsp?id="+fjmultiID[j]+"' target='_blank'>"+docImagefilename+"</a>&nbsp;";
		    }			
		  }
        %>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TD>
          <TD class=Field>
            <%=Util.toScreen(fjnamestr,user.getLanguage())%>
          </TD>
        </TR>         
        <TR style="height:1px;"> <TD class=line1 colSpan=2></TD></TR>


	    <table class="viewform" id="tblProjStatistics">
		<thead>
	    <TR class=title>
            <Th colSpan=2><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></Th>
          </TR>
        <TR  style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
		</thead>
		<tbody>
<%if(!user.getLogintype().equals("2")){%>
	<tr>

	<td ><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%>
	<td  class=Field><a href="/fna/report/expense/FnaExpenseProjectDetail.jsp?projectid=<%=ProjID%>&projidss=1"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></td></tr>
	           <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
<%}%>

<tr>

<td ><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></td>
<td  class=Field><a href="/CRM/search/SearchOperation.jsp?PrjID=<%=ProjID%>">
<%=crmcount%></a></td></tr>
           <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
<tr>
<td ><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
<td class="Field"><a href="/docs/search/DocSearchTemp.jsp?projectid=<%=ProjID%>&docstatus=6">
<%=doccount%></a></td></tr>
           <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>

<tr>
<td ><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></td>
<td class="Field"><a href="/cowork/coworkview.jsp?projectid=<%=ProjID%>&type=all">
<%=allCount%></a></td></tr>
           <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>

<tr>
<td ><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%>)</td>
<td class="Field">
<a href="/workflow/search/WFSearchTemp.jsp?prjids=<%=ProjID%>&nodetype=0">

<%=RelatedRequestCount.getCount0()%></A></TD></TR>
           <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
<tr>
<td ><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>)</td>
<td class="Field"><a
 href="/workflow/search/WFSearchTemp.jsp?prjids=<%=ProjID%>&nodetype=1">
<%=RelatedRequestCount.getCount1()%></A></TD></tr>
           <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>

<tr>
<td ><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%>)</td>
<td class="Field"><a href="/workflow/search/WFSearchTemp.jsp?prjids=<%=ProjID%>&nodetype=2">
<%=RelatedRequestCount.getCount2()%></A></TD></TR>
           <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>

<tr>
<td ><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(553,user.getLanguage())%>)
</td><td class="Field"> <a href="/workflow/search/WFSearchTemp.jsp?prjids=<%=ProjID%>&nodetype=3">
<%=RelatedRequestCount.getCount3()%></A></TD></TR>
      <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
 <tr>
<td   ><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>)</td>
<td class="Field"  width="70%"><a href="/workflow/search/WFSearchTemp.jsp?prjids=<%=ProjID%>">
<%=RelatedRequestCount.getTotalcount()%></a></td></tr>
<!--added by lupeng 2004-07-08-->
<TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
 <tr>
<td   ><%=SystemEnv.getHtmlLabelName(16652,user.getLanguage())%></td>
<td class="Field"  width="70%"><a href="/workplan/search/WorkPlanSearchResult.jsp?prjids=<%=ProjID%>&from=1">
<%=resultCount%></a></td></tr>
<TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
<!--end-->


<%
String workday03 = "";
String begindate03 = "";
String enddate03 = "";
String finish = "0";
String fixedcode="0";
float finish_1=0;
int finish_2 =0;

ProcPara = ProjID;
RecordSet2.executeProc("Prj_TaskProcess_Sum",ProcPara);
if(RecordSet2.next()){
    if (!Util.null2String(RecordSet2.getString("workday")).equals("")){
    	workday03 = Util.null2String(RecordSet2.getString("workday"));
    	if(!Util.null2String(RecordSet2.getString("begindate")).equals("x"))
             begindate03 = Util.null2String(RecordSet2.getString("begindate"));
    	if(!Util.null2String(RecordSet2.getString("enddate")).equals("-")) 
            enddate03 = Util.null2String(RecordSet2.getString("enddate"));
    
    	finish_1=0;
        finish_1 = Util.getFloatValue(RecordSet2.getString("finish"),0);
        finish_2 = (int) finish_1;
        
        fixedcode = Util.null2String(RecordSet2.getString("fixedcost"));
    }
}

String conStr="";
String countprj ="";
String prjincome ="";
String prjconsum ="";
if(!contractids_prj.equals("")){
    /*项目实际收入*/
    conStr="select sum(t1.amount) from FnaAccountLog t1,FnaBudgetfeeType t2  where t1.releatedid in("+contractids_prj+") and t1.iscontractid='1' and  t2.id=t1.feetypeid and t2.feetype='2' and t1.projectid ="+ ProjID;
    RecordSetC.executeSql(conStr);
    RecordSetC.next();
    prjincome = RecordSetC.getString(1);
    /*项目金额＝合同金额的累加*/
    countprj ="select sum(price) from CRM_Contract where id in ("+contractids_prj+")";
    RecordSetC.executeSql(countprj);
    RecordSetC.next();
    prjconsum = RecordSetC.getString(1);
}

%>


        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
          <TD class=Field><%=begindate03%></TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
          <TD class=Field><%=enddate03%></TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></TD>
          <TD class=Field><%=workday03%></TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></TD>
          <TD class=Field height="100%">

            <TABLE height="100%" cellSpacing=0 width="100%">
            <TBODY>
         <TR>
            <%if(finish_1==0){%>
            <td><%=finish%>%</TD>
            <%}else{%>
          <TD
          <%if(finish_2==100){%>
          class=redgraph
          <%}else{%>
          class=greengraph
          <%}%>
          width="<%=finish_1%>%"></td><td><%=finish_2%>%</TD>
             <%}%>
          <TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></TD></TR></TBODY></TABLE>

          </TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
		   <!--added by lupeng 2004-08-26-->
		   <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17544,user.getLanguage())%></TD>
          <TD class=Field><%=totalWorkTime%></TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
		   <!--end-->
        <%if(!user.getLogintype().equals("2")){%>
                <TR>
                <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
                <TD class=Field><%=fixedcode%> </TD>
                </TR>
                   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR><TR>
                <TD><%=SystemEnv.getHtmlLabelName(15264,user.getLanguage())%></TD>
                <TD class=Field><%=projfee%> </TD>
                </TR>   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
                <TR>
                <TD><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%></TD>
                <TD class=Field><%=prjconsum%> </TD>
                </TR>   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
                <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15265,user.getLanguage())%></TD>
                <TD class=Field><%=prjincome%> </TD>
                </TR>   <TR style="height:1px;"> <TD class=line1 colSpan=2></TD></TR>
        <%}%>
        </TBODY>
	  </TABLE>

                                     <!--自定义字段部分 B 项目类型自定义字段部分-->   
                                        <TABLE class=ViewForm  valign="top" id="tblProjTypeFreeField">
                                         <thead>
                                        <tr class="title"><th colspan="2"><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17088,user.getLanguage())%></th></tr>
                                        <tr class="spacing" style="height:1px;"><td class="line1" colSpan="2"></td></tr>
                                        </thead>
                                        <tbody>

                                        <%
                                            
                                            CustomFieldManager cfm = new CustomFieldManager("ProjCustomField",Util.getIntValue(RecordSet.getString("prjtype")));
                                            cfm.getCustomFields();                                            cfm.getCustomData("ProjCustomFieldReal",Util.getIntValue(RecordSet.getString("prjtype")),Util.getIntValue(ProjID));
                                            while(cfm.next()){
                                                String fieldvalue = "";
                                                if(cfm.getHtmlType().equals("2")){
                                                	fieldvalue = Util.null2String(cfm.getData("field"+cfm.getId()));
                                                }else{
                                                	fieldvalue = Util.toHtml(cfm.getData("field"+cfm.getId()));
                                                }
                                        %>
                                            <tr>
                                              <td width="30%" <%if(cfm.getHtmlType().equals("2")){%> valign=top <%}%>> <%=cfm.getLable()%> </td>
                                              <td width="70%" class=field >
                                              <%
                                                if(cfm.getHtmlType().equals("1")||cfm.getHtmlType().equals("2")){
                                              %>
                                              <%=fieldvalue%>
                                              <%
                                                }else if(cfm.getHtmlType().equals("3")){

                                                    String fieldtype = String.valueOf(cfm.getType());
                                                    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                                                    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                                                    String showname = "";                                   // 新建时候默认值显示的名称
                                                    String showid = "";                                     // 新建时候默认值


                                                    if(fieldtype.equals("2") ||fieldtype.equals("19")){
                                                        showname=fieldvalue; // 日期时间
                                                    }else if(!fieldvalue.equals("")) {
                                                        String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                                                        String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                                                        String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                                                        String sql = "";

                                                        HashMap temRes = new HashMap();

                                                        if(fieldvalue.startsWith(",")){
															fieldvalue = fieldvalue.substring(1);
														}
                                                    	if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("152") ||  fieldtype.equals("135")) {    // 多人力资源,多客户,多会议，多文档
                                                            sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                                                        }
                                                        else {
                                                            sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                                                        }

                                                        RecordSet2.executeSql(sql);
                                                        while(RecordSet2.next()){
                                                            showid = Util.null2String(RecordSet2.getString(1)) ;
                                                            String tempshowname= Util.null2String(RecordSet2.getString(2)) ;
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
                                                        if(fieldtype.equals("16")||fieldtype.equals("152")){
                                                        	showname = Util.StringReplace(showname,"isrequest=1&","");
                                                        }                                                        

                                                    }


                                              %>
                                                <span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%></span>
                                               <%
                                                }else if(cfm.getHtmlType().equals("4")){
                                               %>
                                                <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> disabled >
                                               <%
                                                }else if(cfm.getHtmlType().equals("5")){
                                                    cfm.getSelectItem(cfm.getId());
                                               %>
                                               <%
                                                    while(cfm.nextSelect()){
                                                        if(cfm.getSelectValue().equals(fieldvalue)){
                                               %>
                                                    <%=cfm.getSelectName()%>
                                               <%
                                                            break;
                                                        }
                                                    }
                                               %>
                                               <%
                                                }
                                               %>
                                                    </td>
                                                </tr>
                                                  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                                               <%
                                            }
                                               %>
															  </tbody>
                                                </table>

                                    <!--end   自定义字段-->

	</TD>

	<TD></TD>

	<TD vAlign=top  style="word-break: break-all;"  >

	  <TABLE class=viewform id="tblProjManageInfo">
        <COLGROUP>
        <col width="30%">
        <col width="70%">
        </COLGROUP>
        <thead>      
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(633,user.getLanguage())%></TH>
				<th style="text-align:right">
					<span class="spanSwitch" onClick="doSwitch('tblProjBaseInfo,tblProjManageInfo')"><img style='cursor:pointer' src='/images/up.jpg'></span>
				</th>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
			 </thead>
		<tbody>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(636,user.getLanguage())%></TD>        
          <TD class=Field><A href="/proj/data/ViewProject.jsp?ProjID=<%=RecordSet.getString("parentid")%>"><%=ProjectInfoComInfo.getProjectInfoname(RecordSet.getString("parentid"))%></a></TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(637,user.getLanguage())%></TD>
          <TD class=Field>
          <a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("envaluedoc")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("envaluedoc")),user.getLanguage())%></a>
          </TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(638,user.getLanguage())%></TD>
          <TD class=Field>
          <a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("confirmdoc")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("confirmdoc")),user.getLanguage())%></a>
          </TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(639,user.getLanguage())%></TD>
          <TD class=Field>
          <a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("proposedoc")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("proposedoc")),user.getLanguage())%></a>
          </TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field>
          <%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%></TD>
        </TR>
		   <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>
          <%if(user.getLogintype().equals("1")){%><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("department")%>"><%}%><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("department")),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%></TD>
         </TR>
		    <TR style="height:1px;"> <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6161,user.getLanguage())%></TD>
          <TD class=Field>
          <%

        String connames="";
        if(!contractids_prj.equals("")){

            ArrayList conids_muti = Util.TokenizerString(contractids_prj,",");
            int connum = conids_muti.size();

            for(int i=0;i<connum;i++){
                connames= connames+"<a href=/CRM/data/ContractView.jsp?id="+conids_muti.get(i)+">"+Util.toScreen(ContractComInfo.getContractname(""+conids_muti.get(i)),user.getLanguage())+"</a>" +" ";
            }
        }
          %>
          <%=connames%>
          </TD>
         </TR>
   <TR style="height:1px;"> <TD class=line1 colSpan=2></TD></TR>
        </TBODY>
	  </TABLE>
<%if(hasFF){%>
	  <TABLE class=viewform id="tblProjFreeField">
        <COLGROUP>
        <col width="30%">
        <col width="70%">
       <thead>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
				<th style="text-align:right">
					<span class="spanSwitch" onClick="doSwitch('tblProjStatistics,tblProjTypeFreeField,tblProjFreeField,tblDiscussion,tblDiscussionDoc,tblDiscussionList')"><img src='/images/up.jpg'  style='cursor:pointer'></span>
				</th>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
		</thead>
		  <tbody>
<%
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2)%></TD>
          <TD class=Field><%=RecordSet.getString("datefield"+i)%></TD>
        </TR>
		    <TR class=spacing style="height:1px;">
          <TD class=line colSpan=2></TD></TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
          <TD class=Field><%=RecordSet.getString("numberfield"+i)%></TD>
        </TR>
		  <TR class=spacing style="height:1px;">
          <TD class=line colSpan=2></TD></TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><%=RecordSet.getString("textfield"+i)%></TD>
        </TR>  <TR class=spacing style="height:1px;">
          <TD class=line colSpan=2></TD></TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field>
          <INPUT type=checkbox  value=1 <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked <%}%> disabled >
          </TD>
        </TR>  <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
		<%}
	}
%>
        </TBODY>
	  </TABLE>
<%}
    boolean isLight = false;
%>
</form>

<FORM id="Exchange" name="Exchange" action="/discuss/ExchangeOperation.jsp" method="post">
<input type="hidden" name="method1" value="add">
<input type="hidden" name="types" value="PP">
<input type="hidden" name="sortid" value="<%=ProjID%>">
<TABLE class=liststyle cellspacing=1  cellpadding=1  id="tblDiscussion">
<thead>
    <TR class=header>
    <TH colspan="2">
    	<span style="float:left;">
    	<%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%>
    	</span>
    	<span style="float:right">
    	<%
	 //TD2518
	 //modified by hubo,2006-03-15
	 if(!status_prj.equals("4")){%>
		<a href="javascript:submitData()"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp;
	 <%}%>
    </span>
    </TH>
    
    </TR>
    <TR class=Line style="height:1px;">
    <TD colSpan="2" style="padding:0;"></TD>
    </TR>
</thead>
<tbody>
    <TR >
        <TD class=Field colSpan="2">
        <TEXTAREA class=inputstyle NAME=ExchangeInfo ROWS=3 STYLE="width:94%" onchange='checkinput("ExchangeInfo","ExchangeInfospan")'<%
			//TD2518
			//modified by hubo,2006-03-15
			if(status_prj.equals("4")){out.println("disabled");}%>></TEXTAREA>
			  <span id=ExchangeInfospan name=ExchangeInfospan >
 			  <IMG src='/images/BacoError.gif' align=absMiddle>
 			  </span>
        </TD>
        </TR>
</tbody>
</TABLE>
<table id="tblDiscussionDoc">
<tbody>
  <TR class=header>
        <TD width="60"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
        <TD width="*">
		  <%
		  //TD2518
		  //modified by hubo,2006-03-15
		  if(!status_prj.equals("4")){%>
        <input type=hidden name="docids" class="wuiBrowser" value="" 
        	_displayTemplate="<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=#b{id}')>#b{name}</a>&nbsp"
        	_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids">
		  <%}%>
        </TD>
		<td></td>
    </TR>
</tbody>
</table>

  <TABLE class=liststyle cellspacing=1 id="tblDiscussionList">
        <TBODY>
	    <TR class=Header>
	      <th width="30%"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th width="30%"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th width="40%"><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>

	    </TR><tr class="Line" style="height:1px;"><th></th><th></th><th></th></tr>
<%
 isLight = false;
char flag0=2;
int PnLogCount=0;
RecordSetEX.executeProc("ExchangeInfo_SelectBID",ProjID+flag0+"PP");
while(RecordSetEX.next())
{
PnLogCount++;
if (PnLogCount==2) {
%>
</tbody></table>
<div  id=WorkFlowDiv style="display:none">
    <table class=liststyle cellspacing=1 >
           <COLGROUP>
		<COL width="20%">
  		<COL width="30%">
  		<COL width="40%">

    <tbody>
<%}
		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetEX.getString("createDate")%></TD>
          <TD><%=RecordSetEX.getString("createTime")%></TD>
          <TD>
			<%if(Util.getIntValue(RecordSetEX.getString("creater"))>0){%>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetEX.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetEX.getString("creater")),user.getLanguage())%></a>
			<%}else{%>
			<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetEX.getString("creater").substring(1)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+RecordSetEX.getString("creater").substring(1))%></a>
			<%}%>
		  </TD>
        </TR>
<%		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD colSpan=3><%=Util.toHtml(RecordSetEX.getString("remark"))%></TD>

        </TR>
<%		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
<%
        String docids_0=  Util.null2String(RecordSetEX.getString("docids"));
        String docsname="";
        if(!docids_0.equals("")){

            ArrayList docs_muti = Util.TokenizerString(docids_0,",");
            int docsnum = docs_muti.size();

            for(int i=0;i<docsnum;i++){
                docsname= docsname+"<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+"')>"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a><br>" +" ";
            }
        }

 %>
     <td ><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>: </td> <td  colSpan=2> <%=docsname%></td>
         </TR>

     </tr>
	 <tr>
		<td align="right" colspan="3"><a href="/discuss/ViewExchange.jsp?types=PP&sortid=<%=ProjID%>"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a></td>
	 </tr>
<%
	isLight = !isLight;
}
%>	  </TBODY>
	  </TABLE>
<% if (PnLogCount>=2) { %> </div> <%}%>
        <table class=liststyle cellspacing=1 >
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
          <tbody>
          <tr style="height:1px">
            <td> </td>
            <td> </td>
            <td> </td>
            <% if (PnLogCount>=2) {
				/*****去掉右键菜单的‘全部‘，

RCMenu += "{"+SystemEnv.getHtmlLabelName(332,user.getLanguage())+",/discuss/ViewExchange.jsp?types=PP&sortid="+ProjID+",_self}";
RCMenuHeight += RCMenuHeightStep;
		*/
		}
		
		%>


          </tr>
         </tbody>
        </table>
      </td>
    </tr>
  </table>
    <div id="TaskListDIV">
    <table id="scrollarea" name="scrollarea" width="100%" style="zIndex:-1" >
		<tr>
			<td align="center" valign="center">
				<fieldset style="width:30%">
					<img src="/images/loading2.gif"><%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%>
				</fieldset>
			</td>
		</tr>
	</table>
    </div>
	</TD>
  </TR>
  </TBODY>
</TABLE>


	</td>
		</tr>
		</TABLE>

  </FORM>      
                                

	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
// added by lupeng 2004-07-16 to set viewed log.
ProcPara = ProjID + flag + String.valueOf(userid) + flag + user.getLogintype();
rs.executeProc("Prj_ViewedLog_Insert", ProcPara);
// end
%>
<script language=vbs>
sub onShowMDoc(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&tmpids)
         if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					docids2 = id1(0)
					docname = id1(1)
					sHtml = ""
					docids2 = Mid(docids2,2,len(docids2))
					document.all(inputename).value= docids2
					docname = Mid(docname,2,len(docname))
					while InStr(docids2,",") <> 0
						curid = Mid(docids2,1,InStr(docids2,",")-1)
						curname = Mid(docname,1,InStr(docname,",")-1)
						docids2 = Mid(docids2,InStr(docids2,",")+1,Len(docids2))
						docname = Mid(docname,InStr(docname,",")+1,Len(docname))
						sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="&curid&"')>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="&docids2&"')>"&docname&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
        end if
end sub
sub showRemarkDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		weaver.RemarkDoc.value=id(0)&""
		RemarkDocname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"
	end if
end sub


</script>
<SCRIPT language="javascript" src="/js/xmlextras.js"></script>
<script type='text/javascript' src='/dwr/interface/ProjTaskUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/js/ArrayList.js'></script>
<script language="javascript">

function submitData(){
	if (check_form(Exchange,'ExchangeInfo'))  {    
        //alert(Exchange.tagName)
        document.getElementById("Exchange").submit();
    }	
}


  function doSave1(){
	if(check_form(document.Exchange,"ExchangeInfo")){
		document.Exchange.submit();
	}
}

function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
			WorkFlowDiv.style.display = "";
		}
	}


//项目另存模板
//added by hubo, 2005/09/01
function saveAsTemplet(){
	var strTempletName = prompt("请输入模板名称","<%=RecordSet.getString("name")%>模板");
	if(strTempletName==null || trim(strTempletName)==""){
		return false;
	}else{
		//alert(templetName);
		with(document.getElementById("formProjInfo")){
			templetName.value = strTempletName;
			action = "SaveAsTemplet.jsp?projId=<%=ProjID%>";
			submit();
		}
	}
}

function onHiddenImgClick(divObj,imgObj){
     if (imgObj.objStatus=="show"){
        divObj.style.display='none' ;       
        imgObj.src="/images/down.jpg";
        imgObj.title="点击展开";
        imgObj.objStatus="hidden";        
     } else {        
        divObj.style.display='' ;    
        imgObj.src="/images/up.jpg";
        imgObj.title="点击隐藏";
        imgObj.objStatus="show";       
     }
 }

function onImgClick(objImg,taskid,level){ 	
		var parentTrObj=objImg.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
		
		if($(objImg).attr("status")=="hidden"){  //展开
			//if(parentTrObj.childStrs==""){
				objImg.src="/images/loading2.gif";
				ProjTaskUtil.getTaskTRs("<%=user.getLanguage()%>","<%=ProjID%>",taskid,level,
					{callback:function(dataFromServer) {			
						doOtherThing(dataFromServer, objImg,parentTrObj);
					}
					}
				);
			/*} else {
				var childrenList=new ArrayList();
				getAllChildrenIds(parentTrObj,childrenList)			
				for(var i=0;i<childrenList.size();i++) {
					var tempTr=document.getElementById("TR"+childrenList.get(i));
					
					var tempImg=document.getElementById("img_"+childrenList.get(i));
					tempImg.src="/images/project_rank1.gif";
					tempImg.status="show";

					tempTr.style.display='';
					tempTr.nextSibling.style.display='';
				}
				objImg.src="/images/project_rank1.gif";
				objImg.status="show";
			}*/
		} else if($(objImg).attr("status")=="show") {//收缩		    
			var childrenList=new ArrayList();
			getAllChildrenIds(parentTrObj,childrenList)				
			for(var i=0;i<childrenList.size();i++) {
				var tempTr=document.getElementById("TR"+childrenList.get(i));
				$(tempTr).next().remove();
				$(tempTr).remove();				
			}
			objImg.src="/images/project_rank2.gif";
			$(objImg).attr("status","hidden");
			$(parentTrObj).attr("childStrs","");
		}
 }

function getAllChildrenIds(trObj,childrenList){	
	var childStrs=$(trObj).attr("childStrs");	
	//1.求TROBJ上的子节点属性 和子孙节点的记录
	if(childStrs){  //只记录一级子ID
		var childArrays=childStrs.split(",");		
		for(var i=0;i<childArrays.length;i++) {
			
			//alert("TR"+childArrays[i])			
			var tempTrObj=document.getElementById("TR"+childArrays[i]);
			//alert(tempTrObj.tagName)
			childrenList.add(childArrays[i]);

			getAllChildrenIds(tempTrObj,childrenList);
		}		
	} else{			
		return childrenList;
	}
}

function doOtherThing(viewTaskTrArray,objImg,parentTrObj){	
	var oldTrObj=parentTrObj.nextSibling;	
	for(var i=0;i<viewTaskTrArray.length;i++){			  
          var tempStrs=viewTaskTrArray[i].split("\u0002");
		  var rowTR=document.createElement("TR");
		  rowTR.id="TR"+tempStrs[0];
		  rowTR.className=replaceStr(tempStrs[1]);	
		  rowTR.childStrs=""
		  
		  var tempTD1=document.createElement("TD");
		  tempTD1.innerHTML=replaceStr(tempStrs[2]);
		  var tempTD2=document.createElement("TD");
		  tempTD2.innerHTML=replaceStr(tempStrs[3]);
		  var tempTD3=document.createElement("TD");
		  tempTD3.innerHTML=replaceStr(tempStrs[4]);
		  var tempTD4=document.createElement("TD");
		  tempTD4.innerHTML=replaceStr(tempStrs[5]);		  
		  var tempTD5=document.createElement("TD");
		  tempTD5.innerHTML=replaceStr(tempStrs[6]);
		  var tempTD6=document.createElement("TD");
		  tempTD6.innerHTML=replaceStr(tempStrs[7]);	 
		  var tempTD7=document.createElement("TD");
		  tempTD7.innerHTML=replaceStr(tempStrs[8]);
		  
		  rowTR.appendChild(tempTD1);
		  rowTR.appendChild(tempTD2);
		  rowTR.appendChild(tempTD3);
		  rowTR.appendChild(tempTD4);
		  rowTR.appendChild(tempTD5);
		  rowTR.appendChild(tempTD6);
		  rowTR.appendChild(tempTD7);
		  
		  var lineTR=document.createElement("TR");
		  lineTR.className="line";
		  var lineTD=document.createElement("TD");
		  lineTD.colSpan=7;
		  $(lineTD).css("padding","0");
		  $(lineTR).css("height","1px");
		  lineTR.appendChild(lineTD);		 
		 
		  oldTrObj=$(oldTrObj).after(rowTR);
		  oldTrObj=$(rowTR).after(lineTR);

		  objImg.src="/images/project_rank1.gif";
		  objImg.status="show";

		  //TR 记录子的记录
		  $(parentTrObj).attr("childStrs",$(parentTrObj).attr("childStrs")+","+tempStrs[0]);
    }
	if($(parentTrObj).attr("childStrs")!=""){
		 $(parentTrObj).attr("childStrs",$(parentTrObj).attr("childStrs").substr(1));
	}
}

function replaceStr(str){
	if(str=="[none]") return "";
	else return str;
}
</script>
</body>
</html>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdata(){
    var ajax=ajaxinit();
    ajax.open("POST", "ViewProjectData.jsp?ProjID=<%=ProjID%>", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send(null);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.getElementById('TaskListDIV').innerHTML = ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
showdata();
</script>