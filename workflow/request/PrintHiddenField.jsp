<%@ page language="java" contentType="text/html; charset=GBK" %> 
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="urlcominfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.fna.budget.BudgetHandler" %>
<%@ page import="weaver.general.BaseBean" %>
<div style="display:none">
<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
</table>
</div>
<script type="text/javascript">
var trrigerfieldary="";
var trrigerdetailfieldary="";
</script>
<%
String acceptlanguage = request.getHeader("Accept-Language");
int requestid = Util.getIntValue(request.getParameter("requestid"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int formid = Util.getIntValue(request.getParameter("formid"));
String billid = Util.null2String(request.getParameter("billid"));
String isbill = Util.null2String(request.getParameter("isbill"));
int Languageid = Util.getIntValue(request.getParameter("Languageid"));
String _nodeid = Util.null2String(request.getParameter("nodeid"));    
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
String requestname = "";
String requestlevel = "";
RecordSet.executeSql("select requestname,requestlevel from workflow_requestbase where requestid="+requestid);
if(RecordSet.next()){
	requestname=RecordSet.getString("requestname");
	requestlevel=RecordSet.getString("requestlevel");
}

String sqlWfMessage = "select a.messagetype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.messagetype='1' and a.requestid="+requestid ;
RecordSet.executeSql(sqlWfMessage);
int rqMessageType=0;
if(RecordSet.next()){
	rqMessageType=RecordSet.getInt("messagetype");
}

FieldInfo.setRequestid(requestid);
FieldInfo.GetManTableField(formid,Util.getIntValue(isbill),Languageid);
FieldInfo.GetDetailTableField(formid,Util.getIntValue(isbill),Languageid);
FieldInfo.GetWorkflowNode(workflowid);

ArrayList mantablefields=FieldInfo.getManTableFields();
ArrayList manfieldvalues=FieldInfo.getManTableFieldValues();
ArrayList detailtablefields=FieldInfo.getDetailTableFields();
ArrayList detailfieldvalues=FieldInfo.getDetailTableFieldValues();
ArrayList detailtablefieldids=FieldInfo.getDetailTableFieldIds();
ArrayList ManUrlList=FieldInfo.getManUrlList();
ArrayList ManUrlLinkList=FieldInfo.getManUrlLinkList();
ArrayList DetailUrlList=FieldInfo.getDetailUrlList();
ArrayList DetailUrlLinkList=FieldInfo.getDetailUrlLinkList();
ArrayList NodeList=FieldInfo.getNodes();
ArrayList DetailFieldDBTypes=FieldInfo.getDetailFieldDBTypes();
ArrayList manfielddbtypes=FieldInfo.getManTableFieldDBTypes();

String fieldid="";
String fieldvalue="";
String url="";
String urllink="";
for(int i=0; i<mantablefields.size();i++){
    int htmltype=1;
    int type=1;
    int indx=-1;
    fieldid=(String)mantablefields.get(i);
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
        if(htmltype==3){            
%>
    <input type="hidden" name="<%=fieldid%>" value="<%=fieldvalue%>">
    <input type="hidden" name="<%=fieldid%>_url" value="<%=url%>">
    <input type="hidden" name="<%=fieldid%>_urllink" value="<%=urllink%>">
    <input type="hidden" name="<%=fieldid%>_linkno" value="">
<%
        }else{
        	if(htmltype==2 && type==2 && fieldvalue.indexOf("initFlashVideo")>-1){
        		fieldvalue = "";
        	}
%>
    <input type="hidden" name="<%=fieldid%>" value="<%=FieldInfo.toScreen(Util.StringReplace(fieldvalue,"\"","&quot;"))%>">
<%
        }
}
for(int i=0; i<detailtablefields.size();i++){
    ArrayList detaillist=(ArrayList)detailtablefields.get(i);
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
            if(htmltype==3 && (type==16 || type==152|| type==171)){ %>
                <input type="hidden" name="<%=fieldid%>_linkno" value="">
            <%}
        }
    }
%>
    <input type=hidden name="indexnum<%=i%>" id="indexnum<%=i%>" value="0">
    <input type=hidden name="nodesnum<%=i%>" id="nodesnum<%=i%>" value="0">
    <input type=hidden name="totalrow<%=i%>" id="totalrow<%=i%>" value="0">
    <input type=hidden name="tempdetail<%=i%>" id="tempdetail<%=i%>" value="<%=row%>">
<%
}
%>
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
		    imgshoworhide(temprow3,tempcol3);
		  }
		  
		  //签字
    	var temprow4=wcell.GetCellUserStringValueRow("qianzi");
    	var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
    	if(temprow4>0){
    		wcell.DeleteCellImage(temprow4,tempcol4,temprow4,tempcol4);
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
        if(htmltype==2 && ftype==2 && fvalue.indexOf("initFlashVideo")>-1){
        	fvalue = "";
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
            if(ftype==16 || ftype==152|| ftype==171){
                ArrayList tempshowidlist=Util.TokenizerString(fvalue,",");
                String linknums="";
                for(int t=0;t<tempshowidlist.size();t++){
                    int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                    tempnum++;
                    session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(t));
                    session.setAttribute("slinkwfnum",""+tempnum);
                    session.setAttribute("haslinkworkflow","1");
                    linknums+=tempnum+",";
                }
                if(linknums.length()>0) linknums=linknums.substring(0,linknums.length()-1);
%>
                document.all("<%=tmpfid%>_linkno").value="<%=linknums%>";
<%
            }
            fvalue=FieldInfo.getFieldName(fvalue,ftype,dbtype);
        }
        if(htmltype==6){            
            fvalue=FieldInfo.getFileName(fvalue);
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
    
    var isprintbegin=wcell.GetCellUserStringValueRow("detail<%=i%>_isprintbegin");
    var isprintend=wcell.GetCellUserStringValueRow("detail<%=i%>_isprintend");
    if(isprintbegin>0&&isprintend>0){
        wcell.SetRowHide(isprintbegin,isprintbegin,true);
        wcell.SetRowHide(isprintend,isprintend,true);
        if(totalrow==0) wcell.SetRowHide(isprintbegin,isprintend,true);
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
                document.getElementById("<%=tmpfid%>").value='<%=FieldInfo.toScreen(Util.encodeJS(fvalue))%>';
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
                    if(ftype==16 || ftype==152|| ftype==171){
                        ArrayList tempshowidlist=Util.TokenizerString(fvalue,",");
                        String linknums="";
                        for(int t=0;t<tempshowidlist.size();t++){
                            int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                            tempnum++;
                            session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(t));
                            session.setAttribute("slinkwfnum",""+tempnum);
                            session.setAttribute("haslinkworkflow","1");
                            linknums+=tempnum+",";
                        }
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
			var nodemark = '<%out.print(FieldInfo.dropScript(FieldInfo.toExcel(Util.encodeJS(nodemark))));%>';
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
function callback(o, index,nrow) {
    val = o.split("|");
    //alert(o);
    if (val[0] != "") {
        v = val[0].split(",");
        hrmremainstr = "<%=SystemEnv.getHtmlLabelName(18768,Languageid)%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,Languageid)%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,Languageid)%>:" + v[2];
        var hrmremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_" + index + "_<%=hrmremaintype%>");
        if (hrmremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nrow, hrmremaincol, getChangeField(hrmremainstr));
            frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, true);
        }
    }
    if (val[1] != "") {
        v = val[1].split(",");
        deptremainstr = "<%=SystemEnv.getHtmlLabelName(18768,Languageid)%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,Languageid)%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,Languageid)%>:" + v[2];
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
        subcomremainstr = "<%=SystemEnv.getHtmlLabelName(18768,Languageid)%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,Languageid)%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,Languageid)%>:" + v[2];
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
<script language=vbs src="/workflow/mode/loadmode.vbs"></script>
