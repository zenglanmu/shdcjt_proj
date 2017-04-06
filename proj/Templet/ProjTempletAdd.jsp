<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.net.*" %>

<jsp:useBean id="ProjCodeParaBean" class="weaver.proj.form.ProjCodeParaBean" scope="page"/>
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />

<HTML>
	<HEAD>
	    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/weaver.js"></SCRIPT>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList.js"></SCRIPT>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/TaskUtil.js"></SCRIPT>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTaskUtil.js"></SCRIPT>
        <SCRIPT language="javascript"  type='text/javascript'src="/js/projTask/TaskNodeXmlDoc.js"></SCRIPT>
        <SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/TaskDrag.js"></SCRIPT>  
        <SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTask.js"></SCRIPT>   
        
        <script type="text/javascript" src="/js/projTask/temp/prjTask.js"></script>
		<script type="text/javascript" src="/js/projTask/temp/jquery.z4x.js"></script>
		<script type="text/javascript" src="/js/projTask/temp/ProjectAddTaskI2.js"></script>
   </HEAD>

<%  
    String URLFrom = URLEncoder.encode(Util.null2String(request.getParameter("URLFrom")));
    
    //判断是否具有项目编码的维护权限
    if (!HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {
        response.sendRedirect("/notice/noright.jsp") ; 
    }
    

    String imagefilename = "/images/sales.gif";
	String titlename = SystemEnv.getHtmlLabelName(18375,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(82,user.getLanguage());
	String needfav ="1";
	String needhelp ="";//取得相应设置的值

    
    /*为了兼容项目自定义字段*/
    boolean hasFF = true;
    RecordSetFF.executeProc("Base_FreeField_Select","p1");
    if(RecordSetFF.getCounts()<=0)
        hasFF = false;
    else
        RecordSetFF.first(); 

    String projTypeId = Util.null2String(request.getParameter("txtPrjType"));
    int scopid = Util.getIntValue(projTypeId) ;
    String  prjid ="";
    String  crmid="";
    String  hrmid="";
    String docid="";
    String needinputitems = "";
   /*END*/
%>
<BODY id="myBody" >
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(320,user.getLanguage())+",javascript:location='ProjTempletList.jsp',_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
</COLGROUP>
<TR>
    <TD height="10" colspan="3"></TD>
</TR> 
<TR>
    <TD></TD>
    <TD valign="top">
        <Form name="frmAdd" method="post" action="ProjTempletOperate.jsp">
        <input type="hidden" name="method" value="add">
        <input type="hidden" name="URLFrom" value="<%=URLFrom%>">        
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
                        <TD CLASS="line1" colspan="2" ></TD></TR>                
                     </TABLE>
                      <div id="divMainInfo">
                            <TABLE CLASS="viewForm" valign="top" >
                                <colgroup>
                                <col width="15%">
                                <col width="30%">
                                <col width="10%">
                                <col width="15%">
                                <col width="30%">   
                                </colgroup>              
                                <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <INPUT TYPE="text" NAME="txtTempletName" class="inputStyle" onchange="checkinput('txtTempletName','spanTempletName')"> 
                                        <span id=spanTempletName><IMG src="/images/BacoError.gif" align=absMiddle></span>
                                    </TD>
                                    <TD></TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%></TD>
                                    <TD class="field"><INPUT TYPE="text" NAME="txtTempletDesc" class="inputStyle"></TD>                           
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
                                        </colgroup>                    
                                        <TR CLASS="title"><TH colspan="2"><%=SystemEnv.getHtmlLabelName(18625,user.getLanguage())%></TH></TR>
                                        <TR style="height:1px;"><TD CLASS="line1" colspan="2"></TD></TR>
                                        <TR>
                                        <TD><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TD>
                                            <TD class="field">
                                            	<INPUT id=txtPrjType class="wuiBrowser" type="hidden" name="txtPrjType" value="<%=projTypeId%>" 
              											_url="/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp?sqlwhere=Where wfid<>0" 
              											_param="" _required="yes" _displayText="<%=ProjectTypeComInfo.getProjectTypename(""+projTypeId) %>"
              											> 
                                            </TD>                                                      
                                        </TR>
                                        <TR  style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TD>
                                            <TD class="field">
                                              <INPUT id=txtWorkType class="wuiBrowser" type=hidden name=txtWorkType value="" 
                                                	_url="/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp">   
                                            
                                            </TD>                                                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(18628,user.getLanguage())%></TD>
                                            <TD class="field">
                                               
                                            <input type=hidden name="hrmids02" class="wuiBrowser" id ="hrmids02" 
										_param="resourceids" _displayTemplate="<a href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</a>&nbsp"
										_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp">
                                           
                                            </TD>                                                       
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(624,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <input class="inputStyle" type="checkbox" name="isMemberShow" value="1">
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
                                                <input class="inputStyle" type="checkbox" name="isCrmShow" value="1">
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
                                      </colgroup>
                                        <TR CLASS="title"><TH colspan="2"><%=SystemEnv.getHtmlLabelName(633,user.getLanguage())%></TH></TR>
                                        <TR style="height:1px;"><TD CLASS="line1" colspan="2"></TD></TR>
                                        <TR>                                        
                                            <TD><%=SystemEnv.getHtmlLabelName(636,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <input type="hidden" class="wuiBrowser" id="txtParentId"   name="txtParentId" 
                                                	_displayTemplate="<a href='/proj/data/ViewProject.jsp?ProjID=#b{id}'>#b{name}</a>"
                                                	_url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" 
                                                	>
                                            </TD>                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(637,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <INPUT  type=hidden class="wuiBrowser" name="txtEnvDoc" id="txtEnvDoc" 
                                                	_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>"
                                                	_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp">  
                                            
                                            </TD>                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(638,user.getLanguage())%></TD>
                                            <TD class="field">
                                                 <INPUT  type=hidden class="wuiBrowser" name="txtConDoc" id="txtConDoc" 
                                                	_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>"
                                                	_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"> 
                                            </TD>                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(639,user.getLanguage())%></TD>
                                            <TD class="field">                          
                                                 <INPUT  type=hidden class="wuiBrowser" name="txtAdviceDoc" id="txtAdviceDoc" 
                                                	_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>"
                                                	_url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp">
                                            </TD>                           
                                        </TR>  
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
                                            <TD class="field">
                                                 <INPUT type=hidden class="wuiBrowser" name="txtPrjManager" id="txtPrjManager" 
                                                	_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
                                                	_url=" /systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
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
                        </colgroup>           
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
                            <TR valign="top">
                                <TD valign="top">
                                    <!--自定义字段部分 A 项目自定义字段部分-->
                                    <%if(hasFF){%>                         
                                      <TABLE class=viewForm   valign="top">
                                        <colgroup>
                                        <col width="30%">              
                                        <col width="70%">  
                                        <TBODY>                                                   
                                            <%
                                                for(int i=1;i<=5;i++)
                                                {
                                                    if(RecordSetFF.getString(i*2+1).equals("1"))
                                                    {%>
                                                    <TR>
                                                      <TD><%=Util.toScreen(RecordSetFF.getString(i*2),user.getLanguage())%></TD>
                                                      <TD class=Field><button type="button" class=Calendar onclick="getProjdate(<%=i%>)"></BUTTON> 
                                                          <SPAN id=datespan<%=i%> ></SPAN> 
                                                          <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>"></TD>
                                                    </TR><tr style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                                                    <%}
                                                }
                                                for(int i=1;i<=5;i++)
                                                {
                                                    if(RecordSetFF.getString(i*2+11).equals("1"))
                                                    {%>
                                                    <TR>
                                                      <TD><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></TD>
                                                      <TD class=Field><INPUT class=inputstyle maxLength=30 size=30 name="nff0<%=i%>" value="0.0"></TD>
                                                    </TR><tr  style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                                                    <%}
                                                }
                                                for(int i=1;i<=5;i++)
                                                {
                                                    if(RecordSetFF.getString(i*2+21).equals("1"))
                                                    {%>
                                                    <TR>
                                                      <TD><%=Util.toScreen(RecordSetFF.getString(i*2+20),user.getLanguage())%></TD>
                                                      <TD class=Field><INPUT class=inputstyle maxLength=100 size=30 name="tff0<%=i%>"></TD>
                                                    </TR><tr style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                                                    <%}
                                                }
                                                for(int i=1;i<=5;i++)
                                                {
                                                    if(RecordSetFF.getString(i*2+31).equals("1"))
                                                    {%>
                                                    <TR>
                                                      <TD><%=RecordSetFF.getString(i*2+30)%></TD>
                                                      <TD class=Field>
                                                      <INPUT type=checkbox  name="bff0<%=i%>" value="1">
                                                      </TD>                                                    
                                                    <%}
                                                }
                                            %>
                                             <TR  style="height:1px;"><TD  CLASS="line" colspan="2"></TD></TR>
                                            </TBODY>
                                          </TABLE>
                                      <%}%>
                                </TD>

                                <TD>
                                </TD>

                                <TD valign="top">
                                    <!--自定义字段部分 B 项目类型自定义字段部分,scopid为新添加的表现形式的类型-->                                   
                                    <TABLE CLASS="viewForm" valign="top">
                                     <colgroup>
                                    <col width="30%">              
                                    <col width="70%">  
                                      <tbody>                                      
                                    <%                                       
                                        CustomFieldManager cfm = new CustomFieldManager("ProjCustomField",scopid);
                                        cfm.getCustomFields();
										String chkFields="";
                                        while(cfm.next()){
                                            if(cfm.isMand()){
                                                needinputitems += ",customfield"+cfm.getId();
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
                                            <input datatype="text" type=text class=Inputstyle name="customfield<%=cfm.getId()%>"  onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
                                            
                                          <%
                                                    }else{
                                          %>
                                            <input datatype="text" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" value="" >
                                          <%
                                                    }
                                                }else if(cfm.getType()==2){
                                                    if(cfm.isMand()){
												    chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input  datatype="int" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
                                                onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
                                            
                                          <%
                                                    }else{
                                          %>
                                          <input  datatype="int" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
                                          <%
                                                    }
                                                }else if(cfm.getType()==3){
                                                    if(cfm.isMand()){
													chkFields+="customfield"+cfm.getId()+",";
                                          %>
                                            <input datatype="float" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
                                                onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
                                            
                                          <%
                                                    }else{
                                          %>
                                            <input datatype="float" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
                                          <%
                                                    }
                                                }
                                            }else if(cfm.getHtmlType().equals("2")){
                                                if(cfm.isMand()){
												chkFields+="customfield"+cfm.getId()+",";

                                          %>
                                            <textarea class=Inputstyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')"
                                                rows="4" cols="40"  class=Inputstyle></textarea>
                                            
                                          <%
                                                }else{
                                          %>
                                            <textarea class=Inputstyle name="customfield<%=cfm.getId()%>" rows="4" cols="40" ></textarea>
                                          <%
                                                }
                                            }else if(cfm.getHtmlType().equals("3")){

                                                String fieldtype = String.valueOf(cfm.getType());
                                                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                                                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                                                String showname = "";                                   // 新建时候默认值显示的名称
                                                String showid = "";                                     // 新建时候默认值

                                                if(fieldtype.equals("8") && !prjid.equals("")){       //浏览按钮为项目,从前面的参数中获得项目默认值
                                                    showid = "" + Util.getIntValue(prjid,0);
                                                }else if((fieldtype.equals("9") || fieldtype.equals("37")) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值
                                                    showid = "" + Util.getIntValue(docid,0);
                                                }else if((fieldtype.equals("1") ||fieldtype.equals("17")) && !hrmid.equals("")){ //浏览按钮为人,从前面的参数中获得人默认值
                                                    showid = "" + Util.getIntValue(hrmid,0);
                                                }else if((fieldtype.equals("7") || fieldtype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值
                                                    showid = "" + Util.getIntValue(crmid,0);
                                                }else if(fieldtype.equals("4") && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                                                    showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
                                                }else if(fieldtype.equals("24") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                                                    showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
                                                }else if(fieldtype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                                                    showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
                                                }

                                                if(showid.equals("0")) showid = "" ;

                                                if(! showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                                                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
                                                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
                                                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
                                                    String sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;

                                                    RecordSet.executeSql(sql);
                                                    if(RecordSet.next()) {
                                                        if(!linkurl.equals(""))
                                                            showname = "<a href='"+linkurl+showid+"'>"+RecordSet.getString(1)+"</a>&nbsp";
                                                        else
                                                            showname =RecordSet.getString(1) ;
                                                    }
                                                }

                                                //获得当前的日期和时间
                                                Calendar today = Calendar.getInstance();
                                                String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                                                        Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                                                        Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

                                                String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                                                        Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                                                        Util.add0(today.get(Calendar.SECOND), 2) ;

                                                if(fieldtype.equals("2")){                              // 浏览按钮为日期
                                                    showname = currentdate;
                                                    showid = currentdate;
                                                }

                                           %>
                                            <button type="button" class=Browser onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
                                            <input type=hidden name="customfield<%=cfm.getId()%>" value="<%=showid%>">
                                           
                                           <%
                                            }else if(cfm.getHtmlType().equals("4")){
                                           %>
                                            <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" >
											
                                           <%
                                            }else if(cfm.getHtmlType().equals("5")){
                                            	chkFields+="customfield"+cfm.getId()+",";
                                                cfm.getSelectItem(cfm.getId());
                                           %>
                                           <select name="customfield<%=cfm.getId()%>" viewtype="<%if(cfm.isMand()){out.print("1");}else{out.print("0");}%>" class="InputStyle" onChange="checkinput2('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span',this)">
											<option value=""></option>
                                           <%
                                                while(cfm.nextSelect()){
                                           %>
                                                <option value="<%=cfm.getSelectValue()%>"><%=cfm.getSelectName()%></option>
                                           <%
                                                }
                                           %>
                                           </select>
											
                                           <%
                                            }
                                           %>
                                                </td>
                                            </tr>
                                              <TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                                           <%
                                        }
                                           %>   
                                          
                                          </tbody>                                            
                                     </table>
                                    <!--end   自定义字段-->
                                </TD>
                            </TR>
                     </TABLE>
                    </div> <!-- divCustomInfo End-->
                     <br>
                    <!--任务列表-->
                    <TABLE  CLASS="viewForm"  valign="top">
                        <TR CLASS="title">
                            <TH  WIDTH="80%"><%=SystemEnv.getHtmlLabelName(18505,user.getLanguage())%></TH>
                            <TD WIDTH="20%">
                                <div align="right">
                                    <span id="divAddAndDel">
                                        <a  style="cursor:pointer" onclick="addRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;
                                        <a  style="cursor:pointer" onclick="deleteRow()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>&nbsp;  
                                    </span>
                                    &nbsp;&nbsp;
                                    <img src="/images/up.jpg" style="cursor:pointer" onclick="onHiddenImgClick(divTaskList,this)" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" objStatus="show">
                                <div>
                            </TD>
                         </TR>
                        <TR style="height:1px;">
                        <TD CLASS="line1" colspan="2"></TD></TR>                
                     </TABLE>
                     <div>
                        <input type="hidden" onclick="getXmlDocStr1()" value="GetXmlDocStr">
                        <TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none"></TEXTAREA> 
                        <!--得到隐藏的层,等此form提交的时候不要忘了清除里的的数据-->   
                        <div id="divTaskList" style="display:''">
                        <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="tblTask" onmousedown="mousedown(event)"	onmouseup="mouseup(event)"	onmousemove="mousemove(event)">
                            <colgroup>
                            <col width="5%">
                            <col width="3%">
                            <col width="20%">
                            <col width="5%">
                            <col width="12%">                       
                            <col width="12%">
                            <col width="15%">
                            <col width="8%">
                            <col width="10%">
                            <col width="10%">   
                            </colgroup>                                                   
                            <TR class="Header">
                                <TD></TD>
                                <TD><input type="checkbox" onclick="javaScript:onCheckAll(this)" id="chkAllObj"></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>     
                                <TD><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(18506,user.getLanguage())%></TD>   
                            </TR>
                            <tr class="Line" style="height:1px;"><td colspan="10"></td></tr>                        
                        </TABLE>
                    </div> <!--divTaskList End-->                    

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
</table>
<script type="text/javaScript">
  //  var ptu = new ProjTaskUtil(); 
  	prjTaskObj={rootTask:{task:[]}};
    var iRowIndex = 0 ;    
    var RowindexNum=0;
    function doSave(obj){
     	if(!check_form(frmAdd,'txtTempletName,txtPrjType')) return false;
     	var strValue="";
     	var chkFields = '<%=chkFields%>';
     	if(chkFields!=null && chkFields!=''){
     		str = chkFields.split(",");
     		for(var j=0; j<str.length; j++){
     			strValue = str[j];
     			if(!check_form(frmAdd,'txtTempletName,txtPrjType')) return false;
     		}
     	}
		myBody.onbeforeunload=null;
   		obj.disabled = true;
   		var xmlDoc=document.createElement("rootTask");
   		var docDom=generaDomJson();
	 	$.toXml(docDom,xmlDoc);
   	    document.getElementById("areaLinkXml").value= "<rootTask>"+ $(xmlDoc).html().replace(/\"\s/g,"\"").replace(/\s\"/g,"\"")+"</rootTask>";
   		frmAdd.submit();
     }     
    window.onbeforeunload=function(e){
    	protectProjTemplet(e);
    }
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<script type="text/javascript" src="/js/selectDateTime.js"></script>
</HTML>




<script type="text/javascript">
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
</script>
