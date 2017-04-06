<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.ArrayList"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<%
int type=Util.getIntValue(request.getParameter("type"),0);
int id=Util.getIntValue(request.getParameter("id"),0);
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0：非政务系统。2：政务系统。

boolean isLight=false;
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

String userid=String.valueOf(user.getUID());

String logintype = user.getLogintype();
CoworkDAO dao = new CoworkDAO(id);
%>


<%if(type==2){
	isLight=false;
	ArrayList docList = dao.getRelatedDocs();
	if(docList.size()>0){
%>
    <!--相关文档-->
	<table  class="ListStyle" cellspacing="1" width="100%" style="margin:0 0 0 0">
		<COLGROUP> 
		<COL width="45%">
		<COL width="40%">
		<COL width="15%">
	<%if(docList.size()>0){%>
		<tr class="Header">
	    <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
	    <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
	    <th><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></th>
		</tr>
	<%}%>
	<%for(int i=0;i<docList.size();i++){%>
		<%if(isLight){%>	
		<TR CLASS=DataLight>
		<%}else{%>
		<TR CLASS=DataDark>
		<%}%>
			<td><%=DocComInfo.getDocCreateTime(docList.get(i).toString())%></td>
			<td>
			<a href="#" onclick="opendoc2('<%=docList.get(i).toString()%>')"><%=DocComInfo.getDocname(docList.get(i).toString())%></a></td>
	        <td><%=ResourceComInfo.getResourcename(DocComInfo.getDocOwnerid(docList.get(i).toString()))%></td>
	  </tr>
	 <%isLight=!isLight;%>
	 <%}%>
	</table>
<%}else
	out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
}else if(type==3){
   ArrayList wfList = dao.getRelatedWfs();
   if(wfList.size()>0){	
%>
    <!-- 相关流程 -->	
	<table class=ListStyle cellspacing="1" width="100%" style="margin:0 0 0 0">
		<COLGROUP> 
		<COL width="34%">
		<COL width="11%">
		<COL width="12%">
		<COL width="29%">
		<COL width="14%">
	<%if(wfList.size()>0){%>
		<tr class="Header">
		<th><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></th>
	    <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
	    <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
	    <th><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></th>
	    <th><%=SystemEnv.getHtmlLabelName(1335,user.getLanguage())%></th>
		</tr>
	<%}%>
	<%for(int j=0;j<wfList.size();j++){%>
		<%if(isLight){%>	
		<TR CLASS=DataLight>
		<%}else{%>
		<TR CLASS=DataDark>
		<%}%>
			<td><%=RequestComInfo.getRequestCreateTime(wfList.get(j).toString())%></td>
			<td><%=ResourceComInfo.getResourcename(RequestComInfo.getRequestCreater(wfList.get(j).toString()))%></td>
			<td><%=RequestComInfo.getRequestType(wfList.get(j).toString())%></td>
			<td><a href="#" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=wfList.get(j).toString()%>')"><%=RequestComInfo.getRequestname(wfList.get(j).toString())%></a></td>
			<td><%=RequestComInfo.getRequestStatus(wfList.get(j).toString())%></td>
	 <%
	 isLight = !isLight;
	 }%>
	</table>	
	

<%}else
	out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
}else if(type==4){
	if(isgoveproj==0){
	  isLight = false;
	  ArrayList cusList = dao.getRelatedCuss();
	  if(cusList.size()>0){
%>
    <!-- 相关客户 -->	
	<table class=ListStyle style="width: 100%" cellspacing="1" width="100%" style="margin:0 0 0 0">
		<COLGROUP> 
		<COL width="25%">
		<COL width="25%">
		<COL width="25%">
		<COL width="25%">
	 <%for(int j=0;j<cusList.size();j++){%>
		<%if(isLight){%>	
		<TR CLASS=DataLight>
		<%}else{%>
		<TR CLASS=DataDark>
		<%}%>
	    <td colspan="4">
	    <a href="#" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=cusList.get(j).toString()%>')">
	    <%=CustomerInfoComInfo.getCustomerInfoname(cusList.get(j).toString())%>
	    </a>
	    </td>
	  </tr>
	  <tr>
	  	<td>
				<table class=ListStyle>
					<COLGROUP>
					<COL width="25%">
					<COL width="25%">
					<COL width="25%">
					<COL width="25%">
				<%
				String sql = "";
				//String temptable = WorkPlanShareBase.getTempTable(String.valueOf(userid));
				if (RecordSet.getDBType().equals("oracle"))
					sql = " SELECT * FROM ( SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
						+ " FROM WorkPlan WHERE id IN ( "
					    + " SELECT DISTINCT a.id FROM WorkPlan a, WorkPlanShareDetail b "
				        + " WHERE a.id = b.workid"
						+ " AND (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + cusList.get(j).toString() + ",%'"
						//+ " AND b.usertype = "+logintype+" AND b.userid = " + String.valueOf(userid)  //fix TD2536
						+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC) ";
				else if (RecordSet.getDBType().equals("db2"))
					sql = " SELECT id, begindate, begintime, resourceid, description, createrid, createrType, relatedprj, taskid, crmid, requestid, docid"
						+ " FROM WorkPlan WHERE id IN ( "
					    + " SELECT DISTINCT a.id FROM WorkPlan a, WorkPlanShareDetail b "
				        + " WHERE a.id = b.workid"
						+ " AND (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + cusList.get(j).toString() + ",%'"
						//+ " AND b.usertype = "+logintype+" AND b.userid = " + String.valueOf(userid)  //fix TD2536
						+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC ";
				else
					sql = "SELECT id, begindate , begintime, resourceid, description, createrid, createrType, relatedprj, taskid, crmid, requestid, docid"
						+ " FROM WorkPlan WHERE id IN ("
					    + "SELECT DISTINCT a.id FROM WorkPlan a,  WorkPlanShareDetail b WHERE a.id = b.workid"
						+ " AND (',' + a.crmid + ',') LIKE '%," + cusList.get(j).toString() + ",%'"
						//+ " AND b.usertype = " + logintype + " AND b.userid = " + String.valueOf(userid)  //fix TD2536
						+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC";
				
				//RecordSet.writeLog(sql);
				String m_beginDate = "";
				String m_beginTime = "";
				String m_memberIds = "";
				String m_createrType = "";
				String m_description = "";
				RecordSet.executeSql(sql);
				while (RecordSet.next()) {
					m_beginDate = Util.null2String(RecordSet.getString("begindate"));
					m_beginTime = Util.null2String(RecordSet.getString("begintime"));
					m_memberIds = Util.null2String(RecordSet.getString("createrid"));
					m_createrType = Util.null2String(RecordSet.getString("createrType"));
					m_description = Util.null2String(RecordSet.getString("description"));
					String relatedprj = Util.null2String(RecordSet.getString("taskid"));
					String relatedcus = Util.null2String(RecordSet.getString("crmid"));
					String relatedwf = Util.null2String(RecordSet.getString("requestid"));
					String relateddoc = Util.null2String(RecordSet.getString("docid"));
					ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
					ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
					ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
					ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");
				%>
				  <tr>
				    <td colspan="4">
				    <%
					if (!logintype.equals("2")) {
						if (m_createrType.equals("1")) {
							if (!m_memberIds.equals("")) {
								ArrayList members = Util.TokenizerString(m_memberIds, ",");
								for (int i = 0; i < members.size(); i++) {
							%>
										<A href="#" onclick="openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=<%=""+members.get(i)%>')">
										<%=ResourceComInfo.getResourcename(""+members.get(i))%></A>&nbsp;
							<%
											}
										}
									} else {
										if (!m_memberIds.equals("")) {
											ArrayList members = Util.TokenizerString(m_memberIds, ",");
											for (int i = 0; i < members.size(); i++) {
							%>
										<A href="javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=""+members.get(i)%>')">
										<%=CustomerInfoComInfo.getCustomerInfoname(""+members.get(i))%></A>&nbsp;
							<%
											}
										}
									}
								} else {
									if (m_createrType.equals("1")) {
										if (!m_memberIds.equals("")) {
											ArrayList members = Util.TokenizerString(m_memberIds, ",");
											for (int i = 0; i < members.size(); i++) {
							%>
									<%=ResourceComInfo.getResourcename(""+members.get(i))%>
							<%
											}
										}
									} else {
										if (!m_memberIds.equals("")) {
											ArrayList members = Util.TokenizerString(m_memberIds, ",");
											for (int i = 0; i < members.size(); i++) {
							%>
										<A href="#" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=""+members.get(i)%>')">
										<%=CustomerInfoComInfo.getCustomerInfoname(""+members.get(i))%></A>
							<%
											}
										}
									}
								}
							%>
							<%=" "+m_beginDate+" "+m_beginTime%>
							</td>
				  </tr>
					<%if(isLight){%>	
					<TR CLASS=DataLight>
					<%}else{%>
					<TR CLASS=DataDark>
					<%}%>
						<TD style="word-break:break-all"  colSpan=4>
						<%=Util.toScreen(m_description,user.getLanguage())%>
						</TD>
					</TR>

					<%if(isLight){%>	
					<TR CLASS=DataLight>
					<%}else{%>
					<TR CLASS=DataDark>
					<%}%>
				    <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
				    <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
				    <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
				    <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
				  </tr>
				  <%if(relateddocList.size()+relatedprjList.size()+relatedcusList.size()+relatedwfList.size()!=0){%>
					<%if(isLight){%>	
					<TR CLASS=DataLight>
					<%}else{%>
					<TR CLASS=DataDark>
					<%}%>
				    <td>
						<%for(int i=0;i<relateddocList.size();i++){%>
							<a href="#" onclick="openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=relateddocList.get(i).toString()%>')">
							<%=DocComInfo.getDocname(relateddocList.get(i).toString())%><br>
							</a>
						<%}%>
						</td>
				    <td>
						<%for(int i=0;i<relatedprjList.size();i++){%>
							<a href="#" onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList.get(i).toString()%>')">
							<%=ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString())%><br>
							</a>
						<%}%>
						</td>
				    <td>
						<%for(int i=0;i<relatedcusList.size();i++){%>
							<a href="#" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList.get(i).toString()%>')">
							<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString())%><br>
							</a>
						<%}%>		
						</td>
				    <td>
						<%for(int i=0;i<relatedwfList.size();i++){%>
							<a href="#" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList.get(i).toString()%>')">
							<%=RequestComInfo.getRequestname(relatedwfList.get(i).toString())%><br>
							</a>
						<%}%>		
						</td>
				  </tr>
					<%}
				isLight=!isLight;
				}
				%>
			</table>
	  	</td>
	 	</tr>
	  
	 <%}%>
	</table>	
	<%}else
		out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
}
}else if(type==6){
   if(isgoveproj==0){
      ArrayList taskList = dao.getRelatedPrjs();
	  if(taskList.size()>0){
%>
     <!-- 相关项目任务 -->		
	<table class=ListStyle cellspacing="1" width="100%" style="margin:0 0 0 0">
		<COLGROUP> 
		<COL width="25%">
		<COL width="25%">
		<COL width="25%">
		<COL width="25%">
	 <%for(int j=0;j<taskList.size();j++){%>
		<%if(isLight){%>	
		<TR CLASS=DataLight>
		<%}else{%>
		<TR CLASS=DataDark>
		<%}%>
	    <td colspan="4">
	    <a href="#" onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=taskList.get(j).toString()%>')">
	    <%=ProjectTaskApprovalDetail.getTaskSuject(taskList.get(j).toString())%>(<%=SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+ProjectTaskApprovalDetail.getProjectNameByTaskId(taskList.get(j).toString())%>)
	    </a>
	    </td>
	 	<TR style="display:none">
		 	<TD>
				<%
				isLight = false;
				char flag0=2;
				RecordSet.executeProc("ExchangeInfo_SelectBID",taskList.get(j).toString()+flag0+"PT");
				
				while(RecordSet.next())
				{
					String relatedprj = Util.null2String(RecordSet.getString("relatedprj"));
					String relatedcus = Util.null2String(RecordSet.getString("relatedcus"));
					String relatedwf = Util.null2String(RecordSet.getString("relatedwf"));
					String relateddoc = Util.null2String(RecordSet.getString("relateddoc"));
					ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
					ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
					ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
					ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");
				%>
					<table class=ListStyle>
		    	<TR>
		      	<TD colspan="4">
						<%if(Util.getIntValue(RecordSet.getString("creater"))>0){%>
						<a href="#" onclick="openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("creater")%>')"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("creater")),user.getLanguage())%></a>
						<%}else{%>
						<A href="#" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("creater").substring(1)%>')"><%=CustomerInfoComInfo.getCustomerInfoname(""+RecordSet.getString("creater").substring(1))%></a>
						<%}%>
						<%=" "+RecordSet.getString("createDate")+" "+RecordSet.getString("createTime")%>
					  </TD>
	    		</TR>
					<%if(isLight){%>	
					<TR CLASS=DataLight>
					<%}else{%>
					<TR CLASS=DataDark>
					<%}%>
						<TD style="word-break:break-all"  colSpan=4>
						<%=Util.toScreen(RecordSet.getString("remark"),user.getLanguage())%>
						</TD>
					</TR>
					<%if(isLight){%>	
					<TR CLASS=DataLight>
					<%}else{%>
					<TR CLASS=DataDark>
					<%}%>
				    <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
				    <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
				    <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
				    <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
				  </tr>
				  <%if(relateddocList.size()+relatedprjList.size()+relatedcusList.size()+relatedwfList.size()!=0){%>
						<%if(isLight){%>	
						<TR CLASS=DataLight>
						<%}else{%>
						<TR CLASS=DataDark>
						<%}%>
					    <td>
							<%for(int i=0;i<relateddocList.size();i++){%>
								<a href="#" onclick="openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=relateddocList.get(i).toString()%>')">
								<%=DocComInfo.getDocname(relateddocList.get(i).toString())%><br>
								</a>
							<%}%>
							</td>
					    <td>
							<%for(int i=0;i<relatedprjList.size();i++){%>
								<a href="#" onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList.get(i).toString()%>')">
								<%=ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString())%>11111<br>
								</a>
							<%}%>
							</td>
					    <td>
							<%for(int i=0;i<relatedcusList.size();i++){%>
								<a href="#" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList.get(i).toString()%>')">
								<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString())%><br>
								</a>
							<%}%>		
							</td>
					    <td>
							<%for(int i=0;i<relatedwfList.size();i++){%>
								<a href="#" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList.get(i).toString()%>')">
								<%=RequestComInfo.getRequestname(relatedwfList.get(i).toString())%><br>
								</a>
							<%}%>		
							</td>
					<%}%>
				</table>
			<%}%>
		 	</TD>
	 	</TR>
	 <%
	 isLight = !isLight;
	 }%>
	</table>
	<%}else
		out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
}
}else if(type == 5) {
	if(isgoveproj==0){
	ArrayList mutilprjList = dao.getMutilPrjsList();
	if(mutilprjList.size()>0){
%>
    <!-- 相关项目 -->	
	<table class=ListStyle cellspacing="1" width="100%" style="margin:0 0 0 0">
		<COLGROUP> 
		<COL width="25%">
		<COL width="25%">
		<COL width="25%">
		<COL width="25%">
	 <%for(int j=0;j<mutilprjList.size();j++){%>
		<%if(isLight){%>	
		<TR CLASS=DataLight>
		<%}else{%>
		<TR CLASS=DataDark>
		<%}%>
	    <td colspan="4">
	    <a href="#" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=mutilprjList.get(j).toString()%>')">  
		<%=projectInfoComInfo.getProjectInfoname(mutilprjList.get(j).toString())%><br>
		</a>
	    </td>	
	 <%
	 isLight = !isLight;
	 }%>
	</table>
<%}else
	out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
}%>

<%}else if(type==7){
		ArrayList accList = dao.getRelatedAccs();
		if(accList.size()>0){
%>
    <!-- 相关附件 -->	
	<table class=ListStyle style="width: 100%" cellspacing="1" width="100%" style="margin:0 0 0 0">
	<%for(int j=0;j<accList.size();j++){%>
				<%
            RecordSet.executeSql("select id,docsubject,accessorycount from docdetail where id="+accList.get(j));
            int linknum=-1;
          	if(RecordSet.next()){
							if(!isLight){%>	
							<TR CLASS=DataLight>
							<%}else{%>
							<TR CLASS=DataDark>
							<%}%>
								<td>
							<%
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
            <a href="#" style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>','<%=id%>')"><%=docImagefilename%></a>&nbsp
          <%}else{%>
            <a style="cursor:hand" onclick="opendoc1('<%=showid%>','<%=id%>')"><%=tempshowname%></a>&nbsp;
					<%}%>
		     </td>
		     <td>
		        <%if(accessoryCount==1){%>
              <span id = "selectDownload">
                <%
                  //boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
                  //if(!isLocked){
                %>
                  <button type="button" class=btn accessKey=1  onclick="downloads('<%=docImagefileid%>',<%=id%>)">
                    <%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
                  </button>
                <%//}%>
              </span>
              <%} %>	
		     </td>
		  </tr>
		 <%}%>
	 <%
	 isLight = !isLight;
	 }%>
	</table>
<%}else
	out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
}%>
