<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
int id = Util.getIntValue(request.getParameter("id"),0);

String imagefilename = "/images/hdCRMAccount.gif";
String titlename = SystemEnv.getHtmlLabelName(1442,user.getLanguage())+
"-"+SystemEnv.getHtmlLabelName(119,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",ReportEdit.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=weaver action="ReportShareOperation.jsp" method=post onsubmit='return check_form(this,"")'>
<input type="hidden" name="method" value="add">
<input type="hidden" name="reportid" value="<%=id%>">



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

	  <TABLE class="viewform">
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class="Title">
            <TH colSpan=2></TH>
          </TR>
        <TR>
          <TD class=field>
			  <select class=inputstyle  name=sharetype onchange="onChangeSharetype()" >
				  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				  <!-- option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/option -->
				  <option value="3" selected="selected"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				  <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
 			  </SELECT>
		  </TD>
          <TD class=field >
			
			 <INPUT type="hidden" class="wuiBrowser" name="relatedshareid" id="relatedshareid" value="" _url="" _required="yes">
			 
			<span id=showrolelevel name=showrolelevel style="visibility:hidden">
			&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
			<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
			<select class=inputstyle  name=rolelevel  >
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</SELECT>
			</span>
			&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
			<span id=showseclevel name=showseclevel>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
			<INPUT type=text class="InputStyle" name=seclevel size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' >
			</span>
			<SPAN id=seclevelimage></SPAN>
		  </TD>		
		</TR>
		<TR style="height:1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
          <TD class=field>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<select class=inputstyle  name=sharelevel onchange="onChangeShareLevel(event)">
			  <option value="4"><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(18511,user.getLanguage())%></option>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(18512,user.getLanguage())%></option>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
              <!--add by xhheng @20050126 for TD 1614-->
              <option value="3"><%=SystemEnv.getHtmlLabelName(18513,user.getLanguage())%></option>
              <option value="9"><%=SystemEnv.getHtmlLabelName(17006,user.getLanguage())%></option>
			</SELECT>
            &nbsp;&nbsp;
           <INPUT type=hidden name="departmentids" id="departmentids" value="" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" _required="yes" _initEnd="onChangeShareLevel">
             </TD>
		</TR>
<TR style="height:1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
		</TBODY>
	  </TABLE>
	</form>  
<!--原有共享-->
        <table class="viewform">
          <colgroup> 
          <col width="30%"> 
          <col width="50%">
          <col width="20%">
          <tr class="Title"> 
            <th colspan=3><%=SystemEnv.getHtmlLabelName(1442,user.getLanguage())%></th>
          <tr class="Spacing" style="height:1px;"> 
            <td class="Line1" colspan=3></td>
          </tr>
<%
	//查找已经添加的共享
	RecordSet.executeProc("WorkflowReportShare_SByReport",""+id);
	while(RecordSet.next()){
		String tempsharelevel = "" ;
		if(RecordSet.getInt("sharelevel")==4) tempsharelevel = SystemEnv.getHtmlLabelName(6087,user.getLanguage()) ;
		if(RecordSet.getInt("sharelevel")==0) tempsharelevel = SystemEnv.getHtmlLabelName(18511,user.getLanguage()) ;
		if(RecordSet.getInt("sharelevel")==1) tempsharelevel = SystemEnv.getHtmlLabelName(18512,user.getLanguage()) ;
		if(RecordSet.getInt("sharelevel")==2) tempsharelevel = SystemEnv.getHtmlLabelName(140,user.getLanguage()) ;
    //add by xhheng @20050126 for TD 1614
    if(RecordSet.getInt("sharelevel")==3) tempsharelevel = SystemEnv.getHtmlLabelName(18513,user.getLanguage()) ;
        if(RecordSet.getInt("sharelevel")==9){
            String deptnames="";
            ArrayList tempdepts=Util.TokenizerString(RecordSet.getString("mutidepartmentid"),",");
            for(int i=0;i<tempdepts.size();i++){
                int deptidtemp=Util.getIntValue((String)tempdepts.get(i));
                if(deptidtemp>0)
                deptnames+=DepartmentComInfo.getDepartmentname(""+deptidtemp)+",";
            }
            if(deptnames.length()>0){
                deptnames=deptnames.substring(0,deptnames.length()-1);
            }
            tempsharelevel = SystemEnv.getHtmlLabelName(17006,user.getLanguage())+"("+deptnames+")";
        }
        if(RecordSet.getInt("sharetype")==1){%>
	        <TR>
	          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD class=Field>
				<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("userid")%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>:<%=tempsharelevel%>
			  </TD>
			  <TD class=Field align=right>
				<a href="ReportShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&reportid=<%=id%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			  </TD>
	        </TR>  <tr class="Spacing" style="height:1px;"> 
            <td class="Line" colspan=3></td>
          </tr>
			
	    <%}else if(RecordSet.getInt("sharetype")==2){%>
	        <TR>
	          <TD<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/TD>
			  <TD class=Field>
				<a href="/hrm/company/HrmSubCompanyDsp.jsp?id=<%=RecordSet.getString("subcompanyid")%>" target="_blank"><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>:<%=tempsharelevel%>
			  </TD>
			  <TD class=Field align=right>
				<a href="ReportShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&reportid=<%=id%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			  </TD>
	        </TR> <tr class="Spacing" style="height:1px;"> 
            <td class="Line" colspan=3></td>
          </tr>
		<%}else if(RecordSet.getInt("sharetype")==3)	{%>
	        <TR>
	          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD class=Field>
				<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>:<%=tempsharelevel%>
			  </TD>
			  <TD class=Field align=right>
				<a href="ReportShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&reportid=<%=id%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			  </TD>
	        </TR> <tr class="Spacing" style="height:1px;"> 
            <td class="Line" colspan=3></td>
          </tr>
		<%}else if(RecordSet.getInt("sharetype")==4)	{%>
	        <TR>
	          <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
			  <TD class=Field>
			    <%
			    	RecordSet1.executeSql("select rolesmark from hrmroles where id = "+RecordSet.getString("roleid"));
					RecordSet1.next();
			    %>
				<%=Util.toScreen(RecordSet1.getString(1),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>:<%=tempsharelevel%>
			  </TD>
			  <TD class=Field align=right>
				<a href="ReportShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&reportid=<%=id%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			  </TD>
	        </TR> <tr class="Spacing" style="height:1px;"> 
            <td class="Line" colspan=3></td>
          </tr>
		<%}else if(RecordSet.getInt("sharetype")==5)	{%>
	        <TR>
	          <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>:<%=tempsharelevel%>
			  </TD>
			  <TD class=Field align=right>
				<a href="ReportShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&reportid=<%=id%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			  </TD>
	        </TR> <tr class="Spacing" style="height:1px;"> 
            <td class="Line" colspan=3></td>
          </tr>
	    <%}}%>
        </table>

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
function doSave(obj) {
thisvalue=document.weaver.sharetype.value;
levelsvalue=document.weaver.sharelevel.value;
var checkstr="";
if (thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){
        if(levelsvalue==9){
           checkstr="relatedshareid,departmentids";
        }else{
            checkstr="relatedshareid";
        }
}

if(check_form(document.weaver,checkstr)){
document.weaver.submit();
obj.disabled=true;
}
}
</script>

<script language=javascript>
$(function(){

	onChangeSharetype();
});
function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
		document.weaver.relatedshareid.value="";
		$("#relatedshareidSpan").html("<img align=\"absMiddle\" src=\"/images/BacoError.gif\">");
		document.all("showseclevel").style.display='';
	if(thisvalue==1){
		document.all("showseclevel").style.display='none';
		$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
		//TD33012 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存
		seclevelimage.innerHTML = ""
		if(document.all("seclevel").value==""){
			document.all("seclevel").value=10;
		}
		//End TD33012
	}
	if(thisvalue==2){
		document.weaver.seclevel.value=10;
		$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
		
	}
	else{
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==3){
		document.weaver.seclevel.value=10;
		$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
	}
	else{
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==4){
		document.all("showrolelevel").style.visibility='visible';
		$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
		document.weaver.seclevel.value=10;
	}
	else{
		document.all("showrolelevel").style.visibility='hidden';
		document.weaver.seclevel.value=10;
  	}
	if(thisvalue==5){
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=10;
		$("#relatedshareidBtn").hide();
		$("#relatedshareidSpan").hide();
	}else{
		$("#relatedshareidBtn").show();
		$("#relatedshareidSpan").show();
	}
	if(thisvalue<0){
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=0;
	}
}

function onChangeShareLevel(e){
	thisvalue=document.weaver.sharelevel.value;
	document.weaver.departmentids.value="";
	if(thisvalue==9){
        $("#departmentids").prev().show();
        $("#departmentids").next().show();
    }
	else{
		$("#departmentids").next().hide();
        $("#departmentids").prev().hide();
    }
}
</script>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'PrjName,PrjType,WorkType,hrmids02,SecuLevel,PrjManager,PrjDept'))
		weaver.submit();
}
</script>
</BODY>
</HTML>
