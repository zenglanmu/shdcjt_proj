<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*,weaver.workflow.request.WFWorkflows,weaver.workflow.request.WFWorkflowTypes"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<HTML>
<HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
    String imagefilename = "/images/hdDOC.gif";
    String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
    String method = Util.null2String(request.getParameter("method"));
    String objid = Util.null2String(request.getParameter("objid"));
    String workflowid = Util.null2String(request.getParameter("workflowid"));
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String fromdate = Util.null2String(request.getParameter("fromdate"));
	String todate = Util.null2String(request.getParameter("todate"));
	String creatertype = Util.null2String(request.getParameter("creatertype"));
	String createrid = Util.null2String(request.getParameter("createrid"));
	String requestlevel = Util.null2String(request.getParameter("requestlevel"));
	String fromdate2 = Util.null2String(request.getParameter("fromdate2"));
	String todate2 = Util.null2String(request.getParameter("todate2"));
    String workcode = Util.null2String(request.getParameter("workcode"));
    String sqlwhere="";
    boolean isnew = false;
    if (method.equals("type")&&!objid.trim().equals("")) {
    	workflowid = "";
        sqlwhere=" b.workflowtype="+objid;
    }
    if (method.equals("workflow")&&!objid.trim().equals("")) {
    	workflowid = objid;
        sqlwhere=" b.id="+objid;
    }
    if (method.equals("request")&&!objid.trim().equals("")) {
    	workflowid = objid;
        sqlwhere=" b.id="+objid;
        isnew = true;
    }
    int logintype = Util.getIntValue(user.getLogintype(),1);
    int userID = user.getUID();
    WFUrgerManager.setLogintype(logintype);
    WFUrgerManager.setUserid(userID);
    WFUrgerManager.setSqlwhere(sqlwhere);
    ArrayList wftypes=WFUrgerManager.getWrokflowTree();
    String requestSql = "";
    String requestids="";
    if(workflowid.equals("")){
		if(method.equals("type")&&!objid.trim().equals("")){
			RecordSet.execute("select id from workflow_base where workflowtype="+objid);
			while(RecordSet.next()){
				int id_tmp = Util.getIntValue(RecordSet.getString(1), 0);
				workflowid += (id_tmp+",");
			}
			if(!workflowid.equals("")){
				workflowid = workflowid.substring(0, workflowid.length()-1);
			}
		}else{
			workflowid = SearchClause.getWorkflowId();
		}
	}
    ArrayList  flowList=Util.TokenizerString(workflowid,",");
    for(int i=0;i<wftypes.size();i++){
        WFWorkflowTypes wftype=(WFWorkflowTypes)wftypes.get(i);
        ArrayList workflows=wftype.getWorkflows();
        for(int j=0;j<workflows.size();j++){
            if(j>0) break;
            WFWorkflows wfworkflow=(WFWorkflows)workflows.get(j);
            String tempWorkflow=wfworkflow.getWorkflowid()+"";
            if("".equals(workflowid)||flowList.contains(tempWorkflow)) {
                ArrayList requests=new ArrayList();
                ArrayList wfersql =wfworkflow.getWfersql();
                if(isnew){
                    requests=wfworkflow.getNewrequestids();
                }else{
                    requests=wfworkflow.getReqeustids();
                }
                for(int m=0;m<wfersql.size();m++){
                    requestSql += " union all ";
                    requestSql += (String)wfersql.get(m);
                }
                for(int k=0;k<requests.size();k++){
                    if(requestids.equals("")){
                        requestids=(String)requests.get(k);
                    }else{
                        requestids+=","+requests.get(k);
                    }
                }
            }
        }
    }
    requestSql = requestSql.replaceFirst(" union all ", " ");
    String newsql =" where (t1.currentnodetype is null or t1.currentnodetype<>'3') and t1.requestid=t2.requestid and t1.deleted<>1 ";

        if (!workflowid.equals(""))
            newsql += " and t1.workflowid in(" + workflowid + ")";

        if (!nodetype.equals(""))
            newsql += " and t1.currentnodetype='" + nodetype + "'";


        if (!fromdate.equals(""))
            newsql += " and t1.createdate>='" + fromdate + "'";

        if (!todate.equals(""))
            newsql += " and t1.createdate<='" + todate + "'";

        if (!fromdate2.equals(""))
            newsql += " and t2.receivedatetime>='" + fromdate2 + "'";

        if (!todate2.equals(""))
            newsql += " and t2.receivedatetime<='" + todate2 + "'";

        if (!workcode.equals(""))
            newsql += " and t1.creatertype= '0' and t1.creater in(select id from hrmresource where workcode like '%" + workcode + "%')";

        if (!createrid.equals("")) {
            newsql += " and t1.creater='" + createrid + "'";
            newsql += " and t1.creatertype= '" + creatertype + "' ";
        }

        if (!requestlevel.equals("")) {
            newsql += " and t1.requestlevel=" + requestlevel;
        }
       int perpage=10;
    boolean hascreatetime =true;
boolean hascreater =true;
boolean hasworkflowname =true;
boolean hasrequestlevel =true;
boolean hasrequestname =true;
boolean hasreceivetime =true;
boolean hasstatus =true;
boolean hasreceivedpersons =true;
boolean hascurrentnode =true;
RecordSet.executeProc("workflow_RUserDefault_Select",""+userID);
if(RecordSet.next()){
    if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
    if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
    if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
    if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
    if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
    if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
    if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
    if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
    if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
    perpage= RecordSet.getInt("numperpage");
}else{
    RecordSet.executeProc("workflow_RUserDefault_Select","1");
    if(RecordSet.next()){
        if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
        if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
        if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
        if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
        if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
        if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
        if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
        if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
        if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
        perpage= RecordSet.getInt("numperpage");
    }
}

/*如果所有的列都不显示，那么就显示所有的，避免页面出错*/
if(!hascreatetime&&!hascreater&&!hasworkflowname&&!hasrequestlevel&&!hasrequestname&&!hasreceivetime&&!hasstatus&&!hasreceivedpersons&&!hascurrentnode){
	hascreatetime =true;
	hascreater =true;
	hasworkflowname =true;
	hasrequestlevel =true;
	hasrequestname =true;
	hasreceivetime =true;
	hasstatus =true;
	hasreceivedpersons =true;
	hascurrentnode =true;			
}


//update by fanggsh 20060711 for TD4532 begin
boolean hasSubWorkflow =false;

if(workflowid!=null&&!workflowid.equals("")&&workflowid.indexOf(",")==-1){
	RecordSet.executeSql("select id from Workflow_SubWfSet where mainWorkflowId="+workflowid);
	if(RecordSet.next()){
		hasSubWorkflow=true;
	}
}
    if(perpage <2) perpage=10;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:OnSearch(),_self}";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",RequestSupervise.jsp,_self}";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(18363, user.getLanguage()) + ",javascript:_table.firstPage(),_self}";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(1258, user.getLanguage()) + ",javascript:_table.prePage(),_self}";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(1259, user.getLanguage()) + ",javascript:_table.nextPage(),_self}";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(18362, user.getLanguage()) + ",javascript:_table.lastPage(),_self}";
    RCMenuHeight += RCMenuHeightStep;
%>

<FORM id=frmmain name=frmmain method=post action="WFSuperviseList.jsp">
<input type=hidden name=method value="<%=method%>">
<input type=hidden name=objid value="<%=objid%>">
<table width=100% height=94% border="0" cellspacing="0" cellpadding="0">
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

<table class="viewform">
<colgroup>
<col width="10%">
<col width="20%">
<col width="5">
<col width="10%">
<col width="20%">
<col width="5%">
<col width="10%">
<col width="20">
<tbody>
<tr>
    <td><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%>
                </td>
    <td class=field>
        <BUTTON type="button" class=browser onClick="onShowWorkFlow('workflowid','workflowspan')"></button>
	<span id=workflowspan>
	<%if(workflowid!=null && !workflowid.equals("") && workflowid.indexOf(",") == -1){%>
	<%=WorkflowComInfo.getWorkflowname(workflowid)%>
	<%}%>
	</span>
        <input name=workflowid type=hidden value="<%=workflowid%>">

    </td>

    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(15536, user.getLanguage())%>
                </td>
    <td class=field>
        <select class=inputstyle size=1 name=nodetype style=width:150>
            <option value="">&nbsp;</option>
            <option value="0"
                    <% if(nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%>
                        </option>
            <option value="1"
                    <% if(nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%>
                        </option>
            <option value="2"
                    <% if(nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725, user.getLanguage())%>
                        </option>
            <option value="3"
                    <% if(nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%>
                        </option>
        </select>
    </td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(603, user.getLanguage())%>
                </td>
    <td class=field>
        <select class=inputstyle name=requestlevel style=width:140 size=1>
            <option value=""></option>
            <option value="0"
                    <% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%>
                        </option>
            <option value="1"
                    <% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%>
                        </option>
            <option value="2"
                    <% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%>
                        </option>
        </select>
    </td>
</tr>
<TR style="height:1px;">
    <TD class=Line colSpan=8></TD>
</TR>
<tr>

    <td><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%>
                </td>
    <td class=field>
        <BUTTON type="button" class=calendar id=SelectDate onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>
        <SPAN id=fromdatespan><%=fromdate%></SPAN>
        -&nbsp;&nbsp;
        <BUTTON type="button" class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>
        <SPAN id=todatespan><%=todate%></SPAN>
        <input type="hidden" name="fromdate" value="<%=fromdate%>"><input type="hidden" name="todate"
                                                                          value="<%=todate%>">
    </td>

    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%>
                </td>
    <td class=field>
        <select class=inputstyle name=creatertype>
            <%if (!user.getLogintype().equals("2")) {%>
            <option value="0"
                    <% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%>
                        </option>
            <%}%>
            <option value="1"
                    <% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%>
                        </option>
        </select>
        &nbsp
        <BUTTON type="button" class=browser onClick="onShowResource()"></button>
	<span id=resourcespan><% if (creatertype.equals("0")) {%><%=ResourceComInfo.getResourcename(createrid)%><%}%>
    <% if (creatertype.equals("1")) {%><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid), user.getLanguage())%><%}%></span>
        <input name=createrid type=hidden value="<%=createrid%>"></td>
    <td>&nbsp;</td>

    <td><%=SystemEnv.getHtmlLabelName(17994, user.getLanguage())%>
                </td>
    <td class=field>
        <BUTTON type="button" class=calendar id=SelectDate3 onclick="gettheDate(fromdate2,fromdatespan2)"></BUTTON>
        <SPAN id=fromdatespan2><%=fromdate2%></SPAN>
        -&nbsp;&nbsp;
        <BUTTON type="button" class=calendar id=SelectDate4 onclick="gettheDate(todate2,todatespan2)"></BUTTON>
        <SPAN id=todatespan2><%=todate2%></SPAN>
        <input type="hidden" name="fromdate2" value="<%=fromdate2%>"><input type="hidden" name="todate2"
                                                                            value="<%=todate2%>">
    </td>
</tr>
<TR style="height:1px;">
    <TD class=Line colSpan=8></TD>
</TR>
<tr>

    <td><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%>
                </td>
    <td class=field>
        <input type="text" name="workcode" value="<%=workcode%>">
    </td>

    <td>&nbsp;</td>
    <td></td>
    <td>
    </td>
    <td>&nbsp;</td>

    <td></td>
    <td>
    </td>
</tr>
<TR style="height:1px;">
    <TD class=Line colSpan=8></TD>
</TR>
</tbody>
</table>



<TABLE width="100%">


    <tr>

        <td valign="top">
            <%
                String tableString = "";
				String fromSql = "";
				String sqlWhere = newsql;
                String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid,t2.receivedatetime";
                if(RecordSet.getDBType().equals("oracle")){
					fromSql = " from (select requestid,max(receivedate||' '||receivetime) as receivedatetime from workflow_currentoperator group by requestid) t2,workflow_requestbase t1 ";
                }else{
					fromSql = " from (select requestid,max(receivedate+' '+receivetime) as receivedatetime from workflow_currentoperator group by requestid) t2,workflow_requestbase t1 ";
				}
                if (!requestids.equals("")) {
                	if (isnew) {
                		sqlWhere += " AND t1.requestid in("+requestids+") ";
                	}
                }else{
                    sqlWhere+=" and 1>2 ";
                }
                if(RecordSet.getDBType().equals("oracle"))
                {
                	sqlWhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
                }
                else
                {
                	sqlWhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
                }
                String table1 = "select " + backfields + fromSql + sqlWhere;
                backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid,t1.receivedatetime";
                fromSql =" from ("+table1+") t1 ";
				if(!requestSql.equals("")) {
					fromSql += " ,("+requestSql+") t2 ";
					sqlWhere = " where t1.requestid=t2.requestid ";
				}
				else {
					sqlWhere = "";
				}
                String orderby = " t1.receivedatetime ";
                String para2 = "column:requestid+column:workflowid+"+userID+"+"+(logintype-1)+"+"+ user.getLanguage();
				String para4=user.getLanguage()+"+"+user.getUID();
                //System.out.println("select " + backfields + fromSql + sqlWhere+" order by "+orderby);
                tableString = " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\"" + perpage + "\" >" +
                        "	   <sql backfields=\"" + backfields + "\" sqlform=\"" + Util.toHtmlForSplitPage(fromSql) + "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) + "\"  sqlorderby=\"" + orderby + "\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />" +
                        "			<head>";
                if (hascreatetime)
                    tableString += "				<col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(722, user.getLanguage()) + "\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                if (hascreater)
                    tableString += "				<col width=\"6%\"  text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage()) + "\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
                if (hasworkflowname)
                    tableString += "				<col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage()) + "\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
                if (hasrequestlevel)
                    tableString += "				<col width=\"8%\"  text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage()) + "\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\"" + user.getLanguage() + "\"/>";
                if (hasrequestname)
                    tableString += "				<col width=\"19%\"  text=\"" + SystemEnv.getHtmlLabelName(1334, user.getLanguage()) + "\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkByUrger\"  otherpara=\"" + para2 + "\"/>";
                if (hascurrentnode)
                    tableString += "				<col width=\"8%\"  text=\"" + SystemEnv.getHtmlLabelName(524, user.getLanguage()) + SystemEnv.getHtmlLabelName(15586, user.getLanguage()) + "\" column=\"currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
                if (hasreceivetime)
                    tableString += "			    <col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(17994, user.getLanguage()) + "\" column=\"receivedatetime\" orderkey=\"t1.receivedatetime\" />";
                if (hasstatus)
                    tableString += "			    <col width=\"8%\"  text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"t1.status\" />";
                if (hasreceivedpersons)
                    tableString += "			    <col width=\"15%\"  text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\"  otherpara=\"" + para4 + "\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
                if (hasSubWorkflow)
                    tableString += "				<col width=\"6%\"  text=\"" + SystemEnv.getHtmlLabelName(19363, user.getLanguage()) + "\" column=\"requestid\" orderkey=\"t1.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\"" + user.getLanguage() + "\"/>";

                tableString += "			</head>" +
                        "</table>";
            %>

            <wea:SplitPageTag tableString="<%=tableString%>" mode="run"/>
        </td>
    </tr>
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
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
</form>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</body>

<script type="text/javascript">
function onShowResource() {
	var tmpval = $GetEle("creatertype").value;
	var id = null;
	if (tmpval == "0") {
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	}else {
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	}
	if (id != null) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			resourcespan.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			$GetEle("createrid").value=wuiUtil.getJsonValueByIndex(id, 0);
        } else {
			resourcespan.innerHTML = "";
			$GetEle("createrid").value="";
        }
	}

}

function onShowWorkFlow(inputname, spanname) {
	onShowWorkFlowBase(inputname, spanname, false);
}

function onShowWorkFlowBase(inputname, spanname, needed) {
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	if (retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
			$GetEle(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			$GetEle("objid").value = wuiUtil.getJsonValueByIndex(retValue, 0);
		} else { 
			$GetEle(inputname).value = "";
			if (needed) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle("objid").value = "";
		}
	}
}
</script>


<SCRIPT language="javascript">

    function OnSearch(){
    document.frmmain.submit();
    }

    var showTableDiv = document.getElementById('divshowreceivied');
    var oIframe = document.createElement('iframe');
    function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("div");
        message_Div.id="message_Div";
        message_Div.className="xTable_message";
        showTableDiv.appendChild(message_Div);
        var message_Div1 = document.getElementById("message_Div");
        message_Div1.style.display="inline";
        message_Div1.innerHTML=content;
        var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
        var pLeft= document.body.offsetWidth/2-50;
        message_Div1.style.position="absolute"
        message_Div1.style.top=pTop;
        message_Div1.style.left=pLeft;

        message_Div1.style.zIndex=1002;

        oIframe.id = 'HelpFrame';
        showTableDiv.appendChild(oIframe);
        oIframe.frameborder = 0;
        oIframe.style.position = 'absolute';
        oIframe.style.top = pTop;
        oIframe.style.left = pLeft;
        oIframe.style.zIndex = message_Div1.style.zIndex - 1;
        oIframe.style.width = parseInt(message_Div1.offsetWidth);
        oIframe.style.height = parseInt(message_Div1.offsetHeight);
        oIframe.style.display = 'block';
        }

        function ajaxinit(){
        var ajax=false;
        try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
        try {
        ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
        ajax = false;
        }
        }
        if (!ajax && typeof XMLHttpRequest!='undefined') {
        ajax = new XMLHttpRequest();
        }
        return ajax;
        }
        function showallreceived(requestid,returntdid){
        showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
        var ajax=ajaxinit();

        ajax.open("POST", "WorkflowUnoperatorPersons.jsp", true);
        ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        ajax.send("requestid="+requestid+"&returntdid="+returntdid);
        //获取执行状态
        //alert(ajax.readyState);
        //alert(ajax.status);
        ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState==4&&ajax.status == 200) {
        try{
        document.getElementById(returntdid).innerHTML = ajax.responseText;
        }catch(e){}
        showTableDiv.style.display='none';
        oIframe.style.display='none';
        }
        }
        }

</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>