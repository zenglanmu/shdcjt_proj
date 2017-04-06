<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="RpCareerApplyManager" class="weaver.hrm.report.RpCareerApplyManager" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int year = Util.getIntValue(request.getParameter("year"),0);
if(year==0){
Calendar todaycal = Calendar.getInstance ();
year = todaycal.get(Calendar.YEAR);
}


String month = Util.null2String(request.getParameter("month"));
if(month.equals("")){
Calendar todaycal = Calendar.getInstance ();
month = Util.add0(todaycal.get(Calendar.MONTH)+1, 2);
}

String userid =""+user.getUID();
int space=Util.getIntValue(request.getParameter("space"));
int col=Util.getIntValue(request.getParameter("col"),1);
if(col == 3){
  space=Util.getIntValue(request.getParameter("space"),10000);  
}
if(col == 4){
  space=Util.getIntValue(request.getParameter("space"),1);
}
int row=Util.getIntValue(request.getParameter("row"),1);

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

String sqlwhere = "";

if(fromdate.equals("")&&enddate.equals("")){
  fromdate = Util.add0(year,4)+"-01-01";
  enddate = Util.add0(year,4)+"-12-31";
}
if(row==1 || row == 2){
if(!fromdate.equals("")){
	sqlwhere+=" and t1.createdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
  if(RecordSet.getDBType().equals("oracle")){
	sqlwhere+=" and (t1.createdate<='"+enddate+"' and t1.createdate is not null)";
  }else{
    sqlwhere+=" and (t1.createdate<='"+enddate+"' and t1.createdate is not null and t1.createdate <> '')";
  }
}
}
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(352,user.getLanguage())+",/hrm/report/careerapply/HrmRpCareerApply.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",/hrm/report/careerapply/HrmRpCareerApplySearch.jsp,_self} " ;
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
<form name=frmmain action="HrmCareerApplyReport.jsp">
<table class=ViewForm>
<tbody>
<tr>
    <td><%=SystemEnv.getHtmlLabelName(15930,user.getLanguage())%></td>
    <td class=Field>
       <select class=inputStyle name="col" value="<%=col%>">                                    
         <option value=1 <%if(col == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15931,user.getLanguage())%> </option>
         <option value=2 <%if(col == 2){%> selected <%}%>> <%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%>     </option>                           
         <option value=3 <%if(col == 3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%> </option>
         <option value=4 <%if(col == 4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%> </option>
       </select>
    </td>
<%if(col == 3|| col == 4){%>
    <td width=10%><%=SystemEnv.getHtmlLabelName(15932,user.getLanguage())%></td>
    <td class=field>
      <INPUT class=inputStyle maxLength=6 size=6 name="space"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("space")' value="<%=space%>">
    </td>             
<%}%> 
    <td>行名</td>
    <td class=Field>
       <select name="row" value="<%=row%>" onchange="onRefrash()">                                    
         <option value=1 <%if(row == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></option>         
         <option value=2 <%if(row == 2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%> </option>         
         <option value=3 <%if(row == 3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(887,user.getLanguage())%> </option>         
       </select>
    </td>   
</tr>
<TR><TD class=Line colSpan=6></TD></TR> 
<tr>
<%if(row == 3){%>
    <td width=10%><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></td>
    <td class=field>
      <INPUT class=inputStyle maxLength=4 size=4 name="year"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
    </td>             
<%}else{%>
    <td width=10%><%=SystemEnv.getHtmlLabelName(15934,user.getLanguage())%></td>
    <td class=field>
    <BUTTON class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="enddate" value=<%=enddate%>>  
    </td>    
<%}%>    
</tr>
<TR><TD class=Line colSpan=2></TD></TR> 
</tbody>
</table>
<table border=1 width=100%>
  <tr>
<td>
      <TABLE class=ListStyle cellspacing=1 >
        
        <TBODY> 
        <TR class=Header> 
          <TH colSpan=50><%=SystemEnv.getHtmlLabelName(15929,user.getLanguage())%></TH>
        </TR>
       
        <TR class=Header> 
<%
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(15929,user.getLanguage());
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(""+filename) ;
   
   ExcelRow er = null ;
   er = et.newExcelRow() ;
   String type = "";
   if(row == 1){ 
   	type=SystemEnv.getHtmlLabelName(15671,user.getLanguage());
   }
   if(row == 2){ 
   	type=SystemEnv.getHtmlLabelName(6132,user.getLanguage());
   }
   if(row == 3){ 
   	type=SystemEnv.getHtmlLabelName(887,user.getLanguage());
   }
   er.addStringValue(type,"Header");
%>
   <td>
     <%=type%>
   </td>   
<%   
Hashtable result = new Hashtable();
result = RpCareerApplyManager.getResultByColRow(col,row,sqlwhere,space,year);
Hashtable header = RpCareerApplyManager.getHeader();
Hashtable show = RpCareerApplyManager.getShow();

Enumeration skeys = show.keys();
while(skeys.hasMoreElements()){
  Integer index = (Integer)skeys.nextElement();
  String head = (String)show.get(index);
  er.addStringValue(head,"Header") ;
%>        
          <TD><%=head%></TD>
          
<%}%>          
        </TR>
        <TR class=Line><TD colspan="50" ></TD></TR> 
        <%
int needchange = 0;
Enumeration hkeys = header.keys();
while(hkeys.hasMoreElements()){
  Integer index = (Integer)hkeys.nextElement();
  ExcelRow erdep = et.newExcelRow() ; 
  String name = (String)header.get(index);
  erdep.addStringValue(name);
  
  Hashtable content = (Hashtable)result.get(index);
       	if(needchange ==0){
       		needchange = 1;
%>
        <TR class=datalight> 
          <%
  	}else{
  		needchange=0;
  %>
        <TR class=datadark> 
          <%  	}%>
          <td><%=Util.toScreen(name,7)%></td>
<%          
        Enumeration keys = content.keys();
        while(keys.hasMoreElements()){          
          Integer indexc = (Integer)keys.nextElement();          
          String num = (String)content.get(indexc);
          erdep.addStringValue(num);
  %>
          <TD><%=Util.toScreen(num,7)%></TD>                    
<%}%>          
        </TR>
<%   
}
%>        
        </TBODY> 
      </TABLE>
 </td>
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
<script language=javascript>
function onRefrash(){
  
	document.frmmain.submit();
  
}
function submitData() {
 frmmain.submit();
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
