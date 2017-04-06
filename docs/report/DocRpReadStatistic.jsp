<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String userid =""+user.getUID();
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(19582,user.getLanguage());
String needfav ="1";
String needhelp ="";

/*不加权限*/
boolean canView = true;
if(!canView) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String isrefresh = Util.null2String(request.getParameter("isrefresh"));
String sql="";
String sqlwhere = "";
String departmentid = Util.null2String(request.getParameter("departmentid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));

/*查询条件拼装*/
if(! subcompanyid.equals("") && ! departmentid.equals("")) {
    sqlwhere += " and operateuserid in (select id from hrmresource where subcompanyid1 in(" + subcompanyid +") and departmentid=" + departmentid +")" ;
}else{
    if(! subcompanyid.equals("")) {
        sqlwhere += " and operateuserid in (select id from hrmresource where subcompanyid1 in (" + subcompanyid +"))";
    }
    if(! departmentid.equals("")) {
        sqlwhere += " and operateuserid in (select id from hrmresource where departmentid=" + departmentid +")";
    }
}

if(! resourceid.equals("")) {
	sqlwhere += " and operateuserid = " + resourceid ;
}

if(! fromdate.equals("")) {
	sqlwhere += " and operatedate >= '" + fromdate + "' " ;
}

if(! todate.equals("")) {
	sqlwhere += " and operatedate <= '" + todate + "' " ;
}

%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:location.href='DocRpReadStatistic.jsp',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=frmain action="DocRpReadStatistic.jsp?isrefresh=1" method=post>
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
		<TABLE class=Shadow style="width: 100%;">
		<tr>
		<td valign="top" >

            <!--查询条件-->
            <table class=ViewForm style="width: 100%;">
			  <colgroup>
			  <col width="10%">
			  <col width="20%">
			  <col width="10%">
			  <col width="25%">
			  <tbody> 
				<tr> 
                  <!--分部-->
				  <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
				  <td class=Field>
					<input   class=wuiBrowser  class=InputStyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>"
					_displayText="  <%
                        ArrayList subcomidlist=Util.TokenizerString(subcompanyid,",");
                        for(int i=0; i<subcomidlist.size(); i++){%>
                            <%=Util.toScreen(SubCompanyComInfo.getSubCompanyname((String)subcomidlist.get(i)),user.getLanguage())%>&nbsp;
                        <%}
                      %>"
					_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp"
					
					>
				  </td>

                  <!--人力资源-->
				  <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
				  <td class=Field>
					<input class=wuiBrowser id=resourceid type=hidden name=resourceid value="<%=resourceid%>"
					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					_displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name} </a>"
					_displayText="<A href='javaScript:openhrm(<%=resourceid%>);' onclick='pointerXY(event);'><%=ResourceComInfo.getLastname(resourceid)%></A>"
					>
				  </td>
				</tr>
				<TR style="height:2px" ><TD class=Line colSpan=4></TD></TR>

				<tr>
                  <!--部门-->
				  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
				  <td class=Field>
                   <input class=wuiBrowser id=departmentid type=hidden name=departmentid value="<%=departmentid%>" 
	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	_displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>"
	>
				  </td>

                  <!--日期--> 
				  <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
				  <td class=Field>
                    <button class=calendar type=button id=SelectDate onClick=gettheDate(fromdate,fromdatespan)></button>&nbsp; 
					<span id=fromdatespan ><%=fromdate%></span>-&nbsp;&nbsp;
                    <button type=button  class=calendar id=SelectDate2 onClick="gettheDate(todate,todatespan)"></button>&nbsp; 
                    <SPAN id=todatespan><%=todate%></span> 
					<input type="hidden" id=fromdate name="fromdate" value="<%=fromdate%>">
					<input type="hidden" id=todate name="todate" value="<%=todate%>">
				  </td>
				</tr>
				<TR style="height:2px" ><TD class=Line colSpan=4></TD></TR>
		      </tbody> 
			</table><BR>

            <!--数据表-->
            <% if(isrefresh.equals("1")){%>
			<TABLE class=ListStyle cellspacing="1">
			  <COLGROUP>
			  <COL width="20%">
			  <COL width="40%">
			  <COL width="40%">
			  <TBODY>
			  <TR class=Header>
				<TH colSpan=9><%=SystemEnv.getHtmlLabelName(19582,user.getLanguage())%></TH>
			  </TR>
			  <TR class=Header>
				<TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(19584,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(19585,user.getLanguage())%></TD>
			  </TR>
			 
			<%
            sql = " select count(id) as readcounts,count(distinct docid) as readdocs,operateuserid " +
                  " from DocDetailLog " +
                  " where operatetype=0 and usertype=1 " + sqlwhere +
                  " group by operateuserid " +
                  " order by readcounts desc";
			rs.executeSql(sql);
			
			int needchange = 0;
			double sumReadCounts = 0;
			double sumReadDocs = 0;
            while(rs.next()){
                int  id = rs.getInt("id");
                
                String	tempUserid=Util.toScreen(rs.getString("operateuserid"),user.getLanguage());
                String	tempReadCounts=Util.toScreen(rs.getString("readcounts"),user.getLanguage());
                String	tempReadDocs=Util.toScreen(rs.getString("readdocs"),user.getLanguage());
                
                if(!ResourceComInfo.getResourcename(tempUserid).equals("")){
                    sumReadCounts += Util.getDoubleValue(tempReadCounts,0);
                    sumReadDocs += Util.getDoubleValue(tempReadDocs,0);

                    if(needchange ==0){
                        needchange = 1;
                        %><TR class=datalight><%
                    }else{
                        needchange=0;%>
                        <TR class=datadark><%  	
                    }%>
                            <TD>
                                <A href="javaScript:openhrm(<%=tempUserid%>);" onclick='pointerXY(event);'>
                                    <%=Util.toScreen(ResourceComInfo.getResourcename(tempUserid),user.getLanguage())%>
                                </A>
                            </TD>
                            <TD><%=tempReadCounts%></TD>
                            <TD><%=tempReadDocs%></TD>
                        </TR>
             <%}
            }%>  

			<TR class=datadark>
				<TD><font color=red><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></font></TD>
				<TD><font color=red><%=sumReadCounts%></font></TD>
				<TD><font color=red><%=sumReadDocs%></font></TD>
			  </TR>
			 </TBODY></TABLE>

 		</td>
		</tr>
		</TABLE>
        <%}%>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</FORM>

<script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
	frmain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	frmain.resourceid.value=""
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

 sub onShowDepartmentID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmain.departmentid.value then
		issame = true 
	end if
	departmentidspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentidspan.innerHtml = ""
	frmain.departmentid.value=""
	end if
	end if
end sub
</script>

<script language="javascript">
function submitData()
{
    frmain.submit();
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>