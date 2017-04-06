<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(15108,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
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
		<td valign="top"><%
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
perpage=10;

String assetname=Util.fromScreen(request.getParameter("assetname"),user.getLanguage());
String assortmentid=Util.fromScreen(request.getParameter("assortmentid"),user.getLanguage());
String assortmentname = "" ;
int ishead = 0;
if(assortmentid.equals("0")){
	assortmentid="";
}
if(!assortmentid.equals(""))  assortmentname=Util.toScreen(LgcAssortmentComInfo.getAssortmentName(assortmentid),user.getLanguage());
String sqlwhere="";

if(!assortmentid.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere+=" where t1.assortmentid="+assortmentid;
        }
        else 
            sqlwhere+=" and t1.assortmentid="+assortmentid;
    }

if(!assetname.equals("")){
        if(ishead==0){
            ishead = 1;
            sqlwhere+=" where t2.assetname like '%"+assetname+"%'";
        }
        else 
            sqlwhere+=" and t2.assetname like '%"+assetname+"%'";
    }

if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}
String sqlstr = "";

//add by xwj for TD 1554 on 2005-03-25
session.setAttribute("sqlwhere",sqlwhere);
//out.println(sqlwhere);

String sqlexport ="select t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr from LgcAsset t1,LgcAssetCountry t2 "+sqlwhere+" and t1.id=t2.assetid order by t1.assortmentstr desc, t2.assetname desc"; 
//System.out.println("sqlexport:"+sqlexport);
session.setAttribute("psqlexport",sqlexport);

String temptable = "temptable"+ Util.getRandom() ;
if(RecordSet.getDBType().equals("oracle")){
		sqlstr = "create table "+temptable+"  as select * from (select t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr from LgcAsset t1,LgcAssetCountry t2 "+ sqlwhere +" and t1.id=t2.assetid order by t1.assortmentstr desc, t2.assetname desc) where rownum<"+ (pagenum*perpage+2);
		//System.out.println("sqlstr@@@@:"+sqlstr);
}else if(RecordSet.getDBType().equals("db2")){
       sqlstr = "create table "+temptable+"  as  (select t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr from LgcAsset t1,LgcAssetCountry t2 ) definition only";

       RecordSet.executeSql(sqlstr);
       
	   sqlstr = "insert into "+temptable+" (select   t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr from LgcAsset t1,LgcAssetCountry t2 "+ sqlwhere +" and t1.id=t2.assetid order by t1.assortmentstr desc, t2.assetname desc fetch first  "+(pagenum*perpage+1)+" rows only ) ";
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
<form name=weaver method="get" action="LgcSearchProduct.jsp">
  <input type="hidden" name="pagenum" value=''>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//add by xwj on 2005-03-25 for TD 1554
RCMenu += "{"+"Excel,javascript:ContractExport(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>

<table class=ViewForm>
  <tbody>
 <TR class=Title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
  </TR>
<tr style="height: 1px"><td class=Line1 colspan=5></td></tr>
  <tr>
	<td align=left width=10%><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
	<td width="28%" class=field>
              <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp" _displayText="<%=assortmentname%>" type=hidden name=assortmentid value=<%=assortmentid%>>
	</td>
	<td align=right><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<td class=field>
	  <INPUT class=InputStyle maxLength=50 size=30 name="assetname" value="<%=assetname%>">
	</td>
  </TR><tr style="height: 1px"><td class=Line colspan=5></td></tr>
</tbody>
</table>
<table class=ListStyle cellspacing=1 > 
  		<tr> <td valign="top">  
  			<%  
  			String  tableString  =  "";  
  			String  backfields  =  "t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr"; 
  			String  fromSql  = "from LgcAsset t1,LgcAssetCountry t2 ";  
  			String sqlmei = "and t1.id=t2.assetid"; 
			String linkstr = "";
			linkstr = "/lgc/asset/LgcAsset.jsp";
  			String orderby  =  "t2.assetid";     
  			if(!sqlwhere.equals("")){      
  				sqlwhere += sqlmei;
  			}  
  			tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+      
  									 "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"t2.assetid\" sqlsortway=\"desc\"  sqlisdistinct=\"true\"  />"+   
  									 "<head>";   
  			tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15129,user.getLanguage())+"\" href=\"/lgc/asset/LgcAsset.jsp\" linkkey=\"paraid\" linkvaluecolumn=\"assetid\"  column=\"assetname\" orderkey=\"assetname\"  />";            
  			tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(705,user.getLanguage())+"\" column=\"assetunitid\" orderkey=\"assetunitid\" transmethod =\"weaver.lgc.maintenance.AssetUnitComInfo.getAssetUnitname\" />"; 
			tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(726,user.getLanguage())+"\"  column=\"currencyid\" orderkey=\"currencyid\" transmethod =\"weaver.fna.maintenance.CurrencyComInfo.getCurrencyname1\" otherpara=\"column:salesprice\" />";           
			tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(178,user.getLanguage())+"\" column=\"assortmentid\" orderkey=\"assortmentid\" transmethod =\"weaver.lgc.maintenance.LgcAssortmentComInfo.getAssortmentFullName\"/>";         
			tableString+="</head>"; 
			tableString+="</table>";
        %> 
         
			<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
		</td>
	</tr>
</table>
</form>
<script language=vbs>
sub onShowAssortmentID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assortmentidspan.innerHtml = id(1)
	weaver.assortmentid.value=id(0)
	else 
	assortmentidspan.innerHtml = ""
	weaver.assortmentid.value=""
	end if
	end if
end sub
</script>

<!-- modified by xwj 2005-03-25 for TD 1554 -->
<iframe id="searchexport" style="display:none"></iframe>
<script language=javascript>
function ContractExport(){
     searchexport.src="LgcSearchProductExport.jsp";
}
</script>

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
</body>



</html>