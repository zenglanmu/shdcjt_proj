<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID = -1;
    int operateLevel = 0;

    if(1 == detachable){  
        if(null == request.getParameter("subCompanyID")){
            subCompanyID=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")), -1);
        }else{
            subCompanyID=Util.getIntValue(request.getParameter("subCompanyID"),-1);
        }
        if(-1 == subCompanyID){
            subCompanyID = user.getUserSubCompany1();
        }

        session.setAttribute("managefield_subCompanyId", String.valueOf(subCompanyID));

        operateLevel= checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowManage:All", subCompanyID);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
            operateLevel=2;
        }
    }

	int workflowid = Util.getIntValue(request.getParameter("wfid"), -1);
	if(operateLevel<1 || workflowid==-1){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String formID = request.getParameter("formid");
	String isbill = request.getParameter("isbill");
	String operationType = Util.null2String(request.getParameter("operationType"));
	int errorMessage = 0;
	String sql = "";
	//System.out.println("operationType = " + operationType);
	if("add".equalsIgnoreCase(operationType)){
		int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
		int changetime = Util.getIntValue(request.getParameter("changetime"), 0);
		if(changetime == 0){
			changetime = Util.getIntValue(request.getParameter("changetimeinput"), 0);
		}
		int changemode = Util.getIntValue(request.getParameter("changemode"), 0);
		int changemode0 = Util.getIntValue(request.getParameter("changemode0"), 0);
		if(changetime == 2){
			changemode = changemode0;
		}
		int taskid = Util.getIntValue(request.getParameter("taskid"), 0);
		//System.out.println("nodeid = " + nodeid);
		//System.out.println("changetime = " + changetime);
		//System.out.println("taskid = " + taskid);
		if(nodeid==0 || changetime==0 || taskid==0){
			response.sendRedirect("/workflow/workflow/CreateWorktaskByWorkflow.jsp?ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage=0");
			return;
		}
		rs.execute("select id from workflow_createtask where wfid="+workflowid+" and nodeid="+nodeid+" and changetime="+changetime+" and taskid="+taskid);
		if(rs.next()){
			errorMessage = 1;
		}else{
			sql = "insert into workflow_createtask (wfid, nodeid, changetime, taskid, changemode) values ("+workflowid+", "+nodeid+", "+changetime+", "+taskid+", "+changemode+")";
			//System.out.println(sql);
			rs.execute(sql);
		}
	}else if("del".equalsIgnoreCase(operationType)){
		String[] checkbox1s = request.getParameterValues("checkbox1");
		String createwtids = "0";
		if(checkbox1s != null){
			for(int i=0; i<checkbox1s.length; i++){
				createwtids += ("," + checkbox1s[i]);
			}
			sql = "delete from workflow_createtask where id in (" + createwtids + ")";
			rs.execute(sql);
			sql = "delete from workflow_createtaskgroup where createtaskid in (" + createwtids + ")";
			rs.execute(sql);
			sql = "delete from workflow_createtaskdetail where createtaskid in (" + createwtids + ")";
			rs.execute(sql);
		}
	}
    response.sendRedirect("/workflow/workflow/CreateWorktaskByWorkflow.jsp?ajax=1&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill+"&errorMessage="+errorMessage);
%>