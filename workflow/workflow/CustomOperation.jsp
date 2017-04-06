<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}     
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("customadd"))
{
    String Customname = "" + Util.null2String(request.getParameter("Customname"));
	String Querytypeid = "" + Util.getIntValue(request.getParameter("Querytypeid"), 0);
    String Customdesc = "" + Util.fromScreen3(request.getParameter("Customdesc"),user.getLanguage());
	String workflowids = Util.null2String(request.getParameter("workflowids"));
    String isBill = "" + Util.getIntValue(request.getParameter("isBill"), 0);
    String formID = "" + Util.getIntValue(request.getParameter("formID"), 0);
    int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"),0);

	RecordSet.execute("INSERT INTO Workflow_Custom(formID, isBill,Querytypeid,Customname,Customdesc,workflowids,subCompanyId) VALUES ( " + formID + ", '" + isBill + "',"+Querytypeid+",'"+Customname+"','"+Customdesc+"','"+workflowids+"',"+subcompanyid+")");
    RecordSet.executeSql("select max(id) as id from Workflow_Custom");
    RecordSet.next();
    String reportid = RecordSet.getString("id");
    
    int fieldcount = 9;
	fieldcount++;
	String fieldid = "-1";
    String dsporder = ""+fieldcount;
    String para = reportid  ;
    RecordSet.executeProc("Workflow_CustomDspField_Init",para);
	String sql="";
	
	response.sendRedirect("CustomEdit.jsp?id="+reportid);
}
else if(operation.equals("customedit")){//保存对表单中流程的修改
	String id = ""+Util.getIntValue(request.getParameter("id"), 0);
    String Customname = "" + Util.null2String(request.getParameter("Customname"));
	String Querytypeid = "" + Util.getIntValue(request.getParameter("Querytypeid"), 0);
    String Customdesc = "" + Util.fromScreen3(request.getParameter("Customdesc"),user.getLanguage());
	String workflowids = Util.null2String(request.getParameter("workflowids"));
	int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"),0);
	RecordSet.execute("update Workflow_Custom set Customname='"+Customname+"',Querytypeid="+Querytypeid+",Customdesc='"+Customdesc+"',workflowids='"+workflowids+"',subCompanyId="+subcompanyid+" where id="+id);
	response.sendRedirect("/workflow/workflow/CustomEdit.jsp?id="+id);
}
else if(operation.equals("customdelete"))
{
  	int id = Util.getIntValue(request.getParameter("id"));
  	
	String para = ""+id;
	
    RecordSet.execute("delete from Workflow_Custom where id="+para);
    

    response.sendRedirect("CustomQuerySet.jsp");
}
else if(operation.equals("formfieldadd"))
{
   
    int tmpcount=Util.getIntValue(request.getParameter("tmpcount"), 0);
    
    String reportid = Util.null2String(request.getParameter("reportid"));

    RecordSet.executeSql("delete from Workflow_CustomDspField where customid="+reportid);
  
    for(int i=0;i<=tmpcount;i++)
    {
        String fieldid = "" + Util.getIntValue(request.getParameter("fieldid_"+i),0);
        String dsporder = ""+Util.getIntValue(request.getParameter("dsporder_" + i),0);
        String ifquery = Util.null2String(request.getParameter("ifquery_" + i));
        String isshows = Util.null2String(request.getParameter("isshows_" + i));
        String queryorder = ""+Util.getIntValue(request.getParameter("queryorder_" + i),0);
        if (ifquery.equals("")) {
            ifquery = "0";
        }
        if (isshows.equals("")) {
            isshows = "0";
        }
    	if(ifquery.equals("1")||isshows.equals("1"))
    	{
      		String para = reportid + separator + fieldid  + separator + ifquery + separator+ isshows + separator  + dsporder + separator +queryorder;

      		RecordSet.executeProc("Workflow_CustomDspField_Insert",para);
   		}
    }
    
	response.sendRedirect("CustomEdit.jsp?id="+reportid);
}
else if(operation.equals("deletefield"))
{
  	String reportID = Util.null2String(request.getParameter("id"));
	String fieldID = "" + Util.getIntValue(request.getParameter("theid"), 0);

	RecordSet.execute("delete from Workflow_CustomDspField where id="+fieldID+" and customid="+reportID);

	response.sendRedirect("CustomEdit.jsp?id=" + reportID);
}

%>