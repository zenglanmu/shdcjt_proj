<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo"/>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<form name="frmmain" method="post" action="BillCptApplyOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

<%@ include file="/workflow/request/WorkflowManageRequestBody.jsp" %>
<%
    //获取明细表设置
    WFNodeDtlFieldManager.resetParameter();
    WFNodeDtlFieldManager.setNodeid(Util.getIntValue(""+nodeid));
    WFNodeDtlFieldManager.setGroupid(0);
    WFNodeDtlFieldManager.selectWfNodeDtlField();
    String dtladd = WFNodeDtlFieldManager.getIsadd();
    String dtledit = WFNodeDtlFieldManager.getIsedit();
    String dtldelete = WFNodeDtlFieldManager.getIsdelete();
    
    boolean canedit = false;
    if("1".equals(dtledit)){
        canedit = true;
    }
%>
<%
int groupid = 0 ;
fieldids.clear();
fieldnames.clear();
fieldvalues.clear();
fieldlabels.clear();
fieldhtmltypes.clear();
fieldtypes.clear();
ArrayList viewtypes=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
	if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示
	fieldids.add(RecordSet.getString("id"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	viewtypes.add(RecordSet.getString("viewtype"));
}
isviews.clear();
isedits.clear();
ismands.clear();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
	String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
	int thefieldidindex = fieldids.indexOf( thefieldid ) ;
	if( thefieldidindex == -1 ) continue ;
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}

%>
<table class=liststyle cellspacing=1 >
<tr>
	<td>
		<div>
		<% if(!isaffirmancebody.equals("1")|| reEditbody.equals("1")) { %>
		<%if(dtladd.equals("1")){%>
		<BUTTON Class=BtnFlow type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<%}
		if(dtladd.equals("1") || dtldelete.equals("1")){%>
		<BUTTON Class=BtnFlow type=button accessKey=E onclick="deleteRow1();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<%}}%>
		</div>
	</td>
</tr>
</table>
<table class=liststyle cellspacing=1   cols=10 id="oTable">
      	<COLGROUP>
    	   <tr class=header> 
    	   <% if((!isaffirmancebody.equals("1")|| reEditbody.equals("1"))  ) { %>
		   <td width="5%"><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
		   <%}%>
    	   <%
String dsptypes="";
String edittypes ="";
String mandtypes ="";
int tmpcount = 1;
int viewCount = 0; 
for(int ii=0;ii<fieldids.size();ii++){
	String isview1=(String)isviews.get(ii);
	if(isview1.equals("1")) viewCount++;
	}
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);
	String fieldid=(String)fieldids.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	String viewtype = (String)viewtypes.get(i);
	if(viewtype.equals("0"))
		continue;
	
	dsptypes +=","+tmpcount+"_"+isview;
	edittypes +=","+tmpcount+"_"+isedit;
	mandtypes +=","+tmpcount+"_"+ismand;
	tmpcount++;	

%>
    	  
            <td <%if(isview.equals("0")){%> style="display:none" <%}%> width="<%=viewCount==0?0:95/viewCount%>%"><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
            </tr>
    	   
            <%
            
	           int linecolor=0;  
	RecordSet.executeProc("bill_CptApplyDetail_Select",billid+"");
	int rowsum=0;
	while(RecordSet.next()){
            %>
            <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> > 
            	
			      <% if( (!isaffirmancebody.equals("1")|| reEditbody.equals("1")) ) { %>
            <td>
            <input type='checkbox' name='check_node' id='check_node' value="<%=RecordSet.getString("id")%>" <%if(!dtldelete.equals("1")){%>disabled<%}%>>
            </td>
            <%}else{%>
            	&nbsp;
          	<%}%>
          	
            <td <%if(dsptypes.indexOf("1_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("1_1")!=-1&&canedit){%>
            <button class=Browser onClick='onShowAssetType(node_<%=rowsum%>_cpttypespan,node_<%=rowsum%>_cpttypeid,<%if(mandtypes.indexOf("1_1")!=-1) {%>1<%} else {%>0<%}%>)'></button>
            <span class=Inputstyle id=node_<%=rowsum%>_cpttypespan>
            
        	 <% if(mandtypes.indexOf("1_1")!=-1){
        	 		if(RecordSet.getInt("cpttype")==0 )
        	 %>
        	 			<img src='/images/BacoError.gif' align=absmiddle>
        	 <%
        	 	needcheck+=",node_"+rowsum+"_cpttypeid";
        	 }%>
        	 <%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cpttype")),user.getLanguage())%>
         	 </span>
        	<%}else{%>
        	<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cpttype")),user.getLanguage())%>
         <%}%>
            <input type='hidden' name='node_<%=rowsum%>_cpttypeid' id='node_<%=rowsum%>_cpttypeid' value="<%=(RecordSet.getInt("cpttype")>0?RecordSet.getString("cpttype"):"")%>">
	    </td>
	    
	    <td <%if(dsptypes.indexOf("2_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("2_1")!=-1&&canedit){%>
            <button class=Browser onClick='onShowAsset(node_<%=rowsum%>_cptspan,node_<%=rowsum%>_cptid,<%if(mandtypes.indexOf("2_1")!=-1) {%>1<%} else {%>0<%}%>)'></button>
            <span class=Inputstyle id=node_<%=rowsum%>_cptspan>
            
        	 <% if(mandtypes.indexOf("2_1")!=-1){
        	 		if(RecordSet.getInt("cptid")==0 )
        	 %>
        	 			<img src='/images/BacoError.gif' align=absmiddle>
        	 <%
        	 	needcheck+=",node_"+rowsum+"_cptid";
        	 }%><a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("cptid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("cptid")),user.getLanguage())%> </a>
         
        	 </span>
        	<%}else{%>
         <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("cptid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("cptid")),user.getLanguage())%> </a>
         <%}%>
            <input type='hidden' name='node_<%=rowsum%>_cptid' id='node_<%=rowsum%>_cptid' value="<%=(RecordSet.getInt("cptid")>0?RecordSet.getString("cptid"):"")%>">
	    </td>
		 <td <%if(dsptypes.indexOf("3_0")!=-1){%> style="display:none" <%}%>>           
            <% if(edittypes.indexOf("3_1")!=-1&&canedit){%>
            <button class=Browser onClick='onShowAssetCapital(node_<%=rowsum%>_capitalspan,node_<%=rowsum%>_cptcapitalid,<%if(mandtypes.indexOf("3_1")!=-1) {%>1<%} else {%>0<%}%>)'></button>
            <span class=Inputstyle id=node_<%=rowsum%>_capitalspan>
            
        	 <% if(mandtypes.indexOf("3_1")!=-1){
        	 			if(RecordSet.getInt("capitalid")==0)
        	 %>
        	 			<img src='/images/BacoError.gif' align=absmiddle>
        	 <%
        	 	needcheck+=",node_"+rowsum+"_capitalid";
        	 }%>
			 <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%> </a>
        	 </span>
        	<%} else {%>
			 <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%> </a>
			<%}%>
	    <input type='hidden' name='node_<%=rowsum%>_cptcapitalid' id='node_<%=rowsum%>_cptcapitalid' value="<%=(RecordSet.getInt("capitalid")>0?RecordSet.getString("capitalid"):"")%>">
	    </td>

            <td <%if(dsptypes.indexOf("4_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("4_1")!=-1&&canedit){
            	if(mandtypes.indexOf("4_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_number','node_<%=rowsum%>_numberspan')>
            		<span id="node_<%=rowsum%>_numberspan">
            		<%if(RecordSet.getString("number_n").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		         <%
        	 	}needcheck+=",node_"+rowsum+"_number";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>" onKeyPress='ItemNum_KeyPress()'  onblur=checknumber('node_<%=rowsum%>_number')>
            	<%}%>
	    <%}else{%>
	    	<%=RecordSet.getString("number_n")%>
	    <input type='hidden' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("5_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("5_1")!=-1&&canedit){
            	if(mandtypes.indexOf("5_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_unitprice','node_<%=rowsum%>_unitpricespan')>
            		<span id="node_<%=rowsum%>_unitpricespan">
            		<%if(RecordSet.getString("unitprice").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_unitprice";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>" onKeyPress='ItemNum_KeyPress()' onblur=checknumber('node_<%=rowsum%>_unitprice')>
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("unitprice")%>
	    <input type='hidden' name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("6_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("6_1")!=-1&&canedit){
            	if(mandtypes.indexOf("6_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_amount','node_<%=rowsum%>_amountspan')>
            		<span id="node_<%=rowsum%>_amountspan">
            		<%if(RecordSet.getString("amount").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_amount";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>" onKeyPress='ItemNum_KeyPress()' onblur=checknumber('node_<%=rowsum%>_amount')>
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("amount")%>
	    <input type='hidden' name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("7_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("7_1")!=-1&&canedit){%>
            <button class=Browser onClick='onShowDate1(node_<%=rowsum%>_needdatespan,node_<%=rowsum%>_needdate,<%if(mandtypes.indexOf("7_1")!=-1) {%>1<%} else {%>0<%}%>)'></button>
            <span class=Inputstyle id=node_<%=rowsum%>_needdatespan>
            
        	 <% if(mandtypes.indexOf("7_1")!=-1 ){
        	 		if(RecordSet.getString("needdate").equals(""))
        	 %>
        	 			<img src='/images/BacoError.gif' align=absmiddle>
        	 <%
        	 	needcheck+=",node_"+rowsum+"_needdate";
        	 }%>
        	 <%=RecordSet.getString("needdate")%>
            	 </span>
        	<%}else{%>
        	<%=RecordSet.getString("needdate")%>
            <%}%>
	    <input type='hidden' name='node_<%=rowsum%>_needdate' id='node_<%=rowsum%>_needdate' value="<%=RecordSet.getString("needdate")%>">
	    </td>
            <td <%if(dsptypes.indexOf("8_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("8_1")!=-1&&canedit){
            	if(mandtypes.indexOf("8_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=RecordSet.getString("purpose")%>"  OnBlur=checkinput('node_<%=rowsum%>_purpose','node_<%=rowsum%>_purposespan')>
            		<span id="node_<%=rowsum%>_purposespan">
            		<%if(RecordSet.getString("purpose").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_purpose";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=Util.toScreenToEdit(RecordSet.getString("purpose"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <%=Util.toScreen(RecordSet.getString("purpose"),user.getLanguage())%><input type='hidden' name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=RecordSet.getString("purpose")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("9_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("9_1")!=-1&&canedit){
            	if(mandtypes.indexOf("9_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=RecordSet.getString("cptdesc")%>"  OnBlur=checkinput('node_<%=rowsum%>_cptdesc','node_<%=rowsum%>_cptdescspan')>
            		<span id="node_<%=rowsum%>_cptdescspan">
            		<%if(RecordSet.getString("cptdesc").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_cptdesc";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=Util.toScreenToEdit(RecordSet.getString("cptdesc"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <%=Util.toScreen(RecordSet.getString("cptdesc"),user.getLanguage())%>
	    <input type='hidden' name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=RecordSet.getString("cptdesc")%>">
	    <%}%>
	    </td>
           </tr>
            <%if(linecolor==0) linecolor=1;
          else linecolor=0; rowsum++;}%>
  </table> 
<input  type ='hidden' id=nodesnum name=nodesnum value=<%=rowsum%>>
<!-- modify by xhheng @20050328 for TD 1703-->

<br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>
<script language=vbs>
sub onShowResourceID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	else 
		if ismand=1 then
			resourceidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		else
			resourceidspan.innerHtml = ""
		end if
	frmmain.resourceid.value="0"
	end if
	end if
end sub

sub onShowAssetCapital(spanname,inputname,mand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
		else
			if mand=1 then
			spanname.innerHtml =  "<img src='/images/BacoError.gif' align=absmiddle>"
			else 
			spanname.innerHtml =  ""
			end if
			inputname.value=""
		end if
	end if
end sub

sub onShowAsset(spanname,inputname,mand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='1' ")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
		else
			if mand=1 then
			spanname.innerHtml =  "<img src='/images/BacoError.gif' align=absmiddle>"
			else 
			spanname.innerHtml =  ""
			end if
			inputname.value=""
		end if
	end if
end sub

sub onShowAssetType(spanname,inputname,mand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
			if mand=1 then
			spanname.innerHtml =  "<img src='/images/BacoError.gif' align=absmiddle>"
			else 
			spanname.innerHtml =  ""
			end if
			inputname.value=""
		end if
	end if
end sub

</script>   

<script language=javascript>
if ("<%=needcheck%>" != ""){
    document.all("needcheck").value += ","+"<%=needcheck%>";
}

groupid = <%=groupid%>;

rowindex = document.frmmain.nodesnum.value ;
needcheck = "<%=needcheck%>";
function addRow()
{
	ncol = oTable.cols;
	dsptypes = "<%=dsptypes%>";
	edittypes = "<%=edittypes%>";
	mandtypes = "<%=mandtypes%>";
	
	oRow = oTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		if(dsptypes.indexOf(j+"_0")!=-1){
			oCell.style.display="none";
		}
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
					
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("1_1")!=-1){
					sHtml = "<button class=Browser onClick='onShowAssetType(node_"+rowindex+"_cpttypespan,node_"+rowindex+"_cpttypeid,"
					if(mandtypes.indexOf("1_1")!=-1) sHtml += "1" ;
					else sHtml += "0" ;
						sHtml +=")'></button> " + 
        					"<span class=Inputstyle id=node_"+rowindex+"_cpttypespan>";
        				if(mandtypes.indexOf("1_1")!=-1){
        					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_cpttypeid";
        				}
        				sHtml +="</span> <input type='hidden' name='node_"+rowindex+"_cpttypeid' id='node_"+rowindex+"_cpttypeid'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;

			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("2_1")!=-1){
					sHtml = "<button class=Browser onClick='onShowAsset(node_"+rowindex+"_cptspan,node_"+rowindex+"_cptid,";
					if(mandtypes.indexOf("2_1")!=-1) sHtml += "1" ;
					else sHtml += "0" ;
					sHtml +=")'></button> " + 
        					"<span class=Inputstyle id=node_"+rowindex+"_cptspan>";
        				if(mandtypes.indexOf("2_1")!=-1){
        					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_cptid";
        				}
        				sHtml +="</span> <input type='hidden' name='node_"+rowindex+"_cptid' id='node_"+rowindex+"_cptid'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;

			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("3_1")!=-1){
					sHtml = "<button class=Browser onClick='onShowAssetCapital(node_"+rowindex+"_cptcapitalspan,node_"+rowindex+"_cptcapitalid,";
					if(mandtypes.indexOf("3_1")!=-1) sHtml += "1" ;
					else sHtml += "0" ;
					sHtml +=")'></button> " + 
        					"<span class=Inputstyle id=node_"+rowindex+"_cptcapitalspan>";
        				if(mandtypes.indexOf("3_1")!=-1){
        					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_cptcapitalid";
        				}
        				sHtml +="</span> <input type='hidden' name='node_"+rowindex+"_cptcapitalid' id='node_"+rowindex+"_cptcapitalid'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;

			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("4_1")!=-1){
					if(mandtypes.indexOf("4_1")!=-1){ 
						sHtml = "<input type='text' class=inputstyle  name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_number','node_"+rowindex+"_numberspan')><span id='node_"+rowindex+"_numberspan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_number";
        				}else{
        					sHtml = "<input type='text' class=inputstyle   name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onblur=checknumber('node_"+rowindex+"_number')>";
        				}
	        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("5_1")!=-1){
					if(mandtypes.indexOf("5_1")!=-1){
						sHtml = "<input type='text' class=inputstyle    name='node_"+rowindex+"_unitprice'  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_unitprice','node_"+rowindex+"_unitpricespan')><span id='node_"+rowindex+"_unitpricespan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_unitprice";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text' class=inputstyle    name='node_"+rowindex+"_unitprice' onKeyPress='ItemNum_KeyPress()' onblur=checknumber('node_"+rowindex+"_unitprice')>";
        				}
        				
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("6_1")!=-1){
					if(mandtypes.indexOf("6_1")!=-1){
						sHtml = "<input type='text' class=inputstyle    name='node_"+rowindex+"_amount'  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_amount','node_"+rowindex+"_amountspan')><span id='node_"+rowindex+"_amountspan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_amount";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text' class=inputstyle    name='node_"+rowindex+"_amount' onKeyPress='ItemNum_KeyPress()' onblur=checknumber('node_"+rowindex+"_amount')>";
        				}
        				
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			
			case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("7_1")!=-1){
					sHtml = "<button class=Browser onClick='onShowDate1(node_"+rowindex+"_needdatespan,node_"+rowindex+"_needdate,";
					if(mandtypes.indexOf("7_1")!=-1) sHtml += "1" ;
					else sHtml += "0" ;
					sHtml +=")'></button> " + 
						"<span class=Inputstyle id=node_"+rowindex+"_needdatespan> ";
					if(mandtypes.indexOf("7_1")!=-1){
        					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_needdate";
        				}
        				sHtml+="</span>"
        				sHtml += "<input type='hidden' name='node_"+rowindex+"_needdate' id='node_"+rowindex+"_needdate'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			
			case 8: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";;
				if(edittypes.indexOf("8_1")!=-1){
					if(mandtypes.indexOf("8_1")!=-1){
						sHtml = "<input type='text' class=inputstyle   name='node_"+rowindex+"_purpose' onBlur=checkinput('node_"+rowindex+"_purpose','node_"+rowindex+"_purposespan')><span id='node_"+rowindex+"_purposespan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_purpose";
        					sHtml+="</span>"        				
        				}else{
        					sHtml = "<input type='text' class=inputstyle   name='node_"+rowindex+"_purpose'>";
        				}
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;	
			case 9: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";;
				if(edittypes.indexOf("9_1")!=-1){
					if(mandtypes.indexOf("9_1")!=-1){
						sHtml = "<input type='text' class=inputstyle   name='node_"+rowindex+"_cptdesc' onBlur=checkinput('node_"+rowindex+"_cptdesc','node_"+rowindex+"_cptdescspan')><span id='node_"+rowindex+"_cptdescspan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_cptdesc";
        					sHtml+="</span>"        				
        				}else{
        					sHtml = "<input type='text' class=inputstyle   name='node_"+rowindex+"_cptdesc'>";
        				}
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;	
				
		}
	}
    //if ("<%=needcheck%>" != ""){
        document.all("needcheck").value += ","+needcheck;
    //}
	rowindex = rowindex*1 +1;
	document.frmmain.nodesnum.value = rowindex ;
}


function deleteRow1()
{
	var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
            len = document.forms[0].elements.length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node')
                    rowsum1 += 1;
            }
            mandtypes = "<%=mandtypes%>";
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        tmprow = document.forms[0].elements[i].value;
                        oTable.deleteRow(rowsum1);
                    }
                    rowsum1 -=1;
                }
            }
}
}else{
alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
}
	
}	


function changetype(obj){
	groupid = obj.value;		
//	obj.disabled = true;
}
	function doRemark(){
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		document.frmmain.nodesnum.value=<%=rowsum%>;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}


function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{  
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else 
                return true;
            }
            }
        else
        return true;
        }
}


function checktimeok(){
if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != ""){
			YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
			MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
			DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
			YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
			MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
			DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
			// window.alert(YearFrom+MonthFrom+DayFrom);
                   if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
        window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
         return false;
  			 }
  }
     return true; 
}
	

</script>

</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
