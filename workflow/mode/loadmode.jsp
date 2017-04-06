<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="urlcominfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<%
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
//TD9892
BaseBean bb_loadmode = new BaseBean();
int urm_loadmode = 1;
try{
	urm_loadmode = Util.getIntValue(bb_loadmode.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String isbill = Util.null2String(request.getParameter("isbill"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int isform = Util.getIntValue(request.getParameter("isform"));
int modeid = Util.getIntValue(request.getParameter("modeid"));
int nodeid = Util.getIntValue(request.getParameter("nodeid"));
int formid = Util.getIntValue(request.getParameter("formid"));

FieldInfo.setUser(user);
FieldInfo.GetManTableField(formid,Util.getIntValue(isbill),user.getLanguage());
FieldInfo.GetDetailTableField(formid,Util.getIntValue(isbill),user.getLanguage());
FieldInfo.GetWorkflowNode(workflowid);
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
String selfieldsaddString = "";
for(int i=0;i<selfieldsadd.size();i++){
    selfieldsaddString += (String)selfieldsadd.get(i)+",";
}
if(!selfieldsaddString.equals("")) selfieldsaddString = selfieldsaddString.substring(0,selfieldsaddString.length()-1);
//获得触发字段名
DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
String trrigerdetailfield=ddi.GetEntryTriggerDetailFieldName();
ArrayList Linfieldname=ddi.GetInFieldName();
ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
%>
<script type="text/javascript">
var trrigerfields="<%=trrigerfield%>";
var trrigerdetailfields="<%=trrigerdetailfield%>";
var trrigerfieldary=trrigerfields.split(",");
var trrigerdetailfieldary=trrigerdetailfields.split(",");
</script>
<iframe id="modeComboChange" id="modeComboChange" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="datainputform" frameborder=0 height="0" width="0" scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 height="0" width="0" scrolling=no src=""  style="display:none"></iframe>
<iframe ID="selframe" BORDER=0 FRAMEBORDER=no height="0%" width="0%" scrolling="NO" src=""></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<script language=javascript src="/workflow/mode/loadmode.js"></script>
<script type='text/javascript' src='/dwr/interface/BudgetHandler.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script language=javascript src="/js/characterConv.js"></script>
<script language=javascript >
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="ShowCellChanged()"	LANGUAGE="JavaScript" >
var nowrow=frmmain.ChinaExcel.Row;
var nowcol=frmmain.ChinaExcel.Col;
var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nowrow,nowcol);
var cellvalue=frmmain.ChinaExcel.GetCellValue(nowrow,nowcol);
cellvalue = Simplized(cellvalue);
var ismand=frmmain.ChinaExcel.GetCellUserValue(nowrow,nowcol);
var fieldname=uservalue;
if(fieldname!=null){
    var indx=fieldname.lastIndexOf("_");
        if(indx>0){
        var addordel=fieldname.substring(indx+1);
        fieldname=fieldname.substring(0,indx);
        indx=fieldname.lastIndexOf("_");
        if(indx>0){
            fieldname=fieldname.substring(0,indx);
        }
        if(addordel=="sel"){                
                frmmain.ChinaExcel.SetCellCheckBoxValue(nowrow,nowcol,!frmmain.ChinaExcel.GetCellCheckBoxValue(nowrow,nowcol));
                return false;
        }else{
            if(addordel=="4" &&  ismand>0){
                frmmain.ChinaExcel.SetCellCheckBoxValue(nowrow,nowcol,!frmmain.ChinaExcel.GetCellCheckBoxValue(nowrow,nowcol));
                var checkvalue="0";
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
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="MouseLClick(Row, Col, UpDown)"	LANGUAGE="JavaScript" >
	<%if(urm_loadmode==1){%>
    rightMenu.style.visibility="hidden";
    <%}%>
    var nowrow=frmmain.ChinaExcel.Row;
    var nowcol=frmmain.ChinaExcel.Col;
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nowrow,nowcol); 
    var ismand=frmmain.ChinaExcel.GetCellUserValue(nowrow,nowcol);
    var fieldname=uservalue;
    var changefields="";
	var upDown = UpDown;
	if(upDown == 0){//only for mouse left up
    <%
    for(int i=0;i<changedefieldsmanage.size();i++){
    %>
    changefields+=",<%=changedefieldsmanage.get(i)%>";
    <%
    }
    %>
    if(uservalue!=null){
    	if(uservalue=="qianzi"&&ismand==1&&(<%=ispopup%>||"<%=isFormSignature%>"==1)){
    		var remark = document.getElementById("remark").value;
            var signdocids = document.getElementById("signdocids").value;
            var signworkflowids = document.getElementById("signworkflowids").value;
    		var workflowRequestLogId = document.getElementById("workflowRequestLogId").value;
        var fieldvalue=document.getElementById(uservalue).value;
        var redirectUrl = "/workflow/request/WorkFlowSignUP.jsp?nodeid=<%=nodeid%>&fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit="+ismand+"&isFormSignature=<%=isFormSignature%>&formSignatureWidth=<%=formSignatureWidth%>&formSignatureHeight=<%=formSignatureHeight%>&remark="+remark+"&workflowRequestLogId="+workflowRequestLogId+"&signdocids="+signdocids+"&signworkflowids="+signworkflowids;
        var szFeatures = "top="+(screen.height-300)/2+"," ;
        szFeatures +="left="+(screen.width-750)/2+"," ;
        szFeatures +="width=750," ;
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
            if(addordel=="6" && ismand>0){
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
                var redirectUrl = "/workflow/request/WorkFlowFileUP.jsp?fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit="+ismand+"&isbill=<%=isbill%>&uploadType=<%=uploadType%>&selectedfieldid=<%=selectedfieldid%>&selectfieldvalue="+selectfieldvalue;
                var szFeatures = "top="+(screen.height-300)/2+"," ;
                szFeatures +="left="+(screen.width-750)/2+"," ;
                szFeatures +="width=750," ;
                szFeatures +="height=300," ; 
                szFeatures +="directories=no," ;
                szFeatures +="status=no," ;
                szFeatures +="menubar=no," ;
                szFeatures +="scrollbars=yes," ;
                szFeatures +="resizable=no" ; //channelmode
                window.open(redirectUrl,"fileup",szFeatures);                
                frmmain.ChinaExcel.GoToCell(1,1);                
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
        <%if(urm_loadmode==1){%>
        var divBillScrollTop=parent.document.getElementById("divWfBill").scrollTop;
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
			var paraStr = "fieldid="+fieldid+"&childfield="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+selvalue+"&rownum="+rownum;
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
<div id="exceldiv" name="exceldiv" style="display:none">
<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelobj_tw.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelobj.js"></script>
<%} %>
</div>

<DIV id="ocontext" name="ocontext" style="LEFT: 0px;Top:0px;POSITION:ABSOLUTE ;display:none" >
<table id=otable cellpadding='0' cellspacing='0' width="200" border=1 style="WORD-WRAP:break-word">
</table>
</DIV>
<input type=hidden name="indexrow" id="indexrow" value=0>
<input type=hidden name="modeid" id="modeid" value="<%=modeid%>">
<input type=hidden name="isform" id="isform" value="<%=isform%>">
<input type=hidden name="modestr" id="modestr" value="">
<script language=javascript>
function readmode(){
    frmmain.ChinaExcel.ReadHttpFile("/workflow/mode/ModeReader.jsp?modeid=<%=modeid%>&nodeid=<%=nodeid%>&isform=<%=isform%>");
    document.getElementById("exceldiv").style.display='';
}
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
	if(isdefault>0)
    {
    	rowIns("<%=i%>",0,1,changefields);
    }
<%
    }
%>
}
</script>
<script language=vbs>
sub init()
    frmmain.ChinaExcel.SetOnlyShowTipMessage true
    //hideRightClickMenu()
    chinaexcelregedit()
	readmode()
    frmmain.ChinaExcel.DesignMode = false
    frmmain.ChinaExcel.SetShowPopupMenu false
    frmmain.ChinaExcel.SetCanAutoSizeHideCols false
    frmmain.ChinaExcel.SetProtectFormShowCursor false
    frmmain.ChinaExcel.SetShowScrollBar 1,false        
    frmmain.ChinaExcel.ShowGrid = false
    getRowGroup()
    setmantable()
    setdetailtable()
	initRowData()
    doTriggerInit()
    doLinkAgeInit()
    changeKeyword "requestname",document.getElementById("requestname").value,1
    frmmain.ChinaExcel.ReCalculate()    
    setheight()    
    frmmain.ChinaExcel.SetPasteType 1
    RefreshViewSize()
    frmmain.ChinaExcel.SetOnlyShowTipMessage false
end sub
</script>
<script language=javascript>
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
	<%if(urm_loadmode==1){%>
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
function createDoc(fieldbodyid,docVlaue,isedit){
	
	try{
		hidePopup();
	}catch(e){
	}
   /*
   for(i=0;i<=1;i++){
  		parent.document.all("oTDtype_"+i).background="/images/tab2.png";
  		parent.document.all("oTDtype_"+i).className="cycleTD";
  	}
  	parent.document.all("oTDtype_1").background="/images/tab.active2.png";
  	parent.document.all("oTDtype_1").className="cycleTDCurrent";
  	*/
  	//frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docVlaue;
  	frmmain.action = frmmain.action+"?docView="+isedit+"&docValue="+docVlaue+"&isFromEditDocument=true";
    frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw";
	parent.delsave();
	if(check_form(document.frmmain,'requestname')){
      	if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "1";//标识点正文
        document.frmmain.src.value='save';

                        document.frmmain.submit();

	parent.clicktext();//切换当前tab页到正文页面
	if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "";//标识点正文
	if(document.getElementById("iscreate")) document.getElementById("iscreate").value = "0";	
    }

}

function openWindow(urlLink){

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
			document.frmmain.ChinaExcel.SetCellVal(nrow,ncol,strWordkey);
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
			    document.frmmain.ChinaExcel.SetCellVal(keywordRow,keywordCol,id1);
			    document.getElementById("field<%=keywordFieldId%>").value=id1;
		        imgshoworhide(keywordRow,keywordCol);
                frmmain.ChinaExcel.RefreshViewSize();
			}

			frmmain.ChinaExcel.GoToCell(1,1);
		}
	}

}
function onShowFnaInfo(fieldid,nowrow){
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
            if (document.all("<%=organizationid%>_" + trow) && document.all("<%=subject%>_" + trow) && document.all("<%=budgetperiod%>_" + trow)) {
                if (document.all("<%=organizationid%>_" + trow).value != "" && document.all("<%=subject%>_" + trow).value != "" && document.all("<%=budgetperiod%>_" + trow).value != "") {
                    getBudgetKpi(trow, document.all("<%=organizationtype%>_" + trow).value, document.all("<%=organizationid%>_" + trow).value, document.all("<%=subject%>_" + trow).value,nowrow);
                    getLoan(trow, document.all("<%=organizationtype%>_" + trow).value, document.all("<%=organizationid%>_" + trow).value,nowrow);
                    getBudget(trow, document.all("<%=organizationtype%>_" + trow).value, document.all("<%=organizationid%>_" + trow).value, document.all("<%=subject%>_" + trow).value,nowrow);
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
                frmmain.ChinaExcel.SetCellProtect(nowrow, hrmremaincol, nowrow, hrmremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, hrmremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, hrmremaincol, nowrow, hrmremaincol, true);
            }
            var deptremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_" + trow + "_<%=deptremaintype%>");
            if (deptremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nowrow, deptremaincol, nowrow, deptremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, deptremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, deptremaincol, nowrow, deptremaincol, true);
            }
            var subcomremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_" + trow + "_<%=subcomremaintype%>");
            if (subcomremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nowrow, subcomremaincol, nowrow, subcomremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, subcomremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, subcomremaincol, nowrow, subcomremaincol, true);
            }
            var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + trow + "_<%=loanbalancetype%>");
            if (loanbalancecol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nowrow, loanbalancecol, nowrow, loanbalancecol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, loanbalancecol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, loanbalancecol, nowrow, loanbalancecol, true);
            }
            var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + trow + "_<%=oldamounttype%>");
            if (oldamountcol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nowrow, oldamountcol, nowrow, oldamountcol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, oldamountcol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, oldamountcol, nowrow, oldamountcol, true);
                frmmain.ChinaExcel.ReCalculate();
            }
        }
    }
<%}%>
}
function callback(o, index,nowrow) {
    val = o.split("|");
    if (val[0] != "") {
        v = val[0].split(",");
        hrmremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var hrmremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_" + index + "_<%=hrmremaintype%>");
        if (hrmremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nowrow, hrmremaincol, nowrow, hrmremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nowrow, hrmremaincol, hrmremainstr);
            frmmain.ChinaExcel.SetCellProtect(nowrow, hrmremaincol, nowrow, hrmremaincol, true);
        }
    }
    if (val[1] != "") {
        v = val[1].split(",");
        deptremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var deptremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_" + index + "_<%=deptremaintype%>");
        if (deptremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nowrow, deptremaincol, nowrow, deptremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nowrow, deptremaincol, deptremainstr);
            frmmain.ChinaExcel.SetCellProtect(nowrow, deptremaincol, nowrow, deptremaincol, true);
        }
    }
    if (val[2] != "") {
        v = val[2].split(",");
        subcomremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var subcomremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_" + index + "_<%=subcomremaintype%>");
        if (subcomremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nowrow, subcomremaincol, nowrow, subcomremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nowrow, subcomremaincol, subcomremainstr);
            frmmain.ChinaExcel.SetCellProtect(nowrow, subcomremaincol, nowrow, subcomremaincol, true);
        }
    }
    frmmain.ChinaExcel.RefreshViewSize();
}


function getBudgetKpi(index, organizationtype, organizationid, subjid,nowrow) {
    var callbackProxy = function(o) {
        callback(o, index,nowrow);
    };
    var callMetaData = { callback:callbackProxy };

    BudgetHandler.getBudgetKPI(document.all("<%=budgetperiod%>_"+index).value, organizationtype, organizationid, subjid, callMetaData);
}
function callback1(o, index,nowrow) {
    if(document.all("<%=loanbalance%>_" + index)!=null){
        document.all("<%=loanbalance%>_" + index).value = o;
    }
    var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + index + "_<%=loanbalancetype%>");
    if (loanbalancecol > 0) {
        frmmain.ChinaExcel.SetCellProtect(nowrow, loanbalancecol, nowrow, loanbalancecol, false);
        frmmain.ChinaExcel.SetCellVal(nowrow, loanbalancecol, o);
        frmmain.ChinaExcel.SetCellProtect(nowrow, loanbalancecol, nowrow, loanbalancecol, true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}
function callback2(o, index,nowrow) {
     if(document.all("<%=oldamount%>_" + index)!=null){
        document.all("<%=oldamount%>_" + index).value = o;
    }
    var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + index + "_<%=oldamounttype%>");
    if (oldamountcol > 0) {
        frmmain.ChinaExcel.SetCellProtect(nowrow, oldamountcol, nowrow, oldamountcol, false);
        frmmain.ChinaExcel.SetCellVal(nowrow, oldamountcol, o);
        frmmain.ChinaExcel.SetCellProtect(nowrow, oldamountcol, nowrow, oldamountcol, true);
    }
    frmmain.ChinaExcel.ReCalculate();
    frmmain.ChinaExcel.RefreshViewSize();
 }
function getLoan(index, organizationtype, organizationid,nowrow) {
    var callbackProxy = function(o) {
        callback1(o, index,nowrow);
    };
    var callMetaData = { callback:callbackProxy };
    BudgetHandler.getLoanAmount(organizationtype, organizationid,callMetaData);
}
function getBudget(index, organizationtype, organizationid, subjid,nowrow) {
     var callbackProxy = function(o) {
         callback2(o, index,nowrow);
     };
     var callMetaData = { callback:callbackProxy };

     BudgetHandler.getBudgetByDate(document.all("<%=budgetperiod%>_"+index).value, organizationtype, organizationid, subjid, callMetaData);
 }
 function doTriggerInit(){
    window.setTimeout("doDataInput()",200);
}

 function doDataInput(){
	    var tempS = "<%=trrigerfield%>";
	    datainput(tempS);
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

function datainput(parfield){                <!--数据导入-->
      var tempParfieldArr = parfield.split(",");
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=0&trg="+parfield;
      for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
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
      }
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
</script>