<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />

<HTML>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19331,user.getLanguage());
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
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveCreateDocument(this),_self}";
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

		int workflowId = Util.getIntValue(request.getParameter("wfid"),-1);
        String formID = request.getParameter("formid");
        String isbill = request.getParameter("isbill");

		if(formID==null||formID.trim().equals("")){
			formID=WorkflowComInfo.getFormId(""+workflowId);
		}
 		if(isbill==null||isbill.trim().equals("")){
			isbill=WorkflowComInfo.getIsBill(""+workflowId);
		}
		if(formID==null||formID.trim().equals("")||isbill==null||isbill.trim().equals("")){
			RecordSet.executeSql("select formid,isbill from workflow_base where id="+workflowId);
			if(RecordSet.next()){
				formID = Util.null2String(RecordSet.getString("formid"));
				isbill = Util.null2String(RecordSet.getString("isbill"));
			}
		}
		if(!"1".equals(isbill)){
			isbill="0";
		}

        String ifVersion = 	"0";
		int titleFieldId=0;
		int keywordFieldId=0;
        //RecordSet.executeSql("select ifVersion from workflow_base where id=" +workflowId);
        RecordSet.executeSql("select ifVersion,titleFieldId,keywordFieldId from workflow_base where id=" +workflowId);
		if(RecordSet.next()){
            ifVersion = Util.null2String(RecordSet.getString("ifVersion"));
            titleFieldId = Util.getIntValue(RecordSet.getString("titleFieldId"),0);
            keywordFieldId = Util.getIntValue(RecordSet.getString("keywordFieldId"),0);
		}

		boolean canBeSet=true;

		if("1".equals(isbill)){
			canBeSet=false;

			String createPage="";
			String managePage="";
			String viewPage="";
			String operationPage="";
			
			RecordSet.executeSql("select createPage,managePage,viewPage,operationPage from workflow_bill where id= " + formID);
			if(RecordSet.next()){
				createPage=Util.null2String(RecordSet.getString("createPage"));
				managePage=Util.null2String(RecordSet.getString("managePage"));
				viewPage=Util.null2String(RecordSet.getString("viewPage"));
				operationPage=Util.null2String(RecordSet.getString("operationPage"));
			}

			if(createPage.equals("")&&managePage.equals("")&&viewPage.equals("")&&operationPage.equals("")){
				canBeSet=true;
			}
		}

        /*================ 编辑信息 ================*/
        String status = "0";
        int flowCodeField = -1;
        int flowDocField = -1;
		int documentTitleField = -1;
        int flowDocCatField = -1;
		int useTempletNode = -1;
		String printNodes = "";
		String printNodesName="";
		String newTextNodes = "";
        String defaultView = "";
        String mainCategory = "-1";
        String subCategory = "-1";
        String secCategory = "-1";
        String isCompellentMark = "0";
		String isCancelCheck = "0";
		String signatureNodes = "";
		String signatureNodesName = "";
		String isWorkflowDraft = "";
		String isHideTheTraces = "";
		String defaultDocType = "";
		int extfile2doc = 0;
        
        RecordSet.executeSql("SELECT * FROM workflow_createdoc WHERE workFlowID = " + request.getParameter("wfid"));

        if(RecordSet.next())
        {
            status = RecordSet.getString("status");
            
            flowCodeField = RecordSet.getInt("flowCodeField");
            
            flowDocField = RecordSet.getInt("flowDocField");

            documentTitleField = RecordSet.getInt("documentTitleField");
            
            flowDocCatField = RecordSet.getInt("flowDocCatField");

			useTempletNode = RecordSet.getInt("useTempletNode");
            
            printNodes = Util.null2String(RecordSet.getString("printNodes"));

            newTextNodes = Util.null2String(RecordSet.getString("newTextNodes"));

			signatureNodes = Util.null2String(RecordSet.getString("signatureNodes"));

			isWorkflowDraft = Util.null2String(RecordSet.getString("isWorkflowDraft"));

			defaultDocType = Util.null2String(RecordSet.getString("defaultDocType"));

			isHideTheTraces = Util.null2String(RecordSet.getString("isHideTheTraces"));

            defaultView = RecordSet.getString("defaultView");

			isCompellentMark = Util.null2String(RecordSet.getString("iscompellentmark"));

			isCancelCheck = Util.null2String(RecordSet.getString("iscancelcheck"));

            List defaultViewList = Util.TokenizerString(defaultView, "||");
  
            mainCategory = (String)defaultViewList.get(0);

            subCategory = (String)defaultViewList.get(1);

            secCategory = (String)defaultViewList.get(2);
                                    
            if("-1||-1||-1".equals(defaultView))
            {
                defaultView = "";
            }
            else
            {
                defaultView = mainCategoryComInfo.getMainCategoryname(mainCategory) + "/" + subCategoryComInfo.getSubCategoryname(subCategory) + "/" + secCategoryComInfo.getSecCategoryname(secCategory);
            }
            extfile2doc = Util.getIntValue(RecordSet.getString("extfile2doc"), 0);
        }

        //打印节点

		if(!printNodes.equals("")){
			StringBuffer printNodesNameSb=new StringBuffer();
			printNodesNameSb.append(" select b.nodeName ")
				            .append(" from  workflow_flownode a,workflow_nodebase b ")
				            .append(" where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id ")
				            .append("   and a.workflowId=").append(workflowId)
				            .append("   and b.id in(").append(printNodes).append(") ")
				            .append(" order by a.nodeType asc,a.nodeId asc ")				
			;
			RecordSet.executeSql(printNodesNameSb.toString());
			while(RecordSet.next()){
				printNodesName+="，"+Util.null2String(RecordSet.getString("nodeName"));
			}
			if(!printNodesName.equals("")){
				printNodesName=printNodesName.substring(1);
			}
		}

        /**签章节点**/
		if(!signatureNodes.equals("")){
			StringBuffer signatureNodesNameSb=new StringBuffer();
			signatureNodesNameSb.append(" select b.nodeName ")
				            .append(" from  workflow_flownode a,workflow_nodebase b ")
				            .append(" where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id ")
				            .append("   and a.workflowId=").append(workflowId)
				            .append("   and b.id in(").append(signatureNodes).append(") ")
				            .append(" order by a.nodeType asc,a.nodeId asc ")				
			;
			RecordSet.executeSql(signatureNodesNameSb.toString());
			while(RecordSet.next()){
				signatureNodesName+="，"+Util.null2String(RecordSet.getString("nodeName"));
			}
			if(!signatureNodesName.equals("")){
				signatureNodesName=signatureNodesName.substring(1);
			}
		}

        Map docPropIdMap=new HashMap();
		String tempSelectItemId=null;
		String tempDocPropId=null;
		RecordSet.executeSql("SELECT id,selectItemId FROM Workflow_DocProp where workflowId="+workflowId+" and objId=-1");
		while(RecordSet.next()){
			tempSelectItemId=Util.null2String(RecordSet.getString("selectItemId"));
			tempDocPropId=Util.null2String(RecordSet.getString("id"));
			if(!(tempSelectItemId.trim().equals(""))){
				docPropIdMap.put(tempSelectItemId,tempDocPropId);
			}
		}
		int docPropIdDefault=Util.getIntValue((String)docPropIdMap.get("-1"),-1);
                
        /*================ 显示字段查询基SQL ================*/
		String SQL = null;

		if("1".equals(isbill)){
			SQL = "select formField.id,fieldLable.labelName as fieldLable "
                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                    + "where fieldLable.indexId=formField.fieldLabel "
                    + "  and formField.billId= " + formID
                    + "  and formField.viewType=0 "
                    + "  and fieldLable.languageid =" + user.getLanguage();
		}else{
			SQL = "select formDict.ID, fieldLable.fieldLable "
                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                    + "and formField.formid = " + formID
                    + " and fieldLable.langurageid = " + user.getLanguage();
		}
                    
        int formDictID = -1;

		int tempNodeId = -1;
%>

<FORM name="createDocumentByWorkFlow" method="post" action="CreateDocumentByWorkFlowOperation.jsp" >

    <iframe id="chooseDisplayAttributeForm" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

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
                            <!--================== 主题词设置 ==================-->
                            <TABLE class="viewform">
                                <COLGROUP>
                                   <COL width="25%">
                                   <COL width="75%">
                                    <TR class="Title">
                                        <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16978,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
                                    </TR>                                
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line1" colSpan=2></TD>
                                    </TR>

<%
        String SQLWorkFlowCoding = null;
        if("1".equals(isbill)){
        	SQLWorkFlowCoding = SQL + " and formField.fieldHtmlType = '1' and formField.type = 1 order by formField.dspOrder";
        }else{
            SQLWorkFlowCoding = SQL + " and formDict.fieldHtmlType = '1' and formDict.type = 1 order by formField.fieldorder";
        }

%>

                                <tr>
                                    <td><%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%></td>
                                    <TD class=Field>
									    <select name="titleFieldId">
									        <option value=-1></option>
									        <option value=-3  <%if (titleFieldId==-3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
<%
        RecordSet.executeSql(SQLWorkFlowCoding);
        while(RecordSet.next()){
			formDictID = RecordSet.getInt("ID");
%>
									        <OPTION value=<%= formDictID %> <% if(formDictID == titleFieldId) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></OPTION>
<%
        }
%>
									    </select>
                                    </TD>
                                </tr>
                                <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>

                                <tr>
                                    <td><%=SystemEnv.getHtmlLabelName(21516,user.getLanguage())%></td>
                                    <TD class=Field>
                                        <select name="keywordFieldId">
                                            <option value=-1></option>
<%
        RecordSet.executeSql(SQLWorkFlowCoding);
        while(RecordSet.next()){
			formDictID = RecordSet.getInt("ID");
%>
									        <OPTION value=<%= formDictID %> <% if(formDictID == keywordFieldId) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></OPTION>
<%
        }
%>
									    </select>
                                    </TD>
                                </tr>
                                <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>

                                <TR>
                                    <TD height="10" colspan="2"></TD>
                                </TR>
                            </TABLE>

                            <!--================== 通过流程创建文档 ==================-->
                            <TABLE class="viewform">
                                <COLGROUP>
                                   <COL width="25%">
                                   <COL width="75%">
                                    <TR class="Title">
                                        <TH colSpan=2><%=SystemEnv.getHtmlLabelName(19331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
                                    </TR>                                
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line1" colSpan=2></TD>
                                    </TR>
                                <TR class="Title">
                                    <TD><%=SystemEnv.getHtmlLabelName(15376,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19331,user.getLanguage())%></TD>
                                    <TD class=Field><INPUT class=inputstyle type="checkbox" name="show" value="0" onclick="showContent()" <% if(!canBeSet) { %> disabled <% } if("1".equals(status)) {%> checked <% } %> ></TD>
                                </TR>
                                <TR>
                                    <TD height="10" colspan="2"></TD>
                                </TR>
                            </TABLE>
                            
                        <%
                            if(canBeSet)
                            //单据不允许配置
                            {
                              
                        %>
                            <DIV id="contentDiv" <% if("1".equals(status)) { %> style="display:block" <% } else { %> style="display:none" <% } %>>
                                <!--================== 流程基本属性 ==================-->
                                <TABLE class="viewform">
                                    <COLGROUP>
                                       <COL width="25%">
                                       <COL width="75%">
                                    <TR class="Title">
                                        <TH colSpan=2><%=SystemEnv.getHtmlLabelName(20598,user.getLanguage())%></TH>
                                    </TR>                                
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line1" colSpan=2></TD>
                                    </TR>
                                    <!--================== 套红节点 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(20229,user.getLanguage())%></TD>
                                        <TD class=Field>
                                            <SELECT class=inputstyle name="useTempletNode">
                                                <OPTION value=-1></OPTION>
                                            <%
                                                String sqlUseTempletNode =  " select b.id as nodeId,b.nodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and  a.workFlowId= "+workflowId+"  order by a.nodeType,a.nodeId";
                                                
                                                RecordSet.executeSql(sqlUseTempletNode);
                                                
                                                while(RecordSet.next())
                                                {
                                                    tempNodeId = RecordSet.getInt("nodeId");
                                            %>
                                                <OPTION value=<%= tempNodeId %> <% if(tempNodeId == useTempletNode) { %> selected <% } %> ><%= RecordSet.getString("nodeName") %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
                                        </TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=2></TD>
                                    </TR>
                                    <!--================== 打印节点 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(21529,user.getLanguage())%></TD>
                                        <TD class=Field>
                                            <button type="button" class=Browser id=printNodesButton onClick="onShowPrintNodes(printNodes,printNodesSpan,<%=workflowId%>)" name=printNodesButton></BUTTON>
											<SPAN id=printNodesSpan ><%= printNodesName %></SPAN>
											<input type=hidden id='printNodes' name='printNodes' value="<%= printNodes %>">
                                        </TD>
                                    </TR>

                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=2></TD>
                                    </TR>
                                    <!--================== 签章节点 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(21644,user.getLanguage())%></TD>
                                        <TD class=Field>
                                            <button type="button" class=Browser id=printNodesButton onClick="onShowPrintNodes(signatureNodes,signatureNodesSpan,<%=workflowId%>)" name=printNodesButton></BUTTON>
											<SPAN id=signatureNodesSpan ><%= signatureNodesName %></SPAN>
											<input type=hidden id='signatureNodes' name='signatureNodes' value="<%= signatureNodes %>">
                                        </TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=2></TD>
                                    </TR>
									<!--================== 是否只能新建正文 ==================-->
                                    <TR>
                                        <TD><%=SystemEnv.getHtmlLabelName(21634,user.getLanguage())%></TD>
                                        <TD class="Field">
                                          <INPUT class=inputstyle type="checkbox" name="newTextNodes" value="1" <% if("1".equals(newTextNodes)){ %> checked <%} %>/>
                                            <%=SystemEnv.getHtmlLabelName(21635,user.getLanguage())%>
                                        </TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colspan="2"></TD>
                                    </TR>
                                </TABLE>
                                <!--================== 文档基本属性 ==================-->
                                <TABLE class="viewform">
                                    <COLGROUP>
                                       <COL width="25%">
                                       <COL width="15%">
                                       <COL width="60%">
                                    <TR class="Title">
                                        <TH colSpan=3><%=SystemEnv.getHtmlLabelName(19337,user.getLanguage())%></TH>
                                    </TR>                                
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line1" colSpan=3></TD>
                                    </TR>
                                    <!--================== 流程编码字段 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(19338,user.getLanguage())%></TD>
                                        <TD class=Field>
                                            <SELECT class=inputstyle name="workFlowCoding">
                                                <OPTION value=-1></OPTION>
                                            <%

                                                
                                                RecordSet.executeSql(SQLWorkFlowCoding);
                                                
                                                while(RecordSet.next())
                                                {
                                                    formDictID = RecordSet.getInt("ID");
                                            %>
                                                <OPTION value=<%= formDictID %> <% if(formDictID == flowCodeField) { %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
                                        </TD>
                                        <TD class=Field><%=SystemEnv.getHtmlLabelName(21099,user.getLanguage())%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 创建文档字段 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(19339,user.getLanguage())%></TD>
                                        <TD class=Field>
                                            <SELECT class=inputstyle name="createDocument">
                                                <OPTION value=-1></OPTION>
                                            <%
										        String SQLCreateDocument = null;
									            if("1".equals(isbill)){
													SQLCreateDocument = SQL + " and formField.fieldHtmlType = '3' and formField.type = 9 order by formField.dspOrder";
												}else{
													SQLCreateDocument = SQL + " and formDict.fieldHtmlType = '3' and formDict.type = 9 order by formField.fieldorder";
												}

                                                RecordSet.executeSql(SQLCreateDocument);
                                                
                                                while(RecordSet.next())
                                                {
                                                    formDictID = RecordSet.getInt("ID");
                                            %>
                                                <OPTION value=<%= formDictID %> <% if(formDictID == flowDocField) { %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
                                        </TD>
                                        <TD class=Field><%=SystemEnv.getHtmlLabelName(21100,user.getLanguage())%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 文档标题字段 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(21098,user.getLanguage())%></TD>
                                        <TD class=Field>
                                            <SELECT class=inputstyle name="documentTitleField">
                                                <OPTION value=-1></OPTION>
                                                <OPTION value=-3 <% if(documentTitleField == -3) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></OPTION>
                                            <%                                                
                                                RecordSet.executeSql(SQLWorkFlowCoding);
                                                
                                                while(RecordSet.next())
                                                {
                                                    formDictID = RecordSet.getInt("ID");
                                            %>
                                                <OPTION value=<%= formDictID %> <% if(formDictID == documentTitleField) { %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
                                        </TD>
                                        <TD class=Field><%=SystemEnv.getHtmlLabelName(21101,user.getLanguage())%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 文件存放目录 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(15046,user.getLanguage())%></TD>
                                        <TD class=Field>
                                            <SELECT class=inputstyle name="documentLocation" onChange="loadIFrame(this.value)">
                                                <OPTION value=-1></OPTION>
                                            <%
										        String SQLDocumentLocation = null;
									            if("1".equals(isbill)){
													SQLDocumentLocation = SQL + " and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formField.ID = workflow_selectitem.fieldid and isBill='1' )order by formField.dspOrder";
												}else{
													SQLDocumentLocation = SQL + " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formDict.ID = workflow_selectitem.fieldid and isBill='0') order by formField.fieldorder";
												}
                                                int flag = -1;  //防止数据库目录被删除,配置信息存在
                                                
                                                RecordSet.executeSql(SQLDocumentLocation);  
                                                while(RecordSet.next())
                                                {
                                                    formDictID = RecordSet.getInt("ID");
                                            %>
                                                <OPTION value=<%= formDictID %> <% if(formDictID == flowDocCatField) { flag = flowDocCatField; %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></OPTION>
                                            <%
                                                }
                                            %>
                                            </SELECT>
                                        </TD>
                                        <TD class=Field><%=SystemEnv.getHtmlLabelName(21102,user.getLanguage())%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 是否必须保留痕迹 ==================-->
                                    <TR class="Spacing">
                                        <TD><%=SystemEnv.getHtmlLabelName(21631,user.getLanguage())%></TD>
                                        <TD class="Field">
                                          <INPUT class=inputstyle type="checkbox" name="isCompellentMark" onclick="onchangeIsCompellentMark()" value="1" <%if("1".equals(isCompellentMark)){%>checked<%}%> />
                                         </TD>
                                        <TD class=Field><%=SystemEnv.getHtmlLabelName(21637,user.getLanguage())%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 是否取消审阅 ==================-->
                                    <TR class="Spacing">
                                        <TD><%=SystemEnv.getHtmlLabelName(21632,user.getLanguage())%></TD>
                                        <TD class="Field">
                                          <INPUT class=inputstyle type="checkbox" name="isCancelCheck" onclick="onchangeIsCancelCheck()" value="1" <%if("1".equals(isCompellentMark)){%>disabled<%}%> <%if("1".equals(isCancelCheck)){%>checked<%}%>/>
										  <input type="hidden" name="isCancelCheckInput" value="<%if("1".equals(isCancelCheck)){%>1<%}else{%>0<%}%>" />
                                         </TD>
                                        <TD class=Field><%=SystemEnv.getHtmlLabelName(21638,user.getLanguage())%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 是否保留正文版本 ==================-->
                                    <TR class="Spacing">
                                        <TD><%=SystemEnv.getHtmlLabelName(21705,user.getLanguage())%></TD>
                                        <TD class="Field">
                                          <INPUT class=inputstyle type="checkbox" name="ifVersion"  value="1" <%if("1".equals(ifVersion)){%>checked<%}%> />
                                         </TD>
                                        <TD class=Field><%=SystemEnv.getHtmlLabelName(21722,user.getLanguage())%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 是否存为流程草稿 ==================-->
                                    <TR class="Spacing">
                                        <TD><%=SystemEnv.getHtmlLabelName(21731,user.getLanguage())%></TD>
                                        <TD class="Field">
                                          <INPUT class=inputstyle type="checkbox" name="isWorkflowDraft"  value="1" <%if("1".equals(isWorkflowDraft)){%>checked<%}%> />
                                         </TD>
                                        <TD class=Field><%=SystemEnv.getHtmlLabelName(21732,user.getLanguage())%><br><font color="red"><%=SystemEnv.getHtmlLabelName(21733,user.getLanguage())%></font></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 流程附件是否存为正文附件 ==================-->
                                    <TR class="Spacing">
                                        <TD><%=SystemEnv.getHtmlLabelName(24008,user.getLanguage())%></TD>
                                        <TD class="Field">
                                          <INPUT class="inputstyle" type="checkbox" id="extfile2doc" name="extfile2doc"  value="1" <%if(extfile2doc==1){%>checked<%}%> />
                                         </TD>
                                        <TD class=Field><%=SystemEnv.getHtmlLabelName(24009,user.getLanguage())%></font></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
                                    <!--================== 编辑正文时默认隐藏痕迹 ==================-->
                                    <TR class="Spacing">
                                        <TD><%=SystemEnv.getHtmlLabelName(24443,user.getLanguage())%></TD>
                                        <TD class="Field">
                                          <INPUT class=inputstyle type="checkbox" name="isHideTheTraces"  value="1" <%if("1".equals(isHideTheTraces)){%>checked<%}%> />
                                         </TD>
                                        <TD class=Field><%=SystemEnv.getHtmlLabelName(24444,user.getLanguage())%></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
<%
	String isUseDefaultDocType = Util.null2String(BaseBean.getPropValue("weaver_defaultdoctype","ISUSEDEFAULTDOCTYPE"));	
%>
                                    <!--================== 默认文档类型 ==================-->
<%
	if(isUseDefaultDocType.equals("1")){
%>
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(22358,user.getLanguage())%></TD>
                                        <TD class=Field>
                                            <SELECT class=inputstyle name="defaultDocType">
                                                <OPTION value=1 <% if(defaultDocType.equals("1")){%> selected <%}%> >Office Word</OPTION>
                                                <OPTION value=2 <% if(defaultDocType.equals("2")){%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(22359,user.getLanguage())%></OPTION>
                                            </SELECT>
                                        </TD>
                                        <TD class=Field></TD>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line" colSpan=3></TD>
                                    </TR>
<%
	}
%>
                                    <TR>
                                        <TD height="10" colspan="3"></TD>
                                    </TR>
                                </TABLE>
                                
                                <!--================== 默认显示属性 ==================-->
<%
	String isUseBarCode = Util.null2String(BaseBean.getPropValue("weaver_barcode","ISUSEBARCODE"));	
%>
                                <TABLE class="viewform">                           
                                    <TR class="Title">
                                        <TH><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%></TH>
                                    </TR>
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line1"></TD>
                                    </TR>
                                </TABLE>
                                <TABLE class="liststyle">
                                    <COLGROUP>
                                       <COL width="20%">
                                       <COL width="35%">    
                                       <COL width="15%">
                                       <COL width="15%">
                                       <COL width="15%">									
                                    <TR class="header">
                                        <TD></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(19360,user.getLanguage())%></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></TD>
<%if(isUseBarCode.equals("1")){%>
                                        <TD><%=SystemEnv.getHtmlLabelName(21569,user.getLanguage())%></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(21449,user.getLanguage())%></TD>
<%}else{%>
                                        <TD colspan=2><%=SystemEnv.getHtmlLabelName(21569,user.getLanguage())%></TD>
<%}%>
                                    </TR>
                                    <TR class=DataDark>
                                        <TD><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%></TD>
                                        <TD>
                                            <button type="button" class=Browser id=selectCategoryid onClick="onShowCatalogOfDocument('catalogPath'); checkinput('pathCategoryDocument','createDocumentByWorkFlowSpan')" name=selectCategoryid></BUTTON>
                                            <SPAN id=catalogPath ><%= defaultView %></SPAN><SPAN id=createDocumentByWorkFlowSpan><% if("".equals(defaultView) || null == defaultView) { %><IMG src="/images/BacoError.gif" align=absMiddle><% } %></SPAN>
                                        </TD>
                                        <TD><A HREF="#" onClick="detailConfig(tab0001, <%= request.getParameter("wfid") %>, -1, $('input[name=pathCategoryDocument]').val(), $('input[name=secCategoryDocument]').val(), <%= formID %>, '')"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></A></TD>
                                        <TD><A HREF="#" onClick="docPropDetailConfig(tab0001, <%=docPropIdDefault%>,<%=workflowId%>, -1, $('input[name=pathCategoryDocument]').val(), $('input[name=secCategoryDocument]').val())"><%=SystemEnv.getHtmlLabelName(21569,user.getLanguage())%></A></TD>
                                        <TD>
<%if(isUseBarCode.equals("1")){%>
										    <A HREF="#" onClick="detailBarCodeSet(tab0001, <%=workflowId%>, <%= formID %>, <%= isbill %>)"><%=SystemEnv.getHtmlLabelName(21449,user.getLanguage())%></A>
<%}%>
										</TD>
                                    </TR>
                                    
                                </TABLE>    
                                    
                                <!--================== 选择显示属性 ==================-->
                                <TABLE class="viewform">   
                                    <TR class="Title">
                                        <TH colSpan=4><%=SystemEnv.getHtmlLabelName(19341,user.getLanguage())%></TH>
                                    </TR>                                
                                    <TR class="Spacing" style="height:1px;">
                                        <TD class="Line1"></TD>
                                    </TR>
                                </TABLE>
                                <TABLE id="chooseDisplayAttribute" class="liststyle">
                                    <COLGROUP>
                                       <COL width="20%">
                                       <COL width="35%">
                                       <COL width="15%">									
                                       <COL width="*">   
                                    <TR class="header">
                                        <TD><%=SystemEnv.getHtmlLabelName(505,user.getLanguage())%></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(19360,user.getLanguage())%></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></TD>
                                        <TD><%=SystemEnv.getHtmlLabelName(21569,user.getLanguage())%></TD>
                                    </TR>                                                         
                            <%
                                if(-1 != flag)
                                {
                                    int i = 0;
                                                                    
                                    RecordSet.executeSql("select * from workflow_SelectItem where fieldid = " + flag + " and isBill = "+isbill+" and cancel<>'1' order by listOrder asc ");

                                    while(RecordSet.next())
                                    {
                                        String selectValue = RecordSet.getString("selectValue");
                                    
                                        String docPath = "";
                                        
                                        String docCategory = RecordSet.getString("docCategory");
                                        
                                        String innerMainCategory = "";
            							String innerSubCategory = "";
                                        String innerSecCategory = "";
                                        
                                        if(!"".equals(docCategory) && null != docCategory)
                                        //根据路径ID得到路径名称
                                        {
                                        	List nameList = Util.TokenizerString(docCategory, ",");
                                            
                                            innerMainCategory = (String)nameList.get(0);
            								innerSubCategory = (String)nameList.get(1);
            								innerSecCategory = (String)nameList.get(2);
            								
            								docPath = "/" + mainCategoryComInfo.getMainCategoryname(innerMainCategory) + "/" + subCategoryComInfo.getSubCategoryname(innerSubCategory) + "/" + secCategoryComInfo.getSecCategoryname(innerSecCategory);            								                                            
                                        }
										
                                        int docPropId=Util.getIntValue((String)docPropIdMap.get(selectValue),-1);

                                        String isAccordToSubCom = Util.null2String(RecordSet.getString("isAccordToSubCom"));

                            %>
                                        <TR class=<% if(0 == i % 2) {%> DataDark <% } else { %> DataLight <% } %>>
                                            <TD><%= RecordSet.getString("selectName") %></TD>
                                            <TD>
<%if("1".equals(isAccordToSubCom)){%>
                                            <A HREF="#"  onClick="onShowSubcompanyShowAttr(<%=workflowId%>,<%=formID%>,<%=isbill%>,<%=flag%>,<%=selectValue%>)"><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%></A>
<%}else{%>
                                            <%= docPath %>
<%}%>

                                            </TD>
                                            <TD>
                            <%
                                        if(!"".equals(docPath) && null != docPath && !"".equals(docCategory) && null != docCategory&&!"1".equals(isAccordToSubCom))
                                        {
                            %>
                                                <A HREF="#" onClick="detailConfig(tab0001, <%= request.getParameter("wfid") %>, <%= selectValue %>, '<%= docPath %>', <%= innerSecCategory %>, <%= formID %>, '')"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></A>
                            <%
                                        }
                            %>
                                            </TD>
                                            <TD>
                            <%
                                        if(!"".equals(docPath) && null != docPath && !"".equals(docCategory) && null != docCategory&&!"1".equals(isAccordToSubCom))
                                        {
                            %>
                                                <A HREF="#" 
												onClick="docPropDetailConfig(tab0001, <%=docPropId%>,<%=workflowId%>, <%= selectValue %>, '<%= docPath %>', <%= innerSecCategory %>)"
												><%=SystemEnv.getHtmlLabelName(21569,user.getLanguage())%></A>
                            <%
                                        }
                            %>
                                            </TD>
                                        </TR>
                            <%
                                        i++;
                                    }
                                }
                            %>
                                </TABLE>
                            </DIV>
                        <%
                            }
                        %>
                        </TD>
                        <TD></TD>
                    </TR>
                    <TR>
                        <TD height="10" colspan="3"></TD>
                    </TR>
                    <INPUT type=hidden id='workFlowID' name='workFlowID' value=<%= request.getParameter("wfid") %>>
                    <INPUT type=hidden id='formID' name='formID' value=<%= formID %>>
                    <INPUT type=hidden id='isbill' name='isbill' value=<%= isbill %>>
                    
                    
                    <input type=hidden id='pathCategoryDocument' name='pathCategoryDocument' value="<%= defaultView %>">
                    <input type=hidden id='mainCategoryDocument' name='mainCategoryDocument' value="<%= mainCategory %>">
                    <INPUT type=hidden id='subCategoryDocument' name='subCategoryDocument' value="<%= subCategory %>">
                    <INPUT type=hidden id='secCategoryDocument' name='secCategoryDocument' value="<%= secCategory %>">
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    
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