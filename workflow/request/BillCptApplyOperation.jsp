<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="CodeBuild" class="weaver.system.code.CodeBuild" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
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

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

String ismode="";
RecordSet.executeSql("select ismode,showdes,printdes from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
}

char flag = 2; 
String updateclause = "" ;
// add record into bill_CptApplyDetail
if( !ismode.equals("1")&&(src.equals("save") || src.equals("submit")) ) {      // 修改细表和主表信息
	if( !iscreate.equals("1") ) RecordSet.executeSql("delete from bill_CptApplyDetail where cptapplyid =" + billid);
    else {
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;
    }

	int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	if(ismode.equals("1")){//图形化模式下的取值，只有一个明细组，取nodesnum0
	    rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum0")));
	}
	float totalamount =0;
	for(int i=0;i<rowsum;i++) {		
		int cpttypeid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+i+"_cpttypeid")),0);
		int cptid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+i+"_cptid")),0);
		int cptcapitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+i+"_cptcapitalid")),0);
		float number = Util.getFloatValue(fu.getParameter("node_"+i+"_number"),-1);
		float unitprice = Util.getFloatValue(fu.getParameter("node_"+i+"_unitprice"),0);
		
		String needdate = Util.null2String(fu.getParameter("node_"+i+"_needdate"));
		String purpose = Util.null2String(fu.getParameter("node_"+i+"_purpose"));
		String cptdesc = Util.null2String(fu.getParameter("node_"+i+"_cptdesc"));
		
		if(ismode.equals("1")){//图形化模式下的取值
		    cpttypeid = Util.getIntValue(Util.null2String(fu.getParameter("field325_"+i)),0);//资产类型
		    cptid = Util.getIntValue(Util.null2String(fu.getParameter("field159_"+i)),0);//资产资料
		    cptcapitalid = Util.getIntValue(Util.null2String(fu.getParameter("field162_"+i)),0);//资产
		    number = Util.getFloatValue(fu.getParameter("field326_"+i),-1);//数量
		    unitprice = Util.getFloatValue(fu.getParameter("field327_"+i),0);//单价
		    needdate = Util.null2String(fu.getParameter("field329_"+i));//购置日期
		    purpose = Util.null2String(fu.getParameter("field160_"+i));//用途
		    cptdesc = Util.null2String(fu.getParameter("field161_"+i));//描述
		}
		
		if(number <=0 ) continue ;
		float amount = number * unitprice;
		
		String para = ""+billid+flag+cpttypeid+flag+cptid+flag+number+flag+unitprice+flag + amount+flag+needdate+flag+purpose+flag+cptdesc+flag+cptcapitalid;
		RecordSet.executeProc("bill_CptApplyDetail_Insert",para);
		totalamount += amount;		
	}					
	updateclause = " set totalamount = "+totalamount+" ";
	updateclause="update bill_CptApplyMain "+updateclause+" where id = "+billid;
	RecordSet.executeSql(updateclause);

}

//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉入库验收 ==开始==
//System.out.println("src=="+src);
//System.out.println("RequestManager.getNextNodetype()=="+RequestManager.getNextNodetype());
if(src.equals("submit")&&RequestManager.getNextNodetype().equals("3")){
	String BuyerID = Util.fromScreen(fu.getParameter("field154"),user.getLanguage());//申购人id
	String CheckerID = Util.fromScreen(""+user.getUID(),user.getLanguage());//验收人id
	String StockInDate = "";//入库日期YYYY-MM-DD
	Calendar today = Calendar.getInstance();
	StockInDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	String currenttime = Util.add0(today.getTime().getHours(), 2) +":"+
                     	 Util.add0(today.getTime().getMinutes(), 2) +":"+
                       Util.add0(today.getTime().getSeconds(), 2) ;
	char separator = Util.getSeparator() ;
	String para = "";
  para +=separator+BuyerID;
  para +=separator+"";
  para +=separator+CheckerID;
  para +=separator+StockInDate;
	para +=separator+"1";
  RecordSet.executeProc("CptStockInMain_Insert",para);
  
  RecordSet.next();
	String cptstockinid=""+RecordSet.getInt(1);
	
	int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	if(ismode.equals("1")){//图形化模式下的取值，只有一个明细组，取nodesnum0
	    rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum0")));
	}
	for(int i=0;i<rowsum;i++) {
		
		String cpttype = Util.null2String(fu.getParameter("node_"+i+"_cptid"));//资产资料
		String plannumber = Util.null2String(fu.getParameter("node_"+i+"_number"));//数量
		String price = Util.null2String(fu.getParameter("node_"+i+"_unitprice"));//单价
		String customerid_dtl = "";//供应商,流程中没有此字段
		String StockInDate_dtl = Util.null2String(fu.getParameter("node_"+i+"_needdate"));//购置日期
		String capitalspec = "";//规格型号,流程中没有此字段
		String location = "";//存放地点,流程中没有此字段
		String Invoice = "";//发票号,流程中没有此字段
		
		if(ismode.equals("1")){//图形化模式下的取值
		    cpttype = Util.null2String(fu.getParameter("field159_"+i));//资产资料
		    plannumber = Util.null2String(fu.getParameter("field326_"+i));//数量
		    price = Util.null2String(fu.getParameter("field327_"+i));//单价
		    StockInDate_dtl = Util.null2String(fu.getParameter("field329_"+i));//购置日期
		}
		plannumber = (int)Util.getFloatValue(plannumber,0) + "";
		
		String sptcount1="";//sptcount1为1表示单独核算
		RecordSet.executeProc("CptCapital_SelectByID",cpttype);
    if(RecordSet.next()){
    	sptcount1 = RecordSet.getString("sptcount");
    }
		if(sptcount1.equals("1")){
		  for (int j=0;j<Util.getIntValue(plannumber,0);j++){//单独核算根据实际入库的数量每个资产单独为一条记录
				para = cptstockinid;
				para +=separator+cpttype;
				para +=separator+"1";//计划入库数量
				para +=separator+"1";//实际入库数量
				para +=separator+price;
			  para +=separator+customerid_dtl;
			  para +=separator+StockInDate_dtl;
			  para +=separator+capitalspec;
			  para +=separator+location;
			  para +=separator+Invoice;
				RecordSet.executeProc("CptStockInDetail_Insert",para);
			}
		}else{
			para = cptstockinid;
			para +=separator+cpttype;
			para +=separator+plannumber;//计划入库数量
			para +=separator+plannumber;//实际入库数量
			para +=separator+price;
		  para +=separator+customerid_dtl;
		  para +=separator+StockInDate_dtl;
		  para +=separator+capitalspec;
		  para +=separator+location;
		  para +=separator+Invoice;
			RecordSet.executeProc("CptStockInDetail_Insert",para);
		}
	}
  
  String departmentid = Util.fromScreen(fu.getParameter("field153"),user.getLanguage());  //入库部门
	String temprequestid 	= "0";     //该工作流的相关工作流	
	String resourceid = "0";		//申购人
	String stateid  = "1";	
	String capitalid = "";
	String tempmark = "";
	String isinner = "";
	String startdate = "";
	String enddate = "";
	String deprestartdate = "";
	String depreenddate = "";
	String manudate = "";
	//String location = "";
	String num = "";
	String tempid = "";
	String tempstr = "";
	para = "";
	String sptcount = "";
	String rltid = "";
	String relatefee = "";//流转相关金额
	String capitalgroupid = "";
	//String capitalspec = "";
	String selectdate ="";//购置日期
	String counttype = "";	
	ArrayList ids = new ArrayList();
	
	String customerid = "";
	String capitalspec = "";
	String location = "";
	String Invoice = "";	
	String stockindate = "";
	String capitaltypeid = "";//资产类型
	String blongsubcompany = "";//所属分部
	String blongdepartment = "";//所属部门
	
	RecordSet.executeProc("CptStockInDetail_SByStockid",cptstockinid);
	while(RecordSet.next()){
		tempid = RecordSet.getString("id");
		capitalid = RecordSet.getString("cpttype");
		num = RecordSet.getString("innumber");
    double innum = Util.getDoubleValue(num);
    double inprice = Util.getDoubleValue(RecordSet.getString("price"));
    customerid=RecordSet.getString("customerid");
    capitalspec=RecordSet.getString("capitalspec");
    location=RecordSet.getString("location");
    Invoice=RecordSet.getString("Invoice");
    stockindate=RecordSet.getString("selectDate");
		selectdate=RecordSet.getString("selectDate");
		relatefee = ""+(innum*inprice);
		
		RecordSetInner.executeProc("CptCapital_SelectByID",capitalid);
    if(RecordSetInner.next()){
    	tempmark = RecordSetInner.getString("mark");
    	sptcount = RecordSetInner.getString("sptcount");
    	//capitalspec = RecordSetInner.getString("capitalspec");
    	capitalgroupid = RecordSetInner.getString("capitalgroupid");
		capitaltypeid = RecordSetInner.getString("capitaltypeid");
    }
    
    //判断是否固资或低耗1:固资2:低耗
    String tempstr2 = "2,3,4,5,6,7,8,9";
    String rootgroupid = capitalgroupid;
    while(true){
			if((CapitalAssortmentComInfo.getSupAssortmentId(rootgroupid)).equals("0")){
				break;
			}
			rootgroupid = CapitalAssortmentComInfo.getSupAssortmentId(rootgroupid);
		}
	
    if(inprice>=2000){   //单独核算的资产(固资或低耗)
        counttype = "1";
    }else{
        counttype = "2";
    }

	/**    
		//自动生成编号
		String	markstr = "";
		int markint = 0;
    int len=5;
    //流水号长度默认为5位当超过最大值自动扩展一位.
    RecordSetInner.executeProc("CptCapital_SCountByDataType",capitalid);
    if(RecordSetInner.next()){
			markstr = Util.null2String(RecordSetInner.getString(1));
			if (!markstr.equals("")  && markstr.length()>tempmark.length()) {
      	markstr = markstr.substring(tempmark.length());
      	markint = Util.getIntValue(markstr,0);
			}
    }
    if(len<String.valueOf(markint+1).length()){
    	len=String.valueOf(markint+1).length();
    }
    tempmark = tempmark+Util.add0(markint+1,len);
	**/

	blongsubcompany = DepartmentComInfo.getSubcompanyid1(departmentid);
	blongdepartment = departmentid;
	
	//获得资产编号
	if(sptcount.equals("1")){
		tempmark = CodeBuild.getCurrentCapitalCode(DepartmentComInfo.getSubcompanyid1(departmentid),departmentid,capitalgroupid,capitaltypeid,selectdate,stockindate,capitalid);
	}

		RecordSetInner.executeProc("CptCapital_SelectByDataType",capitalid+separator+departmentid);
   	if(!sptcount.equals("1") && RecordSetInner.next()){
    	tempmark = RecordSetInner.getString("mark");
    }else if(!sptcount.equals("1")){
    	tempmark = CodeBuild.getCurrentCapitalCode(DepartmentComInfo.getSubcompanyid1(departmentid),departmentid,capitalgroupid,capitaltypeid,selectdate,stockindate,capitalid);
    }

    
    //如果是非单独核算并且部门有此资产那么编号不变
	
		para = stockindate;//入库日期
		para +=separator+"";//流转至部门
		para +=separator+resourceid; //流转至人
		para +=separator+CheckerID; //入库人
		para +=separator+num; //流转数量
		para +=separator+location;
		para +=separator+temprequestid;
		para +=separator+"";//相关公司(入库无)
		para +=separator+relatefee;//相关金额
		para +=separator+stateid;//流转后的状态(使用或库存)
		para +=separator+"";//流转原因(暂空)
		para +=separator+tempmark;//自动生成的资产编号
		para +=separator+capitalid;//datetype
		para +=separator+startdate;
		para +=separator+enddate;
		para +=separator+deprestartdate;
		para +=separator+depreenddate;
		para +=separator+manudate;
		para += separator+CheckerID;
		para += separator+StockInDate;
		para += separator+currenttime;
		
		String para1 = "";
		//复制卡片
    if(sptcount.equals("1")){
        //单独核算
        //复制一项
        para1 =capitalid;
        para1 +=separator+customerid;
        para1 +=separator+""+inprice;
        para1 +=separator+capitalspec;
        para1 +=separator+location;
        para1 +=separator+Invoice;
        para1 +=separator+stockindate;//入库日期
        para1 +=separator+selectdate;//购置日期

        RecordSetInner.executeProc("CptCapital_Duplicate",para1);
        RecordSetInner.next();
        rltid =RecordSetInner.getString(1);

        para = rltid+separator+para;
        para += separator+""+inprice;
        para += separator+customerid;
        para += separator+counttype;
        para += separator+isinner;
        //更新信息,加入入库信息
        RecordSetInner.executeProc("CptUseLogInStock_Insert",para);
		RecordSetInner.executeSql("update cptcapital set olddepartment = " + departmentid + ",blongsubcompany='"+ blongsubcompany +"', blongdepartment='"+ blongdepartment +"' where id = " + rltid);

        //给资产加上权限未经测试
        String ProcPara ="";
        String sharetype="";
        String seclevel="";
        String rolelevel="";
        String sharelevel= "";
        String userid= "";
        String sharedepartmentid="";
        String roleid= "";
        String foralluser= "";

        //判断资产的跟类rootgroupid的权限
        RecordSetInner.executeSql("select * from CptAssortmentShare where assortmentid="+rootgroupid);
        while (RecordSetInner.next()){
            sharetype= RecordSetInner.getString("sharetype");
            seclevel= RecordSetInner.getString("seclevel");
            rolelevel= RecordSetInner.getString("rolelevel");
            sharelevel= RecordSetInner.getString("sharelevel");
            userid= RecordSetInner.getString("userid");
            sharedepartmentid= RecordSetInner.getString("departmentid");
            roleid= RecordSetInner.getString("roleid");
            foralluser= RecordSetInner.getString("foralluser");

            ProcPara = rltid;
            ProcPara += separator+sharetype;
            ProcPara += separator+seclevel;
            ProcPara += separator+rolelevel;
            ProcPara += separator+sharelevel;
            ProcPara += separator+userid;
            ProcPara += separator+sharedepartmentid;
            ProcPara += separator+roleid;
            ProcPara += separator+foralluser;

            RecordSet1.executeProc("CptCapitalShareInfo_Insert",ProcPara);//把资产加入到CptCapitalShareInfo表里
        }
        CptShare.setCptShareByCpt(rltid);//更新detail表

        ids.add(rltid);
    }else{
        //非单独核算
        RecordSetInner.executeProc("CptCapital_SelectByDataType",capitalid+separator+departmentid);
        if(RecordSetInner.next()){
            //该部门已有该资产
            //费用平均
            rltid = RecordSetInner.getString("id");
            double oldprice = Util.getDoubleValue(RecordSetInner.getString("startprice"));
            double oldnum   = Util.getDoubleValue(RecordSetInner.getString("capitalnum"));
            inprice = (oldprice*oldnum+inprice*Util.getDoubleValue(num))/(oldnum+innum);

            para = rltid+separator+para;
            para += separator+""+inprice;
            para += separator+customerid;
            para += separator+counttype;
            para += separator+isinner;

            //更新信息,加入入库信息
            RecordSetInner.executeProc("CptUseLogInStock_Insert",para);

            //修改资产卡片的参考价格为入库价格
            para1 =rltid;
            para1 +=separator+""+inprice;
            para1 +=separator+capitalspec;
            para1 +=separator+customerid;
            para1 +=separator+location;
            para1 +=separator+Invoice;
            para1 +=separator+stockindate;
            RecordSetInner.executeProc("CptCapital_UpdatePrice",para1);  
        }else{
            //该部门没有该资产
            //复制一项
            para1 =capitalid;
            para1 +=separator+customerid;
            para1 +=separator+""+inprice;
            para1 +=separator+capitalspec;
            para1 +=separator+location;
            para1 +=separator+Invoice;
            para1 +=separator+stockindate;//入库日期
            para1 +=separator+selectdate;//购置日期

            RecordSetInner.executeProc("CptCapital_Duplicate",para1);
            RecordSetInner.next();
            rltid =RecordSetInner.getString(1);

            para = rltid+separator+para;
            para += separator+""+inprice;
            para += separator+customerid;
            para += separator+counttype;
            para += separator+isinner;

            //更新信息,加入入库信息
            RecordSetInner.executeProc("CptUseLogInStock_Insert",para);
			RecordSetInner.executeSql("update cptcapital set olddepartment = " + departmentid + ",blongsubcompany='"+ blongsubcompany +"', blongdepartment='"+ blongdepartment +"' where id = " + rltid);

            //给资产加上权限未经测试
            String ProcPara ="";
            String sharetype="";
            String seclevel="";
            String rolelevel="";
            String sharelevel= "";
            String userid= "";
            String sharedepartmentid="";
            String roleid= "";
            String foralluser= "";
            //判断资产的跟类rootgroupid的权限
            RecordSetInner.executeSql("select * from CptAssortmentShare where assortmentid="+rootgroupid);
            while (RecordSetInner.next()){
                sharetype= RecordSetInner.getString("sharetype");
                seclevel= RecordSetInner.getString("seclevel");
                rolelevel= RecordSetInner.getString("rolelevel");
                sharelevel= RecordSetInner.getString("sharelevel");
                userid= RecordSetInner.getString("userid");
                sharedepartmentid= RecordSetInner.getString("departmentid");
                roleid= RecordSetInner.getString("roleid");
                foralluser= RecordSetInner.getString("foralluser");

                ProcPara = rltid;
                ProcPara += separator+sharetype;
                ProcPara += separator+seclevel;
                ProcPara += separator+rolelevel;
                ProcPara += separator+sharelevel;
                ProcPara += separator+userid;
                ProcPara += separator+sharedepartmentid;
                ProcPara += separator+roleid;
                ProcPara += separator+foralluser;

                RecordSet1.executeProc("CptCapitalShareInfo_Insert",ProcPara);//把资产加入到CptCapitalShareInfo表里                
            }
            CptShare.setCptShareByCpt(rltid);//更新detail表

            ids.add(rltid);
        }
    } 
	}
	
	if(ids!=null&&ids.size()>0){//给资产申购人添加查看权限
		for(int ii=0;ii<ids.size();ii++){
			RecordSet1.executeSql("INSERT INTO CptShareDetail ( cptid, userid , usertype, sharelevel )  VALUES ( "+ids.get(ii)+","+BuyerID+", 1, 1)");
		}
	}
	
  CapitalComInfo.addCapitalCache(ids);
  PoppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(),11,"0",Util.getIntValue(cptstockinid));
}
//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉入库验收 ==结束==

boolean logstatus = RequestManager.saveRequestLog() ;

//response.sendRedirect("/workflow/request/RequestView.jsp");
out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
%>