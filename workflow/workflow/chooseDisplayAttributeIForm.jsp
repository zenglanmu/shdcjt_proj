<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<HTML>
    <HEAD>
    <%
        int fieldId = Util.getIntValue(request.getParameter("fieldId"),-1);
		int workflowId = Util.getIntValue(request.getParameter("wfid"),-1);

        String formID = WorkflowComInfo.getFormId(""+workflowId);
        String isbill = WorkflowComInfo.getIsBill(""+workflowId);
		if(!"1".equals(isbill)){
			isbill="0";
		}
		
        Map docPropIdMap=new HashMap();
		String tempSelectItemId=null;
		String tempDocPropId=null;
		RecordSet.executeSql("SELECT id,selectItemId FROM Workflow_DocProp where workflowId="+workflowId);
		while(RecordSet.next()){
			tempSelectItemId=Util.null2String(RecordSet.getString("selectItemId"));
			tempDocPropId=Util.null2String(RecordSet.getString("id"));
			if(!(tempSelectItemId.trim().equals(""))){
				docPropIdMap.put(tempSelectItemId,tempDocPropId);
			}
		}                    
    %>
    </HEAD>
<BODY>

</BODY>
</HTML>

<SCRIPT language="javascript">
    deleteTable();
    addTable();

    function deleteTable()
    {
        var oTable=window.parent.document.all("chooseDisplayAttribute");

        var len = oTable.rows.length * 1;

        var i = 0;
        
        for(i = len - 1; i >= 1; i--) 
        {
            oTable.deleteRow(i);
        }
    }
    
    function addTable()
    {
        var oTable=window.parent.document.all('chooseDisplayAttribute');
<%
        RecordSet.executeSql("select ID, selectValue, selectName, docPath, docCategory from workflow_SelectItem where fieldid = " + fieldId + " and isBill = "+isbill+" and cancel<>'1' order by listOrder asc ");
		
        while(RecordSet.next()){
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
%>
            var oRow = oTable.insertRow();
            var oRowIndex = oRow.rowIndex;
    
            if (0 == oRowIndex % 2)
            {
                oRow.className = "dataLight";
            }
            else
            {
                oRow.className = "dataDark";
            }
    
            //文档类型
            oCellDocumentType = oRow.insertCell();
            var oDivDocumentType = window.parent.document.createElement("div");        
            oDivDocumentType.innerHTML="<%=RecordSet.getString("selectName")%>";                    
            oCellDocumentType.appendChild(oDivDocumentType);
            
            //关联目录
            oCellDocumentCatalog = oRow.insertCell();
            var oDivDocumentCatalog = window.parent.document.createElement("div");        
            oDivDocumentCatalog.innerHTML="<%= docPath %>";                    
            oCellDocumentCatalog.appendChild(oDivDocumentCatalog);
                    
            //详细设置
            oCellDetalConfig = oRow.insertCell();
            var oDivDetalConfig = window.parent.document.createElement("div");
<%
            if(!"".equals(docPath) && null != docPath && !"".equals(docCategory) && null != docCategory)
            {
%>
                oDivDetalConfig.innerHTML="<A HREF=\"#\" onClick=\"detailConfig(tab0001, <%= workflowId %>, <%= selectValue %>, '<%= docPath %>', <%= innerSecCategory %>, <%= formID %>)\"\"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></A>";                    
<%
            }
%>
            oCellDetalConfig.appendChild(oDivDetalConfig);

            //文档属性页设置
            oCellDocPropDetailConfig = oRow.insertCell();
            var oDivDocPropDetailConfig = window.parent.document.createElement("div");
<%
            if(!"".equals(docPath) && null != docPath && !"".equals(docCategory) && null != docCategory)
            {
%>
                oDivDocPropDetailConfig.innerHTML="<A HREF=\"#\" onClick=\"docPropDetailConfig(tab0001,<%=docPropId%>, <%= workflowId %>, <%= selectValue %>, '<%= docPath %>', <%= innerSecCategory %>)\"\"><%=SystemEnv.getHtmlLabelName(21569,user.getLanguage())%></A>";                    
<%
            }
%>
            oCellDocPropDetailConfig.appendChild(oDivDocPropDetailConfig);

<%            
        }
%>
    }
                
</SCRIPT>
