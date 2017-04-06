<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.cowork.CoworkShareManager" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="iWebOfficeConf.jsp" %>
<%@ include file="PDF417ManagerConf.jsp" %>

<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" /> 
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OpenSendDoc" class="weaver.docs.senddoc.OpenSendDoc" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page"/>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="RequestDoc" class="weaver.workflow.request.RequestDoc" scope="page" />

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="RequestAnnexUpload" class="weaver.workflow.request.RequestAnnexUpload" scope="page" />
<jsp:useBean id="WorkflowBarCodeSetManager" class="weaver.workflow.workflow.WorkflowBarCodeSetManager" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<jsp:useBean id="BaseBeanOfDocDspExt" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="WTRequestUtil" class="weaver.worktask.worktask.WTRequestUtil" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<%//判断金格控件的版本	 2003还是2006
String canPostil = "";
if(isIWebOffice2006 == true){
	canPostil = ",0";
}

int languageId=user.getLanguage();

int docid = Util.getIntValue(request.getParameter("id"),0);
int meetingid = Util.getIntValue(request.getParameter("meetingid"),0);
int olddocid=Util.getIntValue(request.getParameter("olddocid"),0);
if(olddocid<1) olddocid=docid;    
//董平添加 修改BUG1483 原因:查看ID=0的文档，系统会将文档全部列出来
if (docid==0){
	out.println(SystemEnv.getHtmlLabelName(19711,languageId));
	return ;
}
String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //来源于流程建文挡
boolean isNoTurnWhenHasToPage=Util.null2String(request.getParameter("isNoTurnWhenHasToPage")).equals("true")?true:false;//是否有转向页面时不转向  默认为false：否   为“true”表示不转向
boolean  blnOsp = "true".equals(request.getParameter("blnOsp")) ;

String selectedpubmould = Util.null2String(request.getParameter("selectedpubmould")); //选择显示模版的ID

//user info
int userid=user.getUID();
String logintype = user.getLogintype();
String username=ResourceComInfo.getResourcename(""+userid);
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);
//判断新建的是不是个人文档
boolean isPersonalDoc = false ;
String from =  Util.null2String(request.getParameter("from"));
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);

boolean isFromAccessory="true".equals(request.getParameter("isFromAccessory"))?true:false;
int shareparentid= Util.getIntValue(request.getParameter("shareparentid"),0);

if ("personalDoc".equals(from)){
    isPersonalDoc = true ;
}
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl=temStr+mClientName;

int versionId = Util.getIntValue(request.getParameter("versionId"),0);
//取得文档数据
String sql1 = "";
if(versionId==0){
    sql1 = "select * from DocImageFile where docid="+docid+" and (isextfile <> '1' or isextfile is null) order by versionId desc";
}else{
    sql1 = "select * from DocImageFile where docid="+docid+" and versionId="+versionId;
}
RecordSet.executeSql(sql1) ;
RecordSet.next();
versionId = Util.getIntValue(RecordSet.getString("versionId"),0);
if(versionId==0){
	RecordSet.executeSql("select * from DocImageFile where docid="+docid+" order by versionId desc") ;
	if(RecordSet.next()){
		versionId = Util.getIntValue(RecordSet.getString("versionId"),0);
	}
}

String filetype=Util.null2String(""+RecordSet.getString("docfiletype"));
String imagefileName=Util.null2String(""+RecordSet.getString("imagefilename"));
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int imagefileId = Util.getIntValue(request.getParameter("imagefileId"),0);
//跨浏览器直接下载文件用imagefileIdNotIE
int imagefileIdNotIE = imagefileId;
if(imagefileIdNotIE==0){
	imagefileIdNotIE = Util.getIntValue(""+RecordSet.getString("imagefileId"),0);
}

//标识当前字段类型为附件上传类型
String isAppendTypeField = Util.null2String(request.getParameter("isAppendTypeField"));
//文档中心的是否打开附件控制*/
String isOpenFirstAss = Util.null2String(request.getParameter("isOpenFirstAss"));
//判断是否是PDF文档/
boolean isPDF = DocDsp.isPDF(docid,imagefileId,Util.getIntValue(isOpenFirstAss,1));
if(imagefileId==0&&Util.getIntValue(filetype,0) != 2) isPDF = false;
if(isPDF){
%>
		    <script language=javascript>
					location="DocDsp.jsp?id=<%=docid%>&imagefileId=<%=imagefileId%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>";
		    </script> 
<%
    return ;
}
if(filetype.equals("3")){
    filetype=".doc";
}else if(filetype.equals("4")){
    filetype=".xls";
}else if(filetype.equals("5")){
    filetype=".ppt";
}else if(filetype.equals("6")){
    filetype=".wps";
}else if(filetype.equals("7")){
    filetype=".docx";
}else if(filetype.equals("8")){
    filetype=".xlsx";
}else if(filetype.equals("9")){
    filetype=".pptx";
}else if(filetype.equals("10")){
    filetype=".et";
}else{
    filetype=".doc";
}

int messageid=Util.getIntValue(request.getParameter("messageid"),0);
String isrequest = Util.null2String(request.getParameter("isrequest"));

char flag=Util.getSeparator() ;
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
//int requestid=Util.getIntValue(request.getParameter("requestid"),0);

String requestname="";
int workflowid=0;
int formid=0;
int isbill = -1;
int billid=0;
int nodeid=0;
int currentnodeid=0;
String nodetype="";
String nodeName="";
String ifVersion="0";
boolean hasRightOfViewHisVersion=HrmUserVarify.checkUserRight("DocExt:ViewHisVersion", user);

int hasright=0;
String status="";
int creater=0;
int isremark=0;
int operatortype = 0;
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

DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();

String checkOutMessage=Util.null2String(request.getParameter("checkOutMessage"));  //已被检出提示信息



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
docsubject=Util.StringReplace(docsubject,"\"", "&quot;");
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
String canCopy=DocManager.getCanCopy();
String docno = DocManager.getDocno();
int replyid = 0 ;

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




String hasUsedTemplet=DocManager.getHasUsedTemplet();//是否已经套红
int canPrintedNum=DocManager.getCanPrintedNum();//可打印份数

if(docpublishtype.equals("2")){
    int tmppos = doccontent.indexOf("!@#$%^&*");
	if(tmppos!=-1) doccontent = doccontent.substring(tmppos+8,doccontent.length());
}

String docstatusname = DocComInfo.getStatusView(docid,user);

String tmppublishtype="";
if(docpublishtype.equals("2")) tmppublishtype=SystemEnv.getHtmlLabelName(227,user.getLanguage());
else if(docpublishtype.equals("3")) tmppublishtype=SystemEnv.getHtmlLabelName(229,user.getLanguage());
else tmppublishtype=SystemEnv.getHtmlLabelName(58,user.getLanguage());

//子目录信息
RecordSet.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
RecordSet.next();
String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),languageId);
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

String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),languageId);
int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),languageId);
String approvercanedit=Util.toScreen(RecordSet.getString("approvercanedit"),languageId);
int defaultDocLocked = Util.getIntValue(RecordSet.getString("defaultLockedDoc"),0);
String isSetShare=Util.null2String(""+RecordSet.getString("isSetShare"));
int relationable=Util.getIntValue(""+RecordSet.getString("relationable"),0);
String readCount = " ";
String topage= URLEncoder.encode("/docs/docs/DocDsp.jsp?id="+docid);

boolean canDownload = (Util.getIntValue(RecordSet.getString("nodownload"),0)==0)?true:false;
int categoryreadoptercanprint = Util.getIntValue(RecordSet.getString("readoptercanprint"),0);

String isOpenApproveWf=Util.null2String(RecordSet.getString("isOpenApproveWf"));

String readerCanViewHistoryEdition=Util.null2String(RecordSet.getString("readerCanViewHistoryEdition"));

int appointedWorkflowId = Util.getIntValue(RecordSet.getString("appointedWorkflowId"),0);

int maxOfficeDocFileSize = Util.getIntValue(RecordSet.getString("maxOfficeDocFileSize"),8);

int isAutoExtendInfo = Util.getIntValue(RecordSet.getString("isAutoExtendInfo"),0);

boolean isEditionOpen = SecCategoryComInfo.isEditionOpen(seccategory);

//打印申请
boolean canPrintApply=false;
String isagentOfprintApply="0";
String isPrintControl=Util.null2String(RecordSet.getString("isPrintControl"));
int printApplyWorkflowId = Util.getIntValue(RecordSet.getString("printApplyWorkflowId"),0);
		if(printApplyWorkflowId>0){

		    //判断是否有流程创建权限
			canPrintApply = shareManager.hasWfCreatePermission(user, printApplyWorkflowId);

            if(!canPrintApply){
				String begindate="";
				String begintime="";
				String enddate="";
				String endtime="";
				int beagenterid=0;
				RecordSet.executeSql("select distinct workflowid,beagenterid,begindate,begintime,enddate,endtime from workflow_agent where workflowid="+printApplyWorkflowId+" and agenttype>'0' and iscreateagenter=1 and agenterid="+userid);
				while(RecordSet.next()&&!canPrintApply){
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

					canPrintApply = shareManager.hasWfCreatePermission(beagenterid, printApplyWorkflowId);
					
					if(canPrintApply){
						isagentOfprintApply="1";
					}
				}
			}
		}

boolean canDoPrintByApply=false;
boolean canDoPrintByDocDetail=false;
boolean hasPrintNode=false;
boolean isPrintNode=false;

String printNodes="";
if(isPrintControl.equals("1")){
	//判断是否已经有申请成功的打印份数
	String canDoPrintByApplySb = " select 1   from workflow_requestbase a,Bill_DocPrintApply b  where a.requestId=b.requestid    and a.currentNodeType='3'    and b.resourceId="+userid+"   and b.relatedDocId="+docid+"   and printNum>hasPrintNum ";
	RecordSet.executeSql(canDoPrintByApplySb);
	if(RecordSet.next()){
		canDoPrintByApply=true;
	}

	//判断是否有默认的打印份数
	RecordSet.executeSql("select 1 from DocDetail where id="+docid+" and canPrintedNum>hasPrintedNum");
	if(RecordSet.next()){
		canDoPrintByDocDetail=true;
	}
}

boolean isUseTempletNode=false;//来自于流程创建文档时,当前节点是否为套红节点
boolean isSignatureNodes=false;//来自于流程创建文档时,当前节点是否为签章节点
int useTempletNode=0;
String isCompellentMark = "0";//是否必须显示痕迹
String isCancelCheck = "0";//是否取消审阅
String signatureNodes = "";
boolean isCurrentNode = false;
if(fromFlowDoc.equals("1")){
	nodeid=WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1));               //节点id
	RecordSet.executeSql("select workflowId,currentNodeId from workflow_requestbase where requestid="+requestid);
	if(RecordSet.next()){
		workflowid=RecordSet.getInt("workflowid");
		//nodeid=RecordSet.getInt("currentnodeid");
		currentnodeid=RecordSet.getInt("currentnodeid");
	}
	RecordSet.executeSql("select ifVersion from workflow_base where id="+workflowid);
	if(RecordSet.next()){
		ifVersion = Util.null2String(RecordSet.getString("ifVersion"));
	}
	RecordSet.executeSql("select nodeName from workflow_nodebase where id="+nodeid);
	if(RecordSet.next()){
		nodeName = URLEncoder.encode(Util.null2String(RecordSet.getString("nodeName")),"GBK");
	}
	//RecordSet.executeSql("select useTempletNode from workflow_createdoc  where workflowId="+workflowid);
	RecordSet.executeSql("select useTempletNode,printNodes, iscompellentmark, iscancelcheck,signatureNodes from workflow_createdoc  where workflowId="+workflowid);
	if(RecordSet.next()){
		useTempletNode=RecordSet.getInt("useTempletNode");
		printNodes=Util.null2String(RecordSet.getString("printNodes"));
		isCompellentMark = Util.null2String(RecordSet.getString("iscompellentmark"));
		isCancelCheck = Util.null2String(RecordSet.getString("iscancelcheck"));
		signatureNodes = Util.null2String(RecordSet.getString("signatureNodes"));
	}
	if("".equals(isCompellentMark)){
		isCompellentMark = "0";
	}
	if("".equals(isCancelCheck)){
		isCancelCheck = "0";
	}
	if(nodeid==useTempletNode&&nodeid>0&&nodeid==currentnodeid){
		isUseTempletNode=true;
	}

	if(!printNodes.equals("")){
		hasPrintNode=true;
	}
	if((","+printNodes+",").indexOf(","+nodeid+",")>=0&&nodeid>0&&nodeid==currentnodeid){
		isPrintNode=true;
	}
	if((","+signatureNodes+",").indexOf(","+nodeid+",")>=0&&nodeid>0&&nodeid==currentnodeid){
		isSignatureNodes=true;
	}
	if(nodeid==currentnodeid){
		isCurrentNode=true;
	}
}

/***************************取出文章被阅读的次数*********************************************************/
int readCount_int = 0 ;
String sql_readCount ="select sum(readCount) from docreadtag where (userid<>"+doccreaterid+" or usertype<>"+usertype+") and docid =" + docid ;
rs.execute(sql_readCount);
if(rs.next()) readCount_int = Util.getIntValue(rs.getString(1),0) ;


//end by mackjoe
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":("+SystemEnv.getHtmlLabelName(260,user.getLanguage())+" "+readCount_int +" "+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+ ")";
String needfav ="1";
String needhelp ="";
String doctitlename=docsubject + "("+SystemEnv.getHtmlLabelName(260,user.getLanguage())+" "+readCount_int +" "+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+ ")";
String webOfficeFileName=docsubject;
if (isFromAccessory){
    doctitlename=imagefileName;
    webOfficeFileName=imagefileName;
}

doctitlename=Util.stringReplace4DocDspExt(doctitlename);
webOfficeFileName=Util.stringReplace4DocDspExt(webOfficeFileName);

if(!isFromAccessory){
	
	String imageFileNameNoPostfix=webOfficeFileName;
	List postfixList=new ArrayList();
	postfixList.add(".doc");
	postfixList.add(".dot");
	postfixList.add(".docx");
	postfixList.add(".xls");	
	postfixList.add(".xlt");
	postfixList.add(".xlw");
	postfixList.add(".xla");
	postfixList.add(".xlsx");
	postfixList.add(".ppt");
	postfixList.add(".pptx");
	postfixList.add(".wps");
	postfixList.add(".pgf");		

	String tempPostfix=null;
	String postfix="";
	for(int i=0;i<postfixList.size();i++){
		tempPostfix=(String)postfixList.get(i)==null?"":(String)postfixList.get(i);			
	    if(imageFileNameNoPostfix.endsWith(tempPostfix)){
		    imageFileNameNoPostfix=imageFileNameNoPostfix.substring(0,imageFileNameNoPostfix.indexOf(tempPostfix));
			postfix=tempPostfix;
	    }
	}

	imageFileNameNoPostfix=Util.StringReplace(imageFileNameNoPostfix,".","．");
	webOfficeFileName=imageFileNameNoPostfix+postfix;
}

String doc_topage=Util.null2String((String)session.getAttribute("doc_topage"));
String topageFromOther=Util.null2String(request.getParameter("topage"));
if(!"".equals(checkOutMessage)){
	doc_topage="";
	session.removeAttribute("doc_topage");  
}

//从流程过来文档直接跳转
if(fromFlowDoc.equals("1")){
	//流程创建文档统一为不通过session里的doc_topage传值。
	session.removeAttribute("doc_topage");
	doc_topage="";
    if(!topageFromOther.equals("")&&!isNoTurnWhenHasToPage){

	    response.sendRedirect(topageFromOther+"&docfileid=1&docid="+docid); 
	    return ;
    }
}

//TD8562
//通过项目卡片或任务信息页面新建文档，提交时要弹出共享设置页面。
if (!"".equals(doc_topage)&&doc_topage.indexOf("ViewCoWork.jsp")==-1&&doc_topage.indexOf("coworkview.jsp")==-1&&doc_topage.indexOf("ViewProject.jsp")==-1&&doc_topage.indexOf("/proj/process/DocOperation.jsp")==-1){
    if(!topageFromOther.equals("")){
	    session.removeAttribute("doc_topage");  
	    response.sendRedirect(doc_topage+"&docfileid=1&docid="+docid); 
	    return ;
    }
}else{
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
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+olddocid,userInfo);

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
	if(readerCanViewHistoryEdition.equals("1")){
  	    if(canReader && !canEdit) canReader = true;
	} else {
	    if(canReader && !canEdit) canReader = false;
	}
}	
//编辑权限操作者可查看文档状态为：“审批”、“归档”、“待发布”或历史文档
if(canEdit && ((docstatus.equals("3") || docstatus.equals("5") || docstatus.equals("6") || docstatus.equals("7")) || ishistory==1)) {
    canReader = true;
}
//编辑权限操作者可编辑的文档状态为：“草稿”、“生效、正常”、“失效”,非历史文档
if(canEdit && (docstatus.equals("0") || docstatus.equals("4") || docstatus.equals("1") || docstatus.equals("2") || docstatus.equals("7")) && (ishistory!=1))
  canEdit = true;
else
  canEdit = false;
//可回复
if(docreplyable.equals("1") && (docstatus.equals("2") || docstatus.equals("1")))
  canReplay = true;
//可打印
if(canEdit||(categoryreadoptercanprint==1)||(categoryreadoptercanprint==2&&docreadoptercanprint==1))
    canPrint = true;
//启用打印控制，而文档已经没有可打印份数时不可打印
if(isPrintControl.equals("1")&&(!canDoPrintByDocDetail)){
	canPrint = false;
}

//启用打印控制或不启用打印控制，流程创建文档时当前节点为打印节点  则可打印
if(fromFlowDoc.equals("1")&&isPrintNode){
	canPrint = true;
}

//启用打印控制，流程创建文档时当前节点不为打印节点  则不可打印
if(isPrintControl.equals("1")&&fromFlowDoc.equals("1")&&hasPrintNode&&!isPrintNode){
	canPrint = false;
}

if(canDoPrintByApply){
    canPrint = true;
}
//可发布
if(HrmUserVarify.checkUserRight("DocEdit:Publish",user,docdepartmentid) && docstatus.equals("6") && (ishistory!=1))
  canPublish = true ;
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

//从流程过来的文档，并且当前用户处于流程当前操作者中。//可以查看
if(!canReader&&(isrequest.equals("1")||requestid>0)){
//    int userTypeForThisIf=0;
//    if("2".equals(""+user.getLogintype())){
//		userTypeForThisIf= 1;
//	}
//
//    String sqlSb = " select 1  from workflow_currentoperator t2,DocApproveWf t4  where t2.requestid=t4.requestid  and t2.requestid= "+requestid+"   and t4.docId="+olddocid+"   and t2.userid= "+userid+"  and t2.usertype= "+userTypeForThisIf+" union all  select 1  from workflow_currentoperator t2,bill_Approve t4  where t2.requestid=t4.requestid   and t2.requestid= "+requestid+" and t4.approveid= "+olddocid+" and t2.userid= "+userid+" and t2.usertype= "+userTypeForThisIf;
//	RecordSet.executeSql(sqlSb);
//    if(RecordSet.next()){
//		canReader=true;
//	}
    canReader=WFUrgerManager.OperHaveDocViewRight(requestid,userid,Util.getIntValue(logintype,1),""+docid);
}
//从计划任务处过来
String fromworktask = Util.getFileidIn(Util.null2String(request.getParameter("fromworktask")));
String operatorid = Util.getFileidIn(Util.null2String(request.getParameter("operatorid")));
if(!canReader&&"1".equals(fromworktask)) {
	canReader=WTRequestUtil.UrgerHaveWorktaskDocViewRight(requestid,userid, docid ,Util.getIntValue(operatorid,0));
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
/*
//工作微博点击查看文档
int blogDiscussid=Util.getIntValue(request.getParameter("blogDiscussid"),0);
if(!canReader&&blogDiscussid!=0){
	//工作微博记录id
	if(BlogDao.appViewRight("doc",""+userid,docid,blogDiscussid)){	
	      CoworkDAO.shareCoworkRelateddoc(Util.getIntValue(logintype),docid,userid);
	      canReader=true;
	}      
}
*/
//协作区点击查看文档
int isfromcowork=0;
int coworkid=Util.getIntValue(request.getParameter("coworkid"),0);
if(!canReader&&coworkid!=0){
	if(CoworkDAO.haveViewCoworkDocRight(""+userid,""+coworkid,""+docid)) {
	   CoworkDAO.shareCoworkRelateddoc(Util.getIntValue(logintype),docid,userid);
	   isfromcowork=1;
	   canReader=true;
	}
}

if(!canReader)  {
	if (!CoworkDAO.haveRightToViewDoc(Integer.toString(userid),Integer.toString(docid))&&noMeetingDocRight){
        if(!WFUrgerManager.OperHaveDocViewRight(requestid,desrequestid,userid,Util.getIntValue(logintype),""+olddocid) && !WFUrgerManager.UrgerHaveDocViewRight(requestid,userid,Util.getIntValue(logintype),""+docid) && !WFUrgerManager.getMonitorViewObjRight(requestid,userid,""+docid,"0")&& isfrommeeting==0 && !RequestAnnexUpload.HaveAnnexDocViewRight(requestid,userid,Util.getIntValue(logintype),docid)){
        if(doceditionid>-1&&ishistory==1){
			RecordSet.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " and ishistory=0 and id<>"+docid+"  order by docedition desc ");
			int newDocId=0;
			if(RecordSet.next()){
				newDocId = Util.getIntValue(RecordSet.getString("id"));
			}
	        if(newDocId!=docid&&newDocId>0){
	%>
		    <script language=javascript>
		        if(confirm("<%=SystemEnv.getHtmlLabelName(20300,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19986,user.getLanguage())%>")) {
					location="DocDsp.jsp?fromFlowDoc=<%=fromFlowDoc%>&from=<%=from%>&userCategory=<%=userCategory%>&id=<%=newDocId%>&olddocid=<%=olddocid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&blnOsp=<%=blnOsp%>&topage=<%=URLEncoder.encode(topageFromOther)%>&meetingid=<%=meetingid%>";
		        }else{
					location="/notice/noright.jsp";
				}
		    </script> 
	<%
			return;//TD10386 JS跳转需要加入return，下面的JAVA代码才不会执行
	        }else{
				//response.sendRedirect("/notice/noright.jsp") ;
%>
		    <script language=javascript>
					location="/notice/noright.jsp";
		    </script> 
<%
	            return ;
			}
		}else{
	        //response.sendRedirect("/notice/noright.jsp") ;
%>
		    <script language=javascript>
					location="/notice/noright.jsp";
		    </script> 
<%
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
//TD.5544 判断是否用附件打开，如果是，不计次数和不记日志
if(!isFromAccessory){
/**********************向阅读标记表中插入阅读记录，修改阅读次数(只有当浏览者不是创建者时)********************/
	if( userid != doccreaterid || !usertype.equals(logintype) ){
		rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype);  // 他人

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
}
//TD.5544 end
//TD 10368 End
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
    
/* added by wdl 2006.7.5 TD.4617 套用显示模板 */
boolean isApplyMould = false;
boolean blnRealViewLog=false;
//取得模版设置
int wordmouldid = 0;
String mouldtext = "";
List selectMouldList = new ArrayList();
int selectMouldType = 0;
int selectDefaultMould = 0;

if(SecCategoryDocPropertiesComInfo.getDocProperties(""+seccategory,"10")&&SecCategoryDocPropertiesComInfo.getVisible().equals("1")&&(!"1".equals(hasUsedTemplet))&&(!fromFlowDoc.equals("1"))){
	
	if(filetype.equals(".doc")||filetype.equals(".wps")){
		RecordSet.executeSql("select * from DocSecCategoryMould where secCategoryId = "+seccategory+" and mouldType in(3,7) order by id ");
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
				    wordmouldid = selectDefaultMould;
				}
		    } else {
		        wordmouldid = Util.getIntValue(selectedpubmould);
		    }
		} else {
		    if(Util.getIntValue(Util.null2String(selectedpubmould),0)<=0){
		    	if(selectedpubmouldid<=0){
		    	    if(selectMouldType>0)
		    	        wordmouldid = selectDefaultMould;
		    	} else {
		    	    wordmouldid = selectedpubmouldid;
		    	}
		    } else {
		        wordmouldid = Util.getIntValue(selectedpubmould);
		    }
		}
		
	}
}
if((wordmouldid<=0)&&(!fromFlowDoc.equals("1"))){
    wordmouldid = MouldManager.getDefaultWordMouldId();
}

String viewMouldIdAndSecCategoryId="";
int mouldSecCategoryId=0;

//以下情况同时满足，则显示模板取路径设置中的显示模板
//1、来源于流程建文挡
//2、文档没有套红过
//if(fromFlowDoc.equals("1")&&(!"1".equals(hasUsedTemplet))){
if(fromFlowDoc.equals("1") && isUseTempletNode){
	//wordmouldid=RequestDoc.getViewMouldIdForDocDspExt(requestid,docid);
	viewMouldIdAndSecCategoryId=RequestDoc.getViewMouldIdAndSecCategoryIdForDocDspExt(requestid,docid);
	int indexId=viewMouldIdAndSecCategoryId.indexOf("_");
	wordmouldid=Util.getIntValue(viewMouldIdAndSecCategoryId.substring(0,indexId),0);
	mouldSecCategoryId=Util.getIntValue(viewMouldIdAndSecCategoryId.substring(indexId+1),0);

}

if(wordmouldid!=0&&(filetype.equals(".doc")||filetype.equals(".wps"))&&(!"1".equals(hasUsedTemplet))){
	isApplyMould = true;
}

String owneridname=ResourceComInfo.getResourcename(ownerid+"");
int countNum = 0;
String docMouldName = "";
List countMouldList = new ArrayList();
if(fromFlowDoc.equals("1")){

	RecordSet.executeSql("SELECT docMould.ID,docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + mouldSecCategoryId);//获取模板的数量
	String wordmID = String.valueOf(wordmouldid);
	while(RecordSet.next()){
        String docMouldID = RecordSet.getString("ID");
		String mode_name = RecordSet.getString("mouldName");
        countMouldList.add(docMouldID);

		if(docMouldID.equals(wordmID)){
		   docMouldName = mode_name;
		}
	}
    countNum = countMouldList.size();
 }
String strSql="select catelogid from DocDummyDetail where docid="+docid;
rsDummyDoc.executeSql(strSql);
String dummyIds="";
while(rsDummyDoc.next()){
	dummyIds+=Util.null2String(rsDummyDoc.getString(1))+",";
}


boolean istoManagePage=false;
if(!onlyview){
    if (!fromFlowDoc.equals("1")) {
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
       }
       if(docreplyable.equals("1")&&(docstatus.equals("2")||docstatus.equals("1"))) { 
           replyid = docid; //replyid初始设为文档id
           if(isreply.equals("1")) replyid = replydocid; //如果是回复的文档
       }
       if((SecCategoryComInfo.getLogviewtype(seccategory)==1&&HrmUserVarify.checkUserRight("FileLogView:View", user))||(SecCategoryComInfo.getLogviewtype(seccategory)==0)){
           // 具有编辑权限的人都可以查看文档的查看日志
           if(canViewLog&&logintype.equals("1")){
          	 blnRealViewLog=true;
           }else if(canEdit&&logintype.equals("2")){}
          	 blnRealViewLog=true;
		    }
   }
   } else {
	   //boolean istoManagePage=false;
	   RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
	   if(RecordSet.next()){
	   	nodetype=Util.null2String(RecordSet.getString("currentnodetype"));
	   }
	   if(logintype.equals("1")) operatortype = 0;
	   if(logintype.equals("2")) operatortype = 1;

	   RecordSet.executeSql("select isremark from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+operatortype+" order by isremark");
	   while(RecordSet.next())	{
	       isremark = Util.getIntValue(RecordSet.getString("isremark"),-1) ;
	       if( isremark==1||isremark==5 || (isremark==0  && !nodetype.equals("3")) ) {
	         istoManagePage=true;
	         break;
	       }
	   }
   }
}

boolean cantop = false;
int istop = 0;
if(HrmUserVarify.checkUserRight("Document:Top", user)) {
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String createidsubcomid = ResourceComInfo.getSubCompanyID(""+doccreaterid);
	if(detachable==1) {
		ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Document:Top");
		if(subcompanylist.indexOf(createidsubcomid)!=-1) {
			cantop = true;	
		}
	} else {
		cantop = true;
	}
	if(docstatus.equals("3"))
	{
		cantop = false;
	}
	if(cantop) { }
	String sql = "select istop from docdetail d where d.id="+docid;
	rs.executeSql(sql);
	rs.next();
	//int 
	istop = rs.getInt(1);
	if(istop==1) { }
}

boolean isLocked=false;
if(!isUseTempletNode&&!isSignatureNodes&&(!canEdit&&defaultDocLocked==1)){
	isLocked=true;
}
String isUseBarCodeThisJsp="0";
if(fromFlowDoc.equals("1")){
    String isUseBarCode = Util.null2String(BaseBeanOfDocDspExt.getPropValue("weaver_barcode","ISUSEBARCODE"));
    if(isUseBarCode.equals("1")){
	    //判断是否启用二维条码
	    RecordSet.executeSql("select 1 from Workflow_BarCodeSet where workflowId="+workflowid+" and isUse='1'");

	    if(RecordSet.next()){
		    isUseBarCodeThisJsp="1";
	    }
    }
}
%>
<%
if("false".equals(isIE)){
	response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+imagefileIdNotIE+"&download=1");
	return;
}
if(!checkOutMessage.equals("")){
	%>
	<SCRIPT LANGUAGE="JavaScript">
	alert("<%=checkOutMessage%>");
	</SCRIPT>
	<%
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=GBK">
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type='text/javascript' src='/dwr/interface/DocDetailLogWrite.js'></script>

<script src="/js/prototype.js" type="text/javascript"></script>

<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/weaver-lang-tw-gbk.js'></script>
<%}%>

<%
List menuBars = new ArrayList();
List menuBarsForWf = new ArrayList();
List menuOtherBar = new ArrayList();

Map menuBarMap = new HashMap();
Map[] menuBarToolsMap = new HashMap[]{};

menuBars = getMenuBars(onlyview, fromFlowDoc, isPersonalDoc, isrequest, canEditHis, docstatus,
		 hasright, languageId, canEdit, canReader, canShare, canDel, docreplyable,
		OpenSendDoc, docid, cannewworkflow, canPublish, canInvalidate,
		 canArchive, canCancel, canReopen, canCheckOut, canCheckIn, canCheckInCompellably,
		 user, docdepartmentid, canPrintApply, canPrint, isPrintControl, isbill, formid,
		 docapprovable, isremark,SecCategoryComInfo, seccategory, canViewLog,
		 logintype, hasRightOfViewHisVersion, isCurrentNode, defaultDocLocked, filetype, canDownload,
		 nodetype, isreply, istoManagePage, isUseTempletNode, wordmouldid, mouldSecCategoryId,
		 isSignatureNodes, cantop, istop, accessorycount,countNum,hasUsedTemplet);

session.setAttribute("PDF417ManagerCopyRight",PDF417ManagerCopyRight);
session.setAttribute("docMouldName_"+wordmouldid,docMouldName);
%>

	<jsp:include page="/docs/docs/DocDspExtLoad.jsp" flush="true">
	    <jsp:param name="docid" value="<%=docid%>" />
	    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
	    <jsp:param name="isIWebOffice2006" value="<%=(isIWebOffice2006?1:0)%>" />
	    <jsp:param name="requestid" value="<%=requestid%>" />
	    <jsp:param name="ifVersion" value="<%=ifVersion%>" />
	    <jsp:param name="isCompellentMark" value="<%=isCompellentMark%>" />
	    <jsp:param name="canPostil" value="<%=canPostil%>" />
	    <jsp:param name="isFromAccessory" value="<%=isFromAccessory%>" />
	    <jsp:param name="isrequest" value="<%=isrequest%>" />
	    <jsp:param name="hasUsedTemplet" value="<%=hasUsedTemplet%>" />
	    <jsp:param name="isPrintControl" value="<%=isPrintControl%>" />
	    <jsp:param name="doccreaterid" value="<%=doccreaterid%>" />
	    <jsp:param name="userid" value="<%=userid%>" />
	    <jsp:param name="countNum" value="<%=countNum%>" />
	    <jsp:param name="isremark" value="<%=isremark%>" />
	    <jsp:param name="isUseTempletNode" value="<%=(isUseTempletNode?1:0)%>" />
	    <jsp:param name="wordmouldid" value="<%=wordmouldid%>" />
	    <jsp:param name="versionId" value="<%=versionId%>" />
	    <jsp:param name="isSignatureNodes" value="<%=(isSignatureNodes?1:0)%>" />
	    <jsp:param name="CurrentDate" value="<%=CurrentDate%>" />
	    <jsp:param name="CurrentTime" value="<%=CurrentTime%>" />
	    <jsp:param name="workflowid" value="<%=workflowid%>" />
	    <jsp:param name="PDF417ManagerCopyRight" value="<%=PDF417ManagerCopyRight%>" />
	    <jsp:param name="appointedWorkflowId" value="<%=appointedWorkflowId%>" />
	    <jsp:param name="logintype" value="<%=logintype%>" />
	    <jsp:param name="userSeclevel" value="<%=userSeclevel%>" />
	    <jsp:param name="userCategory" value="<%=userCategory%>" />
	    <jsp:param name="from" value="<%=from%>" />
	    <jsp:param name="topage" value="<%=topage%>" />
	    <jsp:param name="maxOfficeDocFileSize" value="<%=maxOfficeDocFileSize%>" />
	    <jsp:param name="isPersonalDoc" value="<%=(isPersonalDoc?1:0)%>" />
	    <jsp:param name="onlyview" value="<%=(onlyview?1:0)%>" />
	    <jsp:param name="canEdit" value="<%=(canEdit?1:0)%>" />
	    <jsp:param name="nodeName" value="<%=nodeName%>" />
	    <jsp:param name="istoManagePage" value="<%=(istoManagePage?1:0)%>" />
	    <jsp:param name="mouldSecCategoryId" value="<%=mouldSecCategoryId%>" />
	    <jsp:param name="cantop" value="<%=(cantop?1:0)%>" />
	    <jsp:param name="istop" value="<%=istop%>" />
	    <jsp:param name="canEditHis" value="<%=(canEditHis?1:0)%>" />
	    <jsp:param name="docstatus" value="<%=docstatus%>" />
	    <jsp:param name="hasright" value="<%=hasright%>" />
	    <jsp:param name="languageId" value="<%=languageId%>" />
	    <jsp:param name="canReader" value="<%=(canReader?1:0)%>" />
	    <jsp:param name="canShare" value="<%=(canShare?1:0)%>" />
	    <jsp:param name="canDel" value="<%=(canDel?1:0)%>" />
	    <jsp:param name="docreplyable" value="<%=docreplyable%>" />
	    <jsp:param name="cannewworkflow" value="<%=(cannewworkflow?1:0)%>" />
	    <jsp:param name="canPublish" value="<%=(canPublish?1:0)%>" />
	    <jsp:param name="canInvalidate" value="<%=(canInvalidate?1:0)%>" />
	    <jsp:param name="canArchive" value="<%=(canArchive?1:0)%>" />
	    <jsp:param name="canCancel" value="<%=(canCancel?1:0)%>" />
	    <jsp:param name="canReopen" value="<%=(canReopen?1:0)%>" />
	    <jsp:param name="canCheckOut" value="<%=(canCheckOut?1:0)%>" />
	    <jsp:param name="canCheckIn" value="<%=(canCheckIn?1:0)%>" />
	    <jsp:param name="canCheckInCompellably" value="<%=(canCheckInCompellably?1:0)%>" />
	    <jsp:param name="docdepartmentid" value="<%=docdepartmentid%>" />
	    <jsp:param name="canPrintApply" value="<%=(canPrintApply?1:0)%>" />
	    <jsp:param name="canPrint" value="<%=(canPrint?1:0)%>" />
	    <jsp:param name="isbill" value="<%=isbill%>" />
	    <jsp:param name="formid" value="<%=formid%>" />
	    <jsp:param name="docapprovable" value="<%=docapprovable%>" />
	    <jsp:param name="seccategory" value="<%=seccategory%>" />
	    <jsp:param name="canViewLog" value="<%=(canViewLog?1:0)%>" />
	    <jsp:param name="hasRightOfViewHisVersion" value="<%=(hasRightOfViewHisVersion?1:0)%>" />
	    <jsp:param name="isCurrentNode" value="<%=(isCurrentNode?1:0)%>" />
	    <jsp:param name="defaultDocLocked" value="<%=defaultDocLocked%>" />
	    <jsp:param name="filetype" value="<%=filetype%>" />
	    <jsp:param name="canDownload" value="<%=(canDownload?1:0)%>" />
	    <jsp:param name="nodetype" value="<%=nodetype%>" />
	    <jsp:param name="isreply" value="<%=isreply%>" />
	    <jsp:param name="accessorycount" value="<%=accessorycount%>" />
	    <jsp:param name="mServerUrl" value="<%=mServerUrl%>" />
	    <jsp:param name="isLocked" value="<%=(isLocked?1:0)%>" />
	    <jsp:param name="isCancelCheck" value="<%=isCancelCheck%>" />
	    <jsp:param name="isApplyMould" value="<%=(isApplyMould?1:0)%>" />
	    <jsp:param name="isUseBarCodeThisJsp" value="<%=isUseBarCodeThisJsp%>" />
	    <jsp:param name="readCountint" value="<%=readCount_int%>" />
	</jsp:include>

</head>

<body class="ext-ie ext-ie8 x-border-layout-ct" scroll="no" onunload="UnLoad()">    

<iframe id="DocCheckInOutUtilIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

	<form name=workflow method=post action="/workflow/request/RequestType.jsp">
        <input type=hidden name=topage value='<%=topage%>'>
        <input type=hidden name=docid value='<%=docid%>'>
    </form>
 
    <FORM id=docsharelog name=docsharelog action="DocShare.jsp" method=post  target="_blank">
    <input type=hidden name=docid value="<%=docid%>">
    <input type=hidden name=docsubject value="<%=docsubject%>">
    <input type=hidden name=doccreaterid value="<%=doccreaterid%>">
    <input type=hidden name=sqlwhere value="where docid=<%=docid%>">
    </form>

    <FORM id=weaver name=weaver action="UploadDoc.jsp?fromFlowDoc=<%=fromFlowDoc%>&workflowid=<%=workflowid%>" method=post>
<!--该参数必须作为Form的第一个参数,并且不能在其他地方调用，用于解决在IE6.0中输入·这个特殊符号存在的问题-->
<INPUT TYPE="hidden" id="docIdErrorError" NAME="docIdErrorError" value="">

<%@ include file="/systeminfo/DocTopTitle.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe id="ClearDocAccessoriesTraceIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

    <input type=hidden name=operation>
    <input type=hidden name=versionId value="<%=versionId%>">
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
<table style="display:none" id="customerTable">
		<tr id="customerTR">
			<td id="customerTD">
			</td>
		</tr>
	</table>
	<input type=hidden name=selectedpubmouldid value="<%=wordmouldid%>">
	<input type=hidden name=assetid value="<%=assetid%>">
	<input type=hidden name=crmid value="<%=crmid%>">
	<input type=hidden name=itemid value="<%=itemid%>">
	<input type=hidden name=projectid value="<%=projectid%>">
	<input type=hidden name=financeid value="<%=financeid%>">
	<input type=hidden name=doccreaterid value="<%=doccreaterid%>">
	<input type=hidden name=docCreaterType value="<%=docCreaterType%>">
	<input type="hidden" name="dummycata" value="<%=dummyIds%>">

	<input type=hidden name=keyword value="<%=keyword%>">
	<input type=hidden name=doccode value="<%=docCode%>">
	
    <input type=hidden name=topage value='<%=topageFromOther%>'>

    <input type=hidden name="requestid" value=<%=requestid%>>
    <input type=hidden name="workflowid" value=<%=workflowid%>>
	<input type=hidden name=hasUsedTemplet value="<%=hasUsedTemplet%>">
	<input type=hidden name=signatureCount value="0">
    <input type=hidden name=isFromAccessory value='<%=isFromAccessory?1:0%>'>

    <%if(isrequest.equals("1")&&(hasright==1||isremark==1)){%>
        <input type=hidden name="isremark" >
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
    
    <input type="hidden" name="hrmresid" value="<%=hrmresid%>">
	<input type="hidden" name="invalidationdate" value="<%=invalidationdate%>">
	<input type="hidden" name="docmodule" value="<%=wordmouldid%>">
    <textarea name=doccontent style="display:none;width:100%;"><%=doccontent%></textarea>

<div style="position: absolute; left: 0; top: 0; width:100%;">

<div id="divContentTab" style="display:none;width:100%;">
       
	<%-- 文档标题 start --%>
	<div id="divDocTile" style="width:100%;<% if(("1").equals(fromFlowDoc)){ %>display: none;<% } %>">
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
       
	<%-- iWebOffice编辑控件 start --%>
	<div id="divContent" style="width:100%;overflow:hidden;">
		<table cellpadding="0" cellspacing="0" style="width:100%;height:100%;">
		<%if(isUseBarCodeThisJsp.equals("1")){%>
			<tr>
				<td bgcolor=menu id="PDF417ManagerTd">
					<div style="display: none;">
						<OBJECT id="PDF417Manager"  classid="<%=PDF417ManagerClassId%>"   codebase="<%=PDF417ManagerClientName%>"></OBJECT>
					</div>
				</td>
			</tr>
		<%}%>
			<tr>
				<td bgcolor=menu id="SignatureAPI">
					<%if(isSignatureNodes){%>
					<OBJECT id=SignatureAPI classid="clsid:79F9A6F8-7DBE-4098-A040-E6E0C3CF2001"  codebase="iSignatureAPI.ocx#version=5,0,2,0" width=0 height=0 align=center hspace=0 vspace=0></OBJECT>
					<%}%>
				</td>
			</tr>
			<tr height='100%'>
				<td bgcolor=menu>
					<div id="objectDiv">
						<div>
						<OBJECT id="WebOffice" name="WebOffice" classid="<%=mClassId%>" style="POSITION:absolute;width:0;height:0;top:-23;" codebase="<%=mClientUrl%>" >
						</OBJECT>
						</div>
						<span id=StatusBar style="display:none">&nbsp;</span>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<%-- iWebOffice编辑控件 end --%>
       
	<%-- 工具栏 start --%>
	<DIV id="divTools" style="width:100%;" class="<% if(("1").equals(fromFlowDoc)){ %>x-panel-footer<% } else { %>x-tab-panel-bbar<% } %>">
	<DIV id=toolbarmenudiv class="<% if(("1").equals(fromFlowDoc)){ %>x-panel-fbar x-panel-btns-center<% } else { %>x-toolbar<% } %> x-small-editor x-toolbar-layout-ct">
		<TABLE class="x-toolbar-ct" style="WIDTH: auto;<% if(("1").equals(fromFlowDoc)){ %>margin-top: 5px;<%} %>" cellSpacing=0>
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
       
<div id="divPropTabCollapsed" style="display:none;width: 100%;overflow:hidden;">
<% if(("1").equals(fromFlowDoc)){ %>
	<DIV style="background-color: #eeeeee;width: 100%;height:5px; margin-top: 5px;">
		<div id=divPropTileIcon onclick="onExpandOrCollapse();" style="text-align:center;cursor: pointer;"><img src="/js/extjs/resources/images/default/layout/mini-top.gif"></div>
	</DIV>
<% } else { %>
	<DIV style="background-color: #eeeeee;border: solid 1px #e0e0e0;width: 100%;height:26px; margin: 3px;text-align: right;">
	<TABLE style="margin-top: 3px;cursor:pointer;"><TBODY><TR>
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
<% } %>
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
		<DIV style="WIDTH: 100%; HEIGHT: 195px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<DIV style="WIDTH: 100%" id=DocPropAdd class=" x-panel x-panel-noborder">
		<DIV class=x-panel-bwrap>
		<DIV style="WIDTH: 100%; HEIGHT: 195px; OVERFLOW: auto;" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
			<div id="divProp" style="display:block">
				<TABLE class=ViewForm width=100%>
				  <COLGROUP>
				  <COL width="15%">
				  <COL width="35%">
				  <COL width="15%">
				  <COL width="35%">
				  </COLGROUP>
				  <TBODY>
			
				<%-- 文档属性 start --%>
				<TR>
					<TD class=Line colSpan=4></TD>
				</TR>
				<jsp:include page="/docs/docs/DocDspExtAttribute.jsp" flush="true">
					<jsp:param name="seccategory" value="<%=seccategory%>" />
					<jsp:param name="docsubject" value="<%=docsubject%>" />
					<jsp:param name="languageId" value="<%=languageId%>" />
					<jsp:param name="isPersonalDoc" value="<%=isPersonalDoc%>" />
					<jsp:param name="publishable" value="<%=publishable%>" />
					<jsp:param name="docid" value="<%=docid%>" />
					<jsp:param name="tmppublishtype" value="<%=tmppublishtype%>" />
					<jsp:param name="docstatusname" value="<%=docstatusname%>" />
					<jsp:param name="wordmouldid" value="<%=wordmouldid%>" />
					<jsp:param name="canPublish" value="<%=canPublish%>" />
					<jsp:param name="selectMouldType" value="<%=selectMouldType%>" />
					<jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
					<jsp:param name="filetype" value="<%=filetype%>" />
					<jsp:param name="dummyIds" value="<%=dummyIds%>" />
				</jsp:include>
				<%-- 文档属性 end --%>
			
				<%-- 类型 start --%>
				<jsp:include page="/docs/docs/DocDspExtType.jsp" flush="true">
					<jsp:param name="seccategory" value="<%=seccategory%>" />
					<jsp:param name="hrmresid" value="<%=hrmresid%>" />
					<jsp:param name="assetid" value="<%=assetid%>" />
					<jsp:param name="crmid" value="<%=crmid%>" />
					<jsp:param name="itemid" value="<%=itemid%>" />
					<jsp:param name="projectid" value="<%=projectid%>" />
					<jsp:param name="financeid" value="<%=financeid%>" />
				</jsp:include>
				<%-- 类型 end --%>
			
				</TBODY>
				</TABLE>
			</div>

		</DIV></DIV></DIV></DIV>
	</div>
	<!-- 文档属性栏 end -->

	<!-- 文档附件栏 start -->
	<div id="divAcc" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 195px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
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
		<DIV style="WIDTH: 100%; HEIGHT: 195px;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
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
		<DIV style="WIDTH: 100%; HEIGHT: 195px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
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
		<DIV style="WIDTH: 100%; HEIGHT: 195px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
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
		<DIV style="WIDTH: 100%; HEIGHT: 195px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
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
		<DIV style="WIDTH: 100%; HEIGHT: 195px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
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
	
	<% if(false){ %>
	<!-- 相关资源栏 start -->
	<div id="divRelationResource" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 195px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
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
		
		<% if(false){ %>
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

</FORM>

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
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="from" value="<%=from%>" />
    <jsp:param name="userCategory" value="<%=userCategory%>" />
    <jsp:param name="blnOsp" value="<%=blnOsp%>" />
    <jsp:param name="isfromcowork" value="<%=isfromcowork%>" />
    <jsp:param name="topageFromOther" value="<%=topageFromOther%>" />
    <jsp:param name="meetingid" value="<%=meetingid%>" />
    <jsp:param name="isSetShare" value="<%=isSetShare%>" />
    <jsp:param name="doc_topage" value="<%=doc_topage%>" />
    <jsp:param name="isfromext" value="0" />
    <jsp:param name="topage" value="<%=URLEncoder.encode(topageFromOther)%>" />
    <jsp:param name="isNoTurnWhenHasToPage" value="<%=isNoTurnWhenHasToPage%>" />		
    <jsp:param name="isAppendTypeField" value="<%=isAppendTypeField%>" />		
</jsp:include>

</body>
</html>

<jsp:include page="/docs/docs/DocComponents.jsp">
	<jsp:param value="<%=user.getLanguage()%>" name="language"/>
	<jsp:param value="getBase" name="operation"/>
</jsp:include>

<SCRIPT LANGUAGE="JavaScript">
	var isFromWf=<%=("1").equals(fromFlowDoc)%>;
	var isFromWfTH = <%=isApplyMould&&isUseTempletNode&&isremark==0%>
	var isFromWfSN = <%=isSignatureNodes%>;
	var docid="<%=docid%>";
	var seccategory="<%=seccategory%>";	
	var parentids="<%=parentids%>";
	var docTitle="<%=Util.encodeJS(docsubject)%>";
	var isReply="<%=isreply.equals("1")%>";
	var doceditionid="<%=doceditionid%>";
	var readerCanViewHistoryEdition="<%=readerCanViewHistoryEdition%>";
	var canEditHis="<%=canEditHis%>";

	var showType="view";
	var coworkid="<%=coworkid%>";
	var meetingid="<%=meetingid%>";
	
	var canShare=<%=canShare%>;
	var canEdit=<%=canEdit%>;
	var canDownload=<%=canDownload%>;//canEdit
	var canViewLog=<%=blnRealViewLog%>;
	var canDocMark=<%=DocMark.isAllowMark(""+seccategory)%>;
	var canReplay=<%=canReplay%>
	var readCount_int=<%=readCount_int%>	
	var maxUploadImageSize="<%=DocUtil.getMaxUploadImageSize(seccategory)%>";
	var relationable=false;
	var pagename="docdspext";	
	var requestid="<%=requestid%>";
	function adjustContentHeight(type){
		var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
		try{
			var propTabHeight = 250;
			if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none") propTabHeight = (isFromWf)?10:30;
			
			var pageHeight=document.body.clientHeight;
			var pageWidth=document.body.clientWidth;
			
			document.getElementById("divContentTab").style.height = pageHeight - propTabHeight;

			var divContentHeight=pageHeight-propTabHeight-65;
			if(isFromWf) divContentHeight += 25;

			var divContentWidth=pageWidth;
			if(divContentHeight!=null && divContentHeight>0){
				document.getElementById("divContent").style.height=divContentHeight;
				document.getElementById("divContent").style.width=divContentWidth;
				document.getElementById("WebOffice").style.height=divContentHeight + 23;
				document.getElementById("WebOffice").style.width=divContentWidth;
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
		} catch(e){	}
	}
	var isPDF=0;
	var canEditPDF=0;
	var accessorycount=<%=accessorycount%>;
	var isEditionOpen=<%=isEditionOpen%>;
	var message21658 = "<%=SystemEnv.getHtmlLabelName(21658,languageId)%>";
	var message21700 = "<%=SystemEnv.getHtmlLabelName(21700,languageId)%>";
	var message21701 = "<%=SystemEnv.getHtmlLabelName(21701,languageId)%>";
	var message24355 = "<%=SystemEnv.getHtmlLabelName(24355,languageId)%>";
	var isAutoExtendInfo=<%=isAutoExtendInfo%>;

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
		<% if(false){ %>
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
		<% if(false){ %>
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
		<% if(false){ %>
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
				document.getElementById("divContentTab").style.display='block';
				document.getElementById("divPropTab").style.display = "none";
				document.getElementById("divPropTabCollapsed").style.display = "block";

				onActiveTab("divProp");
				
				document.getElementById('rightMenu').style.visibility="hidden";
				document.getElementById("divMenu").style.display='';	
			} catch(e){}

			adjustContentHeight("load");
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
						onActiveTab("divAcc");
						onExpandOrCollapse(true);
					}
				},500);
		  	}
		}   
	);
</SCRIPT>
<script type="text/javascript" src="/js/DocDspExt.js"></script>
<jsp:include page="/docs/docs/DocDspExtScript.jsp">
    <jsp:param name="docid" value="<%=docid%>" />
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="isIWebOffice2006" value="<%=isIWebOffice2006%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="ifVersion" value="<%=ifVersion%>" />
    <jsp:param name="isCompellentMark" value="<%=isCompellentMark%>" />
    <jsp:param name="canPostil" value="<%=canPostil%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="isFromAccessory" value="<%=isFromAccessory%>" />
    <jsp:param name="topageFromOther" value="<%=topageFromOther%>" />
    <jsp:param name="isrequest" value="<%=isrequest%>" />
    <jsp:param name="meetingid" value="<%=meetingid%>" />
    <jsp:param name="hasUsedTemplet" value="<%=hasUsedTemplet%>" />
    <jsp:param name="isPrintControl" value="<%=isPrintControl%>" />
    <jsp:param name="doccreaterid" value="<%=doccreaterid%>" />
    <jsp:param name="userid" value="<%=userid%>" />
    <jsp:param name="hasPrintNode" value="<%=hasPrintNode%>" />
    <jsp:param name="isPrintNode" value="<%=isPrintNode%>" />
    <jsp:param name="printApplyWorkflowId" value="<%=printApplyWorkflowId%>" />
    <jsp:param name="isagentOfprintApply" value="<%=isagentOfprintApply%>" />
    <jsp:param name="username" value="<%=username%>" />
    <jsp:param name="countNum" value="<%=countNum%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
    <jsp:param name="isUseTempletNode" value="<%=(isUseTempletNode?1:0)%>" />
    <jsp:param name="wordmouldid" value="<%=wordmouldid%>" />
    <jsp:param name="versionId" value="<%=versionId%>" />
    <jsp:param name="isSignatureNodes" value="<%=isSignatureNodes%>" />
    <jsp:param name="CurrentDate" value="<%=CurrentDate%>" />
    <jsp:param name="CurrentTime" value="<%=CurrentTime%>" />
    <jsp:param name="replyid" value="<%=replyid%>" />
    <jsp:param name="parentids" value="<%=parentids%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="PDF417ManagerCopyRight" value="<%=PDF417ManagerCopyRight%>" />
	<jsp:param name="canPrint" value="<%=(canPrint?1:0)%>" />
</jsp:include>

<%!
private List getMenuBars(
		boolean onlyview,String fromFlowDoc,boolean isPersonalDoc,String isrequest,boolean canEditHis,String docstatus,
		int hasright,int languageId,boolean canEdit,boolean canReader,boolean canShare,boolean canDel,String docreplyable,
		weaver.docs.senddoc.OpenSendDoc OpenSendDoc,int docid,boolean cannewworkflow,boolean canPublish,boolean canInvalidate,
		boolean canArchive,boolean canCancel,boolean canReopen,boolean canCheckOut,boolean canCheckIn,boolean canCheckInCompellably,
		User user,int docdepartmentid,boolean canPrintApply,boolean canPrint,String isPrintControl,int isbill,int formid,
		String docapprovable,int isremark,weaver.docs.category.SecCategoryComInfo secCategoryComInfo,int seccategory,boolean canViewLog,
		String logintype,boolean hasRightOfViewHisVersion,boolean isCurrentNode,int defaultDocLocked,String filetype,boolean canDownload,
		String nodetype,String isreply,boolean istoManagePage,boolean isUseTempletNode,int wordmouldid,int mouldSecCategoryId,
		boolean isSignatureNodes,boolean cantop,int istop,int accessorycount,int countNum,String hasUsedTemplet
) {
		List menuBars = new ArrayList();
		List menuBarsForWf = new ArrayList();
		List menuOtherBar = new ArrayList();

		Map menuBarMap = new HashMap();
		Map[] menuBarToolsMap = new HashMap[] {};

		if (!onlyview) {
			if (!fromFlowDoc.equals("1")) {
				if (!isPersonalDoc) {
					if (isrequest.equals("1")) { //从工作流进入的文档
						//// 如果从工作流进入，文档审批流程的当前操作者在文档不为正常和归档的情况下可以修改，其它流程的在文档为非审批正常或者退回状态下可以修改
						//if (canEditHis && ((!docstatus.equals("2") && !docstatus.equals("5") && hasright == 1) || ((docstatus.equals("1") || docstatus.equals("4")) && hasright == 0))) {
						//如果从工作流进入，文档审批流程的当前操作者在文档不为归档的情况下可以修改，其他操作者在文档为草稿、正常或者退回状态下可以修改。
						if(canEditHis && ((!docstatus.equals("5") && hasright == 1) ||  ((docstatus.equals("0") || docstatus.equals("2") || docstatus.equals("1") || docstatus.equals("4")||Util.getIntValue(docstatus,0)<0) && hasright == 0)) ) {
							menuBarMap = new HashMap();
							menuBarMap.put("id", "btn_save");
							menuBarMap.put("text", SystemEnv.getHtmlLabelName(19714, languageId));
							menuBarMap.put("iconCls", "btn_save");
							menuBarMap.put("handler", "webOfficeMenuClick(1,'');");
							menuBars.add(menuBarMap);
						}
						// 如果是转发，有批注按钮

					}
					// 从非工作流进入的文档
					else if (canEdit) {
						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(93, languageId));
						menuBarMap.put("iconCls", "btn_edit");
						menuBarMap.put("handler", "webOfficeMenuClick(7,'');");
						menuBars.add(menuBarMap);

						if (docstatus.equals("0") || Util.getIntValue(docstatus, 0) <= 0) {

							menuBarMap = new HashMap();
							menuBarMap.put("id", "btn_save");
							menuBarMap.put("text", SystemEnv.getHtmlLabelName(615, languageId));
							menuBarMap.put("iconCls", "btn_save");
							menuBarMap.put("handler", "onSave();");
							menuBars.add(menuBarMap);

						}
					}
					// 草稿时编辑提交
					else if (canReader) {
						if (docstatus.equals("0") || Util.getIntValue(docstatus, 0) <= 0) {

							menuBarMap = new HashMap();
							menuBarMap.put("id", "btn_save");
							menuBarMap.put("text", SystemEnv.getHtmlLabelName(615, languageId));
							menuBarMap.put("iconCls", "btn_save");
							menuBarMap.put("handler", "onSave();");
							menuBars.add(menuBarMap);

						}
					}

					// 具有编辑权限的人,对文档可以修改共享的, 有共享按钮
					if (canShare) {
						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(119, languageId));
						menuBarMap.put("iconCls", "btn_share");
						menuBarMap.put("handler", "webOfficeMenuClick(8,'');");
						menuBars.add(menuBarMap);

					}

					// 文档本人在文档非归档,非审批后正常,非打开状态的时候可以删除文档
					if (canDel) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(91, languageId));
						menuBarMap.put("iconCls", "btn_remove");
						menuBarMap.put("handler", "webOfficeMenuClick(9,'');");
						menuBars.add(menuBarMap);
					}

					// 具有编辑权限的人对审批后正常的文档可以重新打开
					if (canEdit && docstatus.equals("10")) {
						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(244, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(10,'');");
						menuBars.add(menuBarMap);
					}

					//文档回复， 如果是可以回复的文档且是正常的文档， 可以回复
					if (docreplyable.equals("1") && (docstatus.equals("2") || docstatus.equals("1"))) {
						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(18540, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(11,'');");
						menuBars.add(menuBarMap);

					}

					// 如果可以对其它系统发送该文档,可以发送这个文档
					if (OpenSendDoc.inSendDoc("" + docid)) {
						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(18540, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(12,'');");
						menuBars.add(menuBarMap);

					}

					// 如果文档不在打开状态,可以新建工作流
					if (!docstatus.equals("3") && cannewworkflow) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(1239, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(13,'');");
						menuOtherBar.add(menuBarMap);
					}

					menuBarMap = new HashMap();
					menuBarMap.put("text", SystemEnv.getHtmlLabelName(19759, languageId));
					menuBarMap.put("iconCls", "btn_add");
					menuBarMap.put("handler", "webOfficeMenuClick(45,'');");
					menuOtherBar.add(menuBarMap);

					menuBarMap = new HashMap();
					menuBarMap.put("text", SystemEnv.getHtmlLabelName(15295, languageId));
					menuBarMap.put("iconCls", "btn_add");
					menuBarMap.put("handler", "webOfficeMenuClick(14,'');");
					menuOtherBar.add(menuBarMap);

					// 具有文档管理员权限的人可以对待发布文档进行发布
					if (canPublish) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(114, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(15,'');");
						menuOtherBar.add(menuBarMap);

					}

					// 具有编辑或文档管理员权限的人可以对生效/正常文档进行失效操作
					if (canInvalidate) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(15750, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(16,'');");
						menuOtherBar.add(menuBarMap);

					}

					// 具有文档管理员权限的人可以对生效/正常文档进行归档操作
					if (canArchive) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(251, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(17,'');");
						menuOtherBar.add(menuBarMap);

					}

					// 具有文档管理员权限的人可以对生效/正常文档进行作废操作
					// 具有文档管理员权限的人可以对失效文档进行作废操作
					// 具有文档管理员权限的人可以对归档文档进行作废操作
					if (canCancel) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(15358, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(18,'');");
						menuOtherBar.add(menuBarMap);

					}

					// 具有文档管理员权限的人可以对归档文档进行重新打开操作
					// 具有文档管理员权限的人可以对作废文档进行重新打开操作
					if (canReopen) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(244, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(19,'');");
						menuOtherBar.add(menuBarMap);

					}

					//文档未签出时,编辑权限的用户可手动进行文档签出操作
					if (canCheckOut) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(19692, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(25,'');");
						menuOtherBar.add(menuBarMap);

					}

					//文档签出，且签出人为当前用户，则可进行文档签入操作
					if (canCheckIn) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(19693, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(26,'');");
						menuBars.add(menuBarMap);

					}

					//文档签出，且签出人不为当前用户，当前用户具有文档管理员或目录管理员权限，则可进行强制签入操作
					if (canCheckInCompellably) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(19688, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(27,'');");
						menuOtherBar.add(menuBarMap);

					}

					// 具有文档管理员权限的人可以对正常文档进行归档
					if (HrmUserVarify.checkUserRight("DocEdit:Reload", user, docdepartmentid) && docstatus.equals("5")) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(256, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(30,'');");
						menuOtherBar.add(menuBarMap);

					}
					if (canPrintApply) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(21530, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(48,'');");
						menuOtherBar.add(menuBarMap);

					}
					if (canPrint) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(257, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(47,'');");
						menuOtherBar.add(menuBarMap);

					}
					if (isPrintControl.equals("1")) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(21533, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(49,'');");
						menuOtherBar.add(menuBarMap);

					}
					// 从审批工作流进入的, 或者具有编辑权限并且文档有审批的，都有审批意见按钮
					if (isbill == 1 && formid == 28) {
						if ((canEdit && docapprovable.equals("1")) || isremark == 1 || hasright == 1) {

							menuBarMap = new HashMap();
							menuBarMap.put("text", SystemEnv.getHtmlLabelName(1008, languageId));
							menuBarMap.put("iconCls", "btn_add");
							menuBarMap.put("handler", "webOfficeMenuClick(31,'');");
							menuOtherBar.add(menuBarMap);

						}
					}
					//TD12005			    if((SecCategoryComInfo.getLogviewtype(seccategory)==1&&user.getLoginid().equalsIgnoreCase("sysadmin"))||(SecCategoryComInfo.getLogviewtype(seccategory)==0)){
					//当文档目录设定为"按文档日志权限查看"时，对于有文档查看权限的人也能查看日志(TD12005)
					if ((secCategoryComInfo.getLogviewtype(seccategory) == 1 && HrmUserVarify.checkUserRight("FileLogView:View", user)) || (secCategoryComInfo.getLogviewtype(seccategory) == 0)) {
						// 具有编辑权限的人都可以查看文档的查看日志
						if (canViewLog && logintype.equals("1")) {

							menuBarMap = new HashMap();
							menuBarMap.put("text", SystemEnv.getHtmlLabelName(83, languageId));
							menuBarMap.put("iconCls", "btn_log");
							menuBarMap.put("handler", "webOfficeMenuClick(32,'');");
							menuBars.add(menuBarMap);

						} else if (canEdit && logintype.equals("2")) {

							menuBarMap = new HashMap();
							menuBarMap.put("text", SystemEnv.getHtmlLabelName(83, languageId));
							menuBarMap.put("iconCls", "btn_log");
							menuBarMap.put("handler", "webOfficeMenuClick(33,'');");
							menuBars.add(menuBarMap);

						}
					}

					if (hasRightOfViewHisVersion || canEditHis) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(16384, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(35,'');");
						menuOtherBar.add(menuBarMap);

					}
					if (canEdit || (defaultDocLocked != 1 && !docstatus.equals("5")) || hasRightOfViewHisVersion) {
						if (filetype.equals(".doc")) {

							menuBarMap = new HashMap();
							menuBarMap.put("text", SystemEnv.getHtmlLabelName(16385, languageId));
							menuBarMap.put("iconCls", "btn_add");
							menuBarMap.put("handler", "webOfficeMenuClick(36,'');");
							menuOtherBar.add(menuBarMap);

						}
					}
					if (canDownload) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(16382, languageId));
						menuBarMap.put("iconCls", "btn_add");
						menuBarMap.put("handler", "webOfficeMenuClick(37,'');");
						menuOtherBar.add(menuBarMap);

					}
				} else {

					menuBarMap = new HashMap();
					menuBarMap.put("text", SystemEnv.getHtmlLabelName(93, languageId));
					menuBarMap.put("iconCls", "btn_edit");
					menuBarMap.put("handler", "webOfficeMenuClick(39,'');");
					menuBars.add(menuBarMap);

				}

				menuBarMap = new HashMap();
				menuBarMap.put("text", SystemEnv.getHtmlLabelName(1290, languageId));
				menuBarMap.put("iconCls", "btn_back");
				menuBarMap.put("handler", "webOfficeMenuClick(43,'');");
				menuBars.add(menuBarMap);

				menuBarMap = new HashMap();
				menuBarMap.put("text", SystemEnv.getHtmlLabelName(354, languageId));
				menuBarMap.put("iconCls", "btn_refresh");
				menuBarMap.put("handler", "webOfficeMenuClick(42,'');");
				menuBars.add(menuBarMap);

			} else {

				if (istoManagePage) {

					if (isUseTempletNode) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(21659, languageId));
						menuBarMap.put("id", "thSure_id");
						menuBarMap.put("iconCls", "");
						menuBarMap.put("handler", "saveTHTemplate(" + wordmouldid + ");");
						menuBarsForWf.add(menuBarMap);

					if(countNum > 1 && isUseTempletNode && isremark==0){
						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(21660, languageId));
						menuBarMap.put("id", "thModeS_id");
						menuBarMap.put("iconCls", "");
						menuBarMap.put("handler", "selectTemplate(" + mouldSecCategoryId + "," + wordmouldid + ");");
						menuBarsForWf.add(menuBarMap);
					}

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(22983, languageId));
						menuBarMap.put("id", "thCancel_id");
						menuBarMap.put("iconCls", "");
						menuBarMap.put("handler", "useTempletCancel();");
						menuBarsForWf.add(menuBarMap);

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(86, languageId));
						menuBarMap.put("id", "thSaveAgain_id");
						menuBarMap.put("iconCls", "");
						menuBarMap.put("handler", "saveTHTemplateNoConfirm(" + wordmouldid + ");");
						menuBarsForWf.add(menuBarMap);

					}
				}
				if (isSignatureNodes) {/*是否显示盖章*/

					menuBarMap = new HashMap();
					menuBarMap.put("text", SystemEnv.getHtmlLabelName(21650, languageId));
					menuBarMap.put("id", "signature_id1");
					menuBarMap.put("iconCls", "btn_signature");
					menuBarMap.put("handler", "CreateSignature(0);");
					menuBarsForWf.add(menuBarMap);

					menuBarMap = new HashMap();
					menuBarMap.put("text", SystemEnv.getHtmlLabelName(21656, languageId));
					menuBarMap.put("id", "signature_id2");
					menuBarMap.put("iconCls", "btn_signature1");
					menuBarMap.put("handler", "saveIsignatureFun();");
					menuBarsForWf.add(menuBarMap);

				}

				if (canPrint) {

					menuBarMap = new HashMap();
					menuBarMap.put("text", SystemEnv.getHtmlLabelName(257, languageId));
					menuBarMap.put("id", "thprint_id1");
					menuBarMap.put("iconCls", "btn_add");
					menuBarMap.put("handler", "webOfficeMenuClick(47,'');");
					menuBarsForWf.add(menuBarMap);

				}
				if (canEdit || (defaultDocLocked != 1 && !docstatus.equals("5")) || hasRightOfViewHisVersion) {
					if (filetype.equals(".doc") || filetype.equals(".wps")) {

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(19713, languageId));
						menuBarMap.put("id", "hide_id");
						menuBarMap.put("iconCls", "btn_ShowOrHidden");
						menuBarMap.put("handler", "showMarkFunc();");
						menuBarsForWf.add(menuBarMap);

						menuBarMap = new HashMap();
						menuBarMap.put("text", SystemEnv.getHtmlLabelName(19712, languageId));
						menuBarMap.put("id", "dispaly_id");
						menuBarMap.put("iconCls", "btn_displayh");
						menuBarMap.put("handler", "hideMarkFunc();");
						menuBarsForWf.add(menuBarMap);

					}

				}
				RecordSet rs = new RecordSet();
				rs.executeProc("DocImageFile_SelectByDocid", "" + docid);
				if (rs.next()) {

					menuBarMap = new HashMap();
					menuBarMap.put("text", SystemEnv.getHtmlLabelName(58, languageId) + SystemEnv.getHtmlLabelName(156, languageId) + "(" + accessorycount + ")");
					menuBarMap.put("id", "flowDocAcc_id");
					menuBarMap.put("iconCls", "btn_acc");
					menuBarMap.put("handler", "doImgAcc();");
					menuBarsForWf.add(menuBarMap);

				}

			}
		}
        if(menuOtherBar.size()>0){
		menuBarMap = new HashMap();
		menuBars.add(menuBarMap);

		menuBarMap = new HashMap();
		menuBarMap.put("text", SystemEnv.getHtmlLabelName(21739, user.getLanguage()));
		menuBarMap.put("iconCls", "btn_list");
		menuBarMap.put("id", "menuTypeChanger");
		menuBarToolsMap = new HashMap[menuOtherBar.size()];
		for (int tmpindex = 0; tmpindex < menuOtherBar.size(); tmpindex++) menuBarToolsMap[tmpindex] = (Map) menuOtherBar.get(tmpindex);
		menuBarMap.put("menu", menuBarToolsMap);
		menuBars.add(menuBarMap);
        }

		menuBarMap = new HashMap();
		menuBars.add(menuBarMap);

		if (HrmUserVarify.checkUserRight("Document:Top", user)) {
			if (cantop) {

				menuBarMap = new HashMap();
				menuBarMap.put("text", SystemEnv.getHtmlLabelName(23784, languageId));
				menuBarMap.put("iconCls", "btn_up");
				menuBarMap.put("handler", "DocToTop(" + docid + ",1);");
				menuBars.add(menuBarMap);

				menuBarMap = new HashMap();
				menuBars.add(menuBarMap);

			}
			if (istop == 1) {

				menuBarMap = new HashMap();
				menuBarMap.put("text", SystemEnv.getHtmlLabelName(24675, languageId));
				menuBarMap.put("iconCls", "btn_down");
				menuBarMap.put("handler", "DocToTop(" + docid + ",2);");
				menuBars.add(menuBarMap);

				menuBarMap = new HashMap();
				menuBars.add(menuBarMap);

			}
		}

		menuBarMap = new HashMap();
		menuBarMap.put("text", "<span id=spanProp>" + SystemEnv.getHtmlLabelName(21689, user.getLanguage()) + "</span>");
		menuBarMap.put("iconCls", "btn_ShowOrHidden");
		menuBarMap.put("id", "btn_ShowOrHidden");
		menuBarMap.put("handler", "onExpandOrCollapse();");
		menuBars.add(menuBarMap);

		if (("1").equals(fromFlowDoc))
			menuBars = menuBarsForWf;

		return menuBars;
	}
%>