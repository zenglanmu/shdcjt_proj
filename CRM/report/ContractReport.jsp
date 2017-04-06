<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_count" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//add by xhheng @20050128 for TD 1415
RCMenu += "{"+"Excel,javascript:ContractExport(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>

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
<%
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=10;
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
String preyield=Util.fromScreen(request.getParameter("preyield"),user.getLanguage());
String product=Util.fromScreen(request.getParameter("product"),user.getLanguage());
String preyield_1=Util.fromScreen(request.getParameter("preyield_1"),user.getLanguage());
String department=Util.fromScreen(request.getParameter("department"),user.getLanguage());
String province=Util.fromScreen(request.getParameter("province"),user.getLanguage());
String city=Util.fromScreen(request.getParameter("city"),user.getLanguage());

int sign = Util.getIntValue(request.getParameter("sign"),-1);
String conids=Util.fromScreen(request.getParameter("conids"),user.getLanguage());
int ViewType = Util.getIntValue(request.getParameter("ViewType"),0);
String parentid=Util.fromScreen(request.getParameter("parentid"),user.getLanguage());
String ProjID=Util.fromScreen(request.getParameter("ProjID"),user.getLanguage());

//out.print(sign);
String sqlwhere="";
String sqlstr ="";
String currentvalue = "";

if(sign==30){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.status >=2 ";
	else	sqlwhere+=" and t1.status >=2 ";
}
/*
if(sign!=-1){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.id  in("+conids+")";
	else	sqlwhere+=" and t1.id  in("+conids+")";
}
*/
if(!parentid.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.parentid="+parentid;
	else	sqlwhere+=" and t3.parentid="+parentid;
}
if(resource!=0){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.manager="+resource;
	else	sqlwhere+=" and t1.manager="+resource;
}
if(!fromdate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.startDate>='"+fromdate+"'";
	else 	sqlwhere+=" and t1.startDate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.startDate<='"+enddate+"'";
	else 	sqlwhere+=" and t1.startDate<='"+enddate+"'";
}

if(!customer.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.crmId="+customer;
	else	sqlwhere+=" and t1.crmId="+customer;
}

if(!status.equals("")) {
	if(sqlwhere.equals("")) sqlwhere+=" where t1.status="+status;
    else sqlwhere+=" and t1.status="+status;
}

if(!preyield.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.price>="+preyield;
	else	sqlwhere+=" and t1.price>="+preyield;
}
if(!preyield_1.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.price<="+preyield_1;
	else	sqlwhere+=" and t1.price<="+preyield_1;
}


if(!department.equals("")) {
	if(sqlwhere.equals("")) sqlwhere+=" where t3.department="+department;
    else sqlwhere+=" and t3.department="+department;
}

if(!province.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.province="+province;
	else	sqlwhere+=" and t3.province="+province;
}
if(!city.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.city="+city;
	else	sqlwhere+=" and t3.city="+city;
}
if(!ProjID.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.projid="+ProjID;
	else	sqlwhere+=" and t1.projid="+ProjID;
}

if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}

String orderStr = "";
String orderStr1 = "";
if (ViewType == 0 ) {orderStr = "  order by t1.startDate desc "; orderStr1 = "  order by startDate asc ";}
if (ViewType == 1 ) {orderStr = "  order by t1.manager asc "; orderStr1 = "  order by manager desc "; }

//add by xhheng @20050201 for TD 1415
session.setAttribute("sqlwhere",sqlwhere);
session.setAttribute("orderStr",orderStr);
session.setAttribute("orderStr1",orderStr1);
%>
<form id=frmmain name=frmmain method=post action="ContractReport.jsp">
 <input type=hidden id=pagenum name=pagenum value="<%=pagenum%>">


<table class=ViewForm>
  <tbody>
  <COLGROUP>
    <COL width="13%">
    <COL width="20%">
    <COL width="14%">
    <COL width="20%">
    <COL width="13%">
    <COL width="20%">
<TR class=Title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
  </TR>    
<tr style="height: 1px"><td class=Line1 colspan=6></td></tr>
  <tr>
  <%if(!user.getLogintype().equals("2")){%>
  <td ><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
  <td class=field>
  <input class="wuiBrowser" _displayText="<a href='/hrm/resource/HrmResource.jsp?id=<%=resource%>'><%=Util.toScreen(resourcename,user.getLanguage())%></a>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" _displayTemplate="<A href='HrmResource.jsp?id=#b{id}'>#b{name}</A>" type=hidden name=viewer value="<%=resource%>"></td>
  <%}%>

    <TD><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%>  </TD>
    <TD class=Field><INPUT class=InputStyle maxLength=50 size=6 id="preyield" name="preyield" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield")' value="<%=preyield%>">
     -- <INPUT class=InputStyle maxLength=50 size=6 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1")' value="<%=preyield_1%>">
    </TD>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
    <TD class=Field>
    <select class=InputStyle id=status  name=status >
    <option value="" <%if(status.equals("")){%> selected <%}%> ></option>
    <option value=0 <%if(status.equals("0")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></option>
    <option value=-1 <%if(status.equals("-1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%></option>
    <option value=1 <%if(status.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%></option>
    <option value=2 <%if(status.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(6095,user.getLanguage())%></option>
	 <option value=3 <%if(status.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></option>
    </TD>
  </TR><tr style="height: 1px"><td class=Line colspan=6></td></tr>

  <tr>  
    <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
    <TD class=Field>
  <INPUT class=wuiBrowser _displayText="<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=customer%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%></a>" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" type=hidden name="customer" value="<%=customer%>">
  </TD>
</TD>


    <td><%=SystemEnv.getHtmlLabelName(1936,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;<SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
        <input type="hidden" name="fromdate" value=<%=fromdate%>>－&nbsp;<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;<SPAN id=enddatespan >
        <%=Util.toScreen(enddate,user.getLanguage())%></SPAN><input type="hidden" name="enddate" value=<%=enddate%>>
    </td>
	<TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
	<TD class=Field>
	<input class="wuiBrowser" _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" id=department type=hidden name=department value=<%=department%>>
	</TD>
  </TR><tr style="height: 1px"><td class=Line colspan=6></td></tr>

  <TR>
  <TD> <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
  <TD class=Field>
  <INPUT class="wuiBrowser" _displayText="<%=ProvinceComInfo.getProvincename(province)%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp" id=province type=hidden name="province" value="<%=province%>">  
  </TD>
  <TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
  <TD class=Field>  
  <BUTTON class=Browser type="button" id=SelectCityID onclick="onShowCityID()"></BUTTON> 
  <SPAN id=cityidspan STYLE="width=30%">
  <%=CityComInfo.getCityname(city)%></SPAN> 
  <INPUT id=city type=hidden name="city" value="<%=city%>">  
  </TD>
  <TD> <%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></TD>
  <TD class=Field>
    <INPUT class=wuiBrowser _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _displayText="<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=parentid%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(parentid),user.getLanguage())%></a>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" type=hidden id="parentid" name="parentid" value="<%=parentid%>">
  </TD>
  </TR>
  <tr style="height: 1px"><td class=Line colspan=6></td></tr> 

 <TR>
  <TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
  <TD class=Field>
    <INPUT class=wuiBrowser _displayTemplate="<A href='/proj/data/ViewProject.jsp?ProjID=#b{id}'>#b{name}</A>" _displayText="<a href='/proj/data/ViewProject.jsp?ProjID=<%=ProjID%>'><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(ProjID),user.getLanguage())%></a>" _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" type=hidden name="ProjID" value="<%=ProjID%>">
  </TD>
  <TD>&nbsp;</TD>
  <TD class=Field>&nbsp;</TD>
  <TD>&nbsp;</TD>
  <TD class=Field>&nbsp;</TD>
  </TR>
  </TR><tr style="height: 1px"><td class=Line colspan=6></td></tr>  

  <%
  String count_sum = "0";
  if(user.getLogintype().equals("1")){
		 sqlstr = "select sum(price) from CRM_Contract  t1 ,CRM_CustomerInfo  t3 "+ sqlwhere +" and t1.crmId = t3.id and t1.id in (select contractid from ContractShareDetail where userid  = "+user.getUID()+" and usertype=1  group by contractid)";
	}else{
        sqlstr = "select sum(price) from CRM_Contract t1 ,CRM_CustomerInfo  t3 "+ sqlwhere +" and t1.crmId = t3.id and t1.crmId="+user.getUID() ;
	}
   //System.out.print(sqlstr);
   RecordSet_count.executeSql(sqlstr);
   if (RecordSet_count.next()) count_sum = RecordSet_count.getString(1);
  %>



</tbody>
</table>
<table class=ListStyle cellspacing=0>
    <tr> <td valign="top">
  			<%
  			String  tableString  =  "";
  			String  backfields  =  "t1.id, t1.crmid, t1.typeid, t1.price, t1.status, t1.name, t1.manager, t1.startdate ";
  			String  fromSql  = "";
            String sqlmei = "";
            if(user.getLogintype().equals("1")){
                fromSql=" CRM_Contract  t1,(select contractid,max(sharelevel) as sharelevel from ContractShareDetail where  userid="+user.getUID()+" and usertype=1  group by contractid )  t2 ,CRM_CustomerInfo  t3 ";
                sqlmei=" and t1.crmId = t3.id and t1.id = t2.contractid ";
            }else{
                fromSql=" CRM_Contract  t1,CRM_CustomerInfo  t3 ";
                sqlmei=" and t1.crmId = t3.id and t1.crmId="+user.getUID();
            }
  			String orderby  =  "t1.startdate";
  			if(!sqlwhere.equals("")){
  				sqlwhere += sqlmei;
  			}
              tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
  									 "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"  sqlisdistinct=\"true\"  />"+
  									 "<head>";
  			tableString+="<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  column=\"id\" orderkey=\"t1.name\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getContractName\" otherpara=\"column:crmid\"/>";
  			tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(6083,user.getLanguage())+"\" column=\"typeid\" orderkey=\"t1.typeid\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getTypeName\"/>";
            tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(534,user.getLanguage())+"\"  column=\"price\" orderkey=\"t1.price\"/>";
            tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getStatus\" otherpara=\""+user.getLanguage()+"\"/>";
            tableString+="<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(1268,user.getLanguage())+"\" column=\"crmid\" orderkey=\"t1.crmid\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMName\"/>";
            tableString+="<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(2097,user.getLanguage())+"\" column=\"manager\" orderkey=\"t1.manager\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getResourceName\"/>";
            tableString+="<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(1936,user.getLanguage())+"\" column=\"startdate\" orderkey=\"t1.startdate\"/>";
            tableString+="</head>";
          tableString+="</table>";
        %>

			<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" topLeftText='<%="<font color=red style=font:bold>"+SystemEnv.getHtmlLabelName(358,user.getLanguage())+":"+count_sum+"</font>"%>' />
		</td>
	</tr>
</table>

</form>


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
</body>

<SCRIPT language="javascript">
function OnSubmit(pagenum){
        document.frmmain.pagenum.value = pagenum;
		document.frmmain.submit();
}
</script>



<!-- modify by xhheng @20040128 for TD 1415 -->
<iframe id="searchexport" style="display:none"></iframe>
<script language=javascript>

function onShowCityID(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp?provinceid="+frmmain.province.value,
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
		if (data.id!="0"){
			cityidspan.innerHTML = data.name
			frmmain.city.value=data.id
		}else{ 
			cityidspan.innerHTML = ""
			frmmain.city.value=""
		}
	}
}
function comparenumber(){
    lownumber = eval(toFloat(document.all("preyield").value,0));
    highnumber = eval(toFloat(document.all("preyield_1").value,0));
}

function ContractExport(){
    jQuery("#searchexport").attr("src","ContractReportExport.jsp");
}
</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>