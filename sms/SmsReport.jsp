<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.GraphFile" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
//System.out.println("perpage:"+perpage);
if(perpage<=1 )	perpage=10;
//String useridname=ResourceComInfo.getResourcename(userid+"");
String fromdate=Util.null2String(request.getParameter("fromdate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String department=Util.null2String(request.getParameter("department"));
String hrmid=Util.null2String(request.getParameter("hrmid"));
String reportType=Util.null2String(request.getParameter("reportType"));


String sqlwhere=" where t1.id=t2.userid and messagestatus='1' ";
if(!fromdate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t2.finishtime>='"+fromdate+" 00:00:00'";
	else 	sqlwhere+=" and t2.finishtime>='"+fromdate+" 00:00:00'";
}
if(!enddate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t2.finishtime<='"+enddate+" 23:59:59'";
	else 	sqlwhere+=" and t2.finishtime<='"+enddate+" 23:59:59'";
}
if(!department.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.departmentid="+department;
	else 	sqlwhere+=" and t1.departmentid="+department;
}
if(!hrmid.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t2.userid="+hrmid;
	else 	sqlwhere+=" and t2.userid="+hrmid;
}

    //System.out.println("sqlwhere = " + sqlwhere);
String totalSql = "SELECT COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+sqlwhere;
RecordSet.executeSql(totalSql);
String totalCount = "0";
if(RecordSet.next()){
    totalCount = RecordSet.getString(1);
}

/*
if(user.getLogintype().equals("2")){
	if(sqlwhere.equals(""))	sqlwhere+=" where agentid!='' and  agentid!='0'";
	else 	sqlwhere+=" and  agentid!='' and  agentid!='0'";
}
*/
String sqlstr = "";

if(RecordSet.getDBType().equals("oracle")){
    if(reportType.equals("1")){
        sqlstr = "SELECT t2.smsyear,t2.smsmonth,t2.smsday,COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+ sqlwhere +" GROUP BY t2.smsyear,t2.smsmonth,t2.smsday order by t2.smsyear,t2.smsmonth,t2.smsday";
    }else{
        sqlstr = "SELECT t2.smsyear,t2.smsmonth,COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+ sqlwhere +" GROUP BY t2.smsyear,t2.smsmonth order by t2.smsyear,t2.smsmonth";
    }

}else{
    if(reportType.equals("1")){
        sqlstr = "select t2.smsyear,t2.smsmonth,t2.smsday,COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+ sqlwhere  + " GROUP BY t2.smsyear,t2.smsmonth,t2.smsday order by t2.smsyear,t2.smsmonth,t2.smsday";
    }else{
        sqlstr = "select t2.smsyear,t2.smsmonth,COUNT(*) AS smscount FROM HrmResource t1, SMS_Message t2 "+ sqlwhere  + " GROUP BY t2.smsyear,t2.smsmonth order by t2.smsyear,t2.smsmonth";
    }
}



    RecordSet.executeSql(sqlstr);
    //System.out.println("sqlstr = " + sqlstr);

    GraphFile.init ();
    GraphFile.setPicwidth ( 500 );
    GraphFile.setPichight ( 350 );
    GraphFile.setLeftstartpos ( 30 );
    GraphFile.setHistogramwidth ( 15 );
    GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
    GraphFile.setPiclable (SystemEnv.getHtmlLabelName(18954,user.getLanguage()));

    GraphFile.newLine ();
    GraphFile.addPiclinecolor("#660033") ;
    GraphFile.addPiclinelable(SystemEnv.getHtmlLabelName(18953,user.getLanguage())) ;

    String line = "";
    String value = "0";
    double picWidth = 0.0;
    double picWidthStep = 0.0;
    if(reportType.equals("1")){
        picWidthStep = 80.0;
    }else{
        picWidthStep = 60.0;
    }
    //System.out.println("picWidthStep = " + picWidthStep);
    boolean isEmpty = true;
    while(RecordSet.next()){
        picWidth += picWidthStep;
        line = RecordSet.getString("smsyear")+"-"+RecordSet.getString("smsmonth")+(reportType.equals("1")?"-"+RecordSet.getString("smsday"):"");
        GraphFile.addConditionlable(line) ;
        value = RecordSet.getString("smscount");
        //System.out.println("value = " + value);
        GraphFile.addPiclinevalues ( value , line , "#660033" , null  );
        isEmpty = false;

    }
    GraphFile.setPicwidth ( picWidth+100 );

    if(isEmpty){
        GraphFile.addConditionlable(line) ;
        GraphFile.addPiclinevalues ( "0" , line , "#660033" , null  );
    }

    int colcount = GraphFile.getConditionlableCount() + 1 ;


    String imagefilename = "/images/hdReport.gif";
    String titlename = SystemEnv.getHtmlLabelName(17009,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name=frmmain method=post action="SmsReport.jsp">
<input type="hidden" name="isDelete" value="false">
<center><h3></h3></center>
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


			<table class=ViewForm style="width:820px" >
			  <colgroup>
			  <col width="5%">
			  <col width="30%">
			  <col width="5%">
			  <col width="25%">
			  <col width="5%">
			  <col width="10%">
              <col width="5%">
			  <col width="15%">
			  <tbody>
			  <tr>

			  <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
			  <td class=field>
			    <BUTTON  type="button" class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
			    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
			    <input type="hidden" name="fromdate" value=<%=fromdate%>>
			    －
                <BUTTON  type="button"  class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
			    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
			    <input type="hidden" name="enddate" value=<%=enddate%>>
			  </td>
               <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
               <TD class=Field>
                 <input  class=wuiBrowser   id=department type=hidden name=department value="<%=department%>"
                 _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>"
                 _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
                 >
               </TD>
			  <td><%=SystemEnv.getHtmlLabelName(16975,user.getLanguage())%></td>
                        <td class="field"  >
                          <input  class=wuiBrowser type="hidden" name="hrmid" value="<%=hrmid%>"
                          _displayText="  <%if(!hrmid.equals("")){%>
                                                  <%=Util.toScreen(ResourceComInfo.getResourcename(hrmid+""),user.getLanguage())%>
                                           <%}%>"
                           _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"                
                          >
                        </td>
               <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
               <TD class=Field>
                    <select name="reportType">
                        <option value="1" <%=(reportType.equals("1"))?"selected":""%>><%=SystemEnv.getHtmlLabelName(18955,user.getLanguage())%>
                        <option value="2" <%=(reportType.equals("2"))?"selected":""%>><%=SystemEnv.getHtmlLabelName(18956,user.getLanguage())%>
                    </select >
               </TD>
			  </tr>
			  <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
			<script language=vbs>
			sub onShowuserid()
				id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
				if (Not IsEmpty(id)) then
                    if id(0)<> "" then
                        useridspan.innerHtml = "<A href='Hrmuserid.jsp?id="&id(0)&"'>"&id(1)&"</A>"
                        frmmain.userid.value=id(0)
                    else
                        useridspan.innerHtml = ""
                        frmmain.userid.value=""
                    end if
				end if
			end sub
            sub onShowDepartment()
                id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.department.value)
                if Not isempty(id) then
                    if id(0)<> 0 then
                        departmentspan.innerHtml = id(1)
                        frmmain.department.value=id(0)
                    else
                        departmentspan.innerHtml = ""
                        frmmain.department.value=""
                    end if
                end if
            end sub
            sub onShowResource(tdname,inputename)
                id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
                if NOT isempty(id) then
                    if id(0)<> "" then
                        document.all(tdname).innerHtml = id(1)
                        document.all(inputename).value=id(0)
                    else
                        document.all(tdname).innerHtml = empty
                        document.all(inputename).value=""
                    end if
                end if
            end sub
			</script>
			</tbody>
			</table>
            <TABLE class=ListStyle>
              <TBODY>
              <%if(isEmpty){ %>
              <TR>
                <td colSpan=<%=colcount%>><center><h3><%=isEmpty?"没有任何短信":""%> </h3></center></td>
              </tr>
              <%} %>
              <TR class=Header>
                <TD>&nbsp;</TD>
              <%
                while(GraphFile.nextCondition()) {
                    String condition = GraphFile.getConditionlable() ;
              %>
                <TD><%=condition%></TD>
              <%}%>
              </TR>
              <%
                boolean isLight = false;
                while(GraphFile.nextLine()) {
                    isLight = !isLight ;
                    String linelable = GraphFile.getPiclinelable() ;
              %>
              <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
                <TD><%=linelable%></TD>
              <%
                    while(GraphFile.nextCondition()) {
                        String linevalue = GraphFile.getPiclineValue() ;
              %>
                <TD><%=linevalue%></TD>
              <%    } %>
              </TR>
              <%}%>
              </TBODY>
            </TABLE>

            <%--显示图象--%>
            <TABLE class=form>
              <TBODY>
              <TR>
                <TD align=center>
                    <img src='/weaver/weaver.file.GraphOut?pictype=2'>
                </TD>
              </TR>
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

</form>
</body>
<script language="javascript">
function doDelete(){
    if(confirm("确认要删除信息吗？")){
        document.frmmain.isDelete.value="true";
        document.frmmain.submit();
    }
}
function doSubmit()
{
	document.frmmain.submit();
}
</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>