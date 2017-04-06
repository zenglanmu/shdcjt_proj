<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="userSort" class="weaver.workflow.report.UserExceedSort" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>
<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(19037 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ; 
int objType1=Util.getIntValue(request.getParameter("objType"),0);
String objIds=Util.null2String(request.getParameter("objId"));
String objNames=Util.null2String(request.getParameter("objNames"));
String userRights=shareRights.getUserRights("-10",user);//得到用户查看范围
   if (userRights.equals("-100")){
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
    }
String sql="select id from hrmresource where  departmentid in ("+userRights+")  and hrmresource.status in (0,1,2,3)";
 if (userRights.equals(""))
  {sql=" select id from hrmresource where  hrmresource.status in (0,1,2,3) ";
    }
    
ArrayList userIds=new ArrayList();
List sorts=new ArrayList();
ArrayList totlaSort=new ArrayList();
ArrayList totlaSortDepartment=new ArrayList();
ArrayList totlaSortSubCompany=new ArrayList();
ArrayList users=new ArrayList();
ArrayList counts=new ArrayList();
ArrayList sumCounts=new ArrayList();
ArrayList percentCounts=new ArrayList();
String suserIds="";
String tempsql="";
String sqltemp="";
String tempsql1="";
String sqlCondition = " and 1=1";
		switch (objType1){
	        case 1:
			sql+=" and hrmresource.id in ("+objIds+")"  ;
			sqlCondition += "and workflow_currentoperator.userid in (select id from hrmresource where id in ("+objIds+"))";
	        break;
	        case 2:
	        sql+=" and hrmresource.departmentid in ("+objIds+")"  ; 
			sqlCondition += "and workflow_currentoperator.userid in (select id from hrmresource where departmentid in ("+objIds+"))";
	        break;
	        case 3:
	        sql+=" and hrmresource.subcompanyid1 in ("+objIds+")"  ;
            sqlCondition += "and workflow_currentoperator.userid in (select id from hrmresource where subcompanyid1 in ("+objIds+"))";
	        break;
	}

String sqlstr1 = "";
String sqlstr2 = "";
String typeId=Util.null2String(request.getParameter("typeId"));//得到搜索条件
String flowId=Util.null2String(request.getParameter("flowId"));//得到搜索条件
String objStatueType = Util.null2String(request.getParameter("objStatueType"));//得到流程状态搜索条件
String fromadridate = Util.null2String(request.getParameter("fromadridate"));//得到到达搜索条件
String toadridate = Util.null2String(request.getParameter("toadridate"));//得到到达搜索条件
if(!"".equals(fromadridate)) {
	sqlCondition += " and workflow_currentoperator.receivedate >='" +fromadridate+ "'";
	sqlstr1 += " and a.receivedate >='" +fromadridate+ "'";
}
if(!"".equals(toadridate)) {
	sqlCondition += " and workflow_currentoperator.receivedate <='" +toadridate+ "'";
	sqlstr1 += " and a.receivedate <='" +toadridate+ "'";
}
if(!"".equals(objStatueType)) {
	if("1".equals(objStatueType)) {
		sqlCondition += " and workflow_requestbase.currentnodetype ='3'";
		sqlstr2 += " and b.currentnodetype ='3'";
	} else {
		sqlCondition += " and workflow_requestbase.currentnodetype <>'3'";
        sqlstr2 += " and b.currentnodetype <>'3'";
	}
}
if (!typeId.equals("")){
	sqlCondition += " and workflow_currentoperator.workflowtype="+typeId+" ";
	sqlstr1 += " and a.workflowtype="+typeId+" ";
} 

if (!flowId.equals("")){
	sqlCondition += " and workflow_requestbase.workflowid="+flowId+" ";
    sqlstr2 += " and b.workflowid="+flowId+" ";
}
		
RecordSet.execute(sql);  //得到查询人员
while (RecordSet.next())
{
userIds.add(RecordSet.getString(1));
}
if (objType1!=0)
{	
sorts=userSort.getUserSort(sqlCondition); //得到所有人的超期流程排名
if (sorts.size()>0)
{
 totlaSort=(ArrayList)sorts.get(0);
 users=(ArrayList)sorts.get(1);
 counts=(ArrayList)sorts.get(2);
 totlaSortDepartment=(ArrayList)sorts.get(3);
 totlaSortSubCompany=(ArrayList)sorts.get(4);
 sumCounts=(ArrayList)sorts.get(5);
 percentCounts=(ArrayList)sorts.get(6);
}




}
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
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
<FORM id=frmMain name=frmMain action=MostExceedPerson.jsp method=post>
<input type="hidden" name="pagenum" value=''>
<!--查询条件-->
<table  class="viewform">
<tr>
    <td width="10%">
    <select class=inputstyle  name=objType onchange="onChangeType()">
    <option value="1" <%if (objType1==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
    <option value="2" <%if (objType1==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
    <option value="3" <%if (objType1==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
    </select>
    </td>
    <td class=field width="20%">
    
    <button type=button  class=Browser <%if (objType1==2||objType1==3) {%>  style="display:none"  <%}%> onClick="onShowResource('objId','objName')" name=showresource></BUTTON> 
	<button type=button  class=Browser <%if (objType1==0||objType1==1||objType1==3) {%> style="display:none" <%}%> onClick="onShowDepartment('objId','objName')" name=showdepartment></BUTTON> 
    <button type=button  class=Browser <%if (objType1==0||objType1==1||objType1==2) {%> style="display:none"  <%}%> onclick="onShowBranch('objId','objName')" name=showBranch></BUTTON>
	<SPAN id=objName>
	<%=objNames%>
	</SPAN><SPAN id=nameimage>
	<%if (objIds.equals("")) {%>
	<IMG src='/images/BacoError.gif' align=absMiddle></IMG>
	<%}%>
	</SPAN> 
	<input type=hidden name="objId" id="objId" value="<%=objIds%>">
	<input type=hidden name="objNames" id="objNames" value="<%=objNames%>">
	</td>
	
	<td width="10%"><%=SystemEnv.getHtmlLabelName(2196,user.getLanguage())%></td>
    <td class=field width="40%">
    <button type=button  class=calendar id=SelectDate3 onclick=getDate(fromadridatespan,fromadridate)></BUTTON>
	<SPAN id=fromadridatespan><%=fromadridate%></SPAN> 										
	&nbsp;- &nbsp;
	<button type=button  class=calendar id=SelectDate4 onclick=getDate(toadridatespan,toadridate)></BUTTON>
	<SPAN id=toadridatespan><%=toadridate%></SPAN>
	<input type="hidden" name="fromadridate" value="<%=fromadridate%>">
	<input type="hidden" name="toadridate" value="<%=toadridate%>">
	</td>
	
	<td width="10%">
	 <%=SystemEnv.getHtmlLabelName(19061,user.getLanguage())%>
	</td>
	<td class=field width="20%">
    <select class=inputstyle name=objStatueType>
    <option value=""></option>
    <option value="1" <%if("1".equals(objStatueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18800,user.getLanguage())%></option>
    <option value="2" <%if("2".equals(objStatueType)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></option>   
    </select>
	</td>
	</tr>
	<TR class=Separartor style="height:1px;"><TD class="Line" COLSPAN=6></TD></TR>
	
	<tr>
     <td width="10%"><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field width="30%">
	<button type=button  class=Browser onClick="onShow('typeId','typeName')" name=showrequest></BUTTON>
    <SPAN id=typeName>
	<%=WorkTypeComInfo.getWorkTypename(""+typeId)%>
	</SPAN>
	<input type=hidden name="typeId" id="typeId" value="<%=typeId%>">
	</td>
    
    <td width="10%"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
    <td class=field width="30%">
    <button type=button  class=Browser onClick="onShow2('flowId','flowName')" name=showflow></BUTTON>
    <SPAN id=flowName>
	<%=WorkflowComInfo.getWorkflowname(""+flowId)%>
	</SPAN>
	<input type=hidden name="flowId" id="flowId" value="<%=flowId%>">
	</td>
	</tr>
	<TR class=Separartor style="height:1px;"><TD class="Line" COLSPAN=6></TD></TR>
	</table>

<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
  <COLGROUP> 
   <col width="10%">
   <col width="25%"> 
   <col width="10%"> 
   <col width="10%"> 
   <col width="15%"> 
   <col width="10%"> 
   <col width="10%"> 
   <tr class=header align=left>
   <td><%=SystemEnv.getHtmlLabelName(19083,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19082,user.getLanguage())%></td><!--总排名 -->
   <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td><!--人员 -->
   <td><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></td><!--全部流程 -->  
   <td><%=SystemEnv.getHtmlLabelName(1982,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></td><!--超期流程 -->  
   <td><%=SystemEnv.getHtmlLabelName(19101,user.getLanguage())%>（100%）</td><!--超期率 -->  
   <td><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19082,user.getLanguage())%></td><!-- 部门排名 -->
   <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19082,user.getLanguage())%></td><!--分部排名 -->
   </tr>
   <TR class=Line style="height:1px;"><TD colspan="7" ></TD></TR>
   <!-- /table>
   <fieldset style="overflow:auto;height:90%;border-width:0px;">
   <TABLE class=ListStyle cellspacing=1 -->
   <%if (objType1!=0&&userIds.size()>0) {
   
   
   
      boolean isLight = false ;
      for (int i=0;i<users.size();i++)
      {  
        if (userIds.indexOf(users.get(i))!=-1)
          {
            isLight = !isLight ; 
    %>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <td><%=totlaSort.get(i)%></td>
    <td><a href="javaScript:openhrm(<%=users.get(i)%>);" onclick='pointerXY(event);'><%=resourceComInfo.getLastname(""+users.get(i))%></a></td>
    <td><%=sumCounts.get(i)%></td>
    <td><%=counts.get(i)%></td>
    <td><%=Util.round(""+percentCounts.get(i),2)%></td>
    <td><%=(""+totlaSortDepartment.get(i)).substring(0,(""+totlaSortDepartment.get(i)).indexOf("$"))%></td>
    <td><%=(""+totlaSortSubCompany.get(i)).substring(0,(""+totlaSortSubCompany.get(i)).indexOf("$"))%></td>
    </tr>
    <TR class=Line style="height:1px;"><TD colspan="7" ></TD></TR>
    <%
          }
      }
   %>
   <%}%>
</TABLE>




<!-- /fieldset-->
<!--详细内容结束-->
</td>
</tr>
</TABLE>
</FORM>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script>
  function onChangeType(){
 
	thisvalue=document.frmMain.objType.value;
	document.all("objId").value="";
	document.all("objName").innerHTML ="";
	document.all("nameimage").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>";
	if(thisvalue==3){
 		$($GetEle("showBranch")).css("display","");
	}
	else{
		$($GetEle("showBranch")).css("display","none");
	}
	if(thisvalue==2){
 		$($GetEle("showdepartment")).css("display","");
		
	}
	else{
		$($GetEle("showdepartment")).css("display","none");
	}
	if(thisvalue==1){
 		$($GetEle("showresource")).css("display","");
		
	}
	else{
		$($GetEle("showresource")).css("display","none");
		
    }
	
}
function submitData()
{
	   if (check_form(frmMain,'objId'))
		frmMain.submit();
}
</script>

<script type="text/javascript">

function onShowDepartment(inputename, showname) {
    var tmpids = document.all(inputename).value;
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids=" + document.all(inputename).value + "&selectedDepartmentIds=" + tmpids);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
            resourceids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
            resourcename = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
            sHtml = "";
            $G(inputename).value = resourceids;
            
            var idArray = resourceids.split(",");
            var nameArray = resourcename.split(",");
            for (var i=0; i<idArray.length; i++ ) {
	            var curid = idArray[i];
	            var curname = nameArray[i];
	            sHtml = sHtml + "<a href=/hrm/company/HrmDepartmentDsp.jsp?id=" + curid + ">" + curname + "</a>&nbsp";
            }
            
            $G(showname).innerHTML = sHtml;
            $G("nameimage").innerHTML = "";
            $G("objNames").value = sHtml
        } else {
            $G(showname).innerHTML = "";
            $G(inputename).value = "";
            $G("nameimage").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle></IMg>";
        }
    }
}


function onShowResource(inputename, showname) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + $G(inputename).value);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
            resourceids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
            resourcename = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
            sHtml = "";
            $G(inputename).value = resourceids;
            
            var idArray = resourceids.split(",");
            var nameArray = resourcename.split(",");
            for (var i=0; i<idArray.length; i++ ) {
	            var curid = idArray[i];
	            var curname = nameArray[i];
	            sHtml = sHtml + "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
            }
            $G(showname).innerHTML = sHtml;
            $G("nameimage").innerHTML = "";
            $G("objNames").value = sHtml
        } else {
            $G(showname).innerHTML = "";
            $G(inputename).value = "";
            $G("nameimage").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle></IMg>";
        }
    }
}



function onShowBranch(inputename,showname) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=" + $G(inputename).value + "&selectedDepartmentIds=" + $G(inputename).value);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
            resourceids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
            resourcename = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
            sHtml = "";
            $G(inputename).value = resourceids;
            
            var idArray = resourceids.split(",");
            var nameArray = resourcename.split(",");
            for (var i=0; i<idArray.length; i++ ) {
	            var curid = idArray[i];
	            var curname = nameArray[i];
	            sHtml = sHtml + "<a href=/hrm/company/HrmSubCompanyDsp.jsp?id=" + curid + ">" + curname + "</a>&nbsp";
            }
            
            $G(showname).innerHTML = sHtml;
            $G("nameimage").innerHTML = "";
            $G("objNames").value = sHtml
        } else {
            $G(showname).innerHTML = "";
            $G(inputename).value = "";
            $G("nameimage").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle></IMg>";
        }
    }
}


function onShow(inputename,showname){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp");
	if(id){
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if(rid != "0"){
			$G(showname).innerHTML = rname;
    		$G(inputename).value = rid;
        } else {
    		$G(showname).innerHTML ="";
			$G(inputename).value="";
		}

		$G("flowName").innerHTML ="";
        $G("flowId").value="" ;
	}
}

function onShow2(inputename,showname){
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G("typeId").value);
	if(id){
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if(rid != "0"){
			$G(showname).innerHTML = rname;
    		$G(inputename).value = rid;
        } else {
    		$G(showname).innerHTML ="";
			$G(inputename).value="";
		}
	}
}
</script>
<!-- 
<SCRIPT language=VBS>
sub onShowDepartment(inputename,showname)
    tmpids = document.all(inputename).value
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids="&document.all(inputename).value&"&selectedDepartmentIds="&tmpids)
   if (Not IsEmpty(id)) then
        if id(0)<> "" then
          resourceids = id(0)
          resourcename = id(1)
          sHtml = ""
          resourceids = Mid(resourceids,2,len(resourceids))
          
          document.all(inputename).value= resourceids
          resourcename = Mid(resourcename,2,len(resourcename))
          while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
		  document.all("objNames").value=sHtml
        else
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
          document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
         end if
         end if
end sub


sub onShowResource(inputename,showname)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
        if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
          resourceids = id1(0)
          resourcename = id1(1)
          sHtml = ""
          
          resourceids = Mid(resourceids,2,len(resourceids))
         
          document.all(inputename).value= resourceids
          resourcename = Mid(resourcename,2,len(resourcename))
          while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
		  document.all("objNames").value=sHtml
        else
          document.all(inputename).value=""
		  document.all(showname).innerHtml =""
		  document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
        end if
         end if
end sub
	
	
sub onShowBranch(inputename,showname)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&document.all(inputename).value&"&selectedDepartmentIds="&tmpids)
   
		if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
          resourceids = id1(0)
          resourcename = id1(1)
          sHtml = ""
         
          resourceids = Mid(resourceids,2,len(resourceids))
          document.all(inputename).value= resourceids
          resourcename = Mid(resourcename,2,len(resourcename))
          while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
	      document.all("objNames").value=sHtml
        else
		
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
		  document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
        end if
         end if
end sub

sub onShow(inputename,showname)
   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp")
   if (Not IsEmpty(id)) then
        if id(0)<> "0" then

          document.all(showname).innerHtml = id(1)
		  document.all(inputename).value=id(0)
        else
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
         end if
          
		  document.all("flowName").innerHtml =""
          document.all("flowId").value="" 
         end if
end sub

sub onShow2(inputename,showname)
   typeid=document.all("typeId").value
   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid="&typeid)
   if (Not IsEmpty(id)) then
        if id(0)<> "" then

          document.all(showname).innerHtml = id(1)
		  document.all(inputename).value=id(0)
        else
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
         end if
         end if
end sub
</SCRIPT>
 -->
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
