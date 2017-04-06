<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.file.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdata(datasql){
    var ajax=ajaxinit();
    ajax.open("POST", "CptRpCapitalFlowData.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("datasql="+encodeURIComponent(datasql)+"&Language=<%=user.getLanguage()%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("showdatadiv").innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
</script>
</head>
<%
String userid =""+user.getUID();

/*权限判断,资产管理员以及其所有上级
boolean canView = false;
ArrayList allCanView = new ArrayList();
String tempsql = "select resourceid from HrmRoleMembers where resourceid>=1 and roleid in (select roleid from SystemRightRoles where rightid=162)";
RecordSet.executeSql(tempsql);
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
		break;
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
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));//分部ID

if(subcompanyid1.equals("") && detachable==1)
{
	String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing style='height: 1px;'><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
	if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
	else{s+=""+SystemEnv.getHtmlLabelName(21922,user.getLanguage())+"</li></TD></TR></TABLE>";}
	out.println(s);
	return;
}

String isrefresh = Util.null2String(request.getParameter("isrefresh"));

int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0);

String sql="";
String capitalgroupid=Util.null2String(request.getParameter("capitalgroupid"));
String capitalid = Util.null2String(request.getParameter("capitalid"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
System.out.println("subcompanyid============================="+subcompanyid);
String resourceid = Util.null2String(request.getParameter("resourceid"));
String status = Util.null2String(request.getParameter("status"));
String location = Util.null2String(request.getParameter("location"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));


//分页相关
//int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int perpage=Util.getIntValue(request.getParameter("perpage"),0);
//if(perpage<=1 )	perpage=10;
//
//String temptable = "cpttemptable"+ Util.getRandom() ;

if(! sqlwhere1.equals("")) {
	sql = sqlwhere1 ;
}

if(! departmentid.equals("")) {
	sql += " and t1.usedeptid = " + departmentid ;
}

if(! subcompanyid.equals("")){
	sql += " and t2.blongsubcompany in ("+subcompanyid + ")";
}

if(! resourceid.equals("")) {
	sql += " and t1.useresourceid = " + resourceid ;
}

if(! status.equals("")) {
	sql += " and t1.usestatus = " + status ;
}

if(! location.equals("")) {
	sql += " and t1.useaddress like '%" + location +"%'";
}

if(! fromdate.equals("")) {
	sql += " and t1.usedate >= '" + fromdate + "' " ;
}

if(! todate.equals("")) {
	sql += " and t1.usedate <= '" + todate + "' " ;
}

if(! capitalid.equals("")) {
	sql += " and t1.capitalid = " + capitalid ;
}

if(!capitalgroupid.equals("")){
    sql+=" and t2.capitalgroupid in ("
                 +" select id from CptCapitalAssortment where (supassortmentstr like '%|"+capitalgroupid+"|%' )"
                                                        +" or ( id = " + capitalgroupid + ")"
                 +")";
}


String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(1501,user.getLanguage());
String needfav ="1";
String needhelp ="";

String browserUrl="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:location.href='CptRpCapitalFlow.jsp?subcompanyid1="+subcompanyid1+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(isrefresh.equals("1")){
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<FORM id=weaver name=frmain action="CptRpCapitalFlow.jsp?isrefresh=1" method=post>
<input type="hidden" id=sqlwhere1 name="sqlwhere1" value="<%=sqlwhere1%>">
<input type="hidden" id=subcompanyid1 name="subcompanyid1" value="<%=subcompanyid1%>">

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
		<TABLE class=Shadow width=100>
		<tr>
		<td valign="top">

			 <table class=ViewForm >
			  <colgroup>
			  <col width="10%">
			  <col width="20%">
			  <col width="10%">
			  <col width="25%">
			  <col width="10%">
			  <col width="25%">
			  <tbody> 
				<tr> 
                  <!--资产-->
				  <td><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></td>
				  <td class=Field>
					<INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?inculdeNumZero=1" 
					 _displayText="<%=Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage())%>"
					 type=hidden name=capitalid id="capitalid" value="capitalid">
					<!--
					    <button type="button" class=Browser id=SelectCapitalID onClick="onShowCapitalID()"></button> 
					    <span id=capitalidspan><%=Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage())%></span> 
						<input class=InputStyle id=capitalid type=hidden name=capitalid value="<%=capitalid%>">
					 -->
				  </td>
				  <td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
				  <!--资产组-->
                  <td class=Field> 
				    <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp" 
					 _displayText="<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%>"
					 type=hidden name=capitalgroupid id="capitalgroupid" value="capitalgroupid">
					<!--
				    <button type="button" class=Browser onClick="onShowCapitalgroupid()"></button> 
					<span id=capitalgroupidspan><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%></span> 
					<input class=InputStyle id=capitalgroupid type=hidden name=capitalgroupid value=<%=capitalgroupid%>>
					 -->
				  </td>
                  <!--分部-->
					<%if(detachable == 0){ %>
				  <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
				  <td class=Field>
				    <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=<%=subcompanyid%>" 
					 _displayTemplate="<a href='/hrm/company/HrmSubCompanyDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>"
					 _trimLeftComma="yes" _displayText="<%=Util.toScreen(SubCompanyComInfo.getMoreSubCompanyname(subcompanyid),user.getLanguage())%>"
					 type=hidden name=subcompanyid id="subcompanyid" value="<%=subcompanyid%>">
				   <!--
				    <button type="button" class=Browser id=SelectSubCompanyID onClick="onShowSubcompany('subcompanyidspan','subcompanyid')"></button> 
					<span id=subcompanyidspan><%=Util.toScreen(SubCompanyComInfo.getMoreSubCompanyname(subcompanyid),user.getLanguage())%></span> 
					<input class=InputStyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
				   -->	
				  </td>
					<%}else{ %>
					<td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
				  <td class=Field>
				    <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubCompanyByRightBrowser.jsp?rightStr=<%=rightStr%>&selectedids=<%=subcompanyid%>" 
					 _displayTemplate="<a href='/hrm/company/HrmSubCompanyDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>"
					 _trimLeftComma="yes" _displayText="<%=Util.toScreen(SubCompanyComInfo.getMoreSubCompanyname(subcompanyid1),user.getLanguage())%>"
					 type=hidden name=subcompanyid id="subcompanyid" value="<%=subcompanyid1%>">
					<!-- 
				    <button type="button" class=Browser id=SelectSubCompanyID onClick="onShowSubcompany1('subcompanyidspan','subcompanyid','<%=rightStr%>')"></button> 
					<span id=subcompanyidspan><%=Util.toScreen(SubCompanyComInfo.getMoreSubCompanyname(subcompanyid1),user.getLanguage())%></span> 
					<input class=InputStyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid1%>">
					 -->
				  </td>
					<%} %>
				  </tr>
				  <TR style="height: 1px;"> 
						<TD class=Line colSpan=6></TD>
				  </TR>
				  <tr>
                  <!--部门-->
				  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
				  <td class=Field>
				    <%
				      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
				      if(detachable==1)
				    	  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr="+rightStr;
				    %>
				    <INPUT class="wuiBrowser" _url="<%=browserUrl%>" 
					 _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>"
					 type=hidden name=departmentid id="departmentid" value="<%=departmentid%>">
					<!--
				    <button type="button" class=Browser id=SelectDepartmentID onClick="onShowDepartmentID()"></button> 
					<span id=departmentidspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
					<input class=InputStyle id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
					 -->
				  </td>
                  <!--人力资源-->
				  <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
				  <td class=Field>
				    <%
				      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
				      if(detachable==1)
				    	  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr="+rightStr;
				    %>
				    <INPUT class="wuiBrowser" _url="<%=browserUrl%>" 
				     _displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}' target='_blank'>#b{name}</a>"
					 _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>"
					 type=hidden name=resourceid id="resourceid" value="<%=resourceid%>">
					<!-- 
				    <button type="button" class=Browser id=SelectResourceID onClick="onShowResourceID()"></button> 
					<span id=resourceidspan><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></span> 
					<input class=InputStyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
					 -->
				  </td>
                  <!--存放地点-->
				  <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
				  <td class=Field>
				  <input name=location class="InputStyle" value=<%=location%>>
				  </td>				  
				</tr>
				<TR style="height: 1px;"> 
					<TD class=Line colSpan=6></TD>
				</TR>
				<tr> 
                  <!--流转状态--> 
                  <td><%=SystemEnv.getHtmlLabelName(1380,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
				  <td class=Field>			
				     <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=flowview" 
					 _displayText="<%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(status),user.getLanguage())%>"
					 type=hidden name=status id="status" value="<%=status%>">
					 <!-- 	  
				        <button type="button" class=Browser onClick="onShowStateid()"></button> 
						<span id=stateidspan><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(status),user.getLanguage())%></span> 
						<input type=hidden name=status value="<%=status%>">
				     -->		
				  </td>
                  <!--流转日期--> 
				  <td><%=SystemEnv.getHtmlLabelName(1394,user.getLanguage())%></td>
				  <td class=Field><button type="button" class=calendar id=SelectDate onClick=gettheDate(fromdate,fromdatespan)></button>&nbsp; 
					<span id=fromdatespan ><%=fromdate%></span> 
					-&nbsp;&nbsp;<button type="button" class=calendar 
				  id=SelectDate2 onClick="gettheDate(todate,todatespan)"></button>&nbsp; <SPAN id=todatespan><%=todate%></span> 
					<input type="hidden" id=fromdate name="fromdate" value="<%=fromdate%>">
					<input type="hidden" id=todate name="todate" value="<%=todate%>">
				  </td>
				</tr>
				<TR style="height: 1px;"> 
					<TD class=Line colSpan=6></TD>
				  </TR>
				</tbody> 
			  </table><BR>
			<% if(isrefresh.equals("1")){%>
			<TABLE class=ListStyle cellspacing="1">
			  <COLGROUP>
			  <COL width="11%">
			  <COL width="13%">
			  <COL width="10%">
			  <COL width="10%">
			  <COL width="11%">
			  <COL width="11%">
			  <COL width="11%">
			  <COL width="11%">
			  <COL width="12%">
			  <TBODY>
			  <TR class=Header>
				<TH colSpan=9><%=SystemEnv.getHtmlLabelName(1501,user.getLanguage())%></TH>
			  </TR>
			 
			<%
			 ExcelSheet es = new ExcelSheet() ;
			 ExcelRow er = es.newExcelRow () ;

			 er.addStringValue(SystemEnv.getHtmlLabelName(714,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(195,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1394,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1434,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1435,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1436,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1380,user.getLanguage())+SystemEnv.getHtmlLabelName(602,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(22562,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1380,user.getLanguage())+SystemEnv.getHtmlLabelName(534,user.getLanguage())) ;

			 es.addExcelRow(er) ;

			//sql = "select top "+(pagenum*perpage+1)+" * into "+temptable+" from CptUseLog "+sql+" order by usedate desc";
			//rs.execute(sql);   
			//
			//rs.executeSql("Select count(id) RecordSetCounts from "+temptable);
			//boolean hasNextPage=false;
			//int RecordSetCounts = 0;
			//if(rs.next()){
			//	RecordSetCounts = rs.getInt("RecordSetCounts");
			//}
			//if(RecordSetCounts>pagenum*perpage){
			//	hasNextPage=true;
			//}
			//String sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by usedate";
			//rs.executeSql(sqltemp);(被下面的搜索语句代替)

			//Modify by zhouquan 得到资产管理员角色的用户的权限级别(总部2，分部1，部门0)
			
			/*
			tempsql = "select roleLevel from HrmRoleMembers where roleid = 7 and resourceid = "+userid;
            rs.executeSql(tempsql);
            
			String roleLevel = "";
            while(rs.next()){
				roleLevel = rs.getString("roleLevel");
			}

			//Modify by zhouquan 得到资产管理员角色的用户的分部，部门id
			String departmentId = "";
			String subcompanyid1 = "";

			tempsql = "select departmentid, subcompanyid1 from hrmresource  where id = "+userid;
			rs.executeSql(tempsql);
			while(rs.next()){
				departmentId = rs.getString("departmentid");
				subcompanyid1 = rs.getString("subcompanyid1");
			}
            //总部权限过滤
			if(roleLevel.equals("2")){
                if(!subcompanyid.equals("")){
			        sql += " and t2.departmentid in (select id from HrmDepartment where subcompanyid1 in ("+subcompanyid+"))";			
                }
			}
			//分部权限过滤 
			else if(roleLevel.equals("1")){
			    sql += " and t2.departmentid in (select id from HrmDepartment where subcompanyid1 = "+subcompanyid1+")";			
			}
			//部门权限过滤
			else if(roleLevel.equals("0")){
				sql+=" and t2.departmentid = "+ departmentId;	
			}
			*/
            sql = "select t1.*,t2.mark from CptUseLog t1,CptCapital t2 where t1.capitalid = t2.id"+sql+" order by t2.mark ,t1.id";
			%>
			<TR><TD colSpan=9>
				<div id="showdatadiv"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
					<script>showdata("<%=sql%>");</script>
				</div>
			</TD></TR>
			<%
			rs.executeSql(sql);
			//out.println("sql:"+sql);
			int needchange = 0;
			double usecountall = 0;
			double feeall = 0;
				while(rs.next()){
					int  id = rs.getInt("id");
					
					String	tempcapitalid=Util.toScreen(rs.getString("capitalid"),user.getLanguage());
					String	usedate=Util.toScreen(rs.getString("usedate"),user.getLanguage());
					String	olddeptid=rs.getString("olddeptid");
					String	usedeptid=rs.getString("usedeptid");
					String  useresourceid = rs.getString("useresourceid");
					String  usestatus = rs.getString("usestatus");
					String  usecount = Util.toScreen(rs.getString("usecount"),user.getLanguage());
					String  useaddress = Util.toScreen(rs.getString("useaddress"),user.getLanguage());
					String  fee = Util.toScreen(rs.getString("fee"),user.getLanguage());
					String  mark = rs.getString("mark");
					usecountall += Util.getDoubleValue(usecount,0);
					feeall += Util.getDoubleValue(fee,0);
				   try{
			
				 er = es.newExcelRow () ;
				 er.addStringValue(Util.toScreen(CapitalComInfo.getMark(tempcapitalid),user.getLanguage())) ;
				 er.addStringValue(Util.toScreen(CapitalComInfo.getCapitalname(tempcapitalid),user.getLanguage())) ;
				 er.addStringValue(usedate) ;
				 er.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(olddeptid),user.getLanguage())) ;
				 er.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(usedeptid),user.getLanguage())) ;
				 er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(useresourceid),user.getLanguage())) ;
				 er.addStringValue(CapitalStateComInfo.getCapitalStatename(usestatus)) ;
				 er.addValue(usecount) ; 
				 er.addValue(fee) ; 

				 es.addExcelRow(er) ;

			 // if(hasNextPage){
			//		totalline+=1;
			//		if(totalline>perpage)	break;
			//	 }
				  }catch(Exception e){
					System.out.println(e.toString());
				  }
				};
			// rs.executeSql("drop table "+temptable);
			%>  
			
			 </TBODY></TABLE>
			<% 
			 ExcelFile.init() ;
			 ExcelFile.setFilename(SystemEnv.getHtmlLabelName(1501,user.getLanguage())) ;
			 ExcelFile.addSheet(SystemEnv.getHtmlLabelName(1501,user.getLanguage()), es) ;
			}//end of judge if it is first in 
			%>

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
<script type="text/javascript">
function check(object){

   if(object=='undefined')  return false;
   else return true;
}
</script>
 <script language=vbs>
sub onShowCapitalgroupid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" and check(id(1)) then
	capitalgroupidspan.innerHtml = id(1)
	frmain.capitalgroupid.value=id(0)
	else
	capitalgroupidspan.innerHtml = ""
	frmain.capitalgroupid.value=""
	end if
	end if
end sub

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


 sub onShowDepartmentID()
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
	departmentidspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentidspan.innerHtml = ""
	frmain.departmentid.value=""
	end if
	end if
end sub

sub onShowStateid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=flowview")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	stateidspan.innerHtml = id(1)
	frmain.status.value=id(0)
	else
	stateidspan.innerHtml = ""
	frmain.status.value=""
	end if
	end if
end sub

sub onShowCapitalID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?inculdeNumZero=1")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	capitalidspan.innerHtml = id(1)
	frmain.capitalid.value=id(0)
	else 
	capitalidspan.innerHtml = ""
	frmain.capitalid.value=""
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