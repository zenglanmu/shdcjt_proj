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
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/request/wfAgentStatistic.jsp,_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
String agentid = Util.null2String(request.getParameter("agentid"));
String beagentedid = Util.null2String(request.getParameter("beagentedid"));
String fromdate1 = Util.null2String(request.getParameter("fromdate1"));
String todate1 = Util.null2String(request.getParameter("todate1"));
String fromdate2 = Util.null2String(request.getParameter("fromdate2"));
String todate2 = Util.null2String(request.getParameter("todate2"));

String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);

int userid = user.getUID();

String sqlwhere = " 1=1 ";
if(!agentid.equals("")) sqlwhere += " and agenterid="+agentid;
if(!beagentedid.equals("")) sqlwhere += " and beagenterid="+beagentedid;
if(!fromdate1.equals("")) sqlwhere += " and operatordate>='"+fromdate1+"'";
if(!todate1.equals("")) sqlwhere += " and operatordate<='"+todate1+"'";
if(!fromdate2.equals("")) sqlwhere += " and backDate>='"+fromdate2+"'";
if(!todate2.equals("")) sqlwhere += " and backDate<='"+todate2+"'";

String sql = "select count(*) as count,beagenterid,agenterid from workflow_agent where "+
             sqlwhere+" group by beagenterid,agenterid ";
RecordSet.executeSql(sql);
//out.print(sql);
%>

<br>

<form name="frmmain" id="frmmain" method=post action="agentLogList.jsp">
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
            
										<tr ><td valign="top" colspan=3>
										<TABLE class=ViewForm>
											<TR>		
												<td><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></td>
												<TD CLASS="Field">
												<!-- <button type="button" class="browser" onclick="onShowResource(agentid,agentnamespan)"></button> -->
												<button type="button" class="browser" onclick="onShowResource()"></button>
												<!-- <span id="agentnamespan"><%=ResourceComInfo.getResourcename(agentid)%></span>-->
												<span id="agentnamespan"></span>
												<input name="agentid" type=hidden value="<%=agentid%>">
												</TD>
							
												<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></TD>
												<TD CLASS="Field">
												<button type="button" class="browser" onClick="onShowResource1()"></button>
												<!-- <span id="beagentednamaspan"><%=ResourceComInfo.getResourcename(beagentedid)%></span> -->
												<span id="beagentednamaspan"></span>
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
                    		<COL align=left width="30%">
                    		<COL align=left width="30%">
                    		<COL align=left width="15%">
                    		<COL align=left width="20%">
                    			<tr class=Header>
                    				<th><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></th>
                    				<th><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></th>
                    				<th><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></th>
                    				<th><%=SystemEnv.getHtmlLabelName(16851,user.getLanguage())%></th>
                    				<th><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%></th>
                    			</tr>
                    			<%
                    			int rowindex = 1;
                    			int colorindex = 0;
                    			while(RecordSet.next()){
                    			    String counts = RecordSet.getString("count");
                    			    String agenterid = RecordSet.getString("agenterid");
                    			    String beagenterid = RecordSet.getString("beagenterid");
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
                    			    <td><%=counts%></td>
                    			    <td><a href="#" onclick="searchDetail(<%=beagenterid%>,<%=agenterid%>)"><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%></a></td>
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
<!--
<script language=vbs>
    sub onShowResource(inputname,spanname)
        id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
        if NOT isempty(id) then
            if id(0)<> "" then
                spanname.innerHtml = id(1)
                inputname.value=id(0)
            else
                spanname.innerHtml = ""
                inputname.value=""
            end if
        end if
    end sub
</script>  -->
<!-- 2012-08-20 YPC 修改 把VB改成js-->
<script type="text/javascript"> 
//2012-08-22 ypc　修改
function onShowResource(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if(results){
	     if (results.id!= "" ){
			agentnamespan.innerHTML=results.name;
			document.frmmain.agentid.value=results.id;
		}
		else{
			agentnamespan.innerHTML=results.name;
			document.frmmain.agentid.value="";
		}
	}
}

//2012-08-22 ypc　修改
function onShowResource1(){
  var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
   if(results){
	   	 if (results.id!= "" ){
			beagentednamaspan.innerHTML=results.name;
			document.frmmain.beagentedid.value=results.id;
		}
		else{
			beagentednamaspan.innerHTML=results.name;
			document.frmmain.beagentedid.value="";
		}
   }
}
</script>
<script type="text/javascript">
    function doSearch(){
        frmmain.submit();
    }
    function searchDetail(beagenterid,agenterid){
    	//2012-08-20 ypc 修改 一下注释的 两行 这种写法不兼容 Google和火狐 
        //document.getElementById("beagentedid").value=beagenterid;
        //document.getElementById("agentid").value=agenterid;
    	document.all("beagentedid").value=beagenterid;
    	document.all("agentid").value=agenterid;
        document.frmmain.action="agentLogDetailList.jsp";
        document.frmmain.submit();
    }
</script>		    