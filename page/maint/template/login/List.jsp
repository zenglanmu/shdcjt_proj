<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
String styleid =Util.null2String(request.getParameter("styleid"));	
String type = Util.null2String(request.getParameter("type"));
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23140,user.getLanguage());
String needfav ="1";
String needhelp ="";
String message = Util.null2String(request.getParameter("message"));
StyleMaint sm=new StyleMaint(user);
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16388,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>



<html>
 <head>
 <link href="/css/Weaver.css" type="text/css" rel=stylesheet>
 <SCRIPT language="javascript" src="/js/weaver.js"></script>
<link href="/js/jquery/ui/jquery-ui.css" type="text/css" rel=stylesheet>

<!--For Dialog-->
<SCRIPT language="javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.draggable.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.resizable.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.dialog.js"></script>
</head>
<body  id="myBody">
<TABLE width=100% height=100% border="0" cellspacing="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">
    <tr>
      <td height="10" colspan="3"></td>
    </tr>
    <tr>
        <td></td>
        <td valign="top">
			<table class="Shadow">
				<colgroup>
				<col width="1">
				<col width="">
				<col width="10">
				<tr>
					<TD></TD>		
					<td valign="top">
						<table class="liststyle" cellspacing=1>						
							<TR class="header">
								<TH width="5%">ID</TH>
								<TH width="25%"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%><!--名称--></TH>
								<!--<TH width="40%"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>描述</TH>-->
								<TH width="15%"><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%><!--类型--></TH>
								<TH width="15%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><!--预览--></TH>
							</TR>

							<%
							rs.executeSql("select * from pagetemplate order by id");
							int index=0;

							String dirTemplate=pc.getConfig().getString("template.path");
							while(rs.next()){							
								index++;
							%>
							<TR class="<%=index%2==0?"datadark":"datalight"%>">
								<TD><%=rs.getString("id")%></TD>
								<TD><%=rs.getString("templatename")%></TD>
								<TD style="display:none"><%=rs.getString("templatedesc")%></TD>
								<TD><%="cus".equals(rs.getString("templatetype"))?SystemEnv.getHtmlLabelName(19516,user.getLanguage()):SystemEnv.getHtmlLabelName(468,user.getLanguage())%></TD>
								<TD>
								<a href="<%=dirTemplate+rs.getString("dir")%>index.htm" target="_blank"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%><!--预览--></a>
								&nbsp;<a href="<%=dirTemplate+"zip/"+rs.getString("zipName")%>"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><!--下载--></a>
								&nbsp;<a href="#" onclick="onEdit(this)"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><!--编辑--></a>
								&nbsp;<a href="#" onclick="onDel(this)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><!--删除--></a>
								</TD>
							</TR>
							<%}%>
						</table>
					</td>
				</tr><TR style="height:1px;"><TD class=line colspan=3></TD></TR><tr>
				</tr>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
			</table>
			</form>
	    </td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</TABLE>

<div id="divTemplate" title="<%=SystemEnv.getHtmlLabelName(23140,user.getLanguage())%>">
	<FORM  name="frmAdd" method="post" enctype="multipart/form-data" action="Operate.jsp" onSubmit="return actionCheck();">
	<input type="hidden"   name="method" value="add">
	<input type="hidden"   name="templateid">
	<table class="viewform">
		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%><!--名称--></td>
			<td class="field" width="70%">
				<input type="text" class="inputstyle" name="templatename" id="templatename" style="width:95%" onchange='checkinput("templatename","templatenamespan")'>
				<SPAN id=templatenamespan>
	               <IMG src="/images/BacoError.gif" align=absMiddle>
	             </SPAN>
			</td>
		</tr>
		<tr style="height:1px;"><td colspan=2 class="line"></td></tr>
		<tr>
			<td width="30%" ><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!--描述--></td>
			<td class="field" width="70%"><textarea name="templatedesc" id="templatedesc" style='height:70px;width:95%' class=inputStyle onchange='checkinput("templatedesc","templatedescspan")'></textarea>
			<SPAN id=templatedescspan>
	               <IMG src="/images/BacoError.gif" align=absMiddle>
	             </SPAN>
			</td>
		</tr>
		<tr style="height:1px;"><td colspan=2 class="line"></td></tr>
	</table>
	<table class="viewform" id="tblFile">
		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>(.zip)<!--文件--></td>
			<td class="field" width="70%">
				<input type="file"  class="inputstyle" name="templaterar" id="templaterar" style="width:95%" onchange='checkinput("templaterar","templaterarspan")' >
				<SPAN id=templaterarspan>
	               <IMG src="/images/BacoError.gif" align=absMiddle>
	             </SPAN>
			</td>
			
		</tr>
			<!--
		<tr style="height:1px;"><td colspan=2 class="line"></td></tr>

		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(275,user.getLanguage()) %></td>
			<td class="field" width="70%" height='25'>
			  <a href=javascript:openFullWindowForXtable('/page/maint/help/help.jsp?type=template')><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></a>
				<a href="#"><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></a>
			</td>
		</tr>
-->
	</table>
	</FORM>
</div>

</body>
</html>
<script>
	function onAdd(){
		frmAdd.method.value="add";
		$("#templatename").val('');
		$("#templatedesc").val('');
		$("#templatenamespan").children().show();
		$("#templatedescspan").children().show();
		$("#templaterarspan").children().show();
		$("#tblFile").show()
		$("#divTemplate").dialog('open');
	}
	
	function onEdit(obj){		
		frmAdd.method.value="edit";
		frmAdd.templateid.value=$($(obj).parents("tr")[0]).find("td")[0].innerHTML;
		$("#templatename").val($($(obj).parents("tr")[0]).find("td")[1].innerHTML);
		$("#templatenamespan").children().hide();
		$("#templatedesc").val($($(obj).parents("tr")[0]).find("td")[2].innerHTML.replace(new RegExp("<BR>","gm"),"\r\n"));
		$("#templatedescspan").children().hide();
		$("#templaterarspan").children().hide();
		//$("#tblFile").hide()
		$("#divTemplate").dialog('open');	
	}

	function onDel(obj){
		if(isdel()){
			var action  = frmAdd.action;
			var templateid=$($(obj).parents("tr")[0]).find("td")[0].innerHTML;
			$.post(action,{method:'del',templateid:templateid},function(data){
				window.location.reload();
			}); 
		}
	}	

	$(document).ready(function(){
		$("#divTemplate").dialog({
			autoOpen: false,
			resizable:false,
			width:350,
			buttons: {
				"<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>": function() {
					
					if(frmAdd.method.value=='add'){
						if(check_form(frmAdd,'templatename,templatedesc,templaterar')){
							if(checkFileName()){
								frmAdd.submit();
							}
						}
					}else if(frmAdd.method.value=='edit'){
						if(check_form(frmAdd,'templatename,templatedesc')){
							if(checkFileName()){
								frmAdd.submit();
							}
						}
					}
				} 
			} 
		});	
		
		if('<%=message%>'=='1'){
			alert("<%=SystemEnv.getHtmlLabelName(104,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage())%>")
			//window.location.href = "List.jsp"
		}
	});
	
	//判断文件后缀名是否为.zip文件和是否包含中文字符
	function checkFileName(){
		var fileName = document.getElementById("templaterar").value;
		if(fileName!=''){
			fileName=fileName.toLowerCase();   
			var lens=fileName.length;   
			var extname=fileName.substring(lens-4,lens);   
			if(extname!=".zip")   
			{   
			  alert("<%=SystemEnv.getHtmlLabelName(23942,user.getLanguage())%>");  
			  return false;
			} 
			if(/.*[\u4e00-\u9fa5]+.*$/.test(fileName.substr(fileName.lastIndexOf('\\')+1))){
		    	 alert("<%=SystemEnv.getHtmlLabelName(23984,user.getLanguage())%>");  
		    	return false;
		    }
		    
		    return true; 
	    }else{
	    	return true;
	    } 
	}
	//提交判断必填项是否为空
	function actionCheck(){
		var txtName = document.getElementById("templatename").value;
		var descName = document.getElementById("templatedesc").value;
		var rarName = document.getElementById("templaterar").value;
		if(frmAdd.method.value=="add"){
			if(txtName==''||descName==''||rarName==''){
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return false;
			}
		}else if (frmAdd.method.value=="edit"){
			if(txtName==''||descName==''){
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return false;
			}
		}
		return true;
	}
</script>