<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@page import="org.json.JSONObject"%> 
<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
    if(!HrmUserVarify.checkUserRight("AgentLog:View", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    
    String imagefilename = "/images/hdReport.gif";
    String titlename =  SystemEnv.getHtmlLabelName(17723,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/request/agentLogList.jsp,_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
String workflowname = Util.null2String(request.getParameter("workflowname"));
String agentid = Util.null2String(request.getParameter("agentid"));
String beagentedid = Util.null2String(request.getParameter("beagentedid"));
String fromdate1 = Util.null2String(request.getParameter("fromdate1"));
String todate1 = Util.null2String(request.getParameter("todate1"));
String fromdate2 = Util.null2String(request.getParameter("fromdate2"));
String todate2 = Util.null2String(request.getParameter("todate2"));

String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);

int userid = user.getUID();

String sqlwhere = " a.workflowid=b.id ";
if(!agentid.equals("")) sqlwhere += " and a.agenterid="+agentid;
if(!beagentedid.equals("")) sqlwhere += " and a.beagenterid="+beagentedid;
if(!fromdate1.equals("")) sqlwhere += " and a.operatordate>='"+fromdate1+"'";
if(!todate1.equals("")) sqlwhere += " and a.operatordate<='"+todate1+"'";
if(!fromdate2.equals("")) sqlwhere += " and (a.backDate>='"+fromdate2+"' or a.backDate is null or a.backDate = '')";
if(!todate2.equals("")) sqlwhere += " and (a.backDate<='"+todate2+"' or a.backDate is null or a.backDate = '')";
if(!workflowname.equals("")) sqlwhere += " and b.workflowname like '%"+workflowname+"%'";

String sql = "select a.agenterid,a.beagenterid,a.operatordate,a.backDate,a.agenttype,b.workflowname from workflow_agent a, workflow_base b where "+sqlwhere;

RecordSet.executeSql(sql);
//out.print(sql);
%>

<br>

<form name=frmmain method=post action="agentLogDetailList.jsp">
<table width=100% height=100% border="0" cellspacing="1" cellpadding="0">
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
                <table class="viewform">
                    <colgroup>
                    <col width="49%">
                    <col width="">
                    <col width="49%">
            
										<tr><td valign="top" colspan=3>
										<TABLE class=ViewForm>
										<TR>		
												<td><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></td>
												<TD CLASS="Field" colspan=3>
													<input class="inputstyle" type="text" id="workflowname" name="workflowname" value="<%=workflowname%>">
												</TD>
										</TR>
										<TR>		
												<td><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></td>
												<TD CLASS="Field">
												<span id="agentnamespan"><%=ResourceComInfo.getResourcename(agentid)%></span>
												<input name="agentid" type=hidden value="<%=agentid%>">
												</TD>
							
												<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></TD>
												<TD CLASS="Field">
												<span id="beagentednamaspan"><%=ResourceComInfo.getResourcename(beagentedid)%></span>
												<input name="beagentedid" type=hidden value="<%=beagentedid%>">
												</TD>
										</TR>
										<!-- 2012-08-20 ypc 修改 给该列添加高度-->
										<TR style="height:4%"><td colspan=4 class="line"></td></TR>
										<TR>	
											<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(24116,user.getLanguage())%></TD>
											<TD width ="20%" CLASS="Field"> 
												<!-- 必须加上type="button" 2012-08-20 ypc 修改 -->
												<BUTTON type="button" class=calendar id=SelectDate1  onclick="gettheDate(fromdate1,fromdate1span)"></BUTTON>
												<SPAN id=fromdate1span><%=fromdate1%></SPAN>
												-&nbsp;&nbsp;
												<!-- 必须加上type="button" 2012-08-20 ypc 修改 -->
												<BUTTON type="button" class=calendar id=SelectDate2 onclick="gettheDate(todate1,todate1span)"></BUTTON>
												<SPAN id=todate1span><%=todate1%></SPAN>
												<input type="hidden" name="fromdate1" value="<%=fromdate1%>">
												<input type="hidden" name="todate1" value="<%=todate1%>">
											</TD>
											<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(24117,user.getLanguage())%></TD>
											<TD width ="20%" CLASS="Field"> 
												<!-- 必须加上type="button" 2012-08-20 ypc 修改 -->
												<BUTTON type="button" class=calendar id=SelectDate3  onclick="gettheDate(fromdate2,fromdate2span)"></BUTTON>
												<SPAN id=fromdate2span><%=fromdate2%></SPAN>
												-&nbsp;&nbsp;
												 <!-- 必须加上type="button" 2012-08-20 ypc 修改 -->
												<BUTTON type="button" class=calendar id=SelectDate4 onclick="gettheDate(todate2,todate2span)"></BUTTON>
												<SPAN id=todate2span><%=todate2%></SPAN>
												<input type="hidden" name="fromdate2" value="<%=fromdate2%>">
												<input type="hidden" name="todate2" value="<%=todate2%>">
											</TD>
										</TR>
									</TABLE>
								</td></tr>                    
                    <!-- 2012-08-20 ypc 修改 给该列添加高度-->
                    <tr style="height:4%"><td class="line" colspan="3"></td></tr>
                    
                    <tr>
                    	<td valign="top" colspan="3">
                    		<table class=ListStyle>
                    		<COLGROUP>
                    		<COL align=left width="5%">
                    		<COL align=left width="15%">
                    		<COL align=left width="15%">
                    		<COL align=left width="35%">
                    		<COL align=left width="15%">
                    		<COL align=left width="15%">
                    			<tr class=Header>
                    				<th><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></th>
                    				<th><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></th>
                    				<th><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></th>
                    				<th><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></th>
                    				<th><%=SystemEnv.getHtmlLabelName(24116,user.getLanguage())%></th>
                    				<th><%=SystemEnv.getHtmlLabelName(24117,user.getLanguage())%></th>
                    			</tr>
                    			<%
                    			int rowindex = 1;
                    			int colorindex = 0;
                    			while(RecordSet.next()){
                    			    String agenterid = RecordSet.getString("agenterid");
                    			    String beagenterid = RecordSet.getString("beagenterid");
                    			    String tempworkflowname = RecordSet.getString("workflowname");
                    			    String operatordate = Util.null2String(RecordSet.getString("operatordate"));
                    			    String backDate = Util.null2String(RecordSet.getString("backDate"));
                    			    
                    			    String agenttype = Util.null2String(RecordSet.getString("agenttype"));
                    			    if(agenttype.equals("0")&&backDate.equals("")){//已经收回代理的旧数据，没有收回时间
                    			        backDate = SystemEnv.getHtmlLabelName(18661,user.getLanguage());
                    			    }
                    			    if(colorindex==0){
                    			        colorindex = 1;
                    			%>
                    			    <tr class="datadark">
                    			    <%
                    			    }else{
                    			        colorindex = 0;
                    			    %>
                    			    <tr class="datalight">
                    			    <%}%>
                    			    <td><%=rowindex%></td>
                    			    <td><%=ResourceComInfo.getResourcename(beagenterid)%></td>
                    			    <td><%=ResourceComInfo.getResourcename(agenterid)%></td>
                    			    <td><%=tempworkflowname%></td>
                    			    <td><%=operatordate%></td>
                    			    <td><%=backDate%></td>
                    			<%
                    			    rowindex++;
                    			}
                    			%>
                    		</table>
                    	</td>
                    </tr>
                </table>

                </td>
            </tr>
            <tr>
                <td height="10"></td>
            </tr>
        </table>
    </td>
    <td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</form>
</body>
</html>

<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>

<script type="text/javascript">
    function doSearch(){
        frmmain.submit();
    }
    function searchDetail(beagenterid,agenterid){
        frmmain.action="";
        frmmain.submit();
    }
</script>		    