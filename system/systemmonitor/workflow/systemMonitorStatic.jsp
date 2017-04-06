<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
 <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>

<%
String info = Util.null2String(request.getParameter("infoKey"));
int typeid = Util.getIntValue(request.getParameter("typeid"),0);
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
String subcompanyids = "0";
if(info!=null && !"".equals(info))
{
  if("1".equals(info))
  {
      info=SystemEnv.getHtmlLabelName(17989,user.getLanguage())+SystemEnv.getHtmlLabelName(15242,user.getLanguage());
  }
  else if("2".equals(info))
  {
      info=SystemEnv.getHtmlLabelName(17989,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage());
  }
%>
  <script language="JavaScript">
  alert('<%=info%>')
  </script>
<%
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16758,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage());
String needfav ="1";
String needhelp ="";

RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
}
int operatelevel=0;
List subcompanyid1 = new ArrayList();
List subcompanyid2 = new ArrayList();
if (detachable == 1)
{
	//if (subcompanyid<=0)
	//{
	//	subcompanyid = Util.getIntValue(String.valueOf(session.getAttribute("managemonitor_subcompanyid")), -1);
	//}
	//if (subcompanyid == -1)
	//{
	//	subcompanyid = user.getUserSubCompany1();
	//}
	//session.setAttribute("managemonitor_subcompanyid", String.valueOf(subcompanyid));
	if(subcompanyid>0&&user.getUID()!=1)
		operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowMonitor:All", subcompanyid);
	else if(subcompanyid<=0&&user.getUID()!=1)
	{
		int tempsubcompanyid[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowMonitor:All",0);
		if(null!=tempsubcompanyid)
		{
			for(int i = 0;i<tempsubcompanyid.length;i++)
			{
				subcompanyids += "".equals(subcompanyids)?(""+tempsubcompanyid[i]):(","+tempsubcompanyid[i]);
			}
		}
		int tempsubcompanyid1[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowMonitor:All",1);
		if(null!=tempsubcompanyid1)
		{
			for(int i = 0;i<tempsubcompanyid1.length;i++)
			{
				subcompanyid1.add(""+tempsubcompanyid1[i]);
			}
		}
		int tempsubcompanyid2[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowMonitor:All",2);
		if(null!=tempsubcompanyid2)
		{
			for(int i = 0;i<tempsubcompanyid2.length;i++)
			{
				subcompanyid2.add(""+tempsubcompanyid2[i]);
			}
		}
	}
	else
	{
		operatelevel = 2;
	}
}
else
{
	if (HrmUserVarify.checkUserRight("WorkflowMonitor:All", user))
		operatelevel = 2;
	else
	{
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}

String sql = "";
String innersql = "";

if(detachable==1)
{
	if(subcompanyid>0)
	{
		if(RecordSet.getDBType().equals("oracle"))
			innersql += " and nvl(b.subcompanyid,0) = "+subcompanyid;
		else
			innersql += " and isnull(b.subcompanyid,0) = "+subcompanyid;
	}
	else if(user.getUID()!=1)
	{
		if(RecordSet.getDBType().equals("oracle"))
			innersql += " and nvl(b.subcompanyid,0) in ("+subcompanyids+")";
		else
			innersql += " and isnull(b.subcompanyid,0) in ("+subcompanyids+")";
	}
}
if(detachable==1)
{
	if(RecordSet.getDBType().equals("oracle"))
		sql = "select distinct count(distinct a.workflowid) count, a.monitorhrmid,a.subcompanyid,nvl(a.monitortype,0) as monitortype,t.typename,t.typeorder from  workflow_monitor_bound a left join Workflow_MonitorType t on a.monitortype=t.id where 1=1 and exists(select 1 from workflow_base b where b.id=a.workflowid and b.isvalid='1' "+innersql+") ";
	else
		sql = "select distinct count(distinct a.workflowid) count, a.monitorhrmid,a.subcompanyid,isnull(a.monitortype,0) as monitortype,t.typename,t.typeorder from  workflow_monitor_bound a left join Workflow_MonitorType t on a.monitortype=t.id where 1=1 and exists(select 1 from workflow_base b where b.id=a.workflowid and b.isvalid='1' "+innersql+") ";
}
else
{
	if(RecordSet.getDBType().equals("oracle"))
		sql = "select distinct count(distinct a.workflowid) count, a.monitorhrmid,nvl(a.monitortype,0) as monitortype,t.typename,t.typeorder from  workflow_monitor_bound a left join Workflow_MonitorType t on a.monitortype=t.id where 1=1 and exists(select 1 from workflow_base b where b.id=a.workflowid and b.isvalid='1') ";
	else
		sql = "select distinct count(distinct a.workflowid) count, a.monitorhrmid,isnull(a.monitortype,0) as monitortype,t.typename,t.typeorder from  workflow_monitor_bound a left join Workflow_MonitorType t on a.monitortype=t.id where 1=1 and exists(select 1 from workflow_base b where b.id=a.workflowid and b.isvalid='1') ";
}
if(typeid>0)
{
	
	if(RecordSet.getDBType().equals("oracle"))
		sql += " and nvl(a.monitortype,0) = "+typeid;
	else
		sql += " and isnull(a.monitortype,0) = "+typeid;
}
if(operatelevel<0)
{
	sql += " and 1=2 ";
}
if(detachable==1)
{
	if(RecordSet.getDBType().equals("oracle"))
		sql += " group by  a.monitorhrmid,a.subcompanyid,nvl(a.monitortype,0),t.typename,t.typeorder order by a.subcompanyid,t.typeorder, a.monitorhrmid ";
	else
		sql += " group by  a.monitorhrmid,a.subcompanyid,isnull(a.monitortype,0),t.typename,t.typeorder order by a.subcompanyid,t.typeorder, a.monitorhrmid ";
}
else
{
	if(RecordSet.getDBType().equals("oracle"))
		sql += " group by  a.monitorhrmid,nvl(a.monitortype,0),t.typename,t.typeorder order by t.typeorder, a.monitorhrmid ";
	else
		sql += " group by  a.monitorhrmid,isnull(a.monitortype,0),t.typename,t.typeorder order by t.typeorder, a.monitorhrmid ";
}
//out.println("sql : "+sql);
RecordSet.executeSql(sql);
%>


<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(operatelevel>1||subcompanyid2.size()>0)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/system/systemmonitor/workflow/systemMonitorSet.jsp?subcompanyid="+subcompanyid+"&typeid="+typeid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
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

<TABLE class=ListStyle cellspacing=1 >
  <THEAD>
  <COLGROUP>
   <!--xwj for td2903 20051020 begin-->
   <COL align=left width="5%">
   <COL align=left width="15%">
   <%if (detachable == 1){ %><COL align=left width="10%"><%} %>
   <COL align=left width="10%">
   <!--COL align=left width="21%"-->
   <COL align=left width="11%">
   <COL align=left width="11%">
   <COL align=left width="7%">
   
   <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(18560,user.getLanguage())%></TH>
    <%if (detachable == 1){ %><TH><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></TH><%} %><!-- 所属分部 -->
    <TH><%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%></TH><!-- 监控类型 -->
    <!--TH><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></TH-->
    <TH><%=SystemEnv.getHtmlLabelName(18561,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(18562,user.getLanguage())%></TH>
		<TH><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TH>
   </TR>
    <!--xwj for td2903 20051020 end-->
  </THEAD>

<%
int colorcount=0;
int no = 0;
while(RecordSet.next())
{
	if(user.getUID()==1)
	{
		operatelevel = 2;
	}
	else if(subcompanyid1.indexOf(RecordSet.getString("subcompanyid"))>-1)
		operatelevel = 1;
	else if(subcompanyid2.indexOf(RecordSet.getString("subcompanyid"))>-1)
		operatelevel = 2;
		
	no++;
	if(colorcount==0)
	{
        colorcount=1;
    %>
    <TR class=DataLight>
    <%
    }
	else
    {
        colorcount=0;
    %>
    <TR class=DataDark>
	<%
	}
	%>
    <TD><%=no%></TD>
    <TD><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("monitorhrmid")),user.getLanguage())%></TD>
    <%if (detachable == 1){ %><TD><%=Util.toScreen(subCompInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%></TD><%} %>
    <TD><%=Util.toScreen(RecordSet.getString("typename"),user.getLanguage())%></TD>
    <!--TD><%=RecordSet.getString("operatordate")+" "+RecordSet.getString("operatortime")%></TD-->
    <TD><%=RecordSet.getInt("count")%></TD>
    <TD><A href="systemMonitorDetail.jsp?monitorhrmid=<%=RecordSet.getString("monitorhrmid")%>&subcompanyid=<%=RecordSet.getString("subcompanyid") %>&typeid=<%=RecordSet.getString("monitortype") %>">
    <%=SystemEnv.getHtmlLabelName(18562,user.getLanguage())%>
     </A>
    </TD>
    <!--xwj for td2903 20051020 begin-->
    <TD>
       <%if(operatelevel>0){%><A href="systemMonitorSet.jsp?monitorhrmid=<%=RecordSet.getString("monitorhrmid")%>&subcompanyid=<%=RecordSet.getString("subcompanyid") %>&typeid=<%=RecordSet.getString("monitortype") %>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a><%} %> 
       <%if(operatelevel>1){%><a href="javascript:del('<%=RecordSet.getString("monitorhrmid")%>','<%=RecordSet.getString("subcompanyid") %>','<%=RecordSet.getString("monitortype") %>')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%}%>
    </TD>
    <!--xwj for td2903 20051020 end-->
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




</BODY>


<script language="JavaScript">
   function del(id,subid,typeid){
	   if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>"))
	   {
		   var url = "/system/systemmonitor/workflow/systemMonitorOperation.jsp?monitorhrmid="+id+"&actionKey=del&subcompanyid="+subid+"&typeid="+typeid+"&detachable=<%=detachable%>";
		   window.location.href=url;
	   }
   }
 </script>

</HTML>

