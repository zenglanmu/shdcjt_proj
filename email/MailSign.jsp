<%@ page language="java" contentType="text/html; charset=gbk"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init.jsp"%>
<%
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = "" + SystemEnv.getHtmlLabelName(24266, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	
	String showTop = Util.null2String(request.getParameter("showTop"));

	int userId = Util.getIntValue(request.getParameter("userid"));
	if (userId == -1)
	{
		userId = user.getUID();
	}
%>

<html>
	<head>
		<title></title>
		<meta http-equiv="content-type" content="text/html; charset=gbk" />
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
		<style type="text/css">
		.href {
			color: blue;
			text-decoration: underline;
			cursor: hand
		}
		</style>
		<script type="text/javascript">
			function submitForRule(){
			    var chk = document.getElementsByName("isActive");
				for(var i=0;i<chk.length;i++){
					if(chk[i].checked){
						fMailSign.defaultSignId.value = chk[i].value;
					}
				}
			     
				fMailSign.submit();
			 }
			function radioBox(himself) {
				var chk = document.getElementsByName("isActive");
				for(var i=0;i<chk.length;i++){
					if(chk[i] != himself) {
						chk[i].checked = false;
					}
				}
			}
		</script>
	</head>
	<body>
		<%if(showTop.equals("")) {%>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
		<%} else if(showTop.equals("show800")) {%>
			
		<%}%>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitForRule(),_self} " ; 
			RCMenuHeight += RCMenuHeightStep;
			if(showTop.equals("")) {
				RCMenu += "{" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + ",MailSignAdd.jsp?userid=" + userId + ",_self} ";
			} else if(showTop.equals("show800")) {
				RCMenu += "{" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + ",MailSignAdd.jsp?showTop=show800&userid=" + userId + ",_self} ";
			}
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		<table style="width: 98%; height: 92%; border-collapse: collapse" align="center">
			
			<tr>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">
								<!--==========================================================================================-->
								<form id="fMailSign" method="post" action="MailSignOperation.jsp">
									<input type="hidden" name="operation" value="default" />
									<input type="hidden" name="defaultSignId" value="" />
									<%if(showTop.equals("")) {%>
									
									<%} else if(showTop.equals("show800")) {%>
									<input type="hidden" name="showTop" value="show800" />
									<%}%>
									<table class="liststyle" cellspacing="1">
										<tr class="header">
											<th style="width: 30%"><%=SystemEnv.getHtmlLabelName(20148, user.getLanguage())%><!-- 签名 --></th>
											<th style="width: 40%"><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></th>
											<th style="width: 15%"><%=SystemEnv.getHtmlLabelName(18095, user.getLanguage())%></th>
											<th style="width: 15%"><%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></th>
										</tr>
										
										<%
											int i = 0;
											rs.executeSql("SELECT * FROM MailSign WHERE userId=" + userId + " ORDER BY signName");
											while (rs.next())
											{
										%>
										<tr
											<%if((i%2)!=0){out.println("style='background-color:#EEE'");}%>>
											<td>
												<%if(showTop.equals("")) {%>
													<a href="MailSignEdit.jsp?id=<%=rs.getInt("id")%>"><%=rs.getString("signName")%></a>
												<%} else if(showTop.equals("show800")) {%>
													<a href="MailSignEdit.jsp?showTop=show800&id=<%=rs.getInt("id")%>"><%=rs.getString("signName")%></a>
												<%}%>
											</td>
											<td><%=rs.getString("signDesc")%></td>
											<td><input type="checkbox" name="isActive" onclick="radioBox(this)" value="<%=rs.getInt("id")%>" <%if(rs.getString("isActive").equals("1"))out.print("checked");%> /></td>
											<td>
												<%if(showTop.equals("")) {%>
													<span
														onclick="javascript:location.href='MailSignEdit.jsp?id=<%=rs.getInt("id")%>&userid=<%=userId%>'"
														class="href"><%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%></span>
													<span
														onclick="if(confirm('<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage())%>')){location.href='MailSignOperation.jsp?id=<%=rs.getInt("id")%>';}"
														class="href"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></span>
												<%} else if(showTop.equals("show800")) {%>
													<span
														onclick="javascript:location.href='MailSignEdit.jsp?showTop=show800&id=<%=rs.getInt("id")%>&userid=<%=userId%>'"
														class="href"><%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%></span>
													<span
														onclick="if(confirm('<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage())%>')){location.href='MailSignOperation.jsp?showTop=show800&id=<%=rs.getInt("id")%>';}"
														class="href"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></span>
												<%}%>
											</td>
										</tr>
										<%
											i++;
											}
										%>
									</table>
								</form>
								<!--==========================================================================================-->
							</td>
						</tr>
					</TABLE>
				</td>
			</tr>
			
		</table>
	</body>
</html>