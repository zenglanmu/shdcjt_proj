<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="BudgetApproveWFHandler" class="weaver.fna.budget.BudgetApproveWFHandler" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
    boolean canImport = true;//可修改
    
    String operation = Util.null2String(request.getParameter("operation"));
    String fnabudgetinfoid = Util.null2String(request.getParameter("fnabudgetinfoid"));//ID
    String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
    String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
    String budgetperiods = Util.null2String(request.getParameter("budgetperiods"));//期间ID
    
    FileUpload fu = null;
    if(operation.equals("")){
        fu = new FileUpload(request,false);
   	    operation = Util.null2String(fu.getParameter("operation"));
		fnabudgetinfoid = Util.null2String(fu.getParameter("fnabudgetinfoid"));
		organizationid = Util.null2String(fu.getParameter("organizationid"));
		organizationtype = Util.null2String(fu.getParameter("organizationtype"));
		budgetperiods = Util.null2String(fu.getParameter("budgetperiods"));
    }
    
    String para = "";
    char separator = Util.getSeparator();
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
            Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
            Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) + " " +
            Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
            Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
            Util.add0(today.get(Calendar.SECOND), 2);
    
    String filename = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")))+"/templet2.xls";
    
    if(operation.equals("download")){
    	File templet = new File(filename);
    	if(templet.exists()){
    	    out.clear();
    	    response.setContentType("APPLICATION/OCTET-STREAM");
    	    response.setHeader("Content-Disposition", "attachment; filename="+templet.getName());

    	    DataInputStream dis = new DataInputStream(new FileInputStream(templet));
    	    OutputStream os=response.getOutputStream();
    		byte[] buf=new byte[1024];
    	    int left=(int) templet.length();
    	    int read=0;
    	    while(left>0){
    	        read=dis.read(buf);
    	        left-=read;
    	        os.write(buf,0,read);
    	    }
    	    dis.close();
    	    os.close();
    	    out.close();
    	    return;
    	} else {
    		response.sendRedirect("FnaBudgetImport.jsp?msgid=19981");
    		return;
    	}
    } else if(operation.equals("import")){
        String msg = "";
        int errorrow = 0;
        int errortab = 0;
        boolean impflag = true;
        
    	FileManage fm = new FileManage();

    	String Excelfilepath="";
     
    	int fileid = 0 ;
	    
 	    List msubject1names = new ArrayList();
 	    List msubject2names = new ArrayList();
 	    List msubject3names = new ArrayList();
 	    List mbudgetvalues = new ArrayList();

 	    List qsubject1names = new ArrayList();
 	    List qsubject2names = new ArrayList();
 	    List qsubject3names = new ArrayList();
 	    List qbudgetvalues = new ArrayList();

 	    List hsubject1names = new ArrayList();
 	    List hsubject2names = new ArrayList();
 	    List hsubject3names = new ArrayList();
 	    List hbudgetvalues = new ArrayList();
 	    
 	    List ysubject1names = new ArrayList();
 	    List ysubject2names = new ArrayList();
 	    List ysubject3names = new ArrayList();
 	    List ybudgetvalues = new ArrayList();

 	    fileid = Util.getIntValue(fu.uploadFiles("filename"),0);

       	filename = fu.getFileName();
        
       	if(filename!=null&&!"".equals(filename)&&fileid>0){

 	        String sql = "select filerealpath from imagefile where imagefileid = "+fileid;
 	        RecordSet.executeSql(sql);
 	        String uploadfilepath="";
 	        if(RecordSet.next()) uploadfilepath =  RecordSet.getString("filerealpath");
 	
 		    if(!uploadfilepath.equals("")) {
 		        Excelfilepath = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")))+"\\"+filename ;
 		        FileManage.copy(uploadfilepath,Excelfilepath);
 	        }
		    
 		    try {
 				FileInputStream finput1 = new FileInputStream(Excelfilepath);
 				POIFSFileSystem fs1 = new POIFSFileSystem(finput1);
 				HSSFWorkbook workbook1 = new HSSFWorkbook(fs1);
 				finput1.close();
 				
 				for(int q1=1;q1<5;q1++){
 				    
 				    if(!impflag) break;
 				    
	 				HSSFSheet sheet1 = workbook1.getSheetAt(q1-1);
			 		
	 				HSSFRow row = null;
	 				HSSFCell cell = null;
 				
	 				int rowsNum = sheet1.getLastRowNum();
	 				for (int i = 1; i < rowsNum + 1; i++) {
	 				    
						row = sheet1.getRow(i);
						
						String tmpsubject1 = "";
						String tmpsubject2 = "";
						String tmpsubject3 = "";

						String[] tmpbudget = null;
						if(q1==1) tmpbudget = new String[]{"","","","","","","","","","","",""};
						if(q1==2) tmpbudget = new String[]{"","","",""};
						if(q1==3) tmpbudget = new String[]{"",""};
						if(q1==4) tmpbudget = new String[]{""};
						
 					    cell = row.getCell((short)0);
						tmpsubject1 = getCellValue(cell);
						if(tmpsubject1!=null&&!"".equals(tmpsubject1)){
						    RecordSet.executeSql(" select id from FnaBudgetfeeType where id = '" + tmpsubject1 + "' and feelevel = 1 and feeperiod = " + q1);
						    if(RecordSet.next()){
						        tmpsubject1 = Util.null2String(RecordSet.getString(1));
						    } else {
						        msg = "19983";
	 				            errorrow = i;
	 				            errortab = q1;
	 	 				        impflag = false;
	 	 				        break;
						    }
						} else {
						    msg = "20213";
 				            errorrow = i;
 				            errortab = q1;
 	 				        impflag = false;
 	 				        break;
						}
						
 					    cell = row.getCell((short)2);
						tmpsubject2 = getCellValue(cell);
						if(tmpsubject2!=null&&!"".equals(tmpsubject2)){
						    RecordSet.executeSql(" select id from FnaBudgetfeeType where id = '" + tmpsubject2 + "' and feelevel = 2 and supsubject = " + tmpsubject1);
						    if(RecordSet.next()){
						        tmpsubject2 = Util.null2String(RecordSet.getString(1));
						    } else {
						        msg = "19983";
	 				            errorrow = i;
	 				            errortab = q1;
	 	 				        impflag = false;
	 	 				        break;
						    }
						} else {
						    msg = "20213";
 				            errorrow = i;
 				            errortab = q1;
 	 				        impflag = false;
 	 				        break;
						}
						
 					    cell = row.getCell((short)4);
						tmpsubject3 = getCellValue(cell);
						if(tmpsubject3!=null&&!"".equals(tmpsubject3)){
						    RecordSet.executeSql(" select id from FnaBudgetfeeType where id = '" + tmpsubject3 + "' and feelevel = 3 and supsubject = " + tmpsubject2);
						    if(RecordSet.next()){
						        tmpsubject3 = Util.null2String(RecordSet.getString(1));
						    } else {
						        msg = "19983";
	 				            errorrow = i;
	 				            errortab = q1;
	 	 				        impflag = false;
	 	 				        break;
						    }
						} else {
						    msg = "20213";
 				            errorrow = i;
 				            errortab = q1;
 	 				        impflag = false;
 	 				        break;
						}
						
						for(int q2=0;tmpbudget!=null&&q2<tmpbudget.length;q2++){
						    cell = row.getCell((new Short((6+q2)+"")).shortValue());
						    String tmpbudgetstr = Util.null2String(getCellValue(cell));
						    tmpbudget[q2] = tmpbudgetstr;
						}

	 				    if(tmpsubject3!=null&&!"".equals(tmpsubject3)){
	 				        int tmpcount = 0;
							for(int q2=0;tmpbudget!=null&&q2<tmpbudget.length;q2++){
	 				        	if(!tmpbudget[q2].equals("")) tmpcount++;
							}
	 				        if(tmpcount>0){
								if(q1==1){
		 					 	    msubject1names.add(tmpsubject1);
		 					 	    msubject2names.add(tmpsubject2);
		 					 	    msubject3names.add(tmpsubject3);
		 					 	    mbudgetvalues.add(tmpbudget);
								} else if(q1==2){
							 	    qsubject1names.add(tmpsubject1);
							 	    qsubject2names.add(tmpsubject2);
							 	    qsubject3names.add(tmpsubject3);
							 	    qbudgetvalues.add(tmpbudget);
								} else if(q1==3){
							 	    hsubject1names.add(tmpsubject1);
							 	    hsubject2names.add(tmpsubject2);
							 	    hsubject3names.add(tmpsubject3);
							 	    hbudgetvalues.add(tmpbudget);
								} else if(q1==4){
							 	    ysubject1names.add(tmpsubject1);
							 	    ysubject2names.add(tmpsubject2);
							 	    ysubject3names.add(tmpsubject3);
							 	    ybudgetvalues.add(tmpbudget);
								}
	 				        }
	 				    } else {
						    msg = "20213";
 				            errorrow = i;
 				            errortab = q1;
 	 				        impflag = false;
 	 				        break;
	 				    }
	 				}
 				}
 		    } catch(Exception e){
 	            impflag = false;
 	            msg = "20040";
 		    }
         } else {
             impflag = false;
             msg = "20041";
         }
		
 		if(impflag&&((msubject1names!=null&&msubject1names.size()>0)||(qsubject1names!=null&&qsubject1names.size()>0)||(hsubject1names!=null&&hsubject1names.size()>0)||(ysubject1names!=null&&ysubject1names.size()>0))){
            String status = "0";
            String budgetstatus = "0";
            String revision = "0";
            //如果已有草稿，则查找删除
            RecordSet.executeSql(" select id from FnaBudgetInfo where "
                           + " budgetorganizationid = " + organizationid
                           + " and organizationtype = " + organizationtype
                           + " and budgetperiods = " + budgetperiods
                           + " and status = 0 ");
            while(RecordSet.next()) {
                String existfnabudgetinfoid = RecordSet.getString(1);
                RecordSet2.executeSql("delete from FnaBudgetInfoDetail where budgetinfoid = " + existfnabudgetinfoid);
                RecordSet2.executeSql("delete from FnaBudgetInfo where id = " + existfnabudgetinfoid);
            }
            
            para = budgetperiods + separator
                    + organizationid + separator
                    + organizationtype + separator
                    + budgetstatus + separator
                    + user.getUID() + separator
                    + Util.fromScreen(currentdate, user.getLanguage()) + separator
                    + revision + separator
                    + status;
            RecordSet.executeProc("FnaBudgetInfo_Insert", para);
            
            if (RecordSet.next()) {
                
                fnabudgetinfoid = RecordSet.getString(1);
	 		    
	            for (int j = 0; j < msubject3names.size(); j++) {
	                
	                String[] budgetvalues = (String[]) mbudgetvalues.get(j);
	                String budgettypeid = msubject3names.get(j).toString();
	                
	                for(int jj = 0;budgetvalues!=null && budgetvalues.length>0 && jj < budgetvalues.length;jj++){
		                para = fnabudgetinfoid + separator
		                        + budgetperiods + separator
		                        + (jj+1) + separator
		                        + budgettypeid + separator
		                        + "" + separator
		                        + "" + separator
		                        + "" + separator
		                        + budgetvalues[jj] + separator
		                        + "";
		
		                if (budgetvalues[jj]!=null&&!"".equals(budgetvalues[jj])&&Util.getDoubleValue(budgetvalues[jj]) > 0d)
		                    RecordSet2.executeProc("FnaBudgetInfoDetail_Insert", para);
	                }
	            }
	            
	            for (int j = 0; j < qsubject3names.size(); j++) {
	                
	                String[] budgetvalues = (String[]) qbudgetvalues.get(j);
	                String budgettypeid = qsubject3names.get(j).toString();
	                
	                for(int jj = 0;budgetvalues!=null && budgetvalues.length>0 && jj < budgetvalues.length;jj++){
		                para = fnabudgetinfoid + separator
		                        + budgetperiods + separator
		                        + (jj+1) + separator
		                        + budgettypeid + separator
		                        + "" + separator
		                        + "" + separator
		                        + "" + separator
		                        + budgetvalues[jj] + separator
		                        + "";
		
	                    if (budgetvalues[jj]!=null&&!"".equals(budgetvalues[jj])&&Util.getDoubleValue(budgetvalues[jj]) > 0d)		                    
		                    RecordSet2.executeProc("FnaBudgetInfoDetail_Insert", para);
	                }
	            }
	            
	            for (int j = 0; j < hsubject3names.size(); j++) {
	                
	                String[] budgetvalues = (String[]) hbudgetvalues.get(j);
	                String budgettypeid = hsubject3names.get(j).toString();
	                
	                for(int jj = 0;budgetvalues!=null && budgetvalues.length>0 && jj < budgetvalues.length;jj++){
		                para = fnabudgetinfoid + separator
		                        + budgetperiods + separator
		                        + (jj+1) + separator
		                        + budgettypeid + separator
		                        + "" + separator
		                        + "" + separator
		                        + "" + separator
		                        + budgetvalues[jj] + separator
		                        + "";
		
	                    if (budgetvalues[jj]!=null&&!"".equals(budgetvalues[jj])&&Util.getDoubleValue(budgetvalues[jj]) > 0d)		                    
		                    RecordSet2.executeProc("FnaBudgetInfoDetail_Insert", para);
	                }
	            }
	
	            for (int j = 0; j < ysubject3names.size(); j++) {
	                
	                String[] budgetvalues = (String[]) ybudgetvalues.get(j);
	                String budgettypeid = ysubject3names.get(j).toString();
	                
	                for(int jj = 0;budgetvalues!=null && budgetvalues.length>0 && jj < budgetvalues.length;jj++){
		                para = fnabudgetinfoid + separator
		                        + budgetperiods + separator
		                        + (jj+1) + separator
		                        + budgettypeid + separator
		                        + "" + separator
		                        + "" + separator
		                        + "" + separator
		                        + budgetvalues[jj] + separator
		                        + "";
		
	                    if (budgetvalues[jj]!=null&&!"".equals(budgetvalues[jj])&&Util.getDoubleValue(budgetvalues[jj]) > 0d)		                    
		                    RecordSet2.executeProc("FnaBudgetInfoDetail_Insert", para);
	                }
	            }
            }
 		} else {
 		    response.sendRedirect("FnaBudgetImport.jsp?msgid="+msg+(errorrow>0?"&row="+errorrow:"")+(errortab>0?"&tab="+errortab:"")+"&fnabudgetinfoid="+fnabudgetinfoid);
 		    return;
 		}
       	response.sendRedirect("FnaBudgetView.jsp?fnabudgetinfoid="+fnabudgetinfoid);
       	return;
    }
%>
<%!
private String getCellValue(HSSFCell cell){
    String result = "";
    try {
	    if(cell.getCellType()==1){
	        result = cell.getStringCellValue();
	    } else if(cell.getCellType()==0){
	        java.text.DecimalFormat format = new java.text.DecimalFormat("########################.##");
	        result = format.format((new Double(cell.getNumericCellValue())).doubleValue());
	    } else if(cell.getCellType()==3){
	        result = "";
	    }
    } catch(Exception e){
        result = "";
    }
    return result;
}
%>
<%    
    String msgid = Util.null2String(request.getParameter("msgid"));
    int rowid = Util.getIntValue(Util.null2o(request.getParameter("row")));
    int tabid = Util.getIntValue(Util.null2o(request.getParameter("tab")));

    if ("".equals(fnabudgetinfoid)) {
        canImport = false;
    }
    
    String budgetyears = "";//期间年

    String sqlstr = "";

	//取数据
    if (fnabudgetinfoid != null && !"".equals(fnabudgetinfoid)) {
        sqlstr = " select budgetperiods,budgetorganizationid,organizationtype,revision,status,budgetstatus from FnaBudgetInfo where id = " + fnabudgetinfoid;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetperiods = RecordSet.getString("budgetperiods");
            organizationid = RecordSet.getString("budgetorganizationid");
            organizationtype = RecordSet.getString("organizationtype");
        } else {
            canImport = false;
        }
    } else {//如果期间为空,则不允许修改
        canImport = false;
    }

	//检查权限
    int right = -1;//-1：禁止、0：只读、1：编辑、2：完全操作
    if ("0".equals(organizationtype)) {
        if (HrmUserVarify.checkUserRight("HeadBudget:Maint", user))
        	right = Util.getIntValue(HrmUserVarify.getRightLevel("HeadBudget:Maint", user),0);
    } else {
        if (Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0) == 1) {//如果分权
            int subCompanyId = 0;
            if("1".equals(organizationtype))
                subCompanyId = (new Integer(organizationid)).intValue();
            else if("2".equals(organizationtype))
                subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(organizationid))).intValue();
            else if("3".equals(organizationtype))
                 subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(organizationid)))).intValue();
            right = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "SubBudget:Maint",subCompanyId);
        } else {
            if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
                right = Util.getIntValue(HrmUserVarify.getRightLevel("SubBudget:Maint", user),0);
        }
    }

    if (right < 1) canImport = false;//不可编辑

    if (!canImport) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

	//取当前期间的年份
    if ("".equals(budgetyears)) {
        sqlstr = " select fnayear from FnaYearsPeriods where id = " + budgetperiods;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetyears = RecordSet.getString("fnayear");
        }
    }
	
    String imagefilename = "/images/hdReport.gif";
    String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
    
    
    if(operation.equals("")){
    
		List subjectid = new ArrayList();
		List subjectname = new ArrayList();
		List subjectlevel = new ArrayList();
		List subjectsup = new ArrayList();
		List subjectfeeperiod = new ArrayList();
	
		RecordSet.executeSql(" select id,name,feelevel,supsubject,feeperiod from FnaBudgetfeeType order by feelevel,name ");
	    while (RecordSet.next()) {
	        subjectid.add(Util.null2String(RecordSet.getString("id")));
	        subjectname.add(Util.null2String(RecordSet.getString("name")));
	        subjectlevel.add(Util.null2String(RecordSet.getString("feelevel")));
	        subjectsup.add(Util.null2String(RecordSet.getString("supsubject")));
	        subjectfeeperiod.add(Util.null2String(RecordSet.getString("feeperiod")));
	    }
	    
	
		File templet = new File(filename);
		if(templet.exists()){
		    templet.deleteOnExit();
		}
		FileOutputStream fileOut = new FileOutputStream(templet);   
		
		HSSFWorkbook workbook1 = new HSSFWorkbook();
		
		for(int q1=1;q1<5;q1++){
		    
		    boolean readonly = false;
		    boolean mainall = false;
	
		    List subject1id = new ArrayList();
		    List subject1name = new ArrayList();
		    List subject1rowcount = new ArrayList();
	
		    List subject2id = new ArrayList();
		    List subject2name = new ArrayList();
		    List subject2sup = new ArrayList();
		    List subject2rowcount = new ArrayList();
	
		    List subject3id = new ArrayList();
		    List subject3name = new ArrayList();
		    List subject3sup = new ArrayList();
	
		    String sup1idstr = "";
		    for(int i=0;i<subjectid.size();i++) {
		        String tid = subjectid.get(i).toString();
		        String tname = subjectname.get(i).toString();
		        String tlevel = subjectlevel.get(i).toString();
		        String tsup = subjectsup.get(i).toString();
		        String tfeeperiod = subjectfeeperiod.get(i).toString();
		    	if(tlevel.equals("1")){
		            if(tfeeperiod.equals(""+q1)){
		        	    subject1id.add(tid);
		    		    subject1name.add(tname);
		    		    subject1rowcount.add("0");
		    		    sup1idstr += ","+tid;
		            }
		    	}
		    }
		    sup1idstr += ",";
	
		    String sup2idstr = "";
		    for(int i=0;i<subjectid.size();i++) {
		        String tid = subjectid.get(i).toString();
		        String tname = subjectname.get(i).toString();
		        String tlevel = subjectlevel.get(i).toString();
		        String tsup = subjectsup.get(i).toString();
		        String tfeeperiod = subjectfeeperiod.get(i).toString();
		    	if(tlevel.equals("2")){
		            if(sup1idstr.indexOf(","+tsup+",")>-1){
		        	    subject2id.add(tid);
		        		subject2name.add(tname);
		        		subject2sup.add(tsup);
		        	    subject2rowcount.add("0");
		        		sup2idstr += ","+tid;
		            }
		    	}
		    }
		    sup2idstr += ",";
		    	
		    for(int i=0;i<subjectid.size();i++) {
		        String tid = subjectid.get(i).toString();
		        String tname = subjectname.get(i).toString();
		        String tlevel = subjectlevel.get(i).toString();
		        String tsup = subjectsup.get(i).toString();
		        String tfeeperiod = subjectfeeperiod.get(i).toString();
		    	if(tlevel.equals("3")){
		            if(sup2idstr.indexOf(","+tsup+",")>-1){
		        	    subject3id.add(tid);
		        		subject3name.add(tname);
		        		subject3sup.add(tsup);
		            }
		    	}
		    }
	
		    for(int l1=0;l1<subject1id.size();l1++) {
		        int count1 = 0;
		        for(int l2=0;l2<subject2id.size();l2++) {
		            int count2 = 0;
		            if(subject2sup.get(l2).toString().equals(subject1id.get(l1).toString())){
		                for(int l3=0;l3<subject3id.size();l3++) {
		                    if(subject3sup.get(l3).toString().equals(subject2id.get(l2).toString()))
		                        count2++;
		                }
		                subject2rowcount.set(l2,count2+"");
		                count1+=count2;
		            }
		        }
		        subject1rowcount.set(l1,count1+"");
		    }    
		    
		    
			HSSFSheet sheet1 = workbook1.createSheet();
			String sheetname = "";
			if(q1==1) sheetname = "月度预算";
			else if(q1==2) sheetname = "季度预算";
			else if(q1==3) sheetname = "半年预算";
			else if(q1==4) sheetname = "年度预算";
			workbook1.setSheetName(q1-1,sheetname,HSSFWorkbook.ENCODING_UTF_16);
			
			HSSFRow row = null;
			HSSFCell cell = null;
			
			row = sheet1.createRow(0);
			
			cell = row.createCell((short)0);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("一级科目ID");

			cell = row.createCell((short)1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("一级科目");
			
			cell = row.createCell((short)2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("二级科目ID");
			
			cell = row.createCell((short)3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("二级科目");

			cell = row.createCell((short)4);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("三级科目ID");
			
			cell = row.createCell((short)5);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("三级科目");

			int qcount = 0;
			if(q1==1) qcount = 13;
			else if(q1==2) qcount = 5;
			else if(q1==3) qcount = 3;
			else if(q1==4) qcount = 1;
			
			
			for(int q2=1;q2<=qcount;q2++){
			    if(q2<qcount){
					cell = row.createCell((new Short((5+q2)+"")).shortValue());
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(q2+"期");
			    } else {
					cell = row.createCell((new Short((5+q2)+"")).shortValue());
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue("全年");
			    }
			}
				
			
			int rowi = 0;
			for(int l1=0;l1<subject1id.size();l1++) {
			    String firestlevelid = subject1id.get(l1).toString();
			    String firestlevelname = subject1name.get(l1).toString();
			    String firestlevelrowcount = subject1rowcount.get(l1).toString();
			    
			    for(int l2=0;l2<subject2id.size();l2++) {
			        String secondlevelid = subject2id.get(l2).toString();
			        String secondlevelname = subject2name.get(l2).toString();
			        String secondlevelsup = subject2sup.get(l2).toString();
			        String secondlevelrowcount = subject2rowcount.get(l2).toString();
			        if(!secondlevelsup.equals(firestlevelid)) continue;
			
			        for(int l3=0;l3<subject3id.size();l3++) {
			            String thirdlevelid = subject3id.get(l3).toString();
			            String thirdlevelname = subject3name.get(l3).toString();
			            String thirdlevelsup = subject3sup.get(l3).toString();
			            if(!thirdlevelsup.equals(secondlevelid)) continue;
			
			            rowi++;
			        	row = sheet1.createRow(rowi);
			        	
			        	cell = row.createCell((short)0);
			        	cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			        	cell.setCellValue(firestlevelid);
			        	
			        	cell = row.createCell((short)1);
			        	cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			        	cell.setCellValue(firestlevelname);

			        	cell = row.createCell((short)2);
			        	cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			        	cell.setCellValue(secondlevelid);
			        	
			        	cell = row.createCell((short)3);
			        	cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			        	cell.setCellValue(secondlevelname);

			        	cell = row.createCell((short)4);
			        	cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			        	cell.setCellValue(thirdlevelid);
			        	
			        	cell = row.createCell((short)5);
			        	cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			        	cell.setCellValue(thirdlevelname);

			        	Map currentBudgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,thirdlevelid);
			        	
			        	double tmpcount = 0d;
			        	double tmpsum = 0d;
			        	for(int q2=1;q2<=qcount;q2++){
						    tmpcount = Util.getDoubleValue(Util.null2o((String)currentBudgetTypeAmount.get(""+q2)));
						    tmpsum+=tmpcount;
						    if(q2<qcount){
								cell = row.createCell((new Short((5+q2)+"")).shortValue());
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);
								cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
								cell.setCellValue(tmpcount);
								//cell.setCellValue(FnaBudgetInfoComInfo.getStrFromDouble(tmpcount,false,true));
						    } else {
								cell = row.createCell((new Short((5+q2)+"")).shortValue());
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);
								cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
								cell.setCellValue(tmpsum);
								//cell.setCellValue(FnaBudgetInfoComInfo.getStrFromDouble(tmpsum,false,true));
			        		}
			    		}
					}
				}
			}
		}
		
		workbook1.write(fileOut);
		
		fileOut.close();
		
		response.sendRedirect("FnaBudgetImport.jsp?msgid="+msgid+"&operation=upload&fnabudgetinfoid="+fnabudgetinfoid+"&row="+rowid+"&tab="+tabid);
		return;
    }
%>
<HTML><HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <style>
        #tabPane tr td {
            padding-top: 2px
        }

        #monthHtmlTbl td, #seasonHtmlTbl td {
            cursor: hand;
            text-align: center;
            padding: 0 2px 0 2px;
            color: #333;
            text-decoration: underline
        }

        .cycleTD {
            background-image: url( /images/tab2.png );
            cursor: hand;
            font-weight: bold;
            text-align: center;
            color: #666;
            border-bottom: 1px solid #879293;
        }

        .cycleTDCurrent {
            padding-top: 2px;
            background-image: url( /images/tab.active2.png );
            cursor: hand;
            font-weight: bold;
            text-align: center;
            color: #666
        }

        .seasonTDCurrent, .monthTDCurrent {
            color: black;
            font-weight: bold;
            background-color: #CCC
        }

        #subTab {
            border-bottom: 1px solid #879293;
            padding: 0
        }

        #goalGroupStatus {
            text-align: center;
            color: black;
            font-weight: bold
        }
    </style>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(1402, user.getLanguage()) + ",javascript:onNext(this),_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
    <td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
     
<span id="errormsg" style="color:red"></span>

<FORM id="frmMain" name="frmMain" action="FnaBudgetImport.jsp" enctype="multipart/form-data" method=post>
<input type="hidden" name="operation" value="import">
<INPUT name="fnabudgetinfoid" type="hidden" value="<%=fnabudgetinfoid%>">


<!--表头 开始-->

<TABLE class="ViewForm">
<TBODY>
<colgroup>
<col width="16%">
<col width="*">
<TR>
    <TH class=Title colspan=2>
        <%
            String fnatitle = "<font size=\"3\">";
            if ("0".equals(organizationtype))
                fnatitle += (Util.toScreen(CompanyComInfo.getCompanyname(organizationid), user.getLanguage()));
            if ("1".equals(organizationtype))
                fnatitle += (Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid), user.getLanguage()));
            if ("2".equals(organizationtype))
                fnatitle += (Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage()));
            if ("3".equals(organizationtype))
                fnatitle += (Util.toScreen(ResourceComInfo.getResourcename(organizationid), user.getLanguage()));
            fnatitle += budgetyears;
            fnatitle += SystemEnv.getHtmlLabelName(15375, user.getLanguage());
            fnatitle += "</font>";
            out.println(fnatitle);
        %>
    </TH>
</TR>

<TR class=Spacing>
    <TD class=Sep1 colSpan=2></TD>
</TR>

<TR><TD class=Line colSpan=2></TD></TR>

<tr>
    <td colSpan=2><%=SystemEnv.getHtmlLabelName(20211,user.getLanguage())%><%if(!msgid.equals("")){ %><br><font color=red><%=SystemEnv.getHtmlLabelName(Util.getIntValue(msgid),user.getLanguage())%>(Sheet<%=tabid%><%=SystemEnv.getHtmlLabelName(18620,user.getLanguage())%><%=rowid%>)</font><%} %></td>
    </td>
</tr>


<TR><TD class=Line colSpan=2></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(16455, user.getLanguage())%></td>
    <td class=Field>
        <%
            if ("0".equals(organizationtype))
                out.print(Util.toScreen(CompanyComInfo.getCompanyname(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(140, user.getLanguage()) + ")</b>");
            if ("1".equals(organizationtype))
                out.print(Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(24049, user.getLanguage()) + ")</b>");
            if ("2".equals(organizationtype))
                out.print(Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(124, user.getLanguage()) + ")</b>");
            if ("3".equals(organizationtype))
                out.print(Util.toScreen(ResourceComInfo.getResourcename(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(1867, user.getLanguage()) + ")</b>");
        %>
        <input type="hidden" name="organizationid" value="<%=organizationid%>">
        <input type="hidden" name="organizationtype" value="<%=organizationtype%>">
    </td>
</tr>

<TR><TD class=Line colSpan=2></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(15365, user.getLanguage())%></td>
    <td class=Field><%=budgetyears%>
        <input type="hidden" name="budgetperiods" value="<%=budgetperiods%>">
    </td>
</tr>

<TR><TD class=Line colSpan=2></TD></TR>


<tr>
	<td><%=SystemEnv.getHtmlLabelName(19971,user.getLanguage())%></td>
	<td class=Field>
		<a href="#" onclick="onDown()"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a>
	</td>
</tr>

<TR><TD class=Line colSpan=2></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(18577, user.getLanguage())%></td>
    <td class=Field>
        <% // Todo Excel文件导入
        %>
        <input class=InputStyle type=file size=50 name="filename" id="filename"/>
    </td>
</tr>

<TR><TD class=Line colSpan=2></TD></TR>
<TR><TD colSpan=5 height=2></TD></TR>
</TBODY>
</TABLE>

	<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(18617,user.getLanguage())%><br>
	<font color=red><%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%>ID</font>：<%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%>ID<br>
	<font color=red><%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%></font>：<%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%><br>
	<font color=red><%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%>ID</font>：<%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%>ID<br>
	<font color=red><%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%></font>：<%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%><br>
	<font color=red><%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%>ID</font>：<%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%>ID<br>
	<font color=red><%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%></font>：<%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%><br>
	N<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>N<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%><br>
	<%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1823,user.getLanguage())%><br>


</FORM>

</td></tr>
<tr><td colspan="5">&nbsp;</td></tr>
<tr><td colspan="5">&nbsp;</td></tr>
</table>

</td>
</tr>
</TABLE>

</td>
<td></td>
</tr>
<tr>
    <td height="5" colspan="3"></td>
</tr>
</table>




<iframe id="dwnfrm" name="dwnfrm" src="" style="display:none"></iframe>
<script language=javascript>
var oPopup = window.createPopup();

function showWait(content){
    var iX = document.body.offsetWidth/2-50;
	var iY = document.body.offsetHeight/2+document.body.scrollTop-50; 
	var oPopBody = oPopup.document.body;
    oPopBody.style.border = "1px solid #8888AA";
    oPopBody.style.backgroundColor = "white";
    oPopBody.style.position = "absolute";
    oPopBody.style.padding = "5px";
    oPopBody.style.zindex = 150;
    oPopBody.innerHTML = content;
    oPopup.show(iX, iY, 170, 25, document.body);
    var dialogScript = 'window.setTimeout(' + ' function () { window.close(); }, '+1+');';
    var result = window.showModalDialog('javascript:document.writeln(' + '"<script>' + dialogScript + '<' + '/script>")'); 
}

function hideWait(){
	oPopup.hide();
}

function onNext(obj) {
    document.frmMain.action = "FnaBudgetImport.jsp";
    document.frmMain.operation.value = "import";
    document.frmMain.submit();
    obj.disabled=true;
}

function onDown(){
	document.getElementById("dwnfrm").src="FnaBudgetImport.jsp?operation=download";
}

function ResumeError() {
    return true;
}
window.onerror = ResumeError;

</script>

<script language=vbs>
sub showDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		frmMain.documentid.value=id(0)&""
		documentspan.innerHtml = "<a href=""javaScript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="&id(0)&"')"">"&id(1)&"</a>"	
	end if
end sub
</script>

</BODY>
</HTML>