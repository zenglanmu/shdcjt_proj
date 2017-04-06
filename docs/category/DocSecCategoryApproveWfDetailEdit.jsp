<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.docs.category.security.AclManager" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryApproveWfManager" class="weaver.docs.category.SecCategoryApproveWfManager" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<html><head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<%
    //×ÓÄ¿Â¼id
	String id = Util.null2String(request.getParameter("id"));
	String approveType = Util.null2String(request.getParameter("approveType"));
	String approveWfId = Util.null2String(request.getParameter("approveWfId"));
    String approveTypeName="";
	if(approveType.equals("1")){
		approveTypeName=SystemEnv.getHtmlLabelName(19536,user.getLanguage());
	}else if(approveType.equals("2")){
		approveTypeName=SystemEnv.getHtmlLabelName(19537,user.getLanguage());
	}
	String approveWfName=WorkflowComInfo.getWorkflowname(approveWfId);


%>
<%	
	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();

	String subcategoryid=RecordSet.getString("subcategoryid");

	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);


	boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	AclManager am = new AclManager();
	hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
	hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);

    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSubManageRight || hasSecManageRight) {
		canEdit = true ;
	}


%>

<BODY >
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
  //²Ëµ¥
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }

      //RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='/docs/category/DocSecCategoryApproveWfEdit.jsp?id="+id+"',_self}";
      RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='/docs/category/DocSecCategoryApproveWfEdit.jsp?id="+id+"',_self}";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM METHOD="POST" name="frmMain" ACTION="DocSecCategoryApproveWfOperation.jsp">
<INPUT TYPE="hidden" NAME="operation">
<INPUT TYPE="hidden" NAME="id" value="<%=id%>">
<INPUT TYPE="hidden" NAME="approveType" value="<%=approveType%>">
<INPUT TYPE="hidden" NAME="approveWfId" value="<%=approveWfId%>">

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
		<table class="viewForm">
			<COLGROUP> <COL width="25%"> <COL width="75%">
			<TBODY>
			<TR class=Title>
				<TH colSpan=2><%=SystemEnv.getHtmlLabelName(18436,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height: 1px">
            	<TD class=Line1 colSpan=2></TD>
			</TR>
			<TR>
	            <TD><%=SystemEnv.getHtmlLabelName(19535,user.getLanguage())%></TD>
	            <TD class=Field><%=approveTypeName%></TD>
			</TR>
			<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
			<TR>
	            <TD><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage())%></TD>
	            <TD class=Field><%=approveWfName%></TD>
			</TR>
			<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
            <TR>
                <TD height="15" colspan="2"></TD>
            </TR>
			</TBODY>
		</table>

		<TABLE class=ListStyle cellspacing=1>
			<COLGROUP> <COL width="30%"> <COL width="70%">
			<TBODY>
			<TR class=Title>
				<TH colSpan=2><%=SystemEnv.getHtmlLabelName(19538,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height: 1px">
            	<TD class=Line1 colSpan=2 style="padding: 0"></TD>
			</TR>
            <TR class=Header>
                <TH><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></TH>
                <TH><%=SystemEnv.getHtmlLabelName(19539,user.getLanguage())%></TH>
            </TR>
            <%=SecCategoryApproveWfManager.getApproveWfTRString(id,approveType,approveWfId,user.getLanguage(),canEdit)%>
            <TR>
                <TD height="15" colspan="2"></TD>
            </TR>
			</TBODY>
		</table>

		<table class="viewForm">
			<COLGROUP>
			<COL width="100%">
			<TBODY>
			<TR class=Title>
				<TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height: 1px">
            	<TD class=Line1 ></TD>
			</TR>
			<TR>
	            <TD>
                    <ul>
					  <li><%=SystemEnv.getHtmlLabelName(20297,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(20298,user.getLanguage())%></li>
                    </ul>
				</TD>
			</TR>
			<TR style="height: 1px"><TD class=Line></TD></TR>

            <TR>
                <TD height="15" colspan="2"></TD>
            </TR>
			</TBODY>
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
</FORM>
</BODY>
</HTML>

<SCRIPT LANGUAGE="javascript">

function onSave(obj){
    
	obj.disabled=true;
    document.frmMain.operation.value="editApproveWfDetail";
    document.frmMain.submit();
}
 
function onCancel(){
    

    document.frmMain.operation.value="editApproveWfDetail";
    document.frmMain.submit();
}
function onDocProperty(id,obj){
//id = window.showModalDialog("DocSecCategoryDocPropertyBrowser.jsp?seccategory="&id)
	data = window.showModalDialog("DocSecCategoryDocPropertyBrowser.jsp?seccategory="+id+"&needDocumentCreator=1&needCurrentOperator=1")
//if not IsEmpty(id) then
//	obj.parentElement.children(1).innerHTML = id(1)
//	obj.parentElement.children(2).value=id(0)
//else 
//	obj.parentElement.children(1).innerHTML = empty
//	obj.parentElement.children(2).value=""    
//end if

	if(data){
	    if(wuiUtil.getJsonValueByIndex(data,0)!=0){
		    jQuery(obj).parent().find(":eq(1)").html(wuiUtil.getJsonValueByIndex(data,1));
		    jQuery(obj).parent().find(":eq(2)").val(wuiUtil.getJsonValueByIndex(data,0))
		    //obj.parentElement.children(1).innerHTML = getJsonValueByIndex(data,1)
		    //obj.parentElement.children(2).value=getJsonValueByIndex(data,0)
	    }else{
	    	jQuery(obj).parent().find(":eq(1)").html(wuiUtil.getJsonValueByIndex(data,1));
		    jQuery(obj).parent().find(":eq(2)").val(wuiUtil.getJsonValueByIndex(data,0));
		    //obj.parentElement.children(1).innerHTML = ""
		    //obj.parentElement.children(2).value=""
	    }		  
	}
}
</SCRIPT>
