<%@ page language="java" contentType="text/html; charset=GBK" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%@ include file="/systeminfo/init.jsp" %>

<HTML>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21569,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
%>
    <HEAD>
        <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver.js"></script>
    </HEAD>
<BODY>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    int docPropId=Util.getIntValue(request.getParameter("docPropId"),-1);
    int workflowId=Util.getIntValue(request.getParameter("wfid"),-1);
    String pathCategory = "";
    int secCategoryId=0;
	String wfdocpath = "";
	String wfdocpathspan="";
	String wfdocownertype = "";
	String wfdocownerfieldid = "";
	String wfdocowner="";
	String wfdocownerspan="";
	int keepsign = 0;

	rs.executeSql("select * from workflow_base where id = " + workflowId);
	rs.next();
	wfdocowner = rs.getString("wfdocowner");
	wfdocownerspan = ResourceComInfo.getLastname(wfdocowner);
	wfdocownertype = rs.getString("wfdocownertype");
	wfdocownerfieldid = rs.getString("wfdocownerfieldid");
	keepsign = rs.getInt("keepsign");
	wfdocpath = rs.getString("wfdocpath");
	String wfdocpaths[] = Util.TokenizerString2(wfdocpath,",");
	if(wfdocpaths.length==3) secCategoryId = Util.getIntValue(wfdocpaths[2],-1);
	
    String formID = WorkflowComInfo.getFormId(""+workflowId);
    String isbill = WorkflowComInfo.getIsBill(""+workflowId);
	if(!"1".equals(isbill)){
		isbill="0";
	}

	if(pathCategory.equals("")&&secCategoryId>0){
		String innerSecCategory = String.valueOf(secCategoryId);
		String innerSubCategory = SecCategoryComInfo.getSubCategoryid(innerSecCategory);
		String innerMainCategory = SubCategoryComInfo.getMainCategoryid(innerSubCategory);
	    pathCategory = "/" + MainCategoryComInfo.getMainCategoryname(innerMainCategory) + "/" + SubCategoryComInfo.getSubCategoryname(innerSubCategory) + "/" + SecCategoryComInfo.getSecCategoryname(innerSecCategory);     
	    pathCategory = pathCategory.replaceAll("<", "＜").replaceAll(">", "＞").replaceAll("&lt;", "＜").replaceAll("&gt;", "＞");
	    wfdocpathspan = pathCategory;
	}

    if(docPropId<=0){
	    RecordSet.executeSql("select id from  WorkflowToDocProp where workflowId="+workflowId+" and secCategoryid="+secCategoryId);
	    if(RecordSet.next()){
		    docPropId=Util.getIntValue(RecordSet.getString("id"),0);
	    }
	}


	
%>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveCreateDocumentByAction(this),_self}";
    RCMenuHeight += RCMenuHeightStep;      
%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>

<%

    int operateLevel = 0;
    if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
        operateLevel=2;
    }

    if(operateLevel > 0){
        /*================ 下拉框信息 ================*/
        List formDictIDList = new ArrayList();
        List formDictLabelList = new ArrayList();
		String SQL = null;
		if("1".equals(isbill)){
			SQL = "select formField.id,fieldLable.labelName as fieldLable "
                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                    + "where fieldLable.indexId=formField.fieldLabel "
                    + "  and formField.billId= " + formID
                    + "  and formField.viewType=0 "
                    + "  and fieldLable.languageid =" + user.getLanguage()
                    + "  order by formField.dspOrder  asc ";
		}else{			
			SQL = "select formDict.ID, fieldLable.fieldLable "
                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                    + "and formField.formid = " + formID
                    + "and fieldLable.langurageid = " + user.getLanguage()
                    + " order by formField.fieldorder";
		}                      
        RecordSet.executeSql(SQL);
        
        while(RecordSet.next()){
            formDictIDList.add(RecordSet.getString("ID"));
            formDictLabelList.add(RecordSet.getString("fieldLable"));
        }        

%>

<FORM name="CreateDocumentByAction" method="post" action="CreateDocumentByActionOperation.jsp" >

    <TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <COLGROUP>
            <COL width="10">
            <COL width="">
            <COL width="10">
        <TR>
            <TD height="10" colspan="3"></TD>
        </TR>
        <TR>
            <TD ></TD>
            <TD valign="top">
                <TABLE class=Shadow>
                    <TR>
                        <TD valign="top">                            

							<TABLE class="viewform">  
                                <COL width="30%">
					            <COL width="70%">
                                <TR class="Title">
                                    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16484,user.getLanguage())%></TH>
                                </TR>
								<TR class="Spacing" style="height:1px;">
								<TD class="Line1" colSpan=2></TD></TR>
							<!--add by cwj 流程存为文档 -->
								<tr>
								    <td><%=SystemEnv.getHtmlLabelName(22220,user.getLanguage())%></td>
								    <td class=field>
									    <button type="button"  class=Browser id=selectwfdocpath onClick="onShowWfCatalog(wfdocpathspan)" name=selectwfdocpath></BUTTON>
									    <span id="wfdocpathspan"><%=wfdocpathspan%></span>
								    </td>
								</tr>    
								<TR class="Spacing" style="height:1px;">
								<TD class="Line" colSpan=2></TD></TR>
							<!-- end -->
					
							<!--add by cwj 流程存为文档的所有者 -->
								<tr>
								    <td><%=SystemEnv.getHtmlLabelName(22221,user.getLanguage())%></td>
							    	<td class=field>
										<select id="wfdocownertype" name="wfdocownertype" onchange="onchangewfdocownertype(this.value)">
										<option value="0"></option>
										<option value="1" <%if("1".equals(wfdocownertype)){out.println("selected");}%> ><%=SystemEnv.getHtmlLabelName(23122,user.getLanguage())%></option>
										<option value="2" <%if("2".equals(wfdocownertype)){out.println("selected");}%> ><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%></option>
									</select>&nbsp;
							    	<button type="button"  class="Browser" id="selectwfdocowner" name="selectwfdocowner" style="display:<%if(!"1".equals(wfdocownertype)){out.println("none");}%>" onClick="onShowWfDocOwner('wfdocownerspan','wfdocowner','0')"></BUTTON>
							    	<span id="wfdocownerspan" style="display:<%if(!"1".equals(wfdocownertype)){out.println("none");}%>"><a href="javaScript:openhrm(<%=wfdocowner%>);" onclick='pointerXY(event);'><%=wfdocownerspan%></a></span>
									<select id="wfdocownerfieldid" name="wfdocownerfieldid" style="display:<%if(!"2".equals(wfdocownertype)){out.println("none");}%>">
										<%
										String sql_tmp = "";
										if("1".equals(isbill)){
											sql_tmp = "select formField.id,fieldLable.labelName as fieldLable "
								                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
								                    + "where fieldLable.indexId=formField.fieldLabel "
								                    + "  and formField.billId= " + formID
								                    + "  and formField.viewType=0 "
								                    + "  and fieldLable.languageid =" + user.getLanguage()
								                    + " and formField.fieldHtmlType='3' and formField.type in (1,17,160,165,166) order by formField.id";
										}else{
											sql_tmp = "select formDict.id, fieldLable.fieldLable "
								                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
								                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
								                    + "and formField.formid = " + formID
								                    + " and fieldLable.langurageid = " + user.getLanguage()
								                    + " and formDict.fieldHtmlType='3' and formDict.type in (1,17,160,165,166) order by formDict.id";
										}
										RecordSet.executeSql(sql_tmp);
										while(RecordSet.next()){
											String fieldid_tmp = Util.null2String(RecordSet.getString("id"));
											String fieldlabel_tmp = Util.null2String(RecordSet.getString("fieldLable"));
											String selectedStr = "";
											if(!"".equals(wfdocownerfieldid) && fieldid_tmp.equals(wfdocownerfieldid)){
												selectedStr = " selected ";
											}
											out.println("<option value=\""+fieldid_tmp+"\" "+selectedStr+">"+fieldlabel_tmp+"</option>\n");
										}%>
									</select>
						    		</td>
								</tr>    
								<TR class="Spacing" style="height:1px;">
								<TD class="Line" colSpan=2></TD></TR>
								<!-- end -->
				
								<!--add by cwj 流程存为文档 -->
								<tr>
								    <td><%=SystemEnv.getHtmlLabelName(24568,user.getLanguage())%></td>
								    <td class=field>
										<select id=keepsign name=keepsign>
											<OPTION value="1" <%if(keepsign==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></OPTION>
											<OPTION value="2" <%if(keepsign==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></OPTION>
										</select>
								    </td>
								</tr>    
								<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
							<!-- end -->
							</table>                            
		                            <!--================== 文档属性页设置 ==================-->
                            <TABLE class="viewform">                           
                                <TR class="Title">
                                    <TH><%=SystemEnv.getHtmlLabelName(21569,user.getLanguage())%></TH>
                                </TR>
                                <TR class="Spacing" style="height:1px;">
                                    <TD class="Line1" colspan="2"></TD>
                                </TR>
                            </TABLE>
                            <TABLE class="liststyle">
                                <COLGROUP>
                                   <COL width="30%">
                                   <COL width="*">    
                                <TR class="header">
                                    <TD><%=SystemEnv.getHtmlLabelName(21570,user.getLanguage())%></TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></TD>
                                </TR>
                            <%
								List docPropertyTypeExceptList=new ArrayList();//某些文档属性不能通过流程属性获得。
							    docPropertyTypeExceptList.add("6");  //6 主目录
							    docPropertyTypeExceptList.add("7");  //7 分目录
							    docPropertyTypeExceptList.add("8");  //8 子目录
							    docPropertyTypeExceptList.add("10"); //10 模版
							    docPropertyTypeExceptList.add("11"); //11 语言
							    docPropertyTypeExceptList.add("13"); //13 创建
							    docPropertyTypeExceptList.add("14"); //14 修改
							    docPropertyTypeExceptList.add("15"); //15 批准
							    docPropertyTypeExceptList.add("16"); //16 失效
							    docPropertyTypeExceptList.add("17"); //17 归档
							    docPropertyTypeExceptList.add("18"); //18 作废
							    docPropertyTypeExceptList.add("20"); //20 被引用列表
							    docPropertyTypeExceptList.add("24"); //24 虚拟目录

								int docPropDetailId=-1;
							    int docPropFieldId=-1;
								int workflowFieldId=-1;

								int labelId = 0;
								String customName = null;
								int isCustom = 0;
								String docPropertyType=null;
								String docPropFieldName = null;

                                SecCategoryDocPropertiesComInfo.addDefaultDocProperties(secCategoryId);
                                int i = 0;
								StringBuffer sb=new StringBuffer();
								sb.append(" select a.id as docPropFieldId,a.labelId,a.customName,a.isCustom,a.type as docPropertyType,b.id as docPropDetailId,b.workflowFieldId ")
								  .append("   from DocSecCategoryDocProperty a left join (select * from WorkflowToDocPropDetail where docPropId=").append(docPropId).append(")b on a.id=b.docPropFieldId ")
								  .append("  where a.secCategoryId =").append(secCategoryId)
								  .append("  order by a.viewindex asc ")
								;
                                RecordSet.executeSql(sb.toString());

                                while(RecordSet.next()&&secCategoryId>0){
                                    docPropDetailId = Util.getIntValue(RecordSet.getString("docPropDetailId"),-1);
                                    docPropFieldId = Util.getIntValue(RecordSet.getString("docPropFieldId"),-1);
                                    workflowFieldId = Util.getIntValue(RecordSet.getString("workflowFieldId"),-1);

                                    labelId = RecordSet.getInt("labelid");
                                    customName = Util.null2String(RecordSet.getString("customname"));
                                    isCustom = RecordSet.getInt("isCustom");
                                    if(isCustom==1){
                                    	docPropFieldName = customName;
                                    }else{
                                    	if(customName!=null&&!"".equals(customName)){
                                    		docPropFieldName = customName;
                                    	}else{
                                    		docPropFieldName = SystemEnv.getHtmlLabelName(labelId, user.getLanguage());
										}
									}
                                    docPropertyType = Util.null2String(RecordSet.getString("docPropertyType"));
									if(docPropertyTypeExceptList.indexOf(docPropertyType)>=0){
										continue;
									}

                            %>
								    <INPUT TYPE="hidden" NAME="docPropDetailId_<%= i %>" VALUE="<%= docPropDetailId %>">
								    <INPUT TYPE="hidden" NAME="docPropFieldId_<%= i %>" VALUE="<%= docPropFieldId %>">
                                    <TR class=<% if(0 == i % 2) {%> DataDark <% } else { %> DataLight <% } %>>
                                        <TD><%=docPropFieldName%></TD>
                                        <TD>
                                            <SELECT class=inputstyle name="workflowFieldId_<%= i %>">
                                                <OPTION value=-1></OPTION>
											    <option value=-3  <%if ("-3".equals(""+workflowFieldId)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>

                            <%
                                            for(int j = 0; j < formDictIDList.size(); j++){
                            %>                   
                                                <OPTION value=<%= (String)formDictIDList.get(j) %>  <% if(((String)formDictIDList.get(j)).equals(""+workflowFieldId)) { %> selected <% } %>   ><%= (String)formDictLabelList.get(j) %></OPTION>
                            <%
                                            }
                            %>                         
                                            </SELECT>
                                        </TD>
                                    </TR>
                            <%
                                    i++;
                                }
                            %>
                                <TR>
                                    <TD height="10" colspan="3"></TD>
                                </TR>
                            </TABLE>                                                            
                        </TD>
                        <TD></TD>
                    </TR>
                    <TR>
                        <TD height="10" colspan="3"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
	<INPUT type=hidden id='wfdocowner' name='wfdocowner' value="<%=wfdocowner%>">
    <INPUT TYPE="hidden" NAME="wfdocpath" VALUE="<%= wfdocpath %>">    
    <INPUT TYPE="hidden" NAME="docPropId" VALUE="<%= docPropId %>">
    <INPUT TYPE="hidden" NAME="workflowId" VALUE="<%= workflowId %>">
    <INPUT TYPE="hidden" NAME="secCategoryId" VALUE="<%= secCategoryId %>">
    <INPUT TYPE="hidden" NAME="ajax" VALUE="<%= ajax %>">
    <INPUT TYPE="hidden" NAME="rowNum" VALUE="<%=i%>">
</FORM>
<%
    }
    else
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>
</BODY>
</HTML>