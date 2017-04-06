<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;


String method = Util.null2String(request.getParameter("method"));
String sql = "";
if(method.equals("TypeAdd")){
	String name = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("name"))),"'","''");
	String remark = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("remark"))),"'","''");
	
	int typeID = 0;
	sql = "insert into WebMagazineType(name,remark) values('" + name + "','" + remark + "')";
	
	RecordSet.executeSql(sql);
	sql = "select max(id) as id from WebMagazineType";
	RecordSet.executeSql(sql);
	if (RecordSet.next()) typeID = Util.getIntValue(RecordSet.getString("id"),0);
	response.sendRedirect("WebMagazineList.jsp?typeID=" + typeID);
	return;
}else
if(method.equals("TypeDel")){
	int typeID = Util.getIntValue(request.getParameter("typeID"),0);
	sql = "delete WebMagazineType where id = " + typeID;
	RecordSet.executeSql(sql);
	response.sendRedirect("WebMagazineTypeList.jsp");
	return;
}else
if(method.equals("TypeUpdate")){
	int typeID = Util.getIntValue(request.getParameter("typeID"),0);
	String name = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("name"))),"'","''");
	String remark = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("remark"))),"'","''");
	sql = "update WebMagazineType set name = '" + name + "',remark = '" + remark + "' where id = " + typeID;
	RecordSet.executeSql(sql);
	response.sendRedirect("WebMagazineList.jsp?typeID=" + typeID);
	return;
}else
if(method.equals("MagazineAdd")){
	String releaseYear = Util.null2String(request.getParameter("releaseYear"));
	String name = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("name"))),"'","''");
	String HeadDoc = Util.null2String(request.getParameter("HeadDoc"));
	int typeID =  Util.getIntValue(request.getParameter("typeID"),0);
	int totaldetail =  Util.getIntValue(request.getParameter("totaldetail"),0);
	int id = 0 ;
	sql = "insert into WebMagazine(typeID,releaseYear,name,docID,createDate) values(" + typeID + ",'" + releaseYear + "','" + name + "','"+HeadDoc+"','"+currentdate+"')";
	RecordSet.executeSql(sql);
	sql = "select max(id) as id from WebMagazine";
	RecordSet.executeSql(sql);
	if (RecordSet.next()) id = Util.getIntValue(RecordSet.getString("id"),0);
	String group = "";
	String groupIsView = "";
	String groupDocs = ""; 
	for (int i=0;i<totaldetail;i++)
	{
		group = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("node_"+i+"_group"))),"'","''");
		groupIsView = ""+Util.getIntValue(request.getParameter("node_"+i+"_isview"),0);
		groupDocs = request.getParameter("node_"+i+"_docs");
		
		if(!group.equals("")){
			sql = "insert into WebMagazineDetail(mainID,name,isView,docID) values(" + id + ",'" + group + "','"+groupIsView+"','"+groupDocs+"')";
			RecordSet.executeSql(sql);
		}
	}
	response.sendRedirect("WebMagazineView.jsp?id=" + id);
	return;
}else
if(method.equals("MagazineDel")){
	int typeID =  Util.getIntValue(request.getParameter("typeID"),0);
	int id = Util.getIntValue(request.getParameter("id"),0);
	sql = "delete WebMagazine where id = " + id;
	RecordSet.executeSql(sql);
	sql = "delete WebMagazineDetail where mainID = " + id;
	RecordSet.executeSql(sql);
	response.sendRedirect("WebMagazineList.jsp?typeID=" + typeID);
	return;
}else
if(method.equals("MagazineUpdate")){
	String releaseYear = Util.null2String(request.getParameter("releaseYear"));
	String name = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("name"))),"'","''");
	String HeadDoc = Util.null2String(request.getParameter("HeadDoc"));
	int typeID =  Util.getIntValue(request.getParameter("typeID"),0);
	int totaldetail =  Util.getIntValue(request.getParameter("totaldetail"),0);
	int id = Util.getIntValue(request.getParameter("id"),0);
	sql = "update WebMagazine set  releaseYear='" + releaseYear + "',name='" + name + "',docID='"+HeadDoc+"' where id = " + id ;
	RecordSet.executeSql(sql);
	String group = "";
	String groupIsView = "";
	String groupDocs = ""; 
	sql = "delete WebMagazineDetail where mainID = " + id;
	RecordSet.executeSql(sql);
	for (int i=0;i<totaldetail;i++)
	{
		group = Util.StringReplace(Util.toHtml2(Util.null2String(request.getParameter("node_"+i+"_group"))),"'","''");
		groupIsView = ""+Util.getIntValue(request.getParameter("node_"+i+"_isview"),0);
		groupDocs = Util.null2String(request.getParameter("node_"+i+"_docs"));
		if(!group.equals("")){		
			sql = "insert into WebMagazineDetail(mainID,name,isView,docID) values(" + id + ",'" + group + "','"+groupIsView+"','"+groupDocs+"')";
			RecordSet.executeSql(sql);
		}
	}
	response.sendRedirect("WebMagazineView.jsp?id=" + id); 
	return;
}  else if("typedel".equals(method)){
	String typeid = Util.null2String(request.getParameter("typeid"));
	// del WebMagazineType	
	RecordSet.executeSql("delete WebMagazineType where id="+typeid);

	// del WebMagazineDetail
	RecordSet.executeSql("select id from WebMagazine where typeID="+typeid);
	while(RecordSet.next()){
		int tempid=RecordSet.getInt("id");
		RecordSet1.executeSql("delete WebMagazineDetail where mainID="+tempid);
	}
	// del WebMagazine
	RecordSet.executeSql("delete WebMagazine where typeID="+typeid);
	response.sendRedirect("WebMagazineTypeList.jsp"); 
	return;

} else if ("del".equals(method)){
	String id = Util.null2String(request.getParameter("id"));
	String typeID = Util.null2String(request.getParameter("typeID"));

	// del WebMagazineDetail
	RecordSet1.executeSql("delete WebMagazineDetail where mainID="+id);
	// del WebMagazine
	RecordSet.executeSql("delete WebMagazine where id="+id);
	response.sendRedirect("WebMagazineList.jsp?typeID="+typeID); 
	return;

}

%>
