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
String message = Util.null2String(request.getParameter("message"));

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23011,user.getLanguage());
String needfav ="1";
String needhelp ="";

StyleMaint sm=new StyleMaint(user);
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(19407,user.getLanguage())+",javascript:onAdd(),_self} " ;
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
        <%
										
										if("isused".equals(message)){
											out.println("<div style='color:red'>"+SystemEnv.getHtmlLabelName(28664,user.getLanguage())+"</div>");
										}
										%>
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
								<TH width="15%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><!--操作--></TH>
							</TR>

							<%
							rs.executeSql("select * from pagelayout order by id");
							int index=0;

							String dirlayout=pc.getConfig().getString("layout.path");
							while(rs.next()){							
								index++;
							%>
							<TR class="<%=index%2==0?"datadark":"datalight"%>">
								<TD><%=rs.getString("id")%></TD>
								<TD><%=rs.getString("layoutname")%></TD>
								<TD style="display:none"><%if("cus".equals(rs.getString("layouttype"))){ 
										out.print(rs.getString("layoutdesc"));
									}else{
										out.print(SystemEnv.getHtmlLabelName(rs.getInt("layoutdesc"),user.getLanguage()));
									}%></TD>
								<TD><%="cus".equals(rs.getString("layouttype"))?SystemEnv.getHtmlLabelName(19516,user.getLanguage()):SystemEnv.getHtmlLabelName(468,user.getLanguage())%></TD>
								<TD>
								<%if("cus".equals(rs.getString("layouttype"))){ %>
								<a href="<%=dirlayout+rs.getString("layoutdir")%>index.htm" target="_blank"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%><!--预览--></a>
								&nbsp;<a href="<%=dirlayout+"zip/"+rs.getString("zipName")%>"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><!--下载--></a>
								&nbsp;<a href="#" onclick="onEdit(this)"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><!--编辑--></a>
								&nbsp;<a href="#" onclick="onDel(this)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><!--删除--></a>
								<%}else{ %>
								<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%><!--预览-->
								&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><!--下载-->
								&nbsp;<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
								&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><!--删除-->
								
								<%}%>
								</TD>
							</TR>
							<%}%>
						</table>
					</td>
				</tr><TR><TD class=line colspan=3></TD></TR><tr>
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

<div id="divlayout" title="<%=SystemEnv.getHtmlLabelName(23011,user.getLanguage())%>">
	<FORM  name="frmAdd" method="post" enctype="multipart/form-data" action="Operate.jsp">
	<input type="hidden"   name="method" value="add">
	<input type="hidden"   name="layoutid">
	<table class="viewform">
		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%><!--名称--></td>
			<td class="field" width="70%">
				<input type="text" class="inputstyle" name="layoutname" id="layoutname" style="width:95%" onchange='checkinput("layoutname","layoutnamespan")'>
				<SPAN id=layoutnamespan>
	               <IMG src="/images/BacoError.gif" align=absMiddle>
	             </SPAN>
			</td>
		</tr>
		<tr><td colspan=2 class="line"></td></tr>
		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!--描述--></td>
				<td class="field" width="70%"><textarea name="layoutdesc" id="layoutdesc" style='height:70px;width:95%' class=inputStyle onchange='checkinput("layoutdesc","layoutdescspan")'></textarea>
				<SPAN id=layoutdescspan>
	               <IMG src="/images/BacoError.gif" align=absMiddle>
	             </SPAN>
				</td>
			</td>
		</tr>
		<tr><td colspan=2 class="line"></td></tr>
	</table>
	<table class="viewform" id="tblFile">
		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>(.zip)<!--文件--></td>
			<td class="field" width="70%">
				<input type="file"  class="inputstyle" name="layoutrar" id="layoutrar" style="width:95%" onchange='checkinput("layoutrar","layoutrarspan")'>
				<SPAN id=layoutrarspan>
	               <IMG src="/images/BacoError.gif" align=absMiddle>
	             </SPAN>
			</td>
		</tr>
		<!-- 
		<tr><td colspan=2 class="line"></td></tr>

		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(275,user.getLanguage()) %></td>
			<td class="field" width="70%" height='25'>
				<a href=javascript:openFullWindowForXtable('/page/maint/help/help.jsp?type=layout')><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></a> 
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
		$("#layoutname").val('');
		$("#layoutdesc").val('');
		$("#layoutnamespan").children().show();
		$("#layoutdescspan").children().show();
		$("#layoutrarspan").children().show();
		$("#tblFile").show()
		$("#divlayout").dialog('open');	
	}
	
	function onEdit(obj){
		
		frmAdd.method.value="edit";
		frmAdd.layoutid.value=obj.parentNode.parentNode.childNodes[0].innerHTML;
		$("#layoutname").val(obj.parentNode.parentNode.childNodes[1].innerHTML);
		$("#layoutnamespan").children().hide();
		$("#layoutdesc").val($($(obj).parents("tr")[0]).find("td")[2].innerHTML.replace(new RegExp("<BR>","gm"),"\r\n"));
		$("#layoutdescspan").children().hide();
		$("#layoutrarspan").children().hide();
		//$("#tblFile").hide()
		$("#divlayout").dialog('open');	
	}


	function onDel(obj){
		if(isdel()){
			frmAdd.method.value="del";
			frmAdd.layoutid.value=obj.parentNode.parentNode.childNodes[0].innerHTML;
			obj.disabled=true;
			frmAdd.submit();			
		}
	}
	

	$(document).ready(function(){
		$("#divlayout").dialog({
			autoOpen: false,
			resizable:false,
			width:350,
			buttons: {
				"<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>": function() {
					
					if(frmAdd.method.value=='add'){
						if(check_form(frmAdd,'layoutname,layoutdesc,layoutrar')){
							if(checkFileName()){
								frmAdd.submit();
							}
							
						}
					}else if(frmAdd.method.value=='edit'){
						if(check_form(frmAdd,'layoutname,layoutdesc')){
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
			//window.location.href = "LayoutList.jsp"
		}
	});
	
	//判断文件后缀名是否为.zip文件和是否包含中文字符
	function checkFileName(){
		var fileName = document.getElementById("layoutrar").value;
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
</script>