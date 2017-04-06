<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />

<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String name = Util.null2String(request.getParameter("name"));
String engname = Util.null2String(request.getParameter("engname"));
String type = Util.null2String(request.getParameter("type"));
String city = Util.null2String(request.getParameter("City"));
String customerSector = Util.null2String(request.getParameter("CustomerSector"));
String country1 = Util.null2String(request.getParameter("country1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = ","+Util.null2String(request.getParameter("resourceids"))+",";
String resourceids ="";
String resourcenames ="";
String resourcemobilenames ="";

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

//String strtmp = "select id,name from CRM_CustomerInfo ";
//String strtmp = "select t3.id,t1.name,t3.jobtitle,t3.fullname,t3.mobilephone from CRM_Customerinfo t1,CRM_CustomerContacter t3 where t1.id = t3.customerid order by t3.id,name ";
String strtmp = "select distinct t3.id,t1.name,t3.jobtitle,t3.fullname,t3.mobilephone  from CRM_CustomerInfo  t1,"+leftjointable+" t2,CRM_CustomerContacter t3  where t1.deleted<>1 and t1.id = t2.relateditemid and t3.customerid=t1.id ";
if(!name.equals("")) strtmp+=" and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%'";
if(!engname.equals("")) strtmp+=" and t1.engname like '%" + Util.fromScreen2(engname,user.getLanguage()) +"%'";
if(!type.equals("")) strtmp+=" and t1.type = '"+ type +"'";
if(!city.equals("")) strtmp+=" and t1.city = '" + city +"'";
if(!customerSector.equals("")) strtmp+=" and t1.Sector = '" + customerSector +"'";
if(!country1.equals("")) strtmp+=" and t1.country = '"+ country1+"'";
if(!departmentid.equals("")) strtmp+=" and t1.department ='" + departmentid +"'";
strtmp+=" order by t3.id desc";
String allids = "";
String allnames = "";
String allmobiles = "";
StringBuffer sb = new StringBuffer(1024);
StringBuffer sb2 = new StringBuffer(1024);
StringBuffer sb3 = new StringBuffer(1024);
//System.out.println("=============strtmp:"+strtmp);
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
    sb.append(",");
    sb.append(RecordSet.getString("id"));
    sb2.append(",");
    sb2.append(RecordSet.getString("fullname"));
    sb3.append(",");
    sb3.append(RecordSet.getString("mobilephone"));
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){
		 	resourceids +="," + RecordSet.getString("id");
		 	resourcenames += ","+RecordSet.getString("fullname");
            resourcemobilenames += ","+RecordSet.getString("mobilephone");
	}
}
    allids = sb.toString();
    allnames = sb2.toString();
    allmobiles = sb3.toString();
//if(!"".equals(allids)){
//    allnames = allnames.substring(1);
//    allids = allids.substring(1);
//    allmobiles = allmobiles.substring(1);
//}
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
if(!customerSector.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.Sector = " + customerSector ;
	}
	else
		sqlwhere += " and t1.Sector = " + customerSector ;
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

sqlstr = "select t1.id, t1.name, t1.type, t1.city, t1.country  from CRM_CustomerInfo as t1,  CRM_ShareInfo as t2,  HrmRoleMembers as t3 "+ sqlwhere;

sqlstr += " and  ((t1.id=t2.relateditemid) and ( (t2.foralluser=1 and t2.seclevel<="+userSeclevel+") or ( t2.userid="+userID+" ) or (t2.departmentid="+userDepartmentID+" and t2.seclevel<="+userSeclevel+") or (t3.resourceid="+userID+" and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and ( (t2.rolelevel=0 and t1.department="+userDepartmentID+") or (t2.rolelevel=1 and t1.subcompanyid1="+userSubcompanyid1+")  or (t3.rolelevel=2) ) ) ) ) ";

sqlstr += " UNION ";

sqlstr += " select t1.id, t1.name, t1.type, t1.city, t1.country  from CRM_CustomerInfo as t1,  HrmRoleMembers as t3,  HrmResource as t4 "+ sqlwhere;

sqlstr += " and (t1.manager="+userID+" or t1.agent="+userID+"  or  (t4.managerid="+userID+" and t4.id=t1.manager)  or 		(t3.resourceid="+userID+" and t3.roleid=8 and ( (t3.rolelevel=0 and t1.department="+userDepartmentID+") or (t3.rolelevel=1 and t1.subcompanyid1="+userSubcompanyid1+") or (t3.rolelevel=2))))" ;
*/
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int perpage=Util.getIntValue(request.getParameter("perpage"),0);
int	perpage=50;
//添加判断权限的内容--new


String temptable = "crmtemptable"+ Util.getRandom() ;
String CRM_SearchSql = "";
String temptable1 = "";
if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
		temptable1 =" (select * from (select distinct t3.id,t1.name,t3.jobtitle,t3.fullname,t3.mobilephone  from CRM_CustomerInfo  t1, "+leftjointable+" t2, CRM_CustomerContacter t3  "+ sqlwhere +" and t1.id = t2.relateditemid and t3.customerid=t1.id and t1.deleted <>1 order by t3.id desc) where rownum<"+ (pagenum*perpage+2)+") s ";
	}else{
	temptable1 = " (select * from(select t3.id,t1.name,t3.jobtitle,t3.fullname,t3.mobilephone  from CRM_CustomerInfo  t1,CRM_CustomerContacter t3   "+ sqlwhere +" and t1.deleted <>1 and t3.customerid=t1.id  and t1.agent="+user.getUID() + " order by t3.id  desc) where rownum<"+ (pagenum*perpage+2)+") s ";
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
		temptable1 = "(select distinct t3.id,t1.name,t3.jobtitle,t3.fullname,t3.mobilephone  from CRM_CustomerInfo  t1, "+leftjointable+" t2, CRM_CustomerContacter t3  "+ sqlwhere +" and t1.id = t2.relateditemid and t3.customerid=t1.id and t1.deleted <>1 order by t3.id desc   fetch first "+(pagenum*perpage+1)+"  rows only) s";
    }else{
		temptable1 = "(select t3.id,t1.name,t3.jobtitle,t3.fullname,t3.mobilephone  from CRM_CustomerInfo  t1,CRM_CustomerContacter t3   "+ sqlwhere +" and t1.deleted <>1 and t3.customerid=t1.id  and t1.agent="+user.getUID() + " order by t3.id  desc   fetch first "+(pagenum*perpage+1)+"  rows only) s";
    }
}else{
	if(user.getLogintype().equals("1")){
		temptable1 = "(select distinct top "+(pagenum*perpage+1)+" t3.id,t1.name,t3.jobtitle,t3.fullname,t3.mobilephone from CRM_CustomerInfo  t1, "+leftjointable+" t2, CRM_CustomerContacter t3  "+ sqlwhere +" and t1.id = t2.relateditemid and t3.customerid=t1.id and t1.deleted <>1 order by t3.id desc )as s";
	}else{
		temptable1 = "(select distinct top "+(pagenum*perpage+1)+" t3.id,t1.name,t3.jobtitle,t3.fullname,t3.mobilephone from CRM_CustomerInfo  t1,CRM_CustomerContacter t3  "+ sqlwhere +" and t1.deleted <>1 and t3.customerid=t1.id  and t1.agent="+user.getUID() + " order by t3.id desc )as s";
	}
}

//添加判断权限的内容--new*/
//RecordSet.executeSql(CRM_SearchSql);
//System.out.println("temptable1====="+temptable1);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable1);
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
	sqltemp="select * from (select * from  "+temptable1+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable1+"  order by id";
}
//System.out.println("sqltemp====="+sqltemp);
RecordSet.executeSql(sqltemp);

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(pagenum>1){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:prePage(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

if(hasNextPage){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:nextPage(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

%>

			<table align=right style="display:none">
			<tr>
			   <td>&nbsp;</td>
			   <td>
				   <%if(pagenum>1){%>
						<button type=button class=btn accessKey=P onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage()) %></button>
				   <%}%>
			   </td>
			   <td>
				   <%if(hasNextPage){%>
						<button type=button class=btn accessKey=N onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage()) %></button>
				   <%}%>
			   </td>
			   <td>&nbsp;</td>
			</tr>
			</table>
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

			<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/sms/MutiCustomerBrowser_sms.jsp" method=post>
			  <input type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
			  <input type="hidden" name="pagenum" value=''>
				<input type="hidden" name="resourceids" value="">
			<table width=100% class=ViewForm>
			<TR>
			<TD width=15%><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
			<TD width=35% class=field><input name=name value="<%=name%>" class=InputStyle></TD>
			<TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
				  <TD width=35% class=field>
					<input name=engname value="<%=engname%>" class=InputStyle>
				  </TD>
			</TR>
			<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
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
				   
						  <INPUT class="wuiBrowser" id=CityCode type=hidden name="City" value="<%=city%>"
						  _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
						  _displayText="<%=CityComInfo.getCityname(city)%>">
				  </TD>
			</tr>
			<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
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
					<select class=InputStyle id=departmentid name=departmentid>
					<option value=""></option>
					<% while(DepartmentComInfo.next()) {
						String tmpdepartmentid = DepartmentComInfo.getDepartmentid() ;
					%>
					  <option value=<%=tmpdepartmentid%> <% if(tmpdepartmentid.equals(departmentid)) {%>selected<%}%>>
					  <%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></option>
					<% } %>
					</select>
				  </TD>
			</tr>
			<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
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
			</tr>
			<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
			<%}%>
			<TR>
			<TD width=15%><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TD>
			<TD width=35% class=field colSpan=3>
			  
              <INPUT class="wuiBrowser" type=hidden name="CustomerSector" value="<%=customerSector%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
			  _displayText="<%=SectorInfoComInfo.getSectorInfoname(customerSector)%>">
			</TD>
			</TR>			
			<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
			</table>
			<BR>
            <input type="checkbox" onclick="onAllSelect(this)"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>
			<TABLE ID=BrowseTable class=BroswerStyle cellspacing="1" width="100%">
			<TR class=DataHeader>
			<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
			 <TH width=5%></TH>
				  <TH><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></TH>
				  <TH><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TH>
				  <TH><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%></TH>
			</TR>
			
			<%

			int i=0;
			int totalline=1;


			if(RecordSet.last()){
				do{
				String ids = RecordSet.getString("id");
				String mobilenames =RecordSet.getString("mobilephone");;
				String names = RecordSet.getString("name");;
				String fullnames = RecordSet.getString("fullname");;

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
				<TD><input type=checkbox name="check_per" value="<%=ids%>" <%=ischecked%>></TD>
				<td> <%=names%></TD>
				<TD><%=fullnames%>
				</TD>
				<TD><%=mobilenames%></TD>
			</TR>
			<%
				if(hasNextPage){
					totalline+=1;
					if(totalline>perpage)	break;
				}
			}while(RecordSet.previous());
			}

			//RecordSet.executeSql("drop table "+temptable);

			%>
			</TABLE>

			</FORM>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>

</table>

</BODY>
</HTML>


<SCRIPT LANGUAGE=VBS>
sub onShowCityID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	cityidspan.innerHtml = id(1)
	SearchForm.City.value=id(0)
	else
	cityidspan.innerHtml = ""
	SearchForm.City.value=""
	end if
	end if
end sub

sub onShowSectorID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Sectorspan.innerHtml = id(1)
	SearchForm.CustomerSector.value=id(0)
	else
	Sectorspan.innerHtml = ""
	SearchForm.CustomerSector.value=""
	end if
	end if
end sub
</SCRIPT>

<script language="javascript">
resourceids = "<%=resourceids%>"
resourcenames = "<%=resourcenames%>"
mobilephones = "<%=resourcemobilenames%>"
allids = "<%=allids%>"
allnames = "<%=allnames%>"
allmobiles = "<%=allmobiles%>"

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){

		var obj = $(this).find("input[name=check_per]");
		tagName = event.srcElement?event.srcElement.tagName: event.target.tagName;
		if(tagName=="TD"){
		   	if (obj.attr("checked")==true){
		   		obj.attr("checked",false);
		   	}else{
		   		obj.attr("checked",true);
		   	}
	   	}
	   	resourceids="";
	   	resourcenames="";
	   	mobilephones="";
	   	jQuery("#BrowseTable").find("input:checked").each(function(){
	   	    var tr=jQuery(this).parents("tr:first");
	   	    resourceids = resourceids + "," + tr.find("td:first").text();
		   	resourcenames = resourcenames + "," + tr.find("td:eq(3)").text();
		   	mobilephones = mobilephones + "," + tr.find("td:eq(4)").text();
	   	});
	  })
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			jQuery(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			jQuery(this).removeClass("Selected")
		})

})

function btnok_onclick(){
     window.parent.parent.returnValue = {id:resourceids,name:resourcenames,mobile:mobilephones};//Array(resourceids,resourcenames,mobilephones)
     window.parent.parent.close();
}

function btnsub_onclick(){
    jQuery("input[name=resourceids]").val(resourceids);
    document.SearchForm.submit();
}

function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:"",mobile:""};//Array("","","")
     window.parent.parent.close();
}

function onClear()
{
	btnclear_onclick() ;
}
function doSubmit()
{
	btnok_onclick();
}
function onSubmit()
{
	btnsub_onclick();
}
function onClose()
{
	window.parent.close() ;
}
function nextPage(){
    jQuery("input[name=pagenum]").val(<%=pagenum+1%>);
    onSubmit();
}

function prePage(){
    jQuery("input[name=pagenum]").val(<%=pagenum-1%>);
    onSubmit();
}
function onAllSelect(obj){
	//alert(jQuery(obj).attr("checked")==true)
    if(jQuery(obj).attr("checked")==true){
        resourceids = allids;
        resourcenames = allnames;
        mobilephones= allmobiles;
		if(allids!=""){
        for(i=0; i<jQuery("input[name=check_per]").length;i++){
            jQuery(document.all("check_per")[i]).attr("checked",true);
			}
		}
    }else{
    	resourceids = "";
    	resourcenames = "";
    	mobilephones = "";
		if(allids!=""){
        for(i=0; i<jQuery("input[name=check_per]").length;i++){
        	jQuery(document.all("check_per")[i]).attr("checked",false);
			}
		}
    }

}
</script>