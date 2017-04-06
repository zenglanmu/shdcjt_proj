<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17088,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>

<%

    String userid =""+user.getUID();
    /*权限判断,人力资产管理员以及其所有上级*/
    boolean canView = false;
    ArrayList allCanView = new ArrayList();
    String tempsql ="select resourceid from HrmRoleMembers where roleid in (select roleid from SystemRightRoles where rightid=22)";
    RecordSet.executeSql(tempsql);
    while(RecordSet.next()){
        String tempid = RecordSet.getString("resourceid");
        allCanView.add(tempid);
    }// end while
    for (int i=0;i<allCanView.size();i++){
        if(userid.equals((String)allCanView.get(i))){
            canView = true;
        }
    }
    if(!canView) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
    /*权限判断结束*/


    int id = Util.getIntValue(request.getParameter("id"),0);
    RecordSet.executeSql("select * from cus_treeform where scope='HrmCustomFieldByInfoType' and id="+id);
    RecordSet.next();
    int parentid = RecordSet.getInt("parentid");
    String viewType = Util.null2String(RecordSet.getString("viewtype"));
    boolean canEdit = true;
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;

    if(!viewType.equals("1")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(17550,user.getLanguage())+",AddHrmCustomField.jsp?parentid="+id+",_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    if(id != 1 && id != 3){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteField(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
    }
}
if(parentid!=0){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",EditHrmCustomField.jsp?method=delete&id="+parentid+",_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}else{
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",HrmCustomFieldManager.jsp,_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver action="HrmCustomFieldOperation.jsp" method=post >

  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="id" value="<%=id%>">
  <input type="hidden" name="parentid" value="<%=parentid%>">

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

<TABLE class="viewform">
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class="viewform">
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR class="Title">
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class="Spacing" style="height:1px">
          <TD class="Line1" colSpan=2></TD></TR>
<%
    if(id != 1 && id != 3){
%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17549,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=Inputstyle maxLength=50 size=20 name="formlabel" value="<%=RecordSet.getString("formlabel")%>" onchange='checkinput("formlabel","formlabelimage")'><SPAN id=formlabelimage><%if(RecordSet.getString("formlabel").equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR> <TR class="Spacing" style="height:1px;">
<%
    }else{
%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17549,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("formlabel")%></TD>
        </TR> <TR class="Spacing"  style="height:1px">
        <input type=hidden name="formlabel" value="<%=RecordSet.getString("formlabel")%>">
<%
    }
%>
          <TD class="Line" colSpan=2></TD></TR>

          <input type=hidden name="viewtype" value="<%=RecordSet.getString("viewtype")%>">
<%
    if(id != 1 && id != 3){
%>
          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=Inputstyle maxLength=3 size=20 name="scopeorder" value="<%=RecordSet.getString("scopeorder")%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'></TD>
         </TR>   <TR class="Spacing" style="height:1px">
          <TD class="Line" colSpan=2></TD></TR>
<%
    }else{
%>
        <input type=hidden name="scopeorder" value="<%=RecordSet.getString("scopeorder")%>">
<%
    }
%>
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>

        <%--自定义字段--%>
<SCRIPT LANGUAGE=javascript>
function addrow(){
	var oRow;
	var oCell;

	oRow = jQuery("#inputface")[0].insertRow(-1);
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = jQuery("#flable").html() ;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = jQuery("#fhtmltype").html();
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = jQuery("#ftype1").html() ;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = jQuery("#ftype5").html() ;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.innerHTML = jQuery("#fismand").html() ;
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = jQuery("#action").html() ;

}

function addrow2(obj){
	var tobj = jQuery(jQuery(obj).parents("tr")[0].cells[3]).find("table")[0];
	var oRow;
	var oCell;

	oRow = tobj.insertRow(-1);
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#fselectitem").html() ;
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#itemaction").html() ;

}

function delitem(obj){
	var rowobj = jQuery(obj).parent().parent();

	jQuery(rowobj).remove();

}

function upitem(obj){
	if(jQuery(obj).parent().parent().index()==0){
		return;
	}
	var tobj = jQuery(obj).parents("table")[0];
	var rowobj = tobj.insertRow(jQuery(obj).parent().parent().index()-1);
	for(var i=0; i<2; i++){
		var cellobj = rowobj.insertCell(-1);
        //cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = jQuery(obj).parents("tr")[0].cells[i].innerHTML;
	}

	tobj.deleteRow(jQuery(obj).parent().parent().index());

}

function downitem(obj){
	if(jQuery(obj).parent().parent().index()==jQuery(obj).parent().parent().parent().find("tr").length-1){
		return;
	}
	var tobj = jQuery(obj).parents("table")[0];
	var rowobj = tobj.insertRow(jQuery(obj).parent().parent().index()+2);
	for(var i=0; i<2; i++){
		var cellobj = rowobj.insertCell(-1);
        //cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = jQuery(obj).parents("tr")[0].cells[i].innerHTML;
	}

	tobj.deleteRow(jQuery(obj).parent().parent().index());

}

function del(obj){
	var rowobj = jQuery(obj).parent().parent();

	jQuery(rowobj).remove();

}

function up(obj){
	if(jQuery(obj).parent().parent().index()==0){
		return;
	}
	var tobj = jQuery(obj).parents("table")[0];
	
	var rowobj = tobj.insertRow(jQuery(obj).parent().parent().index()-1);
	for(var i=0; i<6; i++){
		var cellobj = rowobj.insertCell(-1);
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = jQuery(obj).parents("tr")[0].cells[i].innerHTML;
	}

	tobj.deleteRow(jQuery(obj).parent().parent().index());

}

function down(obj){
	if(jQuery(obj).parent().parent().index()==jQuery(obj).parents("table")[0].rows.length-1){
		return;
	}
	var tobj = jQuery(obj).parents("table")[0];
	var rowobj = tobj.insertRow(jQuery(obj).parent().parent().index()+2);
	for(var i=0; i<6; i++){
		var cellobj = rowobj.insertCell(-1);
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = jQuery(obj).parents("tr")[0].cells[i].innerHTML;
	}

	tobj.deleteRow(jQuery(obj).parent().parent().index());

}

function htmltypeChange(obj){
	if(obj.selectedIndex == 0){
		jQuery(obj).parents("tr")[0].cells[2].innerHTML=jQuery("#ftype1").html() ;
		jQuery(obj).parents("tr")[0].cells[3].innerHTML=jQuery("#ftype5").html() ;
	}else if(obj.selectedIndex == 2){
		jQuery(obj).parents("tr")[0].cells[2].innerHTML=jQuery("#ftype2").html() ;
		jQuery(obj).parents("tr")[0].cells[3].innerHTML=jQuery("#ftype4").html() ;
	}else if(obj.selectedIndex == 4){
		jQuery(obj).parents("tr")[0].cells[2].innerHTML=jQuery("#fselectaction").html() ;
		jQuery(obj).parents("tr")[0].cells[3].innerHTML=jQuery("#fselectitems").html() ;
	}else{
		jQuery(obj).parents("tr")[0].cells[2].innerHTML=jQuery("#ftype3").html() ;
		c.cells[3].innerHTML=jQuery("#ftype4").html() ;
	}
}

function typeChange(obj){
	if(obj.selectedIndex == 0){
		jQuery(obj).parents("tr")[0].cells[3].innerHTML=jQuery("#ftype5").html();
	}else{
		jQuery(obj).parents("tr")[0].cells[3].innerHTML=jQuery("#ftype4").html();
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
        jQuery("iframe[name=selectItemGetter]").src="SelectRowGetter.jsp?fieldid="+ret;
    }
}

</SCRIPT>

<script language="javascript">
function showSelectRow(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CustomSelectFieldBrowser.jsp");
	if (data!=null){
        return data.id;
	}else{
        return "";
	}
}
</script>
<iframe name="selectItemGetter" style="width:100%;height:200;display:none"></iframe>
<%
    String disableLable = "disabled";
    if(canEdit){
        disableLable="";
%>
<br>
<b>包含字段</b>
<hr>
<BUTTON Class=Btn type=button accessKey=A onclick="addrow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%></BUTTON>
<%
    }
%>
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
	<select size=1 name=type onChange = "typeChange(this)">
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
	</select>
</div>

<div style="DISPLAY: none" id="ftype2">
	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
	<select size=1 name=type>
    <%while(BrowserComInfo.next()){
	   	 if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())){
	        	 //屏蔽集成浏览按钮-zzl
			continue;
			}
    %>
		<option value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),7)%></option>
    <%}%>
	</select>
</div>

<div style="DISPLAY: none" id="ftype3">
	<input name=type type=hidden value="0">
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
	<input name=type type=hidden  value="0">
	<BUTTON Class=Btn type=button accessKey=A onclick="addrow2(this)"><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></BUTTON><br>
    <BUTTON Class=Btn type=button accessKey=I onclick="importSel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></BUTTON>
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
<hr>
<%
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",id);
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
        <input name=type type="hidden" value="<%=cfm.getType()%>">
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
            <input name=type type="hidden" value="<%=cfm.getType()%>">
        </td>
        <td style="border-bottom:silver 1pt solid">
            <input name=flength type=hidden  value="100">
        </td>
    <%}else if(cfm.getHtmlType().equals("5")){%>
        <td style="border-bottom:silver 1pt solid">
            <input name=type type=hidden  value="0">
<%
    if(canEdit){
%>
            <BUTTON Class=Btn type=button accessKey=A onclick="addrow2(this)"><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></BUTTON><br>
            <BUTTON Class=Btn type=button accessKey=I onclick="importSel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></BUTTON>
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
                <img src="/images/icon_ascend.gif" height="14" onclick="upitem(this)">
                <img src="/images/icon_descend.gif" height="14" onclick="downitem(this)">
                <img src="/images/delete.gif" height="14" onclick="delitem(this)">
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
            <input name=type type=hidden  value="0">
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
    <%%>

        <td style="border-bottom:silver 1pt solid">
            <img src="/images/icon_ascend.gif" height="14" onclick="up(this)">
            <img src="/images/icon_descend.gif" height="14" onclick="down(this)">
            <img src="/images/delete.gif" height="14" onclick="del(this)">
        </td>
    </tr>
    <%}%>
</COLGROUP>
</TABLE>

        <%--自定义字段结束--%>
<%
    if(id == 1 || id == 3){
%>

<TABLE class=liststyle cellspacing=1  >
  <COLGROUP>
  <COL width="40%">
  <%--<COL width="30%">--%>
  <COL width="60%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(17549,user.getLanguage())%></th>
  <%--<th>类型</th>--%>
  <th><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></th>
  </tr>
<%
    boolean isLight = false;
    RecordSet.executeSql("select * from cus_treeform where scope='HrmCustomFieldByInfoType' and parentid="+id+" order by scopeorder");
	while(RecordSet.next()){
		if(isLight = !isLight){%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="EditHrmCustomField.jsp?id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("formlabel")%></a></TD>
		<%--<TD><%=RecordSet.getString("viewtype").equals("0")?"单条记录":"多条记录"%></TD>--%>
		<TD><%=Util.getIntValue(RecordSet.getString("scopeorder"),0)%></TD>
	</TR>
<%
	}
%>
 </TABLE>
<%
	}
%>

	</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="0" colspan="3"></td>
</tr>
</table>

</FORM>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'formlabel')){
        clearTempObj();
		weaver.submit();
    }
}

function deleteField(mid,mparentid){
    if(isdel()){
        document.all("method").value="delete";
        clearTempObj();
        weaver.submit();
    }
}
</script>
</BODY>
</HTML>
