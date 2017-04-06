<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.file.Prop" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
String rightStr = "SRDoc:Edit";
if(!HrmUserVarify.checkUserRight(rightStr, user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

%>

<%
String receiveUnitId=Util.null2String(request.getParameter("id"));

String receiveUnitName=DocReceiveUnitComInfo.getReceiveUnitName(receiveUnitId);
int superiorUnitId = Util.getIntValue(DocReceiveUnitComInfo.getSuperiorUnitId(receiveUnitId),0);
String receiverIds = DocReceiveUnitComInfo.getReceiverIds(receiveUnitId);
int showOrder = Util.getIntValue(DocReceiveUnitComInfo.getShowOrder(receiveUnitId),0);
int subcompanyid = Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(receiveUnitId),0);
String subcompanyname = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
String companyType = DocReceiveUnitComInfo.getCompanyType(receiveUnitId);
String changeDir = DocReceiveUnitComInfo.getChangeDir(receiveUnitId);
String isMain = DocReceiveUnitComInfo.getIsMain(receiveUnitId);
Prop prop = Prop.getInstance();
//boolean docchangeEnabled = Util.null2String(prop.getPropValue("DocChange", "Enabled")).equals("Y");
String strDocChgEnabled = Util.null2String(prop.getPropValue("DocChange", "Enabled"));
boolean docchangeEnabled = false;
if("Y".equalsIgnoreCase(strDocChgEnabled) || "1".equals(strDocChgEnabled)) {
    docchangeEnabled = true;
}
String canStartChildRequest = Util.null2String(DocReceiveUnitComInfo.getCanStartChildRequest(receiveUnitId));

String changetype = Util.null2String(request.getParameter("changetype"));
int changeid = Util.getIntValue(request.getParameter("changeid"), 0);
if(!"".equals(changetype)){
	if("0".equals(changetype)){
		superiorUnitId = changeid;
		subcompanyid = Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(""+superiorUnitId), 0);
		subcompanyname = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
	}else if("1".equals(changetype)){
		subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
		subcompanyname = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
		int supSubcompanyid = Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(""+superiorUnitId), 0);
		if(supSubcompanyid != subcompanyid){
			superiorUnitId = 0;
		}
	}
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReceiveUnitUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
</head>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(19309,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

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

<div id=divMessage style="color:red">
</div>

<FORM id=weaver name=frmMain action="DocReceiveUnitOperation.jsp" method=post target="_parent">


        <TABLE class=ViewForm width="100%">
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
          <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height: 1px!important;">
            <TD class=line1 colSpan=2></TD>
          </TR>
          <%if(docchangeEnabled){%>
		  <TR>
            <TD><%=SystemEnv.getHtmlLabelName(22880,user.getLanguage())%></TD>
            <TD class=FIELD>
			<select name="companyType" onchange="changeType(this.value)">
			<option value="0" <%if(companyType.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></option>
			<option value="1" <%if(companyType.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></option>
			</select>
			</TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <%}else {%><INPUT type="hidden" name="companyType" value="0"><%}%>
          <TR>
            <TD class=lable><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle  name=receiveUnitName value="<%=receiveUnitName%>" onchange='checkinput("receiveUnitName","receiveUnitNameImage")'>
                 <SPAN id=receiveUnitNameImage></SPAN>
              </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD class=lable><%=SystemEnv.getHtmlLabelName(19310,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON type="button" class=Browser id=SelectSuperiorUnit onclick="onShowSuperiorUnit()"></BUTTON>
              <SPAN id=superiorUnitSpan><%=DocReceiveUnitComInfo.getReceiveUnitName(""+superiorUnitId)%>
              </SPAN>
              <INPUT id=superiorUnitId type=hidden name=superiorUnitId value="<%=superiorUnitId%>">
            </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR id="HrmTR1">
            <TD><%=SystemEnv.getHtmlLabelName(19311,user.getLanguage())%></TD>
            <TD class=Field>
            <%
            String tmpname = Util.null2String(ResourceComInfo.getMulResourcename1(receiverIds));
            tmpname = tmpname.replaceAll("'","");
            tmpname = tmpname.replaceAll("\"","'");
            System.out.println(tmpname);
            %>
             
              <INPUT class="wuiBrowser" id=receiverIds _displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>" _displayText="<%=tmpname%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" _param="resourceids" _required="yes" type=hidden name=receiverIds value="<%=receiverIds%>">
            </TD>
          </TR>
          <TR id="HrmTR2" style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <%if(docchangeEnabled){%>
		  <TR id="CpnTR1">
            <TD><%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%></TD>
            <TD class=FIELD>
				<INPUT class=InputStyle  name=changeDir value="<%=changeDir%>" onchange='checkinput("changeDir","changeDirImage")'>
                 <SPAN id=changeDirImage></SPAN>
              </TD>
          </TR>
          <TR id="CpnTR2" style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		  <TR id="CpnTR3">
            <TD><%=SystemEnv.getHtmlLabelName(23090,user.getLanguage())%></TD>
            <TD class=FIELD>
            <select name="isMain">
			<option value="0" <%if(isMain.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23092,user.getLanguage())%></option>
			<option value="1" <%if(isMain.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23091,user.getLanguage())%></option>
			</select>
            </TD>
          </TR>
          <TR id="CpnTR4" style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <%}%>
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON class="Browser" type="button" id="SelectSubcompanyid" onclick="onShowSubcompanyid(subcompanyid,subcompanyidspan)"></BUTTON> 
              <SPAN id="subcompanyidspan"><%if("".equals(subcompanyname)){%><IMG src="/images/BacoError.gif" align=absMiddle><%}else{out.print(subcompanyname);}%></SPAN> 
              <INPUT id="subcompanyid" type="hidden" name="subcompanyid" value="<%if(subcompanyid>0){out.print(subcompanyid);}%>">                         
            </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
	
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(22904,user.getLanguage())%></TD>
            <TD class=Field>
			    <select class=inputstyle  name = canStartChildRequest>
			        <option value=1 <%if(canStartChildRequest.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
			        <option value=0 <%if(canStartChildRequest.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
			    </select>                         
            </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

          <TR>
            <TD class=lable><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle name=showOrder size=4 maxlength=4 value="<%=showOrder%>" size=4 maxlength=4  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("showOrder");checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")'>
              <SPAN id=showOrderImage></SPAN>
            </TD>
          </TR>
         <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>


   <input type=hidden name=method>
   <input type=hidden name=id value="<%=receiveUnitId%>">
	<input type="hidden" id="changetype" name="changetype" value="">
	<input type="hidden" id="changeid" name="changeid" value="">
 </FORM>

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
</BODY></HTML>


<script language=javascript>

//o为错误类型 1:系统不支持10层以上的收文单位！
//           2:同级单位名称不能重复

function checkForEditSave(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19319,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19319,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getHtmlLabelName(19366,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19366,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.method.value="EditSave";
		document.frmMain.submit();	
	}
}

function onSave(){
	if(document.frmMain.superiorUnitId.value==<%=receiveUnitId%>){
		//alert("<%=SystemEnv.getHtmlLabelName(19315,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19315,user.getLanguage())%>";
	}else{
		if(check_form(document.frmMain,'receiveUnitName,showOrder')){
			if(document.frmMain.companyType.value=='1') {
				var dirvalue = document.frmMain.changeDir.value;
				if(!dirvalue.isValidString()) {
					alert('<%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22945,user.getLanguage())%>!');
					return;
				}
				if(!check_form(document.frmMain,'changeDir,subcompanyid')) return;
				var _data;
				DocReceiveUnitUtil.checkChangeDir('<%=receiveUnitId%>', dirvalue, callBackFun);
				//回调函数    
				function callBackFun(data) {
					_data = data;
					if(_data*1==0) saveAction();
					else alert('<%=SystemEnv.getHtmlLabelName(22943,user.getLanguage())%>!');
				}
			}
			else {
				if(!check_form(document.frmMain,'receiverIds,subcompanyid')) return;
				saveAction();
			}
		}
	}
}

function saveAction() {
	var newReceiveUnitId=<%=receiveUnitId%>;
	var newReceiveUnitName=document.all("receiveUnitName").value;
	var newSuperiorUnitId=document.all("superiorUnitId").value;
	var newsubcompanyId=document.all("subcompanyid").value;
    newReceiveUnitName=escape(newReceiveUnitName);
	DocReceiveUnitUtil.whetherCanEditSave(newReceiveUnitId,newReceiveUnitName,newSuperiorUnitId,newsubcompanyId,checkForEditSave);
}
 
//o为错误类型 1:当前单位有下级单位，不能删除。
//           2:该记录被引用,不能删除。
function checkForDelete(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19365,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19365,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>")
		divMessage.innerHTML="<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.method.value="Delete";
		document.frmMain.submit();	
	}
}


function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		var receiveUnitId=<%=receiveUnitId%>;
		DocReceiveUnitUtil.whetherCanDelete(receiveUnitId,checkForDelete);
    }
}
function onChangeSubmit(type){
	document.getElementById("changetype").value = type;
	if(type == 0){
		document.getElementById("changeid").value = document.getElementById("superiorUnitId").value;
	}else if(type == 1){
		document.getElementById("changeid").value = document.getElementById("subcompanyid").value;
	}
	document.frmMain.action = "DocReceiveUnitEdit.jsp";
	document.frmMain.target = "";
	document.frmMain.submit();
}
function encode(str){
    return escape(str);
}
//by alan 切换单位类型
function changeType(f, isfirst) {
	if(f==0) {
		document.getElementById('HrmTR1').style.display = '';
		document.getElementById('HrmTR2').style.display = '';
		document.getElementById('CpnTR1').style.display = 'none';
		document.getElementById('CpnTR2').style.display = 'none';
		document.getElementById('CpnTR3').style.display = 'none';
		document.getElementById('isMain').style.display = 'none';
		document.getElementById('CpnTR4').style.display = 'none';
		if(!isfirst) {
			if(document.getElementById('receiverIdsSpan').innerHTML=='')
				checkinput("receiverIds","receiverIdsSpan");
		}
	}
	else {
		document.getElementById('HrmTR1').style.display = 'none';
		document.getElementById('HrmTR2').style.display = 'none';
		document.getElementById('CpnTR1').style.display = '';
		document.getElementById('CpnTR2').style.display = '';
		document.getElementById('CpnTR3').style.display = '';
		document.getElementById('isMain').style.display = '';
		document.getElementById('CpnTR4').style.display = '';
		checkinput("changeDir","changeDirImage");
	}
}
<%if(docchangeEnabled){%>
changeType('<%if(companyType.equals("")){out.print("0");}else{out.print(companyType);}%>', true);
<%}%>

//检查是否符合字符规定 by alan
String.prototype.isValidString=function()
{
	try {
	var result=this.match(/^[a-zA-Z0-9\-_]+$/);
	if(result==null) return false;
	return true;
	}
	catch(e) {
		alert(e);
	}
}

function onShowSuperiorUnit(){
	superiorUnitId=document.frmMain.superiorUnitId.value
	url=encode("/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp?rightStr=<%=rightStr%>&transferValue=<%=receiveUnitId%>_"+superiorUnitId)
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	var issame = false
	if (data){
		if(data.id!=""){
			if (data.id == frmMain.superiorUnitId.value){
				issame = true
			}
			superiorUnitSpan.innerHTML = data.name
			frmMain.superiorUnitId.value=data.id
			onChangeSubmit(0)
		}else{
			superiorUnitSpan.innerHTML = ""
			frmMain.superiorUnitId.value="0"
		}
	}
}
function onShowSubcompanyid(inputname,spanname){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=<%=rightStr%>&isedit=1&selectedids="+inputname.value)
	var issame = false
	if (data){
		if (data.id!=0){
			if (data.id == inputname.value){
				issame = true
			}
			spanname.innerHTML = data.name
			inputname.value = data.id
			onChangeSubmit(1)
		}else{
			spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			inputname.value = ""
		}
	}
}
jQuery(document).ready(function(){

	jQuery(".wuiBrowser").modalDialog();
})
 </script>

