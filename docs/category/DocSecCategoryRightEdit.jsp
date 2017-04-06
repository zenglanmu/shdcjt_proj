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
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SysDefaultsComInfo" class="weaver.docs.tools.SysDefaultsComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="HrmOrgGroupComInfo" class="weaver.hrm.orggroup.HrmOrgGroupComInfo" scope="page" />

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
	String coder=Util.toScreenToEdit(RecordSet.getString("coder"),user.getLanguage());
	String subcategoryid=RecordSet.getString("subcategoryid");
	String docmouldid=RecordSet.getString("docmouldid");
	/* added by wdl 2006.7.3 TD.4617 start */
	String wordmouldid = RecordSet.getString("wordmouldid");
	/* added end */
	String publishable=RecordSet.getString("publishable");
	String replyable=RecordSet.getString("replyable");
	String shareable=RecordSet.getString("shareable");

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

    int markable=Util.getIntValue(Util.null2String(RecordSet.getString("markable")),0);
    int markAnonymity=Util.getIntValue(Util.null2String(RecordSet.getString("markAnonymity")),0);
    int orderable=Util.getIntValue(Util.null2String(RecordSet.getString("orderable")),0);
    int defaultLockedDoc=Util.getIntValue(Util.null2String(RecordSet.getString("defaultLockedDoc")),0);
    int isSetShare=Util.getIntValue(Util.null2String(RecordSet.getString("isSetShare")),0);
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
    
    int maxUploadFileSize=Util.getIntValue(Util.null2String(RecordSet.getString("maxUploadFileSize")),0);
    int allownModiMShareL=Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMShareL")),0);
    int allownModiMShareW=Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMShareW")),0);
    String allowShareTypeStrs=Util.null2String(RecordSet.getString("allowShareTypeStrs"));
    ArrayList allowShareTypeList = Util.TokenizerString(allowShareTypeStrs,",");
    
    int noDownload = Util.getIntValue(Util.null2String(RecordSet.getString("nodownload")),0);
    int noRepeatedName = Util.getIntValue(Util.null2String(RecordSet.getString("norepeatedname")),0);
    int isControledByDir = Util.getIntValue(Util.null2String(RecordSet.getString("iscontroledbydir")),0);
    int pubOperation = Util.getIntValue(Util.null2String(RecordSet.getString("puboperation")),0);
    int childDocReadRemind = Util.getIntValue(Util.null2String(RecordSet.getString("childdocreadremind")),0);
    int readOpterCanPrint = Util.getIntValue(Util.null2String(RecordSet.getString("readoptercanprint")),0);

    float secorder = Util.getFloatValue(Util.null2String(RecordSet.getString("secorder")),0);

	boolean canEdit = false;
	boolean canAdd = false;
	boolean canDelete = false;
	boolean canLog = false;
	boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	//hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
	hasSecManageRight = am.hasPermission(id, AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_CREATEDIR);
	//hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
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

/** TD12005 文档下载权限控制    开始 */
String PCreaterDL = "1";
String PCreaterManagerDL = "1";
String PCreaterSubCompDL = "0";
String PCreaterDepartDL = "0";
String PCreaterWDL = "1";
String PCreaterManagerWDL = "1";
/** TD12005 文档下载权限控制   结束 */

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
    /** TD12005 文档下载权限控制    开始 ======数据库添加以下字段========== */
    PCreaterDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterDL")), PCreater);
    PCreaterManagerDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterManagerDL")), PCreaterManager);
    PCreaterSubCompDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterSubCompDL")), PCreaterSubComp);
    PCreaterDepartDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterDepartDL")), PCreaterDepart);
    PCreaterWDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterWDL")), PCreaterW);
    PCreaterManagerWDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterManagerWDL")), PCreaterManagerW);
    /** TD12005 文档下载权限控制   结束 */
}

//是否有效
String isDownloadDisabled = "";
if(noDownload == 1) isDownloadDisabled ="disabled";
if(!canEdit){
	isDownloadDisabled ="disabled";
}
%>
<%!
/** TD12005 文档下载权限控制   开始 */
private String getDLVisible(String strValue) {
    //是否可见
    String strShow = "";
    if(!"1".equals(strValue)) strShow ="none";
    return strShow;
}

private String getDLChecked(String strCheckValue) {
    //是否选中
    String strChecked = "";
    if("1".equals(strCheckValue)) strChecked ="checked";
    return strChecked;
}

//根据操作权限，共享下载权限判断最终的下载权限
private String setDLValueInit(String strDLValue, String strOprateValue) {
	String strDLNewValue = "0";
	if (strDLValue != null && !"".equals(strDLValue)) {
		strDLNewValue = strDLValue;
	} else if("1".equals(strOprateValue) || "2".equals(strOprateValue) || "3".equals(strOprateValue)) {
		strDLNewValue = "1";
	} else if("0".equals(strOprateValue)) {
		strDLNewValue = "0";
	}
	return strDLNewValue;
}
/** TD12005 文档下载权限控制   结束 */
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
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlNoteName(messageid,user.getLanguage())%></font></DIV>
<%}%>
<%
if(errorcode == 10) {
%>
	<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
<%}%>
<FORM id=weaver name=weaver action="SecCategoryOperation.jsp" method=post>
<input type=hidden name="operation">
<input type=hidden name="id" value="<%=id%>">
<input type=hidden name="fromtab" value="1">
<input type=hidden name="fromSecSet" value="right">
<%
//if(HrmUserVarify.checkUserRight("DocSubCategoryEdit:Edit", user)){
if (canEdit) {
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%--
<%
}if(canAdd){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onNew(),_top} " ;
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
--%>
<%
}
%>
 <TABLE class=ViewForm>
 
  <TBODY>
  <TR>
    <TD vAlign=top>
    	<!-- 细节 -->
        <TABLE class=ViewForm style="display:none">
          <COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY>
          <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
            <td align=right><A href="DocMainCategory.jsp" target="mainFrame"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></A>
             ><A href="DocMainCategoryEdit.jsp?id=<%=mainid%>" target="mainFrame"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></A>
<%            RecordSet rs = cm.getSuperiorSubCategoryList(id, AclManager.CATEGORYTYPE_SEC);
              while (rs.next()) {         %>
               >
                <A href="DocSubCategoryEdit.jsp?id=<%=rs.getInt("subcategoryid")%>" target="mainFrame"><%=Util.toScreen(rs.getString("subcategoryname"), user.getLanguage())%></A>
<%            }                           %>
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
            <TD class=Field><input type=hidden name="subcategoryid" value="<%=subcategoryid%>"><%=SubCategoryComInfo.getSubCategoryname(""+subcategoryid)%>
            </TD>
          </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TD>
            <TD class=Field><%if(canEdit){%>
            <INPUT class=InputStyle maxLength=30 size=30 name=categoryname value="<%=categoryname%>" onChange="checkinput('categoryname','categorynamespan')"><%}else{%><%=categoryname%><%}%>
            <INPUT type=hidden maxLength=30 size=30 name=srccategoryname value="<%=categoryname%>" >
            <span id=categorynamespan><%if(categoryname.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
            </TD>
          </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19389,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT maxLength=20 size=20 class=InputStyle name="coder" value="<%=coder%>"><%}else{%><%=coder%><%}%></TD>
         </TR>

<%-- 目录模版 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(19456,user.getLanguage())%></td>
            <td class=Field>
              <%if(canEdit){%>
              <button type='button' class=Browser onclick="onShowDirMould()"></button>
              <%}%>
            <span id=dirmouldidname></span>
              <input class=InputStyle type=hidden name=dirmouldid value="">
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


<TR><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td> <%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></td>
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
    <TD class=Field><INPUT class=InputStyle type=checkbox <%if(orderable==1){%>checked<%}%> value=1 name="orderable" <%=isdisable%>></TD>
</TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(18573,user.getLanguage())%></TD>           
            <TD class=Field>
                <%
                ischeck="";
                if(shareable.equals("1")) ischeck=" checked";
                %>
                  <%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%><input type="checkbox" name="allownModiMShareL" class="inputstyle" value="1" <%if(allownModiMShareL==1){out.println("checked");}%> <%=isdisable%>>
                &nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18574,user.getLanguage())%><INPUT class=InputStyle type=checkbox value=1 name=shareable <%=ischeck%> <%=isdisable%>>                  
            </TD>
          
          </TR>
          
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19435,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(isSetShare==1){%>checked<%}%> value=1 name="isSetShare" <%=isdisable%>>
            </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(18575,user.getLanguage())%></TD>
            <TD class=Field>           
              <INPUT class=InputStyle type=checkbox <%if(markable==1){%>checked<%}%> value=1 name="markable" onclick="onMarkableClick()" <%=isdisable%>>
            </TD>
          </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox  <%if(markable!=1){%>disabled<%}%> <%if(markAnonymity==1){%>checked<%}%> value=1 name="markAnonymity" <%=isdisable%>>
          </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(18578,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(defaultLockedDoc==1){%>checked<%}%> value=1 name="defaultLockedDoc" <%=isdisable%>>
            </TR>

<%-- 禁止文档下载 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19458,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(noDownload==1){%>checked<%}%> value=1 name="noDownload" <%=isdisable%>>
            </TR>

        
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(18580,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=input size=4 name="maxUploadFileSize" value="<%=maxUploadFileSize%>" <%=isdisable%>>M
          </TR>

<%-- 禁止文档重名 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(noRepeatedName==1){%>checked<%}%> value=1 name="noRepeatedName" <%=isdisable%>>
            </TR>

<%-- 是否受控目录 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19459,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(isControledByDir==1){%>checked<%}%> value=1 name="isControledByDir" <%=isdisable%>>
            </TR>

<%-- 发布操作 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19460,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(pubOperation==1){%>checked<%}%> value=1 name="pubOperation" <%=isdisable%>>
            </TR>

<%-- 子文档阅读提醒 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19461,user.getLanguage())%></TD>
            <TD class=Field>
                <INPUT class=InputStyle type=checkbox <%if(childDocReadRemind==1){%>checked<%}%> value=1 name="childDocReadRemind" <%=isdisable%>>
            </TR>

<%-- 允许只读操作人打印 --%>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19462,user.getLanguage())%></TD>
            <TD class=Field>
        		<select  class=InputStyle name=readOpterCanPrint size=1 <%=isdisable%>>
        			<option value=1 <%if(readOpterCanPrint==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%></option>
        			<option value=0 <%if(readOpterCanPrint==0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(233,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%></option>
        			<option value=2 <%if(readOpterCanPrint==2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19463,user.getLanguage())%></option>
        		</select>
            </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>  
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
          <TD class=Field><INPUT maxLength=5 size=5 class=InputStyle name="secorder" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("secorder")' value="<%=secorder%>"></TD>
         </TR>        
          
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>
        <!-- 类型 -->
        <table class=ViewForm style="display:none">
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
        		<td><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></td>
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
        		<td><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></td>
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
        		<td><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></td>
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
        		<td><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></td>
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
          <tr class=Spacing style="height: 1px!important;"> 
            <td class=Line1 colspan=2></td>
          </tr>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1003,user.getLanguage())%></td>
            <td class=Field>
              <%if(canEdit){%>
              <button type='button' class=browser onclick="onShowWorkflow()"></button>
              <%}%>
              <span id=approvewfspan><%=Util.toScreen(WorkflowComInfo.getWorkflowname(approvewfid),user.getLanguage())%></span>
              <input type=hidden name="approvewfid" value="<%=approvewfid%>">
            </td>
          </tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          </tbody>
        </table>
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
        <!--TD2858 新的需求: 添加与文档创建人相关的默认共享(内部人员)  开始-->    
        <table class="viewform" width="100%">      
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
<!-- TD12005 文档下载权限控制（文档创建人）    开始 -->
                <%
                //是否可见
                String isDownloadShow = this.getDLVisible(PCreater);
                //是否选中
                String isDownloadCheck = this.getDLChecked(PCreaterDL);
                %>
<!-- TD12005 文档下载权限控制（文档创建人）    结束 -->
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
<!-- TD12005 文档下载权限控制（文档创建人）    ONCHANGE添加 -->
                            <select name="PDocCreater" <%=isdisable%> onchange="onOptionChange('PDocCreater')">
                                <option value="0" <%if("0".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
                                <option value="3"  <%if("3".equals(PCreater)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                                </select>
<!-- TD12005 文档下载权限控制（文档创建人）    复选框对象添加 -->
                            <input class='InputStyle' type='checkbox' name='chkPDocCreater' id='chkPDocCreater' value='<%=PCreaterDL%>' style='display:<%=isDownloadShow%>' <%=isDownloadCheck%> <%=isDownloadDisabled%> onclick="setCheckbox(this)"><label for='chkPDocCreater' id='lblPDocCreater' style='display:<%=isDownloadShow%>'><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>
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
<!-- TD12005 文档下载权限控制（创建人经理）    开始 -->
                <%
                //是否可见
                isDownloadShow = this.getDLVisible(PCreaterManager);
                //是否选中
                isDownloadCheck = this.getDLChecked(PCreaterManagerDL);
                %>
<!-- TD12005 文档下载权限控制（创建人经理）    结束 -->
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
<!-- TD12005 文档下载权限控制（创建人经理）    ONCHANGE添加 -->
                            <select name="PCreaterManager" <%=isdisable%> onchange="onOptionChange('PCreaterManager')">
                                <option value="0"  <%if("0".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
                                <option value="3"  <%if("3".equals(PCreaterManager)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select>  
<!-- TD12005 文档下载权限控制（创建人经理）    复选框对象添加 -->
                            <input class='InputStyle' type='checkbox' name='chkPCreaterManager' id='chkPCreaterManager' value='<%=PCreaterManagerDL%>' style='display:<%=isDownloadShow%>' <%=isDownloadCheck%> <%=isDownloadDisabled%> onclick="setCheckbox(this)"><label for='chkPCreaterManager' id='lblPCreaterManager' style='display:<%=isDownloadShow%>'><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>
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
<!-- TD12005 文档下载权限控制（创建人分部）    开始 -->
                <%
                //是否可见
                isDownloadShow = this.getDLVisible(PCreaterSubComp);
                //是否选中
                isDownloadCheck = this.getDLChecked(PCreaterSubCompDL);
                %>
<!-- TD12005 文档下载权限控制（创建人分部）    结束 -->
                    <tr>
                        <td width="60%">
                            <div id="PCreaterSubCompLDiv"   <%if("0".equals(PCreaterSubComp)) {out.println(" style=\"display:none\"" );}%> align="left">   
                                   <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>= <input value="<%=PCreaterSubCompLS%>"  class="inputStyle" type="text" size="4" name="PCreaterSubCompLS" <%=isdisable%>>
                            </div>
                        </td>
                        <td width="40%">
<!-- TD12005 文档下载权限控制（创建人分部）    ONCHANGE添加 -->
                            <select name="PCreaterSubComp" onchange="onSelectChange(this,PCreaterSubCompLDiv);onOptionChange('PCreaterSubComp')" <%=isdisable%>>
                                <option value="0"  <%if("0".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>   
                                <option value="3"  <%if("3".equals(PCreaterSubComp)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select>   
 <!-- TD12005 文档下载权限控制（创建人分部）    复选框对象添加 -->
                            <input class='InputStyle' type='checkbox' name='chkPCreaterSubComp' id='chkPCreaterSubComp' value='<%=PCreaterSubCompDL%>' style='display:<%=isDownloadShow%>' <%=isDownloadCheck%> <%=isDownloadDisabled%> onclick="setCheckbox(this)"><label for='chkPCreaterSubComp' id='lblPCreaterSubComp' style='display:<%=isDownloadShow%>'><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>
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
<!-- TD12005 文档下载权限控制（创建人部门）    开始 -->
                <%
                //是否可见
                isDownloadShow = this.getDLVisible(PCreaterDepart);
                //是否选中
                isDownloadCheck = this.getDLChecked(PCreaterDepartDL);
                %>
<!-- TD12005 文档下载权限控制（创建人部门）    结束 -->
                    <tr>
                        <td width="60%">
                            <Div id="PCreaterDepartLDiv"   <%if("0".equals(PCreaterDepart)) {out.println(" style=\"display:none\"" );}%> align="left">                            
                                     <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>= <input value="<%=PCreaterDepartLS%>"  class="inputStyle" type="text" size="4" name="PCreaterDepartLS" <%=isdisable%>>
                           </Div>
                        </td>
                        <td width="40%">
<!-- TD12005 文档下载权限控制（创建人部门）    ONCHANGE添加 -->
                            <select name="PCreaterDepart" onchange="onSelectChange(this,PCreaterDepartLDiv);onOptionChange('PCreaterDepart')" <%=isdisable%>>
                                <option value="0" <%if("0".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1" <%if("1".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2" <%if("2".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
                                <option value="3"  <%if("3".equals(PCreaterDepart)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select> 
<!-- TD12005 文档下载权限控制（创建人部门）    复选框对象添加 -->
                            <input class='InputStyle' type='checkbox' name='chkPCreaterDepart' id='chkPCreaterDepart' value='<%=PCreaterDepartDL%>' style='display:<%=isDownloadShow%>' <%=isDownloadCheck%> <%=isDownloadDisabled%> onclick="setCheckbox(this)"><label for='chkPCreaterDepart' id='lblPCreaterDepart' style='display:<%=isDownloadShow%>'><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>
                        </td>
                    </tr>
                </table>                 
            </td>
          </tr>  
           <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

           </table>


           <table class="viewform" width="100%">      
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
<!-- TD12005 文档下载权限控制（创建人）外部    开始 -->
                <%
                //是否可见
                isDownloadShow = this.getDLVisible(PCreaterW);
                //是否选中
                isDownloadCheck = this.getDLChecked(PCreaterWDL);
                %>
<!-- TD12005 文档下载权限控制（创建人）外部    结束 -->
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
<!-- TD12005 文档下载权限控制（创建人）外部    ONCHANGE添加 -->
                            <select name="PDocCreaterW" <%=isdisable%> onchange="onOptionChange('PDocCreaterW')">
                                <option value="0" <%if("0".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
                                <option value="3"  <%if("3".equals(PCreaterW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                                </select>
<!-- TD12005 文档下载权限控制（创建人）外部    复选框对象添加 -->
                            <input class='InputStyle' type='checkbox' name='chkPDocCreaterW' id='chkPDocCreaterW' value='<%=PCreaterWDL%>' style='display:<%=isDownloadShow%>' <%=isDownloadCheck%> <%=isDownloadDisabled%> onclick="setCheckbox(this)"><label for='chkPDocCreaterW' id='lblPDocCreaterW' style='display:<%=isDownloadShow%>'><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>                           
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
<!-- TD12005 文档下载权限控制（创建人经理）外部    开始 -->
                <%
                //是否可见
                isDownloadShow = this.getDLVisible(PCreaterManagerW);
                //是否选中
                isDownloadCheck = this.getDLChecked(PCreaterManagerWDL);
                %>
<!-- TD12005 文档下载权限控制（创建人经理）外部    结束 -->
                    <tr>
                        <td width="60%"></td>
                        <td width="40%">
<!-- TD12005 文档下载权限控制（创建人经理）外部    ONCHANGE添加 -->
                            <select name="PCreaterManagerW" <%=isdisable%> onchange="onOptionChange('PCreaterManagerW')">
                                <option value="0"  <%if("0".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                                <option value="1"  <%if("1".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                <option value="2"  <%if("2".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
                                <option value="3"  <%if("3".equals(PCreaterManagerW)){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                            </select>  
 <!-- TD12005 文档下载权限控制（创建人经理）外部    复选框对象添加 -->
                            <input class='InputStyle' type='checkbox' name='chkPCreaterManagerW' id='chkPCreaterManagerW' value='<%=PCreaterManagerWDL%>' style='display:<%=isDownloadShow%>' <%=isDownloadCheck%> <%=isDownloadDisabled%> onclick="setCheckbox(this)"><label for='chkPCreaterManagerW' id='lblPCreaterManagerW' style='display:<%=isDownloadShow%>'><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>
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
        <table class=ViewForm>
          <colgroup>
          <col width="8%">
          <col width="40%">
          <col width="52%">
          <tr class=Title >
            <th colspan=2 nowrap><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18598,user.getLanguage())%>)</th>
            <td align=right>
            <%if(canEdit){%> 
                <input type="checkbox" name="chkAll" onclick="chkAllClick(this)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
                &nbsp;                         
<!-- TD12005 文档下载权限控制 -->
                <a href='/docs/docs/DocShareAddBrowser.jsp?para=1_<%=id%><%if(noDownload == 1) {out.print("&noDownload=1");}%>'><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;                               
                <a href="#" onclick="javaScript:onDelShare();" target="iframeAlert"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
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
/** TD12005 文档下载权限控制     开始*/
        String strDownload = "(" + SystemEnv.getHtmlLabelName(23734,user.getLanguage()) + ")";
        if (noDownload != 1 && Util.getIntValue(Util.null2String(RecordSet.getString("downloadlevel")), 0) == 1) {
        	strDownload = "(" + SystemEnv.getHtmlLabelName(23733,user.getLanguage()) + ")";
        }
/** TD12005 文档下载权限控制     结束*/
		if(RecordSet.getInt("sharetype")==1)	{%>
	        <TR>
              <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId' <%=isdisable%>></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD class=Field>
<!-- TD12005 文档下载权限控制 -->
				<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("userid")%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%></a>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) + strDownload%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			  
	        </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
	    <%}else if(RecordSet.getInt("sharetype")==2)	{%>
	        <TR>
               <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId' <%=isdisable%>></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
			  <TD class=Field>
<!-- TD12005 文档下载权限控制 -->
				<a href="/hrm/company/HrmSubCompanyDsp.jsp?id=<%=RecordSet.getString("subcompanyid")%>" target="_blank"><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) + strDownload%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			 
	        </TR>
        <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}else if(RecordSet.getInt("sharetype")==3)	{%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId' <%=isdisable%>></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD class=Field>
<!-- TD12005 文档下载权限控制 -->
				<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) + strDownload%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			 
	        </TR>
        <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}else if(RecordSet.getInt("sharetype")==4)	{%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId' <%=isdisable%>></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
			  <TD class=Field>
<!-- TD12005 文档下载权限控制 -->
				<%
					RecordSet3.executeSql("select rolesmark from hrmroles where id="+RecordSet.getString("roleid"));
					RecordSet3.next();
				%>
				<%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSet.getString("roleid")),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) + strDownload%><% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                
			  </TD>			 
	        </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}else if(RecordSet.getInt("sharetype")==6)	{%>
	        <TR>
               <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId' <%=isdisable%>></TD>
	          <TD class=Field>群组</TD>
			  <TD class=Field>
				<%=Util.toScreen(HrmOrgGroupComInfo.getOrgGroupName(RecordSet.getString("orgGroupId")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			 
	        </TR>
        <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
		<%}else if(RecordSet.getInt("sharetype")==5)	{%>
	        <TR>
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId' <%=isdisable%>></TD>
	          <TD class=Field><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
			  <TD class=Field>
<!-- TD12005 文档下载权限控制 -->
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) + strDownload%>
				<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
                <% if(RecordSet.getInt("sharelevel")==3)%><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
			  </TD>			  
	        </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
       <%}else if(RecordSet.getInt("sharetype")==9)  {//具体客户%>  
            <TR>
             <TD><INPUT TYPE='checkbox'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId' <%=isdisable%>></TD>
              <TD class=Field><%=SystemEnv.getHtmlLabelName(18647,user.getLanguage())%></TD>
              <TD class=Field>
<!-- TD12005 文档下载权限控制 -->
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
             <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("id")%>" NAME='chkShareId' <%=isdisable%>></TD>
	          <TD class=Field><%=Util.toScreen(crmtypename,user.getLanguage())%></TD>
			  <TD class=Field>
<!-- TD12005 文档下载权限控制 -->
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) + strDownload%>
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
<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>:<input  class=InputStyle name="fieldlable"><input  type="hidden" name="fieldid" value="-1">
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
    <td style="border-bottom:silver 1pt solid"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>:<input  class=InputStyle name="fieldlable" value="<%=cfm.getLable()%>" <%=disableLable%>><input  type="hidden" name="fieldid" value="<%=cfm.getId()%>" ></td>
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
function onSave(obj){
	obj.disabled = true;
	if(check_form(document.weaver,'categoryname')){
	document.weaver.operation.value="edit";
    //clearTempObj();
	document.weaver.submit();}
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
//=====TD12005 文档下载权限控制  开始========//
function onOptionChange(selObjName) {
    var selObj = document.all(selObjName);//选择控件对象
	var oVal = selObj.options[selObj.selectedIndex].value;//选中值
	var chkObj = document.all('chk'+selObjName);//复选框控件对象
    var lblObj = document.all('lbl'+selObjName);//复选框控件对应标签对象

	if(oVal == 1) {//查看时显示	
		chkObj.style.display = '';
		lblObj.style.display = '';
	} else {
		chkObj.style.display = 'none';
		lblObj.style.display = 'none';
	}
}
function setCheckbox(chkObj) {
	if(chkObj.checked == true) {
		chkObj.value = 1;
	} else {
		chkObj.value = 0;
	}
}
//=====TD12005 文档下载权限控制  结束========//

</script>
<script language=vbs>

sub onShowMould()
	id = window.showModalDialog("/docs/mould/DocMouldBrowser.jsp?doctype=.htm")
	if NOT isempty(id) then
		weaver.docmouldid.value=id(0)&""
		docmouldidname.innerHtml = id(1)&""
		docmouldidname.innerHtml = "<a href='/docs/mould/DocMouldDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"
	end if
end sub
<%-- added by wdl 2006.7.3 TD.4617 start  --%>
sub onShowMould1()
	id = window.showModalDialog("/docs/mould/DocMouldBrowser.jsp?doctype=.doc")
	if NOT isempty(id) then
		weaver.wordmouldid.value=id(0)&""
		wordmouldidname.innerHtml = id(1)&""
		wordmouldidname.innerHtml = "<a href='/docs/mould/DocMouldDspExt.jsp?id="&id(0)&"'>"&id(1)&"</a>"
	end if
end sub
<%-- added end  --%>
sub onShowWorkflow()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=28")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		approvewfspan.innerHtml = id(1)
		weaver.approvewfid.value=id(0)
		else
		approvewfspan.innerHtml = empty
		weaver.approvewfid.value=""
		end if
	end if
end sub

sub onShowDept(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowRole(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = empty
		document.all(inputename).value=""
		end if
	end if
end sub
</script>
</BODY></HTML>