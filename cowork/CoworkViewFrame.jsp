<%@ page language="java" contentType="text/html;charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<%
int typeid=Util.getIntValue(Util.null2String(request.getParameter("typeid")),0);
int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);
int docid=Util.getIntValue(Util.null2String(request.getParameter("docid")),0);//TD5067，从协作区创建文档返回的文档ID
String method = Util.null2String(request.getParameter("method"));//从文档关联至协作
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String projectid = Util.null2String(request.getParameter("projectid"));
String type = Util.null2String(request.getParameter("type"));
    //xiaofeng
String uid = Util.null2String(request.getParameter("uid"));
int isworkflow = Util.getIntValue(Util.null2String(request.getParameter("isworkflow")),0);
int isreward = Util.getIntValue(Util.null2String(request.getParameter("isreward")),0);
int maintypeid = Util.getIntValue(Util.null2String(request.getParameter("maintypeid")),0);
String taskIds = Util.null2String(request.getParameter("taskIds"));
int userid=user.getUID();

ArrayList maintypeids = new ArrayList();

boolean isoracle = (RecordSet.getDBType()).equals("oracle");
String sqltmp = "";
if(isoracle){
	sqltmp = "select distinct departmentid from cowork_types where dbms_lob.instr(managerid,',"+userid+",',1,1)>0 or dbms_lob.instr(members,',"+userid+",',1,1)>0";
}else{
	sqltmp = "select distinct departmentid from cowork_types where managerid like '%,"+userid+",%' or members like '%,"+userid+",%'";
}
RecordSet.executeSql(sqltmp);
while(RecordSet.next()){
	String departmentid = RecordSet.getString("departmentid");
	maintypeids.add(departmentid);
	if(maintypeid==0)
		maintypeid = Util.getIntValue(departmentid,0);
}
if(typeid!=0){
    maintypeid=Util.getIntValue(CoTypeComInfo.getCoTypendepartmentid(""+typeid),0);
}
%>
	<frameset cols="50%,50%" name="frameBottom" id="frameBottom" style="cursor:col-resize" border="0">
        <%if(uid.equalsIgnoreCase("")){%>
        <frame src="CoworkList.jsp?maintypeid=<%=maintypeid%>&isworkflow=<%=isworkflow%>&typeid=<%=typeid%>&id=<%=id%>&type=<%=type%>&CustomerID=<%=CustomerID%>&projectid=<%=projectid%>&method=<%=method%>&docid=<%=docid%>&taskIds=<%=taskIds%>" name="frameLeft" id="frameLeft" scrolling="yes">
		<frame src="frameRight.jsp?maintypeid=<%=maintypeid%>&isworkflow=<%=isworkflow%>&typeid=<%=typeid%>&id=<%=id%>&docid=<%=docid%>" name="frameRight" id="frameRight" scrolling="no" style="border-left:2px solid #ccc">
	    <%}else{%>
        <frame src="SearchCoworkResult.jsp?creater=<%=uid%>" name="frameLeft" id="frameLeft" scrolling="yes">
		<frame src="frameRight.jsp?creater=<%=uid%>" name="frameRight" id="frameRight" scrolling="no" style="border-left:2px solid #ccc">
        <%}%>
    </frameset>
