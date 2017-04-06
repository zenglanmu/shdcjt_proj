<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.voting.bean.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="vcm" class="weaver.voting.VotingCollectManager" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(17599, user.getLanguage())+ ":" + SystemEnv.getHtmlLabelName(356, user.getLanguage());
String needfav = "1";
String needhelp = "";
String temptitlename = titlename;
boolean canmaint = HrmUserVarify.checkUserRight("Voting:Maint",user);
boolean canParticular = HrmUserVarify.checkUserRight("Voting:particular",user);
boolean canviewall = false;

boolean islight = true;
String userid = user.getUID() + "";

String votingid = Util.fromScreen(request.getParameter("votingid"),7);
String chiefType = Util.null2String(request.getParameter("chiefType"));
String rchiefId = Util.null2String(request.getParameter("chiefId"));

vcm.setVotingId(votingid);
vcm.setChiefType(chiefType);
vcm.setChiefId(rchiefId);
vcm.setQuestionid("");
VotingBean vb = vcm.getVotingBean();
String nextChiefType = "";
if("com".equals(chiefType))
{
	nextChiefType = "dept";
}
boolean canresulet = false;
String sqlstr = "select resourceid from VotingViewerDetail where votingid ="+votingid;
RecordSet.execute(sqlstr);
while(RecordSet.next()){
  if(userid.equals(RecordSet.getString("resourceid"))){
    canresulet = true;
  }
}

String tempsql = "select distinct t1.id from voting t1,VotingShareDetail t2"+ 
" where t1.id=t2.votingid"+
" and t1.isSeeResult = 1"+
" and " +userid+ " in (select distinct resourceid from VotingShareDetail where votingid =" +votingid+ ")";
String chiefSql = vcm.getChiecfSql();
RecordSet.executeSql(chiefSql);
RecordSet.next();
String subject = RecordSet.getString("subject");
String createrid = RecordSet.getString("createrid");
String createdate = RecordSet.getString("createdate");
String createtime = RecordSet.getString("createtime");
String approverid = RecordSet.getString("approverid");
String approvedate = RecordSet.getString("approvedate");
String approvetime = RecordSet.getString("approvetime");
String begindate = RecordSet.getString("begindate");
String begintime = RecordSet.getString("begintime");
String enddate = RecordSet.getString("enddate");
String endtime = RecordSet.getString("endtime");
String isanony = RecordSet.getString("isanony");
String docid = RecordSet.getString("docid");
String crmid = RecordSet.getString("crmid");
String projectid = RecordSet.getString("projid");
String requestid = RecordSet.getString("requestid");
int votingcount = Util.getIntValue(RecordSet.getString("votingcount"),0);
String status = RecordSet.getString("status");
String isSeeResult = RecordSet.getString("isSeeResult");
String sql = "select v.* From Voting v where  v.id = "+votingid;
RecordSet.executeSql(sql);
RecordSet.next();
String detail = RecordSet.getString("detail");
if(null==subject||"".equals(subject))
	subject = RecordSet.getString("subject");
if(null==createrid||"".equals(createrid))
	createrid = RecordSet.getString("createrid");
if(null==createdate||"".equals(createdate))
	createdate = RecordSet.getString("createdate");
if(null==createtime||"".equals(createtime))
	createtime = RecordSet.getString("createtime");
if(null==approverid||"".equals(approverid))
	approverid = RecordSet.getString("approverid");
if(null==approvedate||"".equals(approvedate))
	approvedate = RecordSet.getString("approvedate");
if(null==approvetime||"".equals(approvetime))
	approvetime = RecordSet.getString("approvetime");
if(null==begindate||"".equals(begindate))
	begindate = RecordSet.getString("begindate");
if(null==begintime||"".equals(begintime))
	begintime = RecordSet.getString("begintime");
if(null==enddate||"".equals(enddate))
	enddate = RecordSet.getString("enddate");
if(null==endtime||"".equals(endtime))
	endtime = RecordSet.getString("endtime");
if(null==isanony||"".equals(isanony))
	isanony = RecordSet.getString("isanony");
if(null==docid||"".equals(docid))
	docid = RecordSet.getString("docid");
if(null==crmid||"".equals(crmid))
	crmid = RecordSet.getString("crmid");
if(null==projectid||"".equals(projectid))
	projectid = RecordSet.getString("projid");
if(null==requestid||"".equals(requestid))
	requestid = RecordSet.getString("requestid");
if(0==votingcount)
	votingcount = Util.getIntValue(RecordSet.getString("votingcount"),0);
if(null==status||"".equals(status))
	status = RecordSet.getString("status");
if(null==isSeeResult||"".equals(isSeeResult))
	isSeeResult = RecordSet.getString("isSeeResult");
if("1".equals(isSeeResult) && !canresulet){
  RecordSet.executeSql(tempsql);
  if (RecordSet.next()){
	response.sendRedirect("/notice/noright.jsp");
	return;
  }   
}

if (userid.equals(createrid) || userid.equals(approverid))
	canviewall = true;

if (canmaint)
	canviewall = true;

ArrayList selectoptionids = new ArrayList();
RecordSet.executeSql("select optionid from votingresource where resourceid="+ userid);
while (RecordSet.next()) {
	selectoptionids.add(RecordSet.getString("optionid"));
}

titlename += "&nbsp;&nbsp;" + "<b>"
		+ SystemEnv.getHtmlLabelName(125, user.getLanguage())
		+ ":&nbsp;</b>"
		+ createdate
		+ "&nbsp;&nbsp;"
		+ createtime
		+ "&nbsp;&nbsp;"
		+ "<b>"
		+ SystemEnv.getHtmlLabelName(271, user.getLanguage())
		+ ":&nbsp;</b>"
		+ "<a href=\"javaScript:openhrm('"
		+ createrid
		+ "');\" onclick='pointerXY(event);'>"
		+ Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())
		+ "</A>&nbsp;&nbsp;"
		+ "<b>"
		+ "&nbsp;&nbsp;"
		+ SystemEnv.getHtmlLabelName(359, user.getLanguage())
		+ ":&nbsp;</b>"
		+ approvedate
		+ "&nbsp;&nbsp;"
		+ approvetime
		+ "&nbsp;&nbsp;"
		+ "<b>"
		+ SystemEnv.getHtmlLabelName(439, user.getLanguage())
		+ ":&nbsp;</b>"
		+ "<a href=\"javaScript:openhrm('"
		+ approverid
		+ "');\" onclick='pointerXY(event);'>"
		+ Util.toScreen(ResourceComInfo.getResourcename(approverid), user.getLanguage()) + "</A>&nbsp;&nbsp;";
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<script type="text/javascript">
function openNextUl(chiefId,o)
{
	if(""!=chiefId)
	{
		var chiefvoting = document.getElementById("chiefIdtable_"+chiefId);
		if(chiefvoting)
		{
			var style = chiefvoting.style.display;
			if(style=="block"||style=="")
			{
				chiefvoting.style.display = "none";
				o.src = "/images/messageimages/plus.gif";
			}
			else
			{
				chiefvoting.style.display = "block";
				o.src = "/images/messageimages/minus.gif";
			}
		}
	}
}
var isopen=false;
function openAllNextUl(obj)
{
    var len=document.all.tags("table").length;
    if(isopen){
        obj.innerHTML=obj.innerHTML.replace(obj.innerText," <%=SystemEnv.getHtmlLabelName(18466, user.getLanguage())%>");
    }else{
        obj.innerHTML=obj.innerHTML.replace(obj.innerText," <%=SystemEnv.getHtmlLabelName(16216, user.getLanguage())%>");
    }
	for(var i=0;i<len;i++)
	{
        var namestr = document.all.tags("table")[i].id;
		if (namestr.indexOf('chiefIdtable_')>=0){
			if(isopen)
			{
                document.all(namestr).style.display = "block";
				document.all("img_"+namestr.split("_")[1]).src = "/images/messageimages/minus.gif";
			}
			else
			{
                document.all(namestr).style.display = "none";
				document.all("img_"+namestr.split("_")[1]).src = "/images/messageimages/plus.gif";
			}
		}
	}
    isopen=!isopen;
}
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
	session.setAttribute("fav_pagename" , temptitlename ) ;

	if ("1".equals(status)&&(canviewall || canParticular)) {//有查看详细信息权限才能做催办操作
		RCMenu += "{"+SystemEnv.getHtmlLabelName(23756,user.getLanguage())+",javascript:doReminders("+votingid+"),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if ((canviewall || canParticular)) {//有查看详细信息权限才能做导出excel操作
	RCMenu += "{Excel , /weaver/weaver.file.ExcelOut,ExcelOut} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
    if(!"".equals(chiefType)){
    RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(18466, user.getLanguage())
			+ ",javascript:openAllNextUl(this),_top} ";
    RCMenuHeight += RCMenuHeightStep;
    }
    RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(1290, user.getLanguage())
			+ ",javascript:back_check(),_top} ";
	RCMenuHeight += RCMenuHeightStep;
%>

<script>
  var parentDialog;
  function back_check(){
     //alert(parentDialog);
     if(parentDialog == null || parentDialog == undefined){
        window.history.go(-1);
     }else{
        
     }
  }
</script>


<%@ include file="/systeminfo/RightClickMenu.jsp"%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<form name=frmmain action="VotingPollOperation.jsp" method=post>
<input type=hidden name=method value="polledit">
<input type=hidden name=votingid value="<%=votingid%>">
<TABLE width=100% height=100% border="0" cellspacing="0">
	<colgroup>
		<col width="5">
		<col width="">
		<col width="5">
	<tr>
		<td height="5" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
				<TABLE class=Shadow>
					<tr>
						<td valign="top">
							<table class=viewform>
								<col width=15%>
								<col width=35%>
								<col width=15%>
								<col width=35%>
								<tr>
									<td colspan="4" align="center">
										<font size=5 color=blue><%=Util.toScreen(subject, 7)%></font>
									</td>
								</tr>
								<tr>
									<td colspan=4><%=Util.toScreen(detail, 7)%>
									</td>
								</tr>
							</table>
							<table class=liststyle>
								<col width=25%>
								<col width=55%>
								<col width=10%>
								<col width=10%>
								<TR class="header">
									<TH colspan=3>
										<div align="left"><%=SystemEnv.getHtmlLabelName(18606, user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18609, user.getLanguage())%>&nbsp;<%=votingcount%>&nbsp;<%=SystemEnv.getHtmlLabelName(18608, user.getLanguage())%>)
										</div>
									</TH>
									<th>
										<%
										if (canviewall || canParticular) {
										%>
										<a href="VotingPollRemark.jsp?votingid=<%=votingid%>"><%=SystemEnv.getHtmlLabelName(18613, user.getLanguage())%></a>
										<%
										}
										%>
									</th>
								</TR>
								<%
									
									List collectChiefs = vb.getCollectChiefs();
									List votingQuestions = vb.getVotingQuestions();
									Map votingOptions = vb.getVotingOptions();
									Map allVotingOptions = vb.getAllVotingOptions();
									Map chiefsMap = vb.getChiefsMap();
									ExcelSheet es = new ExcelSheet() ;
									ExcelRow er = es.newExcelRow () ;
	
									er.addStringValue(SystemEnv.getHtmlLabelName(15486, user.getLanguage())) ;
									er.addStringValue(SystemEnv.getHtmlLabelName(413, user.getLanguage())) ;
									er.addStringValue(SystemEnv.getHtmlLabelName(18939, user.getLanguage())) ;
									er.addStringValue(SystemEnv.getHtmlLabelName(141, user.getLanguage())) ;
									er.addStringValue(SystemEnv.getHtmlLabelName(6086, user.getLanguage())) ;
									er.addStringValue(SystemEnv.getHtmlLabelName(683, user.getLanguage())) ;
									List questionsList = new ArrayList();
									if(null!=votingQuestions&&votingQuestions.size()>0)
									{
										for(int i=0;i<votingQuestions.size();i++)
										{
											VotingQuestionBean vqb = (VotingQuestionBean)votingQuestions.get(i);
											String questionid = vqb.getQuestionid();
											String q_subject = vqb.getSubject();
											String q_description = vqb.getDescription();
											questionsList.add(questionid);
											er.addStringValue(q_subject) ;
										}
									}
									es.addExcelRow(er) ;
									es = vcm.exportVotingToExcel(questionsList,allVotingOptions,es,er);									
									ExcelFile.init() ;
									ExcelFile.setFilename(SystemEnv.getHtmlLabelName(20042, user.getLanguage())) ;
									ExcelFile.addSheet(SystemEnv.getHtmlLabelName(20042, user.getLanguage()), es) ;
									session.setAttribute("ExcelFile",ExcelFile);
									if(null!=collectChiefs&&collectChiefs.size()>0)
									{
										for(Iterator i = collectChiefs.iterator();i.hasNext();)
										{
											CollectChiefBean ccb = (CollectChiefBean)i.next();
											String chiefId = ccb.getChiefId();
											String chiefName = ccb.getChiefName();
											String linkchiefId = "";
											String linkHref = "javascript:openNextUl('"+chiefId+"',document.all('img_"+chiefId+"'));";
											String stampinfo = "";
                                            boolean showV=false;
											if(!chiefsMap.containsKey(chiefId))
											{
												stampinfo = SystemEnv.getHtmlLabelName(23148, user.getLanguage())+"!";
											}
											else
											{
												stampinfo = "";
											}
											if(!"".equals(chiefId))
											{
												if("com".equals(chiefType))
												{
													linkchiefId = chiefId;
													linkHref = "/voting/VotingPollResult.jsp?votingid="+votingid+"&chiefType="+nextChiefType+"&chiefId="+linkchiefId;
                                                    if(ResourceComInfo.getSubCompanyID(userid).equals(chiefId)) showV=true;
												}else if("dept".equals(chiefType))
												{
                                                    if(ResourceComInfo.getDepartmentID(userid).equals(chiefId)) showV=true;
                                                }else{
                                                    if(ResourceComInfo.getJobTitle(userid).equals(chiefId)) showV=true;
                                                }
								%>
								<tr>
									<td colspan="4">
										<img src=/images/messageimages/minus.gif id="img_<%=chiefId%>" onclick="openNextUl('<%=chiefId %>',this);" style="cursor:hand"><a href="<%=linkHref %>"><%=chiefName%><%if(!"".equals(stampinfo)){ %>(<%=stampinfo %>)<%} %></a>
									</td>											
								</tr>
								<%
								if(!chiefsMap.containsKey(chiefId))
								{
									continue;
								}
								%>
								<tr>
									<td colspan="4">
										<table class=liststyle id="chiefIdtable_<%=chiefId %>">
											<col width=25%>
											<col width=55%>
											<col width=10%>
											<col width=10%>
								<%
											}
											if("".equals(chiefType)) showV=true;
											if(null!=votingQuestions&&votingQuestions.size()>0)
											{
												for(Iterator j = votingQuestions.iterator();j.hasNext();)
												{
													VotingQuestionBean vqb = (VotingQuestionBean)j.next();
													String questionid = vqb.getQuestionid();
													String q_subject = vqb.getSubject();
													String q_description = vqb.getDescription();
													
								%>
								
											<tr class=datadark>
												<td colspan=3>
													<b><%=q_subject%></b>
													<%
														if (!q_description.equals(""))
														{
													%>(<%=q_description%>)<%
														}
													%>
												</td>
												<td>
													<%
														if (canviewall || canParticular)
														{
													%><a
														href="VotingPollResultDetail.jsp?questionid=<%=questionid%>&votingid=<%=votingid%>&chiefType=<%=chiefType %>&chiefId=<%=chiefId %>"><%=SystemEnv.getHtmlLabelName(2121, user.getLanguage())%></a>
													<%
														}
													%>
												</td>
											</tr>
											<%
																List voList = (List)allVotingOptions.get(questionid);
																if(null!=voList&&voList.size()>0)
																{
																	int count = 1;
																	for(Iterator k = voList.iterator();k.hasNext();)
																	{
																		VotingOptionBean vob = (VotingOptionBean)k.next();
																		String tquestionid = vob.getQuestionid();
																		String optionid = vob.getOptionid();
																		String o_desc = vob.getOptiondesc();
																		int o_count = 0;
																		String tchiefid = vob.getChiefId();
																		List votingOptionList = (List)votingOptions.get(questionid);
																		if(null!=votingOptionList&&votingOptionList.size()>0)
																		{
																			for(Iterator l = votingOptionList.iterator();l.hasNext();)
																			{
																				VotingOptionBean lvob = (VotingOptionBean)l.next();
																				String lquestionid = lvob.getQuestionid();
																				String loptionid = lvob.getOptionid();
																				String lo_desc = lvob.getOptiondesc();
																				int lo_count = lvob.getOptioncount();
																				String ltchiefid = lvob.getChiefId();
																				
																				if(!lquestionid.equals(questionid))
																					continue;
																				if(!ltchiefid.equals(chiefId))
																					continue;
																				if(loptionid.equals(optionid))
																				{
																					o_count = lo_count;
																				}
																			}
																		}
																		//System.out.println("o_count : "+o_count+"  --votingcount : "+votingcount);
																		float percent = 0;
																		if (votingcount != 0)
																			percent = (float) ((o_count * 1000) / votingcount) / 10;
																		//System.out.println("percent : "+percent+"  --votingcount : "+votingcount);
																		String classgraph = "";
																		if ((count % 4) == 1)
																			classgraph = "/images/BDStatRed.jpg";
																		if ((count % 4) == 2)
																			classgraph = "/images/BDStatBlue.jpg";
																		if ((count % 4) == 3)
																			classgraph = "/images/BDStatGreen.jpg";
																		if ((count % 4) == 0)
																			classgraph = "/images/BDStatYellow.jpg";
											%>
											<tr class=dataLight>
												<td>
													<%=count%>.<%=o_desc%>&nbsp;&nbsp;&nbsp;
													<%
														if (showV&&selectoptionids.indexOf(optionid) != -1)
														{
													%>
													<img src="/images/BacoCheck.gif">
													<%
														}
													%>
												</td>
												<td>
													<%
														if (percent > 0)
														{
													%>
													<TABLE height="100%" cellSpacing=0 width="100%">
														<TBODY>
															<TR>
																<TD <%if(percent<=1){%> width="1%" <%}else{%>
																	width="<%=percent%>%" <%}%>>
																	<img src="<%=classgraph%>" height="15" align="center"
																		border=0 width="<%=percent%>%">
																</TD>
																<TD>
																	&nbsp;
																</TD>
															</TR>
														</TBODY>
													</TABLE>
													<%
														}
														else
														{
													%>
													&nbsp;
													<%
														}
													%>
												</td>
												<td><%=percent%>%
												</td>
												<td><%=o_count%>&nbsp;<%=SystemEnv.getHtmlLabelName(18607, user.getLanguage())%></td>
											</tr>
											<%
																		count++;
																	}
																}
															}
														}
														if(!"".equals(chiefId))
														{
														%>
														</table>
													</td>
												</tr>
														<%
														}
													}
												} 
											%>
										
							</table>
							<table class=liststyle>
							 <TR class="header">
								<TH colspan=3>
									<div align="left"><%=SystemEnv.getHtmlLabelName(21727, user.getLanguage())%></div>
								</TH>
							 </TR>
							 <TR>
								<td>
								<%
								List votingPersons = vb.getVotingPerson();
								if(null!=votingPersons&&votingPersons.size()>0)
								{
									for(Iterator i = votingPersons.iterator();i.hasNext();)
									{
										String tpname = (String)i.next();
									
								%>
						        <%=tpname%>&nbsp;&nbsp;
						        <%
						        	}
								}
								%>
								</td>
							 </TR>
							 <TR class="header">
								<TH colspan=3>
									<div align="left"><%=SystemEnv.getHtmlLabelName(21728, user.getLanguage())%></div>
								</TH>
							 </TR>
							 <TR>
								<td>
								<%
								List noVotingPersons = vb.getNoVotingPerson();
								if(null!=noVotingPersons&&noVotingPersons.size()>0)
								{
									for(Iterator i = noVotingPersons.iterator();i.hasNext();)
									{
										String tpnoname = (String)i.next();
									
								%>
						        <%=tpnoname%>&nbsp;&nbsp;
						        <%
									}
						        }%>
								</td>
							 </TR>
							</table>
						</td>
					</tr>
				</TABLE>
		</td>
		<td></td>
	</tr>
	<tr>
		<td height="5" colspan="3"></td>
	</tr>
</table>
</form>
<script type="text/javascript">
	function doReminders(votingid){
		var opts={
				_dwidth:'550px',
				_dheight:'600px',
				_url:'about:blank',
				_scroll:"no",
				_dialogArguments:"",
				
				value:""
			};
		var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
		opts.top=iTop;
		opts.left=iLeft;
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/voting/VotingReminders.jsp?votingid="+votingid,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
		
	}
</script>
</body>
</html>