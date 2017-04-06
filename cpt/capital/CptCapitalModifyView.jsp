<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="DepreMethodComInfo" class="weaver.cpt.maintenance.DepreMethodComInfo" scope="page"/>
<jsp:useBean id="CapitalModifyFieldComInfo" class="weaver.cpt.capital.CapitalModifyFieldComInfo" scope="page"/>

<%
String CurrentUser = ""+user.getUID();

String logintype = ""+user.getLogintype();
String ProcPara = "";
char flag = 2;
ProcPara = CurrentUser;
ProcPara += flag+logintype;

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
if(perpage<=1 )	perpage=10;

//添加判断权限的内容--new
//String TableName = "";
String temptable = "cptmodifytemptable"+ Util.getRandom() ;
String Cpt_SearchSql = "";
String capitalid = ""+Util.getIntValue(request.getParameter("capitalid"),0);

int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0);
//add by dongping for TD1202
//desc : 该记录页面的统计的记录数目始终是【0】
rs.executeSql("select count(id) as coutnid from CptCapitalModify where cptid = "+ capitalid);
if (rs.next()){
	TotalCount = Util.getIntValue(rs.getString("coutnid"),0);
}

if(RecordSet.getDBType().equals("oracle")){
	Cpt_SearchSql = "create table "+temptable+"  as select * from (select * from CptCapitalModify where cptid = "+ capitalid+" order by id desc ) where rownum<"+ (pagenum*perpage+2);
}else{
	Cpt_SearchSql = "select top "+(pagenum*perpage+1)+" * into "+temptable+" from CptCapitalModify where cptid =  "+ capitalid +" order by id desc";	
}

//out.println(Cpt_SearchSql);

RecordSet.executeSql(Cpt_SearchSql);

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

String strData="";
String strURL="";


%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String titlename = "";
if(CptSearchComInfo.getIsData().equals("1")){
	titlename = SystemEnv.getHtmlLabelName(1509,user.getLanguage());
}else{
	titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage());
}

String imagefilename = "/images/hdHRMCard.gif";
titlename = SystemEnv.getHtmlLabelName(6055,user.getLanguage()) + "-" + CapitalComInfo.getCapitalname(capitalid);
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(pagenum>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",CptCapitalModifyView.jsp?capitalid="+capitalid+"&pagenum="+(pagenum-1)+"&TotalCount="+TotalCount+"&type=search,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(hasNextPage){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",CptCapitalModifyView.jsp?capitalid="+capitalid+"&pagenum="+(pagenum+1)+"&TotalCount="+TotalCount+"&type=search,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(886,user.getLanguage())+",/cpt/capital/CptCapitalUse.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(883,user.getLanguage())+",/cpt/capital/CptCapitalMove.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6051,user.getLanguage())+",/cpt/capital/CptCapitalLend.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6054,user.getLanguage())+",/cpt/capital/CptCapitalLoss.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6052,user.getLanguage())+",/cpt/capital/CptCapitalDiscard.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6053,user.getLanguage())+",/cpt/capital/CptCapitalMend.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6055,user.getLanguage())+",/cpt/capital/CptCapitalModifyOperation.jsp?isdata=2,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15305,user.getLanguage())+",/cpt/capital/CptCapitalBack.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15306,user.getLanguage())+",/cpt/capital/CptCapitalInstock1.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15307,user.getLanguage())+",/cpt/search/CptInstockSearch.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

			<br><b>
			<%=SystemEnv.getHtmlLabelName(2111,user.getLanguage())%>：<%=TotalCount%> <%=SystemEnv.getHtmlLabelName(2110,user.getLanguage())%>：<%=pagenum%>
			</b><br><br>
			<TABLE class=ListStyle cellspacing="1">
			  <COLGROUP>
			  <COL width="20%">
			  <COL width="20%">
			  <COL width="20%">
			  <COL width="20%">
			  <COL width="20%">
			  <TBODY>
			  <TR class=Header>
				<TD><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(6056,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(1450,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></TD>   
				<TD><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></TD>   
			  </TR>
			  <TR class=Line><TD colspan="5" ></TD></TR> 
			<%
				 
				int needchange = 0;
			int totalline=1;
			if(RecordSet.last()){
				do{
				   try{
					String tempid = RecordSet.getString("id");
					String tempfield = RecordSet.getString("field");
					String tempoldvalue = RecordSet.getString("oldvalue");
					String tempcurrentvalue = RecordSet.getString("currentvalue");
					String tempresourceid = RecordSet.getString("resourceid");
					String tempdmodifydate = RecordSet.getString("modifydate");
					if(needchange ==0){
						needchange = 1;
			%>
			  <TR class=datalight>
			  <%
				}else{
					needchange=0;
			  %><TR class=datadark>
			  <%  	}%>
				<TD><%=CapitalModifyFieldComInfo.getCapitalModifyFieldname(tempfield)%></TD> 
				<TD><%=Util.toScreen(tempoldvalue,user.getLanguage())%></TD>    <TD><%=Util.toScreen(tempcurrentvalue,user.getLanguage())%></TD>
				<TD><a href="/hrm/resource/HrmResource.jsp?id=<%=tempresourceid%>">
				  <%=Util.toScreen(ResourceComInfo.getResourcename(tempresourceid),user.getLanguage())%></a></TD>
				<TD><%=Util.toScreen(tempdmodifydate,user.getLanguage())%></TD>
			  </TR>
			<%
				if(hasNextPage){
					totalline+=1;
					if(totalline>perpage)	break;
				 }
				  }catch(Exception e){
					System.out.println(e.toString());
				  }
			}while(RecordSet.previous());
			}
			RecordSet.executeSql("drop table "+temptable);
			%>  
			</TBODY>
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

<script language="javascript">
 function back()
{
	window.history.back(-1);
}
</script>
</body>
</html>
