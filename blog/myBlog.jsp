<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.blog.BlogReportManager"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.AppDao"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@page import="weaver.blog.AppItemVo"%>
<%@page import="weaver.blog.AppVo"%>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(26468,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel=stylesheet href="/css/Weaver.css" type="text/css" />
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='js/timeline/lavalamp.min.js'></script>
<script type='text/javascript' src='js/timeline/easing.js'></script>
<script type='text/javascript' src='js/highlight/jquery.highlight.js'></script>
<script language="javascript" src="/js/weaverTable.js" type="text/javascript"></script>
<link href="js/timeline/lavalamp.css" rel="stylesheet" type="text/css"> 
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/kindeditor/kindeditor.js"></script>
<script type="text/javascript" src="/kindeditor/kindeditor-Lang.js"></script>

<link href="js/weaverImgZoom/weaverImgZoom.css" rel="stylesheet" type="text/css">
<script src="js/weaverImgZoom/weaverImgZoom.js"></script>

<script type="text/javascript" src="js/raty/js/jquery.raty.js"></script>

<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>

<!-- 微博便签 -->
<script type="text/javascript" src="/blog/js/notepad/notepad.js"></script>

<!-- 加载javascript -->
<jsp:include page="blogUitl.jsp"></jsp:include>
</head>
<body>
<%@ include file="/blog/uploader.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
	String userid = "" + user.getUID();
	BlogDao blogDao = new BlogDao();
	Date today = new Date();
	Date startDateTmp = new Date();
	SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyy年MM月dd日");
	SimpleDateFormat timeFormat=new SimpleDateFormat("HH:mm");
	
	String curDate = dateFormat1.format(today); //当前日期
	startDateTmp.setDate(startDateTmp.getDate() - 30);
	String startDate =dateFormat1.format(startDateTmp);

	AppDao appDao = new AppDao();
	List appItemVoList = appDao.getAppItemVoList("mood");
	
	String enableDate=blogDao.getSysSetting("enableDate");       //微博启用日期
	String attachmentDir=blogDao.getSysSetting("attachmentDir"); //附件上传目录
	
	if(dateFormat1.parse(enableDate).getTime()>dateFormat1.parse(startDate).getTime()){
		startDate=enableDate;
	}
	
	String menuItem=Util.null2String(request.getParameter("menuItem"));
	
	if(menuItem.equals(""))
		menuItem="myBlog";
	
	BlogReportManager reportManager=new BlogReportManager();
	
	//来访记录
	int visitTotal=blogDao.getVisitTotal(userid);
	int visitCurrentpage=1;
	int visitTotalpage=visitTotal%5>0?visitTotal/5+1:visitTotal/5;
	List visitorList=blogDao.getVisitorList(userid,visitCurrentpage,5,visitTotal);
	
	int accessTotal=blogDao.getAccessTotal(userid);
	int accessCurrentpage=1;
	int accessTotalpage=accessTotal%5>0?accessTotal/5+1:accessTotal/5;
	List visitList=blogDao.getAccessList(userid,accessCurrentpage,5,accessTotal);
	
	List tempList=blogDao.getTemplate(""+user.getUID());
	String tempContent="";
	int isUsedTemp=0;
	if(tempList.size()>0){
		isUsedTemp=1;
		tempContent=(String)((Map)tempList.get(0)).get("tempContent");
	}
%>

<script type="text/javascript">
   var tempHeight=0;      //微博模版高度
   var isUsedTemp=<%=isUsedTemp%>;  //是启用模版
</script>

 <div>
	 <DIV id=bg></DIV>
	 <div id="loading">
			<div style=" position: absolute;top: 35%;left: 25%" align="center">
			    <img src="/images/loading2.gif" style="vertical-align: middle"><label id="loadingMsg"><%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%></label>
			</div>
	 </div>
 </div>
<div style="height: 100%;" id="myBlogdiv">
    <div style="height:30px;line-height:30px;margin-top:0px" class="TopTitle">
	   <div class="topNav" style="float: left;margin-right:10px">  
			<ul>
				<li class="selected"><a href="myBlog.jsp" style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(26468,user.getLanguage())%></a></li><!-- 微博主页--> 
			</ul>
		</div>
		<span style="float: right;margin-right: 5px;margin-top: 5px;" >
		    <button title="<%=SystemEnv.getHtmlLabelName(18753,user.getLanguage())%>" class="btnFavorite" id="BacoAddFavorite" onclick="openFavouriteBrowser()" type="button" style="vertical-align: top;"></button><!-- 加入收藏夹 -->
	        <button title="帮助" style="margin-left:5px;vertical-align: top;" class="btnHelp" id="btnHelp" onclick="alert('帮助');" type="button"></button><!-- 帮助-->
		</span>
		<div id="searchDiv"  align="right" style="display: block;float: right;margin-top: 4px;">
			<table  cellpadding=0 cellspacing=0>
			<tr>
				<td>
				     <INPUT id=startdate name=startdate type=hidden value="<%=startDate%>">
					 <BUTTON type="button" class=Calendar onclick="getDate('startdatespan','startdate')" style="vertical-align: top;"></BUTTON>
					 <SPAN id="startdatespan"><%=startDate%></SPAN>
					 	<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>&nbsp;
					 <BUTTON type="button" class=Calendar onclick="getDate('enddatespan','enddate')" style="vertical-align: top;"></BUTTON> 
					 <SPAN id=enddatespan><%=curDate%></SPAN>&nbsp;
					 <INPUT id=enddate name=enddate type=hidden value="<%=curDate%>">
					<span>&nbsp;</span>
				</td>
				<td align="right">
	                <div class="searchBox">
	                <input id="content" class="searchInput" onkeydown="if(event.keyCode==13) jQuery('#searchBtn').click();"/> 
	                <div class="searchBtn" id="searchBtn" from="homepage" onclick="search('content','startdate','enddate',this);removeScroll()"></div>
	                </div>
				</td>
			</tr>
		</table>
		</div>
	</div>
<div class="mainContent" style="">
<table style="width: 100%">
   <tr>
       <td valign="top" width="*" style="max-width: 800px;">
            <!-- 左边 --> 
			<div class="left">
			    
			    <div class="tabStyle2" style="margin-top:6px;display: none;width: 100%" id="myBlogMenu">
					<UL>
					    <!-- 我的微博 -->
						<LI id="blog" class="select2" style="margin-left: 10px" url="discussList.jsp?blogid=<%=userid%>&requestType=myblog"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(26468,user.getLanguage())%></A></LI>
						<!-- 我的报表 -->
						<LI id="report" url="myBlogReport.jsp?from=view&userid=<%=userid%>"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(18040,user.getLanguage())%></A></LI>
						<!-- 我的关注 -->
						<LI url="myAttentionHrm.jsp?userid=<%=userid%>"><A href="javascript:void(0)" ><%=SystemEnv.getHtmlLabelName(26933,user.getLanguage())%></A></LI>
						<!-- 关注我的 -->
						<LI url="attentionMeHrm.jsp?userid=<%=userid%>"><A href="javascript:void(0)" ><%=SystemEnv.getHtmlLabelName(26940,user.getLanguage())%></A></LI>
					    <!-- 我能查看 -->
					    <LI url="canViewHrm.jsp?userid=<%=userid%>"><A href="javascript:void(0)" >我能查看</A></LI>
					    <!-- 我能查看 -->
					    <LI url="canViewMeHrm.jsp?userid=<%=userid%>"><A href="javascript:void(0)" >能查看我</A></LI>
					</UL>
				</div>
			    
				<div class="reportBody" id="reportBody" align="center" style="padding-top: 8px;float: none;"></div>
				
				<!-- 主页数据加载提示 -->
				<div id="loadingdiv" style="position:relative;width: 100%;height: 30px;margin-bottom: 15px;display: none;">
			      <div class='loading' style="position: absolute;top: 10px;left: 50%;">
			         <img src='/images/loadingext.gif' align="absMiddle"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
			      </div>
			    </div>	
			</div>
       </td>
       <td valign="top" style="width:195px;padding-left: 12px"> 
          <!-- 右边 -->
			<div class="right" style="margin-top: 10px;">
				<div class="side-item" style="margin-bottom: 6px;">
				    <span>   
				             <!-- 工作指数 -->
							 <a href="javascript:void(0)" class="index" onclick="openReport()"><%=SystemEnv.getHtmlLabelName(26929,user.getLanguage())%>：<span id="workIndexCount" title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(0)%></span><span id="workIndex" style="font-weight: bold;margin-left: 8px;color: #666666">0.0</span></a><br/><!-- 未提交 应提交 -->
							 <%if(appDao.getAppVoByType("mood").isActive()){ 
							 %>
							 <!-- 心情指数 -->
							 <a href="javascript:void(0)" class="index" onclick="openReport()"><%=SystemEnv.getHtmlLabelName(26930,user.getLanguage())%>：<span id="moodIndexCount" title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(0)%></span><span id="moodIndex" style="font-weight: bold;margin-left: 8px;color: #666666">0.0</span></a><br/><!-- 不高兴 高兴 -->
							 <%}%>
							 <% String isSignInOrSignOut=Util.null2String(GCONST.getIsSignInOrSignOut());//是否启用前到签退功能
							    if(isSignInOrSignOut.equals("1")){
							 %>
							 <!-- 考勤指数 -->
							 <a href="javascript:void(0)" class="index" onclick="openReport()"><%=SystemEnv.getHtmlLabelName(26931,user.getLanguage())%>：<span id="scheduleIndexCount" title="<%=SystemEnv.getHtmlLabelName(20085,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20081,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(20079,user.getLanguage())%>"><%=reportManager.getReportIndexStar(0)%></span><span id="scheduleIndex" style="font-weight: bold;margin-left: 8px;color: #666666">0.0</span></a><!-- 旷工 迟到 -->
						     <%} %>
					</span>
				</div>
				<%
					  String allowRequest=blogDao.getSysSetting("allowRequest");   //是否接收关注申请
					  Map count=blogDao.getReindCount(user); 
					  int remindCount=((Integer)count.get("remindCount")).intValue();           //提醒未查看数
					  int commentCount=((Integer)count.get("commentCount")).intValue();         //评论未查看
					  int updateCount=((Integer)count.get("updateCount")).intValue();           //更新总数
					  
				%>
			
				<div class="side-item menu">
				        <!-- 我的主页 --> 
					    <div class="menuItem homepage selected"  id="homepage" url="discussList.jsp?requestType=homepage&currentpage=1">
						    <span class="menuName"><span class="title"><%=SystemEnv.getHtmlLabelName(27128,user.getLanguage())%></span></span><em id="unpdateCount" class="msg-count" onclick="viewUnreadMsg('update',event)" style="display: <%=updateCount>0?"":"none"%>"><span class="count"><%=updateCount%></span></em>
						</div>
						<!-- 我的微博 -->
						<div class="menuItem myblog" id="myBlog" url="discussList.jsp?blogid=<%=userid%>&requestType=myblog">
						    <span class="menuName"><span class="title"><%=SystemEnv.getHtmlLabelName(26468,user.getLanguage())%></span></span>
						</div>
						<!-- 评论我的 -->
						<div class="menuItem commentonme"  id="comment" url="commentOnMe.jsp">
						    <span class="menuName"><span class="title"><%=SystemEnv.getHtmlLabelName(26999,user.getLanguage())%></span></span><em class="msg-count" style="display:<%=commentCount>0?"":"none"%>"><span class="count"><%=commentCount%></span></em>
						</div>
						<!-- 微博便签 -->
						<div class="menuItem notepad" id="notepad"  url="blogNotes.jsp">
						    <span class="menuName"><span class="title">微博便签</span></span>
						</div>
						<!-- 消息提醒 -->
						<div class="menuItem sysremind" id="sysremind"  url="blogRemind.jsp">
						    <span class="menuName"><span class="title"><%=SystemEnv.getHtmlLabelName(19085,user.getLanguage())%></span></span><em class="msg-count" style="display:<%=remindCount>0?"":"none"%>"><span class="count"><%=remindCount%></span></em>
						</div>
				</div>
				<%if(visitorList.size()>0){ %>
					<div class="side-item people-box">
						<div class="title">
							<img src="images/visit-icon.png" align="absmiddle" style="margin-right: 3px"><%=SystemEnv.getHtmlLabelName(26934,user.getLanguage())%><!-- 最近来访 -->
						    <span style="margin-left: 75px"><img id="prepage" onclick="visitpage('pre')" align="absmiddle" width="12px" style="cursor: pointer;" alt="上一页" src="images/pre_page_no.png">&nbsp;&nbsp;<img onclick="visitpage('next')" id="nextpage" align="absmiddle" style="cursor: pointer;" alt="下一页" width="12px" src="<%=visitTotalpage>1?"images/next_page.png":"images/next_page_no.png" %>"></span>
						</div>
						<div id="visitList" class="peoplebox-body clear">
								<ul class="people-list" style="width: 100%">
								<%for(int i=0;i<visitorList.size();i++){
									Map map=(Map)visitorList.get(i);
									String visitor=(String)map.get("userid");
									String visitdate=(String)map.get("visitdate");
									visitdate=dateFormat2.format(dateFormat1.parse(visitdate));
									String visittime=(String)map.get("visittime");
									visittime=timeFormat.format(timeFormat.parse(visittime));
								%>
									<li style="margin-right: 0px;width: 100%;height: 45px">
									
									<div style="float: left;">
									  <a  href="viewBlog.jsp?blogid=<%=visitor%>" target="_blank">
									      <img style="border: 0px;cursor: pointer;" src="<%=ResourceComInfo.getMessagerUrls(visitor)%>" width="40px">
									  </a>
									</div>
									<div style="float: left;margin-left: 5px">
									   <span class="name" style="text-align: left;height: 40px;">
									      <span style="margin-bottom:3px;text-align: left;">
									        <a  href="viewBlog.jsp?blogid=<%=visitor%>" target="_blank"><%=ResourceComInfo.getLastname(visitor) %></a>
									      </span>
									      <span style="color: #666;text-align: left;"><%=visitdate+" "+visittime%></span>
									   </span>
									</div>
								</li>
								<%}%>
							   </ul>
							
						</div>
					</div>
				<%}%>
				<%if(visitList.size()>0){%>
					<div class="side-item people-box">
						<div class="title">
							<img src="images/visit-icon.png" align="absmiddle" style="margin-right: 3px"><%=SystemEnv.getHtmlLabelName(26935,user.getLanguage())%><!-- 最近访问 -->
						    <span style="margin-left: 75px"><img id="accessprepage" onclick="accesspage('pre')" align="absmiddle" width="12px" style="cursor: pointer;" alt="上一页" src="images/pre_page_no.png">&nbsp;&nbsp;<img onclick="accesspage('next')" id="accessnextpage" align="absmiddle" style="cursor: pointer;" alt="下一页" width="12px" src="<%=accessTotalpage>1?"images/next_page.png":"images/next_page_no.png" %>"></span>
						</div>
						<div id="accessList" class="peoplebox-body clear" style="width: 195px;">
							<ul class="people-list" style="width: 100%">
								<%for(int i=0;i<visitList.size();i++){
								    Map map=(Map)visitList.get(i);
									String visitor=(String)map.get("userid");
									String visitdate=(String)map.get("visitdate");
									visitdate=dateFormat2.format(dateFormat1.parse(visitdate));
									String visittime=(String)map.get("visittime");
									visittime=timeFormat.format(timeFormat.parse(visittime));
								%>
									<li  style="margin-right: 0px;width: 100%;height: 45px">
									<div style="float: left;">
									   <a href="viewBlog.jsp?blogid=<%=visitor%>" target="_blank">
									       <img style="border: 0px;cursor: pointer;" src="<%=ResourceComInfo.getMessagerUrls(visitor) %>" width="40px">
									   </a>
									   
									</div>
									<div style="float: left;margin-left: 5px;">
									   <span class="name" style="text-align: left;height: 40px;">
									      <span style="margin-bottom:3px;text-align: left;">
									          <a href="viewBlog.jsp?blogid=<%=visitor%>" target="_blank"><%=ResourceComInfo.getLastname(visitor) %></a>
									      </span>
									      <span style="color: #666;text-align: left;"><%=visitdate+" "+visittime%></span>
									   </span>
									</div>
									
								</li>
								<%}%>
							</ul>
						</div>
					</div>
				<%} %>
			</div>
       </td>
   </tr>
</table>

<div class="clear"></div>
</div>

<iframe id="downloadFrame" style="display: none"></iframe>
<!-- 微博模版内容 -->
<div id="templatediv">
  <%=tempContent%>
</div>
<div class="editorTmp" style="display:none">
<table>
	<tr>
		<td>
		 <textarea name="submitText" scroll="none" style="border: solid 1px;"></textarea>
		</td>
	</tr>
	<tr>
		<td class="appItem_bg">
			<div style="float: left;margin-right: 10px;vertical-align: middle;" >
			    <!-- 保存 -->
				<input type="button" class="submitButton" onclick="saveContent(this)"/>
				<!-- 取消 -->
				<input type="button" class="editCancel" onclick="editCancel(this);" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
			</div>  
	   	 <%
	   	    List appVoList=appDao.getAppVoList();
	   	 	for(int i=0;i<appVoList.size();i++){
	   	 		AppVo appVo=(AppVo)appVoList.get(i);
	   	 		if("mood".equals(appVo.getAppType())){
	   	 		if(appItemVoList!=null&&appItemVoList.size()>0){ 
			   		AppItemVo appItemVo1=(AppItemVo)appItemVoList.get(0);
			   		
			   		String itemType1=appItemVo1.getType();
	  				String itemName1=appItemVo1.getItemName();
	  				if(itemType1.equals("mood"));
	  				   itemName1=SystemEnv.getHtmlLabelName(Util.getIntValue(itemName1),user.getLanguage());
			   %>
			   <!-- 心情 -->
			   <div class="optItem" style="width:90px;position: relative;">
				  <div id="mood_title" class="opt_mood_title"  onclick="show_select('mood_title','mood_items','qty_<%=appItemVo1.getType() %>','mood',event,this)">
				 	
				    <img src="<%=appItemVo1.getFaceImg() %>" width="16px" alt="<%=itemName1%>" align="absmiddle" style="margin-right:3px;margin-left:2px">
				    
				    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(26920,user.getLanguage())%></a><!-- 心情 -->
				 
				  </div>
				  <div id="mood_items" style="display:none" class="opt_items">
				  		<%
				  			for(int j=0;j<appItemVoList.size();j++) {
				  				AppItemVo appItemVo= (AppItemVo)appItemVoList.get(j);
				  				String itemType=appItemVo.getType();
				  				String itemName=appItemVo.getItemName();
				  				if(itemType.equals("mood"));
				  				   itemName=SystemEnv.getHtmlLabelName(Util.getIntValue(itemName),user.getLanguage());
				  		%>
					   		<div class='qty_items_out'  val='<%=appItemVo.getId() %>'><img src="<%=appItemVo.getFaceImg() %>" alt="<%=itemName%>" width="16px" align="absmiddle" style="margin-right:3px;margin-left:2px"><%=itemName%></div>
					   <%} %>
				  </div> 
				  <input name="qty_<%=appItemVo1.getType() %>" class="qty" type="hidden" id="qty_<%=appItemVo1.getType() %>" value="<%=appItemVo1.getId() %>" />
			   </div>
				
		   	 <%} 
	   	   }else if("attachment".equals(appVo.getAppType())){
	   	 %>
	   	    <!-- 附件 -->
	   	    <div class="optItem" style="width: 120px;position: relative;">
			  <div id="temp_title" style="width: 120px" class="opt_title" onclick="openApp(this,'')">
			   <%
			   if(attachmentDir!=null&&!attachmentDir.trim().equals("")){ 
				   String attachmentDirs[]=Util.TokenizerString2(attachmentDir,"|");
				   RecordSet recordSet=new RecordSet();
				   recordSet.executeSql("select maxUploadFileSize from DocSecCategory where id="+attachmentDirs[2]);
				   recordSet.next();
				   String maxsize = Util.null2String(recordSet.getString(1));
			   %>
			    <a href="javascript:void(0)"><div class="uploadDiv" mainId="<%=attachmentDirs[0]%>" subId="<%=attachmentDirs[1]%>" secId="<%=attachmentDirs[2]%>" maxsize="<%=maxsize%>"></div></a>
			   <%}else{ %>
			    <span style="color: red">附件上传目录未设置</span>
			   <%} %>
			  </div>
		  </div>
	   	 <%}else{ %>
			  <div class="optItem">
				  <div id="temp_title" class="opt_title" onclick="openApp(this,'<%=appVo.getAppType() %>')">
				    <img src="<%=appVo.getIconPath() %>" width="16px" align="absmiddle" style="margin-right:3px;margin-left:2px"><a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(Integer.parseInt(appVo.getName()),user.getLanguage()) %></a>
				  </div>
	
			  </div>
		  <%}} %>
		  
</td>
	</tr>
	</table>
</div>
</div>
</body>
</html>
<script>
    var tempHeight=0;      //微博模版高度
    var isUsedTemp=<%=isUsedTemp%>;  //是启用模版
    
	jQuery(function(){
		jQuery(".menuItem").click(function(obj){
		    jQuery(document.body).focus();
			jQuery(".menuItem").each(function(){
				jQuery(this).removeClass("selected");
			});
			
			jQuery(this).addClass("selected");
			var url=jQuery(this).attr("url");
			displayLoading(1,"page");
		    var menuItem=jQuery(this).attr("id");
		    
		    //未读数字提醒不用隐藏
		    if(menuItem!="homepage")
		       jQuery(this).find(".msg-count").hide();
		    
			jQuery.post(url,{},function(a){
			    
				jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
				
				if(menuItem=="notepad")
				      //初始化微博便签编辑器
				      showBlogNotes();
				else{       
					  //显示今天编辑器
					  jQuery(".editor").each(function(){
					    if(jQuery(this).css("display")=="block"){
						   showAfterSubmit(this);
						}
				      });
			    }
			   
				if(menuItem=="myBlog"){
			        jQuery("#myBlogMenu").show();
			        jQuery("#searchBtn").attr("from","myBlog");    //修改搜索来源页
			        
			        jQuery(".tabStyle2 li").each(function(){
						jQuery(this).removeClass("select2");
					});
					jQuery("#blog").addClass("select2");
			    }else{ 
			        jQuery("#searchBtn").attr("from","homepage");  //修改搜索来源页
			        jQuery("#myBlogMenu").hide();     
			     }
				
				
				if(menuItem=="myBlog"||menuItem=="homepage"||menuItem=="comment"){  
			       
			        //初始化处理图片
			        jQuery('.reportContent img').each(function(){
						initImg(this);
				    });
					//上级评分初始化
					jQuery(".blog_raty").each(function(){
					   managerScore(this);
					   jQuery(this).attr("isRaty","true"); 
					});
					
				}
				
				if(menuItem=="homepage"){
				    //initScroll();      //点击我的主页时初始化滚动加载数据 
				}    
				else 
				    removeScroll();
				      
				displayLoading(0);
			});
		});
		
		jQuery(".menuName").hover(
		  function(){
		     jQuery(this).css("text-decoration","underline");
		  },function(){
		     jQuery(this).css("text-decoration","none");
		  }
		);
		jQuery("#unpdateCount").hover(
		  function(){
		     jQuery(this).css("font-weight","bold");
		  },function(){
		     jQuery(this).css("font-weight","normal");
		  }
		);
		
		if("<%=menuItem%>"!="")
		     jQuery("#<%=menuItem%>").click();
		else
		     jQuery("#homepage").click();
		     
		notepad('.reportContent'); //微博便签选取数据        
	});
	
	//查看更新微博
	function viewUnreadMsg(msgType,event){
	   displayLoading(1,"page");
	   jQuery.post("discussList.jsp?blogid=<%=userid%>&requestType=homepageNew",function(a){
	      
	      jQuery(".menuItem").each(function(){
				jQuery(this).removeClass("selected");
		  }); 
		  jQuery("#homepage").addClass("selected");
		  jQuery("#searchBtn").attr("from","homepage");  //修改搜索来源页
	      jQuery("#myBlogMenu").hide();      
	      jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
	      
		  
		  //初始化处理图片
		  jQuery('.reportContent img').each(function(){
			  initImg(this);
		  });
		  
		  jQuery(".blog_raty").each(function(){ //上级评分初始化
		     managerScore(this);
		     jQuery(this).attr("isRaty","true"); 
		  });
		  removeScroll();
	      displayLoading(0);
	   });
	   window.event.cancelBubble = true;
	}

jQuery(document).ready(function(){
    //获取工作指数
    getIndex(<%=userid%>); 
	//隐藏所有下拉菜单
	jQuery(document.body).bind("click",function(){
		jQuery(".dropDown").hide();
		jQuery(".opt_items").hide();
	});
});

   /*滚动加载处理*/  
    var index=0;           //起始读取下标
	var hght=0;             //初始化滚动条总长
	var top=0;              //初始化滚动条的当前位置
	var preTop=0;
	var currentpage=0;       //当前页初始值
	var total=0;
	var flag=true;         //每次请求是否完成标记，避免网速过慢协作类型无法区分 成功返回数据为true
	var pagesize=0;
	
	//初始化滚动
	function initScroll(){
	      index=20;           //起始读取下标
		  hght=0;             //初始化滚动条总长
		  top=0;              //初始化滚动条的当前位置
		  preTop=0;
		  currentpage=1;       //当前页初始值
		  total=0;
		  flag=true;         //每次请求是否完成标记，避免网速过慢协作类型无法区分 成功返回数据为true
		  pagesize=20;
	     
	     //获取主页记录总数，如果index大于total则绑定滚动加载事件
	     jQuery.post("blogOperation.jsp?operation=getHomepageTotal&pagesize="+pagesize,function(data){
            total=jQuery.trim(data);
	        if(index<total){
			 jQuery("#myBlogdiv").bind("scroll",function(){
				  hght=this.scrollHeight;//得到滚动条总长，赋给hght变量
				  top=this.scrollTop;//得到滚动条当前值，赋给top变量
				  if(this.scrollTop>parseInt(this.scrollHeight/3)&&preTop<this.scrollTop)//判断滚动条当前位置是否超过总长的1/3，parseInt为取整函数,向下滚动时才加载数据
				    show();
			       preTop=this.scrollTop;//记录上一个位置
			 });
	       }		 
	     
	     });
	}
	
	//删除滚动
	function removeScroll(){
	    jQuery("#myBlogdiv").unbind("scroll");     
	}
	
	function show(){
	    if(flag){
			index=index+pagesize;
			if(index>total){                    //当读取数量大于总数时
			   //pagesize=total-(index-pagesize); 
			   index=total;                     //页面数据量等于数据总数
			   jQuery("#myBlogdiv").unbind("scroll"); 
			}
			flag=false;
			currentpage=currentpage+1;          //取下一页
			jQuery("#loadingdiv").show();  
		    jQuery.post("discussList.jsp?blogid=<%=userid%>&requestType=homepage&currentpage="+currentpage+"&pagesize="+pagesize,function(data){
				    
				    var tempdiv=jQuery("<div>"+data+"</div>");
				    //初始化处理图片
			        tempdiv.find('.reportContent img').each(function(){
						initImg(this);
				    });
				    jQuery("#reportBody").append(tempdiv);
				    


				    //上级评分处理
				    jQuery(".blog_raty").each(function(){
				       if(jQuery(this).attr("isRaty")!="true"){
					       managerScore(this);
					       jQuery(this).attr("isRaty","true"); 
					   }    
					});
				    hght=0;
				    top=0;
				    flag=true;
				    jQuery("#loadingdiv").hide();  
				    
			});
		}
	} 
/*滚动加载处理*/	
    
    //初始化我的微博菜单
	jQuery(function(){
		jQuery(".tabStyle2 li").click(function(obj){
		        jQuery(document.body).focus();
				jQuery(".tabStyle2 li").each(function(){
					jQuery(this).removeClass("select2");
				});
				jQuery(this).addClass("select2");
				var url=jQuery(this).attr("url");
				var tabid=jQuery(this).attr("id");
				displayLoading(1,"page"); 
				jQuery.post(url,{},function(a){
					jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
					//显示今天编辑器
					jQuery(".editor").each(function(){
					 if(jQuery(this).css("display")=="block"){
						 showAfterSubmit(this);
						}
				    });
					if(tabid=="blog"){
					
					    //图片初始化 
						jQuery('.reportContent img').each(function(){
						   initImg(this);
				        });
						
						//上级评分初始化
						jQuery(".blog_raty").each(function(){
						   managerScore(this);
						})
					}else if(tabid=="report"){  
					    jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
					}
					if(tabid!="report")
					   displayLoading(0);
				});
			});
	});
	
	//添加到收藏夹
    function openFavouriteBrowser(){
	   var url=window.location.href;
	   fav_uri=url.substring(url.indexOf("/blog/"),url.length)+"&";
	   fav_uri = encodeURIComponent(fav_uri,true); 
	   var fav_pagename=jQuery("title").html();
	   window.showModalDialog("/favourite/FavouriteBrowser.jsp?fav_pagename="+fav_pagename+"&fav_uri="+fav_uri+"&fav_querystring=");
    }
    //显示帮助
    function showHelp(){
       var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
       var screenWidth = window.screen.width*1;
       var screenHeight = window.screen.height*1;
       window.open(operationPage+"?pathKey=cowork/coworkview.jsp","_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
    }
    
 //提交回复时，提交等待
 function displayLoading(state,flag){
  if(state==1){
        //遮照打开
        var bgHeight=document.body.scrollHeight; 
        var bgWidth=window.parent.document.body.offsetWidth;
        jQuery("#bg").css("height",bgHeight,"width",bgWidth);
        jQuery("#bg").show();
        //alert(1);
        if(flag=="save")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>");   //正在保存，请稍等...
        else if(flag=="page")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%>");   //页面加载中，请稍候...
        else if(flag=="data")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");   //正在获取数据,请稍等...  
              
        //显示loading
	    var loadingHeight=jQuery("#loading").height();
	    var loadingWidth=jQuery("#loading").width();
	    jQuery("#loading").css({"top":'40%',"left":'30%'});
	    jQuery("#loading").show();
    }else{
        jQuery("#loading").hide();
        jQuery("#bg").hide(); //遮照关闭
    }
}
  
/*最近来访纪录*/
var visitTotal=<%=visitTotal%>;
var visitCurrentpage=<%=visitCurrentpage%>;
var visitTotalpage=<%=visitTotalpage%>;
function visitpage(pageType){
  if(pageType=="next"){
     if(visitCurrentpage==visitTotalpage)
        return ;
     visitCurrentpage=visitCurrentpage+1;
     if(visitCurrentpage==visitTotalpage){
        jQuery("#nextpage").attr("src","images/next_page_no.png"); 
     }   
     jQuery("#prepage").attr("src","images/pre_page.png");   
     jQuery.post("visitRecord.jsp?recordType=visit&total="+visitTotal+"&currentpage="+visitCurrentpage,function(data){
        data=jQuery.trim(data);
        jQuery("#visitList").html(data);
     });
  }else{
     if(visitCurrentpage==1)
        return ;
     visitCurrentpage=visitCurrentpage-1;
     if(visitCurrentpage==1){
        jQuery("#prepage").attr("src","images/pre_page_no.png"); 
     } 
     jQuery("#nextpage").attr("src","images/next_page.png");     
     jQuery.post("visitRecord.jsp?recordType=visit&total="+visitTotal+"&currentpage="+visitCurrentpage,function(data){
        data=jQuery.trim(data);
        jQuery("#visitList").html(data);
     });
  }
}  
  
/*最近来访纪录*/    

/*最近访问纪录*/
var accessTotal=<%=accessTotal%>;
var accessCurrentpage=<%=accessCurrentpage%>;
var accessTotalpage=<%=accessTotalpage%>;



function accesspage(pageType){
  if(pageType=="next"){
     if(accessCurrentpage==accessTotalpage)
        return ;
     accessCurrentpage=accessCurrentpage+1;
     if(accessCurrentpage==accessTotalpage){
        jQuery("#accessnextpage").attr("src","images/next_page_no.png"); 
     }
     jQuery("#accessprepage").attr("src","images/pre_page.png"); 
          
     jQuery.post("visitRecord.jsp?recordType=access&total="+accessTotal+"&currentpage="+accessCurrentpage,function(data){
        data=jQuery.trim(data);
        jQuery("#accessList").html(data);
     });
  }else{
     if(accessCurrentpage==1)
        return ;
     accessCurrentpage=accessCurrentpage-1;
     if(accessCurrentpage==1){
        jQuery("#accessprepage").attr("src","images/pre_page_no.png"); 
     }  
     jQuery("#accessnextpage").attr("src","images/next_page.png");    
     jQuery.post("visitRecord.jsp?recordType=access&total="+accessTotal+"&currentpage="+accessCurrentpage,function(data){
        data=jQuery.trim(data);
        jQuery("#accessList").html(data);
     });
  }
}  
  
/*最近来访纪录*/  


</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker.js"></script>

