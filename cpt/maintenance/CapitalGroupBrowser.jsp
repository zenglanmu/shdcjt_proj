<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String fromcapital = Util.null2String(request.getParameter("fromcapital"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));
String sqlwhere = " ";
int ishead = 0;

if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where description like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and description like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}

if(fromcapital.equals("1")){
	if (ishead==0){
		ishead = 1;
		sqlwhere += " where id not in (select parentid from CptCapitalGroup) ";
	}
	else{
		sqlwhere += " and id not in (select parentid from CptCapitalGroup) ";
	}
}
else{
	if (ishead==0){
		ishead = 1;
		sqlwhere += " where parentid = 0 ";
	}
	else{
		sqlwhere += " and parentid = 0 ";
	}
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CapitalGroupBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<input type=hidden name=parentid>
<input type=hidden name=fromcapital value="<%=fromcapital%>">
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

			<table width=100% class=ViewForm>
			<TR>
			<TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
			<TD width=35% class=field><input name=name value="<%=name%>" class="InputStyle"></TD>
			<TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
			<TD width=35% class=field><input name=description value="<%=description%>" class="InputStyle"></TD>
			</TR>
			<TR style="height:1px;"><TD class=Line colspan=4></TD></TR>
			</table>
			<BR>
			<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" style="width:100%">
			<TR class=DataHeader>
			<TH style='display:none'></TH>
			<TH width=49%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
			<TH width=50%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
			</TR>
			<TR class=Line><TH colspan="3" ></TH></TR> 
			<%
			int i=0;
			sqlwhere = "select * from CptCapitalGroup "+sqlwhere;
			RecordSet.execute(sqlwhere);
			while(RecordSet.next()){
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
				<TD style='display:none'><A HREF=# ><%=RecordSet.getString("id")%></A></TD>
				<TD><%=RecordSet.getString("name")%></TD>
				<TD><%=RecordSet.getString("description")%></TD>
			</TR>
			<%}%>
			</TABLE>

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
<script	language="javascript">
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","£¬");
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
	window.parent.returnValue = {id:"",name:""};
	window.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
});
</script>
<script language="javascript">
function onClear()
{
	btnclear_onclick() ;
}
function onSubmit()
{
	SearchForm.submit();
}
function onClose()
{
	window.parent.close() ;
}
</script>