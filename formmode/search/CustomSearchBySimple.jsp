<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.formmode.interfaces.ModeManageMenu" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Map.Entry" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="crmComInfo1" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page" />
<jsp:useBean id="DeleteData" class="weaver.formmode.search.batchoperate.DeleteData" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>

</head>
<%
int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0);
String logintype = ""+user.getLogintype();    
int usertype = 0;
String userid = ""+user.getUID();
if(logintype.equals("2")){
	usertype= 1;
}

String createrid=Util.null2String(request.getParameter("createrid"));
String docids=Util.null2String(request.getParameter("docids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String hrmids=Util.null2String(request.getParameter("hrmids"));
String prjids=Util.null2String(request.getParameter("prjids"));
String creatertype=Util.null2String(request.getParameter("creatertype"));
String workflowid=""+Util.getIntValue(request.getParameter("workflowid"));
String nodetype=Util.null2String(request.getParameter("nodetype"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
String lastfromdate=Util.null2String(request.getParameter("lastfromdate"));
String lasttodate=Util.null2String(request.getParameter("lasttodate"));
String requestmark=Util.null2String(request.getParameter("requestmark"));
String branchid=Util.null2String(request.getParameter("branchid"));
int during=Util.getIntValue(request.getParameter("during"),0);
int order=Util.getIntValue(request.getParameter("order"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"));
int subday1=Util.getIntValue(request.getParameter("subday1"),0);
int subday2=Util.getIntValue(request.getParameter("subday2"),0);
int maxday=Util.getIntValue(request.getParameter("maxday"),0);
int state=Util.getIntValue(request.getParameter("state"),0);
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
String customid=Util.null2String(request.getParameter("customid"));
int viewtype=Util.getIntValue(request.getParameter("viewtype"),0);
boolean issimple=Util.null2String(request.getParameter("issimple")).equals("true")?true:false;
issimple = true;
String searchtype=Util.null2String(request.getParameter("searchtype"));
int isresearch=Util.getIntValue(request.getParameter("isresearch"),1);
String createurl = "";
String tempquerystring = Util.null2String(request.getQueryString()); 
String tempquerystrings[] = tempquerystring.split("&");
for(int i=0;i<tempquerystrings.length;i++){
	String tempquery = tempquerystrings[i];
	if(tempquery.toLowerCase().startsWith("field")){
		createurl += "&"+tempquery;
	}
}

//快捷搜索 1本周,2本月,3本季,4本年
String thisdate=Util.null2String(request.getParameter("thisdate"));
//快捷搜索 1本部门,2本部门(包含下级部门),3本分部,4本分部(包含下级分部)
String thisorg=Util.null2String(request.getParameter("thisorg"));
//获得快捷搜索的sql
String quickSql = FormModeTransMethod.getQuickSearch(user,thisdate,thisorg);


//Hashtable conht=new Hashtable();    
//if(isresearch==1){
	//conht=(Hashtable)session.getAttribute("conhashtable_"+userid);    
//}
String tempcustomid=customid;
String isbill="1";
String formID="0";
String customname="";
String workflowname="";
String titlename ="";
String tablename="";
String modeid = "0";
String disQuickSearch = "";
String defaultsql = "";
String norightlist = "";
int opentype = 0;
rs.execute("select a.modeid,a.customname,a.customdesc,b.modename,b.formid,a.disQuickSearch,a.defaultsql,a.norightlist,a.opentype from mode_customsearch a,modeinfo b where a.modeid = b.id and a.id="+customid);
if(rs.next()){
    formID=Util.null2String(rs.getString("formid"));
    customname=Util.null2String(rs.getString("customname"));
    titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+customname;
    modeid=""+Util.getIntValue(rs.getString("modeid"),0);
    
    disQuickSearch = "" + Util.toScreenToEdit(rs.getString("disQuickSearch"),user.getLanguage());
    defaultsql = "" + Util.toScreenToEdit(rs.getString("defaultsql"),user.getLanguage()).trim();
    defaultsql = FormModeTransMethod.getDefaultSql(user,thisdate,thisorg,defaultsql);
    norightlist = Util.null2String(rs.getString("norightlist"));
    opentype = Util.getIntValue(rs.getString("opentype"),0);//0 弹出，1当前窗口
}

if(viewtype == 3){//监控权限判断
	ModeRightInfo.setModeId(Util.getIntValue(modeid));
	ModeRightInfo.setType(viewtype);
	ModeRightInfo.setUser(user);
	boolean isRight = false;
	isRight = ModeRightInfo.checkUserRight(viewtype);
	if(!isRight){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
}


rs.executeSql("select tablename from workflow_bill where id = " + formID);
if (rs.next()){
	tablename = rs.getString("tablename"); 
}

String method=Util.null2String(request.getParameter("method"));
String deletebillid=Util.null2String(request.getParameter("deletebillid"));
if(method.equals("del")){//删除数据
	DeleteData.setClientaddress(request.getRemoteAddr());
	DeleteData.setDeletebillid(deletebillid);
	DeleteData.setFormid(Util.getIntValue(formID));
	DeleteData.setModeid(Util.getIntValue(modeid));
	DeleteData.setTablename(tablename);
	DeleteData.setUser(user);
	DeleteData.setViewtype(viewtype);
	DeleteData.DelData();
}

String imagefilename = "/images/hdDOC.gif";
String needfav ="1";
String needhelp ="";

//============================================查询结果====================================

boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
	
String complete1=Util.null2String(request.getParameter("complete"));

String userids="";

//下面开始自定义查询条件
String[] checkcons = request.getParameterValues("check_con");
String whereclause=" where t1.formmodeid = " + modeid + " ";
String sqlwhere="";
ArrayList ids = new ArrayList();
ArrayList colnames = new ArrayList();
ArrayList opts = new ArrayList();
ArrayList values = new ArrayList();
ArrayList names = new ArrayList();
ArrayList opt1s = new ArrayList();
ArrayList value1s = new ArrayList();
ids.clear();
colnames.clear();
opt1s.clear();
names.clear();
value1s.clear();
opts.clear();
values.clear();
Hashtable conht=new Hashtable();
if(checkcons!=null){

for(int i=0;i<checkcons.length;i++){
	String tmpid = ""+checkcons[i];
	String tmpcolname = ""+Util.null2String(request.getParameter("con"+tmpid+"_colname"));
	String htmltype = ""+Util.null2String(request.getParameter("con"+tmpid+"_htmltype"));
	String type = ""+Util.null2String(request.getParameter("con"+tmpid+"_type"));
	String tmpopt = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt"));
	String tmpvalue = ""+Util.null2String(request.getParameter("con"+tmpid+"_value"));
	String tmpname = ""+Util.null2String(request.getParameter("con"+tmpid+"_name"));
	String tmpopt1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt1"));
	String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_value1"));
	conht.put("con_"+tmpid,"1");
	conht.put("con_"+tmpid+"_opt",tmpopt);
	conht.put("con_"+tmpid+"_opt1",tmpopt1);
	conht.put("con_"+tmpid+"_value",tmpvalue);
	conht.put("con_"+tmpid+"_value1",tmpvalue1);
	conht.put("con_"+tmpid+"_name",tmpname);
    if(tmpid.equals("_1")){
        fromdate=tmpvalue;
        todate=tmpvalue1;
    }else if(tmpid.equals("_2")){
        createrid=tmpvalue;
    }else{
		if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框
			if(!tmpvalue.equals(""))
			{
				if(tmpopt.equals("1"))	sqlwhere+=" and (t1."+tmpcolname+" ='"+tmpvalue +"' ";
				if(tmpopt.equals("2"))	sqlwhere+=" and (t1."+tmpcolname+" <>'"+tmpvalue +"' ";
				if(tmpopt.equals("3")){
				    ArrayList tempvalues=Util.TokenizerString(Util.StringReplace(tmpvalue,"　"," ")," ");
				    sqlwhere += " and (";
				    for(int k=0;k<tempvalues.size();k++){
				        if(k==0) sqlwhere += "t1."+tmpcolname;
				        else  sqlwhere += " or t1."+tmpcolname;
				        tmpvalue=Util.StringReplace(Util.StringReplace((String)tempvalues.get(k),"+","%"),"＋","%");
				        if(!isoracle&&!isdb2){
				            int indx=tmpvalue.indexOf("[");
				            if(indx<0) indx=tmpvalue.indexOf("]");
				            if(indx<0){
				                sqlwhere += " like '%"+tmpvalue+"%' ";
				            }else{
				                sqlwhere += " like '%"+Util.StringReplace(Util.StringReplace(Util.StringReplace(tmpvalue,"/","//"),"[","/["),"]","/]")+"%' ESCAPE '/' ";
				            }
				        }else{
				            sqlwhere += " like '%"+tmpvalue+"%' ";
				        }
				    }
				}
				if(tmpopt.equals("4")){
				    ArrayList tempvalues=Util.TokenizerString(Util.StringReplace(tmpvalue,"　"," ")," ");
				    for(int k=0;k<tempvalues.size();k++){
				        if(k==0) sqlwhere += "and (t1."+tmpcolname;
				        else  sqlwhere += " and t1."+tmpcolname;
				        tmpvalue=Util.StringReplace(Util.StringReplace((String)tempvalues.get(k),"+","%"),"＋","%");
				        if(!isoracle&&!isdb2){
				            int indx=tmpvalue.indexOf("[");
				            if(indx<0) indx=tmpvalue.indexOf("]");
				            if(indx<0){
				                sqlwhere += " not like '%"+tmpvalue+"%' ";
				            }else{
				                sqlwhere += " not like '%"+Util.StringReplace(Util.StringReplace(Util.StringReplace(tmpvalue,"/","//"),"[","/["),"]","/]")+"%' ESCAPE '/' ";
				            }
				        }else{
				            sqlwhere += " not like '%"+tmpvalue+"%' ";
				        }
				    }
				}
			}
			} else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
				if(!tmpvalue.equals("")){
					sqlwhere += "and (t1."+tmpcolname;
					if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
					if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
					if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
					if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
					if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
					if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";
				}
				if(!tmpvalue1.equals("")){
					sqlwhere += " and t1."+tmpcolname;
					if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
					if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
					if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
					if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
				    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
					if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
				}
			} else if(htmltype.equals("4")){   //check类型 = !=
				sqlwhere += "and (t1."+tmpcolname;
				if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
				else sqlwhere +="='1' ";
			} else if(htmltype.equals("5")){  //选择框   = !=
				sqlwhere += "and (t1."+tmpcolname;
				if(tmpvalue.equals("")) 
				{
				if(tmpopt.equals("1"))	sqlwhere+=" is null ";
				if(tmpopt.equals("2"))	sqlwhere+=" is not  null ";
				}
				else
				{
				if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
				if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
				}
			} else if(htmltype.equals("3") && (type.equals("1")||type.equals("9")||type.equals("4")||type.equals("7")||type.equals("8")||type.equals("16"))){//浏览框单人力资源  条件为多人力 (int  not  in),条件为多文挡,条件为多部门,条件为多客户,条件为多项目,条件为多请求
				if(!tmpvalue.equals("")) {
					sqlwhere += "and (t1."+tmpcolname;
					if(tmpopt.equals("1"))	sqlwhere+=" in ("+tmpvalue +") ";
					if(tmpopt.equals("2"))	sqlwhere+=" not in ("+tmpvalue +") ";
				}
			}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别 > >= = < !  and > >= = < !
				if(!tmpvalue.equals("")){
					sqlwhere += "and (t1."+tmpcolname;
					if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
					if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
					if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
					if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
					if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
					if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";
				}
				if(!tmpvalue1.equals("")){
					sqlwhere += " and t1."+tmpcolname;
					if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
					if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
					if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
					if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
				    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
					if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
				}
			}//职位安全级别end
			else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期 > >= = < !  and > >= = < !
				if(!tmpvalue.equals("")){
					sqlwhere += "and (t1."+tmpcolname;
					if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
					if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
					if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
					if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
					if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
					if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";
				}
				if(!tmpvalue1.equals("")){
					sqlwhere += " and t1."+tmpcolname;
					if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
					if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
					if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
					if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
				    if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
					if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
				}
			} else if(htmltype.equals("3") && (type.equals("17")||type.equals("57")||type.equals("135")||type.equals("152")||type.equals("18")||type.equals("160"))){  //浏览框  多选筐条件为单选筐(多文挡) 多选筐条件为单选筐（多部门） 多选筐条件为单选筐（多项目 ）多选筐条件为单选筐（多项目 ）
				if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
				      sqlwhere += "and (','||t1."+tmpcolname+"||','";
				else
				      sqlwhere += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
				if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
				if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
			}else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137")||type.equals("142"))){//浏览框  
		 		if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
		       		sqlwhere += "and (','||t1."+tmpcolname+"||','";
				else
					sqlwhere += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
				if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
				if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
			} else if (htmltype.equals("3")){   //其他浏览框
				if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
					sqlwhere += "and (','||t1."+tmpcolname+"||','";
				else
					sqlwhere += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
				if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
				if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
			} else if (htmltype.equals("6")){   //附件上传同多文挡
				if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
					sqlwhere += "and (','||t1."+tmpcolname+"||','";
				else
					sqlwhere += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
				if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
				if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
			}
			if (htmltype.equals("1")|| htmltype.equals("2")||(htmltype.equals("3") && (type.equals("1")||type.equals("9")||type.equals("4")||type.equals("7")||type.equals("8")||type.equals("16")))||(htmltype.equals("3") && type.equals("24"))||(htmltype.equals("3") &&( type.equals("2") || type.equals("19")))) {
				if(!tmpvalue.equals("")){
					sqlwhere +=") ";
				}
			}else{
				sqlwhere +=") ";
			}
		}
	}
}
session.setAttribute("conhashtable_"+userid,conht);
whereclause+=sqlwhere;
sqlwhere = whereclause;
String querys=Util.null2String(request.getParameter("query"));
String fromself =Util.null2String(request.getParameter("fromself"));
String fromselfSql =Util.null2String(request.getParameter("fromselfSql"));
String isfirst =Util.null2String(request.getParameter("isfirst"));
String treesqlwhere = Util.null2String(request.getParameter("treesqlwhere"));
String formmodeid=modeid;
String orderby = "t1.id";
int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);
int perpage=10;

boolean CreateRight = false;//新建权限
boolean BatchImportRight = false;//批量导入权限
boolean DelRight = false;//删除权限

ModeRightInfo.setModeId(Util.getIntValue(modeid));
ModeRightInfo.setType(1);//新建
ModeRightInfo.setUser(user);
CreateRight = ModeRightInfo.checkUserRight(1);

ModeRightInfo.setType(4);//批量导入
BatchImportRight = ModeRightInfo.checkUserRight(4);
if(!BatchImportRight){
	BatchImportRight = HrmUserVarify.checkUserRight("ModeSetting:All", user);
}


%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
//鼠标右键
ModeManageMenu ModeManageMenu = new ModeManageMenu();
ModeManageMenu.setCustomid(Util.getIntValue(customid,0));
ModeManageMenu.setModeId(Util.getIntValue(modeid,0));
ModeManageMenu.setRCMenuHeightStep(RCMenuHeightStep);
ModeManageMenu.setUser(user);
ModeManageMenu.setCreateRight(CreateRight);
ModeManageMenu.setBatchImportRight(BatchImportRight);
ModeManageMenu.getSearchMenu();
HashMap urlMap = ModeManageMenu.getUrlMap();
RCMenu += ModeManageMenu.getRCMenu() ;
RCMenuHeight += ModeManageMenu.getRCMenuHeight() ;
%>

<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
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

<form name="frmmain" method="post" action="/formmode/search/CustomSearchBySimple.jsp">
<input name=iswaitdo type=hidden value="<%=iswaitdo%>">
<input name=workflowid type=hidden value="<%=workflowid%>">
<input name=customid type=hidden value="<%=customid%>">
<input name=viewtype type=hidden value="<%=viewtype%>">
<input name=issimple type=hidden value="<%=issimple%>">
<input name=searchtype type=hidden value="<%=searchtype%>">
<input name="deletebillid" id="deletebillid" type=hidden value="">
<input name="method" id="method" type=hidden value="">
<input name="treesqlwhere" id="treesqlwhere" type=hidden value="<%=treesqlwhere%>">

<%
	if(!disQuickSearch.equals("1")) {
%>
		<table class="viewform">
			<colgroup>
				<col width="10%">
				<col width="39%">
				<col width="8%">
				<col width="10%">
				<col width="39%">
			</colgroup>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(81449,user.getLanguage())%></td>
				<td class="field">
					<input type="checkbox" id="thisdate" name="thisdate" value="1" onclick="clickThisDate(this)" <%if(thisdate.equals("1")){out.println("checked");}%>><span style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(thisdate)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchDate('1')">[<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%>]</span>
					<input type="checkbox" id="thisdate" name="thisdate" value="2" onclick="clickThisDate(this)" <%if(thisdate.equals("2")){out.println("checked");}%>><span style="font-size:12px;TEXT-DECORATION:none;color:<%if("2".equals(thisdate)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchDate('2')">[<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%>]</span>
					<br>
					<input type="checkbox" id="thisdate" name="thisdate" value="3" onclick="clickThisDate(this)" <%if(thisdate.equals("3")){out.println("checked");}%>><span style="font-size:12px;TEXT-DECORATION:none;color:<%if("3".equals(thisdate)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchDate('3')">[<%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%>]</span>
					<input type="checkbox" id="thisdate" name="thisdate" value="4" onclick="clickThisDate(this)" <%if(thisdate.equals("4")){out.println("checked");}%>><span style="font-size:12px;TEXT-DECORATION:none;color:<%if("4".equals(thisdate)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchDate('4')">[<%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%>]</span>
				</td>
				<td></td>
				<td><%=SystemEnv.getHtmlLabelName(81448,user.getLanguage())%></td>
				<td class="field">
					<input type="checkbox" id="thisorg" name="thisorg" value="1" onclick="clickThisOrg(this)" <%if(thisorg.equals("1")){out.println("checked");}%>><span style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(thisorg)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchOrg('1')">[<%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%>]</span>
					<input type="checkbox" id="thisorg" name="thisorg" value="2" onclick="clickThisOrg(this)" <%if(thisorg.equals("2")){out.println("checked");}%>><span style="font-size:12px;TEXT-DECORATION:none;color:<%if("2".equals(thisorg)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchOrg('2')">[<%=SystemEnv.getHtmlLabelName(81362,user.getLanguage())%>]</span>
					<br>
					<input type="checkbox" id="thisorg" name="thisorg" value="3" onclick="clickThisOrg(this)" <%if(thisorg.equals("3")){out.println("checked");}%>><span style="font-size:12px;TEXT-DECORATION:none;color:<%if("3".equals(thisorg)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchOrg('3')">[<%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%>]</span>
					<input type="checkbox" id="thisorg" name="thisorg" value="4" onclick="clickThisOrg(this)" <%if(thisorg.equals("4")){out.println("checked");}%>><span style="font-size:12px;TEXT-DECORATION:none;color:<%if("4".equals(thisorg)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="quickSearchOrg('4')">[<%=SystemEnv.getHtmlLabelName(81363,user.getLanguage())%>]</span>
				</td>	
			</tr>
			<TR class=Separartor style="height:1px;"><td class="Line" COLSPAN=5></TD></TR>
		</table>
<%
	}
%>
<table class="viewform">
  <colgroup>
  <col width="10%">
  <col width="39%">
  <col width="8%">
  <col width="10%">
  <col width="39%">
  </colgroup>
  <tbody>
  <!-- 
  <TR class="Title"><th COLSPAN=5><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></th></TR>
  <TR style="height:1px;" class=Separartor><TD class="Line1" COLSPAN=5></TD></TR>
   -->
   <input type='checkbox' name='check_con' style="display:none">
<%//以下开始列出自定义查询条件
sql="";
if(RecordSet.getDBType().equals("oracle")){
    sql = "select * from (select mode_CustomDspField.queryorder ,mode_CustomDspField.showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,to_char(workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield,mode_CustomDspField,mode_CustomSearch where mode_CustomDspField.customid=mode_Customsearch.id and mode_CustomSearch.id="+customid+" and mode_CustomDspField.isquery='1' and workflow_billfield.billid='"+formID+"' and workflow_billfield.id=mode_CustomDspField.fieldid ";
}else{
    sql = "select * from (select mode_CustomDspField.queryorder ,mode_CustomDspField.showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,convert(varchar,workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield,mode_CustomDspField,mode_CustomSearch where mode_CustomDspField.customid=mode_CustomSearch.id and mode_CustomSearch.id="+customid+" and mode_CustomDspField.isquery='1' and workflow_billfield.billid='"+formID+"' and workflow_billfield.id=mode_CustomDspField.fieldid ";
}

    sql+=" union select queryorder,showorder,fieldid as id,'' as name,'' as label,'' as dbtype,'' as httype,0 as type from mode_CustomDspField where isquery='1' and fieldid in(-1,-2,-3,-4,-5,-6,-7,-8,-9) and customid="+tempcustomid;

    sql+=") a order by a.queryorder,a.showorder,a.id";
int i=0;
int tmpcount = 0;
RecordSet.execute(sql);
//out.print(sql);
while (RecordSet.next())
{tmpcount++;
i++;
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
String htmltype = RecordSet.getString("httype");
String type = RecordSet.getString("type");
String id = RecordSet.getString("id");
String dbtype = Util.null2String(RecordSet.getString("dbtype"));
label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
/*
 初始化创建日期   -1
 创建人           -2
*/
if(id.equals("-1")){
    id="_3";
    name="modedatacreatedate";
    label=SystemEnv.getHtmlLabelName(722,user.getLanguage());
    htmltype="3";
    type="2";
}else if(id.equals("-2")){
    id="_4";
    name="modedatacreater";
    label=SystemEnv.getHtmlLabelName(882,user.getLanguage());
    htmltype="3";
    type="17";
}
String display="display:'';";
if(issimple) display="display:none;";
String checkstr="";
if("1".equals(conht.get("con_"+id))) checkstr="checked";
String tmpvalue="";
String tmpvalue1="";
String tmpname="";
if(isresearch==1){
    tmpvalue=Util.null2String((String)conht.get("con_"+id+"_value"));
    tmpvalue1=Util.null2String((String)conht.get("con_"+id+"_value1"));
    tmpname=Util.null2String((String)conht.get("con_"+id+"_name"));
}
%>
<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
<input type=hidden name="con<%=id%>_type" value="<%=type%>">
<input type=hidden name="con<%=id%>_colname" value="<%=name%>">

<%if (i%2 !=0) {%><tr><%}%>
<td><input type='checkbox' name='check_con' title="<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>" value="<%=id%>" style="display:none" <%=checkstr%>> <%=label%></td>
<%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框
    int tmpopt=3;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),3);
%>
<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<%if(!htmltype.equals("2")){//TD9319 屏蔽掉多行文本框的“等于”和“不等于”操作，text数据库类型不支持该判断%>
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>     <!--等于-->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>   <!--不等于-->
<%}%>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->

</select>
<input type=text class=InputStyle style="width:50%" name="con<%=id%>_value"   onblur="changelevel(this,'<%=tmpcount%>')" value="<%=tmpvalue%>">
<SPAN id=remind style='cursor:hand' title='搜索提示&#10;1.输入"上海泛微"表示查询符合"上海泛微"的记录&#10;2.输入"上海 泛微"表示查询符合"上海"或者符合"泛微"的记录&#10;3.输入"上海+泛微"表示查询符合"上海"并且符合"泛微"的记录'>
<IMG src='/images/remind.png' align=absMiddle>
</SPAN>    
</td>
<%}
else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
    int tmpopt=2;
    int tmpopt1=4;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
    }
%>
<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value" onblur="checknumber('con<%=id%>_value');changelevel1(this,$G('con<%=id%>_value1'),'<%=tmpcount%>')" value="<%=tmpvalue%>">
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="checknumber('con<%=id%>_value1');changelevel1(this,$G('con<%=id%>_value'),'<%=tmpcount%>')" value="<%=tmpvalue1%>">
</td>
<%
}
else if(htmltype.equals("4")){   //check类型
%>
<td class=field >
<input type=checkbox value=1 name="con<%=id%>_value"  onchange="changelevel(this,'<%=tmpcount%>')" <%if(tmpvalue.equals("1")){%>checked<%}%>>

</td>
<%}
else if(htmltype.equals("5")){  //选择框
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>

<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<select class=inputstyle  name="con<%=id%>_value"  onchange="changelevel(this,'<%=tmpcount%>')" >
<option value="" ></option>
<%
char flag=2;
if(id.equals("_6")){
%>
    <option value="0" <%if (nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
    <option value="1" <%if (nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
    <option value="2" <%if (nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
    <option value="3" <%if (nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
<%
}else if(id.equals("_2")){
%>
    <option value="0" <%if (requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
	<option value="1" <%if (requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
	<option value="2" <%if (requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
<%
}else if(id.equals("_8")){
%>
    <option value="0" <%if (isdeleted==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
    <option value="1" <%if (isdeleted==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
    <option value="2" <%if (isdeleted==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
<%
}else{
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
<option value="<%=tmpselectvalue%>" <%if (tmpvalue.equals(""+tmpselectvalue)) {%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%}
}%>
</select>
</td>

<%} else if(htmltype.equals("3") && type.equals("1")){//浏览框单人力资源  条件为多人力 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡  条件为多文挡 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门  条件为多部门 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
	<%} else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户  条件为多客户 (like not lik)
        int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目  条件为多项目 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求  条件为多请求 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别
    int tmpopt=1;
    int tmpopt1=3;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),3);
    }
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value"  onblur="changelevel1(this,$G('con<%=id%>_value1'),'<%=tmpcount%>')"  value="<%=tmpvalue%>">
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="changelevel1(this,$G('con<%=id%>_value'),'<%=tmpcount%>')"  value="<%=tmpvalue1%>" >
</td>
<%}//职位安全级别end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期
    int tmpopt=2;
    int tmpopt1=4;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
    }
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%}%>
<button type=button  class=calendar
<%if(type.equals("2")){%>
 onclick="onSearchWFQTDate(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1,'<%=tmpcount%>')"
<%}else{%>
 onclick ="onSearchWFQTTime(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1,'<%=tmpcount%>')"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span>
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><%}%>
<button type=button  class=calendar
<%if(type.equals("2")){%>
 onclick="onSearchWFQTDate(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value,'<%=tmpcount%>')"
<%}else{%>
 onclick ="onSearchWFQTTime(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value,'<%=tmpcount%>')"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value1" value="<%=tmpvalue1%>">
<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("17")){
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("37")){//浏览框  多选筐条件为单选筐(多文挡)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("57")){//浏览框  多选筐条件为单选筐（多部门）
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("135")){//浏览框  多选筐条件为单选筐（多项目 ）
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("152")){//浏览框  多选筐条件为单选筐（多请求 ）
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}
else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("142")){//浏览框多收发文单位
String urls = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp";
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','<%=urls%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}
else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137"))){//浏览框
String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','<%=urls%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}
else if(htmltype.equals("3") && id.equals("_5")){//工作流浏览框
    tmpname="";
    ArrayList tempvalues=Util.TokenizerString(tmpvalue,",");
    for(int k=0;k<tempvalues.size();k++){
        if(tmpname.equals("")){
            tmpname=WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }else{
            tmpname+=","+WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }
    }
%>
<td class=field >
<input type=hidden  name="con<%=id%>_opt" value="1">
<%if(customid.equals("")){%>
<button type=button  class=browser onClick="onShowWorkFlowSerach('workflowid','workflowspan')"></button>
<span id=workflowspan>
	<%=workflowname%>
</span>
<%}else{%>
<button type=button  class=Browser onclick="onShowCQWorkFlow('con<%=id%>_value','con<%=id%>_valuespan','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
<%}%>
</td>
<%} else if (htmltype.equals("3") && (type.equals("161") || type.equals("162"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype;     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowserCustom('<%=id%>','<%=urls%>','<%=tmpcount%>','<%=type%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if (htmltype.equals("3")){
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','<%=urls%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if (htmltype.equals("6")){   //附件上传同多文挡
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"   >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}else{
%>
  <td class=field>&nbsp;</td>
<%
}
%>
<%if (i%2 !=0) {%><td>&nbsp;</td><%}%>
<%if (i%2 ==0) {%></tr>
<TR class=Separartor style="height:1px;"><td class="Line" COLSPAN=5></TD></TR><%}%>
<%
}%>
<%if (i%2 !=0) {%></tr>
<TR class=Separartor style="height:1px;"><td class="Line" COLSPAN=5></TD></TR><%}%>  
  </tbody>
</table>
</form>

<br>

<!-- 显示查询结果 -->

<TABLE id="tb1" width="100%">
	<tr>
		<td valign="top">                                                                                    
			<%
				String tableString = "";
				if(perpage <2) perpage=10;                                 
				String backfields = " t1.id,t1.formmodeid,t1.modedatacreater,t1.modedatacreatertype,t1.modedatacreatedate,t1.modedatacreatetime ";
				//加上自定以字段
				String showfield="";
				sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,Mode_CustomDspField.showorder,Mode_CustomDspField.istitle" +
                " from workflow_billfield,Mode_CustomDspField,Mode_CustomSearch where Mode_CustomDspField.customid=Mode_CustomSearch.id and Mode_CustomSearch.id="+customid+
                " and Mode_CustomDspField.isshow='1' and workflow_billfield.billid="+formID+"  and   workflow_billfield.id=Mode_CustomDspField.fieldid" +
                " union select Mode_CustomDspField.fieldid as id,'1' as name,2 as label,'3' as dbtype, '4' as httype,5 as type ,Mode_CustomDspField.showorder,Mode_CustomDspField.istitle" +
                " from Mode_CustomDspField ,Mode_CustomSearch where Mode_CustomDspField.customid=Mode_CustomSearch.id and Mode_CustomSearch.id="+customid+
                " and Mode_CustomDspField.isshow='1'  and Mode_CustomDspField.fieldid<0" +
                " order by showorder";
				//out.print(sql);
				RecordSet.execute(sql);
				while (RecordSet.next()){
					if (RecordSet.getInt(1)>0){
						String tempname=Util.null2String(RecordSet.getString("name"));
						String dbtype=Util.null2String(RecordSet.getString("dbtype"));
						if((","+tempname+",").toLowerCase().indexOf(",t1."+tempname.toLowerCase()+",")>-1){
							continue;
						}
						if(dbtype.toLowerCase().equals("text")){
							if(RecordSet.getDBType().equals("oracle")){
								showfield=showfield+","+"to_char(t1."+tempname+") as "+tempname;
							}else{
								showfield=showfield+","+"convert(varchar(4000),t1."+tempname+") as "+tempname;
							}
						}else{
								showfield=showfield+","+"t1."+tempname;
							}
						}
					}
					RecordSet.beforFirst();
					backfields=backfields+showfield;
					ModeShareManager.setModeId(Util.getIntValue(formmodeid,0));
					String rightsql = ModeShareManager.getShareDetailTableByUser("formmode",user);
                    String fromSql  = " from "+tablename+" t1 " ;
                    if(viewtype==3||norightlist.equals("1")){//监控或者无权限列表

                    }else{
                    	//rightsql = rightsql.replace("<","&lt;").replace(">","&gt;");
                        fromSql  = " from "+tablename+" t1,"+rightsql+" t2 " ;
                        sqlwhere += " and t1.id = t2.sourceid ";                    	
                    }
                    
                    if(!quickSql.equals("")){//快捷搜索，如果快捷搜索不为空
                    	if(sqlwhere.equals("")){
                    		sqlwhere = " 1=1 " + quickSql;
                    	}else{
                    		sqlwhere += quickSql;
                    	}
                    }
                    
                    if(!defaultsql.equals("")){//默认搜索，如果快捷搜索不为空
                    	if(sqlwhere.equals("")){
                    		sqlwhere = defaultsql;
                    	}else{
                    		sqlwhere += " and "+defaultsql;
                    	}
                    }
                    
                    if(!treesqlwhere.equals("")){//来自树形关联字段，如果快捷搜索不为空
                    	if(sqlwhere.equals("")){
                    		sqlwhere = " t1." + treesqlwhere;
                    	}else{
                    		sqlwhere += " and t1."+treesqlwhere+" ";
                    	}
                    }

                   	//out.println("select "+backfields+fromSql+sqlwhere);
					String para1="column:id+"+userid+"+"+logintype+"+"+modeid+"+"+viewtype;
					tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
								 //" <checkboxpopedom popedompara=\""+para1+"\" showmethod=\"weaver.formmode.search.FormModeTransMethod.getModeMonitorCheckBox\" />"+
                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"  />"+
                                 "			<head>";
					while (RecordSet.next()) {
						if(RecordSet.getString("id").equals("-1")){
							tableString+="				<col   text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"modedatacreatedate\" orderkey=\"t1.modedatacreatedate,t1.modedatacreatetime\" otherpara=\"column:modedatacreatetime\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultCreateTime\" />";
						}else if(RecordSet.getString("id").equals("-2")){
							tableString+="				<col  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"modedatacreater\" orderkey=\"t1.modedatacreater\"  otherpara=\"column:modedatacreatertype\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultName\" />";
						}else{
							String name = RecordSet.getString("name");
							String label = RecordSet.getString("label");
							String htmltype = RecordSet.getString("httype");
							String type = RecordSet.getString("type");
							String id = RecordSet.getString("id");
							String dbtype=RecordSet.getString("dbtype");
							String istitle = RecordSet.getString("istitle");
							//String viewtype = String.valueOf(Util.getIntValue(request.getParameter("viewtype"),0));
							//http://localhost:8080/formmode/view/addformmode.jsp?type=1&modeId=1&formId=-50
							//type=1&modeId=1&formId=-50
							//type<==>viewtype
							//0、查看
							//1、新建
							//2、编辑
							//3、监控
							String para3="column:id+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+dbtype+"+"+istitle+"+"+formmodeid+"+"+formID+"+"+viewtype+"+"+opentype+"+"+customid+"+fromsearchlist";
							label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
				 			tableString+="			    <col  text=\""+label+"\"  column=\""+name+"\"  otherpara=\""+para3+"\"  transmethod=\"weaver.formmode.search.FormModeTransMethod.getOthers\"/>";
						}
					}
					tableString+="			</head>"+   			
                                 "</table>";
                                 //new weaver.general.BaseBean().writeLog(tableString);
				%>
				<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
			</td>
		</tr>
	</TABLE>

	<table align=right>
		<tr>
			<td>
				<%
				    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
				    RCMenuHeight += RCMenuHeightStep ;
				    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
				    RCMenuHeight += RCMenuHeightStep ;
				    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
				    RCMenuHeight += RCMenuHeightStep ;
				    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
				    RCMenuHeight += RCMenuHeightStep ;
				%>
			</td>
		</tr>
	</TABLE>

<!-- 显示查询结果 -->

		</td>
		</tr>
		</TABLE>
	</td>
	<td class=field></td>
</tr>
<tr>
	<td class=field height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<script language="javascript" src="/js/browser/WorkFlowBrowser.js"></script>
<script language="javaScript">
<%
Iterator it = urlMap.entrySet().iterator();
while (it.hasNext()) {
	Entry entry = (Entry) it.next();
	String detailid = Util.null2String((String)entry.getKey());
	String hreftarget = Util.null2String((String)entry.getValue());
	hreftarget = hreftarget.replace("\"","\\\"");
	out.println("var url_id_"+detailid + " = \"" +hreftarget+"\";");
}
%>

function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function onShowFormWorkFlow(inputname, spanname) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
}
function onShowCQWorkFlow(inputname, spanname, tmpindex) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
	if ($G(inputname).value == "") {
		document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function submitData()
{
	frmmain.submit();
}

function Add(){
	window.open("/formmode/view/AddFormMode.jsp?modeId=<%=modeid%>&formId=<%=formID%>&type=1<%=createurl%>");
}

function BatchImport(){
	window.open("/formmode/interfaces/ModeDataBatchImport.jsp?ajax=1&modeid=<%=modeid%>");
}

function Del(){
	var CheckedCheckboxId = _xtable_CheckedCheckboxId();
	if(CheckedCheckboxId!=""){
		if(isdel()){
			$G("method").value = "del";
			$G("deletebillid").value = CheckedCheckboxId;
			frmmain.submit();
		}
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
	}
}

function submitClear()
{
	btnclear_onclick();
}
function enablemenuall()
{
for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++)
		{
		window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
}
//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
}
function changelevel(obj,tmpindex){
    if(obj.value!=""){
 		document.frmmain.check_con[tmpindex*1].checked = true;
    }else{
        document.frmmain.check_con[tmpindex*1].checked = false;
    }
}
function changelevel1(obj1,obj,tmpindex){
    if(obj.value!=""||obj1.value!=""){
 		document.frmmain.check_con[tmpindex*1].checked = true;
    }else{
        document.frmmain.check_con[tmpindex*1].checked = false;
    }
}
function onSearchWFQTDate(spanname,inputname,inputname1,tmpindex){
	var oncleaingFun = function(){
		  $(spanname).innerHTML = '';
		  $(inputname).value = '';
          if($(inputname).value==""&&$(inputname1).value==""){
              document.frmmain.check_con[tmpindex*1].checked = false;
          }
		}
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;document.frmmain.check_con[tmpindex*1].checked = true;},oncleared:oncleaingFun});
}
function onSearchWFQTTime(spanname,inputname,inputname1,tmpindex){
    var dads  = document.all.meizzDateLayer2.style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop;
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft;
	var ttyp  = spanname.type;
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop;
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
    CustomQuery=1;
    outValue1 = inputname1;
    outValue2=tmpindex;
}
function uescape(url){
    return escape(url);
}
function mouseover(){
	this.focus();
}
//window.frames["rightMenuIframe"].document.body.attachEvent("onmouseover",mouseover);    
if (window.addEventListener){
	window.frames["rightMenuIframe"].document.body.addEventListener("mouseover", mouseover, false);
}else if (window.attachEvent){
	window.frames["rightMenuIframe"].document.body.attachEvent("onmouseover", mouseover);
}else{
	window.frames["rightMenuIframe"].document.body.onmouseover=mouseover;
}	

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}

function onShowResource() {
	var url = "";
	var tmpval = $G("creatertype").value;
	
	if (tmpval == "0") {
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	} else {
		url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	}
	disModalDialog(url, $G("resourcespan"), $G("createrid"), false);
}

function onShowBranch() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $G("branchid").value;
	
	disModalDialog(url, $G("branchspan"), $G("createrid"), false);
}

function onShowDocids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1";
	disModalDialog(url, $G("docidsspan"), $G("docids"), false);
}

function onShowCrmids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	disModalDialog(url, $G("crmidsspan"), $G("crmids"), false);
}

function onShowHrmids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	disModalDialog(url, $G("hrmidsspan"), $G("hrmids"), false);
}

function onShowPrjids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	disModalDialog(url, $G("prjidsspan"), $G("prjids"), false);
}

function onShowBrowser(id,url,tmpindex) {
	var url = url + "?selectedids=" + $G("con" + id + "_value").value;
	disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
	$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;

	if ($G("con" + id + "_value").value == ""){
	    document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
	    document.frmmain.check_con[tmpindex*1].checked = true
	    document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function onShowBrowserCustom(id, url, tmpindex, type1) {
	var id1 = window.showModalDialog(url, "", 
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				var href = wuiUtil.getJsonValueByIndex(id1, 3);
				if(href==''){
					$G("con" + id + "_valuespan").innerHTML = "<a title='" + descs + "'>" + names + "</a>&nbsp";
					$G("con" + id + "_name").value = "<a title='" + descs + "'>" + names + "</a>&nbsp";
				}else{
					$G("con" + id + "_valuespan").innerHTML = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
					$G("con" + id + "_name").value = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
				}
				//$G("con" + id + "_valuespan").innerHTML = "<a title='" + ids + "'>" + names + "</a>&nbsp";
				$G("con" + id + "_value").value = ids;
				//$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var href = wuiUtil.getJsonValueByIndex(id1, 3);
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split(",");
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(href==''){
						sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
					}else{
						sHtml += "<a title='" + curdesc + "' href='" + href + curid + "' target='_blank'>" + curname + "</a>&nbsp";
					}
					//sHtml = sHtml + "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				//$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
				$G("con" + id + "_name").value = sHtml;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
	if ($G("con" + id + "_value").value == "") {
		document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function onShowBrowser1(id,url,type1) {
	//var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con" + id + "_valuespan").innerHTML = id1;
		$G("con" + id + "_value").value=id1
	} else if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con"+id+"_value1span").innerHTML = id1;
		$G("con"+id+"_value1").value=id1;
	}
}



function onShowBrowser2(id, url, type1, tmpindex) {
	var tmpids = "";
	var id1 = null;
	if (type1 == 8) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?projectids=" + tmpids);
	} else if (type1 == 9) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?documentids=" + tmpids);
	} else if (type1 == 1) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 4) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?selectedids=" + tmpids
				+ "&resourceids=" + tmpids);
	} else if (type1 == 16) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 7) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 142) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
	}
	//id1 = window.showModalDialog(url)
	if (id1 != null) {
		resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
		resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$G("con" + id + "_valuespan").innerHTML = resourcename;
			jQuery("input[name=con" + id + "_value]").val(resourceids);
			jQuery("input[name=con" + id + "_name]").val(resourcename);
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
	if ($G("con" + id + "_value").value == "") {
		document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function onShowMutiHrm(spanname, inputename) {
	tmpids = $G(inputename).value;
	id1 = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
					+ tmpids);
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$G(inputename).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			for ( var i = 0; i < resourceidArray.length(); i++) {
				var curid = resourceidArray[i];
				var curname = resourcenameArray[i];
				sHtml = sHtml + curname + "&nbsp";
			}

			$G(spanname).innerHTML = sHtml;
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = true;
			} else {
				$G("flownextoperator")[0].checked = false;
				$G("flownextoperator")[1].checked = true;
			}
		} else {
			$G(spanname).innerHTML = "";
			$G(inputename).value = "";
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = false;
			} else {
				$G("flownextoperator")[0].checked = true;
				$G("flownextoperator")[1].checked = false;
			}
		}
	}
}

function onShowWorkFlowSerach(inputname, spanname) {

	retValue = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	temp = $G(inputname).value;
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			
			if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
				$G("frmmain").action = "WFCustomSearchBySimple.jsp";
				$G("frmmain").submit();
				enablemenuall();
			}
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
			$G("frmmain").action = "WFSearch.jsp";
			$G("frmmain").submit();

		}
	}
}

function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0);
			var names = wuiUtil.getJsonValueByIndex(id, 1);
			
			if (ids.indexOf(",") == 0) {
				ids = ids.substr(1);
				names = names.substr(1);
			}
			$G(inputname).value = ids;
			var sHtml = "";
			
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");
			
			for ( var i = 0; i < ridArray.length; i++) {
				var curid = ridArray[i];
				var curname = rNameArray[i];
				if (i != ridArray.length - 1) sHtml += curname + "，"; 
				else sHtml += curname;
			}
			
			$G(spanname).innerHTML = sHtml;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

function clickThisDate(obj){
	var checked = obj.checked; 
	jQuery("input[name='thisdate']").attr("checked",false);
	obj.checked = checked;
	frmmain.submit();
}
function clickThisOrg(obj){
	var checked = obj.checked; 
	jQuery("input[name='thisorg']").attr("checked",false);
	obj.checked = checked;
	frmmain.submit();
}
function quickSearchDate(index){
	jQuery("input[name='thisdate']").attr("checked",false);
	jQuery("input[name='thisdate']")[index-1].checked=true;
	frmmain.submit();
}
function quickSearchOrg(index){
	jQuery("input[name='thisorg']").attr("checked",false);
	jQuery("input[name='thisorg']")[index-1].checked=true;
	frmmain.submit();
}

function doBatchOperate(detailid,issystemflag){
	//执行接口动作
    if(doInterfacesAction(detailid,issystemflag)){
    	_table.reLoad();
    	eval(eval("url_id_"+detailid));
	}
}
//执行接口动作
function doInterfacesAction(detailid,issystemflag){
	var CheckedCheckboxId = _xtable_CheckedCheckboxId();
	if(CheckedCheckboxId!=""){
		var CheckedCheckboxIds = CheckedCheckboxId.split(",");
		for(var i=0;i<CheckedCheckboxIds.length;i++){
			var billid = CheckedCheckboxIds[i];
			var url = "/formmode/data/ModeDataInterfaceAjax.jsp";
			jQuery.ajax({
				url : url,
				type : "post",
				processData : false,
				data : "pageexpandid="+detailid+"&modeid=<%=modeid%>&formid=<%=formID%>&billid="+billid,
				dataType : "text",
				async : false,//使用同步提交，等待返回的结果
				success: function do4Success(msg){
					
				}
			});
		}
	}
	
	return true;
}
</script>

</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>