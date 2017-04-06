<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.util.*"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.file.Prop"%>

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
		String userid=String.valueOf(user.getUID());;
		String operation=request.getParameter("operation");
		
		String discussid=request.getParameter("discussid");
		
		int isgoveproj = Util.getIntValue(request.getParameter("isgoveproj"),0);//0：非政务系统。2：政务系统。
		
		String isCoworkHead=settingComInfo.getIsCoworkHead(settingComInfo.getId(userid));//是否显示缩略图
		
		String logintype = user.getLogintype();
		
		String disType=Util.null2String((String)session.getAttribute("disType")); //协作讨论显示方式，tree为树形
		
		SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date nowdate=new Date();
		
		boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1"); //是否启用了message
		
		//编辑讨论
		if("edit".equals(operation)){
		
		String typeid=request.getParameter("typeid");
        
        CoworkDAO dao=new CoworkDAO();
		CoworkDiscussVO vo2=(CoworkDiscussVO)dao.getCoworkDiscussVO(discussid);
		String coworkid=vo2.getCoworkid();
		String discussant = Util.null2String(vo2.getDiscussant());
		
		String createdate = Util.null2String(vo2.getCreatedate());
		String createtime = Util.null2String(vo2.getCreatetime());
		
		String maxdiscussid=dao.getMaxDiscussid(""+coworkid);//最大讨论记录id

		boolean result=true;
		long timePass=100L;
		
		String dateStr="";
		if(createtime.length()==5)
			dateStr=createdate+" "+createtime+":00";
		else
			dateStr=createdate+" "+createtime;
		Date discussDate=dateFormat.parse(dateStr);  //回复时间
		timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
	    if(!maxdiscussid.equals(discussid)){
			out.println("1");
		    result=false;
		}else if(timePass>10){
			out.println("2");
		    result=false;
		}	
		if(result){
		String remark2 = Util.null2String(vo2.getRemark());
		String remark2html = Util.StringReplace(remark2,"\r\n","");
		remark2html=remark2html.replaceAll("&lt;","&amp;lt;");
		remark2html=remark2html.replaceAll("&gt;","&amp;gt;");
		String relatedprj = Util.null2String(vo2.getRelatedprj());
		String relatedcus = Util.null2String(vo2.getRelatedcus());
		String relatedwf = Util.null2String(vo2.getRelatedwf());
		String relateddoc = Util.null2String(vo2.getRelateddoc());
		String relatedmutilPrj=Util.null2String(vo2.getRelatedmutilprj());
		
		
		ArrayList relatedprjList = vo2.getRelatedprjList();
		ArrayList relatedcusList = vo2.getRelatedcusList();
		ArrayList relatedwfList = vo2.getRelatedwfList();
		ArrayList relateddocList = vo2.getRelateddocList();
		
		ArrayList relatedaccList = vo2.getRelatedaccList();
		
		String relatedacc=vo2.getRelatedacc();
		
		ArrayList relatemutilprjsList = vo2.getRelatemutilprjsList();
		
		//新添加字段
		String floorNum=vo2.getFloorNum();
		String replayid=vo2.getReplayid();
		
%>
   
    <div id="editdiv">
      <table>
        <tr>
        <td valign="top" class="userHeadTd">
        <div class="userHead" style="<%if(isCoworkHead.equals("0")){%>display:none<%}%>" align="left">
           <img src="<%=ResourceComInfo.getMessagerUrls(discussant)%>" width="30" border="0" align="top"/>
        </div>
        </td>
        <td>
        <div class="discussContent">
         <input type=hidden name="discussid" id="discussid" value="<%=discussid%>">
         <input type="hidden" name="id" value="<%=coworkid%>">
		 <textarea id="discussContent" name="discussContent"><%=remark2html%></textarea>
		 
		 <div class="discussOperation" align="left">
		     <div style="clear: both;margin: 0px 0px 2px 0px;">
		       <button type="button" class="replayBtn" style="float: left;" onclick="doSave('discussContent')"><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
			   <a style="float: left;font-size: 12px;margin-top: 4px;" href="javascript:void(0)" onclick="cancelEdit(<%=discussid%>);return false" class="externalBtn"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></a>
			   <a style="float: right;margin-right: 8px;font-size: 12px;margin-top: 4px;" href="javascript:void(0)" onclick="external('editExternal');return false" class="externalBtn"><%=SystemEnv.getHtmlLabelName(26165,user.getLanguage())%><img src="/cowork/images/edit_down.gif" id="editExternal_img" style="margin-left: 3px;border: 0px;" align="absmiddle"/></a>
             </div>
         </div>
		 
		 <div id="editExternal" class="externalDiv" style="width: 100%">
       <table class=ViewForm id="table1">
           <tr>
               <!-- 相关文档 -->
               <td width="15%"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
               <td width="85%" colspan="3" class=Field style="word-break:break-all">
                  <button type="button" class=browser onClick="onShowDoc('edit_relateddoc','edit_relateddocspan')"></button>
	              <input type=hidden name="edit_relateddoc" id="edit_relateddoc" value="<%=relateddoc%>">
	              <span id="edit_relateddocspan">
					 <%for(int i=0;i<relateddocList.size();i++){%>
					    <a href="javascript:void(0)" onclick="openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=relateddocList.get(i).toString()%>');return false"><%=Util.toScreen(DocComInfo.getDocname(relateddocList.get(i).toString()),user.getLanguage())%></a>
					 <%}%>
	              </span>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr>
               <!-- 相关流程 -->
               <td width="15%"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
               <td width="85%" colspan="3" class=Field style="word-break:break-all">
                  <button type="button" class=browser onClick="onShowRequest('edit_relatedwf','edit_relatedrequestspan')"></button>
				  <input type=hidden name="edit_relatedwf" id="edit_relatedwf" value="<%=relatedwf%>">
				  <span id="edit_relatedrequestspan">
					 <%for(int i=0;i<relatedwfList.size();i++){%>
					    <a href="javascript:void(0)" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList.get(i).toString()%>');return false"><%=Util.toScreen(RequestComInfo.getRequestname(relatedwfList.get(i).toString()),user.getLanguage())%></a>
					 <%}%>
				  </span>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <%if(isgoveproj==0){ %>
	           <tr>
	               <!-- 相关客户 -->
	               <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
	               <td class=Field colspan="3" style="word-break:break-all">
	                  <button type="button" class=browser onClick="onShowCRM('edit_relatedcus','edit_crmspan')"></button>
					  <input type=hidden name="edit_relatedcus" id="edit_relatedcus" value="<%=relatedcus%>">
					  <span id="edit_crmspan">
						  <%for(int i=0;i<relatedcusList.size();i++){%>
						      <a href="javascript:void(0)" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList.get(i).toString()%>');return false"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString()),user.getLanguage())%></a>
						  <%}%>
					  </span>
	               </td>
	           </tr>
              <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <%} %>
           <%if(isgoveproj==0){ %>
           <tr>
               <!-- 相关项目 -->
               <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
               <td class=Field colspan="3">
                    <BUTTON type="button" class="Browser" id="selectMultiProject" onclick="onShowMultiProjectCowork('edit_projectIDs','edit_mutilprojectSpan')"></BUTTON>
				    <INPUT type="hidden" name="edit_projectIDs" id="edit_projectIDs" value="<%=relatedmutilPrj%>">
				    <SPAN id="edit_mutilprojectSpan">
				    <%for(int i=0;i<relatemutilprjsList.size();i++){%>
			         <a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=relatemutilprjsList.get(i).toString()%>');return false"><%=projectInfoComInfo.getProjectInfoname(relatemutilprjsList.get(i).toString())%></a>&nbsp;
			        <%}%>
			       </SPAN>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <%} %>
           <%if(isgoveproj==0){ %>
           <tr>
               <!-- 相关项目任务 -->
               <td <%if(isgoveproj!=0){%>style="display: none;"<%}%>><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
               <td class=Field colspan="3" style="word-break:break-all;<%if(isgoveproj!=0){%>display: none;<%}%>">
                  <button  type="button" class=browser onClick="onShowTask('edit_relatedprj','edit_projectspan')"></button>
			      <input type=hidden name="edit_relatedprj" id="edit_relatedprj" value="<%=relatedprj%>">
			      <span id="edit_projectspan">
			      <%for(int i=0;i<relatedprjList.size();i++){%>
                    <a href="javascript:void(0)"  onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList.get(i).toString()%>');return false"><%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString()),user.getLanguage())%></a>
                  <%}%>
			       </span>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <%} %>
           <tr>
               <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
               <td class=Field <%if(isgoveproj!=0){%>colspan="3"<%}%>  valign="top">
			         <%
			            //附件上传目录
						Map dirMap=dao.getAccessoryDir(typeid);
					    String mainId =(String)dirMap.get("mainId");
					    String subId = (String)dirMap.get("subId");
					    String secId = (String)dirMap.get("secId");
					    String maxsize = (String)dirMap.get("maxsize");
			         %>
			         <input type="hidden" name="newrelateacc" id="newrelateacc" value=""/>
				     <input type="hidden" id="edit_relatedacc" name="edit_relatedacc" value="<%=relatedacc%>"/>
				     <input type="hidden" id="delrelatedacc" name="delrelatedacc" value=""/>	
			         <%int linknum=-1;
			         for(int i=0;i<relatedaccList.size();i++){
			            RecordSet.executeSql("select id,docsubject,accessorycount from docdetail where id="+relatedaccList.get(i));
			            
			          	if(RecordSet.next()){
			          		linknum++;
			          	  String showid = Util.null2String(RecordSet.getString(1)) ;
			              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
			              int accessoryCount=RecordSet.getInt(3);
			
			              DocImageManager.resetParameter();
			              DocImageManager.setDocid(Integer.parseInt(showid));
			              DocImageManager.selectDocImageInfo();
			
			              String docImagefileid = "";
			              long docImagefileSize = 0;
			              String docImagefilename = "";
			              String fileExtendName = "";
			              int versionId = 0;
			
			              if(DocImageManager.next()){
			                //DocImageManager会得到doc第一个附件的最新版本
			                docImagefileid = DocImageManager.getImagefileid();
			                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
			                docImagefilename = DocImageManager.getImagefilename();
			                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
			                versionId = DocImageManager.getVersionId();
			              }
			              if(accessoryCount>1){
			                fileExtendName ="htm";
			              }
			
			             String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
							%>
								<%=imgSrc%>
								<%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx"))){%>
			            <a  style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>');return false"><%=docImagefilename%></a>&nbsp
			          <%}else{%>
			            <a style="cursor:hand" onclick="opendoc1('<%=showid%>');return false"><%=tempshowname%></a>&nbsp
								<%}
			          if(accessoryCount==1){%>
			              <span id = "selectDownload">
			                <%
			                  //boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
			                  //if(!isLocked){
			                %>
			                  <BUTTON type="button" class=btn accessKey=1  onclick='onDeleteAcc("span_id_<%=linknum%>","<%=showid%>")'><U><%=linknum%></U>-删除
				                  <span id="span_id_<%=linknum%>" name="span_id_<%=linknum%>" style="display: none">
				                    <B><FONT COLOR="#FF0033">√</FONT></B>
				                  <span>
                             </BUTTON>
                             
			                <%//}%>
			              </span>
							<%}%>
							<br>
							<%}
			          	}%>
							<div id="edit_uploadDiv" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>" style="margin-top: 0px"></div>
			        </td>
           </tr>
       </table>   
      </div>
         </div>   
      </td>
        </tr>
      </table>           
	 </div>
<%}
		}%>
