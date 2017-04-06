<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String lastname = Util.null2String(request.getParameter("lastname"));
String description = Util.null2String(request.getParameter("description"));

String languageid = ""+user.getLanguage();
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!lastname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where id<>1 and creator="+user.getUID()+" and lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and id<>1 and creator="+user.getUID()+" and lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where id<>1 and creator="+user.getUID()+" and description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and id<>1 and creator="+user.getUID()+" and description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
}

if(sqlwhere.equals("")) sqlwhere=" where id<>1 and creator="+user.getUID();
String sqlstr = "select id,lastname,description from hrmresourcemanager " +sqlwhere;

sqlstr += " order by id " ;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="sysadminBrowser.jsp" method=post>
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

			  <table width=100% class=viewform>
				<TR> 
				  <TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
				  <TD width=35% class=field>
					<input name=lastname value="<%=lastname%>" class="InputStyle">
				  </TD>
				  <TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
				  <TD width=35% class=field> 
					<input name=description value="<%=description%>" class="InputStyle">
				  </TD>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 

			  </table>
			  <BR>
			<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 STYLE="margin-top:0;width:100%">
			<TR class=DataHeader>
				  <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
				  <TH width=40%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
				  <TH width=65%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
				  </TR>
			<TR class=Line><TH colspan="4" ></TH></TR> 

			<%
			int i=0;
			RecordSet.executeSql(sqlstr);
			while(RecordSet.next()){
				String ids = RecordSet.getString("id");
				lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
				description = Util.toScreen(RecordSet.getString("description"),user.getLanguage());
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
				<TD><%=lastname%></TD>
				<TD><%=description%></TD>
			</TR>
			<%}
			%>

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

<input type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
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