<%@ page language="java" contentType="text/html; charset=GBK" %>

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "CompanyComInfo" class = "weaver.hrm.company.CompanyComInfo" scope = "page"/>
<jsp:useBean id = "SubCompanyComInfo" class = "weaver.hrm.company.SubCompanyComInfo" scope = "page"/>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<jsp:useBean id = "ResourceComInfo" class = "weaver.hrm.resource.ResourceComInfo" scope = "page"/>

<%@ include file = "/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
</head>

<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16254,user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
boolean CanAdd = HrmUserVarify.checkUserRight("HrmDefaultScheduleAdd:Add" , user) ; 
%>

<BODY>
<%@ include file = "/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

//搜索
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/schedule/HrmDefaultScheduleAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmDefaultSchedule:Log" , user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+13+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%

String scheduleType = Util.null2String(request.getParameter("scheduleType")) ;
int relatedId= Util.getIntValue(request.getParameter("relatedId"),0);
String relatedName="";
    //获得对象名称
if(scheduleType.equals("3")){
	relatedName=CompanyComInfo.getCompanyname(""+relatedId);
}else if(scheduleType.equals("4")){
	relatedName=SubCompanyComInfo.getSubCompanyname(""+relatedId);
}else if(scheduleType.equals("5")){
	relatedName=DepartmentComInfo.getDepartmentname(""+relatedId);
}else if(scheduleType.equals("6")){
	relatedName=ResourceComInfo.getResourcename(""+relatedId);
}

String sqlWhere=" where 1=1 ";
if(!scheduleType.equals("")){
	sqlWhere+=" and scheduleType='"+scheduleType+"' ";
	if(relatedId>0){
		sqlWhere+=" and  relatedId="+relatedId;
	}
}

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

<FORM id=frmMain name=frmMain method=post action="HrmDefaultScheduleList.jsp">

<%
//    RecordSet.executeProc("HrmSchedule_SelectAll" , "") ; 	
//	while(RecordSet.next()){ 
//		String id = Util.null2String( RecordSet.getString("id") ) ; 
//        String validedatefrom = Util.null2String( RecordSet.getString("validedatefrom") ) ; 
//        String validedateto = Util.null2String( RecordSet.getString("validedateto") ) ; 
		%>
<!--
		<UL><LI> <a href = "HrmDefaultSchedule.jsp?id=<%--=id--%>"><%--=validedatefrom--%> ~ <%--=validedateto--%></a>
		  </li></ul>-->
<%//} %>

<table class=Viewform>
  <tbody>
  <COLGROUP>   
    <COL width="15%">
    <COL width="35%"> 
    <COL width="15%">
    <COL width="35%">

  <tr>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td class=field>
	    <select class=inputstyle  size=1 name=scheduleType style=width:150  onChange="javascript:clearRelatedInfo()">
            <option value="">&nbsp;</option>
            <option value="3" <% if(scheduleType.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
     	    <option value="4" <% if(scheduleType.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
<!--     	    <option value="5" <% if(scheduleType.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
     	    <option value="6" <% if(scheduleType.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>-->
     </select>
    </td>

    <td><span id=spanShowRelatedIdLabel><%if(Util.getIntValue(scheduleType,0)>3){%><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%><%}%></span></td>

    <td class=field>
	    <button class=browser type="button" onClick="javascript:onShowRelatedId()"  name=buttonShowRelatedId <%if(Util.getIntValue(scheduleType,0)<=3){%>style="display:none"<%}%>></button>
	    <span id=relatedNameSpan><%=relatedName%></span>
	    <input name=relatedId type=hidden value="<%=relatedId%>">
    </td>

    <td>
 </tr>  
<TR style="height:2px"><TD class=Line colSpan=6></TD></TR>

  </tbody>
</table>

<table class=ListStyle cellspacing=1 >
<colgroup>  
  <col width="20%">
  <col width="40%">
  <col width="40%">
<tbody>
<tr class=header>  
  <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></td>
</tr>

<%
  String tempId="";
  int tempRelatedId=0;
  String tempRelatedName="";
  String tempScheduleType="";
  String tempScheduleTypeName="";
  String tempValideDateFrom="";
  String tempValideDateTo="";
  String trClass="DataLight";

  String sql = "select id,relatedId,scheduleType,valideDateFrom,valideDateTo from HrmSchedule "+sqlWhere+" order by scheduleType asc,relatedId asc,id desc ";  
  RecordSet.executeSql(sql);	
  while(RecordSet.next()){
   
    tempId = Util.null2String(RecordSet.getString("id"));
    tempRelatedId = Util.getIntValue(RecordSet.getString("relatedId"),0);
    tempScheduleType =   Util.null2String(RecordSet.getString("scheduleType"));
    tempValideDateFrom =   Util.null2String(RecordSet.getString("valideDateFrom"));
    tempValideDateTo =   Util.null2String(RecordSet.getString("valideDateTo"));

    //获得类型名称,对象名称
	if(tempScheduleType.equals("3")){
		tempScheduleTypeName=SystemEnv.getHtmlLabelName(140,user.getLanguage());
	    tempRelatedName=CompanyComInfo.getCompanyname(""+tempRelatedId);
	}else if(tempScheduleType.equals("4")){
		tempScheduleTypeName=SystemEnv.getHtmlLabelName(141,user.getLanguage());
		tempRelatedName=SubCompanyComInfo.getSubCompanyname(""+tempRelatedId);
	}else if(tempScheduleType.equals("5")){
		tempScheduleTypeName=SystemEnv.getHtmlLabelName(124,user.getLanguage());
		tempRelatedName=DepartmentComInfo.getDepartmentname(""+tempRelatedId);
	}else if(tempScheduleType.equals("6")){
		tempScheduleTypeName=SystemEnv.getHtmlLabelName(179,user.getLanguage());
		tempRelatedName=ResourceComInfo.getResourcename(""+tempRelatedId);
	}



%>
	<tr class=<%=trClass%>> 
	
      <td><%=tempScheduleTypeName%></td>
      <td><%=tempRelatedName%></td>
      <td><a href = "HrmDefaultSchedule.jsp?id=<%=tempId%>"><%=tempValideDateFrom%> ~ <%=tempValideDateTo%></a></td>
    </tr>
<%
		  if(trClass.equals("DataLight")){
		      trClass="DataDark";
	      }else{
		      trClass="DataLight";
		  }
}

%>
</tbody>
</table>

</form>


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
</body>
</html>

<script language="javaScript">
	
function onSearch(){
	document.frmMain.submit();
}

function clearRelatedInfo(){
	jQuery("#relatedNameSpan").html("");
	jQuery("input[name=relatedId]").val(0);

	scheduleType = jQuery("select[name=scheduleType]").val();
	if(scheduleType>=4){
		jQuery("button[name=buttonShowRelatedId]").show();
		jQuery("#spanShowRelatedIdLabel").html("<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>");
	}else{
		jQuery("button[name=buttonShowRelatedId]").hide();
		jQuery("#spanShowRelatedIdLabel").html("");
	}
}


function onShowRelatedId(){
	scheduleType = jQuery("select[name=scheduleType]").val();

	if (scheduleType == "4"){
	    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp");
	}else if(scheduleType == "5"){
	         data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
	}else if (scheduleType == "6"){
	              data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	}


	if(data!=null){
	    if (data.id!= ""){
		    jQuery("#relatedNameSpan").html(data.name);
		    jQuery("input[name=relatedId]").val(data.id);
		}else{
		    jQuery("#relatedNameSpan").html("")
		    jQuery("input[name=relatedId]").val("<IMG src = '/images/BacoError.gif' align = absMiddle>");
		}
	}

}

</script>

<script language=vbs>
sub onShowRelatedId1()
	scheduleType = document.all("scheduleType").value

	if scheduleType = "4" then
	    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmMain.relatedId.value)
	else if scheduleType = "5" then
	         id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.relatedId.value)
	     else if scheduleType = "6" then 
	              id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="&frmMain.relatedId.value)
		      end if
		 end if
	end if

	if NOT isempty(id) then
	    if id(0)<> "" then
		    relatedNameSpan.innerHtml = id(1)
		    frmMain.relatedId.value = id(0)
		else
		    relatedNameSpan.innerHtml = ""
		    frmMain.relatedId.value=""
		end if
	end if

end sub
</script>
