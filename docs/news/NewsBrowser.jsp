<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML>


<HEAD>
<LINK REL=stylesheet type="text/css" HREF="/css/Weaver.css">

</HEAD>
<%
String name = Util.null2String(request.getParameter("name"));
String publishtype =  Util.null2String(request.getParameter("publishtype"));
String sqlwhere = "";
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where frontpagename like '%" +name+"%' ";
	}
	else 
		sqlwhere += " and frontpagename like '%" +name +"%' ";
}

String sqlstr = "";
if(ishead==0){
		ishead = 1;
		sqlwhere += " where id != 0 " ;
}
if(!sqlwhere.equals(""))
{
	if(!publishtype.equals(""))
	{
		ishead = 1;
		sqlwhere += "  and publishtype="+publishtype+" " ;
	}
}
else
{
	if(!publishtype.equals(""))
	{
		ishead = 1;
		sqlwhere += "  where publishtype="+publishtype+" " ;
	}
}
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int perpage=Util.getIntValue(request.getParameter("perpage"),0);
int	perpage=30;
//添加判断权限的内容--new


String temptable = "newstemptable"+ Util.getRandom() ;
String news_SearchSql = "";
//System.out.println("sqlwhere:"+sqlwhere);
if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
		news_SearchSql = "create table "+temptable+"  as select * from (select id, frontpagename, frontpagedesc from DocFrontpage "+ sqlwhere +" order by id desc) where rownum<"+ (pagenum*perpage+2);
	}
}else{
	if(user.getLogintype().equals("1")){
		news_SearchSql = "select top "+(pagenum*perpage+1)+" id, frontpagename, frontpagedesc into "+temptable+" from DocFrontpage  "+ sqlwhere +" order by id desc";  
	}
}


//添加判断权限的内容--new*/
RecordSet.executeSql(news_SearchSql);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id";
}
RecordSet.executeSql(sqltemp);

%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<BODY>






<FORM NAME="SearchForm" action="NewsBrowser.jsp" method=post>
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="publishtype" value='<%=publishtype%>'>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
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
		<TABLE class=Shadow  border="0" height="100%" width="100%"> 
		<tr>
		<td valign="top">
				<table width=100% class=ViewForm>
					
					<TR>
					<TD width=15%><%=SystemEnv.getHtmlLabelName(24256,user.getLanguage())%></TD>
					<TD width=35% class=field><input name=name value="<%=name%>" class="inputstyle"></TD>
					<TD width=15%></TD>
					<TD width=35%></TD>
					</TR>
					<TR class=Spacing style="height:1px;"><TD class=Line1 colspan=4></TD></TR>
					<TR class=separator style="height:1px;"><TD class=Sep1 colspan=4></TD></TR>
					</table>
					<TABLE ID=BrowseTable class=BroswerStyle cellspacing="0"  cellpadding="0" width="100%" >
					<TR class=DataHeader>
					<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
					<TH> <%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
					<TH> <%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
					</TR>
					<TR class=Line style="height:1px;"><TH colSpan=3 style="padding:0;"> </TH></TR>
					<%

					int i=0;
					int totalline=1;
					if(RecordSet.last()){
						do{
						String ids = RecordSet.getString("id");
						String names = Util.toScreen(RecordSet.getString("frontpagename"),user.getLanguage());
						String descs = Util.toScreen(RecordSet.getString("frontpagedesc"),user.getLanguage());
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
						<td style="padding-left: 5px"> <%=names%> </TD>
						<TD> <%=descs%> </TD>
					</TR>
					<%
						if(hasNextPage){
							totalline+=1;
							if(totalline>perpage)	break;
						}
					}while(RecordSet.previous());
					}
					RecordSet.executeSql("drop table "+temptable);
					%>
					</TABLE>

					<table align=right>
					<tr>
					   <td>&nbsp;</td>
					   <td>
						   <%if(pagenum>1){%>
								<button type=submit class=btn accessKey=P onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
						   <%}%>
					   </td>
					   <td>
						   <%if(hasNextPage){%>
								<button type=submit class=btn accessKey=N onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
						   <%}%>
					   </td>
					   <td>&nbsp;</td>
					</tr>
					</table>

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

<<script type="text/javascript">
<!--

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
         p.className = "DataDark";
      }else{
         p.className = "DataLight";
      }
   }
}
function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if( "TD"==target.nodeName||"A"==target.nodeName){   	
	  window.parent.returnValue = {id:$($(target).parents("tr")[0].cells[0]).text(),name:$($(target).parents("tr")[0].cells[1]).text()};
	   window.parent.close();
	}
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})

function btnclear_onclick(){
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}
//-->
</script>


