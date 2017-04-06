<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<form name="frmmain" method="post" action="FnaBudgetChgApplyOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
    <%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %>



    <script language=javascript>
        fieldorders = new Array() ;
        isedits = new Array() ;
        ismands = new Array() ;
        var organizationidismand=0;
        var organizationidisedit=0;
    </script>
    <script type='text/javascript' src='/dwr/interface/BudgetHandler.js'></script>
    <script type='text/javascript' src='/dwr/engine.js'></script>
    <script type='text/javascript' src='/dwr/util.js'></script>
    <table class=form>
        <tr><td height=15></td></tr>
        <tr>
            <td>
            <BUTTON Class=BtnFlow type=button accessKey=A onclick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            <BUTTON Class=BtnFlow type=button accessKey=E onclick="deleteRow1();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            </td>
        </tr>
        <TR class=separator>
            <TD class=line2></TD>
        </TR>
        <tr>
            <td>
            <%
                String uid = "" + user.getUID();

                String uname = ResourceComInfo.getLastname(uid);
                String udept = ResourceComInfo.getDepartmentID(uid);
                String udeptname = DepartmentComInfo.getDepartmentname(udept);
                String usubcom = DepartmentComInfo.getSubcompanyid1(udept);
                weaver.hrm.company.SubCompanyComInfo scci = new weaver.hrm.company.SubCompanyComInfo();
                String usubcomname = scci.getSubCompanyname(usubcom);

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
                String theisedit = Util.null2String(RecordSet.getString("isedit")) ;
                String theismandatory = Util.null2String(RecordSet.getString("ismandatory")) ;
//                String thefieldname=(String)fieldnames.get(thefieldidindex);
//                if(thefieldname.equals("organizationtype")||thefieldname.equals("organizationid")||thefieldname.equals("budgetperiod")||thefieldname.equals("subject")){
//                    theisview="1";
//                    theisedit="1";
//                    theismandatory="1";
//                }
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
                isedits.add(theisedit);
                ismands.add(theismandatory);
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
                    <% if (fieldname.equals("organizationid")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",organizationid_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 1 ;
                      organizationidismand=<%=ismand%>;
                      organizationidisedit=<%=isedit%>;
                    <% } else if (fieldname.equals("subject")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",subject_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 2 ;
                    <% } else if (fieldname.equals("budgetperiod")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",subject_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 3 ;
                    <% }  else if (fieldname.equals("relatedprj")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",relatedprj_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 4 ;
                    <% } else if (fieldname.equals("relatedcrm")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",relatedcrm_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 5 ;
                    <% } else if (fieldname.equals("description")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",description_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 6 ;
                    <% } else if (fieldname.equals("oldamount")) {
                      detailfieldcount++ ;%>
                      fieldorders[<%=detailfieldcount%>] = 7 ;
                    <% } else if (fieldname.equals("applyamount")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",applyamount_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 8 ;
                    <% } else if (fieldname.equals("amount")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",amount_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 9 ;
                    <% } else if (fieldname.equals("changeamount")) {
                      detailfieldcount++ ;%>
                      fieldorders[<%=detailfieldcount%>] = 10 ;
                    <% } else if (fieldname.equals("organizationtype")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",organizationtype_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 11 ;
                    <% }%>
                    isedits[<%=detailfieldcount%>] = <%=isedit%> ;
                    ismands[<%=detailfieldcount%>] = <%=ismand%> ;
                </script>
<%          }
%>
              </tr>

            </table>
            </td>
        </tr>
    </table>

    <input type='hidden' id=nodesnum name=nodesnum>
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
              <textarea class=Inputstyle name=remark  id=remark rows=4 cols=40 style="width=80%;display:none" class=Inputstyle temptitle="<%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%>"  <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%>></textarea>
	  		   	<script defer>
	  		   	function funcremark_log(){
					FCKEditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
				<%if(isSignMustInput.equals("1")){%>
					FCKEditorExt.checkText("remarkSpan","remark");
				<%}%>
					FCKEditorExt.toolbarExpand(false,"remark");
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
	<tr><td class=Line2 colSpan=2></td></tr>
    <%
         if("1".equals(isSignDoc_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
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
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}}%>
	</table>
<!-- 单独写签字意见End TD10404 -->
</form>
<script language="JavaScript" src="/js/addRowBg.js" >
</script>



<script language=javascript>
document.all("needcheck").value+=",<%=needcheck%>";
var rowColor="" ;
rowindex = 0 ;
insertindex=0;
deleteindex=0;
deletearray = new Array() ;
thedeletelength=0;

function addRow()
{rowColor = getRowBg();
    oRow = oTable.insertRow(rowindex+1);

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

                switch (dsporder) {
                    case 1 :
                         var oDiv = document.createElement("div");
                        var sHtml = "<span id='organizationspan_"+insertindex+"'>" ;
                         sHtml += "<a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=udept%>'><%=udeptname%></a>"; sHtml += "</span><input type=hidden id='organizationid_"+insertindex+"' name='organizationid_"+insertindex+"' value='<%=udept%>'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 7 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='oldamountspan_"+insertindex+"'></span><input type='hidden' id='oldamount_"+insertindex+"' name='oldamount_"+insertindex+"' value=''>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 10 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='changeamountspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 11 :
                         var oDiv = document.createElement("div");
                        var sHtml = "<input type=hidden id='organizationtype_"+insertindex+"' name='organizationtype_"+insertindex+"' value=3><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    default:
                        var oDiv = document.createElement("div");
                        var sHtml = "&nbsp;";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                }
            } else {
                switch (dsporder)  {
                    case 1 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button type=button  class=Browser onclick='onShowOrganization(\"organizationspan_"+insertindex+"\",\"organizationid_"+insertindex+"\","+ismand+","+insertindex+")'></button>"+"<span id='organizationspan_"+insertindex+"'>" ;        
						sHtml += "<a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=udept%>'><%=udeptname%></a>"; sHtml += "</span><input type=hidden id='organizationid_"+insertindex+"' name='organizationid_"+insertindex+"' value='<%=udept%>'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 2 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button class=Browser onclick='onShowSubject(subjectspan_"+insertindex+",subject_"+insertindex+","+ismand+","+insertindex+")'></button>"+"<span id='subjectspan_"+insertindex+"'>" ;
                        if(ismand == 1) sHtml += "<img src='/images/BacoError.gif' align=absmiddle>"; sHtml += "</span><input type=hidden id='subject_"+insertindex+"' name='subject_"+insertindex+"'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 3 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button class=Browser onclick='onShowWFDate(budgetperiodspan_"+insertindex+",budgetperiod_"+insertindex+","+ismand+","+insertindex+")'></button>"+"<span id='budgetperiodspan_"+insertindex+"'>" ;
                        if(ismand == 1) sHtml += "<img src='/images/BacoError.gif' align=absmiddle>"; sHtml += "</span><input type=hidden id='budgetperiod_"+insertindex+"' name='budgetperiod_"+insertindex+"'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 4 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button class=Browser onclick='onShowPrj(relatedprjspan_"+insertindex+",relatedprj_"+insertindex+","+ismand+","+insertindex+")'></button>"+"<span id='relatedprjspan_"+insertindex+"'>" ;
                        if(ismand == 1) sHtml += "<img src='/images/BacoError.gif' align=absmiddle>"; sHtml += "</span><input type=hidden id='relatedprj_"+insertindex+"' name='relatedprj_"+insertindex+"'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 5 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button class=Browser onclick='onShowCrm(relatedcrmspan_"+insertindex+",relatedcrm_"+insertindex+","+ismand+","+insertindex+")'></button>"+"<span id='relatedcrmspan_"+insertindex+"'>" ;
                        if(ismand == 1) sHtml += "<img src='/images/BacoError.gif' align=absmiddle>"; sHtml += "</span><input type=hidden id='relatedcrm_"+insertindex+"' name='relatedcrm_"+insertindex+"'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 6 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='description_"+insertindex+"' name='description_"+insertindex+"'  onBlur='" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(description_"+ insertindex+",descriptionspan_"+insertindex+");" ;
                        sHtml += "'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='descriptionspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 7 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='oldamountspan_"+insertindex+"'></span><input type=hidden id='oldamount_"+insertindex+"' name='oldamount_"+insertindex+"' value=''>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 8 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:99%  id='applyamount_"+insertindex+"' name='applyamount_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(applyamount_"+ insertindex+",applyamountspan_"+insertindex+");" ;
                        sHtml += "changeapplynumber("+ insertindex+");'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='applyamountspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 9 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:99%  id='amount_"+insertindex+"' name='amount_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(amount_"+ insertindex+",amountspan_"+insertindex+");" ;
                        sHtml += "changenumber("+ insertindex+");'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='amountspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 10 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='changeamountspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 11 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<select id='organizationtype_"+insertindex+"' name='organizationtype_"+insertindex+"' onchange='clearSpan("+insertindex+")'><option value=2 default><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><option value=1><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><option value=3><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option></select>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
               }


            }
        }
    }
    if ("<%=needcheckdtl%>" != ""){
        document.all("needcheck").value += "<%=needcheckdtl%>";
    }
    insertindex = insertindex*1 +1;
    rowindex = rowindex*1 +1;
    document.frmmain.nodesnum.value = insertindex ;

}

function changenumber(index){
    if(document.all("amount_"+index)&&document.all("oldamountspan_"+index)){
   	//TD12002 审批预算值大于0时预算差额以审批预算为准计算
	var aproveamount = Number(eval(toFloat(document.all("amount_"+index).value,0)));
    if(aproveamount > 0) {
		changeval=eval(toFloat(document.all("amount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    } else {
    	changeapplynumber(index);
    	return;
    }
    //changeval=eval(toFloat(document.all("amount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    if(document.all("changeamountspan_"+index)) document.all("changeamountspan_"+index).innerHTML=changeval.toFixed(3);
    }
}

function changeapplynumber(index){
    if(document.all("applyamount_"+index)&&document.all("oldamountspan_"+index)){
	//TD12002 审批预算值大于0时预算差额以审批预算为准计算
	var aproveamount = Number("0");
	if(document.all("amount_"+index)) {
		aproveamount = Number(eval(toFloat(document.all("amount_"+index).value,0)));
	}
    if(aproveamount > 0) {
    	changenumber(index);
    	return;
    } else {
    	changeval=eval(toFloat(document.all("applyamount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    }
    //changeval=eval(toFloat(document.all("applyamount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    if(document.all("changeamountspan_"+index)) document.all("changeamountspan_"+index).innerHTML=changeval.toFixed(3);
    }
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
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}
function clearSpan(index) {
    if(document.all("organizationspan_"+index)!=null&&organizationidisedit==1){
    if(organizationidismand==1){
    document.all("organizationspan_"+index).innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
    }else{
        document.all("organizationspan_"+index).innerHTML = "";
    }    
    document.all("organizationspan_"+index).parentElement.parentElement.style.background=document.all("organizationtype_"+index).parentElement.parentElement.style.background;
    if (document.all("organizationid_" + index) != null) document.all("organizationid_"+index).value = "";
    if(document.all("oldamountspan_"+index)!=null)
    document.all("oldamountspan_"+index).innerHTML = "";
    }
}
function clearaumountspan(index){
    if(document.all("oldamountspan_"+index)!=null)
    document.all("oldamountspan_"+index).innerHTML = "";
    changenumber(index);
    changeapplynumber(index);
}
function onShowOrganization(spanname, inputname, ismand, index) {
    if(document.all("organizationtype_" + index)!=null){
    if (document.all("organizationtype_" + index).value == "3")
        return onShowHR(spanname, inputname, ismand, index);
    else if (document.all("organizationtype_" + index).value == "2")
        return onShowDept(spanname, inputname, ismand, index);
    else if (document.all("organizationtype_" + index).value == "1")
        return onShowSubcom(spanname, inputname, ismand, index);
    else
        return null;
    }else{
        return null;
    }
}
function onShowHR(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0"&&jsid[0] != "") {
            spanname.innerHTML = "<A href='javaScript:openhrm("+jsid[0]+");' onclick='pointerXY(event);'>"+jsid[1]+"</A>";
            inputname.value = jsid[0];
            if(jsid[0]!=<%=uid%>)
            spanname.parentElement.parentElement.style.background='#ff9999';
            else
            if(document.getElementById("organizationtype_"+index))
            spanname.parentElement.parentElement.style.background=document.getElementById("organizationtype_"+index).parentElement.parentElement.style.background;
            else
            spanname.parentElement.parentElement.style.background="";
            if(document.all("subject_" + index)!=null&&document.all("subject_" + index).value != "")
            getBudget(index,3, jsid[0],document.all("subject_" + index).value);
        } else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
            clearaumountspan(index);
        }
    }
}

function onShowDept(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+inputname.value);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0") {
            spanname.innerHTML = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+jsid[0]+"'>"+jsid[1]+"</A>";
            inputname.value = jsid[0];
            if(jsid[0]!=<%=udept%>)
            spanname.parentElement.parentElement.style.background='#ff9999';
            else
            if(document.getElementById("organizationtype_"+index))
            spanname.parentElement.parentElement.style.background=document.getElementById("organizationtype_"+index).parentElement.parentElement.style.background;
            else
            spanname.parentElement.parentElement.style.background="";
            if(document.all("subject_" + index)!=null&&document.all("subject_" + index).value != "")
            getBudget(index,2, jsid[0],document.all("subject_" + index).value);
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
            clearaumountspan(index);
        }
    }

}
function onShowSubcom(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp");
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0") {
            spanname.innerHTML = "<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+jsid[0]+"'>"+jsid[1]+"</A>";
            inputname.value = jsid[0];
            if(jsid[0]!=<%=usubcom%>)
            spanname.parentElement.parentElement.style.background='#ff9999';
            else
            if(document.getElementById("organizationtype_"+index))
            spanname.parentElement.parentElement.style.background=document.getElementById("organizationtype_"+index).parentElement.parentElement.style.background;
            else
            spanname.parentElement.parentElement.style.background="";
            if(document.all("subject_" + index)!=null&&document.all("subject_" + index).value != "")
            getBudget(index,1, jsid[0],document.all("subject_" + index).value);
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
            clearaumountspan(index);
        }
    }
}



function onShowSubject(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp");
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0"){	
			//TD31699 lv start
			if(checkSameSubject(jsid[0],document.all("budgetperiod_" + index).value, ismand, index)){
				alert("【"+jsid[1]+"】<%=SystemEnv.getHtmlNoteName(98,user.getLanguage())%>");
				spanname.innerHTML = "";
				inputname.value = "";
				document.all("budgetperiod_" + index).value = "";
				document.getElementById("budgetperiodspan_" + index).innerHTML ="";
				return;
			}
			//TD31699 lv end
			spanname.innerHTML = jsid[1];
            inputname.value = jsid[0];
            changeSubject(index,jsid[0]);
            return ;
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
        }
    }
    clearaumountspan(index);
}
//TD31699 lv 检查在当前预算是否已经存在 
function checkSameSubject(currentSubjectValue,currentBudgetPeriodValue, ismand, index){
	var result = false;
	var nodesnum = document.frmmain.nodesnum.value;
	var maxIndex = 0;
	if(nodesnum!=null && nodesnum!='' ){
		maxIndex = parseInt(nodesnum);
	}
	if(document.all("budgetperiod_" + index)){
		currentBudgetPeriodValue = currentBudgetPeriodValue.substring(0,7);
		//alert("index="+index+"\n"+"currentSubjectValue="+currentSubjectValue+"\n"+"currentBudgetPeriodValue="+currentBudgetPeriodValue);
		for(var i=0;i<maxIndex;i++){
			if(document.all("subject_" + i) && i!=maxIndex ){			
				var indexSubjectValue = document.all("subject_" + i).value;
				var indexBudgetPeriodValue = document.all("budgetperiod_" + i).value;
				indexBudgetPeriodValue = indexBudgetPeriodValue.substring(0,7);
				//alert("i="+i+"\n"+"indexSubjectValue="+indexSubjectValue+"\n"+"indexBudgetPeriodValue="+indexBudgetPeriodValue);
				if(currentBudgetPeriodValue == indexBudgetPeriodValue && currentSubjectValue == indexSubjectValue){
					result = true;
					break;
				}
					
			}
		}
	}
	//alert(result);
	return result;
}
function onShowPrj(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0"){
            spanname.innerHTML = "<A href='/proj/data/ViewProject.jsp?isrequest=1&ProjID="+jsid[0]+"'>"+jsid[1]+"</A>";
            inputname.value = jsid[0];
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
        }
    }
}
function onShowCrm(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0"){
            spanname.innerHTML = "<A href='/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID="+jsid[0]+"'>"+jsid[1]+"</A>";
            inputname.value = jsid[0];
            changePeriod(index);
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
        }
    }
}
function onShowWFDate(spanname, inputname, ismand, index) {
	var oncleaingFun = function(){
		if (ismand == 1)
			spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		else
			spanname.innerHTML = "";
        inputname.value="";
        clearaumountspan(index);
	}
	WdatePicker({el:spanname,onpicked:function(dp){
		var returndate = dp.cal.getDateStr();
		//TD31699 lv start
		var indexSubject =document.all("subject_" + index);
		var indexSubjectValue = indexSubject.value;
		var subjectName = document.getElementById("subjectspan_" + index).innerHTML;
		if(checkSameSubject(indexSubjectValue,returndate, ismand, index)){
			alert("【"+subjectName+"】<%=SystemEnv.getHtmlNoteName(98,user.getLanguage())%>");
			spanname.innerHTML = "";
			inputname.value = "";
			document.all("subject_" + index).value = "";
			document.getElementById("subjectspan_" + index).innerHTML ="";
			return;
		}
		//TD31699 lv end
		if (returndate != null) {
			if (returndate != ""){
				$dp.$(inputname).value = returndate;
				if(document.all("subject_" + index)!=null&&document.all("subject_" + index).value != "")
					changePeriod(index);
			}else {
				if (ismand == 1)
					spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				else
					spanname.innerHTML = "";
				$dp.$(inputname).value = "";
				clearaumountspan(index);
			}
		}
	},oncleared:oncleaingFun});

	if(ismand == 1){
		var hidename = $(inputname).value;
		if(hidename != ""){
			$(inputname).value = hidename; 
			$(spanname).innerHTML = hidename;
		}else{
			$(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		}
	}
}
function changeSubject(index, subjid) {
    if(document.all("organizationtype_" + index)!=null){
    organizationtypeval = document.all("organizationtype_" + index).value;
    organizationidval = document.all("organizationid_" + index).value;
    getBudget(index, organizationtypeval, organizationidval, subjid);
    }
}
function changePeriod(index) {
            if(document.all("subject_" + index)!=null&&document.all("subject_" + index).value != "")
              changeSubject(index,document.all("subject_" + index).value)
}
function callback(o, index) {
    if(document.getElementById("oldamountspan_" + index)){
         document.getElementById("oldamountspan_" + index).innerHTML = o;
         document.getElementById("oldamount_" + index).value = o;
		 //alert(document.getElementById("oldamount_" + index).value);
    }
    changenumber(index);
    changeapplynumber(index);
}

function getBudget(index, organizationtype, organizationid, subjid) {
    var callbackProxy = function(o) {
        callback(o, index);
    };
    var callMetaData = { callback:callbackProxy };

    if (document.all("budgetperiod_"+index)!= null&&document.all("budgetperiod_"+index).value!= ""&&document.all("organizationid_"+index)!= null&&document.all("organizationid_"+index).value!= ""&&document.all("subject_"+index)!= null&&document.all("subject_"+index).value!= "")
        BudgetHandler.getBudgetByDate(document.all("budgetperiod_"+index).value, organizationtype, organizationid, subjid, callMetaData);
}

function checknumber1(objectname)
{
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=".") isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}


</script>

