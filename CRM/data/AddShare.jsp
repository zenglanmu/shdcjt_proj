<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
String customername = Util.null2String(request.getParameter("customername"));
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String itemtype = Util.null2String(request.getParameter("itemtype"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();

/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSet.getString("department") ;
boolean canedit=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype=1 and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 if(RecordSetV.getString("sharelevel").equals("2") || RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;	
//	 }
//}
int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>1) canedit=true;

if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
	canedit=false;
}

/*权限判断－－End*/

if(!canedit) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'itemtype,CustomerID,relatedshareid,sharetype,rolelevel,seclevel,sharelevel')){
        weaver.submit();
    }
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID+"'>"+Util.toScreen(customername,user.getLanguage(),"0")+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if(!isfromtab){ %>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isfromtab){
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID+"',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
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

<FORM id=weaver name=weaver action="/CRM/data/ShareOperation.jsp" method=post onsubmit='return check_form(this,"itemtype,CustomerID,relatedshareid,sharetype,rolelevel,seclevel,sharelevel")'>
<input type="hidden" name="method" value="add">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="itemtype" value="<%=itemtype%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab %>">
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
<SELECT  class=InputStyle name=sharetype onchange="onChangeSharetype()">
  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
</SELECT>
		  </TD>
          <TD class=field>
<BUTTON type="button" class=Browser style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
<BUTTON type="button" class=Browser style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
<BUTTON type="button" class=Browser style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
 <%
 	if(user.getUserDepartment()!=0){
 %>
 <INPUT type=hidden name=relatedshareid value="<%=user.getUserDepartment()%>">
 <span id=showrelatedsharename name=showrelatedsharename ><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span>
 <%
 	}else{
 		%>
 <INPUT type=hidden name=relatedshareid value="">
 <span id=showrelatedsharename name=showrelatedsharename ><IMG src='/images/BacoError.gif' align=absMiddle></span>
 		
 		<%
 	}
 %>
<span id=showrolelevel name=showrolelevel style="visibility:hidden">
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
<SELECT class=InputStyle  name=rolelevel>
  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
</SELECT>
</span>
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<span id=showseclevel name=showseclevel>
<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
<INPUT class=InputStyle maxLength=3 size=5 
            name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10">
</span>
<SPAN id=seclevelimage></SPAN>

		  </TD>		
		</TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
          <TD class=field>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<SELECT class=InputStyle  name=sharelevel>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
		  </TD>		
		</TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>

		</TBODY>
	  </TABLE>

<script language=javascript>
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value
	document.weaver.relatedshareid.value=""
	document.all("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"

	if(thisvalue==1){
 		$G("showresource").style.display='';
		$G("showseclevel").style.display='none';
		if(trim($G("seclevel").value)==''){
			$Gl("seclevel").value='10';
		}
        $G("seclevelimage").innerHTML='';
	}
	else{
		$G("showresource").style.display='none';
		checkinput("seclevel","seclevelimage");
	}
	if(thisvalue==2){
 		$G("showdepartment").style.display='';
	}
	else{
		$G("showdepartment").style.display='none';
	}
	if(thisvalue==3){
 		$G("showrole").style.display='';
		$G("showrolelevel").style.visibility='visible';
	}
	else{
		$G("showrole").style.display='none';
		$G("showrolelevel").style.visibility='hidden';
    }
	if(thisvalue==4){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value="-1"
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
function onShowDepartment(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+document.all(inputename).value,
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
	    if(data.id!=""&&data.name!="0"){
		    document.all(tdname).innerHTML = data.name
		    document.all(inputename).value=data.id
	    }else{
		    document.all(tdname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		    document.all(inputename).value=""
	    }
	}
}
function onShowResource(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
	    if(data.id!=""&&data.name!="0"){
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
	    if(data.id!=""&&data.name!="0"){
		    document.all(tdname).innerHTML = data.name
		    document.all(inputename).value=data.id
	    }else{
		    document.all(tdname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		    document.all(inputename).value=""
	    }
	}
}
</script>

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
