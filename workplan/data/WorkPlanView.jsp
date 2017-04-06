<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@page import="weaver.Constants"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<html >
<head id="Head1">
	<%
		String curSkin=(String)session.getAttribute("SESSION_CURRENT_SKIN");
		String selectedUser=Util.null2String(request.getParameter("selectUser"));
		if("".equals(selectedUser)){
			selectedUser=""+user.getUID();
		}
		String selectedUserName=ResourceComInfo.getFirstname(selectedUser);
		
		List workPlanTypeForNewList=new ArrayList();
		recordSet.executeSql("SELECT * FROM WorkPlanType" + Constants.WorkPlan_Type_Query_By_Menu);
		while(recordSet.next()){
			Map item=new HashMap();
			item.put("id",recordSet.getString("workPlanTypeID"));
			item.put("name",recordSet.getString("workPlanTypeName"));
			workPlanTypeForNewList.add(item);
		}
		List workPanTypeList=new ArrayList();
		recordSet.executeSql("SELECT * FROM WorkPlanType WHERE available = '1' ORDER BY displayOrder ASC");
		while(recordSet.next()){
			Map item=new HashMap();
			item.put("id",recordSet.getString("workPlanTypeID"));
			item.put("name",recordSet.getString("workPlanTypeName"));
			workPanTypeList.add(item);
		}
	%>
    <title>	My Calendar </title>
    <meta http-equiv="Content-Type" content="text/html;charset=gbk">
    <link href="/workplan/calendar/css/calendar.css" rel="stylesheet" type="text/css" /> 
    <link href="/workplan/calendar/css/dp.css" rel="stylesheet" type="text/css" />   
    <link href="/workplan/calendar/css/main.css" rel="stylesheet" type="text/css" /> 
    <link href="/css/Weaver.css" rel="stylesheet" type="text/css" /> 
    <link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont.css' id="FONT2SYSTEMF" />
	<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curSkin %>/wui.css'/>
	 <link href="/workplan/calendar/css/editbox.css" rel="stylesheet" type="text/css" /> 
    <script src="/workplan/calendar/src/jquery.js" type="text/javascript"></script>  
       
    <script src="/workplan/calendar/src/Plugins/Common.js" type="text/javascript"></script>    
<%
    if(user.getLanguage()==8){
%>
    <script src="/workplan/calendar/src/Plugins/datepicker_lang_US.js" type="text/javascript"></script> 
<%
	}else if(user.getLanguage()==9){
%>
    <script src="/workplan/calendar/src/Plugins/datepicker_lang_HK.js" type="text/javascript"></script> 
<%
    }else{
%>
    <script src="/workplan/calendar/src/Plugins/datepicker_lang_ZH.js" type="text/javascript"></script> 
<%
    }
%>	
    <script src="/workplan/calendar/src/Plugins/jquery.datepicker.js" type="text/javascript"></script>

<%
    if(user.getLanguage()==8){
%>
    <script src="/workplan/calendar/src/Plugins/wdCalendar_lang_US.js" type="text/javascript"></script>  
<%
	}else if(user.getLanguage()==9){
%>
    <script src="/workplan/calendar/src/Plugins/wdCalendar_lang_HK.js" type="text/javascript"></script>  
<%
    }else{
%>
    <script src="/workplan/calendar/src/Plugins/wdCalendar_lang_ZH.js" type="text/javascript"></script>  
<%
    }
%>
  

    <script src="/workplan/calendar/src/Plugins/jquery.calendar.js" type="text/javascript"></script>   
    <script type="/js/jquery/ui/ui.dialog.js"  type="text/javascript"></script>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
	<script type="text/javascript" src="/js/weaver.js"></script>
	<script type="text/javascript" src="/js/workplan/workplan.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog.js"></script>
<script type="text/javascript">

var selectedUser="<%=selectedUser%>";
var selectedUserName="<%=ResourceComInfo.getLastname(selectedUser)%>";
var isShare="<%=Util.null2String(request.getParameter("isShare"))%>";
var workPlanTypeForNewList=<%=JSONArray.fromObject(workPlanTypeForNewList).toString()%>;
var workPanTypeList=<%=JSONArray.fromObject(workPanTypeList).toString()%>;
var dialog2=new Dialog();
dialog2.ID="shareEvent";
var dialog=new Dialog();
dialog.ID="shareEventID";
dialog.InvokeElementId="editBox";
var viewCalendarDialog=new Dialog();
viewCalendarDialog.ID="viewCalendarDialog";
viewCalendarDialog.InvokeElementId="workPlanViewSplash";
viewCalendarDialog.Height="400";
</script>

<style>
	.fcurrent{
		background:#2e9eb2!important;
		color:white;
	}

	.gcweekname ,.mv-dayname,.wk-dayname,.wk-dayname{
		background:url('/workplan/calendar/css/images/caledartitlebg.png');
	}

	#dvwkcontaienr{		
		
	}
	#weekViewAllDaywkBox{
		height:70px;
		overflow-y:scroll;
	}
	.Line{
		padding:0;
	}
</style>

   <script type="text/javascript">
        $(document).ready(function() {     
           var view="week";          
           
            var DATA_FEED_URL = "/workplan/calendar/data/getData.jsp";
            var op = {
                view: view,//指定显示的视图（周，月，日）
                theme:1,//指定默认模板，比如拖拽新建日程时日程的颜色
                showday: new Date(),//指定显示的日期，在视图中显示的日， 周，月为当前指定日期所在的日，周，月。
                EditCmdhandler:Edit,//编辑日程的回调函数
                DeleteCmdhandler:Delete,//删除日程的回调函数
                ViewCmdhandler:View,    //查看日程的回调函数
                onWeekOrMonthToDay:wtd,
                onBeforeRequestData: cal_beforerequest,//ajax请求前 的操作
                onAfterRequestData: cal_afterrequest,//ajax请求成功完成之后的操作
                onRequestDataError: cal_onerror, //ajax请求失败的操作
                autoload:true,
                selectedUser:selectedUser,//指定当前选定的人员
                isShare:isShare,//（isShare：1 显示“所有日程”，其他：显示“我的日程”
                url: DATA_FEED_URL + "?method=list&selectUser=",  //视图中日程项数据请求url
                quickAddUrl: DATA_FEED_URL + "?method=addCalendarItem&selectUser=",//拖拽方式添加日程url
                quickUpdateUrl: DATA_FEED_URL + "?method=editCalendarItemQuick&selectUser=",//拖动调整日程时间url
                quickDeleteUrl: DATA_FEED_URL + "?method=deleteCalendarItem&selectUser=" ,//快速删除日程url
                quickEndUrl: DATA_FEED_URL + "?method=deleteCalendarItem&selectUser=" ,//删除日程url
                getEventItemUrl: DATA_FEED_URL + "?method=getCalendarItem&selectUser="  ,//获取单个日程明细的url
                updateEvent:  DATA_FEED_URL + "?method=editCalendarItem&selectUser="    ,//更新日程信息的url
                getSubordinateUrl: DATA_FEED_URL+"?method=getSubordinate&selectUser=",//获取当前选中人员下属名单的url
                overCalendarItemUrl:DATA_FEED_URL+"?method=overCalendarItem&selectUser&selectUser="//结束日程url
            };
            var $dv = $("#calhead");
            var _MH = document.documentElement.clientHeight;
            var dvH = $dv.height() + $dv.offset().top+10+2;
            op.height = _MH - dvH;
            op.eventItems =[];

            var p = $("#gridcontainer").bcalendar(op).BcalGetOp();
            if (p && p.datestrshow) {
                $("#txtdatetimeshow").text(p.datestrshow);
            }
            //显示时间控件 
            $("#hdtxtshow").datepicker({ picker: "#txtdatetimeshow", showtarget: $("#txtdatetimeshow"),
            onReturn:function(r){                      
                		   
                        var p = $("#gridcontainer").gotoDate(r).BcalGetOp();
                        if (p && p.datestrshow) {
                            $("#txtdatetimeshow").text(p.datestrshow);
                        }
                 } 
            });
            function cal_beforerequest(type)
            {
                var t="Loading data...";
                switch(type)
                {
                    case 1:
                        t="<%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%>"; //页面加载中，请稍候...
                        break;
                    case 2:   
                        t="<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>"; //正在保存，请稍等...
                        break;                   
                    case 3:  
                        t="<%=SystemEnv.getHtmlLabelName(28060,user.getLanguage())%>"; //正在删除日程，请稍后...
                        break;   
                    case 4:    
                        t="<%=SystemEnv.getHtmlLabelName(25008,user.getLanguage())%>";                                   
                        break;
                }
                $("#errorpannel").hide();
                $("#loadingpannel").html(t).show();    
            }
            function Edit(data,a)
            {
                $("#calendarBtns").hide();
               	$("#crmTools").hide();
               
           	 	dialog.Width=500;
           	 	dialog.Height=400;
           	 	dialog.OnLoad=function(){
           	 
                 };
                if(data)
                {
                	
                    if(data[0]=="0"){
                    	NewEvent(data);
                    }else{
                    	var param={
                    			id:data[0]
                    		};
                    	p.onBeforeRequestData && p.onBeforeRequestData(1);
                    	$.post(p.getEventItemUrl+p.selectedUser,param,function(data){
                        	var calendarEvent=new WorkPlanEvent(data);
                        	calendarEvent.FillWorkPlanView();
                        	 $("#editBox").css("visibility","visible");
                        	 p.onAfterRequestData && p.onAfterRequestData(1);
                        	 if(data.shareLevel>1){
                            		dialog.OKEvent=function(){
                            			$("#saveBtn").click();
                            			
                                	};
                            		 dialog.show();
                            		 dialog.okButton.value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>";
                            		 dialog.cancelButton.value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";
                             }else{
                              }
                        	
                        },"json");
                    }
                   
                }
            } 
			function NewEvent(data){
				var calendar1=new WorkPlanEvent({});
            	calendar1.clearWorkPlanView();
                $("input[name=eventId]").val(data[0]);
                $("#planName").val(data[1]);
                if(data[1]){
                	$("#planName").next().hide();	
                  }else{
                	  $("#planName").show();
                    }
                $("#beginDate").val(data[2]);
                $("#beginTime").val(data[3]);
                $("#endDate").val(data[4]);
                $("#endTime").val(data[5]);
                $("#beginDateSpan").text(data[2]);
                $("#beginTimeSpan").text(data[3]);
                $("#endDateSpan").text(data[4]);
                $("#endTimeSpan").text(data[5]);
                $("#memberIDs").val(selectedUser);
            	$("#memberIDsSpan").text(selectedUserName);
           	 	$("#remindInfo").hide();
           	 $("#editBox input").attr("disabled",false);
 			$("#editBox select").attr("disabled",false);
 			$("#editBox textarea").attr("disabled",false);
 			$("#editBox button").show();
           	 	dialog.OKEvent=function(){
        			$("#saveBtn").click();
            	};
            	 
           	    dialog.show();	
           	    dialog.okButton.value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%> "
           	    	$("#editBox").css("visibility","visible");
           	    dialog.cancelButton.value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";
			}

            function View(data0)
            {
            	viewCalendarDialog.Width=500;
            	viewCalendarDialog.Height=400;
                var p = $("#gridcontainer").BcalGetOp();
                var param={
            			id:data0[0]
            		};
            	p.onBeforeRequestData && p.onBeforeRequestData(1);
            	$.post(p.getEventItemUrl+p.selectedUser,param,function(data){
            		
                	var canFinish=false;//是否可以结束日程
                	var canEdit=false;//是否可以编辑日程
                	var canView=false;//是否可以查看日程
                	var canValuate=false;//是否可以共享日程
                	var inMember=false;//是否是接收人
                	var memversIdsArr=data.executeId.split(",")
                	for(var i=0;i<memversIdsArr.length;i++){
						if(memversIdsArr[i]==selectedUser){
							inMember=true;
							break;
						}
                    }
                	if(data&&data.id){
                		canView=true;
                		if(data.shareLevel=="2"){
							canEdit=true;
                        }
                        if(data.status!="0"){
							canEdit=false;
                         }
                        if(data.status=="0"&&(canEdit||inMember)){
                        	canFinish=true;		
                         }
                        
                    }
                    
                	p.onAfterRequestData && p.onAfterRequestData(1);
               	 var calendarEvent=new WorkPlanEvent(data);
               	 if(canView){
               		calendarEvent.FillWorkPlanViewSplash();
               		
               	 }else{
                   	 alert("<%=SystemEnv.getHtmlLabelName(30816,user.getLanguage())%>");
					return;
                  }
                 
                    if(canFinish){
                    	viewCalendarDialog.OKEvent=function(){
                   			$("#EndEventBtns").click();
                       	};
                       	
                       	viewCalendarDialog.show();
                       	viewCalendarDialog.okButton.value="<%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>";
                       	viewCalendarDialog.cancelButton.value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";
                    }
                    if(!canFinish){
                    	viewCalendarDialog.OKEvent=function(){
                   			Dialog.close();
                       	};
                    	viewCalendarDialog.show();
                    	$("#_ButtonCancel_viewCalendarDialog").hide();
                    }
                    if(canEdit){
                    	viewCalendarDialog.addButton("<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>",function(){
							Dialog.close();
								Edit([data.id]);
							
                         });
                    	viewCalendarDialog.addButton("<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>",function(){
          					$("#DeleteBtn").click();
                     	});
                    }
                    if(data.canShare=="true"){
                    	viewCalendarDialog.addButton("<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%> ","<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%> ",function(){
                   			viewCalendarDialog.close();
            					 dialog2.InvokeElementId="workPlanShareSplash";
            					 fillShare(data.id);
            					 if(data.shareLevel>1){
            						
                     			 }
                     			 dialog2.Width=500;
            	                 dialog2.Height=450;
            					 dialog2.show();
            						
                         	 });
            			 
                    }
					
                   	 
            	},"json");         
            }   
            function cal_afterrequest(type)
            {
                switch(type)
                {
                    case 1:
                        $("#loadingpannel").hide();
                        break;
                    case 2:
                        $("#loadingpannel").html("<%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%>!");
                        window.setTimeout(function(){ $("#loadingpannel").hide();},2000);
                    case 3:
                    case 4:
                        $("#loadingpannel").html("<%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>!");
                        window.setTimeout(function(){ $("#loadingpannel").hide();},2000);
                    break;
                }              
               
            }
            function cal_onerror(type,data)
            {
                $("#errorpannel").show();
            }
              
            
          
            function wtd(p)
            {
               if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
                $("div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $("#showdaybtn").addClass("fcurrent");
				
            }
            //to show day view
            $("#showdaybtn").click(function(e) {
                //document.location.href="#day";
                $("div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("day").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
				
				$("#showtodaybtn").text("<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%> ");
            });
            //to show week view
            $("#showweekbtn").click(function(e) {
                //document.location.href="#week";
                $("div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("week").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }

				$("#showtodaybtn").text("<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%> ");

            });
            //to show month view
            $("#showmonthbtn").click(function(e) {
                //document.location.href="#month";
                $(".fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("month").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }

				$("#showtodaybtn").text("<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%> ");
            });
            //refresh current View
            $("#showreflashbtn").click(function(e){
            	 $("#gridcontainer").reload();
            });
            
            //Add a new event
            $("#faddbtn").click(function(e) {
            	var calendar= new WorkPlanEvent({});
            	calendar.clearWorkPlanView();
            	  var today=new Date();
            	  var year=today.getFullYear();
            	  var month=today.getMonth()+1;
            	  var day=today.getDate();
            	  var hours=today.getHours();
            	  var min=today.getMinutes();
            	  
                  var data=["0",
                         "",
                         ""+year+"-"+(month>9?month:"0"+month)+"-"+(day>9?day:"0"+day),
                         ""+(hours>9?hours:"0"+hours)+":"+(min>9?min:"0"+min),"",""];
                 Edit(data);
            	$("#memberIDs").val(selectedUser);
            	$("#memberIDsSpan").text(selectedUserName);
            	
            });
            //go to today
            $("#showtodaybtn").click(function(e) {
                var p = $("#gridcontainer").gotoDate().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }


            });
            //previous date range
            $("#sfprevbtn").click(function(e) {
                var p = $("#gridcontainer").previousRange().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }

            });
            //next date range
            $("#sfnextbtn").click(function(e) {
                var p = $("#gridcontainer").nextRange().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
            });
            $("#cancelEditBtn").click(function(E){
                $("#editBox").css("visibility","hidden");
                $("#editButtons").hide();
                $("#calendarBtns").show();
                });
            $("#saveBtn").click(function(e){
                if(!validateForm()){
					alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
					return;
                }
                var data={};
				var calendar=new WorkPlanEvent({});
				calendar.generateData(data);
				var url=(data.id==""||data.id=="0")?p.quickAddUrl:p.updateEvent;
				p.onBeforeRequestData && p.onBeforeRequestData(2);
				$.post(url+p.selectedUser+"&isShare="+p.isShare,data,function(dataBack){
						$("#cancelEditBtn").click();
						
						$("#editBox").css("visibility","hidden");
						$("#showreflashbtn").click();
						p.onAfterRequestData && p.onAfterRequestData(2);
						Dialog.close()
				},"json");
            });
            $("#DeleteBtn").click(function(){
            	Dialog.confirm(
             			"<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
             				var workplanId=$("#workplanIdView").val();
                        	try{
                        		workplanId=parseInt(workplanId);
                             }catch (e) {
                            	 workplanId=0;
        					}
                             
         					if(workplanId>0){
         	 					
        						var param={id:workplanId};
        						$.post(p.quickDeleteUrl+p.selectedUser+"&isShare="+p.isShare,param,function(data){
        							if(data.IsSuccess){
        								$("#gridcontainer").reload();
        								$("#editBox").css("visibility","hidden");
        								$("#cancelEditBtn").click();
        								Dialog.close()
        							}
        						},"json");
         					}else{
         	 				}
             			}, function () {}, 220, 90,false
             	    );
				
            	
             });
            $("#EndEventBtns").click(function(){
				
						var workplanId=$("#workplanIdView").val();
		            	try{
		            		workplanId=parseInt(workplanId);
		                 }catch (e) {
		                	 workplanId=0;
						}
							if(workplanId>0){
							var param={id:workplanId};
							$.post(p.overCalendarItemUrl+p.selectedUser+"&isShare="+p.isShare,param,function(data){
								if(data.IsSuccess){
									$("#gridcontainer").reload();
									$("#editBox").css("visibility","hidden");
									$("#cancelEditBtn").click();
									Dialog.close()
								}else{
								}
							},"json");
							}else{
			 				}
					
             });
            $("#currentUserSpan").live("click",function(e){
				if($("#subordinateDivList").css("display")=="none"){
					$("#subordinateDivList").show();
				}else{
					$("#subordinateDivList").hide();
					return;
				}
				$("#subordinateDivList").css({
						"left":$(this).offset().left-$("#subordinateDivList").width()+$(this).width()+"px",
						"top":$(this).offset().top+$(this).height()+"px"
					});
             });
            setUser(selectedUser);


		    $("#showweekbtn").trigger("click");
           
        });
        function Delete(data,callback)
        {        
            Dialog.confirm(
        			"<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
        				 callback(0);
        				 
        			}, function () {}, 220, 90,false
        	    );
          }
        function onUserSelected(data){
        	setUser(data.id);
        	
        }
        function onCurrentUserChange(){
        	 var p = $("#gridcontainer").BcalGetOp();
			 var selectedUser1=$("#subordinate").val();
			 setUser(selectedUser1);
        }
        function showMyCalnedar(){
        	setUser(selectedUser);
         }
        function subordinateDivListSelected(userid,userName){
			$("#currentUserSpan").text(userName);
			$("#currentUser").val(userid);
			setUser(userid);
			$("#subordinateDivList").hide();
			
         }
        function setUser(userID){
        	var p = $("#gridcontainer").BcalGetOp();
			var  selectedUser1=userID;
			 p.selectedUser=userID;

			 var opts=document.getElementById("subordinate");
			 if(userID==$("#currentUser").val()){
				
			 }
			 else if(userID!=selectedUser){
			 	$("#currentUser").val(userID);
			 	$("#currentUserSpan").text(opts[opts.selectedIndex].text);
			}else {
				$("#currentUser").val(selectedUser);
			 	$("#currentUserSpan").text(selectedUserName);
			}
			 var param={"userId":userID};
			 $.post(p.getSubordinateUrl,param,function(data){
					if(data){
						for(var i=opts.length;i>0;i--){
							$(opts[i]).remove();
						}
						for(var i=0;i< data.length;i++){
							var user=data[i];
							$("#subordinate").append("<option value='"+user.id+"'>"+user.name+"</option");
						}

						$("#subordinateDivList .title").text($("#currentUserSpan").text()+"<%=SystemEnv.getHtmlLabelName(30805,user.getLanguage())%>:");
			        	var subordinates=$("#subordinate").children();
			        	var list=$($("#subordinateDivList .list")[0]);
			        	list.empty();
			        	for(var i=1;i<subordinates.length;i++ ){
							list.append("<li><a href=\"javascript:subordinateDivListSelected(\'"
										+$(subordinates[i]).val()+"\',\'"+$(subordinates[i]).text()+"\')\">"+$(subordinates[i]).text()+"</a></li>");
			            }
					}
					 $("#gridcontainer").reload();
				},"json");
			
			 
      	}
       
      	function onSharedCalendar(e){
			var targetValue=$.event.fix(e).target.value;
			var p = $("#gridcontainer").BcalGetOp();
			if(targetValue=="2"){
				isShare=1;
				p.isShare=isShare;

				$("#gridcontainer").reload();
			}else{
				isShare="";
				p.isShare=isShare;
				setUser(selectedUser);
				
			}
			
			
        }
        function validateForm(){
				isValidate=true;
				if($("#planName").val()==""){
					isValidate=false;
			    }
				if($("#description").val()==""){
					isValidate=false;
			    }
				if($("#memberIDs").val()==""){
					isValidate=false;
				}
				return isValidate;
        }
       
    </script>    

</head>
<%
      String addBtnUrl="/workplan/calendar/css/images/icons/addBtn.png";
	  if(user.getLanguage()==8){
		  addBtnUrl="/workplan/calendar/css/images/icons/addBtn_EN.png";
	  }
%>
<body scroll="no">

	<%@ include file="/workplan/data/ShareCalendarSegment.jsp" %>
	<%@ include file="/workplan/data/CreateCalendarSegment.jsp" %>
	<%@ include file="/workplan/data/ViewCalendarSegment.jsp" %>
    <div>
	
      <div id="calhead" class="calHead" style="padding-left:10px;padding-top:10px;">
      		<div  style="float:left;">
      			<div id="faddbtn" class="calHeadBtn" style="border:none;height:25px;width:65px;background:url(<%=addBtnUrl%>) no-repeat;">
      				
      			</div>
		      		<div id="showtodaybtn" unselectable="on" class="calHeadBtn" style="margin-left:10px;">
		      			<%=SystemEnv.getHtmlLabelName( 15537 ,user.getLanguage())%> 
		      		</div>
		      		<div id="sfprevbtn" unselectable="on" class="calHeadBtn" style="margin-left:10px;width:23px;_width:25px;">
		      			&#60;
		      		</div>
		      		<div id="sfnextbtn" unselectable="on" class="calHeadBtn" style="border-left:none;width:23px;_width:25px;">
		      			&#62;
		      		</div>
		      		
		      		<div id="txtdatetimeshow" unselectable="on" class="calHeadBtn" style="margin-left:10px;width:auto;padding-left:25px;padding-right:10px;background:url(/workplan/calendar/css/images/icons/date.png) no-repeat;background-position:6px 50%">
		      			<input type="hidden" name="txtshow" id="hdtxtshow" />
		      			<%=SystemEnv.getHtmlLabelName( 27938 ,user.getLanguage())%> 
		      		</div>
      		</div>
      		<div id="editButtons" style="float:left;display:none;">
            	<div class="calHeadBtn" id="saveBtn">
            			<span class="saveCal"><%=SystemEnv.getHtmlLabelName( 86 ,user.getLanguage())%> </span>
            	</div>
            	<div class="calHeadBtn" id="cancelEditBtn">
            			<span class="cancelCalEdit"><%=SystemEnv.getHtmlLabelName( 201 ,user.getLanguage())%> </span>
            	</div>
            	<div class="calHeadBtn" id="DeleteBtn">
            			<span class="deleteCal"><%=SystemEnv.getHtmlLabelName( 23777 ,user.getLanguage())%> </span>
            	</div>
            	<div class="calHeadBtn" id="EndEventBtns">
            			<span class="endCal"><%=SystemEnv.getHtmlLabelName( 22177 ,user.getLanguage())%>  </span>
            	</div>
            	
            </div>
      		<div style="float:right;padding-right:10px;">
      			
	      		<div id="showdaybtn" unselectable="on" class="calHeadBtn" style="margin-left:10px;width:50px;_width:25px;">
	      			<%=SystemEnv.getHtmlLabelName( 27296 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showweekbtn" unselectable="on" class="calHeadBtn" style="border-left:none;width:50px;_width:25px;">
	      			<%=SystemEnv.getHtmlLabelName( 1926 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" class="calHeadBtn" style="border-left:none;width:50px;_width:25px;">
	      			<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%> 
	      		</div>
	      		
	      		<div id="showreflashbtn" unselectable="on" class="calHeadBtn" style="border-left:none;width:50px;_width:25px;">
	      			<%=SystemEnv.getHtmlLabelName( 354 ,user.getLanguage())%> 
	      		</div>
	      		
	      		<div  unselectable="on" class="calHeadBtn" style="margin-left:10px;width:auto !important;padding-left:10px;padding-right:10px;text-align:left;" >
            		
								<input type="hidden" class="wuiBrowser" value="<%=selectedUser %>" id="currentUser"
										 _displayText="<%=ResourceComInfo.getLastname(selectedUser) %>"
										 _url="/hrm/resource/ResourceBrowser.jsp" 
										 _callBack="onUserSelected"
								 />
								<select onchange="onCurrentUserChange()" id="subordinate" name="subordinate" style="display:none;"> 
									<option><%=SystemEnv.getHtmlLabelName( 18214 ,user.getLanguage())%> </option>
									<%
										recordSet.executeProc("HrmResource_SelectByManagerID", selectedUser);
										while(recordSet.next()){
											String id=Util.null2String(recordSet.getString("id"));
									%>
										<option value="<%=id %>"><%=ResourceComInfo.getResourcename(id) %></option>
									<%} %>
								</select>
	      		</div>
	      		<div  unselectable="on" class="calHeadBtn" style="border-left:none;" onclick="showMyCalnedar()">
	      			<%=SystemEnv.getHtmlLabelName( 18480 ,user.getLanguage())%> 
	      		</div>
      		</div>
      </div>
      <div style="padding:1px;">

        <div class="t1 chromeColor">
            &nbsp;</div>
        <div class="t2 chromeColor">
            &nbsp;</div>
        <div id="dvCalMain" class="calmain printborder" style="position:relative">
            <div id="gridcontainer" style="overflow-y: visible;visibility:visible">
            </div>
            
        </div>
        <div class="t2 chromeColor">

            &nbsp;</div>
        <div class="t1 chromeColor">
            &nbsp;
        </div>   
        </div>
  </div>
  <div id="subordinateDivList" >
  		<div class="title"></div>
		<ul class="list">
			
		</ul>
	</div>
	
	<div id="loadingpannel" class="loading" style="height:20px;position:absolute;top:0;right:0;background:rgb(217, 102, 102);"></div>

</body>
</html>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<script type="text/javascript">
$(document).bind("click",function(e){
	var target=$.event.fix(e).target;
	if($(target).attr("id")!="currentUserSpan"){
		$("#subordinateDivList").hide();
	}
});
document.oncontextmenu=function(){
	   return false;
	}
function expand(e){
	tg=e.target||e.srcElement;
	if($(tg).hasClass("expandUnClose")){
		$(tg).removeClass("expandUnClose");
	}else{
			$(tg).addClass("expandUnClose");
	}
}

function onShowResource(inputname,spanname){
	 linkurl="javaScript:openhrm(";
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+$("input[name="+inputname+"]").val());
	   if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href=\"/hrm/resource/HrmResource.jsp?id="+ids[i]+"\"  target='_blank'>"+names[i]+"</a>&nbsp;";
				    	
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id.indexOf(",")!=0?datas.id:datas.id.substring(1));
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
}}
function onshowRequest(inputname,spanname){
	var data=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="+$("input[name="+inputname+"]").val());
	if(data){
		if(data.id){
			ids = data.id.split(",");
		    names =data.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<A href='/workflow/request/ViewRequest.jsp?requestid="+ids[i]+"' target='_blank'>"+names[i]+"</A>&nbsp;";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(data.id.indexOf(",")!=0?data.id:data.id.substring(1));
		}else{
			$("#"+spanname).html("");
		    $("input[name="+inputname+"]").val("");
		}
	}
}
function onShowProject(inputname,spanname){
	var data=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids="+$("input[name="+inputname+"]").val());
	if(data){
		if(data.id){
			ids = data.id.split(",");
		    names =data.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<A href='/proj/data/ViewProject.jsp?ProjID="+ids[i]+"' target='_blank'>"+names[i]+"</A>&nbsp;";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(data.id.indexOf(",")!=0?data.id:data.id.substring(1));
		}else{
			$("#"+spanname).html("");
		    $("input[name="+inputname+"]").val("");
		}
	}
}
function onShowDoc(inputname,spanname){
			var data=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+$("input[name="+inputname+"]").val());
		if(data){
			if(data.id){
				ids = data.id.split(",");
			    names =data.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<A href='/docs/docs/DocDsp.jsp?id="+ids[i]+"' target='_blank'>"+names[i]+"</A>&nbsp;";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(data.id.indexOf(",")!=0?data.id:data.id.substring(1));
			}else{
				$("#"+spanname).html("");
			    $("input[name="+inputname+"]").val("");
			}
		}	
}
function onshowCrms(inputname,spanname){
	var data=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+$("input[name="+inputname+"]").val());
	if(data){
		if(data.id){
			ids = data.id.split(",");
		    names =data.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<A href=/CRM/data/ViewCustomer.jsp?CustomerID="+ids[i]+" target='_blank'>"+names[i]+"</A>&nbsp;";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(data.id.indexOf(",")!=0?data.id:data.id.substring(1));
		}else{
			$("#"+spanname).html("");
		    $("input[name="+inputname+"]").val("");
		}
	}	
	
}

Date.prototype.format = function(format)   
{   
   var o = {   
     "M+" : this.getMonth()+1, //month   
     "d+" : this.getDate(),    //day   
     "h+" : this.getHours(),   //hour   
     "m+" : this.getMinutes(), //minute   
     "s+" : this.getSeconds(), //second   
     "q+" : Math.floor((this.getMonth()+3)/3), //quarter   
     "S" : this.getMilliseconds() //millisecond   
   }   
   if(/(y+)/.test(format)) format=format.replace(RegExp.$1,   
     (this.getFullYear()+"").substr(4 - RegExp.$1.length));   
   for(var k in o)if(new RegExp("("+ k +")").test(format))   
     format = format.replace(RegExp.$1,   
       RegExp.$1.length==1 ? o[k] :    
         ("00"+ o[k]).substr((""+ o[k]).length));   
   return format;   
} 
</script>

