<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo"/>
<jsp:useBean id="SearchNumberRecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<form name="frmmain" method="post" action="BillCptDiscardOperation.jsp" enctype="multipart/form-data">
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
		<% if(!isaffirmancebody.equals("1")|| reEditbody.equals("1")) { %>
		<%if(dtladd.equals("1")){%>
		<BUTTON Class=BtnFlow type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<%}
		if(dtladd.equals("1") || dtldelete.equals("1")){%>
		<BUTTON Class=BtnFlow type=button accessKey=E onclick="deleteRow1();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<%}}%>
	</td>
</tr>
</table>
  <table class=liststyle cellspacing=1   cols=9 id="oTable">
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
    	  
            <td <%if(isview.equals("0")){%> style="display:none" <%}%>><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
            </tr>
    	   
            <%
            
	           int linecolor=0;  
	RecordSet.executeSql("select * from bill_Discard_Detail where detailrequestid="+requestid);
	//System.out.println("select * from bill_Discard_Detail where detailrequestid="+requestid);
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
            <button class=Browser onClick='onShowAssetCapital(node_<%=rowsum%>_capitalidspan,node_<%=rowsum%>_capitalid,node_<%=rowsum%>_number,node_<%=rowsum%>_numberspan,node_<%=rowsum%>_count)'></button>
            <span id="node_<%=rowsum%>_capitalidspan">
            
        	 <% if(mandtypes.indexOf("1_1")!=-1 && RecordSet.getInt("capitalid")==0 ){%>
        	 			<img src='/images/BacoError.gif' align=absmiddle>
        	 <%}
        	 	if(mandtypes.indexOf("1_1")!=-1) needcheck+=",node_"+rowsum+"_capitalid";
        	 %>
        	 <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%></a>
         	 </span>
        	<%}else{%>
        	<a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%></a>
         <%}%>
            <input type='hidden' name='node_<%=rowsum%>_capitalid' id='node_<%=rowsum%>_capitalid' value="<%=RecordSet.getString("capitalid")%>">
	        <%
             String tempStockAmount = "";
             SearchNumberRecordSet.executeSql("select capitalnum from CptCapital where id="+RecordSet.getString("capitalid"));
             if(SearchNumberRecordSet.next()) tempStockAmount = SearchNumberRecordSet.getString("capitalnum");
             %>
            <input type='hidden' name='node_<%=rowsum%>_count' id='node_<%=rowsum%>_count' value="<%=tempStockAmount%>">
	    </td>

            <td <%if(dsptypes.indexOf("2_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("2_1")!=-1&&canedit){
            	if(mandtypes.indexOf("2_1")!=-1){%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("numbers")%>"  onKeyPress='ItemNum_KeyPress()' onBlur="checkinput('node_<%=rowsum%>_number','node_<%=rowsum%>_numberspan');checkCount(<%=rowsum%>)">
            		<span id="node_<%=rowsum%>_numberspan">
            		<%if(RecordSet.getString("numbers").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		         <%}
        	 	needcheck+=",node_"+rowsum+"_number";%>
		        </span>
		
		<%}else{%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("numbers")%>"  onKeyPress='ItemNum_KeyPress()' onBlur='checkCount(<%=rowsum%>)'>
            		<span id="node_<%=rowsum%>_numberspan"></span>
            	<%}%>
	    <%}else{%>
	    	<%=RecordSet.getString("numbers")%>
	    <input type='hidden' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("numbers")%>">
	    <span id="node_<%=rowsum%>_numberspan"></span>
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("3_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("3_1")!=-1&&canedit){%>
            <button class=Browser onClick='onBillCPTShowDate(node_<%=rowsum%>_needdatespan,node_<%=rowsum%>_needdate,<%=mandtypes.indexOf("3_1")%>)'></button>
            <span id=node_<%=rowsum%>_needdatespan>
            
        	 <% if(mandtypes.indexOf("3_1")!=-1 && RecordSet.getString("dates").equals("")){%>
        	 			<img src='/images/BacoError.gif' align=absmiddle>
        	 <%}
        	 	if(mandtypes.indexOf("3_1")!=-1) needcheck+=",node_"+rowsum+"_needdate";
        	 %><%=RecordSet.getString("dates")%>
            
        	 </span>
        	<%}else{%>
        	<%=RecordSet.getString("dates")%>
            <%}%>
	    <input type='hidden' name='node_<%=rowsum%>_needdate' id='node_<%=rowsum%>_needdate' value="<%=RecordSet.getString("dates")%>">
	    </td>
            <td <%if(dsptypes.indexOf("4_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("4_1")!=-1&&canedit){
            	if(mandtypes.indexOf("4_1")!=-1){%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_fee' id='node_<%=rowsum%>_fee' value="<%=RecordSet.getString("fee")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_fee','node_<%=rowsum%>_feespan')>
            		<span id="node_<%=rowsum%>_feespan">
            		<%if(RecordSet.getString("fee").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		        <%}
        	 	needcheck+=",node_"+rowsum+"_fee";%>
		        </span>
		<%}else{%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_fee' id='node_<%=rowsum%>_fee' value="<%=RecordSet.getString("fee")%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("fee")%>
	    <input type='hidden' name='node_<%=rowsum%>_fee' id='node_<%=rowsum%>_fee' value="<%=RecordSet.getString("fee")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("5_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("5_1")!=-1&&canedit){
            	if(mandtypes.indexOf("5_1")!=-1){%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_remark' id='node_<%=rowsum%>_remark' value="<%=RecordSet.getString("remark")%>"  OnBlur=checkinput('node_<%=rowsum%>_remark','node_<%=rowsum%>_remarkspan')>
            		<span id="node_<%=rowsum%>_remarkspan">
            		<%if(RecordSet.getString("remark").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		        <%}
        	 	needcheck+=",node_"+rowsum+"_remark";%>
		        </span>
		<%}else{%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_remark' id='node_<%=rowsum%>_remark' value="<%=Util.toScreenToEdit(RecordSet.getString("remark"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <%=Util.toScreen(RecordSet.getString("remark"),user.getLanguage())%><input type='hidden' name='node_<%=rowsum%>_remark' id='node_<%=rowsum%>_remark' value="<%=RecordSet.getString("remark")%>">
	    <%}%>
	    </td>
        </tr>
            <%if(linecolor==0) linecolor=1;
          else linecolor=0; rowsum++;}%>
  </table>
  <input  type ='hidden' id=nodesnum name=nodesnum value=<%=rowsum%>>
  <!--<INPUT type="hidden" name="needcheck" value="<%=needcheck%>">-->
  <br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>
<script language=vbs>
sub onShowDate111(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub

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

sub getBDate(ismand)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("begindatespan").innerHtml= "<IMG src='/images/BacoError.gif' align=absMiddle>"
	else
		document.all("begindatespan").innerHtml= returndate
	end if
	document.all("begindate").value=returndate
end sub
sub getEDate(ismand)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("enddatespan").innerHtml= "<IMG src='/images/BacoError.gif' align=absMiddle>"
	else	
		document.all("enddatespan").innerHtml= returndate
	end if
	document.all("enddate").value=returndate
end sub

sub getBTIme(ismand)
	returndate = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:360px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("begintimespan").innerHtml= "<IMG src='/images/BacoError.gif' align=absMiddle>"
	else
		document.all("begintimespan").innerHtml= returndate
	end if
	document.all("begintime").value=returndate
end sub
sub getETime(ismand)
	returndate = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:360px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("endtimespan").innerHtml= "<IMG src='/images/BacoError.gif' align=absMiddle>"
	else	
		document.all("endtimespan").innerHtml= returndate
	end if
	document.all("endtime").value=returndate
end sub
sub onShowAssetType(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp?supassortmentid="&groupid&"&fromcapital=2")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml =  "<img src='/images/BacoError.gif' align=absmiddle>"
		inputname.value=""
		end if
	end if
end sub
sub onShowAssetCapital(spanname,inputname,inputnumber,inputnumberspan,inputcount)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1,2,3,4")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
        inputnumber.value=id(7)
        inputcount.value=id(7)
        inputnumberspan.innerHtml =  ""
		else
		spanname.innerHtml =  "<img src='/images/BacoError.gif' align=absmiddle>"
		inputname.value=""
		end if
	end if
end sub
sub onShowCptCapital(spanname,inputname,inputnumber,inputnumberspan,inputcount)
	mand = 1
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1,2,3,4")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
        inputnumber.value=id(7)
        inputcount.value=id(7)
        inputnumberspan.innerHtml =  ""
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
sub onShowDate(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub
</script>   
<script language=javascript>
groupid = <%=groupid%>;
rowindex = document.frmmain.nodesnum.value;
needcheck = "<%=needcheck%>";
document.all("needcheck").value = needcheck;
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
					sHtml = "<button class=Browser onClick='onShowCptCapital(node_"+rowindex+"_capitalidspan,node_"+rowindex+"_capitalid,node_"+rowindex+"_number,node_"+rowindex+"_numberspan,node_"+rowindex+"_count)'></button> " + 
        					"<span id=node_"+rowindex+"_capitalidspan>";
        				if(mandtypes.indexOf("1_1")!=-1){
        					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_capitalid";
        				}
        				sHtml +="</span> <input type='hidden' name='node_"+rowindex+"_capitalid' id='node_"+rowindex+"_capitalid'><input type='hidden' name='node_"+rowindex+"_count' id='node_"+rowindex+"_count'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("2_1")!=-1){
					if(mandtypes.indexOf("2_1")!=-1){ 
						sHtml = "<input class=Inputstyle type='text' class=Inputstyle  name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur=\"checkinput('node_"+rowindex+"_number','node_"+rowindex+"_numberspan');onchange=checkCount("+rowindex+")\"><span id='node_"+rowindex+"_numberspan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_number";
        				}else{
        					sHtml = "<input class=Inputstyle type='text' class=Inputstyle  name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur='checkCount("+rowindex+")'><span id='node_"+rowindex+"_numberspan'></span>";
        				}
	        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}else{
                    sHtml = "<input type='hidden' class=Inputstyle  name='node_"+rowindex+"_number'><span id='node_"+rowindex+"_numberspan'></span>";
	        	    oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv); 
                }
				break;
				
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("3_1")!=-1){
					sHtml = "<button class=Browser onClick='onBillCPTShowDate(node_"+rowindex+"_needdatespan,node_"+rowindex+"_needdate,"+mandtypes.indexOf("3_1")+")'></button> " + 
						"<span id=node_"+rowindex+"_needdatespan> ";
					if(mandtypes.indexOf("3_1")!=-1){
        					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_needdate";
        				}
        				sHtml+="</span>"
        				sHtml += "<input type='hidden' name='node_"+rowindex+"_needdate' id='node_"+rowindex+"_needdate'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
				
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("4_1")!=-1){
					if(mandtypes.indexOf("4_1")!=-1){
						sHtml = "<input class=Inputstyle type='text' class=Inputstyle   name='node_"+rowindex+"_fee'  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_fee','node_"+rowindex+"_feespan')><span id='node_"+rowindex+"_feespan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_fee";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input class=Inputstyle type='text'  class=Inputstyle  name='node_"+rowindex+"_fee'>";
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
						sHtml = "<input class=Inputstyle type='text' class=Inputstyle   name='node_"+rowindex+"_remark'  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_remark','node_"+rowindex+"_remarkspan')><span id='node_"+rowindex+"_remarkspan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_remark";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input class=Inputstyle type='text' class=Inputstyle   name='node_"+rowindex+"_remark'>";
        				}
        				
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
				
		}
	}
	document.all("needcheck").value = needcheck;
	rowindex = rowindex*1 +1;
	document.frmmain.nodesnum.value = rowindex ;
}

function checkCount(index){
    var stockamount = document.all("node_"+index+"_count").value;
    var useamount = document.all("node_"+index+"_number").value;
    if(eval(useamount)>eval(stockamount)){
        alert("<%=SystemEnv.getHtmlLabelName(15313,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
        document.all("node_"+index+"_number").value = stockamount;
    }
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
                        rowindex = rowindex*1 - 1;
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
</html>
