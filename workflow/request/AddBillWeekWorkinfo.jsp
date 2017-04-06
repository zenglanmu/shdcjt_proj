<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillWeekWorkinfoOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
 <%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %>
  <%int userids=user.getUID();

  %>
	<table class="viewform">
    <colgroup> <col width="20%"> <col width="80%"> 
	 <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(20561,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform">

      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class=liststyle cellspacing=1   cols=3 >
	      <COLGROUP> 
	      <COL width="30%"> <COL width="20%"><COL width="40%">
	      <tr class=header> 
	        <td><%=SystemEnv.getHtmlLabelName(15499,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15501,user.getLanguage())%></td>
	      </tr>
		  <%
		  if (rs.getDBType().equals("oracle"))
		  {
		   rs.execute("select * from bill_weekinfodetail where  type=3 and infoid=(select id from (select  b.* from bill_workinfo b,bill_weekinfodetail a where a.infoid=b.id and a.type=3 and b.resourceid="+userids+"  order by requestid desc) where rownum=1 ) order by id  ");
		 
		  }
		  else
		  {
		  rs.execute("select * from bill_weekinfodetail where type=3 and infoid=(select  top 1 b.id  from bill_weekinfodetail a,bill_workinfo b where a.type=3 and a.infoid=b.id and   b.resourceid="+userids+"  order by requestid desc) order by id");
		  }
		  boolean islights=true;
		  while (rs.next())
		  {
		  
			String curworknameold=rs.getString("workname");
    		String curdateold=rs.getString("forecastdate");
    		String curworkdescold=rs.getString("workdesc");
			%>
		  <tr <%if(islights){%>class=datalight <%} else {%>class=datadark<%}%>>
		
		  <td> <%=Util.toScreenToEdit(curworknameold,user.getLanguage())%></td>
		  <td><%=Util.toScreenToEdit(curdateold,user.getLanguage())%></td>
		   <td><%=Util.toScreenToEdit(curworkdescold,user.getLanguage())%></td>
		  </tr>
<%
    		islights=!islights;
    	
    	}
	
%>
	
	    </table>
	   </td></tr></table></td></tr>
  	   <tr><td height=15></td></tr>

    <tr > 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(15493,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform">
	  <!-- 完成事项 -->
	  <tr><td>
		<BUTTON Class=BtnFlow type=button accessKey=A onclick="addRow1()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=BtnFlow type=button accessKey=E onclick="deleteRow1();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<br> </td>
      </tr>
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class=liststyle cellspacing=1   cols=3 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(15494,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(16280,user.getLanguage())%></td>
	      </tr>
<%		
	char flag = 2 ;
	String resourceid=user.getUID()+"";
	int rowindex1=0 ;
	int rowindex2=0 ;
	int rowindex3=0 ;
	boolean islight=true;
	rs.executeProc("bill_workinfo_SSubordinate",""+formid+flag+"-1");
	while(rs.next()){
	    String curid=rs.getString("id");
	    RecordSet.executeProc("bill_workinfodetail_SByType",curid+flag+"1");
	    while(RecordSet.next()){
    		String curworkname=RecordSet.getString("workname");
    		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr <%if(islight){%>class=datalight <%} else {%>class=datadark<%}%>>
		  <td><input type=checkbox name="check_type1" value=<%=rowindex1%>></td>
		  <td><input type=input class=inputstyle  name="type1_<%=rowindex1%>_name" style=width:80% value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><textarea class=inputstyle  name="type1_<%=rowindex1%>_desc" rows=2 style="width:80%" onchange='checkinput1(type1_<%=rowindex1%>_desc,type1_<%=rowindex1%>_descspan)'><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
		  <span id="type1_<%=rowindex1%>_descspan"></span>  
		  </td>
		  </tr>
<%
    		islight=!islight;
    		rowindex1++;
    	}
	}
%>
	    </table>
	   </td></tr>
      </table>
      </td>
    </tr>
    <tr class="Title"> 
      <td colspan=2>
	  <table class="viewform">
	  <!-- 未完成事项 -->
	  <tr><td>
		<BUTTON Class=BtnFlow type=button accessKey=N onclick="addRow2()"><U>N</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=BtnFlow type=button accessKey=D onclick="deleteRow2();"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<br> </td>
      </tr>
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class=liststyle cellspacing=1   cols=3 id="oTable2">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(16281,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15497,user.getLanguage())%></td>
	      </tr>
<%	islight=true;
    rs.executeProc("bill_workinfo_SSubordinate",""+formid+flag+"-1");
	while(rs.next()){
	    String curid=rs.getString("id");
	    RecordSet.executeProc("bill_workinfodetail_SByType",curid+flag+"2");
	    while(RecordSet.next()){
    		String curworkname=RecordSet.getString("workname");
    		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr <%if(islight){%>class=datalight <%} else {%>class=datadark<%}%>>
		  <td><input type=checkbox name="check_type2" value=<%=rowindex2%>></td>
		  <td><input type=input class=inputstyle  name="type2_<%=rowindex2%>_name" style=width:80% value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><textarea class=inputstyle  name="type2_<%=rowindex2%>_desc" rows=2 style="width:80%" onchange='checkinput1(type2_<%=rowindex2%>_desc,type2_<%=rowindex2%>_descspan)'><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
		      <span id="type2_<%=rowindex2%>_descspan"></span>
		  </td>
		  </tr>
<%
    		islight=!islight;
    		rowindex2++;
    	}
	}
%>
	    </table>
	   </td></tr>
      </table>
      </td>
    </tr>
    
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(15498,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform">
	  <!-- 未完成事项 -->
	  <tr><td>
		<BUTTON Class=BtnFlow type=button accessKey=T onclick="addRow3()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=BtnFlow type=button accessKey=X onclick="deleteRow3();"><U>X</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<br> </td>
      </tr>
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class=liststyle cellspacing=1   cols=4 id="oTable3">
	      <COLGROUP> 
	      <COL width="10%"><COL width="30%"> <COL width="20%"><COL width="40%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(15499,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15501,user.getLanguage())%></td>
	      </tr>
<%	islight=true;
    rs.executeProc("bill_workinfo_SSubordinate",""+formid+flag+"-1");
    while(rs.next()){
        String curid=rs.getString("id");
    	RecordSet.executeProc("bill_workinfodetail_SByType",curid+flag+"3");
    	while(RecordSet.next()){
    		String curworkname=RecordSet.getString("workname");
    		String curdate=RecordSet.getString("forecastdate");
    		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr <%if(islight){%>class=datalight <%} else {%>class=datadark<%}%>>
		  <td><input type=checkbox name="check_type3" value=<%=rowindex3%>></td>
		  <td><input type=input class=inputstyle  name="type3_<%=rowindex3%>_name" style="width:80%" value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><button class=Calendar onClick='getMontPlanDate(type3_<%=rowindex3%>_date,type3_<%=rowindex3%>_datespan)'></button>
		  <span id=type3_<%=rowindex3%>_datespan><%=curdate%></span>
		  <input type=hidden name=type3_<%=rowindex3%>_date value="<%=curdate%>">
		  </td>
		  <td><textarea class=inputstyle  name="type3_<%=rowindex3%>_desc" rows=2 style="width:80%" onchange='checkinput1(type3_<%=rowindex3%>_desc,type3_<%=rowindex3%>_descspan)'><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
		      <span id="type3_<%=rowindex3%>_descspan"></span>
		  </td>
<%
    		islight=!islight;
    		rowindex3++;
    	}
	}
%>
	    </table>
	   </td></tr>
  	   <tr><td height=15></td></tr>
      </table>
      </td>
    </tr>
  </table>
<input type="hidden" value="0" name="nodesnum1">
<input type="hidden" value="0" name="nodesnum2">
<input type="hidden" value="0" name="nodesnum3">
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
<script language="JavaScript" src="/js/addRowBg.js"></script>  
<script language=javascript>
rowindex1 = <%=rowindex1%> ;
rowindex2 = <%=rowindex2%> ;
rowindex3 = <%=rowindex3%> ;
var rowColor="" ;
function addRow1()
{		rowColor = getRowBg();
	ncol = oTable1.cols;
	oRow = oTable1.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type1' value="+rowindex1+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' class=inputstyle  name='type1_"+rowindex1+"_name' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<textarea  class=inputstyle rows=2 cols=70 name='type1_"+rowindex1+"_desc' style='width=80%' onchange='checkinput1(type1_"+rowindex1+"_desc,type1_"+rowindex1+"_descspan)'></textarea>"+
				            "<span id='type1_"+rowindex1+"_descspan'><img src='/images/BacoError.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		}
	}
	document.all("needcheck").value += ",type1_"+rowindex1+"_desc";
	rowindex1 = rowindex1*1 +1;
	document.frmmain.nodesnum1.value=rowindex1;
}

function deleteRow1()
{
    var flag = false;
	var ids = document.getElementsByName('check_type1');
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
                if (document.forms[0].elements[i].name=='check_type1')
                    rowsum1 ++;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type1'){
                    if(document.forms[0].elements[i].checked==true)
                        oTable1.deleteRow(rowsum1);
                    rowsum1--;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

function addRow2()
{	rowColor = getRowBg();
	ncol = oTable2.cols;
	oRow = oTable2.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type2' value="+rowindex2+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' class=inputstyle name='type2_"+rowindex2+"_name' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<textarea class=inputstyle  rows=2 cols=70 class=inputstyle name='type2_"+rowindex2+"_desc' style='width=80%' onchange='checkinput1(type2_"+rowindex2+"_desc,type2_"+rowindex2+"_descspan)'></textarea>"+
				            "<span id='type2_"+rowindex2+"_descspan'><img src='/images/BacoError.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		}
	}
	document.all("needcheck").value += ",type2_"+rowindex2+"_desc";
	rowindex2 = rowindex2*1 +1;
	document.frmmain.nodesnum2.value=rowindex2;

}

function deleteRow2()
{
    var flag = false;
	var ids = document.getElementsByName('check_type2');
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
                if (document.forms[0].elements[i].name=='check_type2')
                    rowsum1 ++;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type2'){
                    if(document.forms[0].elements[i].checked==true)
                        oTable2.deleteRow(rowsum1);
                    rowsum1--;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

function addRow3()
{	rowColor = getRowBg();
	ncol = oTable3.cols;
	oRow = oTable3.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type3' value="+rowindex3+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' class=inputstyle  name='type3_"+rowindex3+"_name' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Calendar onClick='getMontPlanDate(type3_"+rowindex3+"_date,type3_"+rowindex3+"_datespan)'></button> " + 
        					"<span class=Inputstyle id=type3_"+rowindex3+"_datespan><img src='/images/BacoError.gif' align=absmiddle></span> "+
        					"<input type='hidden' name='type3_"+rowindex3+"_date' id='type3_"+rowindex3+"_date'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<textarea class=inputstyle  rows=2 cols=70 name='type3_"+rowindex3+"_desc' style='width=80%' onchange='checkinput1(type3_"+rowindex3+"_desc,type3_"+rowindex3+"_descspan)'></textarea>"+
				            "<span id='type3_"+rowindex3+"_descspan'><img src='/images/BacoError.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		}
	}
	document.all("needcheck").value += ",type3_"+rowindex3+"_date"+",type3_"+rowindex3+"_desc";
	rowindex3 = rowindex3*1 +1;
	document.frmmain.nodesnum3.value=rowindex3;
}

function deleteRow3()
{
    var flag = false;
	var ids = document.getElementsByName('check_type3');
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
                if (document.forms[0].elements[i].name=='check_type3')
                    rowsum1 ++;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type3'){
                    if(document.forms[0].elements[i].checked==true)
                        oTable3.deleteRow(rowsum1);
                    rowsum1--;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
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
<SCRIPT language="javascript"  src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>