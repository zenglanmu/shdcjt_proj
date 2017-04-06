<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="hpc" class= "weaver.homepage.cominfo.HomepageCominfo" scope="page" />
<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />

<%
    int hpid = Util.getIntValue(request.getParameter("hpid"),0); 
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
    String  hpname = hpc.getInfoname(""+hpid);
%>

<html>
<HEAD> 
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
   
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
   
%>

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
                            <form name="frmAdd" method="post" action="HomepageShareOperation.jsp">
                              <INPUT TYPE="hidden" NAME="hpid" value="<%=hpid%>">           
                              <INPUT type="hidden" Name="method" value="addMutil">
                			  <INPUT type="hidden" Name="subCompanyId" value="<%=subCompanyId%>">
							  

                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>                                    
                                    <TR class=Spacing style="height:1px;">
                                    <TD class=Line1 colSpan=2></TD></TR>
                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                            
                                            <SELECT class=InputStyle  name=sharetype id="sharetype" onchange="onChangeSharetype(this,relatedshareid,showrelatedsharename)" >   
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> 
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                                                <option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            
											<button type=button  class=Browser id="btnRelatedHrm" style="display:''" onClick="onShowResource('relatedshareid','showrelatedsharename')" name="btnRelatedHrm"></BUTTON> 

											<button type=button  class=Browser id="btnRelatedSubcompany" style="display:none"  onClick="onShowSubcompany('relatedshareid', 'showrelatedsharename')" name="btnRelatedSubcompany"></BUTTON> 

											<button type=button  class=Browser id="btnRelatedDepartment" style="display:none"  onClick="onShowDepartment('relatedshareid', 'showrelatedsharename')" name="btnRelatedAll"></BUTTON> 
                                            
											<INPUT type=hidden name="relatedshareid"  id="relatedshareid" value="">
                                            <span id="showrelatedsharename" name="showrelatedsharename">
												<IMG src='/images/BacoError.gif' align=absMiddle>
											</span>                                            
                                        </TD>		
                                    </TR>
                                    <TR style="height:1px;">
                                        <TD class=Line colSpan=2></TD>
                                    </TR>                                  

                                    <tr>
                                        <TD  colspan=2>
                                           <TABLE  width="100%">
                                            <TR>
                                                <TD width="40%"></TD>
                                                <TD width="20%"><img src="/images/arrow_d.gif" style="cursor:hand" title="添加" onclick="addValue()" border="0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/arrow_u.gif" style="cursor:hand" title="移除" border="0" onclick="removeValue()"></TD>
                                                <TD width="40%"></TD>
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
                                                <tr class=line style="height:1px;"><td colspan=6 style="padding:0;"></td></tr>
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


<SCRIPT LANGUAGE="JavaScript">
<!--

  function onChangeSharetype(seleObj,txtObj,spanObj){
	var thisvalue=seleObj.value;	
    var strAlert= "<IMG src='/images/BacoError.gif' align=absMiddle>"
	
	if(thisvalue==1){  //人员
 		document.getElementById("btnRelatedHrm").style.display='';
		document.getElementById("btnRelatedSubcompany").style.display='none';
		document.getElementById("btnRelatedDepartment").style.display='none';
		txtObj.value="";		
		spanObj.innerHTML=strAlert;	
	} else if (thisvalue==2)	{ //分部
		document.getElementById("btnRelatedHrm").style.display='none';
		document.getElementById("btnRelatedSubcompany").style.display='';
		document.getElementById("btnRelatedDepartment").style.display='none';
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==3)	{ //部门
		document.getElementById("btnRelatedHrm").style.display='none';
		document.getElementById("btnRelatedSubcompany").style.display='none';
		document.getElementById("btnRelatedDepartment").style.display='';
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==5)	{ //所有人
		document.getElementById("btnRelatedHrm").style.display='none';
		document.getElementById("btnRelatedSubcompany").style.display='none';
		document.getElementById("btnRelatedDepartment").style.display='none';
		txtObj.value="";
		spanObj.innerHTML="";
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

function addValue(){
   var thisvalue=document.getElementById("sharetype").value;

   var shareTypeValue = thisvalue;
   var shareType=$("#sharetype")[0];
   var shareTypeText = $(shareType.options[shareType.selectedIndex]).text();

    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
    var relatedShareIds="0";
    var relatedShareNames="";
    if (thisvalue==1 || thisvalue==2 || thisvalue==3) {
        if(!check_form(document.frmAdd,'relatedshareid')) {
            return ;
        }
        relatedShareIds = $G("relatedshareid").value;
        relatedShareNames= $G("showrelatedsharename").innerHTML;
        //alert(relatedShareIds);
    }

   //共享类型 + 共享者ID
   var totalValue=shareTypeValue+"_"+relatedShareIds
   if(thisvalue==5) relatedShareNames=shareTypeText;  //所有人

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
	    for (j=0;j<chkboxElems.length;j++)
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

<<script type="text/javascript">
//<!--
function disModalDialogRtnM(url, inputname, spanname, need, curl, isjs) {
	var id = window.showModalDialog(url);
	
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var names = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
			$G(inputname).value = ids;
			var sHtml = "";
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");
			
			for ( var i = 0; i < ridArray.length; i++) {
				var curid = ridArray[i];
				var curname = rNameArray[i];
				
				if (curl != undefined && curl != null && curl != "") {
					sHtml += ("&nbsp;<A href='" + curl+ curid) 
							+ (isjs ? ")' onclick='pointerXY(event);" : "")
							+ ("'>" + curname + "</a>&nbsp;");
				} else {
					sHtml += curname + (i < ridArray.length - 1) ? "," : ""; 
				}
			}
			
			$G(spanname).innerHTML = sHtml;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";;
		}
	}
}

function onShowSubcompany(inputname,spanname) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=" + $G(inputname).value;
	var curl = "/hrm/company/HrmSubCompanyDsp.jsp?id=";
	disModalDialogRtnM(url, inputname, spanname, true, curl);
}

function onShowDepartment(inputname,spanname) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + $G(inputname).value;
	var curl = "/hrm/company/HrmDepartmentDsp.jsp?id=";
	disModalDialogRtnM(url, inputname, spanname, true, curl);
}

function onShowResource(inputname,spanname) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
	var curl = "javaScript:openhrm(";
	disModalDialogRtnM(url, inputname, spanname, true, curl, true);
}

function doSave(obj) {
	obj.disabled=true;
	$G("frmAdd").submit();    
}
//-->
</script>

<script type="text/javascript">
/*
sub onShowSubcompany(inputname,spanname)  
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&inputname.value)
	
	if NOT isempty(id) then
	    if id(0)<> "" then        
			resourceids = id(0)
			resourcename = id(1)
			sHtml = ""
			resourceids = Mid(resourceids,2,len(resourceids))
			resourcename = Mid(resourcename,2,len(resourcename))
			inputname.value = resourceids
			while InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
			wend
			sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
			spanname.innerHtml = sHtml     
        else
			spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			inputname.value=""
        end if
	end if
end sub

sub onShowDepartment(inputname,spanname)
    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&inputname.value)
	
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub

sub onShowResource(inputname,spanname)
    linkurl="javaScript:openhrm("
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids+ "); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub


Sub doSave(obj)
    obj.disabled=true
	frmAdd.submit    
End Sub
*/


</SCRIPT>
