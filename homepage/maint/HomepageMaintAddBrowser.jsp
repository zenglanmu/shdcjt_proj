<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="hpc" class= "weaver.page.PageCominfo" scope="page" />
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
                            <form name="frmAdd" method="post" action="HomepageMaintOperate.jsp">
                              <INPUT TYPE="hidden" NAME="hpid" value="<%=hpid%>">           
                              <INPUT type="hidden" Name="method" value="addMaint">
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
                                            <%=SystemEnv.getHtmlLabelName(19909,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                            
                                            <SELECT class=InputStyle  name=mainttype id="mainttype" onchange="onChangeMainttype(this,relatedmaintid,showrelatedmaintname)" >   
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> 
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            
											<button type="button" class=Browser id="btnRelatedHrm" style="display:''" onClick="onShowResource(relatedmaintid,showrelatedmaintname)" name="btnRelatedHrm"></BUTTON> 

											<button type="button" class=Browser id="btnRelatedSubcompany" style="display:none"  onClick="onShowSubcompany(relatedmaintid,showrelatedmaintname)" name="btnRelatedSubcompany"></BUTTON> 

											<button type="button" class=Browser id="btnRelatedDepartment" style="display:none"  onClick="onShowDepartment(relatedmaintid,showrelatedmaintname)" name="btnRelatedAll"></BUTTON> 
                                            
											<INPUT type=hidden name="relatedmaintid"  id="relatedmaintid" value="">
                                            <span id="showrelatedmaintname" name="showrelatedmaintname">
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
                                                <tr class=line><td colspan=6  style="padding:0;"></td></tr>
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

  function onChangeMainttype(seleObj,txtObj,spanObj){
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
    var chks = document.getElementsByName("chkMaintDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
    }
}

function addValue(){
   var thisvalue=document.getElementById("mainttype").value;

   var maintTypeValue = thisvalue;
   var mainType=$("#mainttype")[0];
   var maintTypeText = $(mainType.options[mainType.selectedIndex]).text();


    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
    var relatedMaintIds="0";
    var relatedMaintNames="";
    if (thisvalue==1 || thisvalue==2 || thisvalue==3) {
        if(!check_form(document.frmAdd,'relatedmaintid')) {
            return ;
        }
        relatedMaintIds = document.all("relatedmaintid").value;
        relatedMaintNames= document.all("showrelatedmaintname").innerHTML;
    }

   //共享类型 + 共享者ID
   var totalValue=maintTypeValue+"_"+relatedMaintIds
   if(thisvalue==5) relatedMaintNames=maintTypeText;  //所有人

   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.rowIndex;

   if (oRowIndex%2==0) oRow.className="dataLight";
   else oRow.className="dataDark";
	//alert(relatedMaintIds);
   for (var i =1; i <=3; i++) {   //生成一行中的每一列
      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkMaintDetail' value='"+totalValue+"'><input type='hidden' name='txtMaintDetail' value='"+relatedMaintIds+"'>";
      else if (i==2) oDiv.innerHTML=maintTypeText;
	  else if (i==3) oDiv.innerHTML=relatedMaintNames;
      oCell.appendChild(oDiv);
   }
}

function chkAllClick(obj){
	 var chkboxElems= document.getElementsByName("chkMaintDetail");
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

function onShowSubcompany(inputname,spanname){  
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&inputname.value)

	if(datas){
	    if(datas.id){       
			resourceids = datas.id;
			resourcename = datas.name;
			sHtml = ""
			resourceids =resourceids.substr(1);
			resourcenames = resourcename.substr(1);
			var resourceidsAray=resourceids.split(",");
			var resourcenamesArray=resourcenames.split(",");
			for(var i=0;i<resourceidsAray.length;i++){
				sHtml+="<a href="+linkurl+resourceidsAray[i]+">"+resourcenamesArray[i]+"</a>&nbsp";
			}
			$(spanname).html(sHtml) ;
			$(inputname).val(resourceids);
	    }else{
			$(spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			$(inputname).val("");
	    }
	}
}

function onShowDepartment(inputname,spanname){
    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&inputname.value)
	if(datas){
	    if(datas.id){       
			resourceids = datas.id;
			resourcename = datas.name;
			sHtml = ""
			resourceids =resourceids.substr(1);
			resourcenames = resourcename.substr(1);
			var resourceidsAray=resourceids.split(",");
			var resourcenamesArray=resourcenames.split(",");
			for(var i=0;i<resourceidsAray.length;i++){
				sHtml+="<a href="+linkurl+resourceidsAray[i]+">"+resourcenamesArray[i]+"</a>&nbsp";
			}
			$(spanname).html(sHtml) ;
			$(inputname).val(resourceids);
	    }else{
			$(spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			$(inputname).val("");
	    }
	}
}

function onShowResource(inputname,spanname){
    linkurl="javaScript:openhrm("
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if(datas){
	    if(datas.id){       
			resourceids = datas.id;
			resourcename = datas.name;
			sHtml = ""
			resourceids =resourceids.substr(1);
			resourcenames = resourcename.substr(1);
			var resourceidsAray=resourceids.split(",");
			var resourcenamesArray=resourcenames.split(",");
			for(var i=0;i<resourceidsAray.length;i++){
				sHtml+="<a href="+linkurl+resourceidsAray[i]+">"+resourcenamesArray[i]+"</a>&nbsp";
			}
			$(spanname).html(sHtml) ;
			$(inputname).val(resourceids);
	    }else{
			$(spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			$(inputname).val("");
	    }
	}
}


function doSave(obj){
    obj.disabled=true;
	frmAdd.submit();    
}

//-->
</SCRIPT>


