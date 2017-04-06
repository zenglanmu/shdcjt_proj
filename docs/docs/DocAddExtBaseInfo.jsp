<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>

<table class="viewform" id="docPropTable">
  <COLGROUP>
  <COL width="15%">
  <COL width="35%">
  <COL width="15%">
  <COL width="35%">
  </COLGROUP>
  <TBODY>

<script language=javascript>
				var docSelectIndex=0;
				function onChangeDocType(doPage,docType){
					if(confirm("<%=SystemEnv.getHtmlLabelName(18691,languageId)%>")){
						//weaver.docmodule.selectedIndex=0;
						window.onbeforeunload=null;
						location=doPage+'?mainid=<%=mainid%>&secid=<%=secid%>&subid=<%=subid%>&topage=<%=tmptopage%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&docType='+docType+'&docsubject='+weaver.docsubject.value+'&from=<%=from%>&userCategory=<%=userCategory%>&invalidationdate=<%=invalidationdate%>';
						return true;
					}
					//weaver.sdoctype[docSelectIndex].checked=true;
					return false;
				}
			</script>
  
	<%-- 文档类型 start --%>
	
	<TR>
		<TD class=Line colSpan=4></TD>
	</TR>
	<%-- 文档类型 end --%>


	<%
	boolean canShowDocMain = false;
	
	int j = 1;
	SecCategoryDocPropertiesComInfo.addDefaultDocProperties(secid);
	SecCategoryDocPropertiesComInfo.setTofirstRow();
	while(SecCategoryDocPropertiesComInfo.next()){
		int docPropId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getId());
		int docPropSecCategoryId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getSecCategoryId());
		int docPropViewindex = Util.getIntValue(SecCategoryDocPropertiesComInfo.getViewindex());
		int docPropType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType());
		int docPropLabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId());
		int docPropVisible = Util.getIntValue(SecCategoryDocPropertiesComInfo.getVisible());
		String docPropCustomName = SecCategoryDocPropertiesComInfo.getCustomName();
		int docPropColumnWidth = Util.getIntValue(SecCategoryDocPropertiesComInfo.getColumnWidth());
		int docPropMustInput = Util.getIntValue(SecCategoryDocPropertiesComInfo.getMustInput());
		int docPropIsCustom = Util.getIntValue(SecCategoryDocPropertiesComInfo.getIsCustom());
		String docPropScope = SecCategoryDocPropertiesComInfo.getScope();
		int docPropScopeId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getScopeId());
		int docPropFieldid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getFieldId());

		if(docPropSecCategoryId!=secid) continue;
		
		String tagName = "";
		String tagValue = "";
		
		String label = "";
		if(!docPropCustomName.equals("")) {
			label = docPropCustomName;
		} else if(docPropIsCustom!=1) {
			label = SystemEnv.getHtmlLabelName(docPropLabelid,languageId);
			if(docPropType==10) label+="("+SystemEnv.getHtmlLabelName(93,user.getLanguage())+")";
		}
		
		if(docPropVisible==0) continue;
		
		if(docPropType==1||docPropType==11||docPropType==13||
				docPropType==14||docPropType==15||
				docPropType==16||docPropType==17||
				docPropType==18||docPropType==20)
			continue;
		
		if(docPropColumnWidth>1){
			if(j==2){
	%>
			</TR>
			<TR>
				<TD class=Line colSpan=4></TD>
			</TR>
	<%
			}
			j=3;
		}
	%>
			<% if(j==1||j==3){ %>
			<TR height="20">
			<% } %>
			
			<td><%=label%></td>
			<td class=field <%if(j==3){%>colspan="3"<%}%>>
			<%
				switch(docPropType){
					case 1:{//1 文档标题
					
						break;
					}
					case 2:{//2 文档编号
			%>
						<%=docCode%>
			<%
						break;
					}
					case 3:{//3 发布
						if(!publishable.trim().equals("") && !publishable.trim().equals("0")){
						    canShowDocMain = true;
						%>
		                <select  name="docpublishtype" onchange="if(this.value==2) onshowdocmain(1) ; else onshowdocmain(0)">
							<option value=1  ><font color=red><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></font></option>
							<option value=2 selected><font color=red><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></font></option>
							<option value=3  ><font color=red><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></font></option>
						</select>
						<script type="text/javascript">
							function onshowdocmain(vartmp){
								var otrtmp = document.getElementById("otrtmp");
								if(otrtmp!=null&&otrtmp.parentElement!=null){
									if(vartmp==1){
										otrtmp.parentElement.style.display='';
										otrtmp.parentElement.parentElement.parentElement.rows(otrtmp.parentElement.rowIndex+1).style.display='';
									} else {
										otrtmp.parentElement.style.display='none';
										otrtmp.parentElement.parentElement.parentElement.rows(otrtmp.parentElement.rowIndex+1).style.display='none';
									}
								}
							}
						</script>						
						<%
						} else {
						%>
						<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>
						<% } %>
			<%		
						break;
					}
					case 4:{//4 文档版本
			%>
			<%
						break;
					}
					case 5:{//5 文档状态
			%>
						<%=SystemEnv.getHtmlLabelName(220,languageId)%>
			<%
						break;
					}
					case 6:{//6 主目录
			%>
						  <%if (isPersonalDoc){
				              String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
				              String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
						      out.println("［"+SystemEnv.getHtmlLabelName(17600,languageId)+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
						   } else {
						  %>
						      <%=MainCategoryComInfo.getMainCategoryname(""+mainid)%>
						  <%}%>
			<%
						break;
					}
					case 7:{//7 分目录
			%>
						  <%if (isPersonalDoc){
						      String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
						      String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
						      out.println("［"+SystemEnv.getHtmlLabelName(17600,languageId)+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
						   } else {
						  %>
						      <%=SubCategoryComInfo.getSubCategoryname(""+subid)%>
						  <%}%>
			<%
						break;
					}
					case 8:{//8 子目录
			%>
						  <%if (isPersonalDoc){
						      String catalogIds=DocUserSelfUtil.getParentids(""+userCategory);
						      String catalogNames=DocUserSelfUtil.getCatalogNames(catalogIds) ;
						      out.println("［"+SystemEnv.getHtmlLabelName(17600,languageId)+"］　"+catalogNames+DocUserSelfUtil.getCatalogName(""+userCategory));
						   } else {
						  %>
						      <BUTTON type="button" class=Browser onClick="onSelectCategory()" name=selectCategory></BUTTON>
						      <span id=path name=path><%=SecCategoryComInfo.getSecCategoryname(""+secid).equals("")?"<IMG src='/images/BacoError.gif' align=absMiddle>":SecCategoryComInfo.getSecCategoryname(""+secid)%></span>
						  <%}%>
			<%
						break;
					}
					case 9:{//9 部门
			%>
						<span id=docdepartmentidspan>
							<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=docdepartmentid%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+docdepartmentid),user.getLanguage())%></a>
						</span>
			<%
						break;
					}
					case 10:{//10 模版
			%>
					<script language=javascript>
						function onChangeDocModule(thisvalue1){
							var value= "<%=SystemEnv.getHtmlLabelName(18767,user.getLanguage())%>";
							if(confirm(value)){
								window.onbeforeunload=null;
								location='DocAddExt.jsp?mainid=<%=mainid%>&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&secid=<%=secid%>&subid=<%=subid%>&topage=<%=tmptopage%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&from=<%=from%>&docsubject='+weaver.docsubject.value+'&invalidationdate=<%=invalidationdate%>&docmodule='+thisvalue1;
							}
						}
					</script>
					
					
					<select class=InputStyle name=docmodule <%if(selectMouldType==2||selectMouldType==3){%>disabled<%}%> style="width:200" onchange="onChangeDocModule(this.value)">
						<%if(selectMouldType<2){%>
						<option value="-1"></option>
						<%}%>
						<%
						int tmpcount = 0;
						int tmpMouldId = 0;
						
						for(int i=0;i<selectMouldList.size();i++){
						  	String moduleid = (String) selectMouldList.get(i);
							String modulename = DocMouldComInfo.getDocMouldname(moduleid);
						    String mType = DocMouldComInfo.getDocMouldType(moduleid);
						    String mouldTypeName = "";
						    if((mType.equals("")||mType.equals("0")||mType.equals("1"))&&docType.equals(".htm")){
						        mouldTypeName="HTML";
						        tmpMouldId = Util.getIntValue(moduleid);
						    }else if(mType.equals("2")&&docType.equals(".doc")){
						        mouldTypeName="WORD";
						        tmpMouldId = Util.getIntValue(moduleid);
						    }else if(mType.equals("3")&&docType.equals(".xls")){
						        mouldTypeName="EXCEL";
						        tmpMouldId = Util.getIntValue(moduleid);
						    }else if(mType.equals("4")&&docType.equals(".wps")){
						        mouldTypeName=SystemEnv.getHtmlLabelName(22359,languageId);
						        tmpMouldId = Util.getIntValue(moduleid);
						    }else if(mType.equals("5")&&docType.equals(".et")){
						        mouldTypeName=SystemEnv.getHtmlLabelName(24545,languageId);
						        tmpMouldId = Util.getIntValue(moduleid);
						    } else {
						        continue;
						    }
							String isselect ="" ;
							if(docmodule.equals(moduleid)) isselect = " selected";
						%>
							<option value="<%=moduleid%>" <%=isselect%> ><%=modulename%>(<%=mouldTypeName%>)</option>
						<%
							tmpcount++;
						}
						if(tmpcount==1&&Util.getIntValue(docmodule,0)==0&&tmpMouldId!=0){
						%>
						<%-- 
						<script language=javascript>
					        window.onbeforeunload=null;
							location='DocAddExt.jsp?mainid=<%=mainid%>&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&secid=<%=secid%>&subid=<%=subid%>&topage=<%=tmptopage%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&from=<%=from%>&docsubject='+weaver.docsubject.value+'&invalidationdate=<%=invalidationdate%>&docmodule=<%=tmpMouldId%>';
						</script>
						--%>
						<%
						}
						%>
					</select>
			<%
						break;
					}
					case 11:{//11 语言
			%>
			<%
						break;
					}
					case 12:{//12 关键字
			%>
						<input class=InputStyle maxlength=250 size=26 name=keyword value=""
						<% if(docPropMustInput==1){ %>
						onChange="checkinput('keyword','keywordspan')" >
						<SPAN id="keywordspan">
						<%if("".equals("")){%>
						<IMG src="/images/BacoError.gif" align=absMiddle>
						<%}%>
						</SPAN>
						<%
						needinputitems += ",keyword";
						%>
						<%} else {%>
						>
						<%}%>
			<%
						break;
					}
					case 13:{//13 创建
			%>
			<%
						break;
					}
					case 14:{//14 修改
			%>
			<%
						break;
					}
					case 15:{//15 批准
			%>
			<%
						break;
					}
					case 16:{//16 失效
			%>
			<%
						break;
					}
					case 17:{//17 归档
			%>
			<%
						break;
					}
					case 18:{//18 作废
			%>
			<%
						break;
					}
					case 19:{//19 主文档
			%>
						<BUTTON type="button" class=Browser onClick="onSelectMainDocument()" name=selectMainDocument></BUTTON>
						<span id=spanMainDocument name=spanMainDocument><%=SystemEnv.getHtmlLabelName(524,languageId)%><%=SystemEnv.getHtmlLabelName(58,languageId)%></span>
			<%
						break;
					}
					case 20:{//20 被引用列表
			%>
			<%
						break;
					}
					case 21:{//21 文档所有者
						if(user.getType()==0){
							%>
								<button type="button" class=Browser onClick="onShowResource()"></button>
								<span id=owneridspan>
									<a href="javaScript:openhrm(<%=ownerid%>);" onclick='pointerXY(event);'>
									<%=Util.toScreen(owneridname,user.getLanguage())%>
									</a>
								</span>
						<%
						} else {
						%>
							<%=CustomerInfoComInfo.getCustomerInfoname(""+ownerid)%>
						<%
						}
						break;
					}
					case 22:{//22 失效时间
						%>
						<script language=javascript>
						function onChangeDocInvalidationDate(){
							var value= "<%=SystemEnv.getHtmlLabelName(24470,user.getLanguage())%>";
						    if(confirm(value)){
					        	window.onbeforeunload=null;
								location='/docs/docs/DocAddExt.jsp?mainid=<%=mainid%>&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&secid=<%=secid%>&subid=<%=subid%>&topage=<%=tmptopage%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&from=<%=from%>&docsubject='+weaver.docsubject.value+'&docType=<%=docType%>&userCategory=<%=userCategory%>&invalidationdate='+weaver.invalidationdate.value;
						    } else {
						    	weaver.invalidationdate.value = "<%=invalidationdate%>";
						    	setTimeout(function(){$('invalidationdatespan').innerHTML = weaver.invalidationdate.value;}, 50);
						    }
						}
						</script>
						<BUTTON type="button" class=Calendar onclick="getInvalidationDate2(<%=user.getLanguage()%>,onChangeDocInvalidationDate);
						<% if(docPropMustInput==1){ %>
						checkinput('invalidationdate','invalidationdatespan1');"></BUTTON> 
						<SPAN id=invalidationdatespan><%=invalidationdate%></SPAN> 
						<input type="hidden" name="invalidationdate" value="<%=invalidationdate%>">
						<SPAN id="invalidationdatespan1">
						<%if(invalidationdate.equals("")){%>
						<IMG src="/images/BacoError.gif" align=absMiddle>
						<%}%>
						</SPAN>
						<%
						needinputitems += ",invalidationdate";
						%>
						<%} else {%>
						"></BUTTON> 
						<SPAN id=invalidationdatespan><%=invalidationdate%></SPAN> 
						<input type="hidden" name="invalidationdate" value="<%=invalidationdate%>">
						<SPAN id="invalidationdatespan1"></SPAN>
						<%}%>
						<%
						break;
					}
					case 24:{//24虚拟目录	
						String dummyIds="";
						String dummyNames="";
						String strSql="select defaultDummyCata from DocSecCategory where id="+secid;
						rsDummyDoc.executeSql(strSql);
						
						if(rsDummyDoc.next()){							
							dummyIds=Util.null2String(rsDummyDoc.getString("defaultDummyCata"));
							dummyNames=DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(dummyIds);
						}						
						%>
						<BUTTON type="button" class=Browser
						onClick="onShowMutiDummy(dummycata,spanDummycata);
						<% 
						if(docPropMustInput==1){
							%>
							checkinput('dummycata','spanDummycata1');"></BUTTON>
						
							<span id="spanDummycata1" name="spanDummycata1">
							<%
							if("".equals(dummyNames)){ %>
								&nbsp;<IMG src="/images/BacoError.gif" align=absMiddle>
							<%}%>
								
							</span>
							<%
							needinputitems += ",dummycata";
							%>
							<% 
						} else {
							%>
							"></BUTTON>							
					   <%}%>
					   <span id="spanDummycata" name="spanDummycata"><%=dummyNames%></span>
					   <INPUT type="hidden" name="dummycata" id="dummycata" value="<%=dummyIds%>">
						<%
						break;
					}
					case 25:{//25 可打印份数
			%>
						<input class=InputStyle size=4 maxlength=4 name=canPrintedNum value="0" onKeyPress="ItemCount_KeyPress()"
						<% if(docPropMustInput==1){ %>
						    onChange="checknumber('canPrintedNum');checkinput('canPrintedNum','canPrintedNumSpan')" 
						<%
						needinputitems += ",canPrintedNum";
						%>
						<%}else{%>
						    onChange="checknumber('canPrintedNum')" 
						<%}%>
						>						
						<span id="canPrintedNumSpan">
						</span>
			<%
						break;
					}
					case 0:{//0 自定义字段
			%>
			
			
					<%-- 自定义字段 start --%>
					<%
					    String docid = Util.null2String(request.getParameter("docid"));
					    CustomFieldManager cfm = new CustomFieldManager(docPropScope,docPropScopeId);
					    cfm.getCustomFields(docPropFieldid);
					    if(cfm.next()){
					        if(cfm.isMand()){
					            needinputitems += ",customfield"+cfm.getId();
					        }
							if(cfm.getHtmlType().equals("1")){
								if(cfm.getType()==1){
									if(cfm.isMand()){
					%>
										<input datatype="text" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=50 onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError.gif" align=absmiddle></span>
					<%
									} else {
					%>
										<input datatype="text" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" value="" size=50>
					<%
									}
								} else if(cfm.getType()==2) {
									if(cfm.isMand()){
					%>
										<input datatype="int" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
										onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError.gif" align=absmiddle></span>
					<%
									} else {
					%>
										<input  datatype="int" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
					<%
									}
								} else if(cfm.getType()==3) {
									if(cfm.isMand()){
					%>
										<input datatype="float" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
										onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')">
										<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError.gif" align=absmiddle></span>
					<%
									} else {
					%>
										<input datatype="float" type=text class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
					<%
		                			}
		            			}
							} else if(cfm.getHtmlType().equals("2")) {
								if(cfm.isMand()) {
					%>
									<textarea class=Inputstyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')"
									rows="4" cols="40" style="width:80%" class=Inputstyle></textarea>
									<span id="customfield<%=cfm.getId()%>span"><img src="/images/BacoError.gif" align=absmiddle></span>
					<%
								} else {
					%>
									<textarea class=Inputstyle name="customfield<%=cfm.getId()%>" rows="4" cols="40" style="width:80%"></textarea>
					<%
								}
							} else if(cfm.getHtmlType().equals("3")) {
					
					            String fieldtype = String.valueOf(cfm.getType());
							    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
							    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
							    String showname = "";                                   // 新建时候默认值显示的名称
							    String showid = "";                                     // 新建时候默认值
								String fielddbtype=Util.null2String(cfm.getFieldDbType());

							    if(fieldtype.equals("152") || fieldtype.equals("16")){
									linkurl = "/workflow/request/ViewRequest.jsp?requestid=";
								}
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
								if(fieldtype.equals("161")||fieldtype.equals("162")){
									url+="?type="+fielddbtype;
								}
					%>
								<button type="button" class=Browser 
								<%if(!fieldtype.equals("2") && !fieldtype.equals("19")){%>
								 onClick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')"
					            <%}else{if(fieldtype.equals("2")){%>
								 onClick ="onShowDocDate('<%=cfm.getId()%>','<%=fieldtype%>','<%=cfm.isMand()%>')"
								<%}else{%>
								  onClick ="onShowDocsTime(customfield<%=cfm.getId()%>span,customfield<%=cfm.getId()%>,'<%=cfm.isMand()%>')"
								<%}}%>
								 title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
								<input type=hidden name="customfield<%=cfm.getId()%>" value="<%=showid%>">
								<span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,languageId)%>
					<%
								if(cfm.isMand() && showname.equals("")) {
					%>
									<img src="/images/BacoError.gif" align=absmiddle>
					<%
								}
					%>
								</span>
					<%
							} else if(cfm.getHtmlType().equals("4")) {
					%>
								<input type=checkbox value=1 name="customfield<%=cfm.getId()%>" >
					<%
							} else if(cfm.getHtmlType().equals("5")) {
								cfm.getSelectItem(cfm.getId());
					%>
								<select name="customfield<%=cfm.getId()%>" viewtype="<%if(cfm.isMand()){out.print("1");}else{out.print("0");}%>" class="InputStyle" onChange="checkinput2('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span',this.getAttribute('viewtype'))">
									<option value=""></option>
					<%
								while(cfm.nextSelect()){
					%>
									<option value="<%=cfm.getSelectValue()%>"><%=cfm.getSelectName()%></option>
					<%
								}
					%>
								</select>
								<span id="customfield<%=cfm.getId()%>span">
					<%
								if(cfm.isMand()) {
					%>
									<img src="/images/BacoError.gif" align=absmiddle>
					<%
								}
					%>
								</span>
					<%
							}
						}
					%>
					<%-- 自定义字段 end--%>
			
			<%
					}
				}
			%>
			</td>
			<% if(j==2||j==3){ %>
			</TR>
			<TR>
				<TD class=Line colSpan=4></TD>
			</TR>
			<% } %>
	<%
		j++;
		if(j>2) j=1;
	}
	%>
	<% if(j==2){ %>
			</TR>
			<TR>
				<TD class=Line colSpan=4></TD>
			</TR>
	<% } %>	
	
	<%-- 摘要 start  --%>
	<% 
	if(canShowDocMain){
	%>
	<TR height="20" id=oDiv style="display:''">
		<td id=otrtmp><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></td>
		<td class=field colspan="3">
			<input class=InputStyle size=70 name="docmain" onChange="checkinput('docmain','docmainspan')" >
		    <SPAN id="docmainspan">
		    	<IMG src="/images/BacoError.gif" align=absMiddle>
		    </SPAN>
		</td>
	</TR>
	<TR class=Spacing id=oDiv style="display:''">
		<TD class=Line colSpan=2></TD>
	</TR>
	<%
	}
	%>
	<%-- 摘要 end --%>

	<%-- 类型 start --%>
	<%
	/*现在把附件的添加从由文档管理员确定改成了由用户自定义的方式.*/
	// int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),languageId);
	// String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),languageId);
	
	String Id=""+secid;
	RecordSet.executeProc("Doc_SecCategory_SelectByID",Id);
	if(RecordSet.next());
	String hasasset=Util.toScreen(RecordSet.getString("hasasset"),languageId);
	String assetlabel=Util.toScreen(RecordSet.getString("assetlabel"),languageId);
	String hasitems =Util.toScreen(RecordSet.getString("hasitems"),languageId);
	String itemlabel =Util.toScreenToEdit(RecordSet.getString("itemlabel"),languageId);
	String hashrmres =Util.toScreen(RecordSet.getString("hashrmres"),languageId);
	String hrmreslabel =Util.toScreenToEdit(RecordSet.getString("hrmreslabel"),languageId);
	String hascrm =Util.toScreen(RecordSet.getString("hascrm"),languageId);
	String crmlabel =Util.toScreenToEdit(RecordSet.getString("crmlabel"),languageId);
	String hasproject =Util.toScreen(RecordSet.getString("hasproject"),languageId);
	String projectlabel =Util.toScreenToEdit(RecordSet.getString("projectlabel"),languageId);
	String hasfinance =Util.toScreen(RecordSet.getString("hasfinance"),languageId);
	String financelabel =Util.toScreenToEdit(RecordSet.getString("financelabel"),languageId);
	String isSetShare=Util.null2String(""+RecordSet.getString("isSetShare"));
	%>
	<%if(!hasasset.equals("0")||!hasitems.equals("0")||!hashrmres.equals("0")||!hascrm.equals("0")||!hasproject.equals("0")||!hasfinance.equals("0")){%>
	<%}%>
	<%
	int needtr=0;
	String sepStr="<TR><TD class=Line colSpan=4></TD></TR>";
	
	if(!hashrmres.trim().equals("")&&!hashrmres.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(179,languageId);
		if(!hrmreslabel.trim().equals("")) curlabel = hrmreslabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"20\">");}%>
			<td ><%=curlabel%></td>
			<td  class=field>
			<%if(!user.getLogintype().equals("2")){%>
				<button type="button" class=Browser onClick="onShowHrmresID(<%=hashrmres%>)"></button>
			<%}%>
			<span id=hrmresspan>
			<%if(hrmid.equals("")){%>
				<%if(hashrmres.equals("2")){
					needinputitems += ",hrmresid";
					%>
					<IMG src='/images/BacoError.gif' align=absMiddle>
				<%}%>
			<%}else{%>
				<%=ResourceComInfo.getResourcename(hrmid)%>
			<%}%>
			</span>
			<input type=hidden name=hrmresid value=<%=hrmid%>>
			</td>
			<%
			if(needtr==1){
				out.print("</tr>"+sepStr);
				needtr=0;
			} else needtr++;
	}else{
	%>
		<input type=hidden name=hrmresid value=<%=hrmid%>>
	<%
	}
	%>

	<%
	if(!hasasset.trim().equals("")&&!hasasset.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(535,languageId);
		if(!assetlabel.trim().equals("")) curlabel = assetlabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"20\">");}%>
			<td ><%=curlabel%></td>
			<td class=field>
			<%if(!user.getLogintype().equals("2")){%>
				<button type="button" class=Browser onClick="onShowAssetId(<%=hasasset%>)"></button>
			<%}%>
			<span id=assetidspan>
				<%if(hasasset.equals("2")){
					needinputitems += ",assetid";
				%>
					<IMG src='/images/BacoError.gif' align=absMiddle>
				<%}%>
			</span>
			<input type=hidden name=assetid>
			</td>
			
		<%
		if(needtr==1){
			out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	
	
	if(!hascrm.trim().equals("")&&!hascrm.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(147,languageId);
		if(!crmlabel.trim().equals("")) curlabel = crmlabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"20\">");}%>
			<td ><%=curlabel%></td>
			<td class=field>
			<button type="button" class=Browser onClick="onShowCrmID(<%=hascrm%>)"></button>
			<span id=crmidspan>
			<%if(crmid.equals("")){%>
				<%if(hascrm.equals("2")){
					needinputitems += ",crmid";
				%>
				<IMG src='/images/BacoError.gif' align=absMiddle>
				<%}%>
			<%}else{%>
				<%=CustomerInfoComInfo.getCustomerInfoname(crmid)%>
			<%}%>
			</span>
			<input type=hidden name=crmid value=<%=crmid%>>
			</td>
		<%
		if(needtr==1){
			out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}else{
	%>
		<input type=hidden name=crmid value=<%=crmid%>>
	<%}%>
	
	
	<%
	if(!hasitems.trim().equals("")&&!hasitems.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(145,languageId);
		if(!itemlabel.trim().equals("")) curlabel = itemlabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"20\">");}%>
			<td ><%=curlabel%></td>
			<td class=field>
			<button type="button" class=Browser onClick="onShowItemID(<%=hasitems%>)"></button>
			<span id=itemspan>
			<%if(hasitems.equals("2")){
				needinputitems += ",itemid";
				%>
				<IMG src='/images/BacoError.gif' align=absMiddle>
			<%}%>
			</span>
			<input type=hidden name=itemid>
			</td>
		<%
		if(needtr==1){
				out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>

	<%
	if(!hasproject.trim().equals("")&&!hasproject.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(101,languageId);
		if(!projectlabel.trim().equals("")) curlabel = projectlabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"20\">");}%>
			<td><%=curlabel%></td>
			<td class=field>
			<button type="button" class=Browser onClick="onShowProjectID(<%=hasproject%>)"></button>
			<span id=projectidspan>
			<%if(prjid.equals("")){%>
				<%if(hasproject.equals("2")){
					needinputitems += ",projectid";
					%>
					<IMG src='/images/BacoError.gif' align=absMiddle>
				<%}%>
			<%}else{%>
				<%=ProjectInfoComInfo.getProjectInfoname(prjid)%>
			<%}%>
			</span>
			<input type=hidden name=projectid value=<%=prjid%>>
			</td>
			
		<%
		if(needtr==1){
			out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}else{
	%>
		<input type=hidden name=projectid value=<%=prjid%>>
	<%}%>

	<%
	if(!hasfinance.trim().equals("")&&!hasfinance.trim().equals("0")){
		String curlabel = SystemEnv.getHtmlLabelName(189,languageId);
		if(!financelabel.trim().equals(""))	curlabel = financelabel;
		%>
		<% if(needtr==0){ out.println("<tr height=\"20\">");}%>
			<td ><%=curlabel%></td>
			<td class=field>
			<button type="button" class=Browser></button>
			<input type=hidden name=financeid>
			</td>
	<%
		if(needtr==1){
			out.print("</tr>"+sepStr);
			needtr=0;
		} else needtr++;
	}
	%>
	<%
	if(needtr==1){
	%>
		</tr>
	<%}%>
	<%-- 类型 end --%>

	</TBODY>
	</TABLE>
