<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
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

String customerids = Util.null2String(request.getParameter("customerids"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(17221,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2112,user.getLanguage());
String needfav ="1";
String needhelp ="";
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
	<td height="10" colspan="3" style="padding: "></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=weaver name=weaver action="ShareMutiCustomerOperation.jsp" method=post >
<input type="hidden" name="customerids" value="<%=customerids%>">
<input type="hidden" name="rownum" value="">


	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD class=field>
 <%
    String isdisable = "";
    if(!canEdit) isdisable ="disabled";
%>
  <SELECT class=InputStyle  name=sharetype onchange="onChangeSharetype()" <%=isdisable%>>
  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
</SELECT>
		  </TD>
	 <%
                String ordisplay="";
                if(!canEdit) ordisplay = " style='display:none' ";
                %>
          <TD class=field <%=ordisplay%>>
<BUTTON type="button" class=Browser style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON>
<BUTTON type="button" class=Browser style="display:none" onClick="onShowSubcompany('showrelatedsharename','relatedshareid')" name=showsubcompany></BUTTON>
<BUTTON type="button" class=Browser style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON>
<BUTTON type="button" class=Browser style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
 <INPUT type=hidden name=relatedshareid value="">
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

<TR style="height: 1px">
	<TD class=Line colSpan=2></TD>
</TR>
       <tr>
          <TD class=field>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<SELECT class=InputStyle  name=sharelevel <%=isdisable%>>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
		  </TD>
		</TR>

<TR style="height: 1px">
	<TD class=Line colSpan=2></TD>
</TR>

		</TBODY>
	  </TABLE>
<BUTTON Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%></BUTTON>
<BUTTON Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRow();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%></BUTTON>
<!--默认共享-->
        <TABLE class=ListStyle cellspacing="1"  id=oTable>
          <colgroup>
          <col width="5%">
          <col width="20%">
          <col width="75%">
          <tr class=header >
            <td colspan=3><%=SystemEnv.getHtmlLabelName(21443,user.getLanguage())%></td></tr>
  <TR class=Line style="height: 1px"><TD colspan="3" ></TD></TR>

        </table>
</form>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3" style="padding: 0"></td>
</tr>
</table>
<script language=javascript>
function doShare(obj) {
    document.all("rownum").value=curindex;
    obj.disabled=true;
    weaver.submit();
}
</script>
<script language="JavaScript" src="/js/addRowBg.js"></script>
<script language="javascript">
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
		document.weaver.relatedshareid.value="";
	$("#showseclevel").hide();

	$("#showrelatedsharename").html( "<IMG src='/images/BacoError.gif' align=absMiddle>");

	if(thisvalue==1){
 		$("button[name=showresource]").show();
		$("#showseclevel").hide();
	}
	else{
		$("button[name=showresource]").hide();
	}
	if(thisvalue==2){
 		$("button[name=showdepartment]").show();
 		document.weaver.seclevel.value=10;
	}
	else{
		$("button[name=showdepartment]").hide();
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==3){
 		$("button[name=showrole]").show();
		$("#showrolelevel").css("visibility",'visible');
		document.weaver.seclevel.value=10;
	}
	else{
		$("button[name=showrole]").hide();
		$("#showrolelevel").css("visibility",'hidden');
		document.weaver.seclevel.value=10;
    }
	if(thisvalue==4){
		$("#showrelatedsharename").empty();
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=10;
	}
	if(thisvalue<0){
		$("#showrelatedsharename").empty();
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=0;
	}
}

function checkValid(){
    if(document.all("seclevel").value==""&&document.all("showseclevel").style.display!="none"){
    	alert("<%=SystemEnv.getHtmlLabelName(23251,user.getLanguage())%>");
        return false;
    }
    if(document.all("relatedshareid").value==""){
    	alert("<%=SystemEnv.getHtmlLabelName(23252,user.getLanguage())%>");
        return false;
    }
    return true;
}

var curindex=0;
function addRow(){
    if(!checkValid()){
        return;
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
	sHtml = document.all("sharetype").options[document.all("sharetype").selectedIndex].text;
	sHtml += "<input type='hidden' name='sharetype_"+curindex+"' value='"+document.all("sharetype").value+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);


    oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    oDiv = document.createElement("div");
    sHtml = document.all("showrelatedsharename").innerHTML;
    sHtml += "<input type='hidden' name='relatedshareid_"+curindex+"' value='"+document.all("relatedshareid").value+"'>";

    if(document.all("showrolelevel").style.visibility!="hidden"){
        sHtml += "/"+document.all("rolelevel").options[document.all("rolelevel").selectedIndex].text;
    }
    sHtml += "<input type='hidden' name='rolelevel_"+curindex+"' value='"+document.all("rolelevel").value+"'>";

    if(document.all("showseclevel").style.display!="none"){
        sHtml += "<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:"+document.all("seclevel").value;
    }
    sHtml += "<input type='hidden' name='seclevel_"+curindex+"' value='"+document.all("seclevel").value+"'>";

    sHtml += "/"+document.all("sharelevel").options[document.all("sharelevel").selectedIndex].text;
    sHtml += "<input type='hidden' name='sharelevel_"+curindex+"' value='"+document.all("sharelevel").value+"'>";

    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    curindex++;
}

function deleteRow()
{
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
				oTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

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

function onShowResource(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
		if(data.id!=""){
			document.all(tdname).innerHTML = data.name
			document.all(inputename).value=data.id
		}else{
			document.all(tdname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			document.all(inputename).value=""
		}
	}
}
function onShowDepartment(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+document.all(inputename).value,
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
		if(data.id!="0"){
			document.all(tdname).innerHTML = data.name
			document.all(inputename).value=data.id
		}else{
			document.all(tdname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			document.all(inputename).value=""
		}
	}
}

function onShowSubcompany(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+document.all(inputename).value,
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
		if(data.id!="0"){
			document.all(tdname).innerHTML = data.name
			document.all(inputename).value=data.id
		}else{
			document.all(tdname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			document.all(inputename).value=""
		}
	}
}

function onShowRole(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
		if(data.id!="0"){
			document.all(tdname).innerHTML = data.name
			document.all(inputename).value=data.id
		}else{
			document.all(tdname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			document.all(inputename).value=""
		}
	}
}

</script>
</BODY>
</HTML>
