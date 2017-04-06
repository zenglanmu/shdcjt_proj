<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String bankname=Util.null2String(request.getParameter("bankname"));
String bankdesc=Util.null2String(request.getParameter("bankdesc"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!bankname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where bankname like '%" + Util.fromScreen2(bankname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and bankname like '%" + Util.fromScreen2(bankname,user.getLanguage()) +"%' ";
}
if(!bankdesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where bankdesc like '%" + Util.fromScreen2(bankdesc,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and bankdesc like '%" + Util.fromScreen2(bankdesc,user.getLanguage()) +"%' ";
}

String sqlstr = "select * from HrmBank" + sqlwhere ;
%>
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
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="BankBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:doReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset onclick="doReset()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=Viewform style="height:1px;">
<TR class=Spacing style="height:1px;"><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=20%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=30% class=field><input name=bankname value="<%=bankname%>"></TD>
<TD width=20%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD width=30% class=field><input name=bankdesc value="<%=bankdesc%>"></TD>
</TR>
<TR class=separator style="height:1px;"><TD class=Sep1 colspan=4 style="padding:0;"></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width: 100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
      <TH width=30%><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
      <TH width=70%><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String banknames = Util.toScreen(RecordSet.getString("bankname"),user.getLanguage());
	String bankdescs = Util.toScreen(RecordSet.getString("bankdesc"),user.getLanguage());
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD style="display:none"><A HREF=#><%=ids%></A></TD>
	<TD><%=banknames%></TD>
	<td><%=bankdescs%></td>
</TR>
<%}
%>

</TABLE>
  <input type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
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
</BODY>
</HTML>
<script>
  function doSearch(){
    jQuery("#SearchForm").submit();
  }
  
function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
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
}

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;
   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	var curTr=jQuery(target).parents("tr")[0];
     window.parent.parent.returnValue = {
    		 id:jQuery(curTr.cells[0]).text(),
    		 name:jQuery(curTr.cells[1]).text()
     }		 
    
      window.parent.parent.close();
	}
}
 
function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}  

function doReset(){
     jQuery("#SearchForm")[0].reset();
}

jQuery(function(){
	jQuery("#BrowseTable").mouseover(BrowseTable_onmouseover);
	jQuery("#BrowseTable").mouseout(BrowseTable_onmouseout);
	jQuery("#BrowseTable").click(BrowseTable_onclick);
	
	jQuery("#btnclear").click(btnclear_onclick);
	
});  
</script>
