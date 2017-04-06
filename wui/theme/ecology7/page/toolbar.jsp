<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>

<%@ include file="/times.jsp" %>
<jsp:useBean id="signRs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxClient" class="weaver.rtx.RTXClientCom" scope="page" />
<jsp:useBean id="hrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="MouldStatusCominfo" class="weaver.systeminfo.MouldStatusCominfo" scope="page" />

<%
    /*用户验证*/
    User user = HrmUserVarify.getUser(request, response);
    if (user == null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
    StaticObj staticobj = null;
    staticobj = StaticObj.getInstance();
    String software = (String)staticobj.getObject("software") ;
    if(software == null) software="ALL";

    int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
    String Customertype = Util.null2String(""+user.getType()) ;
    String logintype = Util.null2String(user.getLogintype()) ;
    
    
    String skin = (String)request.getAttribute("REQUEST_SKIN_FOLDER");
	//------------------------------------
	//签到部分 Start
	//------------------------------------
	boolean isSyadmin=false;
	//判断分权管理员
	signRs.executeSql("select loginid from hrmresourcemanager where loginid = '"+user.getLoginid()+"'");
	if(signRs.next()){
	   isSyadmin = true;
	}
	
  	String isSignInOrSignOut=Util.null2String(GCONST.getIsSignInOrSignOut());//是否启用前到签退功能  
  	
    //判断当前用户当天有没有签到
  	String signType="1";
  	String sign_flag = "1";
  	
  	String CurrentDate = formatDate("yyyy-MM-dd", null);
  	
  	hrmScheduleDiffUtil.setUser(user);
    boolean isWorkday = hrmScheduleDiffUtil.getIsWorkday(CurrentDate);
    
    boolean isNeedSign = false; 
    if(isSignInOrSignOut.equals("1")&&isWorkday&&!isSyadmin&&ll<0){
    	Calendar today = Calendar.getInstance();
    	String currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
    	String currentmonth = Util.add0(today.get(Calendar.MONTH)+1, 2) ;
    	String currentdate = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    	String currenthour = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) ;
    	
        String currentYearMonthDate=currentyear+"-"+currentmonth+"-"+currentdate;
        signRs.executeSql("SELECT 1 FROM HrmScheduleSign where userId="+user.getUID()+" and  userType='"+user.getLogintype()+"' and signDate='"+currentYearMonthDate+"' and signType='1'  and isInCom='1'");
        if(signRs.next()){
            signType="2";
        }
        sign_flag = signType;
        isNeedSign = true; 
    } else {
    	isNeedSign = false; 
    }
	//------------------------------------
	//签到部分 End
	//------------------------------------
	String signWeekBg = getWeekBg(user);
    
%>
<%!
private String getWeekBg(User user) {
	String strWeek = "";
    java.util.GregorianCalendar g=new java.util.GregorianCalendar();
    int week = g.get(java.util.Calendar.DAY_OF_WEEK);
    switch(week) {
    case 1:
    	strWeek = SystemEnv.getHtmlLabelName(24626,user.getLanguage());
        break;
    case 2:
    	strWeek = SystemEnv.getHtmlLabelName(392,user.getLanguage());
        break;
    case 3:
    	strWeek = SystemEnv.getHtmlLabelName(393,user.getLanguage());
        break;
    case 4:
    	strWeek = SystemEnv.getHtmlLabelName(394,user.getLanguage());
        break;
    case 5:
    	strWeek = SystemEnv.getHtmlLabelName(395,user.getLanguage());
        break;
    case 6:
    	strWeek = SystemEnv.getHtmlLabelName(396,user.getLanguage());
        break;
    case 7:
    	strWeek = SystemEnv.getHtmlLabelName(397,user.getLanguage());
        break;
    default:
    	break;
    }
    
    return strWeek;
}
private String formatDate(String format, Date date) {
	SimpleDateFormat sdf = new SimpleDateFormat(format);
	Calendar calendar = Calendar.getInstance();
	if (date == null) {
		date = new Date();
	}
	calendar.setTime(date);
    return sdf.format(calendar.getTime());
}
%>

<script language=javascript>
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
            	jQuery("#sign_dispan").text("<%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%>");
                showPromptForShowSignInfo(ajax.responseText, signType);
                jQuery("#sign_dispan").attr("_signFlag", 2);
                if(navigator.userAgent.indexOf("MSIE")>0 && navigator.userAgent.indexOf("MSIE 6.0") > 0){  
					DD_belatedPNG.fix('.tbItm,#toolbarMoreBlockTop,.searchBlockBgDiv,#sign_dispan,.topBlockDateBlock,.toolbarTopRight,background');
				}
            }catch(e){
            }
        }
    }
}

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
    var showTableDiv  = document.getElementById('divShowSignInfo');
    var oIframe = document.createElement('iframe');
    
    divShowSignInfo.style.display='none';
    message_Div.style.display='none';
    if (document.all.HelpFrame && document.all.HelpFrame.style) {
        document.all.HelpFrame.style.display='none'
    }
}

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
function getNowTime(){
        //取得当前时间
        var now= new Date();
        var hour=now.getHours();
        
        if (hour < 18) {
            return false;
        }
        return true;
}
</script>

<script type="text/javascript">
<!--
    jQuery(document).ready(function() {
        jQuery(".tbItm").hover(function() {
			/** by zfh 2011-09-20
			*由于IE用jQuery无法获取background-position的值，支持background-position-y，background-position-x，
			*而Safri，firefox，chrome正好相反，先使用下面方法获取background-position的值
			*/
        	var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-y","-25px");
			}else{
				bp=bp.split(" ","1")[0];
				jQuery(jQuery(this)[0]).css("background-position",bp+"  -25px");
			}
        }, function() {
            var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-y","0px");
			}else{
				bp=bp.split(" ","1")[0];
				jQuery(jQuery(this)[0]).css("background-position",bp+" 0px");
			}
        });
        
        jQuery(".dropdown img.flag").addClass("flagvisibility");

        jQuery(".selectTile a").click(function() {
            jQuery(".selectContent ul").toggle();
        });
                    
        jQuery(".selectContent ul li a").click(function() {
            var text = jQuery(this).children("span").html();
            jQuery(".selectTile a").children("span").html(text);
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
        
        jQuery("#searchbt").hover(function() {
			var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-x","-27px");
			}else{
				bp=bp.split(" ","2")[1];
				jQuery(jQuery(this)[0]).css("background-position","-27px "+bp);
			}
        }, function() {
            var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-x","-0px");
			}else{
				bp=bp.split(" ","2")[1];
				jQuery(jQuery(this)[0]).css("background-position","-0px "+bp);
			}
        });
        
        //更多按钮
        jQuery(".toolbarMore").bind("click", function() {
        	jQuery("#toolbarMore").hide();
        });
        
        jQuery("#toolbarMore").hover(function() {
        }, function() {
        	jQuery("#toolbarMore").hide();
        });
        
        //为了兼容ie6，收藏夹iframe动态载入
        jQuery("#navFav").css("position", "relative");
		 jQuery("#navFav").load("/wui/theme/ecology7/page/FavouriteShortCut.jsp")
		//ie6下下拉菜单被select遮盖
		jQuery("#searchBlockUl iframe").css("height", jQuery("#searchBlockUl").height());
		
		jQuery("#searchBlockUl").hover(function () {
		}, function () {
			jQuery("#searchBlockUl").hide();
		});
		jQuery(".selectTile").hover(function () {
		}, function () {
			var clientx = event.clientX;
			var clienty = event.clientY;
			
			var elex = jQuery(this).offset().left;
			var eley = jQuery(this).offset().top;
		
			if (clientx < elex || elex > jQuery(this).offset().right || clienty < eley) {
				jQuery("#searchBlockUl").hide();
			} else {
				return;
			}
		});
		
    });
    
function toolbarMore() {
	jQuery("#toolbarMore").toggle();
}

function goopenWindow(url){
    var chasm = screen.availWidth;
    var mount = screen.availHeight;
    if(chasm<650) chasm=650;
    if(mount<700) mount=700;
    window.open(url,"PluginCheck","scrollbars=yes,resizable=no,width=690,Height=650,top="+(mount-700)/2+",left="+(chasm-650)/2);
}

function goUrl(url){
	document.getElementById("mainFrame").src = url;
}

function showCalendarDialog(){
	var diag_xx = new Dialog();
	diag_xx.Width = 600;
	diag_xx.Height = 387;
	
	diag_xx.ShowCloseButton=true;
	diag_xx.Title = "<%=SystemEnv.getHtmlLabelName(490,user.getLanguage())%>";
	diag_xx.Modal = false;

	diag_xx.URL = "/calendar/wnl2.jsp";
	diag_xx.show();
}

function setSafeSite(){
  jQuery("#downLoadReg").attr("src","/weaverplugin/EcologyPlugin.zip");
}
//-->
</script>

<script type="text/javascript">
<!--
function toolbarSearchIframeOnload(_this) {
}
function showVersion(){

	 about=window.showModalDialog("/systeminfo/version.jsp","","dialogHeight:376px;dialogwidth:466px;help:no");
}




//-->
</script>


<STYLE TYPE="text/css">
    .tbItm{
        cursor:pointer;
        background-position: left center;
        height:20px;
        width:20px;
        background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg.png);
    }
    
    .toolbarItemSelected{
        filter:alpha(opacity=99);-moz-opacity:0.99;
    }

	.searchkeywork {width: 67px;font-size: 12px;height:23px !important;margin-top:1;margin-left:-2px;background:none;border:none !important;color:#333 ;}
	.dropdown {margin-left:5px; font-size:11px; color:#000;height:23px;}
	.selectContent, .selectTile, .dropdown ul { margin:0px; padding:0px; }
	.selectContent { position:relative;z-index:6; }
	.dropdown a, .dropdown a:visited { color:#816c5b; text-decoration:none; outline:none;}
	.dropdown a:hover { color:#5d4617;}
	.selectTile a:hover { color:#5d4617;}
	.selectTile a {background:none; display:block;width:40px;margin-left:4px;margin-top:1px;}
	.selectTile a span {cursor:pointer; display:block; padding:6 0 0 0;background:none;height:25px;}
	.selectContent ul { background:#fff none repeat scroll 0 0; border:1px solid #828790; color:#C5C0B0; display:none;left:0px; position:absolute; top:2px; width:auto; min-width:50px; list-style:none;}
	.dropdown span.value { display:none;}
	.selectContent ul li a { padding:2px 0 2px 2px; display:block;margin:0;width:60px;}
	.selectContent ul li a:hover { background-color:#3399FF;}
	.selectContent ul li a img {border:none;vertical-align:middle;margin-left:2px;}
	.selectContent ul li a span {margin-left:5px;}
	.flagvisibility { display:none;}
</STYLE>
<iframe id="downLoadReg" style="display: none;"></iframe>
<div>
<table width="242px" align="right">
	<tr width="100%">
        <td align="right" stylt="top:0;">
            <TABLE cellpadding="0px" cellspacing="0px" height="29px;" width="<%=isNeedSign ? "256px" : "215px" %>" align="right" style="margin-right:2px;">
                <tr height="100%">
                    <td style="">
						<div class="searchBlockBgDiv" style="float:left;padding-top:20px;width:140px;height:29px;background-image: url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg.png);background-position: 0 -75 ;background-repeat:no-repeat;margin:0;padding:0;">
						
							<form name="searchForm" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
								<input type="hidden" name="searchtype" value="1">
									<div id="sample" class="dropdown" style="float:left;">
										<div class="selectTile">
											<a href="#">
												<span style="float:left;width:32px;display:block;overflow:hidden;text-overflow:ellipsis;"><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%></span>
												<div style="float:right;display: block; width:8px;height:18px;*height:18px;background: url(/wui/theme/ecology7/skins/default/page/ecologyShellImg.png);background-repeat: no-repeat; background-position: -262px  -62px;"></div>
											</a>
										</div>
										<div class="selectContent" style="margin-top:26px;*margin-top:20px;_margin-top:0px;">
											<ul id="searchBlockUl">
												<iframe src="" style="filter:alpha(opacity=0);opacity:0;position:absolute; visibility:inherit; top:0px; left:0px; width:100%; height:100%; z-index:-1; filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';" >
												</iframe>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/doc.gif"/><span searchType="1"><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%></span></a></li>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/hr.png"/><span searchType="2"><%=SystemEnv.getHtmlLabelName(30042,user.getLanguage())%></span></a></li>
											<%if(isgoveproj==0){%>
												<%if((Customertype.equals("3") || Customertype.equals("4") || !logintype.equals("2"))&&("1".equals(MouldStatusCominfo.getStatus("crm"))||"".equals(MouldStatusCominfo.getStatus("crm")))){%> 
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/crm.gif"/><span searchType="3"><%=SystemEnv.getHtmlLabelName(30043,user.getLanguage())%></span></a></li>
												<%
												}
											}
												%>
											<%
											if((!logintype.equals("2")) && software.equals("ALL")&&("1".equals(MouldStatusCominfo.getStatus("cpt"))||"".equals(MouldStatusCominfo.getStatus("cpt")))){%>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/zc.gif"/><span searchType="4"><%=SystemEnv.getHtmlLabelName(30044,user.getLanguage())%></span></a></li>
											<%
											}
											%>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/wl.png"/><span searchType="5"><%=SystemEnv.getHtmlLabelName(30045,user.getLanguage())%></span></a></li>
											<%
											if(isgoveproj==0&&("1".equals(MouldStatusCominfo.getStatus("proj"))||"".equals(MouldStatusCominfo.getStatus("proj")))){%>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/p.gif"/><span searchType="6"><%=SystemEnv.getHtmlLabelName(30046,user.getLanguage())%></span></a></li>
											<%
											}
											%>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/mail.gif"/><span searchType="7"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></span></a></li>
											<%if("1".equals(MouldStatusCominfo.getStatus("message"))||"".equals(MouldStatusCominfo.getStatus("message"))) {%>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/xz.gif"/><span searchType="8"><%=SystemEnv.getHtmlLabelName(30047,user.getLanguage())%></span></a></li>
											<%} %>
											</ul>
										</div>
									</div>
									
									<div style="float:left;">
										<input type="text" name="searchvalue" onMouseOver="this.select()" class="searchkeywork"/>
									</div>
									<div style="float:left;margin-top:5px;">
										<div  onclick="searchForm.submit()" id="searchbt" style="cursor:pointer;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg.png);background-position: 0 -129px;background-repeat: no-repeat; display:block;width:22px;height:19px;margin-left:4px;"></div>
									</div>
									
							 </form>
						</div>
						
						<div style="float:left;">
								<div style="float:left">
									<div class="topBlockDateBlock" style="float:left;cursor:pointer;font-weight:bold;color:#003366;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg.png);background-position: -148px -75px;background-repeat: no-repeat;width:54px;height:29px;line-height:32px;text-align:center;overflow:hidden;" >
										<%=signWeekBg %>
									</div>
								</div>
								<%
								if (isNeedSign) {
								%>
									<div style="float:left;">
										<div onclick="signInOrSignOut(jQuery(this).attr('_signFlag'))" style="float:left;cursor:pointer;color:#fff;font-weight:bold;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg.png) ;background-repeat: no-repeat;background-position:-207 -75px;display:block;width:40px;height:29px;text-align:center;line-height:29px;overflow:hidden;text-overflow:ellipsis;" _signFlag="<%=sign_flag %>" id="sign_dispan">
										<%="1".equals(sign_flag) ? SystemEnv.getHtmlLabelName(20032,user.getLanguage()) : SystemEnv.getHtmlLabelName(20033,user.getLanguage()) %>
										</div>
									</div>
								<%
								}
								%>
								<div style="float:left;display:block;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg.png);background-position: -252 -75px;background-repeat: no-repeat;width:6px;height:29px;" class="toolbarTopRight">
								</div>
						</div>
                    </td>           
                </tr>
            </TABLE>
        </td>
    </tr>
    
	<tr>
		<td height="2px;"></td>
	</tr>
	
    <tr style="" width="100%" align="bottom">
    	<td width="100%">
    	    <TABLE cellpadding="0px" cellspacing="0px" style="margin-top:5px;" width="100%" align="right">
    	    	<tr align="left">
    	    		<!-- 主页 -->
			        <td onClick="javascript:dymlftenu(this);" title="<%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%>">
						<span style="background-position:0 0;display:block;" class="tbItm"></span>
			        </td>
			         <td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">
			        		<span style="margin-right:7px;display:block;width:2px;height:20px;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg.png);background-position:0 -50;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>
					<!-- 收藏夹 -->
			        <td onClick=""  title="<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>">
			        	 <ul id="navFav"> </ul>
			        </td>
			        <!-- Line -->
			        <td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">
			        		<span style="margin-right:7px;display:block;width:2px;height:20px;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg.png);background-position:0 -50;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>
					<!-- 刷新 -->
			        <td onClick="document.getElementById('mainFrame').contentWindow.document.location.reload()" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>" >
			        	<span style="background-position:-25 0;display:block;" class="tbItm"></span>
			        </td>
			        <!-- 后退 -->
			        <td onClick="mainFrame.history.go(-1)" title="<%=SystemEnv.getHtmlLabelName(15122,user.getLanguage())%>">
			        	<span style="background-position:-50 0;display:block;" class="tbItm"></span>
			        </td>
			        <!-- 前进 -->
			        <td onClick="mainFrame.history.go(1)" title="<%=SystemEnv.getHtmlLabelName(15123,user.getLanguage())%>">
			        	<span style="background-position:-75 0;display:block;" class="tbItm"></span>
			        </td>
			        
			       

                     <%if(rtxClient.isValidOfRTX()){
						 RTXConfig rtxConfig = new RTXConfig();
						 String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
						 if("ELINK".equals(RtxOrElinkType)){ 
					 %>
					<td onClick="javascript:openEimClient()" title="<%=SystemEnv.getHtmlLabelName(27463,user.getLanguage())%>">
			        	<span style="background-position:-370 0;display:block;" class="tbItm"></span>
			        </td>
					<%} else {%>
					<td onClick="javascript:openRtxClient()" title="打开RTX客户端">
			        	<span style="background-position:-395 0;display:block;" class="tbItm"></span>
			        </td>					
					<%}}%>
			        
			        <td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">
			        		<span style="margin-right:7px;display:block;width:2px;height:20px;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg.png);background-position:0 -50;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>
			        
			        <td onclick="javascript:toolbarMore();" title="<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>" style="position:relative;"> 
			        	<span style="background-position:-270 0;display:block;" class="tbItm"></span>
				   </td>
					<td style="position:absolute;right:42px;">
						<div id="toolbarMore" style="display:none;position:absolute;width:184px;right:0;top:22;">
			        		<div id="toolbarMoreBlockTop" style="background-image:url(/wui/theme/ecology7/skins/<%=skin %>/page/top/toolbarMoreTop.png);background-repeat:no-repeat;height:11px;overflow:hidden;width:184px;"></div>
			        		<TABLE  cellpadding="10" cellspacing="3px" align="center" width="100%" style="margin:0;background-image:url(/wui/theme/ecology7/skins/<%=skin %>/page/top/toolbarMoreCenter.jpg);background-repeat:repeat-y;">
			        			<tr><td colspan="5" height="5px"></td></tr>
				    	    	<tr align="center">
				    	    		<td onclick="leftBlockContractionOrExpand();" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="background-position:-295 0;display:block;" class="tbItm"></span>
							        </td>
							        
							        <td onclick="topBlockContractionOrExpand();" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="background-position:-320px 0;display:block;" class="tbItm"></span>
							        </td>
							        <td onclick="window.open('/systeminfo/menuconfig/CustomSetting.jsp','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%>">
							        	<span style="background-position:-150 0;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td onclick="javascript:goopenWindow('/weaverplugin/PluginMaintenance.jsp')" title="<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage())%>">
							        	<span style="background-position:-175 0;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td onclick="javascript:showVersion()" title="<%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>">
							        	<span style="background-position:-200 0;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							    </tr>
							    <tr align="center">
				    	    		<td onclick="window.open('/workflow/request/RequestType.jsp?needPopupNewPage=true','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%>">
										<span style="background-position:-100 0;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
									<td onclick="window.open('/docs/docs/DocList.jsp?isuserdefault=1','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>">
										<span style="background-position:-125 0;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td onclick="window.open('/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>">
										<span style="background-position:-345 0;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td title="Ecology<%=SystemEnv.getHtmlLabelName(28422,user.getLanguage())%>" onclick="setSafeSite()">
							            <span style="background-position:-420 0;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td></td>
							    </tr>
							    <tr><td colspan="5" height="5px"></td></tr>
			        		</TABLE>
			        		<TABLE cellpadding="0px" cellspacing="0px" height="5px" width="100%" style="background:url(/wui/theme/ecology7/skins/<%=skin %>/page/top/toolbarMoreBottom.png);background-repeat: no-repeat;"><tr><td height="5px"></td></tr></TABLE>
						<iframe src="javascript:false" style="filter:alpha(opacity=0);opacity:0;position: absolute; visibility: inherit; top: 0px; left: 0px; width: 184px; height: 200px; z-index: -1; filter='progid:dximagetransform.microsoft.alpha(style=0,opacity=0)';" > 
    </iframe> 
						</div>
					</td>
			        <td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">
			        		<span style="margin-right:7px;display:block;width:2px;height:20px;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg.png);background-position:0 -50;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>
			        <td onclick="javascript:if(window.confirm('<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>')) {window.location='/login/Logout.jsp';}" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>"> 
			        	<span style="background-position:-225 0;display:block;" class="tbItm"></span>
			        </td>
    	    	</tr>
    		</TABLE> 
    	</td>
        
    </tr>
</table>
</div>




<%
if (isNeedSign) {
	if("1".equals(signType)){
%>
		<script type="text/javascript">
		<!--
			if(confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>")){
		 		signInOrSignOut(<%=signType%>);
			}
		-->
		</script>
<%
	}
}
%>

