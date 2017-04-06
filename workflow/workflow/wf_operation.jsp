<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.Writer" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<!--add by xhheng @ 2004/12/08 for TDID 1317-->
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<%WFNodeFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%WFNodeDtlFieldManager.resetParameter();%>
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<%WFNodePortalMainManager.resetParameter();%>
<jsp:useBean id="WFNodeOperatorManager" class="weaver.workflow.workflow.WFNodeOperatorManager" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="TestWorkflowComInfo" class="weaver.workflow.workflow.TestWorkflowComInfo" scope="page" />
<%WFNodeOperatorManager.resetParameter();%>
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<%RequestCheckUser.resetParameter();%>
<jsp:useBean id="RequestUserDefaultManager" class="weaver.workflow.request.RequestUserDefaultManager" scope="page"/>
<jsp:useBean id="wFNodeFieldManager" class="weaver.workflow.workflow.WFNodeFieldManager" scope="page"/>
<%
  if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}  
  int design = Util.getIntValue(request.getParameter("design"),0);
  String ajax=Util.null2String(request.getParameter("ajax"));
  String isTemplate=Util.null2String(request.getParameter("isTemplate"));
  int templateid=Util.getIntValue(request.getParameter("templateid"),0);
  int selectedCateLog = Util.getIntValue(request.getParameter("selectcatalog"),0);
  int catelogType = Util.getIntValue(request.getParameter("catalogtype"),0);
  String src = Util.null2String(request.getParameter("src"));
    int subCompanyId = Util.getIntValue(request.getParameter("subcompanyid"),-1); //add by wjy
////得到标记信息
  if(src.equalsIgnoreCase("addwf")){      
      int wfid=0;
    if(templateid>0){
		
        WFManager.reset();
        WFManager.setWfname(Util.null2String(request.getParameter("wfname")));
  	    WFManager.setWfdes(Util.null2String(request.getParameter("wfdes")));
        wfid=WFManager.setWFTemplate(templateid,isTemplate,user.getUID(),request.getRemoteAddr());

		WorkflowComInfo.removeWorkflowCache();
        TestWorkflowComInfo.removeWorkflowCache();
		RequestUserDefaultManager.addDefaultOfSysAdmin(String.valueOf(wfid));
		String hisWorkflowCreater="";
		RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);

    }else{
	WFManager.reset();
  	WFManager.setAction("addwf");
  	WFManager.setWfname(Util.null2String(request.getParameter("wfname")));
  	WFManager.setWfdes(Util.null2String(request.getParameter("wfdes")));        
  	WFManager.setTypeid(Util.getIntValue(Util.null2String(request.getParameter("typeid"))));
  	String isbill = Util.null2String(request.getParameter("isbill"));
  	String iscust = Util.null2String(request.getParameter("iscust"));
  	int helpdocid = Util.getIntValue(request.getParameter("helpdocid"),0);
    String isvalid= Util.null2String(request.getParameter("isvalid"));
    String needmark= Util.null2String(request.getParameter("needmark"));
    //add by xhheng @ 2005/01/24 for 消息提醒 Request06
    String messageType= Util.null2String(request.getParameter("messageType"));
    //add by xwj  20051101 for 邮件提醒 td2965
    String mailMessageType= Util.null2String(request.getParameter("mailMessageType"));
    String forbidAttDownload= Util.null2String(request.getParameter("forbidAttDownload"));
    String docRightByOperator= Util.null2String(request.getParameter("docRightByOperator"));
    //add by xhheng @ 20050302 for TD 1545
    String multiSubmit= Util.null2String(request.getParameter("multiSubmit"));
    //add by xhheng @ 20050303 for TD 1689
    String defaultName= Util.null2String(request.getParameter("defaultName"));
    //add by xhheng @ 20050317 for 附件上传
    String pathcategory= Util.null2String(request.getParameter("pathcategory"));
    String maincategory= Util.null2String(request.getParameter("maincategory"));
    String subcategory= Util.null2String(request.getParameter("subcategory"));
    String seccategory= Util.null2String(request.getParameter("seccategory"));
    int docRightByHrmResource = Util.getIntValue(request.getParameter("docRightByHrmResource"),0);
    String isaffirmance= Util.null2String(request.getParameter("isaffirmance"));
	String isremak= Util.null2String(request.getParameter("isremark"));
	String isShowChart= Util.null2String(request.getParameter("isShowChart"));
	String orderbytype= Util.null2String(request.getParameter("orderbytype"));
	String isModifyLog = Util.null2String(request.getParameter("isModifyLog"));
    String isannexUpload= Util.null2String(request.getParameter("isannexUpload"));
    String annexmaincategory= Util.null2String(request.getParameter("annexmaincategory"));
    String annexsubcategory= Util.null2String(request.getParameter("annexsubcategory"));
    String annexseccategory= Util.null2String(request.getParameter("annexseccategory"));
    String isShowOnReportInput= Util.null2String(request.getParameter("isShowOnReportInput"));
    String ShowDelButtonByReject=Util.null2String(request.getParameter("ShowDelButtonByReject"));
    
    String specialApproval=Util.null2String(request.getParameter("specialApproval"));//是否特批件
    String Frequency=Util.null2String(request.getParameter("Frequency"));
    if(Frequency.equals("")) Frequency = "0";
    String Cycle=Util.null2String(request.getParameter("Cycle"));
    
    String isimportwf=Util.null2String(request.getParameter("isimportwf"));
	String wfdocpath = Util.null2String(request.getParameter("wfdocpath"));
	String newdocpath = Util.null2String(request.getParameter("newdocpath"));
	String wfdocowner = Util.null2String(request.getParameter("wfdocowner"));
	String wfdocownertype = ""+Util.getIntValue(request.getParameter("wfdocownertype"), 0);
	String wfdocownerfieldid = ""+Util.getIntValue(request.getParameter("wfdocownerfieldid"), 0);
	String isImportDetail= Util.null2String(request.getParameter("isImportDetail")); 
    String showUploadTab = Util.null2String(request.getParameter("showUploadTab"));
    String isSignDoc = Util.null2String(request.getParameter("isSignDoc"));
    String showDocTab = Util.null2String(request.getParameter("showDocTab"));
    String isSignWorkflow = Util.null2String(request.getParameter("isSignWorkflow"));
    String showWorkflowTab = Util.null2String(request.getParameter("showWorkflowTab"));
    int isforwardrights = Util.getIntValue(request.getParameter("isforwardrights"),0);
    String isrejectremind=Util.null2String(request.getParameter("isrejectremind"));
    String ischangrejectnode=Util.null2String(request.getParameter("ischangrejectnode"));
	   String isselectrejectnode=Util.null2String(request.getParameter("isselectrejectnode")); 
    String issignview = Util.null2String(request.getParameter("issignview"));
	String nosynfields = Util.null2String(request.getParameter("nosynfields"));
	String isneeddelacc=Util.null2String(request.getParameter("isneeddelacc"));
	String SAPSource = Util.null2String(request.getParameter("SAPSource"));
    if("".equals(isneeddelacc))  isneeddelacc="0";
	int formid = 0;
  	if(isbill.equals("0")){
  		formid = Util.getIntValue(Util.null2String(request.getParameter("formid")));
  		
			String tablename = "";
			RecordSet.executeSql("select tablename from workflow_bill where id="+formid);	
			if(RecordSet.next()) tablename = RecordSet.getString("tablename");
			if(tablename.equals("formtable_main_"+formid*(-1))){//新创建的表单做为单据保存
				isbill = "1";
			}
  	}
  	else {
  		formid = Util.getIntValue(Util.null2String(request.getParameter("billid")));
  		if (isbill.equals("1") && formid == -1)
  					formid = Util.getIntValue(Util.null2String(request.getParameter("formid")));
    }
  	
  	//是否允许创建人删除附件
  	String candelacc= Util.null2String(request.getParameter("candelacc"));
  	
  	WFManager.setFormid(formid);
  	WFManager.setIsBill(isbill);
  	WFManager.setIsCust(iscust);
  	WFManager.setHelpdocid(helpdocid);
    WFManager.setIsValid(isvalid);
    WFManager.setNeedMark(needmark);
    WFManager.setMessageType(messageType);
    WFManager.setMailMessageType(mailMessageType);//added by xwj for td2965 20051101
    WFManager.setForbidAttDownload(forbidAttDownload);
    WFManager.setDocRightByOperator(docRightByOperator);
    WFManager.setMultiSubmit(multiSubmit);
    WFManager.setDefaultName(defaultName);
    WFManager.setDocCategory(maincategory+","+subcategory+","+seccategory);
    WFManager.setDocPath(pathcategory);
    WFManager.setSubCompanyId2(subCompanyId);
    WFManager.setIsTemplate(isTemplate);
    WFManager.setTemplateid(templateid);
    WFManager.setCatelogType(catelogType);
    WFManager.setSelectedCateLog(selectedCateLog);
    WFManager.setDocRightByHrmResource(docRightByHrmResource);
    WFManager.setIsaffirmance(isaffirmance);
	 WFManager.setIsremak(isremak);
	 WFManager.setIsShowChart(isShowChart);
	 WFManager.setOrderbytype(orderbytype);
    WFManager.setIsAnnexUpload(isannexUpload);
    WFManager.setAnnexDocCategory(annexmaincategory+","+annexsubcategory+","+annexseccategory);
    WFManager.setIsShowOnReportInput(isShowOnReportInput);
    WFManager.setIsModifyLog(isModifyLog);
    WFManager.setShowDelButtonByReject(ShowDelButtonByReject);
    
    WFManager.setSpecialApproval(specialApproval);
    WFManager.setFrequency(Frequency);
    WFManager.setCycle(Cycle);
    
    WFManager.setIsImportwf(isimportwf);
	WFManager.setWfdocpath(wfdocpath);
	WFManager.setWfdocowner(wfdocowner);
	WFManager.setWfdocownertype(wfdocownertype);
	WFManager.setWfdocownerfieldid(wfdocownerfieldid);
    WFManager.setShowUploadTab(showUploadTab);
    WFManager.setSignDoc(isSignDoc);
    WFManager.setShowDocTab(showDocTab);
    WFManager.setSignWorkflow(isSignWorkflow);
    WFManager.setShowWorkflowTab(showWorkflowTab);
    WFManager.setCanDelAcc(candelacc);
    WFManager.setIsforwardRights(""+isforwardrights);
    WFManager.setIsrejectremind(isrejectremind);
    WFManager.setIschangrejectnode(ischangrejectnode);
    WFManager.setNewdocpath(newdocpath);
    WFManager.setIssignview(issignview);
	WFManager.setNosynfields(nosynfields);
	WFManager.setSAPSource(SAPSource);
    WFManager.setIsSelectrejectNode(isselectrejectnode);
	WFManager.setIsImportDetail(isImportDetail);
	WFManager.setIsneeddelacc(isneeddelacc);
    wfid=WFManager.setWfInfo();

    WorkflowComInfo.removeWorkflowCache();
    TestWorkflowComInfo.removeWorkflowCache();
	RequestUserDefaultManager.addDefaultOfSysAdmin(String.valueOf(wfid));

    //Start 手机接口功能 by alan
    RecordSet.executeSql("DELETE FROM workflow_mgmsworkflows WHERE workflowid="+wfid);
    if(Util.null2String(request.getParameter("isMgms")).equals("1")){
    	RecordSet.executeSql("INSERT INTO workflow_mgmsworkflows(workflowid) VALUES ("+wfid+")");
    }	
    //End 手机接口功能
    
    //add by xhheng @ 2004/12/08 for TDID 1317 start
    //新增工作流日志
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(wfid);
    SysMaintenanceLog.setRelatedName(Util.null2String(request.getParameter("wfname")));
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("WrokFlow_insert");
    SysMaintenanceLog.setOperateItem("85");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setIstemplate(Util.getIntValue(isTemplate));
    SysMaintenanceLog.setSysLogInfo();
    //add by xhheng @ 2004/12/08 for TDID 1317 end
    }
//    WorkflowComInfo.removeWorkflowCache();
    if(!ajax.equals("1"))
    response.sendRedirect("managewf.jsp");
      else{
    response.sendRedirect("addwf.jsp?src=editwf&isloadleft=1&wfid="+wfid+"&isTemplate="+isTemplate);
      }
    return;

  }
  else if(src.equalsIgnoreCase("editwf")){
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	
    String oldisbill = Util.null2String(request.getParameter("oldisbill"));
  	String oldiscust = Util.null2String(request.getParameter("oldiscust"));
  	String isbill = Util.null2String(request.getParameter("isbill"));
  	String iscust = Util.null2String(request.getParameter("iscust"));
  	int helpdocid = Util.getIntValue(request.getParameter("helpdocid"),0);
    String isvalid= Util.null2String(request.getParameter("isvalid"));
    String needmark= Util.null2String(request.getParameter("needmark"));
    //add by xhheng @ 2005/01/24 for 消息提醒 Request06
    String messageType= Util.null2String(request.getParameter("messageType"));
     //add by xwj  20051101 for 邮件提醒 td2965
    String mailMessageType= Util.null2String(request.getParameter("mailMessageType"));
    String forbidAttDownload= Util.null2String(request.getParameter("forbidAttDownload"));
    String docRightByOperator= Util.null2String(request.getParameter("docRightByOperator"));
    //add by xhheng @ 20050302 for TD 1545
    String multiSubmit= Util.null2String(request.getParameter("multiSubmit"));
    //add by xhheng @ 20050303 for TD 1689
    String defaultName= Util.null2String(request.getParameter("defaultName"));
    //add by xhheng @ 20050317 for 附件上传
    String pathcategory= Util.null2String(request.getParameter("pathcategory"));
    String maincategory= Util.null2String(request.getParameter("maincategory"));
    String subcategory= Util.null2String(request.getParameter("subcategory"));
    String seccategory= Util.null2String(request.getParameter("seccategory"));
    int docRightByHrmResource = Util.getIntValue(request.getParameter("docRightByHrmResource"),0);
    String isaffirmance= Util.null2String(request.getParameter("isaffirmance"));
	String isremak= Util.null2String(request.getParameter("isremark"));
	String isShowChart= Util.null2String(request.getParameter("isShowChart"));
	String orderbytype= Util.null2String(request.getParameter("orderbytype"));
	String isModifyLog= Util.null2String(request.getParameter("isModifyLog"));
    String isannexUpload= Util.null2String(request.getParameter("isannexUpload"));
    String annexmaincategory= Util.null2String(request.getParameter("annexmaincategory"));
    String annexsubcategory= Util.null2String(request.getParameter("annexsubcategory"));
    String annexseccategory= Util.null2String(request.getParameter("annexseccategory"));
    String isShowOnReportInput= Util.null2String(request.getParameter("isShowOnReportInput"));
    String ShowDelButtonByReject=Util.null2String(request.getParameter("ShowDelButtonByReject"));
    
    String specialApproval=Util.null2String(request.getParameter("specialApproval"));
    String Frequency=Util.null2String(request.getParameter("Frequency"));
    if(Frequency.equals("")) Frequency = "0";
    String Cycle=Util.null2String(request.getParameter("Cycle"));
    
    String isimportwf=Util.null2String(request.getParameter("isimportwf"));
	String wfdocpath = Util.null2String(request.getParameter("wfdocpath"));
	String wfdocowner = Util.null2String(request.getParameter("wfdocowner"));
	String wfdocownertype = ""+Util.getIntValue(request.getParameter("wfdocownertype"), 0);
	String wfdocownerfieldid = ""+Util.getIntValue(request.getParameter("wfdocownerfieldid"), 0);
    String showUploadTab = Util.null2String(request.getParameter("showUploadTab"));
    String isImportDetail= Util.null2String(request.getParameter("isImportDetail")); 
	String isSignDoc = Util.null2String(request.getParameter("isSignDoc"));
    String showDocTab = Util.null2String(request.getParameter("showDocTab"));
    String isSignWorkflow = Util.null2String(request.getParameter("isSignWorkflow"));
    String showWorkflowTab = Util.null2String(request.getParameter("showWorkflowTab"));
    int isforwardrights = Util.getIntValue(request.getParameter("isforwardrights"),0);
    String isrejectremind=Util.null2String(request.getParameter("isrejectremind"));
	   String isselectrejectnode=Util.null2String(request.getParameter("isselectrejectnode"));
   String ischangrejectnode=Util.null2String(request.getParameter("ischangrejectnode")); 
    String issignview = Util.null2String(request.getParameter("issignview"));
	String nosynfields = Util.null2String(request.getParameter("nosynfields"));
	String SAPSource = Util.null2String(request.getParameter("SAPSource"));
    int formid = 0;
    int oldformid=Util.getIntValue(Util.null2String(request.getParameter("oldformid")));
	String newdocpath = Util.null2String(request.getParameter("newdocpath"));
	String isneeddelacc=Util.null2String(request.getParameter("isneeddelacc"));
	 if("".equals(isneeddelacc))  isneeddelacc="0";
	RecordSet.executeSql("select * from workflow_base where id = " + wfid);
	if(RecordSet.next()){
		wfdocpath = RecordSet.getString("wfdocpath");
		wfdocowner = RecordSet.getString("wfdocowner");
		wfdocownertype = RecordSet.getString("wfdocownertype");
		wfdocownerfieldid = RecordSet.getString("wfdocownerfieldid");
	}

  	if(isbill.equals("0")){
  		formid = Util.getIntValue(Util.null2String(request.getParameter("formid")));
  		String tablename = "";
			RecordSet.executeSql("select tablename from workflow_bill where id="+formid);	
			if(RecordSet.next()) tablename = RecordSet.getString("tablename");
			if(tablename.equals("formtable_main_"+formid*(-1))){//新创建的表单做为单据保存
				isbill = "1";
			}
  	}
  	else
  		formid = Util.getIntValue(Util.null2String(request.getParameter("billid")));
    
    //是否允许创建人删除附件
    String candelacc= Util.null2String(request.getParameter("candelacc"));
    
    if(Util.getIntValue(iscust)<Util.getIntValue(oldiscust)){ 
        //清除type＝20～25的操作组
        WFManager.reset();
        WFManager.setWfid(wfid);
        WFManager.clearWFCRM();
    }
    if("3".equals(oldisbill) && formid>0){
        //增加新表单字段信息
        WFManager.reset();
        WFManager.setWfid(wfid);
        WFManager.setFormid(formid);
  	    WFManager.setIsBill(isbill);
        WFManager.addWFFieldInfo();
    }
    if(!"3".equals(oldisbill) && !isbill.equals(oldisbill)){
        //清除附加操作中关联的字段信息、字段显示信息及模板信息、出口条件信息，增加新表单字段信息
        WFManager.reset();
        WFManager.setWfid(wfid);
        WFManager.setIsBill(isbill);
        WFManager.setFormid(formid);
        WFManager.clearWFFormInfo();
    }
    if(!"3".equals(oldisbill) && isbill.equals(oldisbill) && oldformid!=formid){
        //清除附加操作中关联的字段信息、字段显示信息及模板信息、出口条件信息，增加新表单字段信息
        WFManager.reset();
        WFManager.setWfid(wfid);
        WFManager.setIsBill(isbill);
        WFManager.setFormid(formid);
        WFManager.clearWFFormInfo();
    }
    WFManager.reset();
  	WFManager.setAction("editwf");
  	WFManager.setWfid(wfid);
  	WFManager.setWfname(Util.null2String(request.getParameter("wfname")));
  	WFManager.setWfdes(Util.null2String(request.getParameter("wfdes")));
  	WFManager.setTypeid(Util.getIntValue(Util.null2String(request.getParameter("typeid"))));
    WFManager.setOldTypeid(Util.getIntValue(Util.null2String(request.getParameter("oldtypeid"))));
    WFManager.setSubCompanyId2(subCompanyId);

  	WFManager.setFormid(formid);
  	WFManager.setIsBill(isbill);
  	WFManager.setIsCust(iscust);
  	WFManager.setHelpdocid(helpdocid);
    WFManager.setIsValid(isvalid);
    WFManager.setNeedMark(needmark);
    WFManager.setMessageType(messageType);
    WFManager.setMailMessageType(mailMessageType);//added by xwj for td2965 20051101
    WFManager.setForbidAttDownload(forbidAttDownload);
    WFManager.setDocRightByOperator(docRightByOperator);
    WFManager.setMultiSubmit(multiSubmit);
    WFManager.setDefaultName(defaultName);
    WFManager.setDocCategory(maincategory+","+subcategory+","+seccategory);
    WFManager.setDocPath(pathcategory);
    WFManager.setTemplateid(templateid);
    WFManager.setCatelogType(catelogType);
    WFManager.setSelectedCateLog(selectedCateLog);
    WFManager.setDocRightByHrmResource(docRightByHrmResource);
    WFManager.setIsaffirmance(isaffirmance);
	WFManager.setIsremak(isremak);
	WFManager.setIsShowChart(isShowChart);
	WFManager.setOrderbytype(orderbytype);
	WFManager.setIsModifyLog(isModifyLog);
    WFManager.setIsAnnexUpload(isannexUpload);
    WFManager.setAnnexDocCategory(annexmaincategory+","+annexsubcategory+","+annexseccategory);
    WFManager.setIsShowOnReportInput(isShowOnReportInput);
    WFManager.setShowDelButtonByReject(ShowDelButtonByReject);
    WFManager.setNosynfields(nosynfields);
    WFManager.setSAPSource(SAPSource);
    WFManager.setSpecialApproval(specialApproval);
    WFManager.setFrequency(Frequency);
    WFManager.setCycle(Cycle);
    
    WFManager.setIsImportwf(isimportwf);
	WFManager.setWfdocpath(wfdocpath);
	WFManager.setWfdocowner(wfdocowner);
	WFManager.setWfdocownertype(wfdocownertype);
	WFManager.setWfdocownerfieldid(wfdocownerfieldid);
    WFManager.setShowUploadTab(showUploadTab);
    WFManager.setSignDoc(isSignDoc);
    WFManager.setShowDocTab(showDocTab);
    WFManager.setSignWorkflow(isSignWorkflow);
    WFManager.setShowWorkflowTab(showWorkflowTab);
    WFManager.setCanDelAcc(candelacc);
    WFManager.setIsforwardRights(""+isforwardrights);
    WFManager.setIsrejectremind(isrejectremind);
    WFManager.setIschangrejectnode(ischangrejectnode);  
	WFManager.setNewdocpath(newdocpath);
	WFManager.setIssignview(issignview);
	  WFManager.setIsSelectrejectNode(isselectrejectnode);
	  	WFManager.setIsImportDetail(isImportDetail);
	  	WFManager.setIsneeddelacc(isneeddelacc);
    WFManager.setWfInfo();

    //Start 手机接口功能 by alan
    RecordSet.executeSql("DELETE FROM workflow_mgmsworkflows WHERE workflowid="+wfid);
    if(Util.null2String(request.getParameter("isMgms")).equals("1")){
    	RecordSet.executeSql("INSERT INTO workflow_mgmsworkflows(workflowid) VALUES ("+wfid+")");
    }	
    //End 手机接口功能
    
    //add by xhheng @ 2004/12/08 for TDID 1317 start
    //修改工作流日志
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(wfid);
    SysMaintenanceLog.setRelatedName(Util.null2String(request.getParameter("wfname")));
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("WrokFlow_update");
    SysMaintenanceLog.setOperateItem("85");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setIstemplate(Util.getIntValue(isTemplate));
    SysMaintenanceLog.setSysLogInfo();
    //add by xhheng @ 2004/12/08 for TDID 1317 end

    WorkflowComInfo.removeWorkflowCache();
    TestWorkflowComInfo.removeWorkflowCache();
    if(!ajax.equals("1")){
    response.sendRedirect("managewf.jsp");
    }else{
    response.sendRedirect("addwf0.jsp?ajax=1&src=editwf&wfid="+wfid+"&isTemplate="+isTemplate);
    }
    return;

  }
  else if(src.equalsIgnoreCase("bywhat")){

  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	String isbill=Util.null2String(request.getParameter("isbill"));
  	int bywhat=Util.getIntValue(Util.null2String(request.getParameter("bywhat")),0);
  	String[] userids = request.getParameterValues("userids");
  	String tmp = "";
  	if(userids!=null){
  	for(int i=0;i<userids.length;i++){
  		String ismanager = Util.null2String(request.getParameter("ismanager_"+userids[i]));
  		if(ismanager.equals("1"))
  			tmp += ",M"+userids[i];
  		else
  			tmp += ","+userids[i];
  	}
  	}
  	if(bywhat ==0){
  		if(!tmp.equals("")){
  			tmp = tmp.substring(1);
  		}
  		String sql = "update workflow_nodebase set userbyform='0',userids='"+tmp+"' where id="+nodeid;
  		RecordSet.executeSql(sql);
  	}
  	else if(bywhat == 1){
  		String sql = "update workflow_nodebase set userbyform='1' where id = "+nodeid;
  		RecordSet.executeSql(sql);
  	}
  	  response.sendRedirect("Editwfnode.jsp?wfid="+wfid);
  	  return;


  }
  else if(src.equalsIgnoreCase("delgroups")){

  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	String isbill=Util.null2String(request.getParameter("isbill"));
    //add by xhheng @ 2004/12/10 for TDID 1448
    String nodetype=Util.null2String(request.getParameter("nodetype"));
  	String iscust=Util.null2String(request.getParameter("iscust"));
  	String[] deleteids = request.getParameterValues("delete_wf_id");

  	String tmp = "";

	 nodetype="";
	char flag=2;
	RecordSet.executeProc("workflow_NodeType_Select",""+wfid+flag+nodeid);

	if(RecordSet.next())
		nodetype = RecordSet.getString("nodetype");

  	if(deleteids!=null){
	  	for(int i=0;i<deleteids.length;i++){
	  		tmp = deleteids[i];
	  		RecordSet.executeProc("workflow_nodegroup_Delete",tmp);
	  		RecordSet.executeProc("workflow_groupdetail_DbyGroup",tmp);
	  		String sql1 = " update workflow_nodebase set totalgroups=totalgroups-1 where id = "+nodeid;
	  		RecordSet.executeSql(sql1);
        //add by xhheng @ 2004/12/10 for TDID 1448
        //创建节点时，才做创建人表更新
        if(nodetype!=null && nodetype.equals("0")){
		  
         // RequestCheckUser.setWorkflowid(wfid);
         // RequestCheckUser.updateCreateList(Util.getIntValue(tmp));
       
		String hisWorkflowCreater=RequestUserDefaultManager.getWorkflowCreater(String.valueOf(wfid));
		RequestCheckUser.setWorkflowid(wfid);
		RequestCheckUser.setNodeid(nodeid);
	    RequestCheckUser.updateCreateList(Util.getIntValue(tmp));
		RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);
        }
	  	}
  	}

    //add by xhheng @ 2004/12/08 for TDID 1317 start
    //删除节点操作组日志
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(nodeid);
    SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(15545,user.getLanguage()));
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("WrokFlowNodeOperator_delete");
    SysMaintenanceLog.setOperateItem("87");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    //add by xhheng @ 2004/12/08 for TDID 1317 end
	if(design==1)//add by cyril on 2008-12-10
		response.sendRedirect("addnodeoperator.jsp?design="+design+"&wfid="+wfid+"&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust);
	else
  	  	response.sendRedirect("Editwfnode.jsp?ajax=1&wfid="+wfid);
  	  return;
 // response.sendRedirect("addnodeoperator.jsp?wfid="+wfid+"&nodeid="+nodeid+"&isbill="+isbill+"&iscust="+iscust+"&formid="+formid);

  }
  else if(src.equalsIgnoreCase("wfnodeadd")){
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);

  	String delids = Util.null2String(request.getParameter("delids"));
  	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodesnum")));

  	int createnum = 0;

  	String sqltmp = "";

//  	if(!delids.equals("")){
//  		delids = delids.substring(1);
//	  	String del_ids[] =Util.TokenizerString2(delids,",");
//		for(int i=0;i<del_ids.length;i++){
//			int tmpid = Util.getIntValue(del_ids[i]);
//			sqltmp = " select count(nodeid) from workflow_flownode where nodeid="+tmpid+" and nodetype='0'";
//			RecordSet.executeSql(sqltmp);
//  			if(RecordSet.next())
//  				createnum -= RecordSet.getInt(1);
//  		}
//	}
	for(int i=0;i<rowsum;i++) {
		String tmptype = Util.null2String(request.getParameter("node_"+i+"_type"));
		if(tmptype.equals("0")){
			createnum += 1;
		}
	}
	if(createnum != 1){
        if(!ajax.equals("1"))
        response.sendRedirect("addwfnode.jsp?message=1&wfid="+wfid);
        else
        response.sendRedirect("addwfnode.jsp?ajax=1&message=1&wfid="+wfid);
        return;
	}

  	if(!delids.equals("")){
	  	String del_ids[] =Util.TokenizerString2(delids,",");
	  	WFNodeMainManager.resetParameter();
      WFNodeMainManager.deleteWfNode(del_ids);
      //add by xhheng @ 2004/12/08 for TDID 1317 start
      //删除节点日志
      for(int i=0;i<del_ids.length;i++){
        SysMaintenanceLog.resetParameter();
        //记录工作流id
        SysMaintenanceLog.setRelatedId(wfid);
        SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(15070,user.getLanguage()));
        SysMaintenanceLog.setOperateType("3");
        SysMaintenanceLog.setOperateDesc("WrokFlowNode_delete");
        SysMaintenanceLog.setOperateItem("86");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
      }
      //add by xhheng @ 2004/12/08 for TDID 1317 end
	}

    //add by mackjoe at 2005-12-19 表单中是否设置了模板
    int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),0);
    String ismode="0";
    RecordSet.executeSql("select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"'");
    if(RecordSet.next()){
        ismode="1";
    }
    //end by mackjoe

	for(int i=0;i<rowsum;i++) {
		WFNodeMainManager.resetParameter();
		WFNodeMainManager.setWfid(wfid);
		WFNodeMainManager.setFormid(formid);
		String nodename = Util.null2String(request.getParameter("node_"+i+"_name"));
		int nodeid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_id")),0);
		String nodetype = Util.null2String(request.getParameter("node_"+i+"_type"));
        String nodeattribute = Util.null2String(request.getParameter("node_"+i+"_attribute"));
        int nodepassnum = Util.getIntValue(request.getParameter("node_"+i+"_passnum"),0);

/*
		if(ismode.equals("1")){
				RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid=0");
        while(RecordSet.next()){
        	int isbill_workflow_modeview = RecordSet.getInt("isbill");
        	int fieldid = RecordSet.getInt("fieldid");
        	String isview = RecordSet.getString("isview");
        	String isedit = RecordSet.getString("isedit");
        	String ismandatory = RecordSet.getString("ismandatory");
        	rs.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid="+fieldid);
        	if(!rs.next()){
        		rs.executeSql("insert into workflow_modeview values("+formid+","+nodeid+","+isbill_workflow_modeview+","+fieldid+",'"+isview+"','"+isedit+"','"+ismandatory+"')");
        	}
        }
     }
*/     
		WFNodeMainManager.setNodename(nodename);
		WFNodeMainManager.setNodetype(nodetype);
        WFNodeMainManager.setNodeattribute(nodeattribute);
        WFNodeMainManager.setNodepassnum(nodepassnum);
        WFNodeMainManager.setIsbill(isbill);
        //modify by xhheng @ 2004/12/08 for TDID 1317 start
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(wfid);
		SysMaintenanceLog.setRelatedName(nodename);
		SysMaintenanceLog.setOperateItem("86");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());

		if(!nodename.equals("") && !nodetype.equals("") && nodeid !=0){
			//修改节点日志
			SysMaintenanceLog.setOperateType("2");
			SysMaintenanceLog.setOperateDesc("WrokFlowNode_update");
            SysMaintenanceLog.setSysLogInfo();
			WFNodeMainManager.setNodeid(nodeid);
			WFNodeMainManager.updateWfNode();
		}

		if(!nodename.equals("") && !nodetype.equals("") && nodeid ==0){
			//新增节点日志
			SysMaintenanceLog.setOperateType("1");
			SysMaintenanceLog.setOperateDesc("WrokFlowNode_insert");
            SysMaintenanceLog.setSysLogInfo();
			WFNodeMainManager.saveWfNode();
			nodeid=WFNodeMainManager.getNodeid2();
        }

		if(ismode.equals("1")){
			RecordSet.executeSql("select  distinct * from workflow_modeview where formid="+formid+" and nodeid=0 and not exists(select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldId=workflow_modeview.fieldId)");

            while(RecordSet.next()){
        	    int isbill_workflow_modeview = RecordSet.getInt("isbill");
        	    int fieldid = RecordSet.getInt("fieldid");
        	    String isview = RecordSet.getString("isview");
        	    String isedit = RecordSet.getString("isedit");
        	    String ismandatory = RecordSet.getString("ismandatory");

        		rs.executeSql("insert into workflow_modeview(formId,nodeId,isBill,fieldId,isview,isedit,ismandatory)  values("+formid+","+nodeid+","+isbill_workflow_modeview+","+fieldid+",'"+isview+"','"+isedit+"','"+ismandatory+"')");
           }
		}
		//modify by xhheng @ 2004/12/08 for TDID 1317 end
	}
    //add by mackjoe at 2005-12-19 表单中设置有模板，自动引用模板  移到WFNodeMainManager中处理
    //RecordSet.executeSql("update workflow_flownode set ismode='"+ismode+"' where workflowid="+wfid);
    //end by mackjoe
    if(!ajax.equals("1")) {
    	if(design==1) {//added by cyril on 2008-12-10
    		int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
    		response.sendRedirect("addnodeoperator.jsp?design=1&wfid="+wfid+"&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+WFManager.getIsCust());
    	}
    	else	
			response.sendRedirect("Editwfnode.jsp?wfid="+wfid);
    }
    else {
    	response.sendRedirect("Editwfnode.jsp?ajax=1&wfid="+wfid);
    }
    return;

  }
    else if(src.equalsIgnoreCase("addoperatorgroup")){
  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	String isbill=Util.null2String(request.getParameter("isbill"));
  	String iscust=Util.null2String(request.getParameter("iscust"));

	int id = 0;
  	String sql = "select max(id) as id from workflow_nodegroup";
  	RecordSet.executeSql(sql);

  	if(RecordSet.next()){
  		id = Util.getIntValue(Util.null2String(RecordSet.getString("id")),0);
  	}
  	id += 1;

	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
	WFNodeOperatorManager.resetParameter();
	WFNodeOperatorManager.setId(id);
	WFNodeOperatorManager.setNodeid(nodeid);
	String groupname = Util.null2String(request.getParameter("groupname"));
	int canview = Util.getIntValue(request.getParameter("canview"),0);
	WFNodeOperatorManager.setName(groupname);
	WFNodeOperatorManager.setCanview(canview);
	WFNodeOperatorManager.setAction("add");
	WFNodeOperatorManager.AddGroupInfo();
    String para="";  
	for(int i=0;i<rowsum;i++) {

		String type = Util.null2String(request.getParameter("group_"+i+"_type"));
		String groupid = Util.null2String(request.getParameter("group_"+i+"_id"));
		int level = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level")),0);
		int level2 = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level2")),0);
        String conditions=Util.null2String(request.getParameter("group_"+i+"_condition"));
        String orders=Util.null2String(request.getParameter("group_"+i+"_order"));
		String signorder=Util.null2String(request.getParameter("group_"+i+"_signorder"));
        String IsCoadjutant=Util.null2String(request.getParameter("group_"+i+"_IsCoadjutant"));
        String signtype=Util.null2String(request.getParameter("group_"+i+"_signtype"));
		String issyscoadjutant=Util.null2String(request.getParameter("group_"+i+"_issyscoadjutant"));
        String coadjutants=Util.null2String(request.getParameter("group_"+i+"_coadjutants"));
        String issubmitdesc=Util.null2String(request.getParameter("group_"+i+"_issubmitdesc"));
		String ispending=Util.null2String(request.getParameter("group_"+i+"_ispending"));
        String isforward=Util.null2String(request.getParameter("group_"+i+"_isforward"));
        String ismodify=Util.null2String(request.getParameter("group_"+i+"_ismodify"));
		String Coadjutantconditions=Util.null2String(request.getParameter("group_"+i+"_Coadjutantconditions"));
		//td13272
		signorder = "-1".equals(signorder) ? "" : signorder;
        String conditioncn=Util.fromScreen(Util.null2String(request.getParameter("group_"+i+"_conditioncn")),user.getLanguage());
		if (orders.equals("")) orders="0";
		if(!type.equals("")){
			char flag=2;
			para=""+id+flag+type+flag+groupid+flag+level+flag+level2+flag+conditions+flag+conditioncn+flag+orders+flag+signorder+flag+IsCoadjutant+
                    flag+signtype+flag+issyscoadjutant+flag+issubmitdesc+flag+ispending+flag+isforward+flag+ismodify+flag+coadjutants+flag+Coadjutantconditions;
			RecordSet.executeProc("workflow_groupdetail_Insert",para);
		}
	}

	int iscreate = Util.getIntValue(request.getParameter("iscreate"),0);
	if(iscreate==1){
        String hisWorkflowCreater=RequestUserDefaultManager.getWorkflowCreater(String.valueOf(wfid));
		RequestCheckUser.setWorkflowid(wfid);
		RequestCheckUser.setNodeid(nodeid);
	    RequestCheckUser.updateCreateList(id);
		RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);

	}

	//add by xhheng @ 2004/12/08 for TDID 1317 start
	//新增操作人组日志
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(nodeid);
	SysMaintenanceLog.setRelatedName(groupname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("WrokFlowNodeOperator_insert");
	SysMaintenanceLog.setOperateItem("87");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	//add by xhheng @ 2004/12/08 for TDID 1317 end
    if(!ajax.equals("1"))
    response.sendRedirect("addnodeoperator.jsp?design="+design+"&wfid="+wfid+"&isbill="+isbill+"&iscust="+iscust+"&formid="+formid+"&nodeid="+nodeid);
    else{
    response.sendRedirect("Editwfnode.jsp?ajax=1&wfid="+wfid);
    }
    return;

  }
  else if(src.equalsIgnoreCase("editoperatorgroup")){
  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
  	String isbill=Util.null2String(request.getParameter("isbill"));
  	String iscust=Util.null2String(request.getParameter("iscust"));
	String oldids=Util.null2String(request.getParameter("oldids"));

  	char flag1 = 2;
  	//RecordSet.executeProc("workflow_groupdetail_DbyGroup",""+id);

	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
	WFNodeOperatorManager.resetParameter();
	WFNodeOperatorManager.setId(id);
	WFNodeOperatorManager.setNodeid(nodeid);
	String groupname = Util.null2String(request.getParameter("groupname"));
	int canview = Util.getIntValue(request.getParameter("canview"),0);
	WFNodeOperatorManager.setName(groupname);
	WFNodeOperatorManager.setCanview(canview);
    String para="";  
	for(int i=0;i<rowsum;i++) {

		String type = Util.null2String(request.getParameter("group_"+i+"_type"));
		String groupid = Util.null2String(request.getParameter("group_"+i+"_id"));
		
		int level = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level")),0);
		int level2 = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level2")),0);
        String conditions=Util.null2String(request.getParameter("group_"+i+"_condition"));
		String signorder=Util.null2String(request.getParameter("group_"+i+"_signorder"));
		//td13272
		signorder = "-1".equals(signorder) ? "" : signorder;
        String orders=Util.null2String(request.getParameter("group_"+i+"_order"));
        String conditioncn=Util.fromScreen(Util.null2String(request.getParameter("group_"+i+"_conditioncn")),user.getLanguage());
		String oldid=Util.null2String(request.getParameter("group_"+i+"_oldid"));
        String IsCoadjutant=Util.null2String(request.getParameter("group_"+i+"_IsCoadjutant"));
        String signtype=Util.null2String(request.getParameter("group_"+i+"_signtype"));
		String issyscoadjutant=Util.null2String(request.getParameter("group_"+i+"_issyscoadjutant"));
        String coadjutants=Util.null2String(request.getParameter("group_"+i+"_coadjutants"));
        String issubmitdesc=Util.null2String(request.getParameter("group_"+i+"_issubmitdesc"));
		String ispending=Util.null2String(request.getParameter("group_"+i+"_ispending"));
        String isforward=Util.null2String(request.getParameter("group_"+i+"_isforward"));
        String ismodify=Util.null2String(request.getParameter("group_"+i+"_ismodify"));
		String Coadjutantconditions=Util.null2String(request.getParameter("group_"+i+"_Coadjutantconditions"));
		if (orders.equals("")) orders="0";
		if(!type.equals("")){
			char flag=2;
			
		    if (oldid.equals("")){
                para=""+id+flag+type+flag+groupid+flag+level+flag+level2+flag+conditions+flag+conditioncn+flag+orders+flag+signorder+flag+IsCoadjutant+
                    flag+signtype+flag+issyscoadjutant+flag+issubmitdesc+flag+ispending+flag+isforward+flag+ismodify+flag+coadjutants+flag+Coadjutantconditions;
                RecordSet.executeProc("workflow_groupdetail_Insert",para);
            }
			else
			{
			RecordSet.execute("update workflow_groupdetail set  type="+type+", objid="+groupid+", level_n="+level+", level2_n="+level2+", conditions='"+conditions+"', conditioncn='"+conditioncn+"', orders='"+orders+"', signorder='"+signorder+
                    "',IsCoadjutant='"+IsCoadjutant+"',signtype='"+signtype+"'," +
                    "issyscoadjutant='"+issyscoadjutant+"',issubmitdesc='"+issubmitdesc+"',ispending='"+ispending+"',isforward='"+isforward+"',ismodify='"+ismodify+"'," +
                    "coadjutants='"+coadjutants+"',coadjutantcn='"+Coadjutantconditions+"' where id="+oldid);
			oldids=Util.StringReplace(oldids,","+oldid+",",",-1,");
			//System.out.print("oldids**********"+oldids);
			//更新

			}
		}

	}
	    //删除
	if (!oldids.equals(",")&&!oldids.equals(""))
	{
	oldids="-1"+oldids+"-1";
    RecordSet.execute("delete from workflow_groupdetail where id in ("+oldids+") ");
	}
		WFNodeOperatorManager.setAction("edit");
		WFNodeOperatorManager.AddGroupInfo();

	int iscreate = Util.getIntValue(request.getParameter("iscreate"),0);
	if(iscreate==1){
        String hisWorkflowCreater=RequestUserDefaultManager.getWorkflowCreater(String.valueOf(wfid));
		RequestCheckUser.setWorkflowid(wfid);
		RequestCheckUser.setNodeid(nodeid);
	    RequestCheckUser.updateCreateList(id);
		RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);
	}

	//add by xhheng @ 2004/12/08 for TDID 1317 start
	//编辑操作人组日志
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(nodeid);
	SysMaintenanceLog.setRelatedName(groupname);
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("WrokFlowNodeOperator_update");
	SysMaintenanceLog.setOperateItem("87");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	//add by xhheng @ 2004/12/08 for TDID 1317 end
    if(!ajax.equals("1")) {
    	response.sendRedirect("addnodeoperator.jsp?design="+design+"&wfid="+wfid+"&isbill="+isbill+"&iscust="+iscust+"&formid="+formid+"&nodeid="+nodeid);
    }
    else
    	response.sendRedirect("Editwfnode.jsp?ajax=1&wfid="+wfid);
    return;

  }else if(src.equalsIgnoreCase("nodefieldhtml")){
		wFNodeFieldManager.setRequest(request);
  		wFNodeFieldManager.setUser(user);
  		int modeid = wFNodeFieldManager.setNodeFieldInfo4Html();
  		int wfid = Util.getIntValue(request.getParameter("wfid"), 0);//
  		int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);//
  		int formid = Util.getIntValue(request.getParameter("formid"), 0);//
  		int isbill = Util.getIntValue(request.getParameter("isbill"), 0);//
  		int needprep = Util.getIntValue(request.getParameter("needprep"), 0);//
		int design_tmp = Util.getIntValue(request.getParameter("design"), 0);//
  		if(needprep == 0){
	  		response.sendRedirect("/workflow/workflow/addwfnodefield.jsp?ajax=1&wfid="+wfid+"&nodeid="+nodeid);
			return;
  		}else if(needprep == 1){
  			response.sendRedirect("/workflow/workflow/edithtmlnodefield.jsp?needprep=1&wfid="+wfid+"&nodeid="+nodeid+"&ajax="+ajax+"&modeid="+modeid);
			return;
  		}else if(needprep == 2){//预览以后再批量设置后，关闭设置页面，并且刷新原来页面
  			if(design_tmp == 1){
  				response.sendRedirect("/workflow/workflow/addwfnodefield.jsp?ajax="+ajax+"&wfid="+wfid+"&nodeid="+nodeid+"&design="+design);
  				return;
  			}else{
	  			out.println("<script>try{window.opener.location.href=\"/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid="+wfid+"&nodeid="+nodeid+"&isbill="+isbill+"&layouttype=0&ajax=0&modeid="+modeid+"\";}catch(e){}");
	  			out.println("window.close();");
	  			out.println("</script>");
  			}
  		}
  		return;
  }
  else if(src.equalsIgnoreCase("wfnodefield")){
  	//System.out.println("wfnodefield");
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	String isbill = Util.null2String(request.getParameter("isbill"));
    String modetype=Util.null2String(request.getParameter("modetype"));
    if(modetype.equals("0")){
        /*--xwj for td1834 on 005-05-18 begin--*/

        String curedit_ = Util.null2String(request.getParameter("title_edit"));
  		 	String curview_ = Util.null2String(request.getParameter("title_view"));
  		 	String curman_ = Util.null2String(request.getParameter("title_man"));
  		 	WFNodeFieldMainManager.resetParameter();
  		 	WFNodeFieldMainManager.setNodeid(nodeid);
  			WFNodeFieldMainManager.setFieldid(-1);
  			WFNodeFieldMainManager.setIsview("0");
  		 	WFNodeFieldMainManager.setIsedit("0");
  		 	WFNodeFieldMainManager.setIsmandatory("0");
  		 	if(curview_.equals("on"))
  		 		WFNodeFieldMainManager.setIsview("1");
  		 	if(curedit_.equals("on"))
  		 		WFNodeFieldMainManager.setIsedit("1");
  		 	if(curman_.equals("on"))
  		 		WFNodeFieldMainManager.setIsmandatory("1");
  			WFNodeFieldMainManager.saveWfNodeField2();

  			//保存紧急程度和是否短信提醒字段 开始 MYQ修改
        String curview1 = Util.null2String(request.getParameter("level_view"));
  		 	String curedit1 = Util.null2String(request.getParameter("level_edit"));
  		 	String curman1 = Util.null2String(request.getParameter("level_man"));
  		 	WFNodeFieldMainManager.resetParameter();
  		 	WFNodeFieldMainManager.setNodeid(nodeid);
  			WFNodeFieldMainManager.setFieldid(-2);
  			WFNodeFieldMainManager.setIsview("0");
  		 	WFNodeFieldMainManager.setIsedit("0");
  		 	WFNodeFieldMainManager.setIsmandatory("0");
  		 	if(curview1.equals("on"))
  		 		WFNodeFieldMainManager.setIsview("1");
  		 	if(curedit1.equals("on")){
  		 		WFNodeFieldMainManager.setIsview("1");
  		 		WFNodeFieldMainManager.setIsedit("1");
  		 	}
  			WFNodeFieldMainManager.saveWfNodeField2();
  			
        String curview2 = Util.null2String(request.getParameter("ismessage_view"));
  		 	String curedit2 = Util.null2String(request.getParameter("ismessage_edit"));
  		 	String curman2 = Util.null2String(request.getParameter("ismessage_man"));
  		 	WFNodeFieldMainManager.resetParameter();
  		 	WFNodeFieldMainManager.setNodeid(nodeid);
  			WFNodeFieldMainManager.setFieldid(-3);
  			WFNodeFieldMainManager.setIsview("0");
  		 	WFNodeFieldMainManager.setIsedit("0");
  		 	WFNodeFieldMainManager.setIsmandatory("0");
  		 	if(curview2.equals("on"))
  		 		WFNodeFieldMainManager.setIsview("1");
  		 	if(curedit2.equals("on")){
  		 		WFNodeFieldMainManager.setIsview("1");
  		 		WFNodeFieldMainManager.setIsedit("1");
  		 	}
  		 	if(curman2.equals("on")){
  		 		WFNodeFieldMainManager.setIsview("1");
  		 		WFNodeFieldMainManager.setIsedit("1");
  		 		WFNodeFieldMainManager.setIsmandatory("1");
  		 	}
  			WFNodeFieldMainManager.saveWfNodeField2();
  			//保存紧急程度和是否短信提醒字段  结束 MYQ修改
  			
     /*--xwj for td1834 on 005-05-18 begin--*/

     if(isbill.equals("0")){
  	  	FormFieldMainManager.setFormid(formid);
  		FormFieldMainManager.selectAllFormField();
          int groupid=-1;
  		while(FormFieldMainManager.next()){
  			int curid=FormFieldMainManager.getFieldid();
              int curgroupid=FormFieldMainManager.getGroupid();
              if(curgroupid==-1) curgroupid=999;
              String isdetail = FormFieldMainManager.getIsdetail();
  			WFNodeFieldMainManager.resetParameter();
  			WFNodeFieldMainManager.setNodeid(nodeid);
  			WFNodeFieldMainManager.setFieldid(curid);
  		 	String curedit = Util.null2String(request.getParameter("node"+curid+"_edit_g"+curgroupid));
  		 	String curview = Util.null2String(request.getParameter("node"+curid+"_view_g"+curgroupid));
  		 	String curman = Util.null2String(request.getParameter("node"+curid+"_man_g"+curgroupid));

  		 	WFNodeFieldMainManager.setIsview("0");
  		 	WFNodeFieldMainManager.setIsedit("0");
  		 	WFNodeFieldMainManager.setIsmandatory("0");
  		 	if(curview.equals("on"))
  		 		WFNodeFieldMainManager.setIsview("1");
  		 	if(curedit.equals("on"))
  		 		WFNodeFieldMainManager.setIsedit("1");
  		 	if(curman.equals("on"))
  		 		WFNodeFieldMainManager.setIsmandatory("1");
  			WFNodeFieldMainManager.saveWfNodeField2();

              if(isdetail.equals("1") && curgroupid>groupid) {
                  groupid=curgroupid;
                  String dtladd = Util.null2String(request.getParameter("dtl_add_"+curgroupid));
                  String dtledit = Util.null2String(request.getParameter("dtl_edit_"+curgroupid));
                  String dtldelete = Util.null2String(request.getParameter("dtl_del_"+curgroupid));
                  String dtlhide = Util.null2String(request.getParameter("hide_del_"+curgroupid));
                  String dtldefault = Util.null2String(request.getParameter("dtl_def_"+curgroupid));
                  String dtlneed = Util.null2String(request.getParameter("dtl_ned_"+curgroupid));

                  WFNodeDtlFieldManager.setNodeid(nodeid);
                  WFNodeDtlFieldManager.setGroupid(curgroupid);
                  WFNodeDtlFieldManager.setIsadd("0");
                  WFNodeDtlFieldManager.setIsedit("0");
                  WFNodeDtlFieldManager.setIsdelete("0");
                  WFNodeDtlFieldManager.setIshide("0");
                  WFNodeDtlFieldManager.setIsdefault("0");
                  WFNodeDtlFieldManager.setIsneed("0");
                  if(dtladd.equals("on"))
                      WFNodeDtlFieldManager.setIsadd("1");
                  if(dtledit.equals("on"))
                      WFNodeDtlFieldManager.setIsedit("1");
                  if(dtldelete.equals("on"))
                      WFNodeDtlFieldManager.setIsdelete("1");
                  if(dtlhide.equals("on"))
                      WFNodeDtlFieldManager.setIshide("1");
                  if(dtldefault.equals("on"))
                      WFNodeDtlFieldManager.setIsdefault("1");
                  if(dtlneed.equals("on"))
                      WFNodeDtlFieldManager.setIsneed("1");
                  WFNodeDtlFieldManager.saveWfNodeDtlField();
              }
  		}
  	}else if(isbill.equals("1")){
  		boolean isNewForm = false;//是否是新表单 modify by myq for TD8730 on 2008.9.12
  		RecordSet.executeSql("select tablename from workflow_bill where id = "+formid);
  		if(RecordSet.next()){
  			String temptablename = Util.null2String(RecordSet.getString("tablename"));
  			if(temptablename.equals("formtable_main_"+formid*(-1))) isNewForm = true;
  		}
  		String sql = "select * from workflow_billfield where billid = "+formid+"  order by viewtype,detailtable,dsporder";
  		if(isNewForm == true){
  			if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
  				sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,TO_NUMBER(substr(detailtable, "+(("formtable_main_"+formid*(-1)+"_dt").length()+1)+",30)),dsporder ";
  			}else{
  				sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,convert(int, substring(detailtable, "+(("formtable_main_"+formid*(-1)+"_dt").length()+1)+",30)),dsporder ";
  			}
  		}else{
  			sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,detailtable,dsporder ";
  		}
  		RecordSet.executeSql(sql);
         int curgroupid=0;
         String predetailtable=null;
          while(RecordSet.next()){
  			int curid=RecordSet.getInt("id");
              int viewtype=RecordSet.getInt("viewtype");
              String detailtable = Util.null2String(RecordSet.getString("detailtable"));
              WFNodeFieldMainManager.resetParameter();
  			WFNodeFieldMainManager.setNodeid(nodeid);
  			WFNodeFieldMainManager.setFieldid(curid);
              if(viewtype==1 && !detailtable.equals(predetailtable)){
                  predetailtable=detailtable;
                  curgroupid++;
              }
              String curedit = Util.null2String(request.getParameter("node"+curid+"_edit_g"+curgroupid));
  		 	String curview = Util.null2String(request.getParameter("node"+curid+"_view_g"+curgroupid));
  		 	String curman = Util.null2String(request.getParameter("node"+curid+"_man_g"+curgroupid));

  		 	WFNodeFieldMainManager.setIsview("0");
  		 	WFNodeFieldMainManager.setIsedit("0");
  		 	WFNodeFieldMainManager.setIsmandatory("0");
  		 	if(curview.equals("on"))
  		 		WFNodeFieldMainManager.setIsview("1");
  		 	if(curedit.equals("on"))
  		 		WFNodeFieldMainManager.setIsedit("1");
  		 	if(curman.equals("on"))
  		 		WFNodeFieldMainManager.setIsmandatory("1");

  			WFNodeFieldMainManager.saveWfNodeField2();
  		}        
          for(int i=0;i<curgroupid;i++){
              String dtladd = Util.null2String(request.getParameter("dtl_add_"+(i+1)));
                  String dtledit = Util.null2String(request.getParameter("dtl_edit_"+(i+1)));
                  String dtldelete = Util.null2String(request.getParameter("dtl_del_"+(i+1)));
                  String dtlhide = Util.null2String(request.getParameter("hide_del_"+(i+1)));
                  String dtldefault = Util.null2String(request.getParameter("dtl_def_"+(i+1)));
                  String dtlneed = Util.null2String(request.getParameter("dtl_ned_"+(i+1)));

                  WFNodeDtlFieldManager.setNodeid(nodeid);
                  WFNodeDtlFieldManager.setGroupid(i);
                  WFNodeDtlFieldManager.setIsadd("0");
                  WFNodeDtlFieldManager.setIsedit("0");
                  WFNodeDtlFieldManager.setIsdelete("0");
                  WFNodeDtlFieldManager.setIshide("0");
                  WFNodeDtlFieldManager.setIsdefault("0");
                  WFNodeDtlFieldManager.setIsneed("0");
                  if(dtladd.equals("on"))
                      WFNodeDtlFieldManager.setIsadd("1");
                  if(dtledit.equals("on"))
                      WFNodeDtlFieldManager.setIsedit("1");
                  if(dtldelete.equals("on"))
                      WFNodeDtlFieldManager.setIsdelete("1");
                  if(dtlhide.equals("on"))
                      WFNodeDtlFieldManager.setIshide("1");
                  if(dtldefault.equals("on"))
                      WFNodeDtlFieldManager.setIsdefault("1");
                  if(dtlneed.equals("on"))
                      WFNodeDtlFieldManager.setIsneed("1");
                  WFNodeDtlFieldManager.saveWfNodeDtlField();
          }
      }
  		//add by mackjoe at 2005-12-19 保存显示类型
    }else if(modetype.equals("1")){
        int showmodeid=Util.getIntValue(Util.null2String(request.getParameter("showmodeid")),0);
        int printmodeid=Util.getIntValue(Util.null2String(request.getParameter("printmodeid")),0);
        int showisform=Util.getIntValue(Util.null2String(request.getParameter("showisform")),0);
        int printisform=Util.getIntValue(Util.null2String(request.getParameter("printisform")),0);
        String showmodename=Util.null2String(request.getParameter("showmodename"));
        String printmodename=Util.null2String(request.getParameter("printmodename"));
        int viewtypeall=Util.getIntValue(Util.null2String(request.getParameter("viewtype_all")),0);
        int viewdescall=Util.getIntValue(Util.null2String(request.getParameter("viewdesc_all")),0);
        int showtype=Util.getIntValue(Util.null2String(request.getParameter("showtype")),0);
        int vtapprove=Util.getIntValue(Util.null2String(request.getParameter("viewtype_approve")),0);
        int vtrealize=Util.getIntValue(Util.null2String(request.getParameter("viewtype_realize")),0);
        int vtforward=Util.getIntValue(Util.null2String(request.getParameter("viewtype_forward")),0);
        int vtpostil=Util.getIntValue(Util.null2String(request.getParameter("viewtype_postil")),0);
        int vtrecipient=Util.getIntValue(Util.null2String(request.getParameter("viewtype_recipient")),0);
        int vtreject=Util.getIntValue(Util.null2String(request.getParameter("viewtype_reject")),0);
        int vtsuperintend=Util.getIntValue(Util.null2String(request.getParameter("viewtype_superintend")),0);
        int vtover=Util.getIntValue(Util.null2String(request.getParameter("viewtype_over")),0);
        int vtintervenor=Util.getIntValue(Util.null2String(request.getParameter("viewtype_intervenor")),0);
        int vdcomments=Util.getIntValue(Util.null2String(request.getParameter("viewdesc_comments")),0);
        int vddeptname=Util.getIntValue(Util.null2String(request.getParameter("viewdesc_deptname")),0);
        int vdoperator=Util.getIntValue(Util.null2String(request.getParameter("viewdesc_operator")),0);
        int vddate=Util.getIntValue(Util.null2String(request.getParameter("viewdesc_date")),0);
        int vdtime=Util.getIntValue(Util.null2String(request.getParameter("viewdesc_time")),0);
        int stnull=Util.getIntValue(Util.null2String(request.getParameter("showtype_null")),0);
        int vsignupload=Util.getIntValue(Util.null2String(request.getParameter("viewdesc_signupload")),0);
        int vsigndoc=Util.getIntValue(Util.null2String(request.getParameter("viewdesc_signdoc")),0);
        int vsignworkflow=Util.getIntValue(Util.null2String(request.getParameter("viewdesc_signworkflow")),0);
        int toexcel=Util.getIntValue(Util.null2String(request.getParameter("toexcel")),0);
        ConnStatement statement=new ConnStatement();
        try {
        boolean isoracle = (statement.getDBType()).equals("oracle");
        String sqlstr="";
        String modestr="";
        int modeids=showmodeid;
        String modename=showmodename;
        String modetable="workflow_nodemode";
        String updatestr="";
        //RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
            for(int i=0;i<2;i++){
                if(i==0){
                    modeids=showmodeid;
                    modename=showmodename;
                    updatestr="showdes";
                    modetable="workflow_nodemode";
                    if(showisform==1){
                        modetable="workflow_formmode";
                    }
                }else{
                    modeids=printmodeid;
                    modename=printmodename;
                    updatestr="printdes";
                    modetable="workflow_nodemode";
                    if(printisform==1){
                        modetable="workflow_formmode";
                    }
                }
                RecordSet.executeSql("select id from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid+" and isprint='"+i+"'");
                //已经有模板
                if(RecordSet.next()){
                    int modeid=RecordSet.getInt("id");
                    //更新模板
                    if(modeids>0){
                        if(modetable.equals("workflow_nodemode")){
                            if(i==0){
                                sqlstr="select formid,nodeid from "+modetable+" where id="+modeids;
                                RecordSet.executeSql(sqlstr);
                                if(RecordSet.next()){
                                    int tempformid=RecordSet.getInt("formid");
                                    int tempnodeid=RecordSet.getInt("nodeid");
                                    if(formid!=tempformid || tempnodeid!=nodeid){
                                        RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
                                        RecordSet.executeSql("select fieldid,isview,isedit,ismandatory from workflow_modeview where formid="+tempformid+" and nodeid="+tempnodeid+" and isbill="+isbill);
                                        while(RecordSet.next()){
                                            rs.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+RecordSet.getInt("fieldid")+",'"+RecordSet.getString("isview")+"','"+RecordSet.getString("isedit")+"','"+RecordSet.getString("ismandatory")+"')");
                                        }
                                    }
                                }
                            }
                            sqlstr="select modedesc from "+modetable+" where id="+modeids;
                            statement.setStatementSql(sqlstr);
                            statement.executeQuery();
                            if (statement.next()) {
                                if(isoracle){
                                    CLOB theclob = statement.getClob(1);
                                    String readline = "" ;
                                    StringBuffer clobStrBuff = new StringBuffer("") ;
                                    BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
                                    while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
                                    clobin.close() ;
                                    modestr=clobStrBuff.toString();
                                }else{
                                modestr = statement.getString("modedesc");
                                }
                            }
                            if(isoracle){
                                sqlstr="update workflow_nodemode set modename=? where id="+modeid;
                                statement.setStatementSql(sqlstr);
                                statement.setString(1 , modename);
                                statement.executeUpdate();

                                sqlstr = "select modedesc from workflow_nodemode where id = "+modeid;
                                statement.setStatementSql(sqlstr, false);
                                statement.executeQuery();
                                if(statement.next()){
                                    CLOB theclob = statement.getClob(1);
                                    char[] contentchar = modestr.toCharArray();
                                    Writer contentwrite = theclob.getCharacterOutputStream();
                                    contentwrite.write(contentchar);
                                    contentwrite.flush();
                                    contentwrite.close();
                                    //statement.close();
                                }
                            }else{
                                sqlstr="update workflow_nodemode set modedesc=?,modename=? where id="+modeid;
                                statement.setStatementSql(sqlstr);
                                statement.setString(1 , modestr);
                                statement.setString(2 , modename);
                                statement.executeUpdate();
                            }
                        }else{
                            if(i==0){
                                RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
                                RecordSet.executeSql("select fieldid,isview,isedit,ismandatory from workflow_modeview where formid="+formid+" and nodeid=0 and isbill="+isbill);
                                while(RecordSet.next()){
                                   rs.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+RecordSet.getInt("fieldid")+",'"+RecordSet.getString("isview")+"','"+RecordSet.getString("isedit")+"','"+RecordSet.getString("ismandatory")+"')");
                                }
                            }
                            RecordSet.executeSql("delete from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid+" and isprint='"+i+"'");
                        }
                    }else{
                        //删除模板
                        //RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
                        RecordSet.executeSql("delete from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid+" and isprint='"+i+"'");
						//(TD23195)是否还有其他模板使用
                        RecordSet.executeSql("select id from workflow_nodemode where formid="+formid+" and nodeid="+nodeid+" and isprint!='"+i+"'");
                        if(RecordSet.getCounts() <= 0) {
                        	RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
                        }
                        RecordSet.executeSql("update workflow_flownode set "+updatestr+"='1' where workflowid="+wfid+" and nodeid="+nodeid);
                    }
                }else{
                    //没有模板
                    //插入模板
                    if(i==0) RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
                    if(modeids>0){
                        if(modetable.equals("workflow_nodemode")){
                            if(i==0){
                                sqlstr="select formid,nodeid from "+modetable+" where id="+modeids;
                                RecordSet.executeSql(sqlstr);
                                if(RecordSet.next()){
                                    int tempformid=RecordSet.getInt("formid");
                                    int tempnodeid=RecordSet.getInt("nodeid");
                                    RecordSet.executeSql("select fieldid,isview,isedit,ismandatory from workflow_modeview where formid="+tempformid+" and nodeid="+tempnodeid+" and isbill="+isbill);
                                    while(RecordSet.next()){
                                        rs.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+RecordSet.getInt("fieldid")+",'"+RecordSet.getString("isview")+"','"+RecordSet.getString("isedit")+"','"+RecordSet.getString("ismandatory")+"')");
                                    }
                                }
                            }
                            sqlstr="select modedesc from "+modetable+" where id="+modeids;
                            statement.setStatementSql(sqlstr);
                            statement.executeQuery();
                            if (statement.next()) {
                                if(isoracle){
                                    CLOB theclob = statement.getClob(1);
                                    String readline = "" ;
                                    StringBuffer clobStrBuff = new StringBuffer("") ;
                                    BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
                                    while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
                                    clobin.close() ;
                                    modestr=clobStrBuff.toString();
                                }else{
                                    modestr = statement.getString("modedesc");
                                }
                            }
                            if(isoracle){
                                sqlstr="insert into workflow_nodemode(formid,nodeid,isprint,modedesc,workflowid,modename) values(?,?,?,empty_clob(),?,?)";
                                statement.setStatementSql(sqlstr);
                                statement.setInt(1 ,formid);
                                statement.setInt(2 ,nodeid);
                                statement.setString(3 ,""+i);
                                statement.setInt(4 ,wfid);
                                statement.setString(5 ,modename);
                                statement.executeUpdate();

                                sqlstr = "select modedesc from workflow_nodemode where formid = "+formid+" and nodeid="+nodeid+" and isprint='"+i+"' and workflowid="+wfid+" order by id desc";
                                statement.setStatementSql(sqlstr, false);
                                statement.executeQuery();
                                if(statement.next()){
                                    CLOB theclob = statement.getClob(1);
                                    char[] contentchar = modestr.toCharArray();
                                    Writer contentwrite = theclob.getCharacterOutputStream();
                                    contentwrite.write(contentchar);
                                    contentwrite.flush();
                                    contentwrite.close();
                                    //statement.close();
                                }
                            }else{
                                sqlstr="insert into workflow_nodemode(formid,nodeid,isprint,modedesc,workflowid,modename) values(?,?,?,?,?,?)";
                                statement.setStatementSql(sqlstr);
                                statement.setInt(1 ,formid);
                                statement.setInt(2 ,nodeid);
                                statement.setString(3 ,""+i);
                                statement.setString(4 , modestr);
                                statement.setInt(5 ,wfid);
                                statement.setString(6 ,modename);
                                statement.executeUpdate();
                            }
                        }else{
                            if(i==0){
                                RecordSet.executeSql("select fieldid,isview,isedit,ismandatory from workflow_modeview where formid="+formid+" and nodeid=0 and isbill="+isbill);
                                while(RecordSet.next()){
                                   rs.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+RecordSet.getInt("fieldid")+",'"+RecordSet.getString("isview")+"','"+RecordSet.getString("isedit")+"','"+RecordSet.getString("ismandatory")+"')");
                                }
                            }
                        }
                        RecordSet.executeSql("update workflow_flownode set "+updatestr+"='0' where workflowid="+wfid+" and nodeid="+nodeid);
                    }else{
                        RecordSet.executeSql("update workflow_flownode set "+updatestr+"='1' where workflowid="+wfid+" and nodeid="+nodeid);
                    }
                }
            }
            RecordSet.executeSql("update workflow_flownode set viewtypeall='"+viewtypeall+"',viewdescall='"+viewdescall+"',showtype='"+showtype+"',vtapprove='"+vtapprove+"',vtforward='"+vtforward+
                    "',vtover='"+vtover+"',vtintervenor='"+vtintervenor+"',vtpostil='"+vtpostil+"',vtrealize='"+vtrealize+"',vtrecipient='"+vtrecipient+"',vtreject='"+vtreject+"',vtsuperintend='"+vtsuperintend+
                    "',vdcomments='"+vdcomments+"',vddate='"+vddate+"',vddeptname='"+vddeptname+"',vdoperator='"+vdoperator+"',vdtime='"+vdtime+"',stnull='"+stnull+"',toexcel='"+toexcel+
                    "',vsignupload='"+vsignupload+"',vsigndoc='"+vsigndoc+"',vsignworkflow='"+vsignworkflow+"' where workflowid="+wfid+" and nodeid="+nodeid);
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            statement.close();
        }
    }else if(modetype.equals("2")){//Html编辑模式
    	wFNodeFieldManager.setRequest(request);
    	wFNodeFieldManager.setUser(user);
    	wFNodeFieldManager.setNodeLayout();
		String syncNodes = Util.null2String(request.getParameter("syncNodes"));
    	List syncNodeList = Util.TokenizerString(syncNodes,",");
    	for(int i=0;i<syncNodeList.size();i++){
    		wFNodeFieldManager.setNodeLayout(Util.getIntValue((String)syncNodeList.get(i)), 0);
    	}
    	String printsyncNodes = Util.null2String(request.getParameter("printsyncNodes"));
    	List printsyncNodeList = Util.TokenizerString(printsyncNodes, ",");
    	for(int i=0;i<printsyncNodeList.size();i++){
    		wFNodeFieldManager.setNodeLayout(Util.getIntValue((String)printsyncNodeList.get(i)), 1);
    	}
    }
    RecordSet.executeSql("update workflow_flownode set ismode='"+modetype+"' where workflowid="+wfid+" and nodeid="+nodeid);
    //end by mackjoe at 2005-12-19
    if(!ajax.equals("1")) {
    	response.sendRedirect("addwfnodefield.jsp?design="+design+"&wfid="+wfid+"&nodeid="+nodeid);
    }
    else {
    	response.sendRedirect("Editwfnode.jsp?ajax=1&wfid="+wfid);
    }
    return;

  }
   else if(src.equalsIgnoreCase("wfnodeportal")){
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);

  	String delids = Util.null2String(request.getParameter("delids"));

  	if(!delids.equals("")){
  		delids = delids.substring(1);
	  	String del_ids[] =Util.TokenizerString2(delids,",");
	  	for(int i=0;i<del_ids.length;i++){
	  		WFNodePortalMainManager.resetParameter();
        WFNodePortalMainManager.setId(Util.getIntValue(del_ids[i],0));
        WFNodePortalMainManager.deleteWfNodePortal();
        //add by xhheng @ 2004/12/08 for TDID 1317 start
        //删除出口日志
        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(wfid);
        SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(15611,user.getLanguage()));
        SysMaintenanceLog.setOperateType("3");
        SysMaintenanceLog.setOperateDesc("WrokFlowNodePortal_delete");
        SysMaintenanceLog.setOperateItem("88");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
        //add by xhheng @ 2004/12/08 for TDID 1317 end
 	 	  }
	  }

  	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodessum")));
	for(int i=0;i<rowsum;i++) {
  		WFNodePortalMainManager.resetParameter();
  		WFNodePortalMainManager.setWfid(wfid);

  		int id = Util.getIntValue(Util.null2String(request.getParameter("por"+i+"_id")),0);

      WFNodePortalMainManager.setNodeid(Util.getIntValue(Util.null2String(request.getParameter("por"+i+"_nodeid")),0));
      WFNodePortalMainManager.setIsreject(Util.null2String(request.getParameter("por"+i+"_rej")));

      WFNodePortalMainManager.setLinkname(Util.null2String(request.getParameter("por"+i+"_link")));
      WFNodePortalMainManager.setCondition(Util.null2String(request.getParameter("por"+i+"_con")));
      //add by xhheng @20050205 for TD 1537
      WFNodePortalMainManager.setConditioncn(Util.null2String(request.getParameter("por"+i+"_con_cn")));
      WFNodePortalMainManager.setDestnodeid(Util.getIntValue(request.getParameter("por"+i+"_des")));
      WFNodePortalMainManager.setPasstime(Util.getFloatValue((String)request.getSession(true).getAttribute("por"+i+"_passtime"),-1));
      WFNodePortalMainManager.setIsBulidCode(Util.null2String(request.getParameter("por"+i+"_isBulidCode")));
      WFNodePortalMainManager.setIsMustPass(Util.null2String(request.getParameter("por"+i+"_ismustpass")));
      WFNodePortalMainManager.setTipsinfo(Util.null2String(request.getParameter("por"+i+"_tipsinfo")));    
      //modify by xhheng @ 2004/12/08 for TDID 1317 start
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(wfid);
      SysMaintenanceLog.setRelatedName(Util.null2String(request.getParameter("por"+i+"_link")));
      SysMaintenanceLog.setOperateItem("88");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      if(Util.getIntValue(request.getParameter("por"+i+"_des"))!=-1 && id ==0){
        WFNodePortalMainManager.saveWfNodePortal();
        //新增出口日志
        SysMaintenanceLog.setOperateType("1");
        SysMaintenanceLog.setOperateDesc("WrokFlowNodePortal_insert");
        SysMaintenanceLog.setSysLogInfo();
      }
      if(Util.getIntValue(request.getParameter("por"+i+"_des"))!=-1 && id !=0){
        WFNodePortalMainManager.setId(id);
        WFNodePortalMainManager.updateWfNodePortal();
        //修改出口日志
        SysMaintenanceLog.setOperateType("2");
        SysMaintenanceLog.setOperateDesc("WrokFlowNodePortal_update");
        SysMaintenanceLog.setSysLogInfo();
      }
      //modify by xhheng @ 2004/12/08 for TDID 1317 end
	}
      if(!ajax.equals("1"))
    response.sendRedirect("addwf.jsp?src=editwf&wfid="+wfid);
      else
   response.sendRedirect("addwfnodeportal.jsp?ajax=1&wfid="+wfid);   
    return;

  }
 /* else if(src.equalsIgnoreCase("formfieldlabel")){
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	ArrayList fields = new ArrayList();
  	ArrayList idarray = new ArrayList();

	FormFieldlabelMainManager.resetParameter();
	FormFieldlabelMainManager.setFormid(formid);
	FormFieldlabelMainManager.deleteFormfield();
	String ids=Util.null2String(request.getParameter("formfieldlabels"));
	int defaultlang=Util.getIntValue(Util.null2String(request.getParameter("isdefault")));
	idarray = Util.TokenizerString(ids,",");

	FormFieldMainManager.setFormid(formid);
	FormFieldMainManager.selectFormField();
	while(FormFieldMainManager.next()){
		int curid=FormFieldMainManager.getFieldid();
		fields.add(""+curid);
	}
	for(int i=0;i<idarray.size();i++) {
		int languageid = Util.getIntValue((String)idarray.get(i),0);
		String isdef = "0";
		if( languageid < 1)
			break;
		if(languageid == defaultlang)
			isdef = "1";
		for(int j=0; j< fields.size();j++) {
			String tfieldid=(String)fields.get(j);
			int fieldid = Util.getIntValue(tfieldid,0);
			FormFieldlabelMainManager.resetParameter();
			FormFieldlabelMainManager.setFormid(formid);
			FormFieldlabelMainManager.setFieldid(fieldid);
			FormFieldlabelMainManager.setLanguageid(languageid);
			String label = Util.null2String(request.getParameter("label_"+languageid+"_"+fieldid));
			if(label.equals(""))
				break;
			FormFieldlabelMainManager.setFieldlabel(label);
			FormFieldlabelMainManager.setIsdefault(isdef);
			FormFieldlabelMainManager.saveFormfieldlabel();
		}
	}

	response.sendRedirect("manageform.jsp");
	return;
  }
*/
%>
