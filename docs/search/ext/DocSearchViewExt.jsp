<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/docs/DocDetailLog.jsp"%>
<script type="text/javascript" src="/js/doc/DocShareSnip.js"></script>
<Div id="divDummy" width="300px" height="160px" style='border:1px solid #CDCDCD;display:none;width:300px;height:160px;background-color:#FFFFFF;overflow:auto'>
<TABLE  style='width:100%;' cellspacing='0' cellpadding='0' valign='top'>
			<TR>
				<TD  style='background-color:#999999;color:#FFFFFF;height:24px'><div style='width:87%;float:left'>&nbsp;<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%></div> <div><a href='javaScript:onCloseImport()'>[<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>]</a></div></TD>
		   </TR>	
			<TR><TD id='tdContent'>
			 <table class='viewform' width="100%" height="100%" id='tblSetting' cellspacing='0' cellpadding='0' class='ViewForm' valign='top'>
				 	 <TR >
					  <TD  style='height:20px;width:30%'>&nbsp;<%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></TD>
					  <TD class='field' style='height:20px;width:70%'><button class=Browser type="button" onClick="onShowMutiDummy(document.getElementById('txtDummy'),document.getElementById('spanDummy'))"></button> <input type="hidden" id="txtDummy"  name="txtDummy"><span id="spanDummy"></span></TD>
					</TR>
					<TR colspan='2' style="height:1px;" ><TD  CLASS='line'></TD></TR>						
				</table>
				<br>


				<table class='viewform' id='tblUploading' cellspacing='0' cellpadding='0' valign='top' style='display:none;text-align:center'>
				 <TR>
					<TD id="tdUploading">
						<img src="/images/loading.gif">&nbsp;<%=SystemEnv.getHtmlLabelName(19819,user.getLanguage())%>...	
					</TD>				   
				 </TR>
			 </table>
			
			</TD></TR>
	</TABLE>
</TD>  
</TR>      
</TABLE>
</Div>
<input type="hidden" id="txtSql"  name="txtSql">
<input type="hidden" id="txtDocs"  name="txtDocs">
<input type="hidden" id="txtStatus"  name="txtStatus">

<script language="javaScript">

	function miniatureDisplay(){
		//$("ipnut[name=displayUsage]").val(1);
		//jQuery("ipnut[name=displayUsage]").val(1)
		$GetEle("displayUsage").value=1;
		var docSearchForm= $('form[name=frmmain]')[0];
		docSearchForm.submit();
	}
	
	function listDisplay(){
		//$("ipnut[name=displayUsage]").val(0);
		//jQuery("ipnut[name=displayUsage]").val(0)
		$GetEle("displayUsage").value=0;
		//var docSearchForm = document.getElementById('frmmain');
		var docSearchForm= $GetEle("frmmain");
		docSearchForm.submit();
	}
	
	
   function initToDummy(){
	   var pTop= document.body.offsetHeight/2+document.body.scrollTop-100;
	   var pLeft= document.body.offsetWidth/2-180;
		
		divDummy.style.position="absolute"
		divDummy.style.top=pTop+"px";
		divDummy.style.left=pLeft+"px";
		divDummy.style.display="inline";
		document.getElementById("spanDummy").innerHTML="";
		document.getElementById("txtDummy").value="";

   }
   function importSelectedToDummy(){ 
   		//alert(tableJson);
   		//_table.getCheckBoxValue();
   		//alert(_table._xtable_CheckedCheckboxId());
   		if(<%=displayUsage%> == 0&&false)
   		{
			txtDocs.value=_table._xtable_CheckedCheckboxId();
		}
		else
		{
			txtDocs.value=_xtable_CheckedCheckboxId();
		}
		if(txtDocs.value=="") {
			alert("<%=SystemEnv.getHtmlLabelName(20551,user.getLanguage())%>");
		} else {
			initToDummy();
			txtStatus.value=1;   
		}
	}
		

   function importAllToDummy(){ 
		initToDummy(); 
		txtStatus.value=2;
		txtSql.value=sessionId;
   }
   function onCloseImport(){
	   tblSetting.style.display='';
	   tblUploading.style.display='none';
	   divDummy.style.display='none';
   }

   function showMsg(txt){		
		tdUploading.innerHTML=txt;
   }

   function onImporting(){
	   tblSetting.style.display='none';
	   tblUploading.style.display='';


	    var importHttp =null;
	    try{
	    	importHttp =new ActiveXObject("Microsoft.XMLHTTP");	  
	    }catch(e){
	    	importHttp =new XMLHttpRequest(); 
	    }
		var actionUrl="/docs/search/DocUpToDummy.jsp?method=add&txtDummy="+txtDummy.value+"&txtSql="+txtSql.value+"&txtDocs="+txtDocs.value+"&txtStatus="+txtStatus.value;		
		//document.write(actionUrl)
		//alert(actionUrl);
		importHttp.open("get",actionUrl, true);
		//alert(importHttp.readyState);   
		importHttp.onreadystatechange = function () {	
			switch (importHttp.readyState) {			   
			   case 4 : 
				    var txt=importHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");;					
					if(txt=="success") {
						//this.onCloseImport();
						//alert('aaa');
						onCloseImport();
					} else {
						//this.showMsg(txt)
						//alert(txt);
						showMsg(txt);
					}					 
			} 
		}	
		
		importHttp.setRequestHeader("Content-Type","text/xml")	

		importHttp.send(null);	
		
   }
</script>


<script language="vbscript">
	
	sub onShowMutiDummy(input,span)	
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"_1")
		'msgbox("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"_1")
		if NOT isempty(id) then
			if id(0)<> "" then	
				dummyidArray=Split(id(0),",")
				dummynames=Split(id(1),",")
				dummyLen=ubound(dummyidArray)-lbound(dummyidArray) 

				For k = 0 To dummyLen
					sHtml = sHtml&"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="&dummyidArray(k)&"'>"&dummynames(k)&"</a><br>"
				Next				
				if sHtml<>"" then
					sHtml=sHtml&"<input type=button value='<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%>	' onclick='onImporting()'>"
			     end if
			     
				input.value=id(0)
				span.innerHTML=sHtml
			else			
				input.value=""
				span.innerHTML=""
			end if
		end if
	end sub
</script>
<script language="javascript">
		function onShowMutiDummy(input,span){
			var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
			var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"_1","",
				"dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");

			if (datas) {
				if (datas.id!= ""){
					dummyidArray=datas.id.split(",");
					dummynames=datas.name.split(",");
					dummyLen=dummyidArray.length;
					sHtml="";
					for(var k=0;k<dummyLen;k++){
						sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a><br>"
					}
					if (sHtml!=""){
						sHtml=sHtml+"<input type=button value='<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%>' onclick='onImporting();'>";
					}
					input.value=datas.id;
					$(span).html(sHtml);
				}
				else{			
					input.value="";
					span.innerHTML="";
				}
			}
		}	
	</script>
<script language="javaScript">
	var docid;
    function onSearch(){
        frmSearch.submit();    
    }

    function doDocDel(docid){
        if (isdel()){
        	var url = "/docs/docs/DocOperate.jsp?operation=delete&docid="+docid;
        	
        	Ext.Ajax.request({
        		url : '/docs/docs/DocDwrProxy.jsp' , 
				params : {},
				url : url ,
				method: 'POST',
				success: function ( result, request) {
					alert(result.responseText.trim());
       				//Ext.Msg.alert('Status', result.responseText.trim());
       				_table.reLoad();
				},
				failure: function ( result, request) { 
					Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result); 
				} 
			});
        }
    }

    function doDocShare(docid){        
		var DocSharePane=new DocShareSnip(docid,true).getGrid();
		
        var winShare = new Ext.Window({
        	//id:'DocSearchViewWinLog',
	        layout: 'fit',
	        width: 600,
	        resizable: true,
	        height: 400,
	        closeAction: 'hide',
	        //plain: true,
	        modal: true,
	        title: wmsg.doc.share,
	        items: DocSharePane,
	        autoScroll: true,
	        buttons: [{
	            text: wmsg.base.submit,// '确定',
	            handler: function(){
	        	winShare.hide();
	            }
	        }]
	    });
        winShare.show(null);
        //var url = "/docs/docs/DocOperate.jsp?operation=share&docid="+docid;
        //openFullWindowHaveBar(url);
    }

    function doDocViewLog(docid){
    	
    	var DocDetailLogPane=getDocDetailLogPane(docid,500,300,false);
		
        var winLog = new Ext.Window({
        	//id:'DocSearchViewWinLog',
	        layout: 'fit',
	        width: 600,
	        resizable: true,
	        height: 400,
	        closeAction: 'hide',
	        //plain: true,
	        modal: true,
	        title: wmsg.doc.detailLog,
	        items: DocDetailLogPane,
	        autoScroll: true,
	        buttons: [{
	            text: wmsg.base.submit,// '确定',
	            handler: function(){
	                 winLog.hide();
	            }
	        }]
	    });
	    winLog.show(null);    
       
    }
    function signReaded(){
        var signReadIds = "";
        if(<%=displayUsage%> == 0&&false)
   		{
			signReadIds=_table._xtable_CheckedCheckboxId();
		}
		else
		{
			signReadIds = _xtable_CheckedCheckboxId();
		}  
        if (signReadIds==""){
            alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
            return ;
        }
        document.DocNewViewForm.action="/docs/search/DocSearchOperation.jsp";
        document.DocNewViewForm.operation.value="signReaded";        
       
		document.DocNewViewForm.signValus.value=signReadIds;
        document.DocNewViewForm.submit();
    }
	function treeView(){
		
	}
	function viewbyOrganization(){
		
	}
	function sutraView(){
		
	}

    function viewByTreeDocField(){
		
    }   
</script>

