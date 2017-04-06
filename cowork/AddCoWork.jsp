<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.cowork.*" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<jsp:useBean id="CoTypeRight" class="weaver.cowork.CoTypeRight" scope="page"/>
<%@ include file="/cowork/uploader.jsp" %>

<%	
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);          

int typeid=Util.getIntValue(request.getParameter("typeid"),0);

int userid=user.getUID();
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
String docid = Util.null2String(request.getParameter("docid"));
String from =request.getParameter("from");//用来表示从哪个页面进入的，从协作区进入from="cowork"，从其他地方进入from="other"
String message= Util.null2String(request.getParameter("message")); //协作创建失败，返回到协作新建页面
%>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(18034,user.getLanguage())%></title>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>

<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/kindeditor/kindeditor.js"></script>
<script type="text/javascript" src="/kindeditor/kindeditor-Lang.js"></script>

<script type="text/javascript" src="js/cowork.js"></script>

<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker.js?rnd="+Math.random()+"'></script>
<link rel="stylesheet" href="/cowork/css/cowork.css" type="text/css" />
</head>
<body onbeforeunload="checkChange()">
<div id="divTopMenu"></div>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name="frmmain" method="post" action="CoworkOperation.jsp?from=<%=from%>"  enctype="multipart/form-data">
  <input type=hidden name="method" value="add">
  <input type=hidden name="from" value="<%=from%>">
<table id="table1" class=viewform style="width: 100%;"> 
  <COLGROUP> 
	<COL width="20%">
	<COL width="35%">
	<COL width="20%">
	<COL width="15%"> 
	<COL width="10%">
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
      <td class=Field colspan=4> 
        <input class=inputstyle type=text name="name" id="name" onkeydown="if(window.event.keyCode==13) return false;" onChange="checkinput('name','namespan')" style="width:90%" onblur="checkLength('name',50,'<%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')">
        <span id="namespan"><img src="/images/BacoError.gif" align=absmiddle></span>
      </td> 
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
      <td class=Field>
      <select name="typeid" id="typeid" size=1 onchange="onShowneedinput();onShowCoTypeAccessory(this.value)">
    
        <%
        	  String defaultCoType = "";//初始协作区类型
        	  int index = 0;
        
            while(CoTypeComInfo.next()){
                
                String tmptypeid=CoTypeComInfo.getCoTypeid();
                String typename=CoTypeComInfo.getCoTypename();             

                int sharelevel = CoTypeRight.getRightLevelForCowork(""+userid,tmptypeid);
                if(sharelevel==0) continue;
               	index++;	
               	if(index==1) defaultCoType = tmptypeid;//初始协作区类型默认为选项中的第一个
               	if(tmptypeid.equals(""+typeid)) defaultCoType = tmptypeid;//如果设置了默认协作区类型，更新初始协作区类型
                
        %>
          <option value="<%=tmptypeid%>" <%if(tmptypeid.equals(""+typeid)){%> selected <%}%> ><%=typename%></option>
        <%
            }
        %>
       </select>
        <span id="subtypespan"></span>
      <input type=hidden name="creater" value=<%=userid%>>
      </td>
      <td colspan=3 class=Field>
        <input type=radio value="0" name="levelvalue" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="levelvalue"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> 
      </td> 
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
      <td class=field colspan=4>      	
		 <button type="button" class=browser onclick="onShowResourceOnly('txtPrincipal','spanPrincipal')"></button>		 
		 <span id="spanPrincipal"><a href='#' onclick='pointerXY(event);openhrm(<%=userid%>);'><%=Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage())%></a></span>
		 <input type=hidden name="txtPrincipal"  id="txtPrincipal" value="<%=userid%>">
      </td>
    </tr>
    
    
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 

    <tr>
      <td><%=SystemEnv.getHtmlLabelName(17689,user.getLanguage())%></td>
      <td class=Field colspan=4>
	      <jsp:include page="/cowork/CoworkShareManager.jsp">
	      	<jsp:param value="add" name="from"/>
	      </jsp:include>
      </td> 
    </tr>

    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <tr> 
    <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
        <TD class=Field>



			<BUTTON type="button" class=calendar  onclick="onShowDate(begindatespan,begindate)"></BUTTON>
         <SPAN id=begindatespan ><%=currentdate%></SPAN>
		 <input type="hidden" name="begindate" id="begindate" value=<%=currentdate%>> 
        </td>
      <td><%=SystemEnv.getHtmlLabelName(17690,user.getLanguage())%></td>
           <TD colspan=2 class=Field>
           <BUTTON type="button" class=Calendar onclick="onShowTime(begintimespan,beingtime)"></BUTTON> 
              <SPAN id=begintimespan>
              </span>
              <input type="hidden" name="beingtime" id="beingtime">   
      </TD>
    </tr>  
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <tr> 
    <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
        <TD class=Field> 
	     <BUTTON type="button" class=calendar  onclick="onShowDate(enddatespan,enddate)"></BUTTON>
         <SPAN id=enddatespan style="color:#000000;font-weight:normal">
		   <IMG src='/images/BacoError.gif' align=absMiddle>
		 </SPAN>
		 <input type="hidden" name="enddate" id="enddate" value=''> 
        </td>
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
           <TD colspan=2 class=Field>
           <BUTTON type="button" class=Calendar onclick="onShowTime(endtimespan,endtime)"></BUTTON> 
              <SPAN id=endtimespan></span>
              <input type="hidden" name="endtime" id="endtime">   
           </TD>
    </tr>  
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
      <td class=Field colspan=4><button type="button" type="button" class=browser onclick="onShowDoc('relateddoc','relateddocspan')"></button>
      <input type=hidden name="relateddoc" id="relateddoc" value="<%=docid%>"><span id="relateddocspan">
      <a href="#" onclick="openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=docid%>')" ><%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></a>
      </span>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR>
    <tr>
	<%if(isgoveproj==0){%>
      <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
      <td class=Field colspan=4><button type="button" class=browser onclick="onShowCRM('relatedcus','crmspan')"></button>
      <input type=hidden name="relatedcus" id="relatedcus" value="<%=CustomerID%>"><span id="crmspan">
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=CustomerID%>" target="_blank"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage())%></a>
      </span>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <tr>
	<%}%>
      <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
      <td class=Field colspan=4><button type="button" class=browser onclick="onShowRequest('relatedwf','relatedrequestspan')"></button>
      <input type=hidden name="relatedwf" id="relatedwf"><span id="relatedrequestspan"></span>
      </td>
    </tr>
    <%if(isgoveproj==0){%>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
	<tr> 
      <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
      <td class=Field colspan=4>
	      <BUTTON type="button" class="Browser" id="selectMultiProject" onclick="onShowMultiProjectCowork('projectIDs','mutilprojectSpan')"></BUTTON>
	      <SPAN id="mutilprojectSpan">
			<A href="/proj/data/ViewProject.jsp?ProjID=">	  
			</A>
	      </SPAN>
		  <INPUT type="hidden" name="projectIDs" value="" id="projectIDs">
      </td>
    </tr>
	<%}%>
	<%if(isgoveproj==0){%>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
	<tr> 
      <td><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
      <td class=Field colspan=4><button type="button" type="button" class=browser onclick="onShowTask('relatedprj','projectspan')"></button>
      <input type=hidden name="relatedprj" id="relatedprj" value="<%=taskrecordid%>"><span id="projectspan">
      <a href="/proj/process/ViewTask.jsp?taskrecordid=<%=taskrecordid%>" target="_blank"><%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(taskrecordid),user.getLanguage())%></a>
      </span>
      </td>
    </tr>
	<%}%>
	<TR style="height: 1px;"><TD class=Line colspan=5></TD></TR>
    <tr>
        <td valign=top><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>
        <td colspan=4 class=Field>
         <textarea class=InputStyle name="remark" id="remark" style="width:100%" rows=5></textarea>  
        </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <!-- 相关附件 -->
    <tr>
		<td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
		<%
		CoworkDAO dao = new CoworkDAO();
		Map dirMap=dao.getAccessoryDir(defaultCoType);
		String mainId =(String)dirMap.get("mainId");
		String subId = (String)dirMap.get("subId");
		String secId = (String)dirMap.get("secId");
		String maxsize = (String)dirMap.get("maxsize");
		
		if(!mainId.equals("")&&!subId.equals("")&&!secId.equals("")){
		%>
				<td class=field colspan=4 id="divAccessory" name="divAccessory">
				    <div id="uploadDiv" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
		        </td>
		<%}else{%>
				<td class=field colspan=4 id="divAccessory" name="divAccessory"><font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font></td>
		<%}%>
		</tr> 
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR>

</table>

</form>
</body>
</html>
<script>
function checkChange() {
	if(jQuery("#name").val()!=""||jQuery("#remark").val()!=""||(jQuery("#relateddoc").val()!=''&&jQuery("#relateddoc").val()!='0')||jQuery("#relatedcus").val()!=''||jQuery("#relatedwf").val()!=''||jQuery("#relatedprj").val()!=''||jQuery("#projectIDs").val()!=''||document.all("relatedacc").value!='')
      event.returnValue="<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
}
</script>
<script language=javascript src="/js/checkData.js"></script>

<script language=javascript>
jQuery(document).ready(function(){

   KE.show({  
		id : 'remark',
					height : '120px',
					width:'100%',
					resizeMode:1,
					imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
				    allowFileManager : false,
	                newlineTag:'br',
	                items : [
						'source','fullscreen','plainpaste', 'wordpaste',  'justifyleft', 'justifycenter', 'justifyright',
						 'insertorderedlist', 'insertunorderedlist', 
						'title', 'fontname', 'fontsize',  'textcolor', 'bgcolor', 'bold',
						'italic', 'underline', 'link', 'unlink'
					],
				    afterCreate : function(id) {
					KE.event.ctrl(document, 13, function() {
						KE.util.setData(id);
						document.forms['frmmain'].submit();
					});
					KE.event.ctrl(KE.g[id].iframeDoc, 13, function() {
						KE.util.setData(id);
						document.forms['frmmain'].submit();
					});
					KE.util.focus(id);
				}
	
	});
  

  //绑定附件上传
   if(jQuery("#uploadDiv").length>0)
     bindUploaderDiv(jQuery("#uploadDiv"),"relatedacc"); 

  if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
   //左侧下拉框处理
   jQuery(document.body).bind("mouseup",function(){
	   parent.jQuery("html").trigger("mouseup.jsp");	
    });
    jQuery(document.body).bind("click",function(){
		jQuery(parent.document.body).trigger("click");		
    });
   }
   
   //新建协作失败提醒
   if("<%=message%>"=="error") 
      alert("<%=SystemEnv.getHtmlLabelName(18034,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage())%>");
      
}
);
function doSave(obj){
	if(check_formM(document.frmmain,'name,typeid,begindate,enddate')&&checkDateTime()){
		
		jQuery(".shareSecLevel").show();
		
		obj.disabled = true;
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
		
		var oUploader=window[jQuery("#uploadDiv").attr("oUploaderIndex")];
	    try{
	       if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
	         doSaveAfterAccUpload();  //保存协作
	       else 
	     	 oUploader.startUpload();
		}catch(e){
		     doSaveAfterAccUpload(); //保存协作
		 }
	}
}

function doSaveAfterAccUpload(){
    document.frmmain.submit();		
}

//检查协作时间
function checkDateTime(){
   var begindateStr=document.getElementById("begindate").value.split("-");
   var enddateStr=document.getElementById("enddate").value.split("-");
   
   var begindate,enddate;
   
   var beingtimeStr=document.getElementById("beingtime").value.split(":");
   var endtimeStr=document.getElementById("endtime").value.split(":");
   if(beingtimeStr.length==2)
       begindate=new Date(begindateStr[0],begindateStr[1]-1,begindateStr[2],beingtimeStr[0],beingtimeStr[1]);
   else
       begindate=new Date(begindateStr[0],begindateStr[1]-1,begindateStr[2]);
   
   if(endtimeStr.length==2)
       enddate=new Date(enddateStr[0],enddateStr[1]-1,enddateStr[2],endtimeStr[0],endtimeStr[1]);
   else
       enddate=new Date(enddateStr[0],enddateStr[1]-1,enddateStr[2]); 
       
   if(begindate>enddate){
       alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
       return false;
   }else
       return true;    
}
  function check_formM(thiswins,items)
{
	thiswin = thiswins
	items = ","+items + ",";
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	if(tmpname=="coworkers"){
		if(tmpvalue == 0){
			alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
			return false;
		}
	}
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
		 alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}

function onShowCoTypeAccessory(CoType){
   jQuery.post("CoworkAccessory.jsp?CoType="+CoType,{},function(data){
       jQuery("#divAccessory").html(data);
       //绑定附件上传
       if(jQuery("#uploadDiv").length>0)
          bindUploaderDiv(jQuery("#uploadDiv"),"relatedacc");
   });
}
</script>

<script>
function onShowneedinput(){
  if(jQuery("#typeid").val()=="")
     jQuery("#subtypespan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
  else
     jQuery("#subtypespan").html("");   
}

</script>
