<%@page import="weaver.email.domain.MailContact"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 

<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>


<html>
	<head>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<link href="/email/css/base.css" rel="stylesheet" type="text/css" />
	</head>
	<body>
		<%
		int mailgroupid = Util.getIntValue(request.getParameter("mailgroupid"));
		String keyword = Util.null2String(request.getParameter("keyword"));
		int userId = user.getUID();
		
		String selectType = "checkbox";
		int pagesize = 10;
		
		String tempBackfields = "";
		String tempFromSql = "";
		String tempSQLWhere = "";
		
		if(mailgroupid == Integer.MAX_VALUE) {
			tempBackfields = "a.id, a.mailUserName, a.mailaddress, a.mailUserMobileP";
			tempFromSql = "MailUserAddress a";
			tempSQLWhere = "a.userId="+ userId;
		} else if(mailgroupid == Integer.MIN_VALUE) {
			tempBackfields = "a.id, a.mailUserName, a.mailaddress, a.mailUserMobileP";
			tempFromSql = "MailUserAddress a";
			tempSQLWhere = "a.id not in (select contactId from GroupAndContact) and a.userId="+ userId;
		} else {
			tempBackfields = "a.id, a.mailUserName, a.mailaddress, a.mailUserMobileP, b.groupId";
			tempFromSql = "MailUserAddress a, GroupAndContact b";
			tempSQLWhere = "a.id=b.contactId and a.userId="+ userId +" and b.groupId="+ mailgroupid;
		}
		
		if(!keyword.trim().equals("")){
			tempSQLWhere += " and ( a.mailUserName like '%"+keyword+"%' or a.mailaddress like '%"+keyword+"%'  or a.mailUserMobileP like '%"+keyword+"%')";
		}
		
		
		String backfields = tempBackfields;
		String fromSql  = tempFromSql;
		String sqlWhere = tempSQLWhere;
		String orderby = "a.id" ;
		String tableString =" <table instanceid=\"contacts\" tabletype=\""+ selectType +"\" pagesize=\""+ pagesize +"\" >"+   
		"	        <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+sqlWhere+"\"  sqlorderby=\""+ orderby +"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqldistinct=\"true\"/>"+
		"			<head>"+
		"				<col width=\"200\"  text=\""+ SystemEnv.getHtmlLabelName(25034,user.getLanguage()) +"\" column=\"id\" orderkey=\"a.mailUserName\" transmethod=\"weaver.email.service.ContactManagerService.getHrefMailUserName\" otherpara=\"column:mailUserName\" />"+ 
		"				<col width=\"180\"  text=\""+ SystemEnv.getHtmlLabelName(19805,user.getLanguage()) +"\" column=\"mailaddress\" orderkey=\"a.mailaddress\" transmethod=\"weaver.email.service.ContactManagerService.getHrefMailAddress\" />"+ 
		"				<col width=\"120\"  text=\""+ SystemEnv.getHtmlLabelName(22482,user.getLanguage()) +"\" column=\"mailUserMobileP\" orderkey=\"a.mailUserMobileP\" />"+ 
		"				<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(81312,user.getLanguage()) +"\" column=\"id\" transmethod=\"weaver.email.service.ContactManagerService.getGroupNames\" />"+
		"			</head>"+   			
		"</table>";
		%>
		<div class="relative p-t-15">
			<div>
				<div class="left">
					<div id="toolBar" class="relative">
						<button id="writeMail" class="btnGray1 left" onclick="writeMail()" title="<%=SystemEnv.getHtmlLabelName(81300,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(81300,user.getLanguage()) %></button>
						<%
						if(!(mailgroupid==Integer.MAX_VALUE ||  mailgroupid==Integer.MIN_VALUE)) {
						%>
						<button id="moveToGroup" class="btnGray1 left" target="#moveGroups" onclick="moveToGroup(this,event)" title="<%=SystemEnv.getHtmlLabelName(81296,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(81296,user.getLanguage()) %></button>
						<%	
						}
						%>
						<button id="copyToGroup" class="btnGray1 left" target="#copyGroups" onclick="copyToGroup(this,event)" title="<%=SystemEnv.getHtmlLabelName(31267,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(31267,user.getLanguage()) %></button>
						<button id="deleteContact" class="btnGray1 left" onclick="deleteContacts()" title="<%=SystemEnv.getHtmlLabelName(81299,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(81299,user.getLanguage()) %></button>
						<%
						if(!(mailgroupid==Integer.MAX_VALUE ||  mailgroupid==Integer.MIN_VALUE)) {
						%>
						<button id="deleteGroup" class="btnGray1 left" onclick="deleteGroup(<%=mailgroupid %>)" title="<%=SystemEnv.getHtmlLabelName(30908,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(30908,user.getLanguage()) %></button>
						<%	
						}
						%>
					</div>
				</div>
				<form action="/email/new/ContactList.jsp">
				
		
				<div class="left  m-l-15 m-t-1">
					<div id="searchBar" class="left">
						<input class="left" style="width: 176px" type="text" name="keyword" id="keyword" value="<%=keyword%>">
						<div id="searchBtn" class="left"  style="height: 23px;width: 23px;cursor: pointer;padding-top: 5px;padding-left: 3px;">
								<img src="/email/images/search.png"  />
						</div>
						<div class="clear"></div>
					</div>
				</div>
					<input type="hidden" name="mailgroupid" id="mailgroupid" value="<%=mailgroupid%>">	
				</form>
				<div class="clear"></div>
			</div>
			
			<wea:SplitPageTag tableString="<%=tableString%>"  mode="run" showExpExcel="true" isShowTopInfo="false" isShowBottomInfo="true" />
		</div>
		
		
		<!-- Load组列表 -->
		<div id="moveGroups" class="absolute hide w-120 maxh-400 ofy-scroll groups">
			<div id="groupContain"></div>
			<div class="w-all groupiteam hand" method="cmtg" onclick="addGroup(this)">
				<span class="overText w-90"><%=SystemEnv.getHtmlLabelName(31194,user.getLanguage()) %></span>
			</div>
		</div>
		<!-- Load组列表 -->
		<div id="copyGroups" class="absolute hide w-120 maxh-400 ofy-scroll groups">
			<div id="groupContain"></div>
			<div class="w-all groupiteam hand" method="cctg" onclick="addGroup(this)">
				<span class="overText w-90"><%=SystemEnv.getHtmlLabelName(31195,user.getLanguage()) %></span>
			</div>
		</div>
		
	</body>
	
	<style>
	.groups {
	border-style: solid;
	border-color: #BBB;
	border-width: 1px;
	border-radius: 3px;
	}
	.groupiteam {
		height: 26px;
		background-color: #F6F6F6;
		color: black;
		padding: 0px 10px 0px 10px;
		line-height: 25px;
	}
	.groupiteamhover {
		background-color: #E6E6E6;;
	}
	.popWindow{
      width:450px;
      height:auto;
      box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
      border: 2px solid #90969E;
      background: #ffffff;
	}
	#_xTable {
		padding: 0px!important;
	}
	.searchFrom{
	 	background: url('/email/images/search.png') no-repeat;
	 	width: 23px;
	 	height: 23px;
	 	cursor: pointer;
	 	background-position-x: 5px;
	 	background-position-y: 5px;
	 }
	 .clearFrom{
	  	color:#cccccc;
	 	width: 23px;
	 	height: 23px;
	 	cursor: pointer;
	 	font-family: verdana!important;
	 }
	</style>
	
	<script type="text/javascript">
	jQuery(document).ready(function() {
		$("body").click(function() {
			$("div.groups").hide();
		});
		
		reLoadGroups(<%=mailgroupid %>);
		
		$("#searchBtn").bind("click",function(){
			$("form")[0].submit();
		})
	});
	
	//刷新【移动到组】和【复制到组】中的组列表
	function reLoadGroups(currentGroup) {
		var param = {"currentGroup": currentGroup};
		$.get("/email/new/GroupList.jsp", param, function(data) {
			var _moveGroups = $("#moveGroups").find("#groupContain");
			var _copyGroups = $("#copyGroups").find("#groupContain");
			_moveGroups.html(data);
			_copyGroups.html(data);
			initMoveToGroup(_moveGroups);
			initCopyToGroup(_copyGroups);
			
			inithover();
		});
		
		function inithover() {
			var _groupiteam = $("div.groupiteam");
			_groupiteam.mouseover(function() {
				$(this).addClass("groupiteamhover");
			});
			_groupiteam.mouseout(function(){
				$(this).removeClass("groupiteamhover");
			});
		}
	}
	
	//智能显示被隐藏的组列表
	function capacity(himself) {
		var _position = $(himself).offset();
		var _targer = $(himself).attr("target");
		$(_targer).css({top: _position.top+26, left: _position.left});
		$("div.groups").each(function() {
			if(this != $(_targer)[0]) {
				$(this).hide();
			}
		});
		$(_targer).toggle();
	}
	
	//移动到组
	function moveToGroup(himself,event){
		stopEvent(event);
		capacity(himself);
	}
	
	//移动到组 
	function initMoveToGroup(groups){
		$(groups).find("div").bind("click", function(){
			var gourp = this;
			var contactsId = getContactsId();
			if(contactsId.length != 0) {
				var param = {"idSet": contactsId.toString(), "sourceGroup": <%=mailgroupid %>, "destGroup": gourp.id, "method": "move"};
				$.get("/email/new/ContactManageOperation.jsp", param, function(){
					window.parent.loadContactsTree();
					_table.reLoad(); //重新加载当前联系人列表
				});
			} else {
				alert("<%=SystemEnv.getHtmlLabelName(81308,user.getLanguage()) %>"); 
			}
		})
	}
	
	//复制到组
	function copyToGroup(himself,event){
		stopEvent(event);
		capacity(himself);
	}
	
	//复制到组
	function initCopyToGroup(groups){
		$(groups).find("div").bind("click", function(){
			var gourp = this;
			var contactsId = getContactsId();
			if(contactsId.length != 0) {
				var param = {"idSet": contactsId.toString(), "sourceGroup": <%=mailgroupid %>, "destGroup": gourp.id, "method": "copy"};
				$.get("/email/new/ContactManageOperation.jsp", param, function(){
					window.parent.loadContactsTree();
					_table.reLoad(); //重新加载当前联系人列表
				});
			} else {
				alert("<%=SystemEnv.getHtmlLabelName(81308,user.getLanguage()) %>"); 
			}
		})
	}
	
	//删除联系人
	function deleteContacts(){
		var contactsId = getContactsId();
		window.parent.deleteContacts(contactsId, <%=mailgroupid %>);
	}
	
	//写信
	function writeMail(){
		var contactMailAddresses = getContactMailAddress();
		if(contactMailAddresses.length != 0) {
			var param = contactMailAddresses.toString();
			window.open("/email/new/MailAdd.jsp?to="+param, "mainFrame", true);
		} else {
			alert("<%=SystemEnv.getHtmlLabelName(81306,user.getLanguage()) %>"); 
		}
	}
	
	//删除组
	function deleteGroup(currentGroup){
		if(currentGroup==<%=Integer.MAX_VALUE %> || currentGroup==<%=Integer.MIN_VALUE %>) {
			alert("<%=SystemEnv.getHtmlLabelName(30909,user.getLanguage()) %>");
		} else {
			var r=confirm("确定要删吗");
			if(r==true) {
				var param = {"id": currentGroup, "method": "delete"};
				$.get("/email/new/GroupManageOperation.jsp", param, function() {
					window.parent.loadContactsTree();
				});
			}
		}
	}
	
	//获取被选中联系人id
	function getContactsId(){
		var _contactsId = new Array();
		
		$("table.ListStyle tbody").find(":checked").each(function(){
			var _id = $(this).attr("checkboxid");
			if(_id != "")
				_contactsId.push(_id);
		});
		
		return _contactsId;
	}

	//获取被选中联系人的邮箱地址
	function getContactMailAddress(){
		var contactMailAddresses = new Array();
		$("table.ListStyle tbody").find(":checked").each(function(){
			var _mailAddress = $(this.parentNode.parentNode).find("a#mailAddress").html();
			if(_mailAddress!=null || _mailAddress!="") {
				contactMailAddresses.push(_mailAddress);
			}
		});
		return contactMailAddresses;
	}
	
	//删除页面中选中的联系人
	function deletePageContact(){
		$("table.ListStyle tbody").find(":checked").each(function(){
			var iteam = $(this).parent().parent();
			$(iteam).remove();
		});
	}
	
	//阻止事件冒泡
	function stopEvent(event) {
		if (event.stopPropagation) { 
			// this code is for Mozilla and Opera 
			event.stopPropagation();
		} 
		else if (window.event) { 
			// this code is for IE 
			window.event.cancelBubble = true; 
		}
	}

	//载入指定的联系人
	function loadContact(id) {
		window.parent.loadContact(id);
	}
	
	//【新建并移动到组】，【新建并复制到组】
	function addGroup(himself) {
		window.parent.addGroup(himself);
	}
	</script>
</html>