<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="hpc" class= "weaver.homepage.cominfo.HomepageElementCominfo" scope="page" />
<jsp:useBean id="rc" class= "weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="scc" class= "weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="dci" class= "weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="shp" class= "weaver.splitepage.transform.SptmForHomepage" scope="page" />
<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />

<%
    String eid = Util.null2String(request.getParameter("eid")); 
	String esharelevel = Util.null2String(request.getParameter("esharelevel"));
    String  share = hpc.getShare(eid);
%>
<html>
<HEAD> 
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
    <SCRIPT language="javascript" src="/js/jquery/jquery.js"></script>
    <style>
    body {
		MARGIN: 0px;
	}
    </style>
</HEAD>
<body>


<%
   
%>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="0">
        <col width="">
        <col width="0">
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
        <tr>
            <td ></td>
            <td valign="top">
                <TABLE width="100%">
                    <tr>
                        <td valign="top">  
                            <form name="frmAdd_<%=eid%>" id="frmAdd_<%=eid%>" method="post" action="ElementShareOperation.jsp">
                              <INPUT TYPE="hidden" NAME="eid" value="<%=eid%>">           
                              <INPUT type="hidden" Name="method" value="addShare">
                              <input type="hidden" name="esharelevel" value="<%=esharelevel %>">
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>                                    
                                    <TR class=Spacing style="height: 1px">
                                    	<TD class=Line1 colSpan=2></TD>
                                    </TR>
                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                            
                                            <SELECT class=InputStyle  name=sharetype id="sharetype" onchange="onChangeSharetype(this,relatedshareid,showrelatedsharename)" >   
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> 
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                                                <option value="6"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
                    							<option value="7"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
                                                <option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            
											<BUTTON class=Browser id="btnHrm" style="" type="button"  onClick="onShowResource('relatedshareid','showrelatedsharename')" name="btnRelatedHrm"></BUTTON> 

											<BUTTON class=Browser id="btnSubcompany" type="button"  style="display:none"  onClick="onShowSubcompany('relatedshareid','showrelatedsharename')" name="btnRelatedSubcompany"></BUTTON> 

											<BUTTON class=Browser id="btnDepartment" style="display:none" type="button"  onClick="onShowDepartment('relatedshareid','showrelatedsharename')" name="btnRelatedAll"></BUTTON> 
                                            <BUTTON class=Browser id="btnRole" type="button"  style="display:none"  onClick="onShowRole('relatedshareid','showrelatedsharename')" name="btnDepartment"></BUTTON>
											<INPUT type=hidden name="relatedshareid"  id="relatedshareid" value="">
                                            <span id="showrelatedsharename" name="showrelatedsharename">
												<IMG src='/images/BacoError.gif' align="absMiddle">
											</span>                                            
                                        </TD>		
                                    </TR>
                                    <tr style='display:none;height:1px;'><td class="line" colspan=2></td></tr> 
									<tr id='roletype_tr' style='display:none'>
										<td width="20%"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
										<td width="80%" class="field">
											<SELECT class=InputStyle  name=roletype id="roletype">
												<option value='2'><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option><!-- 总部 -->
												<option value='1'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
												<option selected value='0'><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></option><!-- 部门 -->
											</SELECT>
										</td>
									</tr>
									<tr style='display:none;height:1px;'><td class="line" colspan=2></td></tr>
									<tr id='securitylevel_tr' style='display:none'>
										<td width="20%"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
										<td width="80%" class="field">
									 	<select class="InputStyle" name="operate" id="operate">
											<option value="0">>=</option>
											<option value="1"><=</option>
										</select>
										<input id='securitylevel' name='securitylevel' type='text' size='3' class='inputstyle' value='10' onChange='checkinput("securitylevel","securitylevelspan")'>
									 	<span id=securitylevelspan name=securitylevelspan >
											
										</span>
									 </td>
									</tr>
                                    <TR style="height:1px;">
                                        <TD class=Line colSpan=2></TD>
                                    </TR>                                  

                                    <tr>
                                        <TD  colspan=2>
                                           <TABLE  width="100%">
                                            <TR>
                                                <TD width=""></TD>
                                                <TD width="90px"><img src="/images/arrow_d.gif" style="cursor:hand" title="添加" onclick="addValue()" border="0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/arrow_u.gif" style="cursor:hand" title="移除" border="0" onclick="removeValue()"></TD>
                                                <TD width=""></TD>
                                            </TR>
                                           </TABLE>
                                        </TD>
                                    <tr>
                                   <TR style="height:1px;">
                                        <TD class=Line colSpan=2></TD>
                                   </TR>
                                   <tr>
                                        <td colspan=2>
                                            <table class="listStyle" id="oTable" name="oTable">
                                                <colgroup>
                                                <col width="8%">
                                                <col width="42%">
                                                <col width="50%">
                                                <tr class="header">
                                                    <td><input type="checkbox" name="chkAll" onclick="chkAllClick(this)"></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></td>
                                                </tr>
                                                <tr class=line style="height: 1px"><td colspan=3 style="padding:0"></td></tr>
                                                <%
                                                out.println(shp.getElementShareStr(eid,user.getLanguage()));
                                                %>
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

</body>
</html>


<SCRIPT type="text/JavaScript">
<!--

  function onChangeSharetype(seleObj,txtObj,spanObj){
	var thisvalue=seleObj.value;	
    var strAlert= "<IMG src='/images/BacoError.gif' align=absMiddle>";
	
	if(thisvalue==1){  //人员
 		$("#btnHrm").show();
		$("#btnSubcompany").hide();
		$("#btnDepartment").hide();
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").hide();
		$("#securitylevel_tr").prev().hide();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;
		txtObj.value="";		
		spanObj.innerHTML=strAlert;	
	} else if (thisvalue==2)	{ //分部
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='';
		document.getElementById("btnDepartment").style.display='none';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==3)	{ //部门
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='none';
		document.getElementById("btnDepartment").style.display='';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==5)	{ //所有人
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='none';
		document.getElementById("btnDepartment").style.display='none';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").hide();
		$("#securitylevel_tr").prev().hide();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="1";
		spanObj.innerHTML="";
	}else if (thisvalue==6){
		$("#btnRole").show();
		$("#btnHrm").hide();
		$("#btnSubcompany").hide();
		$("#btnDepartment").hide();
		$("#roletype_tr").show();
		$("#roletype_tr").prev().show();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		txtObj.value="";
		spanObj.innerHTML=strAlert;
	}else if (thisvalue==7){
		$("#btnRole").hide();
		$("#btnHrm").hide();
		$("#btnSubcompany").hide();
		$("#btnDepartment").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		txtObj.value=$("#securitylevel").val();
		$("#roletype").val(0);
		$("#operate").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		spanObj.innerHTML="";
	}
	
}
function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex);
    }
}

function addValue(){
   	var thisvalue=document.getElementById("sharetype").value;

   	var shareTypeValue = thisvalue;
   	//共享类型
	var shareTypeText = "";
    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
    var relatedShareIds="0";
    var relatedShareNames="";
    if (thisvalue!=5) {
    	if($("#securitylevel").is(":hidden")){
	        if(!check_form(document.frmAdd_<%=eid%>,'relatedshareid')) {
	            return ;
	        }
        }else{
        	if(!check_form(document.frmAdd_<%=eid%>,'relatedshareid,securitylevel')) {
	            return ;
	        }
        }
    }
    switch(parseInt(thisvalue)){
       	case 1:
       		shareTypeText = $("#sharetype option:selected").text();
       		relatedShareIds = $("#relatedshareid").val();
       		relatedShareNames= $("#showrelatedsharename").html();
       		break;
       	case 2:
       	case 3:
       		shareTypeText = $("#sharetype option:selected").text()+"+"+$("#securitylevel").parent().prev().text();
       		relatedShareIds = $("#relatedshareid").val()+"_"+$("#operate").val()+"_"+$("#securitylevel").val();
       		relatedShareNames= $("#showrelatedsharename").html()+"+"+$("#operate option:selected").text()+$("#securitylevel").val();
       		break;
       	case 5:
       		shareTypeText = $("#sharetype option:selected").text();
       		relatedShareIds = $("#relatedshareid").val();
       		relatedShareNames= shareTypeText;
       		break;
       	case 6:
       		shareTypeText = $("#sharetype option:selected").text()+"+"+$("#roletype").parent().prev().text()+"+"+$("#securitylevel").parent().prev().text();
       		relatedShareIds = $("#relatedshareid").val()+"_"+$("#roletype").val()+"_"+$("#operate").val()+"_"+$("#securitylevel").val();
       		relatedShareNames = $("#showrelatedsharename").html()+"+"+$("#roletype option:selected").text()+"+"+$("#operate option:selected").text()+$("#securitylevel").val();
       		break;
       	case 7:
       		shareTypeText = $("#sharetype option:selected").text();
       		$("#relatedshareid").val($("#securitylevel").val());
       		relatedShareIds =$("#operate").val()+"_"+$("#securitylevel").val();
       		relatedShareNames = $("#operate option:selected").text()+$("#securitylevel").val();
       		break;
       		
   }

   //共享类型 + 共享者ID
   var totalValue=shareTypeValue+"$"+relatedShareIds;
   //if(thisvalue==5) relatedShareNames=shareTypeText;  //所有人

   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.rowIndex;

   if (oRowIndex%2==0) oRow.className="dataLight";
   else oRow.className="dataDark";
	
   for (var i =1; i <=3; i++) {   //生成一行中的每一列
      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
      else if (i==2) oDiv.innerHTML=shareTypeText;
	  else if (i==3) oDiv.innerHTML=relatedShareNames;
      oCell.appendChild(oDiv);
   }
}

function chkAllClick(obj){
	 var chkboxElems= document.getElementsByName("chkShareDetail");
	    for (var j=0;j<chkboxElems.length;j++)
	    {
	        if (obj.checked) 
	        {
	        	if(chkboxElems[j].style.display!='none'){
	            	chkboxElems[j].checked = true ;		
	            }	
	        } 
	        else 
	        {       
	            chkboxElems[j].checked = false ;
	        }
	    }
}

//-->
</SCRIPT>
<SCRIPT type="text/JavaScript">
	function onShowResource(inputname,spanname){
		 linkurl="javaScript:openhrm(";
		 var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
		
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

function doSave(obj){
    obj.disabled=true;
	frmAdd_<%=eid%>.submit();    
	alert("");
}	
function onShowSubcompany(inputname,spanname)  {
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
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
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
function onShowDepartment(inputname,spanname){
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
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
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


function onShowRole(inputename,tdname){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","dialogHeight=550px;dialogWidth=550px;");
	
	if (datas){
	    if (datas.id!="") {
		    $("#"+tdname).html(datas.name);
		    $("input[name="+inputename+"]").val(datas.id);
	    }else{
		    	$("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		    $("input[name="+inputename+"]").val("");
	    }
	}
}

</script>
