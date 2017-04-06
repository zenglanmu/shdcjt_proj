<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;
String sql = "";

int modeid = Util.getIntValue(request.getParameter("modeid"),0);
int id = Util.getIntValue(request.getParameter("id"),0);
int hrefid = Util.getIntValue(request.getParameter("hrefid"),0);
int hreftype = Util.getIntValue(request.getParameter("hreftype"),0);
System.out.println(operation);
System.out.println(id);

//先删除数据再重新保存
if (operation.equals("save")) {
	String hreffieldnames[] = request.getParameterValues("hreffieldname");
	String modefieldnames[] = request.getParameterValues("modefieldname");
	if(id>0){
		sql = "update mode_pagerelatefield set modeid = " + modeid + ",hrefid="+hrefid+",hreftype="+hreftype+" where id = " + id;
		rs.executeSql(sql);
	}else{
		sql = "insert into mode_pagerelatefield(modeid,hreftype,hrefid) values("+modeid+","+hreftype+","+hrefid+")";
		rs.executeSql(sql);
		
		sql = "select id from mode_pagerelatefield where modeid="+modeid+" and hrefid="+hrefid+" and hreftype="+hreftype;
		rs.executeSql(sql);
		while(rs.next()){
			id = rs.getInt("id");
		}
	}
	
	sql = "delete from mode_pagerelatefielddetail where mainid = " + id;
	rs.executeSql(sql);
	
	for(int i=0;i<modefieldnames.length;i++){
		String hreffieldname = Util.null2String(hreffieldnames[i]);
		String modefieldname = Util.null2String(modefieldnames[i]);
		if(!modefieldname.equals("")&&!hreffieldname.equals("")){
			sql = "insert into mode_pagerelatefielddetail(mainid,modefieldname,hreffieldname) values ("+id+",'"+modefieldname+"','"+hreffieldname+"')";
			rs.executeSql(sql);
		}
	}
	
%>
	<script type="text/javascript">
	<!--
		window.close();
		window.parent.close();
	//-->
	</script>
<%
	
	//response.sendRedirect("/formmode/interfaces/ModePageExpandRelatedFieldSet.jsp?modeid="+modeid+"&hrefid="+hrefid+"&hreftype="+hreftype+"&id="+id);
}else if (operation.equals("del")) {
    //删除主表数据
	sql = "delete from mode_pagerelatefield where id = " + id;
	rs.executeSql(sql);

	//删除明细表数据
	sql = "delete from mode_pagerelatefielddetail where mainid = " + id;
	rs.executeSql(sql);
%>
	<script type="text/javascript">
	<!--
		window.close();
		window.parent.close();
	//-->
	</script>
<%	
}

%>