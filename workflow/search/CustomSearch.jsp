<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

</head>
<%
session.removeAttribute("RequestViewResource");
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype = 1;
String seclevel = user.getSeclevel();

String selectedworkflow="";
String isuserdefault="";
boolean issimple = Util.null2String(request.getParameter("issimple")).equals("false")?false:true;
String searchtype = Util.null2String(request.getParameter("searchtype"));
if(searchtype.equals("querytype")){
    response.sendRedirect("/workflow/search/CustomQueryTypeSearch.jsp?issimple="+issimple);
    return;
}
%>
<body>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(23802, user.getLanguage()) + ",/workflow/search/CustomQueryTypeSearch.jsp?issimple="+issimple+",_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name=subform method=post>
<%
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));
ArrayList NewWorkflowTypes = new ArrayList();
ArrayList NewWorkflows = new ArrayList();
String sql = "";
    String tempbillworkflowids="";
    String tempfromworkflowids="";
    RecordSet.execute("select * from workflow_custom ");
    while(RecordSet.next()){
        String isbill = Util.null2String(RecordSet.getString("isbill"));
        String formID = Util.null2String(RecordSet.getString("formid"));
        String tempworkflowids = Util.null2String(RecordSet.getString("workflowids"));
        if (tempworkflowids.trim().equals("")) {
            rs.executeSql("select id from workflow_base where isvalid='1' and formid=" + formID + " and isbill='" + isbill + "'");
            while (rs.next()) {
                if (tempworkflowids.trim().equals("")) {
                    tempworkflowids = rs.getString("id");
                } else {
                    tempworkflowids += "," + rs.getString("id");
                }
            }
        }
        if (!tempworkflowids.trim().equals("")) {
            if (isbill.equals("1")) {
                if (tempbillworkflowids.trim().equals("")) {
                    tempbillworkflowids = tempworkflowids;
                } else {
                    tempbillworkflowids += "," + tempworkflowids;
                }
            } else {
                if (tempfromworkflowids.trim().equals("")) {
                    tempfromworkflowids = tempworkflowids;
                } else {
                    tempfromworkflowids += "," + tempworkflowids;
                }
            }
        }
    }
    String tempwfids="";
    if(!tempbillworkflowids.equals("")){
        RecordSet.executeSql("select distinct a.workflowid from workflow_createdoc a,workflow_billfield b where (b.viewtype is null or b.viewtype !='1') and a.flowdocfield=b.id and a.status='1' and a.workflowid in("+tempbillworkflowids+")");
        while(RecordSet.next()){
            String tmpworkflowid=RecordSet.getString("workflowid");
                if(tempwfids.equals("")){
                    tempwfids=tmpworkflowid;
                }else{
                    tempwfids+=","+tmpworkflowid;
                }
            }
    }
    if(!tempfromworkflowids.equals("")){
        RecordSet.executeSql("select distinct c.workflowid from workflow_createdoc c,workflow_formfield a ,workflow_formdict b where a.fieldid=b.id and (a.isdetail is null or a.isdetail !='1') and c.flowdocfield=a.fieldid and c.status='1' and c.workflowid in("+tempfromworkflowids+")");
        while(RecordSet.next()){
            String tmpworkflowid=RecordSet.getString("workflowid");
                if(tempwfids.equals("")){
                    tempwfids=tmpworkflowid;
                }else{
                    tempwfids+=","+tmpworkflowid;
                }
        }
    }
    if(RecordSet.getDBType().equals("oracle")){
        sql = "select  a.workflowtype,a.id from workflow_base a,workflow_custom b where a.isvalid='1' and a.formid=b.formid and a.isbill=b.isbill and (b.workflowids is null or ','||to_char(b.workflowids)||',' like '%,'||to_char(a.id)||',%')";
    }else{
        sql = "select  a.workflowtype,a.id from workflow_base a,workflow_custom b where a.isvalid='1' and a.formid=b.formid and a.isbill=b.isbill and (b.workflowids is null or convert(varchar,b.workflowids) ='' or convert(varchar,b.workflowids) ='' or ','+convert(varchar,b.workflowids)+',' like '%,'+convert(varchar,a.id)+',%')";
    }
    if(!tempwfids.equals("")){
        sql+=" and (a.id in("+tempwfids+") or exists (select 1 from workflow_currentoperator where workflow_currentoperator.workflowid=a.id and userid="+userid+" and usertype='"+usertype+"' ))  order by  a.workflowtype,a.id ";
    }else{
        sql+=" and exists (select 1 from workflow_currentoperator where workflow_currentoperator.workflowid=a.id and userid="+userid+" and usertype='"+usertype+"' )  order by  a.workflowtype,a.id ";
    }
RecordSet.executeSql(sql);
while(RecordSet.next()){
    if(NewWorkflowTypes.indexOf(RecordSet.getString("workflowtype"))==-1)
	NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
    NewWorkflows.add(RecordSet.getString("id"));
}

int wftypetotal=NewWorkflowTypes.size();
//int wftotal=WorkflowComInfo.getWorkflowNum();
int rownum=(wftypetotal+2)/3;
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

<table class="ViewForm">

   <tr class=field>
        <td width="33%" align=left valign=top>
<%
 	int i=0;
 	int needtd=rownum;
	
 	while(WorkTypeComInfo.next()){	
		
 		String wftypename=WorkTypeComInfo.getWorkTypename();
	
 		String wftypeid = WorkTypeComInfo.getWorkTypeid();
		//out.print(NewWorkflowTypes.indexOf(wftypeid));
 		if (NewWorkflowTypes.indexOf(wftypeid)==-1)    continue;        
	 		
 		
 	%>
 	<table class="ViewForm">
		<tr>
		  <td>
 	<%
	needtd--;
 	int isfirst = 1;
	while(WorkflowComInfo.next()){
		String wfname=WorkflowComInfo.getWorkflowname();
	 	String wfid = WorkflowComInfo.getWorkflowid();
	 	String curtypeid = WorkflowComInfo.getWorkflowtype();

        if (NewWorkflows.indexOf(wfid)==-1)    continue;        

	 	if(!curtypeid.equals(wftypeid)) continue;
	 	if(!"1".equals(WorkflowComInfo.getIsValid())){
		 	continue;
	 	}
	 	i++;
	 	
	 	if(isfirst ==1)
			{
	 		isfirst = 0;
	%>
	 <div class=listbox >
		<table width="100%" height="39px" border="0" cellspacing="0" cellpadding="0">
			<tr>
				
				<td class="t-center"><span class="flag_1"></span><span	class="title_1">
		<b><%=Util.toScreen(wftypename,user.getLanguage())%></b>	
	</span></td>
			
		</tr>
	</table>
	 <UL>
	<%}
	 	
	%>
		<li><a href="javascript:onSearchRequest(<%=wfid%>);">
		<%=Util.toScreen(wfname,user.getLanguage())%></a></li>
	<%
		}
		WorkflowComInfo.setTofirstRow();
	%>
		</div></td></tr>
	</table>
	<%
		if(needtd<=0){
			needtd=rownum;
	%>
	</td><td width="20">&nbsp;</td><td width="32%" align=left valign=top>
	<%
		}
	}
	%>		
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

</form>
<script language=javascript>
function onSearchRequest(wfid){
document.subform.action="WFCustomSearchBySimple.jsp?workflowid="+wfid+"&issimple=<%=issimple%>";
document.subform.submit();
}
</script>
</body>

</html>