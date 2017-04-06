<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="java.text.SimpleDateFormat"%>
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
	String from = Util.null2String(fu.getParameter("from"));
	String isCoworkHead=settingComInfo.getIsCoworkHead(settingComInfo.getId(""+userid));
	int currentpage =1;
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<link rel="stylesheet" href="/cowork/css/cowork.css" type="text/css" />
<link rel=stylesheet href="/css/Weaver.css" type="text/css" />
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/cowork/js/scrollTop.js"></script>
<SCRIPT language="VBS" src="/cowork/js/Cowork.vbs"></SCRIPT>
<script language=javascript src="/js/weaver.js"></script>

<!-- 图片缩略 -->
<link href="/blog/js/weaverImgZoom/weaverImgZoom.css" rel="stylesheet" type="text/css">
<script src="/blog/js/weaverImgZoom/weaverImgZoom.js"></script>
</head>
<script  type="text/javascript">
jQuery(document).ready(function(){
  displayLoading(1,"page");
  jQuery.post("/cowork/DiscussRecord.jsp?recordType=replay&type=1&currentpage=<%=currentpage%>",{},function(data){
          
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
  
   //绑定收缩下拉框事件
   if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
    }
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


/*文本输入自动调整高度*/
function autoHeight(obj,height){
  if(obj.scrollHeight>height)
    obj.style.posHeight=obj.scrollHeight
}


/*文本输入自动调整高度*/
function replayAutoHeight(obj){
  if(obj.scrollHeight>35)
    obj.style.posHeight=obj.scrollHeight
}

/*显示回复框*/
var preReplayid="";
function showReplay(discussid,floorNum,coworkid){
   if(preReplayid=="")
      preReplayid=discussid;
   if(preReplayid!=discussid){
      cancelReplay(preReplayid);
      jQuery("#discuss_table_"+preReplayid).css("background-color","#FFFFFF");
      preReplayid=discussid;    
   }      
   jQuery("#replay_"+discussid).show();
   jQuery("#replay_content_"+discussid).focus();
   jQuery("#replayid").val(discussid);  //被回复的留言
   jQuery("#floorNum").val(floorNum);   //被回复留言的楼层 
   jQuery("#coworkid").val(coworkid);   //被回复留言的协作
   
}
/*隐藏回复框*/
function cancelReplay(discussid){
   
   jQuery("#replay_"+discussid).hide();
   jQuery("#replay_content_"+discussid).val("");
   jQuery("#replay_content_"+discussid)[0].style.posHeight="35";
   jQuery("#replayid").val(0);
   jQuery("#floorNum").val(0);
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



 /*提交回复*/
 function doSave(remarkid){
     var remark=jQuery("#"+remarkid);
     var remarkValue=jQuery.trim(remark.val());
     if(remarkValue==""){
        alert("<%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18546,user.getLanguage())%>");
        remark.focus();
        return;   
     }else{
       remarkValue = remarkValue.replace(/\n/g,"<br/>");     //替换换行\n
       remarkValue = remarkValue.replace(/\\/g,"\\\\");      //替换斜杠
       remarkValue = remarkValue.replace(/'/g,"\\'");        //转义单引号
       jQuery("#remark").val(remarkValue);
     }
    
     displayLoading(1,"save");  //提交等待显示
     
     var param="{";
     jQuery("#frmmain").find("input[type='hidden']").each(function(){
        var element=jQuery(this);
        param=param+element.attr("name")+":'"+element.val()+"',"
     });
     param=param.substr(0,param.length-1)+"}";
     var method=jQuery("#method").val();
     jQuery.post("CoworkOperation.jsp", eval('('+param+')'),function(data){
        displayLoading(0);  //提交等待显示
         alert("回复成功");
        jQuery("#replay_"+preReplayid).hide();
        jQuery("#replay_content_"+preReplayid).val("");
     });
 }

//分页
function toPage(pageNum){
  url="/cowork/DiscussRecord.jsp?recordType=replay&type=1&currentpage="+pageNum;
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
     jQuery("#top").focus();
     displayLoading(0);
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
 		    
 		displayLoading(1,"page");
 		jQuery.post("/cowork/DiscussRecord.jsp?recordType=replay&type=1&currentpage="+topage,{},function(data){
 		     jQuery("#discusses").html(data);
		     addBackGround();
		     displayLoading(0);
 		});
 	}

//是否为高级编辑器模式
function isHighEditor(){
  return jQuery("#remarkContent").is(":hidden");
}

//新建协作
function addCowork(){
	if("<%=from%>"=="cowork")
		jQuery(window.parent.document).find("#ifmCoworkItemContent").attr("src","/cowork/AddCoWork.jsp?from=<%=from%>");
	else
        window.location.href="/cowork/AddCoWork.jsp?from=<%=from%>";
    
}

  
//跳转到查询协作
function toSearch(){
	if("<%=from%>"=="cowork")
		 jQuery(window.parent.document).find("#ifmCoworkItemContent").attr("src","/cowork/SearchCowork.jsp");
	else
         window.location.href="/cowork/SearchCowork.jsp";
   
}


   //打开附件
	function opendoc(showid,versionid,docImagefileid,coworkid){
	    openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&coworkid="+coworkid+"&isFromAccessory=true&isfromcoworkdoc=1");
	}
	//打开附件
	function opendoc1(showid,coworkid){
	   openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&coworkid="+coworkid+"&isfromcoworkdoc=1");
	}
	//下载附件
	function downloads(files,coworkid){
	   document.location.href="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&coworkid="+coworkid;
	}
	//打开文档
    function opendoc2(showid){
	   openFullWindowForXtable("/docs/docs/DocDsp.jsp?isfromcoworkdoc=1&id="+showid);
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
</script>
<body id="ViewCoWorkBody" style="overflow: auto;">
<div id="divTopMenu"></div>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addCowork(),_self} ";
    RCMenuHeight += RCMenuHeightStep ;
//从协作区进入
if(from.equals("cowork")){    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:toSearch(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<!-- 提交回复等待 -->
 <div>
	 <DIV id=bg style="background:none"></DIV>
	 <div id="loading">
			<div style=" position: absolute;top: 35%;left: 25%" align="center">
			    <img src="/images/loading2.gif" style="vertical-align: middle"><label id="loadingMsg"><%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%></label>
			</div>
	 </div>
 </div>
<a id="top" href="#"></a>
<div style="width: 99%;height: 100%;padding-left: 10px" align="center">
<form name="frmmain" id="frmmain" method="post" action="CoworkOperation.jsp" enctype="multipart/form-data">
  <input type=hidden name="method" id="method" value="doremark">
  <input type=hidden name="id" id="coworkid" value="0">
  <input type=hidden name="replayid" id="replayid" value="0">
  <input type=hidden name="floorNum" id="floorNum" value="0">
  <input type=hidden name="remark" id="remark" value="0">
  <input type=hidden name="from" id="remark" value="<%=from%>">
  
<!-- 最近一周被回复的留言 -->
<div style="margin-top: 8px;padding-bottom:10px;padding-top:8px;border:1px solid #c2e2e7;background-color:#ebfcff;text-align: center;">
     <%=SystemEnv.getHtmlLabelName(26261,user.getLanguage())%>
</div>
<!-- 协作交流 -->
<div style="width: 99%;padding-top: 8px" id="cowork_comm_tab">
  <div id="discusses"></div>
</div>
</form>
</div>
</body>
</html>
