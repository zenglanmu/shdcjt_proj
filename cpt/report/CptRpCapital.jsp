<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
String userid =""+user.getUID();
/*权限判断,资产管理员以及其所有上级
boolean canView = false;
ArrayList allCanView = new ArrayList();
String sql = "select resourceid from HrmRoleMembers where resourceid>=1 and roleid in (select roleid from SystemRightRoles where rightid=161)";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String tempid = RecordSet.getString("resourceid");
	allCanView.add(tempid);
	AllManagers.getAll(tempid);
	while(AllManagers.next()){
		allCanView.add(AllManagers.getManagerID());
	}
}// end while

for (int i=0;i<allCanView.size();i++){
	if(userid.equals((String)allCanView.get(i))){
		canView = true;
	}
}

if(!canView) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
权限判断结束*/
String rightStr= "";
if(!HrmUserVarify.checkUserRight("CptRpCapital:Display", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}else{
	rightStr="CptRpCapital:Display";
}
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(535,user.getLanguage());
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));//分部ID

if(subcompanyid1.equals("") && detachable==1)
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(21922,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}

String browserUrl="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM action=CptSearch.jsp method=post name=frmain>
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
			<TABLE border=0 cellPadding=0 cellSpacing=0 width="100%">
			<TBODY> 
			<TR> 
			<TD vAlign=top width="84%">
				<input type="hidden" name="operation">
				<input type="hidden" name="isdata" value="2">
				<TABLE class=ViewForm>
				  <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
				  <TR> 
					<TD vAlign=top style="width: 50%"> 
					  <TABLE width="100%">
						<COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 					
						<TR class=Spacing style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--编号-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
						  <td class=Field> 
							<input class=InputStyle maxlength=60 size=30 name="mark">
						  </td>
						</tr>
						<TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--名称-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
						  <td class=Field> 
							<input class=InputStyle maxlength=60 name="name" size=30>
						  </td>
						</tr>
						<TR style="height: 1px;">  
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--分部-->
						<%if(detachable == 1){%>
						<tr> 
                          <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
                          <td class=Field>
                            <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubCompanyByRightBrowser.jsp?rightStr=<%=rightStr%>&selectedids=<%=subcompanyid1%>" 
							 _displayText="<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid1))%>"
							 _trimLeftComma="yes"
							 type=hidden name=blongsubcompany id="blongsubcompany" value="<%=subcompanyid1%>">
                          </td>
						</tr>
						<%}else{%>
						<tr> 
                          <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
                          <td class=Field>
                            <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=<%=subcompanyid1%>" 
							 _trimLeftComma="yes"
							 type=hidden name=blongsubcompany id="blongsubcompany" value="<%=subcompanyid1%>">
                            <!-- 
	                            <button type="button" class=Browser id=SelectSubCompanyID onClick="onShowSubcompany('subcompanyidspan','subcompanyid')"></button> 
	                            <span id="subcompanyidspan"></span> 
	                            <input id=subcompanyid type=hidden name=subcompanyid>
                            -->
                          </td>
						</tr>
						<% }%>
						<TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                       <!--部门-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
						  <td class=Field>
						    <%
						      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
						      if(detachable==1)
						    	  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr="+rightStr;
						    %>
						    <INPUT class="wuiBrowser" _url="<%=browserUrl%>" type=hidden name=departmentid id="departmentid">
						    <!--
						    <button type="button" class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
							<span class=InputStyle id=departmentspan></span> 
							<input id=departmentid type=hidden name=departmentid>
							-->
						  </td>
						</tr>
						<TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--人力资源-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
						  <td class=Field>
						    <%
						      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
						      if(detachable==1)
						    	  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr="+rightStr;
						    %>
						    <INPUT class="wuiBrowser" _url="<%=browserUrl%>" 
							 _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
							 type=hidden name=resourceid id="resourceid">
							<!--
						    <button type="button" class=Browser id=SelectResourceID onClick="onShowResourceID()"></button> 
							<span id=resourceidspan></span> 
							<input class=InputStyle id=resourceid type=hidden name=resourceid >
							 --> 
						  </td>
						</tr>
						<TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--状态-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
						  <td class=Field> 
						    <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=search" 
							 type=hidden name=stateid id="stateid">
							  <!--
							    <button type="button" class=Browser onClick="onShowStateid()"></button> 
								<span id=stateidspan></span> 
								<input type=hidden name=stateid>
							   -->	
						  </td>
						</tr>
						<TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
						</TBODY> 
					  </TABLE>
					</TD>
					<TD vAlign=top style="width: 50%"> 
					  <TABLE width="100%">
						<COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 						
						<TR class=Spacing style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--生效日-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></td>
						  <td class=Field><button type="button"  class=Calendar id=selectstartdate onClick="getDate(startdatespan,startdate)"></button> 
							<span id=startdatespan ></span> 
							<input type="hidden" name="startdate" >
							-&nbsp;&nbsp; <button type="button" class=Calendar id=selectstartdate1 onClick="getDate(startdate1span,startdate1)"></button> 
							<span id=startdate1span ></span> 
							<input type="hidden" name="startdate1">
						  </td>
						</tr>
						<TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--生效至-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></td>
						  <td class=Field><button type="button" class=Calendar id=selectenddate onClick="getDate(enddatespan,enddate)"></button> 
							<span id=enddatespan ></span> 
							<input type="hidden" name="enddate" >
							-&nbsp;&nbsp;<button type="button" class=Calendar id=selectenddate1 onClick="getDate(enddate1span,enddate1)"></button> 
							<span id=enddate1span ></span> 
							<input type="hidden" name="enddate1">
						  </td>
						</tr>
						<TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--资产组-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
						  <td class=Field> 
						    <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp" 
							 type=hidden name=capitalgroupid id="capitalgroupid">
						   <!--
						    <button type="button" class=Browser onClick="onShowCapitalgroupid()"></button> 
							<span id=capitalgroupidspan></span> 
							<input type=hidden name=capitalgroupid>
						    -->	
						  </td>
						</tr>
						<TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--帐内或帐外-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></td>
						  <td class=Field> 
							<select class=InputStyle id=isinner name=isinner>
							  <option value=0 selected></option>
							  <option value=1 ><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%></option>
							  <option value=2 ><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%></option>
							</select>
						  </td>
						</tr>
						<TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--资产类型-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></td>
						  <td class=Field> 
						     <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp" 
							 type=hidden name=capitaltypeid id="capitaltypeid">
							 
							 <!--
						     <button type="button" class=Browser onClick="onShowCapitaltypeid()"></button> 
							 <span id=capitaltypeidspan></span> 
						     <input type=hidden name=capitaltypeid >
						      -->
						 </td>
					   </tr>
					   <TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
                        <!--入库日-->
						<tr> 
						  <td><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></td>
						  <td class=Field><button type="button" class=Calendar onClick="getDate(stockindatespan,stockindate)"></button> 
							<span id=stockindatespan ></span> 
							<input type="hidden" name="stockindate" >
							-<button class=Calendar type="button" onClick="getDate(stockindate1span,stockindate1)"></button> 
							<span id=stockindate1span ></span> 
							<input type="hidden" name="stockindate1">
						  </td>
					   </tr>
					   <TR style="height: 1px;"> 
						  <TD class=Line colSpan=2></TD>
						</TR>
						<!--tr> 
						  <td>类别</td>
						  <td class=Field> 
							<select class=InputStyle id=counttype name=counttype>
							  <option value=0 selected></option>
							  <option value=3 >库存</option>
							  <option value=1 >固定资产</option>
							  <option value=2 >低值易耗品</option>
							</select>
						  </td-->
						</tr>
						</TBODY> 
					  </TABLE>
					</TD>
				  </TR>
				  </TBODY> 
				</TABLE>
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
</FORM>
<SCRIPT language=javascript>
function onSearch(){
	document.frmain.action="../search/SearchOperation.jsp?from=report";
	frmain.submit();
}
</SCRIPT>
<SCRIPT language=VBS>
sub onShowResourceID()
	if <%=detachable%> <> 1 then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	else 
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=<%=rightStr%>")
	end if
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	frmain.resourceid.value=""
	end if
	end if
end sub

sub onShowCustomerid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	customeridspan.innerHtml = id(1)
	frmain.customerid.value=id(0)
	else
	customeridspan.innerHtml = ""
	frmain.customerid.value=""
	end if
	end if
end sub

sub onShowStateid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=search")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Stateidspan.innerHtml = id(1)
	frmain.Stateid.value=id(0)
	else
	Stateidspan.innerHtml = ""
	frmain.Stateid.value=""
	end if
	end if
end sub

sub onShowCapitalgroupid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	capitalgroupidspan.innerHtml = id(1)
	frmain.capitalgroupid.value=id(0)
	else
	capitalgroupidspan.innerHtml = ""
	frmain.capitalgroupid.value=""
	end if
	end if
end sub

sub onShowSubcompany(tdname,inputename)
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	    if id(0)<> "" then        
        resourceids = id(0)
        resourcename = id(1)
        sHtml = ""
        resourceids = Mid(resourceids,2,len(resourceids))
        resourcename = Mid(resourcename,2,len(resourcename))
        document.all(inputename).value = resourceids
        while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
           
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        document.all(tdname).innerHtml = sHtml
        <%--
        document.all(tdname).innerHtml ="<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+id(0)+"'>"+ id(1)+"</a>"
        document.all(inputename).value=id(0)
        --%>
        else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
        end if
	end if
end sub


sub onShowSubcompany1(tdname,inputename,rightStr)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubCompanyByRightBrowser.jsp?selectedids="&document.all(inputename).value&"&rightStr="&rightStr)
	if NOT isempty(id) then
	        if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		document.all(inputename).value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&curname&"&nbsp"
		wend
		sHtml = sHtml&resourcename&"&nbsp"
		document.all(tdname).innerHtml = sHtml
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowDepartment1()
	if <%=detachable%> <> 1 then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	else
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr=<%=rightStr%>&selectedids="&frmain.departmentid.value)
end if
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmain.departmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmain.departmentid.value=""
	end if
	end if
end sub

sub onShowCapitaltypeid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	capitaltypeidspan.innerHtml = id(1)
	frmain.capitaltypeid.value=id(0)
	else
	capitaltypeidspan.innerHtml = ""
	frmain.capitaltypeid.value=""
	end if
	end if
end sub
</SCRIPT>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
