<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(21602,user.getLanguage())+SystemEnv.getHtmlLabelName(446,user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 

String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String companyid = Util.null2String(request.getParameter("companyid"));
if(companyid.equals("0")) subcompanyid = companyid;//如果companyid=0，则为总部

String showname="";
if(!subcompanyid.equals("0")) showname = SubCompanyComInfo.getSubCompanyname(subcompanyid);
else showname = CompanyComInfo.getCompanyname("1");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("AnnualPeriod:All" , user)) { 
RCMenu += "{"+SystemEnv.getHtmlLabelName(365 , user.getLanguage())+",/hrm/schedule/AnnualPeriodAdd.jsp?subcompanyid="+subcompanyid+",_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91 , user.getLanguage())+",javascript:ondelete(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(21671 , user.getLanguage())+",javascript:onSyn(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
	<td valign="top">
<form method=post>
<TABLE class=Shadow>
	<tr>
	<td valign="top">
<table class=Viewform>
  <COLGROUP><COL width="18%"><COL width="82%">
      <TBODY>
      <TR class=Title colspan=5>
        <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
      </TR>
      <TR class=Spacing style="height:2px">
        <TD class=Line1 colspan=3></TD>
      </TR>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%></TD>
        <TD class=field>
          <SPAN><%=showname%></SPAN>          
        </TD>              
      </TR>
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
     </TBODY>
</table>
<br>	
<TABLE class=ListStyle>
 <TBODY>
  <TR class=Header>
    <TH align=left colSpan=2><%=titlename%></TH>
  </TR>
 </TBODY>
</TABLE>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="5%">
  <COL width="20%">
  <COL width="25%">
  <COL width="25%">

  <TBODY>
  <TR class=Header align=left>
    <TH><input type=checkbox name=checkbox value="" onclick="checkall(this)"></TH>
    <TH><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TH>
  </TR>

<%//subcompanyid=0为总部
	RecordSet.executeSql("select * from hrmannualperiod where subcompanyid = " + subcompanyid + " order by annualyear desc");
	int i = 0 ;
	while(RecordSet.next()){
		String id =Util.null2String(RecordSet.getString("id"));
		String annualyear=Util.null2String(RecordSet.getString("annualyear"));
		String startdate=Util.null2String(RecordSet.getString("startdate"));
		String enddate=Util.null2String(RecordSet.getString("enddate"));
				
if(i==0) {
		i=1 ; 
%>
<TR class=DataLight>
<%
	}else{
		i=0 ; 
%>
<TR class=DataDark>
<%
}
%>
    <TD><input type="checkbox" id="periodbox" name="periodbox" value="<%=id%>"></TD>
    <TD><A href="AnnualPeriodEdit.jsp?id=<%=id%>&subcompanyid=<%=subcompanyid%>"><%=annualyear%></A></TD>
    <TD><%=startdate%></TD>
    <TD><%=enddate%></TD>
    </TR>
<%}%>
</TBODY></TABLE>
    
</td>
</tr>
	</TABLE>
</form>	
	</td>
	<td></td>
</tr>
<tr>
	<td height="0" colspan="4"></td>
</tr>
</table>
<script language="javascript">
function onSyn(){
   var v = document.getElementsByName("periodbox");
   var ids = "";
   for(var i=0;i<v.length;i++){
      if(v[i].checked == true) ids = ids + v[i].value + ","
   }
   if(ids==""){
      alert("<%=SystemEnv.getHtmlLabelName(21677,user.getLanguage())%>");
      return false;
   }else{
     if(confirm("<%=SystemEnv.getHtmlLabelName(21669,user.getLanguage())%>")){
       location.href="/hrm/schedule/AnnualPeriodOperation.jsp?operation=syn&subcompanyid=<%=subcompanyid%>&ids="+ids;       
     }   
  }
}
function checkall(obj){
   var v = document.getElementsByName("periodbox");
   for(var i=0;i<v.length;i++){
      v[i].checked = obj.checked;
   }
}
function ondelete(){
   var v = document.getElementsByName("periodbox");
   var ids = "";
   for(var i=0;i<v.length;i++){
      if(v[i].checked == true) ids = ids + v[i].value + ","
   }
   if(ids==""){
      alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
      return false;
   }else{
    if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>")){
       if(confirm("<%=SystemEnv.getHtmlLabelName(18260,user.getLanguage())%>")){       
          location.href="/hrm/schedule/AnnualPeriodOperation.jsp?operation=syndelete&subcompanyid=<%=subcompanyid%>&ids="+ids;       
       }else{
          location.href="/hrm/schedule/AnnualPeriodOperation.jsp?operation=delete&subcompanyid=<%=subcompanyid%>&ids="+ids;       
       }
    }
   }  
}
</script>
</BODY>
</HTML>

