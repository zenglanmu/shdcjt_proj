<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.general.TimeUtil"%><!--added by xwj for td2891-->
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog1" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog2" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<%@ page import="weaver.workflow.request.ComparatorUtilBean" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>
<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>
 -->
<%
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int languageidfromrequest = Util.getIntValue(request.getParameter("languageid"));

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int desrequestid=Util.getIntValue(request.getParameter("desrequestid"),0);
int userid=Util.getIntValue(request.getParameter("userid"),0);
int usertype=Util.getIntValue(request.getParameter("usertype"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
boolean isprint = Util.null2String(request.getParameter("isprint")).equalsIgnoreCase("true") ;
String isOldWf=Util.null2String(request.getParameter("isOldWf"));
String isurger=Util.null2String(request.getParameter("isurger"));
String wfmonitor=Util.null2String(request.getParameter("wfmonitor"));
int loga_urger=isurger.trim().equals("true")?1:0;
int loga_monitor=wfmonitor.trim().equals("true")?1:0;
int intervenorright=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"intervenorright"),0);
boolean isOldWf_ = false;
if(isOldWf.trim().equals("true")) isOldWf_=true;
%>
 <jsp:include page="WorkflowViewWT.jsp" flush="true">
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="userid" value="<%=userid%>" />
	<jsp:param name="usertype" value="<%=usertype%>" />
	<jsp:param name="languageid" value="<%=languageidfromrequest%>" />
</jsp:include>
<%

/**流程存为文档是否要签字意见**/
boolean fromworkflowtodoc = Util.null2String((String)session.getAttribute("urlfrom_workflowtodoc_"+requestid)).equals("true");
boolean ReservationSign = false;
RecordSet.executeSql("select * from workflow_base where id = " + workflowid);
if(RecordSet.next()) ReservationSign = (RecordSet.getInt("keepsign")==2);
if(fromworkflowtodoc&&ReservationSign){
	return;
}
/**流程存为文档是否要签字意见**/

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

		if(rssign.getCounts()==0){
		   allrequestid.remove(index);
		   allrequestname.remove(index);
		}
	}
}

session.setAttribute("canviewwf",canviewwf);

int nodetype = Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"nodetype"),0);
int formid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"formid"),0);
int isbill=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"isbill"),0);
int billid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"billid"),0);
int creater =Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"creater"),0);
int creatertype =Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"creatertype"),0);
String creatername=ResourceComInfo.getResourcename(""+creater);
String intervenoruserids="";
String intervenorusernames="";
int nextnodeid=-1;
String nodeattr="";
ArrayList BrancheNodes=new ArrayList();
if(intervenorright>0){
    String billtablename = "";
    int operatorsize = 0;

    WFNodeMainManager.setWfid(workflowid);
    WFNodeMainManager.selectWfNode();
    while(WFNodeMainManager.next()){
        if(WFNodeMainManager.getNodeid()==nodeid) nodeattr=WFNodeMainManager.getNodeattribute();
    }
    if(nodeattr.equals("2")){
        BrancheNodes=WFLinkInfo.getFlowBrancheNodes(requestid,workflowid);
    }
    boolean hasnextnodeoperator = false;
    Hashtable operatorsht = new Hashtable();


    if (isbill == 1) {
			RecordSet.executeSql("select tablename from workflow_bill where id = " + formid); // 查询工作流单据表的信息
			if (RecordSet.next())
				billtablename = RecordSet.getString("tablename");          // 获得单据的主表
    }
//查询节点操作者
        requestNodeFlow.setRequestid(requestid);
		requestNodeFlow.setNodeid(nodeid);
		requestNodeFlow.setNodetype(""+nodetype);
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
%>
<iframe id="workflownextoperatorfrm" frameborder=0 scrolling=no src=""  style="display:none;"></iframe>
<%}
%>

<%
User user2 = HrmUserVarify.getUser (request , response) ;
if(user2 == null)  return ;
String wfid1 = String.valueOf(workflowid);
String ndid1 = String.valueOf(nodeid);
String isSignMustInput = "0";
RecordSet.executeSql("select issignmustinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}
String isannexupload_edit="";
String annexdocCategory_edit="";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
String showDocTab_edit="";
String showWorkflowTab_edit="";
String showUploadTab_edit="";
RecordSetLog.execute("select isannexupload,annexdocCategory,isSignDoc,isSignWorkflow,showDocTab,showWorkflowTab,showUploadTab from workflow_base where id="+workflowid);
if(RecordSetLog.next()){
    isannexupload_edit=Util.null2String(RecordSetLog.getString("isannexupload"));
    annexdocCategory_edit=Util.null2String(RecordSetLog.getString("annexdocCategory"));
    isSignDoc_edit=Util.null2String(RecordSetLog.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSetLog.getString("isSignWorkflow"));
    showDocTab_edit=Util.null2String(RecordSetLog.getString("showDocTab"));
    showWorkflowTab_edit=Util.null2String(RecordSetLog.getString("showWorkflowTab"));
    showUploadTab_edit=Util.null2String(RecordSetLog.getString("showUploadTab"));
}
%>
<!-- added end. -->
<style type="text/css">
TABLE.ListStyle tbody tr td {
	padding: 4 5 0 5!important;
}
</style>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%;display:none' valign='top'>
</div>
<% if(!isprint&&(isurger.trim().equals("true")||wfmonitor.trim().equals("true")||intervenorright>0)){ %>
<table width="100%">
<tr>
<td width="50%"  valign="top">
<!-- added end. -->
<%--added by xwj for td 2104 on 2005-08-1 begin--%>
  <table class="viewform">
        <!-- modify by xhheng @20050308 for TD 1692 -->
         <COLGROUP>
         <COL width="20%">
         <COL width="80%">
         <%if(intervenorright>0){%>
         <tr><td colspan="2"><b><%=SystemEnv.getHtmlLabelName(18913,languageidfromrequest)%></b></td></tr>
         <TR class=spacing>
            <TD class=line1 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(18914,languageidfromrequest)%></td>
             <td class=field>
                 <select class=inputstyle  id="submitNodeId" name=submitNodeId  onChange='nodechange(this.value)'  temptitle="<%=SystemEnv.getHtmlLabelName(18914,languageidfromrequest)%>">
                 <option value="" ></option>
                 <%
                 WFNodeMainManager.setWfid(workflowid);
                 WFNodeMainManager.selectWfNode();
                 boolean hasnodeid=false;    
                 while(WFNodeMainManager.next()){
                    int tmpid = WFNodeMainManager.getNodeid();
                    //if(tmpid==nodeid) continue;
                    String tmpname = WFNodeMainManager.getNodename();
                    String tmptype = WFNodeMainManager.getNodetype();
                    String tempnodeattr=WFNodeMainManager.getNodeattribute();
                    if(nodeattr.equals("2")){
                        if(!tempnodeattr.equals("2")){
                            if(tmpid==nextnodeid){
                                intervenoruserids="";
                                intervenorusernames="";
                            }
                            continue;
                        }else if(BrancheNodes.indexOf(""+tmpid)==-1){
                            continue;
                        }
                    }else{
                        if(tempnodeattr.equals("2")){
                            if(tmpid==nextnodeid){
                                intervenoruserids="";
                                intervenorusernames="";
                            }
                            continue;
                        }
                    }
                 %>
                 <option value="<%=tmpid%>_<%=tmptype%>" <%if(nextnodeid==tmpid){hasnodeid=true;%>selected<%}%>><%=tmpname%></option>
                 <%}%>
                 </select>
                 <span id="submitNodeIdspan"><%if(!hasnodeid){%><img src='/images/BacoError.gif' align=absmiddle><%}%></span>
             </td>
         </tr>
	<TR class=spacing>
            <TD class=line2 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(21790,languageidfromrequest)%></td>
             <td class=field>
                 <select class=inputstyle  id="SignType" name=SignType>
                 <option value="0" ><%=SystemEnv.getHtmlLabelName(15556,languageidfromrequest)%></option>
                 <option value="1" ><%=SystemEnv.getHtmlLabelName(15557,languageidfromrequest)%></option>
                 <option value="2" ><%=SystemEnv.getHtmlLabelName(15558,languageidfromrequest)%></option>    
                 </select>
             </td>
         </tr>
    <TR class=spacing>
            <TD class=line2 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(18915,languageidfromrequest)%></td>
             <td class=field>
                 <span id="Intervenorspan">
                     <BUTTON type=button  class=Browser onclick="onShowMutiHrm('Intervenorspan','Intervenorid')" ></button><%=intervenorusernames%><%if(intervenorusernames.equals("")){%><img src='/images/BacoError.gif' align=absmiddle><%}%></span>
                 <input type=hidden name="Intervenorid" value="<%=intervenoruserids%>" temptitle="<%=SystemEnv.getHtmlLabelName(18915,languageidfromrequest)%>">
             </td>
         </tr>
    <TR class=spacing>
            <TD class=line2 colSpan=2></TD>
        </TR>
         <%
         }
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
         if(RecordSet.next())
         {
            myremark = Util.null2String(RecordSet.getString("remark")) ;
            annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
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
                  <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,languageidfromrequest)%></font></td>
                </tr>
            <tr>
              <td><%=SystemEnv.getHtmlLabelName(17614,languageidfromrequest)%></td>
              <td class=field>
              <%
         if(workflowPhrases.length>0){
         %>
                <select class=inputstyle  id="phraseselect" name=phraseselect style="width:80%" onChange='onAddPhrase(this.value)' onmousewheel="return false;">
                <option value="">－－<%=SystemEnv.getHtmlLabelName(22409,languageidfromrequest)%>－－</option>
                <%
                  for (int i= 0 ; i <workflowPhrases.length;i++) {
                    String workflowPhrase = workflowPhrases[i] ;  %>
                    <option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
                <%}%>
                </select>
              <%}%>
				<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(17614,languageidfromrequest)%>" value="">
              <textarea  class=Inputstyle name=remark id=remark rows=4 cols=40 style="width:80%"  temptitle="<%=SystemEnv.getHtmlLabelName(17614,languageidfromrequest)%>"   <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%>><%=myremark%></textarea>
	  		   	<script defer>
	  		   	function funcremark_log(){
					//FCKEditorExt.initEditor("frmmain","remark",<%=languageidfromrequest%>,FCKEditorExt.NO_IMAGE);
					CkeditorExt.initEditor('frmmain','remark','<%=languageidfromrequest%>',CkeditorExt.NO_IMAGE,200)
				<%if(isSignMustInput.equals("1")){%>
					CkeditorExt.checkText("remarkSpan","remark");
				<%}%>
					CkeditorExt.toolbarExpand(false,"remark");
				}
	  		  	//if(ieVersion>=8) window.attachEvent("onload", funcremark_log());
	  		  	//else window.attachEvent("onload", funcremark_log);
	  		  	
	  		  	if (window.addEventListener){
	  			    window.addEventListener("load", funcremark_log, false);
	  			}else if (window.attachEvent){
	  			    if(ieVersion>=8) window.attachEvent("onload", funcremark_log());
	  		  		else window.attachEvent("onload", funcremark_log);
	  			}else{
	  			    window.onload=funcremark_log;
	  			}	
				</script>
              <span id="remarkSpan">
<%
	if(isSignMustInput.equals("1")&&"".equals(myremark)){
%>
			  <img src="/images/BacoError.gif" align=absmiddle>
<%
	}
%>
              </span>
          </td> </tr>
         <tr><td class=Line2 colSpan=2></td></tr>
  <%
         if("1".equals(isSignDoc_edit)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,languageidfromrequest)%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids" value="<%=signdocids%>">
                <BUTTON type=button  class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,languageidfromrequest)%>"></button>
                <span id="signdocspan"><%=signdocname%></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_edit)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,languageidfromrequest)%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids" value="<%=signworkflowids%>">
                <BUTTON type=button  class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,languageidfromrequest)%>"></button>
                <span id="signworkflowspan"><%=signworkflowname%></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isannexupload_edit)){
         %>
        <tr>
            <td><%=SystemEnv.getHtmlLabelName(22194,languageidfromrequest)%></td>
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
              String tempshowname= Util.toScreen(RecordSet.getString(2),languageidfromrequest) ;
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
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=tempshowname%></a>&nbsp
              <%}%>
              <input type=hidden name="field-annexupload_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td >
                <BUTTON type=button  class=btnFlow accessKey=1  onclick='onChangeSharetype("span-annexupload_id_<%=linknum%>","field-annexupload_del_<%=linknum%>","0",oUploadannexupload)'><u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,languageidfromrequest)%>
                </button><span id="span-annexupload_id_<%=linknum%>" name="span-annexupload_id_<%=linknum%>" style="visibility:hidden">
                    <b><font COLOR="#FF0033">√</font></b>
                  <span>
            </td>
            <%if(accessoryCount==1){%>
            <td >
              <span id = "selectDownload">
                <%
                  if(!isprint&&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){
                %>
                  <BUTTON type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,languageidfromrequest)%>	  (<%=docImagefileSize/1000%>K)
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
           <font color="red"> <%=SystemEnv.getHtmlLabelName(21418,languageidfromrequest)+SystemEnv.getHtmlLabelName(15808,languageidfromrequest)%>!</font>
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
                "userid":"<%=user2.getUID()%>",
                "logintype":"<%=user2.getLogintype()%>"
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
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,languageidfromrequest)%></span>',
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
//        	window.attachEvent("onload", fileuploadannexupload);
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
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,languageidfromrequest)%></font><!--清除所有选择--></span>
								</span><span>(<%=SystemEnv.getHtmlLabelName(18976,languageidfromrequest)%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,languageidfromrequest)%>)</span>
                      <span id="field-annexuploadspan"></span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field-annexupload" value="<%=annexdocids%>">
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
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
        </table>
    </td> </tr>
</table>
<%}else{%>
<input type="hidden" name="remark" value="">
<input type="hidden" id="signdocids" name="signdocids" value="">
<input type="hidden" id="signworkflowids" name="signworkflowids" value="">
<%}%>
<%
if(!isprint&&(showDocTab_edit.equals("1")||showUploadTab_edit.equals("1")||showWorkflowTab_edit.equals("1"))){
%>
<table style="width:100%;" border=0 cellspacing=0 cellpadding=0  scrolling=no>
	  <colgroup>
		<col width="79">
        <%if(showDocTab_edit.equals("1")){%><col width="79"><%}%>
        <%if(showWorkflowTab_edit.equals("1")){%><col width="79"><%}%>
		<%if(showUploadTab_edit.equals("1")){%><col width="79"><%}%>
		<col width="*">
		</colgroup>
  <TBODY>
	  <tr align=left height="20">
	  <td nowrap name="oTDtype_0"  id="oTDtype_0" style="background:url(/images/tab.active2.png) no-repeat" width=79px  align=center onmouseover="style.cursor='hand'" style="font-weight:bold;"  onclick="signtabchange(0)">
	  <%=SystemEnv.getHtmlLabelName(1380,languageidfromrequest)%><%=SystemEnv.getHtmlLabelName(504,languageidfromrequest)%></td>
	  <%if(showDocTab_edit.equals("1")){%><td nowrap name="oTDtype_1"  id="oTDtype_1" style="background:url(/images/tab2.png) no-repeat" width=79px align=center onmouseover="style.cursor='hand'"  onclick='signtabchange(1)'>
	  <%=SystemEnv.getHtmlLabelName(857,languageidfromrequest)%></td><%}%>
      <%if(showWorkflowTab_edit.equals("1")){%><td nowrap name="oTDtype_2"  id="oTDtype_2" style="background:url(/images/tab2.png) no-repeat" width=79px  align=center onmouseover="style.cursor='hand'"  onclick="signtabchange(2)">
	  <%=SystemEnv.getHtmlLabelName(1044,languageidfromrequest)%></td><%}%>
	  <%if(showUploadTab_edit.equals("1")){%><td nowrap name="oTDtype_3"  id="oTDtype_3" style="background:url(/images/tab2.png) no-repeat" width=79px align=center onmouseover="style.cursor='hand'"  onclick='signtabchange(3)'>
	  <%=SystemEnv.getHtmlLabelName(22194,languageidfromrequest)%></td><%}%>
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
            <th><%=SystemEnv.getHtmlLabelName(1339,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(1341,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(2094,languageidfromrequest)%></th>
          </tr>
          <tr>
              <td colspan="3"><img src="/images/loadingext.gif" alt=""/><%=SystemEnv.getHtmlLabelName(19205,languageidfromrequest)%></td>
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
            <th><%=SystemEnv.getHtmlLabelName(882,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(1339,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(259,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(23753,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(1335,languageidfromrequest)%></th>
          </tr>
          <tr>
              <td colspan="5"><img src="/images/loadingext.gif" alt=""/><%=SystemEnv.getHtmlLabelName(19205,languageidfromrequest)%></td>
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
            <th><%=SystemEnv.getHtmlLabelName(23752,languageidfromrequest)%></th>
          </tr>
          <tr>
              <td><img src="/images/loadingext.gif" alt=""/><%=SystemEnv.getHtmlLabelName(19205,languageidfromrequest)%></td>
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
            loadsigndoc(<%=requestid%>,<%=workflowid%>,<%=userid%>,<%=languageidfromrequest%>);
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
            loadsignwf(<%=requestid%>,<%=workflowid%>,<%=userid%>,<%=languageidfromrequest%>);
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
            loadsignupload(<%=requestid%>,<%=workflowid%>,<%=userid%>,<%=languageidfromrequest%>);
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
    //var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid;
    var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid+"&isurger=<%=isurger%>&wfmonitor=<%=wfmonitor%>";
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
<div id="signid">


        <table class=liststyle cellspacing=1 style="margin:0;padding:0;" id="mainWFHead">
          <colgroup>
          <%--Modefied by xwj for td2104 on 2005-08-1--%>
          <%--update by fanggsh for TD4313 on 2006-05-16 begin--%>
          <%--<col width="10%"><col width="25%"> <col width="10%">  <col width="20%"> <col width="10%"><col width="25%">--%>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%"> 
          <%--update by fanggsh for TD4313 on 2006-05-16 end--%>

          <tbody>
		  <!-- 
		  <tr class="header">
             <%--update by fanggsh for TD4313 on 2006-05-16 begin--%>
     		 <%--<th colspan = 6>流转</th>--%>
             <th colspan = 4><%=SystemEnv.getHtmlLabelName(1380,languageidfromrequest)%></th>
             <%--update by fanggsh for TD4313 on 2006-05-16 end--%>
   		 </tr>
   		 -->

          <tr class="HeaderForWF" id="headTitle">
             <%--update by fanggsh for TD4313 on 2006-05-16 begin--%>
			 <%--
              <th>节点</th>
            <th>意见</th>

            <!--xwj for td2104 20050825 
            <th>操作者</th>
            <th>时间</th>
            -->
			--%>
            <%--added by xwj for td2104 on 2005-08-1--%>
            <%--              
            <th>操作</th>
            <th>接收人</th>
			--%>
            <th><%=SystemEnv.getHtmlLabelName(15586,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(504,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(104,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(15525,languageidfromrequest)%></th>
            <%--update by fanggsh for TD4313 on 2006-05-16 end--%>
          </tr>
		 <%--<tr class="line2"><th colspan="6"></th></tr>//Modefied by xwj for td2104 on 2005-05-12--%>

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
RecordSetLog.executeSql("select nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" order by receivedate desc ,receivetime desc");

if(RecordSetLog.next()){
viewNodeId = RecordSetLog.getString("nodeid");
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

//处理相关流程的查看权限

if(desrequestid!=0)
{
//System.out.print("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
	RecordSet1.executeSql("select workflowid from workflow_requestbase where requestid = "+desrequestid);
	if(RecordSet1.next()){
		WFManager.setWfid(RecordSet1.getInt("workflowid"));
		WFManager.getWfInfo();
	}
	String issignview = WFManager.getIssignview();
if("1".equals(issignview)){
	RecordSetLog.executeSql("select  a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid) and userid="+userid+" order by receivedate desc ,receivetime desc");
	if(RecordSetLog.next()){
	viewNodeId = RecordSetLog.getString("nodeid");
	RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
	if(RecordSetLog1.next()){
	singleViewLogIds = RecordSetLog1.getString("viewnodeids");
	}
	
	if("-1".equals(singleViewLogIds)){//全部查看
	RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+desrequestid+"))");
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
}else{
	RecordSetLog.executeSql("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
	while(RecordSetLog.next()){
	viewNodeId = RecordSetLog.getString("nodeid");
	RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
	if(RecordSetLog1.next()){
	singleViewLogIds = RecordSetLog1.getString("viewnodeids");
	}
	
	if("-1".equals(singleViewLogIds)){//全部查看
	RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+desrequestid+"))");
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
}
	
}
if(isurger.trim().equals("true")||wfmonitor.trim().equals("true")||intervenorright>0){
RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid);
while(RecordSetLog2.next()){
tempNodeId = RecordSetLog2.getString("nodeid");
if(!canViewIds.contains(tempNodeId)){
canViewIds.add(tempNodeId);
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
//RecordSet.executeProc("workflow_RequestLog_SNSave",""+requestid + procflag + "17,18");

/*----added by xwj for td2891 begin-----*/
//工作流id已经从页面获得到了，不需要从数据库中取，屏蔽掉。 mackjoe at 2006-06-12 td4491
/*
String tempWorkflowid = "-1";
String  sqlTemp ="select workflowid from workflow_requestbase where requestid ="+requestid;
RecordSet.executeSql(sqlTemp);
RecordSet.next();
tempWorkflowid = RecordSet.getString("workflowid");
*/
String sqlTemp = "select nodeid from workflow_flownode where workflowid = "+workflowid+" and nodetype = '0'";
RecordSet.executeSql(sqlTemp);
RecordSet.next();
String creatorNodeId = RecordSet.getString("nodeid");
/*----added by xwj for td2891 end-----*/
/*----added by chujun for td8883 start ----*/
WFManager.reset();
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String orderbytype = Util.null2String(WFManager.getOrderbytype());
String orderby = "desc";
String imgline="<img src=\"/images/xp/L.png\">";
if("2".equals(orderbytype)){
	orderby = "asc";
    imgline="<img src=\"/images/xp/L1.png\">";
}

/*----added by chujun for td8883 end ----*/
WFLinkInfo.setRequest(request);
WFLinkInfo.setIsprint(isprint);
//ArrayList log_loglist=WFLinkInfo.getRequestLog(requestid,workflowid,viewLogIds,orderby);
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

	tempImageFileId=0;
	if(tempRequestLogId>0){
		RecordSetlog3.executeSql("select imageFileId from Workflow_FormSignRemark where requestLogId="+tempRequestLogId);
		if(RecordSetlog3.next()){
			tempImageFileId=Util.getIntValue(RecordSetlog3.getString("imageFileId"),0);
		}
	}

	lineNTdOne="line"+String.valueOf(nLogCount)+"TdOne";
    if(log_isbranche==0&&"2".equals(orderbytype)) isLight = !isLight;
if (nLogCount==3) {
%><!-- LL for QC46505 2012/09/06 -->
<!-- 
</tbody></table>
<div  id=WorkFlowDiv style="display:''"><%--xwj for td2104 on 2005-05-18--%>
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    <tbody>   -->
<%}%>
          <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%>>
           <td width="10%"><%=log_nodeimg%><%=Util.toScreen(log_nodename,languageidfromrequest)%></td>
           
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
                <tr>
                <td colspan="3">
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
                  signhead=SystemEnv.getHtmlLabelName(857,languageidfromrequest)+":";
              }else{
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
              <%}
              }
            ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
            int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
            for(int k=0;k<tempwflists.size();k++){
              if(k==0){
                  signhead=SystemEnv.getHtmlLabelName(1044,languageidfromrequest)+":";
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
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=tempshowname%></a>&nbsp
              <%}
              if(accessoryCount==1 &&!isprint&&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){%>
              <BUTTON type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>'">
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
                if(!userimg.equals("") && "0".equals(log_operatortype)){
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
	                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
               <%}
                /*----------added by xwj for td2891 begin----------- */
                else if(log_agenttype.equals("2") || log_agenttype.equals("1")){
                   
                   if(!(""+log_nodeid).equals(creatorNodeId) || ((""+log_nodeid).equals(creatorNodeId) && !WFLinkInfo.isCreateOpt(tempRequestLogId,requestid))){//非创建节点log,必须体现代理关系%>
                   <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                    -> 
				<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                      <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                  <%}
                  else{
                  String isCreator = RecordSetlog3.getString("isCreateAgenter");
                  
                  if(!isCreator.equals("1")){%>
                <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                   <%}
                  else{%>
				  <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                    -> 
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
	String operationname = RequestLogOperateName.getOperateName(""+workflowid,""+requestid,""+log_nodeid,logtype,log_operator,languageidfromrequest,log_operatedate,log_operatetime);
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
                        tempStr = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick=showallreceivedforsign('"+requestid+"','"+log_nodeid+"','"+log_operator+"','"+log_operatedate+
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
</tbody>
	</table>
<div style="width:100%;margin:0;padding:0;" id="requestlogappednDiv">
</div>
<div id='WorkFlowLoddingDiv_<%=requestid %>' style="display:none;text-align:center;width:100%;height:18px;overflow:hidden;">
	<img src="/images/loading2.gif" style="vertical-align: middle;">&nbsp;<span style="vertical-align: middle;line-height:100%;"><%=SystemEnv.getHtmlLabelName(19205, languageidfromrequest)%></span>
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

	tempImageFileId=0;
	if(tempRequestLogId>0){
		RecordSetlog3.executeSql("select imageFileId from Workflow_FormSignRemark where requestLogId="+tempRequestLogId);
		if(RecordSetlog3.next()){
			tempImageFileId=Util.getIntValue(RecordSetlog3.getString("imageFileId"),0);
		}
	}

	lineNTdOne="line"+String.valueOf(nLogCount)+"TdOne";
    if(log_isbranche==0&&"2".equals(orderbytype)) isLight = !isLight;
if (nLogCount==3) {
%>
<!-- LL for QC46505 -->
<!-- </tbody></table>
<div  id=WorkFlowDiv style="display:''"><%--xwj for td2104 on 2005-05-18--%>
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    <tbody> -->
<%}%>
          <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%>>
           <td width="10%"><%=log_nodeimg%><%=Util.toScreen(log_nodename,languageidfromrequest)%></td>
           
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
                  signhead=SystemEnv.getHtmlLabelName(857,languageidfromrequest)+":";
              }else{
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
              <%}
              }
            ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
            int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
            for(int k=0;k<tempwflists.size();k++){
              if(k==0){
                  signhead=SystemEnv.getHtmlLabelName(1044,languageidfromrequest)+":";
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
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:pointer" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=tempshowname%></a>&nbsp
              <%}
              if(accessoryCount==1 &&!isprint&&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){
              %>
              <BUTTON type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>'">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,languageidfromrequest)%>	(<%=docImagefileSize/1000%>K)
                  </BUTTON>
              <%}%>
            </td>
          </tr><%}}%>
          </tbody>
          </table><%}%>
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
                if(!userimg.equals("") && "0".equals(log_operatortype)){
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
            <%if(isprint==false)
            {
                if(!log_agenttype.equals("2")){%>
				<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
	                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
               <%}
                /*----------added by xwj for td2891 begin----------- */
                else if(log_agenttype.equals("2")){
                   
                   if(!(""+log_nodeid).equals(creatorNodeId) || ((""+log_nodeid).equals(creatorNodeId) && !WFLinkInfo.isCreateOpt(tempRequestLogId,requestid))){//非创建节点log,必须体现代理关系%>
                   
                    <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                    -> 
                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)+SystemEnv.getHtmlLabelName(24213,languageidfromrequest)%></a>
                   
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
                  if(!RecordSetlog3.next()){
                      %>
                       <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                      <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                  <%}
                  else{
                  String isCreator = RecordSetlog3.getString("isCreateAgenter");
                  
                  if(!isCreator.equals("1")){%>
                
                     <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                   <%}
                  else{%>
                    <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                    -> 
                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
  <!-- modify by xhheng @20050304 for TD 1691 -->
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
	String operationname = RequestLogOperateName.getOperateName(""+tempworkflowid,""+requestid,""+log_nodeid,logtype,log_operator,languageidfromrequest,log_operatedate,log_operatetime);
	%>
	<%=operationname%>
<%
lineNTdTwo="line"+String.valueOf(nLogCount)+"TdTwo"+Util.getRandom();
%>
            </td>

          <td id="<%=lineNTdTwo%>">
              <%
                String tempStr ="";
                if(log_receivedPersons.length()>0) tempStr = Util.toScreen(log_receivedPersons.substring(0,log_receivedPersons.length()-1),languageidfromrequest);
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
                                "','"+log_operatetime+"','"+lineNTdTwo+"','"+log_logtype+"',"+log_destnodeid+") >"+SystemEnv.getHtmlLabelName(89,languageidfromrequest)+"</span>";
                }
				}
              %>
              <%=tempStr%>
          </td>
          </tr>

          <%
	if(log_isbranche==0&&!"2".equals(orderbytype)) isLight = !isLight;
}}requestid = initrequestid;
%>


</tbody></table>
</div>

<script language="javascript">
function openSignPrint() {
  var redirectUrl = "PrintRequest.jsp?requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=loga_urger%>&ismonitor=<%=loga_monitor%>" ;
  <%//解决相关流程打印权限问题
  String wflinkno = Util.null2String((String) session.getAttribute(requestid+"wflinkno"));
  if(!wflinkno.equals("")){
  %>
  redirectUrl = "PrintRequest.jsp?requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&isrequest=1&wflinkno=<%=wflinkno%>&urger=<%=loga_urger%>&ismonitor=<%=loga_monitor%>";
  <%}%>
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
szFeatures +="toolbar=yes," ;
  szFeatures +="scrollbars=yes," ;

  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}
var showTableDiv  = $GetEle('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("div");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = $GetEle("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.top=pTop;
     message_Div1.style.left=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
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
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,languageidfromrequest)%>");
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
function displaydiv_1()
{
    if(WorkFlowDiv.style.display == ""){
        WorkFlowDiv.style.display = "none";
        //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,languageidfromrequest)%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,languageidfromrequest)%></span>";
    }
    else{
        WorkFlowDiv.style.display = "";
        //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,languageidfromrequest)%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,languageidfromrequest)%></span>";
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
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,languageidfromrequest)%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,languageidfromrequest)%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM>maxUploadImageSize) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,languageidfromrequest)%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,languageidfromrequest)%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,languageidfromrequest)%>");
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
    $GetEle(accname+'_num').value=parseInt($GetEle(accname+'_num').value)+1;
    ncol = $GetEle(accname+'_tab').cols;
    oRow = $GetEle(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          oCell.colSpan=3;
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this,"+maxsize+")'> (<%=SystemEnv.getHtmlLabelName(18976,languageidfromrequest)%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,languageidfromrequest)%>) ";
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

function nodechange(value){
    if(value==""){
        $GetEle("Intervenorid").value="";
        $GetEle("Intervenorspan").innerHTML="<BUTTON type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><img src='/images/BacoError.gif' align=absmiddle>";
        $GetEle("submitNodeIdspan").innerHTML="<img src='/images/BacoError.gif' align=absmiddle>";
    }else{
        var nodeids=value.split("_");
        var selnodeid=nodeids[0];
        var selnodetype=nodeids[1];
        if(selnodetype==0){
            $GetEle("Intervenorid").value="<%=creater%>";
            $GetEle("Intervenorspan").innerHTML="<BUTTON type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><A href='javaScript:openhrm(<%=creater%>);' onclick='pointerXY(event);'><%=creatername%></a>";
        }else{
        rightMenu.style.display="none";
        $GetEle("workflownextoperatorfrm").src="/workflow/request/WorkflowNextOperator.jsp?requestid=<%=requestid%>&intervenorright=<%=intervenorright%>&workflowid=<%=workflowid%>"+
                "&formid=<%=formid%>&isbill=<%=isbill%>&billid=<%=billid%>&creater=<%=creater%>&creatertype=<%=creatertype%>&nodeid="+selnodeid+"&nodetype="+selnodetype;
        }
        $GetEle("submitNodeIdspan").innerHTML="";
    }
}
</script>

<script type="text/javascript">

function onShowMutiHrm(spanname,inputename) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + $GetEle(inputename).value);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
            resourceids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
            resourcename = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
            sHtml = "";
            $G(inputename).value = resourceids;
            
            var idArray = resourceids.split(",");
            var nameArray = resourcename.split(",");
            for (var i=0; i<idArray.length; i++ ) {
	            var curid = idArray[i];
	            var curname = nameArray[i];
	            sHtml = sHtml + "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
            }
            sHtml = "<BUTTON type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button>" + sHtml;
            $G(spanname).innerHTML = sHtml;
        } else {
            $G(spanname).innerHTML ="<BUTTON type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><img src='/images/BacoError.gif' align=absmiddle>";
            $G(inputename).value = "";
        }
    }
}


function onShowSignBrowser(url,linkurl,inputname,spanname,type1) {
	var tmpids = $G(inputname).value;
	var id = null;
    if (type1 == 37) {
    	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url + "?documentids=" + tmpids);
    } else {
    	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url + "?resourceids=" + tmpids);
    }

    if (id) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
            resourceids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
            resourcename = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
            sHtml = "";
            $G(inputename).value = resourceids;
            
            var idArrya = resourceids.split(",");
            var nameArray = resourcename.split(",");
            for (var i=0; i<idArray.length; i++ ) {
	            var curid = idArray[i];
	            var curname = nameArray[i];
	            sHtml = sHtml + "<a href="+ linkurl + curid + " target='_blank'>" + curname + "</a>+nbsp";
            }
            $G(spanname).innerHTML = sHtml;
        } else {
            $G(spanname).innerHTML ="";
            $G(inputename).value = "";
        }
    }
}

</script>
<!-- 
<script language="VBScript">
sub onShowMutiHrm(spanname,inputename)
		tmpids = $GetEle(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					$GetEle(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<A href='javaScript:openhrm("&curid&");' onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
					wend
					sHtml = "<BUTTON type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button>"&sHtml&"<A href='javaScript:openhrm("&resourceids&");' onclick='pointerXY(event);'>"&resourcename&"</a>"
					$GetEle(spanname).innerHtml = sHtml

				else
					$GetEle(spanname).innerHtml ="<BUTTON type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><img src='/images/BacoError.gif' align=absmiddle>"
					$GetEle(inputename).value=""
				end if
			end if
end sub
sub onShowSignBrowser(url,linkurl,inputname,spanname,type1)
    tmpids = $GetEle(inputname).value
    if type1=37 then
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?documentids="&tmpids)
    else
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?resourceids="&tmpids)
    end if
        if NOT isempty(id1) then
		   if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					$GetEle(inputname).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_blank'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_blank'>"&resourcename&"</a>&nbsp"
					$GetEle(spanname).innerHtml = sHtml

		else
				    $GetEle(spanname).innerHtml = empty
					$GetEle(inputname).value=""
        end if
      end if
end sub      
</script>
 -->
<script type="text/javascript">
function  showAllSignLog2(workflowid,requestid,viewLogIds,orderby, pageNumber, targetEle, requestLogDataIsEnd, WorkFlowLoddingDiv, maxRequestLogId) {
	var saslrtn = 0;
	jQuery("#" + WorkFlowLoddingDiv).show();
	var crurrentPageNumber = pageNumber;
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowViewSignMore.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("workflowid="+workflowid+"&requestid="+requestid+"&languageid=<%=languageidfromrequest %>&desrequestid=<%=desrequestid%>&userid=<%=userid%>&isprint=<%=isprint%>&isOldWf=<%=isOldWf%>&viewLogIds="+viewLogIds+"&orderbytype=<%=orderbytype%>&creatorNodeId=<%=creatorNodeId%>&orderby="+orderby + "&pgnumber=" + crurrentPageNumber + "&maxrequestlogid=" + maxRequestLogId + "&wflog" + new Date().getTime() + "=" + "&wfsignlddtcnt=<%=wfsignlddtcnt%>");
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
//primaryWfLogLoadding();

window.onscroll = function () {
	if (document.body.scrollTop + document.body.offsetHeight + 800 >= document.body.scrollHeight ) {
		primaryWfLogLoadding();
	}
};

jQuery(document).ready(function () {
	primaryWfLogLoadding();
});
</script>