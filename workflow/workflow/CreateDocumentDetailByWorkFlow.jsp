<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTwo" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<HTML>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19331,user.getLanguage()) + SystemEnv.getHtmlLabelName(19342,user.getLanguage());
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
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveCreateDocumentDetail(this),_self}";
    RCMenuHeight += RCMenuHeightStep;      
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelCreateDocumentDetail(this),_self}";
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
        String flowID = request.getParameter("flowID");
        String selectItemID = request.getParameter("selectItemID");
        String pathCategory = request.getParameter("pathCategory");
        String secCategoryID = request.getParameter("secCategoryID");        
        String formID = request.getParameter("formID");
                										        
		String parameterMouldID = request.getParameter("mouldID");

		if(parameterMouldID==null||"".equals(parameterMouldID)){
			RecordSet.executeSql("select docMouldId from workflow_docshow where flowId="+flowID+" and fieldid!=-1 and selectItemId="+selectItemID+"  and exists (select 1 from DocSecCategoryMould where mouldType in(3,7) and secCategoryId=workflow_docshow.secCategoryId and mouldId=workflow_docshow.docMouldId)   order by isDefault desc ,fieldId asc");
			if(RecordSet.next()){
				parameterMouldID = Util.null2String(RecordSet.getString("docMouldId"));
			}
		}

        String isbill = WorkflowComInfo.getIsBill(""+flowID);
		if(isbill==null||isbill.trim().equals("")){
			RecordSet.executeSql("select isbill from workflow_base where id="+flowID);
			if(RecordSet.next()){
				isbill = Util.null2String(RecordSet.getString("isbill"));
			}
		}
		if(!"1".equals(isbill)){
			isbill="0";
		}		
        /*================ 编辑信息 ================*/
        Map docMouldBookMarkMap = new Hashtable();
        Map docMouldDateShowTypeMap = new HashMap();
        String docMouldIDEdit = "-1";
        int tempFieldId=-1;
		String tempFieldHtmlType="";
		int tempType=-1;
		
        String editSQL = "SELECT docMouldID, modulId, fieldId,dateShowType FROM workflow_docshow WHERE flowId = " + flowID + " AND selectItemId = " + selectItemID;
        if(!"".equals(parameterMouldID) && null != parameterMouldID)
        //如果通过选择模版进入，则需要加上参数以确定 选择的模版 是否已经被设置过
        {
        	editSQL += " AND docMouldID = " + parameterMouldID;
        }
        RecordSet.executeSql(editSQL);

        while(RecordSet.next())
        {
        	docMouldIDEdit = String.valueOf(RecordSet.getInt("docMouldID"));

            //docMouldBookMarkMap.put(RecordSet.getString("modulId"), RecordSet.getString("fieldId"));
			tempFieldId=Util.getIntValue(RecordSet.getString("fieldId"),-1);
            //docMouldBookMarkMap.put(RecordSet.getString("modulId"), tempFieldId+"_"+FieldComInfo.getFieldhtmltype(""+tempFieldId)+"_"+FieldComInfo.getFieldType(""+tempFieldId));
			if(tempFieldId==-3){
				docMouldBookMarkMap.put(RecordSet.getString("modulId"), "-3_-1_-1");
			}else{
				if("1".equals(isbill)){
			        RecordSetTwo.executeSql("select fieldLabel,fieldHtmlType,type from workflow_billfield where id=" + tempFieldId);
			        if(RecordSetTwo.next()){
				        tempFieldHtmlType=Util.null2String(RecordSetTwo.getString("fieldHtmlType"));
				        tempType=Util.getIntValue(RecordSetTwo.getString("type"),0);
					    docMouldBookMarkMap.put(RecordSet.getString("modulId"), tempFieldId+"_"+tempFieldHtmlType+"_"+tempType);
			        }
				}else{
					docMouldBookMarkMap.put(RecordSet.getString("modulId"), tempFieldId+"_"+FieldComInfo.getFieldhtmltype(""+tempFieldId)+"_"+FieldComInfo.getFieldType(""+tempFieldId));
				}
			}
            docMouldDateShowTypeMap.put(RecordSet.getString("modulId"), Util.null2String(RecordSet.getString("dateShowType")));
        }

              
        /*================ 下拉框信息 ================*/
        List formDictIDList = new ArrayList();
        List formDictLabelList = new ArrayList();
		String SQL = null;
		if("1".equals(isbill)){
			SQL = "select formField.id,fieldLable.labelName as fieldLable,formField.fieldHtmlType,formField.type "
                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                    + "where fieldLable.indexId=formField.fieldLabel "
                    + "  and formField.billId= " + formID
                    + "  and formField.viewType=0 "
                    + "  and fieldLable.languageid =" + user.getLanguage()
                    + "  order by formField.dspOrder  asc ";
		}else{		
			SQL = "select formDict.ID, fieldLable.fieldLable,formDict.fieldHtmlType,formDict.type "
                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                    + "  and formField.formid = " + formID
                    + "  and fieldLable.langurageid = " + user.getLanguage()
                    + " order by formField.fieldorder";
		}                    
        RecordSet.executeSql(SQL);
        
        while(RecordSet.next())
        {
            //formDictIDList.add(RecordSet.getString("ID"));
			tempFieldId=Util.getIntValue(RecordSet.getString("ID"),-1);
			tempFieldHtmlType=Util.null2String(RecordSet.getString("fieldHtmlType"));
	    	tempType=Util.getIntValue(RecordSet.getString("type"),0);
			//formDictIDList.add(tempFieldId+"_"+FieldComInfo.getFieldhtmltype(""+tempFieldId)+"_"+FieldComInfo.getFieldType(""+tempFieldId));
			formDictIDList.add(tempFieldId+"_"+tempFieldHtmlType+"_"+tempType);
            formDictLabelList.add(RecordSet.getString("fieldLable"));
        }        
%>

<FORM name="createDocumentDetailByWorkFlow" method="post" action="CreateDocumentDetailByWorkFlowOperation.jsp" >

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
                            <!--================== 创建文档属性 ==================-->
                            <TABLE class="viewform">
                                <COLGROUP>
                                   <COL width="25%">
                                   <COL width="75%">
                                <TR class="Title">
                                    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(19367,user.getLanguage())%></TH>
                                </TR>                                
                                <TR class="Spacing" style="height:1px;">
                                    <TD class="Line1" colSpan=2></TD>
                                </TR>
                                
                                <TR >
                                    <TD><%=SystemEnv.getHtmlLabelName(19368,user.getLanguage())%></TD>
                                    <TD class=Field><%= pathCategory %></TD>
                                </TR>
                                <TR class="Spacing" style="height:1px;">
                                    <TD class="Line" colSpan=2></TD>
                                </TR>
                                
                                <TR >
                                    <TD><%=SystemEnv.getHtmlLabelName(19369,user.getLanguage())%></TD>
                                	<TD class=Field>                                		
		                                <%
									        String docMouldID = "-1";
									        String docMouldName = "";
									        
									        String finalDocMouldID = "-1";  //在“文档数据设置”需要显示的文档模版ID									        									        
									    %>
								    	<SELECT class=inputstyle name="docMouldID" onchange="detailConfig(tab0001, '<%= flowID %>', '<%= selectItemID %>', '<%= pathCategory %>', '<%= secCategoryID %>', '<%= formID %>', this.value)">
								    		<OPTION value="-1"></OPTION>
								    	<%
								    		 /*================ 正常文档绑定情况 ================*/
									        RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategoryID);

											if(RecordSet.next())
											{
												docMouldID = RecordSet.getString("ID");										            
									            docMouldName = RecordSet.getString("mouldName");
								    	%>
								    		<OPTION value="<%= docMouldID %>" <% if(!"".equals(parameterMouldID) && null != parameterMouldID) { if(docMouldID.equals(parameterMouldID)) { finalDocMouldID = parameterMouldID; %> selected <% }} else if (!"-1".equals(docMouldIDEdit)) { if(docMouldID.equals(docMouldIDEdit)) { finalDocMouldID = docMouldIDEdit; %> selected <% }} %>><%= docMouldName %></OPTION>
								    	<%
									        }
											/*================ 可选择情况 ================*/
									        else
									        {
									        	RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategoryID);
									       		
									        	while(RecordSet.next())
										        {
										            docMouldID = RecordSet.getString("ID");										            
										            docMouldName = RecordSet.getString("mouldName");
	
									    %>
									    		<OPTION value="<%= docMouldID %>" <% if(!"".equals(parameterMouldID) && null != parameterMouldID) { if(docMouldID.equals(parameterMouldID)) { finalDocMouldID = parameterMouldID; %> selected <% }} else if (!"-1".equals(docMouldIDEdit)) { if(docMouldID.equals(docMouldIDEdit)) { finalDocMouldID = docMouldIDEdit; %> selected <% }} %>><%= docMouldName %></OPTION>
									    <%
										        }
										        
										    }									        
		                                %>
			                            </SELECT>
                                    </TD>
                                </TR>
                                <TR class="Spacing" style="height:1px;">
                                    <TD class="Line" colSpan=2></TD>
                                </TR>
                                
                                <TR>
                                    <TD height="10" colspan="2"></TD>
                                </TR>
                            </TABLE>
                            
                            <!--================== 文档数据设置 ==================-->
                            <TABLE class="viewform">                           
                                <TR class="Title">
                                    <TH><%=SystemEnv.getHtmlLabelName(19370,user.getLanguage())%></TH>
                                </TR>
                                <TR class="Spacing" style="height:1px;">
                                    <TD class="Line1"></TD>
                                </TR>
                            </TABLE>
                            <TABLE class="liststyle">
                                <COLGROUP>
                                   <COL width="30%">
                                   <COL width="30%">
                                   <COL width="40%">    
                                <TR class="header">
                                    <TD><%=SystemEnv.getHtmlLabelName(19371,user.getLanguage())%></TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(21271,user.getLanguage())%></TD>
                                </TR>
                            <%
                                int i = 0;
                                
                                //RecordSet.executeSql("SELECT ID, name FROM mouldBookMark WHERE mouldID = " + finalDocMouldID);
                                RecordSet.executeSql("SELECT ID, name FROM mouldBookMark WHERE mouldID = " + finalDocMouldID+" order by showOrder asc,id asc");

                                while(RecordSet.next())
                                {
                                    String bookMarkID = RecordSet.getString("ID");
                            %>
                                    <TR class=<% if(0 == i % 2) {%> DataDark <% } else { %> DataLight <% } %>>
                                        <TD><INPUT TYPE="hidden" NAME="bookMarkID<%= i %>" VALUE="<%= bookMarkID %>"><%=RecordSet.getString("name")%></TD>
                                        <TD>
                                            <SELECT class=inputstyle name="documentConfig<%= i %>" id="documentConfig_<%=i%>" onChange='changeDateShowType(this)'>
                                                <OPTION value=-1_-1_-1></OPTION>
											    <option value=-3_-1_-1  <%if ("-3_-1_-1".equals((String)(docMouldBookMarkMap.get(bookMarkID)))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
                            <%
                                            for(int j = 0; j < formDictIDList.size(); j++)
                                            {
                            %>                   
                                                <OPTION value=<%= (String)formDictIDList.get(j) %>  <% if(((String)formDictIDList.get(j)).equals((String)(docMouldBookMarkMap.get(bookMarkID)))) { %> selected <% } %>   ><%= (String)formDictLabelList.get(j) %></OPTION>
                            <%
                                            }
                            %>                         
                                            </SELECT>
                                        </TD>
                                        <TD>
<%
String divStyle="display:none";
if((Util.null2String((String)(docMouldBookMarkMap.get(bookMarkID)))).endsWith("_3_2")){
	divStyle="display:''";
}
String tempDateShowType=Util.null2String((String)(docMouldDateShowTypeMap.get(bookMarkID)));
%>
								          <div id='divDateShowType_<%=i%>' style="<%=divStyle%>">
                                            <SELECT class=inputstyle name="dateShowType<%=i%>">
                                                <OPTION value=0></OPTION>
								                <OPTION value=1 <%if(tempDateShowType.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21263,user.getLanguage())%></OPTION>
								                <OPTION value=2 <%if(tempDateShowType.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21264,user.getLanguage())%></OPTION>
                                            </SELECT>
										  <div>
                                        </TD>
                                    </TR>
                            <%
                                    i++;
                                }
                            %>
                                <TR>
                                    <TD height="10" colspan="3"></TD>
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
    
    <INPUT TYPE="hidden" NAME="flowID" VALUE="<%= flowID %>">
    <INPUT TYPE="hidden" NAME="selectItemID" VALUE="<%= selectItemID %>">
    <INPUT TYPE="hidden" NAME="count" VALUE="<%= i %>">
    
    <INPUT TYPE="hidden" NAME="formID" VALUE="<%= formID %>">
    <INPUT TYPE="hidden" NAME="isbill" VALUE="<%= isbill %>">
    <INPUT TYPE="hidden" NAME="secCategoryID" VALUE="<%= secCategoryID %>">
            
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
