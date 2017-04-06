<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WorkflowSubwfSetManager" class="weaver.workflow.workflow.WorkflowSubwfSetManager" scope="page"/>

<%
 if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>

<%

String mainWorkflowId = Util.null2String(request.getParameter("mainWorkflowId"));
String subWorkflowId = Util.null2String(request.getParameter("subWorkflowId"));

String workflowSubwfSetId = Util.null2String(request.getParameter("workflowSubwfSetId"));

//获得主流程的相关信息
WFManager.setWfid(Integer.parseInt(mainWorkflowId));
WFManager.getWfInfo();

String mainWorkflowFormId = String.valueOf(WFManager.getFormid());
String mainWorkflowIsBill = WFManager.getIsBill();

//获得子流程配置的相关信息
String hisSubwfCreatorType="";
String hisSubwfCreatorFieldId="";

RecordSet.executeSql(" select subwfCreatorType,subwfCreatorFieldId from Workflow_SubwfSet where id="+workflowSubwfSetId);
if(RecordSet.next()){
	hisSubwfCreatorType=RecordSet.getString(1);
	hisSubwfCreatorFieldId=RecordSet.getString(2);
}

%>

<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19343, user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(19344, user.getLanguage())+"）" + SystemEnv.getHtmlLabelName(19342,user.getLanguage());
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
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveWorkflowSubwfSetDetail1(this),_self}";
    RCMenuHeight += RCMenuHeightStep ;
 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancelWorkflowSubwfSetDetail(this),_self}";
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
                            <form id="formWorkflowSubwfSetDetail" name="formWorkflowSubwfSetDetail" method="post" action="WorkflowSubwfSetOperation.jsp">      
                              <INPUT type="hidden" Name="operation" value="addSubwfSetDetail">
                              <INPUT type="hidden" Name="mainWorkflowId" value="<%=mainWorkflowId%>">
                              <INPUT type="hidden" Name="subWorkflowId" value="<%=subWorkflowId%>">
                              <INPUT type="hidden" Name="workflowSubwfSetId" value="<%=workflowSubwfSetId%>">

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
    if("1".equals(hisSubwfCreatorType)||"".equals(hisSubwfCreatorType)){
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
    if("2".equals(hisSubwfCreatorType)){
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
    if("3".equals(hisSubwfCreatorType)){
%>
										  checked
<%
    }
%>										 
										 >
										 &nbsp;&nbsp;&nbsp;&nbsp;
										  <select class=inputstyle  name=subwfCreatorFieldId onfocus="changeSubwfCreatorType('subwfCreatorType_3')">
<%
    String sql="";
	String fieldId="";
    if(mainWorkflowIsBill.equals("0")){
	    sql = "select a.id as id,c.fieldlable as name from workflow_formdict a,workflow_formfield b,workflow_fieldlable c where  c.isdefault='1' and c.formid = b.formid  and c.fieldid = b.fieldid and  b.fieldid= a.id and a.fieldhtmltype='3' and (a.type = 1 or a.type=165 ) and (b.isdetail<>'1' or b.isdetail is null) and b.formid="+mainWorkflowFormId;
	}else{
		sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid="+ mainWorkflowFormId+ " and fieldhtmltype = '3' and (type=1 or type=165) " ;
	}
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		fieldId=RecordSet.getString("id");
%>
		                                      <option value=<%=fieldId%> 
<%
	if(fieldId.equals(hisSubwfCreatorFieldId)){
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
                                            <table class="listStyle" id="oTableOfSubwfSetDetail" name="oTableOfSubwfSetDetail">
                                                <colgroup>
                                                <col width="25%">
                                                <col width="25%">
                                                <col width="50%">
                                                <tr class="header">
                                                    <td><%=SystemEnv.getHtmlLabelName(19357,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19358,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19359,user.getLanguage())%></td>
                                                </tr>
                                                <%=WorkflowSubwfSetManager.getSubwfSetDetailTRString(mainWorkflowId,subWorkflowId,workflowSubwfSetId,user.getLanguage())%>
                                                <%=WorkflowSubwfSetManager.getSubwfSetDetailDltTRString(mainWorkflowId,subWorkflowId,workflowSubwfSetId,user.getLanguage())%>
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


