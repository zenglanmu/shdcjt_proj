<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
	String sql = "";
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
	if(operateLevel < 1){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	int id = Util.getIntValue(request.getParameter("id"),-1);
	int workflowid = Util.getIntValue(request.getParameter("wfid"),-1);
	int plantypeid = Util.getIntValue(request.getParameter("plantypeid"),-1);
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
	String formID = request.getParameter("formid");
	String isbill = request.getParameter("isbill");
	String operationType = Util.null2String(request.getParameter("operationType"));
	int errorMessage = Util.getIntValue(request.getParameter("errorMessage"), 0);
	//System.out.println("errorMessage = " + errorMessage);
	if("save".equalsIgnoreCase(operationType)){
		int creatertype = Util.getIntValue(request.getParameter("creatertype"), 0);
		int wffield = Util.getIntValue(request.getParameter("wffield"), 0);
		if(creatertype == 0){
			wffield = 0;
		}
		int remindType = Util.getIntValue(request.getParameter("remindType"), 1);
		int remindBeforeStart = Util.getIntValue(request.getParameter("remindBeforeStart"), 0);
		int remindDateBeforeStart = Util.getIntValue(request.getParameter("remindDateBeforeStart"), 0);
		int remindTimeBeforeStart = Util.getIntValue(request.getParameter("remindTimeBeforeStart"), 0);
		int remindBeforeEnd = Util.getIntValue(request.getParameter("remindBeforeEnd"), 0);
		int remindDateBeforeEnd = Util.getIntValue(request.getParameter("remindDateBeforeEnd"), 0);
		int remindTimeBeforeEnd = Util.getIntValue(request.getParameter("remindTimeBeforeEnd"), 0);
		sql = "update workflow_createplan set creatertype="+creatertype+", wffieldid="+wffield+", remindType="+remindType+", remindBeforeStart="+remindBeforeStart+", remindDateBeforeStart="+remindDateBeforeStart+", remindTimeBeforeStart="+remindTimeBeforeStart+", remindBeforeEnd="+remindBeforeEnd+", remindDateBeforeEnd="+remindDateBeforeEnd+", remindTimeBeforeEnd="+remindTimeBeforeEnd+" where id="+id;
		//out.println(sql);
		rs.execute(sql);
		String[] planfieldnames = request.getParameterValues("planfieldname");
		String[] groupids = request.getParameterValues("groupid");
		if(planfieldnames!=null && groupids!=null){
			sql = "delete from workflow_createplandetail where createplanid="+id;
			rs.execute(sql);
			sql = "delete from workflow_createplangroup where createplanid="+id;
			rs.execute(sql);
			for(int i=0; i<groupids.length; i++){
				int groupid = Util.getIntValue(groupids[i], 0);
				int isused_tmp = Util.getIntValue(request.getParameter("isused_"+groupid), 0);
				sql = "insert into workflow_createplangroup (createplanid, groupid, isused) values ("+id+", "+groupid+", "+isused_tmp+")";
				//out.println(sql);
				rs.execute(sql);
				for(int cx=0; cx<planfieldnames.length; cx++){
					String planfieldname_tmp = planfieldnames[cx];
					String wffieldStr = Util.null2String(request.getParameter("wffield_"+planfieldname_tmp+"_"+groupid));
					if("-1".equals(wffieldStr)){
						continue;
					}
					try{
						String[] wffieldStrs = Util.TokenizerString2(wffieldStr, "_");
						int wffieldid = Util.getIntValue(wffieldStrs[0], 0);
						int isdetail = Util.getIntValue(wffieldStrs[1], 0);
						sql = "insert into workflow_createplandetail (createplanid, wffieldid, isdetail, planfieldname, groupid) values ("+id+", "+wffieldid+", "+isdetail+", '"+planfieldname_tmp+"', "+groupid+")";
						//out.println(sql);
						rs.execute(sql);
					}catch(Exception e){
						continue;
					}
				}
			}
		}
	}
	response.sendRedirect("/workflow/workflow/CreateWorkplanByWorkflowDetail.jsp?ajax=1&id="+id+"&wfid="+workflowid);
%>