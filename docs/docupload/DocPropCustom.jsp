<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj,weaver.general.Util" %>
<%@ page import="weaver.docs.docs.CustomFieldManager" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	int secid=Util.getIntValue(request.getParameter("secid"), -1);

	//out.println(secid);



	int ownerid=Util.getIntValue(request.getParameter("ownerid"),0);
	if(ownerid==0) ownerid=user.getUID() ;
	String owneridname=ResourceComInfo.getResourcename(ownerid+"");


	//System.out.println(secid);
	int subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secid), -1);
    int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid), -1);

	RecordSet.executeProc("Doc_SecCategory_SelectByID",secid+"");
	RecordSet.next();
	String publishable=Util.null2String(""+RecordSet.getString("publishable"));


	String needinputitems = "";

%>



<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

<table class="ViewForm" width="100%">
	<colgroup>
	<col width="140">
	<col width="*">
	<!--基本属性-->	
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%><!--新闻类型--></td>
		<td class="field">
			 <%
				if(!publishable.trim().equals("") && !publishable.trim().equals("0")){				
			%>
				<input type=radio name="docpublishtype" id="sel0" value=1 onClick="onshowdocmain(0)"> 
				<label for="sel0"><font color=red><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></font></label>
				<input type=radio name="docpublishtype" id="sel1" value=2 onClick="onshowdocmain(1)" checked><label for="sel1"><font color=red><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></font></label>

				<input type=radio name="docpublishtype" id="sel2" value=3 onClick="onshowdocmain(0)"><label for="sel2"><font color=red><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></font></label>							
			<%
			} else {
				out.println(SystemEnv.getHtmlLabelName(58,user.getLanguage()));
			} 
			%>			
		</td>
	</tr>
	<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR>		


	<tr>
		<td><%=SystemEnv.getHtmlLabelName(18656,user.getLanguage())%><!--文档所有者--></td>
		<td class="field">
		
			<button class=Browser type="button" onClick="onShowResource(ownerid,spanOwnerid)"></button>
			<span id=spanOwnerid>
				<a href="javaScript:openhrm(<%=ownerid%>);" onclick='pointerXY(event);'>
					<%=owneridname%>
				</a>
			</span>
			<input id="ownerid" name="ownerid" type="hidden" value="<%=ownerid%>"> 
		</td>
	</tr>

	<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR>		


	<tr>
		<td><%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%><!--虚拟目录--></td>
		<td class="field">		
			<%
			String dummyIds="";
			String dummyNames="";
			String strSql="select defaultDummyCata from DocSecCategory where id="+secid;
			rsDummyDoc.executeSql(strSql);
			
			if(rsDummyDoc.next()){							
				dummyIds=Util.null2String(rsDummyDoc.getString("defaultDummyCata"));
				dummyNames=DocTreeDocFieldComInfo.getMultiTreeDocFieldNameOther(dummyIds);
			}						
			%>
    	    <button class=Browser type="button"	onClick="onShowMutiDummy(dummycata,spanDummycata)"></BUTTON>							
		   <span id="spanDummycata" name="spanDummycata"><%=dummyNames%></span>
		   <input type="hidden" name="dummycata" id="dummycata" value="<%=dummyIds%>">
		</td>
	</tr>
		
	
	<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR>	
	<!--自定义1-->

	

	<%

	String  prjid = Util.null2String(request.getParameter("prjid"));
	String  crmid=Util.null2String(request.getParameter("crmid"));
	String  hrmid=Util.null2String(request.getParameter("hrmid"));


	String sepStr="<TR id=oDiv style=\"display:'';height:1px\"><TD class=Line colSpan=4></TD></TR>";
	RecordSet.executeProc("Doc_SecCategory_SelectByID",""+secid);
	if(RecordSet.next());
	String hasasset=Util.toScreen(RecordSet.getString("hasasset"),user.getLanguage());
	String assetlabel=Util.toScreen(RecordSet.getString("assetlabel"),user.getLanguage());
	String hasitems =Util.toScreen(RecordSet.getString("hasitems"),user.getLanguage());
	String itemlabel =Util.toScreenToEdit(RecordSet.getString("itemlabel"),user.getLanguage());
	String hashrmres =Util.toScreen(RecordSet.getString("hashrmres"),user.getLanguage());
	String hrmreslabel =Util.toScreenToEdit(RecordSet.getString("hrmreslabel"),user.getLanguage());
	String hascrm =Util.toScreen(RecordSet.getString("hascrm"),user.getLanguage());
	String crmlabel =Util.toScreenToEdit(RecordSet.getString("crmlabel"),user.getLanguage());
	String hasproject =Util.toScreen(RecordSet.getString("hasproject"),user.getLanguage());
	String projectlabel =Util.toScreenToEdit(RecordSet.getString("projectlabel"),user.getLanguage());
	String hasfinance =Util.toScreen(RecordSet.getString("hasfinance"),user.getLanguage());
	String financelabel =Util.toScreenToEdit(RecordSet.getString("financelabel"),user.getLanguage());
	String isSetShare=Util.null2String(""+RecordSet.getString("isSetShare"));
	String maxuploadfilesize = Util.null2String(RecordSet.getString("maxuploadfilesize"));
	if(!hashrmres.trim().equals("")&&!hashrmres.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(179,user.getLanguage());
			if(!hrmreslabel.trim().equals("")) curlabel = hrmreslabel;
			%>
			<% out.println("<tr id=oDiv style=\"display:''\" height=\"20\">");%>
			<td ><%=curlabel%></td>
			<td  class=field>
				<%if(!user.getLogintype().equals("2")){%>
					<button class=Browser type="button" onClick="onShowHrmresID(<%=hashrmres%>)"></button>
				<%}%>
				<span id=hrmresspan>
				<%if(hrmid.equals("")){%>
					<%if(hashrmres.equals("2")){
						needinputitems += ",hrmresid";
					%>
						<img src='/images/BacoError.gif' align=absMiddle>
					<%}%>
				<% } else { %>
					<%=ResourceComInfo.getResourcename(hrmid)%>
				<% } %>
				</span>
				<input type=hidden name=hrmresid value=<%=hrmid%>>
			</td>
		<%			
		out.print("</tr>"+sepStr);
	} else {
	%>
		<input type=hidden name=hrmresid value=<%=hrmid%>>
	<%
	}


		if(!hasasset.trim().equals("")&&!hasasset.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(535,user.getLanguage());
			if(!assetlabel.trim().equals("")) curlabel = assetlabel;
		%>
			<% out.println("<tr id=oDiv style=\"display:''\" height=\"20\">");%>
			<td ><%=curlabel%></td>
			<td class=field>
				<% if(!user.getLogintype().equals("2")) { %>
					<button class=Browser type="button" onClick="onShowAssetId(<%=hasasset%>)"></button>
				<% } %>
				<span id=assetidspan>
				<% if(hasasset.equals("2")) {
						needinputitems += ",assetid";
				%>
						<img src='/images/BacoError.gif' align=absMiddle>
				<% } %>
				</span>
				<input type=hidden name=assetid>
			</td>
			<%					
			out.print("</tr>"+sepStr);
		}
		if(!hascrm.trim().equals("")&&!hascrm.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(147,user.getLanguage());
			if(!crmlabel.trim().equals("")) curlabel = crmlabel;
		%>
			<% out.println("<tr id=oDiv style=\"display:''\" height=\"20\">");%>
			<td ><%=curlabel%></td>
			<td class=field>
				<button class=Browser type="button" onClick="onShowCrmID(<%=hascrm%>)"></button>
				<span id=crmidspan>
				<%if(crmid.equals("")){%>
					<%if(hascrm.equals("2")){
						needinputitems += ",crmid";
					%>
						<img src='/images/BacoError.gif' align=absMiddle>
					<%}%>
				<% } else { %>
					<%=CustomerInfoComInfo.getCustomerInfoname(crmid)%>
				<% } %>
				</span>
				<input type=hidden name=crmid value=<%=crmid%>>
			</td>
			<%
			out.print("</tr>"+sepStr);
		} else {
		%>
			<input type=hidden name=crmid value=<%=crmid%>>
		<% } %>


		<%
		if(!hasitems.trim().equals("")&&!hasitems.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(145,user.getLanguage());
			if(!itemlabel.trim().equals("")) curlabel = itemlabel;
		%>
			<% out.println("<tr id=oDiv style=\"display:''\" height=\"20\">");%>
			<td ><%=curlabel%></td>
			<td class=field>
				<button class=Browser type="button" onClick="onShowItemID(<%=hasitems%>)"></button>
				<span id=itemspan>
				<%if(hasitems.equals("2")){
					needinputitems += ",itemid";
				%>
					<img src='/images/BacoError.gif' align=absMiddle>
				<%}%>
				</span>
				<input type=hidden name=itemid>
			</td>
			<%
			out.print("</tr>"+sepStr);
		}
		%>



		<%
		if(!hasproject.trim().equals("")&&!hasproject.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(101,user.getLanguage());
			if(!projectlabel.trim().equals("")) curlabel = projectlabel;
		%>
			<% out.println("<tr id=oDiv style=\"display:''\" height=\"20\">");%>
			<td><%=curlabel%></td>
			<td class=field>
				<button class=Browser type="button" onClick="onShowProjectID(<%=hasproject%>)"></button>
				<span id=projectidspan>
				<%if(prjid.equals("")){%>
					<%if(hasproject.equals("2")){
						needinputitems += ",projectid";
					%>
						<img src='/images/BacoError.gif' align=absMiddle>
					<%}%>
				<%}else{%>
					<%=ProjectInfoComInfo.getProjectInfoname(prjid)%>
				<%}%>
				</span>
				<input type=hidden name=projectid value=<%=prjid%>>
			</td>
			<%
			out.print("</tr>"+sepStr);
		} else {
		%>
		<input type=hidden name=projectid value=<%=prjid%>>
		<% } %>
		
		
		<%
		if(!hasfinance.trim().equals("")&&!hasfinance.trim().equals("0")){
			String curlabel = SystemEnv.getHtmlLabelName(189,user.getLanguage());
			if(!financelabel.trim().equals("")) curlabel = financelabel;
		%>
			<% out.println("<tr id=oDiv style=\"display:''\" height=\"20\">");%>
			<td ><%=curlabel%></td>
			<td class=field>
				<button class=Browser type="button"></button>
				<input type=hidden name=financeid>
			</td>
			<%
			out.print("</tr>"+sepStr);
		}
		%>
		</tr>

	<!--自定义2-->
	<%
	SecCategoryDocPropertiesComInfo.addDefaultDocProperties(secid);
	SecCategoryDocPropertiesComInfo.setTofirstRow();
	boolean isHaveValue=false;
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
		if(docPropType!=0) continue;

		isHaveValue=true;
		

		String label = "";
		if(!docPropCustomName.equals("")) {
			label = docPropCustomName;
		} else if(docPropIsCustom!=1) {
			label = SystemEnv.getHtmlLabelName(docPropLabelid,user.getLanguage());
			if(docPropType==10) label+="("+SystemEnv.getHtmlLabelName(93,user.getLanguage())+")";
		}
	%>
		
		<tr>
			<td><%=label%></td>
			<td class="field">
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
								<button class=Browser type="button" onClick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
								<input type=hidden name="customfield<%=cfm.getId()%>" value="<%=showid%>">
								<span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
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
								<select name="customfield<%=cfm.getId()%>" class=InputStyle>
					<%
								while(cfm.nextSelect()){
					%>
									<option value="<%=cfm.getSelectValue()%>"><%=cfm.getSelectName()%>
					<%
								}
					%>
								</select>
					<%
							}
						}
					%>
					</td>
					</tr>
					<%if(isHaveValue)%><tr style="height: 1px"><td class="line" colspan="2"></td></tr>
					<%-- 自定义字段 end--%>
		<%}%>
		
		
</table>	
<%//out.println("needinputitems:"+needinputitems);%>
<INPUT TYPE="hidden" NAME="needinputitems" id="needinputitems" value="<%=needinputitems%>">
<input type="hidden" name="docedition" value="-1">
<input type="hidden" name="doceditionid" value="-1">
<input type="hidden" name="maxuploadfilesize" id="maxuploadfilesize" value="<%=maxuploadfilesize %>">

	