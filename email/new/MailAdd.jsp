<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@page import="weaver.hrm.resource.ResourceUtil"%>
<%@page import="weaver.email.domain.MailContact"%>
<%@page import="weaver.email.domain.MailGroup"%>
<%@page import="weaver.email.service.MailManagerService"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.service.MailSystemSettingService" %>

<%@ include file="/systeminfo/init.jsp" %>


<jsp:useBean id="mtus" class="weaver.email.service.MailTemplateUserService" scope="page" />
<jsp:useBean id="mts" class="weaver.email.service.MailTemplateService" scope="page" />
<jsp:useBean id="mms" class="weaver.email.service.MailManagerService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />
<jsp:useBean id="mss" class="weaver.email.service.MailSignService" scope="page" />
<jsp:useBean id="SptmForMail" class="weaver.splitepage.transform.SptmForMail" />
<jsp:useBean id="msst" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<link href="/email/css/base.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>

<script type="text/javascript" src="/kindeditor/kindeditor.js"></script>
<script type="text/javascript" src="/kindeditor/kindeditor-Lang.js"></script>

<script type="text/javascript" src="/email/js/autocomplete/jquery.autocomplete.js"></script>
<link href="/email/js/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/email/js/swfupload/vendor/swfupload/swfupload.js"/></script>  
<script type="text/javascript" src="/email/js/swfupload/vendor/swfupload/swfupload.queue.js"/></script>  
<script type="text/javascript" src="/email/js/swfupload/vendor/swfupload/fileprogress.js"/></script>  
<script type="text/javascript" src="/email/js/swfupload/vendor/swfupload/handlers.js"/></script>  

<script type="text/javascript" src="/email/js/swfupload/src/jquery.swfupload.js"/></script> 
<script type="text/javascript" src="/js/weaver.js"></script> 


<script type="text/javascript" src="/email/js/progressbar/jquery.progressbar.js"/></script>

<link type='text/css' rel='stylesheet'  href='/blog/js/treeviewAsync/eui.tree.css'/>

<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview.js'></script>
<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview.async.js'></script>

<link rel="stylesheet" type="text/css" href="/email/js/tzSelect/jquery.tzSelect.css" />
<link href="/email/css/base.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/email/js/tzSelect/jquery.tzSelect.js"></script>

<script type="text/javascript" src="/email/js/autosizetext/jquery.autosizetext.js"></script>


<script type="text/javascript" src="/email/js/leanModal/jquery.leanModal.min.js"></script>

<script type="text/javascript" src="/email/js/hotkeys/jquery.hotkeys.js"></script>

<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>

 <script type="text/javascript" src="/email/js/easyui/jquery.easyui.min.js"></script>  
<%

%>
<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	
	int mailid = Util.getIntValue(request.getParameter("mailId")); // 老邮件模块邮件ID参数
	
	if(mailid==-1){
		mailid = Util.getIntValue(request.getParameter("id"));
	}
	
	String to = Util.null2String(request.getParameter("to"));
	int flag = Util.getIntValue(request.getParameter("flag"));
	
	int isInternal =0;
	
	if("".equals(Util.null2String(request.getParameter("isInternal")))){
		msst.selectMailSetting(user.getUID());
		isInternal = "0".equals(msst.getDefaulttype())?1:0;
	}else{
		isInternal = Util.getIntValue(request.getParameter("isInternal"),0);
	}
	
	
	
	
	String internalto = Util.null2String(request.getParameter("internalto"));
	String internaltodpids = Util.null2String(request.getParameter("internaltodpids"));
	String internalcc = "";
	String internalbcc = "";
	
	
	int mailfilesize = MailSystemSettingService.getMailFileSizeSetting(); // 附件大小限制
	
	
	mtus.selectDefaultMailTemplate(user.getUID());
	
	//默认模版信息
	int templateType = mtus.getTemplatetype();//0:个人模板 1:公司模板
	int defaultTemplateId = mtus.getTemplateid();
	
	String subject="";
	String sendfrom ="";
	String sendto = "";
	String sendcc = "";
	String sendbcc = "";
	String toall="";
	String toids="";
	String todpids="";
	String ccall = "";
	String ccids="";
	String bccids="";
	String ccdpids="";
	String bccall="";
	String bccdpids="";
	String mailContent="";
	String defaultSign="";
	String mailaccountid="";
	String priority="";
	String accStr="";
	String accids ="";
	defaultSign = mms.getDefaultSign(user.getUID()); //发送邮件时添加的默认签名
	if(flag!=-1){
		if(flag ==1){
			mms.getReplayMailInfo(mailid+"",user);
		}else if(flag==2){
			mms.getReplayAllMailInfo(mailid+"",user);
		}else if(flag==3){
			mms.getForwardMailInfo(mailid+"",user);
		}else if(flag==4){
			mms.getDraftMailInfo(mailid+"",user);
		}
		
		subject = mms.getSubject();
		isInternal = mms.getIsInternal();
		if(isInternal==1){
		
		
			if(flag ==1){
				//回复的时候，收件人为邮件的发起人
				 toall="";
				 todpids="";
				 toids=mms.getSendfrom();
				 internalto=mms.getSendfrom();
			}else	if(flag ==2){
				//回复全部
				 toall=mms.getToall();
				 todpids=mms.getTodpids();
				 toids=mms.getToids();
				 internalto=mms.getToids();
				 
				ccall =mms.getCcall();
				ccdpids = mms.getCcdpids();
				ccids=mms.getCcids();
				internalcc =mms.getCcids();
			}else if(flag ==3){
				 toall="";
				 todpids="";
				 toids="";
				 internalto="";
			}
			else  if(flag==4){
				 toall=mms.getToall();
				 todpids=mms.getTodpids();
				 toids=mms.getToids();
				 internalto=mms.getToids();
				//草稿的时候
				ccall =mms.getCcall();
				ccdpids = mms.getCcdpids();
				ccids=mms.getCcids();
				internalcc =mms.getCcids();

				bccall =mms.getBccall();
				bccdpids =mms.getBccdpids();
				bccids=mms.getBccdpids();
				internalbcc =mms.getBccids();
			}
			
			
		}else{
			sendfrom = mms.getSendfrom();
			sendto = mms.getSendto();
			sendcc = mms.getSendcc();
			sendbcc = mms.getSendbcc();
		}
		
		mailContent = mms.getContent();
		priority = mms.getPriority();
		
		accStr = mms.getAccStr();
		accids = mms.getAccids();
	}else{
		mas.clear();
		mas.setIsDefault("1");
		mas.setUserid(user.getUID()+"");
		mas.selectMailAccount();
		
		if(mas.next()){
			sendfrom = mas.getAccountMailAddress();
			mailaccountid = mas.getAccountid();
		}
		if(!to.equals("")){
			sendto = to;
		}
		 toids=internalto;
		 internalto=internalto;
		 todpids=internaltodpids;
	}
	
	int emailfilesize=0;
	rs.execute("select emailfilesize from SystemSet");
	if(rs.next()){
		emailfilesize = rs.getInt("emailfilesize");
	}
%>
<html>
<body  style="overflow: auto;">
<form name="mailAddForm" id="mailAddForm" method="post" action="/email/MailOperationSend.jsp" enctype="multipart/form-data">
<input type="hidden" name="accids" id="accids" value="<%=accids%>">
<input type="hidden" name="delaccids" id="delaccids" value="">
<input type="hidden" name="folderid" id="folderid" />
<input type="hidden" name="operation" id="operation" />
<input type="hidden" name="attachmentCount" id="attachmentCount" value="-1" />
<input type="hidden" name="savedraft" id="savedraft" value="0" />
<input type="hidden" name="msgid" id="msgid" value="" />
<input type="hidden" name="location" id="location" value="1" />
<input type="hidden" name="flag" id="flag" value="<%=flag %>" />
<%
if(flag==4){
	%>
	<input type="hidden" name="mailid" id="mailid" value="<%=mailid %>" />
	<%
}
%>



<table class="w-all h-all "  style="border-spacing: 0px">
	<tr>
		<td width="*" class="p-r-15">
			<table class="w-all h-all">
				<tr height="90px;">
					<td>
						<div class="w-all  relative" style="background:#f8f8f8 ">
							<div class="absolute w-250" style="top: 5px; right: 10px;z-index:1000 ">
									
									<div class="right" id="miniToolBar">
										
										<span class="spanBtn" id="addCc"  style="padding-left:0px"><%=SystemEnv.getHtmlLabelName(19809, user.getLanguage())%></span>
										<span class="spanBtn" id="delCc"><%=SystemEnv.getHtmlLabelName(81320, user.getLanguage())%></span>
										<span class="spanBtn" id="addBcc"><%=SystemEnv.getHtmlLabelName(19810, user.getLanguage())%></span>
										<span class="spanBtn" id="delBcc"><%=SystemEnv.getHtmlLabelName(81321, user.getLanguage())%></span>
										<span class="spanBtn ">
												<input type="checkbox" value="1" <%if(isInternal==1){ out.print("checked='checked'");} %> name="isInternal" id="isInternal">
												<label for="isInternal"><%=SystemEnv.getHtmlLabelName(24714, user.getLanguage())%></label>
										</span>
									</div>
									<div class="clear"></div>
							</div>
							<div id="sendFromDiv" class="relative h-25 ">
								<div class="left"  <%if(isInternal==1){ out.print("class='hide'"); } %>>
									<div class="color666 bold w-70 p-t-5 p-l-10 left"><%=SystemEnv.getHtmlLabelName(2034, user.getLanguage())%></div>
									<div class="color666  w-200 p-l-10 left">
									<select name="mailAccountId" id="mailAccountId" >
									<%
										mas.clear();
										mas.setUserid(user.getUID()+"");
										mas.selectMailAccount();
										while(mas.next()){
											String tempMail = getDefaultSendFrom(mms,mas.getAccountMailAddress());
											//System.out.println(tempMail+"$$");
											if(!tempMail.equals("")){
												if(tempMail.equals(mas.getAccountMailAddress())){
													%>
												
													<option value="<%=mas.getId()%>" selected="selected"><%=mas.getAccountname() %></option>
													<%
												}else{
													%>
													<option value="<%=mas.getId()%>"><%=mas.getAccountname()%></option>
													<%
												}
											}else{
												if(mas.getIsDefault().equals("1")){
													%>
													<option value="<%=mas.getId()%>" selected="selected"><%=mas.getAccountname() %></option>
													<%
												}else{
													%>
													<option value="<%=mas.getId()%>" ><%=mas.getAccountname() %></option>
													<%
												}
											}
											%>
											<%
										}
									%>
									</select>
									</div>
									<div class="clear"></div>
								</div>
								
								
								<div class="clear"></div>
							</div>
							
							<div id="InternalMail"  <%if(isInternal!=1){ out.print("class='hide'"); } %>>
								<div id="inputTo" class=''>
									<div class="colorblue importInternalBtn hand bold w-70 p-t-5 p-l-10 left" target="internaltoDiv">
										<div class="left "><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%></div>
										<div class=" left  relative   " id="addMailsBtn" style="width: 20px;;">
											<img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr.png"/>
										</div>
										
										<div class="clear"></div>
									</div>
									<div class="color666  w-500 p-t-5 p-l-10 left">
										<!--  <input class="w-500" type="hidden" name="to" id="to" value="<%=sendto%>">-->
										<%
										
										String hrmSpan = SptmForMail.getHrmShowNameHref(internalto);
										ResourceUtil ru = new ResourceUtil();
										String hrmName= ru.getHrmShowName(internalto);
										String hrmdpids = ru.getHrmShowDepartmentID(internalto);
										String hrmdpname = ru.getHrmDepartmentName(todpids);
					
										//收件人
										if(isInternal==1){
											 hrmName= ru.getHrmShowName(toids);
											 //hrmdpids = ru.getHrmShowDepartmentID(internalto);
											 hrmdpname = ru.getHrmDepartmentName(todpids);
										}
										%>
										<input class="mailInputHide" width="20" style="width: 20" type="hidden" name="internalto" id="internalto" value="<%=internalto%>" temptitle="<%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%>">
										<input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalto" name="internaltodpid" id="internaltodpid" value="<%=todpids%>">
										<input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalto" name="internaltoall" id="internaltoall" value="<%=toall%>">
										<input class="" width="20" style="width: 20" type="hidden" name="internaltohrmname" id="internaltohrmname" value="<%=hrmName%>">
										<input class="" width="20" style="width: 20" type="hidden" name="internaltohrmdpid" id="internaltohrmdpid" value="<%=hrmdpids%>">
										<input class="" width="20" style="width: 20" type="hidden" name="internaltodpidname" id="internaltodpidname" value="<%=hrmdpname%>">
			
										<div class="input mailInput  w-500" type="hrm" id="internaltoDiv" target="internalto">
															
										</div>
										
									</div>
									<div id="addsrz" href="#contactAdd" style="position: static;" class="m-t-15  m-l-10 addFrom left" title="<%=SystemEnv.getHtmlLabelName(31184, user.getLanguage())%>"></div>
									<div class="clear"></div>
								</div>
								
								<div id="" class='inputCc'>
									<div class="colorblue importInternalBtn hand bold w-70 p-t-5 p-l-10 left" target="internalccDiv">
										<div class="left "><%=SystemEnv.getHtmlLabelName(17051, user.getLanguage())%></div>
										<div class=" left  relative   " id="addMailsBtn" style="width: 20px;;">
											<img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr.png"/>
										</div>										
										<div class="clear"></div>
									</div>
									<div class="color666  w-500 p-t-5 p-l-10 left">
										<!--  <input class="w-500" type="hidden" name="to" id="to" value="<%=sendto%>">-->
										<%
										
										hrmSpan = SptmForMail.getHrmShowNameHref(internalcc);
										
										hrmName= ru.getHrmShowName(internalcc);
										hrmdpids = ru.getHrmShowDepartmentID(internalcc);
										hrmdpname = ru.getHrmDepartmentName(ccdpids);
										//抄送人
										if(isInternal==1){
											 hrmName= ru.getHrmShowName(ccids);
											// hrmdpids = ru.getHrmShowDepartmentID(internalto);
											 hrmdpname = ru.getHrmDepartmentName(ccdpids);
										}
										%>
										<input class="mailInputHide" width="20" style="width: 20" type="hidden" name="internalcc" id="internalcc" value="<%=internalcc%>">
										<input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalcc" name="internalccdpid" id="internalccdpid" value="<%=ccdpids%>">
										<input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalcc" name="internalccall" id="internalccall" value="<%=ccall%>">
										<input class="" width="20" style="width: 20" type="hidden" name="internalcchrmname" id="internalcchrmname" value="<%=hrmName%>">
										<input class="" width="20" style="width: 20" type="hidden" name="internalcchrmdpid" id="internalcchrmdpid" value="<%=hrmdpids%>">
										<input class="" width="20" style="width: 20" type="hidden" name="internalccdpidname" id="internalccdpidname" value="<%=hrmdpname%>">
										
										<div class="input mailInput  w-500" type="hrm" id="internalccDiv" target="internalcc" style="min-height:28px; cursor: text;padding: 0px">
																	
										</div>
									</div>
									<div class="clear"></div>
								</div>
								
								<div id="" class='inputBcc'>
									<div class="colorblue importInternalBtn hand bold w-70 p-t-5 p-l-10 left" target="internalbccDiv">
										<div class="left "><%=SystemEnv.getHtmlLabelName(81316, user.getLanguage())%></div>
										<div class=" left  relative   " id="addMailsBtn" style="width: 20px;;">
											<img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr.png"/>
										</div>
										
										<div class="clear"></div>
									</div>
									<div class="color666  w-500 p-t-5 p-l-10 left">
										<!--  <input class="w-500" type="hidden" name="to" id="to" value="<%=sendto%>">-->
										<%
										
										hrmSpan = SptmForMail.getHrmShowNameHref(internalbcc);
										
										hrmName= ru.getHrmShowName(internalbcc);
										hrmdpids = ru.getHrmShowDepartmentID(internalbcc);
										hrmdpname = ru.getHrmDepartmentName(bccdpids);
											//抄送人
										if(isInternal==1){
											 hrmName= ru.getHrmShowName(bccids);
											// hrmdpids = ru.getHrmShowDepartmentID(internalto);
											 hrmdpname = ru.getHrmDepartmentName(bccdpids);
										}
										%>
										<input class="mailInputHide" width="20" style="width: 20" type="hidden" name="internalbcc" id="internalbcc" value="<%=internalbcc%>">
										<input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalbcc" name="internalbccdpid" id="internalbccdpid" value="<%=bccdpids%>">
										<input class="mailInputHide" width="20" style="width: 20" type="hidden" relid="internalbcc" name="internalbccall" id="internalbccall" value="<%=bccall%>">
										<input class="" width="20" style="width: 20" type="hidden" name="internalbcchrmname" id="internalbcchrmname" value="<%=hrmName%>">
										<input class="" width="20" style="width: 20" type="hidden" name="internalbcchrmdpid" id="internalbcchrmdpid" value="<%=hrmdpids%>">
										<input class="" width="20" style="width: 20" type="hidden" name="internalbccdpidname" id="internalbccdpidname" value="<%=hrmdpname%>">
									
										<div class="input mailInput  w-500" type="hrm" id="internalbccDiv" target="internalbcc" style="min-height:28px; cursor: text;padding: 0px">
																	
										</div>
									</div>
									<div class="clear"></div>
								</div>
								
							</div>	
							<div id="ExternalMail" <%if(isInternal==1){ out.print("class='hide'"); } %>>
								<div id="inputTo">
									<div class="colorblue importBtn hand bold w-70 p-t-5 p-l-10 left" target="toDiv">
										<div class="left "><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%></div>
										<div class=" left  relative   " target="toDiv" id="addMailsBtn" style="width: 20px;;">
											<img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr.png"/>
										</div>
										
										<div class="clear"></div>
									</div>
									
									<div class="color666  w-500 p-t-5 p-l-10 left">
										<!--  <input class="w-500" type="hidden" name="to" id="to" value="<%=sendto%>">-->
										<input class="mailInputHide" width="20" style="width: 20" type="hidden" name="to" id="to" value="<%=sendto%>" temptitle="<%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%>">
										
										<div class="input mailInput  w-500" id="toDiv" target="to" style="min-height:28px; cursor: text;padding: 0px">
											
										</div>
										
									</div>
									<div id="addContactGroup" href="#" style="position: static;" class="m-t-15  m-l-10 addFrom left" title="<%=SystemEnv.getHtmlLabelName(31184, user.getLanguage())%>"></div>
									<div class="clear"></div>
								</div>
								
								
								
								<div class="inputCc">
									<div class="colorblue importBtn hand bold w-70 p-t-5 p-l-10 left" target="ccDiv">
										<div class="left "><%=SystemEnv.getHtmlLabelName(17051, user.getLanguage())%></div>
										<div class=" left  relative   " id="addMailsBtn" style="width: 20px;;">
											<img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr.png"/>
										</div>
										
										<div class="clear"></div>
									</div>
									
									<div class="color666  w-500 p-t-5 p-l-10 left">
									<input class="mailInputHide " style="width: 90%" type="hidden" name="cc" id="cc" value="<%=sendcc%>">
									<div class="input mailInput w-500" id="ccDiv" target="cc" style="min-height: 28px;cursor: text;padding: 0px"></div>
									
									</div>
									<div class="clear"></div>
								</div>
									
									
								<div class="inputBcc">
									<div class="colorblue importBtn hand bold w-70 p-t-5 p-l-10 left" target="bccDiv">
										<div class="left "><%=SystemEnv.getHtmlLabelName(81316, user.getLanguage())%></div>
										<div class=" left  relative   " id="addMailsBtn" style="width: 20px;;">
											<img class="absolute" style="top:7px;left:5px" src="/email/images/iconDArr.png"/>
										</div>
										
										<div class="clear"></div>
									</div>
									<div class="color666  w-500 p-t-5 p-l-10 left">
									<input class="mailInputHide" style="width: 90%" type="hidden"  name="bcc" id="bcc" value="<%=sendbcc%>">
									
									<div class="input mailInput w-500" id="bccDiv"  target="bcc" style="min-height:28px;cursor: text;padding: 0px">
												
									</div>
									                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    					</div>
									<div class="clear"></div>
								</div>
							</div>	
							
							<div>
								<div class="color666 bold w-70 p-t-5 p-l-10 left"><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%></div>
								<div class="color666  w-500 p-t-5 p-l-10 left">
									<input class="w-500"   type="text"  style="height: 30px; line-height:30px; width:502px; padding: 0px" id="subject" name="subject" value="<%=subject %>" temptitle="<%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%>" >
									<span id="subjectSpan1" class='hide'><%if(subject.equals("")) out.print("<img src='/images/BacoError.gif' align=\"absMiddle\">"); %></span>
								</div>
								<div class="clear"></div>
							</div>
							
							
							<div>
								<div class="color666 bold w-70 p-t-5 p-l-10 left">
									<div class="swfupload-control left">
									    <span id="spanButtonPlaceholder"><%=SystemEnv.getHtmlLabelName(19812, user.getLanguage())%></span>
									</div>
								</div>
								<div class="color666  w-500 p-t-5 p-l-10 left">
										<%=accStr %>
									<div id="progressDemo" class="hide">
										<div class="left m-t-3" style="background: url(/email/images/mailicon.png) -65px 0px  no-repeat ;width: 16px;height: 16px;">&nbsp;</div>
										<div class="left fileName p-b-3"  ></div>
										<div class="left fileSize p-l-15" ></div>
										<div class="left p-l-15 " ><div class="fileProgress m-b-5">0%</div></div>
										<div class="left p-l-15" ><a class="del" href="#"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a></div>
										<div class="clear"></div>
									</div>
									<div id="fsUploadProgress">
								
									</div>
								<input class="w-500" type="hidden" id="acc" value=""></div>
								<div class="clear"></div>
							</div>
								<div class='p-t-10 p-b-10' style="padding-left:140px">
									<div class="  color666 bold p-r-15 p-t-3  left"><%=SystemEnv.getHtmlLabelName(848, user.getLanguage())%></div>
										<div class="color666  w-100   left">
											<select class="w-100" name="priority" id="priority">
													<option value="3" <%if(priority.equals("3"))out.print("selected");%>><%=SystemEnv.getHtmlLabelName(2086, user.getLanguage())%></option>
													<option value="2" <%if(priority.equals("2"))out.print("selected");%>><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%></option>
													<option value="4" <%if(priority.equals("4"))out.print("selected");%>><%=SystemEnv.getHtmlLabelName(19952, user.getLanguage())%></option>
											</select>
										</div>
										<div class="left m-l-15 color666 p-t-5  p-l-15  ">
											<input class=" " type="checkbox" name="savesend" id="savesend" value="1" checked="checked"> <label for="savesend"><%=SystemEnv.getHtmlLabelName(2092, user.getLanguage())%></label>
										</div>
										
										<div class="left p-l-15 color666 p-t-5  ">
											<input class=" p-r-5" type="checkbox" name='texttype' id="texttype" value="1" onclick="changeHTMLEditor(this)"><label for="texttype"> <%=SystemEnv.getHtmlLabelName(19111, user.getLanguage())%></label>
										</div>
									<div class="clear"></div>
								</div>
						</div>
						
					</td>
				</tr>
				<tr >
					<td height="*" class="">
						<div id="editor" class="w-all h-all " style="height: 100%" >
								<textarea class="w-all " height="100%" style="height:100%;width:100%" id="mouldtext" name="mouldtext"><%=mailContent %><%=mailid>1?"":defaultSign %></textarea>
								
								
						</div>
					</td>
				</tr>
				<tr height="30px;">
					<td class="p-t-10 p-b-30">
						
									 
								
							<div id="toolBar" class="m-t-10">
								<button class="btnGreen" type="button" onclick="doSubmit(this)"><%=SystemEnv.getHtmlLabelName(2083, user.getLanguage())%></button> <button class="btnGray" type="button" onclick="doSave(this)"><%=SystemEnv.getHtmlLabelName(220, user.getLanguage())%></button>
							</div>	
					</td>
				</tr>
			</table>
		</td>
		<td width="200px" class="p-r-5 p-b-5 p-t-5 ">
			
			<table class="w-all h-all">
				<tr>
					<td height="32px">
						<div id="tabTitle" >
							<div id="contatctsTab" style="" class="left tab tabSelected" target="contactsContent"><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%></div>
							<div id="hrmOrgTab" class="left tab  tabUnSelected" target="hrmOrgContent"><%=SystemEnv.getHtmlLabelName(17618, user.getLanguage())%></div>
							<div class="clear"></div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="tabContent m-b-10 h-all" id="contactsContent">
							<div class="p-l-10 p-t-10 relative" id="searchBar">
								<input class="w-150 " type="text" id="fromSearch" > 
								<div id="searchBtn" class="searchFrom"></div>
								
								<div id="addFrom" href="#contactAdd" class="addFrom"  title="<%=SystemEnv.getHtmlLabelName(19956,user.getLanguage()) %>" onclick="addContact()"></div>
							</div>
							<div id="contactsContent">
								<!-- 联系人列表 -->
								<div id="contactsTree" class="m-t-10">
								</div>
							</div>
						</div>
						<div id="hrmOrgContent" class="tabContent h-all hide relative" >
							<ul id="hrmOrgTree" style="width: 100%"></ul>
						</div>
						
					</td>
				</tr>
			</table>
		
		
		
		</td>
	</tr>
	
</table>
<ul class="btnGrayDropContent importBtnDown hide " style="width: 100px;left: 0px;top:28px;" >
												
	<li class=""  style="font-weight: normal;line-height: 20px;" onclick="onShowResourcemail(this)" ><button type="button" class="Browser"  title="<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>"></button><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></li>
	<li class=""  style="font-weight: normal;line-height: 20px;" onclick="onShowCRMContacterMail(this)" ><button type="button" class="Browser"  title="<%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%>"></button><%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%></li>
													
</ul>

<ul class="btnGrayDropContent importInternalBtnDown hide " style="width: 100px;left: 0px;top:28px;" >
												
	<li class=""  style="font-weight: normal;line-height: 20px;" onclick="onShowResource(this)" ><button type="button" class="Browser"  title="<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>"></button><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></li>
	<li class=""  style="font-weight: normal;line-height: 20px;" onclick="onShowDepartment(this)" ><button type="button" class="Browser"  title="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>"></button><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></li>
	<li class=""  style="font-weight: normal;line-height: 20px;" onclick="onShowAllResouceLi(this,event)" ><input type="checkbox" class="" onclick="onShowAllResouce(this,event)"  title="<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>"></button><label><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></label></li>												
</ul>

</form>



<%
			mss.selectMailSignByUser(user.getUID());
			while(mss.next()){
				%>
				<div id="signContent_<%=mss.getId()%>" class="hide"><div style="width: 200px;height: 1px; background: #000;overflow: hidden;"></div><%=mss.getSignContent(Util.getRequestHost(request)) %></div>
				
				<%
			}
%>
<!-- 添加联系人 -->
<div id="contactAdd" class=" popWindow hide "></div>

<div  id="hidedivmsg" class="hide">
	
	<div class="h-30"></div>
	<table style="width: 100%" class='p-t-15'>
		<tr class="h-35">
			<td class="p-l-30 p-r-15">
				<span class="color333 font12 w-100"><%=SystemEnv.getHtmlLabelName(19826,user.getLanguage()) %></span>
			</td>
			<td>
				<input type="text" class="w-300 styled input"  name="srzname" id="srzname" onchange='checkinput("srzname","srznamespan")'  maxlength="50">
				<span name="srznamespan" id="srznamespan" class="hide"><img src='/images/BacoError.gif' align="absMiddle"></span>
			</td>
			<td>
			</td>
		</tr>
		<tr class="h-35">
			<td class="p-l-30 p-r-15">
				<span class="color333 font12 w-100"><%=SystemEnv.getHtmlLabelName(431,user.getLanguage()) %></span>
			</td>
			<td>
				<div class="w-300">
					<ul style="overflow: auto;;height: 100px;" id="srzulid">
					</ul>
				</div>
			</td>
		</tr>
	</table>
</div>
<style>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    display:none;
    border:1px solid #ccc;
}
#saveing{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    display:none;
    border:1px solid #ccc;
}
</style>
<div id="loading">	
		<span><img src="/images/loading2.gif" align="absmiddle"></span>
		<span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(31199, user.getLanguage())%>...</span>
</div>
<div id="saveing">	
		<span><img src="/images/loading2.gif" align="absmiddle"></span>
		<span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(19941, user.getLanguage())%>...</span>
</div>





    
</body>
</html>	
<style>
<!--
.sapn_top{
		padding-top:5px !important ;
		padding-top:2px ;
}

 table td{
 	vertical-align: top;
 }
.ke-container{
	width: 100%!important;
}


 .inputSelected{
 	border: 1px solid blue !important;
 } 

 div{
 	font-size: 12px;
 }
 .overText{
	display:inline-block;
	overflow: hidden;
	white-space: nowrap;
	-o-text-overflow: ellipsis; /*--4 opera--*/
	text-overflow: ellipsis;
 }
 .spanBtn{
 	
 	margin-left:5px;
 	padding:1px;
 	cursor: pointer;
 }
 .spanBtnOver{
	padding:1px;
 	cursor: pointer;
 	color:#ffffff;
 	background: #36c;
 	border-radius:3px;
 	margin-left:5px; 	
 }
 
 .mailAdSelect{	
 	color:#ffffff!important;
 	background: #36c!important;
 	border-radius:2px;		
 }
 
  .mailAdOver{	
 	
 	background: #eee;
 	border-radius:2px;		
 }
 
   .mailAdError{	
 	color:#c30;
 	background:  #FFEAEA;
 	border-radius:2px;		
 }

 .tab{
 	width: 99px !important ;
 	width: 100px ;
 	height: 30px;
 	border-top-left-radius:3px;
 	border-top-right-radius:3px;
 	border: 1px solid #cccccc;
 	outline-color:#222222;
 	line-height: 30px;
 	text-align:center;
 	color:#222222;
 	font-weight: bold;
 }
 .tabSelected{
 	background: #ffffff;
 }
 .tabUnSelected{
 	background: #eeeeee;
 }
 
 .tabContent{
 	width: 200px;
 	
 	border-bottom: 1px solid #cccccc;
 	border-left: 1px solid #cccccc;
 	border-right: 1px solid #cccccc;
 	
 	overflow-y: auto;
 	overflow-x: hidden;
 }
 
 .searchFrom{
 	background: url('/email/images/search.png') no-repeat;
 	width: 13px;
 	height: 13px;
 	position: absolute;
 	cursor: pointer;
 	left: 138px;
 	top:15px;
 }
  .clearFrom{
  	color:#cccccc;
 	width: 13px;
 	height: 13px;
 	position: absolute;
 	cursor: pointer;
 	left: 145px;
 	top:13px;
 	font-family: verdana!important;
 }
 
  .addFrom{
 	background: url('/email/images/add.png') no-repeat;
 	width: 13px;
 	height: 13px;
 	position: absolute;
 	cursor: pointer;
 	left: 160px;
 	top:15px;
 }
 .addFrom:hover{
 	background: url('/email/images/addOver.png') no-repeat;
 	
 }
 .iconRArr {
	width: 4px;
	height: 7px;
	background: url(/email/images/iconRArr.png) no-repeat;
	position: absolute;
	top:5px;
	left: 5px;
 }
  .iconDArr {
	width: 7px;
	height: 4px;
	background: url(/email/images/iconDArr.png) no-repeat;
	position: absolute;
	top:5px;
	left: 5px;
 }
 
 .contactsItem{
 	height: 24px;
 	line-height:24px;
 	
 }
 .contactsItemOver{
 	background: whiteSmoke;
 }
 
 .contactsFold{
 	margin-top: 5px;
 }
 
 .ke-icon-sign {
	width: 16px;
	height: 16px;
	background:url("/email/images/sign.png"); 
	background-repeat: no-repeat;
}

 .ke-icon-template {
	width: 16px;
	height: 16px;
	background:url("/email/images/template.png"); 
	background-repeat: no-repeat;
}

 .ke-icon-doc{
	width: 16px;
	height: 16px;
	background:url("/email/images/app-doc.png"); 
	background-repeat: no-repeat;
}

.ke-icon-project{
	width: 16px;
	height: 16px;
	background:url("/email/images/app-project.png"); 
	background-repeat: no-repeat;
}

.ke-icon-crm{
	width: 16px;
	height: 16px;
	background:url("/email/images/app-crm.png"); 
	background-repeat: no-repeat;
}

.ke-icon-workflow{
	width: 16px;
	height: 16px;
	background:url("/email/images/app-wl.png"); 
	background-repeat: no-repeat;
}

.ke-icon-task{
	width: 16px;
	height: 16px;
	background:url("/email/images/app-task.png"); 
	background-repeat: no-repeat;
}

.ke-icon-workplan{
	width: 16px;
	height: 16px;
	background:url("/workplan/calendar/css/images/icons/appt.gif"); 
	background-repeat: no-repeat;
}



 BUTTON.Browser{
 	height: 16px;
 }
 
 .editableAddr-ipt{
	position:relative;
	left: 0;
	top: 0;
	width: 100%;
	font-family: tahoma,verdana;
	margin: 0;
	padding: 0;
	display: inline;
	border: 0;
	outline: 0;
	background: transparent;

	
}
.editableAddr-txt{
	visibility: hidden;
	color: #999;
	
}
.editableAddr {
	float: left;
	margin:3px;
	white-space: nowrap;
	position: relative;
	max-width: 465px;
	
	height: 15px;
	line-height: 15px;
	color: #999;
	font-size: 12px;
	cursor: text;
	
}

.mailInput{
	
	min-height: 28px;
	
	height:auto !important;height:28px;
	display: block;
	cursor: text;
	padding: 0px;
	
}

.huotu_dialog_overlay
	{
		z-index:99991;
		position:fixed;
		filter:alpha(opacity=30); BACKGROUND-COLOR: rgb(0, 0, 0);
		width:100%;
		bottom:0px;
		height:100%;
		top:0px;
		right:0px;
		left:0px;
		opacity:0.3;
		_position:absolute!important;		
		margin: 0px;
		padding: 0px;
		overflow: hidden;
		display: none;
	}
	.bd_dialog_main
	{	
	
		  box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
	      border: 2px solid #90969E;
	      background: #ffffff;
		 display: none; 
		 z-index:99998;
		 position:fixed;
		_position:absolute!important;	
		 width: 400px; 
		 height: 200px; 
		 background-color:white;	
		 text-align: left; 
         line-height: 27px; 
         font-size:14px;
		 font-weight: bold; 
	}
	.li_decimal{ list-style-type:decimal ; list-style-position: inside;}
	
	.mailAdItem{
		white-space: nowrap;
		
	} 
	
	.mailInputOverDisplay{
		height: 100px!important;
		overflow-y: auto!important;
	}
-->
</style>

<script>

var currentInputId="";
var editorHeight=0;

var mailobj;

//zzl关闭私人组
function closedsrz(){
	$("#srzname").val("");
	$("#hidediv").hide();
	$("#hidedivmsg").hide();
}
//zzl添加私人组
function addsrz(himself){
		var srzname=$("#srzname").val();
		var srzids="";
		if($.trim(srzname)==""){
			alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage()) %>！");
			return;
		}
		$("#srzulid>li").each(function(){
			var _checked_ = false;
			_checked_ = $(this).find("[type=checkbox]").attr("checked");
			if(_checked_) {
				srzids+=$(this).attr("_value")+",";
			}
		});
		
		//禁用按钮
		//himself.disabled = true;
		
		$.post("/email/new/MailAddAjax.jsp?srzname="+srzname+"&srzids="+srzids+"&date="+new Date().getTime(),"",function(data){
				if(data==1) {
					alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage()) %>！");
					/*
					//刷新树
					$("#hrmOrgTree").html("");
					$("#hrmOrgTree").addClass("hrmOrg");
					$("#hrmOrgTree").treeview({
       					url:"/email/new/hrmOrgTree.jsp"
    				});
					*/
					
					//closedsrz();
					Dialog.getInstance('0').close();
					$("#hidedivmsg").hide();
					
				} else if(data==3) {
					alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>！");
				} else {
					alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage()) %>！");
				}
				
				//打开按钮
				//himself.disabled = false;
		});
}

function doInput(obj){
	//$(obj).css('position','relative');	
	//var oTextCount = document.getElementById("char"); 
	iCount = obj.value.replace(/([^\u0000-\u00FF])/g,'aa').length; 
	obj.size=iCount+1;    	    
}

function doRemove(obj){
	if($('.ac_results:visible').length>0){
		return;
	}
	$(obj).parent().remove();
}

function mailLeave(obj){
	$(obj).removeClass('mailAdOver')
}

function mailOver(obj){
	
	$(".mailAdOver").removeClass("mailAdOver");
	$(obj).addClass('mailAdOver')
}

function insertBeforeThis(obj,event){
	$(".mailAdOver").removeClass("mailAdOver");
	$(".mailAdSelect").removeClass("mailAdSelect");
	$('.mailInput').find(".mailinputdiv").remove();
	var edit = $('<span class="mailinputdiv editableAddr " >  <input size=1 style="*width:1px;overflow-x:visible;overflow-y:visible;" onblur="doRemove(this)" class="editableAddr-ipt" oninput="doInput(this)" onpropertychange="doInput(this)" onchange="addMailAddress(this)"><span class="editableAddr-txt"></span></span>')
	edit.insertBefore($(obj).parent());
	$('.mailInput').find('.editableAddr-ipt').focus();
	$(".editableAddr-ipt").bind('keydown', 'backspace',function (evt){
		if($(this).val()==''){
			$(this).parent().prev().remove();
		}
	});
	if($(obj).parent().parent().attr("type")=="hrm"){
		edit.find('.editableAddr-ipt').autocomplete("/email/new/GetData.jsp?searchtype=hrm", {
			minChars: 1,
			
			scroll: false,
			max:30,
			width:400,
			multiple:"",
			matchSubset: false,
		    scrollHeight: 500,
			matchContains: "word",
			autoFill: false,
			formatItem: function(row, i, max) {
				return  "\""+row.name +"\"";
			},
			formatMatch: function(row, i, max) {
				return row.name+ " " + row.pinyin+ " " + row.loginid;
			},
			formatResult: function(row) {
				return row.name+"|"+row.id+"|"+row.dpid;
			}
		});
	}else{
		edit.find('.editableAddr-ipt').autocomplete("/email/new/EmailData.jsp", {
			minChars: 1,
			
			scroll: false,
			max:30,
			width:400,
			multiple:"",
		    scrollHeight: 500,
			matchContains: "word",
			autoFill: false,
			formatItem: function(row, i, max) {
				return  row.name +"&lt;" + row.to + "&gt;";
			},
			formatMatch: function(row, i, max) {
				return row.name + " " + row.to;
			},
			formatResult: function(row) {
				return row.name +"|" + row.to;
			}
		});
	}
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation(); 
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
}

function insertAfterThis(obj,event){
	$(".mailAdOver").removeClass("mailAdOver");
	$(".mailAdSelect").removeClass("mailAdSelect");
	$('.mailInput').find(".mailinputdiv").remove();
	var edit = $('<span class="mailinputdiv editableAddr " ><input size=1 style="*width:1px;overflow-x:visible;overflow-y:visible;" onblur="doRemove(this)" class="editableAddr-ipt" oninput="doInput(this)" onpropertychange="doInput(this)" onchange="addMailAddress(this)"><span class="editableAddr-txt"></span></span>')
	
	edit.insertAfter($(obj).parent());
	$('.mailInput').find('.editableAddr-ipt').focus();
	$(".editableAddr-ipt").bind('keydown', 'backspace',function (evt){
		if($(this).val()==''){
			$(this).parent().prev().remove();
		}
	});
	if($(obj).parent().parent().attr("type")=="hrm"){
		edit.find('.editableAddr-ipt').autocomplete("/email/new/GetData.jsp?searchtype=hrm", {
			minChars: 1,
			
			scroll: false,
			max:30,
			width:400,
			multiple:"",
			matchSubset: false,
		    scrollHeight: 500,
			matchContains: "word",
			autoFill: false,
			formatItem: function(row, i, max) {
				return  "\""+row.name +"\"";
			},
			formatMatch: function(row, i, max) {
				return row.name+ " " + row.pinyin+ " " + row.loginid;
			},
			formatResult: function(row) {
				return row.name+"|"+row.id+"|"+row.dpid;
			}
		});
	}else{
		edit.find('.editableAddr-ipt').autocomplete("/email/new/EmailData.jsp", {
			minChars: 1,
			
			scroll: false,
			max:30,
			width:400,
			multiple:"",
		    scrollHeight: 500,
			matchContains: "word",
			autoFill: false,
			formatItem: function(row, i, max) {
				return  row.name +"&lt;" + row.to + "&gt;";
			},
			formatMatch: function(row, i, max) {
				return row.name + " " + row.to;
			},
			formatResult: function(row) {
				return row.name +"|" + row.to;
			}
		});
	}
	
	
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation(); 
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
}

function selectMail(obj,event){
	$(".mailAdSelect").removeClass("mailAdSelect");
	$(obj).addClass("mailAdSelect");
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation(); 
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
}

function mailUnselect(obj,event){
	$(obj).remove("mailAdSelect");
	
}




function addMailAddress(obj){
	
	obj.value = obj.value.toLowerCase();
	if($('.ac_results:visible').length>0){
		return;
	}
	
	if(!addToInput($(obj).parent().parent().attr("id"),obj.value,obj)){
		obj.value = "";
	}
}

function showMailADDiv(obj){
	var  value = obj.val();
	var list =obj.val().split(",");
	var div = $(".mailInput[target="+obj.attr("id")+"]");
	div.html("");
	if(obj.attr("id")=='internalto'||obj.attr("id")=='internalcc'||obj.attr("id")=='internalbcc'){
		//if(obj.attr("id").indexOf("internal")>-1){
		//alert(obj.attr("id")+"hrmname")
		var listname =$("#"+obj.attr("id")+"hrmname").val().split(",");
		var listnamedpid =$("#"+obj.attr("id")+"hrmdpid").val().split(",");
		for(var i=0;i<list.length;i++){
			
			var mail = list[i];
			var dpid = listnamedpid[i];
			var name = listname[i];
			//alert(mail)
			if(mail!=''){
				addToInput(obj.attr("id")+"Div",name+"|"+mail+"|"+dpid);
				//alert(obj.attr("id"))
			}
		}
		$("#"+obj.attr("id")+"Div").find(".clear").remove();
		
	}else if(obj.attr("id")=='internaltodpid'||obj.attr("id")=='internalccdpid'||obj.attr("id")=='internalbccdpid'){
		var listname =$("#"+obj.attr("id")+"name").val().split(",");
		
		for(var i=0;i<list.length;i++){
			
			var dpid = list[i];
			
			var name = listname[i];
			//alert(mail)
			if(dpid!=''){
				addToInput(obj.attr("relid")+"Div",name+"|0|"+dpid);
				//alert(obj.attr("id"))
			}
		}
		$("#"+obj.attr("relid")+"Div").find(".clear").remove();
	}else if(obj.attr("id")=='internaltoall'||obj.attr("id")=='internalccall'||obj.attr("id")=='internalbccall'){
		var listname ='<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>';
		
		for(var i=0;i<list.length;i++){
			
			var dpid = list[i];
			var name = listname;
			if(dpid=='1'){
				addToInput(obj.attr("relid")+"Div",name+"|0|0");
			}
			
		}
		$("#"+obj.attr("relid")+"Div").find(".clear").remove();
	}else{
		for(var i=0;i<list.length;i++){
			
			var mail = list[i];
			if(mail!=''){
				
				var mailDiv = $("<div class='mailAdItem mailAdOK' style='float:left;margin:3px' unselectable='on' title='"+mail+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+mail+";</span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
				div.append(mailDiv)
			}
		}
	}
	
	div.append("<div class='clear'></div>")
	
	
	
	
}

// 人力资源浏览框（人员）
function onShowResourcemail(obj)  {
	$(".btnGrayDropContent").hide();

	var target =  $(obj).parent().attr("target");
	
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MutiResourceMailBrowser.jsp");
	if (data!=null){
		 
        if (data.id!= ""){
         
        	var _ids = data.id.split(",");
			var _names = data.name.split(",");
			for(var i=0;i<_names.length;i++){
				if(_names[i].indexOf("@")==-1) continue;	
				addToInput(target,_names[i])
			
			}
        }else{
         
        }
	 }
}

//人力资源浏览框（email）
function onShowResource(obj)  {
	$(".btnGrayDropContent").hide();
	var target =  $(obj).parent().attr("target");
	getRealMailAddress();
	var resourceid = $("#"+$("#"+target).attr("target")).val()
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+resourceid);
	if (data!=null){
        if (data.id!= ""&&data.dpid){
         	//alert(data.id+"<br>"+data.dpid)
        	var _ids = data.id.split(",");
        	var _dpids = data.dpid.split(",");
			var _names = data.name.split(",");
			var div = $("#"+target);
			div.find(".mailAdItem[dpid!=0][value!='0']").remove();
			for(var i=0;i<_names.length;i++){
				if(_ids[i]!=""){
					addToInput(target,_names[i]+"|"+_ids[i]+"|"+_dpids[i])
				}
			}
        }else{
        	var div = $("#"+target);
        	div.find(".mailAdItem[dpid!=0][value!='0']").remove();
        }
	 }
}

//部门浏览框
function onShowDepartment(obj)  {
	$(".btnGrayDropContent").hide();
	var target =  $(obj).parent().attr("target");
	getRealMailAddress();
	var selectedids = $("#"+$("#"+target).attr("target")+"dpid").val()
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+selectedids);
	if (data!=null){
		 
        if (data.id!= ""){
         	
        	var _ids = data.id.split(",");
			var _names = data.name.split(",");
			var div = $("#"+target);
        	div.find(".mailAdItem[dpid!=0][value='0']").remove();
			for(var i=0;i<_names.length;i++){
				if(_ids[i]!=""){
					addToInput(target,_names[i]+"|0|"+_ids[i])	
				}
				
			}
        }else{
        	var div = $("#"+target);
        	div.find(".mailAdItem[dpid!=0][value='0']").remove();
        }
	 }
}

function onShowAllResouceLi(obj){
	$(".btnGrayDropContent").hide();
	var target =  $(obj).parent().attr("target");

	if($(obj).find("input:checkbox").attr("checked")==true){
		$(obj).find("input:checkbox").attr("checked",false);
		$("#"+target).html("")
		$("#"+target).attr("disabled",'false')
	}else{
		$(obj).find("input:checkbox").attr("checked",true)
		addToInput(target,"<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>|0|0")
		$("#"+target).attr("disabled", 'true');
	}
	
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation(); 
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
}

//添加所有人为收件人

function onShowAllResouce(obj){
	
	$(".btnGrayDropContent").hide();
	var target =  $(obj).parent().parent().attr("target");

	if($(obj).find("input:checkbox").attr("checked")==true){
		//$(obj).find("input:checkbox").attr("checked",false);
		$("#"+target).html("")
		$("#"+target).attr("disabled",'false')
	}else{
		//$(obj).find("input:checkbox").attr("checked",true)
		addToInput(target,"<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>|0|0")
		$("#"+target).attr("disabled",'true')
	}
	
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation(); 
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
	
	
	//alert($(obj).find("input:checkbox").attr("checked"))
}

//客户联系人导入浏览框
function onShowCRMContacterMail(obj){
	$(".btnGrayDropContent").hide();
	var target =  $(obj).parent().attr("target");
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCRMContacterBrowserMail.jsp");
	if(data){
		
		if(data.id!=""){
			//alert(ids[0]);alert(ids[1]);return false;
			
			var _ids = data.id.split(",");
			var _names = data.name.split(",");
			for(var i=0;i<_names.length;i++){
				if(_names[i].indexOf("@")==-1) continue;	
				
				addToInput(target,_names[i])
			}
		}
	}
}

function onShowContacterMail(o1, o2){
	$(".btnGrayDropContent").hide();
	tmpnameCont = jQuery(o1)[0].name;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MailContacterBrowserMulti.jsp");
	if(typeof data!="undefined"){
		if(tmpnameCont=="receiver"){
			jQuery("#receiverSpan").html("");	
		}
		if(data.id!=""){
			var re = /(.*)<(.*)>/ig;
			var mailUser = data.id.split(",");
			var mailEmail = data.name.split(",");
			var mailUserId,mailUserEmail;
			for(var i=0;i<mailUser.length;i++){
				if(mailUser[i]=="") continue;
				mailUserId = mailUser[i].split("~")[0];
				mailUserEmail = mailEmail[i].split("~")[0];
				o1.value += o1.value=="" ? mailUserEmail : "," + mailUserEmail;
				o2.value += o2.value=="" ? mailUserId : "," + mailUserId;
			}
		}else{
			jQuery(o1).val("");
			jQuery(o2).val("");
		}
		
	}

}



//添加email地址
function addToInput(targetid,name,input){
	
	var div = $("#"+targetid);
	
	// 判断当前地址是否已存在,存在则不能重复添加
	if(mailIsExist(div,name)){
		//alert("<%=SystemEnv.getHtmlLabelName(31185,user.getLanguage()) %>!")
		return false;
	}
	
	//清除浮动层clear样式
	div.find(".clear").remove();
	
	//判断输入框类型，人力资源或邮件地址
	if(div.attr("type")=="hrm"){
		
		if(input==undefined){ // 由浏览框批量导入
			if(name!=""){
				
				var list = name.split("|")
				var html;
				if(list[1]=='0'){// 人员ID为0,即为部门信息
					html = $("<div class='mailAdItem mailAdOK' style='float:left;margin:3px'  unselectable='on' dpid='"+list[2]+"'  value='"+list[1]+"' title='"+list[0]+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+list[0]+";</span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
					
				}else{
					html = $("<div class='mailAdItem mailAdOK' style='float:left;margin:3px'  unselectable='on' dpid='"+list[2]+"' value='"+list[1]+"' title='"+list[0]+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+list[0]+";</span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
				}
				
				div.append(html);
			
			}
			
		}else{// 自动联想输入
			if(name!=""){
				
				if($(input).attr("selected")=="true"){
					
					var list = name.split("|")
					if(list[1]=='0'){// 人员ID为0,即为部门信息
						html = $("<div class='mailAdItem mailAdOK' style='float:left;margin:3px'  unselectable='on' dpid='"+list[2]+"'  value='"+list[1]+"' title='"+list[0]+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+list[0]+";</span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
					}else{
						html = $("<div class='mailAdItem mailAdOK' style='float:left;margin:3px'  unselectable='on' dpid='"+list[2]+"'  value='"+list[1]+"' title='"+list[0]+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+list[0]+";</span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
					}
					if($(input).parent().prev().length>0){
						html.insertAfter($(input).parent().prev());
					}else if($(input).parent().next().length>0){
						html.insertBefore($(input).parent().prev());
					}else{
						div.append(html);
					}
				}
			
			}
			input.value="";
			
			$(input).parent().remove();
		}
		
	}else{
		
		if(input == undefined){  // 由浏览框批量导入
			
			//name 格式为 xxxx<yyyyy@yyy.com>，需要处理，获取地址和名称
			var re = /([0-9A-Za-z\-_\.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)/gi; 
			var tmpemail = name.match(re); // 邮件地址
			var tmpname  = name.replace("<"+tmpemail+">","") // 名称
			
			var classname='';
			var validate = /^[\w\-\.]+@[\w\-\.]+(\.\w+)+$/;
			 if(!validate.test(tmpemail)){        
				 classname ='mailAdError'
			 }else{
				 classname ='mailAdOK'
			 }
				
			 if(tmpemail!=""){
			 	var html = $("<div class='mailAdItem "+classname+"' style='float:left;margin:3px' unselectable='on' title='"+tmpemail+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+tmpname+"&lt;"+tmpemail+"&gt;;</span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
				
				div.append(html);
				
			}
			
		}else{
			//name 格式为 xxxx|yyyyy@yyy.com ，需要处理，获取地址和名称
			
			var list = name.split("|")
			if(list.length==1){
				name = name+"|"+name;
				list = name.split("|")
			}
			var tmpemail = list[1]; // 邮件地址
			var tmpname  = list[0] // 名称
			
			var classname='';
			var validate = /^[\w\-\.]+@[\w\-\.]+(\.\w+)+$/;
			 if(!validate.test(tmpemail)){        
				 classname ='mailAdError'
			 }else{
				 classname ='mailAdOK'
			 }
			if(tmpemail!=""){
				var html = $("<div class='mailAdItem "+classname+"' style='float:left;margin:3px' unselectable='on' title='"+tmpemail+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+tmpname+"&lt;"+tmpemail+"&gt;;</span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
				
				if($(input).parent().prev().length>0){
					html.insertAfter($(input).parent().prev());
				}else if($(input).parent().next().length>0){
					html.insertBefore($(input).parent().prev());
				}else{
					div.append(html);
				}
			}
						
			input.value="";			
			$(input).parent().remove();
		}
		
	}
	div.find(".clear").remove();
	div.append("<div class='clear'></div>")
	if(div.height()>100){
		if(!div.hasClass("mailInputOverDisplay")){
			div.addClass("mailInputOverDisplay")
			//console.log('addClass')
		}		 
	}else if (div.height()<90){
		if(div.hasClass("mailInputOverDisplay")){
			div.removeClass("mailInputOverDisplay")
			//console.log('addClass')
		}
		
		//console.log('removeClass')
	}
	
	return true;
}

function mailIsExist(div,name){
	// 判断当前地址是否已存在,存在则不能重复添加
	var isExist = false;
	if(div.attr("type")=="hrm"){
		//alert(name)
		var list = name.split("|");
		//所有人
		if(div.find(".mailAdItem[value=0][dpid=0]").length>0){
			isExist = true;
		}
		//人员
		if(div.find(".mailAdItem[dpid="+list[2]+"][value="+list[1]+"]").length>0){ // 判断是否有相同人员
			
			isExist = true;
		}
		
		//部门
		if(list[1]!=0){ // 判断是该人员部门已存在
			if(div.find(".mailAdItem[dpid="+list[2]+"][value='0']").length>0){
			
				isExist = true;
			}	
		}else{
			if(list[2]==0){
				div.find(".mailAdItem").remove();
			}else{
				div.find(".mailAdItem[dpid="+list[2]+"][value!='0']").remove();
			}
			
		}
		
	}else{
		var re = /([0-9A-Za-z\-_\.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)/gi; 
		var tmpemail = name.match(re);
		if(div.find(".mailAdItem[title="+tmpemail+"]").length>0){
			isExist = true;
		}
	}
	return isExist;
} 

jQuery(document).ready(function(){
	//加载默认邮件模板
	
	<%if(defaultTemplateId!=-1 && flag==-1){%>
		setTimeout("loadMailTemplate(<%=defaultTemplateId%>, <%=templateType%>,1)",500);
	<%}%>
	
	  //设置邮件类型
	 
	 // if('<%=isIE%>'=='true'){
		 //$(".mailInput").css("height","28px");
	 // }
	$(".importBtn").bind("click",function(event){
		var id = $(this).attr("target");
		
		var x=$(this).offset().left
		var y=$(this).offset().top
		
		$(".importBtnDown").attr("target",id);
		
		$(".importBtnDown").css("left",x+25);
		$(".importBtnDown").css("top",y+20);
		$(".importBtnDown").toggle();
		event.stopPropagation(); 
		
	})
	
	$(".importInternalBtn").bind("click",function(event){
		var id = $(this).attr("target");
		
		var x=$(this).offset().left
		var y=$(this).offset().top
		
		$(".importInternalBtnDown").attr("target",id);
		
		$(".importInternalBtnDown").css("left",x+25);
		$(".importInternalBtnDown").css("top",y+20);
		$(".importInternalBtnDown").toggle();
		event.stopPropagation(); 
		
	})
	
	
	$(document).bind("click",function(){
		$(".btnGrayDropContent").hide();
	})
	
	
	loadContactsTree();
	
	
	//$('.mailInput').autogrow();
	
	$(".mailInputHide").each(function(index) {
		showMailADDiv($(this));
	})
	
	
	$('.mailInput').click(function(){
		//alert($(this).attr("disabled"))
		if($(this).attr("disabled")=='true'){
			return;
		}
		$(".mailAdOver").removeClass("mailAdOver");
		
		$(".mailAdSelect").removeClass("mailAdSelect");
		var obj = $('<span class="mailinputdiv editableAddr " > <input size=1 style="*width:1px;overflow-x:visible;overflow-y:visible;" onblur="doRemove(this)" class="editableAddr-ipt" oninput="doInput(this)" onpropertychange="doInput(this)" onchange="addMailAddress(this)"><span class="editableAddr-txt"></span></span>')
		
		if($(this).find(".mailinputdiv").length==0){
			if($(this).find('.clear').length>0){
				obj.insertBefore($(this).find('.clear'));
				$(this).find(".mailinputdiv").find('.editableAddr-ipt').focus();
			}else{
				$(this).append(obj).find('.editableAddr-ipt').focus();
			}
		}else{
			$(this).find(".mailinputdiv").find('.editableAddr-ipt').focus();
		}
		
		try{
		
		$(this).find(".editableAddr-ipt").bind('keydown', 'backspace',function (event){
			if($(this).val()==''){
				
				if($(this).parent().prev().length>0){
					
					if ($(this).parent().prev().parent()[0].clientWidth < $(this).parent().prev().parent()[0].offsetWidth-4){   
						//执行相关脚本。   
					} else{
						
							$(this).parent().prev().parent().removeClass("mailInputOverDisplay");	
					}
					
				}
				$(this).parent().prev().remove();
			}
			if (event.stopPropagation) { 
				// this code is for Mozilla and Opera 
				event.stopPropagation(); 
			} 
			else if (window.event) { 
				// this code is for IE 
				window.event.cancelBubble = true; 
			}
		});
		}catch(e){
			
		}
		
		if($(this).attr("type")=="hrm"){
			//zzl
			var tt=$(this).find(".mailinputdiv").find('.editableAddr-ipt').val();
			obj.find('.editableAddr-ipt').autocomplete("/email/new/GetData.jsp?searchtype=hrm", {
				minChars: 1,
				
				scroll: false,
				max:30,
				width:400,
				multiple:"",
				matchSubset: false,
			    scrollHeight: 500,
				matchContains: "word",
				autoFill: false,
				formatItem: function(row, i, max) {
					return  ""+row.name +"<"+row.department+">";
				},
				formatMatch: function(row, i, max) {
					return row.name+ " " + row.pinyin+ " " + row.loginid;
				},
				formatResult: function(row) {
					return row.name+"|"+row.id+"|"+row.dpid;
				}
			});
			
		}else{
			obj.find('.editableAddr-ipt').autocomplete("/email/new/EmailData.jsp", {
				minChars: 1,
				
				scroll: false,
				max:30,
				width:400,
				multiple:"",
			    scrollHeight: 500,
				matchContains: "word",
				autoFill: false,
				formatItem: function(row, i, max) {
					return  row.name +"&lt;" + row.to + "&gt;";
				},
				formatMatch: function(row, i, max) {
					return row.name + " " + row.to;
				},
				formatResult: function(row) {
					return row.name +"|" + row.to;
				}
			});
		}
	
	})
	
	
	
	editorHeight = $("#editor").outerHeight();
	editorHeight =editorHeight+40;
	
	// 美化select控件
	$("select").tzSelect();
	
	// 邮件自动提示


	$(".clearFrom").click(function(){
		
		$("#fromSearch").val("");
		$(".searchFrom").show();
		$(".clearFrom").hide();
	})
	
	$("#fromSearch").bind("propertychange",function(){
		loadContactsTree()
	})
	
	$("#fromSearch").bind("input",function(){
		loadContactsTree()
	})
	
	//记录当前输入框ID
	$(".mailInput").bind("click",function(){
		currentInputId = $(this).attr("target");
		
	})
	
	// 输入框选中高亮
	$(".mailInput").bind("click",function(){
		$(".inputSelected").removeClass("inputSelected");
		if(!$(this).hasClass("inputSelected")!='true'){
			$(this).addClass("inputSelected");
		}
		
	})
	$(".mailInput").live("blur",function(){
		
		$(this).removeClass("inputSelected");
	})
	
	/*$("div#InternalMiniToolBar").find("span#addsrz").hover(
		function(){$(this).removeClass("spanBtn").addClass("spanBtnOver")},
		function(){$(this).removeClass("spanBtnOver").addClass("spanBtn")}
	);*/
	
	$("#miniToolBar").find("span").hover(
		function(){$(this).removeClass("spanBtn").addClass("spanBtnOver")},
		function(){$(this).removeClass("spanBtnOver").addClass("spanBtn")}
	);
	
	//输入框添加删除事件注册
	$("#addCc").bind("click",function(){
		$("#addCc").hide();
		$("#delCc").show();
		if($("#isInternal").attr("checked")){
			$("#InternalMail").find(".inputCc").show();
		}else{
			
			$("#ExternalMail").find(".inputCc").show();
		}
		
	})
	$("#delCc").bind("click",function(){
		
		$("#delCc").hide();
		$("#addCc").show();
		
		if($("#isInternal").attr("checked")){
			
			$("#InternalMail").find(".inputCc").hide();
			$("#InternalMail").find(".inputCc").find("#internalcc").val("");
			$("#internalccDiv").html("");
		}else{
			
			$("#ExternalMail").find(".inputCc").hide();
			$("#ExternalMail").find(".inputCc").find("#cc").val("");
			$("#ccDiv").html("");
		}
		
	})
	
	$("#addBcc").bind("click",function(){
		$("#addBcc").hide();
		$("#delBcc").show();
		
		if($("#isInternal").attr("checked")){
			$("#InternalMail").find(".inputBcc").show();
		}else{
			
			$("#ExternalMail").find(".inputBcc").show();
		}
	})
	$("#delBcc").bind("click",function(){
		$("#delBcc").hide();
		$("#addBcc").show();
		
		if($("#isInternal").attr("checked")){
			$("#InternalMail").find(".inputBcc").hide();
			$("#InternalMail").find(".inputBcc").find("#internalbcc").val("");
			$("#internalbccDiv").html("");
		}else{
			$("#ExternalMail").find(".inputBcc").hide();
			$("#ExternalMail").find(".inputBcc").find("#bcc").val("");
			$("#bccDiv").html("");
		}
	});
	
	$("#addContactGroup").click(function(){
			$("#srzulid").html(""); //防止内容重复
			$("#srzname").val("");
			
			$("#toDiv").find(".mailAdItem").each(function(){
					//alert($(this).attr("value")+"=="+$(this).attr("title"));
					var temp_title=$(this).attr("title");
					$(this).find("span").each(function(){
							if($(this).html().length>30){
								 $("#srzulid").append(
									"<li class='m-2  li_decimal w-240' _value='"+temp_title+"' title='"+$(this).html()+"'>" + 
										"<input type='checkbox' checked='true' />" + 
										"<span class='overText '>"+($(this).html()).substr(0,30)+"...</span>" + 
									"</li>"
								); 
							}else{
								$("#srzulid").append(
									"<li class='m-2  li_decimal w-240' _value='"+temp_title+"' title='"+$(this).html()+"'>" + 
										"<input type='checkbox' checked='true' />" + 
										"<span class='overText '>"+($(this).html()).substr(0,30)+"</span>" + 
									"</li>"
								); 
							}
					});
			});
			
			
			var diag = new Dialog();
			diag.Width = 450;
			diag.Height = 200;
			diag.Title = "<%=SystemEnv.getHtmlLabelName(22306,user.getLanguage()) %>";
			diag.InvokeElementId = "hidedivmsg";
			diag.OKEvent = addLXR;//点击确定后调用的方法
			diag.show();
			$("#hidedivmsg").show();
	});
	function addLXR(){
			var srzname=$("#srzname").val();
			var srzids="";
			if($.trim(srzname)==""){
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage()) %>！");
				return;
			}
			$("#srzulid>li").each(function(){
				var _checked_ = false;
				_checked_ = $(this).find("[type=checkbox]").attr("checked");
				if(_checked_) {
					srzids+=$(this).attr("_value")+"@;";
				}
			});
			var o4params = {
				method:"haved",
				srzname:encodeURI(srzname),
				srzids:srzids
			}
			$.post("/email/new/EmailcontactAjax.jsp",o4params,function(data){
				if(data==0){
					//30910 组名重复
						alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>!");
				}else if(data==1){
				//30700操作成功
						alert("<%=SystemEnv.getHtmlLabelName(30700,user.getLanguage()) %>!");
						Dialog.getInstance('0').close();
				}else{
				//30651操作失败
						alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>!");
						Dialog.getInstance('0').close();
				}
			});
	}
	//zzl
	$("#addsrz").bind("click",function(){
		//点击创建私人组 creat group
		//var a=(document.body.clientWidth)/2-140; 
		//var b=(document.body.clientHeight)/2-40;
		//$("#hidedivmsg").css("left",a);
		//$("#hidedivmsg").css("top",b);
		//$("#hidediv").show();
		//$("#hidedivmsg").show();
		$("#srzulid").html(""); //防止内容重复
		$("#internaltoDiv").find(".mailAdItem[value!=0]").each(function(){
				//alert($(this).attr("value")+"=="+$(this).attr("title"));
				$("#srzulid").append(
					"<li class='m-2 left li_decimal' _value='"+$(this).attr("value")+"'>" + 
						"<input type='checkbox' checked='true' />" + 
						"<span class='overText w-50'>"+ $(this).attr("title") +"</span>" + 
					"</li>"
				);
		});
		
		
		var diag = new Dialog();
		diag.Width = 450;
		diag.Height = 200;
		diag.Title = "<%=SystemEnv.getHtmlLabelName(31184,user.getLanguage()) %>";
		diag.InvokeElementId = "hidedivmsg";
		diag.OKEvent = addsrz;//点击确定后调用的方法
		diag.show();
		$("#hidedivmsg").show();
		
	})
	
	
	
	
	//zzl
	/*$("#addsrz").find("span").hover(
		function(){$(this).removeClass("spanBtn").addClass("spanBtnOver")},
		function(){$(this).removeClass("spanBtnOver").addClass("spanBtn")}
	);*/
	
	
	
	
	//初始化编辑器
	highEditor("mouldtext",editorHeight)
	
	$("#fromSearch").bind("change",function(){
		if($(this).val()!=""){
			$(".searchFrom").hide();
			$(".clearFrom").show();
		}else{
			$(".searchFrom").show();
			$(".clearFrom").hide();
		}
	})
	
	// 初始化组织结构树
	//zzl
	$("#hrmOrgTree").addClass("hrmOrg"); 
    $("#hrmOrgTree").treeview({
       url:"/email/new/hrmOrgTree.jsp"
    });
    
   	$("#tabTitle").find(".tab").bind("select",function(){
   		if(!$(this).hasClass("tabSelected")){
   			$("#"+$(".tabSelected").attr("target")).hide();
   			$(".tabSelected").removeClass("tabSelected").addClass("tabUnSelected");
   			$(this).removeClass("tabUnSelected").addClass("tabSelected");
   			$("#"+$(this).attr("target")).show();
   			
   		}
   	})
   	$("#tabTitle").find(".tab").css("z-index","-1")
   	
   	$(".tabSelected").trigger("click");
   	
    $('.contactsItem').hover(
            function () {
              $(this).addClass("contactsItemOver");
            }, 
            function () {
            	$(this).removeClass("contactsItemOver");
            }
    );
   
    if(<%=isInternal%>==1) {
		changeMailType(1);
	} else{
		changeMailType(0);
	}
    
});

function loadContactsTree(){
	//加载联系人列表
	
	var keyword =encodeURI($("#fromSearch").val())
	
	$("div#contactsContent div#contactsTree").html("");
	$("div#contactsContent div#contactsTree").load("/email/new/MailAddContactsGroupTree.jsp?keyword="+keyword,function(data){
		$('.contactsItem').hover(
	            function () {
	              $(this).addClass("contactsItemOver");
	            }, 
	            function () {
	            	$(this).removeClass("contactsItemOver");
	            }
	    );
	});
}

function initToolBarStatus(){
	//初始化输入框状态
	
	if($("#isInternal").attr("checked")){
		//设置接收人为了所有人
		if('<%=ccall%>'=='1'||'<%=ccdpids%>'!=''){
				$("#addCc").trigger("click");
		}else{
			if('<%=internalcc%>'!=''){
			$("#addCc").trigger("click");
			}else{
				$("#delCc").trigger("click");
			}
		}
		//设置米送人为所有人
		if("<%=bccall%>"=="1"||"<%=bccdpids%>"!=""){
				$("#addBcc").trigger("click");
		}else{
			if('<%=internalbcc%>'!=''){
				$("#addBcc").trigger("click");
			}else{
				$("#delBcc").trigger("click");
			}
		}
		
		
		
		
	}else{
		if('<%=sendcc%>'!=''){
		
			$("#addCc").trigger("click")
		
		}else{
			
			$("#delCc").trigger("click")
		
		}
		
		if('<%=sendbcc%>'!=''){
			
			$("#addBcc").trigger("click")
		
		}else{
		
			$("#delBcc").trigger("click")
		
		}
	}
	
	
	
}

//zzl
function openBlog(type,id,name,obj){
	//alert(id+"来了"+type+"----"+name);
	var div = $(".mailInput[target="+currentInputId+"]");		
    if(type==0){
    	//添加组
    	 $.post("/email/new/hrmOrgTree.jsp?root="+id,"",function(data){
			$.each(data,function(idx,item){ 									
			 
			  addToInput(div.attr("id"),item.text+"|"+item.id+"|"+item.dpid)

			});

		  });
    }else{
    
    	 addToInput(div.attr("id"),name+"|"+id)
		
    }	
}


/**封装签名插件**/
 KE.lang.sign = '<%=SystemEnv.getHtmlLabelName(20148,user.getLanguage()) %>';
	KE.plugin.sign = {
		click : function(id) {
			var self = this;
			var cmd = 'sign';
			KE.util.selection(id);
			var menu = new KE.menu({
				id : id,
				cmd : cmd,
				width : 130
			});
			<%
			mss.selectMailSignByUser(user.getUID());
			while(mss.next()){
				%>
			menu.add('<%=Util.getMoreStr(mss.getSignName(),7,"...")%>', function() { self.exec(id, '<%=mss.getId()%>'); });
				
				<%
			}
			%>	
			
			menu.show();
			this.menu = menu;
		},
		exec : function(id, value) {
			var cmd = new KE.cmd(id);
			setMailSign(value);
			KE.util.execOnchangeHandler(id);
			this.menu.hide();
			KE.util.focus(id);
		}
	};
	
	
/**封装模板插件**/
KE.lang.template = '<%=SystemEnv.getHtmlLabelName(31186,user.getLanguage()) %>';
KE.plugin.template = {
	click : function(id) {
		var self = this;
		var cmd = 'template';
		KE.util.selection(id);
		var menu = new KE.menu({
			id : id,
			cmd : cmd,
			width : 210
		});
		<%
		mts.selectMailTemplateInfos(user.getUID());
		while(mts.next()){
			%>
			menu.add('<%=Util.getMoreStr(mts.getTemplateName(),14,"...")%>', function() { self.exec(id, '<%=mts.getId()%>','<%=mts.getType()%>'); });
			
			<%
		}
		%>	
		menu.show();
		this.menu = menu;
	},
	exec : function(id, value,type) {
		var cmd = new KE.cmd(id);
		//setMailSign(value);
		//todo
		loadMailTemplate(value,type)
		KE.util.execOnchangeHandler(id);
		this.menu.hide();
		KE.util.focus(id);
	}
};	

KE.lang.doc = "<%=SystemEnv.getHtmlLabelName(22243,user.getLanguage()) %>";
KE.plugin.doc = {
    click : function(id) {
    	openApp('doc')
    }
};
KE.lang.project = "<%=SystemEnv.getHtmlLabelName(101,user.getLanguage()) %>";
KE.plugin.project = {
    click : function(id) {
    	openApp('project')
    }
};

KE.lang.workplan = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage()) %>";
KE.plugin.workplan = {
    click : function(id) {
    	openApp('workplan')
    }
};

KE.lang.workflow = "<%=SystemEnv.getHtmlLabelName(22244,user.getLanguage()) %>";
KE.plugin.workflow = {
    click : function(id) {
    	openApp('workflow')
    }
};

KE.lang.crm = "<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>";
KE.plugin.crm = {
    click : function(id) {
    	openApp('crm')
    }
};

KE.lang.crm = "<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>";
KE.plugin.crm = {
    click : function(id) {
    	openApp('crm')
    }
};

KE.lang.task = "<%=SystemEnv.getHtmlLabelName(1332,user.getLanguage()) %>";
KE.plugin.task = {
    click : function(id) {
    	openApp('task')
    }
};


/*高级编辑器*/
function highEditor(remarkid,height){
    height=!height||height<150?150:height;   
    if(jQuery("#"+remarkid).is(":visible")){
		
		var  items=[
						'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 
						'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough', 'image', 'advtable','remote_image','sign','template','doc',
						'workplan','workflow','crm','project','task'
				   ];
			 
	    KE.init({
					id : remarkid,
					height:height,
					width:'auto',
					resizeMode:1,
					imageUploadJson : '/email/new/upload_json.jsp',
				    allowFileManager : false,
	                newlineTag:'br',
	                items : items,
				    afterCreate : function(id) {
						KE.util.focus(id);
				    }
	   });
	   KE.create(remarkid);
	}
}

/**
 * 切换到纯文本模式
 */
function removeEditor(remarkid){
	KE.remove(remarkid)
}

/**
 * 切换编辑器模式
 */
function changeHTMLEditor(obj){
	
	if(obj.checked){
		if(confirm("<%=SystemEnv.getHtmlLabelName(31242, user.getLanguage())%>")){
			removeEditor("mouldtext")
		}else{
			obj.checked = false;
		}
	}else{
		highEditor("mouldtext",editorHeight)
	}
}

/**
 * 附件上传控件
 */
$(function(){

    $('.swfupload-control').swfupload({
        // Backend Settings
        upload_url: "/email/new/uploader.jsp",    // Relative to the SWF file (or you can use absolute paths)
        
        // File Upload Settings
        file_size_limit : "<%=emailfilesize*1024%>", //
        file_types : "*.*",
        file_types_description : "All Files",
        file_upload_limit : "5",
        file_queue_limit : "0",
    
        // Button Settings
       
        button_placeholder_id : "spanButtonPlaceholder",
        button_width: 70,
        button_height: 20,
        button_text:"<span class='theFont'><%=SystemEnv.getHtmlLabelName(19812, user.getLanguage())%></span>",
        button_text_left_padding: 0,
		button_text_top_padding: 3,
		button_window_mode:'transparent',
        button_text_style: ".theFont { font-size:12;font-weight:bold;color:#666666;cursor:pointer;}",
        button_image_url:"/email/images/acc.png",
        // Flash Settings
        flash_url : "/email/js/swfupload/vendor/swfupload/swfupload.swf"
        
    });

    
    
    // assign our event handlers
    $('.swfupload-control')
    	.bind('fileQueued', function(event, file){
        	$progress = $("#progressDemo").clone();
        	$progress.attr("id",file.id);
        	//var index = $("#fsUploadProgress").find(".progressBar").size();
        	//$progress.find(".fileIndex").text(index);
        	$progress.find(".fileName").text(file.name);
        	
        	$progress.find(".fileSize").text((Math.round(file.size/1000)).toFixed()+"KB");
        	$("#fsUploadProgress").append($progress);
        	$progress.find(".del").bind('click', function () { //Remove from queue on cancel click
                            var swfu = $.swfupload.getInstance('.swfupload-control');
                            swfu.cancelUpload(file.id);
                            
                            $("#"+file.id).remove();
                            
                            //setButton();
                        });
        	$progress.show();
         
            //$(this).swfupload('startUpload');
        })
        .bind('fileQueueError', function (event, file, errorCode, message) {
        	if(errorCode==-100){
        		alert("<%=SystemEnv.getHtmlLabelName(31187,user.getLanguage()) %>");
        	}
        	if(errorCode==-110){
        		alert("<%=SystemEnv.getHtmlLabelName(24494,user.getLanguage()) %><%=emailfilesize%>M");
        	}
        })
        .bind('fileDialogComplete', function (event, numFilesSelected, numFilesQueued) {
        	$('#queuestatus').text('Files Selected: ' + numFilesSelected + ' / Queued Files: ' + numFilesQueued);
        	//setButton();
        })
        .bind('uploadStart', function (event, file) {
        	$("#"+file.id).find(".btnred").hide();
        	$("#cur_patch").text(file.name);
        })
        .bind('uploadProgress', function (event, file, bytesLoaded,bytesTotal) {
        	var percentage = Math.round((bytesLoaded / bytesTotal) * 100);
        	$('#' + file.id).find('.fileProgress').text(percentage + '%');
        	$('#' + file.id).find('.fileProgress').progressBar({height:13,width:102,barImage:'/email/js/progressbar/images/loading.png',boxImage:'/email/js/progressbar/images/bg.png',showText: true});
        })
        .bind('uploadSuccess', function (event, file, serverData) {
        	//处理返回值 serverData
        	//alert(serverData)
        	$("#accids").val($("#accids").val()+","+serverData)
        	var swfu = $.swfupload.getInstance('.swfupload-control');
        	//判断所有文件上传成功后，进行处理
        	if( swfu.getStats().files_queued ===0){
        		//nextStep();
        		
        		//提交表单
        	}
        })
        .bind('uploadComplete', function (event, file) {
        	// upload has completed, try the next one in the queue
        	var swfu = $.swfupload.getInstance('.swfupload-control');
        	if( swfu.getStats().files_queued ===0){
        		//nextStep();
        		$("#loading").show()
        		jQuery("#mailAddForm").submit();
        		//提交表单
        	}
        });
		
});

//在提交表单的时候将div中的收件人邮箱地址组装好，写入对应的input框中
function getRealMailAddress(){
	$(".mailInputHide").val("");
	$(".mailAdOK").each(function(index) {
 	   	
	 	//alert($(this).attr("title"))
	 	if($(this).parent().attr("type")=="hrm"){
	 		var value = $("#"+$(this).parent().attr("target")).val()
	 		var dpvalue =  $("#"+$(this).parent().attr("target")+"dpid").val()
		 	if($(this).attr("dpid")*1==0&&$(this).attr("value")*1==0){
		 		$("#"+$(this).parent().attr("target")+"all").val(1);
		 		$("#"+$(this).parent().attr("target")).val('0')
		 		$("#"+$(this).parent().attr("target")+"dpid").val('0')
		 	}else if($(this).attr("dpid")*1>0&&$(this).attr("value")*1==0){
		 		dpvalue = dpvalue+$(this).attr("dpid")+","
		 		$("#"+$(this).parent().attr("target")+"dpid").val(dpvalue)
		 	}else{
		 		value =value+ $(this).attr("value")+","
		 		$("#"+$(this).parent().attr("target")).val(value)
		 	}
		 	
	 		
	 	}else{
	 		var value = $("#"+$(this).parent().attr("target")).val()
	 		//var value = ""; 
		 	value =value+ $(this).attr("title")+","
		 	
		 	$("#"+$(this).parent().attr("target")).val(value)
	 	}
	 	
	 });
	
	if($("#internalto").val()==''&&($("#internaltodpid").val()!=''||$("#internaltoall").val()!='')){
		$("#internalto").val("0")
	}
	
}

function doSubmit(obj){
	obj.disable=true;
	$("#savedraft").val("0");
	$("#folderid").val("-1");
	
	getRealMailAddress();
	
	if($("#isInternal").attr("checked")){
		if((check_form($G("mailAddForm"),'internalto,subject'))){
			var swfu = $.swfupload.getInstance('.swfupload-control');
			if(swfu.getStats().files_queued >0){
				swfu.setButtonDisabled(true);
				swfu.startUpload();
			}else{
				$("#loading").show()
				jQuery("#mailAddForm").submit();
			}
			
		}
	}else{
		if($(".mailAdError").length>0){
			alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage()) %>")
			return false;
		}
		if((check_form($G("mailAddForm"),'to,subject'))){
			
			var swfu = $.swfupload.getInstance('.swfupload-control');
			if(swfu.getStats().files_queued >0){
				swfu.setButtonDisabled(true);
				swfu.startUpload();
			}else{
				$("#loading").show()
				jQuery("#mailAddForm").submit();
			}
			
		}
	}
}

function doSave(obj){
	obj.disable=true;
	
	$("#savedraft").val("1");
	$("#folderid").val("-2");
	
	getRealMailAddress();
	
	if($("#isInternal").attr("checked")){
		
			var swfu = $.swfupload.getInstance('.swfupload-control');
			if(swfu.getStats().files_queued >0){
				swfu.setButtonDisabled(true);
				swfu.startUpload();
			}else{
				$("#saveing").show()
				jQuery("#mailAddForm").submit();
			}
			
		
	}else{
		if($(".mailAdError").length>0){
			alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage()) %>")
			return false;
		}
		var swfu = $.swfupload.getInstance('.swfupload-control');
		if(swfu.getStats().files_queued >0){
			swfu.setButtonDisabled(true);
			swfu.startUpload();
		}else{
			$("#saveing").show()
			jQuery("#mailAddForm").submit();
		}
			
		
	}
}






/**
 * 验证邮件地址是否合法
 */
function validateForm(){
			
	if(validateMailAddress($G("to").value) && validateMailAddress($G("cc").value) && validateMailAddress($G("bcc").value)){
		return true;
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");//邮件地址格式错误
		return false;
	}

}

//
function validateMailAddress(str){
	var valid = true;
	var arr = str.split(",");
	for(var i=0;i<arr.length;i++){
		var a = arr[i];
		var pos1 = a.indexOf("<");
		var pos2 = a.lastIndexOf(">");
		if(pos1!=-1&&pos2!=-1){
			if(!checkEmail($.trim(a.substring(pos1+1,pos2)))){
				valid = false;
				break;
			}
		}else{
			if(!checkEmail($.trim(a))){
				valid = false;
				break;
			}
		}
	}
	return valid;
}

function checkEmail(emailStr) {	
	if (emailStr.length == 0) {
	 return true;
	}
	var emailPat=/^(.+)@(.+)$/;
	var specialChars="\\(\\)<>@,;:\\\\\\\"\\.\\[\\]";
	var validChars="\[^\\s" + specialChars + "\]";
	var quotedUser="(\"[^\"]*\")";
	var ipDomainPat=/^(\d{1,3})[.](\d{1,3})[.](\d{1,3})[.](\d{1,3})$/;
	var atom=validChars + '+';
	var word="(" + atom + "|" + quotedUser + ")";
	var userPat=new RegExp("^" + word + "(\\." + word + ")*$");
	var domainPat=new RegExp("^" + atom + "(\\." + atom + ")*$");
	var matchArray=emailStr.match(emailPat);
	if (matchArray == null) {
	 return false;
	}
	var user=matchArray[1];
	var domain=matchArray[2];
	if (user.match(userPat) == null) {
	 return false;
	}
	var IPArray = domain.match(ipDomainPat);
	if (IPArray != null) {
	 for (var i = 1; i <= 4; i++) {
	 if (IPArray[i] > 255) {
	 return false;
	 }
	 }
	 return true;
	}
	var domainArray=domain.match(domainPat);
	if (domainArray == null) {
	 return false;
	}
	var atomPat=new RegExp(atom,"g");
	var domArr=domain.match(atomPat);
	var len=domArr.length;
	if ((domArr[domArr.length-1].length < 0) ||
	 (domArr[domArr.length-1].length > 50)) {
	 return false;
	}
	if (len < 2) {
	 return false;
	}
	return true;
}
/**
 * 添加邮件签名
 */
function setMailSign(signid){
	if(signid=="")
	{
		return false;
	}
	var htmlstr = jQuery("#signContent_"+signid).html();
	if(KE.g["mouldtext"].wyswygMode)
		KE.insertHtml("mouldtext",htmlstr);
    else
       alert("<%=SystemEnv.getHtmlLabelName(27541,user.getLanguage())%>"); //请将编辑器切换到可视化模式！
}

// 添加操作者
function addAddress(address){
	
	var div = $(".mailInput[target="+currentInputId+"]");
	
	if(div.hasClass("inputSelected")!='true'){
		div.addClass("inputSelected");
	}
	
	addToInput(div.attr("id"),address)
	
}

//加载邮件模版
function loadMailTemplate(mailTemplateId,mailTemplateType,isdefault){
	if(isdefault==1){
		if(mailTemplateId==0){//清空模板内容
			KE.insertHtml("mouldtext","");//清空编辑器内容
			
			return false;
		}
		$.ajax({
		  url: '/email/MailTemplateTemp.jsp?id='+mailTemplateId+'&templateType='+mailTemplateType+'&userId=<%=user.getUID()%>',
		  success: function(data) {
			  setTemplate(data)
		  }
		});
	}else{
		if(confirm("<%=SystemEnv.getHtmlLabelName(19925, user.getLanguage())%>")){
			
			if(mailTemplateId==0){//清空模板内容
				KE.insertHtml("mouldtext","");//清空编辑器内容
				
				return false;
			}
			$.ajax({
			  url: '/email/MailTemplateTemp.jsp?id='+mailTemplateId+'&templateType='+mailTemplateType+'&userId=<%=user.getUID()%>',
			  success: function(data) {
				  setTemplate(data)
			  }
			});
		}
	}
	
}

//设置邮件模版
function setTemplate(data){
	var templateContent = data;
	var reg = /\@\@\@(.*)\@\@\@/;
	if (templateContent.match(reg)){
		$("#subject").val( templateContent.match(reg)[1]);
	}
    if($("#subject").val()!=""){
    	$("#subjectSpan").html('');
    }
    else{
        $("#subjectSpan").html("<img src='/images/BacoError.gif' align=\"absMiddle\">");
    }
    KE.html("mouldtext","")
	KE.insertHtml("mouldtext",templateContent.replace(reg, ""))
	
}

/**************start*****************MailContactAdd.jsp页面依赖代码******************************************/
//载入添加联系人页面
function addContact() {
	var diag = new Dialog();
	diag.Width = 450;
	diag.Height = 380;
	diag.Title = "<%=SystemEnv.getHtmlLabelName(19956,user.getLanguage()) %>";
	diag.URL = "/email/new/MailContacterAdd.jsp";
	diag.OKEvent = submitFMailContacter;//点击确定后调用的方法
	diag.show();
	
	function submitFMailContacter() {
		var _innerWindow = diag.innerFrame.contentWindow;
		if(_innerWindow.checkInput()) {
			var param = _innerWindow.getSerialize();
			$("#fromSearch").val("");
			$.post("/email/new/ContactManageOperation.jsp", param, function(){
				$("div#contactsContent div#contactsTree").load("/email/new/MailAddContactsTree.jsp", function(){
					diag.close();
				});
			});
		} else {
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>"); 
		}
	}
}
/**************end*****************MailContactAdd.jsp页面依赖代码******************************************/

//显示或着隐藏联系人列表
function showOrHideContactList(himself) {
	//alert($(himself).find(".contactsGroupContent").children().length<1)
	if($(himself).parent().find(".contactsGroupContent").children().length<1){
		//$(himself).find(".contactsGroupContent").load()
		
		var keyword =encodeURI($("#fromSearch").val())
		
		var groupid=$(himself).attr("groupid");
		//alert("/email/new/MailAddContactsTree.jsp?groupid="+groupid+"&keyword="+keyword)
		//alert($(himself).find(".contactsGroupContent").length)
		$(himself).parent().find(".contactsGroupContent").load("/email/new/MailAddContactsTree.jsp?groupid="+groupid+"&keyword="+keyword,function(data){
			
		//alert(data)
			$('.contactsItem').hover(
		            function () {
		              $(this).addClass("contactsItemOver");
		            }, 
		            function () {
		            	$(this).removeClass("contactsItemOver");
		            }
		    );
		});
	}
	$(himself).next("#customGroup").toggle();
	$(himself).find("b").each(function(){
		if($(this).hasClass("hide")) {
			$(this).removeClass("hide");
		} else {
			$(this).addClass("hide");
		}
	});
	
}

//邮件类型切换
$("#isInternal").click(function(){
	
	if($(this).attr("checked")){
		changeMailType(1);
	}else{
		changeMailType(0);
	}
})

function changeMailType(mailType) {
	
	switch(mailType) {
	case 0: //普通邮件
		$("#contatctsTab").trigger("select");
		$("#InternalMail").hide();
		$("#ExternalMail").show();
		//$("#miniToolBar").show();
		$("#sendFromDiv").show();
		$("#addsrz").hide();
		break;
	case 1: //内部邮件
		//使用内部邮件
		$("#hrmOrgTab").trigger("select");
		$("#InternalMail").show();
		$("#ExternalMail").hide();
		//$("#miniToolBar").hide();
		$("#sendFromDiv").hide();
		$("#addsrz").show();
		
		//zzl
		break;
	default:
		break;
	}
	
	initToolBarStatus();
}

function checkinput(elementname,spanid){
	var tmpvalue = $GetEle(elementname).value;
	// 处理$GetEle可能找不到对象时的情况，通过id查找对象
    if(tmpvalue==undefined)
        tmpvalue=document.getElementById(elementname).value;

	while(tmpvalue.indexOf(" ") >= 0){
		tmpvalue = tmpvalue.replace(" ", "");
	}
	if(tmpvalue != ""){
		while(tmpvalue.indexOf("\r\n") >= 0){
			tmpvalue = tmpvalue.replace("\r\n", "");
		}
		if(tmpvalue != ""){
			$GetEle(spanid).innerHTML = "";
		}else{
			$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			//$GetEle(elementname).value = "";
		}
	}else{
		$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		//$GetEle(elementname).value = "";
	}
}

function doDelAcc(id){
	var ids = jQuery("#accids").val();
	ids = ids.replace(","+id+",",",")
	
	jQuery("#accids").val(ids);
	jQuery("#"+id).remove();
	var delids = jQuery("#delaccids").val();
	if(delids!=""){
		delids = delids+","+id;
	}else{
		delids = id;
	}
	jQuery("#delaccids").val(delids);
	
}



$.fn.enable_changed_form_confirm = function () {    
    var _f = this;  
    $(':text, :password, textarea', this).each(function() {    
        $(this).attr('_value', $(this).val());    
    });  
  
    $(':checkbox, :radio', this).each(function() {    
        var _v = this.checked ? 'on' : 'off';    
        $(this).attr('_value', _v);    
    });  
  
    $('select', this).each(function() {  
    	if(this.options.length>0){
    		$(this).attr('_value', this.options[this.selectedIndex].value);    
    	}
        
    });    
        
    $(this).submit(function() {    
        window.onbeforeunload = null;    
    });    
  
    window.onbeforeunload = function() { 
    	//提醒保存
        if(is_form_changed(_f)) {    
            return "<%=SystemEnv.getHtmlLabelName(31243,user.getLanguage())%>";    
        }    
    }    
}  
  
  
  
  
  
function is_form_changed(f) {    
    var changed = false;    
    $(':text, :password, textarea', f).each(function() {    
        var _v = $(this).attr('_value');    
        if(typeof(_v) == 'undefined')   _v = '';    
        if(_v != $(this).val()) changed = true;    
    });    
  
    $(':checkbox, :radio', f).each(function() {    
        var _v = this.checked ? 'on' : 'off';  
        if(_v != $(this).attr('_value')) changed = true;    
    });    
   
    $('select', f).each(function() {    
        var _v = $(this).attr('_value');    
        if(typeof(_v) == 'undefined')   _v = '';    
        if(_v != this.options[this.selectedIndex].value) changed = true;  
    });    
    return changed;    
}  
  
  
  
  
$(function() {    
    $('form').enable_changed_form_confirm();    
});  

function getFormIsChange(){
	
	 if(is_form_changed($("form"))){
		 return  !confirm("<%=SystemEnv.getHtmlLabelName(31243,user.getLanguage())%>\n\n<%=SystemEnv.getHtmlLabelName(31237,user.getLanguage())%>")
	 }else{
		 return false;
	 }
}



//打开应用程序
function openApp(type){
	   var editorId="mouldtext";
	   var htmlstr=onShowApp(type);
	   if(htmlstr){      
	     if(KE.g[editorId].wyswygMode)
	        KE.insertHtml(editorId,htmlstr);
	     else
	        alert("<%=SystemEnv.getHtmlLabelName(27541,user.getLanguage())%>"); //请将编辑器切换到可视化模式！
	   }  
	}

function onShowApp(type){
	var id1;
	var url;
    if(type=='doc'){
	    id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids=");
    	url = "/docs/docs/DocDsp.jsp?id=";
    }else if(type=='project') { 
	    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids=");
	    url = "/proj/data/ViewProject.jsp?ProjID=";
    }else if(type=='task'){
    	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids=");
    	url = "/proj/process/ViewTask.jsp?taskrecordid=";
    }else if(type=='crm'){
    	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=");
    	url="/CRM/data/ViewCustomer.jsp?CustomerID=";
    }else if(type=='workflow'){
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids=");
        url="/workflow/request/ViewRequest.jsp?requestid="
    }else if(type=="workplan"){
    	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workplan/data/WorkplanEventsBrowser.jsp");
    	url="/workplan/data/WorkPlanDetail.jsp?workid="
    }
		      
    if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       var desc=id1.resourcedesc
	       if(ids.length>500)
	          alert("<%=SystemEnv.getHtmlLabelName(25379,user.getLanguage())%>");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var description=(true&&desc)?desc.split("\7"):"";
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!=''){
						if(type=="workplan"){
							var desc_i=description[i];
							sHtml = sHtml+"<br/><a style=''   linkid="+tempid+" target='_blank' linkType='"+type+"' href='"+url+tempid+"' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+tempname+"</a>&nbsp<br/>"+
									"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+decodeURIComponent(desc_i);
						}else{
		                	sHtml = sHtml+"<a  linkid="+tempid+" linkType='"+type+"' href='"+url+tempid+"' target='_blank' ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+tempname+"</a>&nbsp";
						}
			        }
	          }
	          return sHtml;
	       }
    }
}



</script>
<%!
	public String getDefaultSendFrom(MailManagerService mms,String accountMail){
	
		//System.out.println(mms.getSendfrom());
		//System.out.println(accountMail);
		if(mms.getSendfrom().toLowerCase().indexOf(accountMail.toLowerCase())>-1){
			return accountMail;
		}
		//System.out.println(mms.getSendcc());
		//System.out.println(accountMail);
		if(mms.getSendcc().toLowerCase().indexOf(accountMail.toLowerCase())>-1){
			return accountMail;
		}
		//System.out.println(mms.getSendbcc());
		//System.out.println(accountMail);
		if(mms.getSendbcc().toLowerCase().indexOf(accountMail.toLowerCase())>-1){
			return accountMail;
		}
		return "";

	}

%>
