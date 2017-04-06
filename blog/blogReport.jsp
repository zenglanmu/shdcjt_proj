<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.blog.BlogReportManager"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title><%=SystemEnv.getHtmlLabelName(26470,user.getLanguage()) %></title>
<script type='text/javascript' src='js/timeline/lavalamp.min.js'></script>
<script type='text/javascript' src='js/timeline/easing.js'></script>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp.css" rel="stylesheet" type="text/css"> 	

<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>
 
<style>
.name{padding-left: 33px}
.tabClose{float: right;padding-right: 3px;cursor: pointer;}
.report{width:98%;height: 100%;overflow:auto}
.reportFrame{width: 100%;height: 100%;}
</style>
</HEAD>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<%
  String userid=""+user.getUID();
  BlogReportManager reportManager=new BlogReportManager();
  List tempList=reportManager.getReportTempList(userid);
%>

<body style="overflow-x: auto;overflow-y:hidden">
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

<table cellpadding="0"  id="reportTabs" cellspacing="0" height="100%" width="100%" border="0">
<tr>
	<td height="30px" id="blogReportTab" class="blogReportTab" align=left >	
	  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
		<tr align=left>
		    <td nowrap class="item itemSelected" id="my" url="myReport.jsp"><%=SystemEnv.getHtmlLabelName(18040,user.getLanguage())%></td><!-- 我的报表 -->
			<td nowrap width=2px>&nbsp;</td>
			<td nowrap class="item" id = 'attention' url="attentionReport.jsp"><%=SystemEnv.getHtmlLabelName(26943,user.getLanguage())%></td><!--关注报表 -->
			<%
			  for(int i=0;i<tempList.size();i++){
				  Map map=(Map)tempList.get(i);
				  String tempid=(String)map.get("tempid");
				  String tempName=(String)map.get("tempName");
			%>
			   <td nowrap width=2px id='seprator'>&nbsp;</td>
			   <td nowrap class="item" id="<%=tempid%>" url="customReport.jsp?tempid=<%=tempid%>"> 
				<div class="tabTitle" title="<%=tempName%>"><%=tempName%></div><div class="tabClose" onclick="closeTab(this,'<%=tempid%>',event)" title="<%=SystemEnv.getHtmlLabelName(26944,user.getLanguage())%>"><img  src="images/delete-msg.png" align="absmiddle"/><div><!-- 删除报表 -->
			   </td>
			<%} %>
			<td nowrap width=24px style="padding-left: 6px;padding-top: 3px" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(20412,user.getLanguage())%>"> <!-- 添加自定义报表 -->
			  <img src="images/add-tab.png" onclick="addTab(this)" style="cursor: pointer;" />
			</td>
			<td nowrap class="righttab" align=right></td>
		</tr>
	 </table>
	</td>
	<td class="coworkTab" align=right>
	  &nbsp;
	</td>
</tr>
<tr>
	<td id="reportContainer" colspan="2" style="border-left:1px solid #81b3cc;padding-left: 5px" valign="top" align="center">

        <iframe class='reportFrame' src='' id='my_frame' frameborder='0'></iframe>
        <iframe class='reportFrame' src='' id='attention_frame'  frameborder='0' ></iframe>
        <%
          for(int i=0;i<tempList.size();i++){
        	  Map map=(Map)tempList.get(i);
			  String tempid=(String)map.get("tempid");
        %>
          <iframe class='reportFrame' src='' id='<%=tempid%>_frame'  frameborder='0' ></iframe> 
        <%} %>
    </td>
	</tr>
</table>

</body>
<script>

jQuery(document).ready(function(){

	//绑定tab页点击事件
	jQuery(".item").bind("click", function(){
  		var itemType=jQuery(this).attr("type");
  		
  		if(jQuery(this).hasClass("itemSelected"))
  			return;
	  	else{
	  		jQuery(".itemSelected").removeClass("itemSelected");
	  		jQuery(this).addClass("itemSelected");
	  		loadReport(this);
	  	}
  	});

    loadReport(jQuery(".itemSelected"));
	
});

    function loadReport(obj){
      
      	var tabid=jQuery(obj).attr("id");
	    var tabdiv=tabid+"_frame";
	    var url=jQuery(obj).attr("url");
	  		
	    jQuery(".reportFrame").hide();
	    jQuery("#"+tabdiv).show();
	  	
	  	if(jQuery("#"+tabdiv).attr("src")==""){
	  	   
	  	    displayLoading(1,"page");
			var reportFrame=jQuery("#"+tabdiv)[0];
			reportFrame.onreadystatechange = function(){ 
			    if (reportFrame.readyState == "complete"){ 
			       displayLoading(0);
			    }    
			};
	  	    jQuery("#"+tabdiv).attr("src",url);
	  	}
    }

   function addTab(obj){
         
          jQuery.post("blogOperation.jsp?operation=addReport",function(data){
               var tempid=jQuery.trim(data);
	           var tabid=tempid;
		       var tabdiv=tabid+"_frame";
		       jQuery(obj).parent().before("<td nowrap width=2px>&nbsp;</td><td nowrap id='"+tabid+"' class='item'><div class='tabTitle' title='<%=SystemEnv.getHtmlLabelName(20412,user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(20412,user.getLanguage())%></div><div class='tabClose' onclick=closeTab(this,"+tempid+",event) title='<%=SystemEnv.getHtmlLabelName(26944,user.getLanguage())%>'><img src='images/delete-msg.png' align='absmiddle'/><div></td>");
		       jQuery("#"+tabid).bind("click",function(){
		          jQuery(".itemSelected").removeClass("itemSelected");
		  		  jQuery(this).addClass("itemSelected");
		          jQuery(".reportFrame").hide();
		          jQuery("#"+tabdiv).show();
		       });
		       
	           jQuery("blogOperation.jsp?operatio=add");	       
		       
		       jQuery("#"+tabid).attr("url","customReport.jsp?tempid="+tempid);
		       jQuery("#"+tabid).click();
		       jQuery("#reportContainer").append("<iframe class='reportFrame' frameborder='0' src='' id='"+tabdiv+"'></iframe>")
		       jQuery("#"+tabdiv).attr("src","customReport.jsp?isnew=true&tempid="+tempid);
          
          });
	}
    
   function closeTab(obj,tempid,event){
     //确认删除报表
     if(window.confirm("<%=SystemEnv.getHtmlLabelName(16631,user.getLanguage())+SystemEnv.getHtmlLabelName(26944,user.getLanguage())%>")){
         jQuery.post("blogOperation.jsp?operation=delReport&tempid="+tempid);
	     var tab=jQuery("#"+tempid);
	     var seprator=tab.prev();
	     var prevTab=tab.prev().prev();
	     
	     tab.remove();
	     seprator.remove();
	     prevTab.click();
	     event.cancelBubble=true;
     }
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
	    jQuery("#loading").css({"top":document.body.scrollTop + document.body.clientHeight/2 - loadingHeight/2,"left":document.body.scrollLeft + document.body.clientWidth/2 - loadingWidth/2});
	    jQuery("#loading").show();
    }else{
        jQuery("#loading").hide();
        jQuery("#bg").hide(); //遮照关闭
    }
}
   
</script>
