<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="VotingReminiders" class="weaver.voting.VotingReminiders" scope="page"/> 
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%

String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage());
String temptitlename = titlename;
String needfav ="1";
String needhelp ="";

boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
boolean canDelete = HrmUserVarify.checkUserRight("voting:delete", user);
boolean canedit=false ;
boolean canapprove=false ;
boolean canOption = false;

boolean islight=true ;
String userid=user.getUID()+"";

String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());

boolean canresulet = false;
String sqlstr = "select resourceid from VotingViewerDetail where votingid ="+votingid;
RecordSet.execute(sqlstr);
while(RecordSet.next()){
  if(userid.equals(RecordSet.getString("resourceid"))){
    canresulet = true;   
  }
}
if("1".equals(userid)) canresulet = true;//td11778 hww

RecordSet.executeProc("Voting_SelectByID",votingid);
RecordSet.next();
String subject=RecordSet.getString("subject");
String detail=RecordSet.getString("detail");
String createrid=RecordSet.getString("createrid");
String createdate=RecordSet.getString("createdate");
String createtime=RecordSet.getString("createtime");
String approverid=RecordSet.getString("approverid");
String approvedate=RecordSet.getString("approvedate");
String approvetime=RecordSet.getString("approvetime");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");
String isanony=RecordSet.getString("isanony");
String docid=RecordSet.getString("docid");
String crmid=RecordSet.getString("crmid");
String projectid=RecordSet.getString("projid");
String requestid=RecordSet.getString("requestid");
String votingcount = RecordSet.getString("votingcount");
String status = RecordSet.getString("status");
String isSeeResult = RecordSet.getString("isSeeResult");//投票后是否可以查看结果

int votingtype = Util.getIntValue(RecordSet.getString("votingtype"));//调查类型
String votingtypename = "";
RecordSet.executeSql("select typename from voting_type where id ="+votingtype);
if(RecordSet.next()) votingtypename = RecordSet.getString(1);

RecordSet.executeSql("select * from votingoption where votingid ="+votingid);
if(RecordSet.next()){
  canOption = true; 
}else{
   String isother = "";
   rs.executeSql("select * from votingQuestion where votingid ="+votingid);
   if(rs.next()) isother = rs.getString("isother");
   if("1".equals(isother)){
    canOption = true; 
   }
}

if(userid.equals(createrid) || userid.equals(approverid))
    canedit=true ;
if(userid.equals(approverid)) {
    canapprove=true ;   
}

if(canmaint){
    canedit=true ;
    canapprove=true ;
}

//提交权限begin
boolean cancreate = false;

if(HrmUserVarify.checkUserRight("Voting:Maint", user)){
	cancreate = true;
}
String sqlcreate = "select count(id) as recordid from votingmaintdetail where  createrid="+userid;
RecordSet.execute(sqlcreate);
while(RecordSet.next()){
		int recordid = RecordSet.getInt("recordid");
		if(recordid>0){
		  	cancreate = true;
		  }   
	}
	
String sqlcreate2 = "select count(id) as recordid from votingmaintdetail where  approverid="+userid;
RecordSet.execute(sqlcreate2);
while(RecordSet.next()){
		int recordid = RecordSet.getInt("recordid");
		if(recordid>0){
		
		  	canapprove = true;
		  }   
	}
if(userid.equals(createrid)) cancreate=true ;
/***如果是通过流程审批调查，就屏蔽正常的审批开始**/
boolean approvertmp = false;
approvertmp = VotingReminiders.checkApproveVoting(votingid);
if(approvertmp) canapprove = false;
/***如果是通过流程审批调查，就屏蔽正常的审批结束**/


/***流程查看网上调查权限开始**/
String isfromwf = Util.null2String(request.getParameter("isfromworkflow"));
boolean wfviewtmp = false;
if("1".equals(isfromwf)) {
	wfviewtmp = VotingReminiders.checkViewWfVoting(votingid,userid);
	if(wfviewtmp) canresulet = false;
	if(wfviewtmp) canapprove = false;
	if(wfviewtmp) canDelete = false;
}
if(!canedit && !wfviewtmp){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}
rs.executeSql("select status from bill_VotingApprove,voting where votingname=voting.id and voting.id ="+votingid);
if(rs.next()){
	canapprove = false;
	wfviewtmp = true;
}
/***流程查看网上调查权限结束**/

titlename += "&nbsp;&nbsp;"+
             "<b>"+SystemEnv.getHtmlLabelName(125,user.getLanguage())+":&nbsp;</b>"+
		createdate+"&nbsp;&nbsp;"+createtime+"&nbsp;&nbsp;"+
             "<b>"+SystemEnv.getHtmlLabelName(271,user.getLanguage())+":&nbsp;</b>"+
		"<a href=\"javaScript:openhrm('"+createrid+"');\" onclick='pointerXY(event);'>"+
		Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())+
		"</A>&nbsp;&nbsp;"+
	     "<b>"+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(359,user.getLanguage())+":&nbsp;</b>"+
		approvedate+"&nbsp;&nbsp;"+approvetime+"&nbsp;&nbsp;"+
	     "<b>"+SystemEnv.getHtmlLabelName(439,user.getLanguage())+":&nbsp;</b>"+
		"<a href=\"javaScript:openhrm('"+approverid+"');\" onclick='pointerXY(event);'>"+
            	Util.toScreen(ResourceComInfo.getResourcename(approverid),user.getLanguage())+
		"</A>&nbsp;&nbsp;";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
    <%
    	session.setAttribute("fav_pagename" , temptitlename ) ;
        if(status.equals("0") && cancreate){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location.href='/voting/VotingEdit.jsp?votingid="+votingid+"',_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }
        if(status.equals("0") && !wfviewtmp &&  cancreate && !canapprove){
        	RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }
        if(status.equals("0")&& canapprove && !approvertmp){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doApprove(),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        } 
        if(status.equals("1") && cancreate){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(405,user.getLanguage())+",javascript:doEnd(),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }
        if(canDelete && status.equals("0")){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }
        if(canresulet){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(356,user.getLanguage())+",javascript:location.href='/voting/VotingPollResult.jsp?votingid="+votingid+"',_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }   
        
        if(status.equals("0")){
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:doPreView("+votingid+"),_top} " ;
	        RCMenuHeight += RCMenuHeightStep ;
        }

        RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1)',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name=frmmain action="VotingOperation.jsp" method=post onsubmit="return check_form(this,'subject,creater,begindate')">
<input type=hidden name=votingid value="<%=votingid%>">
<input type=hidden name=createrid value="<%=createrid%>">
<input type=hidden name="method" value="finish">
 <TABLE width=100% height=100% border="0" cellspacing="0">
      <colgroup>
        <col width="10">
          <col width="">
            <col width="10">
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
              <tr>
                <td></td>
                <td valign="top">  
                <form name="frmSubscribleHistory" method="post" action="">
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">

<table class=ViewForm>
<col width=15%><col width=35%><col width=15%><col width=35%>
  <TR class=Section>
    <TH colSpan=4><div align="left"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></div></TH></TR>
  <TR class=separator style="height: 1px!important;">
    <TD class=line1 colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
    <td class=field>
    <%=subject%>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(24111,user.getLanguage())%></td>
    <td class=field>
     <%=votingtypename%>
    </td>
  </tr>
  <TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
    <td class=field>
    <%=begindate%>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
    <td class=field>
    <%=begintime%>
    </td>
  </tr>
   <TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
    <td class=field>
    <%=enddate%>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
    <td class=field>
    <%=endtime%>
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
    <td class=field>
    <a href="/docs/docs/DocDsp.jsp?id=<%=docid%>" target="_blank"><%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></a>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
    <td class=field>
    <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmid%>" target="_blank"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></a>
  </tr>
   <TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
    <td class=field>
    <a href="/proj/data/ViewProject.jsp?ProjID=<%=projectid%>" target="_blank"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%></a>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
    <td class=field>
    <a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>" target="_blank"><%=Util.toScreen(RequestComInfo.getRequestname(requestid),user.getLanguage())%></a>
  </tr>  
   <TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></td>
    <td class=field>
    <input class="inputStyle" type=checkbox name="isanony" <%if(isanony.equals("1")){%> checked <%}%> value="1" disabled >
    </td>   
    <td><%=SystemEnv.getHtmlLabelName(21723,user.getLanguage())%></td>
    <td class=field>
      <input class="inputStyle" type=checkbox name="isSeeResult" <%if("1".equals(isSeeResult)){%> checked <%}%> value="1" disabled >
    </td>
  </tr>
  <TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
  <tr>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>
    <td class=field colSpan=3>
    <%=Util.toHtmlVoting(detail)%>
    </td>
  </tr>
  <TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
</table>

<br>

<table class=listStyle>
<col width=25%><col width=50%><col width=15%><col width=10%>
  <TR class=Header>
    <TH colSpan=3><div align="left"><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></div></TH>
    <td align=right><%if(status.equals("0") && cancreate ){%><a href="javascript:addQuestion('<%=votingid%>')"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><%}%></td>
  </TR> 
  <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  </tr>
<%
RecordSet.executeProc("VotingQuestion_SelectByVoting",votingid);
while(RecordSet.next()){
    String questionid=RecordSet.getString("id");
    String q_subject=RecordSet.getString("subject");
    String q_description=RecordSet.getString("description");
    String q_ismulti=RecordSet.getString("ismulti");
    String q_isother=RecordSet.getString("isother");
%>
  <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
    <td><%if(status.equals("0")){%><a href="javascript:editQuestion('<%=questionid%>','<%=votingid%>')"><%}%>
    <%=q_subject%></a></td>
    <td><%=q_description%></td>
    <td><%if(q_ismulti.equals("1")){%><%=SystemEnv.getHtmlLabelName(15205,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15204,user.getLanguage())%><%}%><%if(q_isother.equals("1")){%>/<%=SystemEnv.getHtmlLabelName(18603,user.getLanguage())%> <%}%>
    </td>
    <td><%if(status.equals("0") && cancreate ){%><a href="javascript:addOption('<%=questionid%>','<%=votingid%>')"><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></a><%}%></td>
  </tr>
<%
    islight=!islight ;
    int count=1 ;
    rs.executeProc("VotingOption_SelectByQuestion",questionid);
    while(rs.next()){
        String optionid=rs.getString("id");
        String o_desc=rs.getString("description");
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
    <td colspan=3><img border=0 src="/images/ArrowRightBlue.gif"></img><%=SystemEnv.getHtmlLabelName(1025,user.getLanguage())%><%=count%>:<%if(status.equals("0")){%><a href="javascript:editOption('<%=optionid%>','<%=votingid%>')"><%}%><%=o_desc%></a></td>
    <td align=right><%if(status.equals("0") && cancreate){%><a href="/voting/VotingOptionOperation.jsp?votingid=<%=votingid%>&optionid=<%=optionid%>&method=delete")"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
  </tr>
<%        
        count++;
        islight=!islight;
    }
    
}
%>  
</table>

<br>

<table class=listStyle>
<col width=20%><col width=65%><col width=15%>
  <TR class=header>
    <TH colSpan=2><div align="left"><%=SystemEnv.getHtmlLabelName(18605,user.getLanguage())%></div></TH>
    <td align=right><%if(status.equals("0") && cancreate){%><a href="javascript:addShare('<%=votingid%>')"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><%}%></td>
  </TR> 
  <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  </tr>
<%
islight=true;
RecordSet.executeProc("VotingShare_SelectByVotingid",votingid);
while(RecordSet.next()){
    String shareid=RecordSet.getString("id");
    String sharetype=RecordSet.getString("sharetype");
    String resourceid=RecordSet.getString("resourceid");
    String subcompanyid=RecordSet.getString("subcompanyid");
    String departmentid=RecordSet.getString("departmentid");
    String roleid=RecordSet.getString("roleid");
    String seclevel=RecordSet.getString("seclevel");
    String rolelevel=RecordSet.getString("rolelevel");
    String foralluser=RecordSet.getString("foralluser");
%>
  <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
<%
    if(sharetype.equals("1")){
%>
    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
    <td><a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></td>
    <td><%if(status.equals("0") && cancreate){%><a href="/voting/VotingShareOperation.jsp?method=delete&shareid=<%=shareid%>&votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
<%    
    }
    if(sharetype.equals("2")){
%>
    <td><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></td>
    <td><a href="/hrm/company/HrmSubCompanyDsp.jsp?id=<%=subcompanyid%>" target="_blank"><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>=<%=Util.toScreen(seclevel,user.getLanguage())%></td>
    <td><%if(status.equals("0") && cancreate){%><a href="/voting/VotingShareOperation.jsp?method=delete&shareid=<%=shareid%>&votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
<%    
    }
    if(sharetype.equals("3")){
%>
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>=<%=Util.toScreen(seclevel,user.getLanguage())%></td>
    <td><%if(status.equals("0") && cancreate){%><a href="/voting/VotingShareOperation.jsp?method=delete&shareid=<%=shareid%>&votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
<%    
    }
    if(sharetype.equals("4")){
%>
    <td><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
    <td><%=Util.toScreen(RolesComInfo.getRolesname(roleid),user.getLanguage())%>/
            <% if(rolelevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%}%>
			<% if(rolelevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%}%>
			<% if(rolelevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><%}%></td>
    <td><%if(status.equals("0") && cancreate){%><a href="/voting/VotingShareOperation.jsp?method=delete&shareid=<%=shareid%>&votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
<%    
    }
    if(sharetype.equals("5")){
%>
    <td><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>=<%=Util.toScreen(seclevel,user.getLanguage())%></td>
    <td><%if(status.equals("0") && cancreate){%><a href="/voting/VotingShareOperation.jsp?method=delete&shareid=<%=shareid%>&votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
<%    
    }
%>    
  </tr>
<%
    islight=!islight;
}
%>  
</table>

<br>

<table class=listStyle>
<col width=20%><col width=65%><col width=15%>
  <TR class=header>
    <TH colSpan=2><div align="left"><%=SystemEnv.getHtmlLabelName(20043,user.getLanguage())%></div></TH>
    <td align=right><%if(status.equals("0") && cancreate){%><a href="javascript:addViewer('<%=votingid%>')"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><%}%></td>
  </TR> 
  <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  </tr>
<%
islight=true;
RecordSet.executeSql(" select * from votingviewer where votingid = " + votingid);
while(RecordSet.next()){
    String shareid=RecordSet.getString("id");
    String sharetype=RecordSet.getString("sharetype");
    String resourceid=RecordSet.getString("resourceid");
    String subcompanyid=RecordSet.getString("subcompanyid");
    String departmentid=RecordSet.getString("departmentid");
    String roleid=RecordSet.getString("roleid");
    String seclevel=RecordSet.getString("seclevel");
    String rolelevel=RecordSet.getString("rolelevel");
    String foralluser=RecordSet.getString("foralluser");
%>
  <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
<%
    if(sharetype.equals("1")){
%>
    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
    <td><a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></td>
    <td><%if(status.equals("0") && cancreate){%><a href="VotingViewerOperation.jsp?method=delete&shareid=<%=shareid%>&votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
<%    
    }
    if(sharetype.equals("2")){
%>
    <td><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></td>
    <td><a href="/hrm/company/HrmSubCompanyDsp.jsp?id=<%=subcompanyid%>" target="_blank"><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>=<%=Util.toScreen(seclevel,user.getLanguage())%></td>
    <td><%if(status.equals("0") && cancreate){%><a href="/voting/VotingViewerOperation.jsp?method=delete&shareid=<%=shareid%>&votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
<%    
    }
    if(sharetype.equals("3")){
%>
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>=<%=Util.toScreen(seclevel,user.getLanguage())%></td>
    <td><%if(status.equals("0") && cancreate){%><a href="/voting/VotingViewerOperation.jsp?method=delete&shareid=<%=shareid%>&votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
<%    
    }
    if(sharetype.equals("4")){
%>
    <td><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
    <td><%=Util.toScreen(RolesComInfo.getRolesname(roleid),user.getLanguage())%>/
            <% if(rolelevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%}%>
			<% if(rolelevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%}%>
			<% if(rolelevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><%}%></td>
    <td><%if(status.equals("0") && cancreate){%><a href="/voting/VotingViewerOperation.jsp?method=delete&shareid=<%=shareid%>&votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
<%    
    }
    if(sharetype.equals("5")){
%>
    <td><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>=<%=Util.toScreen(seclevel,user.getLanguage())%></td>
    <td><%if(status.equals("0") && cancreate){%><a href="/voting/VotingViewerOperation.jsp?method=delete&shareid=<%=shareid%>&votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%></td>
<%    
    }
%>    
  </tr>
<%
    islight=!islight;
}
%>  
</table>
                     </td>
                    </tr>
                  </TABLE>  
                  </form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
            </table>
</form>
<script type="text/javascript">
function addQuestion(votingid){
	var iTop = (window.screen.availHeight-30-500)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-600)/2+"px"; //获得窗口的水平位置;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/voting/VotingQuestionAdd.jsp?votingid="+votingid,"","dialogLeft:"+iLeft+";dialogTop:"+iTop+";dialogHeight:500px;dialogwidth:600px;center:1;")
	window.location = "/voting/VotingView.jsp?votingid="+votingid
}

function editQuestion(questionid,votingid){
	var iTop = (window.screen.availHeight-30-500)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-600)/2+"px"; //获得窗口的水平位置;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/voting/VotingQuestionEdit.jsp?questionid="+questionid,"","dialogLeft:"+iLeft+";dialogTop:"+iTop+";dialogHeight:500px;dialogwidth:600px;center:1;")
	window.location = "/voting/VotingView.jsp?votingid="+votingid
}

function addOption(questionid,votingid){
	var iTop = (window.screen.availHeight-30-500)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-600)/2+"px"; //获得窗口的水平位置;
	
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/voting/VotingOptionAdd.jsp?questionid="+questionid,"","dialogLeft:"+iLeft+";dialogTop:"+iTop+";dialogHeight:500px;dialogwidth:600px;center:1;")
	window.location = "/voting/VotingView.jsp?votingid="+votingid
}

function  editOption(optionid,votingid){
	var iTop = (window.screen.availHeight-30-500)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-600)/2+"px"; //获得窗口的水平位置;
	
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/voting/VotingOptionEdit.jsp?optionid="+optionid,"","dialogLeft:"+iLeft+";dialogTop:"+iTop+";dialogHeight:500px;dialogwidth:600px;center:1;")
	window.location = "/voting/VotingView.jsp?votingid="+votingid
}

function addShare(votingid){
	var iTop = (window.screen.availHeight-30-500)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-600)/2+"px"; //获得窗口的水平位置;
	
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/voting/VotingShareAdd.jsp?votingid="+votingid,"","dialogLeft:"+iLeft+";dialogTop:"+iTop+";dialogHeight:500px;dialogwidth:600px;center:1;")
	window.location = "/voting/VotingView.jsp?votingid="+votingid
}
function addViewer(votingid){
	var iTop = (window.screen.availHeight-30-500)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-600)/2+"px"; //获得窗口的水平位置;
	
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/voting/VotingViewerAdd.jsp?votingid="+votingid,"","dialogLeft:"+iLeft+";dialogTop:"+iTop+";dialogHeight:500px;dialogwidth:600px;center:1;")
	window.location = "/voting/VotingView.jsp?votingid="+votingid
}
</script>
<script language=vbs>








</script>
<script language=javascript>
function doEnd(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(18899,user.getLanguage())%>")) {
		  frmmain.method.value="finish";
		  document.frmmain.submit();
		  enableAllmenu();
	}
}

function doDelete(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")) {
		  frmmain.method.value="delete";
		  document.frmmain.submit();
		  enableAllmenu();
	}
}

function doPreView(votingid){
	window.open("/voting/VotingPreView.jsp?votingid="+votingid, "", "toolbar,resizable,scrollbars,dependent,height=600,width=800,top=0,left=100") ; 
}

function doApprove(){
  if(<%=canOption%>){
      frmmain.method.value="approve";
      document.frmmain.submit();
      enableAllmenu();
  }else{
    alert("<%=SystemEnv.getHtmlLabelName(21918,user.getLanguage())%>");
  }
}

function doSubmit(obj){
    frmmain.method.value="submit";
    document.frmmain.submit();
    enableAllmenu();
}
</script>
</body>
</html>