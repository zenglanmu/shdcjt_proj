<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Date" %>

<%@ page import="weaver.common.xtable.*" %>		
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
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
String titlename = SystemEnv.getHtmlLabelName(22484,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid = ""+user.getUID();
//获取当前日期和时间
Date newdate = new Date();
long datetime = newdate.getTime(); 
Timestamp timestamp = new Timestamp(datetime);
String birthdaytype = (timestamp.toString()).substring(5, 7);

String customername = Util.null2String(request.getParameter("customername"));
String fullname = Util.null2String(request.getParameter("fullname"));
String satrdate = Util.null2String(request.getParameter("satrdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String searchoper = Util.null2String(request.getParameter("search"));

int perpage=15;
String backfields="";
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
if(RecordSet.getDBType().equals("oracle")){
  backfields="id,customerid,fullname,substr(birthday,6,10) as birthday,(select fullname from CRM_ContacterTitle where id = title) as title,mobilephone ";
}else{
  backfields="id,customerid,fullname,substring(birthday,6,10) as birthday,(select fullname from CRM_ContacterTitle where id = title) as title,mobilephone ";
}

String  fromSql = "CRM_CustomerContacter ";
String sqlWhere = "customerid in (select distinct t1.id from CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid where t1.deleted = 0  and t1.id = t2.relateditemid";

if("search".equals(searchoper)){
    if(!"".equals(customername)){
       sqlWhere += " and t1.name like '%"+customername+"%')";
       
       if(!"".equals(fullname)){
          sqlWhere += " and fullname like '%"+fullname+"%'";
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
       sqlWhere += " ) ";
       if(!"".equals(fullname)){
         sqlWhere += " and fullname like '%"+fullname+"%'";
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
    }
}else{
    if(RecordSet.getDBType().equals("oracle")){
  		sqlWhere += " ) and substr(birthday,6,2) = '"+birthdaytype+"'";
	}else{
  		sqlWhere += " ) and substring(birthday,6,2) = '"+birthdaytype+"'";
	}
}
if(RecordSet.getDBType().equals("oracle")){
    sqlWhere += " and birthday is not null";
}else{
    sqlWhere += " and birthday <> ''";
}

TableColumn xTableColumn_customerid=new TableColumn();
xTableColumn_customerid.setColumn("customerid");
xTableColumn_customerid.setDataIndex("customerid");
xTableColumn_customerid.setHeader(SystemEnv.getHtmlLabelName(1268,user.getLanguage()));
xTableColumn_customerid.setTransmethod("weaver.splitepage.transform.SptmForContacterInfo.getCustomerFullname");
xTableColumn_customerid.setPara_1("column:customerid");
xTableColumn_customerid.setSortable(true);
xTableColumn_customerid.setWidth(0.05); 
xTableColumnList.add(xTableColumn_customerid);

TableColumn xTableColumn_fullname=new TableColumn();
xTableColumn_fullname.setColumn("fullname");
xTableColumn_fullname.setDataIndex("fullname");
xTableColumn_fullname.setHeader(SystemEnv.getHtmlLabelName(572,user.getLanguage())+SystemEnv.getHtmlLabelName(413,user.getLanguage()));
xTableColumn_fullname.setTarget("_fullwindow");
xTableColumn_fullname.setHref("/CRM/data/ViewContacter.jsp");
xTableColumn_fullname.setLinkkey("ContacterID");
xTableColumn_fullname.setSortable(true);
xTableColumn_fullname.setWidth(0.05); 
xTableColumnList.add(xTableColumn_fullname);

TableColumn xTableColumn_title=new TableColumn();
xTableColumn_title.setColumn("title");
xTableColumn_title.setDataIndex("title");
xTableColumn_title.setHeader(SystemEnv.getHtmlLabelName(462,user.getLanguage()));
//xTableColumn_title.setTransmethod("weaver.splitepage.transform.SptmForContacterInfo.getContacterTitle");
//xTableColumn_title.setPara_1("column:id");
xTableColumn_title.setSortable(true);
xTableColumn_title.setWidth(0.06); 
xTableColumnList.add(xTableColumn_title);

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

TableColumn xTableColumn_mobilephone=new TableColumn();
xTableColumn_mobilephone.setColumn("mobilephone");
xTableColumn_mobilephone.setDataIndex("mobilephone");
xTableColumn_mobilephone.setHeader(SystemEnv.getHtmlLabelName(22482,user.getLanguage()));
xTableColumn_mobilephone.setTarget("_fullwindow");
xTableColumn_mobilephone.setHref("/sms/SmsMessageEdit.jsp");
xTableColumn_mobilephone.setLinkkey("crmid");
xTableColumn_mobilephone.setSortable(true);
xTableColumn_mobilephone.setWidth(0.08); 
xTableColumnList.add(xTableColumn_mobilephone);

TableSql xTableSql=new TableSql();
xTableSql.setBackfields(backfields);
xTableSql.setPageSize(perpage);
xTableSql.setSqlform(fromSql);
xTableSql.setSqlwhere(sqlWhere);
xTableSql.setSqlprimarykey("id");
xTableSql.setSqlisdistinct("true");
xTableSql.setDir(TableConst.DESC);

Table xTable=new Table(request); 

xTable.setTableId("xTable_Contacter");//必填而且与别的地方的Table不能一样，建议用当前页面的名字
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

<FORM id=weaver name=weaver action="/CRM/CustomerContacterInfo.jsp" method=post>
<br/>
<TABLE width=98% height=100% border="0" cellspacing="0" cellpadding="0" class="Shadow">
<tr>
    <td width="10px">
    </td>
    <td>
<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0" class="Shadow">
   <tr>
	 <td height="20">
	   <table class=ViewForm >
	     <tr><td class=Line colSpan=6></td></tr>
	     <tr>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage()) %></td>
		   <td CLASS="Field" width=20%>
		     <input class=InputStyle  type="text" name="customername" value="<%=customername %>">
		   </td>

		   <td width=10%><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())+SystemEnv.getHtmlLabelName(413,user.getLanguage()) %></td>
		   <td CLASS="Field" width=20%>
		     <input class=InputStyle  type="text" name="fullname" value="<%=fullname %>">
		   </td>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(1964,user.getLanguage()) %></td>
		   <td CLASS="Field" width=20%>
		      <BUTTON class=Calendar onclick="getDate(datestarspan,satrdate)"></BUTTON> 
			  <SPAN id=datestarspan><%=satrdate%></SPAN>&nbsp;- &nbsp;
			  <BUTTON class=Calendar onclick="getDate(dateendspan,enddate)"></BUTTON> 
			  <SPAN id=dateendspan><%=enddate%></SPAN>
		      <input class=InputStyle  type="hidden" name="satrdate" value="<%=satrdate%>">
			  <input class=InputStyle  type="hidden" name="enddate" value="<%=enddate%>">
		   </td>
		 </tr>
		 <tr><td class=Line colSpan=6></td></tr>  
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
    </td>
    <td width="10px">
    </td>
</tr>
</TABLE>

<input type="hidden" name="search">
</Form>
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
   
   function showDetailInfo(id){
     openFullWindowForXtable("/CRM/data/ViewCustomer.jsp?CustomerID="+id+"&isfromtab=true");
   }
</script> 
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>