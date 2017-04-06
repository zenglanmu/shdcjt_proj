<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.net.URLEncoder" %>
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<%@page import = "weaver.general.TimeUtil"%>
<%@ page import="weaver.workflow.request.ComparatorUtilBean"%>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<!--added by xwj for td2891-->
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestSignatureManager" class="weaver.workflow.request.RequestSignatureManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog1" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog2" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<jsp:useBean id="RequestUseTempletManager" class="weaver.workflow.request.RequestUseTempletManager" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>
 -->
 <script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>
<%
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
String nodetype= Util.null2String(request.getParameter("nodetype"));
String isremark=Util.null2String(request.getParameter("isremark"));
String isOldWf=Util.null2String(request.getParameter("isOldWf"));
String topage = Util.null2String(request.getParameter("topage")) ;        //返回的页面
String newReportUserId=Util.null2String(request.getParameter("newReportUserId"));
String newCrmId=Util.null2String(request.getParameter("newCrmId"));
boolean isOldWf_ = false;
if(isOldWf.trim().equals("true")) isOldWf_=true;
String creatername="";
// 操作的用户信息
int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());
int workflowid=Util.getIntValue(request.getParameter("workflowid"),0);           //工作流id
String currentdate= Util.null2String(request.getParameter("currentdate"));
String currenttime= Util.null2String(request.getParameter("currenttime"));
String needcheck= "";
int usertype_wfvwt = user.getLogintype().equals("1")?0:1;

/**流程存为文档是否要签字意见**/
boolean fromworkflowtodoc = Util.null2String((String)session.getAttribute("urlfrom_workflowtodoc_"+requestid)).equals("true");
boolean ReservationSign = false;
RecordSet.executeSql("select * from workflow_base where id = " + workflowid);
if(RecordSet.next()) ReservationSign = (RecordSet.getInt("keepsign")==2);
if(fromworkflowtodoc&&ReservationSign){
	return;
}
/**流程存为文档是否要签字意见**/

%>
<jsp:include page="WorkflowViewWT.jsp" flush="true">
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="userid" value="<%=user.getUID()%>" />
	<jsp:param name="usertype" value="<%=usertype_wfvwt%>" />
	<jsp:param name="languageid" value="<%=user.getLanguage()%>" />
</jsp:include>
<%
int initrequestid = requestid;
ArrayList allrequestid = new ArrayList();
ArrayList allrequestname = new ArrayList();
ArrayList canviewwf = (ArrayList)session.getAttribute("canviewwf");
if(canviewwf == null) canviewwf = new ArrayList();
int mainrequestid = 0;
int mainworkflowid = 0;
String canviewworkflowid = "-1";

rssign.executeSql("select requestname,mainrequestid from workflow_requestbase where requestid = "+ requestid);
if(rssign.next()){
    if(rssign.getInt("mainrequestid") > -1){
      mainrequestid = rssign.getInt("mainrequestid");
      rssign.executeSql("select * from workflow_requestbase where requestid = "+ mainrequestid);
      if(rssign.next()){
          allrequestid.add(mainrequestid + ".main");
          allrequestname.add(rssign.getString("requestname"));
      }
    }
  }
String isSignMustInput="0";
rssign.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(rssign.next()){
	isSignMustInput = ""+Util.getIntValue(rssign.getString("issignmustinput"), 0);
}

rssign.executeSql("select * from workflow_requestbase where requestid = "+ mainrequestid);
if(rssign.next()){
     mainworkflowid = rssign.getInt("workflowid");
  }

rssign.executeSql("select distinct subworkflowid from Workflow_SubwfSet where mainworkflowid in ("+mainworkflowid+","+workflowid+") and isread = 1 ");
while(rssign.next()){
     canviewworkflowid+=","+rssign.getString("subworkflowid");
  }

rssign.executeSql("select distinct b.subworkflowid from Workflow_TriDiffWfDiffField a, Workflow_TriDiffWfSubWf b where a.id=b.triDiffWfDiffFieldId and b.isRead=1 and a.mainworkflowid in ("+mainworkflowid+","+workflowid+")");
while(rssign.next()){
     canviewworkflowid+=","+rssign.getString("subworkflowid");
  }

rssign.executeSql("select * from workflow_requestbase where mainrequestid = "+ mainrequestid +" and workflowid in ("+canviewworkflowid+")");
while(rssign.next()){
    allrequestid.add(rssign.getString("requestid") + ".parallel");
    allrequestname.add(rssign.getString("requestname"));
    canviewwf.add(rssign.getString("requestid"));
  }

rssign.executeSql("select * from workflow_requestbase where mainrequestid = "+ requestid+" and workflowid in ("+canviewworkflowid+")");
while(rssign.next()){
    allrequestid.add(rssign.getString("requestid") + ".sub");
    allrequestname.add(rssign.getString("requestname"));
    canviewwf.add(rssign.getString("requestid"));
  }

int index = allrequestid.indexOf(requestid+".parallel");
if(index>-1){
    allrequestid.remove(index);
    allrequestname.remove(index);
  }

if(mainrequestid > 0){
	index = allrequestid.indexOf(mainrequestid+".main");
    if(index>-1){
		//rssign.executeSql("select * from Workflow_SubwfSet where mainworkflowid = "+mainworkflowid+" and subworkflowid = "+workflowid+" and isread = 1");
		rssign.executeSql("select 1 from Workflow_SubwfSet where mainworkflowid = "+mainworkflowid+" and subworkflowid ="+workflowid+" and isread = 1 union select 1 from Workflow_TriDiffWfDiffField a, Workflow_TriDiffWfSubWf b where a.id=b.triDiffWfDiffFieldId and b.isRead=1 and a.mainworkflowid="+mainworkflowid+" and b.subWorkflowId="+workflowid);
		if(rssign.getCounts()==0&&allrequestid.size()>0&&allrequestname.size()>0){
		   allrequestid.remove(index);
		   allrequestname.remove(index);
		}
	}
}

session.setAttribute("canviewwf",canviewwf);

String needconfirm="";
String isannexupload_edit="";
String annexdocCategory_edit="";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
String showDocTab_edit="";
String showWorkflowTab_edit="";
String showUploadTab_edit="";
RecordSetLog.execute("select needAffirmance,isannexupload,annexdocCategory,isSignDoc,isSignWorkflow,showDocTab,showWorkflowTab,showUploadTab from workflow_base where id="+workflowid);
if(RecordSetLog.next()){
    needconfirm=Util.null2o(RecordSetLog.getString("needAffirmance"));
    isannexupload_edit=Util.null2String(RecordSetLog.getString("isannexupload"));
    annexdocCategory_edit=Util.null2String(RecordSetLog.getString("annexdocCategory"));
    isSignDoc_edit=Util.null2String(RecordSetLog.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSetLog.getString("isSignWorkflow"));
    showDocTab_edit=Util.null2String(RecordSetLog.getString("showDocTab"));
    showWorkflowTab_edit=Util.null2String(RecordSetLog.getString("showWorkflowTab"));
    showUploadTab_edit=Util.null2String(RecordSetLog.getString("showUploadTab"));
}

    String billtablename = "";
    int operatorsize = 0;
    int formid=Util.getIntValue(request.getParameter("formid"),0);
    int isbill=Util.getIntValue(request.getParameter("isbill"),0);
    int billid=Util.getIntValue(request.getParameter("billid"),0);
    int creater = Util.getIntValue(request.getParameter("creater"),0);
    int creatertype =Util.getIntValue(request.getParameter("creatertype"),0);

//TD4262 增加提示信息  开始
    String ismode= Util.null2String(request.getParameter("ismode"));
//TD4262 增加提示信息  结束
    String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
    String isworkflowdoc = Util.getIntValue(request.getParameter("isworkflowdoc"),0)+"";//是否为公文

    int usertype = (user.getLogintype()).equals("1") ? 0 : 1;
    creatername=ResourceComInfo.getResourcename(""+creater);
    boolean hasnextnodeoperator = false;
    Hashtable operatorsht = new Hashtable();
    String intervenoruserids="";
    String intervenorusernames="";
    int nextnodeid=nodeid;
if(isremark.equals("5")){
if (isbill == 1) {
			RecordSet.executeSql("select tablename from workflow_bill where id = " + formid); // 查询工作流单据表的信息
			if (RecordSet.next())
				billtablename = RecordSet.getString("tablename");          // 获得单据的主表
}
//查询节点操作者
        requestNodeFlow.setRequestid(requestid);
		requestNodeFlow.setNodeid(nodeid);
		requestNodeFlow.setNodetype(nodetype);
		requestNodeFlow.setWorkflowid(workflowid);
		requestNodeFlow.setUserid(userid);
		requestNodeFlow.setUsertype(usertype);
		requestNodeFlow.setCreaterid(creater);
		requestNodeFlow.setCreatertype(creatertype);
		requestNodeFlow.setIsbill(isbill);
		requestNodeFlow.setBillid(billid);
		requestNodeFlow.setBilltablename(billtablename);
		requestNodeFlow.setRecordSet(RecordSet);
		hasnextnodeoperator = requestNodeFlow.getNextNodeOperator();

		if(hasnextnodeoperator){
			operatorsht = requestNodeFlow.getOperators();
            nextnodeid=requestNodeFlow.getNextNodeid();
            operatorsize = operatorsht.size();
            if(operatorsize > 0){

                TreeMap map = new TreeMap(new ComparatorUtilBean());
				Enumeration tempKeys = operatorsht.keys();
				try{
				while (tempKeys.hasMoreElements()) {
					String tempKey = (String) tempKeys.nextElement();
					ArrayList tempoperators = (ArrayList) operatorsht.get(tempKey);
					map.put(tempKey,tempoperators);
				}
				}catch(Exception e){}
				Iterator iterator = map.keySet().iterator();
				while(iterator.hasNext()) {
				String operatorgroup = (String) iterator.next();
				ArrayList operators = (ArrayList) operatorsht.get(operatorgroup);
				for (int i = 0; i < operators.size(); i++) {
				    String operatorandtype = (String) operators.get(i);
						String[] operatorandtypes = Util.TokenizerString2(operatorandtype, "_");
						String opertor = operatorandtypes[0];
						String opertortype = operatorandtypes[1];
                        intervenoruserids+=opertor+",";
                        if("0".equals(opertortype)){
						intervenorusernames += "<A href='javaScript:openhrm("+opertor+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(opertor)+"</A>&nbsp;";
						}else{
						intervenorusernames += CustomerInfoComInfo.getCustomerInfoname(opertor)+" ";
						}

				}
                }
        }
        }
    if(intervenoruserids.length()>1){
        intervenoruserids=intervenoruserids.substring(0,intervenoruserids.length()-1);
    }
    needcheck+=",Intervenorid";
    if(isremark.equals("5"))  needcheck="";
%>
<iframe id="workflownextoperatorfrm" frameborder=0 scrolling=no src=""  style="display:none;"></iframe>
<%}
%>

<!--TD4262 增加提示信息  开始-->

<%
    if(ismode.equals("1")){
%>

<div id="divFavContent16332" style="display:none"><!--工作流信息保存错误-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(16332,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent16333" style="display:none"><!--工作流下一节点或下一节点操作者错误-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(16333,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>


<div id="divFavContent18978" style="display:none"><!--正在提交流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18979" style="display:none"><!--正在保存流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18980" style="display:none"><!--正在退回流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18984" style="display:none"><!--正在删除流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18984,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
<%
    }else{
%>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%;display:none' valign='top'>
</div>
<%
    }
%>
<!--TD4262 增加提示信息  结束-->
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%;display:none' valign='top'>
</div>
<iframe id="checkReportDataForm" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>
<iframe id="showtipsinfoiframe" name="showtipsinfoiframe" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>
<input type=hidden name="divcontent" value="">
<input type=hidden name="content" value="">
<!--
<table width="100%">
<tr>
<td width="50%"  valign="top">-->
<input type=hidden name="isremark" value="<%=isremark%>">
<!-- added by pony on 2006-05-11 for TD4264 begin -->
<input type=hidden name="requestid" value="<%=requestid%>">
<input type=hidden name="nodeid" value="<%=nodeid%>">
<input type=hidden name="nodetype" value="<%=nodetype%>">
<input type=hidden name="workflowid" value="<%=workflowid%>">
<input type=hidden name="currentdate" value="<%=currentdate%>">
<input type=hidden name="currenttime" value="<%=currenttime%>">
<input type=hidden name="formid" value="<%=formid%>">
<input type=hidden name="isbill" value="<%=isbill%>">
<input type=hidden name="billid" value="<%=billid%>">
<input type=hidden name="creater" value="<%=creater%>">
<input type=hidden name="creatertype" value="<%=creatertype%>">
<input type=hidden name="ismode" value="<%=ismode%>">
<input type=hidden name="workflowRequestLogId" value="-1">
<input type=hidden name="RejectNodes" value="">
<input type=hidden name="RejectToNodeid" value="">
<!-- added end. -->
<%--added by xwj for td 2104 on 2005-08-1 begin--%>
  <table class="viewform">
        <!-- modify by xhheng @20050308 for TD 1692 -->
         <COLGROUP>
         <COL width="20%">
         <COL width="80%">
         <%if(isremark.equals("5")){%>
         <tr><td colspan="2"><b><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%></b></td></tr>
         <TR class=spacing>
            <TD class=line1 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(18914,user.getLanguage())%></td>
             <td class=field>
                 <select class=inputstyle  id="submitNodeId" name=submitNodeId  onChange='nodechange(this.value)'>
                 <%
                 WFNodeMainManager.setWfid(workflowid);
                 WFNodeMainManager.selectWfNode();
                 while(WFNodeMainManager.next()){
                    int tmpid = WFNodeMainManager.getNodeid();
                    if(tmpid==nodeid) continue;
                    String tmpname = WFNodeMainManager.getNodename();
                    String tmptype = WFNodeMainManager.getNodetype();
                 %>
                 <option value="<%=tmpid%>_<%=tmptype%>" <%if(nextnodeid==tmpid){%>selected<%}%>><%=tmpname%></option>
                 <%}%>
                 </select>
             </td>
         </tr>
	<TR class=spacing  style="height:1px;">
            <TD class=line2 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(18915,user.getLanguage())%></td>
             <td class=field>
                 <span id="Intervenorspan">
                     <%if(intervenoruserids.equals("")){%>
                     <button type=button  class=Browser onclick="onShowMutiHrm('Intervenorspan','Intervenorid')" ></button>
                     <%}%><%=intervenorusernames%><%if(intervenorusernames.equals("")){%><img src='/images/BacoError.gif' align=absmiddle><%}%></span>
                 <input type=hidden name="Intervenorid" value="<%=intervenoruserids%>">
             </td>
         </tr>
	<TR class=spacing  style="height:1px;">
            <TD class=line2 colSpan=2></TD>
        </TR>
         <%
         }
         boolean IsBeForwardCanSubmitOpinion="true".equals(session.getAttribute(userid+"_"+requestid+"IsBeForwardCanSubmitOpinion"))?true:false;
         rssign.execute("select isview from workflow_nodeform where fieldid=-4 and nodeid="+nodeid);
		 int isview_ = 0;
		 if(rssign.next()){
			isview_ = Util.getIntValue(rssign.getString("isview"), 0);
		 }
         String isFormSignature=null;
         //html模式下，如果签字意见在模板中显示，此处则不显示
         if(IsBeForwardCanSubmitOpinion && (!"2".equals(ismode) || isview_!=1)){

        int annexmainId=0;
         int annexsubId=0;
         int annexsecId=0;

         if("1".equals(isannexupload_edit) && annexdocCategory_edit!=null && !annexdocCategory_edit.equals("")){
            annexmainId=Util.getIntValue(annexdocCategory_edit.substring(0,annexdocCategory_edit.indexOf(',')));
            annexsubId=Util.getIntValue(annexdocCategory_edit.substring(annexdocCategory_edit.indexOf(',')+1,annexdocCategory_edit.lastIndexOf(',')));
            annexsecId=Util.getIntValue(annexdocCategory_edit.substring(annexdocCategory_edit.lastIndexOf(',')+1));
          }
         int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
         if(annexmaxUploadImageSize<=0){
            annexmaxUploadImageSize = 5;
         }
         char flag1 = Util.getSeparator();
         RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+userid+flag1+""+usertype+flag1+"1");
         String myremark = "" ;
         String annexdocids = "" ;
         String signdocids="";
         String signworkflowids="";
		 int workflowRequestLogId=-1;
         if(RecordSet.next()){
            myremark = Util.null2String(RecordSet.getString("remark"));
            annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
			workflowRequestLogId=Util.getIntValue(RecordSet.getString("requestLogId"),-1);
			signdocids=Util.null2String(RecordSet.getString("signdocids"));
			signworkflowids=Util.null2String(RecordSet.getString("signworkflowids"));
         }
         String signdocname="";
        String signworkflowname="";
        ArrayList templist=Util.TokenizerString(signdocids,",");
        for(int i=0;i<templist.size();i++){
            signdocname+="<a href='/docs/docs/DocDsp.jsp?isrequest=1&id="+templist.get(i)+"' target='_blank'>"+docinf.getDocname((String)templist.get(i))+"</a> ";
        }
        templist=Util.TokenizerString(signworkflowids,",");
        int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
        for(int i=0;i<templist.size();i++){
                tempnum++;
                session.setAttribute("resrequestid" + tempnum, "" + templist.get(i));
            signworkflowname+="<a style=\"cursor:pointer\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+templist.get(i)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
        }
        session.setAttribute("slinkwfnum", "" + tempnum);
        session.setAttribute("haslinkworkflow", "1");


         //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
        //add by cyril on 2008-09-30 for td:9014
   		boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid); 
   		String workflowPhrases[] = new String[RecordSet.getCounts()];
   		String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
   		int x = 0 ;
   		if (isSuccess) {
   			while (RecordSet.next()){
   				workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
   				workflowPhrasesContent[x] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
   				x ++ ;
   			}
   		}
   		//end by cyril on 2008-09-30 for td:9014
         /*----------xwj for td3034 20051118 begin ------*/
         %>
         <tr class="Title">
                  <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
                </tr>
            <tr>
              <td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
              <td style="text-align:right;">

         <%
int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight  from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet.next()){
	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
}
int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
if(isUseWebRevision_t != 1){
	isFormSignature = "";
}
if("1".equals(isFormSignature)){
%>
		<jsp:include page="/workflow/request/WorkflowLoadSignature.jsp">
			<jsp:param name="workflowRequestLogId" value="<%=workflowRequestLogId%>" />
			<jsp:param name="isSignMustInput" value="<%=isSignMustInput%>" />
			<jsp:param name="formSignatureWidth" value="<%=formSignatureWidth%>" />
			<jsp:param name="formSignatureHeight" value="<%=formSignatureHeight%>" />
		</jsp:include>
<%
}else{
         if(workflowPhrases.length>0){
         %>

                <select class=inputstyle  id="phraseselect" name=phraseselect style="width:80%" onChange='onAddPhrase(this.value)' disabled=true onmousewheel="return false;">
                <option value="">－－<%=SystemEnv.getHtmlLabelName(22409,user.getLanguage())%>－－</option>
                <%
                  for (int i= 0 ; i <workflowPhrases.length;i++) {
                    String workflowPhrase = workflowPhrases[i] ;  %>
                    <option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
                <%}%>
                </select>
            <%}%>
				<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>" value="">
              <textarea  class=Inputstyle name=remark id=remark rows=4 cols=40 style="width:80%;display:none" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"   <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%>><%=myremark%></textarea>
	  		  </td>
	  		  <!-- 普通模式处理和HTML模板的处理配合使用 -->
	  		  <td style="text-align:left;">
		  		  <span id="remarkSpan">
					<%
					 if(isSignMustInput.equals("1")&&"".equals(myremark)){
					%>
					   <img src="/images/BacoError.gif" align=absmiddle>
					<%
					  }
					%>
	              </span>
	  		  </td>
	  		  <script defer>
	  		   	function funcremark_log(){
	  		   		CkeditorExt.initEditor('frmmain','remark','<%=user.getLanguage()%>',CkeditorExt.NO_IMAGE,200)
					//FCKEditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
				<%if(isSignMustInput.equals("1")){%>
					CkeditorExt.checkText("remarkSpan","remark");
				<%}%>
					CkeditorExt.toolbarExpand(false,"remark");
				}
				//$(window).bind("load", funcremark_log);
	  		 	if (window.addEventListener){
	        	    window.addEventListener("load", funcremark_log, false);
	        	}else if (window.attachEvent){
	        	    window.attachEvent("onload", funcremark_log);
	        	}else{
	        	    window.onload=funcremark_log;
	        	}
				</script>
<%}%>
</tr>
         <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%if("1".equals(isSignDoc_edit)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids" value="<%=signdocids%>">
                <button type=button  class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"><%=signdocname%></span>
            </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_edit)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids" value="<%=signworkflowids%>">
                <button type=button  class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"><%=signworkflowname%></span>
            </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isannexupload_edit)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
            <td class=field>
          <table cols=3 id="field-annexupload_tab">
          <tbody ><col width="50%" >
            <col width="25%" >
            <col width="25%">
           <%
            int linknum=-1;
            if(!annexdocids.equals("")){
            RecordSet.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+annexdocids+") order by id asc");
            while(RecordSet.next()){
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);
              String SecCategory=Util.null2String(RecordSet.getString(4));
              DocImageManager.resetParameter();
              DocImageManager.setDocid(Util.getIntValue(showid));
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
              boolean nodownload=SecCategoryComInfo1.getNoDownload(SecCategory).equals("1")?true:false;
              String imgSrc= AttachFileUtil.getImgStrbyExtendName(fileExtendName,16);
              %>

          <tr>
            <input type=hidden name="field-annexupload_del_<%=linknum%>" value="0" >
            <td >
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp
              <%}%>
              <input type=hidden name="field-annexupload_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td >
                <button type=button  class=btnFlow accessKey=1  onclick='onChangeSharetype("span-annexupload_id_<%=linknum%>","field-annexupload_del_<%=linknum%>","0",oUploadannexupload)'><u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
                </button><span id="span-annexupload_id_<%=linknum%>" name="span-annexupload_id_<%=linknum%>" style="visibility:hidden">
                    <b><font COLOR="#FF0033">√</font></b>
                  <span>
            </td>
            <%if(accessoryCount==1){%>
            <td >
              <span id = "selectDownload">
                  <%if((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload){%>
                  <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
                  </button>
                 <%}%>
              </span>
            </td>
            <%}%>
          </tr>
              <%}}%>
            <input type=hidden name="field-annexupload_idnum" value=<%=linknum+1%>>
            <input type=hidden name="field-annexupload_idnum_1" value=<%=linknum+1%>>
          <tr>
            <td colspan=3>
            <%if(annexsecId<1){%>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(21418,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}else{%>
              <script>
          var oUploadannexupload;
          function fileuploadannexupload() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId":"<%=annexmainId%>",
                "subId":"<%=annexsubId%>",
                "secId":"<%=annexsecId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>"
            },
            file_size_limit :"<%=annexmaxUploadImageSize%> MB",
            file_types : "*.*",
            file_types_description : "All Files",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgressannexupload",
                cancelButtonId : "btnCancelannexupload",
                uploadfiedid:"field-annexupload"
            },
            debug: false,


            // Button settings

            button_image_url : "/js/swfupload/add.png",    // Relative to the SWF file
            button_placeholder_id : "spanButtonPlaceHolderannexupload",

            button_width: 100,
            button_height: 18,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
            button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 0,
            button_text_left_padding: 18,

            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            // The event handler functions are defined in handlers.js
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_2,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };


        try {
            oUploadannexupload=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileuploadannexupload);
        	
        	if (window.addEventListener){
        	    window.addEventListener("load", fileuploadannexupload, false);
        	}else if (window.attachEvent){
        	    window.attachEvent("onload", fileuploadannexupload);
        	}else{
        	    window.onload=fileuploadannexupload;
        	}
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolderannexupload"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:pointer;TEXT-DECORATION:none" disabled onclick="oUploadannexupload.cancelQueue();" id="btnCancelannexupload">
									<span><img src="/js/swfupload/delete.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span>(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="field-annexuploadspan"></span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 id="field-annexupload" name="field-annexupload" value="<%=annexdocids%>">
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgressannexupload">
                  </div>
                  <div id="divStatusannexupload"></div>
              </td>
          </tr>
      </TABLE>
           <%}%>
           <input type=hidden name='annexmainId' value=<%=annexmainId%>>
          <input type=hidden name='annexsubId' value=<%=annexsubId%>>
          <input type=hidden name='annexsecId' value=<%=annexsecId%>>
            </td>
          </tr>
          </tbody>
          </table>
          </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}
}%>
        </table>
<%
if(showDocTab_edit.equals("1")||showUploadTab_edit.equals("1")||showWorkflowTab_edit.equals("1")){
%>
<table style="width:100%;height:100%" border=0 cellspacing=0 cellpadding=0  scrolling=no>
	  <colgroup>
		<col width="79">
        <%if(showDocTab_edit.equals("1")){%><col width="79"><%}%>
        <%if(showWorkflowTab_edit.equals("1")){%><col width="79"><%}%>
		<%if(showUploadTab_edit.equals("1")){%><col width="79"><%}%>
		<col width="*">
		</colgroup>
  <TBODY>
	  <tr align=left height="20">
	  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2.png" width=79px  align=center onmouseover="style.cursor='hand'" style="font-weight:bold;"  onclick="signtabchange(0)">
	  <%=SystemEnv.getHtmlLabelName(1380,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
	  <%if(showDocTab_edit.equals("1")){%><td nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'"  onclick='signtabchange(1)'>
	  <%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td><%}%>
      <%if(showWorkflowTab_edit.equals("1")){%><td nowrap name="oTDtype_2"  id="oTDtype_2" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'"  onclick="signtabchange(2)">
	  <%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td><%}%>
	  <%if(showUploadTab_edit.equals("1")){%><td nowrap name="oTDtype_3"  id="oTDtype_3" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'"  onclick='signtabchange(3)'>
	  <%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td><%}%>
      <td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	  </tr>
  </TBODY>
</table>
<%if(showDocTab_edit.equals("1")){%>
<div id="SignTabDoc" style="display:none">
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="20%"><col width="60%"> <col width="20%">
          <tbody>
          <tr class=HeaderForWF>
            <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></th>
          </tr>
          <tr>
              <td colspan="3"><img src="/images/loadingext.gif" alt=""/><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></td>
          </tr>
        </tbody>
    </table>
</div>
<%}%>
<%if(showWorkflowTab_edit.equals("1")){%>
<div id="SignTabWF" style="display:none">
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="10%"><col width="15%"> <col width="20%"><col width="40%"> <col width="15%">
          <tbody>
          <tr class=HeaderForWF>
            <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(23753,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1335,user.getLanguage())%></th>  
          </tr>
          <tr>
              <td colspan="5"><img src="/images/loadingext.gif" alt=""/><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></td>
          </tr>
        </tbody>
    </table>
</div>
<%}%>
<%if(showUploadTab_edit.equals("1")){%>
<div id="SignTabUpload" style="display:none">
    <table class=liststyle cellspacing=1  >
          <tbody>
          <tr class=HeaderForWF>
            <th><%=SystemEnv.getHtmlLabelName(23752,user.getLanguage())%></th>
          </tr>
          <tr>
              <td><img src="/images/loadingext.gif" alt=""/><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></td>
          </tr>
        </tbody>
    </table>
</div>
<%
    }
%>
<script type="text/javascript">
var tabwfload=1;
var tabdocload=1;
var tabupload=1;
function signtabchange(tabindex){
    if(tabindex==0){
        jQuery($GetEle("signid")).css("display", "");
        jQuery($GetEle("oTDtype_0")).css("font-weight", "bold");
        jQuery($GetEle("oTDtype_0")).css("background", "url(/images/tab.active2.png) no-repeat");
        <%if(showDocTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabDoc")).css("display", "none");
        jQuery($GetEle("oTDtype_1")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_1")).css("background", "url(/images/tab2.png) no-repeat");
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabWF")).css("display", "none");
        jQuery($GetEle("oTDtype_2")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_2")).css("background", "url(/images/tab2.png) no-repeat");
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabUpload")).css("display", "none");
        jQuery($GetEle("oTDtype_3")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_3")).css("background", "url(/images/tab2.png) no-repeat");
        <%}%>
    }else if(tabindex==1){
        jQuery($GetEle("signid")).css("display", "none");
        jQuery($GetEle("oTDtype_0")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_0")).css("background", "url(/images/tab2.png) no-repeat");
        <%if(showDocTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabDoc")).css("display", "");
        jQuery($GetEle("oTDtype_1")).css("font-weight", "bold");
        jQuery($GetEle("oTDtype_1")).css("background", "url(/images/tab.active2.png) no-repeat");
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabWF")).css("display", "none");
        jQuery($GetEle("oTDtype_2")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_2")).css("background", "url(/images/tab2.png) no-repeat");
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabUpload")).css("display", "none");
        jQuery($GetEle("oTDtype_3")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_3")).css("background", "url(/images/tab2.png) no-repeat");
        <%}%>
        if(tabdocload==1){
            loadsigndoc(<%=initrequestid%>,<%=workflowid%>,<%=user.getUID()%>,<%=user.getLanguage()%>);
        }
    }else if(tabindex==2){
        jQuery($GetEle("signid")).css("display", "none");
        jQuery($GetEle("oTDtype_0")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_0")).css("background", "url(/images/tab2.png) no-repeat");
        <%if(showDocTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabDoc")).css("display", "none");
        jQuery($GetEle("oTDtype_1")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_1")).css("background", "url(/images/tab2.png) no-repeat");
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabWF")).css("display", "");
        jQuery($GetEle("oTDtype_2")).css("font-weight", "bold");
        jQuery($GetEle("oTDtype_2")).css("background", "url(/images/tab.active2.png) no-repeat");
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabUpload")).css("display", "none");
        jQuery($GetEle("oTDtype_3")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_3")).css("background", "url(/images/tab2.png) no-repeat");
        <%}%>
        if(tabwfload==1){
            loadsignwf(<%=initrequestid%>,<%=workflowid%>,<%=user.getUID()%>,<%=user.getLanguage()%>);
        }
    }else if(tabindex==3){
        jQuery($GetEle("signid")).css("display", "none");
        jQuery($GetEle("oTDtype_0")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_0")).css("background", "url(/images/tab2.png) no-repeat");
        <%if(showDocTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabDoc")).css("display", "none");
        jQuery($GetEle("oTDtype_1")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_1")).css("background", "url(/images/tab2.png) no-repeat");
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabWF")).css("display", "none");
        jQuery($GetEle("oTDtype_2")).css("font-weight", "normal");
        jQuery($GetEle("oTDtype_2")).css("background", "url(/images/tab2.png) no-repeat");
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        jQuery($GetEle("SignTabUpload")).css("display", "");
        jQuery($GetEle("oTDtype_3")).css("font-weight", "bold");
        jQuery($GetEle("oTDtype_3")).css("background", "url(/images/tab.active2.png) no-repeat");
        <%}%>
        if(tabupload==1){
            loadsignupload(<%=initrequestid%>,<%=workflowid%>,<%=user.getUID()%>,<%=user.getLanguage()%>);
        }
    }
}
function loadsigndoc(requestid,workflowid,userid,languageid){
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSignDocAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid;
    ajax.send(parpstr);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                $GetEle("SignTabDoc").innerHTML=ajax.responseText;
                tabdocload=0;
            }catch(e){}
        }
    }
}
function loadsignwf(requestid,workflowid,userid,languageid){
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSignWFAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid;
    ajax.send(parpstr);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                $GetEle("SignTabWF").innerHTML=ajax.responseText;
                tabwfload=0;
            }catch(e){}
        }
    }
}
function loadsignupload(requestid,workflowid,userid,languageid){
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSignUploadAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid;
    ajax.send(parpstr);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                $GetEle("SignTabUpload").innerHTML=ajax.responseText;
                tabupload=0;
            }catch(e){}
        }
    }
}
</script>
<%
}
%>
<!--以下删除签字意见字段 by ben 2007-3-16-->

<%
    boolean hasUseTempletSucceed=false;
    boolean isUseTempletNode=false;
    boolean hasSignatureSucceed=false;
    if("1".equals(fromFlowDoc)||"1".equals(isworkflowdoc)){
    	hasUseTempletSucceed=RequestUseTempletManager.ifHasUseTempletSucceed(requestid);
    	isUseTempletNode=RequestUseTempletManager.ifIsUseTempletNode(requestid,user.getUID(),user.getLogintype());
    	hasSignatureSucceed=RequestSignatureManager.ifHasSignatureSucceed(requestid,nodeid,user.getUID(),Util.getIntValue(user.getLogintype(),1));
    }
    %>
<input type="hidden" name="temphasUseTempletSucceed" id="temphasUseTempletSucceed" value="<%=hasUseTempletSucceed%>"/>
<input type="hidden" name="isUseTempletNode" id="isUseTempletNode" value="<%=isUseTempletNode%>"/>
<div id="signid">
        <table class=liststyle cellspacing=1 style="margin:0;padding:0;" id="mainWFHead">
          <colgroup>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
          <tbody>
          <tr class=HeaderForWF id="headTitle">
            <th><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></th>
          </tr>
		           <%
boolean isLight = false;
int nLogCount=0;
//String tempIsFormSignature=null;
int tempRequestLogId=0;
int tempImageFileId=0;
/*--  xwj for td2104 on 20050802 B E G I N --*/
String viewLogIds = "";
ArrayList canViewIds = new ArrayList();
String viewNodeId = "-1";
String tempNodeId = "-1";
String singleViewLogIds = "-1";
char procflag=Util.getSeparator();
//RecordSetLog.executeSql("select distinct nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+user.getUID());
if(nodeid>0){
viewNodeId = ""+nodeid;
RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
if(RecordSetLog1.next()){
singleViewLogIds = RecordSetLog1.getString("viewnodeids");
}

if("-1".equals(singleViewLogIds)){//全部查看
RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
while(RecordSetLog2.next()){
tempNodeId = RecordSetLog2.getString("nodeid");
if(!canViewIds.contains(tempNodeId)){
canViewIds.add(tempNodeId);
}
}
}
else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看

}
else{//查看部分
String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
for(int i=0;i<tempidstrs.length;i++){
if(!canViewIds.contains(tempidstrs[i])){
canViewIds.add(tempidstrs[i]);
}
}
}
}
if(canViewIds.size()>0){
for(int a=0;a<canViewIds.size();a++)
{
viewLogIds += (String)canViewIds.get(a) + ",";
}
viewLogIds = viewLogIds.substring(0,viewLogIds.length()-1);
}
else{
viewLogIds = "-1";
}
String sqlTemp = "select nodeid from workflow_flownode where workflowid = "+workflowid+" and nodetype = '0'";
RecordSet.executeSql(sqlTemp);
RecordSet.next();
String creatorNodeId = RecordSet.getString("nodeid");
/*----added by xwj for td2891 end-----*/
/*----added by chujun for td8883 start ----*/
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String orderbytype = Util.null2String(WFManager.getOrderbytype());
String orderby = "desc";
String imgline="<img src=\"/images/xp/L.png\">";
if("2".equals(orderbytype)){
	orderby = "asc";
    imgline="<img src=\"/images/xp/L1.png\">";
}
WFLinkInfo.setRequest(request);
ArrayList log_loglist=new ArrayList();


String lineNTdOne="";
String lineNTdTwo="";
int log_branchenodeid=0;
String log_tempvalue="";
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
	nLogCount++;
	lineNTdOne="line"+String.valueOf(nLogCount)+"TdOne";

	tempImageFileId=0;
	if(tempRequestLogId>0){
		RecordSetlog3.executeSql("select imageFileId from Workflow_FormSignRemark where requestLogId="+tempRequestLogId);
		if(RecordSetlog3.next()){
			tempImageFileId=Util.getIntValue(RecordSetlog3.getString("imageFileId"),0);
		}
	}
    if(log_isbranche==0&&"2".equals(orderbytype)) isLight = !isLight;
if (nLogCount==3) {
%>
<!-- LL for QC46505 2012/09/06  -->
<!-- 
</tbody></table>




<div  id=WorkFlowDiv style="display:''"><%--xwj for td2104 on 2005-05-18--%>
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    <tbody>
     -->
<%}%>
    <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark <%}%>>
            <td><%=log_nodeimg%><%=Util.toScreen(log_nodename,user.getLanguage())%></td>
              <td width=50%>
				<table width=100%>

		  <tr>
            <td colspan="3">
            	<%if(!log_logtype.equals("t")){%>

<%if(tempRequestLogId>0&&tempImageFileId>0){%>
		<jsp:include page="/workflow/request/WorkflowLoadSignatureRequestLogId.jsp">
			<jsp:param name="tempRequestLogId" value="<%=tempRequestLogId%>" />
		</jsp:include>
<%}else{
	String tempremark = log_remark;
	tempremark = Util.StringReplace(tempremark,"&lt;br&gt;","<br>");
	%>
             <%=Util.StringReplace(tempremark,"&nbsp;"," ")%>
<%}%>
              <%}
            if(!log_annexdocids.equals("")||!log_signdocids.equals("")||!log_signworkflowids.equals("")){
                if(!log_logtype.equals("t")&&tempRequestLogId>0&&tempImageFileId>0){
             %>
                 </td></tr>
              <tr><td colspan="3">
                  <%}%>
           <br/>
          <table width="70%">
                 <tr height="1"><td><td style="border:1px dotted #000000;border-top-color:#ffffff;border-left-color:#ffffff;border-right-color:#ffffff;height:1px">&nbsp;</td></tr>
             </table>
          <table>
          <tbody >
           <%
            String signhead="";
            if(!log_signdocids.equals("")){
            RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_signdocids+") order by id asc");
            int linknum=-1;
            while(RecordSetlog3.next()){
              linknum++;
              if(linknum==0){
                  signhead=SystemEnv.getHtmlLabelName(857,user.getLanguage())+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),user.getLanguage()) ;
              %>
          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td >
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp
            </td>
          </tr>
              <%}
              }
            ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
            int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
            for(int k=0;k<tempwflists.size();k++){
              if(k==0){
                  signhead=SystemEnv.getHtmlLabelName(1044,user.getLanguage())+":";
              }else{
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
                  signhead=SystemEnv.getHtmlLabelName(22194,user.getLanguage())+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),user.getLanguage()) ;
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
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp
              <%}
                  if(accessoryCount==1 &&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){
              %>
              <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>'">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	(<%=docImagefileSize/1000%>K)
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

              <tr>
              <td>&nbsp;</td>
            <td align=right>
               <%-- xwj for td2104 on 20050802 begin--%>
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
                if(!userimg.equals("") && "0".equals(log_operatortype)){
			%>
			<img id=markImg src="<%=userimg%>" ></img>
			<%
			}
			else
			 {
                if(isOldWf_)
            {
               if(log_operatortype.equals("0")){%>
			   <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
	            <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>

              <%}else if(log_operatortype.equals("1")){%>

	           <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%></a>
              <%}else{%>
             <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
             <%}
           }
            else
            {
                  if(log_operatortype.equals("0"))
            {    if(!log_agenttype.equals("2")){%>
			<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
	               <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                 /*----------added by xwj for td2891 begin----------- */
                else if(log_agenttype.equals("2")){

                   if(!(""+log_nodeid).equals(creatorNodeId) || ((""+log_nodeid).equals(creatorNodeId) && !WFLinkInfo.isCreateOpt(tempRequestLogId,requestid))){//非创建节点log,必须体现代理关系%>
<%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%></a>
                    ->
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%></a>

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
                  if(!RecordSetlog3.next()){%>
				  <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                      <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                  else{
                  String isCreator = RecordSetlog3.getString("isCreateAgenter");

                  if(!isCreator.equals("1")){%>
<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
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
                   boolean haswfcreate = new weaver.share.ShareManager().hasWfCreatePermission(user, workflowid);
                   
                   if(haswfcreate){%>
				   <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                   <%}
                  else{%>
				  <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%></a>
                    ->
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%></a>

                  <%}
                  }

                  }
                }
                }
                /*----------added by xwj for td2891 end----------- */
            }
                else if(log_operatortype.equals("1")){%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%></a>
<%}else{%>
<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
<%}

            }
            }%>


        <%-- xwj for td2104 on 20050802 end--%>

            </td>
            </tr>
            <tr>
             <td>&nbsp;</td>
            <td align=right><%=Util.toScreen(log_operatedate,user.getLanguage())%>
              &nbsp<%=Util.toScreen(log_operatetime,user.getLanguage())%></td>
                  </tr>
            </table>
<!--xwj for td2104 20050825-->
            <td>
              <%
	String logtype = log_logtype;
	String operationname = RequestLogOperateName.getOperateName(""+workflowid,""+requestid,""+log_nodeid,logtype,log_operator,user.getLanguage(),log_operatedate,log_operatetime);
	%>
	<%=operationname%>
<%
lineNTdTwo="line"+String.valueOf(nLogCount)+"TdTwo"+Util.getRandom();
%>
            </td>

                  <%--added by xwj for td2104 on 2005-8-1--%>
          <td id="<%=lineNTdTwo%>">
              <%
                String tempStr ="";
                if(log_receivedPersons.length()>0) tempStr = Util.toScreen(log_receivedPersons.substring(0,log_receivedPersons.length()-1),user.getLanguage());

				String showoperators="";
				try
				{
				showoperators=RequestDefaultComInfo.getShowoperator(""+userid);
				}
				catch (Exception eshows)
				{}
                if (!showoperators.equals("1")) {
                if(!"".equals(tempStr) && tempStr != null){
                	tempStr = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick=showallreceivedforsign('"+requestid+"','"+log_nodeid+"','"+log_operator+"','"+log_operatedate+
                                "','"+log_operatetime+"','"+lineNTdTwo+"','"+logtype+"',"+log_destnodeid+") >"+SystemEnv.getHtmlLabelName(89, user.getLanguage())+"</span>";
                }
				}
              %>
              <%=tempStr%>
          </td>


          </tr>

        <%-- 该段代码已被屏蔽，现删除 --%>


          <%
	if(log_isbranche==0&&!"2".equals(orderbytype)) isLight = !isLight;
}
%>

</tbody>
	</table>
<div style="width:100%;margin:0;padding:0;" id="requestlogappednDiv">
</div>
<div id='WorkFlowLoddingDiv_<%=requestid %>' style="display:none;text-align:center;width:100%;height:18px;overflow:hidden;">
	<img src="/images/loading2.gif" style="vertical-align: middle;">&nbsp;<span style="vertical-align: middle;line-height:100%;"><%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%></span>
</div>
<%
//-----------------------------------
// 预留流程签字意见每次加载条数 START
//-----------------------------------
int wfsignlddtcnt = 14;
//-----------------------------------
// 预留流程签字意见每次加载条数 END
//-----------------------------------
%>
<input type="hidden" id="requestLogDataIsEnd<%=requestid %>" value="0">
<input type="hidden" id="requestLogDataMaxRquestLogId" value="0">

<script language="javascript">
	var pgnumber = 2;
	var sucNm = true;
	var currentPageCnt = <%=wfsignlddtcnt%>;
	var requestLogDataMaxRquestLogId = "0";
	
	function primaryWfLogLoadding() {
		if (pgnumber != -1 && sucNm && jQuery("#requestLogDataIsEnd<%=requestid %>").val() != "1" && currentPageCnt >= <%=wfsignlddtcnt%>) {
			sucNm = false;
			showAllSignLog2('<%=workflowid %>','<%=requestid %>','<%=viewLogIds %>','<%=orderby %>', pgnumber, "signTbl", "requestLogDataIsEnd<%=requestid %>", "WorkFlowLoddingDiv_<%=requestid %>", requestLogDataMaxRquestLogId);
			
			if (jQuery("#requestLogDataIsEnd<%=requestid %>").val() != "1") {
				pgnumber++;
			} else {
				sucNm = false
				pgnumber = -1;
			}
		}
	}
</script>

<%

  for(int i=0;i<allrequestid.size();i++)
  {
        int languageidfromrequest = user.getLanguage();
        String temp = allrequestid.get(i).toString();
        int tempindex = temp.indexOf(".");
        requestid = Util.getIntValue(temp.substring(0,tempindex),0);
        temp = temp.substring(tempindex);
        String workflow_name = "";
        if(temp.equals(".main")){
            workflow_name = SystemEnv.getHtmlLabelName(21254,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString();
            workflow_name +=" "+SystemEnv.getHtmlLabelName(504,languageidfromrequest)+":";
        }else if(temp.equals(".sub")){
        	workflow_name = SystemEnv.getHtmlLabelName(19344,languageidfromrequest);
        	workflow_name +=" "+allrequestname.get(i).toString();
            workflow_name +=" "+SystemEnv.getHtmlLabelName(504,languageidfromrequest)+":";
            workflow_name +=" "+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&isovertime=0')>"+SystemEnv.getHtmlLabelName(367,languageidfromrequest)+SystemEnv.getHtmlLabelName(19344,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString()+"</a>";
        }else if(temp.equals(".parallel")){
        	workflow_name = SystemEnv.getHtmlLabelName(21255,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString();
            workflow_name +=" "+SystemEnv.getHtmlLabelName(504,languageidfromrequest)+":";
            workflow_name +=" "+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&isovertime=0')>"+SystemEnv.getHtmlLabelName(367,languageidfromrequest)+SystemEnv.getHtmlLabelName(21255,languageidfromrequest);
            workflow_name +=" "+allrequestname.get(i).toString()+"</a>";
        }

        viewLogIds = "";
        rssign.executeSql("select nodeid from workflow_requestlog where requestid = "+requestid);
        while(rssign.next()){
          viewLogIds += rssign.getString("nodeid")+",";
        }
        viewLogIds +="-1";
        int tempworkflowid=0;
        rssign.executeSql("select * from workflow_requestbase where requestid = "+ requestid);
        if(rssign.next()){
             tempworkflowid = rssign.getInt("workflowid");
          }
        log_loglist=WFLinkInfo.getRequestLog(requestid,tempworkflowid,viewLogIds,orderby);
%>
<div id=WorkFlowDiv style="display:''">
    <table class=liststyle cellspacing=1  >
    	<colgroup>
        <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    	<tbody id="WorkFlowDiv_TBL">
          <tr class="header">
             <th colspan = 4><%=workflow_name%></th>
   		    </tr>
          <tr class=Header>
            <th><%=SystemEnv.getHtmlLabelName(15586,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(504,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(104,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(15525,languageidfromrequest)%></th>
          </tr>

<%
for(int j=0;j<log_loglist.size();j++)
{
    Hashtable htlog=(Hashtable)log_loglist.get(j);
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
    String log_nodeimg="";
    if(log_tempvalue.equals(log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime)){
        log_branchenodeid=0;
    }else{
        log_tempvalue=log_operator+"_"+log_operatortype+"_"+log_operatedate+"_"+log_operatetime;
    }
    if(log_nodeattribute==1&&(log_logtype.equals("0")||log_logtype.equals("2"))&&log_branchenodeid==0){
        log_branchenodeid=log_nodeid;
        log_nodeimg=imgline;
    }
    if(log_isbranche==1){
        log_nodeimg="<img src=\"/images/xp/T.png\">";
        log_branchenodeid=0;
    }
	nLogCount++;

	lineNTdOne="line"+String.valueOf(nLogCount)+"TdOne";

	tempImageFileId=0;
	if(tempRequestLogId>0){
		RecordSetlog3.executeSql("select imageFileId from Workflow_FormSignRemark where requestLogId="+tempRequestLogId);
		if(RecordSetlog3.next()){
			tempImageFileId=Util.getIntValue(RecordSetlog3.getString("imageFileId"),0);
		}
	}
    if(log_isbranche==0&&"2".equals(orderbytype)) isLight = !isLight;
if (nLogCount==3) {
%>
<!-- LL for QC46505 2012/09/06 -->
<!-- </tbody></table>




<div  id=WorkFlowDiv style="display:''"><%--xwj for td2104 on 2005-05-18--%>
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    <tbody> -->
<%}%>
    <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark <%}%>>
            <td><%=log_nodeimg%><%=Util.toScreen(log_nodename,languageidfromrequest)%></td>
              <td width=50%>
				<table width=100%>

		  <tr>
            <td colspan="3">
            	<%if(!log_logtype.equals("t")){%>

<%if(tempRequestLogId>0&&tempImageFileId>0){%>
		<jsp:include page="/workflow/request/WorkflowLoadSignatureRequestLogId.jsp">
			<jsp:param name="tempRequestLogId" value="<%=tempRequestLogId%>" />
		</jsp:include>
<%}else{
	String tempremark = log_remark;
	tempremark = Util.StringReplace(tempremark,"&lt;br&gt;","<br>");
	%>
             <%=Util.StringReplace(tempremark,"&nbsp;"," ")%>
<%}%>
            	<%}%>
             <%
            if(!log_annexdocids.equals("")||!log_signdocids.equals("")||!log_signworkflowids.equals("")){
            if(!log_logtype.equals("t")&&tempRequestLogId>0&&tempImageFileId>0){
             %>
                 </td></tr>
              <tr><td colspan="3">
                  <%}%>
                  <br/>
             <table width="70%">
                 <tr height="1"><td><td style="border:1px dotted #000000;border-top-color:#ffffff;border-left-color:#ffffff;border-right-color:#ffffff;height:1px">&nbsp;</td></tr>
             </table>
             <table>
          <tbody >
           <%
            String signhead="";
            if(!log_signdocids.equals("")){
            RecordSetlog3.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("+log_signdocids+") order by id asc");
            int linknum=-1;
            while(RecordSetlog3.next()){
              linknum++;
              if(linknum==0){
                  signhead=SystemEnv.getHtmlLabelName(857,user.getLanguage())+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),user.getLanguage()) ;
              %>

          <tr>
            <td style="PADDING-left:10px"><nobr><%=signhead%></td>
            <td >
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp
            </td>
          </tr><%}
           }
            ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
            int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
            for(int k=0;k<tempwflists.size();k++){
              if(k==0){
                  signhead=SystemEnv.getHtmlLabelName(1044,user.getLanguage())+":";
              }else{
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
                  signhead=SystemEnv.getHtmlLabelName(22194,user.getLanguage())+":";
              }else{
                  signhead="&nbsp;";
              }
              String showid = Util.null2String(RecordSetlog3.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSetlog3.getString(2),user.getLanguage()) ;
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
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp
              <%}
              if(accessoryCount==1 && ((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){
              %>
              <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>'">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	(<%=docImagefileSize/1000%>K)
                  </BUTTON>
              <%}%>
            </td>
          </tr><%}}%>
          </tbody>
          </table><%}%>
             </td>
             </tr>

              <tr>
              <td>&nbsp;</td>
            <td align=right>
               <%-- xwj for td2104 on 20050802 begin--%>
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
                if(!userimg.equals("") && "0".equals(log_operatortype)){
			%>
			<img id=markImg src="<%=userimg%>" ></img>
			<%
			}
			else
			 {
                if(isOldWf_)
            {
               if(log_operatortype.equals("0")){%>
			   <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
	            <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);">
              <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>

              <%}else if(log_operatortype.equals("1")){%>
	           <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%></a>
              <%}else{%>
             <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
             <%}
           }
            else
            {
                  if(log_operatortype.equals("0"))
            {    if(!log_agenttype.equals("2")){%>
			<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
	               <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                 /*----------added by xwj for td2891 begin----------- */
                else if(log_agenttype.equals("2")){

                   if(!(""+log_nodeid).equals(creatorNodeId) || ((""+log_nodeid).equals(creatorNodeId) && !WFLinkInfo.isCreateOpt(tempRequestLogId,requestid))){//非创建节点log,必须体现代理关系%>
<%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%></a>
                    ->
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%></a>

                   <%}
                   else{//创造节点log, 如果设置代理时选中了代理流程创建,同时代理人本身对该流程就具有创建权限,那么该代理人创建节点的log不体现代理关系
                   String agentCheckSql = " select * from workflow_Agent where workflowId="+ tempworkflowid +" and beagenterId=" + log_agentorbyagentid +
													 " and agenttype = '1' " +
													 " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
													 " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
													 " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
													 " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
													 " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
													 " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)";
                  RecordSetlog3.executeSql(agentCheckSql);
                  if(!RecordSetlog3.next()){%>
				  <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                      <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                  <%}
                  else{
                  String isCreator = RecordSetlog3.getString("isCreateAgenter");

                  if(!isCreator.equals("1")){%>
<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>

                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
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
                   boolean haswfcreate = new weaver.share.ShareManager().hasWfCreatePermission(user, workflowid);
                   
                   if(haswfcreate){%>
                   <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())%></a>
                   <%}
                  else{%>
				  <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),user.getLanguage())%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),user.getLanguage())+SystemEnv.getHtmlLabelName(24214,user.getLanguage())%></a>
                    ->
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,user.getLanguage())%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),user.getLanguage())%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick="pointerXY(event);"><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),user.getLanguage())+SystemEnv.getHtmlLabelName(24213,user.getLanguage())%></a>

                  <%}
                  }

                  }
                }
                }
                /*----------added by xwj for td2891 end----------- */
            }
                else if(log_operatortype.equals("1")){%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),user.getLanguage())%></a>
<%}else{%>
<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
<%}

            }}%>


        <%-- xwj for td2104 on 20050802 end--%>

            </td>
            </tr>
            <tr>
             <td>&nbsp;</td>
            <td align=right><%=Util.toScreen(log_operatedate,user.getLanguage())%>
              &nbsp<%=Util.toScreen(log_operatetime,user.getLanguage())%></td>
                  </tr>
            </table>
<!--xwj for td2104 20050825-->
            <td>
              <%
	String logtype = log_logtype;
	String operationname = RequestLogOperateName.getOperateName(""+tempworkflowid,""+requestid,""+log_nodeid,logtype,log_operator,user.getLanguage(),log_operatedate,log_operatetime);
	%>
	<%=operationname%>
<%
lineNTdTwo="line"+String.valueOf(nLogCount)+"TdTwo"+Util.getRandom();
%>
            </td>

                  <%--added by xwj for td2104 on 2005-8-1--%>
          <td id="<%=lineNTdTwo%>">
              <%
                String tempStr ="";
                if(log_receivedPersons.length()>0) tempStr = Util.toScreen(log_receivedPersons.substring(0,log_receivedPersons.length()-1),user.getLanguage());
				String showoperator="";
				try
				{
				showoperator=RequestDefaultComInfo.getShowoperator(""+userid);
				}
				catch (Exception eshow)
				{}
                if (!showoperator.equals("1")) {
                if(!"".equals(tempStr) && tempStr != null){
                	tempStr = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick=showallreceivedforsign('"+requestid+"','"+log_nodeid+"','"+log_operator+"','"+log_operatedate+
                                "','"+log_operatetime+"','"+lineNTdTwo+"','"+logtype+"',"+log_destnodeid+") >"+SystemEnv.getHtmlLabelName(89, user.getLanguage())+"</span>";
                }
				}
              %>
              <%=tempStr%>
          </td>


          </tr>

        <%-- 该段代码已被屏蔽，现删除 --%>


          <%
	if(log_isbranche==0&&!"2".equals(orderbytype)) isLight = !isLight;
}}requestid = initrequestid;
%>


</tbody></table>
</div>

  <script language="javascript">

<%
    if(ismode.equals("1")){
%>
//TD4262 增加提示信息  开始
var oPopup;
try{
    oPopup = window.createPopup();
}catch(e){}
//TD4262 增加提示信息  结束

<%
    }
%>

    function doRemark_n(obj)
    <!-- 点击被转发的提交按钮,点击抄送的人员提交 -->
	
    {
enableAllmenu();
var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
					displayAllmenu();	
			    }
		    }
<%
		}
	}
%>
if(ischeckok=="true"){	
	if ("<%=needconfirm%>"=="1")
	{
    if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>")){
		displayAllmenu();
        return; 
	}
	}
	
        try
        {
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoRemark").click();
        }
        catch(e)
        {                
			if(checktimeok()) 
			{
		        $GetEle("frmmain").isremark.value='<%=isremark%>';
		        $GetEle("frmmain").src.value='save';
		                        
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

//保存签章数据
<%if("1".equals(isFormSignature)){%>
	                    if(SaveSignature()){

            //TD4262 增加提示信息  开始
			<%
			    if(ismode.equals("1")){
			%>
	            
                            contentBox = $GetEle("divFavContent18978");
                            showObjectPopup(contentBox)
			<%
			    
			    }else{
			%>
		       
                            var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
                            showPrompt(content);
			        
			<%
			    }
			%>
                            //TD4262 增加提示信息  结束
                             $GetEle("frmmain").action="RequestRemarkOperation.jsp";
                            //附件上传
                            StartUploadAll();
                            checkuploadcomplet();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							displayAllmenu();
							return ;
						}
<%}else{%>

            //TD4262 增加提示信息  开始
			<%
			    if(ismode.equals("1")){
			%>
	            
                        contentBox = $GetEle("divFavContent18978");
                        showObjectPopup(contentBox)
			<%
			    
			    }else{
			%>
		       
                        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
                        showPrompt(content);
			        
			<%
			    }
			%>
                        //TD4262 增加提示信息  结束
                        $GetEle("frmmain").action="RequestRemarkOperation.jsp";
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
            }else{
	            displayAllmenu();
                return; 
            }
        }
}
displayAllmenu();
	}
	function checkNodesNum()
	{
		var nodenum = 0;
		try
		{
		<%
		int checkdetailno = 0;
		//
		if(isbill>0)
		{
			if(formid==7||formid==156 || formid==157 || formid==158)
			{
				%>
			   	var rowneed = $GetEle('rowneed').value;
			   	var nodesnum = $GetEle('nodesnum').value;
			   	nodesnum = nodesnum*1;
			   	if(rowneed=="1")
			   	{
			   		if(nodesnum>0)
			   		{
			   			nodenum = 0;
			   		}
			   		else
			   		{
			   			nodenum = 1;
			   		}
			   	}
			   	else
			   	{
			   		nodenum = 0;
			   	}
			   	<%
			}
			else
			{
			    //单据
			    RecordSet.execute("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
			    //System.out.println("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
			    while(RecordSet.next())
			    {
	   	%>
	   	var rowneed = $GetEle('rowneed<%=checkdetailno%>').value;
	   	var nodesnum = $GetEle('nodesnum<%=checkdetailno%>').value;
	   	nodesnum = nodesnum*1;
	   	if(rowneed=="1")
	   	{
	   		if(nodesnum>0)
	   		{
	   			nodenum = 0;
	   		}
	   		else
	   		{
	   			nodenum = '<%=checkdetailno+1%>';
	   		}
	   	}
	   	else
	   	{
	   		nodenum = 0;
	   	}
	   	if(nodenum>0)
	   	{
	   		return nodenum;
	   	}
	   	<%
			   		checkdetailno ++;
			    }
			}
		}
		else
		{
		 	int checkGroupId=0;
		    RecordSet formrs=new RecordSet();
			formrs.execute("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1' order by groupid");
		    while (formrs.next())
		    {
		    	checkGroupId=formrs.getInt(1);
		    	%>
		       	var rowneed = $GetEle('rowneed<%=checkGroupId%>').value;
		       	var nodesnum = $GetEle('nodesnum<%=checkGroupId%>').value;
		       	nodesnum = nodesnum*1;
		       	if(rowneed=="1")
		       	{
		       		if(nodesnum>0)
		       		{
		       			nodenum = 0;
		       		}
		       		else
		       		{
		       			nodenum = <%=checkGroupId+1%>;
		       		}
		       	}
		       	else
		       	{
		       		nodenum = 0;
		       	}
		       	if(nodenum>0)
			   	{
			   		return nodenum;
			   	}
		       	<%
		    }
	    }
	    //多明细循环结束
		%>
		}
		catch(e)
		{
			nodenum = 0;
		}
		return nodenum;
	}
    function doSave_n(obj){
    	enableAllmenu();
		var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		displayAllmenu();
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
		//点击保存按钮
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        }catch(e){
            var ischeckok="";
            try{
              if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
                    ischeckok="true";
            }
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
            if(ischeckok=="true"){
                objSubmit=obj;
                CkeditorExt.updateContent();
                if(checktimeok()&&checkReportData("save")) {
                }else{
                    displayAllmenu();
					return;
                }
            }else{
            	displayAllmenu();
				return;
            }
        }
	}


    function doRemark()
    <!-- 点击被转发的提交按钮 -->
	
    {    
var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
if(ischeckok=="true"){	
	if ("<%=needconfirm%>"=="1")
	{
	if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>"))
    return false;
	}

        try
        {
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoRemark").click();
        }
        catch(e)
        {                
			if(checktimeok()) 
			{
		        $GetEle("frmmain").isremark.value='1';
		        $GetEle("frmmain").src.value='save'; 		                        
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201


//保存签章数据
<%if("1".equals(isFormSignature)){%>
	                    if(SaveSignature()){
            //TD4262 增加提示信息  开始
			<%
			    if(ismode.equals("1")){
			%>
	            
                            contentBox = $GetEle("divFavContent18978");
                            showObjectPopup(contentBox)
			<%
			    
			    }else{
			%>
		       
                            var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
                            showPrompt(content);
			        
			<%
			    }
			%>
                            //TD4262 增加提示信息  结束

                            //附件上传
                            StartUploadAll();
                            checkuploadcomplet();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							displayAllmenu();
							return ;
						}
<%}else{%>
            //TD4262 增加提示信息  开始
			<%
			    if(ismode.equals("1")){
			%>
	            
                        contentBox = $GetEle("divFavContent18978");
                        showObjectPopup(contentBox)
			<%
			    
			    }else{
			%>
		       
                        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
                        showPrompt(content);
			        
			<%
			    }
			%>
                        //TD4262 增加提示信息  结束

                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
            }
        }
}
	}

    function doSave(){//点击保存按钮
        alert(1);
    	enableAllmenu();
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		displayAllmenu();
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        }catch(e){
            var ischeckok="";
            try{
             if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
                    ischeckok="true";
            }
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
	            getRemarkText_log();
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
            if(ischeckok=="true"){
                objSubmit="";
                CkeditorExt.updateContent();
                if(checktimeok()&&checkReportData("save")) {
                }else{
                    displayAllmenu();
				    return;
                }
            }else{
            	displayAllmenu();
				return;
            }
        }
	}

    function doAffirmance(obj){          <!-- 提交确认 -->
		enableAllmenu();
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
            displayAllmenu();
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
		
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        }catch(e){
            var ischeckok="";
            try{
             if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
                    ischeckok="true";
            }
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
            if(ischeckok=="true"){
                objSubmit=obj;
                CkeditorExt.updateContent();
                if(checktimeok()&&checkReportData("Affirmance")) {
                }else{
					displayAllmenu();
					return;
				}
            }else{
				displayAllmenu();
				return;
			}
        }
	}
    

	/*	
	 *	用来给用户自定义检查数据，在流程提交或者保存的时候执行该函数，
	 *	如果检查通过返回true，否则返回false
	 *	用户在使用html模板的时候，通过重写这个方法，来达到检查特殊数据的需求
	 */
	function checkCustomize(){
		return true;
	}
    
    function doSubmit(obj){					//点击提交
			$G('RejectToNodeid').value = '';
    var isuseTemplate = $GetEle("temphasUseTempletSucceed").value;
		if(!checkCustomize()){
			return false;
		}
		
    	enableAllmenu();
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		displayAllmenu();
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSubmit").click();
        }catch(e){
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $GetEle("needcheck")来检查,避免对原有无明细单据的修改
        var ischeckok="";
        try{
        var checkstr=$GetEle("needcheck").value+$GetEle("inputcheck").value+',<%=needcheck%>';
        if(<%=isremark%>==5){
            checkstr="";
        }
        if(check_form($GetEle("frmmain"),checkstr))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
            ischeckok="true";
        }
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
	            getRemarkText_log();
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
        if(ischeckok=="true"){
    		if (("<%=needconfirm%>"=="1")&&("<%=nodetype%>"!="0"))
    		{
    		if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>")){
    			displayAllmenu();
	            return false;
    		}
    		}
			<%
			if("1".equals(fromFlowDoc)||"1".equals(isworkflowdoc)){
				//if(!hasUseTempletSucceed){
			%>
				if(isuseTemplate == 'false'){
					if($GetEle("createdoc")){
					if(window.confirm("<%=SystemEnv.getHtmlLabelName(21252,user.getLanguage())%>")){
					   //parent.resetbanner(1,1);
					   $GetEle("createdoc").click();
					   return false;
					}else{
						displayAllmenu();
					   return false;
					}
					}
					}
			<%
			}
			if("1".equals(fromFlowDoc)||"1".equals(isworkflowdoc)){
				if(!hasSignatureSucceed){
			%>
					if(!window.confirm("<%=SystemEnv.getHtmlLabelName(23043,user.getLanguage())%>")){
						displayAllmenu();
					   return false;
					}
			<%
				}
			}
			%>
            objSubmit=obj;
            CkeditorExt.updateContent();
            if(checktimeok()&&checkReportData("submit")) {
            }else{
            	displayAllmenu();
				return;
            }
        }else{
        	displayAllmenu();
			return;
        }
        }
	}

		function doReject(){				//点击退回
		<%
			if(isSignMustInput.equals("1")){
		%>
			    if(!check_form(document.frmmain,'remarkText10404')){
				    return false;
			    }
		<%
			}
		%>
		var isuseTemplate = $GetEle("temphasUseTempletSucceed").value;
		var _isUseTempletNode = $GetEle("isUseTempletNode").value;
		enableAllmenu();
		if ("<%=needconfirm%>"=="1")
		{
		if (!confirm("<%=SystemEnv.getHtmlLabelName(19991,user.getLanguage())%>")){
			displayAllmenu();
	        return false;
		} 
		}
		<%
		if("1".equals(fromFlowDoc)||"1".equals(isworkflowdoc)){
			//if(isUseTempletNode&&hasUseTempletSucceed){
		%>
			if(_isUseTempletNode == 'true'&&isuseTemplate== 'true'){
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(22985,user.getLanguage())%>")){
				   //parent.resetbanner(1,1);
				   $GetEle("createdoc").click();
				   return;
				}else{
				   displayAllmenu();
				   return;
				}
				}
		<%
			
		}
		%>
		try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoReject").click();
        }catch(e){
            if(onSetRejectNode()){
	            showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=nodeid%>,<%=isbill%>,1,<%=billid%>,"","reject","<%=ismode%>","divFavContent18980","<%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%>");
            }else{
            	displayAllmenu();
				return;
            }
        }
    }

	function doReopen(){        <!-- 点击重新激活 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoReopen").click();
        }catch(e){
            $GetEle("frmmain").src.value='reopen';
            $GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
            jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201
            checkuploadcomplet();
        }
	}

	function doDelete(){        <!-- 点击删除 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoDelete").click();
        }catch(e){
            if(confirm("<%=SystemEnv.getHtmlLabelName(16667,user.getLanguage())%>")) {
                $GetEle("frmmain").src.value='delete';
                $GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

                //TD4262 增加提示信息  开始
<%
    if(ismode.equals("1")){
%>
	            contentBox = $GetEle("divFavContent18984");
                showObjectPopup(contentBox)
<%
    }else{
%>
		       var content="<%=SystemEnv.getHtmlLabelName(18984,user.getLanguage())%>";
		       showPrompt(content);
<%
    }
%>
                //TD4262 增加提示信息  结束

                checkuploadcomplet();
		
            }
        }
    }
//加常用短语
function onAddPhrase(phrase){
	if(phrase!=null && phrase!=""){
		$GetEle("remarkSpan").innerHTML = "";
		try{
			var remarkHtml = FCKEditorExt.getHtml("remark");
			var remarkText = FCKEditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				FCKEditorExt.setHtml(phrase,"remark");
			}else{
				FCKEditorExt.setHtml(remarkHtml+"<p>"+phrase+"</p>","remark");
			}
		}catch(e){}
	}
}
//xwj for td3665 20060227
function doDrawBack(obj){
	if("<%=needconfirm%>"=="1"&&!confirm("<%=SystemEnv.getHtmlLabelName(24703,user.getLanguage())%>")){
		return false;
	}else{
	var ischeckok="true";
	<%
		if(isSignMustInput.equals("1")){
		    if("1".equals(isFormSignature)){
			}else{
	%>
	            if(ischeckok=="true"){
	            	getRemarkText_log();
				    if(!check_form($GetEle("frmmain"),'remarkText10404')){
					    ischeckok="false";
				    }
			    }
	<%
			}
		}
	%>
			if(ischeckok=="true"){	
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
				obj.disabled=true;
				$GetEle("frmmain").action="/workflow/workflow/wfFunctionManageLink.jsp?flag=ov&fromflow=1";
				//附件上传
			    StartUploadAll();
		        checkuploadcomplet();
		}
	}
}
function doRetract(obj){
jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
obj.disabled=true;
document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=rb&requestid=<%=requestid%>" //xwj for td3665 20060224
}
function nodechange(value){
    var nodeids=value.split("_");
    var selnodeid=nodeids[0];
    var selnodetype=nodeids[1];
    if(selnodetype==0){
        $GetEle("Intervenorid").value="<%=creater%>";
        $GetEle("Intervenorspan").innerHTML="<A href='javaScript:openhrm(<%=creater%>);' onclick='pointerXY(event);'><%=creatername%></a>";
    }else{
    rightMenu.style.display="none";
    $GetEle("workflownextoperatorfrm").src="/workflow/request/WorkflowNextOperator.jsp?requestid=<%=requestid%>&isremark=<%=isremark%>&workflowid=<%=workflowid%>"+
            "&formid=<%=formid%>&isbill=<%=isbill%>&billid=<%=billid%>&creater=<%=creater%>&creatertype=<%=creatertype%>&nodeid="+selnodeid+"&nodetype="+selnodetype;
    }
}



//TD4262 增加提示信息  开始
//提示窗口

<%
    if(ismode.equals("1")){
%>
function showObjectPopup(contentBox){
  try{
    var iX=document.body.offsetWidth/2-50;
	var iY=document.body.offsetHeight/2+document.body.scrollTop-50;

	var oPopBody = oPopup.document.body;
    oPopBody.style.border = "1px solid #8888AA";
    oPopBody.style.backgroundColor = "white";
    oPopBody.style.position = "absolute";
    oPopBody.style.padding = "0px";
    oPopBody.style.zindex = 150;

    oPopBody.innerHTML = contentBox.innerHTML;

    oPopup.show(iX, iY, 180, 22, document.body);
  }catch(e){}
}
<%
    }else{
%>
function showPrompt(content)
{
     var showTableDiv  = $GetEle('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = $GetEle("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     jQuery(message_table_Div).css("top", pTop);
     jQuery(message_table_Div).css("left", pLeft);

     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
    
     jQuery(oIframe).css("top", pTop);
     jQuery(oIframe).css("left", pLeft);
     
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}
<%
    }
%>
//TD4262 增加提示信息  结束
var showTableDiv  = $GetEle('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
	var pTop= document.body.offsetHeight/2 + document.body.scrollTop - 50;
	var pLeft= document.body.offsetWidth/2 - 50;
	
	jQuery(showTableDiv).css("display", "");
 
	jQuery(showTableDiv).append("<div id=\"message_Div\" class=\"xTable_message\"></div>");
	jQuery("#message_Div").css("display", "inline");
	jQuery("#message_Div").html(content);
	jQuery("#message_Div").css("position", "absolute");
	jQuery("#message_Div").css("top", pTop);
	jQuery("#message_Div").css("left", pLeft);
	jQuery("#message_Div").css("zIndex", 1002);
	jQuery(oIframe).attr("id", "HelpFrame");
	jQuery(showTableDiv).append(oIframe);
	jQuery(oIframe).attr("frameborder", 0);
	jQuery(oIframe).css("position", "absolute");
	jQuery(oIframe).css("top", pTop);
	jQuery(oIframe).css("left", pLeft);
	jQuery(oIframe).css("zIndex", parseInt(jQuery("#message_Div").css("zIndex")) - 1);
	jQuery(oIframe).css("width", parseInt(jQuery("#message_Div")[0].offsetWidth));
	jQuery(oIframe).css("height", parseInt(jQuery("#message_Div")[0].offsetHeight));
	jQuery(oIframe).css("display", "block");
}
function displaydiv_1()
{
	if(WorkFlowDiv.style.display == ""){
		WorkFlowDiv.style.display = "none";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
	}
	else{
		WorkFlowDiv.style.display = "";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";

	}
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showallreceivedforsign(requestid,viewLogIds,operator,operatedate,operatetime,returntdid,logtype,destnodeid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowReceiviedPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&viewnodeIds="+viewLogIds+"&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            $GetEle(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        } 
    } 
}

function accesoryChanage(obj,maxUploadImageSize){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=$GetEle("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
        //alert("<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>");
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if(parseFloat(maxUploadImageSize)<=0)
    {
    	if(uploadImageMaxSize)
    		maxUploadImageSize = uploadImageMaxSize;
    		
    }
    if (fileLenthByM>maxUploadImageSize) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=50 >";
    $GetEle(objName).outerHTML=outerHTML;
    $GetEle(objName).onchange=tempObjonchange;
}
function addannexRow(accname,maxsize)
  {
  	//区分两种添加方式
  	var uploadspan = "";
  	var checkMaxUpload = 0;
  	if(uploadImageMaxSize&&accname!="field-annexupload")
  	{
  		maxsize = uploadImageMaxSize;
  		uploadspan = "uploadspan";
  	}
  	else
  	{
  		checkMaxUpload = maxsize;
  	}
    $GetEle(accname+'_num').value=parseInt($GetEle(accname+'_num').value)+1;
    ncol = $GetEle(accname+'_tab').cols;
    oRow = $GetEle(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          oCell.colSpan=3;
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this,"+checkMaxUpload+")'><span id='"+uploadspan+"'>(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span> ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }

 function onChangeSharetype(delspan,delid,ismand,Uploadobj){
	fieldid=delid.substr(0,delid.indexOf("_"));
    linknum=delid.substr(delid.lastIndexOf("_")+1);
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
    delfieldid=fieldid+"_id_"+linknum;
    if($GetEle(delspan).style.visibility=='visible'){
      $GetEle(delspan).style.visibility='hidden';
      $GetEle(delid).value='0';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
        var tempvalue=$GetEle(fieldid).value;
          if(tempvalue==""){
              tempvalue=$GetEle(delfieldid).value;
          }else{
              tempvalue+=","+$GetEle(delfieldid).value;
          }
	     $GetEle(fieldid).value=tempvalue;
    }else{
      $GetEle(delspan).style.visibility='visible';
      $GetEle(delid).value='1';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
        var tempvalue=$GetEle(fieldid).value;
        var tempdelvalue=","+$GetEle(delfieldid).value+",";
          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
	     $GetEle(fieldid).value=tempvalue;
    }
	//alert($GetEle(fieldidnum).value);
	if (ismand=="1")
	  {
	if ($GetEle(fieldidnum).value=="0")
	  {
	    $GetEle(fieldid).value="";
        if(Uploadobj.getStats().files_queued==0){
		$GetEle(fieldidspan).innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
        }
	  }
	  else
	  {
		 $GetEle(fieldidspan).innerHTML="";
	  }
	  }
  }
function checkReportData(src){
		var reportUserId="";
		var crmId="";
		var year="";
		var month="";
		var day="";
		var date="";
        <%if(!newReportUserId.equals("")&&!newCrmId.equals("")){%>
        if($GetEle("<%=newReportUserId%>")!=null){
			reportUserId=$GetEle("<%=newReportUserId%>").value;
		}
        if($GetEle("<%=newCrmId%>")!=null){
			crmId=$GetEle("<%=newCrmId%>").value;
		}
        if($GetEle("year")!=null){
			year=$GetEle("year").value;
		}
		if($GetEle("month")!=null){
			month=$GetEle("month").value;
		}
		if($GetEle("day")!=null){
			day=$GetEle("day").value;
		}
		if($GetEle("date")!=null){
			date=$GetEle("date").value;
		}
		StrData="requestid=<%=requestid%>&formid=<%=formid%>&reportUserId="+reportUserId+"&crmId="+crmId+"&year="+year+"&month="+month+"&day="+day+"&date="+date+"&src="+src;
        if($GetEle("checkReportDataForm")!=null){
			$GetEle("checkReportDataForm").src="checkReportDataForm.jsp?"+StrData;
		}else{
            checkReportDataReturn(0,"","",src);
        }
        <%}else{%>
        checkReportDataReturn(0,"","",src);
        <%}%>
	}
function checkReportDataReturn(ret,thedate,dspdate,src){

		if(ret==1||ret==2){
			displayAllmenu();
			alert(dspdate+" "+"<%=SystemEnv.getHtmlLabelName(20775,user.getLanguage())%>");
			return false;
		}
		if(src=="save"){
                    $GetEle("frmmain").src.value='save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");


            //保存签章数据
            <%if("1".equals(isFormSignature)){%>
                                    if(SaveSignature()){
<%
    if(ismode.equals("1")){
%>
                                        contentBox = $GetEle("divFavContent18979");
                                        showObjectPopup(contentBox)
<%
    }else{
%>
                                        var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                                        showPrompt(content);
<%
    }
%>
                                        if(objSubmit!=""){
                                        	objSubmit.disabled=true;
                                        }
                                        //附件上传
                                        StartUploadAll();
                                        checkuploadcomplet();
                                    }else{
                                        if(isDocEmpty==1){
                                        	alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
                                        	isDocEmpty=0;
                                        }else{
                                        	alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
                                        }
	                                    displayAllmenu();
                                        return ;
                                    }
            <%}else{%>
<%
    if(ismode.equals("1")){
%>
                                    contentBox = $GetEle("divFavContent18979");
                                    showObjectPopup(contentBox)
<%
    }else{
%>
                                    var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                                    showPrompt(content);
<%
    }
%>
                                    if(objSubmit!=""){
                                    	objSubmit.disabled=true;
                                    }
                                    //附件上传
                                    StartUploadAll();
                                    checkuploadcomplet();
            <%}%>

		}else if(src=="submit"){
            showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=nodeid%>,<%=isbill%>,0,<%=billid%>,objSubmit,"submit","<%=ismode%>","divFavContent18978","<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>");
		}else if(src=="Affirmance"){
                $GetEle("frmmain").src.value='save';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

            <%
                        topage = URLEncoder.encode(topage) ;
                        String url = URLEncoder.encode("ViewRequest.jsp?isaffirmance=1&reEdit=0&fromFlowDoc="+fromFlowDoc+"&topage="+topage);
                        %>
                $GetEle("frmmain").topage.value="<%=url%>";
//保存签章数据
            <%if("1".equals(isFormSignature)){%>
                                    if(SaveSignature()){

<%
    if(ismode.equals("1")){
%>
                                        contentBox = $GetEle("divFavContent18979");
                                        showObjectPopup(contentBox)
<%
    }else{
%>
                                        var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                                        showPrompt(content);
<%
    }
%>
                                        //TD4262 增加提示信息  结束
                                        if(objSubmit!=""){
                                        	objSubmit.disabled=true;
                                        }
                                        //附件上传
                                        StartUploadAll();
                                        checkuploadcomplet();
                                    }else{
	                                    if(isDocEmpty==1){
	                                    	alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
                                        	isDocEmpty=0;
                                        }else{
                                        	alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
                                        }
	                                    displayAllmenu();
                                        return ;
                                    }
            <%}else{%>
<%
    if(ismode.equals("1")){
%>
                                    contentBox = $GetEle("divFavContent18979");
                                    showObjectPopup(contentBox)
<%
    }else{
%>
                                    var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                                    showPrompt(content);
<%
    }
%>
                                    //TD4262 增加提示信息  结束
                                    if(objSubmit!=""){
                                    	objSubmit.disabled=true;
                                    }
                                    //附件上传
                                    StartUploadAll();
                                    checkuploadcomplet();
            <%}%>
		}
	}

function showtipsinfo(requestid,workflowid,nodeid,isbill,isreject,billid,obj,src,ismode,divcontent,content){
		var nowtarget = frmmain.target;
		var nowaction = frmmain.action;

		$GetEle("divcontent").value=divcontent;
		$GetEle("content").value=content;
		$GetEle("src").value=src;
		frmmain.target = "showtipsinfoiframe";
		frmmain.action = "/workflow/request/WorkflowTipsinfo.jsp";
		frmmain.submit();

		frmmain.target = nowtarget;
		frmmain.action = nowaction;
}


function showtipsinfoReturn(returnvalue,src,ismode,divcontent,content,messageLabelName){

	obj="";
            try{
                if(messageLabelName!=""){
					alert(messageLabelName);
					return ;
				}
            }catch(e){}
            try{
                tipsinfo=returnvalue;
                if(tipsinfo!=""){
                    if(confirm(tipsinfo)){
                        $GetEle("frmmain").src.value=src;
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");


                        //保存签章数据
                        <%if("1".equals(isFormSignature)){%>
                            if(SaveSignature()){
                                if(ismode=="1"){
                                    contentBox = $GetEle(divcontent);
                                    showObjectPopup(contentBox)
                                   }else{
                                    showPrompt(content);
                                }
                                if(obj!=""){
                                    obj.disabled=true;
                                }
                                //附件上传
                                StartUploadAll();
                                checkuploadcomplet();
                            }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
								displayAllmenu();
                                return ;
                            }
                        <%}else{%>
                            if(ismode=="1"){
                                contentBox = $GetEle(divcontent);
                                showObjectPopup(contentBox)
                            }else{
                                showPrompt(content);
                            }
                            if(obj!=""){
                                obj.disabled=true;
                            }
                            //附件上传
                            StartUploadAll();
                            checkuploadcomplet();
                        <%}%>
                    }else{
						displayAllmenu();
                        return ;
					}
                }else{
                    $GetEle("frmmain").src.value=src;
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");


                        //保存签章数据
                        <%if("1".equals(isFormSignature)){%>
                            if(SaveSignature()){
                                if(ismode=="1"){
                                    contentBox = $GetEle(divcontent);
                                    showObjectPopup(contentBox)
                                }else{
                                    showPrompt(content);
                                }
                                if(obj!=""){
                                    obj.disabled=true;
                                }
                                //附件上传
                                StartUploadAll();
                                checkuploadcomplet();
                            }else{
                                if(isDocEmpty==1){
                                	alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
                                	isDocEmpty=0;
                                }else{
                                	alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
                                }
                                displayAllmenu();
                                return ;
                            }
                        <%}else{%>
                            if(ismode=="1"){
                                contentBox = $GetEle(divcontent);
                                showObjectPopup(contentBox)
                            }else{
                                showPrompt(content);
                            }
                            if(obj!=""){
                                obj.disabled=true;
                            }
                            //附件上传
                            StartUploadAll();
                            checkuploadcomplet();
                        <%}%>
                }
            }catch(e){}
}
function doStop(obj){
	//您确定要暂停当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26156,user.getLanguage())%>?")){
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=stop&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
function doCancel(obj){
	//您确定要撤销当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26157,user.getLanguage())%>?")){
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=cancel&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
function doRestart(obj)
{
	//您确定要启用当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26158,user.getLanguage())%>?")){
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=restart&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
</script>

<script type="text/javascript">
//---------------------------------------
// 此script元素内德code均是从vbscript转换而来
//---------------------------------------
//<!--
function onShowBrowser(id, url, linkurl, type1, ismand) {
	if (type1 == 2 || type1 == 19) {
		id1 = window.showModalDialog(url, "", "dialogHeight:320px;dialogwidth:275px");

		$GetEle("field" + id + "span").innerHTML = id1;
		$GetEle("field" + id).value = id1;
	} else {
		if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142
				&& type1 != 135 && type1 != 17 && type1 != 18 && type1 != 27
				&& type1 != 37 && type1 != 56 && type1 != 57 && type1 != 65
				&& type1 != 165 && type1 != 166 && type1 != 167 && type1 != 168
				&& type1 != 4 && type1 != 167 && type1 != 164 && type1 != 169
				&& type1 != 170) {
			id1 = window.showModalDialog(url);
		} else {
			if (type1 == 135) {
				var tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids);
			} else if (type1 == 4 || type1 == 167 || type1 == 164
					|| type1 == 169 || type1 == 170) {
				var tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids);
			} else if (type1 == 37) {
				var tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids);
			} else if (type1 == 142) {
				var tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
			} else if (type1 == 162) {
				var tmpids = $GetEle("field" + id).value;
				url = url + "&beanids=" + tmpids;
				url = url.substring(0, url.indexOf("url=") + 4) + url.substr(url.indexOf("url=") + 4);
				id1 = window.showModalDialog(url);
			} else if (type1 == 165 || type1 == 166 || type1 == 167
					|| type1 == 168) {
				var index = id.indexOf("_");
				if (index != -1) {
					var tmpids = uescape("?isdetail=1&isbill=<%=isbill%>&fieldid="
							+ id.substring(0, index) + "&resourceids="
							+ $GetEle("field" + id).value);
					id1 = window.showModalDialog(url + tmpids);
				} else {
					var tmpids = uescape("?fieldid=" + id
							+ "&isbill=<%=isbill%>&resourceids="
							+ $GetEle("field" + id).value);
					id1 = window.showModalDialog(url + tmpids);
				}
			} else {
				var tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
			}
		}
		if (id1) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135
					|| type1 == 17 || type1 == 18 || type1 == 27 || type1 == 37
					|| type1 == 56 || type1 == 57 || type1 == 65
					|| type1 == 166 || type1 == 168 || type1 == 170) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = "";
					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					$GetEle("field" + id).value = resourceids;
					
					var resourceidArray = resourceids.split(",");
					var resourcenameArray = resourcename.split(",");
					
					for (var _i=0; _i<resourceidArray.length; _i++) {
						var curid = resourceidArray[_i];
						var curname = resourcenameArray[_i];
						
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml = sHtml + "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml = sHtml + "<a href=" + linkurl + curid + ">" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field" + id + "span").innerHTML = sHtml;
				} else {
					if (ismand == 0) {
						$GetEle("field" + id + "span").innerHTML = "";
					} else {
						$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
					}
					$GetEle("field" + id).value = "";
				}

			} else {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
					if (linkurl == "") {
						$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
					} else {
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							$GetEle("field" + id + "span").innerHTML = "<a href=javaScript:openhrm(" 
									+ wuiUtil.getJsonValueByIndex(id1, 0)
									+ "); onclick='pointerXY(event);'>"
									+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
						} else {
							$GetEle("field" + id + "span").innerHTML = "<a href="
									+ linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + ">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
						}

					}
					$GetEle("field" + id).value = wuiUtil.getJsonValueByIndex(id1, 0);
				} else {
					if (ismand == 0) {
						$GetEle("field" + id + "span").innerHTML = "";
					} else {
						$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
					}
					$GetEle("field" + id).value = "";
				}
			}
		}
	}
}

function onShowSignBrowser(url, linkurl, inputname, spanname, type1) {
	var tmpids = $GetEle(inputname).value;
	if (type1 = 37) {
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url
				+ "?documentids=" + tmpids);
	} else {
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url
				+ "?resourceids=" + tmpids);
	}
	if (id1) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$GetEle(inputname).value = resourceids;
			
			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			
			
			for (var _i=0; _i<resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];
				
				sHtml = sHtml + "<a href=" + linkurl + curid
						+ " target='_blank'>" + curname + "</a>&nbsp";
			}
			$GetEle(spanname).innerHTML = sHtml;

		} else {
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		}
	}
}

function onShowMutiHrm(spanname, inputename) {
	tmpids = $GetEle(inputename).value;
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
					+ tmpids);
	if (id1) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			
			$GetEle(inputename).value = resourceids;
			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			for (var _i=0; _i<resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];
				
				sHtml = sHtml + "<A href='javaScript:openhrm(" + curid
						+ ");' onclick='pointerXY(e);'>" + curname
						+ "</a>&nbsp";
			}
			
			$GetEle(spanname).innerHTML = sHtml;

		} else {
			$GetEle(spanname).innerHTML = "<button type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><img src='/images/BacoError.gif' align=absmiddle>";
			$GetEle(inputename).value = "";
		}
	}
}

function getDate(i) {
	var returndate = window.showModalDialog("/systeminfo/Calendar.jsp", "", "dialogHeight:320px;dialogwidth:275px");
	$GetEle("datespan" + i).innerHTML = returndate;
	$GetEle("dff0" + i).value = returndate;
}
//-->
</script>
<style type="text/css">
TABLE.ListStyle tbody tr td {
	padding: 4 5 0 5!important;
}
</style>

<script type="text/javascript">
function  showAllSignLog2(workflowid,requestid,viewLogIds,orderby, pageNumber, targetEle, requestLogDataIsEnd, WorkFlowLoddingDiv, maxRequestLogId) {
	var saslrtn = 0;
	jQuery("#" + WorkFlowLoddingDiv).show();
	var crurrentPageNumber = pageNumber;
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowViewSignMore.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("workflowid="+workflowid+"&requestid="+requestid+"&languageid=<%=user.getLanguage()%>&desrequestid=<%=0%>&userid=<%=userid%>&isprint=<%=false%>&isOldWf=<%=isOldWf%>&viewLogIds="+viewLogIds+"&orderbytype=<%=orderbytype%>&creatorNodeId=<%=creatorNodeId%>&orderby="+orderby + "&pgnumber=" + crurrentPageNumber + "&maxrequestlogid=" + maxRequestLogId + "&wflog" + new Date().getTime() + "=" + "&wfsignlddtcnt=<%=wfsignlddtcnt%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try {
       			var $targetEle = jQuery("#" + targetEle);

            	saslrtn = ajax.responseText.replace(/(^\s*)|(\s*$)/g, "").indexOf("<requestlognodata>");
				if (saslrtn == -1) {
					 
					 var tableStr="<table class=liststyle cellspacing=1 style=\"margin:0;margin-top:-1;\">"+
    				 "<colgroup>"+
    				 "<col width='10%'><col width='50%'> <col width='10%'>  <col width='30%'>"+
    				 "</colgroup>"+jQuery("#headTitle").html()+jQuery.trim(ajax.responseText)+
    				 "</table>"
    				 
					jQuery("#requestlogappednDiv").append(tableStr);
					jQuery("#requestlogappednDiv table tbody tr:first").addClass("HeaderForWF");
					jQuery("#mainWFHead").css("display", "none");
            		sucNm = true;
            	} else {
            		jQuery(requestLogDataIsEnd).val(1);
            		sucNm = false;
            	}
            	currentPageCnt = jQuery("input[name='currentPageCnt" + pageNumber + "']").val();
            	requestLogDataMaxRquestLogId = jQuery("input[name='maxrequestlogid" + crurrentPageNumber + "']").val();
            }
            catch(e) {
            	alert(e);
            }
            oIframe.style.display='none';
            jQuery("#" + WorkFlowLoddingDiv).hide();
        }
    }
}
</script>

<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client.js"></script>
<script type="text/javascript" src="/js/wfsp.js"></script>
<script language="javascript">
initrequestid = "<%=initrequestid%>";
viewLogIds = "<%=viewLogIds%>";
primaryWfLogLoadding();

window.onscroll = function () {
	if (document.body.scrollTop + document.body.offsetHeight + 800 >= document.body.scrollHeight ) {
		primaryWfLogLoadding();
	}
};

jQuery(document).ready(function () {
	primaryWfLogLoadding();
});
</script>