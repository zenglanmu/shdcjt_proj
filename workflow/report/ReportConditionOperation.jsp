<%@ page language="java" contentType="text/html; charset=GBK" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportConditionMouldManager" class="weaver.workflow.report.ReportConditionMouldManager" scope="page" />


<%@ include file="/systeminfo/init.jsp" %>


<%
String operation = Util.null2String(request.getParameter("operation"));

//另存为模板
if(operation.equals("saveAsTemplate"))
{
    //报表id
    String reportId = Util.null2String(request.getParameter("reportid"));
    //新模板的名称
    String newMouldName = Util.null2String(request.getParameter("newMouldName"));
	//新模板的id
	int mouldId=ReportConditionMouldManager.getNextMouldId();
    //用户id
	int userId=user.getUID();

    RecordSet.executeSql("insert into WorkflowRptCondMould(id,mouldName,userId,reportId) values("+mouldId+",'"+newMouldName+"',"+userId+","+reportId+")");


	////往明细表插入数据
    //获得需要插入数据的字段id
	String[] checkConds = request.getParameterValues("check_con");
    String[] isShows=request.getParameterValues("isShow");


	String fieldId="";
    List fieldIdList=new ArrayList();
    List fieldIdCheckCondList=new ArrayList();
    List fieldIdIsShowList=new ArrayList();

    if(checkConds!=null){
	    for(int i=0;i<checkConds.length;i++){
		    fieldId=checkConds[i];
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdList.indexOf(fieldId)==-1){
			    fieldIdList.add(fieldId);
		    }
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdCheckCondList.indexOf(fieldId)==-1){
			    fieldIdCheckCondList.add(fieldId);
		    }
	    }
    }

    if(isShows!=null){
	    for(int i=0;i<isShows.length;i++){
		    fieldId=isShows[i];
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdList.indexOf(fieldId)==-1){
			    fieldIdList.add(fieldId);
		    }
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdIsShowList.indexOf(fieldId)==-1){
			    fieldIdIsShowList.add(fieldId);
		    }
	    }
	}

	String isMain="";
	String isShow="";
	String isCheckCond="";
	String colName="";
	String htmlType="";
	String type="";
	String optionFirst="";
	String valueFirst="";
	String nameFirst="";
	String optionSecond="";
	String valueSecond="";

	for(int i=0;i<fieldIdList.size();i++){
		fieldId=(String)fieldIdList.get(i);
		isMain = ""+Util.null2String(request.getParameter("con"+fieldId+"_ismain"));

		if(fieldIdIsShowList.indexOf(fieldId)>-1){
			isShow="1";
		}else{
			isShow="0";
		}

		if(fieldIdCheckCondList.indexOf(fieldId)>-1){
			isCheckCond="1";
		    colName = ""+Util.null2String(request.getParameter("con"+fieldId+"_colname"));
		    htmlType = ""+Util.null2String(request.getParameter("con"+fieldId+"_htmltype"));
		    type = ""+Util.null2String(request.getParameter("con"+fieldId+"_type"));
		    if(type.equals("")){
			    type="-1";
		    }
		    optionFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_opt"));
		    valueFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_value"));
		    nameFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_name"));
		    optionSecond = ""+Util.null2String(request.getParameter("con"+fieldId+"_opt1"));
		    valueSecond = ""+Util.null2String(request.getParameter("con"+fieldId+"_value1"));

		}else{
			isCheckCond="0";
		    colName = "";
		    htmlType = "";
			type="-1";
		    optionFirst = "";
		    valueFirst = "";
			nameFirst="";
		    optionSecond = "";
		    valueSecond = "";
		}



        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+","+fieldId+",'"+isMain+"','"+isShow+"','"+isCheckCond+"','"+colName+"','"+htmlType+"',"+type+",'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','"+optionSecond+"','"+valueSecond+"')");


	}

	////考虑请求说明、紧急程度、工作流程状态三个特殊的字段
    //请求说明，fieldId指定为-1，isMain指定为'1'
    String requestNameIsShow = Util.null2String(request.getParameter("requestNameIsShow"));
    String requestNameCheckCond = Util.null2String(request.getParameter("requestname_check_con"));
    optionFirst = Util.null2String(request.getParameter("requestname"));
    valueFirst = Util.null2String(request.getParameter("requestnamevalue"));

    if(requestNameIsShow.equals("1")||requestNameCheckCond.equals("1")){
		if(!requestNameIsShow.equals("1")){
			requestNameIsShow="0";
		}

		if(!requestNameCheckCond.equals("1")){
			requestNameCheckCond="0";
            optionFirst = "";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-1,'1','"+requestNameIsShow+"','"+requestNameCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','','','')");
	}

	//紧急程度，fieldId指定为-2，isMain指定为'1'
    String requestLevelIsShow = Util.null2String(request.getParameter("requestLevelIsShow"));
    String requestLevelCheckCond = Util.null2String(request.getParameter("requestlevel_check_con"));
    valueFirst = Util.null2String(request.getParameter("requestlevelvalue"));

    if(requestLevelIsShow.equals("1")||requestLevelCheckCond.equals("1")){
		if(!requestLevelIsShow.equals("1")){
			requestLevelIsShow="0";
		}

		if(!requestLevelCheckCond.equals("1")){
			requestLevelCheckCond="0";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-2,'1','"+requestLevelIsShow+"','"+requestLevelCheckCond+"','','',-1,'','"+valueFirst+"','','','')");
	}

	//工作流程状态，fieldId指定为-3，isMain指定为'1'
    String requestStatusIsShow = Util.null2String(request.getParameter("requestStatusIsShow"));
    String requestStatusCheckCond = Util.null2String(request.getParameter("requeststatus_check_con"));
    valueFirst = Util.null2String(request.getParameter("requeststatusvalue"));

    if(requestStatusIsShow.equals("1")||requestStatusCheckCond.equals("1")){
		if(!requestStatusIsShow.equals("1")){
			requestStatusIsShow="0";
		}

		if(!requestStatusCheckCond.equals("1")){
			requestStatusCheckCond="0";
            optionFirst = "";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-3,'1','"+requestStatusIsShow+"','"+requestStatusCheckCond+"','','',-1,'','"+valueFirst+"','','','')");
	}
	
	//归档时间，fieldId指定为-4，isMain指定为'1'
	//if(requestStatusCheckCond.equals("1")&&valueFirst.equals("1")){
		String archiveTime = Util.null2String(request.getParameter("archiveTime"));
		String archiveTimeFrom = "";
		String archiveTimeTo = "";
		if(archiveTime.equals("1")){
		  archiveTimeFrom = ""+Util.null2String(request.getParameter("fromdate"));
		  archiveTimeTo = ""+Util.null2String(request.getParameter("todate"));
		  RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-4,'1','1','"+archiveTime+"','','',-1,'','"+archiveTimeFrom+"','','','"+archiveTimeTo+"')");
		}
	//}
	
	response.sendRedirect("ReportConditionMould.jsp?id="+reportId+"&mouldId="+mouldId);
	return ;
}


//删除模板
if(operation.equals("deleteTemplate"))
{
    //报表id
    String reportId = Util.null2String(request.getParameter("reportid"));

	//模板id
    int mouldId = Util.getIntValue(request.getParameter("mouldId"),0) ;

    //删除工作流报表条件模板明细表数据
    RecordSet.executeSql("delete from WorkflowRptCondMouldDetail where mouldId="+mouldId);

    //删除工作流报表条件模板表数据
    RecordSet.executeSql("delete from WorkflowRptCondMould where id="+mouldId);

	response.sendRedirect("ReportCondition.jsp?id="+reportId);
	return ;
}


//保存编辑模板
if(operation.equals("editSaveTemplate"))
{
    //报表id
    String reportId = Util.null2String(request.getParameter("reportid"));
    //新模板的名称
    String newMouldName = Util.null2String(request.getParameter("newMouldName"));
	//模板的id
    int mouldId = Util.getIntValue(request.getParameter("mouldId"),0) ;
    //用户id
	int userId=user.getUID();



    RecordSet.executeSql("update WorkflowRptCondMould set mouldName='"+newMouldName+"' where id="+mouldId);

    //删除工作流报表条件模板明细表数据
    RecordSet.executeSql("delete from WorkflowRptCondMouldDetail where mouldId="+mouldId);

	////往明细表插入数据
    //获得需要插入数据的字段id
	String[] checkConds = request.getParameterValues("check_con");
    String[] isShows=request.getParameterValues("isShow");


	String fieldId="";
    List fieldIdList=new ArrayList();
    List fieldIdCheckCondList=new ArrayList();
    List fieldIdIsShowList=new ArrayList();

    if(checkConds!=null){
	    for(int i=0;i<checkConds.length;i++){
		    fieldId=checkConds[i];
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdList.indexOf(fieldId)==-1){
			    fieldIdList.add(fieldId);
		    }
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdCheckCondList.indexOf(fieldId)==-1){
			    fieldIdCheckCondList.add(fieldId);
		    }
	    }
    }

    if(isShows!=null){
	    for(int i=0;i<isShows.length;i++){
		    fieldId=isShows[i];
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdList.indexOf(fieldId)==-1){
			    fieldIdList.add(fieldId);
		    }
		    if(fieldId!=null&&!fieldId.equals("")&&fieldIdIsShowList.indexOf(fieldId)==-1){
			    fieldIdIsShowList.add(fieldId);
		    }
	    }
	}

	String isMain="";
	String isShow="";
	String isCheckCond="";
	String colName="";
	String htmlType="";
	String type="";
	String optionFirst="";
	String valueFirst="";
	String nameFirst="";
	String optionSecond="";
	String valueSecond="";

	for(int i=0;i<fieldIdList.size();i++){
		fieldId=(String)fieldIdList.get(i);
		isMain = ""+Util.null2String(request.getParameter("con"+fieldId+"_ismain"));

		if(fieldIdIsShowList.indexOf(fieldId)>-1){
			isShow="1";
		}else{
			isShow="0";
		}

		if(fieldIdCheckCondList.indexOf(fieldId)>-1){
			isCheckCond="1";
		    colName = ""+Util.null2String(request.getParameter("con"+fieldId+"_colname"));
		    htmlType = ""+Util.null2String(request.getParameter("con"+fieldId+"_htmltype"));
		    type = ""+Util.null2String(request.getParameter("con"+fieldId+"_type"));
		    if(type.equals("")){
			    type="-1";
		    }
		    optionFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_opt"));
		    valueFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_value"));
		    nameFirst = ""+Util.null2String(request.getParameter("con"+fieldId+"_name"));
		    optionSecond = ""+Util.null2String(request.getParameter("con"+fieldId+"_opt1"));
		    valueSecond = ""+Util.null2String(request.getParameter("con"+fieldId+"_value1"));

		}else{
			isCheckCond="0";
		    colName = "";
		    htmlType = "";
			type="-1";
		    optionFirst = "";
		    valueFirst = "";
			nameFirst="";
		    optionSecond = "";
		    valueSecond = "";
		}



        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+","+fieldId+",'"+isMain+"','"+isShow+"','"+isCheckCond+"','"+colName+"','"+htmlType+"',"+type+",'"+optionFirst+"','"+valueFirst+"','"+nameFirst+"','"+optionSecond+"','"+valueSecond+"')");


	}

	////考虑请求说明、紧急程度、工作流程状态三个特殊的字段
    //请求说明，fieldId指定为-1，isMain指定为'1'
    String requestNameIsShow = Util.null2String(request.getParameter("requestNameIsShow"));
    String requestNameCheckCond = Util.null2String(request.getParameter("requestname_check_con"));
    optionFirst = Util.null2String(request.getParameter("requestname"));
    valueFirst = Util.null2String(request.getParameter("requestnamevalue"));

    if(requestNameIsShow.equals("1")||requestNameCheckCond.equals("1")){
		if(!requestNameIsShow.equals("1")){
			requestNameIsShow="0";
		}

		if(!requestNameCheckCond.equals("1")){
			requestNameCheckCond="0";
            optionFirst = "";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-1,'1','"+requestNameIsShow+"','"+requestNameCheckCond+"','','',-1,'"+optionFirst+"','"+valueFirst+"','','','')");
	}

	//紧急程度，fieldId指定为-2，isMain指定为'1'
    String requestLevelIsShow = Util.null2String(request.getParameter("requestLevelIsShow"));
    String requestLevelCheckCond = Util.null2String(request.getParameter("requestlevel_check_con"));
    valueFirst = Util.null2String(request.getParameter("requestlevelvalue"));

    if(requestLevelIsShow.equals("1")||requestLevelCheckCond.equals("1")){
		if(!requestLevelIsShow.equals("1")){
			requestLevelIsShow="0";
		}

		if(!requestLevelCheckCond.equals("1")){
			requestLevelCheckCond="0";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-2,'1','"+requestLevelIsShow+"','"+requestLevelCheckCond+"','','',-1,'','"+valueFirst+"','','','')");
	}

	//工作流程状态，fieldId指定为-3，isMain指定为'1'
    String requestStatusIsShow = Util.null2String(request.getParameter("requestStatusIsShow"));
    String requestStatusCheckCond = Util.null2String(request.getParameter("requeststatus_check_con"));
    valueFirst = Util.null2String(request.getParameter("requeststatusvalue"));

    if(requestStatusIsShow.equals("1")||requestStatusCheckCond.equals("1")){
		if(!requestStatusIsShow.equals("1")){
			requestStatusIsShow="0";
		}

		if(!requestStatusCheckCond.equals("1")){
			requestStatusCheckCond="0";
            optionFirst = "";
            valueFirst = "";
		}

        RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-3,'1','"+requestStatusIsShow+"','"+requestStatusCheckCond+"','','',-1,'','"+valueFirst+"','','','')");
	}
	
	//归档时间，fieldId指定为-4，isMain指定为'1'
	//if(requestStatusCheckCond.equals("1")&&valueFirst.equals("1")){
		String archiveTime = Util.null2String(request.getParameter("archiveTime"));
		String archiveTimeFrom = "";
		String archiveTimeTo = "";
		if(archiveTime.equals("1")){
		  archiveTimeFrom = ""+Util.null2String(request.getParameter("fromdate"));
		  archiveTimeTo = ""+Util.null2String(request.getParameter("todate"));
		  RecordSet.executeSql("insert into WorkflowRptCondMouldDetail(mouldId,fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond) values("+mouldId+",-4,'1','1','"+archiveTime+"','','',-1,'','"+archiveTimeFrom+"','','','"+archiveTimeTo+"')");
		}
	//}
	
	response.sendRedirect("ReportConditionMould.jsp?id="+reportId+"&mouldId="+mouldId);
	return ;
}
%>