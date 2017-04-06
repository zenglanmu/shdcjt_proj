<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 java.net.*" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.RecordSet"%>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="DocDwrUtil" class="weaver.docs.docs.DocDwrUtil" scope="page"/>

<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />

<jsp:useBean id="SecCategoryMouldComInfo" class="weaver.docs.category.SecCategoryMouldComInfo" scope="page"/>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="DocCoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<%
//判断新建的是不是个人文档
boolean isPersonalDoc = false ;
String from =  Util.null2String(request.getParameter("from"));
//System.out.println("from is "+from);
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
if ("personalDoc".equals(from)){
    isPersonalDoc = true ;
}

int docid = Util.getIntValue(request.getParameter("id"),0);

DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();
int docType = DocManager.getDocType();
if(docType == 2){
    response.sendRedirect("DocEditExt.jsp?from="+from+"&userCategory="+userCategory+"&id="+docid);
    return ;
}
%>
<%!
//toHtml2 :把 "&lt;"  转化为 "XXX" 和  "&gt;"  转化为 "YYY" 
private String toHtml2(String src){   
    String returnStr = "" ;
    returnStr = Util.StringReplace(src,"&lt;","XXX");
    returnStr = Util.StringReplace(returnStr,"&gt;","YYY");
    return returnStr ;
}
//TD.5290 对于某些如MS Office生成的格式复杂HTML文档源码进行过滤
private String filterStyle(String src) throws Exception {
    String returnStr = src;
    //returnStr = Util.replace(returnStr,"style=\".*\"","",0);
    //returnStr = Util.replace(returnStr,"<HTML\\s*.*>","<HTML>",0);
    returnStr = Util.replace(returnStr,"<HTML([^<])*","<HTML>",0);
	//19957 当html文档内容存在textarea对象时，显示会有问题
    returnStr = Util.StringReplace(returnStr,"<","&lt;");
    returnStr = Util.StringReplace(returnStr,">","&gt;");
    return returnStr;
}
%>
<script LANGUAGE="JavaScript">
<!--
//重载replace方法为replaceALl
function replace(string,text,by) {    
    var strLength = string.length, txtLength = text.length;
    if ((strLength == 0) || (txtLength == 0)) return string;

    var i = string.indexOf(text);
    if ((!i) && (text != string.substring(0,txtLength))) return string;
    if (i == -1) return string;

    var newstr = string.substring(0,i) + by;

    if (i+txtLength < strLength)
        newstr += replace(string.substring(i+txtLength,strLength),text,by);

    return newstr;
}

//fromHtml2 :把 "XXX"  转化为 "&lt;" 和  "YYY"  转化为 "&gt;"
function  fromHtml2(src1){	
    var returnStr = replace(src1,"XXX","&lt;");
    returnStr = replace(returnStr,"YYY","&gt;");
    return returnStr ;
    
}

//-->
</script>
<%
String checkOutStatus=DocManager.getCheckOutStatus();
int checkOutUserId=DocManager.getCheckOutUserId();
String checkOutUserType=DocManager.getCheckOutUserType();

String checkOutUserName="";

if(checkOutUserType!=null&&checkOutUserType.equals("2")){
	checkOutUserName=CustomerInfoComInfo.getCustomerInfoname(""+checkOutUserId);
}else{
	checkOutUserName=ResourceComInfo.getResourcename(""+checkOutUserId);
}

String checkOutDate=DocManager.getCheckOutDate();
String checkOutTime=DocManager.getCheckOutTime();



String subid=Util.null2String(request.getParameter("subid"));
int SecId=Util.getIntValue(Util.null2String(request.getParameter("SecId")),0);


int maxUploadImageSize = DocUtil.getMaxUploadImageSize2(docid);

String needinputitems = "";
//DocManager.resetParameter();
//DocManager.setId(docid);
//DocManager.getDocInfoById();
//文档信息
int maincategory=DocManager.getMaincategory();
int subcategory=DocManager.getSubcategory();
int seccategory=DocManager.getSeccategory();
int doclangurage=DocManager.getDoclangurage();
String docapprovable=DocManager.getDocapprovable();
String docreplyable=DocManager.getDocreplyable();
String isreply=DocManager.getIsreply();
int replydocid=DocManager.getReplydocid();
String docsubject=DocManager.getDocsubject();
String doccontent=DocManager.getDoccontent();
String docpublishtype=DocManager.getDocpublishtype();
int itemid=DocManager.getItemid();
int itemmaincategoryid=DocManager.getItemmaincategoryid();
int hrmresid=DocManager.getHrmresid();
int crmid=DocManager.getCrmid();
int projectid=DocManager.getProjectid();
int financeid=DocManager.getFinanceid();
int doccreaterid=DocManager.getDoccreaterid();
int docdepartmentid=DocManager.getDocdepartmentid();
String doccreatedate=DocManager.getDoccreatedate();
String doccreatetime=DocManager.getDoccreatetime();
int doclastmoduserid=DocManager.getDoclastmoduserid();
String doclastmoddate=DocManager.getDoclastmoddate();
String doclastmodtime=DocManager.getDoclastmodtime();
int docapproveuserid=DocManager.getDocapproveuserid();
String docapprovedate=DocManager.getDocapprovedate();
String docapprovetime=DocManager.getDocapprovetime();
int docarchiveuserid=DocManager.getDocarchiveuserid();
String docarchivedate=DocManager.getDocarchivedate();
String docarchivetime=DocManager.getDocarchivetime();
String docstatus=DocManager.getDocstatus();
int assetid=DocManager.getAssetid();
int ownerid=DocManager.getOwnerid();
String keyword=DocManager.getKeyword();
int accessorycount=DocManager.getAccessorycount();
int replaydoccount=DocManager.getReplaydoccount();
String usertype=DocManager.getUsertype();


String doccode = DocManager.getDocCode();
int docedition = DocManager.getDocEdition();
int doceditionid = DocManager.getDocEditionId();
    
int selectedpubmouldid = DocManager.getSelectedPubMouldId();

String docCreaterType = DocManager.getDocCreaterType();//文档创建者类型（1:内部用户  2：外部用户）
String docLastModUserType = DocManager.getDocLastModUserType();//文档最后修改者类型（1:内部用户  2：外部用户）
String ownerType = DocManager.getOwnerType();//文档拥有者类型（1:内部用户  2：外部用户）


int maindoc = DocManager.getMainDoc();
int docreadoptercanprint = DocManager.getReadOpterCanPrint();

boolean isTemporaryDoc = false;
String invalidationdate = DocManager.getInvalidationDate();
String reqinvalidationdate = request.getParameter("invalidationdate");
if(reqinvalidationdate!=null)
    invalidationdate = reqinvalidationdate;
if(invalidationdate!=null&&!"".equals(invalidationdate))
    isTemporaryDoc = true;

String docstatusname = DocComInfo.getStatusView(docid,user);



// modify by dongping for td1227 start
//一篇文档共享给客户，并且将编辑权限放给客户，则当客户编辑这篇文档时，系统的日志记录是“系统管理员”修改的这篇文档。
String opreateType=user.getLogintype();

//end

//是否回复提醒
String canRemind=DocManager.getCanRemind();

DocManager.closeStatement();
String docmain = "";

if(ownerid==0) ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
//子目录信息

RecordSet.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
RecordSet.next();
String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
String subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
//String docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
String publishable=Util.null2String(""+RecordSet.getString("publishable"));
String replyable=Util.null2String(""+RecordSet.getString("replyable"));
String shareable=Util.null2String(""+RecordSet.getString("shareable"));
String cusertype=Util.null2String(""+RecordSet.getString("cusertype"));
    cusertype = cusertype.trim();
String cuserseclevel=Util.null2String(""+RecordSet.getString("cuserseclevel"));
    if(cuserseclevel.equals("255")) cuserseclevel="0";
String cdepartmentid1=Util.null2String(""+RecordSet.getString("cdepartmentid1"));
String cdepseclevel1=Util.null2String(""+RecordSet.getString("cdepseclevel1"));
    if(cdepseclevel1.equals("255")) cdepseclevel1="0";
String cdepartmentid2=Util.null2String(""+RecordSet.getString("cdepartmentid2"));
String cdepseclevel2=Util.null2String(""+RecordSet.getString("cdepseclevel2"));
    if(cdepseclevel2.equals("255")) cdepseclevel2="0";
String croleid1=Util.null2String(""+RecordSet.getString("croleid1"));
String crolelevel1=Util.null2String(""+RecordSet.getString("crolelevel1"));
String croleid2=Util.null2String(""+RecordSet.getString("croleid2"));
String crolelevel2=Util.null2String(""+RecordSet.getString("crolelevel2"));
String croleid3=Util.null2String(""+RecordSet.getString("croleid3"));
String crolelevel3=Util.null2String(""+RecordSet.getString("crolelevel3"));
String approvewfid=RecordSet.getString("approveworkflowid");
String needapprovecheck="";
    if(approvewfid.equals(""))  approvewfid="0";
    if(approvewfid.equals("0"))
        needapprovecheck="0";
    else
        needapprovecheck="1";

String readoptercanprint = Util.null2String(""+RecordSet.getString("readoptercanprint"));

/*现在把附件的添加从由文档管理员确定改成了由用户自定义的方式.*/
// String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),user.getLanguage());
// int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),user.getLanguage());
String hasasset=Util.toScreen(RecordSet.getString("hasasset"),user.getLanguage());
String assetlabel=Util.toScreen(RecordSet.getString("assetlabel"),user.getLanguage());
String hasitems =Util.toScreen(RecordSet.getString("hasitems"),user.getLanguage());
String itemlabel =Util.toScreenToEdit(RecordSet.getString("itemlabel"),user.getLanguage());
String hashrmres =Util.toScreen(RecordSet.getString("hashrmres"),user.getLanguage());
String hrmreslabel =Util.toScreenToEdit(RecordSet.getString("hrmreslabel"),user.getLanguage());
String hascrm =Util.toScreen(RecordSet.getString("hascrm"),user.getLanguage());
String crmlabel =Util.toScreenToEdit(RecordSet.getString("crmlabel"),user.getLanguage());
String hasproject =Util.toScreen(RecordSet.getString("hasproject"),user.getLanguage());
String projectlabel =Util.toScreenToEdit(RecordSet.getString("projectlabel"),user.getLanguage());
String hasfinance =Util.toScreen(RecordSet.getString("hasfinance"),user.getLanguage());
String financelabel =Util.toScreenToEdit(RecordSet.getString("financelabel"),user.getLanguage());
String approvercanedit=Util.toScreen(RecordSet.getString("approvercanedit"),user.getLanguage());

boolean isEditionOpen = SecCategoryComInfo.isEditionOpen(seccategory);



/***************************权限判断**************************************************/
boolean  canReader = false;
boolean  canEdit = false;
boolean  canViewLog = false;
boolean canDel = false;
boolean canShare = false ;
String logintype = user.getLogintype() ;
String userid = "" +user.getUID() ;
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();

if("2".equals(logintype)){
	userdepartment="0";
	usersubcomany="0";
	userSeclevel="0";
}
String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
ArrayList PdocList =  SpopForDoc.getDocOpratePopedom(""+docid,userInfo);

//0:查看 1:编辑 2:删除 3:共享 4:日志
if (((String)PdocList.get(0)).equals("true")) canReader = true ;
if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
if (((String)PdocList.get(2)).equals("true")) canDel = true ;
if (((String)PdocList.get(3)).equals("true")) canShare = true ;
if (((String)PdocList.get(4)).equals("true")) canViewLog = true ;    
   
//归档状态的文档不能被编辑
if(canEdit && (docstatus.equals("5"))){
    canEdit = false;
}

if(!canEdit)  {
    //response.sendRedirect("/notice/noright.jsp") ;
    //return ;
	if(canReader){
		response.sendRedirect("/docs/docs/DocDsp.jsp?id="+docid) ;
		return ;		
	}else{
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}


boolean blnRealViewLog=false;
if((SecCategoryComInfo.getLogviewtype(seccategory)==1&&user.getLoginid().equalsIgnoreCase("sysadmin"))||(SecCategoryComInfo.getLogviewtype(seccategory)==0)){
	blnRealViewLog=canViewLog;
}


String temStr="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

//temStr+=SystemEnv.getHtmlLabelName(401,user.getLanguage())+":"+doccreatedate+" "+doccreatetime+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":"+Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":"+doclastmoddate+" "+doclastmodtime+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":"+Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage());

if(doccreaterid>0){
	temStr+=SystemEnv.getHtmlLabelName(401,user.getLanguage())+":"+doccreatedate+" "+doccreatetime+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":"+ResourceComInfo.getClientDetailModifier(""+doccreaterid,docCreaterType,user.getLogintype());
}

if(doclastmoduserid>0){
	temStr+="&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":"+doclastmoddate+" "+doclastmodtime+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":"+ResourceComInfo.getClientDetailModifier(""+doclastmoduserid,docLastModUserType,user.getLogintype());
}

if(checkOutStatus!=null&&(checkOutStatus.equals("1")||checkOutStatus.equals("2"))&&!(checkOutUserId==user.getUID()&&checkOutUserType!=	null&&checkOutUserType.equals(user.getLogintype()))){



	String checkOutMessage=SystemEnv.getHtmlLabelName(19695,user.getLanguage())+SystemEnv.getHtmlLabelName(19690,user.getLanguage())+"："+checkOutUserName;

    checkOutMessage=URLEncoder.encode(checkOutMessage);

    response.sendRedirect("DocDsp.jsp?id="+docid+"&checkOutMessage="+checkOutMessage);
    return ;
}else if(!"1".equals(checkOutStatus)&&!"2".equals(checkOutStatus)){
        Calendar today = Calendar.getInstance();
        String formatDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
                + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
                + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
        String formatTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
                + Util.add0(today.get(Calendar.MINUTE), 2) + ":" + Util.add0(today.get(Calendar.SECOND), 2);
        checkOutDate=formatDate;
        checkOutTime=formatTime;
        checkOutUserName=user.getUsername();
        checkOutStatus="1";

         RecordSet.executeSql("update  DocDetail set checkOutStatus='1',checkOutUserId="+user.getUID()+",checkOutUserType='"+user.getLogintype()+"',checkOutDate='"+formatDate+"',checkOutTime='"+formatTime+"' where id="+docid);

		 DocDetailLog.resetParameter();
		 DocDetailLog.setDocId(docid);
		 DocDetailLog.setDocSubject(docsubject);
		 DocDetailLog.setOperateType("18");
		 DocDetailLog.setOperateUserid(user.getUID());
		 DocDetailLog.setUsertype(user.getLogintype());
		 DocDetailLog.setClientAddress(request.getRemoteAddr());
		 DocDetailLog.setDocCreater(doccreaterid);
		 DocDetailLog.setCreatertype(docCreaterType);
		 DocDetailLog.setDocLogInfo();
}

String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+Util.add0(docid,12)+"   "+temStr;;
String needfav ="1";
String needhelp ="";


int tmppos = doccontent.indexOf("!@#$%^&*");
if(tmppos!=-1){
	docmain = doccontent.substring(0,tmppos);
	doccontent = doccontent.substring(tmppos+8,doccontent.length());
}
%>

<html><head>
<title><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>:<%=docsubject %></title>
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<script language="javascript" src="/js/weaver.js"></script>
<script src="/js/prototype.js" type="text/javascript"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>

<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>
 -->
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>

<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/weaver-lang-tw-gbk.js'></script>
<%}%>

<script LANGUAGE="javascript">

function onLoad(){
	/***@2007-08-24 modify by yeriwei! ***/
	//var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	//FCKEditorExt.initEditor('weaver','doccontent',lang);
  	//Element.hide($("_xTable"));
  //td4694
	//modified by hubo,2006-07-14
  //var msg =weaver.doccontent.innerText+" "; 
  //var msg = document.getElementById("divDocContent").innerHTML + " ";
  //document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=fromHtml2(msg);//weaver.doccontent.innerText;

  try{
  onshowdocmain(<%=(docpublishtype.equals("2"))?1:0%>);
  }catch(e){}
}

function onUnLoad(){   
    try{
	    docCheckIn(<%=docid%>);//签入刚签出的文档
    }catch(e){
    }
}

</script>
<style type="text/css">
html, body {
  height: 100%;
  overflow: hidden;
}
</style>
</head>
<body class="ext-ie ext-ie8 x-border-layout-ct" scroll="no" onLoad="onLoad()"  onunload="onUnLoad()" onbeforeunload="checkChange(event)">
<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<%@ include file="/systeminfo/DocTopTitle.jsp"%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
List menuBars = new ArrayList();
List menuBarsForWf = new ArrayList();

Map menuBarMap = new HashMap();
Map[] menuBarToolsMap = new HashMap[]{};

String strExtBar="";
//strExtBar="[";
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls: 'btn_save',handler: function(){onSave(this)}},";
menuBarMap = new HashMap();
menuBarMap.put("id", "btn_save");
menuBarMap.put("text",SystemEnv.getHtmlLabelName(615,user.getLanguage()));
menuBarMap.put("iconCls","btn_save");
menuBarMap.put("handler","onSave(this);");
menuBars.add(menuBarMap);

if (!isPersonalDoc){
         if(!docstatus.equals("3") && !docstatus.equals("4")) {
            RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:onDraft(this),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
			//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"',iconCls: 'btn_draft',handler: function(){onDraft(this)}},";
			menuBarMap = new HashMap();
			menuBarMap.put("id", "btn_draft");
			menuBarMap.put("text",SystemEnv.getHtmlLabelName(220,user.getLanguage()));
			menuBarMap.put("iconCls","btn_draft");
			menuBarMap.put("handler","onDraft(this);");
			menuBars.add(menuBarMap);
           
            RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(this),_top} " ;
            RCMenuHeight += RCMenuHeightStep ; 
			//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"',iconCls: 'btn_preview',handler: function(){onPreview(this)}},";
        	menuBarMap = new HashMap();
			menuBarMap.put("id", "btn_preview");
        	menuBarMap.put("text",SystemEnv.getHtmlLabelName(221,user.getLanguage()));
        	menuBarMap.put("iconCls","btn_preview");
        	menuBarMap.put("handler","onPreview(this);");
        	menuBars.add(menuBarMap);
        }
        
        RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:switchEditMode(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

		//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+"',iconCls: 'btn_html',handler: function(){FCKEditorExt.switchEditMode()}},";
		menuBarMap = new HashMap();
		menuBarMap.put("text",SystemEnv.getHtmlLabelName(222,user.getLanguage()));
		menuBarMap.put("iconCls","btn_html");
		menuBarMap.put("handler","switchEditMode();");
		menuBars.add(menuBarMap);
		
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(224,user.getLanguage())+",javascript:showHeader(),_top} " ;
        //RCMenuHeight += RCMenuHeightStep ;       
 } 
 //RCMenu += "{"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+",javascript:addannexRow(),_top} " ;
 //RCMenuHeight += RCMenuHeightStep ;
        
 RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
 RCMenuHeight += RCMenuHeightStep ;   
 //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+"',iconCls: 'btn_back',handler: function(){window.history.go(-1)}},";
 menuBarMap = new HashMap();
 menuBarMap.put("text",SystemEnv.getHtmlLabelName(1290,user.getLanguage()));
 menuBarMap.put("iconCls","btn_back");
 menuBarMap.put("handler","window.history.go(-1);");
 menuBars.add(menuBarMap);
 
//strExtBar+="'-',{text:'<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>',iconCls: 'btn_ShowOrHidden',handler: function(){DocCommonExt.showorhiddenprop()}}";
//strExtBar+="]";
 menuBarMap = new HashMap();
 menuBars.add(menuBarMap);

 menuBarMap = new HashMap();
 menuBarMap.put("text","<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>");
 menuBarMap.put("iconCls","btn_ShowOrHidden");
 menuBarMap.put("id","btn_ShowOrHidden");
 menuBarMap.put("handler","onExpandOrCollapse();");
 menuBars.add(menuBarMap);
%>
<!--button class=btn accessKey=4 onClick="addannexRow();"><u>4</u>-<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></button-->
<div id="divMenu" style="display:none">
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</div>

<input type=hidden name=docapprovable value="<%=needapprovecheck%>">
<input type=hidden name=isreply value="<%=isreply%>">
<input type=hidden name=replydocid value="<%=replydocid%>">
<input type=hidden name=isSubmit>
<input type=hidden name=docreplyable value="<%=replyable%>">
<input type=hidden name=docstatus value="<%=docstatus%>">
<input type=hidden name=doccreaterid value="<%=doccreaterid%>">
<input type=hidden name=docCreaterType value="<%=docCreaterType%>">
<input type=hidden name=doccreatedate value="<%=doccreatedate%>">
<input type=hidden name=doccreatetime value="<%=doccreatetime%>">
<input type=hidden name=usertype value="<%=usertype%>"> 
<input type=hidden name=opreateType value="<%=opreateType%>">
<input type=hidden name="ownerid" value="<%=ownerid%>">
<input type=hidden name="oldownerid" value="<%=ownerid%>">
<input type=hidden name="ownerType" value="<%=ownerType%>">
<input type=hidden name="docdepartmentid" value="<%=docdepartmentid%>">
<input type=hidden name=doclangurage value="<%=doclangurage%>">
<input type=hidden name=replaydoccount value="<%=replaydoccount%>">
<input type=hidden name=from value="<%=from%>">
<input type=hidden name=userCategory  value="<%=userCategory%>">
<input type="hidden" name="userId" value="<%=user.getUID()%>">
<input type="hidden" name="userType" value="<%=user.getLogintype()%>">

<input type="hidden" class=InputStyle name="doccode" value="<%=doccode%>">
<input type="hidden" name="docedition" value="<%=docedition%>">
<input type=hidden name=doceditionid value="<%=doceditionid%>">
<input type=hidden name=maincategory value="<%=(maincategory==-1?"":Integer.toString(maincategory))%>">
<input type=hidden name=subcategory value="<%=(subcategory==-1?"":Integer.toString(subcategory))%>">
<input type=hidden name=seccategory value="<%=(seccategory==-1?"":Integer.toString(seccategory))%>">

<input type="hidden" name="maindoc" value="<%=maindoc%>">

<input type=hidden name=operation>
<input type=hidden name=id value="<%=docid%>">
<input type=hidden name=delimgid>

<input type="hidden" name="imageidsExt"  id="imageidsExt">
<input type="hidden" name="imagenamesExt"  id="imagenamesExt">

<input type=hidden name="deleteaccessory" id="deleteaccessory" value="">

<div style="position: absolute; left: 0; top: 0; width:100%;">

<div id="divContentTab" style="display:none;width:100%;">

	<%-- 文档标题 start --%>
	<div id="divDocTile" style="width:100%;">
		<DIV style="WIDTH: 100%; MozUserSelect: none; KhtmlUserSelect: none" class="x-tab-panel-header" >
		<DIV class=x-tab-strip-wrap>
		<UL class="x-tab-strip x-tab-strip-top">
		<LI class=" x-tab-strip-active ">
		<A class=x-tab-strip-close></A>
		<A class=x-tab-right>
		<EM class=x-tab-left>
		<div class=x-tab-strip-inner><div class="x-tab-strip-text " style="padding-top:3px;">
			<table align="center" id="spanDocTitle">
				<tr>
					<td width="58"><b><%=SystemEnv.getHtmlLabelName(19541,user.getLanguage())%>:</b></td> 
					<td>
						<input type="hidden" name="namerepeated" value="0">
						<input style="width:310px" id="docsubject"  name="docsubject" value="<%=docsubject%>" maxlength=200							 
						<%if(!isPersonalDoc){%>
							onChange="checkDocSubject(this);"
							onMouseDown="docSubjectMouseDown(this);"
							onBlur="checkDocSubject(this);"
						<%}else{%>
							onChange="checkinput('docsubject','docsubjectspan');"
						<%}%>
						>
					</td>
					<td>
						<span id="docsubjectspan">
							<%if(docsubject.equals("")){%>
								<img src="/images/BacoError.gif" align=absMiddle>
							<%} %>
						</span>
					</td>
				</tr>
			</table>
			<script type="text/javascript">
				var isChecking = false;
				var prevValue = "";
				var checkCnt = 0;

				function docSubjectMouseDown(obj){
					if(event.button==2){
						checkDocSubject(obj)
					}
				}
				function checkDocSubject(obj){
					if(obj!=null&&obj.value!=null&&obj.value!=""&&obj.value!=prevValue){
					  //$('docsubjectspan').innerHTML = "<font color=red><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></font>";
					  
					  $GetEle('namerepeated').value = 1;
					  isChecking = true;
					  
					  var subject = encodeURIComponent(obj.value);							  
					  var url = 'DocSubjectCheck.jsp';
					  var pars = 'subject='+subject+'&secid=<%=seccategory%>&docid=<%=docid%>';
					  var myAjax = new Ajax.Request(
						url,
						{method: 'post', parameters: pars, onComplete: doCheckDocSubject}
					  );
					}else{
						checkinput('docsubject','docsubjectspan');
					}
				}
				function doCheckDocSubject(req){						
					var num = req.responseXML.getElementsByTagName('num')[0].firstChild.data;
					if(num>0){
						//alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
						$GetEle("docsubjectspan").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>"+
								" <span style='color:red;width:310px;position:absolute;left:415px;top:10px;'><%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%></span>";
						$GetEle('namerepeated').value = 1;
					} else {
						$GetEle('namerepeated').value = 0;
						/** added by cyril on 2008-06-10 for TD:8828 ajax调用后再检查生成一遍校验值 **/
						if(checkCnt==0){
							createTags();
						}
						checkCnt = 1;
						/** end by cyril on 2008-06-10 for TD:8828 **/
						checkinput('docsubject','docsubjectspan');
					}
					isChecking = false;
					prevValue = $GetEle('docsubject').value;
				}
				function checkSubjectRepeated(){
					
					if($GetEle('namerepeated').value==1){
						if(isChecking){
							alert("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
						} else {
							alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
						}
						return false;
					}
					else return true;
				}
			</script>
			<%
			needinputitems += ",docsubject";
			%>
			</div></div>
			</EM></A></LI>
			<LI class=x-tab-edge></LI>
			<DIV class=x-clear></DIV></UL></DIV>
			<DIV class=x-tab-strip-spacer></DIV>
			<DIV style="POSITION: absolute; TOP: 2px; RIGHT: 15px" id=divFavorite>
			</DIV>
		</DIV>
	</div>
	<%-- 文档标题 end --%>

	<%-- HTML编辑控件 start --%>
	<div id="divContent" style="width:100%;">
		<textarea name="doccontent" id="doccontent" style="width:100%;"><%=filterStyle(Util.encodeAnd(doccontent))%></textarea>
	</div>
	<%-- HTML编辑控件 end --%>

	<%-- 工具栏 start --%>
	<div id="divTools" style="width:100%;" class="x-tab-panel-bbar">
		<DIV id=toolbarmenudiv class="x-toolbar x-small-editor x-toolbar-layout-ct">
		<TABLE class="x-toolbar-ct" style="WIDTH: auto" cellSpacing=0>
			<TBODY>
				<TR>
				<td align="left" class="x-toolbar-left">
				<table cellspacing="0">
				<tbody>
				<tr class="x-toolbar-left-row">
				<% 
				for(Iterator mbit = menuBars.iterator();mbit.hasNext();){
					menuBarMap = (Map)mbit.next();
					if(menuBarMap.size()==0){
					%>
					<TD class=x-toolbar-cell><SPAN class=xtb-sep></SPAN></TD>
					<% } else {
						String tooltext = (String)menuBarMap.get("text");
						String tooliconCls = (String)menuBarMap.get("iconCls");
						String toolid = (String)menuBarMap.get("id");
						String toolhandler = (String)menuBarMap.get("handler");
						String toolmouseout = "";
						menuBarToolsMap = (Map[])menuBarMap.get("menu");
						if(menuBarToolsMap!=null&&(toolhandler==null||"".equals(toolhandler))) toolhandler = "showToolsMenu"+toolid+"();";
						if(menuBarToolsMap!=null) toolmouseout = "hideToolsMenu"+toolid+"();";
					%>
					<TD class="x-toolbar-cell">
					<TABLE id="<%=toolid%>" class="x-btn x-btn-text-icon" onmouseover=resetButtonClass(this,2); onmouseout=resetButtonClass(this,1); onclick="<%=toolhandler%>" cellSpacing=0>
						<TBODY class="x-btn-small x-btn-icon-small-left">
							<TR>
								<TD class=x-btn-tl><I>&nbsp;</I></TD>
								<TD class=x-btn-tc></TD>
								<TD class=x-btn-tr><I>&nbsp;</I></TD>
							</TR>
							<TR>
								<TD class=x-btn-ml><I>&nbsp;</I></TD>
								<td class="x-btn-mc"><EM class="<%if(menuBarToolsMap!=null&&menuBarToolsMap.length>0){%>x-btn-arrow<%}%>" unselectable="on">
								<BUTTON id="BUTTON<%=toolid%>" class="x-btn-text <%=tooliconCls%>" type="button"><%=tooltext%></BUTTON>
								</EM></td>
								<TD class=x-btn-mr><I>&nbsp;</I></TD>
							</TR>
							<TR>
								<TD class=x-btn-bl><I>&nbsp;</I></TD>
								<TD class=x-btn-bc></TD>
								<TD class=x-btn-br><I>&nbsp;</I></TD>
							</TR>
						</TBODY>
					</TABLE>
					</TD>
					<% } %>
				<% } %>
				</tr>
				</tbody>
				</table>
				</td>
				</TR>
			</TBODY>
		</TABLE>
		</DIV>
		<script type="text/javascript">
		function resetButtonClass(o,type) {
			var oclassname = o.className;
			if(oclassname) {
				oclassname = oclassname.replace(/(^\s*)|(\s*$)/g, "");
			}
			if(type==1) {
				if(oclassname.indexOf('x-btn-over')>-1)
				{
					o.className = oclassname.replace(/x-btn-over/g,'');
				}
			} else {
				if(oclassname.indexOf('x-btn-over')<0) {
					o.className=oclassname+" x-btn-over ";
				}
			}
		}
		</script>
	</div>
	<% 
	for(Iterator mbit = menuBars.iterator();mbit.hasNext();){
		menuBarMap = (Map)mbit.next();
		if(menuBarMap.size()>0) {
			String toolid = (String)menuBarMap.get("id");
			menuBarToolsMap = (Map[])menuBarMap.get("menu");
			String toolhandler = "";
			String toolmouseout="";
			
			if(menuBarToolsMap!=null&&(toolhandler==null||"".equals(toolhandler))) toolhandler = "showToolsMenu"+toolid+"();";
			if(menuBarToolsMap!=null) toolmouseout = "hideToolsMenu"+toolid+"();";

			if(menuBarToolsMap!=null&&menuBarToolsMap.length>0){
			%>
				<script type="text/javascript">
				function hideToolsMenu<%=toolid%>(){
					var bobj = document.getElementById("<%=toolid%>");
					if(bobj){
						bobj.unselectable = "on";
						resetButtonClass(bobj,1);
						document.getElementById("divToolsMenuIFrame<%=toolid%>").style.display="none";
						document.getElementById("divToolsMenuBorder<%=toolid%>").style.display="none";
						document.getElementById("divToolsMenuContent<%=toolid%>").style.display="none";
					}
				}
				
				function showToolsMenu<%=toolid%>(){
					var bobj = document.getElementById("<%=toolid%>");
					if(bobj){
						bobj.unselectable = "off";
						resetButtonClass(bobj,2);
	
						var dleft = getX(bobj) - 2;
						var dtop = getY(bobj);

						if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none")
							dtop = dtop - bobj.offsetHeight - <%=menuBarToolsMap.length*25-20%>;
						else
							dtop = dtop + bobj.offsetHeight - 5;
						
						document.getElementById("divToolsMenuIFrame<%=toolid%>").style.left=dleft;
						document.getElementById("divToolsMenuIFrame<%=toolid%>").style.top=dtop;
						document.getElementById("divToolsMenuIFrame<%=toolid%>").style.width="121px";
						document.getElementById("divToolsMenuIFrame<%=toolid%>").style.height="<%=menuBarToolsMap.length*25+2%>px";
						document.getElementById("divToolsMenuIFrame<%=toolid%>").style.display="block";
						
						document.getElementById("divToolsMenuBorder<%=toolid%>").style.left=dleft;
						document.getElementById("divToolsMenuBorder<%=toolid%>").style.top=dtop;
						document.getElementById("divToolsMenuBorder<%=toolid%>").style.width="121px";
						document.getElementById("divToolsMenuBorder<%=toolid%>").style.height="<%=menuBarToolsMap.length*25+2%>px";
						document.getElementById("divToolsMenuBorder<%=toolid%>").style.display="block";
						
						document.getElementById("divToolsMenuContent<%=toolid%>").style.left=dleft+3;
						document.getElementById("divToolsMenuContent<%=toolid%>").style.top=dtop+5;
						document.getElementById("divToolsMenuContent<%=toolid%>").style.width="120px";
						document.getElementById("divToolsMenuContent<%=toolid%>").style.height="<%=menuBarToolsMap.length*25+1%>px";
						document.getElementById("divToolsMenuContent<%=toolid%>").style.display="block";

						var ofunc = document.body.onclick;
						document.body.onclick = function () {
							if(ofunc) ofunc.call(this);
							var hidden = true;
							var obj = event.srcElement;
							while(obj){
								if( obj.id=="divToolsMenuIFrame<%=toolid%>" || obj.id=="divToolsMenuBorder<%=toolid%>" ||
									obj.id=="divToolsMenuContent<%=toolid%>" || obj.id=="divToolsMenuUL<%=toolid%>" ||
									obj.id=="divToolsMenuUL<%=toolid%>" || 
									obj.id=="<%=toolid%>"
								) {
									hidden = false;
									break;
								} else {
									obj = obj.parentElement;
								}
							}
							if(hidden) hideToolsMenu<%=toolid%>();
						};
					}
				}
				</script>
				<IFRAME id=divToolsMenuIFrame<%=toolid%> style="Z-INDEX: 14998; VISIBILITY: visible; display:none;" class=ext-shim frameBorder=0></IFRAME>	
				<DIV id=divToolsMenuBorder<%=toolid%> style="Z-INDEX: 14999; display:none; FILTER: progid:DXImageTransform.Microsoft.alpha(opacity=50) progid:DXImageTransform.Microsoft.Blur(pixelradius=4);" class=x-ie-shadow></DIV>
				<DIV id=divToolsMenuContent<%=toolid%> style="Z-INDEX: 15000; display:none; POSITION: absolute; VISIBILITY: visible;" class="x-menu x-menu-floating x-layer ">
				<UL id=divToolsMenuUL<%=toolid%> style="HEIGHT:100%" class=x-menu-list>
					<% for(int l=0;l<menuBarToolsMap.length;l++){ 
							String toolmenutext = (String)menuBarToolsMap[l].get("text");
							String toolmenuiconCls = (String)menuBarToolsMap[l].get("iconCls");
							String toolmenuhandler = (String)menuBarToolsMap[l].get("handler");
							%>
					<LI id=divToolsMenuLI<%=toolid%><%=l%> class="x-menu-list-item">
					<A id=divToolsMenuA<%=toolid%><%=l%> href="#" class=x-menu-item onclick="<%=toolmenuhandler%>;">
					<IMG id=divToolsMenuIMG<%=toolid%><%=l%> class="x-menu-item-icon <%=toolmenuiconCls%>" src="/js/extjs/resources/images/default/s.gif">
					<SPAN id=divToolsMenuSPAN<%=toolid%><%=l%> class=x-menu-item-text><%=toolmenutext%></SPAN>
					</A>
					</LI>
					<% } %>
				</UL>
				</DIV>
			<%
			}
		}
	}
	%>
	<%-- 工具栏 end --%>

</div>

<div id="divPropTabCollapsed" style="display:none;width: 100%;">
	<DIV style="background-color: #eeeeee;border: solid 1px #e0e0e0;width: 100%;height:26px; margin: 3px;float: right;">
	<div style="text-align: right;margin-top: 3px;cursor:pointer;">
	
	<IMG align=absMiddle src="/images/docs/reply.png">&nbsp;<script type="text/javascript">document.write(wmsg.base.replycount);</script>:<FONT id=fontReply color=red><%=replaydoccount%></FONT>
	<A onclick='onExpandOrCollapse(true);onActiveTab("divAcc");'><IMG align=absMiddle src="/images/docs/acc.png">&nbsp;<script type="text/javascript">document.write(wmsg.base.acccount);</script>:<FONT id=fontImgAcc color=red><%=accessorycount%></FONT></A>
	<IMG align=absMiddle src="/images/docs/expand.png" onclick="onExpandOrCollapse();">
	
	</div>
	</DIV>
</div>

<div id="divPropTab" style="display:none;width: 100%">
	
	<!-- 属性标题栏 start -->
	<div id="divPropTile" style="width:100%;">
		<DIV style="MozUserSelect: none; KhtmlUserSelect: none" class="x-panel-header x-unselectable" unselectable="on">
			<DIV id=divPropTileIcon class="x-tool x-tool-toggle x-tool-collapse-south x-tool-collapse-south-over " onclick="onExpandOrCollapse();">&nbsp;</DIV>
			<SPAN id=divPropTileText class=x-panel-header-text><script type="text/javascript">document.write(wmsg.doc.prop);</script></SPAN>
		</DIV>
	</div>
	<!-- 属性标题栏 end -->
	
	<!-- 文档属性栏 start -->
	<div id="divProp" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<DIV style="WIDTH: 100%" id=DocPropAdd class=" x-panel x-panel-noborder">
		<DIV class=x-panel-bwrap>
		<DIV style="WIDTH: 100%; HEIGHT: 186px; OVERFLOW: auto" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
			<%@ include file="/docs/docs/DocEditBaseInfo.jsp" %>
		</DIV></DIV></DIV></DIV>
	</div>
	<!-- 文档属性栏 end -->

	<!-- 文档附件栏 start -->
	<div id="divAcc" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="edit" name="mode"/>
			<jsp:param value="docedit" name="pagename"/>
			<jsp:param value="false" name="isFromWf"/>
			<jsp:param value="<%=docid%>" name="docid"/>
			<jsp:param value="<%=maxUploadImageSize%>" name="maxUploadImageSize"/>
			<jsp:param value="getDivAcc" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 文档附件栏 end -->

	<!-- 文档共享栏 start -->
	<div id="divShare" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="edit" name="mode"/>
			<jsp:param value="docedit" name="pagename"/>
			<jsp:param value="<%=docid%>" name="docid"/>
			<jsp:param value="<%=canShare%>" name="canShare"/>
			<jsp:param value="getDivShare" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 文档共享栏 end -->

	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	<!-- 文档打分栏 start -->
	<div id="divMark" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="edit" name="mode"/>
			<jsp:param value="docedit" name="pagename"/>
			<jsp:param value="<%=docid%>" name="docid"/>
			<jsp:param value="<%=seccategory%>" name="secid"/>
			<jsp:param value="getDivMark" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 文档打分栏 end -->
	<% } %>

	<!-- 底部选项卡栏 start -->
	<div id="divTab" style="width:100%;">

		<DIV style="WIDTH: 1278px" class="x-tab-panel-footer x-tab-panel-footer-noborder">
		<DIV class=x-tab-strip-spacer></DIV>
		<DIV class=x-tab-strip-wrap>
		<UL class="x-tab-strip x-tab-strip-bottom">
		
		<LI id=divPropATab class=" x-tab-strip-active" onclick="onActiveTab('divProp');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.base);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		
		<LI id=divAccATab class=" "  onclick="onActiveTab('divAcc');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text " id="divAccATabTitle"><script type="text/javascript">document.write(wmsg.doc.acc + '(<%=accessorycount%>)');</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		
		<LI id=divShareATab class=" "  onclick="onActiveTab('divShare');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.share);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>

		<% if(DocMark.isAllowMark(""+seccategory)){ %>
		<LI id=divMarkATab class=" "  onclick="onActiveTab('divMark');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.mark);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		<% } %>
		
		

		<LI class=x-tab-edge></LI>
		<DIV class=x-clear></DIV></UL></DIV></DIV>

	</div>
	<!-- 底部选项卡栏 end -->
</div>

</div>

</form>
</body>

</html>

<jsp:include page="/docs/docs/DocComponents.jsp">
	<jsp:param value="<%=user.getLanguage()%>" name="language"/>
	<jsp:param value="getBase" name="operation"/>
</jsp:include>

<script language="javascript" type="text/javascript">
var isFromWf=false;
var seccategory="<%=seccategory%>"; 

var docid="<%=docid%>";
var docTitle="<%=docsubject%>";
var isReply="<%=isreply.equals("1")%>";
var doceditionid="<%=doceditionid%>";

var showType="view";
var coworkid="0";
var meetingid="0";

var strExtBar="<%=strExtBar%>";
var menubar=eval(strExtBar);
var menubarForwf=[];

var canShare=<%=canShare%>;
var canEdit=<%=canEdit%>;
var canDownload=<%=canEdit%>;
var canViewLog=<%=false%>;
var canDocMark=<%=DocMark.isAllowMark(""+seccategory)%>;
var requestid="0";
var maxUploadImageSize="<%= DocUtil.getMaxUploadImageSize(seccategory)%>";

var isEditionOpen=<%=isEditionOpen%>;

function adjustContentHeight(type){
	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	try{
		var propTabHeight = 250;
		if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none") propTabHeight = 30;
		
		var pageHeight=document.body.clientHeight;
		var pageWidth=document.body.clientWidth;
		document.getElementById("divContentTab").style.height = pageHeight - propTabHeight;
		var divContentHeight=pageHeight-propTabHeight-68;
		var divContentWidth=pageWidth;
		if(type=="load"){
			document.getElementById("doccontent").style.height=divContentHeight;
			//FCKEditorExt.initEditor('weaver','doccontent',lang);
			//var ckeditor = CKEDITOR.replace('doccontent',{height:divContentHeight-50,toolbar:'base'});
			CkeditorExt.initEditor('weaver','doccontent','<%=user.getLanguage()%>','',divContentHeight-30,'base')

		} else {			
			if(divContentHeight!=null && divContentHeight>0) {
				//FCKEditorExt.resize(divContentWidth,divContentHeight);	
				jQuery("#cke_contents_"+"doccontent").css("height",divContentHeight-30);				
			}
		}
		<% 
		for(Iterator mbit = menuBars.iterator();mbit.hasNext();){
			menuBarMap = (Map)mbit.next();
			if(menuBarMap.size()>0) {
				String toolid = (String)menuBarMap.get("id");
				menuBarToolsMap = (Map[])menuBarMap.get("menu");
				if(menuBarToolsMap!=null&&menuBarToolsMap.length>0){
				%>
				hideToolsMenu<%=toolid%>();
				<%
				}
			}
		}
		%>
		onResizeDiv();
	} catch(e){
	}
}

function switchEditMode(){
	var oEditor = CKEDITOR.instances.doccontent;
	oEditor.execCommand("source");
}

function onAccessory(){	
	onExpandOrCollapse(true);
	onActiveTab("divAcc");
}

function onExpandOrCollapse(show){
	
	var flag = false;
	if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none"||show) flag = true;
	if(flag){
		document.getElementById("divPropTab").style.display = "block";
		document.getElementById("divPropTabCollapsed").style.display = "none";
		if(document.getElementById("BUTTONbtn_ShowOrHidden")) document.getElementById("BUTTONbtn_ShowOrHidden").value=wmsg.base.hiddenProp;
	}else{
		document.getElementById("divPropTab").style.display = "none";
		document.getElementById("divPropTabCollapsed").style.display = "block";
		if(document.getElementById("BUTTONbtn_ShowOrHidden")) document.getElementById("BUTTONbtn_ShowOrHidden").value=wmsg.base.showProp;
	}
	adjustContentHeight();
	try {
		loadExt();
	} catch(e){}
}

function onActiveTab(tab){
	document.getElementById("divProp").style.display='none';
	document.getElementById("divAcc").style.display='none';
	document.getElementById("divShare").style.display='none';
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	document.getElementById("divMark").style.display='none';
	<% } %>
	document.getElementById("divPropATab").className = "";
	document.getElementById("divAccATab").className = "";
	document.getElementById("divShareATab").className = "";
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	document.getElementById("divMarkATab").className="";
	<% } %>
	
	document.getElementById(tab).style.display='block';
	document.getElementById(tab+"ATab").className='x-tab-strip-active';

	try {
		loadExt();
		eval("doGet"+tab+"();");
		onResizeDiv();
	} catch(e){}
}

function onResizeDiv() {
	if(document.getElementById("divAcc").style.display!='none')
		resizedivAcc();
	else if(document.getElementById("divShare").style.display!='none')
		resizedivShare();
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	else if(document.getElementById("divMark").style.display!='none')
		resizedivMark();
	<% } %>
}

$(document).ready(
	function(){
		
		try{
			onLoad();
		} catch(e){}
		
		try{
			document.getElementById("divContentTab").style.display='block';
			document.getElementById("divPropTab").style.display = "none";
			document.getElementById("divPropTabCollapsed").style.display = "block";

			onActiveTab("divProp");
			
			document.getElementById('rightMenu').style.visibility="hidden";
			document.getElementById("divMenu").style.display='';	
		} catch(e){}

		adjustContentHeight("load");

		finalDo("edit");
		createTags();// by cyril on 2008-08-14 for td:9077

		try{	
			onLoadEnd();
		} catch(e){}

<%if(!docsubject.equals("")&&!isPersonalDoc){%>
		try{
			checkDocSubject($('docsubject'));
		} catch(e){}
<%}%>

	}   
);

function disableToolBar(){
	<% 
	for(Iterator mbit = menuBars.iterator();mbit.hasNext();){
		menuBarMap = (Map)mbit.next();
		if(menuBarMap.size()>0) {
			String toolid = (String)menuBarMap.get("id");
			menuBarToolsMap = (Map[])menuBarMap.get("menu");
			if(menuBarToolsMap!=null&&menuBarToolsMap.length>0){
			%>
			if(documet.getElementById("BUTTON<%=toolid%>"))
				documet.getElementById("BUTTON<%=toolid%>").disabled = true;
			<%
			}
		}
	}
	%>
}

function enableToolBar(){
	<% 
	for(Iterator mbit = menuBars.iterator();mbit.hasNext();){
		menuBarMap = (Map)mbit.next();
		if(menuBarMap.size()>0) {
			String toolid = (String)menuBarMap.get("id");
			menuBarToolsMap = (Map[])menuBarMap.get("menu");
			if(menuBarToolsMap!=null&&menuBarToolsMap.length>0){
			%>
			if(documet.getElementById("BUTTON<%=toolid%>"))
				documet.getElementById("BUTTON<%=toolid%>").disabled = false;
			<%
			}
		}
	}
	%>
}
</script>
<%@ include file="DocEditForCKScript.jsp" %>