<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.login.Account,
				 weaver.login.VerifyLogin,
                 weaver.general.GCONST" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerVO"%>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerDAO"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page"/>
<jsp:useBean id="JobTypeComInfo" class="weaver.hrm.job.JobTypeComInfo" scope="page"/>
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />


<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<base target="_blank" />
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/css/hrm_card.css" type=text/css rel=STYLESHEET>
</head>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);    
String id = Util.null2String(request.getParameter("id"));
if(id.equals("")) id=String.valueOf(user.getUID());



Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();

String workcode = Util.toScreenToEdit(RecordSet.getString("workcode"),user.getLanguage()) ;	/*工号*/
String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;			/*姓名*/
String sex = Util.toScreen(RecordSet.getString("sex"),user.getLanguage()) ;
/*
性别:
0:男性
1:女性
2:未知
*/
String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/
String costcenterid = Util.toScreen(RecordSet.getString("costcenterid"),user.getLanguage()) ;
String subcompanyid = Util.toScreen(RecordSet.getString("subcompanyid1"),user.getLanguage()) ;
if(subcompanyid==null||subcompanyid.equals("")||subcompanyid.equalsIgnoreCase("null"))
 subcompanyid="-1";
session.setAttribute("hrm_subCompanyId",subcompanyid);
/*所属成本中心*/
String jobtitle = Util.toScreen(RecordSet.getString("jobtitle"),user.getLanguage()) ;			/*岗位*/
String joblevel = Util.toScreen(RecordSet.getString("joblevel"),user.getLanguage()) ;			/*职级*/

String jobactivitydesc = Util.toScreen(RecordSet.getString("jobactivitydesc"),user.getLanguage()) ;	/*职责描述*/
String managerid = Util.toScreen(RecordSet.getString("managerid"),user.getLanguage()) ;			/*直接上级*/
String assistantid = Util.toScreen(RecordSet.getString("assistantid"),user.getLanguage()) ;		/*助理*/
String status = Util.toScreen(RecordSet.getString("status"),user.getLanguage()) ;

String locationid = Util.toScreen(RecordSet.getString("locationid"),user.getLanguage()) ;		/*办公地点*/
String workroom = Util.toScreen(RecordSet.getString("workroom"),user.getLanguage()) ;			/*办公室*/
String telephone = Util.toScreen(RecordSet.getString("telephone"),user.getLanguage()) ;			/*办公电话*/
String mobile = Util.toScreen(RecordSet.getString("mobile"),user.getLanguage()) ;			/*移动电话*/

String mobilecall = Util.toScreen(RecordSet.getString("mobilecall"),user.getLanguage()) ;		/*其他电话*/
String fax = Util.toScreen(RecordSet.getString("fax"),user.getLanguage()) ;				/*传真*/
String email = Util.toScreen(RecordSet.getString("email"),user.getLanguage()) ;				/*电邮*/

String resourceimageid = Util.getFileidOut(RecordSet.getString("resourceimageid")) ;	/*照片id 由SequenceIndex表得到，和使用它的表相关联*/
int systemlanguage = Util.getIntValue(RecordSet.getString("systemlanguage"),7);
String jobcall = Util.toScreenToEdit(RecordSet.getString("jobcall"),user.getLanguage()) ;	/*现职称*/
String resourcetype = Util.toScreen(RecordSet.getString("resourcetype"),user.getLanguage()) ;
/*
人力资源种类:
承包商: F
职员: H
学生: D
*/
String extphone = Util.toScreen(RecordSet.getString("extphone"),user.getLanguage()) ;		/*分机电话*/
String jobgroup= Util.toScreen(RecordSet.getString("jobgroup"),user.getLanguage()) ;		/*工作类别*/
String jobactivity= Util.toScreen(RecordSet.getString("jobactivity"),user.getLanguage()) ;	/*职责*/
String createrid = Util.toScreen(RecordSet.getString("createrid"),user.getLanguage()) ;		/*创建人id*/

String createdate = Util.toScreen(RecordSet.getString("createdate"),user.getLanguage()) ;	/*创建日期*/
String lastmodid = Util.toScreen(RecordSet.getString("lastmodid"),user.getLanguage()) ;		/*最后修改人id*/
String lastmoddate = Util.toScreen(RecordSet.getString("lastmoddate"),user.getLanguage()) ;	/*修改日期*/
String lastlogindate = Util.toScreen(RecordSet.getString("lastlogindate"),user.getLanguage()) ;	/*最后登录日期*/

String jobtype = Util.toScreenToEdit(RecordSet.getString("jobtype"),user.getLanguage()) ;	/*职务类别*/
String seclevel = Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage()) ;			/*安全级别*/

String datefield[] = new String[5] ;
String numberfield[] = new String[5] ;
String textfield[] = new String[5] ;
String tinyintfield[] = new String[5] ;

for(int k=1 ; k<6;k++) datefield[k-1] = RecordSet.getString("datefield"+k) ;
for(int k=1 ; k<6;k++) numberfield[k-1] = RecordSet.getString("numberfield"+k) ;
for(int k=1 ; k<6;k++) textfield[k-1] = RecordSet.getString("textfield"+k) ;
for(int k=1 ; k<6;k++) tinyintfield[k-1] = RecordSet.getString("tinyintfield"+k) ;
char flag=2;









RecordSet.executeProc("HrmResource_SCountBySubordinat",id);
RecordSet.next();
String subordinatescount = RecordSet.getString(1) ;


/*显示权限判断*/
int userid = user.getUID();

boolean isSelf		=	false;
boolean isManager	=	false;
boolean displayAll	=	false;
boolean isHr = false;

boolean isSys = ResourceComInfo.isSysInfoView(userid,id);
boolean isFin = ResourceComInfo.isFinInfoView(userid,id);
boolean isCap = ResourceComInfo.isCapInfoView(userid,id);
//boolean isCreater = ResourceComInfo.isCreaterOfResource(userid,id);

AllManagers.getAll(id);
if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid)){
  isHr = true;
}
if(HrmUserVarify.checkUserRight("HrmResource:Display",user))  {
	displayAll		=	true;
}
/*
if(!((currentdate.compareTo(startdate)>=0 || startdate.equals(""))&& (currentdate.compareTo(enddate)<=0 || enddate.equals("")))){
	if (!displayAll){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}
*/

if (id.equals(""+user.getUID()) ){
	isSelf = true;
}

while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		isManager = true;
	}
}

// 判定是否可以查看该人预算
boolean canviewbudget = HrmUserVarify.checkUserRight("FnaBudget:All",user, departmentid) ;
boolean caneditbudget =  HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) &&  (""+user.getUserDepartment()).equals(departmentid) ;
boolean canapprovebudget = HrmUserVarify.checkUserRight("FnaBudget:Approve",user) ;

boolean canlinkbudget = canviewbudget || caneditbudget || canapprovebudget || isSelf ;

// 判定是否可以查看该人收支
boolean canviewexpense = HrmUserVarify.checkUserRight("FnaTransaction:All",user, departmentid) ;
boolean canlinkexpense = canviewexpense || isSelf ;


String titlename="<B>"+SystemEnv.getHtmlLabelName(125,user.getLanguage())+":&nbsp;</B>"+createdate+"&nbsp;&nbsp;<b>"+SystemEnv.getHtmlLabelName(271,user.getLanguage())+":&nbsp;</b><A href=HrmResource.jsp?id="+createrid+">"+Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())+"</A>&nbsp;&nbsp;<B>"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":&nbsp;</B>"+lastmoddate+"&nbsp;&nbsp;<B>"+SystemEnv.getHtmlLabelName(424,user.getLanguage())+":&nbsp;</B><A href=HrmResource.jsp?id="+lastmodid+">"+Util.toScreen(ResourceComInfo.getResourcename(lastmodid),user.getLanguage())+"</A>&nbsp;&nbsp;";
%>
<BODY>



<form name=resource action=HrmResourceOperation.jsp method=post enctype="multipart/form-data">
<INPUT class=inputstyle id=BCValidate type=hidden value=0 name=BCValidate>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%



int detachable=0;
if(session.getAttribute("detachable")!=null){
    detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
}else{
    rs.executeSql("select detachable from SystemSet");
    if(rs.next()){
        detachable=rs.getInt("detachable");
        session.setAttribute("detachable",String.valueOf(detachable));
    }
}
int operatelevel=-1;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}

if((isSelf||operatelevel>0)&&!status.equals("10")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
if(HrmListValidate.isValidate(19)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",javascript:sendmail(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}}
//xiaofeng





//added by lupeng 2004-07-08
RCMenu += "{"+SystemEnv.getHtmlLabelName(16426,user.getLanguage())+",javascript:doAddWorkPlan(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//end

RCMenu += "{"+SystemEnv.getHtmlLabelName(17859,user.getLanguage())+",javascript:doAddCoWork(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

/** 正式系统请删除Start */
List accounts=new VerifyLogin().getAccountsById(Integer.valueOf(id).intValue());
Iterator iter=null;
if(accounts!=null)     iter=  accounts.iterator();
Account current=new Account();
while(iter!=null&&iter.hasNext()){
Account a=(Account)iter.next();
if((""+a.getId()).equals(id))
current=a;
}
/** 正式系统请删除End */	


	


%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


				<div id="pertionalInfo" style="width:740px;">
					<div id="pertionalInfo_sort" >
						<div class="legend" style=""><%=titlename%></div>
						<div class="headInfo">
							<div class="title" >
								<%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(24893,user.getLanguage())%>
							</div>
							<div class="headDetail" style="">
								<div class="headFace" >
									<div class="headFacePic" >
										<img src="<%=ResourceComInfo.getMessagerUrls(id) %>" width="38px">
									</div>
								</div>
								<div class="sortInfo" >
									<div style="height:26px;line-height:26px;"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%>:<%=workcode%></div>
									<div style="height:26px;line-height:26px;"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>:<%=lastname%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%>:
									<% if(sex.equals("0")) {%>
                                <%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%>
                                <%} if(sex.equals("1")) {%>
                                <%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%>
                                <%}%></div>
								</div>
							</div>
						</div>
						
					</div>
					<div class="mainContent" >
						<div class="rightspace" ></div>
						<% if(!resourceimageid.equals("") && !resourceimageid.equals("0")) {%>
						<div class="photo_area" >
							<div class="photo_first_level_bg" >
								<div class="photo_second_level_bg"  >
									<div class="photo_third_level_bg" >
										<a href="/weaver/weaver.file.FileDownload?fileid=<%=resourceimageid%>" target="_blank">
								             <img border=0   id=resourceimage    src="/weaver/weaver.file.FileDownload?fileid=<%=resourceimageid%>">
										</a>
									</div>
								</div>
							</div>
						</div>
						<% } %>
						
						  <%if(weaver.general.GCONST.getMOREACCOUNTLANDING()){%>
                            <div class="persionalInfoDetailItem" >
                              <span class="persionalInfoDetailItemHead">
                              <%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%>
                              </span>
                              <span>
                                <%= current.getType()==0?SystemEnv.getHtmlLabelName(17746,user.getLanguage()):SystemEnv.getHtmlLabelName(17747,user.getLanguage())%>
                              </span>
                            </div>
                             <%if(current.getType()==1){%>
                            <div class="persionalInfoDetailItem" >
                              <span class="persionalInfoDetailItemHead">
								<%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%> 
							  </span>
							  <span class=FIELD>
                            <%iter=accounts.iterator();
                             while(accounts.size()>1&&iter.hasNext()){
                                 Account a=(Account)iter.next();
                                 if(a.getType()==0){
                                     String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
                                     String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
                                     String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());

                             %>
                            <a href="/hrm/resource/HrmResource.jsp?id=<%=a.getId()%>" ><%=subcompanyname+"/"+departmentname+"/"+jobtitlename%></a>
                            <%}}%>
                          </span>
                        </div>
                        <%}}%>
						<div class="persionalInfoDetailItem">
							<span class="persionalInfoDetailItemHead"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></span>
							<span>
								<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>" ><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></a>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></span>
							<span>
							 	<A href="javascript:void(0)" onclick="openFullWindowForXtable('/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=jobtitle%>');return false;"><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></A>/
                                <A href="/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id=<%=JobTitlesComInfo.getJobactivityid(jobtitle)%>" ><%=Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(JobTitlesComInfo.getJobactivityid(jobtitle)),user.getLanguage())%></A>
							</span>
						</div>
						
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead"><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></span>
							<span>
								<%=Util.toScreen(JobCallComInfo.getJobCallname(jobcall),user.getLanguage())%>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead"><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></span>
							<span>
								<%=joblevel%>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
								<%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%>
							</span>
							<span>
								<%=jobactivitydesc%>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							<%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%>
							</span>
							<span>
								 <A href="HrmResource.jsp?id=<%=managerid%>" ><%=Util.toScreen(ResourceComInfo.getResourcename(managerid),user.getLanguage())%></A>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
								<%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%>
							</span>
							<span>
							<A href="HrmResource.jsp?id=<%=assistantid%>" ><%=Util.toScreen(ResourceComInfo.getResourcename(assistantid),user.getLanguage())%></A>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
								<%=SystemEnv.getHtmlLabelName(442,user.getLanguage())%>
							</span>
							<span>
								<% if(!subordinatescount.equals("0")) {%>
                                 <A href="/hrm/search/HrmResourceView.jsp?id=<%=id%>" ><%=subordinatescount%></A>
	                             <%
	                                }
	                             %>
							</span>
						</div>
					
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							<%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>
							</span>
							<span>
							<%if(status.equals("0")){%><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%><%}%>
                                  <%if(status.equals("1")){%><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%><%}%>
                                  <%if(status.equals("2")){%><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%><%}%>
                                  <%if(status.equals("3")){%><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%><%}%>
                                  <%if(status.equals("4")){%><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%><%}%>
                                  <%if(status.equals("5")){%><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><%}%>
                                  <%if(status.equals("6")){%><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%><%}%>
                                  <%if(status.equals("7")){%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%><%}%>
                                  <%if(status.equals("10")){%><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%><%}%>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							<%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%>
							</span>
							<span>
							<A href="/hrm/location/HrmLocationEdit.jsp?id=<%=locationid%>" ><%=Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage())%></A>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							<%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%>
							</span>
							<span>
							<%=workroom%>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							<%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%>
							</span>
							<span>
							<%=telephone%>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
								<%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%>
							</span>
							<span>
								<%=mobile%>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							<%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%>
							</span>
							<span>
							<%=mobilecall%>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							<%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%>
							</span>
							<span>
							<%=fax%>
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							<%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%>
							</span>
							<span>
							<A href="mailto:<%=email%>" ><%=email%></A>
							</span>
						</div>
						<%if(isMultilanguageOK){%>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							<%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%>
							</span>
							<span>
							<%=LanguageComInfo.getLanguagename(""+systemlanguage)%>
							</span>
						</div>
						<%} %>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							<%=SystemEnv.getHtmlLabelName(16067,user.getLanguage())%>
							</span>
							<span>
							<%=lastlogindate%>&nbsp;
							</span>
						</div>

						<%--显示自定义的字段 start --%>
						<%

boolean hasFF = true;
rs2.executeProc("Base_FreeField_Select","hr");
if(rs2.getCounts()<=0)
	hasFF = false;
else
	rs2.first();

if(hasFF){
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+1).equals("1"))
		{%>
			<div class="persionalInfoDetailItem" >
					<span class="persionalInfoDetailItemHead">
					<%=rs2.getString(i*2)%>
					</span>
					<span>
					<%=datefield[i-1]%>&nbsp;
					</span>
			</div>
              <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+11).equals("1"))
		{%>
			<div class="persionalInfoDetailItem" >
					<span class="persionalInfoDetailItemHead">
					<%=rs2.getString(i*2+10)%>
					</span>
					<span>
					<%=numberfield[i-1]%>&nbsp;
					</span>
			</div>
              <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+21).equals("1"))
		{%>
			<div class="persionalInfoDetailItem" >
					<span class="persionalInfoDetailItemHead">
					<%=rs2.getString(i*2+20)%>
					</span>
					<span>
					<%=textfield[i-1]%>&nbsp;
					</span>
			</div>
              <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+31).equals("1"))
		{%>
			<div class="persionalInfoDetailItem" >
					<span class="persionalInfoDetailItemHead">
					<%=rs2.getString(i*2+30)%>
					</span>
					<span>
					<%if(tinyintfield[i-1].equals("1")){
						%> 是 <%	
					}else{%> 否 <%}%>&nbsp;
					</span>
			</div>
              <%}
	}
}

%>
<%--显示自定义的字段 end--%>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
								&nbsp;
							</span>
							<span>
							    &nbsp; 
							</span>
						</div>
						<div class="persionalInfoDetailItem" >
							<span class="persionalInfoDetailItemHead">
							    &nbsp;
							</span>
							<span>
							    &nbsp;
							</span>
						</div>
					</div>
				</div>

	

 <!-- 正式系统请删除Start -->
                          
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
</form>

<script language=javascript>
   function doedit(){

    if(<%=operatelevel%>>0){
      location = "HrmResourceBasicEdit.jsp?isfromtab=true&id=<%=id%>&isView=1";
    }else{
        if(<%=isSelf%>){
          location = "HrmResourceContactEdit.jsp?isfromtab=true&id=<%=id%>&isView=1";
        }
    }
  }
  function dodelete(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
    document.resource.operation.value="delete";
    document.resource.submit();
    }
  }


  function sendmail(){
    var tmpvalue = "<%=email%>";
    while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if (tmpvalue=="" || tmpvalue.indexOf("@") <1 || tmpvalue.indexOf(".") <1 || tmpvalue.length <5) {
        alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
        return;
    }
    window.open("/sendmail/HrmMailMerge.jsp?id=<%=id%>");
  }


function doAddWorkPlan() {
	
	//parent.location.href = "/workplan/data/WorkPlan.jsp?resourceid=<%=id%>&add=1";
	window.open("/workplan/data/WorkPlan.jsp?resourceid=<%=id%>&add=1")
	
}
function doAddCoWork(){
	window.open("/cowork/AddCoWork.jsp?hrmid=<%=id%>")
}

</script>
</BODY>
</HTML>

