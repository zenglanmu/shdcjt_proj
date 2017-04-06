<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>
<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(19034 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ; 
String userRights=shareRights.getUserRights("-7",user);//得到用户查看范围
       if (userRights.equals("-100")){
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
    }
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
    ArrayList wftypess=new ArrayList();

    int totalcount=0;
    String typeId=Util.null2String(request.getParameter("typeId"));//得到搜索条件
    String flowId=Util.null2String(request.getParameter("flowId"));//得到搜索条件
    
    String fromcredate = Util.null2String(request.getParameter("fromcredate"));//得到创建时间搜索条件
	String tocredate = Util.null2String(request.getParameter("tocredate"));//得到创建时间搜索条件
	String objStatueType = Util.null2String(request.getParameter("objStatueType"));//得到流程状态搜索条件
    int objType1 = Util.getIntValue(request.getParameter("objType"),0);//得到创建时间搜索条件
    String rhobjNames = Util.null2String(request.getParameter("rhobjNames"));
    String rhobjId = Util.null2String(request.getParameter("rhobjId"));
    
    String sqlCondition1="";
    String sqlCondition="";
    
    if(objType1 != 0 && !"".equals(rhobjId)){
	    switch (objType1){
	        case 1:
	        	sqlCondition=" and creater in (select id from hrmresource where id in ("+rhobjId+") )"  ;
	        break;
	        case 2:
	        	sqlCondition=" and creater in (select id from hrmresource where departmentid in ("+rhobjId+") )" ;
	        break;
	        case 3:
	        	sqlCondition=" and creater in (select id from hrmresource where subcompanyid1 in ("+rhobjId+") )" ;
	        break;
		}
    }
    if(!"".equals(fromcredate)){
    	sqlCondition += " and createdate >='" +fromcredate+ "'";
    }
    if(!"".equals(tocredate)) {
    	sqlCondition += " and createdate <='" +tocredate+ "'";
	}
    if(!"".equals(objStatueType)) {
		if("1".equals(objStatueType)) {
			sqlCondition += " and workflow_requestbase.currentnodetype ='3'";
		} else {
			sqlCondition += " and workflow_requestbase.currentnodetype <>'3'";
		}
	}
    
    if (userRights.equals(""))
    {sqlCondition1 += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition1 += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
    
    if (!typeId.equals("")&&!typeId.equals("0"))  sqlCondition1+="  and workflow_currentoperator.workflowtype="+typeId;
    //sqlCondition1=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") )";
    //out.print(sqlCondition1);
    sqlCondition += " and workflow_requestbase.workflowid>1 ";
    if (!flowId.equals(""))  sqlCondition+=" and workflow_requestbase.workflowid="+flowId;
    
	//out.print(sql);
	int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
    int	perpage=20;
	
    //out.print(sqlCondition);
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
<FORM id=frmMain name=frmMain action=MostSpendTime.jsp method=post>
<!--查询条件-->
<input type="hidden" name="pagenum" value=''>
<table  class="viewform">
<tr>
    <td width="10%"><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field width="20%">
 
	<input class=wuiBrowser type=hidden name="typeId" id="typeId" value="<%=typeId%>"
	_url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
	_displayText="<%=WorkTypeComInfo.getWorkTypename(""+typeId)%>"
	>
    </td>   
    <td width="10%"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
    <td class=field width="20%">
       <BUTTON type="button" class=Browser onClick="onShow2('flowId','flowName')" name=showflow></BUTTON>
       <SPAN id=flowName>
	    <%=WorkflowComInfo.getWorkflowname(""+flowId)%>
	   </SPAN>
	   <input type=hidden name="flowId" id="flowId" value="<%=flowId%>">
       
    <!--
	<input class=wuiBrowser type=hidden name="flowId" id="flowId" value="<%=flowId%>"
	_url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp"
	displayText="<%=WorkflowComInfo.getWorkflowname(""+flowId)%>"
	>
	-->
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
	<TR class=Separartor style="height:1px"><TD class="Line" COLSPAN=8></TD></TR>
	<tr>
	 <td width="10%">
	    <select class=inputstyle  name=objType onchange="onChangeType()">
	    <option value="1" <%if (objType1==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
	    <option value="2" <%if (objType1==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
	    <option value="3" <%if (objType1==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
	    </select>
    </td>
    <td class=field width="30%">    
    <BUTTON type=button class=Browser <%if (objType1==2||objType1==3) {%>  style="display:none"  <%}%> onClick="onShowResource('rhobjId','rhobjName')" name=showresource></BUTTON> 
	<BUTTON type=button class=Browser <%if (objType1==0||objType1==1||objType1==3) {%> style="display:none" <%}%>  onClick="onShowDepartment('rhobjId','rhobjName')" name=showdepartment></BUTTON> 
    <BUTTON type=button class=Browser <%if (objType1==0||objType1==1||objType1==2) {%> style="display:none"  <%}%>  onclick="onShowBranch('rhobjId','rhobjName')" name=showBranch></BUTTON>
	<SPAN id=rhobjName><%=rhobjNames%></SPAN>
	<input type=hidden name="rhobjId" id="rhobjId" value="<%=rhobjId%>">
	<input type=hidden name="rhobjNames" id="rhobjNames" value="<%=rhobjNames%>">
	</td>
	<td width="10%"><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></td>
    <td class=field width="40%">
    <BUTTON type=button class=calendar id=SelectDate1 onclick=getDate(fromcredatespan,fromcredate)></BUTTON>
	<SPAN id=fromcredatespan><%=fromcredate%></SPAN> 										
	&nbsp;- &nbsp;
	<BUTTON type=button class=calendar id=SelectDate2 onclick=getDate(tocredatespan,tocredate)></BUTTON>
	<SPAN id=tocredatespan><%=tocredate%></SPAN>
	<input type="hidden" name="fromcredate" value="<%=fromcredate%>">
	<input type="hidden" name="tocredate" value="<%=tocredate%>">
	</td>
	</tr>
	
<TR class=Separartor style="height:1px"><TD class="Line" COLSPAN=8></TD></TR>
</table>

<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
  <COLGROUP> 
  <col width="5%">
  <col width="25%"> 
  <col width="15%"> 
  <col width="40%"> 
  <col width="10%"> 
  <TR class=Header align=left>
  <TD><%=SystemEnv.getHtmlLabelName(19082,user.getLanguage())%></Td><!-- 排名-->
  <TD><%=SystemEnv.getHtmlLabelName(19060,user.getLanguage())%></TD><!--具体流程-->
  <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TD><!--工作流-->
  <TD><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></TD><!-- 流程类型-->
  <TD><%=SystemEnv.getHtmlLabelName(19079,user.getLanguage())%></TD><!--耗时-->
  </TR>
  <%  boolean isLight = false ;
      char flag = Util.getSeparator() ;
      boolean hasNextPage=false;
      int totals=pagenum*perpage+1;
      int totalstmp = pagenum*perpage+1;//TD12336
      if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
	  {
	 String sqls=" ( select * from (select  requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid,status,24*(to_date( NVL2(lastoperatedate ,lastoperatedate||' '||lastoperatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')) ,'YYYY-MM-DD HH24:MI:SS')"+
     "-to_date(createdate||' '||createtime,'YYYY-MM-DD HH24:MI:SS')) as spends "+
	" from workflow_requestbase where  "+
	"  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid  and workflow_currentoperator.preisremark='0'　"+sqlCondition1+" ) and status is not null   "+sqlCondition+
	"  order by spends desc) where rownum<"+(totals+1)+" ) s ";
     RecordSet.execute("select count(*) from "+sqls);
      //if (RecordSet.next()) totals=RecordSet.getInt(1);
      if (RecordSet.next()) totalstmp=RecordSet.getInt(1);//TD12336
	      //if(totals>0){
	      if(totalstmp > pagenum*perpage){
	          hasNextPage=true;
	      }
	      //TD12336最后一页取数据
	      if (totalstmp < totals) {
	          totals = totalstmp;
	      }
	  RecordSet.execute("select * from (select * from (select * from "+sqls+" order by spends ) where rownum< "+(totals-(pagenum-1)*perpage+1)+" ) order by  spends desc");
	  }
	  else
	  {
     RecordSet.executeProc("SpendTimeStat_count",sqlCondition1+flag+sqlCondition+flag+totals);
	  }
      //if (RecordSet.next()) totals=RecordSet.getInt(1);
      if (RecordSet.next()) totalstmp=RecordSet.getInt(1);//TD12336
      //if(totals>0){
        if (totalstmp > pagenum*perpage) {
            hasNextPage=true;
        }
        //TD12336最后一页取数据
        if (totalstmp < totals) {
            totals = totalstmp + 1;
        }
		if (!RecordSet.getDBType().equals("oracle")){
      		RecordSet.executeProc("SpendTimeStat_Get",sqlCondition1+flag+sqlCondition+flag+pagenum+flag+perpage+flag+totals) ;
		}
  %>
  		<%if(pagenum>1){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:frmMain.prepage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
						<button type=submit  style="display:none" class=btn accessKey=P id=prepage onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
						<%}%>
						<%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:frmMain.nextpage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
						<button type=submit style="display:none" class=btn accessKey=N  id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
						<%}%>


<%
      
      int i=1;
	  while(RecordSet.next()){       
        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
        String requestName = Util.null2String(RecordSet.getString("requestname")) ;
        String tempStatus= Util.null2String(RecordSet.getString("status")) ;
		float spends = Util.getFloatValue(RecordSet.getString("spends"),0) ;
        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
        isLight = !isLight ; 
        String typeName=WorkTypeComInfo.getWorkTypename(WorkflowComInfo.getWorkflowtype(theworkflowid));
        String flowName=WorkflowComInfo.getWorkflowname(theworkflowid);
 %>

 <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
 <td><%=i+(pagenum-1)*perpage%></td>
 <td><%=requestName%></td>
 <td><%=flowName%></td>
 <td><%=typeName%></td>
 <td><%=Util.round(""+spends,1)%></td>
 </tr>
 <!--
 <TR class=Line><TD colspan="5" ></TD></TR>
  -->
 <%
 i++;
 }
 }%>
<!-- /TABLE>
</fieldset-->
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</FORM>
<script>

  

  function chageFlowType(eventobj,list_obj,target_obj)
  {
	var oOption ;
	var tempstr = eventobj.value +"$";
	target_obj.options.length = 0 ;
	
	oOption = document.createElement("OPTION");
	oOption.text = "";
	oOption.value = "";
	target_obj.options.add(oOption);
	
	if (eventobj.value.length > 0)
	{
	for (var i=0; i< list_obj.options.length; i++)
	{
		if (list_obj.options(i).value.indexOf(tempstr)>=0)
		{
		oOption = document.createElement("OPTION");
		oOption.text=list_obj.options(i).text;
		oOption.value=list_obj.options(i).value.substr(list_obj.options(i).value.indexOf('$')+1,list_obj.options(i).value.length) ;
		target_obj.options.add(oOption);
		}
	
	 }
    }
  }
  
function onChangeType(){
 
	thisvalue=document.frmMain.objType.value;
	$G("rhobjId").value="";
	$G("rhobjName").innerHTML ="";
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
                strs=strs+"<a href=javaScript:openhrm("+ids[i]+"); onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
            }
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.slice(1));
			jQuery("#rhobjNames").val(strs);
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#rhobjNames").val("");
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
			jQuery("#rhobjNames").val(strs);
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#rhobjNames").val(strs);
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
			jQuery("#rhobjNames").val(strs);
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#rhobjNames").val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
		}
	}
}

function onShow2(inputename,showname){
   typeid=$G("typeId").value;
   results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid="+typeid)
   if (results){
        if (results.id!=""){
          $G(showname).innerHTML =results.name;
		  $G(inputename).value=results.id;
        }else{
		  $G(showname).innerHTML ="";
          $G(inputename).value="";
        }
    }
}


</script>

<script language=vbs>
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
		  document.all("rhobjNames").value=sHtml
        else
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
		  document.all("rhobjNames").value=""
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
          document.getElementById(showname).innerHtml = sHtml
          document.all("rhobjNames").value=sHtml
        else
          document.all(inputename).value=""
		  document.all(showname).innerHtml =""
		  document.all("rhobjNames").value=""
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
	      document.all("rhobjNames").value=sHtml
        else		
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
		  document.all("rhobjNames").value=""
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

sub onShow21(inputename,showname)
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
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
