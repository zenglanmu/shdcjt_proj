<%@ page language="java" contentType="text/html; charset=gbk"%>
<%@ include file="/systeminfo/init.jsp"%>
<%
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(24266, user.getLanguage())+":" + SystemEnv.getHtmlLabelName(611, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	String showTop = Util.null2String(request.getParameter("showTop"));
%>

<html>
	<head>
		<title></title>
		<meta http-equiv="content-type" content="text/html; charset=gbk" />
	<head>
		<script type="text/javascript" src="/js/weaver.js"></script>
		<script type="text/javascript" language="javascript"
			src="/wui/common/js/ckeditor/ckeditor.js"></script>
		<script type="text/javascript" language="javascript"
			src="/wui/common/js/ckeditor/ckeditorext.js"></script>
		<script language="javascript" type="text/javascript">
		var lang=<%=(user.getLanguage() == 8) ? "true" : "false"%>;
		window.onload=function(){
			CkeditorExt.initEditor('fMailSign','signContent',lang,'','300px');
		};
		</script>
		<script type="text/javascript">
		function doSubmit(){
			if(check_form(fMailSign,'signName')){
			with(document.getElementById("fMailSign")){
				CkeditorExt.updateContent();
				
				submit();
			}}
		}
		</script>
		<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
	</head>
	<body>
		<%if(showTop.equals("")) {%>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
		<%} else if(showTop.equals("show800")) {%>
			
		<%}%>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:doSubmit(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",javascript:history.back(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		<table style="width: 100%; height: 96%; border-collapse: collapse">
			
			<tr>
				<td valign="top">
					<table class=Shadow>
						<tr>
							<td valign="top">
								<!--==========================================================================================-->
								<form method="post" action="MailSignOperation.jsp" id="fMailSign" name="fMailSign"
									enctype="multipart/form-data">
									<input type="hidden" name="operation" value="add" />
									<input type="hidden" name="userid" value="<%=request.getParameter("userid")%>" />
									<%if(showTop.equals("")) {%>
									
									<%} else if(showTop.equals("show800")) {%>
									<input type="hidden" name="showTop" value="show800" />
									<%}%>
									<table class="ViewForm">
										<colgroup>
											<col width="25%">
											<col width="75%">
										</colgroup>
										<tbody>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(20148, user.getLanguage())%><!-- 签名 --></td>
												<td class="Field">
													<input type="text" name="signName" class="inputstyle" style="width: 90%" onChange="checkinput('signName','signNameSpan')" />
													<span id="signNameSpan"><img src='/images/BacoError.gif' align="absMiddle"></span>
												</td>
											</tr>
											<tr style="height:1px">
												<td class="Line" colspan="2"></td>
											</tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></td>
												<td class="Field">
													<input type="text" name="signDesc" class="inputstyle" style="width: 100%" />
												</td>
											</tr>
											<tr style="height:1px">
												<td class="Line" colspan="2"></td>
											</tr>
											<tr>
												<td colspan="2">
													<textarea name="signContent" id='signContent'
														style="display: none; width: 100%; height: 500px"></textarea>
												</td>
											</tr>
											<tr style="height:1px">
												<td class="Line" colspan="2"></td>
											</tr>
									</table>
								</form>
								<!--==========================================================================================-->
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
		</table>
	</body>
</html>