<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<HTML>
<HEAD>
<title></title>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<link type='text/css' rel='stylesheet'  href='js/treeviewAsync/eui.tree.css'/>
<script language='javascript' type='text/javascript' src='js/treeviewAsync/jquery.treeview.js'></script>
<script language='javascript' type='text/javascript' src='js/treeviewAsync/jquery.treeview.async.js'></script>

<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script> 
</HEAD>
<%
int userid=user.getUID();
String item=Util.null2String(request.getParameter("item"));
String menuItem=Util.null2String(request.getParameter("menuItem"));
String blogid=Util.null2String(request.getParameter("blogid"));
String src="";

if("attention".equals(item))
	src="myAttention.jsp";
else if("viewBlog".equals(item))
	src="viewBlog.jsp?blogid="+blogid;
else 
	src="myBlog.jsp?menuItem="+menuItem;

%>	
<body scroll=no style="overflow-y:hidden">
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
 
	<div id=divContent style="padding-bottom: 10px;height: 100%"> 
		<table  border=0 height=100% width=100% cellpadding="0" cellspacing="0" >
			<tr>
				<td width='280px' nowrap="nowrap" valign="top" id="itmeList" style="display:<%=item.equals("attention")?"":"none"%>">
					<table border=0  height=100% class="liststyle" style="margin:0px;border:1px solid #81b3cc;" width=100% cellpadding="0" cellspacing="0">
					<tr class="Header">
						<th class="blogTab">
						  <!-- 关注列表 -->
						  <div class="narmal active" style="margin-left: 3px" id="attention" onclick="changeTab(this)">
						     <div><%=SystemEnv.getHtmlLabelName(25436,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage())%></div>
						  </div>
						  <!-- 组织机构 -->
						  <div class="narmal" style="margin-left: 3px" id="hrmOrg" onclick="changeTab(this)">
						      <div><%=SystemEnv.getHtmlLabelName(25332,user.getLanguage())%></div>
						  </div>
						  <!-- 可查看的 -->
						  <div class="narmal" style="margin-left: 3px" id="canview" onclick="changeTab(this)">
						     <div><%=SystemEnv.getHtmlLabelName(27545,user.getLanguage())%></div>
						  </div>
						  <!-- 添加关注 -->
						  <div class="narmal" style="margin-left: 3px" id="searchTab" onclick="changeTab(this)">
						     <div><%=SystemEnv.getHtmlLabelName(26939,user.getLanguage())%></div>
						  </div>
						</th>
					</tr>
					<tr id="searchTR" style="display: none"> 
					   <td class="blogsearch" >
					       <table cellpadding="0" cellspacing="0" class="serachtable">
					          <tr>
					              <td class="searchleft">&nbsp;</td>
					              <td class="searchcenter">
					                  <input id="keyworkd" type="text" class="searchbox" value="<%=SystemEnv.getHtmlLabelName(26919,user.getLanguage())%>" onfocus="searchActive(this)" onkeydown="if(event.keyCode==13) doSearch();" onblur="searchNormal(this)"><!-- 请输入姓名 -->
					              </td>
					              <td class="searchright" onclick="doSearch()">&nbsp;</td>
					          </tr>
					       </table>
					   </td>
					</tr>
					<tr>
					   <td style="height: 5px !important;padding: 0px;"></td>
					</tr>
					<tr>
						<td style="margin:0px;padding:0px;" id="blogListTD">
						<div id="divListContentContaner" style="position:relative;height: 100%;overflow: auto;width: 280px">
							<div id="listItems"></div>
							<div id="loadingdiv1" class='listLoading'><img src='/images/loadingext.gif'></div>
							<div id="loadingdiv2" style="position:relative;width: 100%;height: 30px;margin-bottom: 15px;">
							    <div class='loading' style="position: absolute;top: 10px;left: 20%;display: none;">
								   <img src='/images/loadingext.gif' align="absMiddle"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
								</div>
                            </div>
						<!--  
							<iframe id="blogList" src="" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
						-->
						</div>
						
						</td>
					</tr>
					</table>
				</td>
				<td width="8"  align=left valign=middle height=100% id="frmCenter" style="background:#B1D4D9;;cursor:e-resize;display:<%=item.equals("attention")?"":"none"%>">
				     <div id="frmCenterImg" onclick="mnToggleleft(this)" class="frmCenterImgOpen" style="height: 100%"></div>
                </td>
				<td valign="top">
				     <iframe id='ifmBlogItemContent' src='<%=src%>' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
				</td>
			</tr>
		</table>
	</div>
</body>
<script>
  
  window.onresize=function(){ 
    //jQuery("#ifmBlogItemContent").height(document.body.clientHeight);
  }

  function iFrameHeight() {   
		var ifm= document.getElementById("ifmBlogItemContent");   
		var subWeb = document.frames ? document.frames["ifmBlogItemContent"].document : ifm.contentDocument;   
		if(ifm != null && subWeb != null) {
		   ifm.height = subWeb.body.scrollHeight;
		}   
  }  			
					     
  function openBlog(blogid,type,obj){
	var url="";
	if(type==1){
	    	url="viewBlog.jsp?blogid="+blogid;
    }
	if(type==2||type==3){
		url="orgReport.jsp?orgid="+blogid+"&type="+type;
	}
	displayLoading(1,"page");
	jQuery("#ifmBlogItemContent").attr("src",url);
	if(obj){
	 jQuery(obj).css("font-weight","normal");
	 jQuery(obj).parent().parent().find(".selected").removeClass("selected");
	 jQuery(obj).parent().addClass("selected");
	}
 }
					     
function changeTab(obj){
	if(jQuery(obj).hasClass("active"))
		return ;
	jQuery(".blogTab .active").removeClass("active");
	jQuery(obj).addClass("active");
	var itemType=jQuery(obj).attr("id");			       
    if(jQuery(obj).attr("id")=="searchTab")
      jQuery("#searchTR").show();
    else{  
      jQuery("#searchTR").hide();
      jQuery("#keyworkd").val("");
      jQuery("#keyworkd").blur();
    }  
    if(itemType=="attention")
       initScroll();
    else
       removeScroll();       
       
       
    loadCoworkItemList(jQuery(obj).attr("id"));  
   }
      
      function doSearch(){
        loadCoworkItemList("searchList");
      }
      
      function searchActive(obj){
        if(jQuery(obj).val()=="<%=SystemEnv.getHtmlLabelName(26919,user.getLanguage())%>"){
           jQuery(obj).val("");
           jQuery(obj).css("color","#000000");
        }   
      }
      
      function searchNormal(obj){
        if(jQuery(obj).val()==""){
           jQuery(obj).val("<%=SystemEnv.getHtmlLabelName(26919,user.getLanguage())%>");
           jQuery(obj).css("color","#cccccc");
        }
      }
      
      function disAttention(obj,attentionid,islower,eve){
        var itemName=jQuery(obj).parent().parent().find(".title").text();
        var status=jQuery(obj).attr("status");
        if(status=="cancel"){
           jQuery.post("blogOperation.jsp?operation=cancelAttention&islower="+islower+"&attentionid="+attentionid);
           jQuery(obj).attr("status","add");
           jQuery(obj).find("#btnLabel").html("<span class='add'>+</span><%=SystemEnv.getHtmlLabelName(26939,user.getLanguage())%></span>");  
        }
        if(status=="add"){
           jQuery.post("blogOperation.jsp?operation=addAttention&islower="+islower+"&attentionid="+attentionid);
           jQuery(obj).attr("status","cancel");
           jQuery(obj).find("#btnLabel").html("<span class='add'>-</span><%=SystemEnv.getHtmlLabelName(24957,user.getLanguage())%></span>");  
        }
        if(status=="apply"){
          if(jQuery(obj).attr("isApply")!=="true"){
            jQuery.post("blogOperation.jsp?operation=requestAttention&islower="+islower+"&attentionid="+attentionid,function(){
               alert("<%=SystemEnv.getHtmlLabelName(129,user.getLanguage())+SystemEnv.getHtmlLabelName(19558,user.getLanguage())%>"); //申请已经发送
               jQuery(obj).find("#btnLabel").html("<span class='apply'>√</span><%=SystemEnv.getHtmlLabelName(18659,user.getLanguage())%></span>");
               jQuery(obj).attr("isApply","true");
            });
          }else {
              alert("<%=SystemEnv.getHtmlLabelName(129,user.getLanguage())+SystemEnv.getHtmlLabelName(19558,user.getLanguage())%>"); //申请已经发送
          }  
        }
        eve.cancelBubble=true;
      }

/*收缩左边栏*/
function mnToggleleft(obj){
	if(jQuery("#itmeList").is(":hidden")){
	        jQuery("#frmCenterImg").removeClass("frmCenterImgClose");
	        jQuery("#frmCenterImg").addClass("frmCenterImgOpen");
			jQuery("#itmeList").show();
	}else{
	        jQuery("#frmCenterImg").removeClass("frmCenterImgOpen");
	        jQuery("#frmCenterImg").addClass("frmCenterImgClose"); 
			jQuery("#itmeList").hide();
	}
}


//按类别加载协作列表
	function loadCoworkItemList(type){
		if(type==undefined)
		   type="attention";
		var url = "blogList.jsp?listType="+type;
		if(type=="searchList"){
		  var keyworkd=jQuery("#keyworkd").val();
		  if(keyworkd==""||keyworkd=="<%=SystemEnv.getHtmlLabelName(26919,user.getLanguage())%>"){
		     alert("请输入姓名");
		     return ;
		  }else   
		     url=url+"&keyworkd="+keyworkd;
		} 
		jQuery("#loadingdiv1").show();
		jQuery("#listItems").html(""); 
		jQuery.post(url,function(data){
            jQuery("#listItems").html(data);	
            jQuery("#loadingdiv1").hide();	
		});
		//jQuery("#blogList").attr("src",url);
		//jQuery(".listLoading").show();
	}
	
jQuery(document).ready(function(){
    
    jQuery("#divListContentContaner").height(jQuery("#blogListTD").height()); //固定 divListContentContaner高度防止不出现滚动条
    if("<%=item%>"=="attention"){
       initScroll();
       loadCoworkItemList(jQuery(".itemSelected").attr("type"),"");
    }

	//绑定tab页点击事件
	jQuery(".item").bind("click", function(){
  		var itemType=jQuery(this).attr("type");
		if(itemType=="coworkArea"){
		  dropDownCoworkAreas();
		}
		if(jQuery("#itmeList").is(":hidden")){
			jQuery("#frmCenterImg").removeClass("frmCenterImgClose");
	        jQuery("#frmCenterImg").addClass("frmCenterImgOpen");
			jQuery("#itmeList").show();
	    }
		
  		if(jQuery(this).hasClass("itemSelected"))
  			return;
	  	else{
	  		jQuery(".itemSelected").removeClass("itemSelected");
	  		jQuery(this).addClass("itemSelected");
	  	    initData();
            if(itemType!="coworkArea")
	  	       loadCoworkItemList(itemType);
	  	}
  	});
});

    //添加到收藏夹
    function openFavouriteBrowser(){
	   var fav_uri=jQuery("#ifmBlogItemContent").attr("src");
	   fav_uri=fav_uri.replace("from=cowork","");
	   fav_uri = encodeURIComponent(fav_uri,true); 
	   var fav_pagename=jQuery("title", document.frames("ifmBlogItemContent").document).html();
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
        
        if(flag=="save")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>");   //正在保存，请稍等...
        else if(flag=="page")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%>");   //页面加载中，请稍候...
        else if(flag=="data"||flag=="search")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");   //正在获取数据,请稍等...  
              
        //显示loading
	    var loadingHeight=jQuery("#loading").height();
	    var loadingWidth=jQuery("#loading").width();
	    jQuery("#loading").css({"top":'45%',"left":'51%'});
	    jQuery("#loading").show();
    }else{
        jQuery("#loading").hide();
        jQuery("#bg").hide(); //遮照关闭
    }
}


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
	      index=30;           //起始读取下标
		  hght=0;             //初始化滚动条总长
		  top=0;              //初始化滚动条的当前位置
		  preTop=0;
		  currentpage=1;       //当前页初始值
		  total=0;
		  flag=true;         //每次请求是否完成标记，避免网速过慢协作类型无法区分 成功返回数据为true
		  pagesize=30;
	     
	     //获取主页记录总数，如果index大于total则绑定滚动加载事件
	     jQuery.post("blogOperation.jsp?operation=getMyAttentionCount",function(data){
            total=jQuery.trim(data);
	        if(index<total){
			 jQuery("#divListContentContaner").bind("scroll",function(){
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
	    jQuery("#divListContentContaner").unbind("scroll");     
	}
	
	function show(){
	    if(flag){
			index=index+pagesize;
			if(index>total){                    //当读取数量大于总数时
			   index=total;                     //页面数据量等于数据总数
			   jQuery("#divListContentContaner").unbind("scroll"); 
			}
			//alert(index);
			flag=false;
			currentpage=currentpage+1;          //取下一页
			jQuery("#loadingdiv2").show();  
		    jQuery.post("blogList.jsp?listType=attention&currentpage="+currentpage+"&pagesize="+pagesize+"&total="+total,function(data){
				    jQuery("#listItems").append(data);
				    hght=0;
				    top=0;
				    flag=true;
				    jQuery("#loadingdiv2").hide();  
				    
			});
		}
	} 
/*滚动加载处理*/	

</script>
