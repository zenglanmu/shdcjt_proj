<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.conn.RecordSet" %>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="csm" class="weaver.cowork.CoworkShareManager" scope="page" />
<%
	int coworkid=Util.getIntValue(request.getParameter("id"),0);
	String from=Util.null2String(request.getParameter("from"));
	
	//System.out.println("coworkid:"+coworkid);
	boolean isAdd="add".equals(from);
	boolean isEdit="edit".equals(from);
	boolean isView="view".equals(from);
%>

<link href="/js/jquery/plugins/weavertabs/weavertabs.css" type="text/css" rel=stylesheet>
<script type="text/javascript" src="/js/jquery/plugins/weavertabs/jquery.weavertabs.js"></script>



<style type="text/css">
a.spanConfirm,a.spanDelete{
	margin:0 5;
	cursor:hand;
}

.tbl tr td{
	padding:5px;
	vertical-align:top;
}
body{overflow:none;}
</style>
<body>
<div  class="weavertabs" style="border:none;">
<%if(isEdit) {%>
	<table  class="weavertabs-nav" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td target="weavertabs-condition"><%=SystemEnv.getHtmlLabelName(430,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td><!--条件-->
			<td target="weavertabs-hrm"><%=SystemEnv.getHtmlLabelName(18605,user.getLanguage())%></td><!--参与人员-->
			<td target="weavertabs-noread"><%=SystemEnv.getHtmlLabelName(17696,user.getLanguage())%></td><!--未查看者-->
		</tr>
	</table>	
<%}%>

<%if(isView) {%>
  <table cellpadding="0" cellspacing="0" width="100%"> 
     <tr>
         <td class="normal_tab active_tab" nowrap="nowrap" align="center" id="condition" target="weavertabs-condition" onclick="changeJoinTab(id,'target')"><%=SystemEnv.getHtmlLabelName(430,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td><!--条件-->
		 <td class="seprator_tab">&nbsp;</td>
         <td class="normal_tab" nowrap="nowrap"  align="center" id="hrm" target="weavertabs-hrm"  onclick="changeJoinTab(id,'target')"><%=SystemEnv.getHtmlLabelName(18605,user.getLanguage())%></td><!--参与人员-->
		 <td class="seprator_tab">&nbsp;</td>
         <td class="normal_tab" nowrap="nowrap" align="center" id="noread" target="weavertabs-noread" onclick="changeJoinTab(id,'target')"><%=SystemEnv.getHtmlLabelName(17696,user.getLanguage())%></td><!--未查看者-->
         <td width="100%" style="border-bottom: 1px solid #CDCDCD;">&nbsp;</td>
     </tr>
  </table>

<%} %>

<div  class="weavertabs-content">
		<div id="weavertabs-condition">		 
			<TABLE id="tbl" class="ListStyle" cellspacing="1" width="100%" style="margin:3px 0 5px 0">
				<COLGROUP>
					<COL width="60">
					<COL width="*">
					<COL width="60">
					<COL width="60">
				</COLGROUP>
					<tr class="Header">
						<th><%=SystemEnv.getHtmlLabelName(18873,user.getLanguage())%></th>
						<th><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></th>
						<th colspan="<%if(!(isAdd||isEdit)) out.print("2");%>"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th>
						<%if(isAdd||isEdit) {%>
						<th>
							<input type="button" style="cursor:pointer" value="<%=SystemEnv.getHtmlLabelName(18645, user.getLanguage())%>" onclick="addUser();">
						    <input type="hidden" name="isChangeCoworker" value="0" id="isChangeCoworker"/>
						    <input type="hidden" name="shareOperation" value="<%=isAdd?"add":"edit"%>"/>
						    <input type="hidden" name="deleteShareids" id="deleteShareids" value="""/>
						</th>
						<%}%>
					</tr>								
				
					<%
						List alist=csm.getShareConditionStrList(""+coworkid);
					    for(int i=0;i<alist.size();i++){
						    HashMap hm=(HashMap)alist.get(i);
							int typelabel=Util.getIntValue((String)hm.get("typeName"));
					%>	
							<tr shareid="<%=hm.get("shareid")%>">
								<td><%=SystemEnv.getHtmlLabelName(typelabel, user.getLanguage())%></td>
								<td style='word-break:break-all'>
								   <%if((isAdd||isEdit)&&((String)hm.get("type")).equals("1")&&typelabel!=2097&&typelabel!=271){ %>
								      <button type="button"  class="Browser  btnShare" onclick="onShowResource('relatedshareid_<%=hm.get("shareid")%>','showrelatedsharename_<%=hm.get("shareid")%>');jQuery('#isChangeCoworker').val(1)" type="button"></button>
								   <%} %>
								   <span class="showrelatedsharename" id="showrelatedsharename_<%=hm.get("shareid")%>" name="showrelatedsharename">
								      <%=hm.get("contentName")%>
								   </span>
								   <%if(typelabel!=2097&&typelabel!=271){ //不是创建者，也不是参与者%>
									   <input type="hidden" name="sharetype" value="<%=hm.get("type")%>">
									   <input type="hidden" name="relatedshareid" id="relatedshareid_<%=hm.get("shareid")%>" value="<%=hm.get("content")%>">
								       <input type="hidden" name="shareid" value="<%=hm.get("shareid")%>">
								   <%} %>
								</td>
								<td align="center"  colspan="<%if(!(isAdd||isEdit)) out.print("2");%>">
								    <%if(typelabel!=2097&&typelabel!=271){ //不是创建者，也不是参与者%>
								      <%if(((String)hm.get("type")).equals("1")){ %>
								        <input type="hidden" value="<%=hm.get("seclevel")%>" name="secLevel" style="display:none"/>
								      <%}else {%>
								         <%=hm.get("seclevel")%> 
								         <input type="hidden" value="<%=hm.get("seclevel")%>" name="secLevel"/>
								      <%} 
								      }%>
								   
								</td>
								<%if(isAdd||isEdit){%>
									<td align="right">
									   <%if(typelabel!=2097&&typelabel!=271){ %>
											<a onclick="return onRowDelete(this,'<%=hm.get("shareid")%>')" href='void(0)' class='spanDelete'><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>
									   <%}%>
									</td>
								<%}%>
							</tr>
					<% }%>
			</TABLE>
			</div>
			<%if(isView||isEdit) {%>
				<div id="weavertabs-hrm">
				    <table class="ListStyle" cellspacing="1" width="100%" style="margin:3px 0 5px 0">
				       <colgroup>
				       <col width="20%">
				       <col width="80%">
				       <tr>
				           <td valign="top"><%=SystemEnv.getHtmlLabelName(17689, user.getLanguage())%></td><!-- 参与者 -->
				           <td>
				               <%
				                List parterids=csm.getShareList("parter",""+coworkid);
								for(int i=0;i<parterids.size();i++){
				                    String userid=(String)parterids.get(i);       
								%>
								  <a href="/hrm/resource/HrmResource.jsp?id=<%=userid%>" target="_blank"><%=Util.toScreen(resourceComInfo.getResourcename((String)userid),user.getLanguage())%></a>
								<%}%>	
				           </td>
				       </tr>
				       <tr>
				           <td valign="top"><%=SystemEnv.getHtmlLabelName(25472, user.getLanguage())%></td><!-- 关注者 -->
				           <td>
				           <% 
				             List   typemanagerids=csm.getShareList("typemanager",""+coworkid);
				             for(int i=0;i<typemanagerids.size();i++){
				                String userid=(String)typemanagerids.get(i);
				             %>  
								<a href="/hrm/resource/HrmResource.jsp?id=<%=userid%>" target="_blank"><%=Util.toScreen(resourceComInfo.getResourcename((String)userid),user.getLanguage())%></a>
							<%} %>	
					       </td>
				       </tr>
				    </table>
				</div>
				<div  id="weavertabs-noread">
				    <table class="ListStyle" cellspacing="1" width="100%" style="margin:3px 0 5px 0">
				       <colgroup>
				       <col width="20%">
				       <col width="80%">
				       <tr>
				           <td valign="top"><%=SystemEnv.getHtmlLabelName(17696,user.getLanguage())%></td><!-- 未查看者 -->
				           <td>
				               <%
								List noReadids=csm.getNoreadUseridList(""+coworkid);
								for(int i=0;i<noReadids.size();i++){
								 String userid=(String)noReadids.get(i);
								%>
								   <a href="/hrm/resource/HrmResource.jsp?id=<%=userid%>" target="_blank"><%=Util.toScreen(resourceComInfo.getResourcename((String)userid),user.getLanguage())%></a>
							  <%}%>	
				           </td>
				       </tr>
                    </table>
				</div>
			<%}%>
	</div>
</div>
</body>
<SCRIPT LANGUAGE="JavaScript">
	
	

	function onRowConfirm(obj){
		var tr=jQuery(obj).parents("tr:first");
		
		if(beforeConfirm(tr)){
			tr[0].disabled=true;
			tr.find("button").remove();
			tr.find("button").remove();
			tr.find(".shareSecLevel").attr("readOnly",true);
			
			//save data to server
			var valueSelect=tr.find(".sharetype").val();
			var content=tr.find(".relatedshareid").val();
			var seclevel=tr.find(".shareSecLevel").val();
			jQuery.get("/cowork/CoworkShareOperate.jsp",{method:'add',coworkid:'<%=coworkid%>',type:valueSelect,content:content,seclevel:seclevel},function(data){				
				tr.attr("shareid",jQuery.trim(data));
			});
			tr.find(".spanConfirm").remove();
		} else {
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		}		
		return false;
	}

	function beforeConfirm(tr){
		var valueSelect=tr.find(".sharetype").val();
		var content=tr.find(".relatedshareid").val();
		var seclevel=tr.find(".shareSecLevel").val();
		
		if(valueSelect==1){
			if(content=='') return false;
		}	else if(valueSelect==5){
			if(seclevel=='') return false;
		}	 else {
			if(content==''||seclevel=='') return false;
		}
		return true;
	}

	function onRowDelete(obj,shareid){
	    jQuery("#isChangeCoworker").val("1");
	    if(shareid!=undefined)
	       jQuery("#deleteShareids").val(jQuery("#deleteShareids").val()+shareid+",");
		var tr=jQuery(obj).parents("tr:first");
		var shareid=tr.attr("shareid");
		tr.remove();		
		return false;
	}

	var index=0;
	function addUser(){
		jQuery("#isChangeCoworker").val("1");
		var str="<tr>"+
		"	<td>"+getShareTypeStr()+"</td>"+
		"	<td>"+getShareContentStr()+"</td>"+
		"	<td align='center'>"+getSecLevel()+"</td>"+		
		"	<td align='right'>"+getOptStr()+"</td>"+
		"</tr>";	
		jQuery("#tbl tbody").append(str);	

		index++;	
	}
	
	function getShareTypeStr(){
		return  "<select class='sharetype inputstyle'  name='sharetype' onChange=\"onChangeConditiontype(this)\" >"+
		"	<option value='1' selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>" +
        "	<option value='2'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>" +
        "	<option value='3'><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>" +
        "	<option value='4'><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>" +
        "	<option value='5'><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>"+
        "</select>";        
	}
	
	function getShareContentStr(){
		return   "<BUTTON type='button' class='Browser  btnShare' onClick=\"onShowResource('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\" type=\"t1\"></BUTTON>"+		
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowSubcompany('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"  type=\"t2\"></BUTTON>"+ 
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowDepartment('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"   type=\"t3\"></BUTTON>"+ 
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowRole('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"  type=\"t4\"></BUTTON>"+
       "<INPUT type='hidden' name='relatedshareid'  class='relatedshareid' id=\"relatedshareid_"+index+"\" value=''>"+ 
       "<input type='hidden' name='shareid' value='0'>"+
       "<span id=showrelatedsharename_"+index+" class='showrelatedsharename'  name='showrelatedsharename'></span>";
	}
	function getSecLevel(){ 
		return "<input class='shareSecLevel inputstyle' style='width:30px;display:none;text-align:center' name='secLevel' value='0' onkeypress='ItemCount_KeyPress()'/>";
	}
	function getOptStr(){
		//return "<a onclick='return onRowConfirm(this)' href='void(0)' class='spanConfirm'><%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%></a>"+
		<%if(isAdd||isEdit) {%>
			return 	   "<a onclick='return onRowDelete(this)' href='void(0)' class='spanDelete'><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>";
		<%} else {%>
			return "";
		<%}%>
	}  

	jQuery(document).ready(function(){	
		<%if(isEdit) {%>
				jQuery(".weavertabs").weavertabs({selected:0,call:function(divId){
			}});		
		<%} else if(!isView) {%>
			jQuery("#weavertabs-condition").show(); 
		<%}%>
	});	          

	function onChangeConditiontype(obj){
		var thisvalue=jQuery(obj).val();
		var jQuerytr=jQuery(obj.parentNode.parentNode);
		jQuerytr.find(".btnShare").hide();		
		jQuerytr.find(".relatedshareid").val("");
		jQuerytr.find(".showrelatedsharename").html("");
		
		//jQuerytr.find(".shareSecLevel").val("");
		jQuerytr.find(".shareSecLevel").hide();

		if(thisvalue==5){
			jQuerytr.find(".showrelatedsharename").hide();
		} else {
			jQuerytr.find(".showrelatedsharename").show();
			jQuerytr.find("button")[(jQuery(obj).val()-1)].style.display='';
		}	
		if(thisvalue!=1){
			jQuerytr.find(".shareSecLevel").show();
		}	
	}
</script>
