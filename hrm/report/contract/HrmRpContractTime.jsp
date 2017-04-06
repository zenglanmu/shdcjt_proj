<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page"/>
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
session.setAttribute("HrmRpContract_left_"+user.getUID(),"HrmRpContractTime.jsp");
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}
String type = Util.null2String(request.getParameter("type"));
String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
String from = Util.null2String(request.getParameter("from"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15943,user.getLanguage());
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

String sqlwhereyear = "";
String sqlwhere = "";

	sqlwhereyear+=" and t1.contractstartdate>='"+year+"-01-01'";
	sqlwhereyear+=" and (t1.contractstartdate<='"+year+"-12-31' or t1.contractstartdate is null)";
if(detachable==1){
	if(!subcompanyid1.equals("") && from.equals("")){
		sqlwhereyear+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}
	if(from.equals("time")){
		subcompanyid1 = String.valueOf(user.getUserSubCompany1()); 
		sqlwhereyear+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}
}
String sql = "select count(t1.id) from HrmContract t1,HrmResource t2 where 3 = 3 "+sqlwhereyear;
//System.out.println(sql);
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/contract/HrmRpContract.jsp?isFirst=time&subcompanyid1="+subcompanyid1+",_self} " ;
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

<form name=frmmain method=post action="HrmRpContractTime.jsp">
<input type="hidden" name="from">
<input type="hidden" name="subcompanyid" value="<%=subcompanyid1%>">
<%
   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable ( SystemEnv.getHtmlLabelName(15954,user.getLanguage()) );   
%>
<br>
<TABLE class=ViewForm>
  <TBODY> 
  <tr>
    <td width=10%><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></td>
    <td class=field>
      <INPUT class=inputStyle maxLength=4 size=4 name="year"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
    </td>        
    <td width=10%><%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%></td>
    <td class=field>
      <select name=type value="<%=type%>">
      <option value="" selected></option>
      
<%
  sql = "select id,typename from HrmContractType";
  rs.executeSql(sql);
  Hashtable ht  = new Hashtable();  
  while(rs.next()){  
   ht.put(new Integer(rs.getInt("id")),rs.getString("typename"));
   
%>
         <option value="<%=rs.getString("id")%>" <%if(rs.getString("id").equals(type)){%>selected <%}%>><%=rs.getString("typename")%></option>
<%  
  }
%>      
      </select>      
    </td>     
   </tr>
<% 
    String sqlwheret = "";
    if(detachable==1){
	if(!subcompanyid1.equals("") && from.equals("")){
		sqlwheret+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}
	if(from.equals("time")){
		subcompanyid1 = String.valueOf(user.getUserSubCompany1()); 
		sqlwheret+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}
}
if(type.equals("")){   
for(int month = 1;month<13;month++){
   GraphFile.addConditionlable(""+month+Util.toScreen("ÔÂ",user.getLanguage(),"0")) ;
}   

Enumeration keys = ht.keys();
while(keys.hasMoreElements()){    
    Integer typeid = (Integer)keys.nextElement();
    String typename = (String)ht.get(typeid); 
    GraphFile.newLine();   
    GraphFile.addPiclinecolor(GraphFile.random) ; 
    GraphFile.addPiclinelable(Util.toScreen(typename,user.getLanguage())) ; 
    for(int month = 1;month<13;month++){     
	String firstday = ""+year+"-"+Util.add0(month,2)+"-01";
	String lastday = ""+year+"-"+Util.add0(month,2)+"-31";
	sqlwhere =" and (contractstartdate >='"+firstday +"' and contractstartdate <= '"+lastday+"')";
	sqlwhere += " and t1.contracttypeid="+typeid;
	sql = "select count(t1.id) resultcount from HrmContract t1,HrmResource t2 where 3 = 3 "+sqlwhere+sqlwheret;		
	//System.out.println(sql);     
	rs.executeSql(sql);
	rs.next();
	String number = ""+rs.getInt(1);
	GraphFile.addPiclinevalues ( ""+number , ""+month+Util.toScreen("ÔÂ",user.getLanguage(),"0"), "" , null);    		   
     } 
   
}
}else{
   GraphFile.newLine ();
   GraphFile.addPiclinecolor(GraphFile.red) ;
   GraphFile.addPiclinelable(""+year) ;   
   for(int month = 1;month<13;month++){
	   String firstday = ""+year+"-"+Util.add0(month,2)+"-01";
	   String lastday = ""+year+"-"+Util.add0(month,2)+"-31";
	   sqlwhere =" and (contractstartdate >='"+firstday +"' and contractstartdate <= '"+lastday+"')";	   
	   sqlwhere += " and t1.contracttypeid="+type;	   
	   sql = "select count(t1.id) resultcount from HrmContract t1,HrmResource t2 where 3 = 3 "+sqlwhere+sqlwheret;		
	   rs.executeSql(sql);
	   rs.next();
	   String number = ""+rs.getInt(1);
	   String title = ""+month+Util.toScreen("ÔÂ",user.getLanguage(),"0");
	   GraphFile.addConditionlable(title) ;		
	   GraphFile.addPiclinevalues ( ""+number , title , "" , null  );    		
   }   

}     
   int colcount = GraphFile.getConditionlableCount() + 1 ;
%>   
  <TR> 
    <TD align=center colspan=4>
        <img src='/weaver/weaver.file.GraphOut?pictype=2'>
    </TD>
  </TR>  
  <TR> 
    <TD align=center colspan=4>
        <img src='/weaver/weaver.file.GraphOut?pictype=1'>
    </TD>
  </TR>    
  </TBODY> 
</TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY> 
  <TR class=Header>
    <TD>&nbsp;</TD>
  <%
    while(GraphFile.nextCondition()) {
        String condition = GraphFile.getConditionlable() ;
  %>
    <TD><%=condition%></TD>
  <%}%>
  </TR>
 <TR class=Line><TD colspan=<%=colcount%> ></TD></TR> 
  <%
    boolean isLight = false;
    while(GraphFile.nextLine()) {
        isLight = !isLight ;
        String linelable = GraphFile.getPiclinelable() ;
  %>
  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD><%=linelable%></TD>
  <%
        while(GraphFile.nextCondition()) {
            String linevalue = GraphFile.getPiclineValue() ;
  %>
    <TD><%=linevalue%></TD>
  <%    } %>
  </TR>
  <%}%>
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
document.frmmain.from.value = "time";
 frmmain.submit();
}
</script>
</body>
</html>