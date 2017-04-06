<%@ page language="java" contentType="text/html; charset=gbk"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp"%>
<%
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(24266, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	int id = Util.getIntValue(request.getParameter("id"));
	String signName = "";
	String signDesc = "";
	String signContent = "";
	
	String showTop = Util.null2String(request.getParameter("showTop"));
	
	String sql = "select * from MailSign where id="+id;
	rs.executeSql(sql);
	if(rs.next())
	{
		signName = rs.getString("signName");
		signDesc = rs.getString("signDesc");
		signContent = rs.getString("signContent");
		rs1.execute("select id ,isfileattrachment,fileContentId from MailResourceFile where signid="+id+" and isfileattrachment=0");
		while(rs1.next()){ 
		    String isfileattrachment = rs1.getString("isfileattrachment");
		    String imgId = rs1.getString("id");
		    String thecontentid = rs1.getString("fileContentId");
		    String oldsrc = "cid:" + thecontentid ;
		    String newsrc = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+imgId;
		    if(signContent.indexOf(oldsrc)!= -1){
		        signContent = signContent.replace(oldsrc,newsrc);
		    }
		                        
		}
	}
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
								<form method="post" action="MailSignOperation.jsp" id="fMailSign" name="fMailSign" enctype="multipart/form-data">
									<input type="hidden" name="operation" value="update" />
									<input type="hidden" name="id" value="<%=id %>" />
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
												<td><%=SystemEnv.getHtmlLabelName(20148, user.getLanguage())%><!-- Ç©Ãû --></td>
												<td class="Field">
													<input type="text" name="signName" class="inputstyle" style="width: 90%" onChange="checkinput('signName','signNameSpan')" value="<%=signName %>"/>
												</td>
											</tr>
											<tr style="height:1px">
												<td class="Line" colspan="2"></td>
											</tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></td>
												<td class="Field">
													<input type="text" name="signDesc" class="inputstyle" style="width: 100%" value="<%=signDesc %>"/>
												</td>
											</tr>
											<tr style="height:1px">
												<td class="Line" colspan="2"></td>
											</tr>
											<tr>
												<td colspan="2">
													<textarea name="signContent" id="signContent" style="display: none; width: 100%; height: 500px"><%=signContent %></textarea>
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