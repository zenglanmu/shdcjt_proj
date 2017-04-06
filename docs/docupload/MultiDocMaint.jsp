<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>

<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<% 
  if(!HrmUserVarify.checkUserRight("MultiDocUpload:maint", user))  {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
  }
%>



<%
	String imagefilename = "/images/hdDOC.gif";
	String titlename = SystemEnv.getHtmlLabelName(21400,user.getLanguage());
	String needfav ="1";
	String needhelp ="";


	session.putValue("imagefileids_MultiDocUp","");
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/xmlextras.js"></script>
		<SCRIPT language="javascript" src="/js/weaver.js"></script>

		<link href="/js/swfupload/default.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="/js/swfupload/swfupload.js"></script>
		<script type="text/javascript" src="/js/swfupload/swfupload.queue.js"></script>
		<script type="text/javascript" src="/js/swfupload/fileprogress.js"></script>
		<script type="text/javascript" src="/js/swfupload/handlers.js"></script>

		<script type="text/javascript">
				var oUpload;
		
				
				window.onload = function() {
				  var settings = {
						flash_url : "/js/swfupload/swfupload.swf",
						upload_url: "/docs/docupload/MultiDocUpload.jsp",	// Relative to the SWF file
						//post_params: {"PHPSESSID" : "<?php echo session_id(); ?>"},
						file_size_limit : "100 MB",
						file_types : "*.*",
						file_types_description : "All Files",
						file_upload_limit : 100,
						file_queue_limit : 0,
						custom_settings : {
							progressTarget : "fsUploadProgress",
							cancelButtonId : "btnCancel"
						},
						debug: false,
						 

						// Button settings
						
						button_image_url : "/js/swfupload/add.png",	// Relative to the SWF file
						button_placeholder_id : "spanButtonPlaceHolder",
		
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
						file_dialog_complete_handler : fileDialogComplete_1,
						upload_start_handler : uploadStart,
						upload_progress_handler : uploadProgress,
						upload_error_handler : uploadError,
						upload_success_handler : uploadSuccess,
						upload_complete_handler : uploadComplete,
						queue_complete_handler : queueComplete	// Queue plugin event
					};

					
					
					try{
						oUpload = new SWFUpload(settings);
					} catch(e){alert(e)}
				}
		
				function fileDialogComplete_1(){
					document.getElementById("btnCancel1").disabled = false;
					fileDialogComplete
				}
		
		
				function uploadComplete(fileObj) {
					try {
						/*  I want the next upload to continue automatically so I'll call startUpload here */
						if (this.getStats().files_queued === 0) {
							frmAddSubmit();
							document.getElementById(this.customSettings.cancelButtonId).disabled = true;
						} else {	
							this.startUpload();
						}
					} catch (ex) { this.debug(ex); }
		
				}
			</script>

 </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSubmit(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
  
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>			

    <TABLE  width=100% height=100% border="0" cellspacing="0" cellpadding="0">
      <colgroup>
        <col width="10">
          <col width="">
            <col width="10">
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
              <tr>
                <td></td>
                <td valign="top">
                <form name="frmAdd" method="post" action="MultiDocMaintOpration.jsp">
                <input type="hidden" name="doclangurage" value="<%=user.getLanguage()%>">
                
				 <TABLE class=Shadow>
                    <tr>					
                      <td valign="top" width="*">
						<!--//属性页面-->

						
						<table class="ViewForm" width="100%" id="tblProp">
							<colgroup>
							<col width="140">
							<col width="*">
							
							<tr>
								<td><%=SystemEnv.getHtmlLabelName(15046,user.getLanguage())%><!--文件存放目录--></td>
								<td class="field">
									  <button type="button"  class=Browser	 onClick="onShowCreaterCatagory('seccategory','spanSeccategory')"></button>
									  <span id="spanSeccategory" name="spanSeccategory">
										<IMG src="/images/BacoError.gif" align=absMiddle>
									   </span>
									   <font color="red"><%=request.getSession().getAttribute("msg_str")==null?"":request.getSession().getAttribute("msg_str") %></font>
									   <%request.getSession().setAttribute("msg_str",null); %>
									  <input type="hidden" name="seccategory" id="seccategory">   
								</td>
							</tr>
							<TR style="height: 1px!important;"><TD class=Line colSpan=6></TD></TR>		
						</table>	
						<div id="divProp"> 
						</div>
						<BR>

						 <TABLE  class="ViewForm">
							<tr>								
								<td colspan="2">		
								<div>
				
								<span> 
									<span id="spanButtonPlaceHolder"></span><!--选取多个文件-->
								</span>
								&nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload.cancelQueue();" id="btnCancel1">
									<span><img src="/js/swfupload/delete.gif"  border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span>

								</div>
						
	
																	
								</td>
							</tr>
							<tr style="height: 1px!important;"><td class="line1" colspan="2"></td></tr>
							<tr>
								<td  colspan="2">	
										
										
										
										 <div class="fieldset flash" id="fsUploadProgress">											
										</div>
										<div id="divStatus"></div>




								</td>
							</tr>
						</TABLE>

					</td>	
                    </tr>
                  </TABLE>
				</form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
            </table>
            <script type="text/javascript">

        	function onShowResource(input,span){
        		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
        		if (data){
        			if(data.id!=""){
        				span.innerHTML = "<a href='javaScript:openhrm("+data.id+");' onclick='pointerXY(event);'>"+data.name+"</a>"
        				input.value=data.id
        			}else{
        				span.innerHTML = " <IMG src='/images/BacoError.gif' align=absMiddle>"
        				input.value=""
        			}
        		}
        	}
        	function onShowMutiDummy(input,span){	
    			data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value)
	    		if (data){
	    			if(data.id!=""){
		    			
	    				dummyidArray=data.id.split(",")
	    				dummynames=data.name.split(",")
	    				
						var sHtml="";
	    				for(var k=0;k<dummyidArray.length;k++){
	    					sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp"
	    				}
	
	    				input.value=data.id
	    				span.innerHTML=sHtml
	    			}else{			
	    				input.value=""
	    				span.innerHTML=""
	    			}
	    		}
        	}
        	function onShowHrmresID(objval){
	    		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	    		if (data){
	    			if(data.id!=""){
	    				hrmresspan.innerHTML = "<A href='javaScript:openhrm("+data.id+");' onclick='pointerXY(event);'>"+data.name+"</A>"
	    				frmAdd.hrmresid.value=data.id
	
	    			}else{
	    				if (objval=="2"){
	    					hrmresspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	    				}else{
	    					hrmresspan.innerHTML =""
	    				}
	    				frmAdd.hrmresid.value=""
	    			}
	    		}
        	}
        	function onShowAssetId(objval){
	    		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	    		if(data){
		    		if (data.id!=""){
			    		assetidspan.innerHTML = "<A href='/cpt/capital/CapitalBrowser.jsp?id="+data.id+"'>"+data.name+"</A>"
			    		frmAdd.assetid.value=data.id
		    		}else{
		    			if (objval=="2"){
		    				assetidspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		    			}else{
		    				assetidspan.innerHTML =""
		    			}
		    		frmAdd.assetid.value="0"
		    		}
	    		}
        	}
        	function onShowCrmID(objval){
    			data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	    		if(data){
		    		if (data.id!=""){
			    		crmidspan.innerHTML = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="+data.id+"'>"+data.name+"</A>"
			    		frmAdd.crmid.value=data.id
		    		}else{
		    			if (objval=="2"){
		    				crmidspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		    			}else{
		   					crmidspan.innerHTML =""
		   				}
		    			frmAdd.crmid.value="0"
		    		}
	    		}
        	}

        	function onShowItemID(objval){
        		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
        		if(data){
	        		if (data.id!=""){
	        		itemspan.innerHTML = "<A href='/lgc/asset/LgcAsset.jsp?paraid="+data.id+"'>"+data.name+"</A>"
	        		frmAdd.itemid.value=data.id
	        		}else{
	        			if (objval=="2"){
	        				itemspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	        			}else{
        					itemspan.innerHTML =""
        				}
	        		frmAdd.itemid.value="0"
	        		}
        		}
        	}
        	function onShowBrowser(id,url,linkurl,type1,ismand){
        		if(type1== 2 || type1 == 19){
        			id1 = window.showModalDialog(url)
        			document.all("customfield"+id+"span").innerHtml = id1.name
        			document.all("customfield"+id).value=id1.id
        		}else{
        			if(type1==143){
        				tmpids = document.all("customfield"+id).value;
        				id1 = window.showModalDialog(url+"?treeDocFieldIds="+tmpids);
        			}else if(type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=162){
        				id1 = window.showModalDialog(url);
            		}else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            			tmpids = document.all("customfield"+id).value
            			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
            		}else if(type1==162){
							tmpids = document.all("customfield"+id).value;
							url = url + "&beanids=" + tmpids;
							url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
							id1 = window.showModalDialog(url);
            		}else{
            			tmpids = document.all("customfield"+id).value
            			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
            		}

        			if(id1){
						if(type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65){
							if(id1.id!=0 && id1.id!=""){
								resourceids = id1.id
								resourcename = id1.name
								sHtml = ""
								//resourceids = Mid(resourceids,2,len(resourceids))
								document.all("customfield"+id).value= resourceids
								//resourcename = Mid(resourcename,2,len(resourcename))
								resourceids = resourceids.split(",");
								resourcename = resourcename.split(",");
								for(var i=0;i<resourceids.length;i++){
									if(resourceids[i]!=""){
										sHtml = sHtml+"<a href="+linkurl+resourceids[i]+">"+resourcename[i]+"</a>&nbsp"
									}
								}
								
								//sHtml = sHtml+"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
								document.all("customfield"+id+"span").innerHTML = sHtml
							}else{
								if (ismand==0){
									document.all("customfield"+id+"span").innerHTML = "";
								}else{
									document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>";
								}
								document.all("customfield"+id).value=""
								
							}
	            		}else if(type1 == 143){
	        				if(id1.id!=0 && id1.id!=""){
	        					resourceids = id1.id
	        					resourcename = id1.name
	        					sHtml = ""
	        					//resourceids = Mid(resourceids,2,len(resourceids))
	        					document.all("customfield"+id).value= resourceids
	        					//resourcename = Mid(resourcename,2,len(resourcename))
	        					resourceids = resourceids.split(",");
	        					resourcename = resourcename.split(",");
	        					for(var i=0;i<resourceids.length;i++){
	        						if(resourceids[i]!=""){
	        							sHtml = sHtml+"<a href="+linkurl+resourceids[i]+">"+resourcename[i]+"</a>&nbsp"
	        						}
	        					}
	        					
	        					//sHtml = sHtml+"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
	        					document.all("customfield"+id+"span").innerHTML = sHtml
	        				}else{
	        					if (ismand==0){
	        						document.all("customfield"+id+"span").innerHTML = "";
	        					}else{
	        						document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>";
	        					}
	        					document.all("customfield"+id).value=""
	        				}
	        		
	        			}else{
		        			
	        				if(id1.id!=0 && id1.id!=""){

	               if (type1 == 162) {
				   		var ids = id1.id;
						var names =  id1.name;
						var descs =  id1.key3;
						sHtml = ""
						ids = ids.substr(1);
						document.all("customfield"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						document.all("customfield" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = id1.id;
					   	var names = id1.name;
						var descs =  id1.desc;
						document.all("customfield"+id).value = ids;
						sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						document.all("customfield" + id + "span").innerHTML = sHtml;
						return ;
				   }

		       					 if (linkurl == ""){
		       						document.all("customfield"+id+"span").innerHTML = id1.name
		       					 }else{
		       						document.all("customfield"+id+"span").innerHTML = "<a href="+linkurl+id1.id+">"+id1.name+"</a>"
		       					 }
		       					document.all("customfield"+id).value=id1.id
		       				}else{
		       					if (ismand==0){
		       						document.all("customfield"+id+"span").innerHTML = "";
		       					}else{
		       						document.all("customfield"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>";
		       					}
		       					document.all("customfield"+id).value=""
		       				}
	
	       			}
            	}
            }
        	}
            </script>
          </BODY>
        </HTML>



 <SCRIPT LANGUAGE="JavaScript">
	<!--          

	function onShowCreaterCatagory(input,span){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docupload/CatagoryForAddBrowser.jsp")
		if(datas){
			  if(datas.id!="" && datas.id!=0){
					if(datas.id!=$GetEle(input).value){
						if($GetEle(input).value!=""){
							if (confirm("<%=SystemEnv.getHtmlLabelName(21408,user.getLanguage())%>")){
									GetContent("divProp","/docs/docupload/DocPropCustom.jsp?secid=" +datas.id);
							}else{
								   return;
							}
						}else {
							GetContent("divProp","/docs/docupload/DocPropCustom.jsp?secid=" +datas.id);
						}
					}
					
					$GetEle(span).innerHTML =datas.name;
					$GetEle(input).value=datas.id;
				}else{
					$GetEle(span).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
					$GetEle(input).value="";
					divProp.innerHTML="";
				}
			}
		
	}
	
	function onShowProjectID(objval){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
		if (datas){
			if (datas.id!= "") {
				projectidspan.innerHTML = "<A href='/proj/data/ViewProject.jsp?ProjID="+datas.id+"'>"+datas.name+"</A>";
				frmAdd.projectid.value=datas.id
			}
			else {
				if (objval=="2") {
					projectidspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				}else{
					projectidspan.innerHTML ="";
				}
				frmAdd.projectid.value="0";
			}
		}
	}

	function  GetContent(divObj,url){
		divObj=document.getElementById(divObj);
		divObj.innerHTML="<img src=/images/loading2.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...";
		var xmlHttp = XmlHttp.create();
		xmlHttp.open("GET",url, true);
		xmlHttp.onreadystatechange = function () {
			switch (xmlHttp.readyState) {
			   case 3 :
					divObj.innerHTML="<img src=/images/loading2.gif> <%=SystemEnv.getHtmlLabelName(19612,user.getLanguage())%>...";
					break;
			   case 4 :
				   divObj.innerHTML =xmlHttp.responseText;		
				   changeUploaderFileLimit();
				   break;
			}
		}
		xmlHttp.setRequestHeader("Content-Type","text/xml")
		xmlHttp.send(null);
	}

	function changeUploaderFileLimit(){
		var limit = $GetEle("maxuploadfilesize").value
		if(limit==0||limit==""){
			oUpload.setFileSizeLimit("1");
		}else{
			oUpload.setFileSizeLimit(limit+" MB");
		}		
	}
	  function onSubmit(obj){    
		  //1。做必填字段判断
		  //a.目录为必选
		  if(!check_form(document.frmAdd,'seccategory')) return false;
		  //b.各目录相应的字段为必选
		  try{
			  var oNeedinputitems=document.getElementById("needinputitems");
			  if(oNeedinputitems!=null) {
				  if(oNeedinputitems.value!="") {
					    //alert(oNeedinputitems.value);
					    if(!check_form(document.frmAdd,oNeedinputitems.value)) return false;
				  }
			  }
			
		  } catch (e){}

		  //2。上传所有的附件
		  var oStats=oUpload.getStats();
		  //alert(oStats.files_queued);
		  if(oStats.files_queued==0){
			alert("必须选择需要上传的文件!")
		  } else {
			 //alert(oUpload.getStats());
			 obj.disabled=true ;
			 //document.getElementById("tblProp").disabled=true;
			 oUpload.startUpload();	 
		  }		 
	  }

	  function frmAddSubmit(){		
		  frmAdd.submit();

		
	  }

	   function onBack(){ 
		 window.history.go(-1);
	  }         
	 


	function onshowdocmain(vartmp){
		var otrtmp = document.getElementById("otrtmp");
		if(otrtmp!=null&&otrtmp.parentElement!=null){
			if(vartmp==1){
				otrtmp.parentElement.style.display='';
				otrtmp.parentElement.parentElement.parentElement.rows(otrtmp.parentElement.rowIndex+1).style.display='';
			} else {
				otrtmp.parentElement.style.display='none';
				otrtmp.parentElement.parentElement.parentElement.rows(otrtmp.parentElement.rowIndex+1).style.display='none';
			}
		}
	}

	//-->
	</SCRIPT>
	


	


