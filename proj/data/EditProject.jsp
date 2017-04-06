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
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />


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

String sql_prjstatus="select status,accessory from Prj_ProjectInfo where id = "+ProjID;
RecordSet.executeSql(sql_prjstatus);
RecordSet.next();
String status_prj=RecordSet.getString("status");
String project_accessory = Util.null2String(RecordSet.getString("accessory"));//相关附件
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
ArrayList Members_proj = Util.TokenizerString(Members,",");
int Membernum = Members_proj.size();

for(int i=0;i<Membernum;i++){
    Memname= Memname+"<a href=\"/hrm/resource/HrmResource.jsp?id="+Members_proj.get(i)+"\">"+Util.toScreen(ResourceComInfo.getResourcename(""+Members_proj.get(i)),user.getLanguage())+"</a>";
    Memname+=" ";
}

   
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
String editable="yes";
if ("false".equals(isManagerFromView)){
    bbStyle="style='display:none'";
    inputDisabled = "readonly";
    editable="no";
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript"  type='text/javascript' src="/js/weaver.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/TaskUtil.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTaskUtil.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript'src="/js/projTask/TaskNodeXmlDoc.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/TaskDrag.js"></SCRIPT>  
<SCRIPT language="javascript"  type='text/vbScript' src="/js/projTask/ProjTask.vbs"></SCRIPT> 
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
<BODY id="myBody" onbeforeunload="protectProj()">

<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self}";
    RCMenuHeight += RCMenuHeightStep;

//TD4142
//modified by hubo,2006-04-14
// RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.back(),_self}";
//begin TD25863
      RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/data/ViewProject.jsp?log=n&ProjID="+ProjID+",_self}";
//end TD25863    
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver action="/proj/data/ProjectOperation.jsp" method=post enctype="multipart/form-data">
<input <%=inputDisabled%> type="hidden" name="method" value="edit">
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
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>

	<TD vAlign=top>
	
	  <TABLE class=viewform id="tblProjBaseInfo">
	     <thead>
		  <TR class=title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
		</thead>
		<tbody>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><input <%=inputDisabled%> class=inputstyle maxLength=50 size=50 name="PrjName" onblur="checkLength()" onchange='checkinput("PrjName","PrjNameimage")' value="<%=Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage())%>"><SPAN id=PrjNameimage></SPAN><br><span><font color="red"><%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>50(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)</font></span></TD>
        </TR>

		<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
       	<TR>
			<TD width="30%"><%=SystemEnv.getHtmlLabelName(17852,user.getLanguage())%></TD> 
         <TD width="70%" class=Field>
				<input type="text" <%=inputDisabled%>  class=inputstyle maxLength=50 size=30 name="PrjCode" value="<%=RecordSet.getString("procode")%>">
			</TD>
      </TR>
      <tr style="height:1px;">
		<TD class=line colSpan=2 style="height:1px;"></TD></TR>

		<!--ProjectCode End-->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TD>
          <TD class=Field>
         
              
              <input <%=inputDisabled%> class="wuiBrowser"  id=PrjType type="hidden" name=PrjType value="<%=RecordSet.getString("prjtype")%>"
              		_required="yes" _displayText="<%=ProjectTypeComInfo.getProjectTypename(RecordSet.getString("prjtype"))%>"
              		_url="/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp">     </TD>
        </TR>
        <tr style="height:1px;">
		 <TD class=line colSpan=2 style="height:1px;"></TD></TR>
		<!--ProjectTempletBrowser Begin-->
      <tr>
			<td><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></TD>
         <td class=Field>
            <%
                String templetId = RecordSet.getString("proTemplateId");
                if (!"".equals(templetId)) {
                    rs.executeSql("select templetName from Prj_Template where id="+templetId);
                    if (rs.next()){
                        out.println(rs.getString(1));
                    }
                }            
            %>
             <input <%=inputDisabled%> id="prjTempletID" type="hidden" name="prjTemplet" value="<%=templetId%>">
        </td>
		</tr>
      <tr style="height:1px;"><td class=line colSpan=2></td></tr>
		<!--ProjectTempletBrowser End-->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" <%=bbStyle%> class=Browser id=SelectCountryID onclick="onShowWorkTypeID()"></BUTTON> 
              <%
                String tempWorkType = Util.null2String(RecordSet.getString("worktype"));
                if (Util.getIntValue(tempWorkType)<1) tempWorkType="";
                String innerWorkType = "";          
                if (!"".equals(tempWorkType)){
                    innerWorkType = WorkTypeComInfo.getWorkTypename(tempWorkType);
                } else {
                    innerWorkType = "<IMG src=/images/BacoError.gif align=absMiddle>";
                }
               
              %>
              <SPAN id=WorkTypespan><%=innerWorkType%></SPAN> 
              <input <%=inputDisabled%> id=WorkType type=hidden name="WorkType" value="<%=tempWorkType%>"
              		_displayText
              		_url="/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp">
              </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
	<input <%=inputDisabled%> class=inputstyle maxLength=3 size=3 name="SecuLevel" type=hidden value="<%=Util.toScreenToEdit(RecordSet.getString("securelevel"),user.getLanguage())%>">
        </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></TD>
          <TD class=Field>
            <%if(!isactived.equals("2")&&(status_prj.equals("0"))){%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%>
		   <%if(!isactived.equals("2")&&(status_prj.equals("7"))){%><%=SystemEnv.getHtmlLabelName(1010,user.getLanguage())%><%}%>
		   <%if(!isactived.equals("2")&&(status_prj.equals("6"))){%><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%><%}%>
          <%if((isactived.equals("2"))&&(status_prj.equals("5"))){%><%=SystemEnv.getHtmlLabelName(2243,user.getLanguage())%><%}%>
          <%if((isactived.equals("2"))&&(status_prj.equals("1"))){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%><%}%>
          <%if((isactived.equals("2"))&&(status_prj.equals("2"))){%><%=SystemEnv.getHtmlLabelName(2244,user.getLanguage())%><%}%>
          <%if((isactived.equals("2"))&&(status_prj.equals("3"))){%><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%><%}%>
          <%if((isactived.equals("2"))&&(status_prj.equals("4"))){%><%=SystemEnv.getHtmlLabelName(1232,user.getLanguage())%><%}%>
                 <input <%=inputDisabled%> type="hidden" name="status" value="<%=RecordSet.getString("status")%>"/>
          </TD>
        </TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
         <TR>
         <%              
                String innerHrmNames = "";
                if (!"".equals(Members)){
                    innerHrmNames = Memname;
                } else {
                    innerHrmNames = "<IMG src=/images/BacoError.gif align=absMiddle>";
                }
               
              %>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
          <TD class=Field>
            <button type="button" <%=bbStyle%> class=Browser onclick="onShowMHrm(hrmids02,hrmids02span,hrmids03span,'false')"></button>
			<input <%=inputDisabled%> type=hidden name="hrmids02" id ="hrmids02" value="<%=Members%>">
			<span id="hrmids02span"><%=innerHrmNames%></span> 
            <span id="hrmids03span" style="display:none"></span> 
		  </TD>        
        </TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(624,user.getLanguage())%></TD>
          <TD class=Field>
			 <%if("false".equals(isManagerFromView)){%>
				<%if(RecordSet.getString("isblock").equals("1")){%>
					<img src="/images/BacoCheck.gif">
					<input type="hidden" name="MemberOnly" value=1>
				<%}else{%>
					<img src="/images/BacoCross.gif">
				<%}%>
			 <%}else{%>
				<input type=checkbox name="MemberOnly" value=1 <%if(RecordSet.getString("isblock").equals("1")){%> checked <%}%> >
			 <%}%>
			 </TD>
        </TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
          <TD class=Field>
          <%
          	String PrjDescspan="";
          	if(!RecordSet.getString("description").equals("")){
				ArrayList arraycrmids = Util.TokenizerString(RecordSet.getString("description"),",");
				for(int i=0;i<arraycrmids.size();i++){
					PrjDescspan+=("<A href='/CRM/data/ViewCustomer.jsp?CustomerID="+arraycrmids.get(i)+"'>"
							+CustomerInfoComInfo.getCustomerInfoname(""+arraycrmids.get(i))+"</a>&nbsp");
				}
			}
			
			%>	
			<input name="PrjDesc"  class="wuiBrowser"
				value="<%=RecordSet.getString("description")%> "
				_displayText="<%=PrjDescspan %>" _param="resourceids"
				_displayTemplate="<a href=/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}>#b{name}</a>&nbsp"
				_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
			
		  </TD>
        </TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15263,user.getLanguage())%></TD>
          <TD class=Field>
			 <%if("false".equals(isManagerFromView)){%>
				<%if(RecordSet.getString("ManagerView").equals("1")){%>
					<img src="/images/BacoCheck.gif">
					<input type="hidden" name="ManagerView" value=1>
				<%}else{%>
					<img src="/images/BacoCross.gif">
				<%}%>
			 <%}else{%>
				<input type=checkbox name="ManagerView" value=1 <%if(RecordSet.getString("ManagerView").equals("1")){%> checked <%}%> >
			 <%}%>
			</TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
		<%
		  String display = "0";
		  if(!project_accessory.equals("")) {
				display = "1";
				project_accessory = project_accessory.substring(0,project_accessory.lastIndexOf(","));
				String sql="select id,docsubject,accessorycount from docdetail where id in ("+project_accessory+")";
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
		  <tr>
            <input type=hidden name="field_del_<%=linknum%>" value="0" >
            <td>
			  <%if(linknum==0){%><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%><%}else{%><%}%> 
			</td>
			<td class=Field>
              <%=imgSrc%>
              <%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc"))){%>
                <a style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp
              <%}%>
              <input type=hidden name="field_id_<%=linknum%>" value=<%=showid%>>
			    <button type="button" class=btnFlow accessKey=1 onclick='onChangeSharetype("span_id_<%=linknum%>","field_del_<%=linknum%>","<%=0%>")'>
				<u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
				<span id="span_id_<%=linknum%>" name="span_id_<%=linknum%>" style="visibility:hidden">
                    <B><FONT COLOR="#FF0033">√</FONT></B>
                <span>
            </td>
          </tr>
		  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
          <%}%>
            <input type=hidden name="field_idnum" value=<%=linknum+1%>>
            <input type=hidden name="field_idnum_1" value=<%=linknum+1%>>
        <%}%> 
		<%  
		String mainId = "";
		String subId = "";
		String secId = "";
		String maxsize = "0";
		String pathcategory = "";
		rs.executeSql("select * from ProjectAccessory");
		if(rs.next()) pathcategory = rs.getString(3);
		if(!"".equals(pathcategory)){
			 mainId = Util.null2String(rs.getString(2));
		     subId = Util.null2String(rs.getString(3));
		     secId = Util.null2String(rs.getString(4));
		     rs.executeSql("select maxUploadFileSize from DocSecCategory where id="+secId);
		     rs.next();
		     maxsize = Util.null2String(rs.getString(1));
		%>
        <tr>
		  <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
          <td class=field>
           <input class=inputstyle type=file name="accessory1"  onchange='accesoryChanage(this)'>(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=maxsize%>M)
		   <button type="button" class=AddDoc name="addacc" onclick="addannexRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
		   <input type=hidden name=accessory_num value="1">
		   <input type=hidden name=mainId value="<%=mainId%>">
		   <input type=hidden name=subId value="<%=subId%>">
		   <input type=hidden name=secId value="<%=secId%>">
		   <input type=hidden id="maxsize" name="maxsize" value="<%=maxsize%>">
          </td>    
		<%}else{%>
		<td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
		<td class=field ><font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font></td>
       <%}%>
       </tr>
        </TBODY>
	  </TABLE>

                                    <!--***********************************************************-->
                                    <!--ProjectTypeFreeField Begin--> 
                                    <TABLE class=ViewForm id="tblProjTypeFreeField">
                                    <thead>
                                    <tr class="title">
												<th colspan="2">
												<%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17088,user.getLanguage())%></th>
												</tr>
                                    <tr class="spacing" style="height:1px;"><td class="line1" colSpan="2"></td></tr>
                                    </thead>
                                    <tbody>
                                    <%
                                         CustomFieldManager cfm = new CustomFieldManager("ProjCustomField",Util.getIntValue(RecordSet.getString("prjtype")));
                                         cfm.getCustomFields();    
										 String chkFields="";
										 cfm.getCustomData("ProjCustomFieldReal",Util.getIntValue(RecordSet.getString("prjtype")),Util.getIntValue(ProjID));
                                        while(cfm.next()){
                                            if(cfm.isMand()){
                                                needinputitems += ",customfield"+cfm.getId();
                                            }
                                            String fieldvalue ="" ;
                                            if(cfm.getHtmlType().equals("2")){
                                            	fieldvalue = Util.toHtmltextarea(cfm.getData("field"+cfm.getId()));
                                            }else{
                                            	fieldvalue = Util.toHtml(cfm.getData("field"+cfm.getId()));
                                            	//fieldvalue = cfm.getData("field"+cfm.getId());
                                            }
                                    %>
                                        <tr>
                                          <td width="30%" <%if(cfm.getHtmlType().equals("2")){%> valign=top <%}%>> <%=cfm.getLable()%> </td>
                                          <td width="70%" class=field >
                                          <%
                                            if(cfm.getHtmlType().equals("1")){
                                                if(cfm.getType()==1){
                                                    if(cfm.isMand()){
													chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input <%=inputDisabled%> datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>"  maxlength="100" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>100(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)" onKeyPress="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                    }else{
                                          %>
                                            <input <%=inputDisabled%> datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" maxlength="100" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>100(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)" value="" onKeyPress="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
                                            <span id="customfield<%=cfm.getId()%>span"></span>
                                          <%
                                                    }
                                                }else if(cfm.getType()==2){
                                                    if(cfm.isMand()){
													chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input <%=inputDisabled%>  datatype="int" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>"                             size='10' maxlength="9"  onblur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span');checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>10" onKeyPress="ItemCount_KeyPress(this)">
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                    }else{
                                          %>
                                          <input <%=inputDisabled%>  datatype="int" type=text  value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size='10' maxlength="9"  onblur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span');checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>10" onKeyPress="ItemCount_KeyPress(this)">
                                          <span id="customfield<%=cfm.getId()%>span"></span>
                                          <%
                                                    }
                                                }else if(cfm.getType()==3){
                                                    if(cfm.isMand()){
													chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input <%=inputDisabled%> datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size='10'  maxlength="10" onblur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span');checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>10" onKeyPress="ItemNum_KeyPress(this)">
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                    }else{
                                          %>
                                            <input <%=inputDisabled%> datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size='10' maxlength="10" onblur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span');checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>10"  onKeyPress="ItemNum_KeyPress(this)" >
                                            <span id="customfield<%=cfm.getId()%>span"></span>
                                          <%
                                                    }
                                                }
                                            }else if(cfm.getHtmlType().equals("2")){
                                                if(cfm.isMand()){
												chkFields+="customfield"+cfm.getId()+",";

                                          %>
                                            <textarea <%=inputDisabled%> class=Inputstyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')"
                                                rows="4" cols="40" style="width:80%" class=Inputstyle><%=fieldvalue%></textarea>
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                }else{
                                          %>
                                            <textarea <%=inputDisabled%> class=Inputstyle name="customfield<%=cfm.getId()%>" rows="4" cols="40" style="width:80%"><%=fieldvalue%></textarea>
                                          <%
                                                }
                                            }else if(cfm.getHtmlType().equals("3")){

                                                if(cfm.isMand()){
                                                    chkFields+="customfield"+cfm.getId()+",";
                                                }
                                                String fieldtype = String.valueOf(cfm.getType());
                                                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                                                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                                                String showname = "";                                   // 新建时候默认值显示的名称
                                                String showid = "";                                     // 新建时候默认值

                                                String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
                                                String newdocid = Util.null2String(request.getParameter("docid"));

                                                if( fieldtype.equals("37") && !newdocid.equals("")) {
													//chkFields+="customfield"+cfm.getId()+",";
                                                    if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                                                    fieldvalue += newdocid ;
                                                }

                                                if(fieldtype.equals("2") ||fieldtype.equals("19")){
                                                    showname=fieldvalue; // 日期时间
                                                }else if(!fieldvalue.equals("")) {
													//chkFields+="customfield"+cfm.getId()+",";
                                                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                                                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                                                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                                                    String sql = "";

                                                    HashMap temRes = new HashMap();

                                                    if(fieldvalue.startsWith(",")){
														fieldvalue = fieldvalue.substring(1);
													}
                                                	if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("152") ||  fieldtype.equals("135")) {    // 多人力资源,多客户,多会议，多文档
                                                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                                                    }
                                                    else {
                                                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                                                    }

                                                    RecordSet2.executeSql(sql);
                                                    while(RecordSet2.next()){
                                                        showid = Util.null2String(RecordSet2.getString(1)) ;
                                                        String tempshowname= Util.toScreen(RecordSet2.getString(2),user.getLanguage()) ;
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
                                                    if(fieldtype.equals("16")||fieldtype.equals("152")){
                                                    	showname = Util.StringReplace(showname,"isrequest=1&","");
                                                    }

                                                }



                                           %>
                                            <button type="button" <%=bbStyle%> class=Browser onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
                                            <input <%=inputDisabled%> type=hidden name="customfield<%=cfm.getId()%>" value="<%=fieldvalue%>">
                                            <span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
                                                <%if(cfm.isMand() && fieldvalue.equals("")) {
											   chkFields+="customfield"+cfm.getId()+",";%>
											   <img src="/images/BacoError.gif" align=absmiddle><%}%>
                                            </span>
                                           <%
                                            }else if(cfm.getHtmlType().equals("4")){
                                           %>
															<%if("false".equals(isManagerFromView)){%>
																<%if(fieldvalue.equals("1")){%>
																	<img src="/images/BacoCheck.gif">
																	<input type="hidden" value=1 name="customfield<%=cfm.getId()%>">
																<%}else{%>
																	<img src="/images/BacoCross.gif">
																<%}%>
															<%}else{%>
																<input <%=inputDisabled%> type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
															<%}%>
                                           <%
                                            }else if(cfm.getHtmlType().equals("5")){
                                                cfm.getSelectItem(cfm.getId());
                                                boolean checkempty_tmp = true;
                                                if(cfm.isMand() && !"false".equals(isManagerFromView)) {
                                                	chkFields+="customfield"+cfm.getId()+",";
                                                }
                                           %>

														<%if("false".equals(isManagerFromView)){%>
																<%while(cfm.nextSelect()){%>
																	<%if(cfm.getSelectValue().equals(fieldvalue)){out.println(cfm.getSelectName());%>
																	<input type="hidden" name="customfield<%=cfm.getId()%>" value="<%=cfm.getSelectValue()%>">
																	<%}%>
																<%}%>
														<%}else{%>
															 <select <%=inputDisabled%> name="customfield<%=cfm.getId()%>" viewtype="<%if(cfm.isMand()){out.print("1");}else{out.print("0");}%>" class="InputStyle" onChange="checkinput2('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span',this.viewtype)">
																<option value=""></option>
															 <%while(cfm.nextSelect()){
																	if(cfm.getSelectValue().equals(fieldvalue)){
																		checkempty_tmp = false;
																	}
															 %>
																	<option value="<%=cfm.getSelectValue()%>" <%=cfm.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm.getSelectName()%></option>
															 <%}%>
															 </select>
															<span id="customfield<%=cfm.getId()%>span">
															<%
															if(cfm.isMand() && checkempty_tmp) {
															%>
																<img src="/images/BacoError.gif" align=absmiddle>
															<%
															}
															%>
															</span>
														<%}%>

                                           <%
                                            }
                                           %>
                                                </td>
                                            </tr>
                                              <TR style="height:1px;"><TD class=Line colSpan=2></TD>
                                      </TR>
                                           <%
                                        }
                                           %>
													</tbody>
                                      </table>

<!--ProjectTypeFreeField End-->
<!--***********************************************************-->





	</TD>

	<TD></TD>

	<TD vAlign=top>
      
	  <TABLE class=viewform id="tblProjManageInfo">
      <COLGROUP>
        <col width="30%">
        <col width="70%">
		<thead>
		  <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(633,user.getLanguage())%></TH>
				<th style="text-align:right"><span class="spanSwitch" onclick="doSwitch('tblProjBaseInfo,tblProjManageInfo')"><img src='/images/up.jpg' style="cursor:hand"></span></th>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
		</thead>
 
	  <tbody>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(636,user.getLanguage())%></TD>
       
        <input <%=inputDisabled%> class="wuiBrowser" type=hidden name="ParentID" value=<%=Util.toScreenToEdit(RecordSet.getString("parentid"),user.getLanguage())%>
        	_editable="<%=editable %>"
        	_displayText="<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(RecordSet.getString("parentid")),user.getLanguage())%>"
        	_displayTemplate="<A href='/proj/data/ViewProject.jsp?ProjID=#b{id}'>#b{name}</a>"
        	_url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp">
        </TD>
        </TR>
		<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(637,user.getLanguage())%></TD>
          <TD class=Field>
        <input <%=inputDisabled%> class="wuiBrowser" type=hidden name="EnvDoc" value=<%=Util.toScreenToEdit(RecordSet.getString("envaluedoc"),user.getLanguage())%>
        	_editable="<%=editable %>"
        	_displayText="<%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("envaluedoc")),user.getLanguage())%>"
        	_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>"
        	_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp">
        </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(638,user.getLanguage())%></TD>
          <TD class=Field>
          	
        	<input <%=inputDisabled%> class="wuiBrowser" type=hidden name="ConDoc" value=<%=Util.toScreenToEdit(RecordSet.getString("confirmdoc"),user.getLanguage())%>
        		_editable="<%=editable %>"
        		_displayText="<%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("confirmdoc")),user.getLanguage())%>"
        		_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>"
        		_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp">
        
        </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(639,user.getLanguage())%></TD>
          <TD class=Field>
        	<input <%=inputDisabled%> class="wuiBrowser" type=hidden name="ProDoc" value=<%=Util.toScreenToEdit(RecordSet.getString("proposedoc"),user.getLanguage())%>
        		_editable="<%=editable %>"
        		_displayText="<%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("proposedoc")),user.getLanguage())%>"
        		_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>"
        		_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp">
        	</TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field>
              <input <%=inputDisabled%>  class="wuiBrowser" type=hidden name="PrjManager" value=<%=Util.toScreenToEdit(RecordSet.getString("manager"),user.getLanguage())%>
              	 _required="yes" _editable="<%=editable %>" _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%>"
              	_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
              	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
              </TD>
        </TR><TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR> 

        </TBODY>
	  </TABLE>
<%if(hasFF){%>
	  <TABLE class=viewform id="tblProjFreeField">
      <COLGROUP>
        <col width="30%">
        <col width="70%">
		<thead>
		  <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
				<th style="text-align:right"><span class="spanSwitch" onclick="doSwitch('tblProjTypeFreeField,tblProjFreeField')"><img src='/images/up.jpg' style="cursor:hand"></span></th>
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
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2),user.getLanguage())%></TD>
          <TD class=Field><button type="button" <%=bbStyle%> class=Calendar onclick="getProjdate(<%=i%>)"></BUTTON> 
              <SPAN id=datespan<%=i%> ><%=RecordSet.getString("datefield"+i)%></SPAN> 
              <input <%=inputDisabled%> type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=RecordSet.getString("datefield"+i)%>"></TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></TD>
          <TD class=Field><input <%=inputDisabled%> class=inputstyle maxLength=30 size=30 name="nff0<%=i%>" value="<%=RecordSet.getString("numberfield"+i)%>"></TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field><input <%=inputDisabled%> class=inputstyle maxLength=100 size=30 name="tff0<%=i%>" value="<%=Util.toScreen(RecordSet.getString("textfield"+i),user.getLanguage())%>"></TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+30),user.getLanguage())%></TD>
          <TD class=Field>
			 <%if("false".equals(isManagerFromView)){%>
				<%if(RecordSet.getString("tinyintfield"+i).equals("1")){%>
					<img src="/images/BacoCheck.gif">
					<input type="hidden" value=1 name="bff0<%=i%>">
				<%}else{%>
					<img src="/images/BacoCross.gif">
				<%}%>
			<%}else{%>
				<input <%=inputDisabled%> type=checkbox value=1 name="bff0<%=i%>" <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked <%}%>>
			<%}%>
          </TD>
        </TR><TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR> 
		<%}
	}
%>
        </TBODY>
	  </TABLE>
<%}%>


	</TD>
  </TR>
  </TBODY>
</TABLE>



	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%
//TD5205
//modified by hubo, 2006-10-26
ProjTempletUtil.getViewProjTaskListStr(request, Util.getIntValue(ProjID));%>
<TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none">
	<%=Util.StringReplace(ProjTempletUtil.getXmlStr(), "\\", "")%>
</TEXTAREA> 
</FORM>



<script language=vbs>




sub onShowPrjStatusID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectStatusBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	PrjStatusspan.innerHtml = id(1)
	weaver.PrjStatus.value=id(0)
	else 
	PrjStatusspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	weaver.PrjStatus.value=""
	end if
	end if
end sub

sub showEnvDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		weaver.EnvDoc.value=id(0)&""
		EnvDocname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"	
	end if	
end sub

sub onShowMCrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&tmpids)
        if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
        end if
end sub

sub onShowMCon(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiContractBrowser.jsp?contractids="&tmpids)
        if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)                  
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a  href=/CRM/data/ContractView.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/CRM/data/ContractView.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
         end if
end sub
</script>
</BODY>
</HTML>
<script language="javaScript">  
function onShowWorkTypeID(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp")
	if(datas){
		if(datas.id!=""){
			$("#WorkTypespan").html(datas.name);
			$("input[name=WorkType]").val(datas.id);
		}else{ 
			$("#WorkTypespan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			$("input[name=WorkType]").val("");
		}
	}
}
     var ptu = new ProjTaskUtil('<%=ProjTempletUtil.getXmlStr()%>'); 
    //初始化input框 的宽度
    ptu.modiAllTxtSize();
    var iRowIndex = <%=ProjTempletUtil.getMaxProjectTaskId(Util.getIntValue(ProjID))%> ;

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
                
                //删掉select框里的值
                 var seleBeforeTaskObjs = document.getElementsByName("seleBeforeTask");
                for (var j=0;j<seleBeforeTaskObjs.length;j++){
                    var optionIndex = getOptionIndex( seleBeforeTaskObjs[j].options,delItem);
                    if (optionIndex!=-1)  seleBeforeTaskObjs[j].options.remove(optionIndex);  
                }
               
            }
             document.getElementById("chkAllObj").checked = false ;
        } catch(ex){}
    }
   
    function submitData(obj){
	   if (check_form(weaver,'<%=chkFields%>PrjName,PrjType,WorkType,SecuLevel,PrjStatus,PrjManager,PrjDept,hrmids02')) {
            obj.disabled = true;  
            myBody.onbeforeunload=null;
    		weaver.submit();
        }
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
    
    function checkLength(){
			tmpvalue = document.all("PrjName").value;
			if(realLength(tmpvalue)>50){
				alert("<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>50(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)");
				//if(realLength(tmpvalue)==tmpvalue.length) document.all("PrjName").value=tmpvalue.substring(0,50);
				//else document.all("PrjName").value=tmpvalue.substring(0,25);
				while(true){
					tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);
					//alert(tmpvalue);
					if(realLength(tmpvalue)<=50){
						document.all("PrjName").value = tmpvalue;
						return;
					}
				}
			}
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
    function opendoc(showid,versionid,docImagefileid){
    	openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&from=accessory&wpflag=workplan");
    }
    function opendoc1(showid){
    	openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&wpflag=workplan");
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
    	var nrewardTable = document.getElementById("tblProjBaseInfo");
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
                    var sHtml = "<input class=InputStyle  type=file name='accessory"+accessorynum+"' onchange='accesoryChanage(this)'>(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:"+maxsize+"M)";
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>

