<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="oracle.sql.CLOB" %>

<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page"/>

<%

int userid=user.getUID();

// 查看类型
String type = Util.null2String(request.getParameter("type"));

//关注的或者直接参与的协作
String viewType = Util.null2String(request.getParameter("viewtype"));
// 标签Ids
String labelid = Util.null2String(request.getParameter("labelid"));

//是否是搜索操作
String isSearch = Util.null2String(request.getParameter("issearch"));

//关键字
String keyword = Util.null2String(request.getParameter("keyword"));

//协作区ID
String typeid = Util.null2String(request.getParameter("typeid"));

//协作状态
String status = Util.null2String(request.getParameter("status"));

//参与类型
String jointype = Util.null2String(request.getParameter("jointype"));

// 创建者
String creater = Util.null2String(request.getParameter("creater"));

//负责人
String coworkmanager = Util.null2String(request.getParameter("Coworkmanager"));

//开始时间
String startdate = Util.null2String(request.getParameter("startdate"));

// 结束时间
String enddate = Util.null2String(request.getParameter("enddate"));
//if(isworkflow==1){
//    response.sendRedirect("/cowork/WorkflowList.jsp?isworkflow=1&id="+curcustid);
//    return;
//}

String searchStr="";
if("true".equals(isSearch)){
	
	if(!keyword.equals("")){
		searchStr += " and name like '%"+keyword+"%' "; 
	}
	
	if(!typeid.equals("")){
		searchStr += "  and typeid='"+typeid+"'  ";
	}
	
	if(!status.equals("")){
		searchStr += " and status ='"+status+"'  ";
	}
	if(viewType.equals("")){
		if(jointype.equals("")){
			viewType = "";
		}else if(jointype.equals("1")){
			viewType = "p";
		}else if(jointype.equals("2")){
			viewType = "a";
		}
	}
	if(!creater.equals("")){
		searchStr += " and creater='"+creater+"'  ";
	}
	
	if(!coworkmanager.equals("")){
		//todo
		searchStr += " and principal='"+coworkmanager+"'  "; 
	}
	
	if(!startdate.equals("")){
		searchStr +=" and begindate >='"+startdate+"'  ";
	}
	
	if(!enddate.equals("")){
		searchStr +=" and enddate <='"+enddate+"'  ";
	}
}else{
	searchStr = " and status = 1 ";
}

searchStr = searchStr.replaceFirst("and","");

if(searchStr.trim().equals("")){
	searchStr = " 1=1 ";
}

String sqlStr ="";



	if("unread".equals(type)){
		sqlStr = "select distinct a.name,a.id,a.isnew, case when t2.id is null then 0 else 1 end as important from (select t1.name,t1.id, 1 as isnew  from cowork_items t1 where "+ searchStr +" and not exists (select 1 from cowork_read t3 where userid='"+userid+"' and t1.id=t3.coworkid) and  not exists (select 1 from cowork_hidden t4 where userid='"+userid+"' and t1.id=t4.coworkid)) a left join cowork_important t2 on a.id=t2.coworkid and t2.userid='"+userid+"' order by important desc,a.id desc";
		//sqlStr = "select t1.name,t1.id, case when t2.id is null then 0 else 1 end as important,1 as isnew from cowork_items t1 left join cowork_important t2 on t1.status=1 and t1.id=t2.coworkid and not exists (select 1 from cowork_read t3 where userid='"+userid+"' and t1.id=t3.coworkid) order by important desc,a.id desc";       
	}else if("important".equals(type)){
		sqlStr = "select distinct a.name,a.id,a.important, case when t2.id is null then 1 else 0 end as isnew from (select t1.name,t1.id, 1 as important  from cowork_items t1 where "+ searchStr +" and  exists (select 1 from cowork_important t3 where userid='"+userid+"' and t1.id=t3.coworkid) and not exists (select 1 from cowork_hidden t4 where userid='"+userid+"' and t1.id=t4.coworkid)) a left join cowork_read t2 on a.id=t2.coworkid and t2.userid='"+userid+"' order by isnew desc,a.id desc";
	}else if("hidden".equals(type)){
		//sqlStr = "select t1.name,t1.id, case when t2.id is null then 0 else 1 end as isnew,1 as important from cowork_items t1 left join cowork_read t2 on t1.status=1 and t1.id=t2.coworkid and not exists (select 1 from cowork_important t3 where userid='"+userid+"' and t1.id=t3.coworkid) order by isnew desc,t1.id desc";
		sqlStr = "select distinct a.name,a.id,case when t3.id is null then 0 else 1 end as important, case when t2.id is null then 1 else 0 end as isnew from (select t1.name,t1.id  from cowork_items t1 where "+ searchStr +" and  exists (select 1 from cowork_hidden t4 where userid='"+userid+"' and t1.id=t4.coworkid)) a left join cowork_read t2 on a.id=t2.coworkid and t2.userid='"+userid+"' left join cowork_important t3 on a.id=t3.coworkid and t3.userid='"+userid+"' order by important desc, isnew desc,a.id desc";
	
	}else if("type".equals(type)){
		String value = Util.null2String(request.getParameter("value"));
		sqlStr = "select distinct a.name,a.id,case when t3.id is null then 0 else 1 end as important, case when t2.id is null then 1 else 0 end as isnew from (select t1.name,t1.id  from cowork_items t1 where "+ searchStr +" and  exists (select 1 from cowork_item_label t4 where userid='"+userid+"' and t1.id=t4.coworkid and t4.labelid='"+labelid+"')) a left join cowork_read t2 on a.id=t2.coworkid and t2.userid='"+userid+"' left join cowork_important t3 on a.id=t3.coworkid and t3.userid='"+userid+"' order by important desc, isnew desc,a.id desc";
	}else if("label".equals(type)){
		String value = Util.null2String(request.getParameter("value"));	
		sqlStr = "select distinct a.name,a.id,case when t3.id is null then 0 else 1 end as important, case when t2.id is null then 1 else 0 end as isnew from (select t1.name,t1.id  from cowork_items t1 where "+ searchStr +" and  exists (select 1 from cowork_item_label t4 where t1.id=t4.coworkid and t4.labelid='"+labelid+"')) a left join cowork_read t2 on a.id=t2.coworkid and t2.userid='"+userid+"' left join cowork_important t3 on a.id=t3.coworkid and t3.userid='"+userid+"' order by important desc, isnew desc,a.id desc";
	}else if("all".equals(type)){
		if(searchStr.equals("")){
			sqlStr = "select distinct a.name,a.id,case when t3.id is null then 0 else 1 end as important, case when t2.id is null then 1 else 0 end as isnew from (select t1.name,t1.id  from cowork_items t1) a left join cowork_read t2 on a.id=t2.coworkid and t2.userid='"+userid+"' left join cowork_important t3 on a.id=t3.coworkid and t3.userid='"+userid+"' order by important desc, isnew desc,a.id desc";			
		}else{
			sqlStr = "select distinct a.name,a.id,case when t3.id is null then 0 else 1 end as important, case when t2.id is null then 1 else 0 end as isnew from (select t1.name,t1.id  from cowork_items t1 where "+ searchStr +" and not exists (select 1 from cowork_hidden t4 where t1.id=t4.coworkid) ) a left join cowork_read t2 on a.id=t2.coworkid and t2.userid='"+userid+"' left join cowork_important t3 on a.id=t3.coworkid and t3.userid='"+userid+"' order by important desc, isnew desc,a.id desc";
		}
	}
	
%>
 <table id='list' cellpadding="0" cellspacing="0" border="0"  width="100%" background="#ededed">
 	<colgroup>
	<col width="25">
	<col width="20">
	<col width="235">
	</colgroup>
	
<%
ConnStatement statement=new ConnStatement();
try {
	//System.out.println(sqlStr);
    statement.setStatementSql(sqlStr);
    statement.executeQuery();
    while(statement.next()){
    	if(viewType.equals("p")){
    		if(!CoworkShareManager.isCanView(statement.getString("id"),userid+"","parter")){
        		continue;
        	}
    	}else if(viewType.equals("a")){
    		if(!CoworkShareManager.isCanView(statement.getString("id"),userid+"","typemanager")){
        		continue;
        	}
    	}else if(viewType.equals("")){
    		if(!CoworkShareManager.isCanView(statement.getString("id"),userid+"","all")){
    			continue;
    		}
    	}
    	
    	
    	String unread="";
    	String read="";
    	String important="";
    	String normal="";
    	
    	String className ="";
    	if(statement.getString("important").equals("1")){
    		className ="important";
    		important="true";
    		normal="false";
    	}else{
    		className ="normal";
    		normal = "true";
    		important ="false";
    	}
    	
    	if(statement.getString("isnew").equals("1")){
    		unread = "true";
    		read = "false";
    	}else{
    		unread = "fasle";
    		read = "true";
    	}
    	
    	String labelStr ="";
    	RecordSet.execute("select t2.name,t2.icon from cowork_item_label t1,cowork_label t2 where t2.userid='"+userid+"' and t1.coworkid='"+statement.getString("id")+"' and t1.Labelid=t2.id");
    	while(RecordSet.next()){
    		String icon = RecordSet.getString("icon");
    		if(icon.equals("")) icon = "/cowork/images/icon-lable.gif";
    		labelStr +="<span class='lable'><img align='absmiddle' src='"+icon+"'>"+RecordSet.getString("name")+"</span>";
    	}
    	
    	if(!labelStr.equals("")){
    		labelStr = ""+labelStr;
    	}
    	
    	
 %>
	<tr >
		<td><input type="checkbox" value=<%=statement.getString("id") %> unread="<%=unread %>"  read="<%=read %>" important="<%=important %>" normal="<%=normal %>"></td>
		<td><div class='operate <%=className %>' coworkid='<%=statement.getString("id")%>'>&nbsp;</div></td>
		<td style="cursor: pointer;" title="<%=Util.StringReplace(Util.toHtml(statement.getString("name")),"<br>","\n")%>"><span class='title'><%=statement.getString("name") %></span><span id='isnew_<%=statement.getString("id") %>' style='display:<%=statement.getString("isnew").equals("1")?"":"none" %>;width:10px'><img align='absmiddle' src='/images/BDNew.gif'></span><div class='labelContaner'><%=labelStr%></div></td>
	</tr>
 <%              
    }
}catch(Exception ex){
	System.out.println(sqlStr);
	System.out.println(ex);
}finally{
    statement.close();
}
%>
</table>