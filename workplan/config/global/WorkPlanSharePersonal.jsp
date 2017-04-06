<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%

String imagefilename = "/images/hdCRMAccount.gif";
String titlename = SystemEnv.getHtmlLabelName(2211,user.getLanguage())+
"-"+SystemEnv.getHtmlLabelName(2112,user.getLanguage()) ;
int needchange=0;
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

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=weaver action="PlanShareOperation.jsp" method=post >
<input type="hidden" name="method" value="add">
<input type="hidden" name="types" value="1">
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
    
          	<TR>
            <Td>
            <%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>
            </Td><TD class=field ><%RecordSet.execute("SELECT * FROM WorkPlanType where (workPlanTypeID=0 or workPlanTypeID>6) and available=1 order by workPlanTypeID");%>
             <select class=inputstyle  name=planType >
                  <option value="-1"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				 <%while (RecordSet.next()) {%>
				  <option value="<%=RecordSet.getString("workPlanTypeID")%>"><%=Util.forHtml(RecordSet.getString("workPlanTypename"))%></option>
				 <%}%>
				 
 			  </SELECT>
            </td>
          </TR>
         	<TR style="height:1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
        <!--TR>
          <TD>
		   <%=SystemEnv.getHtmlLabelName(21504,user.getLanguage())%>   
		  </TD>
          <TD class=field >
		  <select class=inputstyle  name=sharetyped onchange="onChangeSharetyped()" >
				  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				  <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
				  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				  <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
 			  </SELECT>
			<button type="button" type="button" class=Browser style="display:none" onClick="onShowResource(showrelatedsharenamed,relatedshareided)" name=showresourced></BUTTON> 
			<button type="button" class=Browser style="display:none" onClick="onShowSubcompany(showrelatedsharenamed,relatedshareided)" name=showsubcompanyed></BUTTON> 
			<button type="button" class=Browser style="display:''" onClick="onShowDepartment(showrelatedsharenamed,relatedshareided)" name=showdepartmented></BUTTON> 
			<button type="button" class=Browser style="display:none" onclick="onShowRole(showrelatedsharenamed,relatedshareided)" name=showroled></BUTTON>
			 <INPUT type=hidden name=relatedshareided value="">
			 <span id=showrelatedsharenamed name=showrelatedsharenamed><IMG src='/images/BacoError.gif' align=absMiddle></span>
			<span id=showroleleveled name=showroleleveled style="visibility:hidden">
			&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
			<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
			<select class=inputstyle  name=roleleveled  >
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</SELECT>
			</span>
			&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
			<span id=showsecleveled name=showsecleveled>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
			<INPUT type=text class="InputStyle" name=secleveled size=6 value="10" onchange='checkinput("secleveled","seclevelimaged")' >
			</span>
			<SPAN id=seclevelimaged></SPAN>
		  </TD>	
		  
		</TR>

			<TR >
            <Td colSpan=2 class="Line1"></Td>
          </TR-->
		<tr>
		<TD >
			 <%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>  
		  </TD>
          <TD class=field >
	       <select class=inputstyle  name=sharetype onchange="onChangeSharetype()" >
				  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				  <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
				  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				  <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
 			  </SELECT>
			<button type="button" class=Browser style="display:none" onClick="onShowResource('relatedshareid','showrelatedsharename')" name=showresource></BUTTON> 
			<button type="button" class=Browser style="display:none" onClick="onShowSubcompany('relatedshareid','showrelatedsharename')" name=showsubcompany></BUTTON> 
			<button type="button" class=Browser style="display:''" onClick="onShowDepartment('relatedshareid','showrelatedsharename')" name=showdepartment></BUTTON> 
			<button type="button" class=Browser style="display:none" onclick="onShowRole('relatedshareid','showrelatedsharename')" name=showrole></BUTTON>
			 <INPUT type=hidden name=relatedshareid value="">
			 <span id=showrelatedsharename name=showrelatedsharename><IMG src='/images/BacoError.gif' align=absMiddle></span>
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
		<TR  style="height:1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
          <tr>
          <TD>
			 <%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<select class=inputstyle  name=sharelevel>
			  <option value="1" selected><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
			</SELECT> 
          </TD>
		</TR>
<TR  style="height:1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
		</TBODY>
	  </TABLE>
	</form>  
<!--原有共享--><br>
        <table class=liststyle cellspacing=1>
          <colgroup> 
          <col width="15%"> 
          <col width="25%"> 
		 
          <col width="25%">
		  <col width="5%">
          <col width="8%">
		  <col width="5%">
		  </colgroup>
          <tr class="Title"> 
            <th colspan=6><%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%></th>
          <tr class="Spacing" style="height:1px;"> 
            <td class="Line1" colspan=6 style="padding:0;"></td>
          </tr>
		  <tr class=Header> 
            <td><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></td>
			<!--td ><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td-->
			<td><%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
			<td ></td>
          </tr>
		  <TR style="height:1px;">
            <Td colSpan=6 class="Line1" style="padding:0;"></Td>
          </TR>
<%
	//查找已经添加的共享
	String newName="";
	String oldName="";
	RecordSet.execute("select workPlanType.workPlanTypename ,WorkPlanShareSet.* from WorkPlanShareSet,workPlanType  where settype=1 and workPlanTypeID=planid  and (ssharetype=1 and SUSERID='"+user.getUID()+"') order by  planid ,id desc");
	
	boolean isLight = false;
	while(RecordSet.next())
	{

    		if(isLight = !isLight)
									{
							%>	
							<TR CLASS=DataLight>
							<%
									}
									else
									{
							%>
							<TR CLASS=DataDark>
							<%		
									}
							%>
	<td><%=Util.forHtml(RecordSet.getString(1))%></td>
	<td>
	<%
	int ssharetype=RecordSet.getInt("SSHARETYPE");
	switch (ssharetype)
	{case 1:   //多人员
	    String suerid=RecordSet.getString("SUSERID");
		  if (!suerid.equals("")) {
		  String hrmName="";
		  ArrayList hrmIda=Util.TokenizerString(suerid,",");
		  for (int k=0;k<hrmIda.size();k++)
		  {
		  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
		  }
		  out.print(hrmName);
          }
		break;
	case 2:    //多分部
	    String checkBranchId=RecordSet.getString("SSUBCOMPANYID");
		if (!checkBranchId.equals("")) {
		  String branchName="";
		  ArrayList branchIda=Util.TokenizerString(checkBranchId,",");
		  for (int i=0;i<branchIda.size();i++)
		  {
		  branchName=branchName+"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="+branchIda.get(i)+">"+SubCompanyComInfo.getSubCompanyname(""+branchIda.get(i))+"</a> ";	 
		  }
		  out.print(branchName);
          }
		break;
	case 3:     //多部门
		 String checkDeptId=RecordSet.getString("SDEPARTMENTID");
		 if (!checkDeptId.equals("")) {
		  String deptName="";
		  ArrayList deptIda=Util.TokenizerString(checkDeptId,",");
		  for (int i=0;i<deptIda.size();i++)
		  {
		  deptName=deptName+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+deptIda.get(i)+">"+DepartmentComInfo.getDepartmentname(""+deptIda.get(i))+"</a> ";
		  }
		 out.print(deptName);
		 }
		break;
	case 4:     //角色
        String SROLEID=RecordSet.getString("SROLEID");
		int SROLELEVEL=RecordSet.getInt("SROLELEVEL");
        String SROLELEVELName="";
		if (SROLELEVEL==0) SROLELEVELName=SystemEnv.getHtmlLabelName(124,user.getLanguage());
		if (SROLELEVEL==1) SROLELEVELName=SystemEnv.getHtmlLabelName(141,user.getLanguage());
		if (SROLELEVEL==2) SROLELEVELName=SystemEnv.getHtmlLabelName(140,user.getLanguage());
	    out.print(RolesComInfo.getRolesname(SROLEID)+"/"+SROLELEVELName);
		break;
	case 5:     //所有人
	    out.print(SystemEnv.getHtmlLabelName(1340,user.getLanguage()));
		break;
	}
	
	%>
    </td>
	<!--td><%=RecordSet.getString("Sseclevel")%></td-->
	<td><%
	int sharetype=RecordSet.getInt("SHARETYPE");
	switch (sharetype)
	{case 1:   //多人员
	    String suerid=RecordSet.getString("USERID");
		  if (!suerid.equals("")) {
		  String hrmName="";
		  ArrayList hrmIda=Util.TokenizerString(suerid,",");
		  for (int k=0;k<hrmIda.size();k++)
		  {
		  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
		  }
		  out.print(hrmName);
          }
		break;
	case 2:    //多分部
	    String checkBranchId=RecordSet.getString("SUBCOMPANYID");
		if (!checkBranchId.equals("")) {
		  String branchName="";
		  ArrayList branchIda=Util.TokenizerString(checkBranchId,",");
		  for (int i=0;i<branchIda.size();i++)
		  {
		  branchName=branchName+"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="+branchIda.get(i)+">"+SubCompanyComInfo.getSubCompanyname(""+branchIda.get(i))+"</a> ";	 
		  }
		  out.print(branchName);
          }
		break;
	case 3:     //多部门
		 String checkDeptId=RecordSet.getString("DEPARTMENTID");
		 if (!checkDeptId.equals("")) {
		  String deptName="";
		  ArrayList deptIda=Util.TokenizerString(checkDeptId,",");
		  for (int i=0;i<deptIda.size();i++)
		  {
		  deptName=deptName+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+deptIda.get(i)+">"+DepartmentComInfo.getDepartmentname(""+deptIda.get(i))+"</a> ";
		  }
		 out.print(deptName);
		 }
		break;
	case 4:     //角色
        String SROLEID=RecordSet.getString("ROLEID");
		int SROLELEVEL=RecordSet.getInt("ROLELEVEL");
        String SROLELEVELName="";
		if (SROLELEVEL==0) SROLELEVELName=SystemEnv.getHtmlLabelName(124,user.getLanguage());
		if (SROLELEVEL==1) SROLELEVELName=SystemEnv.getHtmlLabelName(141,user.getLanguage());
		if (SROLELEVEL==2) SROLELEVELName=SystemEnv.getHtmlLabelName(140,user.getLanguage());
	    out.print(RolesComInfo.getRolesname(SROLEID)+"/"+SROLELEVELName);
		break;
	case 5:     //所有人
	    out.print(SystemEnv.getHtmlLabelName(1340,user.getLanguage()));
		break;
	}
	
	%></td>
	<td><%if (sharetype!=1) {%><%=RecordSet.getString("seclevel")%><%}%></td>
	<td><% 
		int SHARELEVEL=RecordSet.getInt("SHARELEVEL");
        String SHARELEVELNAME="";
		if (SHARELEVEL==1) SHARELEVELNAME=SystemEnv.getHtmlLabelName(367,user.getLanguage());
		if (SHARELEVEL==2) SHARELEVELNAME=SystemEnv.getHtmlLabelName(93,user.getLanguage());
        out.print(SHARELEVELNAME);

     %></td>
	<td> <A href="#" onclick="delplan(<%=RecordSet.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> </td>
	</tr><%}
	%>
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
function delplan(id)
{
	if (isdel())
	{
		location.href="PlanShareOperation.jsp?types=1&method=delete&id="+id;
	}
}

function doSave(obj) {
thisvalue=document.weaver.sharetype.value;
//sthisvalue=document.weaver.sharetyped.value;
var checkstr="";
if (thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){
  
            checkstr="relatedshareid";
 }

//alert(checkstr);
if(check_form(document.weaver,checkstr)){
document.weaver.submit();
obj.disabled=true;
}
}
</script>

<script language=javascript>
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
		document.weaver.relatedshareid.value="";
	$("#showseclevel").show();

	$("#showrelatedsharename").html("<IMG src='/images/BacoError.gif' align=absMiddle>");

	if(thisvalue==1){
 		$GetEle("showresource").style.display='';
		$GetEle("showseclevel").style.display='none';
		//TD33012 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存
		seclevelimage.innerHTML = ""
		if($GetEle("seclevel").value==""){
			$GetEle("seclevel").value=10;
		}
		//End TD33012	
	}
	else{
		$GetEle("showresource").style.display='none';
	}
	if(thisvalue==2){
 		$GetEle("showsubcompany").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		$GetEle("showsubcompany").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==3){
 		$GetEle("showdepartment").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		$GetEle("showdepartment").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==4){
 		$GetEle("showrole").style.display='';
		$GetEle("showrolelevel").style.visibility='visible';
		document.weaver.seclevel.value=10;
	}
	else{
		$GetEle("showrole").style.display='none';
		$GetEle("showrolelevel").style.visibility='hidden';
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
	//TD33012 切换时，增加对安全级别为空的提示；人力资源没有安全级别
	if($GetEle("seclevel").value==""&&thisvalue!=1){
		seclevelimage.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	}
	//End TD33012
}


 function onChangeSharetyped(){
	thisvalue=document.weaver.sharetyped.value;
	document.weaver.relatedshareided.value="";
	$GetEle("showsecleveled").style.display='';

	showrelatedsharenamed.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"

	if(thisvalue==1){
 		$GetEle("showresourced").style.display='';
		$GetEle("showsecleveled").style.display='none';
	}
	else{
		$GetEle("showresourced").style.display='none';
	}
	if(thisvalue==2){
 		$GetEle("showsubcompanyed").style.display='';
 		document.weaver.secleveled.value=10;
	}
	else{
		$GetEle("showsubcompanyed").style.display='none';
		document.weaver.secleveled.value=10;
	}
	if(thisvalue==3){
 		$GetEle("showdepartmented").style.display='';
 		document.weaver.secleveled.value=10;
	}
	else{
		$GetEle("showdepartmented").style.display='none';
		document.weaver.secleveled.value=10;
	}
	if(thisvalue==4){
 		$GetEle("showroled").style.display='';
		$GetEle("showroleleveled").style.visibility='visible';
		document.weaver.secleveled.value=10;
	}
	else{
		$GetEle("showroled").style.display='none';
		$GetEle("showroleleveled").style.visibility='hidden';
		document.weaver.secleveled.value=10;
    }
	if(thisvalue==5){
		showrelatedsharenamed.innerHTML = ""
		document.weaver.relatedshareided.value=-1;
		document.weaver.secleveled.value=10;
	}
	if(thisvalue<0){
		showrelatedsharenamed.innerHTML = ""
		document.weaver.relatedshareided.value=-1;
		document.weaver.secleveled.value=0;
	}
}

function onChangeShareLevel(){
	thisvalue=document.weaver.sharelevel.value;
	document.weaver.departmentids.value="";
	departmentidspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";

	if(thisvalue==9){
 		$GetEle("departmentnames").style.display='';
        $GetEle("departmentidspan").style.visibility='visible';
    }
	else{
		$GetEle("departmentnames").style.display='none';
        $GetEle("departmentidspan").style.visibility='hidden';
    }
}


</script>
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
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'PrjName,PrjType,WorkType,hrmids02,SecuLevel,PrjManager,PrjDept'))
		weaver.submit();
}
</script>
</BODY>
</HTML>
