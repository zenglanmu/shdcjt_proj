<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.blog.BlogManager"%>
<jsp:useBean id="appDao" class="weaver.blog.AppDao"></jsp:useBean>
<html>
<head>
<script type='text/javascript' src='js/timeline/lavalamp.min.js'></script>
<script type='text/javascript' src='js/timeline/easing.js'></script>
<script type='text/javascript' src='js/blogUtil.js'></script>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp.css" rel="stylesheet" type="text/css"> 
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>
</head>
<%
  String userid=""+user.getUID();
  String from=Util.null2String(request.getParameter("from"));
  String type=Util.null2String(request.getParameter("type"));
  
  Calendar calendar=Calendar.getInstance();
  int currentMonth=calendar.get(Calendar.MONTH)+1;
  int currentYear=calendar.get(Calendar.YEAR);
  
  int year=Util.getIntValue(request.getParameter("year"),currentYear);
  
  BlogDao blogDao=new BlogDao();
  Map monthMap=blogDao.getCompaerMonth(year);
  int startMonth=((Integer)monthMap.get("startMonth")).intValue();   //开始月份
  int endMonth=((Integer)monthMap.get("endMonth")).intValue();       //结束月份
  
  Map enbaleDate=blogDao.getEnableDate();
  int enableYear=((Integer)enbaleDate.get("year")).intValue();      //微博开始使用年
  
  int month=Util.getIntValue(request.getParameter("month"),endMonth);
  
  String monthStr=month<10?("0"+month):(""+month);
  String isSignInOrSignOut=Util.null2String(GCONST.getIsSignInOrSignOut());//是否启用前到签退功能
%>
<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<div style="width:100%;" >
  <div align="center" id="reportTitle" style="margin-top: 8px;font-weight: bold;font-size: 15px;color: #123885;display: <%=!"other".equals(from)?"block":"none"%>"><%=year+"-"+monthStr%> <%=SystemEnv.getHtmlLabelName(18040,user.getLanguage())%></div><!-- 我的报表 -->
  <div style="margin-top: 3px;margin-bottom: 15px">
         <div class="lavaLampHead">
             <div style="width: 80%;float: left;">
					<ul class="lavaLamp" id="timeContent">
					  <%for(int i=startMonth;i<=endMonth;i++){ 
					      monthStr=i<10?("0"+i):("")+i;
					  %>
					     <li <%=i==month?"class='current'":""%>><a href="javascript:changeMonth(<%=year%>,<%=i%>,'<%=monthStr%>','<%=SystemEnv.getHtmlLabelName(18040,user.getLanguage())%>')"><%=i%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></a></li><!-- 月 -->
					  <%}%>
					</ul>
			  </div>	
			  <div class="report_yearselect" align="right"> 
			     <select class="yearSelect" id="yearSelect" onchange="changeYear()">
			         <%
					   for(int i=currentYear;i>=enableYear;i--){ 
					 %>
					   <option value="<%=i%>" <%=i==year?"selected='selected'":""%>><%=i%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></option><!-- 年 -->
				    <%} %>
			     </select>
			  </div>	
         </div>
    </div>
	<div id="blogReportDiv"> 
	</div>
	<div style="margin-top: 8px;text-align: left;">
	   <%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>：
	       <span style="margin-right: 8px"><img src="images/submit-no.png" align="absmiddle" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%></span>
	       <span  style="margin-right: 8px"><img src="images/submit-ok.png" align="absmiddle" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())%></span>
	       <%if(appDao.getAppVoByType("mood").isActive()) {%>
	       <span  style="margin-right: 8px"><img src="images/mood-unhappy.png" align="absmiddle" width="16px" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%></span>
	       <span  style="margin-right: 8px"><img src="images/mood-happy.png" align="absmiddle" width="16px" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%></span>
	       <%} %>
	      <%if(isSignInOrSignOut.equals("1")){ %> 
	       <span style="margin-right: 8px;"><img src="images/sign-absent.png" width="18px" align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(20085,user.getLanguage())%></span>
	       <span style="margin-right: 8px;"><img src="images/sign-no.png" width="18px" align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(20081,user.getLanguage())%></span>
	       <span style="margin-right: 8px;"><img src="images/sign-ok.png" width="18px" align="absmiddle"  style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></span>
	      <%} %>  
	</div>
</div>		
<script type="text/javascript">
  jQuery(document).ready(function(){   
     window.parent.displayLoading(1,"data");
     jQuery("#blogReportDiv").load("myReportRecord.jsp?userid=<%=userid%>&year=<%=year%>&month=<%=month%>&isSignInOrSignOut=<%=isSignInOrSignOut%>",function(){
        window.parent.displayLoading(0);
     });
     jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
  });
  
  function changeMonth(year,month,monthstr,title){
      window.parent.displayLoading(1,"data");
	  jQuery("#blogReportDiv").load("myReportRecord.jsp?userid=<%=userid%>&isSignInOrSignOut=<%=isSignInOrSignOut%>&year="+year+"&month="+month,function(){
	       window.parent.displayLoading(0);
	  });
	  jQuery("#reportTitle").html(year+"-"+monthstr+" "+title);
  }
  
  function changeYear(){
    window.parent.displayLoading(1,"page");
    var year=jQuery("#yearSelect").val();
    window.location.href="myReport.jsp?year="+year;
  } 
</script>	
</body>
</html>