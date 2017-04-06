<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.cowork.*" %> 
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CoTypeRight" class="weaver.cowork.CoTypeRight" scope="page"/>
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page" />
<HTML>
<%	
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);  
int id=Util.getIntValue(request.getParameter("id"),0);
String from = Util.null2String(request.getParameter("from"));
int userid=user.getUID();
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);

String levelvalue="";
String typeid="";
String begindate="";
String beingtime="";
String enddate="";
String endtime="";
String relatedprj="";
String relatedcus="";
String relatedwf="";
String relateddoc="";
String remark="";
String remarkhtml="";
String creater="";
String name="";
String relatedacc="";
String mutil_prjsid = "";//td11838
String principal="";

ArrayList relatedprjList = new ArrayList();
ArrayList relatedcusList = new ArrayList();
ArrayList relatedwfList = new ArrayList();
ArrayList relateddocListTemp = new ArrayList();
ArrayList relateddocList = new ArrayList();
ArrayList mutilPrjsList = new ArrayList();//td11838
ArrayList relatedaccList = new ArrayList();
ConnStatement statement=new ConnStatement();
String sql = "select * from cowork_items where id = "+id;
boolean isoracle = (statement.getDBType()).equals("oracle");
boolean ismanager = false;
try{
	statement.setStatementSql(sql);
	statement.executeQuery();
	if(statement.next()){
		name = Util.toScreenToEdit(statement.getString("name"),user.getLanguage());
		typeid = statement.getString("typeid");
		levelvalue = statement.getString("levelvalue");
		creater = statement.getString("creater");
        
		begindate = statement.getString("begindate");
		beingtime = statement.getString("beingtime");
		enddate = statement.getString("enddate");
		endtime = statement.getString("endtime");		
		relatedprj = statement.getString("relatedprj");
		if(relatedprj.equals("0"))relatedprj="";//防止旧的数据为0的情况
		relatedprjList = Util.TokenizerString(relatedprj,",");
		relatedcus = statement.getString("relatedcus");
		if(relatedcus.equals("0"))relatedcus="";
		relatedcusList = Util.TokenizerString(relatedcus,",");
		relatedwf = statement.getString("relatedwf");
		if(relatedwf.equals("0"))relatedwf="";
		relatedwfList = Util.TokenizerString(relatedwf,",");
		relateddoc = statement.getString("relateddoc");
		if(relateddoc.equals("0"))relateddoc="";
		relateddocListTemp = Util.TokenizerString(relateddoc,",");//here relateddoc like 1780|8
		
		mutil_prjsid = statement.getString("mutil_prjs");//td11838
		if(mutil_prjsid.equals("0")) mutil_prjsid = "";
		mutilPrjsList = Util.TokenizerString(mutil_prjsid,",");
		
		relateddoc = "";//for TD2533
		for(int i=0;i<relateddocListTemp.size();i++){
				String temp = relateddocListTemp.get(i).toString();
			if(temp.indexOf("|")!=-1){
				relateddocList.add(temp.substring(0,temp.indexOf("|")));
				relateddoc += ","+temp.substring(0,temp.indexOf("|"));//for TD2533
			}
		}
		if(relateddocListTemp.size()>0)//for TD2533
			relateddoc = relateddoc.substring(1);//for TD2533
		
		remark = statement.getString("remark");
		//String remarkhtml = Util.StringReplace(Util.toHtml(remark.trim()),"\n","<br>");
		remarkhtml = Util.StringReplace(remark,"<br>","\n");
		remarkhtml=remarkhtml.replaceAll("&lt;","&amp;lt;");
		remarkhtml=remarkhtml.replaceAll("&gt;","&amp;gt;");
		relatedacc = Util.null2String(statement.getString("accessory"));
		principal = Util.null2String(statement.getString("principal"));
		relatedaccList=Util.TokenizerString(relatedacc,",");
	}
}finally{
	statement.close();
}

if (typeid.equals(""))
{
typeid="0";
}

boolean canEdit = false;
canEdit=CoworkShareManager.isCanEdit(""+id,""+userid,"all");
if (!canEdit)
{
response.sendRedirect("/notice/noright.jsp") ;
return;
}

%>
<HEAD>
<title><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>:<%=name%></title>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<script type="text/javascript" src="js/cowork.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/kindeditor/kindeditor.js"></script>
<script type="text/javascript" src="/kindeditor/kindeditor-Lang.js"></script>
<link rel="stylesheet" href="/cowork/css/cowork.css" type="text/css" />
<style>
  TABLE.ke-container TR {height:auto !important;}
</style>
</head>
<%@ include file="/cowork/uploader.jsp" %>
<div id="divTopMenu"></div>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name="frmmain" method="post" action="CoworkOperation.jsp"  enctype="multipart/form-data">
<input type=hidden name="method" value="edit">
<input type=hidden name="id" value="<%=id%>">
<input type=hidden name="from" value="<%=from%>">
<table id=table1 class=ViewForm> 
  <COLGROUP> 
	<COL width="20%">
	<COL width="25%">
	<COL width="20%">
	<COL width="25%">
	<COL width="10%">
    <tr>
      <td width="22%"><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
      <td class=field colspan=4>
        <input class=inputstyle type=text name="name" value="<%=name%>" onkeydown="if(window.event.keyCode==13) return false;" onChange="checkinput('name','namespan')" style="width:90%" onblur="checkLength('name',50,'<%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')">
        <span id="namespan"></span>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
      </td><td width="28%" class=field>
        <select name="typeid" size=1 onChange="onShowneedinput();onShowCoTypeAccessory(this.value)">
		<%
            String defaultCoType = "";//初始协作区类型
        	  int index = 0;
        	  
            while(CoTypeComInfo.next()){
                index++;
                String tmptypeid=CoTypeComInfo.getCoTypeid();
                String typename=CoTypeComInfo.getCoTypename();                
                String typemanager=CoTypeComInfo.getCoTypemanagerid();                
                String typemembers=CoTypeComInfo.getCoTypemembers();
								
				int tempsharelevel = CoTypeRight.getRightLevelForCowork(""+userid,tmptypeid);
				if(tempsharelevel==0) continue;
								
               	if(index==1) defaultCoType = tmptypeid;//初始协作区类型默认为选项中的第一个
               	if(tmptypeid.equals(""+typeid)) defaultCoType = tmptypeid;//如果设置了默认协作区类型，更新初始协作区类型
        %>
          <option value="<%=tmptypeid%>" <%if(tmptypeid.equals(""+typeid)){%> selected <%}%> ><%=typename%></option>
        <%
            }
        %>
        </select>
        <span id="subtypespan"></span>

      <input type=hidden name="creater" value=<%=creater%>>
      </td>
      <td colspan=3 class=field>
        <input type=radio value="0" name="levelvalue" <%if(levelvalue.equals("0")){%> checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="levelvalue" <%if(levelvalue.equals("1")){%> checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> 
      </td> 
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR>
    
    <tr>
     <td><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
      <td class=field colspan=4>      	
		 <button type="button" class=browser onclick="jQuery('#isChangeCoworker').val(1);onShowResourceOnly('txtPrincipal','spanPrincipal')"></button>		 
		 <span id="spanPrincipal">
		    <a href='javascript:void(0)' onclick='pointerXY(event);openhrm(<%=principal%>);return false;'><%=Util.toScreen(ResourceComInfo.getResourcename(""+principal),user.getLanguage())%></a>
		 </span>
		 <input type=hidden name="txtPrincipal"  id="txtPrincipal" value="<%=principal%>"/>
      </td>
    </tr>
    
    
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(17689,user.getLanguage())%></td>
      <td class=field colspan=4>
       <div style="background: #FFFFFF;height: 240px;overflow:auto;" >
      	 <jsp:include page="/cowork/CoworkShareManager.jsp">
	   		 <jsp:param value="edit" name="from"></jsp:param>
	      	 <jsp:param value="<%=id%>" name="id"></jsp:param>
	     </jsp:include>	
       </div>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <tr> 
    <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
        <TD class=Field>
          <BUTTON type="button" class=calendar  onclick="gettheDate(begindate,begindatespan)"></BUTTON>
         <SPAN id=begindatespan ><%=begindate%></SPAN>
		 <input type="hidden" name="begindate" id="begindate" value=<%=begindate%>>  
        </td>
      <td width="20%"><%=SystemEnv.getHtmlLabelName(17690,user.getLanguage())%></td>
           <TD colspan=2 class=Field>
           <BUTTON type="button" class=Calendar onClick="onShowTime(begintimespan,beingtime)"></BUTTON>
              <SPAN id=begintimespan><%=beingtime%>
              </span>
              <input type="hidden" name="beingtime" id="beingtime" <%if(!beingtime.trim().equals("")){%>value="<%=beingtime%>"<%}%>>   
      </TD>
    </tr>  
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <tr> 
    <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
        <TD class=Field>
			<BUTTON type="button" class=calendar  onclick="gettheDate(enddate,enddatespan)"></BUTTON>
         <SPAN id=enddatespan ><%=enddate%></SPAN>
		 <input type="hidden" name="enddate" id="enddate" value='<%=enddate%>'> 
        </td>
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
           <TD colspan=2 class=Field>
           <BUTTON type="button" class=Calendar onClick="onShowTime(endtimespan,endtime)"></BUTTON>
              <SPAN id=endtimespan><%=endtime%>
              </span>
              <input type="hidden" name="endtime" id="endtime" <%if(!endtime.trim().equals("")){%>value="<%=endtime%>"<%}%>>   
           </TD>
    </tr>  
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
      <td class=Field colspan=4><button type="button" class=browser onClick="onShowDoc('relateddoc','relateddocspan')"></button>
      <input type=hidden name="relateddoc" id="relateddoc" value="<%=relateddoc%>"><span id="relateddocspan">
      <%for(int i=0;i<relateddocList.size();i++){%>
      <a href="/docs/docs/DocDsp.jsp?id=<%=relateddocList.get(i).toString()%>" target="_blank"><%=Util.toScreen(DocComInfo.getDocname(relateddocList.get(i).toString()),user.getLanguage())%></a>
      <%}%>
      </span>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR>
    <tr>
	<%if(isgoveproj==0){%>
      <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
      <td class=field colspan=4><button type="button" class=browser onClick="onShowCRM('relatedcus','crmspan')"></button>
      <input type=hidden id="relatedcus" name="relatedcus" value="<%=relatedcus%>"><span id="crmspan">
      <%for(int i=0;i<relatedcusList.size();i++){%>
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList.get(i).toString()%>" target="_blank"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString()),user.getLanguage())%></a>
      <%}%>
      </span>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <tr>
	<%}%>
      <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
      <td class=field colspan=4><button type="button" class=browser onClick="onShowRequest('relatedwf','relatedrequestspan')"></button>
      <input type=hidden id="relatedwf" name="relatedwf" value="<%=relatedwf%>"><span id="relatedrequestspan">
      <%for(int i=0;i<relatedwfList.size();i++){%>
      <a href="/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList.get(i).toString()%>" target="_blank"><%=Util.toScreen(RequestComInfo.getRequestname(relatedwfList.get(i).toString()),user.getLanguage())%></a>
      <%}%>
      </span>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
    <%if(isgoveproj==0){%>
		<tr> 
      <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
      <td class=field colspan=4>
       <BUTTON type="button" class="Browser" id="selectMultiProject" onclick="onShowMultiProjectCowork('projectIDs','mutilprojectSpan')"></BUTTON>
	    <SPAN id="mutilprojectSpan">
	    <%for(int i=0;i<mutilPrjsList.size();i++){%>
         <a href="javascript:openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=mutilPrjsList.get(i).toString()%>')"><%=projectInfoComInfo.getProjectInfoname(mutilPrjsList.get(i).toString())%></a>&nbsp;
        <%}%>
       </SPAN>
	   <INPUT type="hidden" id="projectIDs" name="projectIDs" value="<%=mutil_prjsid%>">
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
	<%}%>
	<%if(isgoveproj==0){%>
		<tr> 
      <td><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
      <td class=field colspan=4><button type="button" class=browser onClick="onShowTask('relatedprj','projectspan')"></button>
      <input type=hidden id="relatedprj" name="relatedprj" value="<%=relatedprj%>">
      <span id="projectspan">
      <%for(int i=0;i<relatedprjList.size();i++){%>
      <a href="/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList.get(i).toString()%>" target="_blank"><%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString()),user.getLanguage())%></a>
      <%}%>
       </span>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR> 
	<%}%>
    <tr>
        <td valign=top><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>
        <td colspan=4 class=field>
        <textarea class=InputStyle name="remark" style="width:100%" rows=5><%=remarkhtml%></textarea>
        </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR>
    <!-- 相关附件 -->
   <tr>
       <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
       <td colspan=4 class=field>
           <input type="hidden" id="relatedacc" name="relatedacc" value="<%=relatedacc%>">
	       <input type="hidden" id="delrelatedacc" name="delrelatedacc" value="">	
      
    <%
    if(!relatedacc.equals("")) {
            for(int i=0;i<relatedaccList.size();i++){
            String accid=(String)relatedaccList.get(i);	
            sql="select id,docsubject,accessorycount from docdetail where id="+accid+"";
            rs.executeSql(sql);
            int linknum=-1;
            while(rs.next()){
              linknum++;
              String showid = Util.null2String(rs.getString(1)) ;
              String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
              int accessoryCount=rs.getInt(3);

              DocImageManager.resetParameter();
              DocImageManager.setDocid(Integer.parseInt(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }

              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              %>
              <%=imgSrc%>
              <%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx"))){%>
                <a  style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp

              <%}%>
                <BUTTON type="button" class=btn accessKey=1  onclick='onDeleteAcc("span_id_<%=linknum%>","<%=showid%>")'><U><%=linknum%></U>-删除
				                  <span id="span_id_<%=linknum%>" name="span_id_<%=linknum%>" style="display: none">
				                    <B><FONT COLOR="#FF0033">√</FONT></B>
				                  <span>
                </BUTTON>
                <br>
              <%}%>
          <%}}%> 
          <!--上传附件 -->
   <%
			CoworkDAO dao = new CoworkDAO();
			Map dirMap=dao.getAccessoryDir(defaultCoType);
			String mainId =(String)dirMap.get("mainId");
			String subId = (String)dirMap.get("subId");
			String secId = (String)dirMap.get("secId");
			String maxsize = (String)dirMap.get("maxsize");
			if(!mainId.equals("")&&!subId.equals("")&&!secId.equals("")){
			%>
				<div id="uploadDiv" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
			<%}else{%>
				<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
			<%}%>
		 </td>
    </tr>	
    <TR style="height: 1px;"><TD class=Line colspan=5></TD></TR>
</table>

</form> 

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
						'source','fullscreen','plainpaste', 'wordpaste',  'justifyleft', 'justifycenter','justifyright', 
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
      bindUploaderDiv(jQuery("#uploadDiv"),"newrelatedacc"); 
   
  //左侧下拉框处理
  if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
    }
});

function goBack(){
     window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&id=<%=id%>"
   }
//附件删除
function onDeleteAcc(delspan,delid){
	    var delrelatedacc=jQuery("#delrelatedacc").val();
        var relatedacc=jQuery("#relatedacc").val();
	    relatedacc=","+relatedacc;
	    delrelatedacc=","+delrelatedacc;
	    if(jQuery("#"+delspan).is(":hidden")){
			delrelatedacc=delrelatedacc+delid+",";
			var index=relatedacc.indexOf(","+delid+",");
			relatedacc=relatedacc.substr(0,index+1)+relatedacc.substr(index+delid.length+2);
			jQuery("#"+delspan).show();    
		}else{
			var index=delrelatedacc.indexOf(","+delid+",");
			delrelatedacc=delrelatedacc.substr(0,index+1)+delrelatedacc.substr(index+delid.length+2);
			         
			relatedacc=relatedacc+delid+",";
			         
			jQuery("#"+delspan).hide(); 
		}
		jQuery("#relatedacc").val(relatedacc.substr(1,relatedacc.length));
		jQuery("#delrelatedacc").val(delrelatedacc.substr(1,delrelatedacc.length));
} 

function doSave(obj){
	if(check_formM(document.frmmain,'name,coworkers,begindate,enddate')&&checkDateTime()){
		obj.disabled = true;
		
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

function changeView(viewFlag,accepterspan){
	document.all(viewFlag).style.display='none';
	document.all(accepterspan).style.display='';
}
 function onChangeSharetype(delspan,delid,ismand){
	fieldid=delid.substr(0,delid.indexOf("_"));
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
	fieldidspans=fieldid+"spans";
	fieldid=fieldid+"_1";
    if(document.all(delspan).style.visibility=='visible'){
      document.all(delspan).style.visibility='hidden';
      document.all(delid).value='0';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)+1;
    }else{
      document.all(delspan).style.visibility='visible';
      document.all(delid).value='1';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)-1;
    }
  }
function opendoc(showid,versionid,docImagefileid)
{
openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&from=accessory&wpflag=workplan");
}
function opendoc1(showid)
{
openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&wpflag=workplan");
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

function onShowneedinput(){
   if(jQuery("#typeid").val()=="")
      jQuery("#subtypespan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
   else
      jQuery("#subtypespan").html("");    
}

</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>