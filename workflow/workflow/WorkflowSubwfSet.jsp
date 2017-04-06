<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowSubwfSetManager" class="weaver.workflow.workflow.WorkflowSubwfSetManager" scope="page"/>


<%
 if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>

<%

String mainWorkflowId = Util.null2String(request.getParameter("wfid"));

%>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "£º" + SystemEnv.getHtmlLabelName(19343, user.getLanguage())+"£¨"+SystemEnv.getHtmlLabelName(19344, user.getLanguage())+"£©";
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


<%@ include file="/systeminfo/RightClickMenu1.jsp" %>

<% 
int mainWorkflowFormId=0;
String mainWorkflowIsBill="";
String isTriDiffWorkflow="0";
RecordSet.executeSql("select formId,isBill,isTriDiffWorkflow from workflow_base where id="+mainWorkflowId);
if(RecordSet.next()){
	mainWorkflowFormId=Util.getIntValue(RecordSet.getString("formId"),0);
	mainWorkflowIsBill=Util.null2String(RecordSet.getString("isBill"));
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"));
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
                            <form name="formWorkflowSubwfSet" method="post">      
                              <INPUT type="hidden" Name="mainWorkflowId" value="<%=mainWorkflowId%>">

                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>
                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(21578,user.getLanguage())%></B></TD>
									 </TR>								
                                     <TR class=Spacing  style="height:1px;">
									     <TD class=Line1 colSpan=2></TD>
									 </TR>
                                     <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(21579,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                             <input class="inputStyle" type="radio" name="isTriDiffWorkflow" value="0" <%if (!"1".equals(isTriDiffWorkflow)) out.println("checked");%>  onclick="showSubwfSetContent(0)">       
                                        </TD>		
                                     </TR>

                                     <TR  style="height:1px;">
                                         <TD class=Line colSpan=2></TD>
                                     </TR>
                                     <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(21580,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                             <input class="inputStyle" type="radio" name="isTriDiffWorkflow" value="1" <%if ("1".equals(isTriDiffWorkflow)) out.println("checked");%>  onclick="showSubwfSetContent(1)">                                         
                                        </TD>		
                                     </TR>
                                    <TR  style="height:1px;">
                                      <TD class=Line colSpan=2></TD>
									</TR>
                                    <TR>
                                        <TD height="15" colspan="2"></TD>
                                    </TR>								
                                </TBODY>
                              </TABLE>
      <DIV id="subwfSetContentDivSame" 
<%
    if(!"1".equals(isTriDiffWorkflow)) { 
%> style="display:block" 
<%
    } else {
%> style="display:none" 
<%
    }
%>
    >
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>
                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(19345,user.getLanguage())%></B></TD>
									 </TR>								
                                     <TR class=Spacing  style="height:1px;">
									     <TD class=Line1 colSpan=2></TD>
									 </TR>
                                     <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(22050,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                            <SELECT class=InputStyle  name=triggerType  onChange="changeTriggerTypeAndOperation()">   
                                                <option value="1" ><%=SystemEnv.getHtmlLabelName(22051,user.getLanguage())%></option> 
                                                <option value="2" ><%=SystemEnv.getHtmlLabelName(22052,user.getLanguage())%></option>
                                            </SELECT>                                        
                                        </TD>		
                                     </TR>
                                     <TR  style="height:1px;">
                                      <TD class=Line colSpan=2></TD>
									 </TR>
                                     <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(19346,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                            <SELECT class=InputStyle  name=triggerNodeId   onChange="changeTriggerTypeAndOperation()">    
<%
                                                RecordSet.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and  a.workFlowId= "+mainWorkflowId+"  order by a.nodeType,a.nodeId  ");
												while(RecordSet.next()) {
%>
                                                <option value="<%=Util.null2String(RecordSet.getString("triggerNodeType"))%>_<%=Util.null2String(RecordSet.getString("triggerNodeId"))%>"><%=Util.null2String(RecordSet.getString("triggerNodeName"))%></option>
<%
	                                            }
%>

                                            </SELECT>                                        
                                        </TD>		
                                     </TR>

                                     <TR  style="height:1px;">
                                         <TD class=Line colSpan=2></TD>
                                     </TR>

                                     <TR id=trTriggerTime style="display:">
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(19347,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                            <SELECT class=InputStyle  name=triggerTime  onChange="changeTriggerTypeAndOperation()">   
                                                <option value="1" ><%=SystemEnv.getHtmlLabelName(19348,user.getLanguage())%></option> 
                                                <option value="2" selected><%=SystemEnv.getHtmlLabelName(19349,user.getLanguage())%></option>
                                            </SELECT>                                        
                                        </TD>		
                                     </TR>
                                    <TR id=trTriggerTimeLine   style="height:1px;">
                                      <TD class=Line colSpan=2></TD>
									</TR>
									
                                     <TR id=trTriggerOperation style="display:none">
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(22053,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                            <SELECT class=InputStyle  name=triggerOperation  onChange="triggerOperationSelected()">
                                                <option value="" ></option>									
                                                <option value="1" ><%=SystemEnv.getHtmlLabelName(25361,user.getLanguage())%></option> 
                                                <option value="2" ><%=SystemEnv.getHtmlLabelName(25362,user.getLanguage())%></option>
                                            </SELECT>                                        
                                        </TD>		
                                     </TR>
                                     <input type="hidden" name="trTriggerOperationHidden" id="trTriggerOperationHidden" value=""/>
                                     <TR id=trTriggerOperationNew style="display:none">
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(22053,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                            <SELECT class=InputStyle  name=triggerOperationNew  onChange="triggerOperationSelected()">
                                                <option value="" ></option>									
                                                <option value="3" ><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option> 
                                                <option value="4" ><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
                                            </SELECT>                                        
                                        </TD>		
                                     </TR>
                                    <TR id=trTriggerOperationLine  style="display:none;height:1px;">
                                      <TD class=Line colSpan=2></TD>
									</TR>									

                                    <TR >
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(21257,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                           <SELECT class=InputStyle  name=isread>
                                              <OPTION value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></OPTION>
                                              <OPTION value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></OPTION>
                                           </select>                                             
                                        </TD>		
                                    </TR>
                                    
                                    <TR  style="height:1px;">
                                      <TD class=Line colSpan=2></TD>
									</TR>
                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(19344,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                            <button type="button" class=Browser style="display:''" onClick="onShowWorkFlowNeededValid('subWorkflowId','subWorkflowNameSpan')" name=showresource></BUTTON> 
                                            <INPUT type=hidden name=subWorkflowId  id="subWorkflowId" value="">
                                            <span id=subWorkflowNameSpan name=subWorkflowNameSpan><IMG src='/images/BacoError.gif' align=absMiddle></span>                                            
                                        </TD>		
                                    </TR>                                 
                                    <TR  style="height:1px;">
                                      <TD class=Line colSpan=2></TD>
									</TR>
                                </TBODY>
                              </TABLE>
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>

                                    <tr>
                                        <TD  colspan=2>
                                           <TABLE  width="100%">
                                            <TR>
                                                <TD width="40%"></TD>
                                                <TD width="20%"><img src="/images/arrow_d.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addValue()" border="0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" border="0" onclick="removeValue()"></TD>
                                                <TD width="40%"></TD>
                                            </TR>
                                           </TABLE>
                                        </TD>
                                    <tr>
                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(19350,user.getLanguage())%></B></TD>
									 </TR>								
                                     <TR class=Spacing  style="height:1px;">
									     <TD class=Line1 colSpan=2></TD>
									 </TR>
                                   <tr>
                                        <td colspan=2>
                                            <table class="listStyle" id="oTable" name="oTable">
                                                <colgroup>
                                                <col width="4%">
                                                <col width="20%">
                                                <col width="10%">
                                                <col width="10%">
                                                <col width="10%">
                                                <col width="20%">
                                                <col width="16%">
                                                <col width="10%">

                                                <tr class="header">
                                                    <td><input type="checkbox" name="chkAll" onclick="chkAllClick(this)"></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(22050,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19346,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19347,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(22053,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19351,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(21257,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></td>
                                                </tr>
                                                <tr style="height:1px;"><td colspan="8" class="Line"></td></tr>
                                                    <%=WorkflowSubwfSetManager.getSubwfSetTRString(mainWorkflowId,user.getLanguage())%>
                                            </table>
                                        </td>
                                   </tr>
                                </TBODY>
                            </TABLE>
</div>
      <DIV id="subwfSetContentDivDiff" 
<%
    if("1".equals(isTriDiffWorkflow)) { 
%> style="display:block" 
<%
    } else {
%> style="display:none" 
<%
    }
%>
    >
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>
                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(21581,user.getLanguage())%></B></TD>
									 </TR>								
                                     <TR class=Spacing  style="height:1px;">
									     <TD class=Line1 colSpan=2></TD>
									 </TR>
                                     <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(22050,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                            <SELECT class=InputStyle  name=triggerTypeDiff  onChange="changeTriggerTypeAndOperationDiff()">   
                                                <option value="1" ><%=SystemEnv.getHtmlLabelName(22051,user.getLanguage())%></option> 
                                                <option value="2" ><%=SystemEnv.getHtmlLabelName(22052,user.getLanguage())%></option>
                                            </SELECT>                                        
                                        </TD>		
                                     </TR>
                                     <TR  style="height:1px;">
                                      <TD class=Line colSpan=2></TD>
									 </TR>
                                     <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(19346,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                            <SELECT class=InputStyle  name=triggerNodeIdDiff  onChange="changeTriggerTypeAndOperationDiff()">    
<%
                                                RecordSet.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and  a.workFlowId= "+mainWorkflowId+"  order by a.nodeType,a.nodeId  ");
												while(RecordSet.next()) {
%>
                                                <option value="<%=Util.null2String(RecordSet.getString("triggerNodeType"))%>_<%=Util.null2String(RecordSet.getString("triggerNodeId"))%>"><%=Util.null2String(RecordSet.getString("triggerNodeName"))%></option>
<%
	                                            }
%>

                                            </SELECT>                                        
                                        </TD>		
                                     </TR>

                                     <TR  style="height:1px;">
                                         <TD class=Line colSpan=2></TD>
                                     </TR>



                                     <TR id=trTriggerTimeDiff style="display:">
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(19347,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                            <SELECT class=InputStyle  name=triggerTimeDiff  onChange="changeTriggerTypeAndOperationDiff()">   
                                                <option value="1" ><%=SystemEnv.getHtmlLabelName(19348,user.getLanguage())%></option> 
                                                <option value="2" selected><%=SystemEnv.getHtmlLabelName(19349,user.getLanguage())%></option>
                                            </SELECT>                                        
                                        </TD>		
                                     </TR>
                                    <TR id=trTriggerTimeLineDiff style="height:1px;">
                                      <TD class=Line colSpan=2></TD>
									</TR>
                                    
                                     <TR id=trTriggerOperationDiff style="display:none">
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(22053,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                            <SELECT class=InputStyle  name=triggerOperationDiff  onChange="triggerOperationDiffSelected()">
                                                <option value="" ></option>									
                                                <option value="1" ><%=SystemEnv.getHtmlLabelName(25361,user.getLanguage())%></option> 
                                                <option value="2" ><%=SystemEnv.getHtmlLabelName(25362,user.getLanguage())%></option>
                                            </SELECT>                                        
                                        </TD>		
                                     </TR>
                                     <input type="hidden" name="trTriggerOperationDiffHidden" id="trTriggerOperationDiffHidden" value=""/>
                                     <TR id=trTriggerOperationDiffNew style="display:none">
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(22053,user.getLanguage())%>
                                        </TD>                                            
                                        <TD class="field">                                           
                                            <SELECT class=InputStyle  name=triggerOperationDiffNew  onChange="triggerOperationDiffSelected()">
                                                <option value="" ></option>									
                                                <option value="3" ><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option> 
                                                <option value="4" ><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
                                            </SELECT>                                        
                                        </TD>		
                                     </TR>
                                    <TR id=trTriggerOperationLineDiff  style="display:none;height:1px;">
                                      <TD class=Line colSpan=2></TD>
									</TR>

                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(21582,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
										  <select class=inputstyle  name=fieldIdDiff>
<%
    String sql="";
	String fieldId="";
    if(mainWorkflowIsBill.equals("0")){
	    sql = "select a.id as id,c.fieldlable as name from workflow_formdict a,workflow_formfield b,workflow_fieldlable c where  c.isdefault='1' and c.formid = b.formid  and c.fieldid = b.fieldid and  b.fieldid= a.id and a.fieldhtmltype='3' and (a.type=17 or a.type=141 or a.type=142 or a.type=166 ) and (b.isdetail<>'1' or b.isdetail is null) and b.formid="+mainWorkflowFormId+" order by a.id asc";
	}else{
		sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid="+ mainWorkflowFormId+ " and fieldhtmltype = '3' and (type=17 or type=141 or type=142 or type=166) order by id asc" ;
	}
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		fieldId=RecordSet.getString("id");
%>
		                                      <option value=<%=fieldId%> >
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
                                    <TR  style="height:1px;">
                                      <TD class=Line colSpan=2></TD>
									</TR>
                                </TBODY>
                              </TABLE>
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>

                                    <tr>
                                        <TD  colspan=2>
                                           <TABLE  width="100%">
                                            <TR>
                                                <TD width="40%"></TD>
                                                <TD width="20%"><img src="/images/arrow_d.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addValueDiff()" border="0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" border="0" onclick="removeValueDiff()"></TD>
                                                <TD width="40%"></TD>
                                            </TR>
                                           </TABLE>
                                        </TD>
                                    <tr>
                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(21583,user.getLanguage())%></B></TD>
									 </TR>								
                                     <TR class=Spacing  style="height:1px;">
									     <TD class=Line1 colSpan=2></TD>
									 </TR>
                                   <tr>
                                        <td colspan=2>
                                            <table class="listStyle" id="oTableDiff" name="oTableDiff">
                                                <colgroup>
                                                <col width="4%">
                                                <col width="20%">
                                                <col width="14%">
                                                <col width="14%">
                                                <col width="14%">
                                                <col width="20%">
                                                <col width="14%">
                                                <tr class="header">
                                                    <td><input type="checkbox" name="chkAllDiff" onclick="chkAllDiffClick(this)"></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(22050,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19346,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19347,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(22053,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(21582,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></td>
                                                </tr>
                                                <tr class=line  style="height:1px;"><td colspan=5></td></tr>
                                                    <%=WorkflowSubwfSetManager.getSubwfSetDiffTRString(mainWorkflowId,user.getLanguage())%>
                                            </table>
                                        </td>
                                   </tr>
                                    <TR>
                                        <TD height="15" colspan="2"></TD>
                                    </TR>	
                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></B></TD>
									 </TR>								
                                     <TR class=Spacing  style="height:1px;">
									     <TD class=Line1 colSpan=2></TD>
									 </TR>
                                     <TR>
                                        <TD>1¡¢<%=SystemEnv.getHtmlLabelName(21717,user.getLanguage())%></TD>
									 </TR>	
                                </TBODY>
                            </TABLE>
</div>

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