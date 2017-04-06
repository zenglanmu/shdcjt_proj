<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.docs.*" %>
<%@ page import="java.net.URLEncoder" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="SplitPageUtil" class="weaver.general.SplitPageUtil" scope="page" />
<jsp:useBean id="SplitPageParaBean" class="weaver.general.SplitPageParaBean" scope="page" />

<%
    String URLFrom ="/proj/Maint/EditProjectType.jsp?"+request.getQueryString();
	String id = request.getParameter("id");
	String referenced = request.getParameter("referenced");

	RecordSet.executeProc("Prj_ProjectType_SelectByID",id);
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/proj/DBError.jsp?type=FindData");
		return;
	}
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/proj/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();
    boolean canEdit = HrmUserVarify.checkUserRight("EditProjectType:Edit",user);
    boolean canedit_share = HrmUserVarify.checkUserRight("EditProjectType:Edit",user);
    RecordSetShare.executeProc("Prj_T_ShareInfo_SbyRelateid",id);
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver.js">
		</SCRIPT>
	</HEAD>
	<%
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename="";
	if (canEdit) {
	    titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(586,user.getLanguage());
	} else {
	    titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(586,user.getLanguage());
	}
	String needfav ="1";
	String needhelp ="";
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle.jsp" %>
		<FORM id=weaver action="/proj/Maint/ProjectTypeOperation.jsp" method=post>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			if(HrmUserVarify.checkUserRight("EditProjectType:Edit", user)){
                RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
                RCMenuHeight += RCMenuHeightStep;
			%>
			<%
			}
			if(HrmUserVarify.checkUserRight("EditProjectType:Delete", user)){
                RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitDel(),_top} " ;
                RCMenuHeight += RCMenuHeightStep;
			}
			%>

            <%
			if(HrmUserVarify.checkUserRight("EditProjectType:Edit", user)){
                RCMenu += "{"+SystemEnv.getHtmlLabelName(92,user.getLanguage())+",javascript:location='AddProjectType.jsp',_top} " ;
                RCMenuHeight += RCMenuHeightStep;
            }

            RCMenu += "{"+SystemEnv.getHtmlLabelName(320,user.getLanguage())+",javascript:location='ListProjectType.jsp',_top} " ;
            RCMenuHeight += RCMenuHeightStep;

            RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
            RCMenuHeight += RCMenuHeightStep;
			%>

             
     
			<INPUT type="hidden" name="method" value="edit">
			<INPUT type="hidden" name="id" value="<%=id%>">
			<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<COLGROUP> 
				<COL width="10">
				<COL width="">
				<COL width="10">
				<TR>
					<TD height="10" colspan="3">
					</TD>
				</TR>
				<TR>
					<TD >
					</TD>
					<TD valign="top">
						<TABLE class=Shadow>
							<TR>
								<TD valign="top">
									<TABLE class=viewform>
										<COLGROUP>
										<COL width="100%">
										<TBODY>
											<TR>
												<TD vAlign=top>
													<TABLE class=viewform>
														<COLGROUP>
														<COL width="20%">
														<COL width="80%">
														<TBODY>
															<TR class=title>
																<TH>
																	<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
																</TH>
															</TR>
															<TR class=spacing style="height:1px;">
																<TD class=line1 colSpan=2>
																</TD>
															</TR>
															<TR>
																<TD>
																	<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
																</TD>
																<TD class=Field>
																	<% if(canEdit) {%>
																	<INPUT class=inputstyle maxLength=50 size=20 name="type" onchange='checkinput("type","typeimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>">
																	<SPAN id=typeimage>
																	</SPAN>
																	<%}else {%>
																	<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>
																	<%}%>
																</TD>
															</TR>
                                                            <TR class=Line style="height:1px;">
																<TD colspan="2" class="line">
																</TD>
															</TR>
															<TR>
																<TD>
																	<%=SystemEnv.getHtmlLabelName(18632,user.getLanguage())%>
																</TD>
																<TD class=Field>    
																	<%
                                                                    String typeCode = Util.null2String(RecordSet.getString("protypecode"));
                                                                    if(canEdit) { %> 
                                                                        <INPUT class=inputstyle name="txtTypeCode" VALUE="<%=typeCode%>">
																	<%}else {
																	    out.println(typeCode);
																	}%>
																</TD>
															</TR>
															<TR class=Line style="height:1px;">
																<TD colspan="2" class="line">
																</TD>
															</TR>
															<TR>
																<TD>
																	<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
																</TD>
																<TD class=Field>
																	<% if(canEdit) {%>
																	<INPUT class=inputstyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>">
																	<SPAN id=descimage>
																	</SPAN>
																	<%}else {%>
																	<%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%>
																	<%}%>
																</TD>
															</TR>
															<TR class=Line style="height:1px;">
																<TD class=Line colSpan=2>
																</TD>
															</TR>
															<TR>
																<TD>
																	<%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%>
																</TD>
																<TD class="Field">    
																	<%
																		String workflowname,wfid;
																		workflowname=Util.null2String(RecordSet.getString("workflowname"));
																		wfid = Util.null2String(RecordSet.getString("wfid"));
                                                                        if (canEdit){
                                                                    %>
                                                                    
																	<INPUT type=hidden name="approvewfid" class="wuiBrowser" value="<%=(wfid.equals("")||wfid.equals("0")?"":wfid)%>"
																		_displayText="<%=workflowname %>"
																		_url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=74"
																	>
                                                                   
                                                                    <%} else {
                                                                        out.println(workflowname);
                                                                      }%>

																</TD>

															</TR>
															<TR class=Line style="height:1px;">
																<TD class=Line colSpan=2>
																</TD>
															</TR>
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(20420,user.getLanguage())%></TD>
																<TD class="Field">
																	<input 
																		type="checkbox" 
																		name="insertWorkPlan" 
																		value="1" 
																		<%if(RecordSet.getString("insertWorkPlan").equals("1"))out.print("checked");%> />
																</td>
															</tr>
															<TR class=Line style="height:1px;"><TD class=Line colSpan=2></TD>
															</TR>
														</TBODY>
													</TABLE>
												</TD>
											</TR>
										</TBODY>
									</TABLE>

                                    <BR>
									<!--共享信息begin-->
									<TABLE class=viewform  valign="top">
										<COLGROUP>
										<COL width="20%">
										<COL width="70%">
										<COL width="10%">
										<TBODY>
											<TR class=title>
												<TH>
													<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage())%>
												</TH>
												<TD align=right colspan=2>
													<%
                          if(canedit_share){%>
                            <A href="/proj/data/AddTypeShare.jsp?itemtype=2&typeid=<%=id%>&prjtypename=<%=RecordSet.getString(2)%>">
                              <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>
                            </A>
													<%}%>
												</TD>
											</TR>
											<TR class=Line style="height:1px;">
												<TD colspan="2"  class=line >
												</TD>
											</TR>
											<TR class=spacing style="height:1px;">
												<TD class=line1 colSpan=3>
												</TD>
											</TR>
											<%
											if(RecordSetShare.first()){
											do{
												if(RecordSetShare.getInt("sharetype")==1)	{
											%>
											<TR>
												<TD>
													<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
												</TD>
												<TD class=Field>
													<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%>
													/
													<% if(RecordSetShare.getInt("sharelevel")==1){%>
													<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
													<%}else if(RecordSetShare.getInt("sharelevel")==2){%>
													<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
													<%}%>
												</TD>
												<TD class=Field align =right>
													<%if(canedit_share){%>
													<A href="/proj/data/TypeShareOperation.jsp?method=delete&typeid=<%=id%>&id=<%=RecordSetShare.getString("id")%>" onclick="return isdel()">
														<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
													</A>
													<%}%>
												</TD>
											</TR>
											<TR class=spacing style="height:1px;">
												<TD class=line colSpan=3>
												</TD>
											</TR>
											<%}else if(RecordSetShare.getInt("sharetype")==2)	{%>
											<TR>
												<TD>
													<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
												</TD>
												<TD class=Field>
													<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%>
													/
													<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
													:
													<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>
													/
													<% if(RecordSetShare.getInt("sharelevel")==1){%>
													<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
													<%}else if(RecordSetShare.getInt("sharelevel")==2){%>
													<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
													<%}%>
												</TD>
												<TD class=Field align =right>
													<%if(canedit_share){%>
													<A href="/proj/data/TypeShareOperation.jsp?method=delete&typeid=<%=id%>&id=<%=RecordSetShare.getString("id")%>"  onclick="return isdel()">
														<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
													</A>
													<%}%>
												</TD>
											</TR>
											<TR class=spacing style="height:1px;">
												<TD class=line colSpan=3>
												</TD>
											</TR>
											<%}else if(RecordSetShare.getInt("sharetype")==3)	{%>
											<TR>
												<TD>
													<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
												</TD>
												<TD class=Field>
													<%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSetShare.getString("roleid")),user.getLanguage())%>
													/
													<% if(RecordSetShare.getInt("rolelevel")==0){%>
													<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
													<%}%>
													<% if(RecordSetShare.getInt("rolelevel")==1){%>
													<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
													<%}%>
													<% if(RecordSetShare.getInt("rolelevel")==2){%>
													<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
													<%}%>
													/
													<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
													:
													<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>
													/
													<% if(RecordSetShare.getInt("sharelevel")==1){%>
													<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
													<%}else if(RecordSetShare.getInt("sharelevel")==2){%>
													<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
													<%}%>
												</TD>
												<TD class=Field align =right>
													<%if(canedit_share){%>
													<A href="/proj/data/TypeShareOperation.jsp?method=delete&typeid=<%=id%>&id=<%=RecordSetShare.getString("id")%>"  onclick="return isdel()">
														<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
													</A>
													<%}%>
												</TD>
											</TR>
											<TR class=spacing style="height:1px;">
												<TD class=line colSpan=3>
												</TD>
											</TR>
											<%}else if(RecordSetShare.getInt("sharetype")==4)	{%>
											<TR>
												<TD>
													<%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
												</TD>
												<TD class=Field>
													<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
													:
													<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>
													/
													<% if(RecordSetShare.getInt("sharelevel")==1){%>
													<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
													<%}else if(RecordSetShare.getInt("sharelevel")==2){%>
													<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
													<%}%>
												</TD>
												<TD class=Field align =right>
													<%if(canedit_share){%>
													<A href="/proj/data/TypeShareOperation.jsp?method=delete&typeid=<%=id%>&id=<%=RecordSetShare.getString("id")%>"  onclick="return isdel()">
														<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
													</A>
													<%}%>
												</TD>
											</TR>
											<TR class=spacing style="height:1px;">
												<TD class=line colSpan=3>
												</TD>
											</TR>
											<%}%>
											<%}while(RecordSetShare.next());
											}
											%>
										</TBODY>
									</TABLE>

                                    <BR>
                                    
                                   <!--自定义字段部分-->                                    
                                     <SCRIPT LANGUAGE=javascript>
                                        function addrow(){
                                            var oRow;
                                            var oCell;

                                            oRow = inputface.insertRow(-1);
                                            oCell = oRow.insertCell(-1);
                                            oCell.style.borderBottom="silver 1pt solid";
                                            oCell.innerHTML = flable.innerHTML ;
                                            oCell = oRow.insertCell(-1);
                                            oCell.style.borderBottom="silver 1pt solid";
                                            oCell.innerHTML = fhtmltype.innerHTML;
                                            oCell = oRow.insertCell(-1);
                                            oCell.style.borderBottom="silver 1pt solid";
                                            oCell.innerHTML = ftype1.innerHTML ;
                                            oCell = oRow.insertCell(-1);
                                            oCell.style.borderBottom="silver 1pt solid";
                                            oCell.innerHTML = ftype5.innerHTML ;
                                            oCell = oRow.insertCell(-1);
                                            oCell.style.borderBottom="silver 1pt solid";
                                            oCell.innerHTML = fismand.innerHTML ;
                                            oCell = oRow.insertCell(-1);
                                            oCell.style.borderBottom="silver 1pt solid";
                                            oCell.innerHTML = action.innerHTML ;

                                        }

                                        function addrow2(obj){
                                            var tobj = $($(obj).parent().parent()[0].cells[3]).find("table")[0];
                                            var oRow;
                                            var oCell;
                                            oRow = tobj.insertRow(-1);
                                            oCell = oRow.insertCell(-1);
                                            oCell.innerHTML = fselectitem.innerHTML ;
                                            oCell = oRow.insertCell(-1);
                                            oCell.innerHTML = itemaction.innerHTML ;

                                        }

                                        function delitem(obj){
                                            var rowobj = obj.parentElement.parentElement;

                                            rowobj.parentElement.deleteRow(rowobj.rowIndex);

                                        }

                                        function upitem(obj){
                                            if(obj.parentElement.parentElement.rowIndex==0){
                                                return;
                                            }
                                            var tobj = obj.parentElement.parentElement.parentElement;
                                            var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex-1);
                                            for(var i=0; i<2; i++){
                                                var cellobj = rowobj.insertCell(-1)
                                                cellobj.style.borderBottom="silver 1pt solid";
                                                var temCell=obj.parentElement.parentElement.cells[i];
                                                var temVal="";
                                                if($(temCell).find("input").length>0){
                                                	temVal=$(temCell).find("input")[1].value;
                                                }
                                                cellobj.innerHTML = temCell.innerHTML;
                                                if($(temCell).find("input").length>0){
                                                     $(cellobj).find("input").val(temVal);
                                                }
                                            }

                                            tobj.deleteRow(obj.parentElement.parentElement.rowIndex);

                                        }

                                        function downitem(obj){
                                            if(obj.parentElement.parentElement.rowIndex==obj.parentElement.parentElement.parentElement.rows.length-1){
                                                return;
                                            }
                                            var tobj = obj.parentElement.parentElement.parentElement;
                                            var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex+2);
                                            for(var i=0; i<2; i++){
                                                var cellobj = rowobj.insertCell(-1)
                                                var temCell=obj.parentElement.parentElement.cells[i];
                                                var temVal="";
                                                if($(temCell).find("input").length>0){
                                                	temVal=$(temCell).find("input")[1].value;
                                                }
                                                cellobj.style.borderBottom="silver 1pt solid";
                                                cellobj.innerHTML = temCell.innerHTML;
                                                if($(temCell).find("input").length>0){
                                                     $(cellobj).find("input").val(temVal);
                                                }
                                            }

                                            tobj.deleteRow(obj.parentElement.parentElement.rowIndex);

                                        }

                                        function del(obj){
                                            var rowobj = obj.parentElement.parentElement;

                                            rowobj.parentElement.deleteRow(rowobj.rowIndex);

                                        }

                                        function up(obj){
                                            if(obj.parentElement.parentElement.rowIndex==0){
                                                return;
                                            }
                                            var tobj = obj.parentElement.parentElement.parentElement;
                                            var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex-1);
                                            for(var i=0; i<6; i++){
                                                var cellobj = rowobj.insertCell(-1)
                                                cellobj.style.borderBottom="silver 1pt solid";
                                                var temCell=obj.parentElement.parentElement.cells[i];
                                                var temVal="";
                                                if($(temCell).find("input").length>0){
                                                	temVal=$(temCell).find("input")[0].value;
                                                }
                                                 if($(temCell).find("select").length>0){
                                                	temVal=$(temCell).find("select")[0].options[$(temCell).find("select")[0].selectedIndex].value
                                                }
                                                cellobj.innerHTML = temCell.innerHTML;
                                                if($(temCell).find("input").length>0){
                                                	 $(cellobj).find("input").val(temVal);
                                                }
                                                 if($(temCell).find("select").length>0){
                                                	 $(cellobj).find("select").val(temVal);
                                                }
                                            }

                                            tobj.deleteRow(obj.parentElement.parentElement.rowIndex);

                                        }

                                        function down(obj){
                                            if(obj.parentElement.parentElement.rowIndex==obj.parentElement.parentElement.parentElement.rows.length-1){
                                                return;
                                            }
                                            var tobj = obj.parentElement.parentElement.parentElement;
                                            var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex+2);
                                            
                                            for(var i=0; i<6; i++){
                                                var cellobj = rowobj.insertCell(-1)
                                                cellobj.style.borderBottom="silver 1pt solid";
                                                var temCell=obj.parentElement.parentElement.cells[i];
                                                var temVal="";
                                                if($(temCell).find("input").length>0){
                                                	temVal=$(temCell).find("input")[0].value;
                                                }
                                                 if($(temCell).find("select").length>0){
                                                	temVal=$(temCell).find("select")[0].options[$(temCell).find("select")[0].selectedIndex].value
                                                }
                                                cellobj.innerHTML = temCell.innerHTML;
                                                if($(temCell).find("input").length>0){
                                                	 $(cellobj).find("input").val(temVal);
                                                }
                                                 if($(temCell).find("select").length>0){
                                                	 $(cellobj).find("select").val(temVal);
                                                }
                                            }

                                            tobj.deleteRow(obj.parentElement.parentElement.rowIndex);

                                        }

                                        function htmltypeChange(obj){
                                            if(obj.selectedIndex == 0){
                                                obj.parentElement.parentElement.cells[2].innerHTML=ftype1.innerHTML ;
                                                obj.parentElement.parentElement.cells[3].innerHTML=ftype5.innerHTML ;
                                            }else if(obj.selectedIndex == 2){
                                                obj.parentElement.parentElement.cells[2].innerHTML=ftype2.innerHTML ;
                                                obj.parentElement.parentElement.cells[3].innerHTML=ftype4.innerHTML ;
                                            }else if(obj.selectedIndex == 4){
                                                obj.parentElement.parentElement.cells[2].innerHTML=fselectaction.innerHTML ;
                                                obj.parentElement.parentElement.cells[3].innerHTML=fselectitems.innerHTML ;
                                            }else{
                                                obj.parentElement.parentElement.cells[2].innerHTML=ftype3.innerHTML ;
                                                obj.parentElement.parentElement.cells[3].innerHTML=ftype4.innerHTML ;
                                            }
                                        }

                                        function typeChange(obj){
                                            if(obj.selectedIndex == 0){
                                                obj.parentElement.parentElement.cells[3].innerHTML=ftype5.innerHTML ;
                                            }else{
                                                obj.parentElement.parentElement.cells[3].innerHTML=ftype4.innerHTML ;
                                            }
                                        }

                                        function clearTempObj(){
                                            flable.innerHTML="";
                                            fhtmltype.innerHTML="";
                                            ftype1.innerHTML="";
                                            ftype2.innerHTML="";
                                            ftype3.innerHTML="";
                                            ftype4.innerHTML="";
                                            ftype5.innerHTML="";
                                            fselectaction.innerHTML="";
                                            fselectitems.innerHTML="";
                                            fselectitem.innerHTML="";
                                            fismand.innerHTML="";
                                        }

                                        var selectRowObj;
                                        function importSel(obj){
                                            selectRowObj = obj;
                                            //id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CustomSelectFieldBrowser.jsp");
                                            var ret = showSelectRow();
                                            if(ret != ""){
                                                document.all("selectItemGetter").src="/docs/category/SelectRowGetter.jsp?fieldid="+ret;
                                            }
                                        }

                                        </SCRIPT>

                                        <script language="VbScript">
                                        function showSelectRow()
                                            id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CustomSelectFieldBrowser.jsp")
                                            if (Not IsEmpty(id)) then
                                                showSelectRow=id(0)
                                            else
                                                showSelectRow=""
                                            end if
                                        end function
                                        </script>
                                        <iframe name="selectItemGetter" style="width:100%;height:200;display:none"></iframe>
                                        <%
                                            String disableLable = "disabled";
                                            if(canEdit){
                                                disableLable="";
                                        %>                                        
                                        <%
                                            }
                                        %>
                                    <div id="allHiddenDiv">
                                        <div style="DISPLAY: none" id="flable">
                                        <%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>:<input  class=InputStyle name="fieldlable"><input  type="hidden" name="fieldid" value="-1">
                                        </div>

                                        <div style="DISPLAY: none" id="fhtmltype">
                                            <%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>:
                                            <select size="1" name="fieldhtmltype" onChange = "htmltypeChange(this)">
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
                                                <option value="2" ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
                                                <option value="3" ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
                                                <option value="4" ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
                                                <option value="5" ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
                                            </select>
                                        </div>

                                        <div style="DISPLAY: none" id="ftype1">
                                            <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
                                            <select size=1 name=customeType onChange = "typeChange(this)">
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
                                            </select>
                                        </div>

                                        <div style="DISPLAY: none" id="ftype2">
                                            <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
                                            <select size=1 name=customeType>
                                            <%while(BrowserComInfo.next()){
                                            			if("224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())||"226".equals(BrowserComInfo.getBrowserid())||"227".equals(BrowserComInfo.getBrowserid())){
                                            				continue;
                                            			}
                                            		
                                            %>
                                                <option value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),7)%></option>
                                            <%}%>
                                            </select>
                                        </div>

                                        <div style="DISPLAY: none" id="ftype3">
                                            <input name=customeType type=hidden value="0">
                                        </div>

                                        <div style="DISPLAY: none" id="ftype4">
                                            <input name=flength type=hidden  value="100">
                                        </div>

                                        <div style="DISPLAY: none" id="ftype5">
                                            <%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>:<input  class=InputStyle name=flength type=text value="100" maxlength=4 style="width:50">
                                        </div>

                                        <div style="DISPLAY: none" id="fismand">
                                            <%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>:
                                            <select size=1 name=ismand>
                                                <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
                                                <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
                                            </select>
                                        </div>

                                        <div style="DISPLAY: none" id="fselectaction">
                                            <input name=customeType type=hidden  value="0">
                                            <button type="button" Class=Btn type=button accessKey=A onclick="addrow2(this)"><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></BUTTON><br>
                                            <button type="button" Class=Btn type=button accessKey=I onclick="importSel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></BUTTON>
                                        </div>
                                        <div style="DISPLAY: none" id="fselectitems">
                                            <TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 >
                                            <COLGROUP>
                                                <col width="40%">
                                                <col width="60%">
                                            </COLGROUP>
                                            </TABLE>
                                            <input name=selectitemid type=hidden value="--">
                                            <input name=selectitemvalue type=hidden >

                                            <input name=flength type=hidden  value="100">
                                        </div>

                                        <div style="DISPLAY: none" id="fselectitem">
                                            <input name=selectitemid type=hidden value="-1" >
                                            <input  class=InputStyle name=selectitemvalue type=text style="width:100">
                                        </div>

                                        <div style="DISPLAY: none" id="itemaction">
                                            <img src="/images/icon_ascend.gif" height="14" onclick="upitem(this)">
                                            <img src="/images/icon_descend.gif" height="14" onclick="downitem(this)">
                                            <img src="/images/delete.gif" height="14" onclick="delitem(this)">
                                        </div>

                                        <div style="DISPLAY: none" id="action">
                                            <img src="/images/icon_ascend.gif" height="14" onclick="up(this)">
                                            <img src="/images/icon_descend.gif" height="14" onclick="down(this)">
                                            <img src="/images/delete.gif" height="14" onclick="del(this)">
                                        </div>
                                     </div>

                                     <TABLE CLASS="viewform" valign="top">  
                                        <TR CLASS="title"><TH width="80%"><%=SystemEnv.getHtmlLabelName(17037,user.getLanguage())%></TH>
                                        <TD width="20%" align="right"><%if(canEdit){%><a href="javaScript:addrow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><%}%></TD></TR>
                                        <TR style="height:1px;"><TD CLASS="line1" colspan="2"></TD></TR>                                        
                                    </TABLE>
                                        <%
                                             CustomFieldManager cfm = new CustomFieldManager("ProjCustomField",Util.getIntValue(id));
                                             cfm.getCustomFields();
                                        %>
                                        <TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 id="inputface">
                                        <COLGROUP>
                                            <col width="23%" valign="top">
                                            <col width="20%" valign="top">
                                            <col width="22%" valign="top">
                                            <col width="18%" valign="top">
                                            <col width="10%" valign="top">
                                            <col width="7%" valign="top">
                                            <%while(cfm.next()){%>
                                            <tr>
                                            <td style="border-bottom:silver 1pt solid"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>:<input  class=InputStyle name="fieldlable" value="<%=cfm.getLable()%>" <%=disableLable%>><input  type="hidden" name="fieldid" value="<%=cfm.getId()%>" ></td>
                                            <td style="border-bottom:silver 1pt solid">
                                            <%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>:
                                            <%if(cfm.getHtmlType().equals("1")){%>
                                                <%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%>
                                            <%} else if(cfm.getHtmlType().equals("2")){%>
                                                <%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%>
                                            <%} else if(cfm.getHtmlType().equals("3")){%>
                                                <%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>
                                            <%} else if(cfm.getHtmlType().equals("4")){%>
                                                <%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%>
                                            <%} else if(cfm.getHtmlType().equals("5")){%>
                                                <%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%>
                                            <%} %>
                                            <input name="fieldhtmltype" type="hidden" value="<%=cfm.getHtmlType()%>" >
                                            </td>

                                            <%if(cfm.getHtmlType().equals("1")){%>
                                                <td style="border-bottom:silver 1pt solid">
                                                <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
                                                <%if(cfm.getType() == 1){%>
                                                    <%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%>
                                                <%} else if(cfm.getType() == 2){%>
                                                    <%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%>
                                                <%} else if(cfm.getType() == 3){%>
                                                    <%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%>
                                                <%} %>
                                                <input name=customeType type="hidden" value="<%=cfm.getType()%>">
                                                </td>
                                                <td style="border-bottom:silver 1pt solid">
                                                    <%if(cfm.getType()==1){%>
                                                        <%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>:<%=cfm.getStrLength()%>
                                                        <input  name=flength type=hidden  value="<%=cfm.getStrLength()%>">
                                                    <%}else{%>
                                                        <input name=flength type=hidden  value="100">
                                                    <%}%>
                                                </td>
                                            <%}else if(cfm.getHtmlType().equals("3")){%>
                                                <td style="border-bottom:silver 1pt solid">
                                                    <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(String.valueOf(cfm.getType())),0),7)%>
                                                    <input name=customeType type="hidden" value="<%=cfm.getType()%>">
                                                </td>
                                                <td style="border-bottom:silver 1pt solid">
                                                    <input name=flength type=hidden  value="100">
                                                </td>
                                            <%}else if(cfm.getHtmlType().equals("5")){%>
                                                <td style="border-bottom:silver 1pt solid">
                                                    <input name=customeType type=hidden  value="0">
                                        <%
                                            if(canEdit){
                                        %>
                                                    <button type="button" Class=Btn type=button accessKey=A onclick="addrow2(this)"><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></BUTTON><br>
                                                    <button type="button" Class=Btn type=button accessKey=I onclick="importSel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></BUTTON>
                                        <%
                                            }
                                        %>
                                                </td>
                                                <td style="border-bottom:silver 1pt solid">

                                                    <TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 >
                                                    <COLGROUP>
                                                        <col width="40%">
                                                        <col width="60%">
                                                    </COLGROUP>
                                             <%
                                                cfm.getSelectItem(cfm.getId());
                                                while(cfm.nextSelect()){
                                             %>
                                                <tr>
                                                    <td>
                                                        <input name=selectitemid type=hidden value="<%=cfm.getSelectValue()%>" >
                                                        <input  class=InputStyle name=selectitemvalue type=text value="<%=cfm.getSelectName()%>" style="width:100"  <%=disableLable%>>
                                                    </td>
                                                    <td>
                                                       <%if (canEdit)%> <img src="/images/icon_ascend.gif" height="14" onclick="upitem(this)">
                                                        <%if (canEdit)%><img src="/images/icon_descend.gif" height="14" onclick="downitem(this)">
                                                        <%if (canEdit)%> <img src="/images/delete.gif" height="14" onclick="delitem(this)">
                                                    </td>
                                                </tr>

                                             <%}%>

                                                    </TABLE>
                                                    <input name=selectitemid type=hidden value="--">
                                                    <input name=selectitemvalue type=hidden >

                                                    <input name=flength type=hidden  value="100">
                                                </td>
                                            <%}else{%>
                                                <td style="border-bottom:silver 1pt solid">
                                                    <input name=customeType type=hidden  value="0">
                                                </td>
                                                <td style="border-bottom:silver 1pt solid">
                                                    <input name=flength type=hidden  value="100">
                                                </td>
                                            <%}%>
                                            <%%>
                                                <td style="border-bottom:silver 1pt solid">
                                                    <%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>:
                                                    <select size=1 name=ismand  <%=disableLable%>>
                                                        <option value="0" <%=cfm.isMand()?"":"selected"%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
                                                        <option value="1" <%=cfm.isMand()?"selected":""%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
                                                    </select>
                                                </td>
                                            <%if (canEdit){%>
                                              
                                                <td style="border-bottom:silver 1pt solid">
                                                    <img src="/images/icon_ascend.gif" height="14" onclick="up(this)">
                                                    <img src="/images/icon_descend.gif" height="14" onclick="down(this)">
                                                    <img src="/images/delete.gif" height="14" onclick="del(this)">
                                                </td>
                                            
                                            <%} else {%>
                                                <td style="border-bottom:silver 1pt solid">
                                                   &nbsp;&nbsp;
                                                </td>
                                            <%}%>
                                            </tr>
                                            <%}%>
                                        </COLGROUP>
                                        </TABLE>
                                   <!--自定义字段结束-->
                                   <BR>
                                   <!--模板部分--->
                                   <a name="templet" id="templet"></a>
                                    <TABLE CLASS="viewform" valign="top">  
                                        <TR CLASS="title"><TH width="80%"><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></TH>
                                        <TD width="20%" align="right">
                                        <%if (HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {%><a href="javaScript:onAddTemplet()"><%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%></a>&nbsp;&nbsp;<a href="javaScript:onCancelTemplet()"><%=SystemEnv.getHtmlLabelName(18633,user.getLanguage())%></a><%}%></TD></TR>
                                        <TR style="height:1px;"><TD CLASS="line1" colspan="2"></TD></TR>                                        
                                    </TABLE>
                                    <TABLE CLASS="ListStyle" valign="top">      
                                    <colgroup>
                                    <col width="25%">
                                    <col width="40%">
												<col width="15%">
                                    <col width="15%">
                                    <col width="5%">
                                    <TR CLASS="header">
                                            <TD><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></TD>
                                            <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>  
														  <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
                                            <TD><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())%></TD>
                                            <%if(canEdit) {%><TD></TD><%}%>
                                      </TR>  
                                       <TR CLASS="LINE" style="height:1px;"><TD COLSPAN="5" style="padding:0;"></TD></TR>
                                      <%
                                        SplitPageParaBean.setBackFields("id,templetName,isSelected,templetDesc,status");
                                        SplitPageParaBean.setSqlFrom("Prj_Template");
                                        SplitPageParaBean.setSqlWhere("proTypeId="+id);
                                        SplitPageParaBean.setPrimaryKey("id");
                                        SplitPageParaBean.setSortWay(SplitPageParaBean.DESC);
                                        
                                        SplitPageUtil.setSpp(SplitPageParaBean);
                                        RecordSet = SplitPageUtil.getAllRs();
													 String projTemplateIDs = "";
													 String projTemplateStatusOld = "";
                                        while (RecordSet.next()) {
                                            String templetId = Util.null2String(RecordSet.getString("id")) ;
														  projTemplateIDs += templetId + ",";
														  projTemplateStatusOld += RecordSet.getString("status") + ",";
                                            out.println("<TR class='DataLight'>");
                                            out.println("   <TD><a href='/proj/Templet/ProjTempletView.jsp?templetId="+templetId+"'>"+Util.null2String(RecordSet.getString("templetName"))+"</a></TD>");
                                            out.println("   <TD>"+Util.null2String(RecordSet.getString("templetDesc"))+"</TD>");
														  //=============================================================================
														  //Status 1:正常 0:草稿 2:正常待审批 3:草稿退回
														  //added by hubo,20060226
														  out.println("<td>");
														  if(RecordSet.getString("status").equals("0")){
																out.println("<select style='width:70px' name='projTemplateStatus'>");
																out.println("<option value='0' selected>"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"</option>");
																out.println("<option value='1' style='color:green'>"+SystemEnv.getHtmlLabelName(225,user.getLanguage())+"</option>");
																out.println("</select>");
														  }else if(RecordSet.getString("status").equals("1")){
																out.println("<select style='width:70px' name='projTemplateStatus'>");
																out.println("<option value='0'>"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"</option>");
																out.println("<option value='1' style='color:green' selected>"+SystemEnv.getHtmlLabelName(225,user.getLanguage())+"</option>");
																out.println("</select>");
														  }else if(RecordSet.getString("status").equals("2")){
																out.println("<select style='width:70px' name='projTemplateStatus' disabled='true'>");
																out.println("<option value='0'>"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"</option>");
																out.println("<option value='2' selected>"+SystemEnv.getHtmlLabelName(225,user.getLanguage())+"</option>");
																out.println("</select>");
																out.println("<span style='color:red'>"+SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"</span>");
														  }else if(RecordSet.getString("status").equals("3")){
																out.println("<select style='width:70px' name='projTemplateStatus'>");
																out.println("<option value='3' selected>"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"</option>");
																out.println("<option value='1' style='color:green'>"+SystemEnv.getHtmlLabelName(225,user.getLanguage())+"</option>");
																out.println("</select>");
																out.println("<span style='color:red'>"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"</span>");
														  }
														  out.println("</td>");
														  //=============================================================================
														  out.println("<td>");
														  if(RecordSet.getString("status").equals("1")){
                                            if (RecordSet.getInt("isSelected")==1){
                                                out.println("<input type='radio' name='rdoTemplet' checked  value='"+templetId+"'>");
                                            } else {
                                                out.println("<input type='radio' name='rdoTemplet' value='"+templetId+"'>");
                                            }   
														  }
														  out.println("</td>");
                                            if(canEdit) out.println("   <TD><img src='/images/icon_delete.gif' border=0 style='cursor:hand' onclick=\"onDelTemlet(\'"+Util.null2String(RecordSet.getString("id"))+"\')\"></TD>");   
                                            out.println("</TR>");
                                            out.println(" <TR CLASS='LINE'  style='height:1px;'><TD COLSPAN='5'></TD></TR>");
                                        }
                                      %>
                                        
                                    </TABLE>
                                   
								</TD>
							</TR>
						</TABLE>
					</TD>
					<TD>
					</TD>
				</TR>
				<TR>
					<TD height="10" colspan="3">
					</TD>
				</TR>
			</TABLE>
		<input type="hidden" name="projTemplateIDs" value="<%=projTemplateIDs%>">
		<input type="hidden" name="projTemplateStatusNew">
		<input type="hidden" name="projTemplateStatusOld" value="<%=projTemplateStatusOld%>">
		</FORM>       
		<%@ include file="/systeminfo/RightClickMenu.jsp" %>
		<SCRIPT language="javascript">
		    //add by dongping for Fixed BUG694
			if ("<%=referenced%>"=="yes") {
			    alert("<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>") ;
             }

			function submitData(){
				//
				var o = document.getElementsByName("projTemplateStatus");
				var tempStatus = "";
				for(var i=0;i<o.length;i++){
					tempStatus += o[i].options[o[i].selectedIndex].value + ",";
				}
				$("input[name=projTemplateStatusNew]").val(tempStatus);
				 if (check_form(weaver,'type,desc,approvewfid')) {
					  document.getElementById("allHiddenDiv").innerHTML='';
					  weaver.submit();
				 }
			}
			function submitDel() {
                if(isdel()){
                    document.all("method").value="delete" ;
                    weaver.submit();
                }
			}
            function onCancelTemplet(){
                var rdoObjs = document.getElementsByName("rdoTemplet");
                for(var i=0;i<rdoObjs.length;i++) {
                    var rdoObj = rdoObjs[i];
                    rdoObj.checked = false ;
                }
            }
            function onAddTemplet(){
                var Url = "<%=URLEncoder.encode("/proj/Maint/EditProjectType.jsp?id="+id+"&txtPrjType="+id)%>";
                window.location="/proj/Templet/ProjTempletAdd.jsp?URLFrom="+Url+"&txtPrjType=<%=id%>";
            }
            function onDelTemlet(templetId){
                if (templetId=="")  return false ;
                if (isdel()){
                     var Url = "<%=URLEncoder.encode("/proj/Maint/EditProjectType.jsp?id="+id+"&txtPrjType="+id)%>";
                     window.location="/proj/Templet/ProjTempletOperate.jsp?URLFrom="+Url+"&method=delete&templetId="+templetId;
                }
            }
		</SCRIPT>
	
	</BODY>
</HTML>
