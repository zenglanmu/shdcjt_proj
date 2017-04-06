<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<%
int fieldid = Util.getIntValue(request.getParameter("fieldid"), 0);
int childfieldid = Util.getIntValue(request.getParameter("childfieldid"), 0);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int selectvalue = Util.getIntValue(request.getParameter("selectvalue"), -1);
int childvalue = Util.getIntValue(request.getParameter("childvalue"), -1);
int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
int rowindex = Util.getIntValue(request.getParameter("rowindex"), 0);
String fieldname = "";
if(isdetail == 0){
	fieldname = "field"+childfieldid;
}else{
	fieldname = "field"+childfieldid+"_"+rowindex;
}
//System.out.println("fieldid = " + fieldid);
%>
<script type="text/javascript">
var childfieldValue = "<%=childvalue%>";
if(childfieldValue=="-1"){
	try{
		childfieldValue = window.parent.document.getElementById("<%=fieldname%>").value;
	}catch(e){
		childfieldValue = "";
	}
	if(childfieldValue==null || childfieldValue=="-1"){
		childfieldValue = "";
	}
}
var selectfield = null;
function getSelectField(){
	try{
		var elements = window.parent.document.getElementsByName("<%=fieldname%>");
		//alert(elements.length);
		if(elements.length==null){
			selectfield = elements;
		}else{
			for(var i=0; i<elements.length; i++) {
				try{
					//alert(elements[i]);
					//alert(elements[i].name);
					//alert(elements[i].tagName);
					if(elements[i].tagName=="SELECT"){
						selectfield = elements[i];
						break;
					}
				}catch(e){}
			}
		}
	}catch(e){}
	//alert(selectfield);
	//alert(selectfield.tagName);
}
function onChangeSelectField_All(){
	try{
		//var selectfield = window.parent.document.getElementById("<%=fieldname%>");
		if(selectfield != null){
			for(var i = selectfield.length-1; i>0; i--) {
				if (selectfield.options[i] != null){
					selectfield.options[i] = null;
				}
			}
			//selectfield = window.parent.document.getElementById("<%=fieldname%>");
			selectfield.options[0] = new Option("", "");
		}
	}catch(e){}
}
getSelectField();
if(selectfield != null){
	onChangeSelectField_All();
}
</script>
<%
String sql = "";
String changeSelectJSStr = "";
sql = "select childitemid from workflow_selectitem where fieldid="+fieldid+" and isbill="+isbill+" and selectvalue="+selectvalue;
rs.execute(sql);
if(rs.next()){
	String childitemid = Util.null2String(rs.getString("childitemid"));
	if(!"".equals(childitemid.trim())){
		if(!"".equals(childitemid)){
			if(childitemid.indexOf(",")==0){
				childitemid = childitemid.substring(1);
			}
			if(childitemid.endsWith(",")){
				childitemid = childitemid.substring(0, childitemid.length()-1);
			}
			int cx_tmp = 1;
			sql = "select id, selectvalue, selectname, listorder from workflow_selectitem where fieldid="+childfieldid+" and isbill="+isbill+" and selectvalue in ("+childitemid+")  and ( cancel!=1 or cancel is null) order by listorder, id asc";
			rs_item.execute(sql);
			while(rs_item.next()){
				String selectvalue_tmp = Util.null2String(rs_item.getString("selectvalue"));
				String selectname_tmp = Util.toScreen(rs_item.getString("selectname"), 7);
				changeSelectJSStr += ("selectfield.options["+cx_tmp+"] = new Option(\""+selectname_tmp+"\", \""+selectvalue_tmp+"\");\n");
				cx_tmp++;
			}
		}
	}
}
%>
<script type="text/javascript">
function insertSelect_All(){
	//var selectfield = null;
	var hasSelected = false;
	var fieldSpan;
	var viewtype;
	try{
		//selectfield = window.parent.document.getElementById("<%=fieldname%>");
		viewtype = selectfield.viewtype;
	}catch(e){
		viewtype = "0";
	}
	if(viewtype=="undefined" || viewtype==undefined){
		viewtype = "0";
	}
	try{
		selectfield.options[0] = new Option("", "");
		<%=changeSelectJSStr%>
		if(childfieldValue!=null && childfieldValue!=""){
			try{
				fieldSpan = window.parent.document.getElementById("<%=fieldname%>span");
				for(var i=selectfield.length-1; i>=0; i--){
					if (selectfield.options[i] != null){
						var value_tmp = selectfield.options[i].value;
						if(value_tmp==childfieldValue){
							selectfield.options[i].selected = true;
							hasSelected = true;
							fieldSpan.innerHTML = "";
							break;
						}
					}
				}
			}catch(e){}
		}
	}catch(e){}

	if(hasSelected==false && viewtype=="1"){
		try{
			fieldSpan = window.parent.document.getElementById("<%=fieldname%>span");
			fieldSpan.innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
		}catch(e){}
	}
}
if(selectfield != null){
	insertSelect_All();
}
</script>
