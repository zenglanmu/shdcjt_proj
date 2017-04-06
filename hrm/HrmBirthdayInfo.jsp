<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Date" %>

<%@ page import="weaver.common.xtable.*" %>		
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all.css' />
<link rel='stylesheet' type='text/css' href='/css/weaver-ext.css' />
<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray.css'/>
<script type='text/javascript' src='/js/extjs/adapter/ext/ext-base.js'></script>
<script type='text/javascript' src='/js/extjs/ext-all.js'></script>   
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_gbk.js'></script>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en.js'></script>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk.js'></script>
<%}%>
 <script type="text/javascript" src="/js/WeaverTableExt.js"></script> 
 <link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid.css" /> 
 <%
	 ArrayList xTableColumnList=new ArrayList();
 %>
<!--声明结束-->
 
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(22483,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canhrmmaint = HrmUserVarify.checkUserRight("HRM:BirthdayReminder", user);
if(!canhrmmaint){
   response.sendRedirect("/notice/noright.jsp");
   return ;
}

String userid = ""+user.getUID();
//获取当前日期和时间
Date newdate = new Date();
long datetime = newdate.getTime(); 
Timestamp timestamp = new Timestamp(datetime);
String birthdaytype = (timestamp.toString()).substring(5, 7);
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String subcompanyname = Util.null2String(request.getParameter("subcompanyhieden"));
String deptid = Util.null2String(request.getParameter("deptid"));
String depthiddenname = Util.null2String(request.getParameter("depthiddenname"));
String hrmname = Util.null2String(request.getParameter("hrmname"));
String satrdate = Util.null2String(request.getParameter("satrdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String searchoper = Util.null2String(request.getParameter("search"));

int perpage=15;
String backfields="";

if(RecordSet.getDBType().equals("oracle")){
  backfields="id,lastname,substr(birthday,6,10) as birthday,mobile,departmentid,subcompanyid1";
}else{
  backfields="id,lastname,substring(birthday,6,10) as birthday,mobile,departmentid,subcompanyid1";
}

String  fromSql = " hrmresource ";
String sqlWhere = " 1=1 ";

if("search".equals(searchoper)){
       if(!"".equals(hrmname)){
          sqlWhere += " and lastname like '%"+hrmname+"%'";
       }
       if(!"".equals(subcompanyid)){
          sqlWhere += " and subcompanyid1 in ("+subcompanyid+")";
       }
       if(!"".equals(deptid)){
          sqlWhere += " and departmentid in ("+deptid+")";
       }
       if(!"".equals(satrdate)){
          if(RecordSet.getDBType().equals("oracle")){
		  	sqlWhere += " and substr(birthday,6,10) >= '"+satrdate+"'";
		  }else{
		  	sqlWhere += " and substring(birthday,6,10) >= '"+satrdate+"'";
		  }   
       }
       if(!"".equals(enddate)){
          if(RecordSet.getDBType().equals("oracle")){
		  	sqlWhere += " and substr(birthday,6,10) <= '"+enddate+"'";
		  }else{
		  	sqlWhere += " and substring(birthday,6,10) <= '"+enddate+"'";
		  }  
       }
       if(!"".equals(satrdate) && !"".equals(enddate)){
          if(RecordSet.getDBType().equals("oracle")){
		  	sqlWhere +=  " and substr(birthday,6,10) >= '"+satrdate+"' and substr(birthday,6,10) <= '"+enddate+"'";
		  }else{
		  	sqlWhere +=  " and substring(birthday,6,10) >= '"+satrdate+"' and substring(birthday,6,10) <= '"+enddate+"'";
		  }  
       }
}else{
  if(RecordSet.getDBType().equals("oracle")){
	 sqlWhere += " and substr(birthday,6,2) = '"+birthdaytype+"'";
  }else{
  	 sqlWhere += " and substring(birthday,6,2) = '"+birthdaytype+"'";
  } 
}
if(RecordSet.getDBType().equals("oracle")){
    sqlWhere += " and birthday is not null and status in (0,1,2,3)";
}else{
    sqlWhere += " and birthday <> '' and status in (0,1,2,3)";
}
TableColumn xTableColumn_subcompanyid=new TableColumn();
xTableColumn_subcompanyid.setColumn("subcompanyid1");
xTableColumn_subcompanyid.setDataIndex("subcompanyid1");
xTableColumn_subcompanyid.setHeader(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
xTableColumn_subcompanyid.setTransmethod("weaver.splitepage.transform.SptmForContacterInfo.getSubCompanyname");
xTableColumn_subcompanyid.setPara_1("column:subcompanyid1");
xTableColumn_subcompanyid.setSortable(true);
xTableColumn_subcompanyid.setWidth(0.05); 
xTableColumnList.add(xTableColumn_subcompanyid);

TableColumn xTableColumn_departmentid=new TableColumn();
xTableColumn_departmentid.setColumn("departmentid");
xTableColumn_departmentid.setDataIndex("departmentid");
xTableColumn_departmentid.setHeader(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
xTableColumn_departmentid.setTransmethod("weaver.splitepage.transform.SptmForContacterInfo.getDeptmentname");
xTableColumn_departmentid.setPara_1("column:departmentid");
xTableColumn_departmentid.setSortable(true);
xTableColumn_departmentid.setWidth(0.05); 
xTableColumnList.add(xTableColumn_departmentid);

TableColumn xTableColumn_lastname=new TableColumn();
xTableColumn_lastname.setColumn("lastname");
xTableColumn_lastname.setDataIndex("lastname");
xTableColumn_lastname.setHeader(SystemEnv.getHtmlLabelName(413,user.getLanguage()));
xTableColumn_lastname.setTarget("_fullwindow");
xTableColumn_lastname.setHref("/hrm/resource/HrmResource.jsp");
xTableColumn_lastname.setLinkkey("id");
xTableColumn_lastname.setSortable(true);
xTableColumn_lastname.setWidth(0.06); 
xTableColumnList.add(xTableColumn_lastname);

TableColumn xTableColumn_birthday=new TableColumn();
xTableColumn_birthday.setColumn("birthday");
xTableColumn_birthday.setDataIndex("birthday");
xTableColumn_birthday.setHeader(SystemEnv.getHtmlLabelName(1964,user.getLanguage()));
xTableColumn_birthday.setTransmethod("weaver.splitepage.transform.SptmForContacterInfo.getCustomerBirthday");
xTableColumn_birthday.setPara_1("column:birthday");
xTableColumn_birthday.setPara_2(String.valueOf(user.getLanguage()));
xTableColumn_birthday.setSortable(true);
xTableColumn_birthday.setWidth(0.06); 
xTableColumnList.add(xTableColumn_birthday);

TableColumn xTableColumn_mobile=new TableColumn();
xTableColumn_mobile.setColumn("mobile");
xTableColumn_mobile.setDataIndex("mobile");
xTableColumn_mobile.setHeader(SystemEnv.getHtmlLabelName(22482,user.getLanguage()));
xTableColumn_mobile.setTarget("_fullwindow");
xTableColumn_mobile.setHref("/sms/SmsMessageEdit.jsp");
xTableColumn_mobile.setLinkkey("hrmid");
xTableColumn_mobile.setSortable(true);
xTableColumn_mobile.setWidth(0.08); 
xTableColumnList.add(xTableColumn_mobile);

TableSql xTableSql=new TableSql();
xTableSql.setBackfields(backfields);
xTableSql.setPageSize(perpage);
xTableSql.setSqlform(fromSql);
xTableSql.setSqlwhere(sqlWhere);
xTableSql.setSqlprimarykey("id");
xTableSql.setSqlisdistinct("true");
xTableSql.setDir(TableConst.DESC);

Table xTable=new Table(request); 

xTable.setTableId("xTable_hrmBirthdayInfo");//必填而且与别的地方的Table不能一样，建议用当前页面的名字
xTable.setTableGridType(TableConst.NONE);
xTable.setTableNeedRowNumber(true);												
xTable.setTableSql(xTableSql);
xTable.setTableColumnList(xTableColumnList);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>	

<FORM id=weaver name=weaver action="/hrm/HrmBirthdayInfo.jsp" method=post>
<br/>
<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0" class="Shadow">
   <tr>
	 <td height="20">
	   <table class=ViewForm >
	     <tr style="height:1px"><td class=Line colSpan=4></td></tr>
	     <tr>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
		   <td CLASS="Field" width=20%>
		     <INPUT type=hidden class=wuiBrowser name="subcompanyid" id="subcompanyid" value="<%=subcompanyid %>"
		     _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubCompanyByRightBrowser.jsp">
		     <INPUT type=hidden name="subcompanyhieden" id="subcompanyhieden" value="<%=subcompanyname%>">
             <span id="subcompanyname"><%=subcompanyname%></span>
		   </td>

		   <td width=10%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
		   <td CLASS="Field" width=20%>
		     <INPUT type=hidden class=wuiBrowser name="deptid" id="deptid" value="<%=deptid %>"
		     _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp">    
		     <INPUT type=hidden name="depthiddenname" id="depthiddenname" value="<%=depthiddenname%>">           
		     <span id=deptname><%=depthiddenname%></span>
		   </td>
		 </tr>
		 <tr style="height:1px"><td class=Line colSpan=4></td></tr>  
	     <tr>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
		   <td CLASS="Field" width=20%>
		     <input class=InputStyle  type="text" name="hrmname" value="<%=hrmname %>">
		   </td>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(1964,user.getLanguage())%></td>
		   <td CLASS="Field" width=20%>
		      <BUTTON class=Calendar onclick="getDate(datestarspan,satrdate)"></BUTTON> 
			  <SPAN id=datestarspan><%=satrdate%></SPAN>&nbsp;- &nbsp;
			  <BUTTON class=Calendar onclick="getDate(dateendspan,enddate)"></BUTTON> 
			  <SPAN id=dateendspan><%=enddate%></SPAN>
		      <input class=InputStyle  type="hidden" name="satrdate" value="<%=satrdate%>">
			  <input class=InputStyle  type="hidden" name="enddate" value="<%=enddate%>">
		   </td>
		 </tr>
		 <tr style="height:1px"><td class=Line colSpan=4></td></tr>  
	   </table>
	 </td>
  </tr>
  <tr>
	<td></td>
  </tr>
  <tr>
	<td valign="top">
	  <%=xTable.toString()%>
	</td>
  </tr>
</TABLE>
<input type="hidden" name="search">
</Form>
<SCRIPT language=VBS>
sub onShowDepartment()
	dept_id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&weaver.deptid.value)
    dept_name = document.all("deptid").innerHtml
    if Not isempty(dept_id) then
	if dept_id(0)<> "" then
	deptname.innerHtml = Mid(dept_id(1),2)
	weaver.deptid.value = Mid(dept_id(0),2)
    weaver.depthiddenname.value = Mid(dept_id(1),2)
	else
	deptname.innerHtml = ""
	weaver.deptid.value=""
	end if
	end if
end sub

sub onShowSubcompany(tdname,inputename,rightStr)
   sub_id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubCompanyByRightBrowser.jsp?selectedids="&document.all(inputename).value&"&rightStr="&rightStr)     
   if NOT isempty(sub_id) then
		if sub_id(0)<> "" then
	    resourceids = sub_id(0)
		resourcename = sub_id(1)
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
        document.all("subcompanyhieden").value = sHtml
		else
		document.all(tdname).innerHtml = ""
		document.all(inputename).value=""
		end if
	end if
end sub
</SCRIPT>
</BODY>
<script type='text/javascript'>
   function onSearch(){
     document.weaver.search.value="search";
     weaver.submit();
   }
   
   function getDate(spanname,inputname){  
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue.substring(5,10);$dp.$(spanname).innerHTML = returnvalue.substring(5,10);},oncleared:function(dp){$dp.$(inputname).value = ''}});
   }
   
   function showSubCDetailInfo(id){
     openFullWindowForXtable("/hrm/company/HrmDepartment.jsp?subcompanyid="+id);
   }
   
   function showDeptDetailInfo(id){
     openFullWindowForXtable("/hrm/company/HrmDepartmentDsp.jsp?id="+id);
   }
</script> 
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>