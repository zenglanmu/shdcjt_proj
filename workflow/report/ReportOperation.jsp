<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<%
 if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("reportadd"))
{
    String reportName = Util.fromScreen(request.getParameter("reportname"), user.getLanguage());
    String reportType = "" + Util.getIntValue(request.getParameter("reportType"), 0);
     int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"),0);
    String isBill = "" + Util.getIntValue(request.getParameter("isBill"), 0);
    String formID = "" + Util.getIntValue(request.getParameter("formID"), 0);
    String workFlowID = request.getParameter("workflowID");
     	if(workFlowID.equals("0")){	
		RecordSet.executeSql("SELECT * FROM WorkFlow_Base WHERE formID = " + formID + " AND isBill = '" + isBill + "' AND isValid = '1'");
		workFlowID="";
		while(RecordSet.next()){
			workFlowID+=RecordSet.getString("ID")+",";
		}
	}
	String isShowOnReportOutput = Util.null2String(request.getParameter("isShowOnReportOutput"));
	RecordSet.execute("INSERT INTO Workflow_Report(reportName, reportType, reportWFID, formID, isBill, isShowOnReportOutput,subCompanyId) VALUES ('" + reportName + "', " + reportType + ", '" + workFlowID + "', " + formID + ", '" + isBill + "', '" + isShowOnReportOutput + "',"+subcompanyid+")");

    ReportComInfo.removeReportTypeCache() ;
    RecordSet.executeSql("select max(id) as id from Workflow_Report");
    RecordSet.next();
    String reportid = RecordSet.getString("id");
    
    int fieldcount = 0;//统计字段数目
	//requestname
	fieldcount++;
	String fieldid = "-1";
    String dsporder = ""+fieldcount;
    String isstat = "0";
    String dborder = "0";
    String dbordertype = "n";
    String compositororder = "0";
    String para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder;
    RecordSet.executeProc("Workflow_ReportDspField_Insert",para);
    
    //requestlevel
    fieldcount++;
	fieldid = "-2";
    dsporder = ""+fieldcount;
    isstat = "0";
    dborder = "0";
    dbordertype = "n";
    compositororder = "0";
    para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder;
    RecordSet.executeProc("Workflow_ReportDspField_Insert",para);
    
	String sql="";
	if(isBill.equals("0")){
	  /*
	  1、workflow_formdict,workflow_formdictdetail 两张表的分开，是极糟糕的设计！使得必须使用union操作；
	  2、由于workflow_formfield.fieldorder 字段针对头和明细分别记录顺序，使得在union之后对fieldorder使用order by 失去意义；
	  3、针对问题2，对 workflow_formfield.fieldorder 作 +100 的操作，以便union后排序，100能够满足绝对多数单据对头字段的要求；
	  4、检索字段实际存储类型，屏蔽不能排序字段的排序操作；
	  5、添加(明细)标记时要区分sql与oracle的操作差异
	  */
		StringBuffer sqlSB = new StringBuffer();
		sqlSB.append("  select workflow_formfield.fieldid      as id,                                         \n");
		sqlSB.append("         fieldname                       as name,                                       \n");
		sqlSB.append("         workflow_fieldlable.fieldlable  as label,                                      \n");
		sqlSB.append("         workflow_formfield.fieldorder as fieldorder,                                   \n");
		sqlSB.append("         workflow_formdict.fielddbtype   as dbtype,                                     \n");
		sqlSB.append("         workflow_formdict.fieldhtmltype as httype,                                     \n");
		sqlSB.append("         workflow_formdict.type as type                                                 \n");
		sqlSB.append("    from workflow_formfield, workflow_formdict, workflow_fieldlable                     \n");
		sqlSB.append("   where workflow_fieldlable.formid = workflow_formfield.formid                         \n");
		sqlSB.append("     and workflow_fieldlable.isdefault = 1                                              \n");
		sqlSB.append("     and workflow_fieldlable.fieldid = workflow_formfield.fieldid                       \n");
		sqlSB.append("     and workflow_formdict.id = workflow_formfield.fieldid                              \n");
		sqlSB.append("     and workflow_formfield.formid = " + formID + "                                     \n");
		sqlSB.append("     and (workflow_formfield.isdetail <> '1' or workflow_formfield.isdetail is null)    \n");
		sqlSB.append("  Order by workflow_formfield.fieldorder                                                \n");
	    sql = sqlSB.toString();
	}else if(isBill.equals("1")){
		StringBuffer sqlSB = new StringBuffer();
		sqlSB.append("  select * from                                                     \n");
		sqlSB.append("   (select wfbf.id            as id,                                \n");
		sqlSB.append("           wfbf.fieldname     as name,                              \n");
		sqlSB.append("           wfbf.fieldlabel    as label,                             \n");
		sqlSB.append("           wfbf.fielddbtype   as dbtype,                            \n");
		sqlSB.append("           wfbf.fieldhtmltype as httype,                            \n");
		sqlSB.append("           wfbf.type          as type,                              \n");
		sqlSB.append("           wfbf.dsporder      as dsporder,                          \n");
		sqlSB.append("           wfbf.viewtype      as viewtype,                          \n");
		sqlSB.append("           wfbf.detailtable   as detailtable                        \n");
		sqlSB.append("      from workflow_billfield wfbf                                  \n");
		sqlSB.append("     where wfbf.billid = " + formID + " AND wfbf.viewtype = 0       \n");
		sqlSB.append("    Union                                                           \n");
		sqlSB.append("    select wfbf.id            as id,                                \n");
		sqlSB.append("           wfbf.fieldname     as name,                              \n");
		sqlSB.append("           wfbf.fieldlabel    as label,                             \n");
		sqlSB.append("           wfbf.fielddbtype   as dbtype,                            \n");
		sqlSB.append("           wfbf.fieldhtmltype as httype,                            \n");
		sqlSB.append("           wfbf.type          as type,                              \n");
		sqlSB.append("  	       wfbf.dsporder+100  as dsporder,                        \n");
		sqlSB.append("  	       wfbf.viewtype      as viewtype,                        \n");
		sqlSB.append("           wfbf.detailtable   as detailtable                        \n");
		sqlSB.append("  	  from workflow_billfield wfbf                                \n");
		sqlSB.append("  	 where wfbf.billid = " + formID + " AND wfbf.viewtype = 1) a  \n");
		sqlSB.append("  order by a.viewType, a.detailtable, a.dsporder                    \n");
		sql = sqlSB.toString();
	}
	rs.executeSql(sql);
	while(rs.next()){
		fieldcount++;
		fieldid = rs.getString("id"); 
	    dsporder = ""+fieldcount;
	    isstat = "0";
	    dborder = "0";
	    dbordertype = "n";
	    compositororder = "0";
	    para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder;
	    RecordSet.executeProc("Workflow_ReportDspField_Insert",para);
	}
	
	//老表单的明细单独处理
	if(isBill.equals("0")){
		StringBuffer sqlSB = new StringBuffer();
		sqlSB.append("  select workflow_formfield.fieldid as id,                                                 \n");
		sqlSB.append("         fieldname as name,                                                                \n");
		if(rs.getDBType().equals("oracle")){
			sqlSB.append("         concat(workflow_fieldlable.fieldlable,' (明细)') as label,                    \n");
		}else if(rs.getDBType().equals("db2")){
			sqlSB.append("         concat(workflow_fieldlable.fieldlable,' (明细)') as label,                    \n");
		}else{
			sqlSB.append("         workflow_fieldlable.fieldlable + ' (明细)' as label,                          \n");
		}
		sqlSB.append("         workflow_formfield.fieldorder + 100 as fieldorder,                                \n");
		sqlSB.append("         workflow_formdictdetail.fielddbtype as dbtype,                                    \n");
		sqlSB.append("         workflow_formdictdetail.fieldhtmltype as httype,                                  \n");
		sqlSB.append("         workflow_formdictdetail.type as type                                              \n");
		sqlSB.append("    from workflow_formfield, workflow_formdictdetail, workflow_fieldlable                  \n");
		sqlSB.append("   where workflow_fieldlable.formid = workflow_formfield.formid                            \n");
		sqlSB.append("     and workflow_fieldlable.isdefault = 1                                                 \n");
		sqlSB.append("     and workflow_fieldlable.fieldid = workflow_formfield.fieldid                          \n");
		sqlSB.append("     and workflow_formdictdetail.id = workflow_formfield.fieldid                           \n");
		sqlSB.append("     and workflow_formfield.formid = " + formID + "                                        \n");
		sqlSB.append("     and (workflow_formfield.isdetail = '1' or workflow_formfield.isdetail is not null)    \n");
		sqlSB.append("   order by groupid, fieldorder                                                            \n");
		sql = sqlSB.toString();
		rs.executeSql(sql);
		
		while(rs.next()){
			fieldcount++;
			fieldid = rs.getString("id"); 
		    dsporder = ""+fieldcount;
		    isstat = "0";
		    dborder = "0";
		    dbordertype = "n";
		    compositororder = "0";
		    para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder;
		    RecordSet.executeProc("Workflow_ReportDspField_Insert",para);
		}
	}
	response.sendRedirect("ReportEdit.jsp?id="+reportid);
}
else if(operation.equals("reportedit"))
{
  	int ID = Util.getIntValue(request.getParameter("id"));
	String reportName = "" + Util.null2String(request.getParameter("reportName"));
	String reportType = "" + Util.getIntValue(request.getParameter("reportType"), 0);
	String isShowOnReportOutput = "" + Util.null2String(request.getParameter("isShowOnReportOutput"));
	int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"),0);
	RecordSet.execute("UPDATE Workflow_Report SET reportName = '" + reportName + "', reportType = " + reportType + ",isShowOnReportOutput = '" + isShowOnReportOutput + "' ,subcompanyid="+subcompanyid+" WHERE ID = " + ID);
	ReportComInfo.removeReportTypeCache();
 	response.sendRedirect("ReportManage.jsp?subcompanyid="+subcompanyid+"&otype="+reportType);
}
else if(operation.equals("reportdelete"))
{
  	int id = Util.getIntValue(request.getParameter("id"));
  	String reportType = "" + Util.getIntValue(request.getParameter("reportType"), 0);
  	int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"),0);
	String para = ""+id;
	
    RecordSet.executeProc("Workflow_Report_Delete",para);
    
    ReportComInfo.removeReportTypeCache() ;

    response.sendRedirect("ReportManage.jsp?subcompanyid="+subcompanyid+"&otype="+reportType);
}
else if(operation.equals("formfieldadd"))
{
    int tmpcount=Util.getIntValue(request.getParameter("tmpcount"), 0);
    String reportid = Util.null2String(request.getParameter("reportid"));
    RecordSet.executeSql("delete from Workflow_ReportDspField where reportid="+reportid);
  
    for(int i=1;i<=tmpcount;i++)
    {
    	String isshow = "" + Util.getIntValue(request.getParameter("isshow_"+i),0);
    	if(isshow.equals("1"))
    	{
      		String fieldid = "" + Util.getIntValue(request.getParameter("fieldid_"+i),0);
		    String dsporder = Util.null2String(request.getParameter("dsporder_"+i)); //xwj for td2974 20051026
		    String isstat = Util.null2String(request.getParameter("isstat_"+i));
		    String dborder = Util.null2String(request.getParameter("dborder_"+i));
		    String dbordertype = Util.null2String(request.getParameter("dbordertype_"+i));//added by xwj for td2099 for 2005-06-06
		    String compositororder = Util.null2String(request.getParameter("compositororder_"+i));//added by xwj for td2099 for 2005-06-06

      		if(isstat.equals("")) 
      		{
      			isstat = "0" ;
      		}
      		if(dborder.equals("")) 
      		{
      			dborder = "0" ;
      		}
       		if(dbordertype.equals(""))
       		{
       			dbordertype = "n";//added by xwj for td2099 for 2005-06-06
       		}
       		if(compositororder.equals(""))
       		{
       			compositororder = "0";//added by xwj for td2099 for 2005-06-06
       		}
        	if(dsporder.equals(""))
        	{
        		dsporder = "0";//added by xwj for td2099 for 2005-06-06
        	}
      		String para = reportid + separator + fieldid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder;//modefied by xwj for td2099 for 2005-06-06
      		RecordSet.executeProc("Workflow_ReportDspField_Insert",para);
   		}else{
      		String fieldid = "" + Util.getIntValue(request.getParameter("fieldid_"+i),0);
		    String dsporder = Util.null2String(request.getParameter("dsporder_"+i)); //xwj for td2974 20051026
		    String isstat = Util.null2String(request.getParameter("isstat_"+i));
		    String dborder = Util.null2String(request.getParameter("dborder_"+i));
		    String dbordertype = Util.null2String(request.getParameter("dbordertype_"+i));//added by xwj for td2099 for 2005-06-06
		    String compositororder = Util.null2String(request.getParameter("compositororder_"+i));//added by xwj for td2099 for 2005-06-06

      		if(isstat.equals("")) 
      		{
      			isstat = "0" ;
      		}
      		if(dborder.equals("")) 
      		{
      			dborder = "0" ;
      		}
       		if(dbordertype.equals(""))
       		{
       			dbordertype = "n";//added by xwj for td2099 for 2005-06-06
       		}
       		if(compositororder.equals(""))
       		{
       			compositororder = "0";//added by xwj for td2099 for 2005-06-06
       		}
        	if(dsporder.equals(""))
        	{
        		dsporder = "0";//added by xwj for td2099 for 2005-06-06
        	}
      		String para = reportid + separator + dsporder + separator + isstat + separator + dborder + separator + dbordertype + separator + compositororder + separator + fieldid;
      		RecordSet.executeProc("Workflow_RepDspFld_Insert_New",para);
   		}
    	
    }
    
	response.sendRedirect("ReportEdit.jsp?id="+reportid);
}
else if(operation.equals("deletefield"))
{
  	String reportID = Util.null2String(request.getParameter("id"));
	String fieldID = "" + Util.getIntValue(request.getParameter("theid"), 0);
	String sql = "Update Workflow_ReportDspField set FieldidBak = FieldId, FieldId = null Where id = %1$s";
	sql = String.format(sql, fieldID);
	RecordSet.executeSql(sql);
	response.sendRedirect("ReportEdit.jsp?id=" + reportID);
}
%>