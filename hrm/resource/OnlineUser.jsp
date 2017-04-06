<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="AccountType" class="weaver.general.AccountType" scope="page" />
<jsp:useBean id="LicenseCheckLogin" class="weaver.login.LicenseCheckLogin" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<style>
 .checkbox{display:none}
</style>
</head>
<%

String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(20536,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();
String departmentid_para = Util.null2String(request.getParameter("departmentid")) ;
String subcompanyid_para=Util.null2String(request.getParameter("subcompanyid1"));//分部
if("0".equals(subcompanyid_para)) subcompanyid_para = "";
String chkSubCompany=Util.null2o(request.getParameter("chkSubCompany"));//子分部是否包含
String uworkcode=Util.null2String(request.getParameter("uworkcode"));//编号
String uname=Util.null2String(request.getParameter("uname"));//姓名
String utel=Util.null2String(request.getParameter("utel"));//电话
String umobile=Util.null2String(request.getParameter("umobile"));//移动电话
String uemail=Util.null2String(request.getParameter("uemail"));//电子邮件
	
String sql = "select * from hrmresource where 1=1";
if(!departmentid_para.equals(""))
    sql+=" and departmentid="+departmentid_para;
//分部
if(!subcompanyid_para.equals("")) {
	String subcomstr = "";
	if ("1".equals(chkSubCompany)) {
		subcomstr = SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid_para);
	}
	if (!"".equals(subcomstr)) {
		subcomstr += subcompanyid_para;
		sql+=" and subcompanyid1 in ("+ subcomstr + ")";
	} else {
		sql+=" and subcompanyid1="+subcompanyid_para;
	}
}
//编号
if(!uworkcode.equals("")) sql+=" and workcode like '%"+ uworkcode + "%'";
//姓名
if(!uname.equals("")) sql+=" and lastname like '%"+ uname + "%'";
//电话
if(!utel.equals("")) sql+=" and telephone like '%"+ utel + "%'";
//移动电话
if(!umobile.equals("")) sql+=" and mobile like '%"+ umobile + "%'";
//电子邮件
if(!uemail.equals("")) sql+=" and email like '%"+ uemail + "%'";
sql+=" order by lastname";
RecordSet.executeSql(sql);
    //System.out.println(sql);
ArrayList onlineuserids = (ArrayList)staticobj.getObject("onlineuserids") ;

LicenseCheckLogin.checkOnlineUser();//检测用户在线情况
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onReSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=report name=report action=OnlineUser.jsp method=post>
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
			<TABLE class=ViewForm>
			<COLGROUP>
			  <COL width="15%">
			  <COL width="35%">
			  <COL width="15%">
			  <COL width="35%">
			  <TBODY>
              <tr>
                  <TD><%=SystemEnv.getHtmlLabelName(547,user.getLanguage()).substring(2)+SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TD>
                  <TD id=total class=Field><%=onlineuserids.size()%></TD>
					<TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
<!-- TD12390 分部 -->
					<TD class=field>
						<INPUT name=subcompanyid1 class=wuiBrowser type=hidden value="<%=subcompanyid_para%>"
						_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" _displayText="<%=SubCompanyComInfo.getSubCompanyname(subcompanyid_para)%>" _callback="makechecked()">
						<BR>
						<INPUT class='InputStyle' id='chkSubCompany' name='chkSubCompany' type='checkbox' value='<%=chkSubCompany%>'  onclick="setCheckbox(this)" <%if("1".equals(chkSubCompany)){%> checked <%}%> <%if("".equals(subcompanyid_para)){%> style="display:none"<%}%>><LABEL FOR='chkSubCompany' id='lblSubCompany' <%if("".equals(subcompanyid_para)){%> style="display:none"<%}%>><%=SystemEnv.getHtmlLabelName(18921,user.getLanguage())%></LABEL>
					</TD>
              </tr>
			  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
<!-- TD12390 部门、编号-->
					<TR>
						<TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
						<TD class=Field >
							<INPUT id=departmentid class=wuiBrowser type=hidden name=departmentid value="<%=departmentid_para%>"
							_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" _displayTemplate="<A href='/hrm/company/HrmDepartmentDsp.jsp?id=#b{id}'>#b{name}</A>" _displayText="<%=departmentComInfo.getDepartmentname(departmentid_para)%>">
						</TD>
						<TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
						<TD class=field>
							<INPUT name=uworkcode class='InputStyle' size="30" value="<%=uworkcode%>">
						</TD>
					</TR>
					<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
<!-- TD12390 姓名、电话-->
					<TR>
						<TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
						<TD class=field>
							<INPUT name=uname class='InputStyle' size="30" value="<%=uname%>">
						</TD>
						<TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
						<TD class=field>
							<INPUT name=utel class='InputStyle' size="30" value="<%=utel%>">
						</TD>
					</TR>
					<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
<!-- TD12390 移动电话、电子邮件-->
					<TR>
						<TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
						<TD class=field>
							<INPUT name=umobile class='InputStyle' size="30" value="<%=umobile%>">
						</TD>
						<TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
						<TD class=field>
							<INPUT name=uemail class='InputStyle' size="30" value="<%=uemail%>">
						</TD>
					</TR>
					<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
				</TBODY>
				</TABLE>
			<TABLE class=ListStyle cellspacing=1>
				<%if(flagaccount){ %>
			  <COL width="10%">
				<% }%>
			  <COL width="10%">
			  <COL width="10%">
			  <COL width="10%">
			  <COL width="10%">
			  <COL width="15%">
			  <COL width="15%">	
              <COL width="20%">
              <TBODY>
			  <TR class=Header>
				<%if(flagaccount){ %>
				  <TD><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></TD>
					<% }%>
				  <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
				  <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
				  <TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
				  <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
				  <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
				  <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
                  <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
                </TR>
				<%
				boolean islight=true;
			int total=0;


                while(RecordSet.next()){
					  String userid = Util.null2String(RecordSet.getString("id")) ;
                      if(!onlineuserids.contains(userid))
                      continue;
                      String workcode = Util.null2String(RecordSet.getString("workcode")) ;
                      String accounttype = ""+RecordSet.getInt("accounttype");
                      String accounttypename = AccountType.getAccountType(accounttype);
                      String username = Util.null2String(RecordSet.getString("lastname")) ;
					  String subcompanyid1 = Util.null2String(RecordSet.getString("subcompanyid1")) ;
					  String subcompanyid1name = SubCompanyComInfo.getSubCompanyname(subcompanyid1) ;
                      String departmentid = Util.null2String(RecordSet.getString("departmentid")) ;
                      String department = departmentComInfo.getDepartmentname(departmentid) ;
					  String telephone = Util.null2String(RecordSet.getString("telephone")) ;
					  String mobile = Util.null2String(RecordSet.getString("mobile")) ;
					  String email = Util.null2String(RecordSet.getString("email")) ;
                      total++;
                %>
		<tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
		<%if(flagaccount){ %>
		<TD noWrap><%=accounttypename%></TD>
		<%} %>
		<TD noWrap><%=workcode%></TD>
        <TD><A href="/hrm/resource/HrmResource.jsp?id=<%=userid%>" target="_blank"><%=username%></A></TD>
		<TD><A href="/hrm/company/HrmDepartment.jsp?subcompanyid=<%=subcompanyid1%>"target="_blank"><%=subcompanyid1name%></A></TD>
		<TD><A href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>" target="_blank"><%=department%></A></TD>
        <TD noWrap><%=telephone%></TD>
		<TD noWrap><%=mobile%></TD>
        <TD noWrap><%=email%></TD>
				</TR>
			<%
				islight=!islight;

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
	<td height="10" colspan="3"></td>
</tr>
</table>
<!-- 
<script language=vbs>


sub onShowDepartment(tdname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.all(inputname).value)
	if NOT isempty(id) then
	        if id(0)<> "" and id(0)<> "0" then
		document.all(tdname).innerHtml = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="&id(0)&"'>"&id(1)&"</A>"
//		document.all(tdname).innerHtml =id(1)
		document.all(inputname).value=id(0)
		else
		document.all(tdname).innerHtml = ""
		document.all(inputname).value=""
		end if
	end if
end sub

sub onShowSubCompany()
    Dim spans,span
	Set spans=document.getElementsByTagName("span")
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&report.subcompanyid1.value)
	if NOT isempty(id) then
	    if id(0)<> "" then
			subcompanyspan.innerHtml = id(1)
			report.subcompanyid1.value=id(0)
			if id(0)<> 0 then
				report.chkSubCompany.style.display=""
				document.all("lblSubCompany").style.display=""
                for Each span In spans
				  if  span.className="checkbox" then
				      span.style.display="block"
                  end if
                next 
			else
				report.chkSubCompany.style.display="none"
				document.all("lblSubCompany").style.display="none"
                for Each span In spans
				  if  span.className="checkbox" then
				      span.style.display="none"
                  end if
                next 
			end if
		else
			subcompanyspan.innerHtml = ""
			report.subcompanyid1.value=""
			report.chkSubCompany.style.display="none"
			document.all("lblSubCompany").style.display="none"
            for Each span In spans
				  if  span.className="checkbox" then
				      span.style.display="none"
                  end if
            next
		end if
	end if
end sub
</script>
 -->
 
<script type="text/javascript">
document.getElementById("total").innerHTML='<%=total%>';
function makechecked(){
   if($GetEle("subcompanyid1").value!=""){
	   $($GetEle("chkSubCompany")).css("display","");
	   $($GetEle("lblSubCompany")).css("display","");
   }else{
	   $($GetEle("chkSubCompany")).css("display","none");
	   $($GetEle("chkSubCompany")).attr("checked","");
	   $($GetEle("lblSubCompany")).css("display","none");
   }
	
}
function onReSearch(){
	report.submit();
}
function setCheckbox(chkObj) {
	if(chkObj.checked == true) {
		chkObj.value = 1;
	} else {
		chkObj.value = 0;
	}
}
</script>
</FORM>
</BODY>
</HTML>
