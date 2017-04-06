<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.docs.docs.CustomFieldManager,
                 java.net.*" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>

<%@ page import="weaver.conn.RecordSet"%>

 <%@ include file="/systeminfo/init.jsp" %> 
 <%@ include file="iWebOfficeConf.jsp" %> 

<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocTypeManager" class="weaver.docs.type.DocTypeManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>

<jsp:useBean id="SecCategoryMouldComInfo" class="weaver.docs.category.SecCategoryMouldComInfo" scope="page"/>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 

<jsp:useBean id="RequestDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script src="/js/prototype.js" type="text/javascript"></script>

<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/weaver-lang-tw-gbk.js'></script>
<%}%>

<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
String needfav ="1";
String needhelp ="";
//判断金阁控件的版本	 2003还是2006
String canPostil = "";
if(isIWebOffice2006 == true){
	canPostil = ",1";
}
int languageId=user.getLanguage();

//判断新建的是不是个人文档
boolean isPersonalDoc = false ;
String from =  Util.null2String(request.getParameter("from"));
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
//System.out.println("userCategory is "+userCategory);
int shareparentid= Util.getIntValue(request.getParameter("shareparentid"),0);

if ("personalDoc".equals(from)){
    isPersonalDoc = true ;
}

String  docsubject=Util.null2String(request.getParameter("docsubject"));
String docCode = "";//DocCoder.getDocCoder(secid+"");

//编辑：王金永
String  docType=Util.null2String(request.getParameter("docType"));
if(docType.equals("")){
    docType=".doc";
}
//out.println(docType);

String  docId=Util.null2String(request.getParameter("docId"));
String  docTemplate=Util.null2String(request.getParameter("docTemplate"));
String  docEditType=Util.null2String(request.getParameter("docEditType"));
if(docEditType.equals("")){
    docEditType = "1";
}


String  prjid = Util.null2String(request.getParameter("prjid"));
String  crmid=Util.null2String(request.getParameter("crmid"));
String  hrmid=Util.null2String(request.getParameter("hrmid"));
String  showsubmit=Util.null2String(request.getParameter("showsubmit"));
String  topage=Util.null2String(request.getParameter("topage"));
String  tmptopage=URLEncoder.encode(topage);
topage=URLDecoder.decode(tmptopage);

String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl=temStr+mClientName;

if(!showsubmit.equals("0"))  showsubmit="1";

String usertype = user.getLogintype();
int ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
int docdepartmentid=user.getUserDepartment() ;
String needinputitems = "";
if(!isPersonalDoc){
    needinputitems += "maincatgory,subcategory,seccategory";
}
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int workflowid=-1;
AclManager am = new AclManager();

int secid=Util.getIntValue(Util.null2String(request.getParameter("secid")), -1);
int subid=Util.getIntValue(Util.null2String(request.getParameter("subid")), -1);
int mainid=Util.getIntValue(Util.null2String(request.getParameter("mainid")), -1);
String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //来源于流程建文挡
if (fromFlowDoc.equals("1")) {
	docsubject=Util.null2String((String)session.getAttribute(""+user.getUID()+"_"+requestid+"docsubject"));
	docCode=Util.null2String((String)session.getAttribute(""+user.getUID()+"_"+requestid+"docCode"));
	if(docsubject.equals("")){
		docsubject=Util.null2String((String)session.getAttribute("docsubject"+user.getUID()));
	}
	if(docCode.equals("")){
		docCode=Util.null2String((String)session.getAttribute("docCode"+user.getUID()));
	}
	//session.removeAttribute(""+user.getUID()+"_"+requestid+"docsubject");
	//session.removeAttribute(""+user.getUID()+"_"+requestid+"docCode");
	//session.removeAttribute("docsubject"+user.getUID());
	//session.removeAttribute("docCode"+user.getUID());
}

if(docsubject!=null&&!docsubject.trim().equals("")){
	docsubject=Util.StringReplace(docsubject,"\"","&quot;");
}


int nodeid=-1;
int maxUploadImageSize = DocUtil.getMaxUploadImageSize(secid);
if(isPersonalDoc) {
    int haspost= Util.getIntValue(request.getParameter("haspost"),0);
    
    int cannew = 0;
    if(userCategory<0 && haspost != 1){
        String sqlcheck = "select distinct t1.id  from HrmResource t1 ,  DocShare as t2,  HrmRoleMembers as t3 ";
        sqlcheck +="where  ( (t2.foralluser=1 )  ";
        sqlcheck +="or ( t2.userid= t1.id ) ";
        sqlcheck +="or (t2.departmentid=t1.departmentid )  ";
        sqlcheck +="or (t2.subcompanyid=t1.subcompanyid1 ) ";
        sqlcheck +="or ( t3.resourceid=t1.id and t3.roleid=t2.roleid ) ";
        sqlcheck +=" )  and t1.id <> 0 and t2.docid = ";
        sqlcheck += ((-1)*shareparentid);
        sqlcheck += " and t2.sharelevel=2 and  t1.id = "+user.getUID();
        if(shareparentid!=0){
            RecordSet.executeSql(sqlcheck);
            //out.print(sqlcheck);
            if(RecordSet.next())
                cannew = 1;
        }
    } else
        cannew = 1;
    
    if(cannew != 1){
        response.sendRedirect("/notice/noright.jsp") ;
        return;
    }
    secid = 0 ;
    subid = 0 ;
    mainid = 0 ;
}



if (secid == -1) {
    CategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), AclManager.OPERATION_CREATEDOC);
    if (subid != -1) {
        CommonCategory cc = tree.findCategory(subid, AclManager.CATEGORYTYPE_SUB);
        if (cc != null) {
            CommonCategory secCategory = null;
            while (secCategory == null && cc.children.size() > 0) {
                for (int i=0;i<cc.children.size();i++) {
                    if (cc.getChild(i).type == AclManager.CATEGORYTYPE_SEC) {
                        secCategory = cc.getChild(i);
                        break;
                    }
                }
                if (secCategory == null && cc.children.size() > 0) {
                    cc = cc.getChild(0);
                }
            }
            if (secCategory != null) {
                secid = secCategory.id;
            }
        }
    } else if (mainid != -1) {
        CommonCategory cc = tree.findCategory(subid, AclManager.CATEGORYTYPE_MAIN);
        if (cc != null) {
            CommonCategory secCategory = null;
            while (secCategory == null && cc.children.size() > 0) {
                for (int i=0;i<cc.children.size();i++) {
                    if (cc.getChild(i).type == AclManager.CATEGORYTYPE_SEC) {
                        secCategory = cc.getChild(i);
                        break;
                    }
                }
                if (secCategory == null && cc.children.size() > 0) {
                    cc = cc.getChild(0);
                }
            }
            if (secCategory != null) {
                secid = secCategory.id;
            }
        }
    }
}
if (secid != -1) {
    subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secid), -1);
    mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid), -1);
}

String path = "";
if (secid != -1) {
    path = "/"+CategoryUtil.getCategoryPath(secid);
}


String docmodule=Util.null2String(request.getParameter("docmodule"));


boolean isTemporaryDoc = false;
String invalidationdate = Util.null2String(request.getParameter("invalidationdate"));
if(invalidationdate!=null&&!"".equals(invalidationdate))
    isTemporaryDoc = true;
    


String categoryname="";
String subcategoryid="";
String docmouldid="";
String publishable="";
String replyable="";
String shareable="";

String readoptercanprint="";
String editionisopen = "";
String norepeatedname = "";
String iscontroledbydir = "";
String puboperation = "";


String needapprovecheck="";

char flag=2;
String tempsubcategoryid="";

int maxOfficeDocFileSize=8;

if(secid > 0){
    RecordSet.executeProc("Doc_SecCategory_SelectByID",secid+"");
    RecordSet.next();
    categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),languageId);
    subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
    docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
    publishable=Util.null2String(""+RecordSet.getString("publishable"));
    replyable=Util.null2String(""+RecordSet.getString("replyable"));
    shareable=Util.null2String(""+RecordSet.getString("shareable"));
    
	readoptercanprint = Util.null2String(""+RecordSet.getString("readoptercanprint"));
    
	maxOfficeDocFileSize = Util.getIntValue(RecordSet.getString("maxOfficeDocFileSize"),8);

}



// check user right

int haschecked =0;
int trueright = 0;

/* 谭小鹏 2003-05-29日 修改 将原来的权限判断改为新的方法，下面注释中的是原代码 */
if (am.hasPermission(secid, AclManager.CATEGORYTYPE_SEC, user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), AclManager.OPERATION_CREATEDOC)) {
    trueright = 1;
}
if (secid < 0) {
    trueright = 1;
}


RecordSet.executeSql("select workflowId,currentNodeId from workflow_requestbase where requestid="+requestid);
if(RecordSet.next()){
	workflowid=RecordSet.getInt("workflowid");
	nodeid=RecordSet.getInt("currentnodeid");
}

if(fromFlowDoc.equals("1")&&trueright!=1&&!isPersonalDoc) {
	int tempSecId=-1;

    ArrayList docCategoryList=RequestDoc.getSelectItemValue(""+workflowid,""+requestid);	
    if(docCategoryList!=null&&docCategoryList.size()>0){
		tempSecId=Util.getIntValue((String)docCategoryList.get(2),-1);
    }else{
        ArrayList docFieldList=RequestDoc.getDocFiled(""+workflowid);
		if (docFieldList!=null&&docFieldList.size()>0){
			ArrayList tempArrayList=Util.TokenizerString(""+docFieldList.get(2),"||");
			if (tempArrayList!=null&&tempArrayList.size()>0){
                 tempSecId=Util.getIntValue((String)tempArrayList.get(2),-1);
			}
		}
	}

	if(tempSecId==secid){
		//判断当前用户是否为流程当前节点的操作者
	    RecordSet.executeSql("select 1 from workflow_currentoperator where userId="+user.getUID()+" and requestId="+requestid+" and nodeId="+nodeid);
		if(RecordSet.next()){
		    trueright=1;
		}
	}
}

// 	Check Right
if(trueright!=1&&!isPersonalDoc) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}

// add by liuyu for dsp moulde text
String mouldtext = "" ;
int mouldType= 0;
if(!docmodule.equals("")) {
    MouldManager.setId(Util.getIntValue(docmodule));
    MouldManager.getMouldInfoById();
    mouldtext=MouldManager.getMouldText();
    mouldType=MouldManager.getMouldType();
    MouldManager.closeStatement();
    if(mouldType==1){
        String queryStr = request.getQueryString();
        String toQueryStr = queryStr;
        toQueryStr = Util.replace(toQueryStr,"&docmodule=([^&])*","",0);
        out.println("queryStr:"+queryStr);
        response.sendRedirect("DocAdd.jsp?"+toQueryStr);
        return;
    }else if(mouldType==2){
        docType = ".doc";
    }else if(mouldType==3){
        docType = ".xls";
    }else if(mouldType==4){
        docType = ".wps";
    }else if(mouldType==5){
        docType = ".et";
    }
    MouldManager.closeStatement();
}


List selectMouldList = new ArrayList();
int selectMouldType = 0;
int selectDefaultMould = 0;

if(docType.equals(".doc")||docType.equals(".xls")||docType.equals(".wps")||docType.equals(".et")){
	int  tempMouldType=4;//4：WORD编辑模版
	if(docType.equals(".xls")){
		tempMouldType=6;//6：EXCEL编辑模版
	}else if(docType.equals(".wps")){
		tempMouldType=8;//8：WPS文字编辑模版
	}else if(docType.equals(".et")){
		tempMouldType=10;//8：WPS表格编辑模版
	}

	RecordSet.executeSql("select * from DocSecCategoryMould where secCategoryId = "+secid+" and mouldType="+tempMouldType+" order by id ");
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
			    if(selectMouldType==0){
			        selectMouldType = 1;
				    selectDefaultMould = Util.getIntValue(moduleid);
			    }
				selectMouldList.add(moduleid);
		    } else {
		        if(Util.getIntValue(modulebind,1)!=3)
					selectMouldList.add(moduleid);
		    }
		}
	}
	if(selectMouldType>0&&Util.getIntValue(docmodule,0)==0){
        String queryStr = Util.null2String(request.getQueryString());
        String toQueryStr = queryStr;
        if(toQueryStr.indexOf("docmodule=")>-1)
            toQueryStr = Util.replace(toQueryStr,"docmodule=([^&])*","docmodule="+selectDefaultMould,0);
        else
            toQueryStr = toQueryStr + "&docmodule=" + selectDefaultMould;
        toQueryStr = Util.replace(toQueryStr,"docsubject=([^&])*","",0);
        %>
		<script type="text/javascript">
		location = "<%="DocAddExt.jsp?"+toQueryStr%>&docsubject=<%=docsubject%>";
		</script>
<%
        //response.sendRedirect("DocAddExt.jsp?"+toQueryStr);
        return;
	}
}
%>
<script language="javascript" for=WebOffice event="OnMenuClick(vIndex,vCaption)">
    // 1.保存 2.存为草稿 3.预览 4.页眉 5.打开本地文件 6.存为本地文件 7.签名印章  9.显示隐藏 10.刷新窗口
    if (vIndex==1) onSave();
	else if (vIndex==2)  onDraft();
    else if (vIndex==3)  onPreview();
    else if (vIndex==4)  showHeader();
    else if (vIndex==5)  WebOpenLocal();
    else if (vIndex==6)  WebSaveLocal2();
    else if (vIndex==7)  WebOpenSignature();
    else if (vIndex==9)  onExpandOrCollapse();
    else if (vIndex==10) location.reload();
</script>

<script language=javascript>

    function StatusMsg(mString){
    	try{
    		// Ext.get('loading').fadeIn();
    		 document.getElementById('loading-msg').innerHTML = mString;
    		 //Ext.get('loading').fadeOut();
    	}catch(e){}
    }

    function WebSaveLocal2(){
    try{
		
		var hisFileName=weaver.WebOffice.FileName;
		
			var tempFileName=document.all("docsubject").value;

			tempFileName=tempFileName.replace(/\\/g,'＼');
			tempFileName=tempFileName.replace(/\//g,'／');
			tempFileName=tempFileName.replace(/:/g,'：');
			tempFileName=tempFileName.replace(/\*/g,'×');
			tempFileName=tempFileName.replace(/\?/g,'？');
			tempFileName=tempFileName.replace(/\"/g,'“');
			tempFileName=tempFileName.replace(/</g,'＜');
			tempFileName=tempFileName.replace(/>/g,'＞');
			tempFileName=tempFileName.replace(/\|/g,'｜');

			var tempfiletype = tempFileName.substring(tempFileName.lastIndexOf("."),tempFileName.length);
			if(tempfiletype!=null&&(tempfiletype==".doc"||tempfiletype==".xls"||tempfiletype==".ppt"||tempfiletype==".wps"||tempfiletype==".docx"||tempfiletype==".xlsx"||tempfiletype==".pptx"||tempfiletype==".et")){
				tempFileName=tempFileName.substring(0,tempFileName.lastIndexOf("."));
				tempFileName=tempFileName.replace(/\./g,'．');
				tempFileName=tempFileName+tempfiletype;
			} else 

			tempFileName=tempFileName.replace(/\./g,'．');
			weaver.WebOffice.FileName=tempFileName;
		
		weaver.WebOffice.WebSaveLocal();
		StatusMsg(weaver.WebOffice.Status);
		
		weaver.WebOffice.FileName=hisFileName;


    }catch(e){}
    }

    function WebOpenLocal(){
    try{
    weaver.WebOffice.WebOpenLocal();
    StatusMsg(weaver.WebOffice.Status);
    }catch(e){
    }

    }

function changeFileType(xFileType){
	if(xFileType==".docx"||xFileType==".dot"){
		xFileType=".doc";
	}else if(xFileType==".xlsx"||xFileType==".xlt"||xFileType==".xlw"||xFileType==".xla"){
		xFileType=".xls";
	}else if(xFileType==".pptx"){
		xFileType=".ppt";
	}
	return xFileType;
}

/*
Index:
wdPropertyAppName		:9
wdPropertyAuthor		:3
wdPropertyBytes			:22
wdPropertyCategory		:18
wdPropertyCharacters		:16
wdPropertyCharsWSpaces		:30
wdPropertyComments		:5
wdPropertyCompany		:21
wdPropertyFormat		:19
wdPropertyHiddenSlides		:27
wdPropertyHyperlinkBase		:29
wdPropertyKeywords		:4
wdPropertyLastAuthor		:7
wdPropertyLines			:23
wdPropertyManager		:20
wdPropertyMMClips 		:28
wdPropertyNotes			:26
wdPropertyPages			:14
wdPropertyParas			:24
wdPropertyRevision		:8
wdPropertySecurity		:17
wdPropertySlides		:25
wdPropertySubject		:2
wdPropertyTemplate		:6
wdPropertyTimeCreated		:11
wdPropertyTimeLastPrinted	:10
wdPropertyTimeLastSaved		:12
wdPropertyTitle			:1
wdPropertyVBATotalEdit		:13
wdPropertyWords			:15
*/
//获取或设置文档摘要信息
function WebShowDocumentProperties(Index){
    var propertiesValue="";
    try{
	    var properties = weaver.WebOffice.WebObject.BuiltInDocumentProperties;
	    propertiesValue=properties.Item(Index).Value;
    }catch(e){
    }
    return propertiesValue;
}

function getFileSize(){
	var fileSize=new String((1.0*WebShowDocumentProperties(22))/(1024*1024));

    var len = fileSize.length;

	var afterDotCount=0;
	var hasDot=false;
    var newIntValue="";
	var newDecValue="";

    for(i = 0; i < len; i++){
		if(fileSize.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				newIntValue+=fileSize.charAt(i);
			}else{
				afterDotCount++;
				if(afterDotCount<=2){
					newDecValue+=fileSize.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}

	return newValue;
}

    function SaveDocument(){

    var fileSize=getFileSize();

	if(parseFloat(fileSize)>parseFloat(<%=maxOfficeDocFileSize%>)){
		alert("<%=SystemEnv.getHtmlLabelName(24028,languageId)%>"+fileSize+"M，<%=SystemEnv.getHtmlLabelName(24029,languageId)%><%=maxOfficeDocFileSize%>M！");
		return false;
	}

    showPrompt("<%=SystemEnv.getHtmlLabelName(18886,languageId)%>");

    var tempFileName=document.getElementById("docsubject").value;
	tempFileName=tempFileName.replace(/\\/g,'＼');
	tempFileName=tempFileName.replace(/\//g,'／');
	tempFileName=tempFileName.replace(/:/g,'：');
	tempFileName=tempFileName.replace(/\*/g,'×');
	tempFileName=tempFileName.replace(/\?/g,'？');
	tempFileName=tempFileName.replace(/\"/g,'“');
	tempFileName=tempFileName.replace(/</g,'＜');
	tempFileName=tempFileName.replace(/>/g,'＞');
	tempFileName=tempFileName.replace(/\|/g,'｜');
	tempFileName=tempFileName.replace(/\./g,'．');
	tempFileName = tempFileName+'<%=docType%>';
    document.getElementById("WebOffice").FileName=tempFileName;

    weaver.WebOffice.FileType=changeFileType(weaver.WebOffice.FileType);

<%if(isIWebOffice2003&&docType.equals(".doc")){%>
	try{
		var fileSize=0;
		document.getElementById("WebOffice").WebObject.SaveAs();
		fileSize=document.getElementById("WebOffice").WebObject.BuiltinDocumentProperties(22);
		document.getElementById("WebOffice").WebSetMsgByName("NEWFS",fileSize);
	}catch(e){
	}
<%}%>

    if (!weaver.WebOffice.WebSave(<%=isNoComment%>)){
    StatusMsg(weaver.WebOffice.Status);
    alert("<%=SystemEnv.getHtmlLabelName(19007,languageId)%>");


    hiddenPrompt();


    return false;
    }else{
    StatusMsg(weaver.WebOffice.Status);

    weaver.docId.value=weaver.WebOffice.WebGetMsgByName("CREATEID");



    hiddenPrompt();


    return true;
    }
    }
	
	var menubar=[];
	var menubarForwf=[];
    function onLoad(){
    
        <%if(!isIE.equals("true")){%>
		    if(!checkIWebPlugin()){
		        window.location.href="/wui/common/page/sysRemind.jsp?labelid=5";
		    };
        <%}%>

        showPrompt("<%=SystemEnv.getHtmlLabelName(18974,languageId)%>");


        //weaver.WebOffice.WebUrl="<%=mServerUrl%>"
        document.body.scroll = "no";
        document.title="<%=SystemEnv.getHtmlLabelName(1986,languageId)%>";
        window.status="<%=SystemEnv.getHtmlLabelName(1986,languageId)%>";
        //确定菜单类型 
        var menuType=[];
        if ("<%=docType%>"!=".htm"){
        	menuType.push({ text: 'Html&nbsp;<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>',  iconCls: 'btn_html',
        		handler:function(){onChangeDocType('DocAdd.jsp?from=<%=from%>&userCategory=<%=userCategory%>','.htm')}
        	});
        }
        if ("<%=docType%>"!=".doc"){
        	menuType.push({ text: 'Word&nbsp;<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>',  iconCls: 'btn_word',
        	    handler:function(){onChangeDocType('DocAddExt.jsp?from=<%=from%>&userCategory=<%=userCategory%>','.doc')}
			});
        }
        if ("<%=docType%>"!=".xls"){
        	menuType.push({ text: 'Excel&nbsp;<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>',  iconCls:'btn_excel',
				handler:function(){onChangeDocType('DocAddExt.jsp?from=<%=from%>&userCategory=<%=userCategory%>','.xls')}
			});
        }
        
        if ("<%=docType%>"!=".wps"){
        	menuType.push({ text: 'Wps&nbsp;<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>',  iconCls:'btn_wps',
				handler:function(){onChangeDocType('DocAddExt.jsp?from=<%=from%>&userCategory=<%=userCategory%>','.wps')}
			});
        }
<%if("1".equals(isUseET)){%>
        if ("<%=docType%>"!=".et"){
        	menuType.push({ text: 'Et&nbsp;<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>',  iconCls:'btn_et',
				handler:function(){onChangeDocType('DocAddExt.jsp?from=<%=from%>&userCategory=<%=userCategory%>','.et')}
			});
        }
<%}%>		
        try{
             if ("<%=docType%>"==".ppt"){
                  weaver.WebOffice.ProgName="powerpoint.show";
             }

             //添加菜单
             
            
              
            weaver.WebOffice.ShowMenu="1";
            weaver.WebOffice.AppendMenu("1","<%=SystemEnv.getHtmlLabelName(19718,languageId)%>(&S)");
            menubar.push({text:'<%=SystemEnv.getHtmlLabelName(19718,languageId)%>',iconCls:'btn_save',handler:function(){onSave()}});
            menubarForwf.push({text:'<%=SystemEnv.getHtmlLabelName(86,languageId)%>',iconCls:'btn_save',handler:function(){onSave()}});
            
            if (!<%=isPersonalDoc%>){
                weaver.WebOffice.AppendMenu("2","<%=SystemEnv.getHtmlLabelName(19719,languageId)%>(&D)");
                menubar.push({text:'<%=SystemEnv.getHtmlLabelName(19719,languageId)%>',iconCls:'btn_draft',handler:function(){onDraft()}});
                weaver.WebOffice.AppendMenu("3","<%=SystemEnv.getHtmlLabelName(221,languageId)%>");
                menubar.push({text:'<%=SystemEnv.getHtmlLabelName(221,languageId)%>',iconCls:'btn_preview',handler:function(){onPreview()}});
            }

            //weaver.WebOffice.AppendMenu("4","页眉(&H)");
            
            
            
            weaver.WebOffice.AppendMenu("5","<%=SystemEnv.getHtmlLabelName(16381,languageId)%>");
            menubar.push({text:'<%=SystemEnv.getHtmlLabelName(16381,languageId)%>',iconCls:'btn_add',handler:function(){WebOpenLocal()}});
            
            weaver.WebOffice.AppendMenu("6","<%=SystemEnv.getHtmlLabelName(16382,languageId)%>");
            menubar.push({text:'<%=SystemEnv.getHtmlLabelName(16382,languageId)%>',iconCls:'btn_add',handler:function(){WebSaveLocal()}});
            
            weaver.WebOffice.AppendMenu("7","<%=SystemEnv.getHtmlLabelName(16383,languageId)%>(&G)");
            menubar.push({text:'<%=SystemEnv.getHtmlLabelName(16383,languageId)%>',iconCls:'btn_add',handler:function(){WebOpenSignature()}});
            
            weaver.WebOffice.AppendMenu("8","-");
            weaver.WebOffice.AppendMenu("9","<%=SystemEnv.getHtmlLabelName(19652,languageId)%>");
            
            
            weaver.WebOffice.AppendMenu("10","<%=SystemEnv.getHtmlLabelName(354,languageId)%>");
            menubar.push({text:'<%=SystemEnv.getHtmlLabelName(354,languageId)%>',iconCls:'btn_refresh',handler:function(){location.reload();}});
       
            menubar.push('-');
            menubar.push({text:'<%=SystemEnv.getHtmlLabelName(21622,user.getLanguage())%>',iconCls: 'btn_list',id:'menuTypeChanger', menu: menuType  });
            
            menubar.push('-');
            menubar.push({text:'<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>',iconCls:'btn_ShowOrHidden',handler:function(){onExpandOrCollapse()}});
            
            weaver.WebOffice.AppendMenu("11","-");

            weaver.WebOffice.WebUrl="<%=mServerUrl%>";
            weaver.WebOffice.RecordID="-1";
            weaver.WebOffice.Template="<%=(mouldType==1?"":docmodule)%>";
            weaver.WebOffice.FileName="";
            weaver.WebOffice.FileType="<%=docType%>";
			weaver.WebOffice.EditType="1<%=canPostil%>";
			<%if(isIWebOffice2006 == true){%>
			  weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
			<%}%>

            weaver.WebOffice.MaxFileSize = <%=maxOfficeDocFileSize%> * 1024; 
            weaver.WebOffice.UserName="<%=user.getUsername()%>";
            weaver.WebOffice.WebSetMsgByName("USERID","<%=user.getUID()%>");
            weaver.WebOffice.WebOpen();  	//打开该文档
            weaver.WebOffice.WebObject.Saved=true;//added by cyril on 2008-06-10 检测文档是否被修改用
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.ShowType="1";  //文档显示方式  1:表示文字批注  2:表示手写批注  0:表示文档核稿
//iWebOffice2006 特有内容结束
<%}%>             
weaver.WebOffice.DisableMenu("打印预览");
weaver.WebOffice.WebToolsEnable('Standard',109,false);
            weaver.WebOffice.WebToolsVisible("iSignature",false);//隐藏盖章按钮 
            StatusMsg(weaver.WebOffice.Status);

        }catch(e){}

     //TD4213 增加提示信息  开始
     //oPopup.hide();
     hiddenPrompt();
     //TD4213 增加提示信息  结束
     
	//WebToolsEnable('Standard',109,true);StatusMsg('ok');
     
    }

function onLoadEnd(){

    try{
       
    }catch(e){
    }
}

    function UnLoad(){
    try{
    if (!weaver.WebOffice.WebClose()){
    StatusMsg(weaver.WebOffice.Status);
    }else{
    StatusMsg("<%=SystemEnv.getHtmlLabelName(19716,languageId)%>...");
    }
    }catch(e){}
    }

    function WebOpenSignature(){
    try{
    if(!SaveDocument()){
    alert("<%=SystemEnv.getHtmlLabelName(19720,languageId)%>");
    return false;
    }
    weaver.WebOffice.WebOpenSignature();
    StatusMsg(weaver.WebOffice.Status);
    return true;
    }catch(e){
    return false;
    }
    }

function WebToolsVisible(ToolName,Visible){
  try{
    weaver.WebOffice.WebToolsVisible(ToolName,Visible);
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){}
}

    function WebToolsEnable(ToolName,ToolIndex,Enable){
    try{
    weaver.WebOffice.WebToolsEnable(ToolName,ToolIndex,Enable);
    StatusMsg(weaver.WebOffice.Status);
    }catch(e){}
    }

   function protectDoc(){
    	//modified by cyril on 2008-06-10 for TD:8828
    	var Modify = weaver.WebOffice.WebObject.Saved;   	
    	if(!Modify || !checkDataChange()) {
    	  event.returnValue="<%=SystemEnv.getHtmlLabelName(19006,languageId)%>";
    	}
    }
    
    /**added by cyril on 2008-07-02 for TD:8921**/
    function protectDoc_include() {
    	var Modify = weaver.WebOffice.WebObject.Saved;
    	if(!Modify || !checkDataChange()) {
    		if(!confirm('<%=SystemEnv.getHtmlLabelName(19006,languageId)%>'))
    			document.getElementById('onbeforeunload_protectDoc_return').value = 0;//检测不通过
    		else 
    			document.getElementById('onbeforeunload_protectDoc_return').value = 1;//检测通过
    	}
    }
    /**end added by cyril on 2008-07-02 for TD:8921**/

   function wfchangetab(){
    	var Modify = weaver.WebOffice.WebObject.Saved;   	
    	if(!Modify || !checkDataChange()) {
    	  return true;
    	}else{
    	  return false;
    	}
    }

function onChanageShowMode(){
	/*if(DocInfoWindow.style.display == ""){
		DocInfoWindow.style.display = "none";

	}
	else{
		DocInfoWindow.style.display = "";
	}*/

}


</script>
<Title id="Title"></Title>
</head>

<body class="ext-ie ext-ie8 x-border-layout-ct" id="mybody" scroll="no" onunload="UnLoad()" onbeforeunload="protectDoc()">

<FORM id=weaver name=weaver action="UploadDoc.jsp?fromFlowDoc=<%=fromFlowDoc%>&workflowid=<%=workflowid%>" method=post  enctype="multipart/form-data">
<!--该参数必须作为Form的第一个参数,并且不能在其他地方调用，用于解决在IE6.0中输入·这个特殊符号存在的问题-->
<INPUT TYPE="hidden" id="docIdErrorError" NAME="docIdErrorError" value="">
<%@ include file="/systeminfo/DocTopTitle.jsp"%>
<input type="hidden" name="onbeforeunload_protectDoc" onclick="protectDoc_include()"/>
<input type="hidden" name="onbeforeunload_protectDoc_return"/>

<%
List menuBars = new ArrayList();
Map menuBarMap = new HashMap();
Map[] menuBarToolsMap = new HashMap[]{};
if(("1").equals(fromFlowDoc)){
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(86,user.getLanguage()));
	menuBarMap.put("iconCls","btn_save");
	menuBarMap.put("handler","onSave();");
	menuBars.add(menuBarMap);
} else {
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(19718,user.getLanguage()));
	menuBarMap.put("iconCls","btn_save");
	menuBarMap.put("handler","onSave();");
    menuBarMap.put("id","btn_saveid");
	menuBars.add(menuBarMap);
	
	if (!isPersonalDoc){
		menuBarMap = new HashMap();
		menuBarMap.put("text",SystemEnv.getHtmlLabelName(19719,user.getLanguage()));
		menuBarMap.put("iconCls","btn_draft");
		menuBarMap.put("handler","onDraft();");
		menuBarMap.put("id","btn_draft");
		menuBars.add(menuBarMap);
	
		menuBarMap = new HashMap();
		menuBarMap.put("text",SystemEnv.getHtmlLabelName(221,user.getLanguage()));
		menuBarMap.put("iconCls","btn_preview");
		menuBarMap.put("handler","onPreview();");
		menuBars.add(menuBarMap);
	}
	
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(16381,user.getLanguage()));
	menuBarMap.put("iconCls","btn_add");
	menuBarMap.put("handler","WebOpenLocal();");
	menuBars.add(menuBarMap);
	
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(16382,user.getLanguage()));
	menuBarMap.put("iconCls","btn_add");
	menuBarMap.put("handler","WebSaveLocal2();");
	menuBars.add(menuBarMap);
	
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(16383,user.getLanguage()));
	menuBarMap.put("iconCls","btn_add");
	menuBarMap.put("handler","WebOpenSignature();");
	menuBars.add(menuBarMap);
	
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(354,user.getLanguage()));
	menuBarMap.put("iconCls","btn_refresh");
	menuBarMap.put("handler","location.reload();");
	menuBars.add(menuBarMap);
	
	menuBarMap = new HashMap();
	menuBars.add(menuBarMap);
	
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(21622,user.getLanguage()));
	menuBarMap.put("iconCls","btn_list");
	menuBarMap.put("id","menuTypeChanger");

    if("1".equals(isUseET)){
	    menuBarToolsMap = new HashMap[]{new HashMap(),new HashMap(),new HashMap(),new HashMap()};
    }else{
	    menuBarToolsMap = new HashMap[]{new HashMap(),new HashMap(),new HashMap()};
    }



	int tmpindex = 0;
	if (!docType.equals(".htm")){
		menuBarToolsMap[tmpindex].put("text","Html&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
		menuBarToolsMap[tmpindex].put("iconCls","btn_html");
		menuBarToolsMap[tmpindex].put("handler","onChangeDocType('DocAdd.jsp?from="+from+"&userCategory="+userCategory+"','.htm');");
		tmpindex++;
	}
	if (!docType.equals(".doc")){	
		menuBarToolsMap[tmpindex].put("text","WORD&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
		menuBarToolsMap[tmpindex].put("iconCls","btn_word");
		menuBarToolsMap[tmpindex].put("handler","onChangeDocType('DocAddExt.jsp?from="+from+"&userCategory="+userCategory+"','.doc');");
		tmpindex++;
	}
	if (!docType.equals(".xls")){	
		menuBarToolsMap[tmpindex].put("text","Excel&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
		menuBarToolsMap[tmpindex].put("iconCls","btn_excel");
		menuBarToolsMap[tmpindex].put("handler","onChangeDocType('DocAddExt.jsp?from="+from+"&userCategory="+userCategory+"','.xls');");
		tmpindex++;
	}
	if (!docType.equals(".wps")){	
		menuBarToolsMap[tmpindex].put("text","Wps&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
		menuBarToolsMap[tmpindex].put("iconCls","btn_wps");
		menuBarToolsMap[tmpindex].put("handler","onChangeDocType('DocAddExt.jsp?from="+from+"&userCategory="+userCategory+"','.wps');");
		tmpindex++;
	}

    if("1".equals(isUseET)){
	    if (!docType.equals(".et")){	
		    menuBarToolsMap[tmpindex].put("text","Et&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
		    menuBarToolsMap[tmpindex].put("iconCls","btn_et");
		    menuBarToolsMap[tmpindex].put("handler","onChangeDocType('DocAddExt.jsp?from="+from+"&userCategory="+userCategory+"','.et');");
		    tmpindex++;
	     }
	}


	menuBarMap.put("menu",menuBarToolsMap);
	menuBars.add(menuBarMap);
	
	menuBarMap = new HashMap();
	menuBars.add(menuBarMap);
	
	menuBarMap = new HashMap();
	menuBarMap.put("text","<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>");
	menuBarMap.put("iconCls","btn_ShowOrHidden");
	menuBarMap.put("id","btn_ShowOrHidden");
	menuBarMap.put("handler","onExpandOrCollapse();");
	menuBars.add(menuBarMap);
}
%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
//文档的id 插件提交文档后设置这个值
%>
<INPUT TYPE="hidden" id="docId" NAME="docId" value="">
<INPUT TYPE="hidden" id="docType" NAME="docType" value="<%=docType%>">
<input type="hidden" name="operation">
<input type="hidden" name="SecId" value="<%=secid%>">

<script>
    function onSelectCategory(whichcategory) {
    	var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/PermittedCategoryBrowser.jsp?operationcode=<%=AclManager.OPERATION_CREATEDOC%>");
    	if (result != null) {
    		if (result[0] > 0)  {
    			location = "DocAddExt.jsp?secid="+result[1]+"&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&from=<%=from%>&docsubject="+weaver.docsubject.value+"&invalidationdate=<%=invalidationdate%>";
    		}
    	}
    }
</script>
<%--<input type=hidden name=docapprovable value="<%=needapprovecheck%>">--%>
<input type="hidden" name="docreplyable" value="<%=replyable%>">
<input type="hidden" name="usertype" value="<%=usertype%>">
<input type="hidden" name="from">
<input type="hidden" name="userCategory">
<input type="hidden" name="userId" value="<%=user.getUID()%>">
<input type="hidden" name="userType" value="<%=user.getLogintype()%>">

<input type="hidden" name="docstatus" value="0">
<input type="hidden" name="doccode" value="<%=docCode%>">
<input type="hidden" name="docedition" value="-1">
<input type="hidden" name="doceditionid" value="-1">
<input type="hidden" name="maincategory" value="<%=(mainid==-1?"":Integer.toString(mainid))%>">
<INPUT type="hidden" name="subcategory" value="<%=(subid==-1?"":Integer.toString(subid))%>">
<INPUT type="hidden" name="seccategory" value="<%=(secid==-1?"":Integer.toString(secid))%>">
<input type="hidden" name="ownerid" value="<%=ownerid%>">
<input type="hidden" name="docdepartmentid" value="<%=docdepartmentid%>">
<input type="hidden" name="doclangurage" value="<%=languageId%>">
<INPUT type="hidden" name="maindoc" value="-1">

<input type=hidden name=topage value="<%=topage%>">

<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>


<div style="position: absolute; left: 0; top: 0; width:100%;">

<div id="divContentTab" style="display:none;width:100%;">

	<%-- 文档标题 start --%>
	<div id="divDocTile" style="width:100%;<% if(("1").equals(fromFlowDoc)){ %>display: none;<% } %>">
		<DIV style="WIDTH: 100%; MozUserSelect: none; KhtmlUserSelect: none" class="x-tab-panel-header x-unselectable" unselectable="on">
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
						<input  style="width:310px" id="docsubject" name="docsubject" value="<%=docsubject%>" maxlength=200 							 
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
				<%if(!docsubject.equals("")&&!isPersonalDoc){%>
				checkDocSubject($('docsubject'));
				<%}%>
				function docSubjectMouseDown(obj){
					if(event.button==2){
						checkDocSubject(obj)
					}
				}
				function checkDocSubject(obj){
					if(obj!=null&&obj.value!=null&&obj.value!=""&&obj.value!=prevValue){
					  //$('docsubjectspan').innerHTML = "<font color=red><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></font>";
					  
					  isChecking = true;
					  
					  var subject = encodeURIComponent(obj.value);							  
					  var url = 'DocSubjectCheck.jsp';
					  var pars = 'subject='+subject+'&secid=<%=secid%>';
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
						$('docsubjectspan').innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"+
						" <div style='color:red;padding:8px 2px;width:310px;position:absolute;left:415px'><%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%></div>";
						$('namerepeated').value = 1;
					} else {
						$('namerepeated').value = 0;
						checkinput('docsubject','docsubjectspan');
					}
					isChecking = false;
					prevValue = $('docsubject').value;
				}
				function checkSubjectRepeated(){
					if($F('namerepeated')==1){
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
			</DIV></DIV>
	</div>
	<%-- 文档标题 end --%>

	<%-- iWebOffice编辑控件 start --%>
	<div id="divContent" style="width:100%;overflow:hidden;">
		<table cellpadding="0" cellspacing="0" style="width:100%;height:100%;">
			<tr><td bgcolor=menu>
			    <OBJECT id="WebOffice" classid="<%=mClassId%>" style="POSITION:absolute;width:0;height:0;top:-23;filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';" codebase="<%=mClientUrl%>" >
				</OBJECT>
			</td></tr>
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
		<div id=divPropTileIcon onclick="onExpandOrCollapse();" style="text-align:center;cursor: hand;"><img src="/js/extjs/resources/images/default/layout/mini-top.gif"></div>
	</DIV>
<% } else { %>
	<DIV style="background-color: #eeeeee;border: solid 1px #e0e0e0;width: 100%;height:26px; margin: 3px;">
		<DIV id=divPropTileIcon class="x-tool x-tool-expand-south " onclick="onExpandOrCollapse();">&nbsp;</DIV>
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
		<DIV style="WIDTH: 100%; HEIGHT: 195px; OVERFLOW: auto" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
			<%@ include file="/docs/docs/DocAddExtBaseInfo.jsp" %>
		</DIV></DIV></DIV></DIV>
	</div>
	<!-- 文档属性栏 end -->
	
	<!-- 文档附件栏 start -->
	<div id="divAcc" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 195px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="add" name="mode"/>
			<jsp:param value="docaddext" name="pagename"/>
			<jsp:param value="false" name="isFromWf"/>
			<jsp:param value="<%=maxUploadImageSize%>" name="maxUploadImageSize"/>
			<jsp:param value="getDivAcc" name="operation"/>
		</jsp:include>
		</DIV>
	</div>
	<!-- 文档附件栏 end -->

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
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.acc);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		
		<LI class=x-tab-edge></LI>
		<DIV class=x-clear></DIV></UL></DIV></DIV>

	</div>
	<!-- 底部选项卡栏 end -->
</div>

</div>

<!--TD4213 增加提示信息  开始-->
<div id="divFavContent18885" style="display:none">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18885,languageId)%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18886" style="display:none">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18886,languageId)%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18974" style="display:none">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18974,languageId)%>
			</td>
		</tr>
	</table>
</div>
<!--TD4213 增加提示信息  结束-->

<input type="text" style="display:none" name="txtDocTitle" id="txtDocTitle" TABINDEX="1" style="position:absolute" onBlur="docsubject.value=this.value;docsubject.fireEvent('onBlur');">

<input type="hidden" name="imageidsExt"  id="imageidsExt">
<input type="hidden" name="imagenamesExt"  id="imagenamesExt">
<input type="hidden" name="delImageidsExt"  id="delImageidsExt">

</FORM>
 
</body>

</html>

<jsp:include page="/docs/docs/DocComponents.jsp">
	<jsp:param value="<%=user.getLanguage()%>" name="language"/>
	<jsp:param value="getBase" name="operation"/>
</jsp:include>

<script language="javascript" type="text/javascript">
var maxUploadImageSize="<%=maxUploadImageSize%>";
var doctype="<%=docType%>";
var isFromWf=<%=("1").equals(fromFlowDoc)%>;
var languageid="<%=user.getLanguage()%>";

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
	} catch(e){
	}
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

	document.getElementById("divPropATab").className = "";
	document.getElementById("divAccATab").className = "";
	
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
}

$(document).ready(
	function(){
		
		try{
			onLoad();
		} catch(e){}

		if(doctype=="html"){
			document.title=wmsg.doc.createHTML;
		} else if(doctype==".doc"){
			document.title=wmsg.doc.createWord;
		}else if(doctype==".xls"){
			document.title=wmsg.doc.createExcel;
		}else if(doctype==".ppt"){
			document.title=wmsg.doc.createPPT;
		}else if(doctype==".wps"){
			document.title=wmsg.doc.createWps;
		}
		
		try{
			document.getElementById("divContentTab").style.display='block';
			document.getElementById("divPropTab").style.display = "none";
			document.getElementById("divPropTabCollapsed").style.display = "block";

			onActiveTab("divProp");
			
			document.getElementById('rightMenu').style.visibility="hidden";
			document.getElementById("divMenu").style.display='';	
		} catch(e){}

		adjustContentHeight("load");

		finalDo();

		try{	
			onLoadEnd();
		} catch(e){}
	}   
);
</script>
<%@ include file="DocAddExtScript.jsp" %>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>