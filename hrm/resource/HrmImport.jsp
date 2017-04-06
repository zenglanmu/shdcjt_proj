<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<SCRIPT language="javascript" src="/js/checkinput.js"></script>
<%
	if (!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",
			user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

<SCRIPT language="javascript" src="/js/jquery/jquery.js"></script>

<!--For Jquery UI-->
<link href="/js/jquery/ui/jquery-ui.css" type="text/css" rel=stylesheet>
<script type="text/javascript" src="/js/jquery/ui/ui.core.js"></script>
<!--For Dialog-->
<script type="text/javascript" src="/js/jquery/ui/ui.dialog.js"></script>
    
<STYLE type=text/css>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
    display:none;
}
</STYLE>

</head>
<%
	String imagefilename = "/images/hdHRMCard.gif";
	String titlename = SystemEnv.getHtmlLabelName(17887, user
			.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmMain name=frmMain action="HrmImportProcess.jsp" method=post enctype="multipart/form-data" target="subframe">
<DIV>
<BUTTON class=btnSave type="button" accessKey=S  onClick="dosubmit(this)"><U>S</U>-<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%></BUTTON>
&nbsp;&nbsp;&nbsp;&nbsp;
<BUTTON class=btnSave type="button" accessKey=H style="width:156px" onClick="openHistoryLog()"><U>H</U>-<%=SystemEnv.getHtmlLabelName(24644, user.getLanguage())%></BUTTON>
</DIV>
<br>
  <table class=Viewform>
    <COLGROUP> <COL width="15%"> <COL width="85%"> <tbody> 
    <tr class=Title> 
      <td><nobr><b><%=SystemEnv.getHtmlLabelName(1867, user.getLanguage())
					+ SystemEnv.getHtmlLabelName(563, user.getLanguage())%></b></td>
      <td align=right></td>
    </tr>
    <tr class=spacing style="height:2px"> 
      <td class=Line1 colspan=2></td>
    </tr>

    <tr class=spacing> 
      <td><%=SystemEnv.getHtmlLabelName(24638, user.getLanguage())%></td>
      <td class=Field>
        <select name="keyField" id="keyField" style="width: 80px;">
            <option value="workcode"><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></option>
            <option value="loginid"><%=SystemEnv.getHtmlLabelName(412, user.getLanguage())%></option>
            <option value="lastname"><%=SystemEnv.getHtmlLabelName(413, user.getLanguage())%></option>
        </select>
        <span style="" >
                <%=SystemEnv.getHtmlLabelName(24646, user.getLanguage())%>
        </span>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan="2"></TD></TR>
     <tr class=spacing>
         <td><%=SystemEnv.getHtmlLabelName(24863, user.getLanguage())%></td>
         <td class=Field>
             <select id="importType" name="importType" style="width: 80px">
                 <option value="add"><%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></option>
                 <option value="update"><%=SystemEnv.getHtmlLabelName(17744, user.getLanguage())%></option>
             </select>
        </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan="2"></TD></TR>
    <tr class=spacing> 
      <td><%=SystemEnv.getHtmlLabelName(16699, user.getLanguage())%></td>
      <td class=Field>
        <input class=inputstyle style="width: 360px" type="file" name="excelfile" onchange='checkinput("excelfile","excelfilespan");this.value=trim(this.value)'><SPAN id=excelfilespan>
               <IMG src="/images/BacoError.gif" align=absMiddle>
              </SPAN>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr><td colspan="2" height="10px"></td></tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(22272, user.getLanguage())%></td>
      <td><a href='/hrm/resource/inputexcellfile/hrminput.xls'><%=SystemEnv.getHtmlLabelName(22273, user.getLanguage())%></a>&nbsp;</td>
    </tr> 
    <tr class=spacing><td colspan="2" height="8px"></td></tr>
    <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR>
    </tbody> 
  </table>  
   <!-- 隐藏提交iframe -->
   <iframe name='subframe' id="subframe" style='display:none'></iframe>
  
</form>
  <br>
  <br>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>

<!-- 导入等待 -->
 <div id="loading">	
		<span  id="loading-msg"><img src="/images/loading2.gif"><%=SystemEnv.getHtmlLabelName(24635, user.getLanguage())%></span>
 </div>

<!-- 结果展示弹出层 -->
<div id="divInfo" title="<%=SystemEnv.getHtmlLabelName(24635, user.getLanguage())%>">
     <DIV style="BORDER-BOTTOM: #bbbbbb 1px solid; width:100%;height:480px">
	        <DIV id="content" style="OVERFLOW-y: auto;OVERFLOW-x: hidden; WIDTH: 100%px; HEIGHT: 480px">
				 <TABLE id="head" class=ListStyle cellspacing=1 border="0" cellspacing="0" width="100%" style="display: none">
			        <TR class=Header>
			            <TD width="10%" id="keyColum"><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></TD>
				        <TD width="55%"><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></TD>
				        <TD width="10%"><%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></TD>
						<TD width="25%"><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%></TD>
			        </TR>
			      </TABLE>
			      <div id="result"></div>
           </DIV>
	 </DIV>
      <div style="padding-top: 5px" align="center">
			<input id="closeBtn"  disabled="disabled" type="button" value="[<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>]" style="cursor: hand;" onclick="closeDiv();">
		    <span id="downLogFile" style="padding-left: 20px"></span>
	  </div>  
</div>
<iframe id="downLoad" src="" style="display: none;"></iframe>
<script language=javascript>
var index=0; //控制从resultList中读取数据的位置   
var timeId;  //定时器

/*jQuery dialog 初始化*/
$("#divInfo").dialog({   
			autoOpen: false,
        	modal: true, 
        	height: 500,
        	width:  650,
        	draggable: false,
        	resizable: false
	     });
	     
	     
/*提交请求，通过隐藏iframe提交*/
function dosubmit(obj) {
	$("#result").html("");
    if(check_form(document.frmMain,'excelfile')) {
    	var keyFieldValue=$("#keyField").val();    //获取重复性验证字段，在显示日志中只显示重复性验证列
        if(keyFieldValue=="workcode")      //编号
            $("#keyColum").html("<%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%>");
        else if(keyFieldValue=="loginid")  //登录名 
            $("#keyColum").html("<%=SystemEnv.getHtmlLabelName(412, user.getLanguage())%>");    
        else if(keyFieldValue=="lastname") //姓名
            $("#keyColum").html("<%=SystemEnv.getHtmlLabelName(413, user.getLanguage())%>");
        $("#divInfo").dialog('open');   //打开dialog
        //$("#keyField").hide();          //隐藏select 在IE6中bug
        //$("#importType").hide();
        $(".ui-dialog-titlebar-close").css("display","none");//隐藏 jQuery dialog 标题栏默认的关闭按钮
        $( "#divInfo" ).dialog( "option", "title", '<%=SystemEnv.getHtmlLabelName(24635, user.getLanguage())%>' );  //设置状态为正在导入
	    index=0;   //初始化为 0     
        timeId=window.setInterval(getData,2000); //定时读取
        $("#loading").css("display","block");
        document.frmMain.submit() ; 
    }
}

/*每次读取都返回，读取位置，如果调用该函数则说明，显示的事导入结果*/
function changeIndex(resultIndex){
  index=resultIndex;
  $("#head").css("display","block"); 
}

/*读取数据 index 为开始读取位置*/
function getData(){
	$.get("HrmImportLog.jsp?index="+index,function(data){
		 $("#result").html(data);
	});
}

/*返回处理函数 message状态 logfile导入日志文件名*/
function callback(message,logFile){
   window.clearInterval(timeId);
   $("#loading").css("display","none");
   $("#closeBtn").attr("disabled",false);
   
   if(message=='error'){
      $( "#divInfo" ).dialog( "option", "title", '<%=SystemEnv.getHtmlLabelName(24647, user.getLanguage())%>' );  //设置状态为错误提示
   }
   if(message=='ok'){
     $( "#divInfo" ).dialog( "option", "title", '<%=SystemEnv.getHtmlLabelName(24645, user.getLanguage())%>' );  //设置状态为导入完成
     if(logFile!='null')
       $("#downLogFile").html("<%=SystemEnv.getHtmlLabelName(24835, user.getLanguage())%>  <a id=log href='#' onclick=\"downLoadLog('"+logFile+"')\"><%=SystemEnv.getHtmlLabelName(258, user.getLanguage())%></a>");
   }
}


/*关闭弹出层刷新页面*/
//  function closeDiv(){
//   $("#divInfo").dialog("close");      //关闭dialog
//   window.location.reload();
//}

//modify yangdacheng 2011-12-02
/*关闭弹出层不刷新页面*/
  function closeDiv(){
   $("#divInfo").dialog("close");      //关闭dialog

}


/*打开历史导入记录*/
function openHistoryLog(){
	$("#result").html("");
var tableHead = "  <TABLE class=ListStyle cellspacing=1 >" +
		 "<TBODY>" + 
		 "<TR class=Header>" + 
		 "<TD width=\"30%\"><%=SystemEnv.getHtmlLabelName(20515,user.getLanguage())%></TD>" + 
		 "<td width=\"50%\"><%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></td>" + 
		 "<TD width=\"10%\"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></TD>" + 
		 "<TD width=\"10%\"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%></TD>" + 
		 "</TR></TBODY>" + 
		 "</TABLE>";

  $("#divInfo").dialog('open');   //打开dialog
  //$("#keyField").hide();
  //$("#importType").hide();
  $(".ui-dialog-titlebar-close").css("display","none");//隐藏 jQuery dialog 标题栏默认的关闭按钮
  $( "#divInfo" ).dialog( "option", "title", '<%=SystemEnv.getHtmlLabelName(24644, user.getLanguage())%>' );  //设置状态为导入历史记录
  $.get("HrmImportHistoryLog.jsp",function(data){
		 //$("#result").append(data);
	   if ($("#result").html() == "") {
		  $("#result").append(tableHead);
       }
	   $("#result").children("TABLE").children("TBODY").append(data);
	});
}
/*下载导入日志*/
function downLoadLog(path){
  $("#downLoad").attr("src","HrmImportHistoryLog.jsp?option=downLoad&path="+path);
}
/*删除日志文件*/
function deleteLog(path,obj){
  if(window.confirm('<%=SystemEnv.getHtmlLabelName(23271, user.getLanguage())%>'+"?"))
  $.post("HrmImportHistoryLog.jsp?option=delete&path="+path,function(data){
      if($.trim(data)=="true")
        $(obj).parent().parent().remove();
  });
}
</script>

</BODY>
</HTML>