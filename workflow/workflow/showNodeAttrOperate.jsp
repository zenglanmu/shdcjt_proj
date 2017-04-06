<%@ page import="weaver.general.Util,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<%
boolean freeflow=GCONST.getFreeFlow();    
int design = Util.getIntValue(request.getParameter("design"),0);
int wfid = Util.getIntValue(request.getParameter("wfid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
boolean hassetting=false;
String nodetitle= Util.null2String(request.getParameter("nodetitle"));
int isFormSignature= Util.getIntValue(request.getParameter("isFormSignature"),0);
int IsPendingForward= Util.getIntValue(request.getParameter("IsPendingForward"),0);
int IsWaitForwardOpinion= Util.getIntValue(request.getParameter("IsWaitForwardOpinion"),0);
int IsBeForward= Util.getIntValue(request.getParameter("IsBeForward"),0);
int IsSubmitedOpinion= Util.getIntValue(request.getParameter("IsSubmitedOpinion"),0);
int IsSubmitForward= Util.getIntValue(request.getParameter("IsSubmitForward"),0);
int IssynPending= Util.getIntValue(request.getParameter("IssynPending"),0);
int IssynHandled= Util.getIntValue(request.getParameter("IssynHandled"),0);
int formSignatureWidth= Util.getIntValue(request.getParameter("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
int formSignatureHeight= Util.getIntValue(request.getParameter("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
int IssynFormSign= Util.getIntValue(request.getParameter("IssynFormSign"),0);
String src = Util.null2String(request.getParameter("src"));
int IsFreeWorkflow= Util.getIntValue(request.getParameter("IsFreeWorkflow"),0);
int IssynFreewf= Util.getIntValue(request.getParameter("IssynFreewf"),0);
int issignmustinput = Util.getIntValue(request.getParameter("issignmustinput"), 0);
int isfeedback = Util.getIntValue(request.getParameter("isfeedback"), 0);
int isnullnotfeedback = Util.getIntValue(request.getParameter("isnullnotfeedback"), 0);
int issynremark = Util.getIntValue(request.getParameter("issynremark"), 0);
String freewfsetcurnamecn=Util.null2String(request.getParameter("freewfsetcurnamecn"));
String freewfsetcurnameen=Util.null2String(request.getParameter("freewfsetcurnameen"));
String freewfsetcurnametw = Util.null2String(request.getParameter("freewfsetcurnametw"));
int IsBeForwardSubmit= Util.getIntValue(request.getParameter("IsBeForwardSubmit"),0);
int IsBeForwardModify= Util.getIntValue(request.getParameter("IsBeForwardModify"),0);
int IsBeForwardPending= Util.getIntValue(request.getParameter("IsBeForwardPending"),0);
int IsShowPendingForward=Util.getIntValue(request.getParameter("IsShowPendingForward"),0);
String PendingForward_Name7=Util.null2String(request.getParameter("PendingForward_Name7"));
String PendingForward_Name8=Util.null2String(request.getParameter("PendingForward_Name8"));
String PendingForward_Name9=Util.null2String(request.getParameter("PendingForward_Name9"));
int IsShowWaitForwardOpinion=Util.getIntValue(request.getParameter("IsShowWaitForwardOpinion"),0);
String WaitForwardOpinion_Name7=Util.null2String(request.getParameter("WaitForwardOpinion_Name7"));
String WaitForwardOpinion_Name8=Util.null2String(request.getParameter("WaitForwardOpinion_Name8"));
String WaitForwardOpinion_Name9=Util.null2String(request.getParameter("WaitForwardOpinion_Name9"));
int IsShowBeForward=Util.getIntValue(request.getParameter("IsShowBeForward"),0);
String BeForward_Name7=Util.null2String(request.getParameter("BeForward_Name7"));
String BeForward_Name8=Util.null2String(request.getParameter("BeForward_Name8"));
String BeForward_Name9=Util.null2String(request.getParameter("BeForward_Name9"));
int IsShowSubmitedOpinion=Util.getIntValue(request.getParameter("IsShowSubmitedOpinion"),0);
String SubmitedOpinion_Name7=Util.null2String(request.getParameter("SubmitedOpinion_Name7"));
String SubmitedOpinion_Name8=Util.null2String(request.getParameter("SubmitedOpinion_Name8"));
String SubmitedOpinion_Name9=Util.null2String(request.getParameter("SubmitedOpinion_Name9"));
int IsShowSubmitForward=Util.getIntValue(request.getParameter("IsShowSubmitForward"),0);
String SubmitForward_Name7=Util.null2String(request.getParameter("SubmitForward_Name7"));
String SubmitForward_Name8=Util.null2String(request.getParameter("SubmitForward_Name8"));
String SubmitForward_Name9=Util.null2String(request.getParameter("SubmitForward_Name9"));
int IsShowBeForwardSubmit=Util.getIntValue(request.getParameter("IsShowBeForwardSubmit"),0);
String BeForwardSubmit_Name7=Util.null2String(request.getParameter("BeForwardSubmit_Name7"));
String BeForwardSubmit_Name8=Util.null2String(request.getParameter("BeForwardSubmit_Name8"));
String BeForwardSubmit_Name9=Util.null2String(request.getParameter("BeForwardSubmit_Name9"));
int IsShowBeForwardModify=Util.getIntValue(request.getParameter("IsShowBeForwardModify"),0);
String BeForwardModify_Name7=Util.null2String(request.getParameter("BeForwardModify_Name7"));
String BeForwardModify_Name8=Util.null2String(request.getParameter("BeForwardModify_Name8"));
String BeForwardModify_Name9=Util.null2String(request.getParameter("BeForwardModify_Name9"));
int IsShowBeForwardPending=Util.getIntValue(request.getParameter("IsShowBeForwardPending"),0);
String BeForwardPending_Name7=Util.null2String(request.getParameter("BeForwardPending_Name7"));
String BeForwardPending_Name8=Util.null2String(request.getParameter("BeForwardPending_Name8"));
String BeForwardPending_Name9=Util.null2String(request.getParameter("BeForwardPending_Name9"));
int nodetype=-1;
int nodeattribute=WFLinkInfo.getNodeAttribute(nodeid);
if(src.equals("")){
	RecordSet.executeSql("select * from workflow_flownode where workflowId="+wfid+" and nodeId="+nodeid);
	if(RecordSet.next()){
		nodetitle = Util.toHtml2(Util.encodeAnd(Util.null2String(RecordSet.getString("nodetitle"))));
        isFormSignature = Util.getIntValue(RecordSet.getString("isFormSignature"),0);
        IsPendingForward = Util.getIntValue(RecordSet.getString("IsPendingForward"),0);
        IsWaitForwardOpinion = Util.getIntValue(RecordSet.getString("IsWaitForwardOpinion"),0);
        IsBeForward = Util.getIntValue(RecordSet.getString("IsBeForward"),0);
        IsSubmitedOpinion = Util.getIntValue(RecordSet.getString("IsSubmitedOpinion"),0);
        IsSubmitForward = Util.getIntValue(RecordSet.getString("IsSubmitForward"),0);
        formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
		formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
        IsFreeWorkflow = Util.getIntValue(RecordSet.getString("IsFreeWorkflow"),0);
        nodetype=Util.getIntValue(RecordSet.getString("nodetype"));
        freewfsetcurnamecn= Util.toHtml2(Util.encodeAnd(Util.null2String(RecordSet.getString("freewfsetcurnamecn"))));
        freewfsetcurnameen= Util.toHtml2(Util.encodeAnd(Util.null2String(RecordSet.getString("freewfsetcurnameen"))));
        freewfsetcurnametw= Util.toHtml2(Util.encodeAnd(Util.null2String(RecordSet.getString("freewfsetcurnametw"))));
        issignmustinput = Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
        isfeedback = Util.getIntValue(RecordSet.getString("isfeedback"), 0);
        isnullnotfeedback = Util.getIntValue(RecordSet.getString("isnullnotfeedback"), 0);
        IsBeForwardSubmit = Util.getIntValue(RecordSet.getString("IsBeForwardSubmit"), 0);
        IsBeForwardModify = Util.getIntValue(RecordSet.getString("IsBeForwardModify"), 0);
        IsBeForwardPending = Util.getIntValue(RecordSet.getString("IsBeForwardPending"), 0);
        IsShowPendingForward = Util.getIntValue(RecordSet.getString("IsShowPendingForward"), 0);
        IsShowWaitForwardOpinion = Util.getIntValue(RecordSet.getString("IsShowWaitForwardOpinion"), 0);
        IsShowBeForward = Util.getIntValue(RecordSet.getString("IsShowBeForward"), 0);
        IsShowSubmitedOpinion = Util.getIntValue(RecordSet.getString("IsShowSubmitedOpinion"), 0);
        IsShowSubmitForward = Util.getIntValue(RecordSet.getString("IsShowSubmitForward"), 0);
        IsShowBeForwardSubmit = Util.getIntValue(RecordSet.getString("IsShowBeForwardSubmit"), 0);
        IsShowBeForwardModify = Util.getIntValue(RecordSet.getString("IsShowBeForwardModify"), 0);
        IsShowBeForwardPending = Util.getIntValue(RecordSet.getString("IsShowBeForwardPending"), 0);
    }
    RecordSet.executeSql("select * from workflow_CustFieldName where workflowId="+wfid+" and nodeId="+nodeid);
	while(RecordSet.next()){
        String fieldname=Util.null2String(RecordSet.getString("fieldname"));
        int language=Util.getIntValue(RecordSet.getString("Languageid"),7);
        String CustFieldName=Util.toHtml2(Util.encodeAnd(Util.null2String(RecordSet.getString("CustFieldName"))));
        if(fieldname.equalsIgnoreCase("PendingForward")){
            if(language==8){
                PendingForward_Name8 =CustFieldName;
            }else if(language==9){
                PendingForward_Name9 = CustFieldName;
            }else{
                PendingForward_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("WaitForwardOpinion")){
            if(language==8){
                WaitForwardOpinion_Name8 =CustFieldName;
            }else if(language==9){
                WaitForwardOpinion_Name9 = CustFieldName;
            }else{
                WaitForwardOpinion_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForward")){
            if(language==8){
                BeForward_Name8 =CustFieldName;
            }else if(language==9){
                BeForward_Name9 = CustFieldName;
            }else{
                BeForward_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("SubmitedOpinion")){
            if(language==8){
                SubmitedOpinion_Name8 =CustFieldName;
            }else if(language==9){
                SubmitedOpinion_Name9 = CustFieldName;
            }else{
                SubmitedOpinion_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("SubmitForward")){
            if(language==8){
                SubmitForward_Name8 =CustFieldName;
            }else if(language==9){
                SubmitForward_Name9 = CustFieldName;
            }else{
                SubmitForward_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForwardSubmit")){
            if(language==8){
                BeForwardSubmit_Name8 =CustFieldName;
            }else if(language==9){
                BeForwardSubmit_Name9 = CustFieldName;
            }else{
                BeForwardSubmit_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForwardModify")){
            if(language==8){
                BeForwardModify_Name8 =CustFieldName;
            }else if(language==9){
                BeForwardModify_Name9 = CustFieldName;
            }else{
                BeForwardModify_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForwardPending")){
            if(language==8){
                BeForwardPending_Name8 =CustFieldName;
            }else if(language==9){
                BeForwardPending_Name9 = CustFieldName;
            }else{
                BeForwardPending_Name7 = CustFieldName;
            }
        }
    }
}
//if(freewfsetcurnamecn.trim().equals("")){
//    freewfsetcurnamecn=SystemEnv.getHtmlLabelName(21781,7);
//}
//if(freewfsetcurnameen.trim().equals("")){
//    freewfsetcurnameen=SystemEnv.getHtmlLabelName(21781,8);
//}

String ifchangstatus=Util.null2String(BaseBean.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));

if(!hassetting&&isFormSignature==1) hassetting=true;
if(!hassetting&&!nodetitle.equals("")) hassetting=true;
if(!hassetting&&IsPendingForward==1) hassetting=true;
if(!hassetting&&IsWaitForwardOpinion==1) hassetting=true;
if(!hassetting&&IsBeForward==1) hassetting=true;
if(!hassetting&&IsSubmitedOpinion==1) hassetting=true;
if(!hassetting&&IsSubmitForward==1) hassetting=true;
if(!hassetting&&IsFreeWorkflow==1) hassetting=true;
if(!hassetting&&issignmustinput==1) hassetting=true;
if(!hassetting&&isfeedback==1&&ifchangstatus.equals("1")) hassetting=true;
if(!hassetting&&IsBeForwardSubmit==1) hassetting=true;
if(!hassetting&&IsBeForwardModify==1) hassetting=true;
if(!hassetting&&IsBeForwardPending==1) hassetting=true;
if(!hassetting&&IsShowPendingForward==1) hassetting=true;
if(!hassetting&&IsShowWaitForwardOpinion==1) hassetting=true;
if(!hassetting&&IsShowBeForward==1) hassetting=true;
if(!hassetting&&IsShowSubmitedOpinion==1) hassetting=true;
if(!hassetting&&IsShowSubmitForward==1) hassetting=true;
if(!hassetting&&IsShowBeForwardSubmit==1) hassetting=true;
if(!hassetting&&IsShowBeForwardModify==1) hassetting=true;
if(!hassetting&&IsShowBeForwardPending==1) hassetting=true;

if(src.equals("save")){
    RecordSet.executeSql("update workflow_flownode set nodetitle='" + Util.toHtml100(nodetitle) +
            "',isFormSignature='" + isFormSignature +
            "',IsPendingForward='" + IsPendingForward +
            "',IsWaitForwardOpinion='" + IsWaitForwardOpinion +
            "',IsBeForward='" + IsBeForward +
            "',IsSubmitedOpinion='" + IsSubmitedOpinion +
            "',IsSubmitForward='" + IsSubmitForward +
            "',formSignatureWidth=" + formSignatureWidth +
            ",formSignatureHeight=" + formSignatureHeight +
            ",IsFreeWorkflow='" + IsFreeWorkflow +
            "',freewfsetcurnamecn='" + Util.toHtml100(freewfsetcurnamecn) +
            "',freewfsetcurnameen='" + Util.toHtml100(freewfsetcurnameen) +
            "',freewfsetcurnametw='" + Util.toHtml100(freewfsetcurnametw) +
            "',issignmustinput=" + issignmustinput +
            ",isfeedback='" + isfeedback +
            "',isnullnotfeedback='"+isnullnotfeedback+
            "',IsBeForwardSubmit ='"+ IsBeForwardSubmit+
            "',IsBeForwardModify = '"+ IsBeForwardModify+
            "',IsBeForwardPending = '"+ IsBeForwardPending+
            "',IsShowPendingForward = '"+ IsShowPendingForward+
            "',IsShowWaitForwardOpinion = '"+ IsShowWaitForwardOpinion+
            "',IsShowBeForward = '"+ IsShowBeForward+
            "',IsShowSubmitedOpinion = '"+ IsShowSubmitedOpinion+
            "',IsShowSubmitForward = '"+ IsShowSubmitForward+
            "',IsShowBeForwardSubmit = '"+ IsShowBeForwardSubmit+
            "',IsShowBeForwardModify = '"+ IsShowBeForwardModify+
            "',IsShowBeForwardPending = '"+ IsShowBeForwardPending+
            "' where workflowId="+wfid+" and nodeId="+nodeid);
    RecordSet.executeSql("delete from workflow_CustFieldName where workflowId="+wfid+" and nodeId="+nodeid);
    if (!PendingForward_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'PendingForward',7,'"+Util.toHtml100(PendingForward_Name7)+"')");
    }
    if (!PendingForward_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'PendingForward',8,'"+Util.toHtml100(PendingForward_Name8)+"')");
    }
    if (!PendingForward_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'PendingForward',9,'"+Util.toHtml100(PendingForward_Name9)+"')");
    }
    if (!WaitForwardOpinion_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'WaitForwardOpinion',7,'"+Util.toHtml100(WaitForwardOpinion_Name7)+"')");
    }
    if (!WaitForwardOpinion_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'WaitForwardOpinion',8,'"+Util.toHtml100(WaitForwardOpinion_Name8)+"')");
    }
    if (!WaitForwardOpinion_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'WaitForwardOpinion',9,'"+Util.toHtml100(WaitForwardOpinion_Name9)+"')");
    }
    if (!BeForward_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForward',7,'"+Util.toHtml100(BeForward_Name7)+"')");
    }
    if (!BeForward_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForward',8,'"+Util.toHtml100(BeForward_Name8)+"')");
    }
    if (!BeForward_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForward',9,'"+Util.toHtml100(BeForward_Name9)+"')");
    }
    if (!SubmitedOpinion_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitedOpinion',7,'"+Util.toHtml100(SubmitedOpinion_Name7)+"')");
    }
    if (!SubmitedOpinion_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitedOpinion',8,'"+Util.toHtml100(SubmitedOpinion_Name8)+"')");
    }
    if (!SubmitedOpinion_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitedOpinion',9,'"+Util.toHtml100(SubmitedOpinion_Name9)+"')");
    }
    if (!SubmitForward_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitForward',7,'"+Util.toHtml100(SubmitForward_Name7)+"')");
    }
    if (!SubmitForward_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitForward',8,'"+Util.toHtml100(SubmitForward_Name8)+"')");
    }
    if (!SubmitForward_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitForward',9,'"+Util.toHtml100(SubmitForward_Name9)+"')");
    }
    if (!BeForwardSubmit_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmit',7,'"+Util.toHtml100(BeForwardSubmit_Name7)+"')");
    }
    if (!BeForwardSubmit_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmit',8,'"+Util.toHtml100(BeForwardSubmit_Name8)+"')");
    }
    if (!BeForwardSubmit_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmit',9,'"+Util.toHtml100(BeForwardSubmit_Name9)+"')");
    }
    if (!BeForwardModify_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardModify',7,'"+Util.toHtml100(BeForwardModify_Name7)+"')");
    }
    if (!BeForwardModify_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardModify',8,'"+Util.toHtml100(BeForwardModify_Name8)+"')");
    }
    if (!BeForwardModify_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardModify',9,'"+Util.toHtml100(BeForwardModify_Name9)+"')");
    }
    if (!BeForwardPending_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardPending',7,'"+Util.toHtml100(BeForwardPending_Name7)+"')");
    }
    if (!BeForwardPending_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardPending',8,'"+Util.toHtml100(BeForwardPending_Name8)+"')");
    }
    if (!BeForwardPending_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardPending',9,'"+Util.toHtml100(BeForwardPending_Name9)+"')");
    }
    if(IssynPending==1){
        RecordSet.executeSql("update workflow_flownode set IsPendingForward='"+IsPendingForward+
                "',IsWaitForwardOpinion='"+IsWaitForwardOpinion+
                "',IsSubmitedOpinion='"+IsSubmitedOpinion+
                "',IsBeForwardSubmit ='"+ IsBeForwardSubmit+
                "',IsBeForwardModify = '"+ IsBeForwardModify+
                "',IsBeForwardPending = '"+ IsBeForwardPending+
                "',IsShowPendingForward = '"+ IsShowPendingForward+
                "',IsShowWaitForwardOpinion = '"+ IsShowWaitForwardOpinion+
                "',IsShowSubmitedOpinion = '"+ IsShowSubmitedOpinion+
                "',IsShowBeForwardSubmit = '"+ IsShowBeForwardSubmit+
                "',IsShowBeForwardModify = '"+ IsShowBeForwardModify+
                "',IsShowBeForwardPending = '"+ IsShowBeForwardPending+
            "' where workflowId="+wfid);
        RecordSet.executeSql("delete from workflow_CustFieldName where (fieldname='PendingForward'" +
                " or fieldname='WaitForwardOpinion'" +
                " or fieldname='SubmitedOpinion'" +
                " or fieldname='BeForwardSubmit'" +
                " or fieldname='BeForwardModify'" +
                " or fieldname='BeForwardPending') and workflowId="+wfid);
    if (!PendingForward_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'PendingForward',7,'"+Util.toHtml100(PendingForward_Name7)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!PendingForward_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'PendingForward',8,'"+Util.toHtml100(PendingForward_Name8)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!PendingForward_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'PendingForward',9,'"+Util.toHtml100(PendingForward_Name9)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!WaitForwardOpinion_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'WaitForwardOpinion',7,'"+Util.toHtml100(WaitForwardOpinion_Name7)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!WaitForwardOpinion_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'WaitForwardOpinion',8,'"+Util.toHtml100(WaitForwardOpinion_Name8)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!WaitForwardOpinion_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'WaitForwardOpinion',9,'"+Util.toHtml100(WaitForwardOpinion_Name9)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!SubmitedOpinion_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitedOpinion',7,'"+Util.toHtml100(SubmitedOpinion_Name7)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!SubmitedOpinion_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitedOpinion',8,'"+Util.toHtml100(SubmitedOpinion_Name8)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!SubmitedOpinion_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitedOpinion',9,'"+Util.toHtml100(SubmitedOpinion_Name9)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForwardSubmit_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmit',7,'"+Util.toHtml100(BeForwardSubmit_Name7)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForwardSubmit_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmit',8,'"+Util.toHtml100(BeForwardSubmit_Name8)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForwardSubmit_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmit',9,'"+Util.toHtml100(BeForwardSubmit_Name9)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForwardModify_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardModify',7,'"+Util.toHtml100(BeForwardModify_Name7)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForwardModify_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardModify',8,'"+Util.toHtml100(BeForwardModify_Name8)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForwardModify_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardModify',9,'"+Util.toHtml100(BeForwardModify_Name9)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForwardPending_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardPending',7,'"+Util.toHtml100(BeForwardPending_Name7)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForwardPending_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardPending',8,'"+Util.toHtml100(BeForwardPending_Name8)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForwardPending_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardPending',9,'"+Util.toHtml100(BeForwardPending_Name9)+"' from workflow_flownode where workflowid="+wfid);
    }
    }
    if(IssynHandled==1){
        RecordSet.executeSql("update workflow_flownode set IsBeForward='"+IsBeForward+
                "',IsSubmitForward='"+IsSubmitForward+
                "',IsShowBeForward = '"+ IsShowBeForward+
                "',IsShowSubmitForward = '"+ IsShowSubmitForward+
            "' where workflowId="+wfid);
        RecordSet.executeSql("delete from workflow_CustFieldName where (fieldname='BeForward'" +
                " or fieldname='SubmitForward') and workflowId="+wfid);
    if (!BeForward_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForward',7,'"+Util.toHtml100(BeForward_Name7)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForward_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForward',8,'"+Util.toHtml100(BeForward_Name8)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!BeForward_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForward',9,'"+Util.toHtml100(BeForward_Name9)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!SubmitForward_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitForward',7,'"+Util.toHtml100(SubmitForward_Name7)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!SubmitForward_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitForward',8,'"+Util.toHtml100(SubmitForward_Name8)+"' from workflow_flownode where workflowid="+wfid);
    }
    if (!SubmitForward_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitForward',9,'"+Util.toHtml100(SubmitForward_Name9)+"' from workflow_flownode where workflowid="+wfid);
    }
    }
    if(IssynFormSign==1){
        RecordSet.executeSql("update workflow_flownode set isFormSignature='"+isFormSignature+"',formSignatureWidth="+formSignatureWidth+",formSignatureHeight="+formSignatureHeight+" where workflowId="+wfid);
    }
    if(IssynFreewf==1){
        RecordSet.executeSql("update workflow_flownode set IsFreeWorkflow='"+IsFreeWorkflow+"',freewfsetcurnamecn='"+Util.toHtml100(freewfsetcurnamecn)+"',freewfsetcurnameen='"+Util.toHtml100(freewfsetcurnameen)+"',freewfsetcurnametw='"+Util.toHtml100(freewfsetcurnametw)+"' where EXISTS(select 1 from workflow_nodebase a where (a.nodeattribute is null or a.nodeattribute!='1') and a.id=workflow_flownode.nodeid) and (nodetype is null or nodetype!='3') and workflowId="+wfid);
    }
    if(issynremark==1){
    	RecordSet.executeSql("update workflow_flownode set issignmustinput="+issignmustinput+",isfeedback='"+isfeedback+"',isnullnotfeedback='"+isnullnotfeedback+"' where workflowId="+wfid);
    }
}

%>

<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21393,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
%>
<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showNodeAttrOperate.jsp" method="post">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="" name="src">
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=design%>" name="design">    

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

		    <TABLE class="viewform">
		    <COLGROUP>
		    <COL width="50%">
		    <COL width="50%">
            <TR class="Title">
		        <TH colSpan=2><%=SystemEnv.getHtmlLabelName(21668,user.getLanguage())%></TH>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line1" colSpan=2></TD>
		    </TR>
		    <TR>
			    <TD><%=SystemEnv.getHtmlLabelName(21668,user.getLanguage())%></TD>
			    <TD class=Field>
				<INPUT class=InputStyle maxLength=10 size=20 name="nodetitle" value = "<%=nodetitle%>">
				</TD>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" style="padding:0;" colSpan=2></TD>
		    </TR>
<%
	String isUseWebRevision=BaseBean.getPropValue("weaver_iWebRevision","isUseWebRevision");
    if(isUseWebRevision==null||isUseWebRevision.trim().equals("")){
		isUseWebRevision="0";
	}
if(isUseWebRevision.equals("1")){
%>			
            <tr><td height="5" colspan="2">&nbsp;</td></tr>
            <TR class="Title">
		        <TH><%=SystemEnv.getHtmlLabelName(21750,user.getLanguage())%></TH>
                <td><INPUT class=inputstyle type="checkbox" name="IssynFormSign" value="1" ><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></td>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line1" colSpan=2 style="padding:0;"></TD>
		    </TR>
		    <TR>
			    <TD><%=SystemEnv.getHtmlLabelName(21424,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=inputstyle type="checkbox" name="isFormSignature" value="1" onclick="showAttribute(this)" <%   if(isFormSignature==1) {%> checked <% } %> ></TD>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line"  style="padding:0;"  colSpan=2></TD>
		    </TR>
                <TR id="trwidth" style="display:<%if(isFormSignature!=1){%>none<%}%>">
                    <TD><%=SystemEnv.getHtmlLabelName(21830, user.getLanguage())%>
                    </TD>
                    <TD class=Field>
                        <input type="text" class=inputstyle name="formSignatureWidth" value="<%=formSignatureWidth%>" maxlength="4"
                               size="4" onKeyPress="ItemCount_KeyPress()"
                               onChange='checknumber("formSignatureWidth");checkinput("formSignatureWidth","formSignatureWidthImage")'>
                        <SPAN id=formSignatureWidthImage></SPAN>
                        <%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%>
                    </TD>
                </TR>
                <TR class="Spacing" id="trline1" style="height:1px;display:<%if(isFormSignature!=1){%>none<%}%>">
                    <TD  class="Line"  style="padding:0;"  colSpan=2></TD>
                </TR>
                <TR id="trheight" style="display:<%if(isFormSignature!=1){%>none<%}%>">
                    <TD><%=SystemEnv.getHtmlLabelName(21831, user.getLanguage())%>
                    </TD>
                    <TD class=Field>
                        <input type="text" class=inputstyle name="formSignatureHeight" value="<%=formSignatureHeight%>" maxlength="4"
                               size="4" onKeyPress="ItemCount_KeyPress()"
                               onChange='checknumber("formSignatureHeight");checkinput("formSignatureHeight","formSignatureHeightImage")'>
                        <SPAN id=formSignatureHeightImage></SPAN>
                        <%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%>
                    </TD>
                </TR>
                <TR class="Spacing" id="trline2" style="height:1px;display:<%if(isFormSignature!=1){%>none<%}%>">
                    <TD  class="Line"  style="padding:0;"  colSpan=2></TD>
                </TR>
<%
}								   
%>

            <tr><td height="5" colspan="2">&nbsp;</td></tr>
            <TR class="Title">
		        <TH><%=SystemEnv.getHtmlLabelName(21751,user.getLanguage())%></TH>
                <td><INPUT class=inputstyle type="checkbox" name="IssynPending" value="1" ><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></td>
		    </TR>
		    <tr><td colspan="2">
                <TABLE class=liststyle cellspacing=1>
                <COLGROUP>
                <COL width="6">
                <COL width="30%">
                <COL>
                <COL>
                <COL>
                <COL width="12" align="center">
                <TR class="Spacing" style="height:1px;"><TD class="Line1" style="padding:0;" colspan=6></TD></TR>
                <TR class="header">
                    <TD><nobr><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
                    <TD><nobr><%=SystemEnv.getHtmlLabelName(21560,user.getLanguage())%></TD>
                    <TD><nobr><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>）</TD>
                    <TD <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><nobr><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>）</TD>
                    <TD <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><nobr><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(21866,user.getLanguage())%>）</TD>
                    <TD><nobr><%=SystemEnv.getHtmlLabelName(22595,user.getLanguage())%></TD>
                </TR>
                <TR class="Spacing" style="height:1px;">
                    <TD class="Line1" style="padding:0;" colSpan=6></TD>
                </TR>
                <TR class="datalight">
				<TD><INPUT class=inputstyle type="checkbox" name="IsPendingForward" value="1" onclick="CheckClick('IsPendingForward')" <%   if(IsPendingForward==1) {%> checked <% } %> ></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21752,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="PendingForward_Name7" value = "<%=PendingForward_Name7%>" ></TD>
				<TD class=Field <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="PendingForward_Name8" value = "<%=PendingForward_Name8%>" ></TD>
                <TD class=Field <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="PendingForward_Name9" value = "<%=PendingForward_Name9%>" ></TD>
                <TD><INPUT class=inputstyle type="checkbox" name="IsShowPendingForward" value="1"  disabled></TD>
		        </TR>
                <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=6></TD>
		        </TR>
                <TR class="datadark">
				<TD><INPUT class=inputstyle type="checkbox" name="IsWaitForwardOpinion" value="1" onclick="CheckClick('IsWaitForwardOpinion')" <%   if(IsWaitForwardOpinion==1) {%> checked <% } %> <%if(IsPendingForward!=1) {%> disabled<%}%>></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21753,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="WaitForwardOpinion_Name7" value = "<%=WaitForwardOpinion_Name7%>" ></TD>
				<TD class=Field <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="WaitForwardOpinion_Name8" value = "<%=WaitForwardOpinion_Name8%>" ></TD>
                <TD class=Field <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="WaitForwardOpinion_Name9" value = "<%=WaitForwardOpinion_Name9%>" ></TD>
                <TD><INPUT class=inputstyle type="checkbox" name="IsShowWaitForwardOpinion" value="1" <%   if(IsShowWaitForwardOpinion==1) {%> checked <% } %> <%if(IsPendingForward!=1) {%> disabled<%}%>></TD>
		        </TR>
                <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=6></TD>
		        </TR>
                <TR class="datalight">
				<TD><INPUT class=inputstyle type="checkbox" name="IsBeForwardModify" value="1" onclick="CheckClick('IsBeForwardModify')" <%   if(IsBeForwardModify==1) {%> checked <% } %> <%if(IsPendingForward!=1) {%> disabled<%}%>></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(22597,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="BeForwardModify_Name7" value = "<%=BeForwardModify_Name7%>" ></TD>
				<TD class=Field <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="BeForwardModify_Name8" value = "<%=BeForwardModify_Name8%>" ></TD>
                <TD class=Field <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="BeForwardModify_Name9" value = "<%=BeForwardModify_Name9%>" ></TD>
                <TD><INPUT class=inputstyle type="checkbox" name="IsShowBeForwardModify" value="1"  <%   if(IsShowBeForwardModify==1) {%> checked <% } %> ></TD>
		        </TR>
                <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=6></TD>
		        </TR>
                <TR class="datadark">
				<TD><INPUT class=inputstyle type="checkbox" name="IsBeForwardSubmit" value="1" onclick="CheckClick('IsBeForwardSubmit')" <%   if(IsBeForwardSubmit==1) {%> checked <% } %> <%if(IsPendingForward!=1) {%> disabled<%}%>></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(22596,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="BeForwardSubmit_Name7" value = "<%=BeForwardSubmit_Name7%>" ></TD>
				<TD class=Field <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="BeForwardSubmit_Name8" value = "<%=BeForwardSubmit_Name8%>" ></TD>
                <TD class=Field <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="BeForwardSubmit_Name9" value = "<%=BeForwardSubmit_Name9%>" ></TD>
                <TD><INPUT class=inputstyle type="checkbox" name="IsShowBeForwardSubmit" value="1"  <%   if(IsShowBeForwardSubmit==1) {%> checked <% } %> ></TD>
		        </TR>
                <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=6></TD>
		        </TR>
                <TR class="datalight">
				<TD><INPUT class=inputstyle type="checkbox" name="IsSubmitedOpinion" value="1" onclick="CheckClick('IsSubmitedOpinion')" <%   if(IsSubmitedOpinion==1) {%> checked <% } %> <%if(IsPendingForward!=1) {%> disabled<%}%>></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21755,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="SubmitedOpinion_Name7" value = "<%=SubmitedOpinion_Name7%>" ></TD>
				<TD class=Field <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="SubmitedOpinion_Name8" value = "<%=SubmitedOpinion_Name8%>" ></TD>
                <TD class=Field <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="SubmitedOpinion_Name9" value = "<%=SubmitedOpinion_Name9%>" ></TD>
                <TD><INPUT class=inputstyle type="checkbox" name="IsShowSubmitedOpinion" value="1"  <%   if(IsShowSubmitedOpinion==1) {%> checked <% } %> ></TD>
		        </TR>
                <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=6></TD>
		        </TR>
                <TR class="datadark">
				<TD><INPUT class=inputstyle type="checkbox" name="IsBeForwardPending" value="1" onclick="CheckClick('IsBeForwardPending')" <%   if(IsBeForwardPending==1) {%> checked <% } %> <%if(IsPendingForward!=1) {%> disabled<%}%>></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(22598,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="BeForwardPending_Name7" value = "<%=BeForwardPending_Name7%>" ></TD>
				<TD class=Field <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="BeForwardPending_Name8" value = "<%=BeForwardPending_Name8%>" ></TD>
                <TD class=Field <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="BeForwardPending_Name9" value = "<%=BeForwardPending_Name9%>" ></TD>
                <TD><INPUT class=inputstyle type="checkbox" name="IsShowBeForwardPending" value="1"  <%   if(IsShowBeForwardPending==1) {%> checked <% } %> ></TD>
		        </TR>
                <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=6></TD>
		        </TR>
                </TABLE>
            </td></tr>
            <tr><td height="5" colspan="2">&nbsp;</td></tr>
            <TR class="Title">
		        <TH><%=SystemEnv.getHtmlLabelName(21757,user.getLanguage())%></TH>
                <td><INPUT class=inputstyle type="checkbox" name="IssynHandled" value="1" ><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></td>
		    </TR>
		    <tr><td colspan="2">
                <TABLE class=liststyle cellspacing=1>
                <COLGROUP>
                <COL width="6">
                <COL width="30%">
                <COL>
                <COL>
                <COL>
                <COL width="12" align="center">
                <TR class="Spacing" style="height:1px;"><TD style="padding:0;" class="Line1" colspan=6></TD></TR>
                <TR class="header">
                    <TD><nobr><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
                    <TD><nobr><%=SystemEnv.getHtmlLabelName(21560,user.getLanguage())%></TD>
                    <TD><nobr><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>）</TD>
                    <TD <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><nobr><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>）</TD>
                    <TD <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><nobr><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(21866,user.getLanguage())%>）</TD>
                    <TD><nobr><%=SystemEnv.getHtmlLabelName(22595,user.getLanguage())%></TD>
                </TR>
                <TR class="Spacing" style="height:1px;">
                    <TD class="Line1" style="padding:0;" colSpan=6></TD>
                </TR>
                <TR class="datalight">
				<TD><INPUT class=inputstyle type="checkbox" name="IsSubmitForward" value="1" onclick="CheckClick('IsSubmitForward')" <%   if(IsSubmitForward==1) {%> checked <% } %> ></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21756,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="SubmitForward_Name7" value = "<%=SubmitForward_Name7%>" ></TD>
				<TD class=Field <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="SubmitForward_Name8" value = "<%=SubmitForward_Name8%>" ></TD>
                <TD class=Field <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="SubmitForward_Name9" value = "<%=SubmitForward_Name9%>" ></TD>
                <TD><INPUT class=inputstyle type="checkbox" name="IsShowSubmitForward" value="1"  disabled></TD>
		        </TR>
                <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=6></TD>
		        </TR>
                <TR class="datadark">
				<TD><INPUT class=inputstyle type="checkbox" name="IsBeForward" value="1" onclick="CheckClick('IsBeForward')" <%   if(IsBeForward==1) {%> checked <% } %> ></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21754,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="BeForward_Name7" value = "<%=BeForward_Name7%>" ></TD>
				<TD class=Field <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="BeForward_Name8" value = "<%=BeForward_Name8%>" ></TD>
                <TD class=Field <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="BeForward_Name9" value = "<%=BeForward_Name9%>" ></TD>
                <TD><INPUT class=inputstyle type="checkbox" name="IsShowBeForward" value="1"  <%   if(IsShowBeForward==1) {%> checked <% } %> ></TD>
		        </TR>
                <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=6></TD>
		        </TR>
                </TABLE>
            </td></tr>
            <%if(freeflow&&nodetype!=3&&nodeattribute!=1){%>
			<tr><td height="5" colspan="2">&nbsp;</td></tr>
            <TR class="Title">
		        <TH><%=SystemEnv.getHtmlLabelName(21779,user.getLanguage())%></TH>
                <td><INPUT class=inputstyle type="checkbox" name="IssynFreewf" value="1" ><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></td>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line1" colSpan=2></TD>
		    </TR>
		    <TR>
			    <TD><%=SystemEnv.getHtmlLabelName(21780,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=inputstyle type="checkbox" name="IsFreeWorkflow" value="1"  <%   if(IsFreeWorkflow==1) {%> checked <% } %>  onclick="showorhiddendiv(this)"></TD>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=2></TD>
		    </TR>
            <TR>
			    <TD colspan="2">
                    <div id="freewfdiv" style="display:<%if(IsFreeWorkflow!=1){%>none<%}%>">
                        <TABLE class=liststyle cellspacing=1>
                        <COLGROUP>
                        <COL width="16%">
                        <COL width="28%">
                        <COL width="28%">
                        <COL width="28%">
                            <TR>
                                <TD><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></TD>
                                <TD>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)<INPUT class=InputStyle maxLength=10 size=11 name="freewfsetcurnamecn" value = "<%=freewfsetcurnamecn%>"></TD>
                                <TD <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>>(<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>)<INPUT class=InputStyle maxLength=20 size=11 name="freewfsetcurnameen" value = "<%=freewfsetcurnameen%>"></TD>
                                <TD <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>>(<%=SystemEnv.getHtmlLabelName(21866,user.getLanguage())%>)<INPUT class=InputStyle maxLength=20 size=11 name="freewfsetcurnametw" value = "<%=freewfsetcurnametw%>"></TD>
                            </TR>
                            <TR class="Spacing" style="height:1px;">
                                <TD  class="Line"  style="padding:0;"  colSpan=4></TD>
                            </TR>
                        </TABLE>
				    </div>
                </TD>
		    </TR>
            <%}%>
			<!-- 签字意见是否必填 TD10404 -->
			<tr><td height="5" colspan="2">&nbsp;</td></tr>
            <TR class="Title">
		        <TH><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></TH>
                <td><INPUT class=inputstyle type="checkbox" id="issynremark" name="issynremark" value="1" ><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></td>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line1" colSpan=2></TD>
		    </TR>
		    <TR>
			    <TD><%=SystemEnv.getHtmlLabelName(22185,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=inputstyle type="checkbox" id="issignmustinput" name="issignmustinput" value="1" <%if(issignmustinput==1){%>checked<%}%> ></TD>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=2></TD>
		    </TR>
            <%
                if(ifchangstatus.equals("1")){
            %>
            <TR>
			    <TD><%=SystemEnv.getHtmlLabelName(24426,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=inputstyle type="checkbox" id="isfeedback" name="isfeedback" value="1" <%if(isfeedback==1){%>checked<%}%> onclick="FeedbackChange(this,'isnullnotfeedback')"></TD>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=2></TD>
		    </TR>
            <TR>
			    <TD><%=SystemEnv.getHtmlLabelName(24445,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=inputstyle type="checkbox" id="isnullnotfeedback" name="isnullnotfeedback" value="1" <%if(isfeedback==1&&isnullnotfeedback==1){%>checked<%}%> <%if(isfeedback!=1){%>disabled<%}%>></TD>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=2></TD>
		    </TR>
            <%}%>
            </TABLE>

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


</form>

</body>
</html>

<script language=javascript>

function onSave(){
<%if(isUseWebRevision.equals("1")){%>
    if(!document.all("isFormSignature").checked||check_form(document.SearchForm,'formSignatureWidth,formSignatureHeight')){
<%}%>
        document.all("src").value="save";
        document.SearchForm.submit();
<%if(isUseWebRevision.equals("1")){%>
    }
<%}%>
}

function showAttribute(obj){
    if(obj.checked){
        document.all("trline1").style.display = '';
        document.all("trline2").style.display = '';
        document.all("trwidth").style.display = '';
        document.all("trheight").style.display = '';
    }else{
    	document.all("trline1").style.display = 'none';
        document.all("trline2").style.display = 'none';
        document.all("trwidth").style.display = 'none';
        document.all("trheight").style.display = 'none';
    }
}
function onClose(){
    <%if(hassetting){%>
        window.parent.returnValue = "1"
    <%}else{%>
        window.parent.returnValue = "0"
    <%}%>
    window.parent.close();
}
function showorhiddendiv(obj){
    if(obj.checked){
        document.all("freewfdiv").style.display='';
    }else{
        document.all("freewfdiv").style.display='none';
    }
}
function CheckClick(checkname){
    if(checkname=="IsPendingForward"){
        if(document.all(checkname).checked){
            document.all("IsWaitForwardOpinion").disabled=false;
            document.all("IsBeForwardSubmit").disabled=false;
            document.all("IsBeForwardModify").disabled=false;
            document.all("IsBeForwardPending").disabled=false;
            document.all("IsSubmitedOpinion").disabled=false;
            document.all("IsShowWaitForwardOpinion").disabled=false;
            document.all("IsShowBeForwardSubmit").disabled=false;
            document.all("IsShowBeForwardModify").disabled=false;
            document.all("IsShowBeForwardPending").disabled=false;
            document.all("IsShowSubmitedOpinion").disabled=false;
        }else{
            document.all("IsWaitForwardOpinion").disabled=true;
            document.all("IsBeForwardSubmit").disabled=true;
            document.all("IsBeForwardModify").disabled=true;
            document.all("IsBeForwardPending").disabled=true;
            document.all("IsSubmitedOpinion").disabled=true;
            document.all("IsWaitForwardOpinion").checked=false;
            document.all("IsBeForwardSubmit").checked=false;
            document.all("IsBeForwardModify").checked=false;
            document.all("IsBeForwardPending").checked=false;
            document.all("IsSubmitedOpinion").checked=false;
            document.all("IsShowWaitForwardOpinion").disabled=true;
            document.all("IsShowBeForwardSubmit").disabled=true;
            document.all("IsShowBeForwardModify").disabled=true;
            document.all("IsShowBeForwardPending").disabled=true;
            document.all("IsShowSubmitedOpinion").disabled=true;
            document.all("IsShowWaitForwardOpinion").checked=false;
            document.all("IsShowBeForwardSubmit").checked=false;
            document.all("IsShowBeForwardModify").checked=false;
            document.all("IsShowBeForwardPending").checked=false;
            document.all("IsShowSubmitedOpinion").checked=false;
        }
    }
}
<%
if(src.equals("save") && design==0){
%>
onClose();
<%
}else if(src.equals("save") && design==1){
%>
designOnClose();
<%}%>
//工作流图形化确定
function designOnClose() {
	/**
		TD19600
	*/
	window.parent.design_callback('showFormSignatureOperate','<%=hassetting%>');

}
function FeedbackChange(obj,tdname){
    if(obj.checked){
        document.all(tdname).disabled=false;
    }else{
        document.all(tdname).checked=false;
        document.all(tdname).disabled=true;
    }
}
</script>