<%@ page language="java" contentType="text/html; charset=GBK" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.file.*,java.math.BigDecimal" %>
<%@ page import="weaver.workflow.report.ReportCompositorOrderBean" %>
<%@ page import="weaver.workflow.report.ReportCompositorListBean" %>
 <%@ page import="weaver.workflow.report.ReportUtilComparator" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page"/>
<jsp:useBean id="ExpensefeeTypeComInfo" class="weaver.fna.maintenance.ExpensefeeTypeComInfo" scope="page"/>
<jsp:useBean id="MDCompanyNameInfo" class="weaver.workflow.report.ReportShare" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="resourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="WorkflowJspBean" class="weaver.workflow.request.WorkflowJspBean" scope="page"/>	
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<%
//报表id
String reportid = Util.null2String(request.getParameter("reportid")) ;

if(reportid.equals("")){
	reportid="0";
}

String[] checkcons =null;//报表条件
String[] isShowArray = null;//报表列
List isShowList=new ArrayList();//显示的列的字段id

String isbill = "1";
String formid = "0";
String reportname = "";
String modeid = "0";
String sql = "select a.reportname,b.formid,b.id from mode_Report a,modeinfo b where a.modeid = b.id and a.id = "+reportid;
RecordSet.execute(sql) ;
while(RecordSet.next()){
	formid = Util.null2String(RecordSet.getString("formId"));
	reportname = Util.null2String(RecordSet.getString("reportname"));
	modeid = Util.null2String(RecordSet.getString("id"));
}

List fieldids = new ArrayList() ;
List fields = new ArrayList() ;
List fieldnames = new ArrayList() ;

List htmltypes = new ArrayList() ;
List types = new ArrayList() ;
List isstats = new ArrayList() ;
List statvalues = new ArrayList() ;
List tempstatvalues = new ArrayList() ;
List isdetails = new ArrayList() ;//add by wang jinyong
String requestid = ""; //add by wang jinyong
boolean isnew = true; //add by wang jinyong
List isdborders = new ArrayList() ;

ArrayList compositorOrderList = new ArrayList() ;//addsed by xwj for td2099 on 2005-06-08
ArrayList compositorColList = new ArrayList() ;//addsed by xwj for td2451 on 2005-11-14
ArrayList compositorColList2 = new ArrayList() ;//addsed by xwj for td2451 on 2005-11-14

List ids = new ArrayList();
List isMains = new ArrayList();
List isShows = new ArrayList();
List isCheckConds = new ArrayList();
List colnames = new ArrayList();
List htmlTypes = new ArrayList();
List typeTemps = new ArrayList();
List opts = new ArrayList();
List values = new ArrayList();
List names = new ArrayList();
List opt1s = new ArrayList();
List value1s = new ArrayList();


checkcons = request.getParameterValues("check_con");//报表条件
isShowArray = request.getParameterValues("isShow");//报表列

if(isShowArray!=null){
    for(int i=0;i<isShowArray.length;i++){
	    isShowList.add(isShowArray[i]);
    }
}

String modedatacreatedateIsShow = request.getParameter("modedatacreatedateIsShow");
String modedatacreateIsShow = request.getParameter("modedatacreateIsShow");

if(modedatacreatedateIsShow!=null&&modedatacreatedateIsShow.equals("1")){
	isShowList.add("-1");
}

if(modedatacreateIsShow!=null&&modedatacreateIsShow.equals("1")){
	isShowList.add("-2");
}

//传递过来的LIST值
String showListStr = Util.StringReplace(Util.StringReplace(Util.StringReplace(Util.null2String(request.getParameter("isShowList")),"[",","),"]",",")," ","");
isShowList = Util.TokenizerString(showListStr, ",");

String sqlrightwhere = "";
String temOwner = "";


String tablename = "workflow_form" ;
String detailtablename = "" ;
String detailkeyfield = "" ;
int maincount = 0 ;
int detailcount = 0 ;
int ordercount = 0 ;
int statcount = 0 ;
String fieldname = "" ;
String orderbystr = "" ;
ReportCompositorOrderBean reportCompositorOrderBean = new ReportCompositorOrderBean(); //added by xwj for td2099 on 2005-06-08
ReportCompositorListBean rcListBean = new ReportCompositorListBean();//added by xwj for td2451 20051114
ReportCompositorListBean rcColListBean = new ReportCompositorListBean();//added by xwj for td2451 20051114


	//只有显示请求说明时才执行下面的操作
	if(isShowList.indexOf("-1")!=-1){
		rs1.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = -1");
		if(rs1.next()){
		    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
		    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
		    rcListBean.setSqlFlag("a");//xwj for td2451 20051114
		    rcListBean.setFieldName("modedatacreatedate");//xwj for td2451 20051114
		    rcListBean.setFieldId("-1");//xwj for td2451 20051114
		    rcListBean.setColName(SystemEnv.getHtmlLabelName(722,user.getLanguage()));//xwj for td2451 20051114
			compositorColList.add(rcListBean);//xwj for td2451 20051114
		    fields.add("modedatacreatedate");
		    if("1".equals(rs1.getString("dborder"))){
		        reportCompositorOrderBean = new ReportCompositorOrderBean();
		        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
				reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
				reportCompositorOrderBean.setFieldName("modedatacreatedate");
				reportCompositorOrderBean.setSqlFlag("a");
				compositorOrderList.add(reportCompositorOrderBean);
		    }
		}
	}

	 //只有显示紧急程度时才执行下面的操作
	if(isShowList.indexOf("-2")!=-1){    
		rs1.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = -2");
		if(rs1.next()){
	      rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
		    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
		    rcListBean.setSqlFlag("a");//xwj for td2451 20051114
		    rcListBean.setFieldName("modedatacreater");//xwj for td2451 20051114
		    rcListBean.setFieldId("-2");//xwj for td2451 20051114
		    rcListBean.setColName(SystemEnv.getHtmlLabelName(882,user.getLanguage()));
		    compositorColList.add(rcListBean);//xwj for td2451 20051114
		    fields.add("modedatacreater");
		    if("1".equals(rs1.getString("dborder"))){
		        reportCompositorOrderBean = new ReportCompositorOrderBean();
		        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
				reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
				reportCompositorOrderBean.setFieldName("modedatacreater");
				reportCompositorOrderBean.setSqlFlag("a");
				compositorOrderList.add(reportCompositorOrderBean);
		    }
		}
	}
	
	sql = " select a.fieldname , c.labelname, a.fieldhtmltype, a.type, b.isstat , a.viewtype , b.dborder , a.id , b.dbordertype , b.compositororder, b.dsporder, a.detailtable as detailtable from  workflow_billfield a, mode_ReportDspField b , HtmlLabelInfo c " +
       " where a.id = b.fieldid and a.fieldlabel = c.indexid and b.reportid = " + reportid +" and  c.languageid = " + user.getLanguage() + " order by b.dsporder " ;
	RecordSet.execute(sql) ;
	while(RecordSet.next()) {

		if(isShowList.indexOf(Util.null2String(RecordSet.getString(8)))==-1){
			continue;
		}

     String viewtype = Util.null2String(RecordSet.getString(6)) ;
     if(viewtype.equals("1")) {
		viewtype = Util.null2String(RecordSet.getString("detailtable")) ;
		detailcount ++ ;
     }
     else {
         viewtype ="a" ; // "a." --> "a"   xwj for td2131 on 2005-06-20
         maincount ++ ;
     }

     /*-----  xwj for td2974 20051026   B E G I N  ---*/
     rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
     rcListBean.setCompositorList(RecordSet.getDouble(11));//xwj for td2451 20051114
     rcListBean.setSqlFlag(viewtype);//xwj for td2451 20051114
     rcListBean.setFieldName(Util.null2String(RecordSet.getString(1)));//xwj for td2451 20051114
     rcListBean.setFieldId(Util.null2String(RecordSet.getString(8)));//xwj for td2451 20051114
     rcListBean.setColName(Util.toScreen(RecordSet.getString(2),user.getLanguage()));//xwj for td2451 20051114
	      compositorColList.add(rcListBean);//xwj for td2451 20051114
     fields.add(Util.null2String(RecordSet.getString(1))) ;

     if(Util.null2String(RecordSet.getString(7)).equals("1")) {
         reportCompositorOrderBean = new ReportCompositorOrderBean();
         reportCompositorOrderBean.setCompositorOrder(RecordSet.getInt(10));
         reportCompositorOrderBean.setOrderType(Util.null2String(RecordSet.getString(9)));
         reportCompositorOrderBean.setFieldName(Util.null2String(RecordSet.getString(1)));
         reportCompositorOrderBean.setSqlFlag(viewtype);
         compositorOrderList.add(reportCompositorOrderBean);
     }

 }
 compositorColList2 = ReportComInfo.getCompositorList(compositorColList); //xwj for td2451 on 2005-11-14
 for(int a = 0; a < compositorColList2.size(); a++){
 rcColListBean = (ReportCompositorListBean)compositorColList2.get(a);
 RecordSet.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = " +rcColListBean.getFieldId());
 if(RecordSet.next()){
 
 String  tempfieldid = RecordSet.getString("fieldid");
 if("-1".equals(tempfieldid) || "-2".equals(tempfieldid)){
 htmltypes.add(tempfieldid);
 types.add(tempfieldid);
 isdetails.add("");
 }
 else{
 rs3.executeSql("select formid from mode_report b where   b.id = "+ reportid);
 if(rs3.next()){
 rs2.executeSql("select * from workflow_billfield where id = " + tempfieldid + " and billid=" + rs3.getString("formid"));
 if(rs2.next()){
  htmltypes.add(Util.null2String(rs2.getString("fieldhtmltype")));
  types.add(Util.null2String(rs2.getString("type")));
  String detailtabletmp = Util.null2String(rs2.getString("detailtable"));
  if(!"".equals(detailtabletmp)){
 	 isdetails.add("1");
  }else{
 	 isdetails.add("");
  }
 }
 }
 }
 fieldids.add(tempfieldid);
 if(Util.null2String(RecordSet.getString("isstat")).equals("1")) {
         statcount ++ ;
         isstats.add("1") ;
 }
 else{ 
   isstats.add("") ;
 }
 statvalues.add("") ;
 tempstatvalues.add("") ;
  if(Util.null2String(RecordSet.getString("dborder")).equals("1")) {
         ordercount ++ ;
         isdborders.add("1") ;
 }
 else{ 
   isdborders.add("") ;
 }
}
 } //xwj for td2451 on 2005-11-14 
 fieldname =  ReportComInfo.getCompositorListByStrs(compositorColList)+",c.requestid"; //xwj for td2451 on 2005-11-14
 orderbystr = ReportComInfo.getCompositorOrderByStrs(compositorOrderList); //added by xwj for td2099 on2005-06-08
 
	sql = " select tablename , detailtablename , detailkeyfield from workflow_bill where id = " + formid ;
	RecordSet.execute(sql) ;
	RecordSet.next() ;
	tablename = Util.null2String(RecordSet.getString(1)) ;
	detailtablename = Util.null2String(RecordSet.getString(2)) ;
	detailkeyfield = Util.null2String(RecordSet.getString(3)) ;
	detailtablename = "";
	RecordSet.executeSql("select tablename from workflow_billdetailtable where billid="+formid);
	while(RecordSet.next()){
		detailtablename += RecordSet.getString("tablename")+",";
	}

sql = request.getParameter("pmSql");

int pageSize = Util.getIntValue((String)request.getParameter("pageSize"), 20);
int currentPage = Util.getIntValue((String)request.getParameter("currentPage"), 1);
int rowcount = 0;
int pageCount = 0;
String dbType = RecordSet.getDBType();
String countsql = "";
if ("sqlserver".equals((dbType))) {
	countsql = "select count(1) as count from (" + " SELECT TOP 100 PERCENT t1.* from (" + sql + ") t1 ) tbl_1";
} else {
	countsql = "select count(1) as count from (" + sql + ") tbl_1";
}

RecordSet.execute(countsql);
if (RecordSet.next()) {
	rowcount = Util.getIntValue(RecordSet.getString("count"));
}

if(rowcount % pageSize == 0) {
	pageCount = rowcount / pageSize;
} else {
	pageCount = rowcount / pageSize + 1;
}

int tmpPageSize = pageSize;

if (rowcount - currentPage * pageSize < 0) {
	tmpPageSize = currentPage * pageSize - rowcount;
}

String tmpTblName = null;

StringBuffer splitPageSql = new StringBuffer();

if ("sqlserver".equals((dbType))) {
	
	tmpTblName = "TEMP_TBL_RPTDATA_" + new Date().getTime();
	StringBuffer splitinertSql = new StringBuffer();
	
	splitinertSql.append("SELECT *, identity(int,1,1) as rptRltSltId into " + tmpTblName + " FROM (");
	splitinertSql.append(" select top " + pageSize * currentPage + " * from  (    ");
	splitinertSql.append(" SELECT TOP 100 PERCENT t1.* from (" + sql + ") t1");
	splitinertSql.append("    ) tbl");
	splitinertSql.append(") tbl");
	RecordSet.execute(splitinertSql.toString());
	if (currentPage == 1) {
		splitPageSql.append(" select top " + pageSize + " * from ");
		splitPageSql.append(tmpTblName);
	} else {
		splitPageSql.append(" select * from ");
		splitPageSql.append(tmpTblName);
		splitPageSql.append(" where rptRltSltId > ");
		splitPageSql.append((currentPage - 1) * pageSize);
	}
} else {
	splitPageSql.append(" SELECT * FROM ");
	splitPageSql.append(" (");
	splitPageSql.append(" SELECT A.*, ROWNUM RN ");
	splitPageSql.append(" FROM (SELECT * FROM (" + sql + ")) A ");
	splitPageSql.append(" WHERE ROWNUM <= " + currentPage * pageSize + "");
	splitPageSql.append(" )");
	splitPageSql.append(" WHERE RN > " + (currentPage - 1) * pageSize + "");
}


String oldsql = sql;
sql = splitPageSql.toString();

Map statisticsRowKv = new HashMap();
List rowNames = new ArrayList();

%>

<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<table width=100% border="0" cellspacing="0" cellpadding="0" >
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
	<td colspan="3">
		<div style="width:100%;text-align:right;">
			<span style="TEXT-DECORATION:none;height:21px;padding-top:2px;">&raquo; 共<%=rowcount %>条记录&nbsp;&nbsp;&nbsp;每页<%=pageSize %>条</span>
			<% 
			String topSplitPageStr = getSplitPageString(pageSize, currentPage, rowcount, pageCount, "top");
			out.print(topSplitPageStr);
    		%>
    
		</div>
	</td>
</tr>
		<tr>
		<td valign="top">


<TABLE class=liststyle cellspacing=1 id="reportDateTbl" style="table-Layout:fixed;">
  <COLGROUP>
  <TBODY>
  <TR class="HeaderForXtalbe">
  
 <th colSpan=<%=fields.size()%>> <p align="center"><%=reportname%> </p></th>
      
  </TR>
  <TR class="HeaderForXtalbe">
  <%
	ExcelSheet es = new ExcelSheet() ;
	ExcelRow er = es.newExcelRow () ;
  
   ArrayList colList = ReportComInfo.getCompositorList(compositorColList);
   for(int i = 0; i < colList.size(); i++) {
	    rcColListBean = (ReportCompositorListBean) colList.get(i);
	    er.addStringValue(rcColListBean.getColName()) ;
  %>
    <TH style="height: 38px;width:<%=100/colList.size() + "%"%>" title="<%=rcColListBean.getColName()%>"><%=rcColListBean.getColName()%></TH>
    <%
    }
	es.addExcelRow(er) ;
    %>
  </TR>
<%
   	String useddetailtable = Util.null2String(request.getParameter("useddetailtable"));
    int needchange = 0;
    String tempvalue = "";
    String tempdbordervalue = "" ;
    boolean needstat = false ;
    boolean isfirst = true ;
    if(!"".equals(useddetailtable)) useddetailtable = useddetailtable.substring(1);
    detailtablename = useddetailtable;
    ArrayList detailtablenameList = Util.TokenizerString(detailtablename, ",");
    int details = detailtablenameList.size();
    String[] detailids = null;
    if(details>0) detailids = new String[details];
    for(int flag=0;flag<details;flag++){
        detailids[flag] = ",";
    }
    
    if(details>0){
        String tempsql = "select t1.id from ("+sql+") t1";
        RecordSet.executeSql(tempsql);
        ArrayList requestids = new ArrayList();
        while(RecordSet.next()){
        	if (!requestids.contains(RecordSet.getString("id"))) {
            	requestids.add(RecordSet.getString("id"));
        	}
        }
        for(int rqflag=0;rqflag<requestids.size();rqflag++){
            String thisrequestid = (String)requestids.get(rqflag);
            boolean firstrequest = true;
        	for(int indexflag=0;indexflag<details;indexflag++){
	            String thisrowflag = (String)detailtablenameList.get(indexflag);
	            thisrowflag = thisrowflag.toUpperCase();
	            String thisdetailids = ",";
            
          		RecordSet.executeSql("select * from (" + sql + ") tbl where tbl.id=" + thisrequestid);
        		while(RecordSet.next()){
            		String thisdetailrequestid = RecordSet.getString("id");
            		if(!thisrequestid.equals(thisdetailrequestid)) {
            			continue;
            		}
					String thisdetailid = RecordSet.getString(thisrowflag + "_id_");
            		if((RecordSet.getCounts() == 1 && !firstrequest && "".equals(thisdetailid)) || (RecordSet.getCounts() > 1 && thisdetailid.equals("")) || thisdetailids.indexOf(","+thisdetailid+",")>-1){
            			continue;
            		}
           			firstrequest = false;
            		thisdetailids += thisdetailid+",";
			        if(ordercount == 1) {
			            for(int i =0 ; i< fields.size() ; i++) {
			                if(((String)isdborders.get(i)).equals("1")) {
			                    tempvalue = Util.null2String(RecordSet.getString(i+1));
			                    if(!tempvalue.equals(tempdbordervalue)) {
			                        needstat = true ;
			                        tempdbordervalue = tempvalue ;
			                    }
			                    else {
			                        needstat = false ;
			                    }
			                }
			            }
			        }
        
			        if(ordercount > 1){
			            List list  = new ArrayList();
			            for(int i =0 ; i< fields.size() ; i++) {
			                if(((String)isdborders.get(i)).equals("1")) {
			                     tempvalue += Util.null2String(RecordSet.getString(i+1));
			                }
						}
			          
			              if(!tempvalue.equals(tempdbordervalue)) {
			                        needstat = true ;
			                        tempdbordervalue = tempvalue ;
			                    }
			                    else {
			                        needstat = false ;
			                    }
			           tempvalue = "";
			        }

        			isfirst = false ;
       				er = es.newExcelRow () ;
       				if(needchange ==0){
       					needchange = 1;
		%>
  						<TR class=datalight style="word-wrap:break-word;word-break:break-all;">
		<%
  					}else{
  						needchange=0;
		%>
						<TR class=datadark style="word-wrap:break-word;word-break:break-all;">
		<%
					}
		%>
		<%
					String temRequestid = RecordSet.getString("id");
					if(!temRequestid.equals(requestid)){
						isnew = true;
						requestid = temRequestid;
					}else{
						isnew = false;
					}

					String leavetype = "";
					for(int i =0 ; i< fields.size() ; i++) {
						String result = Util.null2String(RecordSet.getString(i+1)) ;
						String tcolname= RecordSet.getColumnName(i+1);
						if(tcolname.indexOf("__")>0&&tcolname.toUpperCase().indexOf(thisrowflag)==-1) {
							result = "";
						}
						String htmltype = (String)htmltypes.get(i);
						int type = Util.getIntValue((String)types.get(i)) ;
						String results[] = null ;
      
						if(htmltype.equals("-2")) {
							result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
						}
    
						if(htmltype.equals("3")) {
        					switch (type) {
					            case 1:
					                result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
					                break ;
					            case 23:
					                result = Util.toScreen(CapitalComInfo.getCapitalname(result),user.getLanguage()) ;
					                break ;
					            case 4:
					                result = Util.toScreen(DepartmentComInfo.getDepartmentname(result),user.getLanguage()) ;
					                break ;
					            case 6:
					                result = Util.toScreen(CostcenterComInfo.getCostCentername(result),user.getLanguage()) ;
					                break ;
					            case 7:
					                result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(result),user.getLanguage()) ;
					                break ;
					            case 8:
					                result = Util.toScreen(ProjectInfoComInfo.getProjectInfoname(result),user.getLanguage()) ;
					                break ;
					            case 9:
					                result = Util.toScreen(DocComInfo.getDocname(result),user.getLanguage()) ;
					                break ;
					            case 12:
					                result = Util.toScreen(CurrencyComInfo.getCurrencyname(result),user.getLanguage()) ;
					                break ;
					            case 25:
					                result = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(result),user.getLanguage()) ;
					                break ;
					            case 14:
					            case 15:
					                result = Util.toScreen(LedgerComInfo.getLedgername(result),user.getLanguage()) ;
					                break ;
					            case 16:
					                result = Util.toScreen(RequestComInfo.getRequestname(result),user.getLanguage()) ;
					                break ;
					            case 17:
					                results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break ;
					            case 18:
					                results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break ;
					            case 24:
					                result = Util.toScreen(JobTitlesComInfo.getJobTitlesname(result),user.getLanguage()) ;
					                break ;
					            case 37:            // 增加多文档处理
					                results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break ;
					             case 57:            // 增加多部门处理
					                results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break ;
					            case 2:
					                break ;
					            case 19:
					                break ;
					            case 42:      //分部
					                result = Util.toScreen(SubCompanyComInfo.getSubCompanyname(result),user.getLanguage()) ;
					                break ;
				                
					            case 65: //多角色处理 added xwj for td2127 on 2005-06-20
					                Map roleMap  = new HashMap(); 
					                String sql_  = "select ID,RolesName from HrmRoles";
					                rs.executeSql(sql_);
					                while(rs.next()){
					                   roleMap.put(rs.getString("ID"),rs.getString("RolesName"));
					                }
					                results = Util.TokenizerString2(result,",");
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen((String)roleMap.get(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen((String)roleMap.get(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break ;
					            case 141:
					            //人力资源条件
					            	result = resourceConditionManager.getFormShowName(result, user.getLanguage());            
					                break;
					            case 142:
					            //收发文单位
					                results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break;
					            case 143:
					            //树状文档
					            	results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                    for(int j=0 ; j< results.length ; j++) {
					                        if(j==0)
					                            result = Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
					                        else
					                            result += ","+ Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
					                    }
					                }
					                break;
					            case 152:
					            //多请求
					            	results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                		result = "";
					                    for(int j=0 ; j< results.length ; j++) {
					                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
					                       rs.executeSql(sql2);
							                   while(rs.next()){
							                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
							                   }
					                    }
					                    if(!result.equals("")) result = result.substring(0,result.length()-1);
					                }
					                break;
					            case 135:
					            //多项目
					            	results = Util.TokenizerString2(result,",") ;
					                if(results != null) {
					                		result = "";
					                    for(int j=0 ; j< results.length ; j++) {
					                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
					                       rs.executeSql(sql2);
							                   while(rs.next()){
							                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
							                   }
					                    }
					                    if(!result.equals("")) result = result.substring(0,result.length()-1);
					                }
					                break;
					            case 161:
								case 162:
					            //自定义单选,多选
					                if(!result.equals("")) {
									//获取字段的数据库类型
									String tempfid=(String)fieldids.get(i);
									String tempfdbtype="";
										rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
					                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
					                    result=WorkflowJspBean.getWorkflowBrowserShowName(result,""+type,"","",tempfdbtype);
									}
					                if (type==162) 
										{
										if(!result.equals("")) result = result.substring(0,result.length()-1);
										}
					                break; 
					            default:
									results = Util.TokenizerString2(result,",") ;
									if(results != null) {
											result = "";
					                    for(int j=0 ; j< results.length ; j++) {
					                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
										   rs.executeSql(sql2);
							                   while(rs.next()){
							                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
							                   }
					                    }
										if(!result.equals("")) result = result.substring(0,result.length()-1);
									}
       						}
    					}
    
						if(htmltype.equals("5"))
					    // 选择框字段
					    {
					        char flag = Util.getSeparator();
					        if(!result.equals("")){
					        	rs.executeProc("workflow_SelectItemSByvalue", (String)fieldids.get(i) + flag + isbill + flag + result);
						        if(rs.next())
						        {
						            result = Util.toScreen(rs.getString("selectname"), user.getLanguage());
						        }
						        else
						        {
						            result = "";
						        }
      						}else{
      	 						result = "";
							}
						}
						if(htmltype.equals("6")) {  // 增加文件上传 added xwj for td2127 on 2005-06-20
	       					switch (type) {
	        					case 1:           
						            result = Util.toScreen(DocComInfo.getMuliDocName(result),user.getLanguage());
						            break ;
	        					case 2:           
						            result = Util.toScreen(DocComInfo.getMuliDocName(result),user.getLanguage());
						            break ;
						        default:
	        				}
	    				}
						
					    if (!rowNames.contains(RecordSet.getColumnName(i + 1))) {
					    	rowNames.add(RecordSet.getColumnName(i + 1));
					    }
        
					    if(((String)isstats.get(i)).equals("1")) {
					
					        double resultdouble = Util.getDoubleValue((String)statvalues.get(i) , 0) ;
					        double tempresultdouble = Util.getDoubleValue((String)tempstatvalues.get(i) , 0) ;
					        
					        statisticsRowKv.put(RecordSet.getColumnName(i + 1), Boolean.valueOf(!isdetails.get(i).equals("1")));
					        
					        if(!isdetails.get(i).equals("1")){
					            if(isnew){
					                resultdouble += Util.getDoubleValue(result , 0) ;
					                tempresultdouble += Util.getDoubleValue(result , 0) ;
					                requestid = temRequestid;
					                statvalues.set(i, ""+resultdouble) ;
					                tempstatvalues.set(i, ""+tempresultdouble) ;
					            }else{
					                result = "0";
					            }
					        }else{
					            resultdouble += Util.getDoubleValue(result , 0) ;
					            tempresultdouble += Util.getDoubleValue(result , 0) ;
					            requestid = temRequestid;
					            statvalues.set(i, ""+resultdouble) ;
					            tempstatvalues.set(i, ""+tempresultdouble) ;
					        }
					    }
  		%>
    
    	<% 
						String tempTdTextValue = "";
						if(!((String)isdborders.get(i)).equals("1") || ((String)isdborders.get(i)).equals("1") && (needstat||statcount== 0) ) { 
							if(htmltype.equals("1") && (type==3)) {
			    				tempTdTextValue=formatData(result);
								er.addValue(formatData(result)) ;
							}else{
			        			tempTdTextValue=result;
								String tempString = Util.StringReplace(Util.getTxtWithoutHTMLElement(FieldInfo.toExcel(result)),"%nbsp;"," ");
				    			tempString = Util.StringReplace(tempString,"&dt;&at;"," ");
								tempString = Util.StringReplace(tempString,"&amp;","&");
			         			if((htmltype.equals("1")&&type==1)||htmltype.equals("2")){ 
			         				er.addStringValue(tempString) ;
			         			} else {
			         				er.addValue(tempString) ;
			         			}
							}
						} else {
							tempTdTextValue=result;
							er.addValue(formatData(result)) ;
						}
		%>
							<TD style="" ><%=delHtml(tempTdTextValue) %></TD>
		<%
					}

		%>
						</TR>
		<%
    				es.addExcelRow(er) ;
				}
			}
		}
	}else{
    	RecordSet.execute(sql);
      	while(RecordSet.next()){
	        if(ordercount == 1) {
	            for(int i =0 ; i< fields.size() ; i++) {
	                if(((String)isdborders.get(i)).equals("1")) {
	                    tempvalue = Util.null2String(RecordSet.getString(i+1));
	                    if(!tempvalue.equals(tempdbordervalue)) {
	                        needstat = true ;
	                        tempdbordervalue = tempvalue ;
	                    }
	                    else {
	                        needstat = false ;
	                    }
	                }
	            }
	        }
			if(ordercount > 1){
            	List list  = new ArrayList();
            	for(int i =0 ; i< fields.size() ; i++) {
                	if(((String)isdborders.get(i)).equals("1")) {
						tempvalue += Util.null2String(RecordSet.getString(i+1));
					}
           		}
          
				if(!tempvalue.equals(tempdbordervalue)) {
					needstat = true ;
					tempdbordervalue = tempvalue ;
				} else {
					needstat = false ;
				}
				tempvalue = "";
			}
  
			if(needstat && statcount != 0 && !isfirst ) {
            	er = es.newExcelRow () ;
		%>
				<TR class=TOTAL style="FONT-WEIGHT: bold">
		<% 
				for(int i =0 ; i< tempstatvalues.size() ; i++) {
					er.addValue(formatData((String)tempstatvalues.get(i))) ;
		%>
            		<TD><%=formatData((String)tempstatvalues.get(i))%></TD>
		<%
					tempstatvalues.set(i,"") ; 
				}
				es.addExcelRow(er) ;
		%>
				</tr>
        <%
			}
        	isfirst = false ;
        	er = es.newExcelRow () ;
			if(needchange ==0){
				needchange = 1;
		%>
  				<TR class=datalight>
		<%
			}else{
  				needchange=0;
		%>
				<TR class=datadark>
		<%
			}
			String temRequestid = RecordSet.getString("requestid");
			if(!temRequestid.equals(requestid)){
				isnew = true;
				requestid = temRequestid;
			}else{
				isnew = false;
			}
  			String leavetype = "";
			for(int i =0 ; i< fields.size() ; i++) {
				String result = Util.null2String(RecordSet.getString(i+1)) ;  	
				String tcolname= RecordSet.getColumnName(i+1);
				String htmltype = (String)htmltypes.get(i);
				int type = Util.getIntValue((String)types.get(i)) ;

				String results[] = null ;
      
				if(htmltype.equals("-2")) {
					result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
				}
    
				if(htmltype.equals("3")) {
			        switch (type) {
			            case 1:
			                result = Util.toScreen(ResourceComInfo.getResourcename(result),user.getLanguage()) ;
			                break ;
			            case 23:
			                result = Util.toScreen(CapitalComInfo.getCapitalname(result),user.getLanguage()) ;
			                break ;
			            case 4:
			                result = Util.toScreen(DepartmentComInfo.getDepartmentname(result),user.getLanguage()) ;
			                break ;
			            case 6:
			                result = Util.toScreen(CostcenterComInfo.getCostCentername(result),user.getLanguage()) ;
			                break ;
			            case 7:
			                result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(result),user.getLanguage()) ;
			                break ;
			            case 8:
			                result = Util.toScreen(ProjectInfoComInfo.getProjectInfoname(result),user.getLanguage()) ;
			                break ;
			            case 9:
			                result = Util.toScreen(DocComInfo.getDocname(result),user.getLanguage()) ;
			                break ;
			            case 12:
			                result = Util.toScreen(CurrencyComInfo.getCurrencyname(result),user.getLanguage()) ;
			                break ;
			            case 25:
			                result = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(result),user.getLanguage()) ;
			                break ;
			            case 14:
			            case 15:
			                result = Util.toScreen(LedgerComInfo.getLedgername(result),user.getLanguage()) ;
			                break ;
			            case 16:
			                result = Util.toScreen(RequestComInfo.getRequestname(result),user.getLanguage()) ;
			                break ;
			            case 17:
			                results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+Util.toScreen(ResourceComInfo.getResourcename(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break ;
			            case 18:
			                results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break ;
			            case 24:
			                result = Util.toScreen(JobTitlesComInfo.getJobTitlesname(result),user.getLanguage()) ;
			                break ;
			            case 37:            // 增加多文档处理
			                results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break ;
			             case 57:            // 增加多部门处理
			                results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen(DepartmentComInfo.getDepartmentname(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break ;
			            case 2:
			                break ;
			            case 19:
			                break ;
			            case 42:      //分部
			                result = Util.toScreen(SubCompanyComInfo.getSubCompanyname(result),user.getLanguage()) ;
			                break ;
			                
			            case 65: //多角色处理 added xwj for td2127 on 2005-06-20
			                Map roleMap  = new HashMap(); 
			                String sql_  = "select ID,RolesName from HrmRoles";
			                rs.executeSql(sql_);
			                while(rs.next()){
			                   roleMap.put(rs.getString("ID"),rs.getString("RolesName"));
			                }
			                results = Util.TokenizerString2(result,",");
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen((String)roleMap.get(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen((String)roleMap.get(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break ;
             
			            case 141:
			            //人力资源条件
			            	result = resourceConditionManager.getFormShowName(result, user.getLanguage());            
			                break;
			            case 142:
			            //收发文单位
			                results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen(DocReceiveUnitComInfo.getReceiveUnitName(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break;
			            case 143:
			            	//树状文档
			            	results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0)
			                            result = Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
			                        else
			                            result += ","+ Util.toScreen(DocTreeDocFieldComInfo.getTreeDocFieldName(results[j]),user.getLanguage()) ;
			                    }
			                }
			                break;
			            case 152:
			            	//多请求
			            	results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                		result = "";
			                    for(int j=0 ; j< results.length ; j++) {
			                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
			                       rs.executeSql(sql2);
					                   while(rs.next()){
					                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
					                   }
			                    }
			                    if(!result.equals("")) result = result.substring(0,result.length()-1);
			                }
			                break;
			            case 135:
			            	//多项目
			            	results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                		result = "";
			                    for(int j=0 ; j< results.length ; j++) {
			                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
			                       rs.executeSql(sql2);
					                   while(rs.next()){
					                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
					                   }
			                    }
			                    if(!result.equals("")) result = result.substring(0,result.length()-1);
			                }
			                break;
			            case 161:
						case 162:
			            	//自定义单选,多选
			                if(!result.equals("")) {
							//获取字段的数据库类型
							String tempfid=(String)fieldids.get(i);
							String tempfdbtype="";
								rs1.execute("select fielddbtype from workflow_billfield where id="+tempfid);
			                     if (rs1.next()) tempfdbtype=rs1.getString("fielddbtype");
			                    result=WorkflowJspBean.getWorkflowBrowserShowName(result,""+type,"","",tempfdbtype);
							}
			                if (type==162) 
								{
								if(!result.equals("")) result = result.substring(0,result.length()-1);
								}
			                break;  
			            default:
			                results = Util.TokenizerString2(result,",") ;
							if(results != null) {
									result = "";
			                    for(int j=0 ; j< results.length ; j++) {
			                       String sql2= "select "+BrowserComInfo.getBrowsercolumname(""+type)+" from "+BrowserComInfo.getBrowsertablename(""+type)+" where "+BrowserComInfo.getBrowserkeycolumname(""+type)+"="+results[j];
								   rs.executeSql(sql2);
					                   while(rs.next()){
					                   	 result += Util.toScreen(rs.getString(1),user.getLanguage())+"," ;
					                   }
			                    }
								if(!result.equals("")) result = result.substring(0,result.length()-1);
							}
					}
    			}
    
			    if(htmltype.equals("5"))
			    // 选择框字段
			    {
			        char flag = Util.getSeparator();
			        if(!result.equals("")){
				        rs.executeProc("workflow_SelectItemSByvalue", (String)fieldids.get(i) + flag + isbill + flag + result);
				        
				        if(rs.next())
				        {
				            result = Util.toScreen(rs.getString("selectname"), user.getLanguage());
				        }
				        else
				        {
				            result = "";
				        }
			      	}else{
						result = "";
			      	}
			    }
				if(htmltype.equals("6")) { 
			       switch (type) {
			        case 1:           
						results = Util.TokenizerString2(result,",") ;
			                if(results != null) {
			                    for(int j=0 ; j< results.length ; j++) {
			                        if(j==0){
			                           //result =  " <a href=\"javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+results[j]+"')\">"+Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) +"</a> ";
			                           result =  Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage());
			                        }else{
			                            //result += "<br>"+  " <a href=\"javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+results[j]+"')\">"+Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage()) +"</a> ";
			                            result += "<br>"+ Util.toScreen(DocComInfo.getDocname(results[j]),user.getLanguage());
			                        }
			                    }
			                }
			            break ;
			        	default:
			        }
				}
				if(htmltype.equals("1")) {   //处理超长的数字会成为科学计数法(如文本，电话号码)
					if (type==1) 
					{ 
						result=result+"　";
					}
				}
				if (!rowNames.contains(RecordSet.getColumnName(i + 1))) {
					rowNames.add(RecordSet.getColumnName(i + 1));
				}
				if(((String)isstats.get(i)).equals("1")) {
			        double resultdouble = Util.getDoubleValue((String)statvalues.get(i) , 0) ;
			        double tempresultdouble = Util.getDoubleValue((String)tempstatvalues.get(i) , 0) ;

					statisticsRowKv.put(RecordSet.getColumnName(i + 1), Boolean.valueOf(!isdetails.get(i).equals("1")));

					if(!isdetails.get(i).equals("1")){
						if(isnew){
			                resultdouble += Util.getDoubleValue(result , 0) ;
			                tempresultdouble += Util.getDoubleValue(result , 0) ;
			                requestid = temRequestid;
			                statvalues.set(i, ""+resultdouble) ;
			                tempstatvalues.set(i, ""+tempresultdouble) ;
			            }else{
			                result = "0";
			            }
        			}else{
			            resultdouble += Util.getDoubleValue(result , 0) ;
			            tempresultdouble += Util.getDoubleValue(result , 0) ;
			            requestid = temRequestid;
			            statvalues.set(i, ""+resultdouble) ;
			            tempstatvalues.set(i, ""+tempresultdouble) ;
					}
				}
				String tempTdTextValue = "";
				if(!((String)isdborders.get(i)).equals("1") || ((String)isdborders.get(i)).equals("1") && (needstat||statcount== 0) ) {
					if(htmltype.equals("1") && (type==3)) {
						tempTdTextValue=formatData(result);
						er.addValue(formatData(result)) ;
					}else{
						tempTdTextValue=result;
						String tempString = Util.StringReplace(Util.getTxtWithoutHTMLElement(FieldInfo.toExcel(result)),"%nbsp;"," ");
					    tempString = Util.StringReplace(tempString,"&dt;&at;"," ");
						tempString = Util.StringReplace(tempString,"&amp;","&");
         				if((htmltype.equals("1")&&type==1)||htmltype.equals("2")) {
         					er.addStringValue(tempString) ;
         				} else {
         					er.addValue(tempString) ;
         				}
					}
				} else {
					tempTdTextValue=result;
					er.addValue(formatData(result)) ;
				}
		%>
				<TD style="" ><%=(tempTdTextValue) %></TD>
		<%
			}

		%>
				</TR>
		<%
    		es.addExcelRow(er) ;
		}
	}
    //如果存在
    if ("sqlserver".equals((dbType))) {
    	RecordSet.execute("drop table " + tmpTblName);
    }
    List newTempStatValues = new ArrayList();
    for (Iterator it = rowNames.iterator();it.hasNext();) {
    	String rowName = (String) it.next();
    	Object obj = statisticsRowKv.get(rowName);
    	String tval = "";
    	if (obj != null) {
    		StringBuffer totalSql = new StringBuffer();
    		Boolean blnobj = (Boolean)obj;
    		boolean isTotal = blnobj.booleanValue(); 
    		
    		if (isTotal) {
    			totalSql.append("select sum(t2.rowsum) as rowsum from ( select Avg(tbl." + rowName + ") as rowsum from ( ");
    			totalSql.append(oldsql);
    			totalSql.append(" ) tbl group by tbl.requestid) t2");
    		} else {
    			totalSql.append("select sum(t2.rowsum) as rowsum from ( select Avg(tbl." + rowName + ") as rowsum from ( ");
    			totalSql.append(oldsql);
    			totalSql.append(" ) tbl group by tbl." + rowName.substring(0, rowName.lastIndexOf("__") + 1) + "id_) t2");
    		}
    		RecordSet.execute(totalSql.toString());
    		if (RecordSet.next()) {
    			tval = String.valueOf(Util.getDoubleValue(Util.null2String(RecordSet.getString("rowsum")), 0));
    		} else {
    			tval = "0.00";
    		}
    	}else {
    		tval = "";
    	}
    	newTempStatValues.add(tval);
    }
	if(statcount != 0 && !isfirst ) {
		er = es.newExcelRow () ;
	%>
        <TR class=TOTAL style="FONT-WEIGHT: bold">
	<% 
            for(int i =0 ; i< tempstatvalues.size() ; i++) {
                er.addValue(formatData((String)tempstatvalues.get(i))) ;
	%>
            	<TD style="" ><%=formatData((String)tempstatvalues.get(i))%></TD>
	<%
				tempstatvalues.set(i,"") ; 
            }
	%>
        </tr>
	<%
		es.addExcelRow(er) ;
	}
    	er = es.newExcelRow () ;
	%>
		<TR class=TOTAL style="FONT-WEIGHT: bold">
	<% 
            for(int i =0 ; i< newTempStatValues.size() ; i++) {
                er.addValue(formatData((String)newTempStatValues.get(i))) ;
	%>
            <TD ><%=formatData((String)newTempStatValues.get(i))%></TD>
	<% 
			}
	%>
		</tr>
	<%
    	es.addExcelRow(er) ;
    
	%>
	</TBODY>
	</TABLE>
	</td>
		</tr>
		<tr>
	<td colspan="3">
		<div style="width:100%;text-align:right;">
			<input type="hidden" name="pageSize" value="<%=pageSize %>">
			<input type="hidden" name="currentPage" value="<%=currentPage %>">
			<input type="hidden" name="rowcount" value="<%=rowcount %>">
			<input type="hidden" name="pageCount" value="<%=pageCount %>">
			<span style="TEXT-DECORATION:none;height:21px;padding-top:2px;">&raquo; 共<%=rowcount %>条记录&nbsp;&nbsp;&nbsp;每页<%=pageSize %>条</span>
	<% 
			String str = getSplitPageString(pageSize, currentPage, rowcount, pageCount, "bottom");
			out.print(str);
	%>
		</div>
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
<div>
	<table class=ReportStyle>
		<TBODY>
			<TR>
				<TD>
					<B>自定义报表中含有多明细显示说明</B>：
					<BR>
					在自定义报表中查看数据，同一卡片所有记录的主表中的字段值相同，
					当显示明细表1的明细字段的记录时，
					仅显示卡片中明细表1中的明细字段值，其他表中的字段值显示为空<br>
					当显示明细表2的明细记录时，
					仅显示卡片中明细表2中的明细字段值，其他表中的字段值显示为空，
					当有多个明细组时，依次类推。					
					<BR>
					<BR>
					这种的显示方式可能造成显示的记录数与分页计算的记录数不符，此为正常现象。
				</TD>
			</TR>
		</TBODY>
	</table>
	<br>
	<br>
</div>

 <%
ExcelFile.init() ;
ExcelFile.setFilename(Util.toScreen(ReportComInfo.getReportname(reportid),user.getLanguage())) ;
ExcelFile.addSheet(Util.toScreen(ReportComInfo.getReportname(reportid),user.getLanguage()), es) ;
 %>
 
 <%! 
 private String getSplitPageString(int pageSize, int currentPage, int rowcount, int pageCount, String position) {
 	String sbf = "";
	int z_index = currentPage - 2;
	int y_num = currentPage + 2;
	String tempCent = "";
	String tempLeft = "";
	String tempRight = "";
	if (z_index > 1) {
	    tempLeft += "<a style=\"position:relative;cursor:hand;TEXT-DECORATION:none;height:21px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\"1\" onClick=\"jumpTo(1)\">" + 1 + "</a>";
	}
	if (z_index > 2) {
	    tempLeft += "<span style=\"height:21px;padding-top:1px;text-align:center;\">&nbsp;...&nbsp;</span>";
	}
	
	if (y_num < (pageCount - 1)) {
	    tempRight += "<span style=\"height:21px;padding-top:1px;text-align:center;\">&nbsp;...&nbsp;</span>";
	}
	
	if (y_num < pageCount) {
		tempRight += "<a style=\"position:relative;cursor:hand;TEXT-DECORATION:none;height:21px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\"1\" onClick=\"jumpTo(" + pageCount + ")\">" + pageCount + "</a>";
	}
	
	for(;z_index<=y_num; z_index++) {
	    if (z_index>0 && z_index<=pageCount) {
	        if (z_index == currentPage) {
	            tempCent +="<a style=\"position:relative;TEXT-DECORATION:none;height:21px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\"" + z_index + "\" class=\"weaverTableCurrentPageBg\" >" + z_index + "</a>";                
	        } else {
	            tempCent +="<a style=\"position:relative;cursor:hand;TEXT-DECORATION:none;height:21px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\"" + z_index + "\" onClick=\"jumpTo(" + z_index + ")\">" + z_index + "</a>";
	        }
	    }
	}
	
	sbf = tempLeft + tempCent + tempRight;
	
	String str = "";
	if(currentPage > 1){
		str +="<a class=\"weaverTablePrevPage\" style=\"position:relative;top:0px;bottom:0;cursor:hand;TEXT-DECORATION:none;height:21px;width:21px;margin-right:5px;font-size:11px;\" id=\"" + position + "-pre\" onClick=\"jumpTo(" + (currentPage - 1) + ")\" onmouseover=\"pmouseover(this, true)\" onmouseout=\"pmouseover(this, false)\">&nbsp;</a>";	
	}else{
		str += "<span class=\"weaverTablePrevPageOfDisabled\" style=\"position:relative;top:0px;TEXT-DECORATION:none;height:21px;width:21px;margin-right:5px;color:#c6c6c6;font-size:11px;display:inline-block;\">&nbsp;</span>";
	}
	str += sbf;
	if(currentPage<pageCount){
		str +="<a class=\"weaverTableNextPage\" style=\"position:relative;top:0px;cursor:hand;TEXT-DECORATION:none;height:21px;width:21px;margin-right:10px;font-size:11px;\" id=\"" + position + "-next\" onClick=\"jumpTo(" + (currentPage + 1) + ")\" onmouseover=\"pmouseover(this, true)\" onmouseout=\"pmouseover(this, false)\">&nbsp;</a>";	
	}else{
		str += "<span class=\"weaverTableNextPageOfDisabled\" style=\"position:relative;top:0px;TEXT-DECORATION:none;height:21px;width:21px;margin-right:10px;font-size:11px;display:inline-block;\">&nbsp;</span>";
	}
	
	String result = "";
    result += "<span style=\"TEXT-DECORATION:none;height:21px;padding-top:1px;\">第&nbsp;</span>";
    
    result += "<input id=\"jumpTo" + position + "\" type=\"text\" value=\""+ currentPage +"\" size=\"3\" class=\"text\" onMouseOver=\"this.select()\" style=\"text-align:right;height:20px;widht:30px;border:1px solid #6ec8ff;background:none;position:relative;margin-right:5px;padding-right:2px;\"/>";
    result += "<span style=\"TEXT-DECORATION:none;height:21px;padding-top:1px;\">页</span>";
    result += "&nbsp;<button id=\"jumpTo-goPage\" onClick=\"jumpTo(document.getElementById('jumpTo" + position + "').value, document.getElementById('jumpTo" + position + "'))\" style=\"cursor:hand;background:url(/wui/theme/ecology7/skins/default/table/jump.png) no-repeat;height:21px;width:38px;margin-right:5px;text-align:center;border:none;\">跳转</button>";
    
    str += result;
	 return str;
 }
 

 private String delHtml(final String inputString) {

     String htmlStr = new weaver.workflow.mode.FieldInfo().toExcel(inputString); // 含html标签的字符串
     htmlStr = Util.StringReplace(htmlStr, "&dt;&at;", "<br>");
     
     String textStr = "";
     java.util.regex.Pattern p_script;
     java.util.regex.Matcher m_script;
     java.util.regex.Pattern p_html;
     java.util.regex.Matcher m_html;

     try {
         String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式

         String regEx_script = "<[/s]*?script[^>]*?>[/s/S]*?<[/s]*?//[/s]*?script[/s]*?>"; // 定义script的正则表达式{或<script[^>]*?>[/s/S]*?<//script>

         p_script = java.util.regex.Pattern.compile(regEx_script, java.util.regex.Pattern.CASE_INSENSITIVE);
         m_script = p_script.matcher(htmlStr);
         htmlStr = m_script.replaceAll(""); // 过滤script标签

         p_html = java.util.regex.Pattern.compile(regEx_html, java.util.regex.Pattern.CASE_INSENSITIVE);
         m_html = p_html.matcher(htmlStr);
         htmlStr = m_html.replaceAll(""); // 过滤html标签

         textStr = htmlStr;

     } catch (Exception e) {
         System.err.println("Html2Text: " + e.getMessage());
     }
     
     return Util.HTMLtoTxt(textStr).replaceAll("%nbsp;", "").trim();// 返回文本字符串
 }
     
 private String formatData(String inData){
     if(inData==null||inData.equals("")){
         return "";
     }
     try{
         return new BigDecimal(  Util.null2String(inData).equals("")?"0":Util.null2String(inData) ).setScale(2,BigDecimal.ROUND_HALF_UP).toString();
     }catch(Exception e){
         return inData;
     }
 }
 %>
</BODY>
</HTML>
