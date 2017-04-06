<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%
session.removeAttribute("branchid");
String whereclause="";
String orderclause="";
String orderclause2="";
String userid = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
String logintype = ""+user.getLogintype();
int usertype = 0;

if(userid.equals("")) {
	userid = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}

SearchClause.resetClause();
String method=Util.null2String(request.getParameter("method"));
String overtime=Util.null2String(request.getParameter("overtime"));
String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录
String complete1=Util.null2String(request.getParameter("complete"));
String workflowidtemp=Util.null2String(request.getParameter("workflowid"));
String wftypetemp=Util.null2String(request.getParameter("wftype"));
String cdepartmentid=Util.null2String(request.getParameter("cdepartmentid"));
int date2during=Util.getIntValue(Util.null2String(request.getParameter("date2during")),0);
int viewType=Util.getIntValue(Util.null2String(request.getParameter("viewType")),0);
if (fromPDA.equals("1"))
{
	response.sendRedirect("WFSearchResultPDA.jsp?workflowid="+workflowidtemp+"&wftype="+wftypetemp+"&complete="+complete1+"&viewType="+viewType);
	return;}

if(overtime.equals("1")){
	response.sendRedirect("WFSearchResult.jsp?isovertime=1"+"&viewType="+viewType);
	return;
}
whereclause = " (t1.deleted=0 or t1.deleted is null)  ";
if(method.equals("viewhrm")){
	String resourceid=Util.null2String(request.getParameter("resourceid"));
	
    if( isoracle ) {
	    whereclause+=" and (',' + TO_CHAR(t1.hrmids) + ',' LIKE '%,"+resourceid+",%') ";
    }else  if( isdb2 ) {
	    whereclause+=" and (',' + VARCHAR(t1.hrmids) + ',' LIKE '%,"+resourceid+",%') ";
	}
    else {
        whereclause+=" and (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+resourceid+",%') ";
    }

	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("WFSearchResult.jsp?start=1"+"&viewType="+viewType);
	return;

}
if(method.equals("all")){
	String complete=Util.null2String(request.getParameter("complete"));
	if(complete.equals("0")){
	    whereclause += " and t2.isremark in( '0','1','5','8','9','7') and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1" ;
	}else if(complete.equals("1")){
    //modify by xhheng @20030525 for TD1725
		whereclause += " and t2.iscomplete = 1  and t2.isremark in('2','4') and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
	}else if(complete.equals("2")){
    //modify by xhheng @20030525 for TD1725
		whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
	//TD10848 complete=4，表示待办黄色图标流程
	//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	if(complete.equals("0") || complete.equals("3") || complete.equals("4")){
	 response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1"+"&viewType="+viewType);
	} else {
	  response.sendRedirect("WFSearchResult.jsp?start=1&date2during="+date2during+"&viewType="+viewType);
	}
	return;
}
if(method.equals("myall")){
	String complete=Util.null2String(request.getParameter("complete"));
	
	//whereclause +=" t1.creater = "+userid+" and t1.creatertype = " + usertype;
	whereclause +=" and t1.creater = "+userid+" and t1.creatertype = " + usertype;
	if(complete.equals("0")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3' and t2.islasttimes=1 ";
	}
	else if(complete.equals("1")){
		whereclause += " and t2.isremark in('2','4') and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("WFSearchResult.jsp?start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}
if(method.equals("myreqeustbywftype")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	
    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);

    String selectedworkflow = "";
    String inSelectedWorkflowStr = "";
    if(fromAdvancedMenu==1){
	    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	    if(info!=null){
	    	selectedworkflow = info.getSelectedContent();
	    }
	    if(!"".equals(selectedContent))
	    {
	    	selectedworkflow = selectedContent;
	    }
	    List selectedWorkflowIdList = Util.TokenizerString(selectedworkflow,"|");
	    for(Iterator it=selectedWorkflowIdList.iterator();it.hasNext();){
	    	String tmpstr = (String)it.next();
	    	if(tmpstr.indexOf("W")>-1)
	    		inSelectedWorkflowStr += "," + tmpstr.substring(1);
	    }
	    if(inSelectedWorkflowStr.substring(0,1).equals(",")) inSelectedWorkflowStr=inSelectedWorkflowStr.substring(1);
	    if(!whereclause.equals("")) whereclause += " and ";
	    whereclause += " t1.workflowid in (" + inSelectedWorkflowStr + ") ";
    }
    /* edited end */    
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+" and isvalid='1' ) ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+" and isvalid='1') ";
	}
	whereclause +=" and t1.creater = "+userid+" and t1.creatertype = " + usertype;
	if(complete.equals("0")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3' and t2.islasttimes=1 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
	response.sendRedirect("WFSearchResult.jsp?start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}
if(method.equals("myreqeustbywfid")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.creater = "+userid+" and t1.creatertype = " + usertype;
	}
	else {
		whereclause +=" and t1.creater = "+userid+" and t1.creatertype = " + usertype;
	}

	if(complete.equals("0")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> '3' and t2.islasttimes=1 ";
	}
	else if(complete.equals("1")){
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '3'  and t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
    SearchClause.setWorkflowId(workflowid);
	response.sendRedirect("WFSearchResult.jsp?start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}

if(method.equals("reqeustbywftype")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	
    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);

    String selectedworkflow = "";
    String inSelectedWorkflowStr = "";
    if(fromAdvancedMenu==1){
	    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	    if(info!=null){
	    	selectedworkflow = info.getSelectedContent();
	    }
	    if(!"".equals(selectedContent))
	    {
	    	selectedworkflow = selectedContent;
	    }
	    List selectedWorkflowIdList = Util.TokenizerString(selectedworkflow,"|");
	    for(Iterator it=selectedWorkflowIdList.iterator();it.hasNext();){
	    	String tmpstr = (String)it.next();
	    	if(tmpstr.indexOf("W")>-1)
	    		inSelectedWorkflowStr += "," + tmpstr.substring(1);
	    }
	    if(inSelectedWorkflowStr.substring(0,1).equals(",")) inSelectedWorkflowStr=inSelectedWorkflowStr.substring(1);
	    if(!whereclause.equals("")) whereclause += " and ";
	    whereclause += " t1.workflowid in (" + inSelectedWorkflowStr + ") ";
    }
    /* edited end */    
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") and (t1.deleted=0 or t1.deleted is null) ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") and (t1.deleted=0 or t1.deleted is null) ";
	}
	
	if(complete.equals("0")){
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
		//whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3') ) and t2.islasttimes=1";
	}
	else if(complete.equals("1")){
		whereclause += " and t2.isremark in('2','4') and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
		whereclause += " and t2.isremark ='2' and t2.iscomplete=0  and  t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
    if(complete.equals("0")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType);
  else
    response.sendRedirect("WFSearchResult.jsp?start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}
//TD8778 褚俊 根据流程类型进入流程列表页面，精确到流程节点
if(method.equals("reqeustbywftypeNode")){
	String wftype=Util.null2String(request.getParameter("wftype"));
	String complete=Util.null2String(request.getParameter("complete"));
	
    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);
	String workFlowIDsRequest=Util.null2String(request.getParameter("workFlowIDsRequest"));
	String workFlowNodeIDsRequest=Util.null2String(request.getParameter("workFlowNodeIDsRequest"));
	//System.out.println("workFlowIDsRequest = " + workFlowIDsRequest);
	//System.out.println("workFlowNodeIDsRequest = " + workFlowNodeIDsRequest);
    String selectedworkflow = "";
    String inSelectedStr = "";
	List selectedWorkflowIdList = Util.TokenizerString(workFlowIDsRequest,",");
    if(fromAdvancedMenu==1){
		for(int i=0; i<selectedWorkflowIdList.size(); i++){
			String wfID = (String)selectedWorkflowIdList.get(i);
			if(!"".equals(workFlowNodeIDsRequest)){
				inSelectedStr += "or ( t1.workflowid = "+wfID+" and t1.currentnodeid in ("+workFlowNodeIDsRequest+") ) ";
			}else{
				inSelectedStr += "or ( t1.workflowid = "+wfID+" ) ";
			}
		}
		if(!"".equals(inSelectedStr)){
			inSelectedStr = inSelectedStr.substring(2);
			if(!"".equals(whereclause)){
				whereclause = whereclause + " and ";
			}
			whereclause += " ( " + inSelectedStr + " ) ";
		}
    }
	//System.out.println(whereclause);
    /* edited end */    
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where workflowtype = "+wftype+") ";
	}
	
	if(complete.equals("0")){
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
		//whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3') ) and t2.islasttimes=1";
	}
	else if(complete.equals("1")){
		whereclause += " and t2.isremark in('2','4') and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
		whereclause += " and t2.isremark ='2' and t2.iscomplete=0  and  t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
    if(complete.equals("0")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType);
  else
    response.sendRedirect("WFSearchResult.jsp?start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}
//add by ben根据单据号得到流程 
if(method.equals("reqeustbybill")){
	String billid=Util.null2String(request.getParameter("billid"));
	String complete=Util.null2String(request.getParameter("complete"));
	
	if(whereclause.equals("")) {
		whereclause +=" t1.workflowid in( select id from workflow_base   where formid = "+billid+" and isbill='1') ";
	}
	else {
		whereclause +=" and t1.workflowid in( select id from workflow_base   where formid = "+billid+" and isbill='1') ";
	}
	
	if(complete.equals("0")){  //未审批
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1 ";
		//whereclause += " and (t1.currentnodetype <> '3' or ((t2.isremark ='1' or t2.isremark ='8' or t2.isremark ='9') and t1.currentnodetype = '3') ) and t2.islasttimes=1";
	}
	else if(complete.equals("1")){ 
		whereclause += " and t2.isremark in('2','4') and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){  //已审批 （把办结和已办一起显示）
		whereclause += "   and ((t2.isremark ='2' and t1.currentnodetype <> 3 and t2.iscomplete=0) or  (t1.currentnodetype = '3')) and  t2.islasttimes=1";
	}
	SearchClause.setWhereClause(whereclause);
    if(complete.equals("0")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType);
  else
    response.sendRedirect("WFSearchResult.jsp?start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}
if(method.equals("reqeustbywfid")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	//complete=0表示待办事宜
	if(complete.equals("0")){
        if(whereclause.equals("")) {
            whereclause +=" t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
        }else{
		    whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
        }
		//modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直都在待办事宜中显示
        //whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3')) and t2.islasttimes=1";
	
	}
    //complete=1表示办结事宜
	else if(complete.equals("1")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark in('2','4') and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
        }else{
		    whereclause += " and t2.isremark in('2','4') and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
        }
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
        }
	}
    //complete=3表示待办事宜，红色new标记
	else if(complete.equals("3")){
        if(whereclause.equals("")) {
            whereclause +=" t2.isremark in( '0','1','8','9','7','5') and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }else{
		    whereclause +=" and t2.isremark in( '0','1','8','9','7','5') and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }
	}
    //complete=4表示待办事宜，灰色new标记
	else if(complete.equals("4")){
        if(whereclause.equals("")) {
            whereclause +=" t2.isremark in( '0','1','8','9','5','7') and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }else{
		    whereclause +=" and t2.isremark in( '0','1','8','9','5','7') and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }
	}
    //complete=5表示已办事宜，灰色new标记
	else if(complete.equals("5")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
        }
	}
    //complete=50表示已办事宜，红色new标记
	else if(complete.equals("50")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }
	}

    //complete=6表示办结事宜，红色new标记
	else if(complete.equals("6")){
        if(whereclause.equals("")) {
            whereclause += " t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
        }else{
            whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
        }
	}
    //complete=7表示办结事宜，灰色new标记
	else if(complete.equals("7")){
        if(whereclause.equals("")) {
            whereclause += " t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
        }else{
            whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
        }
	}
    //complete=8表示超时事宜，
	else if(complete.equals("8")){
        if(whereclause.equals("")) {
            whereclause +=" ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
        }else{
            whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
        }
	}
    SearchClause.setWhereClause(whereclause);

    if(complete.equals("0")||complete.equals("3")||complete.equals("4")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")||complete.equals("5")||complete.equals("6")||complete.equals("7")||complete.equals("8")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
    SearchClause.setWorkflowId(workflowid);
   
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType);
  else
    response.sendRedirect("WFSearchResult.jsp?start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}
if(method.equals("reqeustbywfidNode")){
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String complete=Util.null2String(request.getParameter("complete"));
	String nodeids = Util.null2String(request.getParameter("nodeids"));
	if(!"".equals(workflowid)){
        if(whereclause.equals("")) {
            whereclause +=" t1.workflowid in ("+workflowid+") ";
        }else{
		    whereclause +=" and t1.workflowid in ("+workflowid+") ";
        }
	}
	if(!"".equals(nodeids)){
        if(whereclause.equals("")) {
            whereclause +=" t1.currentnodeid in ("+nodeids+") ";
        }else{
		    whereclause +=" and t1.currentnodeid in ("+nodeids+") ";
        }
	}
	//complete=0表示待办事宜
	if(complete.equals("0")){
        if(whereclause.equals("")) {
            whereclause +=" t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
        }else{
		    whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
        }
		//modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直都在待办事宜中显示
        //whereclause += " and (t1.currentnodetype <> '3' or  (t2.isremark ='1' and t1.currentnodetype = '3')) and t2.islasttimes=1";
	}
    //complete=1表示办结事宜
	else if(complete.equals("1")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark in('2','4') and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
        }else{
		    whereclause += " and t2.isremark in('2','4') and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1";
        }
	}
    //complete=2表示已办事宜
	else if(complete.equals("2")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
        }
	}
    //complete=3表示待办事宜，红色new标记
	else if(complete.equals("3")){
        if(whereclause.equals("")) {
            whereclause +=" t2.isremark in( '0','1','8','9','5','7') and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }else{
		    whereclause +=" and t2.isremark in( '0','1','8','9','5','7') and  t2.viewtype=0 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }
	}
    //complete=4表示待办事宜，灰色new标记
	else if(complete.equals("4")){
        if(whereclause.equals("")) {
            whereclause +=" t2.isremark in( '0','1','8','9','5','7') and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }else{
		    whereclause +=" and t2.isremark in( '0','1','8','9','5','7') and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='5' or t2.isremark='7') ";
        }
	}
    //complete=5表示已办事宜，灰色new标记
	else if(complete.equals("5")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1";
        }
	}
    //complete=50表示已办事宜，红色new标记
	else if(complete.equals("50")){
        if(whereclause.equals("")) {
            whereclause += " t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }else{
		    whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=0 and (agentType<>'1' or agentType is null) ";
        }
	}
    //complete=6表示办结事宜，红色new标记
	else if(complete.equals("6")){
        if(whereclause.equals("")) {
            whereclause += " t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
        }else{
            whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=0";
        }
	}
    //complete=7表示办结事宜，灰色new标记
	else if(complete.equals("7")){
        if(whereclause.equals("")) {
            whereclause += " t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
        }else{
            whereclause += " and t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1";
        }
	}
    //complete=8表示超时事宜，
	else if(complete.equals("8")){
        if(whereclause.equals("")) {
            whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
        }else{
            whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t1.currentnodetype <> 3 ";
        }
	}
    SearchClause.setWhereClause(whereclause);

    if(complete.equals("0")||complete.equals("3")||complete.equals("4")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }else if(complete.equals("1") ||complete.equals("2")||complete.equals("5")||complete.equals("6")||complete.equals("7")||complete.equals("8")){
        orderclause="t2.receivedate ,t2.receivetime ";
        orderclause2=orderclause;
    }
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
    SearchClause.setWorkflowId(workflowid);
   
  if(complete.equals("0") || complete.equals("3") || complete.equals("4"))//modified by cyril on 2008-07-15 for td:8939 complete=3表示新到流程
	  response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1&date2during="+date2during+"&viewType="+viewType);
  else
    response.sendRedirect("WFSearchResult.jsp?start=1&date2during="+date2during+"&viewType="+viewType);
	return;
}

String createrid=Util.null2String(request.getParameter("createrid"));
String docids=Util.null2String(request.getParameter("docids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String hrmids=Util.null2String(request.getParameter("hrmids"));
String prjids=Util.null2String(request.getParameter("prjids"));
String creatertype=Util.null2String(request.getParameter("creatertype"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodetype=Util.null2String(request.getParameter("nodetype"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
String lastfromdate=Util.null2String(request.getParameter("lastfromdate"));
String lasttodate=Util.null2String(request.getParameter("lasttodate"));
String requestmark=Util.null2String(request.getParameter("requestmark"));
String branchid=Util.null2String(request.getParameter("branchid"));
if (!branchid.equals("")) session.setAttribute("branchid",branchid);
int during=Util.getIntValue(request.getParameter("during"),0);
int order=Util.getIntValue(request.getParameter("order"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"),0);
String requestname=Util.fromScreen2(request.getParameter("requestname"),user.getLanguage());
requestname=requestname.trim();
int subday1=Util.getIntValue(request.getParameter("subday1"),0);
int subday2=Util.getIntValue(request.getParameter("subday2"),0);
int maxday=Util.getIntValue(request.getParameter("maxday"),0);
int state=Util.getIntValue(request.getParameter("state"),0);
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
//add by xhheng @20050414 for TD 1545
int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;

Calendar now = Calendar.getInstance();
String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+
	Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
int year=now.get(Calendar.YEAR);
int month=now.get(Calendar.MONTH);
int day=now.get(Calendar.DAY_OF_MONTH);

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


if(!createrid.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.creater='"+createrid+"'";}
	else {whereclause+=" and t1.creater='"+createrid+"'";}
	if(!creatertype.equals("")){
		if(whereclause.equals("")) {whereclause+=" t1.creatertype='"+creatertype+"'";}
		else {whereclause+=" and t1.creatertype='"+creatertype+"'";}
	}
}

//添加附件上传文档的查询
if(!docids.equals("")){
    RecordSet.executeSql("select fieldname from workflow_formdict where fieldhtmltype=6 ");
}

if( isoracle ) {
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" ((concat(concat(',' , To_char(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and ((concat(concat(',' , To_char(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        while(RecordSet.next()){
            String fieldname=RecordSet.getString("fieldname");
            whereclause+=" or (concat(concat(',' , To_char(t4."+fieldname+")) , ',') LIKE '%,"+docids+",%') ";
        }
        whereclause+=") ";
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , To_char(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , To_char(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
    }
}else if( isdb2 ) {
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" ((concat(concat(',' , varchar(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and ((concat(concat(',' , varchar(t1.docids)) , ',') LIKE '%,"+docids+",%') ";}
        while(RecordSet.next()){
            String fieldname=RecordSet.getString("fieldname");
            whereclause+=" or (concat(concat(',' , varchar(t4."+fieldname+")) , ',') LIKE '%,"+docids+",%') ";
        }
        whereclause+=") ";
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , varchar(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , varchar(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , varchar(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , varchar(t1.hrmids)) , ',') LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (concat(concat(',' , varchar(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (concat(concat(',' , varchar(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";}
    }
}
else {
    if(!docids.equals("")){
        if(whereclause.equals("")) {whereclause+=" ((',' + CONVERT(varchar,t1.docids) + ',' LIKE '%,"+docids+",%') ";}
        else {whereclause+=" and ((',' + CONVERT(varchar,t1.docids) + ',' LIKE '%,"+docids+",%') ";}
        while(RecordSet.next()){
            String fieldname=RecordSet.getString("fieldname");
            whereclause+=" or (',' + CONVERT(varchar,t4."+fieldname+") + ',' LIKE '%,"+docids+",%') ";
        }
        whereclause+=") ";
    }
    if(!crmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";}
    }
    if(!hrmids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+hrmids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.hrmids) + ',' LIKE '%,"+hrmids+",%') ";}
    }
    if(!prjids.equals("")){
        if(whereclause.equals("")) {whereclause+=" (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";}
        else {whereclause+=" and (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";}
    }
}
if(!workflowid.equals("")){
	if(whereclause.equals("")) 
	{whereclause+=" t1.workflowid in("+workflowid+")";}
	else 
	{
	 /*--xwj for td2045 on 2005-05-26 --查询流程时, 同时选择流程类型和创建人时出错*/
	 //whereclause+=" and t1.workflowid in("+workflowid+")";
	 whereclause = "t1.workflowid in("+workflowid+") and " + whereclause; 
	}
}
if(!cdepartmentid.equals("")){
    String tempWhere = "";
    ArrayList tempArr = Util.TokenizerString(cdepartmentid,",");
    for(int i=0;i<tempArr.size();i++){
        String tempcdepartmentid = (String)tempArr.get(i);
        if(tempWhere.equals("")) tempWhere += "departmentid="+tempcdepartmentid;
        else tempWhere += " or departmentid="+tempcdepartmentid;
    }
    if(!tempWhere.equals("")){
        if(whereclause.equals("")) {whereclause+=" exists(select 1 from hrmresource where t1.creater=id and t1.creatertype='0' and ("+tempWhere+"))";}
        else {whereclause+=" and exists(select 1 from hrmresource where t1.creater=id and t1.creatertype='0' and ("+tempWhere+"))";}
    }
}
whereclause += WorkflowComInfo.getDateDuringSql(date2during);
if(!requestname.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.requestname like '%"+requestname+"%'";}
	else {whereclause+=" and t1.requestname like '%"+requestname+"%'";}
}
if(!nodetype.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype='"+nodetype+"'";}
	else {whereclause+=" and t1.currentnodetype='"+nodetype+"'";}
}
if(!requestmark.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.requestmark like '%"+requestmark+"%'";}
	else {whereclause+=" and t1.requestmark like '%"+requestmark+"%'";}
}

if(!lastfromdate.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.lastoperatedate>='"+lastfromdate+"'";}
	else {whereclause+=" and t1.lastoperatedate>='"+lastfromdate+"'";}
}
if(!lasttodate.equals("")){
	if(whereclause.equals("")) {whereclause+=" t1.lastoperatedate<='"+lasttodate+"'";}
	else {whereclause+=" and t1.lastoperatedate<='"+lasttodate+"'";}
}
if(during==0){
	if(!fromdate.equals("")){
		if(whereclause.equals("")){whereclause+=" t1.createdate>='"+fromdate+"'";}
		else {whereclause+=" and t1.createdate>='"+fromdate+"'";}
	}
	if(!todate.equals("")){
		if(whereclause.equals("")){whereclause+=" t1.createdate<='"+todate+"'";}
		else {whereclause+=" and t1.createdate<='"+todate+"'";}
	}
}
else{
	if(during==1){
		if(whereclause.equals(""))	whereclause+=" t1.createdate='"+today+"'";
		else  whereclause+=" and t1.createdate='"+today+"'";
	}
	if(during==2){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        /* 刘煜 2004－05－08 修改，原来or 之间没有括号，造成系统死机 */
		if(whereclause.equals(""))	
			whereclause+=" ((t1.createdate='"+today+"' and t1.createtime<='"+CurrentTime+"')"+
			 " or (t1.createdate='"+lastday+"' and t1.createtime>='"+CurrentTime+"')) ";
		else  
			whereclause+=" and ((t1.createdate='"+today+"' and t1.createtime<='"+CurrentTime+"')"+
			 " or (t1.createdate='"+lastday+"' and t1.createtime>='"+CurrentTime+"')) ";
	}
	if(during==3){
		int days=now.getTime().getDay();
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-days);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==4){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-7);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==5){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==6){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-30);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==7){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,0,1);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
	if(during==8){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-365);
		String lastday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
			Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
        		Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
        	if(whereclause.equals(""))
        		whereclause+=" t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
        	else
        		whereclause+=" and t1.createdate<='"+today+"' and t1.createdate>='"+lastday+"'";
	}
		
}

if( isoracle ) {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+="  (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))="+maxday;
        else
            whereclause+=" and (to_date(t1.lastoperatedate,'YYYY-MM-DD')-to_date(t1.createdate,'YYYY-MM-DD'))="+maxday;
    }
}else if( isdb2 ) {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
        else
            whereclause+=" and (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
        else
            whereclause+=" and (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+="  (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))="+maxday;
        else
            whereclause+=" and (date(t1.lastoperatedate,'YYYY-MM-DD')-date(t1.createdate,'YYYY-MM-DD'))="+maxday;
    }
}
else {
    if(subday1!=0){
        if(whereclause.equals(""))	
            whereclause+="  (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))>"+subday1;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))>"+subday1;
    }

    if(subday2!=0){
        if(whereclause.equals(""))	
            whereclause+="  (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))<="+subday2;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))<="+subday2;
    }

    if(maxday!=0){
        if(whereclause.equals(""))	
            whereclause+=" (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))="+maxday;
        else
            whereclause+=" and (convert(datetime,t1.lastoperatedate)-convert(datetime,t1.createdate))="+maxday;
    }
}

if(state==1){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype='3'";}
	else {whereclause+=" and t1.currentnodetype='3'";}
}
if(state==2){
	if(whereclause.equals("")) {whereclause+=" t1.currentnodetype<>'3'";}
	else {whereclause+=" and t1.currentnodetype<>'3'";}
}

if(isdeleted!=2){
	if(whereclause.equals(""))	{
        if(isdeleted == 0) whereclause+=" (exists (select 1 from workflow_base where isvalid=1 and workflow_base.id=t2.workflowid)) ";
        else whereclause += " exists (select 1 from workflow_base where (isvalid=0  or isvalid is null) and workflow_base.id=t2.workflowid) ";
    }
	else {
        if(isdeleted == 0) whereclause+=" and (exists (select 1 from workflow_base where isvalid=1 and workflow_base.id=t2.workflowid)) ";
        else whereclause+=" and exists (select 1 from workflow_base where (isvalid=0  or isvalid is null) and workflow_base.id=t2.workflowid) ";
    }
}

if(!requestlevel.equals("")){
	if(whereclause.equals(""))	whereclause+=" t1.requestlevel="+requestlevel;
	else	whereclause+=" and t1.requestlevel="+requestlevel;
}


if(whereclause.equals("")) whereclause+="  islasttimes=1 ";
else whereclause+=" and islasttimes=1 ";

orderclause="t2.receivedate ,t2.receivetime";
orderclause2="t2.receivedate ,t2.receivetime";

SearchClause.setOrderClause(orderclause);
SearchClause.setOrderClause2(orderclause2);
SearchClause.setWhereClause(whereclause);

SearchClause.setWorkflowId(workflowid);
SearchClause.setNodeType(nodetype);
SearchClause.setFromDate(fromdate);
SearchClause.setToDate(todate);
SearchClause.setCreaterType(creatertype);
SearchClause.setCreaterId(createrid);
SearchClause.setRequestLevel(requestlevel);
SearchClause.setDepartmentid(cdepartmentid);
response.sendRedirect("WFSearchResult.jsp?query=1&pagenum=1&iswaitdo="+iswaitdo+"&docids="+docids+"&date2during="+date2during+"&viewType="+viewType);


%>