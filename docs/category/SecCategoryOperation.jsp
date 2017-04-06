<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.conn.ConnStatement" %>
 <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page"/>
<jsp:useBean id="SecShareableCominfo" class="weaver.docs.docs.SecShareableCominfo" scope="page"/>
<%
  String operation = Util.null2String(request.getParameter("operation"));
  char flag=Util.getSeparator();
  int userid=user.getUID();
  AclManager am = new AclManager();
  CategoryManager cm = new CategoryManager();

  int fromTab = Util.getIntValue(request.getParameter("fromtab"),0);

  if(operation.equalsIgnoreCase("add") ||operation.equalsIgnoreCase("edit") ){
      //add by wjy for custom field
      //for save seccategory id
      int secid = -1;
      //end by wjy

  	String subcategoryid=Util.fromScreen(request.getParameter("subcategoryid"),user.getLanguage());
  	int subid = Integer.parseInt(subcategoryid);
    int mainid=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid),0);
	String categoryname=Util.fromScreen(request.getParameter("categoryname"),user.getLanguage()).trim();
	String coder=Util.fromScreen(request.getParameter("coder"),user.getLanguage());
	String srccategoryname=Util.fromScreen(request.getParameter("srccategoryname"),user.getLanguage());
	String docmouldid=Util.fromScreen(request.getParameter("docmouldid"),user.getLanguage());
		if(docmouldid.equals(""))	docmouldid="0";
		
	/* added by wdl 2006.7.3 TD.4617 start */
	String wordmouldid=Util.fromScreen(request.getParameter("wordmouldid"),user.getLanguage());
	if(wordmouldid.equals(""))	wordmouldid="0";
	/* added end */
		
	String publishable=Util.fromScreen(request.getParameter("publishable"),user.getLanguage());
		if(publishable.equals(""))	publishable="0";
	String replyable=Util.fromScreen(request.getParameter("replyable"),user.getLanguage());
		if(replyable.equals(""))	replyable="0";
	String shareable=Util.fromScreen(request.getParameter("shareable"),user.getLanguage());
		if(shareable.equals(""))	shareable="0";

	String cusertype=Util.fromScreen(request.getParameter("cusertype"),user.getLanguage());
	String cuserseclevel=Util.fromScreen(request.getParameter("cuserseclevel"),user.getLanguage());
/* 下面这行代码2003年6月6日由谭小鹏注释掉 */
//		if(cuserseclevel.equals(""))	shareable="0";
	String cdepartmentid1=Util.fromScreen(request.getParameter("cdepartmentid1"),user.getLanguage());
	String cdepseclevel1=Util.fromScreen(request.getParameter("cdepseclevel1"),user.getLanguage());
	String cdepartmentid2=Util.fromScreen(request.getParameter("cdepartmentid2"),user.getLanguage());
	String cdepseclevel2=Util.fromScreen(request.getParameter("cdepseclevel2"),user.getLanguage());
	String croleid1=Util.fromScreen(request.getParameter("croleid1"),user.getLanguage());
	String crolelevel1=Util.fromScreen(request.getParameter("crolelevel1"),user.getLanguage());
	String croleid2=Util.fromScreen(request.getParameter("croleid2"),user.getLanguage());
	String crolelevel2=Util.fromScreen(request.getParameter("crolelevel2"),user.getLanguage());
	String croleid3=Util.fromScreen(request.getParameter("croleid3"),user.getLanguage());
	String crolelevel3=Util.fromScreen(request.getParameter("crolelevel3"),user.getLanguage());
	String approvewfid=Util.fromScreen(request.getParameter("approvewfid"),user.getLanguage());

	String hasaccessory=Util.fromScreen(request.getParameter("hasaccessory"),user.getLanguage());
		if(hasaccessory.equals(""))	hasaccessory="0";
	String accessorynum=Util.fromScreen(request.getParameter("accessorynum"),user.getLanguage());
	String hasasset=Util.fromScreen(request.getParameter("hasasset"),user.getLanguage());
	String assetlabel=Util.fromScreen(request.getParameter("assetlabel"),user.getLanguage());
	String hasitems=Util.fromScreen(request.getParameter("hasitems"),user.getLanguage());
	String itemlabel=Util.fromScreen(request.getParameter("itemlabel"),user.getLanguage());
	String hashrmres=Util.fromScreen(request.getParameter("hashrmres"),user.getLanguage());
	String hrmreslabel=Util.fromScreen(request.getParameter("hrmreslabel"),user.getLanguage());
	String hascrm=Util.fromScreen(request.getParameter("hascrm"),user.getLanguage());
	String crmlabel=Util.fromScreen(request.getParameter("crmlabel"),user.getLanguage());
	String hasproject=Util.fromScreen(request.getParameter("hasproject"),user.getLanguage());
	String projectlabel=Util.fromScreen(request.getParameter("projectlabel"),user.getLanguage());
	String hasfinance=Util.fromScreen(request.getParameter("hasfinance"),user.getLanguage());
	String financelabel=Util.fromScreen(request.getParameter("financelabel"),user.getLanguage());

  //增加是否此目录打分，以及是否匿名打分等字段
    int markable=Util.getIntValue(Util.null2String(request.getParameter("markable")),0);
    int markAnonymity=Util.getIntValue(Util.null2String(request.getParameter("markAnonymity")),0);
    int orderable=Util.getIntValue(Util.null2String(request.getParameter("orderable")),0);
    int defaultLockedDoc=Util.getIntValue(Util.null2String(request.getParameter("defaultLockedDoc")),0);
    int isSetShare=Util.getIntValue(Util.null2String(request.getParameter("isSetShare")),0);

    int allownModiMShareL=Util.getIntValue(Util.null2String(request.getParameter("allownModiMShareL")),0);
    int allownModiMShareW=Util.getIntValue(Util.null2String(request.getParameter("allownModiMShareW")),0);
    String allowShareTypeStrs = "";

    String[] allowAddSharers = request.getParameterValues("allowAddSharer");
    if (allowAddSharers!=null) {
        for (int i=0;i<allowAddSharers.length;i++){
            allowShareTypeStrs+=allowAddSharers[i]+",";
        }
    }

    int maxOfficeDocFileSize = Util.getIntValue(request.getParameter("maxOfficeDocFileSize"),8);
    int maxUploadFileSize = Util.getIntValue(request.getParameter("maxUploadFileSize"),0);
    
    if(maxUploadFileSize<0){
    	maxUploadFileSize = 0;
    }
	
    int noDownload = Util.getIntValue(request.getParameter("noDownload"),0);
	int noRepeatedName = Util.getIntValue(request.getParameter("noRepeatedName"),0);
	int bacthDownload = Util.getIntValue(request.getParameter("bacthDownload"),0);
	int isControledByDir = Util.getIntValue(request.getParameter("isControledByDir"),0);
	int pubOperation = Util.getIntValue(request.getParameter("pubOperation"),0);
	int childDocReadRemind = Util.getIntValue(request.getParameter("childDocReadRemind"),0);

	String isPrintControl = Util.null2String(request.getParameter("isPrintControl"));
	int printApplyWorkflowId = Util.getIntValue(request.getParameter("printApplyWorkflowId"),0);

    String isLogControl = Util.null2String(request.getParameter("isLogControl"));

	int readOpterCanPrint = Util.getIntValue(request.getParameter("readOpterCanPrint"),0);
	
	int logviewtype = Util.getIntValue(request.getParameter("logviewtype"),0);

    //TD2858 新的需求: 添加与文档创建人相关的默认共享  
    int PCreater=Util.getIntValue(request.getParameter("PDocCreater"),0);
    int PCreaterManager=Util.getIntValue(request.getParameter("PCreaterManager"),0);
    int PCreaterJmanager=Util.getIntValue(request.getParameter("PCreaterJmanager"),0);
    int PCreaterDownOwner=Util.getIntValue(request.getParameter("PCreaterDownOwner"),0);
    int PCreaterSubComp=Util.getIntValue(request.getParameter("PCreaterSubComp"),0);
    int PCreaterDepart=Util.getIntValue(request.getParameter("PCreaterDepart"),0);
    
    int PCreaterDownOwnerLS=Util.getIntValue(request.getParameter("PCreaterDownOwnerLS"),0);
    int PCreaterSubCompLS=Util.getIntValue(request.getParameter("PCreaterSubCompLS"),0);
    int PCreaterDepartLS=Util.getIntValue(request.getParameter("PCreaterDepartLS"),0); 

    int PDocCreaterW=Util.getIntValue(request.getParameter("PDocCreaterW"),0);
    int PCreaterManagerW=Util.getIntValue(request.getParameter("PCreaterManagerW"),0);
    int PCreaterJmanagerW=Util.getIntValue(request.getParameter("PCreaterJmanagerW"),0);

	String defaultDummyCata=Util.null2String(request.getParameter("defaultDummyCata"));
	 int relationable =Util.getIntValue(request.getParameter("relationable"),0);
	
	float secorder = Util.getFloatValue(request.getParameter("secorder"),0);//目录顺序
	
	int dirmouldid = Util.getIntValue(Util.null2String(request.getParameter("dirmouldid")),0);

	int appointedWorkflowId = Util.getIntValue(request.getParameter("appointedWorkflowId"),0);	

/** =========TD12005 文档下载控制权限   开始=========*/
	int PCreaterDL = Util.getIntValue(request.getParameter("chkPDocCreater"),0);
	int PCreaterManagerDL = Util.getIntValue(request.getParameter("chkPCreaterManager"),0);
	int PCreaterSubCompDL = Util.getIntValue(request.getParameter("chkPCreaterSubComp"),0);
	int PCreaterDepartDL = Util.getIntValue(request.getParameter("chkPCreaterDepart"),0);
	int PCreaterWDL = Util.getIntValue(request.getParameter("chkPDocCreaterW"),0);
	int PCreaterManagerWDL = Util.getIntValue(request.getParameter("chkPCreaterManagerW"),0);
/** =========TD12005 文档下载控制权限   结束=========*/

    String isUseFTPOfSystem=Util.null2String(request.getParameter("isUseFTPOfSystem"));//ecology系统使用FTP服务器设置功能  true:启用   false:不使用
    String isUseFTP=Util.null2String(request.getParameter("isUseFTP"));//指定文档子目录是否启用FTP服务器设置
    int FTPConfigId=Util.getIntValue(request.getParameter("FTPConfigId"));//FTP服务器
    
    int isOpenAttachment = Util.getIntValue(request.getParameter("isOpenAttachment"),0);
    
    int isAutoExtendInfo = Util.getIntValue(request.getParameter("isAutoExtendInfo"),0);

	if(operation.equalsIgnoreCase("add")){
	    if(!HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user) && !am.hasPermission(subid, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	    }

        String checkSql = "select count(id) from DocSecCategory where subcategoryid="+subid+" and categoryname = '"+categoryname+"'";
        RecordSet.executeSql(checkSql);
        if(RecordSet.next()){
            if(RecordSet.getInt(1)>0){
                response.sendRedirect("DocSecCategoryAdd.jsp?id="+subid+"&mainid="+mainid+"&errorcode=10");
                return;
            }
        }

		String ParaStr=subcategoryid+flag+categoryname+flag+docmouldid+flag+publishable+flag+replyable+flag+shareable+flag+
					cusertype+flag+cuserseclevel+flag+cdepartmentid1+flag+cdepseclevel1+flag+cdepartmentid2+flag+
					cdepseclevel2+flag+croleid1+flag+crolelevel1+flag+croleid2+flag+crolelevel2+flag+croleid3+flag+
					crolelevel3+flag+hasaccessory+flag+accessorynum+flag+
					hasasset+flag+assetlabel+flag+hasitems+flag+itemlabel+flag+hashrmres+flag+hrmreslabel+flag+hascrm+flag+
					crmlabel+flag+hasproject+flag+projectlabel+flag+hasfinance+flag+financelabel+flag+approvewfid+flag+markable+flag+markAnonymity+flag+orderable+flag+defaultLockedDoc+flag+""+allownModiMShareL+flag+""+allownModiMShareW+flag+
					maxUploadFileSize+flag+wordmouldid+flag+isSetShare+flag+
					noDownload+flag+noRepeatedName+flag+isControledByDir+flag+pubOperation+flag+childDocReadRemind+flag+readOpterCanPrint+flag+isLogControl;
		RecordSet.executeProc("Doc_SecCategory_Insert",ParaStr);
		RecordSet.next();
        	int id=RecordSet.getInt(1);

        SecShareableCominfo.addSecShareInfoCache(""+id);    
		int newid=RecordSet.getInt(1);
        
		
         /*是否允许订阅的处理 start*/
        if (orderable ==1) {
            RecordSet1.executeSql("update docdetail set orderable='1' where seccategory = "+id ); 
        }
        
        RecordSet1.executeSql("update DocSecCategory set secorder="+secorder+",defaultDummyCata='"+defaultDummyCata+"',logviewtype="+logviewtype+",appliedTemplateId="+dirmouldid+",coder='"+coder+"',appointedWorkflowId="+appointedWorkflowId+",isPrintControl='"+isPrintControl+"',printApplyWorkflowId="+printApplyWorkflowId+",relationable='"+relationable+"',isOpenAttachment="+isOpenAttachment+",isAutoExtendInfo="+isAutoExtendInfo+",maxOfficeDocFileSize="+maxOfficeDocFileSize+",bacthDownload="+bacthDownload+" where id = "+id );

        secid = newid;
		cm.addSecidToSuperiorSubCategory(newid);
		log.resetParameter();
        log.setRelatedId(newid);
        log.setRelatedName(categoryname);
        log.setOperateType("1");
        log.setOperateDesc("Doc_SecCategory_Insert");
        log.setOperateItem("3");
        log.setOperateUserid(userid);
        log.setClientAddress(request.getRemoteAddr());
        log.setSysLogInfo();
        
        //TD2858 新的需求: 添加与文档创建人相关的默认共享  开始               
        String strSqlInsert ="insert into secCreaterDocPope (secid,PCreater,PCreaterManager,PCreaterJmanager,PCreaterDownOwner,"+
                            "PCreaterSubComp,PCreaterDepart,PCreaterDownOwnerLS,PCreaterSubCompLS,"+
                            "PCreaterDepartLS,PCreaterW,PCreaterManagerW,PCreaterJmanagerW) values ("+newid+","+PCreater+","+PCreaterManager+","+PCreaterJmanager+","+PCreaterDownOwner+","+
                            PCreaterSubComp+","+PCreaterDepart+","+PCreaterDownOwnerLS+","+PCreaterSubCompLS+","+
                            PCreaterDepartLS+","+PDocCreaterW+","+PCreaterManagerW+","+PCreaterJmanagerW+")";
        
        RecordSet.executeSql(strSqlInsert);    
        //System.out.println(strSqlInsert);   
        //TD2858 新的需求: 添加与文档创建人相关的默认共享  结束

		ConnStatement statement = new ConnStatement();
		try {

			//更新FTP服务器设置信息
			if("1".equals(isUseFTPOfSystem)){
				String sql_FTPConfig="insert into DocSecCatFTPConfig(secCategoryId,isUseFTP,FTPConfigId) values(?,?,?)";
				statement.setStatementSql(sql_FTPConfig);
				statement.setInt(1, secid);
				statement.setString(2, isUseFTP);
				statement.setInt(3, FTPConfigId);
				
				statement.executeUpdate();				
			}			
			
		} catch (Exception e) {
			throw e;
		} finally {
			try {
				statement.close();
			} catch (Exception ex) {
			}
		}

        SubCategoryComInfo.removeMainCategoryCache();
    	SecCategoryComInfo.removeMainCategoryCache();
    }
	if(operation.equalsIgnoreCase("edit")){
		String id=Util.fromScreen(request.getParameter("id"),user.getLanguage());
		int newid=Util.getIntValue(id,0);
		String fromSecSet = Util.null2String(request.getParameter("fromSecSet"));
		secid = Util.getIntValue(id,-1);
		//System.out.println("fromSecSet:"+fromSecSet);
		if(!"right".equals(fromSecSet)){		
			//System.out.println("base...");   
	      
		    if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !am.hasPermission(subid, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR)){
	    		response.sendRedirect("/notice/noright.jsp");
	    		return;
		    }
	
	        String checkSql = "select count(id) from DocSecCategory where categoryname <> '"+srccategoryname+"' and subcategoryid="+subid+" and categoryname = '"+categoryname+"'";
	        RecordSet.executeSql(checkSql);
	        if(RecordSet.next()){
	            if(RecordSet.getInt(1)>0){
	                response.sendRedirect("DocSecCategoryEdit.jsp?id="+id+"&errorcode=10");
	                return;
	            }
	        }
	        int oldOrderAble = 0 ;
	        /*是否允许订阅的处理 start*/
	         RecordSet.executeSql("select  orderable from docseccategory where id ="+id);
	         if (RecordSet.next()){
	            oldOrderAble = Util.getIntValue(RecordSet.getString(1),0);
	         }        
	         if (oldOrderAble!=orderable){
	            RecordSet.executeSql("update docdetail set orderable='"+orderable+"' where seccategory = "+id );          
	         }
	        //end
	
			String ParaStr=id+flag+subcategoryid+flag+categoryname+flag+coder+flag+docmouldid+flag+publishable+flag+replyable+flag+shareable+flag+
						cusertype+flag+cuserseclevel+flag+cdepartmentid1+flag+cdepseclevel1+flag+cdepartmentid2+flag+
						cdepseclevel2+flag+croleid1+flag+crolelevel1+flag+croleid2+flag+crolelevel2+flag+croleid3+flag+
						crolelevel3+flag+hasaccessory+flag+accessorynum+flag+
						hasasset+flag+assetlabel+flag+hasitems+flag+itemlabel+flag+hashrmres+flag+hrmreslabel+flag+hascrm+flag+
						crmlabel+flag+hasproject+flag+projectlabel+flag+hasfinance+flag+financelabel+flag+approvewfid+flag+markable+flag+markAnonymity+flag+orderable+flag+defaultLockedDoc+flag+""+allownModiMShareL+flag+""+allownModiMShareW+flag+
						maxUploadFileSize+flag+wordmouldid+flag+isSetShare+flag+
						noDownload+flag+noRepeatedName+flag+isControledByDir+flag+pubOperation+flag+childDocReadRemind+flag+readOpterCanPrint+flag+isLogControl;
			RecordSet.executeProc("Doc_SecCategory_Update",ParaStr);
			
	        SecShareableCominfo.updateDocInfoCache(""+newid);
	
	        RecordSet1.executeSql("update DocSecCategory set secorder="+secorder+",defaultDummyCata='"+defaultDummyCata+"',logviewtype="+logviewtype+",appliedTemplateId="+dirmouldid+",coder='"+coder+"',appointedWorkflowId="+appointedWorkflowId+",isPrintControl='"+isPrintControl+"',printApplyWorkflowId="+printApplyWorkflowId+",relationable='"+relationable+"',isOpenAttachment="+isOpenAttachment+",isAutoExtendInfo="+isAutoExtendInfo+",maxOfficeDocFileSize="+maxOfficeDocFileSize+",bacthDownload="+bacthDownload+" where id = "+newid );		
			log.resetParameter();
	        log.setRelatedId(newid);
	        log.setRelatedName(categoryname);
	        log.setOperateType("2");
	        log.setOperateDesc("Doc_SecCategory_Update");
	        log.setOperateItem("3");
	        log.setOperateUserid(userid);
	        log.setClientAddress(request.getRemoteAddr());
	        log.setSysLogInfo();

		ConnStatement statement = new ConnStatement();
		try {
			//更新FTP服务器设置信息
			if("1".equals(isUseFTPOfSystem)){
				
				//更新主目录FTP配置信息  开始
				String sql_FTPConfig_delete="delete from DocSecCatFTPConfig where secCategoryId=?";
				statement.setStatementSql(sql_FTPConfig_delete);
				statement.setInt(1, secid);
					
				statement.executeUpdate();

				
				String sql_FTPConfig="insert into DocSecCatFTPConfig(secCategoryId,isUseFTP,FTPConfigId) values(?,?,?)";
				statement.setStatementSql(sql_FTPConfig);
				statement.setInt(1, secid);
				statement.setString(2, isUseFTP);
				statement.setInt(3, FTPConfigId);	
					
				statement.executeUpdate();	
				//更新子目录FTP配置信息  结束

			}
		} catch (Exception e) {
			throw e;
		} finally {
			try {
				statement.close();
			} catch (Exception ex) {
			}
		}
	        SubCategoryComInfo.removeMainCategoryCache();
	    	SecCategoryComInfo.removeMainCategoryCache();
		} else {
			
			//System.out.println("right...");
        
	       //TD2858 新的需求: 添加与文档创建人相关的默认共享  开始
	        RecordSet.executeSql("select count(id) from secCreaterDocPope where secid="+id);
	        RecordSet.next();
	        int countProp = RecordSet.getInt(1);
	        if (countProp!=0) {
/** =========TD12005 文档下载控制权限   开始=========*/
                PCreaterDL = this.setDLValueInit(PCreaterDL, PCreater);
                PCreaterManagerDL = this.setDLValueInit(PCreaterManagerDL, PCreaterManager);
                PCreaterSubCompDL = this.setDLValueInit(PCreaterSubCompDL, PCreaterSubComp);
                PCreaterDepartDL = this.setDLValueInit(PCreaterDepartDL, PCreaterDepart);
                PCreaterWDL = this.setDLValueInit(PCreaterWDL, PDocCreaterW);
                PCreaterManagerWDL = this.setDLValueInit(PCreaterManagerWDL, PCreaterManagerW);
                //String strUpdateInsert ="update  secCreaterDocPope set    PCreater="+PCreater+",PCreaterManager="+PCreaterManager+",PCreaterJmanager="+PCreaterJmanager+",PCreaterDownOwner="+PCreaterDownOwner+","+                             "PCreaterSubComp="+PCreaterSubComp+",PCreaterDepart="+PCreaterDepart+",PCreaterDownOwnerLS="+PCreaterDownOwnerLS+",PCreaterSubCompLS="+PCreaterSubCompLS+","+                                "PCreaterDepartLS="+PCreaterDepartLS+",PCreaterW="+PDocCreaterW+",PCreaterManagerW="+PCreaterManagerW+",PCreaterJmanagerW="+PCreaterJmanagerW+"  where   secid="+id;        
                String strUpdateInsert ="update  secCreaterDocPope set    PCreater="+PCreater+",PCreaterManager="+PCreaterManager+",PCreaterJmanager="+PCreaterJmanager+",PCreaterDownOwner="+PCreaterDownOwner+","+                             "PCreaterSubComp="+PCreaterSubComp+",PCreaterDepart="+PCreaterDepart+",PCreaterDownOwnerLS="+PCreaterDownOwnerLS+",PCreaterSubCompLS="+PCreaterSubCompLS+","+                                "PCreaterDepartLS="+PCreaterDepartLS+",PCreaterW="+PDocCreaterW+",PCreaterManagerW="+PCreaterManagerW+",PCreaterJmanagerW="+PCreaterJmanagerW
                                        +",PCreaterDL=" + PCreaterDL + ",PCreaterManagerDL=" + PCreaterManagerDL + ",PCreaterSubCompDL=" + PCreaterSubCompDL + ",PCreaterDepartDL=" + PCreaterDepartDL + ",PCreaterWDL=" + PCreaterWDL + ",PCreaterManagerWDL=" + PCreaterManagerWDL
                                        +"  where   secid="+id;
/** =========TD12005 文档下载控制权限   结束=========*/
	            RecordSet.executeSql(strUpdateInsert); 
	            //System.out.println(strUpdateInsert);  
	        } else {
	              String strSqlInsert1  ="insert into secCreaterDocPope (secid,PCreater,PCreaterManager,PCreaterJmanager,PCreaterDownOwner,"+
	                            "PCreaterSubComp,PCreaterDepart,PCreaterDownOwnerLS,PCreaterSubCompLS,"+
	                            "PCreaterDepartLS,PCreaterW,PCreaterManagerW,PCreaterJmanagerW) values ("+newid+","+PCreater+","+PCreaterManager+","+PCreaterJmanager+","+PCreaterDownOwner+","+
	                            PCreaterSubComp+","+PCreaterDepart+","+PCreaterDownOwnerLS+","+PCreaterSubCompLS+","+
	                            PCreaterDepartLS+","+PDocCreaterW+","+PCreaterManagerW+","+PCreaterJmanagerW+")";
	        
	           
	            RecordSet.executeSql(strSqlInsert1); 
	        }         
	        //TD2858 新的需求: 添加与文档创建人相关的默认共享  结束  
		}
	}

    /*
    //add by wjy  for custom field

    String[] fieldlable = request.getParameterValues("fieldlable");
    String[] fieldid = request.getParameterValues("fieldid");
    String[] fieldhtmltype = request.getParameterValues("fieldhtmltype");
    String[] type = request.getParameterValues("type");
    String[] flength = request.getParameterValues("flength");
    String[] ismand = request.getParameterValues("ismand");
    String[] selectitemid = request.getParameterValues("selectitemid");
    String[] selectitemvalue = request.getParameterValues("selectitemvalue");

    int scopeId = secid;

   / * if(fieldlable!=null&&fieldhtmltype!=null&&type!=null&&flength!=null){
        for(int i=0; i<fieldlable.length ; i++){
            System.out.print(fieldid[i]+"\t");
            System.out.print(fieldlable[i]+"\t");
            System.out.print(fieldhtmltype[i]+"\t");
            System.out.print(type[i]+"\t");
            System.out.println(flength[i]+"\t");
        }
    }
    System.out.println("--------------------------------------");
    if(selectitemid!=null&&selectitemvalue!=null){
        for(int i=0; i<selectitemid.length ; i++){
            System.out.print(selectitemid[i]+"\t");
            System.out.println(selectitemvalue[i]+"\t");
        }
    }

    System.out.println("=======================================");* /

    CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",scopeId);
    List delFields = cfm.getAllFields2();
    FieldParam fp = new FieldParam();
    if(fieldlable!=null&&fieldid!=null&&fieldhtmltype!=null&&type!=null&&ismand!=null&&flength!=null){
        int selectIndex = 0;
        for(int i=0; i<fieldlable.length ; i++){
            if(type[i].equals("")){
                type[i] = "0";
            }
            delFields.remove(fieldid[i]);
            if(fieldhtmltype[i].equals("1")){
                fp.setSimpleText(Util.getIntValue(type[i],-1),flength[i]);
            }else if(fieldhtmltype[i].equals("2")){
                fp.setText();
            }else if(fieldhtmltype[i].equals("3")){
                fp.setBrowser(Util.getIntValue(type[i],-1));
            }else if(fieldhtmltype[i].equals("4")){
                fp.setCheck();
            }else if(fieldhtmltype[i].equals("5")){
                fp.setSelect();
            }else{
                continue;
            }
            int temId = cfm.checkField(Util.getIntValue(fieldid[i]),fieldlable[i],fp.getFielddbtype(),fp.getFieldhtmltype(),type[i],ismand[i],String.valueOf(i));
            if(fieldhtmltype[i].equals("5")&&temId != -1){
                ArrayList temItemValue = new ArrayList();
                ArrayList temItemName = new ArrayList();
                for(;selectIndex<selectitemid.length;selectIndex++){
                    if(selectitemid[selectIndex].equals("--")){
                        selectIndex++;
                        break;
                    }
                    temItemValue.add(selectitemid[selectIndex]);
                    temItemName.add(selectitemvalue[selectIndex]);
                }
                cfm.checkSelectField(temId, temItemValue, temItemName);
            }
        }
    }
    cfm.deleteFields(delFields);
    //end by wjy
    */
    
    
	//if(operation.equalsIgnoreCase("add")){
		response.sendRedirect("DocSecCategoryEdit.jsp?id="+secid+"&tab="+fromTab+"&reftree=1");
	//}else if(operation.equalsIgnoreCase("edit")){
	    //response.sendRedirect("DocSecCategoryEdit.jsp?id="+secid);
		//response.sendRedirect("DocSecCategoryBaseInfoEdit.jsp?id="+secid);
	//}
  }
  else if(operation.equalsIgnoreCase("delete")){
    int id = Util.getIntValue(request.getParameter("id"),0);
  	String categoryname=SecCategoryComInfo.getSecCategoryname(""+id);
	int subcategoryid=Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+id),0);
  	if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user) && !am.hasPermission(subcategoryid, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

	String message="";

	String checksql = "select id from docdetail where seccategory=" + id;
	RecordSet.executeSql(checksql);
	//System.out.println(checksql);
	if(RecordSet.next())
	{
		message = "87";
	}
	else
	{
		RecordSet.executeSql("SELECT * FROM WorkFlow_SelectItem WHERE docCategory LIKE '%," + id + "'");
		//System.out.println("SELECT * FROM WorkFlow_SelectItem WHERE docCategory LIKE '%," + id + "'");
		if(RecordSet.next())
		{
			message = "87";
		}
		else
		{
		    RecordSet.executeSql("SELECT * FROM WorkFlow_CreateDoc WHERE defaultView LIKE '%||" + id + "'");
		    //System.out.println("SELECT * FROM WorkFlow_CreateDoc WHERE defaultView LIKE '%||" + id + "'");
		    if(RecordSet.next())
			{
				message = "87";
			}
			else{//写作区附件上传关联文档目录
				RecordSet.executeSql("select * from CoworkAccessory where seccategory="+id);
				if(RecordSet.next()){
					message = "87";
				}
			}
			
		}
	}
	
	if(!"".equals(message))
	{

	%>
	<%--
	   <script language="javascript">
	   	window.parent.location="DocSecCategoryEdit.jsp?id=<%=id%>&message=<%=message%>";
	   </script>
	--%>
	<% 
		response.sendRedirect("DocSecCategoryEdit.jsp?id="+id+"&message="+message);
		return;
	}

    //RecordSet.executeProc("DocUserCategory_DByCategory",id+"");
    cm.deleteSecidFromSuperiorSubCategory(id);
  	RecordSet.executeProc("Doc_SecCategory_Delete",id+"");
    SecShareableCominfo.deleteDocInfoCache(""+id);
  	/* 清理权限表 */
  	am.clearPermissionOfDir(id,AclManager.CATEGORYTYPE_SEC);


    //add by wjy for custom field
    CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",id);
    cfm.delete();
    //end by wjy

	log.resetParameter();
    log.setRelatedId(id);
    log.setRelatedName(categoryname);
    log.setOperateType("3");
    log.setOperateDesc("Doc_SecCategory_Delete");
    log.setOperateItem("3");
    log.setOperateUserid(userid);
    log.setClientAddress(request.getRemoteAddr());
    log.setSysLogInfo();

    RecordSet.executeSql("delete from DocSecCatFTPConfig where secCategoryId="+id);
    
    SubCategoryComInfo.removeMainCategoryCache();
	SecCategoryComInfo.removeMainCategoryCache();
	
	response.sendRedirect("DocSubCategoryEdit.jsp?id="+subcategoryid+"&tab="+fromTab+"&reftree=1");
%>
<%-- 
   <script language="javascript">
   	window.parent.location="DocSubCategoryEdit.jsp?id=<%=subcategoryid%>&reftree=1";
   </script>
--%>
<% 
  }
%>
<!-- TD12005 文档下载权限控制   开始 -->
<%!
//根据操作权限，共享下载权限判断最终的下载权限
private int setDLValueInit(int iDLValue, int iOprateValue) {
    int iDLNewValue = 0;
    if(iOprateValue == 1) {
    	iDLNewValue = iDLValue;
    } else if(iOprateValue > 1) {
    	iDLNewValue = 1;
    }
    return iDLNewValue;
}
%>
<!-- TD12005 文档下载权限控制   结束 -->
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">