<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util,weaver.hrm.User,
                 weaver.rtx.RTXExtCom,
				 weaver.rtx.RTXConfig,
                 weaver.hrm.settings.BirthdayReminder,
                 weaver.hrm.settings.RemindSettings,
                 weaver.systeminfo.setting.HrmUserSettingHandler,
                 weaver.systeminfo.setting.HrmUserSetting,
                 weaver.general.TimeUtil,
				 weaver.login.Account" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*,HT.HTSrvAPI,java.math.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.file.Prop" %>

<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/systeminfo/template/templateCss.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%@ include file="/times.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxClient" class="weaver.rtx.RTXClientCom" scope="page" />
<jsp:useBean id="autoPlan" class="weaver.hrm.performance.targetplan.AutoPlan" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="MouldStatusCominfo" class="weaver.systeminfo.MouldStatusCominfo" scope="page" />

<%
Map pageConfigKv = getPageConfigInfo(session, user);
String logoTop = (String)pageConfigKv.get("logoTop");
String logoBtm = (String)pageConfigKv.get("logoBottom");
String islock = (String)pageConfigKv.get("islock");
String bodyBg = Util.null2String((String)pageConfigKv.get("bodyBg"));
String topBgImage = Util.null2String((String)pageConfigKv.get("topBgImage"));
String toolbarBgColor = Util.null2String((String)pageConfigKv.get("toolbarBgColor"));

if (bodyBg.equals("")) {
	bodyBg = "/wui/theme/ecologyBasic/page/images/bodyBg.png";
}

if (topBgImage.equals("")) {
	topBgImage = "/wui/theme/ecologyBasic/page/images/headBg.jpg";
}

if (toolbarBgColor.equals("")) {
	toolbarBgColor = "/wui/theme/ecologyBasic/page/images/toolbarBg.png";
}

%>
<!--网上调查部分-- 开始No blank -->
<SCRIPT LANGUAGE="javascript">
var voteids = "";//网上调查的id
var eBirth = false;//判断是否有人过生日
</SCRIPT>
<% 
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
boolean NoCheck=false;
RecordSet.executeSql("select NoCheckPlugin from SysActivexCheck where NoCheckPlugin='1' and logintype='1' and userid="+user.getUID());
if(RecordSet.next()) NoCheck=true;
if(!NoCheck){
%>
<script language="javascript" src="/js/activex/ActiveX.js"></script>
<SCRIPT LANGUAGE="javascript">
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
checkWeaverActiveX(<%=user.getLanguage()%>);
</script>
<%
}
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
HrmScheduleDiffUtil.setUser(user);
	boolean isWorkday = HrmScheduleDiffUtil.getIsWorkday(CurrentDate);
	boolean isSyadmin=false;
	//判断分权管理员
	RecordSet.executeSql("select loginid from hrmresourcemanager where loginid = '"+user.getLoginid()+"'");
	if(RecordSet.next()){
		isSyadmin = true;
	}

	String isSignInOrSignOut=Util.null2String(GCONST.getIsSignInOrSignOut());//是否启用前到签退功能  
	//判断当前用户当天有没有签到
	String signType="1";

String sql=""; 
sql="select distinct t1.id from voting t1,VotingShareDetail t2 where t1.id=t2.votingid and t2.resourceid="+user.getUID()+" and t1.status=1 "+ 
" and t1.id not in (select distinct votingid from votingresource where resourceid ="+user.getUID()+")" 
+" and (t1.beginDate<'"+CurrentDate+"' or (t1.beginDate='"+CurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+CurrentTime+"'))) "
; 
RecordSet.executeSql(sql); 
while(RecordSet.next()){ 
String votingid = RecordSet.getString("id"); 
%> 
<script language=javascript> 
    //window.open("/voting/VotingPoll.jsp?votingid=<%=votingid%>", "", "toolbar,resizable,scrollbars,dependent,height=600,width=800,top=0,left=100") ;
   if(voteids == ""){
      voteids = '<%=votingid%>';
   }else{
      voteids =voteids + "," +  '<%=votingid%>';
   }
</script> 
<%}%> 
<!--网上调查部分-- 结束 -->

<%
boolean checkchattemp = false;
//String chatserver = Util.null2String(weaver.general.GCONST.getCHATSERVER());//检测即时通讯是否开启
//if(!"".equals(chatserver)) checkchattemp = true;


//String frommain = Util.null2String(request.getParameter("frommain")) ;
RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String birth_valid = settings.getBirthvalid();
String birth_remindmode = settings.getBirthremindmode();
BirthdayReminder birth_reminder = new BirthdayReminder();
if(birth_valid!=null&&birth_valid.equals("1")&&birth_remindmode!=null&&birth_remindmode.equals("0")){
  String today = TimeUtil.getCurrentDateString();
 if( application.getAttribute("birthday")==null||application.getAttribute("birthday")!=today){
   application.setAttribute("birthday",today);
   ArrayList birthEmployers=birth_reminder.getBirthEmployerNames();
   application.setAttribute("birthEmployers",birthEmployers);
   }
 ArrayList birthEmployers=(ArrayList)application.getAttribute("birthEmployers");
 
 if(birthEmployers.size()>0){    
%>
<script>
/*
var chasm = screen.availWidth;
var mount = screen.availHeight;
function openCenterWin(url,w,h) {
   window.open(url,'','scrollbars=yes,resizable=no,width=' + w + ',height=' + h + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5));
}
*/

eBirth = true;
</script>
<%}}%>
<%
String username = ""+user.getUsername() ;
String userid = ""+user.getUID() ;
String usertype = "" ;
if(user.getLogintype().equals("1")) usertype = "1" ;
else  usertype = ""+(-1*user.getType()) ;

char separator = Util.getSeparator() ;

Calendar today = Calendar.getInstance();
String currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
String currentmonth = Util.add0(today.get(Calendar.MONTH)+1, 2) ;
String currentdate = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String currenthour = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) ;

String initsrcpage = "" ;
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;
int targetid = Util.getIntValue(request.getParameter("targetid"),0) ;
//String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String loginfile = Util.getCookie(request , "loginfileweaver") ;
String message = Util.null2String(request.getParameter("message")) ;
String logmessage = Util.null2String((String)session.getAttribute("logmessage")) ;
//自动生成个人计划
//autoPlan.autoSetPlanDay(""+user.getUID(),user);
if(targetid == 0) {
	if(!logintype.equals("2")){
		//initsrcpage="/workspace/WorkSpace.jsp";
        initsrcpage="/homepage/HomepageRedirect.jsp";
		//initsrcpage="/homepage/HomepageRedirect.jsp?hpid=1&subCompanyId=1&isfromportal=0&isfromhp=0";
	}else{
		initsrcpage="/docs/news/NewsDsp.jsp";
	}
}

String gopage = Util.null2String(request.getParameter("gopage"));
String frompage = Util.null2String(request.getParameter("frompage"));
if(!gopage.equals("")){
	gopage=URLDecoder.decode(gopage);
	if(!"".equals(frompage)){
		System.out.println(frompage);
		initsrcpage = gopage+"&message=1&id="+user.getUID();
	}else{
		initsrcpage = gopage;
	}
}
else {
	username = user.getUsername() ;
	userid = ""+user.getUID() ;
	if(logintype.equals("2")){
		switch(targetid) {
			case 1:													// 文档  - 新闻
				initsrcpage = "/docs/news/NewsDsp.jsp?id=1" ;
				break ;
			case 2:													// 人力资源 - 新闻
				initsrcpage = "/docs/news/NewsDsp.jsp?id=2" ;
				break ;
			case 3:													// 财务 - 组织结构
				initsrcpage = "/org/OrgChart.jsp?charttype=F" ;
				break ;
			case 4:													// 物品 - 搜索页面
				initsrcpage = "/lgc/catalog/LgcCatalogsView.jsp" ;
				break ;
			case 5:													// CRM - 我的客户
				initsrcpage = "/CRM/data/ViewCustomer.jsp?CustomerID="+userid ;
				break ;
			case 6:													// 项目 - 我的项目
				initsrcpage = "/proj/search/SearchOperation.jsp" ;
				break ;
			case 7:													// 工作流 - 我的工作流
				initsrcpage = "/workflow/request/RequestView.jsp" ;
				break ;
			case 8:													// 工作流 - 我的工作流
				initsrcpage = "/system/SystemMaintenance.jsp" ;
				break ;
			case 9:													// 工作流 - 我的工作流
				initsrcpage = "/cpt/CptMaintenance.jsp" ;
				break ;

		}
	}else{
		switch(targetid) {
			case 1:													// 文档  - 新闻
				initsrcpage = "/docs/report/DocRp.jsp" ;
				break ;
			case 2:													// 人力资源 - 新闻
				initsrcpage = "/hrm/report/HrmRp.jsp" ;
				break ;
			case 3:													// 财务 - 组织结构
				initsrcpage = "/fna/report/FnaReport.jsp" ;
				break ;
			case 4:													// 物品 - 搜索页面
				initsrcpage = "/lgc/report/LgcRp.jsp" ;
				break ;
			case 5:													// CRM - 我的客户
				initsrcpage = "/CRM/CRMReport.jsp" ;
				break ;
			case 6:													// 项目 - 我的项目
				initsrcpage = "/proj/ProjReport.jsp" ;
				break ;
			case 7:													// 工作流 - 我的工作流
				initsrcpage = "/workflow/WFReport.jsp" ;
				break ;
			case 8:													// 工作流 - 我的工作流
				initsrcpage = "/system/SystemMaintenance.jsp" ;
				break ;
			case 9:													// 工作流 - 我的工作流
				initsrcpage = "/cpt/report/CptRp.jsp" ;
				break ;

		}
	}
}
if(!relogin0.equals("1")&&frommain.equals("yes")){
logmessages=(Map)application.getAttribute("logmessages");
logmessages.put(""+user.getUID(),logmessage);
}

logmessages=(Map)application.getAttribute("logmessages");
logmessages.put(""+user.getUID(),logmessage);

if(!relogin0.equals("1")&&!frommain.equals("yes")&&!logmessage.equals("")){

session.setAttribute("frommain","true");
%>
<script language=javascript>
	flag=confirm("<%=SystemEnv.getHtmlLabelName(16643,user.getLanguage())%>!\n<%=SystemEnv.getHtmlLabelName(2023,user.getLanguage())%>:"+"<%=logmessage%>");
	if(flag)
	//window.location="/main.jsp?frommain=yes&gopage=<%=gopage%>"
	else
	window.location="/login/Login.jsp"
</script>
<%}%>

<%if(relogin0.equals("1")&&!logmessage.equals("")){%>
<script language=javascript>
	//alert("<%=SystemEnv.getHtmlLabelName(16643,user.getLanguage())%>!\n<%=SystemEnv.getHtmlLabelName(27892,user.getLanguage())+SystemEnv.getHtmlLabelName(2023,user.getLanguage())%>:"+"<%=logmessage%>");
	jQuery(function () {
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(16643,user.getLanguage())%>!<br><%=SystemEnv.getHtmlLabelName(27892,user.getLanguage())+SystemEnv.getHtmlLabelName(2023,user.getLanguage())%>:"+"<%=logmessage%>"
			,function(){}, 372, 70, false
		);
	});
</script>
<%}%>
<script language=javascript>
function goMainFrame(o){
	//jQuery(o).o.contentWindow.document.location.href = "<%=initsrcpage%>"; 
	jQuery("#mainFrame",o.contentWindow.document).attr("src","<%=initsrcpage%>"); 
	//o.contentWindow.document.frames[1].document.location.href = "<%=initsrcpage%>";    
}

function showBirth(){
	if (eBirth) {
	 	var diag_bir = new Dialog();
		diag_bir.Width = 516;
		diag_bir.Height = 420;
		diag_bir.AutoClose=6;
		diag_bir.Modal = false;
		diag_bir.Title = "<%=SystemEnv.getHtmlLabelName(17534,user.getLanguage())%>";
		diag_bir.URL = "/hrm/setting/Birthday.jsp?theme=ecology7";
		diag_bir.show();
	}
}

function showVote(){
	if(voteids !=""){
		var arr = voteids.split(",");
		for(i=0;i<arr.length;i++){
			var diag_vote = new Dialog();
			diag_vote.Width = 800;
			diag_vote.Height = 600;
			diag_vote.Modal = false;
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%>";
			diag_vote.URL = "/voting/VotingPoll.jsp?votingid="+arr[i];
			diag_vote.show();
		}
	}
}

jQuery(document).ready(function (){
	//生日提醒与网上调查
	showBirth();
	showVote();
});
</script>

<html>
<head>
<title><%=templateTitle%> - <%=username%></title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel="stylesheet" href="/css/Weaver.css" type="text/css">

<script language=javascript>
	var glbreply = true;
</script>

<%
if(needusb0==1&&"2".equals(usbtype0)){  
	String randLong = ""+Math.random()*1000000000;
	String serialNo = user.getSerial();
	HTSrvAPI htsrv = new HTSrvAPI();
	String sharv = "";
	sharv = htsrv.HTSrvSHA1(randLong, randLong.length());
	sharv = sharv + "04040404";
	String ServerEncData = htsrv.HTSrvCrypt(0, serialNo, 0, sharv);
%>
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script language="JavaScript"  src="/js/htusbjs.js"></script>
<script language="vbs"  src="/js/htusb.vbs"></script>
<OBJECT id="htactx" name="htactx" classid="clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E" codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px;display:none"></OBJECT>
<script language="JavaScript">
var usbuserloginid = "<%=user.getLoginid()%>";
var usblanguage = "<%=user.getLanguage()%>";
var ServerEncData = "<%=ServerEncData%>";
var randLong = "<%=randLong%>";
var password = "<%=user.getPwd()%>";
checkusb();
</script>
<%
}%>
<style id="popupmanager">
#rightMenu{
	display:none;
}
#arrowBoxUp{
	text-align:center;
	border-left: 1px solid #666666;
	border-right: 1px solid #666666;
	border-top:1px solid #666666;
	background-color: #F9F8F7;
	display:none;
}
#arrowBoxDown{
	text-align:center;
	border-left: 1px solid #666666;
	border-right: 1px solid #666666;
	border-bottom:1px solid #666666;
	background-color: #F9F8F7;
	display:none;
}
.popupMenu{
	width: 100px;
	border: 1px solid #666666;
	background-color: #F9F8F7;
	padding: 1px;
}
.popupMenuTable{
	background-image: url(/images/popup/bg_menu.gif);
	background-repeat: repeat-y;
}
.popupMenuTable TD{
	font-family:MS Shell Dlg;
	font-size: 12px;
	cursor: default;
}
.popupMenuRow{
	height: 18px!important;
	
}
.popupMenuRowHover{
	height: 18px!important;
	
	background-color: #B6BDD2;
}
.popupMenuSep{
	background-color: #A6A6A6;
	height:1px;
	width: 70;
	position: relative;
	left: 28;
}
</style>


<style type="text/css">
/* 搜索控件用css */
.searchkeywork {width: 74px;font-size: 12px;height:22px;margin-top:1;margin-left:-2px;background:none;border:none;color:#333;top:0;margin:0;padding:1;padding-top:3px;}
.dropdown {margin-left:5px; font-size:11px; color:#000;height:23px;margin:0;padding:0;padding-top:2px;}
.selectContent, .selectTile, .dropdown ul { margin:0px; padding:0px; }
.selectContent { position:relative;z-index:6; }
.dropdown a, .dropdown a:visited { color:#816c5b; text-decoration:none; outline:none;}
.dropdown a:hover { color:#5d4617;}
.selectTile a:hover { color:#5d4617;}
.selectTile a {background:none; display:block;width:40px;margin-left:4px;margin-top:1px;}
.selectTile a span {cursor:pointer; display:block; padding:0 0 0 0;background:none;}
.selectContent ul { background:#fff none repeat scroll 0 0; border:1px solid #828790; color:#C5C0B0; display:none;left:0px; position:absolute; top:2px; width:auto; min-width:50px; list-style:none;}
.dropdown span.value { display:none;}
.selectContent ul li a { padding:0px 0 0px 2px; display:block;margin:0;width:60px;}
.selectContent ul li a:hover { background-color:#3399FF;}
.selectContent ul li a img {border:none;vertical-align:middle;margin-left:2px;}
.selectContent ul li a span {margin-left:5px;}
.flagvisibility { display:none;}
</style>

<script type="text/javascript">
// 搜索控件用js
jQuery(document).ready(function() {
		jQuery(".dropdown img.flag").addClass("flagvisibility");

        jQuery(".selectTile a").click(function() {
            jQuery(".selectContent ul").toggle();
        });
                    
        jQuery(".selectContent ul li a").click(function() {
            var text = jQuery(this).children("span").html();
            jQuery("#basicSearchrTypeText").html(text);
            jQuery("input[name='searchtype']").val(jQuery(this).children("span").attr("searchType"));
            jQuery(".selectContent ul").hide();
        });
                    
        function getSelectedValue(id) {
            return jQuery("#" + id).find("selectContent a span.value").html();
        }

        jQuery(document).bind('click', function(e) {
            var $clicked = jQuery(e.target);
            if (! $clicked.parents().hasClass("dropdown"))
                jQuery(".selectContent ul").hide();
        });


        jQuery("#flagSwitcher").click(function() {
            jQuery(".dropdown img.flag").toggleClass("flagvisibility");
        });
});		

window.onresize = function winResize() {
	if (jQuery("#mainBody").width() <= 1024 ) {
		jQuery("#topMenuTbl").css("width", "1019px");
	} else {
		jQuery("#topMenuTbl").css("width", jQuery("#mainBody").width() - 5);
	}
}	

jQuery(document).ready(function(){
   jQuery("#mainBody").css("background","url(<%=bodyBg %>) repeat-y");
});

</script>


	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>

<script language=javascript> 

function showThemeListDialog(){
	var themeDialog = new Dialog();
	themeDialog.Width = 500;
	themeDialog.Height = 440;
	themeDialog.ShowCloseButton=true;
	themeDialog.Title = "主题中心";
	themeDialog.Modal = false;
	themeDialog.URL = "/wui/theme/ecology7/page/skinList.jsp";
	themeDialog.show();
}
</script> 
	
<script language="javascript" src="/js/weaver.js"></script>
</head>
<body id="mainBody"  text="#000000"  style="" scroll="no" oncontextmenu="return false;">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%@ include file="/favourite/FavouriteShortCut.jsp" %>
<script>   
  var con=null;
  window.onbeforeunload=function(e){	
	  if(typeof(isMesasgerUnavailable) == "undefined") {
		     isMesasgerUnavailable = true; 
	  }  
	  if(!isMesasgerUnavailable && glbreply == true){
	  	return "<%=SystemEnv.getHtmlLabelName(24985,user.getLanguage())%>";
	  }	
	  e=getEvent(); 
	  var n = e.screenX - e.screenLeft;
	  var b = n > document.documentElement.scrollWidth-20;  
	  if(b && e.clientY < 0 || e.altKey){
	  	e.returnValue = "<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>"; 
	  }
  }  
  window.onunload=function(){	 
	  <%
		boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
		boolean isHaveEMessager=Prop.getPropValue("Messager2","IsUseEMessager").equalsIgnoreCase("1");
		int isHaveMessagerRight = PluginUserCheck.checkPluginUserRight("messager",user.getUID()+"");
		if(isHaveMessager&&!userid.equals("1")&&isHaveMessagerRight==1){%>
			logoutForMessager();
		<%}%>
  }
  </script>
<iframe id="downLoadReg" style="display: none;"></iframe>  
<div id='divShowSignInfo' style='background:#FFFFFF;padding:0px;width:100%;display:none' valign='top'>
</div>

<div id='message_Div' style='display:none'>
</div>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="71px" id="topMenuTd">
		<Table id="topMenuTbl" height="100%" width="100%" cellspacing="0" cellpadding="0" style="background:url(<%=topBgImage %>) repeat-x;">
			<tr id="topMenuLogo" height="43px">
				<td  width="198px" height="43px" style="position:relative;background:url(<%=(logoTop == null || logoTop.equals("")) ? "/wui/theme/ecologyBasic/page/images/logo_up.png" : logoTop %>) no-repeat;">
				&nbsp;
				</td>
				<td width="*">
				</td>
			</tr>
			<%
					String logoBtmImgSrc="";
		            if (logoBtm == null || logoBtm.equals("")) {
		            	logoBtmImgSrc = "/wui/theme/ecologyBasic/page/images/logo_down.png";
		           
		            } else {
		            	logoBtmImgSrc = logoBtm;
					
		            }
					%>
			<tr height="28px">
				<td height="28px" width="198px" style="background:url(<%=logoBtmImgSrc %>)">
					
					
				
					
				</td>
				<td width="*" height="28px" style="">
					
					<table height="28px" width="100%"  cellspacing="0" cellpadding="0" style='background:url(<%=toolbarBgColor %>) repeat-x'>
						<tr>
							<td height="100%" width="680px" align="left">
								<table  height=100% border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width=23 align="center" >
											<%if(!logintype.equals("2")){%>
											<iframe BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE width=0 height=0 SCROLLING=no SRC=/system/SysRemind.jsp></iframe>
											<%}%>
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/BP_Hide.png) no-repeat;" id="LeftHideShow" onclick="javascript:mnToggleleft()" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></td></tr></table>
										</td>
											<td width=23 align="center">
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/BP2_Hide.png) no-repeat;" id="TopHideShow" onclick="javascript:mnToggletop()" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></td></tr></table>
										</td>
										<td width=10 align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:5px;">
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/LogOut.png) no-repeat;" onclick="javascript:toolBarLogOut()" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>"></span></td></tr></table><!--退出-->
										</td>
										<td width=10 align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:5px;">
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu"  style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Back.png) no-repeat" onclick="javascript:toolBarBack()" title="<%=SystemEnv.getHtmlLabelName(15122,user.getLanguage())%>"></span></td></tr></table><!--后退-->
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle" >
											<table style="position:relative;" class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Pre.png) no-repeat;" onclick="javascript:toolBarForward()" title="<%=SystemEnv.getHtmlLabelName(15123,user.getLanguage())%>"></span></td></tr></table><!---->
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Refur.png) no-repeat;" onclick="javascript:toolBarRefresh()" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>"></span></td></tr></table><!--刷新-->
										</td>
										<!-- <td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/wui/theme/ecologyBasic/page/images/toolbar/Favourite.gif" onclick="javascript:toolBarFavourite()" title="<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>"></td></tr></table>
										</td> --><!--收藏夹-->
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table style="position:relative;" class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Print.png) no-repeat;" onclick="javascript:toolBarPrint()" title="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>"></span></td></tr></table><!--打印-->
										</td>
										<%if(weaver.general.GCONST.getMOREACCOUNTLANDING()){%>
										<%//多账号%>
										<%List accounts =(List)session.getAttribute("accounts");
							                if(accounts!=null&&accounts.size()>1){
							                    Iterator iter=accounts.iterator();
							                %>
							            <td width=10 align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:5px;">
										</td>
							            <td style="width:23px;height:28px;" align="center" valign="middle" style="position:relative;">
								            <table class="toolbarMenu"><tr>
								            <td><select id="accountSelect" name="accountSelect" onchange="onCheckTime(this);"  disabled>
								                    <% while(iter.hasNext()){Account a=(Account)iter.next();
								                    String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
								                    String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
								                    String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());                       
								                    %>
								                    <option <%if((""+a.getId()).equals(userid)){%>selected<%}%> value=<%=a.getId()%>><%=subcompanyname+"/"+departmentname+"/"+jobtitlename%></option>
								                    <%}%>
								                </select></td></tr></table>
								        </td>
								            	<%}%>
											<%}%>
										<td width=10 align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:5px;">
										</td>
										<td width="50px" id="favouriteshortcutid" style="position:relative;padding-top:6px">
											<span id="favouriteshortcutSpan" style="color:#fff;text-align:center;padding-top:5px;border:none">
												<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage()) %>
											</span>
											<span class="toolbarBgSpan" style="position:absolute;width:10px;height:6px;border:none;margin-top:5px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/favorites_slt.png) no-repeat;">
											</span>
										</td>
										<td width=10 align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:5px;">
										</td>
										<!-- 搜索block start -->			
										<td width="143px" style="padding-top:2px;">
											
					                        <form name="searchForm" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
								            <TABLE cellpadding="0px" cellspacing="0px" height="23px" width="100%" align="right" style="position:relative;z-index:6;" id="searchBlockTBL">
								                <tr height="100%" style="background: url(/wui/theme/ecologyBasic/page/images/toolbar/search/searchBg.png) center repeat;">
								                    <td width="40px" height="100%" style="margin:0;padding:0;">
								                        <input type="hidden" name="searchtype" value="1">
								                        <div id="sample" class="dropdown" style="position:relative;top:1px;">
								                            <div class="selectTile" style="height: 100%;vertical-align: middle;">
									                            <a href="#"><span style="float:left;width:25px;display:block;" id="basicSearchrTypeText"><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%></span>
																	<TABLE cellpadding="0px" cellspacing="0px" height="4px" width="8px" align="center">
																		<tr>
																			<td width="8px" height="4px" valign="middle" >
																			
																				<div style="position:absolute;overflow:hidden;display:block;width:8px;top:10px;left:36px;height:8px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/search/searchSlt.png) no-repeat;" class="toolbarSplitLine"></div>
																			
																			</td>
																		</tr>
																	</TABLE>
																</a>
															</div>
								                            <div class="selectContent">
								                                <ul id="searchBlockUl">
								                                    <li><a href="#"><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/doc.gif"/><span searchType="1"><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%></span></a></li>
								                                    <li><a href="#"><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/hr.png"/><span searchType="2"><%=SystemEnv.getHtmlLabelName(30042,user.getLanguage())%></span></a></li>
								                                    <li><a href="#"><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/crm.gif"/><span searchType="3"><%=SystemEnv.getHtmlLabelName(30043,user.getLanguage())%></span></a></li>
								                                    <li><a href="#"><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/zc.gif"/><span searchType="4"><%=SystemEnv.getHtmlLabelName(30044,user.getLanguage())%></span></a></li>
								                                    <li><a href="#"><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/wl.png"/><span searchType="5"><%=SystemEnv.getHtmlLabelName(30045,user.getLanguage())%></span></a></li>
								                                    <li><a href="#"><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/p.gif"/><span searchType="6"><%=SystemEnv.getHtmlLabelName(30046,user.getLanguage())%></span></a></li>
								                                    <li><a href="#"><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/mail.gif"/><span searchType="7"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></span></a></li>
					                                                <li><a href="#"><img src="/wui/theme/ecologyBasic/page/images/toolbar/search/searchType/xz.gif"/><span searchType="8"><%=SystemEnv.getHtmlLabelName(30047,user.getLanguage())%></span></a></li>
								                                </ul>
								                            </div>
								                        </div>
								                    </td>
								                  
								                   
								                      <td width="74px">
								                        <input type="text" name="searchvalue" onMouseOver="this.select()" class="searchkeywork"  style=""/>
								                    </td>
								                    <td width="22px" style="position:relative;">
								                        <span onclick="searchForm.submit()" id="searchbt" style="top:4px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/search/searchBt.png)  no-repeat;display:block;width:16px;height:16px;overflow:hidden;cursor:hand;"></span>
								                    </td>
								                </tr>
								            </table>
								            </form>
					                    </td>
										<!-- 搜索block end -->
										<td width="10px">
										</td>
										
										<%

										if(isSignInOrSignOut.equals("1")&&isWorkday&&!isSyadmin&&ll<0){
										    String currentYearMonthDate=currentyear+"-"+currentmonth+"-"+currentdate;
										
											RecordSet.executeSql("SELECT 1 FROM HrmScheduleSign where userId="+user.getUID()+" and  userType='"+user.getLogintype()+"' and signDate='"+currentYearMonthDate+"' and signType='1'  and isInCom='1'");
											if(RecordSet.next()){
												signType="2";
											}
										
										%>
										<td>
										    <div id="signInOrSignOutSpan" onclick="signInOrSignOut(jQuery(this).attr('_signType'))" _signType="<%=signType%>" style="display:block;height:21px;width:56px;text-align:center;padding-top:1px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/sign.gif) no-repeat;cursor:hand;color:blue;Vertical-align:middle;position:relative;overflow:hidden;">
												<%
												if(signType.equals("1")){
													out.println(SystemEnv.getHtmlLabelName(20032,user.getLanguage()));
												}else{
													out.println(SystemEnv.getHtmlLabelName(20033,user.getLanguage()));
												}
												%>						      
										    </div>
										</td>
										<%
										}
										%>
										
									</tr>
								</table>
							</td>
							
							
							
							<td align="right" style="">
		<table height=100% border="0" cellspacing="0" cellpadding="0" >
			<tr>
			<td width=23 align="center" >
				<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Home.png) no-repeat;" onclick="javascript:goUrl('/homepage/HomepageRedirect.jsp')" title="<%=SystemEnv.getHtmlLabelName(1500,user.getLanguage())%>"></span></td></tr></table><!--首页-->
			</td>
			
         <!-- 页面模板选择开始-->
		<td style="width:10;height:28px;"></td>
	    <%
	    if (islock == null || !"1".equals(islock)) {
	    %>
	    <td style="width:23;height:28px;z-index:1;" align="left" valign="middle">
	    	<div style="position:relative;">
			<table class="toolbarMenu" >
			<tr>
			<td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';" onclick="javascript:showThemeListDialog();"><span class="toolbarBgSpan" style="top:6px;left:4px;display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/ThemeSlt.png) no-repeat;" title="主题选择"></span>
			</td>
			</tr>
			</table><!--皮肤-->
			
			</div>
		</td>
		<%
	    }
		%>
         <!-- 页面模板选择结束-->

			<td width=10 align="center" style="position:relative;">
				<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:5px;">
			</td>
			
			<%
			if((isHaveMessager&&!userid.equals("1")&&isHaveMessagerRight==1)||isHaveEMessager){ 
			%>
				<td width="23" align="center" style="position:relative;">
					<!--  <div id="divMessagerState"/>-->
					<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';" id="tdMessageState"></td></tr></table>
				</td>	
				<td width=10 align="center" style="position:relative;">
					<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:5px;">
				</td>
			<%}%>
			
			
			<script type="text/javascript">
				jQuery(document).ready(function() {
					jQuery("#toolbarMore").css("filter", "");
					jQuery("#toolbarMore").hide();
					
					jQuery("#toolbarMore").hover(function() {
			        }, function() {
			        	jQuery("#toolbarMore").hide();
			        });
			        jQuery("#toolbarMore td").bind("click", function() {
			        	jQuery("#toolbarMore").hide();
			        });
				});
				
				function toolbarMore() {
					jQuery("#toolbarMore").toggle();
				}
			</script>
			<td width=30 align="center" style="z-index:1;">
						<div style="position:relative;">
						<table class="toolbarMenu"><tr><td onclick="javascript:toolbarMore();" onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="left:4;top:4px;display:block;width:23px;height:22px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMore.png) no-repeat;" title="<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>"></span></td></tr></table>
			        	<div id="toolbarMore" style="display:none;position:absolute;width:184px;right:8px;top:25px;">
			        		<div id="toolbarMoreBlockTop" style="overflow:hidden;width:184px;background-image:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMoreTop.png);height:11px;"></div>
			        		<TABLE cellpadding="2" cellspacing="0" align="center" width="100%" style="margin:0;background-image:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMoreCenter.jpg);background-repeat: repeat-y;">
			        			<tr><td colspan="5" height="5px"></td></tr>
				    	    	<tr align="center">
				    	    			<td width="5px"></td>
				    	    			<%
										if(checkchattemp){
										%>
										<td width="25px" align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/msn.gif" onclick="javascript:showHrmChatTree('')" title="<%=SystemEnv.getHtmlLabelName(23525,user.getLanguage())%>"></td></tr></table><!---->
										</td>
										<%}%>
										<%if("1".equals(MouldStatusCominfo.getStatus("scheme"))){ %>
							            <td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Plan.gif" onclick="javascript:goUrl('/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>')" title="<%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>"></td></tr></table><!--我的计划-->
										</td>
										<%}%>
										<%if("1".equals(MouldStatusCominfo.getStatus("message"))){ %>
										<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Mail.gif" onclick="javascript:goUrl('/email/MailFrame.jsp?act=add')" title="<%=SystemEnv.getHtmlLabelName(2029,user.getLanguage())%>"></td></tr></table><!--新建邮件-->
										</td>
								    	<%}%>
										<%if("1".equals(MouldStatusCominfo.getStatus("doc"))){ %>
							        	<td width=25px align="center">
											 <table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Doc.gif" onclick="javascript:goUrl('/docs/docs/DocList.jsp')" title="<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>"></td></tr></table><!--新建文档-->
										</td>
										<%} %>
										<%if("1".equals(MouldStatusCominfo.getStatus("workflow"))){ %>
								        <td width=23px align="center">
										    <table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/WorkFlow.gif" onclick="goUrl('/workflow/request/RequestType.jsp?needPopupNewPage=true')" title="<%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%>"></td></tr></table><!--新建流程-->
										</td>
										<%} %>	
								</tr>
								<tr align="center">
										<td width="5px"></td>
										<%if(isgoveproj==0){%>
							            <%if(software.equals("ALL") || software.equals("CRM")){%>
							      		<%if("1".equals(MouldStatusCominfo.getStatus("crm"))){ %>      
							      		<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/CRM.gif" onclick="javascript:goUrl('/CRM/data/AddCustomerExist.jsp')" title="<%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%>"></td></tr></table><!---->
										</td>
										<%}%>
										<%if("1".equals(MouldStatusCominfo.getStatus("proj"))){ %>
							            <td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/PRJ.gif" onclick="javascript:goUrl('/proj/data/AddProject.jsp')" title="<%=SystemEnv.getHtmlLabelName(15007,user.getLanguage())%>"></td></tr></table><!---->
										</td>
										<%}%>
							            <%}%>
										<%}%>
										<%if("1".equals(MouldStatusCominfo.getStatus("meeting"))){ %>
							            <td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Meeting.gif" onclick="javascript:goUrl('/meeting/data/AddMeeting.jsp')" title="<%=SystemEnv.getHtmlLabelName(15008,user.getLanguage())%>"></td></tr></table><!---->
										</td>
										<%}%>			
										<td width=23px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Org.gif" onclick="javascript:goUrl('/org/OrgChart.jsp?charttype=H')" title="<%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%>"></td></tr></table><!--组织结构-->
										</td>	
									</tr>
									<tr align="center">	
										<td width="5px"></td>
										<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Plugin.gif" onclick="javascript:goopenWindow('/weaverplugin/PluginMaintenance.jsp')" title="<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage())%>"></td></tr></table><!--插件-->
										</td>
							         	<%if(rtxClient.isValidOfRTX()){
											RTXConfig rtxConfigtmp = new RTXConfig();
											String RtxOrElinkType = (Util.null2String(rtxConfigtmp.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
											if("ELINK".equals(RtxOrElinkType)){ 
										%>
                                        <td width=23px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/favicon.jpg" onclick="javascript:openEimClient()" title="打开OCS客户端"></td></tr></table><!---->
										</td>
										<%} else {%>
										<td width=23px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/rtx.gif" onclick="javascript:openRtxClient()" title="打开RTX客户端"></td></tr></table><!---->
										</td>
							         	<%}}%>
							         	<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Version.gif" onclick="javascript:showVersion()" title="<%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>"></td></tr></table><!--版本-->
										</td>
										<td width=25px align="center">
										    <table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/safeSite.png" width="15px" onclick="javascript:setSafeSite()" title="Ecology<%=SystemEnv.getHtmlLabelName(28422,user.getLanguage())%>"></td></tr></table><!--版本-->
										</td>
										<td>
										</td>
							    	</tr>
							   
							    <tr><td colspan="5" height="5px"></td></tr>
			        		</TABLE>
			        		<TABLE cellpadding="0px" cellspacing="0px" height="5px" width="100%" style="background:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMoreBottom.png) no-repeat;"><tr><td height="5px"></td></tr></TABLE>
						</div>
						</div>
			        </td>
			
			<!--
				<td width=10 align="center" style="position:relative;">
					<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0 style="margin-top:5px;">
				</td>
				<td width=30 align="center">
					<table class="toolbarMenu" style="position:relative;"><tr><td onclick="javascript:alert('对不起，泛微官方社区正在建设中...');" onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:23px;height:22px;background:url( /wui/theme/ecologyBasic/page/images/toolbar/fanweisq.png) no-repeat;" onclick="" title="泛微社区"></span></td></tr></table>
				</td>
			 -->
			</tr>
		</table>
		</td>
						</tr>
					</table>
				</td>
			</tr>
		</Table>
		<div id="divFavContent" style="position: absolute;z-index: 1000; bottom:10;left:100">
	<div class="popupMenu">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%" class="popupMenuTable">
		<tr height="26">
			<td class="popupMenuRow" onmouseover="this.className='popupMenuRowHover';" onmouseout="this.className='popupMenuRow';" id="popupWin_Menu_Setting">
				<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
					<tr>
						<td width="28">&nbsp;</td>
						<td onclick="goSetting()"><%=SystemEnv.getHtmlLabelName(18166,user.getLanguage())%></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="3">
			<td>
				<div class="popupMenuSep"><img height="1px"></div>
			</td>
		</tr>
	</table>
	</div>
</div>
	</td>	
</tr>
<tr>
	<td style="padding:0px 0px 0px 0px;">
		<div id="bgy" style="position:absolute;width:5px;height:5px;top:70;left:5;z-index:10;overflow:hidden;background:url(/wui/theme/ecologyBasic/page/images/bg-y.png) no-repeat;"></div>
		<iframe id="leftFrame" name="leftFrame" BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height="100%" width="99%" scrolling="NO" src="/wui/theme/ecologyBasic/page/leftFrame.jsp" onload="goMainFrame(this)" style="margin-left: 5px;"/>	
	</td>
</tr>
</table>

<%
if(checkchattemp){
%>
<iframe name="hrmChat" src="/chat/chat.jsp" width="50px" height="50px"></iframe>  
<%}%>
<%
    HrmUserSettingHandler handler = new HrmUserSettingHandler();
    HrmUserSetting setting = handler.getSetting(user.getUID());

    boolean rtxOnload = setting.isRtxOnload();

    if(rtxClient.isValidOfRTX() && rtxOnload){
		String rtxorelinkurl = "";
		RTXConfig rtxConfig = new RTXConfig();
		String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
		if("ELINK".equals(RtxOrElinkType)){ 
			rtxorelinkurl = "EimClientOpen.jsp";
		} else {
			rtxorelinkurl = "RTXClientOpen.jsp";
		}
%>
<iframe name="rtxClient" src="/<%=rtxorelinkurl%>" style="display:none"></iframe>
<%  }else{                                                                       %>
<iframe name="rtxClient" src="" style="display:none"></iframe>
<%  }                                                                            %>
<script>


document.oncontextmenu=""
//search.searchvalue.oncontextmenu=showRightClickMenu1

function showRightClickMenu1(){
	var o = document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame");
    if(o.workSpaceLeft!=null)
		o.workSpaceLeft.rightMenu.style.visibility="hidden";
    if(o.workSpaceInfo!=null)
        o.workSpaceInfo.rightMenu.style.visibility="hidden";
    if(o.workSpaceRight!=null)
		o.workSpaceRight.rightMenu.style.visibility="hidden";
    if(o.workplanLeft!=null)
        o.workplanLeft.rightMenu.style.visibility="hidden";
    if(o.workplanRight!=null)
		o.workplanRight.rightMenu.style.visibility="hidden";
        showRightClickMenu();
}
</script>
</body>
<!--文档弹出窗口-- 开始-->
<% 
String docsid = "";
String pop_width = "";
String pop_hight = "";
String is_popnum = "";
String popupsql = "select docid,pop_num,pop_hight,pop_width,is_popnum from DocDetail  t1, "+tables+"  t2,DocPopUpInfo t3 where t1.id=t2.sourceid and t1.id = t3.docid and (t1.ishistory is null or t1.ishistory = 0) and (t3.pop_startdate <= '"+CurrentDate+"' and t3.pop_enddate >= '"+CurrentDate+"') and pop_num > is_popnum";
RecordSet.executeSql(popupsql); 
while(RecordSet.next()){ 
docsid = RecordSet.getString("docid");
pop_hight = RecordSet.getString("pop_hight");
pop_width = RecordSet.getString("pop_width");
is_popnum = RecordSet.getString("is_popnum");
if("".equals(pop_hight)) pop_hight = "500";
if("".equals(pop_width)) pop_width = "600";
%>
<script language=javascript defer="defer"> 
  var is_popnum = <%=is_popnum%>;
  var docsid = <%=docsid%>;
  var pop_hight = <%=pop_hight%>;
  var pop_width = <%=pop_width%>;
  var docid_num = docsid +"_"+ is_popnum;
  window.open("/docs/docs/DocDsp.jsp?popnum="+docid_num,"","height="+pop_hight+",width="+pop_width+",scrollbars,resizable=yes,status=yes,Minimize=yes,Maximize=yes");
</script> 
<%}%>
<!--文档弹出窗口-- 结束-->
<SCRIPT language=javascript>

jQuery(document).ready(function(){

	jQuery("#favouriteshortcutSpan").load("/wui/theme/ecologyBasic/page/FavouriteShortCut.jsp");
	
})

function showFav(obj){
	var popupX = 0;
	var popupY = 0;
	//alert(jQuery("#divFavContent").html())
	//jQuery("#divFavContent",parent.parent.document).css("position","absolute");
	var offset = jQuery(obj).offset();
	//alert(offset.left)
	jQuery("#divFavContent").css({left:offset.left+26,bottom:offset.bottom});
	
	jQuery("#divFavContent").show();
	//parent.parent.showFav(obj);
}
//jQuery("#divFavContent")[0].onmouseover=onmove;


jQuery("#divFavContent").bind('mouseout',function(e){
	if(isMouseLeaveOrEnter(e, this)) {hideLeftMoreMenu(e);}
	
});

function isMouseLeaveOrEnter(e, handler) {
	e = jQuery.event.fix(e); 
    if (e.type != 'mouseout' && e.type != 'mouseover') return false;
    var reltg = e.relatedTarget ? e.relatedTarget : e.type == 'mouseout' ? e.toElement : e.fromElement;
    while (reltg && reltg != handler)  {
        reltg = reltg.parentNode;
     }
    return (reltg != handler);
}

function hideLeftMoreMenu(){	
	jQuery("#divFavContent").hide();
	return false;
}
function goSetting(){
	jQuery("#mainFrame",jQuery("#leftFrame")[0].contentWindow.document)[0].src='/systeminfo/menuconfig/CustomSetting.jsp'
	//jQuery("#mainFrame",)
}



function insertToPopupMenu(o){
	//alert(o.src)
	var tbl,tbl2,tr,td;
	tbl = document.createElement("table");
	
	tbl.cellspacing = 0;
	tbl.cellpadding = 0;
	tbl.width = "100%";
	tbl.height = "100%";
	tr = tbl.insertRow(-1);
	td = tr.insertCell(-1);
	td.width = 20;
	td.innerHTML = "<img src='"+o.src+"' width='16' heigh='16'/>";
	td = tr.insertCell(-1);
	//td.algin='left';
	td.innerHTML = o.getAttribute("menuname");
	//alert(jQuery(".popupMenuTable").length)
	tbl2 = jQuery(".popupMenuTable").get(0);
	//alert(tbl2.tagName)
	tr = tbl2.insertRow(-1);
	//tr.height="21px";
	td = tr.insertCell(-1);
	tr.height = 21;
	td.onclick = function(){slideFolder(this);};
	td.onmouseover = function(){this.className='popupMenuRowHover';};
	td.onmouseout = function(){this.className='popupMenuRow';};
	td.className = "popupMenuRow";
	td.setAttribute("menuid",o.getAttribute("menuid"));
	td.appendChild(tbl);
}
function openRtxClient(){
    document.all("rtxClient").src="/RTXClientOpen.jsp?notify=true";
}
function openEimClient(){
	document.all("rtxClient").src="/EimClientOpen.jsp";
}

function mnToggleleft(){
	var o = document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrameSet");
	if(o.cols=="0,*"){
		var iMenuWidth=134;
		var iLeftMenuFrameWidth=Cookies.get("iLeftMenuFrameWidth");	
		if(iLeftMenuFrameWidth!=null) iMenuWidth=iLeftMenuFrameWidth;
		try{
			if(jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox")){
				jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox").style.display = "block";
			}
			o.cols = iMenuWidth+",*";
			document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").noResize = false;
			document.getElementById("leftFrame").contentWindow.document.getElementById("LeftMenuFrame").noResize = false;
			
			LeftHideShow.title = "<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";//隐藏
		}catch(e){
			window.status = e;
		}		
	}else{		
		try{
			if(jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox")){
		    	jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox").style.display = "none";
			}
			document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").noResize = true;
			document.getElementById("leftFrame").contentWindow.document.getElementById("LeftMenuFrame").noResize = true;
			
			o.cols = "0,*";
			LeftHideShow.title = "<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";//显示
		}catch(e){
			alert(e)
			window.status = e;
		}
	}
	//add by lupeng 2004.04.27 for TD315
	//leftFrame.location.reload();//重新load左边按钮
	//end
}

function mnToggletop(){
	if(topMenuLogo.style.display == ""){
		jQuery("#topMenuTd").height(28);
		if(document.getElementById("logoBottom")!=null){
			logoBottomSpan.style.display = "block";
			logoBottom.style.display = "none";
			jQuery("#bgy").css("top", jQuery("#bgy").offset().top - 43);
			jQuery("#toolbarBg").css("top", 0);
		}
		topMenuLogo.style.display = "none";
		topMenu.style.height = "28px";
		TopHideShow.title = "<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";//显示

	}
	else{
		jQuery("#topMenuTd").height(71);
		if(document.getElementById("logoBottom")!=null){
			logoBottomSpan.style.display = "none";
			logoBottom.style.display = "block";
			jQuery("#bgy").css("top", jQuery("#bgy").offset().top + 43);
			jQuery("#toolbarBg").css("top", 43);
		}
		topMenuLogo.style.display = "";
		TopHideShow.title = "<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";//隐藏
	}
	//leftFrame.location.reload();//重新load左边按钮
}

function slideFolder(o){

	//jQuery("#leftFrame").contentWindow.document.getElementById("mainFrame")
	jQuery("#LeftMenuFrame",jQuery("#leftFrame")[0].contentWindow.document)[0].contentWindow.slideFolder(o);
	
}

function newSelect()	//新建跳转
{
	var sendRedirect  = document.all("NewBuildSelect").value ;
	if (sendRedirect!="") mainFrame.location.href = sendRedirect ;
}

function favouriteSelect() //收藏夹跳转
{
	var sendRedirect  = document.all("FavouriteSelect").value ;
	if (sendRedirect!="") mainFrame.location.href = sendRedirect ;
}

function toolBarBack() //后退
{
	window.history.back();
}

function toolBarForward() //前进
{
	window.history.forward();
}

function toolBarRefresh(){
	try{
	document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").contentWindow.document.location.reload();
	}catch(exception){}
}

function toolBarStop()
{
    document.getElementById("leftFrame").contentWindow.document.frames[1].document.execCommand('Stop')
}

function toolBarFavourite() //收藏夹
{
	if( typeof (document.getElementById("leftFrame").contentWindow.document.frames[1].contentWindow) == undefined );
	return false;
	var o = document.getElementById("leftFrame").contentWindow.document.frames[1].document.all("BacoAddFavorite");
	if(o!=null)	o.click();
	//杨国生2003-09-26 由于收藏无法直接得到mainFrame中的页面名称，所以采用折衷办法，把TopTile.jsp中的原收藏按钮类型改为hidden,然后直接调用该按钮的onclick()事件。
}

function toolBarPrint() //打印
{
    parent.frames["leftFrame"].frames["mainFrame"].focus();
    parent.frames["leftFrame"].frames["mainFrame"].print();
}

function goUrl(url){
	document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").src = url;
}

var chatwindforward;


function goUrlPopup(o){
	var url = o.getAttribute("url");
	parent.document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").src = url;
}
function goopenWindow(url){
  var chasm = screen.availWidth;
  var mount = screen.availHeight;
  if(chasm<650) chasm=650;
  if(mount<700) mount=700;
  window.open(url,"PluginCheck","scrollbars=yes,resizable=no,width=690,Height=650,top="+(mount-700)/2+",left="+(chasm-650)/2);
}
function isConfirm(LabelStr){
if(!confirm(LabelStr)){
   return false;
}
   return true;
}

function toolBarLogOut() //退出
{
	var LabelStr= "<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>" ;
	<%/* TD4406 modified by hubo,2006-07-10 */%>
	//if(isConfirm(LabelStr)) location.href="/login/Logout.jsp";
	<%/* TD5713 modified by fanggsh,2007-01-09 */%>
	if(isConfirm(LabelStr)){ 
		//mainBody.onbeforeunload=null;
		mainBody.onunload=null;
		location.href="/login/Logout.jsp";
	}

}

/*先注释掉，功能不明
var sRepeat=null;
var oPopup = window.createPopup();
function GetPopupCssText()
{
	var styles = document.styleSheets;
	var csstext = "";
	for(var i=0; i<styles.length; i++)
	{
		if (styles[i].id == "popupmanager")
			csstext += styles[i].cssText;
	}
	return csstext;
}
function mouseout(){
	var x = oPopup.document.parentWindow.event.clientX;
	var y = oPopup.document.parentWindow.event.clientY
	if(x<0 || y<0) oPopup.hide();
	sRepeat = null;
}

function doScrollerIE(dir, src, amount) {	
	if (amount==null) {amount=10}	
	if (dir=="up"){
		oPopup.document.all[src].scrollTop-=amount;
	}else{
		oPopup.document.all[src].scrollTop+=amount;
	}
	if (sRepeat==null) {sRepeat = setInterval("doScrollerIE('"+dir+"','" + src + "'," + amount + ")",150)}	
	return false;
}

function doClearInterval(){
	clearInterval(sRepeat);
}
*/
function ajaxInit(){
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

function signInOrSignOut(signType){
    if(signType != 1){
	    var ajaxUrl = "/wui/theme/ecology7/page/getSystemTime.jsp";
		ajaxUrl += "?field=";
		ajaxUrl += "HH";
		ajaxUrl += "&token=";
		ajaxUrl += new Date().getTime();
		
		jQuery.ajax({
		    url: ajaxUrl,
		    dataType: "text", 
		    contentType : "charset=gbk", 
		    error:function(ajaxrequest){}, 
		    success:function(content){
		    	var isWorkTime = jQuery.trim(content);
		    	if (isWorkTime == "true" && !confirm('<%=SystemEnv.getHtmlLabelName(26273, user.getLanguage())%>')) {
		            return;
		        }
		    	writeSignStatus(signType);
		    }  
	    });
    } else {
    	writeSignStatus(signType);
    }
}

function writeSignStatus(signType) {
	var ajax=ajaxInit();
    ajax.open("POST", "/hrm/schedule/HrmScheduleSignXMLHTTP.jsp?t="+Math.random(), true); 
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("signType="+signType);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            	signInOrSignOutSpan.innerHTML='<%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%>';
                showPromptForShowSignInfo(ajax.responseText, signType);
                jQuery("#signInOrSignOutSpan").attr("_signType", 2);
            }catch(e){
            }
        }
    }
}


var showTableDiv  = document.getElementById('divShowSignInfo');
var oIframe = document.createElement('iframe');


//type  1:显示提示信息
//      2:显示返回的历史动态情况信息
function showPromptForShowSignInfo(content, signType){
    var targetSrc = "";
	content = jQuery.trim(content).replace(/&nbsp;/g, "");
	var confirmContent = "<div style=\"margin-left:5px;margin-right:5px;\">" + content.substring(content.toUpperCase().indexOf('<TD VALIGN="TOP">') + 17, content.toUpperCase().indexOf("<BUTTON"));
	
    var checkday="";
	if(signType==1) checkday="prevWorkDay";
	if(signType==2) checkday="today";
	jQuery.post("/blog/blogOperation.jsp?operation=signCheck&checkday="+checkday,"",function(data){
		var dataJson=eval("("+data+")");
		if (dataJson.isSignRemind==1){
		    if(!dataJson.prevWorkDayHasBlog&&signType==1){
				confirmContent += "<br><br><span style=\"color:red;\"><%=SystemEnv.getHtmlLabelName(26987,user.getLanguage())%></span>";
				targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
			}else if(!dataJson.todayHasBlog&&signType==2){
				confirmContent += "<br><br><span style=\"color:red;\"><%=SystemEnv.getHtmlLabelName(26983,user.getLanguage())%></span>";
				targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
			}
			
			confirmContent += "</div>";
			if (targetSrc != undefined && targetSrc != null && targetSrc != "") {
				Dialog.confirm(
					confirmContent, function (){
						window.open(targetSrc);
					}, function () {}, 520, 90,false
			    );
			} else {
				Dialog.alert(confirmContent, function() {}, 520, 60,false);
			}
			
		    return ;
		}
		confirmContent += "</div>";
		Dialog.alert(confirmContent, function() {}, 520, 60,false);
    });
}

function onCloseDivShowSignInfo(){
	divShowSignInfo.style.display='none';
	message_Div.style.display='none';
	document.all.HelpFrame.style.display='none'
}
var firstTime = new Date().getTime();
function onCheckTime(obj){
	window.location = "/login/IdentityShift.jsp?shiftid="+obj.value;
}
function setAccountSelect(){
	var nowTime = new Date().getTime();
	if((nowTime-firstTime) < 10000){
		setTimeout(function(){setAccountSelect();},1000);
	}else{
		try{
			document.getElementById("accountSelect").disabled = false;
		}catch(e){}
	}
}
setAccountSelect();

//设置受信站点
function setSafeSite(){
  //jQuery("#downLoadReg").attr("src","/weaverplugin/safeSite.jsp");
  jQuery("#downLoadReg").attr("src","/weaverplugin/EcologyPlugin.zip");
}

</SCRIPT>
<script language="javascript">
function showVersion(){
	about=window.showModalDialog("/systeminfo/version.jsp",null,"dialogHeight:376px;dialogwidth:466px;help:no");
}
</script>

<script language=javascript>

<%if(isSignInOrSignOut.equals("1")&&isWorkday&&!isSyadmin&&"1".equals(signType)&&ll<0){%>
if(confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>")){
	signInOrSignOut(<%=signType%>);
}
<%}%>
</script> 

</html>
<script language="javascript" src="/js/Cookies.js"></script>

<%
if(isHaveEMessager){
%>
	<%@ include file="/messager/joinEMessage.jsp"%>
<%
}else{
	if((user.getUID()!=1)&&isHaveMessagerRight==1){ 
%>
	<%@ include file="/messager/join.jsp" %>
<%}}%>



<!--[if IE 6]>
	<script type='text/javascript' src='/wui/common/jquery/plugin/8a-min.js'></script>
<![endif]-->
<!--[if IE 6]>	
	<script languange="javascript">
		DD_belatedPNG.fix('.toolbarBgSpan,.toolbarSplitLine,#searchbt,.searchBlockBgDiv,#toolbarMoreBlockTop,#toolbarBg,#tdMessageState img,background');
		//DD_belatedPNG.fix('#toolbarMoreBlockTop,background');
		jQuery("#tdMessageState").css("padding-top", "6px");
	</script>  
	<STYLE TYPE="text/css">
		
	</script>

<![endif]-->