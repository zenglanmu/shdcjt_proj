
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<%
	String isSent = Util.null2String(request.getParameter("isSent"));
	String isSaveToSentFolder = Util.null2String(request.getParameter("isSaveToSentFolder"));
	mss.selectMailSetting(user.getUID());
	int userLayout = Util.getIntValue(mss.getLayout(),0);
%>

<link href="/email/css/base.css" rel="stylesheet" type="text/css" />
<div class="h-100">&nbsp;</div>

<div class="   w-600 " style="margin-left:auto;margin-right:auto; ">
	<div class="p-t-30" style="border: 1px #d6d6d6 solid;min-height: 400px;height: 400px; background: url(/email/images/envelope.png)">
		<div class="m-l-30">
			<div class="left colorccc m-l-30 p-l-15 font12 p-r-30 p-l-15 relative hand" onclick="backsjx()"><b class="in"></b><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(19816,user.getLanguage()) %></div>
			<div class="left colorccc font12 p-r-30 p-l-15 relative hand" onclick="seejfyj()"><b class="out"></b><%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(30922,user.getLanguage()) %></div>
			<div class="left colorccc font12 p-r-30 p-l-15 relative hand" onclick="writemsg()"><b class="send"></b><%=SystemEnv.getHtmlLabelName(30923,user.getLanguage()) %></div>
			<div class="clear"></div>
		</div>
		<%if(isSent.equals("true")) { %>
		
		<div class="relative">
			<div class="success"></div>
			<div class="successDesc">
				<div class="text-left font36 ">
					<%=SystemEnv.getHtmlLabelName(27564,user.getLanguage()) %>
				</div>
				<%if(isSaveToSentFolder.equals("true")) { %>
				<div>
					<%=SystemEnv.getHtmlLabelName(30924,user.getLanguage()) %>
				</div>
				<%} else if(isSaveToSentFolder.equals("false") || isSaveToSentFolder.equals("")) { %>
				<div>
					<%=SystemEnv.getHtmlLabelName(30925,user.getLanguage()) %>
				</div>
				<%} %>
			</div>
		</div>
		<%} else if(isSent.equals("false")) { %>
		<div class="relative">
			<div class="fail"></div>
			<div class="successDesc">
				<div class="text-left font36 ">
					<%=SystemEnv.getHtmlLabelName(22397,user.getLanguage()) %>
				</div>
				<div>
					<%=SystemEnv.getHtmlLabelName(30926,user.getLanguage()) %>
				</div>
			</div>
		</div>
		<%} else if(isSent.equals("false1")) { %>
		<div class="relative">
			<div class="fail"></div>
			<div class="successDesc">
				<div class="text-left font36 ">
					<%=SystemEnv.getHtmlLabelName(22397,user.getLanguage()) %>
				</div>
				<div>
					<%=SystemEnv.getHtmlLabelName(30927,user.getLanguage()) %>
				</div>
			</div>
		</div>
		<%} %>
	</div>
</div>


<script type="text/javascript">
				function backsjx(){
						//返回收件箱
						try{
							//location.href='/email/new/MailInBox.jsp?folderid=0&receivemail=false'
							if("<%=userLayout%>"=="3"){
								window.parent.gosjx("1","/email/new/MailInboxList.jsp?folderid=0&receivemail=false","<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage()) %>");
							}else{
								window.parent.gosjx("1","/email/new/MailInboxListMain.jsp?folderid=0&receivemail=false","<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage()) %>");
							}
						}catch(e){
								//表示用户从--联系人菜单进入，点击用户超链接发送邮件后，点击返回收件箱
								window.location.href='/email/new/MailInBox.jsp?folderid=0&receivemail=false';
						}
				}
				function seejfyj(){
						//查看已发邮件
						try{
								//location.href='/email/new/MailInBox.jsp?folderid=-1'
								if("<%=userLayout%>"=="3"){
									window.parent.gosjx("1","/email/new/MailInboxList.jsp?folderid=-1","<%=SystemEnv.getHtmlLabelName(2038,user.getLanguage()) %>");
								}else{
									window.parent.gosjx("1","/email/new/MailInboxListMain.jsp?folderid=-1","<%=SystemEnv.getHtmlLabelName(2038,user.getLanguage()) %>");
								}
						}catch(e){
								//表示用户从--联系人菜单进入，点击用户超链接发送邮件后，点击查看已发邮件
								window.location.href='/email/new/MailInBox.jsp?folderid=-1';
						}
				}
				function writemsg(){
						//继续写信
						try{
								window.parent.addTab("1","/email/new/MailAdd.jsp","<%=SystemEnv.getHtmlLabelName(30912,user.getLanguage()) %>");
						}catch(e){
								//表示用户从--联系人菜单进入，点击用户超链接发送邮件后，点击继续写信
								window.location.href='/email/new/MailAdd.jsp';
						}
				}
</script>

<style>
	.send{
		width: 14px;
		height: 16px;
		top: 1px;
		left:0px;
		position: absolute;
		background-position: -64px 0;
		background-image: url(/email/images/sent.png)
	}
	
	.out{
		width: 14px;
		height: 16px;
		top: 1px;
		left:0px;
		position: absolute;
		background-position: -32px 0;
		background-image: url(/email/images/sent.png)
	}
	.in{
		width: 14px;
		height: 16px;
		top: 1px;
		left:0px;
		position: absolute;
		background-position: 0px 0;
		background-image: url(/email/images/sent.png)
	}
	
	.success{
		left:50px;
		top: 138px;
		width: 52px;
		height: 42px;
		position: absolute;
		background-position: -416px 0;
		background-image: url(/email/images/sent.png)
	}
	.fail{
		left:50px;
		top: 138px;
		width: 52px;
		height: 42px;
		position: absolute;
		background-position: -416px -48px;
		background-image: url(/email/images/sent.png)
	}
	.successDesc{
		left:130px;
		top: 138px;
		color:#0D9900;
		height: 42px;
		position: absolute;
	}
	.relative{
		text-align: left;
		
	}
</style>