<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(378,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmLocationsAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/location/HrmLocationAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmLocations:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+23+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+23+",_self} " ;
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
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="40%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(378,user.getLanguage())%></TH></TR>
    <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
  </TR>

<%
     //String sql = "select * from HrmLocations ";
     String sql = "select * from HrmLocations order by showOrder asc";
     rs.executeSql(sql);
     int needchange = 0;
      while(rs.next()){
      int isfirst = 1;
       try{       
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
 <%
  	}else{
  		needchange=0;
 %>
     <TR class=datadark>
 <% 
   }
 %>
    <TD><a href="HrmLocationEdit.jsp?id=<%=rs.getString("id")%>">          <%=rs.getString("locationname")%></a>
    </TD>
    <TD><%=rs.getString("locationdesc")%>
    </TD>
    <TD><%=CountryComInfo.getCountryname(rs.getString("countryid"))%>
    </TD>
    <TD><%=Util.null2String(rs.getString("showOrder"))%>
    </TD>	 
  </TR>
<%isfirst=0;
      }catch(Exception e){
        System.out.println(e.toString());
      }
      
    }
%>  
 </TBODY></TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="4"></td>
</tr>
</table>

 
</BODY></HTML>
