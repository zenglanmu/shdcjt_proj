<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.ConnStatement" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="oracle.sql.CLOB"%>
<%@ page import="java.io.Writer"%>
<%@ page import="java.util.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
ConnStatement statement = new ConnStatement();
int eid=Util.getIntValue(request.getParameter("eid"));
int viewType=Util.getIntValue(request.getParameter("viewType"));
String typeids=Util.null2String(request.getParameter("typeids"));
String flowids=Util.null2String(request.getParameter("flowids"));
String nodeids=Util.null2String(request.getParameter("nodeids"));
String tabTitle = Util.null2String(request.getParameter("tabTitle"));

String tabId = Util.null2String(request.getParameter("tabId"));
String method = Util.null2String(request.getParameter("method"));
int isExclude=Util.getIntValue(request.getParameter("isExclude"),0);
String showCopy = Util.null2String(request.getParameter("showCopy"));
String completeflag = Util.null2String(request.getParameter("completeflag"));
if(showCopy.equals("")){
	showCopy = "0";
}
Hashtable tabAddList =null;
ArrayList tabRemoveList = null;


if(session.getAttribute(eid+"_Add")!=null){
	tabAddList = (Hashtable)session.getAttribute(eid+"_Add");
}else{
	tabAddList = new Hashtable();
	
}


if(session.getAttribute(eid+"_Remove")!=null){
	
	tabRemoveList = (ArrayList)session.getAttribute(eid+"_Remove");
}else{
	tabRemoveList = new ArrayList();
}

if(method.equals("add")||method.equals("edit")){
	Hashtable hasTabParam = new Hashtable();	
	hasTabParam.put("eid",eid+"");
	hasTabParam.put("viewType",viewType+"");
	hasTabParam.put("typeids",typeids);
	hasTabParam.put("flowids",flowids);
	hasTabParam.put("nodeids",nodeids);
	hasTabParam.put("isExclude",isExclude+"");
	hasTabParam.put("tabTitle",tabTitle);
	hasTabParam.put("tabId",tabId);
	hasTabParam.put("showCopy",showCopy);
	hasTabParam.put("completeflag",completeflag);
	tabAddList.put(tabId,hasTabParam);
	session.setAttribute(eid+"_Add",tabAddList);
}else if(method.equals("delete")){
	
	if(tabAddList.containsKey(tabId)){
		tabAddList.remove(tabId);	
	
	}
	tabRemoveList.add(tabId);
		
	session.setAttribute(eid+"_Remove",tabRemoveList);
}else if(method.equals("submit")){
	Enumeration e =tabAddList.elements();  
	while(e.hasMoreElements()){ 
		Hashtable hasParam = (Hashtable)e.nextElement();
		submitTabInfo(Util.getIntValue((String)hasParam.get("eid")),Util.getIntValue((String)hasParam.get("viewType")),(String)hasParam.get("typeids"),
			(String)hasParam.get("flowids"),(String)hasParam.get("nodeids"),Util.getIntValue((String)hasParam.get("isExclude")),
			(String)hasParam.get("tabTitle"),(String)hasParam.get("tabId"),(String)hasParam.get("showCopy"),Util.getIntValue((String)hasParam.get("completeflag"),0),statement,rs);
	} 
	for(int i=0;i<tabRemoveList.size();i++){

		rs.execute("delete from hpsetting_wfcenter where eid="+eid+" and tabId='"+tabRemoveList.get(i)+"'");
	}
	session.removeAttribute(eid+"_Add");
	session.removeAttribute(eid+"_Remove");
}else if(method.equals("cancel")){
	session.removeAttribute(eid+"_Add");
	session.removeAttribute(eid+"_Remove");
}



%>
<%! 
	public void submitTabInfo(int eid,int viewType,String typeids,String flowids,String nodeids, int isExclude, String tabTitle,String tabId,String showCopy,int completeflag, ConnStatement statement,RecordSet rs){
	
	rs.executeSql("select count(*) from hpsetting_wfcenter where eid="+eid+" and tabId='"+tabId+"'");
	rs.next();
	String strSql="";
	if((statement.getDBType()).equals("oracle")){  //oracle
		String strSqlIn="";
		try{
			if(rs.getInt(1)==0) { //insert
				 //strSql="insert into hpsetting_wfcenter (eid,viewType,typeids,flowids,nodeids,isExclude) values ("+eid+","+viewType+",'"+typeids+"','"+flowids+"','"+nodeids+"','"+isExclude+"')";	
				  strSqlIn = "insert into hpsetting_wfcenter (eid,viewType,typeids,flowids,nodeids,isExclude,tabId,tabTitle,showCopy,completeflag) values(?,?,empty_clob(),empty_clob(),empty_clob(),?,?,?,?,?) ";
			      statement.setStatementSql(strSqlIn);
			      statement.setInt(1,eid);
			      statement.setInt(2,viewType);
			      statement.setString(3,""+isExclude);
			      statement.setString(4,tabId);
			      statement.setString(5,tabTitle);
			      statement.setString(6,showCopy);
			      statement.setString(7,""+completeflag);
			      statement.executeUpdate();
	
		          strSqlIn = "select typeids,flowids,nodeids from hpsetting_wfcenter where eid = " +eid+" and tabId='"+tabId+"'";
		          statement.setStatementSql(strSqlIn, false);
		          statement.executeQuery();
		          statement.next();
		          
		          CLOB theclob = statement.getClob(1);
		          String typeids_temp = typeids; 
		          char[] contentchar = typeids_temp.toCharArray();
		          Writer contentwrite = theclob.getCharacterOutputStream();
		          contentwrite.write(contentchar);
		          contentwrite.flush();
		          contentwrite.close();
		          
		          
		          theclob = statement.getClob(2);
		          String flowids_temp = flowids; 
		          contentchar = flowids_temp.toCharArray();
		          contentwrite = theclob.getCharacterOutputStream();
		          contentwrite.write(contentchar);
		          contentwrite.flush();
		          contentwrite.close();
		          
		          theclob = statement.getClob(3);
		          String nodeids_temp = nodeids; 
		          contentchar = nodeids_temp.toCharArray();
		          contentwrite = theclob.getCharacterOutputStream();
		          contentwrite.write(contentchar);
		          contentwrite.flush();
		          contentwrite.close();          
			} else { //update
				strSqlIn="update hpsetting_wfcenter set viewType=?,typeids=empty_clob(),flowids=empty_clob(),nodeids=empty_clob(),isExclude=? , tabTitle=?, showCopy=?,completeflag=?  where eid=? and tabId=?";
				statement.setStatementSql(strSqlIn);
		     	statement.setInt(1,viewType);
		     	statement.setString(2,""+isExclude);
		      	statement.setString(3,tabTitle);	
		      	statement.setString(4,showCopy);
		      	statement.setString(5,""+completeflag);
		      	statement.setInt(6,eid);
		      	statement.setString(7,tabId);
		      	statement.executeUpdate();
	
		      	strSqlIn = "select typeids,flowids,nodeids from hpsetting_wfcenter where eid = " +eid+" and tabId='"+tabId+"'";
		        statement.setStatementSql(strSqlIn, false);
		        statement.executeQuery();
		        statement.next();
		        
		        CLOB theclob = statement.getClob(1);
		        String typeids_temp = typeids; 
		        char[] contentchar = typeids_temp.toCharArray();
		        Writer contentwrite = theclob.getCharacterOutputStream();
		        contentwrite.write(contentchar);
		        contentwrite.flush();
		        contentwrite.close();
		        
		        theclob = statement.getClob(2);
		        String flowids_temp = flowids; 
		        contentchar = flowids_temp.toCharArray();
		        contentwrite = theclob.getCharacterOutputStream();
		        contentwrite.write(contentchar);
		        contentwrite.flush();
		        contentwrite.close();
		        
		        theclob = statement.getClob(3);
		        String nodeids_temp = nodeids; 
		        contentchar = nodeids_temp.toCharArray();
		        contentwrite = theclob.getCharacterOutputStream();
		        contentwrite.write(contentchar);
		        contentwrite.flush();
		        contentwrite.close();        
			} 
		}catch(Exception ex){
			ex.printStackTrace();
		}
		statement.close();
	} else { //sqlserver
		tabTitle = tabTitle.replaceAll("'","''");
		if(rs.getInt(1)==0) { //insert
			strSql="insert into hpsetting_wfcenter (eid,viewType,typeids,flowids,nodeids,isExclude,tabId,tabTitle,showCopy,completeflag) values ("+eid+","+viewType+",'"+typeids+"','"+flowids+"','"+nodeids+"','"+isExclude+"','"+tabId+"','"+tabTitle+"','"+showCopy+"',"+completeflag+")";
		} else { //update
			strSql="update hpsetting_wfcenter set viewType="+viewType+",typeids='"+typeids+"',flowids='"+flowids+"',nodeids='"+nodeids+"',isExclude='"+isExclude+"', tabTitle='"+tabTitle+"', showCopy='"+showCopy+"', completeflag="+completeflag+" where eid="+eid+" and tabId ='"+tabId+"'";
		}
		rs.executeSql(strSql);
	}

	}
%>
<%


//strSql="update hpelement set strsqlwhere='"+viewType+"' where id="+eid;
//rs.executeSql(strSql);
%>