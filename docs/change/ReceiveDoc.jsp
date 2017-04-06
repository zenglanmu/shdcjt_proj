<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReceiveUnitUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>

<%
if(!HrmUserVarify.checkUserRight("DocChange:Receive", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23083,user.getLanguage());
String needfav ="1";
String needhelp ="";

String status = Util.null2String(request.getParameter("status"));
if(status.equals("")) status = "0";
//解决创建流程后,再修改"当前状态",选择其他状态无效,始终回到"已签收"状态
String status_session = Util.null2String((String) session.getAttribute("createworkflow_status" + user.getUID()));
session.removeAttribute("createworkflow_status" + user.getUID());
if(!"".equals(status_session)) status = status_session;
String title = Util.null2String(request.getParameter("title"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String enddate = Util.null2String(request.getParameter("enddate"));

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18526,user.getLanguage())+",javascript:doReceive(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(status.equals("0")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(20569,user.getLanguage())+",javascript:doAction(this,1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(23048,user.getLanguage())+",javascript:doAction(this,2),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:doAction(this,3),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(status.equals("1")) {//创建流程按钮
RCMenu += "{"+SystemEnv.getHtmlLabelName(23087,user.getLanguage())+",javascript:doAction(this,4),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<LINK href="../css/Weaver.css" type=text/css rel=STYLESHEET>

<FORM name="frmmain" action="/docs/change/ReceiveDocOpterator.jsp" method="post">
<input type="hidden" name="src" value="receive" />
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



<table class=ViewForm>
<colgroup>
<col width="15%">
<col width="25%">
<col width="15%">
<col width="25%">
<col width="5%">
<col width="15%">
<tbody>
<TR class="Title"> 
      <TH colSpan="2"><%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%></TH>
    </TR>
<TR class=Spacing style="height:1px;">
  <TD colspan=8 class=line1></TD>
</TR>
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></td>
    <td class=field>
	<select name="status" onChange="doRefresh(this)">
	<option value="0" <%if(status.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23079,user.getLanguage())%></option>
	<option value="1" <%if(status.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23078,user.getLanguage())%></option>
	<option value="2" <%if(status.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22946,user.getLanguage())%></option>
	<option value="3" <%if(status.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21983,user.getLanguage())%></option>
	</select>
	</td>
     <td width=10%><%=SystemEnv.getHtmlLabelName(18002,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type="button" class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=fromdate%></SPAN>
    <input class=inputstyle type="hidden" name="fromdate" value="<%=fromdate%>">
    －<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=enddate%></SPAN>
    <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">
    </td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR>
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(23038,user.getLanguage())%></td>
    <td class=field colspan="3"><INPUT name=title value="<%=title%>"></td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>

<input name=start type=hidden value="<%=start%>">
<input name=ids type=hidden value="">
<input name=companyid type=hidden value="">
<input name=chageFlag type=hidden value="">
<input name=newversionid type=hidden value="">
<input name=sn type=hidden value="">
<input name="fieldConfigWfid" type=hidden value="" onpropertychange="doFieldConfig()"><span id="fieldConfigWfidSpan" style="display:none"></span>
<input name="createWfid" type=hidden value="" onpropertychange="doCreate()"><span id="createWfidSpan" style="display:none"></span>
<%
String statusText = "23079";
if(status.equals("0")) statusText = "23079";
if(status.equals("1")) statusText = "23078";
if(status.equals("2")) statusText = "22946";
if(status.equals("3")) statusText = "21983";

String sqlwhere = " type='1' AND status = '"+status+"' ";
//取未发送的
if(!fromdate.equals("")) sqlwhere += " and receivedate>='"+fromdate+"' ";
if(!enddate.equals("")) sqlwhere += " and receivedate<='"+enddate+"' ";
if(!title.equals("")) sqlwhere += " and title like '%"+title+"%'";

int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);
String tableString = "";
if(perpage <2) perpage=10;                                 
String backfields = " id,title,sn,companyid,chageFlag,flagTitle,version,executedate,executetime,receivedate,receivetime,status ";
String fromSql  = " DocChangeReceive ";
//out.print("select "+backfields + "from "+fromSql+" where "+sqlwhere);
//处理交换字段
String fdStr = "";
String sql = "select distinct t2.id,t1.version from DocChangeFieldConfig t1,"
	+ "(select "+backfields + "from "+fromSql+" where "+sqlwhere+") t2 "
	+ " where t1.companyid=t2.companyid and t1.chageflag=t2.chageflag and t1.version=t2.version ";
RecordSet.executeSql(sql);
//out.println(sql);
while(RecordSet.next()) {
	fdStr += ","+RecordSet.getString("version")+"|"+RecordSet.getString("id");
}
fdStr += ",";
//out.println(fdStr);
tableString =   " <table instanceid=\"receiveDocListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >";
if(status.equals("1")) {
	tableString =   " <table instanceid=\"receiveDocListTable\" tabletype=\"radio\" pagesize=\""+perpage+"\" >";
	tableString += " <checkboxpopedom popedompara=\"column:id+"+"|"+"column:version+"+fdStr+"\" showmethod=\"weaver.docs.change.DocReceiveManager.showMethod\" />";
}
tableString +=  "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"receivedate,receivetime,chageFlag,version,companyid\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"140\"  text=\""+SystemEnv.getHtmlLabelName(18002,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
                "           <col width=\"150\"   text=\""+SystemEnv.getHtmlLabelName(18321,user.getLanguage())+"\" column=\"companyid\" orderkey=\"companyid\" transmethod=\"weaver.docs.senddoc.DocReceiveUnitComInfo.getReceiveUnitName\" />";
if(status.equals("1")) {
	tableString +=  "       <col width=\"120\"  text=\""+SystemEnv.getHtmlLabelName(23775,user.getLanguage())+"\" column=\"flagTitle\" orderkey=\"flagTitle\" />"+
				"           <col width=\"45\"  text=\""+SystemEnv.getHtmlLabelName(22186,user.getLanguage())+"\" column=\"version\" />";
}                
tableString +=  "           <col width=\"\"  text=\""+SystemEnv.getHtmlLabelName(23038,user.getLanguage())+"\" column=\"title\" orderkey=\"title\" href=\"ReceiveDocShow.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" />"+
                "           <col width=\"80\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" column=\"id\" otherpara=\""+statusText+","+user.getLanguage()+"\" transmethod=\"weaver.general.SplitPageTransmethod.getFieldname\" />";
if(status.equals("1")) {
	tableString +=  "           <col width=\"80\"  text=\""+SystemEnv.getHtmlLabelName(724,user.getLanguage())+"\" column=\"chageFlag\" otherpara=\"column:version+column:companyid+"+user.getLanguage()+"+column:sn\" transmethod=\"weaver.docs.change.DocReceiveManager.showConfigStr\" />";
}
tableString +=  "       </head>"+
                " </table>";
%>
<TABLE width="100%">
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
        </td>
    </tr>
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
</FORM>

<script>
function doReceive(mobj) {
	document.frmmain.src.value = 'receive';
	document.frmmain.submit();
	mobj.disabled = true;
}
//刷新动作
function doRefresh(obj) {
	document.frmmain.action = '#';
	document.frmmain.submit();
	obj.disabled = true;
}

//动作
function doAction(mobj, type) {
	if(type=='1') type = 'signin';//签收
	if(type=='2') type = 'reject';//拒收
	if(type=='3') type = 'back';//退回
	if(type=='4') {
		type = 'createworkflow';//创建流程
		if(_xtable_CheckedRadioId()=="") alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');
		else {
			//onShowWorkFlowSerach('createWfid','createWfidSpan');
			DocReceiveUnitUtil.whetherCanCreateRequest(_xtable_CheckedRadioId(), callBackFun);
			//回调函数    
			function callBackFun(data) {
				if(data=="_"){
					document.getElementById("sn").value = "-1";
					onShowWorkFlowSerach('createWfid','createWfidSpan');
				}else{
					document.getElementById("sn").value = data.split("_")[1];
					document.getElementById("createWfid").value = data.split("_")[0];
				}
			}
			return;
		}
	}
	else {
		if(_xtable_CheckedCheckboxId()=="") alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');
		else {
			document.frmmain.src.value = type;
			document.frmmain.ids.value = _xtable_CheckedCheckboxId();
			if(type!='signin') {
				document.frmmain.action = 'DocReject.jsp';
			}
			document.frmmain.submit();
			mobj.disabled = true;
		}
	}
}
//创建流程
function doCreate() {
	var obj = document.frmmain.createWfid;
	if(obj.value=='') return;
	else {
		document.frmmain.src.value = 'createworkflow';
		document.frmmain.ids.value = _xtable_CheckedRadioId();
		document.frmmain.submit();
		//mobj.disabled = true;
		enableAllmenu();
	}
}
//点击配置按钮事件
function doConfig(chageFlag, version, companyid, sn) {
	document.frmmain.chageFlag.value = chageFlag;
	document.frmmain.companyid.value = companyid;
	document.frmmain.newversionid.value = version;
	document.frmmain.sn.value = sn;
	onShowWorkFlowSerach('fieldConfigWfid','fieldConfigWfidSpan');
}
//配置流程字段
function doFieldConfig() {
	var obj = document.frmmain.fieldConfigWfid;
	if(obj.value=='') return;
	else {
		document.frmmain.action='WorkflowFieldConfig.jsp?wfid='+obj.value;
		document.frmmain.submit();
		//mobj.disabled = true;
		enableAllmenu();
	}
}
function doConfigView(chageFlag, version, companyid, sn) {
	document.frmmain.sn.value = sn;
	document.frmmain.action='WorkflowFieldConfig.jsp?chageFlag='+chageFlag+'&companyid='+companyid+'&sn='+sn+"&version="+version;
	document.frmmain.submit();
	//alert(chageFlag+'--'+version+'--'+companyid);
}
</script>
<script language="vbs">
Sub onShowWorkFlowSerach(inputname, spanname)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/change/WfBrowser.jsp")
	temp=document.all(inputname).value
	
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "0" Then
			document.all(spanname).innerHtml = retValue(1)
			document.all(inputname).value = retValue(0)
		Else 
			document.all(inputname).value = ""
			document.all(spanname).innerHtml = ""
			End If
	End If
End Sub
</script>