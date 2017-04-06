<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil"%> <%--xwj for td2483--%>
 <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<%
String info = (String)request.getParameter("infoKey");
%>
<script language="JavaScript">
<%if(info!=null && !"".equals(info)){

  if("1".equals(info)){%>
 alert("<%=SystemEnv.getHtmlNoteName(76,user.getLanguage())%>")
 <%}
 else if("2".equals(info)){%>
 alert("<%=SystemEnv.getHtmlNoteName(77,user.getLanguage())%>")
 <%}
 
 else if("3".equals(info)){%>
 alert("<%=SystemEnv.getHtmlNoteName(78,user.getLanguage())%>")
 <%}
 else if("4".equals(info)){%>
 alert("<%=SystemEnv.getHtmlNoteName(79,user.getLanguage())%>")
 <%}
 else if("5".equals(info)){%>
 alert("<%=SystemEnv.getHtmlLabelName(26802,user.getLanguage())%>")
 <%}
 }%>
</script>


<%
boolean haveAgentAllRight=false;
if(HrmUserVarify.checkUserRight("WorkflowAgent:All", user)){
  haveAgentAllRight=true;
}

//added by xwj fortd2483 20050812
String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18455,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<%
int userid=user.getUID();
String sql = "";
String sql1 = "";
//xwj for td2483
//lv for td29452
if(RecordSet.getDBType().equals("oracle")){
sql = "select count(*) count,t1.beagenterid,t1.agenterid from workflow_agent t1 join workflow_base t2 on t1.workflowid=t2.id where " + 
    " t1.agenttype = '1' " +  
    " and ( ( (t1.endDate = '" + currentDate + "' and (t1.endTime='' or t1.endTime is null))" + 
    " or (t1.endDate = '" + currentDate + "' and t1.endTime > '" + currentTime + "' ) ) " + 
    " or t1.endDate > '" + currentDate + "' or t1.endDate = '' or t1.endDate is null)" +
   
    " group by t1.beagenterid,t1.agenterid having t1.beagenterid = " + userid;
}
else{
sql = "select count(*) count,t1.beagenterid,t1.agenterid from workflow_agent t1 join workflow_base t2 on t1.workflowid=t2.id where " + 
    " t1.agenttype = '1' " +  
    " and ( ( (t1.endDate = '" + currentDate + "' and (t1.endTime='' or t1.endTime is null))" + 
    " or (t1.endDate = '" + currentDate + "' and t1.endTime > '" + currentTime + "' ) ) " + 
    " or t1.endDate > '" + currentDate + "' or t1.endDate = '' or t1.endDate is null)" +
   
    " group by t1.beagenterid,t1.agenterid having t1.beagenterid = " + userid;
}
//out.print("sql=="+sql+"<br>");
RecordSet.executeSql(sql);
%>
<%--
if(RecordSet.getDBType().equals("oracle")){
sql1 = "select count(*) count,t1.beagenterid,t1.agenterid from workflow_agent t1 join workflow_base t2 on t1.workflowid=t2.id where " + 

    " t1.agenttype = '1' " +  
    " and ( ( (t1.endDate = '" + currentDate + "' and (t1.endTime='' or t1.endTime is null))" + 
    " or (t1.endDate = '" + currentDate + "' and t1.endTime > '" + currentTime + "' ) ) " + 
    " or t1.endDate > '" + currentDate + "' or t1.endDate = '' or t1.endDate is null)" +
   

    " group by t1.beagenterid,t1.agenterid having t1.beagenterid <> " + userid;
}
else{
sql1 = "select count(*) count,t1.beagenterid,t1.agenterid from workflow_agent t1 join workflow_base t2 on t1.workflowid=t2.id where " + 

    " t1.agenttype = '1' " +  
    " and ( ( (t1.endDate = '" + currentDate + "' and (t1.endTime='' or t1.endTime is null))" + 
    " or (t1.endDate = '" + currentDate + "' and t1.endTime > '" + currentTime + "' ) ) " + 
    " or t1.endDate > '" + currentDate + "' or t1.endDate = '' or t1.endDate is null)" +
   

    " group by t1.beagenterid,t1.agenterid having t1.beagenterid <> " + userid;
}
//TD8860 按被代理人排序
sql1 += " order by beagenterId";
//out.print("sql1=="+sql1+"<br>");
RecordSet1.executeSql(sql1);
--%>


<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/workflow/request/wfAgentAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",/workflow/request/wfAgentList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(24183,user.getLanguage())+",/workflow/request/requestAgentList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("AgentLog:View", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/workflow/request/agentLogList.jsp,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id="frmMain" name="frmMain" action="wfAgentOperatorNew.jsp" method="post">
<input type="hidden" value="listDetail" name="method">
<input type="hidden" value="" name="beaid">
<input type="hidden" value="" name="aid">
<input type="hidden" value="n" name="isCountermandRunning">
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
<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  <TR>
    <TH align="left"><%=SystemEnv.getHtmlLabelName(18456,user.getLanguage())%></TH></TR>
</TBODY></TABLE>

<%
String beagenterid = "";
String agenterid = "";
String agentId="";
%>

<!--操作者本身的有效代理列表 begin-->
<TABLE class=ListStyle cellspacing=1 width="90%">
  <COLGROUP  width="90%" align="center">
<%--   <COL align=left width="10%">--%>
   <COL align=left width="15%">
   <COL align=left width="15%">
   <COL align=left width="15%">
   <COL align=left width="15%">
   <COL align=left width="40%">
   <TR class=Header>
<%--    <TH><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>--%>
    <TH><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(16851,user.getLanguage())%></TH><%--td2483 for xwj 20050812--%>
    <TH><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(18458,user.getLanguage())%></TH>
  </TR>

<%
int colorcount=0;
int no = 0;
while(RecordSet.next()){
beagenterid = RecordSet.getString("beagenterid");
agenterid = RecordSet.getString("agenterid");
agentId=RecordSet.getString("agentId");
no++;
if(colorcount==0){
        colorcount=1;
    %>
    <TR class=DataLight>
    <%
        }else{
            colorcount=0;
    %>
    <TR class=DataDark>
  <%
  }
  %>
<%--    <TD><%=no%></TD>--%>
    <TD><%=Util.toScreen(ResourceComInfo.getResourcename(beagenterid),user.getLanguage())%></TD>
    <TD><%=Util.toScreen(ResourceComInfo.getResourcename(agenterid),user.getLanguage())%></TD>
    <TD><%=RecordSet.getInt("count")%></TD>
    <TD>
         <A href="wfAgentList.jsp?beagentid=<%=beagenterid%>&agentid=<%=agenterid%>&agenttype=1">
    <%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>
     </A>
    </TD>
    <TD>
      <A href="javascript:countermand('<%=beagenterid%>','<%=agenterid%>')">
    <%=SystemEnv.getHtmlLabelName(18459,user.getLanguage())%>
    </A>
    <input type="checkbox" name="<%=beagenterid%><%=agenterid%>" value="1" checked>
    <%=SystemEnv.getHtmlLabelName(18460,user.getLanguage())%>
    </TD>
</TR>
<%}%>

</TABLE>
<!--操作者本身的有效代理列表 end-->
<br><br>
<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  <TR>
    <TH align="left" width="80%">&nbsp;<%=SystemEnv.getHtmlLabelName(18457,user.getLanguage())%></TH>
  </TR>
  </TBODY>
</TABLE>

<!--其它操作者本身的有效代理列表 begin-->
<%--<TABLE  class=ListStyle cellspacing=1>--%>
<%--  <COLGROUP width="90%" align="left" >--%>
<%--   <COL align=left width="10%">--%>
<%--   <COL align=left width="15%">--%>
<%--   <COL align=left width="15%">--%>
<%--   <COL align=left width="15%">--%>
<%--   <COL align=left width="15%">--%>
<%--   <COL align=left width="30%">--%>
<%--   <TR class=Header>--%>
<%--    <TH><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>--%>
<%--    <TH><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></TH>--%>
<%--    <TH><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></TH>--%>
<%--    <TH><%=SystemEnv.getHtmlLabelName(16851,user.getLanguage())%></TH>--%>
<%--    <TH><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%></TH>--%>
<%--    <TH><%=SystemEnv.getHtmlLabelName(18458,user.getLanguage())%></TH>--%>
<%--  </TR>--%>
<%--<%--%>
<%--colorcount=0;--%>
<%--no = 0;--%>
<%--while(RecordSet1.next()){--%>
<%--beagenterid = RecordSet1.getString("beagenterid");--%>
<%--agenterid = RecordSet1.getString("agenterid");--%>
<%--agentId=RecordSet1.getString("agentId");--%>
<%--no++;--%>
<%--if(colorcount==0){--%>
<%--        colorcount=1;--%>
<%--    %>--%>
<%--    <TR class=DataLight>--%>
<%--    <%--%>
<%--        }else{--%>
<%--            colorcount=0;--%>
<%--    %>--%>
<%--    <TR class=DataDark>--%>
<%--  <%--%>
<%--  }--%>
<%--  %>--%>
<%--    <TD><%=no%></TD>--%>
<%--    <TD><%=Util.toScreen(ResourceComInfo.getResourcename(beagenterid),user.getLanguage())%></TD>--%>
<%--    <TD><%=Util.toScreen(ResourceComInfo.getResourcename(agenterid),user.getLanguage())%></TD>--%>
<%--    <TD><%=RecordSet1.getInt("count")%></TD>--%>
<%--    <TD>--%>
<%--      <A href="wfAgentList.jsp?beagentid=<%=beagenterid%>&agentid=<%=agenterid%>&agenttype=1">--%>
<%--    <%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>--%>
<%--     </A>--%>
<%--    </TD>--%>
<%--    <TD>--%>
<%--    --%>
<%--    <%if(haveAgentAllRight){%>--%>
<%--      <A href="javascript:countermand('<%=beagenterid%>','<%=agenterid%>')">--%>
<%--    <%=SystemEnv.getHtmlLabelName(18459,user.getLanguage())%>--%>
<%--    </A>--%>
<%--    <input type="checkbox" name="<%=beagenterid%><%=agenterid%>" value="1" checked>--%>
<%--    <%=SystemEnv.getHtmlLabelName(18460,user.getLanguage())%>--%>
<%--    <%}%>--%>
<%--    </TD>--%>
<%--</TR>--%>
<%--<%}%>--%>
<%--</TABLE>--%>
<!--其它者本身的有效代理列表 end-->
<!--其它者本身的有效代理列表-分页 start-->
<%
//得到pageNum 与 perpage
//int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
//int perpage = UserDefaultManager.getNumperpage();
//if(perpage <2) perpage=15;
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
if(perpage <2) perpage=10;
String tableString = "";
String backfields = " A.beagenterid,A.agenterid,A.countList ";

//String sqlwhere = " agenttype = '1' " +  
                  //" and ( ( (endDate = '" + currentDate + "' and (endTime='' or endTime is null))" + 
                  //" or (endDate = '" + currentDate + "' and endTime > '" + currentTime + "' ) ) " + 
                  //" or endDate > '" + currentDate + "' or endDate = '' or endDate is null)"+
                  //" group by agentId,beagenterid,agenterid having beagenterid <> " + userid;
String sqlwhere = " 1=1 ";

String fromSql  = " FROM (select t1.beagenterid,t1.agenterid,count(*) as countList "+
                    " from workflow_agent t1 join workflow_base t2 on t1.workflowid=t2.id  "+
                    " where t1.agenttype = '1' "+
                       " and (((t1.endDate = '"+currentDate+"' and (t1.endTime = '' or t1.endTime is null)) or "+
                             " (t1.endDate = '"+currentDate+"' and t1.endTime > '"+currentTime+"')) or t1.endDate > '"+currentDate+"' or t1.endDate = '' or t1.endDate is null) "+
                      " group by t1.beagenterid, t1.agenterid having t1.beagenterid <> "+userid+" ) A ";
//out.print("select "+backfields + "from "+fromSql+" where "+sqlwhere);
//String sqlgroupby="agentId,beagenterid,agenterid having beagenterid <> " + userid;
String orderBy=" A.beagenterid ";
tableString ="<table  instanceid=\"\"  tabletype=\"none\" pagesize=\""+perpage+"\">"+
             "	   <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"A.beagenterid\" sqlsortway=\"asc\" />"+
			 "			<head>"+
			 //"				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"\" />"+
             "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17565,user.getLanguage())+"\" column=\"beagenterid\"  transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
			 "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17566,user.getLanguage())+"\" column=\"agenterid\"    transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
			 "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16851 ,user.getLanguage())+"\" column=\"countList\"/>"+
			 "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(320 ,user.getLanguage())+"\" column=\"beagenterid\" otherpara=\"column:agenterid+"+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getCompanyOper1\" target=\"mainFrame\"/>"+
			 "				<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(18458 ,user.getLanguage())+"\" column=\"beagenterid\" otherpara=\"column:agenterid+"+user.getLanguage()+"+"+haveAgentAllRight+"\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getCompanyOper2\"  target=\"mainFrame\" />"+
			 "			</head>"+
			 "</table>";
%>
<wea:SplitPageTag  tableString="<%=tableString%>" isShowTopInfo="false" mode="run" />
<%--<TABLE width="100%">--%>
<%--    <tr>--%>
<%--        <td valign="top">  --%>
<%--            <wea:SplitPageTag  tableString="<%=tableString%>" isShowTopInfo="false" mode="run" />--%>
<%--        </td>--%>
<%--    </tr>--%>
<%--</TABLE>--%>
<!--其它者本身的有效代理列表-分页 end-->
</td>
</tr>
</TABLE>
</td>
<td>
</td>
</tr>
<tr>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

</FORM>


<script language="JavaScript">

function countermand(beaid_,aid_){
if($G(beaid_ + aid_).checked == true){
	$G("isCountermandRunning").value = "y";
}
$G("method").value="countermand";
$G("beaid").value=beaid_;
$G("aid").value=aid_;
$G("frmMain").submit();
}


</script>


</BODY>
</HTML>
