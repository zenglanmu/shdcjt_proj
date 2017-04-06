<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.common.xtable.*" %>	

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>

 <%
	 ArrayList xTableColumnList=new ArrayList();
 %>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</head>
<%
//add by dongping for TD1273　2004.11.11
// 对文档有查看或者编辑权限的人才能看到查看文档的附件的下载日志
if(!HrmUserVarify.checkUserRight("DocDownloadLog:View",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(17515,user.getLanguage());
String needfav ="1";
String needhelp ="";

String resource = Util.null2String(request.getParameter("resource")) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;

int perpage=25;

String sqlWhere = "";
if(!resource.equals("")) sqlWhere +="where userid ="+resource ;

if(!fromdate.equals("")) {
	if(sqlWhere.equals("")) sqlWhere +="where downloadtime >='"+fromdate+"'" ;
	else sqlWhere +=" and downloadtime >='"+fromdate+"'" ;
}
if(!todate.equals("")) {
	if(sqlWhere.equals("")) sqlWhere +="where downloadtime <='"+todate+" 23:59:59'" ;
	else sqlWhere +=" and downloadtime <='"+todate+" 23:59:59'" ;
}

String tableString = "";
String orderBy = "downloadtime";
String backfields = " userid,username, downloadtime, imagename, docname, docid,clientaddress ";
String  fromSql = " DownloadLog ";

TableColumn xTableColumn_username=new TableColumn();
xTableColumn_username.setColumn("username");
xTableColumn_username.setDataIndex("username");
xTableColumn_username.setHeader(SystemEnv.getHtmlLabelName(17516,user.getLanguage()));
xTableColumn_username.setSortable(true);
xTableColumn_username.setWidth(0.08); 
xTableColumnList.add(xTableColumn_username);

TableColumn xTableColumn_imagename=new TableColumn();
xTableColumn_imagename.setColumn("imagename");
xTableColumn_imagename.setDataIndex("imagename");
xTableColumn_imagename.setHeader(SystemEnv.getHtmlLabelName(17517,user.getLanguage()));
xTableColumn_imagename.setSortable(true);
xTableColumn_imagename.setWidth(0.12); 
xTableColumnList.add(xTableColumn_imagename);

TableColumn xTableColumn_DocName=new TableColumn();
xTableColumn_DocName.setColumn("docname");
xTableColumn_DocName.setDataIndex("docname");
xTableColumn_DocName.setHeader(SystemEnv.getHtmlLabelName(17518,user.getLanguage()));
xTableColumn_DocName.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocDownLogURL");
xTableColumn_DocName.setPara_1("column:docid");
xTableColumn_DocName.setPara_2("column:docname");
xTableColumn_DocName.setSortable(true);
xTableColumn_DocName.setWidth(0.12); 
xTableColumnList.add(xTableColumn_DocName);

TableColumn xTableColumn_downloadtime=new TableColumn();
xTableColumn_downloadtime.setColumn("downloadtime");
xTableColumn_downloadtime.setDataIndex("downloadtime");
xTableColumn_downloadtime.setHeader(SystemEnv.getHtmlLabelName(17519,user.getLanguage()));
xTableColumn_downloadtime.setSortable(true);
xTableColumn_downloadtime.setWidth(0.08); 
xTableColumnList.add(xTableColumn_downloadtime);

TableColumn xTableColumn_clientaddress=new TableColumn();
xTableColumn_clientaddress.setColumn("clientaddress");
xTableColumn_clientaddress.setDataIndex("clientaddress");
xTableColumn_clientaddress.setHeader(SystemEnv.getHtmlLabelName(17484,user.getLanguage()));
xTableColumn_clientaddress.setSortable(true);
xTableColumn_clientaddress.setWidth(0.08); 
xTableColumnList.add(xTableColumn_clientaddress);

TableSql xTableSql=new TableSql();
xTableSql.setBackfields(backfields);
xTableSql.setPageSize(perpage);
xTableSql.setSqlform(fromSql);
xTableSql.setSqlwhere(sqlWhere);
xTableSql.setSqlprimarykey("downloadtime");
xTableSql.setSqlisdistinct("true");
xTableSql.setDir(TableConst.DESC);

Table xTable=new Table(request); 
xTable.setTableId("xTable_DownLogView");//必填而且与别的地方的Table不能一样，建议用当前页面的名字
xTable.setTableGridType(TableConst.NONE);
xTable.setTableNeedRowNumber(true);												
xTable.setTableSql(xTableSql);
xTable.setTableColumnList(xTableColumnList);

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
String topButton = "";
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
%>
<%
if(userightmenu_self==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onReSearch(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+"',handler:function(){onReSearch();}},";
	topButton +="'-',";
}
if(isSysadmin==1){
	topButton +="{iconCls:'btn_viewUrl',text:'"+SystemEnv.getHtmlLabelName(21682, user.getLanguage())+"',handler:function(){viewSourceUrl()}},";
	topButton +="'-',";
}
if(topButton.length()>5){
	topButton = topButton.substring(0,topButton.length()-5);
}
topButton = "["+topButton+"]";
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%@ include file="/docs/docs/DocCommExt.jsp"%>
<%@ include file="/systeminfo/TopTitleExt.jsp"%>
<script type="text/javascript" src="/js/WeaverTableExt.js"></script>  
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid.css" />
<script  language="javascript">	

	_pageId="DomnLogView";  
	_divSearchDiv='divSearch'; 
	_defaultSearchStatus='show';  //close //show //more
    //_divSearchDivHeight=70;
    userightmenu_self = '<%=userightmenu_self%>';
	if(userightmenu_self!=1){
		_divSearchDivHeightNo = 61;
		_divSearchDivHeight=100;
		<%if(userightmenu_self!=1){%>
		eval(rightMenuBarItem = <%=topButton%>);
		<%}%>
	}else{
		_divSearchDivHeightNo = 33;
		_divSearchDivHeight=100;
	}
	//_defaultSearchStatus='show';
</script>



<br>
<div id="divSearch" style="display:none">
<FORM id=report name=report action=DocDownloadLog.jsp method=post>
<TABLE width=100%  border="0" cellspacing="0" cellpadding="0">
 <tr>
	 <td valign="top">
	  <table class=ViewForm >
	      <tr style="height:2px" ><td class=Line colSpan=4></td></tr>
		  <tr>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></td>
		   <td CLASS="Field" width=22%>
			<INPUT  class=wuiBrowser  id="resource" 
				   _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				   _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
				   _displayText="<%=ResourceComInfo.getLastname(resource)%>"
				   id=resource type=hidden name=resource value="<%=resource%>">
		    </td>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
		   <td CLASS="Field" width=22%>
		     <BUTTON type="button" class=calendar id=SelectDate onclick="getfromDate()"></BUTTON>&nbsp;
			 <SPAN id=fromdatespan ><%=fromdate%></SPAN>
				  -&nbsp;&nbsp;
			 <BUTTON type="button" class=calendar id=SelectDate2 onclick="gettoDate()"></BUTTON>&nbsp;
			 <SPAN id=todatespan><%=todate%></SPAN>
			 <input type="hidden" name="fromdate" value="<%=fromdate%>">
			 <input type="hidden" name="todate" value="<%=todate%>">
		   </td>
		  </tr> 
		  <tr style="height: 1px;"><td class=Line colSpan=4></td></tr>
	</table>
   </td>
  </tr>
</TABLE>
</FORM>
</div>
<%out.println(xTable.toString2("_table"));%>
</BODY>
<script language=vbs>
sub onShowResource(tdname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
//		document.all(tdname).innerHtml =id(1)
		document.all(inputname).value=id(0)
		else
		document.all(tdname).innerHtml = empty
		document.all(inputname).value=""
		end if
	end if
end sub
</script>
<script>

function onReSearch(){
	report.submit();
}
</script>
<script  language="javascript">
var viewport
Ext.onReady(function(){
	var tab=new Ext.Panel({		
		activeTab: 0,	
		margins: '5 8 5 5',
		region: 'center',
        resizeTabs: true,
        tabWidth: 150,
        minTabWidth: 120,
        layout:'fit',
        border:false,
        enableTabScroll: true,
        plugins: new Ext.ux.TabCloseMenu(),       
        items: [_table.getGrid()]
	});
	viewport = new Ext.Viewport({
        layout: 'border',
        items: [ panelTitle, tab]    
    });   
    Ext.get('loading').fadeOut();    
    _table.load();
});


</script>
</HTML>
