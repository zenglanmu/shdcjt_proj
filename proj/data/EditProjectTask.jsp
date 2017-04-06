<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetRight" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>

<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>


<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
String from = Util.null2String(request.getParameter("from"));

/*合同*/
String contractids_prj="";
String sql_conids="select id from CRM_Contract where projid ="+ProjID;
RecordSet.executeSql(sql_conids);
while(RecordSet.next()){
    contractids_prj += ","+ RecordSet.getString("id");
}
if(!contractids_prj.equals("")) contractids_prj =contractids_prj.substring(1);

String connames="";
if(!contractids_prj.equals("")){
    ArrayList conids_muti = Util.TokenizerString(contractids_prj,",");
    int connum = conids_muti.size();
    for(int i=0;i<connum;i++){
        connames= connames+"<a href=/CRM/data/ContractView.jsp?id="+conids_muti.get(i)+">"+Util.toScreen(ContractComInfo.getContractname(""+conids_muti.get(i)),user.getLanguage())+"</a>" +" ";               
    }
} 



/*项目状态*/
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID;
RecordSet.executeSql(sql_tatus);
RecordSet.next();
String isactived=RecordSet.getString("isactived");
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划

String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
RecordSet.executeSql(sql_prjstatus);
RecordSet.next();
String status_prj=RecordSet.getString("status");
if(isactived.equals("2")&&(status_prj.equals("3")||status_prj.equals("4"))){//项目冻结或者项目完成
	response.sendRedirect("ViewProject.jsp?ProjID="+ProjID);
}
//status_prj=5&&isactived=2,立项批准
//status_prj=1,正常
//status_prj=2,延期
//status_prj=3,终止
//status_prj=4,冻结

/*查看项目成员*/
String sql_mem="select members from Prj_ProjectInfo where id= "+ProjID ;
RecordSet.executeSql(sql_mem);
RecordSet.next();
String Members=RecordSet.getString("members");
String Memname="";
String MembersName="";
ArrayList Members_proj = Util.TokenizerString(Members,",");
int Membernum = Members_proj.size();

for(int i=0;i<Membernum;i++){
    Memname= Memname+"<a href=\"/hrm/resource/HrmResource.jsp?id="+Members_proj.get(i)+"\">"+Util.toScreen(ResourceComInfo.getResourcename(""+Members_proj.get(i)),user.getLanguage())+"</a>";
    Memname+=" ";
    MembersName+=ResourceComInfo.getResourcename(""+Members_proj.get(i))+",";
}
   if(!MembersName.equals(""))   MembersName=MembersName.substring(0,MembersName.length()-1);

   
String needinputitems = "";
boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","p1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();

RecordSet.executeProc("PRJ_Find_LastModifier",ProjID);
RecordSet.first();
String Modifier = Util.toScreen(RecordSet.getString(1),user.getLanguage());
String ModifyDate = RecordSet.getString(2);

RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/proj/DBError.jsp?type=FindData");
RecordSet.first();
String newStrXml = RecordSet.getString("relationXml");
/*权限－begin*/
String Creater = Util.toScreen(RecordSet.getString("creater"),user.getLanguage());
String CreateDate = RecordSet.getString("createdate");
String manager = RecordSet.getString("manager");
String department = RecordSet.getString("department");
String useridcheck=""+user.getUID();

boolean canview=false;
boolean canedit=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
 if(HrmUserVarify.checkUserRight("ViewProject:View",user,department) || HrmUserVarify.checkUserRight("EditProject:Edit",user,department)) {
	 canview=true;
	 canedit=true;
	 isrole=true;
 }
 if(useridcheck.equals(Creater)){
	 canview=true;
	 canedit=true;
 }
  if(useridcheck.equals(manager)){
	 canview=true;
	 canedit=true;
	 ismanager=true;
 }
AllManagers.getAll(manager);
while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		canview=true;
		canedit=true;
		ismanagers=true;
	}
}
if (from.equals("viewProject")) {
	canedit=true;
}
if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/


String isManagerFromView = Util.null2String(request.getParameter("isManager"));
String bbStyle="" ; // Browser button style.
String inputDisabled=""; //input disabled
if ("false".equals(isManagerFromView)){
    bbStyle="style='display:none'";
    inputDisabled = "readonly";
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript"  type='text/javascript' src="/js/weaver.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTask.js"></SCRIPT>
<script type="text/javascript" src="/js/projTask/temp/prjTask.js"></script>
<script type="text/javascript" src="/js/projTask/temp/jquery.z4x.js"></script>
<script type="text/javascript" src="/js/projTask/temp/ProjectAddTaskI2.js"></script>
<script type="text/javascript" src="/js/projTask/TaskDrag.js"></script>
<script type="text/javascript" src="/js/projTask/TaskUtil.js"></script>
<style type="text/css">
	td{
		background: none;
	}
	#divTaskList .ListStyle table td{
		padding:0 !important;
		background:none !important;
	}
	 body {-moz-user-select: -moz-none;}  
</style>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(610,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+" - "+Util.toScreen(RecordSet.getString("name"),user.getLanguage());
titlename += " <B>" + SystemEnv.getHtmlLabelName(401,user.getLanguage()) + ":</B>"+CreateDate ;
titlename += " <B>" + SystemEnv.getHtmlLabelName(623,user.getLanguage()) + ":</B>";
if(user.getLogintype().equals("1")) 
	titlename += " <A href=/hrm/resource/HrmResource.jsp?id=" + Creater + ">" + Util.toScreen(ResourceComInfo.getResourcename(Creater),user.getLanguage()) + "</a>";
titlename += " <B>" + SystemEnv.getHtmlLabelName(103,user.getLanguage()) + ":</B>"+ModifyDate ;
titlename += " <B>" + SystemEnv.getHtmlLabelName(623,user.getLanguage()) + ":</B>";
if(user.getLogintype().equals("1")) 
	titlename += " <A href=/hrm/resource/HrmResource.jsp?id=" + Modifier + ">" + Util.toScreen(ResourceComInfo.getResourcename(Modifier),user.getLanguage()) + "</a>";

String needfav ="1";
String needhelp ="";
%>
<BODY id="myBody" onbeforeunload="protectProj(event)">
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self}";
    RCMenuHeight += RCMenuHeightStep;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(20521,user.getLanguage())+", /weaver/weaver.file.ExcelOut, ExcelOut} " ;
    RCMenuHeight += RCMenuHeightStep;
//TD4142
//modified by hubo,2006-04-14
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.back(),_self}";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<FORM id=weaver action="/proj/data/ProjectOperation.jsp" method=post enctype="multipart/form-data">
<input <%=inputDisabled%> type="hidden" name="method" value="editTask">
<input <%=inputDisabled%> type="hidden" name="ProjID" value="<%=ProjID%>">
<input type ="hidden" name="isManagerFromView" value="<%=isManagerFromView%>">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">



<TABLE class=viewform>
  <COLGROUP>
  <COL width="49%">

  <TBODY>
  <TR>

	<TD vAlign=top id="TaskDataTD" >
	<table id="scrollarea" name="scrollarea" width="100%" height="100%" style="display:inline;zIndex:-1" >
		<tr>
			<td align="center" valign="center">
				<fieldset style="width:30%">
					<img src="/images/loading2.gif"><%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%></fieldset>
			</td>
		</tr>
	</table>
	</td>
		</tr>
		</TABLE>



	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<input  type=hidden name="hrmids02" id ="hrmids02" value="<%=Members%>">
<span   name="hrmids03span" id ="hrmids03span" style="display:none"><%=MembersName%></span>
</FORM>
<script type="text/javascript">
//选择负责人
function onSelectManager(spanname,inputename){
	tmpids = $("input[name=hrmids02]").val();
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectManagerBrowser.jsp?Members="+tmpids);
	if (datas){
		if(datas.id!=""){
			$(spanname).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>");
			$(inputename).val(datas.id);
		}else {
			$(spanname).html( "");
			$(inputename).val("");
		}
	}
}
//选择前置任务
function onSelectBeforeTask(spanname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectTaskBrowser.jsp",document.getElementsByName("txtTaskName"));
	if (datas){
		if(datas.id!=""){
			$(spanname).html(datas.name);
			$(inputename).val(datas.id);
		}else{
			$(spanname).html("");
			$(inputename).val("");
		}
	}
	beforeTask_check($($.event.fix(getEvent()).target).next("input[name=seleBeforeTask]")[0]);
}
</script>


</BODY>
</HTML>
<script language="javaScript">  
	var ptu = null;
	var iRowIndex = null;
	var RowindexNum = null;

	function init_ptu() {
	   // ptu = new ProjTaskUtil(document.getElementById("task_xml").value); 
	    //初始化input框 的宽度
	    iRowIndex = document.getElementById("task_iRowIndex").value;
	    RowindexNum = document.getElementById("task_RowindexNum").value;
	}
    function addRowForProj(){       
        if (lastSelectedTRObj==null&&<%=isManagerFromView%>==false) {
            alert("<%=SystemEnv.getHtmlLabelName(18866,user.getLanguage())%>")
            return ;
        }
        addRow();
    }
    function deleteRowForProj(){        
        if(!confirm("<%=SystemEnv.getHtmlLabelName(18865,user.getLanguage())%>")) return  ;
        try {
            var taskItems = document.getElementsByName("chkTaskItem");  
            var delList = ptu.getDeleteListForProjEdit(taskItems,'<%=isManagerFromView%>');
         
            for (var i= 0;i<delList.size();i++){
                var delItem = delList.get(i);           
                
				var delRowObj = document.getElementById("tr_"+delItem);
				if (delRowObj==lastSelectedTRObj) {
					lastSelectedTRObj=null ;					
				}
                var delRowIndex = delRowObj.rowIndex;
                var delNextRowIndex= document.getElementById("tr_"+delItem).nextSibling.rowIndex;

                tblTask.deleteRow(delNextRowIndex);
                tblTask.deleteRow(delRowIndex);              
            }
             document.getElementById("chkAllObj").checked = false ;
        } catch(ex){}
    }
   
    function submitData(obj){
            //把所有控件的display属性设为false
           obj.disabled = true;
	 	var xmlDoc=document.createElement("rootTask");
	 	var docDom=generaDomJson();
	 	$.toXml(docDom,xmlDoc);
	    document.getElementById("areaLinkXml").value= "<rootTask>"+ $(xmlDoc).html().replace(/\"\s/g,"\"").replace(/\s\"/g,"\"")+"</rootTask>";

            myBody.onbeforeunload=null;
    		weaver.submit();
    }
        
    //判断SecuLevel 和LabourP input框中是否输入的是数字
    function ItemCount_KeyPress_SandL(){
     if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))))
      {
         window.event.keyCode=0;
      }
    }

    function checknumber_SandL(objectname){	
        valuechar = document.all(objectname).value.split("") ;
        isnumber = false ;
        for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
        if(isnumber) document.all(objectname).value = "" ;
    }
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>

<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdata(){
    var ajax=ajaxinit();
    ajax.open("POST", "EditProjectTaskData.jsp?ProjID=<%=ProjID%>&isManagerFromView=<%=isManagerFromView%>&inputDisabled=<%=inputDisabled%>&Members=<%=Members%>", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send(null);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.getElementById('TaskDataTD').innerHTML = ajax.responseText;
                initPrjTaskObj();
                init_beforTaskStr();
                init_ptu();
                modiAllTxtSize();
            }catch(e){
                return false;
            }
        }
    }
}
showdata();
</script>

<script language='javaScript'>
//初始化前置任务值
function init_beforTaskStr() {
	var taskArr = new Array();
	var txtTaskNames = document.getElementsByName("txtTaskName");
	for (i=1;i<=txtTaskNames.length;i++){
		taskArr[i-1] = txtTaskNames[i-1].value;
	}
	var seleBeforeTasks = document.getElementsByName("seleBeforeTask");
	for (i=1;i<=seleBeforeTasks.length;i++){
		if(seleBeforeTasks[i-1].value!='' && seleBeforeTasks[i-1].value!='0') {
			try {
				if(taskArr[seleBeforeTasks[i-1].value-1]!=undefined)
					document.getElementById('seleBeforeTaskSpan_'+i).innerHTML = taskArr[seleBeforeTasks[i-1].value-1];
			}catch(e){}
		}
	}
}
</script>
