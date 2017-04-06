<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>





<%
String treeDocFieldId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;

String treeDocFieldName=DocTreeDocFieldComInfo.getTreeDocFieldName(treeDocFieldId);


%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(19410,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

if(HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
    

if(HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(19412,user.getLanguage())+",/docs/category/DocTreeDocFieldAdd.jsp?superiorFieldId="+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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

<FORM id=weaver name=frmMain action="DocTreeDocFieldOperation.jsp" method=post target="_parent">


        <TABLE class=ViewForm width="100%">
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
          <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height: 1px!important;">
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
            <TD class=FIELD>
              <INPUT class=InputStyle  name=treeDocFieldName value="<%=treeDocFieldName%>" onchange='checkinput("treeDocFieldName","treeDocFieldNameImage")'>
                 <SPAN id=treeDocFieldNameImage></SPAN>
              </TD>
          </TR>
         <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>


   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=treeDocFieldId%>">
 </FORM>

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
</BODY></HTML>


<script language=javascript>

function onSave(){
	document.frmMain.operation.value="RootEditSave";
	document.frmMain.submit();
}

</script>
