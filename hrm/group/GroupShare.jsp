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
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<%
int groupid = Util.getIntValue(request.getParameter("groupid"));
String groupname=Util.null2String(request.getParameter("name"));

%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(17617,user.getLanguage())+
"-"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+
": <a href='HrmGroupDetail.jsp?id="+groupid+"'>"+ groupname + "</a>";
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location.href='HrmGroup.jsp',_top} " ;
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

<FORM id=weaver name=weaver action="GroupShareOperation.jsp" method=post onsubmit='return check_form(this,"userid,subcompanyid,departmentid,roleid,sharetype,rolelevel,seclevel,sharelevel")'>
<input type="hidden" name="method" value="add">
<input type="hidden" name="groupid" value="<%=groupid%>">


	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD class=field>
 <%
    String isdisable = "";
    if(!canEdit) isdisable ="disabled";
%>
  <SELECT class=InputStyle  name=sharetype onchange="onChangeSharetype()" <%=isdisable%>>
  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
  <!-- option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/option -->
  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
  <option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
 <%while(CustomerTypeComInfo.next()){
	String curid=CustomerTypeComInfo.getCustomerTypeid();
	String curname=CustomerTypeComInfo.getCustomerTypename();
	String optionvalue="-"+curid;
%>
	<option value="<%=optionvalue%>"><%=Util.toScreen(curname,user.getLanguage())%></option>
<%
}%>
</SELECT>
		  </TD>
	 <%
                String ordisplay="";
                if(!canEdit) ordisplay = " style='display:none' ";
                %>
          <TD class=field <%=ordisplay%>>
<BUTTON class=Browser style="display:none" onClick="onShowResourceMutil('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
<BUTTON class=Browser style="display:none" onClick="onShowSubcompany('showrelatedsharename','relatedshareid')" name=showsubcompany></BUTTON> 
<BUTTON class=Browser style="display:''" onClick="onShowDepartmentMutil('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
<BUTTON class=Browser style="display:none" onclick="onShowRoleMutil('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
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

<TR>
	<TD class=Line colSpan=2></TD>
</TR>



		</TBODY>
	  </TABLE>
	  
<!--默认共享-->
        <TABLE class=ListStyle cellspacing="1" >
          <colgroup> 
          <col width="20%"> 
          <col width="60%">
          <col width="20%">
          <tr class=header > 
            <td colspan=3><%=SystemEnv.getHtmlLabelName(17617,user.getLanguage())+SystemEnv.getHtmlLabelName(119,user.getLanguage())%></td></tr>
  <TR class=Line><TD colspan="3" ></TD></TR>

<%
	//查找已经添加的默认共享
    int i=2;
	RecordSet=GroupAction.getShare(groupid);
	while(RecordSet.next()){
        i++;
        //System.out.println(RecordSet.getInt("sharetype"));
        if(i%2==0){
                
		if(RecordSet.getInt("sharetype")==1){%>
	        <TR  class=datalight>
	          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
                                <%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
			  </TD>
	        </TR>
	    <%}else if(RecordSet.getInt("sharetype")==2){%>
	        <TR  class=datalight>
	          <TD<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/TD>
			  <TD class=Field>
				<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
                               <%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
			  </TD>
	        </TR>
		<%}else if(RecordSet.getInt("sharetype")==3)	{%>
	        <TR  class=datalight>
	                  <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<%if(canEdit){%>
				
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
			  </TD>
	        </TR>
		<%}else if(RecordSet.getInt("sharetype")==4)	{%>
	        <TR  class=datalight>
	          <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(RolesComInfo.getRolesname(RecordSet.getString("roleid")),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>">
			     <%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
				<%}%>
			  </TD>
	        </TR>
		<%}else if(RecordSet.getInt("sharetype")==5)	{%>
	        <TR  class=datalight>
	          <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
			  </TD>
	        </TR>
	    <%}else if(RecordSet.getInt("sharetype")<0)	{
	    		String crmtype= "" + ((-1)*RecordSet.getInt("sharetype")) ;
	    		String crmtypename=CustomerTypeComInfo.getCustomerTypename(crmtype);
	    		%>
	        <TR  class=datalight>
	          <TD><%=Util.toScreen(crmtypename,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
			  </TD>
	        </TR>

         
<%          }
        }else{
%>
    <% if(RecordSet.getInt("sharetype")==1){%>
	        <TR class=datadark>
	          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
			  </TD>
	        </TR>
	    <%}else if(RecordSet.getInt("sharetype")==2){%>
	        <TR class=datadark>
	          <TD<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/TD>
			  <TD class=Field>
				<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
			  </TD>
	        </TR>
		<%}else if(RecordSet.getInt("sharetype")==3)	{%>
	        <TR class=datadark>
	          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
			  </TD>
	        </TR>
		<%}else if(RecordSet.getInt("sharetype")==4)	{%>
	        <TR class=datadark>
	          <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(RolesComInfo.getRolesname(RecordSet.getString("roleid")),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>">
			     <%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
				<%}%>
			  </TD>
	        </TR>
		<%}else if(RecordSet.getInt("sharetype")==5)	{%>
	        <TR class=datadark>
	          <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
			  </TD>
	        </TR>
	    <%}else if(RecordSet.getInt("sharetype")<0)	{
	    		String crmtype= "" + ((-1)*RecordSet.getInt("sharetype")) ;
	    		String crmtypename=CustomerTypeComInfo.getCustomerTypename(crmtype);
	    		%>
	        <TR class=datadark>
	          <TD><%=Util.toScreen(crmtypename,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<%if(canEdit){%>
				<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
			  </TD>
	        </TR>
<%
        }
    }
}
%>
        </table>
      </TD></TR>
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
function doSave() {
thisvalue=document.weaver.sharetype.value;
if (thisvalue==1)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==2)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==3)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==4)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else
	document.weaver.submit();
}
</script>

<script language=javascript>
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
		document.weaver.relatedshareid.value="";
	document.all("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"

	if(thisvalue==1){
 		document.all("showresource").style.display='';
		document.all("showseclevel").style.display='none';
	}
	else{
		document.all("showresource").style.display='none';
	}
	if(thisvalue==2){
 		document.all("showsubcompany").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		document.all("showsubcompany").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==3){
 		document.all("showdepartment").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		document.all("showdepartment").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==4){
 		document.all("showrole").style.display='';
		document.all("showrolelevel").style.visibility='visible';
		document.weaver.seclevel.value=10;
	}
	else{
		document.all("showrole").style.display='none';
		document.all("showrolelevel").style.visibility='hidden';
		document.weaver.seclevel.value=10;
    }
	if(thisvalue==5){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=10;
	}
	if(thisvalue<0){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=0;
	}
}
function onShowResourceMutil(spanname, inputname) {
    tmpids = document.all(inputname).value;
    if(tmpids!="-1"){ 
     url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
    }else{
     url="/hrm/resource/MutiResourceBrowser.jsp";
    }
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1].substring(1);
            document.all(inputname).value = jsid[0].substring(1);
        } else {
            document.all(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            document.all(inputname).value = "";
        }
    }
}
function onShowDepartmentMutil(spanname, inputname) {
    
    url=escape("/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+document.all(inputname).value);
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1].substring(1);
            document.all(inputname).value = jsid[0].substring(1);
        }else {
            document.all(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            document.all(inputname).value = "";
        }
    }
}
function onShowRoleMutil(spanname, inputname){
    tmpids = document.all(inputname).value;
    if(tmpids!="-1"){ 
      url=escape("/hrm/roles/MutiRolesBrowser.jsp?resourceids="+tmpids);
    }else{
      url=escape("/hrm/roles/MutiRolesBrowser.jsp");
    }
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1].substring(1);
            document.all(inputname).value = jsid[0].substring(1);
        }else {
            document.all(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            document.all(inputname).value = "";
        }
    }
}
</script>

<SCRIPT language=VBS>
sub onShowDepartment(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	        if id(0)<> "0" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowSubcompany(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowResource(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowRole(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

</SCRIPT>
</BODY>
</HTML>
