<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.system.code.CodeBuild" %>
<%@ page import="weaver.system.code.CoderBean" %>
<jsp:useBean id="workflowJspBean" class="weaver.workflow.request.WorkflowJspBean" scope="page"/>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<%
	HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息
%>
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for @td2977 20051111-->
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="flowDoc1" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="docReceiveUnitComInfo_mba" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>
 -->
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>

<%
	String selectInitJsStr = "";
	String initIframeStr = "";
	char flag = Util.getSeparator();
	String docfileid = Util.null2String(request
			.getParameter("docfileid")); // 新建文档的工作流字段

	String topage = Util.null2String(request.getParameter("topage"));
	String newfromdate = "a";
	String newenddate = "b";
	int requestid = Util.getIntValue(request.getParameter("requestid"),
			0);
	String nodetype = Util
			.null2String(request.getParameter("nodetype"));
	int isremark = Util
			.getIntValue(request.getParameter("isremark"), 0); //当前操作状态
	String userid = Util.null2String(request.getParameter("userid"));
	String needcheck = Util.null2String(request
			.getParameter("needcheck"));

	String workflowtype = Util.null2String(request
			.getParameter("workflowtype"));

	int workflowid = Util.getIntValue(request
			.getParameter("workflowid"));
	String workflowname = Util.null2String((String) session
			.getAttribute(userid + "_" + requestid + "workflowname"));//update by fanggsh 20060509 TD4294
	String fromFlowDoc = Util.null2String(request
			.getParameter("fromFlowDoc")); //是否从流程创建文档而来
	int languageidfromrequest = Util.getIntValue(request
			.getParameter("languageid"));

	boolean canactive = Util.null2String(
			request.getParameter("canactive")).equalsIgnoreCase("true");
	int deleted = Util.getIntValue(request.getParameter("deleted"), 0); //请求是否删除  1:是 0或者其它 否
	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	String sql = "";
	String bodychangattrstr = "";

	//String requestname = Util.null2String(request.getParameter("requestname"));//update by fanggsh 20060509 TD4294
	String requestname = Util.null2String((String) session
			.getAttribute(userid + "_" + requestid + "requestname"));//update by fanggsh 20060509 TD4294
	String requestlevel = Util.null2String(request
			.getParameter("requestlevel"));

	String isbill = Util.null2String(request.getParameter("isbill"));
	int billid = Util.getIntValue(request.getParameter("billid"), 0);

	int formid = Util.getIntValue(request.getParameter("formid"), 0);

	boolean isprint = Util.null2String(request.getParameter("isprint"))
			.equalsIgnoreCase("true");
	boolean isurger = Util.null2String(request.getParameter("isurger"))
			.equalsIgnoreCase("true");
	boolean wfmonitor = Util.null2String(
			request.getParameter("wfmonitor")).equalsIgnoreCase("true");
	String isrequest = Util.null2String(request
			.getParameter("isrequest"));

	ArrayList flowDocs = flowDoc1.getDocFiled("" + workflowid); //得到流程建文挡的发文号字段
	String codeField = "";
	String flowCat="";
	if (flowDocs != null && flowDocs.size() > 0) {
		codeField = "" + flowDocs.get(0);
		flowCat=""+flowDocs.get(3);	//取得流程中“显示目录”字段ID	
	}
	String docFlags = Util.null2String((String) session
			.getAttribute("requestAdd" + requestid));
	String newTNflag = Util.null2String((String) session
			.getAttribute("requestAddNewNodes" + user.getUID()));
	String flowDocField = Util.null2String((String) session
			.getAttribute("requestFlowDocField" + user.getUID()));
	ArrayList managefckfields_body = new ArrayList();
	if (docFlags.equals(""))
		docFlags = Util.null2String((String) session
				.getAttribute("requestAdd" + user.getUID()));
%>
<!--请求的标题开始 -->
<div align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname, user.getLanguage())%></font>
</div>
<title><%=Util.toScreen(workflowname, user.getLanguage())%></title>

<!--请求的标题结束 -->
<%
	int creater = Util.getIntValue(request.getParameter("creater"), 0);
	int creatertype = Util.getIntValue(request
			.getParameter("creatertype"), 0);
	String currentdate = Util.null2String(request
			.getParameter("currentdate"));
	String currenttime = Util.null2String(request
			.getParameter("currenttime"));

	CodeBuild cbuild = new CodeBuild(formid, isbill, workflowid,
			creater, creatertype);
	CoderBean cb = cbuild.getFlowCBuild();
	String isUse = cb.getUserUse(); //是否使用流程编号
	String fieldCode = Util.null2String(cb.getCodeFieldId());
	ArrayList memberList = cb.getMemberList();
	boolean hasHistoryCode = cbuild.hasHistoryCode(RecordSet_nf2,
			workflowid);
	int fieldIdSelect = -1;
	int departmentFieldId = -1;
	int subCompanyFieldId = -1;
	int supSubCompanyFieldId = -1;
	int yearFieldId = -1;
	String yearFieldHtmlType = "";
	int monthFieldId = -1;
	int dateFieldId = -1;

	for (int i = 0; i < memberList.size(); i++) {
		String[] codeMembers = (String[]) memberList.get(i);
		String codeMemberName = codeMembers[0];
		String codeMemberValue = codeMembers[1];
		if ("22755".equals(codeMemberName)) {
			fieldIdSelect = Util.getIntValue(codeMemberValue, -1);
		} else if ("22753".equals(codeMemberName)) {
			supSubCompanyFieldId = Util
					.getIntValue(codeMemberValue, -1);
		} else if ("141".equals(codeMemberName)) {
			subCompanyFieldId = Util.getIntValue(codeMemberValue, -1);
		} else if ("124".equals(codeMemberName)) {
			departmentFieldId = Util.getIntValue(codeMemberValue, -1);
		} else if ("445".equals(codeMemberName)) {
			yearFieldId = Util.getIntValue(codeMemberValue, -1);
		} else if ("6076".equals(codeMemberName)) {
			monthFieldId = Util.getIntValue(codeMemberValue, -1);
		} else if ("390".equals(codeMemberName)
				|| "16889".equals(codeMemberName)) {
			dateFieldId = Util.getIntValue(codeMemberValue, -1);
		}
	}
%>

<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<br>
<input type="hidden" name="htmlfieldids">

<%
	String isaffirmancebody = Util.null2String((String) session
			.getAttribute(user.getUID() + "_" + requestid
					+ "isaffirmance"));//是否需要提交确认
	String reEditbody = Util.null2String((String) session
			.getAttribute(user.getUID() + "_" + requestid + "reEdit"));//是否需要提交确认
	int rqMessageType = -1;
	int wfMessageType = -1;
	String docCategory = "";
	//String sqlWfMessage = "select a.messagetype,b.docCategory from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
	String sqlWfMessage = "select a.messagetype,b.docCategory,b.messagetype as wfMessageType from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="
			+ requestid;
	RecordSet.executeSql(sqlWfMessage);
	if (RecordSet.next()) {
		rqMessageType = RecordSet.getInt("messagetype");
		wfMessageType = RecordSet.getInt("wfMessageType");
		docCategory = RecordSet.getString("docCategory");
	}
	Map secMaxUploads = new HashMap();//封装选择目录的信息
	int secid = Util.getIntValue(docCategory.substring(docCategory
			.lastIndexOf(",") + 1), -1);
	int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1
			.getMaxUploadFileSize("" + secid), 5); //从缓存中取
	if (maxUploadImageSize <= 0) {
		maxUploadImageSize = 5;
	}
	int uploadType = 0;
	String selectedfieldid = "";
	String result = RequestManager.getUpLoadTypeForSelect(workflowid);
	if (!result.equals("")) {
		selectedfieldid = result.substring(0, result.indexOf(","));
		uploadType = Integer.valueOf(
				result.substring(result.indexOf(",") + 1)).intValue();
	}
	boolean isCanuse = RequestManager.hasUsedType(workflowid);
	if (selectedfieldid.equals("") || selectedfieldid.equals("0")) {
		isCanuse = false;
	}
	//如果附件存放方式为选择目录，则重置默认值
	if (uploadType == 1) {
		maxUploadImageSize = 5;
	}
	String keywordismand = "0";
	String keywordisedit = "0";
	int titleFieldId = 0;
	int keywordFieldId = 0;
	String canDelAcc = "";
	String forbidAttDownload="";
	RecordSet
			.execute("select titleFieldId,keywordFieldId,candelacc,forbidAttDownload from workflow_base where id="
					+ workflowid);
	if (RecordSet.next()) {
		titleFieldId = Util.getIntValue(RecordSet
				.getString("titleFieldId"), 0);
		keywordFieldId = Util.getIntValue(RecordSet
				.getString("keywordFieldId"), 0);
		canDelAcc = Util.null2String(RecordSet.getString("candelacc"));
		forbidAttDownload = Util.null2String(RecordSet.getString("forbidAttDownload"));
	}
	ArrayList selfieldsadd = WfLinkageInfo.getSelectField(workflowid,
			nodeid, 0);
	ArrayList changefieldsadd = WfLinkageInfo.getChangeField(
			workflowid, nodeid, 0);
	Map secCategorys = new HashMap();
	ArrayList uploadfieldids = new ArrayList();
%>

<table class="ViewForm">
  <colgroup>
  <col width="20%">
  <col width="80%">

  <%
  	//xwj for td1834 on 2005-05-22
  	String isEdit_ = "-1";
  	RecordSet
  			.executeSql("select isedit from workflow_nodeform where nodeid = "
  					+ String.valueOf(nodeid) + " and fieldid = -1");
  	if (RecordSet.next()) {
  		isEdit_ = Util.null2String(RecordSet.getString("isedit"));
  	}

  	//获得触发字段名 mackjoe 2005-07-22
  	DynamicDataInput ddi = new DynamicDataInput(workflowid + "");
  	String trrigerfield = ddi.GetEntryTriggerFieldName();
  %>

  <!--新建的第一行，包括说明和重要性 -->
  <tr class="Spacing" style="height:1px;">
    <td class="Line1" colSpan=2></td>
  </tr>
  <%
  	boolean editflag = true;//流程的处理人可以编辑流程的优先级和是否短信提醒
  	if (isremark == 1 || isremark == 8 || isremark == 9
  			|| isremark == 7)
  		editflag = false;//被转发人或被抄送人不能编辑
  	String requestlevel_disabled = "disabled";

  	WFNodeFieldMainManager.resetParameter();
  	WFNodeFieldMainManager.setNodeid(nodeid);
  	WFNodeFieldMainManager.setFieldid(-2);//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
  	WFNodeFieldMainManager.selectWfNodeField();
  	if (WFNodeFieldMainManager.getIsedit().equals("1")
  			|| "0".equals(nodetype))
  		requestlevel_disabled = "";
  	WFNodeFieldMainManager.closeStatement();

  	String messageType_disabled = "disabled";
  	WFNodeFieldMainManager.resetParameter();
  	WFNodeFieldMainManager.setNodeid(nodeid);
  	WFNodeFieldMainManager.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
  	WFNodeFieldMainManager.selectWfNodeField();
  	if (WFNodeFieldMainManager.getIsedit().equals("1")
  			|| "0".equals(nodetype))
  		messageType_disabled = "";
  %>

<jsp:include page="WorkflowManageRequestBodyActionTitle.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="editflag" value="<%=editflag%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
	<jsp:param name="isaffirmancebody" value="<%=isaffirmancebody%>" />
	<jsp:param name="reEditbody" value="<%=reEditbody%>" />
	<jsp:param name="isEdit_" value="<%=isEdit_%>" />
	<jsp:param name="rqMessageType" value="<%=rqMessageType%>" />
	<jsp:param name="messageType_disabled" value="<%=messageType_disabled%>" />
	<jsp:param name="wfMessageType" value="<%=wfMessageType%>" />
	<jsp:param name="requestlevel" value="<%=requestlevel%>" />
	<jsp:param name="requestlevel_disabled" value="<%=requestlevel_disabled%>" />
	<jsp:param name="RequestName_Size" value="<%=RequestConstants.RequestName_Size%>" />
	<jsp:param name="RequestName_MaxLength" value="<%=RequestConstants.RequestName_MaxLength%>" />
</jsp:include>

<%
	boolean IsCanModify = "true".equals(session.getAttribute(userid
			+ "_" + requestid + "IsCanModify")) ? true : false;
	boolean editbodyactionflag = false;
	if ((isremark == 0 || IsCanModify)
			&& (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody
					.equals("1")))
		editbodyactionflag = true;
	//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）
	String newdocid = Util.null2String((String) session
			.getAttribute(userid + "_" + requestid + "newdocid"));
	ArrayList fieldids = new ArrayList(); //字段队列
	ArrayList fieldorders = new ArrayList(); //字段显示顺序队列 (单据文件不需要)
	ArrayList languageids = new ArrayList(); //字段显示的语言(单据文件不需要)
	ArrayList fieldlabels = new ArrayList(); //单据的字段的label队列
	ArrayList fieldhtmltypes = new ArrayList(); //单据的字段的html type队列
	ArrayList fieldtypes = new ArrayList(); //单据的字段的type队列
	ArrayList fieldnames = new ArrayList(); //单据的字段的表字段名队列
	ArrayList fieldvalues = new ArrayList(); //字段的值
	ArrayList fieldviewtypes = new ArrayList(); //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
	ArrayList fieldimgwidths = new ArrayList();
	ArrayList fieldimgheights = new ArrayList();
	ArrayList fieldimgnums = new ArrayList();
	int fieldlen = 0; //字段类型长度
	ArrayList fieldrealtype = new ArrayList();
	String fielddbtype = ""; //字段数据类型
	String textheight = "4";//xwj for @td2977 20051111

	if (isbill.equals("0")) {
		RecordSet
				.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null) and   t1.langurageid="
						+ user.getLanguage()
						+ " and t2.formid="
						+ formid + " order by t2.fieldorder");
		while (RecordSet.next()) {
			fieldids.add(Util.null2String(RecordSet
					.getString("fieldid")));
			fieldorders.add(Util.null2String(RecordSet
					.getString("fieldorder")));
			fieldlabels.add(Util.null2String(RecordSet
					.getString("fieldlable")));
			languageids.add(Util.null2String(RecordSet
					.getString("langurageid")));
		}
	} else {
		RecordSet.executeProc("workflow_billfield_Select", formid + "");
		while (RecordSet.next()) {
			fieldids.add(Util.null2String(RecordSet.getString("id")));
			fieldlabels.add(Util.null2String(RecordSet
					.getString("fieldlabel")));
			fieldhtmltypes.add(Util.null2String(RecordSet
					.getString("fieldhtmltype")));
			fieldtypes.add(Util
					.null2String(RecordSet.getString("type")));
			fieldnames.add(Util.null2String(RecordSet
					.getString("fieldname")));
			fieldviewtypes.add(Util.null2String(RecordSet
					.getString("viewtype")));
			fieldrealtype.add(Util.null2String(RecordSet
					.getString("fielddbtype")));
			fieldimgwidths.add(Util.null2String(RecordSet
					.getString("imgwidth")));
			fieldimgheights.add(Util.null2String(RecordSet
					.getString("imgheight")));
			fieldimgnums.add(Util.null2String(RecordSet
					.getString("textheight")));
		}
	}

	// 查询每一个字段的值
	if (!isbill.equals("1")) {
		RecordSet.executeProc("workflow_FieldValue_Select", requestid
				+ ""); // 从workflow_form表中查
		RecordSet.next();
		for (int i = 0; i < fieldids.size(); i++) {
			String fieldname = FieldComInfo
					.getFieldname((String) fieldids.get(i));
			fieldvalues.add(Util.null2String(RecordSet
					.getString(fieldname)));
		}
	} else {
		RecordSet
				.executeSql("select tablename from workflow_bill where id = "
						+ formid); // 查询工作流单据表的信息
		RecordSet.next();
		String tablename = RecordSet.getString("tablename");
		RecordSet.executeSql("select * from " + tablename
				+ " where id = " + billid); // 对于默认的单据表,必须以id作为自增长的Primary key, billid的值就是id. 如果不是,则需要改写这个部分. 另外,默认的单据表必须有 requestid 的字段

		RecordSet.next();
		for (int i = 0; i < fieldids.size(); i++) {
			String fieldname = (String) fieldnames.get(i);
			fieldvalues.add(Util.null2String(RecordSet
					.getString(fieldname)));
		}
	}

	// 确定字段是否显示，是否可以编辑，是否必须输入
	ArrayList isfieldids = new ArrayList(); //字段队列
	ArrayList isviews = new ArrayList(); //字段是否显示队列
	ArrayList isedits = new ArrayList(); //字段是否可以编辑队列
	ArrayList ismands = new ArrayList(); //字段是否必须输入队列

	RecordSet.executeProc("workflow_FieldForm_Select", nodeid + "");
	while (RecordSet.next()) {
		isfieldids
				.add(Util.null2String(RecordSet.getString("fieldid")));
		isviews.add(Util.null2String(RecordSet.getString("isview")));
		isedits.add(Util.null2String(RecordSet.getString("isedit")));
		ismands.add(Util
				.null2String(RecordSet.getString("ismandatory")));
	}

	String beagenter = "" + userid;
	//获得被代理人
	RecordSet
			.executeSql("select agentorbyagentid from workflow_currentoperator where usertype=0 and isremark='0' and requestid="
					+ requestid
					+ " and userid="
					+ userid
					+ " and nodeid=" + nodeid + " order by id desc");
	if (RecordSet.next()) {
		int tembeagenter = RecordSet.getInt(1);
		if (tembeagenter > 0)
			beagenter = "" + tembeagenter;
	}
	session.removeAttribute("beagenter_"+user.getUID());
	session.setAttribute("beagenter_"+user.getUID(), beagenter);
	// 得到每个字段的信息并在页面显示

	for (int i = 0; i < fieldids.size(); i++) { // 循环开始
		int tmpindex = i;
		if (isbill.equals("0"))
			tmpindex = fieldorders.indexOf("" + i); // 如果是表单, 得到表单顺序对应的 i

		String fieldid = (String) fieldids.get(tmpindex); //字段id

		if (isbill.equals("1")) {
			String viewtype = (String) fieldviewtypes.get(tmpindex); // 如果是单据的从表字段,不显示
			if (viewtype.equals("1"))
				continue;
		}

		String isview = "0"; //字段是否显示
		String isedit = "0"; //字段是否可以编辑
		String ismand = "0"; //字段是否必须输入

		int isfieldidindex = isfieldids.indexOf(fieldid);
		if (isfieldidindex != -1) {
			isview = (String) isviews.get(isfieldidindex); //字段是否显示
			isedit = (String) isedits.get(isfieldidindex); //字段是否可以编辑
			ismand = (String) ismands.get(isfieldidindex); //字段是否必须输入
		}
		if (isremark == 5 || isremark == 9) {
			isedit = "0";//抄送(需提交)不可编辑
			ismand = "0";
		}
		String fieldname = ""; //字段数据库表中的字段名
		String fieldhtmltype = ""; //字段的页面类型
		String fieldtype = ""; //字段的类型
		String fieldlable = ""; //字段显示名
		int fieldimgwidth = 0; //图片字段宽度
		int fieldimgheight = 0; //图片字段高度
		int fieldimgnum = 0; //每行显示图片个数
		int languageid = 0;

		if (isbill.equals("0")) {
			languageid = Util.getIntValue((String) languageids
					.get(tmpindex), 0); //需要更新
			fieldhtmltype = FieldComInfo.getFieldhtmltype(fieldid);
			fieldtype = FieldComInfo.getFieldType(fieldid);
			fieldlable = (String) fieldlabels.get(tmpindex);
			fieldname = FieldComInfo.getFieldname(fieldid);
			fielddbtype = FieldComInfo.getFielddbtype(fieldid);
			fieldimgwidth = FieldComInfo.getImgWidth(fieldid);
			fieldimgheight = FieldComInfo.getImgHeight(fieldid);
			fieldimgnum = FieldComInfo.getImgNumPreRow(fieldid);
		} else {
			languageid = user.getLanguage();
			fieldname = (String) fieldnames.get(tmpindex);
			fieldhtmltype = (String) fieldhtmltypes.get(tmpindex);
			fieldtype = (String) fieldtypes.get(tmpindex);
			fielddbtype = (String) fieldrealtype.get(tmpindex);
			fieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue(
					(String) fieldlabels.get(tmpindex), 0), languageid);
			fieldimgwidth = Util.getIntValue((String) fieldimgwidths
					.get(tmpindex), 0);
			fieldimgheight = Util.getIntValue((String) fieldimgheights
					.get(tmpindex), 0);
			fieldimgnum = Util.getIntValue((String) fieldimgnums
					.get(tmpindex), 0);
		}

		String fieldvalue = (String) fieldvalues.get(tmpindex);

		fieldlen = 0;
		if ((fielddbtype.toLowerCase()).indexOf("varchar") > -1) {
			fieldlen = Util.getIntValue(fielddbtype.substring(
					fielddbtype.indexOf("(") + 1,
					fielddbtype.length() - 1));

		}
		if (fieldname.equals("manager")) {
			String tmpmanagerid = ResourceComInfo
					.getManagerID(beagenter);
%>
	<input type=hidden name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=tmpmanagerid%>">
<%
	if (isview.equals("1")) {
%> <tr>
      <td <%if (fieldhtmltype.equals("2")) {%> valign=top <%}%>> <%=Util.toScreen(fieldlable, languageid)%></td>
      <td class=field style="TEXT-VALIGN: center"><%=ResourceComInfo.getLastname(tmpmanagerid)%></td>
   </tr><tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
<%
	}
			continue;
		}

		if (fieldname.equals("begindate"))
			newfromdate = "field" + fieldid; //开始日期,主要为开始日期不大于结束日期进行比较
		if (fieldname.equals("enddate"))
			newenddate = "field" + fieldid; //结束日期,主要为开始日期不大于结束日期进行比较
		if (fieldhtmltype.equals("3") && fieldvalue.equals("0"))
			fieldvalue = "";
		//if(fieldhtmltype.equals("1") && (fieldtype.equals("2") || fieldtype.equals("3")) && Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue = "" ;
		if (("" + keywordFieldId).equals(fieldid))
			keywordismand = ismand;
		if (("" + keywordFieldId).equals(fieldid))
			keywordisedit = isedit;
		if (("" + yearFieldId).equals(fieldid)) {
			yearFieldHtmlType = fieldhtmltype;
		}

		if (ismand.equals("1") && !fieldid.equals(codeField))
			needcheck += ",field" + fieldid; //如果必须输入,加入必须输入的检查中


        if(fieldid.equals(flowCat)){
%>
	<input type=hidden name="oldfield<%=fieldid%>" id="oldfield<%=fieldid%>" value="<%=fieldvalue%>">
<%
		}
		// 下面开始逐行显示字段

		if (isview.equals("1")) { // 字段需要显示
%>
    <tr>
      <td <%if (fieldhtmltype.equals("2")) {%> valign=top <%}%>> <%=Util.toScreen(fieldlable, languageid)%></td>
      <td class=field style="word-wrap:break-word;word-break:break-all;TEXT-VALIGN: center">
      <%
      	if (fieldhtmltype.equals("1")) { // 单行文本框
      				if (fieldtype.equals("1")) { // 单行文本框中的文本
      					if (isedit.equals("1")
      							&& !fieldid.equals(codeField)
      							&& editbodyactionflag) {
      						if (keywordFieldId > 0
      								&& ("" + keywordFieldId)
      										.equals(fieldid)) {
      %>
<button type=button  class=Browser  onclick="onShowKeyword($G('field<%=fieldid%>').getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(21517,
											user.getLanguage())%>"></button>
<%
	}
						//TD18867
						String strJSChangeCode = "";
						if ("1".equals(isUse) && !hasHistoryCode
								&& fieldCode.equals(fieldid)) {
							strJSChangeCode = ";onChangeCode('"
									+ ismand + "')";
						}
						if (ismand.equals("1")) {
%>
        <input datatype="text" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,
											languageid)%>" size=50 value="<%=Util
											.toScreenForWorkflow(fieldvalue)%>" <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%> onBlur="datainput('field<%=fieldid%>');" <%}%> onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);checkLength('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,
											languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,
											user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,
											user.getLanguage())%>')<%if (titleFieldId > 0
											&& keywordFieldId > 0
											&& ("" + titleFieldId)
													.equals(fieldid)) {%>;changeKeyword()<%}%><%=strJSChangeCode%>">
        <span id="field<%=fieldid%>span"><%
        	if (fieldvalue.equals("")) {
        %><img src="/images/BacoError.gif" align=absmiddle><%
        	}
        %></span>
      <%
      	} else {
      %>
        <input datatype="text" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,
											languageid)%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);checkLength('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,
											languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,
											user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,
											user.getLanguage())%>')<%if (titleFieldId > 0
											&& keywordFieldId > 0
											&& ("" + titleFieldId)
													.equals(fieldid)) {%>;changeKeyword()<%}%><%=strJSChangeCode%>" type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%> onBlur="datainput('field<%=fieldid%>');" <%}%> value="<%=Util
											.toScreenForWorkflow(fieldvalue)%>" size=50>
        <span id="field<%=fieldid%>span"></span>
      <%
      	}
      						//流程编号  开始
      						if ("1".equals(isUse) && !hasHistoryCode
      								&& fieldCode.equals(fieldid)) {//启用新版流程编号
      %>
                        <A href="#" onclick="onCreateCodeAgain('<%=ismand%>');return false;"><%=SystemEnv.getHtmlLabelName(22784,
											user.getLanguage())%></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
                        <A href="#" onclick="onChooseReservedCode('<%=ismand%>');return false;"><%=SystemEnv.getHtmlLabelName(22785,
											user.getLanguage())%></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
                        <A href="#" onclick="onNewReservedCode('<%=ismand%>');return false;"><%=SystemEnv.getHtmlLabelName(22783,
											user.getLanguage())%></a>
<%
	}
						//流程编号  结束
					} else {
%>
        <span id="field<%=fieldid%>span"><%=Util.toScreenForWorkflow(fieldvalue)%></span>
         <input type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=Util.toScreenForWorkflow(fieldvalue)%>" >
      <%
      	}
      					if (changefieldsadd.indexOf(fieldid) >= 0) {
      %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
										+ Util.getIntValue(isedit, 0)
										+ Util.getIntValue(ismand, 0)%>" />
<%
	}
				} else if (fieldtype.equals("2")) { // 单行文本框中的整型
					if (isedit.equals("1") && editbodyactionflag) {
						if (ismand.equals("1")) {
%>
        <input datatype="int" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,
											languageid)%>" size=20 value="<%=fieldvalue%>"
		onKeyPress="ItemCount_KeyPress()" <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>  onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);datainput('field<%=fieldid%>')" <%} else {%> onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);" <%}%>>
        <span id="field<%=fieldid%>span"><%
        	if (fieldvalue.equals("")) {
        %><img src="/images/BacoError.gif" align=absmiddle><%
        	}
        %></span>
       <%
       	} else {
       %>
       <!-- 单行文本-整数  再此行添加 onkeyup onafterpaste style="ime-mode:disabled" ypc  2012-09-04 添加 -->
        <input datatype="int" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" 
        type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" size=20 
         onafterpaste="if(isNaN(value))execCommand('undo')"  style="ime-mode:disabled"
        value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()"  
        <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>  onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);datainput('field<%=fieldid%>')" <%} else {%> onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);" <%}%>>
        <span id="field<%=fieldid%>span"></span>
       <%
       	}
       	if (changefieldsadd.indexOf(fieldid) >= 0) {
       %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
											+ Util.getIntValue(isedit, 0)
											+ Util.getIntValue(ismand, 0)%>" />
<%
	}
					} else {
%>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="int" type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
      	}
      				} else if (fieldtype.equals("3")
      						|| fieldtype.equals("5")) { // 单行文本框中的浮点型
      					int decimaldigits_t = 2;
      					if (fieldtype.equals("3")) {
      						int digitsIndex = fielddbtype.indexOf(",");
      						if (digitsIndex > -1) {
      							decimaldigits_t = Util.getIntValue(
      									fielddbtype.substring(
      											digitsIndex + 1,
      											fielddbtype.length() - 1),
      									2);
      						} else {
      							decimaldigits_t = 2;
      						}
      					}
      					if (isedit.equals("1") && editbodyactionflag) {
      						if (ismand.equals("1")) {
      %>
        <input datatype="float" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" size=20 value="<%=fieldvalue%>"
       onKeyPress="ItemDecimal_KeyPress('field<%=fieldid%>',15,<%=decimaldigits_t%>)" <%if (fieldtype.equals("5")) {%>onfocus="changeToNormalFormat('field<%=fieldid%>')"<%}%> <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>  onBlur="checkFloat(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);datainput('field<%=fieldid%>');<%if (fieldtype.equals("5")) {%>changeToThousands('field<%=fieldid%>')<%}%>" <%} else {%> onBlur="checkFloat(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);<%if (fieldtype.equals("5")) {%>changeToThousands('field<%=fieldid%>')<%}%>" <%}%>>
        <span id="field<%=fieldid%>span"><%
        	if (fieldvalue.equals("")) {
        %><img src="/images/BacoError.gif" align=absmiddle><%
        	}
        %></span>
       <%
       	} else {
       %>
       	<!-- 单行文本-浮点数 和金额千分位  style="ime-mode:disabled" onkeyup  onafterpaste ypc  2012-09-04 添加  start-->
        <input datatype="float" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>"
         type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" size=20 
         style="ime-mode:disabled"  onafterpaste="if(isNaN(value))execCommand('undo')"
         value="<%=fieldvalue%>" onKeyPress="ItemDecimal_KeyPress('field<%=fieldid%>',15,<%=decimaldigits_t%>)" <%if (fieldtype.equals("5")) {%>onfocus="changeToNormalFormat('field<%=fieldid%>')"<%}%> <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>  onBlur="checkFloat(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);datainput('field<%=fieldid%>');<%if (fieldtype.equals("5")) {%>changeToThousands('field<%=fieldid%>')<%}%>" <%} else {%> onBlur="checkFloat(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);<%if (fieldtype.equals("5")) {%>changeToThousands('field<%=fieldid%>')<%}%>" <%}%>>
        <span id="field<%=fieldid%>span"></span>
       <%
       	}
       						if (changefieldsadd.indexOf(fieldid) >= 0) {
       %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
											+ Util.getIntValue(isedit, 0)
											+ Util.getIntValue(ismand, 0)%>" />
<%
	}
					} else {
%>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
      	}
      				}
      				/*------------- xwj for td3131 20051116 begin----------*/
      				else if (fieldtype.equals("4")) { // 单行文本框中的金额转换
      %>
            <table cols=2 id="field<%=fieldid%>_tab">
                <tr><td>
                <%
                	if (isedit.equals("1") && editbodyactionflag) {
                						if (ismand.equals("1")) {
                %>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,
											languageid)%>" size=60
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')"
                            <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',$G('field<%=fieldid%>').getAttribute('viewtype'));
                                datainput('field_lable<%=fieldid%>')"
                            <%} else {%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',$G('field<%=fieldid%>').getAttribute('viewtype'))"
                            <%}%>
                        >
                    <span id="field_lable<%=fieldid%>span"><%
                    	if (fieldvalue.equals("")) {
                    %><img src="/images/BacoError.gif" align=absmiddle><%
                    	}
                    %></span>
                    <%
                    	} else {
                    %>
                    	<!-- 把  onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')替换掉 onkeydown="clearNoNum(this)" ypc 2012-09-04 添加-->
                        <!--  onkeydown="clearNoNum(this)" 2012-09-06 ypc 修改 成onKeyPress() -->
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" id="field_lable<%=fieldid%>" size=60
                          onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')"
                            style="ime-mode:disabled"
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',$G('field<%=fieldid%>').getAttribute('viewtype'));
                                datainput('field_lable<%=fieldid%>')"
                            <%} else {%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',$G('field<%=fieldid%>').getAttribute('viewtype'))"
                            <%}%>
                        >
                        <span id="field_lable<%=fieldid%>span"></span>
                    <%
                    	}
                    %>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,
												languageid)%>" type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%
                	if (changefieldsadd.indexOf(fieldid) >= 0) {
                %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
											+ Util.getIntValue(isedit, 0)
											+ Util.getIntValue(ismand, 0)%>" />
<%
	}
					} else {
%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" type=text class=Inputstyle id="field_lable<%=fieldid%>" name="field_lable<%=fieldid%>"  disabled="true" size=60>
                    <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%
                	}
                %>
                </td></tr>
                <tr><td>
                    <input type=text class=Inputstyle size=60 name="field_chinglish<%=fieldid%>" id="field_chinglish<%=fieldid%>"  readOnly="true">
                </td></tr>
                <script language="javascript">
                    $GetEle("field_lable"+<%=fieldid%>).value  = milfloatFormat(floatFormat(<%=fieldvalue%>));
                    $GetEle("field_chinglish"+<%=fieldid%>).value = numberChangeToChinese(<%=fieldvalue%>);
                </script>
            </table>
	    <%
	    	}
	    				/*------------- xwj for td3131 20051116 end ----------*/

	    			} // 单行文本框条件结束
	    			else if (fieldhtmltype.equals("2")) { // 多行文本框
	    				/*-----xwj for @td2977 20051111 begin-----*/
	    				if (isbill.equals("0")) {
	    					rscount
	    							.executeSql("select textheight from workflow_formdict where id = "
	    									+ fieldid);
	    					if (rscount.next()) {
	    						textheight = rscount.getString("textheight");
	    					}
	    				} else {
	    					rscount
	    							.executeSql("select * from workflow_billfield where viewtype=0 and id = "
	    									+ fieldid + " and billid=" + formid);
	    					if (rscount.next()) {
	    						textheight = ""
	    								+ Util.getIntValue(rscount
	    										.getString("textheight"), 4);
	    					}
	    				}
	    				/*-----xwj for @td2977 20051111 begin-----*/
	    				if (isedit.equals("1") && editbodyactionflag) {
	    					if (ismand.equals("1")) {
	    %>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,
												languageid)%>" name="field<%=fieldid%>"  id="field<%=fieldid%>" <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%> onBlur="datainput('field<%=fieldid%>');" <%}%>  onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);checkLengthfortext('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,
												languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,
										user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,
										user.getLanguage())%>')"
		rows="<%=textheight%>" cols="40" style="width:80%;word-break:break-all;word-wrap:break-word" ><%=fieldtype.equals("2") ? Util
										.toHtmltextarea(Util
												.encodeAnd(fieldvalue)) : Util
										.toScreenToEdit(fieldvalue, user
												.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldid%>span"><%
        	if (fieldvalue.equals("")) {
        %><img src="/images/BacoError.gif" align=absmiddle><%
        	}
        %></span>
       <%
       	} else {
       %>
      <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,
												languageid)%>" name="field<%=fieldid%>" id="field<%=fieldid%>" rows="<%=textheight%>" onchange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);checkLengthfortext('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,
												languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,
										user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,
										user.getLanguage())%>')" cols="40" <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%> onBlur="datainput('field<%=fieldid%>');" <%}%> style="width:80%;word-break:break-all;word-wrap:break-word"><%=fieldtype.equals("2") ? Util
										.toHtmltextarea(Util
												.encodeAnd(fieldvalue)) : Util
										.toScreenToEdit(fieldvalue, user
												.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
      <span id="field<%=fieldid%>span"></span>
      <%
      	}
      %>
	  <script>$(function () { $GetEle("htmlfieldids").value += "field<%=fieldid%>;<%=Util.toScreen(fieldlable, languageid)%>,";});</script>
	  <%
	  	if (fieldtype.equals("2")) {
	  %>
		    <script>
			   function funcField<%=fieldid%>(){
				CkeditorExt.initEditor('frmmain','field<%=fieldid%>','<%=user.getLanguage()%>',CkeditorExt.NO_IMAGE,200)
			   	//FCKEditorExt.initEditor('frmmain','field<%=fieldid%>',<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
				<%if (isedit.equals("1"))
									out.println("CkeditorExt.checkText('field"
											+ fieldid + "span','field"
											+ fieldid + "');");%>
					CkeditorExt.toolbarExpand(false,"field<%=fieldid%>");
			   }

				//window.attachEvent("onload", funcField<%=fieldid%>);
				//$(window).bind("load", funcField<%=fieldid%>);
				if (window.addEventListener){
	        	    window.addEventListener("load", funcField<%=fieldid%>, false);
	        	}else if (window.attachEvent){
	        	    window.attachEvent("onload", funcField<%=fieldid%>);
	        	}else{
	        	    window.onload=funcField<%=fieldid%>;
	        	}
				
			</script>
			
			<%
							}
						%>  
			<%
  				if (changefieldsadd.indexOf(fieldid) >= 0) {
  			%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
										+ Util.getIntValue(isedit, 0)
										+ Util.getIntValue(ismand, 0)%>" />
<%
	}
				} else {
					if (fieldtype.equals("2")) {
						session.setAttribute("FCKEDDesc_" + requestid
								+ "_" + userid + "_" + fieldid + "_-1",
								fieldvalue);
						managefckfields_body.add("FCKiframe" + fieldid);
%>
<input type="hidden" id="FCKiframefieldid" value="FCKiframe<%=fieldid%>"/>
        <iframe id="FCKiframe<%=fieldid%>" name="FCKiframe<%=fieldid%>" src="/workflow/request/ShowFckEditorDesc.jsp?requestid=<%=requestid%>&userid=<%=userid%>&fieldid=<%=fieldid%>&rowno=-1"  width="100%" height="100%" marginheight="0" marginwidth="0" allowTransparency="true" frameborder="0"></iframe>
         <textarea name="field<%=fieldid%>" id="field<%=fieldid%>" style="display:none"><%=Util.toHtmltextarea(Util
										.encodeAnd(fieldvalue))%></textarea>
<%
	} else {
%>
        <span id="field<%=fieldid%>span" style="word-break:break-all;word-wrap:break-word"><%=fieldvalue%></span>
         <textarea name="field<%=fieldid%>" id="field<%=fieldid%>" style="display:none"><%=Util.toScreenToEdit(fieldvalue, user
										.getLanguage())%></textarea>
<script>			
	var fieldfieldidspan =  $GetEle('field<%=fieldid%>span');
	var afieldFieldHtml = fieldfieldidspan.getElementsByTagName('a');
	for(var i=0;i<afieldFieldHtml.length;i++){
		if(afieldFieldHtml[i].href.indexOf('javascript:')==-1){
			afieldFieldHtml[i].target='_blank';
		}
	}
</script>
<%
	}
%>

      <%
      	}
      			} // 多行文本框条件结束
      			else if (fieldhtmltype.equals("3")) { // 浏览按钮 (涉及workflow_broswerurl表)
      				String url = BrowserComInfo.getBrowserurl(fieldtype); // 浏览按钮弹出页面的url
      				String linkurl = BrowserComInfo.getLinkurl(fieldtype); // 浏览值点击的时候链接的url
      				String showname = ""; // 值显示的名称
      				String showid = ""; // 值
      				String hiddenlinkvalue = "";

      				String tablename = ""; //浏览框对应的表,比如人力资源表
      				String columname = ""; //浏览框对应的表名称字段
      				String keycolumname = ""; //浏览框对应的表值字段
      				// 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
      				if ((fieldtype.equals("37") || (fieldtype.equals("9") && docFlags
      						.equals("1")))
      						&& fieldid.equals(docfileid)
      						&& !newdocid.equals("")) {
      					if (!fieldvalue.equals(""))
      						fieldvalue += ",";
      					if (fieldtype.equals("9") && docFlags.equals("1"))
      						fieldvalue = newdocid;
      					else
      						fieldvalue += newdocid;
      				}

      				if (fieldtype.equals("2") || fieldtype.equals("19"))
      					showname = fieldvalue; // 日期时间
      				else if (!fieldvalue.equals("")) {
      					ArrayList tempshowidlist = Util.TokenizerString(
      							fieldvalue, ",");
      					if (fieldtype.equals("8")
      							|| fieldtype.equals("135")) {
      						//项目，多项目
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
      										+ "' target='_new'>"
      										+ ProjectInfoComInfo1
      												.getProjectInfoname((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += ProjectInfoComInfo1
      										.getProjectInfoname((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("17")) {
      						showname = workflowJspBean
      								.getMultiResourceShowName(fieldvalue,
      										linkurl, fieldid, user
      												.getLanguage());
      					} else if (fieldtype.equals("1")
      							|| fieldtype.equals("165")
      							|| fieldtype.equals("166")) {
      						//人员，多人员
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								if ("/hrm/resource/HrmResource.jsp?id="
      										.equals(linkurl)) {
      									showname += "<a href='javaScript:openhrm("
      											+ tempshowidlist.get(k)
      											+ ");' onclick='pointerXY(event);'>"
      											+ ResourceComInfo
      													.getResourcename((String) tempshowidlist
      															.get(k))
      											+ "</a>&nbsp";
      								} else
      									showname += "<a href='"
      											+ linkurl
      											+ tempshowidlist.get(k)
      											+ "' target='_new'>"
      											+ ResourceComInfo
      													.getResourcename((String) tempshowidlist
      															.get(k))
      											+ "</a>&nbsp";
      							} else {
      								showname += ResourceComInfo
      										.getResourcename((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("160")) {
      						//角色人员
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								if ("/hrm/resource/HrmResource.jsp?id="
      										.equals(linkurl)) {
      									showname += "<a href='javaScript:openhrm("
      											+ tempshowidlist.get(k)
      											+ ");' onclick='pointerXY(event);'>"
      											+ ResourceComInfo
      													.getResourcename((String) tempshowidlist
      															.get(k))
      											+ "</a>&nbsp";
      								} else
      									showname += "<a href='"
      											+ linkurl
      											+ tempshowidlist.get(k)
      											+ "' target='_new'>"
      											+ ResourceComInfo
      													.getResourcename((String) tempshowidlist
      															.get(k))
      											+ "</a>&nbsp";
      							} else {
      								showname += ResourceComInfo
      										.getResourcename((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("142")) {
      						//收发文单位
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
      										+ "' target='_new'>"
      										+ docReceiveUnitComInfo_mba
      												.getReceiveUnitName((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += docReceiveUnitComInfo_mba
      										.getReceiveUnitName((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("7")
      							|| fieldtype.equals("18")) {
      						//客户，多客户
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
      										+ "' target='_new'>"
      										+ CustomerInfoComInfo
      												.getCustomerInfoname((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += CustomerInfoComInfo
      										.getCustomerInfoname((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("4")
      							|| fieldtype.equals("57")
      							|| fieldtype.equals("167")
      							|| fieldtype.equals("168")) {
      						//部门，多部门
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
      										+ "' target='_new'>"
      										+ DepartmentComInfo1
      												.getDepartmentname((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += DepartmentComInfo1
      										.getDepartmentname((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("9")
      							|| fieldtype.equals("37")) {
      						//文档，多文档
      						for (int k = 0; k < tempshowidlist.size(); k++) {

      							if (fieldtype.equals("9")
      									&& docFlags.equals("1") && fieldid.equals(flowDocField)) {
      								//linkurl="WorkflowEditDoc.jsp?docId=";//????
      								String tempDoc = ""
      										+ tempshowidlist.get(k);
      								String tempDocView = "0";
      								if (isedit.equals("1")
      										&& editbodyactionflag) {
      									tempDocView = "1";
      								}
      								showname += "<a href='javascript:createDoc("
      										+ fieldid
      										+ ","
      										+ tempDoc
      										+ ","
      										+ tempDocView
      										+ ")' >"
      										+ DocComInfo1
      												.getDocname((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp<button type=button  id='createdoc' style='display:none' class=AddDocFlow onclick=createDoc("
      										+ fieldid
      										+ ","
      										+ tempDoc
      										+ ","
      										+ tempDocView + ")></button>";

      							} else {
      								if (!linkurl.equals("")) {
      									showname += "<a href='"
      											+ linkurl
      											+ tempshowidlist.get(k)
      											+ "&requestid="
      											+ requestid
      											+ "' target='_blank'>"
      											+ DocComInfo1
      													.getDocname((String) tempshowidlist
      															.get(k))
      											+ "</a>&nbsp";
      								} else {
      									showname += DocComInfo1
      											.getDocname((String) tempshowidlist
      													.get(k))
      											+ " ";
      								}
      							}
      						}
      					} else if (fieldtype.equals("23")) {
      						//资产
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
      										+ "' target='_new'>"
      										+ CapitalComInfo1
      												.getCapitalname((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += CapitalComInfo1
      										.getCapitalname((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("16")
      							|| fieldtype.equals("152")
      							|| fieldtype.equals("171")) {
      						//相关请求
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								int tempnum = Util
      										.getIntValue(String
      												.valueOf(session
      														.getAttribute("slinkwfnum")));
      								tempnum++;
      								session.setAttribute("resrequestid"
      										+ tempnum, ""
      										+ tempshowidlist.get(k));
      								session.setAttribute("slinkwfnum", ""
      										+ tempnum);
      								session.setAttribute("haslinkworkflow",
      										"1");
      								hiddenlinkvalue += "<input type=hidden name='slink"
      										+ fieldid
      										+ "_rq"
      										+ tempshowidlist.get(k)
      										+ "' value=" + tempnum + ">";
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
      										+ "&wflinkno="
      										+ tempnum
      										+ "' target='_new'>"
      										+ WorkflowRequestComInfo1
      												.getRequestName((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += WorkflowRequestComInfo1
      										.getRequestName((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					}
      					//add by fanggsh for TD4528   20060621 begin
      					else if (fieldtype.equals("141")) {
      						//人力资源条件
      						showname += ResourceConditionManager
      								.getFormShowName(fieldvalue, languageid);
      					}
      					//add by fanggsh for TD4528   20060621 end
      					//added by alan for td:10814
      					else if (fieldtype.equals("142")) {
      						//收发文单位
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("") && !isprint) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
      										+ "' target='_new'>"
      										+ DocReceiveUnitComInfo
      												.getReceiveUnitName(""
      														+ tempshowidlist
      																.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += DocReceiveUnitComInfo
      										.getReceiveUnitName(""
      												+ tempshowidlist.get(k))
      										+ " ";
      							}
      						}
      					}
      					//end by alan for td:10814
      					else if (fieldtype.equals("161")) {//自定义单选
      						showname = ""; // 新建时候默认值显示的名称
      						String showdesc = "";
      						showid = fieldvalue; // 新建时候默认值
      						try {
      							Browser browser = (Browser) StaticObj
      									.getServiceByFullname(fielddbtype,
      											Browser.class);
      							BrowserBean bb = browser.searchById(showid);
      							String desc = Util.null2String(bb
      									.getDescription());
      							String name = Util
      									.null2String(bb.getName());
                                String href=Util.null2String(bb.getHref());
                                if(href.equals("")){
                                	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
                                }else{
                                	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
                                }
      						} catch (Exception e) {
      						}
      					} else if (fieldtype.equals("162")) {//自定义多选
      						showname = ""; // 新建时候默认值显示的名称
      						showid = fieldvalue; // 新建时候默认值
      						try {
      							Browser browser = (Browser) StaticObj
      									.getServiceByFullname(fielddbtype,
      											Browser.class);
      							List l = Util.TokenizerString(showid, ",");
      							for (int j = 0; j < l.size(); j++) {
      								String curid = (String) l.get(j);
      								BrowserBean bb = browser
      										.searchById(curid);
      								String name = Util.null2String(bb
      										.getName());
      								//System.out.println("showname:"+showname);
      								String desc = Util.null2String(bb
      										.getDescription());
      	                            String href=Util.null2String(bb.getHref());
      	                            if(href.equals("")){
      	                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
      	                            }else{
      	                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
      	                            }
      							}
      						} catch (Exception e) {
      						}
      					}
						else if (fieldtype.equals("226")||fieldtype.equals("227")) {
								//集成浏览按钮
								//zzl
								//String showname = ""; // 值显示的名称
      							//String showid = ""; // 值
								//showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
								showname+="<a title='"+fieldvalue+"'>"+fieldvalue+"</a>&nbsp";
								url+="?type="+fielddbtype+"|"+fieldid;	
								//System.out.println("fieldids"+fieldid);
								//System.out.println("fieldnames"+fieldname);
								//System.out.println("fieldvalues"+fieldvalue);
						}
      					else {
      						tablename = BrowserComInfo
      								.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
      						columname = BrowserComInfo
      								.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
      						/*因为应聘库中(HrmCareerApply)的人员的firstname在新增时都为空，此处列名直接取上面查出来的(lastname+firstname)
      						会导致流程提交后应聘人不显示，所以此处做下特殊处理，只取应聘人的lastname	参考TD24866*/
      						if (columname.equals("(lastname+firstname)"))
      							columname = "lastname";
      						keycolumname = BrowserComInfo
      								.getBrowserkeycolumname(fieldtype); //浏览框对应的表值字段

      						//add by wang jinyong
      						HashMap temRes = new HashMap();

      						if (fieldvalue.indexOf(",") != -1) {
      							sql = "select " + keycolumname + ","
      									+ columname + " from " + tablename
      									+ " where " + keycolumname
      									+ " in( " + fieldvalue + ")";
      						} else {
      							sql = "select " + keycolumname + ","
      									+ columname + " from " + tablename
      									+ " where " + keycolumname + "="
      									+ fieldvalue;
      						}

      						RecordSet.executeSql(sql);
      						while (RecordSet.next()) {
      							showid = Util.null2String(RecordSet
      									.getString(1));
      							String tempshowname = Util.toScreen(
      									RecordSet.getString(2), user
      											.getLanguage());
      							if (!linkurl.equals("")) {
      								showname += "<a href='" + linkurl
      										+ showid + "' target='_new'>"
      										+ tempshowname + "</a>&nbsp";
      							} else {
      								showname += tempshowname + " ";
      							}
      						}
      					}
      				}

      				//add by dongping
      				//永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表
      				if (fieldtype.equals("118")) {
      					showname = "<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>查看会议室使用情况</a>";
      				}

      				if (isedit.equals("1") && editbodyactionflag) {
      					//add by fanggsh 20060621 for TD4528 begin
      					if (fieldtype.equals("160")) {
      						rsaddop
      								.execute("select a.level_n, a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="
      										+ fieldid
      										+ " and b.nodeid in (select nodeid from workflow_flownode where workflowid="
      										+ workflowid + ") ");
      						String roleid = "";
      						int rolelevel_tmp = 0;
      						if (rsaddop.next()) {
      							roleid = rsaddop.getString(1);
      							rolelevel_tmp = Util.getIntValue(rsaddop
      									.getString(2), 0);
      							roleid += "a" + rolelevel_tmp+"b"+beagenter;
      						}
      %>
        <button type=button  class=Browser  onclick="onShowResourceRole('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'),'<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,
										user.getLanguage())%>"></button>
<%
	} else if (fieldtype.equals("161")
							|| fieldtype.equals("162")) {
						url += "?type=" + fielddbtype;
%>
		    <button type=button  class=Browser  onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'));<%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>datainput('field<%=fieldid%>');<%}%>" ></button>
<%
  	} else if (fieldtype.equals("226")|| fieldtype.equals("227")) {
			//zzl
			//解决新建的时候不选择sap浏览按钮的数据，然后保存，在代办页面打开，浏览按钮里面没有数据的问题
			url+="?type="+fielddbtype+"|"+fieldid;	
%>
		  <button type=button  class=Browser  onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'));<%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>datainput('field<%=fieldid%>');<%}%>" ></button>
<%	
	}
  	else if (fieldtype.equals("141")) {
  %>
        <button type=button  class=Browser  onclick="onShowResourceConditionBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(172, user
										.getLanguage())%>"></button>
<%
	} else {
						//add by fanggsh 20060621 for TD4528 end
						if (!fieldtype.equals("37")
								&& !fieldtype.equals("9")) { //  多文档特殊处理
%>
        <button type=button  class=Browser 
		<%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'));datainput('field<%=fieldid%>');"		
		<%} else {%>
		onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'))"
		<%}%> 
		title="<%=SystemEnv.getHtmlLabelName(172,
											user.getLanguage())%>">
		</button>
	   			
       <%
	   			       	} else if (fieldtype.equals("37")) { // 如果是多文档字段,加入新建文档按钮
	   			       %>
        <button type=button  class=AddDocFlow onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'))" > <%=SystemEnv.getHtmlLabelName(611,
											user.getLanguage())%></button>&nbsp;&nbsp;<button type=button  class=AddDocFlow onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,
											user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,
											user.getLanguage())%></button>
       <%
       	} else if (fieldtype.equals("9")
       								&& fieldid.equals(flowDocField)) {
       							if (!"1".equals(newTNflag)) {
       %>
		<button type=button  class=Browser 
		<%if (trrigerfield.indexOf("field"
												+ fieldid) >= 0) {%>      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'));datainput('field<%=fieldid%>');"	
		<%} else {%>
		onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'))"
		<%}%> 
		title="<%=SystemEnv.getHtmlLabelName(
												172, user.getLanguage())%>">
		</button>
	   <%
	   	}
	   						} else {
	   %>
	    <button type=button  class=Browser <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>
	      onclick="onShowBrowser3('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>');datainput('field<%=fieldid%>','<%=ismand%>');"
	   <%} else {%>
		  onclick="onShowBrowser3('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,
											user.getLanguage())%>">
	    </button>
		<%
			}
								if (fieldtype.equals("9")
										&& fieldid.equals(flowDocField)) {
		%>
	    <span id="CreateNewDoc">
			 <%
			 	if (docFlags.equals("1")
			 									&& fieldvalue.equals("")) ///????????s
			 							{
			 %>
           <button type=button  id="createdoc" class=AddDocFlow onclick="createDoc('<%=fieldid%>','','1')" title="<%=SystemEnv.getHtmlLabelName(
												82, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(
												82, user.getLanguage())%></button>
           <%
           	}
           						}
           %></span><%
           	}
           				}
           %>
        <span id="field<%=fieldid%>span"><%=showname%>
       <%
       	if (ismand.equals("1") && fieldvalue.equals("")) {
       %>
        <img src="/images/BacoError.gif" align=absmiddle>
       <%
       	}
       %>
        </span>
        <%
        	if (fieldtype.equals("87")) {
        %>
        <A href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193, user
									.getLanguage())%></A>
        <%
        	}
        %>
		   <%
		   	if (fieldtype.equals("9") || fieldtype.equals("161")
		   						|| fieldtype.equals("162")) {
		   %>
		    <input type=hidden viewtype="<%=ismand%>" name="field<%=fieldid%>"  id="field<%=fieldid%>" value="<%=fieldvalue%>" temptitle="<%=Util.toScreen(fieldlable, languageid)%>" >
		   <%
		   	} else {
		   %>
		   <input type=hidden viewtype="<%=ismand%>" name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>"  temptitle="<%=Util.toScreen(fieldlable, languageid)%>" onpropertychange="checkLengthbrow('field<%=fieldid%>','field<%=fieldid%>span','<%=fieldlen%>','<%=Util.toScreen(fieldlable, languageid)%>','<%=SystemEnv.getHtmlLabelName(20246, user
									.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247, user
									.getLanguage())%>',$G('field<%=fieldid%>').getAttribute('viewtype'));<%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>datainput('field<%=fieldid%>')<%}%>">
			 <%
			 	}
			 %>
           <%=hiddenlinkvalue%>
       <%
       	if (changefieldsadd.indexOf(fieldid) >= 0) {
       %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
									+ Util.getIntValue(isedit, 0)
									+ Util.getIntValue(ismand, 0)%>" />
<%
	}
			} // 浏览按钮条件结束
			else if (fieldhtmltype.equals("4")) { // check框
%>
        <input type=checkbox viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable, languageid)%>" value=1 <%if (isedit.equals("0") || !editbodyactionflag) {%> DISABLED <%} else {%> name="field<%=fieldid%>" id="field<%=fieldid%>" <%}
						if (trrigerfield.indexOf("field" + fieldid) >= 0) {%> onChange="datainput('field<%=fieldid%>');" <%}%> <%if (fieldvalue.equals("1")) {%> checked <%}%> >
        <%
        	if (isedit.equals("0") || !editbodyactionflag) {
        %>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>" >
        <%
        	}
        %>
       <%
       	if (changefieldsadd.indexOf(fieldid) >= 0) {
       %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
									+ Util.getIntValue(isedit, 0)
									+ Util.getIntValue(ismand, 0)%>" />
<%
	}
			} // check框条件结束
			else if (fieldhtmltype.equals("5")) { // 选择框   select
				//处理select字段联动
				String onchangeAddStr = "";
				int childfieldid_tmp = 0;
				if ("0".equals(isbill)) {
					rs_item
							.execute("select childfieldid from workflow_formdict where id="
									+ fieldid);
				} else {
					rs_item
							.execute("select childfieldid from workflow_billfield where id="
									+ fieldid);
				}
				if (rs_item.next()) {
					childfieldid_tmp = Util.getIntValue(rs_item
							.getString("childfieldid"), 0);
				}
				int firstPfieldid_tmp = 0;
				boolean hasPfield = false;
				if ("0".equals(isbill)) {
					rs_item
							.execute("select id from workflow_formdict where childfieldid="
									+ fieldid);
				} else {
					rs_item
							.execute("select id from workflow_billfield where childfieldid="
									+ fieldid);
				}
				while (rs_item.next()) {
					firstPfieldid_tmp = Util.getIntValue(rs_item
							.getString("id"), 0);
					if (fieldids.contains("" + firstPfieldid_tmp)) {
						hasPfield = true;
						break;
					}
				}
				if (childfieldid_tmp != 0) {//如果先出现子字段，则要把子字段下拉选项清空
					onchangeAddStr = "changeChildField(this, "
							+ fieldid + ", " + childfieldid_tmp + ")";
				}
				//添加事件信息
				String uploadMax = "";
				if (fieldid.equals(selectedfieldid) && uploadType == 1) {
					uploadMax = "changeMaxUpload('field" + fieldid
							+ "');reAccesoryChanage();";
				}
%>
        <script>
        	function funcField<%=fieldid%>(){
        	    changeshowattr('<%=fieldid%>_0', $GetEle('field<%=fieldid%>').value,-1,'<%=workflowid%>','<%=nodeid%>');
        	}
        	//window.attachEvent("onload", funcField<%=fieldid%>);
        	if (window.addEventListener){
        	    window.addEventListener("load", funcField<%=fieldid%>, false);
        	}else if (window.attachEvent){
        	    window.attachEvent("onload", funcField<%=fieldid%>);
        	}else{
        	    window.onload=funcField<%=fieldid%>;
        	}
        	//$(window).bind("load", funcField<%=fieldid%>);
        </script>
        <select class=inputstyle  viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable, languageid)%>" onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);" <%if (isedit.equals("0") || !editbodyactionflag) {%> name="disfield<%=fieldid%>" DISABLED <%} else {%> name="field<%=fieldid%>" id="field<%=fieldid%>" <%}%> onChange="<%=uploadMax%><%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>datainput('field<%=fieldid%>');<%}
						if (selfieldsadd.indexOf(fieldid) >= 0) {%>changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);<%}%><%=onchangeAddStr%>"  >
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
	   	// 查询选择框的所有可以选择的值
	   				boolean checkempty = true;//xwj for td3313 20051206
	   				String finalvalue = "";//xwj for td3313 20051206
	   				if (hasPfield == false
	   						|| isedit.equals("0")
	   						|| (isaffirmancebody.equals("1") && !reEditbody
	   								.equals("1")) || isremark != 0
	   						|| nodetype.equals("3")) {
	   					rs.executeProc("workflow_selectitembyid_new", ""
	   							+ fieldid + flag + isbill);
	   					while (rs.next()) {
	   						String tmpselectvalue = Util.null2String(rs
	   								.getString("selectvalue"));
	   						String tmpselectname = Util.toScreen(rs
	   								.getString("selectname"), user
	   								.getLanguage());
	   						//获取选择目录的附件大小信息
	   						String tdocCategory = Util.toScreen(rs
	   								.getString("docCategory"), user
	   								.getLanguage());
	   						String tMaxUploadFileSize = "";
	   						if (!"".equals(tdocCategory)
	   								&& fieldid.equals(selectedfieldid)
	   								&& uploadType == 1) {
	   							int tsecid = Util.getIntValue(tdocCategory
	   									.substring(tdocCategory
	   											.lastIndexOf(",") + 1), -1);
	   							tMaxUploadFileSize = ""
	   									+ Util
	   											.getIntValue(
	   													SecCategoryComInfo1
	   															.getMaxUploadFileSize(""
	   																	+ tsecid),
	   													5);
	   							secMaxUploads.put(tmpselectvalue,
	   									tMaxUploadFileSize);
	   							secCategorys.put(tmpselectvalue,
	   									tdocCategory);
	   							if (tmpselectvalue.equals(fieldvalue)) {
	   								maxUploadImageSize = Util.getIntValue(
	   										tMaxUploadFileSize, 5);
	   								docCategory = tdocCategory;
	   							}
	   						}
	   						/* -------- xwj for td3313 20051206 begin -*/
	   						if (tmpselectvalue.equals(fieldvalue)) {
	   							checkempty = false;
	   							finalvalue = tmpselectvalue;
	   						}
	   						/* -------- xwj for td3313 20051206 end -*/
	   %>
	    <option value="<%=tmpselectvalue%>" <%if (fieldvalue.equals(tmpselectvalue)) {%> selected <%}%>><%=tmpselectname%></option>
	   <%
	   	}
	   				} else {
	   					rs.executeProc("workflow_selectitembyid_new", ""
	   							+ fieldid + flag + isbill);
	   					while (rs.next()) {
	   						String tmpselectvalue = Util.null2String(rs
	   								.getString("selectvalue"));
	   						String tmpselectname = Util.toScreen(rs
	   								.getString("selectname"), user
	   								.getLanguage());
	   						/* -------- xwj for td3313 20051206 begin -*/
	   						if (tmpselectvalue.equals(fieldvalue)) {
	   							checkempty = false;
	   							finalvalue = tmpselectvalue;
	   						}
		%>
		<option value="<%=tmpselectvalue%>" <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
		<%
	   					}
	   					selectInitJsStr += "doInitChildSelect(" + fieldid
	   							+ "," + firstPfieldid_tmp + ",\""
	   							+ finalvalue + "\");\n";
	   					initIframeStr += "<iframe id=\"iframe_"
	   							+ firstPfieldid_tmp
	   							+ "_"
	   							+ fieldid
	   							+ "_00\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";
	   				}
	   				if (selfieldsadd.indexOf(fieldid) >= 0)
	   					bodychangattrstr += "changeshowattr('" + fieldid
	   							+ "_0','" + finalvalue + "',-1,"
	   							+ workflowid + "," + nodeid + ");";
	   %>
	    </select>

	    <!--xwj for td3313 20051206 begin-->
	    <span id="field<%=fieldid%>span">
	    <%
	    	if (ismand.equals("1") && checkempty) {
	    %>
       <img src='/images/BacoError.gif' align=absMiddle>
      <%
      	}
      %>
	     </span>
	    <!--xwj for td3313 20051206 end-->

        <%
        	if (isedit.equals("0") || !editbodyactionflag) {
        %>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=finalvalue%>" temptitle="<%=Util.toScreen(fieldlable, languageid)%>" >
        <%
        	}
        %>
       <%
       	if (changefieldsadd.indexOf(fieldid) >= 0) {
       %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
									+ Util.getIntValue(isedit, 0)
									+ Util.getIntValue(ismand, 0)%>" />
<%
	}
				//add by xhheng @20050310 for 附件上传
			} else if (fieldhtmltype.equals("6")) {
%>
          <%
          	if (isedit.equals("1") && editbodyactionflag) {
          %>
          <!--modify by xhheng @20050511 for 1803-->
          <table cols=3 id="field<%=fieldid%>_tab">
            <tbody >
            <col width="50%" >
            <col width="25%" >
            <col width="25%">
          <%
          	if ("-2".equals(fieldvalue)) {
          %>
			<tr>
				<td colSpan=3><font color="red">
				<%=SystemEnv.getHtmlLabelName(21710,
										languageidfromrequest)%></font>
				</td>
			</tr>
			  <%
			  	} else {
			  						if (!fieldvalue.equals("")) {
			  							sql = "select id,docsubject,accessorycount,SecCategory from docdetail where id in("
			  									+ fieldvalue + ") order by id asc";
			  							RecordSet.executeSql(sql);
			  							int AttachmentCounts=RecordSet.getCounts();
			  							int linknum = -1;
			  							boolean isfrist = false;
			  							int imgnum = fieldimgnum;
			  							while (RecordSet.next()) {
			  								isfrist = false;
			  								linknum++;
			  								String showid = Util
			  										.null2String(RecordSet
			  												.getString(1));
			  								String tempshowname = Util.toScreen(
			  										RecordSet.getString(2), user
			  												.getLanguage());
			  								int accessoryCount = RecordSet
			  										.getInt(3);
			  								String SecCategory = Util
			  										.null2String(RecordSet
			  												.getString(4));
			  								DocImageManager.resetParameter();
			  								DocImageManager.setDocid(Integer
			  										.parseInt(showid));
			  								DocImageManager.selectDocImageInfo();

			  								String docImagefileid = "";
			  								long docImagefileSize = 0;
			  								String docImagefilename = "";
			  								String fileExtendName = "";
			  								int versionId = 0;

			  								if (DocImageManager.next()) {
			  									//DocImageManager会得到doc第一个附件的最新版本
			  									docImagefileid = DocImageManager
			  											.getImagefileid();
			  									docImagefileSize = DocImageManager
			  											.getImageFileSize(Util
			  													.getIntValue(docImagefileid));
			  									docImagefilename = DocImageManager
			  											.getImagefilename();
			  									fileExtendName = docImagefilename
			  											.substring(
			  													docImagefilename
			  															.lastIndexOf(".") + 1)
			  											.toLowerCase();
			  									versionId = DocImageManager
			  											.getVersionId();
			  								}
			  								if (accessoryCount > 1) {
			  									fileExtendName = "htm";
			  								}
			  								boolean nodownload = SecCategoryComInfo1
			  										.getNoDownload(SecCategory)
			  										.equals("1") ? true : false;
			  								String imgSrc = AttachFileUtil
			  										.getImgStrbyExtendName(
			  												fileExtendName, 20);

			  								if (fieldtype.equals("2")) {
			  									if (linknum == 0) {
			  										isfrist = true;
			  %>
			<% 
             if(!"1".equals(forbidAttDownload) && !nodownload && AttachmentCounts>1 && linknum==0){
            %>
            <tr> 
              <td colSpan=3><nobr>
                  <button type=button class=btnFlowd accessKey=1  onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')">
                    <%="&nbsp;&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(74,user.getLanguage())+SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%>
                  </button>              
              </td>
            </tr> 
            <%}%> 
            <tr>
                <td colSpan=3>
                    <table cellspacing="0" cellpadding="0">
                        <tr>
              <%
              	}
              									if (imgnum > 0 && linknum >= imgnum) {
              										imgnum += fieldimgnum;
              										isfrist = true;
              %>
              </tr>
              <tr>
              <%
              	}
              %>
                  <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td <%if (!isfrist) {%>style="padding-left:15"<%}%>>
                     <table cellspacing="0" cellpadding="0">
                      <tr>
                          <td colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand;margin:auto;" alt="<%=docImagefilename%>" <%if (fieldimgwidth > 0) {%>width="<%=fieldimgwidth%>"<%}%> <%if (fieldimgheight > 0) {%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <%
                              	//创建节点，并且该流程允许创建人删除附件才有权限删除附件。
                              									if (!canDelAcc.equals("1")
                              											|| (canDelAcc.equals("1") && nodetype
                              													.equals("0"))) {
                              %>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>);return false;'>[<span style="cursor:hand;color:black;"><%=SystemEnv
																.getHtmlLabelName(
																		91,
																		user
																				.getLanguage())%></span>]</a>
                                    <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><b><font COLOR="#FF0033">√</font></b><span></td>
                              <%
                              	}
                              									if (!nodownload) {
                              %>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span  style="cursor:hand;color:black;"><%=SystemEnv
																.getHtmlLabelName(
																		258,
																		user
																				.getLanguage())%></span>]</a>
                              </td>
                              <%
                              	}
                              %>
                      </tr>
                        </table>
                    </td>
              <%
              	} else {
              %>
              <tr>
                <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0" >
            <td >      
              <%=imgSrc%>

              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a  style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>',1)"><%=docImagefilename%></a>&nbsp
              <%
                	} else {
                %>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp

              <%
                	}
                %>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
              </td>
            <%
            	//创建节点，并且该流程允许创建人删除附件才有权限删除附件。
            									if (!canDelAcc.equals("1")|| (canDelAcc.equals("1") && nodetype.equals("0"))) {
            %>
            <td >
                <button type=button  class=btnFlow accessKey=1  onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>)'><u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
                </button><span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden">
                    <b><font COLOR="#FF0033">√</font></b>
                  <span>
            </td>
            <%
            	}
            %>
            <%
            	if (accessoryCount == 1) {
            %>
            <td >
              <!-- 再次加一个nobr 标签 就可以 2012-08-28 ypc 修改 一行不该换行的元素换行 使用此标签 -->
              <span id = "selectDownload">
              	<nobr>
                <%
                	if((!Util.isExt(fileExtendName))||!nodownload){
                %>
                  <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>(<%=docImagefileSize / 1000%>K)
                  </button>
                 <% 
                    //if(isDownloadAll && AttachmentCounts>1 && (linknum+1)==AttachmentCounts){
                    if(!"1".equals(forbidAttDownload) && !nodownload && AttachmentCounts>1 && linknum==0){
                  %>
                  &nbsp;&nbsp;&nbsp;&nbsp;
                  <button type=button class=btnFlowd accessKey=1  onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')">
                    <%="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%>
                  </button>
                  <%}%> 
                <%
                	}
                %>
                </nobr>
              </span>
            </td>
            <%
            	}
            %>
          </tr>
            <%
            	}
            							}
            							if (fieldtype.equals("2") && linknum > -1) {
            %>
            </tr></table></td></tr>
            <%
            	}
            %>
            <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum + 1%>>
            <input type=hidden name="field<%=fieldid%>_idnum_1" value=<%=linknum + 1%>>
          <%
          	}
          					}
          %>
          <tr>
            <td colspan=3>
             <%
             	String mainId = "";
             					String subId = "";
             					String secId = "";
             					if (docCategory != null && !docCategory.equals("")) {
             						mainId = docCategory.substring(0, docCategory
             								.indexOf(','));
             						subId = docCategory.substring(docCategory
             								.indexOf(',') + 1, docCategory
             								.lastIndexOf(','));
             						secId = docCategory.substring(docCategory
             								.lastIndexOf(',') + 1, docCategory
             								.length());
             					}
             					String picfiletypes = "*.*";
             					String filetypedesc = "All Files";
             					if (fieldtype.equals("2")) {
             						picfiletypes = BaseBean.getPropValue(
             								"PicFileTypes", "PicFileTypes");
             						filetypedesc = "Images Files";
             					}
             					boolean canupload = true;
             					if (uploadType == 0) {
             						if ("".equals(mainId) && "".equals(subId)
             								&& "".equals(secId)) {
             							canupload = false;
             %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,
											user.getLanguage())
											+ SystemEnv.getHtmlLabelName(92,
													user.getLanguage())
											+ SystemEnv.getHtmlLabelName(15808,
													user.getLanguage())%>!</font>
           <%
           	}
           					} else if (!isCanuse) {
           						canupload = false;
           %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,
										user.getLanguage())
										+ SystemEnv.getHtmlLabelName(92, user
												.getLanguage())
										+ SystemEnv.getHtmlLabelName(15808,
												user.getLanguage())%>!</font>
           <%
           	}
           					if (canupload) {
           						uploadfieldids.add(fieldid);
           %>
            <script>
          var oUpload<%=fieldid%>;
          function fileupload<%=fieldid%>() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldid%>",
                cancelButtonId : "btnCancel<%=fieldid%>",
                uploadspan : "field<%=fieldid%>span",
                uploadfiedid : "field<%=fieldid%>"
            },
            debug: false,
            button_image_url : "/js/swfupload/add.png",
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldid%>",
            button_width: 100,
            button_height: 18,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,
										user.getLanguage())%></span>',
            button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 0,
            button_text_left_padding: 18,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            // The event handler functions are defined in handlers.js
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_1,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };


        try {
            oUpload<%=fieldid%>=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileupload<%=fieldid%>);
        	//$(window).bind("load", fileupload<%=fieldid%>);
          	if (window.addEventListener){
	      	    window.addEventListener("load", fileupload<%=fieldid%>, false);
	      	}else if (window.attachEvent){
	      	    window.attachEvent("onload", fileupload<%=fieldid%>);
	      	}else{
	      	    window.onload=funcField<%=fieldid%>;
	      	}
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolder<%=fieldid%>"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldid%>.cancelQueue();showmustinput(oUpload<%=fieldid%>);" id="btnCancel<%=fieldid%>">
									<span><img src="/js/swfupload/delete.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,
										user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span id="uploadspan">(<%=SystemEnv.getHtmlLabelName(18976,
										user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,
										user.getLanguage())%>)</span>
                      <span id="field<%=fieldid%>span">
				<%
					if (ismand.equals("1") && fieldvalue.equals("")) {
				%>
			   <img src='/images/BacoError.gif' align=absMiddle>
			  <%
			  	}
			  %>
	     </span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field<%=fieldid%>" id="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,
												languageid)%>"  viewtype="<%=ismand%>" value="<%=fieldvalue%>">
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgress<%=fieldid%>">
                  </div>
                  <div id="divStatus<%=fieldid%>"></div>
              </td>
          </tr>
      </TABLE>
            <%
            	}
            %>
          <input type=hidden name='mainId' value=<%=mainId%>>
          <input type=hidden name='subId' value=<%=subId%>>
          <input type=hidden name='secId' value=<%=secId%>>
             </td>
          </tr>
      </TABLE>
          <%
          	} else {
          					if (!fieldvalue.equals("")) {
          %>
          <table cols=3 id="field<%=fieldid%>_tab">
            <tbody >
            <col width="50%" >
            <col width="25%" >
            <col width="25%">
            <%
            	sql = "select id,docsubject,accessorycount,SecCategory from docdetail where id in("
            								+ fieldvalue + ") order by id asc";
            						int linknum = -1;
            						RecordSet.executeSql(sql);
            						int AttachmentCounts=RecordSet.getCounts();
            						boolean isfrist = false;
            						int imgnum = fieldimgnum;
            						while (RecordSet.next()) {
            							isfrist = false;
            							linknum++;
            							String showid = Util.null2String(RecordSet
            									.getString(1));
            							String tempshowname = Util.toScreen(
            									RecordSet.getString(2), user
            											.getLanguage());
            							int accessoryCount = RecordSet.getInt(3);
            							String SecCategory = Util
            									.null2String(RecordSet.getString(4));
            							DocImageManager.resetParameter();
            							DocImageManager.setDocid(Integer
            									.parseInt(showid));
            							DocImageManager.selectDocImageInfo();

            							String docImagefileid = "";
            							long docImagefileSize = 0;
            							String docImagefilename = "";
            							String fileExtendName = "";
            							int versionId = 0;

            							if (DocImageManager.next()) {
            								docImagefileid = DocImageManager
            										.getImagefileid();
            								docImagefileSize = DocImageManager
            										.getImageFileSize(Util
            												.getIntValue(docImagefileid));
            								docImagefilename = DocImageManager
            										.getImagefilename();
            								fileExtendName = docImagefilename
            										.substring(
            												docImagefilename
            														.lastIndexOf(".") + 1)
            										.toLowerCase();
            								versionId = DocImageManager
            										.getVersionId();
            							}
            							if (accessoryCount > 1) {
            								fileExtendName = "htm";
            							}
            							String imgSrc = AttachFileUtil
            									.getImgStrbyExtendName(
            											fileExtendName, 20);
            							boolean nodownload = SecCategoryComInfo1
            									.getNoDownload(SecCategory).equals(
            											"1") ? true : false;
            							if (fieldtype.equals("2")) {
            								if (linknum == 0) {
            									isfrist = true;
            %>
			<% 
             if(!"1".equals(forbidAttDownload) && !nodownload && AttachmentCounts>1 && linknum==0){
            %>              
            <tr> 
              <td colSpan=3><nobr>
                  <button type=button class=btnFlowd accessKey=1  onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')">
                    <%="&nbsp;&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(74,user.getLanguage())+SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%>
                  </button>           
              </td>
            </tr> 
           <%}%>
            <tr>
                <td colSpan=3>
                    <table cellspacing="0" cellpadding="0">
                        <tr>
              <%
              	}
              								if (imgnum > 0 && linknum >= imgnum) {
              									imgnum += fieldimgnum;
              									isfrist = true;
              %>
              </tr>
              <tr>
              <%
              	}
              %>
                  <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td <%if (!isfrist) {%>style="padding-left:15"<%}%>>
                     <table cellspacing="0" cellpadding="0">
                      <tr>
                          <td colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand;margin:auto;" alt="<%=docImagefilename%>" <%if (fieldimgwidth > 0) {%>width="<%=fieldimgwidth%>"<%}%> <%if (fieldimgheight > 0) {%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <%
                              	if (!nodownload) {
                              %>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span  style="cursor:hand;color:black;"><%=SystemEnv
													.getHtmlLabelName(258, user
															.getLanguage())%></span>]</a>
                              </td>
                              <%
                              	}
                              %>
                      </tr>
                        </table>
                    </td>
              <%
              	} else {
              %>
              <tr>
                <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                <td colspan=3>
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>',0)"><%=docImagefilename%></a>&nbsp

              <%
                	} else {
                %>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%
                	}
                %>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>> <!--xwj for td2893 20051017-->
              <%if((!Util.isExt(fileExtendName))||!nodownload){%>
                <span id = "selectDownload">
                  <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv
													.getHtmlLabelName(258, user
															.getLanguage())%>	(<%=docImagefileSize / 1000%>K)
                  </button>
					<% 
                    //if(isDownloadAll && AttachmentCounts>1 && (linknum+1)==AttachmentCounts){
                    if(!"1".equals(forbidAttDownload) && !nodownload && AttachmentCounts>1 && linknum==0){
                  %>
                  &nbsp;&nbsp;&nbsp;&nbsp;
                  <button type=button class=btnFlowd accessKey=1  onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')">
                    <%="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%>
                  </button>
                  <%}%>  
                </span>
              <%
              	}
              %>
              </td>
          </tr>
            <%
            	}
            						}
            						if (fieldtype.equals("2") && linknum > -1) {
            %>
            </tr></table></td></tr>
            <%
            	}
            %>
              <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum + 1%>><!--xwj for td2893 20051017-->
              <input type=hidden name="field<%=fieldid%>" id="field<%=fieldid%>" value=<%=fieldvalue%>>
              </tbody>
              </table>
              <%
              	}
              				}
              			} // 选择框条件结束 所有条件判定结束
              			else if (fieldhtmltype.equals("7")) {//特殊字段
              				if (isbill.equals("0"))
              					out.println(Util.null2String((String) specialfield.get(fieldid + "_0")));
              				else
              					out.println(Util.null2String((String) specialfield.get(fieldid + "_1")));
              			}
              %>
      </td>
    </tr><tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>

<%
	} else { // 不显示的作为 hidden 保存信息
			if (fieldhtmltype.equals("6")) {
				if (!fieldvalue.equals("")) {
					ArrayList fieldvalueas = Util.TokenizerString(
							fieldvalue, ",");
					// sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
					// RecordSet.executeSql(sql);
					int linknum = -1;
					for (int j = 0; j < fieldvalueas.size(); j++) {
						linknum++;
						String showid = Util.null2String(""
								+ fieldvalueas.get(j));
%>
            <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>"  value=<%=showid%>>

          <%
          	}
          %><input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum + 1%>>
          <%
          	}
          			}

          			if (fieldhtmltype.equals("2") && fieldtype.equals("2")) {
          %>
	<textarea name="field<%=fieldid%>" id="field<%=fieldid%>" style="display:none"><%=fieldvalue%></textarea>
	<%
		} else {
	%>
    <input type=hidden name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue, user
								.getLanguage())%>" >
<%
	}
		}
%>
<%
	} // 循环结束
%>

</table>
<%=initIframeStr%>
<!--#######明细表 Start#######-->
<%
	//@ include file="/workflow/request/WorkflowManageRequestDetailBody.jsp"
%>
<!--#######明细表 END#########-->
<!-- 给一下input隐藏域添加id 供其他页面 通过getElementById()取值 2012-08-0-29 ypc 修改 -->

<input type=hidden name="requestid" id="requestid" value=<%=requestid%>>           <!--请求id-->
<input type=hidden name="workflowid" id="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" id="workflowtype" value="<%=workflowtype%>">       <!--工作流类型-->
<input type=hidden name="nodeid" id="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" id="nodetype" value="<%=nodetype%>">                     <!--当前节点类型-->
<input type=hidden name="src">                                <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" id="iscreate" value="0">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" id="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="isbill" id="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name="billid" id="billid" value="<%=billid%>">             <!--单据id-->

<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->
<input type=hidden name ="topage" id="topage" value="<%=topage%>">				<!--返回的页面-->
<input type=hidden name ="needcheck" id="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" id="inputcheck" value="">

<input type=hidden name ="isMultiDoc" id="isMultiDoc" value=""><!--多文档新建-->

<input type=hidden name="rand" id="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" id="needoutprint" value="">
<iframe name="delzw" width=0 height=0 style="border:none"></iframe>

<script language="javascript">

//默认大小
var uploadImageMaxSize = <%=maxUploadImageSize%>;
var uploaddocCategory="<%=docCategory%>";
var uploadCategorys=new Array();
//填充选择目录的附件大小信息
var selectValues = new Array();
var maxUploads = new Array();
function setMaxUploadInfo()
{
<%if (secMaxUploads != null && secMaxUploads.size() > 0) {
				Set selectValues = secMaxUploads.keySet();

				for (Iterator i = selectValues.iterator(); i.hasNext();) {
					String value = (String) i.next();
					String maxUpload = (String) secMaxUploads.get(value);
					String uplCategory = (String) secCategorys.get(value);%>
		selectValues.push('<%=value%>');
		maxUploads.push('<%=maxUpload%>');
        uploadCategorys.push('<%=uplCategory%>');
<%}
			}%>
}
setMaxUploadInfo();
//目录发生变化时，重新检测文件大小
function reAccesoryChanage()
{
	<%for (int i = 0; i < uploadfieldids.size(); i++) {%>
    checkfilesize(oUpload<%=uploadfieldids.get(i)%>,uploadImageMaxSize,uploaddocCategory);
    showmustinput(oUpload<%=uploadfieldids.get(i)%>);
    <%}%>
}
//选择目录时，改变对应信息
function changeMaxUpload(fieldid)
{
	var efieldid = $GetEle(fieldid);
	if(efieldid)
	{
		var tselectValue = efieldid.value;
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == tselectValue)
			{
				uploadImageMaxSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		if(tselectValue=="")
		{
			uploadImageMaxSize = 5;
		}
		var euploadspans = document.getElementsByTagName("SPAN");
		if(euploadspans)
		{
			for(var j=0;j<euploadspans.length;j++)
			{
				var euploadid = euploadspans[j].id;
				if(euploadid&&euploadid=="uploadspan")
				{
					euploadspans[j].innerHTML = "(<%=SystemEnv.getHtmlLabelName(18976, user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(18977, user.getLanguage())%>)";
				}
			}
		}
	}
}
function funcClsDateTime(){
	//var onlstr = new clsDateTime();
}                

if (window.addEventListener){
    window.addEventListener("load", funcClsDateTime, false);
}else if (window.attachEvent){
    window.attachEvent("onload", funcClsDateTime);
}else{
    window.onload=funcClsDateTime;
}

<%=bodychangattrstr%>
<%String isFormSignature = null;
			RecordSet
					.executeSql("select isFormSignature from workflow_flownode where workflowId="
							+ workflowid + " and nodeId=" + nodeid);
			if (RecordSet.next()) {
				isFormSignature = Util.null2String(RecordSet
						.getString("isFormSignature"));
			}%>
function createDoc(fieldbodyid,docVlaue,isedit)
{
	
	/*
   for(i=0;i<=1;i++){
  		parent.$GetEle("oTDtype_"+i).background="/images/tab2.png";
  		parent.$GetEle("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$GetEle("oTDtype_1").background="/images/tab.active2.png";
  	parent.$GetEle("oTDtype_1").className="cycleTDCurrent";
	*/
  	if("<%=isremark%>"==9||"<%=isremark%>"==5||<%=!editbodyactionflag%>){
  		$GetEle("frmmain").action = "RequestDocView.jsp?requestid=<%=requestid%>&docValue="+docVlaue;
  	}else{
  		$GetEle("frmmain").action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docVlaue+"&isFromEditDocument=true";
  	}
	$GetEle("frmmain").method.value = "crenew_"+fieldbodyid ;
	$GetEle("frmmain").target="delzw";
    parent.delsave();
	if(check_form($GetEle("frmmain"),'requestname')){
		if( $GetEle("needoutprint"))  $GetEle("needoutprint").value = "1";//标识点正文
		$GetEle("src").value='save';
		$GetEle("isremark").value='0';

//保存签章数据
<%if ("1".equals(isFormSignature)) {%>
	                    if(SaveSignature()){
                            //附件上传
                            StartUploadAll();
                            checkuploadcompletBydoc();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614, user
								.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423, user
								.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442, user
								.getLanguage())%>");
							}
							return ;
						}
<%} else {%>
        //附件上传
        StartUploadAll();
        checkuploadcompletBydoc();
<%}%>

    }


}

function openDocExt(showid,versionid,docImagefileid,isedit){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

	// isAppendTypeField参数标识  当前字段类型是附件上传类型，不论该附件所在文档内容是否为空、或者存在最新版本，在该链接打开页面永远打开该附件内容、不显示该附件所在文档内容。
	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&isAppendTypeField=1");
	}
}

function openAccessory(fileId){ 
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>");
}

function onNewDoc(fieldid) {
	$GetEle("frmmain").action = "RequestOperation.jsp" ;
	$GetEle("frmmain").method.value = "docnew_"+fieldid ;
	$GetEle("frmmain").isMultiDoc.value = fieldid ;
	$GetEle("frmmain").src.value='save';
    //附件上传
        StartUploadAll();
        checkuploadcomplet();
}

function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else
                return true;
            }
            }
        else
        return true;
        }
}


function checktimeok(){         <!-- 结束日期不能小于开始日期 -->
    if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && $GetEle("<%=newenddate%>").value != "")
    {
        YearFrom=$GetEle("<%=newfromdate%>").value.substring(0,4);
        MonthFrom=$GetEle("<%=newfromdate%>").value.substring(5,7);
        DayFrom=$GetEle("<%=newfromdate%>").value.substring(8,10);
        YearTo=$GetEle("<%=newenddate%>").value.substring(0,4);
        MonthTo=$GetEle("<%=newenddate%>").value.substring(5,7);
        DayTo=$GetEle("<%=newenddate%>").value.substring(8,10);
        if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
            window.alert("<%=SystemEnv.getHtmlLabelName(15273, user.getLanguage())%>");
            return false;
        }
    }
    return true;
}

function datainput(parfield){                <!--数据导入-->
      //var xmlhttp=XmlHttp.create();
      var detailsum="0";
      try{
          detailsum=$GetEle("detailsum").value;
      }catch(e){ detailsum="0";}
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum="+detailsum+"&trg="+parfield;
      <%if (!trrigerfield.trim().equals("")) {
				ArrayList Linfieldname = ddi.GetInFieldName();
				ArrayList Lcondetionfieldname = ddi.GetConditionFieldName();
				for (int i = 0; i < Linfieldname.size(); i++) {
					String temp = (String) Linfieldname.get(i);%>
          if($GetEle("<%=temp.substring(temp.indexOf("|") + 1)%>")) StrData+="&<%=temp%>="+$GetEle("<%=temp.substring(temp.indexOf("|") + 1)%>").value;
      <%}
				for (int i = 0; i < Lcondetionfieldname.size(); i++) {
					String temp = (String) Lcondetionfieldname.get(i);%>
          if($GetEle("<%=temp.substring(temp.indexOf("|") + 1)%>")) StrData+="&<%=temp%>="+$GetEle("<%=temp.substring(temp.indexOf("|") + 1)%>").value;
      <%}
			}%>
      //alert(StrData);
      $GetEle("datainputform").src="DataInputFrom.jsp?"+StrData;
      //xmlhttp.open("POST", "DataInputFrom.jsp", false);
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }
function getWFLinknum(wffiledname){
    if($GetEle(wffiledname) != null){
        return $GetEle(wffiledname).value;
    }else{
        return 0;
    }
}

function changeKeyword(){
<%if (titleFieldId > 0 && keywordFieldId > 0) {%>
	    var titleObj= $GetEle("field<%=titleFieldId%>");
	    var keywordObj= $GetEle("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		     $GetEle("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordDataEscape&docTitle="+escape(URLencode(titleObj.value))+"&docKeyword="+escape(URLencode(keywordObj.value));
	    }
<%} else if (titleFieldId == -3 && keywordFieldId > 0) {%>
	    var titleObj= $GetEle("requestname");
	    var keywordObj= $GetEle("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		     $GetEle("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordDataEscape&docTitle="+escape(URLencode(titleObj.value))+"&docKeyword="+escape(URLencode(keywordObj.value));
	    }
<%}%>
}

function URLencode(sStr) 
{	
	   return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F'); 
}
function updateKeywordData(strKeyword){
<%if (keywordFieldId > 0) {%>
	var keywordObj= $GetEle("field<%=keywordFieldId%>");

    var keywordismand=<%=keywordismand%>;
    var keywordisedit=<%=keywordisedit%>;

	if(keywordObj!=null){
		if(keywordisedit==1){
			keywordObj.value=strKeyword;
			if(keywordismand==1){
				checkinput('field<%=keywordFieldId%>','field<%=keywordFieldId%>span');
			}
		}else{
			keywordObj.value=strKeyword;
			field<%=keywordFieldId%>span.innerHTML=strKeyword;
		}

	}
<%}%>
}


function onShowKeyword(isbodymand){
<%if (keywordFieldId > 0) {%>
	var keywordObj= $GetEle("field<%=keywordFieldId%>");
	if(keywordObj!=null){
		strKeyword=keywordObj.value;
        tempUrl=escape("/docs/sendDoc/WorkflowKeywordBrowserMulti.jsp?strKeyword="+strKeyword);
		tempUrl=tempUrl.replace(/%A0/g,'%20');
        returnKeyword=window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+tempUrl);
        
		if(typeof(returnKeyword)!="undefined"){
			keywordObj.value=returnKeyword;
			if(isbodymand==1){
				checkinput('field<%=keywordFieldId%>','field<%=keywordFieldId%>span');
			}
		}
	}
<%}%>
}
function uescape(url){
    return escape(url);
}
//** iframe自动适应页面 **//

    function dyniframesize()
    {
    var dyniframe;
    <%for (int i = 0; i < managefckfields_body.size(); i++) {%>
    if (document.getElementById)
    {
        //自动调整iframe高度
        dyniframe =  $GetEle("<%=managefckfields_body.get(i)%>");
        if (dyniframe && !window.opera)
        {
            if (dyniframe.contentDocument && dyniframe.contentDocument.body.offsetHeight){ //如果用户的浏览器是NetScape
                dyniframe.height = dyniframe.contentDocument.body.offsetHeight+20;
            }else if (dyniframe.Document && dyniframe.Document.body.scrollHeight){ //如果用户的浏览器是IE
                //alert(dyniframe.name+"|"+dyniframe.Document.body.scrollHeight);
                dyniframe.Document.body.bgColor="transparent";
                dyniframe.height = dyniframe.Document.body.scrollHeight+20;
            }
        }
    }
    <%}%>
    <%if (fieldids.size() < 1) {%>
    alert("<%=SystemEnv.getHtmlLabelName(22577, user
								.getLanguage())%>");
    <%}%>
    }
    
    if (window.addEventListener)
    window.addEventListener("load", dyniframesize, false);
    else if (window.attachEvent)
    window.attachEvent("onload", dyniframesize);
    else
    window.onload=dyniframesize;

    function changeChildField(obj, fieldid, childfieldid){
        var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+obj.value;
        $GetEle("selectChange").src = "SelectChange.jsp?"+paraStr;
        //alert($GetEle("selectChange").src);
    }
    function doInitChildSelect(fieldid,pFieldid,finalvalue){
    	try{
    		var pField = $GetEle("field"+pFieldid);
    		if(pField != null){
    			var pFieldValue = pField.value;
    			if(pFieldValue==null || pFieldValue==""){
    				return;
    			}
    			if(pFieldValue!=null && pFieldValue!=""){
    				var field = $GetEle("field"+fieldid);
    			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
    				$GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
    			}
    		}
    	}catch(e){}
    }
    <%=selectInitJsStr%>

<%ArrayList currentdateList = Util.TokenizerString(currentdate, "-");
			int departmentId = Util.getIntValue(ResourceComInfo
					.getDepartmentID("" + creater), -1);
			int subCompanyId = Util.getIntValue(DepartmentComInfo1
					.getSubcompanyid1("" + departmentId), -1);
			int supSubCompanyId = Util.getIntValue(SubCompanyComInfo1
					.getSupsubcomid("" + subCompanyId), -1);
			if (supSubCompanyId <= 0) {
				supSubCompanyId = subCompanyId;//若上级分部为空，则认为上级分部为分部
			}%>

    var workflowId=<%=workflowid%>;
    var formId=<%=formid%>;
    var isBill=<%=isbill%>;
	var yearId=-1;
	var monthId=-1;
	var dateId=-1;
	var fieldId=-1;
	var fieldValue=-1;
	var supSubCompanyId=-1;
	var subCompanyId=-1;
	var departmentId=-1;
	var recordId=-1;
	//发文字号初始值取得(TD18867)
	var hasinitfieldvalue=false
	var initfieldValue = -1;
	if( $GetEle("field<%=fieldCode%>")!=null&& $GetEle("field<%=fieldCode%>span")!=null){
		if(!hasinitfieldvalue) {
			initfieldvalue =  $GetEle("field<%=fieldCode%>").value;
			hasinitfieldvalue = true;
		}
	}

	var yearFieldValue=-1;
    var yearFieldHtmlType=-1;
	var monthFieldValue=-1;
	var dateFieldValue=-1;	

function initDataForWorkflowCode(){
	yearId=-1;
	monthId=-1;
	dateId=-1;
	fieldId=-1;
	fieldValue=-1;
	supSubCompanyId=-1;
	subCompanyId=-1;
	departmentId=-1;
	recordId=-1;

	yearFieldValue=-1;
	yearFieldHtmlType="<%=yearFieldHtmlType%>";
	monthFieldValue=-1;
	dateFieldValue=-1;	

	if( $GetEle("field<%=yearFieldId%>")!=null){
		if(yearFieldHtmlType==5){//年份为下拉框
		  try{
			  objYear= $GetEle("field<%=yearFieldId%>");
			  yearId=objYear.options[objYear.selectedIndex].text; 
		  }catch(e){
		  }
		}else{
		    yearFieldValue= $GetEle("field<%=yearFieldId%>").value;
		    if(yearFieldValue.indexOf("-")>0){
			    var yearFieldValueArray = yearFieldValue.split("-") ;
			    if(yearFieldValueArray.length>=1){
				    yearId=yearFieldValueArray[0];
			    }
		    }else{
			    yearId=yearFieldValue;
		    }
		}
	}

	if( $GetEle("field<%=monthFieldId%>")!=null){
		monthFieldValue= $GetEle("field<%=monthFieldId%>").value;
		if(monthFieldValue.indexOf("-")>0){
			var monthFieldValueArray = monthFieldValue.split("-") ;
			if(monthFieldValueArray.length>=2){
				yearId=monthFieldValueArray[0];
				monthId=monthFieldValueArray[1];
			}
		}
	}

	if( $GetEle("field<%=dateFieldId%>")!=null){
		dateFieldValue= $GetEle("field<%=dateFieldId%>").value;
		if(dateFieldValue.indexOf("-")>0){
			var dateFieldValueArray = dateFieldValue.split("-") ;
			if(dateFieldValueArray.length>=3){
				yearId=dateFieldValueArray[0];
				monthId=dateFieldValueArray[1];
				dateId=dateFieldValueArray[2];
			}
		}
	}

<%if (currentdateList.size() >= 1) {%>
	    if(yearId==""||yearId<=0){
	        yearId=<%=(String) currentdateList.get(0)%>;
        }
<%}%>
<%if (currentdateList.size() >= 2) {%>
	    if(monthId==""||monthId<=0){
	        monthId=<%=(String) currentdateList.get(1)%>;
        }
<%}%>
<%if (currentdateList.size() >= 3) {%>
	    if(dateId==""||dateId<=0){
	        dateId=<%=(String) currentdateList.get(2)%>;
        }
<%}%>

	if( $GetEle("field<%=fieldIdSelect%>")!=null){
		fieldId=<%=fieldIdSelect%>;
		fieldValue= $GetEle("field<%=fieldIdSelect%>").value;
	}

	if( $GetEle("field<%=supSubCompanyFieldId%>")!=null){
		supSubCompanyId= $GetEle("field<%=supSubCompanyFieldId%>").value;
	}
	if(supSubCompanyId==""||supSubCompanyId<=0){
	    supSubCompanyId=<%=supSubCompanyId%>;
	}
    
	if( $GetEle("field<%=subCompanyFieldId%>")!=null){
		subCompanyId= $GetEle("field<%=subCompanyFieldId%>").value;
	}
	if(subCompanyId==""||subCompanyId<=0){
	    subCompanyId=<%=subCompanyId%>;
	}

	if( $GetEle("field<%=departmentFieldId%>")!=null){
		departmentId= $GetEle("field<%=departmentFieldId%>").value;
	}
	if(departmentId==""||departmentId<=0){
	    departmentId=<%=departmentId%>;
	}
}

//发文字号变更(TD18867)
function onChangeCode(ismand){
	if( $GetEle("field<%=fieldCode%>")!=null&& $GetEle("field<%=fieldCode%>span")!=null){
		initDataForWorkflowCode();
		if( $GetEle("field<%=fieldCode%>").value == "" ||  $GetEle("field<%=fieldCode%>").value == initfieldvalue) {
			return;
		} else {
        	$GetEle("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=ChangeCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&ismand="+ismand+"&returnCodeStr="+ $GetEle("field<%=fieldCode%>").value +"&oldCodeStr="+initfieldvalue;
        }
	}
}

function onCreateCodeAgain(ismand){
	if( $GetEle("field<%=fieldCode%>")!=null&& $GetEle("field<%=fieldCode%>span")!=null){
        initDataForWorkflowCode();
        $GetEle("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=CreateCodeAgain&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&ismand="+ismand;
	}
}
function onCreateCodeAgainReturn(newCode,ismand){

		if(typeof(newCode)!="undefined"&&newCode!=""){
			 $GetEle("field<%=fieldCode%>").value=newCode;
			 $GetEle("field<%=fieldCode%>span").innerHTML = "";
			//发文字号重新赋值(TD18867)
			initfieldvalue = newCode;

			if(parent.document.getElementById("requestmarkSpan")!=null){
				parent.document.getElementById("requestmarkSpan").innerText=newCode;
			}

			if( $GetEle("requestmarkSpan")!=null){
				 $GetEle("requestmarkSpan").innerText=newCode;
			}

		}

}

function onChooseReservedCode(ismand){
	if( $GetEle("field<%=fieldCode%>")!=null&& $GetEle("field<%=fieldCode%>span")!=null){
        initDataForWorkflowCode();
        url=uescape("/workflow/workflow/showChooseReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
	    con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "" , "dialogWidth=550px;dialogHeight=550px");

		if(typeof(con)!="undefined"&&con!=""){
			$GetEle("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=chooseReservedCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&codeSeqReservedIdAndCode="+con+"&ismand="+ismand;	
		}	
	}

}

function onNewReservedCode(ismand){
    initDataForWorkflowCode();
    url=uescape("/workflow/workflow/showNewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
	con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth=550px;dialogHeight=550px");
}
</script>
<script type="text/javascript">
function onShowBrowser3(id,url,linkurl,type1,ismand) {
	onShowBrowser2(id, url, linkurl, type1, ismand, 3);
}

function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag) {
	var id1 = null;
	
    if (type1 == 9  && "<%=docFlags%>" == "1" ) {
        if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
        	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
        } else {
	    	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
        }
	}
	
	if (type1 == 23) {
		url += "?billid=<%=formid%>";
	}
	if (type1 == 226||type1 == 227) {
		if(id.split("_")[1]){
			//zzl-拼接行号
			url += "_"+id.split("_")[1];
		}
	}
	if (type1 == 2 || type1 == 19 ) {
	    spanname = "field" + id + "span";
	    inputname = "field" + id;
	    
		if (type1 == 2) {
			onFlownoShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand);
		}
	} else {
	    if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170) {
	    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
	    		id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
	    	} else {
			    if (type1 == 161) {
				    id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
				} else {
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
	    	}
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) {
	        //type1 = 167 是:分权单部门-分部 不应该包含在这里面 ypc 2012-09-06 修改
	        } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 162 ) {
				tmpids = $GetEle("field"+id).value;

				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			} else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&isbill=<%=isbill%>&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle("field"+id).value+"&selectedids="+$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&isbill=<%=isbill%>&resourceids=" + $GetEle("field" + id).value+"&selectedids="+$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else {
		        tmpids = $GetEle("field" + id).value;
		        if (tmpids == "NULL" || tmpids == "Null" || tmpids == "null") {
		        	tmpids = "";
		        }
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
		
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""

					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					var tlinkurl = linkurl;
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];

						if (type1 == 171 || type1 == 152) {
	                        linkno = getWFLinknum("slink" + id + "_rq" + curid);
	                        if (linkno>0) {
	                        	curid = curid + "&wflinkno=" + linkno;
							} else {
	                        	tlinkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid="
							}
						}
						
						if (tlinkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + tlinkurl + curid + " target=_new>" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field"+id+"span").innerHTML = sHtml;
					$GetEle("field"+id).value= resourceids;
				} else {
 					if (ismand == 0) {
 						$GetEle("field"+id+"span").innerHTML = "";
 					} else {
 						$GetEle("field"+id+"span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
 					}
 					$GetEle("field"+id).value = "";
				}

			} else {
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						sHtml = ""
						ids = ids.substr(1);
						$GetEle("field"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							//sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
							if(href==''){
								sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
							}else{
								sHtml += "<a title='" + curdesc + "' href='" + href + curid + "' target='_blank'>" + curname + "</a>&nbsp";
							}
						}
						
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
					   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						$GetEle("field"+id).value = ids;
						//sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						if(href==''){
							sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						}else{
							sHtml = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
						}
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return ;
				   }

				   if (type1 == 16) {
					   curid = wuiUtil.getJsonValueByIndex(id1, 0);
                   	   linkno = getWFLinknum("slink" + id + "_rq" + curid);
	                   if (linkno>0) {
	                       curid = curid + "&wflinkno=" + linkno;
	                   } else {
	                       linkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid=";
	                   }
	                   $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
					   if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
						   $GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(e);'>" + wuiUtil.getJsonValueByIndex(id1, 1)+ "</a>&nbsp";
					   } else {
	                       $GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + curid + " target='_new'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
					   }
	                   return;
				   }
				   
	               if (type1 == 9 && "<%=docFlags%>" == "1" && (funFlag == undefined || funFlag != 3)) {
		                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
		                $GetEle("field" + id + "span").innerHTML = "<a href='#' onclick=\"createDoc(" + id + ", " + tempid + ", 1)\">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=\"button\" id=\"createdoc\" style=\"display:none\" class=\"AddDocFlow\" onclick=\"createDoc(" + id + ", " + tempid + ",1)\"></button>";
	               } else {
	            	    if (linkurl == "") {
				        	$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
				        } else {
							if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
								$GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
							} else {
								$GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
							}
				        }
	               }
	               $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
	                if (type1 == 9 && "<%=docFlags%>" == "1" && (funFlag == undefined || funFlag != 3)) {
	                	var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("");
	                }
			   } else {
					if (ismand == 0) {
						$GetEle("field"+id+"span").innerHTML = "";
					} else {
						$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>"
					}
					$GetEle("field"+id).value="";
					if (type1 == 9 && "<%=docFlags%>" == "1" && (funFlag == undefined || funFlag != 3)) {
						var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%></button>");
					}
			   }
			}
		}
	}
}

function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("field" + id).value;
	url = url + roleid + "_" + tmpids;

	id1 = window.showModalDialog(url);
	if (id1) {

		if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";

			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);

			$GetEle("field" + id).value = resourceids;

			var idArray = resourceids.split(",");
			var nameArray = resourcename.split(",");
			for ( var _i = 0; _i < idArray.length; _i++) {
				var curid = idArray[_i];
				var curname = nameArray[_i];

				sHtml = sHtml + "<a href=" + linkurl + curid
						+ " target='_new'>" + curname + "</a>&nbsp";
			}

			$GetEle("field" + id + "span").innerHTML = sHtml;

		} else {
			if (ismand == 0) {
				$GetEle("field" + id + "span").innerHTML = "";
			} else {
				$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			}
			$GetEle("field" + id).value = "";
		}
	}
}

function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {

	var tmpids = $GetEle("field" + id).value;
	var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	if (dialogId) {
		if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
			var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
			var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
			var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
			var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
			var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
			var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
			var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
			var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);

			var sHtml = "";
			var fileIdValue = "";
			shareTypeValues = shareTypeValues.substr(1);
			shareTypeTexts = shareTypeTexts.substr(1);
			relatedShareIdses = relatedShareIdses.substr(1);
			relatedShareNameses = relatedShareNameses.substr(1);
			rolelevelValues = rolelevelValues.substr(1);
			rolelevelTexts = rolelevelTexts.substr(1);
			secLevelValues = secLevelValues.substr(1);
			secLevelTexts = secLevelTexts.substr(1);

			var shareTypeValueArray = shareTypeValues.split("~");
			var shareTypeTextArray = shareTypeTexts.split("~");
			var relatedShareIdseArray = relatedShareIdses.split("~");
			var relatedShareNameseArray = relatedShareNameses.split("~");
			var rolelevelValueArray = rolelevelValues.split("~");
			var rolelevelTextArray = rolelevelTexts.split("~");
			var secLevelValueArray = secLevelValues.split("~");
			var secLevelTextArray = secLevelTexts.split("~");
			for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {

				var shareTypeValue = shareTypeValueArray[_i];
				var shareTypeText = shareTypeTextArray[_i];
				var relatedShareIds = relatedShareIdseArray[_i];
				var relatedShareNames = relatedShareNameseArray[_i];
				var rolelevelValue = rolelevelValueArray[_i];
				var rolelevelText = rolelevelTextArray[_i];
				var secLevelValue = secLevelValueArray[_i];
				var secLevelText = secLevelTextArray[_i];

				fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
						+ relatedShareIds + "_" + rolelevelValue + "_"
						+ secLevelValue;

				if (shareTypeValue == "1") {
					sHtml = sHtml + "," + shareTypeText + "("
							+ relatedShareNames + ")";
				} else if (shareTypeValue == "2") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
				} else if (shareTypeValue == "3") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
				} else if (shareTypeValue == "4") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="
							+ rolelevelText
							+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
				} else {
					sHtml = sHtml
							+ ","
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
				}

			}
			
			sHtml = sHtml.substr(1);
			fileIdValue = fileIdValue.substr(1);

			$GetEle("field" + id).value = fileIdValue;
			$GetEle("field" + id + "span").innerHTML = sHtml;
		}
	} else {
		if (ismand == 0) {
			$GetEle("field" + id + "span").innerHtml = "";
		} else {
			$GetEle("field" + id + "span").innerHtml = "<img src='/images/BacoError.gif' align=absmiddle>";
		}
		$GetEle("field" + id).value = "";
	}
}

</script>

<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<script type="text/javascript" src="/js/selectDateTime.js"></script>