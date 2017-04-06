<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.AttachFileUtil"%>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
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
   </HEAD>

<%  
    //判断是否具有项目编码的维护权限
    boolean canMaint = false ;
    if (HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {       
        canMaint = true ;
    }
    

    String imagefilename = "/images/sales.gif";
	String titlename = SystemEnv.getHtmlLabelName(18375,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(367,user.getLanguage());
	String needfav ="1";
	String needhelp ="";//取得相应设置的值

    
    /*为了兼容项目自定义字段*/
    boolean hasFF = true;
    RecordSetFF.executeProc("Base_FreeField_Select","p1");
    if(RecordSetFF.getCounts()<=0)
        hasFF = false;
    else
        RecordSetFF.first(); 

    String projTypeId = request.getParameter("txtPrjType");
    int scopid = Util.getIntValue(projTypeId) ;
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

 
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    if (canMaint) {      
        RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='ProjTempletEdit.jsp?templetId="+templetId+"',_self} " ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del(),_self} " ;
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
    String  templetName = "";
    String  templetDesc = "";
    int  proTypeId = -1;
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
    String  strSql = "select * from Prj_Template where id="+templetId;      
    RecordSet.executeSql(strSql);
    if (RecordSet.next()){
        templetName = Util.null2String(RecordSet.getString("templetName"));
        templetDesc = Util.null2String(RecordSet.getString("templetDesc"));
        proTypeId = Util.getIntValue(RecordSet.getString("proTypeId"));
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
    }
%>
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
        <Form name="frmAdd" action="ProjTempletOperate.jsp">
        <input type="hidden" name="method" value="add">
         <TABLE class=Shadow >
            <TR>
                <TD valign="top">
                    <!--模板基本信息-->
                    <TABLE  CLASS="viewForm"  valign="top">
                        <TR CLASS="title">
                            <TH  WIDTH="80%"><%=SystemEnv.getHtmlLabelName(18625,user.getLanguage())%></TH>
                            <TD WIDTH="20%">
                                <div align="right">
                                    <img src="/images/up.jpg" style="cursor:hand" onclick="onHiddenImgClick(divMainInfo,this)" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" objStatus="show">
                                <div>
                            </TD>
                         </TR>
                        <TR  style="height:1px;">
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
                                        <%=templetName%>
                                    </TD>
                                    <TD></TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <%=templetDesc%>
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
                                        </colgroup>                  
                                        <TR CLASS="title"><TH colspan="2"><%=SystemEnv.getHtmlLabelName(18625,user.getLanguage())%></TH></TR>
                                        <TR  style="height:1px;"><TD CLASS="line1" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <a href="/proj/Maint/EditProjectType.jsp?id=<%=proTypeId%>"><%=ProjectTypeComInfo.getProjectTypename(""+proTypeId)%></a>
                                            </TD>                                                      
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <a href="/proj/Maint/EditWorkType.jsp?id=<%=workTypeId%>"><%=WorkTypeComInfo.getWorkTypename(workTypeId)%></a> 
                                            </TD>                                                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(18628,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <%=ProjTempletUtil.getMemberNames(proMember)%>
                                            </TD>                                                       
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(624,user.getLanguage())%></TD>
                                            <TD class="field">
                                                 <%
                                                    if ("1".equals(isMemberSee)) out.println("<img src='/images/BacoCheck.gif'>");
                                                    else out.println("<img src='/images/BacoCross.gif'>");
                                                %>                                             
                                            </TD>                                                            
                                        </TR>  
                                         <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
                                            <TD class="field">
                                               <%=ProjTempletUtil.getCrmNames(proCrm)%> 
                                            </TD>                                                              
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>
                                            <TD><%=SystemEnv.getHtmlLabelName(15263,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <%
                                                    if ("1".equals(isCrmSee)) out.println("<img src='/images/BacoCheck.gif'>");
                                                    else out.println("<img src='/images/BacoCross.gif'>");
                                                %>
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
                                        <TR  style="height:1px;"><TD CLASS="line1" colspan="2"></TD></TR>
                                        <TR>                                        
                                            <TD><%=SystemEnv.getHtmlLabelName(636,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <a href="/proj/data/ViewProject.jsp?ProjID=<%=parentProId%>"><%=ProjectInfoComInfo.getProjectInfoname(parentProId)%></a>
                                            </TD>                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(637,user.getLanguage())%></TD>
                                            <TD class="field">
											<%if(!commentDoc.equals("")){%>
                                                <a href="/docs/docs/DocDsp.jsp?id=<%=commentDoc%>"><%=DocComInfo.getDocname(commentDoc)%></a>
                                            <%}%>
											</TD>                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(638,user.getLanguage())%></TD>
                                            <TD class="field">
                                                 <%if(!confirmDoc.equals("")){%>
                                                <a href="/docs/docs/DocDsp.jsp?id=<%=confirmDoc%>"><%=DocComInfo.getDocname(confirmDoc)%></a>
                                                <%}%>
											</TD>                           
                                        </TR>
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(639,user.getLanguage())%></TD>
                                            <TD class="field"> 
											<%if(!adviceDoc.equals("")){%>
                                                <a href="/docs/docs/DocDsp.jsp?id=<%=adviceDoc%>"><%=DocComInfo.getDocname(adviceDoc)%></a>
                                            <%}%>
											</TD>                           
                                        </TR>  
                                        <TR style="height:1px;"><TD CLASS="Line" colspan="2"></TD></TR>
                                        <TR>                                            
                                            <TD><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
                                            <TD class="field">
                                                <a href="/hrm/resource/HrmResource.jsp?id=<%=Manager%>"><%=ResourceComInfo.getLastname(Manager)%></a>
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
                                    <img src="/images/up.jpg" style="cursor:hand" onclick="onHiddenImgClick(divCustomInfo,this)" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" objStatus="show">
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
                                          <TD><%=RecordSetFF.getString(i*2)%></TD>
                                          <TD class=Field><%=RecordSet.getString("datefield"+i)%></TD>
                                        </TR>
                                            <TR class=spacing style="height:1px;">
                                          <TD class=line colSpan=2></TD></TR>
                                        <%}
                                    }
                                    for(int i=1;i<=5;i++)
                                    {
                                        if(RecordSetFF.getString(i*2+11).equals("1"))
                                        {%>
                                        <TR>
                                          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
                                          <TD class=Field><%=RecordSet.getString("numberfield"+i)%></TD>
                                        </TR>
                                          <TR class=spacing style="height:1px;">
                                          <TD class=line colSpan=2></TD></TR>
                                        <%}
                                    }
                                    for(int i=1;i<=5;i++)
                                    {
                                        if(RecordSetFF.getString(i*2+21).equals("1"))
                                        {%>
                                        <TR>
                                          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
                                          <TD class=Field><%=RecordSet.getString("textfield"+i)%></TD>
                                        </TR>  <TR class=spacing style="height:1px;">
                                          <TD class=line colSpan=2></TD></TR>
                                        <%}
                                    }
                                    for(int i=1;i<=5;i++)
                                    {
                                        if(RecordSetFF.getString(i*2+31).equals("1"))
                                        {%>
                                        <TR>
                                          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
                                          <TD class=Field>
                                          <INPUT type=checkbox  value=1 <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked <%}%> disabled >
                                          </TD>
                                        </TR>  <TR class=spacing style="height:1px;">
                                          <TD class=line colSpan=2></TD></TR>
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
                                        <TABLE class=ViewForm  valign="top">
                                          <COLGROUP>
                                          <COL width="30%">
                                          <COL width="70%">
                                          </COLGROUP>
                                        <%
                                            CustomFieldManager cfm = new CustomFieldManager("ProjCustomField",proTypeId);
                                            cfm.getCustomFields();
                                            cfm.getCustomData(templetId);
                                            while(cfm.next()){
                                                String fieldvalue = "";
                                                if(cfm.getHtmlType().equals("2")){
                                                	fieldvalue = Util.null2String(cfm.getData("field"+cfm.getId()));
                                                }else{
                                                	fieldvalue = Util.toHtml(cfm.getData("field"+cfm.getId()));
                                                }
                                        %>
                                            <tr>
                                              <td <%if(cfm.getHtmlType().equals("2")){%> valign=top <%}%>> <%=cfm.getLable()%> </td>
                                              <td class=field >
                                              <%
                                                if(cfm.getHtmlType().equals("1")||cfm.getHtmlType().equals("2")){
                                              %>
                                              <%=fieldvalue%>
                                              <%
                                                }else if(cfm.getHtmlType().equals("3")){

                                                    String fieldtype = String.valueOf(cfm.getType());
                                                    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                                                    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                                                    String showname = "";                                   // 新建时候默认值显示的名称
                                                    String showid = "";                                     // 新建时候默认值


                                                    if(fieldtype.equals("2") ||fieldtype.equals("19")){
                                                        showname=fieldvalue; // 日期时间
                                                    }else if(!fieldvalue.equals("")) {
                                                        String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                                                        String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                                                        String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                                                        String sql = "";

                                                        HashMap temRes = new HashMap();
                                                        if(fieldvalue.startsWith(",")){
															fieldvalue = fieldvalue.substring(1);
														}
                                                        if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65") ||fieldtype.equals("152")|| fieldtype.equals("135")) {    // 多人力资源,多客户,多会议，多文档
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
                                                <span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%></span>
                                               <%
                                                }else if(cfm.getHtmlType().equals("4")){
                                               %>
                                                <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> disabled >
                                               <%
                                                }else if(cfm.getHtmlType().equals("5")){
                                                    cfm.getSelectItem(cfm.getId());
                                               %>
                                               <%
                                                    while(cfm.nextSelect()){
                                                        if(cfm.getSelectValue().equals(fieldvalue)){
                                               %>
                                                    <%=cfm.getSelectName()%>
                                               <%
                                                            break;
                                                        }
                                                    }
                                               %>
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
</HTML>


<script language="javaScript">
 function onHiddenImgClick(divObj,imgObj){
     if (imgObj.objStatus=="show"){
        divObj.style.display='none' ;       
        imgObj.src="/images/down.jpg";
        imgObj.title="<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>";
        imgObj.objStatus="hidden";
     } else {        
        divObj.style.display='' ;    
        imgObj.src="/images/up.jpg";
        imgObj.title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";
       imgObj.objStatus="show";      
     }
 }
 function del(){
 if(confirm("<%=SystemEnv.getHtmlLabelName(20903,user.getLanguage())%>"))
   window.location.href="ProjTempletOperate.jsp?method=delete&templetId=<%=templetId%>";
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
	    ajax.open("POST", "ProjTempletViewData.jsp?templetId=<%=templetId%>", true);
	    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	    ajax.send(null);
	    //获取执行状态
	    ajax.onreadystatechange = function() {
	        //如果执行状态成功，那么就把返回信息写到指定的层里
	        if (ajax.readyState == 4 && ajax.status == 200) {
	            try{
	                document.getElementById('TaskDataDIV').innerHTML = ajax.responseText;
	            }catch(e){
	            	alert(e.description);
	                return false;
	            }
	        }
	    }
	}
	showdata();
</script>


