<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.ldap.LdapUtil"%>
<%@ page import="ln.LN"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
if(!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(17743,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
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
  <COL width="60%">
  <COL width="20%">
  </COLGROUP>
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(17743,user.getLanguage())%></TH></TR>
    <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
  </TR>

<%
    weaver.soa.hrm.HrmService service = new weaver.soa.hrm.HrmService();
    weaver.soa.hrm.ExportResult[] result;
    /*String lastupdate = "0";
    String sql = "select * from ldapimporttime";

    rs.executeSql(sql);
    if (rs.next()) {
        lastupdate = rs.getString("usertime");
    }
    if (lastupdate.equals("0"))*/
        result = service.exportLdap();
    /*else {
        String type = Prop.getPropValue(weaver.general.GCONST.getConfigFile(), LdapUtil.TYPE);
        if (type.equals("ad"))
            lastupdate += "000000.0Z";
        result = service.exportLdapByTime(lastupdate);
    }
    */
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + Util.add0(today.get(Calendar.MONTH) + 1, 2) + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
    LN l = new LN();
            if (l.CkHrmnum() >= 0) {  //reach the max hrm number
              ;
            } else {
                String sql = "update ldapimporttime set usertime='" + currentdate + "'";
                rs.executeSql(sql);
            }
    int needchange = 0;
    for (int i = 0; i < result.length; i++) {
        int isfirst = 1;
        try {
            if (needchange == 0) {
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
    <TD><%=result[i].getLastname()%>
    </TD>
    <TD><%=SystemEnv.getHtmlLabelName(Util.getIntValue(result[i].getOperation()),user.getLanguage())%>
    </TD>
    <TD><%=SystemEnv.getHtmlLabelName(Util.getIntValue(result[i].getStatus()),user.getLanguage())%>
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
<td height="0" colspan="3"></td>
</tr>
</table>


</BODY></HTML>
