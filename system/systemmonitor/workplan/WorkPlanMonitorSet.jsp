<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">		
		<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
	</HEAD>

<%
    if(!HrmUserVarify.checkUserRight("WorkPlanMonitorSet:Set", user))
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
		
	int userid=user.getUID();
		
	String logintype = user.getLogintype();
	int usertype = 0;
	if(logintype.equals("2"))
	{
		usertype = 1;
	}
	
	//参数传递
	String hrmID = Util.null2String(request.getParameter("hrmID"));
	if(null == hrmID || "".equals(hrmID))
	{
	    hrmID = String.valueOf(userid);
	}
%>

<BODY>
<%
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(19793,user.getLanguage());
	String needfav = "1";
	String needhelp = "";	
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM name="frmmain" action="/system/systemmonitor/workplan/WorkPlanMonitorSetOperation.jsp" method="post">	
   	<!--================== 日程监控人 ================== -->
	<TABLE class="ViewForm">
		<COLGROUP>
			<COL width="20%">
			<COL width="80%">
  		<TBODY>   
  		<TR style="height:1px">
  			<TD class="Line" colSpan="2"></TD>
  		</TR>
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(19794,user.getLanguage())%></TD>
			<TD class="Field">			
						
				<INPUT type="hidden" class="wuiBrowser" name="hrmID" id ="hrmID" value=<%=hrmID%> _displayText="<%= Util.toScreen(ResourceComInfo.getResourcename(hrmID),user.getLanguage()) %>"
					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
					>
		    </TD>
		</TR>
		<TR style="height:1px">
			<TD class="Line" colSpan="2" > </TD>
		</TR>
		</TBODY>
	</TABLE>
  
	<!--================== 日程类型列表 ================== -->
	<TABLE class=ListStyle cellspacing=1>
		<TR class=Header>
			<TH width="5%"><INPUT type=checkbox name="checkAll" id="checkAll" onclick="onCheckAll()"></TH>
			<TH width="95%"><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></TH>
		</TR>
		<TR class=Line>
			<TD colSpan=2></TD>
		</TR>
		<%
			String sql = "SELECT * FROM WorkPlanType ORDER BY workPlanTypeID ASC";
			RecordSet.executeSql(sql);
			int colorCount = 0;
			while(RecordSet.next())
			{		
				if(0 == colorCount)
				{
			        colorCount = 1;
		%>
			<TR class=DataLight>
		<%
			    }
				else
				{
			        colorCount = 0;
		%>
			<TR class=DataDark>
		<%
			  	}
		%>
			    <TD><INPUT id="workPlanTypeIDs" name="workPlanTypeIDs" type=checkbox value=<%= RecordSet.getInt("workPlanTypeID") %>></TD>
			    <TD><%=Util.forHtml(RecordSet.getString("workPlanTypeName")) %></TD>			    
			</TR>
		<%
			}
		%>
	</TABLE>
</FORM>

</BODY>

</HTML>



<SCRIPT language="JavaScript">
function doSave(obj)
{
   var typeids = document.getElementsByName('workPlanTypeIDs');
   var count = typeids.length;
   var cheked = 0;
   for(var i=0;i<count;i++){
      if(typeids[i].checked)
      cheked++
   }
   if(cheked == 0){
      alert('<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>');
      return;
   }
   if(document.frmmain.hrmID.value==0)
   {
       alert("<%=SystemEnv.getHtmlLabelName(19796,user.getLanguage())%>");
   }
   else
   {
       window.document.frmmain.submit();
       obj.disabled = true;
   }
}

function goBack() 
{
	document.location.href="/system/systemmonitor/workplan/WorkPlanMonitorStatic.jsp"
}

function onCheckAll()
{
	var workPlanTypeIDs = document.all("workPlanTypeIDs");

    if(workPlanTypeIDs.length > 1)
    {
    	for(var i = 0; i < workPlanTypeIDs.length; i++)
    	{
    		workPlanTypeIDs[i].checked = document.all("checkAll").checked;
    	}
    }
    else
    {
    	workPlanTypeIDs.checked = document.all("checkAll").checked;
    }    
}

function init()
{
<%
	if(!"".equals(hrmID) && null != hrmID)
	{
%>
		var workPlanTypeIDs = document.all("workPlanTypeIDs");
<%
	    RecordSet.executeSql("SELECT * FROM WorkPlanMonitor WHERE hrmID = " + hrmID);
	    
	    while(RecordSet.next())
	    {
	        String workPlanTypeID = RecordSet.getString("workPlanTypeID");
%>
		    if(workPlanTypeIDs.length > 1)
		    {
		    	for(var i = 0; i < workPlanTypeIDs.length; i++)
		    	{
		    		if(workPlanTypeIDs[i].value == <%= workPlanTypeID %>)
		    		{
		    			workPlanTypeIDs[i].checked = "checked";
		    		}
		    	}
		    }
		    else
		    {
		    	if(workPlanTypeIDs.value == <%= workPlanTypeID %>)
		    	{
		    		workPlanTypeIDs.checked = "checked";
		    	}
		    }
<%
	    }
%>
		var allChecked = true; 
		
		if(workPlanTypeIDs.length > 1)
	    {
	    	for(var i = 0; i < workPlanTypeIDs.length; i++)
	    	{
	    		if(!workPlanTypeIDs[i].checked)
	    		{
	    			allChecked = false;
	    		}
	    	}
	    }
	    else
	    {
	    	if(!workPlanTypeIDs.checked)
	    	{
	    		allChecked = false;	
	    	}
	    }
	    if(allChecked)
	    {
	    	document.all("checkAll").checked = "checked";
	    }
<%	    
	}
%>	
}

init();

</SCRIPT>