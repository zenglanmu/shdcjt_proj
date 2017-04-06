/**
  作用：    时间控件的统一管理
  创建者：  brant
  时间：    2008.3.28
**/
var $J = jQuery ? jQuery : $;
$J(document).ready(function () {
	$J(".wuiDate").each(function(){
		var z = $J(this), n = z.attr("name"), t = z.attr("type"),v = z.val(), b = z.attr("_button"), s = z.attr("_span"), f = z.attr("_callback"), r = z.attr("_isrequired");
		n = (n == undefined || n == null || n == "") ? new Date().getTime() + "_input" : n;
		b = (b == undefined || b == null || b == "") ? n + "ReleBtn_Autogrt" : b;
		s = (s == undefined || s == null || s == "") ? n + "ReleSpan_Autogrt" : s;
		if (t != "hidden") {
			z.css("display", "none");	
			z.attr("name", n + "_back");
		}
		
		var x = "<button class=\"calendar\" type=\"button\" name=" + b + "\" id=" + b + "\" onclick=\"_gdt('" + n + "', '" + s + "', '" + f + "');\"></button>";
		x += "<span id=\"" + s + "\" name=\"" + s + "\">" + v + "</span>";
		if (r != undefined && r != null && r == "yes") {
			x += "<span id=\"" + s + "img" + "\" name=\"" + s + "img" + "\">";
			if (v == undefined || v == null || v == "") {
				x += "<img align=\"absMiddle\" src=\"/images/BacoError	.gif\"/>";
			}
			x += "</span>";
			
			z.bind("propertychange", function () {
				checkinput(n, s + "img");
			});
		}
		z.after(x);
	}); 
});
function _gdt(_i, _s, _f) {
	try {
		var returnValue = _gettheDate(_i, _s, _f);
	} catch(e){} 
}

function _gettheDate(inputname,spanname, _f){
	
	var evt = window.event;
    WdatePicker({
			el : spanname,
			onpicked : function(dp) {
				var returnvalue = dp.cal.getDateStr();
				$dp.$(inputname).value = returnvalue;
				if (!window.ActiveXObject) {
					//手动触发oninput事件
					checkinput(inputname, spanname + "img");
				}
				try {
					if (_f != undefined && _f != null && _f != "") {
						eval(_f + "($dp.$(inputname).value, evt)");	
					}
					
				} catch (e) {}
			},
			oncleared : function(dp) {
				$dp.$(inputname).value = '';
				if (!window.ActiveXObject) {
					//手动触发oninput事件
					checkinput(inputname, spanname + "img");
				}
			}
	});
}

//function $() {
function $ele4p() {
	var elements = new Array();
	for (var i = 0; i < arguments.length; i++) {
		var element = arguments[i];
		if (typeof element == 'string') {
			element = document.getElementById(element);
			
			if (element == undefined || element == null) {
				element = document.getElementsByName(arguments[i])[0];
			}
		}
		if (arguments.length == 1) {
			return element;
		}
		elements.push(element);
	}
	return elements;
}

/*********************************
 path: ../car/CarInfoAdd.jsp or CarInfoEdit.jsp or CarInfoView.jsp  
*********************************/
function getBuyDate(){
   WdatePicker({el:'buyDateSpan',onpicked:function(dp){$dp.$('buyDate').value = dp.cal.getDateStr()}})
}
	
/*********************************
 path: ../car/CarInfoBrowser.jsp,CarInfoMaintenace.jsp
       ../hrm/report/HrmRpTrainHourByDep.jsp,HrmRpTrainHourByType.jsp,HrmRpTrainPeoNumDep.jsp,HrmRpTrainPeoNumByType.jsp
*********************************/
function getStartDate(){
	WdatePicker({el:'startdatespan',onpicked:function(dp){
		  $dp.$('startdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdate').value = ''}})
}
function getEndDate(){
	WdatePicker({el:'enddatespan',onpicked:function(dp){
		$dp.$('enddate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate').value = ''}})	
}

/*********************************
 path: ../car/CarUserInfo.jsp
       ../datacenter/maintenance/reportstatus/ReportDetailCrm.jsp
       ../hrm/resource/HrmResourceAbsense.jsp,HrmResourcePlan.jsp
	   ../cpt/capital/CptCapitalUsePlan.jsp
*********************************/
function getSubTheDate(){
	 WdatePicker({el:'hiddenSpan',onpicked:function(dp){
	        document.frmmain.currentdate.value = dp.cal.getDateStr();
			document.frmmain.submit()},oncleared:function(dp){$dp.$('currentdate').value = ''}})
}

/*********************************
 path:  ../hrm/report/RptSalaryDiff.jsp
*********************************/
function getcurrentdate(){
   WdatePicker({el:'currentdatespan',onpicked:function(dp){
	   var recurrentdate  = dp.cal.getDateStr(); document.frmmain.currentdate.value = recurrentdate.substring(0,7); 
	   document.frmmain.submit()},oncleared:function(dp){$dp.$('currentdate').value = ''}})
}

/*********************************
 path: ../docs/docs/DocAdd.jsp,DocEdit.jsp,DocAddExt.jsp,DocEditExt.jsp
*********************************/
function getInvalidationDate(l){
  //var userl = l;
  var returnvalue;
  //var stringvalue;
  
  var clearingFunc = function(){
	  //if(userl == 7){
		  //stringvalue = "文档改变为正常文档后内容会丢失，确认要改变吗";
	  //}
	 // if(userl == 8){
		  //stringvalue = "Content will lost while changing into normal doc,sure to change?";
	 // }
	  //if(window.confirm(stringvalue)){
		  document.getElementById('invalidationdate').value = '';
	  //}
  }
  WdatePicker({el:'invalidationdatespan',onpicked:function(dp){
	    returnvalue = dp.cal.getDateStr(); 
		//$ele4p('invalidationdatespan').innerHTML = '';
	    //if(userl == 7){
		 // stringvalue = "文档改变为临时文档后内容会丢失，确认要改变吗?";
		 // }
	    //if(userl == 8){
		 // stringvalue = "Content will lost while changing into temporary doc,sure to change?";
	   // }	    
	    //if(window.confirm(stringvalue)){
			$dp.$('invalidationdate').value = returnvalue;
            $ele4p('invalidationdatespan').innerHTML = returnvalue;
	    //}  
	  },
	  onclearing:clearingFunc})
}

function getInvalidationDate2(l,callbackFunc){
	  //var userl = l;
	  var returnvalue;
	  //var stringvalue;
	  
	  var clearingFunc = function(){
		  //if(userl == 7){
			  //stringvalue = "文档改变为正常文档后内容会丢失，确认要改变吗";
		  //}
		 // if(userl == 8){
			  //stringvalue = "Content will lost while changing into normal doc,sure to change?";
		 // }
		  //if(window.confirm(stringvalue)){
		   $GetEle('invalidationdate').value = '';
		  	callbackFunc.call(this);
		  //}
	  }
	  WdatePicker({el:'invalidationdatespan',onpicked:function(dp){
		    returnvalue = dp.cal.getDateStr(); 
			//$ele4p('invalidationdatespan').innerHTML = '';
		    //if(userl == 7){
			 // stringvalue = "文档改变为临时文档后内容会丢失，确认要改变吗?";
			 // }
		    //if(userl == 8){
			 // stringvalue = "Content will lost while changing into temporary doc,sure to change?";
		   // }	    
		    //if(window.confirm(stringvalue)){
				$dp.$('invalidationdate').value = returnvalue;
	            $ele4p('invalidationdatespan').innerHTML = returnvalue;
	            callbackFunc.call(this);
		    //}  
		  },
		  onclearing:clearingFunc});
}

function onShowDocDate(id,fieldbodytype,isbodymand){
	var spanname = "customfield"+id+"span";
	var inputname = "customfield"+id;
	var oncleaingFun = function(){
		  if(isbodymand){
			 $ele4p("customfield"+id).value = '';
		     $ele4p(spanname).innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
          }else{
			 $ele4p("customfield"+id).value = '';
		     $ele4p(spanname).innerHTML = '';
		  }
		}
	if(fieldbodytype == 2){
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
	}

    var hidename = $ele4p(inputname).value;
	if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	}else{
	    $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	}
}

/*********************************
 path: ../docs/docsubscribe/DocSubscribeHistory.jsp,DocSubscribeApprove.jsp,DocSubscribeBack.jsp
       ../docs/report/DocRpReadStatistic.jsp
	   ../workflow/report/FlowTypeStat.jsp,WorkList.jsp,ReportCondition.jsp,ReportConditionEdit.jsp,ReportConditionMould.jsp
	   ../workflow/search/SubWFSearchResult.jsp,WFSearch.jsp,WFSearchResult.jsp,WFCustomSearch.jsp,WFCustomSearchResult.jsp
	                      WFSearchResultForNewBackWorkflow.jsp,WFSuperviselist.jsp
	   ../system/systemmonitor/workflow/WorkflowMonitor.jsp
	   ../systeminfo/SysMaintenanceLog.jsp
	   ../hrm/report/HrmRpContact.jsp,HrmRpResource.jsp
	   ../hrm/career/usedemand/HrmUseDemandAnalyse.jsp
	   ../cpt/capital/CptCapitalFlowView.jsp
	   ../cpt/maintenance/CptCapitalCheckStock.jsp
	   ../cpt/report/CptRpCapitalApportion.jsp,CptRpCapitalCheckStock_bak.jsp,CptRpCapitalFlow.jsp
*********************************/
function gettheDate(inputname,spanname){
	    WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../cpt/capital/CptCapitalMend.jsp
*********************************/
function getmendDate(){
	var spanname ="menddatespan";
	 var inputname = "menddate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../docs/search/DocSearch.jsp
       ../system/systemmonitor/docs/DocMonitor.jsp
	   ../docs/docs/DocBrowser.jsp,DocBrowserWord.jsp,MutiDocBrowser.jsp,MutiDocBrowser_proj.jsp
	   ../docs/docsubscribe/MutiDocByWenerBrowser.jsp
	   ../docs/news/MultiNewsBrowser.jsp 
	   ../hrm/career/CareerInviteBrowser.jsp
	   ../hrm/career/HrmCareerApplyAddThree.jsp
	   ../hrm/resource/HrmResourceWorkEdit.jsp
	   ../hrm/report/HrmRpMonthSalarySum.jsp,HrmRpResourceSalarySum.jsp,HrmTrainAttendReport.jsp,HrmTrainLayoutReport.jsp,HrmTrainReport.jsp
	                HrmTrainResourceReport.jsp
	   ../hrm/report/careerapply/HrmCareerApplyReport.jsp,HrmRpCareerApply.jsp
	   ../hrm/report/resource/HrmRpResource.jsp
	   ../hrm/report/schedulediff/HrmArrangeShiftReport.jsp,HrmRpScheduleDiff.jsp,HrmRpScheduleDiffDepTime.jsp,HrmRpScheduleDiffDepDay.jsp
	                              HrmRpScheduleDiffType.jsp,HrmRpScheduleDiffTypeDay.jsp,HrmRpTimecard.jsp,HrmRpValidateTimecard.jsp
                                  HrmRpScheduleDiffDepDayReport.jsp,HrmRpScheduleDiffDepMonReport.jsp,HrmScheduleDiffDetailReport.jsp
								  HrmShcheduleDiffReport.jsp,HrmScheDuleDiffTypeMonReport.jsp
       ../hrm/report/usedemand/HrmRpUseDemand.jsp,HrmRpUserDemandDetail.jsp,HrmUseDemandReport.jsp
	   ../hrm/search/HrmResourceSearch.jsp
       ../hrm/schedule/HrmArrangeShiftMaintance.jsp,HrmArrangeShiftProcess.jsp,HrmOutTimecard.jsp,HrmScheduleMaintance.jsp,HrmScheduleMaintanceAdd.jsp
                      HrmWorkTimeWarpList.jsp,HrmWorkTimeWarpCreate.jsp,HrmTimeCarWarpList.jsp
	   ../hrm/career/HrmCareerApplyWorkEdit.jsp,HrmCareerInviteAdd.jsp,HrmCareerInviteEdit.jsp,HrmInterviewAssess.jsp,HrmInterviewPlan.jsp
	                 HrmInterviewResult.jsp
	   ../hrm/career/careerplan/CareerPlanBrowser.jsp,HrmCareerPlanAdd.jsp,HrmCareerPlanEdit.jsp,HrmCareerPlanEditDo.jsp,HrmCareerPlanFinish.jsp
	                            HrmCareerPlanFinishView.jsp
	   ../hrm/career/usedemand/HrmUseDemandAdd.jsp,HrmUseDemandEdit.jsp,HrmUseDemandEditDo.jsp
	   ../hrm/train/train/HrmCareerPlanFinshView.jsp,HrmTrainActorAdd.jsp,HrmTrainAdd.jsp,HrmTrainAssess.jsp,HrmTrainAssessAdd.jsp
	                      HrmTrainAssessEdit.jsp,HrmTrainDayAdd.jsp,HrmTrainDayEdit.jsp,HrmTrainEdit.jsp,HrmTrainEditDo.jsp,HrmTrainFinish.jsp
						  HrmTrainFinishView.jsp,HrmTrainTest.jsp
	   ../hrm/trian/trianlayout/HrmTrainLayoutAdd.jsp,HrmTrainLayoutEdit.jsp,HrmTrainLayoutEditDo.jsp,TrainLayoutAssess.jsp
	   ../hrm/trian/trainplan/HrmTrainLayoutEditDo.jsp,HrmTrainPlanAdd.jsp,HrmTrainPlanEdit.jsp,HrmTrainPlanEditDo.jsp
	   ../hrm/contract/HrmContract.jsp,HrmContractAdd.jsp,HrmContractAddExt.jsp,HrmContractEdit.jsp,HrmContractEditExt.jsp,HrmContractView.jsp,HrmContractViewExt.jsp
       ../hrm/finance/salary/HrmSalaryCreate.jsp,PieceRateMaintenanceEdit.jsp
	   ../workflow/request/ManageBillCptAdjust.jsp,ManageBillCptCarFix.jsp,ManageBillCptCarMantant.jsp,ManageBillCptCarOut.jsp
	                       ManageBillCptCheck.jsp,ManageBillCptFetch.jsp,ManageBillCptPlan.jsp,ManageBillCptRequire.jsp,ManageBillCptStockIn.jsp
						   ManageBillHireResource.jsp,ManageBillHotelBookAll.jsp
	   ../proj/Templet/MutiTaskBrowser.jsp
	   ../proj/process/MutiTaskBrowser.jsp
	   ../proj/plan/EditTaskProcess.jsp,EditProjToolProcess.jsp,EditProjTool.jsp,EditProjMemberProcess.jsp,EditPlan.jsp,AddPlan.jsp,AddProjMember.jsp
	                AddProjMemberProcess.jsp,AddProjTool.jsp,AddProjToolProcess.jsp
       ../fna/report/expense/FnaExpenseTypeCrmDetail.jsp,FnaExpenseTypeDetail.jsp,FnaExpenseTypeProjectDetail.jsp,FnaExpenseTypeResourceDetail.jsp
       ../cpt/search/CptSearch.jsp
	   ../meeting/meetingbrowser.jsp
*********************************/
function getDate(spanname,inputname){  
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../docs/search/DocSummary.jsp,DocSummary3.jsp,DocSearchTemp.jsp,DocSummary(bak1).jsp,DocSummary2(bak1).jsp,DocSummary2.jsp
       ../docs/docs/DocDownloadLog.jsp
	   ../docs/report/DocCreateRp.jsp,DocRpAllDocSum.jsp,DocRpDocSum.jsp,DocRpCreater.jsp,DocRpRelative.jsp,DocRpOrganizationSum.jsp
       ../workflow/report/HrmMonthWorkRp.jsp,HrmWeekRp.jsp,OperateLogRp.jsp,ViewLogRp.jsp
	   ../CRM/report/CRMLoginLogRp.jsp,CRMModifyLogRp.jsp,CRMViewLogRp.jsp,TradeInfoRpSum.jsp,ContractFnaReport.jsp,ContractProReport.jsp
                     ContractReport.jsp,CRMContactLogRp.jsp,CRMEvaluationRp.jsp
	   ../CRM/search/SearchAdvanced.jsp,SearchSimple.jsp
	   ../CRM/sellchance/FailureRpSum.jsp,SelArEACiytRpSum.jsp,SellAreaProRpSum.jsp,SellChanceReport.jsp,SellClientRpSum.jsp,SellManagerRpSum.jsp
	                     SellProductRpSum.jsp,SellStatusRpSum.jsp,SuccessRpSum.jsp
	   ../hrm/resource/HrmResourceExchange.jsp
	   ../hrm/report/hrmAgeRp.jsp,HrmCostcenterRp.jsp,hrmDepartmentRp.jsp,hrmEducationLevelRp.jsp,HrmJobActivityRp.jsp,HrmJobCallRp.jsp
	                 HrmJobGroupRp.jsp,HrmJobLevelRp.jsp,HrmJobTitleRp.jsp,hrmMarriedRp.jsp,HrmRpAbsense.jsp,hrmSevLevelRp.jsp
					 hrmSexRp.jsp,hrmStatusRp.jsp,hrmUsekindRp.jsp
	   ../hrm/report/careerapply/HrmRpCareerApplySearch.jsp
	   ../hrm/report/contract/HrmRpContract.jsp,HrmRpContractDetail.jsp,HrmRpContractType.jsp
	   ../hrm/report/dismiss/HrmDismissReport.jsp,HrmRpDismiss.jsp,HrmRpDismissDetail.jsp,HrmRpDismissTime.jsp
	   ../hrm/report/extend/HrmExtentReport.jsp,HrmRpExtend.jsp,HrmRpExtendDetail.jsp,HrmRpExtendTime.jsp
	   ../hrm/report/fire/HrmFireReport.jsp,HrmRpFire.jsp,HrmRpFireDetail.jsp,HrmRpFireTime.jsp
	   ../hrm/report/hire/HrmHireReport.jsp,HrmRpHire.jsp,HrmRpHireDetail.jsp,HrmRpHireTime.jsp
	   ../hrm/report/redeploy/HrmRedeployReport.jsp,HrmRpRedeploy.jsp,HrmRpRedeployDetail.jsp,HrmRpRedeployTime.jsp
	   ../hrm/report/rehire/HrmRehireReport.jsp,HrmRpRehire.jsp,HrmRpRehireDetail.jsp,HrmRpRehireTime.jsp
       ../hrm/report/resource/HrmRpResourceAdd.jsp,HrmRpResourceAddReport.jsp,HrmRpResourceAddTime.jsp
	   ../hrm/report/retire/HrmRetireReport.jsp,HrmRpRetireTime.jsp,HrmRpRetire.jsp,HrmRpRetireDetail.jsp
	   ../hrm/search/HrmResourceSearch.jsp
	   ../proj/Templet/ProjectModifyLogRp.jsp
       ../fna/report/RptMoneyWeekDetailQuery.jsp
*********************************/
function getfromDate(){
		WdatePicker({el:'fromdatespan',onpicked:function(dp){
			$dp.$('fromdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('fromdate').value = ''}});
}
function gettoDate(){
		WdatePicker({el:'todatespan',onpicked:function(dp){
			$dp.$('todate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('todate').value = ''}});
}
function getendDate(){
		WdatePicker({el:'enddatespan',onpicked:function(dp){
			$dp.$('enddate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

/*********************************
 path: ../docs/docdummy/DocDummyRight.jsp
*********************************/
function gettheDummyDate(inputname,spanname){
		WdatePicker({maxDate:'#F{$dp.$(\'subscribeDateTo\').value||\'2020-10-01\'}',el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}
function gettheDummyDate1(inputname,spanname){
		WdatePicker({minDate:'#F{$dp.$(\'subscribeDateFrom\').value}',el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../docs/search/IndexManager.jsp
*********************************/
function showCalendar(spanId,inputId){
  WdatePicker({el:spanId,onpicked:function(dp){
	  var returnvalue = dp.cal.getDateStr();$dp.$(inputId).value = returnvalue;},oncleared:function(dp){$dp.$(inputId).value = ''}});
}

/*********************************
 path: ../voting/VotingAdd.jsp,VotingEdit.jsp
       ../workflow/report/RequestRpPlan.jsp
	   ../workflow/request/AddBillCptAdjust.jsp,AddBillCptApply.jsp,AddBillCptCarFee.jsp,AddBillCptCarFix.jsp,AddBillCptCarMantant.jsp
	                       AddBillCptCarOut.jsp,AddBillCptCheck,jsp,AddBillCptFetch.jsp,AddBillCptPlan.jsp,AddBillCptRequire.jsp
						   AddBillCptStockIn.jsp,AddBillExpense.jsp,AddMeetingroom.jsp,ManageBillWeekInfo.jsp,ManageBillMonthWorkinfo.jsp
	   ../CRM/data/ContractAdd.jsp,ContractEdit.jsp,ContractView.jsp
	   ../CRM/sellchance/AddSellChance.jsp
	   ../hrm/schedule/HrmArrangeShiftAdd.jsp,HrmDefaultScheduleAdd.jsp,HrmDefaultSchedule.jsp
	   ../fna/maintenance/FnaPersonalReturn.jsp,FnaPersonalReturnEdit.jsp,FnaYearsPeriodsAdd.jsp,FnaYearsPoriodsListEdit.jsp
	   ../meeting/data/EditMeeting.jsp
*********************************/
function onShowDate(spanname,inputname){	
	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
		var hidename = $ele4p(inputname).value;
		if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		}else{
	      $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		}
}


function onBillCPTShowDate(spanname,inputname,ismand){	
	  var returnvalue;
	  var oncleaingFun = function(){
		  if(ismand != -1){
			   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
			   $ele4p(inputname).value = '';
		   }else{
		       spanname.innerHTML = ""; 
			   $ele4p(inputname).value = '';
		   } 
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
    
	if(ismand != -1){
	 var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
    }
}


/*********************************
 path:  ../workflow/request/AddBillExpense.jsp,ManageBillExpense.jsp,AddBillHrmScheduleMain.jsp
*********************************/
function onBillShowDate(spanname,inputname,ismand){	
	  var returnvalue;
	  var oncleaingFun = function(){
		  if(ismand == 1){
			   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
			   $ele4p(inputname).value = '';
		   }else{
		       spanname.innerHTML = ""; 
			   $ele4p(inputname).value = '';
		   } 
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
    
	if(ismand == 1){
	 var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
    }
}

/*********************************
 path: ../workflow/request/AddResourcePlan.jsp
*********************************/
function onShowdate(inputname,spanname){
	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
		   $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

     var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../workflow/report/pendingRequestRp.jsp,RequestQualityRp.jsp,WorkflowTypeRp.jsp
 *********************************/
 function getStartDate1(){
    WdatePicker({el:'startdatespan1',onpicked:function(dp){
		$dp.$('startdate1').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdate1').value = ''}});
 }
 function getStartDate2(){
    WdatePicker({el:'startdatespan2',onpicked:function(dp){
		$dp.$('startdate2').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdate2').value = ''}});
 }
 function getEndDate1(){
    WdatePicker({el:'enddatespan1',onpicked:function(dp){
		$dp.$('enddate1').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate1').value = ''}});
 }
 function getEndDate2(){
    WdatePicker({el:'enddatespan2',onpicked:function(dp){
		$dp.$('enddate2').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate2').value = ''}});
 }

 /*********************************
 path: ../workflow/request/AddBill2Request.jsp,AddBill3Request.jsp,AddBill4Request.jsp
 *********************************/
 function getdate(i){ 
   WdatePicker({el:'datespan'+i,onpicked:function(dp){
	   $dp.$('dff0'+i).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dff0'+i).value = ''}});
 }

/*********************************
 path: ../workflow/request/AddBillLeaveJob.jsp,AddBillMailboxApply.jsp,AddBillMonthWorkBrief.jsp,AddBillMonthWorkinfo.jsp
                           AddBillMonthWorkPlan.jsp,AddBillTotalBudget.jsp,RequestBrowser.jsp,MultiRequestBrowserRight.jsp
						   ManageBillMonthWorkPlan.jsp
*********************************/
function getTheDate(inputname,spanname){
	WdatePicker({el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../workflow/request/AddBillMonthWorkinfo.jsp,AddBillWeekWorkinfo.jsp
*********************************/
function getMontPlanDate(inputname,spanname){	
	var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		   $ele4p(inputname).value = '';
		}
	WdatePicker({el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		$dp.$(spanname).innerHTML = returnvalue;
		$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

     var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../workflow/request/AddOvertime.jsp,AddProjectPlan.jsp
       ../hrm/performance/targetType/TargetBrowserMuti.jsp
	   ../proj/data/MultiTaskBrowser.jsp
	   ../cowork/AddCoWork.jsp
*********************************/
function getBDate(ismand){
    var oncleaingFun = function(){
			if(ismand == 1){
		        document.all("begindatespan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$ele4p('begindate').value = '';
		    }		 
		}
    WdatePicker({onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();	
		$dp.$('begindatespan').innerHTML = returnvalue;
		$dp.$('begindate').value = returnvalue;
	},oncleared:oncleaingFun});

	if(ismand == 1){
	     var hidename = $ele4p('begindate').value;
		 if(hidename != ""){
			$ele4p('begindate').value = hidename; 
			$ele4p('begindatespan').innerHTML = hidename;
		 }else{
		  $ele4p('begindatespan').innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		 }
	}
}
function getEDate(ismand){
	var oncleaingFun = function(){
			if(ismand == 1){
		        document.all("enddatespan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$ele4p('enddate').value = '';
		    }		 
		}
    WdatePicker({onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();	
		$dp.$('enddatespan').innerHTML = returnvalue;
		$dp.$('enddate').value = returnvalue;
	},oncleared:oncleaingFun});

	if(ismand == 1){
	     var hidename = $ele4p('enddate').value;
		 if(hidename != ""){
			$ele4p('enddate').value = hidename; 
			$ele4p('enddatespan').innerHTML = hidename;
		 }else{
		  $ele4p('enddatespan').innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		 }
	}
}

/*********************************
 path: ../workflow/request/wfAgentAdd.jsp,wfAgentEdit.jsp
*********************************/
function onshowAgentBDate(){
  WdatePicker({minDate:'%y-%M-#{%d}',maxDate:'#F{$dp.$(\'endDate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('beginDate').value = returnvalue;},oncleared:function(dp){$dp.$('beginDate').value = ''}});
}
function onshowAgentEDate(){
  WdatePicker({minDate:'#F{$dp.$(\'beginDate\').value||\'%y-%M-#{%d}\'}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('endDate').value = returnvalue;},oncleared:function(dp){$dp.$('endDate').value = ''}});
}

/*********************************
 path: ../workflow/request/wfAgentList.jsp
*********************************/
function onlistAgentBDate(){
  WdatePicker({maxDate:'#F{$dp.$(\'todate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('fromdate').value = returnvalue;},oncleared:function(dp){$dp.$('fromdate').value = ''}});
}
function onlistAgentEDate(){
  WdatePicker({minDate:'#F{$dp.$(\'fromdate\').value}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('todate').value = returnvalue;},oncleared:function(dp){$dp.$('todate').value = ''}});
}

/*********************************
 path: ../workflow/request/WorkflowAddRequestBody.jsp,AddBillMeeting.jsp,AddBillCaruseApprove.jsp,WorkflowAddRequestDetailBody.jsp
*********************************/
function onShowFlowDate(id,fieldbodytype,isbodymand){
	var spanname = "field"+id+"span";
	var inputname = "field"+id;
	var oncleaingFun = function(){
		  if(isbodymand == 0){
		     $ele4p(spanname).innerHTML = '';
			 $ele4p("field"+id).value = '';
          }else{
		     $ele4p(spanname).innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			 $ele4p("field"+id).value = '';
		  }
		}
	if(fieldbodytype == 2){
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(spanname).innerHTML = returnvalue;
			$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
	}

    if(isbodymand != 0){
	     var hidename = $ele4p(inputname).value;
		 if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		 }else{
		  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		 }
	}
}
function onShowNoFlowDate(id,fieldbodytype,isbodymand){
	var spanname = "field"+id+"span";
	var inputname = "field"+id;
	var oncleaingFun = function(){
		  if(isbodymand == 0){
		     $ele4p(spanname).innerHTML = '';
			 $ele4p("field"+id).value = '';
          }else{
		     $ele4p(spanname).innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			 $ele4p("field"+id).value = '';
		  }
		}
	if(fieldbodytype == 2){
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(spanname).innerHTML = returnvalue;
			$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
	}

    if(isbodymand != 0){
	     var hidename = $ele4p(inputname).value;
		 if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		 }else{
		  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		 }
	}
}
/*********************************
 path: ../workflow/search/WFCustomSearch.jsp
*********************************/
function onSearchWFDate(spanname,inputname){
	var oncleaingFun = function(){
		  $ele4p(spanname).innerHTML = '';
		  $ele4p(inputname).value = '';
		}
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
}

/*********************************
 path: ../datacenter/maintenance/reportstatus/ReportDetailStatus.jsp
*********************************/
function getReportDate(){
   WdatePicker({el:'datespan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('date').value = returnvalue;},oncleared:function(dp){$dp.$('date').value = ''}});
}

 /*********************************
 path: ../CRM/data/AddContacter.jsp,AddCustomer.jsp,AddPerCustomer.jsp,EditAddress.jsp,EditContacter.jsp,EditCustomer.jsp,EditPerCustomer.jsp
 *********************************/
 function getCrmDate(i){
   WdatePicker({el:'datespan'+i,onpicked:function(dp){
	   $dp.$('dff0'+i).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dff0'+i).value = ''}});
 }

/*********************************
 path: ../CRM/data/AddContacter.jsp,EditContacter.jsp
*********************************/
function getbirthday(){
   WdatePicker({el:'birthdayspan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('birthday').value = returnvalue;},oncleared:function(dp){$dp.$('birthday').value = ''}});
}

/*********************************
 path: ../CRM/data/AddContactLog.jsp,EditContactLog.jsp
*********************************/
function getContactDate(){
  WdatePicker({el:'ContactDatespan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('ContactDate').value = returnvalue;},oncleared:function(dp){$dp.$('ContactDate').value = ''}});
}
function getEndData(){
  WdatePicker({el:'EndDataspan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('EndData').value = returnvalue;},oncleared:function(dp){$dp.$('EndData').value = ''}});
}

/*********************************
 path: ../CRM/data/ContractAdd.jsp,ContractEdit.jsp,ContractView.jsp
       ../CRM/sellchance/AddSellChance.jsp,EditSellChance.jsp
*********************************/
function onShowDate_1(spanname,inputname){
  var oncleaingFun = function(){
		$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		$ele4p(inputname).value = '';
  }
  WdatePicker({el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		$dp.$(spanname).innerHTML = returnvalue;
		$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

	 var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}
function onShowDate2(spanname,inputname,inputenameTemp){
  var oncleaingFun = function(){
		$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		$ele4p(inputname).value = '';
  }
  WdatePicker({el:spanname,onpicked:function(dp){
	var returnvalue = dp.cal.getDateStr();
	$dp.$(spanname).innerHTML = returnvalue;
	$dp.$(inputname).value = returnvalue;$dp.$(inputenameTemp).value = returnvalue;},oncleared:oncleaingFun});

     var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../CRM/data/EditCustomer.jsp,EditPerCustomer.jsp
*********************************/
function getCreditDate(){
  WdatePicker({el:'creditexpirespan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('CreditExpire').value = returnvalue;},oncleared:function(dp){$dp.$('CreditExpire').value = ''}});
}

/*********************************
 path: ../CRM/search/SearchAdvanced.jsp
*********************************/
function getStatusFrom(){
  WdatePicker({el:'StatusFromspan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('StatusFrom').value = returnvalue;},oncleared:function(dp){$dp.$('StatusFrom').value = ''}});
}
function getStatusTo(){
  WdatePicker({el:'StatusTospan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('StatusTo').value = returnvalue;},oncleared:function(dp){$dp.$('StatusTo').value = ''}});
}
function getTypeFrom(){
  WdatePicker({el:'TypeFromspan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('TypeFrom').value = returnvalue;},oncleared:function(dp){$dp.$('TypeFrom').value = ''}});
}
function getTypeTo(){
  WdatePicker({el:'TypeTospan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('TypeTo').value = returnvalue;},oncleared:function(dp){$dp.$('TypeTo').value = ''}});
}

/*********************************
 path: ../hrm/award/HrmAward.jsp,HrmAwardAdd.jsp,HrmAwardEdit
       ../hrm/check/HrmCheckKindAdd.jsp,HrmCheckKindEdit.jsp,HrmCheckKindView.jsp
*********************************/
function getHrmDate(spanname,inputname){	
	
	WdatePicker({el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){
			$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$ele4p(inputname).value = '';
				
		}});
 /* var oncleaingFun = function(){
		$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		$ele4p(inputname).value = '';
  }
  WdatePicker({onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
        $dp.$(spanname).innerHTML = returnvalue;
		$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }*/
}

/*********************************
 path: ../hrm/career/HrmCareerApply.jsp
*********************************/
function getHrmfromDate(){
  WdatePicker({el:'fromdatespan',onpicked:function(dp){
			$dp.$('FromDate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('FromDate').value = ''}});
}
function getHrmendDate(){
  WdatePicker({el:'enddatespan',onpicked:function(dp){
			$dp.$('EndDate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('EndDate').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResource1Add.jsp,HrmResource1Edit.jsp,HrmRsourceAddTwo.jsp,HrmResourceEdit.jsp,HrmResourcePersonalEdit.jsp
       ../hrm/career/HrmCareerApplyAddTwo.jsp
*********************************/
function getbirthdayDate(){
  WdatePicker({el:'birthdayspan',onpicked:function(dp){
			$dp.$('birthday').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('birthday').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceAbsense1Add.jsp,HrmResourceCertificationAdd.jsp,HrmResourceCertificationEdit.jsp
                       HrmResourceaWelfareAdd.jsp,HrmResourceaWelfareEdit.jsp,HrmSourceWorkResumeInAdd.jsp,HrmSourceWorkResumeInEdit.jsp
*********************************/
function getDateFrom(){
  WdatePicker({el:'datefromspan',onpicked:function(dp){
			$dp.$('datefrom').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('datefrom').value = ''}});
}
function getDateTo(){
  WdatePicker({el:'datetospan',onpicked:function(dp){
			$dp.$('dateto').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dateto').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceAdd.jsp
       ../hrm/career/HrmCareerApplyToResource.jsp
*********************************/
function onShowHrmDate(id,id2){
  var spanname = "span"+id2;
  var inputname = "dateField"+id;
  var oncleaingFun = function(){	
	   $ele4p("dateField"+id).value = '';
  }
  WdatePicker({el:spanname,onpicked:function(dp){
	  var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
}

/*********************************
 path: ../hrm/resource/HrmResourceAddThree.jsp
*********************************/
function getstartdate(){
  WdatePicker({el:'startdatespan',onpicked:function(dp){
			$dp.$('startdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdate').value = ''}});
}
function getenddate(){
  WdatePicker({el:'enddatespan',onpicked:function(dp){
			$dp.$('enddate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate').value = ''}});
}
function getRSDate(spanname,inputname){
  WdatePicker({el:spanname,onpicked:function(dp){
			$dp.$(inputname).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceAddTwo.jsp,HrmResourceEdit.jsp,HrmResourcePersonalEdit.jsp
       ../hrm/career/HrmCareerApplyAddTwo.jsp
*********************************/
function getbememberdateDate(){
  WdatePicker({el:'bememberdatespan',onpicked:function(dp){
			$dp.$('bememberdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('bememberdate').value = ''}});
}
function getbepartydateDate(){
  WdatePicker({el:'bepartydatespan',onpicked:function(dp){
			$dp.$('bepartydate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('bepartydate').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceComponentAdd.jsp,HrmResourceComponentEdit.jsp,HrmResourceEdit.jsp,HrmResourceEducationInfoAdd.jsp
                       HrmResourceEducationInfoEdit.jsp,HrmResourceOtherInfoAdd.jsp,HrmResourceOtherInfoEdit.jsp,HrmResourceWorkEdit.jsp
					   HrmResourceWorkResumeAdd.jsp,HrmResourceWorkResumeEdit.jsp
*********************************/
function getstartDate(){
  WdatePicker({el:'startdatespan',onpicked:function(dp){
			$dp.$('startdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdate').value = ''}});
}
function getHendDate(){
  WdatePicker({el:'enddatespan',onpicked:function(dp){
			$dp.$('enddate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceDismiss.jsp,HrmResourceExtend.jsp,HrmResourceFire.jsp,HrmResourceHire.jsp,HrmResourceReploy.jsp
                       HrmResourceRehire.jsp,HrmResourceRetire.jsp,HrmResourceTry.jsp
*********************************/
function getchangedate(){
   var spanname ="changedatespan";
	 var inputname = "changedate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}
function getchangeenddate(){
  
   var spanname ="changeenddatespan";
	 var inputname = "changeenddate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../hrm/resource/HrmResourceEdit.jsp
       ../hrm/search/HrmResourceSearch.jsp
*********************************/
function getHreDate(i){
  WdatePicker({el:'datespan'+i,onpicked:function(dp){
	   $dp.$('dff0'+i).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dff0'+i).value = ''}});
}
function getcontractDate(){
  WdatePicker({el:'contractdatespan',onpicked:function(dp){
			$dp.$('contractdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('contractdate').value = ''}});
}
function getexpiryDate(){
  WdatePicker({el:'expirydatespan',onpicked:function(dp){
			$dp.$('expirydate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('expirydate').value = ''}});
}
function getContractbegintimeDate(){
  WdatePicker({el:'contractbegintimespan',onpicked:function(dp){
			$dp.$('contractbegintime').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('contractbegintime').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceRewardsRecordAdd.jsp,HrmResourceRewardsRecordEdit.jsp
*********************************/
function getRewardsDate(){
   WdatePicker({el:'rewardsdatespan',onpicked:function(dp){
			$dp.$('rewardsdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('rewardsdate').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceTrainRecordAdd.jsp,HrmResourceTrainRecordEdit.jsp
*********************************/
function getTrainstartDate(){
   WdatePicker({el:'trainstartdatespan',onpicked:function(dp){
			$dp.$('trainstartdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('trainstartdate').value = ''}});
}
function getTrainendDate(){
   WdatePicker({el:'trainenddatespan',onpicked:function(dp){
			$dp.$('trainenddate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('trainenddate').value = ''}});
}

/*********************************
 path: ../hrm/report/contract/HrmRpContract.jsp,HrmRpContractDetail.jsp,HrmRpContractType.jsp
       ../hrm/report/extend/HrmRpExtend.jsp,HrmRpExtendDetail.jsp
	   ../hrm/report/rehire/,HrmRpRehire.jsp,HrmRpRehireDetail.jsp
*********************************/
function getfromToDate(){
   WdatePicker({el:'fromTodatespan',onpicked:function(dp){
			$dp.$('fromTodate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('fromTodate').value = ''}});
}
function getendToDate(){
  WdatePicker({el:'endTodatespan',onpicked:function(dp){
			$dp.$('endTodate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('endTodate').value = ''}});
}

/*********************************
 path: ../hrm/report/resource/HrmRpResource.jsp
       ../hrm/search/HrmResourceSearch.jsp
*********************************/
function getstartDateTo(){
   WdatePicker({el:'startdateTospan',onpicked:function(dp){
			$dp.$('startdateTo').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdateTo').value = ''}});
}
function getcontractDateTo(){
   WdatePicker({el:'contractdateTospan',onpicked:function(dp){
			$dp.$('contractdateTo').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('contractdateTo').value = ''}});
}
function getendDateTo(){
   WdatePicker({el:'enddateTospan',onpicked:function(dp){
			$dp.$('enddateTo').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddateTo').value = ''}});
}

/*********************************
 path: ../hrm/schedule/HrmArrangeShift.jsp
*********************************/
function onHrmShowDate(spanname,inputname){
  WdatePicker({el:spanname,onpicked:function(dp){
			$dp.$(inputname).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../hrm/schedule/HrmPubHolidayAdd.jsp
*********************************/
function getholidayDate(){
   WdatePicker({el:'holidaydatespan',onpicked:function(dp){
			$dp.$('holidaydate').value = dp.cal.getDateStr();
			if($dp.$('countryid').value != ''){$dp.$('operation').value = "selectdate";document.frmmain.submit();}},
				oncleared:function(dp){$dp.$('holidaydate').value = ''}});
}

/*********************************
 path: ../hrm/schedule/HrmWorkTimeList.jsp,HrmWorkTimeCreate.jsp,HrmWorkTimeEdit.jsp
       ../hrm/finance/HrmDepSalaryPay.jsp
*********************************/
function getSdDate(spanname,inputname){
   WdatePicker({el:spanname,onpicked:function(dp){
	 //var yandm = $ele4p(inputname).value;
     //$dp.$(spanname).innerHTML = yandm;
	 var resubing =dp.cal.getDateStr(); 
	 $dp.$(inputname).value =resubing.substring(0,7);
	 $dp.$(spanname).innerHTML =resubing.substring(0,7);
	 },
	 oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../hrm/schedule/HrmScheduleMaintanceEdit.jsp
*********************************/
function getSdHrmDate(spanname,inputname){
  WdatePicker({el:spanname,onpicked:function(dp){
	$dp.$(inputname).value = dp.cal.getDateStr();
	if(frmmain.startdate.value != "" && frmmain.enddate.value != "" && frmmain.starttime.value != "" && frmmain.endtime.value != ""){
       frmmain.operation.value="submit";
       frmmain.submit();
      }
	},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../hrm/report/resource/HrmRpResource.jsp
*********************************/
function onRpDateShow(spanname,inputname,isbodymand){
   var oncleaingFun = function(){
		  if(isbodymand == 0){
		     $ele4p(spanname).innerHTML = '';
			 $ele4p(inputname).value = '';
          }else{
		     $ele4p(spanname).innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			 $ele4p(inputname).value = '';
		  }
		}
   WdatePicker({el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;
		$dp.$(spanname).innerHTML = returnvalue;
		},oncleared:oncleaingFun});
 
   if(isbodymand != 0){
    var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
   }
}

/*********************************
 path: ../hrm/performance/goal/myGoalAdd.jsp,myGoalBreak.jsp,myGoalEdit.jsp
*********************************/
function getPfStartDate(){
	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p('startDateSpan').innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p('startDate').value = '';
	      }
	   WdatePicker({maxDate:'#F{$dp.$(\'endDate\').value||\'2020-10-01\'}',el:'startDateSpan',onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$('startDateSpan').innerHTML = returnvalue;
        $dp.$('startDate').value = returnvalue;},oncleared:oncleaingFun});
		var hidename = $ele4p('startDate').value;
		if(hidename != ""){
			$ele4p('startDate').value = hidename; 
			$ele4p('startDateSpan').innerHTML = hidename;
		}else{
	      $ele4p('startDateSpan').innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		}
}
function getPfEndDate(){
  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p('endDateSpan').innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p('endDate').value = '';
	      }
	   WdatePicker({minDate:'#F{$dp.$(\'startDate\').value}',el:'endDateSpan',onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$('endDateSpan').innerHTML = returnvalue;
        $dp.$('endDate').value = returnvalue;},oncleared:oncleaingFun});
		var hidename1 = $ele4p('endDate').value;
		if(hidename1 != ""){
			$ele4p('endDate').value = hidename1; 
			$ele4p('endDateSpan').innerHTML = hidename1;
		}else{
	      $ele4p('endDateSpan').innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		}
}
function getLimitStartDate(startspan,startvalue,endspan,endvalue){
	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(startspan).innerHTML = ""; 
           $ele4p(startvalue).value = '';
	      }
	   WdatePicker({maxDate:'#F{$dp.$(\''+endvalue+'\').value||\'2020-10-01\'}',el:startspan,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(startspan).innerHTML = returnvalue;
        $dp.$(startvalue).value = returnvalue;},oncleared:oncleaingFun});
		var hidename = $ele4p(startvalue).value;
		if(hidename != ""){
			$ele4p(startvalue).value = hidename; 
			$ele4p(startspan).innerHTML = hidename;
		}else{
	      $ele4p(startspan).innerHTML = "";
		}
}
function getLimitEndDate(startspan,startvalue,endspan,endvalue){
 	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(endspan).innerHTML = ""; 
           $ele4p(endvalue).value = '';
	      }
	   WdatePicker({minDate:'#F{$dp.$(\''+startvalue+'\').value}',el:endspan,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(endspan).innerHTML = returnvalue;
        $dp.$(endvalue).value = returnvalue;},oncleared:oncleaingFun});
		var hidename1 = $ele4p(endvalue).value;
		if(hidename1 != ""){
			$ele4p(endvalue).value = hidename1; 
			$ele4p(endspan).innerHTML = hidename1;
		}else{
	      $ele4p(endspan).innerHTML = "";
		}
}

/*********************************
 path: ../hrm/employee/EmployeeAdd.jsp
*********************************/
function getworkdayDate(){
  WdatePicker({el:'workdayspan',onpicked:function(dp){
		$dp.$('workday').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('workday').value = ''}});
}

/*********************************
 path: ../workflow/request/ManageBillCptApply.jsp
*********************************/
function onShowDate1(spanname,inputname,mand){
  var oncleaingFun = function(){
	    if(mand == 1){
		 $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		}else{
		  $ele4p(spanname).innerHTML = '';
		}
		$ele4p(inputname).value = '';
  }
  WdatePicker({el:spanname,onpicked:function(dp){
		$dp.$(inputname).value = dp.cal.getDateStr();
		$dp.$(spanname).innerHTML = dp.cal.getDateStr();
		},oncleared:oncleaingFun});

   if(mand == 1){
    var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
   }
}

/*********************************
 path: ../workplan/data/WorkPlanAdd.jsp
*********************************/
function onshowPlanDate(inputname,spanname){
  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../proj/Templet/TempletTaskEdit.jsp
*********************************/
function gettheProjBDate(){
		WdatePicker({maxDate:'#F{$dp.$(\'enddate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('begindate').value = returnvalue;calculateWorkday();},oncleared:function(dp){$dp.$('begindate').value = ''}});
}
function gettheProjEDate(){
		WdatePicker({minDate:'#F{$dp.$(\'begindate\').value}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('enddate').value = returnvalue;calculateWorkday();},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

/*********************************
 path: ../proj/process/AddTask.jsp
*********************************/
function getProjBDate(){
		WdatePicker({maxDate:'#F{$dp.$(\'enddate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('begindate').value = returnvalue;},oncleared:function(dp){$dp.$('begindate').value = ''}});
}
function getProjEDate(){
		WdatePicker({minDate:'#F{$dp.$(\'begindate\').value}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('enddate').value = returnvalue;},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

/*********************************
 path: ../proj/process/DspMember.jsp,ViewProcessByPic.jsp,ViewProcess.jsp,ProjectTaskApprovalDetail.jsp,ProjextTaskApproval.jsp
       ../proj/plan/ViewPlan.jsp,NewPlan.jsp,DspMember.jsp
*********************************/
function getProjSubDate(spanname,inputname){  
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;weaver.submit();},oncleared:function(dp){$dp.$(inputname).value = '';weaver.submit();}});
}

/*********************************
 path: ../proj/data/EditProjMember.jsp,AddProjMember.jsp
*********************************/
function getBDateP(){
  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p("BDatePspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p('begindate').value = '';
	      }
	   WdatePicker({onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$('BDatePspan').innerHTML = returnvalue;
        $dp.$('begindate').value = returnvalue;},oncleared:oncleaingFun});
}
function getEDateP(){
  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p("EDatePspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p('enddate').value = '';
	      }
	   WdatePicker({onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$('EDatePspan').innerHTML = returnvalue;
        $dp.$('enddate').value = returnvalue;},oncleared:oncleaingFun});
}

/*********************************
 path: ../proj/plan/EditTask.jsp,AddTask.jsp
*********************************/
function getProjPBDate(){
		WdatePicker({maxDate:'#F{$dp.$(\'enddate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('begindate').value = returnvalue;
			weaver.action="/proj/data/TaskCountWorkday.jsp";
	        weaver.submit();
			},oncleared:function(dp){$dp.$('begindate').value = ''}});
}
function getProjPEDate(){
		WdatePicker({minDate:'#F{$dp.$(\'begindate\').value}',el:'enddatespan',onpicked:function(dp){
				var returnvalue = dp.cal.getDateStr();$dp.$('enddate').value = returnvalue;
				var startdate = $dp.$('begindate').value;
				if(startdate=="")
				{
					alert("开始日期未选择，请选择!");
				}
				else
				{
					weaver.action="/proj/data/TaskCountWorkday.jsp";
		        	weaver.submit();
		        }
			},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

/*********************************
 path: ../proj/process/EditTask.jsp
*********************************/
function getcalBeWorkday(){
		WdatePicker({maxDate:'#F{$dp.$(\'enddate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('begindate').value = returnvalue;},
				oncleared:function(dp){$dp.$('begindate').value = ''}});
}
function getcalEeWorkday(){
		WdatePicker({minDate:'#F{$dp.$(\'begindate\').value}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('enddate').value = returnvalue;},
				oncleared:function(dp){$dp.$('enddate').value = ''}});
}
function getActualBDate(){
		WdatePicker({maxDate:'#F{$dp.$(\'actualEndDate\').value||\'2020-10-01\'}',el:'actualBeginDateSpan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('actualBeginDate').value = returnvalue;},oncleared:function(dp){$dp.$('actualBeginDate').value = ''}});
}
function getActualEDate(){
		WdatePicker({minDate:'#F{$dp.$(\'actualBeginDate\').value}',el:'actualEndDateSpan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('actualEndDate').value = returnvalue;},oncleared:function(dp){$dp.$('actualEndDate').value = ''}});
}

function getActualBDate_1(){
		WdatePicker({maxDate:'#F{$dp.$(\'actualEndDate\').value||\'2020-10-01\'}',el:'actualBeginDateSpan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('actualBeginDate').value = returnvalue;},oncleared:function(dp){$dp.$('actualBeginDate').value = ''}});
}
function getActualEDate_1(){
		WdatePicker({minDate:'#F{$dp.$(\'actualBeginDate\').value}',el:'actualEndDateSpan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('actualEndDate').value = returnvalue;},oncleared:function(dp){$dp.$('actualEndDate').value = ''}});
}

/*********************************
 path: ../fna/transaction/FnaTransactionAdd.jsp,FnaTransactionEdit.jsp
*********************************/
function getFnaTaddDate(currentdate){
      var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p("trandatespan").innerHTML = currentdate; 
           $ele4p('trandate').value = currentdate;
	      }
	   WdatePicker({el:'trandatespan',onpicking:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$('trandate').value = returnvalue;},oncleared:oncleaingFun});
}

/*********************************
 path: ../fna/report/RptManagementDetailQuery.jsp,RptOtherArPersonDetailQuery.jsp
*********************************/
function getFnafromDate(){
     WdatePicker({el:'fromdatespan',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('fromdate').value =resubing.substring(0,7);},oncleared:function(dp){$dp.$('fromdate').value = ''}});
}
function getFnaendDate(){
     WdatePicker({el:'enddatespan',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('enddate').value =resubing.substring(0,7);},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

 /*********************************
 path: ../proj/data/AddProject.jsp
       ../cpt/capital/CptCapitalAdd.jsp,CptCapitalEdit
 *********************************/
 function getProjdate(i){ 
   WdatePicker({el:'datespan'+i,onpicked:function(dp){
	   $dp.$('dff0'+i).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dff0'+i).value = ''}});
 }

 /*********************************
 path: ../proj/data/EditProjectTask.jsp
 *********************************/
 function onShowBeginDate(txtObj,spanObj,endDateObj,spanEndDateObj,workLongObj){
	   WdatePicker({el:spanObj,onpicked:function(dp){		
		var returndate = dp.cal.getDateStr();
          onShowBeginDate1(returndate,txtObj,spanObj,endDateObj,spanEndDateObj,workLongObj);
		},
		oncleared:function(dp){$dp.$(txtObj).value = ''}});
}
 function onShowEndDate(txtObj,spanObj,beginDateObj,spanBeginDateObj,workLongObj){
	   WdatePicker({el:spanObj,onpicked:function(dp){		
		var returndate = dp.cal.getDateStr();
          onShowEndDate1(returndate,txtObj,spanObj,beginDateObj,spanBeginDateObj,workLongObj);
		},
		oncleared:function(dp){$dp.$(txtObj).value = ''}});
}

 /*********************************
 path: ../workflow/request/AddRequest.jsp,WorkflowManageSingForBill.jsp
 *********************************/
function onWorkFlowShowDate(spanname,inputname,ismand){	      
	  var returnvalue;	  
	  var oncleaingFun = function(){
		  if(ismand == 1){
			   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
			   $ele4p(inputname).value = '';
		   }else{
		       $ele4p(spanname).innerHTML = ""; 
			   $ele4p(inputname).value = '';
		   } 
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

	if(ismand == 1){
	   var hidename = $ele4p(inputname).value;
		 if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		 }else{
		  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		 }
	}
}

function onFlownoShowDate(spanname,inputname,ismand){	
	  var returnvalue;	  
	  var oncleaingFun = function(){
		  if(ismand == 1){
			   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
			   $ele4p(inputname).value = '';
		   }else{
		       $ele4p(spanname).innerHTML = ""; 
			   $ele4p(inputname).value = '';
		   } 
	      };
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
    if(ismand == 1){
	   var hidename = $ele4p(inputname).value;
		 if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		 }else{
		  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		 }
	}
}

function onBoHaiShowDate(spanname,inputname,ismand){	
	  var returnvalue;	  
	  var oncleaingFun = function(){
		  if(ismand == 1){
			   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
			   $ele4p(inputname).value = '';
		   }else{
		       $ele4p(spanname).innerHTML = ""; 
			   $ele4p(inputname).value = '';
		   } 
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;getLeaveDays();},oncleared:oncleaingFun});

      if(ismand == 1){
	   var hidename = $ele4p(inputname).value;
		 if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		 }else{
		  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		 }
	 }
}

/*********************************
 path: ../cpt/cpital/CptCapitalBack.jsp,CptCapitalDiscard.jsp,CptCapitalUse.jsp
*********************************/
function getdiscardDate(spanname,inputname){
	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalEdit.jsp
*********************************/
function getStockInDate(){
     WdatePicker({el:'getStockInDate',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('StockInDate').value =resubing.substring(0,7);},oncleared:function(dp){$dp.$('StockInDate').value = ''}});
}

/*********************************
 path: ../cpt/capital/CptCapitalLend.jsp
*********************************/
function getlendDate(){
     var spanname ="lenddatespan";
	 var inputname = "lenddate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalLoss.jsp
*********************************/
function getlossDate(){
    var spanname ="lossdatespan";
	 var inputname = "lossdate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalMend.jsp
*********************************/
function getmendDate(){
	var spanname ="menddatespan";
	 var inputname = "menddate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalMove.jsp
*********************************/
function getmoveinDate(){
	var spanname ="moveindatespan";
	 var inputname = "moveindate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalInstock2.jsp
*********************************/
function getinstockDate(){
    var spanname ="instockdatespan";
	 var inputname = "instockdate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalMoveOut.jsp
*********************************/
function getmoveoutDate(){
	var spanname ="moveoutdatespan";
	 var inputname = "moveoutdate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalOther.jsp
*********************************/
function getotherDate(){
   var spanname ="otherdatespan";
	 var inputname = "otherdate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalReturn.jsp
*********************************/
function getreturnDate(){
	var spanname ="returndatespan";
	 var inputname = "returndate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalEdit.jsp
*********************************/
function getDeprestartdate(){
     WdatePicker({el:'deprestartdatespan',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('deprestartdate').value =resubing.substring(0,7);},oncleared:function(dp){$dp.$('deprestartdate').value = ''}});
}

/*********************************
 path: ../cpt/capital/CptCapitalEdit.jsp
*********************************/
function getmanuDate(){
     WdatePicker({el:'manudatespan',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('manudate').value =resubing.substring(0,7);},oncleared:function(dp){$dp.$('manudate').value = ''}});
}

/*********************************
 path: ../cpt/car/CptCapitalList.jsp,CptCapitalSalaryRp.jsp,CptCapitalSalaryTotalRp.jsp,CarUseRp.jsp,CarUseTotalRp.jsp
*********************************/
function getStartdate1(){
     WdatePicker({el:'startdate1span',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('startdate1').value =resubing;frmmain.submit();},oncleared:function(dp){$dp.$('startdate1').value = ''}});
}
function getStartdate2(){
     WdatePicker({el:'startdate2span',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('startdate2').value =resubing;frmmain.submit();},oncleared:function(dp){$dp.$('startdate2').value = ''}});
}

/*********************************
 path: ../hrm/schedule/hrmPubHolidayAdd.jsp
*********************************/
function getholiday1Date(){
   WdatePicker({el:'holidaydatespan',onpicked:function(dp){
			$dp.$('holidaydate').value = dp.cal.getDateStr();
			if($dp.$('countryid').value != ''){$dp.$('operation').value = "selectdate";
			document.frmmain.submit();}},
				oncleared:function(dp){
				//$dp.$(holidaydate).value = '';
				document.getElementById('holidaydatespan').innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
                $dp.$('holidaydate').value = '';
				}});
}

/*********************************
 path: ../cpt/cpital/CptCapitalBack.jsp,CptCapitalDiscard.jsp
*********************************/
function gethandoverDate(){
   var spanname ="handoverdatespan";
	 var inputname = "handoverdate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	 }
}