<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int trighttype = Util.getIntValue(request.getParameter("trighttype"),0);
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<BODY>
<%
String imagefilename = "/images/hdCRMAccount.gif";
String titlename = SystemEnv.getHtmlLabelName(16526,user.getLanguage());
String needfav ="1";
String needhelp ="";
if(trighttype==1){//创建权限:添加
	titlename = SystemEnv.getHtmlLabelName(21945,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else if(trighttype==0){//默认共享:添加
	titlename = SystemEnv.getHtmlLabelName(15059,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else if(trighttype==2){//监控权限:添加
	titlename = SystemEnv.getHtmlLabelName(20305,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else if(trighttype==4){//批量导入权限:添加
	titlename = SystemEnv.getHtmlLabelName(30253,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='ModeRightEdit.jsp?modeId="+modeId+"',_top} " ;
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
<FORM id=weaver name=weaver action=ModeRightOperation.jsp method=post onsubmit='return check_by_permissiontype()'>
  <input type="hidden" name="method" value="addNew">
  <input type="hidden" name="modeId" value="<%=modeId%>">
  <TABLE class=ViewForm>
    <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
    </COLGROUP>
    <TBODY>
     <TR><!-- 共享类型 -->
       <TD><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></TD>
       <TD class="field">
         <SELECT class=InputStyle  name=sharetype onChange="onChangeSharetype()" >  
           <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
           <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
           <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
           <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
           <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
	<%
			if(trighttype==0){
	%>
				<option value="1000"><%=SystemEnv.getHtmlLabelName(81438,user.getLanguage())%></option><!-- 流程主字段 -->
	<%
			}
	%>
         </SELECT>
         <span id="modefieldtypespan" style="display:none"><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span>
         <select id="modefieldtype" name="modefieldtype" style="display:none" onchange="changeFieldType(this)">
         	<option value="1"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
         	<option value="2"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
         	<option value="3"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
         </select>
         
         <span id=showspan >
	         <INPUT type=hidden name="relatedid"  id="relatedid" value="">
	         <BUTTON class=Browser id="btnRelated" onClick="onShowRelated(relatedid,showrelatedname)" name="btnRelated"></BUTTON>
	         <span id="showrelatedname" name="showrelatedname"><IMG src='/images/BacoError.gif' align=absMiddle></span>
         </span>
       </TD>
     </TR>
     <TR style="height: 1px"> <TD class=Line colSpan=2></TD></TR>
     <!-- 角色级别 -->
     <TR id=rolelevel_tr name=id=rolelevel_tr style="display:none">
       <td><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
       <td class="field">
           <SELECT  name=rolelevel>
	           <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><!-- 分门 -->
	           <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
       </td>
     </TR>
     <TR id=rolelevel_line name=rolelevel_line style="display:none;height: 1px">
       <TD class=Line colSpan=2  ></TD>
     </TR>
     <!-- 安全级别 -->
     <TR  id=showlevel_tr name=showlevel_tr style="display:none;height: 1px">
       <TD><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
       <TD class="field">
       	 <INPUT type=text name=showlevel class=InputStyle size=6 value="10" onchange='checkinput("showlevel","showlevelimage")' onKeyPress="ItemCount_KeyPress()">
         <span id=showlevelimage></span>
       </TD>
     </TR>
     <TR id=showlevel_line name=showlevel_line style="display:none;height: 1px">
        <TD class=Line colSpan=2 ></TD>
     </TR>
     <!-- 权限项 -->
     <TR>
       <td><%=SystemEnv.getHtmlLabelName(440,user.getLanguage())%></td>
       <TD class="field">
         <SELECT class=InputStyle  name=righttype <%if(trighttype == 1 || trighttype == 2 || trighttype == 4){%>disabled<%}%>>
         	 <%if(trighttype == 1){%>
         	 <option value="0" selected><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></option>
         	 <%}else if(trighttype == 2){%>
         	 <option value="4" selected><%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%></option>
         	 <%}else if(trighttype == 4){%>
         	 <option value="5" selected><%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%></option>
         	 <%} %>
	         <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
			 <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
			 <option value="3"><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option>
		 </SELECT>
       </TD>
     </TR>
     <TR class="Spacing"><TD class="Line1" colspan=2></TD></TR>
     
     <TR>
       <TD  colspan=2>
         <TABLE  width="100%">
           <TR>
     		<TD width="*"></TD>
        	<TD width="300px">
        	<button class="btnNew" type="button" onClick="addValue()" title="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" accesskey="a"><u>A</u>&nbsp;<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<button class="btnDelete" type="button" onClick="removeValue()" title="<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" onClick="removeValue()" accesskey="d"><u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%></button></TD>
           </TR>
         </TABLE>
       </TD>
     </TR>
     <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
     <tr>
       <td colspan=2>
         <table class="listStyle" id="oTable" name="oTable">
             <colgroup>
             <col width="3%">
             <col width="20%">
             <col width="20%">
             <col width="17%">
             <col width="20%">
             <col width="20%">
             <tr class="header">
                 <th><input type="checkbox" name="chkAll" onClick="chkAllClick(this)"></th>
                 <th><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></th>
                 <th><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th>
                 <th><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></th>
                 <th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th>
                 <th><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></th>
             </tr>
             <tr class=Line style="height: 1px" ><td colspan=6 style="padding: 0px"></td></tr>
         </table>
       </td>
  	  </tr>
    </TBODY>
  </TABLE>
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

<script language=javascript>
function onChangeSharetype(){
	var thisvalue=$GetEle("sharetype").value;	
    var strAlert= ""
	if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4 || thisvalue==1000){//需要浏览框
		$GetEle("showspan").style.display='';	//浏览框
		$GetEle("relatedid").value="";
		$GetEle("showrelatedname").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
	}else{
		$GetEle("showspan").style.display='none';	//不需要浏览框
	}
	if(thisvalue != 4){
		$GetEle("rolelevel_tr").style.display='none';	//角色级别
		$GetEle("rolelevel_line").style.display='none';	
	}else{
		$GetEle("rolelevel_tr").style.display='';	//需要角色级别
		$GetEle("rolelevel_line").style.display='';	
	}
	if(thisvalue == 1){//人员不需要安全级别
		$GetEle("showlevel_tr").style.display='none';	//安全级别
		$GetEle("showlevel_line").style.display='none';
	}else{
		$GetEle("showlevel_tr").style.display='';	//安全级别
		$GetEle("showlevel_line").style.display='';
	}
	
	if(thisvalue==1000){
		jQuery("#modefieldtype").show();
		jQuery("#modefieldtypespan").show();
		if(jQuery("#modefieldtype").val()=='1'){
			jQuery("#showlevel_tr").hide();
		}else{
			jQuery("#showlevel_tr").show();
		}
	}else{
		jQuery("#modefieldtype").hide();
		jQuery("#modefieldtypespan").hide();
	}
}

function changeFieldType(obj){
	if(obj.value=='1'){
		jQuery("#showlevel_tr").hide();
	}else{
		jQuery("#showlevel_tr").show();
	}
	$GetEle("showspan").style.display='';	//浏览框
	$GetEle("relatedid").value="";
	$GetEle("showrelatedname").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
}

function onShowRelated(inputname,spanname){
	var sharetype = $G("sharetype").value;
	var datas = "";
	if(sharetype == '1'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+inputname.value);
	}else if(sharetype == '2'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+inputname.value+"&selectedDepartmentIds="+inputname.value);
	}else if(sharetype == '3'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+inputname.value);
	}else if(sharetype == '4'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	}else if(sharetype == '1000'){
		var modefieldtype = jQuery("#modefieldtype").val();
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape("/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type="+modefieldtype+"&selectedids="+inputname.value+"&modeId=<%=modeId%>"));
	}
	if (datas != undefined && datas != null) {
		var ids = "";
		var names = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		if(datas.id != ''){
			if(sharetype != '4' && sharetype != '1000'){
				ids = datas.id.substring(1);
				names = datas.name.substring(1);
			}else{
				ids = datas.id;
				names = datas.name;
			}
			inputname.value = ids;
			spanname.innerHTML = names;
		}else{
			inputname.value = ids;
			spanname.innerHTML = names;
		}
	}
}


function addValue(){
	thisvalue=$GetEle("sharetype").value;
	var shareTypeValue = thisvalue;
	var shareTypeText = $GetEle("sharetype").options.item($GetEle("sharetype").selectedIndex).text;
	//人力资源(1),分部(2),部门(3),角色后的那个选项值不能为空(4)
	var relatedids="0";
	var relatedShareNames="";
	if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4||thisvalue==1000) {
	    if(!check_form(document.weaver,'relatedid')) {
	        return ;
	    }
	    if (thisvalue == 4){
	        if (!check_form(document.weaver,'rolelevel'))
	            return;
	    }
	    relatedids = $GetEle("relatedid").value;
	    relatedShareNames= $GetEle("showrelatedname").innerHTML;
	}
	if(thisvalue != 1){
    	if (!check_form(document.weaver,'showlevel'))
            return;
    }
	var showlevelValue="0";
	var showlevelText="";
	if (thisvalue!=1&&!(thisvalue==1000&&jQuery("#modefieldtype").val()=="1")) {
	    showlevelValue = $GetEle("showlevel").value;
	    showlevelText = showlevelValue;
	}
	var rolelevelValue=0;
	var rolelevelText="";
	if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
	   	rolelevelValue = $GetEle("rolelevel").value;
	    	rolelevelText = $GetEle("rolelevel").options.item($GetEle("rolelevel").selectedIndex).text;
	}
	
	var righttypeValue =  $GetEle("righttype").value;
	var righttypelText = $GetEle("righttype").options.item($GetEle("righttype").selectedIndex).text;
	
	//共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限+下载权限(TD12005)
	var totalValue=shareTypeValue+"_"+relatedids+"_"+rolelevelValue+"_"+showlevelValue+"_"+righttypeValue+"_"+righttypelText;
	var oRow = oTable.insertRow(-1);
	var oRowIndex = oRow.rowIndex;
	
	if (oRowIndex%2==0) oRow.className="dataLight";
	else oRow.className="dataDark";
	
	for (var i =1; i <=6; i++) {   //生成一行中的每一列
		oCell = oRow.insertCell(-1);
		var oDiv = document.createElement("div");
		if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
		else if (i==2) oDiv.innerHTML=shareTypeText;
		else  if (i==3) oDiv.innerHTML=relatedShareNames;
		else  if (i==4) oDiv.innerHTML=rolelevelText;
		else  if (i==5) {
			if (showlevelText=="0") {
				showlevelText="";
			}
			if(thisvalue==1000&&jQuery("#modefieldtype").val()=="1"){
				showlevelText="";
			}
			oDiv.innerHTML=showlevelText;
		}
		else  if (i==6) oDiv.innerHTML=righttypelText;
		oCell.appendChild(oDiv);
	}
}

function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
    }
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }
}

function doSave(obj){
    obj.disabled=true;
    weaver.submit();
}
</script>

</BODY>
</HTML>
