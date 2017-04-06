<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.servicefiles.ResetXMLFileCache"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String browserid = Util.null2String(request.getParameter("browserid"));
String customid = Util.null2String(request.getParameter("customid"));
String type = Util.null2String(request.getParameter("type"));
if(!browserid.equals("")&&!customid.equals("")&&!type.equals("")){
	String modeid = "";
	String formid = "";
	String titlename = "";
	String tablename = "";
	
	String sql = "select a.modeid,a.customname,a.customdesc,b.modename,b.formid from mode_custombrowser a,modeinfo b where a.modeid = b.id and a.id="+customid;
	rs.executeSql(sql);
	if(rs.next()){
		formid = Util.null2String(rs.getString("formid"));	
		modeid = Util.null2String(rs.getString("modeid"));
	}
	
	sql = "select tablename from workflow_bill where id = " + formid;
	rs.executeSql(sql);
	while(rs.next()){
		tablename = Util.null2String(rs.getString("tablename"));
	}
	
	sql = "select b.fieldname from mode_CustomBrowserDspField a,workflow_billfield b where a.fieldid = b.id and a.customid = "+customid+" and a.istitle = '1'";
	rs.executeSql(sql);
	while(rs.next()){
		titlename = Util.null2String(rs.getString("fieldname"));
	}
    
    String searchById = "select "+titlename+","+titlename+" from "+tablename+" where id=?";
    String search = "select id,"+titlename+","+titlename+" from "+tablename;
    String searchByName = "select id,"+titlename+","+titlename+" from "+tablename + " where " + titlename + " like ?";
    String outPageURL = "/formmode/browser/CommonSingleBrowser.jsp?customid="+customid;
    String from = "1";
    String href = "/formmode/view/AddFormMode.jsp?type=0&modeId="+modeid+"&formId="+formid+"&billid=";
    if(type.equals("2")){
    	outPageURL = "/formmode/browser/CommonMultiBrowser.jsp?customid="+customid;
    }
    String ds = "";
    String nameHeader = "";
    String descriptionHeader = "";

    Hashtable dataHST = new Hashtable();
    dataHST.put("ds",ds);
    dataHST.put("search",search);
    dataHST.put("searchById",searchById);
    dataHST.put("searchByName",searchByName);
    dataHST.put("nameHeader",nameHeader);
    dataHST.put("descriptionHeader",descriptionHeader);
    dataHST.put("outPageURL",outPageURL);
    dataHST.put("from",from);
    dataHST.put("href",href);

    ArrayList pointArrayList = BrowserXML.getPointArrayList();
    if(pointArrayList.indexOf(browserid)>-1){
%>
		<script type="text/javascript">
			location.href = "/formmode/browser/CreateBrowser.jsp?customid=<%=customid%>&browserid=<%=browserid%>&type=<%=type%>&flag=1";
		</script>
<%
    }else{
    	BrowserXML.writeToBrowserXMLAdd(browserid,dataHST);
    	ResetXMLFileCache.resetCache();
%>
		<script type="text/javascript">
			alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
			window.parent.close();
		</script>
<%
    }
}else{
%>
	<script type="text/javascript">
		location.href = "/formmode/browser/CreateBrowser.jsp?customid=<%=customid%>&browserid=<%=browserid%>&type=<%=type%>&flag=2";
	</script>
<%
}
%>

