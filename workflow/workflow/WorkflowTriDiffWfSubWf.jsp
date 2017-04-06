<%@ page language="java" contentType="text/html; charset=GBK" %>


<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />


<HTML>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19343,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21591,user.getLanguage())+"）"+SystemEnv.getHtmlLabelName(19342,user.getLanguage());
    String needfav = "";
    String needhelp = "";
%>
    <HEAD>
        <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver.js"></script>
    </HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%

    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearchWorkflowTriDiffWfSubWf(),_top} " ;
    RCMenuHeight += RCMenuHeightStep;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveWorkflowTriDiffWfSubWf(this),_self}";
    RCMenuHeight += RCMenuHeightStep;
	
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancelWorkflowTriDiffWfSubWf(this),_self}";
    RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu1.jsp" %>

<%

    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID = -1;
    int operateLevel = 0;

    if(1 == detachable)
    {  
        if(null == request.getParameter("subCompanyID"))
        {
            subCompanyID=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")), -1);
        }
        else
        {
            subCompanyID=Util.getIntValue(request.getParameter("subCompanyID"),-1);
        }
        if(-1 == subCompanyID)
        {
            subCompanyID = user.getUserSubCompany1();
        }
        
        session.setAttribute("managefield_subCompanyId", String.valueOf(subCompanyID));
        
        operateLevel= checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowManage:All", subCompanyID);
    }
    else
    {
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
        {
            operateLevel=2;
        }
    }

    if(operateLevel > 0)
    {

		int triDiffWfDiffFieldId = Util.getIntValue(request.getParameter("triDiffWfDiffFieldId"),-1);
		int mainWorkflowId=0;
		int triggerNodeId=0;
		String triggerTime="";
		int fieldId=0;

        RecordSet.executeSql("select * from Workflow_TriDiffWfDiffField where id=" + triDiffWfDiffFieldId);
        if(RecordSet.next()){
			mainWorkflowId=Util.getIntValue(RecordSet.getString("mainWorkflowId"),0);
			triggerNodeId=Util.getIntValue(RecordSet.getString("triggerNodeId"),0);
			triggerTime=Util.null2String(RecordSet.getString("triggerTime"));
			fieldId=Util.getIntValue(RecordSet.getString("fieldId"),0);
		}

		String formId=WorkflowComInfo.getFormId(""+mainWorkflowId);
		String isBill=WorkflowComInfo.getIsBill(""+mainWorkflowId);

		String triggerNodeName="";
        RecordSet.executeSql("select nodeName from workflow_nodebase where id=" + triggerNodeId);
        if(RecordSet.next()){
			triggerNodeName=Util.null2String(RecordSet.getString("nodeName"));
		}

		String triggerTimeText="";
		if("1".equals(triggerTime)){// 到达节点 
			triggerTimeText=SystemEnv.getHtmlLabelName(19348,user.getLanguage());
		}else if("2".equals(triggerTime)){//离开节点
			triggerTimeText=SystemEnv.getHtmlLabelName(19349,user.getLanguage());
		}

		String fieldName="";
		String fieldHtmlType="";
		int type=0;

		if("1".equals(isBill)){
			int fieldLabel=0;
			RecordSet.executeSql("select fieldLabel,fieldHtmlType,type from workflow_billfield where id=" + fieldId);
			if(RecordSet.next()){
				fieldLabel=Util.getIntValue(RecordSet.getString("fieldLabel"),0);
				fieldName=SystemEnv.getHtmlLabelName(fieldLabel,user.getLanguage());
				fieldHtmlType=Util.null2String(RecordSet.getString("fieldHtmlType"));
				type=Util.getIntValue(RecordSet.getString("type"),0);
			}
		}else{
			RecordSet.executeSql("select fieldLable from workflow_fieldlable where formId="+formId+" and fieldId="+fieldId+" and langurageId=" + user.getLanguage());
			if(RecordSet.next()){
				fieldName=Util.null2String(RecordSet.getString("fieldLable"));
			}
			fieldHtmlType=Util.null2String(FieldComInfo.getFieldhtmltype(""+fieldId));
			type=Util.getIntValue(FieldComInfo.getFieldType(""+fieldId),0);
		}


%>

<iframe id="iFrameWorkflowTriDiffWfSubWf" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<FORM name="formWorkflowTriDiffWfSubWf" method="post" action="WorkflowTriDiffWfSubWfOperation.jsp" >

    <INPUT type=hidden id='triDiffWfDiffFieldId' name='triDiffWfDiffFieldId' value=<%=triDiffWfDiffFieldId %>>

    <TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <COLGROUP>
            <COL width="10">
            <COL width="">
            <COL width="10">
        <TR>
            <TD height="10" colspan="3"></TD>
        </TR>
        <TR>
            <TD ></TD>
            <TD valign="top">
                <TABLE class=Shadow>
                    <TR>
                        <TD valign="top">

                                <!--================== 可区分子流程字段信息 ==================-->
                                <TABLE class="viewform">
                                    <COLGROUP>
                                       <COL width="25%">
                                       <COL width="75%">
                                       </COLGROUP>
                                    <TR class="Title">
                                        <TH colSpan=2><%=SystemEnv.getHtmlLabelName(21592,user.getLanguage())%></TH>
                                    </TR>                                
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line1" colSpan=2></TD>
                                    </TR>
                                    <!--================== 触发节点 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(19346,user.getLanguage())%></TD>
                                        <TD class=Field><%=triggerNodeName%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 触发时间 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(19347,user.getLanguage())%></TD>
                                        <TD class=Field><%=triggerTimeText%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 可区分字段 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(21582,user.getLanguage())%></TD>
                                        <TD class=Field><%=fieldName%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=2></TD>
                                    </TR>
                                    <TR>
                                        <TD height="10" colspan="2"></TD>
                                    </TR>
                                </TABLE>											
                                <!--================== 默认子流程 ==================-->
                                <TABLE class="viewform">                           
                                    <TR class="Title">
                                        <TH><%=SystemEnv.getHtmlLabelName(21593,user.getLanguage())%></TH>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line1"></TD>
                                    </TR>
                                </TABLE>
                                <TABLE class="liststyle">
                                    <COLGROUP>
                                       <COL width="30%">
                                       <COL width="30%">    
                                       <COL width="20%">
                                       <COL width="20%">								
                                    <TR class="header">
                                        <TD></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(19344,user.getLanguage())%></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(21257,user.getLanguage())%></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(21585,user.getLanguage())%></TD>
                                    </TR>
<%
        int triDiffWfSubWfIdDefault=0;
        int subWorkflowIdDefault=0;
        int isReadDefault=0;
        RecordSet.executeSql("select id,subWorkflowId,isRead from Workflow_TriDiffWfSubWf where triDiffWfDiffFieldId="+triDiffWfDiffFieldId+" and fieldValue=-1 order by id asc");
        if(RecordSet.next()){
			triDiffWfSubWfIdDefault=Util.getIntValue(RecordSet.getString("id"),0);
			subWorkflowIdDefault=Util.getIntValue(RecordSet.getString("subWorkflowId"),0);
			isReadDefault=Util.getIntValue(RecordSet.getString("isRead"),0);
		}
		String subWorkflowNameDefault=WorkflowComInfo.getWorkflowname(""+subWorkflowIdDefault);

%>
                                    <TR class=DataDark>
                                        <TD><%=SystemEnv.getHtmlLabelName(21593,user.getLanguage())%><INPUT type=hidden name=triDiffWfSubWfIdDefault  id="triDiffWfSubWfIdDefault" value="<%=triDiffWfSubWfIdDefault%>"></TD>
                                        <TD>
                                            <button type="button" class=Browser  onClick="onShowWorkFlowNeededValidSingle('subWorkflowIdDefault','subWorkflowNameDefaultSpan',1)" name=showSubWorkflow></BUTTON> 
                                            <INPUT type=hidden name=subWorkflowIdDefault  id="subWorkflowIdDefault" value="<%=subWorkflowIdDefault%>">
                                            <span id=subWorkflowNameDefaultSpan name=subWorkflowNameDefaultSpan>
<%if(triDiffWfSubWfIdDefault<=0){%>
												<IMG src='/images/BacoError.gif' align=absMiddle>
<%}else{%>
												<%=subWorkflowNameDefault%>
<%}%>
											</span>
                                        </TD>
                                        <TD>
                                            <SELECT class="InputStyle"  name="isReadDefault" id="isReadDefault"  >   
                                                <option value="0" <%if(isReadDefault==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option> 
                                                <option value="1" <%if(isReadDefault==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
                                            </SELECT>
										</TD>
                                        <TD>
										    <A HREF="#" onClick="triDiffWfSubWfFieldConfig(tab0002,<%=triDiffWfDiffFieldId%>, <%=triDiffWfSubWfIdDefault%>, -1, jQuery('#subWorkflowIdDefault').val(), jQuery('#isReadDefault').val(), <%=mainWorkflowId%>)"><%=SystemEnv.getHtmlLabelName(21585,user.getLanguage())%></A>
										</TD>
                                    </TR>
                                    <TR>
                                        <TD height="10" colspan="5"></TD>
                                    </TR>
                                </TABLE>    
                                    
                                <!--================== 选择子流程 ==================-->
                                <TABLE class="viewform">   
                                    <TR class="Title">
                                        <TH colSpan=4><%=SystemEnv.getHtmlLabelName(21594,user.getLanguage())%></TH>
                                    </TR>                                
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line1"></TD>
                                    </TR>
                                </TABLE>
<%

boolean useHrmResource=false;
boolean useDocReceiveUnit=false;

if(type==17||type==141||type==166){
	useHrmResource=true;
}else if(type==142){
	useDocReceiveUnit=true;
}
if(useHrmResource){
%>
                                <TABLE class="viewform">
                                    <COLGROUP>
                                       <COL width="30%">
                                       <COL width="30%">
                                       <COL width="20%">
                                       <COL width="20%">

                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
                                        <TD class=Field>
											<button type="button" class=Browser id=SelectSubCompany onclick="onShowSubcompanySingle(subCompanyIdTriDiffWfSubWf,subCompanyNameTriDiffWfSubWfSpan,0)"></BUTTON>
											<SPAN id=subCompanyNameTriDiffWfSubWfSpan></SPAN>
											<INPUT class=inputstyle id=subCompanyIdTriDiffWfSubWf type=hidden name=subCompanyIdTriDiffWfSubWf value="">										
										</TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
                                        <TD class=Field>
											<button type="button" class=Browser id=SelectDepartment onclick="onShowDepartmentSingle(departmentIdTriDiffWfSubWf,departmentNameTriDiffWfSubWfSpan,0)"></BUTTON>
											<SPAN id=departmentNameTriDiffWfSubWfSpan></SPAN>
											<INPUT class=inputstyle id=departmentIdTriDiffWfSubWf type=hidden name=departmentIdTriDiffWfSubWf value="">
										</TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=4></TD>
                                    </TR>

                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
                                        <TD class=Field><input class=Inputstyle type="text" name="resourceNameTriDiffWfSubWf"  value=""></TD>
                                        <TD></TD>
                                        <TD></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=4></TD>
                                    </TR>
                                </TABLE>
<%
}else if(useDocReceiveUnit){
%>
                                <TABLE class="viewform">
                                    <COLGROUP>
                                       <COL width="30%">
                                       <COL width="30%">
                                       <COL width="20%">
                                       <COL width="20%">

                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(19310,user.getLanguage())%></TD>
                                        <TD class=Field>
											<button type="button" class=Browser id=SelectSuperiorUnit onclick="onShowReceiveUnitSingle(superiorUnitIdTriDiffWfSubWf,superiorUnitNameTriDiffWfSubWfSpan,0)"></BUTTON>
											<SPAN id=superiorUnitNameTriDiffWfSubWfSpan></SPAN>
											<INPUT class=inputstyle id=superiorUnitIdTriDiffWfSubWf type=hidden name=superiorUnitIdTriDiffWfSubWf value="">										
										</TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
                                        <TD class=Field><input class=Inputstyle type="text" name="receiveUnitNameTriDiffWfSubWf"  value=""></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=4></TD>
                                    </TR>
                                </TABLE>
<%
}
%>
                                <TABLE id="chooseSubWorkflow" class="liststyle">
                                    <COLGROUP>
                                       <COL width="30%">
                                       <COL width="30%">
                                       <COL width="20%">									
                                       <COL width="20%">   
                                    <TR class="header">
                                        <TD><%=SystemEnv.getHtmlLabelName(21595,user.getLanguage())%></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(19344,user.getLanguage())%></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(21257,user.getLanguage())%></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(21585,user.getLanguage())%></TD>
                                    </TR>                                                         
<%



int triDiffWfSubWfId=0;
int subWorkflowId=0;
String subWorkflowName="";
int isRead=0;
int fieldValue=0;
String fieldValueName="";

Map triDiffWfSubWfIdMap=new HashMap();
Map subWorkflowIdMap=new HashMap();
Map isReadMap=new HashMap();

RecordSet.executeSql("select id,subWorkflowId,isRead,fieldValue from Workflow_TriDiffWfSubWf where triDiffWfDiffFieldId="+triDiffWfDiffFieldId+" and fieldValue>0  order by id desc");
while(RecordSet.next()){
	triDiffWfSubWfId=Util.getIntValue(RecordSet.getString("id"),0);
	subWorkflowId=Util.getIntValue(RecordSet.getString("subWorkflowId"),0);
	isRead=Util.getIntValue(RecordSet.getString("isRead"),0);
	fieldValue=Util.getIntValue(RecordSet.getString("fieldValue"),0);

    triDiffWfSubWfIdMap.put(""+fieldValue,""+triDiffWfSubWfId);
    subWorkflowIdMap.put(""+fieldValue,""+subWorkflowId);
    isReadMap.put(""+fieldValue,""+isRead);
}

boolean isOracle=RecordSet.getDBType().equals("oracle");

int pagenum=1;

int perpage = 10;
RecordSet.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(RecordSet.next()){
	perpage     =Util.getIntValue(RecordSet.getString("dspperpage"),10); 
}

String sql = "";
String sqlAll ="";
String sqlwhere="";//TD35628
if(useHrmResource){
	if(isOracle){
		//sql =" (select * from (select id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere +"  and (status=0 or status = 1 or status = 2 or status = 3) order by dsporder asc) where rownum<"+ (pagenum*perpage+1)+"    order by dsporder desc)s";
		sql =" (select * from (select id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere +"  and (status=0 or status = 1 or status = 2 or status = 3) order by dspOrder asc,fieldValueName asc,fieldValue asc) where rownum<"+ (pagenum*perpage+1)+"    order by dspOrder desc,fieldValueName desc,fieldValue desc)s";
		sqlAll=" (select id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere +"  and (status=0 or status = 1 or status = 2 or status = 3))s";
	}else{
		//sql = " (select top "+(pagenum*perpage+1)+" * from (select distinct top "+(pagenum*perpage+1)+" select id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere+" and (status=0 or status = 1 or status = 2 or status = 3) order by dsporder asc)as s order by dsporder desc) as t ";
		sql = "  (select top "+(pagenum*perpage)+" * from (select distinct top "+(pagenum*perpage)+" id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere+" and (status=0 or status = 1 or status = 2 or status = 3) order by dspOrder asc,fieldValueName asc,fieldValue asc)as s order by dspOrder desc,fieldValueName desc,fieldValue desc) as t ";
		sqlAll=" (select  id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere+" and (status=0 or status = 1 or status = 2 or status = 3) )as s  ";
	}
}else if(useDocReceiveUnit){
	sqlwhere=" and (canceled is null or canceled=0) ";//TD29443 lv 不显示封存收发文单位 TD35628
	if(isOracle){
		//sql =" (select * from (select id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere +"   order by dsporder asc) where rownum<"+ (pagenum*perpage+1)+"    order by dsporder desc)s";
		sql =" (select * from (select id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere +"   order by dspOrder asc,fieldValueName asc,fieldValue asc) where rownum<"+ (pagenum*perpage+1)+"    order by dspOrder desc,fieldValueName desc,fieldValue desc)s";
		sqlAll="(select id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere +")s";
	}else{
		//sql = " (select top "+(pagenum*perpage+1)+" * from (select distinct top "+(pagenum*perpage+1)+" select id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere+"  order by dsporder asc)as s order by dsporder desc) as t ";
		sql = " (select top "+(pagenum*perpage)+" * from (select distinct top "+(pagenum*perpage)+" id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere+"  order by dspOrder asc,fieldValueName asc,fieldValue asc)as s order by dspOrder desc,fieldValueName desc,fieldValue desc) as t ";
		sqlAll=" (select id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere+")as s";
	}
}

int RecordSetCountsAll = 0;
RecordSet.executeSql("Select count(fieldValue) RecordSetCounts from "+sqlAll);
if(RecordSet.next()){
	RecordSetCountsAll = RecordSet.getInt("RecordSetCounts");
}
boolean hasNextPage=false;
if(RecordSetCountsAll>pagenum*perpage){
	hasNextPage=true;
}

int RecordSetCounts = 0;
RecordSet.executeSql("Select count(fieldValue) RecordSetCounts from "+sql);
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}

String sqltemp="";
int topnum = (RecordSetCounts-(pagenum-1)*perpage);
if(topnum<0){
	topnum = 0;
}
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+sql+") where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1)+"  order by dspOrder asc,fieldValueName asc,fieldValue asc";
}else{
	//sqltemp=" select top "+topnum+" * from ( select top "+topnum+" * from "+sql+") as m  order by dspOrder asc,fieldValueName asc,fieldValue asc";
	sqltemp=" select top "+topnum+" * from "+sql+"  order by dspOrder asc,fieldValueName asc,fieldValue asc";
}

int rowNum=0;
String trClass="DataLight";

RecordSet.executeSql(sqltemp);
while(RecordSet.next()){
	fieldValue=Util.getIntValue(RecordSet.getString("fieldValue"),0);
	fieldValueName=Util.null2String(RecordSet.getString("fieldValueName"));

	triDiffWfSubWfId=Util.getIntValue((String)triDiffWfSubWfIdMap.get(""+fieldValue),0);
	subWorkflowId=Util.getIntValue((String)subWorkflowIdMap.get(""+fieldValue),0);
	isRead=Util.getIntValue((String)isReadMap.get(""+fieldValue),0);

	subWorkflowName=WorkflowComInfo.getWorkflowname(""+subWorkflowId);

%>
                                    <TR class="<%=trClass%>">
                                        <TD><%=fieldValueName%>
	                                       <INPUT type=hidden name=triDiffWfSubWfId_<%=rowNum%>  id="triDiffWfSubWfId_<%=rowNum%>" value="<%=triDiffWfSubWfId%>">
	                                       <INPUT type=hidden name=fieldValue_<%=rowNum%>  id="fieldValue_<%=rowNum%>" value="<%=fieldValue%>">
	                                    </TD>
                                        <TD>
                                            <button type="button" class=Browser  onClick="onShowWorkFlowNeededValidSingle('subWorkflowId_<%=rowNum%>','subWorkflowNameSpan_<%=rowNum%>',0)" name=showSubWorkflow></BUTTON><span id=subWorkflowNameSpan_<%=rowNum%> name=subWorkflowNameSpan_<%=rowNum%>><%=subWorkflowName%></span>
                                            <INPUT type=hidden name=subWorkflowId_<%=rowNum%>  id="subWorkflowId_<%=rowNum%>" value="<%=subWorkflowId%>">
                                        </TD>
                                        <TD>
                                            <SELECT class="InputStyle"  name="isRead_<%=rowNum%>" id="isRead_<%=rowNum%>"  >   
                                                <option value="0" <%if(isRead==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option> 
                                                <option value="1" <%if(isRead==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
                                            </SELECT>
										</TD>
                                        <TD>
										    <A HREF="#" onClick="triDiffWfSubWfFieldConfig(tab0002,<%=triDiffWfDiffFieldId%>, <%=triDiffWfSubWfId%>, <%=fieldValue%>, jQuery('#subWorkflowId_<%=rowNum%>').val(), jQuery('#isRead_<%=rowNum%>').val(), <%=mainWorkflowId%>)"><%=SystemEnv.getHtmlLabelName(21585,user.getLanguage())%></A>
										</TD>
                                    </TR>
<%
    if(trClass.equals("DataLight")){
		trClass="DataDark";
    }else{
		trClass="DataLight";
	}
	rowNum++;
}
%>
                                    <TR>
                                        <TD height="10" colspan="4"></TD>
                                    </TR>
                                    <TR>
                                        <TD>
<%
if(pagenum>1){
%>
<A HREF="#" onClick="prePageTriDiffWfSubWf()">【<%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%>】</A>
<%
}
if(pagenum<=1&&hasNextPage){
%>
<A HREF="#" onClick="nextPageTriDiffWfSubWf()">【<%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%>】</A>
<%
}
%>
	                                    </TD>
                                        <TD>
<%
if(pagenum>1&&hasNextPage){
%>
<A HREF="#" onClick="nextPageTriDiffWfSubWf()">【<%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%>】</A>
<%
}
%>
	                                    </TD>
                                        <TD>&nbsp;</TD>
                                        <TD>&nbsp;</TD>
                                    </TR>	
                                </TABLE>


                        </TD>
                        <TD></TD>
                    </TR>
                    <TR>
                        <TD height="10" colspan="3"></TD>
                    </TR>

         
                </TABLE>
            </TD>
        </TR>
    </TABLE>

<INPUT type=hidden name=rowNumTriDiffWfSubWf  id="rowNumTriDiffWfSubWf" value="<%=rowNum%>">
<INPUT type=hidden name=pagenumTriDiffWfSubWf  id="pagenumTriDiffWfSubWf" value="<%=pagenum%>">
			
</FORM>
<%
    }
    else
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>
</BODY>
</HTML>
<script language="javascript" for="document" event="onkeydown">  
   var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;   
   if (keyCode == 13) {  
   		if(document.getElementById("pagenumTriDiffWfSubWf")==null){
			return;
		}
		document.getElementById("pagenumTriDiffWfSubWf").value = 1;
	 
    	if(document.getElementById("triDiffWfDiffFieldId")==null){
			return;
		}
		triDiffWfDiffFieldId=document.getElementById("triDiffWfDiffFieldId").value;
		pagenum=1;
		subCompanyId=0;
		departmentId=0;
		resourceName="";
	
		superiorUnitId=0;
		receiveUnitName="";
		if(document.getElementById("pagenumTriDiffWfSubWf")!=null){
			pagenum=document.getElementById("pagenumTriDiffWfSubWf").value;
		}
	
		if(document.getElementById("subCompanyIdTriDiffWfSubWf")!=null){
			subCompanyId=document.getElementById("subCompanyIdTriDiffWfSubWf").value;
		}
		if(document.getElementById("departmentIdTriDiffWfSubWf")!=null){
			departmentId=document.getElementById("departmentIdTriDiffWfSubWf").value;
		}
		if(document.getElementById("resourceNameTriDiffWfSubWf")!=null){
			resourceName=document.getElementById("resourceNameTriDiffWfSubWf").value;
		}
		if(document.getElementById("superiorUnitIdTriDiffWfSubWf")!=null){
			superiorUnitId=document.getElementById("superiorUnitIdTriDiffWfSubWf").value;
		}
		if(document.getElementById("receiveUnitNameTriDiffWfSubWf")!=null){
			receiveUnitName=document.getElementById("receiveUnitNameTriDiffWfSubWf").value;
		}
		document.all("iFrameWorkflowTriDiffWfSubWf").src = "iFrameWorkflowTriDiffWfSubWf.jsp?triDiffWfDiffFieldId=" + triDiffWfDiffFieldId + "&pagenum=" + pagenum + "&subCompanyId=" + subCompanyId+ "&departmentId=" + departmentId+ "&resourceName=" + encodeURIComponent(encodeURIComponent(resourceName))+ "&superiorUnitId=" + superiorUnitId+ "&receiveUnitName=" + receiveUnitName;
	    return false;
   }   
</script>  
