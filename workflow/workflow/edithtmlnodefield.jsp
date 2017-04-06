<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<%
//把权限判断放到最上面，不影响下面的初始化对象、参数
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<jsp:useBean id="WFNodeFieldMainManager2" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<%WFNodeFieldMainManager.resetParameter();%>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<%FormFieldMainManager.resetParameter();
FormFieldMainManager.setIsHtmlMode(1);
%>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%WFNodeDtlFieldManager.resetParameter();%>
<%
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
int ajax = Util.getIntValue(request.getParameter("ajax"), 0);
int needprep = Util.getIntValue(request.getParameter("needprep"), 0);
int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
int design = Util.getIntValue(request.getParameter("design"), 0);
String nodetype = "";
rs.execute("select nodetype from workflow_flownode where nodeid="+nodeid);
if(rs.next()){
	nodetype = ""+Util.getIntValue(rs.getString("nodetype"), 0);
}
int colsperrow = 1;
rs.execute("select colsperrow from workflow_flownodehtml where workflowid="+wfid+" and nodeid="+nodeid);
if(rs.next()){
	colsperrow = Util.getIntValue(rs.getString("colsperrow"), 1);
}
WFManager.setWfid(wfid);
WFManager.getWfInfo();
int formid = WFManager.getFormid();
String isbill = ""+Util.getIntValue(WFManager.getIsBill(), 0);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23689,user.getLanguage());
String needfav ="";
String needhelp ="";
if(ajax == 0){
%>
<HTML>
<HEAD>
<link href="/css/Weaver.css" type="text/css" rel=STYLESHEET>
<script type="text/javascript" language="javascript" src="/js/weaver.js"></script>
<TITLE></TITLE>
</HEAD>
<BODY>
<%}%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(ajax == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(23690,user.getLanguage())+",javascript:prepShowHtml("+formid+","+wfid+","+nodeid+","+isbill+",0,"+ajax+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(ajax == 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldbatchsave(),_self} " ;
}
RCMenuHeight += RCMenuHeightStep;


if(ajax == 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_self} " ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelBatchSet("+nodeid+"),_self} " ;
}
RCMenuHeight += RCMenuHeightStep;

if(ajax == 1){
%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}%>
<form id="nodefieldhtml" name="nodefieldhtml" method="post" action="wf_operation.jsp"  target="_self">
<input type="hidden" id="ajax" name="ajax" value="<%=ajax%>">
<input type="hidden" id="src" name="src" value="nodefieldhtml">
<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid%>">
<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
<input type="hidden" id="formid" name="formid" value="<%=formid%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<input type="hidden" id="needprep" name="needprep" value="0">
<input type="hidden" id="modeid" name="modeid" value="<%=modeid%>">
<input type="hidden" id="needcreatenew" name="needcreatenew" value="0">
<input type="hidden" id="nodetype" name="nodetype" value="<%=nodetype%>">
<input type="hidden" id="design" name="design" value="<%=design%>">
<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
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

  <table class=liststyle cellspacing=1 id="tab_dtl_list-1">
	<COLGROUP>
	<COL width="20%">
	<COL width="20%">
	<COL width="20%">
	<COL width="20%">
	<COL width="20%">
  	<TR height="10">
		<TD colSpan=5></TD>
	</TR>
	<tr>
		<td colspan="5">
		<table class="viewform" cellspacing="1">
			<COLGROUP>
			<COL width="30%">
			<COL width="40%">
			<COL width="30%">
			<tr>
				<td class="field"><strong><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%><strong></td>
				<td class="field"><%=SystemEnv.getHtmlLabelName(23692,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
					<select id="colsperrow" name="colsperrow" style="width:50px">
						<option value="1" <%if(colsperrow==1){out.print(" selected ");}%>>1</option>
						<option value="2" <%if(colsperrow==2){out.print(" selected ");}%>>2</option>
						<option value="3" <%if(colsperrow==3){out.print(" selected ");}%>>3</option>
						<option value="4" <%if(colsperrow==4){out.print(" selected ");}%>>4</option>
					</select>
				</td>
				<td class="field" align="right">
				<%if(ajax == 1){%>
					<a href="javascript:prepShowHtml(<%=formid%>,<%=wfid%>,<%=nodeid%>,<%=isbill%>,0,<%=ajax%>)"><%=SystemEnv.getHtmlLabelName(23690,user.getLanguage())%></a>
				<%}%>
				&nbsp;&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
		</table>
		</td>
	</tr> 
	<TR><TD class="Line1" colSpan=5></TD></TR>
	<tr class=header>
			<td>
				<%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%>
			</td>
			<td>
				<input type="checkbox" name="title_viewall"  onClick="if(this.checked==false){document.nodefieldhtml.title_editall.checked=false;document.nodefieldhtml.title_manall.checked=false;};onChangeViewAll(-1,this.checked)" >
				<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%>
			</td>
			<td>
				<input type="checkbox" name="title_editall"  onClick="if(this.checked==true){document.nodefieldhtml.title_viewall.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.title_manall.checked=false;};onChangeEditAll(-1,this.checked)">
				<%=SystemEnv.getHtmlLabelName(15604,user.getLanguage())%>
			</td>
			<td>
				<input type="checkbox" name="title_manall"  onClick="if(this.checked==true){document.nodefieldhtml.title_viewall.checked=(this.checked==true?true:false);document.nodefieldhtml.title_editall.checked=(this.checked==true?true:false);};onChangeManAll(-1,this.checked)" >
				<%=SystemEnv.getHtmlLabelName(15605,user.getLanguage())%>
			</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(23691,user.getLanguage())%>
			</td>
</tr><TR class=Line ><TD colSpan=5></TD></TR>

<!--xwj for td1834 on 2005-05-18  begin -->
<%
int linecolor=0;
if(nodeid!=-1&&1==2){
	boolean isEndNode = false;
	if(nodetype.equals("3")){
		 isEndNode = true;
	}
	String view="";
	String edit="";
	String man="";
	String orderid="";
	WFNodeFieldMainManager.resetParameter();
	WFNodeFieldMainManager.setNodeid(nodeid);
	WFNodeFieldMainManager.setFieldid(-1);//"流程标题"字段在workflow_nodeform中的fieldid 定为 "-1"
	WFNodeFieldMainManager.selectWfNodeField();
	orderid = WFNodeFieldMainManager.getOrderid();
	if(WFNodeFieldMainManager.getIsview().equals("")){
		view = " checked ";
		WFNodeFieldMainManager.setIsview("1");
		orderid = "0.0";
	}else{
		if(WFNodeFieldMainManager.getIsview().equals("1"))
		view=" checked";
		if(WFNodeFieldMainManager.getIsedit().equals("1"))
		edit=" checked";
		if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
		man=" checked";
	}
	if(isEndNode){
		edit = "";
		man = "";
	}
	%>
	<tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
		<td><input type="checkbox" name="title_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.title_edit0.checked=false;document.nodefieldhtml.title_man0.checked=false;}"  ></td>
		<td><input type="checkbox" name="title_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.title_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.title_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
		<td><input type="checkbox" name="title_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.title_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.title_edit0.checked=(this.checked==true?true:false);}" <%if(isEndNode){%>disabled<%}%>></td>
		<td><input type="text" class="Inputstyle" name="title_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
	</tr>
<%
	if(linecolor==0) {
		linecolor=1;
	}else{
		linecolor=0;
	}
	WFNodeFieldMainManager.closeStatement();
}
if(nodeid!=-1&&1==2){
	boolean isEndNode = false;
	if(nodetype.equals("3")){
		isEndNode = true;
	}
	String view="";
	String edit="";
	String man="";
	String orderid="";
	WFNodeFieldMainManager.resetParameter();
	WFNodeFieldMainManager.setNodeid(nodeid);
	WFNodeFieldMainManager.setFieldid(-2);//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
	WFNodeFieldMainManager.selectWfNodeField();
	orderid = WFNodeFieldMainManager.getOrderid();
	if(WFNodeFieldMainManager.getIsview().equals("")){
		view = " checked ";
		WFNodeFieldMainManager.setIsview("1");
		orderid = "1.0";
	}else{
	   if(WFNodeFieldMainManager.getIsview().equals("1"))
		  view=" checked";
	   if(WFNodeFieldMainManager.getIsedit().equals("1"))
		  edit=" checked";
	   if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
		  man=" checked";
	}
	if(isEndNode){
	   edit = "";
	   man = "";
	}
	%>
	 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
			<td><input type="checkbox" name="level_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.level_edit0.checked=false;document.nodefieldhtml.level_man0.checked=false;}" ></td>
			<td><input type="checkbox" name="level_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.level_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.level_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
			<td><input type="checkbox" name="level_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.level_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.level_edit0.checked=(this.checked==true?true:false);}" <%if(isEndNode){%>disabled<%}%>></td>
			<td><input type="text" class="Inputstyle" name="level_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
  </tr>
<%
	if(linecolor==0) {
		linecolor=1;
	}
	else{
		linecolor=0;
	}

	WFNodeFieldMainManager.closeStatement();
	}
	String messageType = WFManager.getMessageType();
	if(nodeid!=-1&&messageType.equals("1")&&1==2){
		boolean isEndNode = false;
		if(nodetype.equals("3")){
			isEndNode = true;
		}
		String view="";
		String edit="";
		String man="";
		String orderid="";
		WFNodeFieldMainManager.resetParameter();
		WFNodeFieldMainManager.setNodeid(nodeid);
		WFNodeFieldMainManager.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
		WFNodeFieldMainManager.selectWfNodeField();
		orderid = WFNodeFieldMainManager.getOrderid();
		if(WFNodeFieldMainManager.getIsview().equals("")){
			view = " checked ";
			WFNodeFieldMainManager.setIsview("1");
			orderid = "2.0";
		}else{
		   if(WFNodeFieldMainManager.getIsview().equals("1"))
			  view=" checked";
		   if(WFNodeFieldMainManager.getIsedit().equals("1"))
			  edit=" checked";
		   if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
			  man=" checked";
		}
		if(isEndNode){
		   edit = "";
		   man = "";
		}
%>
	 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%></td>
			<td><input type="checkbox" name="ismessage_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.ismessage_edit0.checked=false;document.nodefieldhtml.ismessage_man0.checked=false;}"  ></td>
			<td><input type="checkbox" name="ismessage_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.ismessage_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.ismessage_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
			<td><input type="checkbox" name="ismessage_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.ismessage_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.ismessage_edit0.checked=(this.checked==true?true:false);}" <%if(isEndNode){%>disabled<%}%>></td>
			<td><input type="text" class="Inputstyle" name="ismessage_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
  </tr>
<%
	if(linecolor==0) {
		linecolor=1;
	}
	else{
		linecolor=0;
	}
	WFNodeFieldMainManager.closeStatement();
}
%>
<!--xwj for td1834 on 2005-05-18  end -->

<%
//初始化标题、紧急程度、是否短信提醒
String fieldSql = "select fieldid from workflow_nodeform t1 where t1.nodeid=" + nodeid + " and fieldid in (-1, -2, -3)";
RecordSet.executeSql(fieldSql);
if (!RecordSet.next()) {
	for (int k=-1; k>-4; k--) {
		RecordSet.executeSql("insert into workflow_nodeform(nodeid, fieldid) values(" + nodeid + ", " + k + ")");
	}
}

if(nodeid!=-1 && isbill.equals("0")){
	
//int linecolor=0; xwj for td1834 on 2005-05-18
	FormFieldMainManager.setFormid(formid);
	FormFieldMainManager.setNodeid(nodeid);
	FormFieldMainManager.selectFormFieldLableForHtml();
	int groupid=-1;
	String dtldisabled="";
	while(FormFieldMainManager.next()){
		int curid=FormFieldMainManager.getFieldid();
		if(curid==-1){
			boolean isEndNode = false;
			if(nodetype.equals("3")){
				 isEndNode = true;
			}
			String view="";
			String edit="";
			String man="";
			String orderid="";
			WFNodeFieldMainManager2.resetParameter();
			WFNodeFieldMainManager2.setNodeid(nodeid);
			WFNodeFieldMainManager2.setFieldid(-1);//"流程标题"字段在workflow_nodeform中的fieldid 定为 "-1"
			WFNodeFieldMainManager2.selectWfNodeField();
			orderid = WFNodeFieldMainManager2.getOrderid();
			if(WFNodeFieldMainManager2.getIsview().equals("")){
				view = " checked ";
				WFNodeFieldMainManager2.setIsview("1");
				orderid = "0.0";
			}else{
				if(WFNodeFieldMainManager2.getIsview().equals("1"))
				view=" checked";
				if(WFNodeFieldMainManager2.getIsedit().equals("1"))
				edit=" checked";
				if(WFNodeFieldMainManager2.getIsmandatory().equals("1"))
				man=" checked";
			}
			if(isEndNode){
				edit = "";
				man = "";
			}
	%>
	<tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
		<td><input type="checkbox" name="title_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.title_edit0.checked=false;document.nodefieldhtml.title_man0.checked=false;}"  ></td>
		<td><input type="checkbox" name="title_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.title_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.title_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
		<td><input type="checkbox" name="title_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.title_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.title_edit0.checked=(this.checked==true?true:false);}" <%if(isEndNode){%>disabled<%}%>></td>
		<td><input type="text" class="Inputstyle" name="title_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
	</tr>
<%
			if(linecolor==0) {
				linecolor=1;
			}else{
				linecolor=0;
			}
			WFNodeFieldMainManager2.closeStatement();
			continue;
		}else if(curid==-2){
		
			boolean isEndNode = false;
			if(nodetype.equals("3")){
				isEndNode = true;
			}
			String view="";
			String edit="";
			String man="";
			String orderid="";
			WFNodeFieldMainManager2.resetParameter();
			WFNodeFieldMainManager2.setNodeid(nodeid);
			WFNodeFieldMainManager2.setFieldid(-2);//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
			WFNodeFieldMainManager2.selectWfNodeField();
			orderid = WFNodeFieldMainManager2.getOrderid();
			if(WFNodeFieldMainManager2.getIsview().equals("")){
				view = " checked ";
				WFNodeFieldMainManager2.setIsview("1");
				orderid = "1.0";
			}else{
			   if(WFNodeFieldMainManager2.getIsview().equals("1"))
				  view=" checked";
			   if(WFNodeFieldMainManager2.getIsedit().equals("1"))
				  edit=" checked";
			   if(WFNodeFieldMainManager2.getIsmandatory().equals("1"))
				  man=" checked";
			}
			if(isEndNode){
			   edit = "";
			   man = "";
			}
	%>
	 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
			<td><input type="checkbox" name="level_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.level_edit0.checked=false;document.nodefieldhtml.level_man0.checked=false;}" ></td>
			<td><input type="checkbox" name="level_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.level_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.level_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
			<td><input type="checkbox" name="level_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.level_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.level_edit0.checked=(this.checked==true?true:false);}" <%if(isEndNode){%>disabled<%}%>></td>
			<td><input type="text" class="Inputstyle" name="level_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
  </tr>
<%
			if(linecolor==0) {
				linecolor=1;
			}
			else{
				linecolor=0;
			}

			WFNodeFieldMainManager2.closeStatement();
	
			continue;
		}else if(curid==-3){
			if(!messageType.equals("1")) continue;
			boolean isEndNode = false;
			if(nodetype.equals("3")){
			 isEndNode = true;
			}
			String view="";
			String edit="";
			String man="";
			String orderid="";
			WFNodeFieldMainManager2.resetParameter();
			WFNodeFieldMainManager2.setNodeid(nodeid);
			WFNodeFieldMainManager2.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
			WFNodeFieldMainManager2.selectWfNodeField();
			orderid = WFNodeFieldMainManager2.getOrderid();
			if(WFNodeFieldMainManager2.getIsview().equals("")){
				view = " checked ";
				WFNodeFieldMainManager2.setIsview("1");
				orderid = "2.0";
			}else{
			   if(WFNodeFieldMainManager2.getIsview().equals("1"))
				  view=" checked";
			   if(WFNodeFieldMainManager2.getIsedit().equals("1"))
				  edit=" checked";
			   if(WFNodeFieldMainManager2.getIsmandatory().equals("1"))
				  man=" checked";
			}
			if(isEndNode){
			   edit = "";
			   man = "";
			}
	%>
	 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%></td>
			<td><input type="checkbox" name="ismessage_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.ismessage_edit0.checked=false;document.nodefieldhtml.ismessage_man0.checked=false;}"  ></td>
			<td><input type="checkbox" name="ismessage_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.ismessage_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.ismessage_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
			<td><input type="checkbox" name="ismessage_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.ismessage_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.ismessage_edit0.checked=(this.checked==true?true:false);}" <%if(isEndNode){%>disabled<%}%>></td>
			<td><input type="text" class="Inputstyle" name="ismessage_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
  </tr>
<%
			if(linecolor==0) {
				linecolor=1;
			}
			else{
				linecolor=0;
			}
			WFNodeFieldMainManager2.closeStatement();
		
			continue;
		}else if(curid==-4){
			boolean isEndNode = true;
			String view="";
			String edit="";
			String man="";
			String orderid="";
			WFNodeFieldMainManager2.resetParameter();
			WFNodeFieldMainManager2.setNodeid(nodeid);
			WFNodeFieldMainManager2.setFieldid(-4);//"签字意见"字段在workflow_nodeform中的fieldid 定为 "-4"
			WFNodeFieldMainManager2.selectWfNodeField();
			orderid = WFNodeFieldMainManager2.getOrderid();
			if(WFNodeFieldMainManager2.getIsview().equals("")){
				view = " checked ";
				WFNodeFieldMainManager2.setIsview("1");
				orderid = "4.0";
			}else{
				if(WFNodeFieldMainManager2.getIsview().equals("1"))
					view=" checked";
				if(WFNodeFieldMainManager2.getIsedit().equals("1"))
					edit=" checked";
				if(WFNodeFieldMainManager2.getIsmandatory().equals("1"))
					man=" checked";
			}
			if(isEndNode){
			   edit = "";
			   man = "";
			}
	%>
	 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
			<td><input type="checkbox" id="isremark_view0" name="isremark_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.isremark_edit0.checked=false;document.nodefieldhtml.isremark_man0.checked=false;}"  ></td>
			<td><input type="checkbox" id="isremark_edit0" name="isremark_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.isremark_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.isremark_man0.checked=false;}" disabled ></td>
			<td><input type="checkbox" id="isremark_man0" name="isremark_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.isremark_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.isremark_edit0.checked=(this.checked==true?true:false);}" disabled></td>
			<td><input type="text" class="Inputstyle" name="isremark_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
  </tr>
<%
			if(linecolor==0) {
				linecolor=1;
			}
			else{
				linecolor=0;
			}
			WFNodeFieldMainManager2.closeStatement();
		
			continue;
		}
		String fieldname=FieldComInfo.getFieldname(""+curid);
		//if (fieldname.equals("manager")) continue;//字段为“manager”这个字段是程序后台所用，不必做必填之类的设置!
		String fieldhtmltype = FieldComInfo.getFieldhtmltype(""+curid);
		String curlable = FormFieldMainManager.getFieldLable();
		int curgroupid=FormFieldMainManager.getGroupid();
		//表单头group值为－1，会引起拼装checkbox语句的脚本错误，这里简单的处理为999
		if(curgroupid==-1) curgroupid=999;
		String isdetail = FormFieldMainManager.getIsdetail();
		WFNodeFieldMainManager.resetParameter();
		WFNodeFieldMainManager.setNodeid(nodeid);
		WFNodeFieldMainManager.setFieldid(curid);
		WFNodeFieldMainManager.selectWfNodeField();
		String view="";
		String edit="";
		String man="";
		String orderid = "";
		if(isdetail.equals("1") && curgroupid>groupid) {
			groupid=curgroupid;

			WFNodeDtlFieldManager.setNodeid(nodeid);
			WFNodeDtlFieldManager.setGroupid(curgroupid);
			WFNodeDtlFieldManager.selectWfNodeDtlField();

			String dtladd = WFNodeDtlFieldManager.getIsadd();
			if(dtladd.equals("1")) dtladd=" checked";

			String dtledit = WFNodeDtlFieldManager.getIsedit();
			if(dtledit.equals("1")) dtledit=" checked";

			String dtldelete = WFNodeDtlFieldManager.getIsdelete();
			if(dtldelete.equals("1")) dtldelete=" checked";

			String dtlhide = WFNodeDtlFieldManager.getIshide();
			if(dtlhide.equals("1")) dtlhide=" checked";
			
			String dtldefault = WFNodeDtlFieldManager.getIsdefault();
        	if(dtldefault.equals("1")) dtldefault=" checked";
        	
            String dtlneed = WFNodeDtlFieldManager.getIsneed();
        	if(dtlneed.equals("1")) dtlneed=" checked";

			if(!dtladd.equals(" checked") && !dtledit.equals(" checked")) 
				dtldisabled="disabled";
			else
				dtldisabled="";
		%>
		</table>
		<table class=viewform cellspacing=1 id="tab_dtl_<%=groupid%>" name="tab_dtl_'<%=groupid%>'">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<tr>
				<td class=field colSpan=2><strong><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid+1%><strong></td>
			</tr>	
			<TR><TD class="Line1" colSpan=2></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="dtl_add_<%=groupid%>" onClick="checkChange2('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>></td>
				<!--'<%=String.valueOf(groupid)%>'-->
			</tr>	
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange2('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>></td>
			</tr>	
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>></td>
			</tr>	
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			<%
            if(!nodetype.equals("3"))
            {
            %>
            <tr>
                <td><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></td>
                <td class=field><input type="checkbox"  name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>></td>
            </tr>
            <TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
            <tr>
                <td><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></td>
                <td class=field><input type="checkbox" name="dtl_def_<%=groupid%>" onClick="" <%=dtldefault%>></td>
            </tr>
            <TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
            <%
            }
            %>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="hide_del_<%=groupid%>" onClick="" <%=dtlhide%>></td>
			</tr>	
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			</table>
			<table class=liststyle cellspacing=1 id="tab_dtl_list<%=groupid%>" name="tab_dtl_list<%=groupid%>">
			<COLGROUP>
			<COL width="20%">
			<COL width="20%">
			<COL width="20%">
			<COL width="20%">
			<COL width="20%">
			<tr class=header>
				<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
			<td>
				<input type="checkbox" name="title_viewall<%=groupid%>"  onClick="if(this.checked==false){document.nodefieldhtml.title_editall<%=groupid%>.checked=false;document.nodefieldhtml.title_manall<%=groupid%>.checked=false;};onChangeViewAll(<%=curgroupid%>,this.checked)" >
				<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%>
			</td>
			<td>
				<input type="checkbox" name="title_editall<%=groupid%>"  onClick="if(this.checked==true){document.nodefieldhtml.title_viewall<%=groupid%>.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.title_manall<%=groupid%>.checked=false;};onChangeEditAll(<%=curgroupid%>,this.checked)" <%=dtldisabled%>>
				<%=SystemEnv.getHtmlLabelName(15604,user.getLanguage())%>
			</td>
			<td>
				<input type="checkbox" name="title_manall<%=groupid%>"  onClick="if(this.checked==true){document.nodefieldhtml.title_viewall<%=groupid%>.checked=(this.checked==true?true:false);document.nodefieldhtml.title_editall<%=groupid%>.checked=(this.checked==true?true:false);};onChangeManAll(<%=curgroupid%>,this.checked)" <%=dtldisabled%>>
				<%=SystemEnv.getHtmlLabelName(15605,user.getLanguage())%>
			</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(23691,user.getLanguage())%>
			</td>
			</tr><TR class=Line ><TD colSpan=5></TD></TR>
		<%
	}

			if(WFNodeFieldMainManager.getIsview().equals("1"))
				view=" checked";
			if(WFNodeFieldMainManager.getIsedit().equals("1"))
				edit=" checked";
			if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
				man=" checked";
			orderid = WFNodeFieldMainManager.getOrderid();
%>
 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >

		<td><%=Util.toScreen(curlable,user.getLanguage())%></td>
		<td><input type="checkbox" name="node<%=curid%>_view_g<%=curgroupid%>" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.node<%=curid%>_edit_g<%=curgroupid%>.checked=false;document.nodefieldhtml.node<%=curid%>_man_g<%=curgroupid%>.checked=false;}"></td>
		<%if(!"7".equals(fieldhtmltype)){%>
		<td><input type="checkbox" name="node<%=curid%>_edit_g<%=curgroupid%>" <%=edit%> <%=dtldisabled%> onClick="if(this.checked==true){document.nodefieldhtml.node<%=curid%>_view_g<%=curgroupid%>.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.node<%=curid%>_man_g<%=curgroupid%>.checked=false;}" <%if(nodetype.equals("3") || fieldname.equals("manager") || fieldhtmltype.equals("7")){%>disabled<%}%>></td>
		<td><input type="checkbox" name="node<%=curid%>_man_g<%=curgroupid%>"  <%=man%>  <%=dtldisabled%> onClick="if(this.checked==true){document.nodefieldhtml.node<%=curid%>_view_g<%=curgroupid%>.checked=(this.checked==true?true:false);document.nodefieldhtml.node<%=curid%>_edit_g<%=curgroupid%>.checked=(this.checked==true?true:false);}" <%if(nodetype.equals("3") || fieldname.equals("manager") || fieldhtmltype.equals("7")){%>disabled<%}%>></td>
		<%}else{%>
		<td><input type="checkbox" name="node<%=curid%>_edit_g<%=curgroupid%>" disabled></td>
		<td><input type="checkbox" name="node<%=curid%>_man_g<%=curgroupid%>" disabled></td>
		<%}%>
		<td><input type="text" class="Inputstyle" name="node<%=curid%>_orderid_g<%=curgroupid%>" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
</tr>
<%
		if(linecolor==0) linecolor=1;
		else linecolor=0;
	}
	FormFieldMainManager.closeStatement();
}
else if(nodeid!=-1 && isbill.equals("1")){
//int linecolor=0; xwj for td1834 on 2005-05-18

	boolean isNewForm = false;//是否是新表单 modify by myq for TD8730 on 2008.9.12
	RecordSet.executeSql("select tablename from workflow_bill where id = "+formid);
	if(RecordSet.next()){
		String temptablename = Util.null2String(RecordSet.getString("tablename"));
		if(temptablename.equals("formtable_main_"+formid*(-1))) isNewForm = true;
	}

	boolean iscptbill = false;
	if(isbill.equals("1")&&(formid==7||formid==14||formid==15||formid==18||formid==19||formid==201))
		iscptbill = true;

	String sql = "";
	if(isNewForm == true){
		if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
			sql = "select * from (select distinct t1.fieldid,t1.orderid,t2.billid,t2.fieldname,t2.fieldlabel,t2.fielddbtype,t2.fieldhtmltype,t2.type,nvl(t2.viewtype,0) as viewtype,nvl(t2.detailtable,'') as detailtable,t2.fromUser,nvl(t2.textheight,-1) as textheight,nvl(t2.dsporder,0) as dsporder,t2.childfieldid,t2.imgheight,t2.imgwidth from workflow_nodeform t1 left join (select * from workflow_billfield where billid = "+formid+") t2 on t1.fieldid=t2.id where nodeid="+nodeid+") a order by viewtype,TO_NUMBER(substr(detailtable, "+(("formtable_main_"+formid*(-1)+"_dt").length()+1)+",30)),orderid,dsporder,textheight,fieldid desc ";
		}else{
			sql = "select * from (select distinct t1.fieldid,t1.orderid,t2.billid,t2.fieldname,t2.fieldlabel,t2.fielddbtype,t2.fieldhtmltype,t2.type,isnull(t2.viewtype,0) as viewtype,isnull(t2.detailtable,'') as detailtable,t2.fromUser,isnull(t2.textheight,-1) as textheight,isnull(t2.dsporder,0) as dsporder ,t2.childfieldid,t2.imgheight,t2.imgwidth from workflow_nodeform t1 left join (select * from workflow_billfield where billid = "+formid+") t2 on t1.fieldid=t2.id where nodeid="+nodeid+") a order by viewtype,convert(int, substring(detailtable, "+(("formtable_main_"+formid*(-1)+"_dt").length()+1)+",30)),orderid,dsporder,textheight,fieldid desc ";
		}
	}else{
		if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
			sql = "select * from (select distinct t1.fieldid,t1.orderid,t2.billid,t2.fieldname,t2.fieldlabel,t2.fielddbtype,t2.fieldhtmltype,t2.type,nvl(t2.viewtype,0) as viewtype,nvl(t2.detailtable,'') as detailtable,t2.fromUser,nvl(t2.textheight,-1) as textheight,nvl(t2.dsporder,0) as dsporder,t2.childfieldid,t2.imgheight,t2.imgwidth from workflow_nodeform t1 left join (select * from workflow_billfield where billid = "+formid+") t2 on t1.fieldid=t2.id where nodeid="+nodeid+") a order by viewtype,detailtable,orderid,dsporder,textheight,fieldid desc ";
		}else{
			sql = "select * from (select distinct t1.fieldid,t1.orderid,t2.billid,t2.fieldname,t2.fieldlabel,t2.fielddbtype,t2.fieldhtmltype,t2.type,isnull(t2.viewtype,0) as viewtype,isnull(t2.detailtable,'') as detailtable,t2.fromUser,isnull(t2.textheight,-1) as textheight,isnull(t2.dsporder,0) as dsporder,t2.childfieldid,t2.imgheight,t2.imgwidth from workflow_nodeform t1 left join (select * from workflow_billfield where billid = "+formid+") t2 on t1.fieldid=t2.id where nodeid="+nodeid+") a order by viewtype,detailtable,orderid,dsporder,textheight,fieldid desc ";
		}
	}
	
	RecordSet.executeSql(sql);
	String predetailtable=null;
	int groupid=0;
	String dtldisabled="";
	while(RecordSet.next()){
		String fieldhtmltype = RecordSet.getString("fieldhtmltype");
		int curid=RecordSet.getInt("fieldid");
		int curlabel = RecordSet.getInt("fieldlabel");
		int viewtype = RecordSet.getInt("viewtype");
		String detailtable = Util.null2String(RecordSet.getString("detailtable"));
		
		if(curid==-1){
			
			boolean isEndNode = false;
		if(nodetype.equals("3")){
			 isEndNode = true;
		 }
		String view="";
		String edit="";
		String man="";
		String orderid="";
		WFNodeFieldMainManager.resetParameter();
		WFNodeFieldMainManager.setNodeid(nodeid);
		WFNodeFieldMainManager.setFieldid(-1);//"流程标题"字段在workflow_nodeform中的fieldid 定为 "-1"
		WFNodeFieldMainManager.selectWfNodeField();
		orderid = WFNodeFieldMainManager.getOrderid();
		if(WFNodeFieldMainManager.getIsview().equals("")){
			view = " checked ";
			WFNodeFieldMainManager.setIsview("1");
			orderid = "0.0";
		}else{
			if(WFNodeFieldMainManager.getIsview().equals("1"))
			view=" checked";
			if(WFNodeFieldMainManager.getIsedit().equals("1"))
			edit=" checked";
			if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
			man=" checked";
		}
		if(isEndNode){
			edit = "";
			man = "";
		}
	%>
	<tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
		<td><input type="checkbox" name="title_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.title_edit0.checked=false;document.nodefieldhtml.title_man0.checked=false;}"  ></td>
		<td><input type="checkbox" name="title_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.title_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.title_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
		<td><input type="checkbox" name="title_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.title_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.title_edit0.checked=(this.checked==true?true:false);}" <%if(isEndNode){%>disabled<%}%>></td>
		<td><input type="text" class="Inputstyle" name="title_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
	</tr>
<%
		if(linecolor==0) {
			linecolor=1;
		}else{
			linecolor=0;
		}
		WFNodeFieldMainManager.closeStatement();
			
			continue;
		}else	if(curid==-2){
			
			boolean isEndNode = false;
		if(nodetype.equals("3")){
		 isEndNode = true;
		}
		String view="";
		String edit="";
		String man="";
		String orderid="";
		WFNodeFieldMainManager.resetParameter();
		WFNodeFieldMainManager.setNodeid(nodeid);
		WFNodeFieldMainManager.setFieldid(-2);//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
		WFNodeFieldMainManager.selectWfNodeField();
		orderid = WFNodeFieldMainManager.getOrderid();
		if(WFNodeFieldMainManager.getIsview().equals("")){
			view = " checked ";
			WFNodeFieldMainManager.setIsview("1");
			orderid = "1.0";
		}else{
		   if(WFNodeFieldMainManager.getIsview().equals("1"))
			  view=" checked";
		   if(WFNodeFieldMainManager.getIsedit().equals("1"))
			  edit=" checked";
		   if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
			  man=" checked";
		}
		if(isEndNode){
		   edit = "";
		   man = "";
		}
	%>
	 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
			<td><input type="checkbox" name="level_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.level_edit0.checked=false;document.nodefieldhtml.level_man0.checked=false;}" ></td>
			<td><input type="checkbox" name="level_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.level_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.level_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
			<td><input type="checkbox" name="level_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.level_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.level_edit0.checked=(this.checked==true?true:false);}" <%if(isEndNode){%>disabled<%}%>></td>
			<td><input type="text" class="Inputstyle" name="level_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
  </tr>
<%
		if(linecolor==0) {
			linecolor=1;
		}
		else{
			linecolor=0;
		}

		WFNodeFieldMainManager.closeStatement();
		
		continue;
	}else	if(curid==-3){
		
		if(!messageType.equals("1")) continue;
		boolean isEndNode = false;
	 if(nodetype.equals("3")){
		 isEndNode = true;
	 }
	String view="";
	String edit="";
	String man="";
	String orderid="";
	WFNodeFieldMainManager.resetParameter();
	WFNodeFieldMainManager.setNodeid(nodeid);
	WFNodeFieldMainManager.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
	WFNodeFieldMainManager.selectWfNodeField();
	orderid = WFNodeFieldMainManager.getOrderid();
	if(WFNodeFieldMainManager.getIsview().equals("")){
		view = " checked ";
		WFNodeFieldMainManager.setIsview("1");
		orderid = "2.0";
	}else{
	   if(WFNodeFieldMainManager.getIsview().equals("1"))
		  view=" checked";
	   if(WFNodeFieldMainManager.getIsedit().equals("1"))
		  edit=" checked";
	   if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
		  man=" checked";
	}
	if(isEndNode){
	   edit = "";
	   man = "";
	}
	%>
	 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%></td>
			<td><input type="checkbox" name="ismessage_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.ismessage_edit0.checked=false;document.nodefieldhtml.ismessage_man0.checked=false;}"  ></td>
			<td><input type="checkbox" name="ismessage_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.ismessage_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.ismessage_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
			<td><input type="checkbox" name="ismessage_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.ismessage_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.ismessage_edit0.checked=(this.checked==true?true:false);}" <%if(isEndNode){%>disabled<%}%>></td>
			<td><input type="text" class="Inputstyle" name="ismessage_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
  </tr>
 <%
	if(linecolor==0) {
		linecolor=1;
	}
	else{
		linecolor=0;
	}
	WFNodeFieldMainManager.closeStatement();
		
	continue;
	}else	if(curid==-4){
		boolean isEndNode = true;
	String view="";
	String edit="";
	String man="";
	String orderid="";
	WFNodeFieldMainManager.resetParameter();
	WFNodeFieldMainManager.setNodeid(nodeid);
	WFNodeFieldMainManager.setFieldid(-4);//"签字意见"字段在workflow_nodeform中的fieldid 定为 "-3"
	WFNodeFieldMainManager.selectWfNodeField();
	orderid = WFNodeFieldMainManager.getOrderid();
	if(WFNodeFieldMainManager.getIsview().equals("")){
		view = " checked ";
		WFNodeFieldMainManager.setIsview("1");
		orderid = "4.0";
	}else{
	   if(WFNodeFieldMainManager.getIsview().equals("1"))
		  view=" checked";
	   if(WFNodeFieldMainManager.getIsedit().equals("1"))
		  edit=" checked";
	   if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
		  man=" checked";
	}
	if(isEndNode){
	   edit = "";
	   man = "";
	}
	%>
	 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
			<td><input type="checkbox" id="isremark_view0" name="isremark_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.isremark_edit0.checked=false;document.nodefieldhtml.isremark_man0.checked=false;}"  ></td>
			<td><input type="checkbox" id="isremark_edit0" name="isremark_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.isremark_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.isremark_man0.checked=false;}" disabled ></td>
			<td><input type="checkbox" id="isremark_man0" name="isremark_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.isremark_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.isremark_edit0.checked=(this.checked==true?true:false);}" disabled></td>
			<td><input type="text" class="Inputstyle" name="isremark_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
  </tr>
 <%
	if(linecolor==0) {
		linecolor=1;
	}
	else{
		linecolor=0;
	}
	WFNodeFieldMainManager.closeStatement();
		
	continue;
}

	WFNodeFieldMainManager.resetParameter();
	WFNodeFieldMainManager.setNodeid(nodeid);
	WFNodeFieldMainManager.setFieldid(curid);
	WFNodeFieldMainManager.selectWfNodeField();  
	//String dtladd = WFNodeDtlFieldManager.getIsadd();
	
	String view="";
	String edit="";
	String man="";
	String orderid = "";
	if(viewtype==1 && !detailtable.equals(predetailtable)){
		groupid++;
		WFNodeDtlFieldManager.setNodeid(nodeid);
		WFNodeDtlFieldManager.setGroupid(groupid-1);
		WFNodeDtlFieldManager.selectWfNodeDtlField();
		String dtladd = WFNodeDtlFieldManager.getIsadd();
		//String add = WFNodeDtlFieldManager.getIsadd();
			if(dtladd.equals("1")) dtladd=" checked";
		String dtledit = WFNodeDtlFieldManager.getIsedit();
			if(dtledit.equals("1")) dtledit=" checked";
		String dtldelete = WFNodeDtlFieldManager.getIsdelete();
			if(dtldelete.equals("1")) dtldelete=" checked";
		String dtlhide = WFNodeDtlFieldManager.getIshide();
			if(dtlhide.equals("1")) dtlhide=" checked";
		String dtldefault = WFNodeDtlFieldManager.getIsdefault();
        	if(dtldefault.equals("1")) dtldefault=" checked";
        String dtlneed = WFNodeDtlFieldManager.getIsneed();
        	if(dtlneed.equals("1")) dtlneed=" checked";
		predetailtable=detailtable;
		if((formid==156 || formid==157 || formid==158 || isNewForm || iscptbill) && !dtladd.equals(" checked") && !dtledit.equals(" checked"))
			dtldisabled="disabled";
		else
			dtldisabled="";
		%>
		</table>
		<%if(isNewForm){%>
		<table class=viewform cellspacing=1 id="tab_dtl_<%=groupid%>" name="tab_dtl_'<%=groupid%>'">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<tr>
				<td class=field colSpan=2><strong><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid%><strong></td>
			</tr>	
			<TR><TD class="Line1" colSpan=2></TD></TR>
			<tr>
				<!-- HTML模版下面的允许新增明细 -->
				<td><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="dtl_add_<%=groupid%>" onClick="checkChange2('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>></td>
				<!--'<%=String.valueOf(groupid)%>'-->
			</tr>	
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			<tr>
				<!-- HTML模版下面的允许修改已有明细 -->
				<td><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange2('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>></td>
			</tr>	
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			<tr>
				<!-- HTML模版下面的允许删除已有明细 -->
				<td><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>></td>
			</tr>   
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			<%
            if(!nodetype.equals("3"))
            {
            %>
            <tr>
            	<!-- HTML模版下面的必须新增明细 -->
                <td><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></td>
                <td class=field>
                <!-- 根据 允许新增明细 是否选中(dtladd) 判断 显示还是隐藏 ypc 2012-08-31-->
                <%if(dtladd.equals(" checked")){%>
                 <input type="checkbox"  name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>>
                <%}else{%>
                 <input type="checkbox" disabled=false name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>>
                <%}%>
                </td>
            </tr>
            <TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
            <tr>
            	<!-- HTML模版下面的新增默认空明细 -->
                <td><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></td>
                <td class=field>
                <!-- 根据 允许新增明细 是否选中(dtladd) 判断 显示还是隐藏 ypc 2012-08-31-->
                <%if(dtladd.equals(" checked")){%>
                 <input type="checkbox" name="dtl_def_<%=groupid%>" onClick="" <%=dtldefault%>>
                <%}else{%>
                  <input type="checkbox" disabled=false name="dtl_def_<%=groupid%>" onClick="" <%=dtldefault%>>
                <%}%>
                </td>
            </tr>
            <TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
            <%
            }
            %>
			<tr>
				<!-- HTML模版下面是否打印空明细 -->
				<td><%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="hide_del_<%=groupid%>" onClick="" <%=dtlhide%>></td>
			</tr>	 
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			</table>
			<%}%>
		<table class=viewform cellspacing=1 name="tab_dtl_<%=groupid%>">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<%if(!isNewForm){%>
			<tr>
				<td class=field colSpan=2><strong><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid%><strong></td>
			</tr>
			<%}%>
			<TR><TD class="Line1" colSpan=2></TD></TR>
			<% if(formid==156 || formid==157 || formid==158 || iscptbill){%>	
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="dtl_add_<%=groupid%>" onClick="checkChange2('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>></td>
			</tr>
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange2('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>></td>
			</tr>
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></td>
				<td class=field><input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>></td>
			</tr>
			<%}%>
			<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
			</table>
			<table class=liststyle cellspacing=1 id="tab_dtl_list<%=groupid%>" >
			<COLGROUP>
			<COL width="20%">
			<COL width="20%">
			<COL width="20%">
			<COL width="20%">
			<COL width="20%">
			<tr class=header>
				<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
				<td>
					<input type="checkbox" name="node_viewall_g<%=groupid%>"  onClick="if(this.checked==false){document.nodefieldhtml.node_editall_g<%=groupid%>.checked=false; document.nodefieldhtml.node_manall_g<%=groupid%>.checked=false;};onChangeViewAll(<%=groupid%>,this.checked)">
					<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%>
				</td>
				<td>
					<input type="checkbox" name="node_editall_g<%=groupid%>" <%=dtldisabled%>  onClick="if(this.checked==true){document.nodefieldhtml.node_viewall_g<%=groupid%>.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.node_manall_g<%=groupid%>.checked=false;};onChangeEditAll(<%=groupid%>,this.checked)" <%if(nodetype.equals("3")){%>disabled<%}%>>
					<%=SystemEnv.getHtmlLabelName(15604,user.getLanguage())%>
				</td>
				<td>
					<input type="checkbox" name="node_manall_g<%=groupid%>" <%=dtldisabled%>  onClick="if(this.checked==true){document.nodefieldhtml.node_viewall_g<%=groupid%>.checked=(this.checked==true?true:false);document.nodefieldhtml.node_editall_g<%=groupid%>.checked=(this.checked==true?true:false);};onChangeManAll(<%=groupid%>,this.checked)" <%if(nodetype.equals("3")){%>disabled<%}%>>
					<%=SystemEnv.getHtmlLabelName(15605,user.getLanguage())%>
				</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(23691,user.getLanguage())%>
			</td>
			</tr><TR class=Line ><TD colSpan=5></TD></TR>
		<%

	}
	if(WFNodeFieldMainManager.getIsview().equals("1"))
		view=" checked";
	if(WFNodeFieldMainManager.getIsedit().equals("1"))
		edit=" checked";
	if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
		man=" checked";
	orderid = WFNodeFieldMainManager.getOrderid();
%>
 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(curlabel,user.getLanguage())%></td>
		<td><input type="checkbox" name="node<%=curid%>_view_g<%=groupid%>" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.node<%=curid%>_edit_g<%=groupid%>.checked=false;document.nodefieldhtml.node<%=curid%>_man_g<%=groupid%>.checked=false;}"></td>
		<%if(!fieldhtmltype.equals("7")){%>		
		<td><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" <%=edit%> <%=dtldisabled%> onClick="if(this.checked==true){document.nodefieldhtml.node<%=curid%>_view_g<%=groupid%>.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.node<%=curid%>_man_g<%=groupid%>.checked=false;}" <%if(nodetype.equals("3")){%>disabled<%}%>></td>
		<td><input type="checkbox" name="node<%=curid%>_man_g<%=groupid%>"  <%=man%>  <%=dtldisabled%> onClick="if(this.checked==true){document.nodefieldhtml.node<%=curid%>_view_g<%=groupid%>.checked=(this.checked==true?true:false);document.nodefieldhtml.node<%=curid%>_edit_g<%=groupid%>.checked=(this.checked==true?true:false);}" <%if(nodetype.equals("3")){%>disabled<%}%>></td>
		<%}else{%>
		<td><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" disabled></td>
		<td><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" disabled></td>
		<%}%>
		<td><input type="text" class="Inputstyle" name="node<%=curid%>_orderid_g<%=groupid%>" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
</tr>
<%
	if(linecolor==0){
		linecolor=1;
	}else{
		linecolor=0;
	}
}
}
%>
</table>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
</table>
</form>
<%
if(ajax == 0){
%>
</BODY>
</HTML>
<%}%>

<script language="javascript">
<%if(ajax == 0){%>
function prepShowHtml(formid,wfid,nodeid,isbill,layouttype,ajax){
	openFullWindowHaveBar("/workflow/html/index.jsp?formid="+formid+"&wfid="+wfid+"&nodeid="+nodeid+"&isbill="+isbill+"&layouttype="+layouttype+"&ajax="+ajax)
}
function ItemFloat_KeyPress_ehnf(obj){
	if(!((window.event.keyCode>=48 && window.event.keyCode<=57) || window.event.keyCode==46)){
		window.event.keyCode=0;
	}
}
function submitData(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(23708, user.getLanguage())%>")){
		nodefieldhtml.needcreatenew.value = "1";
	}else{
		nodefieldhtml.needcreatenew.value = "0";
	}
	nodefieldhtml.needprep.value = "2";
	nodefieldhtml.submit();
}
function checkFloat_ehnf(obj){
	var valuenow = obj.value;
	var index = valuenow.indexOf(".");
	var valuechange = valuenow;
	if(index > -1){
		if(index == 0){
			valuechange = "0"+valuenow;
			index = 1;
		}
		valuenow = valuechange.substring(0, index+1);
		valuechange = valuechange.substring(index+1, valuechange.length);
		if(valuechange.length > 2){
			valuechange = valuechange.substring(0, 2);
		}
		index = valuechange.indexOf(".");
		if(index > -1){
			valuechange = valuechange.substring(0, index);
		}
		valuenow = valuenow + valuechange;
		index = valuenow.indexOf(".");
		if(index>-1 && index==valuenow.length-1){
			if(valuenow.length>=6){
				valuenow = valuenow.substring(0, index);
			}else{
				valuenow = valuenow + "0";
			}
		}
		obj.value = valuenow;
	}
}
function checkChange2(id) {
	len = document.nodefieldhtml.elements.length;
    var isenable=0;
	 var isen=0; //ypc  2012-08-30
    if(document.all("dtl_add_"+id).checked){
        isen=1;
    }
    //start 2012-08-31 ypc 
    if(document.all("dtl_edit_"+id).checked){
    	isenable=1;
    }
    //end 2012-08-31 ypc 
    if(isen==1)
    {
    	document.all("dtl_ned_"+id).disabled=false;
    	document.all("dtl_def_"+id).disabled=false;
    }
    else
    {
    	document.all("dtl_ned_"+id).checked=false;  // 2012-08-31 ypc
    	document.all("dtl_def_"+id).checked=false; // 2012-08-31 ypc
		document.all("dtl_ned_"+id).disabled=true;
		document.all("dtl_def_"+id).disabled=true;
    }
    for( i=0; i<len; i++) {
        var elename=document.nodefieldhtml.elements[i].name;
        elename=elename.substr(elename.indexOf('_')+1);
        if (elename=='edit_g'+id || elename=='man_g'+id || elename=='editall_g'+id || elename=='manall_g'+id || elename=='editall'+id || elename=='manall'+id) {
            if(isenable==1||isen==1){ // 2012-08-31 ypc //更改此处
                document.nodefieldhtml.elements[i].disabled=false;
            }else{
				document.nodefieldhtml.elements[i].disabled=true;
            }
        } 
    } 
	

    //len = document.nodefieldhtml.elements.length;
   // var isenable=0;
   // if(document.all("dtl_add_"+id).checked || document.all("dtl_edit_"+id).checked){
    //    isenable=1;
    //}
	//if(isenable==1) {
	//	document.all("dtl_ned_"+id).disabled=false;
	//	document.all("dtl_def_"+id).disabled=false;
	//} else {
	//	document.all("dtl_ned_"+id).disabled=true;
	//	document.all("dtl_def_"+id).disabled=true;
	//}
    //for( i=0; i<len; i++) {
       // var elename=document.nodefieldhtml.elements[i].name;
      //  elename=elename.substr(elename.indexOf('_')+1);
       // if (elename=='edit_g'+id || elename=='man_g'+id || elename=='editall_g'+id || elename=='manall_g'+id || elename=='editall'+id || elename=='manall'+id) {
       //     if(isenable==1){
        //        document.nodefieldhtml.elements[i].disabled=false;
          //  }else{
		//		document.nodefieldhtml.elements[i].disabled=true;
         //   }
        //} 
    //} 
}
function onChangeViewAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	//alert(tab_id);
	var tab_name = document.getElementById(tab_id);
	//alert(tab_name);
	var row = tab_name.rows.length;
	//alert(row);
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows(i);
		//alert(tmpTr);
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd1 = tmpTr.cells(1);
		if(tmpTd1 == undefined){
			continue;
		}
		//var tmpName = tmpTd1.childNodes[0].name;
		//alert(tmpName);
		if(tmpTd1.childNodes[0].disabled == false){
			tmpTd1.childNodes[0].checked = opt;
		}

		if(opt == false){
			var tmpTd2 = tmpTr.cells(2);
			if(tmpTd2.childNodes[0].disabled == false){
				tmpTd2.childNodes[0].checked = opt;
			}

			var tmpTd3 = tmpTr.cells(3);
			if(tmpTd3.childNodes[0].disabled == false){
				tmpTd3.childNodes[0].checked = opt;
			}
		}
	}
}

function onChangeEditAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows(i);
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd2 = tmpTr.cells(2);
		if(tmpTd2 == undefined){
			continue;
		}
		if(tmpTd2.childNodes[0].disabled == false){
			tmpTd2.childNodes[0].checked = opt;
		}
		if(opt == false){
			var tmpTd3 = tmpTr.cells(3);
			if(tmpTd3.childNodes[0].disabled == false){
				tmpTd3.childNodes[0].checked = opt;
				}
		}else{
			var tmpTd1 = tmpTr.cells(1);
			if(tmpTd1.childNodes[0].disabled == false){
				tmpTd1.childNodes[0].checked = opt;
			}
		}
	}
}

function onChangeManAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows(i);
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd3 = tmpTr.cells(3);
		if(tmpTd3 == undefined){
			continue;
		}
		if(tmpTd3.childNodes[0].disabled == false){
			tmpTd3.childNodes[0].checked = opt;
		}
		if(opt == true){
			var tmpTd1 = tmpTr.cells(1);
			if(tmpTd1.childNodes[0].disabled == false){
				tmpTd1.childNodes[0].checked = opt;
			}
			var tmpTd2 = tmpTr.cells(2);
			if(tmpTd2.childNodes[0].disabled == false){
				tmpTd2.childNodes[0].checked = opt;
			}
		}
	}
}

<%}%>
</script>
<%if(needprep == 1){%>
	<SCRIPT LANGUAGE="javascript">
		showHtmlLayoutFck("<%=formid%>","<%=wfid%>","<%=nodeid%>","<%=isbill%>","0","1");
		openFullWindowHaveBar("/workflow/html/LayoutEditFrame.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=0&isbill=<%=isbill%>&layouttype=0&modeid=0");
	</SCRIPT>
<%}%>
