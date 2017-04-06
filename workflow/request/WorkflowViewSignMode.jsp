<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.general.TimeUtil"%><!--added by xwj for td2891-->
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.BaseBean" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
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
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<%

int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int languageidfromrequest = Util.getIntValue(request.getParameter("languageid"));

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int desrequestid=Util.getIntValue(request.getParameter("desrequestid"),0);
int userid=Util.getIntValue(request.getParameter("userid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
boolean isprint = Util.null2String(request.getParameter("isprint")).equalsIgnoreCase("true") ;
String isOldWf=Util.null2String(request.getParameter("isOldWf"));
boolean isOldWf_ = false;
if(isOldWf.trim().equals("true")) isOldWf_=true;
boolean isurger=false;                  //督办人可查看
boolean wfmonitor=false;                //流程监控人
int logintype=Util.getIntValue(request.getParameter("logintype"),1);
isurger=WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,logintype);
int ismonitor=Util.getIntValue(request.getParameter("ismonitor"),0);
if(ismonitor==1) wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid);
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
    rssign.executeSql("select 1 from Workflow_SubwfSet where mainworkflowid = "+mainworkflowid+" and subworkflowid ="+workflowid+" and isread = 1 union select 1 from Workflow_TriDiffWfDiffField a, Workflow_TriDiffWfSubWf b where a.id=b.triDiffWfDiffFieldId and b.isRead=1 and a.mainworkflowid="+mainworkflowid+" and b.subWorkflowId="+workflowid);

    if(rssign.getCounts()==0){
       allrequestid.remove(index);
	   allrequestname.remove(index);
    }
  }
}

session.setAttribute("canviewwf",canviewwf);
int intervenorright=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"intervenorright"),0);
String showDocTab_edit="";
String showWorkflowTab_edit="";
String showUploadTab_edit="";
RecordSetLog.execute("select showDocTab,showWorkflowTab,showUploadTab from workflow_base where id="+workflowid);
if(RecordSetLog.next()){
    showDocTab_edit=Util.null2String(RecordSetLog.getString("showDocTab"));
    showWorkflowTab_edit=Util.null2String(RecordSetLog.getString("showWorkflowTab"));
    showUploadTab_edit=Util.null2String(RecordSetLog.getString("showUploadTab"));
}
%>

<%
User user2 = HrmUserVarify.getUser (request , response) ;
if(user2 == null)  return ;
String wfid1 = String.valueOf(workflowid);
String ndid1 = String.valueOf(nodeid);

%>
<!-- added end. -->
<%
if(!isprint&&(showDocTab_edit.equals("1")||showUploadTab_edit.equals("1")||showWorkflowTab_edit.equals("1"))){
%>
<table style="width:100%;height:100%" border=0 cellspacing=0 cellpadding=0  scrolling=no >
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
	  <%=SystemEnv.getHtmlLabelName(1380,languageidfromrequest)%><%=SystemEnv.getHtmlLabelName(504,languageidfromrequest)%></td>
	  <%if(showDocTab_edit.equals("1")){%><td nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'"  onclick='signtabchange(1)'>
	  <%=SystemEnv.getHtmlLabelName(857,languageidfromrequest)%></td><%}%>
      <%if(showWorkflowTab_edit.equals("1")){%><td nowrap name="oTDtype_2"  id="oTDtype_2" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'"  onclick="signtabchange(2)">
	  <%=SystemEnv.getHtmlLabelName(1044,languageidfromrequest)%></td><%}%>
	  <%if(showUploadTab_edit.equals("1")){%><td nowrap name="oTDtype_3"  id="oTDtype_3" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'"  onclick='signtabchange(3)'>
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
        document.getElementById("signid").style.display='';
        document.getElementById("oTDtype_0").style.fontWeight="bold";
        document.getElementById("oTDtype_0").background="/images/tab.active2.png";
        <%if(showDocTab_edit.equals("1")){%>
        document.getElementById("SignTabDoc").style.display='none';
        document.getElementById("oTDtype_1").style.fontWeight="normal";
        document.getElementById("oTDtype_1").background="/images/tab2.png";
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        document.getElementById("SignTabWF").style.display='none';
        document.getElementById("oTDtype_2").style.fontWeight="normal";
        document.getElementById("oTDtype_2").background="/images/tab2.png";
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        document.getElementById("SignTabUpload").style.display='none';
        document.getElementById("oTDtype_3").style.fontWeight="normal";
        document.getElementById("oTDtype_3").background="/images/tab2.png";
        <%}%>
    }else if(tabindex==1){
        document.getElementById("signid").style.display='none';
        document.getElementById("oTDtype_0").style.fontWeight="normal";
        document.getElementById("oTDtype_0").background="/images/tab2.png";
        <%if(showDocTab_edit.equals("1")){%>
        document.getElementById("SignTabDoc").style.display='';
        document.getElementById("oTDtype_1").style.fontWeight="bold";
        document.getElementById("oTDtype_1").background="/images/tab.active2.png";
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        document.getElementById("SignTabWF").style.display='none';
        document.getElementById("oTDtype_2").style.fontWeight="normal";
        document.getElementById("oTDtype_2").background="/images/tab2.png";
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        document.getElementById("SignTabUpload").style.display='none';
        document.getElementById("oTDtype_3").style.fontWeight="normal";
        document.getElementById("oTDtype_3").background="/images/tab2.png";
        <%}%>
        if(tabdocload==1){
            loadsigndoc(<%=initrequestid%>,<%=workflowid%>,<%=userid%>,<%=languageidfromrequest%>);
        }
    }else if(tabindex==2){
        document.getElementById("signid").style.display='none';
        document.getElementById("oTDtype_0").style.fontWeight="normal";
        document.getElementById("oTDtype_0").background="/images/tab2.png";
        <%if(showDocTab_edit.equals("1")){%>
        document.getElementById("SignTabDoc").style.display='none';
        document.getElementById("oTDtype_1").style.fontWeight="normal";
        document.getElementById("oTDtype_1").background="/images/tab2.png";
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        document.getElementById("SignTabWF").style.display='';
        document.getElementById("oTDtype_2").style.fontWeight="bold";
        document.getElementById("oTDtype_2").background="/images/tab.active2.png";
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        document.getElementById("SignTabUpload").style.display='none';
        document.getElementById("oTDtype_3").style.fontWeight="normal";
        document.getElementById("oTDtype_3").background="/images/tab2.png";
        <%}%>
        if(tabwfload==1){
            loadsignwf(<%=initrequestid%>,<%=workflowid%>,<%=userid%>,<%=languageidfromrequest%>);
        }
    }else if(tabindex==3){
        document.getElementById("signid").style.display='none';
        document.getElementById("oTDtype_0").style.fontWeight="normal";
        document.getElementById("oTDtype_0").background="/images/tab2.png";
        <%if(showDocTab_edit.equals("1")){%>
        document.getElementById("SignTabDoc").style.display='none';
        document.getElementById("oTDtype_1").style.fontWeight="normal";
        document.getElementById("oTDtype_1").background="/images/tab2.png";
        <%}%>
        <%if(showWorkflowTab_edit.equals("1")){%>
        document.getElementById("SignTabWF").style.display='none';
        document.getElementById("oTDtype_2").style.fontWeight="normal";
        document.getElementById("oTDtype_2").background="/images/tab2.png";
        <%}%>
        <%if(showUploadTab_edit.equals("1")){%>
        document.getElementById("SignTabUpload").style.display='';
        document.getElementById("oTDtype_3").style.fontWeight="bold";
        document.getElementById("oTDtype_3").background="/images/tab.active2.png";
        <%}%>
        if(tabupload==1){
            loadsignupload(<%=initrequestid%>,<%=workflowid%>,<%=userid%>,<%=languageidfromrequest%>);
        }
    }
}
function loadsigndoc(requestid,workflowid,userid,languageid){
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSignDocAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid+"&isprint=<%=isprint%>";
    ajax.send(parpstr);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.getElementById("SignTabDoc").innerHTML=ajax.responseText;
                tabdocload=0;
            }catch(e){}
        }
    }
}
function loadsignwf(requestid,workflowid,userid,languageid){
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSignWFAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid+"&isprint=<%=isprint%>";
    ajax.send(parpstr);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.getElementById("SignTabWF").innerHTML=ajax.responseText;
                tabwfload=0;
            }catch(e){}
        }
    }
}
function loadsignupload(requestid,workflowid,userid,languageid){
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSignUploadAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var parpstr="requestid="+requestid+"&workflowid="+workflowid+"&userid="+userid+"&languageid="+languageid+"&isprint=<%=isprint%>";
    ajax.send(parpstr);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.getElementById("SignTabUpload").innerHTML=ajax.responseText;
                tabupload=0;
            }catch(e){}
        }
    }
}
</script>
<%
}
%>
<div ID='signid'>

        <table class=liststyle cellspacing=1 style="margin:0;padding:0;">
          <colgroup>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
          <tbody>
          <tr class=HeaderForWF>
            <th><%=SystemEnv.getHtmlLabelName(15586,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(504,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(104,languageidfromrequest)%></th>
            <th><%=SystemEnv.getHtmlLabelName(15525,languageidfromrequest)%></th>
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
	RecordSet1.executeSql("select workflowid from workflow_requestbase where requestid = "+desrequestid);
	if(RecordSet1.next()){
		WFManager.setWfid(RecordSet1.getInt("workflowid"));
		WFManager.getWfInfo();
	}
	String issignview = WFManager.getIssignview();
	if("1".equals(issignview)){
		//System.out.print("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
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
		//System.out.print("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
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
if(isurger || wfmonitor||intervenorright>0){//全部查看
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
//ArrayList log_loglist=WFLinkInfo.getRequestLog(requestid,workflowid,viewLogIds,orderby);
ArrayList log_loglist = new ArrayList();

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
    tempRequestLogId=0;
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
</tbody></table>
<div  id=WorkFlowDiv style="display:''">
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    <tbody>
<%}%>
          <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%>>
           <td width="10%"><%=log_nodeimg%><%=Util.toScreen(log_nodename,languageidfromrequest)%></td>

           <td width=50%>
							<table width=100%>
			  <tr>
             <td colspan=2>
            	<%if(!log_logtype.equals("t")){%>
<%--if(tempIsFormSignature.equals("1")){--%>
<%if(tempRequestLogId>0&&tempImageFileId>0){%>
		<jsp:include page="/workflow/request/WorkflowLoadSignatureRequestLogId.jsp">
			<jsp:param name="tempRequestLogId" value="<%=tempRequestLogId%>" />
		</jsp:include>
<%}else{
		String tempremark = log_remark;
		tempremark = Util.StringReplace(tempremark,"&lt;br&gt;","<br>");
	%>
              <%=Util.toScreen(tempremark,languageidfromrequest)%>
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
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp;
            </td>
          </tr><%}
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
              String temprequestname="<a style=\"cursor:hand\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+tempwflists.get(k)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)tempwflists.get(k))+"</a>";
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
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=tempshowname%></a>&nbsp
              <%}
              if(accessoryCount==1 &&!isprint&&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){
              %>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
	<a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'>
              <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
            <%}else{%>
			<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
            <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
            /
			<%}%>
              <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
            <%}%>

<%}else if(log_operatortype.equals("1")){%>
  <!-- modify by xhheng @20050304 for TD 1691 -->
  <%if(isprint==false){%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>&requestid=<%=requestid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),languageidfromrequest)%></a>
  <%}else{%>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
	                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
               <%}
                /*----------added by xwj for td2891 begin----------- */
                else if(log_agenttype.equals("2")){

                   if(!(""+log_nodeid).equals(creatorNodeId) || ((""+log_nodeid).equals(creatorNodeId) && !WFLinkInfo.isCreateOpt(tempRequestLogId,requestid))){//非创建节点log,必须体现代理关系%>
<%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                    ->
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                      <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                  <%}
                  else{
                  String isCreator = RecordSetlog3.getString("isCreateAgenter");

                  if(!isCreator.equals("1")){%>
<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                   <%}
                  else{%>
				  <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                    ->
					<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
			   <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
               /
			   <%}%>
	                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
               <%}
                else if(log_agenttype.equals("2")){%>
				<%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
/
<%}%>
                  <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                ->
				<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
               /
			   <%}%>
                <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)+SystemEnv.getHtmlLabelName(24213,languageidfromrequest)%></a>

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

      <%-- xwj for td2104 on 20050802 end --%>


            </td>
            </tr>
            <tr>
            <td>&nbsp;</td>
           <td align=right><%=Util.toScreen(log_operatedate,languageidfromrequest)%>
              &nbsp<%=Util.toScreen(log_operatetime,languageidfromrequest)%>
              </td>
            </tr>
             </table>
             <!--xwj for td2104 20050825-->
            <td>
              <%
	String logtype = log_logtype;
	String operationname = RequestLogOperateName.getOperateName(""+workflowid,""+requestid,""+log_nodeid,logtype,log_operator,languageidfromrequest,log_operatedate,log_operatetime);
	%>
	<%=operationname%>
<%
lineNTdTwo="line"+String.valueOf(nLogCount)+"TdTwo";
%>
            </td>
                      <%--added by xwj for td2104 on 2005-8-1--%>
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
				{}
                if (!showoperators.equals("1")) {
                if(!"".equals(tempStr) && tempStr != null){
                        tempStr = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick=showallreceived('"+log_operator+"','"+log_operatedate+
                                "','"+log_operatetime+"','"+lineNTdTwo+"','"+log_nodeid+"','"+logtype+"',"+log_destnodeid+") >"+SystemEnv.getHtmlLabelName(89,languageidfromrequest)+"</span>";
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
	<img src="/images/loading2.gif" style="vertical-align: middle;">&nbsp;<span style="vertical-align: middle;line-height:100%;"><%=SystemEnv.getHtmlLabelName(19205,languageidfromrequest)%></span>
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
</tbody></table>
<div  id=WorkFlowDiv style="display:''"><%--xwj for td2104 on 2005-05-18--%>
    <table class=liststyle cellspacing=1  >
    <colgroup>
          <col width="10%"><col width="50%"> <col width="10%">  <col width="30%">
    <tbody>
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
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp;
            </td>
          </tr><%}
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
              String temprequestname="<a style=\"cursor:hand\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+tempwflists.get(k)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)tempwflists.get(k))+"</a>";
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
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=tempshowname%></a>&nbsp
              <%}
              if(accessoryCount==1 &&!isprint&&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){%>
              <BUTTON class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>'">
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
	<a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'>
              <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
            <%}else{%>
			<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
            <%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%>
            /
			<%}%>
              <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%>
            <%}%>

<%}else if(log_operatortype.equals("1")){%>
  <!-- modify by xhheng @20050304 for TD 1691 -->
  <%if(isprint==false){%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=log_operator%>&requestid=<%=requestid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(log_operator),languageidfromrequest)%></a>
  <%}else{%>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
	                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
               <%}
                /*----------added by xwj for td2891 begin----------- */
                else if(log_agenttype.equals("2")){
                   
                   if(!(""+log_nodeid).equals(creatorNodeId) || ((""+log_nodeid).equals(creatorNodeId) && !WFLinkInfo.isCreateOpt(tempRequestLogId,requestid))){//非创建节点log,必须体现代理关系%>
                   
                    <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
	               /
				   <%}%>
                    <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                    -> 
                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                      <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                  <%}
                  else{
                  String isCreator = RecordSetlog3.getString("isCreateAgenter");
                  
                  if(!isCreator.equals("1")){%>
                
                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_operator%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%></a>
                   <%}
                  else{%>
                    <%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(log_agentorbyagentid),languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%></a>
	               /
				   <%}%>
                   <a href="javaScript:openhrm(<%=log_agentorbyagentid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%></a>
                    -> 
                    <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
	               <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(log_operatorDept,languageidfromrequest)%>" target="_blank"><%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%></a>
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
			   <%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
               <%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%>
               /
			   <%}%>
	                   <%=Util.toScreen(ResourceComInfo.getResourcename(log_operator),languageidfromrequest)%>
               <%}
                else if(log_agenttype.equals("2")){%>
				<%if(!"0".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(ResourceComInfo.getDepartmentID(log_agentorbyagentid)))){%>
<%=Util.toScreen(DepartmentComInfo1.getDepartmentname(ResourceComInfo.getDepartmentID(log_agentorbyagentid)),languageidfromrequest)%>
/
<%}%>
                  
                  <%=Util.toScreen(ResourceComInfo.getResourcename(log_agentorbyagentid),languageidfromrequest)+SystemEnv.getHtmlLabelName(24214,languageidfromrequest)%>
                -> 
                	<%if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){%>
               <%=Util.toScreen(DepartmentComInfo1.getDepartmentname(log_operatorDept),languageidfromrequest)%>
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
                if(log_receivedPersons.length()>0) tempStr =Util.toScreen(log_receivedPersons.substring(0,log_receivedPersons.length()-1),languageidfromrequest);
		  String showoperator="";
				try
				{
				showoperator=RequestDefaultComInfo.getShowoperator(""+userid);
				}
				catch (Exception eshow)
				{}
                if (!showoperator.equals("1")) {
                if(!"".equals(tempStr) && tempStr != null){
                        tempStr = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick=showallreceivedforsign('"+requestid+"','"+log_nodeid+"','"
                                +log_operator+"','"+log_operatedate+"','"+log_operatetime+"','"+lineNTdTwo+"','"+logtype+"',"+log_destnodeid+") >"+SystemEnv.getHtmlLabelName(89,languageidfromrequest)+"</span>";
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
</div>

<SCRIPT language="javascript">
function windowOnloadViewSignMode(){
    /*
    imagehtml = document.getElementById("signid").innerHTML;
    window.parent.document.getElementById("IMAGETDSign").innerHTML = imagehtml;
    */
}

if (window.addEventListener){
    window.addEventListener("load", windowOnloadViewSignMode, false);
}else if (window.attachEvent){
    window.attachEvent("onload", windowOnloadViewSignMode);
}else{
    window.onload=windowOnloadViewSignMode;
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
    //showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,languageidfromrequest)%>");
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowReceiviedPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&viewnodeIds="+viewLogIds+"&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            document.getElementById(returntdid).innerHTML = ajax.responseText;
            //showTableDiv.style.display='none';
            oIframe.style.display='none';
            }catch(e){}
        }
    }
}
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
    ajax.send("workflowid="+workflowid+"&requestid="+requestid+"&languageid=<%=languageidfromrequest%>&desrequestid=<%=desrequestid%>&userid=<%=userid%>&isprint=<%=isprint%>&isOldWf=<%=isOldWf%>&viewLogIds="+viewLogIds+"&orderbytype=<%=orderbytype%>&creatorNodeId=<%=creatorNodeId%>&orderby="+orderby + "&pgnumber=" + crurrentPageNumber + "&maxrequestlogid=" + maxRequestLogId + "&wflog" + new Date().getTime() + "=" + "&wfsignlddtcnt=<%=wfsignlddtcnt%>" + "&wfsignlddtcnt=<%=wfsignlddtcnt%>");
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
    				 "</colgroup>"+jQuery.trim(ajax.responseText)+
    				 "</table>"
    				 
					jQuery("#requestlogappednDiv").append(tableStr);
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
