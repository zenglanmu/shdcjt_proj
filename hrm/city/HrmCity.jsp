<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(493,user.getLanguage());
String needfav ="1";
String needhelp ="";
String provinceid = Util.null2String(request.getParameter("provinceid"));
String countryid = Util.null2String(request.getParameter("countryid"));
if (countryid == "" ){
countryid = user.getCountryid();
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(193,user.getLanguage())+",/hrm/city/HrmCityAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCity:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+61+",_self} " ;
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
  <COLGROUP>
  <COL width="25%">
  <COL width="25%">
  <COL width="25%">
  <COL width="25%">
  <TBODY>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmCity.jsp" method=post>
  <TR class=Header>
    <TH colSpan=4>
	<%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>: 
<select name=countryid size=1 class=inputstyle  onChange="SearchForm.submit()">
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

	<%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%>: 
<select name=provinceid size=1 class=inputstyle  onChange="SearchForm.submit()">
     <option value="">&nbsp;</option>
     <%
      while(ProvinceComInfo.next()){
     	String selected="";
     	String curprovinceid=ProvinceComInfo.getProvinceid();
     	String curprovincename=ProvinceComInfo.getProvincename();
     	if(curprovinceid.equals(provinceid+""))	selected="selected";
     %>
     <option value="<%=curprovinceid%>" <%=selected%>><%=Util.toScreen(curprovincename,user.getLanguage())%></option>
     <%
     }%>
     </select>	
	</TH></TR>
 </FORM>
 
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(801,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(802,user.getLanguage())%></TD>    
  </TR>
  <TR class=Line><TD colspan="4" ></TD></TR> 
<%
    String TempProvincename = "" ;
	boolean isfirst = false ;
    char separator = Util.getSeparator() ;
  	if(countryid =="")
		countryid = "0";
	if(provinceid =="")
		provinceid = "0";

	String para = countryid + separator + provinceid  ;

      rs.executeProc("HrmCity_Select",para);
    int needchange = 0;
      while(rs.next()){
			String caceledstate = "";
			String caceled = "";
			caceled = rs.getString("canceled");
			if("1".equals(caceled)){
					caceledstate = "<span><font color=\"red\">("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")</font></span>";
    		}
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD>
	<%
	String Provincename= Util.toScreen(ProvinceComInfo.getProvincename(rs.getString("provinceid")),user.getLanguage());
	if (TempProvincename != Provincename){
		TempProvincename = Provincename;
		isfirst=true ;
	}  
	else {
		isfirst=false;
	}
    %>  
	<%=isfirst==true?Provincename:""%>
	  
    </TD>
	<TD><a href="HrmCityEdit.jsp?id=<%=rs.getString(1)%>&canceled=<%=rs.getString(7)%>"><%=Util.toScreen(rs.getString(2),user.getLanguage())%></a><%=caceledstate %></TD>
    <TD><%=Util.null2String(rs.getString(3))%></TD>
    <TD><%=Util.null2String(rs.getString(4))%></TD>	  
  </TR>
<%
    }
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
</BODY>
</HTML>