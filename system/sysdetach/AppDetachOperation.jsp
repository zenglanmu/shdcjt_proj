<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("AppDetach:All", user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String id = request.getParameter("id");

	String name = request.getParameter("name");
	String description = request.getParameter("description");
	
	String scopeTotal = request.getParameter("scopeTotal");
	String memberTotal = request.getParameter("memberTotal");
	
	String[] scopeids = request.getParameterValues("scope_id");
	String[] scopesourcetypes = request.getParameterValues("scope_sourcetype");
	String[] scopetypes = request.getParameterValues("scope_type");
	String[] scopeseclevels = request.getParameterValues("scope_seclevel");
	String[] scopecontents = request.getParameterValues("scope_content");
	
	String[] memberids = request.getParameterValues("member_id");
	String[] membersourcetypes = request.getParameterValues("member_sourcetype");
	String[] membertypes = request.getParameterValues("member_type");
	String[] memberseclevels = request.getParameterValues("member_seclevel");
	String[] membercontents = request.getParameterValues("member_content");
	
	RecordSet rs=new RecordSet();
	
	if(id==null||"".equals(id)) {
		rs.executeSql("insert into SysDetachInfo(name,description) values('"+name+"','"+description+"')");
		
		rs.executeSql("select max(id) id from SysDetachInfo where name = '"+name+"'");
		rs.next();
		id = rs.getString("id");
	} else {
		rs.executeSql("update SysDetachInfo set name = '"+name+"',description = '"+description+"' where id = "+id);
	}
	
	rs.executeSql("delete from SysDetachDetail where infoid = " + id);
	
	for(int i=0;scopetypes!=null&&i<scopetypes.length;i++){
		String infoid = id;
		String sourcetype = scopesourcetypes[i];
		String type = scopetypes[i];
		String seclevel = scopeseclevels[i];
		String content = scopecontents[i];
		
		if(type!=null&&!"".equals(type)
		&&content!=null&&!"".equals(content))
		rs.executeSql("insert into SysDetachDetail(infoid,sourcetype,\"type\",content,seclevel) values("+infoid+","+sourcetype+","+type+",'"+content+"',"+seclevel+")");
	}
	
	for(int i=0;membertypes!=null&&i<membertypes.length;i++){
		String infoid = id;
		String sourcetype = membersourcetypes[i];
		String type = membertypes[i];
		String seclevel = memberseclevels[i];
		String content = membercontents[i];
		
		if(type!=null&&!"".equals(type)
		&&content!=null&&!"".equals(content))
		rs.executeSql("insert into SysDetachDetail(infoid,sourcetype,\"type\",content,seclevel) values("+infoid+","+sourcetype+","+type+",'"+content+"',"+seclevel+")");
	}

	rs.executeSql(" delete from SysDetachReport ");
	rs.executeSql(" insert into SysDetachReport(fromid,frominfoid,fromtype,fromcontent,fromseclevel,toid,toinfoid,totype,tocontent,toseclevel) " +
						 " (select a.id,a.infoid,a.\"type\",a.content,a.seclevel,b.id,b.infoid,b.\"type\",b.content,b.seclevel from (select * from SysDetachDetail where sourcetype = 2) a," +
						 " ( select * from SysDetachDetail where sourcetype = 1) b where a.infoid = b.infoid ) ");
	//response.sendRedirect("AppDetachEdit.jsp?id="+id);
%>
<script type="text/javascript">
alert('<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>');
location.href = 'AppDetachEdit.jsp?id=<%=id%>';
</script>