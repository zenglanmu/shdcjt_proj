<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>    
</head>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(30055,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);
int isadd = Util.getIntValue(Util.null2String(request.getParameter("isadd")),0);
int modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")),0);
int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);



int initmodeid = Util.getIntValue(Util.null2String(request.getParameter("initmodeid")),0);
int initworkflowid = Util.getIntValue(Util.null2String(request.getParameter("initworkflowid")),0);
if(isadd==1){
	modeid = initmodeid;
	//workflowid = initworkflowid;
}


String modename = "";
String sql = "";
int modeformid = 0;
int wfformid = 0;
int modecreater = 0;
int modecreaterfieldid = 0;
int triggerNodeId = 0;
int triggerType = 0;
int isenable = 0;
sql = "select * from mode_workflowtomodeset where id = " + id;
rs.executeSql(sql);
while(rs.next()){
	modeid = rs.getInt("modeid");
	workflowid = rs.getInt("workflowid");
	id = rs.getInt("id");
	modecreater = rs.getInt("modecreater");
	modecreaterfieldid = rs.getInt("modecreaterfieldid");
	wfformid = Util.getIntValue(WorkflowComInfo.getFormId(String.valueOf(workflowid)));
	triggerNodeId = rs.getInt("triggerNodeId");
	triggerType = rs.getInt("triggerType");
	isenable = rs.getInt("isenable");
}

if(modeid>0){
	sql = "select modename,formid from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		modename = Util.null2String(rs.getString("modename"));
		modeformid = rs.getInt("formid");
	}
}
if(modename.equals("")){
	modename = "<img src=\"/images/BacoError.gif\" align=\"absmiddle\">";
}

HashMap existsMap = new HashMap();
sql = "select * from mode_workflowtomodesetdetail where mainid = " + id;
rs.executeSql(sql);
while(rs.next()){
	String modefieldid = rs.getString("modefieldid");
	String wffieldid = rs.getString("wffieldid");
	String key = modefieldid+"_"+wffieldid;
	existsMap.put(key,key);
	existsMap.put(modefieldid,wffieldid);
}

//显示基础设置
String displaystr = "";
if(workflowid<=0){
	displaystr = "style=\"display:none\"";
}

if(modeid>0&&workflowid>0){
	titlename = SystemEnv.getHtmlLabelName(30055,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(19342,user.getLanguage());
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

if(isadd!=1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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

<form name="frmSearch" method="post" action="/formmode/interfaces/WorkflowToModeSetOperation.jsp">
	<input name="operation" value="save" type="hidden">
	<input name="id" value="<%=id%>" type="hidden">
	
	<input name="initmodeid" value="<%=initmodeid%>" type="hidden">
	<input name="initworkflowid" value="<%=initworkflowid%>" type="hidden">
	
	<table class="ViewForm">
		<COLGROUP>
			<COL width="35%">
			<COL width="65%">
		</COLGROUP>
		<TR>
			<TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></B></TD>
		</TR>
		<tr style="height:1px"><td colspan=4 class=Line1></td></tr>

		<tr <%=displaystr%>>
			<td>
				<%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%>
			</td>
			<td class=Field>
				<input class="inputstyle" id="isenable" name="isenable" type="checkbox" value="1" <%if(isenable==1)out.println("checked");%>>
			</td>

		</tr>
		<tr  <%=displaystr%> style="height:1px"><td colspan=4 class=Line></td></tr>
		
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>
			</td>
			<td class=Field>
				<input class="wuiBrowser" id="workflowid" _required="yes" name="workflowid" type="hidden" value="<%=workflowid==0?"":String.valueOf(workflowid)%>" _displayText="<%=WorkflowComInfo.getWorkflowname(String.valueOf(workflowid))%>" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isbill=1 and formid<0">
			</td>

		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
		
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%>
			</td>
			<td class="Field">
		  		 <button type="button" class="browser Browser" id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></button><span id=modeidspan><%=modename%></span>
		  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
	</table>
	
	<table class="ViewForm" <%=displaystr%>>
		<COLGROUP>
			<COL width="35%">
			<COL width="65%">
		</COLGROUP>

		<TR>
			<TD>
				<%=SystemEnv.getHtmlLabelName(19346,user.getLanguage())%>
			</TD>                                            
			<TD class="field">                                           
				<SELECT class=InputStyle name="triggerNodeId">    
					<%
						rs.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and  a.workFlowId= "+workflowid+"  order by a.nodeType,a.nodeId  ");
						while(rs.next()) {
							int temptriggerNodeId = rs.getInt("triggerNodeId");
							String triggerNodeName = Util.null2String(rs.getString("triggerNodeName"));
							boolean selected = (temptriggerNodeId==triggerNodeId);
							String selectedstr = "";
							if(selected){
								selectedstr = "selected";
							}
					%>
							<option value="<%=temptriggerNodeId%>" <%=selectedstr%>><%=triggerNodeName%></option>
					<%
						}
					%>
				</SELECT>                                        
			</TD>		
		</TR>

		<TR  style="height:1px;">
		    <TD class=Line colSpan=2></TD>
		</TR>
		<TR>
			<TD>
				<%=SystemEnv.getHtmlLabelName(19347,user.getLanguage())%>
			</TD>                                            
			<TD class="field">                                           
				<SELECT class=InputStyle  name="triggerType">   
					<option value="1" <%if(triggerType==1)out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19348,user.getLanguage())%></option> 
					<option value="0" <%if(triggerType==0)out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19349,user.getLanguage())%></option>
				</SELECT>                                        
			</TD>		
		</TR>
		<TR id=trTriggerTimeLine style="height:1px;">
			<TD class=Line colSpan=2></TD>
		</TR>
		
		<TR>
			<TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(28597,user.getLanguage())%></B></TD>
		</TR>								
		<TR class=Spacing style="height:1px;">
			<TD class=Line1 colSpan=2></TD>
		</TR>
		<TR>
			<TD>
				<%=SystemEnv.getHtmlLabelName(28607,user.getLanguage())%>
			</TD>                                            
			<TD class="field">
				<input type=radio name=modecreater id=modecreater value="1" 
				<%
				    if(modecreater<=0||modecreater==1){
				%>
						checked
				<%
					}
				%>
				>
			</TD>
		</TR>
		<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
		<TR>
			<TD>
			   <%=SystemEnv.getHtmlLabelName(28595,user.getLanguage())%>
			</TD>                                            
			<TD class="field"> 
				<input type=radio name=modecreater id=modecreater value="2" 
				<%
				    if(modecreater==2){
				%>
						checked
				<%
				    }
				%>
				>			
			</TD>		
		</TR>
		<TR style="height:1px;">
		    <TD class=Line colSpan=2></TD>
		</TR>
		<TR>
			<TD>
				<%=SystemEnv.getHtmlLabelName(28608 ,user.getLanguage())%>
			</TD>                                            
			<TD class="field"> 
				<input type=radio name=modecreater id=modecreater value="3"
				<%
				    if(modecreater==3){
				%>
						checked
				<%
				    }
				%>										 
				>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<select class=inputstyle  name=modecreaterfieldid id="modecreaterfieldid">
				<%
					int fieldId= 0;
					//sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid="+ wfformid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=141 or type=142 or type=166) " ;
					sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid="+ wfformid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=166) " ;
					rs.executeSql(sql);
					while(rs.next()){
						fieldId=rs.getInt("id");
				%>
						<option value=<%=fieldId%> 
				<%
						if(fieldId==modecreaterfieldid){
				%>
							selected
				<%
				    	}
				%>
				>
						<%=SystemEnv.getHtmlLabelName(rs.getInt("name"),user.getLanguage())%>
						</option>
				<%
					}
				%>
				</select>
			</TD>		
		</TR>
		<TR class=Spacing style="height:1px;">
			<TD class=Line colSpan=2></TD>
		</TR>
	</table>
	<%
		int modedetailno = 0;
		HashMap optionMap = new HashMap();
		
		HashMap modeFieldIdMap = new HashMap();
		HashMap modeLabelNameMap = new HashMap();
		
		ArrayList modeFieldIdList = new ArrayList();
		ArrayList modeLabelNameList = new ArrayList();
		
		ArrayList modeDetailFieldIdList = new ArrayList();
		ArrayList modeDetailLabelNameList = new ArrayList();		
		
		if(modeid>0&&workflowid>0){
			modeFieldIdList.add("-1");
			modeLabelNameList.add("请求标题");
			
			modeFieldIdList.add("-2");
			modeLabelNameList.add("请求Id");
			
			//模块表单字段信息
			String tempdetailtable = "";
			sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where billid = " + wfformid + " order by viewtype asc,detailtable asc,id asc";
			rs.executeSql(sql);
			while(rs.next()){
				String fieldid = Util.null2String(rs.getString("id"));
				String fieldname = Util.null2String(rs.getString("fieldname"));
				String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
				String fielddbtype = Util.null2String(rs.getString("fielddbtype"));
				String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
				String type = Util.null2String(rs.getString("type"));
				String viewtype = Util.null2String(rs.getString("viewtype"));
				String detailtable = Util.null2String(rs.getString("detailtable"));
				String labelname = SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel),user.getLanguage());
				String optionstr = "<option value=\""+fieldid+"\">"+labelname+"</option>";
				if(viewtype.equals("1")&&!tempdetailtable.equals(detailtable)){
					modedetailno++;
					tempdetailtable = detailtable;
					//modeFieldIdList = new ArrayList();
					//modeLabelNameList = new ArrayList();
					modeDetailFieldIdList.add("");
					modeDetailLabelNameList.add("------明细"+modedetailno+"------");
				}
				if(modedetailno==0){
					modeFieldIdList.add(fieldid);
					modeLabelNameList.add(labelname);
				}else{
					modeDetailFieldIdList.add(fieldid);
					modeDetailLabelNameList.add(labelname);					
				}
				String key = String.valueOf(modedetailno);
				if(optionMap.containsKey(key)){
					optionstr = Util.null2String((String)optionMap.get(key)) + optionstr;
				}
				optionMap.put(key,optionstr);
				//modeFieldIdMap.put(key,modeFieldIdList);
				//modeLabelNameMap.put(key,modeLabelNameList);
			}
			
			//modeFieldIdList = (ArrayList)modeFieldIdMap.get("0");
			//modeLabelNameList = (ArrayList)modeLabelNameMap.get("0");
	%>
			<TABLE class=ViewForm>
				<COLGROUP>
					<COL width="30%">
					<COL width="70%">
				</COLGROUP>
		  		<TBODY>
		       		<TR>
						<TD colSpan=2><B>模块数据导入</B></TD>
					</TR>					
					<TR class=Spacing style="height:1px;">
						<TD class=Line1 colSpan=2></TD>
					</TR>
					<tr>
						<td colspan=2>
							<table class="listStyle" id="oTableOfSubwfSetDetail" name="oTableOfSubwfSetDetail">
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<tr class="header">
								    <td><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td>
		                  			<td><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></td>
		              			</tr>
		              			<%
		              				//被触发流程字段信息
		              				int detailno = 0;
		              				tempdetailtable = "";
		              				String dataclass = "datalight";
		              				sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where billid = " + modeformid + " order by viewtype asc,detailtable asc";
			              			rs.executeSql(sql);
			              			while(rs.next()){
			              				String fieldid = Util.null2String(rs.getString("id"));
			              				String fieldname = Util.null2String(rs.getString("fieldname"));
			              				String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
			              				String fielddbtype = Util.null2String(rs.getString("fielddbtype"));
			              				String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
			              				String type = Util.null2String(rs.getString("type"));
			              				String viewtype = Util.null2String(rs.getString("viewtype"));
			              				String detailtable = Util.null2String(rs.getString("detailtable"));
			              				String labelname = SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel),user.getLanguage());
			              				if(viewtype.equals("1")&&!tempdetailtable.equals(detailtable)){
			              					detailno++;
			              					tempdetailtable = detailtable;
			              					dataclass = "datalight";
								%>
				              				<tr>
				              					<td colspan="2"><b><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%><%=detailno%></b></td>
				              					<td  style="display:none">
				              						<%=SystemEnv.getHtmlLabelName(28606,user.getLanguage())%>
				              						<select style="display:none" id="selectdetail<%=detailno%>"  name="selectdetail<%=detailno%>" onchange="ChangeSelect(this)">
				              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
				              							<%
				              								for(int i=1;i<modedetailno;i++){
			              								%>
				              									<option value="<%=i%>"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%><%=i%></option>
				              							<%
				              								}
				              							%>
				              						</select>
				              					</td>
				              				</tr>
											<TR class=Spacing style="height:1px;">
												<TD class=Line1 colSpan=2></TD>
											</TR>
											<tr class="header">
											    <td><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td>
					                  			<td><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></td>
					              			</tr>
								<%
			              				}
			              		%>
			              				<tr class="<%=dataclass%>">
			              					<td>
			              						<%=labelname%>
			              						<input type="hidden" name="modefieldid<%=detailno%>" id="modefieldid<%=detailno%>" value="<%=fieldid%>">
		              						</td>
			              					<td>
			              						<select name="wffieldid<%=detailno%>" id="wffieldid<%=detailno%>">
			              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
			              							<%
			              								if(detailno==0){
			              									for(int i=0;i<modeFieldIdList.size();i++){
			              										String tempfieldid = (String)modeFieldIdList.get(i);
			              										String tempfieldlabelname = (String)modeLabelNameList.get(i);
				              									String key = fieldid+"_"+tempfieldid;
				              									boolean selected = existsMap.containsKey(key);
				              									String selectedstr = "";
				              									if(selected){
				              										selectedstr = "selected";
				              									}
		           									%>
		           												<option value="<%=tempfieldid%>" <%=selectedstr%>><%=tempfieldlabelname%></option>
		           									<%
			              									}
			              								}else{
			              									for(int i=0;i<modeDetailFieldIdList.size();i++){
			              										String tempfieldid = (String)modeDetailFieldIdList.get(i);
			              										String tempfieldlabelname = (String)modeDetailLabelNameList.get(i);
				              									String key = fieldid+"_"+tempfieldid;
				              									boolean selected = existsMap.containsKey(key);
				              									String selectedstr = "";
				              									if(selected){
				              										selectedstr = "selected";
				              									}
		           									%>
		           												<option value="<%=tempfieldid%>" <%=selectedstr%>><%=tempfieldlabelname%></option>
		           									<%
			              									}			              									
			              								}
			              							%>
			              						</select>
			              					</td>
			              				</tr>
			              		<%
			              				if(dataclass.equals("datalight")){
			              					dataclass = "datadark";
			              				}else{
			              					dataclass = "datalight";
			              				}
			              			}
		              			%>
		                	</table>
		                	<input type="hidden" name="detailno" value="<%=detailno%>">
		            	</td>
					</tr>
				</TBODY>
			</TABLE>
	<%
		} 
	%>
</form>


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
<script type="text/javascript">
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})

	<%
		for(int i=0;i<modedetailno;i++){
			String key = String.valueOf(i);
			String optionstr = Util.null2String((String)optionMap.get(key));
			out.println(" var option" + key + "  = '" + optionstr + "';");
		}
	%>

    function doSave(){
        if($("#workflowid").val()=='0'){
        	$("#workflowid").val("");
		}
        if($("#modeid").val()=='0'){
        	$("#modeid").val("");
		}
        if(check_form(document.frmSearch,"workflowid,modeid")){
        	enableAllmenu();
        	document.frmSearch.submit();
        }
    }
    function doBack(){
    	enableAllmenu();
    	location.href = "/formmode/interfaces/WorkflowToModeList.jsp?modeid=<%=initmodeid%>&workflowid=<%=initworkflowid%>";
	}
	function doDel(){
    	if(isdel()){
    		enableAllmenu();
    		document.frmSearch.operation.value="del";
    		document.frmSearch.submit();
    	}
	}
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("<img src=\"/images/BacoError.gif\" align=\"absmiddle\">");
    		}
    	} 
    }

</script>

</BODY></HTML>