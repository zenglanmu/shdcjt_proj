<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.cowork.CoworkShareManager"%> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />

<%
if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

String method = Util.null2String(request.getParameter("method"));
String cotypeid = Util.null2String(request.getParameter("cotypeid"));
String settype = Util.null2String(request.getParameter("settype"));

if (method.equals("add")){
    int shareType = Util.getIntValue(Util.null2String(request.getParameter("sharetype")),0);
    String shareId = Util.null2String(request.getParameter("relatedshareid"));
    int roleLevel = Util.getIntValue(Util.null2String(request.getParameter("rolelevel")),0);
    int secLevel = Util.getIntValue(Util.null2String(request.getParameter("seclevel")),0);
    
    String insertsql = "";
    if(settype.equals("manager")){
    	CoworkShareManager shareManager=new CoworkShareManager();
    	if(shareType==2)
    		shareId=shareManager.getOrgIdsStr(shareId,"3");
    	if(shareType==3)
    		shareId=shareManager.getOrgIdsStr(shareId,"2");
    	insertsql = "insert into cotype_sharemanager(cotypeid,sharetype,sharevalue,seclevel,rolelevel) values("+cotypeid+","+shareType+",'"+shareId+"',"+secLevel+","+roleLevel+")";
    }
    else if(settype.equals("members")) insertsql = "insert into cotype_sharemembers(cotypeid,sharetype,sharevalue,seclevel,rolelevel) values("+cotypeid+","+shareType+",'"+shareId+"',"+secLevel+","+roleLevel+")";
    if(!insertsql.equals("")) rs.executeSql(insertsql);
    //更新当前协作区所属协作负责人缓存
    if(settype.equals("manager")){
        String sql="select id  from cowork_items where typeid="+cotypeid;
        rs.executeSql(sql);
        CoworkShareManager shareManager=new CoworkShareManager();
        while(rs.next()){
     	   String coworkid=rs.getString("id");
     	   shareManager.deleteCache("typemanager",coworkid); //删除协作缓存
        }
     }
    CoTypeComInfo.removeCoTypeInfoCache();
		
    response.sendRedirect("CoworkTypeShareEdit.jsp?settype="+settype+"&cotypeid="+cotypeid);    	
}
else if (method.equals("delete")){
    String delId = Util.null2String(request.getParameter("delid"));
    String deletesql = "";
    if(settype.equals("manager")) deletesql = "delete from cotype_sharemanager where id="+delId;
    else if(settype.equals("members")) deletesql = "delete from cotype_sharemembers where id="+delId;
    if(!deletesql.equals("")) rs.executeSql(deletesql);
    //更新当前协作区所属协作负责人缓存
    if(settype.equals("manager")){
       String sql="select id  from cowork_items where typeid="+cotypeid;
       rs.executeSql(sql);
       CoworkShareManager shareManager=new CoworkShareManager();
       while(rs.next()){
    	   String coworkid=rs.getString("id");
    	   shareManager.deleteCache("typemanager",coworkid);//删除协作缓存
       }
    }
    CoTypeComInfo.removeCoTypeInfoCache();
    response.sendRedirect("CoworkTypeShareEdit.jsp?settype="+settype+"&cotypeid="+cotypeid); 
}
%>
