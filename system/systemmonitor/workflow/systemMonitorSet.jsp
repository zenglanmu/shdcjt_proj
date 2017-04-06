<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />


<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree.css">
<style>
TABLE.Shadow A {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:hover {
	COLOR: #333; TEXT-DECORATION: none
}

TABLE.Shadow A:link {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:visited {
	TEXT-DECORATION: none
}
</style>
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
<script type="text/javascript" src="/js/xloadtree/xtree4workflowMonitorSet.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4workflow.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
</HEAD>

<%
if(!HrmUserVarify.checkUserRight("WorkflowMonitor:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String info = Util.null2String(request.getParameter("infoKey"));
String wfHomeIcon = "/images/treeimages/Home.gif";
boolean wfintervenor= GCONST.getWorkflowIntervenorByMonitor();
%>
<script language="JavaScript">
<%if(info!=null && !info.equals("")){
    if(info.equals("1")){%>
      alert('<%=SystemEnv.getHtmlLabelName(18563,user.getLanguage())%>')
    <%}
 }%>
</script>



<%
int userid=user.getUID();
int monitorhrmid=Util.getIntValue(request.getParameter("monitorhrmid"),0);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16758,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage());

String needhelp ="";

int monitor=userid;
if(monitorhrmid>0) monitor=monitorhrmid;
String oldtypeid = Util.null2String(request.getParameter("oldtypeid"));
String typeid = Util.null2String(request.getParameter("typeid"));
typeid = (Util.getIntValue(typeid,0)<=0)?"":typeid;
String typename = "";
if(Util.getIntValue(typeid,0)>0)
{
	rs.executeSql("select * from Workflow_MonitorType where id = "+typeid);
	if(rs.next())
	{
		typename = rs.getString("typename");
	}
}
if(Util.getIntValue(oldtypeid,0)<=0&&Util.getIntValue(typeid,0)>0)
{
	oldtypeid = typeid;
}

String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
subcompanyid = (Util.getIntValue(subcompanyid,0)<=0)?"":subcompanyid;

RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
}

String isOpenWorkflowStopOrCancel=GCONST.getWorkflowStopOrCancel();//是否开启流程暂停或取消设置
%>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16216,user.getLanguage())+",javascript:goexpandall(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18466,user.getLanguage())+",javascript:docollapseall(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM name="frmmain" action="/system/systemmonitor/workflow/systemMonitorOperation.jsp" method="post">
<input type=hidden name="actionKey" value="add">
<input type=hidden name="detachable" value="<%=detachable %>">
<INPUT type="hidden" name="oldmonitortypeid"  id ="oldmonitortypeid" value=<%=typeid%>>
  <TABLE class="ViewForm">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>   

  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--代理人-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(18560,user.getLanguage())%></TD>
    <TD class="Field">
	  <BUTTON type="button" class="Browser" id="SelectAgenter" onclick="onShowHrm(Agenterspan,monitorhrmid)"></BUTTON>
      <SPAN id="Agenterspan">
      <A href='javaScript:openhrm(<%=monitor%>);' onclick='pointerXY(event);'>
      <%=Util.toScreen(ResourceComInfo.getResourcename(String.valueOf(monitor)),user.getLanguage())%></A></SPAN>
      <INPUT type="hidden" name="monitorhrmid"  id ="monitorhrmid" value=<%=monitor%>>
      <INPUT type="hidden" name="oldmonitorhrmid"  id ="oldmonitorhrmid" value=<%=monitor%>>
      </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
  <TR>
  	<!-- 监控类型 -->
    <TD><%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%></TD>
    <TD class="Field">

        <INPUT type="hidden" class="wuiBrowser" name="monitortypeid" id ="monitortypeid" _displayText="<%=Util.toScreen(typename,user.getLanguage())%>" value="<%=typeid%>" _required="yes"
        	_url="/systeminfo/BrowserMain.jsp?url=/workflow/monitor/monitortypeBrowser.jsp"
        >
        
    </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
  <TR style="<%if(detachable==1){ %>display:block;<%}else{%>display:none;<%} %>">
  	<!-- 所属分部 -->
    <TD><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></TD>
    <TD class="Field">
        <INPUT type="hidden" class="wuiBrowser" name="subcompanyid"  id ="subcompanyid" value='<%=subcompanyid%>' _displayText="<%=Util.toScreen(subCompInfo.getSubCompanyname(String.valueOf(subcompanyid)),user.getLanguage())%>" _required="yes" 
        	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowMonitor:All&isedit=1" _callBack="onShowSubcompany"
        	>
    </TD>
  </TR>
  <TR style="height:1px;<%if(detachable==1){ %>display:block;<%}else{%>display:none;<%} %>"><TD class="Line" colSpan="2"></TD></TR>
  </TBODY>
  </TABLE>
  
<SPAN id="wfspan">
<TABLE class=ListStyle cellspacing=1 width="100%">
<TR class=Header>
	<TH width="29%"><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></TH>
	<th width="7%"><INPUT type=checkbox name="checkall" id="checkall" value="1" onclick="onCheckAll(this);"><%=SystemEnv.getHtmlLabelName(17989,user.getLanguage())%></th>
    <th width="13%"><INPUT type=checkbox name="viewcheckall" id="viewcheckall" value="1" onclick="onViewCheckAll(this);"><%=SystemEnv.getHtmlLabelName(21225,user.getLanguage())%></th>
    <th width="10%" <%if(!wfintervenor){%>style="display:none"<%}%>><INPUT type=checkbox name="intervenorcheckall" id="intervenorcheckall" value="1" onclick="onIntervenorCheckAll(this);"><%=SystemEnv.getHtmlLabelName(21926,user.getLanguage())%></th>
    <th width="8%"><INPUT type=checkbox name="delcheckall" id="delcheckall" value="1" onclick="onDelCheckAll(this);"><%=SystemEnv.getHtmlLabelName(22281,user.getLanguage())%></th>
    <th width="11%"><INPUT type=checkbox name="fbcheckall" id="fbcheckall" value="1" onclick="onFBCheckAll(this);"><%=SystemEnv.getHtmlLabelName(22283,user.getLanguage())%></th>
    <th width="11%"><INPUT type=checkbox name="focheckall" id="focheckall" value="1" onclick="onFOCheckAll(this);"><%=SystemEnv.getHtmlLabelName(22282,user.getLanguage())%></th>
    <th width="11%" style="<%=isOpenWorkflowStopOrCancel.equals("1")?"":"display: none"%>"><INPUT type=checkbox name="socheckall" id="socheckall" value="1" onclick="onSOCheckAll(this);">是否暂停撤销启用</th>
</TR>
<TR class=Line style="height:1px;">
	<TD colSpan=8></TD>
</TR>
<tr>
	<td colspan="8" id="treeTD">
	<script type="text/javascript">
	isOpenWorkflowStopOrCancel="<%=isOpenWorkflowStopOrCancel%>"; //是否开启流程暂停或撤销设置
	
	webFXTreeConfig.blankIcon		= "/images/xp2/blank.png";
	webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus.png";
	webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus.png";
	webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus.png";
	webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus.png";
	webFXTreeConfig.iIcon			= "/images/xp2/I.png";
	webFXTreeConfig.lIcon			= "/images/xp2/L.png";
	webFXTreeConfig.tIcon			= "/images/xp2/T.png";
    webFXTreeConfig.usePersistence=false;
    webFXTreeConfig.wfintervenor=<%=wfintervenor%>;

    var rti;
	var tree = new WebFXTree('<%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%>','','','<%=wfHomeIcon%>','<%=wfHomeIcon%>');
	<%out.println(WorkTypeComInfo.getWFTypeInfo(String.valueOf(monitorhrmid),""+userid,Util.getIntValue(oldtypeid,0),Util.getIntValue(subcompanyid,0),detachable));%>
	document.write(tree);
	//rti.expand();
	</script>
	</td>
</tr>
</table>
</span>
<BR>
<BR>
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%>：</B><BR>
<B><%=SystemEnv.getHtmlLabelName(18560,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(21232,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(17989,user.getLanguage())%>：</B><BR><%=SystemEnv.getHtmlLabelName(21233,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21234,user.getLanguage())%>
<BR><%=SystemEnv.getHtmlLabelName(21235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21236,user.getLanguage())%>
<BR><%=SystemEnv.getHtmlLabelName(21237,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21238,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(21225,user.getLanguage())%>：</B><BR><%=SystemEnv.getHtmlLabelName(21239,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21240,user.getLanguage())%>
<BR><%=SystemEnv.getHtmlLabelName(21241,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21242,user.getLanguage())%>
<BR><%=SystemEnv.getHtmlLabelName(21243,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21244,user.getLanguage())%>
<BR>
<%if(wfintervenor){%>
<B><%=SystemEnv.getHtmlLabelName(21926,user.getLanguage())%>：</B><BR><%=SystemEnv.getHtmlLabelName(21959,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21962,user.getLanguage())%>
<BR><%=SystemEnv.getHtmlLabelName(21960,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21963,user.getLanguage())%>
<BR><%=SystemEnv.getHtmlLabelName(21961,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21964,user.getLanguage())%>
<BR>
<%}%>
<B><%=SystemEnv.getHtmlLabelName(22281,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(22287,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(22283,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(22287,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(22282,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(22287,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(16216,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(21245,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(18466,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(21246,user.getLanguage())%>
<BR>
<font color="red"><B><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>：</B>
<BR><%=SystemEnv.getHtmlLabelName(21247,user.getLanguage())%>
<BR><%=SystemEnv.getHtmlLabelName(21248,user.getLanguage())%>
<BR><%=SystemEnv.getHtmlLabelName(21249,user.getLanguage())%>
</font> <BR>
</TD>
</TR>
</TBODY>
</table>
</FORM>
</body>


<script type="text/javascript">
function onShowHrm(spanname,inputename){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
  
  <%if(1==detachable){%>
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=WorkflowMonitor:All","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
  <%}else{%>
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
  <%}%>
  if (datas){
	   if(datas.id!=""){
	    spanname.innerHTML= "<A href='javaScript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</A>";
	    inputename.value=datas.id;
		location.href = "/system/systemmonitor/workflow/systemMonitorSet.jsp?typeid="+frmmain.monitortypeid.value+"&subcompanyid=<%=subcompanyid%>&monitorhrmid="+datas.id;
	   }else{ 
	    spanname.innerHTML= "<IMG src='/images/BacoError.gif' align=absMiddle>";
	    inputename.value="";
	   }
  }
}
function onShowSubcompany(datas,e)
{
	if(datas.id!="")
	{
		location.href = "/system/systemmonitor/workflow/systemMonitorSet.jsp?typeid="+frmmain.monitortypeid.value+"&monitorhrmid=<%=monitorhrmid%>&subcompanyid="+datas.id
	}
}
var expandall=false;
function doSave(obj){
	var isCheck = false;
	var len = document.frmmain.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
        //if (document.frmmain.elements[i].name.indexOf('w')==0) {
    		if(document.frmmain.elements[i].checked==true) {
        		//alert(document.frmmain.elements[i].name);
        		isCheck = true;
        		break;
    		}
        //}
    }
   if(!isCheck) {
	   alert('<%=SystemEnv.getHtmlLabelName(22442,user.getLanguage())%>!');
	   return;
   }
   var checkfields = "";
   <% if(detachable==1){ %>
		checkfields = 'monitorhrmid,monitortypeid,subcompanyid';
   <%}else{%>
		checkfields = 'monitorhrmid,monitortypeid';
   <%}%>
	if (check_form(frmmain,checkfields)){
       window.document.frmmain.submit();
       obj.disabled = true;
    }
}

function goBack() {
	document.location.href="/system/systemmonitor/workflow/systemMonitorStatic.jsp?typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>"
}


function checkMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("t"+id).checked ;
    if(!mainchecked){
        document.all("vt"+id).checked=mainchecked;
        document.all("it"+id).checked=mainchecked;
        document.all("dt"+id).checked=mainchecked;
        document.all("bt"+id).checked=mainchecked;
        document.all("ot"+id).checked=mainchecked;
        document.all("st"+id).checked=mainchecked;
        document.all("checkall").checked=mainchecked;
        document.all("viewcheckall").checked=mainchecked;
        document.all("intervenorcheckall").checked=mainchecked;
        document.all("delcheckall").checked=mainchecked;
        document.all("fbcheckall").checked=mainchecked;
        document.all("focheckall").checked=mainchecked;
        document.all("socheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='w'+id || (!mainchecked && (document.frmmain.elements[i].name=='vw'+id || document.frmmain.elements[i].name=='iw'+id || document.frmmain.elements[i].name=='dw'+id || document.frmmain.elements[i].name=='bw'+id || document.frmmain.elements[i].name=='ow'+id|| document.frmmain.elements[i].name=='sw'+id))) {
            document.frmmain.elements[i].checked= mainchecked ;
        } 
    }
}

function checkSub(obj,wfid,id) {
    len = document.frmmain.elements.length;
    var i=0;
    if(!obj.checked){
    document.all("checkall").checked=obj.checked;
    document.all("viewcheckall").checked=obj.checked;
    document.all("intervenorcheckall").checked=obj.checked;
    document.all("delcheckall").checked=obj.checked;
    document.all("fbcheckall").checked=obj.checked;
    document.all("focheckall").checked=obj.checked;
    document.all("socheckall").checked=obj.checked;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="VW"+wfid||document.frmmain.elements[i].value=="IW"+wfid||document.frmmain.elements[i].value=="DW"+wfid||document.frmmain.elements[i].value=="BW"+wfid||document.frmmain.elements[i].value=="OW"+wfid||document.frmmain.elements[i].value=="SW"+wfid) {
            document.frmmain.elements[i].checked=false;
        }
    }
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='w'+id) {
            if(document.frmmain.elements[i].checked){
                document.all("t"+id).checked=true;
                return;
            }
        }
    }
    document.all("t"+id).checked=false;
    document.all("vt"+id).checked=false;
    document.all("it"+id).checked=false;
    document.all("dt"+id).checked=false;
    document.all("bt"+id).checked=false;
    document.all("ot"+id).checked=false;
    document.all("st"+id).checked=false;
}

function onCheckAll(obj){
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('t')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0 || (!obj.checked && (
        document.frmmain.elements[i].name.indexOf('vt')==0 || document.frmmain.elements[i].name.indexOf('vw')==0||
        document.frmmain.elements[i].name.indexOf('it')==0 || document.frmmain.elements[i].name.indexOf('iw')==0||
        document.frmmain.elements[i].name.indexOf('dt')==0 || document.frmmain.elements[i].name.indexOf('dw')==0||
        document.frmmain.elements[i].name.indexOf('bt')==0 || document.frmmain.elements[i].name.indexOf('bw')==0||
        document.frmmain.elements[i].name.indexOf('ot')==0 || document.frmmain.elements[i].name.indexOf('ow')==0||
        document.frmmain.elements[i].name.indexOf('st')==0 || document.frmmain.elements[i].name.indexOf('sw')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(!obj.checked){
        document.all("viewcheckall").checked=obj.checked;
        document.all("intervenorcheckall").checked=obj.checked;
        document.all("delcheckall").checked=obj.checked;
        document.all("fbcheckall").checked=obj.checked;
        document.all("focheckall").checked=obj.checked;
        document.all("socheckall").checked=obj.checked;
        
    }
}

function viewcheckMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("vt"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("viewcheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='vw'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
}

function viewcheckSub(obj,wfid,id) {
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("viewcheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='vw'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("vt"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("vt"+id).checked=false;
}

function onViewCheckAll(obj){
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('vt')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('vt')==0 || document.frmmain.elements[i].name.indexOf('vw')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }

}

function intervenorcheckMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("it"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("intervenorcheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='iw'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
}

function intervenorcheckSub(obj,wfid,id) {
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("intervenorcheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='iw'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("it"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("it"+id).checked=false;
}

function onIntervenorCheckAll(obj){
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('it')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('it')==0 || document.frmmain.elements[i].name.indexOf('iw')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }

}

function delcheckMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("dt"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("delcheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='dw'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
}

function delcheckSub(obj,wfid,id) {
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("delcheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='dw'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("dt"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("dt"+id).checked=false;
}

function onDelCheckAll(obj){
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('dt')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('dt')==0 || document.frmmain.elements[i].name.indexOf('dw')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }

}

function fbcheckMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("bt"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("fbcheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='bw'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
}

function fbcheckSub(obj,wfid,id) {
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("fbcheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='bw'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("bt"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("bt"+id).checked=false;
}

function onFBCheckAll(obj){
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('bt')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('bt')==0 || document.frmmain.elements[i].name.indexOf('bw')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }

}

function focheckMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("ot"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("focheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='ow'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
}

function focheckSub(obj,wfid,id) {
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("focheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='ow'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("ot"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("ot"+id).checked=false;
}

function onFOCheckAll(obj){
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('ot')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('ot')==0 || document.frmmain.elements[i].name.indexOf('ow')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }

}
function onSOCheckAll(obj){
    len = document.frmmain.elements.length;
    var i=0;
    if(!expandall){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('st')==0) {
    		document.frmmain.elements[i].checked=!obj.checked;
            document.frmmain.elements[i].click();
        }
    }
    expandall=true;
    }
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name.indexOf('st')==0 || document.frmmain.elements[i].name.indexOf('sw')==0 || (obj.checked && (document.frmmain.elements[i].name.indexOf('t')==0 || document.frmmain.elements[i].name.indexOf('w')==0))) 
        {
    		document.frmmain.elements[i].checked=obj.checked;
    	}
    }
    if(obj.checked){
        document.all("checkall").checked=obj.checked;
    }

}
function socheckMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("st"+id).checked ;
    if(mainchecked) document.all("t"+id).checked=mainchecked;
    else{
        document.all("socheckall").checked=mainchecked;
    }
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='sw'+id || (mainchecked && document.frmmain.elements[i].name=='w'+id)) {
            document.frmmain.elements[i].checked= mainchecked ;
        }
    }
}

function socheckSub(obj,wfid,id) {
    len = document.frmmain.elements.length;
    var i=0;
    if(obj.checked){
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].value=="W"+wfid) {
            document.frmmain.elements[i].checked=true;
            document.all("t"+id).checked=true;
            break;
        }
    }
    }else{
        document.all("socheckall").checked=obj.checked;
    }
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='sw'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("st"+id).checked=true;
    		return;
    		}
    	}
    }
    document.all("st"+id).checked=false;
}
function goexpandall(){
tree.expandAll();
expandall=true;
}
function docollapseall(){
tree.collapseAll();
}
</script>

</html>
