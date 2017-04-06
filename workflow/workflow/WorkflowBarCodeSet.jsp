<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>



<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowBarCodeSetManager" class="weaver.workflow.workflow.WorkflowBarCodeSetManager" scope="page" />


<HTML>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21449,user.getLanguage());
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
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveBarCodeSet(this),_self}";
    RCMenuHeight += RCMenuHeightStep;      
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelBarCodeSet(this),_self}";
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
        int workflowId = Util.getIntValue(request.getParameter("workflowId"),-1);
        String formId = request.getParameter("formId");
        String isBill = Util.null2String(request.getParameter("isBill"));
		
		int id=-1;
		String isUse="0";
		String measureUnit="1";
		int printRatio=96;
		int minWidth=30;
		int maxWidth=70;
		int minHeight=10;
		int maxHeight=25;
		int bestWidth=50;
		int bestHeight=20;

        RecordSet.executeSql("select * from Workflow_BarCodeSet where workflowId="+workflowId);

        if(RecordSet.next()){
        	id = Util.getIntValue(RecordSet.getString("id"),-1);
        	isUse = Util.null2String(RecordSet.getString("isUse"));
        	measureUnit = Util.null2String(RecordSet.getString("measureUnit"));
        	printRatio = Util.getIntValue(RecordSet.getString("printRatio"),96);
        	minWidth = Util.getIntValue(RecordSet.getString("minWidth"),30);
        	maxWidth = Util.getIntValue(RecordSet.getString("maxWidth"),70);
        	minHeight = Util.getIntValue(RecordSet.getString("minHeight"),10);
        	maxHeight = Util.getIntValue(RecordSet.getString("maxHeight"),25);
        	bestWidth = Util.getIntValue(RecordSet.getString("bestWidth"),50);
        	bestHeight = Util.getIntValue(RecordSet.getString("bestHeight"),20);
        }

		if(measureUnit.trim().equals("")){
			measureUnit="1";
		}        
%>

<FORM name="formBarCodeSet" method="post" action="WorkflowBarCodeSetOperation.jsp" >

    <INPUT TYPE="hidden" NAME="workflowId" VALUE="<%= workflowId %>">  
    <INPUT TYPE="hidden" NAME="formId" VALUE="<%= formId %>">
    <INPUT TYPE="hidden" NAME="isBill" VALUE="<%= isBill %>">
    <INPUT TYPE="hidden" NAME="id" VALUE="<%= id %>">

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
                            <!--================== 是否启用 ==================-->
                            <TABLE class="viewform">
                                <COLGROUP>
                                   <COL width="25%">
                                   <COL width="75%">
                                <TR class="Title">
                                    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></TH>
                                </TR>                                
                                <TR class="Spacing">
                                    <TD class="Line1" colSpan=2></TD>
                                </TR>
                                
                                <TR >
                                    <TD><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></TD>
                                    <TD class=Field><INPUT class=inputstyle type="checkbox" name="isUseBarCodeSet" value="1" onclick="showContentBarCodeSet()"  <%if("1".equals(isUse)) {%> checked <% } %>></TD>
                                </TR>
                                <TR class="Spacing">
                                    <TD class="Line" colSpan=2></TD>
                                </TR>
                                                                
                                <TR>
                                    <TD height="10" colspan="2"></TD>
                                </TR>
                            </TABLE>
<DIV id="contentDivBarCodeSet" <% if("1".equals(isUse)) { %> style="display:block" <% } else { %> style="display:none" <% } %>>									
                            <!--================== 打印设置 ==================-->
                            <TABLE class="viewform">
                                <COLGROUP>
                                   <COL width="20%">
                                   <COL width="30%">
                                   <COL width="20%">
                                   <COL width="30%">
                                <TR class="Title">
                                    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(20756,user.getLanguage())%></TH>
                                </TR>                                
                                <TR class="Spacing">
                                    <TD class="Line1" colSpan=4></TD>
                                </TR>
                                
                                <TR >
                                    <TD><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></TD>
                                    <TD class=Field>
                                            <SELECT class=inputstyle name="measureUnit" onChange="changeMeasureUnit(this.value)">
                                                <OPTION value="1" <% if(measureUnit.equals("1")) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(21450,user.getLanguage())%></OPTION>
                                                <OPTION value="2" <% if(measureUnit.equals("2")) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%></OPTION>
                                            </SELECT>
									</TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(21451,user.getLanguage())%></TD>
                                    <TD class=Field>
									    <%=SystemEnv.getHtmlLabelName(21452,user.getLanguage())%>	  
									    <input type="text" name="printRatioBarCodeSet" value="<%=printRatio%>" maxlength="4" size="4"  onKeyPress="ItemCount_KeyPress()" onChange='checknumber("printRatioBarCodeSet");checkinput("printRatioBarCodeSet","printRatioBarCodeSetImage")'>
                                        <SPAN id=printRatioBarCodeSetImage></SPAN>
										<%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%>
									</TD>
                                </TR>
                                <TR class="Spacing">
                                    <TD class="Line" colSpan=2></TD>
                                </TR>
                                
                                <TR >
                                    <TD><%=SystemEnv.getHtmlLabelName(21453,user.getLanguage())%></TD>
                                	<TD class=Field>
	                                  <input type="text" name="minWidthBarCodeSet" value="<%=minWidth%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("minWidthBarCodeSet");checkinput("minWidthBarCodeSet","minWidthBarCodeSetImage")'>
                                      <SPAN id=minWidthBarCodeSetImage></SPAN>
	                                  -
	                                  <input type="text" name="maxWidthBarCodeSet"   value="<%=maxWidth%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("maxWidthBarCodeSet");checkinput("maxWidthBarCodeSet","maxWidthBarCodeSetImage")'>
                                      <SPAN id=maxWidthBarCodeSetImage></SPAN>									
								      &nbsp;<span id=widthRangeSpan><%if("1".equals(measureUnit)){%><%=SystemEnv.getHtmlLabelName(21450,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%><%}%></span></TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(21454,user.getLanguage())%></TD>
                                	<TD class=Field>
	                                  <input type="text" name="bestWidthBarCodeSet"   value="<%=bestWidth%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("bestWidthBarCodeSet");checkinput("bestWidthBarCodeSet","bestWidthBarCodeSetImage")'>
                                      <SPAN id=bestWidthBarCodeSetImage></SPAN>
									  &nbsp;<span id=bestWidthSpan><%if("1".equals(measureUnit)){%><%=SystemEnv.getHtmlLabelName(21450,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%><%}%></span></TD>
                                </TR>
                                <TR class="Spacing">
                                    <TD class="Line" colSpan=2></TD>
                                </TR>

                                <TR >
                                    <TD><%=SystemEnv.getHtmlLabelName(21455,user.getLanguage())%></TD>
                                	<TD class=Field>
	                                  <input type="text" name="minHeightBarCodeSet" value="<%=minHeight%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("minHeightBarCodeSet");checkinput("minHeightBarCodeSet","minHeightBarCodeSetImage")'>
                                      <SPAN id=minHeightBarCodeSetImage></SPAN>
	                                  -
	                                  <input type="text" name="maxHeightBarCodeSet"   value="<%=maxHeight%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("maxHeightBarCodeSet");checkinput("maxHeightBarCodeSet","maxHeightBarCodeSetImage")'>
                                      <SPAN id=maxHeightBarCodeSetImage></SPAN>
									  &nbsp;<span id=heightRangeSpan><%if("1".equals(measureUnit)){%><%=SystemEnv.getHtmlLabelName(21450,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%><%}%></span></TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(21466,user.getLanguage())%></TD>
                                	<TD class=Field>
	                                  <input type="text" name="bestHeightBarCodeSet"   value="<%=bestHeight%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("bestHeightBarCodeSet");checkinput("bestHeightBarCodeSet","bestHeightBarCodeSetImage")'>
                                      <SPAN id=bestHeightBarCodeSetImage></SPAN>
									  &nbsp;<span id=bestHeightSpan><%if("1".equals(measureUnit)){%><%=SystemEnv.getHtmlLabelName(21450,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%><%}%></span></TD>
                                </TR>
                                <TR class="Spacing">
                                    <TD class="Line" colSpan=2></TD>
                                </TR>								

                                <TR>
                                    <TD height="10" colspan="2"></TD>
                                </TR>
                            </TABLE>
<%

        int dataElementNum=14;//数据元素个数，根据规范为14个。


        Map barCodeSetDetailMap = new HashMap();
		int tempDataElementId=0;
		int tempFieldId=0;
        RecordSet.executeSql("select * from Workflow_BarCodeSetDetail where barCodeSetId="+id);
        while(RecordSet.next()){
			tempDataElementId=Util.getIntValue(RecordSet.getString("dataElementId"),0);
			tempFieldId=Util.getIntValue(RecordSet.getString("fieldId"),0);

            barCodeSetDetailMap.put(""+tempDataElementId, ""+tempFieldId);
        }

              
        /*================ 下拉框信息 ================*/
        List formDictIdList = new ArrayList();
        List formDictLabelList = new ArrayList();
        
		String SQL = null;
		if("1".equals(isBill)){
			SQL = "select formField.id,fieldLable.labelName as fieldLable "
                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                    + "where fieldLable.indexId=formField.fieldLabel "
                    + "  and formField.billId= " + formId
                    + "  and formField.viewType=0 "
                    + "  and fieldLable.languageid =" + user.getLanguage()
                    + "  order by formField.dspOrder  asc ";
		}else{			
			SQL = "select formDict.ID, fieldLable.fieldLable "
                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                    + "and formField.formid = " + formId
                    + "and fieldLable.langurageid = " + user.getLanguage()
                    + " order by formField.fieldorder";
		}
                    
        RecordSet.executeSql(SQL);
        
        while(RecordSet.next()){
            formDictIdList.add(Util.null2String(RecordSet.getString("ID")));
            formDictLabelList.add(Util.null2String(RecordSet.getString("fieldLable")));
        }
%>                            
                            <!--================== 数据元素设置 ==================-->
                            <TABLE class="viewform">                           
                                <TR class="Title">
                                    <TH><%=SystemEnv.getHtmlLabelName(21456,user.getLanguage())%></TH>
                                </TR>
                                <TR class="Spacing">
                                    <TD class="Line1"></TD>
                                </TR>
                            </TABLE>
                            <TABLE class="liststyle">
                                <COLGROUP>
                                   <COL width="30%">
                                   <COL width="*">    
                                <TR class="header">
                                    <TD><%=SystemEnv.getHtmlLabelName(21457,user.getLanguage())%></TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></TD>
                                </TR>
                            <%
                                for(int i=1;i<=dataElementNum;i++){
                            %>
                                    <TR class=<% if(0 == i % 2) {%> DataDark <% } else { %> DataLight <% } %>>
                                        <TD><%=WorkflowBarCodeSetManager.getLabelNameByDataElementId(i,user.getLanguage())%></TD>
                                        <TD>
                                            <SELECT class=inputstyle name="fieldId<%=i%>">
                                                <OPTION value=-1></OPTION>
											    <option value=-3  <%if ("-3".equals((String)(barCodeSetDetailMap.get(""+i)))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
                            <%
                                            for(int j = 0; j < formDictIdList.size(); j++){
                            %>                   
                                                <OPTION value=<%= (String)formDictIdList.get(j) %>  <% if(((String)formDictIdList.get(j)).equals((String)(barCodeSetDetailMap.get(""+i)))) { %> selected <% } %>   ><%= (String)formDictLabelList.get(j) %></OPTION>
                            <%
                                            }
                            %>                         
                                            </SELECT>
                                        </TD>
                                    </TR>
                            <%
                                }
                            %>
                                <TR>
                                    <TD height="10" colspan="3"></TD>
                                </TR>
                            </TABLE>
</DIV>								
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
    
    <INPUT TYPE="hidden" NAME="dataElementNum" VALUE="<%=dataElementNum%>">  
            
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
