<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="session" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String lastname = Util.null2String(request.getParameter("lastname"));
String firstname = Util.null2String(request.getParameter("firstname"));
String educationlevel = Util.null2String(request.getParameter("educationlevel"));
String sex = Util.null2String(request.getParameter("sex"));
String careerid = Util.null2String(request.getParameter("careerid"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = ","+Util.null2String(request.getParameter("resourceids"))+",";
String resourceids ="";
String resourcenames ="";
String strtmp = "select id,lastname,firstname from HrmCareerApply";
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){
		 	resourceids +="," + RecordSet.getString("id");
		 	//resourcenames += ","+RecordSet.getString("firstname")+" "+RecordSet.getString("lastname");
			resourcenames += ","+RecordSet.getString("lastname");
	}
}
if(!lastname.equals("")){
	sqlwhere += " and lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
}
//if(!firstname.equals("")){
//	sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
//}
if(!educationlevel.equals("")){
	sqlwhere += " and educationlevel='"+educationlevel+"' ";
}
if(!sex.equals("")){
	sqlwhere += " and sex = '" + sex +"' ";
}
//if(!careerid.equals("")){
	//sqlwhere += " and careerid = '" + careerid +"' ";
//}
if(!jobtitle.equals("")){
	sqlwhere += " and jobtitle = '" + jobtitle +"' ";
}
String sqlstr = "select * from HrmCareerApply where 1=1 " + sqlwhere ;
String sqlstr1 = "select distinct jobtitle from HrmCareerApply ";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiCareerBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsub_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btnSearch accessKey=S id=btnsub onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:reset_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btnReset accessKey=T id=reset onclick="reset_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=O id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=C id=btnclear onclick="btnclear_onclick()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=Viewform>
<TR class=Spacing style="height: 1px">
<TD class=Line1 colspan=4></TD></TR>
<TR>
	<!--<TD width=15%><%=SystemEnv.getHtmlLabelName(461,user.getLanguage())%></TD>
	<TD width=35% class=field><input class=inputstyle name=firstname value="<%=firstname%>"></TD>-->
	<%---------------------姓名--------------------%>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
	<TD width=35% class=field><input class=inputstyle name=lastname value="<%=lastname%>"></TD>
    <%---------------------性别--------------------%>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
    <TD width=35% class=field>
	  <select class=inputstyle id=sex name=sex>
		<option value=""></option>
		<option value=0 <%if(sex.equalsIgnoreCase("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
		<option value=1 <%if(sex.equalsIgnoreCase("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
	  </select>
   </TD>
</TR>
<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR> 
<TR>
	<%---------------------应聘职位--------------------%>
	   <TD width=15%><%=SystemEnv.getHtmlLabelName(1856,user.getLanguage())%></TD>
       <TD width=35% class=field>
        <select class=inputstyle size=1 name=jobtitle>
     	  <option value="">&nbsp;</option>
     	  <%
			  //while(CareerInviteComInfo.next()){
				  //String curCareerId=CareerInviteComInfo.getCareerInviteid();
				  //String curCareerInviteName=CareerInviteComInfo.getCareerInvitename();
				RecordSet.executeSql(sqlstr1);
				while(RecordSet.next()){
					String jobTitelId = RecordSet.getString("jobtitle");
					String jobTitelName = JobTitlesComInfo.getJobTitlesname(jobTitelId);
     	  %>
     	  <option value="<%=jobTitelId%>" <%if(jobtitle.equals(jobTitelId)){%> selected <%}%>>
     	  <%=Util.toScreen(jobTitelName,user.getLanguage())%></option>
     	  <%}%>
        </select>
      </TD>
	  <%---------------------学历--------------------%>
	  <TD width=15%><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=educationlevel name=educationlevel>
				<option value=""></option>
				<%
					while(EduLevelComInfo.next()){
						String educationLevelId = EduLevelComInfo.getEducationLevelid();
						String educationLevelName = EduLevelComInfo.getEducationLevelname();
				%>
				<option value="<%=educationLevelId%>" <% if(educationlevel.equals(educationLevelId)) {%>selected<%}%>>
				<%=Util.toScreen(educationLevelName,user.getLanguage())%></option>
				<%}%>
        </select>
      </TD>
</tr>
<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR> 

<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
	 <TH width=5%></TH>  
     <TH width=20%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>      
	<TH width=15%><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TH>
      <TH width=15%><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></TH>
      <TH width=40%><%=SystemEnv.getHtmlLabelName(1856,user.getLanguage())%></TH>
</TR>
<TR class=Line style="height: 1px"><TH colspan="5" ></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String lastnames = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
	String firstnames = Util.toScreen(RecordSet.getString("firstname"),user.getLanguage());
	String educationlevels = RecordSet.getString("educationlevel");
	String sexs =RecordSet.getString("sex");
	//String careerids =RecordSet.getString("careerid");
	String jobtitle1 =RecordSet.getString("jobtitle");
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD style="display:none"><A HREF=#><%=ids%></A></TD>
	 <%
	 String ischecked = "";
	 if(check_per.indexOf(","+ids+",")!=-1){
	 	ischecked = " checked ";
	 }%>
	<TD><input class=inputstyle type=checkbox name="check_per" value="<%=ids%>" <%=ischecked%>></TD>
	<TD><%=lastnames%></TD>
	<%---------------------性别--------------------%>
	<TD><% if(sexs.equalsIgnoreCase("0")) {%>
            <%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%> 
            <%} if(sexs.equalsIgnoreCase("1")) {%>
            <%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%> 
            <%}%>
	</TD>
	<%---------------------学历--------------------%>
	<TD>
           <%
			while(EduLevelComInfo.next()){
				String educationLevelId = EduLevelComInfo.getEducationLevelid();
				String educationLevelName = EduLevelComInfo.getEducationLevelname();
		   %>
				<% if(educationlevels.equals(educationLevelId)) {%>
				<%=Util.toScreen(educationLevelName,user.getLanguage())%>
				<%}%>
		   <%}%>
	</TD>
	<%---------------------应聘职位--------------------%>
	<TD><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle1),user.getLanguage())%></TD>
</TR>
<%}
%>

</TABLE>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input class=inputstyle type="hidden" name="resourceids" value="">
</FORM>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript">
var resourceids = "<%=resourceids%>"
var resourcenames = "<%=resourcenames%>"

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		//alert(event.target.tagName)
		//if(event.target.tagName=="INPUT"){
		//	return;
		//}
		
		var obj = $(this).find("input[name=check_per]");
		if(event.target.tagName=="INPUT"){
			if(obj.attr("checked")== true){
				obj.attr("checked",true);
				resourceids = resourceids + "," + $(this).find("td:first").text();
				resourcenames = resourcenames + "," + $(this).find("td:eq(2)").text();
			}else{
				obj.attr("checked",false);
				resourceids = resourceids.replace(","+$(this).find("td:first").text(),"");
				resourcenames = resourcenames.replace(","+$(this).find("td:eq(2)").text(),"")
			}
		}else{
			if(obj.attr("checked")==true){
				obj.attr("checked",false);
				resourceids = resourceids.replace(","+$(this).find("td:first").text(),"");
				resourcenames = resourcenames.replace(","+$(this).find("td:eq(2)").text(),"")
			}else{
				obj.attr("checked",true);
				resourceids = resourceids + "," + $(this).find("td:first").text();
				resourcenames = resourcenames + "," + $(this).find("td:eq(2)").text();
			}
		}
		event.stopPropagation();
		//return false;
		return true;  //ypc 2012-09-04 修改
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})

//function btnclear_onclick(){
     //window.parent.returnValue ={id:"",name:""}
     //window.parent.close();
//}
//function btnok_onclick(){
	//window.parent.returnValue = {id:resourceids,name:resourcenames};
	//window.parent.close();
//}


//2012-08-16 ypc 修改
//确定 选中的值 
function btnok_onclick(){
	//2012-08-21 ypc 修改
	//window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
	window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
	window.parent.parent.close();
}
//清空选中的值
function btnclear_onclick(){
     window.parent.parent.returnValue ={id:"",name:""};
     window.parent.parent.close();
}

function btnsub_onclick(){
	document.SearchForm.resourceids.value = resourceids
	document.SearchForm.submit();
}

function reset_onclick(){
	document.SearchForm.lastname.value=""
	document.SearchForm.sex.value=""
	document.SearchForm.jobtitle.value=""
	document.SearchForm.educationlevel.value=""
}
</script>
</BODY>
</HTML>