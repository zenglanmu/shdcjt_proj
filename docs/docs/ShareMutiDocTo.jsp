<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String docsubject= "" ;
String sharedocids = Util.null2String(request.getParameter("sharedocids"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(17220,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2112,user.getLanguage());
String needfav ="1";
String needhelp ="";
docsubject = Util.toScreen(docsubject,user.getLanguage(),"0");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
boolean canEdit = true ;
	/*if has Seccateory edit right, or has approve right(canapprove=1), or user is the document creater can edit documetn right.*/
/*if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user)||canapprove==1||user.getUID()==doccreaterid){
	canEdit = true;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
*/
RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:doShare(this),_top} " ;
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

<FORM id=weaver name=weaver action="ShareMutiDocOperation.jsp" method=post >
<input type="hidden" name="sharedocids" value="<%=sharedocids%>">
<input type="hidden" name="rownum" value="">


	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2></TH>
          </TR>
        <TR class=Spacing style="height: 1px;">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD class=field>
 <%
    String isdisable = "";
    if(!canEdit) isdisable ="disabled";
%>
  <SELECT class=InputStyle  name=sharetype onchange="onChangeSharetype()" <%=isdisable%>>
  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
  <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
  <option value="6"><%=SystemEnv.getHtmlLabelName(24002,user.getLanguage())%></option>
  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
  <option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
<%if(isgoveproj==0){%>
 <%while(CustomerTypeComInfo.next()){
	String curid=CustomerTypeComInfo.getCustomerTypeid();
	String curname=CustomerTypeComInfo.getCustomerTypename();
	String optionvalue="-"+curid;
%>
	<option value="<%=optionvalue%>"><%=Util.toScreen(curname,user.getLanguage())%></option>
<%
}
}%>
</SELECT>
		  </TD>
	 <%
                String ordisplay="";
                if(!canEdit) ordisplay = " style='display:none' ";
                %> 
          <TD class=field <%=ordisplay%>>
<button type="button" class=Browser style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON>
<button type="button" class=Browser style="display:none" onClick="onShowSubcompany('showrelatedsharename','relatedshareid')" name=showsubcompany></BUTTON>
<button type="button" class=Browser style="" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON>
<button type="button" class=Browser style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
<button type="button" class=Browser style="display:none" onClick="onShowOrgGroup('relatedshareid','showrelatedsharename')" name=showOrgGroup></BUTTON>


 <INPUT type=hidden name=relatedshareid  id=relatedshareid value="">
 
 <span id=showrelatedsharename name=showrelatedsharename><IMG src='/images/BacoError.gif' align=absMiddle></span>
 
<span id=showrolelevel name=showrolelevel style="visibility:hidden">
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
<SELECT class=InputStyle  name=rolelevel  <%=isdisable%>>
  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
</SELECT>
</span>
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<span id=showseclevel name=showseclevel>
<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
<INPUT type=text name=seclevel class=InputStyle size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' <%=isdisable%>>
</span>
<SPAN id=seclevelimage></SPAN>

		  </TD>
		</TR>

<TR style="height:1px;">
	<TD class=Line colSpan=2></TD>
</TR>
       <tr>
          <TD class=field>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<SELECT class=InputStyle  name=sharelevel <%=isdisable%>  onchange="onOptionChange('sharelevel')">
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
              <option value="3"><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
            </SELECT>
		  	<input class='InputStyle' type='checkbox' name='chksharelevel' id='chksharelevel' style="display:''" onclick="setCheckbox(chksharelevel)">
          	<label for='lblsharelevel' id='lblsharelevel' style="display:''"><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>
		  </TD>
		</TR>

<TR style="height:1px;">
	<TD class=Line colSpan=2></TD>
</TR>

		</TBODY>
	  </TABLE>
<button type="button" Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%></BUTTON>
<button type="button" Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRow();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%></BUTTON></div>
<!--默认共享-->
        <TABLE class=ListStyle cellspacing="1"  id=oTable>
          <colgroup>
          <col width="5%">
          <col width="20%">
          <col width="75%">
          <tr class=header >
            <td colspan=3><%=SystemEnv.getHtmlLabelName(1985,user.getLanguage())%></td></tr>


        </table>


      </TD></TR>
    </TBODY>
  </TABLE>
</form>

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
function doShare(obj) {
    $GetEle("rownum").value=curindex;
    obj.disabled=true;
    weaver.submit();
}
</script>
<script language="JavaScript" src="/js/addRowBg.js"></script>
<script language="javascript">
//===== 文档下载权限控制  开始========//
function onOptionChange(selObjName) {
    var selObj = document.all(selObjName);//选择控件对象
	var oVal = selObj.options[selObj.selectedIndex].value;//选中值
	var chkObj = document.all('chk'+selObjName);//复选框控件对象
    var lblObj = document.all('lbl'+selObjName);//复选框控件对应标签对象

	if(oVal == 1) {//查看时显示	
		chkObj.style.display = '';
		lblObj.style.display = '';
	} else {
		chkObj.style.display = 'none';
		lblObj.style.display = 'none';
	}
}
function setCheckbox(chkObj) {
	if(chkObj.checked == true) {
		chkObj.value = 1;
	} else {
		chkObj.value = 0;
	}
}
//===== 文档下载权限控制  结束========//

  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
		document.weaver.relatedshareid.value="";
	$GetEle("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"

	if(thisvalue==1){
 		$GetEle("showresource").style.display='';
		$GetEle("showseclevel").style.display='none';
	}
	else{
		$GetEle("showresource").style.display='none';
	}
	if(thisvalue==2){
 		$GetEle("showsubcompany").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		$GetEle("showsubcompany").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==3){
 		$GetEle("showdepartment").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		$GetEle("showdepartment").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==4){
 		$GetEle("showrole").style.display='';
		$GetEle("showrolelevel").style.visibility='visible';
		document.weaver.seclevel.value=10;
	}
	else{
		$GetEle("showrole").style.display='none';
		$GetEle("showrolelevel").style.visibility='hidden';
		document.weaver.seclevel.value=10;
    }
	if(thisvalue==5){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=10;
	}
	//TD18757
	if(thisvalue==6){
 		$GetEle("showOrgGroup").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		$GetEle("showOrgGroup").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue<0){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=0;
	}
}

function checkValid(){
    if($GetEle("seclevel").value==""&&$GetEle("showseclevel").style.display!="none"){
        alert("安全级别不能为空");
        return false;
    }
    if($("#relatedshareid").val()==""){
        alert("相关共享不能为空");
        return false;
    }
    return true;
}

var curindex=0;
function addRow(){
    if(!checkValid()){
        return ;
    }
    rowColor = getRowBg();
    var oRow = oTable.insertRow(-1);

    var oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    var oDiv = document.createElement("div");
    var sHtml = "<input type='checkbox' name='check_node' value='0'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    oDiv = document.createElement("div");
	sHtml = $GetEle("sharetype").options[$GetEle("sharetype").selectedIndex].text;
	sHtml += "<input type='hidden' name='sharetype_"+curindex+"' value='"+$GetEle("sharetype").value+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);


    oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    oDiv = document.createElement("div");
    sHtml = $GetEle("showrelatedsharename").innerHTML;
    sHtml += "<input type='hidden' name='relatedshareid_"+curindex+"' value='"+$GetEle("relatedshareid").value+"'>";

    if($GetEle("showrolelevel").style.visibility!="hidden"){
        sHtml += "/"+$GetEle("rolelevel").options[$GetEle("rolelevel").selectedIndex].text;
    }
    sHtml += "<input type='hidden' name='rolelevel_"+curindex+"' value='"+$GetEle("rolelevel").value+"'>";

    if($GetEle("showseclevel").style.display!="none"){
        sHtml += "<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:"+$GetEle("seclevel").value;
    }
    sHtml += "<input type='hidden' name='seclevel_"+curindex+"' value='"+$GetEle("seclevel").value+"'>";

    sHtml += "/"+$GetEle("sharelevel").options[$GetEle("sharelevel").selectedIndex].text;
    sHtml += "<input type='hidden' name='sharelevel_"+curindex+"' value='"+$GetEle("sharelevel").value+"'>";

	if($GetEle("chksharelevel").style.display!="none"&&$GetEle("chksharelevel").value=="1"){
    	sHtml += " <%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%>";
    	sHtml += "<input type='hidden' name='downloadlevel_"+curindex+"' value='"+$GetEle("chksharelevel").value+"'>";
    }
    
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    curindex++;
}

function deleteRow()
{
	
	try{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1);
			}
			rowsum1 -=1;
		}

	}}
	catch (e) {
		alert(""+e.message)
	}
}


</script>

<script type="text/javascript"> 
	function onShowDepartment(spanname,inputname){
	    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp")
		if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href="+linkurl+ids[i]+">"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
	}
	
	
	function onShowSubcompany(spanname,inputname){
	    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp")
		if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href="+linkurl+ids[i]+">"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
	}
	
	function onShowResource(spanname,inputname){
	    linkurl="javaScript:openhrm(";
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;	
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;")
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
				    $("#"+spanname).html(sHtml);
				    $("input[name="+inputname+"]").val(datas.id);
			    }
			    else	{
		    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
				    $("input[name="+inputname+"]").val("");
			    }
			}
	}
	
	function onShowRole(tdname,inputename){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
		if (datas){
		    if (datas.id!=""){
				$("#"+tdname).html(datas.name);
				$("input[name="+inputename+"]").val(datas.id);
			}
			else{
				$("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
				$("input[name="+inputename+"]").val("");
			}
		}
	}
	function onShowOrgGroup(inputname,spanname){
		linkurl="/hrm/orggroup/HrmOrgGroupRelated.jsp?orgGroupId=";
		url="/hrm/orggroup/HrmOrgGroupBrowser.jsp";
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
		if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href="+linkurl+ids[i]+">"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
	}
</script>

</BODY>
</HTML>
