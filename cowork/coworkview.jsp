<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.cowork.CoworkItemMarkOperation"%>
<%@page import="weaver.cowork.CoworkLabelVO"%>
<%@ include file="/systeminfo/init.jsp" %>

<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
<jsp:useBean id="CoTypeRight" class="weaver.cowork.CoTypeRight" scope="page"/>
<HTML>
<HEAD>
<title><%=SystemEnv.getHtmlLabelName(18032,user.getLanguage()) %></title>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/js/jquery/plugins/treeview/jquery.treeview.css" />
<script src="/js/jquery/plugins/treeview/jquery.treeview.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" media="all" href="/cowork/css/cowork.css" />
</HEAD>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%
int userid=user.getUID();
//int typeid=Util.getIntValue(Util.null2String(request.getParameter("typeid")),0);没有
int docid=Util.getIntValue(Util.null2String(request.getParameter("docid")),0);//TD5067，从协作区创建文档返回的文档ID
String method = Util.null2String(request.getParameter("method"));//从文档关联至协作
int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);//协作区提醒

String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String projectid = Util.null2String(request.getParameter("projectid"));
String type = Util.null2String(request.getParameter("type"));
String uid = Util.null2String(request.getParameter("uid"));
//int isworkflow = Util.getIntValue(Util.null2String(request.getParameter("isworkflow")),0);

int maintypeid = Util.getIntValue(Util.null2String(request.getParameter("maintypeid")),0);

String taskIds = Util.null2String(request.getParameter("taskIds"));
String queryStr=request.getQueryString();//参数 
String disPage="/cowork/ViewCoWork.jsp?"+queryStr;

String quickSearch= Util.null2String(request.getParameter("quickSearch")); //是否来自快速搜索
String name= Util.null2String(request.getParameter("name")); //快速搜索协作主题

String flag = Util.null2String(request.getParameter("flag"));
String iframeSrc = "";
if(flag.equals("add")){
	iframeSrc = "/cowork/AddCoWork.jsp?from=cowork&typeid=0" ;
}else if(flag.equals("search")){	
	iframeSrc = "/cowork/SearchCowork.jsp?from=cowork&name="+name;
}else if(id!=0){
	iframeSrc = disPage; 
}else{
	//iframeSrc = "/cowork/welcome.jsp?from=cowork";
    iframeSrc = "/cowork/ViewReplay.jsp?from=cowork";
}

Cookie cookies[]=request.getCookies();
String coworkLeftWidth="0";
for(int i=0;i<cookies.length;i++){
	if(cookies[i].getName().equals("coworkLeftWidth")){
		coworkLeftWidth=cookies[i].getValue();
	    break;
	}	
}
if(coworkLeftWidth.equals("0"))
	coworkLeftWidth="288";

CoworkItemMarkOperation markOperation=new CoworkItemMarkOperation();
List labelList=markOperation.getLabelList(""+userid,"all");          //标签列表
%>	
<body scroll=no>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">

<tr>
	<td height="30px" class="coworkTab" align=left >	
	  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
		<tr align=left>
			<td nowrap class="item itemSelected" id = 'allTab' type='all' title="<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></td><!--全部 -->
            <%for(int i=0;i<labelList.size();i++){ 
                 CoworkLabelVO labelVO=(CoworkLabelVO)labelList.get(i);
                 String isUsed=labelVO.getIsUsed();
                 if(isUsed.equals("0")) continue;
                 String labelid=labelVO.getId();
                 String labelType=labelVO.getLabelType();
                 String labelName=labelVO.getName();
                 if(!labelType.equals("label"))
                	 labelName=SystemEnv.getHtmlLabelName(Integer.parseInt(labelVO.getName()),user.getLanguage());
                 else
                	 labelName=labelVO.getName();
            %>
              <td nowrap width=2px>&nbsp;<td>
			  <td nowrap class="item" type='<%=labelType%>' labelid='<%=labelid%>' title='<%=labelName%>'>
			     <div style="cursor:hand;width:65px; line-height:25px; text-overflow:ellipsis; white-space:nowrap; overflow:hidden">
			        <%=labelName%>
			     </div>
			  </td>
            <%}%>
			  <td nowrap width=2px>&nbsp;<td>
			  <td nowrap class="righttab" align=right></td>
		</tr>
	 </table>
	</td>
	<td class="coworkTab" align=right>
	   <div style="position:relative;margin-right:15px">
	     <button style="background-image:url('/images_face/ecologyFace_2/LeftMenuIcon/SystemSetting.gif') !important;margin-right: 6px;" title="<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())+SystemEnv.getHtmlLabelName(22250,user.getLanguage())%>" class="btnFavorite" id="BacoAddFavorite" onclick="openLabelSet();" type="button"/><!-- 加入收藏夹 -->
         <button title="<%=SystemEnv.getHtmlLabelName(18753,user.getLanguage())%>" class="btnFavorite" id="BacoAddFavorite" onclick="openFavouriteBrowser();" type="button"/><!-- 加入收藏夹 -->
	     <button title="<%=SystemEnv.getHtmlLabelName(275,user.getLanguage())%>" style="margin-left:5px" class="btnHelp" id="btnHelp" onclick="showHelp();" type="button"/><!-- 帮助-->
       </div>
	</td>
</tr>
<tr>
	<td colspan="2" style="border-left:1px solid #81b3cc;">
		<div id=divContent > 
		<table border=0 height=100% width=100% cellpadding="0" cellspacing="0">
			<tr>
				<td width="<%=coworkLeftWidth%>" valign="top" id="itmeList">
					<table border=0 height=100% class="liststyle" style="margin:0px" width=100% cellpadding="0" cellspacing="0">
					<tr class="Header">
						<th style="margin:0px;padding:0px">
						<div id='listTitle'>
						    
						    <div id='checkBtn' class='checkBtn' style="padding-left: 0px">
						    	<a class="btnEcology" href="#" style="text-decoration:none">
									<div class="left" style="padding-top:4px;padding-left: 0px"><input class="noCanStyle" type="checkbox" id="chkALL" style='margin-top:-5'>&nbsp;<img src='/cowork/images/icon-down.gif' align="absmiddle" style="margin-top:-1px"></div>
									<div class="right"> &nbsp;</div>
								</a>
							</div>
							<div id='markBtn' class='operateBtn'>
						    	<a class="btnEcology" href="#" style="text-decoration:none">
									<div class="left" style="padding-top:4px;color:#034956;font-weight:normal"><%=SystemEnv.getHtmlLabelName(25418,user.getLanguage()) %>&nbsp;<img src='/cowork/images/icon-down.gif' align="absmiddle" style="margin-top:-1px"></div>
									<div class="right"> &nbsp;</div>
								</a>
							</div>
							
							<div id='orderTypeBtn' class='operateBtn' orderType="unread">
						    	<a class="btnEcology" href="#" style="text-decoration:none">
									<div class="left" style="padding-top:4px;color:#034956;font-weight:normal"><%=SystemEnv.getHtmlLabelName(338,user.getLanguage()) %>&nbsp;<img src='/cowork/images/icon-down.gif' align="absmiddle" style="margin-top:-1px"></div>
									<div class="right"> &nbsp;</div>
								</a>
							</div>
							
							<div id='labelBtn' class='operateBtn'>
						    	<a class="btnEcology" href="#" style="text-decoration:none">
									<div class="left" style="padding-top:4px;color:#034956;font-weight:normal" ><%=SystemEnv.getHtmlLabelName(176,user.getLanguage()) %>&nbsp;<img src='/cowork/images/icon-down.gif' align="absmiddle" style="margin-top:-1px"></div>
									<div class="right">&nbsp;</div>
								</a>
							</div>
							
						</div>
						</th>
					</tr>
					<tr>
						<td style="margin:0px;padding:0px">
						<div id="divListContentContaner" style="position:relative;height: 100%">
						<div class='loading'><img src='/images/loadingext.gif'></div>
						<iframe id="coworkList" src="" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
						</div>
						</td>
					</tr>
					</table>
				</td>
				<td width="8"  align=left valign=middle height=100% id="frmCenter" style="background:#B1D4D9;;cursor:e-resize;" onmousedown="Resize_mousedown(event,this);"   onmouseup="Resize_mouseup(event,this);"   onmousemove="Resize_mousemove(event,this);">
				     <div id="frmCenterImg" onclick="mnToggleleft(this)" class="frmCenterImgOpen"></div>
                </td>
				<td>
					<div id="divCoworkItemContent" style='height:100%;width:100%;'>
						<iframe id='ifmCoworkItemContent' src='<%=iframeSrc%>' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
					</div>
				</td>
			</tr>
		</table>
		</div>
		</td>
	</tr>
</table>
<div id='dropDownLabel' class='dropDown' parent='labelBtn' style="work-break:break-all;width:150px;overflow: auto;">
	
</div>

<div class='dropDown' parent='markBtn' style="width:80px">
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="markItemAsType('read')"><%=SystemEnv.getHtmlLabelName(25419,user.getLanguage()) %></div>
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="markItemAsType('unread')" ><%=SystemEnv.getHtmlLabelName(25420,user.getLanguage()) %></div>
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="markItemAsType('important')"><%=SystemEnv.getHtmlLabelName(25421,user.getLanguage()) %></div>
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="markItemAsType('normal')" ><%=SystemEnv.getHtmlLabelName(25422,user.getLanguage()) %></div>
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="markItemAsType('hidden')" ><%=SystemEnv.getHtmlLabelName(25423,user.getLanguage()) %></div>
	</div>
	
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="markItemAsType('show')" ><%=SystemEnv.getHtmlLabelName(25424,user.getLanguage()) %></div>
	</div>
	
</div>

<div class='dropDown' parent='checkBtn'>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action='selectAll()'><%=SystemEnv.getHtmlLabelName(25398,user.getLanguage()) %></div>
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action='clearAll()'><%=SystemEnv.getHtmlLabelName(557,user.getLanguage()) %></div>
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="selectByType('read')"><%=SystemEnv.getHtmlLabelName(25425,user.getLanguage()) %></div>
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="selectByType('unread')"><%=SystemEnv.getHtmlLabelName(25426,user.getLanguage()) %></div>
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="selectByType('important')"><%=SystemEnv.getHtmlLabelName(25397,user.getLanguage()) %></div>
	</div>
	
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="selectByType('normal')"><%=SystemEnv.getHtmlLabelName(25427,user.getLanguage()) %></div>
	</div>
	
</div>

<div class='dropDown' parent='orderTypeBtn' orderType="important">
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="orderType('important',this)"><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())+SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></div><!-- 按重要 -->
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="orderType('unread',this)"><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())+SystemEnv.getHtmlLabelName(25426,user.getLanguage())%></div>
	</div>
</div>

<div class='dropDown' parent='viewTypeBtn'>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="changeViewType('',this)"><%=SystemEnv.getHtmlLabelName(25398,user.getLanguage()) %></div>
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="changeViewType('p',this)"><%=SystemEnv.getHtmlLabelName(25435,user.getLanguage()) %></div>
	</div>
	<div class=row onmouseover="this.className='rowOver'" onmouseout="this.className='row'">
		<div class='title' action="changeViewType('a',this)"><%=SystemEnv.getHtmlLabelName(25436,user.getLanguage()) %> </div>
	</div>
</div>

<div id='manageLabelsDiv'  style='background-color: #ededed; display:none' parent='none'>

</div>
<div id='coworkAreaTab' class='dropDown' parent='coworkArea' style="width: 125px;overflow:auto;height:50%"></div>

</body>
<script>

/*打开标签设置*/
function openLabelSet(){
  jQuery("#ifmCoworkItemContent").attr("src","/cowork/labelSetting.jsp");
  jQuery(".dropDown").hide();
}

/*排序*/
function orderType(type,obj){
  jQuery(".dropDown").hide();
  if(jQuery("#orderTypeBtn").attr("orderType")==type)
     return ;
  jQuery("#orderTypeBtn").attr("orderType",type);
  loadCoworkItemList(jQuery(".itemSelected").attr("type"));
}

/*拖动效果*/
  var   isResizing=false;   
  var clientX=0;        
  function   Resize_mousedown(event,obj){   
      clientX = event.clientX;            
      if("<%=isIE%>"=="true")
         obj.setCapture();
      else
         window.captureEvents(Event.MOUSEMOVE|Event.MOUSEUP);   
	  isResizing=true;   
  }   
  function   Resize_mousemove(event,obj){   
      if(!isResizing)   return   ;   
      var prevtd=jQuery(obj).prev();
      var width =prevtd.width()+event.clientX-clientX;
      clientX=event.clientX;
      prevtd.width(width);
  }   
  function   Resize_mouseup(event,obj){   
	  var coworkLeftWidth=jQuery("#itmeList").width();
	  addCookie("coworkLeftWidth",coworkLeftWidth,365*24*60*60*1000); //添加cookie
	  
	  if("<%=isIE%>"=="true")
         obj.releaseCapture();
      else
         window.releaseEvents(Event.MOUSEMOVE|Event.MOUSEUP); 
	  isResizing=false;   
  }  
 
 //非IE下处理分隔栏拖动释放
 if("<%=isIE%>"!="true"){
	  jQuery(document).ready(function(){
	      jQuery("#coworkList").bind("load",function(){
	         jQuery("#coworkList").contents().find("body").bind("mouseup",function(){
		         if(isResizing)
		            Resize_mouseup();
	         });
	      })
	     
	      jQuery("#ifmCoworkItemContent").bind("load",function(){
	        jQuery("#ifmCoworkItemContent").contents().find("body").bind("mouseup",function(){
	          if(isResizing)
	             Resize_mouseup();
	        });
	        jQuery("#ifmCoworkItemContent").contents().find("iframe").each(function(){
	            jQuery(this).contents().find("body").bind("mouseup",function(){
		          if(isResizing)
		             Resize_mouseup();
	            });
	        });
	     });
	  });
  }
   
  //添加cookie
  function addCookie(objName,objValue,objHours){//添加cookie
		var str = objName + "=" + escape(objValue);
		if(objHours > 0){//为0时不设定过期时间，浏览器关闭时cookie自动消失
			var date = new Date();
			date.setTime(date.getTime() + objHours);
			str += "; expires=" + date.toGMTString();
		}
		document.cookie = str;
  }
  //读取cookie
  function getCookie(objName){//获取指定名称的cookie的值
		var arrStr = document.cookie.split("; ");
		for(var i = 0;i < arrStr.length;i ++){
		   var temp = arrStr[i].split("=");
		   if(temp[0] == objName) return unescape(temp[1]);
		}
  }
  
  

/*打开协作*/
function openCowork(obj,coworkid){
  jQuery("#ifmCoworkItemContent").attr("src","/cowork/ViewCoWork.jsp?from=cowork&id="+coworkid+'&docid=<%=docid%>&t='+Math.random()); 
  var parentTr=jQuery(obj).parent();
  parentTr.find("input").attr("unread",false);
  parentTr.find("input").attr("read",true);
  jQuery(obj).find(".title").css("font-weight","normal");
  
  parentTr.parent().find(".selected").removeClass("selected");
  parentTr.addClass("selected");
  //parentTr.parent().find(".rtop div").css("margin-bottom","-1px");
  //parentTr.parent().find(".rbottom div").css("margin-top","-1px");
  //parentTr.parent().find(".rbottom").css("margin-top","-1px");
}

/*标记为重要不重要*/
function markImportant(obj,coworkid){
  var parentTr=jQuery(obj).parent().parent();
  if(parentTr.find("input").attr("important")=="true"){
      parentTr.find("img").attr("src","/cowork/images/notimportent.gif");
      parentTr.find("input").attr("important","false");
      markItemAsImportantOrNot(coworkid,"normal")
  }
  else{
      parentTr.find("img").attr("src","/cowork/images/importent.gif");
      parentTr.find("input").attr("important","true");    
      markItemAsImportantOrNot(coworkid,"important")
  }
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

function loadCoworkArea(obj,typeid){
   jQuery("#coworkAreaTab").find(".currentArea").removeClass("currentArea");
   jQuery(obj).addClass("currentArea");
   jQuery(".itemSelected").attr("title",jQuery(obj).html()).html("<div style='cursor:hand;width:65px; line-height:25px; text-overflow:ellipsis; white-space:nowrap; overflow:hidden'>"+jQuery(obj).html()+"</div>");
   var searchStr="typeid="+typeid;
   loadCoworkItemList("coworkArea",searchStr);
   jQuery(".dropDown").hide();
}

//按类别加载协作列表
	function loadCoworkItemList(type,search){
	    
		var viewType = jQuery("#viewTypeBtn").attr("viewtype");
		var orderType = jQuery("#orderTypeBtn").attr("orderType");
		var labelid="0";
		if(type=="label")
		   labelid=jQuery(".itemSelected").attr("labelid");
		   
		var url = "/cowork/CoworkList.jsp";
		url+="?orderType="+orderType+"&type="+type+"&labelid="+labelid+"&"+search+"&projectid=<%=projectid%>&taskIds=<%=taskIds%>";
		
		jQuery("#coworkList").attr("src",url);
		jQuery(".loading").show();
	}

	//标记为重要或者不重要
	function markItemAsImportantOrNot(coworkid,type){
        jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:coworkid,type:type},function(data){
        	return true; 
        });
	}
	
   // 初始化信息
	function initData(){
		jQuery("#viewTypeBtn").attr("viewtype","");
		jQuery("#orderTypeBtn").attr("orderType","unread");
	}
	
	//获取Tab导航栏标签信息
  	function dropDownCoworkAreas(){
  		if(jQuery("#coworkAreaTab").html()==""){
	  		jQuery.post("/cowork/CoworkXMLHTTP.jsp",{},function(data){
	  		    jQuery("#coworkAreaTab").html(data);
	  		    jQuery("#coworkAreaList").treeview();
	  		    jQuery(".item[type='coworkArea']").click();
	  		    jQuery("#coworkAreaTab").bind("click",function(event){
	  		        event.cancelBubble = true;
	  		        return false;
	  		    });
	  		});
  		}
  	}
  	
  	//获取所有选中的协作ID
	function getSelectedItems(){
		var coworkids="";
		jQuery("#coworkList").contents().find("#list input:checked").each(function(jQuerythis){
			if(jQuery(this).attr("id")!="allCheck"){
				coworkids+=jQuery(this).val()+",";
			}
		});
		return coworkids;
	}
	
	//标记协作状态  type:{read:已读,unread:未读,hidden:隐藏,show:取消隐藏,important:重要(加星),normal:一般(不加星)} 
	function markItemAsType(type){
		var coworkids=getSelectedItems();
		if(coworkids==""){
			jQuery(".dropDown").hide();
			alert("<%=SystemEnv.getHtmlLabelName(25430,user.getLanguage()) %>");
		}
		
		jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:coworkids,type:type},function(data){
        	return true; 
        });
        
        jQuery("#coworkList").contents().find("#list input:checked").each(function(jQuerythis){
			if(jQuery(this).attr("id")!="allCheck"){
				if(type=='read'){
					jQuery(this).attr("read",true);
					jQuery(this).attr("unread",false);
					jQuery(this).parents("tr:first").find("td:last").css("font-weight","normal");
				}else if(type=='unread'){
					jQuery(this).attr("read",false);
					jQuery(this).attr("unread",true);
					jQuery(this).parents("tr:first").find("td:last").find(".title").css("font-weight","bold");
				}else if(type=='important'){
					jQuery(this).attr("important",true);
					jQuery(this).attr("normal",false);
					jQuery(this).parents("tr:first").find("img").attr("src","/cowork/images/importent.gif");
				}else if(type=='normal'){
					jQuery(this).attr("important",false);
					jQuery(this).attr("normal",true);
					jQuery(this).parents("tr:first").find("img").attr("src","/cowork/images/notimportent.gif");
				}else if(type=='hidden'){
					if(jQuery(".itemSelected").attr("type")!="hidden")
					  jQuery(this).parents("tr:first").remove();
				}else if( type=='show'){
                    if(jQuery(".itemSelected").attr("type")=="hidden")
					  jQuery(this).parents("tr:first").remove();
                }
			}
		});
		return true;
	}
	
	//选择框
	jQuery("#chkALL").bind("click",function(event){
		if(jQuery(this).attr("checked")){
			selectAll();
		}else{
			clearAll();
		}
		event.stopPropagation();
	});
	
	//全选
	function selectAll(){
		jQuery("#coworkList").contents().find("#list input:checkbox").attr("checked",true);
		jQuery("#chkALL").attr("checked",true);
		return true;
	}
	
	//取消全选
	function clearAll(){
		jQuery("#coworkList").contents().find("#list input:checkbox").attr("checked",false);
		jQuery("#chkALL").attr("checked",false);
		return true;
	}
	
	function selectByType(type){
		clearAll();
		jQuery("#coworkList").contents().find("#list input:["+type+"=true]").attr("checked",true);
		return true;
	}
	
	function setCheckStatus(dopDown){
		jQuery(dopDown).find(".row .check").each(function(jQuerythis){
			jQuery(this).removeClass("add").addClass("remove");
		});
	}
	
	//初始化标签
	function initLabel(dopDown){
		jQuerydopDown = jQuery(dopDown);
		//为标签标题绑定事件
		jQuerydopDown.find(".title").each(function(jQuerythis){
			var action = jQuery(this).attr("action");
			
			if(action=='undefind'){
				//event.stopPropagation();
			}else{
				jQuery(this).bind("click",function(event){
					if(!eval(action)){
						event.stopPropagation();
					}
				});
			}
		});
		
		//alert(jQuery("#coworkList").contents().find("#list input:checked").length);
		jQuerydopDown.find(".check").each(function(){
		   var labelid=jQuery(this).attr("labelid");
		   var flag=0;
		   var hasLabelid=false;
		   //alert(labelid);
		   jQuery("#coworkList").contents().find("#list input:checked").each(function(i){
		       hasLabelid=false;
		       jQuery(this).parents("tr:first").find(".label").each(function(){
		           if(labelid==jQuery(this).attr("labelid")){
		              hasLabelid=true;
		              return false;
				   }
		       });
		       
			   if(i!=0&&flag==0&&hasLabelid)	
			       flag=2; 
			   if((i==0||flag==1)&&hasLabelid)
			       flag=1;      
			       
			   if(flag==1&&!hasLabelid)
			       flag=2;	   
		   });
		   
		   if(flag==0){
		     jQuery(this).addClass("remove");
		     jQuery(this).attr("type","remove");
		    } 
		   else if(flag==2){
		      jQuery(this).addClass("edit");
		      jQuery(this).attr("type","edit");
		   }
		   else if(flag==1){
		     jQuery(this).addClass("add");  
		     jQuery(this).attr("type","add");
		   }
		});
		
		//初始化标签样式
		//jQuerydopDown.find(".check").removeClass("add").addClass("remove");
		
		//var coworkids = getSelectedItems();
		
		//为标签选择框绑定事件
		jQuery(".dropDown .row .check").each(function(jQuerythis){
		    var type=jQuery(this).attr("type");
            if(type=="add"){
               jQuery(this).bind("click",function(event){
					if(jQuery(this).hasClass("remove")){
						jQuery(this).removeClass("remove").addClass("add");
					}else if(jQuery(this).hasClass("add")){
						jQuery(this).removeClass("add").addClass("remove");
					}
					event.stopPropagation();
			  });
            }else if(type=="edit"){
               jQuery(this).bind("click",function(event){
					if(jQuery(this).hasClass("remove")){
						jQuery(this).removeClass("remove").addClass("edit");
					}else if(jQuery(this).hasClass("add")){
						jQuery(this).removeClass("add").addClass("remove");
					}else if(jQuery(this).hasClass("edit")){
						jQuery(this).removeClass("edit").addClass("add");
					}
					event.stopPropagation();
			  });
            }else if(type=="remove"){
               jQuery(this).bind("click",function(event){
					if(jQuery(this).hasClass("remove")){
						jQuery(this).removeClass("remove").addClass("add");
					}else if(jQuery(this).hasClass("add")){
						jQuery(this).removeClass("add").addClass("remove");
					}
					event.stopPropagation();
			  });
            }
		});
		
		// 绑定标签功能按钮事件
		jQuery(".dropDown .row .operate").each(function(jQuerythis){
			var action = jQuery(this).attr("action");
			if(action=='undefind'){
				//event.stopPropagation();
			}else{
				jQuery(this).bind("click",function(event){
					if(!eval(action)){
						event.stopPropagation();
					}
				});
			}
		});
		
		//设置标签显示下拉框高度
		var rowLength=jQuery("#dropDownLabel .row").length;
		if(rowLength>12)
		    jQuery("#dropDownLabel").height(10*24+2);
		else
		    jQuery("#dropDownLabel").height(rowLength*24+2);      
	}
	
	//应用标签
	function applyLabels(obj){
		var coworkids = getSelectedItems();
		if(coworkids==""){
			alert("<%=SystemEnv.getHtmlLabelName(25430,user.getLanguage()) %>");
			return true;
		}
		var labelids='';
		jQuery("#dropDownLabel").find(".add").each(function(i,n){
			labelids+=jQuery(n).next().attr("labelid")+",";
		});
		labelids=labelids.substr(0,labelids.length-1);
		jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:coworkids,type:"addLabel",labelids:labelids},function(data){
        	//先不做返回值判断，统一按成功处理
        	return true; 
		});
		
		//更改标签信息
		if(labelids==""){
			jQuery("#coworkList").contents().find("#list input:checked").each(function(i,n){
				jQuery(this).parents("tr:first").find(".labelContaner").html("");
				jQuery(this).parents("tr:first").find(".labelContaner").hide();
			});
		}else{
			jQuery("#coworkList").contents().find("#list input:checked").each(function(i,n){
			    var labelContaner=jQuery(this).parents("tr:first").find(".labelContaner");
			    labelContaner.html("");
			    labelContaner.show();
			    var labelidList=labelids.split(",");
			    for(var i=0;i<labelidList.length;i++){
			       var label=jQuery("#dropDownLabel").find(".title[labelid="+labelidList[i]+"]");
			       var labelName=label.html();
			       var labelid=label.attr("id");
			       var labelColor=label.attr("labelColor");
			       var textColor=label.attr("textColor");
			       var labelWidth=Math.ceil(getLabelLength(labelName)/2.0)*12+6;
			       var labelHtml="<span class='label' labelid='"+labelidList[i]+"'><div style='background: "+labelColor+";width:"+labelWidth+"px'>"+
			       "<div class='rtop'><div class='r2' style='background:"+labelColor+";border-bottom:"+labelColor+" 1px solid'></div><div class='r3' style='background:"+labelColor+";border-bottom:"+labelColor+" 1px solid'></div></div>"+
			       "<div class='labelTitle' style='color:"+textColor+"'>"+labelName+"</div>"+
			       "<div class='rbottom'><div class='r3' style='background:"+labelColor+";border-bottom:"+labelColor+" 1px solid'></div><div class='r2' style='background:"+labelColor+";border-bottom:"+labelColor+" 1px solid'></div></div>"+
			       "</div></span>";
			       labelContaner.append(labelHtml);
			    }
			});
		}
		return true;
	}

//计算标签名长度	
function getLabelLength(strTemp)  
{  
    var  i,sum;  
    sum=0;  
    for(i=0;i<strTemp.length;i++){  
       if  ((strTemp.charCodeAt(i)>=0)  &&  (strTemp.charCodeAt(i)<=255))  
          sum=sum+1;  
       else  
          sum=sum+2;  
     }  
    return  sum;  
} 	
	
	
	
jQuery(document).ready(function(){

    if("<%=flag%>"=="search"){
	    var searchstr="";
	    if("<%=quickSearch%>"=="true")
	      searchstr="isSearch=true&status=1&name=<%=name%>";
	   loadCoworkItemList(jQuery(".itemSelected").attr("type"),searchstr);
	}else if("<%=flag%>"=="add"){
		reloadItemListContent();
	}else if("<%=docid%>"!="0"){
	    reloadItemListContent();
	}else if("<%=id%>"!="0"){
	    reloadItemListContent();
	}
	else{
	   //加载未读协作信息 
	   loadCoworkItemList(jQuery(".itemSelected").attr("type"),searchstr);
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
	
	//加载所有下拉按钮事件
	jQuery(".dropDown").each(function(jQuerythis){
		var jQuerydopDown = jQuery(this);
		var dropDownParent;
		if(jQuerydopDown.attr("parent")=="coworkArea")
		   	dropDownParent=jQuery(".item[type=coworkArea]");
		else
		    dropDownParent=jQuery("#"+jQuerydopDown.attr("parent"));   	
		   				
		dropDownParent.bind("click",function(event){
			jQuery(".dropDown").hide();
			if(jQuerydopDown.attr("id")=="dropDownLabel"){
				//加载用户标签内容
				jQuerydopDown.html("");
				jQuerydopDown.load("/cowork/CoworkItemMarkOperation.jsp?type=getLabel",function(){
					//初始化标签
					initLabel(jQuerydopDown);
					
				});
			}
			
			jQuerydopDown.css({
				top:jQuery(this).position().top+28,
				left:jQuery(this).position().left
				
			})	
			setCheckStatus(jQuerydopDown);
			if(jQuerydopDown.css("display")!='none'){
				jQuerydopDown.hide();
			}else{
				
				jQuerydopDown.show();
			}		
			
			event.stopPropagation();
		})
		
	})
	
	//隐藏所有下拉菜单
	jQuery(document.body).bind("click",function(){
		jQuery(".dropDown").hide();
	});
	
	jQuery(".dropDown .row .title").each(function(jQuerythis){
		var action = jQuery(this).attr("action");
		if(action=='undefind'){
			//event.stopPropagation();
		}else{
			jQuery(this).bind("click",function(event){
				if(!eval(action)){
					event.stopPropagation();
				}
			});
		}
	});
});

//重新刷新当前列表
function reloadItemListContent(type){
	if(jQuery(".itemSelected").attr("id")=='allTab'){
		initData();
		loadCoworkItemList(jQuery(".itemSelected").attr("type")+"");
	}else{
		jQuery("#allTab").trigger("click");
	}
	
	if(type=="search"){
		jQuery("#advanceSearchDiv").show();
		jQuery('#viewTypeBtn').hide();
	}
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
    //添加到收藏夹
    function openFavouriteBrowser(){
	   var fav_uri=jQuery("#ifmCoworkItemContent").attr("src");
	   fav_uri=fav_uri.replace("from=cowork","");
	   fav_uri = encodeURIComponent(fav_uri,true); 
	   var fav_pagename=jQuery("title", document.frames("ifmCoworkItemContent").document).html();
	   window.showModalDialog("/favourite/FavouriteBrowser.jsp?fav_pagename="+fav_pagename+"&fav_uri="+fav_uri+"&fav_querystring=");
    }
    //显示帮助
    function showHelp(){
       var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
       var screenWidth = window.screen.width*1;
       var screenHeight = window.screen.height*1;
       window.open(operationPage+"?pathKey=cowork/coworkview.jsp","_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
    }

</script>
