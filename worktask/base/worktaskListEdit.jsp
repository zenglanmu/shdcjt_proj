<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.field.FieldManager" scope="page" />
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
	String type = Util.null2String(request.getParameter("type"));
	String type1 = Util.null2String(request.getParameter("type1"));
	String type2 = Util.null2String(request.getParameter("type2"));
	String fielddec = Util.null2String(request.getParameter("fielddec"));
%>

<script language="javascript">
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_field_id') {
if(!document.form2.elements[i].disabled){
	document.form2.elements[i].checked=(checked==true?true:false);
}
} } }


function unselectall()
{
	if(document.form2.checkall0.checked){
	document.form2.checkall0.checked =0;
	}
}
function confirmdel() {
	len=document.form2.elements.length;
	var i=0;
	for(i=0;i<len;i++){
		if (document.form2.elements[i].name=='delete_field_id')
			if(document.form2.elements[i].checked)
				break;
	}
	if(i==len){
		alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		return false;
	}
	return confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>") ;
}

</script>
<body>
<br>
<%
	String fieldid=""+Util.getIntValue(request.getParameter("fieldid"),0);
	String fieldname=Util.null2String(request.getParameter("fieldname"));
	String fielddbtype=Util.null2String(request.getParameter("fielddbtype"));

	ArrayList idList = new ArrayList();
	ArrayList fieldnameList = new ArrayList();
	ArrayList descriptionList = new ArrayList();
	ArrayList crmnameList = new ArrayList();
	ArrayList isshowList = new ArrayList();
	ArrayList isshowlistList = new ArrayList();
	ArrayList widthList = new ArrayList();
	ArrayList wttypeList = new ArrayList();
	ArrayList ismandList = new ArrayList();
	ArrayList orderidlistList = new ArrayList();
	ArrayList isqueryList = new ArrayList();
	ArrayList isadvancedqueryList = new ArrayList();
	ArrayList needorderList = new ArrayList();
	ArrayList fielddbtypeList = new ArrayList();

	String sql = "select id, fieldname, description, crmname, isshow, wttype, ismand, isshowlist, width, orderidlist, isquery, isadvancedquery, needorder, fielddbtype from worktask_fielddict f left join worktask_taskfield t on f.id=t.fieldid and t.taskid="+wtid+" left join worktask_tasklist l on f.id=l.fieldid and l.taskid="+wtid+" where t.isshow=1 and f.fieldhtmltype<>6 order by wttype asc, isshowlist desc, orderidlist asc, id asc";//附件字段不在列表中显示
	//System.out.println(sql);
	String useids = "";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		idList.add(Util.null2String(RecordSet.getString("id")));
		fieldnameList.add(Util.null2String(RecordSet.getString("fieldname")));
		descriptionList.add(Util.null2String(RecordSet.getString("description")));
		crmnameList.add(Util.null2String(RecordSet.getString("crmname")));
		isshowList.add(Util.null2String(RecordSet.getString("isshow")));
		isshowlistList.add(Util.null2String(RecordSet.getString("isshowlist")));
		widthList.add(Util.null2String(RecordSet.getString("width")));
		wttypeList.add(Util.null2String(RecordSet.getString("wttype")));
		ismandList.add(Util.null2String(RecordSet.getString("ismand")));
		orderidlistList.add(Util.null2String(RecordSet.getString("orderidlist")));
		isqueryList.add(Util.null2String(RecordSet.getString("isquery")));
		isadvancedqueryList.add(Util.null2String(RecordSet.getString("isadvancedquery")));
		needorderList.add(Util.null2String(RecordSet.getString("needorder")));
		fielddbtypeList.add(Util.null2String(RecordSet.getString("fielddbtype")));
	}

%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<form name="formField" method="post" action="worktaskFieldOperation.jsp">
	<input type="hidden" name="mothed" value="">
	<input type="hidden" name="wtid" value="<%=wtid%>">
	<input type="hidden" name="wttype_delete" value="" >
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
if(wtid == 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(21930, user.getLanguage())+",javascript:newworktask(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showLog(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;

%>


<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<%
			for(int r=1; r<=3; r++){
				String title_tmp = "";
				if(r == 1){
					title_tmp = SystemEnv.getHtmlLabelName(21932,user.getLanguage());
				}else if(r == 2){
					title_tmp = SystemEnv.getHtmlLabelName(21935,user.getLanguage());
				}else{
					title_tmp = SystemEnv.getHtmlLabelName(21936,user.getLanguage());
				}
		%>
				<table class="viewForm">
					<COLGROUP>
					<COL width="25%">
					<COL width="75%">
					<TBODY>
					<TR class=Title>
						<TH><%=title_tmp%></TH>
						<TH><div align="right">
						</TH>
					</TR>
					<TR class=Spacing style="height: 1px">
						<TD class=Line1 colSpan=2></TD>
					</TR>
					</TBODY>
				</table>
			  <table class=liststyle cellspacing=1 id="table<%=r%>" >
				<COLGROUP>
				<COL width="14%">
				<COL width="14%">
				<COL width="14%">
				<COL width="8%">
				<COL width="8%">
				<COL width="8%">
				<COL width="13%">
				<COL width="14%">
				<COL width="8%">
			<tr class="Header">
				<td><%=SystemEnv.getHtmlLabelName(21933,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(21938,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(19509,user.getLanguage())%>(px)</td>
				<td><%=SystemEnv.getHtmlLabelName(21940,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(21941,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(15516,user.getLanguage())%></td>
			<TR class=Line><TD colspan="9" ></TD></TR>
				  <%
					int linecolor=0;
					for(int i=0; i<idList.size(); i++){
						String wttype = (String)wttypeList.get(i);
						if(!(""+r).equals(wttype)){
							continue;
						}
						String id = (String)idList.get(i);
						String crmname = Util.null2String((String)crmnameList.get(i));
						String isshowlist = Util.null2String((String)isshowlistList.get(i));
						String ismand = Util.null2String((String)ismandList.get(i));
						int orderidlist = Util.getIntValue((String)orderidlistList.get(i), 0);
						int width = Util.getIntValue((String)widthList.get(i), 0);
						int needorder = Util.getIntValue((String)needorderList.get(i), 0);
						String fielddbtype_tmp = Util.null2String((String)fielddbtypeList.get(i));
						String isdquery = Util.null2String((String)isqueryList.get(i));
						String isadvancedquery = Util.null2String((String)isadvancedqueryList.get(i));
						String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
						String disabled_remindnum = "";
						if("remindnum".equalsIgnoreCase(fieldname_tmp)){
							disabled_remindnum = "disabled=true";
							isdquery = "0";
							isadvancedquery = "0";
						}
						if(("2").equals(wttype) || ("3").equals(wttype)){
							disabled_remindnum = "disabled=true";
						}
						String canOrderStr = "";
						if("text".equalsIgnoreCase(fielddbtype_tmp)){
							canOrderStr = " disabled ";
						}
				  %>
				<tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
					<td>
						<input type="hidden"  name="fieldid" value="<%=id%>" >
						<%=fieldname_tmp%>
					</td>
					<td><%=Util.toScreen((String)descriptionList.get(i), user.getLanguage())%></td>
					<td><%=Util.toScreen(crmname, user.getLanguage())%></td>
					<td>
					<%if("1".equals(ismand)){%>
						<input type="checkbox"  name="isshowlistdis_<%=id%>" value="1" disabled=true checked=true>
						<input type="hidden" name="isshowlist_<%=id%>" value="1" >
					<%}else{%>
						<input type="checkbox"  name="isshowlist_<%=id%>" value="1" onClick="changeShow(this)" <%if("1".equals(isshowlist)){%>checked<%}%>>
					<%}%>
					</td>
					<td><input class=Inputstyle type="text" name="orderidlist_<%=id%>" size="4" maxlength="2" onKeyPress="ItemCount_KeyPress_self(event)" value="<%=orderidlist%>"></td>
					<td><input class=Inputstyle type="text" name="width_<%=id%>" size="5" maxlength="3" onKeyPress="ItemCount_KeyPress_self(event)" value="<%=width%>"></td>
					<td><input type="checkbox"  name="isquery_<%=id%>" value="1" onClick="changeIsquery(this)" <%if("1".equals(isdquery)){%>checked<%}%> <%=disabled_remindnum%>>
					</td>
					<td><input type="checkbox"  name="isadvancedquery_<%=id%>" value="1" onClick="changeIsadvancedquery(this)" <%if("1".equals(isadvancedquery)){%>checked<%}%> <%=disabled_remindnum%>>
					</td>
					<td><input type="checkbox"  name="needorder_<%=id%>" value="1"  <%if(needorder==1){%>checked<%}%> <%=canOrderStr%>>
					</td>
					</tr>
				<%
					if(linecolor==0) linecolor=1;
						else linecolor=0;
					}
				  %>
			  </table>
			  <P>
		<%}%>
	  </td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


</form>
<script language="javascript">
function saveData(){
	formField.mothed.value="savelist";
	formField.submit();
}
function newworktask(){
	parent.location.href = "worktaskAdd.jsp?isnew=1";
}
function showLog(){


}
function changeShow(obj){
	//alert(obj.checked);
	if(obj.checked == false){
		//alert(obj.parentElement.parentElement.children(5).children(0).checked);
		//obj.parentElement.parentElement.children(5).children(0).checked = false;
		//obj.parentElement.parentElement.children(6).children(0).checked = false;
		
		jQuery(jQuery(obj).parents("tr:first").children()[5]).children()[0].checked=false;
		jQuery(jQuery(obj).parents("tr:first").children()[6]).children()[0].checked=false;
		
	}
}
function changeIsquery(obj){
	if(obj.checked == true){
		//obj.parentElement.parentElement.children(3).children(0).checked = true;
		jQuery(jQuery(obj).parents("tr:first").children()[3]).children()[0].checked=true;
	}else{
		//obj.parentElement.parentElement.children(7).children(0).checked = false;
		jQuery(jQuery(obj).parents("tr:first").children()[7]).children()[0].checked=false;
	}
	//alert(obj.parentElement.parentElement.children(3).children(0).checked);
}
function changeIsadvancedquery(obj){
	if(obj.checked == true){
		//obj.parentElement.parentElement.children(3).children(0).checked = true;
		//obj.parentElement.parentElement.children(6).children(0).checked = true;
		
		jQuery(jQuery(obj).parents("tr:first").children()[3]).children()[0].checked=true;
		jQuery(jQuery(obj).parents("tr:first").children()[6]).children()[0].checked=true;
	}
	//alert(obj.parentElement.parentElement.children(3).children(0).checked);
}
function addrow(wttype){
	location.href="fieldAdd.jsp?wtid=<%=wtid%>&wttype="+wttype;
}
function delrow(wttype){
	if(confirm("<%=SystemEnv.getHtmlLabelName(21939,user.getLanguage())%>")){
		formField.wttype_delete.value = wttype;
		formField.mothed.value="delete";
		formField.submit();
	}
}
function ItemCount_KeyPress_self(event){
    event = event || window.event
	if(!((event.keyCode>=48) && (event.keyCode<=57))){
		event.keyCode=0;
	}
}

function useSetto(){
	url=escape("/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=1");
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, window);
}
</script>

<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<script type="text/javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</body>
</html>