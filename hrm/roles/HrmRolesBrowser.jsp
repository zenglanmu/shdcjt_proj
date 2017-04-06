<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String rolesname = Util.null2String(request.getParameter("rolesname"));
String rolesmark = Util.null2String(request.getParameter("rolesmark"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!rolesname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where rolesname like '%" + Util.fromScreen2(rolesname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and rolesname like '%" + Util.fromScreen2(rolesname,user.getLanguage()) +"%' ";
}
if(!rolesmark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where rolesmark like '%" + Util.fromScreen2(rolesmark,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and rolesmark like '%" + Util.fromScreen2(rolesmark,user.getLanguage()) +"%' ";
}
String sqlstr = "select * from HrmRoles " + sqlwhere+" order by rolesmark" ;
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
<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="HrmRolesBrowser.jsp" method="post">
<DIV align=right style="display:none">
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	//把document.SearchForm().btnclear.click(); 改成btnclear_onclick() 就可以清空啦
	//2012-08-14 ypc 修改
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
</DIV>
<%
if(userightmenu_self==0){%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 id="btnclear" onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
<%}%>
<table width=100% class=ViewForm>
    <TR class=Spacing> 
      <TD class=line1 colspan=4></TD>
    </TR>
    <TR> 
      <TD width=15%><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TD>
      <TD width=35% class=field> 
        <input class=inputstyle name=rolesmark value="<%=rolesmark%>">
      </TD>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
      <TD width=35% class=field> 
        <input class=inputstyle name=rolesname value="<%=rolesname%>">
      </TD>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colspan=4></TD>
    </TR>
  </table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TH>      
	  <TH width=40%><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TH>      
	  <TH width=65%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
      </tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String rolesmarks = Util.toScreen(RecordSet.getString("rolesmark"),user.getLanguage());
	String rolesnames = Util.toScreen(RecordSet.getString("rolesname"),user.getLanguage());
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
	<TD><%=rolesmarks%></TD>
	<TD><%=rolesnames%></TD>
</TR>
<%}
%>

</TABLE>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
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
<SCRIPT LANGUAGE=VBS>


</SCRIPT>
<script	language="javascript">

function btnclears(){
	window.parent.parent.returnValue = "";
	window.parent.parent.close();
}

function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
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
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
		window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>
