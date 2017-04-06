<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SysWorkflow" class="weaver.system.SysWorkflow" scope="page" />

<%

char flag = 2;
String ProcPara = "";

String CurrentUser = ""+user.getUID();
String SubmiterType = ""+user.getLogintype();
String ClientIP = request.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String method = Util.null2String(request.getParameter("method"));
String meetingid=Util.null2String(request.getParameter("meetingid"));
String Sql="";

if(method.equals("edit"))
{
	int topicrows=Util.getIntValue(Util.null2String(request.getParameter("topicrows")),0);
	String recordsetids="";
	for(int i=0;i<topicrows;i++){
		String recordsetid=Util.null2String(request.getParameter("recordsetid_"+i));
		if(!recordsetid.equals("")) recordsetids+=","+recordsetid;
	}
	if(!recordsetids.equals("")){
		recordsetids=recordsetids.substring(1);
		Sql = "delete Meeting_Topic WHERE ( meetingid = "+meetingid+" and id not in ("+recordsetids+"))";
		RecordSet.executeSql(Sql);
	}else{
		Sql = "delete Meeting_Topic WHERE ( meetingid = "+meetingid+")";
		RecordSet.executeSql(Sql);
	}

	for(int i=0;i<topicrows;i++){
		String recordsetid=Util.null2String(request.getParameter("recordsetid_"+i));
		String topicsubject=Util.null2String(request.getParameter("topicsubject_"+i));
		String topichrmids=Util.null2String(request.getParameter("topichrmids_"+i));	
		String topicopen=Util.null2String(request.getParameter("topicopen_"+i));
		String topicprojid=Util.null2String(request.getParameter("topicprojid_"+i));	
		String topiccrmid=Util.null2String(request.getParameter("topiccrmid_"+i));	
		
		if(!recordsetid.equals("")){
			if(!topicsubject.equals("")){
				ProcPara =  recordsetid;
				ProcPara += flag + "0";
	            ProcPara += flag + topicsubject;
				ProcPara += flag + topichrmids;	
				ProcPara += flag + topicprojid;	
				ProcPara += flag + topiccrmid;
				ProcPara += flag + topicopen;
				RecordSet.executeProc("Meeting_Topic_Update",ProcPara);		
			}			
		}else if(!topicsubject.equals("")){
				ProcPara =  meetingid;
				ProcPara += flag + "0";
				ProcPara += flag + topicsubject;		
				ProcPara += flag + topichrmids;	
				ProcPara += flag + topicprojid;	
				ProcPara += flag + topiccrmid;
				ProcPara += flag + topicopen;
				RecordSet.executeProc("Meeting_Topic_Insert",ProcPara);		
		}
	}

}

%>


<script language=VBS>

     window.parent.returnvalue = Array("","")
     window.parent.close

</script>


