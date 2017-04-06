<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all.css' />
<link rel='stylesheet' type='text/css' href='/css/weaver-ext.css' />
<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray.css'/>
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid.css" />

<script type='text/javascript' src='/js/jquery/jquery.js'></script>
<script type='text/javascript' src='/js/extjs/adapter/jquery/jquery.js'></script>
<script type='text/javascript' src='/js/extjs/adapter/jquery/ext-jquery-adapter.js'></script>
<script type='text/javascript' src='/js/extjs/ext-all.js'></script>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />

</head>
<%
	if(!HrmUserVarify.checkUserRight("AppDetach:All", user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	String imagefilename = "/images/hdSystem.gif";
	String titlename = SystemEnv.getHtmlLabelName(24333, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:doSave(),_self} ";
	RCMenuHeight += RCMenuHeightStep;

	RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:doCancel(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp"%>

<%
RecordSet rs=new RecordSet();

String id = Util.null2String(request.getParameter("id"));

String name = "";
String description = "";

rs.executeSql("select * from SysDetachInfo where id = " + id);
if(rs.next()){
	name = Util.null2String(rs.getString("name"));
	description = Util.null2String(rs.getString("description"));
}

List scopelist = new ArrayList();
List memberlist = new ArrayList();

rs.executeSql("select * from SysDetachDetail where infoid = " + id);
while(rs.next()){
	String did = Util.null2String(rs.getString("id"));
	String dsourcetype = Util.null2String(rs.getString("sourcetype"));
	String dtype = Util.null2String(rs.getString("type"));
	String dcontent = Util.null2String(rs.getString("content"));
	String dseclevel = Util.null2String(rs.getString("seclevel"));
	
	if(dsourcetype.equals("1")) {
		Map scopemap = new HashMap();
		scopemap.put("id",did);
		scopemap.put("sourcetype",dsourcetype);
		scopemap.put("type",dtype);
		scopemap.put("seclevel",dseclevel);
		scopemap.put("content",dcontent);
		scopelist.add(scopemap);
	} else if(dsourcetype.equals("2")) {
		Map membermap = new HashMap();
		membermap.put("id",did);
		membermap.put("sourcetype",dsourcetype);
		membermap.put("type",dtype);
		membermap.put("seclevel",dseclevel);
		membermap.put("content",dcontent);
		memberlist.add(membermap);
	}
}
%>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="AppDetachOperation.jsp">
<input type="hidden" id="id" name="id" value="<%=id%>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
		<TABLE class=Shadow>
			<tr>
				<td valign="top">

				<TABLE class=ViewForm>
					<COLGROUP>
						<COL width="20%">
						<COL width="80%">
					<TBODY>
						<tr><td colspan="2"></td></tr>
						<TR class=Title>
							<TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></TH>
						</TR>
						
						<TR class=Spacing>
							<TD class=Line1 colSpan=2></TD>
						</TR>

						<tr>
							<td><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
							<td class=Field><input type="text" name="name" class="InputStyle" style="width:90%" value="<%=name%>"></td>
						</tr>
						
						<TR>
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></td>
							<td class=Field>
								<textarea rows="3" cols="70" name="description" class="InputStyle" style="width:90%"><%=description%></textarea>
							</td>
						</tr>
						
						<TR>
							<TD class=Line colSpan=2></TD>
						</TR>
						<TR>
							<TD colSpan=2>&nbsp;</TD>
						</TR>
						
						<!-- 范围设置19374 -->
						<TR class=Title>
							<TH><%=SystemEnv.getHtmlLabelName(19374, user.getLanguage())%></TH>
							<td align="right">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>" onclick="addScope();">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="deleteScope();">
							</td>
						</TR>
						<TR class=Spacing>
							<TD class=Line1 colSpan=2></TD>
						</TR>
						<tr>
							<td colspan="2">
							
							<input type="hidden" id="scopeTotal" name="scopeTotal" value="<%=scopelist.size()%>">
							
							<TABLE id="table_scope" class=BroswerStyle cellspacing="1" cellpadding="1" width="100%">
							<colgroup>
								<col width="5%">
								<col width="25%">
								<col width="35%">
								<col width="35%">
							</colgroup>
							<tr class=DataHeader>
								<th></td>
								<th><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
								<th><%=SystemEnv.getHtmlLabelName(139, user.getLanguage())%></td>
								<th><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></td>
							</tr>
							<TR class=Line><TH colspan="6" ></TH></TR>
							<% 
							for(int i=0;i<scopelist.size();i++){ 
								Map scopemap = (Map)scopelist.get(i);
								int detailid = Util.getIntValue(Util.null2String((String)scopemap.get("id")),0);
								int sourcetype = Util.getIntValue(Util.null2String((String)scopemap.get("sourcetype")),0);
								int type = Util.getIntValue(Util.null2String((String)scopemap.get("type")),0);
								int seclevel = Util.getIntValue(Util.null2String((String)scopemap.get("seclevel")),0);
								String content = Util.null2String((String)scopemap.get("content"));
								
								String showtype = "";
								String showlevel = "";
								String showcontent = "";
								
								//1.人员 2. 分部 3.部门 4.角色 5.所有人 6.群组
								if(type==1){
									//人力资源
									showtype = SystemEnv.getHtmlLabelName(179, user.getLanguage());
									showlevel = "";
									showcontent = "<a href='/hrm/resource/HrmResource.jsp?id="+content+"'>"+resourceComInfo.getLastname(content)+"</a>&nbsp;";
								} else if(type==2){
									//分部
									showtype = SystemEnv.getHtmlLabelName(141, user.getLanguage());
									showlevel = SystemEnv.getHtmlLabelName(683, user.getLanguage()) + ">=" + seclevel + SystemEnv.getHtmlLabelName(18941, user.getLanguage());
									showcontent = "<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+content+"'>"+subCompanyComInfo.getSubCompanyname(content)+"</a>&nbsp;";
								} else if(type==3){
									//部门
									showtype = SystemEnv.getHtmlLabelName(124, user.getLanguage());
									showlevel = SystemEnv.getHtmlLabelName(683, user.getLanguage()) + ">=" + seclevel + SystemEnv.getHtmlLabelName(18942, user.getLanguage());
									showcontent = "<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+content+"'>"+departmentComInfo.getDepartmentname(content)+"</a>&nbsp;";
								} else if(type==4){
									//角色
									showtype = SystemEnv.getHtmlLabelName(122, user.getLanguage());
									
									int rolelevel = Util.getIntValue(content.substring(content.length()-1),0);
									int roletext = 124;
									if(rolelevel==0) roletext = 124;
									else if(rolelevel==1) roletext = 141;
									else if(rolelevel==2) roletext = 140;
									
									showlevel = SystemEnv.getHtmlLabelName(3005, user.getLanguage()) + "=" + SystemEnv.getHtmlLabelName(roletext, user.getLanguage());
									showlevel+= SystemEnv.getHtmlLabelName(683, user.getLanguage()) + ">=" + seclevel + SystemEnv.getHtmlLabelName(18945, user.getLanguage());

									showcontent = rolesComInfo.getRolesname(content.substring(0,content.length()-1));
								}
							%>
							<tr>
								<td>
								<input type="checkbox" id="scope_<%=i%>" name="scope_id" class="InputStyle" value="<%=detailid%>">
								<input type="hidden" id="scope_sourcetype<%=i%>" name="scope_sourcetype" class="InputStyle" value="<%=sourcetype%>">
								<input type="hidden" id="scope_type<%=i%>" name="scope_type" class="InputStyle" value="<%=type%>">
								<input type="hidden" id="scope_seclevel<%=i%>" name="scope_seclevel" class="InputStyle" value="<%=seclevel%>">
								<input type="hidden" id="scope_content<%=i%>" name="scope_content" class="InputStyle" value="<%=content%>">
								</td>
								<td><%=showtype%></td>
								<td><%=showlevel%></td>
								<td><%=showcontent%></td>
							</tr>
							<TR>
								<TD class=Line colSpan=6></TD>
							</TR>
							<%
							}
							%>
							</TABLE>
							</td>
						</tr>
						<TR>
							<TD colSpan=2>&nbsp;</TD>
						</TR>
						
						
						
						<!-- 成员设置 -->
						<TR class=Title>
							<TH><%=SystemEnv.getHtmlLabelName(431, user.getLanguage())%></TH>
							<td align="right">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>" onclick="addMember();">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="deleteMember();">
							</td>
						</TR>
						<TR class=Spacing>
							<TD class=Line1 colSpan=2></TD>
						</TR>
						<tr>
							<td colspan="2">
							
							<input type="hidden" id="memberTotal" name="memberTotal" value="<%=memberlist.size()%>">
							
							<TABLE id="table_member" class=BroswerStyle cellspacing="1" cellpadding="1" width="100%">
							<colgroup>
								<col width="5%">
								<col width="25%">
								<col width="35%">
								<col width="35%">
							</colgroup>
							<tr class=DataHeader>
								<th></td>
								<th><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
								<th><%=SystemEnv.getHtmlLabelName(139, user.getLanguage())%></td>
								<th><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></td>
							</tr>
							<TR class=Line><TH colspan="6" ></TH></TR>
							<% 
							for(int i=0;i<memberlist.size();i++){ 
								Map membermap = (Map)memberlist.get(i);
								int detailid = Util.getIntValue(Util.null2String((String)membermap.get("id")),0);
								int sourcetype = Util.getIntValue(Util.null2String((String)membermap.get("sourcetype")),0);
								int type = Util.getIntValue(Util.null2String((String)membermap.get("type")),0);
								int seclevel = Util.getIntValue(Util.null2String((String)membermap.get("seclevel")),0);
								String content = Util.null2String((String)membermap.get("content"));
								
								String showname = "";
								String showlevel = "";
								String showobject = "";
								
								//1.人员 2. 分部 3.部门 4.角色 5.所有人 6.群组
								if(type==1){
									//人力资源
									showname = SystemEnv.getHtmlLabelName(179, user.getLanguage());
									showlevel = "";
									showobject = "<a href='/hrm/resource/HrmResource.jsp?id="+content+"'>"+resourceComInfo.getLastname(content)+"</a>&nbsp;";
								} else if(type==2){
									//分部
									showname = SystemEnv.getHtmlLabelName(141, user.getLanguage());
									showlevel = SystemEnv.getHtmlLabelName(683, user.getLanguage()) + ">=" + seclevel + SystemEnv.getHtmlLabelName(18941, user.getLanguage());
									showobject = "<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+content+"'>"+subCompanyComInfo.getSubCompanyname(content)+"</a>&nbsp;";
								} else if(type==3){
									//部门
									showname = SystemEnv.getHtmlLabelName(124, user.getLanguage());
									showlevel = SystemEnv.getHtmlLabelName(683, user.getLanguage()) + ">=" + seclevel + SystemEnv.getHtmlLabelName(18942, user.getLanguage());
									showobject = "<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+content+"'>"+departmentComInfo.getDepartmentname(content)+"</a>&nbsp;";
								} else if(type==4){
									//角色
									showname = SystemEnv.getHtmlLabelName(122, user.getLanguage());
									
									int rolelevel = Util.getIntValue(content.substring(content.length()-1),0);
									int roletext = 124;
									if(rolelevel==0) roletext = 124;
									else if(rolelevel==1) roletext = 141;
									else if(rolelevel==2) roletext = 140;
									
									showlevel = SystemEnv.getHtmlLabelName(3005, user.getLanguage()) + "=" + SystemEnv.getHtmlLabelName(roletext, user.getLanguage());
									showlevel+= SystemEnv.getHtmlLabelName(683, user.getLanguage()) + ">=" + seclevel + SystemEnv.getHtmlLabelName(18945, user.getLanguage());

									showobject = rolesComInfo.getRolesname(content.substring(0,content.length()-1));
								}
							%>
							<tr>
								<td>
								<input type="checkbox" id="member_<%=i%>" name="member_id" class="InputStyle" value="<%=detailid%>">
								<input type="hidden" id="member_sourcetype<%=i%>" name="member_sourcetype" class="InputStyle" value="<%=sourcetype%>">
								<input type="hidden" id="member_type<%=i%>" name="member_type" class="InputStyle" value="<%=type%>">
								<input type="hidden" id="member_seclevel<%=i%>" name="member_seclevel" class="InputStyle" value="<%=seclevel%>">
								<input type="hidden" id="member_content<%=i%>" name="member_content" class="InputStyle" value="<%=content%>">
								</td>
								<td><%=showname%></td>
								<td><%=showlevel%></td>
								<td><%=showobject%></td>
							</tr>
							<TR>
								<TD class=Line colSpan=6></TD>
							</TR>
							<%
							}
							%>
							</TABLE>
							</td>
						</tr>
						<TR>
							<TD colSpan=2>&nbsp;</TD>
						</TR>
						
						

					</TBODY>
				</TABLE>
				</td>
			</tr>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
		</table>
		</td>
		<td></td>
	</tr>
</table>

<div id="addwin" class="x-hidden">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">    
        <tr>
            <td valign="top">
                <TABLE width=100% height=100%>
                    <tr>
                        <td valign="top">  
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>            
                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                            <SELECT class=InputStyle name=sharetype onChange="onChangeSharetype()" >   
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option> 
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                                                <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            <BUTTON class=Browser style="display:''" onClick="onShowResource('relatedshareid','showrelatedsharename');" name=showresource></BUTTON> 
                                            <BUTTON class=Browser style="display:none" onClick="onShowSubcompany('relatedshareid','showrelatedsharename');" name=showsubcompany></BUTTON> 
                                            <BUTTON class=Browser style="display:none" onClick="onShowDepartment('relatedshareid','showrelatedsharename');" name=showdepartment></BUTTON> 
                                            <BUTTON class=Browser style="display:none" onClick="onShowRole('relatedshareid','showrelatedsharename');" name=showrole></BUTTON>
                                            <INPUT type=hidden name=relatedshareid  id="relatedshareid" value="">
                                            <span id=showrelatedsharename name=showrelatedsharename></span>                                            
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD class=Line colSpan=2></TD>
                                    </TR>

                                    <TR id=showrolelevel name=showrolelevel style="display:none">
                                        <TD>
                                            <%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <SELECT  name=rolelevel>
                                                    <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
                                                    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
                                                    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
                                             </SELECT>
                                        </td>
                                    </TR>
                                     <TR>
                                        <TD class=Line colSpan=2  id=showrolelevel_line name=showrolelevel_line style="display:none"></TD>
                                     </TR>

                                      <TR  id=showseclevel name=showseclevel style="display:none">
                                        <TD>
                                             <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <INPUT type=text name=seclevel class=InputStyle size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' onKeyPress="ItemCount_KeyPress()">
                                             <span id=seclevelimage></span>
                                        </td>
                                    </TR>
                                     <TR>
                                        <TD class=Line colSpan=2 id=showseclevel_line name=showseclevel_line style="display:none"></TD>
                                     </TR>
                                </TBODY>
                            </TABLE>
                        </td>
                    </tr>
                </TABLE>
            </td>
        </tr>
        </table>
</div>

</FORM>

</BODY>
</HTML>
<script type="text/javascript">
	function doSave(){
		frmMain.submit();
	}

	function doCancel(){
		location.href = 'AppDetachList.jsp';
	}
	
	function addScope(){
		var win;
		if(!win){
			win = new Ext.Window({
		           contentEl:"addwin",
		           width:500,
		           height:400,
		           modal:true,
		           closable:true,
		           closeAction:"hide",
		           buttons:[{text:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",handler:function(){onScopeOk();win.hide();}},{text:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",handler:function(){onScopeCancel();win.hide();}}],
		           buttonAlign:"center",
		           title:"<%=SystemEnv.getHtmlLabelName(18454,user.getLanguage())%>"
		        });
		}
        win.show();
	}

	function onScopeOk(){
		var table = document.getElementById("table_scope");
		if(table) {
		 	var sharetype = document.all("sharetype").value;
		 	var seclevel = document.all("seclevel").value;
		 	var rolelevel = document.all("rolelevel").value;
		 	var relatedshareids = document.all("relatedshareid").value;

		 	var sharetypetext = document.all("sharetype").options[document.all("sharetype").selectedIndex].text;
		 	var showrelatedsharenames = document.getElementById("showrelatedsharename").innerHTML;
		 	var roleleveltext = document.all("rolelevel").options[document.all("rolelevel").selectedIndex].text;

		 	var relatedshareid = relatedshareids.split(",");
		 	var showrelatedsharename = showrelatedsharenames.split("&nbsp;");

			for(var i=0;i<relatedshareid.length;i++){
				if(!relatedshareid[i]||relatedshareid[i]=="") continue;

				var id = "0";
				var sourcetype = "1";
			 	var type = "";
				var level = "";
				var content = "";
				
				var showtype = "";
				var showlevel = "";
				var showcontent = "";
				
				if(sharetype=="1"){
					type = "1";
					showtype = sharetypetext;
					level = "0";
					showlevel = "";
					content = relatedshareid[i];
					showcontent = showrelatedsharename[i];
				} else if(sharetype=="2"){
					type = "2";
					showtype = sharetypetext;
					level = seclevel;
					showlevel = "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>" + ">=" + seclevel + "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
					content = relatedshareid[i];
					showcontent = showrelatedsharename[i];
				} else if(sharetype=="3"){
					type = "3";
					showtype = sharetypetext;
					level = seclevel;
					showlevel = "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>" + ">=" + seclevel + "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
					content = relatedshareid[i];
					showcontent = showrelatedsharename[i];
				} else if(sharetype=="4"){
					type = "4";
					showtype = sharetypetext;
					level = seclevel;
					showlevel = "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>=" + roleleveltext + "/" + "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>" + ">=" + seclevel + "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
					content = relatedshareid[i] + rolelevel;
					showcontent = showrelatedsharename[i];
				}
				
				var oRow = table.insertRow();
				var oCell = oRow.insertCell();
				var index = parseInt(document.getElementById("scopeTotal").value) + 1;
				document.getElementById("scopeTotal").value = index;

				oCell.innerHTML = "<input type=\"checkbox\" id=\"scope_"+index+"\" name=\"scope_id\" class=\"InputStyle\" value=\""+id+"\"> " +
								  "<input type=\"hidden\" id=\"scope_sourcetype"+index+"\" name=\"scope_sourcetype\" value=\""+sourcetype+"\"> " +
								  "<input type=\"hidden\" id=\"scope_type"+index+"\" name=\"scope_type\" value=\""+type+"\"> " +
								  "<input type=\"hidden\" id=\"scope_seclevel"+index+"\" name=\"scope_seclevel\" value=\""+level+"\"> " +
								  "<input type=\"hidden\" id=\"scope_content"+index+"\" name=\"scope_content\" value=\""+content+"\">";
				oCell = oRow.insertCell();
				oCell.innerHTML = showtype;
				oCell = oRow.insertCell();
				oCell.innerHTML = showlevel;
				oCell = oRow.insertCell();
				oCell.innerHTML = showcontent;
				oRow = table.insertRow();
				oCell = oRow.insertCell();
				oCell.colSpan = 4;
				oCell.className = "Line";
			}

		 	document.all("sharetype").value = "1";
		 	document.all("seclevel").value = "";
		 	document.all("rolelevel").value = "";
		 	document.all("relatedshareid").value = "";
		 	document.getElementById("showrelatedsharename").innerHTML = "";
		 	onChangeSharetype();
		}
	}

	function onScopeCancel() {
	 	document.all("sharetype").value = "1";
	 	document.all("seclevel").value = "";
	 	document.all("rolelevel").value = "";
	 	document.all("relatedshareid").value = "";
	 	document.getElementById("showrelatedsharename").innerHTML = "";
	 	onChangeSharetype();
	}

	function deleteScope(){
		var chkids = document.getElementsByName("scope_id");
		var count = chkids.length;
		for(var i=count-1;i>=0;i--){
			if(chkids[i]&&chkids[i].checked){
				var tr = chkids[i].parentElement.parentElement;
				if(tr){
					tr.parentElement.deleteRow(tr.rowIndex+1);
					tr.parentElement.deleteRow(tr.rowIndex);
					document.getElementById("scopeTotal").value = parseInt(document.getElementById("scopeTotal").value) - 1;
				}
			}
		}
	}


	function addMember(){
		var win;
		if(!win){
			win = new Ext.Window({
		           contentEl:"addwin",
		           width:500,
		           height:400,
		           modal:true,
		           closable:true,
		           closeAction:"hide",
		           buttons:[{text:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",handler:function(){onMemberOk();win.hide();}},{text:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",handler:function(){onMemberCancel();win.hide();}}],
		           buttonAlign:"center",
		           title:"<%=SystemEnv.getHtmlLabelName(18454,user.getLanguage())%>"
		        });
		}
        win.show();
	}

	function onMemberOk(){
		var table = document.getElementById("table_member");
		if(table) {
		 	var sharetype = document.all("sharetype").value;
		 	var seclevel = document.all("seclevel").value;
		 	var rolelevel = document.all("rolelevel").value;
		 	var relatedshareids = document.all("relatedshareid").value;

		 	var sharetypetext = document.all("sharetype").options[document.all("sharetype").selectedIndex].text;
		 	var showrelatedsharenames = document.getElementById("showrelatedsharename").innerHTML;
		 	var roleleveltext = document.all("rolelevel").options[document.all("rolelevel").selectedIndex].text;

		 	var relatedshareid = relatedshareids.split(",");
		 	var showrelatedsharename = showrelatedsharenames.split("&nbsp;");

			for(var i=0;i<relatedshareid.length;i++){
				if(!relatedshareid[i]||relatedshareid[i]=="") continue;

				var id = "0";
				var sourcetype = "2";
			 	var type = "";
				var level = "";
				var content = "";
				
				var showtype = "";
				var showlevel = "";
				var showcontent = "";
				
				if(sharetype=="1"){
					type = "1";
					showtype = sharetypetext;
					level = "0";
					showlevel = "";
					content = relatedshareid[i];
					showcontent = showrelatedsharename[i];
				} else if(sharetype=="2"){
					type = "2";
					showtype = sharetypetext;
					level = seclevel;
					showlevel = "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>" + ">=" + seclevel + "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
					content = relatedshareid[i];
					showcontent = showrelatedsharename[i];
				} else if(sharetype=="3"){
					type = "3";
					showtype = sharetypetext;
					level = seclevel;
					showlevel = "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>" + ">=" + seclevel + "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
					content = relatedshareid[i];
					showcontent = showrelatedsharename[i];
				} else if(sharetype=="4"){
					type = "4";
					showtype = sharetypetext;
					level = seclevel;
					showlevel = "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>=" + roleleveltext + "/" + "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>" + ">=" + seclevel + "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
					content = relatedshareid[i] + rolelevel;
					showcontent = showrelatedsharename[i];
				}
				
				var oRow = table.insertRow();
				var oCell = oRow.insertCell();
				var index = parseInt(document.getElementById("memberTotal").value) + 1;
				document.getElementById("memberTotal").value = index;

				oCell.innerHTML = "<input type=\"checkbox\" id=\"member_"+index+"\" name=\"member_id\" class=\"InputStyle\" value=\""+id+"\"> " +
								  "<input type=\"hidden\" id=\"member_sourcetype"+index+"\" name=\"member_sourcetype\" value=\""+sourcetype+"\"> " +
								  "<input type=\"hidden\" id=\"member_type"+index+"\" name=\"member_type\" value=\""+type+"\"> " +
								  "<input type=\"hidden\" id=\"member_seclevel"+index+"\" name=\"member_seclevel\" value=\""+level+"\"> " +
								  "<input type=\"hidden\" id=\"member_content"+index+"\" name=\"member_content\" value=\""+content+"\">";
				oCell = oRow.insertCell();
				oCell.innerHTML = showtype;
				oCell = oRow.insertCell();
				oCell.innerHTML = showlevel;
				oCell = oRow.insertCell();
				oCell.innerHTML = showcontent;
				oRow = table.insertRow();
				oCell = oRow.insertCell();
				oCell.colSpan = 4;
				oCell.className = "Line";
			}

		 	document.all("sharetype").value = "1";
		 	document.all("seclevel").value = "";
		 	document.all("rolelevel").value = "";
		 	document.all("relatedshareid").value = "";
		 	document.getElementById("showrelatedsharename").innerHTML = "";
		 	onChangeSharetype();
		}
	}

	function onMemberCancel() {
	 	document.all("sharetype").value = "1";
	 	document.all("seclevel").value = "";
	 	document.all("rolelevel").value = "";
	 	document.all("relatedshareid").value = "";
	 	document.getElementById("showrelatedsharename").innerHTML = "";
	 	onChangeSharetype();
	}

	function deleteMember(){
		var chkids = document.getElementsByName("member_id");
		var count = chkids.length;
		for(var i=count-1;i>=0;i--){
			if(chkids[i]&&chkids[i].checked){
				var tr = chkids[i].parentElement.parentElement;
				if(tr){
					tr.parentElement.deleteRow(tr.rowIndex+1);
					tr.parentElement.deleteRow(tr.rowIndex);
					document.getElementById("memberTotal").value = parseInt(document.getElementById("memberTotal").value) - 1;
				}
			}
		}
	}

	
	function onChangeSharetype(){
		var thisvalue=document.all("sharetype").value;
		document.all("relatedshareid").value="";
		document.all("showseclevel").style.display='';
		document.all("showseclevel_line").style.display='';
		if(thisvalue==1){
			document.all("showresource").style.display='';
			document.all("showseclevel").style.display='none';
		    document.all("showseclevel_line").style.display='none';
		    document.all("seclevel").value=0;
		} else {
			document.all("showresource").style.display='none';
		}
		if(thisvalue==2){
	 		document.all("showsubcompany").style.display='';
	 		document.all("seclevel").value=10;
		} else {
			document.all("showsubcompany").style.display='none';
			document.all("seclevel").value=10;
		}
		if(thisvalue==3){
		 	document.all("showdepartment").style.display='';
		 	document.all("seclevel").value=10;
		} else {
			document.all("showdepartment").style.display='none';
			document.all("seclevel").value=10;
		}
		if(thisvalue==4){
		 	document.all("showrole").style.display='';
			document.all("showrolelevel").style.display='';
		    document.all("showrolelevel_line").style.display='';
		    document.all("rolelevel").style.display='';
			document.all("seclevel").value=10;
		} else {
			document.all("showrole").style.display='none';
			document.all("showrolelevel").style.display='none';
		    document.all("showrolelevel_line").style.display='none';
		    document.all("rolelevel").style.display='none';
			document.all("seclevel").value=10;
	    }
	}

	function onShowResource(input,span) {
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
		try {
			vbid = new VBArray(vbid);
		} catch(e) {
			return;
		}
		var id = vbid.toArray();
		if (id[0]&&id[1]) {
			dummyidArray=id[0].split(",");
			dummynames=id[1].split(",");
			var sHtml = "";
			for(var k=0;k<dummyidArray.length;k++){
				if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
					sHtml = sHtml+"&nbsp<a href='/hrm/resource/HrmResource.jsp?id="+dummyidArray[k]+"'>"+dummynames[k]+"</a>";
			}
			document.getElementById(input).value=id[0];
			document.getElementById(span).innerHTML=sHtml;
		} else {			
			document.getElementById(input).value="0";
			document.getElementById(span).innerHTML="";
		}
	}

	function onShowSubcompany(input,span) {
	    var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+document.getElementById(input).value);
		try {
			vbid = new VBArray(vbid);
		} catch(e) {
			return;
		}
		var id = vbid.toArray();
		if (id[0]&&id[1]) {
			dummyidArray=id[0].split(",");
			dummynames=id[1].split(",");
			var sHtml = "";
			for(var k=0;k<dummyidArray.length;k++){
				if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
					sHtml = sHtml+"&nbsp<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+dummyidArray[k]+"'>"+dummynames[k]+"</a>";
			}
			document.getElementById(input).value=id[0];
			document.getElementById(span).innerHTML=sHtml;
		} else {			
			document.getElementById(input).value="0";
			document.getElementById(span).innerHTML="";
		}
	}

	function onShowDepartment(input,span) {
	    var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+document.getElementById(input).value);
		try {
			vbid = new VBArray(vbid);
		} catch(e) {
			return;
		}
		var id = vbid.toArray();
		if (id[0]&&id[1]) {
			dummyidArray=id[0].split(",");
			dummynames=id[1].split(",");
			var sHtml = "";
			for(var k=0;k<dummyidArray.length;k++){
				if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
					sHtml = sHtml+"&nbsp<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+dummyidArray[k]+"'>"+dummynames[k]+"</a>";
			}
			document.getElementById(input).value=id[0];
			document.getElementById(span).innerHTML=sHtml;
		} else {			
			document.getElementById(input).value="0";
			document.getElementById(span).innerHTML="";
		}
	}

	function onShowRole(input,span) {
	    var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
		try {
			vbid = new VBArray(vbid);
		} catch(e) {
			return;
		}
		var id = vbid.toArray();
		if (id[0]&&id[1]) {
			document.getElementById(input).value=id[0];
			document.getElementById(span).innerHTML=id[1];
		} else {			
			document.getElementById(input).value="0";
			document.getElementById(span).innerHTML="";
		}
	}
</script>