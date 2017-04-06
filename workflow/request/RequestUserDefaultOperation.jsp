<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />

<%
int userid=user.getUID();
char flag=2;
String selectedworkflow="";
String isuserdefault="";
String action="";
String[] value;
try{
for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
	value=request.getParameterValues((String) En.nextElement());
	for(int i=0;i<value.length;i++){
	value[i]=Util.null2String(value[i]);
	if(value[i].indexOf("T")!=-1||value[i].indexOf("W")!=-1||value[i].indexOf("R")!=-1){
		if (selectedworkflow.equals("")){
			selectedworkflow+=value[i];
			}
		else{
			selectedworkflow+="|"+value[i];
			}
	}
	}
}
}catch(Exception e){}
if(selectedworkflow.equals("")) isuserdefault="0";
else    isuserdefault="1";

String hascreatetime = Util.null2String(request.getParameter("hascreatetime"));
String hascreater = Util.null2String(request.getParameter("hascreater"));
String hasworkflowname = Util.null2String(request.getParameter("hasworkflowname"));
String hasrequestlevel = Util.null2String(request.getParameter("hasrequestlevel"));
String hasrequestname = Util.null2String(request.getParameter("hasrequestname"));
String hasreceivetime = Util.null2String(request.getParameter("hasreceivetime"));
String hasstatus = Util.null2String(request.getParameter("hasstatus"));
String hasreceivedpersons = Util.null2String(request.getParameter("hasreceivedpersons"));
String hascurrentnode = Util.null2String(request.getParameter("hascurrentnode"));
String numperpage = Util.null2String(request.getParameter("numperpage"));
String noReceiveMailRemind = Util.null2String(request.getParameter("noReceiveMailRemind"));
String Showoperator = Util.null2String(request.getParameter("Showoperator"));
String commonuse = Util.null2String(request.getParameter("commonuse"));

if(commonuse.equals("")){
	commonuse = "0";
}

//----------------------------
//START
//----------------------------
//----------------------------
//定义报表显示
//----------------------------
int wfreportnumperpage = Util.getIntValue(Util.null2String(request.getParameter("wfreportnumperpage")), 20);
weaver.conn.RecordSet rs2 = new weaver.conn.RecordSet();
rs2.execute("delete from workflowReportCustom where userid=" + user.getUID());

if (rs2.next()) {
	rs2.execute("update workflowReportCustom set wfreportnumperpage=" + wfreportnumperpage + " where userid=" + user.getUID());
} else {
	rs2.execute("insert into workflowReportCustom(userid, wfreportnumperpage) values(" + user.getUID() + ", " + wfreportnumperpage + ")");
}
//----------------------------
//END
//----------------------------

//System.out.print();
RecordSet.executeProc("workflow_RUserDefault_Select",""+userid);
if(RecordSet.next()){
    action="update";
}else{
    action="insert";
}
String Procpara=""+userid+flag+selectedworkflow+flag+isuserdefault+flag+hascreatetime+flag+hascreater+flag+hasworkflowname+flag+hasrequestlevel+flag+hasrequestname+flag+hasreceivetime+flag+hasstatus+flag+hasreceivedpersons+flag+hascurrentnode+flag+numperpage+flag+noReceiveMailRemind+flag+Showoperator+flag+commonuse;
if(action.equals("insert"))
{
    RecordSet.executeProc("workflow_RUserDefault_Insert",Procpara);
	//新曾缓存
    RequestDefaultComInfo.addRequestDefaultComInfoCache(""+userid);
}
else
{
    RecordSet.executeProc("workflow_RUserDefault_Update",Procpara);
   //更新缓存
   RequestDefaultComInfo.updateRequestDefaultComInfoCache(""+userid);
}
//modify by xhheng @20050206 for TD 1541
response.sendRedirect("/workflow/request/RequestUserDefault.jsp?saved=true");
%>
