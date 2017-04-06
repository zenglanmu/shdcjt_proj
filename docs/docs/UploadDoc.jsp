<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="java.net.*" %>

<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ApproveParameter" class="weaver.workflow.request.ApproveParameter" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page"/>
<jsp:useBean id="poppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<%--
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="docCoders" class="weaver.docs.docs.DocCoder" scope="page"/>
--%>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocApproveWfManager" class="weaver.docs.docs.DocApproveWfManager" scope="page" />
<jsp:useBean id="RequestDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>

<%@ include file="/systeminfo/init.jsp" %>

<%
  	DocManager.resetParameter();
  	DocManager.setClientAddress(request.getRemoteAddr());
    DocManager.setUserid(user.getUID());
    DocManager.setLanguageid(user.getLanguage());
    DocManager.setUsertype(""+user.getLogintype());	 
  	String message = DocManager.UploadDoc(request);
    String fromFlowDoc= Util.null2String(request.getParameter("fromFlowDoc")); //从流程建文挡来
    int relatedWorkflowId=Util.getIntValue(request.getParameter("workflowid"),0);//流程id

    int docId=DocManager.getId();
    
    //处理文档中图片权限
    String content = DocManager.getDoccontent2();
    DocManager.correctDocImageFileByDocContent(docId,content);
   
    
    
    
    
    
    
	//得到文档状态
	String status = DocManager.getDocstatus2();

    FileUpload fileUpload=DocManager.getFileUpload2();

	String oldStatus=DocManager.getOldstatus();
		
    if (fromFlowDoc.equals("1")) {
		//rs.executeSql("update docdetail set docstatus='1' where id="+docId);//从流程建文挡不要审批
		//DocManager.setDocstatus("1");


		ArrayList docFiledList=RequestDoc.getDocFiled(""+relatedWorkflowId);
		String isWorkflowDraft="";
		if(docFiledList!=null&&docFiledList.size()>6){
			isWorkflowDraft=""+docFiledList.get(6);
		}
		if(!"2".equals(status)&&!"5".equals(status)&&!"2".equals(oldStatus)&&!"5".equals(oldStatus)&&"1".equals(isWorkflowDraft)){
		    rs.executeSql("update docdetail set docstatus='9' where id="+docId);//从流程建文挡不要审批
		    DocManager.setDocstatus("9");
			status="9";
		}else if(!"2".equals(status)&&!"5".equals(status)&&!"2".equals(oldStatus)&&!"5".equals(oldStatus)){
		    rs.executeSql("update docdetail set docstatus='1' where id="+docId);//从流程建文挡不要审批
		    DocManager.setDocstatus("1");
			status="1";
		}else if("2".equals(oldStatus)||"5".equals(oldStatus)){
		    rs.executeSql("update docdetail set docstatus='"+oldStatus+"' where id="+docId);
		    DocManager.setDocstatus(oldStatus);
			status=oldStatus;
		}

		int requestid=Util.getIntValue(fileUpload.getParameter("requestid"),0);//请求id
		if(requestid>0){
			RequestDoc.setDocIdToRequest(String.valueOf(relatedWorkflowId),String.valueOf(requestid),String.valueOf(docId));
		}
	}

	String isFromAccessory=Util.null2String(fileUpload.getParameter("isFromAccessory"));//是否来自于附件

	String pstate="sub";
	if(isFromAccessory.equals("1")){
		pstate="";
	}

    if("9".equals(oldStatus)){//9：流程草稿状态的文档编辑后不更改文档状态。
		rs.executeSql("update docdetail set docstatus='9' where id="+docId);//从流程建文挡不要审批
		DocManager.setDocstatus("9");
		status="9";
	}
//    if (flowDocss.getRequestToModul()!=null&&((flowDocss.getRequestToModul()).size()>0)) {
//	    docCoders.saveModulValue(flowDocss.getRequestToModul(),""+docId); //存储书签
//	    flowDocss.setRequestToModul();
//    }
  	if ("".equals(message)) {
  		out.println(SystemEnv.getHtmlLabelName(19139,user.getLanguage()));
  		return ;  	
  	}
   
    if ("addPersonalDoc".equals(message)){
        String userCategoryId = DocManager.getUserCatalogId();
        response.sendRedirect("PersonalDocRight.jsp?userCategory="+userCategoryId);        
        return ;
    }     

    if ("useTemplet".equals(message)){
        String temp_doc_topage = Util.null2String((String)session.getAttribute("temp_doc_topage"));;
	    session.removeAttribute("temp_doc_topage");
		session.setAttribute("doc_topage",URLDecoder.decode(temp_doc_topage));

    } 
    String urlfrom = DocManager.getUrlFrom();

    boolean isadd = (message.indexOf("add") == 0) ;
    boolean isedit = (message.indexOf("edit") == 0) ;   

    // 文档缓存
    if(isadd || isedit || message.equals("delete")) {       
        if(isadd) DocComInfo.addDocInfoCache(""+docId);
        else if(isedit) DocComInfo.updateDocInfoCache(""+docId);
        else DocComInfo.deleteDocInfoCache(""+docId);
    }

    int contractid = 0;
    String sql = "select id,contractman from HrmContract where contractdocid = "+docId;
    rs.executeSql(sql);
    while(rs.next()) {
        contractid = Util.getIntValue(rs.getString("id"));
        //update popup message table
        int userid = user.getUID();                   //当前用户id
        String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
        int usertype = 0;
        if (logintype.equals("1")) usertype = 0;
        if (logintype.equals("2")) usertype = 1;
        rs.executeSql("SELECT id FROM HrmRemindMsg where remindtype<5 and resourceid=" + rs.getString("contractman"));
        while (rs.next()) {
            String remindid = rs.getString("id");
            poppupRemindInfoUtil.updatePoppupRemindInfo(userid, 7, (logintype).equals("1") ? "0" : "1", Util.getIntValue(remindid, 0));
        }      
    }

    if(message.equals("delete")){   //delete
        if(urlfrom.equals("hr")){
       		out.write("<script>try{opener._table.reLoad();window.close();}catch(e){window.location.href = \"/hrm/contract/contract/HrmContract.jsp?from=delete\"}</script>");
        }else{
            response.sendRedirect("/docs/search/DocSummary.jsp");
        }   
    }else if(message.equals("delete_1")){// delete_1
        if(urlfrom.equals("hr")){
            response.sendRedirect("/hrm/contract/contract/HrmContractEdit.jsp?id="+contractid);
        }        
        response.sendRedirect("DocDsp.jsp?messageid=1&id="+docId+"&pstate="+pstate);
    }else if(message.equals("delpic")){// delpic
        if(urlfrom.equals("hr")){
          response.sendRedirect("/hrm/contract/contract/HrmContractEdit.jsp?id="+contractid);
        }
        response.sendRedirect("DocEdit.jsp?id="+docId);
    } else if(isadd || isedit || message.equals("invalidate")){// add edit invalidate
		//进行共享
        DocViewer.setDocShareByDoc(""+docId);

        if(urlfrom.equals("hr")){
			out.write("<script>try{opener._table.reLoad();window.close();}catch(e){window.location.href = \"/hrm/contract/contract/HrmContractView.jsp?id="+contractid+"\"}</script>");
        }else{
	        boolean blnOsp = false;  //open share window 只有两种情况有弹出框 1.当做的是除开草稿外的新建操作 2.做的是编辑提交草稿外的编辑操作
	    	

			
            //如果子目录设置了文档提交时设置共享，则弹出设置共享窗口
            //TD.5037只有新建提交（非草稿），才弹出设置共享窗口
            //或者编辑草稿时，
            if(("addsave".equals(message)||("editsave".equals(message)&&(DocManager.getOldstatus().equals("0")||DocManager.getOldstatus().equals("4")||Util.getIntValue(DocManager.getOldstatus(),0)<=0)))&&SecCategoryComInfo.isSetShare(DocManager.getSeccategory2())&&!message.equals("invalidate")){
        	    blnOsp = true ;
          	}

	        //提交需要审批
	        if ("addsave".equals(message)||"editsave".equals(message)||"invalidate".equals(message)){
	        	String doc_topage=Util.null2String((String)session.getAttribute("doc_topage"));
				//TD8562
				//通过项目卡片或任务信息页面新建文档，提交时要弹出共享设置页面。
              	//System.out.println("doc_topage = " + doc_topage);
	        	if (!"".equals(doc_topage)&&doc_topage.indexOf("ViewProject.jsp")==-1&&doc_topage.indexOf("/proj/process/DocOperation.jsp")==-1){
	        		blnOsp = false;
	        	}
	        	
	        	if(!blnOsp&&docId>0){//如果不需要弹出设置共享窗口
	        	
	        		if("-1".equals(status)){
	        			RecordSet.executeSql("update DocDetail set docStatus='1' where id="+docId);
	        		}
	        		
	        		if("-6".equals(status)){
	        			RecordSet.executeSql("update DocDetail set docStatus='6' where id="+docId);
	        		}
					String approveType = "invalidate".equals(message)?"2":"1";
	        		//直接触发流程
	              	if(("-3".equals(status)||"3".equals(status))&&SecCategoryComInfo.needApprove(DocComInfo.getDocSecCategory(""+docId), Util.getIntValue(approveType,1))&&!fromFlowDoc.equals("1")){
	              		if("-3".equals(status))
	              			RecordSet.executeSql("update DocDetail set docStatus='3' where id="+docId);
	
	                    //String approveType="invalidate".equals(message)?"2":"1";
	                    //DocApproveWfManager.approveWf(docId,approveType,user);
	
						//流程的触发
						//int workflowid = SecCategoryComInfo.getApproveWf(DocManager.getSeccategory2(),("invalidate".equals(message)?2:1));
	                    
	                    int workflowId=-1;
						String isOpenApproveWf="";/*isOpenApproveWf为1表示启用文档生效审批和文档失效审批 ，isOpenApproveWf为2表示启用批准工作流，即文档需求变更前使用的批准工作流。 fanggsh 20060928 fot TD5032*/
	
							RecordSet.executeSql("select approveWorkflowId,isOpenApproveWf from DocSecCategory where id="+DocManager.getSeccategory2());
							if(RecordSet.next()) {
								workflowId=RecordSet.getInt("approveWorkflowId");
								isOpenApproveWf=Util.null2String(RecordSet.getString("isOpenApproveWf"));
							}
	
						if(isOpenApproveWf.equals("1")&&!"3".equals(DocManager.getOldstatus())){
							DocApproveWfManager.setRequest(request);
							String approveWfStatus=DocApproveWfManager.approveWf(docId,approveType,user);
							if("false".equals(approveWfStatus)&&approveType.equals("1")){
								RecordSet.executeSql("update DocDetail set docStatus='0' where id="+docId);
								//RecordSet.executeSql("update DocDetail set isHistory='1',docStatus='7' where id<>"+docId+" and docEditionId=(select docEditionId from DocDetail where id="+docId+")");
				                RecordSet.executeSql(" update docdetail set docstatus = 7,ishistory = 1 where id <> " + docId + " and docedition > 0 and docedition < (select docedition from DocDetail where id="+docId+") and doceditionid > 0 and doceditionid = (select docEditionId from DocDetail where id="+docId+")");
								
							}
							if("false".equals(approveWfStatus)&&approveType.equals("2")){
								RecordSet.executeSql("update DocDetail set docStatus='2' where id="+docId);
							}
						}
	
						if(!"invalidate".equals(message)&&workflowId>0&&isOpenApproveWf.equals("2")&&!"3".equals(DocManager.getOldstatus())){
							//触发流程
							ApproveParameter.resetParameter();
							ApproveParameter.setWorkflowid(workflowId);
							ApproveParameter.setNodetype("0");
							ApproveParameter.setApproveid(docId);
							ApproveParameter.setApprovetype("9");
							ApproveParameter.setRequestname(DocManager.getDocsubject2());          
							ApproveParameter.setGopage("/docs/docs/DocApprove.jsp?id=");
							ApproveParameter.setBackpage("/docs/docs/DocApprove.jsp?id="); 
							
							if(ApproveParameter.getFormid()==67) {
								//response.sendRedirect("/workflow/request/BillInnerSendDocOperation.jsp?docid="+docId+"&src=save&iscreate=1&blnOsp="+true);
								response.sendRedirect("/workflow/request/BillInnerSendDocOperation.jsp?docid="+docId+"&src=save&iscreate=1&blnOsp="+blnOsp);
							} else if(ApproveParameter.getFormid()==28) {
								RecordSet.executeSql("select a.requestid,a.requestname from workflow_requestbase a, bill_Approve b where a.workflowid="+workflowId+" and a.currentnodetype=0 and a.requestid=b.requestid and b.approveid="+docId);
								
								if(RecordSet.next()){//该文档对应的审批流程已触发过，并且流程目前处于创建节点
								    String tempRequestid = RecordSet.getString(1);
								    String tempnodeid = ""+ApproveParameter.getNodeid();
								    String temprequestname = RecordSet.getString(2);
								    response.sendRedirect("/workflow/request/BillApproveOperation.jsp?workflowid="+workflowId+"&requestid="+tempRequestid+"&docid="+docId+"&src=submit&iscreate=0&blnOsp="+blnOsp+"&topage="+URLEncoder.encode(DocManager.getToPage())+"&flagTASK=1&nodeid="+tempnodeid+"&nodetype=0&isbill=1&formid=28&requestname="+URLEncoder.encode(temprequestname) + "&isremark=0");
								}else{
								response.sendRedirect("/workflow/request/BillApproveOperation.jsp?docid="+docId+"&src=submit&iscreate=1&blnOsp="+blnOsp+"&topage="+URLEncoder.encode(DocManager.getToPage())+"&flagTASK=1");
								}
							}else{   
								//response.sendRedirect("/workflow/request/BillApproveOperation.jsp?docid="+docId+"&src=submit&iscreate=1&blnOsp="+true);
								response.sendRedirect("/workflow/request/BillApproveOperation.jsp?docid="+docId+"&src=submit&iscreate=1&blnOsp="+blnOsp);							
							}
							return;						
						}
	              	}
	            }
	        }
			
			if (fromFlowDoc.equals("1")) {//如果是从公文则之间跳转到ViewRequest.jsp
				String doctopage = DocManager.getToPage();
				if(doctopage.indexOf("fromFlowDoc")>0)
				doctopage = Util.StringReplaceOnce(doctopage,"fromFlowDoc","fromFlowDoc1");
				out.println("<script>parent.location.href=\""+doctopage+"&docfileid=1&docid="+docId+"\"</script>");			
				return;	
			}
			int oldid = Util.getIntValue(fileUpload.getParameter("id"), 0);
			if(oldid<docId){
				out.write("<script>try{opener._table.reLoad();}catch(e){}</script>");
				String locationhref="/docs/docs/DocDsp.jsp?fromFlowDoc="+fromFlowDoc+"&id="+docId+"&blnOsp="+blnOsp+"&topage="+URLEncoder.encode(DocManager.getToPage())+"&pstate="+pstate;
			    out.write("<script>location.href=\""+locationhref+"\"</script>");
			}else{
				response.sendRedirect("/docs/docs/DocDsp.jsp?fromFlowDoc="+fromFlowDoc+"&id="+docId+"&blnOsp="+blnOsp+"&topage="+URLEncoder.encode(DocManager.getToPage())+"&pstate="+pstate);
			}
        }
	}else{
		if(urlfrom.equals("hr")){
			out.write("<script>try{opener._table.reLoad();window.close();}catch(e){window.location.href = \"/hrm/contract/contract/HrmContractView.jsp?id="+contractid+"\"}</script>");
	    }else{   
	      //response.sendRedirect("DocDsp.jsp?id="+docId+"&pstate=sub");
			if (fromFlowDoc.equals("1")) {//如果是从公文则之间跳转到ViewRequest.jsp
				String doctopage = DocManager.getToPage();
				if(doctopage.indexOf("fromFlowDoc")>0)
				doctopage = Util.StringReplaceOnce(doctopage,"fromFlowDoc","fromFlowDoc1");
				out.println("<script>parent.location.href=\""+doctopage+"&docfileid=1&docid="+docId+"\"</script>");			
				return;	
			}
	      response.sendRedirect("/docs/docs/DocDsp.jsp?fromFlowDoc="+fromFlowDoc+"&id="+docId+"&topage="+URLEncoder.encode(DocManager.getToPage())+"&pstate="+pstate);
	    }
	}
%>
