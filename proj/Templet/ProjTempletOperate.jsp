<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="PriTemplate" class="weaver.proj.PriTemplate" scope="page" />
<%
    //多个来源
    String URLFrom = URLDecoder.decode(Util.null2String(request.getParameter("URLFrom")));
        
    String method = Util.null2String(request.getParameter("method"));
    String templetId = Util.null2String(request.getParameter("templetId"));
    //---------项目变量
    int projectType = Util.getIntValue(request.getParameter("txtPrjType"));  //项目类型
    int workType = Util.getIntValue(request.getParameter("txtWorkType"));     //工作类型
    String hrmId = Util.null2String(request.getParameter("hrmids02"));        //项目成员
    int parentId = Util.getIntValue(request.getParameter("txtParentId"));     //上级项目
    int envDoc = Util.getIntValue(request.getParameter("txtEnvDoc"));       //评价书
    int conDoc = Util.getIntValue(request.getParameter("txtConDoc"));       //确认书
    int adviceDoc = Util.getIntValue(request.getParameter("txtAdviceDoc"));    //建议书
    int prjManager = Util.getIntValue(request.getParameter("txtPrjManager"));   //经理
    String isCrmShow = Util.null2String(request.getParameter("isCrmShow"));       //客户可见
    String isMemberShow = Util.null2String(request.getParameter("isMemberShow"));    //成员可见
    String aboutMCrm = Util.null2String(request.getParameter("areaAboutMCrm"));    //相关客户
    String templetName = Util.null2String(request.getParameter("txtTempletName"));    //模板名称
    String templetDesc = Util.null2String(request.getParameter("txtTempletDesc"));    //模板描述
   
    //---------项目自定义字段
    String dff01=Util.null2String(request.getParameter("dff01"));
    String dff02=Util.null2String(request.getParameter("dff02"));
    String dff03=Util.null2String(request.getParameter("dff03"));
    String dff04=Util.null2String(request.getParameter("dff04"));
    String dff05=Util.null2String(request.getParameter("dff05"));

    String nff01=Util.null2String(request.getParameter("nff01"));
    if(nff01.equals("")) nff01="0.0";
    String nff02=Util.null2String(request.getParameter("nff02"));
    if(nff02.equals("")) nff02="0.0";
    String nff03=Util.null2String(request.getParameter("nff03"));
    if(nff03.equals("")) nff03="0.0";
    String nff04=Util.null2String(request.getParameter("nff04"));
    if(nff04.equals("")) nff04="0.0";
    String nff05=Util.null2String(request.getParameter("nff05"));
    if(nff05.equals("")) nff05="0.0";

    String tff01=Util.fromScreen(request.getParameter("tff01"),user.getLanguage());
    String tff02=Util.fromScreen(request.getParameter("tff02"),user.getLanguage());
    String tff03=Util.fromScreen(request.getParameter("tff03"),user.getLanguage());
    String tff04=Util.fromScreen(request.getParameter("tff04"),user.getLanguage());
    String tff05=Util.fromScreen(request.getParameter("tff05"),user.getLanguage());

    String bff01=Util.null2String(request.getParameter("bff01"));
    if(bff01.equals("")) bff01="0";
    String bff02=Util.null2String(request.getParameter("bff02"));
    if(bff02.equals("")) bff02="0";
    String bff03=Util.null2String(request.getParameter("bff03"));
    if(bff03.equals("")) bff03="0";
    String bff04=Util.null2String(request.getParameter("bff04"));
    if(bff04.equals("")) bff04="0";
    String bff05=Util.null2String(request.getParameter("bff05"));
    if(bff05.equals("")) bff05="0";

    //---------任务自定义字段
    String[] taskids = request.getParameterValues("templetTaskId");   //任务ID
    String[] rowIndexs = request.getParameterValues("txtRowIndex");   //任务名称
    String[] taskNames = request.getParameterValues("txtTaskName");   //任务名称
    String[] workLongs = request.getParameterValues("txtWorkLong");   //工期
    String[] beginDates = request.getParameterValues("txtBeginDate");  //开始时间
    String[] endDates = request.getParameterValues("txtEndDate");     //结束时间
    String[] beforeTasks = request.getParameterValues("seleBeforeTask"); //前置任务
    String[] budgets = request.getParameterValues("txtBudget");         //预算
    String[] managers = request.getParameterValues("txtManager");       //负责人
    String linkXml=Util.null2String(request.getParameter("areaLinkXml"));  //上下级关系的字符串
 PriTemplate.setTempletName(templetName);
 PriTemplate.setTempletDesc(templetDesc);
 PriTemplate.setProjectType(projectType);
 PriTemplate.setWorkType(workType);
 PriTemplate.setHrmId(hrmId);
 PriTemplate.setIsMemberShow(isMemberShow);
 PriTemplate.setAboutMCrm(aboutMCrm);
 PriTemplate.setIsCrmShow(isCrmShow);
 PriTemplate.setParentId(parentId);
 PriTemplate.setEnvDoc(envDoc);
 PriTemplate.setConDoc(conDoc);
 PriTemplate.setAdviceDoc(adviceDoc);
 PriTemplate.setPrjManager(prjManager);
 PriTemplate.setLinkXml(linkXml);
 PriTemplate.setDff01(dff01);
 PriTemplate.setDff02(dff02);
 PriTemplate.setDff03(dff03);
 PriTemplate.setDff04(dff04);
 PriTemplate.setDff05(dff05);
 PriTemplate.setNff01(nff01);
 PriTemplate.setNff02(nff02);
 PriTemplate.setNff03(nff03);
 PriTemplate.setNff04(nff04);
 PriTemplate.setNff05(nff05);
 PriTemplate.setTff01(tff01);
 PriTemplate.setTff02(tff02);
 PriTemplate.setTff03(tff03);
 PriTemplate.setTff04(tff04);
 PriTemplate.setTff05(tff05);
 PriTemplate.setBff01(bff01);
 PriTemplate.setBff02(bff02);
 PriTemplate.setBff03(bff03);
 PriTemplate.setBff04(bff04);
 PriTemplate.setBff05(bff05);
 PriTemplate.setTempletId(templetId);

    /*
    项目模板是否需要审批
    modified by hubo,2006-04-21
    */
    String defaultStatus = "1";
	String sqlApprove = "SELECT isNeedAppr,wfid FROM ProjTemplateMaint";
	rs.executeSql(sqlApprove);
	if(rs.next()){
		if(rs.getString("isNeedAppr").equals("1")){
			defaultStatus = "0";
		}
	}

    if ("add".equals(method)){    
        try {
            //------项目变量及项目自定义字段的数据的插入
           PriTemplate.AddPrjTemplateInfo();
            //System.out.println(strInsertSql);
            rs.executeSql("select max(id) from Prj_Template");
            int newProjId = 0;
            if (rs.next()){
                newProjId = Util.getIntValue(rs.getString(1));
            }
            //System.out.println(linkXml);
            //------项目类型自定义字段的值的插入
            ProjTempletUtil.addProjTypeCData(request,newProjId);
        
            //------任务的内容的插入
   
            for (int i=0 ;i<taskNames.length;i++){
                int rowIndex = Util.getIntValue(rowIndexs[i]);
                String taskName = taskNames[i];
                float workLong = Util.getFloatValue(workLongs[i],0);
                String beginDate = beginDates[i];
                String endDate = endDates[i];
                int beforeTask = Util.getIntValue(beforeTasks[i],0);
                float budget = Util.getFloatValue(budgets[i],0);
                int manager =Util.getIntValue(managers[i],0);

                String parentTaskId = ProjTempletUtil.getParentTaskId(linkXml,rowIndex);                  
                //System.out.println("rowIndex :"+rowIndex+" parentTaskId : "+parentTaskId);
                String strsqlForTask = "insert into Prj_TemplateTask (templetId,templetTaskId,taskName,taskManager,begindate,enddate,workday,budget,parentTaskId,befTaskId) values("+newProjId+","+(i+1)+",'"+taskName+"',"+manager+",'"+beginDate+"','"+endDate+"',"+workLong+","+budget+","+parentTaskId+","+beforeTask+")";                
                rs.executeSql(strsqlForTask);          
             }
             
             //前置任务修正
             //任务在未实际插入数据库前，任务id不确定，此时前置任务保存的id为任务的行号，在任务插入数据库后需要修正实际前置任务id
             rs.executeSql("select id,befTaskId from Prj_TemplateTask where befTaskId!=0 and templetId="+newProjId);
             while(rs.next()){
                 String id = rs.getString("id");
                 String befTaskId = rs.getString("befTaskId");
                 String realBefTaskId = befTaskId;
                 rs1.executeSql("select id from Prj_TemplateTask where templetTaskId="+befTaskId+" and templetId="+newProjId);
                 if(rs1.next()) realBefTaskId = rs1.getString("id");
                 rs1.executeSql("update Prj_TemplateTask set befTaskId="+realBefTaskId+" where id="+id);
             }
             //前置任务修正
        } catch (Exception ex) {
            System.out.println(ex);
        }
        if (!"".equals(URLFrom)){
            response.sendRedirect(URLFrom);
        } else {
            response.sendRedirect("ProjTempletList.jsp");        
        }
        return ;
    } else if("edit".equals(method)) {
        try {
            //------项目变量及项目自定义字段的数据的插入
            PriTemplate.EditPriTemplateInfo();
           
            //------项目类型自定义字段的值的编辑
            ProjTempletUtil.editProjTypeCData(request,Util.getIntValue(templetId));
           
            //------任务的内容的编辑
            //选删除所有相关的任务,再添加全部的新任务         

            for (int i=0 ;i<rowIndexs.length;i++){
                int rowIndex = Util.getIntValue(rowIndexs[i]);
                String taskName = taskNames[i];
                float workLong = Util.getFloatValue(workLongs[i],0);
                String beginDate = beginDates[i];
                String endDate = endDates[i];
                int beforeTask = 0;
                int bfindex = Util.getIntValue(beforeTasks[i],0);
                if(bfindex>0) {
                	//前置任务
                	beforeTask = Util.getIntValue(rowIndexs[bfindex-1]);
                }
                float budget = Util.getFloatValue(budgets[i],0);
                int manager =Util.getIntValue(managers[i],0);
                String parentTaskId = ProjTempletUtil.getParentTaskId(linkXml,rowIndex);
                int taskid = Util.getIntValue(taskids[i],-1);

                //System.out.println("rowIndex :"+rowIndex+" parentTaskId : "+parentTaskId);
                String strsqlForTask = "";
                if (taskid!=-1){
                    strsqlForTask="update Prj_TemplateTask set taskName='"+taskName+"',taskManager="+manager+",begindate='"+beginDate+"',enddate='"+endDate+"',workday="+workLong+",budget="+budget+",parentTaskId="+parentTaskId+",befTaskId="+beforeTask+" where templetid="+templetId+" and id="+taskid;
                } else {
                    strsqlForTask = "insert into Prj_TemplateTask (templetId,templetTaskId,taskName,taskManager,begindate,enddate,workday,budget,parentTaskId,befTaskId) values("+templetId+","+rowIndex+",'"+taskName+"',"+manager+",'"+beginDate+"','"+endDate+"',"+workLong+","+budget+","+parentTaskId+","+beforeTask+")"; 
                }
                rs.executeSql(strsqlForTask); 
             }
             //删除相关的任务 
             
             
             //前置任务修正
             //任务在未实际插入数据库前，任务id不确定，此时前置任务保存的id为任务的行号，在任务插入数据库后需要修正实际前置任务id
             rs.executeSql("select id,befTaskId from Prj_TemplateTask where befTaskId!=0 and templetId="+templetId);
             while(rs.next()){
                 String id = rs.getString("id");
                 String befTaskId = rs.getString("befTaskId");
                 String realBefTaskId = befTaskId;
                 rs1.executeSql("select id from Prj_TemplateTask where templetTaskId="+befTaskId+" and templetId="+templetId);
                 if(rs1.next()) realBefTaskId = rs1.getString("id");
                 rs1.executeSql("update Prj_TemplateTask set befTaskId="+realBefTaskId+" where id="+id);
             }
             //前置任务修正
        } catch (Exception ex) {
        	System.out.println(ex);
        }

        ArrayList rowIndexList = Util.arrayToArrayList(rowIndexs);
        rs.executeSql("select id,templetTaskId from Prj_TemplateTask where templetId="+templetId);
        while (rs.next()){
            String taskId = Util.null2String(rs.getString("id"));
            String templetTaskId = Util.null2String(rs.getString("templetTaskId"));           
            //如果从客户端传过来的数据中不存在此任务的ID则需删掉此任务
            if (rowIndexList.indexOf(templetTaskId)==-1){    
                rs1.executeSql("delete Prj_TemplateTask where id = "+taskId);
            }
        }
        response.sendRedirect("ProjTempletView.jsp?templetId="+templetId);        
        return ;
    } else if("delete".equals(method)) {
       if (!"".equals(templetId)) {
             //删除模板本中的数据
             String strDelTemplet = "delete Prj_Template where id="+templetId;
             rs.executeSql(strDelTemplet);
            //删除除任务表中的数据
             String strDelTask = "delete Prj_TemplateTask where templetId="+templetId;
             rs.executeSql(strDelTask);
            //删除自定义表中的数据
             String strDelCdTemplet = "delete cus_fielddata where scope='ProjCustomField'  and id = "+templetId;
             rs.executeSql(strDelCdTemplet);

             //System.out.println(strDelTemplet);
             //System.out.println(strDelTask);
             //System.out.println(strDelCdTemplet);
       }
       if (!"".equals(URLFrom)){
            response.sendRedirect(URLFrom);            
        } else {
            response.sendRedirect("ProjTempletList.jsp"); 
        }
    }
%>
