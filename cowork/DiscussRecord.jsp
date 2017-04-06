<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.file.Prop"%>
<%@page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<jsp:useBean id="settingComInfo" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" />
<%

  User user = HrmUserVarify.getUser(request,response);
  if(user == null)  return ;

  String userid=String.valueOf(user.getUID());
	
  int type=Util.getIntValue(request.getParameter("type"),0);
  
  int id=Util.getIntValue(request.getParameter("id"),0);
  
  String recordType=Util.null2String(request.getParameter("recordType"));
 
  String isCoworkHead=settingComInfo.getIsCoworkHead(settingComInfo.getId(userid));
  
  int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0：非政务系统。2：政务系统。
  
  String logintype = user.getLogintype();
  
  CoworkDAO dao = new CoworkDAO(id);
	
  int pagesize = 20;//讨论交流每页显示条数
  
  int currentpage = Util.getIntValue((String)request.getParameter("currentpage"), 1);
  
  int prepage=currentpage-1;
  
  int nextpage=currentpage+1;
  
  int totalsize =0;
  ArrayList list=new ArrayList();
  
  String srchcontent =Util.null2String(request.getParameter("srchcontent"));
  String startdate =Util.null2String(request.getParameter("startdate"));
  String enddate =Util.null2String(request.getParameter("enddate"));
  String par_discussant =Util.null2String(request.getParameter("discussant"));
  String srchFloorNum =Util.null2String(request.getParameter("srchFloorNum"));
  String isReplay =Util.null2String(request.getParameter("isReplay"));
  
  String searchStr = "";
  if (!"".equals(srchcontent)) {
	  searchStr += " and remark like '%" + srchcontent + "%'";
  }
  if (!"".equals(startdate)) {
	  searchStr += " and createdate >= '" + startdate + "'";
  }
  if (!"".equals(enddate)) {
	  searchStr += " and createdate <= '" + enddate + "'";
  }
  if (!"".equals(par_discussant)) {
	  searchStr += " and discussant = '" + par_discussant + "'";
  }
  if (!"".equals(srchFloorNum)) { //按照楼号搜索
	  searchStr += " and floorNum = " + srchFloorNum + "";
  }
  if (!"".equals(isReplay)) {     //显示非回复内容
	  searchStr += " and replayid = 0";
  }
  
  if(recordType.equals("")){
	  totalsize =dao.getDiscussVOListCount(searchStr);
	  list = dao.getDiscussVOList(currentpage, pagesize, searchStr);
  }else if(recordType.equals("replay")){
      totalsize =dao.getDiscussReplayListCount(userid);
	  list = dao.getDiscussReplayList(currentpage, pagesize, userid);
  }
  
  int totalpage = totalsize / pagesize;
  if(totalsize - totalpage * pagesize > 0) totalpage = totalpage + 1;
  
  String maxdiscussid=dao.getMaxDiscussid(""+id);
		
  Date nowdate=new Date();
  
  SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

  //讨论记录
  if(list.size()>0){
  for(int k=0;k<list.size();k++){
	  
		CoworkDiscussVO vo = (CoworkDiscussVO)list.get(k);
		String coworkid=vo.getCoworkid();                          //协作Id
		String discussant = Util.null2String(vo.getDiscussant());  //回复人id
		String createdate = Util.null2String(vo.getCreatedate());  //创建日期
		String createtime = Util.null2String(vo.getCreatetime());  //创建时间
		String remark2 = Util.null2String(vo.getRemark());         //回复内容 
		String remark2html = Util.StringReplace(remark2.trim(),"\r\n",""); 
		
		String relatedprj = Util.null2String(vo.getRelatedprj());  //相关项目任务
		String relatedcus = Util.null2String(vo.getRelatedcus());  //相关客户
		String relatedwf = Util.null2String(vo.getRelatedwf());    //相关流程
		String relateddoc = Util.null2String(vo.getRelateddoc());  //相关文档
		
		ArrayList relatedprjList = vo.getRelatedprjList();       
		ArrayList relatedcusList = vo.getRelatedcusList();
		ArrayList relatedwfList = vo.getRelatedwfList();
		ArrayList relateddocList = vo.getRelateddocList();
		
		ArrayList relatedaccList = vo.getRelatedaccList();
		
		ArrayList relatemutilprjsList = vo.getRelatemutilprjsList();
		
		//新添加字段
		String discussid=vo.getId();
		String floorNum=vo.getFloorNum();
		String replayid=Util.null2String(vo.getReplayid());
		
		long timePass=100L;
		if(maxdiscussid.equals(discussid)&&userid.equals(discussant)){
            String dateStr="";
			if(createtime.length()==5)
				dateStr=createdate+" "+createtime+":00";
			else
				dateStr=createdate+" "+createtime;
		    Date discussDate=dateFormat.parse(dateStr);  //回复时间
		    timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
		}
	%>
	<div id="discuss_div_<%=discussid%>" class="discuss_div">
	 <table class="discuss" id="discuss_table_<%=discussid%>" cellpadding="0" cellspacing="0">
     <tr> 
        <td valign="top" width="42px" class="userHeadTd" style="<%if(isCoworkHead.equals("0")){%>display:none<%}%>">
            <div class="userHead">
               <img src="<%=ResourceComInfo.getMessagerUrls(discussant)%>" width="30" border="0" align="top"/>
            </div>
        </td>
        <td valign="top" width="*" style="work-break:break-all;padding-left:3px" id="discussContentTd_<%=discussid%>">
            <table cellpadding="0" style="float: left;width: 100%" cellspacing="0" id="discuss_content_<%=discussid%>">
               <col width="3%"/>
               <col width="97%"/>
               <tr>
                  <td colspan="2" style="padding-bottom: 2px">
				    <span style="width:360px;float: left">
                      <%if(!"replay".equals(recordType)){%><span style="color: #999999"><%=floorNum%><%=SystemEnv.getHtmlLabelName(25403,user.getLanguage())%><!--楼-->：</span><%}%><a href="javascript:void(0)" style="text-decoration:none" onclick="pointerXY(event);openhrm('<%=discussant%>');return false;"><%=Util.toScreen(ResourceComInfo.getResourcename(discussant),user.getLanguage())%></a><%if(!replayid.equals("0")){%><img src="/cowork/images/replay.png" align="absmiddle"/><%}else{ %><img src="/cowork/images/publish.png" align="absmiddle"/><%}%>
                      <span style="color: #999999"><%=SystemEnv.getHtmlLabelName(23066,user.getLanguage())%>：<%=createdate%>&nbsp;<%=createtime%></span><!-- 发表时间 -->
                    </span>
                    <%if(!"replay".equals(recordType)){%>
	                   <span style="margin-left:10px;float: right;">
					     <!-- 编辑 删除 权限 回复者本人 没有协作回复和讨论回复 操作时间间隔小于10分 -->
						  <a href="javascript:void(0)" onclick="showReplay('<%=discussid%>','<%=floorNum%>','<%=coworkid%>');return false;" class="replayLink"><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></a><!-- 回复 -->
						<%if(userid.equals(discussant)&&maxdiscussid.equals(discussid)&&timePass<=10){%>
						   <a href="javascript:void(0)" onclick="editDiscuss('<%=discussid%>','<%=replayid%>');return false;" class="replayLink operationTimeOut"><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%></a><!--修改 -->
						   <a href="javascript:void(0)" onclick="deleteDiscuss('<%=discussid%>');return false;" class="replayLink operationTimeOut"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><!--删除-->
						<%} %>
	                   </span>
	                 <%}%>  
				 </td>
               </tr>
               
               <!-- 被回复内容 -->
               <%if(replayid!=null&&!"0".equals(replayid)&&!"".equals(replayid)){
	              CoworkDiscussVO discussvo=dao.getCoworkDiscussVO(replayid);
	              if(discussvo!=null){
			      String preremark = Util.StringReplace(discussvo.getRemark().trim(),"\n","<br>");
			      ArrayList relatedprjList2=discussvo.getRelatedprjList();       
			      ArrayList relatedcusList2=discussvo.getRelatedcusList();
			      ArrayList relatedwfList2=discussvo.getRelatedwfList();
			      ArrayList relateddocList2=discussvo.getRelateddocList();
			      ArrayList relatedaccList2=discussvo.getRelatedaccList();
			      ArrayList relatemutilprjsList2=discussvo.getRelatemutilprjsList();
	           %>
	           <tr>
	           <td colspan="2" style="border: 1px solid #d3e7ec;background-color:#ebfcff;padding: 5px 5px 2px 5px">
                      <table cellpadding="0" cellspacing="0">
                         <col width="3%"/>
                         <col width="97%"/>
                         <tr>
                             <td colspan="2">
                                <span style="color: #999999"><%=SystemEnv.getHtmlLabelName(18540,user.getLanguage())%>&nbsp;<%=discussvo.getFloorNum()%><%=SystemEnv.getHtmlLabelName(25403,user.getLanguage())%>：</span><a href="javascript:void(0)" onclick="pointerXY(event);openhrm('<%=discussvo.getDiscussant()%>');return false;" style="color:#0000FF;text-decoration: none"><%=Util.toScreen(ResourceComInfo.getResourcename(discussvo.getDiscussant()),user.getLanguage())%></a><img src="/cowork/images/publish.png" align="absmiddle"/>
                                <span style="color: #999999"><%=SystemEnv.getHtmlLabelName(23066,user.getLanguage())%>：<%=discussvo.getCreatedate()%>&nbsp;<%=discussvo.getCreatetime()%></span>  
                             </td>
                         </tr>
                         <tr>
                             <td colspan="2" class="discuss_replayContent" style="color:#666">
                                 <%=preremark%>
                             </td>
                         </tr>
                         <%if(relateddocList2.size()!=0){ //文档%>
				          <tr>
			                 <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>：</td>
			                 <td style="word-break:break-all">
			                    <%for(int i=0;i<relateddocList2.size();i++){%>
								  <a href="javascript:void(0)" onclick="opendoc2('<%=relateddocList2.get(i).toString()%>',<%=id%>);return false" class="relatedLink">
									<%=DocComInfo.getDocname(relateddocList2.get(i).toString())%>
								  </a>
								<%}%>
			                    </td>
		                     </tr>
			             <%} %>
			             
			             <!-- 相关流程 -->
			           <%if(relatedwfList2.size()!=0){%>
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<relatedwfList2.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList2.get(i).toString()%>');return false" class="relatedLink">
											<%=RequestComInfo.getRequestname(relatedwfList2.get(i).toString())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%}%>
			           <!-- 相关客户 -->
			           <%if(isgoveproj==0&&relatedcusList2.size()!=0){ %>
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<relatedcusList2.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList2.get(i).toString()%>');return false" class="relatedLink">
											<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList2.get(i).toString())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%} %>
	           
			           <!-- 相关项目 -->
			           <%if(isgoveproj==0&&relatemutilprjsList2.size()!=0){%>
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<relatemutilprjsList2.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=relatemutilprjsList2.get(i).toString()%>');return false" class="relatedLink">
											<%=projectInfoComInfo.getProjectInfoname(relatemutilprjsList2.get(i).toString())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%}%>
	           
			           <!-- 相关任务 -->
			           <%if(isgoveproj==0&&relatedprjList2.size()!=0){%>    
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<relatedprjList2.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList2.get(i).toString()%>');return false" class="relatedLink">
											<%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(relatedprjList2.get(i).toString()),user.getLanguage())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%}%>
	           
			           <!-- 相关附件 -->
			           <%if(relatedaccList2!=null&&relatedaccList2.size()!=0){%>
			               <tr>
			                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%=dao.showRelatedaccList(relatedaccList2,user,id)%>  
			                    </td>
			               </tr>
			           <%}%>
                      </table>
                  </td>  
               </tr>
	           <%}}%>
	           <!-- 被回复的内容 -->
               <tr>
	              <td colspan="2"  valign="top" class="discuss_content" style="padding-top: 8px">
	                  <%=remark2html%>
	               </td>
               </tr>
               
               <!-- 相关文档 -->
               <%if(relateddocList.size()!=0){%>
	               <tr>
	                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                        <%for(int i=0;i<relateddocList.size();i++){%>
								<a href="javascript:void(0)" onclick="opendoc2('<%=relateddocList.get(i).toString()%>',<%=id%>);return false" class="relatedLink">
								  <%=DocComInfo.getDocname(relateddocList.get(i).toString())%>
								</a>
							<%}%>
	                    </td>
	               </tr>
	           <%}%>
	           <!-- 相关流程 -->
	           <%if(relatedwfList.size()!=0){%>
	              <tr>
	                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                       <%for(int i=0;i<relatedwfList.size();i++){%>
								<a href="javascript:void(0)" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList.get(i).toString()%>');return false" class="relatedLink">
									<%=RequestComInfo.getRequestname(relatedwfList.get(i).toString())%>
								</a>
						   <%}%>	
	                    </td>
	               </tr>
	           <%}%>
	           <!-- 相关客户 -->
	           <%if(isgoveproj==0&&relatedcusList.size()!=0){ %>
	              <tr>
	                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                       <%for(int i=0;i<relatedcusList.size();i++){%>
								<a href="javascript:void(0)" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList.get(i).toString()%>');return false" class="relatedLink">
									<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString())%>
								</a>
						   <%}%>	
	                    </td>
	               </tr>
	           <%} %>
	           
	           <!-- 相关项目 -->
	           <%if(isgoveproj==0&&relatemutilprjsList.size()!=0){%>
	              <tr>
	                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                       <%for(int i=0;i<relatemutilprjsList.size();i++){%>
								<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=relatemutilprjsList.get(i).toString()%>');return false" class="relatedLink">
									<%=projectInfoComInfo.getProjectInfoname(relatemutilprjsList.get(i).toString())%>
								</a>
						   <%}%>	
	                    </td>
	               </tr>
	           <%}%>
	           
	           <!-- 相关任务 -->
	           <%if(isgoveproj==0&&relatedprjList.size()!=0){%>    
	              <tr>
	                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                       <%for(int i=0;i<relatedprjList.size();i++){%>
								<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList.get(i).toString()%>');return false" class="relatedLink">
									<%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString()),user.getLanguage())%>
								</a>
						   <%}%>	
	                    </td>
	               </tr>
	           <%}%>
	           
	           <!-- 相关附件 -->
	           <%if(relatedaccList.size()!=0){%>
	               <tr>
	                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                       <%=dao.showRelatedaccList(relatedaccList,user,id)%>  
	                    </td>
	               </tr>
	           <%}%>
	           <tr id="replaytr_<%=discussid%>">
		        <td colspan="2">
		           <div id="replay_<%=discussid%>" class="replaydiv" > 
				         <!--请填写回复内容-->
		                 <%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18546,user.getLanguage())%>
		               <div style="margin-bottom: 3px;width: 99%;">  
		                  <textarea id="replay_content_<%=discussid%>" class="replayContent"  onpropertychange="autoHeight(this,35)"></textarea>
		               </div>
					   <div class="discussOperation" style="width: 99%;">
					       <!-- 回复 -->
					       <button type="button"  class="replayBtn" onclick="doSave('replay_content_<%=discussid%>')">
					          <%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%>
					       </button>
						   <a href="javascript:void(0)" onclick="cancelReplay('<%=discussid%>');return false;" class="cancelBtn"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></a><!-- 取消 -->
					   </div>
		           </div>
		        </td>
               </tr>
            </table>
        </td>
     </tr>
  </table>
 </div> 
 <div class="discussLline"></div>
<%}%>

   <table width="100%" cellpadding="0" cellspacing="0" style="margin-top: 5px;margin-right: 10px">
	    <!-- 分页 -->
		<tr class="pagenav" style="<%if(totalsize==0){ %>display:none<%}%>;" >
		    <td>
		         <%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalsize"><%=totalsize%></span><%=SystemEnv.getHtmlLabelName(24683,user.getLanguage())%> <!-- 共62条记录 -->
		         <%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=pagesize%><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>    <!-- 每页10条 -->
		         <%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalpage"><%=totalpage%></span><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%> <!-- 共7页 -->
		         <%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><span class="currentpage"><%=currentpage%></span><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%><!-- 当前第1页 --> 
		          <!-- 首页 上一页 下一页 尾页 --> 
				 <%if(totalpage>1&&currentpage!=1){%>
				    <A class=pageActive id="firstPage" href='javascript:void(0)' onclick='toPage(1);return false;'><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%></A>
				 <%}else{%>
				    <%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%>
				 <%}%>
				 <%if(totalpage>1&&currentpage!=1){%>
				   <A class=pageActive  id="prePage" href='javascript:void(0)' onclick='toPage(<%=prepage%>);return false;'><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></A>
				 <%}else{%>
				   <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%>
				 <%}%>
				 <%if(totalpage>1&&currentpage!=totalpage){%>
				   <A class=pageActive  id="nextPage" href='javascript:void(0)' onclick='toPage(<%=nextpage%>);return false;'><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></A>
                 <%}else{%>
				   <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%>
				 <%}%>
				 <%if(totalpage>1&&currentpage!=totalpage){%>
				   <A  class=pageActive id="lastPage" href='javascript:void(0)' onclick='toPage(<%=totalpage%>);return false;'><%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%></A>
                 <%}else{%>
				   <%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%>
				 <%}%>
		         <input type="button"  onclick="toGoPage(<%=totalpage%>,'topagenum')" value="<%=SystemEnv.getHtmlLabelName(23162,user.getLanguage())%>" style="cursor: pointer;height: 22px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><input type="text" size="2" style="line-height:18px;height: 18px;text-align: right;vertical-align: middle !important;" name='topagenum' id="topagenum" onkeyPress="if(event.keyCode==13){toGoPage(<%=totalpage%>,'topagenum');return false;}" value="<%=currentpage %>"><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>
		    </td>
		 </tr>
		 <tr><td height="10px"></td></tr>
	</table>
<%}else{%>
     <div class="norecord"><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></div>
<%}%>