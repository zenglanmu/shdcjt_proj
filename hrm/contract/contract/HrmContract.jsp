<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<body>
<%
boolean hasRight = false;
String rightStr = "";
if(HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)){
	hasRight = true ;
	rightStr = "HrmContractTypeAdd:Add";
}
if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
	hasRight = true ;
	rightStr = "HrmContractAdd:Add";
}
if(!hasRight){
		response.sendRedirect("/notice/noright.jsp");
		return;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String from = Util.null2String(request.getParameter("from"));
boolean isoracle = rs.getDBType().equals("oracle") ;
String typepar = Util.null2String(request.getParameter("typepar"));
String namepar = Util.null2String(request.getParameter("namepar"));
String manpar = Util.null2String(request.getParameter("manpar"));
String startdatefrom = Util.null2String(request.getParameter("startdatefrom"));
String startdateto = Util.null2String(request.getParameter("startdateto"));
String enddatefrom = Util.null2String(request.getParameter("enddatefrom"));
String enddateto = Util.null2String(request.getParameter("enddateto"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String status = Util.null2String(request.getParameter("status"));


if("".equals(departmentid) && !from.equals("tree") && !	from.equals("")){
	departmentid = Util.null2String((String)session.getAttribute("HrmContract_departmentid_"+user.getUID()));
}
if(subcompanyid.equals("") && departmentid.equalsIgnoreCase("") && !from.equals("delete") && detachable==1 )
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(21921,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}
String sqlwhere = "";
String sqlstr ="";
String currentvalue = "";
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!namepar.equals("")){
		if(sqlwhere.equals("")) sqlwhere += " where contractname like '%" + namepar +"%' ";

	else
		sqlwhere += " and contractname like '%" + namepar +"%' ";
}
if(!manpar.equals("")){

		if(sqlwhere.equals(""))sqlwhere += " where contractman =" + manpar +" ";

	else
		sqlwhere += " and contractman =" + manpar +" ";
}
if(!typepar.equals("")){

		if(sqlwhere.equals(""))sqlwhere += " where contracttypeid in (select id from HrmContractType where typename like '%" + typepar +"%') ";

	else
		sqlwhere += " and contracttypeid in (select id from HrmContractType where typename like '%" + typepar +"%') ";
}
if(!startdatefrom.equals("")){

       if(sqlwhere.equals(""))	sqlwhere+=" where contractstartdate>='"+startdatefrom+"'";
		else 	sqlwhere+=" and contractstartdate>='"+startdatefrom+"'";
}
if(!startdateto.equals("")){
        if(sqlwhere.equals(""))	sqlwhere+=" where contractstartdate<='"+startdateto+"'";
		else 	sqlwhere+=" and contractstartdate<='"+startdateto+"'";

}
if(!enddatefrom.equals("")){

		if(sqlwhere.equals(""))	sqlwhere+=" where contractenddate>='"+enddatefrom+"'";
		else 	sqlwhere+=" and contractenddate>='"+enddatefrom+"'";
}
if(!enddateto.equals("")){
      

		if(sqlwhere.equals(""))	sqlwhere+=" where contractenddate<='"+enddateto+"'";
		else 	sqlwhere+=" and contractenddate<='"+enddateto+"'";

}



if(!status.equals("")&& !status.equals("8")&&!status.equals("9") ){
			if(sqlwhere.equals("")){
				sqlwhere = " where contractman in (select id from hrmresource where status = "+status+" )  ";
			}else{
				sqlwhere += " and contractman in ( select id from hrmresource where status = "+status+" ) ";
			}
}

if(status.equals("8")||status.equals("") ){
			if(sqlwhere.equals("")){
				sqlwhere = " where contractman in (select id from hrmresource where status = 0 or status = 1 or status = 2 or status = 3) ";
			}else{
				sqlwhere += " and contractman in  (select id from hrmresource where status = 0 or status = 1 or status = 2 or status = 3) ";
			}
		}

if(detachable==1){
	if(!departmentid.equals("") && subcompanyid.equals("")){
			if(sqlwhere.equals("")){
			sqlwhere += " where id != 0 and  contractman in (select id from HrmResource where departmentid ="+departmentid+")" ;
			}else{
			sqlwhere += " and id != 0 and  contractman in (select id from HrmResource where departmentid ="+departmentid+")" ;
			}
	}else if(!subcompanyid.equals("") && departmentid.equals("")){
		if(sqlwhere.equals("")){
				sqlwhere += " where id != 0 and  contractman in (select id from HrmResource where subcompanyid1 ="+subcompanyid+")" ;
		}else{
				sqlwhere += " and id != 0 and  contractman in (select id from HrmResource where subcompanyid1 ="+subcompanyid+")" ;
		}
	
	}else if (from.equals("location")){
			if(!subcompanyid.equals("")){
				if(sqlwhere.equals("")){
				sqlwhere += " where id != 0 and  contractman in ((select id from HrmResource where subcompanyid1 ="+subcompanyid+"))" ;
				}else{
				sqlwhere += " and id != 0 and  contractman in ((select id from HrmResource where subcompanyid1 ="+subcompanyid+"))" ;
				}
			}else if (!departmentid.equals("")){
				if(sqlwhere.equals("")){
					sqlwhere += " where id != 0 and  contractman in ((select id from HrmResource where subcompanyid1 ="+departmentid+"))" ;
					}else{
					sqlwhere += " and id != 0 and  contractman in ((select id from HrmResource where subcompanyid1 ="+departmentid+"))" ;
					}
			}
	}else if (from.equals("delete")){
		if(sqlwhere.equals("")){
				sqlwhere += " where id != 0 and  contractman in ((select id from HrmResource where departmentid ="+user.getUserDepartment()+"))" ;
				}else{
				sqlwhere += " and id != 0 and  contractman in ((select id from HrmResource where departmentid ="+user.getUserDepartment()+"))" ;
				}
	}
}else{
	if(sqlwhere.equals("")){
		sqlwhere += " where id != 0 " ;
	}else{
		sqlwhere += " and id != 0 " ;
	}
}
if(!"".equals(departmentid)){
	session.setAttribute("HrmContract_departmentid_"+user.getUID(), departmentid);
}
session.setAttribute("sqlwhere",sqlwhere);
int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;
int numcount = 0;
  String sqlnum = "select count(id) from HrmContract "+sqlwhere;
  //System.out.println("sqlnum:"+sqlnum);
  rs.executeSql(sqlnum);
  rs.next();
  numcount = rs.getInt(1);


String temptable = "temptable"+Util.getRandom();
String sqltemp = "" ;
String temptable1="";
if(isoracle) {
    //sqltemp = "create table "+temptable+" as select * from ( select * from HrmContract "+sqlwhere+" order by id desc )  where rownum<"+ (pagenum*perpage+1);
	temptable1="(select * from (select *  FROM HrmContract "+sqlwhere+"  order by id desc ) where rownum<"+ (pagenum*perpage+1)+")  s";
}
else {
    //sqltemp = "select top "+(pagenum*perpage)+" * into "+temptable+" from HrmContract "+sqlwhere+" order by id desc";
    temptable1="(select top "+(pagenum*perpage+1)+"  *  from HrmContract  "+sqlwhere+"  order by id desc) as s";
}

//rs.executeSql(sqltemp);
//out.print(temptable1);
String sqlcount = "select count(id) from "+temptable1;
//rs.executeSql(sqlcount);
rs.next();
int count = rs.getInt(1);
String sql = "" ;
if(isoracle) {
    sql = "select * from (select * from "+temptable1 +" order by id ) where rownum<="+ (count - ((pagenum-1)*perpage)) ;
}
else {
    sql = "select top "+(count - ((pagenum-1)*perpage)) +" * from "+temptable1+" order by id ";
}
//out.print(sql);
boolean hasnext = false;
if(numcount>pagenum*perpage){
  hasnext = true;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(614,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
    int deplevel=0;
    if(detachable==1){
       deplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmContractAdd:Add",Util.getIntValue(DepartmentComInfo.getSubcompanyid1(departmentid)));
    }else{
      if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user))
        deplevel=2;
    }
    if(user.getUID() != 1 || !"".equals(departmentid) || detachable == 0) {
		if(deplevel>0){
			//if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",/hrm/contract/contract/HrmContractTypeSelect.jsp?departmentid="+departmentid+",_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			//}
		}
	}
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+105+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=templet name=templet action="HrmContract.jsp" method=post>
<input class=inputstyle type="hidden" name="from">
<input class=inputstyle type="hidden" name="departmentid" value="<%=departmentid%>">
<input class=inputstyle type="hidden" name="subcompanyid" value="<%=subcompanyid%>">
<table class=Viewform>
  <tbody>
  <COLGROUP>
    <COL width="10%">
    <COL width="25%">
    <COL width="10%">
    <COL width="25%">
    <COL width="10%">
    <COL width="20%">
  <TR class=Title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=6 ></TD>
  </TR>
  <tr>
    <td>
      <%=SystemEnv.getHtmlLabelName(15775,user.getLanguage())%>
    </td>
    <td class=field>
      <input  class=inputstyle type=text name=typepar value=<%=typepar%>>
    </td>
    <td>
      <%=SystemEnv.getHtmlLabelName(15142,user.getLanguage())%>
    </td>
    <td class=field>
      <input class=inputstyle type=text name=namepar value=<%=namepar%>>
    </td>
    <td>
      <%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%>
    </td>
    <td class=field>

          <input class="wuiBrowser" type=hidden id=manpar name=manpar value="<%=manpar%>"
		  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
		  _displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>">
    </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
  <tr>
    <td>
      <%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%>
    </td>
    <td class=field>
       <BUTTON class=Calendar type="button" id=selectstartdatefrom onclick="getDate(startdatefromspan,startdatefrom)"></BUTTON>
       <SPAN id=startdatefromspan ><%=startdatefrom%></SPAN> -&nbsp;
       <BUTTON class=Calendar type="button" id=selectstartdateto onclick="getDate(startdatetospan,startdateto)"></BUTTON>
       <SPAN id=startdatetospan ><%=startdateto%></SPAN>
       <input class=inputstyle type="hidden" name="startdatefrom" value="<%=startdatefrom%>">
       <input class=inputstyle type="hidden" name="startdateto" value="<%=startdateto%>">
    </td>
    <td>
      <%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%>
    </td>
    <td class=field>
       <BUTTON class=Calendar type="button" id=selectenddatefrom onclick="getDate(enddatefromspan,enddatefrom)"></BUTTON>
       <SPAN id=enddatefromspan ><%=enddatefrom%></SPAN> -&nbsp;
       <BUTTON class=Calendar type="button" id=selectenddateto onclick="getDate(enddatetospan,enddateto)"></BUTTON>
       <SPAN id=enddatetospan ><%=enddateto%></SPAN>
       <input class=inputstyle type="hidden" name="enddatefrom" value="<%=enddatefrom%>">
       <input class=inputstyle type="hidden" name="enddateto" value="<%=enddateto%>">
    </td>
 <td>
      <%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>
    </td>
    <td class=field>
        <SELECT class=inputstyle id=status name=status value="<%=status%>">
<%

    if(status.equals("")){
      status = "8";
    }
  
%>
                   <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
                   <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
                   <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
                   <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
                   <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
                   <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
                   <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
                   <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
                   <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
                   <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>
                 </SELECT>
    </td>
  </tr>
   <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
  </tbody>
</table>
<br>

<TABLE class=ListStyle cellspacing=1 >
<TBODY>
  <TR>

  </TR>
    <!--TR class=Spacing>
        <TD class=Line1 colSpan=2></TD-->
<%
	                     //得到pageNum 与 perpage
	                     //int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
	                     //int perpage = UserDefaultManager.getNumperpage();
	                     if(perpage <2) perpage=15;
	                     
	                     //设置好搜索条件
	                     String backFields =" id,contractname,contracttypeid,contractman,contractstartdate,contractenddate ";
	                     String fromSql = " HrmContract";
						 String sqlmei = "";
	                     String sqlWhere = "" ;
						 String orderBy="";
						 //orderBy = " enddate  ";
						 if(!sqlwhere.equals("")){
  				sqlwhere += sqlmei;
  			}
						 String linkstr = "";
						 //linkstr = "HrmCheckBasicInfo.jsp";
	                     String tableString=""+
	                            "<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
	                            "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
	                            "<head>";
	                                  tableString+="<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(614,user.getLanguage())+"\" column=\"contractname\" orderkey=\"id\" href=\"HrmContractView.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_fullwindow\"/>";
									  tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15775,user.getLanguage())+"\" column=\"contracttypeid\" orderkey=\"contracttypeid\" href=\"/hrm/contract/contracttype/HrmContractTypeEdit.jsp\" linkkey=\"id\" transmethod=\"weaver.hrm.contract.ContractTypeComInfo.getContractTypename\"/>";	    
									  tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15776,user.getLanguage())+"\" column=\"contractman\" orderkey=\"contractman\" href=\"/hrm/resource/HrmResource.jsp\" linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>";
									  tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1970,user.getLanguage())+"\" column=\"contractstartdate\" orderkey=\"contractstartdate\" transmethod=\"\"/>";
									  tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15236,user.getLanguage())+"\" column=\"contractenddate\" orderkey=\"contractenddate\" transmethod=\"\"/>";
	                            tableString+="</head>";
								tableString+="</table>";

	                   %>
					   <TABLE width="100%" height="100%">
	                         <TR>
	                             <TD valign="top">
	                                 <wea:SplitPageTag isShowTopInfo="true" tableString="<%=tableString%>"   mode="run"/>
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
<td height="0" colspan="3"></td>
</tr>
</table>
</BODY>
<script language=javascript>
function submitData() {
 document.templet.from.value = "location";
 templet.submit();

}
</script>
<script language=vbs>
sub onShowResource()
	Dim id
if <%=detachable%> <> 1 then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	else 
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=<%=rightStr%>")
	end if
	if NOT isempty(id) then
	        if id(0)<> "" then
		manparspan.innerHtml = "<a href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		templet.manpar.value=id(0)
		else
		manparspan.innerHtml = ""
		templet.manpar.value=""
		end if
	end if
end sub
</script>
<script language=javascript>
function pageup(){
    document.templet.pagenum.value="<%=pagenum-1%>";
    document.templet.action="HrmContract.jsp";
    document.templet.submit();
}
function pagedown(){
    document.templet.pagenum.value="<%=pagenum+1%>";
    document.templet.action="HrmContract.jsp";
    document.templet.submit();
}
function ContractExport(){
    searchexport.location="ContractReportExport.jsp";
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>