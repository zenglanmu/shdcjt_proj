<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String operation = Util.null2String(request.getParameter("operation"));
String norightlist = Util.null2String(request.getParameter("norightlist"));
char separator = Util.getSeparator() ;

if(operation.equals("customadd"))
{
    String Customname = "" + Util.fromScreen(request.getParameter("Customname"),user.getLanguage());
	String modeid = "" + Util.getIntValue(request.getParameter("modeid"), 0);
    String Customdesc = "" + Util.fromScreen(request.getParameter("Customdesc"),user.getLanguage());
    
	RecordSet.execute("INSERT INTO mode_customsearch(modeid,customname,customdesc) VALUES ( "+ modeid + ", '" + Customname + "','"+Customdesc+"')");
    RecordSet.executeSql("select max(id) as id from mode_customsearch");
    RecordSet.next();
    String queryid = RecordSet.getString("id");
    String para = queryid  ;
    RecordSet.executeProc("mode_CustomDspField_Init",para);
	response.sendRedirect("/formmode/search/CustomSearchEdit.jsp?id="+queryid);
}
else if(operation.equals("customedit")){//保存对表单中流程的修改
	String id = ""+Util.getIntValue(request.getParameter("id"), 0);
    String Customname = "" + Util.fromScreen(request.getParameter("Customname"),user.getLanguage());
    String Customdesc = "" + Util.fromScreen(request.getParameter("Customdesc"),user.getLanguage());
    String disQuickSearch = "" + Util.fromScreen(request.getParameter("disQuickSearch"),user.getLanguage());
    String defaultsql = "" + Util.fromScreen(request.getParameter("defaultsql"),user.getLanguage());
	String modeid = Util.null2String(request.getParameter("modeid"));//如果模式id修改了，而且表单不一样，则删除原先的数据。
	String opentype = "" + Util.fromScreen(request.getParameter("opentype"),user.getLanguage());
	
	String sql = "";
	sql = "select * from modeinfo where id = "+modeid+" and formid in(select formid from mode_CustomSearch a,modeinfo b where a.modeid = b.id and a.id = "+id+")";
	rs.executeSql(sql);
	if(!rs.next()){
		sql = "delete from mode_CustomDspField where customid = " + id;
		rs.executeSql(sql);
	}
	RecordSet.execute("update mode_CustomSearch set norightlist='"+norightlist+"',defaultsql='"+defaultsql+"',disQuickSearch='"+disQuickSearch+"',Customname='"+Customname+"',Customdesc='"+Customdesc+"',modeid='"+modeid+"',opentype='"+opentype+"' where id="+id);
	response.sendRedirect("/formmode/search/CustomSearchEdit.jsp?id="+id);
}
else if(operation.equals("customdelete"))
{
  	int id = Util.getIntValue(request.getParameter("id"));
  	int modeid = Util.getIntValue(request.getParameter("modeid"));
  	String sql = "";
  	sql = "delete from mode_customsearch where id=" + id;
  	rs.execute(sql);
	sql = "delete from mode_CustomDspField where customid = " + id;
	rs.executeSql(sql);    
    response.sendRedirect("/formmode/search/CustomSearch.jsp?modeid="+modeid);
}
else if(operation.equals("formfieldadd"))
{
   
    int tmpcount=Util.getIntValue(request.getParameter("tmpcount"), 0);
    String id = Util.null2String(request.getParameter("id"));
    RecordSet.executeSql("delete from mode_CustomDspField where customid="+id);
  
    for(int i=0;i<=tmpcount;i++)
    {
        String fieldid = "" + Util.getIntValue(request.getParameter("fieldid_"+i),0);
        String dsporder = ""+Util.getIntValue(request.getParameter("dsporder_" + i),0);
        String isquery = Util.null2String(request.getParameter("isquery_" + i));
        String isshows = Util.null2String(request.getParameter("isshows_" + i));
        String queryorder = ""+Util.getIntValue(request.getParameter("queryorder_" + i),0);
        String istitle = ""+Util.getIntValue(request.getParameter("istitles_" + i),0);
        if (isquery.equals("")) {
            isquery = "0";
        }
        if (isshows.equals("")) {
            isshows = "0";
        }
        if (istitle.equals("")) {
        	istitle = "0";
        }
    	if(isquery.equals("1")||isshows.equals("1"))
    	{
      		String para = id + separator + fieldid  + separator + isquery + separator+ isshows + separator  + dsporder + separator +queryorder + separator + istitle;

      		RecordSet.executeProc("mode_CustomDspField_Insert",para);
   		}
    }
	response.sendRedirect("/formmode/search/CustomSearchEdit.jsp?id="+id);
}
else if(operation.equals("deletefield"))
{
  	String id = Util.null2String(request.getParameter("id"));
	String fieldID = "" + Util.getIntValue(request.getParameter("theid"), 0);
	RecordSet.execute("delete from mode_CustomDspField where id="+fieldID+" and customid="+id);
	response.sendRedirect("/formmode/search/CustomSearchEdit.jsp?id="+id);
}

%>