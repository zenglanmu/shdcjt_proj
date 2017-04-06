<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdSystem.gif";
String titlename =SystemEnv.getHtmlLabelName(385,user.getLanguage())+SystemEnv.getHtmlLabelName(80,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanTran = HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user);
String fromid=Util.null2String(request.getParameter("fromid"));
String toid=Util.null2String(request.getParameter("toid"));

//for CRM
String crmidstr=Util.fromScreen(request.getParameter("crmidstr"),user.getLanguage());
String crmall=Util.fromScreen(request.getParameter("crmall"),user.getLanguage());
int crmallnum=0;
int crmnum=0;
ArrayList crmids=new ArrayList();
if(!crmidstr.equals("")){
	crmids=Util.TokenizerString(crmidstr,",");
	crmnum=crmids.size();
}

//for project
String projectidstr=Util.fromScreen(request.getParameter("projectidstr"),user.getLanguage());
String projectall=Util.fromScreen(request.getParameter("projectall"),user.getLanguage());
int projectallnum=0;
int projectnum=0;
ArrayList projectids= new ArrayList();
if(!projectidstr.equals("")){
	projectids=Util.TokenizerString(projectidstr,",");
	projectnum=projectids.size();
}

//for resource
String resourceidstr=Util.fromScreen(request.getParameter("resourceidstr"),user.getLanguage());
String resourceall=Util.fromScreen(request.getParameter("resourceall"),user.getLanguage());
int resourceallnum=0;
int resourcenum=0;
ArrayList resourceids=new ArrayList();
if(!resourceidstr.equals("")){
	resourceids=Util.TokenizerString(resourceidstr,",");
	resourcenum=resourceids.size();
}

//for doc
String docidstr=Util.fromScreen(request.getParameter("docidstr"),user.getLanguage());
String docall=Util.fromScreen(request.getParameter("docall"),user.getLanguage());
int docallnum=0;
int docnum=0;
ArrayList docids=new ArrayList();
if(!docidstr.equals("")){
	docids=Util.TokenizerString(docidstr,",");
	docnum=docids.size();
}

//for event
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
{
    usertype= 1;
}

String eventIDStr=Util.fromScreen(request.getParameter("eventIDStr"),user.getLanguage());
String eventAll=Util.fromScreen(request.getParameter("eventAll"),user.getLanguage());
int eventAllNum=0;
int eventNum=0;
ArrayList eventIDs=new ArrayList();

if(!eventIDStr.equals("")){
    eventIDs=Util.TokenizerString(eventIDStr,",");
    eventNum=eventIDs.size();
}

String coworkIDStr=Util.fromScreen(request.getParameter("coworkIDStr"),user.getLanguage());
String coworkAll=Util.fromScreen(request.getParameter("coworkAll"),user.getLanguage());
int coworkAllNum=0;
int coworkNum=0;
ArrayList coworkIDs=new ArrayList();
if(!coworkIDStr.equals("")){
		coworkIDs=Util.TokenizerString(coworkIDStr,",");
    coworkNum=coworkIDs.size();
}

if(!fromid.equals(""))
{
	//update by alan on 2009-08-17 for td:11539
	String sql="select count(id) from DocDetail where maincategory!=0  and subcategory!=0 and seccategory!=0 and ";
	sql += "id IN (select max(id) from DocDetail where ownerid="+fromid+" and (ishistory is null or ishistory = 0) group by parentids)";
	RecordSet.executeSql(sql);
	RecordSet.next();
	docallnum=RecordSet.getInt(1);

	RecordSet.executeProc("HrmResource_SCountBySubordinat",fromid);
	RecordSet.next();
	resourceallnum=RecordSet.getInt(1);

	RecordSet.executeProc("CRM_Info_SelectCountByResource",fromid);
	RecordSet.next();
	crmallnum=RecordSet.getInt(1);

	RecordSet.executeProc("Prj_Info_SelectCountByResource",fromid);
	RecordSet.next();
	projectallnum=RecordSet.getInt(1);
    
	StringBuffer stringBuffer = new StringBuffer();
	stringBuffer.append("SELECT DISTINCT a.workflowId, a.requestId FROM Workflow_RequestBase a, Workflow_CurrentOperator b");
	stringBuffer.append(" WHERE a.requestId = b.requestId");
	stringBuffer.append(" AND b.isRemark in ('2', '4')");
	stringBuffer.append(" AND isComplete = 1 AND isLastTimes = 1");
	stringBuffer.append(" AND userId = ");
	stringBuffer.append(fromid);
	stringBuffer.append(" AND userType = ");	
	stringBuffer.append(usertype);
	
	//System.out.println(stringBuffer.toString());
    RecordSet.executeSql(stringBuffer.toString());
    
    while(RecordSet.next())
    {
        String workflowId = Util.null2String(RecordSet.getString("workflowId"));
        
        if("1".equals(WorkflowComInfo.getIsValid(workflowId)))
        {            
            eventAllNum++;
        }
    }
    
    //System.out.print(eventAllNum);
    
    RecordSet.executeSql("select count(*) from cowork_items where coworkmanager="+fromid);
  	if(RecordSet.next()) coworkAllNum = RecordSet.getInt(1);
    
}

if(crmall.equals("1"))	crmnum=crmallnum;
if(projectall.equals("1"))	projectnum=projectallnum;
if(resourceall.equals("1"))	resourcenum=resourceallnum;
if(docall.equals("1"))	docnum=docallnum;
if(eventAll.equals("1"))  eventNum=eventAllNum;
if(coworkAll.equals("1"))  coworkNum=coworkAllNum;

int i=0;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanTran){
RCMenu += "{"+SystemEnv.getHtmlLabelName(553,user.getLanguage())+",javascript:submitData(),_self} " ;
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

<form id=frmmain name=frmmain method=post action="HrmRightTransferOperation.jsp" >
<input class=inputstyle type=hidden name="type">
<input class=inputstyle type=hidden name="crmidstr" value="<%=crmidstr%>">
<input class=inputstyle type=hidden name="projectidstr" value="<%=projectidstr%>">
<input class=inputstyle type=hidden name="resourceidstr" value="<%=resourceidstr%>">
<input class=inputstyle type=hidden name="docidstr" value="<%=docidstr%>">
<input class=inputstyle type=hidden name="eventIDStr" value="<%=eventIDStr%>"><!-- apollo-->
<input class=inputstyle type=hidden name="coworkIDStr" value="<%=coworkIDStr%>">

<input class=inputstyle type=hidden name="crmallFlag" value="1">
<input class=inputstyle type=hidden name="projectallFlag" value="1">
<input class=inputstyle type=hidden name="resourceallFlag" value="1">
<input class=inputstyle type=hidden name="docallFlag" value="1">
<input class=inputstyle type=hidden name="eventAllFlag" value="1"><!-- apollo-->
<input class=inputstyle type=hidden name="coworkAllFlag" value="1">

<table class=viewform>
  <COLGROUP>
    <COL width="10%">
    <COL width="33%">
    <COL width=24>
    <COL width="10%">
    <COL width="10%">
    <COL width="33%">
  <TBODY>
  
  <TR class=title>
    <TD colSpan=6><B><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></B></TD>
  </TR>
  
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=6></TD>
  </TR>
  
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%></td>
    <td class=field><%if(CanTran){%><button type=button  class=Browser onClick="getFromid()"></button><%}%>&nbsp;
      <span id=fromidspan><%if(fromid.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%} else {%>
        <%=ResourceComInfo.getResourcename(fromid)%><%}%>
      </span>
      <input class=inputstyle type=hidden name="fromid" value="<%=fromid%>"></td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></td>
    <td><input class=inputstyle type="checkbox" <%if(crmallnum==0){%>disabled=false<%}%> name="crmall" value=1
     <%if(crmall.equals("1")||(crmnum==crmallnum&&crmidstr.equals(""))){%> checked <%}%> onClick="crmCheckboxSelect()">
     	<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
     	<input class=inputstyle type=hidden name="crmallnum" value="<%=crmallnum%>"></td>
    <td class=field><button type=button  id="selectCrmButton" <%if(crmallnum==0){%>disabled=false<%}%> class=Browser onClick="selectCRM()"></button>
     ( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><span id="crmNum"> <%=crmnum%></span>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=crmallnum%> )
    </td>
  </tr>
  
  <TR style="height:1px;">
    <TD class=Line colSpan=6></TD>
  </TR>
  
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%></td>
    <td class=field><%if(CanTran){%><button type=button  class=Browser onClick="getToid()"></button><%}%>&nbsp;
      <span id=toidspan><%if(toid.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%} else {%>
        <%=ResourceComInfo.getResourcename(toid)%><%}%>
      </span>
      <input class=inputstyle type=hidden name="toid" value="<%=toid%>"></td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
    <td><input class=inputstyle type="checkbox" <%if(projectallnum==0){%>disabled=false<%}%> name="projectall" value=1
      <%if(projectall.equals("1")||(projectnum==projectallnum&&projectidstr.equals(""))){%> checked <%}%> onClick="projectCheckboxSelect()">
       <%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
      <input class=inputstyle type=hidden name="projectallnum" value="<%=projectallnum%>"></td>
    <td class=field><button type=button  id="selectProjectButton" <%if(projectallnum==0){%>disabled=false<%}%> class=Browser onClick="selectProject()"></button>
      ( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><span id="projectNum"> <%=projectnum%></span>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=projectallnum%> )
    </td>
  </tr>
  
  <TR style="height:1px;">
    <TD class=Line colSpan=6></TD>
  </TR>
  
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
    <td><input class=inputstyle type="checkbox" <%if(resourceallnum==0){%>disabled=false<%}%> name="resourceall" value=1
      <%if(resourceall.equals("1")||(resourcenum==resourceallnum&&resourceidstr.equals(""))){%> checked <%}%> onClick="resourceCheckboxSelect()">
      <%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
      <input class=inputstyle type=hidden name="resourceallnum" value="<%=resourceallnum%>"></td>
    <td class=field><button type=button  class=Browser <%if(resourceallnum==0){%>disabled=false<%}%> onClick="selectResource()"></button>
      ( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><span id="resourceNum"> <%=resourcenum%></span>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=resourceallnum%> )
    </td>
  </tr>
  
  <TR style="height:1px;">
    <TD></TD><TD></TD><TD></TD>    
    <TD class=Line colSpan=3 ></TD>
  </TR>
  
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
    <td><input class=inputstyle type="checkbox" <%if(docallnum==0){%>disabled=false<%}%> name="docall" value=1
    <%
      if(docall.equals("1")||(docnum==docallnum)){%> checked <%}%> onClick="docCheckboxSelect()">
        <%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
    	<input class=inputstyle type=hidden name="docallnum" value="<%=docallnum%>"></td>
        <td class=field><button type=button  id="selectDocButton" class=Browser <%if(docallnum==0){%>disabled=false<%}%> onClick="selectDoc()"></button>
     	( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><span id="docNum"> <%=docnum%></span>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=docallnum%> )
    </td>
  </tr>
    
  <TR style="height:1px;">  
    <TD></TD><TD></TD><TD></TD>
    <TD class=Line colSpan=3 ></TD>
  </TR>
  
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(17992,user.getLanguage())%></td>
    <td><input class=inputstyle type="checkbox" <%if(eventAllNum==0){%>disabled=false<%}%> name="eventAll" value=1
    <%
      if(eventAll.equals("1")||(eventNum==eventAllNum)){%> checked <%}%> onClick="eventCheckboxSelect()">
        <%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
        <input class=inputstyle type=hidden name="eventAllNum" value="<%=eventAllNum%>"></td>
        <td class=field><button type=button  id="selectEventButton" class=Browser <%if(eventAllNum==0){%>disabled=false<%}%> onClick="selectEvent()"></button>
        ( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><span id="eventNum"> <%=eventNum%></span>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=eventAllNum%> )
    </td>
  </tr>
    
  <TR style="height:1px;">  
    <TD></TD><TD></TD><TD></TD>
    <TD class=Line colSpan=3 ></TD>
  </TR>
  
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></td>
    <td><input class=inputstyle type="checkbox" <%if(coworkAllNum==0){%>disabled=false<%}%> name="coworkAll" value=1
    <%
      if(coworkAll.equals("1")||(coworkNum==coworkAllNum)){%> checked <%}%> onClick="coworkCheckboxSelect()">
        <%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
        <input class=inputstyle type=hidden name="coworkAllNum" value="<%=coworkAllNum%>"></td>
        <td class=field><button type=button  id="selectCoworkButton" class=Browser <%if(coworkAllNum==0){%>disabled=false<%}%> onClick="selectCowork()"></button>
        ( <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><span id="coworkNum"> <%=coworkNum%></span>,<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%> <%=coworkAllNum%> )
    </td>
  </tr>
    
  <TR style="height:1px;">  
    <TD></TD><TD></TD><TD></TD>
    <TD class=Line colSpan=3 ></TD>
  </TR>
  
  </TBODY>
</table>
</form>
</td>
</tr>

<tr>
<td>
<table class=ReportStyle width="100%">
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(18731,user.getLanguage())%>&nbsp;1</B>:<%=SystemEnv.getHtmlLabelName(18732,user.getLanguage())%>.<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18734,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(18731,user.getLanguage())%>&nbsp;2</B>:<%=SystemEnv.getHtmlLabelName(18733,user.getLanguage())%>.<BR>
<B><%=SystemEnv.getHtmlLabelName(18731,user.getLanguage())%>&nbsp;3</B>:<%=SystemEnv.getHtmlLabelName(18735,user.getLanguage())%>.<BR>
<B><%=SystemEnv.getHtmlLabelName(18731,user.getLanguage())%>&nbsp;4</B>:<%=SystemEnv.getHtmlLabelName(18736,user.getLanguage())%>.<BR>
<B><%=SystemEnv.getHtmlLabelName(18731,user.getLanguage())%>&nbsp;5</B>:<%=SystemEnv.getHtmlLabelName(18737,user.getLanguage())%>.<BR>
<B><%=SystemEnv.getHtmlLabelName(18731,user.getLanguage())%>&nbsp;6</B>:<%=SystemEnv.getHtmlLabelName(18738,user.getLanguage())%>.<BR>
<B><%=SystemEnv.getHtmlLabelName(18731,user.getLanguage())%>&nbsp;7</B>:<%=SystemEnv.getHtmlLabelName(19017,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(18731,user.getLanguage())%>&nbsp;8</B>:<%=SystemEnv.getHtmlLabelName(21261,user.getLanguage())%>
<BR>
<BR>
<BR>
<B><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%></B>:<%=SystemEnv.getHtmlLabelName(18740,user.getLanguage())%><BR>
</TD>
</TR>
</TBODY>
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
<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function getFromid() {
	getFromid2(
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			, $GetEle("fromidspan")
			, $GetEle("fromid")
			, true);
}

function getFromid2(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}

		$GetEle("frmmain").action="HrmRightTransfer.jsp";
		$GetEle("frmmain").submit();
	}
}

function getToid() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			, $GetEle("toidspan")
			, $GetEle("toid")
			, true);
}
</script>

<script language=javascript>
function selectResource(){
	if(!$GetEle("resourceall").checked&&<%=resourceallnum%>!=0){
		$GetEle("type").value=3;
		$GetEle("resourceallFlag").value=$GetEle("resourceall").checked?"1":"0";
		$GetEle("frmmain").action="HrmRightTransferDetail.jsp";
		$GetEle("frmmain").submit();
	}
}
function selectDoc(){
	if(!$GetEle("docall").checked&&<%=docallnum%>!=0){
		$GetEle("type").value=4;
		$GetEle("docallFlag").value=$GetEle("docall").checked?"1":"0";
		$GetEle("frmmain").action="HrmRightTransferDetail.jsp";
		$GetEle("frmmain").submit();
	}
}
function selectCRM(){
	if(!$GetEle("crmall").checked&&<%=crmallnum%>!=0){
		$GetEle("type").value=1;
		$GetEle("crmallFlag").value=$GetEle("crmall").checked?"1":"0";
		$GetEle("frmmain").action="HrmRightTransferDetail.jsp";
		$GetEle("frmmain").submit();
	}
}
function selectProject(){
	if(!$GetEle("projectall").checked&&<%=projectallnum%>!=0){
		$GetEle("type").value=2;
		$GetEle("projectallFlag").value=$GetEle("projectall").checked?"1":"0";
		$GetEle("frmmain").action="HrmRightTransferDetail.jsp";
		$GetEle("frmmain").submit();
	}
}
function selectEvent(){
    if(!$GetEle("eventAll").checked&&<%=eventAllNum%>!=0){
        $GetEle("type").value=5;
        $GetEle("eventAllFlag").value=$GetEle("eventAll").checked?"1":"0";
        
        $GetEle("frmmain").action="HrmRightTransferDetail.jsp";
        $GetEle("frmmain").submit();
    }
}
function selectCowork(){
    if(!$GetEle("coworkAll").checked&&<%=coworkAllNum%>!=0){
        $GetEle("type").value=6;
        $GetEle("coworkAllFlag").value=$GetEle("coworkAll").checked?"1":"0";
        
        $GetEle("frmmain").action="HrmRightTransferDetail.jsp";
        $GetEle("frmmain").submit();
    }
}

function selectAll(){
	$GetEle("frmmain").action="HrmRightTransfer.jsp";
	$GetEle("frmmain").submit();
}
function crmCheckboxSelect(){
	if($GetEle("crmall").checked==true){
		$GetEle("crmNum").innerHTML=" <%=crmallnum%>";
	}
	else{
		$GetEle("crmNum").innerHTML=" 0";
		$GetEle("crmidstr").value="";
    }
}
function projectCheckboxSelect(){
	if($GetEle("projectall").checked==true){
		$GetEle("projectNum").innerHTML="<%=projectallnum%>";
	}
	else{
		$GetEle("projectNum").innerHTML=" 0";
		$GetEle("projectidstr").value="";
    }
}
function resourceCheckboxSelect(){
	if($GetEle("resourceall").checked==true){
		$GetEle("resourceNum").innerHTML="<%=resourceallnum%>";
	}
	else{
		$GetEle("resourceNum").innerHTML=" 0";
		$GetEle("resourceidstr").value="";
    }
}
function docCheckboxSelect(){
	if($GetEle("docall").checked==true){
		$GetEle("docNum").innerHTML=" <%=docallnum%>";
	}
	else{
		docNum.innerHTML=" 0";
		$GetEle("docidstr").value="";
    }
}
function eventCheckboxSelect(){
    if($GetEle("eventAll").checked==true){
    	$GetEle("eventNum").innerHTML="<%=eventAllNum%>";
    }
    else{
    	$GetEle("eventNum").innerHTML=" 0";
    	$GetEle("eventIDStr").value="";
    }
}
function coworkCheckboxSelect(){
    if($GetEle("coworkAll").checked==true){
    	$GetEle("coworkNum").innerHTML="<%=coworkAllNum%>";
    }
    else{
        $GetEle("coworkNum").innerHTML=" 0";
        $GetEle("coworkIDStr").value="";
    }
}


function check_same(){
	if(check_form($GetEle("frmmain"),'fromid,toid')){
		if($GetEle("fromid").value==$GetEle("toid").value){
			alert("<%=SystemEnv.getHtmlNoteName(20,user.getLanguage())%>");
			return false;
		}
		return true;
	}
	return false;
}
function submitData() {
 if(check_same()){
 $GetEle("frmmain").submit();
 }
}
</script>
</body>
</html>