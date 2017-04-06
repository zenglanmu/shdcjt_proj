<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<%

int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int languageidfromrequest = Util.getIntValue(request.getParameter("languageid"));
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"), 0);
int userid = Util.getIntValue(request.getParameter("userid"), 0);
boolean isprint = Util.null2String(request.getParameter("isprint")).equalsIgnoreCase("true");
String isOldWf = Util.null2String(request.getParameter("isOldWf"));
String viewLogIds = Util.null2String(request.getParameter("viewLogIds"));
String orderbytype = Util.null2String(request.getParameter("orderbytype"));
int creatorNodeId = Util.getIntValue(Util.null2String(request.getParameter("creatorNodeId")));

String pgflag = Util.null2String(request.getParameter("pgnumber"));
String maxrequestlogid = Util.null2String(request.getParameter("maxrequestlogid"));
int pgnumber = Util.getIntValue(pgflag);
int wfsignlddtcnt = Util.getIntValue(request.getParameter("wfsignlddtcnt"), 0);
boolean isOldWf_ = false;
if(isOldWf.trim().equals("true")) isOldWf_=true;
User user2 = HrmUserVarify.getUser(request, response);
if (user2 == null)
	return;


String orderby = "desc";
String imgline="<img src=\"/images/xp/L.png\">";
if("2".equals(orderbytype))
{
	orderby = "asc";
    imgline="<img src=\"/images/xp/L1.png\">";
}
WFLinkInfo.setRequest(request);
ArrayList log_loglist = null;

StringBuffer sbfmaxrequestlogid = new StringBuffer(maxrequestlogid);
if (pgflag == null || pgflag.equals("")) {
	log_loglist = WFLinkInfo.getRequestLog(requestid,workflowid,viewLogIds,orderby);
} else {
	log_loglist = WFLinkInfo.getRequestLog(requestid,workflowid,viewLogIds,orderby, wfsignlddtcnt, sbfmaxrequestlogid);
}

boolean isLight = false;
int nLogCount=0;
String lineNTdOne="";
String lineNTdTwo="";
int log_branchenodeid=0;
String log_tempvalue="";
int tempRequestLogId=0;
int tempImageFileId=0;
%>

<%!
 private String script2Empty(String pagestr) {
    String retrunstr = "";
	while(pagestr.toLowerCase().indexOf("<script") != -1){
        int startindx = pagestr.toLowerCase().indexOf("<script");
		int endindx = pagestr.toLowerCase().indexOf("</script>");
		if (endindx != -1 && endindx > startindx){
			retrunstr += pagestr.substring(0, startindx);
			pagestr = pagestr.substring(endindx + 9);
		}
	}
	retrunstr+=pagestr;
	
	return retrunstr;
 }
%>

<%if (pgflag == null || pgflag.equals("")) {  %>
<table class=liststyle cellspacing=1>
    <colgroup>
    <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    <tbody>
<%} else {
	int currentPageCnt = log_loglist.size();
	out.print("<input type=\"hidden\" name=\"currentPageCnt" + pgnumber + "\" value=\"" + currentPageCnt + "\">");
	out.print("<input type=\"hidden\" name=\"maxrequestlogid" + pgnumber + "\" value=\"" + sbfmaxrequestlogid.toString() + "\">");
	if (log_loglist == null || log_loglist.isEmpty()) {
		out.print("<requestlognodata>");
		return;
	}
}
%>

<%
for(int i=0;i<log_loglist.size();i++)
{
    Hashtable htlog=(Hashtable)log_loglist.get(i);
    int log_isbranche=Util.getIntValue((String)htlog.get("isbranche"),0);
    int log_nodeid=Util.getIntValue((String)htlog.get("nodeid"),0);
    int log_nodeattribute=Util.getIntValue((String)htlog.get("nodeattribute"),0);
    String log_nodename=Util.null2String((String)htlog.get("nodename"));
    int log_destnodeid=Util.getIntValue((String)htlog.get("destnodeid"));
    String log_remark=Util.null2String((String)htlog.get("remark"));
    String log_operatortype=Util.null2String((String)htlog.get("operatortype"));
    String log_operator=Util.null2String((String)htlog.get("operator"));
    String log_agenttype=Util.null2String((String)htlog.get("agenttype"));
    String log_agentorbyagentid=Util.null2String((String)htlog.get("agentorbyagentid"));
    String log_operatedate=Util.null2String((String)htlog.get("operatedate"));
    String log_operatetime=Util.null2String((String)htlog.get("operatetime"));
    String log_logtype=Util.null2String((String)htlog.get("logtype"));
    String log_receivedPersons=Util.null2String((String)htlog.get("receivedPersons"));
    tempRequestLogId=Util.getIntValue((String)htlog.get("logid"),0);
    String log_annexdocids=Util.null2String((String)htlog.get("annexdocids"));
    String log_operatorDept=Util.null2String((String)htlog.get("operatorDept"));
    String log_signdocids=Util.null2String((String)htlog.get("signdocids"));
    String log_signworkflowids=Util.null2String((String)htlog.get("signworkflowids"));
    
    String log_remarkHtml = Util.null2String((String)htlog.get("remarkHtml"));
    String log_iframeId = Util.null2String((String)htlog.get("iframeId"));	
    
    if (pgflag == null || pgflag.equals("")) {
	    if(log_loglist.size()>10)
	    {
	    	if(i<10)
	    	{
	    		continue;
	    	}
	    }
    } 
    String log_nodeimg="";
    if(log_tempvalue.equals(log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime)){
        log_branchenodeid=0;
    }else{
        log_tempvalue=log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime;
    }
    if(log_nodeattribute==1&&(log_logtype.equals("0")||log_logtype.equals("2"))&&log_branchenodeid==0){
        log_nodeimg=imgline;
        log_branchenodeid=log_nodeid;
    }
    if(log_isbranche==1){
        log_nodeimg="<img src=\"/images/xp/T.png\">";
        log_branchenodeid=0;
    }

	tempImageFileId=0;
	if(tempRequestLogId>0)
	{
		RecordSetlog3.executeSql("select imageFileId from Workflow_FormSignRemark where requestLogId="+tempRequestLogId);
		if(RecordSetlog3.next())
		{
			tempImageFileId=Util.getIntValue(RecordSetlog3.getString("imageFileId"),0);
		}
	}

	lineNTdOne="line"+String.valueOf(nLogCount)+"TdOne";
    if(log_isbranche==0&&"2".equals(orderbytype)) isLight = !isLight;
%>
          <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%>>
           <td width="10%"><%=log_nodeimg%><%=Util.toScreen(log_nodename,languageidfromrequest)%></td>
           <td width=50%>
			<table width=100%>
			  <tr> 
             	<td colspan="3">
            	<%
            	if(!log_logtype.equals("t"))
            	{
					if(tempRequestLogId>0&&tempImageFileId>0)
					{
				%>
					<jsp:include page="/workflow/request/WorkflowLoadSignatureRequestLogId.jsp">
						<jsp:param name="tempRequestLogId" value="<%=tempRequestLogId%>" />
					</jsp:include>
				<%
					}
					else
					{
						String tempremark = log_remark;
						tempremark = Util.StringReplace(tempremark,"&lt;br&gt;","<br>");
				%>
				    <%=Util.StringReplace(tempremark,"&nbsp;"," ")%>
				    
				    
				    <%
				    if (pgflag != null && !pgflag.equals("")) {
					%>
			            <script type="text/javascript">
						try {
							setIframeContent("<%=log_iframeId %>", "<%=script2Empty(log_remarkHtml).replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "").replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"")%>");
							 bodyresize(document.getElementById("<%=log_iframeId%>").contentWindow.document, "<%=log_iframeId%>", 1);
						} catch(e) {}
            </script>
					<%
					}
					%>
				    
				    
				<%
					}
				%>
             <%
             }
             if(!log_annexdocids.equals("")||!log_signdocids.equals("")||!log_signworkflowids.equals(""))
             {
                if(!log_logtype.equals("t")&&tempRequestLogId>0&&tempImageFileId>0)
                {
             %>
                </td>
              </tr>
              <tr>
                <td colspan="3">
             <%
                }
             %>
           			<br/>
		            <table width="70%">
		                 <tr height="1"><td><td style="border:1px dotted #000000;border-top-color:#ffffff;border-left-color:#ffffff;border-right-color:#ffffff;height:1px">&nbsp;</td></tr>
		            </table>
		          	<table>
          				<tbody >
             <%
	            String signhead="";
	            if(!log_signdocids.equals(""))
	            {
		            RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_signdocids+") order by id asc");
		            int linknum=-1;
		            while(RecordSetlog3.next())
		            {
		              linknum++;
		              if(linknum==0)
		              {
		                  signhead=SystemEnv.getHtmlLabelName(857,languageidfromrequest)+":";
		              }
		              else
		              {
		                  signhead="&nbsp;";
		              }
		              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
		              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),languageidfromrequest) ;
              %>

				          <tr>
				            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
				            <td >
				                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp;
				            </td>
				          </tr>
            <%
              	    }
                }
	            ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
	            int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
	            for(int k=0;k<tempwflists.size();k++)
	            {
	              if(k==0)
	              {
	                  signhead=SystemEnv.getHtmlLabelName(1044,languageidfromrequest)+":";
	              }
	              else
	              {
	                  signhead="&nbsp;";
	              }
                  tempnum++;
                  session.setAttribute("resrequestid" + tempnum, "" + tempwflists.get(k));                
                  String temprequestname="<a style=\"cursor:pointer\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+tempwflists.get(k)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)tempwflists.get(k))+"</a>";
            %>

	          <tr>
	            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
	            <td><%=temprequestname%></td>
	          </tr>
              <%
            }
            session.setAttribute("slinkwfnum", "" + tempnum);
            session.setAttribute("haslinkworkflow", "1");
            if(!log_annexdocids.equals("")){
            RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_annexdocids+") order by id asc");
            int linknum=-1;
            while(RecordSetlog3.next()){
              linknum++;
              if(linknum==0){
                  signhead=SystemEnv.getHtmlLabelName(22194,languageidfromrequest)+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),languageidfromrequest) ;
              int accessoryCount=RecordSetlog3.getInt(3);
              String SecCategory=Util.null2String(RecordSetlog3.getString(4));
              DocImageManager.resetParameter();
              DocImageManager.setDocid(Util.getIntValue(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefilename = "";
              String fileExtendName = "";
              String docImagefileid = "";
              int versionId = 0;
              long docImagefileSize = 0;
              if(DocImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }
              String imgSrc= AttachFileUtil.getImgStrbyExtendName(fileExtendName,16);
              boolean nodownload=SecCategoryComInfo1.getNoDownload(SecCategory).equals("1")?true:false;
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td >
              <%=imgSrc%>
              <%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx")||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=tempshowname%></a>&nbsp
              <%}
              if(accessoryCount==1 &&!isprint&&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){%>
              <BUTTON class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>'">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,languageidfromrequest)%>	(<%=docImagefileSize/1000%>K)
                  </BUTTON>
              <%}%>
            </td>
          </tr>
              <%}}%>
          </tbody>
          </table>
                <%}%>
             </td>
             </tr>
                  <!--  modified end. -->
             <tr>
             <td>&nbsp;</td>
              <td align=right>
                <%-- xwj for td2104 on 20050802 begin --%>
             <%
                 BaseBean wfsbean=FieldInfo.getWfsbean();
                int showimg = Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","showimg"),0);
                rssign.execute("select * from DocSignature  where hrmresid=" + log_operator + "order by markid");
                String userimg = "";
                if (showimg == 1 && rssign.next()) {
                    // 获取签章图片并显示
                    String markpath = Util.null2String(rssign.getString("markpath"));
                    if (!markpath.equals("")) {
                        userimg = "/weaver/weaver.file.ImgFileDownload?userid=" + log_operator;
                    }
                }
                if(!userimg.equals("")){
			%>
			<img id=markImg src="<%=userimg%>" ></img>
			<%
			}
			else
			 {
                 if(isOldWf_)
             {
              //System.out.println("viewsign_old");
            if(log_operatortype.equals("0")){%>
            <!-- modify by xhheng @20050304 for TD 1691 -->
            <%if(isprint==false){%>
			<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
	<a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'>
              <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
            <%}else{%>
	              <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%> <%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%>
	               /
				   <%}%>
              <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%>
            <%}%>

<%}else if(log_operatortype.equals("1")){%>
  <!-- modify by xhheng @20050304 for TD 1691 -->
  <%if(isprint==false){%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>&requestid=<%=requestid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),languageidfromrequest)%></a>
  <%}else{%>
	 <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%> <%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%>
	  /
	  <%}%>
    <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),languageidfromrequest)%>
  <%}%>
<%}else{%>
<%=SystemEnv.getHtmlLabelName(468,languageidfromrequest)%>
<%}
             
             }
             else
             {
                        //System.out.println("viewsign_new");
                         if(log_operatortype.equals("0")){%>
            <!-- modify by xhheng @20050304 for TD 1691 -->
            <%if(isprint==false)
            {
                if(!log_agenttype.equals("2")){%>
				<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
	                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
               <%}
                /*----------added by xwj for td2891 begin----------- */
                else if(log_agenttype.equals("2") || log_agenttype.equals("1")){
                   
                   if(!(""+log_nodeid).equals(String.valueOf(creatorNodeId))){%>
                   <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                    -> 
				<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)+SystemEnv.getHtmlLabelName(24213,languageidfromrequest)%></a>
                   
                   <%}
                   else{//创造节点log, 如果设置代理时选中了代理流程创建,同时代理人本身对该流程就具有创建权限,那么该代理人创建节点的log不体现代理关系
                   String agentCheckSql = " select * from workflow_Agent where workflowId="+ workflowid +" and beagenterId=" + log_agentorbyagentid +
													 " and agenttype = '1' " +
													 " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
													 " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
													 " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
													 " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
													 " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
													 " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)";
                  RecordSetlog3.executeSql(agentCheckSql);
                  if(!RecordSetlog3.next()){
                      %>
					  <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                      <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                  <%}
                  else{
                  String isCreator = RecordSetlog3.getString("isCreateAgenter");
                  
                  if(!isCreator.equals("1")){%>
                <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                  <%}
                  else{
                   
                   int userLevelUp = -1;
                   int uesrLevelTo = -1;
                   int secLevel = -1;
                   rsCheckUserCreater.executeSql("select seclevel from HrmResource where id= " + log_operator);
                   if(rsCheckUserCreater.next()){
                   secLevel = rsCheckUserCreater.getInt("seclevel");
                   }
                   else{
                   rsCheckUserCreater.executeSql("select seclevel from HrmResourceManager where id= " + log_operator);
                   if(rsCheckUserCreater.next()){
                   secLevel = rsCheckUserCreater.getInt("seclevel");
                   }
                   }
                   
                 //是否有此流程的创建权限
                   boolean haswfcreate = new weaver.share.ShareManager().hasWfCreatePermission(HrmUserVarify.getUser(request, response), workflowid);;
                   if(haswfcreate){%>
				   <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                   <%}
                  else{%>
				  <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                    -> 
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)+SystemEnv.getHtmlLabelName(24213,languageidfromrequest)%></a>
                 
                  <%} 
                  }
                  
                  }
                }
                }
                /*----------added by xwj for td2891 end----------- */
                else{
                }
            }
            else
            {
              
               if(!log_agenttype.equals("2")){%>
              <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%> <%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%>
               /
			   <%}%>
	                   <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%>
               <%}
                else if(log_agenttype.equals("2")){%>
                 <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%> <%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%>
                  /
				  <%}%>
                  <%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%>
                -> 
               <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%> <%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%>
                  /
				  <%}%>
                <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)+SystemEnv.getHtmlLabelName(24213,languageidfromrequest)%>
                  
                <%}
                else{
                }
            
           }

       }
     
       else if(log_operatortype.equals("1")){%>
  <%if(isprint==false){%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>&requestid=<%=requestid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),languageidfromrequest)%></a>
  <%}else{%>
    <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),languageidfromrequest)%>
  <%}%>
<%}else{%>
<%=SystemEnv.getHtmlLabelName(468,languageidfromrequest)%>
<%}
             
             
}}%>
         
           
            </td>
            </tr>
            <tr>
            <td>&nbsp;</td>
           <td align=right><%=Util.toScreen(log_operatedate,languageidfromrequest)%>
              &nbsp<%=Util.toScreen(log_operatetime,languageidfromrequest)%>
              </td>
            </tr>
             </table>
            <td>
              <%
	String logtype = log_logtype;
	String operationname = RequestLogOperateName.getOperateName(""+workflowid,""+requestid,""+log_nodeid,logtype,log_operator,languageidfromrequest);
	%>
	<%=operationname%>
<%
lineNTdTwo="line"+String.valueOf(nLogCount)+"TdTwo"+Util.getRandom();
%>
            </td>
          <td id="<%=lineNTdTwo%>">
              <%
                String tempStr ="";
                if(log_receivedPersons.length()>0) tempStr =Util.toScreen(log_receivedPersons.substring(0,log_receivedPersons.length()-1),languageidfromrequest);
				String showoperators="";
				try
				{
				showoperators=RequestDefaultComInfo.getShowoperator(""+userid);
				
				}
				catch (Exception eshows)
				{
				}
                if (!showoperators.equals("1")) {
                if(!"".equals(tempStr) && tempStr != null){
                        tempStr = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick=showallreceivedforsign('"+requestid+"','"+viewLogIds+"','"+log_operator+"','"+log_operatedate+
                                "','"+log_operatetime+"','"+lineNTdTwo+"','"+log_logtype+"',"+log_destnodeid+") >"+SystemEnv.getHtmlLabelName(89,languageidfromrequest)+"</span>";
                }
				}
              %>
              <%=tempStr%>
          </td>
          </tr>

          <%
	if(log_isbranche==0&&!"2".equals(orderbytype)) isLight = !isLight;
}
%>
<%if (pgflag == null || pgflag.equals("")) {  %>
</tbody></table>
<%} %>
