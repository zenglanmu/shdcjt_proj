<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";

String businessKind = Util.null2String(request.getParameter("businessKind"));
String business = Util.null2String(request.getParameter("business"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:frmSearch.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/jobactivities/HrmJobActivitiesAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobActivities:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+25+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
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
<TABLE class=Shadow>
<tr>
<td valign="top">

<!--???????????-->

<form name="frmSearch" method="post" action="">
	<table class="ViewForm">
	  <COLGROUP>
	  <COL width="20%">
	  <COL width="30%">
	   <COL width="20%">
	  <COL width="30%">
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%>
			</td>
			<td class="Field">

				<input type="hidden" name="businessKind" class="wuiBrowser" value="<%=businessKind%>"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp"
				_displayText="<%=JobGroupsComInfo.getJobGroupsname(businessKind)%>">
			</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>
			</td>
			<td class="Field">
				<input type="text" name="business" class="inputStyle" value=<%=business%>>
			</td>	
		</tr>
	</table>
</form>

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="60%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TD>    
  </TR>

<%
  String strSql ="select * from HrmJobActivities" ;
  boolean isFirst = true ;
  
  if (!"".equals(businessKind)) {
  	if (isFirst){
  		strSql = strSql + "  where jobgroupid = "+businessKind;
  		isFirst = false ;
  	} else {
  		strSql = strSql + "  and jobgroupid = "+businessKind;
  	}  	  	
  } 
  if (!"".equals(business)) {  
  	if (isFirst){
  		strSql = strSql+" where jobactivityname like '%"+business+"%'";
  		isFirst = false ;
  	} else {
  		strSql = strSql+" and jobactivityname like '%"+business+"%'";
  	}  	  	
  }

  if (!businessKind.equals("") || !business.equals("")){
  	rs.executeSql(strSql);  
  	int needchange = 0;  
  	String tempBusinessKindId = "";
  	while (rs.next()){
  		String businessKindId = rs.getString("jobgroupid");
  		String businessKindName = JobGroupsComInfo.getJobGroupsname(businessKindId);  		
  		String businessId = rs.getString("id");
 		String businessName = rs.getString("jobactivityname");
 		
		if(needchange ==0){
    		needchange = 1;	   %>		
    		<TR class=datalight>
        <%} else {%>
        	<TR class=datadark>
        	<%needchange=0;
        }%>         
      			<TD><a href="/hrm/jobgroups/HrmJobGroupsEdit.jsp?id=<%=businessKindId%>">
      				<%
      					if (!tempBusinessKindId.equals(businessKindId)) {
      						out.println(businessKindName);
							tempBusinessKindId = businessKindId ;
						} else {
							out.println("");
						}					
      				%>      			
      			</a></TD>
			    <TD><a href="HrmJobActivitiesEdit.jsp?id=<%=businessId%>"><%=businessName%></a></TD>			    
			 </TR>  
  		<%  	
  	}
  
  }
  else {
       
	    int needchange = 0;
	      while(JobGroupsComInfo.next()){
	      int isfirst = 1;
	      	String groupid = JobGroupsComInfo.getJobGroupsid();
	      	String groupname = JobGroupsComInfo.getJobGroupsname();      	
	      	while(JobActivitiesComInfo.next()){
	      		String tmpgroup = JobActivitiesComInfo.getJobgroupid();
	      	
	      		if(!tmpgroup.equals(groupid)) continue;
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
	    <TD><a href="/hrm/jobgroups/HrmJobGroupsEdit.jsp?id=<%=tmpgroup%>"><%=isfirst==1?groupname:""%></a></TD>
	    <TD><a href="HrmJobActivitiesEdit.jsp?id=<%=JobActivitiesComInfo.getJobActivitiesid()%>"><%=JobActivitiesComInfo.getJobActivitiesname()%></a></TD>
	    
	  </TR>
	<%isfirst=0;
	      }catch(Exception e){
	        System.out.println(e.toString());
	      }
	      }
	    }
	%>  
<%}%>
 </TBODY></TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr  style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=vbScript>
         sub onShowJobGroup()
                id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp")
                if Not isempty(id) then 
                if id(0)<> 0 then
                businessKindSpan.innerHtml = id(1)
                frmSearch.businessKind.value=id(0)
                else
                businessKindSpan.innerHtml = ""
                frmSearch.businessKind.value=""
                end if
                end if
        end sub
</script> 
</BODY></HTML>