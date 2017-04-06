<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
char flag = 2;
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
String shareid = Util.null2String(request.getParameter("shareid"));
String votingid = Util.null2String(request.getParameter("votingid"));
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));

String userid = "0" ;
String departmentid = "0" ;
String subcompanyid="0";
String roleid = "0" ;
String foralluser = "0" ;

if(sharetype.equals("1")){
 userid = relatedshareid ;
 seclevel = "0";
}
if(sharetype.equals("2")) subcompanyid = relatedshareid ;
if(sharetype.equals("3")) departmentid = relatedshareid ;
if(sharetype.equals("4")) roleid = relatedshareid ;
if(sharetype.equals("5")) foralluser = "1" ;

if(method.equals("add")&& (sharetype.equals("1")||sharetype.equals("2")||sharetype.equals("3")))
{
	ArrayList objnames = Util.TokenizerString(relatedshareid,",");
   	if(objnames!=null){
   		for(int i=0;i<objnames.size();i++){
   			String tmpid = ""+objnames.get(i);
   			
   			userid = "0";
   			departmentid = "0" ;
   			subcompanyid="0";
   			if(sharetype.equals("1")) userid = tmpid;
   			if(sharetype.equals("2")) subcompanyid = tmpid;
   			if(sharetype.equals("3")) departmentid = tmpid;

   		    ProcPara = votingid + flag + sharetype + flag + userid + flag + subcompanyid + flag + 
            departmentid + flag + roleid + flag + seclevel + flag + rolelevel + flag + foralluser;
            RecordSet.executeProc("VotingShare_Insert",ProcPara);
            RecordSet.executeProc("VotingShareDetail_Update",votingid);	
   		}
	}
}
else if(method.equals("add")&& !(sharetype.equals("1")||sharetype.equals("2")||sharetype.equals("3")))
{
   ProcPara = votingid + flag + sharetype + flag + userid + flag + subcompanyid + flag + 
              departmentid + flag + roleid + flag + seclevel + flag + rolelevel + flag + foralluser;
   RecordSet.executeProc("VotingShare_Insert",ProcPara);
   RecordSet.executeProc("VotingShareDetail_Update",votingid);
}

if(method.equals("delete")){
    RecordSet.executeProc("VotingShare_Delete",shareid);
    RecordSet.executeProc("VotingShareDetail_Update",votingid);
    response.sendRedirect("VotingView.jsp?votingid="+votingid);
    return;
}
%>
<script type="text/javascript">
	window.parent.returnValue = {id:"", name:""};
	window.parent.close();
</script>