<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<HTML><HEAD>

<style type="text/css">
#departmentid, #country1 {
	width:100%;
}
</style>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String name = Util.null2String(request.getParameter("name"));
String engname = Util.null2String(request.getParameter("engname"));
String type = Util.null2String(request.getParameter("type"));
String city = Util.null2String(request.getParameter("City"));
String country1 = Util.null2String(request.getParameter("country1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));
String crmManager = Util.null2String(request.getParameter("crmManager"));
String sectorInfo = Util.null2String(request.getParameter("sectorInfo"));
String customerStatus = Util.null2String(request.getParameter("customerStatus"));
String customerDesc = Util.null2String(request.getParameter("customerDesc"));
String customerSize = Util.null2String(request.getParameter("customerSize"));

String customerStatusName = CustomerStatusComInfo.getCustomerStatusname(customerStatus);

String customerDescName = Util.null2String(CustomerDescComInfo.getCustomerDescname(customerDesc));
String customerSizeName = Util.null2String(CustomerSizeComInfo.getCustomerSizename(customerSize));
String sectorInfoName = Util.null2String(SectorInfoComInfo.getSectorInfoname(sectorInfo));

String resourceids ="";
String resourcenames ="";

if (!check_per.equals("")) {
	if(check_per.indexOf(',')==0){
		check_per=check_per.substring(1);
	}
	String strtmp = "select id,name from CRM_CustomerInfo  where id in ("+check_per+")";

	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("name")));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}
	try{
		
		StringTokenizer st = new StringTokenizer(check_per,",");
	
		while(st.hasMoreTokens()){
			String s = st.nextToken();
			if(ht.containsKey(s)){//如果check_per中的已选的客户此时不存在会出错TD1612
				resourceids +=","+s;
				resourcenames += ","+ht.get(s).toString();
			}
		}
	}catch(Exception e){
		resourceids ="";
		resourcenames ="";
	}
}

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}
if(!engname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.engname like '%" + Util.fromScreen2(engname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and t1.engname like '%" + Util.fromScreen2(engname,user.getLanguage()) +"%' ";
}
if(!type.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.type = "+ type ;
	}
	else
		sqlwhere += " and t1.type = "+ type;
}
if(!city.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.city = " + city ;
	}
	else
		sqlwhere += " and t1.city = " + city ;
}
if(!country1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.country = "+ country1 ;
	}
	else
		sqlwhere += " and t1.country = "+ country1;
}
if(!departmentid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.department =" + departmentid +" " ;
	}
	else
		sqlwhere += " and t1.department =" + departmentid +" " ;
}
if(!crmManager.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.manager =" + crmManager +" " ;
	}
	else
		sqlwhere += " and t1.manager =" + crmManager +" " ;
}
if(!sectorInfo.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.sector = "+ sectorInfo ;
	}
	else
		sqlwhere += " and t1.sector = "+ sectorInfo;
}
if(!customerStatus.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.status = "+ customerStatus ;
	}
	else
		sqlwhere += " and t1.status = "+ customerStatus;
}
if(!customerDesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.description = "+ customerDesc ;
	}
	else
		sqlwhere += " and t1.description = "+ customerDesc;
}
if(!customerSize.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.size_n = "+ customerSize ;
	}
	else
		sqlwhere += " and t1.size_n = "+ customerSize;
}

String sqlstr = "";
if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.id != 0 " ;
}
/*
String userID = ""+user.getUID();
String userDepartmentID = ""+user.getUserDepartment();
String userSeclevel = ""+user.getSeclevel();
String userSubcompanyid1 = ""+user.getUserSubCompany1();

sqlstr = "select t1.id, t1.name, t1.type, t1.city, t1.country,t1.size_n,t1.description,t1.status,t1.sector from CRM_CustomerInfo as t1,  CRM_ShareInfo as t2,  HrmRoleMembers as t3 "+ sqlwhere;

sqlstr += " and  ((t1.id=t2.relateditemid) and ( (t2.foralluser=1 and t2.seclevel<="+userSeclevel+") or ( t2.userid="+userID+" ) or (t2.departmentid="+userDepartmentID+" and t2.seclevel<="+userSeclevel+") or (t3.resourceid="+userID+" and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and ( (t2.rolelevel=0 and t1.department="+userDepartmentID+") or (t2.rolelevel=1 and t1.subcompanyid1="+userSubcompanyid1+")  or (t3.rolelevel=2) ) ) ) ) ";

sqlstr += " UNION ";

sqlstr += " select t1.id, t1.name, t1.type, t1.city, t1.country,t1.size_n,t1.description,t1.status,t1.sector  from CRM_CustomerInfo as t1,  HrmRoleMembers as t3,  HrmResource as t4 "+ sqlwhere;

sqlstr += " and (t1.manager="+userID+" or t1.agent="+userID+"  or  (t4.managerid="+userID+" and t4.id=t1.manager)  or 		(t3.resourceid="+userID+" and t3.roleid=8 and ( (t3.rolelevel=0 and t1.department="+userDepartmentID+") or (t3.rolelevel=1 and t1.subcompanyid1="+userSubcompanyid1+") or (t3.rolelevel=2))))" ;
*/
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int perpage=Util.getIntValue(request.getParameter("perpage"),0);
int	perpage=30;
//添加判断权限的内容--new


String temptable = "crmtemptable"+ Util.getRandom() ;
String CRM_SearchSql = "";
String temptable1="";
//String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String leftjointable = CrmShareBase.getTempTableByBrowser(""+user.getUID());
/*
if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
		//CRM_SearchSql = "create table "+temptable+"  as select * from (select distinct  t1.* from CRM_CustomerInfo  t1,CrmShareDetail  t2  "+ sqlwhere +" and t1.deleted<>1 and t1.id = t2.crmid and t2.usertype=1 and t2.userid="+user.getUID() + " order by t1.id desc) where rownum<"+ (pagenum*perpage+2);
	    temptable1=" ( select * from (select distinct  t1.* from CRM_CustomerInfo  t1,"+leftjointable+"  t2  "+ sqlwhere +" and t1.deleted<>1 and t1.id = t2.relateditemid order by t1.id desc) where rownum<"+ (pagenum*perpage+2)+") s ";
	     
	}else{
		//CRM_SearchSql = "create table "+temptable+"  as select * from (select distinct  t1.* from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id  desc) where rownum<"+ (pagenum*perpage+2);
	    temptable1=" ( select * from (select distinct  t1.* from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id  desc) where rownum<"+ (pagenum*perpage+2)+") s ";
	    
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
		//CRM_SearchSql = "create table "+temptable+"  as (select distinct  t1.* from CRM_CustomerInfo  t1,CrmShareDetail  t2 ) definition only";
        //RecordSet.executeSql(CRM_SearchSql);
        //CRM_SearchSql = "insert into "+temptable+" (select distinct  t1.* from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id  desc fetch first "+(pagenum*perpage+1)+"  rows only)";
        temptable1=" (select distinct  t1.* from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id  desc fetch first "+(pagenum*perpage+1)+"  rows only) s ";        
    }else{
		//CRM_SearchSql = "create table "+temptable+"  as (select distinct  t1.* from CRM_CustomerInfo  t1) definition only";
        //RecordSet.executeSql(CRM_SearchSql);
        //CRM_SearchSql = "insert into "+temptable+" (select distinct  t1.* from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id  desc fetch first "+(pagenum*perpage+1)+"  rows only)";
        temptable1=" (select distinct  t1.* from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id  desc fetch first "+(pagenum*perpage+1)+"  rows only) s ";
    }
}else{
	if(user.getLogintype().equals("1")){
		//CRM_SearchSql = "select distinct top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from CRM_CustomerInfo  t1,CrmShareDetail  t2  "+ sqlwhere +" and t1.deleted<>1 and t1.id = t2.crmid and t2.usertype=1 and t2.userid="+user.getUID() + " order by t1.id desc";  
	    temptable1= " (select distinct top "+(pagenum*perpage+1)+" t1.*  from CRM_CustomerInfo  t1,"+leftjointable+"  t2  "+ sqlwhere +" and t1.deleted<>1 and t1.id = t2.relateditemid order by t1.id desc ) as s ";  
	}else{
		//CRM_SearchSql = "select distinct top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id desc";  
	    temptable1=" (select distinct top "+(pagenum*perpage+1)+" t1.*  from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.deleted<>1 and t1.agent="+user.getUID() + " order by t1.id desc) as s ";  	    
	}
}
*/
//添加判断权限的内容--new*/
//RecordSet.executeSql(CRM_SearchSql);
//RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable1);
if(user.getLogintype().equals("1")){
   temptable1="  CRM_CustomerInfo t1 "+sqlwhere+" and t1.deleted<>1 and "+leftjointable;
}else{
   temptable1="  CRM_CustomerInfo t1 "+sqlwhere+" and t1.deleted<>1 and t1.agent="+user.getUID();
}
 RecordSet.executeSql("select count(*) RecordSetCounts from "+temptable1);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
String sqltemp="";
int iTotal =RecordSetCounts;
int iNextNum = pagenum * perpage;
int ipageset = perpage;
if(iTotal - iNextNum + perpage < perpage) ipageset = iTotal - iNextNum + perpage;
if(iTotal < perpage) ipageset = iTotal;

if(RecordSet.getDBType().equals("oracle")){
	//sqltemp="select * from (select * from  "+temptable1+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
	sqltemp=  "select t1.id,t1.name,t1.engname,t1.type,t1.city,t1.country,t1.department from "+temptable1+" order by t1.id desc";
	sqltemp = "select t2.*,rownum rn from (" + sqltemp + ") t2 where rownum <= " + iNextNum;
	sqltemp = "select t3.* from (" + sqltemp + ") t3 where rn > " + (iNextNum - perpage);
}else{
	//sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable1+"  order by id";
	sqltemp="select top "+iNextNum+" t1.id,t1.name,t1.engname,t1.type,t1.city,t1.country,t1.department from "+temptable1+" order by t1.id desc";
	sqltemp = "select top " + ipageset +" t2.* from (" + sqltemp + ") t2 order by t2.id asc";
	sqltemp = "select top " + ipageset +" t3.* from (" + sqltemp + ") t3 order by t3.id desc";
}
RecordSet.executeSql(sqltemp);
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	
	<td valign="top">
		<!--########Shadow Table Start########-->
<TABLE class=Shadow>
		<tr>
		<td valign="top" colspan="2">

		<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MutiCustomerBrowser.jsp" method=post>
		<input type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="resourceids" value="">
		<input type="hidden" name="crmManager" value="<%=crmManager%>">
		<!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=O id=btnok onclick="btnok_onclick(event)"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=2 id=btnclear onclick="btnclear_onclick(event);"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
		<!--##############Right click context menu buttons END//####################-->
		<!--######## Search Table Start########-->
<table width=100% class=ViewForm valign="top">
	<TR class=Spacing style="height:1px;"><TD class=Line1 colspan=4></TD></TR>
	<TR>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
		<TD width=35% class=field><input class=InputStyle  name=name value="<%=name%>"></TD>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
		<TD width=35% class=field>
			<input class=InputStyle  name=engname value="<%=engname%>">
		</TD>
	</TR>

	<TR>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
		<TD width=35% class=field>
			<select class=InputStyle id=type name=type>
			<option value=""></option>
			<%if(!Util.null2String(request.getParameter("sqlwhere")).equals("where t1.type in (3,4)")){%>
					<%
					while(CustomerTypeComInfo.next()){
					%>		  
					  <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>" <%if(type.equalsIgnoreCase(CustomerTypeComInfo.getCustomerTypeid())) {%>selected<%}%>><%=CustomerTypeComInfo.getCustomerTypename()%></option>
					<%}%>
			<%}else{%>
					<%
					while(CustomerTypeComInfo.next()){
					if(CustomerTypeComInfo.getCustomerTypeid().equals("3") || CustomerTypeComInfo.getCustomerTypeid().equals("4")){
					%>		  
					  <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>" <%if(type.equalsIgnoreCase(CustomerTypeComInfo.getCustomerTypeid())) {%>selected<%}%>><%=CustomerTypeComInfo.getCustomerTypename()%></option>
					<%}}%>
			<%}%>
			</select>

		</TD>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
		<TD width=35% class=field>
		  <input class="wuiBrowser"  id=CityCode type=hidden name="City" value="<%=city%>" _displayText="<%=CityComInfo.getCityname(city)%>"
		  	_url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp">
		</TD>
	</TR>
	<tr style="height:1px;"><td class=Line colspan=4></td></tr>
<%if(!user.getLogintype().equals("2")){%>
	<tr>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
	<TD width=35% class=field>
			<select class=InputStyle id=country1 name=country1>
			<option value=""></option>
			<%
			while(CountryComInfo.next()){
			%>		  
			  <option value="<%=CountryComInfo.getCountryid()%>" <%if(country1.equalsIgnoreCase(CountryComInfo.getCountryid())) {%>selected<%}%>><%=CountryComInfo.getCountryname()%></option>
			  <%}%>
			</select>
	</td>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
		  <TD width=35% class=field>
			<select class=InputStyle style="width:150px" id=departmentid name=departmentid>
			<option value=""></option>
			<% while(DepartmentComInfo.next()) {  
				String tmpdepartmentid = DepartmentComInfo.getDepartmentid() ;
			%>
			  <option title="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%>" value=<%=tmpdepartmentid%> <% if(tmpdepartmentid.equals(departmentid)) {%>selected<%}%>>
			  <%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></option>
			<% } %>
			</select>
	</TD>
	</TR>
	<tr style="height:1px;"><td class=Line colspan=4></td></tr>
<%}else{%>
	<tr>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
	<TD width=35% class=field>
	<select class=InputStyle id=country1 name=country1>
			<option value=""></option>
			<%
			while(CountryComInfo.next()){
			%>		  
			  <option value="<%=CountryComInfo.getCountryid()%>" <%if(country1.equalsIgnoreCase(CountryComInfo.getCountryid())) {%>selected<%}%>><%=CountryComInfo.getCountryname()%></option>
			  <%}%>
			</select>
		  </td>
	<TD width=15%></TD>
		  <TD width=35% class=field>
			
		  </TD>
	</TR>
	<tr style="height:1px;"><td class=Line colspan=4></td></tr>
	<%}%>
	<tr>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
	<TD width=35% class=field>
		  <input class="wuiBrowser"  id=customerStatus type=hidden name="customerStatus" value="<%=customerStatus%>" _displayText="<%=customerStatusName%>" 
		  	_url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp">
	</td>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
	<TD width=35% class=field>
		  <input class="wuiBrowser"  id=customerDesc type=hidden name="customerDesc" value="<%=customerDesc%>"
		  	_url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp" _displayText="<%=customerDescName%>">
	
	</td>
	</tr>
	<tr  style="height:1px;"><td class=Line colspan=4></td></tr>
	<tr>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
	<TD width=35% class=field>
		  <input class="wuiBrowser"  id=customerSize type=hidden name="customerSize" value="<%=customerSize%>" 
		  		_displayText="<%=customerSizeName%>"
		  		_url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp">
	</td>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TD>
	<TD width=35% class=field>
		  <input class="wuiBrowser"  id=sectorInfo type=hidden name="sectorInfo" value="<%=sectorInfo%>" _displayText="<%=sectorInfoName%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp">
	</td>
	</tr>
	<TR class=Spacing style="height:1px;"><TD class=Line1 colspan=4></TD></TR>
</table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%" valign="top">
	<!--############Browser Table START################-->
	<TABLE class=BroswerStyle cellspacing="0" cellpadding="0" style="width:100%;">
		<TR class=DataHeader>
			<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
			<TH width="47%"><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TH>      
			<TH width="28%"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
			<TH width="27%"><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TH>
			
			  <!--<TH><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TH>-->
		</tr>

		<tr>
		<td colspan="4" width="100%" height="260px">
			<div style="overflow-y:scroll;width:100%;height:260px">
			<table width="100%" id="BrowseTable"  style="width:100%;">
				<%

				int i=0;
				int totalline=1;
				while(RecordSet.next()){
					String ids = RecordSet.getString("id");
					String names = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
					String engnames = Util.toScreen(RecordSet.getString("engname"),user.getLanguage());
					String types = RecordSet.getString("type");
					String citys = RecordSet.getString("city");
					String country1s = Util.toScreen(RecordSet.getString("country"),user.getLanguage());
					String departmentids = RecordSet.getString("department");
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
					
				<td width="50%" style="word-break:break-all"> <%=names%></TD>
				<TD width="30%" style="word-break:break-all"><%=CustomerTypeComInfo.getCustomerTypename(types)%>
				</TD>
				<TD width="25%" style="word-break:break-all"><%=CityComInfo.getCityname(citys)%></TD>
				<!--
				<TD><%=CountryComInfo.getCountryname(country1s)%></TD>
				-->
				</TR>
				<%
					if(hasNextPage){
						totalline+=1;
						if(totalline>perpage)	break;
					}
				}
				//RecordSet.executeSql("drop table "+temptable);
				%>
						</table>
						<table align=right style="display:none">
						<tr>
						   <td>&nbsp;</td>
						   <td>
							   <%if(pagenum>1){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type=submit class=btn accessKey=P id=prepage onclick="setResourceStr();$('input[name=pagenum]').val(<%=pagenum-1%>);"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>
							   <%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type=submit class=btn accessKey=N  id=nextpage onclick="setResourceStr();$('input[name=pagenum]').val(<%=pagenum+1%>);"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>&nbsp;</td>
						</tr>
						</table>
			</div>
		</td>
	</tr>
	</TABLE>
</td>
<!--##########Browser Table END//#############-->
<td width="40%" valign="top">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" width="100%">
		<tr>
			<td align="center" valign="top" width="30%">
				<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="/images/arrow_left_all.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="/images/arrow_right.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="/images/arrow_right_all.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="/images/arrow_d.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
			</td>
			<td align="center" valign="top" width="70%">
				<select size="15" name="srcList" multiple="true" style="width:100%;word-wrap:break-word" >
					
					
				</select>
			</td>
		</tr>
		
	</table>
	<!--########//Select Table End########-->

</td>
</tr>

	</FORM>

		</td>
		</tr>
		</TABLE>
		<!--##############Shadow Table END//######################-->
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>





<script type="text/javascript">
<!--
	resourceids = "<%=resourceids%>";
	resourcenames = "<%=resourcenames%>";
	function btnclear_onclick(){
	    window.parent.parent.returnValue = {id:"",name:""};
	    window.parent.parent.close();
	}


jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})


function btnok_onclick(){
	  setResourceStr();
	 window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
    window.parent.parent.close();
}

function btnsub_onclick(){
    setResourceStr();
   $("#resourceids").val(resourceids);
   document.SearchForm.submit();
}
	
function BrowseTable_onclick(e){
	var target =  e.srcElement||e.target ;
	try{
		if(target.nodeName == "TD" || target.nodeName == "A"){
			var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+jQuery.trim($($(target).parents("tr")[0].cells[1]).text()) ;
			if(!isExistEntry(newEntry,resourceArray)){
				addObjectToSelect($("select[name=srcList]")[0],newEntry);
				reloadResourceArray();
			}
		}
	}catch (en) {
		alert(en.message);
	}
}
function BrowseTable_onmouseover(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark";
      }else{
         p.className = "DataLight";
      }
   }
}
//-->
</script>
<script language="javascript">
//var resourceids = "<%=resourceids%>"
//var resourcenames = "<%=resourcenames%>"

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List
 格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	$(oOption).text(str.split("~")[1]);
	
}

function isExistEntry(entry,arrayObj){
	
	for(var i=0;i<arrayObj.length;i++){
		
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
}

function upFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
function addAllToList(){
	var table =$("#BrowseTable");
	$("#BrowseTable").find("tr").each(function(){
		var str=jQuery.trim($($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text());
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
	});
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList =$("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+jQuery.trim(destList.options[i].text) ;
	}
	//alert(resourceArray.length);
}

function setResourceStr(){
	
	resourceids ="";
	resourcenames = "";
	for(var i=0;i<resourceArray.length;i++){
		resourceids += ","+resourceArray[i].split("~")[0] ;
		resourcenames += ","+resourceArray[i].split("~")[1] ;
	}
	//alert(resourceids+"--"+resourcenames);
	$("input[name=resourceids]").val( resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
	$("input[name=resourceids]").val(resourceids.substring(1)) ;
    document.SearchForm.submit();
}
</script>
