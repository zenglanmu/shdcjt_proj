<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<%@ page import="weaver.file.FileUpload" %>
<%
FileUpload fu = new FileUpload(request);
String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));
String[] check_node_vals = fu.getParameterValues("check_node_val");

if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}
ArrayList frozennumList = new ArrayList();
ArrayList capitalidList = new ArrayList();

int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
boolean overStore = false;

if(src.equals("submit")||(!nodetype.equals("0")&&src.equals("save"))){//提交时更新资产的冻结数量
	try{
		//创建节点提交
		if(nodetype.equals("0")){
			for(int i=0;i<rowsum;i++){
				float number = Util.getFloatValue(fu.getParameter("node_"+i+"_number"),0);//领用数量
				if (number <= 0) number=0;
				int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+i+"_capitalid")),0);

				RecordSet2.executeSql("update CptCapital set frozennum = frozennum+"+number+" where id="+capitalid);
			}
		}else{
			//非创建节点提交
			Map<Integer,Float> calMap = new HashMap<Integer,Float>();
			for(int i=0;i<rowsum;i++){
				float number = Util.getFloatValue(fu.getParameter("node_"+i+"_number"),0);//领用数量
				if (number <= 0) number=0;
				int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+i+"_capitalid")),0);

				Float val = calMap.get(capitalid);
				if(val == null){
					calMap.put(capitalid,number);
				}else{
					calMap.put(capitalid,val.floatValue()+number);
				}
			}
			RecordSet.executeSql("select capitalid,sum(number_n) from bill_CptFetchDetail where cptfetchid = (select id from bill_CptFetchMain where requestid="+requestid+") group by capitalid");
			while(RecordSet.next()){
				int cptid = RecordSet.getInt(1);
				float frozennum = RecordSet.getFloat(2);
				//System.out.println("非创建节点===update CptCapital set frozennum = frozennum" + ((calMap.get(cptid)-frozennum)>0?"+":"-") +(Math.abs(calMap.get(cptid)-frozennum))+" where id="+cptid);
				RecordSet2.executeSql("update CptCapital set frozennum = frozennum" + ((calMap.get(cptid)-frozennum)>0?"+":"-") +(Math.abs(calMap.get(cptid)-frozennum))+" where id="+cptid);
			}
		}
	}catch(Exception exception){
	}
}else if("reject".equals(src)){//退回  如果退回到创建节点，则释放该流程所冻结的资产数
	try{
		RecordSetTrans.executeSql("select destnodeid as lastnodeid from workflow_nodelink where workflowid="+workflowid+" and nodeid="+nodeid+" and isreject='1'");
		if(RecordSetTrans.next()){
			int lastnodeid = RecordSetTrans.getInt("lastnodeid");
			RecordSetTrans.executeSql("select nodetype as lastnodetype from workflow_flownode where nodeid="+lastnodeid);
			if(RecordSetTrans.next()){
				String lastnodetype = RecordSetTrans.getString("lastnodetype");
				if(lastnodetype.equals("0")){//退回到创建节点
					for(int i=0;i<rowsum;i++){
						int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+i+"_capitalid")),0);
						float capitalidnum = Util.getFloatValue(fu.getParameter("node_"+i+"_number"),0);
					
						RecordSetTrans.executeSql("update CptCapital set frozennum=frozennum-"+capitalidnum+" where id="+capitalid);
					}
				}
			}
		}
	}catch(Exception exception){
	}
}
//td13521
if(overStore) src = "save";

RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
//add by chengfeng.han 2011-7-28 td20647 
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
RequestManager.setIsagentCreater(isagentCreater);
RequestManager.setBeAgenter(beagenter);
//end
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

char flag = 2; 
String updateclause = "" ;
// add record into bill_CptApplyDetail
if( src.equals("save") || src.equals("submit") ) {      // 修改细表和主表信息
	if( !iscreate.equals("1") ) RecordSet.executeSql("delete from bill_CptFetchDetail where cptfetchid =" + billid);
    else {
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;
    }

	//int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	float totalamount =0;
	
	for(int i=0;i<rowsum;i++) {		
		String idval = ""+i;
		if(check_node_vals!=null){
			idval = check_node_vals[i];
		 }
		int cptid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+idval+"_cptid")),0);
		int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+idval+"_capitalid")),0);
		float number = Util.getFloatValue(fu.getParameter("node_"+idval+"_number"),0);
		float unitprice = Util.getFloatValue(fu.getParameter("node_"+idval+"_unitprice"),0);
		float amount = number * unitprice;
		String needdate = Util.null2String(fu.getParameter("node_"+idval+"_needdate"));
		String purpose = Util.null2String(fu.getParameter("node_"+idval+"_purpose"));
		String cptdesc = Util.null2String(fu.getParameter("node_"+idval+"_cptdesc"));
		String para = ""+billid+flag+cptid+flag+capitalid+flag+number+flag+unitprice+flag + amount+flag+needdate+flag+purpose+flag+cptdesc;
		RecordSet.executeProc("bill_CptFetchDetail_Insert",para);
		totalamount += amount;		
	}					
	updateclause += " set totalamount = "+totalamount+" ";
	updateclause="update bill_CptFetchMain "+updateclause+" where id = "+billid;
	RecordSet.executeSql(updateclause);

}
if(overStore){
    out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message=201');</script>");
    return ;
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
    //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
    out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
    return ;
}

//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉资产领用 ==开始==
if(src.equals("submit")&&RequestManager.getNextNodetype().equals("3")){
//System.out.println("Here.................");
	String para = "";
	
	String capitalid = "";
	String capitalnum = "";
	String resourceid = "";
	String departmentid = "";
	String tempremark = "";
	String sptcount = "";
	String location="";
	boolean isoracle = RecordSet.getDBType().equals("oracle");
	String sqltemp="";
	String useddate = "";
	
	resourceid = Util.null2String(fu.getParameter("field208"));//申请人
	departmentid = Util.null2String(fu.getParameter("field207"));//部门
	
	//int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	for(int i=0;i<rowsum;i++){
		capitalid = Util.null2String(fu.getParameter("node_"+i+"_capitalid"));//领用资产
		capitalnum = Util.null2String(fu.getParameter("node_"+i+"_number"));//领用数量
		if(Util.getFloatValue(capitalnum,0)<=0) continue;
		tempremark = Util.null2String(fu.getParameter("node_"+i+"_purpose"))+"/"+Util.null2String(fu.getParameter("node_"+i+"_cptdesc"));//备注=用途+描述
		
		String cpttype = Util.null2String(fu.getParameter("node_"+i+"_capitalid"));//资产资料
		RecordSet.executeProc("CptCapital_SelectByID",cpttype);
    if(RecordSet.next()){
    	sptcount = RecordSet.getString("sptcount");//是否单独核算
    }
    
    location = "";//存放地点，流程中没有此字段。
    useddate = Util.null2String(fu.getParameter("node_"+i+"_needdate"));//领用日期

    if(!capitalid.equals("")){
    if(sptcount.equals("1")){
        para = capitalid;
        para +=flag+useddate;
        para +=flag+departmentid;
        para +=flag+resourceid;
        para +=flag+"1";
        //para +=flag+userequest;
        para +=flag+"";
        para +=flag+"0";
        para +=flag+"2";
        para +=flag+tempremark;
        para +=flag+location;
        para +=flag+sptcount;

        RecordSet.executeProc("CptUseLogUse_Insert",para);
    }else{ 
        para = capitalid;
        para +=flag+useddate;
        para +=flag+departmentid;
        para +=flag+resourceid;
        para +=flag+capitalnum;
        // para +=separator+userequest; 
        para +=flag+"";    
        para +=flag+"0";  
        para +=flag+"2";
        para +=flag+tempremark;
        para +=flag+location;
        para +=flag+"0";

        RecordSet.executeProc("CptUseLogUse_Insert",para);
    }

    RecordSet.executeProc("HrmInfoStatus_UpdateCapital",""+resourceid);
    CapitalComInfo.removeCapitalCache();
    CptShare.setCptShareByCpt(capitalid);//更新detail表
    
    if(!location.equals("")){
        RecordSet.executeSql("update CptCapital set location='"+location+"' where id="+capitalid);
    }

    //更新折旧开始时间

    if(!isoracle){
        sqltemp="update CptCapital set deprestartdate='"+useddate+"' where id="+capitalid+" and (deprestartdate is null or deprestartdate='')";
    }else{
        sqltemp="update CptCapital set deprestartdate='"+useddate+"' where id="+capitalid+" and deprestartdate is null";
    }
    RecordSet.executeSql(sqltemp);
    }
    
    //更新冻结数量
    float old_frozennum = 0.0f;
    float new_frozennum = 0.0f;
    RecordSet.executeSql("select frozennum as old_frozennum from CptCapital where id="+capitalid);
    if(RecordSet.next())	old_frozennum = RecordSet.getFloat("old_frozennum");
    new_frozennum = old_frozennum - Util.getFloatValue(capitalnum);
    RecordSet.executeSql("update CptCapital set frozennum="+new_frozennum+" where id="+capitalid);
	}
}
//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉资产领用 ==结束==

boolean logstatus = RequestManager.saveRequestLog() ;

WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String isShowChart = Util.null2String(WFManager.getIsShowChart());
if ("1".equals(isShowChart)) {
	out.print("<script>wfforward('/workflow/request/WorkflowDirection.jsp?requestid=" + requestid + "&workflowid=" + workflowid + "&isbill=" + isbill + "&formid=" + formid+"');</script>");
} else{
//response.sendRedirect("/workflow/request/RequestView.jsp");
	out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
}
%>