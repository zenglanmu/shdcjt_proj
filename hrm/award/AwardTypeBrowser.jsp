<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String awardtype = Util.null2String(request.getParameter("awardtype"));

String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));

String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}


if(!awardtype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where awardtype = '" + awardtype + "' ";
	}
	else{
		sqlwhere += " and awardtype = '" + awardtype + "' ";
	}
}
	
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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="AwardTypeBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>

<TR>
<TD><%=SystemEnv.getHtmlLabelName(808,user.getLanguage())%></TD>
<TD class=field colspan=5>
   <select name=awardtype size=1 class=inputstyle  onChange="SearchForm.submit()">
     <option value="">&nbsp;</option>
     <option value="0" <%if(awardtype.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%></option>
     <option value="1" <%if(awardtype.equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%></option>
   </select>
</TD>
</TR>

<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR> 
<tr>
<TD ><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD  class=field colspan=2><input class=Inputstyle name=name value="<%=name%>"></TD>
<TD ><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD  class=field colspan=2><input class=Inputstyle  name=description value="<%=description%>"></TD>
</TR>
<TR class="Spacing" style="height: 1px"><TD class="Line1" colspan=6></TD></TR>

</table>
 
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=0% style="display:none"></TH>
<TH width=20%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=20%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
<TH width=60%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
</tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmAwardType  " + sqlwhere;
rs.execute(sqlwhere);

while(rs.next()){
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
	<TD width=0% style="display:none"><A HREF=#><%=rs.getString("id")%></A></TD>
	<TD><%=Util.toScreen(rs.getString("name"),user.getLanguage())%></TD>
    <td>
        <% if(rs.getString("awardtype").equals("0")){ %><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%>
        <% } else {%><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%><% } %>
    </td>   
    <TD><%=Util.toScreen(rs.getString("description"),user.getLanguage())%></TD>
</TR>
<%}%>
</TABLE></FORM>
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

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}
  
</script>
</BODY>
</HTML>
