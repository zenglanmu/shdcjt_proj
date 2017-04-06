<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.general.GCONST,weaver.file.Prop" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
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
    String inSelectedStr = "";
SearchClause.resetClause();
String infoId=Util.null2String(request.getParameter("infoId"));
String selectedContent=Util.null2String(request.getParameter("selectedContent"));
if(selectedContent!=null && selectedContent.startsWith("key_")){
	String menuid = selectedContent.substring(4);
	RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
	selectedContent = "";
	while(RecordSet.next()){
		String keyVal = RecordSet.getString(2);
		selectedContent += keyVal +"|";
	}
	if(selectedContent.indexOf("|")!=-1)
		selectedContent = selectedContent.substring(0,selectedContent.length()-1);
}
int vmenuType=Util.getIntValue(Util.null2String(request.getParameter("menuType")),0);
String overtime=Util.null2String(request.getParameter("overtime"));
String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录
String complete=Util.null2String(request.getParameter("complete"));
String workflowidtemp=Util.null2String(request.getParameter("workflowid"));
String wftypetemp=Util.null2String(request.getParameter("wftype"));
Prop prop = Prop.getInstance();
String hasOvertime = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.overtime"));
String hasChangStatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile(), "ecology.changestatus"));
if (fromPDA.equals("1"))
{
	response.sendRedirect("WFSearchResultPDA.jsp?workflowid="+workflowidtemp+"&wftype="+wftypetemp+"&complete="+complete);
	return;}

if(overtime.equals("1")){
	response.sendRedirect("WFSearchResult.jsp?isovertime=1");
	return;
}
    String selectedworkflow = "";
	int menuType = 0;
    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
    LeftMenuInfo info = infoHandler.getLeftMenuInfo(Util.getIntValue(infoId, 0));
    if(info!=null){
    	selectedworkflow = info.getSelectedContent();
		menuType = info.getMenuType();
    }
    if(!"".equals(selectedContent))
    {
    	selectedworkflow = selectedContent;
    }
    if(vmenuType>0)
    {
    	menuType = vmenuType;
    }
    selectedworkflow+="|";
	List whereclauseList = Util.TokenizerString(selectedworkflow,"|");

//待办事宜，可精确到流程节点
if(menuType == 2){

	String wfids = "";
	String nodeids = "";
	for(int i=0; i<whereclauseList.size(); i++){
		String wherec_tmp = (String)whereclauseList.get(i);
		if(wherec_tmp.length() >= 1){
			if("W".equals(wherec_tmp.substring(0, 1))){
				wfids = wfids + ", " + wherec_tmp.substring(1);
				String wfidstr = "PW" + wherec_tmp.substring(1) + "N";
				boolean hasNodeid = false;
				for(int j=0; j<whereclauseList.size(); j++){
					String t_clause = (String)whereclauseList.get(j);
					if(t_clause.indexOf(wfidstr)>-1){
						hasNodeid = true;
						break;
					}
				}
				if(hasNodeid == false){
					RecordSet.executeSql("select nodeid from workflow_flownode where workflowid="+wherec_tmp.substring(1));
					while(RecordSet.next()){
						String wfnodeid_rs = Util.null2String(RecordSet.getString("nodeid"));
						if(!"".equals(wfnodeid_rs)){
							nodeids = nodeids + ", " + wfnodeid_rs;
						}
					}
				}
			}else if("PW".equals(wherec_tmp.substring(0, 2))){
				int bx = wherec_tmp.indexOf("N");
				String t_wfid = wherec_tmp.substring(2, bx);
				bx = wherec_tmp.indexOf("SP^AN");
				nodeids = nodeids + ", " + wherec_tmp.substring(3 + t_wfid.length(), bx);
			}
		}
	}
	if(!"".equals(wfids)){
		wfids = wfids.substring(1);
		if(!"".equals(nodeids)){
			nodeids = nodeids.substring(1);
			inSelectedStr += "t1.workflowid in ("+wfids+") and t1.currentnodeid in ("+nodeids+") ";
		}else{
			inSelectedStr += "t1.workflowid in ("+wfids+") ";
		}
	}

	whereclause += inSelectedStr;

	if("".equals(whereclause)){
		whereclause +=" t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
	}else{
		whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
	}

	SearchClause.setWhereClause(whereclause);

    orderclause="t2.receivedate ,t2.receivetime ";

    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);

	response.sendRedirect("WFSearchResult.jsp?start=1&iswaitdo=1");
	return;
}else
//已办事宜
if(menuType == 3){
	String wfids = "";
	String nodeids = "";
	for(int i=0; i<whereclauseList.size(); i++){
		String wherec_tmp = (String)whereclauseList.get(i);
		if(wherec_tmp.length() >= 1){
			if("W".equals(wherec_tmp.substring(0, 1))){
				wfids = wfids + ", " + wherec_tmp.substring(1);
			}
		}
	}
	if(!"".equals(wfids)){
		wfids = wfids.substring(1);
		inSelectedStr += "t1.workflowid in ("+wfids+") ";
	}
	whereclause += inSelectedStr;
	if("".equals(whereclause)){
		whereclause = "t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
	}else{
		whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
	}
	SearchClause.setWhereClause(whereclause);

    orderclause="t2.receivedate ,t2.receivetime ";

    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);

	response.sendRedirect("WFSearchResult.jsp?start=1");
	return;
}else
//办结事宜
if(menuType == 4){
	String wfids = "";
	String nodeids = "";
	for(int i=0; i<whereclauseList.size(); i++){
		String wherec_tmp = (String)whereclauseList.get(i);
		if(wherec_tmp.length() >= 1){
			if("W".equals(wherec_tmp.substring(0, 1))){
				wfids = wfids + ", " + wherec_tmp.substring(1);
			}
		}
	}
	if(!"".equals(wfids)){
		wfids = wfids.substring(1);
		inSelectedStr += "t1.workflowid in ("+wfids+") ";
	}
	whereclause += inSelectedStr;
	if("".equals(whereclause)){
		whereclause = "t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1 ";
	}else{
		whereclause += " and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1 ";
	}
	SearchClause.setWhereClause(whereclause);

    orderclause="t2.receivedate ,t2.receivetime ";

    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);

	response.sendRedirect("WFSearchResult.jsp?start=1");
	return;
}else
//我的请求
if(menuType == 5){
	String wfids = "";
	String nodeids = "";
	for(int i=0; i<whereclauseList.size(); i++){
		String wherec_tmp = (String)whereclauseList.get(i);
		if(wherec_tmp.length() >= 1){
			if("W".equals(wherec_tmp.substring(0, 1))){
				wfids = wfids + ", " + wherec_tmp.substring(1);
			}
		}
	}
	if(!"".equals(wfids)){
		wfids = wfids.substring(1);
		inSelectedStr += "t1.workflowid in ("+wfids+") ";
	}
	whereclause += inSelectedStr;
	
	if("".equals(whereclause)){
		whereclause +=" t1.creater = "+userid+" and t1.creatertype = " + usertype;
	}else{
		whereclause +=" and t1.creater = "+userid+" and t1.creatertype = " + usertype;
	}
	whereclause += " and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1 ";
	SearchClause.setWhereClause(whereclause);

    orderclause="t2.receivedate ,t2.receivetime ";

    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);

	response.sendRedirect("WFSearchResult.jsp?start=1");
	return;
}else
//抄送事宜
if(menuType == 6){
	String wfids = "";
	String nodeids = "";
	for(int i=0; i<whereclauseList.size(); i++){
		String wherec_tmp = (String)whereclauseList.get(i);
		if(wherec_tmp.length() >= 1){
			if("W".equals(wherec_tmp.substring(0, 1))){
				wfids = wfids + ", " + wherec_tmp.substring(1);
			}
		}
	}
	if(!"".equals(wfids)){
		wfids = wfids.substring(1);
		inSelectedStr += "t1.workflowid in ("+wfids+") ";
	}

	whereclause += inSelectedStr;

	if("".equals(whereclause)){
		whereclause +=" t2.isremark in ('8', '9','7') ";
	}else{
		whereclause +=" and t2.isremark in ('8', '9','7') ";
	}

	SearchClause.setWhereClause(whereclause);

    orderclause="t2.receivedate ,t2.receivetime ";

    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);

	response.sendRedirect("WFSearchResult.jsp?start=1");
	return;
}else
//督办事宜
if(menuType == 7){
 
	String wfids = "";
	String nodeids = "";
	for(int i=0; i<whereclauseList.size(); i++){
		String wherec_tmp = (String)whereclauseList.get(i);
		if(wherec_tmp.length() >= 1){
			if("W".equals(wherec_tmp.substring(0, 1))){
				wfids = wfids + "," + wherec_tmp.substring(1);
			}
		}
	}
	if(!"".equals(wfids)){
		wfids = wfids.substring(1);
		inSelectedStr += "t1.workflowid in ("+wfids+") ";
	}
	whereclause += inSelectedStr;

	SearchClause.setWhereClause(whereclause);

    orderclause="t2.receivedate ,t2.receivetime ";
    SearchClause.setWorkflowId(wfids);
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);

	response.sendRedirect("WFSuperviseList.jsp?method=workflow");
	return;
}else
//超时事宜
if(menuType == 8 && !"".equals(hasOvertime)){
	String wfids = "";
	String nodeids = "";
	for(int i=0; i<whereclauseList.size(); i++){
		String wherec_tmp = (String)whereclauseList.get(i);
		if(wherec_tmp.length() >= 1){
			if("W".equals(wherec_tmp.substring(0, 1))){
				wfids = wfids + ", " + wherec_tmp.substring(1);
			}
		}
	}
	if(!"".equals(wfids)){
		wfids = wfids.substring(1);
		inSelectedStr += "t1.workflowid in ("+wfids+") ";
	}
	whereclause += inSelectedStr;
	
	if("".equals(whereclause)){
		whereclause +=" ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') ";
        whereclause += " and t1.currentnodetype <> 3 ";
	}else{
		whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') ";
        whereclause += " and t1.currentnodetype <> 3 ";
	}

	SearchClause.setWhereClause(whereclause);

    orderclause="t2.receivedate ,t2.receivetime ";

    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);

	response.sendRedirect("WFSearchResult.jsp?start=1");
	return;
}else
//反馈事宜
if(menuType == 9 && !"".equals(hasChangStatus)){
	String wfids = "";
	String nodeids = "";
	for(int i=0; i<whereclauseList.size(); i++){
		String wherec_tmp = (String)whereclauseList.get(i);
		if(wherec_tmp.length() >= 1){
			if("W".equals(wherec_tmp.substring(0, 1))){
				wfids = wfids + ", " + wherec_tmp.substring(1);
			}
		}
	}
	if(!"".equals(wfids)){
		wfids = wfids.substring(1);
		inSelectedStr += "t1.workflowid in ("+wfids+") ";
	}
	whereclause += inSelectedStr;

	if("".equals(whereclause)){
		whereclause +=" (( t2.isremark in( '0','1','8','9','7') ";
        whereclause += " and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='7')) or ";
	}else{
		whereclause +=" and (( t2.isremark in( '0','1','8','9','7') ";
        whereclause += " and  t2.viewtype=-1 and t2.islasttimes=1 and ((t2.isremark='0' and (t2.isprocessed is null or (t2.isprocessed<>'2' and t2.isprocessed<>'3'))) or t2.isremark='1' or t2.isremark='8' or t2.isremark='9' or t2.isremark='7')) or ";
	}
	whereclause += " (t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 and t2.viewtype=-1) or ";
	whereclause += " (t1.currentnodetype = 3 and islasttimes=1 and t2.viewtype=-1))";


	SearchClause.setWhereClause(whereclause);

    orderclause="t2.receivedate ,t2.receivetime ";

    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);

	response.sendRedirect("WFSearchResult.jsp?start=1");
	return;
}else{//不是以上任何一个，跳转到安全页面
	inSelectedStr += "t1.workflowid in (0) ";
	whereclause += inSelectedStr;
	SearchClause.setWhereClause(whereclause);

    orderclause="t2.receivedate ,t2.receivetime ";

    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);

	response.sendRedirect("WFSearchResult.jsp?start=1");
	return;
}
%>