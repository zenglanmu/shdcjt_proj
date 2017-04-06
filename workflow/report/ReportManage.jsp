<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
int otype = Util.getIntValue(Util.null2String(request.getParameter("otype")),0);
int subcompanyid = Util.getIntValue(Util.null2String(request.getParameter("subcompanyid")),0);
String reportname = Util.null2String(request.getParameter("reportname"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;
List subcompanyid2 = new ArrayList();
if(detachable==1)
{
	if(subcompanyid>0)
		operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowReportManage:All", subcompanyid);
	else
	{
		int tempsubcompanyid2[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowReportManage:All",2);
		if(null!=tempsubcompanyid2)
		{
			for(int i = 0;i<tempsubcompanyid2.length;i++)
			{
				subcompanyid2.add(""+tempsubcompanyid2[i]);
			}
		}
	}
}
else
{
	operatelevel = 2;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<div>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(operatelevel>1||subcompanyid2.size()>0){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",ReportAdd.jsp?reportType="+otype+"&subcompanyid="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>
</div>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id="SearchForm" name="SearchForm" action="ReportManage.jsp" method="post">
<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
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
	<COLGROUP>
	<COL width="20%">
	<COL width="80%">
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></TD>
		<TD class="field">
			<input type="text" class="InputStyle" style="width:40%" id="reportname" name="reportname" value="<%=reportname%>">
		</TD>
	</TR>
	<TR style="height:1px;"><TD class="Line2" colspan="2"></TD></TR>
</table>
<br/>
<table class=ListStyle cellspacing=1 > 
  		<tr> <td valign="top">  
  			<%  
  			String  tableString  =  "";  
  			String  backfields  =  "*"; 
  			String  fromSql  = " from Workflow_Report";
  			String  sqlwhere  =  " where 1=1 ";  
  			if(detachable==1)
  			{
				if(!"".equals(reportname))
				{
					sqlwhere += " and reportname like '%"+reportname+"%' ";
				}
				else
				{
					if(rs.getDBType().equals("oracle"))
					{
						if(otype>0)
							sqlwhere+=" and nvl(reporttype,0) ="+otype;
						if(subcompanyid>0)
							sqlwhere+=" and nvl(subcompanyid,0)="+subcompanyid;
					}
					else
					{
						if(otype>0)
							sqlwhere+=" and isnull(reporttype,0) ="+otype;
						if(subcompanyid>0)
							sqlwhere+=" and isnull(subcompanyid,0)="+subcompanyid;
					}
				}
				if(user.getUID()!=1)
				{
					int[] subCompany = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowReportManage:All");
     				String mSubComStr="";
     				String subCompanyString="";
	       			for(int j = 0; j < subCompany.length; j++)
					{
						subCompanyString += subCompany[j] + ",";
					}
					if(!"".equals(subCompanyString) && null != subCompanyString)
					{
						subCompanyString = subCompanyString.substring(0, subCompanyString.length() - 1);
					}
					if(!"".equals(subCompanyString) && null != subCompanyString)
					{
						sqlwhere+=" and subcompanyid in("+subCompanyString+")";
					}
					else
					{
						sqlwhere+=" and 1=2";
					}
				}
  			}
  			else
  			{
				if(!"".equals(reportname))
				{
					sqlwhere += " and reportname like '%"+reportname+"%' ";
				}
				else
				{
		    		
		    		if(rs.getDBType().equals("oracle"))
					{
						if(otype>0)
		    				sqlwhere+=" and nvl(reporttype,0) ="+otype;
					}
					else
					{
						if(otype>0)
							sqlwhere+=" and isnull(reporttype,0) ="+otype;
					}
				}
  			}	
  			String orderby  =  "id";
  			//out.println("select " + backfields + fromSql + sqlwhere);
  			tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+10+"\" >"+      
  									 "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlisdistinct=\"true\"  />"+   
  									 "<head>";   
  		tableString+="<col width=\"10%\" href=\"/workflow/report/ReportEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\"  column=\"id\" orderkey=\"id\" />";            
  			//tableString+="<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(15517,user.getLanguage())+"\" column=\"reportname\" orderkey=\"reportname\" />"; 
  		tableString+="<col width=\"30%\" href=\"/workflow/report/ReportEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_self\"  text=\""+SystemEnv.getHtmlLabelName(15517,user.getLanguage())+"\" column=\"reportname\" orderkey=\"reportname\" />"; 
        tableString+="<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(15434,user.getLanguage())+"\"  column=\"reporttype\" orderkey=\"reporttype\" transmethod=\"weaver.splitepage.transform.SptmForWorkFlowReport.getReportType\" otherpara=\""+user.getLanguage()+"\" />";           
        tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(15451,user.getLanguage())+"\" column=\"formid\" orderkey=\"formid\" transmethod=\"weaver.splitepage.transform.SptmForWorkFlowReport.getReportFormName\" otherpara=\""+user.getLanguage()+"+column:isbill\" />";
        if(detachable==1)
        {           
        	tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(19799,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\"/>";
        }
        tableString+="</head>";
	    tableString+="</table>";
        %> 
         
			<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run"/>
		</td>
	</tr>
</table>

	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</td>
<td ></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>

</table>
</FORM>
</BODY></HTML>
<script language="javascript">
function onSearch(){
	SearchForm.submit();
}
</script>
