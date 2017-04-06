<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeLayoutUtil" class="weaver.formmode.setup.ModeLayoutUtil" scope="page" />
<jsp:useBean id="resolveFormMode" class="weaver.formmode.view.ResolveFormMode" scope="page" />
<HTML>
<HEAD>
<link href="/css/Weaver.css" type="text/css" rel=STYLESHEET>
<script type="text/javascript" language="javascript" src="/js/weaver.js"></script>
<script language=javascript src="/js/jquery/jquery.js"></script>
<script type="text/javascript" language="javascript" src="/formmode/js/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/formmode/js/FCKEditorExt.js"></script>
<style type="text/css">
	body { overflow-x:hidden }
</style>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int Id = Util.getIntValue(request.getParameter("Id"), 0);
int type = Util.getIntValue(request.getParameter("type"), -1);
int modeId = Util.getIntValue(request.getParameter("modeId"), 0);
int formId = Util.getIntValue(request.getParameter("formId"), 0);
int flag = Util.getIntValue(request.getParameter("flag"), 0);

String layoutname = "";
String htmlLayout = "";
int cssfile = 0;
String sysPath = "";

int canFieldEdit = 1;//设置这个属性，在wfEditorConf.js获得hidden的input的value，以判断是否出现“只读”、“可编辑”、“必填”3个右键菜单
if(type==0 || type==3)
	canFieldEdit = 0;
modeLayoutUtil.searchModeLayout(modeId,formId,Id);
List modeList = null;
String cssname = "";
String realfilename = "";
if(Id > 0){
	modeList= modeLayoutUtil.getModeLayoutList();
	if(modeList.size()==1){
		Map modeMap = (Map)modeList.get(0);
		layoutname = (String)modeMap.get("layoutName");
		sysPath = (String)modeMap.get("sysPath");
		modeLayoutUtil.setSysPath(sysPath);
		modeLayoutUtil.getHtmlLayoutText();
		htmlLayout = modeLayoutUtil.getHtmlLayout();
		
		cssfile = Util.getIntValue((String)modeMap.get("cssfile"),0);
		rs.execute("select * from workflow_crmcssfile where id="+cssfile);
		if(rs.next()){
			cssname = Util.null2String(rs.getString("cssname"));
			realfilename = Util.null2String(rs.getString("realfilename"));
		}
		String layout = Util.null2String((String)session.getAttribute("layout_t"));
		if(!"".equals(layout)){
			htmlLayout = layout;
			session.removeAttribute("layout_t");
		}
		htmlLayout = resolveFormMode.deleteTempCss(htmlLayout);
		htmlLayout = resolveFormMode.addTempCss(htmlLayout, realfilename);
		
	}
}
if(htmlLayout.equals(""))
	htmlLayout = "<link href=\"/css/Weaver.css\" type=\"text/css\" rel=STYLESHEET>";
//System.out.println(htmlLayout);
modeLayoutUtil.setUser(user);
modeLayoutUtil.setModeId(modeId);
modeLayoutUtil.setFormId(formId);
modeLayoutUtil.setType(type);
/*
Map fieldmap = modeLayoutUtil.getFormfields(user.getLanguage(),type);
List detailGroupLists = (List)fieldmap.get("detailGroup");		//明细
List mainfields = (List)fieldmap.get("mainfields");				//主表字段
List detlfields = (List)fieldmap.get("detlfields");				//子表字段
*/
Hashtable rhs = modeLayoutUtil.getFieldAttr4LEF();
ArrayList fieldidList = (ArrayList)rhs.get("fieldidList");
Hashtable fieldLabel_hs = (Hashtable)rhs.get("fieldLabel_hs");
Hashtable fieldAttr_hs = (Hashtable)rhs.get("fieldAttr_hs");
Hashtable detailFieldid_hs = (Hashtable)rhs.get("detailFieldid_hs");
ArrayList detailGroupList = (ArrayList)rhs.get("detailGroupList");
Hashtable detailGroupTitle_hs = (Hashtable)rhs.get("detailGroupTitle_hs");
Hashtable fieldSQL_hs = (Hashtable)rhs.get("fieldSQL_hs");

ArrayList detailGroupAttrList = (ArrayList)rhs.get("detailGroupAttrList");
String fileFieldids = Util.null2String((String)rhs.get("fileFieldids"));
String inputFieldids = Util.null2String((String)rhs.get("inputFieldids"));
String especialFieldids = Util.null2String((String)rhs.get("especialFieldids"));
String dateFields = Util.null2String((String)rhs.get("dateFields"));
String zhengshuFields = Util.null2String((String)rhs.get("zhengshuFields"));
String shuziFieldids = Util.null2String((String)rhs.get("shuziFieldids"));

String layoutTypeName = modeLayoutUtil.getTypeDesc(type,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());

StringBuffer fieldAttr_sb = new StringBuffer();//字段属性，拼html代码。主表和明细表字段放一起拼
StringBuffer detailGroupAttr_sb = new StringBuffer();//明细表属性
StringBuffer fieldSQL_sb = new StringBuffer();//字段SQL属性
StringBuffer fieldid_sb = new StringBuffer();//记录所有字段id
%>
<TITLE></TITLE>
</HEAD>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(64,user.getLanguage())+SystemEnv.getHtmlLabelName(23690,user.getLanguage())+",javascript:onPreview(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
if(flag==1){
%>
<SCRIPT LANGUAGE="javascript">
	alert("<%=SystemEnv.getHtmlLabelName(18758, user.getLanguage())%>");
</SCRIPT>
<%}%>
<BODY onload="initFckEdit();" style="MARGIN: 0px;">
<form id="LayoutForm" name="LayoutForm" action="LayoutOperation.jsp" target="_self" method="post" enctype="multipart/form-data">
<table width="100%" height="100%" class="ViewForm" bgcolor="#000000" border="0" cellpadding="3" cellspacing="1" align="center">
<colgroup>
<col width="*">
<col width="250px">
  <tr bgcolor="#DDDDDD" height="100%">
	<td bgcolor="#DDDDDD" width="*" valign="top">
		<textarea name="layouttext" id="layouttext" style="display:none;width:100%;height:100%"><%=htmlLayout%></textarea>
	</td>
	<td valign="top" align="center" style="width:250px;height:100%" bgcolor="#ffffff">
	<table class="ViewForm" cellpadding="0" cellspacing="0">
	 <colgroup>
	 <col width="50%">
	 <col width="50%">
	  <tr>
		<td heigth="20" align="center" colspan="2"><B><%=SystemEnv.getHtmlLabelName(23721,user.getLanguage())%>&nbsp;:&nbsp;</B><%=layoutTypeName%></td>
	  </tr>
	  <tr><td class="Line2"></td></tr>
	  <tr height="100%" width="100%" valign="top">
		<td style="border-right:1px #ECECEC solid" height="100%" valign="top">
		<table class="ViewForm" width="120" border="0" cellspacing="1" cellpadding="3" align="center">
		  <tr class="Title">
			<td class="field" align="center"><B><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></B></td>
		  </tr>
		  <tr><td class="Line2"></td></tr>
		  <tr class="Title">
			<td class="field" id="tdtablelist" name="tdtablelist" align="center">
			 <select id="tablelist0" name="tablelist0" class="tablelist" size="1" onchange="onchangeformlabel(this)" style="width:100%">
			  <option value="-1" selected><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
			  <%
				if(detailGroupList!=null && detailGroupList.size()>0){
					for(int i=0; i<detailGroupList.size(); i++){
						String groupid_tmp = (String)detailGroupList.get(i);
						ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
						if(detailFieldidList!=null && detailFieldidList.size()>0){
							String title_tmp = (String)detailGroupTitle_hs.get("grouptitle"+groupid_tmp);
			  %>
					<option value="<%=i%>"><%=title_tmp%></option>
			  <%
						}
					}
				}
			  %>
			 </select>
		    </td>
		  </tr>
		  <tr><td class="Line2"></td></tr>
		  <tr class="Title">
			<td class="field" id="tdfieldlist" name="tdfieldlist" align="center">
			 <select id="labellist-1" name="labellist-1" class="labellist" size="15" ondblclick="javascript:cool_webcontrollabel(this);" style="width:100%;display:">
			<%
				for(int i=0; i<fieldidList.size(); i++){
					String fieldid_tmp = (String)fieldidList.get(i);
					String fieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+fieldid_tmp);
			%>
						<option value="<%=fieldid_tmp%>" nodeType="<%=fieldlabel_tmp%>"><%=fieldlabel_tmp%></option>
			<%
				}
			%>
					</select>
			<%
			if(detailGroupList!=null && detailGroupList.size()>0){
				for(int i=0; i<detailGroupList.size(); i++){
					String groupid_tmp = (String)detailGroupList.get(i);
					ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
					if(detailFieldidList!=null && detailFieldidList.size()>0){
			%>
					<select id="labellist<%=i%>" name="labellist<%=i%>" class="labellist" size="15" ondblclick="javascript:cool_webcontrollabel(this);" style="width:100%;display:none">
			<%
						for(int j=0; j<detailFieldidList.size(); j++){
							String detailFieldid_tmp = (String)detailFieldidList.get(j);
							String detailFieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+detailFieldid_tmp);
			%>
							<option value="<%=detailFieldid_tmp%>" nodeType="<%=detailFieldlabel_tmp%>"><%=detailFieldlabel_tmp%></option>
			<%
						}
					}
			%>
					</select>
			<%
				}
			}
			%>
			
			<select id="labellist-all" name="labellist-all" class="labellist" size="15" ondblclick="javascript:cool_webcontrollabel(this);" style="width:100%;display:none">
				<optgroup label="主表字段">
				<%
					for(int i=0; i<fieldidList.size(); i++){
						String fieldid_tmp = (String)fieldidList.get(i);
						String fieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+fieldid_tmp);
				%>
							<option value="<%=fieldid_tmp%>" nodeType="<%=fieldlabel_tmp%>"><%=fieldlabel_tmp%></option>
				<%
					}
				%>
				</optgroup>
			    <%
				if(detailGroupList!=null && detailGroupList.size()>0){
				%>
				<%
					for(int i=0; i<detailGroupList.size(); i++){
						String groupid_tmp = (String)detailGroupList.get(i);
						ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
						if(detailFieldidList!=null && detailFieldidList.size()>0){
				%>
						<optgroup label="明细表<%=i+1 %>字段">
				<%
							for(int j=0; j<detailFieldidList.size(); j++){
								String detailFieldid_tmp = (String)detailFieldidList.get(j);
								String detailFieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+detailFieldid_tmp);
				%>
								<option value="<%=detailFieldid_tmp%>" nodeType="<%=detailFieldlabel_tmp%>"><%=detailFieldlabel_tmp%></option>
				<%
							}
						}
				%>
						</optgroup>
				<%
					}
				}
				%>
				
			</select>
			</td>
		  </tr>
		  <tr><td class="Line2"></td></tr>
		</table>
	    </td>
	    <td style="border-left:1px #ECECEC solid" height="100%" valign="top">
		  <table class="ViewForm" width="120" border="0" cellspacing="1" cellpadding="3" align="center">
			<tr class="Title">
				<td class="field" align="center"><B><%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%></B></td>
			</tr>
			<tr><td class="Line2"></td></tr>
			<tr class="Title">
				<td class="field" align="center">
					<select id="tablelist1" name="tablelist1" class="tablelist" size="1" onchange="onchangeformfield(this)" style="width:100%">
						<option value="-1" selected><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
						 <%
							if(detailGroupList!=null && detailGroupList.size()>0){
								for(int i=0; i<detailGroupList.size(); i++){
									String groupid_tmp = (String)detailGroupList.get(i);
									ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
									if(detailFieldidList!=null && detailFieldidList.size()>0){
										String title_tmp = (String)detailGroupTitle_hs.get("grouptitle"+groupid_tmp);
						%>
								<option value="<%=i%>"><%=title_tmp%></option>
						<%
									}
								}
							}
						%>
					</select>
				</td>
			</tr>
			<tr><td class="Line2"></td></tr>
			<tr class="Title">
				<td class="field" align="center">
					<select id="fieldlist-1" name="fieldlist-1" class="fieldlist" size="15" onchange="loadfieldstyle(this)" ondblclick="javascript:cool_webcontrolfield(this);" style="width:100%">
					 <%
						for(int i=0; i<fieldidList.size(); i++){
							String fieldid_tmp = (String)fieldidList.get(i);
							String fieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+fieldid_tmp);
							String fieldAttr_tmp = Util.null2String((String)fieldAttr_hs.get("fieldAttr"+fieldid_tmp));
							fieldAttr_sb.append("<input type=\"hidden\" id=\"fieldattr"+fieldid_tmp+"\" nodetype=\"-1\" name=\"fieldattr"+fieldid_tmp+"\" value=\""+fieldAttr_tmp+"\">").append("\n");
							String fieldSQL_tmp = Util.null2String((String)fieldSQL_hs.get("fieldsql"+fieldid_tmp));
							int caltype_tmp = Util.getIntValue((String)fieldSQL_hs.get("caltype"+fieldid_tmp), 0);
							int othertype_tmp = Util.getIntValue((String)fieldSQL_hs.get("othertype"+fieldid_tmp), 0);
							int transtype_tmp = Util.getIntValue((String)fieldSQL_hs.get("transtype"+fieldid_tmp), 0);
							fieldSQL_sb.append("<input type=\"hidden\" id=\"fieldsql"+fieldid_tmp+"\" name=\"fieldsql"+fieldid_tmp+"\" value=\""+fieldSQL_tmp+"\">").append("\n");
							fieldSQL_sb.append("<input type=\"hidden\" id=\"caltype"+fieldid_tmp+"\" name=\"caltype"+fieldid_tmp+"\" value=\""+caltype_tmp+"\" >").append("\n");
							fieldSQL_sb.append("<input type=\"hidden\" id=\"othertype"+fieldid_tmp+"\" name=\"othertype"+fieldid_tmp+"\" value=\""+othertype_tmp+"\">").append("\n");
							fieldSQL_sb.append("<input type=\"hidden\" id=\"transtype"+fieldid_tmp+"\" name=\"transtype"+fieldid_tmp+"\" value=\""+transtype_tmp+"\">").append("\n");
							fieldid_sb.append(fieldid_tmp+",");
						%>
								<option value="<%=fieldid_tmp%>" nodeType="<%=fieldAttr_tmp%>"><%=fieldlabel_tmp%></option>
						<%
						}
						%>
					</select>
					<%
					if(detailGroupList!=null && detailGroupList.size()>0){
						for(int i=0; i<detailGroupList.size(); i++){
							String groupid_tmp = (String)detailGroupList.get(i);
							String detailGroupAttr = (String)detailGroupAttrList.get(i);
							ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
							if(detailFieldidList!=null && detailFieldidList.size()>0){
								String title_tmp = (String)detailGroupTitle_hs.get("grouptitle"+groupid_tmp);
								detailGroupAttr_sb.append("<input type=\"hidden\" id=\"detailgroupattr"+i+"\" name=\"detailgroupattr"+i+"\" value=\""+detailGroupAttr+"\">").append("\n");
					%>
							<select id="fieldlist<%=i%>" name="fieldlist<%=i%>" class="fieldlist" size="15" onchange="loadfieldstyle(this)" ondblclick="javascript:cool_webcontrolfield(this);" style="width:100%;display:none">
					<%
								for(int j=0; j<detailFieldidList.size(); j++){
									String detailFieldid_tmp = (String)detailFieldidList.get(j);
									String detailFieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+detailFieldid_tmp);
									String detailFieldAttr_tmp = (String)fieldAttr_hs.get("fieldAttr"+detailFieldid_tmp);
									fieldAttr_sb.append("<input type=\"hidden\" id=\"fieldattr"+detailFieldid_tmp+"\" nodetype=\""+i+"\" name=\"fieldattr"+detailFieldid_tmp+"\" value=\""+detailFieldAttr_tmp+"\">").append("\n");
									String fieldSQL_tmp = Util.null2String((String)fieldSQL_hs.get("fieldsql"+detailFieldid_tmp));
									int caltype_tmp = Util.getIntValue((String)fieldSQL_hs.get("caltype"+detailFieldid_tmp), 0);
									int othertype_tmp = Util.getIntValue((String)fieldSQL_hs.get("othertype"+detailFieldid_tmp), 0);
									int transtype_tmp = Util.getIntValue((String)fieldSQL_hs.get("transtype"+detailFieldid_tmp), 0);
									fieldSQL_sb.append("<input type=\"hidden\" id=\"fieldsql"+detailFieldid_tmp+"\" name=\"fieldsql"+detailFieldid_tmp+"\" value=\""+fieldSQL_tmp+"\">").append("\n");
									fieldSQL_sb.append("<input type=\"hidden\" id=\"caltype"+detailFieldid_tmp+"\" name=\"caltype"+detailFieldid_tmp+"\" value=\""+caltype_tmp+"\" >").append("\n");
									fieldSQL_sb.append("<input type=\"hidden\" id=\"othertype"+detailFieldid_tmp+"\" name=\"othertype"+detailFieldid_tmp+"\" value=\""+othertype_tmp+"\">").append("\n");
									fieldSQL_sb.append("<input type=\"hidden\" id=\"transtype"+detailFieldid_tmp+"\" name=\"transtype"+detailFieldid_tmp+"\" value=\""+transtype_tmp+"\">").append("\n");
									fieldid_sb.append(detailFieldid_tmp+",");
					%>
									<option value="<%=detailFieldid_tmp%>" nodeType="<%=detailFieldAttr_tmp%>"><%=detailFieldlabel_tmp%></option>
					<%
								}
							}
					%>
							</select>
					<%
						}
					}
					%>
				</td>
			</tr>
			<tr><td class="Line2"></td></tr>
		  </table>
		</td>
	  </tr>
	  <tr>
		<td heigth="20" align="center" colspan="2"><B><%=SystemEnv.getHtmlLabelName(23724,user.getLanguage())%>:</B></td>
	  </tr>
	  <tr>
		<td heigth="20" align="center" colspan="2">
		  <input type="hidden" id="nowgroupid" name="nowgroupid" value=""><input type="hidden" id="nowfieldid" name="nowfieldid" value="">
		  	<div id="groupAttrDiv" name="groupAttrDiv" class="groupAttrDiv" style="display:none">
			<%if(type > 0){%>
				<%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%><input type="checkbox" id="dtladd" name="dtladd" class="groupattrcheckbox" value="1" onclick="onclickgroupattr(this)"><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%><input type="checkbox" id="dtledit" name="dtledit" class="groupattrcheckbox" value="1" onclick="onclickgroupattr(this)">
				</br>
				<%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%>
				<input type="checkbox" id="dtlned" name="dtlned" class="groupattrcheckbox" value="1" onclick="onclickgroupattr(this)"><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%><input type="checkbox" id="dtldef" name="dtldef" class="groupattrcheckbox" value="1" onclick="onclickgroupattr(this)">
				</br>
				<%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%><input type="checkbox" id="dtldel" name="dtldel" class="groupattrcheckbox" value="1" onclick="onclickgroupattr(this)">
<!--				<%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%><input type="checkbox" id="dtlhide" name="dtlhide" class="groupattrcheckbox" value="1" onclick="onclickgroupattr(this)">-->
			<%}else{%>
<!--				<%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%><input type="checkbox" id="dtlhide" name="dtlhide" class="groupattrcheckbox" value="1" onclick="onclickgroupattr(this)">-->
				<input type="checkbox" id="dtladd" name="dtladd" class="groupattrcheckbox0" value="1" style="visibility:hidden">
				<input type="checkbox" id="dtledit" name="dtledit" class="groupattrcheckbox0" value="1" style="visibility:hidden">
				<input type="checkbox" id="dtldel" name="dtldel" class="groupattrcheckbox0" value="1" style="visibility:hidden">
				<input type="checkbox" id="dtlned" name="dtlned" class="groupattrcheckbox0" value="1" style="visibility:hidden">
				<input type="checkbox" id="dtldef" name="dtldef" class="groupattrcheckbox0" value="1" style="visibility:hidden">
			<%}%>
			</div>
		  <select id="fieldattrlist" name="fieldattrlist" class="fieldattrlist" onchange="onchangefieldattr(this)" style="display:none">
			<option value="1"><%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%></option>
			<option value="3"><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option>
		  </select>		
		</td>
	  </tr>
	  <tr><td class="Line2" colspan="2"></td></tr>
	  <tr>
		<td heigth="20" align="center" colspan="2">
			<B><%=SystemEnv.getHtmlLabelName(23731,user.getLanguage())%>&nbsp;:&nbsp;</B><input id="layoutname" name="layoutname" class="InputStyle" value="<%=layoutname%>" temptitle="<%=SystemEnv.getHtmlLabelName(23731,user.getLanguage())%>" maxlength="20" onchange="checkinput('layoutname','layoutnamespan')"><span id="layoutnamespan"><%if("".equals(layoutname)){out.print("<IMG src='/images/BacoError.gif' align=absMiddle>");}%></span>
		</td>
	  </tr>
	  <tr><td class="Line2" colspan="2"></td></tr>
	  <tr height="20"><td colspan="2"></td></tr>
	  <tr>
		<td heigth="20" align="center" colspan="2">
			<a href="javascript:openFullWindowHaveBar('/formmode/setup/EditHtmlField.jsp?type=<%=type%>&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=Id %>&layoutname=<%=layoutname %>')">
			<%=SystemEnv.getHtmlLabelName(28423,user.getLanguage())%></a>
		</td>
	  </tr>
	  <tr><td class="Line2" colspan="2"></td></tr>
	  <tr height="20"><td colspan="2"></td></tr>
			<tr>
				<td heigth="20" align="left" colspan="2">
					&nbsp;&nbsp;
					<B>CSS<%=SystemEnv.getHtmlLabelName(1014,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>&nbsp;&nbsp;:</B>
					<a href="#" onclick="uploadCss()"><%=SystemEnv.getHtmlLabelName(75,user.getLanguage())%></a>&nbsp;&nbsp;
					<a href="#" onclick="changeCss()"><%=SystemEnv.getHtmlLabelName(27825,user.getLanguage())%></a>
				</td>
			</tr>
			<tr><td class="Line2" colspan="2"></td></tr>
			<tr>
				<td heigth="20" align="left" colspan="2">
					&nbsp;&nbsp;
					<B>CSS<%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%>&nbsp;&nbsp;：</B>
					<span id="cssfilespan"><%=cssname%></span>
					<input type="hidden" id="cssfile" name="cssfile" value="<%=cssfile%>">
				</td>
			</tr>
			<tr><td class="Line2" colspan="2"></td></tr>
			<tr height="5"><td colspan="2"></td></tr>
			<tr>
			<td heigth="20" align="left" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="/workflow/html/WorkFlowCssList.jsp" target="_blank">CSS<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%></a>
			</td>
			</tr>
			<tr><td class="Line2" colspan="2"></td></tr>
			<tr height="5"><td colspan="2"></td></tr>
	 </table>
	 <%=fieldAttr_sb.toString()%>
	 <%=detailGroupAttr_sb.toString()%>
	 <%=fieldSQL_sb%>
	 <input type="hidden" id="operation" name="operation" value="saveHtmlMode">
	 <input type="hidden" id="modeId" name="modeId" value="<%=modeId%>">
	 <input type="hidden" id="formId" name="formId" value="<%=formId%>">
	 <input type="hidden" id="Id" name="Id" value="<%=Id%>">
	 <input type="hidden" id="type" name="type" value="<%=type%>">
	 <input type="hidden" id="fieldids" name="fieldids" value="<%if(fieldid_sb.length()>0){out.print(fieldid_sb.deleteCharAt(fieldid_sb.length()-1));}%>">
	 <input type="hidden" id="fileFieldids" name="fileFieldids" value="<%=fileFieldids%>">
	 <input type="hidden" id="inputFieldids" name="inputFieldids" value="<%=inputFieldids%>">
	 <input type="hidden" id="especialFieldids" name="especialFieldids" value="<%=especialFieldids%>">
	 <input type="hidden" id="shuziFieldids" name="shuziFieldids" value="<%=shuziFieldids%>">
	 <input type="hidden" id="canFieldEdit" name="canFieldEdit" value="<%=canFieldEdit%>">
	 <input type="hidden" id="htmlfile" name="htmlfile" value="">
	 <input type="hidden" id="dateFields" name="dateFields" value="<%=dateFields%>">
	 <input type="hidden" id="zhengshuFields" name="zhengshuFields" value="<%=zhengshuFields%>">
	<div id="htmllayoutdiv" name="htmllayoutdiv" style="height:0px;width:0px;visibility:hidden"></div>
	</td>
  </tr>
 <tbody>
</table>
</body>
<script type="text/javascript">
function funcremark(){
	FCKEditorExt.initEditor("LayoutForm","layouttext",7,FCKEditorExt.HtmlLayout_IMAGE);
}
function initFckEdit(){
	funcremark();
}

function loadfieldstyle(obj){
}

function loadfieldstyle(obj){
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	//$("#nowgroupid").val("");
	$("#nowfieldid").val("");
	$("#groupAttrDiv").hide();
	$("#fieldattrlist").hide();
	$(".groupattrcheckbox").attr("checked", "");
<%if(type==1 || type==2){//只有新建、编辑模板才能调整字段显示属性%>
	var especialFieldids = $("#especialFieldids").val();
	var index_eFieldids = (","+especialFieldids+",").indexOf(","+obj.value+",");
	if(obj.id!="fieldlist-2" && index_eFieldids==-1 && obj.value!="-4"){//不是节点
		var fckHtml = FCKEditorExt.getHtml("layouttext");
		//alert(fckHtml.indexOf("$field"+obj.value+"$"));
		if(fckHtml.indexOf("$field"+obj.value+"$") != -1){//如果Fck编辑框里面没有这个字段，那么也不显示出来
			if(obj.id == "fieldlist-1"){//主表
				var nowfieldid = obj.value;
				$("#nowfieldid").val(nowfieldid);
				var fieldattr = $("#fieldattr"+nowfieldid).val();
				$("#fieldattrlist").val(fieldattr);
				$("#fieldattrlist").show();
			}else{
				var nowgroupid = $("#nowgroupid").val();
				var nowgroupattr = $("#detailgroupattr"+nowgroupid).val();
				$("#fieldattrlist option").each(function(){
					if($(this).val()=="2" || $(this).val()=="3"){
						$(this).remove();
					}
				});
				if(nowgroupattr.indexOf("00") != 0){
					$("#fieldattrlist").append("<option value=\"2\"><%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%></option>");
					$("#fieldattrlist").append("<option value=\"3\"><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option>");
				}
				var nowfieldid = obj.value;
				$("#nowfieldid").val(nowfieldid);
				var fieldattr = $("#fieldattr"+nowfieldid).val();
				$("#fieldattrlist").val(fieldattr);
				$("#fieldattrlist").show();
			}
		}
	}
	fckHtml = FCKEditorExt.getHtml("layouttext");
	//FCKEditorExt.setHtml(fckHtml,"layouttext");
<%}%>
}
function onchangeformlabel(obj){
	$(".labellist").hide();
	$("#labellist"+obj.value).show();
}

//往左边Fck编辑框里加一个字段显示名
function cool_webcontrollabel(obj){
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	var labelid = obj.value;
	var labelhtml = "<input class=\"Label\" id=\"$label"+labelid+"$\" name=\"label"+labelid+"\" value=\""+nodetype+"\">";
	FCKEditorExt.insertHtml(labelhtml, "layouttext");
}

function cool_webcontrolfield(obj){
	var fckHtml = FCKEditorExt.getHtml("layouttext");
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	var fieldlabel = obj.options.item(obj.selectedIndex).text;
	var fieldid = obj.value;
	if(fckHtml.indexOf("$field"+fieldid+"$") != -1){
		alert("<%=SystemEnv.getHtmlLabelName(23723, user.getLanguage())%>");
		return;
	}
<%if(type == 1 || type == 2){%>
	$("#fieldattr"+fieldid).val("2");//刚添加的都认为是编辑属性
<%}else{%>
	$("#fieldattr"+fieldid).val("1");
<%}%>
	var fieldattrStr = "<%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%>";//可编辑
<%if(type == 1 || type == 2){%>
	var fieldhtml = "<input class=\"InputStyle\" id=\"$field"+fieldid+"$\" name=\"field"+fieldid+"\" value=\"["+fieldattrStr+"]"+fieldlabel+"\">";
<%}else{%>
	var fieldhtml = "<input class=\"InputStyle\" id=\"$field"+fieldid+"$\" name=\"field"+fieldid+"\" value=\""+fieldlabel+"\">";
<%}%>
	FCKEditorExt.insertHtml(fieldhtml, "layouttext");
	$("#nowfieldid").val("");
	$("#groupAttrDiv").hide();
	$("#fieldattrlist").hide();
	$(".groupattrcheckbox").attr("checked", "");
	if(obj.id == "fieldlist-1"){//主表
	<%if(type > 0 && type != 3){%>
		var nowfieldid = obj.value;
		$("#nowfieldid").val(nowfieldid);
		var fieldattr = $("#fieldattr"+nowfieldid).val();
		$("#fieldattrlist").val(fieldattr);
		$("#fieldattrlist").show();
	<%}%>
	}else{
		var nowgroupid = $("#nowgroupid").val();
		var nowgroupattr = $("#detailgroupattr"+nowgroupid).val();
		<%if(type > 0){%>
			$("#fieldattrlist option").each(function(){
				if($(this).val()=="2" || $(this).val()=="3"){
					$(this).remove();
				}
			});
			if(nowgroupattr.indexOf("00") != 0){
				$("#fieldattrlist").append("<option value=\"2\"><%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%></option>");
				$("#fieldattrlist").append("<option value=\"3\"><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option>");
			}
		<%}%>
		var nowfieldid = obj.value;
		$("#nowfieldid").val(nowfieldid);
		<%if(type > 0){%>
			var fieldattr = $("#fieldattr"+nowfieldid).val();
			$("#fieldattrlist").val(fieldattr);
			$("#fieldattrlist").show();
		<%}%>
	}
}
function onSave(){
	FCKEditorExt.updateContent();
	var textStr = document.getElementById("layouttext").value;
	var tmpStr = fomateHtml(textStr);
	document.getElementById("layouttext").value = tmpStr;
	if(check_form(LayoutForm,"layoutname")){
		LayoutForm.submit();
		enableAllmenu();
	}
}

function fomateHtml(textStr){
	var tmpStr = "";
	var hasTd = textStr.indexOf("<td");
	var tdIndex = textStr.indexOf("<td");
	var headIndex = textStr.indexOf("<", tdIndex+1);
	var tailIndex = textStr.indexOf(">", tdIndex);
	var tailTdIndex = textStr.indexOf(">&nbsp;</td>", tdIndex);
	while(hasTd >= 0){
		if(tdIndex>=0 && headIndex==(tailIndex+7) && tailTdIndex==tailIndex){
			tmpStr += textStr.substring(0, tailIndex+1);
			textStr = textStr.substring(tailTdIndex+7, textStr.length);
		}else{
			tmpStr += textStr.substring(0, tdIndex+3);
			textStr = textStr.substring(tdIndex+3, textStr.length);
		}
		hasTd = textStr.indexOf("<td");
		tdIndex = textStr.indexOf("<td");
		headIndex = textStr.indexOf("<", tdIndex+1);
		tailIndex = textStr.indexOf(">", tdIndex);
		tailTdIndex = textStr.indexOf(">&nbsp;</td>", tdIndex);
	}
	tmpStr += textStr;
	return tmpStr;
}


function onchangefieldattr(obj){
	var nowfieldid = $("#nowfieldid").val();
	$("#fieldattr"+nowfieldid).val(obj.value);
	var fckHtml = FCKEditorExt.getHtml("layouttext");
	var pos1 = fckHtml.indexOf("$field"+nowfieldid+"$");
	if(pos1 != -1){
		var pos2 = fckHtml.indexOf("[", pos1);
		if(pos2 != -1){
			var pos3 = fckHtml.indexOf("]", pos2);
			var text1 = fckHtml.substring(0, pos2+1);
			if(obj.value == "0"){
				var text1 = text1.substring(0, text1.lastIndexOf("<"));
				pos3 = fckHtml.indexOf(">", pos2)+1;
				//text1 += "隐藏";如果切换成隐藏，直接删除
			}else if(obj.value == "1"){
				text1 += "<%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%>";	
			}else if(obj.value == "2"){
				text1 += "<%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%>";
			}else if(obj.value == "3"){
				text1 += "<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>";
			}
			text1 += fckHtml.substring(pos3);
			FCKEditorExt.setHtml(text1,"layouttext");
		}
	}else if(obj.value != "0"){
		//如果本来没有，则添加进去
		var nowgroupid = "-1";
		if(nowfieldid.indexOf("-") == 0){//明细字段
			nowgroupid = $("#nowgroupid").val();
		}
		var obj2 = document.getElementById("fieldlist"+nowgroupid);
		var nodetype = obj2.options.item(obj2.selectedIndex).nodeType;
		var fieldlabel = obj2.options.item(obj2.selectedIndex).text;
		var fieldid = nowfieldid;
		var fieldattrStr = "<%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%>";
		if(obj.value == "1"){
			fieldattrStr = "<%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%>";
		}else if(obj.value == "3"){
			fieldattrStr = "<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>";
		}
	<%if(type==0){%>
		var fieldhtml = "<input class=\"InputStyle\" id=\"$field"+fieldid+"$\" name=\"field"+fieldid+"\" value=\"["+fieldattrStr+"]"+fieldlabel+"\">";
	<%}else{%>
		var fieldhtml = "<input class=\"InputStyle\" id=\"$field"+fieldid+"$\" name=\"field"+fieldid+"\" value=\""+fieldlabel+"\">";
	<%}%>
		FCKEditorExt.insertHtml(fieldhtml, "layouttext");

	}
}
function onchangefieldattrFromFck(fieldid,fieldShowAttr){
	var nowfieldid = $("#nowfieldid").val();
	if(nowfieldid == fieldid){
		$("#fieldattrlist").val(fieldShowAttr);
	}
	var fckHtml = FCKEditorExt.getHtml("layouttext");
	var pos1 = fckHtml.indexOf("$field"+fieldid+"$");
	if(pos1 != -1){
		var pos2 = fckHtml.indexOf("[", pos1);
		if(pos2 != -1){
			var pos3 = fckHtml.indexOf("]", pos2);
			var text1 = fckHtml.substring(0, pos2+1);
			if(fieldShowAttr == "0"){
				var text1 = text1.substring(0, text1.lastIndexOf("<"));
				pos3 = fckHtml.indexOf(">", pos2)+1;
				//text1 += "隐藏";如果切换成隐藏，直接删除
			}else if(fieldShowAttr == "1"){
				text1 += "<%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%>";	
			}else if(fieldShowAttr == "2"){
				text1 += "<%=SystemEnv.getHtmlLabelName(18018,user.getLanguage())%>";
			}else if(fieldShowAttr == "3"){
				text1 += "<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>";
			}
			text1 += fckHtml.substring(pos3);
			FCKEditorExt.setHtml(text1,"layouttext");
		}
	}
}
function onchangeformfield(obj){
	$(".fieldlist").hide();
	$("#fieldlist"+obj.value).show();
	$("#nowgroupid").val(obj.value);
	$("#nowfieldid").val("");
	$("#groupAttrDiv").hide();
	$("#fieldattrlist").hide();
	$(".groupattrcheckbox").attr("checked", "");
	if($("#nowgroupid").val()!="-2" && $("#nowgroupid").val()!="-1"){
		var thisGroupAttr = $("#detailgroupattr"+obj.value).val();
		if(thisGroupAttr.indexOf("1") == 0){
			$("#dtladd").attr("checked", "checked");
		}
		if(thisGroupAttr.indexOf("1",1) == 1){
			$("#dtledit").attr("checked", "checked");
		}
		if(thisGroupAttr.indexOf("1",2) == 2){
			$("#dtldel").attr("checked", "checked");
		}
		if(thisGroupAttr.indexOf("1",3) == 3){
			$("#dtlhide").attr("checked", "checked");
		}
		if(thisGroupAttr.indexOf("1",4) == 4){
			$("#dtldef").attr("checked", "checked");
		}
		if(thisGroupAttr.indexOf("1",5) == 5){
			$("#dtlned").attr("checked", "checked");
		}
		$("#groupAttrDiv").show();
	}
}
function onclickgroupattr(obj){
	var nowgroupid = $("#nowgroupid").val();
	var groupattr = "";
	var text2 = "";
	if($("#dtladd").attr("checked")==true){
		groupattr += "1";
		text2 = "<button type='button' class=\"BtnFlow\" type=\"button\" id=\"$addbutton"+nowgroupid+"$\" name=\"addbutton"+nowgroupid+"\" accessKey=\"A\" onclick=\"addRow"+nowgroupid+"("+nowgroupid+");return false;\"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></BUTTON>";
	}else{
		groupattr += "0";
	}
	text2 += "<button class=\"BtnFlow\" type=\"button\" id=\"$delbutton"+nowgroupid+"$\" name=\"delbutton"+nowgroupid+"\" accessKey=\"E\" onclick=\"if(isdel()){deleteRow"+nowgroupid+"("+nowgroupid+");}return false;\"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></BUTTON>";
	var fckHtml = FCKEditorExt.getHtml("layouttext");
	var pos1 = fckHtml.indexOf("<div id=\"div"+nowgroupid+"button\"");
	if(pos1 != -1){
		var pos2 = fckHtml.indexOf(">", pos1);
		var pos3 = fckHtml.indexOf("</div>", pos2);
		var text1 = fckHtml.substring(0, pos2+1);
		var text3 = fckHtml.substring(pos3);
		var text = text1 + text2 + text3;
		FCKEditorExt.setHtml(text, "layouttext");
	}
	if($("#dtledit").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtldel").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtlhide").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtldef").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtlned").attr("checked")==true){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	$("#detailgroupattr"+nowgroupid).val(groupattr);
}

function uploadCss(){
	var urls = "/workflow/html/WorkFlowCssUP.jsp";
	var id_t = showModalDialog("/systeminfo/BrowserMain.jsp?url="+urls);
	if(id_t){
		if(id_t[0]!="" && id_t[0]!="0" && id_t[0]!="-1"){
			document.getElementById("cssfile").value = id_t[0];
			document.getElementById("cssfilespan").innerHTML = id_t[1];
		}else{
			document.getElementById("cssfile").value = "";
			document.getElementById("cssfilespan").innerHTML = "";
		}
	}
}
function changeCss(){
	var urls = "/workflow/html/WorkFlowCssBrowser.jsp";
	var id_t = showModalDialog("/systeminfo/BrowserMain.jsp?url="+urls);
	if(id_t){
		if(id_t[0]!="" && id_t[0]!="0" && id_t[0]!="-1"){
			document.getElementById("cssfile").value = id_t[0];
			document.getElementById("cssfilespan").innerHTML = id_t[1];
		}else{
			document.getElementById("cssfile").value = "";
			document.getElementById("cssfilespan").innerHTML = "";
		}
	}
}
function onPreviewLayout(){
	openFullWindow("/workflow/html/LayoutPreview.jsp?");
}
function onImportLayout(){
	var urls = "/workflow/html/WorkFlowHtmlBrowser.jsp";
	var id_t = showModalDialog("/systeminfo/BrowserMain.jsp?url="+urls);
	if(id_t){
		if(id_t[0]=="1"){
			self.location.reload();
		}
	}
}
function onExportLayout(){
	document.getElementById("htmloutiframe").src = "/weaver/weaver.file.HtmlFileDownload?modeid=<%=modeId%>";
}
function onPreview(){
	// /formmode/view/AddFormMode.jsp?modeId=16&formId=-263&type=1
	//int type = Util.getIntValue(request.getParameter("type"), -1);
	//int modeId = Util.getIntValue(request.getParameter("modeId"), 0);
	//int formId = Util.getIntValue(request.getParameter("formId"), 0);
	var url = "/formmode/setup/LayoutPreview.jsp?modeId=<%=modeId%>&formId=<%=formId%>&type=<%=type%>";
	openNewFullWindow(url);
}
</script>
</html>