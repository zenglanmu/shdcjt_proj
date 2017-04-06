<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%@ include file="/docs/common.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
char flag = 2;
String ProcPara = "";
String ProjID = Util.null2String(request.getParameter("ProjID"));
String log = Util.null2String(request.getParameter("log"));
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
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

<TABLE class=liststyle cellspacing=1 >
<TBODY>
        <TR class=Header>
          <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
		</TR>
			<TR class=Line>
		
		<th class="Line1"></th>
		<th class="Line1"></th>
		<th class="Line1"></th>
		</TR> 
<%
String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;

String sql="SELECT distinct t1.id, t1.docsubject, t1.ownerid, t1.usertype, t1.doccreatedate, t1.doccreatetime FROM DocDetail  t1, "+tables+" t2, Prj_Doc t3 ";
String sqlwhere=" where t1.id = t2.sourceid  and t1.id = t3.docid and t3.prjid = " + ProjID + " ";
String orderby=" ORDER BY t1.id DESC ";
sql=sql+sqlwhere+orderby;
RecordSet.executeSql(sql);
while(RecordSet.next())
{
	String id=RecordSet.getString("id");
	String createdate=RecordSet.getString("doccreatedate");
	String createtime=RecordSet.getString("doccreatetime");
	String ownerid=RecordSet.getString("ownerid");
	String ownertype=RecordSet.getString("usertype");
	String docsubject=RecordSet.getString("docsubject");
%>
    <tr class=datadark>
      <td><%=Util.toScreen(createdate,user.getLanguage())%>&nbsp<%=Util.toScreen(createtime,user.getLanguage())%></td>
      <td>
      <%if(ownertype.equals("1")){%>
      <%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=ownerid%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(ownerid),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
      <%}else if(ownertype.equals("2")){%>
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=ownerid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(ownerid),user.getLanguage())%></a>
      <%}%>
      </td>
      <td><a href="/docs/docs/DocDsp.jsp?id=<%=id%>"><%=Util.toScreen(docsubject,user.getLanguage())%></a></td>
       </tr>

<%}%>
		</TBODY>
	</TABLE></td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


</BODY>
</HTML>
