<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%

String fullname = Util.null2String(request.getParameter("fullname"));
String sqlwhere = "";

if(!fullname.equals("")){
		sqlwhere += " and subject like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
}

//String sql = "select * from Voting where status in (1,2) "+sqlwhere +" order by id asc";

String sqlstr = "" ;
String temptable = "wftemptable"+ Util.getRandom() ;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=50;

if(RecordSet.getDBType().equals("oracle")){
		sqlstr = " (select * from Voting where status in (1,2) "+sqlwhere +" and rownum<"+ (pagenum*perpage+2) + " ) s";
}else{
		sqlstr = " (select top "+(pagenum*perpage+1)+" * from Voting where status in (1,2) "+sqlwhere +" ) as s" ;
}


RecordSet.executeSql("Select count(id) RecordSetCounts from "+sqlstr);

System.out.println("Select count(id) RecordSetCounts from "+sqlstr);
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
	sqltemp="select * from (select * from  "+sqlstr+" order by createdate , createtime ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+sqlstr+"  order by createdate desc, createtime desc";
}
RecordSet.executeSql(sqltemp);
System.out.println(sqltemp);

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="VotingInfoBrowser.jsp" method=post>
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

  <table width=100% class="viewform">
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(24096,user.getLanguage())%></TD>
      <TD width=85% class=field>
        <input name=fullname class=Inputstyle value="<%=fullname%>">
      </TD>
    </TR><TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
        
    <TR class="Spacing">
      <TD class="Line1" colspan=4></TD>
    </TR>

  </table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" style="width:100%;">
<TR class=DataHeader>
      <TH width=0% style="display:none"></TH>
	  <TH width=40%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
	  <TH width=60%><%=SystemEnv.getHtmlLabelName(24096,user.getLanguage())%></TH>
	  </TR>
	  <TR class=Line style="height:1px;"><Th colspan="4" ></Th></TR>
<%
int i=0;
int totalline=1;
if(RecordSet.last()){
	do{
		String requestids = RecordSet.getString("id");
		String creatername = RecordSet.getString("subject");

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
		<TD><%=requestids%></TD>
		<TD><%=creatername%>
		</TD>
	</TR>
	<%
		if(hasNextPage){
			totalline+=1;
			if(totalline>perpage)	break;
		}
	}while(RecordSet.previous());
}
%>

</TABLE>
	   <%if(pagenum>1){%>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",VotingInfoBrowser.jsp?pagenum="+(pagenum-1)+",_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			%> <%}%>
				   <%if(hasNextPage){%>
					<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",VotingInfoBrowser.jsp?pagenum="+(pagenum+1)+",_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			%> <%}%>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

</BODY></HTML>

<script type="text/javascript">


function submitData(){
	if (check_form(SearchForm,''))
		SearchForm.submit();
}

function submitClear(){
	window.parent.returnValue = {id:"",name:""};
	window.parent.close();
}

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
	         p.className = "DataDark";
	      }else{
	         p.className = "DataLight";
	      }
	   }
});
$("#BrowseTable").bind("click",function(e){
	var target =  e.srcElement||e.target ;
	try{
		if(target.nodeName == "TD" || target.nodeName == "A"){
			var curRow=$(target).parents("tr")[0];
			window.parent.parent.returnValue = {id:$(curRow.cells[0]).text(),name:$(curRow.cells[1]).text()};
			window.parent.parent.close();
		}
	}catch (en) {
		alert(en.message);
	}
});
</script>
