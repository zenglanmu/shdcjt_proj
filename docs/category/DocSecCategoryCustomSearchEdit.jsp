<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.docs.category.security.AclManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script src="/js/prototype.js" type="text/javascript"></script>
</HEAD>

<%
    String id = Util.null2String(request.getParameter("id"));
	SecCategoryDocPropertiesComInfo.addDefaultDocProperties(Util.getIntValue(id));
	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String subcategoryid=RecordSet.getString("subcategoryid");
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
	//初始值
    boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	AclManager am = new AclManager();
	//hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
	//hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
	hasSecManageRight = am.hasPermission(Util.getIntValue(id,-1), AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_CREATEDIR);
    String disableLable = "disabled";
    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add",user) || hasSubManageRight || hasSecManageRight) {
		canEdit = true ;
        disableLable="";
    }
%>
<BASE TARGET="_parent">
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%//菜单
if (canEdit) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>

<FORM METHOD="POST" name="frmCustomSearch" ACTION="DocSecCategoryCustomSearchEditOperation.jsp">
	<INPUT TYPE="hidden" NAME="method" VALUE="save">
	<INPUT TYPE="hidden" NAME="secCategoryId" value="<%=id%>">
	<%
	int useCustomSearch = 0;
	RecordSet.executeSql("select * from DocSecCategory where id = " + id);
	if(RecordSet.next()){
	    useCustomSearch = RecordSet.getInt("useCustomSearch");
	}
	%>
	<table class="viewForm">
		<COLGROUP>
		<COL width="25%">
		<COL width="75%">
		<TBODY>
		<TR class=Title>
			<TH colSpan=2><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TH>
		</TR>
		<TR class=Spacing>
	        <TD class=Line1 colSpan=2></TD>
		</TR>
	
	   	<TR>
	     	<TD><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20237,user.getLanguage())%></TD>
	     	<TD class=Field>
	      		<input class=InputStyle type=checkbox value=1 name=useCustomSearch <%=(useCustomSearch==1)?"checked":""%>  <%=disableLable%>>
	     	</TD>
	   	</TR>
	   	
	   	<TR><TD class=Line colSpan=2></TD></TR>
	   	
		</TBODY>
	</table>
	
	<table class="viewForm">
		<COLGROUP>
		<COL width="25%">
		<COL width="75%">
		<TBODY>
		<TR class=Title>
			<TH colSpan=2><%=SystemEnv.getHtmlLabelName(20237,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%></TH>
		</TR>
		<TR class=Spacing>
           	<TD class=Line1 colSpan=2></TD>
		</TR>
		</TBODY>
	</table>
		
	<TABLE width=100% class=ListStyle cellspacing=1>
		<TBODY>
		<COLGROUP>
		<col width="10%">
		<col width="*">
		<col width="20%">
		<col width="20%">
		<col width="20%">
		</COLGROUP>
		<THEAD>
		    <TR class=Header>
		        <th><%=SystemEnv.getHtmlLabelName(338, user.getLanguage())%></th>
		        <th><%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%></th>
		        <th><%=SystemEnv.getHtmlLabelName(15603, user.getLanguage())%></th>
		        <th><%=SystemEnv.getHtmlLabelName(22837, user.getLanguage())%></th>
		        <th><%=SystemEnv.getHtmlLabelName(23824, user.getLanguage())%></th>
		    </TR>
		</THEAD>
	</TABLE>	

	<TABLE width=100% class="viewForm" cellspacing="1" id="inputsetting">
		<TBODY>
		<COLGROUP>
		<col width="10%">
		<col width="*">
		<col width="20%">
		<col width="20%">
		<col width="20%">
		</COLGROUP>
		<TR class=Spacing><TD class=Line colSpan=5></TD></TR>
		<%

        List canAsCondList=new ArrayList();
		canAsCondList.add("1");//1:文档标题
		canAsCondList.add("9");//9：部门
		canAsCondList.add("21");//21：文档所有者
		SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(Util.getIntValue(id));
		RecordSet.executeSql("select * from DocSecCategoryCusSearch where secCategoryId = "+id+" order by viewindex");
		int i=0;
		while(RecordSet.next()){
			int currId = RecordSet.getInt("id");
			int currDocPropertyId = RecordSet.getInt("docPropertyId");
			int currVisible = RecordSet.getInt("visible");
			int currIsCond = RecordSet.getInt("isCond");
			int currCondColumnWidth = RecordSet.getInt("condColumnWidth");

			int currLabelId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
			String currCustomName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+""));
			
			int currType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType(currDocPropertyId+""));
			
			String currName = (currCustomName.equals("")&&currLabelId>0)?SystemEnv.getHtmlLabelName(currLabelId, user.getLanguage()):currCustomName;
			
			int tempIndexId=currName.lastIndexOf("(自定义)");
			if(tempIndexId<=0){
				tempIndexId=currName.lastIndexOf("(user-defined)");
			}
			if(tempIndexId>0){
				currName=currName.substring(0,tempIndexId);
			}			

			i++;
		%>
		<TR>
			<TD>
				<input type="hidden" name="propertyid" value="<%=currId%>">
				<input type="hidden" name="docpropertyid" value="<%=currDocPropertyId%>">
				<img id="imgArrowUp" src="/images/ArrowUpGreen.gif" onclick="onSettingUp(this);" style="cursor:hand<%if(i==1){%>;visibility:hidden<%}%>" <%=disableLable%>>&nbsp;
				<img id="imgArrowDown" src="/images/ArrowDownRed.gif" onclick="onSettingDown(this);" style="cursor:hand<%if(i==RecordSet.getCounts()){%>;visibility:hidden<%}%>" <%=disableLable%>>
			</TD>
			<TD>
				<%=currName%>
			</TD>
			<%if(currType==10||currType==20) {%>
			<TD class=Field>
				<INPUT type="checkbox" class=InputStyle name="chk_visible" disabled=true>
				<INPUT type="hidden" class=InputStyle name="visible" value="<%=currVisible%>">
			</TD>
			<%}else{ %>
				<TD class=Field>
					<INPUT type="checkbox" class=InputStyle name="chk_visible" onclick="this.parentElement.children(1).value=(this.checked)?1:0;" <%=currVisible!=0?"checked":""%> <%=currVisible==-1?"checked disabled":""%> <%=disableLable%>>
					<INPUT type="hidden" class=InputStyle name="visible" value="<%=currVisible%>">
				</TD>
			<%} %>
			<TD class=Field>
				<INPUT type="checkbox" class=InputStyle name="chk_isCond" onclick="this.parentElement.children(1).value=(this.checked)?1:0;" <%=currIsCond!=0?"checked":""%> <%=(currType>=1&&canAsCondList.indexOf(""+currType)==-1)?"disabled":""%> <%=disableLable%>>
				<INPUT type="hidden" class=InputStyle name="isCond" value="<%=currIsCond%>">
			</TD>
			<TD class=Field>
				<select class=InputStyle name="select_condColumnWidth" <%=disableLable%>  <%if(disableLable.equals("")&&currType>=1&&canAsCondList.indexOf(""+currType)==-1){%>disabled<%}%> onchange="this.parentElement.children(1).value=this.value">
					<option value="1" <%if(currCondColumnWidth==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19802,user.getLanguage())%></option>
					<option value="2" <%if(currCondColumnWidth==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19803,user.getLanguage())%></option>
				</select>
				<INPUT type="hidden" class=InputStyle name="condColumnWidth" value="<%=currCondColumnWidth%>">
			</TD>
		</TR>
		<TR class=Spacing><TD class=Line colSpan=6></TD></TR>
		<%
		}
		%>
		</TBODY>
	</TABLE>

<SCRIPT LANGUAGE=javascript>
function onSave(obj){
	obj.disabled = true;
	document.frmCustomSearch.submit();
}
var colNum = 5;

function onSettingUp(obj){
	var currRow = obj.parentElement.parentElement;
	
	if(currRow!=null){
		var currTable = currRow.parentElement.parentElement;
		if(currRow.rowIndex-1<=0) return;

		var insRow1 = currTable.insertRow(currRow.rowIndex-2<0?0:currRow.rowIndex-2);
		var insCell1 = insRow1.insertCell();
		insCell1.colSpan = colNum;
		insCell1.className = "Line";

		var insRow2 = currTable.insertRow(insRow1.rowIndex<0?0:insRow1.rowIndex);
		
		for(var i=0; i<colNum; i++){
			var insCell2 = insRow2.insertCell();
	    	if(i>1) insCell2.className = "field";
			insCell2.innerHTML = currRow.cells[i].innerHTML;
	    	
		}

		currTable.deleteRow(obj.parentElement.parentElement.rowIndex+1);
		currTable.deleteRow(obj.parentElement.parentElement.rowIndex);
	}
	setImgArrow();
}

function onSettingDown(obj){
	var currRow = obj.parentElement.parentElement;
	if(currRow!=null){
		var currTable = currRow.parentElement.parentElement;
		if(currRow.rowIndex+2>=currTable.rows.length) return;

		var insRow1 = currTable.insertRow(currRow.rowIndex+3>currTable.rows.length?currTable.rows.length:currRow.rowIndex+3);
		var insCell1 = insRow1.insertCell();
		insCell1.colSpan = colNum;
		insCell1.className = "Line";

		var insRow2 = currTable.insertRow(insRow1.rowIndex+1>currTable.rows.length?currTable.rows.length:insRow1.rowIndex+1);
		for(var i=0; i<colNum; i++){
			var insCell2 = insRow2.insertCell();
	    	if(i>1) insCell2.className = "field";
			insCell2.innerHTML = currRow.cells[i].innerHTML;
		}

		currTable.deleteRow(obj.parentElement.parentElement.rowIndex-1);
		currTable.deleteRow(obj.parentElement.parentElement.rowIndex);
		
	}
	setImgArrow();
}

function setImgArrow(){
	var imgArrow = $A(document.getElementsByName('imgArrowUp'));
	for(var i=0;imgArrow!=null&&i<imgArrow.length;i++){
		if(i==0) imgArrow[i].style.visibility = "hidden";
		else imgArrow[i].style.visibility = "visible";
	}
	var imgArrow = $A(document.getElementsByName('imgArrowDown'));
	for(var i=0;imgArrow!=null&&i<imgArrow.length;i++){
		if(i==(imgArrow.length-1)) imgArrow[i].style.visibility = "hidden";
		else imgArrow[i].style.visibility = "visible";
	}
}

</SCRIPT>


</FORM>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

</BODY>
</HTML>