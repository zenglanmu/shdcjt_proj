<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String from = Util.null2String(request.getParameter("from"));
String nothrmids = Util.null2String(request.getParameter("nothrmids"));  //经过选择排除的邮件发送人

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String sqlwhere = HrmSearchComInfo.FormatSQLSearch();
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);

RecordSet.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(RecordSet.next()){
	perpage =Util.getIntValue(RecordSet.getString(36),-1);
}

if(perpage<=1 )	perpage=10;

String temptable = "hrmtemptable"+ Util.getRandom() ;
String Hrm_SearchSql = "";

int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0);
String tempsearchsql = HrmSearchComInfo.FormatSQLSearch();



//去掉"order by"子句,防止下面的查询语句出现错误
String tempstr = "" ;
if(tempsearchsql.length() > 0 && tempsearchsql.indexOf("order by") >=0 ) tempstr = tempsearchsql.substring(0,tempsearchsql.indexOf("order by"));

if(TotalCount==0){
	if (tempsearchsql.equals("")){
		Hrm_SearchSql = "select count(*) from HrmResource  t1 "+ tempstr;
	}else{
		Hrm_SearchSql = "select count(*) from HrmResource  t1 "+ tempstr;
	}
	RecordSet.executeSql(Hrm_SearchSql);

	if(RecordSet.next()){
	TotalCount = RecordSet.getInt(1);
	}
}

//tempsearchsql from HrmSearchComInfo will always has a order by clause
if(RecordSet.getDBType().equals("oracle")){
	Hrm_SearchSql = "create table "+temptable+"  as select * from (select t1.* from HrmResource  t1 "+ tempsearchsql+" desc) where rownum<"+ (pagenum*perpage+2);
}else{
	Hrm_SearchSql = "select top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from HrmResource  t1 "+ tempsearchsql+" desc";
}

//out.print(Hrm_SearchSql) ;

RecordSet.executeSql(Hrm_SearchSql);

RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by "+HrmSearchComInfo.getOrderby()+") where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by "+HrmSearchComInfo.getOrderby();
}

RecordSet.executeSql(sqltemp);

String jobtitleid = Util.null2String(HrmSearchComInfo.getJobtitle());
String departmentid = Util.null2String(HrmSearchComInfo.getDepartment());
String costcenterid = Util.null2String(HrmSearchComInfo.getCostcenter());
String resourcetype = Util.null2String(HrmSearchComInfo.getResourcetype());
String empstatus = Util.null2String(HrmSearchComInfo.getStatus());
String orderby = Util.null2String(HrmSearchComInfo.getOrderby());

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(1226,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(172,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:shareNext(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;
if(pagenum>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:changePageSubmit(\\\"/sendmail/HrmChoice.jsp?pagenum="+(pagenum-1)+"&from="+from+"&TotalCount="+TotalCount+"\\\"),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(hasNextPage){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:changePageSubmit(\\\"/sendmail/HrmChoice.jsp?pagenum="+(pagenum+1)+"&from="+from+"&TotalCount="+TotalCount+"\\\"),_self} " ;
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
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=frmMain action="HrmChoice.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere%>" >
<%
if(from.equals("hrmorg")){%>
<div id=oDiv>
<% }else{%>
<div id=oDiv style="display:none">
<%}%>
        <TABLE class=ListStyle cellspacing=1  WIDTH=100%>
        <TR><TH COLSPAN=8 ALIGN=LEFT><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR>
        
        </TABLE>
        <TABLE CLASS=VIEWForm>
        <COL WIDTH=15%>
        <COL WIDTH=27%>
        <COL WIDTH=5%>
        <COL WIDTH=*%>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
            <TD class=Field>

              <input class="wuiBrowser" id=department type=hidden name=department value="<%=departmentid%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			  _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>"
			  _callback="changeValue">
             </TD>
			<TD></TD>
			<TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
			<TD CLASS=Field colspan=5>
			<%
			String ischecked = "";
			if(resourcetype.equals("2"))
				ischecked = " checked";
			%>
				<INPUT class=inputstyle TYPE=radio VALUE="2" name=resourcetype <%=ischecked%>><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%>
			<%
			ischecked = "";
			if(resourcetype.equals("1"))
				ischecked = " checked";
			%>
				<INPUT class=inputstyle TYPE=radio VALUE="1" name=resourcetype <%=ischecked%>><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%>
			<%
			ischecked = "";
			if(resourcetype.equals("3"))
				ischecked = " checked";
			%>	<INPUT class=inputstyle TYPE=radio VALUE="3" name=resourcetype <%=ischecked%>><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%>
			<%
			ischecked = "";
			if(resourcetype.equals("4"))
				ischecked = " checked";
			%>	<INPUT class=inputstyle TYPE=radio VALUE="4" name=resourcetype <%=ischecked%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%>
			<%
			ischecked = "";
			if(resourcetype.equals(""))
				ischecked = " checked";
			%>	<INPUT class=inputstyle TYPE=radio VALUE="" name=resourcetype <%=ischecked%>>
			<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
			</TD>
		</TR>
         <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
		<TR><TD><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></TD>
			 <TD class=Field>
			 
              <input class="wuiBrowser" id=costcenter type=hidden name=costcenter value="<%=costcenterid%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp"
			  _displayText="<%=Util.toScreen(CostcenterComInfo.getCostCentername(costcenterid),user.getLanguage())%>">
             </TD><TD></TD>
			<TD><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>

				<TD CLASS=Field colspan=4>
				<SELECT CLASS=INPUTSTYLE Name=status >
				<%
			ischecked = "";
			if(empstatus.equals("0"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="0" <%=ischecked%>>
			<%
			ischecked = "";
			if(empstatus.equals("1"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="1" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%>
			<%
			ischecked = "";
			if(empstatus.equals("2"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="2" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(415,user.getLanguage())%>
			</TD>
		</TR>
		<TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></TD>
			<TD CLASS=Field><SELECT class=inputstyle Name=orderby >
			<%
			ischecked = "";
			if(orderby.equals("id"))
				ischecked = " selected";
			%>
			     	<OPTION VALUE="id" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%>
			<%
			ischecked = "";
			if(orderby.equals("firstname"))
				ischecked = " selected";
			%>	<OPTION VALUE="firstname" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%>
			<%
			ischecked = "";
			if(orderby.equals("lastname"))
				ischecked = " selected";
			%>	<OPTION VALUE="lastname" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(461,user.getLanguage())%>
			<%
			ischecked = "";
			if(orderby.equals("birthday"))
				ischecked = " selected";
			%>	<OPTION VALUE="birthday" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%>
			<%
			ischecked = "";
			if(orderby.equals("jobtitle"))
				ischecked = " selected";
			%>	<OPTION VALUE="jobtitle" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%>
			<%
			ischecked = "";
			if(orderby.equals("countryid"))
				ischecked = " selected";
			%>	<OPTION VALUE="countryid" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>
			<%
			ischecked = "";
			if(orderby.equals("nationality"))
				ischecked = " selected";
			%>	<OPTION VALUE="nationality" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(465,user.getLanguage())%>
			<%
			ischecked = "";
			if(orderby.equals("costcenterid"))
				ischecked = " selected";
			%>	<OPTION VALUE="costcenterid" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%>
		        </SELECT></TD>
		        <TD></TD>
		        <TD></TD>
		        <TD></TD>
		 </TR>
         <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
         </TABLE>

        </div>
</FORM>

<br><b>
<%=SystemEnv.getHtmlLabelName(2111,user.getLanguage())%>：<%=TotalCount%> <%=SystemEnv.getHtmlLabelName(2110,user.getLanguage())%>：<%=pagenum%>
</b><br><br>

  <table class=ListStyle cellspacing=1  id=tblReport>
     <colgroup>
    <col valign=top align=left width="5%">
    <col valign=top align=left width="8%">
    <col valign=top align=left width="25%">
    <col valign=top align=left width="25%">
    <col valign=top align=left width="20%">
    <col valign=top align=left width="17%">
    <tbody>
    <tr class=Header>
      <th></th>
      <th><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(378,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></th>
    </tr>

    <tr class=Header>
      <th></th>
      <th><%=SystemEnv.getHtmlLabelName(547,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> </th>
      <th><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(2120,user.getLanguage())%></th>
    </tr>
    


   <%
   int needchange = 0;
  int totalline=1;
if(RecordSet.last()){
	do{
	try{
   	if(needchange==0){
   %>
   <tr class=DataLight>
   <%}else{
   %>
   <tr class=DataDark>
   <%}%>
      <th><input type="checkbox"  style="width:100%" name="hrmid" onclick="changeCheck(this)" value="<%=RecordSet.getString("id")%>" <%=(nothrmids.indexOf(RecordSet.getString("id"))==-1)?"checked":""%>></th>
      <td><%=RecordSet.getString("workcode")%></td>
      <td><a target="_blank" href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("firstname")%>&nbsp<%=RecordSet.getString("lastname")%></a></td>
      <td><a  target="_blank" href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("departmentid")%>"><%=DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid"))%></a></td>
      <td><a  target="_blank" href="/hrm/location/HrmLocationEdit.jsp?id=<%=RecordSet.getString("locationid")%>"><%=LocationComInfo.getLocationname(RecordSet.getString("locationid"))%></a></td>
      <td><a target="_blank" href="mailto:<%=RecordSet.getString("email")%>"><%=RecordSet.getString("email")%></a></td>
    </tr>
   <% 	if(needchange==0){
   		needchange=1;
   %>
   <tr class=DataLight>
   <%}else{
   needchange=0;%>
   <tr class=DataDark>
   <%}%>
      <th></th>
      <td><% if((currentdate.compareTo(RecordSet.getString("startdate"))>=0 || RecordSet.getString("startdate").equals(""))&& (currentdate.compareTo(RecordSet.getString("enddate"))<=0 || RecordSet.getString("enddate").equals(""))){%>
      <img src="/images/BacoCheck.gif"><%}%>
	  <% if(HrmUserVarify.isUserOnline(RecordSet.getString("id"))) {%><img src="/images/State_LoggedOn.gif"><%}%>
	  </td>
      <td><%=RecordSet.getString("telephone")%></td>
      <td><a  target="_blank" href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=RecordSet.getString("jobtitle")%>"><%=JobTitlesComInfo.getJobTitlesname(RecordSet.getString("jobtitle"))%></a></td>
      <td><a  target="_blank" href="/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id=<%=JobTitlesComInfo.getJobactivityid(RecordSet.getString("jobtitle"))%>"><%=JobActivitiesComInfo.getJobActivitiesname(JobTitlesComInfo.getJobactivityid(RecordSet.getString("jobtitle")))%></a></td>
      <td><a  target="_blank" href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("managerid")%>"><%=ResourceComInfo.getResourcename(RecordSet.getString("managerid"))%></a></td>
    </tr>
   <%if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	 }
      }catch(Exception e){
        System.out.println(e.toString());
      }
}while(RecordSet.previous());
}

RecordSet.executeSql("drop table "+temptable);
%>
    </tbody>

  </TABLE>
	<table align=right>
   <tr>
   <td>&nbsp;</td>

   <td>&nbsp;</td>
   </tr>
</TABLE>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>

</table>

<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.department.value)
	if Not isempty(id) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmMain.department.value=id(0)
	costcenterspan.innerHtml = ""
	frmMain.costcenter.value=""
	else
	departmentspan.innerHtml = ""
	frmMain.department.value=""
	end if
	end if
end sub
sub onShowCostCenter()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="&frmMain.department.value)
	if Not isempty(id) then
	if id(0)<> 0 then
	costcenterspan.innerHtml = id(1)
	frmMain.costcenter.value=id(0)
	else
	costcenterspan.innerHtml = ""
	frmMain.costcenter.value=""
	end if
	end if
end sub
</script>
<script language="JavaScript">
var nothrmids = "<%=nothrmids%>";

function changeCheck(obj){
    if(!obj.status){
        var rep = new RegExp("|"+obj.value,"g");
        nothrmids = nothrmids.replace(rep,"");
        nothrmids +="|"+obj.value;
    }else{
        var rep = new RegExp("|"+obj.value,"g");
        nothrmids = nothrmids.replace(rep,"");
    }
}

function changeValue(){
	jQuery("#costcenterSpan").html("");
	jQuery("input[name=costcenter]").val("");
}

function changePageSubmit(pageStr){
    //alert(pageStr+"&nothrmids="+nothrmids);
    location=pageStr+"&nothrmids="+nothrmids;
}
function shareNext(){
    frmMain.action="HrmMailMerge.jsp?issearch=1&nothrmids="+nothrmids;
    frmMain.submit();
}
</script>
</BODY>
</HTML>
