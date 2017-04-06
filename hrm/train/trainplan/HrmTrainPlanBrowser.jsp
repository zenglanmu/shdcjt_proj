<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
int userid = user.getUID();

String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String planname = Util.null2String(request.getParameter("planname"));
String layoutid = Util.null2String(request.getParameter("layoutid"));
String planaim = Util.null2String(request.getParameter("planaim"));
String plancontent = Util.null2String(request.getParameter("plancontent"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!planname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where planname like '%";
		sqlwhere += Util.fromScreen2(planname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and planname like '%";
		sqlwhere += Util.fromScreen2(planname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!layoutid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutid =";
		sqlwhere += Util.fromScreen2(layoutid,user.getLanguage());
		sqlwhere += " ";
	}
	else{
		sqlwhere += " and layoutid =";
		sqlwhere += Util.fromScreen2(layoutid,user.getLanguage());
		sqlwhere += " ";
	}
}
if(!planaim.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where planaim like '%";
		sqlwhere += Util.fromScreen2(planaim,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and planaim like '%";
		sqlwhere += Util.fromScreen2(planaim,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!plancontent.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where plancontent like '%";
		sqlwhere += Util.fromScreen2(plancontent,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and plancontent like '%";
		sqlwhere += Util.fromScreen2(plancontent,user.getLanguage());
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmTrainPlanBrowser.jsp" method=post>
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
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=spacing style="height: 1px"><TD class=line1 colspan=6></TD></TR>
<TR>
<TD width=5%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=15% class=field><input class=inputstyle name=planname value="<%=planname%>"></TD>
<TD><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TD>
<TD class=Field>
   
   <INPUT  _displayText="<%=TrainLayoutComInfo.getLayoutname(layoutid)%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/train/trainlayout/TrainLayoutBrowser.jsp" class=wuiBrowser id=layoutid type=hidden name=layoutid value="<%=layoutid%>">           
</TD>
</tr>
<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR> 
<tr>
<TD width=10%><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TD>
<TD width=30% class=field><input class=inputstyle name=plancontent value="<%=plancontent%>"></TD>
<TD width=10%><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></TD>
<TD width=30% class=field><input class=inputstyle name=planaim value="<%=planaim%>"></TD>
</TR>
<TR class=spacing style="height: 1px"><TD class=line1 colspan=6></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=15%><%=SystemEnv.getHtmlLabelName(6101,user.getLanguage())%></TH>
<TH width=35%><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TH>
<TH width=35%><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></TH>
</tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmTrainPlan "+sqlwhere;
//out.println(sqlwhere);
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
  String id = RecordSet.getString("id");
  boolean canView = TrainPlanComInfo.isViewer(id,""+userid);  
  if(HrmUserVarify.checkUserRight("HrmTrainPlanEdit:Edit", user)){
   canView = true;
}
  if(!canView)continue;
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
	<TD><%=RecordSet.getString("planname")%></TD>
	<TD><%=TrainLayoutComInfo.getLayoutname(RecordSet.getString("layoutid"))%></TD>
	<TD><%=RecordSet.getString("plancontent")%></TD>
	<TD><%=RecordSet.getString("planaim")%></TD>	
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
	window.parent.returnValue = {id:"0",name:""};
	window.parent.close()
}
  
</script>
</BODY></HTML>