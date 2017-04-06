<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
int userid=user.getUID();
if(!HrmUserVarify.checkUserRight("CoWorkAccessory:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	String method = Util.null2String(request.getParameter("method"));
  String pathcategory = "";
  String maincategory = "";
  String subcategory = "";
  String seccategory = "";
  if(method.equals("save")){
	  pathcategory = Util.null2String(request.getParameter("pathcategory"));
	  maincategory = Util.null2String(request.getParameter("maincategory"));
	  subcategory = Util.null2String(request.getParameter("subcategory"));
	  seccategory = Util.null2String(request.getParameter("seccategory"));
	  RecordSet.executeSql("delete from CoworkAccessory");
	  RecordSet.executeSql("insert into CoworkAccessory values('"+pathcategory+"','"+maincategory+"','"+subcategory+"','"+seccategory+"')"); 	
	  %>
    <script language=javascript>
	  alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
	  window.location = "accessorySetting.jsp";
    </script>
  <%}
  int maxsize = 0;
  RecordSet.executeSql("select * from CoworkAccessory");
	if(RecordSet.next()){
		//pathcategory = Util.null2String(RecordSet.getString(1));
	  maincategory = Util.null2String(RecordSet.getString(2));
	  subcategory = Util.null2String(RecordSet.getString(3));
	  seccategory = Util.null2String(RecordSet.getString(4));
	  pathcategory = "/"+MainCategoryComInfo.getMainCategoryname(maincategory)+
	                 "/"+SubCategoryComInfo.getSubCategoryname(subcategory)+
	                 "/"+SecCategoryComInfo.getSecCategoryname(seccategory);
	}
  %>
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(21274,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<tr>
<td height="10" colspan="2"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=weaver action="accessorySetting.jsp" method=post>
<input type=hidden id='method' name='method'>
<input type=hidden id='pathcategory' name='pathcategory' value="<%=pathcategory%>">
<input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>">
<INPUT type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>">
<INPUT type=hidden id='seccategory' name='seccategory' value="<%=seccategory%>">
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="15%">
  <COL width=85%>
  <TBODY>
	  <tr>
	  <td><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></td>
	    <td class=field>
	    <BUTTON type="button" class=Browser onClick="onShowCatalog(mypathspan)" name=selectCategory></BUTTON>
	    <span id=mypathspan>
	    	<%if(pathcategory.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle>
	    	<%}else{%><%=pathcategory%><%}%>
	    </span>
	    <INPUT type=hidden id='mypath' name='mypath' value="<%=pathcategory%>">
	    </td>
	  </tr>
    <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR> 
  </TBODY>
</TABLE>
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
<script language=javascript>  
function submitData(){
	if(check_form(weaver,"mypath")){
		document.all("method").value="save";
		weaver.submit();
	}
}
function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
          spanName.innerHTML=wuiUtil.getJsonValueByIndex(result,2);
          document.all("mypath").value=wuiUtil.getJsonValueByIndex(result,2);
          document.all("pathcategory").value=wuiUtil.getJsonValueByIndex(result,2);
          document.all("maincategory").value=wuiUtil.getJsonValueByIndex(result,3);
          document.all("subcategory").value=wuiUtil.getJsonValueByIndex(result,4);
          document.all("seccategory").value=wuiUtil.getJsonValueByIndex(result,1);
        }else{
          spanName.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
          document.all("mypath").value="";
          document.all("pathcategory").value="";
          document.all("maincategory").value="";
          document.all("subcategory").value="";
          document.all("seccategory").value="";
        }
    }
}
</script>
