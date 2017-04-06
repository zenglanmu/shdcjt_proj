<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SysDefaultsComInfo" class="weaver.docs.tools.SysDefaultsComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
AclManager am = new AclManager();
int id = Util.getIntValue(request.getParameter("id"),0);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
CategoryManager cm = new CategoryManager();

	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	categoryname = categoryname.replaceAll("&nbsp","&amp;nbsp").replaceAll("\''","\'");
	
	String coder=Util.toScreenToEdit(RecordSet.getString("coder"),user.getLanguage());
	String subcategoryid=RecordSet.getString("subcategoryid");
	//String docmouldid=RecordSet.getString("docmouldid");
	/* added by wdl 2006.7.3 TD.4617 start */
	//String wordmouldid = RecordSet.getString("wordmouldid");
	/* added end */
	String publishable=RecordSet.getString("publishable");
	String replyable=RecordSet.getString("replyable");
	String shareable=RecordSet.getString("shareable");
    float secorder = RecordSet.getFloat("secorder");
    
	int logviewtype = Util.getIntValue(RecordSet.getString("logviewtype"),0);

	String cusertype=RecordSet.getString("cusertype");
	String cuserseclevel=RecordSet.getString("cuserseclevel");
	if(cuserseclevel.equals("255")) cuserseclevel="";
	String cdepartmentid1=RecordSet.getString("cdepartmentid1");
	String cdepseclevel1=RecordSet.getString("cdepseclevel1");
	if(cdepseclevel1.equals("255")) cdepseclevel1="";
	String cdepartmentid2=RecordSet.getString("cdepartmentid2");
	String cdepseclevel2=RecordSet.getString("cdepseclevel2");
	if(cdepseclevel2.equals("255")) cdepseclevel2="";
	String croleid1=RecordSet.getString("croleid1");
	String crolelevel1=RecordSet.getString("crolelevel1");
	String croleid2=RecordSet.getString("croleid2");
	String crolelevel2=RecordSet.getString("crolelevel2");
	String croleid3=RecordSet.getString("croleid3");
	String crolelevel3=RecordSet.getString("crolelevel3");
	String approvewfid=RecordSet.getString("approveworkflowid");
	String hasaccessory=RecordSet.getString("hasaccessory");
	String accessorynum=RecordSet.getString("accessorynum");
	String hasasset=RecordSet.getString("hasasset");
	String assetlabel=RecordSet.getString("assetlabel");
	String hasitems=RecordSet.getString("hasitems");
	String itemlabel=RecordSet.getString("itemlabel");
	String hashrmres=RecordSet.getString("hashrmres");
	String hrmreslabel=RecordSet.getString("hrmreslabel");
	String hascrm=RecordSet.getString("hascrm");
	String crmlabel=RecordSet.getString("crmlabel");
	String hasproject=RecordSet.getString("hasproject");
	String projectlabel=RecordSet.getString("projectlabel");
	String hasfinance=RecordSet.getString("hasfinance");
	String financelabel=RecordSet.getString("financelabel");

	String defaultDummyCata=Util.null2String(RecordSet.getString("defaultDummyCata"));
	int relationable  = Util.getIntValue(RecordSet.getString("relationable"),0);

    int markable=Util.getIntValue(Util.null2String(RecordSet.getString("markable")),0);
    int markAnonymity=Util.getIntValue(Util.null2String(RecordSet.getString("markAnonymity")),0);
    int orderable=Util.getIntValue(Util.null2String(RecordSet.getString("orderable")),0);
    int defaultLockedDoc=Util.getIntValue(Util.null2String(RecordSet.getString("defaultLockedDoc")),0);
    int isSetShare=Util.getIntValue(Util.null2String(RecordSet.getString("isSetShare")),0);
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
    
    int maxOfficeDocFileSize=Util.getIntValue(Util.null2String(RecordSet.getString("maxOfficeDocFileSize")),8);
    int maxUploadFileSize=Util.getIntValue(Util.null2String(RecordSet.getString("maxUploadFileSize")),0);
    int allownModiMShareL=Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMShareL")),0);
    int allownModiMShareW=Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMShareW")),0);
    String allowShareTypeStrs=Util.null2String(RecordSet.getString("allowShareTypeStrs"));
    ArrayList allowShareTypeList = Util.TokenizerString(allowShareTypeStrs,",");
    
    int noDownload = Util.getIntValue(Util.null2String(RecordSet.getString("nodownload")),0);
    int noRepeatedName = Util.getIntValue(Util.null2String(RecordSet.getString("norepeatedname")),0);
    int bacthDownload = Util.getIntValue(Util.null2String(RecordSet.getString("bacthDownload")),0);
    int isControledByDir = Util.getIntValue(Util.null2String(RecordSet.getString("iscontroledbydir")),0);
    int pubOperation = Util.getIntValue(Util.null2String(RecordSet.getString("puboperation")),0);
    int childDocReadRemind = Util.getIntValue(Util.null2String(RecordSet.getString("childdocreadremind")),0);

    String isPrintControl=Util.null2String(RecordSet.getString("isPrintControl"));
    int printApplyWorkflowId = Util.getIntValue(Util.null2String(RecordSet.getString("printApplyWorkflowId")),0);
    
    String isLogControl = Util.null2String(RecordSet.getString("isLogControl"));
    
    int isOpenAttachment = Util.getIntValue(Util.null2String(RecordSet.getString("isOpenAttachment")),0);
    
    int isAutoExtendInfo = Util.getIntValue(Util.null2String(RecordSet.getString("isAutoExtendInfo")),0);

    int readOpterCanPrint = Util.getIntValue(Util.null2String(RecordSet.getString("readoptercanprint")),0);
    int appointedWorkflowId = Util.getIntValue(Util.null2String(RecordSet.getString("appointedWorkflowId")),0);    
    int appliedTemplateId = Util.getIntValue(Util.null2String(RecordSet.getString("appliedTemplateId")),0);
    String appliedTemplateName = "";
    if(appliedTemplateId>0){
    	RecordSet.executeSql(" select name from DocSecCategoryTemplate where id = " + appliedTemplateId);
    	RecordSet.next();
    	appliedTemplateName = Util.null2String(RecordSet.getString(1));
    }


    
    RecordSet.executeSql(" select norepeatedname from DocMainCategory where id = " + mainid);
    RecordSet.next();
    if(Util.getIntValue(RecordSet.getString("norepeatedname"),0)==1||Util.getIntValue(SubCategoryComInfo.getNoRepeatedName(subcategoryid),0)==1)
        noRepeatedName = 11;

	boolean canEdit = false;
	boolean canAdd = false;
	boolean canDelete = false;
	boolean canLog = false;
	boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
	//hasSecManageRight = am.hasPermission(id, AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_CREATEDIR);
	hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || hasSubManageRight || hasSecManageRight){
	    canEdit = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategoryAdd:add", user) || hasSubManageRight || hasSecManageRight){
        canAdd = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user) || hasSubManageRight || hasSecManageRight) {
        canDelete = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategory:log", user) || hasSubManageRight || hasSecManageRight) {
        canLog = true;
    }


String isdisplay="";
String ischeck="";

//求分目录中文档创建者相关的权限
String PCreater = "3";
String PCreaterManager = "1";
String PCreaterJmanager = "1";
String PCreaterDownOwner = "0";
String PCreaterSubComp = "0";
String PCreaterDepart = "0";
String PCreaterDownOwnerLS = "0";
String PCreaterSubCompLS = "0";
String PCreaterDepartLS = "0";

String PCreaterW = "3";
String PCreaterManagerW = "1";
String PCreaterJmanagerW = "1";

RecordSet1.executeSql("select * from secCreaterDocPope where secid = "+id);
if (RecordSet1.next()) {
    PCreater = Util.null2String(RecordSet1.getString("PCreater"));
    PCreaterManager = Util.null2String(RecordSet1.getString("PCreaterManager"));
    PCreaterJmanager = Util.null2String(RecordSet1.getString("PCreaterJmanager"));
    PCreaterDownOwner = Util.null2String(RecordSet1.getString("PCreaterDownOwner"));
    PCreaterSubComp = Util.null2String(RecordSet1.getString("PCreaterSubComp"));
    PCreaterDepart = Util.null2String(RecordSet1.getString("PCreaterDepart"));
    PCreaterDownOwnerLS = Util.null2String(RecordSet1.getString("PCreaterDownOwnerLS"));   
    PCreaterSubCompLS = Util.null2String(RecordSet1.getString("PCreaterSubCompLS"));   
    PCreaterDepartLS = Util.null2String(RecordSet1.getString("PCreaterDepartLS"));
    PCreaterW = Util.null2String(RecordSet1.getString("PCreaterW"));
    PCreaterManagerW = Util.null2String(RecordSet1.getString("PCreaterManagerW"));
    PCreaterJmanagerW = Util.null2String(RecordSet1.getString("PCreaterJmanagerW"));
}

String tempName = SubCategoryComInfo.getSubCategoryname(""+subcategoryid);
tempName = tempName.replaceAll("<", "＜").replaceAll(">", "＞").replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("&nbsp","&amp;nbsp").replaceAll("\''","\'");;
%>
<BASE TARGET="_parent">
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%--
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
--%>
<%
if(messageid !=0) {
 if(messageid==87){
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(21536,user.getLanguage())%></font></DIV> 
<% }else{
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlNoteName(messageid,user.getLanguage())%></font></DIV>
<%}
}%>
<%
if(errorcode == 10) {
%>
	<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
<%}%>

<iframe name="DocFTPConfigInfoGetter" style="width:100%;height:200;display:none"></iframe>

<FORM id=weaver name=weaver action="SecCategoryOperation.jsp" method=post>
<input type=hidden name="operation">
<input type=hidden name="id" value="<%=id%>">
<input type=hidden name="fromtab" value="0">
<input type=hidden name="tab" value="0">
<%
//if(HrmUserVarify.checkUserRight("DocSubCategoryEdit:Edit", user)){
if (canEdit) {
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canAdd){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(67,user.getLanguage())+",javascript:onNew(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(19468,user.getLanguage())+",javascript:onSaveAsTmpl(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canDelete){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canLog){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
%>
 <TABLE class=ViewForm>

  <TBODY>
  <TR>
    <TD vAlign=top>
    	<!-- 细节 -->
        <TABLE class=ViewForm>
          <COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY>
          <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
            <td align=right><A href="DocMainCategory.jsp" target="mainFrame"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></A>
             ><A href="DocMainCategoryEdit.jsp?id=<%=mainid%>" target="contentframe"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></A>
               >
               <A href="DocSubCategoryEdit.jsp?id=<%=subcategoryid%>" target="contentframe"><%=tempName%></A>
            </td>
          </TR>
          <TR class=Spacing style="height: 1px!important;">
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD>
            <TD class=Field><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></TD>
          </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD>
            <TD class=Field><input type=hidden name="subcategoryid" value="<%=subcategoryid%>"><%=tempName%>
            </TD>
          </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TD>
            <TD class=Field><%if(canEdit){%>
            <INPUT class=InputStyle maxLength=100 size=60 name=categoryname value="<%=categoryname%>" onChange="checkinput('categoryname','categorynamespan')"><%}else{%><%=categoryname%><%}%>
            <INPUT type=hidden maxLength=100 size=60 name=srccategoryname value="<%=categoryname%>" >
            <span id=categorynamespan><%if(categoryname.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
            </TD>
          </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19389,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT maxLength=50 size=30 class=InputStyle name="coder" value="<%=coder%>"><%}else{%><%=coder%><%}%></TD>
         </TR>

<%-- 目录模版 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(19456,user.getLanguage())%></td>
            <td class=Field>
              <%if(canEdit){%>
              
              <input class=wuiBrowser _displayText="<%=appliedTemplateName %>" _url='/systeminfo/BrowserMain.jsp?url=/docs/category/DocSecCategoryTmplBrowser.jsp' 
              	_beforeShow="" _callBack="changeTemplate" type=hidden name=dirmouldid value="<%=appliedTemplateId%>">
              <%}else{%>
            <span id=dirmouldidname><%if(appliedTemplateId>0){%><%=appliedTemplateName%><%}%></span>
              
              <%} %>
            </td>
          </tr>

<%--
<TR><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td>HTML<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></td>
            <td class=Field>
              <%if(canEdit){%>
              <button class=Browser onclick="onShowMould()"></button>
              <%}%>
            <span id=docmouldidname><a href="/docs/mould/DocMouldDsp.jsp?id=<%=docmouldid%>"><%=DocMouldComInfo.getDocMouldname(""+docmouldid)%></a></span>
              <input class=InputStyle type=hidden name=docmouldid value="<%=docmouldid%>">
            </td>
          </tr>


<% -- added by wdl 2006.7.3 TD.4617 start  -- %>          
<TR><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td>Word<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></td>
            <td class=Field>
              <%if(canEdit){%>
              <button class=Browser onclick="onShowMould1()"></button>
              <%}%>
            <span id=wordmouldidname><a href="/docs/mould/DocMouldDspExt.jsp?id=<%=wordmouldid%>"><%=DocMouldComInfo.getDocMouldname(""+wordmouldid)%></a></span>
              <input class=InputStyle type=hidden name=wordmouldid value="<%=wordmouldid%>">
            </td>
          </tr>
<% -- added end -- %> 
--%>


<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td> <%=SystemEnv.getHtmlLabelName(19790,user.getLanguage())%></td>
            <td class=Field>
            <%
            String isdisable = "";
            if(!canEdit) isdisable ="disabled";
            ischeck="";
            if(publishable.equals("1")) ischeck=" checked";
            %>
              <input class=InputStyle  type=checkbox value=1 name=publishable <%=ischeck%> <%=isdisable%>>
             </td>
          </tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></td>
            <td class=Field>
            <%
            isdisable = "";
            if(!canEdit) isdisable ="disabled";
            ischeck="";
            if(replyable.equals("1")) ischeck=" checked";
            %>
              <input class=InputStyle type=checkbox value=1 name=replyable <%=ischeck%> <%=isdisable%>>
              </td>
          </tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

<TR>
    <TD><%=SystemEnv.getHtmlLabelName(18572,user.getLanguage())%></TD>
    <!--<TD class=Field><INPUT class=InputStyle type=checkbox <%if(orderable==1){%>checked<%}%> value=1 name="orderable" onclick="onOrderAbleClick(this,allowAddSharer1,allowAddSharer1_ext)"></TD>-->
    <TD class=Field><INPUT class=InputStyle type=checkbox <%if(orderable==1){%>checked<%}%> value=1 name="orderable" <%if(!canEdit){%>disabled<%}%>></TD>
</TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(20449,user.getLanguage())%></TD>           
            <TD class=Field>
                <%
                ischeck="";
                if(shareable.equals("1")) ischeck=" checked";
                %>
                  <%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%><input type="checkbox" name="allownModiMShareL" class="inputstyle" value="1" <%if(allownModiMShareL==1){out.println("checked");}%> <%if(!canEdit){%>disabled<%}%>>
                &nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18574,user.getLanguage())%><INPUT class=InputStyle type=checkbox value=1 name=shareable <%=ischeck%> <%=isdisable%>>                  
            </TD>
          
          </TR>
          
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19435,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(isSetShare==1){%>checked<%}%> value=1 name="isSetShare" <%if(!canEdit){%>disabled<%}%>>
            </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(18575,user.getLanguage())%></TD>
            <TD class=Field>           
              <INPUT class=InputStyle type=checkbox <%if(markable==1){%>checked<%}%> value=1 name="markable" onclick="onMarkableClick()" <%if(!canEdit){%>disabled<%}%>>
            </TD>
          </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox  <%if(markable!=1){%>disabled<%}%> <%if(markAnonymity==1){%>checked<%}%> value=1 name="markAnonymity" <%if(!canEdit){%>disabled<%}%>>
          </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(18578,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(defaultLockedDoc==1){%>checked<%}%> value=1 name="defaultLockedDoc" <%if(!canEdit){%>disabled<%}%>>
            </TR>

<%-- 禁止文档下载 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19458,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle  type=checkbox <%if(noDownload==1){%>checked<%}%> value=1 name="noDownload" <%if(!canEdit){%>disabled<%}%>>
            </TR>
<%-- Office文档最大 --%>
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(24024,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=input size=4 defValue="<%=maxOfficeDocFileSize%>" onchange="checkPositiveNumber('<%=SystemEnv.getHtmlLabelName(24024,user.getLanguage())%>',this)" name="maxOfficeDocFileSize" onKeyPress="ItemCount_KeyPress()" value="<%=maxOfficeDocFileSize%>" <%if(!canEdit){%>disabled<%}%>>M（<%=SystemEnv.getHtmlLabelName(24025,user.getLanguage())%>）
          </TR>
<%-- 附件上传最大 --%>        
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(18580,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle defValue="<%=maxUploadFileSize%>" onchange="checkPositiveNumber('<%=SystemEnv.getHtmlLabelName(18580,user.getLanguage())%>',this)" type=input size=4 name="maxUploadFileSize" onKeyPress="ItemCount_KeyPress()" value="<%=maxUploadFileSize%>" <%if(!canEdit){%>disabled<%}%>>M
          </TR>
<%-- 附件是否允许批量下载 --%>         
<TR style="height: 1px" ><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(27025,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(bacthDownload==1){%>checked<%}%> <%if(noDownload==1){%>disabled<%}%> value=1 name="bacthDownload" <%if(!canEdit){%>disabled<%}%>>
            </TR>
<%-- 禁止文档重名 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(noRepeatedName==1){%>checked<%}%> <%if(noRepeatedName==11){%>checked disabled<%}%> value=1 name="noRepeatedName" <%if(!canEdit){%>disabled<%}%>>
            </TR>

<%-- 是否受控目录 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19459,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(isControledByDir==1){%>checked<%}%> value=1 name="isControledByDir" <%if(!canEdit){%>disabled<%}%>>
            </TR>

<%-- 发布操作 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19460,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(pubOperation==1){%>checked<%}%> value=1 name="pubOperation" <%if(!canEdit){%>disabled<%}%>>
            </TR>
<%-- 相关资源 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(22672,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(relationable==1){%>checked<%}%> value=1 name="relationable" <%if(!canEdit){%>disabled<%}%>>
            </TR>


<%-- 子文档阅读提醒 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19461,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(childDocReadRemind==1){%>checked<%}%> value=1 name="childDocReadRemind" <%if(!canEdit){%>disabled<%}%>>
            </TR>

<%-- 是否打印控制 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(21528,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(isPrintControl.equals("1")){%>checked<%}%> value=1 name="isPrintControl"  <%if(!canEdit){%>disabled<%}%>>
            </TR>

<%-- 打印申请流程 --%>

			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(21532,user.getLanguage())%></TD>
            <TD class=Field>							     		
				<%if(canEdit){%>
							<INPUT  type=hidden name="printApplyWorkflowId" id="printApplyWorkflowId" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=200" _displayText="<%=WorkflowComInfo.getWorkflowname(""+printApplyWorkflowId)%>" value="<%=printApplyWorkflowId%>" >			
				<%}else{%>
							<%=WorkflowComInfo.getWorkflowname(""+printApplyWorkflowId)%>
				<%}%>
            </TR>

<%-- 允许只读操作人打印 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19462,user.getLanguage())%></TD>
            <TD class=Field>
        		<select  class=InputStyle name=readOpterCanPrint size=1 <%if(!canEdit){%>disabled<%}%>>
        			<option value=1 <%if(readOpterCanPrint==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%></option>
        			<option value=0 <%if(readOpterCanPrint==0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(233,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%></option>
        			<option value=2 <%if(readOpterCanPrint==2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19463,user.getLanguage())%></option>
        		</select>
            </TR>

<%-- 文档日志查看 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(20997,user.getLanguage())%></TD>
            <TD class=Field>
        		<select  class=InputStyle name=logviewtype size=1 <%if(!canEdit){%>disabled<%}%>>
        			<option value=0 <%if(logviewtype==0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20998,user.getLanguage())%></option>
                    <!-- TD12005 文档日志查看 "仅管理员能查看"改为"按文档日志权限查看" -->
                    <option value=1 <%if(logviewtype==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(23751,user.getLanguage())%></option>
        		</select>
            </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(21996,user.getLanguage())%></TD>
          <TD class=Field>
             <INPUT class=InputStyle type=checkbox <%if(isLogControl.equals("1")){%>checked<%}%> value=1 name="isLogControl"  <%if(!canEdit){%>disabled<%}%>>
          </TD>
        </TR>

<%-- 虚拟目录 --%>

			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(20498,user.getLanguage())%></TD>
            <TD class=Field>							     		
				<%if(canEdit){%>
				<INPUT  class="wuiBrowser"  _displayText="<%=DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(defaultDummyCata).replaceAll("\"","'")%>" _url="/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp" type=hidden value="<%=defaultDummyCata %>" name="defaultDummyCata" id="defaultDummyCata">
				
				<%}%>

            </TR>
<%-- 新建工作流指定流程 --%>

			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(21382,user.getLanguage())%></TD>
            <TD class=Field>							     		
				<%if(canEdit){%>
				<INPUT class=wuiBrowser _displayText="<%=WorkflowComInfo.getWorkflowname(""+appointedWorkflowId)%>" value="<%=appointedWorkflowId %>" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1" type=hidden name="appointedWorkflowId" id="appointedWorkflowId" value="0" >
										
				<%}else{%>
							<%=WorkflowComInfo.getWorkflowname(""+appointedWorkflowId)%>
				<%}%>
            </TR>

<%-- 单附件直接打开 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(24000,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(isOpenAttachment==1){%>checked<%}%> value=1 name="isOpenAttachment"  <%if(!canEdit){%>disabled<%}%>>
            </TR>
          
<%-- 展开文档属性 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(24417,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(isAutoExtendInfo==1){%>checked<%}%> value=1 name="isAutoExtendInfo"  <%if(!canEdit){%>disabled<%}%>>
            </TR>
          
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT maxLength=5 size=5 class=InputStyle name="secorder" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("secorder")' value="<%=secorder%>"><%}else{%><%=secorder%><%}%></TD>
         </TR>
         
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>

<%
	String isUseFTPOfSystem=BaseBean.getPropValue("FTPConfig","ISUSEFTP");
	if("1".equals(isUseFTPOfSystem)){
		String isUseFTP="0";
		int FTPConfigId=0;
		String FTPConfigName="";
		String FTPConfigDesc="";
		String serverIP="";
		String serverPort="";
		String userName="";
		String userPassword="";
		String defaultRootDir="";
		int maxConnCount=0;
		float showOrder=0;

		RecordSet.executeSql("select * from DocSecCatFTPConfig where secCategoryId=" + id);
		if(RecordSet.next()){
			isUseFTP = Util.null2String(RecordSet.getString("isUseFTP"));
			FTPConfigId = Util.getIntValue(RecordSet.getString("FTPConfigId"),0);
		}

		if(FTPConfigId==0){
			DocFTPConfigComInfo.setTofirstRow();
			if(DocFTPConfigComInfo.next()){
				FTPConfigId=Util.getIntValue(DocFTPConfigComInfo.getId(),0);
			}
		}

		FTPConfigName = Util.null2String(DocFTPConfigComInfo.getFTPConfigName(""+FTPConfigId));
		FTPConfigDesc = Util.null2String(DocFTPConfigComInfo.getFTPConfigDesc(""+FTPConfigId));
		serverIP = Util.null2String(DocFTPConfigComInfo.getServerIP(""+FTPConfigId));
		serverPort = Util.null2String(DocFTPConfigComInfo.getServerPort(""+FTPConfigId));
		userName = Util.null2String(DocFTPConfigComInfo.getUserName(""+FTPConfigId));
		userPassword = Util.null2String(DocFTPConfigComInfo.getUserPassword(""+FTPConfigId));
        if(!userPassword.equals("")){
		    userPassword="●●●●●●";
	    }
		defaultRootDir = Util.null2String(DocFTPConfigComInfo.getDefaultRootDir(""+FTPConfigId));
		maxConnCount = Util.getIntValue(DocFTPConfigComInfo.getMaxConnCount(""+FTPConfigId),0);
		showOrder = Util.getFloatValue(DocFTPConfigComInfo.getShowOrder(""+FTPConfigId),0);
%>
<INPUT type="hidden" name="isUseFTPOfSystem" value="<%=isUseFTPOfSystem%>">

      <TABLE class=ViewForm>
        <TBODY>
	    <COLGROUP>
	    <COL width="20%">
	    <COL width="80%">

        <TR class=Title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(20518,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px!important;">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></TD>
          <TD class=Field><INPUT type="checkbox" class=InputStyle name="isUseFTP" value="1" onclick="showFTPConfig()"  <%if("1".equals(isUseFTP)){%>checked<%}%> <%if(!canEdit){%>disabled<%}%>></TD>
        </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        </TBODY></TABLE>

    <DIV id="FTPConfigDiv" <% if("1".equals(isUseFTP)) { %> style="display:block" <% } else { %> style="display:none" <% } %>>
      <TABLE class=ViewForm>
        <TBODY>
	    <COLGROUP>
	    <COL width="20%">
	    <COL width="80%">
        <TR>
		    <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%></TD>
		    <TD class=Field>
		        <SELECT class=inputstyle name="FTPConfigId" onChange="loadDocFTPConfigInfo(this)">
<%
		            DocFTPConfigComInfo.setTofirstRow();
		            while(DocFTPConfigComInfo.next()){
%>
		                <OPTION value=<%= DocFTPConfigComInfo.getId() %> <% if(Util.getIntValue(DocFTPConfigComInfo.getId(),-1) == FTPConfigId) { %> selected <% } %> ><%= DocFTPConfigComInfo.getFTPConfigName() %></OPTION>
<%
		            }
%>
		        </SELECT>
		    </TD>
        </TR>
        <TR class="Spacing" style="height: 1px!important;"><TD class="Line" colSpan=2></TD></TR>

        <tr>
        <td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
        <td class=field><SPAN id=FTPConfigNameSpan><%=FTPConfigName%></SPAN></td>
        </tr>
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <tr>
        <td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
        <td class=field><SPAN id=FTPConfigDescSpan><%=FTPConfigDesc%></SPAN></td>
        </tr>
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=serverIPSpan><%=serverIP%></SPAN></TD>
        </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=serverPortSpan><%=serverPort%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=userNameSpan><%=userName%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=userPasswordSpan><%=userPassword%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18476,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=defaultRootDirSpan><%=defaultRootDir%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20522,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=maxConnCountSpan><%=maxConnCount%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=showOrderSpan><%=showOrder%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>		
        </TBODY></TABLE>
    </div>

<%
	}
%>

        <!-- 类型 -->
        <table class=ViewForm>
        	<col width=25%><col width=30%><col width=15%><col width=30%>
        	<TR class=Title>
            	<TH><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
            	<TD align=right>&nbsp;</TD>
          	</TR>
          	<TR class=Spacing style="height: 1px!important;">
            	<TD class=Line1 colSpan=4></TD>
         	</TR>      
<%if(software.equals("ALL")){%>
        	<tr>
        		<td><%=SystemEnv.getHtmlLabelName(16173,user.getLanguage())%></td>
        		<td class=field>
        		<select  class=InputStyle name=hasasset size=1 <%=isdisable%>>
        			<option value=1 <%if(hasasset.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%></option>
        			<option value=0 <%if(hasasset.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%></option>
        			<option value=2 <%if(hasasset.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%></option>
        		</select>
        		</td>
        		<td><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></td>
        		<td class=field>
        		<input class=InputStyle maxlength=30 size=15 name=assetlabel
        		value="<%=Util.toScreenToEdit(assetlabel,user.getLanguage())%>" <%=isdisable%>>
        		</td>
        	</tr>
    <TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
<%}%>
        	<tr>
        		<td><%=SystemEnv.getHtmlLabelName(16177,user.getLanguage())%></td>
        		<td class=field>
        		<select class=InputStyle  name=hashrmres size=1 <%=isdisable%>>
        			<option value=1 <%if(hashrmres.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%></option>
        			<option value=0 <%if(hashrmres.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%></option>
        			<option value=2 <%if(hashrmres.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%></option>
        		</select>
        		</td>
        		<td><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></td>
        		<td class=field>
        		<input class=InputStyle maxlength=30 size=15 name=hrmreslabel
        		value="<%=Util.toScreenToEdit(hrmreslabel,user.getLanguage())%>" <%=isdisable%>>
        		</td>
        	</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
<%if(software.equals("ALL") || software.equals("CRM")){%>
        	<tr>
        		<td>CRM<%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></td>
        		<td class=field>
        		<select class=InputStyle  name=hascrm size=1 <%=isdisable%>>
        			<option value=1 <%if(hascrm.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%></option>
        			<option value=0 <%if(hascrm.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%></option>
        			<option value=2 <%if(hascrm.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%></option>
        		</select>
        		</td>
        		<td><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></td>
        		<td class=field>
        		<input class=InputStyle maxlength=30 size=15 name=crmlabel
        		value="<%=Util.toScreenToEdit(crmlabel,user.getLanguage())%>" <%=isdisable%>>
        		</td>
        	</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
        	<tr>
        		<td><%=SystemEnv.getHtmlLabelName(16178,user.getLanguage())%></td>
        		<td class=field>
        		<select class=InputStyle  name=hasproject size=1 <%=isdisable%>>
        			<option value=1 <%if(hasproject.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16174,user.getLanguage())%></option>
        			<option value=0 <%if(hasproject.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16175,user.getLanguage())%></option>
        			<option value=2 <%if(hasproject.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16176,user.getLanguage())%></option>
        		</select>
        		</td>
        		<td><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></td>
        		<td class=field>
        		<input class=InputStyle maxlength=30 size=15 name=projectlabel
        		value="<%=Util.toScreenToEdit(projectlabel,user.getLanguage())%>" <%=isdisable%>>
        		</td>
        	</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
<%}%>
        </table>
      <%--
	  </TD>
    <TD></TD>
      <TD vAlign=top>
      --%>
        <!-- 安全信息 -->
        <table class=ViewForm style="display:none">
          <colgroup> <col width="30%"> <col width="70%"> <tbody>
          <tr class=Title>
            <th><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></th>
          </tr>
          <tr class=Spacing>
            <td class=Line1 colspan=2></td>
          </tr>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1003,user.getLanguage())%></td>
            <td class=Field>
              <%if(canEdit){%>
              <button type='button' class=browser onclick="onShowWorkflow()"></button>
              <%}else{%>
              <INPUT class=wuiBrowser _displayText="<%=Util.toScreen(WorkflowComInfo.getWorkflowname(approvewfid),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1" type=hidden name="approvewfid" id="approvewfid" value="<%=approvewfid %>" >
              <%} %>
              <span id=approvewfspan></span>
              <input type=hidden name="approvewfid" value="<%=approvewfid%>">
            </td>
          </tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          </tbody>
        </table>
        <div style="display:none">
        <!--创建文档权限设置-->
        <%
           int[] labels = {58,125,385};
           int operationcode = AclManager.OPERATION_CREATEDOC;
           int categorytype = AclManager.CATEGORYTYPE_SEC;
        %>
        <%@ include file="/docs/category/PermissionList.jsp" %>
        <!--复制文档权限设置-->
        <%
           labels[1] = 77;
           operationcode = AclManager.OPERATION_COPYDOC;
        %>
        <%@ include file="/docs/category/PermissionList.jsp" %>
        <!--移动文档权限设置-->
        <%
           labels[1] = 78;
           operationcode = AclManager.OPERATION_MOVEDOC;
        %>
        <%@ include file="/docs/category/PermissionList.jsp" %>
        </div>
        <!--TD2858 新的需求: 添加与文档创建人相关的默认共享(内部人员)  开始-->    
        <table class="viewform" width="100%" style="display:none">      
           <COLGROUP>
            <COL width="30%">
            <COL width="70%">
           </COLGROUP>
           <tr class=Title>
            <th colspan=2><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18590,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(18589,user.getLanguage())%>)</th>
           </tr>
           <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr class=Spacing style="height: 1px!important;">
            <td class=Line1 colspan=2></td>
          </tr>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(18582,user.getLanguage())%></td>
            <td class=Field> 
             
                <table width="100%">
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
                            <select name="PDocCreater">            
                                <option value="0" <%if("0".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
                                <option value="3"  <%if("3".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                                </select>
                        </td>
                    </tr>
                </table>
                
            </td>
          </tr>   
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(18583,user.getLanguage())%></td>
            <td class=Field>     
            
               <table width="100%">
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
                            <select name="PCreaterManager">            
                                <option value="0"  <%if("0".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
                                <option value="3"  <%if("3".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select>  
                        </td>
                    </tr>
                </table>  
                  
            </td>
          </tr> 
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>        
           <input type="hidden" name="PCreaterJmanager" value="0">    
           <input type="hidden" name="PCreaterDownOwner" value="0"> 
           <tr>
            <td><%=SystemEnv.getHtmlLabelName(18584,user.getLanguage())%></td>
            <td class=Field>              
                <table width="100%">
                    <tr>
                        <td width="60%">
                            <div id="PCreaterSubCompLDiv"   <%if("0".equals(PCreaterSubComp)) {out.println(" style=\"display:none\"" );}%> align="left">   
                                   <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>= <input value="<%=PCreaterSubCompLS%>"  class="inputStyle" type="text" size="4" name="PCreaterSubCompLS">
                            </div>
                        </td>
                        <td width="40%">
                            <select name="PCreaterSubComp" onchange="onSelectChange(this,PCreaterSubCompLDiv)">            
                                <option value="0"  <%if("0".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>   
                                <option value="3"  <%if("3".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select>   
                        </td>
                    </tr>
                </table>                  
                
              
            </td>
          </tr>  
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
           <tr>
            <td><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></td>
            <td class=Field>   
                <table width="100%">
                    <tr>
                        <td width="60%">
                            <Div id="PCreaterDepartLDiv"   <%if("0".equals(PCreaterDepart)) {out.println(" style=\"display:none\"" );}%> align="left">                            
                                     <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>= <input value="<%=PCreaterDepartLS%>"  class="inputStyle" type="text" size="4" name="PCreaterDepartLS">
                           </Div>
                        </td>
                        <td width="40%">
                            <select name="PCreaterDepart" onchange="onSelectChange(this,PCreaterDepartLDiv)">            
                                <option value="0" <%if("0".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1" <%if("1".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2" <%if("2".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
                                <option value="3"  <%if("3".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select> 
                        </td>
                    </tr>
                </table>                 
            </td>
          </tr>  
           <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

           </table>


           <table class="viewform" width="100%" style="display:none">      
           <COLGROUP>
            <COL width="30%">
            <COL width="70%">
           </COLGROUP>
           <tr class=Title>
            <th colspan=2><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18590,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(2209,user.getLanguage())%>)</th>
           </tr>
           <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr class=Spacing style="height: 1px!important;">
            <td class=Line1 colspan=2></td>
          </tr>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(18582,user.getLanguage())%></td>
            <td class=Field> 
             
                <table width="100%">
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
                            <select name="PDocCreaterW">            
                                <option value="0" <%if("0".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
                                <option value="3"  <%if("3".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                                </select>
                        </td>
                    </tr>
                </table>
                
            </td>
          </tr>   
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></td>
            <td class=Field>     
            
               <table width="100%">
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
                            <select name="PCreaterManagerW">            
                                <option value="0"  <%if("0".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
                                <option value="3"  <%if("3".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select>  
                        </td>
                    </tr>
                </table>  
                  
            </td>
          </tr> 
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>          
          <input type="hidden" name="PCreaterJmanagerW" value="0">    
          </Table>
           <!--TD2858 新的需求: 添加与文档创建人相关的默认共享  结束-->           
        
        <!--默认共享-->
        <table class=ViewForm  style="display:none">
          <colgroup>
          <col width="8%">
          <col width="40%">
          <col width="52%">
          <tr class=Title >
            <th colspan=2><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18598,user.getLanguage())%>)</th>
            <td align=right>
            <%if(canEdit){%> 
                <input type="checkbox" name="chkAll" onclick="chkAllClick(this)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
                &nbsp;                         
                <a href="/docs/docs/DocShareAddBrowser.jsp?para=1_<%=id%>" target="mainFrame"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;                 
                <a href="javaScript:onDelShare()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
            <%}%>            
            </td>
          </tr>
          <tr class=Spacing style="height: 1px!important;">
            <td class=Line1 colspan=3></td>
          </tr>
<%
	//查找已经添加的默认共享
	RecordSet.executeProc("DocSecCategoryShare_SBySecID",id+"");
	while(RecordSet.next()){
		if(RecordSet.getInt("sharetype")==1)	{%>
	        <TR>
              <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			  
	        </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
	    <%}else if(RecordSet.getInt("sharetype")==2)	{%>
	        <TR>
               <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			 
	        </TR>
        <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}else if(RecordSet.getInt("sharetype")==3)	{%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			 
	        </TR>
        <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}else if(RecordSet.getInt("sharetype")==4)	{%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(RolesComInfo.getRolesname(RecordSet.getString("roleid")),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                
			  </TD>			 
	        </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}else if(RecordSet.getInt("sharetype")==5)	{%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			  
	        </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
       <%}else if(RecordSet.getInt("sharetype")==9)  {//具体客户%>  
            <TR>
             <TD><INPUT TYPE='checkbox'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
              <TD class=Field><%=SystemEnv.getHtmlLabelName(18647,user.getLanguage())%></TD>
              <TD class=Field>
                <%=CustomerInfoComInfo.getCustomerInfoname(Util.null2String(RecordSet.getString("crmid")))%>/
                <% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
              </TD>           
            </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
	    <%}else if(RecordSet.getInt("sharetype")<0)	{
	    		String crmtype= "" + ((-1)*RecordSet.getInt("sharetype")) ;
	    		String crmtypename=CustomerTypeComInfo.getCustomerTypename(crmtype);
	    		%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId'></TD>
	          <TD class=Field><%=Util.toScreen(crmtypename,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			 
	        </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}%>
<%	}%>
        </table>
      </TD></TR>
    </TBODY>
  </TABLE>

   <SCRIPT language="javaScript">
       function onSelectChange(obj1,obj2){
            var selectValue = obj1.value;
            if (selectValue!=0) obj2.style.display="";
            else  obj2.style.display="none";           
       }
   
   </SCRIPT>

<%--
<% --自定义字段-- %>
<SCRIPT LANGUAGE=javascript>
function addrow(){
	var oRow;
	var oCell;

	oRow = inputface.insertRow();
	oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = flable.innerHTML ;
	oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = fhtmltype.innerHTML;
	oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = ftype1.innerHTML ;
	oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = ftype5.innerHTML ;
	oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
    oCell.innerHTML = fismand.innerHTML ;
	oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = action.innerHTML ;

}

function addrow2(obj){
	var tobj = obj.parentElement.parentElement.cells[3].childNodes[0];
	var oRow;
	var oCell;

	oRow = tobj.insertRow();
	oCell = oRow.insertCell();
	oCell.innerHTML = fselectitem.innerHTML ;
	oCell = oRow.insertCell();
	oCell.innerHTML = itemaction.innerHTML ;

}

function delitem(obj){
	var rowobj = obj.parentElement.parentElement;

	rowobj.parentElement.deleteRow(rowobj.rowIndex);

}

function upitem(obj){
	if(obj.parentElement.parentElement.rowIndex==0){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex-1);
	for(var i=0; i<2; i++){
		var cellobj = rowobj.insertCell()
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}

	tobj.deleteRow(obj.parentElement.parentElement.rowIndex);

}

function downitem(obj){
	if(obj.parentElement.parentElement.rowIndex==obj.parentElement.parentElement.parentElement.rows.length-1){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex+2);
	for(var i=0; i<2; i++){
		var cellobj = rowobj.insertCell()
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}

	tobj.deleteRow(obj.parentElement.parentElement.rowIndex);

}

function del(obj){
	var rowobj = obj.parentElement.parentElement;

	rowobj.parentElement.deleteRow(rowobj.rowIndex);

}

function up(obj){
	if(obj.parentElement.parentElement.rowIndex==0){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex-1);
	for(var i=0; i<6; i++){
		var cellobj = rowobj.insertCell()
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}

	tobj.deleteRow(obj.parentElement.parentElement.rowIndex);

}

function down(obj){
	if(obj.parentElement.parentElement.rowIndex==obj.parentElement.parentElement.parentElement.rows.length-1){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex+2);
	for(var i=0; i<6; i++){
		var cellobj = rowobj.insertCell()
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}

	tobj.deleteRow(obj.parentElement.parentElement.rowIndex);

}

function htmltypeChange(obj){
	if(obj.selectedIndex == 0){
		obj.parentElement.parentElement.cells[2].innerHTML=ftype1.innerHTML ;
		obj.parentElement.parentElement.cells[3].innerHTML=ftype5.innerHTML ;
	}else if(obj.selectedIndex == 2){
		obj.parentElement.parentElement.cells[2].innerHTML=ftype2.innerHTML ;
		obj.parentElement.parentElement.cells[3].innerHTML=ftype4.innerHTML ;
	}else if(obj.selectedIndex == 4){
		obj.parentElement.parentElement.cells[2].innerHTML=fselectaction.innerHTML ;
		obj.parentElement.parentElement.cells[3].innerHTML=fselectitems.innerHTML ;
	}else{
		obj.parentElement.parentElement.cells[2].innerHTML=ftype3.innerHTML ;
		obj.parentElement.parentElement.cells[3].innerHTML=ftype4.innerHTML ;
	}
}

function typeChange(obj){
	if(obj.selectedIndex == 0){
		obj.parentElement.parentElement.cells[3].innerHTML=ftype5.innerHTML ;
	}else{
		obj.parentElement.parentElement.cells[3].innerHTML=ftype4.innerHTML ;
	}
}

function clearTempObj(){
    flable.innerHTML="";
    fhtmltype.innerHTML="";
    ftype1.innerHTML="";
    ftype2.innerHTML="";
    ftype3.innerHTML="";
    ftype4.innerHTML="";
    ftype5.innerHTML="";
    fselectaction.innerHTML="";
    fselectitems.innerHTML="";
    fselectitem.innerHTML="";
    fismand.innerHTML="";
}

var selectRowObj;
function importSel(obj){
    selectRowObj = obj;
    //id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CustomSelectFieldBrowser.jsp");
    var ret = showSelectRow();
    if(ret != ""){
        document.all("selectItemGetter").src="SelectRowGetter.jsp?fieldid="+ret;
    }
}

</SCRIPT>

<script language="VbScript">
function showSelectRow()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CustomSelectFieldBrowser.jsp")
	if (Not IsEmpty(id)) then
        showSelectRow=id(0)
	else
        showSelectRow=""
    end if
end function
</script>
<iframe name="selectItemGetter" style="width:100%;height:200;display:none"></iframe>

<div style="display:none">

<%
    String disableLable = "disabled";
    if(canEdit){
        disableLable="";
%>
<hr>
<BUTTON Class=Btn type=button accessKey=A onclick="addrow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%></BUTTON>
<%
    }
%>
<div style="DISPLAY: none" id="flable">
<%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%>:<input  class=InputStyle name="fieldlable"><input  type="hidden" name="fieldid" value="-1">
</div>

<div style="DISPLAY: none" id="fhtmltype">
	<%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>:
    <select size="1" name="fieldhtmltype" onChange = "htmltypeChange(this)">
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
		<option value="2" ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
		<option value="3" ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
		<option value="4" ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
		<option value="5" ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
    </select>
</div>

<div style="DISPLAY: none" id="ftype1">
	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
	<select size=1 name=type onChange = "typeChange(this)">
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
	</select>
</div>

<div style="DISPLAY: none" id="ftype2">
	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
	<select size=1 name=type>
    <%while(BrowserComInfo.next()){%>
		<option value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),7)%></option>
    <%}%>
	</select>
</div>

<div style="DISPLAY: none" id="ftype3">
	<input name=type type=hidden value="0">
</div>

<div style="DISPLAY: none" id="ftype4">
	<input name=flength type=hidden  value="100">
</div>

<div style="DISPLAY: none" id="ftype5">
	<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>:<input  class=InputStyle name=flength type=text value="100" maxlength=4 style="width:50">
</div>

<div style="DISPLAY: none" id="fismand">
	<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>:
	<select size=1 name=ismand>
		<option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
		<option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	</select>
</div>

<div style="DISPLAY: none" id="fselectaction">
	<input name=type type=hidden  value="0">
	<BUTTON Class=Btn type=button accessKey=A onclick="addrow2(this)"><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></BUTTON><br>
    <BUTTON Class=Btn type=button accessKey=I onclick="importSel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></BUTTON>
</div>
<div style="DISPLAY: none" id="fselectitems">
	<TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 >
	<COLGROUP>
		<col width="40%">
		<col width="60%">
	</COLGROUP>
	</TABLE>
    <input name=selectitemid type=hidden value="--">
	<input name=selectitemvalue type=hidden >

    <input name=flength type=hidden  value="100">
</div>

<div style="DISPLAY: none" id="fselectitem">
	<input name=selectitemid type=hidden value="-1" >
	<input  class=InputStyle name=selectitemvalue type=text style="width:100">
</div>

<div style="DISPLAY: none" id="itemaction">
    <img src="/images/icon_ascend.gif" height="14" onclick="upitem(this)">
    <img src="/images/icon_descend.gif" height="14" onclick="downitem(this)">
	<img src="/images/delete.gif" height="14" onclick="delitem(this)">
</div>

<div style="DISPLAY: none" id="action">
    <img src="/images/icon_ascend.gif" height="14" onclick="up(this)">
    <img src="/images/icon_descend.gif" height="14" onclick="down(this)">
	<img src="/images/delete.gif" height="14" onclick="del(this)">
</div>
<hr>

</div>

<%
    CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",id);
    cfm.getCustomFields();
%>
<TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 id="inputface"  style="display:none">
<COLGROUP>
	<col width="23%" valign="top">
	<col width="20%" valign="top">
	<col width="22%" valign="top">
	<col width="18%" valign="top">
	<col width="10%" valign="top">
	<col width="7%" valign="top">
    <%while(cfm.next()){%>
    <tr>
    <td style="border-bottom:silver 1pt solid"><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%>:<input  class=InputStyle name="fieldlable" value="<%=cfm.getLable()%>" <%=disableLable%>><input  type="hidden" name="fieldid" value="<%=cfm.getId()%>" ></td>
    <td style="border-bottom:silver 1pt solid">
    <%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>:
    <%if(cfm.getHtmlType().equals("1")){%>
        <%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("2")){%>
        <%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("3")){%>
        <%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("4")){%>
        <%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("5")){%>
        <%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%>
    <%} %>
    <input name="fieldhtmltype" type="hidden" value="<%=cfm.getHtmlType()%>" >
    </td>

    <%if(cfm.getHtmlType().equals("1")){%>
        <td style="border-bottom:silver 1pt solid">
        <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
        <%if(cfm.getType() == 1){%>
            <%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%>
        <%} else if(cfm.getType() == 2){%>
            <%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%>
        <%} else if(cfm.getType() == 3){%>
            <%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%>
        <%} %>
        <input name=type type="hidden" value="<%=cfm.getType()%>">
        </td>
        <td style="border-bottom:silver 1pt solid">
            <%if(cfm.getType()==1){%>
                <%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>:<%=cfm.getStrLength()%>
                <input  name=flength type=hidden  value="<%=cfm.getStrLength()%>">
            <%}else{%>
                <input name=flength type=hidden  value="100">
            <%}%>
        </td>
    <%}else if(cfm.getHtmlType().equals("3")){%>
        <td style="border-bottom:silver 1pt solid">
            <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(String.valueOf(cfm.getType())),0),7)%>
            <input name=type type="hidden" value="<%=cfm.getType()%>">
        </td>
        <td style="border-bottom:silver 1pt solid">
            <input name=flength type=hidden  value="100">
        </td>
    <%}else if(cfm.getHtmlType().equals("5")){%>
        <td style="border-bottom:silver 1pt solid">
            <input name=type type=hidden  value="0">
<%
    if(canEdit){
%>
            <BUTTON Class=Btn type=button accessKey=A onclick="addrow2(this)"><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></BUTTON><br>
            <BUTTON Class=Btn type=button accessKey=I onclick="importSel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></BUTTON>
<%
    }
%>
        </td>
        <td style="border-bottom:silver 1pt solid">

            <TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 >
            <COLGROUP>
                <col width="40%">
                <col width="60%">
            </COLGROUP>
     <%
        cfm.getSelectItem(cfm.getId());
        while(cfm.nextSelect()){
     %>
        <tr>
            <td>
            	<input name=selectitemid type=hidden value="<%=cfm.getSelectValue()%>" >
	            <input  class=InputStyle name=selectitemvalue type=text value="<%=cfm.getSelectName()%>" style="width:100"  <%=disableLable%>>
            </td>
            <td>
                <img src="/images/icon_ascend.gif" height="14" onclick="upitem(this)">
                <img src="/images/icon_descend.gif" height="14" onclick="downitem(this)">
                <img src="/images/delete.gif" height="14" onclick="delitem(this)">
            </td>
        </tr>

     <%}%>

            </TABLE>
            <input name=selectitemid type=hidden value="--">
            <input name=selectitemvalue type=hidden >

            <input name=flength type=hidden  value="100">
        </td>
    <%}else{%>
        <td style="border-bottom:silver 1pt solid">
            <input name=type type=hidden  value="0">
        </td>
        <td style="border-bottom:silver 1pt solid">
            <input name=flength type=hidden  value="100">
        </td>
    <%}%>
    <%%>
        <td style="border-bottom:silver 1pt solid">
            <%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>:
            <select size=1 name=ismand  <%=disableLable%>>
                <option value="0" <%=cfm.isMand()?"":"selected"%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
                <option value="1" <%=cfm.isMand()?"selected":""%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
            </select>
        </td>
    <%%>

        <td style="border-bottom:silver 1pt solid">
            <img src="/images/icon_ascend.gif" height="14" onclick="up(this)">
            <img src="/images/icon_descend.gif" height="14" onclick="down(this)">
            <img src="/images/delete.gif" height="14" onclick="del(this)">
        </td>
    </tr>
    <%}%>

</TABLE>


<% --自定义字段结束-- %>
--%>

<p>
<p>
</form>
<%--

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
--%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script language="javascript">

function checkPositiveNumber(label,obj){
	var def = jQuery(obj).attr("defValue");
	if(obj.value<0){
		alert("'"+label+"'<%=SystemEnv.getHtmlLabelName(22065,user.getLanguage())%>")
		obj.value=def;
	}
}

function changeTemplate(data,e){
	if(data){
		if(data.id!="0"&&data.id!=""){
			if (confirm("<%=SystemEnv.getHtmlLabelName(18767,user.getLanguage())%>",49,"<%=SystemEnv.getHtmlLabelName(558,user.getLanguage())%>")){
				window.parent.location="DocSecCategorySaveAsTmplOperation.jsp?secCategoryId=<%=id%>&tmplId="+data.id+"&method=getsettingfromtmpl"
			}
		}else{
			$GetEle("dirmouldid").value="";
			$GetEle("dirmouldidSpan").innerHTML="";
		}
	}
}
function onSaveAsTmpl(obj){
	window.parent.location="DocSecCategorySaveAsTmpl.jsp?id=<%=id%>";
}
function onSave(obj){
	obj.disabled = true;
	if(check_form(document.weaver,'categoryname')){
		document.weaver.operation.value="edit";
		//clearTempObj();
		document.weaver.submit();
	}else{
		obj.disabled = false;
	}
}
function onNew(){
	window.parent.location="DocSecCategoryAdd.jsp?id=<%=subcategoryid%>&mainid=<%=mainid%>";
}
function onLog(){
	window.parent.location="/systeminfo/SysMaintenanceLog.jsp?secid=66&sqlwhere=where operateitem=3 and relatedid=<%=id%>";
}
function onDelete(){
	if(isdel()) {
		document.weaver.operation.value="delete";
		document.weaver.submit();
	}
}
function onMarkableClick(){
    if (document.all("markable").checked){
        document.all("markAnonymity").disabled = false ;
    } else {
        document.all("markAnonymity").checked = false ;
        document.all("markAnonymity").disabled = true ;
    }
}

//与共享相关的操作 
 function onOrderAbleClick(obj,obj2,obj3) {
     if (obj.checked){
         obj2.checked = true;
         obj3.checked = true;
         obj2.disabled = true;
         obj3.disabled = false ;
     } else {
         obj2.disabled = false ;
         obj3.disabled = true ;
     }
 }
function allowAddSharer3Onclick(obj) { //完全控制者
    if (obj.checked){       
    } else {
        if (document.getElementById("allowAddSharer4").checked||document.getElementById("allowAddSharer5").checked){
            if(!window.confirm("确认具有完全控制权限者将不能共享此目录下的文档吗")) {
                obj.checked = true ;
            }
        }
    }

}

function allowAddSharer4Onclick(obj) { //编辑权限者
    if (obj.checked){
       document.getElementById("allowAddSharer3").checked = true; 
    }else {
        if (document.getElementById("allowAddSharer5").checked){
            if(!window.confirm("确认具有编辑权限者将不能共享此目录下的文档吗")) {
                obj.checked = true ;
            }
        }
    }

}

function allowAddSharer5Onclick(obj) { //查看权限者
    if (obj.checked){
       document.getElementById("allowAddSharer3").checked = true; 
       document.getElementById("allowAddSharer4").checked = true;
    }
}
  function chkAllClick(obj){   
    var chks = document.getElementsByName("chkShareId");    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }    
}
function onDelShare(){   
    document.weaver.action="ShareOperation.jsp?secid=<%=id%>&method=delMShare";
    document.weaver.submit();
}

function showFTPConfig(){
    if(document.all("isUseFTP").checked){
        document.all("FTPConfigDiv").style.display = "block";
    }else{
    	document.all("FTPConfigDiv").style.display = "none";
    }
}

function loadDocFTPConfigInfo(obj){
	document.all("DocFTPConfigInfoGetter").src="DocFTPConfigIframe.jsp?operation=loadDocFTPConfigInfo&FTPConfigId="+obj.value;
}


function returnDocFTPConfigInfo(FTPConfigName,FTPConfigDesc,serverIP,serverPort,userName,userPassword,defaultRootDir,maxConnCount,showOrder){
	FTPConfigNameSpan.innerHTML=FTPConfigName;
	FTPConfigDescSpan.innerHTML=FTPConfigDesc;
	serverIPSpan.innerHTML=serverIP;
	serverPortSpan.innerHTML=serverPort;
	userNameSpan.innerHTML=userName;
	userPasswordSpan.innerHTML=userPassword;
	defaultRootDirSpan.innerHTML=defaultRootDir;
	maxConnCountSpan.innerHTML=maxConnCount;
	showOrderSpan.innerHTML=showOrder;
}
function setBacthDownload(o){
    var bacthDownload = document.getElementById("bacthDownload");
 	if(o.checked){
 	 //bacthDownload.value="1";
 	 //bacthDownload.checked="true";
 	 bacthDownload.disabled="true"
 	 
 	}else{
 	  //bacthDownload.value="";
 	  //bacthDownload.checked=false;
 	  bacthDownload.disabled=false;

 	}
 }
</script>
<script type="text/javascript">
 $(document).ready(function(){
    $($GetEle("noDownload")).click(function(){
	    if($($GetEle("noDownload")).attr("checked")==true){
	         $($GetEle("bacthDownload")).attr("disabled","disabled");
	    }else{
	          $($GetEle("bacthDownload")).removeAttr("disabled");
	    }
   });
 });
</script>
</BODY></HTML>
