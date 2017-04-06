<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="java.text.MessageFormat"%>
<%@page import="weaver.hrm.job.JobActivitiesComInfo"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.AppDao"%>
<%@page import="weaver.blog.AppItemVo"%>
<%@page import="weaver.blog.AppVo"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp.css" rel="stylesheet" type="text/css"> 
<link rel=stylesheet href="/css/Weaver.css" type="text/css" />
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/kindeditor/kindeditor.js"></script>
<script type="text/javascript" src="/kindeditor/kindeditor-Lang.js"></script>
<script type='text/javascript' src='js/timeline/lavalamp.min.js'></script>
<script type='text/javascript' src='js/timeline/easing.js'></script>
<script type='text/javascript' src='js/highlight/jquery.highlight.js'></script>
<link href="js/weaverImgZoom/weaverImgZoom.css" rel="stylesheet" type="text/css">
<script src="js/weaverImgZoom/weaverImgZoom.js"></script>

<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>

<script type="text/javascript" src="js/raty/js/jquery.raty.js"></script>

<!-- 微博便签 -->
<script type="text/javascript" src="/blog/js/notepad/notepad.js"></script>

<jsp:include page="blogUitl.jsp"></jsp:include>
<%

String blogid=Util.null2String(request.getParameter("blogid"));   //要查看的微博id
String userid=""+user.getUID();
BlogDao blogDao=new BlogDao();
BlogShareManager shareManager=new BlogShareManager();
int status=shareManager.viewRight(blogid,userid); //微博查看权限
AppDao appDao=new AppDao();
List appItemVoList=appDao.getAppItemVoList("mood");

Calendar calendar=Calendar.getInstance();
int currentMonth=calendar.get(Calendar.MONTH)+1;
int currentYear=calendar.get(Calendar.YEAR);

BlogReportManager reportManager=new BlogReportManager();
reportManager.setUser(user);

Date today=new Date();
Date startDateTmp=new Date();
SimpleDateFormat frm=new SimpleDateFormat("yyyy-MM-dd");
String curDate=frm.format(today);    //当前日期
startDateTmp.setDate(startDateTmp.getDate()-30);
String startDate=frm.format(startDateTmp);
String enableDate=blogDao.getSysSetting("enableDate");         //微博启用日期 
String attachmentDir=blogDao.getSysSetting("attachmentDir");   //附件上传目录
if(frm.parse(enableDate).getTime()>frm.parse(startDate).getTime()){
	startDate=enableDate;
}

List tempList=blogDao.getTemplate(""+user.getUID());
String tempContent="";
int isUsedTemp=0;
if(tempList.size()>0){
	isUsedTemp=1;
	tempContent=(String)((Map)tempList.get(0)).get("tempContent");
}
%>
<title><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())%>:<%=ResourceComInfo.getLastname(blogid)%></title>
</head>
<body> 
<%@ include file="/blog/uploader.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

 <div>
	 <DIV id=bg></DIV>
	 <div id="loading">
			<div style=" position: absolute;top: 35%;left: 25%" align="center">
			    <img src="/images/loading2.gif" style="vertical-align: middle"><label id="loadingMsg"><%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%></label>
			</div>
	 </div>
 </div>

<div id="myBlogdiv" style="width: 98%;height: 100%;margin-left:8px;">
<div class="TopTitle">
	<div class="topNav" >
		<ul>
			<li><a href="javascript:toMyBlog()"><%=SystemEnv.getHtmlLabelName(26468,user.getLanguage())%></a></li><!-- 我的微博 -->
			<li class="splite1"></li>
			<li><a href="javascript:toMyAttention()"><%=SystemEnv.getHtmlLabelName(26469,user.getLanguage())%></a></li><!-- 我的关注 -->
		</ul>
		<span style="float: right;margin-top: 5px;margin-right: 5px" >
		    <button title="<%=SystemEnv.getHtmlLabelName(18753,user.getLanguage())%>" class="btnFavorite" id="BacoAddFavorite" onclick="openFavouriteBrowser()" type="button"></button><!-- 加入收藏夹 -->
	        <button title="帮助" style="margin-left:5px" class="btnHelp" id="btnHelp" onclick="alert('帮助');" type="button"></button><!-- 帮助-->
		</span>
	</div>
 </div>	
	<div style="height:6px;padding:0;font-size:0;"></div>
   <%
  //如果status=0则不具有查看权限 status=-1 不能查看且不允许申请
   if (status>0||userid.equals(blogid)) {
 
       blogDao.addReadRecord(userid,blogid); //添加已读记录
       blogDao.addVisitRecord(userid,blogid);
       
       //删除被查看用户的更新提醒
       String sql="delete from blog_remind where remindType=6 and remindid="+userid+" and relatedid="+blogid;
	   RecordSet recordSet=new RecordSet();
	   recordSet.execute(sql);
       
   %>
	<div class="personalInfo" style="background: url('images/person-bg.png');border-left: 1px solid #D9DBE5;border-right: 1px solid #D9DBE5;">
		<div class="logo">
			<img src="<%=ResourceComInfo.getMessagerUrls(blogid) %>">
		</div>
		<div class="sortInfo" style="width:400px">
			<div class="sortInfoTop"  style="padding-top:10px">
			  <div>
			    <a href="/hrm/resource/HrmResource.jsp?id=<%=blogid%>" target="_blank" style="font-weight: bold;"><%=ResourceComInfo.getLastname(blogid) %></a>
			    <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=ResourceComInfo.getDepartmentID(blogid)%>" target="_blank" style="margin-left: 8px"><%=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(blogid)) %></a>
			  </div>
			</div>
			<div style="padding-top:8px">
			  <table width="100%">
			    <tr>
			       <td width="180px" valign="top">
					   <span style="color: #666">
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
			    </td>
			    <td>
			           <!-- 上级 -->
			           <span style="color: #666666"><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>：<a href="/hrm/resource/HrmResource.jsp?id=<%=ResourceComInfo.getManagerID(blogid)%>" target="_blank"><%=ResourceComInfo.getLastname(ResourceComInfo.getManagerID(blogid))%></a></span><br>
			           <!-- 电话 -->
			           <span style="color: #666666"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>：<%=ResourceComInfo.getTelephone(blogid)%></span><br>
			           <!-- 手机 -->
			           <span style="color: #666666"><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%>：<%=ResourceComInfo.getMobile(blogid)%></span>
			    </td>
			    </tr>
			  </table>
			   
			</div>
	    </div>
		<div class="actions" style="padding-top: 8px">
			<div style="float: right;margin-right: 15px">
				     <a class="btnEcology" id="addAttention" href="javascript:void(0)" onclick="addAttention(<%=status%>)" status="<%=status%>" style="margin-right: 8px;display: <%=status==1||status==2?"":"none"%>">
						<div class="left" style="width:68px;color: #666"><span ><span style="font-size: 13px;font-weight: bolder;margin-right: 3px">+</span><%=SystemEnv.getHtmlLabelName(26939,user.getLanguage())%></span></div><!-- 添加关注 -->
						<div class="right"> &nbsp;</div>
				     </a>
				     <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="disAttention(<%=status%>)" status="<%=status%>" style="margin-right: 8px;display: <%=status==3||status==4?"":"none"%>">
						<div class="left" style="width:68px;color: #666"><span ><span style="font-size: 13px;font-weight: bolder;margin-right: 3px">-</span><%=SystemEnv.getHtmlLabelName(24957,user.getLanguage())%></span></div><!-- 取消关注 -->
						<div class="right"> &nbsp;</div>
				     </a>
			</div>
		</div>
		<div class="clear"></div>
	</div>
	<div class="clear"></div>

	<%
	  String blogTabName=SystemEnv.getHtmlLabelName(27011,user.getLanguage());//他的微博
	  String reportTabName=SystemEnv.getHtmlLabelName(27012,user.getLanguage()); //他的报表
	  String myAttentionTabName=SystemEnv.getHtmlLabelName(27013,user.getLanguage());//他关注的
	  String attentionMeTabName=SystemEnv.getHtmlLabelName(27014,user.getLanguage()); //关注他的
	  if(userid.equals(blogid)){
		  blogTabName=SystemEnv.getHtmlLabelName(26468,user.getLanguage()); //我的微博
		  reportTabName=SystemEnv.getHtmlLabelName(18040,user.getLanguage()); //我的报表
		  myAttentionTabName=SystemEnv.getHtmlLabelName(26933,user.getLanguage());//我关注的
		  attentionMeTabName=SystemEnv.getHtmlLabelName(26940,user.getLanguage()); //关注我的
	  }else if(ResourceComInfo.getSexs(blogid).equals("1")){
		  blogTabName=SystemEnv.getHtmlLabelName(27015,user.getLanguage()); //她的微博
		  reportTabName=SystemEnv.getHtmlLabelName(27016,user.getLanguage()); //她的报表
		  myAttentionTabName=SystemEnv.getHtmlLabelName(27017,user.getLanguage());//她关注的
		  attentionMeTabName=SystemEnv.getHtmlLabelName(27018,user.getLanguage()); //她注我的
	  }
	%>
	<div class="tabStyle2">
		<UL>
			<LI id="blog" class="select2" url="discussList.jsp?blogid=<%=blogid %>&requestType=myblog"><A href="javascript:void(0)"><%=blogTabName%></A></LI>
			<LI id="report" url="myBlogReport.jsp?from=view&userid=<%=blogid%>"><A href="javascript:void(0)"><%=reportTabName%></A></LI>
			<LI url="myAttentionHrm.jsp?from=view&userid=<%=blogid%>"><A href="javascript:void(0)" ><%=myAttentionTabName%></A></LI>
			<LI url="attentionMeHrm.jsp?from=view&userid=<%=blogid%>"><A href="javascript:void(0)" ><%=attentionMeTabName%></A></LI>
		</UL>
		
	</div>
	<div id="searchDiv"  align="right" style="display: block;float: right;margin-top: 4px;border-bottom: #e4e9ed 1px solid;width: 100%;padding-bottom: 5px">
		<table  cellpadding=0 cellspacing=0>
		<tr>
			
			<td>
			     <INPUT id=startdate name=startdate type=hidden value="<%=startDate%>">
				 <INPUT id=startdate_ name=startdate_ type=hidden value="<%=startDate%>">
				 <BUTTON type="button" class=Calendar onclick="getDate('startdatespan','startdate')"></BUTTON>
				 <SPAN id="startdatespan"><%=startDate%></SPAN>
				 	<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>&nbsp;
				 <BUTTON type="button" class=Calendar onclick="getDate('enddatespan','enddate')"></BUTTON> 
				 <SPAN id=enddatespan><%=curDate%></SPAN>&nbsp;
				 <INPUT id=enddate name=enddate type=hidden value="<%=curDate%>">
				 <INPUT id=enddate_ name=enddate_ type=hidden value="<%=curDate%>">
				<span>&nbsp;</span>
			</td>
			<td align="right">
                <div class="searchBox">
                <input id="content" class="searchInput"  onkeydown="if(event.keyCode==13) jQuery('#searchBtn').click();"/>
                <div class="searchBtn" id="searchBtn" from="user" onclick="search('content','startdate','enddate',this,'<%=blogid %>');jQuery('.tabStyle2').find('.select2').each(function(){jQuery(this).removeClass('select2');jQuery('.tabStyle2 li:first').addClass('select2')});"></div>
                </div>
			</td>
		</tr>
	</table>
	</div>
	<div class="reportBody" id="reportBody" style="width: 100%">
			
	</div>
	<%}else if(status==-1){ 
		Object object[]=new Object[1];
		object[0]="<a href='/hrm/resource/HrmResource.jsp?id="+blogid+"' target='_blank' style='font-weight: bold;text-decoration: underline !important;'>"+ResourceComInfo.getLastname(blogid)+"</a>";
	    String message=MessageFormat.format(SystemEnv.getHtmlLabelName(27019,user.getLanguage()),object);
	%>
        <div style="margin-top: 40px;text-align: center;">
            <%=message%>
        </div>
    <%}else if(status==0) {
    	Object object[]=new Object[1];
		object[0]="<a href='/hrm/resource/HrmResource.jsp?id="+blogid+"' target='_blank' style='font-weight: bold;text-decoration: underline !important;'>"+ResourceComInfo.getLastname(blogid)+"</a>";
    	String message=MessageFormat.format(SystemEnv.getHtmlLabelName(27020,user.getLanguage()),object);
    %>
        <div style="margin-top: 40px;text-align: center;">
           <%=message%>
           <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="doAttention(this,<%=blogid%>,0,event);" status="apply" style="margin-right: 8px;">
				<div class="left" style="width:68px;color: #666;font-weight: normal !important;padding-left: 0px"><span id="btnLabel"><span class="apply">√</span><%=SystemEnv.getHtmlLabelName(26941,user.getLanguage())%></span></div><!-- 申请关注 -->
				<div class="right"> &nbsp;</div>
		   </a>
        </div>   
    <%} %>
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
		   <textarea name="submitText"  scroll="none" style="border: solid 1px;"></textarea>
		</td>
	</tr>
	<tr>
		<td class="appItem_bg">
			<div style="float: left;margin-right: 10px;">
				<!-- 保存 -->
				<input type="button" class="submitButton" onclick="saveContent(this)"/>
				<!-- 取消 -->
				<input type="button" class="editCancel" onclick="editCancel(this);" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
			</div>  
	   	 <%
	   	   List appVoList=appDao.getAppVoList();
	   	 	Iterator appVoListIter=appVoList.iterator();
	   	 	while(appVoListIter.hasNext()){
	   	 		AppVo appVo=(AppVo)appVoListIter.next();
	   	 		if("mood".equals(appVo.getAppType())){
	   	 		if(appItemVoList!=null&&appItemVoList.size()>0){ 
			   		Iterator itr=appItemVoList.iterator();
			   		AppItemVo appItemVo1=(AppItemVo)appItemVoList.get(0);
			   		String itemType1=appItemVo1.getType();
			   		String itemName1=appItemVo1.getItemName();
			   		if(itemType1.equals("mood"))
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
				  			while(itr.hasNext()) {
				  				AppItemVo appItemVo= (AppItemVo)itr.next();
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
</body>
</html>
<script>

    var tempHeight=0;      //微博模版高度
    var isUsedTemp=<%=isUsedTemp%>;  //是启用模版

    //跳转到我的微博
	function toMyBlog(){
	   if(jQuery(window.parent.document).find("#blogList").is(":hidden"))
	      window.location.href='myBlog.jsp'; 
	   else
	      window.parent.location.href='blogView.jsp';   
	}
    
    //跳转到我的关注
    function toMyAttention(){
       if(jQuery(window.parent.document).find("#blogList").is(":hidden"))
          window.parent.location.href='blogView.jsp?item=attention';
	   else
	      window.location.href='myAttention.jsp'; 
    }
function requestAttention(obj,attentionid){
    if(jQuery(obj).attr("isApply")!="true"){
      jQuery.post("blogOperation.jsp?operation=requestAttention&attentionid="+attentionid,function(){
         jQuery(obj).find("#btnLabel").html("<span class='apply'>√</span><%=SystemEnv.getHtmlLabelName(18659,user.getLanguage())%>");
         jQuery(obj).attr("isApply","true");
         alert("<%=SystemEnv.getHtmlLabelName(27084,user.getLanguage())%>");//申请已经发送
      });
     }else{
         alert("<%=SystemEnv.getHtmlLabelName(27084,user.getLanguage())%>");//申请已经发送
     }  
   } 

function disAttention(status){
    var itemName="<%=ResourceComInfo.getLastname(blogid)%>";
    var islower=0;
	if(status==4||status==2) islower=1;
	jQuery.post("blogOperation.jsp?operation=cancelAttention&islower="+islower+"&attentionid=<%=blogid%>");
	jQuery("#cancelAttention").hide();
	jQuery("#addAttention").show();    
}

function addAttention(status){
    var itemName="<%=ResourceComInfo.getLastname(blogid)%>";
    var islower=0;
    if(status==4||status==2) islower=1;
	jQuery.post("blogOperation.jsp?operation=addAttention&islower="+islower+"&attentionid=<%=blogid%>");
	jQuery("#cancelAttention").show();
	jQuery("#addAttention").hide();     
}


function requestAttention(obj,attentionid,attentionName,islower){
	 jQuery.post("blogOperation.jsp?operation=requestAttention&islower="+islower+"&attentionid="+attentionid,function(){
	   alert("<%=SystemEnv.getHtmlLabelName(27084,user.getLanguage())%>"); //申请已经发送
	 });
}
    
jQuery(function(){
	jQuery(".tabStyle2 li").click(function(obj){
			jQuery(".tabStyle2 li").each(function(){
				jQuery(this).removeClass("select2");
			});
			jQuery(this).addClass("select2");
			var url=jQuery(this).attr("url");
			var tabid=jQuery(this).attr("id");
			
			if(tabid=="blog")
			   jQuery("#searchDiv").show();
			else
			   jQuery("#searchDiv").hide();   
			
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
				    //图片缩小处理   
					jQuery('.reportContent img').each(function(){
					    initImg(this);
					});
					
					//上级评分初始化
					jQuery(".blog_raty").each(function(){
					   if(jQuery(this).attr("isRaty")!="true"){
					       managerScore(this);
					       jQuery(this).attr("isRaty","true"); 
			           }
					})
				}else if(tabid=="report"){  
				    jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
				}
				displayLoading(0);
			});
		});
		window.parent.displayLoading(0);
		if(<%=status%>>0||<%=userid%>==<%=blogid%>){
		    displayLoading(1,"page"); 
		    jQuery(".tabStyle2 li:first").click();
		    getIndex(<%=blogid%>); 
		}
		jQuery(document.body).bind("click",function(){
			jQuery(".dropDown").hide();
			jQuery(".opt_items").hide();
	    });
	    
	    notepad('.reportContent'); //微博便签选取数据
});
function openApp(obj,type){
	   var editorId=jQuery(obj).parents(".editor").find("textarea[name=submitText]").attr("id");
	   var htmlstr="";
	   if(type=='doc')
	      htmlstr=onShowDoc();
	   else if(type=='project')   
	      htmlstr=onShowProject();
	   else if(type=='task')   
	      htmlstr=onShowTask();
	   else if(type=='crm')   
	      htmlstr=onShowCRM();
	   else if(type=='workflow')   
	      htmlstr=onShowRequest();
	         
	   KE.insertHtml(editorId,htmlstr);
	} 
   //添加到收藏夹
    function openFavouriteBrowser(){
	   var url=window.location.href;
	   fav_uri=url.substring(url.indexOf("/blog/"),url.length)+"&";
	   fav_uri = encodeURIComponent(fav_uri,true); 
	   var fav_pagename=jQuery("title").html();
	   window.showModalDialog("/favourite/FavouriteBrowser.jsp?fav_pagename="+fav_pagename+"&fav_uri="+fav_uri+"&fav_querystring=");
    }	
</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker.js"></script>

