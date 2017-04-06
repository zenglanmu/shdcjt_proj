var showwidth=0;
var showheight=0;
var nowcol=1;
var nowrow=1;
function getwidth(){
	var swidth=0;
	showwidth=0;
	var i=0;
	nowcol=document.frmmain.ChinaExcel.GetSelectRegionStartCol();
	var startCol = document.frmmain.ChinaExcel.GetStartCol();
	
	if(!frmmain.ChinaExcel.ShowHeader){
		i=1 ;
	}
	i = (startCol - 1) + i;
	for (i ; i <nowcol; i++){
		swidth=document.frmmain.ChinaExcel.GetColSize(i,1);
		showwidth+=swidth;
	}
}
function getHeight(){
	var sheight=0;
	showheight=0;
	var j=0;
	nowrow=document.frmmain.ChinaExcel.GetSelectRegionStartRow();
	if(!frmmain.ChinaExcel.ShowHeader){
		j=1;
	}
	for(j;j <nowrow; j++){
		sheight=document.frmmain.ChinaExcel.GetRowSize(j,1);
		showheight+=sheight;
	}
}
function mouseout(){
	var x = oPopup.document.parentWindow.event.clientX;
	var y = oPopup.document.parentWindow.event.clientY
	if(x<0 || y<0) window.setTimeout("oPopup.hide()",1000);
}
var oPopup = window.createPopup();
var oPopupInprepDspDate = window.createPopup();
var lefter =0;
var topper =0;
function showPopup(uservalue,cellvalue,ismand,selectshow)
{

    if(uservalue!=null && uservalue!="" && uservalue.lastIndexOf("_")>-1 && ismand>=0){

        if(uservalue=="main_createCodeAgain"){
			showPopupCreateCodeAgain(uservalue,cellvalue,ismand,selectshow);
			return ;
		}

		var fieldBodyId=0;
		var isedit=0;
		if(ismand>0){
			isedit=1;
		}
		if(uservalue.indexOf("_")>5){
			fieldBodyId=uservalue.substring(5,uservalue.indexOf("_"));
		}

		var flowDocField=-1;
		var newTextNodes;
		if($G("flowDocField")!=null){
			flowDocField=$G("flowDocField").value;
		}

		if($G("newTextNodes") != null){
		   newTextNodes = $G("newTextNodes").value;
		}


        var htmltype=uservalue.substring(uservalue.lastIndexOf("_")+1);
        uservalue=uservalue.substring(0,uservalue.lastIndexOf("_"));
        var fieldtype=0;
        if(uservalue.lastIndexOf("_")>-1){
            fieldtype=uservalue.substring(uservalue.lastIndexOf("_")+1);
            uservalue=uservalue.substring(0,uservalue.lastIndexOf("_"));
        }

		var resourceRoleId="-1";	
		if(document.getElementById("resourceRoleId"+uservalue)!=null){
			resourceRoleId=document.getElementById("resourceRoleId"+uservalue).value;
		}

		getwidth();
        getHeight();
        if(!frmmain.ChinaExcel.ShowHeader){
           showwidth=showwidth;
        }else{
           showwidth=showwidth-20;
        }
        lefter =showwidth;
        topper =frmmain.ChinaExcel.GetMousePosY();
        if(htmltype=="3"){
            var urlid="";
            var url="";
            var urllink="";
            var urllinkno="";
            var i;
            var selvalue=new Array();
            var urlarr=new Array();
            var urlno=new Array();
            var oTable=document.getElementById("otable");
            var oDiv;
            var sHtml = "";
            var indexrow=parseInt(document.getElementById("indexrow").value);
            var requestid="0";
            var desrequestid = "0";
            if(indexrow>0){
                for(i=(indexrow-1);i>=0;i--){
                    oTable.deleteRow(i);
                }
                indexrow=0;
            }
            try{
                urlid=document.getElementById(uservalue).value;
                var fieldstr=uservalue;
                if(uservalue.indexOf("_")>0){
                    fieldstr=uservalue.substring(0,uservalue.indexOf("_"));
                }
                if(document.getElementById(uservalue+"_url").value){
                    url=document.getElementById(uservalue+"_url").value;
                }
                if (url == "") {
                    url = document.getElementById(fieldstr + "_url").value;
                }
                if (document.getElementById(uservalue + "_urllink").value) {
                    urllink = document.getElementById(uservalue + "_urllink").value;

                }
                if (urllink == "") {
                    urllink = document.getElementById(fieldstr + "_urllink").value;
                }
                urllinkno=document.getElementById(uservalue+"_linkno").value;
            }catch(e){}
            if(document.getElementById("requestid")!=null)
                requestid=document.getElementById("requestid").value;
                if(document.getElementById("desrequestid")!=null){
            	desrequestid=document.getElementById("desrequestid").value;
            }
            if(cellvalue!=null && cellvalue!=""){
                if(cellvalue.indexOf(",")>-1){
                    selvalue=cellvalue.split(",");
                    urlarr=urlid.split(",");
                    urlno=urllinkno.split(",");
                }else{
                    selvalue[0]=cellvalue;
                    urlarr[0]=urlid;
                    urlno[0]=urllinkno;
                }
				oTable.border=1;
                oRow = oTable.insertRow();
                oCell = oRow.insertCell();
                oCell.colSpan =2;
                oCell.style.fontSize="14px";
                oCell.style.color="blue";
                for(i=0;i<selvalue.length;i++){
                    if(sHtml.length>0){
                        sHtml+=" ";
                    }
                    if(urllink!=""){

                        if(fieldtype==9&&fieldBodyId==flowDocField){
                            //sHtml+="<a href='#' onclick=\"this.disabled=true;parent.createDoc('"+fieldBodyId+"','"+urlarr[i]+"','"+isedit+"')\">"+selvalue[i]+"</a>";
							sHtml+="<a href='#' onclick=\"try {this.disabled=true;parent.createDoc('"+fieldBodyId+"','"+urlarr[i]+"','"+isedit+"');}catch(e){parent.window.open('"+urllink+urlarr[i]+"&requestid="+requestid+"&desrequestid="+desrequestid+"')}\">"+selvalue[i]+"</a>";
                        }else if(fieldtype==16 || fieldtype==152 || fieldtype==171){
                            if(urlno[i]!=""&&urlno[i]>-1){
                                sHtml+="<a href='#' onclick=\"parent.window.open('"+urllink+urlarr[i]+"&wflinkno="+urlno[i]+"')\">"+selvalue[i]+"</a>";
                            }else{
                                sHtml+="<a href='#' onclick=\"parent.window.open('"+urllink+urlarr[i]+"')\">"+selvalue[i]+"</a>";
                            }
                        }else if(fieldtype==8 || fieldtype==135 || fieldtype==7 || fieldtype==18 || fieldtype==9 || fieldtype==37 || fieldtype==23){
                            sHtml+="<a href='#' onclick=\"parent.window.open('"+urllink+urlarr[i]+"&requestid="+requestid+"&desrequestid="+desrequestid+"')\">"+selvalue[i]+"</a>";
                        }
                        else
                        {
                             if(urllink=="/hrm/resource/HrmResource.jsp?id=")
                             {
								sHtml +="<a href='#' onclick='javascript:parent.pointerXY(event);parent.openhrm("+urlarr[i]+");'>"+selvalue[i]+"</a>"
							 }
							 else
							 {
                            	sHtml+="<a href='#' onclick=\"parent.openWindow('"+urllink+urlarr[i]+"')\">"+selvalue[i]+"</a>";
                             }
                        }
                    }else{
                        sHtml+=selvalue[i];
                    }
                }
                oDiv = document.createElement("div");
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                indexrow++;
            }
			if(selectshow!=0 && ismand>0){
            
			if(fieldtype==9&&fieldBodyId==flowDocField){
				url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
			}

            oRow = oTable.insertRow();
            oCell = oRow.insertCell();
            oCell.style.fontSize="14px";
            oCell.style.background="#e4e4e4";
            var ModalDialog="window.showModalDialog('";
            if (fieldtype== 2 || fieldtype == 19){
                ModalDialog+=url+"','','dialogHeight:320px;dialogWidth:275px')";
            }else{
                if (fieldtype != 162 && fieldtype != 171 && fieldtype != 152 && fieldtype != 142 && fieldtype != 141 && fieldtype != 135 && fieldtype !=17 && fieldtype != 18 && fieldtype!=27 && fieldtype!=37 && fieldtype!=56 && fieldtype!=57 && fieldtype!=65 && fieldtype!=165 && fieldtype!=166 && fieldtype!=167 && fieldtype!=168){
                	ModalDialog+=url+"')";
                }else{
                    var resourceids="";
                    try{
                        resourceids=$G(uservalue).value;
                    }catch(e){}
                    if (fieldtype==135)
                        ModalDialog+=url+"?projectids="+resourceids+"')";
                    else if (fieldtype==37)
                        ModalDialog+=url+"?documentids="+resourceids+"')";
                    else if (fieldtype==142)
                        ModalDialog+=url+"?receiveUnitIds="+resourceids+"')";
                    else if (fieldtype==141){
                        //ModalDialog+=url+"?resourceCondition="+resourceids+"&isFromMode=1')";
					    tempUrl=escape("/hrm/resource/ResourceConditionBrowser.jsp?resourceCondition="+resourceids+"&isFromMode=1");
                        ModalDialog+="/systeminfo/BrowserMain.jsp?url="+tempUrl+"')";
					}else if (fieldtype==162){
                        var tempUrl = url+"&beanids="+resourceids;
						tempUrl = tempUrl.substr(0,32) + escape(tempUrl.substr(32));
						ModalDialog+=""+tempUrl+"')";
					}else if (fieldtype==165 || fieldtype==166 || fieldtype==167 || fieldtype==168){
                        tindex=uservalue.indexOf("_");
                        //TD15899
                        var isbill;
                        if(typeof(document.getElementById("isbill")) != undefined)
                        	isbill=document.getElementById("isbill").value;
                        if(tindex>0){
                            tempuservalue=uservalue.substring(0,tindex);
                            //tempUrl=escape("?isdetail=1&fieldid="+tempuservalue.substring(5));//TD15899
                            tempUrl=escape("?isdetail=1&isbill="+isbill+"&fieldid="+tempuservalue.substring(5)+"&resourceids="+resourceids);
                            ModalDialog+=url+tempUrl+"')";
                        }else{
                            //ModalDialog+=url+"?fieldid="+uservalue.substring(5)+"')";//TD15899
                        	tempUrl=escape("?fieldid="+uservalue.substring(5)+"&isbill="+isbill+ "&resourceids="+resourceids);
                            ModalDialog+=url+tempUrl+"')";
                        }
                    }
                    else
                        ModalDialog+=url+"?resourceids="+resourceids+"')";
                }
            }
            //由于日期控件本身返回值为vb所以，不用转换
			if (ModalDialog.indexOf("systeminfo/Calendar.jsp") == -1 && ModalDialog.indexOf("systeminfo/Clock.jsp") == -1) {        
            	ModalDialog = "parent.string2VbArray(parent.json2String(" + ModalDialog + "))";
            }
            
            reportUserIdInputName="";
			crmIdInputName="";
			if(document.getElementById("reportUserIdInputName")!=null){
				reportUserIdInputName=document.getElementById("reportUserIdInputName").value;
			}
			if(document.getElementById("crmIdInputName")!=null){
				crmIdInputName=document.getElementById("crmIdInputName").value;
			}
			sHtml="";    
            var language=readCookie("languageidweaver");
            if(language==8){
                if(reportUserIdInputName==uservalue){
					sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowReportUserIdThis("+ModalDialog+",'"+uservalue+"',"+nowrow+","+nowcol+")\">[Please Select]";
				}else if(crmIdInputName==uservalue){
					sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowCustomerThis('"+uservalue+"',"+nowrow+","+nowcol+")\">[Please Select]";
				}else{
					 if(fieldtype==9&&fieldBodyId==flowDocField){
						if(newTextNodes != 1){
						  sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">[Please Select]";
				         }
					 }else{
					      sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">[Please Select]";
				     }	
				}
			    if(fieldtype==9&&fieldBodyId==flowDocField&&(cellvalue==null || cellvalue=="")){
					sHtml+="<LINK href=\"/css/Weaver.css\" type=text/css rel=STYLESHEET>";
		            sHtml+="<button id=\"createdocbutton\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.createDoc('"+fieldBodyId+"','','"+isedit+"')\" title=\"New\">New</button>";
				}
				if(fieldtype==160){
					sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowResourceRole('"+url+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+",'"+resourceRoleId+"')\">[Please Select]";
				}
                if(fieldtype==161||fieldtype==162){
                	var tempUrl = url+"&beanids="+resourceids;
					tempUrl = tempUrl.substr(0,32) + escape(tempUrl.substr(32));
                	sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.ShowCustomizeBrowser('"+tempUrl+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">[Please Select]";
                }
			}
			else if(language==9){ 
                 if(reportUserIdInputName==uservalue)
                 { 
						sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowReportUserIdThis("+ModalDialog+",'"+uservalue+"',"+nowrow+" ,"+nowcol+")\">[請選擇]"; 
				 }else if(crmIdInputName==uservalue){ 
						sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowCustomerThis('"+uservalue+"',"+nowrow+","+nowcol+" )\">[請選擇]"; 
				 }else{ 
					if(fieldtype==9&&fieldBodyId==flowDocField){ 
						if(newTextNodes != 1){ 
							sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+" ,"+ismand+","+nowrow+","+nowcol+")\">[請選擇]"; 
						} 
					}else{ 
						sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+" ,"+ismand+","+nowrow+","+nowcol+")\">[請選擇]"; 
					} 
				} 
                 if(fieldtype==9&&fieldBodyId==flowDocField&&(cellvalue==null || cellvalue=="")){ 
					sHtml+="<LINK href=\"/css/Weaver.css\" type=text/css rel=STYLESHEET>"; 
					sHtml+="<button id=\"createdocbutton\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.createDoc('"+fieldBodyId+"','','"+isedit+"')\" title=\"新建\">新建</button>";
				} 
				if(fieldtype==160){ 
					sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowResourceRole('"+url+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+",'"+resourceRoleId+"')\">[請選擇]"; 
				} 
                if(fieldtype==161||fieldtype==162){
                	var tempUrl = url+"&beanids="+resourceids;
					tempUrl = tempUrl.substr(0,32) + escape(tempUrl.substr(32));
                	sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.ShowCustomizeBrowser('"+tempUrl+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">[請選擇]";
                }
			}
			else{
                if(reportUserIdInputName==uservalue){
					sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowReportUserIdThis("+ModalDialog+",'"+uservalue+"',"+nowrow+","+nowcol+")\">[请选择]";
				}else if(crmIdInputName==uservalue){
					sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowCustomerThis('"+uservalue+"',"+nowrow+","+nowcol+")\">[请选择]";
				}else{
					if(fieldtype==9&&fieldBodyId==flowDocField){
						if(newTextNodes != 1){
						  sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">[请选择]";
				        }
					}else{
					  sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.Browser("+ModalDialog+",'"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">[请选择]";
				    }
				}
                if(fieldtype==9&&fieldBodyId==flowDocField&&(cellvalue==null || cellvalue=="")){
					sHtml+="<LINK href=\"/css/Weaver.css\" type=text/css rel=STYLESHEET>";
				   sHtml+="<button id=\"createdocbutton\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.createDoc('"+fieldBodyId+"','','"+isedit+"')\" title=\"新建\">新建</button>";
				}
				if(fieldtype==160){
					sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowResourceRole('"+url+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+",'"+resourceRoleId+"')\">[请选择]";
				}
                if(fieldtype==161||fieldtype==162){
                	var tempUrl = url+"&beanids="+resourceids;
					tempUrl = tempUrl.substr(0,32) + escape(tempUrl.substr(32));
                	sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.ShowCustomizeBrowser('"+tempUrl+"','"+uservalue+"',"+fieldtype+","+ismand+","+nowrow+","+nowcol+")\">[请选择]";
                }
			}
			
            oDiv = document.createElement("div");
            oDiv.innerHTML = sHtml;
            oCell.appendChild(oDiv);

            oCell = oRow.insertCell();
            oCell.style.color="blue";
            oCell.style.fontSize="14px";
            oCell.style.background="#e4e4e4";
			sHtml="";
            if(language==8){
                if(fieldtype==9&&fieldBodyId==flowDocField){
					if(newTextNodes != 1){
					  sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">Clear Result</a>";
					}
				}else{
                      sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">Clear Result</a>";
				}   
			}
			else if(language==9){
                if(fieldtype==9&&fieldBodyId==flowDocField){
					if(newTextNodes != 1){
					  sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">清除結果</a>";
					}
				}else{
                      sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">清除結果</a>";
				}
			}
			else{
                if(fieldtype==9&&fieldBodyId==flowDocField){
					if(newTextNodes != 1){
					  sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">清除结果</a>";
					}
				}else{
                      sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">清除结果</a>";
				}
			}
            oDiv = document.createElement("div");
            oDiv.innerHTML = sHtml;
            oCell.appendChild(oDiv);
            
            indexrow++;
            
            if(fieldtype==87){
                oRow = oTable.insertRow();
                oCell = oRow.insertCell();
                oCell.style.fontSize="14px";
                oCell.style.background="#e4e4e4";
                oDiv = document.createElement("div");
                oDiv.innerHTML = "<A href='#' onclick=\"parent.window.open('/meeting/report/MeetingRoomPlan.jsp')\">查看会议室使用情况</A>";
                oCell.appendChild(oDiv);
                oCell = oRow.insertCell();
                oCell.style.fontSize="14px";
                oCell.style.background="#e4e4e4";
                oDiv = document.createElement("div");
                oDiv.innerHTML = "";
                oCell.appendChild(oDiv);
            
                indexrow++;
            }
			}
            document.getElementById("indexrow").value=indexrow;
            var ocont=document.getElementById("ocontext");
            ocont.style.display='';
            oPopup.document.body.attachEvent("onmouseout",mouseout);
            oPopup.document.body.innerHTML = ocont.innerHTML;             
            if(fieldtype==161||fieldtype==162){            	
            	if(selectshow!=0 && ismand>0) oPopup.show(lefter,topper,200,ocont.offsetHeight, document.ChinaExcel);            		
            }else{            	
            	oPopup.show(lefter,topper,200,ocont.offsetHeight, document.ChinaExcel);	
            }
            ocont.style.display='none';
        }else if(htmltype=="7"&&fieldtype=="1"){//特殊字段，自定义链接
            var urlid="";
            var url="";
            var urllink="";
            var urllinkno="";
            var i;
            var selvalue=new Array();
            var urlarr=new Array();
            var urlno=new Array();
            var oTable=document.getElementById("otable");
            var oDiv;
            var sHtml = "";
            var indexrow=parseInt(document.getElementById("indexrow").value);
            if(indexrow>0){
                for(i=(indexrow-1);i>=0;i--){
                    oTable.deleteRow(i);
                }
                indexrow=0;
            }
            try{
                urlid=document.getElementById(uservalue).value;
                var fieldstr=uservalue;
                if(uservalue.indexOf("_")>0){
                    fieldstr=uservalue.substring(0,uservalue.indexOf("_"));
                }
                url=document.getElementById(fieldstr+"_url").value;
                urllink=document.getElementById(fieldstr+"_urllink").value;
                urllinkno=document.getElementById(uservalue+"_linkno").value;
            }catch(e){}
            if(cellvalue!=null && cellvalue!=""){
                if(cellvalue.indexOf(",")>-1){
                    selvalue=cellvalue.split(",");
                    urlarr=urlid.split(",");
                    urlno=urllinkno.split(",");
                }else{
                    selvalue[0]=cellvalue;
                    urlarr[0]=urlid;
                    urlno[0]=urllinkno;
                }
				oTable.border=1;
                oRow = oTable.insertRow();
                oCell = oRow.insertCell();
                oCell.colSpan =2;
                oCell.style.fontSize="14px";
                oCell.style.color="blue";
                for(i=0;i<selvalue.length;i++){
                    if(sHtml.length>0){
                        sHtml+=" ";
                    }
                    if(urllink!=""){
                            sHtml+="<a href='#' onclick=\"parent.openWindowNoRequestid('"+urllink+"')\">"+selvalue[i]+"</a>";
                    }else{
                        sHtml+=selvalue[i];
                    }
                }
                oDiv = document.createElement("div");
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                indexrow++;
            }
            document.getElementById("indexrow").value=indexrow;
            var ocont=document.getElementById("ocontext");
            ocont.style.display='';
            oPopup.document.body.attachEvent("onmouseout",mouseout);
            oPopup.document.body.innerHTML = ocont.innerHTML; 
            oPopup.show(lefter,topper,200,ocont.offsetHeight, document.ChinaExcel);	
            ocont.style.display='none';
        }else{
            inprepDspDateInputName="";
			if(document.getElementById("inprepDspDateInputName")!=null){
				inprepDspDateInputName=document.getElementById("inprepDspDateInputName").value;
			}
			if(inprepDspDateInputName==uservalue&&selectshow!=0 && ismand>0){
				showPopupForInprepDspDate(uservalue,cellvalue,ismand,selectshow);
			}else{
				//hidePopup();
			}        
        }
    }
}

function showPopupCreateCodeAgain(uservalue,cellvalue,ismand,selectshow){

	var isShowPopupCreateCodeAgain=-1;
	if(document.getElementById("isShowPopupCreateCodeAgain")!=null){
		isShowPopupCreateCodeAgain=document.getElementById("isShowPopupCreateCodeAgain").value;
	}
	if(isShowPopupCreateCodeAgain!=1){
		return ;
	}

	getwidth();
    getHeight();
    if(!frmmain.ChinaExcel.ShowHeader){
		showwidth=showwidth;
    }else{
		showwidth=showwidth-20;
    }
    lefter =showwidth;
    topper =frmmain.ChinaExcel.GetMousePosY();

            var oTable=document.getElementById("otable");
            var oDiv;
            var sHtml = "";
            var indexrow=parseInt(document.getElementById("indexrow").value);

            if(indexrow>0){
                for(i=(indexrow-1);i>=0;i--){
                    oTable.deleteRow(i);
                }
                indexrow=0;
            }

            oRow = oTable.insertRow();
            oCell = oRow.insertCell();
            oCell.style.fontSize="14px";
            oCell.style.background="#e4e4e4";

			sHtml="";    
            var language=readCookie("languageidweaver");
            if(language==8){
				sHtml+="<button id=\"createCodeAgain\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.onCreateCodeAgain()\" title=\"Create Code Again\">Create Code Again</button><button id=\"onChooseReservedCode\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.onChooseReservedCode()\" title=\"Choose Reserved Code\">Choose Reserved Code</button><button id=\"onNewReservedCode\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.onNewReservedCode()\" title=\"New Reserved Code\">New Reserved Code</button>";
			}else if(language==9){
				sHtml+="<button id=\"createCodeAgain\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.onCreateCodeAgain()\" title=\"重新生成編號\">重新生成編號</button><button id=\"onChooseReservedCode\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.onChooseReservedCode()\" title=\"選擇預留號\">選擇預留號</button><button id=\"onNewReservedCode\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.onNewReservedCode()\" title=\"新建預留號\">新建預留號</button>";
			}else{
				sHtml+="<button id=\"createCodeAgain\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.onCreateCodeAgain()\" title=\"重新生成编号\">重新生成编号</button><button id=\"onChooseReservedCode\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.onChooseReservedCode()\" title=\"选择预留号\">选择预留号</button><button id=\"onNewReservedCode\" style=\"cursor:hand\" class=AddDoc onclick=\"this.disabled=true;parent.onNewReservedCode()\" title=\"新建预留号\">新建预留号</button>";
			}

            oDiv = document.createElement("div");
            oDiv.innerHTML = sHtml;
            oCell.appendChild(oDiv);
            
            indexrow++;

            document.getElementById("indexrow").value=indexrow;
            var ocont=document.getElementById("ocontext");
            ocont.style.display='';
            oPopup.document.body.attachEvent("onmouseout",mouseout);
            oPopup.document.body.innerHTML = ocont.innerHTML;             
            oPopup.show(lefter,topper,400,ocont.offsetHeight, document.ChinaExcel);	
            ocont.style.display='none';
}

function showPopupForInprepDspDate(uservalue,cellvalue,ismand,selectshow){

            var oTable=document.getElementById("otable");
            var oDiv;
            var sHtml = "";
            var indexrow=parseInt(document.getElementById("indexrow").value);
            if(indexrow>0){
                for(i=(indexrow-1);i>=0;i--){
                    oTable.deleteRow(i);
                }
                indexrow=0;
            }

			oTable.border=1;
			oRow = oTable.insertRow();
			oCell = oRow.insertCell();
			oCell.colSpan =2;
			oCell.style.fontSize="14px";
			oCell.style.color="blue";

			var inprepfrequenceTemp=document.getElementById("inprepfrequenceTemp").value;

			var yearTemp=document.getElementById("year").value;
			var monthTemp=document.getElementById("month").value;
			var dayTemp=document.getElementById("day").value;
			var currentYearTemp=document.getElementById("currentYearTemp").value;

			var language=readCookie("languageidweaver");

            var label_445="年";
            var label_6076="月";

			if(language==8){
				label_445="Year";
				label_6076="Month";
			}

			if(inprepfrequenceTemp==1||inprepfrequenceTemp==2||inprepfrequenceTemp==3||inprepfrequenceTemp==6||inprepfrequenceTemp==7){
				sHtml+=label_445+"：<select name=\"yearTemp\" onChange=\"parent.onChangeTempOnPopup('yearTemp',this.value)\">";
                for(iTemp=2 ; iTemp>-3;iTemp--) {
					tempyear = currentYearTemp - iTemp ;
					selected = "" ;
					if( yearTemp==tempyear){
						selected = "selected" ;
					}
					sHtml+="<option value=\""+tempyear+"\" "+selected+">"+tempyear+"</option>";
                }
				sHtml+="</select>";
			}

			if(inprepfrequenceTemp==2||inprepfrequenceTemp==3) {
				sHtml+=label_6076+"：<select name=\"monthTemp\" onChange=\"parent.onChangeTempOnPopup('monthTemp',this.value)\">";
				if(monthTemp=="01"){
					sHtml+="<option value=\"01\" selected>1</option>";
				}else{
					sHtml+="<option value=\"01\">1</option>";
				}
				if(monthTemp=="02"){
					sHtml+="<option value=\"02\" selected>2</option>";
				}else{
					sHtml+="<option value=\"02\">2</option>";
				}
				if(monthTemp=="03"){
					sHtml+="<option value=\"03\" selected>3</option>";
				}else{
					sHtml+="<option value=\"03\">3</option>";
				}
				if(monthTemp=="04"){
					sHtml+="<option value=\"04\" selected>4</option>";
				}else{
					sHtml+="<option value=\"04\">4</option>";
				}
				if(monthTemp=="05"){
					sHtml+="<option value=\"05\" selected>5</option>";
				}else{
					sHtml+="<option value=\"05\">5</option>";
				}
				if(monthTemp=="06"){
					sHtml+="<option value=\"06\" selected>6</option>";
				}else{
					sHtml+="<option value=\"06\">6</option>";
				}
				if(monthTemp=="07"){
					sHtml+="<option value=\"07\" selected>7</option>";
				}else{
					sHtml+="<option value=\"07\">7</option>";
				}
				if(monthTemp=="08"){
					sHtml+="<option value=\"08\" selected>8</option>";
				}else{
					sHtml+="<option value=\"08\">8</option>";
				}
				if(monthTemp=="09"){
					sHtml+="<option value=\"09\" selected>9</option>";
				}else{
					sHtml+="<option value=\"09\">9</option>";
				}
				if(monthTemp=="10"){
					sHtml+="<option value=\"10\" selected>10</option>";
				}else{
					sHtml+="<option value=\"10\">10</option>";
				}
				if(monthTemp=="11"){
					sHtml+="<option value=\"11\" selected>11</option>";
				}else{
					sHtml+="<option value=\"11\">11</option>";
				}
				if(monthTemp=="12"){
					sHtml+="<option value=\"12\" selected>12</option>";
				}else{
					sHtml+="<option value=\"12\">12</option>";
				}
				sHtml+="</select>";
			}

			if(inprepfrequenceTemp==3) {
				sHtml+="旬：<select name=\"dayTemp\" onChange=\"parent.onChangeTempOnPopup('dayTemp',this.value)\">";
				if(dayTemp<10){
					sHtml+="<option value=\"05\" selected>上旬</option>";
				}else{
					sHtml+="<option value=\"05\">上旬</option>";
				}
				if(dayTemp>=10&&dayTemp<20){
					sHtml+="<option value=\"15\" selected>中旬</option>";
				}else{
					sHtml+="<option value=\"15\">中旬</option>";
				}
				if(dayTemp>=20){
					sHtml+="<option value=\"25\" selected>下旬</option>";
				}else{
					sHtml+="<option value=\"25\">下旬</option>";
				}
				sHtml+="</select>";
			}

			if(inprepfrequenceTemp==6) {
				sHtml+="半年：<select name=\"monthTemp\"  onChange=\"parent.onChangeTempOnPopup('monthTemp',this.value)\">";
				if(monthTemp<7){
					sHtml+="<option value=\"01\" selected>上半年</option>";
				}else{
					sHtml+="<option value=\"01\">上半年</option>";
				}
				if(monthTemp>=7){
					sHtml+="<option value=\"07\" selected>下半年</option>";
				}else{
					sHtml+="<option value=\"07\">下半年</option>";
				}
				sHtml+="</select>";
			}

			if(inprepfrequenceTemp==7) {
				sHtml+="季：<select name=\"monthTemp\"  onChange=\"parent.onChangeTempOnPopup('monthTemp',this.value)\">";
				if(monthTemp<4){
					sHtml+="<option value=\"01\" selected>一季度</option>";
				}else{
					sHtml+="<option value=\"01\">一季度</option>";
				}
				if(monthTemp>=4&&monthTemp<7){
					sHtml+="<option value=\"04\" selected>二季度</option>";
				}else{
					sHtml+="<option value=\"04\">二季度</option>";
				}
				if(monthTemp>=7&&monthTemp<10){
					sHtml+="<option value=\"07\" selected>三季度</option>";
				}else{
					sHtml+="<option value=\"07\">三季度</option>";
				}
				if(monthTemp>=10){
					sHtml+="<option value=\"10\" selected>四季度</option>";
				}else{
					sHtml+="<option value=\"10\">四季度</option>";
				}
				sHtml+="</select>";
			}

			if(inprepfrequenceTemp==0||inprepfrequenceTemp==4||inprepfrequenceTemp==5) {
				var ModalDialog="window.showModalDialog('/systeminfo/Calendar.jsp','','dialogHeight:320px;dialogWidth:275px')";
                if(language==8){
					sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowInprepDspDateThis("+ModalDialog+",'"+uservalue+"',2,"+ismand+","+nowrow+","+nowcol+")\">[Please Select]";
			    }
			    else if(language==9){
					sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowInprepDspDateThis("+ModalDialog+",'"+uservalue+"',2,"+ismand+","+nowrow+","+nowcol+")\">[請選擇]";
			    }
			    else{
					sHtml="<img src=\"/images/BacoBrowser.gif\" style=\"cursor:hand\" onclick=\"parent.onShowInprepDspDateThis("+ModalDialog+",'"+uservalue+"',2,"+ismand+","+nowrow+","+nowcol+")\">[请选择]";
			    }
			}

			oDiv = document.createElement("div");
			oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);
			indexrow++;


			if(selectshow!=0 && ismand>0&&inprepfrequenceTemp!=0&&inprepfrequenceTemp!=4&&inprepfrequenceTemp!=5){
				oRow = oTable.insertRow();
				oCell = oRow.insertCell();
				oCell.style.fontSize="14px";
				oCell.style.background="#e4e4e4";


				if(language==8){
				    sHtml="<a href='#' onclick=\"parent.onChangeInprepDspDate('"+uservalue+"',"+nowrow+","+nowcol+")\">Confirm</a>";
				}
				else if(language==9){
				    sHtml="<a href='#' onclick=\"parent.onChangeInprepDspDate('"+uservalue+"',"+nowrow+","+nowcol+")\">確定</a>";
				}
				else{
				    sHtml="<a href='#' onclick=\"parent.onChangeInprepDspDate('"+uservalue+"',"+nowrow+","+nowcol+")\">确定</a>";
				}
				oDiv = document.createElement("div");
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);

				oCell = oRow.insertCell();
				oCell.style.color="blue";
				oCell.style.fontSize="14px";
				oCell.style.background="#e4e4e4";
				if(language==8){
				    sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">Clear Result</a>";
				}
				else if(language==9){
				    sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">清除結果</a>";
				}
				else{
				    sHtml="<a href='#' onclick=\"parent.clearobj('"+uservalue+"',"+nowrow+","+nowcol+")\">清除结果</a>";
				}
				oDiv = document.createElement("div");
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				indexrow++;
			}
			if(inprepfrequenceTemp==1||inprepfrequenceTemp==2||inprepfrequenceTemp==3||inprepfrequenceTemp==6||inprepfrequenceTemp==7){
				oRow = oTable.insertRow();
				oRow.style.height=200;
				oCell = oRow.insertCell();
				oCell.style.fontSize="14px";
				oCell.style.background="#e4e4e4";
				indexrow++;
			}
            document.getElementById("indexrow").value=indexrow;
            var ocont=document.getElementById("ocontext");
            ocont.style.display='';

            if(inprepfrequenceTemp==0||inprepfrequenceTemp==4||inprepfrequenceTemp==5){
				oPopup.document.body.attachEvent("onmouseout",mouseout);
				oPopup.document.body.innerHTML = ocont.innerHTML;
				oPopup.show(lefter,topper,250,ocont.offsetHeight, document.ChinaExcel);
			}else{
				oPopupInprepDspDate.document.body.innerHTML = ocont.innerHTML;
				oPopupInprepDspDate.show(lefter,topper,250,ocont.offsetHeight, document.ChinaExcel);
			}
            ocont.style.display='none';
}

function onChangeInprepDspDate(uservalue,nowrow,nowcol){

	var yearTemp="";
	var monthTemp="";
	var dayTemp="";
	var inprepDspDate="";

	if(document.getElementById("yearTemp")!=null){
		yearTemp=document.getElementById("yearTemp").value;
		document.getElementById("year").value=yearTemp;
	}
	if(document.getElementById("monthTemp")!=null){
		monthTemp=document.getElementById("monthTemp").value;
		document.getElementById("month").value=monthTemp;
	}
	if(document.getElementById("dayTemp")!=null){
		dayTemp=document.getElementById("dayTemp").value;
		document.getElementById("day").value=dayTemp;
	}

	var inprepfrequenceTemp=document.getElementById("inprepfrequenceTemp").value;
    if(inprepfrequenceTemp==1){
		inprepDspDate=yearTemp;
	}else if(inprepfrequenceTemp==2){
		inprepDspDate=yearTemp + "-"+monthTemp;
	}else if(inprepfrequenceTemp==3){
		inprepDspDate=yearTemp + "-"+monthTemp;
		if(dayTemp=="05"){
			inprepDspDate += " 上旬" ;
		}else if(dayTemp=="15"){
			inprepDspDate += " 中旬" ;
		}else if(dayTemp=="25"){
			inprepDspDate += " 下旬" ;
		}
	}else if(inprepfrequenceTemp==6){
		inprepDspDate=yearTemp;
		if(monthTemp=="01"){
			inprepDspDate += " 上半年" ;
		}else if(monthTemp=="07"){
			inprepDspDate += " 下半年" ;
		}
	}else if(inprepfrequenceTemp==7){
		inprepDspDate=yearTemp;
		if(monthTemp=="01"){
			inprepDspDate += " 一季度" ;
		}else if(monthTemp=="04"){
			inprepDspDate += " 二季度" ;
		}else if(monthTemp=="07"){
			inprepDspDate += " 三季度" ;
		}else if(monthTemp=="10"){
			inprepDspDate += " 四季度" ;
		}
	}

	frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,inprepDspDate)
	$G(uservalue).value=inprepDspDate
	imgshoworhide(nowrow,nowcol)
	frmmain.ChinaExcel.RefreshViewSize();
    hidePopup();
}

function onChangeTempOnPopup(objName,objValue){
	document.getElementById(objName).value=objValue;
}

function clearobj(uservalue,nowrow,nowcol){
    hidePopup();
    try{
        document.getElementById(uservalue).value="";
        DataInputByBrowser(uservalue);
    }catch(e){}
    frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,"");
    onShowFnaInfo(uservalue,nowrow);
    imgshoworhide(nowrow,nowcol);
    frmmain.ChinaExcel.RefreshViewSize();
}
function hidePopup()
{
    oPopup.hide();
    oPopupInprepDspDate.hide();
}
function DataInputByBrowser(fieldid){
    var fieldstr = fieldid;
    if (fieldid.indexOf("_") > 0) {
        fieldstr = fieldid.substring(0, fieldid.indexOf("_"));
    }
    if (trrigerfieldary != "" && trrigerfieldary.join("qwertyuiop").indexOf(fieldstr) != -1) {
        datainput(fieldid);
    } else if (trrigerdetailfieldary != "" && trrigerdetailfieldary.join("qwertyuiop").indexOf(fieldstr) != -1) {
        datainputd(fieldid);
    }
}
function imgshoworhide(nowrow,nowcol){
    var showtype=frmmain.ChinaExcel.GetCellUserValue(nowrow,nowcol);
    var cellvalue=frmmain.ChinaExcel.GetCellValue(nowrow,nowcol);
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nowrow,nowcol);
    if(uservalue!=null && uservalue!="" && uservalue.indexOf("_add")<0 && uservalue.indexOf("_del")<0 && uservalue.indexOf("_head")<0 && uservalue.indexOf("_end")<0 && uservalue.indexOf("_sel")<0&& uservalue.indexOf("_showKeyword")<0){
        if(uservalue=="requestname"){
          if(cellvalue!=null && cellvalue!=""){
          	frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
          	if(showtype==0) frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
          }else{
          	frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoError.gif",nowrow,nowcol,true,true);
          }
        }else if(uservalue=="qianzi"){
          if(cellvalue!=null && cellvalue!=""){
          	frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
          }else{
			  
			  var isSignMustInput=0;
			  if($G("isSignMustInput")!=null){
				  isSignMustInput=$G("isSignMustInput").value;
			  }

			  if(isSignMustInput==1){
				  frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoError.gif",nowrow,nowcol,true,true);
			  }
          }
        }else{
	        var index=uservalue.lastIndexOf("_");
	        var htmltype=0;
	        if(index>0){
	            htmltype=uservalue.substr(index+1);
	        }
	        var isProtect=frmmain.ChinaExcel.IsCellProtect(nowrow,nowcol);
	        if(isProtect){
	           frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,false);
	        }
	        if(showtype==2){
	            if(cellvalue!=null && cellvalue!=""){
	                frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
	            }else{
	                if(htmltype==3 || htmltype==6){
	                    frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoBrowser_b.gif",nowrow,nowcol,true,true);
	                }else{
	                    frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoError.gif",nowrow,nowcol,true,true);
	                }
	            }
	        }else if(showtype==1 && (htmltype==3 || htmltype==6)){
	            if(cellvalue!=null && cellvalue!=""){
	                frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
	            }else{
	                frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoBrowser.gif",nowrow,nowcol,true,true);
	            }
	        }
	        if(isProtect){
	           frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
	        }
	      }
    }
}

function imghide(nowrow,nowcol){
    var isprotect=frmmain.ChinaExcel.IsCellProtect(nowrow,nowcol);
    if(isprotect) frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,false);
    frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
    if(isprotect) frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
}

function ToExcel(){
    var maxcol=frmmain.ChinaExcel.GetMaxCol();
    var isformprotect=frmmain.ChinaExcel.FormProtect;
	if(isformprotect) frmmain.ChinaExcel.FormProtect=false;
    for(i=0;i<rowgroup.length;i++){
        var headrow=frmmain.ChinaExcel.GetCellUserStringValueRow("detail"+i+"_head");
        if(headrow>0){
            var nowrow=headrow+1;
            while(frmmain.ChinaExcel.IsRowHide(nowrow)){
                for(k=0;k<=maxcol;k++){
                    imghide(nowrow,k);
                }
                nowrow++;
            }
        }
    }
	var maxrow = frmmain.ChinaExcel.GetMaxRow();
	for(var ax=0; ax<=maxrow; ax++){
		for(var bx=0; bx<=maxcol; bx++){
			try{
				if(frmmain.ChinaExcel.GetCellCheckBoxValue(ax, bx)){
					frmmain.ChinaExcel.SetCellVal(ax, bx, "√");
				
				}
			}catch(e){}
		}
	
	}
	frmmain.ChinaExcel.OnSaveAsExcelFile();
	for(var ax=0; ax<=maxrow; ax++){
		for(var bx=0; bx<=maxcol; bx++){
			try{
				if(frmmain.ChinaExcel.GetCellCheckBoxValue(ax, bx)){
					frmmain.ChinaExcel.SetCellVal(ax, bx, "");
				
				}
			}catch(e){}
		}
	
	}
    if(isformprotect) frmmain.ChinaExcel.FormProtect=true;
}

function changevalue(uservalue,cellvalue,ismand){
		if(uservalue=="requestname"){
    		cellvalue=cellvalue.replace(/\r/g,"<br>");
    		cellvalue=cellvalue.replace(/\n/g,"");
    		document.getElementById(uservalue).value=cellvalue;
   	}else if(uservalue=="qianzi"){
    		cellvalue=cellvalue.replace(/\r/g,"<br>");
    		cellvalue=cellvalue.replace(/\n/g,"");
    		document.getElementById("remark").value=cellvalue;
   	}
   	else
    if(uservalue!=null && uservalue!="" && uservalue.lastIndexOf("_")>-1 && ismand>0){
        var htmltype=uservalue.substring(uservalue.lastIndexOf("_")+1);
        uservalue=uservalue.substring(0,uservalue.lastIndexOf("_"));
        var fieldtype=0;
        if(uservalue.lastIndexOf("_")>-1){
            fieldtype=uservalue.substring(uservalue.lastIndexOf("_")+1);
            uservalue=uservalue.substring(0,uservalue.lastIndexOf("_"));
        }
        //取消重新计算，解决滚动条会自动滚动到最前端问题
//        if(htmltype==1 && (fieldtype==2 || fieldtype==3)){
//			frmmain.ChinaExcel.ReCalculate();
//		}
        if(htmltype!="3" && htmltype!="5" && htmltype!="6" && ismand>0){
            cellvalue=cellvalue.replace(/\r/g,"<br>");
            cellvalue=cellvalue.replace(/\n/g,"");
         
      
            document.getElementById(uservalue).value=cellvalue;
            
        }
    }
}


function refresh(obj,fieldid){  
	var ocont=document.getElementById(fieldid+"file");
    oPopup.show(lefter,topper,250,ocont.offsetHeight, document.ChinaExcel);
    //var num=parseInt(document.getElementById(fieldid+'_num').value);
    var cellval="";
    //if(num>0){
        //addfj(fieldid,num);
        //cellval=frmmain.ChinaExcel.GetCellValue(nowrow,nowcol)+",";
    //}
    ocont.innerHTML=oPopup.document.body.innerHTML;
    //document.getElementById(fieldid+'_num').value=num+1;
    var objvalue=obj.value;
    frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,cellval+objvalue.substring(objvalue.lastIndexOf("\\")+1));
    frmmain.ChinaExcel.RefreshViewSize();
}
function addfj(fieldid,num){
    var oTable=document.getElementById(fieldid+"_tab");
    oRow = oTable.insertRow();
    oCell = oRow.insertCell();
    var oDiv = document.createElement("div");
    var sHtml = "<input type='file' size=15 id='"+fieldid+"_"+(num+1)+"' name='"+fieldid+"_"+(num+1)+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
}
function delfj(fieldid){
    var oTable=document.getElementById(fieldid+"_tab");
    var rows=parseInt(document.getElementById(fieldid+'_num').value);
    var i;
    if(rows-1>0){
        for(i=(rows-1);i>=0;i--){
           oTable.deleteRow(i);
        }
    }
}
function clearfile(fieldid){
    hidePopup();
    delfj(fieldid);
    document.getElementById(fieldid+'_num').value="0";
    frmmain.ChinaExcel.SetCellVal(nowrow,nowcol,"");
    frmmain.ChinaExcel.RefreshViewSize();
}
function rowIns(detailgroup,isedit,rows){
    rowIns(detailgroup,isedit,rows,"");
}
function rowIns(detailgroup,isedit,rows,changefields){
    rowIns(detailgroup,isedit,rows,changefields,"");
}
function rowIns(detailgroup,isedit,rows,changefields,nobodychangattr) 
{
	var num=0;
    var totalrow=0;
    var wcell=frmmain.ChinaExcel;
	for(j=0;j<rows;j++){		
		var headrow=wcell.GetCellUserStringValueRow("detail"+detailgroup+"_head");
		var nInsertAfterRow=wcell.GetCellUserStringValueRow("detail"+detailgroup+"_end");
		var selcol=wcell.GetCellUserStringValueCol("detail"+detailgroup+"_sel");
        num=parseInt(document.getElementById("indexnum"+detailgroup).value);
        totalrow=parseInt(document.getElementById("totalrow"+detailgroup).value);

		//复制行不为空
		if(headrow!=null && headrow!="" && nInsertAfterRow!=null && nInsertAfterRow!=""){
			//将新行加入提交字段
			if(document.getElementById('submitdtlid'+detailgroup)){
			if(document.getElementById('submitdtlid'+detailgroup).value==''){
				document.getElementById('submitdtlid'+detailgroup).value=num;
			}else{
				document.getElementById('submitdtlid'+detailgroup).value+=","+num;
			}
			}

            var workflowid=0;
			var nodeid=0;
			var stringseldefieldsadd="";
			var bodychangattrstr="";
			if(document.getElementById("workflowid")){
				workflowid=document.getElementById("workflowid").value;
			}
			if(document.getElementById("nodeid")){
				nodeid=document.getElementById("nodeid").value;
			}
			if(document.getElementById("stringseldefieldsadd")){
				stringseldefieldsadd=document.getElementById("stringseldefieldsadd").value;
			}

			//加入明细行id空值字段
			adddetail("dtl_id_"+detailgroup+"_"+num,"","","");

			var nInsertRows=rowgroup[detailgroup];
			wcell.SetCanRefresh(false);
			//插入空行
			wcell.SetRowHide(headrow+1,headrow+nInsertRows,false);
            wcell.InsertFormatRows(nInsertAfterRow-1,nInsertRows,headrow+1,headrow+nInsertRows);
			wcell.SetRowHide(headrow+1,headrow+nInsertRows,true);
			//列循环
			var initDetailFields = "";
			for(i=0;i<=wcell.GetMaxCol();i++){
                for(k=0;k<nInsertRows;k++){
                //获得cell对象
				var userstr=wcell.GetCellUserStringValue(nInsertAfterRow+k,i);
                var usershowtype=wcell.GetCellUserValue(nInsertAfterRow+k,i);
                if(userstr!=null && userstr!=""){
					if(userstr.indexOf("_sel")>0){
						
						wcell.SetCellCheckBoxValue(nInsertAfterRow+k,i,false);
					}else{
					var leftstr=userstr.substring(0,userstr.indexOf("_")+1);
					var rightstr=userstr.substring(userstr.indexOf("_")+1);
					userstr=leftstr+num+rightstr.substring(rightstr.indexOf("_"));
					var isprotect=wcell.IsCellProtect(nInsertAfterRow+k,i);
                    var values="";
                    var tfieldid=userstr.substring(5,userstr.indexOf("_"));    
                    //设置cell对象
					if(isprotect){
						wcell.SetCellProtect(nInsertAfterRow+k,i,nInsertAfterRow+k,i,false);
					}
                    wcell.SetCellUserStringValue(nInsertAfterRow+k,i,nInsertAfterRow+k,i,userstr);
                    if(isprotect){
						wcell.SetCellProtect(nInsertAfterRow+k,i,nInsertAfterRow+k,i,true);
					}
                    var htmltype=userstr.substring(userstr.lastIndexOf("_")+1);
                    var tempuserstr=userstr.substring(0,userstr.lastIndexOf("_"));
                    var detailtype=tempuserstr.substring(tempuserstr.lastIndexOf("_")+1);
                    if(htmltype==4){
                    		values=wcell.GetCellCheckBoxValue(nInsertAfterRow+k,i);
                        wcell.SetCellCheckBoxValue(nInsertAfterRow+k,i,values);
                        wcell.SetCellProtect(nInsertAfterRow+k,i,nInsertAfterRow+k,i,true);
                        if(values=='true') values = 1;
                        else values = 0;
                    }
					if(htmltype==3 || htmltype==6){
						try{
							if(htmltype==3&&(detailtype==1||detailtype==17||detailtype==165||detailtype==166)&&$G("userid").value!=null)
								values=$G("userid").value;
							else if(htmltype==3&&(detailtype==8||detailtype==135)) values=$G("relatedPrjId").value;
							else if(htmltype==3&&(detailtype==9||detailtype==37)) values=$G("relatedDocId").value;
							else if(htmltype==3&&(detailtype==7||detailtype==18)) values=$G("relatedCrmId").value;
							// 加上 分权单分部   分权多分部两个类型
							else if(htmltype==3&& (detailtype==164 || detailtype==169 || detailtype==170)) values=$G("subcompanyidofuser").value;
							else if(htmltype==3&&(detailtype==4||detailtype==57||detailtype==167||detailtype==168)) values=$G("departmentidofuser").value;
                            else if(htmltype==3&&detailtype==24) values=$G("jobtitleidofdefaultuser").value;
							else values=wcell.GetCellValue(nInsertAfterRow+k,i);
							}catch(e){}
                        wcell.SetCellProtect(nInsertAfterRow+k,i,nInsertAfterRow+k,i,true);
                    }
                    if(htmltype==5){
                        values=wcell.GetCellComboSelectedActualValue(nInsertAfterRow+k,i);

						var tempstringseldefieldsadd=","+stringseldefieldsadd+",";
						var temptfieldid=","+tfieldid+",";
						if(tempstringseldefieldsadd.indexOf(temptfieldid)>-1){
							if(nobodychangattr!="1"){
								bodychangattrstr+="changeshowattrBymode('"+tfieldid+"_1','"+values+"',"+num+","+workflowid+","+nodeid+");";
							}
						}
                    }
                    var oldfieldshowattr="";
                    //是否为联动字段改变的字段，是则隐藏字段的显示属性值，“显示属性_字段名称”
                    if((changefields+",").indexOf(tfieldid)>=0) oldfieldshowattr=nInsertRows+"|"+usershowtype+"|"+userstr;    
                    //在隐藏table中加入相同空对象
                    adddetail(leftstr+num,values,oldfieldshowattr,htmltype);
                    initDetailFields += leftstr+num+",";
                    if(usershowtype==2){
						var checkfield=$G("needcheck").value;	
						$G("needcheck").value=checkfield+","+leftstr+num;
                        if(htmltype==3 || htmltype==6){
                            wcell.ReadHttpImageFile("/images/BacoBrowser_b.gif",nInsertAfterRow+k,i,true,true);
                        }else if(htmltype==5&&values>-1&&values!=''){
                             wcell.DeleteCellImage(nInsertAfterRow+k,i,nInsertAfterRow+k,i);
                        }else{
                            wcell.ReadHttpImageFile("/images/BacoError.gif",nInsertAfterRow+k,i,true,true);
                        }
                    }
                    imgshoworhide(nInsertAfterRow+k,i);
					}
				}
			    }
            }
            
			if(isedit!=1){
			 //wcell.GoToCell(nInsertAfterRow,selcol);
			wcell.SetCellCheckBoxValue(nInsertAfterRow,selcol,false);
			datainputd(initDetailFields);
			}
			wcell.SetCanRefresh(true);			
			wcell.RefreshViewSize();			
			wcell.ReCalculate();
			num++;
            totalrow++;
            document.getElementById("indexnum"+detailgroup).value=num;
            document.getElementById("nodesnum"+detailgroup).value=num;
            document.getElementById("totalrow"+detailgroup).value=totalrow;

			if(bodychangattrstr!=""){
				eval(bodychangattrstr);
			}
		}
	}
}
//在hidden_tab中装载空值字段，每字段占用一行
function adddetail(fieldname,values,oldfieldshowattr,htmltype){
	var tempfieldname = "";
	if(fieldname.length > 7){
		tempfieldname = fieldname.substring(0,7);
	}
	var isDel_id = false;
	var temmtitlevalue="";
	if(tempfieldname != "dtl_id_"){
		tempfieldname = fieldname.substring(0, fieldname.indexOf("_"));
		try{
			temmtitlevalue = document.getElementsByName("temp_"+tempfieldname)[0].value;
		}catch(e){}
	}else{
		isDel_id = true;
	}

	value_field = values;
	var fieldid = "";
	if(isDel_id == false){
		try{
			fieldid = fieldname.substring(5,fieldname.indexOf("_"));
	        indexOfFieldid = inoperatefieldArray.indexOf(fieldid);
			if(indexOfFieldid>-1){
				value_field = inoperatevalueArray[indexOfFieldid];
			}
		}catch(e){}
	}
	try{
		if(fieldid!="" && temmtitlevalue==""){
			temmtitlevalue = document.getElementsByName("field"+fieldid)[0].getAttribute("temptitle");
		}
	}catch(e){}
    var oTable=document.getElementById("hidden_tab");
    oRow = oTable.insertRow();
	oRow.id="tr"+fieldname;
    oCell = oRow.insertCell();
    var oDiv = document.createElement("div");
    var sHtml = "";
    if(isDel_id == true){
    	sHtml = "<input type='hidden' id='"+fieldname+"' name='"+fieldname+"' value='"+value_field+"'>";
    }else{
	    sHtml = "<input type='text' temptitle='"+temmtitlevalue+"' id='"+fieldname+"' name='"+fieldname+"' value='"+value_field+"'>";
	    if(oldfieldshowattr!=null&&oldfieldshowattr!=""){
	        sHtml+="<input type='hidden' id='old"+fieldname+"' name='old"+fieldname+"' value='"+oldfieldshowattr+"'>";
	    }
	    if(htmltype==3){
	        sHtml+="<input type='hidden' name='"+fieldname+"_url' value=''><input type='hidden' name='"+fieldname+"_urllink' value=''>";
	    }
    }
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
    //if(isDel_id == false){
		//DataInputByBrowser(fieldname);
    //}
}
//在hidden_tab中删除字段
function deldetail(fieldname){
    var oTable=document.getElementById("hidden_tab");
	var rows=oTable.rows;
    var checkfield=$G("needcheck").value+",";
    for(var i=0;i<rows.length;i++){
		if(rows[i].id=="tr"+fieldname){
			var tag=","+fieldname+",";
            checkfield=checkfield.replace(tag,",");
            $G("needcheck").value=checkfield.substr(0,checkfield.length-1);
            oTable.deleteRow(i);
		}
	}
}
function checktimeok(){//结束日期不能小于开始日期 -->
    return true;
}
function chinaexcelregedit(){
    frmmain.ChinaExcel.Login("泛微软件","891e490cd34e3e33975b1b7e523e8b32","上海泛微网络技术有限公司");
}
function changeshowattrBymode(fieldid,fieldvalue,rownum,workflowid,nodeid){
    len = document.forms[0].elements.length;
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowChangeShowAttrAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("workflowid="+workflowid+"&nodeid="+nodeid+"&fieldid="+fieldid+"&fieldvalue="+fieldvalue);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            var allreturnvalues=ajax.responseText;
            var allreturnvaluesarray=allreturnvalues.split("+");
            for(t=0;t<allreturnvaluesarray.length;t++){
            
            var returnvalues = allreturnvaluesarray[t];
            if(returnvalues!=""){
                //var tfieldid=fieldid.split("_");
                //var isdetail=tfieldid[1];
                var fieldarray=returnvalues.split("&");
                for(n=0;n<fieldarray.length;n++){
                    var fieldattrs=fieldarray[n].split("$");
                    var fieldids=fieldattrs[0];
                    var fieldattr=fieldattrs[1];
                    var fieldidarray=fieldids.split(",");
                    if(fieldattr==-1){ //没有设置联动，恢复原值和恢复原显示属性
                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==tfieldidarray[1]){
                                    if(rownum>-1){  //明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&document.getElementById('oldfield'+tfieldidarray[0]+"_"+rownum)){
                                            oldfieldview=document.getElementById('oldfield'+tfieldidarray[0]+"_"+rownum).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1){
                                                var insertrows=oldfieldviewarry[0];
                                                var isedit=oldfieldviewarry[1];
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                if(rownum==0){
                                                    nowrow=parseInt(nowrow)+parseInt(insertrows);
                                                }
                                                var checkstr_=$G("needcheck").value+",";
                                                if(isedit==2){
                                                    imgshowChange(nowrow,nowcol,2);
                                                    if(checkstr_.indexOf("field"+tfieldidarray[0]+"_"+rownum+",")<0) $G("needcheck").value=checkstr_+"field"+tfieldidarray[0]+"_"+rownum;
                                                }
                                                if(isedit==1){
                                                    imgshowChange(nowrow,nowcol,1);
                                                    $G("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+"_"+rownum+",","");
                                                }
                                            }
                                        }
                                    }else{     //主字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&document.getElementById('oldfield'+tfieldidarray[0])){
                                            oldfieldview=document.getElementById('oldfield'+tfieldidarray[0]).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1){
                                                var isedit=oldfieldviewarry[1];
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                var checkstr_=$G("needcheck").value+",";
                                                if(isedit==2) {
                                                    imgshowChange(nowrow,nowcol,2);
                                                    if(checkstr_.indexOf("field"+tfieldidarray[0]+",")<0) $G("needcheck").value=checkstr_+"field"+tfieldidarray[0];
                                                }
                                                if(isedit==1) {
                                                    imgshowChange(nowrow,nowcol,1);
                                                    $G("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+",","");
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(fieldattr==1){//为编辑，显示属性设为编辑
                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==tfieldidarray[1]){
                                    if(rownum>-1){  //明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&document.getElementById('oldfield'+tfieldidarray[0]+"_"+rownum)){
                                            oldfieldview=document.getElementById('oldfield'+tfieldidarray[0]+"_"+rownum).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1&&oldfieldviewarry[1]>0){
                                                var insertrows=oldfieldviewarry[0];
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                var checkstr_=$G("needcheck").value+",";
                                                if(rownum==0){
                                                    nowrow=parseInt(nowrow)+parseInt(insertrows);
                                                }
                                                imgshowChange(nowrow,nowcol,1);
                                                $G("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+"_"+rownum+",","");
                                            }
                                        }
                                    }else{     //主字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&document.getElementById('oldfield'+tfieldidarray[0])){
                                            oldfieldview=document.getElementById('oldfield'+tfieldidarray[0]).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1&&oldfieldviewarry[1]>0){
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                var checkstr_=$G("needcheck").value+",";
                                                imgshowChange(nowrow,nowcol,1);
                                                $G("needcheck").value=checkstr_.replace("field"+tfieldidarray[0]+",","");
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(fieldattr==2){//为必填，显示属性设为编辑
                        for(i=0;i<len;i++){
                            for(j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                if (tfieldidarray[1]==tfieldidarray[1]){
                                    if(rownum>-1){  //明细字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]+"_"+rownum&&document.getElementById('oldfield'+tfieldidarray[0]+"_"+rownum)){
                                            oldfieldview=document.getElementById('oldfield'+tfieldidarray[0]+"_"+rownum).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1&&oldfieldviewarry[1]>0){
                                                var insertrows=oldfieldviewarry[0];
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                if(rownum==0){
                                                    nowrow=parseInt(nowrow)+parseInt(insertrows);
                                                }
                                                var checkstr_=$G("needcheck").value+",";
                                                imgshowChange(nowrow,nowcol,2);
                                                if(checkstr_.indexOf("field"+tfieldidarray[0]+"_"+rownum+",")<0) $G("needcheck").value=checkstr_+"field"+tfieldidarray[0]+"_"+rownum;
                                            }
                                        }
                                    }else{     //主字段
                                        if(document.forms[0].elements[i].name=='field'+tfieldidarray[0]&&document.getElementById('oldfield'+tfieldidarray[0])){
                                            oldfieldview=document.getElementById('oldfield'+tfieldidarray[0]).value;
                                            oldfieldviewarry=oldfieldview.split("|");
                                            if(oldfieldviewarry.length>1&&oldfieldviewarry[1]>0){
                                                var changefieldid=oldfieldviewarry[2];
                                                var nowrow=frmmain.ChinaExcel.GetCellUserStringValueRow(changefieldid);
                                                var nowcol=frmmain.ChinaExcel.GetCellUserStringValueCol(changefieldid);
                                                var checkstr_=$G("needcheck").value+",";
                                                imgshowChange(nowrow,nowcol,2);
                                                if(checkstr_.indexOf("field"+tfieldidarray[0]+",")<0) $G("needcheck").value=checkstr_+"field"+tfieldidarray[0];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            }
            frmmain.ChinaExcel.Refresh();
            //alert($G("needcheck").value);
            }catch(e){}
        }
    }
}
function imgshowChange(nowrow,nowcol,showtype){
    var cellvalue=frmmain.ChinaExcel.GetCellValue(nowrow,nowcol);
    cellvalue = Simplized(cellvalue);
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nowrow,nowcol);
    if(uservalue!=null && uservalue!="" && uservalue.indexOf("_add")<0 && uservalue.indexOf("_del")<0 && uservalue.indexOf("_head")<0 && uservalue.indexOf("_end")<0 && uservalue.indexOf("_sel")<0&& uservalue.indexOf("_showKeyword")<0){

	        var index=uservalue.lastIndexOf("_");
	        var htmltype=0;
	        if(index>0){
	            htmltype=uservalue.substr(index+1);
	        }
	        var isProtect=frmmain.ChinaExcel.IsCellProtect(nowrow,nowcol);
	        if(isProtect){
	           frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,false);
	        }
            frmmain.ChinaExcel.SetCellUserValue(nowrow,nowcol,nowrow,nowcol,showtype);
            if(showtype==2){
                if(cellvalue==null || cellvalue==""){
                    frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
                    if(htmltype==3 || htmltype==6){
                        frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoBrowser_b.gif",nowrow,nowcol,true,true);
	                }else{
                        frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoError.gif",nowrow,nowcol,true,true);
	                }
	            }
	        }else if(showtype==1){
                if(cellvalue==null || cellvalue==""){
                    frmmain.ChinaExcel.DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
                    if(htmltype==3 || htmltype==6){
                        frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoBrowser.gif",nowrow,nowcol,true,true);
                    }
                }
            }
	        if(isProtect){
	           frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
	        }
    }
}
function getFirstRowNo(objid){
    var rowno=frmmain.ChinaExcel.GetCellUserStringValueRow (objid)
    var objidary=objid.split("_");
    if(objidary[1]==0){
        rowno=FirstRowNo(objid);
    }
    return rowno;
}
function resetsubmitdtlid(tmpstr){
	var tsz = tmpstr.split("_");
	var delid_tmp = tsz[0];
	var groupid_tmp = tsz[1];
	var submitdtlidArray=document.getElementById("submitdtlid"+groupid_tmp).value.split(",");
    document.getElementById("submitdtlid"+groupid_tmp).value="";
    var k;
    for(k=0; k<submitdtlidArray.length; k++){
        if(submitdtlidArray[k]!=delid_tmp){
            if(document.getElementById("submitdtlid"+groupid_tmp).value==''){
                document.getElementById("submitdtlid"+groupid_tmp).value = submitdtlidArray[k];
            }else{
                document.getElementById("submitdtlid"+groupid_tmp).value += ","+submitdtlidArray[k];
            }
        }
    }
}

function json2String(josinobj) {
	if (josinobj == undefined || josinobj == null) {
		return "";
	}
	var ary = "";
	var _index = 0;
	try {
		for(var key in josinobj){
			if (_index++ > 0) {
				ary += "(~!@#$%^&*)";
			}
			ary += josinobj[key];
		}
	} catch (e) {}
	return ary;
}