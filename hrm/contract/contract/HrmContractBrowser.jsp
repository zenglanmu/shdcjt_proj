<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.contract.ContractTypeComInfo" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
ContractTypeComInfo ctci = new ContractTypeComInfo();
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String type = Util.null2String(request.getParameter("type"));
String name = Util.null2String(request.getParameter("name"));
String contractman = Util.null2String(request.getParameter("man"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where contractname like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and contractname like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!contractman.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where contractman in (select id from HrmResource where lastname like '%"+Util.fromScreen2(contractman,user.getLanguage())+"%') ";		
	}
	else{
		sqlwhere += " and contractman in (select id from HrmResource where lastname like '%"+Util.fromScreen2(contractman,user.getLanguage())+"%') ";		
	}
}
if(!type.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where contracttypeid in(select id from HrmContractType where typename like '%"+Util.fromScreen2(type,user.getLanguage())+"%') ";
	}
	else{
		sqlwhere += " and contracttypeid in(select id from HrmContractType where typename like '%"+Util.fromScreen2(type,user.getLanguage())+"%') ";
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
</colgroup>
<tr>
<td height="0" colspan="3" style="height:1px;"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM NAME=SearchForm STYLE="margin-bottom:0;height:1px;" action="HrmContractBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnseach_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:btnset_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=Viewform>          
<TR class=Spacing style="height:2px"><TD class=Line1 colspan=6>
    </TD>
</TR>
<TR>
    <TD class=field><%=SystemEnv.getHtmlLabelName(15775,user.getLanguage())%></TD>
    <TD class=field>
      <input class=inputstyle size=10 name=type value="<%=type%>">
    </TD>
    <TD class=field><%=SystemEnv.getHtmlLabelName(15142,user.getLanguage())%></TD>
    <TD class=field>
      <input class=inputstyle size=20 name=name value="<%=name%>">
    </TD>
    <TD class=field><%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%></TD>
    <TD class=field>
      <input class=inputstyle size=10 name=man value="<%=contractman%>">
    </TD>
</TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15142,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15780,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%></TH>
</tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmContract "+sqlwhere;
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
	<TD style="display:none"><A HREF=#><%=rs.getString("id")%></A></TD>
	<TD><%=rs.getString("contractname")%></TD>
	<TD><A HREF=#><%=ctci.getContractTypename(rs.getString("contracttypeid"))%></A></TD>
	<TD><%=ResourceComInfo.getResourcename(rs.getString("contractman"))%></TD>	
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
<td height="0" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
 </BODY></HTML>

<SCRIPT LANGUAGE="JavaScript">
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.parent.returnValue = {"id":jQuery(this).find("td:first").text(),"name":jQuery(this).find("td:nth-child(2)").text()};
			window.parent.parent.close();
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			jQuery(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			jQuery(this).removeClass("Selected")
		})

})

function btnclear_onclick(){
     window.parent.parent.returnValue = {"id":"","name":""};
     window.parent.parent.close();
}

function btncancel_onclick(){
     window.parent.parent.close();
}

function btnseach_onclick(){
     document.forms[0].submit();
}

function btnset_onclick(){
     document.forms[0].reset();
}

</SCRIPT>
