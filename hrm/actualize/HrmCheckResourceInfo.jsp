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
String resource = Util.null2String(request.getParameter("resource")) ;
String checkid = Util.null2String(request.getParameter("checkid")) ;
String checktypeid = "" ;

sql = "select checktypeid from HrmCheckList where id="+checkid ;
rs.executeSql(sql);
if(rs.next()) checktypeid = Util.null2String(rs.getString("checktypeid"));

ArrayList checkitemids = new ArrayList() ;
sql = "select checkitemid from HrmCheckKindItem where checktypeid="+checktypeid ;
rs.executeSql(sql) ;
while(rs.next()) {
    String checkitemid = Util.null2String(rs.getString("checkitemid"));
    checkitemids.add(checkitemid) ;
}

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
    <TH colSpan=<%=3+checkitemids.size()%>><%=SystemEnv.getHtmlLabelName(15647,user.getLanguage())%></TH>
  </TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15662,user.getLanguage())%></TD>
    <%
    for(int i=0;i<checkitemids.size();i++){
        String checkitemid = (String)checkitemids.get(i);
    
    %>
    <TD><%=Util.toScreen(CheckComInfo.getCheckName(checkitemid),user.getLanguage())%></TD>
    <%
    }    
    %>
    <TD><%=SystemEnv.getHtmlLabelName(15663,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></TD>
  </TR>
<%  
    ArrayList results = new ArrayList() ;
    ArrayList gradecheckitemids = new ArrayList() ;
    sql = "select a.checkercount ,b.checkitemid,b.result " +
       "from HrmByCheckPeople a , HrmCheckGrade b " +
       "where a.id = b.checkpeopleid and a.checkid="+checkid + " and a.resourceid="+resource ;
    rs.executeSql(sql);
    while(rs.next()){
        String checkercount = Util.null2String(rs.getString(1));
        String checkitemid = Util.null2String(rs.getString(2));
        String result = Util.null2String(rs.getString(3));

        gradecheckitemids.add( checkercount + "_" + checkitemid ) ;
        results.add(result) ;
              
    } 
     
        boolean isLight = false;
        sql = "select checkercount ,result,proportion from HrmByCheckPeople where checkid="+checkid + " and resourceid="+resource+ " order by proportion desc " ;
        rs.executeSql(sql);
        while(rs.next()){
            String checkercount = Util.null2String(rs.getString(1));
            double chiefresult = Util.getDoubleValue(Util.null2String(rs.getString(2)),0);
            String proportion = Util.null2String(rs.getString(3));
            
            isLight = !isLight ;  
                    
%>
                <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
                <TD>
                 <%=Util.toScreen(ResourceComInfo.getResourcename(rs.getString("checkercount")),user.getLanguage())%></a></TD>
                <%
                for( int i = 0 ; i< checkitemids.size() ; i++ ) {
                    String checkitemid = (String) checkitemids.get(i) ;
                    int checkitemidindex = gradecheckitemids.indexOf(checkercount + "_" + checkitemid);
                    String result = "" ;
                    if(checkitemidindex != -1){
                        result = (String) results.get(checkitemidindex) ;
                    }
                %>
                <TD><%=result%></TD> 
                <% 
                }
                String chiefresultstr = "" ;
                if(chiefresult !=0) chiefresultstr = "" + chiefresult ;    
                %>
                <TD><%=chiefresultstr%></TD> 
                <TD><%=proportion%>%</TD> 
                </TR>

<% } %> 
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