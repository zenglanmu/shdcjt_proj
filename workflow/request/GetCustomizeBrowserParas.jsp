<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.Writer"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
response.setContentType("text/xml;charset=UTF-8");
String formid=Util.getIntValue(request.getParameter("formid"),0)+"";
String isbill=Util.getIntValue(request.getParameter("isbill"),-1)+"";
String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
String browserType = Util.null2String(request.getParameter("browserType"));
String currenttime = Util.null2String(request.getParameter("currenttime"));
String frombrowserid = Util.null2String(request.getParameter("frombrowserid"));//触发字段id
String sql = "";

boolean ismainfiled = true;//是主字段
String detailrow = "";//如果是明字段，代表行号
String fromdetailtable = "";//如果是明字段，代表明细表
String fromfieldid = "";//触发字段id
String strs[] = frombrowserid.split("_");
if(strs.length==2){
	fromfieldid = strs[0];
	detailrow = strs[1];
	ismainfiled = false;
}else{
	fromfieldid = strs[0];
}
fromfieldid = fromfieldid.toLowerCase();
if(fromfieldid.indexOf("field")>=0){
	fromfieldid = fromfieldid.replace("field","");
}

ArrayList allFieldList = new ArrayList();//主字段
HashMap allField = new HashMap();//主字段
ArrayList needChangeField = new ArrayList();//需要转换的字段
String needChangeFieldString = "";
if(isbill.equals("1")){//单据
	sql = "select id,fieldname,detailtable from workflow_billfield where billid = "+formid;
	rs.executeSql(sql);
	while(rs.next()){
		String id = "field"+Util.null2String(rs.getString("id"));
		String fieldname = Util.null2String(rs.getString("fieldname")).toLowerCase();
		String detailtable = Util.null2String(rs.getString("detailtable")).toLowerCase();
		if(!detailtable.equals("")){
			detailtable = detailtable + "_";
		}
		if(id.equals("field"+fromfieldid)){
			fromdetailtable = detailtable;
		}
		fieldname = "$"+detailtable+fieldname+"$";
		allField.put(fieldname.toLowerCase(),id);
		System.out.println("all field: "+fieldname+"	####	"+id);
		allFieldList.add(fieldname);
	}
}else{//表单
	//主字段
	sql = "select b.id,b.fieldname from workflow_formfield a,workflow_formdict b where a.fieldid = b.id and formid = " + formid;
	rs.executeSql(sql);
	while(rs.next()){
		String id = "field"+Util.null2String(rs.getString("id"));
		String fieldname = "$"+Util.null2String(rs.getString("fieldname"))+"$";
		//System.out.println(id+"	"+fieldname);
		allField.put(fieldname.toLowerCase(),id);
		allFieldList.add(fieldname);
	}
	//明细字段
	sql = "select b.id,b.fieldname from workflow_formfield a,workflow_formdictdetail b where a.fieldid = b.id and formid = " + formid;
	rs.executeSql(sql);
	while(rs.next()){
		String id = "field"+Util.null2String(rs.getString("id"));
		String fieldname = "$detail_"+Util.null2String(rs.getString("fieldname"))+"$";
		if(id.equals("field"+fromfieldid)){
			fromdetailtable = "detail_";
		}
		//System.out.println(id+"	"+fieldname);
		allField.put(fieldname.toLowerCase(),id);
		allFieldList.add(fieldname);
	}
}

Browser browser=(Browser)StaticObj.getServiceByFullname(browserType, Browser.class);
String Search = browser.getSearch().toLowerCase();//
String SearchByName = browser.getSearchByName().toLowerCase();//

for(int i=0;i<allFieldList.size();i++){
	String fieldname = Util.null2String((String)allFieldList.get(i));
	int searchIndex = Search.indexOf(fieldname);
	int searchByNameIndex = SearchByName.indexOf(fieldname);
	//System.out.println(fieldname+"	"+searchIndex+"	"+searchByNameIndex);
	if(searchIndex>=0||searchByNameIndex>=0){
		String fieldid = Util.null2String((String)allField.get(fieldname));
		int isdetailfield = fieldname.indexOf(fromdetailtable);
		if(isdetailfield>=0&&!fromdetailtable.equals("")){
			fieldid = fieldid+"_"+detailrow;
		}
		needChangeFieldString += fieldid + ",";
	}
}
session.setAttribute("needChangeFieldString_"+workflowid+"_"+currenttime,needChangeFieldString);
session.setAttribute("allField_"+workflowid+"_"+currenttime,allField);
session.setAttribute("allFieldList_"+workflowid+"_"+currenttime,allFieldList);
%>
<value>
<%=needChangeFieldString%>
</value>