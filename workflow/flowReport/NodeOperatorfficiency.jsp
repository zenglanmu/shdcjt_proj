<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>
<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(19035 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ; 
String userRights=shareRights.getUserRights("-8",user);//得到用户查看范围
   if (userRights.equals("-100")){
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
    }
String typeId=Util.null2String(request.getParameter("typeId"));//得到搜索条件
String flowId=Util.null2String(request.getParameter("flowId"));//得到搜索条件
String nodeType=Util.null2String(request.getParameter("nodeType"));//得到搜索条件    

String fromadridate = Util.null2String(request.getParameter("fromadridate"));//得到到达搜索条件
String toadridate = Util.null2String(request.getParameter("toadridate"));//得到到达搜索条件

String sqlCondition="";
if (userRights.equals(""))
    {sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    } 
//sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") )";

if(!"".equals(fromadridate)) {
	sqlCondition += " and workflow_currentoperator.receivedate >='" +fromadridate+ "'";
}
if(!"".equals(toadridate)) {
	sqlCondition += " and workflow_currentoperator.receivedate <='" +toadridate+ "'";
}

if (!typeId.equals("")&&!typeId.equals("0"))  sqlCondition+=" and workflow_currentoperator.workflowid="+flowId;
else sqlCondition=" and 1=2" ;
if (!flowId.equals("")&&!nodeType.equals(""))
{
RecordSet.execute("select nodeid from workflow_flownode where workflowid="+flowId+" and nodetype='"+nodeType+"' ");
String nodeids="-1";
while (RecordSet.next())
	{
    nodeids=nodeids+","+RecordSet.getInt(1);
}
if(!nodeids.equals("-1"))
{
sqlCondition+=" and workflow_currentoperator.nodeid in ("+nodeids+")" ;
}
else
{
sqlCondition=" and 1=2" ;
}
}


if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
{
RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where trim(operatedate)='' "+sqlCondition);

String sqls="select userid," +
"24*avg(to_date( NVL2(operatedate ,operatedate||' '||operatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
"-to_date(receivedate||' '||receivetime,'YYYY-MM-DD HH24:MI:SS')) as spends "+ 
" from workflow_currentoperator where exists (select 1 from workflow_requestbase where  "+
" workflow_requestbase.requestid=workflow_currentoperator.requestid "+
" and status is not null) "+sqlCondition+
" group by userid order by spends desc ";
RecordSet.execute(sqls);
//out.print(sqls);
}
else
	{
RecordSet.execute("update workflow_currentoperator set operatedate=null,operatetime=null where rtrim(ltrim(operatedate))='' "+sqlCondition);

RecordSet.executeProc("NodeOperatorTime",sqlCondition) ;
	}
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmMain name=frmMain action=NodeOperatorfficiency.jsp method=post>
<!--查询条件-->
<table  class="viewform">
<tr>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field width="30%">
    <!-- select class=inputstyle name=typeId onchange="chageFlowType(this,flowIds,flowId)">
    <option value=""></option>
    <%
         while(WorkTypeComInfo.next()){
         if (!WorkTypeComInfo.getWorkTypeid().equals("1"))
         {
     	String checktmp = "";
     	if(typeId.equals(WorkTypeComInfo.getWorkTypeid()))
     		checktmp=" selected";
		%>
		<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=checktmp%>><%=WorkTypeComInfo.getWorkTypename()%></option>
		<%
		}
		}
		%>
		</select-->
	<BUTTON type='button' class=Browser onClick="onShow('typeId','typeName')" name=showrequest></BUTTON>
    <SPAN id=typeName>
	<%=WorkTypeComInfo.getWorkTypename(""+typeId)%>
	</SPAN>
	<input type=hidden name="typeId" id="typeId" value="<%=typeId%>">
		<SPAN id=nameimage><%if(typeId.equals("")) {%>
	      <IMG src='/images/BacoError.gif' align=absMiddle></IMG>
	    <%}%></span>
		</td>
    
    <td width="10%"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
    <td class=field width="30%">
    <!-- select class=inputstyle name=flowId style="width:160" onchange="changeImage(this)">
    <option value=""></option>
    </select>
    <select class=inputstyle name=flowIds style="display:none">
    <%
    while(WorkflowComInfo.next()){
         
     	String tempFlow = WorkflowComInfo.getWorkflowid();
     	String tempType=WorkflowComInfo.getWorkflowtype(tempFlow);
     		
	%>
	<option value="<%=tempType+"$"+WorkflowComInfo.getWorkflowid()%>"><%=WorkflowComInfo.getWorkflowname()%></option>
	<%
	}
	
	%>
	</select-->
	<BUTTON type='button' class=Browser onClick="onShow2('flowId','flowName')" name=showflow></BUTTON>
    <SPAN id=flowName>
	<%=WorkflowComInfo.getWorkflowname(""+flowId)%>
	</SPAN>
	<input type=hidden name="flowId" id="flowId" value="<%=flowId%>">
	<SPAN id=nameimage1><%if(flowId.equals("")) {%>
	      <IMG src='/images/BacoError.gif' align=absMiddle></IMG>
	    <%}%></span>
	</td>
	</tr>
	
<TR class=Separartor style="height: 1px;"><TD class="Line" COLSPAN=6></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
    <td class=field>
     <select class=inputstyle  size=1 name=nodeType style=width:60>
     	<option value="0" <%if (nodeType.equals("0")) {%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
     	<option value="1" <%if (nodeType.equals("1")) {%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
     	<option value="2" <%if (nodeType.equals("2")) {%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
     	<!-- option value="3" <%if (nodeType.equals("0")) {%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option-->
     </select>
    </td>
	<td width="10%"><%=SystemEnv.getHtmlLabelName(2196,user.getLanguage())%></td>
    <td class=field width="40%">
    <BUTTON type='button' class=calendar id=SelectDate3 onclick=getDate(fromadridatespan,fromadridate)></BUTTON>
	<SPAN id=fromadridatespan><%=fromadridate%></SPAN> 										
	&nbsp;- &nbsp;
	<BUTTON type='button' class=calendar id=SelectDate4 onclick=getDate(toadridatespan,toadridate)></BUTTON>
	<SPAN id=toadridatespan><%=toadridate%></SPAN>
	<input type="hidden" name="fromadridate" value="<%=fromadridate%>">
	<input type="hidden" name="toadridate" value="<%=toadridate%>">
	</td>
	</td>
	</tr>
	<TR class=Separartor style="height: 1px;"><TD class="Line" COLSPAN=6></TD></TR>
</table>
</FORM>
<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
  <COLGROUP>
  <col width="5%">
  <col width="15%">
  <col width="15%">
   <tr class=header>
   <td><%=SystemEnv.getHtmlLabelName(19082,user.getLanguage())%></td><!-- 排名-->
   <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td><!--人员 -->
   <TD><%=SystemEnv.getHtmlLabelName(19059,user.getLanguage())%></TD><!--平均耗时-->
   </tr>
    <% boolean isLight = false ;
      int i=1;
	  while(RecordSet.next()){   
   
            isLight = !isLight ; 
    %>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <td><%=i%></td>
    <td><a href="javaScript:openhrm(<%=RecordSet.getString(1)%>);" onclick='pointerXY(event);'><%=resourceComInfo.getLastname(""+RecordSet.getString(1))%></a></td>
    <td><%=Util.round(RecordSet.getString(2),1)%></td>
    </tr>
    <!--
    <TR class=Line style="height: 1px;"><TD colspan="3" ></TD></TR>
     -->
    <%
       i++;   
      }
   %>
</TABLE>

<!--详细内容结束-->
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
<script>
  function chageFlowType(eventobj,list_obj,target_obj)
  {
	var oOption ;
	var tempstr = eventobj.value +"$";
	target_obj.options.length = 0 ;
	
	oOption = document.createElement("OPTION");
	oOption.text = "";
	oOption.value = "";
	target_obj.options.add(oOption);
	
	if (eventobj.value.length > 0)
	{document.all("nameimage").innerHTML="";
	for (var i=0; i< list_obj.options.length; i++)
	{
		if (list_obj.options(i).value.indexOf(tempstr)>=0)
		{
		oOption = document.createElement("OPTION");
		oOption.text=list_obj.options(i).text;
		oOption.value=list_obj.options(i).value.substr(list_obj.options(i).value.indexOf('$')+1,list_obj.options(i).value.length) ;
		target_obj.options.add(oOption);
		}
	
	 }
    }
    else
    {
    document.all("nameimage").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMG>";
    }
     
  
  }
function changeImage(eventobj)
{
if (eventobj.value.length > 0)
{
document.all("nameimage1").innerHTML="";
}
else
{document.all("nameimage1").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMG>";
}
}  
function submitData()
{   
    if (check_form(frmMain,'typeId,flowId'))
   frmMain.submit();
}

function onShow(inputename,showname){
   var results= window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp");
   if (results) {
        if (results.id!=""){
          $G("nameimage").innerHTML="";
          $G(showname).innerHTML =results.name;
		  $G(inputename).value=results.id;
        }else{
		  $G(showname).innerHTML ="";
          $G(inputename).value="";
          $G("nameimage").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMG>";
        }
          $G("nameimage1").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMG>";
		  $G("flowName").innerHTML ="";
          $G("flowId").value="" ;
    }
}

function onShow2(inputename,showname){
   typeid=$G("typeId").value;
   results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid="+typeid);
   if (results) {
        if (results.id!="") {
          $G("nameimage1").innerHTML=""
          $G(showname).innerHTML =results.name;
		  $G(inputename).value=results.id;
        }else{
          $G("nameimage1").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMG>";
		  $G(showname).innerHTML ="";
          $G(inputename).value="";
       }
   }
}

</script>

<script language=vbs>
sub onShow1(inputename,showname)

   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp")
   if (Not IsEmpty(id)) then
        if id(0)<> "0" then
          document.all("nameimage").innerHTML=""
          document.all(showname).innerHtml = id(1)
		  document.all(inputename).value=id(0)
        else
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
          document.all("nameimage").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMG>"
         end if
          document.all("nameimage1").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMG>"
		  document.all("flowName").innerHtml =""
          document.all("flowId").value="" 
         end if
end sub

sub onShow21(inputename,showname)
   typeid=document.all("typeId").value
   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid="&typeid)
   if (Not IsEmpty(id)) then
        if id(0)<> "" then
          document.all("nameimage1").innerHTML=""
          document.all(showname).innerHtml = id(1)
		  document.all(inputename).value=id(0)
        else
		 
          document.all("nameimage1").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMG>"
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
         end if
         end if
end sub

</SCRIPT>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
