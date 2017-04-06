
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.common.xtable.TableSql" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocTreeDocFieldManager" class="weaver.docs.category.DocTreeDocFieldManager" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />

<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sharemanager" class="weaver.share.ShareManager" scope="page" />

<%@ page import="weaver.common.xtable.*"%>
<%

boolean isoracle = RecordSet.getDBType().equalsIgnoreCase("oracle");

String sessionId=Util.getEncrypt("xTableSql_"+Util.getRandom()); 
	ArrayList xTableColumnList = new ArrayList();
	ArrayList xTableOperationList = new ArrayList();
	ArrayList xTableToolBarList = new ArrayList();	
	TableSql xTableSql=new TableSql();
	Table xTable=new Table(request); 
	TableOperatePopedom xTableOperatePopedom=new TableOperatePopedom();
	
		//TableColumn xTableColumn_ID = new TableColumn();
		//xTableColumn_ID.setColumn("id");
		//xTableColumn_ID.setDataIndex("id");
		//xTableColumn_ID.setHeader("&nbsp;&nbsp;");
		//xTableColumn_ID.setSortable(false);
		//xTableColumn_ID.setHideable(false);
		//xTableColumn_ID.setWidth(0.0000001);
		//xTableColumnList.add(xTableColumn_ID);
	 //xTable.setColumnWidth(54);
	 xTableToolBarList.add("");
	 xTableToolBarList.add("");
	 xTableToolBarList.add("");
%>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	return;
}
/* edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 */
int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
int showtype = Util.getIntValue(request.getParameter("showtype"),0);
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
/* edited end */
String frompage=Util.null2String(request.getParameter("frompage"));//从哪个页面过来
////排序状态 0:默认排序 1:按文章分数排序  2:按文章打分人数排序 3:按文章的访问题排序
int sortState = Util.getIntValue(Util.null2String(request.getParameter("sortState")),0) ;

String docsubject = Util.null2String(request.getParameter("docsubject")) ;
String doccontent = Util.null2String(request.getParameter("doccontent")) ;
String containreply = Util.null2String(request.getParameter("containreply")) ;
String maincategory=Util.null2String(request.getParameter("maincategory"));
if(maincategory.equals("0"))maincategory="";
String subcategory=Util.null2String(request.getParameter("subcategory"));
if(subcategory.equals("0"))subcategory="";
String seccategory=Util.null2String(request.getParameter("seccategory"));
if(seccategory.equals("0"))seccategory="";
String docid=Util.null2String(request.getParameter("docid"));
if(docid.equals("0"))docid="";
String doccreaterid=Util.null2String(request.getParameter("doccreaterid"));
if(doccreaterid.equals("0")) doccreaterid="";

String departmentid=Util.null2String(request.getParameter("departmentid"));
if(departmentid.equals("0")) departmentid="";
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
if(subcompanyid.equals("0")) subcompanyid="";

String doclangurage=Util.null2String(request.getParameter("doclangurage"));
if(doclangurage.equals("0"))doclangurage="";
String hrmresid=Util.null2String(request.getParameter("hrmresid"));
if(hrmresid.equals("0"))hrmresid="";
String itemid=Util.null2String(request.getParameter("itemid"));
if(itemid.equals("0"))itemid="";
String itemmaincategoryid=Util.null2String(request.getParameter("itemmaincategoryid"));
if(itemmaincategoryid.equals("0"))itemmaincategoryid="";
String crmid=Util.null2String(request.getParameter("crmid"));
if(crmid.equals("0"))crmid="";
String projectid=Util.null2String(request.getParameter("projectid"));
if(projectid.equals("0"))projectid="";
String financeid=Util.null2String(request.getParameter("financeid"));
if(financeid.equals("0"))financeid="";
String docpublishtype=Util.null2String(request.getParameter("docpublishtype")) ;
String docstatus=Util.null2String(request.getParameter("docstatus")) ;
String keyword=Util.null2String(request.getParameter("keyword"));
String ownerid=Util.null2String(request.getParameter("ownerid"));
if(ownerid.equals("0")) ownerid="";

String isreply=Util.null2String(request.getParameter("isreply"));
String isNew=Util.null2String(request.getParameter("isNew"));
String loginType="";
if(request.getParameter("loginType")!=null){
	loginType = Util.null2String(request.getParameter("loginType"));
}
else{
	loginType =  user.getLogintype();
}
String isMainOrSub=Util.null2String(request.getParameter("isMainOrSub"));
String usertype =Util.null2String(request.getParameter("usertype"));

String docno = Util.null2String(request.getParameter("docno"));
String doclastmoddatefrom = Util.null2String(request.getParameter("doclastmoddatefrom"));
String doclastmoddateto = Util.null2String(request.getParameter("doclastmoddateto"));
String docarchivedatefrom = Util.null2String(request.getParameter("docarchivedatefrom"));
String docarchivedateto = Util.null2String(request.getParameter("docarchivedateto"));
String doccreatedatefrom = Util.null2String(request.getParameter("doccreatedatefrom"));
String doccreatedateto = Util.null2String(request.getParameter("doccreatedateto"));
String docapprovedatefrom = Util.null2String(request.getParameter("docapprovedatefrom"));
String docapprovedateto = Util.null2String(request.getParameter("docapprovedateto"));
String replaydoccountfrom = Util.null2String(request.getParameter("replaydoccountfrom"));
String replaydoccountto = Util.null2String(request.getParameter("replaydoccountto"));
String accessorycountfrom = Util.null2String(request.getParameter("accessorycountfrom"));
String accessorycountto = Util.null2String(request.getParameter("accessorycountto"));

String contentname = Util.null2String(request.getParameter("contentname"));

String doclastmoduserid = Util.null2String(request.getParameter("doclastmoduserid"));
if(doclastmoduserid.equals("0")) doclastmoduserid="";
String docarchiveuserid = Util.null2String(request.getParameter("docarchiveuserid"));
if(docarchiveuserid.equals("0")) docarchiveuserid="";
String docapproveuserid = Util.null2String(request.getParameter("docapproveuserid"));
if(docapproveuserid.equals("0")) docapproveuserid="";
String assetid = Util.null2String(request.getParameter("assetid"));
if(assetid.equals("0")) assetid="";
String treeDocFieldId = Util.null2String(request.getParameter("treeDocFieldId"));
if(treeDocFieldId.equals("0")) treeDocFieldId="";


String noRead = Util.null2String(request.getParameter("noRead"));
String dspreply = Util.null2String(request.getParameter("dspreply"));
String date2during = Util.null2String(request.getParameter("date2during"));
//set DocSearchComInfo values------------------------------------

DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.setContentname(contentname);
DocSearchComInfo.setContainreply(containreply);
DocSearchComInfo.setDocsubject(docsubject);
DocSearchComInfo.setDoccontent(doccontent);
DocSearchComInfo.setMaincategory(maincategory);
DocSearchComInfo.setSubcategory(subcategory);
DocSearchComInfo.setSeccategory(seccategory);
DocSearchComInfo.setDocid(docid);
DocSearchComInfo.setDoccreaterid(doccreaterid);
DocSearchComInfo.setDocdepartmentid(departmentid);
DocSearchComInfo.setDoclanguage(doclangurage);
DocSearchComInfo.setHrmresid(hrmresid);
DocSearchComInfo.setItemid(itemid);
DocSearchComInfo.setItemmaincategoryid(itemmaincategoryid);
DocSearchComInfo.setCrmid(crmid);
DocSearchComInfo.setProjectid(projectid);
DocSearchComInfo.setFinanceid(financeid);
DocSearchComInfo.setUsertype(usertype);
DocSearchComInfo.setUserID(""+user.getUID());
DocSearchComInfo.setIsreply(isreply) ;
DocSearchComInfo.setIsNew(isNew) ;
DocSearchComInfo.setIsMainOrSub(isMainOrSub) ;
DocSearchComInfo.setLoginType(loginType) ;
DocSearchComInfo.setNoRead(noRead) ;
DocSearchComInfo.setDate2during(date2during);
if ("0".equals(dspreply)) DocSearchComInfo.setContainreply("1");   //全部
else if("1".equals(dspreply)) DocSearchComInfo.setContainreply("0");   //非回复
else if ("2".equals(dspreply)) DocSearchComInfo.setIsreply("1");  //仅回复

if(docpublishtype.equals("1")||docpublishtype.equals("2")||docpublishtype.equals("3")||docpublishtype.equals("5")){
	DocSearchComInfo.setDocpublishtype(docpublishtype);
}

if(docstatus.equals("1")||docstatus.equals("5")||docstatus.equals("7")){

	if(docstatus.equals("1")){
		DocSearchComInfo.addDocstatus("1");
		DocSearchComInfo.addDocstatus("2");
	}
	else
		DocSearchComInfo.addDocstatus(docstatus);
}
else{
	DocSearchComInfo.addDocstatus("1");
	DocSearchComInfo.addDocstatus("2");
    DocSearchComInfo.addDocstatus("5");
    if(frompage.equals(""))
    DocSearchComInfo.addDocstatus("7");
}

DocSearchComInfo.setKeyword(keyword);
DocSearchComInfo.setOwnerid(ownerid);


DocSearchComInfo.setDocno(docno);
DocSearchComInfo.setDoclastmoddateFrom(doclastmoddatefrom);
DocSearchComInfo.setDoclastmoddateTo(doclastmoddateto);
DocSearchComInfo.setDocarchivedateFrom(docarchivedatefrom);
DocSearchComInfo.setDocarchivedateTo(docarchivedateto);
DocSearchComInfo.setDoccreatedateFrom(doccreatedatefrom);
DocSearchComInfo.setDoccreatedateTo(doccreatedateto);
DocSearchComInfo.setDocapprovedateFrom(docapprovedatefrom);
DocSearchComInfo.setDocapprovedateTo(docapprovedateto);
DocSearchComInfo.setReplaydoccountFrom(replaydoccountfrom);
DocSearchComInfo.setReplaydoccountTo(replaydoccountto);
DocSearchComInfo.setAccessorycountFrom(accessorycountfrom);
DocSearchComInfo.setAccessorycountTo(accessorycountto);
DocSearchComInfo.setDoclastmoduserid(doclastmoduserid);
DocSearchComInfo.setDocarchiveuserid(docarchiveuserid);
DocSearchComInfo.setDocapproveuserid(docapproveuserid);
DocSearchComInfo.setAssetid(assetid);
DocSearchComInfo.setTreeDocFieldId(treeDocFieldId);

DocSearchComInfo.setDocSubCompanyId(subcompanyid);
String strShowType="";
if(showtype==0){
	strShowType="";
}else{
	strShowType=String.valueOf(showtype);
}
DocSearchComInfo.setShowType(strShowType);

//处理自定义条件 begin
    String[] checkcons = request.getParameterValues("check_con");
    String sqlwhere = "";
    String sqlrightwhere = "";
    String temOwner = "";
	
    if(checkcons!=null){
        for(int i=0;i<checkcons.length;i++){
            String tmpid = ""+checkcons[i];
            String tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
            String tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
            String tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
            String tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
            String tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
            String tmpname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_name"));
            String tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
            String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));

            //生成where子句

            temOwner = "tCustom";

            if((tmphtmltype.equals("1")&& tmptype.equals("1"))||tmphtmltype.equals("2")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
                if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
                if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
            }else if(tmphtmltype.equals("1")&& !tmptype.equals("1")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("")){
                    if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";

                    if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }
                if(!tmpvalue1.equals("")){
                    if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
                }
            }
            else if(tmphtmltype.equals("4")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
                else sqlwhere +="='1' ";
            }
            else if(tmphtmltype.equals("5")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
            }
            else if(tmphtmltype.equals("3") && !tmptype.equals("2") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")&& !tmptype.equals("65")&& !tmptype.equals("162")  ){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("2")||tmptype.equals("19"))){ // 对日期处理
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("")){
                    if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";

                    if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }
                if(!tmpvalue1.equals("")){
                    if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
                }
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("17") || tmptype.equals("18") || tmptype.equals("37") || tmptype.equals("65")|| tmptype.equals("162")  )){       // 对多人力资源，多客户，多文档的处理
                //sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
				if(isoracle){
					sqlwhere += "and (','||"+temOwner+"."+tmpcolname+"||',' ";
				}else{
					sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
				}
                if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
                if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
            }

            sqlwhere +=") ";
		
        }

    }
    
    //for debug
   
    if(!sqlwhere.equals("")){
        //去掉sql语句前面的and
        sqlwhere = sqlwhere.trim().substring(3);
        DocSearchComInfo.setCustomSqlWhere(sqlwhere);
    }else{
        DocSearchComInfo.setCustomSqlWhere("");
    }

	
%>


<%

String sqlWhere="";
//查询设置
String userid=user.getUID()+"" ;
//String loginType = user.getLogintype() ;
String userSeclevel = user.getSeclevel() ;
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
char flag=2;
boolean shownewicon=false;
//String dspreply = DocSearchComInfo.getContainreply() ;
String tabletype="checkbox";
String browser="";

String tables=sharemanager.getShareDetailTableByUser("doc",user);

//String isreply=Util.null2String(request.getParameter("isreply"));
//String frompage=Util.null2String(request.getParameter("frompage"));
//String doccreatedatefrom=Util.null2String(request.getParameter("doccreatedatefrom"));
//String doccreatedateto=Util.null2String(request.getParameter("doccreatedateto"));
//String docpublishtype=Util.null2String(request.getParameter("docpublishtype"));

/* edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 */
//int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
//int showtype = Util.getIntValue(request.getParameter("showtype"),0);
//int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);//
//int infoId = Util.getIntValue(request.getParameter("infoId"),0);

String selectArr = "";
LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectArr = info.getSelectedContent();
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

int showTitle = Util.getIntValue(request.getParameter("showTitle"),0);
int showDocs = Util.getIntValue(request.getParameter("showDocs"),0);
//String maincategory=Util.null2String(request.getParameter("maincategory"));
//String subcategory=Util.null2String(request.getParameter("subcategory"));
//String seccategory=Util.null2String(request.getParameter("seccategory"));
String tseccategory = seccategory;
String tsubcategory = subcategory;
String tmaincategory = maincategory;
String tmaincategoryname = "";
String tsubcategoryname ="";
String tseccategoryname="";
if(!"".equals(tseccategory)) tsubcategory = SecCategoryComInfo.getSubCategoryid(tseccategory);
if(!"".equals(tsubcategory)) tmaincategory = SubCategoryComInfo.getMainCategoryid(tsubcategory);



/* edited end */

/* added by yinshun.xu 2006-07-19 按组织结构显示 */
//String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
//String departmentid=Util.null2String(request.getParameter("departmentid"));

/* added end */

/* added by fanggsh 2006-07-24 按树状字段显示 */

/* added end */






String tableString = "";
String tableInfo = "";


boolean isUsedCustomSearch = "true".equals(Util.null2String(request.getParameter("isUsedCustomSearch")))?true:false;

if(DocSearchComInfo.getSeccategory()!=null&&!"".equals(DocSearchComInfo.getSeccategory())){
    isUsedCustomSearch = SecCategoryComInfo.isUsedCustomSearch(Util.getIntValue(DocSearchComInfo.getSeccategory()));
}
String strDummy=""; 
String strDummyEn="";

if(DocTreeDocFieldManager.getIsHaveRightToDummy(user.getUID())){
	strDummy="&nbsp;&nbsp;[<a href=\"javascript:importSelectedToDummy()\">"+SystemEnv.getHtmlLabelName(21826,user.getLanguage())+"</a>]&nbsp;&nbsp;[<a href=\"javascript:importAllToDummy()\">"+SystemEnv.getHtmlLabelName(21827,user.getLanguage())+"</a>]"; 
	    //strDummyEn="&nbsp;&nbsp;[<a href='javascript:importSelectedToDummy()'>Import Selected Docs To Dummy Catelog</a>]&nbsp;&nbsp;[<a href='javascript:importAllToDummy()'>Import All Docs To Dummy Catelog</a>]";
	
	xTableToolBarList.set(1,"{text:'"+SystemEnv.getHtmlLabelName(21826,user.getLanguage())+"',iconCls:'btn_import',handler:function(){importSelectedToDummy()}}");
	xTableToolBarList.set(2,"{text:'"+SystemEnv.getHtmlLabelName(21827,user.getLanguage())+"',iconCls:'btn_import',handler:function(){importAllToDummy()}}");

} else {
 	strDummy="&nbsp;&nbsp;["+SystemEnv.getHtmlLabelName(21826,user.getLanguage())+"]&nbsp;&nbsp;["+SystemEnv.getHtmlLabelName(21827,user.getLanguage())+"]"; 
}

if(isUsedCustomSearch){
	
    String seccategoryid =  Util.null2String(request.getParameter("seccategoryid"));
    DocSearchComInfo.setSeccategory(seccategoryid);
    //backFields
	String backFields = "";
	//backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname");
	String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	if(RecordSet.getDBType().equals("oracle"))
	{
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	}
	backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname,t1.doccreaterid");
	if((Util.getIntValue(DocSearchComInfo.getDate2during(),0)>0&&Util.getIntValue(DocSearchComInfo.getDate2during(),0)<37)||!UserDefaultManager.getHasoperate().equals("1"))
    {
    	backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t1.docextendname,t1.doccreaterid");
    }
    
	//from
	String  sqlFrom = "DocDetail  t1, "+tables+"  t2";
	
	String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
	if(!strCustomSql.equals("")){
	  sqlFrom += ", cus_fielddata tCustom ";
	}
	//where
	
	//String isNew
	isNew = DocSearchComInfo.getIsNew() ;
	
	String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
	if(!frompage.equals("")){
	 whereclause=whereclause+" and t1.docstatus in ('1','2','5') and t1.usertype=1";
	 if(isreply.equals("0")){
	   whereclause+=" and (isreply='' or isreply is null) ";
	 }
	 if(!doccreatedatefrom.equals("")){
	   whereclause+=" and doccreatedate>='"+doccreatedatefrom+"' ";
	 }
     if(!doccreatedateto.equals("")){
       whereclause+=" and doccreatedate<='"+doccreatedateto+"' ";
     }
     if(docpublishtype.equals("1")){
      whereclause+=" and (docpublishtype='1'  or docpublishtype='' or docpublishtype is null ) ";
     }
     if(docpublishtype.equals("2")||docpublishtype.equals("3")){
      whereclause+=" and docpublishtype="+docpublishtype;
     }	 
	}
	/* added by wdl 2006-08-28 不显示历史版本 */
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	/* added end */
	
	/* added by wdl 2006-06-13 left menu advanced menu */
	if((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))
		whereclause+=" and maincategory in (" + inMainCategoryStr + ") ";
	if((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))
		whereclause+=" and subcategory in (" + inSubCategoryStr + ") ";
	/* added end */
	//String tableInfo
	
	tableInfo = "[<a href=\"/docs/search/DocSearch.jsp?from=docsubscribe\">"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"</a>]"+strDummy;
	xTableToolBarList.set(0,"{text:'"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"',iconCls:'btn_rss',handler:function(){window.location = '/docs/search/DocSearch.jsp?from=docsubscribe'}}");
	
	//用于暂时屏蔽外部用户的订阅功能
	if (!"1".equals(loginType)){
	    tableInfo = "";
		xTableToolBarList.set(0,"");
	}
	
	
		
	sqlFrom += ",(select ljt1.id as docid,ljt2.* from DocDetail ljt1 LEFT JOIN cus_fielddata ljt2 ON ljt1.id=ljt2.id and ljt2.scope='DocCustomFieldBySecCategory' and ljt2.scopeid="+DocSearchComInfo.getSeccategory()+") tcm";
	whereclause += " and t1.id = tcm.docid ";
	
	
	
	
	
	sqlWhere = DocSearchManage.getShareSqlWhere(whereclause,user);

	//colString
	String userInfoForotherpara =loginType+"+"+userid;
	String colString ="";
	if(displayUsage==0){
		colString +="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
		TableColumn xTableColumn_icon = new TableColumn();
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
	colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
	TableColumn xTableColumn_DocName = new TableColumn();
	xTableColumn_DocName.setColumn("docsubject");
	xTableColumn_DocName.setDataIndex("docsubject");
	xTableColumn_DocName.setHeader(SystemEnv.getHtmlLabelName(58,user.getLanguage()));
	xTableColumn_DocName.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId");
	xTableColumn_DocName.setPara_1("column:id");
	xTableColumn_DocName.setPara_2(userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount");
	//xTableColumn_DocName.setHref("/docs/docs/DocDsp.jsp");
	//xTableColumn_DocName.setLinkkey("id");
	xTableColumn_DocName.setSortable(true);
	xTableColumn_DocName.setWidth(0.22);
	xTableColumnList.add(xTableColumn_DocName);
	if (isNew.equals("yes")&&displayUsage==0) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是" 
	     
		tabletype="checkbox";
		tableInfo="";
		//xTableToolBarList.set(0,"");
		colString ="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
		colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIconIsNew\" otherpara=\"column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
		xTableColumnList.clear();
		TableColumn xTableColumn_icon = new TableColumn();
		xTableColumn_icon.setColumn("docextendname");
		xTableColumn_icon.setDataIndex("docextendname");
		xTableColumn_icon.setHeader("&nbsp;&nbsp;");
		xTableColumn_icon
				.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName");
		xTableColumn_icon.setPara_1("column:docextendname");
		xTableColumn_icon.setSortable(false);
		xTableColumn_icon.setHideable(false);
		xTableColumn_icon.setWidth(0.03);
		xTableColumnList.add(xTableColumn_icon);
		
		TableColumn xTableColumn_DocName2 = new TableColumn();
		xTableColumn_DocName2.setColumn("docsubject");
		xTableColumn_DocName2.setDataIndex("docsubject");
		xTableColumn_DocName2.setHeader(SystemEnv.getHtmlLabelName(58, user.getLanguage()));
		xTableColumn_DocName2.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocNameAndIconIsNew");
		xTableColumn_DocName2.setPara_1("column:id");
		xTableColumn_DocName2.setPara_2("column:docsubject");
		xTableColumn_DocName2.setTarget("_fullwindow");
		//xTableColumn_DocName2.setHref("/docs/docs/DocDsp.jsp");
		xTableColumn_DocName2.setLinkkey("id");
		xTableColumn_DocName2.setSortable(true);
		xTableColumn_DocName2.setWidth(0.22);
		xTableColumnList.add(xTableColumn_DocName2);
	}
	//orderBy
	String orderBy = "doclastmoddate,doclastmodtime";    
	//primarykey
	String primarykey = "t1.id";
	//pagesize
	UserDefaultManager.setUserid(user.getUID());
	UserDefaultManager.selectUserDefault();
	int pagesize = UserDefaultManager.getNumperpage();
	if(pagesize <2) pagesize=10;
	
	//operateString userType_userId_userSeclevel
 		String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
 		String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel+column:id";
 		String operateString = "";
 		if (UserDefaultManager.getHasoperate().equals("1")&&displayUsage==0) 
 		{  
 	 	   operateString= "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2\" otherpara=\""+popedomOtherpara+"\" otherpara2=\""+popedomOtherpara2+"\"></popedom> ";
 	       operateString+="     <operate href=\"/docs/docs/DocEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>";
 	       operateString+="     <operate href=\"javascript:doDocDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_fullwindow\" index=\"2\"/>";
 	       operateString+="     <operate href=\"javascript:doDocShare()\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" target=\"_fullwindow\" index=\"3\"/>";
 	       operateString+="     <operate href=\"javascript:doDocViewLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" target=\"_fullwindow\" index=\"4\"/>";       
 	       operateString+="</operates>";
 	       
 		   xTableOperatePopedom.setTransmethod("weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2");
 		   xTableOperatePopedom.setOtherpara(popedomOtherpara);
 		   xTableOperatePopedom.setOtherpara2(popedomOtherpara2);
 		   TableOperation xTableOperation_Edit = new TableOperation();
 			xTableOperation_Edit.setHref("/docs/docs/DocEdit.jsp");
 			xTableOperation_Edit.setLinkkey("id");
 			xTableOperation_Edit.setLinkvaluecolumn("id");
 			xTableOperation_Edit.setText(SystemEnv.getHtmlLabelName(93,user.getLanguage()));
 			xTableOperation_Edit.setTarget("_fullwindow");
 			xTableOperation_Edit.setIndex("1");
 			xTableOperationList.add(xTableOperation_Edit);

 			TableOperation xTableOperation_Del = new TableOperation();
 			xTableOperation_Del.setHref("javascript:doDocDel()");
 			xTableOperation_Del.setText(SystemEnv.getHtmlLabelName(91, user.getLanguage()));
 			xTableOperation_Del.setTarget("_fullwindow");
 			xTableOperation_Del.setIndex("2");
 			xTableOperationList.add(xTableOperation_Del);

 			TableOperation xTableOperation_Share = new TableOperation();
 			xTableOperation_Share.setHref("javascript:doDocShare()");
 			xTableOperation_Share.setText(SystemEnv.getHtmlLabelName(119,user.getLanguage()));
 			xTableOperation_Share.setTarget("_fullwindow");
 			xTableOperation_Share.setIndex("3");
 			xTableOperationList.add(xTableOperation_Share);

 			TableOperation xTableOperation_Log = new TableOperation();
 			xTableOperation_Log.setHref("javascript:doDocViewLog()");
 			xTableOperation_Log.setText(SystemEnv.getHtmlLabelName(83, user.getLanguage()));
 			xTableOperation_Log.setTarget("_fullwindow");
 			xTableOperation_Log.setIndex("4");
 			xTableOperationList.add(xTableOperation_Log);      
 		}
	 
    SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(Util.getIntValue(DocSearchComInfo.getSeccategory()));
	RecordSet.executeSql("select * from DocSecCategoryCusSearch where secCategoryId = "+DocSearchComInfo.getSeccategory()+" order by viewindex");
	while(RecordSet.next()){
		int currId = RecordSet.getInt("id");
		int currDocPropertyId = RecordSet.getInt("docPropertyId");
		int currVisible = RecordSet.getInt("visible");
		
		int currType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType(currDocPropertyId+""));
		if(currType==1) continue;
		
		int currIsCustom = Util.getIntValue(SecCategoryDocPropertiesComInfo.getIsCustom(currDocPropertyId+""));
		
		int currLabelId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
		String currCustomName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+""));
		
		String currName = (currCustomName.equals("")&&currLabelId>0)?SystemEnv.getHtmlLabelName(currLabelId, user.getLanguage()):currCustomName;
        
        if(currVisible==1&&displayUsage==0){
            if(currIsCustom==1){
                int tmpfieldid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getFieldId(currDocPropertyId+""));
                String tmpcustomName = SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+"");
                if ("oracle".equals(RecordSet.getDBType())){
                	backFields=getFilterBackFields(backFields,"tcm.field"+tmpfieldid);
                }else{
                	backFields=getFilterBackFields(backFields,"cast(tcm.field"+tmpfieldid+" as varchar) as field"+tmpfieldid);
                }
        	    colString +="<col width=\"10%\"  text=\""+tmpcustomName+"\" column=\""+"field"+tmpfieldid+"\" orderkey=\""+"field"+tmpfieldid+"\"   transmethod=\"weaver.docs.docs.CustomFieldSptmForDoc.getFieldShowName\" otherpara=\""+tmpfieldid+"+"+user.getLanguage()+"\"/>";

            	TableColumn xTableColumn_Field = new TableColumn();
				xTableColumn_Field.setColumn("field" + tmpfieldid);
				xTableColumn_Field.setDataIndex("field"+ tmpfieldid);
				xTableColumn_Field.setTransmethod("weaver.docs.docs.CustomFieldSptmForDoc.getFieldShowName");
				xTableColumn_Field.setPara_1("column:field"+tmpfieldid);
				xTableColumn_Field.setPara_2(tmpfieldid+"+"+user.getLanguage());
				xTableColumn_Field.setHeader(tmpcustomName);
				xTableColumn_Field.setWidth(0.1);
				xTableColumn_Field.setSortable(true);
				xTableColumnList.add(xTableColumn_Field);
            } else {
                if(currType==2){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docCode");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docCode\" orderkey=\"docCode\"/>";
                	TableColumn xTableColumn_DocCode = new TableColumn();
					xTableColumn_DocCode.setColumn("docCode");
					xTableColumn_DocCode.setDataIndex("docCode");
					xTableColumn_DocCode.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocCode.setSortable(true);
					xTableColumn_DocCode.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocCode);
                } else if(currType==3){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docpublishtype");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docpublishtype\" orderkey=\"docpublishtype\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocPublicType\" otherpara=\""+user.getLanguage()+"\"/>";
                	TableColumn xTableColumn_DocPublishType = new TableColumn();
					xTableColumn_DocPublishType.setColumn("docpublishtype");
					xTableColumn_DocPublishType.setDataIndex("docpublishtype");
					xTableColumn_DocPublishType.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocPublishType.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocPublicType");
					xTableColumn_DocPublishType.setPara_1("column:docpublishtype");
					xTableColumn_DocPublishType.setPara_2(Integer.toString(user.getLanguage()));
					xTableColumn_DocPublishType.setSortable(true);
					xTableColumn_DocPublishType.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocPublishType);
                } else if(currType==4){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docedition");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docedition\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocVersion\"/>";
                	TableColumn xTableColumn_DocEdition = new TableColumn();
					xTableColumn_DocEdition.setColumn("version");
					xTableColumn_DocEdition.setDataIndex("version");
					xTableColumn_DocEdition.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocEdition.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocVersion");
					xTableColumn_DocEdition.setPara_1("column:id");
					xTableColumn_DocEdition.setSortable(true);
					xTableColumn_DocEdition.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocEdition);
                } else if(currType==5){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docstatus");
            	    colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\" otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";            	    
                	TableColumn xTableColumn_DocStatus = new TableColumn();
					xTableColumn_DocStatus.setColumn("docstatus");
					xTableColumn_DocStatus.setDataIndex("docstatus");
					xTableColumn_DocStatus.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocStatus.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus3");
					xTableColumn_DocStatus.setPara_1("column:id");
					xTableColumn_DocStatus.setPara_2(Integer.toString(user.getLanguage())+"+column:docstatus+column:seccategory");
					xTableColumn_DocStatus.setSortable(true);
					xTableColumn_DocStatus.setWidth(0.05);
					xTableColumnList.add(xTableColumn_DocStatus);
                } else if(currType==6){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.maincategory");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"maincategory\" orderkey=\"maincategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocMaincategory\"/>";
                	TableColumn xTableColumn_MainCategory = new TableColumn();
					xTableColumn_MainCategory.setColumn("maincategory");
					xTableColumn_MainCategory.setDataIndex("maincategory");
					xTableColumn_MainCategory.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_MainCategory.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocMaincategory");
					xTableColumn_MainCategory.setPara_1("column:maincategory");
					xTableColumn_MainCategory.setSortable(true);
					xTableColumn_MainCategory.setWidth(0.1);
					xTableColumnList.add(xTableColumn_MainCategory);
                } else if(currType==7){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.subcategory");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"subcategory\" orderkey=\"subcategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSubcategory\"/>";
                	TableColumn xTableColumn_SubCategory = new TableColumn();
					xTableColumn_SubCategory.setColumn("subcategory");
					xTableColumn_SubCategory.setDataIndex("subcategory");
					xTableColumn_SubCategory.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_SubCategory.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocSubcategory");
					xTableColumn_SubCategory.setPara_1("column:subcategory");
					xTableColumn_SubCategory.setSortable(true);
					xTableColumn_SubCategory.setWidth(0.1);
					xTableColumnList.add(xTableColumn_SubCategory);
                } else if(currType==8){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.seccategory");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"seccategory\" orderkey=\"seccategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSeccategory\"/>";
                	TableColumn xTableColumn_Seccategory = new TableColumn();
					xTableColumn_Seccategory.setColumn("seccategory");
					xTableColumn_Seccategory.setDataIndex("seccategory");
					xTableColumn_Seccategory.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_Seccategory.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocSeccategory");
					xTableColumn_Seccategory.setPara_1("column:seccategory");
					xTableColumn_Seccategory.setSortable(true);
					xTableColumn_Seccategory.setWidth(0.1);
					xTableColumnList.add(xTableColumn_Seccategory);
                } else if(currType==9){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docdepartmentid");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docdepartmentid\" orderkey=\"docdepartmentid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocDepartment\"/>";
              	    TableColumn xTableColumn_DocDepartmentId = new TableColumn();
					xTableColumn_DocDepartmentId.setColumn("docdepartmentid");
					xTableColumn_DocDepartmentId.setDataIndex("docdepartmentid");
					xTableColumn_DocDepartmentId.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocDepartmentId.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocDepartment");
					xTableColumn_DocDepartmentId.setPara_1("column:docdepartmentid");
					xTableColumn_DocDepartmentId.setSortable(true);
					xTableColumn_DocDepartmentId.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocDepartmentId);
                } else if(currType==10){
                    
                    
                } else if(currType==11){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doclangurage");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doclangurage\" orderkey=\"doclangurage\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocLangurage\"/>";
                	TableColumn xTableColumn_DocLangurage = new TableColumn();
					xTableColumn_DocLangurage.setColumn("doclangurage");
					xTableColumn_DocLangurage.setDataIndex("doclangurage");
					xTableColumn_DocLangurage.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocLangurage.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocLangurage");
					xTableColumn_DocLangurage.setPara_1("column:doclangurage");
					xTableColumn_DocLangurage.setSortable(true);
					xTableColumn_DocLangurage.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocLangurage);
                } else if(currType==12){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.keyword");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"keyword\" orderkey=\"keyword\"/>";
                	TableColumn xTableColumn_KeyWord = new TableColumn();
					xTableColumn_KeyWord.setColumn("keyword");
					xTableColumn_KeyWord.setDataIndex("keyword");
					xTableColumn_KeyWord.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_KeyWord.setSortable(true);
					xTableColumn_KeyWord.setWidth(0.1);
					xTableColumnList.add(xTableColumn_KeyWord);
                
                } else if(currType==13){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
                    backFields=getFilterBackFields(backFields,"t1.doccreatedate,t1.doccreatetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
                	TableColumn xTableColumn_DocCreateDate = new TableColumn();
					xTableColumn_DocCreateDate.setColumn("doccreatedate");
					xTableColumn_DocCreateDate.setDataIndex("doccreatedate");
					xTableColumn_DocCreateDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocCreateDate.setSortable(true);
					xTableColumn_DocCreateDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocCreateDate);
                } else if(currType==14){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doclastmoduserid,t1.doclastmoddate,t1.doclastmodtime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
                	TableColumn xTableColumn_DocLastModDate = new TableColumn();
					xTableColumn_DocLastModDate.setColumn("doclastmoddate");
					xTableColumn_DocLastModDate.setDataIndex("doclastmoddate");
					xTableColumn_DocLastModDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocLastModDate.setSortable(true);
					xTableColumn_DocLastModDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocLastModDate);
                } else if(currType==15){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docapproveuserid,t1.docapprovedate,t1.docapprovetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docapprovedate\" orderkey=\"docapprovedate\"/>";
                	TableColumn xTableColumn_DocApproveDate = new TableColumn();
					xTableColumn_DocApproveDate.setColumn("docapprovedate");
					xTableColumn_DocApproveDate.setDataIndex("docapprovedate");
					xTableColumn_DocApproveDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocApproveDate.setSortable(true);
					xTableColumn_DocApproveDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocApproveDate);
                } else if(currType==16){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docinvaluserid,t1.docinvaldate,t1.docinvaltime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docinvaldate\" orderkey=\"docinvaldate\"/>";
                	TableColumn xTableColumn_DocInvalDate = new TableColumn();
					xTableColumn_DocInvalDate.setColumn("docinvaldate");
					xTableColumn_DocInvalDate.setDataIndex("docinvaldate");
					xTableColumn_DocInvalDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocInvalDate.setSortable(true);
					xTableColumn_DocInvalDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocInvalDate);
                } else if(currType==17){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docarchiveuserid,t1.docarchivedate,t1.docarchivetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docarchivedate\" orderkey=\"docarchivedate\"/>";
                	TableColumn xTableColumn_DocArchiveDate = new TableColumn();
					xTableColumn_DocArchiveDate.setColumn("docarchivedate");
					xTableColumn_DocArchiveDate.setDataIndex("docarchivedate");
					xTableColumn_DocArchiveDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocArchiveDate.setSortable(true);
					xTableColumn_DocArchiveDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocArchiveDate);
                } else if(currType==18){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doccanceluserid,t1.doccanceldate,t1.doccanceltime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doccanceldate\" orderkey=\"doccanceldate\"/>";
               		TableColumn xTableColumn_DocCancelDate = new TableColumn();
					xTableColumn_DocCancelDate.setColumn("doccanceldate");
					xTableColumn_DocCancelDate.setDataIndex("doccanceldate");
					xTableColumn_DocCancelDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_DocCancelDate.setSortable(true);
					xTableColumn_DocCancelDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_DocCancelDate);
                } else if(currType==19){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.maindoc");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" otherpara=\"column:maindoc+"+user.getLanguage()+"\" orderkey=\"maindoc\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocMaindoc\"/>";
                	TableColumn xTableColumn_MainDoc = new TableColumn();
					xTableColumn_MainDoc.setColumn("maindoc");
					xTableColumn_MainDoc.setDataIndex("maindoc");
					xTableColumn_MainDoc.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_MainDoc.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocMaindoc");
					xTableColumn_MainDoc.setPara_1("column:id");
					xTableColumn_MainDoc.setPara_2("column:maindoc+"+ user.getLanguage());
					xTableColumn_MainDoc.setSortable(true);
					xTableColumn_MainDoc.setWidth(0.1);
					xTableColumnList.add(xTableColumn_MainDoc);
                } else if(currType==20){
                    
                    
                } else if(currType==21){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.ownerid");
          	        colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
                	TableColumn xTableColumn_OwnerId = new TableColumn();
					xTableColumn_OwnerId.setColumn("ownerid");
					xTableColumn_OwnerId.setDataIndex("ownerid");
					xTableColumn_OwnerId.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_OwnerId.setTransmethod("weaver.splitepage.transform.SptmForDoc.getName");
					xTableColumn_OwnerId.setPara_1("column:ownerid");
					xTableColumn_OwnerId.setPara_2("column:usertype");
					xTableColumn_OwnerId.setSortable(true);
					xTableColumn_OwnerId.setWidth(0.08);
					xTableColumnList.add(xTableColumn_OwnerId);
                } else if(currType==22){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.invalidationdate");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"invalidationdate\" orderkey=\"invalidationdate\"/>";
                	TableColumn xTableColumn_InvalidationDate = new TableColumn();
					xTableColumn_InvalidationDate.setColumn("invalidationdate");
					xTableColumn_InvalidationDate.setDataIndex("invalidationdate");
					xTableColumn_InvalidationDate.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_InvalidationDate.setSortable(true);
					xTableColumn_InvalidationDate.setWidth(0.1);
					xTableColumnList.add(xTableColumn_InvalidationDate);
                }else if(currType==24){
                	int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
             	    
             	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocDummyCategory\"/>";
                 	TableColumn xTableColumn_DocDummyCategory = new TableColumn();
                 	xTableColumn_DocDummyCategory.setColumn("docDummyCategory");
                 	xTableColumn_DocDummyCategory.setDataIndex("docDummyCategory");
                 	xTableColumn_DocDummyCategory.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
                 	xTableColumn_DocDummyCategory.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocDummyCategory");
                 	xTableColumn_DocDummyCategory.setPara_1("column:id");
                 	xTableColumn_DocDummyCategory.setSortable(false);
                 	xTableColumn_DocDummyCategory.setWidth(0.1);
 					xTableColumnList.add(xTableColumn_DocDummyCategory);
                }else if(currType==25){
                	
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.canPrintedNum");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"canPrintedNum\" orderkey=\"canPrintedNum\"/>";
                	TableColumn xTableColumn_CanPrintedNum = new TableColumn();
                	xTableColumn_CanPrintedNum.setColumn("canPrintedNum");
					xTableColumn_CanPrintedNum.setDataIndex("canPrintedNum");
					xTableColumn_CanPrintedNum.setHeader(SystemEnv.getHtmlLabelName(tmplabelid, user.getLanguage()));
					xTableColumn_CanPrintedNum.setSortable(true);
					xTableColumn_CanPrintedNum.setWidth(0.1);
					xTableColumnList.add(xTableColumn_CanPrintedNum);
                }
                
                
            }
        }
    }
	
	
	
	
	
	
	
	//  用户自定义设置
	boolean dspcreater = false ;
	boolean dspcreatedate = false ;
	boolean dspmodifydate = false ;
	boolean dspdocid = false;
	boolean dspcategory = false ;
	boolean dspaccessorynum = false ;
	boolean dspreplynum = false ;
	
	if (UserDefaultManager.getHasdocid().equals("1")) {
	    dspdocid = true;
	}
	/*
	if (UserDefaultManager.getHascreater().equals("1")&&displayUsage==0) {
	      dspcreater = true ;
	      backFields=getFilterBackFields(backFields,"t1.ownerid,t1.usertype");
	      colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
	}
	if (UserDefaultManager.getHascreatedate().equals("1")&&displayUsage==0) { 
	    dspcreatedate = true ;
	    backFields=getFilterBackFields(backFields,"t1.doccreatedate");
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
	}
	if (UserDefaultManager.getHascreatetime().equals("1")&&displayUsage==0) {
	    dspmodifydate = true ;
	    backFields=getFilterBackFields(backFields,"t1.doclastmoddate");
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
	}
	if (UserDefaultManager.getHascategory().equals("1")&&displayUsage==0) {   
	    dspcategory = true ;
	    backFields=getFilterBackFields(backFields,"t1.maincategory");
	    colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory\" returncolumn=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
	}
	*/
	if (UserDefaultManager.getHasreplycount().equals("1")&&displayUsage==0) {  
	    dspreplynum = true ;
	    backFields=getFilterBackFields(backFields,"t1.replaydoccount");
	    colString +="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";
		TableColumn xTableColumn_ReplayDocCount = new TableColumn();
		xTableColumn_ReplayDocCount.setColumn("replaydoccount");
		xTableColumn_ReplayDocCount.setDataIndex("replaydoccount");
		xTableColumn_ReplayDocCount.setHeader(SystemEnv.getHtmlLabelName(18470, user.getLanguage()));
		xTableColumn_ReplayDocCount.setTransmethod("weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount");
		xTableColumn_ReplayDocCount.setPara_1("column:id");
		xTableColumn_ReplayDocCount.setPara_2("column:replaydoccount");
		xTableColumn_ReplayDocCount.setSortable(false);
		xTableColumn_ReplayDocCount.setWidth(0.06);
		xTableColumnList.add(xTableColumn_ReplayDocCount);	
	}
	if (UserDefaultManager.getHasaccessorycount().equals("1")&&displayUsage==0) {  
	    dspaccessorynum = true ;
	    backFields=getFilterBackFields(backFields,"t1.accessorycount");
	    colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";
		
		TableColumn xTableColumn_AccessoryCount = new TableColumn();
		xTableColumn_AccessoryCount.setColumn("accessorycount");
		xTableColumn_AccessoryCount.setDataIndex("accessorycount");
		xTableColumn_AccessoryCount.setHeader(SystemEnv.getHtmlLabelName(2002, user.getLanguage()));
		xTableColumn_AccessoryCount.setSortable(true);
		xTableColumn_AccessoryCount.setWidth(0.06);
		xTableColumnList.add(xTableColumn_AccessoryCount);
	}
	

	backFields=getFilterBackFields(backFields,"t1.sumReadCount,t1.docstatus,t1.sumMark");
	if(displayUsage==0) {
		colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";
		TableColumn xTableColumn_SumReadCount = new TableColumn();
		xTableColumn_SumReadCount.setColumn("sumReadCount");
		xTableColumn_SumReadCount.setDataIndex("sumReadCount");
		xTableColumn_SumReadCount.setHeader(SystemEnv.getHtmlLabelName(18469, user.getLanguage()));
		xTableColumn_SumReadCount.setSortable(true);
		xTableColumn_SumReadCount.setWidth(0.06);
		xTableColumnList.add(xTableColumn_SumReadCount);
		colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" column=\"sumMark\" orderkey=\"sumMark\"/>";
		TableColumn xTableColumn_SumMark = new TableColumn();
		xTableColumn_SumMark.setColumn("sumMark");
		xTableColumn_SumMark.setDataIndex("sumMark");
		xTableColumn_SumMark.setHeader(SystemEnv.getHtmlLabelName(15663, user.getLanguage()));
		xTableColumn_SumMark.setSortable(true);
		xTableColumn_SumMark.setWidth(0.05);
		xTableColumnList.add(xTableColumn_SumMark);
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" otherpara=\""+user.getLanguage()+"\"/>";
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\"  otherpara=\""+user.getLanguage()+"\"/>";
	}
	
	
	if(backFields.startsWith(",")) backFields=backFields.substring(1);
	if(backFields.endsWith(",")) backFields=backFields.substring(0,backFields.length()-1);
	
	
		
	//默认为按文档创建日期排序所以,必须要有这个字段
	//if (backFields.indexOf("doclastmoddate")==-1) {
	//    backFields+=",doclastmoddate";
	//}
	
	
	//eg. sqlwhere: where   docstatus in ('1','2','5')  and seccategory in (1033,1035,1036,1037)  and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.docid and t2.userid=67 and t2.usertype=1 
	if (isNew.equals("yes")) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是"      
	    primarykey="id";
	    if ("oracle".equals(RecordSet.getDBType())) {    
		    //sqlFrom=" (select * from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left join (select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b on a.id=b.docid ";        
		    //sqlWhere="  b.docid is  null) table1";
		    //backFields="table1.*";
	    } else {
	        //sqlFrom="from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left outer join (select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b on a.id=b.docid ";
		    //sqlWhere=" b.docid is  null";
		    //backFields="*";
	    }
	}
	
	if(displayUsage!=0){
		tabletype="thumbnail";
		browser="<browser imgurl=\"/weaver/weaver.docs.docs.ShowDocsImageServlet\" linkkey=\"docId\" linkvaluecolumn=\"id\" />";
	}
	//用于暂时屏蔽外部用户的文档列表的多选框
	if (!"1".equals(loginType)){
		if("checkbox".equals(tabletype)){
			tabletype="";
		}else if("thumbnail".equals(tabletype)){
			tabletype="thumbnailNoCheck";
		}	
	}
	//String tableString
	tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+tabletype+"\">";
	tableString+=browser;
    tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<head>"+colString+"</head>";
    tableString+=operateString;
    tableString+="</table>";  
    
    xTableSql.setBackfields(backFields);
    xTableSql.setOutfields(outFields);
	xTableSql.setPageSize(pagesize);
	xTableSql.setSqlform(sqlFrom);
	xTableSql.setSqlwhere(sqlWhere);
	xTableSql.setSqlgroupby("");
	xTableSql.setSqlprimarykey(primarykey);
	xTableSql.setSqlisdistinct("false");
	xTableSql.setDir(TableConst.DESC);
	xTableSql.setSort(orderBy); 

	TableSql xTableSql_2=new TableSql();
	xTableSql_2.setBackfields(backFields);
	xTableSql_2.setOutfields(outFields);
	xTableSql_2.setSqlwhere(sqlWhere);
	session.setAttribute(sessionId+"_sql",xTableSql_2);
      
} else {
    
	//from
	String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	if(RecordSet.getDBType().equals("oracle"))
	{
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	}
	//backFields
	String backFields="t1.id,t1.seccategory,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname,t1.doccreaterid,";
	//from
	if((Util.getIntValue(DocSearchComInfo.getDate2during(),0)>0&&Util.getIntValue(DocSearchComInfo.getDate2during(),0)<37)||!UserDefaultManager.getHasoperate().equals("1"))
    {
		backFields="t1.id,t1.seccategory,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t1.docextendname,t1.doccreaterid,";
    }
	String  sqlFrom = "DocDetail  t1, "+tables+"  t2";  
	String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
	if(!strCustomSql.equals("")){
	  sqlFrom += ", cus_fielddata tCustom ";
	}
	//where
	
	
	
	//String isNew
	isNew = DocSearchComInfo.getIsNew() ;
	
	
	
	String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
	
	if(!frompage.equals("")){
	 whereclause=whereclause+" and t1.docstatus in ('1','2','5') and t1.usertype=1 ";
	 if(isreply.equals("0")){
	   whereclause+=" and (isreply='' or isreply is null) ";
	 }
	 if(!doccreatedatefrom.equals("")){
	   whereclause+=" and doccreatedate>='"+doccreatedatefrom+"' ";
	 }
     if(!doccreatedateto.equals("")){
       whereclause+=" and doccreatedate<='"+doccreatedateto+"' ";
     }
     if(docpublishtype.equals("1")){
      whereclause+=" and (docpublishtype='1'  or docpublishtype='' or docpublishtype is null ) ";
     }
     if(docpublishtype.equals("2")||docpublishtype.equals("3")){
      whereclause+=" and docpublishtype="+docpublishtype;
     }	 
	}
	
	/* added by wdl 2006-08-28 不显示历史版本 */
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	/* added end */
	
	/* added by wdl 2006-06-13 left menu advanced menu */
	if((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))
		whereclause+=" and maincategory in (" + inMainCategoryStr + ") ";
	if((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))
		whereclause+=" and subcategory in (" + inSubCategoryStr + ") ";
	/* added end */
	
	
	//String tableInfo
	
	tableInfo = "[<a href=\"/docs/search/DocSearch.jsp?from=docsubscribe\">"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"</a>]"+strDummy;
	xTableToolBarList.set(0,"{text:'"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"',iconCls:'btn_rss',handler:function(){window.location = '/docs/search/DocSearch.jsp?from=docsubscribe'}}");
	
	
	
	//用于暂时屏蔽外部用户的订阅功能
	if (!"1".equals(loginType)){
	    tableInfo = "";
	    xTableToolBarList.set(0,"");
	}
	sqlWhere = DocSearchManage.getShareSqlWhere(whereclause,user);
	
	//colString
	String userInfoForotherpara =loginType+"+"+userid;
	String colString ="";
	if(displayUsage==0){
		colString +="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
		TableColumn xTableColumn_icon = new TableColumn();
		xTableColumn_icon.setColumn("docextendname");
		xTableColumn_icon.setDataIndex("docextendname");
		xTableColumn_icon.setHeader("&nbsp;&nbsp;");
		xTableColumn_icon
				.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName");
		xTableColumn_icon.setPara_1("column:docextendname");
		xTableColumn_icon.setSortable(false);
		xTableColumn_icon.setHideable(false);
		xTableColumn_icon.setWidth(0.03);
		xTableColumnList.add(xTableColumn_icon);
	}
	colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
	TableColumn xTableColumn_DocName = new TableColumn();
	xTableColumn_DocName.setColumn("docsubject");
	xTableColumn_DocName.setDataIndex("docsubject");
	xTableColumn_DocName.setHeader(SystemEnv.getHtmlLabelName(58,user.getLanguage()));
	xTableColumn_DocName.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId");
	xTableColumn_DocName.setPara_1("column:id");
	xTableColumn_DocName.setPara_2(userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount");
	xTableColumn_DocName.setTarget("_fullwindow");
	//xTableColumn_DocName.setHref("/docs/docs/DocDsp.jsp");
	xTableColumn_DocName.setLinkkey("id");
	xTableColumn_DocName.setSortable(true);
	xTableColumn_DocName.setWidth(0.22);
	xTableColumnList.add(xTableColumn_DocName);
	if (isNew.equals("yes")&&displayUsage==0) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是" 
	    
	     tabletype="checkbox";
	     tableInfo="";
	     //xTableToolBarList.set(0,"");
	     colString ="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
	     colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIconIsNew\" otherpara=\"column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
		xTableColumnList.clear();
		TableColumn xTableColumn_icon = new TableColumn();
		xTableColumn_icon.setColumn("docextendname");
		xTableColumn_icon.setDataIndex("docextendname");
		xTableColumn_icon.setHeader("&nbsp;&nbsp;");
		xTableColumn_icon.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName");
		xTableColumn_icon.setPara_1("column:docextendname");
		xTableColumn_icon.setSortable(false);
		xTableColumn_icon.setHideable(false);
		xTableColumn_icon.setWidth(0.03);
		xTableColumnList.add(xTableColumn_icon);
		
		TableColumn xTableColumn_DocName3=new TableColumn();
		xTableColumn_DocName3.setColumn("docsubject");
		xTableColumn_DocName3.setDataIndex("docsubject");
		xTableColumn_DocName3.setHeader(SystemEnv.getHtmlLabelName(
				58, user.getLanguage()));
		xTableColumn_DocName3
				.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocNameAndIconIsNew");
		xTableColumn_DocName3.setPara_1("column:id");
		xTableColumn_DocName3.setPara_2("column:docsubject");
		xTableColumn_DocName3.setTarget("_fullwindow");
		//xTableColumn_DocName3.setHref("/docs/docs/DocDsp.jsp");
		xTableColumn_DocName3.setLinkkey("id");
		xTableColumn_DocName3.setSortable(true);
		xTableColumn_DocName3.setWidth(0.22);
		xTableColumnList.add(xTableColumn_DocName3);
	}
	//orderBy
	String orderBy = "doclastmoddate,doclastmodtime";    
	//primarykey
	String primarykey = "t1.id";
	//pagesize
	UserDefaultManager.setUserid(user.getUID());
	UserDefaultManager.selectUserDefault();
	int pagesize = UserDefaultManager.getNumperpage();
	if(pagesize <2) pagesize=10;
	
	//operateString userType_userId_userSeclevel
	String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
	String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel+column:id";
	String operateString = "";
	if (UserDefaultManager.getHasoperate().equals("1")&&displayUsage==0) 
	{
	    operateString= "<operates width=\"20%\">";
        operateString+=" <popedom transmethod=\"weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2\"  otherpara=\""+popedomOtherpara+"\" otherpara2=\""+popedomOtherpara2+"\"></popedom> ";
        operateString+="     <operate href=\"/docs/docs/DocEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>";
        operateString+="     <operate href=\"javascript:doDocDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_fullwindow\" index=\"2\"/>";
        operateString+="     <operate href=\"javascript:doDocShare()\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" target=\"_fullwindow\" index=\"3\"/>";
        operateString+="     <operate href=\"javascript:doDocViewLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" target=\"_fullwindow\" index=\"4\"/>";       
        operateString+="</operates>";

	
		xTableOperatePopedom.setTransmethod("weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2");
		xTableOperatePopedom.setOtherpara(popedomOtherpara);
		xTableOperatePopedom.setOtherpara2(popedomOtherpara2);
		TableOperation xTableOperation_Edit = new TableOperation();
		xTableOperation_Edit.setHref("/docs/docs/DocEdit.jsp");
		xTableOperation_Edit.setLinkkey("id");
		xTableOperation_Edit.setLinkvaluecolumn("id");
		xTableOperation_Edit.setText(SystemEnv.getHtmlLabelName(93,user.getLanguage()));
		xTableOperation_Edit.setTarget("_fullwindow");
		xTableOperation_Edit.setIndex("1");
		xTableOperationList.add(xTableOperation_Edit);

		TableOperation xTableOperation_Del = new TableOperation();
		xTableOperation_Del.setHref("javascript:doDocDel()");
		xTableOperation_Del.setText(SystemEnv.getHtmlLabelName(91, user.getLanguage()));
		xTableOperation_Del.setTarget("_fullwindow");
		xTableOperation_Del.setIndex("2");
		xTableOperationList.add(xTableOperation_Del);

		TableOperation xTableOperation_Share = new TableOperation();
		xTableOperation_Share.setHref("javascript:doDocShare()");
		xTableOperation_Share.setText(SystemEnv.getHtmlLabelName(119,user.getLanguage()));
		xTableOperation_Share.setTarget("_fullwindow");
		xTableOperation_Share.setIndex("3");
		xTableOperationList.add(xTableOperation_Share);

		TableOperation xTableOperation_Log = new TableOperation();
		xTableOperation_Log.setHref("javascript:doDocViewLog()");
		xTableOperation_Log.setText(SystemEnv.getHtmlLabelName(83, user.getLanguage()));
		xTableOperation_Log.setTarget("_fullwindow");
		xTableOperation_Log.setIndex("4");
		xTableOperationList.add(xTableOperation_Log);
	}

	
	//  用户自定义设置
	boolean dspcreater = false ;
	boolean dspcreatedate = false ;
	boolean dspmodifydate = false ;
	boolean dspdocid = false;
	boolean dspcategory = false ;
	boolean dspaccessorynum = false ;
	boolean dspreplynum = false ;
	
	
	if (UserDefaultManager.getHasdocid().equals("1")) {
	    dspdocid = true;    
	}
	if (UserDefaultManager.getHascreater().equals("1")&&displayUsage==0) {
	      dspcreater = true ;
	      backFields+="ownerid,t1.usertype,";
	      colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
		TableColumn xTableColumn_OwnerId = new TableColumn();
		xTableColumn_OwnerId.setColumn("ownerid");
		xTableColumn_OwnerId.setDataIndex("ownerid");
		xTableColumn_OwnerId.setHeader(SystemEnv.getHtmlLabelName(79, user.getLanguage()));
		xTableColumn_OwnerId.setTransmethod("weaver.splitepage.transform.SptmForDoc.getName");
		xTableColumn_OwnerId.setPara_1("column:ownerid");
		xTableColumn_OwnerId.setPara_2("column:usertype");
		xTableColumn_OwnerId.setSortable(true);
		xTableColumn_OwnerId.setWidth(0.08);
		xTableColumnList.add(xTableColumn_OwnerId);
	}
	if (UserDefaultManager.getHascreatedate().equals("1")&&displayUsage==0) { 
	    dspcreatedate = true ;
	    backFields+="doccreatedate,";
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
		TableColumn xTableColumn_DocCreateDate = new TableColumn();
		xTableColumn_DocCreateDate.setColumn("doccreatedate");
		xTableColumn_DocCreateDate.setDataIndex("doccreatedate");
		xTableColumn_DocCreateDate.setHeader(SystemEnv.getHtmlLabelName(722, user.getLanguage()));
		xTableColumn_DocCreateDate.setSortable(true);
		xTableColumn_DocCreateDate.setWidth(0.1);
		xTableColumnList.add(xTableColumn_DocCreateDate);
	}
	if (UserDefaultManager.getHascreatetime().equals("1")&&displayUsage==0) {
	    dspmodifydate = true ;
	    //backFields+="doclastmoddate,";
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
		TableColumn xTableColumn_DocLastModDate = new TableColumn();
		xTableColumn_DocLastModDate.setColumn("doclastmoddate");
		xTableColumn_DocLastModDate.setDataIndex("doclastmoddate");
		xTableColumn_DocLastModDate.setHeader(SystemEnv.getHtmlLabelName(723, user.getLanguage()));
		xTableColumn_DocLastModDate.setSortable(true);
		xTableColumn_DocLastModDate.setWidth(0.1);
		xTableColumnList.add(xTableColumn_DocLastModDate);
	}
	if (UserDefaultManager.getHascategory().equals("1")&&displayUsage==0) {   
	    dspcategory = true ;
	    backFields+="maincategory,";
	    colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory\" returncolumn=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
		TableColumn xTableColumn_Maincate=new TableColumn();
		xTableColumn_Maincate.setColumn("maincategory");
		xTableColumn_Maincate.setDataIndex("maincategory");
		xTableColumn_Maincate.setTransmethod("weaver.splitepage.transform.SptmForDoc.getAllDirName");
		xTableColumn_Maincate.setPara_1("column:id");
		xTableColumn_Maincate.setHeader(SystemEnv.getHtmlLabelName(92,user.getLanguage()));
		xTableColumn_Maincate.setSortable(true);
		xTableColumn_Maincate.setWidth(0.14); 
		xTableColumnList.add(xTableColumn_Maincate);
	}
	if (UserDefaultManager.getHasreplycount().equals("1")&&displayUsage==0) {  
	    dspreplynum = true ;
	    backFields+="replaydoccount,";
	    colString +="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";
		TableColumn xTableColumn_Replaydoccount=new TableColumn();
		xTableColumn_Replaydoccount.setColumn("replaydoccount");
		xTableColumn_Replaydoccount.setDataIndex("replaydoccount");
		xTableColumn_Replaydoccount.setTransmethod("weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount");
		xTableColumn_Replaydoccount.setPara_1("column:id");
		xTableColumn_Replaydoccount.setPara_2("column:replaydoccount");
		xTableColumn_Replaydoccount.setHeader(SystemEnv.getHtmlLabelName(18470,user.getLanguage()));
		xTableColumn_Replaydoccount.setSortable(false);
		xTableColumn_Replaydoccount.setWidth(0.06); 
		xTableColumnList.add(xTableColumn_Replaydoccount);
	}
	if (UserDefaultManager.getHasaccessorycount().equals("1")&&displayUsage==0) {  
	    dspaccessorynum = true ;
	    backFields+="accessorycount,";
	    colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";
		TableColumn xTableColumn_AccessoryCount = new TableColumn();
		xTableColumn_AccessoryCount.setColumn("accessorycount");
		xTableColumn_AccessoryCount.setDataIndex("accessorycount");
		xTableColumn_AccessoryCount.setHeader(SystemEnv.getHtmlLabelName(2002, user.getLanguage()));
		xTableColumn_AccessoryCount.setSortable(true);
		xTableColumn_AccessoryCount.setWidth(0.06);
		xTableColumnList.add(xTableColumn_AccessoryCount);
	}
	
	backFields+="sumReadCount,docstatus,sumMark";
	
	if(displayUsage==0) {
		colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";
		TableColumn xTableColumn_SumReadCount = new TableColumn();
		xTableColumn_SumReadCount.setColumn("sumReadCount");
		xTableColumn_SumReadCount.setDataIndex("sumReadCount");
		xTableColumn_SumReadCount.setHeader(SystemEnv.getHtmlLabelName(18469, user.getLanguage()));
		xTableColumn_SumReadCount.setSortable(true);
		xTableColumn_SumReadCount.setWidth(0.06);
		xTableColumnList.add(xTableColumn_SumReadCount);
		colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" column=\"sumMark\" orderkey=\"sumMark\"/>";
		TableColumn xTableColumn_SumMark = new TableColumn();
		xTableColumn_SumMark.setColumn("sumMark");
		xTableColumn_SumMark.setDataIndex("sumMark");
		xTableColumn_SumMark.setHeader(SystemEnv.getHtmlLabelName(15663, user.getLanguage()));
		xTableColumn_SumMark.setSortable(true);
		xTableColumn_SumMark.setWidth(0.05);
		xTableColumnList.add(xTableColumn_SumMark);
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" otherpara=\""+user.getLanguage()+"\"/>";
		colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\"  otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";
		TableColumn xTableColumn_DocStatus = new TableColumn();
		xTableColumn_DocStatus.setColumn("docstatus");
		xTableColumn_DocStatus.setDataIndex("docstatus");
		xTableColumn_DocStatus.setHeader(SystemEnv.getHtmlLabelName(602, user.getLanguage()));
		xTableColumn_DocStatus.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus3");
		xTableColumn_DocStatus.setPara_1("column:id");
		xTableColumn_DocStatus.setPara_2(""+user.getLanguage()+"+column:docstatus+column:seccategory");
		xTableColumn_DocStatus.setSortable(true);
		xTableColumn_DocStatus.setWidth(0.05);
		xTableColumnList.add(xTableColumn_DocStatus);
	}
		
	//默认为按文档创建日期排序所以,必须要有这个字段
	//if (backFields.indexOf("doclastmoddate")==-1) {
	//    backFields+=",doclastmoddate";
	//}
	
	
	//eg. sqlwhere: where   docstatus in ('1','2','5')  and seccategory in (1033,1035,1036,1037)  and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.docid and t2.userid=67 and t2.usertype=1 
	if (isNew.equals("yes")) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是"      
	    primarykey="id";
	    if ("oracle".equals(RecordSet.getDBType())) {    
		   // sqlFrom=" (select * from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a ,(select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b ";        
		    //sqlWhere=" a.id=b.docid(+) and b.docid is  null) table1";
		    //backFields="table1.*";
	    } else {
	       // sqlFrom="from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left outer join (select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b on a.id=b.docid ";
		   //// sqlWhere=" b.docid is  null";
		    //backFields="*";
	    }
	} 
	//虚拟目录
	if(showtype==3){
		primarykey="id";
	  
		sqlFrom="from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left outer join (select docid from DocDummyDetail where catelogid="+Util.getIntValue(treeDocFieldId,0)+") b on a.id=b.docid ";
		sqlWhere=" b.docid is  null";
		backFields="*";
		tableInfo="";
		xTableToolBarList.set(0,"");
	}
	if(displayUsage!=0){
		tabletype="thumbnail";
		browser="<browser imgurl=\"/weaver/weaver.docs.docs.ShowDocsImageServlet\" linkkey=\"docId\" linkvaluecolumn=\"id\" />";
	}
	//用于暂时屏蔽外部用户的文档列表的多选框
	if (!"1".equals(loginType)){
		if("checkbox".equals(tabletype)){
			tabletype="";
		}else if("thumbnail".equals(tabletype)){
			tabletype="thumbnailNoCheck";
		}	
	}
	//String tableString
	tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+tabletype+"\">";
	tableString+=browser;
	tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<head>"+colString+"</head>";
    tableString+=operateString;
    tableString+="</table>";     
       
	xTableSql.setBackfields(backFields);
	xTableSql.setOutfields(outFields);
	xTableSql.setPageSize(pagesize);
	xTableSql.setSqlform(sqlFrom);
	xTableSql.setSqlwhere(sqlWhere);
	xTableSql.setSqlgroupby("");
	xTableSql.setSqlprimarykey(primarykey);
	xTableSql.setSqlisdistinct("false");
	xTableSql.setDir(TableConst.DESC);
	xTableSql.setSort(orderBy);
	
	TableSql xTableSql_2=new TableSql();
	xTableSql_2.setBackfields(backFields);
	xTableSql_2.setSqlwhere(sqlWhere);
	xTableSql_2.setOutfields(outFields);
	session.setAttribute(sessionId+"_sql",xTableSql_2);   
}       
%>

					<% if(displayUsage==0){ 
							if(tabletype =="checkbox")
							{
								xTable.setTableGridType(TableConst.CHECKBOX);
							}
							else
							{
								xTable.setTableGridType(TableConst.NONE);
							}
							xTable.setTableNeedRowNumber(true);												
							xTable.setTableSql(xTableSql);
							xTable.setTableColumnList(xTableColumnList);
							xTable.setTableOperatePopedom(xTableOperatePopedom);
							xTable.setTableOperationList(xTableOperationList);
							xTable.setUser(user);
							xTable.setTableId("docsearch");
							String xTableToolBar = "";
							
							for(int i=0;i<xTableToolBarList.size();i++){
							
								if("".equals(xTableToolBarList.get(0))){
									break;
								}
								if(!"".equals(xTableToolBarList.get(i)))
									xTableToolBar+=xTableToolBarList.get(i).toString()+",'|',";
								
							}
							if(!xTableToolBar.equals("")){
								xTableToolBar = xTableToolBar.substring(0,xTableToolBar.length()-5);
							}
							xTableToolBar="["+xTableToolBar+"]";
							
							xTable.setTbar(xTableToolBar);
							
							
														
					%>		
										
					<% } else { %>
							
							
					<% }%> 
		



<%! 
private String getFilterBackFields(String oldbf,String addedbfs){
    String[] bfs = Util.TokenizerString2(addedbfs,",");
    String bf = "";
    for(int i=0;bfs!=null&&bfs.length>0&&i<bfs.length;i++){
        bf = bfs[i];
        if(oldbf.indexOf(","+bf+",")==-1){
            if(oldbf.endsWith(",")) oldbf+=bf+",";
            else oldbf+=","+bf+",";
        }
    }
    return oldbf;
}
%>

<%

if(displayUsage==0&&false){	
	out.println(xTable.toString2("_table")+"^^"+sessionId);
	
}else{
	session.setAttribute(sessionId,tableString);
	out.println("var tableString = '"+tableString+"'; var tableInfo = '"+tableInfo+"';var sessionId='"+sessionId+"';"); 
	
	//System.out.println("111111111111111111111111"); 
	//System.out.println("var tableString = '"+tableString+"'; var tableInfo = '"+tableInfo+"';"); 
	
}


return;
%>