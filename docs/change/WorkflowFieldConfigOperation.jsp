<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
	response.sendRedirect("/notice/noright.jsp");
		return;
}
%>
<%
String fieldname = "";
String outerfieldname = "";
String rulesopt = "";
int version = Util.getIntValue(request.getParameter("version"), 1);
String companyid = Util.null2String(request.getParameter("companyid"));
String workflowid = Util.null2String(request.getParameter("wfid"));
String chageFlag = Util.null2String(request.getParameter("chageFlag"));
String sn = Util.null2String(request.getParameter("sn"));
String newversionid = Util.null2String(request.getParameter("newversionid"));
int fieldscount = Util.getIntValue(request.getParameter("fieldscount"), 0);
if(fieldscount>2) {
	//首先清空相同值,防止错误重复
	RecordSet.executeSql("DELETE FROM DocChangeFieldConfig WHERE chageFlag='"+chageFlag+"' AND companyid="+companyid+" AND version="+version+" AND workflowid="+workflowid+" and sn = " + sn);
}
for(int i=1; i<=fieldscount; i++) {
	fieldname = Util.null2String(request.getParameter("fieldid_index_"+i));
	outerfieldname = Util.null2String(request.getParameter("outerfieldname_index_"+i));
	rulesopt = Util.null2String(request.getParameter("rulesopt_"+i));
	if(outerfieldname.equals("")) continue;
	else {
		String sql = "insert into DocChangeFieldConfig(chageFlag,companyid,version,workflowid,fieldname,outerfieldname,rulesopt,sn) " +
					 "VALUES ('"+chageFlag+"', "+companyid+", "+version+", "+workflowid+", '"+fieldname+"', '"+outerfieldname+"', '"+rulesopt+"','"+sn+"')";
		RecordSet.executeSql(sql);
	}
}
%>
<script>
alert('<%=SystemEnv.getHtmlLabelName(23767,user.getLanguage())%>');
location.href = 'WorkflowFieldConfig.jsp?wfid=<%=workflowid%>&chageFlag=<%=chageFlag%>&companyid=<%=companyid%>&version=<%=version%>&sn=<%=sn%>&newversionid=<%=newversionid%>';
</script>