<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.docs.docs.CustomFieldManager" %>
<%

response.setHeader("Pragma","no-cache");

response.setHeader("Cache-Control","no-cache");

response.setDateHeader("Expires",0);

%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.net.*,weaver.general.Util" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" /> 
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OpenSendDoc" class="weaver.docs.senddoc.OpenSendDoc" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page"/>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>

<jsp:useBean id="SecCategoryMouldComInfo" class="weaver.docs.category.SecCategoryMouldComInfo" scope="page"/>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="DocCoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="RequestAnnexUpload" class="weaver.workflow.request.RequestAnnexUpload" scope="page" />
<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="BlogDao" class="weaver.blog.BlogDao" scope="page"/>
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />

<%

int docid = Util.getIntValue(request.getParameter("id"),0);
//页面操作类型，如果为提交状态页面的请求，默认值为sub，TD23929。
String pagestatus = Util.null2String(request.getParameter("pstate")); 
int meetingid = Util.getIntValue(request.getParameter("meetingid"),0);

//文档弹出窗口次数开始
String popnum = Util.null2String(request.getParameter("popnum"));
int is_popnum = 0;
if(!"".equals(popnum)){
 is_popnum =  Util.getIntValue(popnum.substring(popnum.indexOf("_")+1,popnum.length())) + 1;
 docid = Util.getIntValue(popnum.substring(0,popnum.indexOf("_")));
 RecordSet.executeSql("update DocPopUpInfo set is_popnum = "+is_popnum+" where docid = "+docid);
}
//文档弹出窗口次数结束

int olddocid=Util.getIntValue(request.getParameter("olddocid"),0);
if(olddocid<1) olddocid=docid;


//董平添加 修改BUG1483 原因:查看ID=0的文档，系统会将文档全部列出来
if (docid==0){
    response.sendRedirect("/notice/Deleted.jsp?showtype=doc0");
    return ;
}
rs.executeSql("select DocSubject from Docdetail where id="+docid);
if(!rs.next()){
    response.sendRedirect("/notice/Deleted.jsp?showtype=doc");
    return ;
}
String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //来源于流程建文挡
boolean  blnOsp = "true".equals(request.getParameter("blnOsp")) ;   //共享提醒的Session名字
String selectedpubmould = Util.null2String(request.getParameter("selectedpubmould")); //选择显示模版的ID

//user info
int userid=user.getUID();
String logintype = user.getLogintype();
String username=ResourceComInfo.getResourcename(""+userid);
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();

//判断新建的是不是个人文档
boolean isPersonalDoc = false ;
String from =  Util.null2String(request.getParameter("from"));
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
//System.out.println("userCategory is "+userCategory);
int shareparentid= Util.getIntValue(request.getParameter("shareparentid"),0);

if ("personalDoc".equals(from)){
    isPersonalDoc = true ;
}

//TD.5091判断是否客户
boolean isCustomer = false;
if(user.getLogintype().equals("2")){
    isCustomer = true ;
}

int messageid=Util.getIntValue(request.getParameter("messageid"),0);
String isrequest = Util.null2String(request.getParameter("isrequest"));
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);

char flag=Util.getSeparator() ;
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
int requestid=Util.getIntValue(request.getParameter("requestid"),0);

String requestname="";
int workflowid=0;
int formid=0;
int isbill = -1;
int billid=0;
int nodeid=0;
String nodetype="0";
int hasright=0;
String status="";
int creater=0;
int isremark=0;
int operatortype = 0 ;
int replyid = 0 ;
String workflowtype="";
String messageType="";

String docIds="";
String crmIds="";
String hrmIds="";
String prjIds="";
String cptIds="";

String user_fieldid="";
String isreopen="";
String isreject="";
String isend="";

String topageFromOther=Util.null2String(request.getParameter("topage"));

DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();

int docType = DocManager.getDocType();

/*判断是否是PDF文档*/
int imagefileId = Util.getIntValue(request.getParameter("imagefileId"),0);
//文档中心的是否打开附件控制
String isOpenFirstAss = Util.null2String(request.getParameter("isOpenFirstAss"));
//isAppendTypeField参数标识  当前字段类型是附件上传类型
String isAppendTypeField = Util.null2String(request.getParameter("isAppendTypeField"));

boolean isPDF = DocDsp.isPDF(docid,imagefileId,Util.getIntValue(isOpenFirstAss,1));
if(imagefileId==0&&docType == 2) isPDF = false;
if(docType == 2&&!isPDF){
    //response.sendRedirect("DocDspExt.jsp?fromFlowDoc="+fromFlowDoc+"&from="+from+"&userCategory="+userCategory+"&id="+docid+"&isrequest="+isrequest+"&requestid="+requestid+"&blnOsp="+blnOsp);
    response.sendRedirect("DocDspExt.jsp?fromFlowDoc="+fromFlowDoc+"&from="+from+"&userCategory="+userCategory+"&id="+docid+"&olddocid="+olddocid+"&isrequest="+isrequest+"&requestid="+requestid+"&desrequestid="+desrequestid+"&blnOsp="+blnOsp+"&topage="+URLEncoder.encode(topageFromOther)+"&meetingid="+meetingid);
    return ;
}
%>
<HTML><HEAD>

<%
String checkOutMessage=Util.null2String(request.getParameter("checkOutMessage"));  //已被检出提示信息

if(!checkOutMessage.equals("")){
%>
<SCRIPT LANGUAGE="JavaScript">
alert("<%=checkOutMessage%>");
</SCRIPT>
<%
}

//文档信息
int maincategory=DocManager.getMaincategory();
int subcategory=DocManager.getSubcategory();
int seccategory=DocManager.getSeccategory();
int doclangurage=DocManager.getDoclangurage();
String docapprovable=DocManager.getDocapprovable();
String docreplyable=SecCategoryComInfo.getSecReplyAbles(""+seccategory);
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
String parentids=DocManager.getParentids();
int assetid=DocManager.getAssetid();
int ownerid=DocManager.getOwnerid();
String keyword=DocManager.getKeyword();
int accessorycount=DocManager.getAccessorycount();
int replaydoccount=DocManager.getReplaydoccount();
String usertype=DocManager.getUsertype();
String docno = DocManager.getDocno();

int docvaliduserid = DocManager.getDocValidUserId();
String docvaliddate = DocManager.getDocValidDate();
String docvalidtime = DocManager.getDocValidTime();
int docpubuserid = DocManager.getDocPubUserId();
String docpubdate = DocManager.getDocPubDate();
String docpubtime = DocManager.getDocPubTime();
int docreopenuserid = DocManager.getDocReOpenUserId();
String docreopendate = DocManager.getDocReOpenDate();
String docreopentime = DocManager.getDocReOpenTime();
int docinvaluserid = DocManager.getDocInvalUserId();
String docinvaldate = DocManager.getDocInvalDate();
String docinvaltime = DocManager.getDocInvalTime();
int doccanceluserid = DocManager.getDocCancelUserId();
String doccanceldate = DocManager.getDocCancelDate();
String doccanceltime = DocManager.getDocCancelTime();

String docCode = DocManager.getDocCode();
int docedition = DocManager.getDocEdition();
int doceditionid = DocManager.getDocEditionId();
int ishistory = DocManager.getIsHistory();
int selectedpubmouldid = DocManager.getSelectedPubMouldId();

int maindoc = DocManager.getMainDoc();
int docreadoptercanprint = DocManager.getReadOpterCanPrint();

boolean isTemporaryDoc = false;
String invalidationdate = DocManager.getInvalidationDate();
if(invalidationdate!=null&&!"".equals(invalidationdate))
    isTemporaryDoc = true;

//是否回复提醒
String canRemind=DocManager.getCanRemind();

String checkOutStatus=DocManager.getCheckOutStatus();
int checkOutUserId=DocManager.getCheckOutUserId();
String checkOutUserType=DocManager.getCheckOutUserType();


String docCreaterType = DocManager.getDocCreaterType();//文档创建者类型（1:内部用户  2：外部用户）
String docLastModUserType = DocManager.getDocLastModUserType();//文档最后修改者类型（1:内部用户  2：外部用户）
String docApproveUserType = DocManager.getDocApproveUserType();//文档审批者类型（1:内部用户  2：外部用户）
String docInvalUserType = DocManager.getDocInvalUserType();//失效操作人类型（1:内部用户  2：外部用户）
String docArchiveUserType = DocManager.getDocArchiveUserType();//文档归档者类型（1:内部用户  2：外部用户）
String docCancelUserType = DocManager.getDocCancelUserType();//作废操作人类型（1:内部用户  2：外部用户）
String ownerType = DocManager.getOwnerType();//文档拥有者类型（1:内部用户  2：外部用户）

if(docpublishtype.equals("2")){
	int tmppos = doccontent.indexOf("!@#$%^&*");
	if(tmppos!=-1) doccontent = doccontent.substring(tmppos+8,doccontent.length());
}


String docstatusname = DocComInfo.getStatusView(docid,user);

String tmppublishtype="";
if(docpublishtype.equals("2")) tmppublishtype=SystemEnv.getHtmlLabelName(227,user.getLanguage());
else if(docpublishtype.equals("3")) tmppublishtype=SystemEnv.getHtmlLabelName(229,user.getLanguage());
else tmppublishtype=SystemEnv.getHtmlLabelName(58,user.getLanguage());

boolean blnRealViewLog=false;
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
if(approvewfid.equals("0")) needapprovecheck="0";
else needapprovecheck="1";

String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),user.getLanguage());
int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),user.getLanguage());
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
String isSetShare=Util.null2String(""+RecordSet.getString("isSetShare"));
int relationable=Util.getIntValue(""+RecordSet.getString("relationable"),0);
int isOpenAttachment=Util.getIntValue(""+RecordSet.getString("isOpenAttachment"),0);
String readCount = " ";
String topage= URLEncoder.encode("/docs/docs/DocDsp.jsp?id="+docid);

boolean canDownload = (Util.getIntValue(Util.null2String(RecordSet.getString("nodownload")),0)==0)?true:false;
int categoryreadoptercanprint = Util.getIntValue(RecordSet.getString("readoptercanprint"),0);

String isOpenApproveWf=Util.null2String(RecordSet.getString("isOpenApproveWf"));

String readerCanViewHistoryEdition=Util.null2String(RecordSet.getString("readerCanViewHistoryEdition"));
int appointedWorkflowId = Util.getIntValue(RecordSet.getString("appointedWorkflowId"),0);

int isAutoExtendInfo = Util.getIntValue(RecordSet.getString("isAutoExtendInfo"),0);

boolean isEditionOpen = SecCategoryComInfo.isEditionOpen(seccategory);

int coworkid = Util.getIntValue(request.getParameter("coworkid"),0);
int blogDiscussid=Util.getIntValue(request.getParameter("blogDiscussid"),0);
//blogDiscussid=0;
/***************************取出文章被阅读的次数*********************************************************/
int readCount_int = 0 ;
String sql_readCount ="select sum(readCount) from docreadtag where (userid<>"+doccreaterid+" or usertype<>"+usertype+") and docid =" + docid ;
rs.execute(sql_readCount);
if(rs.next()) readCount_int = Util.getIntValue(rs.getString(1),0) ;

/*TD7574 当文档的内容为空时且此文档只有一个附件时，而且没有摘要的文档，直接打开此附件，而不是打开页面*/
boolean openFirstAss = false;
if("1".equals(isOpenFirstAss)) openFirstAss = true;
else if("0".equals(isOpenFirstAss)) openFirstAss = false;
else if(blnOsp||isOpenAttachment==0) openFirstAss = false;
else if(isOpenAttachment==1) openFirstAss = true;

if(openFirstAss){
	//替换HTML标签
	String strDoccontent=Util.replace(doccontent,"<[^>]*>","",0);
	//替换空字符串
	strDoccontent=Util.replace(strDoccontent,"&nbsp;","",0);
	//替换换行
	strDoccontent=Util.replace(strDoccontent,"\r\n","",0);
    //替换空格
	strDoccontent=Util.replace(strDoccontent," ","",0);

	if("initFlashVideo();".equals(strDoccontent)||"".equals(strDoccontent))
		openFirstAss = true;
	else
		openFirstAss = false;
}


int isUseiWebPDF = 0;
try {
	isUseiWebPDF = Util.getIntValue(RecordSet.getPropValue("weaver_iWebPDF", "isUseiWebPDF"), 0);
} catch(Exception e){}
if(isPDF&&isUseiWebPDF==1){
	if(imagefileId==0){
		if(!openFirstAss){
			isPDF = false;
		}
	}
	openFirstAss=false;//若文件是pdf文件且启用PDF在线打开，则不下载打开pdf文件而在线打开PDF文件。
} else if(isPDF&&isUseiWebPDF==0){
	if(imagefileId==0){
		if(openFirstAss){
			DocImageManager.resetParameter();
			DocImageManager.setDocid(docid);
	        try {
	        	DocImageManager.selectDocImageInfo();
				if (DocImageManager.next()) {
					imagefileId = Util.getIntValue(DocImageManager.getImagefileid(),0);
				}
			} catch (Exception e) {			
			}
			if( userid != doccreaterid || !usertype.equals(logintype) ) {
			    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
			    DocDetailLog.resetParameter();
			    DocDetailLog.setDocId(docid);
			    DocDetailLog.setDocSubject(docsubject);
			    DocDetailLog.setOperateType("0");
			    DocDetailLog.setOperateUserid(user.getUID());
			    DocDetailLog.setUsertype(user.getLogintype());
			    DocDetailLog.setClientAddress(request.getRemoteAddr());
			    DocDetailLog.setDocCreater(doccreaterid);
			    DocDetailLog.setDocLogInfo();
			}
			response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+imagefileId+"&coworkid="+coworkid+"&requestid="+requestid+"&desrequestid="+desrequestid);
			return ;
		} else {
			isPDF = false;
		}
	} else {
		if( userid != doccreaterid || !usertype.equals(logintype) ) {
		    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
		    DocDetailLog.resetParameter();
		    DocDetailLog.setDocId(docid);
		    DocDetailLog.setDocSubject(docsubject);
		    DocDetailLog.setOperateType("0");
		    DocDetailLog.setOperateUserid(user.getUID());
		    DocDetailLog.setUsertype(user.getLogintype());
		    DocDetailLog.setClientAddress(request.getRemoteAddr());
		    DocDetailLog.setDocCreater(doccreaterid);
		    DocDetailLog.setDocLogInfo();
		}
		response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+imagefileId+"&coworkid="+coworkid+"&requestid="+requestid+"&desrequestid="+desrequestid);
		return ;
	}
}
if ("sub".equals(pagestatus)) openFirstAss = false;

//如果当前打开文档是  流程中的附件上传类型字段，则不论该附件所在文档内容是否为空、或者存在最新版本，在该链接打开页面永远打开该附件内容、不显示该附件所在文档内容。
if("1".equals(isAppendTypeField)){
	openFirstAss = true;
}

if(openFirstAss){
	DocDsp.setIsRequest(isrequest);
	DocDsp.setRequestId(requestid);
	DocDsp.setFrom(from);
	DocDsp.setUserCategory(userCategory);
	String redUrl=DocDsp.getNoContentRedirUrl(docid);
	//得到附件数，如果附件总数为1就直接打开附件，否则就直接打开这个HTML文档
	//System.out.println("redUrl:"+redUrl);
	if(redUrl!="") {
		/* For TD11396 解决文档中心元素直接打开文档附件时，该文档未被记录已查看 by Hqf Start*/
		if( userid != doccreaterid || !usertype.equals(logintype) ) {
		    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
		    DocDetailLog.resetParameter();
		    DocDetailLog.setDocId(docid);
		    DocDetailLog.setDocSubject(docsubject);
		    DocDetailLog.setOperateType("0");
		    DocDetailLog.setOperateUserid(user.getUID());
		    DocDetailLog.setUsertype(user.getLogintype());
		    DocDetailLog.setClientAddress(request.getRemoteAddr());
		    DocDetailLog.setDocCreater(doccreaterid);
		    DocDetailLog.setDocLogInfo();
		}
		/* For TD11396 解决文档中心元素直接打开文档附件时，该文档未被记录已查看 by Hqf End */
		response.sendRedirect(redUrl);
		return;
	}
}

Hashtable hr = new Hashtable();
hr.put("DOC_MainCategory",Util.null2String(MainCategoryComInfo.getMainCategoryname(""+maincategory)));
hr.put("DOC_SubCategory",Util.null2String(SubCategoryComInfo.getSubCategoryname(""+subcategory)));
hr.put("DOC_SecCategory",Util.null2String(SecCategoryComInfo.getSecCategoryname(""+seccategory)));
hr.put("DOC_Department",Util.null2String("<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+docdepartmentid+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(""+docdepartmentid),user.getLanguage())+"</a>"));
hr.put("DOC_Content",Util.null2String(doccontent));

//if(usertype.equals("1"))  {
//    hr.put("DOC_CreatedBy",Util.null2String(Util.toScreen(ResourceComInfo.getFirstname(""+ownerid),user.getLanguage())));
//    hr.put("DOC_CreatedByLink",Util.null2String("<a href='javaScript:openhrm("+ownerid+"'>"+Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),user.getLanguage())+"</a>"));
//    hr.put("DOC_CreatedByFull",Util.null2String(Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),user.getLanguage())));
//}
//else {
//    hr.put("DOC_CreatedBy",Util.null2String(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage())));
//    hr.put("DOC_CreatedByLink",Util.null2String("<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+ownerid+"'>"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage())+"</a>"));
//    hr.put("DOC_CreatedByFull",Util.null2String(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage())));
//}
if(usertype.equals("2"))  {

    hr.put("DOC_CreatedBy",Util.null2String(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid),user.getLanguage())));
    hr.put("DOC_CreatedByLink",Util.null2String("<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+doccreaterid+"'>"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid),user.getLanguage())+"</a>"));
    hr.put("DOC_CreatedByFull",Util.null2String(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid),user.getLanguage())));
}else {
    hr.put("DOC_CreatedBy",Util.null2String(Util.toScreen(ResourceComInfo.getFirstname(""+doccreaterid),user.getLanguage())));
    hr.put("DOC_CreatedByLink",Util.null2String("<a href='javaScript:openhrm("+doccreaterid+");' onclick='pointerXY(event);'>"+Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())+"</a>"));
    hr.put("DOC_CreatedByFull",Util.null2String(Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())));
}

hr.put("DOC_CreatedDate",Util.null2String(doccreatedate));
hr.put("DOC_DocId",Util.null2String(Util.add0(docid,12)));
hr.put("DOC_ModifiedBy",Util.null2String(Util.toScreen(ResourceComInfo.getFirstname(""+doclastmoduserid),user.getLanguage())));
hr.put("DOC_ModifiedDate",Util.null2String(doclastmoddate));
hr.put("DOC_Language",Util.null2String(LanguageComInfo.getLanguagename(""+doclangurage)));
hr.put("DOC_ParentId",Util.null2String(Util.add0(replydocid,12)));
hr.put("DOC_Status",Util.null2String(docstatusname));
hr.put("DOC_Subject",Util.null2String(docsubject));
hr.put("DOC_Publish",Util.null2String(tmppublishtype));
hr.put("DOC_ApproveDate",Util.null2String(docapprovedate));
hr.put("DOC_NO", Util.null2String(docCode)) ;

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+docsubject;
String needfav ="1";
String needhelp ="";


//从流程过来文档直接跳转
String doc_topage=Util.null2String((String)session.getAttribute("doc_topage")); 
//TD8562
//通过项目卡片或任务信息页面新建文档，提交时要弹出共享设置页面。

if (!"".equals(doc_topage)&&doc_topage.indexOf("ViewCoWork.jsp")==-1&&doc_topage.indexOf("coworkview.jsp")==-1&&doc_topage.indexOf("ViewProject.jsp")==-1&&doc_topage.indexOf("ViewTask.jsp")==-1&&doc_topage.indexOf("/proj/process/DocOperation.jsp")==-1){
   //session.removeAttribute("doc_topage");  
   //response.sendRedirect(doc_topage+"&docfileid=1&docid="+docid); 
   //return ;

    if(!topageFromOther.equals("")){
	    session.removeAttribute("doc_topage");  
	    response.sendRedirect(doc_topage+"&docfileid=1&docid="+docid); 
	    return ;
    }
}else 
//从协作区过来文档直接跳转
if(!"".equals(doc_topage)&&(doc_topage.indexOf("coworkview.jsp")>=0||doc_topage.indexOf("ViewCoWork.jsp")>=0)){
	session.removeAttribute("doc_topage");  
	%>
	<script>
	window.opener.location="<%=doc_topage%>&docfileid=1&docid=<%=docid%>";
	window.close();
	</script>
	<%
	return ;
}

/***************************权限判断**************************************************/
//0:查看  
boolean canReader = false;
//1:编辑
boolean canEdit = false;
//2:删除
boolean canDel = false;
//3:共享
boolean canShare = false ;
//4:日志
boolean canViewLog = false;
//5:可以回复
boolean canReplay = false;
//6:打印
boolean canPrint = false;
//7:发布
boolean canPublish = false;
//8:失效
boolean canInvalidate = false;
//9:归档
boolean canArchive = false;
//10:作废
boolean canCancel = false;
//11:重新打开
boolean canReopen = false;

//签出
boolean canCheckOut = false;
//签入
boolean canCheckIn = false;
//强制签入
boolean canCheckInCompellably =false ;
//新建工作流
boolean cannewworkflow = true;
//TD12005不可下载
boolean canDownloadFromShare = false;

String sharelevel="";
String userSeclevelCheck = userSeclevel;//TD22220
if("2".equals(logintype)){
	userdepartment="0";
	usersubcomany="0";
	userSeclevel="0";
}

//String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
String userInfo=logintype+"_"+userid+"_"+userSeclevelCheck+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);

if (((String)PdocList.get(0)).equals("true")) canReader = true ;
if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
if (((String)PdocList.get(2)).equals("true")) canDel = true ;
if (((String)PdocList.get(3)).equals("true")) canShare = true ;
if (((String)PdocList.get(4)).equals("true")) canViewLog = true ;
if (((String)PdocList.get(5)).equals("true")) canDownloadFromShare = true ;//TD12005

//对于正常状态的文档，是否具有查看权限
boolean canReaderHis = canReader;
//对于正常状态的文档，是否具有编辑权限
boolean canEditHis = canEdit;

//只读权限操作者所见的文档状态为：“生效、正常”、“归档”。
//文档所在子目录的“只读权限操作人可查看历史版本”选上时，也可查看该子目录下的失效文档

//if(canReader && ((canEdit&&!docstatus.equals("8")) || (docstatus.equals("1") || docstatus.equals("2") || docstatus.equals("5"))))
//    canReader = true;
//else
//    canReader = false;

if(canReader && ((!docstatus.equals("7")&&!docstatus.equals("8")) 
                  ||(docstatus.equals("7")&&ishistory==1&&readerCanViewHistoryEdition.equals("1"))
				  )){
    canReader = true;
}else{
    canReader = false;
}

//是否可以查看历史版本
//具有编辑权限的用户，始终可见文档的历史版本；
//可以设置具有只读权限的操作人是否可见历史版本；

if(ishistory==1) {
	//if(SecCategoryComInfo.isReaderCanViewHistoryEdition(seccategory)){
	if(readerCanViewHistoryEdition.equals("1")){
    	if(canReader && !canEdit) canReader = true;
	} else {
	    if(canReader && !canEdit) canReader = false;
	}
}	


//编辑权限操作者可查看文档状态为：“审批”、“归档”、“待发布”或历史文档
if(canEdit && ((docstatus.equals("3") || docstatus.equals("5") || docstatus.equals("6") || docstatus.equals("7")) || ishistory==1)) {
	//canEdit = false;
    canReader = true;
}

//编辑权限操作者可编辑的文档状态为：“草稿”、“生效、正常”、“失效”,非历史文档
if(canEdit && (docstatus.equals("0") || docstatus.equals("4") || docstatus.equals("1") || docstatus.equals("2") || docstatus.equals("7") || docstatus.equals("-1")) && (ishistory!=1))
    canEdit = true;
else
    canEdit = false;

//可回复
if(docreplyable.equals("1") && (docstatus.equals("2") || docstatus.equals("1")))
    canReplay = true;
//可打印
//if(docreadoptercanprint==1)
//    canPrint = true;
if(canEdit||(categoryreadoptercanprint==1)||(categoryreadoptercanprint==2&&docreadoptercanprint==1)){
	canPrint = true;
}
//可发布
//if(HrmUserVarify.checkUserRight("DocEdit:Publish",user,docdepartmentid) && SecCategoryComInfo.needPubOperation(seccategory) && docstatus.equals("6") && (ishistory!=1))
//    canPublish = true ;
if(HrmUserVarify.checkUserRight("DocEdit:Publish",user,docdepartmentid) && docstatus.equals("6") && (ishistory!=1)){
    canPublish = true ;
}
//可失效
if(HrmUserVarify.checkUserRight("DocEdit:Invalidate",user,docdepartmentid) && (docstatus.equals("1") || docstatus.equals("2")) && (ishistory!=1))
    canInvalidate = true ;

//可失效  文档编辑权限者可对文档进行失效
if(canEdit && (docstatus.equals("1") || docstatus.equals("2")) && (ishistory!=1)){
	    canInvalidate = true ;
}

//可归档
if(HrmUserVarify.checkUserRight("DocEdit:Archive",user,docdepartmentid) && (docstatus.equals("1") || docstatus.equals("2")) && (ishistory!=1))
	canArchive = true ;
//可作废
if(HrmUserVarify.checkUserRight("DocEdit:Cancel",user,docdepartmentid) && (docstatus.equals("1") || docstatus.equals("2") || docstatus.equals("5") || docstatus.equals("7")) && (ishistory!=1))
	canCancel = true ;
//可重新打开
if(HrmUserVarify.checkUserRight("DocEdit:Reopen",user,docdepartmentid) && (docstatus.equals("5") || docstatus.equals("8")) && (ishistory!=1))
    canReopen = true ;

if(canEdit){
    canShare = true;
    canViewLog = true;
}

//对任何状态的文档，拥有完全控制权限的操作人可在文档页面上以右键按钮的形式作“删除”操作。
//对任何状态的文档，如文档管理员和目录管理员拥有文档读权限，可在文档页面上以右键按钮的形式作“删除”操作
if(canDel   || HrmUserVarify.checkUserRight("DocEdit:Delete",user,docdepartmentid) ){
    //canDel = true;
	if(docstatus.equals("5")||docstatus.equals("3")){
        canDel = false;
	}else{
		canDel = true;
	}
}else{
    canDel = false;
}

//对于需要弹出共享窗口//或从流程过来的文档//需要可读 
//为消除隐患，取消功能://对于需要弹出共享窗口//或从流程过来的文档//需要可读    update by fanggsh 2007-03-23 for TD6249  begin
////if(blnOsp || isrequest.equals("1")) canReader = true;
//if(blnOsp || (isrequest.equals("1")&&(docstatus.equals("1") || docstatus.equals("2") || docstatus.equals("5")))) canReader = true;
//为消除隐患，取消功能://对于需要弹出共享窗口//或从流程过来的文档//需要可读    update by fanggsh 2007-03-23 for TD6249  end

//从流程过来的文档，并且当前用户处于流程当前操作者中。//可以查看
//if(!canReader&&isrequest.equals("1")&&(isOpenApproveWf.equals("1")||isOpenApproveWf.equals("2"))){
if(!canReader&&(isrequest.equals("1")||requestid>0)){
//    int userTypeForThisIf=0;
//    if("2".equals(""+user.getLogintype())){
//		userTypeForThisIf= 1;
//	}
		
//	StringBuffer sqlSb=new StringBuffer();

//	if(isOpenApproveWf.equals("1")){
//		sqlSb.append(" select 1 ")
//			 .append(" from workflow_currentoperator t2,DocApproveWf t4 ")
//			 .append(" where t2.requestid=t4.requestid ")
//			 .append("   and t2.requestid= ").append(requestid)
//			 .append("   and t4.docId=").append(docid)
//			 .append("   and t2.userid= ").append(userid)
//			 .append("   and t2.usertype= ").append(userTypeForThisIf)
//			 //.append("   and t2.isremark in( '0','1') ")
//		  ;
//	}else{
//		sqlSb.append(" select 1 ")
//			 .append(" from workflow_currentoperator t2,bill_Approve t4 ")
//			 .append(" where t2.requestid=t4.requestid ")
//           .append("   and t2.requestid= ").append(requestid)
//		     .append("   and t4.approveid= ").append(docid)
//		     .append("   and t2.userid= ").append(userid)
//		     .append("   and t2.usertype= ").append(userTypeForThisIf)
//		     .append("   and t4.status='0' ")
//		     //.append("   and t2.isremark in( '0','1') ")
//		    ;
//	}
	
//
//		sqlSb.append(" select 1 ")
//			 .append(" from workflow_currentoperator t2,DocApproveWf t4 ")
//			 .append(" where t2.requestid=t4.requestid ")
//			 .append("   and t2.requestid= ").append(requestid)
//			 .append("   and t4.docId=").append(olddocid)
//			 .append("   and t2.userid= ").append(userid)
//			 .append("   and t2.usertype= ").append(userTypeForThisIf)
//			 .append(" union all ")
//			 .append(" select 1 ")
//			 .append(" from workflow_currentoperator t2,bill_Approve t4 ")
//			 .append(" where t2.requestid=t4.requestid ")
//             .append("   and t2.requestid= ").append(requestid)
//		     .append("   and t4.approveid= ").append(olddocid)
//		     .append("   and t2.userid= ").append(userid)
//		     .append("   and t2.usertype= ").append(userTypeForThisIf)
////		     .append("   and t4.status='0' ")
//		    ;
//
//
//	RecordSet.executeSql(sqlSb.toString());
//
//    if(RecordSet.next()){
//		canReader=true;
//	}
    canReader=WFUrgerManager.OperHaveDocViewRight(requestid,userid,Util.getIntValue(logintype,1),""+docid);
    
  	//另外一种情况,子流程触发的,当前流程创建人可以查看文档
    if(!canReader) {
	    RecordSet.executeSql("SELECT 1 FROM workflow_requestbase WHERE requestid="+requestid+" and creater="+userid);
	    if(RecordSet.next()) {
	    	canReader=true;
	    }
    }
}
boolean onlyview=false;

if(!canReader){
	if(
		  ((""+userid).equals(""+doccreaterid)&&logintype.equals(docCreaterType))
	    ||((""+userid).equals(""+ownerid)&&logintype.equals(ownerType))
	  ){
		canReader=true;
	}
}
int isfrommeeting = 0;
boolean noMeetingDocRight = true;
if(meetingid>0&&!canReader)
{
	noMeetingDocRight = !MeetingUtil.UrgerHaveMeetingDocViewRight(""+meetingid,user,Util.getIntValue(logintype),""+docid);
	if(!noMeetingDocRight)
	{
		isfrommeeting=1;
	}
}

//工作微博点击查看文档
if(!canReader&&blogDiscussid!=0){
	//工作微博记录id
	if(BlogDao.appViewRight("doc",""+userid,docid,blogDiscussid)){	
	      CoworkDAO.shareCoworkRelateddoc(Util.getIntValue(logintype),docid,userid);
	      canReader=true;
	}      
}

//协作区点击查看文档
if(!canReader&&coworkid!=0){
	if(CoworkDAO.haveViewCoworkDocRight(""+userid,""+coworkid,""+docid)) {
	   CoworkDAO.shareCoworkRelateddoc(Util.getIntValue(logintype),docid,userid);
	   canReader=true;
	}
}

if(!canReader)  {
	if (!CoworkDAO.haveRightToViewDoc(Integer.toString(userid),Integer.toString(docid))&&noMeetingDocRight){
        if(!WFUrgerManager.OperHaveDocViewRight(requestid,desrequestid,userid,Util.getIntValue(logintype),""+olddocid) && !WFUrgerManager.UrgerHaveDocViewRight(requestid,userid,Util.getIntValue(logintype),""+docid) && !WFUrgerManager.getMonitorViewObjRight(requestid,userid,""+docid,"0") && isfrommeeting==0 && !RequestAnnexUpload.HaveAnnexDocViewRight(requestid,userid,Util.getIntValue(logintype),docid)){
		if(doceditionid>-1&&ishistory==1){
			RecordSet.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " and ishistory=0 and id<>"+docid+"  order by docedition desc ");
            //RecordSet.next();
	        //int newDocId = Util.getIntValue(RecordSet.getString("id"));
			int newDocId=0;
			if(RecordSet.next()){
				newDocId = Util.getIntValue(RecordSet.getString("id"));
			}
	        if(newDocId!=docid&&newDocId>0){
	%>
		    <script language=javascript>
			//location="DocDsp.jsp?id=<%=newDocId%>";
		        if(confirm("<%=SystemEnv.getHtmlLabelName(20300,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19986,user.getLanguage())%>")) {
					 location="DocDsp.jsp?fromFlowDoc=<%=fromFlowDoc%>&from=<%=from%>&userCategory=<%=userCategory%>&id=<%=newDocId%>&olddocid=<%=olddocid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&blnOsp=<%=blnOsp%>&topage=<%=URLEncoder.encode(topageFromOther)%>";
		        }else{
					location="/notice/noright.jsp";
				}
		    </script> 
	<%
			return;//TD10386 JS跳转需要加入return，下面的JAVA代码才不会执行
	        }else{
				response.sendRedirect("/notice/noright.jsp") ;
	            return ;
			}
		}else{
	        response.sendRedirect("/notice/noright.jsp") ;
	        return ;
		}
        }else{
            onlyview=true;
        }

    } else {
	    canViewLog = true ;
	    cannewworkflow = false;
	}
}
//TD10368 把日志记录移动到权限判断的跳转之后 Start
/**********************向阅读标记表中插入阅读记录，修改阅读次数(只有当浏览者不是创建者时)********************/
if( userid != doccreaterid || !usertype.equals(logintype) ) {
    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
    DocDetailLog.resetParameter();
    DocDetailLog.setDocId(docid);
    DocDetailLog.setDocSubject(docsubject);
    DocDetailLog.setOperateType("0");
    DocDetailLog.setOperateUserid(user.getUID());
    DocDetailLog.setUsertype(user.getLogintype());
    DocDetailLog.setClientAddress(request.getRemoteAddr());
    DocDetailLog.setDocCreater(doccreaterid);
    DocDetailLog.setDocLogInfo();
}
//TD10368 End

	//文档未签出时,编辑权限的用户可手动进行文档签出操作
	if(canEdit&&(checkOutStatus==null||(!checkOutStatus.equals("1")&&!checkOutStatus.equals("2")))){
		canCheckOut=true;
        canCheckIn=false;
        canCheckInCompellably=false;
	}
    //文档签出，且签出人为当前用户，则可进行文档签入操作
	if(checkOutStatus!=null&&(checkOutStatus.equals("1")||checkOutStatus.equals("2"))&&checkOutUserId==userid&&checkOutUserType!=	null&&checkOutUserType.equals(logintype)){
		canCheckOut=false;
        canCheckIn=true;
        canCheckInCompellably=false;
	}

	//文档签出，且签出人不为当前用户，当前用户具有文档管理员或目录管理员权限，则可进行强制签入操作
	if(!canCheckIn&&checkOutStatus!=null&&(checkOutStatus.equals("1")||checkOutStatus.equals("2"))&&!(checkOutUserId==userid&&checkOutUserType!=	null&&checkOutUserType.equals(logintype))){

		//判断当前用户是否是文档管理员或目录管理员
		boolean isDocAdminOrDirAdmin=false;
		
		if(HrmUserVarify.checkUserRight("DocEdit:Delete",user,docdepartmentid)){
			isDocAdminOrDirAdmin=true;
		}else{
			String userTypeForDirAccess=usertype.equals("1")?"0":"1";//userTypeForDirAccess，0：内部用户，1：外部用户
            RecordSet.executeSql("select 1 from DirAccessControlDetail where  sourcetype=0 and sourceid="+maincategory+" and sharelevel=1  and ((type=0 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=1 and content in ("+shareManager.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+"))" );

			if(RecordSet.next()){
				isDocAdminOrDirAdmin=true;
			}else{
				rs.executeSql("select 1 from DirAccessControlDetail where  sourcetype=1 and sourceid="+subcategory+" and sharelevel=1 and ((type=0 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=1 and content in ("+shareManager.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+"))" );
				if(rs.next()){
					isDocAdminOrDirAdmin=true;
				}
			}

		}

		if(isDocAdminOrDirAdmin){
			canCheckOut=false;
            canCheckIn=false;
            canCheckInCompellably=true;
		}

	}

	if(canEdit) canDownload = true;
	
    //下载权限=目录的下载权限&&共享设定的下载权限
    canDownload = canDownloadFromShare && canDownload;//TD12005	
	
//取得模版设置
String mouldtext = "";
int docmouldid = 0;

List selectMouldList = new ArrayList();
int selectMouldType = 0;
int selectDefaultMould = 0;

if(SecCategoryDocPropertiesComInfo.getDocProperties(""+seccategory,"10")&&SecCategoryDocPropertiesComInfo.getVisible().equals("1")){

	if(docType==1){
		RecordSet.executeSql("select t1.* from DocSecCategoryMould t1 right join DocMould t2 on t1.mouldId = t2.id where t1.secCategoryId = "+seccategory+" and t1.mouldType=1 order by t1.id");
		while(RecordSet.next()){
			String moduleid=RecordSet.getString("mouldId");
			String mType = DocMouldComInfo.getDocMouldType(moduleid);
			String modulebind = RecordSet.getString("mouldBind");
			int isDefault = Util.getIntValue(RecordSet.getString("isDefault"),0);

			if(isTemporaryDoc){
			    
				if(Util.getIntValue(modulebind,1)==3){
				    selectMouldType = 3;
				    selectDefaultMould = Util.getIntValue(moduleid);
				    selectMouldList.add(moduleid);
			    } else if(Util.getIntValue(modulebind,1)==1&&isDefault==1){
			        if(selectMouldType==0){
				        selectMouldType = 1;
					    selectDefaultMould = Util.getIntValue(moduleid);
			        }
					selectMouldList.add(moduleid);
			    } else {
			        if(Util.getIntValue(modulebind,1)!=2)
						selectMouldList.add(moduleid);
			    }
				
			} else {
			    
				if(Util.getIntValue(modulebind,1)==2){
				    selectMouldType = 2;
				    selectDefaultMould = Util.getIntValue(moduleid);
				    selectMouldList.add(moduleid);
			    } else if(Util.getIntValue(modulebind,1)==1&&isDefault==1){
			        selectMouldType = 1;
				    selectDefaultMould = Util.getIntValue(moduleid);
					selectMouldList.add(moduleid);
			    } else {
			        if(Util.getIntValue(modulebind,1)!=3)
						selectMouldList.add(moduleid);
			    }
			}
		}
		
		if(canPublish && docstatus.equals("6")){
		    if(Util.getIntValue(Util.null2String(selectedpubmould),0)<=0){
				if(selectMouldType>0){
				    docmouldid = selectDefaultMould;
				}
		    } else {
		        docmouldid = Util.getIntValue(selectedpubmould);
		    }
		} else {
		    if(Util.getIntValue(Util.null2String(selectedpubmould),0)<=0){
		    	if(selectedpubmouldid<=0){
		    	    if(selectMouldType>0)
		    	        docmouldid = selectDefaultMould;
		    	} else {
		    	    docmouldid = selectedpubmouldid;
		    	}
		    } else {
		        docmouldid = Util.getIntValue(selectedpubmould);
		    }
		}
	}
}

if(docmouldid<=0)
    docmouldid = MouldManager.getDefaultMouldId();
MouldManager.setId(docmouldid);
MouldManager.getMouldInfoById();
mouldtext= MouldManager.getMouldText();
MouldManager.closeStatement();
mouldtext = Util.fillValuesToString(mouldtext,hr);

String owneridname=ResourceComInfo.getResourcename(ownerid+"");

String strSql="select catelogid from DocDummyDetail where docid="+docid;
rsDummyDoc.executeSql(strSql);
String dummyIds="";
while(rsDummyDoc.next()){
	dummyIds+=Util.null2String(rsDummyDoc.getString(1))+",";
}

%>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<script language="javascript" src="/js/weaver.js"></script>
<script src="/js/prototype.js" type="text/javascript"></script>
<style type="text/css">
#ext-gen34, #ext-gen29 {
	Line-height:161%!important;
	font-family:"verdana","宋体"!important; 
} 
</style>
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/weaver-lang-tw-gbk.js'></script>
<%}%>
<title><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>:<%=docsubject %></title>
</HEAD>

<body class="ext-ie ext-ie8 x-border-layout-ct" scroll="no" style="overflow-x: hidden">

<%@ include file="/systeminfo/DocTopTitle.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    loadTopMenu=0; 
%>
<div style="display:none;width:100%;height:100%;" >
	<%
	  session.setAttribute("html_"+docid,mouldtext);
	  int htmlcounter=Util.getIntValue((String)session.getAttribute("htmlcounter_"+docid),-1);
		if(htmlcounter<=0){
			session.setAttribute("htmlcounter_"+docid,"1");
		}else{
			htmlcounter++;
			session.setAttribute("htmlcounter_"+docid,""+htmlcounter);
		}
	%>
	<textarea id="txtContent"><%=mouldtext%></textarea>
</div>
<form name=workflow method=post action="/workflow/request/RequestType.jsp">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=docid value='<%=docid%>'>
</form>

<%
List menuBars = new ArrayList();
List menuBarsForWf = new ArrayList();
List menuOtherBar = new ArrayList();

Map menuBarMap = new HashMap();
Map[] menuBarToolsMap = new HashMap[]{};

String strOtherBar="";
//strOtherBar="[";
String strExtBar="";
//strExtBar="[";
String strFunctionBar="";

if(!onlyview){
if (!isPersonalDoc){
   
    if(isrequest.equals("1")){ //从工作流进入的文档
        hasright = 0 ;

        if(logintype.equals("1")) operatortype = 0;
        if(logintype.equals("2")) operatortype = 1;

        if(requestid != 0 ) {
            RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
            if(RecordSet.next()){
                workflowid=RecordSet.getInt("workflowid");
                nodeid=RecordSet.getInt("currentnodeid");
                nodetype=RecordSet.getString("currentnodetype");
                requestname=RecordSet.getString("requestname");
                status=RecordSet.getString("status");
                creater=RecordSet.getInt("creater");
                docIds = Util.null2String(RecordSet.getString("docIds"));
                crmIds = Util.null2String(RecordSet.getString("crmIds"));
                hrmIds = Util.null2String(RecordSet.getString("hrmIds"));
                prjIds = Util.null2String(RecordSet.getString("prjIds"));
                cptIds = Util.null2String(RecordSet.getString("cptIds"));
            }
            RecordSet.executeSql("select isremark from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype = "+operatortype + " and isremark in ('1','0') " );
            if(RecordSet.next())	{
                if((RecordSet.getString(1)).equals("0")) hasright=1;
                else if((RecordSet.getString(1)).equals("1")) isremark=1;
            }


            RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
            if(RecordSet.next()){
                user_fieldid=RecordSet.getString("userids");
                isreopen=RecordSet.getString("isreopen");
                isreject=RecordSet.getString("isreject");
                isend=RecordSet.getString("isend");
            }
            ////~~~~~~~~~~~~~~get billformid & billid~~~~~~~~~~~~~~~~~~~~~
            //RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
            //RecordSet.next();
            //formid=RecordSet.getInt("billformid");
            //billid=RecordSet.getInt("billid");
            //~~~~~~~~~~~~~~get  billid~~~~~~~~~~~~~~~~~~~~~
			RecordSet.executeSql("select billId from workflow_form where requestid="+requestid);
			if(RecordSet.next()){
				billid = RecordSet.getInt("billId");
			}
            //~~~~~~~~~~~~~~get workflowtype & formid & isbill & messageType~~~~~~~~~~~~~~~~~~~~~
            RecordSet.executeSql("select workflowtype,formid,isbill,messageType from workflow_base where id="+workflowid);
            if(RecordSet.next()){
				workflowtype = RecordSet.getString("workflowtype");
				formid = RecordSet.getInt("formid");
				isbill = RecordSet.getInt("isbill");
				messageType = RecordSet.getString("messageType");
            }
        }

        //// 如果从工作流进入，文档审批流程的当前操作者在文档不为正常和归档的情况下可以修改，其它流程的在文档为非审批正常或者退回状态下可以修改
        //if(canEditHis && ((!docstatus.equals("5") && hasright == 1) ||  ((docstatus.equals("0") || docstatus.equals("2") || docstatus.equals("1") || docstatus.equals("4")) && hasright == 0)) ) {
		//如果从工作流进入，文档审批流程的当前操作者在文档不为归档的情况下可以修改，其他操作者在文档为草稿、正常或者退回状态下可以修改。
        if(canEditHis && ((!docstatus.equals("5") && hasright == 1) ||  ((docstatus.equals("0") || docstatus.equals("2") || docstatus.equals("1") || docstatus.equals("4")||Util.getIntValue(docstatus,0)<0) && hasright == 0)) ) {
            RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='DocEdit.jsp?id="+docid+"',_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
            
            //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"',iconCls: 'btn_edit',handler: function(){window.location='DocEdit.jsp?id="+docid+"'}},";
            menuBarMap = new HashMap();
            menuBarMap.put("text",SystemEnv.getHtmlLabelName(93,user.getLanguage()));
            menuBarMap.put("iconCls","btn_edit");
            menuBarMap.put("handler","window.location='DocEdit.jsp?id="+docid+"';");
            menuBars.add(menuBarMap);
            
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
			//RCMenuHeight += RCMenuHeightStep ;
        }
		/*
        // 如果是转发，有批注按钮
        if(isremark==1){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(1005,user.getLanguage())+",javascript:doRemark(),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
            strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(1005,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){doRemark()}},";
        }
        else if(hasright==1 && !isend.equals("1")){       // 否则未结束的有批准或者转发的按钮,可退回的有退回按钮.
            if(nodetype.equals("1")) {// 审批
                RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doSubmit(),_top} " ;
                strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){doSubmit()}},";
            } else {                    // 提交
                RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(),_top} " ;
                strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls: 'btn_save',handler: function(){doSubmit()}},";
            }
            RCMenuHeight += RCMenuHeightStep ;

            RCMenu += "{"+SystemEnv.getHtmlLabelName(6011,user.getLanguage())+",javascript:location.href='/workflow/request/RemarkOld.jsp?requestid="+requestid+"',_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
            strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(6011,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){window.location='/workflow/request/RemarkOld.jsp?requestid="+requestid+"'}},";

            if(isreject.equals("1")){
                RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:doReject(),_top} " ;
                RCMenuHeight += RCMenuHeightStep ;
                
                strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"',iconCls: 'btn_reject',handler: function(){doReject()}},";
            }
        }
		*/
    }
    
    // 从非工作流进入的文档
    else if(canEdit) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='DocEdit.jsp?id="+docid+"',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"',iconCls: 'btn_edit',handler: function(){window.location='DocEdit.jsp?id="+docid+"'}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(93,user.getLanguage()));
        menuBarMap.put("iconCls","btn_edit");
        menuBarMap.put("handler","window.location='DocEdit.jsp?id="+docid+"';");
        menuBars.add(menuBarMap);
		
        if(docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
			
			//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls: 'btn_save',handler: function(){onSave(this)}},";
	        menuBarMap = new HashMap();
	        menuBarMap.put("id", "btn_save");
	        menuBarMap.put("text",SystemEnv.getHtmlLabelName(615,user.getLanguage()));
	        menuBarMap.put("iconCls","btn_save");
	        menuBarMap.put("handler","onSave(this);");
	        menuBars.add(menuBarMap);
		}
    }else if(canReader){
		if(docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0){
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
		    RCMenuHeight += RCMenuHeightStep ;

			//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls: 'btn_save',handler: function(){onSave(this)}},";
	        menuBarMap = new HashMap();
	        menuBarMap.put("id", "btn_save");
	        menuBarMap.put("text",SystemEnv.getHtmlLabelName(615,user.getLanguage()));
	        menuBarMap.put("iconCls","btn_save");
	        menuBarMap.put("handler","onSave(this);");
	        menuBars.add(menuBarMap);
		}
	}

    // 具有编辑权限的人,对文档可以修改共享的, 有共享按钮
    if(canShare){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:doShare(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"',iconCls: 'btn_share',handler: function(){doShare()}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(119,user.getLanguage()));
        menuBarMap.put("iconCls","btn_share");
        menuBarMap.put("handler","doShare();");
        menuBars.add(menuBarMap);
    }

   

    // 具有编辑权限的人对审批后正常的文档可以重新打开
    /*
    if(canReopen){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:onReopen(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    */

    //文档回复， 如果是可以回复的文档且是正常的文档， 可以回复
    if(canReplay) {
        replyid = docid; //replyid初始设为文档id
        if(isreply.equals("1")) replyid = replydocid; //如果是回复的文档
        RCMenu += "{"+SystemEnv.getHtmlLabelName(117,user.getLanguage())+",javascript:doReply(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(117,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){doReply()}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(117,user.getLanguage()));
        menuBarMap.put("iconCls","btn_add");
        menuBarMap.put("handler","doReply();");
        menuBars.add(menuBarMap);
        
		//strFunctionBar+="{text:'"+SystemEnv.getHtmlLabelName(21703,user.getLanguage())+"(<font id=fontReply style=color:#FF0000;font-weight:bold>0</font>)',iconCls: 'btn_add',handler: function(){doReplyList()}},";
    }
    
     // 文档本人在文档非归档,非审批后正常,非打开状态的时候可以删除文档
    if(canDel) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"',iconCls: 'btn_remove',handler: function(){onDelete(this)}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(91,user.getLanguage()));
        menuBarMap.put("iconCls","btn_remove");
        menuBarMap.put("handler","onDelete(this);");
        menuBars.add(menuBarMap);
    }

    // 如果可以对其它系统发送该文档,可以发送这个文档
    if(OpenSendDoc.inSendDoc(""+docid)) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(16999,user.getLanguage())+",javascript:location.href='/docs/sendDoc/docCheckDetail.jsp?sendDocId="+OpenSendDoc.getSendDocId(""+docid)+"',_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        //strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(16999,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){window.location='/docs/sendDoc/docCheckDetail.jsp?sendDocId="+OpenSendDoc.getSendDocId(""+docid)+"'}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(16999,user.getLanguage()));
        menuBarMap.put("iconCls","btn_add");
        menuBarMap.put("handler","window.location='/docs/sendDoc/docCheckDetail.jsp?sendDocId="+OpenSendDoc.getSendDocId(""+docid)+"';");
        menuOtherBar.add(menuBarMap);
    }

    // 如果文档不在打开状态,可以新建工作流
    if(!docstatus.equals("3") && cannewworkflow ) {
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(1239,user.getLanguage())+",javascript:document.workflow.submit(),_top} " ;

		if(appointedWorkflowId>0){
			boolean hasNewRequestRight=false;
			String isagent="0";
		    //判断是否有流程创建权限
			hasNewRequestRight = shareManager.hasWfCreatePermission(user, appointedWorkflowId);

            if(!hasNewRequestRight){
				String begindate="";
				String begintime="";
				String enddate="";
				String endtime="";
				int beagenterid=0;
				RecordSet.executeSql("select distinct workflowid,beagenterid,begindate,begintime,enddate,endtime from workflow_agent where workflowid="+appointedWorkflowId+" and agenttype>'0' and iscreateagenter=1 and agenterid="+userid);
				while(RecordSet.next()&&!hasNewRequestRight){
					begindate=Util.null2String(RecordSet.getString("begindate"));
					begintime=Util.null2String(RecordSet.getString("begintime"));
					enddate=Util.null2String(RecordSet.getString("enddate"));
					endtime=Util.null2String(RecordSet.getString("endtime"));
					beagenterid=Util.getIntValue(RecordSet.getString("beagenterid"),0);

					if(!begindate.equals("")){
						if((begindate+" "+begintime).compareTo(CurrentDate+" "+CurrentTime)>0)
							continue;
					}
					if(!enddate.equals("")){
					    if((enddate+" "+endtime).compareTo(CurrentDate+" "+CurrentTime)<0)
					        continue;
					}
					
					hasNewRequestRight = shareManager.hasWfCreatePermission(beagenterid, appointedWorkflowId);
					
					if(hasNewRequestRight){
						isagent="1";
					}
				}
			}

			if(hasNewRequestRight){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1239,user.getLanguage())+",javascript:location.href='/workflow/request/AddRequest.jsp?workflowid="+appointedWorkflowId+"&isagent="+isagent+"&docid="+docid+"',_top} " ;
				RCMenuHeight += RCMenuHeightStep ;

				//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(1239,user.getLanguage())+"',iconCls: 'btn_relateCwork',handler: function(){window.location='/workflow/request/AddRequest.jsp?workflowid="+appointedWorkflowId+"&isagent="+isagent+"&docid="+docid+"'}},";
		        menuBarMap = new HashMap();
		        menuBarMap.put("text",SystemEnv.getHtmlLabelName(1239,user.getLanguage()));
		        menuBarMap.put("iconCls","btn_relateCwork");
		        menuBarMap.put("handler","window.location='/workflow/request/AddRequest.jsp?workflowid="+appointedWorkflowId+"&isagent="+isagent+"&docid="+docid+"';");
		        menuOtherBar.add(menuBarMap);
			}else{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1239,user.getLanguage())+",javascript:document.workflow.submit(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;

				//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(1239,user.getLanguage())+"',iconCls: 'btn_relateCwork',handler: function(){document.workflow.submit()}},";
		        menuBarMap = new HashMap();
		        menuBarMap.put("text",SystemEnv.getHtmlLabelName(1239,user.getLanguage()));
		        menuBarMap.put("iconCls","btn_relateCwork");
		        menuBarMap.put("handler","document.workflow.submit();");
		        menuOtherBar.add(menuBarMap);
			}
		}else{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1239,user.getLanguage())+",javascript:document.workflow.submit(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;

			//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(1239,user.getLanguage())+"',iconCls: 'btn_relateCwork',handler: function(){document.workflow.submit()}},";
	        menuBarMap = new HashMap();
	        menuBarMap.put("text",SystemEnv.getHtmlLabelName(1239,user.getLanguage()));
	        menuBarMap.put("iconCls","btn_relateCwork");
	        menuBarMap.put("handler","document.workflow.submit();");
	        menuOtherBar.add(menuBarMap);
		}
    }
    	
    if(!isCustomer){
	    // 新建协作事件
		RCMenu += "{"+SystemEnv.getHtmlLabelName(17859,user.getLanguage())+",/cowork/AddCoWork.jsp?docid="+docid+",_self} " ;
		RCMenuHeight += RCMenuHeightStep;

		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(17859,user.getLanguage())+"',iconCls: 'btn_newCwork',handler: function(){window.location='/cowork/AddCoWork.jsp?docid="+docid+"'}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(17859,user.getLanguage()));
        menuBarMap.put("iconCls","btn_newCwork");
        menuBarMap.put("handler","window.location='/cowork/AddCoWork.jsp?docid="+docid+"';");
        menuOtherBar.add(menuBarMap);
	    // 关联到协作
		RCMenu += "{"+SystemEnv.getHtmlLabelName(19759,user.getLanguage())+",javascript:doRelate2Cowork(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep;

		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(19759,user.getLanguage())+"',iconCls: 'btn_relateCwork',handler: function(){doRelate2Cowork(this)}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(19759,user.getLanguage()));
        menuBarMap.put("iconCls","btn_relateCwork");
        menuBarMap.put("handler","doRelate2Cowork(this);");
        menuOtherBar.add(menuBarMap);
    }

    // 可以查看文档的人都具有查看相关工作流的列表权限
    RCMenu += "{"+SystemEnv.getHtmlLabelName(15295,user.getLanguage())+",javascript:doRelateWfFun("+docid+"),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(15295,user.getLanguage())+"',iconCls: 'btn_relateWork',handler: function(){window.location='/workflow/search/WFSearchTemp.jsp?docids="+docid+"'}},";
    menuBarMap = new HashMap();
    menuBarMap.put("text",SystemEnv.getHtmlLabelName(15295,user.getLanguage()));
    menuBarMap.put("iconCls","btn_relateWork");
    menuBarMap.put("handler","doRelateWfFun("+docid+");");
    menuOtherBar.add(menuBarMap);

    //新建计划
    if(!isCustomer){
	    // added by lupeng 200-07-09 to add the "add work plan" button.
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(16426,user.getLanguage())+",javascript:doAddWorkPlan(),_top} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    // end
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(16426,user.getLanguage())+"',iconCls: 'btn_newPlan',handler: function(){doAddWorkPlan()}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(16426,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_newPlan");
	    menuBarMap.put("handler","doAddWorkPlan();");
	    menuOtherBar.add(menuBarMap);
    }

    // 具有文档管理员权限的人可以对待发布文档进行发布
    if(canPublish){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(114,user.getLanguage())+",javascript:onPublish(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(114,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onPublish(this)}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(114,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onPublish(this);");
	    menuOtherBar.add(menuBarMap);
    }
    
    // 具有编辑或文档管理员权限的人可以对生效/正常文档进行失效操作
    if(canInvalidate){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(15750,user.getLanguage())+",javascript:onInvalidate(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(15750,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onInvalidate(this)}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(15750,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onInvalidate(this);");
	    menuOtherBar.add(menuBarMap);
    }
    // 具有文档管理员权限的人可以对生效/正常文档进行归档操作
    if(canArchive){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(251,user.getLanguage())+",javascript:onArchive(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(251,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onArchive(this)}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(251,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onArchive(this);");
	    menuOtherBar.add(menuBarMap);
    }
    // 具有文档管理员权限的人可以对生效/正常文档进行作废操作
    // 具有文档管理员权限的人可以对失效文档进行作废操作
    // 具有文档管理员权限的人可以对归档文档进行作废操作
    if(canCancel){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(15358,user.getLanguage())+",javascript:onCancel(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(15358,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onCancel(this)}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(15358,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onCancel(this);");
	    menuOtherBar.add(menuBarMap);
    }
    
    // 具有文档管理员权限的人可以对归档文档进行重新打开操作
    // 具有文档管理员权限的人可以对作废文档进行重新打开操作
    if(canReopen){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:onReopen(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onReopen(this)}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(244,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onReopen(this);");
	    menuOtherBar.add(menuBarMap);
    }
    
    
	//文档未签出时,编辑权限的用户可手动进行文档签出操作
    if(canCheckOut){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(19692,user.getLanguage())+",javascript:onCheckOut(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(19692,user.getLanguage())+"',iconCls: 'btn_checkout',handler: function(){onCheckOut(this)}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(19692,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_checkout");
	    menuBarMap.put("handler","onCheckOut(this);");
	    menuOtherBar.add(menuBarMap);
    }
    //文档签出，且签出人为当前用户，则可进行文档签入操作

    if(canCheckIn){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(19693,user.getLanguage())+",javascript:onCheckIn(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(19693,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onCheckIn()}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(19693,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onCheckIn();");
	    menuOtherBar.add(menuBarMap);
    }

	//文档签出，且签出人不为当前用户，当前用户具有文档管理员或目录管理员权限，则可进行强制签入操作
    if(canCheckInCompellably){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(19688,user.getLanguage())+",javascript:onCheckIn(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(19688,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onCheckIn()}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(19688,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onCheckIn();");
	    menuOtherBar.add(menuBarMap);
    }
    
    // 具有文档管理员权限的人可以对正常文档进行重载
    if(HrmUserVarify.checkUserRight("DocEdit:Reload",user,docdepartmentid) && docstatus.equals("5")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(256,user.getLanguage())+",javascript:onReload(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(256,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onReload()}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(256,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onReload();");
	    menuOtherBar.add(menuBarMap);
    }

    // 具有打印权限可以对文档进行打印
    if(canPrint){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:onPrint(),_top} " ;
	    RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+"',iconCls: 'btn_print',handler: function(){onPrint()}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(257,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_print");
	    menuBarMap.put("handler","onPrint();");
	    menuOtherBar.add(menuBarMap);
    }
    
    // 从审批工作流进入的, 或者具有编辑权限并且文档有审批的，都有审批意见按钮
//    if((canEdit && docapprovable.equals("1")) || isremark==1 || hasright==1 ) {
    if(((canEdit && docapprovable.equals("1")) || isremark==1 || hasright==1 )&&isbill==1&&formid==28) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(1008,user.getLanguage())+",javascript:location.href='DocApproveRemark.jsp?docid="+docid+"&isrequest="+isrequest+"&requestid="+requestid+"',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(1008,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){window.location='DocApproveRemark.jsp?docid="+docid+"&isrequest="+isrequest+"&requestid="+requestid+"'}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(1008,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","window.location='DocApproveRemark.jsp?docid="+docid+"&isrequest="+isrequest+"&requestid="+requestid+"';");
	    menuOtherBar.add(menuBarMap);
    }
//TD12005    if((SecCategoryComInfo.getLogviewtype(seccategory)==1&&user.getLoginid().equalsIgnoreCase("sysadmin"))||(SecCategoryComInfo.getLogviewtype(seccategory)==0)){
	//当文档目录设定为"按文档日志权限查看"时，对于有文档查看权限的人也能查看日志(TD12005)    
    if((SecCategoryComInfo.getLogviewtype(seccategory)==1&&HrmUserVarify.checkUserRight("FileLogView:View", user))||(SecCategoryComInfo.getLogviewtype(seccategory)==0)){
    // 具有编辑权限的人都可以查看文档的查看日志
    if(canViewLog&&logintype.equals("1")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:doViewLog(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

		//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"',iconCls: 'btn_log',handler: function(){doViewLog()}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(83,user.getLanguage()));
        menuBarMap.put("iconCls","btn_log");
        menuBarMap.put("handler","doViewLog();");
        menuBars.add(menuBarMap);
		blnRealViewLog=true;

    }else if(canEdit&&logintype.equals("2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:doViewLog(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

		//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"',iconCls: 'btn_log',handler: function(){doViewLog()}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(83,user.getLanguage()));
        menuBarMap.put("iconCls","btn_log");
        menuBarMap.put("handler","doViewLog();");
        menuBars.add(menuBarMap);
		blnRealViewLog=true;
    }
    
    }
    
} else {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='DocEdit.jsp?from="+from+"&id="+docid+"&userCategory="+userCategory+"',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"',iconCls: 'btn_edit',handler: function(){window.location='DocEdit.jsp?from="+from+"&id="+docid+"&userCategory="+userCategory+"'}},";
    menuBarMap = new HashMap();
    menuBarMap.put("text",SystemEnv.getHtmlLabelName(93,user.getLanguage()));
    menuBarMap.put("iconCls","btn_edit");
    menuBarMap.put("handler","window.location='DocEdit.jsp?from="+from+"&id="+docid+"&userCategory="+userCategory+"';");
    menuBars.add(menuBarMap);
	if(!docstatus.equals("1") || !docstatus.equals("2") || !docstatus.equals("6")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onSave(this)}},";
    menuBarMap = new HashMap();
    menuBarMap.put("text",SystemEnv.getHtmlLabelName(615,user.getLanguage()));
    menuBarMap.put("iconCls","btn_add");
    menuBarMap.put("handler","onSave(this);");
    menuBars.add(menuBarMap);
	}
}
if(HrmUserVarify.checkUserRight("Document:Top", user))
{
	boolean cantop = false;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String createidsubcomid = ResourceComInfo.getSubCompanyID(""+doccreaterid);
	if(detachable==1)
	{
		ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Document:Top");
		if(subcompanylist.indexOf(createidsubcomid)!=-1)
		{
			cantop = true;	
		}
	}
	else
	{
		cantop = true;
	}
	if(docstatus.equals("3"))
	{
		cantop = false;
	}
	if(cantop)
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(23784,user.getLanguage())+",javascript:DocToTop("+docid+",1),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(23784,user.getLanguage())+"',iconCls: 'btn_up',handler: function(){DocToTop("+docid+",1);}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(23784,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_up");
	    menuBarMap.put("handler","DocToTop("+docid+",1);");
	    menuBars.add(menuBarMap);
	}
	String sql = "select istop from docdetail d where d.id="+docid;
	rs.executeSql(sql);
	rs.next();
	int istop = rs.getInt(1);
	if(istop==1)
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(24675,user.getLanguage())+",javascript:DocToTop("+docid+",2),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(24675,user.getLanguage())+"',iconCls: 'btn_down',handler: function(){DocToTop("+docid+",2);}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(24675,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_down");
	    menuBarMap.put("handler","DocToTop("+docid+",2);");
	    menuBars.add(menuBarMap);
	}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+"',iconCls: 'btn_back',handler: function(){window.history.go(-1)}},";
menuBarMap = new HashMap();
menuBarMap.put("text",SystemEnv.getHtmlLabelName(1290,user.getLanguage()));
menuBarMap.put("iconCls","btn_back");
menuBarMap.put("handler","window.history.go(-1);");
menuBars.add(menuBarMap);
}
//if(",".equals(strOtherBar.substring(strOtherBar.length()-1))) strOtherBar=strOtherBar.substring(0,strOtherBar.length()-1);
//strOtherBar+="]";

//strFunctionBar+="{text:'"+SystemEnv.getHtmlLabelName(21704,user.getLanguage())+"(<font id=fontImgAcc style=color:#FF0000;font-weight:bold>0</font>)',iconCls: 'btn_add',handler: function(){doImgAcc()}}"; //附件


//System.out.println("============"+strOtherBar);
//strExtBar+="'-',{text:'"+SystemEnv.getHtmlLabelName(21739,user.getLanguage())+"',iconCls: 'btn_list',menu:"+strOtherBar+"}";
//strExtBar+="'-',"+strFunctionBar;
if(menuOtherBar.size()>0){
menuBarMap = new HashMap();
menuBars.add(menuBarMap);

menuBarMap = new HashMap();
menuBarMap.put("text",SystemEnv.getHtmlLabelName(21739,user.getLanguage()));
menuBarMap.put("iconCls","btn_list");
menuBarMap.put("id","menuTypeChanger");
menuBarToolsMap = new HashMap[menuOtherBar.size()];
for(int tmpindex=0;tmpindex<menuOtherBar.size();tmpindex++) menuBarToolsMap[tmpindex]=(Map)menuOtherBar.get(tmpindex);
menuBarMap.put("menu",menuBarToolsMap);
menuBars.add(menuBarMap);
}

//strExtBar+=",'-',{text:'<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>',iconCls: 'btn_ShowOrHidden',handler: function(){DocCommonExt.showorhiddenprop()}}";  //显示属性
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

<div id="divTopMenu" style="display:none">
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</div>

<FORM id=docsharelog name=docsharelog action="DocShare.jsp" method=post  target="_blank">
<input type=hidden name=docid value="<%=docid%>">
<input type=hidden name=docsubject value="<%=docsubject%>">
<input type=hidden name=doccreaterid value="<%=doccreaterid%>">
<input type=hidden name=sqlwhere value="where docid=<%=docid%>">
</form>

<FORM id=weaver name=weaver action="UploadDoc.jsp" method=post>
	<input type=hidden name=operation>
	<input type=hidden name="isSubmit">
	<input type=hidden name=id value="<%=docid%>">
	<input type=hidden name=docno value='<%=docno%>'>
	<input type=hidden name=docsubject value="<%=docsubject%>">
	<input type=hidden name=docapprovable value="<%=needapprovecheck%>">
	<input type=hidden name=ownerid value="<%=ownerid%>">
    <input type=hidden name="oldownerid" value="<%=ownerid%>">
    <input type=hidden name="ownerType" value="<%=ownerType%>">
	<input type=hidden name=doccreatedate value="<%=doccreatedate%>">
	<input type=hidden name=doccreatetime value="<%=doccreatetime%>">
	<input type=hidden name=docstatus value="<%=docstatus%>">
	<input type=hidden name=docedition value="<%=docedition%>">
	<input type=hidden name=doceditionid value="<%=doceditionid%>">
	<input type=hidden name=maincategory value="<%=(maincategory==-1?"":Integer.toString(maincategory))%>">
	<INPUT type=hidden name=subcategory value="<%=(subcategory==-1?"":Integer.toString(subcategory))%>">
	<INPUT type=hidden name=seccategory value="<%=(seccategory==-1?"":Integer.toString(seccategory))%>">
	<input type=hidden name=docpublishtype value="<%=docpublishtype%>">
	<input type=hidden name=selectedpubmouldid value="<%=docmouldid%>">
	<input type=hidden name=isreply value="<%=isreply%>">
	<input type=hidden name=replydocid value="<%=replydocid%>">
	<input type=hidden name=doccreaterid value="<%=doccreaterid%>">
	<input type=hidden name=docCreaterType value="<%=docCreaterType%>">

	<input type=hidden name=keyword value="<%=keyword%>">
	<input type=hidden name=doccode value="<%=docCode%>">
	<input type=hidden name=assetid value="<%=assetid%>">
	<input type=hidden name=crmid value="<%=crmid%>">
	<input type=hidden name=itemid value="<%=itemid%>">
	<input type=hidden name=projectid value="<%=projectid%>">
	<input type=hidden name=financeid value="<%=financeid%>">

	<input type="hidden" name="hrmresid" value="<%=hrmresid%>">
	<input type="hidden" name="invalidationdate" value="<%=invalidationdate%>">
	<input type="hidden" name="dummycata" value="<%=dummyIds%>">
	<input type="hidden" name="docmodule" value="<%=docmouldid%>">

	<table style="display:none" id="customerTable">
		<tr id="customerTR">
			<td id="customerTD">
			</td>
		</tr>
	</table>
	<script language="JavaScript">
		function insertToCustomer(id, value){
			var customerTD = document.getElementById("customerTD");
			customerTD.innerHTML += "<input type='hidden' name='customfield"+id+"' value='"+value+"' /> ";
		}
	</script>

	<%if(isrequest.equals("1")&&(hasright==1||isremark==1)){%>
		<input type=hidden name="isremark" >
		<input type=hidden name="requestid" value=<%=requestid%>>
		<input type=hidden name="workflowid" value=<%=workflowid%>>
		<input type=hidden name="nodeid" value=<%=nodeid%>>
		<input type=hidden name="nodetype" value=<%=nodetype%>>
		<input type=hidden name="src">
		<input type=hidden name="iscreate" value="0">
		<input type=hidden name="formid" value=<%=formid%>>
		<input type=hidden name="isbill" value=<%=isbill%>>
		<input type=hidden name="billid" value=<%=billid%>>
		<input type=hidden name="requestname" value=<%=requestname%>>
		<input type=hidden name="manager" value=<%=ResourceComInfo.getManagerID(""+userid)%>>
		<input type=hidden name="isfromdoc" value="1">
		<input type=hidden name="workflowtype" value=<%=workflowtype%>>
		<input type=hidden name="messageType" value=<%=messageType%>>
		<input type=hidden name="docIds" value="<%=docIds%>">
		<input type=hidden name="crmIds" value="<%=crmIds%>">
		<input type=hidden name="hrmIds" value="<%=hrmIds%>">
		<input type=hidden name="prjIds" value="<%=prjIds%>">
		<input type=hidden name="cptIds" value="<%=cptIds%>">
	<%}%>

	<textarea name=doccontent style="display:none;"><%=doccontent%></textarea> 

</FORM>

<div style=" width:100%;">

<div id="divContentTab" style="display:none;width:100%;">

	<%-- 文档标题 start --%>
	<div id="divDocTile" style="width:100%; POSITION:relative">
		<DIV style="WIDTH: 100%; MozUserSelect: none; KhtmlUserSelect: none" class="x-tab-panel-header x-unselectable" unselectable="on">
		<DIV class=x-tab-strip-wrap>
		<UL class="x-tab-strip x-tab-strip-top">
		<LI class=" x-tab-strip-active ">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<span class=x-tab-strip-inner><span class="x-tab-strip-text ">
			<div id="spanDocTitle" style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;width:500px;height:20px;padding-top:3px;"><%=docsubject%></div>
		</span></span>
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
		<IFRAME id="doccontentifm" style="OVERFLOW: auto;width:100%;height:100%;" class=x-managed-iframe src="" frameBorder=0></IFRAME>
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

<div id="divPropTabCollapsed" style="display:none;width:100%;">
	<DIV style="position:relative; background-color: #eeeeee;border: solid 0px #e0e0e0;width: 100%;height:26px;text-align: right;">
	<TABLE style="margin-top: 3px;cursor:pointer; position: absolute; right: 0"><TBODY><TR>
	<% if(canViewLog) { %>
	<td style='padding-right:5px'><a onClick='onExpandOrCollapse(true);onActiveTab("divViewLog");'><img align='absmiddle' src='/images/docs/read.png'>&nbsp;<script type="text/javascript">document.write(wmsg.base.readcount);</script>:<font color='red'><%=readCount_int%></font></a></td>
	<% } else { %>
	<td style='padding-right:5px'><img align='absmiddle' src='/images/docs/read.png'>&nbsp;<script type="text/javascript">document.write(wmsg.base.readcount);</script>:<font color='red'><%=readCount_int%></font></td>
	<% } %>
	<% if(canReplay) { %>
	<td style='padding-right:5px'><a onClick='onExpandOrCollapse(true);onActiveTab("divReplay");'><img align='absmiddle' src='/images/docs/reply.png'>&nbsp;<script type="text/javascript">document.write(wmsg.base.replycount);</script>:<font color='red' id='fontReply'><%=replaydoccount%></font></a></td>
	<% } %>
	<TD width=100><A onclick='onExpandOrCollapse(true);onActiveTab("divAcc");'><IMG align='absmiddle' src="/images/docs/acc.png">&nbsp;<script type="text/javascript">document.write(wmsg.base.acccount);</script>:<FONT id=fontImgAcc color=red><%=accessorycount%></FONT></A></TD>
	<TD width=16><IMG align='absmiddle' src="/images/docs/expand.png" onclick="onExpandOrCollapse();"></TD>
	</TR></TBODY></TABLE>
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
			<jsp:include page="/docs/docs/DocDspBaseInfo.jsp">
				<jsp:param value="<%=userCategory%>" name="userCategory"/>
				<jsp:param value="<%=docid%>" name="docid"/>
				<jsp:param value="<%=isPersonalDoc%>" name="isPersonalDoc"/>
				<jsp:param value="<%=canPublish%>" name="canPublish"/>
				<jsp:param value="<%=selectedpubmould%>" name="selectedpubmould"/>
			</jsp:include>
		</DIV></DIV></DIV></DIV>
	</div>
	<!-- 文档属性栏 end -->

	<!-- 文档附件栏 start -->
	<div id="divAcc" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="<%=user.getLanguage()%>" name="language"/>
			<jsp:param value="view" name="mode"/>
			<jsp:param value="docdsp" name="pagename"/>
			<jsp:param value="false" name="isFromWf"/>
			<jsp:param value="<%=docid%>" name="docid"/>
			<jsp:param value="<%=DocUtil.getMaxUploadImageSize(seccategory)%>" name="maxUploadImageSize"/>
      <jsp:param value="<%=DocUtil.getBatchDownloadFlag(docid)%>" name="bacthDownloadFlag"/>
			<jsp:param value="getDivAcc" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 文档附件栏 end -->

	<% if(canReplay) { %>
	<!-- 文档回复栏 start -->
	<div id="divReplay" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="<%=user.getLanguage()%>" name="language"/>
			<jsp:param value="view" name="mode"/>
			<jsp:param value="docdsp" name="pagename"/>
			<jsp:param value="<%=docid%>" name="docid"/>
			<jsp:param value="<%=seccategory%>" name="secid"/>
			<jsp:param value="getDivReplay" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 文档回复栏 end -->
	<% } %>

	<!-- 文档共享栏 start -->
	<div id="divShare" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="<%=user.getLanguage()%>" name="language"/>
			<jsp:param value="view" name="mode"/>
			<jsp:param value="docedsp" name="pagename"/>
			<jsp:param value="<%=docid%>" name="docid"/>
			<jsp:param value="<%=canShare%>" name="canShare"/>
			<jsp:param value="getDivShare" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 文档共享栏 end -->
		
	<!-- 文档版本栏 start -->
	<div id="divVer" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="<%=user.getLanguage()%>" name="language"/>
			<jsp:param value="view" name="mode"/>
			<jsp:param value="docdsp" name="pagename"/>
			<jsp:param value="<%=docid%>" name="docid"/>
			<jsp:param value="<%=canShare%>" name="canShare"/>
			<jsp:param value="getDivVer" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 文档版本栏 end -->
	
	<% if(canViewLog) { %>
	<!-- 文档日志栏 start -->
	<div id="divViewLog" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="<%=user.getLanguage()%>" name="language"/>
			<jsp:param value="view" name="mode"/>
			<jsp:param value="docdsp" name="pagename"/>
			<jsp:param value="<%=docid%>" name="docid"/>
			<jsp:param value="<%=canShare%>" name="canShare"/>
			<jsp:param value="getDivViewLog" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 文档日志栏 end -->
	<% } %>
		
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	<!-- 文档打分栏 start -->
	<div id="divMark" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="<%=user.getLanguage()%>" name="language"/>
			<jsp:param value="view" name="mode"/>
			<jsp:param value="docdsp" name="pagename"/>
			<jsp:param value="<%=docid%>" name="docid"/>
			<jsp:param value="<%=seccategory%>" name="secid"/>
			<jsp:param value="getDivMark" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 文档打分栏 end -->
	<% } %>
	
	<% if(relationable==1){ %>
	<!-- 相关资源栏 start -->
	<div id="divRelationResource" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 186px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="<%=user.getLanguage()%>" name="language"/>
			<jsp:param value="view" name="mode"/>
			<jsp:param value="docdsp" name="pagename"/>
			<jsp:param value="<%=docid%>" name="docid"/>
			<jsp:param value="<%=canShare%>" name="canShare"/>
			<jsp:param value="getDivRelationResource" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 相关资源栏 end -->
	<% } %>

	<!-- 底部选项卡栏 start -->
	<div id="divTab" style="width:100%;">

		<DIV style="WIDTH:100%" class="x-tab-panel-footer x-tab-panel-footer-noborder">
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
		
		<% if(canReplay) { %>
		<LI id=divReplayATab class=" "  onclick="onActiveTab('divReplay');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text " id="divReplayATabTitle"><script type="text/javascript">document.write(wmsg.doc.reply + '(<%=replaydoccount%>)');</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		<% } %>
		
		<LI id=divShareATab class=" "  onclick="onActiveTab('divShare');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.share);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>

		<LI id=divVerATab class=" "  onclick="onActiveTab('divVer');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.version);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		
		<% if(canViewLog) { %>
		<LI id=divViewLogATab class=" "  onclick="onActiveTab('divViewLog');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><%=SystemEnv.getHtmlLabelName(21990,user.getLanguage())%></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		<% } %>

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
		
		<% if(relationable==1){ %>
		<LI id=divRelationResourceATab class=" "  onclick="onActiveTab('divRelationResource');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.base.relationResource);</script></SPAN></SPAN>
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

</body>
</html>

<jsp:include page="/docs/docs/DocComponents.jsp">
	<jsp:param value="<%=user.getLanguage()%>" name="language"/>
	<jsp:param value="getBase" name="operation"/>
</jsp:include>

<script language="javascript" type="text/javascript">
var isFromWf=false;
var docid="<%=docid%>";
var olddocid="<%=olddocid%>";
var seccategory="<%=seccategory%>";	
var parentids="<%=parentids%>";
var docTitle="<%=docsubject%>";
var isReply="<%=isreply.equals("1")%>";
var doceditionid="<%=doceditionid%>";
var readerCanViewHistoryEdition="<%=readerCanViewHistoryEdition%>";
var canEditHis="<%=canEditHis%>";

var showType="view";
var coworkid="<%=coworkid%>";
var meetingid="<%=meetingid%>";

var strExtBar="<%=strExtBar%>";
//alert(strExtBar)
var menubar=eval(strExtBar);
var menubarForwf=[];
var canViewLog=<%=blnRealViewLog%>;	
var canShare=<%=canShare%>;
var canEdit=<%=canEdit%>;
var canDownload=<%=canDownload%>;
var canDocMark=<%=DocMark.isAllowMark(""+seccategory)%>;
var canReplay=<%=canReplay%>
var readCount_int=<%=readCount_int%>
var relationable=<%=relationable==1%>;
var maxUploadImageSize="<%= DocUtil.getMaxUploadImageSize(seccategory)%>";
var pagename="docdsp";
var requestid="<%=requestid%>";
var isrequest="<%=isrequest%>";

var isPDF=<%=isPDF?1:0%>;
var imagefileId=<%=imagefileId%>;
var canPrint=<%=canPrint?1:0%>;
var canEditPDF=<%=canEdit?1:0%>;
var accessorycount=<%=accessorycount%>;

var isEditionOpen=<%=isEditionOpen%>;

var doccreaterid="<%=doccreaterid%>";
var docCreaterType="<%=docCreaterType%>";
var ownerid="<%=ownerid%>";
var ownerType="<%=ownerType%>";

var isAutoExtendInfo=<%=isAutoExtendInfo%>;

function adjustContentHeight(type){
	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	try{
		var propTabHeight = 250;
		if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none") propTabHeight = 30;
		
		var pageHeight=document.body.clientHeight;
		var pageWidth=document.body.clientWidth;
		var divContentHeight=pageHeight-propTabHeight-65;
		var divContentWidth=pageWidth;

		document.getElementById("divContent").style.height=divContentHeight;

		document.getElementById("divContentTab").style.height = pageHeight - propTabHeight;
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

function onExpandOrCollapse(show){
	var flag = false;
	if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none"||show) flag = true;
	if(flag){
		document.getElementById("divPropTab").style.display = "block";
		document.getElementById("divPropTabCollapsed").style.display = "none";
		if(document.getElementById("spanProp")) document.getElementById("spanProp").innerHTML=wmsg.base.hiddenProp;
	}else{
		document.getElementById("divPropTab").style.display = "none";
		document.getElementById("divPropTabCollapsed").style.display = "block";
		if(document.getElementById("spanProp")) document.getElementById("spanProp").innerHTML=wmsg.base.showProp;
	}
	adjustContentHeight();
	try {
		loadExt();
	} catch(e){}
}

function onActiveTab(tab){
	document.getElementById("divProp").style.display='none';
	document.getElementById("divAcc").style.display='none';
	<% if(canReplay) { %>
	document.getElementById("divReplay").style.display='none';
	<% } %>
	document.getElementById("divShare").style.display='none';
	document.getElementById("divVer").style.display='none';
	<% if(canViewLog) { %>
	document.getElementById("divViewLog").style.display='none';
	<% } %>
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	document.getElementById("divMark").style.display='none';
	<% } %>
	<% if(relationable==1){ %>
	document.getElementById("divRelationResource").style.display='none';
	<% } %>
	
	document.getElementById("divPropATab").className = "";
	document.getElementById("divAccATab").className = "";
	<% if(canReplay) { %>
	document.getElementById("divReplayATab").className = "";
	<% } %>
	document.getElementById("divShareATab").className = "";
	document.getElementById("divVerATab").className = "";
	<% if(canViewLog) { %>
	document.getElementById("divViewLogATab").className = "";
	<% } %>
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	document.getElementById("divMarkATab").className = "";
	<% } %>
	<% if(relationable==1){ %>
	document.getElementById("divRelationResourceATab").className = "";
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
	<% if(canReplay) { %>
	else if(document.getElementById("divReplay").style.display!='none')
		resizedivReplay();
	<% } %>
	else if(document.getElementById("divShare").style.display!='none')
		resizedivShare();
	else if(document.getElementById("divVer").style.display!='none')
		resizedivVer();
	<% if(canViewLog) { %>
	else if(document.getElementById("divViewLog").style.display!='none')
		resizedivViewLog();
	<% } %>
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	else if(document.getElementById("divMark").style.display!='none')
		resizedivMark();
	<% } %>
	<% if(relationable==1){ %>
	else if(document.getElementById("divRelationResource").style.display!='none')
		resizedivRelationResource();
	<% } %>
}

$(document).ready(
	function(){
		
		try{
			onLoad();
		} catch(e){}
		
		try{
			document.getElementById("doccontentifm").src = "/docs/docs/DocDspHtmlShow.jsp?docid=<%=docid%>&imagefileId=<%=imagefileId%>&isPDF=<%=isPDF?1:0%>&canPrint=<%=canPrint?1:0%>&canEdit=<%=canEdit?1:0%>"
			
			document.getElementById("divPropTab").style.display = "none";
			document.getElementById("divPropTabCollapsed").style.display = "block";

			onActiveTab("divProp");
			
			document.getElementById('rightMenu').style.visibility="hidden";
			document.getElementById("divTopMenu").style.display='';	

			adjustContentHeight("load");

			document.getElementById("divContentTab").style.display='block';
		} catch(e){}

		if(isFromWf) {			 
			try{
				if(isFromWfTH && isFromWfSN){
				  //Ext.getCmp('signature_id1').hide();
				  document.getElementById('signature_id1').style.display = "none";
				  //Ext.getCmp('signature_id2').hide();
				  document.getElementById('signature_id2').style.display = "none";
				}
		    	//Ext.getCmp('hide_id').hide();
		    	document.getElementById('hide_id').style.display = "none";
			} catch(e){}
	    }

		finalDo("view");

		try{	
			onLoadEnd();
		} catch(e){}

	  	if(isAutoExtendInfo&&isAutoExtendInfo>0&&accessorycount&&accessorycount>0){
	  		var timer=setInterval(function(){
				if(document.readyState=="complete") {
					clearInterval(timer);
					onExpandOrCollapse(true);
					onActiveTab("divAcc");
				}
			},500);
	    }
	}
);
</script>
<jsp:include page="/docs/docs/DocDspScript.jsp">
    <jsp:param name="docid" value="<%=docid%>" />
    <jsp:param name="docmouldid" value="<%=docmouldid%>" />
    <jsp:param name="username" value="<%=username%>" />
    <jsp:param name="CurrentDate" value="<%=CurrentDate%>" />
    <jsp:param name="CurrentTime" value="<%=CurrentTime%>" />
	<jsp:param name="parentids" value="<%=parentids%>" />
	<jsp:param name="meetingid" value="<%=meetingid%>" />
</jsp:include>
<jsp:include page="/docs/docs/DocUtil.jsp">
    <jsp:param name="seccategory" value="<%=seccategory%>" />
    <jsp:param name="docid" value="<%=docid%>" />
    <jsp:param name="maindoc" value="<%=maindoc%>" />
    <jsp:param name="ishistory" value="<%=ishistory%>" />
    <jsp:param name="doceditionid" value="<%=doceditionid%>" />
    <jsp:param name="olddocid" value="<%=olddocid%>" />
    <jsp:param name="isrequest" value="<%=isrequest%>" />
    <jsp:param name="desrequestid" value="<%=desrequestid%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="isSetShare" value="<%=isSetShare%>" />
    <jsp:param name="doc_topage" value="<%=doc_topage%>" />
    <jsp:param name="isfromext" value="0" />
</jsp:include>
<style>
	.x-ie-shadow{
		 background-color:#fff;
		*background-color:#777!important;
	}
</style>