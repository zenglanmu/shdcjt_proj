<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>

<%   

String resourceCondition = Util.null2String(request.getParameter("resourceCondition"));
String isFromMode = Util.null2String(request.getParameter("isFromMode"));//是否来自于图形化表单，如果来自于图形化表单，则返回的值中将不带链接。


%>

<html>
<HEAD> 
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>

<body>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<table width=100% height=93% border="0" cellspacing="0" cellpadding="0">
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
                            <form name="weaver" method="post">      

                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>
                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></B></TD>
									 </TR>								
                                    <TR class=Spacing style="height:1px;">
                                    <TD class=Line1 colSpan=2></TD></TR>
                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                            
                                            <SELECT class=InputStyle  name=sharetype onchange="onChangeSharetype(this)" >   
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> 
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                                                <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>    
                                                <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            <button type="button"  class=Browser style="display:''" onClick="onShowResource('relatedshareid','showrelatedsharename','showrelatedsharenameofnolink')" name=showresource></BUTTON> 
                                            <button type="button"  class=Browser style="display:none" onClick="onShowSubcompany('relatedshareid','showrelatedsharename','showrelatedsharenameofnolink')" name=showsubcompany></BUTTON> 
                                            <button type="button"  class=Browser style="display:none" onClick="onShowDepartment('relatedshareid','showrelatedsharename','showrelatedsharenameofnolink')"     name=showdepartment></BUTTON> 
                                            <button type="button"  class=Browser style="display:none" onclick="onShowRole('relatedshareid','showrelatedsharename','showrelatedsharenameofnolink')" name=showrole></BUTTON>
                                            <INPUT type=hidden name=relatedshareid  id="relatedshareid" value="">
                                            <span id=showrelatedsharename name=showrelatedsharename><IMG src='/images/BacoError.gif' align=absMiddle></span> 
                                            <span id=showrelatedsharenameofnolink name=showrelatedsharenameofnolink style="display:none"></span> 
											
                                        </TD>		
                                    </TR>
                                    <TR style="height:1px;">
                                        <TD class=Line colSpan=2></TD>
                                    </TR>

                                    <TR id=showrolelevel name=showrolelevel style="display:none">
                                        <TD>
                                            <%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <SELECT  name=rolelevel>
                                                    <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
                                                    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
                                                    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
                                                </SELECT>
                                        </td>
                                    </TR>
                                     <TR style="height:1px;">
                                        <TD class=Line colSpan=2  id=showrolelevel_line name=showrolelevel_line style="display:none"></TD>
                                     </TR>

                                      <TR  id=showseclevel name=showseclevel style="display:none">
                                        <TD>
                                             <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <INPUT type=text name=seclevel class=InputStyle size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' onkeypress="ItemCount_KeyPress()">
                                             <span id=seclevelimage></span>
                                        </td>
                                    </TR>
                                     <TR style="height:1px;">
                                        <TD class=Line colSpan=2 id=showseclevel_line name=showseclevel_line style="display:none"></TD>
                                     </TR>

                                    <tr>
                                        <TD  colspan=2>
                                           <TABLE  width="100%">
                                            <TR>
                                                <TD width="40%"></TD>
                                                <TD width="20%"><img src="/images/arrow_d.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addValue()" border="0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(20230,user.getLanguage())%>" border="0" onclick="removeValue()"></TD>
                                                <TD width="40%"></TD>
                                            </TR>
                                           </TABLE>
                                        </TD>
                                    <tr>

                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(19255,user.getLanguage())%></B></TD>
									 </TR>								
                                     <TR class=Spacing  style="height:1px;">
									     <TD class=Line1 colSpan=2></TD>
									 </TR>

                                   <tr>
                                        <td colspan=2>
                                            <table class="listStyle" id="oTable" name="oTable">
                                                <colgroup>
                                                <col width="4%">
                                                <col width="16%">
                                                <col width="16%">
                                                <col width="16%">
                                                <col width="16%">
                                                </colgroup>
                                                <tr class="header">
                                                    <td><input type="checkbox" name="chkAll" onclick="chkAllClick(this)"></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
                                                </tr>
                                                <tr class=line style="height:1px;"><td colspan=5></td></tr>
												<%=ResourceConditionManager.getBrowserTRString(resourceCondition,user.getLanguage())%>
                                            </table>
                                        </td>
                                   </tr>
                                </TBODY>
                            </TABLE>
                        </td>
                    </tr>
                </TABLE>
                </form>
            </td>
            <td></td>
        </tr>
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
        </table>

<TABLE width="100%">
<tr width=100%>
     <td align="center" valign="bottom" colspan=3>
     
	    <button type="button"  class=btn accessKey=O  id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	    <button type="button"  class=btn accessKey=2  id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>		
        <button type="button"  class=btnReset accessKey=T  id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
</tr>
</TABLE>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

var shareTypeValues = ""
var shareTypeTexts = ""
var relatedShareIdses = ""
var relatedShareNameses = ""
var relatedShareNamesesOfNoLink = ""
var rolelevelValues = ""
var rolelevelTexts = ""
var secLevelValues = ""
var secLevelTexts = ""

function onChangeSharetype(_this){

	var thisvalue=_this.value;
	$G("relatedshareid").value="";
	$G("showseclevel").style.display='';
    $G("showseclevel_line").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"

	if(thisvalue==1){
 		$G("showresource").style.display='';
		$G("showseclevel").style.display='none';
        $G("showseclevel_line").style.display='none';
        $G("seclevel").value=0;
	}else{
		$G("showresource").style.display='none';
	}

	if(thisvalue==2){
 		$G("showsubcompany").style.display='';
 		$G("seclevel").value=10;
	}
	else{
		$G("showsubcompany").style.display='none';
		$G("seclevel").value=10;
	}
	if(thisvalue==3){
 		$G("showdepartment").style.display='';
 		$G("seclevel").value=10;
	}
	else{
		$G("showdepartment").style.display='none';
		$G("seclevel").value=10;
	}
	if(thisvalue==4){
 		$G("showrole").style.display='';
		$G("showrolelevel").style.display='';
    $G("showrolelevel_line").style.display='';
    $G("rolelevel").style.display='';
		$G("seclevel").value=10;
	}
	else{
		$G("showrole").style.display='none';
		$G("showrolelevel").style.display='none';
    $G("showrolelevel_line").style.display='none';
    $G("rolelevel").style.display='none';
		$G("seclevel").value=10;
    }
	if(thisvalue==5){
		showrelatedsharename.innerHTML = ""
		$G("relatedshareid").value=-1;
		$G("seclevel").value=10;
	}
}


function removeValue(){

	len = document.forms[0].elements.length;

	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='chkShareDetail')
			rowsum1 += 1;
	}

	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='chkShareDetail'){

			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+1);				
			}
			rowsum1 -=1;
		}
	
	} 
}

function addValue(){

   thisvalue=$("select[name=sharetype]").val();

   var shareTypeValue = thisvalue;
   var shareTypeText = $($("select[name=sharetype]")[0].options.item($("select[name=sharetype]")[0].selectedIndex)).text();


    //人力资源(1),分部(2),部门(3),角色后的那个选项值不能为空(4)
    var relatedShareIds="0";
    var relatedShareNames="";
	var relatedShareNamesOfNoLink="";
    if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4) {
        if(!check_form(document.weaver,'relatedshareid')) {
            return ;
        }
        if (thisvalue==4){
            if (!check_form(document.weaver,'seclevel'))
                return;
        }
        relatedShareIds = $("input[name=relatedshareid]").val();
        relatedShareNames= $("#showrelatedsharename").html();
        relatedShareNamesOfNoLink= $("#showrelatedsharenameofnolink").html();
    }

    var secLevelValue="0";
    var secLevelText="";
    if (thisvalue!=1) {
        secLevelValue = $("input[name=seclevel]").val();
        secLevelText=secLevelValue;
		if (secLevelText=="0") secLevelText="";
    }

   var rolelevelValue=0;
   var rolelevelText="";
   if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
       rolelevelValue = $("select[name=rolelevel]").val();
       rolelevelText=$($("select[name=rolelevel]")[0].options.item($("select[name=rolelevel]")[0].selectedIndex)).text();
   }


   //共享类型 + 共享者ID +共享角色级别 +共享级别
   var totalValue=shareTypeValue+"_"+relatedShareIds+"_"+rolelevelValue+"_"+secLevelValue;


   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.rowIndex;

   if (oRowIndex%2==0) oRow.className="dataLight";
   else oRow.className="dataDark";

   for (var i =1; i <=5; i++) {   //生成一行中的每一列


      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'>";
      else  if (i==2) oDiv.innerHTML=shareTypeText+"<input type='hidden' name='shareTypeValue' value='"+shareTypeValue+"'><input type='hidden' name='shareTypeText' value='"+shareTypeText+"'>";
      else  if (i==3) oDiv.innerHTML=relatedShareNames+"<input type='hidden' name='relatedShareIds' value='"+relatedShareIds+"'><input type='hidden' name='relatedShareNames' value='"+relatedShareNames+"'><input type='hidden' name='relatedShareNamesOfNoLink' value='"+relatedShareNamesOfNoLink+"'>";
      else  if (i==4) oDiv.innerHTML=rolelevelText+"<input type='hidden' name='rolelevelValue' value='"+rolelevelValue+"'><input type='hidden' name='rolelevelText' value='"+rolelevelText+"'>";
      else  if (i==5) oDiv.innerHTML=secLevelText+"<input type='hidden' name='secLevelValue' value='"+secLevelValue+"'><input type='hidden' name='secLevelText' value='"+secLevelText+"'>";

      oCell.appendChild(oDiv);
   }
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }
}


function setResourceStr(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
		shareTypeValues += "~"+document.getElementsByName("shareTypeValue")[i].value;
		shareTypeTexts += "~"+document.getElementsByName("shareTypeText")[i].value;
		relatedShareIdses += "~"+document.getElementsByName("relatedShareIds")[i].value;
		relatedShareNameses += "~"+document.getElementsByName("relatedShareNames")[i].value;
		relatedShareNamesesOfNoLink += "~"+document.getElementsByName("relatedShareNamesOfNoLink")[i].value;
		rolelevelValues += "~"+document.getElementsByName("rolelevelValue")[i].value;
		rolelevelTexts += "~"+document.getElementsByName("rolelevelText")[i].value;
		secLevelValues += "~"+document.getElementsByName("secLevelValue")[i].value;
		secLevelTexts += "~"+document.getElementsByName("secLevelText")[i].value;

    }
}

</SCRIPT>
<script type="text/javascript">
<!--
function onShowResource(inputname,spanname, spanNameOfNoLink){
	 linkurl="javaScript:openhrm(";
	 var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
  if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    sHtmlOfNoLink = ""
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
				    	sHtmlOfNoLink = sHtmlOfNoLink + names[i] + " ";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
			    $G(spanNameOfNoLink).innerHTML = sHtmlOfNoLink;
		    }
		    else	{
	    	    $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
			    $G(spanNameOfNoLink).innerHTML = "";
		    }
		}
}

function onShowSubcompany(inputname,spanname, spanNameOfNoLink)  {
		linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	    		"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	   if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    sHtmlOfNoLink = ""
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
				    	sHtmlOfNoLink = sHtmlOfNoLink + names[i] + " ";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
			    $G(spanNameOfNoLink).innerHTML = sHtmlOfNoLink;
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
			    $G(spanNameOfNoLink).innerHTML = "";
		    }
		}
}
function onShowDepartment(inputname,spanname, spanNameOfNoLink){
	linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
			"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	 if (datas) {
	    if (datas.id!= "") {
	        ids = datas.id.split(",");
		    names =datas.name.split(",");
		    sHtml = "";
		    sHtmlOfNoLink = ""
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
			    	sHtmlOfNoLink = sHtmlOfNoLink + names[i] + " ";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(datas.id);
		    $G(spanNameOfNoLink).innerHTML = sHtmlOfNoLink;
	    }
	    else	{
    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		    $("input[name="+inputname+"]").val("");
		    $G(spanNameOfNoLink).innerHTML = "";
	    }
	}
}


function onShowRole(inputename,tdname, spanNameOfNoLink){
	linkurl="/hrm/roles/HrmRolesEdit.jsp?id="
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","dialogHeight=550px;dialogWidth=550px;");
	
	if (datas){
	    if (datas.id!="") {
		    $("#"+tdname).html("<a href=" + linkurl + datas.id + ">" + datas.name + "</a>&nbsp");
		    $("input[name="+inputename+"]").val(datas.id);
		    $G(spanNameOfNoLink).innerHTML = datas.name + " ";
	    }else{
		    	$("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		    $("input[name="+inputename+"]").val("");
		    $G(spanNameOfNoLink).innerHTML = "";
	    }
	}
}


function btndelete_onclick(){
	removeValue();
}

function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:"",relatedIds:"",relatedLink:"",rolevelIds:"",roleLevelText:"",secLevelIds:"",secLevelTexts:""}
     window.parent.parent.close();
}


function btnok_onclick(){
     setResourceStr();

<%
    if("1".equals(isFromMode)){
%>
     window.parent.parent.returnValue = {id:shareTypeValues,name:shareTypeTexts,relatedIds:relatedShareIdses,relatedLink:relatedShareNamesesOfNoLink,
    	     rolevelIds:rolelevelValues,roleLevelText:rolelevelTexts,secLevelIds:secLevelValues,secLevelTexts:secLevelTexts};
<%
    }else{
%>
     window.parent.parent.returnValue = {id:shareTypeValues,name:shareTypeTexts,relatedIds:relatedShareIdses,relatedLink:relatedShareNameses,rolevelIds:rolelevelValues,
    		 roleLevelText:rolelevelTexts,secLevelIds:secLevelValues,secLevelTexts:secLevelTexts};
<%
    }
%>

     window.parent.parent.close();
}


function btncancel_onclick(){
	window.parent.parent.close()
}
//-->
</script>
