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
String titlename = SystemEnv.getHtmlLabelName(28601,user.getLanguage());
String needfav ="1";
String needhelp ="";

String customname = Util.null2String(request.getParameter("customname"));
int modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")),0);
int workflowid=0;
String modename = "";
String sql = "";
int id = 0;
int modeformid = 0;
int wfformid = 0;
int wfcreater = 0;
int wfcreaterfieldid = 0;
String successwriteback = "";
String failwriteback = "";
if(modeid>0){
	sql = "select modename,formid from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		modename = Util.null2String(rs.getString("modename"));
		modeformid = rs.getInt("formid");
	}
}

sql = "select * from mode_triggerworkflowset where modeid = " + modeid;
rs.executeSql(sql);
while(rs.next()){
	workflowid = rs.getInt("workflowid");
	id = rs.getInt("id");
	wfcreater = rs.getInt("wfcreater");
	wfcreaterfieldid = rs.getInt("wfcreaterfieldid");
	wfformid = Util.getIntValue(WorkflowComInfo.getFormId(String.valueOf(workflowid)));
	successwriteback = Util.null2String(rs.getString("successwriteback"));
	failwriteback = Util.null2String(rs.getString("failwriteback"));
}

HashMap existsMap = new HashMap();
sql = "select * from mode_triggerworkflowsetdetail where mainid = " + id;
rs.executeSql(sql);
while(rs.next()){
	String modefieldid = rs.getString("modefieldid");
	String wffieldid = rs.getString("wffieldid");
	String key = wffieldid+"_"+modefieldid;
	existsMap.put(key,key);
	existsMap.put(wffieldid,modefieldid);
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(id>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
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

<form name="frmSearch" method="post" action="/formmode/interfaces/ModeTriggerWorkflowSetOperation.jsp">
	<input name="operation" value="save" type="hidden">
	<input name="modeid" value="<%=modeid%>" type="hidden">
	<input name="id" value="<%=id%>" type="hidden">
	<table class="ViewForm">
		<COLGROUP>
			<COL width="20%">
			<COL width="80%">
		</COLGROUP>
		<TR>
			<TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></B></TD>
		</TR>
		<tr style="height:1px"><td colspan=4 class=Line1></td></tr>
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%>
			</td>
			<td class="Field">
		  		 <!-- button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></BUTTON -->
		  		 <span id=modeidspan><%=modename%></span>
		  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(28600,user.getLanguage())%>
			</td>
			<td class=Field>
				<input class="wuiBrowser" id="workflowid" name="workflowid" _required="yes" type="hidden" value="<%=workflowid==0?"":(String.valueOf(workflowid))%>" _displayText="<%=WorkflowComInfo.getWorkflowname(String.valueOf(workflowid))%>" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isbill=1 and formid<0">
			</td>

		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(30297,user.getLanguage())%></td>
			<td>
				<%=SystemEnv.getHtmlLabelName(23108,user.getLanguage())%>:
				<br>
				<textarea id="successwriteback" name="successwriteback" style="width:80%" rows=4 ><%=successwriteback%></textarea>
				<br>
				<%=SystemEnv.getHtmlLabelName(23109,user.getLanguage())%>:
				<br>
				<textarea id="failwriteback" name="failwriteback" style="width:80%" rows=4 ><%=failwriteback%></textarea>
				<br>
				<font color="red">
				触发审批流成功或者失败的时候，可以设置回写值，用来修改当前模块某些主字段的值，比如:a='2'，
				<br>
				如果要修改多个字段的值，请用","将多个字段的值隔开，比如a='2',b='3',c='abc'，
				<br>
				其中a,b,c是指表单中数据库字段名。
				</font>
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
		
		<TR>
			<TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(28602,user.getLanguage())%></B></TD>
		</TR>								
		<TR class=Spacing style="height:1px;">
			<TD class=Line1 colSpan=2></TD>
		</TR>
		<TR>
			<TD>
				<%=SystemEnv.getHtmlLabelName(28596,user.getLanguage())%>
			</TD>                                            
			<TD class="field">
				<input type=radio name=wfcreater id=wfcreater value="1" 
				<%
				    if(wfcreater<=0||wfcreater==1){
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
			   <%=SystemEnv.getHtmlLabelName(28597,user.getLanguage())%>
			</TD>                                            
			<TD class="field"> 
				<input type=radio name=wfcreater id=wfcreater value="2" 
				<%
				    if(wfcreater==2){
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
				<%=SystemEnv.getHtmlLabelName(28598,user.getLanguage())%>
			</TD>                                            
			<TD class="field"> 
				<input type=radio name=wfcreater id=wfcreater value="3"
				<%
				    if(wfcreater==3){
				%>
						checked
				<%
				    }
				%>										 
				>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<select class=inputstyle  name=wfcreaterfieldid>
				<%
					int fieldId= 0;
					//sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid="+ modeformid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=141 or type=142 or type=166) " ;
					sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid="+ modeformid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=166) " ;
					rs.executeSql(sql);
					while(rs.next()){
						fieldId=rs.getInt("id");
				%>
						<option value=<%=fieldId%> 
				<%
						if(fieldId==wfcreaterfieldid){
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
		<TR style="height:1px;">
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

		if(workflowid>0){
			
			modeFieldIdList.add("-1");
			modeLabelNameList.add("数据Id");
			
			//模块表单字段信息
			String tempdetailtable = "";
			sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where billid = " + modeformid + " order by viewtype asc,detailtable asc,id asc";
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
						<TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(28603,user.getLanguage())%></B></TD>
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
								    <td><%=SystemEnv.getHtmlLabelName(28604,user.getLanguage())%></td>
		                  			<td><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td>
		              			</tr>
	              				<tr class="datalight">
	              					<td>
	              						<%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%>
	              						<input type="hidden" name="wffieldid0" id="wffieldid0" value="-1">
              						</td>
	              					<td>
	              						<select name="modefieldid0" id="modefieldid0">
	              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
	              							<%
	              								for(int i=0;i<modeFieldIdList.size();i++){
	              									String fieldid = (String)modeFieldIdList.get(i);
	              									String fieldlabelname = (String)modeLabelNameList.get(i);
	              									String key = "-1_"+fieldid;
	              									boolean selected = existsMap.containsKey(key);
	              									String selectedstr = "";
	              									if(selected){
	              										selectedstr = "selected";
	              									}
           									%>
           											<option value="<%=fieldid%>" <%=selectedstr%>><%=fieldlabelname%></option>
           									<%
	              								}
	              							%>
	              						</select>
	              					</td>
	              				</tr>
	              				<tr class="datadark">
	              					<td>
	              						<%=SystemEnv.getHtmlLabelName(21587,user.getLanguage())%>
	              						<input type="hidden" name="wffieldid0" id="wffieldid0" value="-2">
              						</td>
	              					<td>
	              						<select name="modefieldid0" id="modefieldid0">
	              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
	              							<%
	              								for(int i=0;i<modeFieldIdList.size();i++){
	              									String fieldid = (String)modeFieldIdList.get(i);
	              									String fieldlabelname = (String)modeLabelNameList.get(i);
	              									String key = "-2_"+fieldid;
	              									boolean selected = existsMap.containsKey(key);
	              									String selectedstr = "";
	              									if(selected){
	              										selectedstr = "selected";
	              									}
           									%>
           											<option value="<%=fieldid%>" <%=selectedstr%>><%=fieldlabelname%></option>
           									<%
	              								}
	              							%>
	              						</select>
	              					</td>
	              				</tr>
	              				<%
	              				int messageType = 0;
	              				rs.executeSql("select messageType from workflow_base where id="+workflowid);
	              				if(rs.next())
	              					messageType = Util.getIntValue(rs.getString(1),0);
	              				%>
	              				<tr class="datalight" <%if(messageType == 0){ %>style="display:none"<%} %>>
	              					<td>
	              						<%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
	              						<input type="hidden" name="wffieldid0" id="wffieldid0" value="-3">
              						</td>
	              					<td>
	              						<select name="modefieldid0" id="modefieldid0">
	              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
	              							<%
	              								for(int i=0;i<modeFieldIdList.size();i++){
	              									String fieldid = (String)modeFieldIdList.get(i);
	              									String fieldlabelname = (String)modeLabelNameList.get(i);
	              									String key = "-3_"+fieldid;
	              									boolean selected = existsMap.containsKey(key);
	              									String selectedstr = "";
	              									if(selected){
	              										selectedstr = "selected";
	              									}
           									%>
           											<option value="<%=fieldid%>" <%=selectedstr%>><%=fieldlabelname%></option>
           									<%
	              								}
	              							%>
	              						</select>
	              					</td>
	              				</tr>
		              			<%
		              				//被触发流程字段信息
		              				int detailno = 0;
		              				tempdetailtable = "";
		              				String dataclass = "datadark";
		              				sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where billid = " + wfformid + " order by viewtype asc,detailtable asc";
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
											    <td><%=SystemEnv.getHtmlLabelName(28604,user.getLanguage())%></td>
					                  			<td><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td>
					              			</tr>
								<%
			              				}
			              		%>
			              				<tr class="<%=dataclass%>">
			              					<td>
			              						<%=labelname%>
			              						<input type="hidden" name="wffieldid<%=detailno%>" value="<%=fieldid%>">
		              						</td>
			              					<td>
			              						<select name="modefieldid<%=detailno%>" id="modefieldid<%=detailno%>">
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
		if($("#modeid").val()=='0'){
			if(confirm("请先保存基本信息！")){
				window.parent.document.getElementById('modeBasicTab').click();
			}else{
				$('.href').hide();
			}
		}
	});

	<%
		for(int i=0;i<modedetailno;i++){
			String key = String.valueOf(i);
			String optionstr = Util.null2String((String)optionMap.get(key));
			out.println(" var option" + key + "  = '" + optionstr + "';");
		}
	%>

	function ChangeSelect(obj){
		
	}

	$(document).ready(function(){//onload事件
		
	});

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
    			$(spanName).html("");
    		}
    	} 
    }

</script>

</BODY></HTML>