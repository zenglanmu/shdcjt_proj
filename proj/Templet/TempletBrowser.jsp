<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
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


<FORM NAME=SearchForm STYLE="margin-bottom:0" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btnclose.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 id="btnclose" onclick="window.parent.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
</DIV>


<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%"> 
<TR class=DataHeader>
	<TH width="10%">ID</TH>
	<TH width="30%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
	<TH width="60%"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
</tr>
<TR class=Line><TH colSpan=3></TH></TR>
<tr>
	<td width="50" style="display:"><a HREF=#>0</a></td>
	<td><%=SystemEnv.getHtmlLabelName(17907,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(17910,user.getLanguage())%></td>
</tr>
<%
int i=0;
int projTypeID = Util.getIntValue(Util.null2String(request.getParameter("projTypeID")), -1);

int templetID = -1;
String templetName = "";
String templetDesc = "";
//modified by hubo,20060228,只可以选择正常状态的模板
String sql = "SELECT id,templetName,templetDesc FROM Prj_Template WHERE proTypeId="+projTypeID+" AND status='1'";
RecordSet.executeSql(sql);
while(RecordSet.next()) {
	templetID = RecordSet.getInt("id");
	templetName = Util.toScreen(RecordSet.getString("templetName"),user.getLanguage());
	templetDesc = Util.toScreen(RecordSet.getString("templetDesc"),user.getLanguage());
	if(i==0){
		i=1;
	%>
	<TR class=DataLight>
	<%	
	}else{
		i=0;
	%>
	<TR class=DataDark>
	<%}%>
	<TD width="50" style="display:"><A HREF=#><%=templetID%></A></TD>
	<TD><%=templetName%></TD>
	<TD ><%=templetDesc%></TD>
	</TR>
<%}%>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<script type="text/javascript">
<!--
$("#BrowseTable").bind("mouseover",function(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
});
$("#BrowseTable").bind("mouseout",function(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
});

$("#BrowseTable").bind("click",function(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
     window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
	 window.parent.parent.close();
	}
});
function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}
//-->
</script>

</BODY></HTML>