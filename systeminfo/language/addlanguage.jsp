<%@ page import="weaver.general.Util" %>
<jsp:useBean id="LanguageManager" class="weaver.systeminfo.language.LanguageManager" scope="session"/>
<html>
<%
	String type="";
	int title=0;
	String languagename="";
    String id="";
	String languagedesc="";
	String encode="";
	String isactive="";
	int languageid=0;
	languageid=Util.getIntValue(Util.null2String(request.getParameter("languageid")),0);
	type = Util.null2String(request.getParameter("src"));
	if(type=="") 
		type = "addlanguage";
	if(type.equals("addlanguage"))
		title=1;
	else {
		title=0;
		LanguageManager.setLanguageid(languageid);
		LanguageManager.getLanguageInfo();
		languagename=LanguageManager.getLanguagename();
		encode=LanguageManager.getencode();
		isactive=LanguageManager.getisactive();
	}	
%>

<head>
</head>

<body>
<form name="id" method="post" action="language_operation.jsp">
  <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
    <tr> 
      <td colspan="7" height="23" bgcolor="#7777FF"><b><font color="#FFFFFF">
        <%if(title==1){%>
        添加语言
        <%}else{%>
        编辑语言
        <%}%>
        </font></b></td>
    </tr>
    <tr> 
      <td colspan="7" align="center" height="15"></td>
    </tr>
    <tr>
      <td width="50%" align="center" bgcolor="#CCCCCC" height="23">ID号</td>
      <td width="50%" align="left" bgcolor="#D2D1F1" height="23">
        <input type="text" name="id" value="<%=languageid%>">
      </td>
    </tr>
    <tr> 
      <td width="50%" align="center" bgcolor="#CCCCCC" height="23">语言名称</td>
      <td width="50%" align="left" bgcolor="#D2D1F1" height="23">
        <input type="text" name="languagename" size="40" value="<%=languagename%>">
      </td>
    </tr>
    <tr> 
      <td width="50%" align="center" bgcolor="#CCCCCC" height="23">编码方式</td>
      <td width="50%" align="left" bgcolor="#D2D1F1" height="23">
        <input type="text" name="encode" size="40" value="<%=encode%>">
      </td>
    </tr>
    <tr> 
      <td width="50%" align="center" bgcolor="#CCCCCC" height="23">语言状态</td>
      <td width="50%" align="left" bgcolor="#D2D1F1" height="23"> 
        <select size=1 name="isactive">
          <%if (isactive.equals("1")){%>
          <option value="0">未激活</option>
          <option value="1" selected>已激活</option>
          <%}
      else {%>
          <option value="0" selected>未激活</option>
          <option value="1">已激活</option>
          <%}%>
        </select>
      </td>
    </tr>
    <tr> 
      <td colspan="2" align="right" height="42"> 
        <input type="submit" value="保存" name="submit">
        <% if(type.equals("addlanguage")){%>
        <input type="reset" value="清除" name="reset">
        <%}%>
        <input type="button" value="取消" name="cancel" onclick="history.back(-1)">
      </td>
      <input type="hidden" value="<%=type%>" name="src">
      <input type="hidden" value="<%=languageid%>" name="languageid"></td>
    </tr>
  </table>
</form>
</body>

</html>