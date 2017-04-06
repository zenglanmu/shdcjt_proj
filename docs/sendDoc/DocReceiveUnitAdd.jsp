
<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.file.Prop" %>

<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
String rightStr = "SRDoc:Edit";
if(!HrmUserVarify.checkUserRight(rightStr, user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
Prop prop = Prop.getInstance();
//boolean docchangeEnabled = Util.null2String(prop.getPropValue("DocChange", "Enabled")).equals("Y");
String strDocChgEnabled = Util.null2String(prop.getPropValue("DocChange", "Enabled"));
boolean docchangeEnabled = false;
if("Y".equalsIgnoreCase(strDocChgEnabled) || "1".equals(strDocChgEnabled)) {
    docchangeEnabled = true;
}
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), 0);
int superiorUnitId = Util.getIntValue(request.getParameter("superiorUnitId"),0);
String subcompanyname = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
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

String titlename = SystemEnv.getHtmlLabelName(19309,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_TOP} " ;
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

<FORM id=weaver name=frmMain action="DocReceiveUnitOperation.jsp" method=post  target="_parent">

        <TABLE class=ViewForm width="100%">
          <COLGROUP> 
		  <COL width="30%">
		  <COL width="70%">
		  <TBODY> 

          <TR class=Title> 
              <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height: 1px!important;"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <%if(docchangeEnabled){%>
		  <TR>
            <TD><%=SystemEnv.getHtmlLabelName(22880,user.getLanguage())%></TD>
            <TD class=FIELD>
			<select id="companyType" name="companyType" onchange="changeType(this.value)">
			<option value="0"><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></option>
			<option value="1"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></option>
			</select>
			</TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		  <%}%>
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%></TD>
            <TD class=FIELD> 
              <INPUT class=InputStyle  name=receiveUnitName onchange='checkinput("receiveUnitName","receiveUnitNameImage")' value="">
              <SPAN id=receiveUnitNameImage>
			  <IMG src="/images/BacoError.gif" align=absMiddle>
			  </SPAN>
              </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(19310,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON class=Browser id=SelectSuperiorUnitId type="button" onclick="onShowSuperiorUnit()"></BUTTON> 

              <SPAN id=superiorUnitSpan>
                  <%=DocReceiveUnitComInfo.getReceiveUnitName(""+superiorUnitId)%>
              </SPAN> 
              <INPUT class=inputstyle id=superiorUnitId type=hidden name=superiorUnitId value=<%=superiorUnitId%>>                           
            </TD>
          </TR>         
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          <TR id="HrmTR1"> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(19311,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON class=Browser id=SelectReceiverIds type="button" onclick="onShowReceiverIds('receiverIds','receiverIdsSpan')"></BUTTON> 

              <SPAN id=receiverIdsSpan>
			      <IMG src="/images/BacoError.gif" align=absMiddle>
              </SPAN> 
              <INPUT class=inputstyle id=receiverIds type=hidden name=receiverIds value="">                         
            </TD>
          </TR>
    <TR id="HrmTR2" style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    <%if(docchangeEnabled){%>
	  <TR id="CpnTR1">
           <TD><%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%></TD>
           <TD class=FIELD>
			<INPUT class=InputStyle  name=changeDir value="" onchange='checkinput("changeDir","changeDirImage")'>
                <SPAN id=changeDirImage></SPAN>
             </TD>
         </TR>
         <TR id="CpnTR2" style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
	  <TR id="CpnTR3">
           <TD><%=SystemEnv.getHtmlLabelName(23090,user.getLanguage())%></TD>
           <TD class=FIELD>
           <select name="isMain">
		<option value="0"><%=SystemEnv.getHtmlLabelName(23092,user.getLanguage())%></option>
		<option value="1"><%=SystemEnv.getHtmlLabelName(23091,user.getLanguage())%></option>
		</select>
           </TD>
         </TR>
         <TR id="CpnTR4" style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
         <%}%>
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON class="Browser" id="SelectSubcompanyid" type="button" onclick="onShowSubcompanyid(subcompanyid,subcompanyidspan)"></BUTTON> 
              <SPAN id="subcompanyidspan"><%if("".equals(subcompanyname)){%><IMG src="/images/BacoError.gif" align=absMiddle><%}else{out.print(subcompanyname);}%></SPAN> 
              <INPUT id="subcompanyid" type="hidden" name="subcompanyid" value="<%if(subcompanyid>0){out.print(subcompanyid);}%>">                         
            </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
	
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(22904,user.getLanguage())%></TD>
            <TD class=Field>
			    <select class=inputstyle  name = canStartChildRequest>
			        <option value=1 ><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
			        <option value=0 ><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
			    </select>                         
            </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

            <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=InputStyle name=showOrder value=0 size=4 maxlength=4  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("showOrder");checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")' value="">
              <SPAN id=showOrderImage></SPAN>
            </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>

   <input class=inputstyle type=hidden name=method value="AddSave">
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

</BODY>
</HTML>


<script language=javascript>

//o为错误类型 1:系统不支持10层以上的收文单位！
//           2:同级单位名称不能重复

function checkForAddSave(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19319,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19319,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getHtmlLabelName(19366,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19366,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.submit();		
	}
}

function onSave() {
	if(check_form(frmMain,'receiveUnitName,subcompanyid,showOrder')){
		var newReceiveUnitName=document.all("receiveUnitName").value;
		var mewSuperiorUnitId=document.all("superiorUnitId").value;
		var newsubcompanyId=document.all("subcompanyid").value;
		newReceiveUnitName=escape(newReceiveUnitName);

		if(document.getElementById("companyType")!=null&&document.getElementById("companyType").value=='1') {
			var dirvalue = document.getElementById('changeDir').value;
			if(!dirvalue.isValidString()) {
				alert('<%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22945,user.getLanguage())%>!');
				return;
			}
			if(!check_form(document.frmMain,'changeDir')) return;
			var _data;
			DocReceiveUnitUtil.checkChangeDir('', dirvalue, callBackFun);
			//回调函数    
			function callBackFun(data) {
				_data = data;
				if(_data*1==0) DocReceiveUnitUtil.whetherCanAddSave(newReceiveUnitName,mewSuperiorUnitId,newsubcompanyId,checkForAddSave);
				else alert('<%=SystemEnv.getHtmlLabelName(22943,user.getLanguage())%>!');
			}
		}
		else {
			if(!check_form(frmMain,'receiverIds')) return;
			DocReceiveUnitUtil.whetherCanAddSave(newReceiveUnitName,mewSuperiorUnitId,newsubcompanyId,checkForAddSave);
		}

		//DocReceiveUnitUtil.whetherCanAddSave(newReceiveUnitName,mewSuperiorUnitId,newsubcompanyId,checkForAddSave);
    }
}
function onChangeSubmit(type){
	document.getElementById("changetype").value = type;
	if(type == 0){
		document.getElementById("changeid").value = document.getElementById("superiorUnitId").value;
	}else if(type == 1){
		document.getElementById("changeid").value = document.getElementById("subcompanyid").value;
	}
	document.frmMain.action = "DocReceiveUnitAdd.jsp";
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
		<%if(docchangeEnabled){%>
			document.getElementById('CpnTR1').style.display = 'none';
			document.getElementById('CpnTR2').style.display = 'none';
			document.getElementById('CpnTR3').style.display = 'none';
			document.getElementById('isMain').style.display = 'none';
			document.getElementById('CpnTR4').style.display = 'none';
		<%}%>
		if(!isfirst) {
			if(document.getElementById('receiverIdsSpan').innerHTML=='')
				checkinput("receiverIds","receiverIdsSpan");
		}
	}
	else {
		document.getElementById('HrmTR1').style.display = 'none';
		document.getElementById('HrmTR2').style.display = 'none';
		<%if(docchangeEnabled){%>
			document.getElementById('CpnTR1').style.display = '';
			document.getElementById('CpnTR2').style.display = '';
			document.getElementById('CpnTR3').style.display = '';
			document.getElementById('isMain').style.display = '';
			document.getElementById('CpnTR4').style.display = '';
			checkinput("changeDir","changeDirImage");
		<%}%>
	}
}
changeType('0', true);

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

var opts={
		_dwidth:'550px',
		_dheight:'550px',
		_url:'about:blank',
		_scroll:"no",
		_dialogArguments:"",
		
		value:""
	};
var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
opts.top=iTop;
opts.left=iLeft;

function onShowReceiverIds(inputname,spanname){
	  linkurl="javaScript:openhrm(";
	     datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	    if (datas) {
	     if (datas.id!= "") {
	         ids = datas.id.split(",");
	     names =datas.name.split(",");
	     sHtml = "";
	     for( var i=0;i<ids.length;i++){
	     if(ids[i]!=""){
	      sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
	     }
	     }
	    
	     jQuery("#"+spanname).html(sHtml);
	     jQuery("input[name="+inputname+"]").val(datas.id);
	     }
	     else {
	    	 jQuery("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	    	 jQuery("input[name="+inputname+"]").val("");
	     }
	 }
	 }
function onShowSuperiorUnit(){
	superiorUnitId=document.frmMain.superiorUnitId.value
	url="/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp?superiorUnitId="+superiorUnitId+"&rightStr=<%=rightStr%>";
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	issame = false
	if (data) {
		if (data.id!=""){
			if (data.id == frmMain.superiorUnitId.value){
				issame = true
			}
			superiorUnitSpan.innerHtml = data.name
			frmMain.superiorUnitId.value=data.id
			onChangeSubmit(0)
		}else{
			superiorUnitSpan.innerHtml = ""
			frmMain.superiorUnitId.value="0"
			onChangeSubmit(0)
		}
	}
}

function onShowSubcompanyid(inputname,spanname){
	data= window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=<%=rightStr%>&isedit=1&selectedids="+inputname.value,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	issame = false
	if (data) {
		if(data.id!=""){
			if (data.id== inputname.value){
				issame = true
			}
			spanname.innerHtml = data.name
			inputname.value = data.id
			onChangeSubmit(1)
		}else{
			spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			inputname.value = ""
			onChangeSubmit(1)
		}
	}
}
</script>
