function addRow(){
        var oRow;      
        oRow = tblTask.insertRow(-1);     
        oRow.className="DataLight";  
        iRowIndex++ ;
        if(RowindexNum==undefined){
        	RowindexNum=0;
        	iRowIndex=0;
        }
        RowindexNum++;
        oRow.id="tr_"+iRowIndex;
        oRow.customIndex = iRowIndex;
        for (var i = 1; i <= 10; i++) {
            oCell = oRow.insertCell(-1);
    		oCell.align = "left";
           
            var oDiv = document.createElement("div");
            var sHtml=""; 
            switch (i){               
               case 1: //编号	                    
                    oCell.style.backgroundColor="#e7e7e7";
					if(readCookie("languageidweaver")==8){
						oCell.title="click then move"; 
					}
					if(readCookie("languageidweaver")==9){
						oCell.title="單擊選中然後可拖動";
					}
					else {
						oCell.title="单击选中 然后可拖动";  
					}	                        
                    oCell.onclick=function(){onDragTDDBClick(this);};
                    sHtml=RowindexNum+"<input type='hidden' name='templetTaskId' value='-1'><input type='hidden' name='txtRowIndex' id='txtRowindex_"+iRowIndex+"' value='"+iRowIndex+"'>";
                    break ;
                case 2: //checkbox 框	                    
                    sHtml="<input type='checkbox' class='inputStyle' name='chkTaskItem' id='chkTaskItem_"+iRowIndex+"' value='"+iRowIndex+"'>";                   
                    break ;
				case 3: //任务名称	
                    oCell.align = "right";
                    sHtml="<table><tr width='100%'><td><div id='taskNameDiv_"+iRowIndex+"' align='right'  valign='bottom'><img id='img_"+iRowIndex+"' style='visibility:hidden;cursor:pointer' src='/images/project_rank.gif' onclick='onImgClick(this,"+iRowIndex+")' imgState='show' ><div></td><td><input type='txtTaskName' class='inputStyle' name='txtTaskName'      id='txtTaskName_"+iRowIndex+"' onchange='onTaskNameChange(this,"+iRowIndex+")' size='24'  customIndex='"+iRowIndex+"'></td></tr></table>";  
                    break ;
                case 4: //工期						
                    sHtml="<input type='txtWorkLong' class='inputStyle' name='txtWorkLong'  size='4' id='txtWorkLong_"+iRowIndex+"'  onKeyPress='ItemNum_KeyPress(this)' onchange='onWorkLongChange(this,txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+")'>"; 
                    break ;
                case 5: //开始时间						
                    sHtml="<button type=\"button\" class=Calendar onclick='onShowBeginDate(txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>"+
                          "<SPAN id=spanBeginDate_"+iRowIndex+" ></SPAN>"+
                          "<input type='hidden' name='txtBeginDate' id='txtBeginDate_"+iRowIndex+"'>";                
                    break ;
                case 6: //结束时间						
                   sHtml="<button type=\"button\" class=Calendar onclick='onShowEndDate(txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>"+
                          "<SPAN id=spanEndDate_"+iRowIndex+" ></SPAN>"+
                          "<input type='hidden' name='txtEndDate' id='txtEndDate_"+iRowIndex+"'>";                
                   break ;
                case 7: //前置任务						
                    //sHtml="<select name='seleBeforeTask' id='seleBeforeTask_"+iRowIndex+"'  onchange='onBeforeTaskChange(this,"+iRowIndex+")'><option value='0'></option></select>";
                	sHtml="<button type=\"button\" class=Browser onclick='onSelectBeforeTask(seleBeforeTaskSpan_"+iRowIndex+",seleBeforeTask_"+iRowIndex+")'></button><input type=hidden name='seleBeforeTask' id='seleBeforeTask_"+iRowIndex+"' value=''  oninput='beforeTask_check(this)'  onpropertychange='beforeTask_check(this)'><span id='seleBeforeTask_TD'><span id='seleBeforeTaskSpan_"+iRowIndex+"'></span></span><input type=hidden name='index_"+iRowIndex+"' id='index_"+iRowIndex+"' value='"+iRowIndex+"'>";
                    break ;
                case 8: //预算	 					
                    sHtml="<input type='text' class='inputStyle' name='txtBudget' size='8' id='txtBudget_"+iRowIndex+"' onKeyPress='ItemNum_KeyPress(this)'>";                
                    break ;
                case 9: //负责人		
                    //sHtml="<select  name='txtManager' id='txtManager_"+iRowIndex+"'  ><option value='0'></option></select>";
                	sHtml="<button type=\"button\" class=Browser onclick='onSelectManager(txtManagerSpan_"+iRowIndex+",txtManager_"+iRowIndex+")'></button><input type=hidden name='txtManager' id='txtManager_"+iRowIndex+"' value=''><span id='txtManagerSpan_"+iRowIndex+"'></span>";
                    break ;
                case 10: //升降级	                ;<a href='javaScript:downLevel("+iRowIndex+")'
					if(readCookie("languageidweaver")==8){
						sHtml="<img title='up' src='/images/leftup.gif' border='0' onclick='upLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></img>&nbsp;&nbsp<img  title='down'     src='/images/rightDown.gif' border='0'  onclick='downLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></img>";               
					}
					else if(readCookie("languageidweaver")==9)
					{
						sHtml="<img title='升級' src='/images/leftup.gif' border='0' onclick='upLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></ img>&nbsp;&nbsp<img title='降級' src='/images/rightDown.gif' border='0' onclick='downLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></img>";
					}
					else {						
						sHtml="<img title='升级' src='/images/leftup.gif' border='0' onclick='upLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></img>&nbsp;&nbsp<img  title='降级'     src='/images/rightDown.gif' border='0'  onclick='downLevel("+iRowIndex+")' style='cursor:pointer;width:20px'></img>";                      
					}	                    
                    break ;
                default:
                    sHtml=" ";                
                    break ;
            }
            //alert(sHtml)
            oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);              
        }
        //把节点加入文档对像中                 
        addNode(iRowIndex)

        //多加一行
        oRow = tblTask.insertRow(-1); 
        oRow.className="Line";
        oCell = oRow.insertCell(-1)
        oCell.colSpan="10";

        //移动到相应的结点下去

      // addRowNeedMove(iRowIndex,lastSelectedTRObj);
    }

    function addOption(idStr,valueStr,rowIndex){
          var txtManagerObj3 = document.getElementById("txtManager_"+rowIndex);                           
          txtManagerObj3.options.add(new Option(valueStr,idStr));
    }

    function removeAllManager(){
    	//修改项目成员时不做任何事情
    }
    
    function getAllSelelt(){
    	var resultStr = "";
    	var txtManagerObjs = document.getElementsByName("txtManager");  
         for (var i=0;i<txtManagerObjs.length;i++){
             var obj = txtManagerObjs[i];
             resultStr += obj.value+"|";
         }
         return resultStr;
    }
    
    function addSeleValue (oldSelectValue){
    	//修改项目成员时不做任何事情    	
    }

	function isContainValue(selectObj,optionValue) {
		for (var i=0;i<selectObj.options.length ;i++ )	{
			var option = selectObj.options.item(i);
			if (option.value==optionValue)	return "true";
		}
		return "false";
	}
    function getObj(objId){
        try {
            var obj = document.getElementById(objId);
            return obj;
        } catch(ex){
            return null;
        }

    }

	function getUseableRowIndex(){
        try {
           var objTRs=tblTask.getElementsByTagName("TR");
		   var returnIndex=null;
		   if(objTRs!=null){
			   for(var i=0;i<objTRs.length;i++){
				   if(i>10) break;				  
				   if(objTRs[i].customIndex!=null) {
					   returnIndex=objTRs[i].customIndex;
					   //alert(objTRs[i].customIndex)
					   break;
				   }
			   }
		   }
		   return returnIndex;
        } catch(ex){
            return null;
        }

    }

    function onCheckAll(obj){
        var taskItems = document.getElementsByName("chkTaskItem");
        for (var i=0;i<taskItems.length;i++){
            taskItems[i].checked= obj.checked ;
        }
    }

    function onTaskNameChange(txtObj,rowIndex){      
    	/**
		var seleBeforeTaskObjs = document.getElementsByName("seleBeforeTask");
		if(seleBeforeTaskObjs == "[object]"){
			alert("");
			return;
		}
		for (var i=0;i<seleBeforeTaskObjs.length;i++){
			var selectValue = seleBeforeTaskObjs[i].value ;
			
			var optionIndex = getOptionIndex( seleBeforeTaskObjs[i].options,rowIndex);
			if (optionIndex!=-1)  seleBeforeTaskObjs[i].options.remove(optionIndex);     
			if (txtObj.value!="") {
				seleBeforeTaskObjs[i].options.add(new Option(txtObj.value,rowIndex),optionIndex) ;			
				seleBeforeTaskObjs[i].value = selectValue;
			}
		}   
		*/     
    }

    function getOptionIndex (optionsObj,objValue){
        for (var i=0 ;i<optionsObj.length;i++){
            if (optionsObj[i].value == objValue){
                return i;
            }
        }
        return -1;
    }
    
    //判断前置任务是否合法 by alan
    function beforeTask_check(obj) {
    	var oldindex = -1;
    	var oldobjs = document.getElementsByName('seleBeforeTask');
    	for(var i=1; i<=oldobjs.length; i++) {
    		if(oldobjs[i-1]==obj) {
    			oldindex = i;
    		}
    	}
    	var tdobjs = $('#seleBeforeTask_TD');
    	if(oldindex==obj.value) {
    		$(tdobjs[oldindex-1]).find('span').html("");
    		$(obj).val("0");
			if(readCookie("languageidweaver")==8){
				alert("Can't let hisself set his prefix task!");
			} 
			else if(readCookie("languageidweaver")==9){ 
				alert("不能把本身設置為前置任務!"); 
			}
			else {
				alert("不能把本身设置为前置任务!"); 
			}
    	}
    }

    //当前值任务改变的时候
    function onBeforeTaskChange(obj,selfIndex){
        var beforeTaskValue = obj.value;	
        if (beforeTaskValue==0) return false;
	
		
        //得到本身任务的对象
         var selfTaskBeginDateObj = document.getElementById("txtBeginDate_"+selfIndex);
         var selfTaskBeginDateSpanObj = document.getElementById("spanBeginDate_"+selfIndex);

         var selfTaskEndDateObj = document.getElementById("txtEndDate_"+selfIndex);
         var selfTaskEndDateSpanObj = document.getElementById("spanEndDate_"+selfIndex);

         var selfWorkLongObj = document.getElementById("txtWorkLong_"+selfIndex);

   
        //得到前置任何的对象
         var beforeTaskBeginDateObj = document.getElementById("txtBeginDate_"+beforeTaskValue);
         var beforeTaskBeginDateSpanObj = document.getElementById("spanBeginDate_"+beforeTaskValue);

         var beforeTaskEndDateObj = document.getElementById("txtEndDate_"+beforeTaskValue);
         var beforeTaskEndDateSpanObj = document.getElementById("spanEndDate_"+beforeTaskValue);

         var beforeWorkLongObj = document.getElementById("txtWorkLong_"+beforeTaskValue);

            //如果前置任务的结束时间大于本身任务的开始时间 那么修改本身任务的时间
         if (beforeTaskEndDateObj.value>selfTaskBeginDateObj.value||selfTaskBeginDateObj.value=='') {
            var newValue = getAddNewDateStr(beforeTaskEndDateObj.value,2);
            selfTaskBeginDateObj.value = newValue;
            selfTaskBeginDateSpanObj.innerHTML = newValue;
            if (selfWorkLongObj.value!="") {
                var newValue2 =getAddNewDateStr(selfTaskBeginDateObj.value,parseInt(selfWorkLongObj.value));
                selfTaskEndDateObj.value = newValue2;
                selfTaskEndDateSpanObj.innerHTML=newValue2;
            }
         }    
		 
		 	
		//判断前置任务选择的是不是其本身
		//得到得到本身任务的名称	
		//alert(beforeTaskValue+" "+selfIndex);
		if (beforeTaskValue==selfIndex)	{
			if(readCookie("languageidweaver")==8){
				alert("Can't let hisself set his prefix task!");
			} 
			else if(readCookie("languageidweaver")==9){ 
				alert("不能把本身設置為前置任務!"); 
			}
			else {
				alert("不能把本身设置为前置任务!"); 
			}	
			obj.value=0;	
			return false;
		}
   }
  //计算天数差的函数，通用
  //如果返回为-1 表示,sDate1比sDate2小
  function dateDiffForJava(sDate1, sDate2){  //sDate1和sDate2是2002-12-18格式
    var aDate, oDate1, oDate2, iDays
    oDate1=new Date(sDate1);
	oDate2=new Date(sDate2);
	if(""+oDate1.getFullYear()=="NaN"){
		aDate = sDate1.split("-")
	    oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])  //转换为12-18-2002格式
	    aDate = sDate2.split("-")
	    oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])
    }
	if (oDate2-oDate1>=0) {
        iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 /24)  //把相差的毫秒数转换为天数
        iDays=iDays+1;
    } else {        
		iDays = -1 	    
	}
    return iDays
  }

//判断input框中是否输入的是数字,包括小数点
  function ItemNum_KeyPress(obj){
     var event=getEvent();
	  tmpvalue = obj.value;
     var count = 0;
     var len = -1;
     len = tmpvalue.length; 
     for(i = 0; i < len; i++){
        if(tmpvalue.charAt(i) == "."){
        count++;     
        }
     }
     if(!((event.keyCode>=48 && event.keyCode<=57) || (event.keyCode==46 &&len>=1&& count == 0))) {           
    	 event.keyCode=0;         
      }
  }

  function upLevel(rowIndex){
		moveNodeUp(rowIndex);
		modiChildsSize();
  }

  function downLevel(rowIndex){        
	  moveNodeDown(rowIndex);
	  modiChildsSize();
  }

 function onImgClick(obj,rowIndex){   
    if ($(obj).attr("imgState")=='show'){
        obj.src='/images/project_rank2.gif'
        obj.imgState='hidden'
        	showTRchilds(rowIndex,"hidden");
    } else {
        obj.src='/images/project_rank.gif'
        obj.imgState='show'
        	showTRchilds(rowIndex,"visible");
    }
 }
  
 function onHiddenImgClick(divObj,imgObj){
     if (imgObj.objStatus=="show"){
        divObj.style.display='none' ;       
        imgObj.src="/images/down.jpg";
		if(readCookie("languageidweaver")==8){
			imgObj.title="click then expand";
		}
		else if(readCookie("languageidweaver")==9){ 
			imgObj.title="點擊展開"; 
		}
		else {
			imgObj.title="点击展开";
		}	       
        imgObj.objStatus="hidden";
        if (divObj==divTaskList){
            divAddAndDel.style.display='none' ; 
        }
     } else {        
        divObj.style.display='' ;    
        imgObj.src="/images/up.jpg";
		if(readCookie("languageidweaver")==8){
			imgObj.title="click then hidden";
		}
		else if(readCookie("languageidweaver")==9){ 
			imgObj.title="點擊隱藏"; 
		}
		else {
			imgObj.title="点击隐藏";
		}        
        imgObj.objStatus="show";
        if (divObj==divTaskList){

            divAddAndDel.style.display='' ; 
        }
     }
 }
   function  getXmlDocStr1(){      
        str = ptu.getXmlDocStr();
        document.all("areaLinkXml").value=  str ;    
   }


 function addSelManager(strId,strValue){ 
	 //修改项目人员时不做任何处理
  }
 
  function protectProjTemplet(event){ 
  	//if(!checkDataChange()) {//added by cyril on 2008-06-12 for TD:8828
			if(readCookie("languageidweaver")==8){
				return event.returnValue="Project templet isn't save. if you left data will be lost ,are you srue?";
			}
			else if(readCookie("languageidweaver")==9)
			{
				return event.returnValue="項目模板還沒保存，如果離開，將會丟失數據，真的要離開嗎？";
			}
			else {
				return event.returnValue="项目模板还没保存，如果离开，将会丢失数据，真的要离开吗？";
				//return("当前页面的修改没有保存，确认退出？");
			} 
	//	}        
  }

  function protectProj(e){ 
  	//if(!checkDataChange()) {//added by cyril on 2008-06-12 for TD:8828
		/*  if(readCookie("languageidweaver")==8){
			    event.returnValue="Project  isn't save. if you left data will be lost ,are you srue?";			
			} 
			else if(readCookie("languageidweaver")==9)
			{
				event.returnValue="項目還沒保存，如果離開，將會丟失數據，真的要離開嗎？";
			} 
			else {
				event.returnValue="项目还没保存，如果离开，将会丢失数据，真的要离开吗？";
			}
			*/
  	  e=e||event;
	  e.returnValue="项目还没保存，如果离开，将会丢失数据，真的要离开吗？";
    //}
   }