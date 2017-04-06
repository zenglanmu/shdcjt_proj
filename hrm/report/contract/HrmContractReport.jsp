<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
session.setAttribute("HrmRpContract_left_"+user.getUID(),"HrmContractReport.jsp");
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}
String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+ SystemEnv.getHtmlLabelName(15939,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
String from = Util.null2String(request.getParameter("from"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
float resultpercent=0;
int linecolor=0;
String sqlwhere = "";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/contract/HrmRpContract.jsp?isFirst=report&subcompanyid1="+subcompanyid1+",_self} " ;
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
<form name=frmmain method=post action="HrmContractReport.jsp">
<input type="hidden" name="from">
<input type="hidden" name="subcompanyid1" value="<%=subcompanyid1%>">
<TABLE class=ViewForm>
  <TBODY> 
  <tr>
    <td width=10%><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></td>
    <td class=field>
      <INPUT class=inputStyle maxLength=4 size=4 name="year"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
    </td>     
   </tr>  
  </TBODY> 
</TABLE>
<%
   int line = 0;
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(15940,user.getLanguage());
   ExcelFile.setFilename(""+year+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
%>
<table class=ListStyle cellspacing=1 >
<tbody>
<TR class=Header>
<TH colspan=13><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>－<%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TH>
  </TR>
  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%></td>
</tr>
<TR class=Line><TD colspan="13" ></TD></TR> 
<%   
   ExcelSheet et = ExcelFile.newExcelSheet(SystemEnv.getHtmlLabelName(124,user.getLanguage())+"－"+ SystemEnv.getHtmlLabelName(887,user.getLanguage())) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(8000) ;
   
   ExcelRow er = null ;

   er = et.newExcelRow() ;
   er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()), "Header" ) ; 
   String sqlwhere1 = "";
   if(detachable==1){
		   if(from.equals("report")){
		   		sqlwhere1+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
		   }
		   if(!subcompanyid1.equals("") && !from.equals("report")){
				sqlwhere1+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
			}
		}
   String sql = "select distinct(t2.departmentid) resultid from HrmContract t1,HrmResource t2 where (t2.accounttype is null or t2.accounttype=0) "+sqlwhere1;     
   //System.out.println(sql); 
   rs2.executeSql(sql);
   while(rs2.next()){   
     String resultid = ""+rs2.getString(1);
     ExcelRow erdep = et.newExcelRow() ;
     String depname = Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage());
     erdep.addStringValue(depname);
     if(line%2==0){
     line++;
%>
<tr class=datalight>
<%}else{%><tr class=datadark><%line++;}%>
  <td><%=depname%></td>
<%     
     for(int month = 1;month<13;month++){   
   	   String title = "" + month + SystemEnv.getHtmlLabelName(6076,user.getLanguage());
		if(er.size()<=12) er.addStringValue(""+title, "Header" ) ;
	   String firstday = ""+year+"-"+Util.add0(month,2)+"-01";
	   String lastday = ""+year+"-"+Util.add0(month,2)+"-31";
	   sqlwhere =" and (contractstartdate >='"+firstday +"' and contractstartdate <= '"+lastday+"')";
	   //System.out.println(subcompanyid);
	   if(detachable==1){
		   if(from.equals("report")){
		   		sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
		   }
		   if(!subcompanyid1.equals("") && !from.equals("report")){
				sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
			}
		}
	   sql = "select count(t1.id) resultcount from HrmContract t1,HrmResource t2 where (t2.accounttype is null or t2.accounttype=0) and t1.contractman = t2.id and t2.departmentid = "+resultid+sqlwhere;	   
	   //out.println(sql+"<br>");	
	   //System.out.println(sql);	     	   
	   rs.executeSql(sql);
	   rs.next();	   
	   String resultcount = ""+rs.getInt(1);
	   erdep.addStringValue(resultcount);
%>
  <td><%=resultcount%></td>
<%	   	   	   
   } 
%>
</tr>
<%    
 } 
%>
</tbody>
</table>
<br>
<table class=ListStyle cellspacing=1 >
<tbody>
<TR class=Header>
    <TH colspan=13><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%>－<%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TH>
  </TR>
  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%></td>
</tr>
<TR class=Line><TD colspan="13" ></TD></TR> 

<%   
   ExcelSheet etType = ExcelFile.newExcelSheet( SystemEnv.getHtmlLabelName(6158,user.getLanguage())+"－"+SystemEnv.getHtmlLabelName(887,user.getLanguage())) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   etType.addColumnwidth(8000) ;
   
   ExcelRow erType = null ;

   erType = etType.newExcelRow() ;
   erType.addStringValue( SystemEnv.getHtmlLabelName(6158,user.getLanguage()), "Header" ) ; 
   
   sql = "select distinct(t2.id) resultid from HrmContract t1,HrmContractType t2 where t1.contracttypeid = t2.id ";
   rs2.executeSql(sql);
   while(rs2.next()){   
     String resultid = ""+rs2.getString(1);
     ExcelRow erdep = etType.newExcelRow() ;
     String typename = Util.toScreen(ContractTypeComInfo.getContractTypename(resultid),user.getLanguage());
     erdep.addStringValue(typename);
     if(line%2==0){
     line++;
%>
<tr class=datalight>
<%}else{%><tr class=datadark><%line++;}%>
  <td><%=typename%></td>
<%     
     for(int month = 1;month<13;month++){   
   	   String title = "" + month + SystemEnv.getHtmlLabelName(6076,user.getLanguage());
   	   if(erType.size()<=12) erType.addStringValue(""+title, "Header" ) ;   	      	   
	   String firstday = ""+year+"-"+Util.add0(month,2)+"-01";
	   String lastday = ""+year+"-"+Util.add0(month,2)+"-31";
	   sqlwhere =" and (contractstartdate >='"+firstday +"' and contractstartdate <= '"+lastday+"')";
	   
	   sql = "select count(t1.id) resultcount from HrmContract t1 where t1.contracttypeid =  "+resultid+sqlwhere;
	   //out.println(sql+"<br>");		     	   
	   rs.executeSql(sql);
	   rs.next();	   
	   String resultcount = ""+rs.getInt(1);
	   erdep.addStringValue(resultcount);
%>
  <td><%=resultcount%></td>
<%	   	   	   
   } 
%>
</tr>
<%    
 } 
%>
</tbody>
</table>
<br>
<table class=ListStyle cellspacing=1 >
<tbody>
<TR class=Header>
    <TH colspan=13><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>－<%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></TH>
  </TR>
  <tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
<%
  ExcelSheet etdepType = ExcelFile.newExcelSheet( SystemEnv.getHtmlLabelName(124,user.getLanguage())+"－"+SystemEnv.getHtmlLabelName(6158,user.getLanguage())) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   etdepType.addColumnwidth(8000) ;
   
   ExcelRow erdepType = null ;

   erdepType = etdepType.newExcelRow() ;
   erdepType.addStringValue( SystemEnv.getHtmlLabelName(124,user.getLanguage()), "Header" ) ; 
   
  sql = "select id,typename from HrmContractType order by id";
  rs.executeSql(sql);
  Hashtable ht = new Hashtable();
  Hashtable htname = new Hashtable();
  int i = 0;
  while(rs.next()){
  ht.put(new Integer(i),rs.getString("id"));
  htname.put(new Integer(i),rs.getString("typename"));
  i++;
  }
  Enumeration keynames = htname.keys();     
  while(keynames.hasMoreElements()){
    Integer index = (Integer)keynames.nextElement();
    String typename = (String)htname.get(index); 
    erdepType.addStringValue(Util.toScreen(Util.null2String(typename),user.getLanguage()), "Header" ) ;   
%>  
  <td><%=Util.null2String(typename)%></td>  
<%}%>  
</tr>
 <TR class=Line><TD colspan="13" ></TD></TR> 

<%    
	String sqlwhere2 = "";
	if(detachable==1){
		   if(from.equals("report")){
		   		sqlwhere2+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
		   }
		   if(!subcompanyid1.equals("") && !from.equals("report")){
				sqlwhere2+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
			}
		}
   sql = "select distinct(t2.departmentid) resultid from HrmContract t1,HrmResource t2 where 1=1" +sqlwhere2;
   rs2.executeSql(sql);
   while(rs2.next()){   
     String resultid = ""+rs2.getString(1);
     ExcelRow erdep = etdepType.newExcelRow() ;
     String depname = Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage());
     erdep.addStringValue(depname);
     if(line%2==0){
     line++;
%>
<tr class=datalight>
<%}else{%><tr class=datadark><%line++;}%>
  <td><%=depname%></td>
<%     
     Enumeration keys = ht.keys();     
     while(keys.hasMoreElements()){
           Integer index = (Integer)keys.nextElement();
           String typeid = (String)ht.get(index);     
	   sqlwhere =" and contracttypeid =  "+typeid;	
	   String firstday = ""+year+"-01-01";
	   String lastday = ""+year+"-12-31";
	   sqlwhere +=" and (contractstartdate >='"+firstday +"' and contractstartdate <= '"+lastday+"')";   
	   sql = "select count(t1.id) resultcount from HrmContract t1,HrmResource t2 where t1.contractman = t2.id and t2.departmentid = "+resultid+sqlwhere;
	   rs.executeSql(sql);
	   rs.next();	   
	   String resultcount = ""+rs.getInt(1);
	   erdep.addStringValue(resultcount);
%>
  <td><%=resultcount%></td>

<%	   	   	   
   } 
%>
</tr>

<%    
 } 
%>
</tbody>
</table>
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
document.frmmain.from.value = "report";
 frmmain.submit();
}
</script>
</body>
</html>