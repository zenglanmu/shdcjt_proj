<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.system.code.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<%
boolean canEdit=true;
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
			  	}
			 	else
			 	{
			 	sql="select id,fieldlabel from workflow_billfield where viewtype=0 and type='1' and fieldhtmltype='1' and billid="+formid;
			 	}


	//初始值
  //CodeBuild cbuild = new CodeBuild(formid); 
  //CodeBuild cbuild = new CodeBuild(formid,isbill);
  CodeBuild cbuild = new CodeBuild(formid,isbill,wfid);  
  boolean hasHistoryCode=cbuild.hasHistoryCode(RecordSet,wfid);
  CoderBean cbean = cbuild.getFlowCBuild();
  ArrayList coderMemberList = cbean.getMemberList();
  String isUse =  cbean.getUserUse();
  String fieldSequenceAlone =  cbean.getFieldSequenceAlone();
  String workflowSeqAlone =  cbean.getWorkflowSeqAlone();
  String dateSeqAlone =  cbean.getDateSeqAlone();
  String dateSeqSelect =  cbean.getDateSeqSelect();
  String struSeqAlone =  cbean.getStruSeqAlone();
  String struSeqSelect =  cbean.getStruSeqSelect();
  
%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowCodeSave(this),_self} " ;
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
<form id="frmCoder" name="frmCoder" method=post action="coderOperation.jsp" >
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
   <COL width="30%">
   <COL width="70%">
       <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TH>
	   </TR>
       <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD>
	   </TR>
       <TR>
                    <TD><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></TD>
                    <TD  class="Field"> <input class="inputStyle" type="checkbox" name="txtUserUse" value="1" <%if ("1".equals(isUse)) out.println("checked");%>>
                    </TD>
       </TR>
       <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<%if(!ajax.equals("1")){%>
       <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
   <TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR>
<TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR>
<%if(isPortalOK){%><!--portal begin-->
<TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR>
<%}%><!--portal end-->
  <tr>
  <TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR>
  <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
          <td colspan="2" align="center" height="15"></td>
        </tr>
<%}%>
          <TR class="Title">
    	  <TH colspan=2><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></th><th>
    	  </TH></TR>
<%if(!ajax.equals("1")){%>
    <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
<%}%>
</table>


<div id="odiv">
 <table class="viewform">
   <COLGROUP>
   <COL width="30%">
   <COL width="70%">
   </COLGROUP>
      <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
  </table>
  <%String fieldid=cbean.getCodeFieldId();
  %>
 <%if(!ajax.equals("1")){%>
  <table class=viewform cellspacing=1  id="oTable">
  <%}else{%>
  <table class=viewform cellspacing=1  id="oTable4port">
 <%}%>
  <COLGROUP>
    <COL width="30%">
  	<COL width="70%">
    	   <tr>
            <td><%=SystemEnv.getHtmlLabelName(19503,user.getLanguage())%></td>
            <td class=Field>
            <select name="selectField">
            <%  
            RecordSet.execute(sql);
            while (RecordSet.next())
            {if (isbill.equals("0"))
              {String htmltype=FieldComInfo.getFieldhtmltype(RecordSet.getString(1));
              String types=FieldComInfo.getFieldType(RecordSet.getString(1));
              if (!(htmltype.equals("1"))||!(types.equals("1"))) continue;
              }
            %>
            <option  <%if (fieldid.equals(RecordSet.getString(1))) {%>selected<%}%>  value=<%=RecordSet.getString(1)%>><%if (isbill.equals("0")) {%><%=RecordSet.getString(2)%>
            <%} else {%>
            <%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%>
            <%}%></option>
            <%}%>
            </select>
             <!-- 编号字段--></td>
</tr> <TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR>
    </table>
    
<table class="viewform">
   <COLGROUP>
   <COL width="30%">
   <COL width="70%">
<TR class="Title">
 <TH colspan=2><%=SystemEnv.getHtmlLabelName(19504,user.getLanguage())%></th><th>
 </TH></TR>
<%if(!ajax.equals("1")){%>
 <TR class="Spacing" style="height: 1px">
 <TD class="Line1" colSpan=2></TD></TR>
<%}%>
</table>	
 <table class="viewform">
   <COLGROUP>
   <COL width="30%">
   <COL width="70%">
   </COLGROUP>
      <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
  </table>
<%if(!ajax.equals("1")){%>
  <table class=viewform cellspacing=1  id="oTable">
  <%}else{%>
  <table class=viewform cellspacing=1  id="oTable4port">
 <%}%>
  <COLGROUP>
    <COL width="30%">
  	<COL width="70%">
     <TR class="Spacing">
    	  <TD colSpan=2>
    	  <TABLE class=ViewForm>
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">         
          <TBODY>
<%
List hisShowNameList =new ArrayList();
hisShowNameList.add("18729");
hisShowNameList.add("445");
hisShowNameList.add("6076");
hisShowNameList.add("18811");



		String SQL = null;

		if("1".equals(isbill)){
			SQL = "select formField.id,fieldLable.labelName as fieldLable "
                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                    + "where fieldLable.indexId=formField.fieldLabel "
                    + "  and formField.billId= " + formid
                    + "  and formField.viewType=0 "
                    + "  and fieldLable.languageid =" + user.getLanguage();
		}else{
			SQL = "select formDict.ID, fieldLable.fieldLable "
                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                    + "and formField.formid = " + formid
                    + " and fieldLable.langurageid = " + user.getLanguage();
		}

        String selectFieldSql=null;
        if("1".equals(isbill)){
        	selectFieldSql = SQL + " and formField.fieldHtmlType = '5' order by formField.dspOrder";
        }else{
            selectFieldSql = SQL + " and formDict.fieldHtmlType = '5' order by formField.fieldorder";
        }
        String subCompanyFieldSql=null;
        if("1".equals(isbill)){
        	subCompanyFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(42,164,169,170) order by formField.dspOrder";
        }else{
            subCompanyFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(42,164,169,170) order by formField.fieldorder";
        }
        String departmentFieldSql=null;
        if("1".equals(isbill)){
        	departmentFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(4,57,167,168) order by formField.dspOrder";
        }else{
            departmentFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(4,57,167,168) order by formField.fieldorder";
        }

        String yearFieldSql=null;
        if("1".equals(isbill)){
        	//yearFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(2,178) order by formField.dspOrder";
        	yearFieldSql = SQL + " and ((formField.fieldHtmlType = '3' and formField.type in(2,178))or(formField.fieldHtmlType = '5' and exists(select 1 from workflow_selectitem where isBill="+isbill+" and workflow_selectitem.fieldId=formField.id and selectName>'1900' and selectName<'2099'))) order by formField.dspOrder";
        }else{
            //yearFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(2,178) order by formField.fieldorder";
            yearFieldSql = SQL + " and ((formDict.fieldHtmlType = '3' and formDict.type in(2,178))or(formDict.fieldHtmlType = '5' and exists(select 1 from workflow_selectitem where isBill="+isbill+" and workflow_selectitem.fieldId=formDict.id and selectName>'1900' and selectName<'2099'))) order by formField.fieldorder";
        }

        String monthFieldSql=null;
        if("1".equals(isbill)){
        	monthFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(2) order by formField.dspOrder";
        }else{
            monthFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(2) order by formField.fieldorder";
        }

        String dateFieldSql=null;
        if("1".equals(isbill)){
        	dateFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(2) order by formField.dspOrder";
        }else{
            dateFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(2) order by formField.fieldorder";
        }

int tempFieldId=0;
int selectFieldId=0;
%>
          <%for (int i=0;i<coderMemberList.size();i++){
                 String[] codeMembers = (String[])coderMemberList.get(i);
                 String codeMemberName = codeMembers[0];
                 String codeMemberValue = codeMembers[1];
                 String codeMemberType = codeMembers[2];
				 
				 if(hasHistoryCode&&hisShowNameList.indexOf(codeMemberName)==-1){
					 continue;
				 }
             %>
                <TR id="TR_<%=i%>" customer1="member">
                    <TD codevalue="<%=codeMemberName%>">
                     
                     <%if (canEdit){%>
                       <a href="javaScript:imgUpOnclick(<%=i%>)">
                       <img id="img_up_<%=i%>" <%if (i==0) {%>style="visibility:hidden;width=0"  <%}%> name="img_up" src='/images/ArrowUpGreen.gif' title='<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>' border=0></a>
                       &nbsp;
                       <a href="javaScript:imgDownOnclick(<%=i%>)">
                       <%%><img id="img_down_<%=i%>"  <%if (i==coderMemberList.size()-1) {%>style="visibility:hidden;width=0" <%}%> name ="img_down" src='/images/ArrowDownRed.gif' title='<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>' border=0></a>              
                       &nbsp;
                       <%}%>
                      <%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage()) %>
                    </TD>
                    <TD class="Field">
                      <%
                         if ("1".equals(codeMemberType)){   //1:checkbox
                           if ("1".equals(codeMemberValue)){
                             if (canEdit){
                              out.println("<input id=chk_"+i+" type=checkbox class=inputstyle checked value=1  onclick=proView()>");
                             } else {
                              out.println("<div>"+SystemEnv.getHtmlLabelName(160,user.getLanguage())+"</div>");
                             }
                           } else {
                              if (canEdit){
                                out.println("<input id=chk_"+i+" type=checkbox class=inputstyle  value=1  onclick=proView()>");
                               } else {
                                out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
                               }                              
                           }
                         } else if ("2".equals(codeMemberType)){   //2:input
                              if (canEdit){%>
                                 <input type=text name="inputt<%=i%>" <%if (codeMemberName.equals("18811")) {%> onchange='checkint("inputt<%=i%>");proView();'<%} else {%>onchange=proView()<%}%> class=inputstyle   value="<%=codeMemberValue%>">
                              <% } else {
                                  out.println("<div>"+codeMemberValue+"</div>");
                               } 
                             
                         } else if ("5".equals(codeMemberType)){   //5:select
                                if (canEdit){
									if("22755".equals(codeMemberName)){
%>
                                            <SELECT class=inputstyle name="fieldSequenceAlone_<%=i%>" onclick="proView();changeTrFieldSequenceAlone(this)">
                                                <OPTION value=-1></OPTION>
                                            <%
                                                RecordSet.executeSql(selectFieldSql);  
                                                while(RecordSet.next()){
                                                    tempFieldId = RecordSet.getInt("ID");
													selectFieldId=tempFieldId;
                                            %>
                                                    <OPTION value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<A HREF="#" onClick="shortNameSetting(tab10, <%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%></A>
<% 
									}else if("22753".equals(codeMemberName)){
%>
                                            <SELECT class=inputstyle name="fieldSequenceAlone_<%=i%>" onclick="proView()">
                                                <OPTION value=-1></OPTION>
                                                <OPTION value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22787,user.getLanguage())%></OPTION>
                                            <%
                                                RecordSet.executeSql(subCompanyFieldSql);
                                                while(RecordSet.next()){
                                                    tempFieldId = RecordSet.getInt("ID");
                                            %>
                                                    <OPTION value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<A HREF="#" onClick="supSubComAbbr(tab10, <%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%></A>
<%
									}else if("141".equals(codeMemberName)){
%>
                                            <SELECT class=inputstyle name="fieldSequenceAlone_<%=i%>" onclick="proView()">
                                                <OPTION value=-1></OPTION>
                                                <OPTION value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22788,user.getLanguage())%></OPTION>
                                            <%
                                                RecordSet.executeSql(subCompanyFieldSql);  
                                                while(RecordSet.next()){
                                                    tempFieldId = RecordSet.getInt("ID");
                                            %>
                                                    <OPTION value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<A HREF="#" onClick="subComAbbr(tab10, <%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%></A>
<%
									}else if("124".equals(codeMemberName)){
%>
                                            <SELECT class=inputstyle name="fieldSequenceAlone_<%=i%>" onclick="proView()">
                                                <OPTION value=-1></OPTION>
                                                <OPTION value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(19225,user.getLanguage())%></OPTION>
                                            <%
                                                RecordSet.executeSql(departmentFieldSql);										
                                                while(RecordSet.next()){
                                                    tempFieldId = RecordSet.getInt("ID");
                                            %>
                                                    <OPTION value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<A HREF="#" onClick="deptAbbr(tab10, <%= wfid %>, <%= formid %>, <%= isbill %>,<%= "".equals(codeMemberValue)?"-1":codeMemberValue %>)"><%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%></A>
<%
									}else if("445".equals(codeMemberName)){//年
%>
                                            <SELECT class=inputstyle name="fieldSequenceAlone_<%=i%>" onclick="proView()">
                                                <OPTION value=-1></OPTION>
                                                <OPTION value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22793,user.getLanguage())%></OPTION>
                                            <%
                                                RecordSet.executeSql(yearFieldSql);										
                                                while(RecordSet.next()){
                                                    tempFieldId = RecordSet.getInt("ID");
                                            %>
                                                    <OPTION value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
<%
									}else if("6076".equals(codeMemberName)){//月
%>
                                            <SELECT class=inputstyle name="fieldSequenceAlone_<%=i%>" onclick="proView()">
                                                <OPTION value=-1></OPTION>
                                                <OPTION value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(22794,user.getLanguage())%></OPTION>
                                            <%
                                                RecordSet.executeSql(monthFieldSql);										
                                                while(RecordSet.next()){
                                                    tempFieldId = RecordSet.getInt("ID");
                                            %>
                                                    <OPTION value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
<%
									}else if("390".equals(codeMemberName)||"16889".equals(codeMemberName)){//日
%>
                                            <SELECT class=inputstyle name="fieldSequenceAlone_<%=i%>" onclick="proView()">
                                                <OPTION value=-1></OPTION>
                                                <OPTION value=-2 <% if(("-2").equals(codeMemberValue)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(15625,user.getLanguage())%></OPTION>
                                            <%
                                                RecordSet.executeSql(dateFieldSql);										
                                                while(RecordSet.next()){
                                                    tempFieldId = RecordSet.getInt("ID");
                                            %>
                                                    <OPTION value=<%= tempFieldId %> <% if((""+tempFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
<%
									}
                                } else {
                                  //out.println("<div>"+codeMemberValue+"</div>");
                               } 
 %>
	 
 <%
                         }  
                    %>
                    </TD>                   
                </TR>  
                <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>
<%if(!hasHistoryCode){%>

            	<TR id=trFieldSequenceAlone <%if(selectFieldId<=0){%>style="display:none"<%}%>>
            		<TD><%=SystemEnv.getHtmlLabelName(22215,user.getLanguage())%></TD>
					<TD class="Field"><input class="inputStyle" type="checkbox" name="fieldSequenceAlone" value="1" <%if ("1".equals(fieldSequenceAlone)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
					</TD>
            	</TR>
            	<TR id=trLineFieldSequenceAlone <%if(selectFieldId<=0){%>style="display:none;height: 1px;"<%}else{%>style="height: 1px"<%} %> ><TD class=Line colSpan=2></TD></TR>

            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(21189,user.getLanguage())%></TD>
					<TD class="Field"><input class="inputStyle" type="checkbox" name="workflowSeqAlone" value="1" <%if ("1".equals(workflowSeqAlone)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
					</TD>
            	</TR>
            	<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>

            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(19418,user.getLanguage())%></TD>
					<TD class="Field">
						<input class="inputStyle" type="checkbox" name="dateSeqAlone" value="1" <%if ("1".equals(dateSeqAlone)) out.println("checked");%> >&nbsp;
						<input class="inputStyle" type="radio" name="dateSeqSelect" value="1" <%if ("1".equals(dateSeqSelect)||"".equals(dateSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="dateSeqSelect" value="2" <%if ("2".equals(dateSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="dateSeqSelect" value="3" <%if ("3".equals(dateSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
						
					</TD>
            	</TR>
            	<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>

            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(22756,user.getLanguage())%></TD>
					<TD class="Field">
						<input class="inputStyle" type="checkbox" name="struSeqAlone" value="1" <%if ("1".equals(struSeqAlone)) out.println("checked");%> >&nbsp;
						<input class="inputStyle" type="radio" name="struSeqSelect" value="1" <%if ("1".equals(struSeqSelect)||"".equals(struSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="struSeqSelect" value="2" <%if ("2".equals(struSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="struSeqSelect" value="3" <%if ("3".equals(struSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
						
					</TD>
            	</TR>
            	<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<%}%>
                 <TR>
                    <TD><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></TD>
                    <TD class="Field"> 
                      <table border="1" cellspacing="0" cellpadding="0">
                        <tr id="TR_pro"></tr>
                        
                      </table>
                    </TD>
                 </TR>
                 <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<%
if(!hasHistoryCode){
	RecordSet.execute("select 1 from workflow_Code where (formId="+formid+" and isBill='"+isbill+"') or (flowId="+wfid+" and workflowSeqAlone='1')");
	if(RecordSet.next()){
%>

                 <TR>
                    <TD><A HREF="#" onClick="codeSeqSet(tab10, <%= wfid %>, <%= formid %>, <%= isbill %>)"><%=SystemEnv.getHtmlLabelName(20578,user.getLanguage())%></A></TD>
                    <TD><A HREF="#" onClick="codeSeqReservedSet(tab10, <%= wfid %>, <%= formid %>, <%= isbill %>)"><%=SystemEnv.getHtmlLabelName(22779,user.getLanguage())%></A></TD>
                 </TR>
                 <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<%
	}
}
%>
          </TBODY>
        </td>
        </tr>
        </TABLE>
    	  
    	  </TD></TR>   	  
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
    <INPUT TYPE="hidden" NAME="postValue" id="postValue">
    <INPUT TYPE="hidden" NAME="formid" value="<%=formid%>">
    <INPUT TYPE="hidden" NAME="isBill" value="<%=isbill%>">    
<center>
</form>
</div>


</body>

</html>