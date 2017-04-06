<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<jsp:useBean id="WorkflowTriDiffWfManager" class="weaver.workflow.workflow.WorkflowTriDiffWfManager" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<%
 if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>

<%

int triDiffWfDiffFieldId = Util.getIntValue(request.getParameter("triDiffWfDiffFieldId"),0);
int triDiffWfSubWfId = Util.getIntValue(request.getParameter("triDiffWfSubWfId"),0);
int fieldValue = Util.getIntValue(request.getParameter("fieldValue"),0);
int subWorkflowId = Util.getIntValue(request.getParameter("subWorkflowId"),0);
int isRead = Util.getIntValue(request.getParameter("isRead"),0);

int mainWorkflowId = Util.getIntValue(request.getParameter("mainWorkflowId"),0);

String mainWorkflowFormId = WorkflowComInfo.getFormId(""+mainWorkflowId);
String mainWorkflowIsBill = WorkflowComInfo.getIsBill(""+mainWorkflowId);


//获得子流程配置的相关信息
String subwfCreatorType="";
int subwfCreatorFieldId=0;

RecordSet.executeSql(" select subwfCreatorType,subwfCreatorFieldId from Workflow_TriDiffWfSubWf where id="+triDiffWfSubWfId);
if(RecordSet.next()){
	subwfCreatorType=Util.null2String(RecordSet.getString("subwfCreatorType"));
	subwfCreatorFieldId=Util.getIntValue(RecordSet.getString("subwfCreatorFieldId"),0);
}

%>

<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19343, user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(19357, user.getLanguage())+"）" + SystemEnv.getHtmlLabelName(19342,user.getLanguage());
    String needfav = "";
    String needhelp = "";
%>
<html>
<HEAD> 
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>

<body>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveWorkflowTriDiffWfSubWfField(this),_self}";
    RCMenuHeight += RCMenuHeightStep ;
 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancelWorkflowTriDiffWfSubWfField(this,"+triDiffWfDiffFieldId+"),_self}";
    RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu1.jsp" %>

<%    
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
                            <form id="formWorkflowTriDiffWfSubWfField" name="formWorkflowTriDiffWfSubWfField" method="post" action="WorkflowTriDiffWfSubWfFieldOperation.jsp">
                              <INPUT type="hidden" Name="triDiffWfDiffFieldId" value="<%=triDiffWfDiffFieldId%>">
                              <INPUT type="hidden" Name="triDiffWfSubWfId" value="<%=triDiffWfSubWfId%>">
                              <INPUT type="hidden" Name="fieldValue" value="<%=fieldValue%>">
                              <INPUT type="hidden" Name="subWorkflowId" value="<%=subWorkflowId%>">
                              <INPUT type="hidden" Name="isRead" value="<%=isRead%>">

                              <INPUT type="hidden" Name="operation" value="addTriDiffWfSubWfField">




                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="35%">
                                <COL width="65%">
                                <TBODY>
                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(19352,user.getLanguage())%></B></TD>
									 </TR>								
                                     <TR class=Spacing style="height:1px;">
									     <TD class=Line1 colSpan=2></TD>
									 </TR>
                                     <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(19353,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">
										  <input type=radio name=subwfCreatorType id=subwfCreatorType_1 value="1" 
<%
    if("1".equals(subwfCreatorType)||"".equals(subwfCreatorType)){
%>
										  checked
<%
    }
%>
										  >
										</TD>		
                                     </TR>
                                     <TR style="height:1px;">
                                         <TD class=Line colSpan=2>
										 
										 </TD>
                                     </TR>
                                     <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(19354,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field"> 
										 <input type=radio name=subwfCreatorType id=subwfCreatorType_2 value="2" 
<%
    if("2".equals(subwfCreatorType)){
%>
										  checked
<%
    }
%>										 
										 >			
                                        </TD>		
                                     </TR>
                                     <TR style="height:1px;">
                                         <TD class=Line colSpan=2></TD>
                                     </TR>
                                     <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(19355,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field"> 
										 <input type=radio name=subwfCreatorType id=subwfCreatorType_3 value="3"
<%
    if("3".equals(subwfCreatorType)){
%>
										  checked
<%
    }
%>										 
										 >
										 &nbsp;&nbsp;&nbsp;&nbsp;
										  <select class="inputstyle" name="subwfCreatorFieldId" onfocus="changeSubwfCreatorType('subwfCreatorType_3')">
<%
    String sql="";
	int fieldId=0;
    if(mainWorkflowIsBill.equals("0")){
	    sql = "select a.id as id,c.fieldlable as name from workflow_formdict a,workflow_formfield b,workflow_fieldlable c where  c.isdefault='1' and c.formid = b.formid  and c.fieldid = b.fieldid and  b.fieldid= a.id and a.fieldhtmltype='3' and (a.type = 1 or a.type=17 or a.type=141 or a.type=142 or a.type=166 ) and (b.isdetail<>'1' or b.isdetail is null) and b.formid="+mainWorkflowFormId;
	}else{
		sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid="+ mainWorkflowFormId+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=141 or type=142 or type=166) " ;
	}
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		fieldId=Util.getIntValue(RecordSet.getString("id"),0);
%>
		                                      <option value=<%=fieldId%> 
<%
	if(fieldId==subwfCreatorFieldId){
%>
	                                           selected
<%
    }
%>
                                              >
<%
    	if(mainWorkflowIsBill.equals("0")) {
%> 
	                                            <%=RecordSet.getString("name")%>
<%
    	} else {
%>
	                                            <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%>
<%
    	}
%>
	                                           </option>
<%
	}
%>


                                         </select>
                                        </TD>		
                                     </TR>
                                     <TR>
                                         <TD height="10" colspan="5"></TD>
                                     </TR>
                                </TBODY>
                              </TABLE>
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>
                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(19356,user.getLanguage())%></B></TD>
									 </TR>								
                                     <TR class=Spacing style="height:1px;">
									     <TD class=Line1 colSpan=2></TD>
									 </TR>
                                   <tr>
                                        <td colspan=2>
                                            <table class="listStyle" id="oTableOfTriDiffWfSubWfField" name="oTableOfTriDiffWfSubWfField">
                                                <colgroup>
                                                <col width="25%">
                                                <col width="25%">
                                                <col width="25%">
                                                <col width="25%">
                                                <tr class="header">
                                                    <td><%=SystemEnv.getHtmlLabelName(19357,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19358,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(21577,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19359,user.getLanguage())%></td>
                                                </tr>
                                                <%=WorkflowTriDiffWfManager.getTriDiffWfFieldTRString(mainWorkflowId,subWorkflowId,triDiffWfSubWfId,user.getLanguage())%>
                                                <%=WorkflowTriDiffWfManager.getTriDiffWfFieldDetailTRString(mainWorkflowId,subWorkflowId,triDiffWfSubWfId,user.getLanguage())%>
                                            </table>
                                        </td>
                                   </tr>
                                </TBODY>
                            </TABLE>
                        </td>
                    </tr>
                </TABLE>
                </form>
            </td>
            <td></td>
        </tr>
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
        </table>

</body>
</html>


