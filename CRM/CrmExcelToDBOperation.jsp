<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLDecoder.*"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmExcelToDB" class="weaver.crm.ExcelToDB.CrmExcelToDB" scope="page" />
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%
response.setHeader("cache-control", "no-cache"); 
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
FileUpload fu = new FileUpload(request,false);
FileManage fm = new FileManage();

String manager=fu.getParameter("manager");
String department= ResourceComInfo.getDepartmentID(manager);
CrmExcelToDB.setDepartment(department);
String subcompanyid1=DepartmentComInfo.getSubcompanyid1(department);
CrmExcelToDB.setSubcompanyid(subcompanyid1);
String CustomerStatus=fu.getParameter("CustomerStatus");
if("".equals(manager)){
	manager = ""+user.getUID();
}

String Excelfilepath="";
 
int fileid = 0 ;

try {
    fileid = Util.getIntValue(fu.uploadFiles("filename"),0);

    String filename = fu.getFileName();


    String sql = "select filerealpath from imagefile where imagefileid = "+fileid;
    RecordSet.executeSql(sql);
    String uploadfilepath="";
    if(RecordSet.next()) uploadfilepath =  RecordSet.getString("filerealpath");


 if(!uploadfilepath.equals("")){

        Excelfilepath = GCONST.getRootPath()+"Crm/ExcelToDB"+File.separatorChar+filename ;
System.out.println("Excelfilepath£½"+Excelfilepath);
        fm.copy(uploadfilepath,Excelfilepath);
   
        
    }


 String msg="";
String msg1="";
String msg2="";
String msg3="";
String msg4="";
int    msgsize=0;
int    msgEmailsize=0;

CrmExcelToDB.setManager(manager);
CrmExcelToDB.setCrmStatus(CustomerStatus);
CrmExcelToDB.setUserId(user.getUID());

CrmExcelToDB.ScanFile(Excelfilepath);
msgsize=CrmExcelToDB.getMsg1().size();
msgEmailsize=CrmExcelToDB.getMsg3().size();

/* */

if (CrmExcelToDB.getMsg1().size()==0 && CrmExcelToDB.getMsg3().size()==0){
int maxId = 0;
String sqlStr1= "select max(id) from Crm_CustomerInfo";
RecordSet.execute(sqlStr1);
if(RecordSet.next()){
    maxId=RecordSet.getInt(1);
}
CrmExcelToDB.ExcelToDB(Excelfilepath);
int customerId = 0;
String sqlStr2 = "select id from Crm_CustomerInfo where id >"+maxId;
RecordSet.execute(sqlStr2);
while(RecordSet.next()){
    customerId = RecordSet.getInt(1);
    CustomerModifyLog.modify(customerId,user.getUID(),Util.getIntValue(manager));
}
if(CrmExcelToDB.isErreData()){
	msg="bad";	
}else{
    msg="success";
}

response.sendRedirect("CrmExcelToDB.jsp?msg="+msg);
}
else{
	for (int i = 0; i <CrmExcelToDB.getMsg1().size(); i++){
		msg1=msg1+(String)CrmExcelToDB.getMsg1().elementAt(i)+",";
		msg2=msg2+(String)CrmExcelToDB.getMsg2().elementAt(i)+",";
	}
	for (int j = 0; j <CrmExcelToDB.getMsg3().size(); j++){
		msg3=msg3+(String)CrmExcelToDB.getMsg3().elementAt(j)+",";
		msg4=msg4+(String)CrmExcelToDB.getMsg4().elementAt(j)+",";
	}

fm.DeleteFile(Excelfilepath);
response.sendRedirect("CrmExcelToDB.jsp?msg="+msg+"&msg1="+msg1+"&msg2="+msg2+"&msgsize="+msgsize+"&msg3="+msg3+"&msg4="+msg4+"&msgEmailsize="+msgEmailsize);
}

}
catch(Exception e) {

}



%>
