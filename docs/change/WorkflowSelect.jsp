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
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
</HEAD>

<%
if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String info = (String)request.getParameter("infoKey");
%>
<script language="JavaScript">
function stopBar(scrollarea,mainarea){
	var scroll_area = scrollarea;
	var main_area = mainarea;
	scroll_area.style.display='none';
    main_area.style.display='';
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
String titlename = SystemEnv.getHtmlLabelName(22876,user.getLanguage());
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
<!--TD4262 增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<!--TD4262 增加提示信息  结束-->
<table id="scrollarea" name="scrollarea" width="100%" height="100%" style="display:inline;zIndex:-1" >
		<tr>
			<td align="center" valign="center">
				<fieldset style="width:30%">
					<img src="/images/loading2.gif" alt="请稍候..."><%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%></fieldset>
			</td>
		</tr>
	</table>
<table id="mainarea" name="mainarea" border=0 cellpadding="0" cellspacing="0" height="100%" width="100%" style="display:none;zIndex:100" valign="top" align="top">
		<tr>
		<td valign="top">
<FORM name="frmmain" action="/docs/change/DocChangeOpterator.jsp" method="post">
<input name="method" value="add" type="hidden" />
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

<TABLE class="Shadow">
<tr>
<td valign="top">


<table class=ListStyle cellspacing=1>
<%
ArrayList typeids=new ArrayList();
ArrayList workflowids=new ArrayList();
String sql = "";
sql = "select distinct t1.workflowtype from workflow_base t1, workflow_createdoc t2 where t2.status='1' AND t2.flowDocField>0 AND t1.id=t2.workflowid and t1.isvalid=1 ";
if(DocChangeManager.cversion.equals("4")) {
	sql += " and t1.id in(select t1.id from workflow_base t1,workflow_fieldLable fieldLable,workflow_formField formField, workflow_formdict formDict"; 
	sql += " where fieldLable.formid = formField.formid ";
	sql += " and fieldLable.fieldid = formField.fieldid "; 
	sql += " and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "; 
	sql += " and formField.formid = t1.formid and fieldLable.langurageid = "+user.getLanguage(); 
	sql += " and formDict.fieldHtmlType = '3' and formDict.type = 9 ";
	sql += " group by t1.id) ";
}
sql += " and t1.id not in(select workflowid from DocChangeWorkflow)" ;
//out.println(sql);
RecordSet.executeSql(sql);
while(RecordSet.next()){
       //原代码问题：已经distinct了，又何必判断typeids.indexOf(RecordSet.getString("workflowtype"))==-1
	typeids.add(RecordSet.getString("workflowtype"));
}

sql = "select t1.id from workflow_base t1, workflow_createdoc t2 where t2.status='1' AND t2.flowDocField>0 AND t1.id=t2.workflowid  and t1.isvalid=1 ";
sql += " and t1.id in(select t1.id from workflow_base t1,workflow_fieldLable fieldLable,workflow_formField formField, workflow_formdict formDict"; 
sql += " where fieldLable.formid = formField.formid ";
sql += " and fieldLable.fieldid = formField.fieldid "; 
sql += " and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "; 
sql += " and formField.formid = t1.formid and fieldLable.langurageid = "+user.getLanguage(); 
sql += " and formDict.fieldHtmlType = '3' and formDict.type = 9 ";
sql += " group by t1.id) ";
sql += " and t1.id not in(select workflowid from DocChangeWorkflow)" ;
//RecordSet.executeSql(sql);
while(RecordSet.next()){
       workflowids.add(RecordSet.getString("id"));
}
%>
  <tr class="Title">
     	<TH colSpan=2>
      	<!--Modified by xwj for td2578 20050822-->
      	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>
      	&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%><input type="checkbox" name="selectAll" onclick="selecAll()">
      	</TH>
  </tr>
  <TR class="Spacing" style="height:1px;">
        <TD class="Line1" colSpan=2 style="height:1px; margin:0px;padding:0px;"></TD>
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
		 
	  }
	  %>
		  
		   		  <%
		  arr.add(typeid);%><!--xwj for td2551 20050902-->
		  <input type="checkbox" name="t<%=typeid%>" value="T<%=typeid%>" onclick="checkMain('<%=typeid%>')">
		 <!--mackjoe for td2737 2005-09-09 begin-->
		  <img src="\images\btnDocExpand.gif" BORDER="0" HEIGHT="12px" WIDTH="12px" style="CURSOR: hand" name="img<%=typeid%>" onclick="show(<%=typeid%>,<%=usertype%>)"></img>
		  <a href="#" style="COLOR: #000000;TEXT-DECORATION: none" onclick="show(<%=typeid%>,<%=usertype%>)"><b><%=typename%></b></a> 
		   <%%>
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
	 %>
		<tr class="field">
		  <td width="20%"></td>
		  
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
sub onShowHrmBeAgent(spanname,inputename)
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
	window.document.frmmain.submit();
	obj.disabled = true;
}


function goBack() {
	
	document.location.href="/docs/change/DocChangeSetting.jsp" //xwj for td3218 20051201
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
	showLoading();
    var imgs="img"+obj;
    var sss="s"+obj; 
    if(document.all(sss).style.display=="none"){
    	//added by cyril on 2008-08-25 for td:9236
    	//document.all("scrollarea").style.display = "";
    	//document.all("mainarea").style.display = "";
    	var req;
    	if (window.XMLHttpRequest) {
        	req = new XMLHttpRequest(); 
    	}
    	else if (window.ActiveXObject){ 
        	req = new ActiveXObject("Microsoft.XMLHTTP"); 
        }
        if(req){
            req.open("GET","WorkflowSelectDetail.jsp?typeid="+obj+"&usertype="+usertype, true);
            req.onreadystatechange = function() {
            	if (req.readyState == 4 && req.status == 200) {
                	//alert(req.responseText);
                	document.all(sss).innerHTML = req.responseText;
                	document.all(sss).style.display="";
                	document.all(imgs).src="/images/btnDocCollapse.gif";
                	document.all("t"+obj).checked = true;
                	req = null
                	//stopBar(scrollarea,mainarea);
                	document.getElementById('_xTable').style.display = 'none';
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

function showLoading() {
	var datacontent='<img src="/images/loadingext.gif"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>';
	var datadivshow = false;
	try {
		showPrompt(datacontent);
		datadivshow = true;
	}
	catch(e) {}
}

//TD4262 增加提示信息  开始
//提示窗口
function showPrompt(content)
{
   var showTableDiv  = document.getElementById('_xTable');
   var message_table_Div = document.createElement("<div>")
   message_table_Div.id="message_table_Div";
   message_table_Div.className="xTable_message";
   showTableDiv.appendChild(message_table_Div);
   var message_table_Div  = document.getElementById("message_table_Div");
   message_table_Div.style.display="inline";
   message_table_Div.innerHTML=content;
   var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
   var pLeft= document.body.offsetWidth/2-50;
   message_table_Div.style.position="absolute"
   message_table_Div.style.posTop=pTop;
   message_table_Div.style.posLeft=pLeft;

   message_table_Div.style.zIndex=1002;
   var oIframe = document.createElement('iframe');
   oIframe.id = 'HelpFrame';
   showTableDiv.appendChild(oIframe);
   oIframe.frameborder = 0;
   oIframe.style.position = 'absolute';
   oIframe.style.top = pTop;
   oIframe.style.left = pLeft;
   oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
   oIframe.style.width = parseInt(message_table_Div.offsetWidth);
   oIframe.style.height = parseInt(message_table_Div.offsetHeight);
   oIframe.style.display = 'block';
}
//TD4262 增加提示信息  结束
</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</html>
