<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
String companyName="";
String cversion="";
RecordSet.executeSql("select companyname,cversion from license");
if (RecordSet.next())
{
	companyName=RecordSet.getString("companyname");
	cversion=RecordSet.getString("cversion");
}
%>


<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(16900,user.getLanguage())%> ecology</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link rel="stylesheet" href="/css/Weaver.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" scroll="no">

<style>
.textfield{
	width:100%;
	height:60px;
	overflow:auto;
	border:1px solid #31699B;
}

.splite{
	width:25px;
	display:inline;
}
</style>
<table width="460" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td colspan="2"><img src="/images_face/version/ecology.gif"></td>
  </tr>
  <tr> 
    <td width="362" valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr>
          <td height="20">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>:&nbsp;<%=cversion%></td>
        </tr>
        <tr>
          <td height="20">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16898,user.getLanguage())%>:&nbsp;<%=companyName%></td>
        </tr>
        <tr>
        <%if(user.getLanguage()==7){%>
          <td>              
            <div class="textfield"><div class='splite'></div>本软件是基于J2EE的各种技术，B/S模式的三层结构设计完成的，由上海泛微网络科技股份有限公司独立开发。<br>
<div class='splite'></div>本软件的版权属于上海泛微网络科技股份有限公司，未经泛微公司的授权许可不得擅自发布或使用该软件。<br>
<div class='splite'></div>weaver e-cology、泛微司标均是上海泛微网络科技股份有限公司商标，Windows、NT、Java等均是各相关公司的商标或注册商标。<br>
<div class='splite'></div>警告:本计算机程序受著作权法和国际公约的保护，未经授权擅自复制或散布本程序的部分或全部，将承受严厉的民事和刑事处罚，对已知的违反者将给予法律范围内的全面制裁。</div>
          </td>
         <%}else if(user.getLanguage()==8){%>
          <td>              
            <div class="textfield"><div class='splite'></div>This software is based on various technologies of J2EE and three-layer framework of B/S mode,It's developed independently by Shanghai Weaver Network Co., Ltd.<br>
<div class='splite'></div>The copyright of this software belongs to Shanghai Weaver Network Co., Ltd.It is prohibited to release or use this software.<br>
<div class='splite'></div>Weaver e-cology and releated are trademarks of Shanghai Weaver Network Co., Ltd.Windows, NT, Java and related are trademarks of the other companies.<br>
<div class='splite'></div>Warning:This program is protected by the law of copyright and the law of international convention. Without permission, any copying or dispersing any part of the program will be subjected to civil and criminal penalties. Any trespasser who knows this warning will be measured out harsh justice.</div>
          </td>
         <%}else if(user.getLanguage()==9){%>
          <td>              
            <div class="textfield"><div class='splite'></div>本軟件是基於J2EE的各種技術，B/S模式的三層結構設計完成的，由上海泛微網络科技股份有限公司獨立開發。<br> 
<div class='splite'></div>本軟件的版權屬於上海泛微網络科技股份有限公司，未經泛微公司的授權許可不得擅自發布或使用該軟件。 <br>
<div class='splite'></div>weaver e-cology、泛微司標均是上海泛微網络科技股份有限公司商標，Windows、NT、Java等均是各相關公司的商標或註冊商標。<br> 
<div class='splite'></div>警告:本計算機程序受著作權法和國際公約的保護，未經授權擅自複製或散佈本程序的部分或全部，將承受嚴厲的民事和刑事處罰，對已知的違反者將給予法律範圍內的全面製裁。</div>
          </td>
         <%}%>
        </tr>
        <tr height="5">
          <td></td>
        </tr>
        <tr height="30">          <td>&nbsp;&nbsp;<u><%=SystemEnv.getHtmlLabelName(16899,user.getLanguage())%>&nbsp;&nbsp;&copy;&nbsp;&nbsp;Shanghai Weaver Network Co., Ltd</u></td>
        </tr>
        <tr height="30">
          <td align="right"><button name="submit" onclick="window.close()" style="width:80px"><%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></button>&nbsp;&nbsp;</td>
        </tr>
        <tr height="30">
          <td></td>
        </tr>
        <tr height="30">
          <td valign="bottom">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16897,user.getLanguage())%>:&nbsp;<a href="http://www.weaver.com.cn" target="_blank"><u>www.weaver.com.cn</u></a></td>
        </tr>
      </table>
    </td>
    <td width="98"><img src="/images_face/version/img.gif"></td>
  </tr>
</table>
</body>
</html>