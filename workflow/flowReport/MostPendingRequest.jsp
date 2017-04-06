<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="userSort" class="weaver.workflow.report.UserPendingSort" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>
<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(19032 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ; 
int objType1=Util.getIntValue(request.getParameter("objType"),0);
String objIds=Util.null2String(request.getParameter("objId"));
String objNames=Util.null2String(request.getParameter("objNames"));
String userRights=shareRights.getUserRights("-6",user);//得到用户查看范围
if (userRights.equals("-100")){
   response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String fromcredate = Util.null2String(request.getParameter("fromcredate"));//得到创建时间搜索条件
String tocredate = Util.null2String(request.getParameter("tocredate"));//得到创建时间搜索条件
String fromadridate = Util.null2String(request.getParameter("fromadridate"));//得到到达搜索条件
String toadridate = Util.null2String(request.getParameter("toadridate"));//得到到达搜索条件

String sqlCondition = " and 1=1 ";
if(!"".equals(fromcredate)) {
    sqlCondition += " and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid = workflow_currentoperator.requestid and workflow_requestbase.createdate >= '"+fromcredate+"')";
}
if(!"".equals(tocredate)) {
	sqlCondition += " and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid = workflow_currentoperator.requestid and workflow_requestbase.createdate <= '"+tocredate+"')";
}
if(!"".equals(fromadridate)) {
	sqlCondition += " and workflow_currentoperator.receivedate >='" +fromadridate+ "'";
}
if(!"".equals(toadridate)) {
	sqlCondition += " and workflow_currentoperator.receivedate <='" +toadridate+ "'";
}

String sql="select id from hrmresource where  departmentid in ("+userRights+")  and hrmresource.status in (0,1,2,3)";
if (userRights.equals(""))
{
sql=" select id from hrmresource where  hrmresource.status in (0,1,2,3) ";
} 
ArrayList userIds=new ArrayList();
List sorts=new ArrayList();
ArrayList totlaSort=new ArrayList();
ArrayList totlaSortDepartment=new ArrayList();
ArrayList totlaSortSubCompany=new ArrayList();
ArrayList users=new ArrayList();
ArrayList counts=new ArrayList();
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
if (objType1!=0)
{	
sorts=userSort.getUserSort(sqlCondition); //得到所有人的待办事宜排名
if (sorts.size()>0)
{
 totlaSort=(ArrayList)sorts.get(0);
 users=(ArrayList)sorts.get(1);
 counts=(ArrayList)sorts.get(2);
 totlaSortDepartment=(ArrayList)sorts.get(3);
 totlaSortSubCompany=(ArrayList)sorts.get(4);
}
RecordSet.execute(sql);
while (RecordSet.next())
{
userIds.add(RecordSet.getString(1));
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
<FORM id=frmMain name=frmMain action=MostPendingRequest.jsp method=post>
<!--查询条件-->
<table  class="viewform">
<tr>
    <td width="10%">
    <select class=inputstyle  name=objType onChange="onChangeType()">
    <option value="1" <%if (objType1==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
    <option value="2" <%if (objType1==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
    <option value="3" <%if (objType1==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
    </select>
    </td>
    <td class=field width="20%">
    
    <BUTTON type=button class=Browser <%if (objType1==2||objType1==3) {%>  style="display:none"  <%}%> onClick="onShowResource('objId','objName')" name=showresource></BUTTON> 
	<BUTTON type=button class=Browser <%if (objType1==0||objType1==1||objType1==3) {%> style="display:none" <%}%> onClick="onShowDepartment('objId','objName')" name=showdepartment></BUTTON> 
    <BUTTON type=button class=Browser <%if (objType1==0||objType1==1||objType1==2) {%> style="display:none"  <%}%> onClick="onShowBranch('objId','objName')" name=showBranch></BUTTON>
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
	
	<td width="10%"><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></td>
    <td class=field width="20%">
    <BUTTON class=calendar type=button id=SelectDate1 onclick=getDate(fromcredatespan,fromcredate)></BUTTON>
	<SPAN id=fromcredatespan><%=fromcredate%></SPAN> 										
	&nbsp;- &nbsp;
	<BUTTON class=calendar type=button id=SelectDate2 onclick=getDate(tocredatespan,tocredate)></BUTTON>
	<SPAN id=tocredatespan><%=tocredate%></SPAN>
	<input type="hidden" name="fromcredate" value="<%=fromcredate%>">
	<input type="hidden" name="tocredate" value="<%=tocredate%>">
	</td>
	
	<td width="10%"><%=SystemEnv.getHtmlLabelName(2196,user.getLanguage())%></td>
    <td class=field width="20%">
    <BUTTON class=calendar type=button id=SelectDate3 onclick=getDate(fromadridatespan,fromadridate)></BUTTON>
	<SPAN id=fromadridatespan><%=fromadridate%></SPAN> 										
	&nbsp;- &nbsp;
	<BUTTON class=calendar type=button id=SelectDate4 onclick=getDate(toadridatespan,toadridate)></BUTTON>
	<SPAN id=toadridatespan><%=toadridate%></SPAN>
	<input type="hidden" name="fromadridate" value="<%=fromadridate%>">
	<input type="hidden" name="toadridate" value="<%=toadridate%>">
	</td>
	
	</tr>
	</table>
</FORM>
<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
  <COLGROUP> 
   <col width="10%">
   <col width="20%"> 
   <col width="20%"> 
   <col width="10%"> 
   <col width="10%"> 
   <col width="10%"> 
   <tr class=header align=left>
   <td><%=SystemEnv.getHtmlLabelName(19083,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19082,user.getLanguage())%></td><!--总排名 -->
   <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td><!--人员 -->
   <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td><!--部门 -->
   <td><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></td><!--待办事宜 -->  
   <td><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19082,user.getLanguage())%></td><!-- 部门排名 -->
   <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19082,user.getLanguage())%></td><!--分部排名 -->
   </tr>
   <TR style="height: 1px;"><TD class=Line colspan="6" style="padding: 0px;"></TD></TR>
   <%
   BarTeeChart bar=null;
   if (objType1!=0&&userIds.size()>0) {
      boolean isLight = false ;
  	/*******/
	bar=TeeChartFactory.createBarChart(SystemEnv.getHtmlLabelName(19032 , user.getLanguage()),700,400);
	bar.setMarksStyle(BarTeeChart.SMS_Value);
	//line.isDebug();
	List list1=new ArrayList(),list2=new ArrayList(),list3=new ArrayList();
	String tmp=null;
	/**************************************/
      for (int i=0;i<users.size();i++)
      {  
        if (userIds.indexOf(users.get(i))!=-1)
          {
		  /************************************/
			BarChartModel lc=new BarChartModel();			
			tmp=resourceComInfo.getLastname(""+users.get(i));
			lc.setCategoryName(tmp);
			lc.setValue(counts.get(i).toString());
			list1.add(lc);
		  /************************************/
            isLight = !isLight ; 
    %>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <td><%=totlaSort.get(i)%></td>
    <td><a href="javaScript:openhrm(<%=users.get(i)%>);" onclick='pointerXY(event);'><%=resourceComInfo.getLastname(""+users.get(i))%></a></td>
    <td><%=DepartmentComInfo.getDepartmentname(resourceComInfo.getDepartmentID(""+users.get(i)))%></td>
    <td><%=counts.get(i)%></td>
    <td><%=(""+totlaSortDepartment.get(i)).substring(0,(""+totlaSortDepartment.get(i)).indexOf("$"))%></td>
    <td><%=(""+totlaSortSubCompany.get(i)).substring(0,(""+totlaSortSubCompany.get(i)).indexOf("$"))%></td>
    </tr>
    <!--
    <TR style="height: 1px;" class=Line><TD colspan="6" style="padding: 0px;"></TD></TR>
     -->
    <%
		
          }
      }
	  bar.addSeries(SystemEnv.getHtmlLabelName(19083,user.getLanguage())+SystemEnv.getHtmlLabelName(19082,user.getLanguage()),list1,"");//增加数据曲线
	  //bar.addSeries(SystemEnv.getHtmlLabelName(18939,user.getLanguage())+SystemEnv.getHtmlLabelName(19082,user.getLanguage()),list2);
	 // bar.addSeries(SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(19082,user.getLanguage()),list3);
   %>
   <%}%>
</TABLE>
<br>
<div id="3DMap" >
<%if(bar!=null)bar.print(out);%>
<br>
</div>
<!-- fieldset style="overflow:auto;height:90%;border-width:0px;">

<!-- /fieldset-->
<!--详细内容结束-->
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
<script type="text/javascript">
if (!window.ActiveXObject) {
    jQuery("#3DMap").hide();
}
</script>
<script>
  function onChangeType(){
 
	thisvalue=document.frmMain.objType.value;
	$G("objId").value="";
	$G("objName").innerHTML ="";
	$G("nameimage").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>";
	if(thisvalue==3){
 		$G("showBranch").style.display='';
	}
	else{
		$G("showBranch").style.display='none';
	}
	if(thisvalue==2){
 		$G("showdepartment").style.display='';
		
	}
	else{
		$G("showdepartment").style.display='none';
	}
	if(thisvalue==1){
 		$G("showresource").style.display='';
		
	}
	else{
		$G("showresource").style.display='none';
		
    }
	
}
function submitData()
{
	   if (check_form(frmMain,'objId'))
		   document.frmMain.submit();
}
function onShowResource(inputename,tdname){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.slice(1).split(",");
	    	var names=datas.name.slice(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a href=javaScript:openhrm("+ids[i]+"); onclick='pointerXY(event);' target='_blank'>"+names[i]+"</a>&nbsp";
            }
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.slice(1));
			jQuery("#objNames").val(strs);
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#objNames").val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
		}
	}
}
function onShowDepartment(inputename,tdname){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids="+ids+"&selectedDepartmentIds="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.slice(1).split(",");
	    	var names=datas.name.slice(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a target='_blank' href=/hrm/company/HrmDepartmentDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
            }
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.slice(1));
			jQuery("#objNames").val(strs);
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#objNames").val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
		}
	}
}
function onShowBranch(inputename,tdname){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+ids+"&selectedDepartmentIds="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.slice(1).split(",");
	    	var names=datas.name.slice(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a target='_blank' href=/hrm/company/HrmSubCompanyDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
            }
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.slice(1));
			jQuery("#objNames").val(strs);
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#objNames").val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
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
</SCRIPT>
-->
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
