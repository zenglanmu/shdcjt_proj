<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo"/>
<jsp:useBean id="SearchNumberRecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<form name="frmmain" method="post" action="BillCptFetchOperation.jsp" enctype="multipart/form-data">
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

<%!
//页面过大抽取方法
private String getAddAndDelButton(User user, String isaffirmancebody, String reEditbody, String dtladd, String dtldelete) {
	StringBuffer sf = new StringBuffer("<table class=liststyle cellspacing=1 ><tr><td>");

	if(!isaffirmancebody.equals("1")|| reEditbody.equals("1")) {
		if(dtladd.equals("1")){
			sf.append("<BUTTON Class=BtnFlow type=button accessKey=A onclick=\"addRow();\"><U>A</U>-");
			sf.append(SystemEnv.getHtmlLabelName(611,user.getLanguage()));
			sf.append("</BUTTON>");
		}
		if(dtladd.equals("1") || dtldelete.equals("1")){
			sf.append("<BUTTON Class=BtnFlow type=button accessKey=E onclick=\"deleteRow1();\"><U>E</U>-");
			sf.append(SystemEnv.getHtmlLabelName(91,user.getLanguage()));
			sf.append("</BUTTON>");
		}
	}
	sf.append("</td></tr></table>");
	
	return sf.toString();
	
}
%>

<%
	
String totalamountsum = "" ;
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
	if( !theviewtype.equals("1") ){
		if("totalamount".equals(RecordSet.getString("fieldname"))){
			totalamountsum = "field"+RecordSet.getString("id");
		}
		continue ;
	}    // 如果是单据的主表字段,不显示
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
int viewCount = 0; 
for(int ii=0;ii<fieldids.size();ii++){
    String isview1=(String)isviews.get(ii);
    if(isview1.equals("1")) viewCount++;
}
if(viewCount>0){
%>
<%=getAddAndDelButton(user, isaffirmancebody, reEditbody, dtladd, dtldelete) %>
<%}%>
  <table class=liststyle cellspacing=1   cols=9 id="oTable">
      	<COLGROUP>
    	
    	<tr class=header> 
		<% if((!isaffirmancebody.equals("1")|| reEditbody.equals("1"))  ) { %>
	    <%if(viewCount>0){%><td width="5%"><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td><%}%>
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
    	  
            <%if(viewCount>0){%><td <%if(isview.equals("0")){%> style="display:none" <%}%>><%=Util.toScreen(fieldlable,user.getLanguage())%></td><%}%>
<%}%>
            </tr>
            
    	   
            <%
            
	           int linecolor=0;  
	RecordSet.executeProc("bill_CptFetchDetail_Select",billid+"");
	int rowsum=0;
	while(RecordSet.next()){
            %>
            <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> > 

            <% if( (!isaffirmancebody.equals("1")|| reEditbody.equals("1")) ) { %>
            <%if(viewCount>0){%><td>
            <input type='checkbox' name='check_node' id='check_node' isexist="1" value="<%=RecordSet.getString("id")%>" <%if(!dtldelete.equals("1")){%>disabled<%}%>>
			<input type="hidden" name='check_node_val' value='<%=rowsum%>'>
            </td><%}%>
            <%}else{%>
            	&nbsp;
          	<%}%>
			
            
            <td <%if(dsptypes.indexOf("1_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("1_1")!=-1&&canedit){%>
            <button class=Browser onClick='onShowAssetType(node_<%=rowsum%>_cptidspan,node_<%=rowsum%>_cptid)'></button>
            <span id=node_<%=rowsum%>_cptidspan>
            
        	 <% if(mandtypes.indexOf("1_1")!=-1){
        	 		 if(RecordSet.getInt("cptid")==0) 
        	 %>
        	 			<img src='/images/BacoError.gif' align=absmiddle>
        	 <%
        	 	needcheck+=",node_"+rowsum+"_cptid";
        	 }%>
        	 <%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cptid")),user.getLanguage())%>
         	 </span>
        	<%}else{%>
        	<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cptid")),user.getLanguage())%>
         <%}%>
            <input type='hidden' name='node_<%=rowsum%>_cptid' id='node_<%=rowsum%>_cptid' value="<%=(RecordSet.getInt("cptid")>0?RecordSet.getString("cptid"):"")%>">
	    </td>

		<td <%if(dsptypes.indexOf("2_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("2_1")!=-1&&canedit){%>
			<button class=Browser onClick='onShowCptCapital(node_<%=rowsum%>_capitalidspan,node_<%=rowsum%>_capitalid,node_<%=rowsum%>_capitalcount,node_<%=rowsum%>_number,node_<%=rowsum%>_numberspan,"node_<%=rowsum%>")'></button>
            <span id="node_<%=rowsum%>_capitalidspan">
            
        	 <% if(mandtypes.indexOf("2_1")!=-1){
        	 		if(RecordSet.getInt("capitalid")==0)
        	 %>
        	 			<img src='/images/BacoError.gif' align=absmiddle>
        	 <%
        	 	needcheck+=",node_"+rowsum+"_capitalid";
        	 }%>
        	 <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%></a>
         	 </span>
        	<%}else{%>
        	<a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%></a>
         <%}%>
            <input type='hidden' name='node_<%=rowsum%>_capitalid' id='node_<%=rowsum%>_capitalid' value="<%=(RecordSet.getInt("capitalid")>0?RecordSet.getString("capitalid"):"")%>">
            <%
             String tempStockAmount = "";
             SearchNumberRecordSet.executeSql("select capitalnum from CptCapital where id="+RecordSet.getString("capitalid"));
             if(SearchNumberRecordSet.next()) tempStockAmount = SearchNumberRecordSet.getString("capitalnum");
             %>
            <input type='hidden' name='node_<%=rowsum%>_capitalcount' id='node_<%=rowsum%>_capitalcount' value="<%=tempStockAmount%>">
	    </td>

            <td <%if(dsptypes.indexOf("3_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("3_1")!=-1&&canedit){
            	if(mandtypes.indexOf("3_1")!=-1){%>
            		<input type='text' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>"  onKeyPress='ItemNum_KeyPress()' onBlur="checkinput('node_<%=rowsum%>_number','node_<%=rowsum%>_numberspan');checkCount(<%=rowsum%>);changeamountsum('node_<%=rowsum%>')">
            		<span id="node_<%=rowsum%>_numberspan">
            		<%if(RecordSet.getString("number_n").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		         <%
        	 	}needcheck+=",node_"+rowsum+"_number";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>" onKeyPress='ItemNum_KeyPress()' onBlur='checkCount(<%=rowsum%>);changeamountsum("node_<%=rowsum%>")'>
            		<span id="node_<%=rowsum%>_numberspan"></span>
            	<%}%>
	    <%}else{%>
	    	<span id="node_<%=rowsum%>_numberspan"><%=RecordSet.getString("number_n")%></span>
	    <input type='hidden' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>">
	    
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("4_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("4_1")!=-1&&canedit){
            	if(mandtypes.indexOf("4_1")!=-1){%>
            		<input type='text' name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_unitprice','node_<%=rowsum%>_unitpricespan');changeamountsum('node_<%=rowsum%>')>
            		<span id="node_<%=rowsum%>_unitpricespan">
            		<%if(RecordSet.getString("unitprice").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_unitprice";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>" onBlur="changeamountsum('node_<%=rowsum%>')">
            	<%}%>
	    <%}else{%>
	    <span id="node_<%=rowsum%>_unitpricespan"><%=RecordSet.getString("unitprice")%></span>
	    <input type='hidden' name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("5_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("5_1")!=-1&&canedit){
            	if(mandtypes.indexOf("5_1")!=-1){%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_amount','node_<%=rowsum%>_amountspan')>
            		<span id="node_<%=rowsum%>_amountspan">
            		<%if(RecordSet.getString("amount").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_amount";
        	 	%>
		        </span>
		<%}else{%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>">
            	<%}%>
	    <%}else{%>
	    <span id="node_<%=rowsum%>_amountspan"><%=RecordSet.getString("amount")%></span>
	    <input type='hidden' name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("6_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("6_1")!=-1&&canedit){%>
            <button class=Browser onClick='onBillCPTShowDate(node_<%=rowsum%>_needdatespan,node_<%=rowsum%>_needdate,<%=mandtypes.indexOf("6_1")%>)'></button>
            <span id=node_<%=rowsum%>_needdatespan>
            
        	 <% if(mandtypes.indexOf("6_1")!=-1){
        	 			if(RecordSet.getString("needdate").equals(""))
        	 %>
        	 			<img src='/images/BacoError.gif' align=absmiddle>
        	 <%
        	 	needcheck+=",node_"+rowsum+"_needdate";
        	 }%><%=RecordSet.getString("needdate")%>
            
        	 </span>
        	<%}else{%>
        	<%=RecordSet.getString("needdate")%>
            <%}%>
	    <input type='hidden' name='node_<%=rowsum%>_needdate' id='node_<%=rowsum%>_needdate' value="<%=RecordSet.getString("needdate")%>">
	    </td>
            <td <%if(dsptypes.indexOf("7_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("7_1")!=-1&&canedit){
            	if(mandtypes.indexOf("7_1")!=-1){%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=RecordSet.getString("purpose")%>"  OnBlur=checkinput('node_<%=rowsum%>_purpose','node_<%=rowsum%>_purposespan')>
            		<span id="node_<%=rowsum%>_purposespan">
            		<%if(RecordSet.getString("purpose").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_purpose";
        	 	%>
		        </span>
		<%}else{%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=Util.toScreenToEdit(RecordSet.getString("purpose"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <%=Util.toScreen(RecordSet.getString("purpose"),user.getLanguage())%><input type='hidden' name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=RecordSet.getString("purpose")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("8_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("8_1")!=-1&&canedit){
            	if(mandtypes.indexOf("8_1")!=-1){%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=RecordSet.getString("cptdesc")%>"  OnBlur=checkinput('node_<%=rowsum%>_cptdesc','node_<%=rowsum%>_cptdescspan')>
            		<span id="node_<%=rowsum%>_cptdescspan">
            		<%if(RecordSet.getString("cptdesc").equals("")){%>
            		<img src="/images/BacoError.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_cptdesc";
        	 	%>
		        </span>
		<%}else{%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=Util.toScreenToEdit(RecordSet.getString("cptdesc"),user.getLanguage())%>">
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
  <input  type ='hidden' id=delids name=delids value="">
  <br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>

</form>
 <!--页面过大-->
<jsp:include page="ManageBillCptFetch2.jsp" flush="true">
    <jsp:param name="mandtypes" value="<%=mandtypes%>" />
    <jsp:param name="groupid" value="<%=groupid%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
    <jsp:param name="dsptypes" value="<%=dsptypes%>" />
    <jsp:param name="edittypes" value="<%=edittypes%>" />
    <jsp:param name="newenddate" value="<%=newenddate%>" />
    <jsp:param name="newfromdate" value="<%=newfromdate%>" />
    <jsp:param name="totalamountsum" value="<%=totalamountsum%>" />
</jsp:include>
</body>
</html>
