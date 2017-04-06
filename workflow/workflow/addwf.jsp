<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page
	import="weaver.general.Util,weaver.file.Prop,weaver.general.GCONST"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager"
	scope="session" />
<jsp:useBean id="FieldMainManager"
	class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="FormFieldMainManager"
	class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="DetailFieldComInfo"
	class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DataSourceXML"
	class="weaver.servicefiles.DataSourceXML" scope="page" />
<%@ include file="/systeminfo/init.jsp"%>

<%
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
		response.sendRedirect("/notice/noright.jsp");

		return;
	}
%>

<%
	ArrayList pointArrayList = DataSourceXML.getPointArrayList();
	//节点模板编辑刷新
	String isnodemode = Util.null2String(request
			.getParameter("isnodemode"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String fromWfEdit = Util.null2String(request
			.getParameter("fromWfEdit"));
	if (wfid.equals(""))
		wfid = "0";
	//是否为流程模板
	String isTemplate = Util.getIntValue(
			Util.null2String(request.getParameter("isTemplate")), 0)
			+ "";
	int typeid = Util.getIntValue(request.getParameter("typeid"), 0);
	String selecttab = Util.null2String(request
			.getParameter("selecttab"));

	String isbill = "3";
	int formid = 0;
	if (!wfid.equals("0")) {
		WFManager.setWfid(Util.getIntValue(wfid));
		WFManager.getWfInfo();
		isbill = WFManager.getIsBill();
		formid = WFManager.getFormid();
		typeid = WFManager.getTypeid();
	}

	String sql = "";
	String wfMainFieldsOptions = "";//主字段
	String wfDetailFieldsOptions = "";//明细字段
	String wfFieldsOptions = "";//全部字段
	if (formid != 0) {
		if (isbill.equals("0")) {//表单主字段
			sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "
					+ " where a.isdetail is null and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="
					+ formid
					+ " and b.langurageid = "
					+ user.getLanguage();
			if (RecordSet.getDBType().equals("oracle")) {
				sql += " order by a.isdetail desc,a.fieldorder asc ";
			} else {
				sql += " order by a.isdetail,a.fieldorder ";
			}
		} else if (isbill.equals("1")) {//单据主字段
			sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=0 and billid="
					+ formid;
			sql += " order by viewtype,dsporder";
		}
		RecordSet.executeSql(sql);
		while (RecordSet.next()) {
			String fieldname = "";
			if (isbill.equals("0"))
				fieldname = RecordSet.getString("fieldlable");
			if (isbill.equals("1"))
				fieldname = SystemEnv.getHtmlLabelName(
						RecordSet.getInt("fieldlabel"),
						user.getLanguage());
			wfMainFieldsOptions += "<option value="
					+ RecordSet.getString(1) + ">" + fieldname
					+ "</option>";
		}
		if (isbill.equals("0")) {//表单明细字段
			sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "
					+ " where a.isdetail=1 and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="
					+ formid
					+ " and b.langurageid = "
					+ user.getLanguage();
			if (RecordSet.getDBType().equals("oracle")) {
				sql += " order by a.groupId,a.isdetail desc,a.fieldorder asc";
			} else {
				sql += " order by a.groupId,a.isdetail,a.fieldorder ";
			}
		} else if (isbill.equals("1")) {//单据明细字段
			sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=1 and billid="
					+ formid;
			sql += " order by viewtype,dsporder";
		}
		RecordSet.executeSql(sql);
		while (RecordSet.next()) {
			String fieldname = "";
			if (isbill.equals("0"))
				fieldname = RecordSet.getString("fieldlable");
			if (isbill.equals("1"))
				fieldname = SystemEnv.getHtmlLabelName(
						RecordSet.getInt("fieldlabel"),
						user.getLanguage());
			wfDetailFieldsOptions += "<option value="
					+ RecordSet.getString(1) + ">" + fieldname
					+ "</option>";
		}
	}

	wfFieldsOptions = wfMainFieldsOptions + wfDetailFieldsOptions;

	int detachable = Util.getIntValue(
			String.valueOf(session.getAttribute("detachable")), 0);
	session.setAttribute("treeleft" + isTemplate, typeid + "");
	Cookie ck = new Cookie("treeleft" + isTemplate + user.getUID(),
			typeid + "");
	ck.setMaxAge(30 * 24 * 60 * 60);
	response.addCookie(ck);
	//added by cyril on 2008-08-20 for td:9215
	session.setAttribute("treeleft_cnodeid" + isTemplate, wfid + "");
	ck = new Cookie("treeleft_cnodeid" + isTemplate + user.getUID(),
			wfid + "");
	ck.setMaxAge(30 * 24 * 60 * 60);
	response.addCookie(ck);
	//end by cyril on 2008-08-20 for td:9215
	int isloadleft = Util.getIntValue(
			request.getParameter("isloadleft"), 0);
	//是否启用计划任务模块
	int isusedworktask = Util.getIntValue(
			BaseBean.getPropValue("worktask", "isusedworktask"), 0);
	int has_createwpbywf = Util
			.getIntValue(BaseBean.getPropValue("createwpbywf",
					"hascreatewpbywf"), 0);
%>
<html>
<head>
<%@ include file="/hrm/resource/simpleHrmResource.jsp"%>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<!-- 
    <SCRIPT language="javascript" src="/js/checknumber.js"></script>
     -->
<script type='text/javascript' src='/dwr/interface/WorkflowSubwfSetUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script language="JavaScript" src="/js/addRowBg.js"></script>
<script type="text/javascript" src="/js/dojo.js"></script>
<script src="/js/tab.js"></script>
<script type="text/javascript">
        dojo.require("dojo.widget.TabSet");
        dojo.require("dojo.io.*");
        dojo.require("dojo.event.*");
</script>
<script language=javascript src="/js/jquery/plugins/tooltip/jquery.tooltip.js"></script>
<LINK href="/js/jquery/plugins/tooltip/simpletooltip.css" type=text/css rel=STYLESHEET>
<LINK href="/js/src/widget/templates/HtmlTabSet.css" type="text/css"
	media=screen>


</head>
<body>
	<%
		if (isloadleft == 1) {
	%>
	<script>
    parent.wfleftFrame.location="wfmanage_left2.jsp?isTemplate=<%=isTemplate%>";
</script>
	<%
		}
	%>
	<div id="mainTabSet" dojoType="TabSet"
		style="width: 100%; height: 100%; white-space: nowrap;"
		selectedTab="<%=selecttab%>">
		<div id="tab0" dojoType="Tab" style="white-space: nowrap"
			label="<%=SystemEnv.getHtmlLabelName(16483, user.getLanguage())%>"
			onSelected="setNowTab('tab0');setHelpURL('0', 'workflow/workflow/addwf0.jsp')">
			<div id="subTabSet0" dojoType="TabSet"
				style="width: 100%; height: 100%;"
				<%if ("true".equals(fromWfEdit)) {%> selectedTab="tab4"
				<%} else if (isnodemode.equals("1")) {%> selectedTab="tab2" <%}%>>
				<%
					if (wfid.equals("0")) {
				%>
				<div id="tab1" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>"
					url="/workflow/workflow/addwf0.jsp?ajax=1&isTemplate=<%=isTemplate%>&typeid=<%=typeid%>"
					onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setnowtab0('tab1');setHelpURL('-0','workflow/workflow/addwf0.jsp')"></div>
				<%
					} else {
				%>
				<div id="tab1" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>"
					url="/workflow/workflow/addwf0.jsp?ajax=1&src=editwf&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>"
					onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setnowtab0('tab1');setHelpURL('-0','workflow/workflow/addwf0.jsp')"></div>
				<div id="tab2" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(15615, user.getLanguage())%>"
					<%if (isnodemode.equals("1")) {%>
					url="/workflow/workflow/Editwfnode.jsp?ajax=1&wfid=<%=wfid%>"
					<%} else {%> url="" <%}%>
					onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab2ref();setHelpURL('-0','workflow/workflow/Editwfnode.jsp')"></div>
				<div id="tab3" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(15606, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab3ref();setHelpURL('-0','workflow/workflow/addwfnodeportal.jsp')"></div>
				<%
					if ("true".equals(fromWfEdit)) {
				%>
				<div id="tab4" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(16459,
							user.getLanguage())%>"
					url="/workflow/request/WorkflowLayoutEdit0.jsp?wfid=<%=wfid%>"
					onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab4ref();setHelpURL('-0','workflow/request/WorkflowLayoutEdit0.jsp')"></div>
				<%
					} else {
				%>
				<div id="tab4" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(16459,
							user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab4ref();setHelpURL('-0','workflow/request/WorkflowLayoutEdit0.jsp')"></div>
				<%
					}
				%>
				<%--<div id="tab5" dojoType="Tab" label="<%=SystemEnv.getHtmlLabelName(83, user.getLanguage())%>"  url="/workflow/workflow/WFLog.jsp?wfid=<%=wfid%>" onmousedown="if(event.button==2) {initMenu(this);}" onSelected="setnowtab0('tab5');setHelpURL('-0','workflow/workflow/WFLog.jsp')"></div>--%>
				<div id="tab5" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(83, user.getLanguage())%>"
					url="/workflow/workflow/WFLog.jsp?wfid=<%=wfid%>"
					onSelected="setnowtab0('tab5');setHelpURL('-0','workflow/workflow/WFLog.jsp')"></div>
				<div id="tab6" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(18361, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab6ref();setHelpURL('-0','workflow/workflow/wfFunctionManage.jsp')"></div>
				<%--xwj for td3665 20060223--%>
				<div id="tab7" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(18812, user.getLanguage())%>"
					url="/workflow/workflow/WorkFlowPlanSet.jsp?ajax=1&wfid=<%=wfid%>"
					onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setnowtab0('tab7');setHelpURL('-0','workflow/workflow/WorkFlowPlanSet.jsp')"></div>
				<%--add by ben 2006-04-12 fro TD1673--%>
				<%-- added by pony on 2006-04-21 for TD4215 begin--%>
				<!--div id="tab8" dojoType="Tab" label="<%=SystemEnv.getHtmlLabelName(18880, user.getLanguage())%>"  url="/workflow/workflow/WFOpinionField.jsp?ajax=1&wfid=<%=wfid%>" onmousedown="if(event.button==2) {initMenu(this);}" onSelected="setnowtab0('tab8');setHelpURL('-0','workflow/workflow/WFOpinionField.jsp')"></div-->
				<%-- added by pony on 2006-04-21 end--%>
				<div id="tab9" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(19501, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab9ref();setHelpURL('-0','workflow/workflow/WFTitleSet.jsp')"></div>
				<div id="tab10" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(19502, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab10ref();setHelpURL('-0','workflow/workflow/WFCode.jsp')"></div>
				<div id="tab11" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(21220, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab11ref();setHelpURL('-0','workflow/workflow/WFUrger.jsp')"></div>
				<%
					}
				%>
			</div>
		</div>

		<div id="tab00" dojoType="Tab" style="white-space: nowrap"
			label="<%=SystemEnv.getHtmlLabelName(19516, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532, user.getLanguage())%>"
			onSelected="setNowTab('tab00');setHelpURL('1','workflow/form/addform.jsp')">
			<div id="subTabSet00" dojoType="TabSet"
				style="width: 100%; height: 100%;">
				<div id="tab01" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setnowtab1('tab01');setHelpURL('-1','workflow/form/addform.jsp')"></div>
				<div id="tab02" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(15449, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab02ref();setHelpURL('-1','workflow/form/addformfield.jsp')">
					<iframe id="tab02iframe" name="tab02iframe" frameborder="0"
						width=100% height=100% scrolling="auto" src=""></iframe>
				</div>
				<div id="tab03" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab03ref();setHelpURL('-1','workflow/form/addformfieldlabel.jsp')"></div>
				<div id="tab04" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(18368, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab04ref();setHelpURL('-1','workflow/form/addformrowcal.jsp')"></div>
				<div id="tab05" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(18369, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="tab05ref();setHelpURL('-1','workflow/form/addformcolcal.jsp')"></div>
			</div>
		</div>

		<div id="tab000" dojoType="Tab" style="white-space: nowrap"
			label="<%=SystemEnv.getHtmlLabelName(468, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532, user.getLanguage())%>"
			onSelected="settab000();setHelpURL('2','workflow/workflow/BillManagementList.jsp')">
			<iframe id="tab000if" name="tab000if" frameborder="0" width=100%
				height=100% scrolling="auto" src=""></iframe>
		</div>

		<div id="tab0000" dojoType="Tab" style="white-space: nowrap"
			label="<%=SystemEnv.getHtmlLabelName(19332, user.getLanguage())%>"
			onSelected="setNowTab0000('tab0000');setHelpURL('3','workflow/workflow/CreateDocumentByWorkFlow.jsp')">
			<div id="subTabSet0000" dojoType="TabSet"
				style="width: 100%; height: 100%;">
				<div style="float: left" id="tab0001" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(19331, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setNowTab0000('tab0001');setHelpURL('-3','workflow/workflow/CreateDocumentByWorkFlow.jsp')"></div>
				<div style="float: left" id="tab0002" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(19343, user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(19344, user.getLanguage())%>）"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setNowTab0002('tab0002');setHelpURL('-3','workflow/workflow/WorkflowSubwfSet.jsp')"></div>
				<%
					if (isusedworktask == 1) {
				%>
				<div style="float: left" id="tab0003" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(22118, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setNowTab0003('tab0003');setHelpURL('-3','workflow/workflow/CreateWorktaskByWorkflow.jsp')"></div>
				<%
					}
				%>
				<%
					if (has_createwpbywf == 1) {
				%>
				<div style="float: left" id="tab0004" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(24086, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setNowTab0004('tab0004');setHelpURL('-3','workflow/workflow/CreateWorkplanByWorkflow.jsp')"></div>
				<%
					}
				%>
				<div style="float: left" id="tab0005" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(22231, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setNowTab0005('tab0005');setHelpURL('-3','workflow/workflow/CreateDocumentByAction.jsp')"></div>
			</div>
		</div>
		<div id="tab00000" dojoType="Tab" style="white-space: nowrap"
			label="<%=SystemEnv.getHtmlLabelName(21683, user.getLanguage())%>"
			onSelected="setNowTab00000('tab00000');setHelpURL('4','workflow/workflow/LinkageViewAttr.jsp')">
			<div id="subTabSet00000" dojoType="TabSet"
				style="width: 100%; height: 100%;">
				<div id="tab000001" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(21684, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setNowTab00000('tab000001');setHelpURL('-4','workflow/workflow/LinkageViewAttr.jsp')"></div>
				<%
					if (GCONST.getFIELDLINKAGE()) {
				%>
				<div id="tab000002" dojoType="Tab"
					label="<%=SystemEnv.getHtmlLabelName(21848, user.getLanguage())%>"
					url="" onmousedown="if(event.button==2) {initMenu(this);}"
					onSelected="setNowTab00000('tab000002');setHelpURL('-0','workflow/workflow/WFUrger.jsp')"></div>
				<%
					}
				%>
			</div>
		</div>
	</div>
</body>
</html>
<script language="JavaScript" src="/js/addRowBg.js"></script>
<script language="JavaScript">

String.prototype.length2 = function() {
    var cArr = this.match(/[^\x00-\xff]/ig);
    return this.length + (cArr == null ? 0 : cArr.length);
    }
<%if (detachable == 1) {%>
//工作流路径设置中，隐藏左边组织树

	if(parent.parent.document.getElementById("oTd1").style.display!="none"){
		parent.parent.document.getElementById("oTd1").style.display="none";
	}
<%}%>


var workflowidAll = <%=wfid%>;
var isTemplateAll = <%=isTemplate%>;
var helpURL = "workflow/workflow/addwf0.jsp";

var help0URL = "workflow/workflow/addwf0.jsp";
var help0OldURL = "workflow/workflow/addwf0.jsp";
var help0InnerURL = "workflow/workflow/addwf0.jsp";

var help1URL = "workflow/form/addform.jsp";
var help1OldURL = "";
var help1InnerURL = "";

var help2URL = "workflow/workflow/BillManagementList.jsp";
var help2OldURL = "";
var help2InnerURL = "";

var help3URL = "workflow/workflow/CreateDocumentByWorkFlow.jsp";
var help3OldURL = "";
var help3InnerURL = "";

var help4URL = "workflow/workflow/LinkageViewAttr.jsp";
var help4OldURL = "";
var help4InnerURL = "";

var tab01oldurl="";
var tab02oldurl="";
var tab03oldurl="";
var tab04oldurl="";
var tab05oldurl="";
var tab5oldurl="";
var tab6oldurl="";
var tab01url="";
var tab02url="";
var tab02iframesrc="";
var tab03url="";
var tab04url="";
var tab05url="";
var tab1OldURL = "/workflow/workflow/addwf0.jsp?ajax=1&src=editwf&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>";  //TD5395
var tab2oldurl="";
var tab3oldurl="";
var tab4oldurl="";
var tab9oldurl="";
var tab10oldurl="";
var tab11oldurl="";
var tab1URL = tab1OldURL;  //TD5395
var tab2url="/workflow/workflow/Editwfnode.jsp?ajax=1&wfid=<%=wfid%>";
var tab3url="/workflow/workflow/addwfnodeportal.jsp?ajax=1&wfid=<%=wfid%>";
var tab4url="/workflow/request/WorkflowLayoutEdit0.jsp?wfid=<%=wfid%>";
var tab6url="/workflow/workflow/wfFunctionManage.jsp?ajax=1&wfid=<%=wfid%>";
var tab9url="/workflow/workflow/WFTitleSet.jsp?ajax=1&wfid=<%=wfid%>";
var tab10url="/workflow/workflow/WFCode.jsp?ajax=1&wfid=<%=wfid%>";
var tab11url="/workflow/workflow/WFUrger.jsp?ajax=1&wfid=<%=wfid%>";

var nowtab="tab0";
var nowtab0="tab1";
var nowtab1="tab01";
var tabiframesrc="";

var tab0001OldURL = "";
var tab0001URL = "/workflow/workflow/CreateDocumentByWorkFlow.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";

var tab0002OldURL = "";
var tab0002URL = "/workflow/workflow/WorkflowSubwfSet.jsp?ajax=1&wfid=<%=wfid%>";

var tab0003OldURL = "";
var tab0003URL = "/workflow/workflow/CreateWorktaskByWorkflow.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";

var tab0004OldURL = "";
var tab0004URL = "/workflow/workflow/CreateWorkplanByWorkflow.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";

var tab0005OldURL = "";
var tab0005URL = "/workflow/workflow/CreateDocumentByAction.jsp?ajax=1&wfid=<%=wfid%>";

var tab000001OldURL = "";
var tab000001URL = "/workflow/workflow/LinkageViewAttr.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";
<%if (!wfid.equals("0")) {%>
tab000001URL = "/workflow/workflow/LinkageViewAttr.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>";
<%} else {%>
tab000001URL = "/workflow/workflow/wfError.jsp?msg=<%=SystemEnv.getHtmlLabelName(21685, user.getLanguage())%>";
<%}
			boolean isnewform = false;
			if (isbill.equals("1")) {
				RecordSet
						.executeSql("select tablename from workflow_bill where id="
								+ formid);
				if (RecordSet.next()) {
					String tablename = RecordSet.getString("tablename");
					if (tablename.equals("formtable_main_" + formid * (-1)))
						isnewform = true;
				}
			}%>

<%if (isbill.equals("1") && !isnewform && !wfid.equals("0")
					&& formid != -1) {%>
        tabiframesrc="/workflow/workflow/BillManagementDetail.jsp?billId=<%=formid%>";
<%} else {%>
        tabiframesrc="/workflow/workflow/BillManagementList.jsp";
<%}
			if (isbill.equals("0") && !wfid.equals("0")) {%>
        tab01url="/workflow/form/addform.jsp?formid=<%=formid%>&src=editform&ajax=1";
        tab02iframesrc = "/workflow/form/addformfield.jsp?formid=<%=formid%>";
        //tab02url="/workflow/form/addformfield.jsp?ajax=1&formid=<%=formid%>";
        tab03url="/workflow/form/addformfieldlabel.jsp?ajax=1&formid=<%=formid%>";
        tab04url="/workflow/form/addformrowcal.jsp?ajax=1&formid=<%=formid%>";
        tab05url="/workflow/form/addformcolcal.jsp?ajax=1&formid=<%=formid%>";
<%} else if (isnewform) {%>
	tab01url="/workflow/form/editform.jsp?ajax=1&formid=<%=formid%>";
	tab02iframesrc="/workflow/form/editformfield.jsp?formid=<%=formid%>";
	tab03url="/workflow/form/addformfieldlabel0.jsp?formid=<%=formid%>&ajax=1";
	tab04url="/workflow/form/addformrowcal0.jsp?formid=<%=formid%>&ajax=1";
	tab05url="/workflow/form/addformcolcal0.jsp?formid=<%=formid%>&ajax=1";
<%} else {%>
        tab01url="/workflow/form/manageform.jsp?ajax=1";
        tab02iframesrc="/workflow/workflow/wfError.jsp";
        tab03url="/workflow/workflow/wfError.jsp";
        tab04url="/workflow/workflow/wfError.jsp";
        tab05url="/workflow/workflow/wfError.jsp";
<%}%>

	function flowTriggerSave(obj){
		var triggerNum = $GetEle("triggerNum").value;
		for(var tempTriggerIndex=0;tempTriggerIndex<triggerNum;tempTriggerIndex++){
			if($GetEle("triggerField"+tempTriggerIndex)){
				var triggerfield = $GetEle("triggerField"+tempTriggerIndex).value;
				if(triggerfield==""){
					alert("<%=SystemEnv.getHtmlNoteName(14, user.getLanguage())%>");
					return;
				}
			}
		}
		obj.disabled=true;
		doPost($GetEle("frmTrigger"),tab000002);
	}
	function deleteRowOfFieldTrigger(){
    var oTable=$GetEle('LinkageTable');
    curindex=0;
    len = document.frmTrigger.elements.length;
    var i=0;
    var rowsum1 = 0;
    var delsum=0;
    for(i=len-1; i >= 0;i--) {
        if (document.frmTrigger.elements[i].name=='checkbox_TriggerField'){
            rowsum1 += 1;
            if(document.frmTrigger.elements[i].checked==true) delsum+=1;
        }
    }
    if(delsum<1){
    	alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>");
    }else{
        if(confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>")){
            for(i=len-1; i >= 0;i--) {
                if (document.frmTrigger.elements[i].name=='checkbox_TriggerField'){
                    if(document.frmTrigger.elements[i].checked==true) {
                        oTable.deleteRow(rowsum1-1);
                        //$GetEle("triggerNum").value = $GetEle("triggerNum").value*1 - 1;
                        curindex--;
                    }
                    rowsum1 -=1;
                }

            }
            //$GetEle("rownum").value=curindex;
        }

    }
	}
	function addRowOfFieldTrigger(){
		triggerFieldOfRowIndex = $GetEle("triggerNum").value*1;
		$GetEle("triggerNum").value = triggerFieldOfRowIndex*1 + 1;
		rowColor = getRowBg();
		ncol = jQuery("#LinkageTable").attr("cols");
		oRow = LinkageTable.insertRow(-1);
		oRow.style.height=24;
		for(j=0; j<ncol; j++){
			oCell = oRow.insertCell(-1);
			oCell.noWrap=true;
			switch(j){
				case 0:
					oCell.style.background=rowColor;
					var oDiv = document.createElement("div");
					var sHtml = "<input type='checkbox' name='checkbox_TriggerField' value='"+triggerFieldOfRowIndex+"'>";
					oDiv.innerHTML = sHtml;
					jQuery(oCell).append(oDiv);
					break;
				case 1:
					var oDiv = document.createElement("div");
					var sHtml = "<table width=100%><COLGROUP><COL width='30%'><COL width='70%'>"+
											"<tr>"+
												"<td><%=SystemEnv.getHtmlLabelName(21805, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%></td>"+
												"<td class=field><BUTTON type='button' class=Browser onClick='onShowTriggerField(\"triggerField"+triggerFieldOfRowIndex+"\",\"triggerFieldSpan"+triggerFieldOfRowIndex+"\", \"triggerFieldType"+triggerFieldOfRowIndex+"\",\""+triggerFieldOfRowIndex+"\")'></BUTTON><input type='hidden' value=-1 name='triggerFieldType"+triggerFieldOfRowIndex+"' id='triggerFieldType"+triggerFieldOfRowIndex+"'>"+
												"<input type='hidden' name='triggerField"+triggerFieldOfRowIndex+"' id='triggerField"+triggerFieldOfRowIndex+"'><span id='triggerFieldSpan"+triggerFieldOfRowIndex+"'><IMG src='/images/BacoError.gif' align=absMiddle><span></td>"+
											"</tr><TR style='height:1px'><TD class=Line colSpan=2></TD></TR>"+
											"<tr>"+
												"<td><b><%=SystemEnv.getHtmlLabelName(21805, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653, user.getLanguage())%></b></td>"+
												"<td align=right>"+
													"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='addTriggerSetting("+triggerFieldOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653, user.getLanguage())%></a>"+
													"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='deleteTriggerSetting("+triggerFieldOfRowIndex+")'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653, user.getLanguage())%></a>"+
												"</td>"+
											"</tr><TR style='height:1px'><TD class=Line1 colSpan=2></TD></TR>"+
											"<tr><td colSpan=2><table id='table_"+triggerFieldOfRowIndex+"' width=100% class='viewform' cols=2><COLGROUP><COL width='2%'><COL width='98%'><input type='hidden' id='triggerSettingRows_"+triggerFieldOfRowIndex+"' name='triggerSettingRows_"+triggerFieldOfRowIndex+"' value='0'></table><td></tr>"+
											"</table>";
					oDiv.innerHTML = sHtml;
					jQuery(oCell).append(oDiv);
					break;	
			}
		}
	}
	function deleteTriggerSetting(index){
    var oTable=$GetEle('table_'+index);
    curindex=0;
    len = oTable.rows.length;
    var i=0;
    //var rowsum1 = 0;
    var delsum=0;
    for(i=0;i <len;i++) { 
        if(oTable.rows[i].cells[0].all[0].checked){
            //rowsum1 += 1;
            delsum += 1;
        }
    }
    if(delsum<1){
    	alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>");
    }else{
        if(confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>")){
            for(i=len-1; i >= 0;i--) {
                if (oTable.rows[i].cells[0].all[0].name=='checkbox_TriggerSetting'){
                    if(oTable.rows[i].cells[0].all[0].checked==true) {
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("nodeid_"+document.frmlinkageviewattr.elements[i].value+",","");
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("selectfieldid_"+document.frmlinkageviewattr.elements[i].value+",","");
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("selectfieldvalue_"+document.frmlinkageviewattr.elements[i].value+",","");
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("changefieldids_"+document.frmlinkageviewattr.elements[i].value+",","");
                        oTable.deleteRow(i);
                        curindex--;
                    }
                    //rowsum1 -=1;
                }

            }
            //$GetEle("rownum").value=curindex;
        }

    }
	}
	function addTriggerSetting(index){
		triggerFieldType = $GetEle("triggerFieldType"+index).value;
		triggerFieldId = $GetEle("triggerField"+index).value;
		optionS = "";
		paraFieldsOptions = "";
		evaluateFieldsOptions = "";
		var oTable=$GetEle('table_'+index);
		triggerSettingOfRowIndex = $G("triggerSettingRows_"+index).value;
		$G("triggerSettingRows_"+index).value = triggerSettingOfRowIndex*1 + 1;
		rowColor = getRowBg();
		ncol = jQuery(oTable).attr("cols");
		if(triggerFieldType==1){
			optionS = "<option value=0><%=SystemEnv.getHtmlLabelName(19325, user.getLanguage())%></option>";
			paraFieldsOptions = "";
			evaluateFieldsOptions  = "";
			
			var ajax=ajaxinit();
			ajax.open("POST", "triggerdetailoption.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("wfid=<%=wfid%>&fieldid="+triggerFieldId);
			//获取执行状态
			ajax.onreadystatechange = function() {
			    //如果执行状态成功，那么就把返回信息写到指定的层里
			    if (ajax.readyState == 4 && ajax.status == 200) {
			        try{
			            paraFieldsOptions=ajax.responseText;
			            paraFieldsOptions=paraFieldsOptions.substring(paraFieldsOptions.indexOf("<"),paraFieldsOptions.length);
			            evaluateFieldsOptions=paraFieldsOptions;
			            
			
			            oRow = oTable.insertRow(-1);
			            oRow.style.height=24;
			            for(j=0; j<ncol; j++){
			            	oCell = oRow.insertCell(-1);
			            	oCell.noWrap=true;
			            	switch(j){
			            		case 0:
			            			oCell.style.background=rowColor;
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<input type='checkbox' name='checkbox_TriggerSetting' value='"+triggerSettingOfRowIndex+"'>";
			            			oCell.innerHTML = sHtml;
			            			//jQuery(oCell).append(oDiv);
			            			break;
			            		case 1:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<table width=100%><COLGROUP><COL width='30%'><COL width='70%'>"+
			            									"<tr>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(21840, user.getLanguage())%></td>"+
			            									"<td class=field colSpan=2><select id='tabletype"+index+triggerSettingOfRowIndex+"' name='tabletype"+index+triggerSettingOfRowIndex+"'>"+
			            									optionS+
			            									"</select><%=SystemEnv.getHtmlLabelName(18076, user.getLanguage())%>：<select id='datasource"+index+triggerSettingOfRowIndex+"' name='datasource"+index+triggerSettingOfRowIndex+"' onchange='changedatasource(this,"+index+","+triggerSettingOfRowIndex+")'>"+
											                "<option value=''></option><%for (int l = 0; l < pointArrayList.size(); l++) {%><option value='<%=pointArrayList.get(l)%>'><%=pointArrayList.get(l)%></option><%}%></select>"+
											                "</td></tr><TR style='height:1px'><TD class=Line colSpan=3></TD></TR>"+
			            									"<tr>"+
			            									"<td valign=top><%=SystemEnv.getHtmlLabelName(19422, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15190, user.getLanguage())%></td>"+
			            									"<td><table id='tableTable"+index+triggerSettingOfRowIndex+"' width=100% cols=4><COL width='25%'><COL width='25%'><COL width='10%'><COL width='10%'><COL width='30%'><tr>"+
			            									"<td class=field style='display:'><BUTTON type='button' class=Browser onClick='onShowTable(tablename"+index+triggerSettingOfRowIndex+"1,tablenamespan"+index+triggerSettingOfRowIndex+"1,formid"+index+triggerSettingOfRowIndex+"1)'></BUTTON>"+
			            									"<span id='tablenamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='formid"+index+triggerSettingOfRowIndex+"1' name='formid"+index+triggerSettingOfRowIndex+"1'></td>"+
			            									"<td class=field><input type=text class=Inputstyle size=10 id='tablename"+index+triggerSettingOfRowIndex+"1' name='tablename"+index+triggerSettingOfRowIndex+"1'></td>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(475, user.getLanguage())%></td>"+
			            									"<td class=field><input type=text class=Inputstyle size=6 id='tablebyname"+index+triggerSettingOfRowIndex+"1' name='tablebyname"+index+triggerSettingOfRowIndex+"1'></td>"+
			            									"</tr><input type='hidden' id='tableTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='tableTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'></table></td>"+
			            									"<td class=field valign=top nowrap>"+
			            									"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='addtable(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></a>"+
			            									"</td>"+
			            									"</tr><TR style='height:1px'><TD class=Line colSpan=3></TD></TR>"+
			            									"<tr>"+
			            									"<td valign=top><%=SystemEnv.getHtmlLabelName(21841, user.getLanguage())%></td>"+
			            									"<td class=field colSpan=2><textarea class=Inputstyle id='tableralations"+index+triggerSettingOfRowIndex+"' name='tableralations"+index+triggerSettingOfRowIndex+"' cols=68 rows=4></textarea><br><font color=red><%=SystemEnv.getHtmlLabelName(21842, user.getLanguage())%>a.id=b.id and a.wfid=b.wfid</font></td>"+
			            									"</tr><TR style='height:1px'><TD class=Line colSpan=3></TD></TR>"+
			            									"<tr>"+
			            									"<td><b><%=SystemEnv.getHtmlLabelName(21843, user.getLanguage())%></b></td>"+
			            									"<td align=right colSpan=4>"+
			            									"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='addParameterTable(parameterTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843, user.getLanguage())%></a>"+
			            									"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='deleteParameterTable(parameterTable"+index+triggerSettingOfRowIndex+")'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843, user.getLanguage())%></a>"+
			            									"</td>"+
			            									"</tr><TR style='height:1px'><TD class=Line1 colSpan=5></TD></TR>"+
			            									"<tr><td colSpan=5>"+
			            									"<table id='parameterTable"+index+triggerSettingOfRowIndex+"' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>"+
			            									"<tr class=Header>"+
			            									"<td></td>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(21844, user.getLanguage())%></td>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(19372, user.getLanguage())%></td>"+
			            									"</tr>"+
			            									"<tr>"+
			            									"<td class=field><input type='checkbox' name='checkbox_ParameterSetting' value=1></td>"+
			            									"<td class=field><button type='button' class=Browser onClick='showParaTableFiled(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+",1)'></button><span id='parafieldnamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='parafieldname"+index+triggerSettingOfRowIndex+"1' name='parafieldname"+index+triggerSettingOfRowIndex+"1'><input type=hidden id='parafieldtablename"+index+triggerSettingOfRowIndex+"1' name='parafieldtablename"+index+triggerSettingOfRowIndex+"1'></td>"+
			            									"<td class=field><select id='parawfField"+index+triggerSettingOfRowIndex+"1' name='parawfField"+index+triggerSettingOfRowIndex+"1'>"+paraFieldsOptions+"</select></td>"+
			            									"</tr><input type='hidden' id='parameterTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='parameterTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'>"+
			            									"</table>"+
			            									"</td></tr>"+
			            									"<tr>"+
			            									"<td><b><%=SystemEnv.getHtmlLabelName(21845, user.getLanguage())%></b></td>"+
			            									"<td align=right colSpan=4>"+
			            									"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='addEvaluateTable(evaluateTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846, user.getLanguage())%></a>"+
			            									"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='deleteEvaluateTable(evaluateTable"+index+triggerSettingOfRowIndex+")'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846, user.getLanguage())%></a>"+
			            									"</td>"+
			            									"</tr><TR style='height:1px'><TD class=Line1 colSpan=5></TD></TR>"+
			            									"<tr><td colSpan=5>"+
			            									"<table id='evaluateTable"+index+triggerSettingOfRowIndex+"' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>"+
			            									"<tr class=Header>"+
			            									"<td></td>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(21847, user.getLanguage())%></td>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(19372, user.getLanguage())%></td>"+
			            									"</tr>"+
			            									"<tr>"+
			            									"<td class=field><input type='checkbox' name='checkbox_EvaluateSetting' value=1></td>"+
			            									"<td class=field><button type='button' class=Browser onClick='showEvaluateTableFiled(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+",1)'></button><span id='evaluatefieldnamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='evaluatefieldname"+index+triggerSettingOfRowIndex+"1' name='evaluatefieldname"+index+triggerSettingOfRowIndex+"1'><input type=hidden id='evaluatefieldtablename"+index+triggerSettingOfRowIndex+"1' name='evaluatefieldtablename"+index+triggerSettingOfRowIndex+"1'></td>"+
			            									"<td class=field><select id='evaluatewfField"+index+triggerSettingOfRowIndex+"1' name='evaluatewfField"+index+triggerSettingOfRowIndex+"1'>"+evaluateFieldsOptions+"</select></td>"+
			            									"</tr><input type='hidden' id='evaluateTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='evaluateTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'>"+
			            									"</table>"+
			            									"</td></tr>"+
			            									"</table>";
			            			oDiv.innerHTML = sHtml;
			            			jQuery(oCell).append(oDiv);
			            			break;	
			            		}
			            	}
			            }catch(e){
			        }
			    }
			}
		}
		else {
		if(triggerFieldType==0){
			optionS = "<option value=1><%=SystemEnv.getHtmlLabelName(21778, user.getLanguage())%></option>";
			paraFieldsOptions = "<%=wfMainFieldsOptions%>";
			evaluateFieldsOptions = "<%=wfMainFieldsOptions%>";
		}else{
			optionS = "<option value=1><%=SystemEnv.getHtmlLabelName(21778, user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(19325, user.getLanguage())%></option>";
			paraFieldsOptions = "<%=wfFieldsOptions%>";
			evaluateFieldsOptions = "<%=wfFieldsOptions%>";
		}
		oRow = oTable.insertRow(-1);
		oRow.style.height=24;
		for(j=0; j<ncol; j++){
			oCell = oRow.insertCell(-1);
			oCell.noWrap=true;
			switch(j){
				case 0:
					oCell.style.background=rowColor;
					var oDiv = document.createElement("div");
					var sHtml = "<input type='checkbox' name='checkbox_TriggerSetting' value='"+triggerSettingOfRowIndex+"'>";
					oCell.innerHTML = sHtml;
					//jQuery(oCell).append(oDiv);
					break;
				case 1:
					var oDiv = document.createElement("div");
					var sHtml = "<table width=100%><COLGROUP><COL width='30%'><COL width='70%'>"+
											"<tr>"+
												"<td><%=SystemEnv.getHtmlLabelName(21840, user.getLanguage())%></td>"+
												"<td class=field colSpan=2><select id='tabletype"+index+triggerSettingOfRowIndex+"' name='tabletype"+index+triggerSettingOfRowIndex+"'>"+
													optionS+
											"</select><%=SystemEnv.getHtmlLabelName(18076, user.getLanguage())%>：<select id='datasource"+index+triggerSettingOfRowIndex+"' name='datasource"+index+triggerSettingOfRowIndex+"' onchange='changedatasource(this,"+index+","+triggerSettingOfRowIndex+")'>"+
											"<option value=''></option><%for (int l = 0; l < pointArrayList.size(); l++) {%><option value='<%=pointArrayList.get(l)%>'><%=pointArrayList.get(l)%></option><%}%></select>"+
											"</td></tr><TR style='height:1px'><TD class=Line colSpan=3></TD></TR>"+
											"<tr>"+
												"<td valign=top><%=SystemEnv.getHtmlLabelName(19422, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15190, user.getLanguage())%></td>"+
												"<td><table id='tableTable"+index+triggerSettingOfRowIndex+"' width=100% cols=4><COL width='25%'><COL width='25%'><COL width='10%'><COL width='10%'><COL width='30%'><tr>"+
												"<td class=field style='display:'><BUTTON type='button' class=Browser onClick='onShowTable(tablename"+index+triggerSettingOfRowIndex+"1,tablenamespan"+index+triggerSettingOfRowIndex+"1,formid"+index+triggerSettingOfRowIndex+"1)'></BUTTON>"+
												"<span id='tablenamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='formid"+index+triggerSettingOfRowIndex+"1' name='formid"+index+triggerSettingOfRowIndex+"1'></td>"+
												"<td class=field><input type=text class=Inputstyle size=10 id='tablename"+index+triggerSettingOfRowIndex+"1' name='tablename"+index+triggerSettingOfRowIndex+"1'></td>"+
												"<td><%=SystemEnv.getHtmlLabelName(475, user.getLanguage())%></td>"+
												"<td class=field><input type=text class=Inputstyle size=6 id='tablebyname"+index+triggerSettingOfRowIndex+"1' name='tablebyname"+index+triggerSettingOfRowIndex+"1'></td>"+
												"</tr><input type='hidden' id='tableTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='tableTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'></table></td>"+
												"<td class=field valign=top nowrap>"+
													"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='addtable(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></a>"+
												"</td>"+
											"</tr><TR style='height:1px'><TD class=Line colSpan=3></TD></TR>"+
											"<tr>"+
												"<td valign=top><%=SystemEnv.getHtmlLabelName(21841, user.getLanguage())%></td>"+
												"<td class=field colSpan=2><textarea class=Inputstyle id='tableralations"+index+triggerSettingOfRowIndex+"' name='tableralations"+index+triggerSettingOfRowIndex+"' cols=68 rows=4></textarea><br><font color=red><%=SystemEnv.getHtmlLabelName(21842, user.getLanguage())%>a.id=b.id and a.wfid=b.wfid</font></td>"+
											"</tr><TR style='height:1px'><TD class=Line colSpan=3></TD></TR>"+
											"<tr>"+
												"<td><b><%=SystemEnv.getHtmlLabelName(21843, user.getLanguage())%></b></td>"+
												"<td align=right colSpan=4>"+
													"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='addParameterTable(parameterTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843, user.getLanguage())%></a>"+
													"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='deleteParameterTable(parameterTable"+index+triggerSettingOfRowIndex+")'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843, user.getLanguage())%></a>"+
												"</td>"+
											"</tr><TR style='height:1px'><TD class=Line1 colSpan=5></TD></TR>"+
											"<tr><td colSpan=5>"+
												"<table id='parameterTable"+index+triggerSettingOfRowIndex+"' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>"+
													"<tr class=Header>"+
														"<td></td>"+
														"<td><%=SystemEnv.getHtmlLabelName(21844, user.getLanguage())%></td>"+
														"<td><%=SystemEnv.getHtmlLabelName(19372, user.getLanguage())%></td>"+
													"</tr>"+
													"<tr>"+
														"<td class=field><input type='checkbox' name='checkbox_ParameterSetting' value=1></td>"+
														"<td class=field><button type='button' class=Browser onClick='showParaTableFiled(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+",1)'></button><span id='parafieldnamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='parafieldname"+index+triggerSettingOfRowIndex+"1' name='parafieldname"+index+triggerSettingOfRowIndex+"1'><input type=hidden id='parafieldtablename"+index+triggerSettingOfRowIndex+"1' name='parafieldtablename"+index+triggerSettingOfRowIndex+"1'></td>"+
														"<td class=field><select id='parawfField"+index+triggerSettingOfRowIndex+"1' name='parawfField"+index+triggerSettingOfRowIndex+"1'>"+paraFieldsOptions+"</select></td>"+
													"</tr><input type='hidden' id='parameterTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='parameterTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'>"+
												"</table>"+
											"</td></tr>"+
											"<tr>"+
												"<td><b><%=SystemEnv.getHtmlLabelName(21845, user.getLanguage())%></b></td>"+
												"<td align=right colSpan=4>"+
													"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='addEvaluateTable(evaluateTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846, user.getLanguage())%></a>"+
													"<a style=\"color:#262626;cursor:pointer; TEXT-DECORATION:none\" onclick='deleteEvaluateTable(evaluateTable"+index+triggerSettingOfRowIndex+")'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846, user.getLanguage())%></a>"+
												"</td>"+
											"</tr><TR style='height:1px'><TD class=Line1 colSpan=5></TD></TR>"+
											"<tr><td colSpan=5>"+
												"<table id='evaluateTable"+index+triggerSettingOfRowIndex+"' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>"+
													"<tr class=Header>"+
														"<td></td>"+
														"<td><%=SystemEnv.getHtmlLabelName(21847, user.getLanguage())%></td>"+
														"<td><%=SystemEnv.getHtmlLabelName(19372, user.getLanguage())%></td>"+
													"</tr>"+
													"<tr>"+
														"<td class=field><input type='checkbox' name='checkbox_EvaluateSetting' value=1></td>"+
														"<td class=field><button type='button' class=Browser onClick='showEvaluateTableFiled(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+",1)'></button><span id='evaluatefieldnamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='evaluatefieldname"+index+triggerSettingOfRowIndex+"1' name='evaluatefieldname"+index+triggerSettingOfRowIndex+"1'><input type=hidden id='evaluatefieldtablename"+index+triggerSettingOfRowIndex+"1' name='evaluatefieldtablename"+index+triggerSettingOfRowIndex+"1'></td>"+
														"<td class=field><select id='evaluatewfField"+index+triggerSettingOfRowIndex+"1' name='evaluatewfField"+index+triggerSettingOfRowIndex+"1'>"+evaluateFieldsOptions+"</select></td>"+
													"</tr><input type='hidden' id='evaluateTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='evaluateTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'>"+
												"</table>"+
											"</td></tr>"+
											"</table>";
					oDiv.innerHTML = sHtml;
					jQuery(oCell).append(oDiv);
					break;	
			}
		}
		}
		rowindex = rowindex*1 +1;
	}
	function changedatasource(obj,tindex,tindex1){
	    var oTable=$G("tableTable"+tindex+tindex1);
	    var rows = oTable.rows.length ;
        for(i=0; i < rows;i++){
        if(obj.value==""){
        oTable.rows(i).cells(0).style.display='';
        }else{
        oTable.rows(i).cells(0).style.display='none';
        }
        }
	}
	function addtable(oTable,firstindex,secindex){
		rowindex = $G("tableTableRowsNum_"+firstindex+"_"+secindex).value*1;
		$G("tableTableRowsNum_"+firstindex+"_"+secindex).value = rowindex*1 + 1;
		datasource=$G("datasource"+firstindex+secindex).value;
    rowColor = getRowBg();
		ncol = jQuery(oTable).attr("cols");
		oRow = oTable.insertRow(-1);
		oRow.style.height=24;
		for(j=0; j<ncol; j++){
			oCell = oRow.insertCell(-1);
			oCell.noWrap=true;
			oCell.style.background=rowColor;
			switch(j){
				case 0:
				    if(datasource==""){
                    oCell.style.display='';
                    }else{
                    oCell.style.display='none';
                    }
					var oDiv = document.createElement("div");
					var sHtml = "<BUTTON type='button' class=Browser onClick='onShowTable(tablename"+firstindex+secindex+rowindex+",tablenamespan"+firstindex+secindex+rowindex+",formid"+firstindex+secindex+rowindex+")'></BUTTON>"+
											"<span id=tablenamespan"+firstindex+secindex+rowindex+"></span><input type=hidden id='formid"+firstindex+secindex+rowindex+"' name='formid"+firstindex+secindex+rowindex+"'>";
					oDiv.innerHTML = sHtml;
					jQuery(oCell).append(oDiv);
					break;
				case 1:
					var oDiv = document.createElement("div");
					var sHtml = "<input type=text class=Inputstyle size=10 id=tablename"+firstindex+secindex+rowindex+" name=tablename"+firstindex+secindex+rowindex+">";
					oDiv.innerHTML = sHtml;
					jQuery(oCell).append(oDiv);
					break;
				case 2:
					var oDiv = document.createElement("div");
					var sHtml = "<%=SystemEnv.getHtmlLabelName(475, user.getLanguage())%>";
					oDiv.innerHTML = sHtml;
					jQuery(oCell).append(oDiv);
					break;
				case 3:
					var oDiv = document.createElement("div");
					var sHtml = "<input type=text class=Inputstyle size=6 id=tablebyname"+firstindex+secindex+rowindex+" name=tablebyname"+firstindex+secindex+rowindex+">";
					oDiv.innerHTML = sHtml;
					jQuery(oCell).append(oDiv);
					break;
			}
		}
	}
	function deleteParameterTable(oTable){
    curindex=0;
    len = oTable.rows.length;
    var i=0;
    var rowsum1 = 0;
    var delsum=0;
    for(i=len-1; i >= 1;i--) {
        if (oTable.rows[i].cells[0].all[0].checked){
            //rowsum1 += 1;
            delsum += 1;
        }
    }
    if(delsum<1){
    	alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>");
    }else{
        if(confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>")){
            for(i=len-1; i >= 1;i--) {
                if (oTable.rows[i].cells[0].all[0].name=='checkbox_ParameterSetting'){
                    if(oTable.rows[i].cells[0].all[0].checked==true) {
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("nodeid_"+document.frmlinkageviewattr.elements[i].value+",","");
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("selectfieldid_"+document.frmlinkageviewattr.elements[i].value+",","");
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("selectfieldvalue_"+document.frmlinkageviewattr.elements[i].value+",","");
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("changefieldids_"+document.frmlinkageviewattr.elements[i].value+",","");
                        oTable.deleteRow(i);
                        curindex--;
                    }
                    //rowsum1 -=1;
                }

            }
            //$GetEle("rownum").value=curindex;
        }

    }
	}
	function addParameterTable(oTable,firstindex,secindex){
		triggerFieldType = $GetEle("triggerFieldType"+firstindex).value;
		triggerFieldId = $GetEle("triggerField"+firstindex).value;
		
		obj = "tableTable"+firstindex+secindex;
		
		rowindex = $GetEle("parameterTableRowsNum_"+firstindex+"_"+secindex).value*1;
		$GetEle("parameterTableRowsNum_"+firstindex+"_"+secindex).value = rowindex*1 + 1;
		rowColor = getRowBg();
		ncol = jQuery(oTable).attr("cols");
			
		paraFieldsOptions = "";
		if(triggerFieldType==0){
			paraFieldsOptions = "<%=wfMainFieldsOptions%>";
		
			oRow = oTable.insertRow(-1);
			oRow.style.height=24;
			for(j=0; j<ncol; j++){
				oCell = oRow.insertCell(-1);
				oCell.noWrap=true;
				oCell.style.background=rowColor;
				switch(j){
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='checkbox_ParameterSetting' value='"+rowindex+"'>";
						oCell.innerHTML = sHtml;
						//jQuery(oCell).append(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml = "<button type='button' class=Browser onClick='showParaTableFiled("+obj+","+firstindex+","+secindex+","+rowindex+")'></button>"+
												"<span id='parafieldnamespan"+firstindex+secindex+rowindex+"'></span><input type=hidden id='parafieldname"+firstindex+secindex+rowindex+"' name='parafieldname"+firstindex+secindex+rowindex+"'><input type=hidden id='parafieldtablename"+firstindex+secindex+rowindex+"' name='parafieldtablename"+firstindex+secindex+rowindex+"'>";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 2:
						var oDiv = document.createElement("div");
						var sHtml = "<select id='parawfField"+firstindex+secindex+rowindex+"' name='parawfField"+firstindex+secindex+rowindex+"'>"+
												paraFieldsOptions+
												"</select>";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
				}
			}
		}else{
			var ajax=ajaxinit();
			ajax.open("POST", "triggerdetailoption.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("wfid=<%=wfid%>&fieldid="+triggerFieldId);
			//获取执行状态
			ajax.onreadystatechange = function() {
			    //如果执行状态成功，那么就把返回信息写到指定的层里
			    if (ajax.readyState == 4 && ajax.status == 200) {
			        try{
			            paraFieldsOptions=ajax.responseText;
			            paraFieldsOptions=paraFieldsOptions.substring(paraFieldsOptions.indexOf("<"),paraFieldsOptions.length);
			            
			            oRow = oTable.insertRow(-1);
			            oRow.style.height=24;
			            for(j=0; j<ncol; j++){
			            	oCell = oRow.insertCell(-1);
			            	oCell.noWrap=true;
			            	oCell.style.background=rowColor;
			            	switch(j){
			            		case 0:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<input type='checkbox' name='checkbox_ParameterSetting' value='"+rowindex+"'>";
			            			oCell.innerHTML = sHtml;
			            			//jQuery(oCell).append(oDiv);
			            			break;
			            		case 1:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<button type='button' class=Browser onClick='showParaTableFiled("+obj+","+firstindex+","+secindex+","+rowindex+")'></button>"+
			            									"<span id='parafieldnamespan"+firstindex+secindex+rowindex+"'></span><input type=hidden id='parafieldname"+firstindex+secindex+rowindex+"' name='parafieldname"+firstindex+secindex+rowindex+"'><input type=hidden id='parafieldtablename"+firstindex+secindex+rowindex+"' name='parafieldtablename"+firstindex+secindex+rowindex+"'>";
			            			oDiv.innerHTML = sHtml;
			            			jQuery(oCell).append(oDiv);
			            			break;
			            		case 2:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<select id='parawfField"+firstindex+secindex+rowindex+"' name='parawfField"+firstindex+secindex+rowindex+"'>"+
			            									paraFieldsOptions+
			            									"</select>";
			            			oDiv.innerHTML = sHtml;
			            			jQuery(oCell).append(oDiv);
			            			break;
			            	}
			            }
			        }catch(e){
			        }
			    }
			}
		}
	}
	function deleteEvaluateTable(oTable){
    curindex=0;
    len = oTable.rows.length;
    var i=0;
    var rowsum1 = 0;
    var delsum=0;
    for(i=len-1; i >= 1;i--) {
        if (oTable.rows[i].cells[0].all[0].checked){
            //rowsum1 += 1;
            delsum+=1;
        }
    }
    if(delsum<1){
    	alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>");
    }else{
        if(confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>")){
            for(i=len-1; i >= 1;i--) {
                if (oTable.rows[i].cells[0].all[0].name=='checkbox_EvaluateSetting'){
                    if(oTable.rows[i].cells[0].all[0].checked==true) {
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("nodeid_"+document.frmlinkageviewattr.elements[i].value+",","");
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("selectfieldid_"+document.frmlinkageviewattr.elements[i].value+",","");
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("selectfieldvalue_"+document.frmlinkageviewattr.elements[i].value+",","");
                        //$GetEle('checkfield').value = ($GetEle('checkfield').value).replace("changefieldids_"+document.frmlinkageviewattr.elements[i].value+",","");
                        oTable.deleteRow(i);
                        curindex--;
                    }
                    //rowsum1 -=1;
                }

            }
            //$GetEle("rownum").value=curindex;
        }

    }
	}
	function addEvaluateTable(oTable,firstindex,secindex){	
		triggerFieldType = $GetEle("triggerFieldType"+firstindex).value;
		triggerFieldId = $GetEle("triggerField"+firstindex).value;
		optionS = "";
		paraFieldsOptions = "";
		evaluateFieldsOptions = "";
		
		obj = "tableTable"+firstindex+secindex;
		
		rowindex = $GetEle("evaluateTableRowsNum_"+firstindex+"_"+secindex).value*1;
		$GetEle("evaluateTableRowsNum_"+firstindex+"_"+secindex).value = rowindex*1 + 1;
    rowColor = getRowBg();
		ncol = jQuery(oTable).attr("cols");
		if(triggerFieldType==0){
			evaluateFieldsOptions  = "<%=wfMainFieldsOptions%>";
		
			oRow = oTable.insertRow(-1);
			oRow.style.height=24;
			for(j=0; j<ncol; j++){
				oCell = oRow.insertCell(-1);
				oCell.noWrap=true;
				oCell.style.background=rowColor;
				switch(j){
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='checkbox_EvaluateSetting' value='"+rowindex+"'>";
						oCell.innerHTML = sHtml;
						//jQuery(oCell).append(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml = "<button type='button' class=Browser onClick='showEvaluateTableFiled("+obj+","+firstindex+","+secindex+","+rowindex+")'></button>"+
												"<span id='evaluatefieldnamespan"+firstindex+secindex+rowindex+"'></span><input type=hidden id='evaluatefieldname"+firstindex+secindex+rowindex+"' name='evaluatefieldname"+firstindex+secindex+rowindex+"'><input type=hidden id='evaluatefieldtablename"+firstindex+secindex+rowindex+"' name='evaluatefieldtablename"+firstindex+secindex+rowindex+"'>";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 2:
						var oDiv = document.createElement("div");
						var sHtml = "<select id='evaluatewfField"+firstindex+secindex+rowindex+"' name='evaluatewfField"+firstindex+secindex+rowindex+"'>"+
												evaluateFieldsOptions+
												"</select>";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
				}
			}
		}else{
			var ajax=ajaxinit();
			ajax.open("POST", "triggerdetailoption.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("wfid=<%=wfid%>&fieldid="+triggerFieldId);
			//获取执行状态
			ajax.onreadystatechange = function() {
			    //如果执行状态成功，那么就把返回信息写到指定的层里
			    if (ajax.readyState == 4 && ajax.status == 200) {
			        try{
			            evaluateFieldsOptions=ajax.responseText;
			            evaluateFieldsOptions=evaluateFieldsOptions.substring(evaluateFieldsOptions.indexOf("<"),evaluateFieldsOptions.length);
			            
			            oRow = oTable.insertRow(-1);
			            oRow.style.height=24;
			            for(j=0; j<ncol; j++){
			            	oCell = oRow.insertCell(-1);
			            	oCell.noWrap=true;
			            	oCell.style.background=rowColor;
			            	switch(j){
			            		case 0:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<input type='checkbox' name='checkbox_EvaluateSetting' value='"+rowindex+"'>";
			            			oCell.innerHTML = sHtml;
			            			//jQuery(oCell).append(oDiv);
			            			break;
			            		case 1:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<button type='button' class=Browser onClick='showEvaluateTableFiled("+obj+","+firstindex+","+secindex+","+rowindex+")'></button>"+
			            									"<span id='evaluatefieldnamespan"+firstindex+secindex+rowindex+"'></span><input type=hidden id='evaluatefieldname"+firstindex+secindex+rowindex+"' name='evaluatefieldname"+firstindex+secindex+rowindex+"'><input type=hidden id='evaluatefieldtablename"+firstindex+secindex+rowindex+"' name='evaluatefieldtablename"+firstindex+secindex+rowindex+"'>";
			            			oDiv.innerHTML = sHtml;
			            			jQuery(oCell).append(oDiv);
			            			break;
			            		case 2:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<select id='evaluatewfField"+firstindex+secindex+rowindex+"' name='evaluatewfField"+firstindex+secindex+rowindex+"'>"+
			            									evaluateFieldsOptions+
			            									"</select>";
			            			oDiv.innerHTML = sHtml;
			            			jQuery(oCell).append(oDiv);
			            			break;
			            	}
			            }
			    		}catch(e){}
			    }
			}
		}
	}


function prepShowHtml(formid,wfid,nodeid,isbill,layouttype,ajax){
	if(confirm("<%=SystemEnv.getHtmlLabelName(23708, user.getLanguage())%>")){
		nodefieldhtml.needcreatenew.value = "1";
	}else{
		nodefieldhtml.needcreatenew.value = "0";
	}
    tab000001OldURL="";
    nodefieldhtml.needprep.value = "1";
	doPost(nodefieldhtml,tab2);
	//上面那句判断是提示要不要先保存的。下面这句是跳转页面的。完全可以不保存仍旧跳转
	callFunction(formid,wfid,nodeid,isbill,layouttype,ajax);
}

function fieldbatchsave(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(23708, user.getLanguage())%>")){
		nodefieldhtml.needcreatenew.value = "1";
	}else{
		nodefieldhtml.needcreatenew.value = "0";
	}
    tab000001OldURL="";
	doPost(nodefieldhtml,tab2) ;
}

function formnodedel(){
    len=document.fromaddtab.elements.length;
	var i=0;
	for(i=0;i<len;i++){
		if (document.fromaddtab.elements[i].name=='delete_form_id'||document.fromaddtab.elements[i].name=='delete_newform_id')
			if(document.fromaddtab.elements[i].checked)
				break;
	}
	if(i==len){
		alert("<%=SystemEnv.getHtmlLabelName(15445, user.getLanguage())%>");
		return false;
	}
    if(confirm("<%=SystemEnv.getHtmlLabelName(15459, user.getLanguage())%>?")){
        fromaddtab.action = "/workflow/form/delforms.jsp";
        doPost(fromaddtab,tab01);
    }
}

//by cyril
var designTime = '';
var isEdit = <%=Util.getIntValue(WFManager.getIsEdit(), 0)%>;
var usrId =<%=user.getUID()%>;
var editor=<%=WFManager.getEditor()%>;

var wfEditor = '/workflow/workflow/wfEditor.jsp?wfid=<%=wfid%>&editor=<%=WFManager.getEditor()%>';

function addRowx(obj)
{       
        var oTbody = fromfieldoTable.tBodies[0];
			
		var ncol = oTbody.rows[0].cells.length;
			
		var oRow = oTbody.insertRow(-1);
			
		var rowindex = oRow.getAttribute("rowIndex") - 1;
       
        <%String sHtml1 = "";
			String sHtml2 = "";
			String sHtml3 = "";

			// sHtml1="<tr class=header>";
			// sHtml1+="<td width=45% align=center class=field>"+SystemEnv.getHtmlLabelName(15453,user.getLanguage())+"</td>";
			// sHtml1+="<td width=10% align=center class=field>"+SystemEnv.getHtmlLabelName(104,user.getLanguage())+"</td>";
			// sHtml1+="<td width=45% align=center class=field>"+SystemEnv.getHtmlLabelName(18766,user.getLanguage())+"</td>";
			// sHtml1+="<td>&nbsp;</td></tr>";

			//sHtml1+="<tr><td vaglin=middle>";
			sHtml1 += "<select class=inputstyle  size=15 name='srcListMul"
					+ "\"+rowindex+\"' multiple style='width:100%' onchange=showtitle(event) ondblclick=addSrcToDestList3('srcListMul"
					+ "\"+rowindex+\"','destListMul" + "\"+rowindex+\"')>";

			FieldMainManager.resetParameter();
			FieldMainManager.setUserid(user.getUID());
			FieldMainManager.selectAllCodViewDetailField();
			while (FieldMainManager.next()) {
				sHtml1 += "<option value='"
						+ FieldMainManager.getFieldManager().getFieldid()
						+ "'>"
						+ FieldMainManager.getFieldManager().getFieldname()
						+ "["
						+ SystemEnv.getHtmlLabelName(63, user.getLanguage())
						+ ":"
						+ FieldMainManager.getFieldManager().getFielddbtype()
						+ "]";
				if (!Util.null2String(
						FieldMainManager.getFieldManager().getDescription())
						.equals("")) {
					sHtml1 += "["
							+ SystemEnv.getHtmlLabelName(433,
									user.getLanguage())
							+ ":"
							+ FieldMainManager.getFieldManager()
									.getDescription() + "]";
				}
				sHtml1 += "</option>";
			}
			sHtml1 += "</select>";
			//"</td>";

			//sHtml1+="<td align=center>
			sHtml2 += "<img src='/images/arrow_u.gif' title='"
					+ SystemEnv.getHtmlLabelName(15084, user.getLanguage())
					+ "' onclick=upFromDestList3('destListMul"
					+ "\"+rowindex+\"')>";
			sHtml2 += "<br><br>";
			sHtml2 += "<img src='/images/arrow_l.gif' title='"
					+ SystemEnv.getHtmlLabelName(91, user.getLanguage())
					+ "' onClick=deleteFromDestList3('srcListMul"
					+ "\"+rowindex+\"','destListMul" + "\"+rowindex+\"')>";
			sHtml2 += "<br><br>";
			sHtml2 += "<img src='/images/arrow_r.gif'  title='"
					+ SystemEnv.getHtmlLabelName(456, user.getLanguage())
					+ "' onclick=addSrcToDestList3('srcListMul"
					+ "\"+rowindex+\"','destListMul" + "\"+rowindex+\"')>";
			sHtml2 += "<br><br>";
			sHtml2 += "<img src='/images/arrow_d.gif'   title='"
					+ SystemEnv.getHtmlLabelName(15085, user.getLanguage())
					+ "' onclick=downFromDestList3('destListMul"
					+ "\"+rowindex+\"')>";
			//sHtml1+="</td>";

			//sHtml1+="<td align=center>";
			sHtml3 += "<select class=inputstyle  size=15 name='destListMul"
					+ "\"+rowindex+\"' multiple style='width:100%' ondblclick=deleteFromDestList3('srcListMul"
					+ "\"+rowindex+\"','destListMul" + "\"+rowindex+\"')>";

			FormFieldMainManager.setFormid(formid);
			FormFieldMainManager.setGroupId(-1);
			FormFieldMainManager.selectDetailFormField();

			while (FormFieldMainManager.next()) {
				sHtml3 += "<option value='"
						+ FormFieldMainManager.getFieldid()
						+ "'>"
						+ DetailFieldComInfo.getFieldname(""
								+ FormFieldMainManager.getFieldid());
				sHtml3 += "["
						+ SystemEnv.getHtmlLabelName(63, user.getLanguage())
						+ ":" + FormFieldMainManager.getFieldDbType() + "]";
				if (!FormFieldMainManager.getDescription().equals("")) {
					sHtml3 += "["
							+ SystemEnv.getHtmlLabelName(433,
									user.getLanguage()) + ":"
							+ FormFieldMainManager.getDescription() + "]";
				}
				sHtml3 += "</option>";
			}

			sHtml3 += "</select>";
			//</td><td >&nbsp;</td></tr>";%>

       // oCell = oRow.insertCell(-1);
       // oCell.style.height=24;
       // oCell.style.background= "#E7E7E7";
       // var oDiv = document.createElement("div");
       // var sHtml = "<%=sHtml1%>" ;
        //alert(sHtml);
       // oDiv.innerHTML = sHtml;
       // jQuery(oCell).append(oDiv);
        for(j=0; j<ncol; j++) {
        oCell = oRow.insertCell(-1);
		oCell.style.height = 24;
		
		switch(j) {
		case 0:
		{ 
		var oDiv = document.createElement("div");
        var sHtml = "<%=sHtml1%>" ;
        //alert(sHtml);
        oDiv.innerHTML = sHtml;
        jQuery(oCell).append(oDiv);
        break;}
		case 1:
		{
		var oDiv = document.createElement("div");
		oDiv.style.textAlign = "center";
        var sHtml = "<%=sHtml2%>" ;
        //alert(sHtml);
        oDiv.innerHTML = sHtml;
        jQuery(oCell).append(oDiv);
        break;
		}
		case 2:
		{
		var oDiv = document.createElement("div");
        var sHtml = "<%=sHtml3%>" ;
        //alert(sHtml);
        oDiv.innerHTML = sHtml;
        jQuery(oCell).append(oDiv);
        break;
		}
		case 3:
		}
		
        }
       // rowindex = rowindex*1 +1;
       //curindex = curindex*1 +1;
        //$GetEle("nodesnum"+obj).value = curindex ;
        //$GetEle('indexnum'+obj).value = rowindex;
    
    
}


//表单显示名
var fieldrowindex = 0;
function fieldlabeladdRow()
{
    var selectlangids = document.fieldlabelfrm.selectlangids.value;
    var rowColor="" ;
    rowColor = getRowBg();
	ncol = oTable.cols;
	var oOption=document.fieldlabelfrm.languageList;
	if(oOption.value==''){
		alert("<%=SystemEnv.getHtmlLabelName(15457, user.getLanguage())%>！");
		return;
	}
	if(selectlangids.indexOf(oOption.value)!=-1){
		alert("<%=SystemEnv.getHtmlLabelName(15458, user.getLanguage())%>!");
		return;
	}
	oRow = oTable.rows[0];          		//在table中第一行,返回行的id
	oCell = oRow.insertCell(-1);
	//oCell.style.background= rowColor;
	//oCell.style.height=23;
	var oDiv = document.createElement("div");
	var sHtml = "<input type='checkbox' name='check_lang' value='" + oOption.value +"'>";
	sHtml += "<%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%>("+ languagespan.innerHTML +")";
	oDiv.innerHTML = sHtml;    //内嵌html语句
	jQuery(oCell).append(oDiv);   //将odiv插入到ocell后面,作为ocell的内容
    eval(document.fieldlabelfrm.insertlabels.value);

	fieldrowindex +=parseInt(document.fieldlabelfrm.rownum.value);
	selectlangids += oOption.value;
	selectlangids += ",";
    document.fieldlabelfrm.selectlangids.value=selectlangids;
}

var fieldid = new Array();
var fieldlable = new Array();
var rowcurindex = 0;
var currowcalexp = "";

function addRowCal(){
    if(currowcalexp==""){
        return;
    }
    var error_msg = "<%=SystemEnv.getHtmlLabelName(27783,user.getLanguage())%>"; 
    
    //------------------------------------------
    // 表达式check开始
    //------------------------------------------
    var equalsIndex = currowcalexp.indexOf("=");
    if (equalsIndex < 0) {
    	alert(error_msg);
    	return;
    }
    //等于号之前的内容
    var calexpEqa_bef = currowcalexp.substring(0, equalsIndex);
    //等于号之后的内容
    var calexpEqa_aft = currowcalexp.substring(equalsIndex+1, currowcalexp.length);
	//赋值语句之前必须指定一个变量
	if (calexpEqa_bef.indexOf("detailfield_") == -1) {
		alert(error_msg);
		return;
	}
    
    calexpEqa_bef = calexpEqa_bef.replace("detailfield_", "");
    //赋值语句之前指定了过多的变量
    if (calexpEqa_bef.indexOf("detailfield_") != -1) {
    	alert(error_msg);
		return;
    }
    //第一个等号之前不能含有操作符
    var symbols = ["+", "-", "*", "/", "(", ")"];
    for (var i=0; i<symbols.length; i++) {
    	var symbol = symbols[i];
    	if (calexpEqa_bef.indexOf(symbol) != -1) {
    		alert(error_msg);
			return;
    	}
    }
    
    calexpEqa_aft = calexpEqa_aft.replace(new RegExp("detailfield_" ,"gm"), "");
    try {
    	if (isNaN(eval("("+calexpEqa_aft+")"))) {
    		alert(error_msg);
    		return;
    	}
    } catch (e) {
    	alert(error_msg);
    	return;
    }
    //------------------------------------------
    // 表达式check结束
    //------------------------------------------
    oRow = $("#allcalexp")[0].insertRow(-1);
    oRow.style.background= "#efefef";

    oCell = oRow.insertCell(-1);
    oCell.style.color="red";
    var oDiv = document.createElement("div");
    var sHtml = $GetEle("rowcalexp").innerHTML+"<input type='hidden' name='calstr' value='"+currowcalexp+"'>";
    //alert(sHtml);
    oDiv.innerHTML = sHtml;
    jQuery(oCell).append(oDiv);

    oDiv = document.createElement("div");
    oCell = oRow.insertCell(-1);
    var sHtml = "<a href='#' onclick='deleteRowcal(this)'><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>";
    oDiv.innerHTML = sHtml;
    jQuery(oCell).append(oDiv);

    clearexp();
}



function deleteRowcal(obj){
    //alert(obj.parentElement.parentElement.parentElement.getAttribute("rowIndex"));
    if(confirm("<%=SystemEnv.getHtmlLabelName(18688, user.getLanguage())%>")){
        $("#allcalexp")[0].deleteRow(obj.parentElement.parentElement.parentElement.getAttribute("rowIndex"));
    }
}

function addcalnumber(){
    var calnumber = prompt("<%=SystemEnv.getHtmlLabelName(18689, user.getLanguage())%>","1.0");
    if (isNaN(calnumber)){
    	alert("<%=SystemEnv.getHtmlLabelName(20321,user.getLanguage())%>");
		return;
	}
    if(calnumber!=null){
        fieldid[rowcurindex]=calnumber;
        fieldlable[rowcurindex]=calnumber;
        rowcurindex++;

        refreshcal();
    }
}

function OnMultiSubmit(){
	 if(confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>")) {
         doPost(BillMDetTab000,tab000);
     }
}
//单据管理--end

function nodeopaddsave(obj){
    var sss=document.addopform.groupname.value;
    if(sss.length2()>60){
    alert("<%=SystemEnv.getHtmlLabelName(18686, user.getLanguage())%>");
    }else{
    if (check_form(addopform, 'groupname')) {
        var rowindex4op = 0;
        var len = document.addopform.elements.length;
        var rowsum1 = 0;
        var obj_tmp;
        for (i = 0; i < len; i++) {
            if (document.addopform.elements[i].name == 'check_node') {
                rowsum1 += 1;
                obj_tmp = document.addopform.elements[i];
            }
        }

        if (rowsum1 > 0) {
            rowindex4op = parseInt(obj_tmp.getAttribute("rowIndex")) + 1;
        }

        addopform.groupnum.value = rowindex4op;
		
        obj.disabled = true;
        doPost(addopform, tab2);
    }
   }
}

function portsave(obj){
	var portrowsum = parseInt($GetEle("portrowsum").innerHTML);
	if(rowindex4port==-1)
    rowindex4port=portrowsum;
    if(portrowsum>rowindex4port){
    	rowindex4port = portrowsum;
    }
    var elementslength = document.portform.elements.length;
    for(var i=0;i<elementslength;i++){
        var pf_elementtmp = document.portform.elements[i];
        if(pf_elementtmp != null && pf_elementtmp.name.indexOf("por")==0&&pf_elementtmp.name.indexOf("_link")==(pf_elementtmp.name.length-5)){
    //if($GetEle("por"+i+"_link") != null){
	    	tempValue = pf_elementtmp.value;
		    	if(tempValue==""){
		    	 alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
		    	 return;
		    	}
		    }
		
	   //TD23877:20110505 出口提示信息的长度控制 ADD BY QB START    
	   if ($GetEle("por"+i+"_tipsinfo") != null) {
	   	   temptips = $GetEle("por"+i+"_tipsinfo").value;
	   	   if (realLength(temptips)>500) {
	   	   	alert("<%=SystemEnv.getHtmlLabelName(20246, user.getLanguage())%>"+"500("+"<%=SystemEnv.getHtmlLabelName(20247, user.getLanguage())%>"+")");
	   	   	return null;
	   	   }
	   }
	   //TD23877:20110505 出口提示信息的长度控制 ADD BY QB END  
    }
    
    portform.nodessum.value=rowindex4port;
    portform.delids.value=delids4port;
    obj.disabled=true;
    tab4oldurl="";  
    doPost(portform,tab3);
}
//TD23877:20110505 出口提示信息的长度控制 ADD BY QB START
function checkAddInputInfoLength(obj){
	var portrowsum = parseInt($GetEle("portrowsum").innerHTML);
		if(rowindex4port==-1)
	    rowindex4port=portrowsum;
	    if(portrowsum>rowindex4port){
	    	rowindex4port = portrowsum;
    }
    for(var i=0;i<rowindex4port;i++){
    	if ($GetEle("por"+i+"_tipsinfo") != null) {
	   	   temptips = $GetEle("por"+i+"_tipsinfo").value;
	   	   tempValue = $GetEle("por"+i+"_link").value;
	   	   var size = $GetEle("por"+i+"_tipsinfo").maxLength;
	   	   if (realLength(temptips)>500) {
	   	   		alert("<%=SystemEnv.getHtmlLabelName(20246, user.getLanguage())%>"+"500("+"<%=SystemEnv.getHtmlLabelName(20247, user.getLanguage())%>"+")");
		   	    while(true){
					temptips = temptips.substring(0,temptips.length-1);					
					if(realLength(temptips)<=size){
						$GetEle("por"+i+"_tipsinfo").value = temptips;
						return;
					}
				}
	   	   }
	   }
    }
}
function checkInputInfoLength(rowsum){
	var tmpvalue = $G("por"+rowsum+"_tipsinfo").value;
	var size = $G("por"+rowsum+"_tipsinfo").maxLength;
	if (realLength(tmpvalue)>500) {
		alert("<%=SystemEnv.getHtmlLabelName(20246, user.getLanguage())%>"+"500("+"<%=SystemEnv.getHtmlLabelName(20247, user.getLanguage())%>"+")");
		while(true){ 	    	
			tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);			
			if(realLength(tmpvalue)<=size){
				$GetEle("por"+rowsum+"_tipsinfo").value = tmpvalue;
				return;
			}
		}
	}
}
//TD23877:20110505 出口提示信息的长度控制 ADD BY QB END    
function flowPlanSave(obj){
   type=document.flowPlanForm.frequencyt.value;
   sum=document.flowPlanForm.dateSum.value;
    if ((type=="0"&&sum>7)||(type=="1"&&sum>30)||(type=="2"&&sum>90)||(type=="3"&&sum>365))
    {
      alert('<%=SystemEnv.getHtmlLabelName(18819, user.getLanguage())%>');
      return;
    }
    obj.disabled=true;
    doPost(flowPlanForm,tab7);
}

function onchangeisbill(objval){
    var oldval=document.weaver.oldisbill.value;
    <%if (isnewform) {%>
    oldval = 0;//新表单
    <%}%>
    if(oldval!=3 && objval!=oldval){
       if(!confirm("<%=SystemEnv.getHtmlLabelName(18682, user.getLanguage())%>")){
            document.weaver.isbill.value=document.weaver.oldisbill.value;
       }
    }
    objval=$GetEle("isbill").value;
	if(objval==0){
		$G("formidSelect").style.display = '';
		$G("formidSelectSpan").style.display = '';
		$G("formid").value = "";
		while($G("formidSelectSpan").firstChild){
				$G("formidSelectSpan").removeChild($G("formidSelectSpan").firstChild);
		}
		$G("billidSelect").style.display = 'none';
		$G("billidSelectSpan").style.display = 'none';
        $G("isaffirmance").disabled=false;
        $G("isShowChart").disabled=false;
        $G("isImportDetail").value = 1;
        $G("isImportDetail").style.display = '';
        $G("isImportDetail_fake").style.display = 'none'; 
	}else{
        if(objval==1){
        	$G("billidSelect").style.display= '';
        	$G("billidSelectSpan").style.display= '';
        	$G("formidSelect").style.display = 'none';
        	$G("formidSelectSpan").style.display = 'none';
        	$G("formid").value = "";
            var endaffirmances=$GetEle("endaffirmances").value;
            var endShowCharts=$GetEle("endShowCharts").value;
            if(endaffirmances.indexOf(","+$G("billid").value+",")>-1){
                $GetEle("isaffirmance").checked=false;
                $GetEle("isaffirmance").disabled=true;
            }else{
                $GetEle("isaffirmance").disabled=false;
            }
            if(endShowCharts.indexOf(","+$G("billid").value+",")>-1){
                $GetEle("isShowChart").checked=false;
                $GetEle("isShowChart").disabled=true;
            }else{
                $GetEle("isShowChart").disabled=false;
            }
            $G("isImportDetail").value = 0;  
            $G("isImportDetail").style.display = 'none';
            $G("isImportDetail_fake").style.display = ''; 
        }else{
        	$G("formidSelect").style.display = 'none';
        	$G("formidSelectSpan").style.display = 'none';
        	$G("billidSelect").style.display = 'none';
        	$G("billidSelectSpan").style.display = 'none';
            $G("isaffirmance").disabled=false;
            $G("isShowChart").disabled=false;
			
            $G("isImportDetail").value = 1;
            $G("isImportDetail").style.display = '';
            $G("isImportDetail_fake").style.display = 'none';  
        }
    }
}
function changeOrderShow(){
	var orderbytype = $GetEle("orderbytype").value;
	if(orderbytype == 1){
		$GetEle("orderShowSpan").innerHTML="<%=SystemEnv.getHtmlLabelName(21629, user.getLanguage())%>";
	}else{
		$GetEle("orderShowSpan").innerHTML="<%=SystemEnv.getHtmlLabelName(21628, user.getLanguage())%>";
	}
}

function onchangeiscust(objval){
    var srctype=document.weaver.src.value;
	if(srctype=="editwf"&&objval<document.weaver.oldiscust.value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18685, user.getLanguage())%>")){
            document.weaver.iscust.value=document.weaver.oldiscust.value;
        }
	}
}
function onchangeformid(objval){
    var oldisbillval=document.weaver.oldisbill.value;
    var isbillval=document.weaver.isbill.value;
    <%if (isnewform) {%>
    oldisbillval = 0;//新表单
    <%}%>
	if(oldisbillval!=3 && isbillval==oldisbillval && objval!=document.weaver.oldformid.value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18683, user.getLanguage())%>")){
            document.weaver.formid.value=document.weaver.oldformid.value;
        }
	}
}
function onchangebillid(objval){
    var oldisbillval=document.weaver.oldisbill.value;
    var isbillval=document.weaver.isbill.value;
	if(oldisbillval!=3 && isbillval==oldisbillval && objval!=document.weaver.oldformid.value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18684, user.getLanguage())%>")){
            document.weaver.billid.value=document.weaver.oldformid.value;
        }
	}
}
//modify by xhheng @20050204 for TD 1538
function submitData(obj){
try{
	if(!checkLengtpointerCut("wfdes",'200',"<%=SystemEnv.getHtmlLabelName(15594, user.getLanguage())%>",'<%=SystemEnv.getHtmlLabelName(20246, user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247, user.getLanguage())%>')){
		return;
		}
}catch(e){}
    if (check_form(weaver,'wfname,subcompanyid')) {
        obj.disabled=true;
        var isbills=document.weaver.isbill.value;
        var iscust=document.weaver.iscust.value;
        var oldiscust=document.weaver.oldiscust.value;
        if(oldiscust!=iscust){
            tab2oldurl="";
        }
		if(isbills == "1"){
			var billid_t = $G("billid").value;
			var formid_t = $G("formid").value;
			if(billid_t == ""){
					if (formid_t == ""){
							if (formid_t > 0 && billid_t == ""){
						   } else {
									alert("<%=SystemEnv.getHtmlLabelName(27615,user.getLanguage())%>");
									obj.disabled=false;
									return;
							}							
					}
			}
		}else if(isbills == "0"){
			var formid_t = $G("formid").value;
			if(formid_t == ""){
				alert("<%=SystemEnv.getHtmlLabelName(27616,user.getLanguage())%>");
				obj.disabled=false;
				return;
			}
		}else{
			var _flag = $G("addwf0div").style.display;
			if("none" != _flag){
				alert("<%=SystemEnv.getHtmlLabelName(27617,user.getLanguage())%>");
				obj.disabled=false;
				return ;
			}
		}
        tab02oldurl="";
        tab03oldurl="";
        tab04oldurl="";
        tab05oldurl="";
        tab01oldurl="";
        tab2oldurl="";
        tab3oldurl="";
        tab4oldurl="";
        tab9oldurl="";
        tab10oldurl="";
        tab11oldurl="";
        if(isbills==0){
            var formids=document.weaver.formid.value;
            tab01url="/workflow/form/addform.jsp?formid="+formids+"&src=editform&ajax=1";
            //tab02url="/workflow/form/addformfield.jsp?ajax=1&formid="+formids;
            tab02iframesrc="/workflow/form/addformfield.jsp?formid="+formids;
            tab03url="/workflow/form/addformfieldlabel.jsp?ajax=1&formid="+formids;
            tab04url="/workflow/form/addformrowcal.jsp?ajax=1&formid="+formids;
            tab05url="/workflow/form/addformcolcal.jsp?ajax=1&formid="+formids;
            tabiframesrc="/workflow/workflow/BillManagementList.jsp";
        }else if(isbills==1){
            var billids=document.weaver.billid.value;
            tab01url="/workflow/form/manageform.jsp?ajax=1";
            tab02iframesrc="/workflow/workflow/wfError.jsp";
            tab03url="/workflow/workflow/wfError.jsp";
            tab04url="/workflow/workflow/wfError.jsp";
            tab05url="/workflow/workflow/wfError.jsp";
            tabiframesrc="/workflow/workflow/BillManagementDetail.jsp?billId="+billids;
        }else{
            tab01url="/workflow/form/manageform.jsp?ajax=1";
            tab02iframesrc="/workflow/workflow/wfError.jsp";
            tab03url="/workflow/workflow/wfError.jsp";
            tab04url="/workflow/workflow/wfError.jsp";
            tab05url="/workflow/workflow/wfError.jsp";
            tabiframesrc="/workflow/workflow/BillManagementList.jsp";
        }
        if(nowtab1=="tab01"){
                jQuery(document.getElementsByTagName("ul")[1].getElementsByTagName("li")[0]).trigger("click");
            }else if(nowtab1=="tab02"){
                jQuery(document.getElementsByTagName("ul")[1].getElementsByTagName("li")[1]).trigger("click");
            }else if(nowtab1=="tab03"){
                jQuery(document.getElementsByTagName("ul")[1].getElementsByTagName("li")[2]).trigger("click");
            }else if(nowtab1=="tab04"){
                jQuery(document.getElementsByTagName("ul")[1].getElementsByTagName("li")[3]).trigger("click");
            }else if(nowtab1=="tab05"){
                jQuery(document.getElementsByTagName("ul")[1].getElementsByTagName("li")[4]).trigger("click");
            }
        <%if (wfid.equals("0")) {%>
          weaver.submit();
        <%} else {%>
        doPost(weaver,tab1)  ;
        parent.wfleftFrame.location="wfmanage_left2.jsp?isTemplate=<%=isTemplate%>";
        refreshAddwf("<%=wfid%>");
        <%}%>
   }
}

function refreshAddwf(wfid1){
	var isbill1 = "";
	try{
		isbill1 = document.weaver.isbill.value;
	}catch(e){
		isbill1 = "";
	}
	if(isbill1 != ""){
		parent.wfmainFrame.location.href = "addwf.jsp?src=editwf&wfid="+wfid1+"&isTemplate=<%=isTemplate%>";
	}else{
		window.setTimeout(function(){refreshAddwf(wfid1);},100);
	}
}


function setNowTab0005(tabName){
    nowtab = tabName;
    if(tab0005OldURL != tab0005URL){
        doGet(tab0005, tab0005URL);
        tab0005OldURL = tab0005URL;
    }
}

</script>
</body>
<script type="text/javascript">
var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
function showDoc(){
	datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if(datas){
		$("input[name=helpdocid]").val(datas.id);
		$("#Documentname").html("<a href='/docs/docs/DocDsp.jsp?id="+datas.id+"'>"+datas.name+"</a>");
	}
}
function onShowFormSelect(isbill,inputName, spanName){
var datas,endaffirmances,endShowCharts,affpos,showpos;
datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfFormBrowser.jsp?isbill="+isbill,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
endaffirmances=$("#endaffirmances").val();
endShowCharts=$("#endShowCharts").val();

if (datas){
    if(datas.id!=""){
	    $(inputName).val(datas.id);
		if ($(inputName).val()==datas.id){
	    	$(spanName).html(datas.name);
		}
        if( isbill==1){
        	affpos=endaffirmances.indexOf(","+datas.id+",");
        
	        if (affpos>0){
		        $GetEle("isaffirmance").checked=false
		        $GetEle("isaffirmance").disabled=true
	        }else{
	        	$GetEle("isaffirmance").disabled=false
	        }
       		showpos=endShowCharts.indexOf(","+datas.id+",");
	        if(showpos>0){
		        $GetEle("isShowChart").checked=false
		        $GetEle("isShowChart").disabled=true
	        }
	        else{
	        	$GetEle("isShowChart").disabled=false
	        }
        }
    }
} else{
	    inputName.value=""
        $GetEle("isaffirmance").disabled=false
        $GetEle("isShowChart").disabled=false
	    if (isMand==1){
		    spanName.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	    }else{
		    spanName.innerHTML = ""
	    }
}
}

function onShowBrowser5html(formid,nodeid,isbill,layouttype){
	urls = "/workflow/workflow/WorkflowHtmlBrowser.jsp?formid="+formid+"&layouttype="+layouttype+"&isbill="+isbill;
	urls = "/systeminfo/BrowserMain.jsp?url="+encode(urls);
	datas = window.showModalDialog(urls);
	if(datas.id!=""){
		if (layouttype=="0"){
			document.all("showhtmlid").value=datas.id;
			document.all("showhtmlisform").value=datas.isForm;
			document.all("showhtmlname").value=datas.name;
			if(datas.id==""){
				$("#showhtmlspan").html("");
			}
			else{
				url="<a href='#' onclick=openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&layouttype=0&modeid="+datas.id+"')>"+datas.name+"</a>"
			
				$("#showhtmlspan").html(url);
			}
		} else {   
			document.all("mobilehtmlid").value=datas.id;
			document.all("mobilehtmlisform").value=datas.isForm;
			document.all("mobilehtmlname").value=datas.name;
			if( datas.id==""){
				$("#mobilehtmlspan").html("");
			}else{
				url="<a href='#' onclick=openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&layouttype=1&modeid="+datas.id+"')>"+datas.name+"</a>"
				$("#mobilehtmlspan").html(url);
			}
		}
	} else {
		if (layouttype=="0"){
			$G("showhtmlid").value = "";
			$G("showhtmlisform").value = "";
			$G("showhtmlname").value = "";
			$("#showhtmlspan").html("");
		} else{
			$G("mobilehtmlid").value = "";
			$G("mobilehtmlisform").value = "";
			$G("mobilehtmlname").value = "";
			$("#mobilehtmlspan").html("");
		}
	}
}

function onShowBrowser4html(formid,nodeid,isbill,layouttype){
	urls = "/workflow/workflow/WorkflowHtmlBrowser.jsp?formid="+formid+"&layouttype="+layouttype+"&isbill="+isbill;
	urls = "/systeminfo/BrowserMain.jsp?url="+encode(urls);
	datas = window.showModalDialog(urls,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas != null && datas != undefined) {
		if(datas.id != ""){
			if (layouttype=="0"){
				$G("showhtmlid").value=datas.id;
				$G("showhtmlisform").value=datas.isForm;
				$G("showhtmlname").value=datas.name;
				if(datas.id == ""){
					$("#showhtmlspan").html("");
				}
				else{
					url="<a href='#' onclick=openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&layouttype=0&modeid="+datas.id+"')>"+datas.name+"</a>"
				
					$("#showhtmlspan").html(url);
				}
			} else{
				$G("printhtmlid").value = datas.id;
				$G("printhtmlisform").value = datas.isForm;
				$G("printhtmlname").value = datas.name;
				if( datas.id == ""){
					$("#printhtmlspan").html("");
				}else{
					url="<a href='#' onclick=openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&layouttype=1&modeid="+datas.id+"')>"+datas.name+"</a>"
					$("#printhtmlspan").html(url);
				}
			}
		} else {
			if (layouttype=="0"){
				$G("showhtmlid").value = "";
				$G("showhtmlisform").value = "";
				$G("showhtmlname").value = "";
				$("#showhtmlspan").html("");
			} else{
				$G("printhtmlid").value = "";
				$G("printhtmlisform").value = "";
				$G("printhtmlname").value = "";
				$("#printhtmlspan").html("");
			}
		}
	}
}

function onShowBrowser4field(formid,nodeid,isbill,isprint){
    urls="/workflow/workflow/WorkflowModeBrowser.jsp?formid="+formid+"&isprint="+isprint+"&isbill="+isbill;
    urls = "/systeminfo/BrowserMain.jsp?url="+encode(urls);
    datas = window.showModalDialog(urls,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if(datas){
        if (isprint!="1"){
            $G("showmodeid").value = datas.id;
            $G("showisform").value = datas.isForm;
            $G("showmodename").value = datas.name;
            if (datas.id==""){
                $("#showmodespan").html("");
			}else{
                url="<a href='#' onclick=openFullWindowHaveBar('/workflow/mode/index.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&isprint=0&modeid="+datas.id+"')>"+datas.name+"</a>";
                $("#showmodespan").html(url);
			}
		}else{
			$G("printmodeid").value = datas.id;
			$G("printisform").value = datas.isForm;
			$G("printmodename").value = datas.name;

            if (datas.id==""){
            $("#printmodespan").html("");
            }else{
                url="<a href='#' onclick=openFullWindowHaveBar('/workflow/mode/index.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&isprint=1&modeid="+datas.id+"')>"+datas.name+"</a>"
                $("#printmodespan").html(url);
			}
		}
	}
}

function onShowBrowsers(wfid,formid,isbill){
	var src=$("#fromsrc").val();
	var url = "BrowserMain.jsp?url=OperatorCondition.jsp?fromsrc="+src+"&formid="+formid+"&isbill="+isbill;
	
	id = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (id != null && id != undefined) {
	        if (wuiUtil.getJsonValueByIndex(id, 0)!="") {
				$("#conditionss").val(wuiUtil.getJsonValueByIndex(id, 0));
				$("#conditions").html(wuiUtil.getJsonValueByIndex(id, 1));
				$("#conditioncn").val(wuiUtil.getJsonValueByIndex(id, 1));
				$("#fromsrc").val("2");
			}else{
				$("#conditionss").val("");
				$("#conditions").html("");
				$("#conditioncn").val("");
			}
	}
}



function onShowBrowser4opM(url,index,tmpindex){
	tmpid = "id_"+index;
	tmpname = "name_"+index;
	datas = window.showModalDialog(url + "?resourceids=," + $G(tmpid).value, "","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
        if (datas.id!= ""){
			$("#"+tmpname).html(datas.name.substr(1));
			
			$("input[name="+tmpid+"]").val(datas.id.substr(1));
			tmpindex.checked = true
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = tmpid.substr(8);
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}

function onShowBrowser4op(url,index,tmpindex){
	tmpid = "id_"+index;
	tmpname = "name_"+index;
	url=url+"?selectedids=" + $G(tmpid).value;
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
        if (datas.id!= ""){
			$("#"+tmpname).html(datas.name.substr(0));
			$("input[name="+tmpid+"]").val(datas.id.substr(0));
			tmpindex.checked = true;
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = tmpid.substr(8);
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}
function onShowBrowser4opLevel(url,index,tmpindex){
	tmpid = "level_"+index;
	tmpname = "templevel_"+index;
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
	    if (datas.id!= ""){
			$("#"+tmpname).html(datas.name);
			$("input[name="+tmpid+"]").val(datas.id);
			tmpindex.checked = true
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = index;
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}


function onChangetypeByUrger(objval){
	if (objval==1){
		$("#odiv_urger_1").css("display","");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==2 ){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==3) {
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==4 ){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if(objval==5){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==6){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==7){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==8){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","");
	}
}
function onShowBrowserByUrger(url,index,tmpindex,formname){
	tmpid = "wfid_"+index;
	tmpname = "wfname_"+index;
	url=url+"?selectedids="+$GetEle(tmpid).value
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
	    if (datas.id!= ""){
			$("#"+tmpname).html(datas.name);
			$("input[name="+tmpid+"]").val(datas.id);
			tmpindex.checked = true
	        tmpid = $(tmpindex).attr("id");
			formname.selectindex.value = index;
			formname.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}
function onShowBrowserByUrgerM(url,index,tmpindex,formname){
	tmpid = "wfid_"+index;
	tmpname = "wfname_"+index
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
	    if (datas.id!= ""){
			$G(tmpname).innerHTML = datas.name.substr(1);
			$G(tmpid).value = datas.id.substr(1);
			tmpindex.checked = true
	        tmpid = tmpindex.id;
			formname.selectindex.value = index;
			formname.selectvalue.value = tmpindex.value;
		}else{
			$G(tmpname).innerHTML = "";
			$G(tmpid).value = "";
		}
	}
}
function onShowBrowsersByWFU(wfid,formid,isbill){
	src=$("#wffromsrc").val();
	url = "BrowserMain.jsp?url=OperatorCondition.jsp?fromsrc="+src+"&formid="+formid+"&isbill="+isbill
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
        if(datas.id!=""){
			$("input[name=wfconditionss]").val(datas.id);
			$("#wfconditions").html(datas.name);
			$("input[name=wfconditioncn]").val(datas.name);
			$("input[name=wffromsrc]").val("2");
        }else{
        	$("input[name=wfconditionss]").val("");
			$("#wfconditions").html("");
			$("input[name=wfconditioncn]").val("");
        }
	}
}
function onShowWorkFlowNeededValid(inputname, spanname){
	url=encode("/workflow/workflow/WorkflowBrowser.jsp?isValid=1")	
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;")
	if(datas){
		if(datas.id!=""){
			$("#"+spanname).html(datas.name);
			$("input[name="+inputname+"]").val(datas.id);
		}else {
			$("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			$("input[name="+inputname+"]").val("");
		}
		
	}
}
function onShowTriggerField(inputname,spanname,fieldtype,rowindex){
	inputname = $G(inputname);
	spanname = $G(spanname);
	fieldtype = $G(fieldtype);
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};

	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/fieldBrowser.jsp?wfid=<%=wfid%>",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data){
		if(data.id!=""){
			temprows = $G("table_"+rowindex).rows.length
			for(var s=0;s<=temprows-1;s++){
				jQuery($G("tabletype"+rowindex+s)).find('option') .remove()
				temprows3 = $G("parameterTable"+rowindex+s).rows.length
				for(var g=1;g<=temprows3-1;g++){
					 jQuery($G("parawfField"+rowindex+s+g)).find('option') .remove()
				}
				temprows5 = $G("evaluateTable"+rowindex+s).rows.length
				for(var g1=0;g1<=temprows5-1;g1++){
					jQuery($GetEle("evaluatewfField"+rowindex+s+g1)).find('option') .remove()
				}
			}
			inputname.value = data.id;
			
			spanname.innerHTML = data.name;
			
			fieldtype.value = data.fieldtype ? data.fieldtype : "";
			options = data.options ? data.options : "";
			options = options.replace(/,/g, "");
			for(var m=0;m<=temprows-1;m++){
				var ttt=$G("tabletype"+rowindex+m)
				if(data.fieldtype==0){
					jQuery($G("tabletype"+rowindex+m)).append("<option value='0'><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>");
				}else{
					jQuery($G("tabletype"+rowindex+m)).append("<option value='1'><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option>");
				}
				temprows7 = jQuery("#parameterTable"+rowindex+m).find("tr").length
				for(var n=1;n<temprows7;n++){
					//$('div.second').replaceWith('<h2>New heading</h2>');
					jQuery($G("parawfField"+rowindex+m+n)).replaceWith("<select id='parawfField"+rowindex+m+n+"' name='parawfField"+rowindex+m+n+"'>"+options+"</select>");
				}
				temprows8 = $G("evaluateTable"+rowindex+m).rows.length
				for(var n=1;n<temprows8;n++){
					//$('div.second').replaceWith('<h2>New heading</h2>');
					jQuery($G("evaluatewfField"+rowindex+m+n)).replaceWith("<select id='evaluatewfField"+rowindex+m+n+"' name='evaluatewfField"+rowindex+m+n+"'>"+options+"</select>");
				}				
			}
			
		}else{
			inputname.value = ""
			spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			fieldtype.value = ""
		}
	}
	
}


function onShowTable(inputname,spanname,hiddenname){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};

	opts.top=iTop;
	opts.left=iLeft;
	data = showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/triggerTableBrowser.jsp?wfid=<%=wfid%>",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data) {
		if(data.id!=""){
			inputname.value = data.id
			spanname.innerHTML = data.name
			hiddenname.value = data.other1
		}else{
			inputname.value = ""
			spanname.innerHTML = ""
			hiddenname.value = ""
		}
	}
}

function showParaTableFiled(obj,firstindex,secindex,rowindex){
	var tablenames="";
	rows = jQuery(obj).find("tr").length
	for (var s=1;s<=rows;s++){
		tablename = "tablename"+firstindex+secindex+s
		formid = "formid"+firstindex+secindex+s
		//alert(tablename+"&&&"+formid)
		tablenames = tablenames + $GetEle(formid).value + ":"+ $GetEle(tablename).value + ","
	}
	datasourcename="datasource"+firstindex+secindex;
	urls="/workflow/workflow/triggerTableFieldsBrowser.jsp?datasourceid="+$GetEle(datasourcename).value+"&tablenames="+tablenames
	urls="/systeminfo/BrowserMain.jsp?url="+encode(urls)
	var opts={
		_dwidth:'550px',
		_dheight:'550px',
		_url:'about:blank',
		_scroll:"no",
		_dialogArguments:"",
		
		value:""
	};
	
	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog(urls,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data){ 
		if (data.id!=""){
			$GetEle("parafieldname"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(data, 0);
			$GetEle("parafieldnamespan"+firstindex+secindex+rowindex).innerHTML = wuiUtil.getJsonValueByIndex(data, 1);
			$GetEle("parafieldtablename"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(data, 2);
		}else{
			$GetEle("parafieldname"+firstindex+secindex+rowindex).value = ""
			$GetEle("parafieldnamespan"+firstindex+secindex+rowindex).innerHTML = ""
			$GetEle("parafieldtablename"+firstindex+secindex+rowindex).value = ""
		}
	}
}
function showEvaluateTableFiled(obj,firstindex,secindex,rowindex){
	var tablenames = "";
	rows = jQuery(obj).find("tr").length
	for (var s=1;s<=rows;s++){
		tablename = "tablename"+firstindex+secindex+s
		formid = "formid"+firstindex+secindex+s
		//alert(tablename+"&&&"+formid)
		tablenames = tablenames + $GetEle(formid).value + ":"+ $GetEle(tablename).value + ","
	}
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
		
		opts.top=iTop;
		opts.left=iLeft;
		
	datasourcename="datasource"+firstindex+secindex
	urls="/workflow/workflow/triggerTableFieldsBrowser.jsp?datasourceid="+$GetEle(datasourcename).value+"&tablenames="+tablenames
	urls="/systeminfo/BrowserMain.jsp?url="+encode(urls)
	data = window.showModalDialog(urls,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
		if (data.id!=""){
			$GetEle("evaluatefieldname"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(data, 0);
			$GetEle("evaluatefieldnamespan"+firstindex+secindex+rowindex).innerHTML = wuiUtil.getJsonValueByIndex(data, 1);
			$GetEle("evaluatefieldtablename"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(data, 2);
		}else{
			$GetEle("evaluatefieldname"+firstindex+secindex+rowindex).value = ""
			$GetEle("evaluatefieldnamespan"+firstindex+secindex+rowindex).innerHTML = ""
			$GetEle("evaluatefieldtablename"+firstindex+secindex+rowindex).value = ""
		}
	}
}
function changeSubwfCreatorType(subwfCreatorType){
	$GetEle(subwfCreatorType).checked = true;
}
function onShowWfDocOwner(spanname,inputename,needinput){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;")
	if (datas) {
		if(datas.id!=""){
			$("#"+spanname).html("<a href='javaScript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</a>");
			$("input[name="+inputename+"]").val(datas.id);
		}else{
			if(needinput == "1") {
				$("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			}else{
				$("#"+spanname).empty();
			}
			$("input[name="+inputename+"]").val("");
		}
	}
}

function onShowWorkFlowNeededValidSingle(inputname, spanname,isMand){
	url=encode("/workflow/workflow/WorkflowBrowser.jsp?isValid=1")	
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;")
	if(datas){
		if(datas.id!=""){
			jQuery("#"+spanname).html(datas.name);
			jQuery("#"+inputname).val(datas.id);
		}else{ 
			jQuery("#"+inputname).val("");
		    if(isMand == 1){
		    	jQuery("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		    }else{
		    	jQuery("#"+spanname).html("");
		    }
		} 
	}
}

function onShowWorkflow(inputname,spanname){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=1");
	//datas = json2Array(datas);
	if(datas){
	    if(datas.id!="") {
			$G(spanname).innerHTML = datas.name;
			$G(inputname).value = datas.id;
	        $G("addwf0div").style.display="none";
	        $G("addwf1div").style.display="none";
	    }else{
	    	$G(spanname).innerHTML = "";
	    	$G(inputname).value="";
	    	$G("addwf0div").style.display="";
	    	$G("addwf1div").style.display="";
	   }
	}
}
//add by fanggsh 20060705 for TD 4531 end
function lavaShowMultiField(spanname,hiddenidname,nodeid,fieldid) {
	var url=encode("/workflow/field/MultiWorkflowFieldBrowser.jsp?wfid=<%=wfid%>&nodeid=" + nodeid + "&selfieldid=" + fieldid + "&fieldids=" + $G(hiddenidname).value);
	var data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
	var issame = false

	if (data){
        if (data.id!="" && data.id != "0"){
            
            $G(spanname).innerHTML =data.name.substr(1);
            $G(hiddenidname).value=data.id.substr(1);
        }else{
            $G(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
            $G(hiddenidname).value=""
        }
	}
}


</script>


<script type="text/javascript">


function onChangetype(objval) {
	if ( objval==1 ) {
		$G("odiv_1").style.display="";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
	    //$G("signordertrline").style.display="none";
		//$G("signordertr").style.display="none";
}
if ( objval==2 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
	    //$G("signordertrline").style.display="";
		//$G("signordertr").style.display="";
}
if ( objval==3 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
	    //$G("signordertrline").style.display="none";
		//$G("signordertr").style.display="none";
		}
if ( objval==4 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
	    //$G("signordertrline").style.display="none";
		//$G("signordertr").style.display="none";
		}
if ( objval==5 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
	    //$G("signordertrline").style.display="none";
		//$G("signordertr").style.display="none";
		}
if ( objval==6 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
	    //$G("signordertrline").style.display="none";
		//$G("signordertr").style.display="none";
		}
if ( objval==7 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="none";
	    //$G("signordertrline").style.display="";
		//$G("signordertr").style.display="";
		}
if ( objval==8 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="";
        $G("odiv_9").style.display="none";
	    //$G("signordertrline").style.display="none";
		//$G("signordertr").style.display="none";
}
	if (objval == 9 ) {
		$G("odiv_1").style.display="none";
		$G("odiv_2").style.display="none";
		$G("odiv_3").style.display="none";
		$G("odiv_4").style.display="none";
		$G("odiv_5").style.display="none";
		$G("odiv_6").style.display="none";
		$G("odiv_7").style.display="none";
		$G("odiv_8").style.display="none";
        $G("odiv_9").style.display="";
		//$G("signordertrline").style.display="";
		//$G("signordertr").style.display="";
	}

}

function onShowSubcompany(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1&selectedids="+weaver.subcompanyid.value);
	//datas = json2Array(datas);
	issame = false;
	if (datas){
	if(datas.id!="0"&&datas.id!=""){
		if(datas.id == weaver.subcompanyid.value){
			issame = true;
		}
		$(subcompanyspan).html(datas.name); //ypc 2012-09-24
		$GetEle("subcompanyid").value=datas.id; //ypc 2012-09-24
	}
	else{
		$GetEle("subcompanyspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>" ;//ypc 2012-09-24
		$GetEle("subcompanyid").value = ""; //ypc 2012-09-24
	}
	}
}

function adfonShowSubcompany(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&selectedids="+addformtabspecial.subcompanyid.value);
	issame = false;
	if (data){
		if (data.id!=0){
			if (data.id == addformtabspecial.subcompanyid.value){
				issame = true;
			}
			subcompanyspan1.innerHTML = data.name;
			addformtabspecial.subcompanyid.value=data.id;
		}else{
			subcompanyspan1.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			addformtabspecial.subcompanyid.value="";
		}
	}
}


function onShowSubcompanySingle(inputName, spanName, isMand) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All+selectedids=" + inputName.value)

    if (data) {
        if (data.id != 0) {
            inputName.value = data.id;
            spanName.innerHTML = data.name;
        } else {
            inputName.value = "";
            if (isMand == 1) {
                spanName.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            } else {
                spanName.innerHTML = "";
            }
        }
    }
}

function onShowDepartmentSingle(inputName, spanName, isMand) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?rightStr=WorkflowManage:All+selectedids=" + inputName.value)

     if (data) {
        if (data.id != 0) {
            inputName.value = data.id;
            spanName.innerHTML = data.name;
        } else {
            inputName.value = "";
            if (isMand == 1) {
                spanName.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            } else {
                spanName.innerHTML = "";
            }
        }
    }
}

function onShowReceiveUnitSingle(inputName, spanName, isMand) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp")

    if (data) {
        if (data.id != "") {
            inputName.value = data.id;
            spanName.innerHTML = data.name;
        } else {
            inputName.value = "";
            if (isMand == 1) {
                spanName.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            } else {
                spanName.innerHTML = "";
            }
        }
    }
}
function showlanguage() {
    data = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp");
    if (data) {
        if (data.id != 0) {
            languagespan.innerHTML = data.name;
            document.fieldlabelfrm.languageList.value = data.id;
        } else {
            languagespan.innerHTML = "";
            document.fieldlabelfrm.languageList.value = "";
        }
    }
}
function gettheDate(inputname, spanname) {
    returndate = window.showModalDialog("/systeminfo/Calendar.jsp",null, "dialogHeight:320px;dialogwidth:275px");
    spanname.innerHTML = returndate;
    inputname.value = returndate;
}

function onShowResourceID(inputname, spanname) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
    if (data) {
        if (data.id != "") {
            spanname.innerHTML = "<A href='HrmResource.jsp?id=" + data.id + "'>" + data.name + "</A>";
            inputname.value = data.id;
        } else {
            spanname.innerHTML = "";
            inputname.value = "";
        }
    }
}


function changelevel(tmpindex) {
    tmpindex.checked = true;
    tmpid = tmpindex.id;
    //document.addopform.selectindex.value = Mid(tmpid, 9, len(tmpid));
    document.addopform.selectindex.value = tmpid.substring(8);// Mid(tmpid, 9, len(tmpid));
    document.addopform.selectvalue.value = tmpindex.value;
    if($GetEle("tmptype_42").checked){
    $GetEle("Tab_Coadjutant").style.display='';
    }else {
    $GetEle("Tab_Coadjutant").style.display='none';
    }
    //alert("selindex:"+Mid(tmpid,9,len(tmpid)))+"   selectvalue:"+tmpindex.value;
}

function onShowBrowserByUrgerLevel(url, index, tmpindex, formname) {
    tmpid = "wflevel_" + index;
    tmpname = "tempwflevel_" + index;
    data = window.showModalDialog(url);
    if (data) {
        if (data.id != "") {
            $GetEle(tmpname).innerHTML = data.name;
            $GetEle(tmpid).value = data.id;
            tmpindex.checked = true;
            tmpid = tmpindex.id;
            //formname.selectindex.value = Mid(tmpid, 9, len(tmpid));
            formname.selectindex.value = tmpid.substring(8);
            formname.selectvalue.value = tmpindex.value;
        } else {
            $GetEle(tmpname).innerHTML = "";
            $GetEle(tmpid).value = "0";
        }
    }
}

function changelevelByUrger(tmpindex) {
    tmpindex.checked = true;
    tmpid = tmpindex.id;
    //wfurgerform.selectindex.value = Mid(tmpid, 9, len(tmpid));
    wfurgerform.selectindex.value = tmpid.substring(8);
    wfurgerform.selectvalue.value = tmpindex.value;
}

function onShowMultiSubcompanyBrowserByDec(inputename, showname, ismand) {
    tmpids = $GetEle(inputename).value;
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiSubcompanyBrowserByDec.jsp?selectedids=" + $GetEle(inputename).value + "+selectedDepartmentIds=" + tmpids)

    if (data) {
        if (data.id != "") {
           
            resourceids = data.id;
		    resourcename = data.name;
		    var sHtml = "";
		    resourceids = resourceids.substring(1);
		    resourcename = resourcename.substring(1);
		    ids = resourceids.split(",");
		    names =resourcename.split(",");
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+names[i]+"</a>&nbsp";
	        	}
	        }
            $GetEle(showname).innerHTML = sHtml;
            $GetEle(inputename).value = resourceids;
        } else {
            if (ismand == 1) {
                $GetEle(showname).innerHTML = "<img src='/images/BacoError.gif' align=absMiddle></img>";
            } else {
                $GetEle(showname).innerHTML = "";
            };
            $GetEle(inputename).value = "";
        }
    }
}

function onShowFormSelectForCopy(isbill, inputName, spanName, isMand) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfFormBrowser.jsp?isbill=" + isbill)

    if (data) {
        if (data.id != "") {
            inputName.value = data.id;
            spanName.innerHTML = data.name;
        } else {
            inputName.value = "";
            if (isMand == 1) {
                spanName.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            } else {
                spanName.innerHTML = "";
            }
        }
    }
}

function onShowCoadjutantBrowser() {
   
    url = encode("/workflow/workflow/showCoadjutantOperate.jsp?iscoadjutant=" + $GetEle("IsCoadjutant").value + "+signtype=" + $GetEle("signtype").value + "+issyscoadjutant=" + $GetEle("issyscoadjutant").value + "+coadjutants=" + $GetEle("coadjutants").value + "+coadjutantnames=" + $GetEle("coadjutantnames").value + "+issubmitdesc=" + $GetEle("issubmitdesc").value + "+ispending=" + $GetEle("ispending").value + "+isforward=" + $GetEle("isforward").value + "+ismodify=" + $GetEle("ismodify").value);
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
    if (data) {
        if (wuiUtil.getJsonValueByIndex(data, 0) != "") {
            
            $GetEle("IsCoadjutant").value = wuiUtil.getJsonValueByIndex(data, 0);
            $GetEle("signtype").value = wuiUtil.getJsonValueByIndex(data, 1);
            $GetEle("issyscoadjutant").value = wuiUtil.getJsonValueByIndex(data, 2);
            $GetEle("coadjutants").value = wuiUtil.getJsonValueByIndex(data, 3);
            $GetEle("coadjutantnames").value = wuiUtil.getJsonValueByIndex(data, 4);
            $GetEle("issubmitdesc").value = wuiUtil.getJsonValueByIndex(data, 5);
            $GetEle("ispending").value = wuiUtil.getJsonValueByIndex(data, 6);
            $GetEle("isforward").value = wuiUtil.getJsonValueByIndex(data, 7);
            $GetEle("ismodify").value = wuiUtil.getJsonValueByIndex(data, 8);
            $GetEle("Coadjutantconditions").value = wuiUtil.getJsonValueByIndex(data, 9);
            $GetEle("Coadjutantconditionspan").innerHTML = wuiUtil.getJsonValueByIndex(data,9);
        } else {
            $GetEle("IsCoadjutant").value = "";
            $GetEle("signtype").value = "";
            $GetEle("issyscoadjutant").value = "";
            $GetEle("coadjutants").value = "";
            $GetEle("coadjutantnames").value = "";
            $GetEle("issubmitdesc").value = "";
            $GetEle("ispending").value = "";
            $GetEle("isforward").value = "";
            $GetEle("ismodify").value = "";
            $GetEle("Coadjutantconditions").value = "";
            $GetEle("Coadjutantconditionspan").innerHTML = "";
        }
    }
}
</script>

 

<script language="javascript">


function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if (result) {
        if (result.tag>0)  {
        	
           $G(spanName).innerHTML = result.path;
           $G("pathcategory").value = result.path;
           $G("maincategory").value=result.mainid;
           $G("subcategory").value=result.subid;
           $G("seccategory").value=result.id;
        }else{
           $G(spanName).innerHTML = "";
           $G("pathcategory").value="";
           $G("maincategory").value="";
           $G("subcategory").value="";
           $G("seccategory").value="";
        }
    }
}

function onShowWfCatalog(spanName) {
    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if (datas) {
        if (datas.tag>0)  {
            $(spanName).html(datas.path);
            $("input[name=wfdocpath]").val(datas.mainid+","+datas.subid+","+datas.id);
        }
        else{
            spanName.innerHTML="";
            $GetEle("wfdocpath").value="";
            }
    }
}

function onShowDocCatalog(spanName) {
    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if (datas) {
        if (datas.tag > 0)  {
            $(spanName).html(datas.path);
            $GetEle("newdocpath").value=datas.mainid+","+datas.subid+","+datas.id;
        }
        else{
        	$(spanName).html("");
            $GetEle("newdocpath").value="";
            }
    }
}

function ShowAnnexUpload(obj,tr1name,tr2name,tr3name,tr4name,tabobj){
    if(obj.checked){
        tr1name.style.display = '';
        tr2name.style.display = '';
        tr3name.style.display = '';
        tr4name.style.display = '';
    }else{
        tr1name.style.display = 'none';
        tr2name.style.display = 'none';
        tr3name.style.display = 'none';
        tr4name.style.display = 'none';
    }
    tabobj.checked=obj.checked;
}
function ShowORHidden(obj,tr1name,tr2name,tabobj){
    if(obj.checked){
        tr1name.style.display = '';
        tr2name.style.display = '';
    }else{
        tr1name.style.display = 'none';
        tr2name.style.display = 'none';
    }
    tabobj.checked=obj.checked;
}

function json2Array(josinobj) {
	if (josinobj == undefined || josinobj == null) {
		return null;
	}
	var ary = new Array();
	var _index = 0;
	try {
		for(var key in josinobj){
			ary[_index++] = josinobj[key];
		}
	} catch (e) {}
	return ary;
}

function onShowAnnexCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    result = json2Array(result);
    if (result != null) {
        if (result[0] > 0)  {
            spanName.innerHTML=result[2];
            $GetEle("annexmaincategory").value=result[3];
            $GetEle("annexsubcategory").value=result[4];
            $GetEle("annexseccategory").value=result[1];
        }else{ //<!--added xwj for td2048 on 2005-6-1 begin -->
            spanName.innerHTML="";
            $GetEle("annexmaincategory").value="";
            $GetEle("annexsubcategory").value="";
            $GetEle("annexseccategory").value="";
            }
        //<!--added xwj for td2048 on 2005-6-1 end -->
    }
}

function onchangeIsCompellentMark(){
	var cIsCompellentMark = $GetEle("isCompellentMark").checked;
	if(cIsCompellentMark == true){
		$GetEle("isCancelCheck").checked = true;
		$GetEle("isCancelCheck").disabled = true;
		$GetEle("isCancelCheckInput").value = "1";
	}else{
		$GetEle("isCancelCheck").disabled = false;
	}
}

function onchangeIsCancelCheck(){
	var cIsCancelCheck = $GetEle("isCancelCheck").checked;
	if(cIsCancelCheck == true){
		$GetEle("isCancelCheckInput").value = "1";
	}else{
		$GetEle("isCancelCheckInput").value = "0";
	}
}

function onShowCatalogOfDocument(spanName) 
{
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if (result != null) 
    {
        if (result.tag =="1")  
        {
            $("#"+spanName).html(result.path);
            $("input[name=pathCategoryDocument]").val(result.path);
            $("input[name=mainCategoryDocument]").val(result.mainid);
            $("input[name=subCategoryDocument]").val(result.subid);
            $("input[name=secCategoryDocument]").val(result.id);
        }
        else
        {
            $("#"+spanName).empty();
            $("input[name=pathCategoryDocument]").val("");
            $("input[name=mainCategoryDocument]").val("");
            $("input[name=subCategoryDocument]").val("");
            $("input[name=secCategoryDocument]").val("");
        }
    }
}

function onShowPrintNodes(inputName,spanName,workflowId){
	printNodes=inputName.value;
    tempUrl=escape("/workflow/workflow/WorkflowNodeBrowserMulti.jsp?printNodes="+printNodes+"&workflowId="+workflowId);
    var result =window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+tempUrl,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");

    if (result != null){
		if (result.id!=""){  
		    inputName.value=result.id;
		    spanName.innerHTML=result.name;
		}else{
		    inputName.value="0";
		    spanName.innerHTML="";
		}
    }
}

rowindex = -1;
delids = "";
function addRow(tableId)
{
	//ypc 2012-09-03 声明oTable
	var oTable = null;
	
	oTable = $G(tableId);
	if(rowindex == -1)
    rowindex=$GetEle("noderowsum").innerHTML;
    ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= "";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='node_"+rowindex+"_type'><option value='-1'>********<%=SystemEnv.getHtmlLabelName(15597, user.getLanguage())%>***********</option><option value='0'><strong><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%></strong><option value='1'><strong><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%></strong><option value='2'><strong><%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%></strong><option value='3'><strong><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%></strong></select>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='input' class='InputStyle'name='node_"+rowindex+"_name' onblur='checkinput(\"node_"+rowindex+"_name\",\"node_"+rowindex+"_namespan\");checkSameName("+rowindex+",this.value)' maxlength=30><span id='node_"+rowindex+"_namespan'><img src='/images/BacoError.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
            case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='node_"+rowindex+"_attribute' onchange=changeattri(this)><option value='0'><%=SystemEnv.getHtmlLabelName(154, user.getLanguage())%></option><option value='1'><strong><%=SystemEnv.getHtmlLabelName(21394, user.getLanguage())%></strong><option value='2'><strong><%=SystemEnv.getHtmlLabelName(21395, user.getLanguage())%></strong><option value='3'><strong><%=SystemEnv.getHtmlLabelName(21396, user.getLanguage())%></strong><option value='4'><strong><%=SystemEnv.getHtmlLabelName(21397, user.getLanguage())%></strong></select><input type='input' class='InputStyle' size='5' maxlength=2 name='node_"+rowindex+"_passnum' style='display:none' onKeyPress=ItemCount_KeyPress() onBlur=checkcount1(this)>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
        }
	}
	$G("needcheck").value = $G("needcheck").value+",node_"+rowindex+"_name";
	rowindex = rowindex*1 +1;

}

function checkSameName(thisrowindex,thisvalue){
    try{
        if(rowindex == -1){
            rowindex=$G("noderowsum").innerHTML;
        }
        if(rowindex>0){
            for(i=0;i<rowindex;i++){
                if(thisrowindex!=i){
                    if(thisvalue!=""&&thisvalue==$G("node_"+i+"_name").value){
                        alert("<%=SystemEnv.getHtmlLabelName(25217, user.getLanguage())%>！");
                        $G("node_"+thisrowindex+"_name").value = "";
                        $G("node_"+thisrowindex+"_namespan").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
                    }
                }
            }
        }
    }catch(e){}
}

function selectall(){
	
    var needcheck = $G("needcheck").value;
    if(check_form(nodeform,needcheck)){
    if(rowindex == -1){
		rowindex=$G("noderowsum").innerHTML;
	}
    try{
    	var createnodes = 0;
    	var processednodes = 0;
    	var processpointstart = 0;
    	var processpointmiddle = 0;
    	var processpointend3 = 0;
    	var processpointend4 = 0;
    	if(rowindex>0){
	    	for(i=0;i<rowindex;i++){
				try{
					if($GetEle("node_"+i+"_name"))
					{
						var nodename = $GetEle("node_"+i+"_name").value;
						
						if(nodename.indexOf("<")>-1||nodename.indexOf(">")>-1||nodename.indexOf("'")>-1||nodename.indexOf(",")>-1||nodename.indexOf("\"")>-1)
						{
							alert("<%=SystemEnv.getHtmlLabelName(25775, user.getLanguage())%>");
							$GetEle("node_"+i+"_name").focus();
							return;
						}
					}
					
					if($GetEle("node_"+i+"_type").value==-1){
						alert("<%=SystemEnv.getHtmlLabelName(15597, user.getLanguage())%>");
						return;
					}else if($GetEle("node_"+i+"_type").value==0){
					    createnodes = createnodes+1;
					}else if($GetEle("node_"+i+"_type").value==3){
					    processednodes = processednodes+1;
					}
				}catch(e){ }
				try{
					if($GetEle("node_"+i+"_attribute").value==1){
						processpointstart++;
					}
					if($GetEle("node_"+i+"_attribute").value==2){
						processpointmiddle++;
					}
					if($GetEle("node_"+i+"_attribute").value==3){
						processpointend3++;
					}
					if($GetEle("node_"+i+"_attribute").value==4){
						processpointend4++;
					}
				}catch(e){}
	    	}
	    }
	    if(processpointstart>1){
	    	alert("<%=SystemEnv.getHtmlLabelName(25489, user.getLanguage())%>");
	    	return;
	    }
	    //必须有一个分叉起始点
	    if(processpointstart==0){
	    	if(processpointmiddle !=0 || processpointend3 !=0 || processpointend4 !=0){
		    	alert("<%=SystemEnv.getHtmlLabelName(25492, user.getLanguage())%>");
		    	return;
	    	}
	    }
	    //如果有分叉起始点，有且仅有一个通过分支数合并或指定通过分支合并。
	    if(processpointstart==1){
	    	if((processpointend3+processpointend4)!=1){
		    	alert("<%=SystemEnv.getHtmlLabelName(25493, user.getLanguage())%>");
		    	return;
	    	}
	    }
	    
	    if(createnodes!=1){
	       alert("<%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15595, user.getLanguage())%>");
	       return;
	    }
	    if(processednodes<1){
	       alert("<%=SystemEnv.getHtmlLabelName(25218, user.getLanguage())%>");
	       return;
	    }
  	}catch(e){alert('错误' + e.message + '发生在' +   e.lineNumber + '行');}
    document.nodeform.nodesnum.value=rowindex;
	document.nodeform.delids.value=delids;
    tab3oldurl="";
    tab4oldurl="";
    tab6oldurl="";
    tab000001OldURL="";
    doPost(document.nodeform,tab2);
    }
}

<%--xwj taiping wf_log  control  2005-07-25  B E G I N --%>
function onShowBrowser1(wfid,nodeid){
  url = "BrowserMain.jsp?url=wfNodeBrownser.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	con = window.showModalDialog(url,'','dialogHeight:400px;dialogwidth:400px');
    if(con != undefined){
        if(con=="1"){// "1" 代表 "全选" 或 "选择部分"
            $GetEle("por"+nodeid+"_conspan").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            $GetEle("por"+nodeid+"_conspan").innerHTML="";
        }
    }

}
<%--xwj taiping wf_log  control  2005-07-25  E N D --%>

function onShowBrowser(row){
//	alert(row);
	url = "BrowserMain.jsp?url=showaddinoperate.jsp?wfid=<%=wfid%>&nodeid="+row;
//	alert(url);
	con = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
//  alert(con==undefined);
    if(con != undefined){
        if(con=="1"){
            $GetEle("ischeck"+row+"span").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            $GetEle("ischeck"+row+"span").innerHTML="";
        }
    }

}
<%--xwj for td3130 20051122 begin--%>
function onShowPreBrowser(row){
	url = "BrowserMain.jsp?url=showpreaddinoperate.jsp?wfid=<%=wfid%>&nodeid="+row;
	con = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if(con != undefined){
        if(con=="1"){
            $GetEle("ischeckpre"+row+"span").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            $GetEle("ischeckpre"+row+"span").innerHTML="";
        }
    }

}
<%--xwj for td3130 20051122 end--%>

function onShowNodeAttrBrowser(nodeid){
	url = "BrowserMain.jsp?url=showNodeAttrOperate.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	con = window.showModalDialog(url,'','dialogHeight:500px;dialogwidth:600px');
    if(con != undefined){
        if(con=="1"){
            $GetEle("nodeattr"+nodeid+"Span").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            $GetEle("nodeattr"+nodeid+"Span").innerHTML="";
        }
    }
}

function onShowButtonNameBrowser(nodeid){
	url = "BrowserMain.jsp?url=showButtonNameOperate.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	con = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if(con != undefined){
        if(con=="1"){
            $GetEle("buttonName"+nodeid+"Span").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            $GetEle("buttonName"+nodeid+"Span").innerHTML="";
        }
    }
}

var rowColor="" ;
theselectradio = null ;

function setSelIndex(selindex, selectvalue) {
    //alert("selindex:"+selindex+"   selectvalue:"+selectvalue);
    document.addopform.selectindex.value = selindex ;
    document.addopform.selectvalue.value = selectvalue ;
    if($GetEle("tmptype_42").checked){
    $GetEle("Tab_Coadjutant").style.display='';
    }else {
    $GetEle("Tab_Coadjutant").style.display='none';
    }
}
function setSelIndexByUrger(selindex, selectvalue) {
    //alert("selindex:"+selindex+"   selectvalue:"+selectvalue);
    document.wfurgerform.selectindex.value = selindex ;
    document.wfurgerform.selectvalue.value = selectvalue ;
}


function addRow4op(){
    var rowindex4op = 0;
    var rows=document.getElementsByName('check_node');
    var len = document.addopform.elements.length;
    var rowsum1 = 0;
    var obj;
    for(i=0; i < len;i++) {
		if (document.addopform.elements[i].name=='check_node'){
			rowsum1 += 1;
            obj=document.addopform.elements[i];
            }
    }

    if(rowsum1>0) {
    	rowindex4op=parseInt(obj.getAttribute("rowIndex"))+1;
    }

    for(i=0;i<56;i++){
    	var belongtype ="0";
        if(document.addopform.selectindex.value == i){
			switch (i) {
            case 0:
			case 1:
            case 2:
			case 7:
			case 8:
			case 9:
			case 11:
			case 12:
			case 14:
			case 15:
			case 16:
			case 18:
			case 19:
			case 27:
			case 28:
			case 29:
			case 30:
            case 38:
            case 45:
            case 46:
			case 50:
				
				//如果安全级别最大值不为空且最小值为空, 则最小值默认为0 。
				if($G("level_"+i).value ==''  &&  $G("level2_"+i).value != '')     $G("level_"+i).value = '0';
				if($GetEle("id_"+i).value ==0 || $GetEle("level_"+i).value =="" || ($GetEle("level_"+i).value =="0"&&i==50)){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 3:
			case 5:
			case 49:
			case 6:
			case 10:
			case 13:
			case 17:
			case 20:
			case 21:
			case 31:
			case 40:
			case 41:
			case 42:
			case 43:
			case 44:
			case 47:
			case 48:
			case 51:
			
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;

			case 52:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 53:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 54:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 55:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 4:   //所有人
            case 24:  //创建人下属
			case 25:  //创建人本分部
			case 26:  //创建人本部门 
			case 39:  //创建人上级部门
			case 32:  //创建客户

				//如果安全级别最大值不为空且最小值为空, 则最小值默认为0 。
				if($G("level_"+i).value ==''  &&  $G("level2_"+i).value != '')    $G("level_"+i).value = '0';
				if($G("level_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			}
            var hrmids,hrmnames; 
			var k=1;
			var subcompanyids,subcompanynames; 
			var belongtypeStr = "";
			var singerorder_flag = 0;
			try{
				singerorder_flag = parseInt(document.getElementById("singerorder_flag").value);
			}catch(e){
				singerorder_flag = 0;
			}
			var singerorder_type = document.getElementById("singerorder_type").value;
      if (i==0){//多分部
			var stmps = $G("id_"+i).value;
			var sHtmls = $G("name_"+i).innerHTML;
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(belongtype=="1"){
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag>0 && singerorder_type!="30"){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = ""+k;
                document.getElementById("singerorder_type").value = "30";
			}else{
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
            }
			}
			var departmentids,departmentnames; 
      if (i==1){//多部门
			var stmps = $G("id_"+i).value;
			var sHtmls = $G("name_"+i).innerHTML;
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(belongtype=="1"){
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag>0 && singerorder_type!="1"){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = ""+k;
                document.getElementById("singerorder_type").value = "1";
			}else{
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
            }
			}
		if(i==2){//角色
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(belongtype=="1"){
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag > 0){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = "1";
                document.getElementById("singerorder_type").value = "2";
			}
		}
            if (i==3)  //多人力资源
			{
			var stmps = $G("id_"+i).value;
			hrmids=stmps.split(",");
			var sHtmls = $G("name_"+i).innerHTML;
			hrmnames=sHtmls.split(",");
			k=hrmids.length;
			}
			for (m=0;m<k;m++)
			{ rowColor = getRowBg();
//			ncol = oTable4op.cols;
			ncol = oTable4op.rows[0].cells.length
			oRow = oTable4op.insertRow(-1);
			for(j=0; j<ncol; j++) {
				oCell = oRow.insertCell(-1);
				oCell.style.height=24;
				oCell.style.background= rowColor;
				switch(j) {
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='check_node' value='0' rowindex="+rowindex4op+" belongtype="+belongtype+">";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml="";

						if(i==0)
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>"+belongtypeStr;
						if(i== 1 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>"+belongtypeStr;
						if(i== 2 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>"+belongtypeStr;
						if(i== 3 )
							sHtml="<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>";
						if(i== 4 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>";
						if(i== 5 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%>";
						if(i== 6 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%>";
						if(i== 7 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%>";
						if(i== 8 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%>";
						if(i== 9 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%>";
						if(i== 10 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%>";
						if(i== 11 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%>";
						if(i== 12 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%>";
						if(i== 13 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%>";
						if(i== 14 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%>";
						if(i== 15 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%>";
						if(i== 16 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%>";
						if(i== 17 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%>";
						if(i== 18 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%>";
						if(i== 19 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%>";
						if(i== 20 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%>";
						if(i== 21 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%>";
						if(i== 22 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%>";
						if(i== 23 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>";
						if(i== 24 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%>";
						if(i== 25 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%>";
						if(i== 26 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%>";
						if(i== 27 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%>";
						if(i== 28 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%>";
						if(i== 29 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%>";
						if(i== 30 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%>";
						if(i== 31 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%>";
						if(i== 32 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%>";
						if(i== 38 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%>";
                        if(i== 39 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%>";
                        if(i== 40 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%>";
                        if(i== 41 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%>";
                        if(i== 42 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
                        if(i== 43 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
                        if(i== 44 )
							sHtml="<%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%>";
                        if(i== 45 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%>";
                        if(i== 46 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%>";
                        if(i== 47 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%>";
                        if(i== 48 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%>";
                        if(i== 49 )
							sHtml="<%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%>";
						if(i== 50 )
							sHtml="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>";
						if(i== 51 )
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
						if(i== 52 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%>";
						if(i== 53 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%>";
						if(i== 54 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%>";
						if(i== 55 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%>";
                        oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

                        var rowtypevalue = document.addopform.selectvalue.value ;
						
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='hidden' name='group_"+rowindex4op+"_type'  value='"+rowtypevalue+"'>";
						oDiv1.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv1);
						break;
				case 2:
					{
						var stmp="";
					if(i==0){
					  	stmp=""+subcompanyids[m];
					  }else if(i==1){
					  	stmp=""+departmentids[m];
					  }else{ 
						if (i==3)
					    {
						stmp=""+hrmids[m];
						}
					    else
					    {
						 stmp = $G("id_"+i).value;
					    }
            		}
						var oDiv = document.createElement("div");
						var sHtml = "";
						if((i>= 5 && i <= 21) || i == 27 || i == 31 || i == 30 || i==38  || i== 40 || i == 41|| i == 42|| i == 43|| i == 44|| i == 45|| i == 46|| i == 47|| i == 48|| i == 49|| i == 50|| i == 51|| i == 52 || i == 53 || i == 54 || i == 55){
							var srcList = $G("id_"+i);
							for (var count = srcList.options.length - 1; count >= 0; count--) {
								if(srcList.options[count].value==stmp)
									sHtml = srcList.options[count].text;
							}
						}
						else if(i== 4 || i== 22 || i== 23 || i==24 || i== 25 || i== 26  || i== 32 || i == 39){
							sHtml = stmp;
						}
						else
					      {
						    if(i==0){ sHtml=subcompanynames[m];}
						    else if(i==1){ sHtml=departmentnames[m];}
					    else{
							if (i==3)
							sHtml=hrmnames[m];
							else
							sHtml = $G("name_"+i).innerHTML;
							}
						  }
						  if (i==50)  sHtml =sHtml+"/"+$G("templevel_"+i).innerHTML;

						oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

						var oDiv2= document.createElement("div");
                       
						var stemp=stmp;
						
                        var sHtml1;
                        if(i==0 || i==1){
                        	sHtml1="<input type='hidden'  name='group_"+rowindex4op+"_subcompanyids' value='"+stemp+"'>";
                        	sHtml1 += "<input type='hidden'  name='group_"+rowindex4op+"_id' value='"+stemp+"'>";
                        }else{
							sHtml1="<input type='hidden'  name='group_"+rowindex4op+"_id' value='"+stemp+"'>";
                        }
						oDiv2.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv2);
						break;
					}
					case 3:
						var oDiv = document.createElement("div");
						var sval = "";
						var sval2 = "";
						var sHtml="";
					
						if(i == 0 || i == 1 || i == 4 || i == 7 || i == 8 || i == 9 || i == 11 || i == 12 || i== 14 || i == 15 || i == 16 || i == 18 || i == 19 || i == 24 || i == 25 || i == 26 || i == 27 || i == 28 || i == 29 || i == 30 || i == 32 || i == 38 || i == 39 || i == 45 || i == 46||i == 42||i == 51){
                            sval = $G("level_"+i).value;
                            sval2 = $G("level2_"+i).value;
							
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }

						}
						if (i==50){

                            sval = $G("level_"+i).value;
							sval2 = $G("level2_"+i).value;
							if(sval2=="1"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22689,user.getLanguage())%>";
							}else if(sval2=="2"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22690,user.getLanguage())%>";
							}else if(sval2=="3"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22667,user.getLanguage())%>";
							}else{
								sHtml = "<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
							}
						}
						if(i == 2 ){
							sval = $G("level_"+i).value;
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
							if(sval==3)
								sHtml="<%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%>";
						}
					
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);

						var oDiv3= document.createElement("div");
                        var sHtml1 = "<input type='hidden' size='32' name='group_"+rowindex4op+"_level'  value='"+sval+"'>";
                        if(sval2!=""){
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='"+sval2+"'>";
                        }else{
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='-1'>";
                        }
						
						oDiv3.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv3);
						break;

					case 4:
						var oDiv = document.createElement("div");
						var sval = "";
						var sHtml="";
					
						if(i == 5|| i == 42|| i == 43|| i == 49||i == 50||i == 40||i == 41||i == 31||i == 51||i == 52||i == 53||i == 54||i == 55 ||i == 31 ){
							if($G("signorder")){
								sval = document.all("signorder");
							}else{

								sval = document.all("signorder_"+i);
							}

							if(sval[0].checked){
                                sHtml="<%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>";
								sval = "0";
                            } else if(sval[1].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>";
								sval = "1";
							} else if(sval[2].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>";
								sval = "2";
							} else if(sval[3].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>";
								sval = "3";
							} else if(sval[4].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>";
								sval = "4";
							}
							
						}
						if(i==0 || i==1 || i==2){
							sval = $G("signorder_"+i).value;
						}
                        sHtml += "<input type='hidden' size='32' name='group_"+rowindex4op+"_signorder'  value='"+sval+"'>";

						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 5:
						var oDiv = document.createElement("div");
						var sval = $G("conditionss").value;
						var sval1 = $G("conditioncn").value;
                        var sval2 = $G("Coadjutantconditions").value;
						/*var temp = document.all("signorder_5");
						if(document.all("tmptype_5").checked&&(temp[3].checked||temp[4].checked)){
							sval="";
							sval1="";
						}*/
                        if(!$G("tmptype_42").checked){
                            sval2="";
                        }
						while (sval.indexOf("'")>0)
						{
							sval=sval.replace("'","’");
						}
						while (sval1.indexOf("'")>0)
						{
							sval1=sval1.replace("'","’");
						}
						var hashead=0;
						var sHtml="<input type='hidden' name='group_"+rowindex4op+"_condition' value='"+sval+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_conditioncn' value='"+sval1+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_Coadjutantconditions' value='"+sval2+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_IsCoadjutant' value='"+$G("IsCoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_signtype' value='"+$G("signtype").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_issyscoadjutant' value='"+$G("issyscoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_coadjutants' value='"+$G("coadjutants").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_issubmitdesc' value='"+$G("issubmitdesc").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_ispending' value='"+$G("ispending").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_isforward' value='"+$G("isforward").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_ismodify' value='"+$G("ismodify").value+"'>";
                        if(sval1!=""){
						    sHtml+="<%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>:"+sval1;
                            hashead=1;
                        }
                        if(sval2!=""){
                            if(hashead==1) sHtml+="<br>";
                            sHtml+="<%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%>:"+sval2;
                        }
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
						case 6:
							var sval = "";
							if(($G("signordertr")&&$G("signordertr").style.display!="none"
								&&(i == 5||i == 6||i == 7||i == 8||i == 9||i == 38||i == 42||i == 52||i == 53||i == 54||i == 55||i == 51||i == 43
								||i == 49||i == 50||i == 22||i == 23||i == 24||i == 25||i == 26||i == 39||i == 40||i == 41))
								||i == 31||((i == 2||i == 3)&&$G("signorder_"+i))){
								if(i==31||i==2||i==3)
								{
									sval = document.all("signorder_"+i);
								}
								else
								{
									sval = document.all("signorder");
								}
								if(sval)
								{
									
									if(sval[0]&&sval[0].checked){ 
										sval = "0";
		                            }else if(sval[1]&&sval[1].checked){ 
										sval = "1";
									}else if(sval[2]&&sval[2].checked){ 
										sval = "2";
									}else if(sval[3]&&sval[3].checked){ 
										sval = "3";
									}else if(sval[4]&&sval[4].checked){ 
										sval = "4";
									} 
								}
							} 
							
						var oDiv = document.createElement("div");

						//var sval1 = document.getElementById("orders").value;
						var sval1 = $G("orders").value;

						var temp = document.all("signorder");
						var f_check = true;
						if(temp)
						{
							if(document.getElementById("signordertr")&&document.getElementById("signordertr").style.display!="none"&&(temp[3].checked||temp[4].checked)){
								sval1="";
								f_check = false;
							}
						}
						if (sval1==null || sval1 == ''){
							sval1=0;
						}
						//alert(sval1);
						var sHtml="<input type='hidden' name='group_"+rowindex4op+"_orderold' value='"+sval1+"'>";
						var nodetype_operatorgroup = $GetEle("nodetype_operatorgroup").value;
						//如果是会签抄送不显示批次
						if(sval=='3'||sval=='4'){
							sHtml += '';
						} 
						else{
							if(nodetype_operatorgroup == 1 || nodetype_operatorgroup == 2 || nodetype_operatorgroup == 3){
								sHtml+="<input type='text' class='Inputstyle' name='group_"+rowindex4op+"_order' value='"+sval1+"' onchange=\"check_number('group_"+rowindex4op+"_order');checkDigit(this,5,2)\"  maxlength=\"5\" style=\"width:80%\">";
							}else{
								sHtml += sval1;
							}
						}
						if(f_check == false){
							sHtml = "";
						}
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
				}
			}
			rowindex4op = rowindex4op*1 +1;
			}
			$G("fromsrc").value="1";
			$G("conditionss").value="";
			$G("conditioncn").value="";
			$G("conditions").innerHTML="";
			$G("IsCoadjutant").value="";
			$G("signtype").value="";
			$G("issyscoadjutant").value="";
			$G("coadjutants").value="";
			$G("issubmitdesc").value="";
			$G("ispending").value="";
			$G("isforward").value="";
			$G("ismodify").value="";
            $G("Coadjutantconditions").value="";
			$G("Coadjutantconditionspan").innerHTML="";
			//for(itmp = 0;itmp < 32;itmp++)
				//document.form1.tmptype(itmp).checked = false;
			return;
		}
	}
	alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");

}

function checkDigit(elementName,p,s){
	tmpvalue = elementName.value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    elementName.value=newValue;
}

function deleteRow4op()
{
	len = document.addopform.elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.addopform.elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.addopform.elements[i].name=='check_node'){
			if(document.addopform.elements[i].checked==true) {
                if(document.addopform.elements[i].belongtype=="2"){
        			var singerorder_flag = 0;
        			try{
        				singerorder_flag = parseInt($G("singerorder_flag").value);
        			}catch(e){
        				singerorder_flag = 0;
        			}
        			if(singerorder_flag > 0){
        				singerorder_flag = singerorder_flag - 1;
        			}
                    $GetEle("singerorder_flag").value = ""+singerorder_flag;
                    if(singerorder_flag == 0){
                    	$G("singerorder_type").value = "";
                    }
                }
				oTable4op.deleteRow(rowsum1);
			}
			rowsum1 -=1;
		}

	}
}

function addRowByUrger()
{
    var rowindex4op = 0;
    var rows=document.getElementsByName('wfcheck_node');
    var len = document.wfurgerform.elements.length;
    var rowsum1 = 0;
    var obj;
    for(i=0; i < len;i++) {
		if (document.wfurgerform.elements[i].name=='wfcheck_node'){
			rowsum1 += 1;
            obj=document.wfurgerform.elements[i];
            }
    }

    if(rowsum1>0) {
    rowindex4op=parseInt(obj.getAttribute("rowIndex"))+1;
    }



    for(i=0;i<51;i++){

        if(document.wfurgerform.selectindex.value == i){
			switch (i) {
            case 0:
			case 1:
            case 2:
			case 7:
			case 8:
			case 9:
			case 11:
			case 12:
			case 14:
			case 15:
			case 16:
			case 18:
			case 19:
			case 27:
			case 28:
			case 29:
			case 30:
            case 38:
            case 45:
            case 46:
			case 50:
				if($GetEle("wfid_"+i).value ==0 || $GetEle("wflevel_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584, user.getLanguage())%>!");
					return;
				}
				break;
			case 3:
			case 5:
			case 49:
			case 6:
			case 10:
			case 13:
			case 17:
			case 20:
			case 21:
			case 31:
			case 40:
			case 41:
			case 42:
			case 43:
			case 44:
			case 47:
			case 48:

				if($GetEle("wfid_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584, user.getLanguage())%>!");
					return;
				}
				break;

			case 4:
            case 24:
			case 25:
			case 26:
			case 32:

				if($GetEle("wflevel_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584, user.getLanguage())%>!");
					return;
				}
				break;
			}
            var hrmids,hrmnames;
			var k=1;
            if (i==3)  //多人力资源
			{
			var stmps = $G("wfid_"+i).value;
			if (stmps == null) {
				stmps = "";
			}
			hrmids=stmps.split(",");
			var sHtmls = $GetEle("wfname_"+i).innerHTML;
			hrmnames=sHtmls.split(",");
			k=hrmids.length;
			}
			for (m=0;m<k;m++)
			{ rowColor = getRowBg();
			ncol = jQuery(oTableByUrger).attr("cols");
			oRow = oTableByUrger.insertRow(-1);
			for(j=0; j<ncol; j++) {
				oCell = oRow.insertCell(-1);
				oCell.style.height=24;
				oCell.style.background= rowColor;

				switch(j) {
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='wfcheck_node' value='0' rowindex="+rowindex4op+">";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml="";

						if(i==0)
							sHtml="<%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%>";
						if(i== 1 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%>";
						if(i== 2 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122, user.getLanguage())%>";
						if(i== 3 )
							sHtml="<%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%>";
						if(i== 4 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1340, user.getLanguage())%>";
						if(i== 5 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15555, user.getLanguage())%>";
						if(i== 6 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15559, user.getLanguage())%>";
						if(i== 7 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15560, user.getLanguage())%>";
						if(i== 8 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15561, user.getLanguage())%>";
						if(i== 9 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15562, user.getLanguage())%>";
						if(i== 10 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15564, user.getLanguage())%>";
						if(i== 11 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15565, user.getLanguage())%>";
						if(i== 12 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15566, user.getLanguage())%>";
						if(i== 13 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15567, user.getLanguage())%>";
						if(i== 14 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15568, user.getLanguage())%>";
						if(i== 15 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15569, user.getLanguage())%>";
						if(i== 16 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15570, user.getLanguage())%>";
						if(i== 17 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15571, user.getLanguage())%>";
						if(i== 18 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15572, user.getLanguage())%>";
						if(i== 19 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15573, user.getLanguage())%>";
						if(i== 20 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15574, user.getLanguage())%>";
						if(i== 21 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15575, user.getLanguage())%>";
						if(i== 22 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15079, user.getLanguage())%>";
						if(i== 23 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15080, user.getLanguage())%>";
						if(i== 24 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15576, user.getLanguage())%>";
						if(i== 25 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15577, user.getLanguage())%>";
						if(i== 26 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15081, user.getLanguage())%>";
						if(i== 27 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1282, user.getLanguage())%>";
						if(i== 28 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15078, user.getLanguage())%>";
						if(i== 29 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15579, user.getLanguage())%>";
						if(i== 30 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1278, user.getLanguage())%>";
						if(i== 31 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15580, user.getLanguage())%>";
						if(i== 32 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15581, user.getLanguage())%>";
						if(i== 38 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15563, user.getLanguage())%>";
                        if(i== 39 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15578, user.getLanguage())%>";
                        if(i== 40 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18676, user.getLanguage())%>";
                        if(i== 41 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18677, user.getLanguage())%>";
                        if(i== 42 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%>";
                        if(i== 43 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122, user.getLanguage())%>";
                        if(i== 44 )
							sHtml="<%=SystemEnv.getHtmlLabelName(17204, user.getLanguage())%>";
                        if(i== 45 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18678, user.getLanguage())%>";
                        if(i== 46 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18679, user.getLanguage())%>";
                        if(i== 47 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18680, user.getLanguage())%>";
                        if(i== 48 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18681, user.getLanguage())%>";
                        if(i== 49 )
							sHtml="<%=SystemEnv.getHtmlLabelName(19309, user.getLanguage())%>";
						if(i== 50 )
							sHtml="<%=SystemEnv.getHtmlLabelName(20570, user.getLanguage())%>";
                        oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

                        var rowtypevalue = document.wfurgerform.selectvalue.value ;

						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='hidden' name='group_"+rowindex4op+"_type'  value='"+rowtypevalue+"'>";
						oDiv1.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv1);
						break;
					case 2:
					{
						var stmp="";

						if (i==3)
					    {
						stmp=""+hrmids[m];
						}
					    else
					    {
						 stmp = $GetEle("wfid_"+i).value;
					    }

						var oDiv = document.createElement("div");
						var sHtml = "";
						if(i>= 5 && i <= 21 || i == 27 || i == 31 || i == 30 || i==38  || i== 40 || i == 41|| i == 42|| i == 43|| i == 44|| i == 45|| i == 46|| i == 47|| i == 48|| i == 49|| i == 50){
							var srcList = $GetEle("wfid_"+i);
							for (var count = srcList.options.length - 1; count >= 0; count--) {
								if(srcList.options[count].value==stmp)
									sHtml = srcList.options[count].text;
							}
						}
						else if(i== 4 || i== 22 || i== 23 || i==24 || i== 25 || i== 26  || i== 32 || i == 39){
							sHtml = stmp;
						}
						else
					      {
							if (i==3)
							sHtml=hrmnames[m];
							else
							sHtml = $GetEle("wfname_"+i).innerHTML;
						  }
						  if (i==50)  sHtml =sHtml+"/"+$GetEle("tempwflevel_"+i).innerHTML;

						oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

						var oDiv2= document.createElement("div");

						var stemp=stmp;

						var sHtml1 = "<input type='hidden'  name='group_"+rowindex4op+"_id' value='"+stemp+"'>";

						oDiv2.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv2);
						break;
					}
					case 3:
						var oDiv = document.createElement("div");
						var sval = "";
						var sval2 = "";
						var sHtml="";

						if(i == 0 || i == 1 || i == 4 || i == 7 || i == 8 || i == 9 || i == 11 || i == 12 || i== 14 || i == 15 || i == 16 || i == 18 || i == 19 || i == 24 || i == 25 || i == 26 || i == 27 || i == 28 || i == 29 || i == 30 || i == 32 || i == 38 || i == 39 || i == 45 || i == 46||i == 42){
                            sval = $GetEle("wflevel_"+i).value;
                            sval2 = $GetEle("wflevel2_"+i).value;

                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }

						}
						if (i==50)
							{
                            sval = $GetEle("wflevel_"+i).value;

							}
						if(i == 2 ){
							sval = $GetEle("wflevel_"+i).value;
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%>";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%>";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(140, user.getLanguage())%>";
						}

						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);

						var oDiv3= document.createElement("div");
                        var sHtml1 = "<input type='hidden' size='32' name='group_"+rowindex4op+"_level'  value='"+sval+"'>";
                        if(sval2!=""){
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='"+sval2+"'>";
                        }else{
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='-1'>";
                        }

						oDiv3.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv3);
						break;

						case 4:
						var oDiv = document.createElement("div");
						var sval = $GetEle("wfconditionss").value;
						var sval1 = $GetEle("wfconditioncn").value;
						while (sval.indexOf("'")>0)
						{
						sval=sval.replace("'","’");
						}
						while (sval1.indexOf("'")>0)
						{
						sval1=sval1.replace("'","’");
						}

						var sHtml="<input type='hidden' name='group_"+rowindex4op+"_condition' value='"+sval+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_conditioncn' value='"+sval1+"'>";
						sHtml+=$GetEle("wfconditioncn").value;
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
				}
			}
			rowindex4op = rowindex4op*1 +1;
			}
			$GetEle("wffromsrc").value="1";
			$GetEle("wfconditionss").value="";
			$GetEle("wfconditioncn").value="";
			$GetEle("wfconditions").innerHTML="";
			return;
		}
	}
	alert("<%=SystemEnv.getHtmlLabelName(15584, user.getLanguage())%>!");

}


function deleteRowByUrger()
{
	len = document.wfurgerform.elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.wfurgerform.elements[i].name=='wfcheck_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.wfurgerform.elements[i].name=='wfcheck_node'){
			if(document.wfurgerform.elements[i].checked==true) {
				oTableByUrger.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}

rowindex4port = -1;
delids4port = "";
function addRow4port(rformid,risbill,nodeidstr,nodeattrstr,nodenamestr,nodeidattr4,showwayoutinfo)
{
    //if(rowindex4port == -1)
    //rowindex4port=$GetEle("portrowsum").innerHTML;
	var portrowsum = parseInt(document.all("portrowsum").innerHTML);
	if(rowindex4port==-1)
    rowindex4port=portrowsum;
    if(portrowsum>rowindex4port){
    	rowindex4port = portrowsum;
    }
    rowColor = getRowBg();
	ncol = 8;
    if(showwayoutinfo) ncol = 9;
	var oOption=document.portform.curnode.options[document.portform.curnode.selectedIndex];

	if(oOption.value == -1)
		return;

	tmpval = oOption.value;
	tmparry = tmpval.split("_");
	tmpval = tmparry[0];
	tmptype = tmparry[1];
    tmpattr =tmparry[2];
    tmpnodeids=nodeidstr.split(",");
    tmpnodeattrs=nodeattrstr.split(",");
    var splitstr = "<%=Util.getSeparator()%>";
    tmpnodenames=nodenamestr.split(splitstr);
	//添加出口 2012-08-29 ypc 修改
	//在这个地方添加啦document.getElementById();
	//oTable4port.insertRow(-1); 这种写法 导致 新建流程时 按照以下顺序会出现错误（IE浏览器的左下角报js错误）
	//路径设置 - 添加 - 添加节点信息 - 添加流程编号 - 添加出口 (错误就在这里: 当选中某一个节点 点击 添加出口 按钮IE浏览器左下角就报js错误) 此种错误不用图形编辑工具去搭建
	oRow = document.getElementById("oTable4port").insertRow(-1);

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = oOption.text+"<input type='hidden' name='por"+rowindex4port+"_nodeid' value='"+tmpval+"'>";


				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='por" + rowindex4port +"_rej' value='1'";
				if(tmptype != 1)
					sHtml += " disabled ";
				sHtml += ">";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;

			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "";
				sHtml += "<button type='button' class=Browser onclick='onShowBrowser4port(0,"+rowindex4port+","+rformid+","+risbill+")'></button>";
				sHtml +="<input type='hidden' name='por"+rowindex4port+"_con'>";
        /* add by xhheng @20050205 for TD 1537 */
        sHtml +="<input type='hidden' name='por"+rowindex4port+"_con_cn'>";
				sHtml += "<span  name='por"+rowindex4port+"_conspan' id='por"+rowindex4port+"_conspan'></span>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "";
				sHtml += "<button type='button' class=Browser onclick='onShowAddInBrowser(0)'></button>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='por" + rowindex4port +"_isBulidCode' value='1'";
				sHtml += ">";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 6:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' class=inputstyle name='por"+rowindex4port+"_link' onchange='checkinput(\"por"+rowindex4port+"_link\",\"por"+rowindex4port+"_linkspan\"),checkLength(\"por"+rowindex4port+"_link\",\"60\",\"<%=SystemEnv.getHtmlLabelName(15611, user.getLanguage())%>\",\"文本长度不能超过\",\"1个中文字符等于2个长度\")'>";
				sHtml += "<span  id='por"+rowindex4port+"_linkspan'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 7:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='por"+rowindex4port+"_des' onchange=checkSame('por"+rowindex4port+"_nodeid',this,'"+nodeidattr4+"','por"+rowindex4port+"_ismustpass','por"+rowindex4port+"_ismustpassspan')><option value='-1'><%=SystemEnv.getHtmlLabelName(15612, user.getLanguage())%></option>";
                for(i=0;i<tmpnodeids.length; i++) {
                        switch(tmpattr){
                            case "0":
                            case "3":
                            case "4":
                                if(tmpnodeattrs[i]!=2){
                                    sHtml += "<option value='"+tmpnodeids[i]+"'><strong>"+tmpnodenames[i]+"</strong>";
                                }
                                break;
                            case "1":
                                if(tmpnodeattrs[i]!=3&&tmpnodeattrs[i]!=4){
                                    sHtml += "<option value='"+tmpnodeids[i]+"'><strong>"+tmpnodenames[i]+"</strong>";
                                }
                                break;
                            case "2":
                                if(tmpnodeattrs[i]!=0&&tmpnodeattrs[i]!=1){
                                    sHtml += "<option value='"+tmpnodeids[i]+"'><strong>"+tmpnodenames[i]+"</strong>";
                                }
                                break;
                        }
                }
                sHtml+= "</select><input type=checkbox name='por"+rowindex4port+"_ismustpass' value='1' style='display:none;'><SPAN id='por"+rowindex4port+"_ismustpassspan' style='display:none;'><%=SystemEnv.getHtmlLabelName(21398, user.getLanguage())%></SPAN>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);

				break;
            case 8:
                var oDiv = document.createElement("div");
                //TD23877:20110509 出口提示信息的长度控制 ADD BY QB START  
				//var sHtml = "<input type='text' class=inputstyle name='por"+rowindex4port+"_tipsinfo'  maxlength=500>";
				var sHtml = "<input type='text' class=inputstyle name='por"+rowindex4port+"_tipsinfo' onblur=checkAddInputInfoLength(this) maxlength=500>";
				//TD23877:20110509 出口提示信息的长度控制 ADD BY QB END  
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
        }
	}
	rowindex4port = rowindex4port*1 +1;

}

//add by xwj  for td3665 20060223
function CheckAll(haschecked,flag) {
    len = document.wfmForm.elements.length;
    var i=0;
    var name = "";
    for( i=0; i<len; i++) {
        name = document.wfmForm.elements[i].name;
        if (name.indexOf(flag)!=-1) {
            document.wfmForm.elements[i].checked=(haschecked==true?true:false);
        }
    }
}


function deleteRow4port()
{   if(rowindex4port == -1)
    rowindex4port=$GetEle("portrowsum").innerHTML;
	len = document.portform.elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.portform.elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.portform.elements[i].name=='check_node'){
			if(document.portform.elements[i].checked==true) {
				if(document.portform.elements[i].value!='0')
					delids4port +=","+ document.portform.elements[i].value;
					//删除出口 > 添加 document.getElementById(); 2012-08-29 ypc 修改 (直接通过 id:oTable4port 获取不到该属性 在某种情况下)
				document.getElementById("oTable4port").deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}

function onShowBrowser4port(id,row,rformid,risbill){
//	alert("id:"+id+",row:"+row);
    if(id==0) {
		alert("<%=SystemEnv.getHtmlLabelName(15613, user.getLanguage())%>");
    } else {
		url = "BrowserMain.jsp?url=showcondition.jsp?formid="+rformid+"&isbill="+risbill+"&id="+row+"&linkid="+id;
		con = window.showModalDialog(url,'','dialogHeight:400px;dialogwidth:600px');
		if(con!=null) {
			if(con != ""){
	      		//modify by xhheng @20050205 for TD 1537
				$G("por"+row+"_con").value=con.substring(0,con.indexOf(";"));
				$G("por"+row+"_con_cn").value=con.substring(con.indexOf(";")+1,con.length);
	      		$G("por"+row+"_conspan").innerHTML="<img src='/images/BacoCheck.gif' border=0></img>";
			} else {
				$G("por"+row+"_con").value="";
				$G("por"+row+"_con_cn").value="";
				$G("por"+row+"_conspan").innerHTML="";
			}
		} 
    }
}
function onShowAddInBrowser(row){
//	alert(row);
	if(row==0)
		alert("<%=SystemEnv.getHtmlLabelName(15613, user.getLanguage())%>");
	else{
		url = "BrowserMain.jsp?url=showaddinoperate.jsp?wfid=<%=wfid%>&linkid="+row;
		con = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if(con != undefined){
        if(con=="1"){
            $GetEle("ischeck"+row+"span").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            $GetEle("ischeck"+row+"span").innerHTML="";
        }
    }
	}
//	alert(url);
}
function checkSame(curNodePortal,obj,nodeidattr4,ismustpass,ismustpassspan){
    if($GetEle(curNodePortal).value==obj.value)
    alert("<%=SystemEnv.getHtmlLabelName(18690, user.getLanguage())%>");
    tmpnodeid =","+obj.value+",";
    nodeidattr4+=",";
    if(nodeidattr4.indexOf(tmpnodeid)>-1){
        document.portform.all(ismustpass).style.display='';
        document.portform.all(ismustpassspan).style.display='';
    }else{
        document.portform.all(ismustpass).style.display='none';
        document.portform.all(ismustpassspan).style.display='none';
    }
}


function logtype(obj){

     if(obj.value=="0")
     $GetEle('slog').src="";
       else if(obj.value=="1")
     $GetEle('slog').src="/systeminfo/SysMaintenanceLog.jsp?wflog=1&sqlwhere=where operateitem=85 and relatedid=<%=wfid%>";
       else if(obj.value=="2")
     $GetEle('slog').src="/systeminfo/SysMaintenanceLog.jsp?wflog=1&sqlwhere=where operateitem=86 and relatedid=<%=wfid%>";
       else if(obj.value=="3")
     $GetEle('slog').src="/systeminfo/SysMaintenanceLog.jsp?wflog=1&sqlwhere=where operateitem=88 and relatedid=<%=wfid%>";
   }

function logsearch()
{
	doPost(SysMaintenanceLog,log);
}
</script>

<SCRIPT LANGUAGE=javascript>
function addrow(){
	var oRow;
	var oCell;

	oRow = inputface.insertRow(-1);
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = lable_cn.innerHTML ;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = lable_en.innerHTML;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = type_cn.innerHTML ;	
    oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = action.innerHTML ;
}

function del(obj){
	var rowobj = obj.parentElement.parentElement;
	rowobj.parentElement.deleteRow(rowobj.getAttribute("rowIndex"));
}

function delitem(obj){
	var rowobj = obj.parentElement.parentElement;
	rowobj.parentElement.deleteRow(rowobj.getAttribute("rowIndex"));
}

function upitem(obj){
	if(obj.parentElement.parentElement.getAttribute("rowIndex")==0){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.getAttribute("rowIndex")-1);
	for(var i=0; i<4; i++){
		var cellobj = rowobj.insertCell(-1)
        //cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}
	tobj.deleteRow(obj.parentElement.parentElement.getAttribute("rowIndex"));
}

function downitem(obj){
	if(obj.parentElement.parentElement.getAttribute("rowIndex")==obj.parentElement.parentElement.parentElement.rows.length-1){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.getAttribute("rowIndex")+2);
	for(var i=0; i<4; i++){
		var cellobj = rowobj.insertCell(-1)
        //cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}
	tobj.deleteRow(obj.parentElement.parentElement.getAttribute("rowIndex"));
}

function up(obj){
	if(obj.parentElement.parentElement.getAttribute("rowIndex")==0){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.getAttribute("rowIndex")-1);
	for(var i=0; i<4; i++){
		var cellobj = rowobj.insertCell(-1)
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}
	tobj.deleteRow(obj.parentElement.parentElement.getAttribute("rowIndex"));
}

function down(obj){
	if(obj.parentElement.parentElement.getAttribute("rowIndex")==obj.parentElement.parentElement.parentElement.rows.length-1){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.getAttribute("rowIndex")+2);
	for(var i=0; i<4; i++){
		var cellobj = rowobj.insertCell(-1)
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}
	tobj.deleteRow(obj.parentElement.parentElement.getAttribute("rowIndex"));
}

function clearTempObj(){
    lable_cn.innerHTML="";
    lable_en.innerHTML="";
    type_cn.innerHTML="";
    action.innerHTML="";
}
</SCRIPT>
<script language="javascript">
function submitFields()
{
	if(check_opinion_form()){
	doPost(formlabel,tab8);
	}
}

function check_label(){
	var obj = document.getElementsByName("label_cn");
	var spanids = document.getElementsByName("span_label_id");
	if(obj.length){
		for(var i=1; i<obj.length; i++){
			if(trim(obj[i].value) == ""){
				spanids[i].innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			}else{
				spanids[i].innerHTML = "";
			}
		}
	}
	return true;
}

function check_opinion_form(){
	var obj = document.getElementsByName("label_cn");
	var spanids = document.getElementsByName("span_label_id");
	if(obj.length){
		for(var i=1; i<obj.length; i++){
			if(trim(obj[i].value) == ""){
				spanids[i].innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
				return false;
			}else{
				spanids[i].innerHTML = "";
			}
		}
	}
	return true;
}
</script>

<script language="javascript">
function nodeOpinionFields(id)
{
	doGet(tab2, "/workflow/workflow/AddOpinionField.jsp?ajax=1&wfid=<%=wfid%>&nodeid="+id);
}

function nodeOpinionfieldsave(){
    doPost(opinionform,tab2) ;
}

//高级设置 流程创建文档
function showContent()
{
    if($GetEle("show").checked)
    {
        $GetEle("contentDiv").style.display = "block";
    }
    else
    {
    	$GetEle("contentDiv").style.display = "none";
    }
}

//高级设置 流程创建文档
function loadIFrame(fieldId)
{
	$GetEle("chooseDisplayAttributeForm").src = "chooseDisplayAttributeIForm.jsp?fieldId=" + fieldId  + "&wfid=" + <%=wfid%>;
}

//高级设置详细设置 流程创建文档
//标签ID, 工作流ID, 下拉框值ID, 文档目录, 二级目录ID, 表单ID, 模版ID
function detailConfig(talID, flowID, selectItemID, pathCategory, secCategoryID, formID, mouldID)
{
	if("" == pathCategory || null == pathCategory)
	{
		alert("<%=SystemEnv.getHtmlLabelName(19373, user.getLanguage())%>");
		return;
	}
	else
	{
		pathCategory = escape(pathCategory);
		doGet(talID, 'CreateDocumentDetailByWorkFlow.jsp?ajax=1&flowID=' + flowID + '&selectItemID=' + selectItemID + '&pathCategory=' + pathCategory + '&secCategoryID=' + secCategoryID + '&formID=' + formID + '&mouldID=' + mouldID);
	}
}

function saveCreateDocumentByAction(obj)
{
    doPost(CreateDocumentByAction, tab0005);
    //obj.disabled=true;
}

function saveCreateDocument(obj)
{   
    if($GetEle("show").checked)
    {
        if (check_form(createDocumentByWorkFlow,'pathCategoryDocument'))
    	{
    	    doPost(createDocumentByWorkFlow, tab0001);
    	    obj.disabled=true;
    	}
    }
    else
    {
        doPost(createDocumentByWorkFlow, tab0001);
        obj.disabled=true;
    }    
}

function saveCreateDocumentDetail(obj)
{
	doPost(createDocumentDetailByWorkFlow, tab0001);	
	obj.disabled=true;
}

function cancelCreateDocumentDetail(obj)
{
	doGet(tab0001, tab0001URL);
}

//高级设置详细设置 文档属性页设置
function docPropDetailConfig(tabId,docPropId,workflowId,selectItemId, pathCategory, secCategoryId){
	if("" == pathCategory || null == pathCategory){
		alert("<%=SystemEnv.getHtmlLabelName(19373, user.getLanguage())%>");
		return;
	}else{
		pathCategory = escape(pathCategory);
		doGet(tabId, 'WorkflowDocPropDetail.jsp?ajax=1&docPropId=' + docPropId + '&workflowId=' + workflowId+ '&selectItemId=' + selectItemId + '&pathCategory=' + pathCategory + '&secCategoryId=' + secCategoryId);
	}
}

function saveDocPropDetail(obj){
	doPost(docPropDetailForm, tab0001);	
	obj.disabled=true;
}

function cancelDocPropDetail(obj){
	doGet(tab0001, tab0001URL);
}
function onShowSubcompanyShowAttr(workflowId,formId,isBill,fieldId,selectValue){

    url=encode("/workflow/workflow/showSubcompanyShowAttrList.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&fieldId="+fieldId+"&selectValue="+selectValue);	
	con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
}
//高级设置详细设置 二维条码设置
//标签ID, 工作流ID
function detailBarCodeSet(talID, workflowId, formID, isbill){
		doGet(talID, 'WorkflowBarCodeSet.jsp?ajax=1&workflowId=' + workflowId + '&formId=' + formID + '&isBill=' + isbill );
}


function checkValueBarCodeSet(){
    if(!check_form(formBarCodeSet,"printRatioBarCodeSet,minWidthBarCodeSet,maxWidthBarCodeSet,bestWidthBarCodeSet,minHeightBarCodeSet,maxHeightBarCodeSet,bestHeightBarCodeSet")){//判断必填项
		return false;
	}

    var minWidthBarCodeSet=parseInt(formBarCodeSet.minWidthBarCodeSet.value);
    var maxWidthBarCodeSet=parseInt(formBarCodeSet.maxWidthBarCodeSet.value);
	if(minWidthBarCodeSet>maxWidthBarCodeSet){
		alert("<%=SystemEnv.getHtmlLabelName(21467, user.getLanguage())%>");
		return false;
	}

    var bestWidthBarCodeSet=parseInt(formBarCodeSet.bestWidthBarCodeSet.value);  
	if(bestWidthBarCodeSet<minWidthBarCodeSet||bestWidthBarCodeSet>maxWidthBarCodeSet){
		alert("<%=SystemEnv.getHtmlLabelName(21468, user.getLanguage())%>");
		return false;
	}

    var minHeightBarCodeSet=parseInt(formBarCodeSet.minHeightBarCodeSet.value);
    var maxHeightBarCodeSet=parseInt(formBarCodeSet.maxHeightBarCodeSet.value);
	if(minHeightBarCodeSet>maxHeightBarCodeSet){
		alert("<%=SystemEnv.getHtmlLabelName(21469, user.getLanguage())%>");
		return false;
	}

    var bestHeightBarCodeSet=parseInt(formBarCodeSet.bestHeightBarCodeSet.value);  
	if(bestHeightBarCodeSet<minHeightBarCodeSet||bestHeightBarCodeSet>maxHeightBarCodeSet){
		alert("<%=SystemEnv.getHtmlLabelName(21470, user.getLanguage())%>");
		return false;
	}

	return true ;
}

function saveBarCodeSet(obj){
	if(checkValueBarCodeSet()){
	    doPost(formBarCodeSet, tab0001);	
	    obj.disabled=true;
	}

}

function cancelBarCodeSet(obj){
	doGet(tab0001, tab0001URL);
}

function showContentBarCodeSet(){
    if($GetEle("isUseBarCodeSet").checked){
        $GetEle("contentDivBarCodeSet").style.display = "block";
    }
    else{
    	$GetEle("contentDivBarCodeSet").style.display = "none";
    }
}

function changeMeasureUnit(objValue){
    if(objValue==1){
        widthRangeSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(21450, user.getLanguage())%>";
        bestWidthSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(21450, user.getLanguage())%>";
        heightRangeSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(21450, user.getLanguage())%>";
        bestHeightSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(21450, user.getLanguage())%>";

        formBarCodeSet.minWidthBarCodeSet.value="30";
        formBarCodeSet.maxWidthBarCodeSet.value="70";
        formBarCodeSet.bestWidthBarCodeSet.value="50";

        formBarCodeSet.minHeightBarCodeSet.value="10";
        formBarCodeSet.maxHeightBarCodeSet.value="25";
        formBarCodeSet.bestHeightBarCodeSet.value="20";
    }
    else if(objValue==2){
        widthRangeSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%>";
        bestWidthSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%>";
        heightRangeSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%>";
        bestHeightSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%>";

        formBarCodeSet.minWidthBarCodeSet.value="113";
        formBarCodeSet.maxWidthBarCodeSet.value="265";
        formBarCodeSet.bestWidthBarCodeSet.value="189";

        formBarCodeSet.minHeightBarCodeSet.value="38";
        formBarCodeSet.maxHeightBarCodeSet.value="144";
        formBarCodeSet.bestHeightBarCodeSet.value="76";
    }
}

//add by fanggsh 20060705 for TD 4531 begin

function removeValue(){

	len = document.formWorkflowSubwfSet.elements.length;

	var i=0;

	var hasItem = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.formWorkflowSubwfSet.elements[i].name=='chkSubWorkflowSet'){
			if(document.formWorkflowSubwfSet.elements[i].checked==true) {
				    hasItem=1;				
			}
		}	
	} 

	if(hasItem == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return ;
	}


    if(!confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
        return ;	
	}

	var rowsum1 = 0;

	for(i=len-1; i >= 0;i--) {
		if (document.formWorkflowSubwfSet.elements[i].name=='chkSubWorkflowSet')
			rowsum1 += 1;
	}

	for(i=len-1; i >= 0;i--) {
		if (document.formWorkflowSubwfSet.elements[i].name=='chkSubWorkflowSet'){


			if(document.formWorkflowSubwfSet.elements[i].checked==true) {
                workflowSubwfSetId=document.formWorkflowSubwfSet.elements[i].value;
                if(workflowSubwfSetId!=null&&workflowSubwfSetId!='0'){
				    WorkflowSubwfSetUtil.deleteWorkflowSubwfSet(workflowSubwfSetId,returnTrue) ;
				    //ypc 2011
				    document.getElementById("oTable").deleteRow(rowsum1+1);
				}
				
			}
			rowsum1 -=1;
		}	
	} 
}

function returnTrue(o){
	return true;
}


function returnWorkflowSubwfSetId(o){
    var oRowIndex = o.split('_')[0];
	var workflowSubwfSetId = o.split('_')[1];

	var mainWorkflowId = $G("mainWorkflowId").value;

    if(oRowIndex==2){
		$G("chkSubWorkflowSet").value=workflowSubwfSetId;
		subWorkflowId=$G("subWorkflowIdValue").value;

		$G("detailLinkSpan").innerHTML="<A HREF='#' onClick='goWorkflowSubwfSetDetail(tab0002, "+workflowSubwfSetId+", "+mainWorkflowId+", "+subWorkflowId+")'"+"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></A>";
    } else if(oRowIndex>2){
    	jQuery("input[name=chkSubWorkflowSet]")[oRowIndex-2].value = workflowSubwfSetId;
		subWorkflowId=jQuery("input[name=subWorkflowIdValue]")[oRowIndex-2].value;

		jQuery("span[id=detailLinkSpan]")[oRowIndex-2].innerHTML="<A HREF='#' onClick='goWorkflowSubwfSetDetail(tab0002, "+workflowSubwfSetId+", "+mainWorkflowId+", "+subWorkflowId+")'"+"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></A>";		
	}
    var size = jQuery("select[name=isreaddetail]").length;   
    jQuery("select[name=isreaddetail]")[size-1].name=workflowSubwfSetId;
}


function addValue(){
    var isread = $G("isread").value;
    var subWorkflowIdValue=$G("subWorkflowId").value;
    var subWorkflowNameText=$G("subWorkflowNameSpan").innerHTML;    

	if(subWorkflowIdValue==""||subWorkflowIdValue=="0"){
		alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		return;
	}

   var mainWorkflowId=<%=wfid%>;

   var triggerTypeValue=$G("triggerType").value;
   var triggerTypeText = jQuery($G("triggerType").options.item($G("triggerType").selectedIndex)).text();

   var triggerNodeIdValue=$G("triggerNodeId").value;
   triggerNodeIdValue=triggerNodeIdValue.substr(triggerNodeIdValue.lastIndexOf("_")+1);
   var triggerNodeNameText = jQuery($G("triggerNodeId").options.item($G("triggerNodeId").selectedIndex)).text();

   var triggerTimeValue=$G("triggerTime").value;
   var triggerTimeText = jQuery($G("triggerTime").options.item($G("triggerTime").selectedIndex)).text();

   var triggerOperationText ="";
   var triggerOperationValue=$G("trTriggerOperationHidden").value;
   //var triggerOperationText = $G("triggerOperation").options.item($G("trTriggerOperationHidden").selectedIndex).innerText;
   
   if(triggerOperationValue!="" && triggerOperationValue==1){
   		triggerOperationText='<%=SystemEnv.getHtmlLabelName(25361,user.getLanguage())%>';
   }else if(triggerOperationValue!="" && triggerOperationValue==2){
   		triggerOperationText='<%=SystemEnv.getHtmlLabelName(25362,user.getLanguage())%>';
   }else if(triggerOperationValue!="" && triggerOperationValue==3){
   		triggerOperationText='<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>';
   }else if(triggerOperationValue!="" && triggerOperationValue==4){
   		triggerOperationText='<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>';
   }else{
   		triggerOperationText="";
   }
   if(triggerTypeValue==2){
	   triggerTimeValue="";
	   triggerTimeText="";
	   triggerOperationValue="";
	   triggerOperationText="";
   }
   
   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.getAttribute("rowIndex");

   if (oRowIndex%2==0) oRow.className="dataLight";
   else oRow.className="dataDark";


   for (var i =1; i <=8; i++) {   //生成一行中的每一列


      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1)
		  oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkSubWorkflowSet' value='0'>";
      else  if (i==2) oDiv.innerHTML=triggerTypeText+"<input type='hidden' name='triggerTypeValue' value='"+triggerTypeValue+"'><input type='hidden' name='triggerTypeText' value='"+triggerTypeText+"'>";
      else  if (i==3) oDiv.innerHTML=triggerNodeNameText+"<input type='hidden' name='triggerNodeIdValue' value='"+triggerNodeIdValue+"'><input type='hidden' name='triggerNodeNameText' value='"+triggerNodeNameText+"'>";
      else  if (i==4) oDiv.innerHTML=triggerTimeText+"<input type='hidden' name='triggerTimeValue' value='"+triggerTimeValue+"'><input type='hidden' name='triggerTimeText' value='"+triggerTimeText+"'>";
      else  if (i==5) oDiv.innerHTML=triggerOperationText+"<input type='hidden' name='triggerOperationValue' value='"+triggerOperationValue+"'><input type='hidden' name='triggerOperationText' value='"+triggerOperationText+"'>";
      else  if (i==6) oDiv.innerHTML=subWorkflowNameText+"<input type='hidden' name='subWorkflowIdValue' value='"+subWorkflowIdValue+"'><input type='hidden' name='subWorkflowNameText' value='"+subWorkflowNameText+"'>";
      else  if (i==7) if(isread==0)oDiv.innerHTML="<select class='inputStyle' name=isreaddetail onchange=isreadonchange(this)><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option></select>";
                      else oDiv.innerHTML="<select class='inputStyle' name=isreaddetail onchange=isreadonchange(this)><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><option value=1 selected><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option></select>";                      
      else  if (i==8) oDiv.innerHTML="<span id=detailLinkSpan><a href='#'><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a></span>";

      jQuery(oCell).append(oDiv);
   }
    WorkflowSubwfSetUtil.addWorkflowSubwfSet(mainWorkflowId,subWorkflowIdValue,triggerNodeIdValue,triggerTypeValue,triggerTimeValue,triggerOperationValue,oRowIndex,isread+"",returnWorkflowSubwfSetId);
}

function isreadonchange(obj){
   WorkflowSubwfSetUtil.updateWorkflowSubwfSet(obj.name,obj.value,returnTrue) ;
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkSubWorkflowSet");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }
}

function chkAllDiffClick(obj){
    var chks = document.getElementsByName("chkSubWorkflowSetDiff");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }
}

function encode(str){
    return escape(str);
}

function changeIfSplitField(obj){

    var objId=$(obj).attr("id");
    var objValue=$(obj).val();

    var divName="divIfSplitField_"+objId.substr(objId.lastIndexOf("_")+1)

    var objHtmlType=objValue.substring(0,objValue.indexOf("_"));
    var objType=objValue.substring(objValue.indexOf("_")+1,objValue.lastIndexOf("_"));

    var objChkIfSplitField=$($(obj).parent().next().children()[0]).children()[0];
    
    if(objHtmlType=='3'&&(objType=='17'||objType=='141'||objType=='142'||objType=='166')){
        $("#"+divName).show();
        objChkIfSplitField.value='1'
        objChkIfSplitField.checked=false        
    }else{
    	$("#"+divName).hide();
        objChkIfSplitField.value='1'
        objChkIfSplitField.checked=false    
    }

}

function onSaveWorkflowSubwfSetDetail1(obj)
{
	obj.disabled=true;
	var eles = document.getElementsByName("mainWorkflowFieldId");
	var eles = jQuery("select[name=mainWorkflowFieldId][viewtype=1]");
	if (eles != null && eles != undefined) {
		for (var i=0; i<eles.length; i++) {
			var eleValue = jQuery(eles[i]).children("option:selected").val();
			if (eleValue == "" || eleValue == null) {
				alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
				obj.disabled=false;
				eles[i].focus();
				return;
			}
		}
	}
    doPost(formWorkflowSubwfSetDetail,tab0002);	
}

function onCancelWorkflowSubwfSetDetail(obj)
{
	doGet(tab0002, tab0002URL);
}

//标签ID, 子流程设置ID, 主流程ID, 子流程ID
function goWorkflowSubwfSetDetail(talID, workflowSubwfSetId, mainWorkflowId, subWorkflowId)
{
	doGet(talID, "/workflow/workflow/WorkflowSubwfSetDetail.jsp?ajax=1&workflowSubwfSetId="+workflowSubwfSetId+"&mainWorkflowId="+mainWorkflowId+"&subWorkflowId="+subWorkflowId);

}

function clearOtherChkOfSubwfSetDetail(obj)
{

	var rowsLength=oTableOfSubwfSetDetail.rows.length;
	var objName=$(obj).attr("name");
    var objIndex=objName.substr(objName.lastIndexOf("_")+1);
	if(obj.checked==true){
		for(i=0;i<=rowsLength-2;i++){
			if(i!=objIndex){
				if($("input[name=chkIfSplitField_"+i+"]").length>0&&$("input[name=chkIfSplitField_"+i+"]").parent().css("display")!="null"){
					$("input[name=chkIfSplitField_"+i+"]")[0].checked=false;
				}
				
			}
		}
    }
}

function changeTriggerTypeAndOperation(){
	$G("trTriggerTime").style.display="none";
	$G("trTriggerTimeLine").style.display="none";
	$G("trTriggerOperation").style.display="none";
	$G("trTriggerOperationLine").style.display="none";
	$G("triggerTime").style.display="none";
	$G("triggerOperation").style.display="none";
	
	
    var triggerNodeId=$G("triggerNodeId").value;
    var triggerNodeType=triggerNodeId.substring(0,triggerNodeId.indexOf("_"));
    triggerNodeId=triggerNodeId.substr(triggerNodeId.lastIndexOf("_")+1)

    var triggerType=$G("triggerType").value;

    var triggerTime=$G("triggerTime").value;
    var finalOperationValue="";

	if(triggerType==1){
	    $G("trTriggerTime").style.display="";
	    $G("trTriggerTimeLine").style.display="";
	    $G("triggerTime").style.display="";
	    $G("trTriggerOperationNew").style.display="none";
	    $G("triggerOperationNew").style.display="none";
		if(triggerNodeType==1||triggerTime==1){
	        $G("trTriggerOperationLine").style.display="";
	    	$G("triggerOperation").style.display="";
	    	if(triggerTime==1){ //到达节点
	    		finalOperationValue = $G("triggerOperation").value;
	    		$G("trTriggerOperation").style.display="";
	    		$G("trTriggerOperationNew").style.display="none";
	    		$G("triggerOperationNew").style.display="none";
	    	}
	    	if(triggerTime==2){ //离开节点
	    
	    		finalOperationValue = $G("triggerOperationNew").value;
	    		$G("trTriggerOperation").style.display="none";
	    		$G("trTriggerOperationNew").style.display="";
	    		//TD23271:20110505 ADD BY QB START
	    		$G("triggerOperationNew").style.display="";
	    		
	    		$G("triggerOperation").style.display="none";
	    		//TD23271:20110505 ADD BY QB END
	    	}
		} else {
			//TD23271:20110505 ADD BY QB START
			$G("trTriggerOperationNew").style.display="none";
			$G("triggerOperationNew").style.display="none";
			//TD23271:20110505 ADD BY QB END
		}
	}else{
		$G("trTriggerOperationNew").style.display="none"; //有自动触发(触发节点：审批  触发时间：离开节点) 改为手动触发时隐藏 触发操作 
	}
	$G("trTriggerOperationHidden").value = finalOperationValue;
}

function triggerOperationSelected(){
	var triggerNodeId=$G("triggerNodeId").value;
    var triggerNodeType=triggerNodeId.substring(0,triggerNodeId.indexOf("_"));
    triggerNodeId=triggerNodeId.substr(triggerNodeId.lastIndexOf("_")+1)
    var triggerType=$G("triggerType").value;
    var triggerTime=$G("triggerTime").value;
	var finalOperationValue="";
	if(triggerType==1){
		if(triggerNodeType==1||triggerTime==1){
	    	if(triggerTime==1){ //到达节点
	    		finalOperationValue = $G("triggerOperation").value;
	    	}
	    	if(triggerTime==2){ //离开节点
	    		finalOperationValue = $G("triggerOperationNew").value;
	    	}
		}
	}
	$G("trTriggerOperationHidden").value = finalOperationValue;
}

function returnTrueDiff(o){
	return true;
}

function showSubwfSetContent(objId){
   var mainWorkflowId=<%=wfid%>;

	if(objId==1){
    	$GetEle("subwfSetContentDivSame").style.display = "none";
        $GetEle("subwfSetContentDivDiff").style.display = "block";
		WorkflowSubwfSetUtil.updateIsTriDiffWorkflow(mainWorkflowId,1,returnTrueDiff);
	}else{
    	$GetEle("subwfSetContentDivSame").style.display = "block";
        $GetEle("subwfSetContentDivDiff").style.display = "none";
		WorkflowSubwfSetUtil.updateIsTriDiffWorkflow(mainWorkflowId,0,returnTrueDiff);
	}
}



function removeValueDiff(){

	len = document.formWorkflowSubwfSet.elements.length;

	var i=0;

	var hasItem = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.formWorkflowSubwfSet.elements[i].name=='chkSubWorkflowSetDiff'){
			if(document.formWorkflowSubwfSet.elements[i].checked==true) {
				    hasItem=1;				
			}
		}	
	} 

	if(hasItem == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>!");
		return ;
	}


    if(!confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>")){
        return ;	
	}

	var rowsum1 = 0;

	for(i=len-1; i >= 0;i--) {
		if (document.formWorkflowSubwfSet.elements[i].name=='chkSubWorkflowSetDiff')
			rowsum1 += 1;
	}

	for(i=len-1; i >= 0;i--) {
		if (document.formWorkflowSubwfSet.elements[i].name=='chkSubWorkflowSetDiff'){


			if(document.formWorkflowSubwfSet.elements[i].checked==true) {
                workflowSubwfSetId=document.formWorkflowSubwfSet.elements[i].value;
                if(workflowSubwfSetId!=null&&workflowSubwfSetId!='0'){
				    WorkflowSubwfSetUtil.deleteWorkflowSubwfSetDiff(workflowSubwfSetId,returnTrueDiff) ;
				    oTableDiff.deleteRow(rowsum1+1);
				}
				
			}
			rowsum1 -=1;
		}	
	} 
}

function returnWorkflowTriDiffWfDiffFieldId(o){

    var oRowIndex=o.split('_')[0];
	var triDiffWfDiffFieldId=o.split('_')[1];

    if(oRowIndex==2){
		$GetEle("chkSubWorkflowSetDiff").value=triDiffWfDiffFieldId;

		$GetEle("detailLinkDiffSpan").innerHTML="<A HREF='#' onClick='goWorkflowTriDiffWfSubWf(tab0002, "+triDiffWfDiffFieldId+")'"+"><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage())%></A>";
    }
    else if(oRowIndex>2){
		document.getElementsByName("chkSubWorkflowSetDiff")[oRowIndex-2].value=triDiffWfDiffFieldId;

		document.getElementsByName("detailLinkDiffSpan")[oRowIndex-2].innerHTML="<A HREF='#' onClick='goWorkflowTriDiffWfSubWf(tab0002, "+triDiffWfDiffFieldId+")'"+"><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage())%></A>";		
	}
}

function addValueDiff(){
  
   var mainWorkflowId=<%=wfid%>;


   var triggerTypeDiffValue=$("select[name=triggerTypeDiff]").val();
   var triggerTypeDiffText = $($("select[name=triggerTypeDiff]")[0].options.item($("select[name=triggerTypeDiff]")[0].selectedIndex)).text();

   var triggerNodeIdDiffValue=$("select[name=triggerNodeIdDiff]").val();
   triggerNodeIdDiffValue=triggerNodeIdDiffValue.substr(triggerNodeIdDiffValue.lastIndexOf("_")+1);

   var triggerNodeNameDiffText = $($("select[name=triggerNodeIdDiff]")[0].options.item($("select[name=triggerNodeIdDiff]")[0].selectedIndex)).text();

	var triggerTimeDiffObject=document.getElementsByName("triggerTimeDiff")[0];
   var triggerTimeDiffValue=$(triggerTimeDiffObject).val();
   var triggerTimeDiffText = $(triggerTimeDiffObject.options.item(triggerTimeDiffObject.selectedIndex)).html();

   var triggerOperationDiffText ="";
   var triggerOperationDiffValue=$("input[name=trTriggerOperationDiffHidden]").val();
   //var triggerOperationDiffText = $GetEle("triggerOperationDiff").options.item($GetEle("triggerOperationDiff").selectedIndex).innerText;

   if(triggerOperationDiffValue!="" && triggerOperationDiffValue==1){
   		triggerOperationDiffText='<%=SystemEnv.getHtmlLabelName(25361, user.getLanguage())%>';
   }else if(triggerOperationDiffValue!="" && triggerOperationDiffValue==2){
   		triggerOperationDiffText='<%=SystemEnv.getHtmlLabelName(25362, user.getLanguage())%>';
   }else if(triggerOperationDiffValue!="" && triggerOperationDiffValue==3){
   		triggerOperationDiffText='<%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%>';
   }else if(triggerOperationDiffValue!="" && triggerOperationDiffValue==4){
   		triggerOperationDiffText='<%=SystemEnv.getHtmlLabelName(236, user.getLanguage())%>';
   }else{
   		triggerOperationDiffText="";
   }
   
   

   var fieldIdDiffObj=$("select[name=fieldIdDiff]")[0];
   var fieldIdDiffValue=$(fieldIdDiffObj).val();

   if(fieldIdDiffValue==""){
	   alert("<%=SystemEnv.getHtmlLabelName(25166, user.getLanguage())%>");
	   return;
   }


   var fieldNameDiffText = $(fieldIdDiffObj.options.item(fieldIdDiffObj.selectedIndex)).text();

   if(triggerTypeDiffValue==2){
	   triggerTimeDiffValue="";
	   triggerTimeDiffText="";
	   triggerOperationDiffValue="";
	   triggerOperationDiffText="";
   }
   
   var oRow = oTableDiff.insertRow(-1);
   var oRowIndex = oRow.getAttribute("rowIndex");

   if (oRowIndex%2==0) oRow.className="dataLight";
   else oRow.className="dataDark";


   for (var i =1; i <=7; i++) {   //生成一行中的每一列


      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1)
		  oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkSubWorkflowSetDiff' value='0'>";
      else  if (i==2) oDiv.innerHTML=triggerTypeDiffText+"<input type='hidden' name='triggerTypeDiffValue' value='"+triggerTypeDiffValue+"'><input type='hidden' name='triggerTypeDiffText' value='"+triggerTypeDiffText+"'>";
      else  if (i==3) oDiv.innerHTML=triggerNodeNameDiffText+"<input type='hidden' name='triggerNodeIdDiffValue' value='"+triggerNodeIdDiffValue+"'><input type='hidden' name='triggerNodeNameDiffText' value='"+triggerNodeNameDiffText+"'>";
      else  if (i==4) oDiv.innerHTML=triggerTimeDiffText+"<input type='hidden' name='triggerTimeDiffValue' value='"+triggerTimeDiffValue+"'><input type='hidden' name='triggerTimeDiffText' value='"+triggerTimeDiffText+"'>";
      else  if (i==5) oDiv.innerHTML=triggerOperationDiffText+"<input type='hidden' name='triggerOperationDiffValue' value='"+triggerOperationDiffValue+"'><input type='hidden' name='triggerOperationDiffText' value='"+triggerOperationDiffText+"'>";
      else  if (i==6) oDiv.innerHTML=fieldNameDiffText+"<input type='hidden' name='fieldIdDiffValue' value='"+fieldIdDiffValue+"'><input type='hidden' name='fieldNameDiffText' value='"+fieldNameDiffText+"'>"; 
      else  if (i==7) oDiv.innerHTML="<span id=detailLinkDiffSpan><a href='#'><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage())%></a></span>";

      jQuery(oCell).append(oDiv);

   }
    WorkflowSubwfSetUtil.addWorkflowSubwfSetDiff(mainWorkflowId,triggerNodeIdDiffValue,triggerTypeDiffValue,triggerTimeDiffValue,triggerOperationDiffValue,fieldIdDiffValue,oRowIndex,returnWorkflowTriDiffWfDiffFieldId);
}

function onSaveWorkflowTriDiffWfSubWf(obj){
	subWorkflowIdDefault=$G("subWorkflowIdDefault").value;
	if("" == subWorkflowIdDefault || null == subWorkflowIdDefault|| subWorkflowIdDefault == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
		return;
	}

	obj.disabled=true;
	doPost(formWorkflowTriDiffWfSubWf,tab0002);	
}

function triDiffWfSubWfFieldConfig(talID, triDiffWfDiffFieldId,triDiffWfSubWfId,fieldValue, subWorkflowId, isRead,mainWorkflowId){
	if("" == subWorkflowId || null == subWorkflowId|| subWorkflowId == 0){
		alert("<%=SystemEnv.getHtmlLabelName(21601, user.getLanguage())%>");
		return;
	}
	doGet(talID, "/workflow/workflow/WorkflowTriDiffWfSubWfField.jsp?ajax=1&triDiffWfDiffFieldId="+triDiffWfDiffFieldId+"&triDiffWfSubWfId="+triDiffWfSubWfId+"&fieldValue="+fieldValue+"&subWorkflowId="+subWorkflowId+"&isRead="+isRead+"&mainWorkflowId="+mainWorkflowId);
}


function changeIsCreateDocAgain(obj,divNamePart,fieldIdSplited){

    var objId=$(obj).attr("id");
    var objValue=$(obj).val();

    var divName=divNamePart+objId.substr(objId.lastIndexOf("_")+1)
    var spanName="span"+divNamePart+objId.substr(objId.lastIndexOf("_")+1);

    var objHtmlType=objValue.substring(0,objValue.indexOf("_"));
    var objType=objValue.substring(objValue.indexOf("_")+1,objValue.lastIndexOf("_"));
    var objFieldId=objValue.substring(objValue.lastIndexOf("_")+1);

    var objChkIsCreateDocAgain=$(obj).parent().next().find("input")[0];
    
    if((objHtmlType=='3'&&(objType=='9'||objType=='37'))||objHtmlType=='6'){

		if(objHtmlType=='6'){
			$G(spanName).innerHTML="<%=SystemEnv.getHtmlLabelName(21719, user.getLanguage())%>";
		}else{
			$G(spanName).innerHTML="<%=SystemEnv.getHtmlLabelName(21718, user.getLanguage())%>";
		}
		$("#"+divName).show();
        objChkIsCreateDocAgain.value='1'
        objChkIsCreateDocAgain.checked=false        
    }else{
        $("#"+divName).hide();
        objChkIsCreateDocAgain.value='1'
        objChkIsCreateDocAgain.checked=false    
    }

	if(fieldIdSplited>0){
		var divIfSplitFieldName="divIfSplitField_"+objId.substr(objId.lastIndexOf("_")+1);
        var objChkIfSplitField=obj.parentNode.nextSibling.nextSibling.children(0).children(0);

		if(fieldIdSplited==objFieldId){
            $GetEle(divIfSplitFieldName).style.display=""
            objChkIfSplitField.value='1'
            objChkIfSplitField.checked=false
		}else{
            $GetEle(divIfSplitFieldName).style.display="none"
            objChkIfSplitField.value='1'
            objChkIfSplitField.checked=false 
		}
	}

}
function rejectremindChange(obj,tdname){
    if(obj.checked){
        $GetEle(tdname).disabled=false;
    }else{
        $GetEle(tdname).checked=false;
        $GetEle(tdname).disabled=true;
    }
} 
</script>
<!--流程编码-->
<SCRIPT LANGUAGE="JavaScript">
<!--
var colors= new Array ("#6633CC","#FF33CC","#666633","#CC00FF","#996666");

function checkValueCodeSeqSet() {
	var dateSeqAlone=formCodeSeqSet.dateSeqAlone.value;
	var dateSeqSelect=formCodeSeqSet.dateSeqSelect.value;

	if(dateSeqAlone==1){
		if(dateSeqSelect==1){
			if(!check_form(formCodeSeqSet,"yearIdBeginCodeSeqSet,yearIdEndCodeSeqSet")) return false ;
			if(formCodeSeqSet.yearIdBeginCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25, user.getLanguage())%>");
				return false;
			}
			if(formCodeSeqSet.yearIdEndCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25, user.getLanguage())%>");
				return false;
			}
			if(formCodeSeqSet.yearIdBeginCodeSeqSet.value>formCodeSeqSet.yearIdEndCodeSeqSet.value){
				alert("<%=SystemEnv.getHtmlLabelName(21190, user.getLanguage())%>");
				return false;
			}
		}else if(dateSeqSelect==2){
			if(!check_form(formCodeSeqSet,"yearIdCodeSeqSet")) return false ;
			if(formCodeSeqSet.yearIdCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25, user.getLanguage())%>");
				return false;
			}
			monthIdBeginCodeSeqSet=parseInt(formCodeSeqSet.monthIdBeginCodeSeqSet.value);
			monthIdEndCodeSeqSet=parseInt(formCodeSeqSet.monthIdEndCodeSeqSet.value);
			if(monthIdBeginCodeSeqSet>monthIdEndCodeSeqSet){
				alert("<%=SystemEnv.getHtmlLabelName(21191, user.getLanguage())%>");
				return false;
			}
		}else if(dateSeqSelect==3){
			if(!check_form(formCodeSeqSet,"yearIdCodeSeqSet")) return false ;
			if(formCodeSeqSet.yearIdCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25, user.getLanguage())%>");
				return false;
			}
			dateIdBeginCodeSeqSet=parseInt(formCodeSeqSet.dateIdBeginCodeSeqSet.value);
			dateIdEndCodeSeqSet=parseInt(formCodeSeqSet.dateIdEndCodeSeqSet.value);
			if(dateIdBeginCodeSeqSet>dateIdEndCodeSeqSet){
				alert("<%=SystemEnv.getHtmlLabelName(16721, user.getLanguage())%>");
				return false;
			}
		}
	}
	return true ;
}

function onChangeYearOrMonth(){
	var yearIdObj=formCodeSeqSet.yearIdCodeSeqSet;
	var monthIdObj=formCodeSeqSet.monthIdCodeSeqSet;
	var dateIdBeginObj=formCodeSeqSet.dateIdBeginCodeSeqSet;
	var dateIdEndObj=formCodeSeqSet.dateIdEndCodeSeqSet;

    var yearId=yearIdObj.value;
	var monthId=monthIdObj.value;

    if(yearId.length != 4 ) {
		alert("<%=SystemEnv.getHtmlNoteName(25, user.getLanguage())%>");
		yearIdObj.focus(); 
		return;
    }

	//每个月的初始天数
	var MonDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

	var n = MonDays[monthId - 1];
	if ( monthId ==2 && isLeapYear(yearId)){
		n++;
	}

	createDayCodeSeqSet(n,dateIdBeginObj);
	createDayCodeSeqSet(n,dateIdEndObj);
}

function linkagevaaddrow(nodeids,nodenames,selectfieldids,selectfieldnames,selectvalues,selectvaluenames){
    var nodeidarray=nodeids.split(",");
    var nodenamearray=nodenames.split(",");
    var selectfieldidarray=selectfieldids.split(",");
    var selectfieldnamearray=selectfieldnames.split(",");
    var selectvaluearray=selectvalues.split(",");
    var selectvaluenamearray=selectvaluenames.split(",");
    var oTable=$GetEle('lavaoTable');
    var curindex=parseInt($GetEle('linkage_rownum').value);
    var rowindex=parseInt($GetEle('linkage_indexnum').value);
    var ncol = 6;
    var oRow = oTable.insertRow(-1);
    for(j=0; j<ncol; j++) {
        var oCell = oRow.insertCell(-1);
		oCell.style.height = 24;
		oCell.style.background= "#E7E7E7";
		switch(j) {
            case 0:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<input type='checkbox' class=inputstyle name='check_node' value='"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
                jQuery(oCell).append(oDiv);
                break;
            }
            case 1:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='nodeid_"+rowindex+"' onchange='lavachangenode(this.value,"+rowindex+")'>"
                for(i=0;i<nodeidarray.length;i++){
                    sHtml+="<option value='"+nodeidarray[i]+"'>"+nodenamearray[i]+"</option>";
                }
                sHtml+="</select><span id='nodeid_"+rowindex+"span'>";
                if(nodeids==""){
                    sHtml+="<IMG src='/images/BacoError.gif' align=absMiddle>";
                }
                sHtml+="</span>";
                oDiv.innerHTML = sHtml;
                jQuery(oCell).append(oDiv);
                break;
            }
            case 2:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='selectfieldid_"+rowindex+"' onchange='lavachangefield(this.value,"+rowindex+")'>";
                for(i=0;i<selectfieldidarray.length;i++){
                    sHtml+="<option value='"+selectfieldidarray[i]+"'>"+selectfieldnamearray[i]+"</option>";
                }
                sHtml+="</select><span id='selectfieldid_"+rowindex+"span'>";
                if(selectfieldids==""){
                    sHtml+="<IMG src='/images/BacoError.gif' align=absMiddle>";
                }
                sHtml+="</span>";
                oDiv.innerHTML = sHtml
                jQuery(oCell).append(oDiv);
                break;
            }
            case 3:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='selectfieldvalue_"+rowindex+"'>";
                for(i=0;i<selectvaluearray.length;i++){
                    sHtml+="<option value='"+selectvaluearray[i]+"'>"+selectvaluenamearray[i]+"</option>";
                }
                sHtml+="</select><span id='selectfieldvalue_"+rowindex+"span'>";
                if(selectvalues==""){
                    sHtml+="<IMG src='/images/BacoError.gif' align=absMiddle>";
                }
                sHtml+="</span>";
                oDiv.innerHTML = sHtml;
                jQuery(oCell).append(oDiv);
                break;
            }
            case 4:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<button type='button' class=Browser onclick='lavaShowMultiField(\"changefieldidsspan_"+rowindex+"\",\"changefieldids_"+
                            rowindex+"\",nodeid_"+rowindex+".value,selectfieldid_"+rowindex+".value)'></button><SPAN id='changefieldidsspan_"+rowindex+
                            "'><IMG src='/images/BacoError.gif' align=absMiddle></SPAN><input type='hidden' class=inputstyle name='changefieldids_"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
                jQuery(oCell).append(oDiv);
                break;
            }
            case 5:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='viewattr_"+rowindex+"'>";
                sHtml+="<option value=2><%=SystemEnv.getHtmlLabelName(18019, user.getLanguage())%></option> ";
                sHtml+="<option value=1><%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%></option>";
                sHtml+="</select>";
                oDiv.innerHTML = sHtml;
                jQuery(oCell).append(oDiv);
                break;
            }
        }
    }
    $GetEle('checkfield').value = $GetEle('checkfield').value+"nodeid_"+rowindex+",selectfieldid_"+rowindex+",selectfieldvalue_"+rowindex+",changefieldids_"+rowindex+",";
    $GetEle("linkage_rownum").value = curindex+1 ;
    $GetEle('linkage_indexnum').value = rowindex+1;
}
function linkagevadelrow(){
    var oTable=$GetEle('lavaoTable');
    curindex=parseInt($GetEle("linkage_rownum").value);
    len = document.frmlinkageviewattr.elements.length;
    var i=0;
    var rowsum1 = 0;
    var delsum=0;
    for(i=len-1; i >= 0;i--) {
        if (document.frmlinkageviewattr.elements[i].name=='check_node'){
            rowsum1 += 1;
            if(document.frmlinkageviewattr.elements[i].checked==true) delsum+=1;
        }
    }
    if(delsum<1){
        alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>");
    }else{
        if(confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>")){
            for(i=len-1; i >= 0;i--) {
                if (document.frmlinkageviewattr.elements[i].name=='check_node'){
                    if(document.frmlinkageviewattr.elements[i].checked==true) {
                        $GetEle('checkfield').value = ($GetEle('checkfield').value).replace("nodeid_"+document.frmlinkageviewattr.elements[i].value+",","");
                        $GetEle('checkfield').value = ($GetEle('checkfield').value).replace("selectfieldid_"+document.frmlinkageviewattr.elements[i].value+",","");
                        $GetEle('checkfield').value = ($GetEle('checkfield').value).replace("selectfieldvalue_"+document.frmlinkageviewattr.elements[i].value+",","");
                        $GetEle('checkfield').value = ($GetEle('checkfield').value).replace("changefieldids_"+document.frmlinkageviewattr.elements[i].value+",","");
                        oTable.deleteRow(rowsum1+2);
                        curindex--;
                    }
                    rowsum1 -=1;
                }

            }
            $GetEle("linkage_rownum").value=curindex;
        }

    }
}

function lavachangenode(nodeid,rownum){
    fieldsel=$GetEle("selectfieldid_"+rownum);
    fieldselspan=$GetEle("selectfieldid_"+rownum+"span");
    changefieldids=$GetEle("changefieldids_"+rownum);
    changefieldidspan=$GetEle("changefieldidsspan_"+rownum);
    clearOptionsCodeSeqSet(fieldsel);
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSelectAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("workflowid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>&languageid=<%=user.getLanguage()%>&option=selfield&nodeid="+nodeid);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            var returnvalues=ajax.responseText;
            if(returnvalues==""){
                fieldselspan.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
                fieldsel.options.add(new Option("",""));
                lavachangefield("",rownum);
            }else{
                fieldselspan.innerHTML="";

                var selefields=returnvalues.split(",");
                for(var i=0; i<selefields.length; i++){
                    var itemids=selefields[i].split("$");
                    fieldsel.options.add(new Option(itemids[1],itemids[0]));
                    if(i==0) {
                        lavachangefield(itemids[0],rownum);
                    }
                }
            }
            changefieldids.value="";
            changefieldidspan.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
            }catch(e){}
        }
    }
}
function lavachangefield(fieldid,rownum){
    fieldvaluesel=$GetEle("selectfieldvalue_"+rownum);
    fieldvalueselspan=$GetEle("selectfieldvalue_"+rownum+"span");
    changefieldids=$GetEle("changefieldids_"+rownum);
    changefieldidspan=$GetEle("changefieldidsspan_"+rownum);
    clearOptionsCodeSeqSet(fieldvaluesel);
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSelectAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("workflowid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>&languageid=<%=user.getLanguage()%>&option=selfieldvalue&fieldid="+ fieldid);
		//获取执行状态
		ajax.onreadystatechange = function() {
			//如果执行状态成功，那么就把返回信息写到指定的层里
			if (ajax.readyState == 4 && ajax.status == 200) {
				try {
					var returnvalues = ajax.responseText;
					if (returnvalues == "") {
						fieldvalueselspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
						fieldvaluesel.options.add(new Option("", ""));
					} else {
						fieldvalueselspan.innerHTML = "";
						var selefieldvalues = returnvalues.split(",");

						for ( var i = 0; i < selefieldvalues.length; i++) {
							var itemids = selefieldvalues[i].split("$");
							fieldvaluesel.options.add(new Option(itemids[1],
									itemids[0]));
						}
					}
					changefieldids.value = "";
					changefieldidspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				} catch (e) {
				}
			}
		}
	}

	function flowTitleSave2(obj) {
		var rowindex4op = "";
		var sel = document.flowTitleForm.destList;
		for ( var i = 0; i < sel.options.length; i++) {
			if (sel.options[i] != null) {
				rowindex4op += sel.options[i].value + ",";
			}
		}
		flowTitleForm.postvalues.value = rowindex4op;
		doPost(flowTitleForm, tab9);
		obj.disabled = true;
	}
	function addSrcToDestListTit() {
		destList = window.document.flowTitleForm.destList;
		srcList = window.document.flowTitleForm.srcList;
		var len = destList.length;
		for ( var i = 0; i < srcList.length; i++) {
			if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
				var found = false;
				for ( var count = 0; count < len; count++) {
					if (destList.options[count] != null) {
						if (srcList.options[i].text == destList.options[count].text) {
							found = true;
							break;
						}
					}
				}
				if (found != true) {
					destList.options[len] = new Option(srcList.options[i].text,
							srcList.options[i].value);
					len++;
				}
			}
		}
		jQuery(".vtip").simpletooltip("click");
        if($.browser.msie){
    		jQuery(".vtip").attr("title","");
    	}
	}

	function deleteFromDestListTit() {
		var destList = window.document.flowTitleForm.destList;
		var len = destList.options.length;
		for ( var i = (len - 1); i >= 0; i--) {
			if ((destList.options[i] != null)
					&& (destList.options[i].selected == true)) {
				destList.options[i] = null;
			}
		}
	}
	function ShowORHidden2(obj) {
		if (obj.checked) {
			Frequencytr.style.display = '';
			Cycletr.style.display = '';
			Frequencytrline.style.display = '';
			Cycletrline.style.display = '';
			$G('selCycle').style.display = '';
		} else {
			Frequencytr.style.display = 'none';
			Cycletr.style.display = 'none';
			Frequencytrline.style.display = 'none';
			Cycletrline.style.display = 'none';
			$G('selCycle').style.display = 'none';
		}
	}
	function docheckisvalid(obj){
		var oldisvalid = $GetEle("oldisvalid").value;
		if(obj.value=="1"){
			alert("<%=SystemEnv.getHtmlLabelName(28058,user.getLanguage())%>");
			jQuery("#isvalid").val(oldisvalid);
		}
	}


function onShowNodes4html(wfid,nodeid,inputname,spanname,selectids){
	var selectids = $GetEle(inputname).value;
	if(selectids==""){
		selectids = "0";		
	}
	var urls="/workflow/workflow/WorkFlowNodesBrowser.jsp?wfid="+wfid+"_"+nodeid+"_"+selectids;
	urls="/systeminfo/BrowserMain.jsp?url="+urls
	var id1 = window.showModalDialog(urls);
	if(id1==null){
		return;	
	}else if(id1[0]==0||id1[1]==""){
		$GetEle(inputname).value="";
		$GetEle(spanname).innerHTML="";
	}else if(id1[0]==1){
		$GetEle(inputname).value=id1[1];
		$GetEle(spanname).innerHTML=id1[2];
	}
}
function showNoSynFields(inputname, spanname){
	var oldfields = $GetEle(inputname).value;
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape("/workflow/workflow/fieldMutilBrowser.jsp?workflowid=<%=wfid%>&oldfields="+oldfields));
	if(datas != null){
		if(datas[0]!=null && datas[0]!=""){
			$GetEle(inputname).value = datas[0];
			$GetEle(spanname).innerHTML = datas[1];
		}else{
			$GetEle(inputname).value = "";
			$GetEle(spanname).innerHTML = "";
		}
	}
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
.btn_RequestSubmitList {
	BORDER-RIGHT: #7b9ebd 1px solid;
	PADDING-RIGHT: 2px;
	BORDER-TOP: #7b9ebd 1px solid;
	PADDING-LEFT: 2px;
	FONT-SIZE: 12px;
	FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0,
		StartColorStr=#ffffff, EndColorStr=#cecfde );
	BORDER-LEFT: #7b9ebd 1px solid;
	CURSOR: pointer;
	COLOR: black;
	PADDING-TOP: 2px;
	BORDER-BOTTOM: #7b9ebd 1px solid
}
</STYLE>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>

<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" src="/js/addwf.js"></script>