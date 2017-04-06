<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.fna.budget.BudgetApproveWFHandler"%>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
<%@ page import="weaver.fna.budget.BudgetPeriod"%>
<%@ page import="weaver.file.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetBED"class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetBHF"class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page"/>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page"/>
<%
FileUpload fu = new FileUpload(request);

String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = 1;
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));
String topage=URLDecoder.decode(Util.null2String(fu.getParameter("topage")));//返回的页面
if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}


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
    String ismode = "";
    int showdes = 0;
    int modeid = 0;
    RecordSet.executeSql("select ismode,showdes,printdes from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + nodeid);
    if (RecordSet.next()) {
        ismode = Util.null2String(RecordSet.getString("ismode"));
        showdes = Util.getIntValue(Util.null2String(RecordSet.getString("showdes")), 0);
    }
    if (ismode.equals("1") && showdes != 1) {
        RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid=" + workflowid + " and nodeid=" + nodeid);
        if (RecordSet.next()) {
            modeid = RecordSet.getInt("id");
        } else {
            RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid=" + formid + " and isbill='" + isbill + "'");
            if (RecordSet.next()) {
                modeid = RecordSet.getInt("id");
            }
        }
    }
if( (src.equals("save") || src.equals("submit"))&&modeid<1 ) {      // 修改细表和主表信息
    requestid = RequestManager.getRequestid() ;
    billid = RequestManager.getBillid() ;
    String crmids = "";
    String prjids = "";
    Hashtable fieldnameType_hs = new Hashtable();
    ArrayList fieldnameList = new ArrayList();
    RecordSet.execute("select fieldname, type from workflow_billfield where billid=159 and fieldhtmltype=3 and type in (7,18,8,135) and (viewtype is null or viewtype<>1)");
    while(RecordSet.next()){
    	String fieldname_tmp = Util.null2String(RecordSet.getString(1));
    	if("".equals(fieldname_tmp)){
    		continue;
    	}
    	String type_tmp = Util.null2String(RecordSet.getString(2));
    	fieldnameType_hs.put(fieldname_tmp, type_tmp);
    	fieldnameList.add(fieldname_tmp);
    }
    if(fieldnameList.size() <= 0){
    	RecordSet.execute("select * from Bill_FnaBudgetChgApply where requestid="+requestid);
    	if(RecordSet.next()){
    		for(int i=0; i<fieldnameList.size(); i++){
    			String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
    			String type_tmp = Util.null2String((String)fieldnameType_hs.get(fieldname_tmp));
    			String value_tmp = Util.null2String(RecordSet.getString(fieldname_tmp));
    			if(!"".equals(value_tmp)){
    				if("7".equals(type_tmp) || "18".equals(type_tmp)){		//客户字段
    					if(!"".equals(crmids)){
	    					crmids += (","+value_tmp);
    					}else{
    						crmids = value_tmp;
    					}
    				}else if("8".equals(type_tmp) || "135".equals(type_tmp)){		//项目字段
    					if(!"".equals(crmids)){
    						prjids += (","+value_tmp);
    					}else{
    						prjids = value_tmp;
    					}
    				}
    			}
    		}
    	}
    }
    ArrayList detaileditfields=FieldInfo.getSaveDetailFields(formid,isbill,workflowid,nodeid,new ArrayList());
    WFNodeDtlFieldManager.setNodeid(nodeid);
    WFNodeDtlFieldManager.setGroupid(0);
    WFNodeDtlFieldManager.selectWfNodeDtlField();
    String dtldelete = WFNodeDtlFieldManager.getIsdelete();
    if(detaileditfields.size()>0||dtldelete.equals("1")||iscreate.equals("1")){
        if( !iscreate.equals("1") ) RecordSet.executeSql("delete Bill_FnaBudgetChgApplyDetail where id="+billid);
    int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
    for(int i=0;i<rowsum;i++) {
        int organizationtype = Util.getIntValue(fu.getParameter("organizationtype_"+i),3);
		int organizationid = Util.getIntValue(fu.getParameter("organizationid_"+i),0);
        int relatedprj = Util.getIntValue(fu.getParameter("relatedprj_"+i),0);
        int relatedcrm = Util.getIntValue(fu.getParameter("relatedcrm_"+i),0);
//        int relatedhrm = Util.getIntValue(fu.getParameter("relatedhrm_"+i),0);
        double amount= Util.getDoubleValue(fu.getParameter("amount_"+i),0);
        double oldamount = Util.getDoubleValue(fu.getParameter("oldamount_"+i),0);
        double applyamount= Util.getDoubleValue(fu.getParameter("applyamount_"+i),0);
        String subject = Util.null2String(fu.getParameter("subject_"+i));
        String budgetperiod = Util.null2String(fu.getParameter("budgetperiod_"+i));
        String description = Util.toHtml(fu.getParameter("description_"+i));
        //if(applyamount == 0 ) continue ;
        if(organizationid==0&&relatedprj==0&&relatedcrm==0&&amount==0&&applyamount==0&&subject.equals("")&&budgetperiod.equals("")&&description.equals("")) {
             continue ;
        }
        if(relatedcrm > 0){
        	if(!"".equals(crmids)){
				crmids += (","+relatedcrm);
			}else{
				crmids = ""+relatedcrm;
			}
        }
        if(relatedprj > 0){
        	if(!"".equals(prjids)){
        		prjids += (","+relatedprj);
			}else{
				prjids = ""+relatedprj;
			}
        }
        if(subject.equals(""))
        subject="0";
        //if(amount==0) amount=applyamount;
        //TD12002
        //String sql="insert into Bill_FnaBudgetChgApplyDetail (id,organizationtype,organizationid,amount,subject,description,budgetperiod,relatedprj,relatedcrm,applyamount,dsporder) values("+billid+","+ organizationtype +","+ organizationid+","
        //             + amount+","+ subject +",'"+description+"','"+budgetperiod+"',"+relatedprj+","+relatedcrm+","+applyamount+","+i+")";
        String sql="insert into Bill_FnaBudgetChgApplyDetail (id,organizationtype,organizationid,amount,subject,description,budgetperiod,relatedprj,relatedcrm,oldamount,applyamount,dsporder) values("+billid+","+ organizationtype +","+ organizationid+","
                     + BudgetHandler.getDoubleValue(amount, 3)+","+ subject +",'"+description+"','"+budgetperiod+"',"+relatedprj+","+relatedcrm+","+BudgetHandler.getDoubleValue(oldamount, 3)+","+BudgetHandler.getDoubleValue(applyamount, 3)+","+i+")";


        //System.out.println("sql:"+sql);
        RecordSet.executeSql(sql);
	}
    }
    RequestManager.setCrmids(crmids);
    RequestManager.setPrjids(prjids);
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;

if(!topage.equals("")){
	if(topage.indexOf("?")!=-1){
		//response.sendRedirect(topage+"&requestid="+requestid);
		out.print("<script>wfforward('"+topage+"&requestid="+requestid+"');</script>");
	}else{
		//response.sendRedirect(topage+"?requestid="+requestid);
		out.print("<script>wfforward('"+topage+"?requestid="+requestid+"');</script>");
	}	
}

if (RequestManager.getNextNodetype().equals("3")) {
    if(modeid<1){
		//TD30937 start by lv 
		HashMap budgetAmountMap = new HashMap();//key=部门类型_预算单位_科目 , value=审批预算
		//TD30937 end by lv 
		int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
		for(int i=0;i<rowsum;i++) {
			int organizationtype = Util.getIntValue(fu.getParameter("organizationtype_"+i),3);
			int organizationid = Util.getIntValue(fu.getParameter("organizationid_"+i),0);
			int relatedprj = Util.getIntValue(fu.getParameter("relatedprj_"+i),0);
			int relatedcrm = Util.getIntValue(fu.getParameter("relatedcrm_"+i),0);
			double amount= Util.getDoubleValue(fu.getParameter("amount_"+i),0);
			double applyamount= Util.getDoubleValue(fu.getParameter("applyamount_"+i),0);
			String subject = Util.null2String(fu.getParameter("subject_"+i));
			String budgetperiod = Util.null2String(fu.getParameter("budgetperiod_"+i));
			String description = Util.toHtml(fu.getParameter("description_"+i));
			if(applyamount == 0 ||organizationid<=0) continue ;
			if(subject.equals(""))
			subject="0";
			if(amount==0)
			amount=applyamount;
			
			//TD30937 start by lv 
			//计算同部门类型同预算单位同科目的累计审批预算总额
			BudgetPeriod bp = BudgetHandler.getBudgetPeriod(budgetperiod, Util.getIntValue(subject));
			//TD 39652 start
			if(bp == null) {
				continue;
			}
			//TD 39652 end
			String budgetAmountMapKey = organizationtype + "_" + organizationid + "_" + subject + "_" + bp.getPeriod() + "_" + bp.getPeriodlist();
			double budgetAmountMapValue = 0;
			if(budgetAmountMap.get(budgetAmountMapKey)==null ){
				budgetAmountMapValue = amount;
			}else{
				budgetAmountMapValue = ((Double)budgetAmountMap.get(budgetAmountMapKey)).doubleValue() + amount;
			}
			//加入到map
			budgetAmountMap.put(budgetAmountMapKey,new Double(budgetAmountMapValue));

			BudgetApproveWFHandler bwfh=new  BudgetApproveWFHandler();
			//更新审批预算总额
			bwfh.changeBudget(budgetperiod,organizationtype,organizationid,Util.getIntValue(subject),budgetAmountMapValue);
			System.out.println("budgetAmountMapKey="+budgetAmountMapKey+", budgetAmountMapValue="+budgetAmountMapValue);
			//TD30937 end by lv
			
		}
    }else{
		//TD30937 start by lv 
		HashMap budgetAmountMap = new HashMap();//key=部门类型_预算单位_科目 , value=审批预算
		//TD30937 end by lv 
        RecordSet.executeSql("select * from Bill_FnaBudgetChgApplyDetail where id=" + billid);
        while (RecordSet.next()) {
            int organizationtype = Util.getIntValue(RecordSet.getString("organizationtype"),3);
            int organizationid = Util.getIntValue(RecordSet.getString("organizationid"),0);
            double amount = Util.getDoubleValue(RecordSet.getString("amount"), 0);
            double applyamount = Util.getDoubleValue(RecordSet.getString("applyamount"), 0);
            int relatedprj = Util.getIntValue(RecordSet.getString("relatedprj"), 0);
            int relatedcrm = Util.getIntValue(RecordSet.getString("relatedcrm"), 0);
            String subject = Util.null2String(RecordSet.getString("subject"));
            String budgetperiod = Util.null2String(RecordSet.getString("budgetperiod"));
            String description = Util.null2String(RecordSet.getString("description"));
            if(applyamount == 0||organizationid<=0) continue ;
            if(subject.equals(""))
            subject="0";
            if(amount==0)
            amount=applyamount;
           
			//TD30937 start by lv 
			//计算同部门类型同预算单位同科目的累计审批预算总额
			BudgetPeriod bp = BudgetHandler.getBudgetPeriod(budgetperiod, Util.getIntValue(subject));
			//TD 39652 start
			if(bp == null) {
				continue;
			}
			//TD 39652 end
			String budgetAmountMapKey = organizationtype + "_" + organizationid + "_" + subject + "_" + bp.getPeriod() + "_" + bp.getPeriodlist();
			double budgetAmountMapValue = 0;
			if(budgetAmountMap.get(budgetAmountMapKey)==null ){
				budgetAmountMapValue = amount;
			}else{
				budgetAmountMapValue = ((Double)budgetAmountMap.get(budgetAmountMapKey)).doubleValue() + amount;
			}
			//加入到map
			budgetAmountMap.put(budgetAmountMapKey,new Double(budgetAmountMapValue));

            BudgetApproveWFHandler bwfh=new  BudgetApproveWFHandler();
			//更新审批预算总额
            bwfh.changeBudget(budgetperiod,organizationtype,organizationid,Util.getIntValue(subject),budgetAmountMapValue);
			System.out.println("budgetAmountMapKey="+budgetAmountMapKey+", budgetAmountMapValue="+budgetAmountMapValue);
			//TD30937 end by lv 
        }
    }
}
    WFManager.setWfid(workflowid);
    WFManager.getWfInfo();
    String isShowChart = Util.null2String(WFManager.getIsShowChart());
    if ("1".equals(isShowChart)) {
        //response.sendRedirect("/workflow/request/WorkflowDirection.jsp?requestid=" + requestid + "&workflowid=" + workflowid + "&isbill=" + isbill + "&formid=" + formid);
		out.print("<script>wfforward('/workflow/request/WorkflowDirection.jsp?requestid=" + requestid + "&workflowid=" + workflowid + "&isbill=" + isbill + "&formid=" + formid+"');</script>");
    } else {
		//response.sendRedirect("/workflow/request/RequestView.jsp");
		out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
    }


%>

