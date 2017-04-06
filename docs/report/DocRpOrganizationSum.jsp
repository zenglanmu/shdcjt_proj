<%@ page import="weaver.general.*,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SplitPageUtil" class="weaver.general.SplitPageUtil" scope="page" />
<jsp:useBean id="SplitPageParaBean" class="weaver.general.SplitPageParaBean" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>

<%
    String organizationtype = Util.null2String(request.getParameter("organizationtype"));
    String titlelable="";
    if  ("1".equals(organizationtype)) titlelable = SystemEnv.getHtmlLabelName(20415,user.getLanguage());
    else if  ("2".equals(organizationtype)) titlelable = SystemEnv.getHtmlLabelName(20414,user.getLanguage());
    else if  ("3".equals(organizationtype)) titlelable = SystemEnv.getHtmlLabelName(20413,user.getLanguage());
    

    int prepage = 10 ;
    int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
    
    
	//目前该功能只开发给文档管理员，因为可以查看到所有文档的文档名称。
    if(!HrmUserVarify.checkUserRight("DocEdit:Delete",user)) {//如果具有删除文档的权限,则认为是文档管理员
    	response.sendRedirect("/notice/noright.jsp") ;
    	return ;
    }
    
    
    String organizationid = Util.null2String(request.getParameter("organizationid")) ;
    
    String fromdate = Util.null2String(request.getParameter("fromdate")) ;
    String todate = Util.null2String(request.getParameter("todate")) ;
    String secid = Util.null2String(request.getParameter("secid"));
    String treeDocFieldId = Util.null2String(request.getParameter("treeDocFieldId"));
	
    String orderby = Util.null2String(request.getParameter("orderby"));
    
    String imagefilename = "/images/hdReport.gif";
    String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage()) + ":" + titlelable;
    String needfav ="1";
    String needhelp =""; 
    int total=0;
    int linecolor=0;
    char separator = Util.getSeparator() ;
    int userid=user.getUID();
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.report.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=report name=report action=DocRpOrganizationSum.jsp method=post>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">

<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow style="width: 100%" >
		<tr>
		<td valign="top">
			<TABLE class=ViewForm  >
				<COLGROUP> <COL width="99%"> <COL width="1%"><TBODY>
				<TR>
				  <TD vAlign=top>



<TABLE class=ViewForm border=0>
  <COLGROUP> <COL width="15%"> <COL width="30%"> <COL width="15%"> <COL width="40%">
  <TBODY>
  <TR>
  	<TD>
    <%
    if(organizationtype.equals("1")) {
    %>
    
    <%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></TD>
    <TD class=Field>
    <BUTTON class=Browser type="button"></BUTTON>&nbsp;
    <SPAN id=organizationdesc>
	<%=Util.toScreen(CompanyComInfo.getCompanyname("1"),user.getLanguage())%>
	</SPAN>
	<INPUT id=organizationid type=hidden name=organizationid value="<%=1%>" >
    
    <% 
    } else if(organizationtype.equals("2")) { 
    %>
    
    <%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
    <TD class=Field>
    <BUTTON class=Browser type="button" onClick="onShowSubCompany()"></BUTTON>&nbsp;
    <SPAN id=organizationdesc>
	<%if(!organizationid.equals("")) {%>
	<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid),user.getLanguage())%>
    <%}%>
	</SPAN>
	<INPUT id=organizationid type=hidden name=organizationid value="<%=organizationid%>" >
    <% 
    } else if(organizationtype.equals("3")) { 
    %>
    
    <%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class=Field>
    <BUTTON class=Browser onClick="onShowDepartment()" type="button"></BUTTON>&nbsp;
    <SPAN id=organizationdesc>
	<%if(!organizationid.equals("")) {%>
	<%=Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid),user.getLanguage())%>
    <%}%>
	</SPAN>
	<INPUT id=organizationid type=hidden name=organizationid value="<%=organizationid%>" >
	<% } %>

	<INPUT id=organizationtype type=hidden name=organizationtype value="<%=organizationtype%>" >
    </TD>
    
    
    
    <TD><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></TD>
    <TD class=field> <input class="wuiDate"  type="hidden" name="fromdate" value="<%=fromdate%>">
      -&nbsp;&nbsp;
	 <input  class="wuiDate"  type="hidden" name="todate" value="<%=todate%>">
    </TD>
  </TR>
<TR  style="height:2px" ><TD class=Line colSpan=4></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></TD>
    <TD class=Field>
      <SELECT class=InputStyle  id=orderby style="WIDTH: 150px" name=orderby>
        <OPTION value=1 <%if(orderby.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%>
        <OPTION value=2 <%if(orderby.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <OPTION value=3 <%if(orderby.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%>
      </SELECT>
    </TD>
      <TD></TD>
    <TD class=Field>
    </TD>
  </TR>
<TR  style="height:2px" ><TD class=Line colSpan=4></TD></TR>
  </TBODY>
</TABLE>
</FORM>
        
        

            <TABLE class=ListStyle width="100%" cellspacing=1>
              <COLGROUP>
              <COL align=left width="15%">
              <COL align=left width="19%">
              <COL align=right width="7%">
              <COL align=right width="10%">
              <COL align=left width="19%">
              <COL align=right width="7%">
              <COL align=right width="9%">
              <COL align=right width="6%">
              <COL align=right width="9%">
              <TBODY>
              <TR class=header>
                <TH colspan=9><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH>
              </TR>
              <TR class=Header>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></TH>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
                <TH>%</TH>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TH>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></TH>
                <TH>%</TH>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TH>
                <TH>%</TH></TR>
            <TR class=Line><TD colSpan=9></TD></TR>
                <%
                String sql = " select count(t1.id) from docdetail t1,hrmresource t2 where (t1.doccreaterid = t2.id or t1.ownerid = t2.id) and t1.docstatus in (1,2,5) and (t1.ishistory <>1 or t1.ishistory is null) ";

            	String sqlWhere = " and t1.docstatus in (1,2,5) and (t1.ishistory <>1 or t1.ishistory is null) ";
            	if(Util.getIntValue(organizationtype,1)==2&&Util.getIntValue(organizationid,0)>0){
            		sqlWhere += " and t2.subcompanyid1 = " + organizationid;
            		sql += " and t2.subcompanyid1 = " + organizationid;
            	} else if(Util.getIntValue(organizationtype,1)==3&&Util.getIntValue(organizationid,0)>0){
            		sqlWhere += " and t2.departmentid = " + organizationid;
            		sql += " and t2.departmentid = " + organizationid;
            	}
                
            	if(fromdate!=null&&!"".equals(fromdate)){
            		sqlWhere += " and t1.doccreatedate >= '" + fromdate + "' ";
            		sql += " and t1.doccreatedate >= '" + fromdate + "' ";
            	}
            	
            	if(todate!=null&&!"".equals(todate)){
            		sqlWhere += " and t1.doccreatedate <= '" + todate + "' ";
            		sql += " and t1.doccreatedate <= '" + todate + "' ";
            	}
            	
            	RecordSet.executeSql(sql);
            	RecordSet.next();
            	total = Util.getIntValue(RecordSet.getString(1));
            	
            	String tmporgastr = "";
            	if(Util.getIntValue(organizationtype,1)==1)
            		tmporgastr = "t2.subcompanyid1";
            	else if(Util.getIntValue(organizationtype,1)==2)
            		tmporgastr = "t2.departmentid";
            	else if(Util.getIntValue(organizationtype,1)==3)
            		tmporgastr = "t2.id";
            	
            	String orderbyStr = "";
            	if(RecordSet.getDBType().equals("oracle")){
            		orderbyStr = " nvl(resultcount1,0) desc ";
            	} else {
            		orderbyStr = " isnull(resultcount1,0) desc ";
            	}
            	if(Util.getIntValue(orderby,1)==1)
                	if(RecordSet.getDBType().equals("oracle")){
                		orderbyStr = " nvl(resultcount1,0) desc ";
                	} else {
                		orderbyStr = " isnull(resultcount1,0) desc ";
                	}
            	else if(Util.getIntValue(orderby,1)==2)
                	if(RecordSet.getDBType().equals("oracle")){
                		orderbyStr = " nvl(resultcount3,0) desc ";
                	} else {
                		orderbyStr = " isnull(resultcount3,0) desc ";
                	}
            	else if(Util.getIntValue(orderby,1)==3)
                	if(RecordSet.getDBType().equals("oracle")){
                		orderbyStr = " nvl(resultcount2,0) desc ";
                	} else {
                		orderbyStr = " isnull(resultcount2,0) desc ";
                	}
            		
                sql =   " select * from ( " +
                		" select * from ( "+
                		" select "+tmporgastr+" as resultid1, count(t1.id) as resultcount1 from docdetail t1, "+
                		" hrmresource t2 "+
                		" where (t1.doccreaterid = t2.id or t1.ownerid = t2.id) "+
                		sqlWhere +
						" group by " + tmporgastr +
                		" ) a "+
                		" left join "+
                		" ( "+
                		" select "+tmporgastr+" as resultid2, count(t1.id) as resultcount2 from docdetail t1, "+
                		" hrmresource t2 "+
                		" where (t1.doccreaterid = t2.id or t1.ownerid = t2.id) "+
                		sqlWhere +
                		" and t1.isreply=1 "+
                		" group by " + tmporgastr +
                		" ) b on a.resultid1 = b.resultid2 " +
                		" left join "+
                		" ( "+
                		" select "+tmporgastr+" as resultid3, count(t1.id) as resultcount3 from docdetail t1, "+
                		" hrmresource t2 "+
                		" where (t1.doccreaterid = t2.id or t1.ownerid = t2.id) "+
                		sqlWhere +
                		" and (t1.isreply <> 1 or t1.isreply is null) "+
                		" group by " + tmporgastr +
                		" ) c on a.resultid1 = c.resultid3 " +
                		" ) t " +
                		" order by " + orderbyStr;
                
				RecordSet.executeSql(sql);
            	while(RecordSet.next()){
                
	                String resultid = RecordSet.getString("resultid1");
	                
                    int resultcount = Util.getIntValue(RecordSet.getString("resultcount1"),0);
                    
                    int replycount = Util.getIntValue(RecordSet.getString("resultcount2"),0);
                    
                    int normalcount = resultcount-replycount;
                    if(normalcount<0) normalcount = 0;
                    
                    float resultpercent=((total==0)?0:(float)resultcount*100/(float)total);
                    
                    resultpercent=Math.round(resultpercent*100)/100f;//(float)((int)(resultpercent*100))/100;
                    
                    float normalpercent=((resultcount==0)?0:(float)normalcount*100/(float)resultcount);
                    
                    normalpercent=Math.round(normalpercent*100)/100f;//(float)((int)(normalpercent*100))/100;
                    
                    float replypercent=((resultcount==0)?0:(float)replycount*100/(float)resultcount);
                    
                    replypercent=Math.round(replypercent*100)/100f;//(float)((int)(replypercent*100))/100;
                    
                %>
              <TR <%if(linecolor%2==0){%>class=datalight <%} else {%> class=datadark <%}%>>
                <TD>
               
                <%
                String showname="";
                if ("1".equals(organizationtype)) showname=SubCompanyComInfo.getSubCompanyname(resultid);
                else if ("2".equals(organizationtype)) showname=DepartmentComInfo.getDepartmentname(resultid);
                else if ("3".equals(organizationtype)) showname=ResourceComInfo.getResourcename(resultid);
                %>
                <%=showname%>                
                </TD>
               <TD>
                  <TABLE height="100%" cellSpacing=0 width="100%">
                    <TBODY>
                    <TR>
                        <TD class=redgraph width="<%=(resultpercent<1?1:(int)resultpercent+1)%>%"><img src="/images/spacer.gif" width=0 height=0></TD>
                        <TD width="*"><img src="/images/spacer.gif" width=0 height=0></TD>
                     </TR>
                    </TBODY>
                   </TABLE>
                 </TD>
                <TD><%=resultcount%></TD>
                <TD><%=resultpercent%>%</TD>
               <TD>
                  <TABLE height="100%" cellSpacing=0 width="100%">
                    <TBODY>
                    <TR>
                      <TD class=bluegraph width="<%=normalpercent%>%" <%if(normalpercent==0.0) out.println("style='display:none'");%>><img src="/images/spacer.gif" width=0 height=0></TD>
                      <TD class=greengraph width="<%=replypercent%>%" <%if(replypercent==0.0) out.println("style='display:none'");%>><img src="/images/spacer.gif" width=0 height=0></TD>          
                     </TR>
                    </TBODY>
                   </TABLE>
                 </TD>
                <TD><%=normalcount%></TD>
                <TD><%=normalpercent%>%</TD>
                <TD><%=replycount%></TD>
                <TD><%=replypercent%>%</TD></TR>
              <% 
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
</BODY>
<script language="javascript">

function onShowDepartment(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("#organizationid").val());
	if(results){
	   if(results.id!=""){
	     jQuery("#organizationdesc").html(results.name);
	     jQuery("#organizationid").val(results.id);
	   }else{
	     jQuery("#organizationdesc").html("");
	     jQuery("#organizationid").val("");
	   }
	}
}

function onShowSubCompany(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+jQuery("#organizationid").val());
	if(results){
	   if(results.id!=""){
	     jQuery("#organizationdesc").html(results.name);
	     jQuery("#organizationid").val(results.id);
	   }else{
	     jQuery("#organizationdesc").html("");
	     jQuery("#organizationid").val("");
	   }
	}
}

function onReSearch(){
	fromdatespan.innerHTML="";
	report.fromdate.value="";
	
	todatespan.innerHTML="";
	report.todate.value="";
	
	<%if(!organizationtype.equals("1")) {%>
	organizationdesc.innerHTML="";
	report.organizationid.value="";
	<%}%>
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>