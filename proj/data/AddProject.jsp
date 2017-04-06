<%@ page language="java" contentType="text/html; charset=GBK" %>
 <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjCodeParaBean" class="weaver.proj.form.ProjCodeParaBean" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<%
//========================== 得到任务列表相关

boolean isOnly = Util.null2String(request.getParameter("isOnly")).equalsIgnoreCase("y") ? true : false;
String  templetName = SystemEnv.getHtmlLabelName(17907,user.getLanguage());

int templetId = Util.getIntValue(request.getParameter("templetId"));
int projTypeId = Util.getIntValue(request.getParameter("projTypeId"));   

    String  templetDesc = ""; 
    String  workTypeId = "";
    String  proMember = "";
    String  isMemberSee = "";
    String  proCrm = "";
    String  isCrmSee = "";
    String  parentProId = "";
    String  commentDoc = "";
    String  confirmDoc = "";
    String  adviceDoc = "";
    String  Manager = "";
    String  relationXml="";
    String  strSql = "select * from Prj_Template where id="+templetId;      
    RecordSet.executeSql(strSql);
    if (RecordSet.next()){
        templetName = Util.null2String(RecordSet.getString("templetName"));
        templetDesc = Util.null2String(RecordSet.getString("templetDesc"));
        
        if (projTypeId==-1){
            projTypeId = Util.getIntValue(RecordSet.getString("proTypeId"));
        }
        workTypeId = Util.null2String(RecordSet.getString("workTypeId"));
        proMember = Util.null2String(RecordSet.getString("proMember"));
        isMemberSee = Util.null2String(RecordSet.getString("isMemberSee"));
        proCrm = Util.null2String(RecordSet.getString("proCrm"));
        isCrmSee = Util.null2String(RecordSet.getString("isCrmSee"));
        parentProId = Util.null2String(RecordSet.getString("parentProId"));
        commentDoc = Util.null2String(RecordSet.getString("commentDoc"));
        confirmDoc = Util.null2String(RecordSet.getString("confirmDoc"));
        adviceDoc = Util.null2String(RecordSet.getString("adviceDoc"));
        Manager = Util.null2String(RecordSet.getString("Manager"));
        relationXml = Util.null2String(RecordSet.getString("relationXml"));
    }
//==========================
//==========================
String projTypeName = ProjectTypeComInfo.getProjectTypename(String.valueOf(projTypeId));
String projTypeCode = ProjectTypeComInfo.getProjectTypecode(String.valueOf(projTypeId));
String workTypeName = WorkTypeComInfo.getWorkTypename(workTypeId);
String proMemberName = ProjTempletUtil.getMemberNames(proMember);
String proCrmName = ProjTempletUtil.getCrmNames(proCrm);
String parentProName = ProjectInfoComInfo.getProjectInfoname(parentProId);
String commentDocName = DocComInfo.getDocname(commentDoc);
String confirmDocName = DocComInfo.getDocname(confirmDoc);
String adviceDocName = DocComInfo.getDocname(adviceDoc);
//==========================
boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","p1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();



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
<SCRIPT language="javascript"  type='text/vbScript' src="/js/projTask/ProjTask.vbs"></SCRIPT>
<script type="text/javascript">
function impProjBase(){
	with(document.weaver){
     
		$("PrjTypeSpan").html("<%=projTypeName%>");
		$("input[name=PrjType]").val('<%=projTypeId%>');
   
        if ("<%=workTypeId%>">"0"){        
        	$("#WorkTypeSpan").html('<%=workTypeName%>');
    		$("input[name=WorkType]").val('<%=workTypeId%>');
        }
        if ("<%=proMember%>"!=""){
    		hrmids02Span.innerHTML = '<%=proMemberName%>';
    		hrmids02.value = '<%=proMember%>';		
        }
        
         if ("<%=proCrm%>"!=""){
            PrjDescspan.innerHTML = '<a href=""><%=proCrmName%></a>';
            PrjDesc.value = '<%=proCrm%>';
        }       
		ParentIDSpan.innerHTML = '<a href="/proj/data/ViewProject.jsp?ProjID=<%=parentProId%>"><%=parentProName%></a>';
		ParentID.value = '<%=parentProId%>';
		EnvDocSpan.innerHTML = '<a href="/docs/docs/DocDsp.jsp?id=<%=commentDoc%>"><%=commentDocName%></a>';
		EnvDoc.value = '<%=commentDoc%>';
		ConDocSpan.innerHTML = '<a href="/docs/docs/DocDsp.jsp?id=<%=confirmDoc%>"><%=confirmDocName%></a>';
		ConDoc.value = '<%=confirmDoc%>';
		ProDocSpan.innerHTML = '<a href="/docs/docs/DocDsp.jsp?id=<%=adviceDoc%>"><%=adviceDocName%></a>';
		ProDoc.value = '<%=adviceDoc%>';
		<%if(isMemberSee.equals("1")){%>
		MemberOnly.checked = true;
		<%}else{%>
		MemberOnly.checked = false;
		<%}%>
		<%if(isCrmSee.equals("1")){%>
		ManagerView.checked = true;
		<%}else{%>
		ManagerView.checked = false;
		<%}%>
	}
}
</script>
<style>

	.spanSwitch{cursor:pointer;font-weight:bold}
	#tblTask table td{padding:0;}
</style>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(101,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY id="myBody" onbeforeunload="protectProj(event)">
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=weaver action="/proj/data/ProjectOperation.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="method" value="add">


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



<TABLE class=viewForm >
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>

	<TD vAlign=top>
<!--***********************************************************-->
<!--ProjectBaseInfo Begin-->
	  <TABLE class=viewForm id="tblProjectBaseInfo">
      <thead>  
        <TR class=title>
            <TH colspan="2"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
		</thead>
		<tbody>
        <TR>
          <TD width="30%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD width="70%" class=Field><INPUT class=inputstyle maxLength=50 size=50 name="PrjName" onblur="checkLength()" onchange='checkinput("PrjName","PrjNameimage")'><SPAN id=PrjNameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN><br><span><font color="red"><%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>50(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)</font></span></TD>
        </TR>
	    <TR style="height:1px;"><TD class=line colSpan=2></TD></TR>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT id=PrjType class="wuiBrowser" type="hidden" name=PrjType value="<%=projTypeId%>" 
              	_url="/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp?sqlwhere=Where wfid<>0" _param="" 
              	_required="yes" _displayText="<%=ProjectTypeComInfo.getProjectTypename(""+projTypeId) %>"
              >     </TD>
        </TR>
		 <TR style="height:1px;"><TD class=line colSpan=2></TD></TR>
		<!--ProjectTempletBrowser Begin-->
        <tr>
			<td><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></TD>
         <td class=Field>
				<%if(isOnly){%> 
				<span id="prjTempletSpan"><%=templetName%> (<span style="color:red"><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())%></span>)</span>
                <input id="prjTempletID" type="hidden" name="prjTemplet" value="<%=templetId%>">     
				<%}else{%>
				<button type="button" class="Browser" onclick="onShowPrjTemplet()"></BUTTON> 
				<span id="prjTempletSpan"><%=templetName%></span>
                <input id="prjTempletID" type="hidden" name="prjTemplet" value="<%=templetId%>">     
				<%}%>
				
			</td>
		</tr>
      <tr style="height:1px;"><td class=line colSpan=2></td></tr>
		
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TD>
          <TD class=Field>
  
          <INPUT id=WorkType type=hidden name=WorkType class="wuiBrowser"
          			_required="yes"
          		 _url="/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp">    
         </TD>
        </TR>
		<TR style="height:1px;"><TD class=line colSpan=2></TD></TR>
        <INPUT class=inputstyle maxLength=3 size=3 name="SecuLevel" value=10 type=hidden />
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></TD>
          <TD class=Field></TD>
        </TR>
		<TR  style="height:1px;"><TD class=line colSpan=2></TD></TR>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
          <TD class=Field>
			<input type=hidden name="hrmids02" class="wuiBrowser" id ="hrmids02" value=""  _required="yes"
				_param="resourceids" _displayTemplate="<a href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</a>&nbsp"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp">
		<!--  
			<span id="hrmids02span"><IMG src='/images/BacoError.gif' align=absMiddle></span> 
            <span id="hrmids03span" style="display:none"></span> 
            -->
		  </TD>
        
        </TR>
		 <TR style="height:1px;"><TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(624,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="MemberOnly" value=1 checked ></TD>
        </TR>
        <TR style="height:1px;"><TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
          <TD class=Field>
			<textarea name="PrjDesc" style="display:none" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
				_displayTemplate="<a href=/CRM/data/ViewCustomer.jsp?CustomerID=${id} >#b{name}</a>&nbsp"
			></textarea>
		  </TD>
        </TR>
        <TR style="height:1px;"><TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15263,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="ManagerView" value=1 checked ></TD>
        </TR>
        <TR style="height:1px;"><TD class=line colSpan=2></TD></TR>
        <%
		String mainId = "";
		String subId = "";
		String secId = "";
		String maxsize = "0";
		RecordSet.executeSql("select * from ProjectAccessory");
	    if(RecordSet.next()){
		     mainId = Util.null2String(RecordSet.getString(2));
		     subId = Util.null2String(RecordSet.getString(3));
		     secId = Util.null2String(RecordSet.getString(4));
		     RecordSet.executeSql("select maxUploadFileSize from DocSecCategory where id="+secId);
		     RecordSet.next();
		     maxsize = Util.null2String(RecordSet.getString(1));
	    }
		if(!mainId.equals("")&&!subId.equals("")&&!secId.equals("")){
		%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></TD>
          <TD class=Field>
            <input class=inputstyle type=file name="accessory1" onchange='accesoryChanage(this)' style="width:100%">
		    <span id="shfj_span"></span>
		    (<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=maxsize%>M)
		    <button type="button" class=AddDoc name="addacc" onclick="addannexRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
		    <input type=hidden name=accessory_num value="1">
            <input type=hidden id="mainId" name="mainId" value="<%=mainId%>">
            <input type=hidden id="subId" name="subId" value="<%=subId%>">
            <input type=hidden id="secId" name="secId" value="<%=secId%>">
            <input type=hidden id="maxsize" name="maxsize" value="<%=maxsize%>">
          </TD>
        <%}else{%>
          <TD><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></TD>
		  <td class=field id="divAccessory" name="divAccessory"><font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font></td>
        <%}%>
        </TR>
		<!--TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><TEXTAREA class=inputstyle NAME=PrjInfo ROWS=9 STYLE="width:100%"></TEXTAREA></TD>
        </TR-->  
		</tbody>
	  </TABLE>
<!--ProjectBaseInfo End-->
<!--***********************************************************-->




<!--***********************************************************-->
<!--ProjectTypeFreeField Begin--> 
<TABLE class=ViewForm id="tblProjectTypeField">
<thead>
<tr class="title"><th colspan="2"><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17088,user.getLanguage())%></th></tr>
<tr class="spacing" style="height:1px;"><td class="line1" colSpan="2"></td></tr>
</thead>
<tbody>
<%
CustomFieldManager cfm = new CustomFieldManager("ProjCustomField",projTypeId);
cfm.getCustomFields();
String chkFields="";
cfm.getCustomData(templetId);
while(cfm.next()){
	String fieldvalue = "";
	if(cfm.getHtmlType().equals("2")){
    	fieldvalue = Util.toHtmltextarea(cfm.getData("field"+cfm.getId()));
    }else{
    	fieldvalue = Util.toHtml(cfm.getData("field"+cfm.getId()));
    }
%>
<tr>
	<td width="30%" <%if(cfm.getHtmlType().equals("2")){%> valign=top <%}%>> <%=cfm.getLable()%> </td>
	<td width="70%" class="field">
	<%
                                            if(cfm.getHtmlType().equals("1")){
                                                if(cfm.getType()==1){
                                                    if(cfm.isMand()){
														chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>"  maxlength="100" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>100(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)" onKeyPress="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                    }else{
                                          %>
                                            <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" maxlength="100" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>100(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)" value="" onKeyPress="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
                                            <span id="customfield<%=cfm.getId()%>span"></span>
                                          <%
                                                    }
                                                }else if(cfm.getType()==2){
                                                    if(cfm.isMand()){
													chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input  datatype="int" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>"                                                 size='10' maxlength="9"  onblur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span');checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>10" onKeyPress="ItemCount_KeyPress(this)">
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                    }else{
                                          %>
                                          <input  datatype="int" type=text  value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size='10' maxlength="9"  onblur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span');checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>10"  onKeyPress="ItemCount_KeyPress(this)">
                                          <span id="customfield<%=cfm.getId()%>span"></span>
                                          <%
                                                    }
                                                }else if(cfm.getType()==3){
                                                    if(cfm.isMand()){
													chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size='10' maxlength="10" onblur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span');checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>10" onKeyPress="ItemNum_KeyPress(this)">
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                    }else{
                                          %>
                                            <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size='10' maxlength="10" onblur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span');checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>10"  onKeyPress="ItemNum_KeyPress(this)" >
                                            <span id="customfield<%=cfm.getId()%>span"></span>
                                          <%
                                                    }
                                                }
                                            }else if(cfm.getHtmlType().equals("2")){
                                                if(cfm.isMand()){
												chkFields+="customfield"+cfm.getId()+",";

                                          %>
                                            <textarea class=Inputstyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')"
                                                rows="4" cols="40" style="width:80%" class=Inputstyle><%=fieldvalue%></textarea>
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                }else{
                                          %>
                                            <textarea class=Inputstyle name="customfield<%=cfm.getId()%>" rows="4" cols="40" style="width:80%"><%=fieldvalue%></textarea>
                                          <%
                                                }
                                            }else if(cfm.getHtmlType().equals("3")){

                                                String fieldtype = String.valueOf(cfm.getType());
                                                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                                                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                                                String showname = "";                                   // 新建时候默认值显示的名称
                                                String showid = "";                                     // 新建时候默认值

                                                String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
                                                String newdocid = Util.null2String(request.getParameter("docid"));

                                                if( fieldtype.equals("37") && !newdocid.equals("")) {
                                                    if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                                                    fieldvalue += newdocid ;
                                                }

                                                if(fieldtype.equals("2") ||fieldtype.equals("19")){
                                                    showname=fieldvalue; // 日期时间
                                                }else if(!fieldvalue.equals("")) {
                                                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                                                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                                                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                                                    String sql = "";

                                                    HashMap temRes = new HashMap();

                                                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")) {    // 多人力资源,多客户,多会议，多文档
                                                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                                                    }
                                                    else {
                                                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                                                    }

                                                    RecordSet.executeSql(sql);
                                                    while(RecordSet.next()){
                                                        showid = Util.null2String(RecordSet.getString(1)) ;
                                                        String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                                                        if(!linkurl.equals(""))
                                                            //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                                                            temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                                                        else{
                                                            //showname += tempshowname ;
                                                            temRes.put(String.valueOf(showid),tempshowname);
                                                        }
                                                    }
                                                    StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                                                    String temstkvalue = "";
                                                    while(temstk.hasMoreTokens()){
                                                        temstkvalue = temstk.nextToken();

                                                        if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                                                            showname += temRes.get(temstkvalue);
                                                        }
                                                    }

                                                }



                                           %>
                                            <button type="button" class=Browser onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
                                            <input type=hidden name="customfield<%=cfm.getId()%>" value="<%=fieldvalue%>">
                                            <span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
                                                <%if(cfm.isMand() && fieldvalue.equals("")) {
											   chkFields+="customfield"+cfm.getId()+",";%><img src="/images/BacoError.gif" align=absmiddle><%}%>
                                            </span>
                                           <%
                                            }else if(cfm.getHtmlType().equals("4")){
                                           %>
                                            <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
                                           <%
                                            }else if(cfm.getHtmlType().equals("5")){
                                                cfm.getSelectItem(cfm.getId());
                                           %>
                                                                                    <select name="customfield<%=cfm.getId()%>" viewtype="<%if(cfm.isMand()){out.print("1");}else{out.print("0");}%>" class="InputStyle" onChange="checkinput2('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span',this.getAttribute('viewtype'))">
											<option value=""></option>
                                           <%
                                                while(cfm.nextSelect()){
                                           %>
                                                <option value="<%=cfm.getSelectValue()%>" <%=cfm.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm.getSelectName()%></option>
                                           <%
                                                }
                                           %>
                                           </select>
												<span id="customfield<%=cfm.getId()%>span">
											<%
												if(cfm.isMand()) {
													chkFields+="customfield"+cfm.getId()+",";
											%>
													<img src="/images/BacoError.gif" align=absmiddle>
											<%
												}
											%>
												</span>
                                           <%
                                            }
                                           %>
	</td>
</tr>
<tr style="height:1px;"><td class="Line" colSpan="2"></td></tr>
<%}%>
</tbody>
</table>

<!--ProjectTypeFreeField End-->
<!--***********************************************************-->

	</TD>

	<TD></TD>
    
	<TD vAlign=top>
<!--***********************************************************-->
<!--PrjectManageInfo Begin-->
	  <TABLE class=viewForm id="tblProjectManageInfo">
        <thead>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(633,user.getLanguage())%></TH>
				<th style="text-align:right">
					<span class="spanSwitch" onclick="doSwitch('tblProjectBaseInfo,tblProjectManageInfo')"><img src='/images/up.jpg'></span>
				</th>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
			 </thead>
    <!--    <TR>
          <TD>图片</TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="Photo" value=0></TD>
        </TR>
      -->  
		<tbody>
        <TR>
          <TD width="30%"><%=SystemEnv.getHtmlLabelName(636,user.getLanguage())%></TD>
          <TD width="70%" class=Field>
  
        <INPUT class="wuiBrowser" type=hidden name="ParentID" value="0" _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp">
        </TD>
        </TR>
        <tr  style="height:1px;">
        <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(637,user.getLanguage())%></TD>
          <TD class=Field>
        
        <INPUT class="wuiBrowser" type=hidden name="EnvDoc" value=0 _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"></TD>
        
        </TR>
        <tr  style="height:1px;"><TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(638,user.getLanguage())%></TD>
          <TD class=Field>
        
        <INPUT class="wuiBrowser" type=hidden name="ConDoc" value=0 _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"></TD>
        </TR>
        <tr style="height:1px;">
        <TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(639,user.getLanguage())%></TD>
          <TD class=Field>
        <INPUT class="wuiBrowser" type=hidden name="ProDoc" value=0 _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"></TD>
        </TR><tr style="height:1px;"><TD class=line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class="wuiBrowser" type=hidden name="PrjManager" value="<%=user.getUID()%>"  _required="yes"
              	_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
              	_displayText="<%=user.getUsername()%>"
              	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"></TD>
        </TR><tr style="height:1px;"><TD class=line1 colSpan=2></TD></TR>
        <!--TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field><button type="button" class=Browser id=SelectDeparment onClick="onShowPrjDept()"></button> 
              <span class=inputstyle id=PrjDeptspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span> 
              <input id=PrjDept type=hidden name="PrjDept" value="<%=user.getUserDepartment()%>"></TD>
        </TR -->
        <!--TR>
          <TD>相关合同</TD>
          <TD class=Field>
          	<button type="button" class=Browser onclick="onShowMCon('muticontractspan','muticontract')"></button>
			<input type=hidden name="muticontract" value="">
			<span id="muticontractspan"></span> 
		  </TD>
        </TR -->
		  </tbody>
	  </TABLE>
<!--ProjectManageInfo End-->
<!--***********************************************************-->
<%
RecordSet.executeSql("select * from Prj_Template where id="+templetId);   
RecordSet.first();
 %>
<!--***********************************************************-->
<!--ProjectFreeField Begin-->
<%if(hasFF){%>
	  <TABLE class=viewForm id="tblProjectField">
        <thead>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
				<th style="text-align:right"><span class="spanSwitch" onclick="doSwitch('tblProjectTypeField,tblProjectField')"><img src='/images/up.jpg'></th>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
		</thead>
		<tbody>
<%
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD width="30%"><%=Util.toScreen(RecordSetFF.getString(i*2),user.getLanguage())%></TD>
          <TD width="70%" class=Field><button type="button" class=Calendar onclick="getProjdate(<%=i%>)"></BUTTON> 
              <SPAN id=datespan<%=i%> ><%=RecordSet.getString("datefield"+i)%></SPAN> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value = "<%=RecordSet.getString("datefield"+i) %>"></TD>
        </TR><tr style="height:1px;"><TD class=line colSpan=2></TD></TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=30 size=30 name="nff0<%=i%>" value = "<%=RecordSet.getString("numberfield"+i) %>"></TD>
        </TR><tr style="height:1px;"><TD class=line colSpan=2></TD></TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=100 size=30 name="tff0<%=i%>"  value = "<%=RecordSet.getString("Textfield"+i) %>"></TD>
        </TR><tr style="height:1px;"><TD class=line colSpan=2></TD></TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field>
          <%if(RecordSet.getString("tinyintfield"+i).equals("1")){ %>
          <INPUT type=checkbox  name="bff0<%=i%>" checked value = "1">
          <%}else{%>
          <INPUT type=checkbox  name="bff0<%=i%>" value = "0">
          <%} %> 
          </TD>
        </TR><tr style="height:1px;"><TD class=line1 colSpan=2></TD></TR>
		<%}
	}
%>
        </TBODY>
	  </TABLE>
<%}%>
<!--ProjectFreeField End-->
<!--***********************************************************-->
	</TD>
  </TR>
  </TBODY>
</TABLE>

    <br> 
    <div id="TaskDataDIV">
    <table id="scrollarea" name="scrollarea" width="100%" style="display:inline;zIndex:-1" >
		<tr>
			<td align="center" valign="center">
				<fieldset style="width:30%">
					<img src="/images/loading2.gif"><%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%></fieldset>
			</td>
		</tr>
	</table>
    </div>

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

<div id="temp_seleBeforeTask_DIV" style="display:none"><select name='temp_seleBeforeTask' class='inputStyle'><option value='0'></option></select></div>
<script language='javaScript'>
/**************
 * 改进列表任务加载性能  for td:9891 by cyril on 2009-01-12
 */
//初始化所有前置任务
//document.all.testTime.innerHTML += '<br>beforTaskStr start:'+new Date();
var temp_seleBeforeTask = document.getElementById("temp_seleBeforeTask");
<%
String beforTaskStr = ProjTempletUtil.getBeforeTaskStr();                               
String outStr = "var seleBefTaskObj=temp_seleBeforeTask;"+beforTaskStr+"";
out.println(outStr);
%>
var seleBeforeTask_TD = document.getElementsByName('seleBeforeTask_TD');
var temp_seleBeforeTask_DIV = document.getElementById('temp_seleBeforeTask_DIV').innerHTML;
for(i=0; i<seleBeforeTask_TD.length; i++) {
	temp_seleBeforeTask.name = 'seleBeforeTask';
	temp_seleBeforeTask.id = 'seleBeforeTask_'+(i+1);
	//temp_seleBeforeTask.id = 'seleBeforeTask_'+(i+1);
	seleBeforeTask_TD[i].innerHTML = replaceStr(i);
}
//alert(document.getElementsByName('temp_seleBeforeTask')[1].id);
//document.all.testTime.innerHTML += '<br>beforTaskStr end:'+new Date();

//拼成SELECT
function replaceStr(id) {
	id++;
	var str = temp_seleBeforeTask_DIV;
	var len = str.length;
	var spchar = 'temp_seleBeforeTask';
	var sp = str.indexOf(spchar);
	str = str.substring(0, sp)+str.substring(sp+5, len);
	str = str.substring(0, 7)+' id=seleBeforeTask_'+id+' onchange=onBeforeTaskChange(this,'+id+') '+str.substring(7, len);
	return str;
}

//处理前置任务
//document.all.testTime.innerHTML += '<br>set befTaskObj start:'+new Date();
var befTaskObj = document.getElementsByName('seleBeforeTask');
<%
ArrayList befTaskSeleList =  ProjTempletUtil.getBefTaskSeleList();
for (int k=0;k<befTaskSeleList.size();k++){
    String[] paras = (String[])befTaskSeleList.get(k);
    String rowIndex = paras[0];
    String befTaskValue = paras[1];
    String outStr2 = "befTaskObj["+k+"].value='"+befTaskValue+"'";
    out.println(outStr2);
}
%>
//document.all.testTime.innerHTML += '<br>set befTaskObj end:'+new Date();
//document.all.testTime.innerHTML += '<br>members start:'+new Date();
//初始化任务负责人多选框
var objManagers = document.getElementsByName("txtManager");
for (i=0;i<objManagers.length;i++){
	var objManager=objManagers[i];
<%
    String[]  members = Util.TokenizerString2(proMember,",");
    for (int h=0;h<members.length;h++) {
        String member = members[h];
         String outStr3 = "objManager.options.add(new Option('"+ResourceComInfo.getLastname(member)+"','"+member+"'))";
         out.println(outStr3);
    }
%>
}
//document.all.testTime.innerHTML += '<br>members end:'+new Date();
//document.all.testTime.innerHTML += '<br>taskManagerList start:'+new Date();
//处理负责人数据
var taskObj = document.getElementsByName("txtManager");
<%	
    ArrayList taskManagerList =  ProjTempletUtil.getTaskManagerList();
  
    for (int j=0;j<taskManagerList.size();j++){
        String[] paras = (String[])taskManagerList.get(j);
        String rowIndex = paras[0];
        String taskManagerValue = paras[1];
        String outStr4 = "taskObj["+j+"].value='"+taskManagerValue+"'";
         out.println(outStr4);
    }
%>
//document.all.testTime.innerHTML += '<br>taskManagerList end:'+new Date();
</script>

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

//判断SecuLevel 和LabourP input框中是否输入的是数字
//added by hubo, 2005/08/31
//edit by zfh,20111212
function onShowPrjTemplet(){
	var currentProjType = document.getElementById("PrjType");
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Templet/TempletBrowser.jsp?projTypeID="+$(currentProjType).val(),"dialogArguments=342342");
	if (datas){
		if(datas.id!=""){
			templetID = datas.id;
			templetName = datas.name;
			location.href = "/proj/data/AddProject.jsp?projTypeId="+$(currentProjType).val()+"&templetId="+templetID;
		}
	}
}
function ItemCount_KeyPress_SandL()
{
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))))
  {
     window.event.keyCode=0;
  }
}

function checknumber_SandL(objectname)
{	
	valuechar = document.all(objectname).value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
	if(isnumber) document.all(objectname).value = "" ;
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<script type="text/javascript" src="/js/selectDateTime.js"></script>
</HTML>

<script language="javaScript">
//此处为合并时需要注意的地方
	var ptu = null;
	var iRowIndex = null;
	var RowindexNum = null;

	function init_ptu() {
	    //ptu = new ProjTaskUtil($("textarea[name=task_xml]").val()); 
	    //初始化input框 的宽度
	    iRowIndex = document.getElementById("task_iRowIndex").value;
	    RowindexNum = document.getElementById("task_RowindexNum").value;
	} 
   
function checkLength(){
	tmpvalue = $("input[name=PrjName]").val();
	if(realLength(tmpvalue)>50){
		//if(realLength(tmpvalue)==tmpvalue.length) document.all("PrjName").value=tmpvalue.substring(0,50);
		//else document.all("PrjName").value=tmpvalue.substring(0,25);
		while(true){
			tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);
			//alert(tmpvalue);
			if(realLength(tmpvalue)<=50){
				$("input[name=PrjName]").val(tmpvalue);
				return;
			}
		}
	}
}
 
 function submitData(obj){
    if(!check_form(weaver,'<%=chkFields%>PrjName,PrjType,WorkType,hrmids02,SecuLevel,PrjManager,PrjDept')) return false;
    obj.disabled = true;
 	var xmlDoc=document.createElement("rootTask");
 	var docDom=generaDomJson();
 	$.toXml(docDom,xmlDoc);
    document.getElementById("areaLinkXml").value= "<rootTask>"+ $(xmlDoc).html().replace(/\"\s/g,"\"").replace(/\s\"/g,"\"")+"</rootTask>";
    myBody.onbeforeunload=null;
    weaver.submit();    
}

function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth=-1;
    try {
    	var fso = new ActiveXObject("Scripting.FileSystemObject");
    	fileLenth=parseInt(fso.getFile(objValue).size);
    } catch (e){
        try{
    		fileLenth=parseInt(obj.files[0].size);
        }catch (e) {
			alert("您的浏览器不支持获取文件大小的操作");
			createAndRemoveObj(obj)
			return;
		}
    }
    if(fileLenth&&fileLenth<0){
    	createAndRemoveObj(obj);
    	return;
    }else{
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByK =  fileLenth/1024;
		var fileLenthByM =  fileLenthByK/1024;
	
		var fileLenthName;
		if(fileLenthByM>=0.1){
			fileLenthName=fileLenthByM.toFixed(1)+"M";
		}else if(fileLenthByK>=0.1){
			fileLenthName=fileLenthByK.toFixed(1)+"K";
		}else{
			fileLenthName=fileLenth+"B";
		}
		maxsize = document.getElementById("maxsize").value;
    if (fileLenthByM>maxsize) {
        alert("所传附件为:"+fileLenthName+",此目录下不能上传超过"+maxsize+"M的文件,如果需要传送大文件,请与管理员联系!");
        createAndRemoveObj(obj);
    }
}
function createAndRemoveObj(obj){
    objName = obj.name;
    var  newObj = document.createElement("input");
    newObj.name=objName;
    newObj.className="InputStyle";
    newObj.type="file";
    newObj.onchange=function(){accesoryChanage(this);};

    var objParentNode = obj.parentNode;
    var objNextNode = obj.nextSibling;
    $(obj).remove();
    objParentNode.insertBefore(newObj,objNextNode);
}
accessorynum = 2 ;
function addannexRow(){
	var nrewardTable = document.getElementById("tblProjectBaseInfo");
	var maxsize = document.getElementById("maxsize").value;
	oRow = nrewardTable.insertRow(-1);
	oRow.height=20;
	for(j=0; j<2; j++) {
		oCell = oRow.insertCell(-1);
		switch(j) {
    		case 0:
				var sHtml = "";
				oCell.innerHTML = sHtml;
				break;
            case 1:
        		oCell.colSpan = 4;
        		oCell.className = "field";
                var sHtml = "<input class=InputStyle style='width:100%'  type=file name='accessory"+accessorynum+"' onchange='accesoryChanage(this)'>(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:"+maxsize+"M)";
						oCell.innerHTML = sHtml;
			    break;
		}
	}
	$("input[name=accessory_num]").val(accessorynum) ;
	accessorynum = accessorynum*1 +1;
	oRow1 = nrewardTable.insertRow(-1);
	$(oRow1).css("height","1px")
	for(j=0; j<2; j++) {
		oCell1 = oRow1.insertCell(-1);
		switch(j) {
    		case 0:
				break;
            case 1:
        		oCell1.colSpan = 4
        		oCell1.className = "Line";
				break;
		}
	}
}
</script>

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
    ajax.open("POST", "AddProjectData.jsp?templetId=<%=templetId%>", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send(null);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.getElementById('TaskDataDIV').innerHTML = ajax.responseText;
                initPrjTaskObj();
                init_beforTaskStr();
                init_ptu();
            }catch(e){
                return false;
            }
        }
    }
}
showdata();
//初始化前置任务值
function init_beforTaskStr() {
	var taskArr = new Array();
	var txtTaskNames = document.getElementsByName("txtTaskName");
	for (i=1;i<=txtTaskNames.length;i++){
		taskArr[i-1] = txtTaskNames[i-1].value;
	}
	var seleBeforeTasks = document.getElementsByName("seleBeforeTask");
	for (i=1;i<=seleBeforeTasks.length;i++){
		try {
			if(seleBeforeTasks[i-1].value!=""&&seleBeforeTasks[i-1].value!="0") {

				document.getElementById('seleBeforeTaskSpan_'+i).innerHTML = taskArr[$('input[name=templetTaskId_'+seleBeforeTasks[i-1].value+"]").val()];
	   			seleBeforeTasks[i-1].value = $('input[name=templetTaskId_'+seleBeforeTasks[i-1].value+"]").val()*1+1;
	   			
			}
		}catch(e){
		}
	}
}
$(function(){
	impProjBase();
});
</script>
