<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML>
<HEAD>
    <meta http-equiv="Pragma" content="no-cache" /> 
    <meta http-equiv="Cache-Control" content="no-cache" /> 
    <meta http-equiv="Expires" content="0" />
    
    <script type="text/javascript" src="/js/xmlextras.js"></script>
    <script type="text/javascript" src="/js/xtree1.js"></script>
    <script type="text/javascript" src="/js/xloadtree.js"></script>
	
		<link type="text/css" rel="stylesheet" href="/css/Weaver.css">
		<link type="text/css" rel="stylesheet" href="/js/xtree.css">

    <base target="mainFrame"/>
<style type="text/css">  
	.mainList{
		margin:0;
		padding:0;
		
	}

</style>

</HEAD>
<BODY oncontextmenu="return false;">
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

    <%@ include file="/systeminfo/RightClickMenu.jsp" %>

    <table width=100% class="ViewForm" valign="top">

        <TR>
            <td>
			<UL class="mainList"><LI><B><a href="#.jsp" onClick="onClickSys()" target="_self"><%=SystemEnv.getHtmlLabelName(21927,user.getLanguage())%></a></B><P>
<%
StringBuffer treeStr = new StringBuffer();

	RecordSet.execute("select * from worktask_base order by orderid");
	
 	while(RecordSet.next()){
 		treeStr = new StringBuffer();
 		
 		String wtname_tmp = Util.null2String(RecordSet.getString("name"));
 		String wtid_tmp = Util.null2String(RecordSet.getString("id"));

        treeStr.append("<UL class=\"subList\"><LI>");
        treeStr.append("<a href=\"#\" onClick=\"onClickCategory("+wtid_tmp+");\"");
        treeStr.append(" target=\"_self\" >");
        treeStr.append(wtname_tmp);
        treeStr.append("</a></UL></LI><P>");
        out.println(treeStr.toString());
 	}
%></LI></UL>
            <td>
        </tr>
    </table>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="worktaskAdd.jsp" method=post target="contentframe">
    <input type="hidden" name="wtid" value="">
    </FORM>
    
<script type="text/javascript">
function onClickSys(){
	document.SearchForm.action = "worktaskSysSet.jsp";
	document.all("wtid").value = "0";
	document.SearchForm.submit();

}
function onClickCategory(id) {
	document.SearchForm.action = "worktaskAdd.jsp";
	document.all("wtid").value = id;
	document.SearchForm.submit();
}
</script>
</BODY>
</HTML>