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
	CoworkItemMarkOperation markOperation=new CoworkItemMarkOperation();
	List labelList=markOperation.getLabelList(""+userid,"all");
%>
<html>
<head>
<title></title>
<LINK href="/css/Weaver.css" type='text/css' rel='STYLESHEET'>

<link href="/js/jquery/ui/jquery-ui.css" type="text/css" rel=stylesheet>
<script type="text/javascript" src="/js/jquery/ui/ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.dialog.js"></script>
</head>
<body id="ViewCoWorkBody" style="overflow: auto;">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/cowork/addLabel.jsp,_self} ";
    RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<style>
  #coloPanel .ListStyle tr{height:24px !important;}
  #coloPanel .ListStyle td{padding-left:2px !important;
                padding-right:2px !important;
                padding-top:0px !important;
                padding-bottom:0px !important;
  }
  #colorPicker td{width:20px !important;text-align:center;cursor:pointer}
</style>

<div id="coloPanel" title="<%=SystemEnv.getHtmlLabelName(22975,user.getLanguage())%>">
	<div id="colorPicker">
	    <table cellpadding="0" cellspacing="5" align="center">
	       <tr>
	          <td style="background-color: #dee5f2; color: #5a6986;" colorValue="#dee5f2" textColor="#5a6986" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #e0ecff; color: #206cff;" colorValue="#e0ecff" textColor="#206cff" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #dfe2ff; color: #0000cc;" colorValue="#dfe2ff" textColor="#0000cc" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #e0d5f9; color: #5229a3;" colorValue="#e0d5f9" textColor="#5229a3" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #fde9f4; color: #854f61;" colorValue="#fde9f4" textColor="#854f61" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #ffe3e3; color: #cc0000;" colorValue="#ffe3e3" textColor="#cc0000" onclick="chooseColor(this)">a</td>
	       </tr>
	       <tr>
	          <td style="background-color: #5a6986; color: #dee5f2;" colorValue="#5a6986" textColor="#dee5f2" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #206cff; color: #e0ecff;" colorValue="#206cff" textColor="#e0ecff" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #0000cc; color: #dfe2ff;" colorValue="#0000cc" textColor="#dfe2ff" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #5229a3; color: #e0d5f9;" colorValue="#5229a3" textColor="#e0d5f9" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #854f61; color: #fde9f4;" colorValue="#854f61" textColor="#fde9f4" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #cc0000; color: #ffe3e3;" colorValue="#cc0000" textColor="#ffe3e3" onclick="chooseColor(this)">a</td>
	       </tr>
	       <tr>
	          <td style="background-color: #fff0e1; color: #ec7000;" colorValue="#fff0e1" textColor="#ec7000" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #fadcb3; color: #b36d00;" colorValue="#fadcb3" textColor="#b36d00" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #f3e7b3; color: #ab8b00;" colorValue="#f3e7b3" textColor="#ab8b00" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #ffffd4; color: #636330;" colorValue="#ffffd4" textColor="#636330" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #f9ffef; color: #64992c;" colorValue="#f9ffef" textColor="#64992c" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #f1f5ec; color: #006633;" colorValue="#f1f5ec" textColor="#006633" onclick="chooseColor(this)">a</td>
	       </tr>
	       <tr>
	          <td style="background-color: #ec7000; color: #fff0e1;" colorValue="#ec7000" textColor="#fff0e1" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #b36d00; color: #fadcb3;" colorValue="#b36d00" textColor="#fadcb3" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #ab8b00; color: #f3e7b3;" colorValue="#ab8b00" textColor="#f3e7b3" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #636330; color: #ffffd4;" colorValue="#636330" textColor="#ffffd4" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #64992c; color: #f9ffef;" colorValue="#64992c" textColor="#f9ffef" onclick="chooseColor(this)">a</td>
	          <td style="background-color: #006633; color: #f1f5ec;" colorValue="#006633" textColor="#f1f5ec" onclick="chooseColor(this)">a</td>
	       </tr>
	       
	    </table>
	</div>
	<div align="center"><input type="text" style="color: white;" id="txtColorTemp" size="20px"  /></div>
</div>

<form action="/cowork/CoworkItemMarkOperation.jsp" target="_parent"  id="labelForm" method="post">
<input type="hidden" name="type" value="setLabel">
<table id='list' class="ListStyle" cellspacing="1" style="margin:0px;width:100%;font-size: 12px;width: 98%;vertical-align: " align="center">
	 	<colgroup>
		<col width="30%">
		<col width="20%">
		<col width="20%">
		<col width="20%">
		</colgroup>
		<tbody id="list_body">
		   <tr class="Header">   
		      <th colspan="4"><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())+SystemEnv.getHtmlLabelName(176,user.getLanguage())+SystemEnv.getHtmlLabelName(22250,user.getLanguage())%></th><!-- 协作区标签设置 -->
		      <th align="right">
		      <input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(176,user.getLanguage())%>" class="btn" onclick="addLabel()" />
		      </th>
		   </tr>
		   <tr class="Header">
		      <th><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())+SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></th> <!-- 标签名称 -->
		      <th>是否显示在Tab页</th><!-- 是否显示在Tab页 -->
		      <th><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())+SystemEnv.getHtmlLabelName(495,user.getLanguage())%></th><!-- 标签颜色 -->
		      <th><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></th><!-- 顺序 -->
		      <th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th><!-- 操作 -->
		   </tr>
		   <%
		   for(int i=0;i<labelList.size();i++){ 
               CoworkLabelVO labelVO=(CoworkLabelVO)labelList.get(i);
               
               String id=labelVO.getId();
               String labelType=labelVO.getLabelType();
               String name=labelVO.getName();
               String labelOrder=labelVO.getLabelOrder();
               String isUsed=labelVO.getIsUsed();
               String labelColor=labelVO.getLabelColor();
               String textColor=labelVO.getTextColor();
               String labelName="";
               if(!labelType.equals("label"))
              	 labelName=SystemEnv.getHtmlLabelName(Util.getIntValue(name),user.getLanguage());
               else
              	 labelName=labelVO.getName();
		   %>
		   <tr id="labelline_<%=id%>">
		      <td><input name="id" type="hidden" value="<%=id%>" /> <input name="name" type="hidden" value="<%=name%>" /> <input type="hidden" name="labelType" value="<%=labelType%>"><%=labelName%></td>
		      <td><input name="isUsed_<%=id%>" type="checkbox" <%if(isUsed.equals("1")){%>checked="checked"<%}%> value="1"></td><!-- 启用 -->
		      <td>
		        <input type="hidden" value="<%=labelColor%>" name="labelColor" id="labelColor_<%=id%>">
		        <input type="hidden" value="<%=textColor%>" name="textColor" id="textColor_<%=id%>">
		        <%if(labelType.equals("label")){%>
		         <SPAN style="BACKGROUND-COLOR: <%=labelColor%>; COLOR: <%=textColor%>;padding:2px" id="<%=id%>" class=colorblock r_attr="background-color" r_id="menuhContainer" colorValue="<%=labelColor%>" textColor="<%=textColor%>"><%=name%></SPAN>
		         <img src='/js/jquery/plugins/farbtastic/color.png' style='cursor:hand;margin-left:3px' align="absmiddle" onclick='doColorClick(this,<%=id%>)' border=0/>
		        <%}%>
		      </td>
		      <td><input name="labelOrder" onblur="isInt(this)" value="<%=labelOrder%>" style="text-align: center;" size="5" maxlength="4"/></td>
		      <td>
		         <%if(labelType.equals("label")){%>
		          <a href="javascript:editLabel(<%=id%>)"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a>&nbsp;&nbsp;&nbsp;<a href="javascript:deleteLabel(<%=id%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><!-- 编辑 删除-->
		         <%}%> 
		      </td>
		   </tr>
		   <%}%>
	    </tbody>
  </table>
  </form>
  <script type="text/javascript">
  
  function addLabel(){
    window.location.href="/cowork/addLabel.jsp";
  }
  
  function chooseColor(obj){
     
     var colorValue=jQuery(obj).attr("colorValue");
     var textColor=jQuery(obj).attr("textColor");
     
     jQuery("#txtColorTemp").attr("colorValue",colorValue);
     jQuery("#txtColorTemp").attr("textColor",textColor);
     jQuery("#txtColorTemp").css("background-color",colorValue);
     jQuery("#txtColorTemp").css("color",textColor);
  }
  
   jQuery(document).ready(function(){
      if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	     //左侧下拉框处理
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
      }
      
	 $("#coloPanel").dialog({
				autoOpen: false,
				draggable:false,
				resizable:false,
				width:200,
				buttons: {
					"<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>":function(){  // 取消
					    $(this).dialog("close");
					},
					"<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>": function() { //确定
						var colorValue=$("#txtColorTemp").attr("colorValue");
						var textColor=$("#txtColorTemp").attr("textColor");
						var objFormId=$("#txtColorTemp").attr("from");	
						
						$("#labelColor_"+objFormId).val(colorValue);	
						$("#textColor_"+objFormId).val(textColor);
						
						$("#"+objFormId).css("background-color",colorValue);
						$("#"+objFormId).css("color",textColor);
						
                        $("#"+objFormId).attr("colorValue",colorValue); 
                        $("#"+objFormId).attr("textColor",textColor); 
                        
						$(this).dialog("close"); 
					}
				} 
			});		
   });
   
   function deleteLabel(labelid){
      if(confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>?")){ //确认删除吗
         $("#labelline_"+labelid).remove();
         $.post("/cowork/CoworkItemMarkOperation.jsp",{type:"deleteLabel",id:labelid},function(data){});
      }
    }
    
    function editLabel(labelid){
      window.location.href="/cowork/addLabel.jsp?type=editLabel&labelid="+labelid;      
    }
    
    function doSave(){
      $("#labelForm").submit();
    }
    
    function isInt(obj){
      var value=$(obj).val()
      if(value!=parseInt(value)){
         alert("<%=SystemEnv.getHtmlLabelName(23086,user.getLanguage())%>");//必须为整数,请重新输入
         $(obj).focus();
      }
    }
    
    //点击颜色弹出框
	function doColorClick(obj,labelid){
	    var colorSpan=jQuery("#"+labelid);
	    
		$("#txtColorTemp").val(colorSpan.text());
		$("#txtColorTemp").css("background-color",colorSpan.attr("colorValue"));
		$("#txtColorTemp").css("color",colorSpan.attr("textColor"));
		$("#txtColorTemp").attr("from",colorSpan.attr("id")); 

		$("#coloPanel").dialog('open');	
		var offset = $(obj).offset();
		

		var coloPanelWidth=$("#coloPanel")[0].parentNode.offsetWidth;
		var coloPanelHeight=$("#coloPanel")[0].parentNode.offsetHeight;


		var rightedge=document.body.clientWidth-event.clientX
		var bottomedge=document.body.clientHeight-event.clientY
		
		if (rightedge<coloPanelWidth)
			$("#coloPanel")[0].parentNode.style.left=document.body.scrollLeft+event.clientX-$("#coloPanel")[0].parentNode.offsetWidth-10
		else
			$("#coloPanel")[0].parentNode.style.left=document.body.scrollLeft+event.clientX+10
			
		
		if (bottomedge<coloPanelHeight)
			$("#coloPanel")[0].parentNode.style.top=document.body.scrollTop+event.clientY-$("#coloPanel")[0].parentNode.offsetHeight
		else
			$("#coloPanel")[0].parentNode.style.top=document.body.scrollTop+event.clientY
	}
  </script>
</body>
</html>
