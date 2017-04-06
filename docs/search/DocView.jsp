<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/docs/common.jsp" %>


 <%
	 ArrayList xTableColumnList=new ArrayList();
 %>
<!--声明结束-->

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<style type="text/css">
	.x-panel-tbar{
		width:auto !important;
	}
	#DocShare{
		width:auto !important;
	}
	#DocDetailLog{
		width:auto !important;
	}
</style>
</head>

<%



String userid=user.getUID()+"" ;
String loginType = user.getLogintype() ;
String userSeclevel = user.getSeclevel() ;
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
//初始化值
String doccreaterid = Util.null2String(request.getParameter("doccreaterid")) ;
String docstatus = Util.null2String(request.getParameter("docstatus"));
String maincategory = Util.null2String(request.getParameter("maincategory"));
String dspreply = Util.null2String(request.getParameter("dspreply")) ;
String docsubject = Util.null2String(request.getParameter("docsubject"));

//System.out.println("docsubject:"+docsubject);


/* edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 */
int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);

int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
String selectArr = "";
if(selectedContent!=null && selectedContent.startsWith("key_")){
	String menuid = selectedContent.substring(4);
	RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
	selectedContent = "";
	while(RecordSet.next()){
		String keyVal = RecordSet.getString(2);
		selectedContent += keyVal +"|";
	}
	if(selectedContent.indexOf("|")!=-1)
		selectedContent = selectedContent.substring(0,selectedContent.length()-1);
}
LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectArr = info.getSelectedContent();
}
if(!"".equals(selectedContent))
{
	selectArr = selectedContent;
}
String inMainCategoryStr = "";
String inSubCategoryStr = "";
String[] docCategoryArray = null;
if(fromAdvancedMenu==1){
	docCategoryArray = Util.TokenizerString2(selectArr,"|");
	if(docCategoryArray!=null&&docCategoryArray.length>0){
		for(int k=0;k<docCategoryArray.length;k++){
			if(docCategoryArray[k].indexOf("M")>-1)
				inMainCategoryStr += "," + docCategoryArray[k].substring(1);
			if(docCategoryArray[k].indexOf("S")>-1)
				inSubCategoryStr += "," + docCategoryArray[k].substring(1);
		}
		if(inMainCategoryStr.substring(0,1).equals(",")) inMainCategoryStr=inMainCategoryStr.substring(1);
		if(inSubCategoryStr.substring(0,1).equals(",")) inSubCategoryStr=inSubCategoryStr.substring(1);
	}
}
/* edited end */

if(doccreaterid.equals("")) doccreaterid = ""+user.getUID() ;
if(dspreply.equals("")) dspreply="1"; 
//页标题
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":" ;
if(user.getLogintype().equals("1"))
	titlename += ResourceComInfo.getResourcename(doccreaterid);
else
    titlename += CustomerInfoComInfo.getCustomerInfoname(doccreaterid);

String needfav ="1";
String needhelp ="";
%>
<!--声明开始 此断请不要修改  可以放在此处，也可放在此文件开始处-->


<%@ page import="weaver.common.xtable.*" %>
<%@ include file="/docs/docs/DocCommExt.jsp"%>
<%@ include file="/docs/DocDetailLog.jsp"%>

<%@ include file="/systeminfo/TopTitle.jsp"%>


<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid.css" />	

<%//  查询设置
DocSearchComInfo.resetSearchInfo() ;
DocSearchComInfo.setDoccreaterid(doccreaterid) ;
DocSearchComInfo.setOwnerid(doccreaterid) ;
DocSearchComInfo.setUsertype(user.getLogintype()) ;
if(!docstatus.equals(""))  DocSearchComInfo.addDocstatus(docstatus) ;
if(!maincategory.equals(""))  DocSearchComInfo.setMaincategory(maincategory) ;
if(!docsubject.equals(""))  DocSearchComInfo.setDocsubject(docsubject) ;


if ("0".equals(dspreply)) DocSearchComInfo.setContainreply("1");   //全部
else if("1".equals(dspreply)) DocSearchComInfo.setContainreply("0");   //非回复
else if ("2".equals(dspreply)) DocSearchComInfo.setIsreply("1");  //仅回复
//backFields
String backFields="t1.id,t1.seccategory,doclastmodtime,docsubject,t2.sharelevel,t1.docextendname,";
//from
String sqlFrom = "DocDetail  t1, "+tables+"  t2";
//where
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;

/* added by wdl 2006-08-28 不显示历史版本 */
whereclause+=" and (ishistory is null or ishistory = 0) ";
/* added end */

//whereclause+=" and t1.docStatus != 8 ";
whereclause+=" and t1.docStatus != 8 and t1.docStatus != 9 ";

/* added by wdl 2006-06-13 left menu advanced menu */
if((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))
	whereclause+=" and maincategory in (" + inMainCategoryStr + ") ";
if((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))
	whereclause+=" and subcategory in (" + inSubCategoryStr + ") ";
/* added end */

String sqlWhere = DocSearchManage.getShareSqlWhere(whereclause,user) ;
//orderBy
String orderBy = "doclastmoddate,doclastmodtime";
//primarykey
String primarykey = "t1.id";
//pagesize
UserDefaultManager.setUserid(user.getUID());
UserDefaultManager.selectUserDefault();
int pagesize = UserDefaultManager.getNumperpage();
if(pagesize <2) pagesize=10;
//colString
String colString ="";
if(displayUsage==0){
	colString += "<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";

	TableColumn xTableColumn_icon=new TableColumn();
	xTableColumn_icon.setColumn("docextendname");
	xTableColumn_icon.setDataIndex("docextendname");
	xTableColumn_icon.setHeader("&nbsp;&nbsp;");
	xTableColumn_icon.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName");
	xTableColumn_icon.setPara_1("column:docextendname");
	xTableColumn_icon.setSortable(false);
	xTableColumn_icon.setHideable(false);
	xTableColumn_icon.setWidth(0.03); 
	xTableColumnList.add(xTableColumn_icon);
}

colString +="<col name=\"id\" width=\"21%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"docsubject\" orderkey=\"docsubject\" target=\"_fullwindow\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" />";
TableColumn xTableColumn_DocName=new TableColumn();
xTableColumn_DocName.setColumn("docsubject");
xTableColumn_DocName.setDataIndex("docsubject");
xTableColumn_DocName.setHeader(SystemEnv.getHtmlLabelName(58,user.getLanguage()));
//xTableColumn_DocName.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocName");
//xTableColumn_DocName.setPara_1("column:id");
xTableColumn_DocName.setTarget("_fullwindow");
xTableColumn_DocName.setHref("/docs/docs/DocDsp.jsp");
xTableColumn_DocName.setLinkkey("id");
xTableColumn_DocName.setLinkvaluecolumn("id");
xTableColumn_DocName.setSortable(true);
xTableColumn_DocName.setWidth(0.5); 
xTableColumnList.add(xTableColumn_DocName);


//operateString
String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
//String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel";
String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel+column:id";
String operateString= "<operates width=\"18%\">";
       operateString+=" <popedom transmethod=\"weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2\"  otherpara=\""+popedomOtherpara+"\" otherpara2=\""+popedomOtherpara2+"\"></popedom> ";
       operateString+="     <operate href=\"/docs/docs/DocEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>";
       operateString+="     <operate href=\"javascript:doDocDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_fullwindow\" index=\"2\"/>";
       operateString+="     <operate href=\"javascript:doDocShare()\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" target=\"_fullwindow\" index=\"3\"/>";
       operateString+="     <operate href=\"javascript:doDocViewLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" target=\"_fullwindow\" index=\"4\"/>";       
       operateString+="</operates>";
TableOperatePopedom xTableOperatePopedom=new TableOperatePopedom();
xTableOperatePopedom.setTransmethod("weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2");
xTableOperatePopedom.setOtherpara(popedomOtherpara);
xTableOperatePopedom.setOtherpara2(popedomOtherpara2);

ArrayList xTableOperationList=new ArrayList();

TableOperation xTableOperation_Edit=new TableOperation();
xTableOperation_Edit.setHref("/docs/docs/DocEdit.jsp");
xTableOperation_Edit.setLinkkey("id");
xTableOperation_Edit.setLinkvaluecolumn("id");
xTableOperation_Edit.setText(SystemEnv.getHtmlLabelName(93,user.getLanguage()));
xTableOperation_Edit.setTarget("_fullwindow");
xTableOperation_Edit.setIndex("1");
xTableOperationList.add(xTableOperation_Edit);

TableOperation xTableOperation_Del=new TableOperation();
xTableOperation_Del.setHref("javascript:doDocDel()");
xTableOperation_Del.setText(SystemEnv.getHtmlLabelName(91,user.getLanguage()));
xTableOperation_Del.setTarget("_fullwindow");
xTableOperation_Del.setIndex("2");
xTableOperationList.add(xTableOperation_Del);

TableOperation xTableOperation_Share=new TableOperation();
xTableOperation_Share.setHref("javascript:doDocShare()");
xTableOperation_Share.setText(SystemEnv.getHtmlLabelName(119,user.getLanguage()));
xTableOperation_Share.setTarget("_fullwindow");
xTableOperation_Share.setIndex("3");
xTableOperationList.add(xTableOperation_Share);

TableOperation xTableOperation_Log=new TableOperation();
xTableOperation_Log.setHref("javascript:doDocViewLog()");
xTableOperation_Log.setText(SystemEnv.getHtmlLabelName(83,user.getLanguage()));
xTableOperation_Log.setTarget("_fullwindow");
xTableOperation_Log.setIndex("4");
xTableOperationList.add(xTableOperation_Log);

//  用户自定义设置
boolean dspcreater = false ;
boolean dspcreatedate = false ;
boolean dspmodifydate = false ;
boolean dspdocid = false;
boolean dspcategory = false ;
boolean dspaccessorynum = false ;
boolean dspreplynum = false ;


UserDefaultManager.setUserid(user.getUID());
UserDefaultManager.selectUserDefault();
Table xTable=new Table(request); 
if (UserDefaultManager.getHasdocid().equals("1")) {
    dspdocid = true;    
}
if (UserDefaultManager.getHascreater().equals("1")&&displayUsage==0) {
      dspcreater = true ;
      backFields+="ownerid,";
      colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\"  otherpara=\""+loginType+"\"/>";

	  TableColumn xTableColumn_Owner=new TableColumn();
	  xTableColumn_Owner.setColumn("ownerid");
	  xTableColumn_Owner.setDataIndex("ownerid");
	  xTableColumn_Owner.setHeader(SystemEnv.getHtmlLabelName(79,user.getLanguage()));
	  xTableColumn_Owner.setTransmethod("weaver.splitepage.transform.SptmForDoc.getName");
	  xTableColumn_Owner.setPara_1("column:ownerid");
	  xTableColumn_Owner.setPara_2(loginType);
	  xTableColumn_Owner.setSortable(true);
	  xTableColumn_Owner.setWidth(0.1); 
	  xTableColumnList.add(xTableColumn_Owner);
}
if (UserDefaultManager.getHascreatedate().equals("1")&&displayUsage==0) { 
    dspcreatedate = true ;
    backFields+="doccreatedate,";
    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";

	 TableColumn xTableColumn_Createdate=new TableColumn();
     xTableColumn_Createdate.setColumn("doccreatedate");
     xTableColumn_Createdate.setDataIndex("doccreatedate");
     xTableColumn_Createdate.setHeader(SystemEnv.getHtmlLabelName(722,user.getLanguage()));
     xTableColumn_Createdate.setSortable(true);
     xTableColumn_Createdate.setWidth(0.1); 
     xTableColumnList.add(xTableColumn_Createdate);
}
if (UserDefaultManager.getHascreatetime().equals("1")&&displayUsage==0) {
    dspmodifydate = true ;
    backFields+="doclastmoddate,";
    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";

	 TableColumn xTableColumn_Moddate=new TableColumn();
     xTableColumn_Moddate.setColumn("doclastmoddate");
     xTableColumn_Moddate.setDataIndex("doclastmoddate");
     xTableColumn_Moddate.setHeader(SystemEnv.getHtmlLabelName(723,user.getLanguage()));
     xTableColumn_Moddate.setSortable(true);
     xTableColumn_Moddate.setWidth(0.1); 
     xTableColumnList.add(xTableColumn_Moddate);

}
if (UserDefaultManager.getHascategory().equals("1")&&displayUsage==0) {   
    dspcategory = true ;
    backFields+="maincategory,";
    colString +="<col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory\" returncolumn=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";

	 TableColumn xTableColumn_Maincate=new TableColumn();
     xTableColumn_Maincate.setColumn("maincategory");
     xTableColumn_Maincate.setDataIndex("maincategory");
	 xTableColumn_Maincate.setTransmethod("weaver.splitepage.transform.SptmForDoc.getAllDirName");
	 xTableColumn_Maincate.setPara_1("column:id");
     xTableColumn_Maincate.setHeader(SystemEnv.getHtmlLabelName(92,user.getLanguage()));
     xTableColumn_Maincate.setSortable(true);
     xTableColumn_Maincate.setWidth(0.14); 
     xTableColumnList.add(xTableColumn_Maincate);
     
     
     xTable.setColumnWidth(54);	


}
if (UserDefaultManager.getHasreplycount().equals("1")&&displayUsage==0) {  
    dspreplynum = true ;
    backFields+="replaydoccount,";
    colString +="<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";

    TableColumn xTableColumn_ReplayDocCount = new TableColumn();
	xTableColumn_ReplayDocCount.setColumn("replaydoccount");
	xTableColumn_ReplayDocCount.setDataIndex("replaydoccount");
	xTableColumn_ReplayDocCount.setHeader(SystemEnv.getHtmlLabelName(18470, user.getLanguage()));
	xTableColumn_ReplayDocCount.setTransmethod("weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount");
	xTableColumn_ReplayDocCount.setPara_1("column:id");
	xTableColumn_ReplayDocCount.setPara_2("column:replaydoccount");
	xTableColumn_ReplayDocCount.setSortable(false);
	xTableColumn_ReplayDocCount.setWidth(0.07);
     xTableColumnList.add(xTableColumn_ReplayDocCount);


}
if (UserDefaultManager.getHasaccessorycount().equals("1")&&displayUsage==0) {  
    dspaccessorynum = true ;
    backFields+="accessorycount,";
    colString +="<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";


	 TableColumn xTableColumn_Accessorycount=new TableColumn();
     xTableColumn_Accessorycount.setColumn("accessorycount");
     xTableColumn_Accessorycount.setDataIndex("accessorycount");
     xTableColumn_Accessorycount.setHeader(SystemEnv.getHtmlLabelName(2002,user.getLanguage()));
     xTableColumn_Accessorycount.setWidth(0.07); 
	 xTableColumn_Accessorycount.setSortable(true);
     xTableColumnList.add(xTableColumn_Accessorycount);

}
	
backFields+="sumReadCount,docstatus";    

if(displayUsage==0) {
	colString +="<col width=\"7%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";

	 TableColumn xTableColumn_ReadCount=new TableColumn();
     xTableColumn_ReadCount.setColumn("sumReadCount");
     xTableColumn_ReadCount.setDataIndex("sumReadCount");
     xTableColumn_ReadCount.setHeader(SystemEnv.getHtmlLabelName(18469,user.getLanguage()));
     xTableColumn_ReadCount.setWidth(0.07); 
	 xTableColumn_ReadCount.setSortable(true);
     xTableColumnList.add(xTableColumn_ReadCount);


	//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\"  otherpara=\""+user.getLanguage()+"\"/>";
	//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\"  otherpara=\""+user.getLanguage()+"\"/>";
	colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\"  otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";

	TableColumn xTableColumn_DocStatus=new TableColumn();
	xTableColumn_DocStatus.setColumn("docstatus");
	xTableColumn_DocStatus.setDataIndex("docstatus");
	xTableColumn_DocStatus.setHeader(SystemEnv.getHtmlLabelName(602,user.getLanguage()));	 
	//xTableColumn_DocStatus.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus2");
	xTableColumn_DocStatus.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus3");
	xTableColumn_DocStatus.setPara_1("column:id");
	//xTableColumn_DocStatus.setPara_2(""+user.getLanguage());
	xTableColumn_DocStatus.setPara_2(""+user.getLanguage()+"+column:docstatus+column:seccategory");
	xTableColumn_DocStatus.setWidth(0.05); 
	xTableColumn_DocStatus.setSortable(true);
	 xTableColumnList.add(xTableColumn_DocStatus);
}
//默认为按文档创建日期排序所以,必须要有这个字段
if (backFields.indexOf("doclastmoddate")==-1) {
    backFields+=",doclastmoddate";
}

String tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+((displayUsage==0)?"none":"thumbnail")+"\">";//是否缩略图显示
	   tableString+=(displayUsage==0)?"":"<browser imgurl=\"/weaver/weaver.docs.docs.ShowDocsImageServlet\" linkkey=\"docId\" linkvaluecolumn=\"id\" />";//是否缩略图显示
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\"/>";
       tableString+="<head>"+colString+"</head>";
       tableString+=operateString;
       tableString+="</table>";

TableSql xTableSql=new TableSql();
xTableSql.setBackfields(backFields);
xTableSql.setPageSize(pagesize);
xTableSql.setSqlform(sqlFrom);
xTableSql.setSqlwhere(sqlWhere);
xTableSql.setSqlgroupby("");
xTableSql.setSqlprimarykey(primarykey);
xTableSql.setSqlisdistinct("true");
xTableSql.setDir(TableConst.DESC);
xTableSql.setSort(orderBy);

//System.out.println(orderBy);
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
if(userightmenu_self ==1||true){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}else{
	topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+"',handler:function(){onSearch();}},";
	topButton +="'-',";
	topButton +="{iconCls:'btn_first',text:'"+SystemEnv.getHtmlLabelName(18363, user.getLanguage())+"',handler:function(){_table.firstPage();}},";
	topButton +="'-',";
	topButton +="{iconCls:'btn_previous',text:'"+SystemEnv.getHtmlLabelName(1258, user.getLanguage())+"',handler:function(){_table.prePage();}},";
	topButton +="'-',";
	topButton +="{iconCls:'btn_next',text:'"+SystemEnv.getHtmlLabelName(1259, user.getLanguage())+"',handler:function(){_table.nextPage();}},";
	topButton +="'-',";
	topButton +="{iconCls:'btn_end',text:'"+SystemEnv.getHtmlLabelName(18362, user.getLanguage())+"',handler:function(){_table.lastPage();}},";
	topButton +="'-',";
	topButton +="{iconCls:'btn_back',text:'"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+"',handler:function(){window.history.go(-1);}},";
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

<script  language="javascript">	
	userightmenu_self = '<%=userightmenu_self%>';
	if(userightmenu_self!=1){
		_divSearchDivHeightNo = 61;
		_divSearchDivHeight=125;
		<%if(userightmenu_self!=1){%>
		eval(rightMenuBarItem = <%=topButton%>);
		<%}%>
	}else{
		_divSearchDivHeightNo = 33;
		_divSearchDivHeight=125;
	}
	_isViewPort=true;
	_pageId="DocView";  
	_divSearchDiv='divContent'; 
	_defaultSearchStatus='show';  //close //show //more
</script>		
		
<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0" valign="top">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<TD valign="top">
		<TABLE valign="top" style="width:100%"> 
		<TR>
            <TD valign="top">
			<div id="divContent" style="display:none;">
            <FORM name="frmSearch" method="post" action="DocView.jsp">    
                <TABLE class=ViewForm  valign="top">
                    <TR valign="top">		
						<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(19541,user.getLanguage())%></TD>
                         <TD CLASS="Field">
							<input type=text value="<%=docsubject%>" name="docsubject" style="width:60%"> 
                         </TD>
				
                        <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD>
                         <TD CLASS="Field">
                            <select width="30" name=maincategory style="width:60%">
                              <option value=""></option>
                              <%
                                 while(MainCategoryComInfo.next()){
                                    String isselect = "";
                                    String curid = MainCategoryComInfo.getMainCategoryid();
                                    String curname = MainCategoryComInfo.getMainCategoryname();
                                    if(maincategory.equals(curid)) isselect=" selected";
                                	/* added by wdl 2006-06-13 left menu advanced menu */
                                	if((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr)&&(inMainCategoryStr+",").indexOf(curid+",")==-1)
                                		continue;
                                	/* added end */
                              %>
                                    <option value="<%=curid%>" <%=isselect%>><%=curname%></option>
                              <%}%>
                              </select>
                         </TD>
					</TR>
					<TR style="height:1px;"><td colspan=4 class="line"></td></TR>
  					<!-- <TR valign="top"> -->
  					<TR>	
                         <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></TD>
                         <TD  WIDTH="20%" CLASS="Field">
                            <SELECT  class=InputStyle  name=dspreply style="width:60%">
                              <option value="0" <%if(dspreply.equals("0")) {%>selected<%}%>></option>
                              <option value="1" <%if(dspreply.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18467,user.getLanguage())%></option>
                              <option value="2" <%if(dspreply.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18468,user.getLanguage())%></option>
                            </SELECT>                          
                         </TD>
                         <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
                         <TD width ="20%" CLASS="Field"> 
                            <select name="docstatus" style="width:60%">
                                <option value=""></option>
                                <option value="0" <%if (docstatus.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
                                <option value="1" <%if (docstatus.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
                                <option value="2" <%if (docstatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%>)</option>
                                <option value="3" <%if (docstatus.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
                                <option value="4" <%if (docstatus.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
                                <option value="5" <%if (docstatus.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
                                <option value="6" <%if (docstatus.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
                                <option value="7" <%if (docstatus.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
                                <!-- <option value="8" <%if (docstatus.equals("8")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option> -->
                            </select>
                         </TD>
                    </TR>
					
                     <TR>
                         <TD valign="top"  colspan=6>
							<script type="text/javascript" src="/js/WeaverTablePlugins.js"></script> 
							<%-- edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 --%>
                            <% if(displayUsage==0&&false){
                            	//封装表格并显示表格
								
								xTable.setTableId("xTable_DocView");//必填而且与别的地方的Table不能一样
								xTable.setTableGridType(TableConst.NONE);
								//xTable.setTableGridType(TableConst.CHECKBOX);
								xTable.setTableNeedRowNumber(true);												
								xTable.setTableSql(xTableSql);
								xTable.setTableColumnList(xTableColumnList);
								xTable.setTableOperatePopedom(xTableOperatePopedom);
								xTable.setTableOperationList(xTableOperationList);
								xTable.setUser(user);
															
								out.println(xTable.toString2("_table"));
                            } else { %>
                            	<wea:SplitPageTag tableString="<%=tableString%>" mode="run" isShowThumbnail="" imageNumberPerRow="5"/>
                            <% } %>
                            <%-- edited by wdl end --%>
                          </TD>
                     </TR> 
                </TABLE>
                </FORM>
				  <FORM name="frmPostData" method="post" action="\docs\docs\DocOperate.jsp">
				        <input type="hidden" name="operation">
				        <input type="hidden" name="docid">
				        <input type="hidden"   name="redirectTo"  value="\docs\search\DocView.jsp">
				    </FORM>
				</div>
             </TD>
         </TR>            
         </TABLE>
    </TD>
    <td ></td>
</TR>
</TABLE>
  

</BODY>
</HTML>
<script language="javaScript">
    function onSearch(){
    /*
        if(_btnSearchStatusShow)  frmSearch.submit(); 
        else _onShowOrHidenSearch();    
    */    
        frmSearch.submit(); 
    }

    function doDocDel(docid){
        if (isdel()){
        	var url = "/docs/docs/DocOperate.jsp?operation=delete&docid="+docid;
        	
        	Ext.Ajax.request({
        		url : '/docs/docs/DocDwrProxy.jsp' , 
				params : {},
				url : url ,
				method: 'POST',
				success: function ( result, request) {
					alert(result.responseText.trim());
       				//Ext.Msg.alert('Status', result.responseText.trim());
       				_table.reLoad();
				},
				failure: function ( result, request) { 
					Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result); 
				} 
			});
        }
    }

    function doDocShare(docid){        
		var DocSharePane=new DocShareSnip(docid,true).getGrid();
		
        var winShare = new Ext.Window({
        	//id:'DocSearchViewWinLog',
	        layout: 'fit',
	        width: 650,
	        resizable: true,
	        height: 400, 
	        closeAction: 'hide',
	        //plain: true,
	        modal: true,
	        title: wmsg.doc.share,
	        items: DocSharePane,
	        autoScroll: true,
	        buttons: [{
	            text: wmsg.base.submit,// '确定',
	            handler: function(){
	        	winShare.hide();
	            }
	        }]
	    });
        winShare.show(null);
        //var url = "/docs/docs/DocOperate.jsp?operation=share&docid="+docid;
        //openFullWindowHaveBar(url);
    }

    function doDocViewLog(docid){
    	
    	var DocDetailLogPane=getDocDetailLogPane(docid,600,450,false); 
		
        var winLog = new Ext.Window({
        	//id:'DocSearchViewWinLog',
	        layout: 'fit',
	        width: 650,
	        resizable: true,
	        height: 400,
	        closeAction: 'hide',
	        //plain: true,
	        modal: true,
	        title: wmsg.doc.detailLog,
	        items: DocDetailLogPane,
	        autoScroll: true,
	        buttons: [{
	            text: wmsg.base.submit,// '确定',
	            handler: function(){
	                 winLog.hide();
	            }
	        }]
	    });
	    winLog.show(null);    
       
    }
</script>


<script type="text/javascript" src="/js/doc/DocShareSnip.js"></script>
<script  language="javascript">
var viewport
$(function(){
	Ext.get('loading').fadeOut();
    document.getElementById("divContent").style.display="block";
	
});
</script>


