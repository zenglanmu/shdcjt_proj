<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%/*
	关于字段的数据库类型的中文表述没完成，需要另外添加标签

*/%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.field.FieldManager" scope="page" />
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(684,user.getLanguage());
String needfav ="1";
String needhelp ="";
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
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>



<br>
<%
	String fieldid=""+Util.getIntValue(request.getParameter("fieldid"),0);
	String fieldname=Util.null2String(request.getParameter("fieldname"));
	String fielddbtype=Util.null2String(request.getParameter("fielddbtype"));
	String fieldhtmltype=Util.null2String(request.getParameter("fieldhtmltype"));

    String sql = "select fieldid from workflow_formfield group by fieldid";
    String useids = "";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        useids += ","+RecordSet.getString(1);
    }

    //int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int detachable=0;//字段管理不分权，TD10331
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FieldManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FieldManage:All", user))
            operatelevel=2;
    }
    String fieldhtmltypeForSearch = Util.null2String(request.getParameter("fieldhtmltypeForSearch"));
    String type = Util.null2String(request.getParameter("type"));
    String type1 = Util.null2String(request.getParameter("type1"));
    String fieldnameForSearch = Util.null2String(request.getParameter("fieldnameForSearch"));
    String fielddec = Util.null2String(request.getParameter("fielddec"));
%>
<form name="form2" method="post" action="deldetailfields.jsp">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:searchData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:doReset(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
if(operatelevel>0){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",addfield.jsp?srcType=detailfield,_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}
if(operatelevel>1){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%}
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

      <table class=liststyle cellspacing=1  >
      	<COLGROUP>
  	   	<!--xwj for td3344 20051208 begin-->
  	<COL width="5%">
  	<COL width="5%">
  	<COL width="20%">
  	<COL width="10%">
  	<COL width="20%">
  	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
  		<!--xwj for td3344 20051208 end-->
        <TR class="Header">
    	  <TH colSpan=9><%=SystemEnv.getHtmlLabelName(684,user.getLanguage())%></TH></TR><!--xwj for td3344 20051208-->
        <TR class="Header">
          <TH colSpan=9><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%><!--xwj for td3344 20051208-->
            <input type="radio" name=srcType value="mainfield"  onclick="location='managefield.jsp'"><%=SystemEnv.getHtmlLabelName(18549,user.getLanguage())%>
            <input type="radio" name=srcType value="detailfield" checked><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%>
          </TH>
        </TR>
<tr class="Header">
		<td colspan="2"><nobr><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></nobr></td>
		<td class=field><input type=text name=fieldnameForSearch class=Inputstyle value="<%=fieldnameForSearch%>"></td>
		<td><nobr><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></nobr></td>
		<td class=field><input type=text name=fielddec class=Inputstyle value="<%=fielddec%>"></td>
    <td><nobr><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></nobr></td>
    <td class=field>
    <select class=inputstyle  size="1" name="fieldhtmltypeForSearch" onchange="showType()">
    <option value="0"></option>
    <option value="1" <%if(fieldhtmltypeForSearch.equals("1")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
    <option value="2" <%if(fieldhtmltypeForSearch.equals("2")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
    <option value="3" <%if(fieldhtmltypeForSearch.equals("3")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
    <option value="4" <%if(fieldhtmltypeForSearch.equals("4")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
    <option value="5" <%if(fieldhtmltypeForSearch.equals("5")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
    </select>
    </td>
    <td><span id=typename>
    	<%if(fieldhtmltypeForSearch.equals("1")||fieldhtmltypeForSearch.equals("3")){%>
    		<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>
    	<%}%>
    </span></td>
	  <td class=field>
	  <select class=inputstyle  size="1" name="type" <%if(fieldhtmltypeForSearch.equals("1")){%> style="display:''"<%}else{%> style="display:none" <%}%>>
	    <option value="0"></option>
	    <option value="1" <%if(type.equals("1")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
	    <option value="2" <%if(type.equals("2")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
	    <option value="3" <%if(type.equals("3")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
	    <option value="4" <%if(type.equals("4")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
	    <option value="5" <%if(type.equals("5")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
	  </select>
	  <select class=inputstyle  size="1" name="type1" <%if(fieldhtmltypeForSearch.equals("3")){%> style="display:''"<%}else{%> style="display:none" <%}%>>
	    <option value="0"></option>
	    <%while(BrowserComInfo.next()){
	    		String browserid = Util.null2String(BrowserComInfo.getBrowserid());
	    		int browserlableid = Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0);
	    %>
	    	<option value="<%=browserid%>" <%if(type1.equals(browserid)){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(browserlableid,user.getLanguage())%></option>
	    <%}%>
	   </select>
	  </td>
  	</div>
</tr>
          <input type=hidden name=fieldid value="<%= fieldid %>">
          <input type=hidden name=fieldname value="<%= fieldname %>">
          <input type=hidden name=fielddbtype value="<%= fielddbtype %>">
          <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></td>
            <td colspan="2"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
             <td colspan="2"><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td><!--added by xwj for td3344 20051208-->
            <td colspan="2"><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></td>
            <td colspan="2"><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
          </tr>
	<TR class=Line><TD colspan="9" ></TD></TR><!--xwj for td3344 20051208-->
          <%
          if(operatelevel>-1){
            FieldMainManager.resetParameter();
            FieldMainManager.setSubCompanyId(subCompanyId);
              FieldMainManager.setFieldNameForSearch(fieldnameForSearch);
              FieldMainManager.setFieldDec(fielddec);
              FieldMainManager.setHtmlType(fieldhtmltypeForSearch);
              FieldMainManager.setFieldType(type);
              FieldMainManager.setFieldType1(type1);
            FieldMainManager.selectDetailField();
            int htmltype=0;
	    int linecolor=0;
	    int fieldtype=0;
	    String dbtype="";
	    String strlength="";
	    String dbtypedesc="";
            while(FieldMainManager.next()){
              FieldInfo = FieldMainManager.getFieldManager();
              if(FieldInfo.getFieldhtmltype().equals("1"))
              	htmltype=688;
              else if(FieldInfo.getFieldhtmltype().equals("2"))
              	htmltype=689;
              else if(FieldInfo.getFieldhtmltype().equals("3"))
              	htmltype=695;
              else if(FieldInfo.getFieldhtmltype().equals("4"))
              	htmltype=691;
              else if(FieldInfo.getFieldhtmltype().equals("5"))
              	htmltype=690;

              fieldtype=FieldInfo.getType();
              dbtype=FieldInfo.getFielddbtype();
              if(FieldInfo.getFieldhtmltype().equals("1")&&fieldtype==1)
              	strlength=dbtype.substring(8,dbtype.length()-1);

              if(FieldInfo.getFieldhtmltype().equals("1")){
              	if(fieldtype==1)	dbtypedesc=strlength+"bits string";
              	if(fieldtype==2)	dbtypedesc="integer";
              	if(fieldtype==3)	dbtypedesc="float";
              }
              if(FieldInfo.getFieldhtmltype().equals("2")){
              	dbtypedesc="textarea";
              }
              if(FieldInfo.getFieldhtmltype().equals("3")){
              	dbtypedesc=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(fieldtype+""),0),user.getLanguage())+"browser button";
              }
              if(FieldInfo.getFieldhtmltype().equals("4")){
              	dbtypedesc="check box";
              }
              if(FieldInfo.getFieldhtmltype().equals("5")){
              	dbtypedesc="integer";
              }
          %>
          <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
            <td>
            <%if(!Util.toScreen(FieldInfo.getFieldname(),user.getLanguage()).equals("manager")&&!Util.toScreen(FieldInfo.getFieldname(),user.getLanguage()).equals("president")){%>
            <input type="checkbox"  name="delete_field_id" value="<%=FieldInfo.getFieldid()%>" onClick=unselectall() <%=(useids.indexOf(""+FieldInfo.getFieldid())!=-1)?"disabled":""%> >
            <%} else {%>
            Sys
            <%}%>
            </td>
            <td colspan="2">
            <%if(!Util.toScreen(FieldInfo.getFieldname(),user.getLanguage()).equals("manager")&&!Util.toScreen(FieldInfo.getFieldname(),user.getLanguage()).equals("president")){%>
            <!--modify by xhheng @ 20041213 for TDID 1230-->
            <a href="addfield.jsp?fieldnameForSearch=<%=fieldnameForSearch%>&fielddec=<%=fielddec%>&fieldhtmltypeForSearch=<%=fieldhtmltypeForSearch%>&type=<%=type%>&type1=<%=type1%>&srcType=detailfield&src=editfield&fieldid=<%=FieldInfo.getFieldid()%>&isused=<%=(useids.indexOf(""+FieldInfo.getFieldid())!=-1)?"true":"false"%>"><%}%>
            <%=Util.toScreen(FieldInfo.getFieldname(),user.getLanguage())%></a></td>
            <td colspan="2"><%=Util.toScreen(FieldInfo.getDescription(),user.getLanguage())%></td><!--xwj for td3344 20051208-->
            <td colspan="2"><%=SystemEnv.getHtmlLabelName(htmltype,user.getLanguage())%>
            <%if(FieldInfo.getFieldhtmltype().equals("3")){%> - <%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(fieldtype+""),0),user.getLanguage())%><%}%>
            </td>
            <td colspan="2"><%=Util.toScreen(dbtype+"",user.getLanguage())%></td>
          </tr>
          <%
          if(linecolor==0) linecolor=1;
          else linecolor=0;
          }
            FieldMainManager.closeStatement();
          }
          %>
          <tr class="header">
            <td colspan=9>
              <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
              <%=SystemEnv.getHtmlLabelName(694,user.getLanguage())%></td>
          </tr>
      </table>
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
function submitData()
{
	if (confirmdel())
	{
	    if(confirm("<%=SystemEnv.getHtmlLabelName(22288,user.getLanguage())%>"))
	    {
		form2.submit();
      }
    }
}

function searchData(){
	para1 = document.all("fieldhtmltypeForSearch").value;
	para2 = document.all("type").value;
	para3 = document.all("type1").value;
	para4 = document.all("fieldnameForSearch").value;
	para5 = document.all("fielddec").value;
	window.location="managedetailfield.jsp?fieldhtmltypeForSearch="+para1+"&type="+para2+"&type1="+para3+"&fieldnameForSearch="+para4+"&fielddec="+para5;
	//form2.action="managefield.jsp";
	//form2.submit();
}
function doReset(){
		document.getElementById("fieldnameForSearch").value="";
		document.getElementById("fielddec").value="";
		document.getElementById("fieldhtmltypeForSearch").value="0";
		document.getElementById("type").value="0";
		document.getElementById("type").style.display="none";
		document.getElementById("type1").value="0";
		document.getElementById("type1").style.display="none";
		typename.innerHTML="";
}
function showType(){
	htmltype=document.all("fieldhtmltypeForSearch").value;
	if(htmltype==1){
		typename.innerHTML='<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>';
		document.getElementById("type").style.display='';
		document.getElementById("type1").value='0';
		document.getElementById("type1").style.display='none';
	}else if(htmltype==3){
		typename.innerHTML='<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>';
		document.getElementById("type1").style.display='';
		document.getElementById("type").value='0';
		document.getElementById("type").style.display='none';
	}else{
		typename.innerHTML='';
		document.getElementById("type").value='0';
		document.getElementById("type").style.display='none';
		document.getElementById("type1").value='0';
		document.getElementById("type1").style.display='none';
	}
}
function submitClear()
{
	btnclear_onclick();
}

</script>
</body>
</html>