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
<jsp:useBean id="CapitalExcelToDB" class="weaver.cpt.ExcelToDB.CapitalExcelToDB" scope="page" />

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
FileUpload fu = new FileUpload(request,false);
FileManage fm = new FileManage();

int isdata=Util.getIntValue(fu.getParameter("isdata"));
String responsepage="CapitalExcelToDB.jsp";
if(isdata==2) responsepage="CapitalExcelToDB1.jsp";
String Excelfilepath="";
String auto = Util.null2String(fu.getParameter("auto"));

int fileid = 0 ;

try {
    fileid = Util.getIntValue(fu.uploadFiles("filename"),0);

    String filename = fu.getFileName();


    String sql = "select filerealpath from imagefile where imagefileid = "+fileid;
    RecordSet.executeSql(sql);
    String uploadfilepath="";
    if(RecordSet.next()) uploadfilepath =  RecordSet.getString("filerealpath");


 if(!uploadfilepath.equals("")){

        Excelfilepath = GCONST.getRootPath()+"cpt/ExcelToDB"+File.separatorChar+filename ;
        fm.copy(uploadfilepath,Excelfilepath);
    }


String msg="";
String msg1="";
String msg2="";
int    msgsize=0;

CapitalExcelToDB.ExcelToDB(Excelfilepath,isdata,user.getUID(),user.getLanguage(),request.getRemoteAddr(),auto);
msgsize=CapitalExcelToDB.getMsg1().size();
if(msgsize==0){
    msg="success";
    response.sendRedirect(responsepage+"?msg="+msg);
}else{
    for (int i = 0; i <msgsize; i++){
    msg1=msg1+(String)CapitalExcelToDB.getMsg1().elementAt(i)+",";
    msg2=msg2+(String)CapitalExcelToDB.getMsg2().elementAt(i)+",";
    }

    fm.DeleteFile(Excelfilepath);
	session.setAttribute("cptmsg1",msg1);
	session.setAttribute("cptmsg2",msg2);
    response.sendRedirect(responsepage+"?msg="+msg+"&msgsize="+msgsize);
}
}
catch(Exception e) {

}



%>
