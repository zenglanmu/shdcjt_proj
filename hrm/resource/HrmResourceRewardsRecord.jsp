<%@ page import="weaver.general.Util,weaver.conn.*,java.math.*,
                 weaver.hrm.resource.ResourceComInfo" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="AwardComInfo" class="weaver.hrm.award.AwardComInfo" scope="page" />
<jsp:useBean id="CheckItemComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%!
   /**
    * Added By Charoes Huang On May 20 ,2004
    * @param resourceid
    * @param comInfo
    * @return  the resource name string with hyper link
    */
   private String getRecourceLinkStr(String resourceid,ResourceComInfo comInfo){
       String linkStr ="";
       String[] resources =Util.TokenizerString2(resourceid,",");
       for(int i=0;i<resources.length;i++){
           linkStr += "<A href=\"/hrm/resource/HrmResource.jsp?id="+resources[i]+"\">"+comInfo.getResourcename(resources[i])+"</A>&nbsp;";
       }
       return linkStr;
   }
%>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
AllManagers.getAll(resourceid);
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
//added by hubo,20060113
if(resourceid.equals("")) resourceid=String.valueOf(user.getUID());
boolean isSelf		=	false;
boolean isManager	=	false;
if (resourceid.equals(""+user.getUID()) ){
	isSelf = true;
}
while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		isManager = true;
	}
}
if(!(isSelf||isManager||HrmUserVarify.checkUserRight("HrmResource:RewardsRecord",user))) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
char separator = Util.getSeparator() ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(7015,user.getLanguage());
String needfav ="1";
String needhelp ="";
String sql = "" ;
%>
<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>
<% if(!isfromtab){%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<%if(!isfromtab){ %>
<TABLE class=Shadow>
<%}else{ %>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">

<TABLE class=ListStyle cellspacing=1  >

<TR class=Header>
    <TH width="20%" colspan=5><%=SystemEnv.getHtmlLabelName(15682,user.getLanguage())%>
    </TH>
    </TR>

<tr class=Header>
    <Td width=20%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></Td>
    
    <Td width=10%><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></Td>
    <Td width=10%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></Td>
    <Td width=25%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></Td>
    <Td width=25%><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></Td>
</tr>

<%
    int temp=0;
    boolean isLight = false;
	if("oracle".equals(rs.getDBType())){
	  sql = "select * from HrmAwardInfo where concat(concat(',',resourseid),',') like '%," +resourceid+",%'" ;
	}else if("db2".equals(rs.getDBType())){
	  sql = "select * from HrmAwardInfo where concat(concat(',',resourseid),',') like '%," +resourceid+",%'" ;
	}else{
	  sql = "select * from HrmAwardInfo where ','+resourseid+',' like '%," +resourceid+",%'" ;
	}
    
    rs.executeSql(sql) ;
    while(rs.next()){
        String ids = Util.null2String(rs.getString("id")) ;
        String rptitles = Util.toScreen(rs.getString("rptitle"),user.getLanguage()) ;
        String rpdates = Util.toScreen(rs.getString("rpdate"),user.getLanguage()) ;
        String rpexplains = Util.toScreen(rs.getString("rpexplain"),user.getLanguage()) ;
        String rptransacts = Util.toScreen(rs.getString("rptransact"),user.getLanguage()) ;
        String resourceids = rs.getString("resourseid") ;

%>
<tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
	<TD style="display:none"><%=ids%></TD>
    <TD><%=rptitles%></a></TD>

     <TD><%=Util.toScreen(AwardComInfo.getAwardName(rs.getString("rptypeid")),user.getLanguage())%></TD>
    <TD><%=rpdates%></TD>
    <TD><%=rpexplains%></TD>
    <TD><%=rptransacts%></TD>
</TR>
<% } %>
</TABLE>
<br>
<b><%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%></b>
<%
ArrayList checkiditemids = new ArrayList() ;
ArrayList results = new ArrayList() ;

sql = " select a.checkid,a.proportion,b.checkitemid,sum(b.result),count(b.result)"+
      " from HrmByCheckPeople a , HrmCheckGrade b "+
      " where a.id = b.checkpeopleid and a.resourceid="+resourceid+
      " group by a.checkid,a.proportion, b.checkitemid ";

rs.executeSql( sql ) ;
while( rs.next() ) {
    String checkid = Util.null2String(rs.getString(1));
    double proportion = Util.getDoubleValue(rs.getString(2),0);
    String checkitemid = Util.null2String(rs.getString(3));
    double resultsum = Util.getDoubleValue(rs.getString(4),0);
    double resultcount = Util.getDoubleValue(rs.getString(5),0);
    double tempresultsum = resultsum * proportion / resultcount / 100.00 ;

    int checkiditemidindex = checkiditemids.indexOf( checkid + "_" + checkitemid ) ;
    if( checkiditemidindex == -1 ) {
        checkiditemids.add( checkid + "_" + checkitemid ) ;
        results.add( "" + tempresultsum ) ;
    }
    else {
        double tempoldresultsum = Util.getDoubleValue( (String)results.get(checkiditemidindex) ,0) ;
        tempresultsum += tempoldresultsum ;
        results.set( checkiditemidindex , "" + tempresultsum ) ;

    }
}


ArrayList checkids = new ArrayList() ;
ArrayList hasrecordcounts = new ArrayList() ;

sql = " select checkid , count(resourceid) from HrmByCheckPeople where resourceid="+resourceid +
      " and result > 0 group by checkid " ;

rs.executeSql(sql);
while(rs.next()){
    String checkid = Util.null2String(rs.getString(1));
    String hasrecordcount = Util.null2String(rs.getString(2));
    checkids.add( checkid ) ;
    hasrecordcounts.add( hasrecordcount ) ;

}


String checktypeid = "" ;
String checkitemid = "" ;
String checkitemproportion = "" ;
ArrayList checktypeids = new ArrayList() ;
ArrayList checkitemids = new ArrayList() ;
ArrayList checkitemproportions = new ArrayList() ;
sql = " select checktypeid,checkitemid,checkitemproportion from HrmcheckKindItem " ;
rs.executeSql(sql);
while(rs.next()){
    checktypeid = Util.null2String(rs.getString(1)) ;
    checkitemid = Util.null2String(rs.getString(2)) ;
    checkitemproportion = Util.null2String(rs.getString(3)) ;
    checktypeids.add(checktypeid) ;
    checkitemids.add(checkitemid) ;
    checkitemproportions.add(checkitemproportion) ;

}
sql ="select distinct a.checktypeid from HrmCheckList a,HrmByCheckPeople b "+
      " where a.id = b.checkid and b.resourceid = "+resourceid ;

rs.executeSql(sql);

while(rs.next()) {
    checktypeid = Util.null2String(rs.getString("checktypeid"));
    String kindname = "" ;
    sql = "select kindname from HrmCheckKind where id="+checktypeid ;
    rs2.executeSql(sql) ;
    if(rs2.next()) kindname = Util.toScreen(rs2.getString("kindname"),user.getLanguage()) ;

%>
    <TABLE class=ListStyle cellspacing=1 >
        <TR class=header>
            <TH><%=kindname%></TH>
        </tr>
    </table>
    <TABLE class=ListStyle cellspacing=1  >
    <tr class=Header>
    <Td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></Td>
    <%
   for(int i=0;i<checkitemids.size();i++){
        checkitemid = (String)checkitemids.get(i) ;
        String newchecktypeid = (String)checktypeids.get(i) ;
         if(!newchecktypeid.equals(checktypeid)) continue ;
    %>
    <TD><%=Util.toScreen(CheckItemComInfo.getCheckName(checkitemid),user.getLanguage())%></TD>
    <%
    }
    %>
    <Td><%=SystemEnv.getHtmlLabelName(15649,user.getLanguage())%></Td>
    <Td><%=SystemEnv.getHtmlLabelName(15650,user.getLanguage())%></Td>
   </tr>
    <%
    String checkid = "";
    sql = " select id , startdate , enddate from HrmCheckList"+ " where id in ( select distinct"+        " checkid from HrmByCheckPeople where resourceid="+resourceid + " and result>0)"+
          " and checktypeid="+checktypeid ;

    rs2.executeSql(sql) ;
    while(rs2.next()) {
        checkid = Util.null2String(rs2.getString(1)) ;
        String startdate = Util.null2String(rs2.getString(2));
        String enddate = Util.null2String(rs2.getString(3));

        String hasrecordcount = "" ;
        int checkidindex = checkids.indexOf( checkid ) ;
        if( checkidindex != -1 ) hasrecordcount = (String)hasrecordcounts.get(checkidindex) ;
        isLight = !isLight ;

    %>
   <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
     <td><%=startdate%>~<%=enddate%></td>
    <%
        double resourceresultsum = 0 ;
        for(int i=0;i<checkitemids.size();i++){
            String newchecktypeid = (String)checktypeids.get(i) ;
            if(!newchecktypeid.equals(checktypeid)) continue ;
            checkitemid = (String)checkitemids.get(i) ;
            checkitemproportion = (String)checkitemproportions.get(i) ;

            String result = "" ;
            int resultindex = checkiditemids.indexOf( checkid + "_" + checkitemid ) ;
            if(resultindex != -1 ) result =  (String)results.get(resultindex) ;

            resourceresultsum += Util.getDoubleValue(result,0) * Util.getDoubleValue(checkitemproportion,0) / 100.00 ;

            result = ""+ (new BigDecimal(Util.getDoubleValue(result))).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;

    %>
    <TD><%=result%></TD>
    <%
        }
    resourceresultsum = (new BigDecimal(resourceresultsum)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
    %>
    <TD><%=resourceresultsum%></TD>
    <TD><%=hasrecordcount%></TD>
 </tr>
 <%
    }
 %>
</table>
<%
}
%>
<BR>
<TABLE class="ListStyle" cellspacing="1">
<COLGROUP>
<COL width="30%">
<COL width="20%">
<COL width="20%">
<COL width="15%">
<COL width="15%">
<TR class="Header">
    <TH algin="left" colspan="5"><%=SystemEnv.getHtmlLabelName(17503,user.getLanguage())%></TH>
</TR>
<TR class="Header">
    <TD><%=SystemEnv.getHtmlLabelName(15653,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15648,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15657,user.getLanguage())%></TD>
</TR>

<%
    isLight = false;
    String m_checkedId = "";
    String m_checkName = "";
    String m_startDate = "";
    String m_endDate = "";
    String m_valuatedId = "";
    String m_score = "";
    sql = "select a.id, b.checkname, a.resourceid, b.startdate, b.enddate, a.result" +
    " from HrmByCheckPeople a , HrmCheckList b "+
    " where a.checkid = b.id and a.checkercount="+resourceid +" and b.enddate>='"+currentdate+"' " ;
    rs.executeSql(sql);
    while (rs.next()) {
        m_checkedId = Util.null2String(rs.getString(1)) ;
        m_checkName = Util.null2String(rs.getString(2)) ;
        m_valuatedId = Util.null2String(rs.getString("resourceid")) ;
        m_startDate = Util.null2String(rs.getString("startdate")) ;
        m_endDate = Util.null2String(rs.getString("enddate")) ;
        m_score = Util.null2String(rs.getString("result")) ;

        isLight = !isLight;

    %>
    <TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
    <TD class="Field"><A href="/hrm/actualize/HrmCheckMark.jsp?id=<%=m_checkedId%>"><%=m_checkName%></A></TD>
    <TD class="Field"><%=m_startDate%></TD>
    <TD class="Field"><%=m_endDate%></TD>
    <TD class="Field"><%=ResourceComInfo.getResourcename(m_valuatedId)%></TD>
    <TD class="Field"><%=m_score%></TD>
    </TR>
    <%}%>
</TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
</BODY></HTML>