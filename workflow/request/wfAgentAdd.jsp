<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
 <%@ include file="/systeminfo/init.jsp" %>
 <%@ page import="weaver.general.TimeUtil"%><%--xwj for td2551 20050822--%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsCheck" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2551 20050902--%>
<jsp:useBean id="rsCheck_" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2551 200509022--%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
</HEAD>

<%
String info = (String)request.getParameter("infoKey");
%>
<script language="JavaScript">
function stopBar(scrollarea,mainarea){
	var scroll_area = scrollarea;
	var main_area = mainarea;
	scroll_area.style.display='none';
   // main_area.style.display='inline';
}
<%if(info!=null && !"".equals(info)){

  if("1".equals(info)){%>
 alert("<%=SystemEnv.getHtmlNoteName(80,user.getLanguage())%>")
 <%}
 else{
 }
 }%>
</script>



<%
ArrayList arr = new ArrayList();
int userid=user.getUID();
//added by xwj for td2551 20050902
String changeBeagentId = (String)request.getParameter("changeBeagentId");
if(changeBeagentId != null && !"".equals(changeBeagentId)){
userid = Integer.parseInt(changeBeagentId);
}
String checked="";
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18461,user.getLanguage());
String needfav ="1";
String needhelp ="";
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
  usertype = 1;
String seclevel = user.getSeclevel();

int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
String workflowname=WorkflowComInfo.getWorkflowname(String.valueOf(workflowid));

boolean haveAgentAllRight=false;
if(HrmUserVarify.checkUserRight("WorkflowAgent:All", user)){
  haveAgentAllRight=true;
}

//int beagenterId=0; xwj for td2551 20050902
int agenterId=0;
String beginDate="";
String beginTime="";
String endDate="";
String endTime="";
int isCreateAgenter=0;
int rowsum=0;

if(!haveAgentAllRight){
   //beagenterId=userid;   xwj for td2551 20050902
  if (workflowid!=-1)
{
  rs.executeSql("select * from Workflow_Agent where workflowid="+workflowid+ " and beagenterId="+userid); // xwj for td2551 20050822
  if(rs.next()){
    agenterId=rs.getInt("agenterId");
    beginDate=rs.getString("beginDate");
    beginTime=rs.getString("beginTime");
    endDate=rs.getString("endDate");
    endTime=rs.getString("endTime");
    isCreateAgenter=rs.getInt("isCreateAgenter");
  }
}
}
%>

<body>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table id="scrollarea" name="scrollarea" width="100%" height="100%" style="zIndex:-1" >
		<tr>
			<td align="center" valign="center">
				<fieldset style="width:30%">
					<img src="/images/loading2.gif" alt="请稍候..."><%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%></fieldset>
			</td>
		</tr>
	</table>
<table id="mainarea" name="mainarea" border=0 cellpadding="0" cellspacing="0" width="100%" style="zIndex:100" >
		<tr>
		<td>
<FORM name="frmmain" action="/workflow/request/wfAgentOperatorNew.jsp" method="post">
  <input type="hidden" value="<%=haveAgentAllRight%>" name="haveAgentAllRight">
  <input type="hidden" value="<%=workflowid%>" name="workflowid">
  <input type="hidden" value="add" name="method">
  <input type="hidden" value="<%=usertype%>" name="usertype" />
  <TABLE class="ViewForm">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>   

  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

     <!--被代理人-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></TD>
    <TD class="Field">
    <%if (haveAgentAllRight) {%>
    <button type="button"   class="Browser" id="SelectBeagenter" onclick="onShowHrmBeAgent(beagenterspan,beagenterId)"></BUTTON><!--xwj for td2551 20050902--> 
      <SPAN id="beagenterspan">
         <A href="javaScript:openhrm(<%=userid%>);" onclick='pointerXY(event);'>
         <%=Util.toScreen(ResourceComInfo.getResourcename((new Integer(userid)).toString()),user.getLanguage())%>
         </A>
      </SPAN> 
      <INPUT type="hidden" name="beagenterId"  id ="beagenterId" value=<%=userid%>>
  <%} else {%>  
      <SPAN id="agentidspan"><A href="javaScript:openhrm(<%=userid%>);" onclick='pointerXY(event);'>
      <%=user.getUsername()%></A></SPAN>
              <INPUT type="hidden" name="beagenterId" value="<%=userid%>">
  <%}%>
      </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--代理人-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></TD>
    <TD class="Field">
      <INPUT type="hidden" class="wuiBrowser" name="agenterId"  id ="agenterId" value="<%=agenterId==0?"":""%>"
      _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename((new Integer(agenterId)).toString()),user.getLanguage())%>"
      _displayTemplate="<A href='javaScript:openhrm(#b{id});' onclick='pointerXY(event);'>#b{name} </A>"
      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
      _required="yes"
      />
    </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--开始时间-->
  <TR>          
  <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD class="Field">
      
      <button type="button"   class="Calendar" id="SelectBeginDate" onclick="onshowAgentBDate()"></BUTTON> 
      <SPAN id="begindatespan"><%if (!beginDate.equals("")) {%><%=beginDate%><%}%></SPAN> 
      &nbsp;&nbsp;&nbsp;
      <button type="button"   class="Clock" id="SelectBeginTime" onclick="onshowAgentTime('begintimespan','beginTime')"></BUTTON>
      <SPAN id="begintimespan"><%if (!beginTime.equals("")) {%><%=beginTime%><%}%></SPAN></TD>
       
       <INPUT type="hidden" name="beginDate" id="beginDate" value=<%=beginDate%>>
       <INPUT type="hidden" name="beginTime" id="beginTime" value=<%=beginTime%>>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--结束时间-->
  <TR>    <TD><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD class="Field">
     
      <button type="button"   class="Calendar" id="SelectEndDate" onclick="onshowAgentEDate()"></BUTTON> 
      <SPAN id="enddatespan"><%if (!endDate.equals("")) {%><%=endDate%><%}%></SPAN> 
      &nbsp;&nbsp;&nbsp;
      <button type="button"   class="Clock" id="SelectEndTime" onclick="onshowAgentTime('endtimespan','endTime')"></BUTTON>
      <SPAN id="endtimespan"><%if (!endTime.equals("")) {%><%=endTime%><%}%></SPAN> </TD>
  
       <INPUT type="hidden" name="endDate" value=<%=endDate%>>
       <INPUT type="hidden" name="endTime" value=<%=endTime%>>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR> 

    <!--是否为可创建代理-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17577,user.getLanguage())%></TD>
    <TD class="Field">
       <INPUT class=InputStyle type=checkbox value=1 name='isCreateAgenter'>
   </TD>
  </TR>
  <TR style="height:1px"><TD class="Line" colSpan="2"></TD></TR>
  <!--是否处理待办事宜-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></TD>
    <TD class="Field">
       <INPUT class=InputStyle type=checkbox value=1 style="display:" name='isPendThing' >
   </TD>
  </TR>
  <TR style="height:1px"><TD class="Line" colSpan="2"></TD></TR>
  </TBODY>
  </TABLE>
  
<%-- xwj for td2483 20050812 begin --%>
<!--WF tree begin-->
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


<table class="viewform" style="">
<%
ArrayList typeids=new ArrayList();
ArrayList workflowids=new ArrayList();
//modify by xhheng @20050920 for 代码优化
String sql = "";
if(usertype ==0){
    //原代码问题：两表连接无意义，为什么要连接
	sql = "select distinct workflowtype from workflow_base " ;
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
        //原代码问题：已经distinct了，又何必判断typeids.indexOf(RecordSet.getString("workflowtype"))==-1
		typeids.add(RecordSet.getString("workflowtype"));
	}
}
else if(usertype ==1){
    typeids.add("29");
}

//modify by xhheng @20050920 for TD 2744
//原代码意义不明，删除。修改为从workflow_base中检索流程，解决没有创建人的流程不能代理的问题
if(usertype ==0){
	sql = "select * from workflow_base order by workflowname " ;
	//RecordSet.executeSql(sql);
	while(RecordSet.next()){
        workflowids.add(RecordSet.getString("id"));
	}
}
else if(usertype ==1){
    //客户用户只能代理“外部访问者支持”类型的流程
	sql = "select id from workflow_base where workflowtype=29 order by workflowname";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
        workflowids.add(RecordSet.getString("id"));
	}
}
%>
  <tr class="Title">
     	<TH colSpan=2>
      	<!--Modified by xwj for td2578 20050822-->
      	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>
      	&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%><input type="checkbox" name="selectAll" onclick="selecAll()" checked>
      	</TH>
  </tr>
  <TR class="Spacing">
        <TD class="Line1" colSpan=2></TD>
  </TR>
  
  <%
  String checkSql = "";//xwj for td2551 20050902
  boolean checkFlag = true;//xwj for td2551 20050902
  int count = 0;//xwj for td2551 20050902
  String currentDate=TimeUtil.getCurrentDateString();//xwj for td2551 20050902
  String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);//xwj for td2551 20050902
	int typecate = typeids.size();
	int rownum = typecate/2;
	if((typecate-rownum*2)!=0)  rownum=rownum+1;
  %>
  <tr class=field>
        <td width="50%" align=left valign=top>
        <%
 	int needtd=rownum;
 	for(int i=0;i<typeids.size();i++){
 	   count = 0;//xwj for td2551 20050902
 		String typeid = (String)typeids.get(i);
 	
 		String typename=WorkTypeComInfo.getWorkTypename(typeid);
 		needtd--;
 	%>
 	<table class="viewform">
		<tr class=field>
		  <td colspan=2 align=left>
		  
		   		  <%//added by xwj for td2551 20050902
		  for(int h=0;h<workflowids.size();h++){
		  String workflowid2 = (String)workflowids.get(h);
			String workflowname2=WorkflowComInfo.getWorkflowname(workflowid2);
		 	String curtypeid2 = WorkflowComInfo.getWorkflowtype(workflowid2);
		 if(curtypeid2.equals(typeid)){
		 checkSql = " select * from workflow_Agent where workflowId="+ workflowid2 +" and beagenterId=" + userid + 
    " and agenttype = '1' " + 
    " and ( ( (endDate = '" + currentDate + "' and (endTime='' or endTime is null))" + 
    " or (endDate = '" + currentDate + "' and endTime > '" + currentTime + "' ) ) " + 
    " or endDate > '" + currentDate + "' or endDate = '' or endDate is null)" +
    " and ( ( (beginDate = '" + currentDate + "' and (beginTime='' or beginTime is null))" + 
	  " or (beginDate = '" + currentDate + "' and beginTime < '" + currentTime + "' ) ) " + 
	  " or beginDate < '" + currentDate + "' or beginDate = '' or beginDate is null)";
	  rsCheck_.executeSql(checkSql);
	  if(!rsCheck_.next()){
	  count++;
      //modify by xhheng @20050920 for 代码优化
      //count仅用来判断是否>0,故大于0后就不要在继续循环了
      break;
	  }
	  }
	  }
	  %>
		  
		   		  <%if(count>-1){
		  arr.add(typeid);%><!--xwj for td2551 20050902-->
		  <input type="checkbox" name="t<%=typeid%>" value="T<%=typeid%>" onclick="checkMain('<%=typeid%>')" checked>
		 <!--mackjoe for td2737 2005-09-09 begin-->
		  <img src="/images/btnDocExpand.gif" BORDER="0" HEIGHT="12px" WIDTH="12px" style="CURSOR: hand" name="img<%=typeid%>" onclick="show(<%=typeid%>,<%=usertype%>)"></img>
		  <a href="#" style="COLOR: #000000;TEXT-DECORATION: none" onclick="show(<%=typeid%>,<%=usertype%>)"><b><%=typename%></b></a> 
		   <%}%>
		  </td></tr>	
		</table>
    <div id="s<%=typeid%>" style="display:none">
     <!--table class="viewform"-->       
    <!--mackjoe for td2737 2005-09-09 end-->  
 				   <!--xwj for td2551 20050902 begin-->
 	<%
 	  
		for(int j=0;j<workflowids.size();j++){
		  String workflowid1 = (String)workflowids.get(j);
			String workflowname1=WorkflowComInfo.getWorkflowname(workflowid1);
		 	String curtypeid = WorkflowComInfo.getWorkflowtype(workflowid1);
		 if(!curtypeid.equals(typeid)){
		 	    continue;
		 }
		 checkSql = " select * from workflow_Agent where workflowId="+ workflowid1 +" and beagenterId=" + userid + 
    " and agenttype = '1' " + 
    " and ( ( (endDate = '" + currentDate + "' and (endTime='' or endTime is null))" + 
    " or (endDate = '" + currentDate + "' and endTime > '" + currentTime + "' ) ) " + 
    " or endDate > '" + currentDate + "' or endDate = '' or endDate is null)" +
    " and ( ( (beginDate = '" + currentDate + "' and (beginTime='' or beginTime is null))" + 
	  " or (beginDate = '" + currentDate + "' and beginTime < '" + currentTime + "' ) ) " + 
	  " or beginDate < '" + currentDate + "' or beginDate = '' or beginDate is null)";
	  rsCheck.executeSql(checkSql);
	  if(rsCheck.next()){
	   checkFlag = false;
	  }
	  else{
	  checkFlag = true;
	  }
	 %>
		<tr class="field">
		  <td width="20%"></td>
      <%if(checkFlag){%>
		  <td>
		    
		    <input type="checkbox" name="w<%=typeid%>" value="W<%=workflowid1%>" onclick="checkSub('<%=typeid%>')" checked><!--xwj for td2578 20050822-->
		    <%=workflowname1%>
		  </td>
		  <%}%>
		   <!--xwj for td2551 20050902 end-->
		  
		  </tr>
	<%
		}
	%>
	<!--/table-->
    </div>
	<%
		if(needtd==0){
			needtd=typecate/2;
	%>
		</td><td align=left valign=top>
	<%
		}
	}
	%>		
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
<!--WF tree end-->
<%-- xwj for td2483 20050812 end --%>


</FORM>
</td></tr></table>
<script>
stopBar(scrollarea,mainarea);
</script>
</body>


<script language="VBS">
sub onShowHrm(spanname,inputename)
  id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
  if (Not IsEmpty(id)) then
  if id(0)<> "" then
    spanname.innerHTML= "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
    inputename.value=id(0)
  else 
    spanname.innerHTML= "<IMG src='/images/BacoError.gif' align=absMiddle>"
    inputename.value=""
  end if
  end if
end sub

<!--added by xwj for td2551 20050902 begin-->
sub onShowHrmBeAgent1(spanname,inputename)
  id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
  if (Not IsEmpty(id)) then
  if id(0)<> "" then
    spanname.innerHTML= "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
    inputename.value=id(0)
    location.href = "/workflow/request/wfAgentAdd.jsp?changeBeagentId="+id(0)
  else 
    spanname.innerHTML= "<IMG src='/images/BacoError.gif' align=absMiddle>"
    inputename.value=""
  end if
  end if
end sub
<!--added by xwj for td2551 20050902 end-->
</script>


<script language="JavaScript">
<!--added by xwj for td2551 20050822 begin-->
function selecAll(){
var flag = document.all('selectAll').checked;
var len = document.frmmain.elements.length;
var i=0;
var mainKey;
var subKey;

<%for(int h=0; h<arr.size(); h++){%>
mainKey = "t"+<%=arr.get(h)%>;
document.all(mainKey).checked=flag;
for( i=0; i<len; i++) {
   subKey = "w"+<%=arr.get(h)%>;
   if (document.frmmain.elements[i].name==subKey) {
        document.frmmain.elements[i].checked= flag ;
      } 
  }

<%}%> 
}
<!--added by xwj for td2551 20050822 end-->

function doSave(obj){
	//加入提交前的时间判断
	var beginDateTime = document.frmmain.beginDate.value+' '+document.frmmain.beginTime.value;
	var endDateTime = document.frmmain.endDate.value+' '+document.frmmain.endTime.value;
	if(beginDateTime.valueOf()>endDateTime.valueOf()) {
		alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
		return;
	}
   document.all("method").value="add";
   if(document.frmmain.beagenterId.value==0){
       alert("<%=SystemEnv.getHtmlNoteName(81,user.getLanguage())%>");
   }
   else if(document.frmmain.agenterId.value==0){
       alert("<%=SystemEnv.getHtmlNoteName(82,user.getLanguage())%>");
   }
   else if(document.frmmain.beagenterId.value==document.frmmain.agenterId.value){
        alert("<%=SystemEnv.getHtmlNoteName(83,user.getLanguage())%>");
   }
   else{
       window.document.frmmain.submit();
       obj.disabled = true;
   }
 
}


function goBack() {
	
	document.location.href="/workflow/request/wfAgentStatistic.jsp" //xwj for td3218 20051201
}


function checkMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("t"+id).checked ;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='w'+id) {
            document.frmmain.elements[i].checked= mainchecked ;
        } 
    } 
}


function checkSub(id) {
    len = document.frmmain.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='w'+id) {
    	if(!document.frmmain.elements[i].checked){
    		document.all("t"+id).checked = false;
    		return;
    		}
    	} 
    }
    document.all("t"+id).checked = true; 
}

function submitData()
{
	if (check_form(weaver,''))
		weaver.submit();
}

function submitDel()
{
	if(isdel()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}
function show(obj,usertype){
    var imgs="img"+obj;
    var sss="s"+obj; 
    if(document.all(sss).style.display=="none"){
    	//added by cyril on 2008-08-25 for td:9236
    	document.all("scrollarea").style.display = "";
    	document.all("mainarea").style.display = "";
    	var req;
    	if (window.XMLHttpRequest) {
        	req = new XMLHttpRequest(); 
    	}
    	else if (window.ActiveXObject){ 
        	req = new ActiveXObject("Microsoft.XMLHTTP"); 
        }
        if(req){
            req.open("GET","wfAgentAddAjax.jsp?typeid="+obj+"&usertype="+usertype, true);
            req.onreadystatechange = function() {
            	if (req.readyState == 4 && req.status == 200) {
                	//alert(req.responseText);
                	document.all(sss).innerHTML = req.responseText;
                	document.all(sss).style.display="";
                	document.all(imgs).src="/images/btnDocCollapse.gif";
                	document.all("t"+obj).checked = true;
                	req = null
                	stopBar(scrollarea,mainarea);
            	}
            }; 
            req.send(null);
        }
    	//end by cyril on 2008-08-25 for td:9236
    }else{
        document.all(sss).style.display="none";
        document.all(imgs).src="/images/btnDocExpand.gif";
    }
}

function onShowHrmBeAgent(spanname,inputename){
  var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
  if (results){
	  if (results.id!="") {
	    spanname.innerHTML= "<A href='javaScript:openhrm("+results.id+");' onclick='pointerXY(event);'>"+results.name+"</A>"
	    inputename.value=results.id
	    location.href = "/workflow/request/wfAgentAdd.jsp?changeBeagentId="+results.id;
	  }else{ 
	    spanname.innerHTML= "<IMG src='/images/BacoError.gif' align=absMiddle>"
	    inputename.value=""
	  }
  }
}

</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</html>
