<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.hrm.schedule.HrmAnnualImport"%>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<%
FileUpload fu = new FileUpload(request,false);
String operation = Util.null2String(fu.getParameter("operation"));
String subcompanyid = Util.null2String(fu.getParameter("subCompanyId"));
String departmentid = Util.null2String(fu.getParameter("departmentid"));
String annualyear = Util.null2String(fu.getParameter("annualyear"));
String sql="";

if(operation.equals("import")){
   if(!HrmUserVarify.checkUserRight("AnnualLeave:All", user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   
   int fileid = 0 ;   
   String msg="";
   String msg1="";
   String msg2="";
   
   try {      
    fileid = Util.getIntValue(fu.uploadFiles("excelfile"),0);      
    sql = "select filerealpath from imagefile where imagefileid = "+fileid;
    RecordSet.executeSql(sql);
    String uploadfilepath="";
    if(RecordSet.next()) uploadfilepath =  RecordSet.getString("filerealpath");
    
    HrmAnnualImport HrmAnnualImport = new HrmAnnualImport();
    HrmAnnualImport.ScanFile(uploadfilepath);
    if(HrmAnnualImport.getMsg1().size()==0){
       HrmAnnualImport.ExcelToDB(uploadfilepath,subcompanyid,departmentid,annualyear);
       msg="sucess";
       response.sendRedirect("AnnualManagementImport.jsp?msg="+msg+"&annualyear="+annualyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid);
    }else{
       for (int i = 0; i <HrmAnnualImport.getMsg1().size();i++){
         msg1=msg1+(String)HrmAnnualImport.getMsg1().elementAt(i)+",";
         msg2=msg2+(String)HrmAnnualImport.getMsg2().elementAt(i)+",";
       }
       response.sendRedirect("AnnualManagementImport.jsp?msg="+msg+"&msg1="+msg1+"&msg2="+msg2+"&annualyear="+annualyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid);    
    }    
   }catch(Exception e){
 
   }  
      
   response.sendRedirect("AnnualManagementImport.jsp?annualyear="+annualyear+"&subCompanyId="+subcompanyid+"&departmentid="+departmentid);
}


%>