<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %> 
<%@ page import="java.io.*" %>
<%@ page import="weaver.file.FileUpload" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<jsp:useBean id="settingComInfo" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" />
<%
	int userid=user.getUID();//用户id
	FileUpload fu = new FileUpload(request);
	int id=Util.getIntValue(fu.getParameter("id"),0);  //协作id
	String needfresh = Util.fromScreen(fu.getParameter("needfresh"),user.getLanguage());//刷新左侧列表变量 1 刷新
	String from = Util.null2String(fu.getParameter("from"));
	if(id==0){ //如果id=0跳转到新建页面
		response.sendRedirect("/cowork/welcome.jsp?from="+from+"&needfresh="+needfresh);
		return;
	}
	
	boolean canView = false;    //是否具有查看权限
	boolean canEdit = false;    //是否具有编辑权限
	
	canView=CoworkShareManager.isCanView(""+id,""+userid,"all");
	canEdit=CoworkShareManager.isCanEdit(""+id,""+userid,"all");
	
	//如果不具有查看权限则跳转到无权限页面
	if (id>0&&!canView) {
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}
	
	int docid=Util.getIntValue(Util.null2String(fu.getParameter("docid")),0);//TD5067，从协作区创建文档返回的文档ID
	String maintypeid = Util.null2String(fu.getParameter("maintypeid"));
	int type=Util.getIntValue(fu.getParameter("type"),0);
	int viewall=Util.getIntValue(fu.getParameter("viewall"),0);//是否查看部分讨论记录，0：否,1：是
	int isworkflow = Util.getIntValue(Util.null2String(fu.getParameter("isworkflow")),0);
	int isreward = Util.getIntValue(Util.null2String(fu.getParameter("isreward")),0);
	
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0：非政务系统。2：政务系统。
	String view = (String)fu.getParameter("view");
	
	if(isworkflow==1&&id!=0){	
		response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+id);
		return;
	}
	String isCoworkHead=settingComInfo.getIsCoworkHead(settingComInfo.getId(""+userid));
	
	CoworkDAO dao = new CoworkDAO(id);
	CoworkItemsVO vo = dao.getCoworkItemsVO();
	String name = Util.null2String(vo.getName());                 //协作名称
	String levelvalue = Util.null2String(vo.getLevelvalue());     //等级
	String typeid=Util.null2String(vo.getTypeid());               //所属协作区
	String begindate = Util.null2String(vo.getBegindate());       //开始日期
	String beingtime = Util.null2String(vo.getBeingtime());       //开始时间      
	String enddate = Util.null2String(vo.getEnddate());           //结束日期
	String endtime = Util.null2String(vo.getEndtime());           //结束时间
	String remark = Util.null2String(vo.getRemark()).trim();             //详细描述

	String creater = Util.null2String(vo.getCreater());           //协作创建人
	String status = Util.null2String(vo.getStatus());             //协作状态
	String createdate2 = Util.null2String(vo.getCreatedate());    //创建日期
	String createtime2 = Util.null2String(vo.getCreatetime());    //创建时间
	String principal=Util.null2String(vo.getPrincipal());         //协作负责人 
	String coworkid2=vo.getId();                                  //协作id
	
	String logintype = user.getLogintype();                       //登陆类型
	
	//添加查看者记录
    String sql="select id from cowork_read where coworkid="+id+" and userid="+userid;
	RecordSet.execute(sql);  
	if(!RecordSet.next()){
		sql="insert into cowork_read(coworkid,userid) values("+id+","+userid+")";
		RecordSet.execute(sql);
    }

	//添加查看日志
	dao.addCoworkLog(id,2,userid,fu);
	
	boolean isImportant=false;
	boolean isHidden=false;
	
    RecordSet.execute("select id from cowork_important where coworkid="+id+" and userid="+userid);
    if(RecordSet.next())
    	isImportant=true;
    RecordSet.execute("select id from cowork_hidden where coworkid="+id+" and userid="+userid);
    if(RecordSet.next())
    	isHidden=true;
	
	int pagesize = 10;//讨论交流每页显示条数
	int currentpage =1;
	
	BlogDao blogDao=new BlogDao();
	String isOpenBlog=blogDao.getBlogStatus(); //是否启用微博模块
%>
<html>
<head>
<title><%=name%></title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<!-- alt+g 查找 -->
<script  type="text/javascript">var isCurrentPop=true;//zdialog是否在当前页面弹出</script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>
<!-- 图片缩略 -->
<link href="/blog/js/weaverImgZoom/weaverImgZoom.css" rel="stylesheet" type="text/css">
<script src="/blog/js/weaverImgZoom/weaverImgZoom.js"></script>

<link rel="stylesheet" href="/cowork/css/cowork.css" type="text/css" />
<link rel=stylesheet href="/css/Weaver.css" type="text/css" />
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/cowork/js/scrollTop.js"></script>
<script type="text/javascript" src="js/cowork.js"></script>
<script language=javascript src="/js/weaver.js"></script>
<script type="text/javascript" src="/kindeditor/kindeditor.js"></script>
<script type="text/javascript" src="/kindeditor/kindeditor-Lang.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<%
  if(isOpenBlog.equals("1")){
%>
<!-- 微博便签 -->
<script type="text/javascript" src="/blog/js/notepad/notepad.js"></script>
<%} %>
<%@ include file="/cowork/uploader.jsp" %>
</head>
<script  type="text/javascript">
jQuery(document).ready(function(){
  displayLoading(1,"page");
  jQuery.post("/cowork/DiscussRecord.jsp?type=1&id=<%=id%>&currentpage=<%=currentpage%>",{},function(data){
          var tempdiv=jQuery("<div>"+data+"</div>");
          tempdiv.find('.discuss_content img').each(function(){
		  		initImg(this);
		  });
		  tempdiv.find('.discuss_replayContent img').each(function(){
		        initImg(this);
          });
          jQuery("#discusses").append(tempdiv);
          //为留言添加背景颜色
		  addBackGround();
		  displayLoading(0);
		  resizeImg(); 
  }); 
  
   remarkActive();
  
   //绑定附件上传
   if(jQuery("#uploadDiv").length>0)
     bindUploaderDiv(jQuery("#uploadDiv"),"relatedacc");
   
   //绑定收缩下拉框事件
   if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
    }
    
    if(<%=docid%>!=0)
      external('external');
    
    notepad('.discuss_content'); //微博便签选取数据
});

function resizeImg(){
   jQuery(".discuss_content img").each(function(){
        if(jQuery(this).width()>document.body.clientWidth*0.8)
             jQuery(this).width(document.body.clientWidth*0.8);
        //var srcstr=jQuery(this).attr("src");   
        //var imgLink=jQuery("<a href="+srcstr+" target='_blank'></a>"); 
        //jQuery(this).css({"border":"0px"}).attr("alt","<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage())+SystemEnv.getHtmlLabelName(367,user.getLanguage())%>").after(imgLink).appendTo(imgLink); 
   });

   jQuery(".discuss_replayContent img").each(function(){
        if(jQuery(this).width()>document.body.clientWidth*0.6)
             jQuery(this).width(document.body.clientWidth*0.6);
        //var srcstr=jQuery(this).attr("src");   
        //var imgLink=jQuery("<a href="+srcstr+" target='_blank'></a>");
        //jQuery(this).attr("alt","<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage())+SystemEnv.getHtmlLabelName(367,user.getLanguage())%>").after(imgLink).appendTo(imgLink); 
   });
}

 window.onbeforeunload=function (event){
    if(jQuery.trim(jQuery("#remarkContent").val())!=""||(jQuery("#relateddoc").val()!=''&&jQuery("#relateddoc").val()!='0')||jQuery("#relatedcus").val()!=''
 	  ||jQuery("#relatedwf").val()!=''||jQuery("#relatedprj").val()!=''||jQuery("#projectIDs").val()!=''||document.all("relatedacc").value!='')
 	  
      return "<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
    
    //编辑状态下 
    if(jQuery("#editdiv").length!=0)
      return "<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";  
 }


//为留言添加背景颜色
function addBackGround(){
   jQuery(".discuss_div").each(function(){
		     jQuery(this).bind("mouseover",function(){
		          jQuery(this).css("background-color","#f5fafa");
		     }).bind("mouseout",function(){
		          //如果回复框显示则不还原颜色
		          if(jQuery(this).find(".replaydiv").is(":hidden"))
		             jQuery(this).css("background-color","#FFFFFF");
		     });
  });
}


/*tab切换*/
function changeMainTab(id){
  if(jQuery("#"+id).hasClass("active_tab"))
     return false; 
  
  var activeTab=jQuery("#mainTab .active_tab");
  var activeTabId=activeTab.attr("id");
  
  activeTab.removeClass("active_tab");
  jQuery("#"+activeTabId+"_tab").hide();
  
  jQuery("#"+id).addClass("active_tab");
  jQuery("#"+id+"_tab").show(); 
  
  if(id=="cowork_join"&&jQuery("#cowork_join_tab").html()==""){
     jQuery.post("/cowork/CoworkShareManager.jsp?from=view&id=<%=id%>",{},function(data){
        jQuery("#cowork_join_tab").html(data);
        window.setTimeout(function(){
          jQuery("#weavertabs-condition").show();
        },1000);
        
     });
  }
  if(id=="cowork_resource"&&jQuery("#relate_doc_div").html()==""){
    jQuery("#relate_doc_div").load("/cowork/ViewCoWorkDiscussData.jsp?id=<%=id%>&type=2");
  }
}

/*文本输入自动调整高度*/
function autoHeight(obj,height){
  if(obj.scrollHeight>height)
    obj.style.posHeight=obj.scrollHeight
}

/*附加功能*/
function external(externalid){
   if(jQuery("#"+externalid).is(":visible")){
      jQuery("#"+externalid).hide();
      jQuery("#"+externalid+"_img").attr("src","/cowork/images/edit_down.gif");
   }else{
      jQuery("#"+externalid).show();
      jQuery("#"+externalid+"_img").attr("src","/cowork/images/edit_up.gif");
   }
}


/*高级编辑器*/
function highEditor(remarkid){
    if(jQuery("#"+remarkid).is(":visible")){
		
		var items;
		if(remarkid=="remarkContent")
		  items=[
						'source','fullscreen','plainpaste', 'wordpaste','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 
						'title', 'fontname', 'fontsize',  'textcolor', 'bgcolor', 'bold',
						'italic', 'underline', 'strikethrough', 'image', 'advtable', 'hr', 'emoticons', 'link', 'unlink'
				 ];
		else
		  items=[
						'source','plainpaste','wordpaste','justifyleft', 'justifycenter', 'justifyright','insertorderedlist', 'insertunorderedlist', 
						'title', 'fontname', 'fontsize',  'textcolor', 'bgcolor', 'bold',
						'italic', 'underline', 'strikethrough', 'image', 'advtable', 'hr', 'emoticons', 'link', 'unlink'
				 ];		 
	    KE.init({
					id : remarkid,
					height : '100px',
					width:'100%',
					resizeMode:1,
					imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
				    allowFileManager : false,
	                newlineTag:'br',
	                items : items,
				    afterCreate : function(id) {
						KE.util.focus(id);
				    }
	   });
	   KE.create(remarkid);
	   if(remarkid=="remarkContent"){
	     jQuery("#highEditorImg").attr("src","/cowork/images/normal_edit.png");  
	   }  
	}
}
function remarkActive(){
   highEditor('remarkContent');
}

/*文本输入自动调整高度*/
function replayAutoHeight(obj){
  if(obj.scrollHeight>35)
    obj.style.posHeight=obj.scrollHeight
}

/*显示回复框*/
var preReplayid="";
function showReplay(discussid,floorNum){
   if(preReplayid=="")
      preReplayid=discussid;
   if(preReplayid!=discussid){
      if(KE.text("replay_content_"+preReplayid)!=""){
	      if(confirm("<%=SystemEnv.getHtmlLabelName(25406,user.getLanguage())%>")){
		        cancelReplay(preReplayid);
		        jQuery("#discuss_table_"+preReplayid).css("background-color","#FFFFFF");
		        preReplayid=discussid;
	      }else
	            return ;
      }else{
	        cancelReplay(preReplayid);
	        jQuery("#discuss_table_"+preReplayid).css("background-color","#FFFFFF");
	        preReplayid=discussid;
	  }    
   }      
   jQuery("#replay_"+discussid).show();
   //jQuery("#replay_content_"+discussid).focus();
   highEditor("replay_content_"+discussid);
   KE.focus("replay_content_"+discussid);
   jQuery("#replayid").val(discussid);  //被回复的留言
   jQuery("#floorNum").val(floorNum);   //被回复留言的楼层 
}
/*隐藏回复框*/
function cancelReplay(discussid){
   
   KE.text("replay_content_"+discussid,"");
   KE.remove("replay_content_"+discussid);
   jQuery("#replay_"+discussid).hide();
   //jQuery("#replay_content_"+discussid).val("");
   //jQuery("#replay_content_"+discussid)[0].style.posHeight="35";
   jQuery("#replayid").val(0);
   jQuery("#floorNum").val(0);
   preReplayid="";
}  

//提交回复时，提交等待
function displayLoading(state,flag){
  if(state==1){
        //遮照打开
        var bgHeight=document.body.scrollHeight; 
        var bgWidth=window.parent.document.body.offsetWidth;
        jQuery("#bg").css("height",bgHeight,"width",bgWidth);
        jQuery("#bg").show();
        
        if(flag=="save")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>");
        else if(flag=="page"||flag=="edit")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(20010,user.getLanguage())%>");
              
        //显示loading
	    var loadingHeight=jQuery("#loading").height();
	    var loadingWidth=jQuery("#loading").width();
	    jQuery("#loading").css({"top":document.body.scrollTop + document.body.clientHeight/2 - loadingHeight/2,"left":document.body.scrollLeft + document.body.clientWidth/2 - loadingWidth/2});
	    jQuery("#loading").show();
    }else{
        jQuery("#loading").hide();
        jQuery("#bg").hide(); //遮照关闭
    }
}

//查询
function getSearchStr(){
	 var srchcontent=jQuery("#srchcontent").val();
	 var startdate=jQuery("#startdate").val();
	 var enddate=jQuery("#enddate").val();
	 var discussant = jQuery("#discussant").val();
	 var srchFloorNum=jQuery("#srchFloorNum").val();
	 if(srchFloorNum!=""){
	    if(srchFloorNum!=parseInt(srchFloorNum)|| srchFloorNum <=0) {
              alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>");  //请输入整数
              jQuery("#srchFloorNum").val(""); //置空
              jQuery("#srchFloorNum").focus();
 		      return ;
 		}
	 }
	 var isReplay="";
	 if(jQuery("#isReplay").attr("checked")){
	    isReplay="1";
	 }
	 if(startdate!=""&&enddate!=""&& startdate>enddate){
		 alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
		 return ;
	 }
     var paramStr="&srchcontent="+srchcontent+"&startdate="+startdate+"&enddate="+enddate+"&discussant="+discussant+"&srchFloorNum="+srchFloorNum+"&isReplay="+isReplay;
     return paramStr;
 }
 
 //清除搜索条件
 function clearSearch(){
   jQuery("#srchcontent").val("");
   jQuery("#startdate").val("");
   jQuery("#startdatespan").html("");
   jQuery("#enddatespan").html("");
   
   jQuery("#enddate").val("");
   jQuery("#discussant").val("");
   jQuery("#discussantspan").html("");
   jQuery("#srchFloorNum").val("");
}

 /*提交回复*/
 function doSave(remarkid){
     
     if(remarkid==undefined)
        remarkid='remarkContent';
       
     if(remarkid=='remarkContent'){
        jQuery("#replayid").val(0);  //被回复的留言
        jQuery("#floorNum").val(0);   //被回复留言的楼层 
     }
     //过滤编辑内容中可能包含的input button
     jQuery(KE.g[remarkid].iframeDoc.body).find("button").remove();
     jQuery(KE.g[remarkid].iframeDoc.body).find("input").remove();
     //获取内容中图片大小
	 jQuery(KE.g[remarkid].iframeDoc.body).find("img").each(function(){
	   var imgWidth=jQuery(this).width();
	   jQuery(this).attr("imgWidth",imgWidth);
	 });
        
     var remark=jQuery("#"+remarkid);
     remarkValue=KE.html(remarkid);
     
     if(remarkValue==""){
        alert("<%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18546,user.getLanguage())%>");
        if(remark.is(":visible"))
           remark.focus();
        else
           KE.util.focus(remarkid);   
        return;   
     }else{
       jQuery("#btnSubmit").attr("disabled","disabled"); //提交时禁用提交按钮 避免重复提交
       jQuery(".replayBtn").attr("disabled","disabled"); //提交时禁用回复按钮 避免重复提交 
       
       if(remark.is(":visible")) //如果可见则为文本模式  否则为html模式
          remarkValue = remarkValue.replace(/\n/g,"<br/>");     //替换换行\n
       else{
         remarkValue = remarkValue.replace(/\n/g,"");     //替换换行\n
         remarkValue = remarkValue.replace(/\r/g,"");     //替换单行\r
       }
       
       remarkValue = remarkValue.replace(/\\/g,"\\\\"); //替换斜杠
       remarkValue = remarkValue.replace(/'/g,"\\'");   //转义单引号
       
       jQuery("#remark").val(remarkValue);
     }
     
     jQuery(document.body).focus();
     
     var oUploader=null;
     if(remarkid=="discussContent"){
        jQuery("#method").val("editdiscuss"); //编辑评论
        oUploader=window[jQuery("#edit_uploadDiv").attr("oUploaderIndex")];   
     }
     else{
        jQuery("#method").val("doremark");    //发表意见
        oUploader=window[jQuery("#uploadDiv").attr("oUploaderIndex")];        
     }
     displayLoading(1,"save");  //提交等待显示
     
     try{
       if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
         doSaveAfterAccUpload();  //提交回复
       else 
     	 oUploader.startUpload();
	 }catch(e) {
	     doSaveAfterAccUpload(); //提交回复
	  }
 }

 function   doSaveAfterAccUpload(){
     //提交参数
     var param="{";
     jQuery("#frmmain").find("input[type='hidden']").each(function(){
        var element=jQuery(this);
        param=param+element.attr("name")+":'"+element.val()+"',"
     });
     param=param.substr(0,param.length-1)+"}";
     var method=jQuery("#method").val();
     
     //回复评论
     if(method=="doremark"){ 
        jQuery.post("CoworkOperation.jsp", eval('('+param+')'),function(data){
              displayLoading(0);  //提交等待显示
              if(jQuery("#replayid").val()=="0")
                 clearRemark();      
	 	      toPage(1); //加载第一页内容
	 	      jQuery("#btnSubmit").attr("disabled","");//恢复提交按钮
	 	      jQuery(".replayBtn").attr("disabled",""); //恢复回复按钮
         });
     }else if(method=="editdiscuss"){ //编辑评论
         jQuery.post("CoworkOperation.jsp", eval('('+param+')'),function(data){
		          displayLoading(0);  //提交等待显示
		          
		          if(jQuery.trim(data)=="1"||jQuery.trim(data)=="2"){ //首先进行是否超过时间判断
			        displayLoading(0); 
			        if(jQuery.trim(data)=="1"){
			           alert("<%=SystemEnv.getHtmlLabelName(26229 ,user.getLanguage())%>");  //协作有最新回复
			        }   
			        else
			           alert("<%=SystemEnv.getHtmlLabelName(25408,user.getLanguage())%>");  //回复时间已经超过10分钟
			        jQuery(".operationTimeOut").hide();
			      }
		          
	 	          toPage(1); //加载第一页内容
	 	          jQuery("#btnSubmit").attr("disabled","");//恢复提交按钮
	 	          jQuery(".replayBtn").attr("disabled",""); //恢复回复按钮
              });
          jQuery("#method").val("doremark"); //恢复method值
     }
     
 }

//分页
function toPage(pageNum){
  var  searchStr=getSearchStr();
  url="/cowork/DiscussRecord.jsp?type=1&id=<%=id%>&currentpage="+pageNum+searchStr;
  displayLoading(1,"page");
  jQuery.post(url,{},function(data){
     var tempdiv=jQuery("<div>"+data+"</div>");
     tempdiv.find('.discuss_content img').each(function(){
		  initImg(this);
     }); 
     tempdiv.find('.discuss_replayContent img').each(function(){
		  initImg(this);
     }); 
     
     jQuery("#discusses").html("");
     jQuery("#discusses").append(tempdiv);
     addBackGround();
     displayLoading(0);
     jQuery("#top").focus();
	 preReplayid="";
	 resizeImg();
	 
  });
}

//转到
function toGoPage(totalpage,topage){
 	    var topagenum=jQuery("#"+topage);
 		var topage =topagenum.val();
 		if(topage <0 || topage!=parseInt(topage) ) {
              alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>");  //请输入整数
              topagenum.val(""); //置空
              topagenum.focus();
 		      return ;
 		 }
 		if(topage>totalpage) topage=totalpage; //大于最大页数
 		if(topage==0) topage=1;                //小于最小页数 
 		toPage(topage);
}

//是否为高级编辑器模式
function isHighEditor(){
  return jQuery("#remarkContent").is(":hidden");
}

//删除讨论
 function deleteDiscuss(discussid){
   if(window.confirm("<%=SystemEnv.getHtmlLabelName(25405,user.getLanguage())%>")){ //确认要删除该讨论记录
      jQuery.post("CoworkOperation.jsp?method=delete&id=<%=id%>&discussid="+discussid,{},function(data){
         if(jQuery.trim(data)=="0"){
             toPage(1);
	     }else if(jQuery.trim(data)=="1"){
	         alert("<%=SystemEnv.getHtmlLabelName(26229,user.getLanguage())%>");
	         toPage(1);
	         jQuery(".operationTimeOut").hide();
	      }else if(jQuery.trim(data)=="2"){   
	         alert("<%=SystemEnv.getHtmlLabelName(25408,user.getLanguage())%>");
             jQuery(".operationTimeOut").hide();
          }
      });
	 }      
 }
 
  //编辑讨论
 function editDiscuss(discussid,replayid){
 
   if(jQuery("#replay_"+discussid).is(":visible")){
      alert("<%=SystemEnv.getHtmlLabelName(25404,user.getLanguage())%>");
      return ;
    }  
   displayLoading(1,"edit");
   jQuery.post("discussOperation.jsp?operation=edit",{discussid:discussid,typeid:<%=typeid%>,isgoveproj:<%=isgoveproj%>},function(data){
      if(jQuery.trim(data)=="1"||jQuery.trim(data)=="2"){ //首先进行是否超过时间判断
        displayLoading(0); 
        if(jQuery.trim(data)=="1"){
           alert("<%=SystemEnv.getHtmlLabelName(26229 ,user.getLanguage())%>");  //协作有最新回复
           toPage(1);
        }   
        else
           alert("<%=SystemEnv.getHtmlLabelName(25408,user.getLanguage())%>");  //回复时间已经超过10分钟
        jQuery(".operationTimeOut").hide();
        return ;
      }else{ 
        jQuery("#discuss_table_"+discussid).hide();
       
	    jQuery("#discuss_div_"+discussid).append(data);
	    if(jQuery("#edit_uploadDiv").length>0)
	       bindUploaderDiv(jQuery("#edit_uploadDiv"),"newrelatedacc");
	    highEditor('discussContent');
	    displayLoading(0);
      }
   });
 }
 
//取消编辑 
 function cancelEdit(discussid){
    jQuery(document.body).focus(); //避免删除div时 页面焦点丢失
    jQuery("#editdiv").remove();
    jQuery("#discuss_table_"+discussid).show();
 }

//附件删除
function onDeleteAcc(delspan,delid){
	 var delrelatedacc=jQuery("#delrelatedacc").val();
	 var relatedacc=jQuery("#edit_relatedacc").val();
	 relatedacc=","+relatedacc;
	 delrelatedacc=","+delrelatedacc;
	 if(jQuery("#"+delspan).is(":hidden")){
		delrelatedacc=delrelatedacc+delid+",";
		var index=relatedacc.indexOf(","+delid+",");
		relatedacc=relatedacc.substr(0,index+1)+relatedacc.substr(index+delid.length+2);
		jQuery("#"+delspan).show();    
	 }else{
		var index=delrelatedacc.indexOf(","+delid+",");
		delrelatedacc=delrelatedacc.substr(0,index+1)+delrelatedacc.substr(index+delid.length+2);
						         
		relatedacc=relatedacc+delid+",";
						         
		jQuery("#"+delspan).hide(); 
	}
		jQuery("#edit_relatedacc").val(relatedacc.substr(1,relatedacc.length));
		jQuery("#delrelatedacc").val(delrelatedacc.substr(1,delrelatedacc.length));
} 

function clearRemark(){
        //隐藏附加功能
        jQuery("#external").hide();
        //相关文档
 	    jQuery("#relateddoc").val("");    
 		jQuery("#relateddocsspan").html("");
 		//相关客户	    
 		jQuery("#relatedcus").val("");
 		jQuery("#crmspan").html("");
 		//相关流程	    
 		jQuery("#relatedwf").val("");
 		jQuery("#relatedrequestspan").html("");
 		//相关项目	    
 		jQuery("#projectIDs").val("");
 		jQuery("#mutilprojectSpan").html("");
 		//相关项目任务	    
 		jQuery("#relatedprj").val("");
 		jQuery("#projectspan").html("");
 		//还原被回复人id
		jQuery("#replayid").val(0);
 		//相关附件
 		if(jQuery("#uploadDiv").length>0)
 		   bindUploaderDiv(jQuery("#uploadDiv"),"relatedacc"); //重新附件上传绑定
 		
 		//还原编辑框
 		KE.text("remarkContent","");
 		KE.create("remarkContent");
}

//新建协作
function addCowork(){
	if("<%=from%>"=="cowork")
		jQuery(window.parent.document).find("#ifmCoworkItemContent").attr("src","/cowork/AddCoWork.jsp?from=<%=from%>&typeid=<%=typeid%>");
	else
        window.location.href="/cowork/AddCoWork.jsp?from=<%=from%>&typeid=<%=typeid%>";
    
}

//编辑协作
function editCowork(){
	if("<%=from%>"=="cowork")
	 jQuery(window.parent.document).find("#ifmCoworkItemContent").attr("src","/cowork/EditCoWork.jsp?from=<%=from%>&id=<%=id%>");
	else
     window.location.href="/cowork/EditCoWork.jsp?from=<%=from%>&id=<%=id%>";
    
}
  
//跳转到查询协作
function toSearch(){
	if("<%=from%>"=="cowork")
		 jQuery(window.parent.document).find("#ifmCoworkItemContent").attr("src","/cowork/SearchCowork.jsp");
	else
         window.location.href="/cowork/SearchCowork.jsp"; 
   
}

/*结束协作*/
 function doEnd(){
 	if(confirm("<%=SystemEnv.getHtmlLabelName(18899,user.getLanguage())%>")) {
      if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined)
         window.parent.reloadItemListContent();
      frmmain.method.value="end";
 	  document.frmmain.submit();
 	}
 }
 /*打开协作*/
 function doOpen(){
 	if(confirm("<%=SystemEnv.getHtmlLabelName(18900,user.getLanguage())%>")) {
    		if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined)
                window.parent.reloadItemListContent();
			frmmain.method.value="open";
 		    document.frmmain.submit();
 	}
 }
 /*添加到日程安排*/
 function doAdd(){

   if(window.confirm("<%=SystemEnv.getHtmlLabelName(16634,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17698,user.getLanguage())%>?")){ //确认添加日程
      jQuery.post("CoworkOperation.jsp?method=addtoplan&id=<%=id%>",function(data){
          alert("<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>");//日程添加成功
      });
      }
   else      
      return ;
 }

 /*导出协作*/
 function doexport(){
     window.openFullWindowHaveBar("/docs/docs/DocList.jsp?coworkid=<%=id%>&isExpDiscussion=y");
 }
 
 /*协作参与情况tab切换*/
function changeJoinTab(id,target){
  if(jQuery("#"+id).hasClass("active_tab"))
     return false; 
     
  var activeTab=jQuery("#cowork_join_tab .active_tab");
  var activeTabId=activeTab.attr("id");   
  activeTab.removeClass("active_tab");
  
  jQuery("#weavertabs-"+activeTabId).hide();
  
  jQuery("#"+id).addClass("active_tab");
  jQuery("#weavertabs-"+id).show();  
}

/*相关资源tab切换*/
function changeRelatedTab(id,type){
  var resourceUrl="/cowork/ViewCoWorkDiscussData.jsp?id=<%=id%>&type="+type;
  if(jQuery("#"+id).hasClass("active_tab"))
     return false; 
     
  var activeTab=jQuery("#cowork_resource_tab .active_tab");
  var activeTabId=activeTab.attr("id");   
     
  activeTab.removeClass("active_tab");
  jQuery("#"+activeTabId+"_div").hide();
  
  jQuery("#"+id).addClass("active_tab");
  jQuery("#"+id+"_div").show();  
    
  if(jQuery("#"+id+"_div").html()=="")
    jQuery.post(resourceUrl,{},function(data){
       jQuery("#"+id+"_div").html(data);
    });  
  
}

function showDetail(type){
  if(type=="all"){
     jQuery("#showAll").show();
     jQuery("#showPart").hide();
	 jQuery("#table1 tr[detail]").toggle();
  }else{
     jQuery("#showAll").hide();
     jQuery("#showPart").show();
	 jQuery("#table1 tr[detail]").toggle();
  }   
}

   //打开附件
	function opendoc(showid,versionid,docImagefileid,coworkid){
	    openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&coworkid="+coworkid+"&isFromAccessory=true&isfromcoworkdoc=1");
	}
	//打开附件
	function opendoc1(showid,coworkid){
	   openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=0&coworkid="+coworkid+"&isfromcoworkdoc=1");
	}
	//下载附件
	function downloads(files,coworkid){
	   jQuery("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&coworkid="+coworkid);
	}
	//打开文档
    function opendoc2(showid,coworkid){ 
	   openFullWindowForXtable("/docs/docs/DocDsp.jsp?coworkid="+coworkid+"&id="+showid);
	}
   
    function showSearch(){
      if(jQuery("#searchTable").is(":hidden")){
        jQuery("#searchBtn").css("background","url('/cowork/images/search_up.png')");
        jQuery("#searchTable").show();
        }
      else{
        jQuery("#searchBtn").css("background","url('/cowork/images/search_down.png')");
        jQuery("#searchTable").hide(); 
      }    
    }
    
  //显示缩略图
  function showHead(obj){
       if(obj.checked){
         jQuery(".userHeadTd").show(); 
         jQuery.post("/cowork/CoworkOperation.jsp?method=showHead&isCoworkHead=1",{},function(){
         });
       }else{
         jQuery(".userHeadTd").hide(); 
         jQuery.post("/cowork/CoworkOperation.jsp?method=showHead&isCoworkHead=0",{},function(){});
       }     
  }
  
  function markAsImportant(){
    if("<%=isImportant%>"=="true"){  
       jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:"<%=id%>",type:"normal"},function(data){
             window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&&needfresh=1&id=<%=id%>";
        	 return true; 
       });
     }else{
       jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:"<%=id%>",type:"important"},function(data){
             window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&&needfresh=1&id=<%=id%>";
        	 return true; 
       });
     }
  }
  
  function markAsHidden(){
    if("<%=isHidden%>"=="true"){  
       jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:"<%=id%>",type:"show"},function(data){
             window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&&needfresh=1&id=<%=id%>";
        	 return true; 
       });
     }else{
       jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:"<%=id%>",type:"hidden"},function(data){
             window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&&needfresh=1&id=<%=id%>";
        	 return true; 
       });
     }
  }
  
  //根据楼号查找
  function findByFloorNum(event){
      if(event.altKey&&event.keyCode==71) { 
         var diag = new Dialog();
	     diag.Width = 240;
		 diag.Height =60;
		 diag.Modal = false;
		 diag.Title = "按照楼号查找";
		 diag.InnerHtml="<div style='text-align:left;padding-left:40px;'><div style='margin-top:10px;'><span style='margin-right:8px;'>楼号:</span><input type=text id='findFloorNum' style='width:120px;'/></div><div id='floorNumError' style='display:none;color:red;padding-left:30px;'>请输入整数</div></div>"
		 //点击确定后调用的方法
		 diag.OKEvent = function(){ 
		    var findFloorNum=jQuery("#findFloorNum").val();
		    if(findFloorNum!=""&&(findFloorNum!=parseInt(findFloorNum)|| findFloorNum <=0)) {
              //alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>");  //请输入整数
              jQuery("#floorNumError").show();
              jQuery("#findFloorNum").val(""); //置空
              jQuery("#findFloorNum").focus();
 		      return ;
 		   }else{
 		      jQuery("#srchFloorNum").val(findFloorNum);
 		      diag.close();
		      toPage(1);
		   }
		 };
		 diag.show();
		 
		 jQuery("#findFloorNum").bind("keypress",function(event){
		    if(event.keyCode==13){
		       diag.OKEvent();
		    }
		 });
		 jQuery("#findFloorNum").focus();
      } 
  }
  
  //初始化图片
 function initImg(obj){
       var imgWidth=jQuery(obj).attr("imgWidth");
	   if(imgWidth>400)
	      jQuery(obj).width(400);
	   else if(imgWidth==0)
	      jQuery(obj).width(400);   
	   else{
	      if(jQuery(obj).width()>400)
	         jQuery(obj).width(400);
	   }  
	   //alert(imgWidth);
	
	   jQuery(obj).coomixPic({
			path: '/blog/js/weaverImgZoom/images',	// 设置coomixPic图片文件夹路径
			preload: true,		// 设置是否提前缓存视野内的大图片
			blur: true,			// 设置加载大图是否有模糊变清晰的效果
			
			// 语言设置
		    left: '<%=SystemEnv.getHtmlLabelName(26921,user.getLanguage())%>',		// 左旋转按钮文字
		    right: '<%=SystemEnv.getHtmlLabelName(26922,user.getLanguage())%>',		// 右旋转按钮文字
		    source: '<%=SystemEnv.getHtmlLabelName(26923,user.getLanguage())%>',    // 查看原图按钮文字
			hide:'<%=SystemEnv.getHtmlLabelName(26985,user.getLanguage())%>'       //收起
	   });
	
 }
 
 function firstPage(){
    if(jQuery("#firstPage").length>0)
       jQuery("#firstPage").click();
 }
 
 function prePage(){
    if(jQuery("#prePage").length>0)
       jQuery("#prePage").click();
 }
 
 function nextPage(){
    if(jQuery("#nextPage").length>0)
       jQuery("#nextPage").click();
 }
 
 function lastPage(){
    if(jQuery("#lastPage").length>0)
       jQuery("#lastPage").click();
 }
  
</script>
<body id="ViewCoWorkBody" style="overflow: auto;" onkeydown="findByFloorNum(event)">
<div id="divTopMenu"></div>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	int menuIndex=0;
if(canEdit&&id!=0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:editCowork(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	menuIndex++;
} 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addCowork(),_self} ";
    RCMenuHeight += RCMenuHeightStep ;
    menuIndex++;
//从协作区进入
if(from.equals("cowork")){    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:toSearch(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    menuIndex++;
}

if(isImportant){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(25422,user.getLanguage())+",javascript:markAsImportant(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    menuIndex++;
    
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(25421,user.getLanguage())+",javascript:markAsImportant(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    menuIndex++;
}

if(isHidden){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(25424,user.getLanguage())+",javascript:markAsHidden(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    menuIndex++;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(25423,user.getLanguage())+",javascript:markAsHidden(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	menuIndex++;
}
    
if(canEdit&&id!=0){ 
	if(!status.equals("2")){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(405,user.getLanguage())+",javascript:doEnd(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    menuIndex++;
    } 
    if(status.equals("2")){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(360,user.getLanguage())+",javascript:doOpen(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    menuIndex++;
    }
}
if(id!=0){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(17480,user.getLanguage())+",CoworkLogView.jsp?from="+from+"&id="+id+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    menuIndex++;
}

if(!status.equals("2")&&id!=0){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(17698,user.getLanguage())+",javascript:doAdd(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    menuIndex++;
}
if(id!=0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+",javascript:doexport(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	menuIndex++;
}

	RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:firstPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:prePage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:nextPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:lastPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript">
    
    jQuery(document).bind("mousedown",function(event){
        var menuIndex=<%=menuIndex%>;
        if(event.button==2){
          //右键首页菜单是否显示
	      if(jQuery("#firstPage").length>0){
	         jQuery("#rightMenuIframe").contents().find("#menuItemDivId"+(menuIndex+1)).show();
	      }else{
	         jQuery("#rightMenuIframe").contents().find("#menuItemDivId"+(menuIndex+1)).hide();
	      }   
	      //右键上一页菜单是否显示
	      if(jQuery("#prePage").length>0){
	         jQuery("#rightMenuIframe").contents().find("#menuItemDivId"+(menuIndex+2)).show();
	      }else{
	         jQuery("#rightMenuIframe").contents().find("#menuItemDivId"+(menuIndex+2)).hide();
	      } 
	      
	      //右键下一页菜单是否显示
	      if(jQuery("#nextPage").length>0){
	         jQuery("#rightMenuIframe").contents().find("#menuItemDivId"+(menuIndex+3)).show();
	      }else{
	         jQuery("#rightMenuIframe").contents().find("#menuItemDivId"+(menuIndex+3)).hide();
	      } 
	      
	      //右键尾页菜单是否显示
	      if(jQuery("#lastPage").length>0){
	         jQuery("#rightMenuIframe").contents().find("#menuItemDivId"+(menuIndex+4)).show();
	      }else{
	         jQuery("#rightMenuIframe").contents().find("#menuItemDivId"+(menuIndex+4)).hide();
	      } 
	      
	    }  
    });  
    function initPageMenu(){
      if(event.button!=2)
         return ;
      var menuIndex=<%=menuIndex%>;
      if(jQuery("#firstPage").length>0){
         jQuery("#rightMenuIframe").contents().find("#menuItemDivId"+menuIndex+1).show();
      }else{
         jQuery("#rightMenuIframe").contents().find("#menuItemDivId"+menuIndex+1).show();
      }   
      alert(menuIndex);
    }
</script>
<!-- 提交回复等待 -->
 <div>
	 <DIV id=bg></DIV>
	 <div id="loading">
			<div style=" position: absolute;top: 35%;left: 25%" align="center">
			    <img src="/images/loading2.gif" style="vertical-align: middle"><label id="loadingMsg"><%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%></label>
			</div>
	 </div>
 </div>
 
<%
//是否需要刷新协作列表
if(needfresh.equals("1")){
%>
<script language=javascript>
   if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined)
      window.parent.reloadItemListContent();
</script>
<%}%>
<a id="top" href="#"></a>
<iframe id="downloadFrame" style="display: none"></iframe>
<div align="center" style="width: 100%;height: 100%;">
<div style="width: 98%;height: 100%;margin-left: 5px;">
<table id=table1 class=ViewForm style="margin-top: 5px;width: 99%"> 
	<COLGROUP> 
	<COL width="10%"/>
	<COL width="35%"/>
	<COL width="10%"/>
	<COL width="45%"/>
	 <%if(!from.equals("product")){%>
      <tr>
        <td colspan=4 style="padding-bottom:10px;padding-top:8px;border:1px solid #c2e2e7;background-color:#ebfcff">
           <%
              
             if(remark.indexOf("<form")!=-1)
            	 remark=remark.replace("<form", "<span").replace("</form>", "</span>").replace("id=\"frmmain\"", "id=\"\"").replace("name=\"frmmain\"", "name=\"\"");
             if(remark.replaceAll("<[^>].*?>","").replaceAll("&nbsp;","").length()>150){
				String remarkhtml=remark.replaceAll("<[^>].*?>","").replaceAll("&nbsp;","");
                //remark=Util.StringReplace(remark,"\n","<br>");
           %>
              <span id="showPart"><%=remarkhtml.substring(0,150)%>...<a href="javascript:void(0)" onclick="showDetail('all');return false" style="color: blue;text-decoration: underline;"><%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%><span style="font-size:9px">>></span></a></span><!-- 展开 -->
              <span id="showAll" style="display: none"><%=remark%><a href="javascript:void(0)" onclick="showDetail('part');return false" style="color: blue;text-decoration: underline;margin-left:3px"><%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%><span style="font-size:9px">>></span></a></span><!-- 收缩 -->
           <%}else{ 
			  String remarkhtml =remark; 
		   %>
		      <span id="showPart">
			   <%=remarkhtml%><a href="javascript:void(0)" style="margin-left:3px" onclick="showDetail('all');return false"><%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%><span style="font-size:9px">>></span></a>
			   </span><!-- 展开 -->
               <span id="showAll" style="display: none">
			    <%=remarkhtml%><a href="javascript:void(0)" onclick="showDetail('part');return false" style="margin-left:3px"><%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%><span style="font-size:9px">>></span></a>
			   </span><!-- 收缩 -->
           <%} %>
        </td>
    </tr>    
    <%}%>
	<tr>
	   <td colspan="4">
	     <span style="color:#015a68;font-weight:bold;font-size:13px"><%=name%></span>
		 <span style="font-size:13px">|</span>
         <%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>：<a href='javascript:void(0)' onclick='pointerXY(event);openhrm(<%=creater%>);return false;' style="color:#0000FF"><%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%></a>
		 &nbsp;&nbsp;&nbsp;
		 <%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>：<a href='javascript:void(0)' onclick='pointerXY(event);openhrm(<%=principal%>);return false;' style="color:#0000FF"><%=Util.toScreen(ResourceComInfo.getResourcename(principal),user.getLanguage())%></a>
	   </td><!-- 主题 -->
	</tr>
	<TR class="Spacing" style="display:none;height: 1px" detail="true"><TD class="Line" colSpan="4"></TD></TR>
		<tr style="display:none" detail="true">
			<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
			<td  class=Field>
				<%=CoTypeComInfo.getCoTypename(typeid)%>        
			</td>
			<TD><%=SystemEnv.getHtmlLabelName(17697,user.getLanguage())%></TD>
			<TD class=Field>
				<%=begindate%> <%=beingtime%><%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>&nbsp;<%=enddate%> <%=endtime%> 
			</td>     
		</tr>
		<TR class="Spacing" style="display:none;height: 1px" detail="true"><TD class="Line" colSpan="4"></TD></TR>
</table>	
<div style="width: 99%;margin-top: 2px;" align="center">
   <textarea id="remarkContent" class="remarkContent" onpropertychange='autoHeight(this,60)' onfocus="remarkActive()"></textarea>
</div>

<div style="width: 99%;margin-top: 3px;height: 25px;">
   <div style="padding: 0px 0px 3px 0px;">
       <div style="float: left;" align="center"> 
           <input type="button" onclick="doSave('remarkContent')"  id="btnSubmit" class="btnSubmit"  value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>">
       </div><!-- 提交 -->
	   <div align="right" style="float:right;padding-top:5px">
	       <img src="/cowork/images/edit_down.gif" id="external_img" align="absmiddle" style="margin-right:-3px;margin-top:-2px"/><a href="javascript:void(0)" onclick="external('external');return false;" class="externalBtn"><%=SystemEnv.getHtmlLabelName(26165,user.getLanguage())%></a>&nbsp;&nbsp;<!-- 附加功能 -->
	   </div>
   </div>
</div>
<form name="frmmain" id="frmmain" method="post" action="CoworkOperation.jsp" enctype="multipart/form-data">
  
  <input type=hidden name="type" value="<%=type%>">
  <input type=hidden name="viewall" value="<%=viewall%>">
  <input type=hidden name="method" id="method" value="doremark">
  <input type=hidden name="id" value="<%=id%>">
  <input type=hidden name="typeid" value="<%=typeid%>">  
  <input type=hidden name="creater" value="<%=creater%>">
  <input type=hidden name="txtPrincipal" value="<%=principal%>">
  <input type=hidden name="replayid" id="replayid" value="0">
  <input type=hidden name="floorNum" id="floorNum" value="0">
  <input type=hidden name="remark" id="remark" value="0">
  <input type=hidden name="from" id="remark" value="<%=from%>">
<div id="external" class="externalDiv" >
       <table class=ViewForm id="table1">
           <tr>
               <!-- 相关文档 -->
               <td width="15%"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
               <td width="85%" colspan="3" class=Field style="word-break:break-all">
                  <button type="button" class=browser onclick="onShowDoc('relateddoc','relateddocsspan')"></button>
				  <input type=hidden id="relateddoc" name="relateddoc" value="<%=docid%>">
				  <span id="relateddocsspan"><a href="javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=docid%>')"><%=DocComInfo.getDocname(Integer.toString(docid))%></a></span>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr>
               <!-- 相关流程 -->
               <td width="15%"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
               <td width="85%" colspan="3" class=Field style="word-break:break-all">
                  <button type="button" class=browser onclick="onShowRequest('relatedwf','relatedrequestspan')"></button>
			      <input type=hidden id="relatedwf" name="relatedwf">
			      <span id="relatedrequestspan"></span>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr <%if(isgoveproj!=0){ %>style="display: none;"<%}%>>
               <!-- 相关客户 -->
               <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
               <td class=Field colspan="3" style="word-break:break-all">
                  <button type="button" class=browser onclick="onShowCRM('relatedcus','crmspan')"></button>
				  <input type="hidden" id="relatedcus" name="relatedcus">
				  <span id="crmspan"></span>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr>
               <!-- 相关项目 -->
               <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
               <td class=Field colspan="3">
                  <BUTTON type="button" class="Browser" id="selectMultiProject" onclick="onShowMultiProjectCowork('projectIDs','mutilprojectSpan')"></BUTTON>
				  <INPUT type="hidden" id="projectIDs" name="projectIDs" >
				  <SPAN id="mutilprojectSpan"></SPAN>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr>
               <!-- 相关项目任务 -->
               <td <%if(isgoveproj!=0){%>style="display: none;"<%}%>><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
               <td class=Field colspan="3" style="word-break:break-all;<%if(isgoveproj!=0){%>display: none;<%}%>">
                  <button type="button" class=browser onclick="onShowTask('relatedprj','projectspan')"></button>
			      <input type="hidden" id="relatedprj" name="relatedprj">
				 <span id="projectspan"></span>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr>
               <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
               <%
					Map dirMap=dao.getAccessoryDir(typeid);
					String mainId =(String)dirMap.get("mainId");
					String subId = (String)dirMap.get("subId");
					String secId = (String)dirMap.get("secId");
					String maxsize = (String)dirMap.get("maxsize");
					
					if(!mainId.equals("")&&!subId.equals("")&&!secId.equals("")){
					%>
					<td colspan="3" class=Field <%if(isgoveproj!=0) out.println("colspan=3");%> style="white-space: nowrap">
						<div id="uploadDiv" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
					</td>
					<%}else{%>
					 <td <%if(isgoveproj!=0) out.println("colspan=3");%>><font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font></td>
					<%}%> 
           </tr>
       </table>   
</div>

<table cellspacing="0" cellpadding="0" class="navTab" id="mainTab" style="display: block;margin-top:8px;">
	  <tr>
	     <!-- 协作交流 -->
		 <td class="normal_tab active_tab" nowrap="nowrap" id="cowork_comm" onclick="changeMainTab(id)">
		      <%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%>
		 </td>
		 <td class="seprator_tab">&nbsp;</td>
		 <td class="normal_tab" nowrap="nowrap" id="cowork_join" onclick="changeMainTab(id)"><%=SystemEnv.getHtmlLabelName(430,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(622,user.getLanguage())%></td>
		 <td class="seprator_tab" nowrap="nowrap">&nbsp;</td>
		 <!-- 参与情况 -->
		 <td class="normal_tab" nowrap="nowrap" id="cowork_resource" onclick="changeMainTab(id)"><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6105,user.getLanguage())%></td><!-- 相关资源--> 
		 <td class="line_tab" align="right">
		    <input type="checkbox" id="isReplay" name="isReplay" onclick="toPage(1)" value="1">非回复记录
		    <input type="checkbox" id="isCoworkHead" name="isCoworkHead" onclick="showHead(this)" value="1" <%if(!isCoworkHead.equals("0")){%>checked="checked"<%}%>>显示缩略图
		    <input type="button" id="searchBtn" style="cursor:pointer;border:0px;width:82px;padding-left:10px;padding-top:3px;font-size:12px;height:23px;background-image:url('/cowork/images/search_down.png');" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())%>" onclick="showSearch()"/>
		 </td>
	  </tr>
</table>

<!-- 协作交流 -->
<div style="width: 99%;padding-top: 8px;" id="cowork_comm_tab">
  <table class=ViewForm id="searchTable" style="display:none;margin-bottom: 8px">
	<tr>
		 <!-- 内容 -->
		 <td width="10%"><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
         <td width="40%" class=field>
           <input class=inputstyle type=text id='srchcontent' value="" style="width:80%">      
         </td>
		 <td width="10%" style="padding-left:10px">
	       <!--发表人-->
	        <%=SystemEnv.getHtmlLabelName(26225,user.getLanguage())%>
         </td>
         <td width="40%" class=field>
            <BUTTON class=Browser id=SelectCreaterID type="button" onClick="onShowResourceOnly('discussant','discussantspan')"></BUTTON> 
            <span id=discussantspan></span> 
            <INPUT class=saveHistory id=discussant type=hidden name=discussant>
         </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR>
		 <tr> 
            <TD><%=SystemEnv.getHtmlLabelName(17697,user.getLanguage())%></TD>
            <TD class=Field>
               <BUTTON type="button" class=Calendar onclick="getDate(startdatespan,startdate)"></BUTTON> 
               <SPAN id=startdatespan></SPAN> 
               <input type="hidden" name="startdate" id="startdate" >
               <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp&nbsp
               <BUTTON  type="button" class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
               <SPAN id=enddatespan></SPAN> 
               <input type="hidden" name="enddate" id="enddate" >
            </TD> 
            <td style="padding-left:10px">楼号</td>
			<td class=Field>
			   <span style="margin-right: 15px;"><input class=inputstyle type=text id='srchFloorNum' value="" size="5">(Alt+G)</span>
			   <BUTTON type="button" style="cursor:pointer;text-align:center;border:0px;width:38px;font-size:12px;height:22px;background:url('/cowork/images/search.png');padding: 0px;" onclick="toPage(1)"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON><!-- 搜索 -->
               <BUTTON type="button" style="cursor:pointer;text-align:center;border:0px;width:38px;font-size:12px;height:22px;margin-left:15px;background:url('/cowork/images/search.png');padding: 0px;" onclick="clearSearch()"><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON><!-- 清除 -->
            </td>
	     </tr>
    <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR>
  </table>
  <div id="discusses"></div>
</div>
</form>
<!-- 协作参与人 -->
<div class="navTab" id="cowork_join_tab"></div>

<!-- 相关资源 -->
<div class="navTab" id="cowork_resource_tab" >
  <table cellpadding="0" cellspacing="0" width="100%"> 
     <tr>
         <td class="normal_tab active_tab" nowrap="nowrap" align="center" id="relate_doc" onclick="changeRelatedTab(id,2)"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td><!-- 相关文档 -->
		 <td class="seprator_tab">&nbsp;</td>
         <td class="normal_tab" nowrap="nowrap" align="center" id="relate_wf"  onclick="changeRelatedTab(id,3)"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td><!-- 相关流程 -->
		 <td class="seprator_tab">&nbsp;</td>
         <td class="normal_tab" nowrap="nowrap" align="center" id="relate_crm" onclick="changeRelatedTab(id,4)"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td><!-- 相关客户 -->
		 <td class="seprator_tab">&nbsp;</td>
         <td class="normal_tab" nowrap="nowrap" align="center" id="relate_proj" onclick="changeRelatedTab(id,5)"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td><!-- 相关项目 -->
		 <td class="seprator_tab">&nbsp;</td>
         <td class="normal_tab" nowrap="nowrap" align="center" id="relate_task" onclick="changeRelatedTab(id,6)"><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td> <!-- 相关任务 -->
		 <td class="seprator_tab">&nbsp;</td>
         <td class="normal_tab" nowrap="nowrap" align="center" id="relate_acc"  onclick="changeRelatedTab(id,7)"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td><!-- 相关附件 -->
         <td class="line_tab">&nbsp;</td>
     </tr>
  </table>
  <div id="relate_doc_div" class="related_active_div"></div>
  <div id="relate_wf_div" class="related_div"></div>
  <div id="relate_crm_div" class="related_div"></div>
  <div id="relate_proj_div" class="related_div"></div>
  <div id="relate_task_div" class="related_div"></div>
  <div id="relate_acc_div" class="related_div"></div>
</div>

</div>
</div>
</body>
</html>
