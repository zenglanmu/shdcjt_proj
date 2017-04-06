<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.field.FieldManager" scope="page" />
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
	String type = Util.null2String(request.getParameter("type"));
	String type1 = Util.null2String(request.getParameter("type1"));
	String type2 = Util.null2String(request.getParameter("type2"));
	String fielddec = Util.null2String(request.getParameter("fielddec"));
%>

<script language="javascript">
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_field_id') {
if(!document.form2.elements[i].disabled){
	document.form2.elements[i].checked=(checked==true?true:false);
}
} } }


function unselectall()
{
	if(document.form2.checkall0.checked){
	document.form2.checkall0.checked =0;
	}
}
function confirmdel() {
	len=document.form2.elements.length;
	var i=0;
	for(i=0;i<len;i++){
		if (document.form2.elements[i].name=='delete_field_id')
			if(document.form2.elements[i].checked)
				break;
	}
	if(i==len){
		alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		return false;
	}
	return confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>") ;
}

</script>
<body>
<br>
<%
	String fieldid=""+Util.getIntValue(request.getParameter("fieldid"),0);
	String fieldname=Util.null2String(request.getParameter("fieldname"));
	String fielddbtype=Util.null2String(request.getParameter("fielddbtype"));

	ArrayList idList = new ArrayList();
	ArrayList fieldnameList = new ArrayList();
	ArrayList descriptionList = new ArrayList();
	ArrayList fielddbtypeList = new ArrayList();
	ArrayList fieldhtmltypeList = new ArrayList();
	ArrayList typeList = new ArrayList();
	ArrayList textheightList = new ArrayList();
	ArrayList issystemList = new ArrayList();
	ArrayList crmnameList = new ArrayList();
	ArrayList isshowList = new ArrayList();
	ArrayList iseditList = new ArrayList();
	ArrayList ismandList = new ArrayList();
	ArrayList wttypeList = new ArrayList();
	ArrayList orderidList = new ArrayList();
	ArrayList defaultvalueList = new ArrayList();
	ArrayList defaultvaluecnList = new ArrayList();

	String sql = "select id, fieldname, description, fielddbtype, fieldhtmltype, type, issystem, crmname, isshow, wttype, isedit, ismand, orderid, defaultvalue, defaultvaluecn, textheight from worktask_fielddict f left join worktask_taskfield t on f.id=t.fieldid and t.taskid="+wtid+" order by wttype asc, isshow desc, orderid asc";
	//System.out.println(sql);
	String useids = "";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		idList.add(Util.null2String(RecordSet.getString("id")));
		fieldnameList.add(Util.null2String(RecordSet.getString("fieldname")));
		descriptionList.add(Util.null2String(RecordSet.getString("description")));
		fielddbtypeList.add(Util.null2String(RecordSet.getString("fielddbtype")));
		fieldhtmltypeList.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
		typeList.add(Util.null2String(RecordSet.getString("type")));
		issystemList.add(Util.null2String(RecordSet.getString("issystem")));
		crmnameList.add(Util.null2String(RecordSet.getString("crmname")));
		isshowList.add(Util.null2String(RecordSet.getString("isshow")));
		iseditList.add(Util.null2String(RecordSet.getString("isedit")));
		ismandList.add(Util.null2String(RecordSet.getString("ismand")));
		wttypeList.add(Util.null2String(RecordSet.getString("wttype")));
		orderidList.add(Util.null2String(RecordSet.getString("orderid")));
		defaultvalueList.add(Util.null2String(RecordSet.getString("defaultvalue")));
		defaultvaluecnList.add(Util.null2String(RecordSet.getString("defaultvaluecn")));
		textheightList.add(Util.null2String(RecordSet.getString("textheight")));
	}

%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<form name="formField" method="post" action="worktaskFieldOperation.jsp">
	<input type="hidden" name="mothed" value="">
	<input type="hidden" name="wtid" value="<%=wtid%>">
	<input type="hidden" name="wttype_delete" value="" >
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
if(wtid == 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(21930, user.getLanguage())+",javascript:newworktask(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showLog(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;

%>


<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<%
			for(int r=1; r<=3; r++){
				String title_tmp = "";
				if(r == 1){
					title_tmp = SystemEnv.getHtmlLabelName(21932,user.getLanguage());
				}else if(r == 2){
					title_tmp = SystemEnv.getHtmlLabelName(21935,user.getLanguage());
				}else{
					title_tmp = SystemEnv.getHtmlLabelName(21936,user.getLanguage());
				}
		%>
				<table class="viewForm">
					<COLGROUP>
					<COL width="25%">
					<COL width="75%">
					<TBODY>
					<TR class=Title>
						<TH><%=title_tmp%></TH>
						<TH><div align="right">
						<BUTTON Class=btnNew type=button onclick="addrow('<%=r%>')">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%></BUTTON>
						<BUTTON Class=btnDelete type=button onclick="delrow('<%=r%>')">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(702, user.getLanguage())%></BUTTON>
						</div></TH>
					</TR>
					<TR class=Spacing style="height:2px">
						<TD class=Line1 colSpan=2></TD>
					</TR>
					</TBODY>
				</table>
			  <table class=liststyle cellspacing=1 id="table<%=r%>" >
				<COLGROUP>
				<!--xwj for td3344 20051208 begin-->
			<COL width="5%">
			<COL width="12%">
			<COL width="12%">
			<COL width="12%">
			<COL width="9%">
			<COL width="9%">
			<COL width="9%">
			<COL width="8%">
			<COL width="12%">
			<COL width="12%">
				<!--xwj for td3344 20051208 end-->
			<tr class="Header">
				<td></td>
				<td><%=SystemEnv.getHtmlLabelName(21933,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(21938,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(15604,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(15605,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td>
			<TR class=Line><TD colspan="10" ></TD></TR><!--xwj for td3344 20051208-->
				  <%
					int htmltype=0;
					int linecolor=0;
					int fieldtype=0;
					for(int i=0; i<idList.size(); i++){
						String wttype = (String)wttypeList.get(i);
						if(!(""+r).equals(wttype)){
							continue;
						}
						String fieldhtmltype = (String)fieldhtmltypeList.get(i);
						if(fieldhtmltype.equals("1")){
							htmltype=688;
						}else if(fieldhtmltype.equals("2")){
							htmltype=689;
						}else if(fieldhtmltype.equals("3")){
							htmltype=695;
						}else if(fieldhtmltype.equals("4")){
							htmltype=691;
						}else if(fieldhtmltype.equals("5")){
							htmltype=690;
						}else if(fieldhtmltype.equals("6")){
							htmltype=17616;
						}else if(fieldhtmltype.equals("7")){
							htmltype=21691;
						}
						fieldtype = Util.getIntValue((String)typeList.get(i), 0);

						String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));

						String issystem = (String)issystemList.get(i);
						String id = (String)idList.get(i);
						String crmname = Util.null2String((String)crmnameList.get(i));
						String isshow = Util.null2String((String)isshowList.get(i));
						String isedit = Util.null2String((String)iseditList.get(i));
						String ismand = Util.null2String((String)ismandList.get(i));
						int orderid = Util.getIntValue((String)orderidList.get(i), 0);
						String defaultvalue = Util.null2String((String)defaultvalueList.get(i));
						String defaultvaluecn = Util.null2String((String)defaultvaluecnList.get(i));
						int textheight = Util.getIntValue((String)textheightList.get(i));
				  %>
				<tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
					<td>
						<input type="hidden"  name="fieldid" value="<%=id%>" >
					<%if(!"1".equals(issystem)){%>
						<input type="checkbox"  name="delete_field_id<%=r%>" value="<%=id%>" >
					<%} else {%>
					Sys
					<%}%>
					</td>
					<td>
					<%
						if("1".equals(issystem)){
							out.print(Util.null2String((String)fieldnameList.get(i)));
						}else{
							out.print("<a href=\"fieldAdd.jsp?wttype="+wttype+"&src=editfield&fieldid="+id+"&isused=true\">"+Util.null2String((String)fieldnameList.get(i))+"</a>");
						}
					%>
					</td>
					<td><%=Util.toScreen((String)descriptionList.get(i), user.getLanguage())%></td>
					<td><input class=Inputstyle type="text" name="crmname_<%=id%>" size="20" maxlength="10" value="<%=crmname%>"></td>
					<td><input type="checkbox"  name="isshow_<%=id%>" value="1" onClick="changeShow(this)" <%if("1".equals(isshow)){%>checked<%}%>></td>
					<td><input type="checkbox"  name="isedit_<%=id%>" value="1" onClick="changeEdit(this)" <%if("1".equals(isedit)){%>checked<%}%>></td>
					<td><input type="checkbox"  name="ismand_<%=id%>" value="1" onClick="changeMand(this)" <%if("1".equals(ismand)){%>checked<%}%>></td>
					<td><input class=Inputstyle type="text" name="orderid_<%=id%>" size="4" maxlength="2" onKeyPress="ItemCount_KeyPress_self(event)" value="<%=orderid%>"></td>
					<td><%=SystemEnv.getHtmlLabelName(htmltype,user.getLanguage())%></td>
					<td>
						<%
							if((fieldhtmltype.equals("1")&&fieldtype==1) || fieldhtmltype.equals("2")){
						%>
						<input class=Inputstyle type="text" name="defaultvalue_<%=id%>" size="15" maxlength="<%=fieldhtmltype.equals("2")?20:textheight/2-1%>" value="<%=defaultvalue%>">
						<%}else if(fieldhtmltype.equals("1")&&fieldtype==2){%>
						<input class=Inputstyle type="text" name="defaultvalue_<%=id%>" size="15" maxlength="10" onKeyPress="ItemCount_KeyPress_self(event)" value="<%=defaultvalue%>">
						<%}else if(fieldhtmltype.equals("1")&&fieldtype==3){%>
						<input class=Inputstyle type="text" name="defaultvalue_<%=id%>" size="15" maxlength="10" onKeyPress="ItemDecimal_KeyPress()" value="<%=defaultvalue%>">
						<%}else if(fieldhtmltype.equals("4")){%>
						<input type="checkbox"  name="defaultvalue_<%=id%>" value="1" <%if("1".equals(defaultvalue)){%>checked<%}%>>
						<%}else if(fieldhtmltype.equals("3")){
							String url=BrowserComInfo.getBrowserurl(""+fieldtype);     // 浏览按钮弹出页面的url
							String linkurl=BrowserComInfo.getLinkurl(""+fieldtype);    // 浏览值点击的时候链接的url
							%>
							<%if(fieldtype==2 || fieldtype==19){%>
								<input type="hidden" name="defaultvalue_<%=id%>" value="<%=defaultvalue%>" >
								<button class=Browser type="button"   
								<%if(fieldtype==2){%>
								 onclick="onSearchWFDate(defaultvaluespan_<%=id%>, defaultvalue_<%=id%>)"
								<%}else{%>
								 onclick ="onSearchWFTime(defaultvaluespan_<%=id%>, defaultvalue_<%=id%>)"
								<%}%>
								 ></button>
								 <span name="defaultvaluespan_<%=id%>" id="defaultvaluespan_<%=id%>"><%=defaultvalue%></span>
							<%}else if("liableperson".equalsIgnoreCase(fieldname_tmp)){
								out.println(SystemEnv.getHtmlLabelName(21691, user.getLanguage()));
								out.print("<input type=\"hidden\" id=\"defaultvalue_"+id+"\" name=\"defaultvalue_"+id+"\" value=\"\" >");
								out.print("<input type=\"hidden\" id=\"defaultvaluecn_"+id+"\" name=\"defaultvaluecn_"+id+"\" value=\"\" />");
							}else{%>
							<input type="hidden" name="defaultvalue_<%=id%>" value="<%=defaultvalue%>" >
							<input type="hidden" name="defaultvaluecn_<%=id%>" value="<%=defaultvaluecn%>" >
							<button class=Browser type="button" onclick="onShowBrowser2('<%=id%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>')"></button>
							<span name="defaultvaluespan_<%=id%>" id="defaultvaluespan_<%=id%>"><%=defaultvaluecn%></span>
							<%}%>
						<%}else if(fieldhtmltype.equals("5")){%>
							<select class=inputstyle name="defaultvalue_<%=id%>" id="defaultvalueselect_<%=id%>" >
								<option value=""></option>
							<%
								RecordSet.execute("select * from worktask_selectItem where fieldid="+id+" order by orderid");
								while(RecordSet.next()){
									String selectvalue = Util.null2String(RecordSet.getString("selectvalue"));
									String selectname = Util.null2String(RecordSet.getString("selectname"));
							%>
									<option value="<%=selectvalue%>" <%if(defaultvalue.equals(selectvalue)){%>selected<%}%>><%=selectname%></option>
								<%}
							}%>
						</td>
					</tr>
				<%
					if(linecolor==0) linecolor=1;
						else linecolor=0;
					}
				  %>
			  </table>
			  <P>
		<%}%>
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


</form>
<script language="javascript">
function saveData(){
	formField.mothed.value="save";
	formField.submit();
}
function newworktask(){
	parent.location.href = "worktaskAdd.jsp?isnew=1";
}
function showLog(){


}
function changeShow(obj){
	if(obj.checked == false){
		jQuery(jQuery(obj).parents("tr:first").children()[5]).children()[0].checked=false;
		jQuery(jQuery(obj).parents("tr:first").children()[6]).children()[0].checked=false;
		//obj.parentElement.parentElement.children(5).children(0).checked = false;
		//obj.parentElement.parentElement.children(6).children(0).checked = false;
	}
}
function changeEdit(obj){
	if(obj.checked == false){
		//obj.parentElement.parentElement.children(6).children(0).checked = false;
		jQuery(jQuery(obj).parents("tr:first").children()[6]).children()[0].checked=false;
	}else{
		//obj.parentElement.parentElement.children(4).children(0).checked = true;
		jQuery(jQuery(obj).parents("tr:first").children()[4]).children()[0].checked=true;
	}
}
function changeMand(obj){
	if(obj.checked == true){
		//obj.parentElement.parentElement.children(4).children(0).checked = true;
		//obj.parentElement.parentElement.children(5).children(0).checked = true;
		jQuery(jQuery(obj).parents("tr:first").children()[4]).children()[0].checked=true;
		jQuery(jQuery(obj).parents("tr:first").children()[5]).children()[0].checked=true;
	}
}
function addrow(wttype){
	location.href="fieldAdd.jsp?wtid=<%=wtid%>&wttype="+wttype;
}
function delrow(wttype){
	if(confirm("<%=SystemEnv.getHtmlLabelName(21939,user.getLanguage())%>")){
		formField.wttype_delete.value = wttype;
		formField.mothed.value="delete";
		formField.submit();
	}
}
function ItemCount_KeyPress_self(event){
    event = event || window.event
	if(!((event.keyCode>=48) && (event.keyCode<=57))){
		event.keyCode=0;
	}
}
function useSetto(){
	url=escape("/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=0");
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, window);
}

function onShowBrowser2(id,url,linkurl,type1){
ismand = "0";
sHtml = "";
if (type1 == 2 || type1 == 19){
    spanname = "defaultvalue_span"+id;
    inputname = "defaultvalue_"+id;
	if (type1 == 2){
	  onFlownoShowDate(spanname,inputname,ismand);
	}else{
      onWorkFlowShowTime(spanname,inputname,ismand);
	}
	sHtml = jQuery("input[name=defaultvalue_"+id+"]").val();
}else{
	if(type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170){
		id1 = window.showModalDialog(url);
	}else{
        if (type1==135){
			tmpids = jQuery("input[name=defaultvalue_"+id+"]").val();
			id1 = window.showModalDialog(url+"?projectids="+tmpids);
        }else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
	        tmpids = jQuery("input[name=defaultvalue_"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids);
        }else if( type1==37){
	        tmpids = jQuery("input[name=defaultvalue_"+id+"]").val();
			id1 = window.showModalDialog(url+"?documentids="+tmpids);
        }else if( type1==142){
	        tmpids = jQuery("input[name=defaultvalue_"+id+"]").val();
			id1 = window.showModalDialog(url+"?receiveUnitIds="+tmpids);
        }else if (type1==165 || type1==166 || type1==167 || type1==168){
        	index=id.indexof("_");
	        if (index>0){
		        tmpids=unescape("?isdetail=1+fieldid="+ id.substr(1,index-1) +"+resourceids="+jQuery("input[name=defaultvalue_"+id+"]").val());
		        id1 = window.showModalDialog(url+tmpids);
	        }else{
		        tmpids=unescape("?fieldid="+id+"+resourceids="+jQuery("input[name=defaultvalue_"+id+"]").val());
		        id1 = window.showModalDialog(url+tmpids);
	        }
        }else{
	        tmpids = jQuery("input[name=defaultvalue_"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids);
        }
	}
	if (id1!=null){
		if (type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170){
			if (id1.id!= ""  && id1.id!= "0"){
				ids = id1.id.split(",");
				names =id1.name.split(",");
				resourceids = id1.id.substr(2,id1.id.length);
				resourcename = id1.name.substr(2,id1.name.length);
				for( var i=0;i<ids.length;i++){
					if(ids[i]!=""){
						sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_new'>"+names[i]+"</a>&nbsp;";
					}
				}
				jQuery("span[name=defaultvaluespan_"+id+"]").html(sHtml);
				jQuery("input[name=defaultvaluecn_"+id+"]").val(sHtml);
				jQuery("input[name=defaultvalue_"+id+"]").val(resourceids);
			}else{
				if (ismand==0){
					jQuery("span[name=defaultvaluespan_"+id+"]").html(empty);
					jQuery("input[name=defaultvaluecn_"+id+"]").val("");
				}else{
					jQuery("input[name=defaultvalue_"+id+"]").html("<img src='/images/BacoError.gif' align=absmiddle>");
				}
				jQuery("input[name=defaultvalue_"+id+"]").val("");
			}

		}else{
		   if  (id1.id!=""  && id1.id!= "0"){
               if (type1==162){
            	ids = id1.id.split(",");
       			names =id1.name.split(",");
				descs = id1.other1.split(",");
				ids = id1.id.substr(2,id1.id.length);
				jQuery("input[name=defaultvalue_"+id+"]").val(ids);
				names = id1.name.substr(2,id1.name.length);
				descs = id1.other1.substr(2,id1.desc.length);
				for( var i=0;i<ids.length;i++){
					if(ids[i]!=""){
					sHtml = sHtml+"<a title='"+ids[i]+"' >"+names[i]+"</a>&nbsp;";
					}
				}
				jQuery("span[name=defaultvalue_span"+id+"]").html(sHtml);
				jQuery("input[name=defaultvaluecn_"+id+"]").val(sHtml);
                //exit sub
                }
				if (type1==161){
					name = id1.name;
					desc = id1.other1;
					jQuery("input[name=defaultvalue_"+id+"]").val(id1.id);
					sHtml = "<a title='"+desc+"'>"+name+"</a>&nbsp;";
					jQuery("span[name=defaultvaluespan_"+id+"]").html(sHtml);
					jQuery("input[name=defaultvaluecn_"+id+"]").val(sHtml);
					//exit sub
				}
		        if (linkurl == ""){
					jQuery("span[name=defaultvaluespan_"+id+"]").html(id1.name);
					jQuery("input[name=defaultvaluecn_"+id+"]").val(id1.name);
		        }else{
					jQuery("span[name=defaultvaluespan_"+id+"]").html("<a href="+linkurl+id1.id+" target='_new'>"+id1.name+"</a>");
					jQuery("input[name=defaultvaluecn_"+id+"]").val("<a href="+linkurl+id1.id+" target='_new'>"+id1.name+"</a>");
		        }
				jQuery("input[name=defaultvalue_"+id+"]").val(id1.id);

		   }else{
				if (ismand==0){
					jQuery("span[name=defaultvaluespan_"+id+"]").html(empty);
					jQuery("input[name=defaultvaluecn_"+id+"]").val("");
				}else{
					jQuery("span[name=defaultvaluespan_"+id+"]").html("<img src='/images/BacoError.gif' align=absmiddle>");
				}
				jQuery("input[name=defaultvalue_"+id+"]").val("");
		   }
		}
	}
}
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<script type="text/javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</body>
</html>