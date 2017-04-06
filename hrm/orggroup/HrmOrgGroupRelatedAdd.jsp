<%@ page language="java" contentType="text/html; charset=GBK" %> 

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ include file="/systeminfo/init.jsp" %>

<html>
<HEAD> 
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
if(!HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
    int orgGroupId = Util.getIntValue(request.getParameter("orgGroupId"),0); 
	
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(82,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24662,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>


<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/orggroup/HrmOrgGroupRelated.jsp?orgGroupId="+orgGroupId+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
        <tr style="height:0px">
            <td height="0" colspan="3"></td>
        </tr>
        <tr>
            <td ></td>
            <td valign="top">
                <TABLE class=Shadow>
                    <tr>
                        <td valign="top">  
                            <form name="weaver" method="post">
                              <INPUT TYPE="hidden" NAME="orgGroupId" value="<%=orgGroupId%>">           
                              <INPUT type="hidden" Name="operation" value="addMutil">

                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>                                    

                                    <TR>
                                        <TD><%=SystemEnv.getHtmlLabelName(24663,user.getLanguage())%></TD>
                                            
                                        <TD class="field">
                                            
                                            <SELECT class=InputStyle id="sharetype" name="sharetype" onChange="onChangeSharetype(this)" >   
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            <BUTTON class=Browser type="button" style="display:none" onClick="onShowResource(relatedshareid,showrelatedsharename)" name="showresource" id="showresource"></BUTTON> 
                                            <BUTTON class=Browser type="button" style="display:" onClick="onShowSubcompany('showrelatedsharename','relatedshareid')" name="showsubcompany" id="showsubcompany"></BUTTON> 
                                            <BUTTON class=Browser type="button" style="display:none" onClick="onShowDepartment('relatedshareid','showrelatedsharename')" name="showdepartment" id="showdepartment"></BUTTON>
                                            <BUTTON class=Browser type="button" style="display:none" onClick="onShowRole('showrelatedsharename','relatedshareid')" name="showrole" id="showrole"></BUTTON>
                                            <INPUT type="hidden" name="relatedshareid" id="relatedshareid" value="">
                                            <span id="showrelatedsharename" name="showrelatedsharename"><IMG src='/images/BacoError.gif' align=absMiddle></span>                                            
                                        </TD>		
                                    </TR>
                                    <TR style="height:1px">
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
                                     <TR style="height:1px">
                                        <TD class=Line colSpan=2  id=showrolelevel_line name=showrolelevel_line style="display:none"></TD>
                                     </TR>

                                      <TR  id=showseclevel name=showseclevel style="display:">
                                        <TD>
                                             <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <INPUT type=text name=seclevel class=InputStyle size=6 value="0" onchange='checkinput("seclevel","seclevelimage")' onKeyPress="ItemCount_KeyPress()">
                                             <span id=seclevelimage></span>
											  &nbsp;&nbsp;-&nbsp;&nbsp;
                                             <INPUT type=text name=secLevelTo class=InputStyle size=6 value="100" onchange='checkinput("secLevelTo","secLevelToimage")' onKeyPress="ItemCount_KeyPress()">
                                             <span id=secLevelToimage></span>											  
                                        </td>
                                    </TR>
                                     <TR style="height:1px">
                                        <TD class=Line colSpan=2 id=showseclevel_line name=showseclevel_line style="display:"></TD>
                                     </TR>

                                    <tr>
                                        <TD  colspan=2>
                                           <TABLE  width="100%">
                                            <TR>
                                                <TD width="80%"></TD>
                                                <TD width="20%">
                                                <button class="btnNew" type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addValue()" accesskey="a"><u>A</u>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
                                                </td><td>
                                                <button class="btnDelete" type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeValue()" accesskey="d"><u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
                                                </TD>
                                            </TR>
                                           </TABLE>
                                        </TD>
                                   <TR style="height:1px">
                                        <TD class=Line colSpan=2></TD>
                                   </TR>
                                   <tr>
                                        <td colspan=2>
                                            <table class="listStyle" id="oTable" name="oTable">
                                                <colgroup>
                                                <col width="4%">
                                                <col width="32%">
                                                <col width="32%">
                                                <col width="32%">
                                                <tr class="header">
                                                    <td><input type="checkbox" name="chkAll" onClick="chkAllClick(this)"></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(24663,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(24664,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
                                                </tr>
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
        <tr style="height:0px">
            <td height="0" colspan="3"></td>
        </tr>
        </table>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
<!--

function onChangeSharetype(obj){


	var thisvalue = obj.value;
	jQuery("#relatedshareid").val("");
	jQuery("#showseclevel").show();
  jQuery("#showseclevel_line").show();

	jQuery(showrelatedsharename).html("<IMG src='/images/BacoError.gif' align=absMiddle>");


	if(thisvalue==1){
		jQuery("#showresource").show();
		jQuery("#showseclevel").hide();
		jQuery("#showseclevel_line").hide();
		jQuery("input[name=seclevel]").val(0);
	}else{
		jQuery("#showresource").hide();
	}

	if(thisvalue==2){
 		jQuery("#showsubcompany").show();
 		jQuery("input[name=seclevel]").val(0);
 		jQuery("input[name=seclevelTo]").val(100);
	}else{
		jQuery("#showsubcompany").hide();
		jQuery("input[name=seclevel]").val(0);
 		jQuery("input[name=seclevelTo]").val(100);
	}

	if(thisvalue==3){
 		jQuery("#showdepartment").show();
 		jQuery("input[name=seclevel]").val(0);
 		jQuery("input[name=seclevelTo]").val(100);
	}
	else{
		jQuery("#showdepartment").hide();
		jQuery("input[name=seclevel]").val(0);
 		jQuery("input[name=seclevelTo]").val(100);
	}
	if(thisvalue==4){
 		jQuery("#showrole").show();
		jQuery("#showrolelevel").show();
    jQuery("#showrolelevel_line").show();
    jQuery("#rolelevel").show();
    jQuery("input[name=seclevel]").val(0);
		jQuery("input[name=seclevelTo]").val(100);
	}
	else{
		jQuery("#showrole").hide();
		jQuery("#showrolelevel").hide();
    jQuery("#showrolelevel_line").hide();
    jQuery("#rolelevel").hide();
    jQuery("input[name=seclevel]").val(0);
		jQuery("input[name=seclevelTo]").val(100);
    }
	if(thisvalue==5){
		jQuery(showrelatedsharename).html("");
		jQuery("#relatedshareid").val(-1);
		jQuery("input[name=seclevel]").val(0);
 		jQuery("input[name=seclevelTo]").val(100);
	}
	if(thisvalue<0){
		jQuery(showrelatedsharename).html("");
		jQuery("#relatedshareid").val(-1);
		jQuery("input[name=seclevel]").val(0);
 		jQuery("input[name=seclevelTo]").val(100);
	}
}

function removeValue(){
	try{
		var chks = document.getElementsByName("chkShareDetail");
		for (var i=chks.length-1; i>=0; i--){
			var chk = chks[i];
			//alert(i);
			//alert(chk.value);
			//alert(chk.parentElement.parentElement.parentElement.tagName);
			if (chk.checked){
				oTable.deleteRow(jQuery(chk).parent().parent().parent().index());
			}
		}
	}catch(e){}
	try{
		var chks2 = document.getElementsByName("chkShareDetail2");
		for (var j=chks2.length-1; j>=0; j--){
			var chk2 = chks2[j];
			var delids = document.weaver.delids.value;
			if (chk2.checked){
				//alert(j);
				//alert(chk2.value);
				//alert(chk2.parentElement.parentElement.rowIndex);
				oTable2.deleteRow(jQuery(chk2).parent().parent().index());
				document.weaver.delids.value = delids + chk2.value + ",";
				delids = document.weaver.delids.value;
			}
		}
	}catch(e){}
}

function addValue(){
    thisvalue=jQuery("select[name=sharetype]").val();

   var shareTypeValue = thisvalue;
   var shareTypeText = jQuery("select[name=sharetype] option:selected").html();


    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
    var relatedShareIds="0";
    var relatedShareNames="";
    if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4||thisvalue==9) {
        if(!check_form(document.weaver,'relatedshareid')) {
            return ;
        }
        if (thisvalue==4){
            if (!check_form(document.weaver,'seclevel'))
                return;
        }
        relatedShareIds = jQuery("#relatedshareid").val();
        relatedShareNames= jQuery("#showrelatedsharename").html();
    }

    var secLevelValue="0";
    var secLevelText="";
    if (thisvalue!=1&&thisvalue!=-80&&thisvalue!=-81&&thisvalue!=-82&&thisvalue!=80&&thisvalue!=81&&thisvalue!=82) {
        secLevelValue = jQuery("input[name=seclevel]").val();
        secLevelText=secLevelValue;
    }
    var secLevelValueTo="0";
    var secLevelTextTo="";
    if (thisvalue!=1&&thisvalue!=-80&&thisvalue!=-81&&thisvalue!=-82&&thisvalue!=80&&thisvalue!=81&&thisvalue!=82) {
        secLevelValueTo = jQuery("input[name=secLevelTo]").val();
        secLevelTextTo=secLevelValueTo;
    }

   var rolelevelValue=0;
   var rolelevelText="";
   if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
       rolelevelValue = jQuery("select[name=rolelevel]").val();
       rolelevelText=jQuery("select[name=rolelevel] option:selected").html();
   }

   //共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限
   var totalValue=shareTypeValue+"_"+relatedShareIds+"_"+rolelevelValue+"_"+secLevelValue+"_"+secLevelValueTo;

   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.rowIndex;

   if (oRowIndex%2==0) oRow.className="DataLight";
   else oRow.className="DataDark";

   for (var i =1; i <=4; i++) {   //生成一行中的每一列

      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
      else if (i==2) oDiv.innerHTML=shareTypeText;
      else  if (i==3) oDiv.innerHTML=relatedShareNames;
      else  if (i==4) { oDiv.innerHTML=secLevelText+" - "+secLevelTextTo;}

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
//-->
</SCRIPT>
<script type="text/javascript">
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

function onShowSubcompany(tdname,inputname){
linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
if (data!=null) {
    if (data.id!= "") { 	
    	ids = data.id.split(",");
		names =data.name.split(",");
        sHtml = "";
      	for(var i=0;i<ids.length;i++){
      		if(ids!=""){
            sHtml = sHtml+"<a href=javaScript:openFullWindowHaveBar('"+linkurl+ids[i]+"')>"+names[i]+"</a>&nbsp;";
      		}        
      	}
        jQuery("#"+tdname).html(sHtml);
        jQuery("input[name="+inputname+"]").val(data.id);
        }else{
        	jQuery("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	    jQuery("input[name="+inputname+"]").val("");
	    }
	}
}

function onShowDepartment(inputname,spanname){
	linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data!=null) {
		if (data.id!= "" ) { 	
			ids = data.id.split(",");
			names =data.name.split(",");
			sHtml = "";
			for(var i=0;i<ids.length;i++){
				if(ids!=""){
					sHtml = sHtml+"<a href=javaScript:openFullWindowHaveBar('"+linkurl+ids[i]+"')>"+names[i]+"</a>&nbsp;";
				}
			}
			jQuery("#"+spanname).html(sHtml);
			jQuery("input[name="+inputname+"]").val(data.id);
		}else{
			jQuery("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name="+inputname+"]").val("");
		}
	}
}

function doSave(obj){
    obj.disabled=true;
    document.weaver.action="/hrm/orggroup/HrmOrgGroupRelatedOperation.jsp?orgGroupId=<%=orgGroupId%>";
	document.weaver.submit();
}
</script>
<!--
<SCRIPT language=VBS>

sub onShowResource(inputname,spanname)
    linkurl="/hrm/resource/HrmResource.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
    if (Not IsEmpty(id)) then
	    'if id(0)<> "" then
	    if id(0)<> "" and  id(0)<> "0" then
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
    	    'inputname.value="0"
    	    inputname.value=""
	    end if
    end if
end sub


sub onShowRole(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	    'if id(0)<> "" then
	    if id(0)<> "" and id(0)<> "0" then
		    document.getElementById(tdname).innerHtml = id(1)
		    document.getElementById(inputename).value=id(0)
		else
		    document.getElementById(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		    document.getElementById(inputename).value=""
		end if
	end if
end sub





</SCRIPT>
-->
