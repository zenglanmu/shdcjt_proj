<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmAnnualManagement" class="weaver.hrm.schedule.HrmAnnualManagement" scope="page" />

<%
String operation = Util.null2String(request.getParameter("operation"));
String subcompanyid = Util.null2String(request.getParameter("subCompanyId"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String annualyear = Util.null2String(request.getParameter("annualyear"));
String sql="";

if(operation.equals("edit")){
   if(!HrmUserVarify.checkUserRight("AnnualLeave:All", user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
      
   String resourceid[] = request.getParameterValues("resourceid");
   String annualdays[] = request.getParameterValues("annualdays");
  
   if(resourceid!=null){
     for(int i=0;i<resourceid.length;i++){
         String tempresourceid = resourceid[i];
		 String tempannualdays = annualdays[i].equals("")?"0":annualdays[i];
         sql = "delete from hrmannualmanagement where resourceid = " + tempresourceid + " and annualyear = " + annualyear;
         RecordSet.executeSql(sql);
         sql = "insert into hrmannualmanagement (resourceid,annualyear,annualdays,status) values ('"+tempresourceid+"','"+annualyear+"','"+tempannualdays+"',1)";
         RecordSet.executeSql(sql);
     }
   }
   response.sendRedirect("AnnualManagementView.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid);
}

if(operation.equals("batchprocess")){
   if(!HrmUserVarify.checkUserRight("AnnualLeave:All", user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }

   Calendar today = Calendar.getInstance();
   String currentdate= Util.add0(today.get(Calendar.YEAR),4) +"-"+ Util.add0(today.get(Calendar.MONTH)+1,2) +"-"+ Util.add0(today.get(Calendar.DAY_OF_MONTH),2);   
   
   String result = HrmAnnualManagement.getBatchProcess(subcompanyid,departmentid);
   if(result.equals("-1")){
      response.sendRedirect("AnnualManagementEdit.jsp?message=12&subCompanyId="+subcompanyid+"&departmentid="+departmentid);
   }
   
   //人员卡片上面的工作信息，可以录入合同开始日期，合同开始日期则为到职日期,年假批量处理，根据工龄来初始化
   HashMap BatchProcess = new HashMap();//批量处理设置，工龄 + 年假天数
   RecordSet.executeSql("select * from HrmAnnualBatchProcess where subcompanyid = " + result + " order by workingage desc");
   int workingage[] = new int[RecordSet.getCounts()];//工龄
   int j = 0;
   while(RecordSet.next()){
      BatchProcess.put(RecordSet.getFloat("workingage")+"",RecordSet.getString("annualdays"));
      workingage[j++] = (int) RecordSet.getFloat("workingage");     
   }
   
   HashMap userStartDate = new HashMap();//所有用户的合同开始日期
   RecordSet.executeSql("select * from hrmresource");
   while(RecordSet.next()){
      userStartDate.put(RecordSet.getString("id"),Util.null2String(RecordSet.getString("startdate")));
   }
   
   String resourceid[] = request.getParameterValues("resourceid");
   if(resourceid!=null){
     for(int i=0;i<resourceid.length;i++){
       String startdate = userStartDate.get(resourceid[i]).toString();
       if(startdate.equals("")) startdate = currentdate;
       int days = TimeUtil.dateInterval(startdate,currentdate);
       int _workingage = days/365;
       float annualdays = HrmAnnualManagement.getAnnualDays(BatchProcess,workingage,_workingage);

       String tempresourceid = resourceid[i];
       sql = "delete from hrmannualmanagement where resourceid = " + tempresourceid + " and annualyear = " + annualyear;
       RecordSet.executeSql(sql);
       sql = "insert into hrmannualmanagement (resourceid,annualyear,annualdays,status) values ('"+tempresourceid+"','"+annualyear+"','"+annualdays+"',1)";
       RecordSet.executeSql(sql);       
     }
   }
               
   response.sendRedirect("AnnualManagementView.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid);
}

%>


