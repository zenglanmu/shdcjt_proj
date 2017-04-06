<%@page import="weaver.email.domain.MailContact"%>
<%@page import="weaver.email.domain.MailGroup"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />

<html>
	<head>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<link href="/email/css/base.css" rel="stylesheet" type="text/css" />
	</head>
	<body style="background-color: #F8F8F8;">
		<%
			int id = Util.getIntValue(request.getParameter("id"));
			MailContact mailContact = cms.getContact(id, user.getUID());
			ArrayList<MailGroup> groups = mailContact.getGroups();
			HashSet<Integer> groupIdSet = new HashSet<Integer>();
			for(int i=0; i<groups.size(); i++) {
				groupIdSet.add(groups.get(i).getMailGroupId());
			}
			int groupCount = gms.getGroupCount(user.getUID());
			
			String returnvalue=Util.null2String(request.getParameter("returnvalue"));
			String mailAddress = Util.null2String(request.getParameter("sendFrom"));
		
		%>
		
		
		<div id="title" class="font13 bold color333 p-l-20 p-t-5" ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></div>
		<div id="content" class="p-t-5 p-l-20">
			<form method="post" id="fMailContacter" name="fMailContacter"  action="/email/new/MailContacterAddOperation.jsp">
				<input type="hidden" name="groups" value="">
				<%
					if(id == -1) {
				%>
				<input type="hidden" name="method" value="contacterAdd">
				<%	
					} else {
				%>
				<input type="hidden" name="method" value="contacterEdit">
				<input type="hidden" name="id" value="<%=id %>">
				<%	
					}
				%>
				
				<table class="">
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(25034,user.getLanguage()) %>
						</td>
						<td>
							<%
								if(id == -1) {
							%>
							<input value="<%=mailContact.getMailUserName() %>" type="text" class="font12 w-300 styled input" name="mailUserName" id="mailUserName" onchange="checkInput()" >
							<b style="color: red">!</b>
							<%	
								} else {
							%>
							<input value="<%=mailContact.getMailUserName() %>" type="text" class="font12 w-300 styled input" name="mailUserName" id="mailUserName" onchange="checkInput()" >
							<b style="color: red; display: none;">!</b>
							<%	
								}
							%>
						</td>
					</tr>
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(19805,user.getLanguage()) %>
						</td>
						<td>
							<%
								if(id == -1) {
							%>
							<input value="<%=mailAddress %>" type="text" class="font12 w-300 styled input" name="mailUserEmail" id="mailUserEmail" onchange="checkInput()" >
							<b style="color: red">!</b>
							<%	
								} else {
							%>
							<input value="<%=mailContact.getMailAddress() %>" type="text" class="font12 w-300 styled input" name="mailUserEmail" id="mailUserEmail" onchange="checkInput()" >
							<b style="color: red; display: none;">!</b>
							<%	
								}
							%>
						</td>
					</tr>
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(25734,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%=mailContact.getMailUserDesc() %>" type="text" class="font12 w-300 styled input" name="mailUserDesc">
						</td>
					</tr>
				</table>
				<div id="title" class="font13 bold color333 hand w-400 relative m-t-5"  >
					<b class="iconRArr hide" style="left: -10px !important;"></b>
					<b class="iconDArr" style="left: -10px !important;"></b>
					<span><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage()) %></span>
					<div class="line-1 m-b-5">&nbsp;</div>
				</div>
				<table class="">
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(422,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%=mailContact.getMailUserTel() %>" type="text" class="font12 w-300 styled input" name="mailUserMobileP" id="mailUserMobileP">
						</td>
					</tr>
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(421,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%=mailContact.getMailUserTelP() %>" type="text" class="font12 w-300 styled input" name="mailUserTelP" id="mailUserTelP">
						</td>
					</tr>
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(23525,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%=mailContact.getMailUserIMP() %>" type="text" class="font12 w-300 styled input" name="mailUserIMP" id="mailUserIMP">
						</td>
					</tr>
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(19814,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%=mailContact.getMailUserAddressP() %>" type="text" class="font12 w-300 styled input" name="mailUserAddressP">
						</td>
					</tr>
				</table>
				<div id="title" class="font13 bold color333 hand w-400 relative m-t-5" >
					<b class="iconRArr" style="left: -10px !important;"></b>
					<b class="iconDArr hide" style="left: -10px !important;"></b>
			               <span><%=SystemEnv.getHtmlLabelName(15688,user.getLanguage()) %></span>
					<div class="line-1 m-b-5">&nbsp;</div>
				</div>
				<table class=" hide">
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(421,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%= mailContact.getMailUserTelW() %>" type="text" class="font12 w-300 styled input" name="mailUserTelW">
						</td>
					</tr>
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(494,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%= mailContact.getMailUserFaxW() %>" type="text" class="font12 w-300 styled input" name="mailUserFaxW">
						</td>
					</tr>
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(1851,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%= mailContact.getMailUserCompanyW() %>" type="text" class="font12 w-300 styled input" name="mailUserCompanyW" id="mailUserCompanyW">
						</td>
					</tr>
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(27511,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%= mailContact.getMailUserDepartmentW() %>" type="text" class="font12 w-300 styled input" name="mailUserDepartmentW" id="mailUserDepartmentW">
						</td>
					</tr>
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%= mailContact.getMailUserTmailUserPostWelP() %>" type="text" class="font12 w-300 styled input" name="mailUserPostW" id="mailUserPostW">
						</td>
					</tr>
					<tr class="h-25">
						<td class="color333 font12 w-100">
							<%=SystemEnv.getHtmlLabelName(17095,user.getLanguage()) %>
						</td>
						<td>
							<input value="<%= mailContact.getMailUserTemailUserAddressWlP() %>" type="text" class="font12 w-300 styled input" name="mailUserAddressW" id="mailUserAddressW">
						</td>
					</tr>
				</table>
				<div id="title" class="font13 bold color333 hand w-400 relative m-t-5" >
					<%
						if(groupCount <= 0) {
					%>
					<b class="iconRArr" style="left: -10px !important;"></b>
					<b class="iconDArr hide" style="left: -10px !important;"></b>
					<%		
						} else {
					%>
					<b class="iconRArr hide" style="left: -10px !important;"></b>
					<b class="iconDArr" style="left: -10px !important;"></b>
					<%		
						}
					%>
					<span><%=SystemEnv.getHtmlLabelName(81313,user.getLanguage()) %></span>
					<div class="line-1 m-b-5">&nbsp;</div>
				</div>
				<%
					if(groupCount <= 0) {
				%>
				<table class="hide m-t-5">
				<%		
					} else {
				%>
				<table class="m-t-5">
				<%		
					}
				%>
					<tr class="h-25">
						<td class="color333 font12 w-100" valign="top">
							 <%=SystemEnv.getHtmlLabelName(81314,user.getLanguage()) %>
						</td>
						<td>
							<div>
								<ul>
									<%	
									ArrayList<MailGroup> groupList = new ArrayList<MailGroup>();
									if(groupCount > 0) {
										//获得当前用户的所有自定义组列表
										groupList = gms.getGroupsById(user.getUID());
									}
									for(int i=0; i<groupList.size(); i++) {
										MailGroup mailGroup = groupList.get(i);
										if(groupIdSet.contains(mailGroup.getMailGroupId())) {
									%>
									<li class="left m-2">
										<input type="checkbox" checked="checked" class="" name="groupId" value="<%=mailGroup.getMailGroupId() %>" />
										<span class="overText w-50" title="<%=mailGroup.getMailGroupName() %>"><%=mailGroup.getMailGroupName() %></span>
									</li>	
									<%
										} else {
									%>
									<li class="left m-2">
										<input type="checkbox" class="" name="groupId" value="<%=mailGroup.getMailGroupId() %>" />
										<span class="overText w-50" title="<%=mailGroup.getMailGroupName() %>"><%=mailGroup.getMailGroupName() %></span>
									</li>
									<%
										}
									}
									%>
								</ul>
							</div>
						</td>
					</tr>
				</table>
			</form>
		</div>	
	</body>
</html>

<script type="text/javascript">
jQuery(document).ready(function() {
	
	
	<%
		if(!"".equals(returnvalue)){
			if("1".equals(returnvalue)){
	%>
				alert("<%=SystemEnv.getHtmlLabelName(30648,user.getLanguage()) %>!");
				window.parent.closeDialog();
	<%
			}else{
	%>
				alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>!");
	<%		
			}
		}
	%>
	
	checkInput();
	$("div.hand").bind("click", function(){
		$(this).next("table").toggle();
		$(this).find("b").each(function(){
			if($(this).hasClass("hide")) {
				$(this).removeClass("hide");
			} else {
				$(this).addClass("hide");
			}
		});
	});
	//解决弹出的页面按钮在左右和上下模式下，乱码的问题
	try{
		window.parent.document.getElementById("_ButtonOK_0").value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>";
		window.parent.document.getElementById("_ButtonCancel_0").value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>";
	}catch(e){
		
	}
	//$("#_ButtonOK_0").value("确定");
});

//验证
function checkInput() {
	var _form = $("form#fMailContacter");
	var mailUserName = $.trim(_form.find("input#mailUserName").val());
	var mailUserEmail = $.trim(_form.find("input#mailUserEmail").val());
	eamilReg = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/;
	var isName, isEmail;
	
	if(mailUserName==""){
		_form.find("input#mailUserName").next("b").show();
		isName = false;
	} else {
		_form.find("input#mailUserName").next("b").hide();
		isName = true;
	}
	if(mailUserEmail=="" || !eamilReg.test(mailUserEmail)){
		_form.find("input#mailUserEmail").next("b").show();
		isEmail = false;
	} else {
		_form.find("input#mailUserEmail").next("b").hide();
		isEmail = true;
	}
	return isName&&isEmail;
}

//获取表单JSON对象
function getSerialize() {
	var _form = $("form#fMailContacter");
	var _groups = new Array();
	_form.find("input[name=groupId]").each(function(){
		if(this.checked) {
			_groups.push(this.value);
		}
	});
	_form.find("input[name=groups]").val(_groups.toString());
	var _param = _form.serializeArray();
	return _param;
}
function submitDate(){
	if(checkInput()){
				$("#fMailContacter").submit();	
	}else{
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
	}
}
</script>