<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page"/>
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<jsp:useBean id="GraphFile2" class="weaver.file.GraphFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String rightStr = "";
if(HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)){
	rightStr="HrmContractTypeAdd:Add";
}
if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
	rightStr="HrmContractAdd:Add";
}
session.setAttribute("HrmRpContract_left_"+user.getUID(),"HrmRpContractType.jsp");
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}
String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
String from = Util.null2String(request.getParameter("from"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
//System.out.println("--------:"+subcompanyid1);
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15942,user.getLanguage());
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String fromTodate=Util.fromScreen(request.getParameter("fromTodate"),user.getLanguage());
String endTodate=Util.fromScreen(request.getParameter("endTodate"),user.getLanguage());

String depid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());


String sqlwhere = "";

if(!fromdate.equals("")){
	sqlwhere+=" and t1.contractstartdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.contractstartdate<='"+enddate+"' or t1.contractstartdate is null)";
}
if(!fromTodate.equals("")){
	sqlwhere+=" and t1.contractenddate>='"+fromTodate+"'";
}
if(!endTodate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (t1.contractenddate<='"+endTodate+"' and t1.contractenddate is not null)";
  }else{
    sqlwhere+=" and (t1.contractenddate<='"+endTodate+"' and t1.contractenddate is not null and t1.contractenddate <> '')";
  }
}
if(!depid.equals("")){
	sqlwhere+=" and t1.contractman= t2.id and t2.departmentid = "+depid+"";
}
if(detachable==1){
	if(!subcompanyid1.equals("")){
		sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}
	if(from.equals("type")){
	    subcompanyid1 = String.valueOf(user.getUserSubCompany1()); 
		sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}
}
String sql = "select count(t1.id) from HrmContract t1,HrmResource t2 where (t2.accounttype is null or t2.accounttype=0) and t1.contractman = t2.id "+sqlwhere;
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);

String sqlstr = "select t3.id resultid, count(t1.id) resultcount from HrmContract t1,HrmResource t2,HrmContractType t3 where (t2.accounttype is null or t2.accounttype=0) and t1.contractman = t2.id and  t1.contracttypeid = t3.id "+sqlwhere+" group by t3.id";
//System.out.println(sqlstr);
rs.executeSql(sqlstr);
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/contract/HrmRpContract.jsp?isFirst=type&subcompanyid1="+subcompanyid1+",_self} " ;
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
<form name=frmmain method=post action="HrmRpContractType.jsp">
<input type="hidden" name="from" value ="<%=from%>" >
<table class=ViewForm>
<colgroup>
<col width="15%">
<col width="25%">
<col width="15%">
<col width="25%">
<col width="5%">
<col width="15%">
<tbody>
<TR class= Spacing>
  <TD colspan=8 class=sep2></TD>
</TR>
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(1936,user.getLanguage())%></td>
    <td class=field>
    <BUTTON  type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    гн<BUTTON  type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
     <td width=10%><%=SystemEnv.getHtmlLabelName(15944,user.getLanguage())%></td>
    <td class=field>
    <BUTTON  type="button" class=calendar id=SelectDate onclick=getfromToDate()></BUTTON>&nbsp;
    <SPAN id=fromTodatespan ><%=Util.toScreen(fromTodate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromTodate" value=<%=fromTodate%>>
    гн<BUTTON  type="button" class=calendar id=SelectDate onclick=getendToDate()></BUTTON>&nbsp;
    <SPAN id=endTodatespan ><%=Util.toScreen(endTodate,user.getLanguage())%></SPAN>
    <input type="hidden" name="endTodate" value=<%=endTodate%>>  
    </td>     
    <TD><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></TD>
    <TD class=Field>   
      <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr=<%=rightStr%>"
       _displayText="<%=DepartmentComInfo.getDepartmentname(depid)%>" name="departmentid" id="departmentid" value="<%=depid%>"
      >      
    </TD>    
</tr>
<TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>
<table class=ListStyle cellspacing=1 >
<colgroup>
<col width="5%">
<tbody>
  <TR class=Header >
    <TH colspan=5><%=SystemEnv.getHtmlLabelName(15945,user.getLanguage())%>: <%=total%></TH>
  </TR>
    <tr class=header>
    <td></td>
    <td><%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15946,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(336,user.getLanguage())%></td>    
  </tr>
  <TR class=Line style="height: 1px;"><TD colspan="5" ></TD></TR> 
  <%
   rs.first();
   
   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable ( SystemEnv.getHtmlLabelName(15942,user.getLanguage()) );
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
   
   int totalnum = 0;
   if(total!=0){
     do{
	String resultid = rs.getString(1);
	int resultcount = rs.getInt(2);
	if(resultcount < 0){
	  resultcount = 0;
	}
	totalnum+=resultcount;
	resultpercent=(float)resultcount*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/(float)100;			
	
   %>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <td><a href="HrmRpContractDetail.jsp?typeid=<%=resultid%>">>>></a></td>
    <TD><a href="/hrm/contract/contracttype/HrmContractTypeEdit.jsp?id=<%=resultid%>"> <%=Util.toScreen(ContractTypeComInfo.getContractTypename(resultid),user.getLanguage())%></TD>
    <TD height="100%">        
        <TABLE height="100%" cellSpacing=0 
        <%if(resultpercent==100){%>
        class=redgraph 
        <%}else{%>
        class=greengraph 
        <%}%>
        width="<%=resultpercent%>%">                       
        <TBODY>
        <TR>
        <TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>        
        </TR>
        </TBODY>
        </TABLE>    
    </TD>
    <TD><%=resultcount%></TD>
    <TD><%=resultpercent%>%</TD>    
    </TR>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		
		GraphFile.addConditionlable(Util.toScreen(ContractTypeComInfo.getContractTypename(resultid),user.getLanguage())) ;		
		GraphFile.addPiclinevalues ( ""+resultcount , Util.toScreen(ContractTypeComInfo.getContractTypename(resultid),user.getLanguage()) , GraphFile.random , null  );    		
    		}while(rs.next());    		
	}
	int colcount = GraphFile.getConditionlableCount() + 1 ;
	%>  
</table>
<br>
<TABLE class=ViewForm>
  <TBODY>     
  <TR> 
    <TD align=center>
        <img src='/weaver/weaver.file.GraphOut?pictype=3'>
    </TD>
  </TR>     
  </TBODY> 
</TABLE>
</form>
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
<script language=javascript>  
function submitData() {
 document.frmmain.from.value ="type";
 frmmain.submit();
}
</script>
<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr=<%=rightStr%>&selectedids="&frmMain.departmentid.value)	
	if id(0)<> 0 then	
	departmentspan.innerHtml = id(1)
	frmMain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmMain.departmentid.value=""	
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>