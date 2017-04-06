<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workflow.dmlaction.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="DMLActionBase" class="weaver.formmode.interfaces.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.formmode.interfaces.dmlaction.commands.bases.FieldBase" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user))
{
	response.sendRedirect("/notice/noright.jsp");
	
	return;
}
%>
<%
	String operate = Util.null2String(request.getParameter("operate"));
	int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
	int modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")),0);
	int expandid = Util.getIntValue(Util.null2String(request.getParameter("expandid")),0);
	DMLActionBase.setActionid(actionid);
	DMLActionBase.initDMLAction();
	boolean isexists = DMLActionBase.isIsexists();
	if(!isexists)
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	//dmlactionname,dmlorder,workflowId,nodeid,ispreoperator,nodelinkid,datasourceid,dmltype
	
	String modename = "";
	String isbill = "1";
	String formid = "";
	String sql = "select modename,formid from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		formid = Util.null2String(rs.getString("formid"));
		modename = Util.null2String(rs.getString("modename"));
	}
	
	String actionname = "";
	int dmlorder = 0;
	int workflowId = 0;
	//数据源
	String datasourceid = "";
	//是否需要选择数据源
	boolean needcheckds = true;
	if(user.getUID()==1)
	{
		needcheckds = false;
	}
	//操作类型
	String dmltype = "";
	//节点id
	int nodeid = 0;
	//是否节点后附加操作
	String ispreoperator = "";
	//节点出口id
	int nodelinkid = 0;
	if(!"changetable".equals(operate))
	{
		actionname = DMLActionBase.getActionname();
		dmlorder = DMLActionBase.getDmlorder();
		workflowId = DMLActionBase.getWorkflowId();
		//数据源
		datasourceid = DMLActionBase.getDatasourceid();
		//操作类型
		dmltype = DMLActionBase.getDmltype();
		//节点id
		nodeid = DMLActionBase.getNodeid();
		//是否节点后附加操作
		ispreoperator = DMLActionBase.getIspreoperator();
		//节点出口id
		nodelinkid = DMLActionBase.getNodelinkid();
	}
	else
	{
		actionname = Util.null2String(request.getParameter("actionname"));
		dmlorder = Util.getIntValue(Util.null2String(request.getParameter("dmlorder")),0);
		
		workflowId = Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
		//数据源
		datasourceid = Util.null2String(request.getParameter("datasourceid"));
		//操作类型
		dmltype = Util.null2String(request.getParameter("dmltype"));
		//节点id
		nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
		//是否节点后附加操作
		ispreoperator = Util.null2String(request.getParameter("ispreoperator"));
		//节点出口id
		nodelinkid = Util.getIntValue(Util.null2String(request.getParameter("nodelinkid")),0);
	}
	
	//actionid,actiontable,dmlformid,dmlformname,dmlisdetail," +
	//dmltablename,dmltablebyname,dmlsql,dmlfieldtypes,dmlfieldnames,dmlothersql,dmlotherfieldtypes," +
	//dmlotherfieldnames,dmlcuswhere,dmlcussql
	int actionsqlsetid = 0;
	
	String actiontable = "";
	//表单id
	int dmlformid = 0;
	//表单名称
	String dmlformname = "";
	//是否为明细
	String dmlisdetail = "";
	//对应表名称
	String dmltablename = "";
	//表别名
	String dmltablebyname = "";
	//自定义条件
	String dmlcuswhere = "";
	//指定sql类型
	String dmlmainsqltype = "";
	//指定sql
	String dmlcussql = "";
	String maintablename = DMLActionBase.getActiontable();
	Map dmlMap = DMLActionBase.getDmlMap();
	Map fieldMap = DMLActionBase.getFieldMap();
	Map whereMap = DMLActionBase.getWhereMap();
	String dbtype = DBTypeUtil.getDataSourceDbtype(RecordSet,datasourceid);
	//外部表字段以及类型
	Map allcolnums = new HashMap();
	//字段列表
	List fieldList = new ArrayList();
	Map fieldDBTypeMap = new HashMap();
	//字段标签列表
	Map fieldLabelMap = new HashMap();
	//字段名列表
	Map fieldNameMap = new HashMap();
%>
<html>
	<head>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver.js"></script>
		<STYLE TYPE="text/css">
		.btn_actionList
		{
			BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
		} 
		</STYLE>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	</head>
	<%
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = SystemEnv.getHtmlLabelName(26418, user.getLanguage()); //配置接口动作(数据库DML)
		String needfav = "1";
		String needhelp = "";
	%>
	<body>
		<%@ include file="/systeminfo/TopTitle.jsp"%>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/workflow/dmlaction/DMLActionSettingView.jsp?actionid="+actionid+",_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		<form name="frmmain" method="post" action="DMLActionSettingOperation.jsp">
			<input type="hidden" id="operate" name="operate" value="edit">
			<input type="hidden" id="actionid" name="actionid" value="<%=actionid %>">
			<input type="hidden" id="expandid" name="expandid" value="<%=expandid %>">
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<table class=viewform cellspacing=1>
										<colgroup>
											<col width="15%">
											<col width="85%">
										<tbody>
											<tr class=spacing>
												<td class=Sep1 colSpan=2></td>
											</tr>
											<tr>
												<td class=line colspan=2>
												<td>
											</tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
												<td class=field>
													<input type=text size=35 class=inputstyle maxlength=20 id="actionname" name="actionname" value="<%=actionname%>" onChange="checkinput('actionname','actionnamespan')">
													<span id="actionnamespan">
														<%
															if (actionname.equals(""))
															{
														%>
														<img src="/images/BacoError.gif" align=absmiddle>
														<%
															}
														%>
													</span>
												</td>
											</tr>
											<tr>
												<td class=line colspan=2></td>
											</tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(28485, user.getLanguage())%></td>
												<td class=field>
													<span id="workflowspan">
														<%=modename%>
													</span>
													<input type="hidden" id="modeid" name="modeid" value="<%=modeid%>">
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%></td><!-- 执行顺序 -->
												<td class=field>
													<input type=text size=35 class=inputstyle id="dmlorder" name="dmlorder" maxlength=10 value="<%=dmlorder%>" onChange="checkinput('dmlorder','dmlorderspan')"  onKeyPress="ItemCount_KeyPress()" onBlur="checknumber1(this);">
													<span id="dmlorderspan">
														<%
															if ((""+dmlorder).equals(""))
															{
														%>
														<img src="/images/BacoError.gif" align=absmiddle>
														<%
															}
														%>
													</span>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(18076, user.getLanguage())%></td>
												<td class=field>
													<select id="datasourceid" name="datasourceid" onchange="ChangeDatasource(this);<%if(needcheckds){ %>checkinput('datasourceid','datasourceidspan');<%} %>">
														<option></option>
														<%
															List datasourceList = DataSourceXML.getPointArrayList();
															for (int i = 0; i < datasourceList.size(); i++)
															{
																String pointid = Util.null2String((String) datasourceList.get(i));
														%>
														<option value="<%=pointid%>" <%if(pointid.equals(datasourceid)){ %>selected<%} %>><%=pointid%></option>
														<%
															}
														%>
													</select>
													<%if(needcheckds){ %>
													<span id="datasourceidspan">
													<%if (datasourceid.equals("")){%>
													<img src="/images/BacoError.gif" align=absmiddle>
													<%} %>
													</span>
													<%} %>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td>DML<%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td><!-- 类型 -->
												<td class=field>
													<select id="dmltype" name="dmltype" onChange="checkinput('dmltype','dmltypespan')">
														<option></option>
														<option value="insert" <%if("insert".equals(dmltype)){ %>selected<%} %>>insert<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></option>
														<option value="update" <%if("update".equals(dmltype)){ %>selected<%} %>>update<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></option>
														<option value="delete" <%if("delete".equals(dmltype)){ %>selected<%} %>>delete<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></option>
													</select>
													<span id="dmltypespan">
													<%if (dmltype.equals("")){%>
													<img src="/images/BacoError.gif" align=absmiddle>
													<%} %>
													</span>
												</td>
											</tr>
											<tr><td class=line1 colspan=2></td></tr>
											<tr>
												<td colspan=2>
												<%
													//流程id，节点id或者出口id，是否需要检查数据源以及是数据源是否为空
													if (modeid>0&&expandid>0)
													{
														String tablesql = "";
														
														List actionSetList = (List)dmlMap.get(maintablename);
														List fieldsList = null;
														List wheresList = null;
														if(null!=actionSetList||"changetable".equals(operate))
														{
															if(!"changetable".equals(operate))
															{
																if(actionSetList.size()>0)
																	actionsqlsetid = Util.getIntValue((String)actionSetList.get(0),0);
																//action数据源表名
																if(actionSetList.size()>1)
																	actiontable = Util.null2String((String)actionSetList.get(1));
																//表单id
																if(actionSetList.size()>2)
																	dmlformid = Util.getIntValue((String)actionSetList.get(2),0);
																//表单名称
																if(actionSetList.size()>3)
																	dmlformname = Util.null2String((String)actionSetList.get(3));
																//是否为明细
																if(actionSetList.size()>4)
																	dmlisdetail = Util.null2String((String)actionSetList.get(4));
																//对应表名称
																if(actionSetList.size()>5)
																	dmltablename = Util.null2String((String)actionSetList.get(5));
																//表别名
																if(actionSetList.size()>6)
																	dmltablebyname = Util.null2String((String)actionSetList.get(6));
																//自定义条件
																if(actionSetList.size()>7)
																	dmlcuswhere = Util.null2String((String)actionSetList.get(7));
																//指定sql类型
																if(actionSetList.size()>8)
																	dmlmainsqltype = Util.null2String((String)actionSetList.get(8));
																//指定sql
																if(actionSetList.size()>9)
																	dmlcussql = Util.null2String((String)actionSetList.get(9));
																
																fieldsList = (List)fieldMap.get(""+actionsqlsetid);
																wheresList = (List)whereMap.get(""+actionsqlsetid);
															}
															else
															{
																actionsqlsetid = Util.getIntValue(Util.null2String(request.getParameter("actionsqlsetid")),0);
																//表单id
																dmlformid = Util.getIntValue(Util.null2String(request.getParameter("dmlformid")),0);
																//表单名称
																dmlformname = Util.null2String(request.getParameter("dmlformname"));
																//是否为明细
																dmlisdetail = Util.null2String(request.getParameter("dmlisdetail"));
																//对应表名称
																dmltablename = Util.null2String(request.getParameter("dmltablename"));
															}
															FieldBase.getDMLActionFields(user,datasourceid,Util.getIntValue(formid,0),Util.getIntValue(isbill,0),0,dmlformid,dmltablename,Util.getIntValue(dmlisdetail,0),needcheckds);
															allcolnums = FieldBase.getAllcolnums();
													%>
													<table width="100%">
														<colgroup>
															<col width="15%">
															<col width="35%">
															<col width="15%">
															<col width="35%">
														<tbody>
															<tr>
																<td><%=SystemEnv.getHtmlLabelName(1995, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778, user.getLanguage())%></td>
																<td class=field>
																	<table width="100%">
																		<colgroup>
																				<col width="50%">
																				<col width="50%">
																		<tbody>
																			<tr>
																				<td id="thisdatasourceid" class=field style="display:<%if(!datasourceid.equals("")||needcheckds){ %>none<%} %>">
																					<BUTTON type='button' class=Browser onClick="onShowTable(dmltablename,dmlformname,dmltablenamespan,dmlformid,dmlisdetail)"></BUTTON>
																					<span id="dmltablenamespan"><%=dmlformname %></span>
																					<input type=hidden id="actionsqlsetid" name="actionsqlsetid" value="<%=actionsqlsetid %>">
																					<input type=hidden id="dmlformid" name="dmlformid" value="<%=dmlformid %>">
																					<input type=hidden id="dmlformname" name="dmlformname" value="<%=dmlformname %>">
																					<input type=hidden id="dmlisdetail" name="dmlisdetail" value="<%=dmlisdetail %>">
																				</td>
																				<td class=field>
																					<input type=text class=Inputstyle size=20 maxlength=50 id="dmltablename" name="dmltablename" value="<%=dmltablename %>"	onBlur='checkinput_char_num("dmltablename");' onchange="javascript:changeTableField();checkinput('dmltablename','dmltablenamespans');"><span id="dmltablenamespans"><%if (dmltablename.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%} %></span>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
																<td><%=SystemEnv.getHtmlLabelName(81344, user.getLanguage())%></td><!-- 流程主表 -->
																<td class=field>
																	<%=maintablename %>
																	<input type=hidden id="maintablename" name="maintablename" value="<%=maintablename %>">
																</td>
															</tr>
															<tr>
																<td class=line colspan=4></td>
															</tr>
															<tr class='Title'>
																<th>DML<%=SystemEnv.getHtmlLabelName(18020, user.getLanguage())%></th><!-- 主表字段 -->
																<td class=field align=right>
																	<DIV align=right>
																		<BUTTON type='button' class=btn_actionList onclick=addRow('fieldValueTableTr','dml');><SPAN id=addrowspan><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></SPAN></BUTTON><!-- 增加 -->
																		&nbsp;&nbsp;
																		<BUTTON type='button' class=btn_actionList onclick=delRow('fieldValueTableTr','dmlcheck');><SPAN id=delrowspan><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></SPAN></BUTTON><!-- 删除 -->
																	</DIV>
																</td>
																<th><%=SystemEnv.getHtmlLabelName(81345, user.getLanguage())%></th><!-- 流程主表字段 -->
																<td class=field align=right><a href="#" onclick="showTableFieldDiv('fieldValueTableT',this);">[<%=SystemEnv.getHtmlLabelName(27669, user.getLanguage())%>]</a></td>
															</tr>
															<tr><td class=line1 colspan=4></td></tr>
													<%
													allcolnums = FieldBase.getAllcolnums();
													//字段列表
													fieldList = FieldBase.getFieldList();
													if(null!=fieldList&&fieldList.size()>0)
													{
														//字段类型列表
														fieldDBTypeMap = FieldBase.getFieldDBTypeMap();
														//字段标签列表
														fieldLabelMap = FieldBase.getFieldLabelMap();
														//字段名列表
														fieldNameMap = FieldBase.getFieldNameMap();
													%>
															<tr>
																<td colspan=4>
																	<div id="propDiv">
																		<table width="100%" class='ViewForm' cellpadding="0" cellspacing="0">
																			<colgroup>
																				<col width="20%">
																				<col width="30%">
																				<col width="20%">
																				<col width="30%">
																			<tbody>
																				<tr id='fieldValueTable'>
																					<td colspan=2 vAlign="top">
																						<table width="100%" class='liststyle' id="fieldValueTableTr" style="padding:0px;margin:0px;" cellpadding="0" cellspacing="0">
																							<colgroup>
																								<col width="10%">
																								<col width="30%">
																								<col width="30%">
																								<col width="30%">
																							<tbody>
																								<tr class=Header>
																									<td>&nbsp;&nbsp;&nbsp;</td>
																									<td><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></td><!-- 字段名称 -->
																									<td><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></td><!-- 字段类型 -->
																									<td><%=SystemEnv.getHtmlLabelName(26422, user.getLanguage())%></td><!-- 同步对应字段 -->
																								</tr>
																								<%
																								boolean isright = true;
																								Set columnSet = allcolnums.keySet();
																								for(Iterator i = columnSet.iterator();i.hasNext();)
																								{
																									String fieldname = Util.null2String((String)i.next());
																									String fielddbtype = Util.null2String((String)allcolnums.get(fieldname));
																									boolean iscanhandle = DBTypeUtil.checkFieldDBType(fielddbtype,dbtype);
																									if(!DMLActionBase.isKeyField(fieldsList,fieldname))
																									{
																										continue;
																									}
																								%>
																									<tr style="height:20px;" class="<%=isright?"dataRight":"dataDark" %>">
																										<td><input type=checkbox id='dmlcheck' name='dmlcheck'></td>
																										<td><BUTTON type='button' class=Browser onClick="onShowTableField(this);"></BUTTON><input type=text value="<%=fieldname %>" style="border:0px;" readOnly="true"></td>
																										<td><%=fielddbtype %></td>
																										<td>
																											<select name="dmlfieldname" width="100px;" style='width:100%;' <%if(!iscanhandle){ %>disabled<%} %>>
																												<option></option>
																												<%
																												for(int j = 0;j<fieldList.size();j++)
																												{
																													String jfieldid = (String)fieldList.get(j);
																													String jfieldname = Util.null2String((String)fieldNameMap.get(jfieldid));
																													String jfielddbtype = Util.null2String((String)fieldDBTypeMap.get(jfieldid));
																													String jfieldlabel = Util.null2String((String)fieldLabelMap.get(jfieldid));
																												%>
																												<option value="<%=fieldname %>=<%=fielddbtype %>=<%=jfieldname %>" <%if(null!=fieldsList&&fieldsList.contains(fieldname+"="+fielddbtype+"="+jfieldname)) out.println("selected"); %> title="<%=jfieldlabel %>"><%=jfieldlabel %></option>
																												<%} %>
																											</select>
																										</td>
																									</tr>
																									<tr><td class=line colspan=3></td></tr>
																								<%
																									isright = isright?false:true;
																								}
																								%>
																							</tbody>
																						</table>
																					</td>
																					<td colspan=2 vAlign="top">
																						<table width="100%" class='liststyle' style="padding:0px;margin:0px;" cellpadding="0" cellspacing="0">
																							<colgroup>
																								<col width="40%">
																								<col width="30%">
																								<col width="30%">
																							<tbody>
																								<tr class=Header>
																									<td><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%></td><!-- 字段显示名 -->
																									<td><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></td><!-- 字段名 -->
																									<td><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></td><!-- 字段类型 -->
																								</tr>
																								<tr id=fieldValueTableT>
																									<td colspan=3 style="padding:0px;margin:0px;">
																										<table width="100%" class='liststyle' style="padding:0px;margin:0px;" cellpadding="0" cellspacing="0">
																											<colgroup>
																												<col width="40%">
																												<col width="30%">
																												<col width="30%">
																											<tbody>
																							<%
																							isright = true;
																							for(int i = 0;i<fieldList.size();i++)
																							{
																								String fieldid = (String)fieldList.get(i);
																								String fieldname = Util.null2String((String)fieldNameMap.get(fieldid));
																								String fielddbtype = Util.null2String((String)fieldDBTypeMap.get(fieldid));
																								String fieldlabel = Util.null2String((String)fieldLabelMap.get(fieldid));
																							%>
																								<tr style="height:20px;" class="<%=isright?"dataRight":"dataDark" %>">
																									<td><%=fieldlabel %></td>
																									<td><input type=text value="<%=fieldname %>" style="border:0px;" readOnly="true"></td>
																									<td><%=fielddbtype %></td>
																								</tr>
																								<tr><td class=line colspan=3></td></tr>
																							<%
																								isright = isright?false:true;
																							}
																							%>
																											</tbody>
																										</table>
																									</td>
																								</tr>
																							</tbody>
																						</table>
																					</td>
																				</tr>
																				<tr class='Title'>
																					<th>DML<%=SystemEnv.getHtmlLabelName(26423, user.getLanguage())%></th><!-- 主表条件 -->
																					<td class=field align=right>
																						<DIV align=right>
																							<BUTTON type='button' class=btn_actionList onclick=addRow('fieldWhereTableTr','where');><SPAN id=addrowspan><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></SPAN></BUTTON><!-- 增加 -->
																							&nbsp;&nbsp;
																							<BUTTON type='button' class=btn_actionList onclick=delRow('fieldWhereTableTr','wherecheck');><SPAN id=delrowspan><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></SPAN></BUTTON><!-- 删除 -->
																						</DIV>
																					</td>
																					<th><%=SystemEnv.getHtmlLabelName(81345, user.getLanguage())%></th><!-- 流程主表字段 -->
																					<td class=field align=right><a href="#" onclick="showTableFieldDiv('fieldWhereTableT',this);">[<%=SystemEnv.getHtmlLabelName(27669, user.getLanguage())%>]</a></td>
																				</tr>
																				<tr><td class=line1 colspan=4></td></tr>
																				<tr id='fieldWhereTable'>
																					<td colspan=2 vAlign="top">
																						<table width="100%" class='liststyle' id="fieldWhereTableTr" style="padding:0px;margin:0px;" cellpadding="0" cellspacing="0">
																							<colgroup>
																								<col width="10%">
																								<col width="30%">
																								<col width="30%">
																								<col width="30%">
																							<tbody>
																								<tr class=Header>
																									<td>&nbsp;&nbsp;&nbsp;</td><!-- 字段显示名 -->
																									<td><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></td><!-- 字段名 -->
																									<td><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></td><!-- 字段类型 -->
																									<td><%=SystemEnv.getHtmlLabelName(26424, user.getLanguage())%></td><!-- 条件对应字段 -->
																								</tr>
																								<%
																								isright = true;
																								for(Iterator i = columnSet.iterator();i.hasNext();)
																								{
																									String fieldname = Util.null2String((String)i.next());
																									String fielddbtype = Util.null2String((String)allcolnums.get(fieldname));
																									boolean iscanhandle = DBTypeUtil.checkFieldDBType(fielddbtype,dbtype);
																									if(!DMLActionBase.isKeyField(wheresList,fieldname))
																									{
																										continue;
																									}
																								%>
																									<tr style="height:20px;" class="<%=isright?"dataRight":"dataDark" %>">
																										<td><input type=checkbox id='wherecheck' name='wherecheck'></td>
																										<td><BUTTON type='button' class=Browser onClick="onShowTableField(this);"></BUTTON><input type=text value="<%=fieldname %>" style="border:0px;" readOnly="true"></td>
																										<td><%=fielddbtype %></td>
																										<td>
																											<select name="wherefieldname" width="100px;" style='width:100%;' <%if(!iscanhandle){ %>disabled<%} %>>
																												<option></option>
																												<%
																												for(int j = 0;j<fieldList.size();j++)
																												{
																													String jfieldid = (String)fieldList.get(j);
																													String jfieldname = Util.null2String((String)fieldNameMap.get(jfieldid));
																													String jfielddbtype = Util.null2String((String)fieldDBTypeMap.get(jfieldid));
																													String jfieldlabel = Util.null2String((String)fieldLabelMap.get(jfieldid));
																												%>
																												<option value="<%=fieldname %>=<%=fielddbtype %>=<%=jfieldname %>" <%if(null!=wheresList&&wheresList.contains(fieldname+"="+fielddbtype+"="+jfieldname)) out.println("selected"); %> title="<%=jfieldlabel %>"><%=jfieldlabel %></option>
																												<%} %>
																											</select>
																										</td>
																									</tr>
																									<tr><td class=line colspan=3></td></tr>
																								<%
																									isright = isright?false:true;
																								}
																								%>
																							</tbody>
																						</table>
																					</td>
																					<td colspan=2 vAlign="top">
																						<table width="100%" class='liststyle' style="padding:0px;margin:0px;">
																							<colgroup>
																								<col width="40%">
																								<col width="30%">
																								<col width="30%">
																							<tbody>
																								<tr class=Header>
																									<td><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%></td><!-- 字段显示名 -->
																									<td><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></td><!-- 字段名 -->
																									<td><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></td><!-- 字段类型 -->
																								</tr>
																								<tr id=fieldWhereTableT>
																									<td colspan=3 style="padding:0px;margin:0px;">
																										<table width="100%" class='liststyle' style="padding:0px;margin:0px;" cellpadding="0" cellspacing="0">
																											<colgroup>
																												<col width="40%">
																												<col width="30%">
																												<col width="30%">
																											<tbody>
																							<%
																							isright = true;
																							for(int i = 0;i<fieldList.size();i++)
																							{
																								String fieldid = (String)fieldList.get(i);
																								String fieldname = Util.null2String((String)fieldNameMap.get(fieldid));
																								String fielddbtype = Util.null2String((String)fieldDBTypeMap.get(fieldid));
																								String fieldlabel = Util.null2String((String)fieldLabelMap.get(fieldid));
																							%>
																								<tr style="height:20px;" class="<%=isright?"dataRight":"dataDark" %>">
																									<td><%=fieldlabel %></td>
																									<td><input type=text value="<%=fieldname %>" style="border:0px;" readOnly="true"></td>
																									<td><%=fielddbtype %></td>
																								</tr>
																								<tr><td class=line colspan=3></td></tr>
																							<%
																								isright = isright?false:true;
																							}
																							%>
																											</tbody>
																										</table>
																									</td>
																								</tr>
																							</tbody>
																						</table>
																					</td>
																				</tr>
																				<tr><td class=line colspan=4></td></tr>
																				<tr>
																					<td valign="top"><%=SystemEnv.getHtmlLabelName(26425, user.getLanguage())%></td><!-- 自定义主表条件 -->
																					<td class=field colspan=3>
																						<textarea id="dmlmainwhere" name="dmlmainwhere" cols=100 rows=4><%=dmlcuswhere %></textarea>
																					</td>
																				</tr>
																				<tr><td class=line colspan=4></td></tr>
																				<tr>
																					<td valign="top"><%=SystemEnv.getHtmlLabelName(26426, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td><!-- 自定义主表DML语句类型 -->
																					<td class=field colspan=3>
																						<select id="dmlmainsqltype" name="dmlmainsqltype">
																							<option value="0" <%if("0".equals(dmlmainsqltype)||"".equals(dmlmainsqltype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(27670, user.getLanguage())%></option><!-- sql语句 -->
																							<option value="1" <%if("1".equals(dmlmainsqltype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(27671, user.getLanguage())%></option><!-- 存储过程 -->
																						</select>
																					</td>
																				</tr>
																				<tr><td class=line colspan=4></td></tr>
																				<tr>
																					<td valign="top"><%=SystemEnv.getHtmlLabelName(26426, user.getLanguage())%></td><!-- 自定义主表DML语句 -->
																					<td class=field colspan=3>
																						<textarea id="dmlmainsql" name="dmlmainsql" cols=100 rows=4><%=dmlcussql %></textarea>
																					</td>
																				</tr>
																				<tr><td class=line colspan=4></td></tr>
																			</tbody>
																		</table>
																	</div>
																</td>
															</tr>
														</tbody>
													</table>
												<%
															}
														}
													}
												%>
												</td>
											</tr>
											
										</tbody>
									</table>
									
									<table width="100%" class='ViewForm'>
										<tr class="Title"><th>DML<%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></th></tr><!-- 说明 -->
										<tr><td class=line1></td></tr>
										<tr>
											<td>
												<font color="red">1、<%=SystemEnv.getHtmlLabelName(27673, user.getLanguage())%></font><br><!-- 请谨慎使用update，delete操作 -->
												<font color="green">2、<%=SystemEnv.getHtmlLabelName(27674, user.getLanguage())%></font><br><!-- 只能同步当前流程主表数据的到其他数据表中 -->
												<font color="green">3、<%=SystemEnv.getHtmlLabelName(27675, user.getLanguage())%><br><!-- 如果DML类型为update、delete，那么必须有DML主表条件或者自定义主表条件，否则此DML不被执行 -->
												<font color="maroon">4、<%=SystemEnv.getHtmlLabelName(27676, user.getLanguage())%>：<br><!-- 对各数据库中大对象数据类型字段，以及二进制数据类型字段不做同步，具体如下 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SQLSERVER:binary,varbinary,image<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ORACLE:raw,long raw,blob,clob,nclob,bfile,rowid<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MYSQL:BLOB,ENUM,SET<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DB2:GRAPHIC,VARGRAPHIC,LONG VARCHAR,CLOB,LONG VARGRAPHIC,DBCLOB,BLOB<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SYSBASE:text,image<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INFORMIX:text,byte<br>
												</font>
												<font color="dodgerblue">5、<%=SystemEnv.getHtmlLabelName(27677, user.getLanguage())%>:<br><!-- 对于自定义主表条件，具体格式如下 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;userid={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A} and lastname='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}' and ....<br><!-- 流程字段名称 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(27679, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(27680, user.getLanguage())%>。<br><!-- sql中,以字段名开始(不能以where或者and开始)，{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型决定. -->
												<font color="dodgerblue">6、<%=SystemEnv.getHtmlLabelName(27681, user.getLanguage())%>：<br><!-- 对于自定义主表DML语句，具体格式如下 -->
												</font>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;update hrmresource set lastname='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}',mobile='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}' ... where userid={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>C} and ...<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(27679, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(27682, user.getLanguage())%>。<br><!-- sql中，{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型,以及字段类型决定 -->
												</font>
												<font color="dodgerblue">7、<%=SystemEnv.getHtmlLabelName(27683, user.getLanguage())%>：<br><!-- 由于各数据库中，日期数据类型不同，为保证数据正确同步，建议使用自定义主表DML语句，比如 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;oracle<%=SystemEnv.getHtmlLabelName(15024, user.getLanguage())%>：update hrmresource set b.birthday=to_date('{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}','YYYY-MM-DD') ... where userid={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B} and ...<br>
												</font>
												<font color="dodgerblue">8、<%=SystemEnv.getHtmlLabelName(27684, user.getLanguage())%>:<br><!-- 自定义主表DML语句类型为存储过程时，各数据库调用方式如下(未列出的数据库请参看各数据库帮助) -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;oracle<%=SystemEnv.getHtmlLabelName(15024, user.getLanguage())%>：call procname('{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}','{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}'....)<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sqlserver<%=SystemEnv.getHtmlLabelName(15024, user.getLanguage())%>：EXECUTE procname '{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}','{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}'....<br>
												</font>
											</td>
										</tr>
									</table>
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
	</body>
</html>
<script language="javascript">
var checkfield1 = "";
var checkfield2 = "";
var checkfield3 = "";
<%
if(needcheckds)
{
%>
	checkfield1 = "datasourceid";
	checkfield2 = "dmltablename,datasourceid";
	checkfield3 = "actionname,dmlorder,workflowId,dmltablename,datasourceid";
<%
}
else
{
%>
	checkfield1 = "";
	checkfield2 = "dmltablename";
	checkfield3 = "actionname,dmlorder,workflowId,dmltablename";
<%	
}
%>
var isright = true;
function addRow(fieldtable,fieldname)
{
	var oTable=document.getElementById(fieldtable);
	var oRow1 = oTable.insertRow();
	oRow1.style.height=20;
	oRow1.className = isright?"dataRight":"dataDark";
	
    var oCell1 = oRow1.insertCell();
	oCell1.style.wordWrap= "break-word";
	oCell1.style.wordBreak= "break-all";
    var sHtml = "<input type=checkbox id='"+fieldname+"check' name='"+fieldname+"check'>";
    oCell1.innerHTML = sHtml;
    
    var oCell2 = oRow1.insertCell();
	oCell2.style.wordWrap= "break-word";
	oCell2.style.wordBreak= "break-all";
    var sHtml = "<BUTTON type='button' class=Browser onClick=\"onShowTableField(this);\"></BUTTON><input type=text id='fieldname' name='fieldname' value='' style='border:0px;' readOnly='true'>";
    oCell2.innerHTML = sHtml;
    
    var oCell3 = oRow1.insertCell();
    
    var oCell4 = oRow1.insertCell();
    oCell4.style.wordWrap= "break-word";
	oCell4.style.wordBreak= "break-all";
    var sHtml = "<select id='"+fieldname+"fieldname' name='"+fieldname+"fieldname' width='100px;' style='width:100%;'><option></option></select>";
    oCell4.innerHTML = sHtml;
    
    var oRow2 = oTable.insertRow();
    var oCell5 = oRow2.insertCell();
    oCell5.className = "line";
    oCell5.colSpan = 4;
	isright = isright?false:true;
}
function delRow(fieldtable,checkname)
{
	var deleteList = new Array();
	var oTable=document.getElementById(fieldtable);
	var checknames = document.getElementsByName(checkname);
	var len = checknames.length;
	if(len>0)
	{
		try
		{
			for(var i = 0;i<len;i++)
			{
				var checknameelm = checknames[i];
				if(checknameelm.checked)
				{
					var oRow = checknameelm.parentElement.parentElement;
					var oRowLine = checknameelm.parentElement.parentElement.nextSibling;
					deleteList.push(oRow);
					deleteList.push(oRowLine);
				}
			}
		}
		catch(e)
		{
		}
	}
	if(deleteList.length>0)
	{
		for(var di = 0;di<deleteList.length;di++)
		{
			var deletetr = deleteList[di];
			var lineindex = deletetr.rowIndex;
			oTable.deleteRow(lineindex);
		}
	}
	else
	{
		//请选择需要删除的数据
		alert("<%=SystemEnv.getHtmlLabelName(22686, user.getLanguage())%>")
	}
}
function deleteAllRow(fieldtable,checkname)
{
	var checknames = document.getElementsByName(checkname);
	var len = checknames.length;
	if(len>0)
	{
		try
		{
			for(var i = 0;i<len;i++)
			{
				checknames[i].checked = true;
			}
		}
		catch(e)
		{
		}
		delRow(fieldtable,checkname);
	}
}
function changeTableField()
{
	checkinput('dmltablename','dmltablenamespans');
	var olddmltablename = "<%=dmltablename %>";
	var olddmlformname = "<%=dmlformname %>";
	var olddmlformid = "<%=dmlformid %>";
	var olddmlisdetail = "<%=dmlisdetail %>";
	
	var newdmltablename = document.getElementById('dmltablename').value;
	var newdmlformname = document.getElementById('dmlformname').value;
	var newdmlformid = document.getElementById('dmlformid').value;
	var newdmlisdetail = document.getElementById('dmlisdetail').value;
	
	if(olddmltablename!=newdmltablename||olddmlformname!=newdmlformname||olddmlformid!=newdmlformid||olddmlisdetail!=newdmlisdetail)
	{
		//外部主表发生改变,将重新获取字段信息,确定此修改吗
		var hasField = hasFieldAdd();
		if(hasField)
		{
			if(confirm("<%=SystemEnv.getHtmlLabelName(26430, user.getLanguage())%>?"))
			{
				if(newdmltablename=="")
				{
					deleteAllRow('fieldValueTableTr','dmlcheck');
					deleteAllRow('fieldWhereTableTr','wherecheck');
				}
				else
				{
					if((newdmlformid!=""&&newdmlformid!="0")&&olddmlformid==newdmlformid)
					{
						document.getElementById('dmltablename').value = olddmltablename;
					}
					
				    deleteAllRow('fieldValueTableTr','dmlcheck');
					deleteAllRow('fieldWhereTableTr','wherecheck');
			    }
			}
			else
			{
				document.getElementById('dmltablenamespan').innerHTML = olddmlformname;
				document.getElementById('dmlformid').value = olddmlformid;
				document.getElementById('dmlformname').value = olddmlformname;
				document.getElementById('dmlisdetail').value = olddmlisdetail;
				document.getElementById('dmltablename').value = olddmltablename;
			}
		}
	}
	
	
}
function appendField(fieldname,fielddbtype,iscanhandle,obj)
{
	try
	{
		if(fieldname==""||typeof(fieldname)=="undefined")
		{
			return;
		}
		//字段名
		var objfield = obj.nextSibling;
		objfield.value = fieldname;
		//字段类型
		var dbtypecell = obj.parentElement.nextSibling;
		dbtypecell.innerHTML = fielddbtype;
		//select选择
		var selectcell = dbtypecell.nextSibling;
		var selectel = selectcell.firstChild;
		selectel.innerHTML = "";
   		selectel.options.add(new Option("",""));
   		<%
		for(int i = 0;i<fieldList.size();i++)
		{
			String fieldid = (String)fieldList.get(i);
			String fieldname = Util.null2String((String)fieldNameMap.get(fieldid));
			String fielddbtype = Util.null2String((String)fieldDBTypeMap.get(fieldid));
			String fieldlabel = Util.null2String((String)fieldLabelMap.get(fieldid));
		%>
		var eo = new Option('<%=fieldlabel%>',fieldname+"="+fielddbtype+"=<%=fieldname%>");
		eo.title = '<%=fieldlabel%>';
   		selectel.options.add(eo);
   		<%
   		}
   		%>
   		if(iscanhandle=="false")
   		{
   			selectel.disabled = true;
   		}
	}
	catch(e)
	{
		alert(e);
	}
}
function submitData()
{
	enableAllmenu();
    if(check_form(frmmain,checkfield3))
    {
    	var dmlmainsqltype = document.frmmain.dmlmainsqltype.value;
    	var dmlmainsql = document.frmmain.dmlmainsql.value;
    	dmlmainsql = dmlmainsql.toLowerCase();
    	if(""!=dmlmainsql)
    	{
    		if((dmlmainsqltype==0&&dmlmainsql.indexOf("update")!=0&&dmlmainsql.indexOf("insert")!=0&&dmlmainsql.indexOf("delete")!=0)||(dmlmainsqltype==1&&dmlmainsql.indexOf("call")!=0&&dmlmainsql.indexOf("execute")!=0))
    		{
    			//不正确，请重新输入
    			alert("<%=SystemEnv.getHtmlLabelName(26426, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27685, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(27686, user.getLanguage())%>!");
    			document.frmmain.dmlmainsql.focus();
   				displayAllmenu();
   				return;
    		}
    	}
        document.frmmain.submit();
    }
    displayAllmenu();
}
function deleteData()
{
    if(isdel())
    {
    	
    	document.frmmain.operate.value="delete";
        document.frmmain.submit();
    }
}
/**
 *	是否存在设置的字段数据
 **/
function hasFieldAdd()
{
	var hasfield = false;
	var checknames = document.getElementsByName("dmlcheck");
	var len = checknames.length;
	if(len>0)
	{
		hasfield = true;
	}
	checknames = document.getElementsByName("wherecheck");
	len = checknames.length;
	if(len>0)
	{
		hasfield = true;
	}
	return hasfield;
}
function ChangeDatasource(obj)
{
	var olddatasourceid = "<%=datasourceid %>";
	var thisdatasourceid = document.getElementById('thisdatasourceid');
	var ischange = false;
	var hasField = hasFieldAdd();
	if(hasField)
	{
		//切换数据源将丢失您的设置,确定切换数据源吗
		if(confirm("<%=SystemEnv.getHtmlLabelName(26431, user.getLanguage())%>?"))
		{
			ischange = true;
			deleteAllRow('fieldValueTableTr','dmlcheck');
			deleteAllRow('fieldWhereTableTr','wherecheck');
		}
		else
		{
			var options = obj.options;
			for(var i = 0;i<options.length;i++)
			{
				var op = options[i];
				if(op.value==olddatasourceid)
				{
					op.selected = true;
				}
			}
		}
	}
	else
	{
		ischange = true;
	}
	if(obj.value=="")
	{
		<%if(needcheckds){%>
		thisdatasourceid.style.display = "none";
		<%}else{%>
		thisdatasourceid.style.display = "";
		<%}%>
	}
	else
	{
		thisdatasourceid.style.display = "none";
	}
	if(ischange)
	{
		document.getElementById('dmltablenamespan').innerHTML = "";
		document.getElementById('dmlformid').value = "";
		document.getElementById('dmlformname').value = "";
		document.getElementById('dmlisdetail').value = "";
		document.getElementById('dmltablename').value = "";
		document.getElementById('dmltablenamespans').innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
	}
}
function showTableFieldDiv(obj,obja)
{
	var objtr = document.getElementById(obj);
	if(objtr)
	{
		if(objtr.style.display=="")
		{
			objtr.style.display = "none";
			obja.innerText = "[<%=SystemEnv.getHtmlLabelName(27687, user.getLanguage())%>]";
			
		}
		else
		{
			objtr.style.display = "";
			obja.innerText = "[<%=SystemEnv.getHtmlLabelName(27669, user.getLanguage())%>]";
		}
	}
}
function onShowTable(inputname,formname,spanname,hiddenname,isdetail){
	var id_t = showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/triggerTableBrowser.jsp?wfid=<%=workflowId%>");
	if(id_t){
		if(id_t.id != ""){
			inputname.value = wuiUtil.getJsonValueByIndex(id_t, 0);
			formname.value = wuiUtil.getJsonValueByIndex(id_t, 1);
			spanname.innerHTML = wuiUtil.getJsonValueByIndex(id_t, 1);
			hiddenname.value = wuiUtil.getJsonValueByIndex(id_t, 3);
			isdetail.value = wuiUtil.getJsonValueByIndex(id_t, 4);
		}else{
			inputname.value = "";
			formname.value = "";
			spanname.innerHTML = "";
			hiddenname.value = "";
			isdetail.value = "";
		}
	}
	changeTableField();
}

function onShowTableField(obj){
	var fieldname;
	var fielddbtype;
	var iscanhandle;
	var datasourceid = document.getElementById("datasourceid").value;
	var needcheckds = "<%=needcheckds%>";
	var dmlformid = document.getElementById("dmlformid").value;
	var dmltablename = document.getElementById("dmltablename").value;
	var dmlisdetail = document.getElementById("dmltablename").value;
	var urls = "/systeminfo/BrowserMain.jsp?url=/workflow/dmlaction/dmlTableFieldsBrowser.jsp?datasourceid="+datasourceid+"&needcheckds="+needcheckds+"&dmlformid="+dmlformid+"&dmlisdetail="+dmlisdetail+"&dmltablename="+dmltablename;
	var id_t = showModalDialog(urls);
	if(id_t){
		if(id_t.id != ""){
			fieldname = wuiUtil.getJsonValueByIndex(id_t, 0);
			fielddbtype = wuiUtil.getJsonValueByIndex(id_t, 1);
			iscanhandle = wuiUtil.getJsonValueByIndex(id_t, 2);
		}else{
			fieldname = "";
			fielddbtype = "";
			iscanhandle = "";
		}
	}
	appendField(fieldname,fielddbtype,iscanhandle,obj);
}
</script>
