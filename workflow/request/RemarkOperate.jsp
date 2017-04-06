<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.workflow.request.RequestAnnexUpload,weaver.share.ShareinnerInfo" %>
<%--td3641 xwj 20060214--%>
 <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RequestAddShareInfo" class="weaver.workflow.request.RequestAddShareInfo" scope="page" />
<%--  added by xwj on 22005-08-01 for td2104  --%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td3641 on 20060214 --%>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/><!--xwj for td3641 on 20060214-->
<jsp:useBean id="sendMail" class="weaver.workflow.request.MailAndMessage" scope="page"/><!--xwj for td3641 on 20060214-->
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="RemarkOperaterManager" class="weaver.workflow.request.RemarkOperaterManager" scope="page" />
<jsp:useBean id="RequestAddOpinionShareInfo" class="weaver.workflow.request.RequestAddOpinionShareInfo" scope="page" />
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />

<%
FileUpload fu = new FileUpload(request);
String operate=Util.null2String(fu.getParameter("operate"));
String requestid=Util.null2String(fu.getParameter("requestid"));
String ifchangstatus=Util.null2String(basebean.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));

char flag=Util.getSeparator() ;
String para="";
String usertype="0";//被转发人肯定为人力资源，因此类型默认为“0”TD9836
String userid=user.getUID()+"";
String remark = Util.null2String(fu.getParameter("remark"));
String signdocids = Util.null2String(fu.getParameter("signdocids"));
String signworkflowids = Util.null2String(fu.getParameter("signworkflowids"));
String clientip=fu.getRemoteAddr();
int requestLogId = Util.getIntValue(fu.getParameter("workflowRequestLogId"),0);
String logintype = user.getLogintype();
//if(logintype.equals("2")){
//   usertype="1";
//}
String operatortype = "";
    
if(logintype.equals("1"))  operatortype = "0";
if(logintype.equals("2"))  operatortype = "1";

Calendar today = Calendar.getInstance();
String CurrentDate = "";
String CurrentTime = "";
try{
	rs.executeProc("GetDBDateAndTime", "");
	if(rs.next()){
		CurrentDate = rs.getString("dbdate");
		CurrentTime = rs.getString("dbtime");
	}
}catch(Exception e){
	CurrentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	CurrentTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2) ;
}                      
int currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"nodeid"),0);
int workflowid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"workflowid"),0);
String requestname = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestname"));
String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");      
//all remark resource 
int detailnum=Util.getIntValue(fu.getParameter("totaldetail"),0);
ArrayList resourceids = new ArrayList();
ArrayList agenterids=new ArrayList();
String resourceid="";
int i=0;


String tmpid=Util.fromScreen(fu.getParameter("field5"),user.getLanguage());
if(!tmpid.equals("")){
    String[] tmpids=Util.TokenizerString2(tmpid,",");
    for(int m=0 ;m<tmpids.length;m++){
        resourceids.add(tmpids[m]);
    }
}
ArrayList rightResourceidList = new ArrayList();
rs.execute("select distinct userid from workflow_currentoperator where usertype=0 and requestid="+requestid);
while(rs.next()){
	int userid_tmp = Util.getIntValue(rs.getString("userid"), 0);
	if(resourceids.contains(""+userid_tmp) == false){
		rightResourceidList.add(""+userid_tmp);
	}
}

int wfcurrrid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"wfcurrrid"));
String messageid="";
/* ---- xwj for td2104 on 20050802 begin-----  */	

if(operate.equals("save")&&wfcurrrid>0){


   /* --------------add by xwj for td3641 begin -----*/
       String tempHrmIds = "";//xwj td2302
    String agentSQL = "";//xwj td2302
    boolean isbeAgent=false;
    String agenterId="";
    String beginDate="";
    String beginTime="";
   String endDate="";
   String endTime="";
   String currentDate="";
   String currentTime="";
   String agenttype = "";
   /* --------------add by xwj for td3641 end -----*/


    WFForwardManager.setForwardRight(fu,Util.getIntValue(requestid),workflowid,currentnodeid,Util.getIntValue(userid));
    int showorder = 1;    
	for(i=0;i<resourceids.size();i++){
       int BeForwardid=0;
	   isbeAgent=false;
      //modify by mackjoe at 2005-09-28 td2865
      resourceid=(String)resourceids.get(i);
      String selectsql="select isremark,id from workflow_currentoperator where requestid="+requestid+" and isremark in('0','1','5','7') and userid="+resourceid+" and usertype=0 order by isremark";
      RecordSet.executeSql(selectsql);
      boolean isexist=false;
      if(RecordSet.next()){
          isexist=true;
      }
      //end by mackjoe
	  RecordSet.executeSql("select max(showorder) as maxshow from workflow_currentoperator where nodeid = " + currentnodeid + " and isremark in ('0','1','4') and requestid = "+ requestid);
		if(RecordSet.next()){
		showorder = RecordSet.getInt("maxshow") + 1;
		}		
			/* -----------   xwj for td3641 begin -----------*/
                            agentSQL = " select * from workflow_Agent where workflowId="+ workflowid +" and beagenterId=" + resourceid + 
                     " and agenttype = '1' " +  
                     " and ( ( (endDate = '" + CurrentDate + "' and (endTime='' or endTime is null))" + 
                     " or (endDate = '" + CurrentDate + "' and endTime > '" + CurrentTime + "' ) ) " + 
                     " or endDate > '" + CurrentDate + "' or endDate = '' or endDate is null)" +
                     " and ( ( (beginDate = '" + CurrentDate + "' and (beginTime='' or beginTime is null))" + 
	             " or (beginDate = '" + CurrentDate + "' and beginTime < '" + CurrentTime + "' ) ) " + 
	             " or beginDate < '" + CurrentDate + "' or beginDate = '' or beginDate is null)"; //agentSQL is added by xwj for td2302
                        
                         rs.execute(agentSQL);
                         
                        if(rs.next()){
                        	isbeAgent=true;
                        	 agenterId=rs.getString("agenterId");
                        	 beginDate=rs.getString("beginDate");
                           beginTime=rs.getString("beginTime");
                        	 endDate=rs.getString("endDate");
                        	 endTime=rs.getString("endTime");
                        	 currentDate=TimeUtil.getCurrentDateString();
                        	 currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
                        	 agenttype = rs.getString("agenttype");
                             agenterids.add(agenterId);
						}
		
        if(!isexist){
		if(isbeAgent){
		  //代理人
			para=requestid+ flag +resourceid+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "2" +
		flag + currentnodeid + flag + agenterId + flag + "1" + flag + showorder+flag+"-1";
		RecordSet.executeProc("workflow_CurrentOperator_I",para);
		//被代理人
			para=requestid+ flag +agenterId+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "1" +
		flag + currentnodeid + flag + resourceid + flag + "2" + flag + showorder+flag+"-1";
		RecordSet.executeProc("workflow_CurrentOperator_I",para);
            agentSQL="select id from workflow_CurrentOperator where requestid="+requestid+" and userid="+agenterId+" and usertype="+usertype+" and isremark='1' and nodeid="+currentnodeid+" and showorder="+showorder+" order by id desc";
		}
		else{
			para=requestid+ flag +resourceid+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "1" +
		  flag + currentnodeid + flag + -1 + flag + "0" + flag + showorder+flag+"-1";
		  RecordSet.executeProc("workflow_CurrentOperator_I",para);
            agentSQL="select id from workflow_CurrentOperator where requestid="+requestid+" and userid="+resourceid+" and usertype="+usertype+" and isremark='1' and nodeid="+currentnodeid+" and showorder="+showorder+" order by id desc";
		}
            RecordSet.execute(agentSQL);
            if(RecordSet.next()){
                BeForwardid=RecordSet.getInt("id");
            }
        }

    if(!isbeAgent){                 	 
    tempHrmIds += Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()) + ",";
	  }
	  else{
	  tempHrmIds += Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()) + "->"+ Util.toScreen(ResourceComInfo.getResourcename(agenterId),user.getLanguage())+ ",";
	  }
	  	
	/* -----------   xwj for td3641 end -----------*/
	
	//流程测试状态下转发，不提醒被转发人 START
	int istest = 0;
	try{
		rs.execute("select isvalid from workflow_base where id="+workflowid);
		if(rs.next()){
			int isvalid_t = Util.getIntValue(rs.getString("isvalid"), 0);
			if(isvalid_t == 2){
				istest = 1;
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	if (istest != 1) {
        // 2004-05-19 刘煜修改， 在转发的时候加入对被转发人的工作流提醒（有新的工作流）, 被转发人肯定为人力资源，因此类型默认为“0”
       if(isbeAgent){
       PoppupRemindInfoUtil.insertPoppupRemindInfo(Integer.parseInt(agenterId),0,"0",Integer.parseInt(requestid),requestname);//xwj for td3450 20060111
       }
       else{
       PoppupRemindInfoUtil.insertPoppupRemindInfo(Integer.parseInt(resourceid),0,"0",Integer.parseInt(requestid),requestname);//xwj for td3450 20060111
       }
	}
	//流程测试状态下转发，不提醒被转发人 END
        WFForwardManager.SaveForward(Util.getIntValue(requestid),wfcurrrid,BeForwardid);
	}

    //将代理人加入人员列表，用于发送邮件通知和设置共享
    for(i=0;i<agenterids.size();i++){
        resourceids.add(agenterids.get(i));
    }
    
	String isfeedback="";
    String isnullnotfeedback="";
	RecordSet.executeSql("select isfeedback,isnullnotfeedback from workflow_flownode where workflowid="+workflowid+" and nodeid="+currentnodeid);
	if(RecordSet.next()){
		isfeedback=Util.null2String(RecordSet.getString("isfeedback"));
        isnullnotfeedback=Util.null2String(RecordSet.getString("isnullnotfeedback"));
	}
	/*
	if (!ifchangstatus.equals("")&&isfeedback.equals("1")&&((isnullnotfeedback.equals("1")&&!Util.replace(remark, "\\<script\\>initFlashVideo\\(\\)\\;\\<\\/script\\>", "", 0, false).equals(""))||!isnullnotfeedback.equals("1")))
		{
		RecordSet.executeSql("update workflow_currentoperator set viewtype =-1  where needwfback='1' and requestid=" + requestid + " and userid<>" + userid + " and viewtype=-2");
		}*/

   //发送邮件
       sendMail.setRequest(fu);
       sendMail.sendMailAndMessage(Integer.parseInt(requestid),resourceids,user);
	//加入LOG表信息
	  RecordSet.executeSql("select * from workflow_currentoperator where userid = " + userid + " and nodeid = " + currentnodeid + " and isremark in ('0','1','4') and requestid = "+ requestid+" order by showorder,receivedate,receivetime");
    int tempagentorbyagentid = -1;
    int tempagenttype = 0;
    if(RecordSet.next()){
    showorder =  RecordSet.getInt("showorder");
    tempagentorbyagentid = RecordSet.getInt("agentorbyagentid");
    tempagenttype = RecordSet.getInt("agenttype");
    if(tempagenttype<0) tempagenttype = 0;
    }
	String currentnodetype = "";
	RecordSet.executeSql("select currentnodetype from workflow_requestbase where requestid= "+requestid);
	if(RecordSet.next()){
		currentnodetype = RecordSet.getString("currentnodetype");
		if(currentnodetype.equals("3")){
			tempagentorbyagentid = -1;
			tempagenttype = 0;
		}
	}
    RequestAnnexUpload rau=new RequestAnnexUpload();
    rau.setRequest(fu);
    rau.setUser(user);
    String annexdocids=rau.AnnexUpload();
    String Procpara="";
       Procpara=requestid+"" + flag + workflowid+"" + flag + currentnodeid+"" + flag + "7" + flag 
    	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag 
    	+ clientip+flag+operatortype+flag+"0"+flag+tempHrmIds.trim() + flag + tempagentorbyagentid + flag + tempagenttype + flag + showorder+flag+annexdocids+flag+requestLogId+ flag + signdocids+flag+signworkflowids; //xwj for td1837 on 2005-05-12
    RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
    
    if(requestLogId>0){//表单签章
    	RecordSet.executeSql("select imagefileid from workflow_formsignremark where requestlogid="+requestLogId);
    	RecordSet.next();
    	int imagefileid = Util.getIntValue(RecordSet.getString("imagefileid"),0);
    	if(imagefileid>0) remark=""+requestLogId;
    }
    if (!ifchangstatus.equals("")&&isfeedback.equals("1")&&((isnullnotfeedback.equals("1")&&!Util.replace(remark, "\\<script\\>initFlashVideo\\(\\)\\;\\<\\/script\\>", "", 0, false).equals(""))||!isnullnotfeedback.equals("1")))
    {
    	RecordSet.executeSql("update workflow_currentoperator set viewtype =-1  where needwfback='1' and requestid=" + requestid + " and userid<>" + userid + " and viewtype=-2");
    }

	//处理之前节点操作人对附件的权限 TD10577 Start
	String[] docids = Util.TokenizerString2(annexdocids, ",");
	for(int cx=0; i<docids.length; i++){
		int docid_tmp = Util.getIntValue(docids[cx]);
		for(int bx=0; bx<rightResourceidList.size(); bx++){
			int rightResourceid_tmp = Util.getIntValue((String)rightResourceidList.get(bx), 0);
			try{
				ShareinnerInfo shareInfo=new ShareinnerInfo();
				shareInfo.AddShare(docid_tmp, 1, rightResourceid_tmp, 10, 1, 1, rightResourceid_tmp, "ShareinnerDoc", 1);
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	//处理之前节点操作人对附件的权限 TD10577 End

    //保存签字意见提交人当前部门
    //String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(""+userid));
    //if(!departmentid.equals("")) rs.executeSql("update workflow_requestlog set operatorDept="+departmentid+" where requestid="+requestid+" and nodeid="+currentnodeid+" and logtype='7' and operator="+userid+" and operatortype="+operatortype);  

    if(!signdocids.equals("")){
        RecordSet.executeSql("select docids from workflow_requestbase where requestid="+requestid);
        RecordSet.next();
        String newdocids = Util.null2String(RecordSet.getString("docids"));
        if(!newdocids.equals("")) newdocids = newdocids+","+signdocids;
        else newdocids = signdocids;
        RecordSet.executeSql("update workflow_requestbase set docids='"+newdocids+"' where requestid="+requestid);
    }
    RequestAddShareInfo.SetNextNodeID(currentnodeid);
    RequestAddShareInfo.addShareInfo(requestid,resourceids,WFForwardManager.getIsBeForwardModify().equals("1")?"true":"false") ;
    
    //added by pony on 2006-05-31 for Td4442
    RemarkOperaterManager.processRemark(workflowid,requestid,currentnodeid,user,fu);
    RequestAddOpinionShareInfo.processOpinionRemarkResourcesShare(workflowid,requestid,resourceids,user,currentnodeid);
    //added end.
    //RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+",lastoperatedate='"+CurrentDate+"',lastoperatetime='"+CurrentTime+"' where requestid="+requestid);
  	if(currentnodetype.equals("3"))//如果流程已归档，不修改lastoperatedate和lastoperatetime的值
   	    RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+" where requestid="+requestid);
   	else
   	    RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+",lastoperatedate='"+CurrentDate+"',lastoperatetime='"+CurrentTime+"' where requestid="+requestid);

	//TD9144 弹出转发窗口，提交转发请求后，关闭该窗口，并刷新原页面
    //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid);

}else{
    messageid="6";
}
%>
<script language=javascript>
try{
	window.opener.parent.location.href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>&message=<%=messageid%>";
	//window.opener.location.reload();
}catch(e){}
window.opener = null; 
window.open("","_self");
setTimeout("window.close()",1);
</script>