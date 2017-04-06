<%@page import="org.apache.commons.httpclient.util.DateUtil"%>
<%@page import="weaver.general.Time"%>
<%@page import="weaver.email.domain.MailLabel"%>
<%@page import="weaver.email.service.MailResourceService"%>
<%@page import="weaver.email.service.LabelManagerService"%>
<%@page import="weaver.email.service.MailSettingService"%>
<%@ page import="weaver.splitepage.transform.SptmForMail" %>

<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />



<%
	
	String mailtype = Util.null2String(request.getParameter("mailtype"));
	String folderid = Util.null2String(request.getParameter("folderid"));
	String labelid = Util.null2String(request.getParameter("labelid"));
	String subject = Util.null2String(request.getParameter("subject"));
	String star = Util.null2String(request.getParameter("star"));
	int index = Util.getIntValue(request.getParameter("index"),1);
	int perpage = Util.getIntValue(request.getParameter("perpage"),20);
	int isInternal = Util.getIntValue(request.getParameter("isInternal"),-1);
	
	String mailaccountid = Util.null2String(request.getParameter("mailaccountid"));
	String status = Util.null2String(request.getParameter("status"));
	String from = Util.null2String(request.getParameter("from"));
	String to = Util.null2String(request.getParameter("to"));
	String attachmentnumber = Util.null2String(request.getParameter("attachmentnumber"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	
	mrs.setResourceid(user.getUID()+"");
	mrs.setFolderid(folderid+"");
	mrs.setLabelid(labelid);
	mrs.setStarred(star);
	mrs.setSubject(subject.trim());
	mrs.setSendfrom(from);
	mrs.setSendto(to);
	mrs.setStatus(status);
	mrs.setAttachmentnumber(attachmentnumber);
	mrs.setMailaccountid(mailaccountid);
	mrs.setIsInternal(isInternal);
	mrs.setStartdate(startdate);
	mrs.setEnddate(enddate);
	mrs.selectMailResourceSplitePage(perpage,index);
	
	int currentYear = new Date().getYear();
	
	int currentWeek = TimeUtil.getWeekOfYear(new Date(),2);
	String currentDate = TimeUtil.getCurrentDateString();
	int currentWeekDate =TimeUtil.dateWeekday(currentDate);
	
	int day7Count=0;
	int day1Count=0;
	int day2Count=0;
	int day3Count=0;
	int day4Count=0;
	int day5Count=0;
	int day6Count=0;
	int lastWeekCount=0;
	int beforLastWeekCount = 0;
	
	StringBuffer day7Table = new StringBuffer();
	StringBuffer day1Table = new StringBuffer();
	StringBuffer day2Table = new StringBuffer();
	StringBuffer day3Table = new StringBuffer();
	StringBuffer day4Table = new StringBuffer();
	StringBuffer day5Table = new StringBuffer();
	StringBuffer day6Table = new StringBuffer();
	StringBuffer lastWeekTable =new StringBuffer();
	StringBuffer beforLastWeekTable = new StringBuffer();
	
	while(mrs.next()){
		String sendDate =  mrs.getOnlySenddate();
		int theWeek = TimeUtil.getWeekOfYear(TimeUtil.getString2Date(sendDate,"yyyy'-'MM'-'dd"),2);
		
		//out.println(currentWeek+"=="+theWeek+"<br>");
		int theDay = TimeUtil.dateWeekday(sendDate);
		
		Calendar cl =  TimeUtil.getCalendar(sendDate,"yyyy'-'MM'-'dd");
		
		int theYear = TimeUtil.getString2Date(sendDate,"yyyy'-'MM'-'dd").getYear();
		//out.println(theYear+"=="+currentYear+"day"+theDay+"<br>");
		if(theYear==currentYear&&theWeek==currentWeek){ // 
			//out.println(theDay);
			
			
			if(theDay==1){
				day1Count++;
				day1Table.append(getTableString(mrs,user));	
			}
			if(theDay==2){
				day2Count++;
				day2Table.append(getTableString(mrs,user));	
			}
			if(theDay==3){
				day3Count++;
				day3Table.append(getTableString(mrs,user));	
			}
			if(theDay==4){
				day4Count++;
				day4Table.append(getTableString(mrs,user));	
			}
			if(theDay==5){
				day5Count++;
				day5Table.append(getTableString(mrs,user));	
			}
			if(theDay==6){
				day6Count++;
				day6Table.append(getTableString(mrs,user));	
			}
			if(theDay==0){
				day7Count++;
				day7Table.append(getTableString(mrs,user));	
			}
			
		}
		
		//上周
		if(theYear==currentYear&&theWeek==currentWeek-1){
			lastWeekCount++;
			lastWeekTable.append(getTableString(mrs,user));
			
		}else if(theYear==currentYear-1&&theWeek==TimeUtil.getMaxWeekNumOfYear(theYear)&&currentWeek==1){
			lastWeekCount++;
			lastWeekTable.append(getTableString(mrs,user));
		}
		
		//更早
		if(theYear<currentYear||theWeek<currentWeek-1){
			beforLastWeekCount++;
			beforLastWeekTable.append(getTableString(mrs,user));
			
		}
	}
	

	if(day1Count>0){
		if(currentWeekDate==1){
			day1Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day1Count+")--></div>");
		}else{
			day1Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(392,user.getLanguage())+"</font> <!--("+day1Count+")--></div>");
		}
		day1Count=0;
	}
	if(day2Count>0){
		if(currentWeekDate==2){
			day2Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day2Count+")--></div>");
		}else{
			day2Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(393,user.getLanguage())+"</font> <!--("+day2Count+")--></div>");
		}
		day2Count=2;
	}
	if(day3Count>0){
		if(currentWeekDate==3){
			day3Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day3Count+")--></div>");
		}else{
			day3Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(394,user.getLanguage())+"</font> <!--("+day3Count+")--></div>");
		}
		day3Count=0;
	}
	if(day4Count>0){
		if(currentWeekDate==4){
			day4Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day4Count+")--></div>");
		}else{
			day4Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(395,user.getLanguage())+"</font> <!--("+day4Count+")--></div>");
		}
		day4Count=0;
	}
	if(day5Count>0){
		if(currentWeekDate==5){
			day5Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day5Count+")--></div>");
		}else{
			day5Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(396,user.getLanguage())+"</font> <!--("+day5Count+")--></div>");
		}
		day5Count=0;
	}
	if(day6Count>0){
		if(currentWeekDate==6){
			day6Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day6Count+")--></div>");
		}else{
			day6Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(397,user.getLanguage())+"</font> <!--("+day6Count+")--></div>");
		}
		day6Count=0;
	}
	
	if(day7Count>0){
		if(currentWeekDate==0){
			day7Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day7Count+")--></div>");
		}else{
			day7Table.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(398,user.getLanguage())+"</font> <!--("+day7Count+")--></div>");
		}
		day7Count=0;
	}
	
	if(lastWeekCount>0){
		lastWeekTable.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(26789,user.getLanguage())+"</font> <!--("+lastWeekCount+")--></div>");
		lastWeekCount=0;
	}
	if(beforLastWeekCount>0){
		beforLastWeekTable.insert(0,"<div style='color:#00659D' class='font12 p-t-5 '> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(81336,user.getLanguage())+"</font> <!--("+beforLastWeekCount+")--></div>");
		beforLastWeekCount = 0;
	}
%>
		<%=day7Table.toString() %>
		<%=day6Table.toString() %>
		<%=day5Table.toString() %>
		<%=day4Table.toString() %>
		<%=day3Table.toString() %>
		<%=day2Table.toString() %>
		<%=day1Table.toString() %>
		
		<%=lastWeekTable.toString() %>
		<%=beforLastWeekTable.toString() %>
		
		<%!
		
			public String getTableString(MailResourceService mrs ,User user){
				MailSettingService mailSettingService = new MailSettingService();
				mailSettingService.selectMailSetting(user.getUID());
				int userLayout = Util.getIntValue(mailSettingService.getLayout(),0);
				String str="";
				str ="<table id='tbl_"+mrs.getId()+"' cellspacing='0' class='mailitem i M h-25'>"+

				"<tr>"+
					"<td class='cx'>"+
						"<input  type='checkbox' status="+mrs.getStatus()+"  sendfrom='"+mrs.getSendfrom()+"' name='mailid' value="+mrs.getId()+"  starred='"+mrs.getStarred()+"' >"+
					"</td>"+
					"<td class='ci'>"+
						"<div class='ciz left'>&nbsp;</div>";
					if(mrs.getStatus().equals("1")){
						str+="<div class='cir left Rr' title='"+SystemEnv.getHtmlLabelName(25425,user.getLanguage())+"'>&nbsp;</div>";
					}else{
						str+="<div class='cir left Ru' title='"+SystemEnv.getHtmlLabelName(25426,user.getLanguage())+"'>&nbsp;</div>";
					}
					if(mrs.getAttachmentnumber().equals("0")){
						str+="<div class='cij left ' >&nbsp;</div>";
					}else{
						str+="<div class='cij left Ju' title='"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"'>&nbsp;</div>";
					}
					SptmForMail spm = new SptmForMail();	
					str +="</td>"
					   +"<td>"
					   +	"<table cellspacing='0' class='i'>"
							
					   +		"<tr>"
						+			"<td class='tl tf' style='width:200px;' title='"+mrs.getSendfrom()+"'>"
						+				"<nobr>"+spm.getMailSendFromRealName(mrs.getSendfrom(),mrs.getIsInternal())+"&nbsp;</nobr>"
						+			"</td>";
						if(userLayout == 2) {
							
						} else {
						str +=		"<td class='fg_n '>"
						    +			"<div></div>"
						    +		"</td>";
						}
						str +=		"<td class='gt tf'><div class='relative'>";
						if(mrs.getFolderid().equals("-2")) {
							str +=		"<div class='title hand' id='draft'  onclick='ctwMail("+mrs.getId()+",this)' title='"+mrs.getSubject()+"'>"+getSubject(mrs.getSubject(),user)+"</div>";
						} else {
							str +=		"<div class='title hand'  onclick='viewMail("+mrs.getId()+",this)' title='"+mrs.getSubject()+"'>"+getSubject(mrs.getSubject(),user)+"</div>";
						}
						
						LabelManagerService lms = new LabelManagerService();
						int mailId = Util.getIntValue(mrs.getId());
						ArrayList<MailLabel> mailLabels = lms.getMailLabels(mailId);
						
						String labelStr = "";
						for(int i=0;i<mailLabels.size();i++){
							labelStr+="<div class='label hand' style='  background:"+mailLabels.get(i).getColor()+"' _conmenu='1'>"
									+	"<div class='left lbName'>"+mailLabels.get(i).getName()+"</div>"
									+     "<input type='hidden' name='lableId' value='"+mailLabels.get(i).getId()+"' />"
									+     "<input type='hidden' name='mailId' value='"+mailId+"' />"
									+	"<div class='left closeLb hand hide ' title='"+SystemEnv.getHtmlLabelName(81338,user.getLanguage())+"' name='nb'></div>"
									+ "<div class='cleaer'></div>"	
									+"</div>";
						}
						if(userLayout == 2) {
							str += "<td style='width: 7px;'></td>";
						} else {
						if(!labelStr.equals("")){
							str +="<div class='absolute' style='right:5px;top:0px'>"+labelStr+"</div>";
						}
						
						str+=			"</div></td>"
							+		"<td class='dt'>"
							+			"<div>"+mrs.getOnlySenddate()+"</div>"
							+		"</td>";
						}
						if(mrs.getStarred().equals("1")){
							str+=		"<td class='fg fs1 hand' title='"+SystemEnv.getHtmlLabelName(81297,user.getLanguage())+"'><div><input type='hidden' name='mailId' value='"+mailId+"' /></div></td>";
						}else{
							str+=		"<td class='fg hand' title='"+SystemEnv.getHtmlLabelName(81337,user.getLanguage())+"'><div><input type='hidden' name='mailId' value='"+mailId+"' /></div></td>";
							
						}
						str+=		"</tr>"
							
						+"				</table>"
						+			"</td>"
						+		"</tr>"
						
						+"</table>";
				return str;
			}		
			
			public String getSubject(String subject ,User user){
				if(subject.equals("")){
					return "("+SystemEnv.getHtmlLabelName(31240,user.getLanguage())+")";
				}else{
					return subject;
				}
			}
		%>