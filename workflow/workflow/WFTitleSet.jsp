<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<%

if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

%>
<html>
<%



	String isbill = "";
	int wfid=0;
	int formid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	String sql="";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }
   
   if (isbill.equals("0"))
  	{
   	sql="select workflow_formfield.fieldid, workflow_fieldlable.fieldlable from workflow_formfield,workflow_fieldlable where workflow_formfield.fieldid=workflow_fieldlable.fieldid and workflow_fieldlable.formid=workflow_formfield.formid  and workflow_fieldlable.formid="+formid+" and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and langurageid="+user.getLanguage();
   	//TD8709
   	sql += " order by workflow_formfield.isdetail desc, workflow_formfield.groupid, workflow_formfield.fieldorder";
  	}
 	else
 	{
 	sql="select id,fieldlabel from workflow_billfield where viewtype=0 and billid="+formid;
 	//TD8709
 	sql += " order by viewtype,detailtable,dsporder";
 	}
	   				
%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<style type="text/css">
#simpleTooltip { padding: 7px; border: 1px solid #A6A7AB!important; background: #F2F3F5!important; }
</style>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<body>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
if(operatelevel>0){
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowTitleSave2(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
    if(!ajax.equals("1")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;

RCMenuHeight += RCMenuHeightStep;
    }
%>

<%
if(!ajax.equals("1")){
if(RecordSet.getDBType().equals("db2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=88 and relatedid="+wfid+",_self} " ;
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=88 and relatedid="+wfid+",_self} " ;

}

RCMenuHeight += RCMenuHeightStep ;
    }
    }
%>
<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<form id="flowTitleForm" name="flowTitleForm" method=post action="WorkFlowTitleSetOperation.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}%>
<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
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

   <table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
<%if(!ajax.equals("1")){%>
       <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
   <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
<TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
<%if(isPortalOK){%><!--portal begin-->
<TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
<%}%><!--portal end-->
  <tr>
  <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
  <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
          <td colspan="2" align="center" height="15"></td>
        </tr>
<%}%>
          <TR class="Title">
    	  <TH colspan=2><%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%></th><th>
    	  </TH></TR>
<%if(!ajax.equals("1")){%>
    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
<%}%>
</table>


<div id="odiv">
 <table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
      <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
  </table>
  <%String fieldid="";
  RecordSet.execute("select * from workflow_TitleSet where flowid="+wfid +" order by gradation");
  while(RecordSet.next())
  {
  fieldid += RecordSet.getString("fieldid")+",";
  
  }
  %>
 <%if(!ajax.equals("1")){%>
  <table class=viewform cellspacing=1  id="oTable">
  <%}else{%>
  <table class=viewform cellspacing=1  id="oTable4port">
 <%}%>
  <COLGROUP>
    <COL width="40%">
  	<COL width="20%">
  	<COL width="40%">
  			<tr class=header>
			    <td align=center class=field><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></td>
			    <td align=center class=field><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>    
			    <td align=center class=field><%=SystemEnv.getHtmlLabelName(15448,user.getLanguage())%></td>
		    </tr>
		    <tr>
			    <td vaglin="middle">
				<select class=inputstyle  size="15" name="srcList" multiple style="width:100%" onchange="showtitle(event)" ondblclick="addSrcToDestListTit()">
				<%
					RecordSet.execute(sql);
					while (RecordSet.next()){
				%>
					<option class="vtip" title="<%if(isbill.equals("0")){%><%=RecordSet.getString(2)%><%}else{%><%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%><%}%>" value=<%=RecordSet.getString(1)%>><%if(isbill.equals("0")){%><%=RecordSet.getString(2)%><%}else{%><%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%><%}%></option>
				<%}%>
				</select>
			    </td>
			    <td align=center>
					<img src="/images/arrow_r.gif"  title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onClick="javascript:addSrcToDestListTit();">
					<br><br>
					<br><br>
					<img src="/images/arrow_l.gif" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="javascript:deleteFromDestListTit();">
			    </td>
			    <td align=center>
					<select class=inputstyle  size=15 name="destList" multiple style="width:100%" onchange="showtitle(event)" ondblclick="deleteFromDestListTit()">
					<%
					ArrayList fieldids = Util.TokenizerString(fieldid,",");
					RecordSet.execute(sql);
					if(fieldids!=null && fieldids.size()>0){
  						for(int i=0;i<fieldids.size();i++){
							while(RecordSet.next()){
								if(fieldids.get(i).toString().equals(RecordSet.getString(1))){
					%>
					<option class="vtip" title="<%if(isbill.equals("0")){%><%=RecordSet.getString(2)%><%}else{%><%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%><%}%>" value=<%=RecordSet.getString(1)%>><%if(isbill.equals("0")){%><%=RecordSet.getString(2)%><%}else{%><%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%><%}%></option>
					<%
								}
							}
							RecordSet.beforFirst();
						}
					}
					%>
					</select>
				  </td>
		  	</tr> 
		  	<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=3></TD></TR>
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

<br>
<center>
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="" name="postvalues">
<center>
</form>
</div>

<%if(!ajax.equals("1")){%>
<script language="JavaScript" src="/js/addRowBg.js" >
</script>
<script language=javascript>

function selectall(){
	
	window.document.flowTitleForm.submit();
}


</script>
<%}%>
</body>
</html>