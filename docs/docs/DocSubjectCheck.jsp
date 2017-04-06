<%@ page language="java" contentType="text/xml; charset=UTF-8" %><?xml version="1.0" encoding="UTF-8"?>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet"%>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String subject= Util.null2String(request.getParameter("subject"));
subject=Util.toHtml(subject);
//String subject = java.net.URLDecoder.decode(Util.null2String(request.getParameter("subject")));
String secid = Util.null2String(request.getParameter("secid"));
String docid = Util.null2String(request.getParameter("docid"));

String sql = "";
boolean mainNoRepeatedName = false;
boolean subNoRepeatedName = false;
boolean secNoRepeatedName = false;

String subid = SecCategoryComInfo.getSubCategoryid(secid);
String mainid = SubCategoryComInfo.getMainCategoryid(subid);
if("".equals(mainid)){
	RecordSet.executeSql(" select t1.maincategoryid from DocSubCategory t1 left join DocSecCategory t2 on t1.subcategoryid = t2.subcategoryid where t2.id = "+secid);
	RecordSet.next();
	mainid = RecordSet.getString(1);
}
RecordSet.executeSql(" select norepeatedname from DocMainCategory where id = " + mainid);
RecordSet.next();
mainNoRepeatedName = (Util.getIntValue(RecordSet.getString("norepeatedname"),0)==1)?true:false;

subNoRepeatedName = (Util.getIntValue(SubCategoryComInfo.getNoRepeatedName(subid),0)==1)?true:false;;

secNoRepeatedName = SecCategoryComInfo.isNoRepeatedName(Util.getIntValue(secid));

if(secNoRepeatedName||subNoRepeatedName||mainNoRepeatedName){
    //sql = " select count(0) from DocDetail d where docsubject = '" + subject + "' ";
    sql = " select count(0) from DocDetail d where docsubject = '" + subject + "'   and (ishistory is null or ishistory = 0) ";
    if(mainNoRepeatedName) sql += " and maincategory = " + mainid;
    else if(subNoRepeatedName) sql += " and subcategory = " + subid;
    else if(secNoRepeatedName) sql += " and seccategory = " + secid;
    if(!"".equals(docid))
        sql += " and id not in " +
        	   " ( " +
        	   " select id from DocDetail " +
        	   " where id = " + docid +
        	   " or doceditionid in " + 
        	   " ( " +
        	   " select doceditionid from DocDetail " +
        	   " where id = " + docid +
        	   " and doceditionid > 0 " +
        	   " and (doceditionid is not null) " +
        	   " ) " +
        	   " ) ";
    
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
    	out.println("<num>");
    	out.println(RecordSet.getString(1));
    	out.println("</num>");
    } else {
    	out.println("<num>");
    	out.println(RecordSet.getString(1));
    	out.println("</num>");
    }
} else {
	out.println("<num>");
	out.println(0);
	out.println("</num>");
}
%>