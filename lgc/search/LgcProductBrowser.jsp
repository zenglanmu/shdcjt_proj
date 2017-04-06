<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
perpage=50;

String assetname=Util.fromScreen(request.getParameter("assetname"),user.getLanguage());
String assortmentid=Util.fromScreen(request.getParameter("assortmentid"),user.getLanguage());
String assortmentname = "" ;
if(assortmentid.equals("0")){
	assortmentid="";
}
if(!assortmentid.equals(""))  assortmentname=Util.toScreen(LgcAssortmentComInfo.getAssortmentName(assortmentid),user.getLanguage());
String sqlwhere="";

if(!assetname.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t2.assetname like '%"+assetname+"%'";
	else 	sqlwhere+=" and t2.assetname like '%"+assetname+"%'";
}
if(!assortmentid.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.assortmentstr like '%|"+assortmentid+"|%'";
	else 	sqlwhere+=" and t1.assortmentstr like '%|"+assortmentid+"|%'";
}
if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}
String sqlstr = "";

String temptable = "temptable"+ Util.getRandom() ;
if(RecordSet.getDBType().equals("oracle")){
		sqlstr = "create table "+temptable+"  as select * from (select t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr from LgcAsset t1,LgcAssetCountry t2 "+ sqlwhere +" and t1.id=t2.assetid order by t1.assortmentstr desc, t2.assetname desc) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
        sqlstr = "create table "+temptable+"  as (select t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr from LgcAsset t1,LgcAssetCountry t2 ) definition only ";
 
        RecordSet.executeSql(sqlstr);

        sqlstr = "insert into "+temptable+" (select  t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr from LgcAsset t1,LgcAssetCountry t2 "+ sqlwhere +" and t1.id=t2.assetid order by t1.assortmentstr desc, t2.assetname desc fetch first "+(pagenum*perpage+1)+" rows only )";
}else{
		sqlstr = "select top "+(pagenum*perpage+1)+"  t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr   into "+temptable+" from LgcAsset t1,LgcAssetCountry t2 "+ sqlwhere +" and t1.id=t2.assetid order by t1.assortmentstr desc, t2.assetname desc";
}

RecordSet.executeSql(sqlstr);
RecordSet.executeSql("Select count(*) RecordSetCounts from "+temptable);
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
	sqltemp="select * from (select * from  "+temptable+" order by assortmentstr,assetname) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select * from "+temptable+"  order by assortmentstr,assetname fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only  ";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by assortmentstr,assetname  ";
}

RecordSet.executeSql(sqltemp);
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
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="LgcProductBrowser.jsp" method=post>
  <input type="hidden" name="pagenum" value=''>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
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
<table class=ViewForm>
  <tbody>
<TR style="height: 1px"><TD class=Line1 colSpan=5></TD></TR>
  <tr>
	<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
	<td class=field>
              <INPUT class=wuiBrowser  _displayText="<%=assortmentname%>" _url="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp" type=hidden name=assortmentid value=<%=assortmentid%>>
	</td>
	<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<td class=field>
	  <INPUT class=InputStyle maxLength=50 size=30 name="assetname" value="<%=assetname%>">
	</td>
	<td class=field>
	</td>
  </tr>
  <TR style="height: 1px"><TD class=Line colSpan=5></TD></TR>
</tbody>
</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
<TH width=0% style="display:none"></TH>      
  <TH><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></TH>
<TH width=0% style="display:none"></TH> 
  <TH><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></TH>
<TH width=0% style="display:none"></TH> 
  <TH><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH></tr><TR class=Line><TH colSpan=5></TH></TR>
<%

int i=0;
int totalline=1;
if(RecordSet.last()){
	do{
	String ids = RecordSet.getString("assetid");
	String assetname0 = Util.toScreen(RecordSet.getString("assetname"),user.getLanguage());
	String assetunitid = Util.toScreen(RecordSet.getString("assetunitid"),user.getLanguage());
	String assetunitname = Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage());
	String currencyid = RecordSet.getString("currencyid");
	String currencyname = Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage());
	String salesprice = RecordSet.getString("salesprice");
	String assortmentid0 = Util.toScreen(RecordSet.getString("assortmentid"),user.getLanguage());
	String assortmentfullname =Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(assortmentid0),user.getLanguage());
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
	<TD><%=assetname0%></TD>
	<TD style="display:none"><A HREF=#><%=assetunitid%></A></TD>
	<TD><%=assetunitname%></TD>
	<TD style="display:none"><A HREF=#><%=currencyid%></A></TD>
	<TD><%=currencyname%></TD>
	<TD><%=Util.getPointValue(salesprice)%></TD>
	<TD><%=assortmentfullname%></TD>
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
<tr style="display:none">
   <td>&nbsp;</td>
   <td>
	   <%if(pagenum>1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
			<button type=submit class=btn accessKey=P id=prepage  onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>
	   <%if(hasNextPage){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
			<button type=submit class=btn accessKey=N  id=nextpage  onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>&nbsp;</td>
</tr>
</table>
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
<script type="text/javascript">

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:eq(1)").text(),other1:$(this).find("td:eq(2)").text(),other2:$(this).find("td:eq(3)").text(),other3:$(this).find("td:eq(4)").text(),other4:$(this).find("td:eq(5)").text(),other5:$(this).find("td:eq(6)").text(),other6:$(this).find("td:eq(7)").text()};
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
	window.parent.returnValue = {id:"",name:"",other1:"",other2:"",other3:"",other4:"",other5:"",other6:""};
	window.parent.close()
}

</script>
</BODY></HTML>