<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.AttachFileUtil"%>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />

<HTML>
	<HEAD>
	    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/weaver.js"></SCRIPT>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList.js"></SCRIPT>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/TaskUtil.js"></SCRIPT>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTaskUtil.js"></SCRIPT>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/TaskDrag.js"></SCRIPT>  
        <script type="text/javascript" src="/js/projTask/temp/prjTask.js"></script>
	<script type="text/javascript" src="/js/projTask/temp/jquery.z4x.js"></script>
	<script type="text/javascript" src="/js/projTask/temp/ProjectAddTaskI2.js"></script>
	<script type="text/javascript" src="/js/projTask/ProjTask.js"></script>
    <SCRIPT language="javascript"  type='text/vbScript' src="/js/projTask/ProjTask.vbs"></SCRIPT>
   </HEAD>

<%  
    //判断是否具有项目编码的维护权限
    boolean canMaint = false ;
    if (HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {       
        canMaint = true ;
    }
    

    String imagefilename = "/images/sales.gif";
	String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";//取得相应设置的值

    
    /*为了兼容项目自定义字段*/
    boolean hasFF = true;
    RecordSetFF.executeProc("Base_FreeField_Select","p1");
    if(RecordSetFF.getCounts()<=0)
        hasFF = false;
    else
        RecordSetFF.first(); 

    int projTypeId = Util.getIntValue(request.getParameter("txtPrjType"));   
    int scopid = projTypeId ;
    String  prjid ="";
    String  crmid="";
    String  hrmid="";
    String docid="";
    String needinputitems = "";
   /*END*/


  int templetId = Util.getIntValue(request.getParameter("templetId"));
  if (templetId==-1) {
    out.println("页面出现错误,请与管理员联系!");
    return ;
  }
%>

<BODY id="myBody" onbeforeunload="protectProj(event)">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    if (canMaint) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this)',_self} " ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:location='ProjTempletOperate.jsp?method=delete&templetId="+templetId+"',_self} " ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='ProjTempletAdd.jsp',_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
	RCMenu += "{"+SystemEnv.getHtmlLabelName(320,user.getLanguage())+",javascript:location='ProjTempletList.jsp',_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
    String templetName = "";
    String templetDesc = "";
    String workTypeId = "";
    String proMember = "";
    String isMemberSee = "";
    String proCrm = "";
    String isCrmSee = "";
    String parentProId = "";
    String commentDoc = "";
    String confirmDoc = "";
    String adviceDoc = "";
    String Manager = "";
    String relationXml = "";
    String strSql = "select * from Prj_Template where id=" + templetId;
    RecordSet.executeSql(strSql);
    if (RecordSet.next()) {
        templetName = Util.null2String(RecordSet.getString("templetName"));
        templetDesc = Util.null2String(RecordSet.getString("templetDesc"));

        if (projTypeId == -1) {
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
    String proMembername = "";
    ArrayList Members_proj = Util.TokenizerString(proMember, ",");
    String[] proMembers = proMember.split(",");
    for (int i = 0; i < Members_proj.size(); i++) {
        proMembername += "<a href=/hrm/resource/HrmResource.jsp?id="+proMembers[i]+">"+ResourceComInfo.getResourcename( ""+ Members_proj.get(i))+"</a>&nbsp;";
    }
%>
<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
    <TD height="10" colspan="3"></TD>
</TR> 
<TR>
    <TD></TD>
    <TD valign="top">
        <Form name="frmEdit"  method="post"  action="ProjTempletOperate.jsp">
        <input type="hidden" name="method" value="edit">
        <input type="hidden" name="templetId" value="<%=templetId%>">
         <TABLE class=Shadow >
            <TR>
                <TD valign="top">
                    <!--模板基本信息-->
                    <TABLE  CLASS="viewForm"  valign="top">
                        <TR CLASS="title">
                            <TH  WIDTH="80%"><%=SystemEnv.getHtmlLabelName(18625,user.getLanguage())%></TH>
                            <TD WIDTH="20%">
                                <div align="right">
                                    <img src="/images/up.jpg" style="cursor:pointer" onclick="onHiddenImgClick(divMainInfo,this)" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" objStatus="show">
                                <div>
                            </TD>
                         </TR>
                        <TR style="height:1px;">
                        <TD CLASS="line1" colspan="2"></TD></TR>                
                     </TABLE>
                      <div id="divMainInfo">
                            <TABLE CLASS="viewForm" valign="top" >
                                <colgroup>
                                <col width="15%">
                                <col width="30%">
                                <col width="10%">
                                <col width="15%">
                                <col width="30%">                 
                                <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <INPUT TYPE="text" NAME="txtTempletName" class="inputStyle" onchange="checkinput('txtTempletName','spanTempletName')" value="<%=templetName%>"> 
                                        <span id=spanTempletName><% if("".equals(templetName))  out.println("<img src='/images/BacoError.gif' align=absmiddle>");%></span>
                                    </TD>
                                    <TD></TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <INPUT TYPE="text" NAME="txtTempletDesc" class="inputStyle" value="<%=templetDesc%>">
                                    </TD>                           
                                </TR>
                                <TR style="height:1px;"><TD CLASS="Line" colspan="5"></TD></TR>
                            </TABLE>
                            <BR>      

                            <TABLE CLASS="viewForm" valign="top">
                            <colgroup>
                            <col width="45%">              
                            <col width="10%">
                            <col width="45%">
                            <TR>
                                <!--左边-->
                                <TD  valign="top">
                                    <TABLE CLASS="viewForm" valign="top">
                                        <colgroup>
                                        <col width="30%">              
                                        <col width="70%">                       
                                        <TR CLASS="title"><TH colspan="2"><%=SystemEnv.getHtmlLabelName(18625,user.getLanguage())%></TH></TR>
                                        <TR style="height:1px;"><TD CLASS="line1" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <button type="button" class=Browser id=SelectCountryID onclick="onShowPrjTypeID(txtPrjType,spanPrjType,spanPrjTypeImg,'edit','<%=templetId%>')"></BUTTON>  
                                                <span id="spanPrjType"><a href="/proj/Maint/EditProjectType.jsp?id=<%=projTypeId%>"><%=ProjectTypeComInfo.getProjectTypename(""+projTypeId)%></a></span>  
                                                <span id="spanPrjTypeImg"><% if(projTypeId==-1)  out.println("<img src='/images/BacoError.gif' align=absmiddle>");%></span>
                                                <INPUT id="txtPrjType" type="hidden" name=txtPrjType value="<%=projTypeId%>">
                                            </TD>                                                      
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TD>
                                            <TD class="field">
                                                
                                                <INPUT id=txtWorkType class="wuiBrowser" type=hidden name=txtWorkType value="<%=workTypeId%>" _displayText="<%=WorkTypeComInfo.getWorkTypename(workTypeId) %>"
                                                	_url="/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp">   
                                            </TD>                                                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(18628,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <input type=hidden name="hrmids02" class="wuiBrowser" id ="hrmids02" value="<%=proMember %>" 
                                                 _displayText="<%=proMembername%>"
										_param="resourceids" _displayTemplate="<a href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</a>&nbsp"
										_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp">
                                            </TD>                                                       
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(624,user.getLanguage())%></TD>
                                            <TD class="field">
                                                     <input class="inputStyle" type="checkbox" name="isMemberShow"  <%if ("1".equals(isMemberSee)) out.println("checked");%>  value="1">
                                            </TD>                                                            
                                        </TR>  
                                         <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <input class="wuiBrowser" name="areaAboutMCrm" id="areaAboutMCrm"  _param="resourceids"
                                                	_displayTemplate="<a href=/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}>#b{name}</a>&nbsp"
                                                	_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
                                            </TD>                                                              
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(15263,user.getLanguage())%></TD>
                                            <TD class="field">
                                                 <input class="inputStyle" type="checkbox" name="isCrmShow"  <%if ("1".equals(isCrmSee)) out.println("checked");%> value="1">
                                            </TD>                                            
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>   
                                    </TABLE>                            
                                </TD>

                                <!--中间-->
                                <TD></TD>

                                <!--右边-->
                                
                                <TD  valign="top">    
                                    <TABLE CLASS="viewForm" valign="top">
                                    <colgroup>
                                        <col width="30%">              
                                        <col width="70%">  
                                        <TR CLASS="title"><TH colspan="2"><%=SystemEnv.getHtmlLabelName(633,user.getLanguage())%></TH></TR>
                                        <TR style="height:1px;"><TD CLASS="line1" colspan="2"></TD></TR>
                                        <TR>                                        
                                            <TD><%=SystemEnv.getHtmlLabelName(636,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <input type="hidden" class="wuiBrowser" id="txtParentId"  value="<%=parentProId%>" name="txtParentId" 
                                                	_displayText="<%=ProjectInfoComInfo.getProjectInfoname(parentProId) %>"
                                                	_displayTemplate="<a href='/proj/data/ViewProject.jsp?ProjID=#b{id}'>#b{name}</a>"
                                                	_url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" 
                                                	>
                                            </TD>                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(637,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <INPUT  type=hidden class="wuiBrowser" name="txtEnvDoc" id="txtEnvDoc" value="<%=commentDoc%>"
                                                	_displayText="<%=DocComInfo.getDocname(commentDoc) %>"
                                                	_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>"
                                                	_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp">  
                                            </TD>                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(638,user.getLanguage())%></TD>
                                            <TD class="field">
                                                 <INPUT  type=hidden class="wuiBrowser" name="txtConDoc" id="txtConDoc" value="<%=confirmDoc%>"
                                                	_displayText="<%=DocComInfo.getDocname(confirmDoc) %>"
                                                	_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>"
                                                	_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"> 
                                            </TD>                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(639,user.getLanguage())%></TD>
                                            <TD class="field">   
                                                <INPUT  type=hidden class="wuiBrowser" name="txtAdviceDoc" id="txtAdviceDoc" value="<%=adviceDoc%>"
                                                	_displayText="<%=DocComInfo.getDocname(adviceDoc) %>"
                                                	_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>"
                                                	_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp">
                                            </TD>                           
                                        </TR>  
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <INPUT type=hidden class="wuiBrowser" name="txtPrjManager" id="txtPrjManager" value="<%=Manager%>"
                                                	_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
                                                	_url=" /systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
                                                	_displayText="<%=ResourceComInfo.getLastname(Manager)%>" 
                                                	>
                                               
                                            </TD>                           
                                        </TR>
                                         <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>                                    
                                    </TABLE>                      
                                  </TD>                           
                           </TR>            
                        </TABLE>

                      </div> <!-- divMainInfo End-->
                      <BR>
                   <!--项目自定义信息-->
                    <TABLE  CLASS="viewForm"  valign="top">
                        <colgroup>
                        <col width="45%">              
                        <col width="10%">
                        <col width="40%">
                        <col width="5%">             
                        <TR CLASS="title">
                            <TH><%=SystemEnv.getHtmlLabelName(18629,user.getLanguage())%></TH>
                            <TH></TH>
                            <TH><%=SystemEnv.getHtmlLabelName(18630,user.getLanguage())%></TH>
                            <TH>
                                <div align="right">
                                    <img src="/images/up.jpg" style="cursor:pointer" onclick="onHiddenImgClick(divCustomInfo,this)" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" objStatus="show">
                                </div>
                            </TH>
                        <TR style="height:1px;">
                            <TD class="line1"></TD>
                            <TD></TD>
                            <TD class="line1" colspan="2"></TD>
                         </TR>
                     </TABLE>
                    <div id="divCustomInfo">
                     <TABLE CLASS="viewForm" valign="top">
                            <colgroup>
                            <col width="45%">              
                            <col width="10%">
                            <col width="45%">
                            <TR>
                                <TD>
                                    <!--自定义字段部分 A 项目自定义字段部分-->
                                    <%if(hasFF){%>
                                      <TABLE class=viewform>
                                        <COLGROUP>
                                        <COL width="30%">
                                        <COL width="70%">
                                        <TBODY>
                                         <%
                                            for(int i=1;i<=5;i++)
                                            {
                                                if(RecordSetFF.getString(i*2+1).equals("1"))
                                                {%>
                                                <TR>
                                                  <TD><%=Util.toScreen(RecordSetFF.getString(i*2),user.getLanguage())%></TD>
                                                  <TD class=Field><button type="button" class=Calendar onclick="getProjdate(<%=i%>)"></BUTTON> 
                                                      <SPAN id=datespan<%=i%> ><%=RecordSet.getString("datefield"+i)%></SPAN> 
                                                      <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=RecordSet.getString("datefield"+i)%>"></TD>
                                                </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
                                                <%}
                                            }
                                            for(int i=1;i<=5;i++)
                                            {
                                                if(RecordSetFF.getString(i*2+11).equals("1"))
                                                {%>
                                                <TR>
                                                  <TD><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></TD>
                                                  <TD class=Field><INPUT class=inputstyle maxLength=30  name="nff0<%=i%>" value="<%=RecordSet.getString("numberfield"+i)%>"></TD>
                                                </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
                                                <%}
                                            }
                                            for(int i=1;i<=5;i++)
                                            {
                                                if(RecordSetFF.getString(i*2+21).equals("1"))
                                                {%>
                                                <TR>
                                                  <TD><%=Util.toScreen(RecordSetFF.getString(i*2+20),user.getLanguage())%></TD>
                                                  <TD class=Field><INPUT class=inputstyle maxLength=100  name="tff0<%=i%>" value="<%=Util.toScreen(RecordSet.getString("textfield"+i),user.getLanguage())%>"></TD>
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
                                                  <INPUT type=checkbox  name="bff0<%=i%>" value="1" <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked <%}%>></TD>
                                                </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
                                                <%}
                                            }
                                        %>
                                                </TBODY>
                                              </TABLE>
                                        <%}%>
                                </TD>

                                <TD>
                                </TD>

                                <TD  valign="top">
                                <!--自定义字段部分 B 项目类型自定义字段部分--> 
                                 <TABLE class=ViewForm>
                                      <COLGROUP>
                                      <COL width="30%">
                                      <COL width="70%">
                                      </COLGROUP>
                                    <%
                                        CustomFieldManager cfm = new CustomFieldManager("ProjCustomField",projTypeId);
                                        cfm.getCustomFields();
										String chkFields="";
                                        cfm.getCustomData(templetId);
                                        while(cfm.next()){
                                            if(cfm.isMand()){
                                                needinputitems += ",customfield"+cfm.getId();
                                            }
                                            String fieldvalue = "";
                                            if(cfm.getHtmlType().equals("2")){
                                            	fieldvalue = Util.toHtmltextarea(cfm.getData("field"+cfm.getId()));
                                            }else{
                                            	fieldvalue = Util.toHtml(cfm.getData("field"+cfm.getId()));
                                            	//fieldvalue = cfm.getData("field"+cfm.getId());
                                            }
                                    %>
                                        <tr>
                                          <td <%if(cfm.getHtmlType().equals("2")){%> valign=top <%}%>> <%=cfm.getLable()%> </td>
                                          <td class=field >
                                          <%
                                            if(cfm.getHtmlType().equals("1")){
                                                if(cfm.getType()==1){
                                                    if(cfm.isMand()){
														chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                    }else{
                                          %>
                                            <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" value="">
                                          <%
                                                    }
                                                }else if(cfm.getType()==2){
                                                    if(cfm.isMand()){
													chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input  datatype="int" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>"                                                onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                    }else{
                                          %>
                                          <input  datatype="int" type=text  value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
                                          <%
                                                    }
                                                }else if(cfm.getType()==3){
                                                    if(cfm.isMand()){
													chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
                                                onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
                                            <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                                          <%
                                                    }else{
                                          %>
                                            <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
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
													chkFields+="customfield"+cfm.getId()+",";
                                                    if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                                                    fieldvalue += newdocid ;
                                                }

                                                if(fieldtype.equals("2") ||fieldtype.equals("19")){
													chkFields+="customfield"+cfm.getId()+",";
                                                    showname=fieldvalue; // 日期时间
                                                }else if(!fieldvalue.equals("")) {
													chkFields+="customfield"+cfm.getId()+",";
                                                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                                                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                                                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                                                    String sql = "";

                                                    HashMap temRes = new HashMap();

                                                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65") ||fieldtype.equals("152")||fieldtype.equals("135")) {    // 多人力资源,多客户,多会议，多文档
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
											    chkFields+="customfield"+cfm.getId()+",";%>
												<img src="/images/BacoError.gif" align=absmiddle><%}%>
                                            </span>
                                           <%
                                            }else if(cfm.getHtmlType().equals("4")){
                                           %>
                                            <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
                                           <%
                                            }else if(cfm.getHtmlType().equals("5")){
                                            	chkFields+="customfield"+cfm.getId()+",";
                                                cfm.getSelectItem(cfm.getId());
                                                boolean checkempty_tmp = true;
                                           %>
                                           <select name="customfield<%=cfm.getId()%>"  viewtype="<%if(cfm.isMand()){out.print("1");}else{out.print("0");}%>" class="InputStyle" onChange="checkinput2('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span',this)">
											<option value=""></option>
                                           <%
                                                while(cfm.nextSelect()){
											   chkFields+="customfield"+cfm.getId()+",";
												if(cfm.getSelectValue().equals(fieldvalue)){
													checkempty_tmp = false;
												}
                                           %>
                                                <option value="<%=cfm.getSelectValue()%>" <%=cfm.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm.getSelectName()%>
                                           <%
                                                }
                                           %>
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
                                      </table>
                                    <!--end   自定义字段-->
                                </TD>
                            </TR>
                     </TABLE>
                    </div> <!-- divCustomInfo End-->
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

                </TD>
            </TR>            
         </TABLE>
         </FORM>
    </TD>
    <TD></TD>
</TR>                    
<TR>
    <TD height="10" colspan="3"></TD>
</TR>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<script type="text/javascript" src="/js/selectDateTime.js"></script>
</HTML>

<script language="javaScript">
	var ptu = null;
	var iRowIndex = null;
	var RowindexNum = null;
	
	function init_ptu() {
		    iRowIndex = document.getElementById("task_iRowIndex").value;
		    RowindexNum = document.getElementById("task_RowindexNum").value;
	}
	
    function doSave(obj){
	   	if(!check_form(frmEdit,'txtTempletName,txtPrjType')) return false;
	   	var strValue="";
	   	var chkFields = '<%=chkFields%>';
	   	if(chkFields!=null && chkFields!=''){
	   		str = chkFields.split(",");
	   		for(var j=0; j<str.length; j++){
	   			strValue = str[j];
	   			if(!check_form(frmEdit,'txtTempletName,txtPrjType,'+strValue)) return false;
	   		}
	   	}
		myBody.onbeforeunload=null;
 		obj.disabled = true;
 		var xmlDoc=document.createElement("rootTask");

 		var docDom=generaDomJson();
	 	$.toXml(docDom,xmlDoc);
	    document.getElementById("areaLinkXml").value= "<rootTask>"+ $(xmlDoc).html().replace(/\"\s/g,"\"").replace(/\s\"/g,"\"")+"</rootTask>";
 		frmEdit.submit();
    }


   //初始化前置任务值
   function init_beforTaskStr() {
	   try {
	 	   	var taskArr = new Array();
	 	   	var txtTaskNames = document.getElementsByName("txtTaskName");
	 	   	for (i=1;i<=txtTaskNames.length;i++){
	 	   		taskArr[i-1] = txtTaskNames[i-1].value;
	 	   	}
	 	   	var seleBeforeTasks = document.getElementsByName("seleBeforeTask");
	 	   	for (i=1;i<=seleBeforeTasks.length;i++){
		 	   	try {
	 	   			if(seleBeforeTasks[i-1].value!='' && seleBeforeTasks[i-1].value!='0') {
	 	   				document.getElementById('seleBeforeTaskSpan_'+i).innerHTML = taskArr[document.getElementById('templetTaskId_'+seleBeforeTasks[i-1].value).value];
	 	   				seleBeforeTasks[i-1].value = document.getElementById('templetTaskId_'+seleBeforeTasks[i-1].value).value*1+1;
	 	   			}
		 	   	}catch(e){
		 	   		seleBeforeTasks[i-1].value;
			 	}
	 	   	}
	   }catch(e){}
    }


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
   	    ajax.open("POST", "ProjTempletEditData.jsp?templetId=<%=templetId%>", true);
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
   	   	            alert("=========================================");
   	            	alert(e.description);
   	                return false;
   	            }
   	        }
   	    }
   	}
   	showdata();
</script>

<script type="text/javascript">
<!--
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
}

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

//项目类型
function onShowPrjTypeID(txtObj,spanObj,spanImgObj,method,templetId){   
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp?sqlwhere=Where wfid<>0 ")
	if (datas){
        if(datas.id){
            spanObj.innerHtml = datas.name
            txtObj.value=datas.id
			if (method=="add"){
				location = "ProjTempletAdd.jsp?txtPrjType="+datas.id;
			}else{
				location = "ProjTempletEdit.jsp?txtPrjType="+datas.id+"&templetId="+templetId
			}
			$(spanImgObj).html("");
        } else {
            $(spanObj).html("");           
			$(spanImgObj).html("<IMG src='/images/BacoError.gif' align='absMiddle'>");
            $(txtObj).val("");
        }
	}
}
//-->
</script>
