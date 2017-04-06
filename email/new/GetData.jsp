<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%
int rows = 5;
String userid = user.getUID()+"";
String temptable = "";
String usertype="0";
if(user.getLogintype().equals("2")) usertype="1";
String json = "";
String key_word = Util.null2String(request.getParameter("q"));
String searchtype = Util.null2String(request.getParameter("searchtype"));

StringBuffer sql = new StringBuffer();
String sqlWhere = "";
String sqlWhere2 = "";
if(!key_word.equals("")){
	
	sqlWhere += " #### like '%" + key_word + "%'";
	
	

	if(searchtype.equals("hrm")){
		sql.append("select id,lastname,departmentid from HrmResource where (status =0 or status = 1 or status = 2 or status = 3) and ("+sqlWhere.replaceAll("####","lastname")+" or "+sqlWhere.replaceAll("####","pinyinlastname")+") order by dsporder");
		
	}
	rs.executeSql(sql.toString());
	if(rs.getCounts()>0){
		while(rs.next()){
			json += "{id:'"+rs.getString(1)+"',name:'"+rs.getString(2)+"',department:'"+DepartmentComInfo.getDepartmentname(rs.getString(3))+"',dpid:'"+rs.getString(3)+"'";
		
			json += "},";
		}
	}
	if(!json.equals("")){
		json = "[" + json.substring(0,json.length()-1) + "]";
	}
}

out.println(json);
%>
