<%@ page language="java" contentType="text/html; charset=GBK" %> 
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="urlcominfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.request.ComparatorUtilBean" %>
<%@ page import="weaver.fna.budget.BudgetHandler" %>
<%@ page import="weaver.general.BaseBean" %>
<script type="text/javascript">
var trrigerfieldary="";
var trrigerdetailfieldary="";
</script>
<div style="display:none">
<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
</table>
</div>
<%
String acceptlanguage = request.getHeader("Accept-Language");
User user = HrmUserVarify.getUser (request , response) ;

int requestid = Util.getIntValue(request.getParameter("requestid"));
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int formid = Util.getIntValue(request.getParameter("formid"));
String billid = Util.null2String(request.getParameter("billid"));
String isbill = Util.null2String(request.getParameter("isbill"));
int Languageid = Util.getIntValue(request.getParameter("Languageid"));
String isurger=Util.null2String(request.getParameter("isurger"));
String _nodeid = Util.null2String(request.getParameter("nodeid"));
String nodetype = Util.null2String(request.getParameter("nodetype"));
int isprint = Util.getIntValue(request.getParameter("isprint"));
int intervenorright=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"intervenorright"),0);
int usertype = 0;
if(user.getLogintype().equals("1")) usertype = 0;
if(user.getLogintype().equals("2")) usertype = 1;
int creater = Util.getIntValue((String) session.getAttribute(user.getUID() + "_" + requestid + "creater"), 0);
int creatertype = Util.getIntValue((String) session.getAttribute(user.getUID() + "_" + requestid + "creatertype"), 0);
String creatername = ResourceComInfo.getResourcename("" + creater);
String intervenoruserids = "";
String intervenorusernames = "";
int nextnodeid = -1;
String nodeattr = "";
ArrayList BrancheNodes=new ArrayList();
ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段

String flowDocField="";
if (flowDocs!=null&&flowDocs.size()>1)
{

flowDocField=""+flowDocs.get(1);
}
String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));
if (docFlags.equals("")) docFlags=Util.null2String((String)session.getAttribute("requestAdd"+user.getUID()));

String isSignMustInput="0";
RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+_nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}
String organizationtype="";
String organizationid="";
String subject="";
String budgetperiod="";
String hrmremain="";
String hrmremaintype="";
String deptremain="";
String deptremaintype="";
String subcomremain="";
String subcomremaintype="";
String loanbalance="";
String loanbalancetype="";
String oldamount="";
String oldamounttype="";
if(isbill.equals("1")&&(formid==156 ||formid==157 ||formid==158 ||formid==159)){
    RecordSet.executeSql("select fieldname,id,type,fieldhtmltype from workflow_billfield where viewtype=1 and billid="+formid);
    while(RecordSet.next()){
        if("organizationtype".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        organizationtype="field"+RecordSet.getString("id");
        if("organizationid".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        organizationid="field"+RecordSet.getString("id");
        if("subject".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        subject="field"+RecordSet.getString("id");
        if("budgetperiod".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        budgetperiod="field"+RecordSet.getString("id");
        if("hrmremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            hrmremain="field"+RecordSet.getString("id");
            hrmremaintype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("deptremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            deptremain="field"+RecordSet.getString("id");
            deptremaintype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("subcomremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            subcomremain="field"+RecordSet.getString("id");
            subcomremaintype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("loanbalance".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            loanbalance="field"+RecordSet.getString("id");
            loanbalancetype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("oldamount".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            oldamount="field"+RecordSet.getString("id");
            oldamounttype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
    }
}
BudgetHandler bp = new BudgetHandler();

FieldInfo.setRequestid(requestid);
FieldInfo.setUser(user);
FieldInfo.GetManTableField(formid,Util.getIntValue(isbill),Languageid);
FieldInfo.GetDetailTableField(formid,Util.getIntValue(isbill),Languageid);
FieldInfo.GetWorkflowNode(workflowid);

ArrayList mantablefields=FieldInfo.getManTableFields();
ArrayList manfieldvalues=FieldInfo.getManTableFieldValues();
ArrayList manfielddbtypes=FieldInfo.getManTableFieldDBTypes();
ArrayList detailtablefields=FieldInfo.getDetailTableFields();
ArrayList detailfieldvalues=FieldInfo.getDetailTableFieldValues();
ArrayList detailtablefieldids=FieldInfo.getDetailTableFieldIds();
ArrayList ManUrlList=FieldInfo.getManUrlList();
ArrayList ManUrlLinkList=FieldInfo.getManUrlLinkList();
ArrayList DetailUrlList=FieldInfo.getDetailUrlList();
ArrayList DetailUrlLinkList=FieldInfo.getDetailUrlLinkList();
ArrayList NodeList=FieldInfo.getNodes();
ArrayList DetailFieldDBTypes=FieldInfo.getDetailFieldDBTypes();

ArrayList mantablefieldlables=new ArrayList();
ArrayList detailtablefieldlables=new ArrayList();
mantablefieldlables=FieldInfo.getManTableFieldNames();
detailtablefieldlables=FieldInfo.getDetailTableFieldNames();

String fieldid="";
String fieldvalue="";
String filedname="";
String url="";
String urllink="";
for(int i=0; i<mantablefields.size();i++){
    int htmltype=1;
    int type=1;
    int indx=-1;
    fieldid=(String)mantablefields.get(i);
    filedname=(String)mantablefieldlables.get(i);
    fieldvalue=(String)manfieldvalues.get(i);
    url=(String)ManUrlList.get(i);
    urllink=(String)ManUrlLinkList.get(i);
    indx=fieldid.lastIndexOf("_");
    if(indx>0){
        htmltype=Util.getIntValue(fieldid.substring(indx+1),1);
        fieldid=fieldid.substring(0,indx);            
    }
    indx=fieldid.lastIndexOf("_");
    if(indx>0){
        type=Util.getIntValue(fieldid.substring(indx+1),1);
        fieldid=fieldid.substring(0,indx);    
    }
    if(htmltype==6){
        ArrayList filenum=new ArrayList();
        if(!fieldvalue.equals("")){
            filenum=Util.TokenizerString(fieldvalue,",");
        }        
%>   
    <input type=hidden id="<%=fieldid%>_num" name='<%=fieldid%>_num' value="0"> 
    <input type=hidden name="<%=fieldid%>_idnum" value="<%=filenum.size()%>">
    <input type=hidden temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=fieldvalue%>">
<%
    }else{
        if(htmltype==3){            
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=fieldvalue%>">
    <input type="hidden" name="<%=fieldid%>_url" value="<%=url%>">
    <input type="hidden" name="<%=fieldid%>_urllink" value="<%=urllink%>">
    <input type="hidden" name="<%=fieldid%>_linkno" value="">
<%
        }else if(htmltype==7&&type==1){
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=fieldvalue%>">
    <input type="hidden" name="<%=fieldid%>_url" value="<%=url%>">
    <input type="hidden" name="<%=fieldid%>_urllink" value="<%=urllink%>">
    <input type="hidden" name="<%=fieldid%>_linkno" value="">
<%
        }else{
	if(htmltype==2&&type==2) {%>
	 <textarea style="display:none" temptitle="<%=filedname%>" name="<%=fieldid%>"><%=FieldInfo.toScreen(fieldvalue)%></textarea>	
	<%}
	else {
		String ffieldvalue = FieldInfo.toScreen(Util.StringReplace(fieldvalue,"\"","&quot;"));
    	if(htmltype == 2 && type == 1) {
    		ffieldvalue = Util.StringReplace(ffieldvalue, "<", "&lt;");
    		ffieldvalue = Util.StringReplace(ffieldvalue, ">", "&gt;");
    	}
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=ffieldvalue%>">
<%
	}   }
    }
}

//标题,紧急程度，是否短信提醒
String requestlevel = Util.null2String(request.getParameter("requestlevel"));
String requestname = Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"requestname"));
String sqlWfMessage = "select a.messagetype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.messagetype='1' and a.requestid="+requestid ;
RecordSet.executeSql(sqlWfMessage);
int rqMessageType=0;
if(RecordSet.next()){
	rqMessageType=RecordSet.getInt("messagetype");
}
%>
<%RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+_nodeid+" and fieldid=-1");
if(RecordSet.next()){//如果在模板中设置了标题，下面的隐含字段作为标题对象保存数据
%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>" name="requestname" value="<%=FieldInfo.toScreen(Util.StringReplace(requestname,"\"","&quot;"))%>">
<%}%>
<%RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+_nodeid+" and fieldid=-2");
if(RecordSet.next()){//如果在模板中设置了紧急程度，下面的隐含字段作为紧急程度对象保存数据
%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>" name="requestlevel" value="<%=requestlevel%>">
<%}%>
<%RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+_nodeid+" and fieldid=-3");
if(RecordSet.next()){//如果在模板中设置了是否短信提醒，下面的隐含字段作为是否短信提醒保存数据
%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%>" name="messageType" value="<%=rqMessageType%>">
<%}%>
<%
for(int i=0; i<detailtablefields.size();i++){
String fieldlable="";
    ArrayList detaillist=(ArrayList)detailtablefields.get(i);
    ArrayList detaillablelist=(ArrayList)detailtablefieldlables.get(i);
    ArrayList detailurls=(ArrayList)DetailUrlList.get(i);
    ArrayList detailurllinks=(ArrayList)DetailUrlLinkList.get(i);
    ArrayList detailvalues=(ArrayList)detailfieldvalues.get(i);
    ArrayList detailfieldids=(ArrayList)detailtablefieldids.get(i);
    int htmltype=1;
    int type=1;
    int indx=-1;
    int row=0;
    for(int j=0;j<detailfieldids.size();j++){
        ArrayList fieldids=(ArrayList)detailfieldids.get(j);
        ArrayList fieldvalues=(ArrayList)detailvalues.get(j);
        url=(String)detailurls.get(j);
        urllink=(String)detailurllinks.get(j);
        String fieldname=(String)detaillist.get(j);
        String tempfieldname=fieldname.substring(0,fieldname.indexOf("_"));
        fieldlable=(String)detaillablelist.get(j);
        if(Util.getIntValue(fieldname.substring(fieldname.lastIndexOf("_")+1),1)==3){
 %>
    <input type="hidden" name="<%=fieldname.substring(0,fieldname.indexOf("_"))%>_url" value="<%=url%>">
    <input type="hidden" name="<%=fieldname.substring(0,fieldname.indexOf("_"))%>_urllink" value="<%=urllink%>">
    <input type="hidden" name="<%=fieldname.substring(0,fieldname.indexOf("_"))%>_linkno" value="">
<%
        }
        row=fieldids.size();
        for(int k=0;k<fieldids.size();k++){
            fieldid=(String)fieldids.get(k);
            fieldvalue=(String)fieldvalues.get(k);
            indx=fieldid.lastIndexOf("_");
            if(indx>0){
                htmltype=Util.getIntValue(fieldid.substring(indx+1),1);
                fieldid=fieldid.substring(0,indx);            
            }
            indx=fieldid.lastIndexOf("_");
            if(indx>0){
                type=Util.getIntValue(fieldid.substring(indx+1),1);
                fieldid=fieldid.substring(0,indx);    
            }
            if(htmltype==3 && (type==16 || type==152 || type==171)){ %>
                <input type="hidden" name="<%=fieldid%>_linkno" value="">
            <%}
        }%>
            <input type="hidden"  value="<%=fieldlable%>" name="temp_<%=tempfieldname%>">
            <%
    }
%>
    <input type=hidden name="indexnum<%=i%>" id="indexnum<%=i%>" value="0">
    <input type=hidden name="nodesnum<%=i%>" id="nodesnum<%=i%>" value="0">
    <input type=hidden name="totalrow<%=i%>" id="totalrow<%=i%>" value="0">
    <input type=hidden name="tempdetail<%=i%>" id="tempdetail<%=i%>" value="<%=row%>">
<%
}
%>

<span  id=createDocButtonSpan><button id='createdoc' style='display:none' class=AddDoc onclick=createDocForNewTab('','0')></button></span>

<input type="hidden" name="flowDocField" value="<%=flowDocField%>">
<input type="hidden" name="requestid" value="<%=requestid%>">
<input type="hidden" name="workflowid" value="<%=workflowid%>">
<input type="hidden" name="formid" value="<%=formid%>">
<input type="hidden" name="billid" value="<%=billid%>">
<input type="hidden" name="isbill" value="<%=isbill%>">
<input type="hidden" name="nodeid" value="<%=_nodeid%>">
<input type="hidden" name="nodetype" value="<%=nodetype%>">

<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<iframe name="delzw" width=0 height=0></iframe>
<% if((isurger.trim().equals("true")||intervenorright>0) && isprint!=1){
if(intervenorright>0){
        String billtablename = "";
        int operatorsize = 0;

        WFNodeMainManager.setWfid(workflowid);
        WFNodeMainManager.selectWfNode();
        while (WFNodeMainManager.next()) {
            if (WFNodeMainManager.getNodeid() == Util.getIntValue(_nodeid))
                nodeattr = WFNodeMainManager.getNodeattribute();
        }
        if(nodeattr.equals("2")){
            BrancheNodes=WFLinkInfo.getFlowBrancheNodes(requestid,workflowid);
        }
        boolean hasnextnodeoperator = false;
        Hashtable operatorsht = new Hashtable();


        if (isbill.equals("1")) {
            RecordSet.executeSql("select tablename from workflow_bill where id = " + formid); // 查询工作流单据表的信息
            if (RecordSet.next())
                billtablename = RecordSet.getString("tablename");          // 获得单据的主表
        }
//查询节点操作者
        requestNodeFlow.setRequestid(requestid);
        requestNodeFlow.setNodeid(Util.getIntValue(_nodeid));
        requestNodeFlow.setNodetype("" + nodetype);
        requestNodeFlow.setWorkflowid(workflowid);
        requestNodeFlow.setUserid(user.getUID());
        requestNodeFlow.setUsertype(usertype);
        requestNodeFlow.setCreaterid(creater);
        requestNodeFlow.setCreatertype(creatertype);
        requestNodeFlow.setIsbill(Util.getIntValue(isbill));
        requestNodeFlow.setBillid(Util.getIntValue(billid));
        requestNodeFlow.setBilltablename(billtablename);
        requestNodeFlow.setRecordSet(RecordSet);
        hasnextnodeoperator = requestNodeFlow.getNextNodeOperator();

        if (hasnextnodeoperator) {
            operatorsht = requestNodeFlow.getOperators();
            nextnodeid = requestNodeFlow.getNextNodeid();
            operatorsize = operatorsht.size();
            if (operatorsize > 0) {

                TreeMap map = new TreeMap(new ComparatorUtilBean());
                Enumeration tempKeys = operatorsht.keys();
                try{
                while (tempKeys.hasMoreElements()) {
                    String tempKey = (String) tempKeys.nextElement();
                    ArrayList tempoperators = (ArrayList) operatorsht.get(tempKey);
                    map.put(tempKey, tempoperators);
                }
                }catch(Exception e){}
                Iterator iterator = map.keySet().iterator();
                while (iterator.hasNext()) {
                    String operatorgroup = (String) iterator.next();
                    ArrayList operators = (ArrayList) operatorsht.get(operatorgroup);
                    for (int i = 0; i < operators.size(); i++) {
                        String operatorandtype = (String) operators.get(i);
                        String[] operatorandtypes = Util.TokenizerString2(operatorandtype, "_");
                        String opertor = operatorandtypes[0];
                        String opertortype = operatorandtypes[1];
                        intervenoruserids += opertor + ",";
                        if ("0".equals(opertortype)) {
                            intervenorusernames += "<A href='javaScript:openhrm(" + opertor + ");' onclick='pointerXY(event);'>" + ResourceComInfo.getResourcename(opertor) + "</A>&nbsp;";
                        } else {
                            intervenorusernames += CustomerInfoComInfo.getCustomerInfoname(opertor) + " ";
                        }

                    }
                }
            }
        }
        if (intervenoruserids.length() > 1) {
            intervenoruserids = intervenoruserids.substring(0, intervenoruserids.length() - 1);
        }
%>
<iframe id="workflownextoperatorfrm" frameborder=0 scrolling=no src=""  style="display:none;"></iframe>
<%
}
String isannexupload_edit="";
String annexdocCategory_edit="";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
RecordSet.execute("select isannexupload,annexdocCategory,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isannexupload_edit=Util.null2String(RecordSet.getString("isannexupload"));
    annexdocCategory_edit=Util.null2String(RecordSet.getString("annexdocCategory"));
    isSignDoc_edit=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
%>

<table width="100%" id="t_sign">
<tr>
<td width="50%"  valign="top">
<!-- added end. -->
<%--added by xwj for td 2104 on 2005-08-1 begin--%>
  <table class="viewform">
        <!-- modify by xhheng @20050308 for TD 1692 -->
         <COLGROUP>
         <COL width="20%">
         <COL width="80%">
         <%if(intervenorright>0){%>
         <tr><td colspan="2"><b><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%></b></td></tr>
         <TR class=spacing>
            <TD class=line1 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(18914,user.getLanguage())%></td>
             <td class=field>
                 <select class=inputstyle  id="submitNodeId" name=submitNodeId  onChange='nodechange(this.value)'  temptitle="<%=SystemEnv.getHtmlLabelName(18914,user.getLanguage())%>">
                 <option value="" ></option>
                 <%
                 WFNodeMainManager.setWfid(workflowid);
                 WFNodeMainManager.selectWfNode();
                 boolean hasnodeid=false;
                 while(WFNodeMainManager.next()){
                    int tmpid = WFNodeMainManager.getNodeid();
                    //if(tmpid==nodeid) continue;
                    String tmpname = WFNodeMainManager.getNodename();
                    String tmptype = WFNodeMainManager.getNodetype();
                    String tempnodeattr=WFNodeMainManager.getNodeattribute();
                    if(nodeattr.equals("2")){
                        if(!tempnodeattr.equals("2")){
                            if(tmpid==nextnodeid){
                                intervenoruserids="";
                                intervenorusernames="";
                            }
                            continue;
                        }else if(BrancheNodes.indexOf(""+tmpid)==-1){
                            continue;
                        }
                    }else{
                        if(tempnodeattr.equals("2")){
                            if(tmpid==nextnodeid){
                                intervenoruserids="";
                                intervenorusernames="";
                            }
                            continue;
                        }
                    }
                 %>
                 <option value="<%=tmpid%>_<%=tmptype%>" <%if(nextnodeid==tmpid){hasnodeid=true;%>selected<%}%>><%=tmpname%></option>
                 <%}%>
                 </select>
                 <span id="submitNodeIdspan"><%if(!hasnodeid){%><img src='/images/BacoError.gif' align=absmiddle><%}%></span>
             </td>
         </tr>
	<TR class=spacing>
            <TD class=line2 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(21790,user.getLanguage())%></td>
             <td class=field>
                 <select class=inputstyle  id="SignType" name=SignType>
                 <option value="0" ><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%></option>
                 <option value="1" ><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%></option>
                 <option value="2" ><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%></option>
                 </select>
             </td>
         </tr>
    <TR class=spacing>
            <TD class=line2 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(18915,user.getLanguage())%></td>
             <td class=field>
                 <span id="Intervenorspan">
                     <button class=Browser onclick="onShowMutiHrm('Intervenorspan','Intervenorid')" ></button><%=intervenorusernames%><%if(intervenorusernames.equals("")){%><img src='/images/BacoError.gif' align=absmiddle><%}%></span>
                 <input type=hidden name="Intervenorid" value="<%=intervenoruserids%>" temptitle="<%=SystemEnv.getHtmlLabelName(18915,user.getLanguage())%>">
             </td>
         </tr>
    <TR class=spacing>
            <TD class=line2 colSpan=2></TD>
        </TR>
         <%
         }
        int annexmainId=0;
         int annexsubId=0;
         int annexsecId=0;

         if("1".equals(isannexupload_edit) && annexdocCategory_edit!=null && !annexdocCategory_edit.equals("")){
            annexmainId=Util.getIntValue(annexdocCategory_edit.substring(0,annexdocCategory_edit.indexOf(',')));
            annexsubId=Util.getIntValue(annexdocCategory_edit.substring(annexdocCategory_edit.indexOf(',')+1,annexdocCategory_edit.lastIndexOf(',')));
            annexsecId=Util.getIntValue(annexdocCategory_edit.substring(annexdocCategory_edit.lastIndexOf(',')+1));
          }
         int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
         if(annexmaxUploadImageSize<=0){
            annexmaxUploadImageSize = 5;
         }
         char flag1 = Util.getSeparator();
         RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+user.getUID()+flag1+""+(Util.getIntValue(user.getLogintype())-1)+flag1+"1");
         String myremark = "" ;
         String annexdocids = "" ;
         String signdocids="";
         String signworkflowids="";
         if(RecordSet.next())
         {
            myremark = Util.toScreenToEdit(RecordSet.getString("remarkText"),Languageid) ;
            annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
            signdocids=Util.null2String(RecordSet.getString("signdocids"));
			signworkflowids=Util.null2String(RecordSet.getString("signworkflowids"));
         }
         String signdocname="";
        String signworkflowname="";
        ArrayList templist=Util.TokenizerString(signdocids,",");
        for(int i=0;i<templist.size();i++){
            signdocname+="<a href='/docs/docs/DocDsp.jsp?isrequest=1&id="+templist.get(i)+"' target='_blank'>"+docinf.getDocname((String)templist.get(i))+"</a> ";
        }
        templist=Util.TokenizerString(signworkflowids,",");
        int vtempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
        for(int i=0;i<templist.size();i++){
                vtempnum++;
                session.setAttribute("resrequestid" + vtempnum, "" + templist.get(i));
            signworkflowname+="<a style=\"cursor:hand\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+templist.get(i)+"&wflinkno="+vtempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
        }
        session.setAttribute("slinkwfnum", "" + vtempnum);
        session.setAttribute("haslinkworkflow", "1");
         //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+user.getUID());
         //add by cyril on 2008-09-30 for td:9014
         boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+user.getUID()); 
         String workflowPhrases[] = new String[RecordSet.getCounts()];
         String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
         int x = 0 ;
         if (isSuccess) {
         	while (RecordSet.next()){
         		workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
         		workflowPhrasesContent[x] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
         		x ++ ;
         	}
         }
         //end by cyril on 2008-09-30 for td:9014
         /*----------xwj for td3034 20051118 begin ------*/
         %>
         <tr class="Title">
                  <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,Languageid)%></font></td>
                </tr>
            <tr>
              <td><%=SystemEnv.getHtmlLabelName(17614,Languageid)%></td>
              <td class=field>
               <%
         if(workflowPhrases.length>0){
         %>
                <select class=inputstyle  id="phraseselect" name=phraseselect style="width:80%" onChange='onAddPhrase(this.value)'>
                <option value="">－－<%=SystemEnv.getHtmlLabelName(22409,Languageid)%>－－</option>
                <%
                  for (int i= 0 ; i <workflowPhrases.length;i++) {
                    String workflowPhrase = workflowPhrases[i] ;  %>
                    <option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
                <%}%>
                </select>
              <%}%>
				<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(17614,Languageid)%>" value="">
              <textarea  class=Inputstyle name=remark rows=4 cols=40 style="width:80%"  temptitle="<%=SystemEnv.getHtmlLabelName(17614,Languageid)%>"   <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%>><%=myremark%></textarea>
	  		   	<script defer>
	  		   	function funcremark_log(){
					FCKEditorExt.initEditor("frmmain","remark",<%=Languageid%>,FCKEditorExt.NO_IMAGE);
				<%if(isSignMustInput.equals("1")){%>
					FCKEditorExt.checkText("remarkSpan","remark");
				<%}%>
					FCKEditorExt.toolbarExpand(false,"remark");
				}
	  			//window.attachEvent("onload", funcremark_log);
	  			if (window.addEventListener){
	  			    window.addEventListener("load", funcremark_log, false);
	  			}else if (window.attachEvent){
	  			    window.attachEvent("onload", funcremark_log);
	  			}else{
	  			    window.onload=funcremark_log;
  				}	
				</script>
              <span id="remarkSpan">
<%
	if(isSignMustInput.equals("1")&&"".equals(myremark)){
%>
			  <img src="/images/BacoError.gif" align=absmiddle>
<%
	}
%>
              </span>
          </td> </tr>
         <tr><td class=Line2 colSpan=2></td></tr>
  <%
         if("1".equals(isSignDoc_edit)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,Languageid)%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids" value="<%=signdocids%>">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,Languageid)%>"></button>
                <span id="signdocspan"><%=signdocname%></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_edit)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,Languageid)%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids" value="<%=signworkflowids%>">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,Languageid)%>"></button>
                <span id="signworkflowspan"><%=signworkflowname%></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isannexupload_edit)){
         %>
        <tr>
            <td><%=SystemEnv.getHtmlLabelName(22194,Languageid)%></td>
            <td class=field>
          <table cols=3 id="field-annexupload_tab">
          <tbody ><col width="50%" >
            <col width="25%" >
            <col width="25%">
           <%
            int linknum=-1;
            if(!annexdocids.equals("")){
            RecordSet.executeSql("select id,docsubject,accessorycount from docdetail where id in("+annexdocids+") order by id asc");
            while(RecordSet.next()){
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),Languageid) ;
              int accessoryCount=RecordSet.getInt(3);

              DocImageManager.resetParameter();
              DocImageManager.setDocid(Util.getIntValue(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }

              String imgSrc= AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              %>

          <tr>
            <input type=hidden name="field-annexupload_del_<%=linknum%>" value="0" >
            <td >
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp
              <%}%>
              <input type=hidden name="field-annexupload_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td >
                <button class=btnFlow accessKey=1  onclick='onChangeSharetype("span-annexupload_id_<%=linknum%>","field-annexupload_del_<%=linknum%>","0",<%=annexmaxUploadImageSize%>)'><u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,Languageid)%>
                </button><span id="span-annexupload_id_<%=linknum%>" name="span-annexupload_id_<%=linknum%>" style="visibility:hidden">
                    <b><font COLOR="#FF0033">√</font></b>
                  <span>
            </td>
            <%if(accessoryCount==1){%>
            <td >
              <span id = "selectDownload">
                <%
                  boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Util.getIntValue(showid));
                  if(!isLocked){
                %>
                  <button class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,Languageid)%>	  (<%=docImagefileSize/1000%>K)
                  </button>
                <%}%>
              </span>
            </td>
            <%}%>
          </tr>
              <%}}%>
            <input type=hidden name="field-annexupload_idnum" value=<%=linknum+1%>>
            <input type=hidden name="field-annexupload_idnum_1" value=<%=linknum+1%>>
          <tr>
            <td colspan=3>
            <%if(annexsecId<1){%>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(21418,Languageid)+SystemEnv.getHtmlLabelName(15808,Languageid)%>!</font>
           <%}else{%>
              <script>
          var oUploadannexupload;
          function fileuploadannexupload() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId":"<%=annexmainId%>",
                "subId":"<%=annexsubId%>",
                "secId":"<%=annexsecId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>"
            },
            file_size_limit :"<%=annexmaxUploadImageSize%> MB",
            file_types : "*.*",
            file_types_description : "All Files",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgressannexupload",
                cancelButtonId : "btnCancelannexupload",
                uploadfiedid:"field-annexupload"
            },
            debug: false,


            // Button settings

            button_image_url : "/js/swfupload/add.png",    // Relative to the SWF file
            button_placeholder_id : "spanButtonPlaceHolderannexupload",

            button_width: 100,
            button_height: 18,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
            button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 0,
            button_text_left_padding: 18,

            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            // The event handler functions are defined in handlers.js
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_2,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };


        try {
            oUploadannexupload=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileuploadannexupload);
        	if (window.addEventListener){
  			    window.addEventListener("load", fileuploadannexupload, false);
  			}else if (window.attachEvent){
  			    window.attachEvent("onload", fileuploadannexupload);
  			}else{
  			    window.onload=fileuploadannexupload;
  			}	
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolderannexupload"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUploadannexupload.cancelQueue();" id="btnCancelannexupload">
									<span><img src="/js/swfupload/delete.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span>(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="field-annexuploadspan"></span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field-annexupload" value="<%=annexdocids%>">
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgressannexupload">
                  </div>
                  <div id="divStatusannexupload"></div>
              </td>
          </tr>
      </TABLE>
           <%}%>
            <input type=hidden name='annexmainId' value=<%=annexmainId%>>
          <input type=hidden name='annexsubId' value=<%=annexsubId%>>
          <input type=hidden name='annexsecId' value=<%=annexsecId%>>
            </td>
          </tr>
          </tbody>
          </table>
          </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>      
         <%}%>
        </table>
    </td> </tr>
</table>
<%}else{%>
<input type="hidden" name="remark" value="">
<input type=hidden name="signdocids" value="">
<input type=hidden name='signworkflowids' value="">
<%}%>
<script language=javascript>
var rowgroup=new Array();
function getRowGroup(){
<%
    for(int i=0; i<detailtablefields.size();i++){
%>
        var headrow=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_head");
        var endrow=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_end");
        if(headrow==null || headrow=="" || endrow==null || endrow=="" || endrow-headrow-1<1){
            rowgroup[<%=i%>]=0;
        }else{
            rowgroup[<%=i%>]=(endrow-headrow-1);
        }
<%
    }
%>
}

function setmantable(){
    var wcell=frmmain.ChinaExcel;
    try{
    	//标题
    	var temprow1=wcell.GetCellUserStringValueRow("requestname");
    	var tempcol1=wcell.GetCellUserStringValueCol("requestname");
    	if(temprow1>0){
	    	document.all("needcheck").value=document.all("needcheck").value+",requestname";
		    wcell.SetCellVal(temprow1,tempcol1,getChangeField('<%=FieldInfo.toExcel(Util.encodeJS(requestname))%>'));
		    imgshoworhide(temprow1,tempcol1);
		  }
	    
	    //紧急程度
    	var temprow2=wcell.GetCellUserStringValueRow("requestlevel");
    	var tempcol2=wcell.GetCellUserStringValueCol("requestlevel");
    	if(temprow2>0){
		   	//wcell.SetCellComboType1(temprow2,tempcol2,false,true,false,"<%=SystemEnv.getHtmlLabelName(225,Languageid)%>;<%=SystemEnv.getHtmlLabelName(15533,Languageid)%>;<%=SystemEnv.getHtmlLabelName(2087,Languageid)%>","0;1;2");
	      if("<%=requestlevel%>"==0) wcell.SetCellVal(temprow2,tempcol2,getChangeField("<%=SystemEnv.getHtmlLabelName(225,Languageid)%>")); 
	      if("<%=requestlevel%>"==1) wcell.SetCellVal(temprow2,tempcol2,getChangeField("<%=SystemEnv.getHtmlLabelName(15533,Languageid)%>")); 
	      if("<%=requestlevel%>"==2) wcell.SetCellVal(temprow2,tempcol2,getChangeField("<%=SystemEnv.getHtmlLabelName(2087,Languageid)%>")); 
	      document.all("requestlevel").value="<%=requestlevel%>";
		    imgshoworhide(temprow2,tempcol2);
		  }
	    
	    //是否短信提醒
    	var temprow3=wcell.GetCellUserStringValueRow("messageType");
    	var tempcol3=wcell.GetCellUserStringValueCol("messageType");
    	if(temprow3>0){
		   	//wcell.SetCellComboType1(temprow3,tempcol3,false,true,false,"<%=SystemEnv.getHtmlLabelName(17583,Languageid)%>;<%=SystemEnv.getHtmlLabelName(17584,Languageid)%>;<%=SystemEnv.getHtmlLabelName(17585,Languageid)%>","0;1;2");
	      if("<%=rqMessageType%>"==0) wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17583,Languageid)%>")); 
	      if("<%=rqMessageType%>"==1) wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17584,Languageid)%>")); 
	      if("<%=rqMessageType%>"==2) wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17585,Languageid)%>")); 
	      document.all("messageType").value="<%=rqMessageType%>";
		    imgshoworhide(temprow3,tempcol3);
		  }
		  
		  //签字
    	var temprow4=wcell.GetCellUserStringValueRow("qianzi");
    	var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
    	if(temprow4>0){
    		wcell.DeleteCellImage(temprow4,tempcol4,temprow4,tempcol4);
    	}

		//重新生成编号
    	var temprow5=wcell.GetCellUserStringValueRow("main_createCodeAgain");
    	var tempcol5=wcell.GetCellUserStringValueCol("main_createCodeAgain");
    	if(temprow5>0){
			imghide(temprow5,tempcol5);
    	}
  	}catch(e){}
<%
    for(int i=0; i<mantablefields.size();i++){
        String fid=(String)mantablefields.get(i);
        String fvalue=(String)manfieldvalues.get(i);
		String dbtype=(String)manfielddbtypes.get(i);
%>
    var nrow=wcell.GetCellUserStringValueRow("<%=fid%>");
    if(nrow>0){
        var ncol=wcell.GetCellUserStringValueCol("<%=fid%>");
<%
        int htmltype=1;    
        int ftype=0;
        String tmpfid=fid;
        int indx=tmpfid.lastIndexOf("_");
        if(indx>0){
           htmltype=Util.getIntValue(tmpfid.substring(indx+1),1);
           tmpfid=tmpfid.substring(0,indx); 
           indx=tmpfid.lastIndexOf("_");
            if(indx>0){
               ftype=Util.getIntValue(tmpfid.substring(indx+1),1);   
               tmpfid=tmpfid.substring(0,indx); 
            }
        } 
        if(htmltype==5){
            FieldInfo.getSelectItem(fid,isbill);
            ArrayList  SelectItems=FieldInfo.getSelectItems();
            ArrayList SelectItemValues=FieldInfo.getSelectItemValues();
            String Combostr="";
            fvalue="";
            for(int j=0;j<SelectItems.size();j++){
                String selectname=(String)SelectItems.get(j);
                String selectvalue=(String)SelectItemValues.get(j);
                Combostr+=";"+selectname;
%>
                var fieldvalue=document.getElementById("<%=tmpfid%>").value;
                var selvalue="<%=selectvalue%>";
                if(fieldvalue==selvalue){
                    wcell.SetCellVal(nrow,ncol,getChangeField('<%=FieldInfo.toExcel(Util.encodeJS(selectname))%>'));
                }
<%
            }
%>
        wcell.SetCellComboType(nrow,ncol,false,false,"<%=Util.encodeJS(Combostr)%>");           
<%
        }
        if(htmltype==4){
%>
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
        wcell.SetCellCheckBoxType(nrow,ncol);        
<%
            if(fvalue.equals("1")){
%>
        wcell.SetCellCheckBoxValue(nrow,ncol,true);
<%
            }
%>
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
        }
        if(htmltype==3){
            if(ftype==16 || ftype==152 || ftype==171){
                ArrayList tempshowidlist=Util.TokenizerString(fvalue,",");
                String linknums="";
                int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                for(int t=0;t<tempshowidlist.size();t++){
                    tempnum++;
                    session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(t));
                    linknums+=tempnum+",";
                }
                session.setAttribute("slinkwfnum",""+tempnum);
                session.setAttribute("haslinkworkflow","1");
                if(linknums.length()>0) linknums=linknums.substring(0,linknums.length()-1);
%>
                document.all("<%=tmpfid%>_linkno").value="<%=linknums%>";
<%
            }

            if( ftype==9&&docFlags.equals("1") && tmpfid.equals("field"+flowDocField) ) {
%>

            createDocButtonSpan.innerHTML="<button id='createdoc' style='display:none' class=AddDoc onclick=createDocForNewTab('<%=tmpfid%>','0')></button>"
<%
            }
            fvalue=FieldInfo.getFieldName(fvalue,ftype,dbtype);
        }
        if(htmltype==6){            
			if("-2".equals(fvalue)){
				fvalue = SystemEnv.getHtmlLabelName(21710, user.getLanguage());
%>
		var color_red = wcell.GetRGBValue(255, 0, 0);
		if(wcell.IsCellProtect(nrow,ncol) == true){
			wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
			wcell.SetCellTextColor(nrow, ncol, nrow, ncol, color_red);
			wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
		}else{
			wcell.SetCellTextColor(nrow, ncol, nrow, ncol, color_red);
		}
<%
			}else{
				fvalue=FieldInfo.getFileName(fvalue);
				fvalue=Util.StringReplace(fvalue,",","<br>");
			}

        }
        if(htmltype!=4 && htmltype!=5){
        	String ffvalue = Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(fvalue)));
        	if(htmltype == 2 && ftype == 1) {
        		ffvalue = Util.StringReplace(ffvalue, "<", "&lt;");
        		ffvalue = Util.StringReplace(ffvalue, ">", "&gt;");
        	}
%>
            var Formula=wcell.GetCellFormula(nrow,ncol);
            if(Formula==null || Formula==""){
                var strtxt = '<%=ffvalue%>';
<%
        if(htmltype==2&&ftype==2){
%>
    	strtxt = getFckText(strtxt);
<%
        }
%>
            wcell.SetCellVal(nrow,ncol,getChangeField(strtxt));
            }
<%
        }
%>
    imghide(nrow,ncol);
    }
<%
    }
%>
}
function setdetailtable(){
    var wcell=frmmain.ChinaExcel;    
<%
    String fid="";
    String fvalue="";
	String dfielddbtype="";
    for(int i=0; i<detailtablefieldids.size();i++){
%>
    var totalrow=parseInt(document.getElementById("tempdetail<%=i%>").value);
    for(var row=0;row<totalrow;row++){
    rowIns("<%=i%>",1,1);
    }
    var selcol=wcell.GetCellUserStringValueCol("detail<%=i%>_sel");
    var nInsertAfterRow=wcell.GetCellUserStringValueRow("detail<%=i%>_end"); 
    var nInsertRows=rowgroup[<%=i%>];
    if(selcol>0 && nInsertAfterRow>0){
        if("<%=(i+1)%>"=="<%=detailtablefieldids.size()%>")
        wcell.SetCellCheckBoxValue(nInsertAfterRow-nInsertRows,selcol,false);
    }
<%
        ArrayList dfids=(ArrayList)detailtablefieldids.get(i);
        ArrayList dfvalues=(ArrayList)detailfieldvalues.get(i);
		ArrayList dfielddbtypes=(ArrayList)DetailFieldDBTypes.get(i);
        ArrayList torgtypevalues=new ArrayList();
        ArrayList tbudgetperiodvalues=new ArrayList();
        ArrayList torgidvalues=new ArrayList();
        ArrayList tsubjectvalues=new ArrayList();
        for(int j=0;j<dfids.size();j++){
            ArrayList fids=(ArrayList)dfids.get(j);
            ArrayList fvalues=(ArrayList)dfvalues.get(j);
			dfielddbtype=(String)dfielddbtypes.get(j);
            for(int k=0;k<fids.size();k++){
                fid=(String)fids.get(k);
                fvalue=(String)fvalues.get(k);
                if(fid.indexOf(budgetperiod+"_")==0){
                    tbudgetperiodvalues.add(fvalue);
                }else if(fid.indexOf(organizationtype+"_")==0){
                    torgtypevalues.add(fvalue);
                }else if(fid.indexOf(organizationid+"_")==0){
                    torgidvalues.add(fvalue);
                }else if(fid.indexOf(subject+"_")==0){
                    tsubjectvalues.add(fvalue);
                }
%>
                var nrow=wcell.GetCellUserStringValueRow("<%=fid%>");
                if(nrow>0){
                    var ncol=wcell.GetCellUserStringValueCol("<%=fid%>");
<%
                if(k==0){
%>  
                nrow=nrow+nInsertRows;
<%
                }
                int htmltype=1;    
                int ftype=0;
                String tmpfid=fid;
                int indx=tmpfid.lastIndexOf("_");
                if(indx>0){
                   htmltype=Util.getIntValue(tmpfid.substring(indx+1),1);
                   tmpfid=tmpfid.substring(0,indx);
                   indx=tmpfid.lastIndexOf("_");
                   if(indx>0){
                      ftype=Util.getIntValue(tmpfid.substring(indx+1),1); 
                      tmpfid=tmpfid.substring(0,indx); 
                   }
                }
                int tmprow=Util.getIntValue(tmpfid.substring(tmpfid.indexOf("_")+1));
%>
                document.getElementById("<%=tmpfid%>").value = "<%=FieldInfo.toScreen(Util.encodeJS(fvalue))%>";
<%
                if(htmltype==5){
                    FieldInfo.getSelectItem(fid,isbill);
                    ArrayList  SelectItems=FieldInfo.getSelectItems();
                    ArrayList SelectItemValues=FieldInfo.getSelectItemValues();
                    String Combostr="";
                    fvalue="";
                    for(int n=0;n<SelectItems.size();n++){
                        String selectname=(String)SelectItems.get(n);
                        String selectvalue=(String)SelectItemValues.get(n);
                        Combostr+=";"+selectname;
%>
                        var fieldvalue=document.getElementById("<%=tmpfid%>").value;
                        var selvalue="<%=selectvalue%>";
                        if(fieldvalue==selvalue){
                            wcell.SetCellVal(nrow,ncol,getChangeField('<%=FieldInfo.toExcel(Util.encodeJS(selectname))%>'));
                        }
<%
                    }
%>
                    wcell.SetCellComboType(nrow,ncol,false,false,"<%=Util.encodeJS(Combostr)%>");           
<%
                }
                if(htmltype==4){
%>
                    wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
                    wcell.SetCellCheckBoxType(nrow,ncol);
<%
                    if(fvalue.equals("1")){
%>
                    wcell.SetCellCheckBoxValue(nrow,ncol,true);
<%
                    }
%>
                    wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
                }
                if(htmltype==3){
                    if(ftype==16 || ftype==152 || ftype==171){
                        ArrayList tempshowidlist=Util.TokenizerString(fvalue,",");
                        String linknums="";
                        int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                        for(int t=0;t<tempshowidlist.size();t++){
                            tempnum++;
                            session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(t));
                            linknums+=tempnum+",";
                        }
                        session.setAttribute("slinkwfnum",""+tempnum);
                        session.setAttribute("haslinkworkflow","1");
                        if(linknums.length()>0) linknums=linknums.substring(0,linknums.length()-1);
%>
                        document.all("<%=tmpfid%>_linkno").value="<%=linknums%>";
<%
                    }
                    if(tmpfid.indexOf(organizationid+"_")==0){
                        if(torgtypevalues.size()>=tmprow){
                            int orgtype=Util.getIntValue((String)torgtypevalues.get(tmprow),3);
                            if(orgtype==1){
                                ftype=164;
                            }else if(orgtype==2){
                                ftype=4;
                            }else{
                                ftype=1;
                            }
                        }
%>
                    var temporgtype=3;
                    if(document.all("<%=organizationtype%>_<%=tmprow%>")) temporgtype=document.all("<%=organizationtype%>_<%=tmprow%>").value;
                    wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
                    var tfieldid="<%=organizationid%>_<%=tmprow%>";
                    var turl="";
                    var turllink="";
                    if (temporgtype == 1) {
                        tfieldid += "_164_3";
                        turl = '<%=urlcominfo.getBrowserurl("164")%>';
                        turllink = '<%=urlcominfo.getLinkurl("164")%>';
                    } else if (temporgtype == 2) {
                        tfieldid += "_4_3";
                        turl = '<%=urlcominfo.getBrowserurl("4")%>';
                        turllink = '<%=urlcominfo.getLinkurl("4")%>';
                    } else {
                        tfieldid += "_1_3";
                        turl = '<%=urlcominfo.getBrowserurl("1")%>';
                        turllink = '<%=urlcominfo.getLinkurl("1")%>';
                    }
                    wcell.SetCellUserStringValue(nrow, ncol, nrow, ncol, tfieldid);
                    if (document.all("<%=organizationid%>_<%=tmprow%>_url")) {
                        document.all("<%=organizationid%>_<%=tmprow%>_url").value = turl;
                    }
                    if (document.all("<%=organizationid%>_<%=tmprow%>_urllink")) {
                        document.all("<%=organizationid%>_<%=tmprow%>_urllink").value = turllink;
                    }
<%
                    }
                    fvalue=FieldInfo.getFieldName(fvalue,ftype,dfielddbtype);
                }
                if(htmltype!=4 && htmltype!=5){
%>
                var Formula=wcell.GetCellFormula(nrow,ncol);
                if(Formula==null || Formula==""){
                    var strtxt = '<%=Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(fvalue)))%>';
<%
        if(htmltype==2&&ftype==2){
%>
    	strtxt = getFckText(strtxt);
<%
        }
%>
            wcell.SetCellVal(nrow,ncol,getChangeField(strtxt));
                }
<%
                }
                if(fid.indexOf(hrmremain+"_")==0||fid.indexOf(deptremain+"_")==0||fid.indexOf(subcomremain+"_")==0){
                    if(torgtypevalues.size()>=tmprow&&tbudgetperiodvalues.size()>=tmprow&&torgidvalues.size()>=tmprow&&tsubjectvalues.size()>=tmprow){
                        String kpi=bp.getBudgetKPI(""+tbudgetperiodvalues.get(tmprow),Util.getIntValue(""+torgtypevalues.get(tmprow)),Util.getIntValue(""+torgidvalues.get(tmprow)),Util.getIntValue(""+tsubjectvalues.get(tmprow)));

%>
                    callback("<%=kpi%>","<%=tmprow%>",nrow);
<%
                    }
                }else if(fid.indexOf(loanbalance+"_")==0){
                    if(torgtypevalues.size()>=tmprow&&tbudgetperiodvalues.size()>=tmprow&&torgidvalues.size()>=tmprow&&tsubjectvalues.size()>=tmprow){
                        double loanamount=bp.getLoanAmount(Util.getIntValue(""+torgtypevalues.get(tmprow)),Util.getIntValue(""+torgidvalues.get(tmprow)));
%>
                    callback1("<%=loanamount%>",<%=tmprow%>,nrow);
<%
                    }
                }else if(fid.indexOf(oldamount+"_")==0){
                    if(torgtypevalues.size()>=tmprow&&tbudgetperiodvalues.size()>=tmprow&&torgidvalues.size()>=tmprow&&tsubjectvalues.size()>=tmprow){
                        double toldamount=bp.getBudgetByDate(""+tbudgetperiodvalues.get(tmprow),Util.getIntValue(""+torgtypevalues.get(tmprow)),Util.getIntValue(""+torgidvalues.get(tmprow)),Util.getIntValue(""+tsubjectvalues.get(tmprow)));
%>
                    callback2("<%=toldamount%>",<%=tmprow%>,nrow);
<%
                    }
                }
%>
    imghide(nrow,ncol);
    }
<%
            }
        }
    }
%>
}
function setnodevalue(){
    var wcell=frmmain.ChinaExcel;
<%
for(int i=0;i<NodeList.size();i++){
    String nodestr=(String)NodeList.get(i);
    int nodeid=0;
    int indx=nodestr.lastIndexOf("_");
    if(indx>0){
        nodeid=Util.getIntValue(nodestr.substring(indx+1));
    }
    String nodemark=FieldInfo.GetNodeRemark(workflowid,nodeid,Util.getIntValue(_nodeid));
	nodemark = nodemark.replaceAll("&ldquo;","“");
    nodemark = nodemark.replaceAll("&rdquo;","”");
%>
    var nrow=wcell.GetCellUserStringValueRow("<%=nodestr%>");
    if(nrow>0){
        var ncol=wcell.GetCellUserStringValueCol("<%=nodestr%>");    
<%
		if(nodemark.indexOf("/weaver/weaver.file.FileDownload?fileid=")>=0||nodemark.indexOf("/weaver/weaver.file.ImgFileDownload?userid=")>=0){
%>
	        wcell.SetCanRefresh(false);
<%
			List nodeRemarkListOfBeenSplited=FieldInfo.getNodeRemarkListOfBeenSplited(nodemark);
			Map nodeRemarkOfBeenSplitedMap=null;
			String imageNodeRemark=null;
			String strNodeRemark=null;
			int n=0;
			for(int j=0;j<nodeRemarkListOfBeenSplited.size();j++){
			    nodeRemarkOfBeenSplitedMap=(Map)nodeRemarkListOfBeenSplited.get(j);
			    imageNodeRemark=(String)nodeRemarkOfBeenSplitedMap.get("imageNodeRemark");
			    strNodeRemark=(String)nodeRemarkOfBeenSplitedMap.get("strNodeRemark");
				if(imageNodeRemark != null){
					imageNodeRemark = imageNodeRemark.replaceAll("\r\n", "<br>");
					imageNodeRemark = imageNodeRemark.replaceAll("\n", "<br>");
					imageNodeRemark = imageNodeRemark.replaceAll("\"", "\\\\\"");
					imageNodeRemark = imageNodeRemark.replaceAll("\'", "\\\\\'");
				}
			    strNodeRemark=(String)nodeRemarkOfBeenSplitedMap.get("strNodeRemark");
				if(strNodeRemark != null){
					strNodeRemark = strNodeRemark.replaceAll("\r\n", "<br>");
					strNodeRemark = strNodeRemark.replaceAll("\n", "<br>");
					strNodeRemark = strNodeRemark.replaceAll("\"", "\\\\\"");
					strNodeRemark = strNodeRemark.replaceAll("\'", "\\\\\'");
				}
				if(j>0){
					n++;
%>
					wcell.InsertOnlyFormatRows(nrow+<%=n%>-1, 1,nrow,nrow);
					//新加的行清除图片
					for(k=0; k<=wcell.GetMaxCol(); k++){
						isProtect=wcell.IsCellProtect(nrow+<%=n%>,k);
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,false);
							wcell.DeleteCellImage(nrow+<%=n%>,k,nrow+<%=n%>,k);
						}
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,true);
						}
					}
<%
				}
%>
			    isProtect=wcell.IsCellProtect(nrow+<%=n%>,ncol);
			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,false);
			    }
<%
	if(imageNodeRemark.indexOf("/weaver/weaver.file.ImgFileDownload?userid=")>=0){
		BaseBean wfsbean=FieldInfo.getWfsbean();
		int rowheight=Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","imgheight"),0);
		int imgshowtpe=Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","imgshowtpe"),2);
%>
<%
                    if(rowheight>0){
%>
                    wcell.SetRowSize(nrow+<%=n%>, nrow+<%=n%>, <%=rowheight%>,1);
<%
                    }
%>
			        wcell.ReadHttpImageFile("<%=imageNodeRemark%>",nrow+<%=n%>,ncol,true,<%=(imgshowtpe==1)?true:false%>);
                    wcell.SetCellImageSize(nrow+<%=n%>,ncol,<%=imgshowtpe%>);
<%
	}else if(imageNodeRemark.indexOf("/weaver/weaver.file.FileDownload?fileid=")>=0){
%>
			    wcell.ReadHttpImageFile("<%=imageNodeRemark%>",nrow+<%=n%>,ncol,true,true);
<%
	}
	//TD47194，用于解决签字意见中插入图片之后再模板模式下不显示签字意见的问题。
	if(strNodeRemark==null)strNodeRemark="";
	String txtImageNodeRemark = imageNodeRemark;
	if(imageNodeRemark.startsWith("/weaver/weaver.file.FileDownload?fileid=")||imageNodeRemark.startsWith("/weaver/weaver.file.ImgFileDownload?userid=")){
		txtImageNodeRemark="";
	}
%>
			    var strNodeRemark = '<%out.print(Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(strNodeRemark+txtImageNodeRemark))));%>';
    			strNodeRemark = getFckText(strNodeRemark);

<%
	if(imageNodeRemark.indexOf("/weaver/weaver.file.ImgFileDownload?userid=")>=0&&!strNodeRemark.equals("")){
%>
			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
        n++;	
%>
			    wcell.InsertOnlyFormatRows(nrow+<%=n%>-1, 1,nrow,nrow);
				//新加的行清除图片
				for(k=0; k<=wcell.GetMaxCol(); k++){
					isProtect=wcell.IsCellProtect(nrow+<%=n%>,k);
					if(isProtect){
						wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,false);
						wcell.DeleteCellImage(nrow+<%=n%>,k,nrow+<%=n%>,k);
					}
					if(isProtect){
						wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,true);
					}
				}
			    isProtect=wcell.IsCellProtect(nrow+<%=n%>,ncol);
			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,false);
			    }
                wcell.SetCellVal(nrow+<%=n%>,ncol,getChangeField(strNodeRemark));
                wcell.SetCellHorzTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,1);
                wcell.SetCellVertTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,3);

			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
	}else{
%>

                wcell.SetCellVal(nrow+<%=n%>,ncol,getChangeField(strNodeRemark));
                wcell.SetCellHorzTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,1);
                wcell.SetCellVertTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,3);

			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
	}
%>

<%
	        }

			for(int m=1;m<=n;m++){
%>
                    for(k=0;k<=wcell.GetMaxCol();k++){
						isProtect=wcell.IsCellProtect(nrow+<%=m%>,k);
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=m%>,k,nrow+<%=m%>,k,false);
						}
					    wcell.ClearCellBorder(nrow+<%=m%>,k, nrow+<%=m%>, k, 2);
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=m%>,k,nrow+<%=m%>,k,true);
						}
					}	
<%
			}
%>
	        wcell.SetCanRefresh(true);
	        wcell.RefreshViewSize();
	        wcell.ReCalculate();
<%
		}else{
%>
			var nodemark = '<%out.print(Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(nodemark))));%>';
			nodemark = getFckText(nodemark);
            wcell.SetCellVal(nrow,ncol,getChangeField(nodemark));
            imghide(nrow,ncol);
<%
		}
%>
    }
<%
}   
%>
}

function createDocForNewTab(tmpfid,isedit){
  
   if(tmpfid==null||tmpfid==""){
	   return ;
   }

   var fieldbodyid="0";

   if(tmpfid.length>5){
	   fieldbodyid=tmpfid.substring(5);
   }
	/*
   for(i=0;i<=1;i++){
  		parent.document.all("oTDtype_"+i).background="/images/tab2.png";
  		parent.document.all("oTDtype_"+i).className="cycleTD";
  	}
  	parent.document.all("oTDtype_1").background="/images/tab.active2.png";
  	parent.document.all("oTDtype_1").className="cycleTDCurrent";
  	*/
	var docValue=document.all(tmpfid).value;

  	frmmain.action = "RequestDocView.jsp?docView="+isedit+"&docValue="+docValue+"&requestid="+<%=requestid%>+"&desrequestid="+<%=desrequestid%>;
    frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw";
    parent.delsave();
	if(check_form(document.frmmain,'requestname')){
      	if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "1";//标识点正文
        document.frmmain.src.value='save';
        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		parent.clicktext();//切换当前tab页到正文页面
		if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "";//标识点正文
    }
}
function accesoryChanage(obj,maxUploadImageSize){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=document.getElementById("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,Languageid)%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,Languageid)%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM>maxUploadImageSize) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,Languageid)%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,Languageid)%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,Languageid)%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=50 >";
    document.getElementById(objName).outerHTML=outerHTML;
    document.getElementById(objName).onchange=tempObjonchange;
}
function addannexRow(accname,maxsize)
  {
    document.all(accname+'_num').value=parseInt(document.all(accname+'_num').value)+1;
    ncol = document.all(accname+'_tab').cols;
    oRow = document.all(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1); 

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          oCell.colSpan=3;
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this,"+maxsize+")'> (<%=SystemEnv.getHtmlLabelName(18976,Languageid)%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,Languageid)%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }

 function onChangeSharetype(delspan,delid,ismand,maxUploadImageSize){
	fieldid=delid.substr(0,delid.indexOf("_"));
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
	fieldidspans=fieldid+"spans";
	fieldid=fieldid+"_1";
	 var sHtml = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange='accesoryChanage(this,"+maxUploadImageSize+")'> (<%=SystemEnv.getHtmlLabelName(18976,Languageid)%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,Languageid)%>) ";
	 var sHtml1 = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange=\"accesoryChanage(this,"+maxUploadImageSize+");checkinput(\'"+fieldid+"\',\'"+fieldidspan+"\')\"> (<%=SystemEnv.getHtmlLabelName(18976,Languageid)%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,Languageid)%>) ";

    if(document.all(delspan).style.visibility=='visible'){
      document.all(delspan).style.visibility='hidden';
      document.all(delid).value='0';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)+1;
    }else{
      document.all(delspan).style.visibility='visible';
      document.all(delid).value='1';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)-1;
    }
	//alert(document.all(fieldidnum).value);
	if (ismand=="1")
	  {
	if (document.all(fieldidnum).value=="0")
	  {
	    document.all("needcheck").value=document.all("needcheck").value+","+fieldid;
		document.all(fieldidspan).innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";

		//document.all(fieldidspans).innerHTML=sHtml1;
	  }
	  else
	  {   if (document.all("needcheck").value.indexOf(","+fieldid)>0)
		  {
	     document.all("needcheck").value=document.all("needcheck").value.substr(0,document.all("needcheck").value.indexOf(","+fieldid));
		 document.all(fieldidspan).innerHTML="";
		 //document.all(fieldidspans).innerHTML=sHtml;
		  }
	  }
	  }
  }
function nodechange(value){
    if(value==""){
        document.all("Intervenorid").value="";
        document.all("Intervenorspan").innerHTML="<button class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><img src='/images/BacoError.gif' align=absmiddle>";
        document.all("submitNodeIdspan").innerHTML="<img src='/images/BacoError.gif' align=absmiddle>";
    }else{
        var nodeids=value.split("_");
        var selnodeid=nodeids[0];
        var selnodetype=nodeids[1];
        if(selnodetype==0){
            document.all("Intervenorid").value="<%=creater%>";
            document.all("Intervenorspan").innerHTML="<button class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><A href='javaScript:openhrm(<%=creater%>);' onclick='pointerXY(event);'><%=creatername%></a>";
        }else{
        rightMenu.style.display="none";
        document.all("workflownextoperatorfrm").src="/workflow/request/WorkflowNextOperator.jsp?requestid=<%=requestid%>&intervenorright=<%=intervenorright%>&workflowid=<%=workflowid%>"+
                "&formid=<%=formid%>&isbill=<%=isbill%>&billid=<%=billid%>&creater=<%=creater%>&creatertype=<%=creatertype%>&nodeid="+selnodeid+"&nodetype="+selnodetype;
        }
        document.all("submitNodeIdspan").innerHTML="";
    }
}
function callback(o, index,nrow) {
    val = o.split("|");
    //alert(o);
    if (val[0] != "") {
        v = val[0].split(",");
        hrmremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var hrmremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_" + index + "_<%=hrmremaintype%>");
        if (hrmremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nrow, hrmremaincol, getChangeField(hrmremainstr));
            frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, true);
        }
    }
    if (val[1] != "") {
        v = val[1].split(",");
        deptremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var deptremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_" + index + "_<%=deptremaintype%>");
        //alert(nrow+"+"+deptremaincol+"|"+deptremainstr);
        if (deptremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nrow, deptremaincol, nrow, deptremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nrow, deptremaincol, getChangeField(deptremainstr));
            frmmain.ChinaExcel.SetCellProtect(nrow, deptremaincol, nrow, deptremaincol, true);
        }
    }
    if (val[2] != "") {
        v = val[2].split(",");
        subcomremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var subcomremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_" + index + "_<%=subcomremaintype%>");
        //alert(nrow+"+"+subcomremaincol+"|"+subcomremainstr);
        if (subcomremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nrow, subcomremaincol, nrow, subcomremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nrow, subcomremaincol, getChangeField(subcomremainstr));
            frmmain.ChinaExcel.SetCellProtect(nrow, subcomremaincol, nrow, subcomremaincol, true);
        }
    }
    frmmain.ChinaExcel.RefreshViewSize();
}

function callback1(o, index,nrow) {
    //alert(o);
    if(document.all("<%=loanbalance%>_" + index)!=null){
        document.all("<%=loanbalance%>_" + index).value = o;
    }
    var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + index + "_<%=loanbalancetype%>");
    if (loanbalancecol > 0) {
        frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, false);
        frmmain.ChinaExcel.SetCellVal(nrow, loanbalancecol, getChangeField(o));
        frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}
function callback2(o, index,nrow) {
    //alert(o);
    if(document.all("<%=oldamount%>_" + index)!=null){
        document.all("<%=oldamount%>_" + index).value = o;
    }
    var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + index + "_<%=oldamounttype%>");
    if (oldamountcol > 0) {
        frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, false);
        frmmain.ChinaExcel.SetCellVal(nrow, oldamountcol, getChangeField(o));
        frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
</script>
<script language=javascript src="/js/characterConv.js"></script>
<script language="VBScript">
sub onShowMutiHrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<A href='javaScript:openhrm("&curid&");' onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
					wend
					sHtml = "<button class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button>"&sHtml&"<A href='javaScript:openhrm("&resourceids&");' onclick='pointerXY(event);'>"&resourcename&"</a>"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml ="<button class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><img src='/images/BacoError.gif' align=absmiddle>"
					document.all(inputename).value=""
				end if
			end if
end sub
</script>
<script language=vbs src="/workflow/mode/loadmode.vbs"></script>
<script type="text/vbscript">
sub onShowSignBrowser(url,linkurl,inputname,spanname,type1)
    tmpids = document.all(inputname).value
    if type1=37 then
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?documentids="&tmpids)
    else
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?resourceids="&tmpids)
    end if
        if NOT isempty(id1) then
		   if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputname).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_blank'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_blank'>"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

		else
				    document.all(spanname).innerHtml = empty
					document.all(inputname).value=""
        end if
      end if
end sub
</script>
