<%@ page import="weaver.general.Util,weaver.conn.*,java.math.*" %>
<%@ page import="" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CheckComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(7014,user.getLanguage());
String needfav ="1";
String needhelp ="";
String sql="" ;
String id = Util.null2String(request.getParameter("id")) ;
String checktypeid = "" ;

sql = "select checktypeid from HrmCheckList where id="+id ;
rs.executeSql(sql);
if(rs.next()) checktypeid = Util.null2String(rs.getString("checktypeid"));

ArrayList checkitemids = new ArrayList() ;
ArrayList checkitemproportions = new ArrayList() ;
sql = "select checkitemid , checkitemproportion from HrmCheckKindItem where checktypeid="+checktypeid ;
rs.executeSql(sql) ;
while(rs.next()) {
    String checkitemid = Util.null2String(rs.getString("checkitemid"));
    String checkitemproportion = Util.null2String(rs.getString("checkitemproportion"));
    checkitemids.add(checkitemid) ;
    checkitemproportions.add(checkitemproportion) ;
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/actualize/HrmCheckInfo.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
  <TBODY>
  <TR class=Header>
    <TH colSpan=<%=4+checkitemids.size()%>><%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15648,user.getLanguage())%></TD>
    <%
    for(int i=0;i<checkitemids.size();i++){
        String checkitemid = (String)checkitemids.get(i);
    
    %>
    <TD><%=Util.toScreen(CheckComInfo.getCheckName(checkitemid),user.getLanguage())%></TD>
    <%
    }    
    %>
    <TD><%=SystemEnv.getHtmlLabelName(15649,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15650,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15651,user.getLanguage())%></TD>
  </TR>
<%  
    ArrayList resourceiditemids = new ArrayList() ;
    ArrayList results = new ArrayList() ;

    sql = " select a.resourceid ,a.proportion,b.checkitemid,sum(b.result),count(b.result) " +
          " from HrmByCheckPeople a , HrmCheckGrade b " +
          " where a.id = b.checkpeopleid and a.checkid = " + id +
          " group by a.resourceid , a.proportion, b.checkitemid ";
    
    rs.executeSql( sql ) ;
    while( rs.next() ) {
        String resourceid = Util.null2String(rs.getString(1));
        double proportion = Util.getDoubleValue(rs.getString(2),0);
        String checkitemid = Util.null2String(rs.getString(3));
        double resultsum = Util.getDoubleValue(rs.getString(4),0);
        double resultcount = Util.getDoubleValue(rs.getString(5),0);

        double tempresultsum = resultsum * proportion / resultcount / 100.00 ;
        
        int resourceiditemidindex = resourceiditemids.indexOf( resourceid + "_" + checkitemid ) ;
        if( resourceiditemidindex == -1 ) {
            resourceiditemids.add( resourceid + "_" + checkitemid ) ;
            results.add( "" + tempresultsum ) ;
        }
        else {
            double tempoldresultsum = Util.getDoubleValue( (String)results.get(resourceiditemidindex) ,0) ;
            tempresultsum += tempoldresultsum ;
            results.set( resourceiditemidindex , "" + tempresultsum ) ;
        }
    }

    boolean isLight = false;
    double resourceresultsum = 0 ;

    ArrayList resourceids = new ArrayList() ;
    ArrayList hasrecordcounts = new ArrayList() ;
    
    sql = "select resourceid , count(resourceid) from HrmByCheckPeople where checkid="+id + " and result > 0 group by resourceid " ;
    rs.executeSql(sql);
    while(rs.next()){
        String resourceid = Util.null2String(rs.getString(1));
        String hasrecordcount = Util.null2String(rs.getString(2));
        resourceids.add( resourceid ) ;
        hasrecordcounts.add( hasrecordcount ) ;
    }
    sql = "select resourceid , count(resourceid) from HrmByCheckPeople where checkid="+id + " group by resourceid " ;
    rs.executeSql(sql);
    while(rs.next()){
        String resourceid = Util.null2String(rs.getString(1));
        String checkercount = Util.null2String(rs.getString(2));
        String hasrecordcount = "" ;
        int resourceidindex = resourceids.indexOf( resourceid ) ;
        if( resourceidindex != -1 ) hasrecordcount = (String)hasrecordcounts.get(resourceidindex) ;
        resourceresultsum = 0 ;
        isLight = !isLight ;   
%> 
   <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD>
    <a href = "/hrm/actualize/HrmCheckResourceInfo.jsp?resource=<%=resourceid%>&checkid=<%=id%>">
    <%=Util.toScreen(ResourceComInfo.getResourcename(rs.getString("resourceid")),user.getLanguage())%></a></TD>
    <%
    for( int i = 0 ; i< checkitemids.size() ; i++ ) {
        String checkitemid = (String) checkitemids.get(i) ;
        double checkitemproportion = Util.getDoubleValue((String) checkitemproportions.get(i),0) ;
        int resultindex = resourceiditemids.indexOf( resourceid + "_" + checkitemid ) ;
        String resultstr = "" ;
        double result = 0 ;
        if(resultindex != -1 ) result =  Util.getDoubleValue((String)results.get(resultindex),0) ;
        resourceresultsum += result * checkitemproportion / 100.00 ;
        result = (new BigDecimal(result)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
        if( result != 0 ) resultstr = "" + result ;
    %>
    <TD><%=resultstr%></TD> 
    <%
    }
    String resourceresultsumstr = "" ;
    resourceresultsum = (new BigDecimal(resourceresultsum)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
    if( resourceresultsum != 0 ) resourceresultsumstr = "" + resourceresultsum ;
    %>
    <TD><%=resourceresultsumstr%></TD> 
    <TD><%=checkercount%></TD> 
    <TD><%=hasrecordcount%></TD> 
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
<td height="0" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>