<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<jsp:useBean id="UseDemandManager" class="weaver.hrm.report.UseDemandManager" scope="session"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(16060,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16063,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;


int content=Util.getIntValue(request.getParameter("content"),1);

String sqlwhere = "";
String sql = "";
sql= "select demandnum from HrmUseDemand  where 4 = 4 "+sqlwhere;
rs.executeSql(sql);
while(rs.next()){
total += rs.getInt(1);
}
String title = "";
if(content==1){title = SystemEnv.getHtmlLabelName(124,user.getLanguage());}
if(content==2){title = SystemEnv.getHtmlLabelName(6086,user.getLanguage());}
if(content==3){title = SystemEnv.getHtmlLabelName(6152,user.getLanguage());}
if(content==4){title = SystemEnv.getHtmlLabelName(818,user.getLanguage());}
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(352,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
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
<form name=frmmain method=post action="HrmUseDemandReport.jsp">
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
    <td width=10%><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></td>
    <td class=field>
      <INPUT class=inputStyle maxLength=4 size=4 name="year"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
    </td>  
    <td><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></td>
    <td class=Field>
       <select class=inputstyle name="content" value="<%=content%>" onchange="dosubmit()">                
         <option value=1 <%if(content == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> </option>
         <option value=2 <%if(content == 2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> </option>
         <option value=3 <%if(content == 3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%> </option>
         <option value=4 <%if(content == 4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%> </option>
       </select>
    </td>    
</tr>
<TR><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>
<table class=ListStyle cellspacing=1 >
<colgroup>
<tbody>
  <TR class=Header >
    <TH colspan=13><%=SystemEnv.getHtmlLabelName(15861,user.getLanguage())%>: <%=total%></TH>
  </TR>
  <tr class=header>    
    <td><%=title%></td>
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
   int line = 0;
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(16064,user.getLanguage()) + title + SystemEnv.getHtmlLabelName(15101,user.getLanguage()) ;        
   ExcelFile.setFilename(""+year+filename) ;
   

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(""+year+filename) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(8000) ;
   
   ExcelRow er = null ;

   er = et.newExcelRow() ;
   er.addStringValue(title,"Header"); 
   for(int i = 1;i<13;i++){
     er.addStringValue(Util.toScreen(i+"月",user.getLanguage(),"0"),"Header"); 
   }
   
   
   int totalnum = 0;
   if(total!=0){
     Hashtable ht = new Hashtable();
     Hashtable show = new Hashtable();     
     ht = UseDemandManager.getResultByContent(content,sqlwhere);
     show = UseDemandManager.getShow();
     Enumeration keys = ht.keys();
     while(keys.hasMoreElements()){        
	String resultid = (String)keys.nextElement();
	int  resultcount = Util.getIntValue((String)ht.get(resultid));
	String name = Util.toScreen((String)show.get(resultid),user.getLanguage());
	ExcelRow ers = et.newExcelRow() ;
	ers.addStringValue(name);
	ArrayList al = new ArrayList();
	al =  UseDemandManager.getMonResultByContent(content,year,resultid);
   %>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>      
    <TD><%=name%></TD>
<%        for(int i=0;i<al.size();i++){
           ers.addStringValue((String)al.get(i));
     		
%>     
    <TD><%=al.get(i)%></TD>    
<%}%>    
    </TR>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		}      	
    	}	
	%>  
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
  function dosubmit(){
    document.frmmain.submit();
  }
  function submitData() {
 frmmain.submit();
}
</script>
</body>
  <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>