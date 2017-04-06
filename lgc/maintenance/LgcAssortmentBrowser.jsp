<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String assortmentname = Util.null2String(request.getParameter("assortmentname"));
String assortmentremark = Util.null2String(request.getParameter("assortmentremark"));
int supassortmentid = Util.getIntValue(request.getParameter("supassortmentid"),0);
String listname = Util.null2String(request.getParameter("listname"));
String fromlgc = Util.null2String(request.getParameter("fromlgc"));

String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!fromlgc.equals("1")){
	if(ishead==0){
		ishead=1;
		sqlwhere += " where supassortmentid=";
		sqlwhere += supassortmentid;
	}
	else{
		sqlwhere += " and supassortmentid=";
		sqlwhere += supassortmentid;
	}
}
else{
	if(ishead==0){
		ishead=1;
		sqlwhere += " where subassortmentcount = 0 ";
	}
	else{
		sqlwhere += " and subassortmentcount = 0 ";
	}
}
	
if(!assortmentname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where assortmentname like '%";
		sqlwhere += Util.fromScreen2(assortmentname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and assortmentname like '%";
		sqlwhere += Util.fromScreen2(assortmentname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!assortmentremark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where assortmentremark like '%";
		sqlwhere += Util.fromScreen2(assortmentremark,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and assortmentremark like '%";
		sqlwhere += Util.fromScreen2(assortmentremark,user.getLanguage());
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="LgcAssortmentBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<input type=hidden name=supassortmentid>
<input type=hidden name=listname value="<%=listname%>">
<input type=hidden name=fromlgc value="<%=fromlgc%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S onclick="onSearch()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<% if(!fromlgc.equals("1")&&!fromlgc.equals("2")) { %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15317,user.getLanguage())+",javascript:onUp(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=T onclick="onUp()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(15317,user.getLanguage())%></BUTTON>
<% } %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=Spacing style="height: 1px"><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle  name=assortmentname value="<%=assortmentname%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle  name=assortmentremark value="<%=assortmentremark%>"></TD>
</TR>
<TR style="height: 1px"><TD class=Line colSpan=4></TD></TR>

</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
<% if(!fromlgc.equals("1")&&!fromlgc.equals("2")) { %>
<TH width=33%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=47%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
<TH width=20%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></TH></tr><TR class=Line style="height: 1px"><TH colSpan=3></TH></TR>
<% }else{ %>
<TH width=40%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=60%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH></tr><TR class=Line style="height: 1px"><TH colSpan=2></TH></TR>
<%}%>
<%
int i=0;

sqlwhere = "select * from LgcAssetAssortment "+sqlwhere;

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
	<TD style="display:none" id=td1><A HREF=#><%=RecordSet.getString("id")%></A></TD>
	<TD id=td2><%=RecordSet.getString("assortmentname")%></TD>
	<TD id=td3><%=RecordSet.getString("assortmentremark")%></TD>
	<% if(!fromlgc.equals("1")&&!fromlgc.equals("2")) { %>
	<Td id=td4 onclick="onview('<%=RecordSet.getString("id")%>','<%=RecordSet.getString("assortmentname")%>');"><%=SystemEnv.getHtmlLabelName(6001,user.getLanguage())%></Td>
	<% } %>
</TR>
<%}%>
</TABLE></FORM>
        

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height: 10px">
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>    
    </BODY></HTML>
<script language=javascript>
function onview(objval1,objval2){
	SearchForm.listname.value=SearchForm.listname.value + objval2 + "->";
	SearchForm.supassortmentid.value=objval1;
	SearchForm.submit();
}

function onSearch(){
	SearchForm.supassortmentid.value=<%=supassortmentid%>;
	SearchForm.submit();
}

function onUp(){
	SearchForm.listname.value = "";
	<% if(supassortmentid==0){ %>
		SearchForm.supassortmentid.value=0;
	<% }else{ %>	
		SearchForm.supassortmentid.value=<%=LgcAssortmentComInfo.getSupAssortmentId(""+supassortmentid)%>;
	<% } %>
	SearchForm.submit();
}
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
	window.parent.returnValue = {id:"0",name:""};
	window.parent.close()
}
</script>