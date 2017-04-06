<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 java.net.*" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.conn.RecordSet"%>

<%@ include file="/systeminfo/init.jsp" %>
<%
	if("false".equals(isIE)){
		response.sendRedirect("/docs/docs/DocAddForCK.jsp?"+request.getQueryString());
	}
%>
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
<jsp:useBean id="RecordSetAcc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
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
<jsp:useBean id="DocCoder" class="weaver.docs.docs.DocCoder" scope="page"/>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />

<%
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

//编辑：王金永
String  docType=Util.null2String(request.getParameter("docType"));
if(docType.equals("")){
    docType=".htm";
}
//out.println(docType);

/*added by hubo 050829*/
String isExpDiscussion = Util.null2String(request.getParameter("isExpDiscussion"));

String  prjid = Util.null2String(request.getParameter("prjid"));
String  crmid=Util.null2String(request.getParameter("crmid"));
String  hrmid=Util.null2String(request.getParameter("hrmid"));
String  coworkid = Util.null2String(request.getParameter("coworkid"));
String  showsubmit=Util.null2String(request.getParameter("showsubmit"));

String  topage=Util.null2String(request.getParameter("topage"));
String  tmptopage=URLEncoder.encode(topage);//专门用于页面直接导向

/*added by hubo 060226*/
if(!prjid.equals("")){
	docsubject = ProjectInfoComInfo.getProjectInfoname(prjid);
	String sqlProj = "SELECT proCode FROM Prj_ProjectInfo WHERE id="+prjid+"";
	RecordSet.executeSql(sqlProj);
	if(RecordSet.next()){
		docsubject += "("+RecordSet.getString("proCode")+")";
	}
}


String  sepStr="";
if(!showsubmit.equals("0"))  showsubmit="1";

String usertype = user.getLogintype();
int ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
int docdepartmentid=user.getUserDepartment() ;
String needinputitems = "";
if(!isPersonalDoc){
    needinputitems += "maincatgory,subcategory,seccategory";
}
AclManager am = new AclManager();

int secid=Util.getIntValue(Util.null2String(request.getParameter("secid")), -1);
int subid=Util.getIntValue(Util.null2String(request.getParameter("subid")), -1);
int mainid=Util.getIntValue(Util.null2String(request.getParameter("mainid")), -1);

int maxUploadImageSize = DocUtil.getMaxUploadImageSize(secid);

String isUseET=Util.null2String(BaseBean.getPropValue("weaver_obj","isUseET"));

if(isPersonalDoc) {
    int cannew = 0;
    if(userCategory<0){
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

//String doctypeid=Util.null2String(request.getParameter("doctypeid"));
String docmodule=Util.null2String(request.getParameter("docmodule"));
//if(doctypeid.equals("")) doctypeid = "0";

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


//String docdefseclevel="";
// String docseclevel="";
//int docmaxseclevel=-1;

String needapprovecheck="";

char flag=2;
String tempsubcategoryid="";

if(secid > 0){
	RecordSet.executeProc("Doc_SecCategory_SelectByID",secid+"");
	RecordSet.next();
	categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
	docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
	publishable=Util.null2String(""+RecordSet.getString("publishable"));
	replyable=Util.null2String(""+RecordSet.getString("replyable"));
	shareable=Util.null2String(""+RecordSet.getString("shareable"));
	
	readoptercanprint = Util.null2String(""+RecordSet.getString("readoptercanprint"));

	/* 在DocManager中判断
	String approvewfid=RecordSet.getString("approveworkflowid");
	if(approvewfid.equals("")) approvewfid="0";
    if(approvewfid.equals("0"))
        needapprovecheck="0";
    else
        needapprovecheck="1";
	*/
}

String docCode = "";//DocCoder.getDocCoder(secid+"");

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

/*
//	是否满足创建者类型＋安全级别的要求

if(cusertype.equals("0")){//判断内部用户的安全级别
	if(Util.getIntValue(user.getSeclevel()) >= Util.getIntValue(cuserseclevel) )
		trueright = 1;
}

//	是否满足部门＋安全级别的要求
if(user.getUserDepartment()==Util.getIntValue(cdepartmentid1,0) &&user.getUserDepartment()!=0 ){
	if(Util.getIntValue(user.getSeclevel()) >= Util.getIntValue(cdepseclevel1) )
		trueright = 1;
}
if(!cdepartmentid1.equals("0"))
	haschecked = 1;
if(user.getUserDepartment()==Util.getIntValue(cdepartmentid2,0) &&user.getUserDepartment()!=0 ){
	if(Util.getIntValue(user.getSeclevel()) >= Util.getIntValue(cdepseclevel2) )
		trueright = 1;
}
if(!cdepartmentid2.equals("0"))
	haschecked = 1;
//	是否满足角色＋级别的要求

if(!croleid1.equals("0")){
	if(CheckUserRight.checkUserRight(""+user.getUID(),croleid1,crolelevel1))
		trueright=1;
	haschecked =1 ;
}
if(!croleid2.equals("0")){
	if(CheckUserRight.checkUserRight(""+user.getUID(),croleid2,crolelevel2))
		trueright=1;
	haschecked =1 ;
}
if(!croleid3.equals("0")){
	if(CheckUserRight.checkUserRight(""+user.getUID(),croleid3,crolelevel3))
		trueright=1;
	haschecked =1 ;
}
//	该子目录是否有安全限制
if(haschecked ==0)
{
	trueright = 1;
}
*/


// 	Check Right
if(trueright!=1&&!isPersonalDoc) {
  	response.sendRedirect("/notice/noright.jsp");
	return;
}

// add by liuyu for dsp moulde text
String mouldtext = "" ;
int mouldType = 0;
if(!docmodule.equals("")) {
	MouldManager.setId(Util.getIntValue(docmodule));
	MouldManager.getMouldInfoById();
	mouldtext=MouldManager.getMouldText();
    mouldType=MouldManager.getMouldType();
	MouldManager.closeStatement();
    if(mouldType>1){
        String queryStr = request.getQueryString();
        String toQueryStr = queryStr;
        toQueryStr = Util.replace(toQueryStr,"&docmodule=([^&])*","",0);
%>
<SCRIPT LANGUAGE="JavaScript">
	document.location.href = "DocAddExt.jsp?<%=toQueryStr%>";
</SCRIPT>
<%
        return;
    }
	MouldManager.closeStatement();
}

List selectMouldList = new ArrayList();
int selectMouldType = 0;
int selectDefaultMould = 0;

if(docType.equals(".htm")){
	RecordSet.executeSql("select * from DocSecCategoryMould where secCategoryId = "+secid+" and mouldType=2 order by id ");
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
        String queryStr = request.getQueryString();
        String toQueryStr = queryStr;
        if(toQueryStr.indexOf("docmodule=")>-1)
            toQueryStr = Util.replace(toQueryStr,"docmodule=([^&])*","docmodule="+selectDefaultMould,0);
        else
            toQueryStr = toQueryStr + "&docmodule=" + selectDefaultMould;
        response.sendRedirect("DocAdd.jsp?"+toQueryStr);
        return;
	}
}



/**************************************************************************************************************
Discussion of project export to document
hubo,2005-08-29 modify by yshxu 2005-12-01 for adding customer contract export to document
*/
if(isExpDiscussion.equals("y")){
	String defaultSubject = "";
	char flag0=2;
	String projDiscussionHTML = "";
	StringBuffer projDiscussion = new StringBuffer("");
	if(!prjid.equals("")){
		String types = "PP";
		String sortid = prjid;

		RecordSetEX.executeProc("ExchangeInfo_SelectBID",sortid+flag0+types);
		while(RecordSetEX.next()){
			projDiscussion.append("<table style='width:100%;font-family:MS Shell Dlg;font-size:12px'><tr style='background-color:#dfdfdf;height:20px'>");
			projDiscussion.append("<td>"+RecordSetEX.getString("createDate")+"&nbsp;"+RecordSetEX.getString("createTime")+"&nbsp;&nbsp;<a href='javaScript:openhrm("+RecordSetEX.getString("creater")+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(RecordSetEX.getString("creater"))+"</a></td>");
			projDiscussion.append("</tr>");
			projDiscussion.append("<tr><td>"+Util.toHtml5(RecordSetEX.getString("remark"))+"</td></tr>");
			String docids_0=  Util.null2String(RecordSetEX.getString("docids"));
			String docsname="";
			if(!docids_0.equals("")){
				ArrayList docs_muti = Util.TokenizerString(docids_0,",");
				int docsnum = docs_muti.size();
				for(int i=0;i<docsnum;i++){
					 docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+"："+docsname+"</td></tr>");
			}
			projDiscussion.append("</table>");
		}
		defaultSubject = ProjectInfoComInfo.getProjectInfoname(prjid)+"-"+SystemEnv.getHtmlLabelName(15153,user.getLanguage());
	}else if(!coworkid.equals("")){

		RecordSetEX.executeSql("select * from cowork_discuss where coworkid="+coworkid+" order by createdate desc,createtime desc");
		while(RecordSetEX.next()){
			projDiscussion.append("<table style='width:100%;font-family:MS Shell Dlg;font-size:12px'><tr style='background-color:#dfdfdf;height:20px'>");
			projDiscussion.append("<td>"+RecordSetEX.getString("createdate")+"&nbsp;"+RecordSetEX.getString("createtime")+"&nbsp;&nbsp;<a href='javaScript:openhrm("+RecordSetEX.getString("discussant")+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(RecordSetEX.getString("discussant"))+"</a></td>");
			projDiscussion.append("</tr>");
			String str = Util.null2String(RecordSetEX.getString("remark"));
			str = Util.StringReplace(str,"&lt;br&gt;","");
			projDiscussion.append("<tr><td>"+str+"</td></tr>");

			String relatedprj = Util.null2String(RecordSetEX.getString("relatedprj"));
			if(relatedprj.equals("0"))relatedprj="";
			String relatedcus = Util.null2String(RecordSetEX.getString("relatedcus"));
			if(relatedcus.equals("0"))relatedcus="";
			String relatedwf = Util.null2String(RecordSetEX.getString("relatedwf"));
			if(relatedwf.equals("0"))relatedwf="";
			String relateddoc = Util.null2String(RecordSetEX.getString("relateddoc"));
			if(relateddoc.equals("0"))relateddoc="";
			String relatedacc = Util.null2String(RecordSetEX.getString("ralatedaccessory"));
			if(relatedacc.equals("0"))relatedacc="";
			ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
			ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
			ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
			ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");
			ArrayList relatedaccList = Util.TokenizerString(relatedacc, ",");

			String prjsname="",cussname="",wfsname="",docsname="",accsname="";

			if(relateddocList.size()>0){
				for(int i=0;i<relateddocList.size();i++){
					docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+relateddocList.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+relateddocList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+"："+docsname+"</td></tr>");
			}
			if(relatedcusList.size()>0){
				for(int i=0;i<relatedcusList.size();i++){
					cussname= cussname+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+relatedcusList.get(i)+">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+relatedcusList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(783,user.getLanguage())+"："+cussname+"</td></tr>");
			}
			if(relatedwfList.size()>0){
				for(int i=0;i<relatedwfList.size();i++){
					wfsname= wfsname+"<a href=/workflow/request/ViewRequest.jsp?requestid="+relatedwfList.get(i)+">"+Util.toScreen(RequestComInfo.getRequestname(""+relatedwfList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"："+wfsname+"</td></tr>");
			}
			if(relatedprjList.size()>0){
				for(int i=0;i<relatedprjList.size();i++){
					prjsname= prjsname+"<a href=/proj/process/ViewTask.jsp?taskrecordid="+relatedprjList.get(i)+">"+Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(""+relatedprjList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(18871,user.getLanguage())+"："+prjsname+"</td></tr>");
			}
			if(relatedaccList.size()>0){
				for(int i=0;i<relatedaccList.size();i++){
					RecordSetAcc.executeSql("select id,docsubject from docdetail where id="+relatedaccList.get(i));
					if(RecordSetAcc.next()){
						String showid = Util.null2String(RecordSetAcc.getString(1));
            String tempshowname= Util.toScreen(RecordSetAcc.getString(2),user.getLanguage()) ;
            String fileExtendName = "";
            String docImagefileid = "";
            String docImagefilename = "";
						DocImageManager.resetParameter();
            DocImageManager.setDocid(Integer.parseInt(showid));
            DocImageManager.selectDocImageInfo();
            if(DocImageManager.next()){
              docImagefileid = DocImageManager.getImagefileid();
              docImagefilename = DocImageManager.getImagefilename();
            	fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
            }
            if(fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")){
            	accsname = accsname + "<a href=/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&fromcowork=1>"+tempshowname+"</a>"+"&nbsp;&nbsp;";
            }else{
            	accsname = accsname + "<a href=/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&fromcowork=1>"+tempshowname+"</a>"+"&nbsp;&nbsp;";
            }
					}
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"："+accsname+"</td></tr>");
			}
			projDiscussion.append("</table>");
			projDiscussion.append("<br>");
		}


		RecordSetEX.executeSql("select * from cowork_items where id="+coworkid);
		while(RecordSetEX.next()){
			projDiscussion.append("<table style='width:100%;font-family:MS Shell Dlg;font-size:12px'><tr style='background-color:#dfdfdf;height:20px'>");
			projDiscussion.append("<td>"+RecordSetEX.getString("createdate")+"&nbsp;"+RecordSetEX.getString("createtime")+"&nbsp;&nbsp;<a href='javaScript:openhrm("+RecordSetEX.getString("creater")+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(RecordSetEX.getString("creater"))+"</a></td>");
			projDiscussion.append("</tr>");
			String str = Util.toHtml7(RecordSetEX.getString("remark"));
			str = Util.StringReplace(str,"&lt;br&gt;","");
			projDiscussion.append("<tr><td>"+str+"</td></tr>");

			String relatedprj = Util.null2String(RecordSetEX.getString("relatedprj"));
			if(relatedprj.equals("0"))relatedprj="";
			String relatedcus = Util.null2String(RecordSetEX.getString("relatedcus"));
			if(relatedcus.equals("0"))relatedcus="";
			String relatedwf = Util.null2String(RecordSetEX.getString("relatedwf"));
			if(relatedwf.equals("0"))relatedwf="";
			String relateddoc = Util.null2String(RecordSetEX.getString("relateddoc"));
			if(relateddoc.equals("0"))relateddoc="";
			String relatedacc = Util.null2String(RecordSetEX.getString("accessory"));
			if(relatedacc.equals("0"))relatedacc="";
			ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
			ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
			ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
			ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");
			ArrayList relatedaccList = Util.TokenizerString(relatedacc, ",");

			String prjsname="",cussname="",wfsname="",docsname="",accsname="";

			if(relateddocList.size()>0){
				for(int i=0;i<relateddocList.size();i++){
					String relateddoctemp = ""+relateddocList.get(i);
					if(relateddoctemp.indexOf("|")!=-1)
						relateddoctemp = relateddoctemp.substring(0,relateddoctemp.indexOf("|"));
					docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+relateddoctemp+">"+Util.toScreen(DocComInfo.getDocname(relateddoctemp),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+"："+docsname+"</td></tr>");
			}
			if(relatedcusList.size()>0){
				for(int i=0;i<relatedcusList.size();i++){
					cussname= cussname+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+relatedcusList.get(i)+">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+relatedcusList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(783,user.getLanguage())+"："+cussname+"</td></tr>");
			}
			if(relatedwfList.size()>0){
				for(int i=0;i<relatedwfList.size();i++){
					wfsname= wfsname+"<a href=/workflow/request/ViewRequest.jsp?requestid="+relatedwfList.get(i)+">"+Util.toScreen(RequestComInfo.getRequestname(""+relatedwfList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"："+wfsname+"</td></tr>");
			}
			if(relatedprjList.size()>0){
				for(int i=0;i<relatedprjList.size();i++){
					prjsname= prjsname+"<a href=/proj/process/ViewTask.jsp?taskrecordid="+relatedprjList.get(i)+">"+Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(""+relatedprjList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(18871,user.getLanguage())+"："+prjsname+"</td></tr>");
			}
			if(relatedaccList.size()>0){
				for(int i=0;i<relatedaccList.size();i++){
					RecordSetAcc.executeSql("select id,docsubject from docdetail where id="+relatedaccList.get(i));
					if(RecordSetAcc.next()){
						String showid = Util.null2String(RecordSetAcc.getString(1));
            String tempshowname= Util.toScreen(RecordSetAcc.getString(2),user.getLanguage()) ;
            String fileExtendName = "";
            String docImagefileid = "";
            String docImagefilename = "";
						DocImageManager.resetParameter();
            DocImageManager.setDocid(Integer.parseInt(showid));
            DocImageManager.selectDocImageInfo();
            if(DocImageManager.next()){
              docImagefileid = DocImageManager.getImagefileid();
              docImagefilename = DocImageManager.getImagefilename();
            	fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
            }
            if(fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")){
            	accsname = accsname + "<a href=/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&fromcowork=1>"+tempshowname+"</a>"+"&nbsp;&nbsp;";
            }else{
            	accsname = accsname + "<a href=/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&fromcowork=1>"+tempshowname+"</a>"+"&nbsp;&nbsp;";
            }
					}
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"："+accsname+"</td></tr>");
			}
			projDiscussion.append("</table>");
			projDiscussion.append("<br>");
		}
		defaultSubject = RecordSetEX.getString("name")+"-"+SystemEnv.getHtmlLabelName(15153,user.getLanguage());
	}else if(!crmid.equals("")){
		String tempsql = "";
		if (RecordSetC.getDBType().equals("oracle"))
			tempsql = " SELECT * FROM ( SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
				+ " FROM WorkPlan WHERE id IN ( "
				+ " SELECT DISTINCT a.id FROM WorkPlan a "
				+ " where (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + crmid + ",%'"
				+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC)";
		else if (RecordSetC.getDBType().equals("db2"))
			tempsql = " SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
				+ " FROM WorkPlan WHERE id IN ( "
				+ " SELECT DISTINCT a.id FROM WorkPlan a "
				+ " where (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + crmid + ",%'"
				+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC";
		else
			tempsql = "SELECT id, begindate , begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
				+ " FROM WorkPlan WHERE id IN ("
				+ "SELECT DISTINCT a.id FROM WorkPlan a"
				+ " where (',' + a.crmid + ',') LIKE '%," + crmid + ",%'"
				+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC";
		RecordSetC.executeSql(tempsql);
		while (RecordSetC.next()) {
			String m_beginDate = Util.null2String(RecordSetC.getString("begindate"));
			String m_beginTime = Util.null2String(RecordSetC.getString("begintime"));
			String m_memberId = Util.null2String(RecordSetC.getString("createrid"));
			String m_createrType = Util.null2String(RecordSetC.getString("createrType"));
			String m_description = Util.null2String(RecordSetC.getString("description"));
			String relatedprj = Util.null2String(RecordSetC.getString("taskid"));
			if(relatedprj.equals("0"))relatedprj="";
			String relatedcus = Util.null2String(RecordSetC.getString("crmid"));
			if(relatedcus.equals("0"))relatedcus="";
			String relatedwf = Util.null2String(RecordSetC.getString("requestid"));
			if(relatedwf.equals("0"))relatedwf="";
			String relateddoc = Util.null2String(RecordSetC.getString("docid"));
			if(relateddoc.equals("0"))relateddoc="";
			ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
			ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
			ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
			ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");

			projDiscussion.append("<table style='width:100%;font-family:MS Shell Dlg;font-size:12px'><tr style='background-color:#dfdfdf;height:20px'>");
			if (m_createrType.equals("1"))
				projDiscussion.append("<td>"+m_beginDate+"&nbsp;"+m_beginTime+"&nbsp;&nbsp;<a href='javaScript:openhrm("+m_memberId+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(m_memberId)+"</a></td>");
			else
				projDiscussion.append("<td>"+m_beginDate+"&nbsp;"+m_beginTime+"&nbsp;&nbsp;<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+m_memberId+"'>"+CustomerInfoComInfo.getCustomerInfoname(m_memberId)+"</a></td>");
			projDiscussion.append("</tr>");
			projDiscussion.append("<tr><td>"+m_description+"</td></tr>");
			String prjsname="",cussname="",wfsname="",docsname="";
			if(relatedprjList.size()>0){
				for(int i=0;i<relatedprjList.size();i++){
					prjsname= prjsname+"<a href=/proj/process/ViewTask.jsp?taskrecordid="+relatedprjList.get(i)+">"+Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(""+relatedprjList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(18871,user.getLanguage())+"："+prjsname+"</td></tr>");
			}
			if(relatedcusList.size()>0){
				for(int i=0;i<relatedcusList.size();i++){
					cussname= cussname+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+relatedcusList.get(i)+">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+relatedcusList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(783,user.getLanguage())+"："+cussname+"</td></tr>");
			}
			if(relatedwfList.size()>0){
				for(int i=0;i<relatedwfList.size();i++){
					wfsname= wfsname+"<a href=/workflow/request/ViewRequest.jsp?requestid="+relatedwfList.get(i)+">"+Util.toScreen(RequestComInfo.getRequestname(""+relatedwfList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"："+wfsname+"</td></tr>");
			}
			if(relateddocList.size()>0){
				for(int i=0;i<relateddocList.size();i++){
					docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+relateddocList.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+relateddocList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+"："+docsname+"</td></tr>");
			}
			projDiscussion.append("</table>");
			projDiscussion.append("<br>");
		}
		defaultSubject = CustomerInfoComInfo.getCustomerInfoname(crmid)+"-"+SystemEnv.getHtmlLabelName(6082,user.getLanguage());
	}
	projDiscussionHTML = projDiscussion.toString();

	docsubject = defaultSubject;
	mouldtext = projDiscussionHTML;
}
/**************************************************************************************************************/



String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
String needfav ="1";
String needhelp ="";

String Id=""+secid;
%>
<html><head>
<script type="text/javascript" src="/wui/common/jquery/jquery.js"></script>
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<script language="javascript" src="/js/weaver.js"></script>

<script src="/js/prototype.js" type="text/javascript"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>
<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>
 -->

<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/weaver-lang-tw-gbk.js'></script>
<%}%>

</head>
<body class="ext-ie ext-ie8 x-border-layout-ct" scroll="no" >
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
menuBarMap.put("text",SystemEnv.getHtmlLabelName(615,user.getLanguage()));
menuBarMap.put("iconCls","btn_save");
menuBarMap.put("handler","onSave(this);");
menuBars.add(menuBarMap);

if (!isPersonalDoc){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:onDraft(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"',iconCls: 'btn_draft',handler: function(){onDraft(this)}},";
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(220,user.getLanguage()));
	menuBarMap.put("iconCls","btn_draft");
	menuBarMap.put("handler","onDraft(this);");
	menuBars.add(menuBarMap);
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"',iconCls: 'btn_preview',handler: function(){onPreview(this)}},";
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(221,user.getLanguage()));
	menuBarMap.put("iconCls","btn_preview");
	menuBarMap.put("handler","onPreview(this);");
	menuBars.add(menuBarMap);
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:FCKEditorExt.switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+"',iconCls: 'btn_html',handler: function(){FCKEditorExt.switchEditMode()}},";
menuBarMap = new HashMap();
menuBarMap.put("text",SystemEnv.getHtmlLabelName(222,user.getLanguage()));
menuBarMap.put("iconCls","btn_html");
menuBarMap.put("handler","FCKEditorExt.switchEditMode();");
menuBars.add(menuBarMap);

//RCMenu += "{"+SystemEnv.getHtmlLabelName(224,user.getLanguage())+",javascript:showHeader(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;

//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(224,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){showHeader()}}";

//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onAccessory()}},";
menuBarMap = new HashMap();
menuBarMap.put("text",SystemEnv.getHtmlLabelName(156,user.getLanguage()));
menuBarMap.put("iconCls","btn_add");
menuBarMap.put("handler","onAccessory();");
menuBars.add(menuBarMap);

menuBarMap = new HashMap();
menuBars.add(menuBarMap);

//strExtBar+="'-',{text:'"+SystemEnv.getHtmlLabelName(21622,user.getLanguage())+"',iconCls: 'btn_list',id:'menuTypeChanger', menu: [{ text: 'WORD&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"',  iconCls: 'btn_word',handler:function(){onChangeDocType(\'DocAddExt.jsp\',\'.doc\')}},{ text: 'EXCEL&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"',  iconCls: 'btn_excel',handler:function(){onChangeDocType(\'DocAddExt.jsp\',\'.xls\')}},{ text: 'WPS&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"',  iconCls: 'btn_wps',handler:function(){onChangeDocType(\'DocAddExt.jsp\',\'.wps\')}}]  },";
menuBarMap = new HashMap();
menuBarMap.put("text",SystemEnv.getHtmlLabelName(21622,user.getLanguage()));
menuBarMap.put("iconCls","btn_list");
menuBarMap.put("id","menuTypeChanger");

if("1".equals(isUseET)){
    menuBarToolsMap = new HashMap[]{new HashMap(),new HashMap(),new HashMap(),new HashMap()};
}else{
    menuBarToolsMap = new HashMap[]{new HashMap(),new HashMap(),new HashMap()};
}


menuBarToolsMap[0].put("text","WORD&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
menuBarToolsMap[0].put("iconCls","btn_word");
menuBarToolsMap[0].put("handler","onChangeDocType('DocAddExt.jsp','.doc');");
menuBarToolsMap[1].put("text","EXCEL&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
menuBarToolsMap[1].put("iconCls","btn_excel");
menuBarToolsMap[1].put("handler","onChangeDocType('DocAddExt.jsp','.xls');");
menuBarToolsMap[2].put("text","WPS&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
menuBarToolsMap[2].put("iconCls","btn_wps");
menuBarToolsMap[2].put("handler","onChangeDocType('DocAddExt.jsp','.wps');");
if("1".equals(isUseET)){
    menuBarToolsMap[3].put("text","ET&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
    menuBarToolsMap[3].put("iconCls","btn_et");
    menuBarToolsMap[3].put("handler","onChangeDocType('DocAddExt.jsp','.et');");
}
menuBarMap.put("menu",menuBarToolsMap);
menuBars.add(menuBarMap);

menuBarMap = new HashMap();
menuBars.add(menuBarMap);

//strExtBar+="'-',{text:'<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>',iconCls: 'btn_ShowOrHidden',handler: function(){DocCommonExt.showorhiddenprop()}}";
menuBarMap = new HashMap();
menuBarMap.put("text","<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>");
menuBarMap.put("iconCls","btn_ShowOrHidden");
menuBarMap.put("id","btn_ShowOrHidden");
menuBarMap.put("handler","onExpandOrCollapse();");
menuBars.add(menuBarMap);

//strExtBar+="]";

//RCMenu += "{"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+",javascript:addannexRow(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<div id="divMenu" style="display:none">
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</div>

<script>
function onSelectCategory(whichcategory) {	
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/PermittedCategoryBrowser.jsp?operationcode=<%=AclManager.OPERATION_CREATEDOC%>");
	if (result != null) {
	    if (result[0] > 0)  {
	        //location = "DocAdd.jsp?secid="+result[1]+"&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&coworkid=<%=coworkid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&from=<%=from%>&docsubject="+weaver.docsubject.value+"&invalidationdate=<%=invalidationdate%>";
	        location = "DocAdd.jsp?secid="+result[1]+"&topage=<%=tmptopage%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&coworkid=<%=coworkid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&from=<%=from%>&docsubject="+weaver.docsubject.value+"&invalidationdate=<%=invalidationdate%>";
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
<input type="hidden" name="subcategory" value="<%=(subid==-1?"":Integer.toString(subid))%>">
<input type="hidden" name="seccategory" value="<%=(secid==-1?"":Integer.toString(secid))%>">
<input type="hidden" name="ownerid" value="<%=ownerid%>">
<input type="hidden" name="docdepartmentid" value="<%=docdepartmentid%>">
<input type="hidden" name="doclangurage" value=<%=user.getLanguage()%>>
<input type="hidden" name="maindoc" value="-1">

<input type="hidden" name="topage" value="<%=Util.null2String(request.getParameter("topage"))%>">
<input type=hidden name=operation>
<input type="hidden" name="SecId" value="<%=Id%>">
<input type="hidden" name="imageidsExt"  id="imageidsExt">
<input type="hidden" name="imagenamesExt"  id="imagenamesExt">
<input type="hidden" name="delImageidsExt"  id="delImageidsExt">

<div style="position: absolute; left: 0; top: 0; width:100%;">

<div id="divContentTab" style="display:none;width:100%;">

	<%-- 文档标题 start --%>
	<div id="divDocTile" style="width:100%;">
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
						<input style="width:310px" id="docsubject" name="docsubject" value="<%=docsubject%>" maxlength=200							 
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
				checkDocSubject($GetEle("docsubject"));
				<%}%>
				function docSubjectMouseDown(obj){
					if(event.button==2){
						checkDocSubject(obj)
					}
				}
				function checkDocSubject(obj){
					if(obj!=null&&obj.value!=null&&obj.value!=""&&obj.value!=prevValue){
					  //$('docsubjectspan').innerHTML = "<font color=red><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></font>";
					  
					  $GetEle("namerepeated").value = 1;
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
						$("#docsubjectspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>"+
								" <div style='color:red;padding:8px 2px;width:310px;position:absolute;left:415px'><%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%></div>");
						$GetEle("namerepeated").value = 1;
					} else {
						$GetEle("namerepeated").value = 0;
						checkinput('docsubject','docsubjectspan');
					}
					isChecking = false;
					prevValue = $GetEle("docsubject").value;
				}
				function checkSubjectRepeated(){
					if($GetEle("namerepeated").value==1){
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
	

	<%-- HTML编辑控件 start --%>
	<div id="divContent" style="width:100%;">
		<textarea name="doccontent" id="doccontent" TABINDEX="2"><%=mouldtext%></textarea>
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
	<DIV style="background-color: #eeeeee;border: solid 1px #e0e0e0;width: 100%;height:26px; margin: 3px;">
		<DIV id=divPropTileIcon class="x-tool x-tool-expand-south " onclick="onExpandOrCollapse();">&nbsp;</DIV>
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
		<DIV style="WIDTH: 100%; HEIGHT: 181px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<DIV style="WIDTH: 100%" id=DocPropAdd class=" x-panel x-panel-noborder">
		<DIV class=x-panel-bwrap>
		<DIV style="WIDTH: 100%; HEIGHT: 181px; OVERFLOW: auto" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
			<%@ include file="/docs/docs/DocAddBaseInfo.jsp" %>
		</DIV></DIV></DIV></DIV>
	</div>
	<!-- 文档属性栏 end -->
	
	<!-- 文档附件栏 start -->
	<div id="divAcc" style="display:none;width:100%;">
		<DIV style="WIDTH: 100%; HEIGHT: 181px" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<jsp:include page="/docs/docs/DocComponents.jsp">
			<jsp:param value="add" name="mode"/>
			<jsp:param value="docadd" name="pagename"/>
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

</form>
</body>

</html>

<jsp:include page="/docs/docs/DocComponents.jsp">
	<jsp:param value="<%=user.getLanguage()%>" name="language"/>
	<jsp:param value="getBase" name="operation"/>
</jsp:include>

<!--文档内容过滤JS-->
<script language="javascript" type="text/javascript">
  function ContentSearch(){
	var flag = false;//检查标志。false：表示未找到。true：表示找到
    try {
	   var str = "<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>";//keyword
	   var arr = [];//支持多关键字查找
	   var splitflag = " ";//分隔标志
		if(str === ""){	
			return false;
		}else{
			//将关键字放到数组之中
			arr = str.split(splitflag);	
		}
		var v_html = FCKeditorAPI.GetInstance("doccontent").GetXHTML(true);//需要查找的内容
		//删除注释
		v_html = v_html.replace(/<!--(?:.*)\-->/g,"");
		//将HTML代码支离为HTML片段和文字片段，其中文字片段用于正则替换处理，而HTML片段置之不理
		var tags = /[^<>]+|<(\/?)([A-Za-z]+)([^<>]*)>/g;
		var a = v_html.match(tags);
		jQuery.each(a, function(i, c){
			if(!/<(?:.|\s)*?>/.test(c)){//非标签
				//开始执行替换
				jQuery.each(arr,function(index, con){
					if(con === ""){return;}
					var reg = new RegExp(regTrim(con), "g");
					if(reg.test(c)){
						//正则替换
						c = c.replace(reg,"♂"+con+"♀");
						flag = true;
					}
				});
				a[i] = c;
			}
		});
	}catch(err) {
	   flag = false;
	}
	return flag;
}

 function regTrim(s){
		var imp = /[\^\.\\\|\(\)\*\+\-\$\[\]\?]/g;
		var imp_c = {};
		imp_c["^"] = "\\^";
		imp_c["."] = "\\.";
		imp_c["\\"] = "\\\\";
		imp_c["|"] = "\\|";
		imp_c["("] = "\\(";
		imp_c[")"] = "\\)";
		imp_c["*"] = "\\*";
		imp_c["+"] = "\\+";
		imp_c["-"] = "\\-";
		imp_c["$"] = "\$";
		imp_c["["] = "\\[";
		imp_c["]"] = "\\]";
		imp_c["?"] = "\\?";
		s = s.replace(imp,function(o){
			return imp_c[o];					   
		});	
		return s;
}
</script>
<!--文档内容过滤JSend-->

<script language="javascript" type="text/javascript">
var isFromWf=false;
var languageid="<%=user.getLanguage()%>";
var maxUploadImageSize="<%=maxUploadImageSize%>";
var strExtBar="<%=strExtBar%>";
var menubar=eval(strExtBar);
var menubarForwf=[];
var doctype="html";

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
			FCKEditorExt.initEditor('weaver','doccontent','<%=user.getLanguage()%>','',divContentHeight-28)

		} else {			
			jQuery("#cke_contents_"+"doccontent").css("height",divContentHeight-28);
			jQuery(".cke_source").css("height",divContentHeight-28);	
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
<%@ include file="DocAddScript.jsp" %> 
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>