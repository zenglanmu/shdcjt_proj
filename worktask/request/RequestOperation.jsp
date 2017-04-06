<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.worktask.request.RequestShare"%>
<%@ page import="weaver.worktask.request.WorkplanCreateByRequest"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.system.SysWFLMonitor" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="requestManager" class="weaver.worktask.request.RequestManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page"/>
<%

String sql = "";
FileUpload fu = new FileUpload(request);
int isRefash = Util.getIntValue(fu.getParameter("isRefash"), 0);
String years = Util.null2String(fu.getParameter("years"));
String months = Util.null2String(fu.getParameter("months"));
String quarters = Util.null2String(fu.getParameter("quarters"));
String weeks = Util.null2String(fu.getParameter("weeks"));
String days = Util.null2String(fu.getParameter("days"));
String objId = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type = Util.null2String(fu.getParameter("type")); //周期
int type_d = Util.getIntValue((String)SessionOper.getAttribute(session,"hrm.type_d"), 0); //计划所有者类型
String objName = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
String operationType = Util.null2String(fu.getParameter("operationType"));
int wtid = Util.getIntValue(fu.getParameter("wtid"), 0);
int worktaskStatus = Util.getIntValue(fu.getParameter("worktaskStatus"), 0);
int isCreate = Util.getIntValue(fu.getParameter("isCreate"), 0);
int isfromleft = Util.getIntValue(fu.getParameter("isfromleft"), 0);
String functionPage = Util.null2String(fu.getParameter("functionPage"));
if("multisave".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multisave");
	requestManager.setUser(user);
	boolean flag = requestManager.saveMultiRequestInfo();

	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multidelete".equalsIgnoreCase(operationType)){
	String requestids = "";
	String[] requestids_del = fu.getParameterValues("checktask2");
	if(requestids_del != null){
		for(int i=0; i<requestids_del.length; i++){
			int requestid_del = Util.getIntValue(requestids_del[i], 0);
			requestids += (requestid_del + ",");
		}
		requestManager.setFu(fu);
		requestManager.setIsCreate(1);
		requestManager.setWtid(wtid);//
		requestManager.setSrc("multidelete");
		requestManager.setUser(user);
		boolean flag = requestManager.deleteMultiRequest(requestids);
	}
	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiSubmit".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multisubmit");
	requestManager.setUser(user);
	boolean flag = requestManager.submitMultiRequest();
	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiApprove".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multiapprove");
	requestManager.setUser(user);
	boolean flag = requestManager.approveMultiRequest();

	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiBack".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multiback");
	requestManager.setUser(user);
	boolean flag = requestManager.approveMultiRequest();

	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiCancel".equalsIgnoreCase(operationType)){
	//JSP中操作：审批流程强制归档；JAVA操作：计划任务被取消
	ArrayList requestidsArr = new ArrayList();
	String[] requestid_adds = fu.getParameters("checktask2");
	String requestids = "";
	if(requestid_adds != null && requestid_adds.length >= 1){
		for(int i=0; i<requestid_adds.length; i++){
			int requestid_tmp = Util.getIntValue(requestid_adds[i], 0);
			if(requestid_tmp > 0){
				requestids += (","+requestid_tmp);
			}
		}
		rs.execute("select approverequest from worktask_requestbase where requestid in (0"+requestids+")");
		while(rs.next()){
			int approverequest = Util.getIntValue(rs.getString("approverequest"), 0);
			if(approverequest != 0){
				requestidsArr.add(""+approverequest);
			}
		}
		if(requestidsArr.size() > 0){
			WfForceOver.doForceOver(requestidsArr, request, response);
		}
		requestManager.setFu(fu);
		requestManager.setIsCreate(isCreate);
		requestManager.setWtid(wtid);//
		requestManager.setSrc("multicancel");
		requestManager.setUser(user);
		boolean flag = requestManager.approveMultiRequest();
	}
	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiExecute".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multiexecute");
	requestManager.setUser(user);
	boolean flag = requestManager.executeMultiRequest();

	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiCheck".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multicheck");
	requestManager.setUser(user);
	boolean flag = requestManager.checkMultiRequest();

	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("save".equalsIgnoreCase(operationType)){
	int requestid = 0;
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setTaskid(wtid);
	requestManager.setSrc("save");
	requestManager.setUser(user);
	if(isCreate == 0){
		requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
		requestManager.setRequestid(requestid);
	}
	boolean flag = requestManager.saveRequestInfo(0);
	requestid = requestManager.getRequestid();
	//response.sendRedirect("ViewWorktask.jsp?requestid="+requestid);
	out.println("<script>location.href=\"ViewWorktask.jsp?requestid="+requestid+"\";");
	if(isRefash == 0){
		out.println("try{window.opener.location.reload();}catch(e){}");
	}
	out.println("</script>");
	return;
}else if("Submit".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setTaskid(wtid);
	requestManager.setSrc("submit");
	requestManager.setUser(user);
	int requestid = 0;
	RequestShare requestShare = null;
	if(isCreate == 0){
		requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
		requestManager.setRequestid(requestid);
		boolean flag = requestManager.saveRequestInfo(0);
	}else{
		boolean flag = requestManager.saveRequestInfo(0);
		requestid = requestManager.getRequestid();
		requestShare = new RequestShare();
		requestShare.setWorktaskStatus(1);
		requestShare.setWtid(wtid);
		requestShare.setRequestid(requestid);
		requestShare.setRequestShare();
	}
	String ccuser = "";
	int creater = 0;
	String taskcontent = "";
	int approverequest = 0;//可能是被退回的提交，判断是否已挂有审批流程，如果有，则执行“提交审批(submitapprove)”操作
	rs.execute("select ccuser, taskcontent, creater, approverequest from worktask_requestbase where requestid="+requestid);
	if(rs.next()){
		ccuser = Util.null2String(rs.getString("ccuser"));
		taskcontent = Util.null2String(rs.getString("taskcontent"));
		creater = Util.getIntValue(rs.getString("creater"));
		approverequest = Util.getIntValue(rs.getString("approverequest"), 0);
	}
	requestShare = new RequestShare();
	requestShare.setWtid(wtid);
	requestShare.setRequestid(requestid);

	int approvewf_tmp = 0;
	String taskname = "";
	int workplantypeid = 0;
	int autotoplan = 0;
	int useapprovewf = 0;
	//System.out.println(wtid);
	rs.execute("select * from worktask_base where id="+wtid);
	if(rs.next()){
		useapprovewf = Util.getIntValue(rs.getString("useapprovewf"), 0);
		approvewf_tmp = Util.getIntValue(rs.getString("approvewf"), 0);
		taskname = Util.null2String(rs.getString("name"));
		autotoplan = Util.getIntValue(rs.getString("autotoplan"), 0);
		workplantypeid = Util.getIntValue(rs.getString("workplantypeid"), 0);
	}
	if(useapprovewf==1 && approvewf_tmp != 0){
		requestManager.setApprovewf(approvewf_tmp);
		requestManager.setTaskname(taskname);
		if(approverequest <= 0){
			requestManager.submitRequest();
		}else{
			requestManager.setSrc("submitapprove");
			requestManager.approveRequest(approverequest);
			rs.execute("update worktask_requestbase set status=2 where requestid="+requestid+" and taskid="+wtid);
		}
		requestShare.setWorktaskStatus(2);
	}else{
		rs.execute("update worktask_requestbase set status=6 where requestid="+requestid+" and taskid="+wtid);
		requestShare.setWorktaskStatus(6);
		requestManager.createSysRemindWF(ccuser, creater, taskcontent);
		if(autotoplan==1 && workplantypeid>=0){
			WorkplanCreateByRequest workplanCreateByRequest = new WorkplanCreateByRequest();
			workplanCreateByRequest.setTaskid(wtid);
			workplanCreateByRequest.setRequestid(requestid);
			workplanCreateByRequest.setWorkplantypeid(workplantypeid);
			workplanCreateByRequest.createWorkplan();
		}
	}
	requestShare.setWtid(wtid);
	requestShare.setRequestid(requestid);
	requestShare.setRequestShare();
	//response.sendRedirect("ViewWorktask.jsp?requestid="+requestid);
	out.println("<script>location.href=\"ViewWorktask.jsp?requestid="+requestid+"\";");
	if(isRefash == 0){
		out.println("try{window.opener.location.reload();}catch(e){}");
	}
	out.println("</script>");
	return;
}else if("delete".equalsIgnoreCase(operationType)){
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	requestManager.setFu(fu);
	requestManager.setIsCreate(0);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multidelete");
	requestManager.setUser(user);
	boolean flag = requestManager.deleteMultiRequest(""+requestid);
	out.println("<script>alert(\""+SystemEnv.getHtmlLabelName(20461, user.getLanguage())+"\");try{window.opener.location.reload();}catch(e){}");
	out.println("window.close();</script>");
	return;
}else if("cancel".equalsIgnoreCase(operationType)){
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	ArrayList requestidsArr = new ArrayList();
	rs.execute("select approverequest from worktask_requestbase where requestid ="+requestid);
	if(rs.next()){
		int approverequest = Util.getIntValue(rs.getString("approverequest"), 0);
		if(approverequest != 0){
			requestidsArr.add(""+approverequest);
			WfForceOver.doForceOver(requestidsArr, request, response);
		}
	}

	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("cancel");
	requestManager.setUser(user);
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.cancelRequest();
	out.println("<script>alert(\""+SystemEnv.getHtmlLabelName(16539, user.getLanguage())+SystemEnv.getHtmlLabelName(20114, user.getLanguage())+"\");try{window.opener.location.reload();}catch(e){}");
	out.println("window.close();</script>");
	return;
}else if("Approve".equalsIgnoreCase(operationType)){
	int approverequest = Util.getIntValue(fu.getParameter("approverequest"), 0);
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.setSrc("approve");
	requestManager.setUser(user);
	requestManager.approveRequest(approverequest);

	out.println("<script>try{window.opener.location.reload();}catch(e){}");
	out.println("window.close();</script>");
	return;
}else if("Back".equalsIgnoreCase(operationType)){
	int approverequest = Util.getIntValue(fu.getParameter("approverequest"), 0);
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.setSrc("back");
	requestManager.setUser(user);
	requestManager.approveRequest(approverequest);

	out.println("<script>try{window.opener.location.reload();}catch(e){}");
	out.println("window.close();</script>");
	return;
}else if("Execute".equalsIgnoreCase(operationType)){
	int operatorid = Util.getIntValue(fu.getParameter("operatorid"), 0);
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	Hashtable field_hs = null;
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("execute");
	requestManager.setUser(user);
	requestManager.setOperatorid(operatorid);
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.executeRequest(field_hs);

	out.println("<script>try{window.opener.location.reload();}catch(e){}");
	out.println("location.href=\"ViewWorktask.jsp?operatorid="+operatorid+"\";");
	out.println("</script>");
}else if("Check".equalsIgnoreCase(operationType)){
	int operatorid = Util.getIntValue(fu.getParameter("operatorid"), 0);
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	Hashtable field_hs = null;
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("check");
	requestManager.setUser(user);
	requestManager.setOperatorid(operatorid);
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.checkRequest(field_hs);

	out.println("<script>try{window.opener.location.reload();}catch(e){}");
	out.println("location.href=\"ViewWorktask.jsp?operatorid="+operatorid+"\";");
	out.println("</script>");
}else if("savetemplate".equalsIgnoreCase(operationType)){
	int requestid = 0;
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setTaskid(wtid);
	requestManager.setSrc("save");
	requestManager.setUser(user);
	if(isCreate == 0){
		requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
		requestManager.setRequestid(requestid);
	}
	boolean flag = requestManager.saveRequestInfo(0);
	requestid = requestManager.getRequestid();
	out.println("<script>location.href=\"ViewWorktaskTemplate.jsp?requestid="+requestid+"\";");
	if(isRefash == 0){
		out.println("try{window.opener.location.reload();}catch(e){}");
	}
	out.println("</script>");
	return;
}else if("multideletetemplate".equalsIgnoreCase(operationType)){//模板批量删除，无需删除审批工作流程
	String requestids = "";
	String[] requestids_del = fu.getParameterValues("checktask2");
	if(requestids_del != null){
		for(int i=0; i<requestids_del.length; i++){
			int requestid_del = Util.getIntValue(requestids_del[i], 0);
			requestids += (requestid_del + ",");
		}
		requestids = requestids.substring(0, requestids.length()-1);
		sql = "update worktask_requestbase set deleted=1 where requestid in ( "+requestids+" ) ";
		//System.out.println(sql);
		rs.execute(sql);
	}
	String taskcontent = Util.null2String(fu.getParameter("taskcontent"));
	int wakemode = Util.getIntValue(fu.getParameter("wakemode"), 0);
	response.sendRedirect(functionPage+"?wtid="+wtid+"&wakemode="+wakemode+"&taskcontent="+taskcontent);
	return;
}else if("deletetemplate".equalsIgnoreCase(operationType)){//模板单个删除，无需删除审批工作流程
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	sql = "update worktask_requestbase set deleted=1 where requestid in ( "+requestid+" ) ";
	//System.out.println(sql);
	rs.execute(sql);
	out.println("<script>alert(\""+SystemEnv.getHtmlLabelName(20461, user.getLanguage())+"\");try{window.opener.location.reload();}catch(e){}");
	out.println("window.close();</script>");
	return;
}else if("Remark".equalsIgnoreCase(operationType)){
	int operatorid = Util.getIntValue(fu.getParameter("operatorid"), 0);
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	Hashtable field_hs = null;
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("remark");
	requestManager.setUser(user);
	requestManager.setOperatorid(operatorid);
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.remarkRequest();

	out.println("<script>");
	out.println("location.href=\"ViewWorktask.jsp?operatorid="+operatorid+"\";");
	out.println("</script>");
}
%>