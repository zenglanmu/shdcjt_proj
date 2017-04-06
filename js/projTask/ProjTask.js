


//得到时间
function getDate(i){
	datas = window.showModalDialog("/systeminfo/Calendar.jsp","","dialogHeight:320px;dialogwidth:275px");
	$("#datespan"+i).html(datas.name);
	$("input[name=dff0"+i+"]").val(datas.id);
}



//列表中显示开始时间
function onShowBeginDate1(returndate,txtObj,spanObj,endDateObj,spanEndDateObj,workLongObj){
	if (returndate){
		if (returndate!=""){
			endDate = endDateObj.value;			
			if (endDate != ""){
				diffDate = dateDiffForJava(returndate,endDate);
				if (diffDate<0){
					if(readCookie("languageidweaver")==8){
						alert("The end time must be larger than the start time!")
                        $(spanObj).html(txtObj.value);
					}
					else{
						alert("结束时间必须大于开始时间！")
						$(spanObj).html(txtObj.value);
					}
				}else {
					$(spanObj).html(returndate);
					$(txtObj).val(returndate);
					$(workLongObj).val(diffDate);
				}
			} else {
					if  (workLongObj.value!="" ){
						newDate = getAddNewDateStr1(returndate,workLongObj.value)
						$(spanEndDateObj).html(newDate);
						$(endDateObj).val(newDate);
					}
					
					$(spanObj).html(returndate);
					$(txtObj).val(returndate);        
			}
		}else{
			$(spanObj).html( "");
			$(txtObj).val("" );
		} 
	}
}

//列表中显示结束时间
function onShowEndDate1(returndate,txtObj,spanObj,beginDateObj,spanBeginDateObj,workLongObj){
		if (returndate){
		if (returndate!=""){
			beginDate = beginDateObj.value
			diffDate = dateDiffForJava(beginDate,returndate);
			if (beginDate != ""){
				if (diffDate<0){
					if(readCookie("languageidweaver")==8){
						alert("The end time must be larger than the start time!")
						spanObj.innerHtml = txtObj.value
					}else{
						alert("结束时间必须大于开始时间！")
						spanObj.innerHtml = txtObj.value
					}
				}else {
					spanObj.innerHtml= returndate
					txtObj.value=returndate    
					workLongObj.value=diffDate
				} 
			}else{
					if ( workLongObj.value != ""){
						newDate = getSubtrNewDateStr(returndate,workLongObj.value)
						spanBeginDateObj.innerHtml=newDate
						beginDateObj.value=newDate
					}

					spanObj.innerHtml= returndate
					txtObj.value=returndate    
			}
		}else{
			spanObj.innerHtml= ""
			txtObj.value="" 
		}
		}
}

//当改变工期时做以下操作
function onWorkLongChange(workLongObj,beginDateObj,spanBeginDateObj,endDateObj,spanEndDateObj){
	workLong = workLongObj.value
	beginDate = beginDateObj.value
	endDate = endDateObj.value

	if (workLong!="" && beginDate!=""){
		newDate = getAddNewDateStr1(beginDate,workLong)
		spanEndDateObj.innerHTML=newDate
		endDateObj.value=newDate
		return;
	}
	if (workLong!="" && endDate!=""){
		newDate = getSubtrNewDateStr(endDate,workLong)
		$(spanBeginDateObj).html(newDate);
		$(beginDateObj).val(newDate);
		return;
	}
}


//算新的时间的方法 加法
	function getAddNewDateStr(strDate,addDay){
       if (strDate=""){
			getAddNewDateStr="" 	
			return;
       }
        
		strDateArray = strDate.split("-");
		strYear = strDateArray[0];
		strMonth = strDateArray[1];
		strDay = strDateArray[2];
		myDate2 = new Date();
		myDate2.setYear(strYear);
		myDate2.setMonth(strMonth);
		myDate2.setDate(parseInt(strDay)+addDay);
		myYear = myDate2.getFullYear();
		myMonth= myDate2.getMonth();
		myDay = myDate2.getDate();

		if (myMonth<10){
			newMonth = "0"+ (myMonth);
		}else {
			newMonth = (myMonth)
		}
		if (myDay<10 ){
			 newDay = "0"+ (myDay) 
		}else{
			newDay = (myDay)
		}
		getAddNewDateStr = ""+(myYear)+"-"+newMonth+"-"+newDay;
	return;
}
	
//算新的时间的方法 加法  TD18989
	function getAddNewDateStr1(strDate,addDay){
		if (strDate==""){
			return "" 	;
			
		}
     
		strDateArray = strDate.split("-");
		strYear = strDateArray[0];
		strMonth = strDateArray[1];
		strDay = strDateArray[2];

		if(parseInt(addDay)>0 && (""+parseInt(addDay)==addDay || ""+(parseInt(addDay))+".0"==addDay)){
		   MyDate2 = new Date(parseInt(strYear), parseInt(strMonth), parseInt(strDay)+parseInt(addDay)-1);
		}else{ 
		   MyDate2 = new Date(parseInt(strYear), parseInt(strMonth), parseInt(strDay)+parseInt(addDay))
		}   
		myYear = MyDate2.getFullYear();
		myMonth= MyDate2.getMonth();
		myDay = MyDate2.getDate();

		if( myMonth<10){
				newMonth = "0"+ (myMonth) ;
		}else{
			newMonth = ""+(myMonth);
		}
		if(myDay<10){
			 newDay = "0"+ (myDay) ;
		}else{
				newDay = (myDay);
		}
		return ""+(myYear)+"-"+newMonth+"-"+newDay;
	}

//算新的时间的方法 减法
	function getSubtrNewDateStr(strDate,addDay){
       if(strDate==""){
			return "";
       }
        
		strDateArray = strDate.split("-");
		strYear = strDateArray[0];
		strMonth = strDateArray[1];
		strDay = strDateArray[2];
		MyDate2 = new Date(parseInt(strYear), parseInt(strMonth), parseInt(strDay)-addDay+1);   		
		myYear = MyDate2.getFullYear();
		myMonth= MyDate2.getMonth();
		myDay = MyDate2.getDate();

		if (myMonth<10){
			 newMonth = "0"+ myMonth; 
		}else{
			 newMonth = ""+myMonth;
		}
		if (myDay<10){
			newDay = "0"+ (myDay) ;
		}else{
			newDay = ""+(myDay);
		}
		return ""+(myYear)+"-"+newMonth+"-"+newDay;
	}
