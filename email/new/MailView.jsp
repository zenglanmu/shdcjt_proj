<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@page import="weaver.email.service.MailResourceFileService"%>
<%@ page import="java.io.*" %>
<%@ page import="weaver.email.domain.*" %>
<%@page import="weaver.email.WeavermailComInfo"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.general.GCONST"%>
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" />
<jsp:useBean id="mrfs" class="weaver.email.service.MailResourceFileService" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<jsp:useBean id="SptmForMail" class="weaver.splitepage.transform.SptmForMail" />
<jsp:useBean id="rs0" class="weaver.conn.RecordSet" scope="page" />
<%

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	int mailid = Util.getIntValue(request.getParameter("mailid"),-1);
	
	int folderid = Util.getIntValue(request.getParameter("folderId"),Integer.MIN_VALUE);
	
	int isInternal = Util.getIntValue(request.getParameter("isInternal"),0);
	int star = Util.getIntValue(request.getParameter("star"),0);
	
	//布局信息
	mss.selectMailSetting(user.getUID());
	int layout = Util.getIntValue(mss.getLayout(),3);
	
	/* 会计算邮件ID，此部分先去除
	// 获取文件夹下最新邮件ID
	if(mailid<0){
		if(isInternal==1) {
			mailid = mrs.getInternalLastMailId(user.getUID());
		} else if(star==1) {
			mailid = mrs.getStarLastMailId(user.getUID());
		} else if(folderid!=Integer.MIN_VALUE) {
			mailid = mrs.getFolderLastMailId(folderid+"",user.getUID());
		}
	}*/
	if(mailid<0){
%>


	<body style="margin: 0px;padding: 0px;overflow: auto;">
	<div class="h-60">&nbsp;</div>
	<div class="w-all h-all">
		<div class="text-center font12">没有可显示的邮件</div>
	</div>
	</body>
<%
		return;
	}
	
	// 读取邮件，并加载到缓存中
	mrs.setId(mailid+"");
	mrs.selectMailResource();
	WeavermailComInfo wmc = new WeavermailComInfo();
	if(mrs.next()){
		int resourceid = Util.getIntValue(mrs.getResourceid());
		if(resourceid!=user.getUID() && mailid>0){ //判断是否有权限查看邮件
			response.sendRedirect("/notice/noright.jsp");
			return;
		}else{
		
		
			wmc.setPriority(mrs.getPrioority()) ;
			wmc.setRealeSendfrom(mrs.getSendfrom()) ;
			wmc.setRealeCC(mrs.getSendcc()) ;
			wmc.setRealeTO(mrs.getSendto()) ;
			wmc.setRealeBCC(mrs.getSendbcc()) ;
			wmc.setSendDate(mrs.getSenddate()) ;
			wmc.setSubject(mrs.getSubject()) ;
			wmc.setContent(mrs.getContent());
			wmc.setBccids(mrs.getBccids());
			wmc.setBccall(mrs.getBccall());
			wmc.setBccdpids(mrs.getBccdpids());
			wmc.setCcids(mrs.getCcids());
			wmc.setCcall(mrs.getCcall());
			wmc.setCcdpids(mrs.getCcdpids());
			wmc.setTodpids(mrs.getTodpids());
			wmc.setToids(mrs.getToids());
			wmc.setToall(mrs.getToall());
			
			
			wmc.setContenttype(mrs.getMailtype());
			if(("1").equals(mrs.getHashtmlimage())){
			    wmc.setHtmlimage(true);
			}else{
			    wmc.setHtmlimage(false);
			}
		}
	}
	
	// 标记邮件为已读
	mrs.updateMailResourceStatus("1",mailid+"",user.getUID());
	
	//EML
	String _emlPath = Util.null2String(mrs.getEmlpath());
	String emlName = Util.null2String(mrs.getEmlname());
	String loadjquery= Util.null2String(request.getParameter("loadjquery"));
	String emlPath = GCONST.getRootPath() + "email" + File.separatorChar + "eml" + File.separatorChar;
	File eml = new File(emlPath + emlName + ".eml");
	if(!_emlPath.equals("")) eml = new File(_emlPath);
	
	if(layout==3){
		if("1".equals(loadjquery)){
		
	%>	
		<script type="text/javascript" src="/wui/common/jquery/jquery.js"></script>
	<%	
		}
	%>
	<link href="/email/css/base.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="/email/js/tzSelect/jquery.tzSelect.css" />
	<script type="text/javascript" src="/email/js/tzSelect/jquery.tzSelect.js"></script>
	<script type="text/javascript" src="/email/js/leanModal/jquery.leanModal.min.js"></script>
	<script language="javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
	<script language="javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>
	<script language="javascript" defer="defer" src="/js/init.js"></script>
	<script type="text/javascript">
	var languageid = '<%=user.getLanguage()%>'
	</script>
	<script type="text/javascript" src="/js/messagejs/highslide/highslide-full.js"></script>
	<script type="text/javascript" src="/js/messagejs/simplehrm.js"></script>
	<script type="text/javascript" src="/js/messagejs/messagejs.js"></script>
	<% 	
	  	}else{
	%> 
		<link rel="stylesheet" type="text/css" href="/email/js/tzSelect/jquery.tzSelect.css" /> 
		<script type="text/javascript" src="/email/js/tzSelect/jquery.tzSelect.js"></script>
	 <%
	  	}
	%>
<style>
*{		
	font-family:"微软雅黑"!important; 
}
BUTTON.showallresource{
	BORDER-RIGHT: medium none; 
	BORDER-TOP: medium none; 
	*PADDING-LEFT: 8px; 
	FONT-SIZE: 8pt; BACKGROUND-IMAGE: url(/images/showallresource.gif);
	 PADDING-BOTTOM: 2px; MARGIN: 2px 0px 1px 2px; OVERFLOW: hidden; 
	 BORDER-LEFT: medium none; WIDTH: 70px; CURSOR: pointer; 
	 COLOR: #000000; PADDING-TOP: 1px; 
	 BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; 
	 FONT-FAMILY: Verdana; HEIGHT: 20px; 
	 BACKGROUND-COLOR: transparent; 
	 TEXT-ALIGN: center;
}

</style>
<body style="margin: 0px;padding: 0px;overflow: auto;">
<form id="test">
<div class="w-all h-all " style="overflow: hidden;" >
	<div id="MailViewMain">
	
	<div id="inBoxTitle" class="h-35 " style="background: url(/email/images/inboxTitleBg.png)" >
		<div class="left mailviewtoolbar p-l-10" style="">
			
		<%
			 
			%>
			<button class=" btnGray1 left" type="button" id="replayBtn"><%=SystemEnv.getHtmlLabelName(117, user.getLanguage())%></button>
			<button class=" btnGray1 left" type="button" id="replayAllBtn"><%=SystemEnv.getHtmlLabelName(2053, user.getLanguage())%></button>
			<button class=" btnGray1 left" type="button" id="forwardBtn"><%=SystemEnv.getHtmlLabelName(6011, user.getLanguage())%></button>
			<%
			  if(layout==3){
				  %>
			<%if(folderid != -3) {%>
			<button class=" btnGray1 left" type="button" id="delBtn"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></button>
			<%}%>
			<button class=" btnGray1 left" type="button" id="dropBtn"><%=SystemEnv.getHtmlLabelName(2031, user.getLanguage())%></button>
			
			<!-- 标记为--start -->

			<div class="btnGrayDrop relative left " id="signAs02" style="width: 100px;"><%=SystemEnv.getHtmlLabelName(81293 ,user.getLanguage()) %>...
			<ul class="btnGrayDropContent hide" style="width: 100px;position: absolute;" >
				<%
				  ArrayList<MailLabel> lmsList= lms.getLabelManagerList(user.getUID());
					for(int i=0; i<lmsList.size();i++){
						MailLabel ml = lmsList.get(i);
						%>
						<li class="markLabel item" target="<%=ml.getId()%>" ><div class="m-r-5 left " style="line-height:8px;margin-top:8px;border-radius:2px; height:8px;width:8px; background:<%=ml.getColor()%>;">&nbsp;</div><%=Util.getMoreStr(ml.getName(),5,"...") %></li>
						<%
					}
				%>
				<%if(lmsList.size()>0){
					%>
					<li style="height: 10px ;margin-bottom: -5px;margin-top: -4px"><div class="line-1 m-t-5"  style="overflow: hidden;"></div></li>
					<%
				} %>
				<!-- 取消所有标签--start -->
				<li class="item"  onclick="cancelLabel2(this)"><%=SystemEnv.getHtmlLabelName(31219 ,user.getLanguage()) %></li>
				<!-- 取消所有标签--end -->
				<!-- 新建并标记--start -->
				<li class="newitem"   onclick="createLabel2(1)">+<%=SystemEnv.getHtmlLabelName(31220 ,user.getLanguage()) %></li>
				<!-- 新建并标记--end -->
			</ul>
			</div>
			<!-- 标记为--end -->
			
			<!-- 移动到...start -->
			<div class="btnGrayDrop relative left " id="moveTo02" style="width: 100px;"><%=SystemEnv.getHtmlLabelName(81298 ,user.getLanguage()) %>...
				<ul class="btnGrayDropContent hide" style="width: 100px;position: absolute;" >
					<%
						ArrayList<MailFolder> folderList= fms.getFolderManagerList(user.getUID());
						for(int i=0; i<folderList.size();i++){
							MailFolder mf = folderList.get(i);
							%>
							<li class="item" target="<%=mf.getId()%>"><%=Util.getMoreStr(mf.getFolderName(), 5, "...") %></li>
							<%
						}
						
					%>
					<%if(folderList.size()>0){
						%>
						<li style="height: 10px;margin-bottom: -5px;margin-top: -4px"><div class="line-1 m-t-5" style="overflow: hidden;"></div></li>
						<%
					} %>
					<!-- 新建并移动--start -->
					<li class="newitem"  onclick="createLabel2(2)">+<%=SystemEnv.getHtmlLabelName(31221 ,user.getLanguage()) %></li>
					<!-- 新建并移动--end -->
				</ul>
			</div>
			<!-- 移动到...end -->
			<%} %>
		</div>
		<div class="clear"></div>
	</div>

	<div class="line-1 ">&nbsp;</div>
	<div class="">
		<div id="mailTitle" class="mailTitle p-t-15 p-l-15">
			<div id="subject">
				<div class="font14 bold left  p-r-5"><%=Util.getMoreStr(getSubject(mrs.getSubject(),user), 40, "...")%></div>
				<%if(mrs.getStarred().equals("1")){ %>
					<div class=" fg2 fs2 left m-t-3 hand"  id="StarTarget"></div>
				<%}else{ %>
					<div class=" fg2 left m-t-3 hand"    id="StarTarget"></div>
				<%} %>
				<%
				ArrayList<MailLabel> mailLabels = lms.getMailLabels(mailid);
				String str ="";
				for(int i=0;i<mailLabels.size();i++){
						/*str+="<div class='label left' style='margin-left:3px; padding-left:3px;background:"+mailLabels.get(i).getColor()+"'>"
							+	"<span class='lbName' id='label_"+mailLabels.get(i).getId()+"'>"+mailLabels.get(i).getName()+"</span>"
							+     "<input type='hidden' name='lableId' value='"+mailLabels.get(i).getId()+"' />"
							+     "<input type='hidden' name='mailId' value='"+mailid+"' />"
							+	"<span class='closeLb hand' title='"+SystemEnv.getHtmlLabelName(81338,user.getLanguage())+"'><b>x</b></span>"
							+"</div>";*/
						str+="<div class='label hand' style='  background:"+mailLabels.get(i).getColor()+"'>"
						+	"<div class='left lbName'>"+mailLabels.get(i).getName()+"</div>"
						+     "<input type='hidden' name='lableId' value='"+mailLabels.get(i).getId()+"' />"
						+     "<input type='hidden' name='mailId' value='"+mailid+"' />"
						+	"<div class='left closeLb hand hide ' title='"+SystemEnv.getHtmlLabelName(81338,user.getLanguage())+"'></div>"
						+ "<div class='cleaer'></div>"	
						+"</div>";	
				}
				out.println(str);
				%>
				<div class="clear"></div>
			</div>
			<div id="from" class="m-t-5">
				<div class="color999 left  p-r-5"><%=SystemEnv.getHtmlLabelName(2034, user.getLanguage())%>:</div>
				<div class="left color999 p-r-5"> 
				
				<%
				if(mrs.getIsInternal()==1){
					out.print(SptmForMail.getHrmShowNameHref(mrs.getSendfrom()) );
				}else{
					out.print(SptmForMail.getNameByEmail(mrs.getSendfrom()) );
				}
				
				
				%>   </div>
				<%
				if(mrs.getIsInternal()!=1){
				int id = cms.getIdByMailAddress(mrs.getSendfrom(), user.getUID());
				if(id == -1){
				%>
				<div class="left ico_profileTips m-t-2" title="<%=SystemEnv.getHtmlLabelName(19956, user.getLanguage())%>" onclick="loadContactAdd(this)">
					<input type="hidden" name="sendFrom" value="<%=mrs.getSendfrom() %>" />
				</div>
				<%} else {%>
				<div class="left ico_profileTips m-t-2" title="<%=SystemEnv.getHtmlLabelName(81335, user.getLanguage())%>" onclick="loadContact(<%=id %>, this)">
				</div>
				<%}
				}%>
				
				<div class="clear"></div>
			</div>
			<div id="from" class="m-t-5">
				<div class="color999 left  p-r-5"><%=SystemEnv.getHtmlLabelName(19736, user.getLanguage())%>:</div>
				<div class="left color999 p-r-5"> <%=mrs.getSenddate() %> </div>
				<div class="clear"></div>
			</div>
		
			<!--收件人--start  -->
			<div id="to" class="m-t-5">
				<div class="color999 left  p-r-5"><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%>:</div>
				<div class="left color999 p-r-5 "   id="to_hrmshow" >
						<%
							if(mrs.getIsInternal()==1){
								//out.print(SptmForMail.getHrmShowNameHref(mrs.getSendto()));
								out.print(SptmForMail.getHrmShowNameHrefTOP(mrs,10,1));
							}else{
								out.print(SptmForMail.getNameByEmail(mrs.getSendto()) );
							}
						%>  
				</div>
				<div class="clear" style="height: 0px"></div>
			</div>
			<!--收件人--end  -->
			
			<%
			 boolean ccflag=false;
			 if(mrs.getIsInternal()==1){
				if("1".equals(mrs.getCcall())){
					ccflag=true;
				}else if(!"".equals(mrs.getCcdpids())){
					ccflag=true;
				}else if(!"".equals(mrs.getCcids())){
					ccflag=true;
				}		
			 }
				if(!mrs.getSendcc().trim().equals("")||ccflag){
					%>
				<div id="bcc" class="m-t-5">
					<div class="color999 left  p-r-5"><%=SystemEnv.getHtmlLabelName(17051, user.getLanguage())%>:</div>
					<div class="left color999 p-r-5"   id="">
					<%
							if(mrs.getIsInternal()==1){
								//out.print(SptmForMail.getHrmShowNameHref(mrs.getSendto()));
								out.print(SptmForMail.getHrmShowNameHrefTOP(mrs,10,2));
							}else{
								out.print(SptmForMail.getNameByEmail(mrs.getSendcc()) );
							}
				%>
				</div>
					<div class="clear" style="height: 0px"></div>
				</div>
				<%		
				}
			%>
			
			
			<%
				 boolean bccflag=false;
				 if(mrs.getIsInternal()==1){
					if("1".equals(mrs.getBccall())){
						bccflag=true;
					}else if(!"".equals(mrs.getBccdpids())){
						bccflag=true;
					}else if(!"".equals(mrs.getBccids())){
						bccflag=true;
					}		
				 }
				//密送人的判断
				//如果当前用户=改邮件的发送用户，就显示"密送人"
				if((!mrs.getSendbcc().trim().equals("")&&mrs.getIsInternal()==1)||bccflag){
					//内部邮件------------------------------密送人处理-----------------------------------
					boolean readBcc=false;
					if(mrs.getSendfrom().equals(""+user.getUID())){
							readBcc=true;
					}
					String send_bcc=","+mrs.getSendbcc()+",";
					if(send_bcc.indexOf(","+user.getUID()+",")!=-1){
						readBcc=true;
					}else if("1".equals(mrs.getBccall())){
						//密送给所有人
						readBcc=true;
					}else if(!"".equals(mrs.getBccids())&&(","+mrs.getBccids()+",").indexOf(","+user.getUID()+",")!=-1){
						//密送给某些人,并且包含当前用户
						readBcc=true;
					}else if(!"".equals(mrs.getBccdpids())){
						//密送给某个部门,并且包含当前用户
						rs0.execute("select id from HrmResource where departmentid in("+mrs.getBccdpids()+") and id='"+user.getUID()+"'");
						if(rs0.next()){
							readBcc=true;
						}
					}	
					if(readBcc){
					%>
				<div id="bcc" class="m-t-5">
					<div class="color999 left  p-r-5"><%=SystemEnv.getHtmlLabelName(81316, user.getLanguage())%>:</div>
					<div class="left color999 p-r-5"   id="">
					<%
							if(mrs.getIsInternal()==1){
								out.print(SptmForMail.getHrmShowNameHrefTOP(mrs,10,3));
							}else{
								out.print(SptmForMail.getNameByEmail(mrs.getSendbcc()) );
							}
					%>
				</div>
					<div class="clear" style="height: 0px"></div>
				</div>
				<%		
					}
				}else if(!mrs.getSendbcc().trim().equals("")&&mrs.getIsInternal()!=1){
					//外部邮件------------------------------密送人处理-----------------------------------
					boolean readBcc=false;
					//得到当前用户的所有邮箱账号
					rs0.execute("SELECT accountMailAddress FROM MailAccount WHERE userId='"+user.getUID()+"'");
				
					while(rs0.next()){
						//判断该邮件是不是我发出的邮件
						if((mrs.getSendfrom().toLowerCase()).equals(rs0.getString("accountMailAddress").toLowerCase())){
								 readBcc=true;
								 break;
						}
					}
					//如果是我发送的，就能看到密送人，否则不能看到密送人
					if(readBcc){
				%>
				<div id="bcc" class="m-t-5">
					<div class="color999 left  p-r-5"><%=SystemEnv.getHtmlLabelName(81316, user.getLanguage())%>:</div>
					<div class="left color999 p-r-5"   id="">
					<%
							if(mrs.getIsInternal()==1){
								//out.print(SptmForMail.getHrmShowNameHrefTOP(mrs.getSendbcc(),10));
								out.print(SptmForMail.getHrmShowNameHrefTOP(mrs,10,3));
							}else{
								out.print(SptmForMail.getNameByEmail(mrs.getSendbcc()) );
							}
					%>
				</div>
					<div class="clear" style="height: 0px"></div>
				</div>	
				<%
						}
					}
				%>
			
			
			<%
			mrfs.selectMailResourceFileInfos(mailid+"","1");
			ArrayList filenames = new ArrayList() ;
			ArrayList filenums  = new ArrayList() ;
			ArrayList filenameencodes  = new ArrayList() ;
			int fileNum=0;
			if(mrfs.getCount()>0){ %>
			<div id="attachment" class="m-t-5">
				<div class="color999 left  p-r-5"><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%>:</div>
				<div class="left color333 p-r-5"> 
					<%
						while(mrfs.next()){ 
							int fileId = mrfs.getId();
							filenames.add(mrfs.getFilename()) ;
							filenums.add(fileId+"") ;
							filenameencodes.add("1") ;
							fileNum++ ; 
							String fileUrl = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+fileId;
						%>
						<a href="<%=fileUrl%>&download=1" style="color:blue;text-decoration:underline"><%=Util.toScreen(mrfs.getFilename(), user.getLanguage())%></a>&nbsp;
						<%}%>
				 </div>
				<div class="clear"></div>
			</div>
			<%} %>
		</div>	
		
	
	</div>
	</div>
	<iframe id="mailContent" class="" frameborder="0" width="100%" height="100%" scrolling="auto" src="MailContentView.jsp?mailid=<%=mailid%>">
		
	</iframe>
	<%
	wmc.setTotlefile(fileNum);
	wmc.setFilenames(filenames);
	wmc.setFilenums(filenums);
	wmc.setFilenameencodes(filenameencodes);
	session.setAttribute("WeavermailComInfo", wmc);
	%>
</div>

</form>

<!-- 添加联系人 -->
<div id="contactAdd" class="popWindow hide "></div>

<!-- 修改联系人 -->
<div id="contactEdit" class="popWindow hide "></div>

<!-- 静态初始化一个leanModal遮罩 -->
<div id="lean_overlay"></div>

<style>
<!--
	.tzSelect{
		top:8px !important ;
		top:4px ;
		display:inline-block !important ;
		display:inline ;
		margin-left: 2px;
	}
	.popWindow{
	      width:450px;
	      height:auto;
	      box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
	      border: 2px solid #90969E;
	      background: #ffffff;
	}
	#lean_overlay {
	    position: fixed;
	    z-index:100;
	    top: 0px;
	    left: 0px;
	    height:100%;
	    width:100%;
	    background: #000;
	    display: none;
	    filter: alpha(opacity=30);
	}
	.Bdy{
		padding:0px;
	}
	.ico_profileTips {
		background: url('/email/images/mailicon.png') -64px -220px no-repeat;
		border: 0px;
		border-image: initial;
		padding: 0px;
		width: 16px;
		height: 14px;
		padding-right:1px;
		vertical-align: middle;
	}
	.mailTitle{
		background: #f2f2f2;
		
	}
	.workMail{
		background: #C58D44;
		color:#ffffff;
		width: 50px;
		padding:3 15 3 15;
		height: 15px;
	}
	.ico_mailtitle {
		background: url('/email/images/mailicon.png') 1px -82px no-repeat;
		width: 26px;
		height: 16px;
	}
	table.O2 {
		border-top: 1px solid white;
		color: #333333;
		font-size:12px;
	}
	td.o_title2 {
		background: url(/email/images/mailicon.png) -128px 0px repeat-y;
		margin: 0px;
		padding: 0px 0px 0px 12px;
	}
	table.O2 td {
		border-bottom: 1px solid #C1C8D2;
		background-color: #F2F4F6;
		padding-top: 0px;
	}
	
	table{
		font-size: 12px!important;
	}
	
	table.M, table.F {
		height: 24px;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #E3E6EB;
		font-weight: normal;
		clear: both;
		
	}
	table.i {
		table-layout: fixed;
		
	}
	table.i td.cx, table.i td.cx_s {
		vertical-align: top;
		padding: 3px 0px 1px 5px;
		width: 24px;
	}

	table.i td.ci {
		vertical-align: top;
		width: 50px;
		padding: 4px 0px 0px;
	}

	table.i td.l {
		padding-top: 2px;
		cursor: pointer;
	}
	table.i td.tl {
		width: 111px;
		padding-right: 12px;
	}
	.txtflow, .tf {
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}
	table.i td.fg_n {
		width: 23px;
	}
	
	.txtflow, .tf {
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}
	
	table.i td.dt {
		width: 100px;
		white-space: nowrap;
	}

	table.i td.fg {
		width: 20px;
	}
	table.i td.ci div.ciz {
		width: 9px;
		margin-top: 2px;
	}
	table.i td.ci div.cir {
		width: 18px;
		height: 16px;
		overflow: hidden;
		cursor: pointer;
	}
	table.i .no {
		font-weight: normal;
		font-size: 12px;
	}
	.Rr {
		background: url(/email/images/mailicon.png) -48px -16px no-repeat;
	}
	.Ru {
		background: url(/email/images/mailicon.png) -48px 0px no-repeat;
	}
	.Ju {
		background: url(/email/images/mailicon.png) -65px 0px no-repeat;
		cursor: pointer;
	}
	.fg2{
		width: 14px;
		height: 14px;
		background: url(/email/images/mailicon.png) -32px -160px no-repeat;
	}
	.fs2{
		width: 14px;
		height: 14px;
		background: url(/email/images/mailicon.png) -48px -160px no-repeat;
	}
	table.i td.ci div.cij {
		width: 12px;
		height: 12px;
		overflow: hidden;
		margin-top: 3px;
	}
	div{
		font-size: 12px;
	}
	
	
	
	.lbName{
		color:#ffffff;
		height: 20px;
		padding-left:8px;
		line-height: 20px;
		vertical-align: middle;
		
	}
	.closeLb{
		background: url("/email/images/closeNew.png") left center;
		background-repeat: no-repeat;
		width: 18px;
		height: 20px;
		margin-left: 5px;
	}
	.label{
		border-radius: 2px;
		float: right;
		display: inline-block;
		padding-right: 8px;
		height: 20px;
		line-height: 20px;
		margin-left: 3px;
	}
	
	.selectBox{
		height: 25px!important;
		margin-left: 3px;
	}
-->
</style>

<script>

jQuery(document).ready(function(){
	
	//$("#mailContent").css("height",document.body.clientHeight-40);
	if('<%=layout%>'==3){
		$("#mailContent").css("height",document.body.clientHeight-$("#MailViewMain").height()-10);
	}else if('<%=layout%>'==2){
		
		$("#mailContent").css("height",document.body.clientHeight-$("#MailViewMain").height());
		$("#mailContent").css("width",document.body.clientWidth/2);
	}else{
		$("#mailContent").css("height",document.body.clientHeight-$("#MailViewMain").height());
		//$("#mailContent").css("width",document.body.clientWidth);
	}
	
	
	mailViewInit();
	//zzl-更新tab页的标题
	if('<%=layout%>'==3){
		$(window.parent.document).find(".active > .title").html("<%=getSubject(mrs.getSubject(),user)%>");	
	}
	
	$(document).bind("click",function(){
			$(".btnGrayDropContent").hide();
	})
	
});

/**************start*****************MailContactAdd.jsp页面依赖代码******************************************/
//添加联系人
function submitFMailContacter() {
	//checkInput方法在contacts.jsp页面
	if(checkInput("contactAdd")) {
		var param = $("div#contactAdd #fMailContacter").serializeArray();
		$.post("/email/new/ContactManageOperation.jsp", param, function(){
			$("#addContact").close_modal("div#contactAdd");
			reloadCurrentPage();
		});
	} else {
		alert("<%=SystemEnv.getHtmlLabelName(30935, user.getLanguage())%>！");
	}
}

//修改联系人
function editContacter() {
	//checkInput方法在contacts.jsp页面
	if(checkInput("contactEdit")) {
		var param = $("div#contactEdit #fMailContacter").serializeArray();
		$.post("/email/new/ContactManageOperation.jsp", param, function(){
			$("#addContact").close_modal("div#contactEdit");
		});
	} else {
		alert("<%=SystemEnv.getHtmlLabelName(30935, user.getLanguage())%>！");
	}
}

var dlg;
//在其子页面中，调用此方法打开相应的界面
function openDialog(title,url) {
			dlg=new Dialog();//定义Dialog对象
			dlg.Model=true;
			dlg.Width=500;//定义长度
			dlg.Height=400;
			dlg.URL=url;
			dlg.Title=title;
			dlg.OKEvent = SaveDate;//点击确定后调用的方法
			dlg.show();
				
}

function closeDialog() {
		dlg.close();
}
function SaveDate(){
	   // var tempJson= document.getElementById("_DialogFrame_0").contentWindow.getSerialize();
	     document.getElementById("_DialogFrame_0").contentWindow.submitDate(dlg);
	 	
		/* $(temp).each(function(i,data){
				alert(data);
		}) */
}

//载入指定的联系人
function loadContact(id, himself) {
	openDialog("<%=SystemEnv.getHtmlLabelName(31229, user.getLanguage())%>","/email/new/MailContacterAdd.jsp?id="+id);
	/* $("#contactEdit").load("/email/new/MailContacterAdd.jsp", param, function(){
		//initContactModal(this);
		$(himself).show_modal({ overlay:0.3, closeButton: ".modal_close" }, this)
	}); */
}

//载入添加联系人页面
function loadContactAdd(himself) {
	openDialog("<%=SystemEnv.getHtmlLabelName(19956, user.getLanguage())%>","/email/new/MailContacterAdd.jsp");
	/* $("#contactAdd").load("/email/new/MailContacterAdd.jsp", function(){
		//initContactModal(this);
		checkInput("contactAdd");
		$(himself).show_modal({ overlay:0.3, closeButton: ".modal_close" }, this)
	}); */
}
/**************end*****************MailContactAdd.jsp页面依赖代码******************************************/

function mailViewInit(){
	
	
	$("#signAs02").bind("click",function(event){
		$(".btnGrayDropContent").hide();
		 var x=$(this).offset().left;
		 var y=$(this).offset().top;
		 //alert($(this).offset().left);
		// $("#signAs02").find(".btnGrayDropContent").css("top",y+25);
		// $("#signAs02").find(".btnGrayDropContent").css("left",x);
		$("#signAs02").find(".btnGrayDropContent").show(); 
		stopEvent();
	}).find(".item").bind("click", function(event){
			var mails = '<%=mailid%>';
			var labelid = $(this).attr("target");
			if(mails==""){
				return;
			}
			var param = {"mailsId": mails, "operation": "addLable", "lableId": labelid};
			$.post("/email/new/MailManageOperation.jsp", param, function(){
			});
			$(".btnGrayDropContent").hide();
			stopEvent();
			window.document.location.reload();
	});
	
	$("#signAs02").find("li").mouseover(function(){
			$(this).css("background-color","#cccccc");
	}).mouseout(function(){
			$(this).css("background-color","rgb(248, 248, 248)");
	});
	$("#moveTo02").bind("click",function(event){
		$(".btnGrayDropContent").hide();
		var x=$(this).offset().left;
		var y=$(this).offset().top;
		 //alert($(this).offset().left);
		//$("#moveTo02").find(".btnGrayDropContent").css("top",y+25);
		//$("#moveTo02").find(".btnGrayDropContent").css("left",x);
		$("#moveTo02").find(".btnGrayDropContent").show();
		stopEvent();
	}).find(".item").bind("click", function(event){
		var mails = '<%=mailid%>';
		var folderid = $(this).attr("target");
		if(mails==""){
			return;
		}
		moveMailToFolder(mails,folderid)
	});
	
	$("#moveTo02").find("li").mouseover(function(){
			$(this).css("background-color","#cccccc");
	}).mouseout(function(){
			$(this).css("background-color","rgb(248, 248, 248)");
	});
	<%-- $('#viewMoveFolder').tzSelect();
	
	//移动指定邮件
	$("select#viewMoveFolder").bind("change", function(){
		var mails = '<%=mailid%>';
		var folderid = $(this).val()
		if(mails==""){
			return;
		}
		moveMailToFolder(mails,folderid)
		
	}); --%>
	
	<%-- $('#viewMarkLable').bind("change",function(){
		var mails = '<%=mailid%>';
		var labelid = $(this).val()
		if(mails==""){
			return;
		}
		if($("#label_"+labelid).length>0){
			return;
		}else{
			var param = {"mailsId": mails, "operation": "addLable", "lableId": labelid};
			$.post("/email/new/MailManageOperation.jsp", param, function(){
				
			});
		}
	}) --%>
	
	
	jQuery("#replayBtn").bind("click",function(){
			//回复
			
			var url="/email/new/MailAdd.jsp?flag=1&id=<%=mailid%>"
			
					window.parent.addTab("1",url,"Re:<%=mrs.getSubject() %>","");
			
	})

	jQuery("#replayAllBtn").bind("click",function(){
		//回复全部
		var url="/email/new/MailAdd.jsp?flag=2&id=<%=mailid%>"
		
			window.parent.addTab("1",url,"Re:<%=mrs.getSubject() %>","");
		
	})
	jQuery("#forwardBtn").bind("click",function(){
		//转发
		var url="/email/new/MailAdd.jsp?flag=3&id=<%=mailid%>"
		
			window.parent.addTab("1",url,"Fw:<%=mrs.getSubject() %>","");
		
	})
	<%if(folderid != -3) {%>
	jQuery("#delBtn").bind("click",function(){
		//删除
		if(isdel()){
			moveMailToFolder('<%=mailid%>',"-3");
			
				window.parent.deleteTab();
			
		}
	})
	<%}%>
	jQuery("#dropBtn").bind("click",function(){
		//删除全部
		if(isdel()){
			deleteMail('<%=mailid%>');
			
				window.parent.deleteTab();
			
		}
	})
	
	

	
	
	initLableTarget();
	initStarTarget();
		
}

//标签功能
function initLableTarget(){
	//初始化标签中的closeLb按钮
	$("div.label").find("div.closeLb").bind("click", function(){
		var self = this;
		var hisParent = $(self).parent();
		var mailId = $(hisParent).find("input[name=mailId]").val();
		var lableId = $(hisParent).find("input[name=lableId]").val();
		var param = {"mailId": mailId, "lableId": lableId, "operation": "removeLable"};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
			$(hisParent).remove();
		});
	});
	
	$(".label").mouseenter(function(){
		var obj = $(this);
		t=setTimeout(function(){
			
			$(obj).find(".closeLb").show();
		},500);
	}).mouseleave(function(){
		var obj = $(this);
		
		$(obj).find(".closeLb").hide();
		clearTimeout(t);
		
	});
}

//移动邮件到指定文件夹
function moveMailToFolder(mailIds,folderid){
	if(mailIds!=""){
		var param = {"mailId": mailIds,movetoFolder:folderid, "operation": "move"};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
			window.parent.document.location.reload();
		});
	}
}

//星标功能
function initStarTarget(){

	$(".fg2").bind("click", function(){
		var self = this;
		var mailId = '<%=mailid%>';
		if($(self).hasClass("fs2")) {
			var param = {"mailId": mailId, "star": 0, "operation": "updateStar"};
			$.post("/email/new/MailManageOperation.jsp", param, function(){
				$(self).removeClass("fs2");
			});
		} else {
			var param = {"mailId": mailId, "star": 1, "operation": "updateStar"};
			$.post("/email/new/MailManageOperation.jsp", param, function(){
				$(self).addClass("fs2");
			});
		}
	});
}

function Goto(url){	
	
	//window.open(url,"mainFrame");
	window.location.href=url;
	
}

//彻底删除邮件
function deleteMail(maiId){
	if(maiId!=""){
		var param = {"mailId": maiId, "operation": "delete"};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
			//window.parent.document.location.reload();
			if("<%=layout%>"==3){//平铺
				window.parent.deleteTab();
			}else{
				window.parent.parent.deleteTab();
			}
		});
	}
}

//重载当前页面
function reloadCurrentPage() {
	var url = "MailView.jsp?mailid="+<%=mailid%>+"&folderid=<%=folderid%>";
	$("#mailContentContainer").load(url,function(){
		mailViewInit(<%=mailid%>,url);
	});
}

//为指定的元素添加按键响应 mailContentContainer
function pageTurning(event) {
	switch(event.keyCode) {
	case 37:
		nextMail(<%=mailid%>);
		stopEvent();
		break;
	case 39:
		prevMail(<%=mailid%>);
		stopEvent();
		break;
	}
}

$(".btnSpan").hover(
	function(){$(this).addClass("btnSpanOver")},
	function(){$(this).removeClass("btnSpanOver")}
);

$(".label").mouseenter(function(){
	var obj = $(this);
	t=setTimeout(function(){
		
		$(obj).find(".closeLb").show();
	},500);
}).mouseleave(function(){
	var obj = $(this);
	
	$(obj).find(".closeLb").hide();
	clearTimeout(t);
	
});

function openShowNameHref(to,obj,type){
	if(type==1){
		window.parent.addTab("1","/email/new/MailAdd.jsp?to="+to,"<%=SystemEnv.getHtmlLabelName(30912, user.getLanguage())%>");
	}else{
		window.parent.addTab("1","/email/new/MailAdd.jsp?to="+to+"&isInternal=0","<%=SystemEnv.getHtmlLabelName(30912, user.getLanguage())%>");
	}
}

//阻止事件冒泡
function stopEvent() {
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation();
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
}

function cancelLabel2(obj){
	var mails = "<%=mailid%>";
	var param = {"mailsId": mails, "operation": "cancelLabel"};
	$.post("/email/new/MailManageOperation.jsp", param, function(){
		$(obj).parent().hide();
	});
}
function createLabel2(type){
	var mails = "<%=mailid%>";
	if(type==1){
		openDialogcreateLabel2("<%=SystemEnv.getHtmlLabelName(31220, user.getLanguage())%>","/email/new/LabelCreate.jsp?mailsId="+mails+"&type=1",1);
	}else{
		openDialogcreateLabel2("<%=SystemEnv.getHtmlLabelName(31221, user.getLanguage())%>","/email/new/LabelCreate.jsp?mailsId="+mails+"&type=2",2);
	}
	
}
var dlgcreateLabel2;
//在其子页面中，调用此方法打开相应的界面
function openDialogcreateLabel2(title,url,type) {
			dlgcreateLabel2=new Dialog();//定义Dialog对象
			dlgcreateLabel2.Model=true;
			dlgcreateLabel2.Width=500;//定义长度
			if(type==2){
				dlgcreateLabel2.Height=100;
			}else{
				dlgcreateLabel2.Height=200;
			}
			dlgcreateLabel2.URL=url;
			dlgcreateLabel2.Title=title;
			dlgcreateLabel2.OKEvent = SaveDatecreateLabel02;//点击确定后调用的方法
			dlgcreateLabel2.show();			
}
function closeDialogcreateLabel() {
		dlgcreateLabel2.close();
		window.document.location.reload();
}
function SaveDatecreateLabel02(){
	     document.getElementById("_DialogFrame_0").contentWindow.submitDate(dlg);
}
function showALL(obj,type){
	$(obj).val("<%=SystemEnv.getHtmlLabelName(31230, user.getLanguage())%>...");
	//延迟加载数据，达到一种好的加载效果
	 setTimeout(
	 	function(){
	 				$.post("/email/new/MailLoadHrmAjax.jsp?type="+type, "", function(data){
							$(obj).parent().html(data);
							if($("#to_hrmshow").height()>=100){
									$("#to_hrmshow").height("100px");
									$("#to_hrmshow").css("overflow-x","none").css("overflow-y","auto");
							}
					});
	 	}
	 ,1500);
}	

function isdel(){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   if(!confirm(str)){
       return false;
   }
       return true;
 }
</script>
<%@ include file="/email/new/simpleHrmResource.jsp" %>
<%!
public String getSubject(String subject ,User user){
	if(subject.equals("")){
		return SystemEnv.getHtmlLabelName(31240,user.getLanguage());
	}else{
		return subject;
	}
}
%>
