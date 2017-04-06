<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String sql = "";
String allsubcompanyid = SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid+"")+subcompanyid;

String temp1=",";
int a[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"AnnualPeriod:All");
for(int j=0;j<a.length;j++) {
   temp1+=a[j]+",";
}

ArrayList rightsub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"LeaveTypeColor:All");
String temp = "";
if(rightsub!=null){
   for(int i=0;i<rightsub.size();i++){
      if((","+allsubcompanyid).indexOf(","+rightsub.get(i).toString()+",")>-1 && temp1.indexOf(","+rightsub.get(i).toString()+",")>-1 ) temp += rightsub.get(i).toString()+",";
   }
}
allsubcompanyid = temp + subcompanyid;

if(operation.equals("edit")){
   if(!HrmUserVarify.checkUserRight("LeaveTypeColor:All", user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   
   String[] itemids=request.getParameterValues("itemid");
   
   if(itemids!=null){
      sql = "delete from HrmLeaveTypeColor where subcompanyid = " + subcompanyid;
      RecordSet.executeSql(sql);
      for(int i=0;i<itemids.length;i++){
         String itemid = itemids[i];
         String color = Util.null2String(request.getParameter("color"+i));
         sql = "insert into HrmLeaveTypeColor (itemid,color,subcompanyid) values ('"+itemid+"','"+color+"','"+subcompanyid+"')";
         RecordSet.executeSql(sql);
      }
   }

   response.sendRedirect("LeaveTypeColorView.jsp?subcompanyid="+subcompanyid);
}

if(operation.equals("delete")){
   if(!HrmUserVarify.checkUserRight("LeaveTypeColor:All", user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String ids = Util.null2String(request.getParameter("ids")) + "-1";
   if(ids.equals("")||ids.equals("-1")){   
      sql = "delete from HrmLeaveTypeColor where subcompanyid = " + subcompanyid;
   }else{
      sql = "delete from HrmLeaveTypeColor where id in (" + ids + ")";
   }
   RecordSet.executeSql(sql);

   response.sendRedirect("LeaveTypeColorView.jsp?subcompanyid="+subcompanyid);      
}

if(operation.equals("syn")){
   if(!HrmUserVarify.checkUserRight("LeaveTypeColor:All", user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String ids = Util.null2String(request.getParameter("ids")) + "-1";
   String _itemid = "";
   sql = "select * from HrmLeaveTypeColor where id in(" +ids+ ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
      _itemid += RecordSet.getString("itemid") + ",";      
   }
   _itemid += "-1";
   
   String _tempsubcompanyid[] = Util.TokenizerString2(allsubcompanyid,",");   
   sql = "delete from HrmLeaveTypeColor where subcompanyid <> " + subcompanyid + " and subcompanyid in ("+allsubcompanyid+") and itemid in (" + _itemid + ")";
   RecordSet.executeSql(sql);
   sql = "select * from HrmLeaveTypeColor where subcompanyid = " + subcompanyid + " and id in (" + ids + ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
     String itemid = RecordSet.getString("itemid");
     String color = RecordSet.getString("color");
     for(int i=0;i<_tempsubcompanyid.length;i++){
         if(_tempsubcompanyid[i].equals(subcompanyid)) continue;
         sql = "insert into HrmLeaveTypeColor (itemid,color,subcompanyid) values ('"+itemid+"','"+color+"','"+_tempsubcompanyid[i]+"')";
         RecordSet.executeSql(sql);        
     }
   }
   
   response.sendRedirect("LeaveTypeColorView.jsp?subcompanyid="+subcompanyid);      
}
if(operation.equals("syndelete")){
   if(!HrmUserVarify.checkUserRight("LeaveTypeColor:All", user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   
   String ids = Util.null2String(request.getParameter("ids")) + "-1";
   String _itemid = "";
   sql = "select * from HrmLeaveTypeColor where id in(" +ids+ ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
      _itemid += RecordSet.getString("itemid") + ",";      
   }
   _itemid += "-1";
   
   sql = "delete from HrmLeaveTypeColor where subcompanyid in ("+allsubcompanyid+") and itemid in (" + _itemid + ")";
   RecordSet.executeSql(sql);

   response.sendRedirect("LeaveTypeColorView.jsp?subcompanyid="+subcompanyid);      
}
%>