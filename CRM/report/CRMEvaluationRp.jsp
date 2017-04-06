<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(6073,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//add by xwj on 2005-03-25 for TD 1554
RCMenu += "{"+"Excel,javascript:ContractExport(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

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
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=10;
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

String sqlwhere="";
int ViewType = Util.getIntValue(request.getParameter("ViewType"),0);
if(resource!=0){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.manager="+resource;
	else	sqlwhere+=" and t1.manager="+resource;
}
if(!fromdate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.createdate>='"+fromdate+"'";
	else 	sqlwhere+=" and t1.createdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.createdate<='"+enddate+"'";
	else 	sqlwhere+=" and t1.createdate<='"+enddate+"'";
}

if(ViewType!=0){
	// modified by lupeng 2004-8-18 for TD883
	if(sqlwhere.equals(""))	
		sqlwhere += " where t1.evaluation = " + ViewType;
	else 	
		sqlwhere += " and t1.evaluation = " + ViewType ;
	// end.
}
/*
if(user.getLogintype().equals("2")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.agentid!='' and  t1.agentid!='0'";
	else 	sqlwhere+=" and  t1.agentid!='' and  t1.agentid!='0'";
}
*/
String sqlstr = "";
if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}

//add by xwj for TD 1554 on 2005-03-25
session.setAttribute("sqlwhere",sqlwhere);

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
%>
<form id=frmmain name=frmmain method=post action="CRMEvaluationRp.jsp">

<table class=ViewForm>
  <colgroup>
  <col width="10%">
  <col width="40%">
  <col width="10%">
  <col width="40%">
  <tbody>
  <tr>
  <%if(!user.getLogintype().equals("2")){%>
  <td><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
  <td class=field>
  <input class="wuiBrowser" _displayTemplate="<A href='HrmResource.jsp?id=#b{id}'>#b{name}</A>" _displayText="<a href='/hrm/resource/HrmResource.jsp?id=<%=resource%>'><%=Util.toScreen(resourcename,user.getLanguage())%></a>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name=viewer value="<%=resource%>"></td>
  <%}%>
  <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
  <td class=field>
  <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
  <input type="hidden" name="fromdate" value=<%=fromdate%>>
  гн<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
  <input type="hidden" name="enddate" value=<%=enddate%>>
  
  </td>
  </TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>
  <tr>  <td><%=SystemEnv.getHtmlLabelName(6073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></td>
  <td class=field><select  class=InputStyle size="1" name="ViewType" >
			<option value="0" <%if (ViewType==0) {%>selected<%}%>> </option>
			<% while (EvaluationLevelComInfo.next())
		  {
		  int levelint = Util.getIntValue(EvaluationLevelComInfo.getEvaluationLevelid(),0);
		  %>
		  <option value="<%=levelint%>" <%if (ViewType==levelint) {%>selected<%}%>><%=EvaluationLevelComInfo.getEvaluationLevelname()%></option>
		  <%}%>
			</select>
			</td>
  <td></td>
  <td class=field></td></TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>

</tbody>
</table>
<%
String backFields = "";
String fromSql = "";
String orderBy = "";
String sqlWhereNew = "";
if(RecordSet.getDBType().equals("oracle")){
	backFields=" id,evaluation,manager,createdate ";
	orderBy = "t1.createdate";
	if(user.getLogintype().equals("1")){
		fromSql=" CRM_CustomerInfo  t1,"+leftjointable+"  t2";
		sqlWhereNew = sqlwhere +" and t1.deleted <>1 and t1.id = t2.relateditemid";
	}else{
		fromSql=" CRM_CustomerInfo  t1";
		sqlWhereNew = sqlwhere +"  and t1.deleted <>1 and t1.agent="+user.getUID();
	}
}else if(RecordSet.getDBType().equals("db2")){
	backFields=" id,evaluation,manager,createdate ";
	orderBy = "t1.createdate";
	if(user.getLogintype().equals("1")){
		fromSql=" CRM_CustomerInfo  t1,"+leftjointable+"  t2";
		sqlWhereNew = sqlwhere +" and t1.deleted <>1 and t1.id = t2.relateditemid";
	}else{
		fromSql=" CRM_CustomerInfo  t1";
		sqlWhereNew = sqlwhere +"  and t1.deleted <>1 and t1.agent="+user.getUID();
	}
}else{
	backFields=" id,evaluation,manager,createdate ";
	orderBy = "t1.createdate";
	if(user.getLogintype().equals("1")){
		fromSql=" CRM_CustomerInfo  t1,"+leftjointable+"  t2";
		sqlWhereNew = sqlwhere +" and t1.deleted <>1 and t1.id = t2.relateditemid";
	}else{
		fromSql=" CRM_CustomerInfo  t1";
		sqlWhereNew = sqlwhere +"  and t1.deleted <>1 and t1.agent="+user.getUID();
	}
}
String linkstr = "/CRM/data/ViewCustomer.jsp";
String tableString=""+
       "<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
       "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhereNew)+"\" sqlisdistinct=\"true\"/>"+
       "<head>"+
             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1268,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" href=\""+linkstr+"\" linkkey=\"CustomerID\" linkvaluecolumn=\"id\"  transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\"/>"+
             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(6073,user.getLanguage())+"\" column=\"evaluation\" orderkey=\"evaluation\" />"+
             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1278,user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\" />"+
       "</head>"+
       "</table>";
%>
<TABLE width="100%" height="100%">
    <TR>
        <TD valign="top">
            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>
        </TD>
    </TR>
</TABLE>

</form>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<!-- modified by xwj 2005-03-25 for TD 1554 -->
<iframe id="searchexport" style="display:none"></iframe>
<script language=javascript>
function ContractExport(){
     searchexport.src="CRMEvaluationRpExport.jsp";
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>