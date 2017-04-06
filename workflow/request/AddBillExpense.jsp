<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<form name="frmmain" method="post" action="BillExpenseOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
    <%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %>
<%
//获取明细表设置
WFNodeDtlFieldManager.resetParameter();
WFNodeDtlFieldManager.setNodeid(Util.getIntValue(""+nodeid));
WFNodeDtlFieldManager.setGroupid(0);
WFNodeDtlFieldManager.selectWfNodeDtlField();
String dtladd = WFNodeDtlFieldManager.getIsadd();
String dtledit = WFNodeDtlFieldManager.getIsedit();
String dtldelete = WFNodeDtlFieldManager.getIsdelete();
String dtldefault = WFNodeDtlFieldManager.getIsdefault();
String dtlneed = WFNodeDtlFieldManager.getIsneed();
%>
    <div>

    <table  class=form border=1 bordercolor='black'>
      <tbody>
      <TR class=Section>
          <TH><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH>
      </TR>
          <tr style="height:1px;" class="Spacing"> <td class="Line2" ></td></tr>
      <%
        //RecordSet.executeProc("bill_HrmFinance_SelectLoan",""+userid);
        //RecordSet.next();
        //String loanamount=RecordSet.getString(1);
        RecordSet.executeSql("select sum(amount) from fnaloaninfo where organizationtype=3 and organizationid="+userid);
        RecordSet.next();
        double loanamount=Util.getDoubleValue(RecordSet.getString(1),0);        
      %>
      <tr>
        <td><%=SystemEnv.getHtmlLabelName(16271,user.getLanguage())%> <%=loanamount%></td>
      </tr>     <tr class="Spacing" style="height:1px;"> <td class="Line2" ></td></tr>
      </tbody>
    </table>
    </div>

    <script language=javascript>
        fieldorders = new Array() ;
        isedits = new Array() ;
        ismands = new Array() ;
    </script>

    <table class=form>
        <tr><td height=15></td></tr>
        <tr>
            <td>
            <%if(dtladd.equals("1")){%>
            <button type=button Class=BtnFlow type=button accessKey=A onclick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            <%}
            if(dtladd.equals("1") || dtldelete.equals("1")){%>
            <button type=button Class=BtnFlow type=button accessKey=E onclick="deleteRow1();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            <%}%>
            </td>
        </tr>
        <TR class=separator style="height:1px;">
            <TD class=line2></TD>
        </TR>
        <tr>
            <td>
            <%
            int colcount = 0 ;
            int colwidth = 0 ;
            fieldids.clear() ;
            fieldlabels.clear() ;
            fieldhtmltypes.clear() ;
            fieldtypes.clear() ;
            fieldnames.clear() ;
            fieldviewtypes.clear() ;

            RecordSet.executeProc("workflow_billfield_Select",formid+"");
            while(RecordSet.next()){
                String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
                if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示

                fieldids.add(Util.null2String(RecordSet.getString("id")));
                fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
                fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
                fieldtypes.add(Util.null2String(RecordSet.getString("type")));
                fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
                fieldviewtypes.add(theviewtype);
            }

            // 确定字段是否显示，是否可以编辑，是否必须输入
            isfieldids.clear() ;              //字段队列
            isviews.clear() ;              //字段是否显示队列
            isedits.clear() ;              //字段是否可以编辑队列
            ismands.clear() ;              //字段是否必须输入队列

            RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
            while(RecordSet.next()){
                String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                if( thefieldidindex == -1 ) continue ;
                String theisview = Util.null2String(RecordSet.getString("isview")) ;
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
                isedits.add(Util.null2String(RecordSet.getString("isedit")));
                ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
            }

            if( colcount != 0 ) colwidth = 95/colcount ;


    %>
            <table Class=liststyle id="oTable">
              <COLGROUP>
              <tr class=header>
                <td width="5%">&nbsp;</td>
   <%
            ArrayList viewfieldnames = new ArrayList() ;

            // 得到每个字段的信息并在页面显示

            int detailfieldcount = -1 ;
            //modify by xhheng @20050323 for TD 1703，组装明细部check串
            String needcheckdtl="";

            for(int i=0;i<fieldids.size();i++){         // 循环开始

                String fieldid=(String)fieldids.get(i);  //字段id
                String isview="0" ;    //字段是否显示
                String isedit="0" ;    //字段是否可以编辑
                String ismand="0" ;    //字段是否必须输入

                int isfieldidindex = isfieldids.indexOf(fieldid) ;
                if( isfieldidindex != -1 ) {
                    isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
                    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
                }
                if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环

                String fieldname = "" ;                         //字段数据库表中的字段名
                String fieldlable = "" ;                        //字段显示名
                int languageid = 0 ;

                fieldname=(String)fieldnames.get(i);
                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%"><%=fieldlable%></td>
                <script language=javascript>
                    <% if (fieldname.equals("relatedate")) { 
                      detailfieldcount++ ;  
                      if(ismand.equals("1")) needcheckdtl += ",relatedate_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 1 ;
                    <% } else if (fieldname.equals("feetypeid")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",feetypeid_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 2 ;
                    <% } else if (fieldname.equals("detailremark")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",detailremark_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 3 ;
                    <% } else if (fieldname.equals("accessory")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",accessory_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 4 ;
                    <% } else if (fieldname.equals("relatedcrm")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",relatedcrm_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 5 ;
                    <% } else if (fieldname.equals("relatedproject")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",relatedproject_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 6 ;
                    <% } else if (fieldname.equals("feesum")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",feesum_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 7 ;
                    <% } else if (fieldname.equals("realfeesum")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",realfeesum_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 8 ;
                    <% } else if (fieldname.equals("invoicenum")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",invoicenum_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 9 ;

					<% } else if (fieldname.equals("relaterequest")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",relaterequest_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 10 ;

                    <% } %>
                    isedits[<%=detailfieldcount%>] = <%=isedit%> ;
                    ismands[<%=detailfieldcount%>] = <%=ismand%> ;
                </script>
<%          }
%>
              </tr>


              <tr class=TOTAL style="FONT-WEIGHT: bold; COLOR: red">
                <td>合计</td>
<%          for(int i=0;i<viewfieldnames.size();i++){
                String thefieldname = (String)viewfieldnames.get(i) ;
%>
                <td <% if(thefieldname.equals("accessory")) {%> id=accessorycount
                    <% } else if(thefieldname.equals("feesum")) {%> id=expensecountspan<%}%>>&nbsp;
                </td>
<%          }
%>
              </tr>
            </table>
            </td>
        </tr>
    </table>
<!-- 单独写签字意见Start TD10404 -->
	<table class="ViewForm" >
	<colgroup>
	<col width="20%">
	<col width="80%">
	<tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
      <td class=field>
      <!-- modify by xhheng @20050308 for TD 1692 -->
         <%
         //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
        //add by cyril on 2008-09-30 for td:9014
 		boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid); 
 		String workflowPhrases[] = new String[RecordSet.getCounts()];
 		String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
 		int m = 0 ;
 		if (isSuccess) {
 			while (RecordSet.next()){
 				workflowPhrases[m] = Util.null2String(RecordSet.getString("phraseShort"));
 				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
 				m ++ ;
 			}
 		}
 		//end by cyril on 2008-09-30 for td:9014

if("1".equals(isFormSignature)){
		 int workflowRequestLogId=-1;
%>
		<jsp:include page="/workflow/request/WorkflowLoadSignature.jsp">
			<jsp:param name="workflowRequestLogId" value="<%=workflowRequestLogId%>" />
			<jsp:param name="isSignMustInput" value="<%=isSignMustInput%>" />
			<jsp:param name="formSignatureWidth" value="<%=formSignatureWidth%>" />
			<jsp:param name="formSignatureHeight" value="<%=formSignatureHeight%>" />
		</jsp:include>
<%
}else{
             if(workflowPhrases.length>0){
         %>
                <select class=inputstyle  id="phraseselect" name=phraseselect style="width:80%" onChange='onAddPhrase(this.value)'>
                <option value="">－－<%=SystemEnv.getHtmlLabelName(22409,user.getLanguage())%>－－</option>
                <%
                  for (int i= 0 ; i <workflowPhrases.length;i++) {
                    String workflowPhrase = workflowPhrases[i] ;
                    //这里把value改成内容
                %>
                    <option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
                <%}%>
                </select>

          <%}%>
				<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%>" value="">
              <textarea class=Inputstyle name=remark id="remark" rows=4 cols=40 style="width=80%;display:none" class=Inputstyle temptitle="<%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%>"  <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%>></textarea>
	  		   	<script defer>
	  		   	function funcremark_log(){
					CkeditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,CkeditorExt.NO_IMAGE,200);
				<%if(isSignMustInput.equals("1")){%>
					CkeditorExt.checkText("remarkSpan","remark");
				<%}%>
					CkeditorExt.toolbarExpand(false,"remark");
				}
	  		  	//if(ieVersion>=8) window.attachEvent("onload", funcremark_log());
	  		  	//else window.attachEvent("onload", funcremark_log);
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
	if(isSignMustInput.equals("1")){
%>
			  <img src="/images/BacoError.gif" align=absmiddle>
<%
	}
%>
              </span>
<%}%>

       </td>
    </tr>
	<tr  style="height:1px;"><td class=Line2 colSpan=2></td></tr>
    <%
         if("1".equals(isSignDoc_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids">
                <button type=button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"></span>
            </td>
          </tr>
          <tr  style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids">
                <button type=button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"></span>
            </td>
          </tr>
          <tr  style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
         if("1".equals(isannexupload_add)){
            int annexmainId=0;
             int annexsubId=0;
             int annexsecId=0;
             String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
             if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
                annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
                annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
                annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
              }
             int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
             if(annexmaxUploadImageSize<=0){
                annexmaxUploadImageSize = 5;
             }
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
            <td class=field>
          <%if(annexsecId<1){%>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(21418,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
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
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field-annexupload" >
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
              <input type=hidden name='annexmainId' value=<%=annexmainId%>>
              <input type=hidden name='annexsubId' value=<%=annexsubId%>>
              <input type=hidden name='annexsecId' value=<%=annexsecId%>>
          </td>
          </tr>
          <tr  style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}}%>
	</table>
<!-- 单独写签字意见End TD10404 -->
    <input type='hidden' id=nodesnum name=nodesnum value="0">
    <input type='hidden' id="indexnum" name="indexnum" value="0">
    <input type='hidden' id=rowneed name=rowneed value="<%=dtlneed %>">
</form>
<script language="JavaScript" src="/js/addRowBg.js" >
</script>

<script language=javascript>
var rowColor="" ;
rowindex = 0 ;
insertindex=0;
deleteindex=0;
deletearray = new Array() ;
thedeletelength=0;

function addRow()
{
	rowColor = getRowBg();
    oRow = oTable.insertRow(rowindex+1);
    curindex=parseInt($GetEle('nodesnum').value);

    for(j=0; j < fieldorders.length+1; j++) {
        oCell = oRow.insertCell(-1);
        oCell.style.height=24;
        oCell.style.background= rowColor;
        if( j == 0 ) {
            var oDiv = document.createElement("div");
            var sHtml = "<input type='checkbox' name='check_node' value='"+insertindex+"'>";
            oDiv.innerHTML = sHtml;
            oCell.appendChild(oDiv);
        } else {
            dsporder = fieldorders[j-1] ;
            isedit = isedits[j-1] ;
            ismand = ismands[j-1] ;

            if( isedit != 1 ) {
                var oDiv = document.createElement("div");
                var sHtml = "&nbsp;";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
            } else {
                switch (dsporder)  {
                    case 1 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button type=button class=Browser onclick='onBillShowDate(relatedatespan_"+insertindex+",relatedate_"+insertindex+","+ismand+")'></button>"+"<span id='relatedatespan_"+insertindex+"'>" ;
                        if(ismand == 1) sHtml += "<img src='/images/BacoError.gif' align=absmiddle>"; sHtml += "</span><input type=hidden id='relatedate_"+insertindex+"' name='relatedate_"+insertindex+"'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 2 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button type=button class=Browser onclick='onShowFeetype(\"feetypeidspan_"+insertindex+"\",\"feetypeid_"+insertindex+"\","+ismand+")'></button>"+"<span id='feetypeidspan_"+insertindex+"'>" ;
                        if(ismand == 1) sHtml += "<img src='/images/BacoError.gif' align=absmiddle>"; sHtml += "</span><input type=hidden id='feetypeid_"+insertindex+"' name='feetypeid_"+insertindex+"'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 3 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85% name='detailremark_"+insertindex+"'";
                        if(ismand == 1)
                            sHtml += "onchange='checkinput1(detailremark_"+insertindex+",detailremarkspan_"+insertindex+")'";
                        sHtml += ">" ;
                        if(ismand == 1)
                            sHtml += "<span id='detailremarkspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 4 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='accessory_"+insertindex+"' name='accessory_"+insertindex+"' maxlength='10' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(accessory_"+ insertindex+",accessoryspan_"+insertindex+");" ;
                        sHtml += "changeaccessory();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='accessoryspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 5 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button type=button class=browser onclick='onShowCustomer(\"relatedcrmspan_"+insertindex+"\",\"relatedcrm_"+insertindex+"\","+ismand+")'></button>"+"<span id='relatedcrmspan_"+insertindex+"'>";
                        if(ismand == 1)
                            sHtml += "<img src='/images/BacoError.gif' align=absmiddle>" ;
                        sHtml += "</span><input type=hidden id='relatedcrm_"+insertindex+"' name='relatedcrm_"+insertindex+"'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 6 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button type=button class=browser onclick='onShowProject(\"relatedprojectspan_"+insertindex+"\",\"relatedproject_"+insertindex+"\","+ismand+")'></button>"+"<span id='relatedprojectspan_"+insertindex+"'>";
                        if(ismand == 1)
                            sHtml += "<img src='/images/BacoError.gif' align=absmiddle>" ;
                        sHtml += "</span><input type=hidden id='relatedproject_"+insertindex+"' name='relatedproject_"+insertindex+"'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 7 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<input type='text' class=inputstyle style=width:85%  id='feesum_"+insertindex+"' name='feesum_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(feesum_"+insertindex+",feesumspan_"+insertindex+");" ;
                        sHtml += "changenumber();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='feesumspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 8 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<input type='text' class=inputstyle style=width:85%  id='realfeesum_"+insertindex+"' name='realfeesum_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(realfeesum_"+ insertindex+",realfeesumspan_"+insertindex+");" ;
                        sHtml += "'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='realfeesumspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 9 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<input type='text' class=inputstyle style=width:85%  id='invoicenum_"+insertindex+"' name='invoicenum_"+insertindex+"' " ;
                        if(ismand == 1)
                            sHtml += "onchange='checkinput1(invoicenum_"+insertindex+",invoicenumspan_"+insertindex+")'";
                        sHtml += ">" ;
                        if(ismand == 1)
                            sHtml += "<span id='invoicenumspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
					case 10 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button type=button class=browser onclick='onShowRequest(\"relaterequestspan_"+insertindex+"\",\"relaterequest_"+insertindex+"\","+ismand+")'></button>"+"<span id='relaterequestspan_"+insertindex+"'>";
                        if(ismand == 1)
                            sHtml += "<img src='/images/BacoError.gif' align=absmiddle>" ;
                        sHtml += "</span><input type=hidden id='relaterequest_"+insertindex+"' name='relaterequest_"+insertindex+"'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                }
            }
        }
    }
    if ("<%=needcheckdtl%>" != ""){
        $GetEle("needcheck").value += "<%=needcheckdtl%>";
    }
    insertindex = insertindex*1 +1;
    rowindex = curindex*1 +1;
    $GetEle("nodesnum").value = rowindex;
    $GetEle("indexnum").value = insertindex;

}
<%
if(dtldefault.equals("1"))
{
%>
addRow();
<%	
}
%>
function changeaccessory() {
    countaccessory = 0 ;
    for(j=0;j<insertindex;j++) {
        hasdelete = false ;
        for(k=0;k<deletearray.length;k++){
            if(j==deletearray[k])
            hasdelete=true;
        }
        if(hasdelete) continue ;
        countaccessory += eval(toInt($GetEle("accessory_"+j).value,0)) ;
    }
    accessorycount.innerHTML = countaccessory ;
}

function changenumber(){

    count_total = 0 ;

    for(j=0;j<insertindex;j++) {
        hasdelete = false ;
        for(k=0;k<deletearray.length;k++){
            if(j==deletearray[k])
            hasdelete=true;
        }
        if(hasdelete) continue ;
        count_total+= eval(toFloat($GetEle("feesum_"+j).value,0)) ;
    }
    expensecountspan.innerHTML = count_total.toFixed(3);


}

function toFloat(str , def) {
    if(isNaN(parseFloat(str))) return def ;
    else return str ;
}

function toInt(str , def) {
    if(isNaN(parseInt(str))) return def ;
    else return str ;
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
            var therowindex = 0 ;
            var rowsum1 = 0;
            rowindex=parseInt($GetEle("nodesnum").value);
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node')
                    rowsum1 += 1;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        therowindex = document.forms[0].elements[i].value ;
                        deletearray[thedeletelength] = therowindex ;
                        thedeletelength ++ ;
                        oTable.deleteRow(rowsum1);
                        rowindex--;
                    }
                    rowsum1 -=1;
                }

            }

            changeaccessory() ;
            changenumber() ;
            $GetEle("frmmain").nodesnum.value = rowindex ;
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}
</script>
<script type="text/javascript">
function onShowCustomer(spanname,inputname,ismand) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp", "", "dialogWidth=550px;dialogHeight=550px");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			
			$GetEle(spanname).innerHTML = "<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+wuiUtil.getJsonValueByIndex(id, 0)+"'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			if (ismand == 1) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle(inputname).value = "";
		}
	}
}

function onShowFeetype(spanname,inputname,ismand) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='1'", "", "dialogWidth=550px;dialogHeight=550px");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			
			$GetEle(spanname).innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			if (ismand == 1) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle(inputname).value = "";
		}
	}
}

function onShowProject(spanname,inputname,ismand) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp", "", "dialogWidth=550px;dialogHeight=550px");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			
			$GetEle(spanname).innerHTML = "<a href='/proj/data/ViewProject.jsp?ProjID="+wuiUtil.getJsonValueByIndex(id, 0)+"'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			if (ismand == 1) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle(inputname).value = "";
		}
	}
}

function onShowRequest(spanname,inputname,ismand) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1", "", "dialogWidth=550px;dialogHeight=550px");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			
			$GetEle(spanname).innerHTML = "<a href='/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+wuiUtil.getJsonValueByIndex(id, 0)+"'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			if (ismand == 1) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle(inputname).value = "";
		}
	}
}

</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>