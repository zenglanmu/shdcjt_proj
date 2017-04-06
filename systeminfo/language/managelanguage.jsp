<%@ page import="weaver.general.Util" %>
<jsp:useBean id="LanguageInfo" class="weaver.systeminfo.language.LanguageManager" scope="page" />
<jsp:useBean id="LanguageMainManager" class="weaver.systeminfo.language.LanguageMainManager" scope="page" />
<%LanguageMainManager.resetParameter();%>
<jsp:setProperty name="LanguageMainManager" property = "*"/>
<html>
<head>
<title>语言维护</title>
<script language="javascript">
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_language_id') {
document.form2.elements[i].checked=(checked==true?true:false);
} } }


function unselectall()
{
    if(document.form2.checkall0.checked){
	document.form2.checkall0.checked =0;
    }
}
function confirmdel() {
	return confirm("确定删除选定的信息吗?") ;
}

function OpenNewWindow(sURL,w,h)
{
  var iWidth = 0 ;
  var iHeight = 0 ;
  iWidth=(window.screen.availWidth-10)*w;
  iHeight=(window.screen.availHeight-50)*h;
  ileft=(window.screen.availWidth - iWidth)/2;
  itop= (window.screen.availHeight - iHeight + 50)/2;
  var szFeatures = "" ;
  szFeatures =	"resizable=no,status=no,menubar=no,width=" + 
				iWidth + ",height=" + iHeight*h + ",top="+itop+",left="+ileft
  window.open(sURL,"",szFeatures)
}

</script>
</head>
<body>
<%
	String languageid=""+Util.getIntValue(request.getParameter("languageid"),0);
	String languagename=Util.null2String(request.getParameter("languagename"));
	String languagedesc=Util.null2String(request.getParameter("languagedesc"));
	String encode=Util.null2String(request.getParameter("encode"));	
	String isactive=Util.null2String(request.getParameter("isactive"));	
	
%>
      <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
        <tr> 
          <td colspan="7" height="23" bgcolor="#7777FF"><b><font color="#FFFFFF">语言维护</font></b></td>
        </tr>
        <tr> 
          <td colspan="7" align="center" height="15"></td>
        </tr>
        <form name="form2" method="post" onSubmit="return confirmdel()" action="dellanguage.jsp">
          <input type=hidden name=languageid value="<%= languageid %>">
          <input type=hidden name=languagename value="<%= languagename %>">
          <input type=hidden name=encode value="<%= encode %>">
          <input type=hidden name=isactive value="<%= isactive %>">
          <tr> 
            <td width="10%" align="center" bgcolor="#CCCCCC" height="23">选中</td>
            <td width="20%" align="center" bgcolor="#CCCCCC" height="23">语言名称</td>
	    <td width="20%" align="center" bgcolor="#CCCCCC" height="23">编码方式</td>	
            <td width="20%" align="center" bgcolor="#CCCCCC" height="23">是否激活</td>	
            <td width="10%" align="center" bgcolor="#CCCCCC" height="23">编辑</td>
          </tr>
          <%
            LanguageMainManager.selectLanguage();

            while(LanguageMainManager.next()){
              LanguageInfo = LanguageMainManager.getLanguageManager();
			  
          %>
          <tr> 
            <td width="10%" align="center" bgcolor="#D2D1F1"> 
              <input type="checkbox"  name="delete_language_id" value="<%=LanguageInfo.getLanguageid()%>" onClick=unselectall()>
            </td>
            <td width="20%" align="center" bgcolor="#D2D1F1"><%=LanguageInfo.getLanguagename()%></td>
            <td width="20%" align="center" bgcolor="#D2D1F1"><%=LanguageInfo.getencode()%></td>
            <%if (LanguageInfo.getisactive().equals("0")){%>
            <td width="20%" align="center" bgcolor="#D2D1F1"><font color=yellow>未激活<a href="activelanguage.jsp?isactive=1&languageid=<%=LanguageInfo.getLanguageid()%>"><img src="/images/transfer.gif" width="16" height="16" border="0"></font></td>
            <% } 
               else {%>
            <td width="20%" align="center" bgcolor="#D2D1F1"><font color=green>已激活<a href="activelanguage.jsp?isactive=0&languageid=<%=LanguageInfo.getLanguageid()%>"><img src="/images/transfer.gif" width="16" height="16" border="0"></font></td>
            <%}%>   
            <td width="10%" align="center" bgcolor="#D2D1F1"> <a href="addlanguage.jsp?src=editlanguage&languageid=<%=LanguageInfo.getLanguageid()%>"><img src="/images/iedit.gif" width="16" height="16" border="0"></a> 
            </td>
          </tr>
          <%}
            LanguageMainManager.closeStatement();
          %>
          <tr> 
            <td colspan="9" height="19"> 
              <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
              全部选中</td>
          </tr>
          <tr> 
            
      <td colspan="9" align="right" height="42"> 
        <input type="button" name="Submit" value="导出SQL语句" onclick="document.SqlLanguage.submit()">
        <input type="button" name="Submit4" value="添加语言" onclick="document.addlanguage.submit()">
              <input type="submit" name="Submit2" value="删除语言">
            </td>
          </tr>
        </form>
        <form name="addlanguage" action = "addlanguage.jsp">
        </form>
		<form name="SqlLanguage" action = "SqlLanguage.jsp">
        </form>
      </table>
