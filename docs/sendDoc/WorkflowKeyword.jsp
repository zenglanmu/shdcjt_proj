<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16978,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("SendDoc:Manage", user)){
       
    RCMenu += "{"+SystemEnv.getHtmlLabelName(19412,user.getLanguage())+",/docs/sendDoc/WorkflowKeywordAdd.jsp?parentId=0&hisId=0,_self} " ;
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
  <COL width="35%">
  <COL width="35%">
  <COL width="30%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(16978,user.getLanguage())%></TH></TR>
 
  <TR class=Header>    
    <TD><%=SystemEnv.getHtmlLabelName(21510,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(21511,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="3" ></TD></TR> 
<%
    int id=0;
    String keywordName=null;
	String keywordDesc=null;
	double showOrder=0;
    RecordSet.executeSql("select * from Workflow_Keyword where parentId<=0 order by showOrder asc");
    int needchange = 0;

    while(RecordSet.next()){
		id=Util.getIntValue(RecordSet.getString("id"),0);
        keywordName=Util.null2String(RecordSet.getString("keywordName"));
        keywordDesc=Util.null2String(RecordSet.getString("keywordDesc"));
        showOrder=Util.getDoubleValue(RecordSet.getString("showOrder"),0);
        try{
			if(needchange ==0){
				needchange = 1;
%>
  <TR class=datalight>
  <%
			}else{
  		        needchange=0;
  %><TR class=datadark>
<%  	
			}
%>    
    <TD><a href="/docs/sendDoc/WorkflowKeywordDsp.jsp?id=<%=id%>"><%=keywordName%></a></TD>
    <TD><%=keywordDesc%></TD>
    <TD><%=showOrder%></TD>    
  </TR>
<%
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
<td height="10" colspan="3"></td>
</tr>
</table>

</BODY></HTML>
