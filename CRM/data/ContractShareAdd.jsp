<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>

<%
String customername = Util.null2String(request.getParameter("customername"));
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String contractId = Util.null2String(request.getParameter("contractId"));


/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
boolean canedit=false;
boolean canview=false;
boolean canedit_share=false;

String ViewSql="select sharelevel from ContractShareDetail where contractid="+contractId+" and usertype=1 and userid="+user.getUID();

RecordSet.executeSql(ViewSql);

while(RecordSet.next())
{
	 canview=true;
	 if(RecordSet.getString("sharelevel").equals("2")){
		canedit=true;	
		canedit_share=true;	
	 }else if (RecordSet.getString("sharelevel").equals("3") || RecordSet.getString("sharelevel").equals("4")){
		canedit=true;
		canedit_share=true;	
	 }
}

if (!canview) response.sendRedirect("/notice/noright.jsp") ;
/*check right end*/
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+" - "+"<a href=/CRM/data/ContractView.jsp?id="+contractId+"&CustomerID="+CustomerID+">"+ContractComInfo.getContractname(contractId)+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<FORM id=weaver name=weaver action="/CRM/data/ContractShareOperation.jsp" method=post >
<input type="hidden" name="method" value="add">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="contractId" value="<%=contractId%>">


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
<SELECT name=sharetype onchange="onChangeSharetype()">
  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
</SELECT>
		  </TD>
          <TD class=field>
<BUTTON class=Browser type="button" style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
<BUTTON class=Browser type="button" style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
<BUTTON class=Browser type="button" style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
 <INPUT type=hidden name=relatedshareid value="<%=user.getUserDepartment()%>">
 <span id=showrelatedsharename name=showrelatedsharename ><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span>
<span id=showrolelevel name=showrolelevel style="visibility:hidden">
<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
<SELECT name=rolelevel>
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
		</TR>
          <TD class=field>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<SELECT name=sharelevel>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
		  </TD>		
		</TR>

		</TBODY>
	  </TABLE>



<!--共享信息begin-->
<%
RecordSetShare.executeProc("Contract_ShareInfo_SByCID",contractId);
%>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="70%">
  		<COL width="10%">
        <TBODY>
       
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=3></TD></TR>
<%
if(RecordSetShare.first()){
do{
	if(RecordSetShare.getInt("sharetype")==1)	{
%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field align =right>
			<%if(canedit_share){%>
			<a href='/CRM/data/ContractShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&contractId=<%=contractId%>&CustomerID=<%=CustomerID%>' onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			<%}%>
		  </TD>
        </TR>
	<%}else if(RecordSetShare.getInt("sharetype")==2)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field align =right>
			<%if(canedit_share){%>
			<a href='/CRM/data/ContractShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&contractId=<%=contractId%>&CustomerID=<%=CustomerID%>'  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			<%}%>
		  </TD>
        </TR>
	<%}else if(RecordSetShare.getInt("sharetype")==3)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(RolesComInfo.getRolesname(RecordSetShare.getString("roleid")),user.getLanguage())%>/<% if(RecordSetShare.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			<% if(RecordSetShare.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			<% if(RecordSetShare.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field align =right>
			<%if(canedit_share){%>
			<a href='/CRM/data/ContractShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&contractId=<%=contractId%>&CustomerID=<%=CustomerID%>'  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			<%}%>
		  </TD>
        </TR>
	<%}else if(RecordSetShare.getInt("sharetype")==4)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field align =right>
			<%if(canedit_share){%>
			<a href='/CRM/data/ContractShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&contractId=<%=contractId%>&CustomerID=<%=CustomerID%>'  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			<%}%>
		  </TD>
        </TR>
	<%}%>
 <%}while(RecordSetShare.next());
}			
%>
        </TBODY>
	  </TABLE>


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
	thisvalue=document.weaver.sharetype.value
	document.weaver.relatedshareid.value=""
	$G("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"

	if(thisvalue==1){
 		$G("showresource").style.display='';
		$G("showseclevel").style.display='none';
	}
	else{
		$G("showresource").style.display='none';
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

function doSave(){
	var parastr = "contractId,relatedshareid,sharetype,rolelevel,seclevel,sharelevel" ;	
	if(check_form(document.weaver,parastr)){
		
		document.weaver.submit();
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

</BODY>
</HTML>
