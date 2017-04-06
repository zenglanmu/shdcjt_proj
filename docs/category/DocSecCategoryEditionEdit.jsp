<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.docs.category.security.AclManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script src="/js/prototype.js" type="text/javascript"></script>
</HEAD>

<%
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String subcategoryid=RecordSet.getString("subcategoryid");
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
	//³õÊ¼Öµ
    boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	AclManager am = new AclManager();
	hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
	hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);

    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSubManageRight || hasSecManageRight) {
		canEdit = true ;
	}
%>
<BASE TARGET="_parent">
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
  //²Ëµ¥
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM METHOD="POST" name="frmEdition" ACTION="DocSecCategoryEditionOperation.jsp">
<INPUT TYPE="hidden" NAME="method" VALUE="save">
<INPUT TYPE="hidden" NAME="secCategoryId" value="<%=id%>">
<%
int currEditionIsOpen = 0;
String currEditionPrefix = "";
int currReaderCanViewHistoryEdition = 0;

int isNotDelHisAtt = 0;

RecordSet.executeSql("select * from DocSecCategory where id = " + id);
if(RecordSet.next()){
	currEditionIsOpen = RecordSet.getInt("editionIsOpen");
	currEditionPrefix = RecordSet.getString("editionPrefix");
	currReaderCanViewHistoryEdition = RecordSet.getInt("readerCanViewHistoryEdition");
	isNotDelHisAtt = Util.getIntValue(Util.null2String(RecordSet.getString("isNotDelHisAtt")),0);
}
%>
	
<table class="viewForm">
	<COLGROUP>
	<COL width="30%">
	<COL width="70%">
	<TBODY>
	<TR class=Title>
		<TH colSpan=2><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TH>
	</TR>
	<TR class=Spacing style="height: 1px!important;">
        <TD class=Line1 colSpan=2></TD>
	</TR>

   	<TR>
     	<TD><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19450,user.getLanguage())%></TD>
     	<TD class=Field>
      		<input class=InputStyle type=checkbox value=1 name=editionIsOpen <%=(currEditionIsOpen==1)?"checked":""%> <%if(!canEdit){%>disabled<%}%>>
     	</TD>
   	</TR>
   	
   	<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
   	
</TBODY>
</TABLE>


<table class="viewForm">
	<COLGROUP>
	<COL width="30%">
	<COL width="70%">
	<TBODY>
	<TR class=Title>
		<TH colSpan=2><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
	</TR>
	<TR class=Spacing style="height: 1px!important;">
        <TD class=Line1 colSpan=2></TD>
	</TR>

    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(583,user.getLanguage())%></TD>
        <TD class=Field>
           	<input class=InputStyle type="text" value="<%=currEditionPrefix%>" name="editionPrefix" <%if(!canEdit){%>disabled<%}%>>
        </TD>
    </TR>

	<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(19528,user.getLanguage())%></TD>
        <TD class=Field>
           	<input class=InputStyle type=checkbox value=1 name="readerCanViewHistoryEdition" <%=(currReaderCanViewHistoryEdition==1)?"checked":""%> <%if(!canEdit){%>disabled<%}%>>
        </TD>
    </TR>
    
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(24436,user.getLanguage())%></TD>
        <TD class=Field>
            <INPUT class=InputStyle type=checkbox <%if(isNotDelHisAtt==1){%>checked<%}%> value=1 name="isNotDelHisAtt"  <%if(!canEdit){%>disabled<%}%>>
        </TD>
    </TR>
    
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

	</TBODY>
</TABLE>

<script>
function onSave(obj){
	document.frmEdition.submit();
	obj.disabled = true;
}
</SCRIPT>
</FORM>

</BODY>
</HTML>