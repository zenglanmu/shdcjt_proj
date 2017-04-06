<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.system.code.CodeBuild" %>
<%@ page import="weaver.system.code.CoderBean" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="urlcominfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />

<%
String acceptlanguage = Util.null2String(request.getHeader("Accept-Language"));
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
//TD9892
BaseBean bb_manageom = new BaseBean();
int urm_manageom = 1;
try{
	urm_manageom = Util.getIntValue(bb_manageom.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}

User user = HrmUserVarify.getUser (request , response) ;

int requestid = Util.getIntValue(request.getParameter("requestid"));
String isbill = Util.null2String(request.getParameter("isbill"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
String isaffirmance=Util.null2String(request.getParameter("isaffirmance"));//是否需要提交确认
String reEdit=Util.null2String(request.getParameter("reEdit"));
String nodetype=Util.null2String(request.getParameter("nodetype"));
int isform = Util.getIntValue(request.getParameter("isform"));
int modeid = Util.getIntValue(request.getParameter("modeid"));
int nodeid = Util.getIntValue(request.getParameter("nodeid"));
int isremark=Util.getIntValue(request.getParameter("isremark"));
int formid = Util.getIntValue(request.getParameter("formid"));
boolean IsBeForwardCanSubmitOpinion="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsBeForwardCanSubmitOpinion"))?true:false;
boolean IsCanModify="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsCanModify"))?true:false;
boolean editmodeflag=false;
if((isremark==0||IsCanModify) && (!isaffirmance.equals("1") || !nodetype.equals("0") || reEdit.equals("1"))) editmodeflag=true;
boolean isFnabill=false;
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
 int uploadType = 0;
 String selectedfieldid = "";
 
 FieldInfo.setUser(user);
 FieldInfo.GetManTableField(formid,Util.getIntValue(isbill),user.getLanguage());
 FieldInfo.GetDetailTableField(formid,Util.getIntValue(isbill),user.getLanguage());
 FieldInfo.GetWorkflowNode(workflowid);
 
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
     uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
     selectedfieldid = result.substring(0,result.indexOf(","));
 }    
if(isbill.equals("1")&&(formid==156 ||formid==157 ||formid==158 ||formid==159)){
    isFnabill=true;
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

int creater= Util.getIntValue(request.getParameter("creater"),0);
int creatertype=Util.getIntValue(request.getParameter("creatertype"),0);
String currentdate = Util.null2String(request.getParameter("currentdate"));
String currenttime = Util.null2String(request.getParameter("currenttime"));

CodeBuild cbuild = new CodeBuild(formid,isbill,workflowid,creater,creatertype);
CoderBean cb = cbuild.getFlowCBuild();
String isUse = cb.getUserUse();  //是否使用流程编号
String fieldCode=Util.null2String(cb.getCodeFieldId());
ArrayList memberList = cb.getMemberList();
boolean hasHistoryCode=cbuild.hasHistoryCode(RecordSet,workflowid);
int fieldIdSelect=-1;
int departmentFieldId=-1;
int subCompanyFieldId=-1;
int supSubCompanyFieldId=-1;
int yearFieldId=-1;
String yearFieldHtmlType="";
int monthFieldId=-1;
int dateFieldId=-1;

for (int i=0;i<memberList.size();i++){
	String[] codeMembers = (String[])memberList.get(i);
	String codeMemberName = codeMembers[0];
	String codeMemberValue = codeMembers[1];
	if("22755".equals(codeMemberName)){
		fieldIdSelect=Util.getIntValue(codeMemberValue,-1);
	}else if("22753".equals(codeMemberName)){
		supSubCompanyFieldId=Util.getIntValue(codeMemberValue,-1);
	}else if("141".equals(codeMemberName)){
		subCompanyFieldId=Util.getIntValue(codeMemberValue,-1);
	}else if("124".equals(codeMemberName)){
		departmentFieldId=Util.getIntValue(codeMemberValue,-1);
	}else if("445".equals(codeMemberName)){
		yearFieldId=Util.getIntValue(codeMemberValue,-1);
	}else if("6076".equals(codeMemberName)){
		monthFieldId=Util.getIntValue(codeMemberValue,-1);
	}else if("390".equals(codeMemberName)||"16889".equals(codeMemberName)){
		dateFieldId=Util.getIntValue(codeMemberValue,-1);
	}
}

String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来

String isFormSignature=null;
int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet.next()){
	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
}
boolean ispopup=false;
RecordSet.executeSql("select isannexUpload from workflow_base where (isannexUpload='1' or isSignDoc='1' or isSignWorkflow='1') and id="+workflowid);
if(RecordSet.next()){
	ispopup=true;
}
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,0);
ArrayList seldefieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,1);
ArrayList changedefieldsmanage=WfLinkageInfo.getChangeField(workflowid,nodeid,1);    
//获得触发字段名
DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
String trrigerdetailfield=ddi.GetEntryTriggerDetailFieldName();
ArrayList Linfieldname=ddi.GetInFieldName();
ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();

String selfieldsaddString = "";
for(int i=0;i<selfieldsadd.size();i++){
    selfieldsaddString += (String)selfieldsadd.get(i)+",";
}
%>
<input type=hidden name="oldaction" id="oldaction">
<script type="text/javascript">
var trrigerfields="<%=trrigerfield%>";
var trrigerdetailfields="<%=trrigerdetailfield%>";
var trrigerfieldary=trrigerfields.split(",");
var trrigerdetailfieldary="";
document.getElementById("oldaction").value=frmmain.action;
</script>
<iframe id="modeComboChange" id="modeComboChange" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="datainputform" frameborder=0 height="0" width="0" scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 height="0" width="0" scrolling=no src=""  style="display:none"></iframe>
<iframe ID="selframe" BORDER=0 FRAMEBORDER=no height="0%" width="0%" scrolling="NO" src=""></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="createCodeAgainIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<script language=javascript src="/workflow/mode/loadmode.js"></script>
<script type='text/javascript' src='/dwr/interface/BudgetHandler.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script language=javascript src="/js/characterConv.js"></script>
<script type="text/javascript">
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
</script>
<SCRIPT FOR="ChinaExcel" EVENT="ShowCellChanged()"	LANGUAGE="JavaScript" >
var nowrow=frmmain.ChinaExcel.Row;
var nowcol=frmmain.ChinaExcel.Col;
var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nowrow,nowcol);
var cellvalue=frmmain.ChinaExcel.GetCellValue(nowrow,nowcol);
cellvalue = Simplized(cellvalue);
var ismand=frmmain.ChinaExcel.GetCellUserValue(nowrow,nowcol);
<%
if(!editmodeflag){
%>
ismand=0;
<%
}
if(isaffirmance.equals("1") && nodetype.equals("0") && !reEdit.equals("1")){%>
showPopup(uservalue,cellvalue,ismand,0);
<%}else{%>
var fieldname=uservalue;
if(fieldname!=null){
    var indx=fieldname.lastIndexOf("_");
        if(indx>0){
        var addordel=fieldname.substring(indx+1);
        fieldname=fieldname.substring(0,indx);
        if(addordel=="sel"){                
                frmmain.ChinaExcel.SetCellCheckBoxValue(nowrow,nowcol,!frmmain.ChinaExcel.GetCellCheckBoxValue(nowrow,nowcol));
                return false;
        }else{
            if(addordel=="4" &&  ismand>0){
                frmmain.ChinaExcel.SetCellCheckBoxValue(nowrow,nowcol,!frmmain.ChinaExcel.GetCellCheckBoxValue(nowrow,nowcol));
                var checkvalue="0";
                indx=fieldname.lastIndexOf("_");
                if(indx>0){
                    fieldname=fieldname.substring(0,indx);                        
                }
                if(GetCellCheckBoxValue(nowrow,nowcol)){
                    checkvalue="1";
                }
                document.all(fieldname).value=checkvalue;
                DataInputByBrowser(fieldname);
                return false;
            }
        }
    }
}
    showPopup(uservalue,cellvalue,ismand,1);
<%}%>
    return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="MouseLClick(Row, Col, UpDown)"	LANGUAGE="JavaScript" >
	<%if(urm_manageom==1){%>
    rightMenu.style.visibility="hidden";
    <%}%>
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col); 
    var ismand=frmmain.ChinaExcel.GetCellUserValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    var fieldname=uservalue;
    var changefields="";
	var upDown = UpDown;
	if(upDown == 0){//only for mouse left up
    <%
    for(int j=0;j<changedefieldsmanage.size();j++){
    %>
    changefields+=",<%=changedefieldsmanage.get(j)%>";
    <%
    }
    %>
    if(uservalue!=null){
    	if(uservalue=="qianzi"&&ismand>0&&<%=IsBeForwardCanSubmitOpinion%>&&(<%=ispopup%>||"<%=isFormSignature%>"==1)){
    		var remark = document.getElementById("remark").value;
            var signdocids = document.getElementById("signdocids").value;
            var signworkflowids = document.getElementById("signworkflowids").value;
    		var workflowRequestLogId = document.getElementById("workflowRequestLogId").value;
        var fieldvalue=document.getElementById(uservalue).value;
        var redirectUrl = "/workflow/request/WorkFlowSignUP.jsp?nodeid=<%=nodeid%>&fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit="+ismand+"&isFormSignature=<%=isFormSignature%>&formSignatureWidth=<%=formSignatureWidth%>&formSignatureHeight=<%=formSignatureHeight%>&remark="+remark+"&workflowRequestLogId="+workflowRequestLogId+"&signdocids="+signdocids+"&signworkflowids="+signworkflowids;
        var szFeatures = "top="+(screen.height-300)/2+"," ;
        szFeatures +="left="+(screen.width-750)/2+"," ;
        szFeatures +="width=860," ;
        szFeatures +="height=300," ; 
        szFeatures +="directories=no," ;
        szFeatures +="status=no," ;
        szFeatures +="menubar=no," ;
        szFeatures +="scrollbars=yes," ;
        szFeatures +="resizable=no" ; //channelmode
        window.open(redirectUrl,"fileup",szFeatures);                
        frmmain.ChinaExcel.GoToCell(1,1);
    	}else{
        var indx=uservalue.lastIndexOf("_");
        if(indx>0){
            var addordel=uservalue.substring(indx+1);
            uservalue=uservalue.substring(0,indx);
            <%if(editmodeflag){%>
            if(addordel=="add"){
            	//获取当前滚动条起始位置
            	var startCol = frmmain.ChinaExcel.GetStartCol();
                rowIns(uservalue.substring(6),0,1,changefields);
                setheight();
                //将当前滚动条设置为添加前的位置
                frmmain.ChinaExcel.SetHScrollPos(startCol);
            }
            if(addordel=="del"){
                rowDel(uservalue.substring(6));
                setheight();
            }
            if(addordel=="showKeyword"){
                onShowKeyword();
            }
            <%}%>
            if(addordel=="6"){
                indx=uservalue.indexOf("_");
                if(indx>0){
                    uservalue=uservalue.substring(0,indx);
                }
                var fieldvalue=document.getElementById(uservalue).value;
                var selectfieldvalue="";
                <%
                if(!selectedfieldid.equals("")){
                %>
                if(document.getElementById("field<%=selectedfieldid%>")) selectfieldvalue=document.getElementById("field<%=selectedfieldid%>").value
                <%}%>
				<%if(editmodeflag){%>
                if(ismand>0 || fieldvalue.length>0){
                var redirectUrl = "/workflow/request/WorkFlowFileUP.jsp?fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit="+ismand+"&requestid=<%=requestid%>&isbill=<%=isbill%>&uploadType=<%=uploadType%>&selectedfieldid=<%=selectedfieldid%>&selectfieldvalue="+selectfieldvalue;
                var szFeatures = "top="+(screen.height-300)/2+"," ;
                szFeatures +="left="+(screen.width-750)/2+"," ;
                szFeatures +="width=860," ;
                szFeatures +="height=300," ; 
                szFeatures +="directories=no," ;
                szFeatures +="status=no," ;
                szFeatures +="menubar=no," ;
                szFeatures +="scrollbars=yes," ;
                szFeatures +="resizable=no" ; //channelmode
                window.open(redirectUrl,"fileup",szFeatures) ;

                frmmain.ChinaExcel.GoToCell(1,1);
                }
				<%}else if((isremark==1 || isremark==8 || isremark==9) && (!isaffirmance.equals("1") || !nodetype.equals("0") || reEdit.equals("1"))){//TD10998 被转发、抄送特殊处理，能查看、下载附件%>
                if(ismand>0 || fieldvalue.length>0){
					var redirectUrl = "/workflow/request/WorkFlowFileUP.jsp?fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit=0&requestid=<%=requestid%>&isbill=<%=isbill%>&uploadType=<%=uploadType%>&selectedfieldid=<%=selectedfieldid%>&selectfieldvalue="+selectfieldvalue;
					var szFeatures = "top="+(screen.height-300)/2+",";
					szFeatures +="left="+(screen.width-750)/2+",";
					szFeatures +="width=750,";
					szFeatures +="height=300,";
					szFeatures +="directories=no,";
					szFeatures +="status=no,";
					szFeatures +="menubar=no,";
					szFeatures +="scrollbars=yes,";
					szFeatures +="resizable=no";
					window.open(redirectUrl,"fileup",szFeatures);
					frmmain.ChinaExcel.GoToCell(1,1);
                }
				<%}%>
            }
        }
      }
    }
	}else{
		//frmmain.ChinaExcel.GoToCell(1,1);
	}
	setheight();
    frmmain.ChinaExcel.RefreshViewSize();
    return false;
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="MouseRClick()"	LANGUAGE="JavaScript" >
        hidePopup();
        var divBillScrollTop=parent.document.getElementById("divWfBill").scrollTop;
        <%if(urm_manageom==1){%>
        rightMenu.style.left=frmmain.ChinaExcel.offsetLeft+frmmain.ChinaExcel.GetMousePosX();
        rightMenu.style.top=frmmain.ChinaExcel.offsetTop+frmmain.ChinaExcel.GetMousePosY()-divBillScrollTop;
		rightMenu.style.visibility="visible";
		<%}%>
		return false;
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="CellContentChanged()"	LANGUAGE="JavaScript" >
    imgshoworhide(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col); 
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    var cellvalue=frmmain.ChinaExcel.GetCellValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    cellvalue = Simplized(cellvalue);
    var ismand=frmmain.ChinaExcel.GetCellUserValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    changevalue(uservalue,cellvalue,ismand);
    changeKeyword(uservalue,cellvalue,ismand);
    var fieldname=uservalue;
    if(fieldname!=null){
        var indx=fieldname.lastIndexOf("_");
        if(indx>0){
            var addordel=fieldname.substring(indx+1);
            fieldname=fieldname.substring(0,indx);
            indx=fieldname.lastIndexOf("_");
            if(indx>0){
                fieldname=fieldname.substring(0,indx);
                DataInputByBrowser(fieldname);
            }
        }
    }
    
     var fieldName2 = uservalue.substring(0,uservalue.indexOf("_"));
     if(fieldName2=="field<%=fieldCode%>"){ 
     	onChangeCode(ismand);
     }
    
    frmmain.ChinaExcel.RefreshViewSize();
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="ComboSelChanged()"	LANGUAGE="JavaScript" >
    var nrow= frmmain.ChinaExcel.Row;
    var ncol=frmmain.ChinaExcel.Col;
    var selvalue=frmmain.ChinaExcel.GetCellComboSelectedActualValue(nrow,ncol);
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nrow,ncol);
    var nindx=uservalue.lastIndexOf("_");
    var fieldid="-1";
    var rownum=-1;
    <%if(isFnabill){%>
    var tindx=uservalue.indexOf("_");
    if(tindx>0){
        var tfieldname=uservalue.substring(0,tindx);
        var tlastfield=uservalue.substring(tindx+1);
        if(tfieldname=="<%=organizationtype%>"){
            tindx=tlastfield.indexOf("_");
            if(tindx>0){
                var trow=tlastfield.substring(0,tindx);
                if(document.getElementById("<%=organizationtype%>_"+trow)){
                    var oldtype=document.getElementById("<%=organizationtype%>_"+trow).value;
                    var tfieldid="<%=organizationid%>_"+trow;
                    if(oldtype==1){
                        tfieldid+="_164_3";
                    }else if(oldtype==2){
                        tfieldid+="_4_3";
                    }else{
                        tfieldid+="_1_3";
                    }
                    var orgidcol=frmmain.ChinaExcel.GetCellUserStringValueCol(tfieldid);
                    if(orgidcol>0){
                        tfieldid="<%=organizationid%>_"+trow;
                        var turl="";
                        var turllink="";
                        if(selvalue==1){
                            tfieldid+="_164_3";
                            turl='<%=urlcominfo.getBrowserurl("164")%>';
                            turllink='<%=urlcominfo.getLinkurl("164")%>';
                        }else if(selvalue==2){
                            tfieldid+="_4_3";
                            turl='<%=urlcominfo.getBrowserurl("4")%>';
                            turllink='<%=urlcominfo.getLinkurl("4")%>';
                        }else{
                            tfieldid+="_1_3";
                            turl='<%=urlcominfo.getBrowserurl("1")%>';
                            turllink='<%=urlcominfo.getLinkurl("1")%>';
                        }
                        frmmain.ChinaExcel.SetCellProtect(nrow,orgidcol,nrow,orgidcol,false);
                        frmmain.ChinaExcel.SetCellUserStringValue(nrow,orgidcol,nrow,orgidcol,tfieldid);
                        frmmain.ChinaExcel.SetCellVal(nrow,orgidcol,"");
                        imgshoworhide(nrow,orgidcol);
                        frmmain.ChinaExcel.SetCellProtect(nrow,orgidcol,nrow,orgidcol,true);
                        if(document.getElementById("<%=organizationid%>_"+trow)){
                            document.getElementById("<%=organizationid%>_"+trow).value="";
                        }
                        if(document.getElementById("<%=organizationid%>_"+trow+"_url")){
                            document.getElementById("<%=organizationid%>_"+trow+"_url").value=turl;
                        }
                        if(document.getElementById("<%=organizationid%>_"+trow+"_urllink")){
                            document.getElementById("<%=organizationid%>_"+trow+"_urllink").value=turllink;
                        }
                        if(document.getElementById("<%=hrmremain%>_"+trow)){
                            document.getElementById("<%=hrmremain%>_"+trow).value="";
                        }
                        if(document.getElementById("<%=deptremain%>_"+trow)){
                            document.getElementById("<%=deptremain%>_"+trow).value="";
                        }
                        if(document.getElementById("<%=subcomremain%>_"+trow)){
                            document.getElementById("<%=subcomremain%>_"+trow).value="";
                        }
                        if(document.getElementById("<%=loanbalance%>_"+trow)){
                            document.getElementById("<%=loanbalance%>_"+trow).value="";
                        }
                        if(document.getElementById("<%=oldamount%>_"+trow)){
                            document.getElementById("<%=oldamount%>_"+trow).value="";
                        }
                        var hrmremaincol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_"+trow+"_<%=hrmremaintype%>");
                        if(hrmremaincol>0){
                            frmmain.ChinaExcel.SetCellProtect(nrow,hrmremaincol,nrow,hrmremaincol,false);
                            frmmain.ChinaExcel.SetCellVal(nrow,hrmremaincol,"");
                            frmmain.ChinaExcel.SetCellProtect(nrow,hrmremaincol,nrow,hrmremaincol,true);
                        }
                        var deptremaincol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_"+trow+"_<%=deptremaintype%>");
                        if(deptremaincol>0){
                            frmmain.ChinaExcel.SetCellProtect(nrow,deptremaincol,nrow,deptremaincol,false);
                            frmmain.ChinaExcel.SetCellVal(nrow,deptremaincol,"");
                            frmmain.ChinaExcel.SetCellProtect(nrow,deptremaincol,nrow,deptremaincol,true);
                        }
                        var subcomremaincol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_"+trow+"_<%=subcomremaintype%>");
                        if(subcomremaincol>0){
                            frmmain.ChinaExcel.SetCellProtect(nrow,subcomremaincol,nrow,subcomremaincol,false);
                            frmmain.ChinaExcel.SetCellVal(nrow,subcomremaincol,"");
                            frmmain.ChinaExcel.SetCellProtect(nrow,subcomremaincol,nrow,subcomremaincol,true);
                        }
                        var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + trow + "_<%=loanbalancetype%>");
                        if (loanbalancecol > 0) {
                            frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, false);
                            frmmain.ChinaExcel.SetCellVal(nrow, loanbalancecol, "");
                            frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, true);
                        }
                        var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + trow + "_<%=oldamounttype%>");
                        if (oldamountcol > 0) {
                            frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, false);
                            frmmain.ChinaExcel.SetCellVal(nrow, oldamountcol, "");
                            frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, true);
                            frmmain.ChinaExcel.ReCalculate();
                        }
                    }
                }
            }
        }
    }
    <%}%>
    if(uservalue!="requestlevel"&&uservalue!="messageType"){
	    if(nindx>0){
	        uservalue=uservalue.substring(0,nindx);
	        nindx=uservalue.lastIndexOf("_");
	        if(nindx>0){
	            uservalue=uservalue.substring(0,nindx);
                nindx=uservalue.lastIndexOf("_");
                if(nindx>0){
                    fieldid=uservalue.substring(5,nindx);
                    rownum=uservalue.substring(nindx+1);
                }else{
                    fieldid=uservalue.substring(5);
                }
            }
	    }
	  }
    document.getElementById(uservalue).value=selvalue;
    <%
    for(int i=0;i<selfieldsadd.size();i++){
    %>
    if("<%=selfieldsadd.get(i)%>"==fieldid){
        changeshowattrBymode('<%=selfieldsadd.get(i)%>_0',selvalue,-1,<%=workflowid%>,<%=nodeid%>);
    }
    <%
    }
    for(int i=0;i<seldefieldsadd.size();i++){
    %>
    if("<%=seldefieldsadd.get(i)%>"==fieldid){
        changeshowattrBymode('<%=seldefieldsadd.get(i)%>_1',selvalue,rownum,<%=workflowid%>,<%=nodeid%>);
    }
    <%
    }
    %>
    var childfieldObj = document.getElementById("childFieldfield"+fieldid);
    if(childfieldObj!=null){
		var childfieldid = childfieldObj.value;
		if(childfieldid!=null && childfieldid!="" && childfieldid!="0" && (childfieldid.indexOf("0_")==-1 || childfieldid.indexOf("0_")>0)){
			var paraStr = "ismanager=1&fieldid="+fieldid+"&childfield="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+selvalue+"&rownum="+rownum;
			//alert(paraStr);
		    document.getElementById("modeComboChange").src = "ComboChange.jsp?"+paraStr;
		}
    }
    return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="CalculateEnd()"	LANGUAGE="JavaScript" >
    MainCalculate();
    DetailCalculate();
	return false;
</script>
<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelobj_tw.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelobj.js"></script>
<%} %>
<DIV id="ocontext" name="ocontext" style="LEFT: 0px;Top:0px;POSITION:ABSOLUTE ;display:none" >
<table id=otable cellpadding='0' cellspacing='0' width="200" border=1 style="WORD-WRAP:break-word">
</table>
</DIV>

<input type=hidden name="indexrow" id="indexrow" value=0>
<input type=hidden name="isform" id="isform" value="<%=isform%>">
<input type=hidden name="modeid" id="modeid" value="<%=modeid%>">
<input type=hidden name="modestr" id="modestr" value="">
<input type=hidden name="isShowPopupCreateCodeAgain" id="isShowPopupCreateCodeAgain" value="1">

<script language=javascript>
function readmode(){
    frmmain.ChinaExcel.ReadHttpFile("/workflow/mode/ModeReader.jsp?modeid=<%=modeid%>&nodeid=<%=nodeid%>&isform=<%=isform%>");
}
</script>
<script language=vbs>
sub init()
    frmmain.ChinaExcel.SetOnlyShowTipMessage true
    chinaexcelregedit()
	readmode()
    frmmain.ChinaExcel.DesignMode = false
    frmmain.ChinaExcel.SetShowPopupMenu false	
    frmmain.ChinaExcel.SetCanAutoSizeHideCols true 
    frmmain.ChinaExcel.SetProtectFormShowCursor true 
    frmmain.ChinaExcel.ShowGrid = false
    frmmain.ChinaExcel.SetShowScrollBar 1,false
    getRowGroup()
    setmantable()
    setdetailtable()
    setnodevalue()
	initRowData()
    doTriggerInit()
    doLinkAgeInit()
    frmmain.ChinaExcel.ReCalculate()
    <%if(isaffirmance.equals("1") && nodetype.equals("0") && !reEdit.equals("1")){%>
        frmmain.ChinaExcel.FormProtect true
    <%}%>
    setheight()
    frmmain.ChinaExcel.SetPasteType 1
    frmmain.ChinaExcel.GoToCell 1,1
    RefreshViewSize()
    frmmain.ChinaExcel.SetOnlyShowTipMessage false
end sub
</script>
<script language=javascript>
	function initRowData()
	{
		var changefields="";
	<%
	    for(int j=0;j<changedefieldsmanage.size();j++){
	    %>
	    changefields+=",<%=changedefieldsmanage.get(j)%>";
	    <%
	    }
	    ArrayList detailtablefieldids=FieldInfo.getDetailTableFieldIds();
	    for(int i=0; i<detailtablefieldids.size();i++)
	    {
	%>
		//确认是否添加控制
		var isneed=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_isneed");
		var isdefault=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_isdefault");
		var tempdetail = document.getElementById("tempdetail<%=i%>");
		var tempdetailvalue = 0;
		if(tempdetail)
		{
			tempdetailvalue = tempdetail.value;
		}
	    if(tempdetailvalue<1&&isdefault>0)
	    {
	    	rowIns("<%=i%>",1,1,changefields,"1");
	    }
	<%
	    }
	%>
	}
     function setheight(){
        var maxrow=frmmain.ChinaExcel.GetMaxRow();
        var totalheight=5;
        for(var i=1;i<=maxrow;i++){
            totalheight+=frmmain.ChinaExcel.GetRowSize(i,1);
        }
        frmmain.ChinaExcel.height=totalheight;
        frmmain.ChinaExcel.SetShowScrollBar(1,true);
    }
    function setwidth(){

        var totalwidth=0;
        var colnum = frmmain.ChinaExcel.GetMaxCol();		
		for(var i=0;i<colnum;i++){
			totalwidth += frmmain.ChinaExcel.GetColSize(i,1);
		}

        var temptotalwidth=parent.document.body.clientWidth-totalwidth;

        if(temptotalwidth>0&&false){ 
        	totalwidth=totalwidth;
        	frmmain.ChinaExcel.width=totalwidth;
        	frmmain.ChinaExcel.SetShowScrollBar(0,false);
        }else{
        	frmmain.ChinaExcel.width=parent.document.body.clientWidth - 40;
        	frmmain.ChinaExcel.SetShowScrollBar(0,true);
        }
    }

function window.onresize(){
    setheight();
	setwidth();
}
function RefreshViewSize(){
	<%if(urm_manageom==1){%>
    //rightMenu.focus();
	    try {
		    rightMenu.focus();
	    }catch(e) {
	    }
    <%}%>
    for(r=0;r<rowgroup.length;r++){
        rhead=frmmain.ChinaExcel.GetCellUserStringValueRow("detail"+r+"_head");
        frmmain.ChinaExcel.SetRowHide(rhead,rhead+rowgroup[r],true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}

<%
//String isFormSignature=null;
//RecordSet.executeSql("select isFormSignature from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
//if(RecordSet.next()){
//	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
//}
%>

function createDoc(fieldbodyid,docValue,isedit){
	
	/* 
   for(i=0;i<=1;i++){ 
  		parent.document.all("oTDtype_"+i).background="/images/tab2.png";
  		parent.document.all("oTDtype_"+i).className="cycleTD";
  	}
  	parent.document.all("oTDtype_1").background="/images/tab.active2.png";
  	parent.document.all("oTDtype_1").className="cycleTDCurrent";  	
  	*/
  	//frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docValue;
  	if("<%=isremark%>"==9||<%=!editmodeflag%>||"<%=isremark%>"==5||"<%=isremark%>"==8){
  		frmmain.action = "RequestDocView.jsp?requestid=<%=requestid%>&docValue="+docValue;
  	}else{
  	//frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docValue;
  	    frmmain.action = document.getElementById("oldaction").value+"?docView="+isedit+"&docValue="+docValue+"&isFromEditDocument=true";
  	}
    frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw"; 
	parent.delsave();
	if(check_form(document.frmmain,'requestname')){
		if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "1";//标识点正文    
        document.frmmain.src.value='save';
        document.frmmain.isremark.value='0';
        				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");                       //附件上传
                        StartUploadAll();
                        checkuploadcompletBydoc();
    }
}

function openWindow(urlLink){

  	window.open(urlLink+"&requestid=<%=requestid%>");

}

function openWindowNoRequestid(urlLink){
    window.open(urlLink);
}

<%
int titleFieldId=-1;
int keywordFieldId=-1;
RecordSet.execute("select titleFieldId,keywordFieldId from workflow_base where id="+workflowid);
if(RecordSet.next()){
	titleFieldId=RecordSet.getInt("titleFieldId");
	keywordFieldId=RecordSet.getInt("keywordFieldId");
}
%>
var hasinitfieldvalue=false;
	var initfieldvalue = -1;
	if(document.getElementById("field<%=fieldCode%>")!=null){
		if(!hasinitfieldvalue) {
			initfieldvalue = document.getElementById("field<%=fieldCode%>").value;
			hasinitfieldvalue = true;
		}
	}    
//发文字号变更(TD20002)
function onChangeCode(ismand){
	if(document.getElementById("field<%=fieldCode%>")!=null){
		initDataForWorkflowCode();
		if(document.getElementById("field<%=fieldCode%>").value == "" || document.getElementById("field<%=fieldCode%>").value == initfieldvalue) {
			return;
		} else {
        	document.all("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=ChangeCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&ismand="+ismand+"&returnCodeStr="+document.getElementById("field<%=fieldCode%>").value +"&oldCodeStr="+initfieldvalue;
        }
	}
}
function changeKeyword(uservalue,cellvalue,ismand){
<%
	if(titleFieldId>0&&keywordFieldId>0){
%>
        fieldName=uservalue.substring(0,uservalue.indexOf("_"));
        if(fieldName=="field<%=titleFieldId%>"){
        	var keywordObj=document.getElementById("field<%=keywordFieldId%>");
		    document.getElementById("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordData&docTitle="+cellvalue+"&docKeyword="+keywordObj.value;
	    }
<%
   }else if(titleFieldId==-3&&keywordFieldId>0){
%>
        fieldName=uservalue;
        if(fieldName=="requestname"){
        	var keywordObj=document.getElementById("field<%=keywordFieldId%>");
		    document.getElementById("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordData&docTitle="+cellvalue+"&docKeyword="+keywordObj.value;
	    }
<%
   }
%>
}

function updateKeywordData(strWordkey){

	var nrow=frmmain.ChinaExcel.GetCellUserStringValueRow("field<%=keywordFieldId%>_1_1");
	if(nrow>0){
		var ncol=frmmain.ChinaExcel.GetCellUserStringValueCol("field<%=keywordFieldId%>_1_1");
		if(ncol>0){
			document.frmmain.ChinaExcel.SetCellVal(nrow,ncol,getChangeField(strWordkey));
			document.getElementById("field<%=keywordFieldId%>").value=strWordkey;
		    imgshoworhide(nrow,ncol);
            document.frmmain.ChinaExcel.RefreshViewSize();
		}
	}
}

function onShowKeyword(){

	var keywordRow=frmmain.ChinaExcel.GetCellUserStringValueRow("field<%=keywordFieldId%>_1_1");
	if(keywordRow>0){
		var keywordCol=frmmain.ChinaExcel.GetCellUserStringValueCol("field<%=keywordFieldId%>_1_1");
		if(keywordCol>0){

            strKeyword=document.getElementById("field<%=keywordFieldId%>").value;
            tempUrl=escape("/docs/sendDoc/WorkflowKeywordBrowserMulti.jsp?strKeyword="+strKeyword);
            id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+tempUrl);
        
		    if(typeof(id1)!="undefined"){
			    document.frmmain.ChinaExcel.SetCellVal(keywordRow,keywordCol,getChangeField(id1));
			    document.getElementById("field<%=keywordFieldId%>").value=id1;
		        imgshoworhide(keywordRow,keywordCol);
                frmmain.ChinaExcel.RefreshViewSize();
			}

			frmmain.ChinaExcel.GoToCell(1,1);
		}
	}

}
function onShowFnaInfo(fieldid,nrow){
<%if(isFnabill){%>
    var tindx = fieldid.indexOf("_");
    if (tindx > 0) {
        var tfieldname = fieldid.substring(0, tindx);
        var tlastfield = fieldid.substring(tindx + 1);
        if (tfieldname == "<%=organizationid%>" || tfieldname == "<%=subject%>" || tfieldname == "<%=budgetperiod%>") {
            tindx = tlastfield.indexOf("_");
            var trow=0;
            if(tindx>0){
                trow = tlastfield.substring(0, tindx);
            }else{
                trow = tlastfield;
            }
            if (document.all("<%=organizationtype%>_" + trow) && document.all("<%=organizationid%>_" + trow) && document.all("<%=subject%>_" + trow) && document.all("<%=budgetperiod%>_" + trow)) {
                if (document.all("<%=organizationtype%>_" + trow).value != "" && document.all("<%=organizationid%>_" + trow).value != "" && document.all("<%=subject%>_" + trow).value != "" && document.all("<%=budgetperiod%>_" + trow).value != "") {
                    getBudgetKpi(trow, document.all("<%=organizationtype%>_" + trow).value, document.all("<%=organizationid%>_" + trow).value, document.all("<%=subject%>_" + trow).value, nrow);
                    getLoan(trow, document.all("<%=organizationtype%>_" + trow).value, document.all("<%=organizationid%>_" + trow).value, nrow);
                    getBudget(trow, document.all("<%=organizationtype%>_" + trow).value, document.all("<%=organizationid%>_" + trow).value, document.all("<%=subject%>_" + trow).value, nrow);
                    return;
                }
            }
            if (document.all("<%=hrmremain%>_" + trow)) {
                document.all("<%=hrmremain%>_" + trow).value = "";
            }
            if (document.all("<%=deptremain%>_" + trow)) {
                document.all("<%=deptremain%>_" + trow).value = "";
            }
            if (document.all("<%=subcomremain%>_" + trow)) {
                document.all("<%=subcomremain%>_" + trow).value = "";
            }
            if(document.all("<%=loanbalance%>_" + trow)!=null){
                document.all("<%=loanbalance%>_" + trow).value = "";
            }
            if(document.all("<%=oldamount%>_" + trow)!=null){
                document.all("<%=oldamount%>_" + trow).value = "";
            }
            var hrmremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_" + trow + "_<%=hrmremaintype%>");
            if (hrmremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nrow, hrmremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, true);
            }
            var deptremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_" + trow + "_<%=deptremaintype%>");
            if (deptremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nrow, deptremaincol, nrow, deptremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nrow, deptremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nrow, deptremaincol, nrow, deptremaincol, true);
            }
            var subcomremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_" + trow + "_<%=subcomremaintype%>");
            if (subcomremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nrow, subcomremaincol, nrow, subcomremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nrow, subcomremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nrow, subcomremaincol, nrow, subcomremaincol, true);
            }
            var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + trow + "_<%=loanbalancetype%>");
            if (loanbalancecol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, false);
                frmmain.ChinaExcel.SetCellVal(nrow, loanbalancecol, "");
                frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, true);
            }
            var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + trow + "_<%=oldamounttype%>");
            if (oldamountcol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, false);
                frmmain.ChinaExcel.SetCellVal(nrow, oldamountcol, "");
                frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, true);
                frmmain.ChinaExcel.ReCalculate();
            }
        }
    }
<%}%>
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


function getBudgetKpi(index, organizationtype, organizationid, subjid,nrow) {
    var callbackProxy = function(o) {
        callback(o, index,nrow);
    };
    var callMetaData = { callback:callbackProxy };
    BudgetHandler.getBudgetKPI(document.all("<%=budgetperiod%>_" + index).value, organizationtype, organizationid, subjid, callMetaData);
}
function getBudget(index, organizationtype, organizationid, subjid,nrow) {
    var callbackProxy = function(o) {
        callback2(o, index,nrow);
    };
    var callMetaData = { callback:callbackProxy };
    BudgetHandler.getBudgetByDate(document.all("<%=budgetperiod%>_" + index).value, organizationtype, organizationid, subjid, callMetaData);
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
		setExcelValue("<%=loanbalance%>_" + index + "_<%=loanbalancetype%>",o);
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
    frmmain.ChinaExcel.ReCalculate();
    frmmain.ChinaExcel.RefreshViewSize();
}
function setExcelValue(labelexcel,value){
	var wcell=frmmain.ChinaExcel;
	var temprow1=wcell.GetCellUserStringValueRow(labelexcel);
	var tempcol1=wcell.GetCellUserStringValueCol(labelexcel);
	if(temprow1>0){
		wcell.SetCellVal(temprow1,tempcol1,value);
	    imgshoworhide(temprow1,tempcol1);
	}		
}
function getLoan(index, organizationtype, organizationid,nrow) {
    var callbackProxy = function(o) {
        callback1(o, index,nrow);
    };
    var callMetaData = { callback:callbackProxy };
    BudgetHandler.getLoanAmount(organizationtype, organizationid,callMetaData);
}

function doLinkAgeInit(){
    window.setTimeout("RealdoLinkAgeInit()",500);
}
function RealdoLinkAgeInit(){
    var tempS = "<%=selfieldsaddString%>";
    var tempA = "";
    var fields = "";
    var fieldvalues = "";
    if(tempS.length>0){
        tempA = tempS.split(",");
        for(var i=0;i<tempA.length;i++){
            if(document.getElementById("field"+tempA[i])){
                var tempselvalue = document.getElementById("field"+tempA[i]).value;
                fields += ","+tempA[i]+"_0";
                fieldvalues += ","+tempselvalue;
            }
        }
    }
    changeshowattrBymode(fields,fieldvalues,-1,<%=workflowid%>,<%=nodeid%>);
}

function doTriggerInit(){
    trrigerdetailfieldary=trrigerdetailfields.split(",");
}
function datainput(parfield){                <!--数据导入-->
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=0&trg="+parfield;
      <%
      if(!trrigerfield.trim().equals("")){

          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          if(document.all("<%=temp.substring(temp.indexOf("|")+1)%>")!=null) StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
         if(document.all("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          }
      %>
      //alert(StrData);
      document.all("datainputform").src="DataInputMode.jsp?"+StrData;
  }
function datainputd(parfield){                <!--数据导入-->

      var tempParfieldArr = parfield.split(",");
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=1&trg="+parfield;

      for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	var indexid=tempParfield.substr(tempParfield.indexOf("_")+1);

      <%
      if(!trrigerdetailfield.trim().equals("")){
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          if(document.all("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)!=null) StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value;

      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          if(document.all("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value;
      <%
          }
          }
      %>
      }

      document.all("datainputformdetail").src="DataInputModeDetail.jsp?"+StrData;
  }

<%
ArrayList currentdateList=Util.TokenizerString(currentdate,"-") ;
int departmentId=Util.getIntValue(ResourceComInfo.getDepartmentID(""+creater),-1);
int subCompanyId=Util.getIntValue(DepartmentComInfo1.getSubcompanyid1(""+departmentId),-1);	
int supSubCompanyId=Util.getIntValue(SubCompanyComInfo1.getSupsubcomid(""+subCompanyId),-1);
if(supSubCompanyId<=0){
	supSubCompanyId=subCompanyId;//若上级分部为空，则认为上级分部为分部
}
%>

    var workflowId=<%=workflowid%>;
    var formId=<%=formid%>;
    var isBill=<%=isbill%>;
	var yearId=-1;
	var monthId=-1;
	var dateId=-1;
	var fieldId=-1;
	var fieldValue=-1;
	var supSubCompanyId=-1;
	var subCompanyId=-1;
	var departmentId=-1;
	var recordId=-1;

	var yearFieldValue=-1;
    var yearFieldHtmlType=-1;
	var monthFieldValue=-1;
	var dateFieldValue=-1;	

function initDataForWorkflowCode(){
	yearId=-1;
	monthId=-1;
	dateId=-1;
	fieldId=-1;
	fieldValue=-1;
	supSubCompanyId=-1;
	subCompanyId=-1;
	departmentId=-1;
	recordId=-1;

	yearFieldValue=-1;
	yearFieldHtmlType="<%=yearFieldHtmlType%>";
	monthFieldValue=-1;
	dateFieldValue=-1;	

	if(document.getElementById("field<%=yearFieldId%>")!=null){
		if(yearFieldHtmlType==5){//年份为下拉框
		  try{
			  objYear=document.getElementById("field<%=yearFieldId%>");
			  yearId=objYear.options[objYear.selectedIndex].text; 
		  }catch(e){
		  }
		}else{
		    yearFieldValue=document.getElementById("field<%=yearFieldId%>").value;
		    if(yearFieldValue.indexOf("-")>0){
			    var yearFieldValueArray = yearFieldValue.split("-") ;
			    if(yearFieldValueArray.length>=1){
				    yearId=yearFieldValueArray[0];
			    }
		    }else{
			    yearId=yearFieldValue;
		    }
		}
	}

	if(document.getElementById("field<%=monthFieldId%>")!=null){
		monthFieldValue=document.getElementById("field<%=monthFieldId%>").value;
		if(monthFieldValue.indexOf("-")>0){
			var monthFieldValueArray = monthFieldValue.split("-") ;
			if(monthFieldValueArray.length>=2){
				yearId=monthFieldValueArray[0];
				monthId=monthFieldValueArray[1];
			}
		}
	}

	if(document.getElementById("field<%=dateFieldId%>")!=null){
		dateFieldValue=document.getElementById("field<%=dateFieldId%>").value;
		if(dateFieldValue.indexOf("-")>0){
			var dateFieldValueArray = dateFieldValue.split("-") ;
			if(dateFieldValueArray.length>=3){
				yearId=dateFieldValueArray[0];
				monthId=dateFieldValueArray[1];
				dateId=dateFieldValueArray[2];
			}
		}
	}

<%
	if(currentdateList.size()>=1){
%>
	    if(yearId==""||yearId<=0){
	        yearId=<%=(String)currentdateList.get(0)%>;
        }
<%
	}
%>
<%
	if(currentdateList.size()>=2){
%>
	    if(monthId==""||monthId<=0){
	        monthId=<%=(String)currentdateList.get(1)%>;
        }
<%
	}
%>
<%
	if(currentdateList.size()>=3){
%>
	    if(dateId==""||dateId<=0){
	        dateId=<%=(String)currentdateList.get(2)%>;
        }
<%
	}
%>

	if(document.getElementById("field<%=fieldIdSelect%>")!=null){
		fieldId=<%=fieldIdSelect%>;
		fieldValue=document.getElementById("field<%=fieldIdSelect%>").value;
	}

	if(document.getElementById("field<%=supSubCompanyFieldId%>")!=null){
		supSubCompanyId=document.getElementById("field<%=supSubCompanyFieldId%>").value;
	}
	if(supSubCompanyId==""||supSubCompanyId<=0){
	    supSubCompanyId=<%=supSubCompanyId%>;
	}
    
	if(document.getElementById("field<%=subCompanyFieldId%>")!=null){
		subCompanyId=document.getElementById("field<%=subCompanyFieldId%>").value;
	}
	if(subCompanyId==""||subCompanyId<=0){
	    subCompanyId=<%=subCompanyId%>;
	}

	if(document.getElementById("field<%=departmentFieldId%>")!=null){
		departmentId=document.getElementById("field<%=departmentFieldId%>").value;
	}
	if(departmentId==""||departmentId<=0){
	    departmentId=<%=departmentId%>;
	}
}

function onCreateCodeAgain(){

	try{
		oPopup.hide();
	}catch(e){
	}

	var ismand=1;
	if(document.getElementById("field<%=fieldCode%>")!=null){
        initDataForWorkflowCode();
        document.all("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=CreateCodeAgain&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&ismand="+ismand;
	}
}
function onCreateCodeAgainReturn(newCode,ismand){

		if(typeof(newCode)!="undefined"&&newCode!=""){
			document.getElementById("field<%=fieldCode%>").value=newCode;

			if(parent.document.getElementById("requestmarkSpan")!=null){
				parent.document.getElementById("requestmarkSpan").innerText=newCode;
			}

	        var fieldCodeRow=frmmain.ChinaExcel.GetCellUserStringValueRow("field<%=fieldCode%>_1_1");
	        if(fieldCodeRow>0){
		        var fieldCodeCol=frmmain.ChinaExcel.GetCellUserStringValueCol("field<%=fieldCode%>_1_1");
		        if(fieldCodeCol>0){
					document.frmmain.ChinaExcel.SetCellVal(fieldCodeRow,fieldCodeCol,newCode);
					imgshoworhide(fieldCodeRow,fieldCodeCol);
					frmmain.ChinaExcel.RefreshViewSize();
		        }
	        }
		}
}

function onChooseReservedCode(){

	try{
		oPopup.hide();
	}catch(e){
	}

	var ismand=1;

	if(document.getElementById("field<%=fieldCode%>")!=null){
        initDataForWorkflowCode();
        url=uescape("/workflow/workflow/showChooseReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	

	    con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);

		if(typeof(con)!="undefined"&&con!=""){
			document.all("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=chooseReservedCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&codeSeqReservedIdAndCode="+con+"&ismand="+ismand;	
		}	
	}

}

function onNewReservedCode(){

	try{
		oPopup.hide();
	}catch(e){
	}

    initDataForWorkflowCode();
    url=uescape("/workflow/workflow/showNewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
	con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);

}

function uescape(url){
    return escape(url);
}
</script>