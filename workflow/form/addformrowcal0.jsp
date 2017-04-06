<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
 <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<HTML><HEAD>

<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    if(!ajax.equals("1")){
%>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver.js"></script>
<%
    }
%>
</head>

<%
	String formname="";
	String formdes="";
	String createtype = Util.null2String(request.getParameter("createtype")) ;	
	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
    int subCompanyId2 = -1;
    int subCompanyId= -1;
	if(formid!=0) RecordSet.executeSql("select * from workflow_bill where id="+formid);
	if(RecordSet.next()){
		formname = SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage());
		formdes = RecordSet.getString("formdes");
		formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
		formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	  subCompanyId2 = RecordSet.getInt("subcompanyid");
	  subCompanyId = subCompanyId2;
		formdes = Util.StringReplace(formdes,"\n","<br>");
	}

    ArrayList detailid = new ArrayList();
    ArrayList detaillable = new ArrayList();
    ArrayList groupIds= new ArrayList();
    ArrayList signid = new ArrayList();
    signid.add("+");
    signid.add("-");
    signid.add("*");
    signid.add("/");
    signid.add("=");
    signid.add("(");
    signid.add(")");

    ArrayList signlable = new ArrayList();
    signlable.add("＋");
    signlable.add("－");
    signlable.add("×");
    signlable.add("÷");
    signlable.add("＝");
    signlable.add("（");
    signlable.add("）");

    String rowcalstr = "";
    String sql = "select * from workflow_formdetailinfo where formid ="+formid;
    if(formid!=0) RecordSet.executeSql(sql);
    if(RecordSet.next()){
        rowcalstr = RecordSet.getString("rowcalstr");
    }

    sql = "select * from workflow_billfield where viewtype=1 and fieldhtmltype=1 and (type=2 or type=3 or type=4 or type=5) and billid="+formid+"  order by id";
    if(formid!=0) RecordSet.executeSql(sql);
    while(RecordSet.next()){
        detailid.add(RecordSet.getString("id"));
        detaillable.add(SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage()));
        groupIds.add(RecordSet.getString("detailtable"));
    }
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int operatelevel=0;

    if(detachable==1){  
        //subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FormManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FormManage:All", user))
            operatelevel=2;
    }

%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18368,user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";
%>
<script language="JavaScript">

</script>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<br>

<%
if(operatelevel>0){
    if(!ajax.equals("1"))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveRole(),_self}" ;
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:rowsaveRole1(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
if(!ajax.equals("1")){
if(createtype.equals("2")) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",FormDesignMain.jsp?src=editform&formid="+formid+",_self}" ;
}
else {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",addform.jsp?src=editform&formid="+formid+",_self}" ;
}
RCMenuHeight += RCMenuHeightStep ;
}
}
%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<form name="rowcalfrm" method="post" action="/workflow/form/formrole_operation0.jsp" >
<input type="hidden" value="rowcalrole" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=createtype%>" name="createtype">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" name="curindex" id="curindex" value="0">
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



<table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
   <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height: 1px" >
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></td>
    <td class=field><strong><%=Util.toScreen(formname,user.getLanguage())%><strong></td>
  </tr><TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR> <strong></strong>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></td>
    <td class=field><strong><%=Util.toScreen(formdes,user.getLanguage())%></strong></td>
  </tr><TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
</table>

<table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
   <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr height=20>
    <td><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></td>
    <td class=field><span id="rowcalexp" style="color:red"></span></td>
  </tr><TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR>
    <tr height=20>
    <td><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%></td>
    <td class=field >
<%
    for(int i=0; i<detailid.size(); i++){
%>
    <a href="#" accessKey="detailfield_<%=detailid.get(i)%>" id="<%=groupIds.get(i)%>" onclick="addexp(this);"><%=detaillable.get(i)%></a>&nbsp;&nbsp;
<%
    }
%>
    </td>
  </tr><TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR>

  <tr height=20>
    <td><%=SystemEnv.getHtmlLabelName(18743,user.getLanguage())%></td>
    <td class=field ><b>
        <a href="#" accessKey="+" onclick="addexp(this)">＋</a>
        <a href="#" accessKey="-" onclick="addexp(this)">－</a>
        <a href="#" accessKey="*" onclick="addexp(this)">×</a>
        <a href="#" accessKey="/" onclick="addexp(this)">÷</a>
        <a href="#" accessKey="=" onclick="addexp(this)">＝</a>
        <a href="#" accessKey="(" onclick="addexp(this)">（</a>
        <a href="#" accessKey=")" onclick="addexp(this)">）</a>
        <a href="#" onclick="addcalnumber()"><%=SystemEnv.getHtmlLabelName(193,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%></a>
        </b>
    </td>
  </tr><TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR>
  <tr>
    <td></td>
    <td class=field >
    <BUTTON Class=Btn type=button accessKey=B onclick="removeexp()"><U>B</U>-<%=SystemEnv.getHtmlLabelName(18744,user.getLanguage())%></BUTTON>
    <BUTTON Class=Btn type=button accessKey=A onclick="addRowCal()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
    </td>
  </tr>
  <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
</table>
<br>

<table class="viewform" id="allcalexp">
  <COLGROUP>
   <COL width="90%">
   <COL width="10%">
  <TR class="Title">
    	  <TH colSpan=3><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(579,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=3></TD></TR>
  <tr class=header>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></td>
    <td align=center class=field></td>
  </tr>
      <TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=3></TD></TR>
<%
    StringTokenizer stk = new StringTokenizer(rowcalstr,";");
    while(stk.hasMoreTokens()){
        String token = stk.nextToken();
        String token2 = token;
        if(!token2.equals("")){
            for(int i=0; i<signid.size(); i++){
                token2 = Util.StringReplace(token2,""+signid.get(i),signlable.get(i)+"");
            }
            for(int i=0; i<detailid.size(); i++){
                token2 = Util.StringReplace(token2,"detailfield_"+detailid.get(i),"<span style='color:#000000'>"+detaillable.get(i)+"</span>");           }

        }
%>
  <tr style="background:#efefef">
    <td style="color:red"><div><%=token2%><input type="hidden" name="calstr" value="<%=token%>"></div></td>
    <td ><div><a href="#" onclick="deleteRowcal(this)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></div></td>
  </tr>
<%
    }
%>

</table>

<br>

<SPAN style="color:red"><%=SystemEnv.getHtmlLabelName(19734, user.getLanguage())%></SPAN>

</form>

</center>
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function saveRole(){
    rowcalfrm.submit();
}

var fieldid = new Array();
var fieldlable = new Array();
var curindex = 0;
var currowcalexp = "";
var groups="";
function addexp(obj){		
    fieldid[curindex]=obj.accessKey;	
    if("+-*/()=".indexOf(obj.accessKey)==-1){
    	if (groups==""||groups==obj.id){
			fieldlable[curindex]="<span style='color:#000000'>"+obj.innerHTML+"</span>";
			groups=obj.id;
    	}else{
			alert('<%=SystemEnv.getHtmlLabelName(18909,user.getLanguage())%>');
			return;
    	}
    }else{
    	fieldlable[curindex]=obj.innerHTML; 
    }	
	
    curindex++;
    refreshcal();
}
function removeexp(){
    curindex --;
    if(curindex<0){
        curindex = 0;
    }
    refreshcal();
}

function refreshcal(){
    currowcalexp = "";
    document.all("rowcalexp").innerHTML="";
    for(var i=0; i<curindex; i++){
        currowcalexp+=fieldid[i];
        document.all("rowcalexp").innerHTML+=fieldlable[i];
    }
}

function addRowCal(){
    if(currowcalexp==""){
        return;
    }
    
    var error_msg = "<%=SystemEnv.getHtmlLabelName(27783,user.getLanguage())%>"; 
    
    //------------------------------------------
    // 表达式check开始
    //------------------------------------------
    var equalsIndex = currowcalexp.indexOf("=");
    if (equalsIndex < 0) {
    	alert(error_msg);
    	return;
    }
    //等于号之前的内容
    var calexpEqa_bef = currowcalexp.substring(0, equalsIndex);
    //等于号之后的内容
    var calexpEqa_aft = currowcalexp.substring(equalsIndex+1, currowcalexp.length);
	//赋值语句之前必须指定一个变量
	if (calexpEqa_bef.indexOf("detailfield_") == -1) {
		alert(error_msg);
		return;
	}
    
    calexpEqa_bef = calexpEqa_bef.replace("detailfield_", "");
    //赋值语句之前指定了过多的变量
    if (calexpEqa_bef.indexOf("detailfield_") != -1) {
    	alert(error_msg);
		return;
    }
    //第一个等号之前不能含有操作符
    var symbols = ["+", "-", "*", "/", "(", ")"];
    for (var i=0; i<symbols.length; i++) {
    	var symbol = symbols[i];
    	if (calexpEqa_bef.indexOf(symbol) != -1) {
    		alert(error_msg);
			return;
    	}
    }
    
    calexpEqa_aft = calexpEqa_aft.replace(new RegExp("detailfield_" ,"gm"), "");
    try {
    	if (isNaN(eval("("+calexpEqa_aft+")"))) {
    		alert(error_msg);
    		return;
    	}
    } catch (e) {
    	alert(error_msg);
    	return;
    }
    //------------------------------------------
    // 表达式check结束
    //------------------------------------------
    
    oRow = allcalexp.insertRow(-1);
    oRow.style.background= "#efefef";

    oCell = oRow.insertCell(-1);
    oCell.style.color="red";
    var oDiv = document.createElement("div");
    var sHtml = document.all("rowcalexp").innerHTML+"<input type='hidden' name='calstr' value='"+currowcalexp+"'>";

    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    oDiv = document.createElement("div");
    oCell = oRow.insertCell(-1);
    var sHtml = "<a href='#' onclick='deleteRowcal(this)'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    clearexp();
}

function clearexp(){
    currowcalexp = "";
    groups="";
    curindex=0;
	fieldid = new Array();
	fieldlable = new Array();	

    document.all("rowcalexp").innerHTML="";	
	document.getElementById("curindex").value=curindex;	
}

function deleteRowcal(obj){
    //alert(obj.parentElement.parentElement.parentElement.rowIndex);
    if(confirm('<%=SystemEnv.getHtmlLabelName(18688,user.getLanguage())%>')){
        allcalexp.deleteRow(jQuery(obj).parent().parent().parent()[0].rowIndex);
    }
}

function addcalnumber(){
    var calnumber = prompt('<%=SystemEnv.getHtmlLabelName(18689,user.getLanguage())%>',"1.0");
    if(calnumber!=null){
        fieldid[curindex]=calnumber;
        fieldlable[curindex]=calnumber;
        curindex++;

        refreshcal();
    }
}
</script>
<%}%>
</body>
</html>