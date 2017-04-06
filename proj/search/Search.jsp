<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />

<%@ include file="/systeminfo/init.jsp" %>
<%
String method=Util.null2String(request.getParameter("method"));
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);	
// if(method.equals("empty"))               // modify by liuyu to empty any where
// {
	SearchComInfo1.resetSearchInfo();
//	mouldid=0;
// }
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(101,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid = user.getUID();

	String status ="";
	String prjtype   ="";
	String worktype="";
	String nameopt   ="";
	String name="";
	String description ="";
	String customer ="";
 	String parent = "";
	String securelevel ="";
	String department ="";
	String manager ="";
	String member ="";
	String procode="";
	
	String startdate="";
	String startdateto="";
	String enddate="";
	String enddateto="";
	
RecordSet.executeProc("Prj_SearchMould_SelectByID",""+mouldid);
if(RecordSet.next()){		
	status =Util.toScreenToEdit(RecordSet.getString(5),user.getLanguage());
	prjtype   =Util.toScreenToEdit(RecordSet.getString(6),user.getLanguage());
	worktype=Util.toScreenToEdit(RecordSet.getString(7),user.getLanguage());
	nameopt   =Util.toScreenToEdit(RecordSet.getString(8),user.getLanguage());
	name=Util.toScreenToEdit(RecordSet.getString(9),user.getLanguage());
	description =Util.toScreenToEdit(RecordSet.getString(10),user.getLanguage());
	customer =Util.toScreenToEdit(RecordSet.getString(11),user.getLanguage());
	parent =Util.toScreenToEdit(RecordSet.getString(12),user.getLanguage());
	securelevel =Util.toScreenToEdit(RecordSet.getString(13),user.getLanguage());
	department =Util.toScreenToEdit(RecordSet.getString(14),user.getLanguage());
	manager =Util.toScreenToEdit(RecordSet.getString(15),user.getLanguage());
	member =Util.toScreenToEdit(RecordSet.getString(16),user.getLanguage());
	procode=Util.toScreenToEdit(RecordSet.getString("procode"),user.getLanguage()); 
	
	startdate=Util.toScreenToEdit(RecordSet.getString("startdatefrom"),user.getLanguage()); 
	startdateto=Util.toScreenToEdit(RecordSet.getString("startdateto"),user.getLanguage()); 
	enddate=Util.toScreenToEdit(RecordSet.getString("enddatefrom"),user.getLanguage()); 
	enddateto=Util.toScreenToEdit(RecordSet.getString("enddateto"),user.getLanguage()); 	
}
else{
	 status =Util.toScreenToEdit(SearchComInfo1.getstatus(),user.getLanguage());
	 prjtype   =Util.toScreenToEdit(SearchComInfo1.getprjtype(),user.getLanguage());
	 worktype=Util.toScreenToEdit(SearchComInfo1.getworktype(),user.getLanguage());
	 nameopt   =Util.toScreenToEdit(SearchComInfo1.getnameopt(),user.getLanguage());
	 name=Util.toScreenToEdit(SearchComInfo1.getname(),user.getLanguage());
	 description =Util.toScreenToEdit(SearchComInfo1.getdescription(),user.getLanguage());
	 customer =Util.toScreenToEdit(SearchComInfo1.getcustomer(),user.getLanguage());
	 parent =Util.toScreenToEdit(SearchComInfo1.getparent(),user.getLanguage());
	 securelevel =Util.toScreenToEdit(SearchComInfo1.getsecurelevel(),user.getLanguage());
	 department =Util.toScreenToEdit(SearchComInfo1.getdepartment(),user.getLanguage());
	 manager =Util.toScreenToEdit(SearchComInfo1.getmanager(),user.getLanguage());
	 member =Util.toScreenToEdit(SearchComInfo1.getmember(),user.getLanguage());
	 procode=Util.toScreenToEdit(SearchComInfo1.getProcode(),user.getLanguage());
	 
	 startdate=Util.toScreenToEdit(SearchComInfo1.getStartDate(),user.getLanguage());
	 startdateto=Util.toScreenToEdit(SearchComInfo1.getStartDateTo(),user.getLanguage());
	 enddate=Util.toScreenToEdit(SearchComInfo1.getEndDate(),user.getLanguage());
	 enddateto=Util.toScreenToEdit(SearchComInfo1.getEndDateTo(),user.getLanguage());
}
%>
<BODY>

<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:formreset(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;

if(mouldid==0) {


RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:onSaveas(),_top}";
RCMenuHeight += RCMenuHeightStep;} ; 

if(mouldid!=0) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top}" ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top}" ;
RCMenuHeight += RCMenuHeightStep;};

%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name="resource" method="post" action="SearchOperation.jsp">


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




<TABLE cellPadding=0 cellSpacing=0 width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top width="84%">
      <TABLE class=viewform width="100%">
	<!-- BUTTON class=btnReset id=Empty accessKey=E onclick="location.href='/proj/search/Search.jsp?method=empty'"><U>E</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON -->
	
        <COLGROUP>
        <COL width="49%">
        <COL width="2%">
        <COL width="49%">
        <TBODY>

        <TR class=title>
          <Td colSpan=3 >
           <TABLE class=viewform >
              <COLGROUP>
              <COL width="20%">
              <COL width="60%">
              <TBODY>
              <%String tmpval="";
              if(mouldid==0 || !status.equals("")){
              %>
              <tr>              
              	<td><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></td>
              	<td class=field>
              	<%
              		
              		while(ProjectStatusComInfo.next()){
              			tmpval = ProjectStatusComInfo.getProjectStatusid();
              			status = "," + status + ",";
              	%>
				<INPUT name="status" type="checkbox" value="<%=ProjectStatusComInfo.getProjectStatusid()%>" <%if(status.indexOf(tmpval)!=-1){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname()),user.getLanguage())%>
              	<%}%>
                <INPUT name="status" type="checkbox" value="0" ><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>
              	</td>
              </tr>

              
			  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
              <%}%>
              <%
              if(mouldid==0 || !prjtype.equals("")){
              %>
              <tr>
              	<td><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></td>
              	<td class=field>
              	<%
              		while(ProjectTypeComInfo.next()){
              			tmpval = ProjectTypeComInfo.getProjectTypeid();
              			prjtype = "," + prjtype + ",";
              	%>
              		<INPUT name="prjtype" type="checkbox" value="<%=ProjectTypeComInfo.getProjectTypeid()%>" <%if(prjtype.indexOf(tmpval)!=-1){%> checked <%}%> ><%=ProjectTypeComInfo.getProjectTypename()%>
              	<%}%>
              	</td>
              <tr><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
              <%}%>
              <%
              if(mouldid==0 || !worktype.equals("")){
              %>
              <tr>
              	<td><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></td>
              	<td class=field>
              	<%
              		while(WorkTypeComInfo.next()){
              		tmpval = WorkTypeComInfo.getWorkTypeid();
              			worktype = "," + worktype + ",";
              	%>
              		<INPUT name="worktype" type="checkbox" value="<%=WorkTypeComInfo.getWorkTypeid()%>"  <%if(worktype.indexOf(tmpval)!=-1){%> checked <%}%> ><%=WorkTypeComInfo.getWorkTypename()%>
              	<%}%>
              	</td>
              <tr><TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR> 
              <%}%>
              </tbody>
            </table>
          </Td></TR>
        
        <TR>
          <TD vAlign=top colSpan=2>
            <TABLE width="100%">
              <COLGROUP>
              <COL width="35%">
              <COL width="65%">
              <TBODY>
              <TR class=title><TH colSpan=2><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></TH></TR>
              <TR class=Separartor style="height:1px;"><TD class=line1 colSpan=2></TD></TR>
              
              <%
              
              if(mouldid==0 ||!procode.equals("")){
              %>             
              
              <TR><TD><%=SystemEnv.getHtmlLabelName(17852,user.getLanguage())%></TD>              
                <TD class=Field><INPUT name=procode size=18 value="<%=procode%>" class="InputStyle"></TD>
              </TR>
              <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>              
              <%}%>

              <%             
              if(mouldid==0 ||!name.equals("")){
              %>
              <TR>
                <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
                <TD class=Field>
                <select class=inputstyle  name="nameopt">
                <option value="0" <%if(nameopt.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%></option>
                <option value="1" <%if(nameopt.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
                <option value="2" <%if(nameopt.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
                <INPUT name=name size=10 value="<%=name%>" class="InputStyle"></TD></TR>  
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>            
              <%}%>
                                   
              <%
              if(mouldid==0 || (!parent.equals("0")&&!parent.equals(""))){
              %>
               <TR>
          	<TD><%=SystemEnv.getHtmlLabelName(636,user.getLanguage())%></TD>
         	 <TD class=Field>
      	 	<INPUT class="wuiBrowser" type=hidden name="parent" value="<%=parent%>"  _displayText="<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(parent),user.getLanguage())%>"
      	 		_displayTemplate="<A href='/proj/data/ViewProject.jsp?ProjID=#b{id}'>#b{name}</a>"
      	 		 _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"></TD>
      	  	</TR>
			<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
      	  	 <%}%>
              <%
			  if(user.getLogintype().equals("1")){
              if(mouldid==0 || (! manager.equals("0")&&! manager.equals(""))){
              %>
              
              <TR>
          <TD><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class="wuiBrowser" type=hidden name="manager" value="<%=manager%>"
              	_displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%>"
              	_displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
              	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
           </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
			  <%}}%>
               <%
              if(mouldid==0 ||(! customer.equals("0")&&! customer.equals(""))){
              %>
              <TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class="wuiBrowser" type=hidden name="customer" value="<%=customer%>" 
              	_displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(customer),user.getLanguage())%>"
              	_displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
              	_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp">
              
              </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <%}%>
             <%
			  if(user.getLogintype().equals("1")){
              if(mouldid==0 || (!member.equals("0")&&!member.equals(""))){
              %>  
              <TR>
          <TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class="wuiBrowser" type=hidden name="member" value="<%=member%>"
              	_displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(member),user.getLanguage())%>"
              	_displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
               _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"></TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <%}}%>
              <%
			  if(user.getLogintype().equals("1")){
              if(mouldid==0 || (!department.equals("0")&&!department.equals(""))){
              %>
              
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>
              <input id="PrjDept" class="wuiBrowser" type="hidden" name="department" value="<%=department%>"
              	_displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>"
              	_displayTemplate="<a href='/hrm/company/HrmDepartmentDsp.jsp?id=#b{id}'>#b{name}</a>"
              	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp">
             </TD>
	        </TR>
            <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
                 <%}}%>  
	        
	        <%if(mouldid==0||!startdate.equals("")||!startdateto.equals("")||!enddate.equals("")||!enddateto.equals("")){%>
	        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
          <TD class=Field>
          	<button type="button"  class=Calendar id=selectstartdate onclick="getstartDate()"></BUTTON>
          	<SPAN id=startdatespan><%=startdate%></SPAN>гн
          	<button type="button"  class=Calendar id=selectstartdateTo onclick="getstartDateTo()"></BUTTON>
          	<SPAN id=startdateTospan><%=startdateto%></SPAN>
          	<input class=inputstyle type="hidden" name="startdate" value="<%=startdate%>">
          	<input class=inputstyle type="hidden" name="startdateTo" value="<%=startdateto%>">
          </TD>
	        </TR>
	        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
	        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field>
          	<button type="button"  class=Calendar id=selectenddate onclick="getendDate()"></BUTTON>
          	<SPAN id=enddatespan><%=enddate%></SPAN>гн
          	<button type="button"  class=Calendar id=selectenddateTo onclick="getendDateTo()"></BUTTON>
          	<SPAN id=enddateTospan><%=enddateto%></SPAN>
          	<input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">
          	<input class=inputstyle type="hidden" name="enddateTo" value="<%=enddateto%>">
          </TD>
	        </TR>
	        <%if(mouldid!=0){%><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR><%}%>
	        <%}%>
            
	        <%if(mouldid==0){%>
	        <TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR>
	        <TR>
                <TD><%=SystemEnv.getHtmlLabelName(17491,user.getLanguage())%>г║</TD>
                <TD class=Field><input  name="perpage" value="10" class="inputStyle"  size=2></TD>
            </TR>
            <%}%>              
         </TBODY></TABLE></TD>
          <TD align=left vAlign=top>
            </TD></TR>
        </TBODY></TABLE></TD>
         <TD style="BACKGROUND-COLOR: #e5e5e5" vAlign=top width="16%"><!-- Template -->
      <TABLE class=liststyle cellspacing=1 >
        <TBODY>
        <TR>
          <TH><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></TH></TR>
        <TR class=DataLight>
          <TD><a href="Search.jsp?mouldid=0"><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></a></TD></TR>
        <% 
        int i=0;
        
        RecordSet.executeProc("Prj_SearchMould_SelectByUserID",""+userid);
	while(RecordSet.next()){
        	if(i==0){%><TR class=DataDark><%i=1;}
        	else{%><TR class=DataLight><%i=0;}%>
          <td><a href="Search.jsp?mouldid=<%=RecordSet.getString(1)%>"><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></a></td>
        </TR>
        <%}
        if(mouldid==0){%>
        <TR style="height:1px;">
          <TD align=center style="height:0;padding:0;">
			</TD>
        </TR>
        <TR id=oTrname style="display:none">
          <TD><font color=red><%=SystemEnv.getHtmlLabelName(554,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></font></TD>
        </TR>
        <TR>
          <TD><INPUT type="text" name="mouldname" value="" class="InputStyle"></TD>
        </TR>
        <%}%>
		
        </TBODY></TABLE></TD>
 </TR></TBODY></TABLE>
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


 
 
 
 
        
<input type="hidden" name="opera">
<input type="hidden" name="mouldid" value="<%=mouldid%>">
</FORM>
<script language=javascript>
function checkNewmould(){
	if(document.resource.mouldname.value==''){
		oTrname.style.display='';
		return false;
		}
	return true;
}
function onSaveas(){
	if(checkNewmould()){
	document.resource.opera.value="insert";
	document.resource.action="SearchMouldOperation.jsp";
	document.resource.submit();
	}
}        
function onSave(){
	document.resource.opera.value="update";
	document.resource.action="SearchMouldOperation.jsp";
	document.resource.submit();
}
function onDelete(){
	if(isdel()){ 
	document.resource.opera.value="delete";
	document.resource.action="SearchMouldOperation.jsp";
	document.resource.submit();
	}
}
function formreset(){
	<%if(mouldid==0){ %>
		var v=document.getElementsByTagName("input"); 
		for(var i=0;i<v.length;i++) { 
			v[i].value=""; 	
			if(v[i].type=="checkbox") {
				v[i].checked = false;
			}
		
		} 
		
		var n=document.getElementsByTagName("span"); 
		for(var i=0;i<n.length;i++) { 
			if(n[i].id == "BacoTitle"){ continue;}
			n[i].innerText=""; 		
		} 
	
		if(document.getElementById("nameopt")!=null){
			document.getElementById("nameopt").value="0";
		}
	<%}else{%>
		resource.reset();		
		if(document.getElementById("ParentIDspan")!=null){
			document.getElementById("ParentIDspan").innerHTML="<A href='/proj/data/ViewProject.jsp?ProjID=<%=parent%>'><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(parent),user.getLanguage())%></a>";
		}
		if(document.getElementById("PrjManagerspan")!=null){
			document.getElementById("PrjManagerspan").innerHTML="<a href='/hrm/resource/HrmResource.jsp?id=<%=manager%>'><%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%></a>"; 
		}
		if(document.getElementById("customerspan")!=null){
			document.getElementById("customerspan").innerHTML="<a href='/hrm/resource/HrmResource.jsp?id=<%=customer%>'><%=Util.toScreen(ResourceComInfo.getResourcename(customer),user.getLanguage())%></a>";
		}
		if(document.getElementById("memberspan")!=null){
			document.getElementById("memberspan").innerHTML="<a href='/hrm/resource/HrmResource.jsp?id=<%=member%>'><%=Util.toScreen(ResourceComInfo.getResourcename(member),user.getLanguage())%></a>";
		}
		
		if(document.getElementById("PrjDeptspan")!=null){
			document.getElementById("PrjDeptspan").innerHTML="<a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=department%>'><%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%></a>";
		}
		
		if(document.getElementById("startdatespan")!=null){
			document.getElementById("startdatespan").innerHTML="<%=startdate%>";
		}
		if(document.getElementById("startdateTospan")!=null){
			document.getElementById("startdateTospan").innerHTML="<%=startdateto%>";
		}
		if(document.getElementById("enddatespan")!=null){
			document.getElementById("enddatespan").innerHTML="<%=enddate%>";
		}
		if(document.getElementById("enddateTospan")!=null){	
			document.getElementById("enddateTospan").innerHTML="<%=enddateto%>";
		}
		
	<%}%>
}
</script>
<script language=vbs>




sub onShowCustomerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	customerspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	resource.customer.value=id(0)
	else 
	customerspan.innerHtml = ""
	resource.customer.value=""
	end if
	end if
end sub

</script> 
<script language="javascript">
function submitData()
{
	if (check_form(resource,''))
		resource.submit();
}

function submitClear()
{
	btnclear_onclick();
}

</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
