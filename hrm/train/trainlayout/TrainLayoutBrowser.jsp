<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String layoutname = Util.null2String(request.getParameter("layoutname"));
String layoutaim = Util.null2String(request.getParameter("layoutaim"));
String layoutcontent = Util.null2String(request.getParameter("layoutcontent"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!layoutname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutname like '%";
		sqlwhere += Util.fromScreen2(layoutname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and layoutname like '%";
		sqlwhere += Util.fromScreen2(layoutname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!layoutaim.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutaim like '%";
		sqlwhere += Util.fromScreen2(layoutaim,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and layoutaim like '%";
		sqlwhere += Util.fromScreen2(layoutaim,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!layoutcontent.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutcontent like '%";
		sqlwhere += Util.fromScreen2(layoutcontent,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and layoutcontent like '%";
		sqlwhere += Util.fromScreen2(layoutcontent,user.getLanguage());
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
<tr  style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="TrainLayoutBrowser.jsp" method=post>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=spacing style="height:1px;"><TD class=line1 colspan=6 style="padding:0"></TD></TR>
<TR>
<TD width=5%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=15% class=field><input class=inputstyle name=layoutname value="<%=layoutname%>"></TD>
<TD width=10%><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TD>
<TD width=30% class=field><input class=inputstyle name=layoutcontent value="<%=layoutcontent%>"></TD>
<TD width=10%><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></TD>
<TD width=30% class=field><input class=inputstyle name=layoutaim value="<%=layoutaim%>"></TD>
</TR>
<TR class=spacing><TD class=line1 colspan=6></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=20%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=40%><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TH>
<TH width=40%><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></TH>
</tr><TR class=Line style="height:1px;"><TH colspan="4" style="padding:0;"></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmTrainLayout "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
  String id = RecordSet.getString("id");
  if(!TrainLayoutComInfo.canAddPlan(id,user.getUID()))continue;
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
	<TD style="display:none"><%=id%></TD>
	<TD><%=RecordSet.getString("layoutname")%></TD>
	<TD><%=RecordSet.getString("layoutcontent")%></TD>
	<TD><%=RecordSet.getString("layoutaim")%></TD>	
</TR>
<%}%>
</TABLE></FORM>
 </td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>
<SCRIPT LANGUAGE="JavaScript">
function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:""};
     window.parent.parent.close();
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.parent.returnValue = {id:jQuery(this).find("td:first").text(),name:jQuery(this).find("td:first").next().text()};
			window.parent.parent.close();
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			jQuery(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			jQuery(this).removeClass("Selected")
		})

})
</SCRIPT>