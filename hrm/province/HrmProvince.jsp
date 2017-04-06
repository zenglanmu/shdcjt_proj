<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(800,user.getLanguage());
String needfav ="1";
String needhelp ="";
String countryid = Util.null2String(request.getParameter("countryid"));
if (countryid == "" ){
countryid = user.getCountryid();
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(193,user.getLanguage())+",/hrm/province/HrmProvinceAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmProvince:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+74+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+74+",_self} " ;
    }
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
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmProvince.jsp" method=post>
  <TR class=Header>
    <TH colSpan=3>
	<%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>: 
<select name=countryid size=1 class=inputStyle  onChange="SearchForm.submit()">
     <option value="">&nbsp;</option>
     <%while(CountryComInfo.next()){
     	String selected="";
     	String curcountryid=CountryComInfo.getCountryid();
     	String curcountryname=CountryComInfo.getCountryname();
     	if(curcountryid.equals(countryid+""))	selected="selected";
     %>
     <option value="<%=curcountryid%>" <%=selected%>><%=Util.toScreen(curcountryname,user.getLanguage())%></option>
     <%
     }%>
     </select>	
	</TH></TR>
 </FORM>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
  </TR>
<TR class=Line style="height:1px;"><TD colspan="2" ></TD></TR> 
<%	
	if(countryid =="")
		countryid = "0";

	boolean isfirst = false ;
       rs.executeProc("HrmProvince_Select",countryid);
    int needchange = 0;
      while(rs.next()){
			String caceledstate = "";
			String caceled = "";
			caceled = rs.getString("canceled");
			if("1".equals(caceled)){
					caceledstate = "<span><font color=\"red\">("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")</font></span>";
    		}
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
	<TD><a href="HrmProvinceEdit.jsp?id=<%=rs.getString(1)%>&canceled=<%=rs.getString(5)%>"><%=rs.getString(2)%></a><%=caceledstate %></TD>
    <TD><%=rs.getString(3)%></TD>
    
  </TR>
<%
      }catch(Exception e){
        System.out.println(e.toString());
      }
    }
%>  
 </TBODY>
 </TABLE>
</BODY>
</HTML>