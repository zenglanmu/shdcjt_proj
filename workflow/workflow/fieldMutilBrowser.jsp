<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF="/css/Weaver.css"></HEAD>
<%
int wfid = Util.getIntValue(request.getParameter("workflowid"));
String oldfields = Util.null2String(request.getParameter("oldfields"));
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="fieldMutilBrowser.jsp" method=post>
<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
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
			<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1">
			<TR class=DataHeader>
			<TH width="10%"></TH>
			<TH width="90%"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TH>
			</TR>
			<TR class=Line><TH colspan="2" ></TH></TR> 
			<%
			int i=0;
			String sql = "";
			String isbill = "";
			String formid = "";

			RecordSet.executeSql("select formid,isbill from workflow_base where id="+wfid);
			if(RecordSet.next()){
				formid = RecordSet.getString("formid");
				isbill = RecordSet.getString("isbill");
			}
			if(isbill.equals("0")){//表单
					sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder, a.isdetail from workflow_formfield a, workflow_fieldlable b "+
						  " where a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage();
					if(RecordSet.getDBType().equals("oracle")){
						sql += " order by a.isdetail desc,a.fieldorder asc ";
					}else{    
						sql += " order by a.isdetail,a.fieldorder ";
					}
			}else if(isbill.equals("1")){//单据
				sql = "select id as fieldid,fieldlabel,viewtype as isdetail,dsporder as fieldorder, viewtype as isdetail from workflow_billfield where billid="+formid;
				sql += " order by viewtype,dsporder";
			}

			//out.println("sql:"+sql);
			RecordSet.execute(sql);
			while(RecordSet.next()){
				String fieldlablename = "";
				if(isbill.equals("1")){//单据无法将字段名称作为查询条件，在这里进行处理
					fieldlablename = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage());
				}else{
					fieldlablename = Util.null2String(RecordSet.getString("fieldlable"));
				}
				int id_tmp = Util.getIntValue(RecordSet.getString("fieldid"), 0);
				int isdetail_ = Util.getIntValue(RecordSet.getString("isdetail"), 0);
				String isdetailStr = "";
				if(isdetail_ == 1){
					isdetailStr = "(" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + ")";
				}
				String checkStr = "";
				if((","+oldfields+",").indexOf(","+id_tmp+",") > -1){
					checkStr = " checked ";
				}
				if(i==0){
					i=1;
			%>
			<TR class=DataLight>
			<%
				}else{
					i=0;
			%>
			<TR class=DataDark>
				<%
				}
				%>
				<TD><input class="Inputstyle" type="checkbox" value="<%=id_tmp%>" tempid="<%=id_tmp%>" id="checkbox_<%=id_tmp%>" name="checkboxfield" temptitle="<%=fieldlablename%><%=isdetailStr%>" <%=checkStr%>></TD>
				<TD>
					<%=fieldlablename%><%=isdetailStr%>
				</TD>
			</TR>
			<%}%>
			</TABLE>

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

</FORM>

</BODY>
</HTML>

<script language="javascript">
function onClear(){
     window.parent.returnValue = Array("","");
     window.parent.close();
}
function onSubmit(){
	var fields = "";
	var fieldnames = "";
	var fieldList = document.getElementsByName("checkboxfield");
	if(fieldList){
		for(var i=0; i<fieldList.length; i++){
			var fieldcheckbox = fieldList[i];
			if(fieldcheckbox.checked == true){
				fields = fields + fieldcheckbox.tempid + ",";
				fieldnames = fieldnames + fieldcheckbox.temptitle + ",";
			}
		}
		if(fields.length > 0){
			fields = fields.substring(0, fields.length-1);
			fieldnames = fieldnames.substring(0, fieldnames.length-1);
		}
	}
	window.parent.returnValue = Array(fields, fieldnames);
	window.parent.close();
}
function onClose()
{
	window.parent.close() ;
}
</script>