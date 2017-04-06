<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="WFInfo" class="weaver.workflow.workflow.WFManager" scope="page" />
<jsp:useBean id="WFMainManager" class="weaver.workflow.workflow.WFMainManager" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>

<%
WFMainManager.resetParameter();
String isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),0)+"";
String tabletitlename=SystemEnv.getHtmlLabelName(2079,user.getLanguage());
String memotitle=SystemEnv.getHtmlLabelName(15594,user.getLanguage());
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
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
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }
%>
<jsp:setProperty name="WFMainManager" property = "*"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script language="javascript">
<%if(detachable==1){%>
if(parent.parent.oTd1.style.display!="none"){
	parent.parent.oTd1.style.display="none";
}
<%}%>
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_wf_id') {
    if(document.form2.elements[i].disabled == false){
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
	len = document.form2.elements.length;
	var i=0;
	var hasitem = 0;
	for( i=0; i<len; i++) {
		if (document.form2.elements[i].name=='delete_wf_id') {
			if(document.form2.elements[i].checked==true)
				hasitem = 1;
		}
	}
	if(hasitem == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return false;
	}
	return confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>£¿") ;
}

function OpenNewWindow(sURL,w,h)
{
  var iWidth = 0 ;
  var iHeight = 0 ;
  iWidth=(window.screen.availWidth-10)*w;
  iHeight=(window.screen.availHeight-50)*h;
  ileft=(window.screen.availWidth - iWidth)/2;
  itop= (window.screen.availHeight - iHeight + 50)/2;
  var szFeatures = "" ;
  szFeatures =	"resizable=no,status=no,menubar=no,width=" +
				iWidth + ",height=" + iHeight*h + ",top="+itop+",left="+ileft
  window.open(sURL,"",szFeatures)
}

</script>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="1";
String needhelp ="";
if(isTemplate.equals("1")){
    titlename=SystemEnv.getHtmlLabelName(18334,user.getLanguage());
    tabletitlename=SystemEnv.getHtmlLabelName(18151,user.getLanguage());
    memotitle=SystemEnv.getHtmlLabelName(433,user.getLanguage());
}

%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	String wfid=""+Util.getIntValue(request.getParameter("wfid"),0);
	String formid=""+Util.getIntValue(request.getParameter("formid"),0);
	String wfname=Util.null2String(request.getParameter("wfname"));
	String wfdes=Util.null2String(request.getParameter("wfdes"));
	String wfnameQuery=Util.null2String(request.getParameter("wfnameQuery"));
	int typeid=Util.getIntValue(request.getParameter("typeid"),0);
    String templatestr="";
    if(isTemplate.equals("1")){
       templatestr=" and isTemplate=1";
    }else{
       templatestr=" and (isTemplate is null or isTemplate <> 1)";
    }
    session.setAttribute("treeleft"+isTemplate,typeid+"");
    Cookie ck = new Cookie("treeleft"+isTemplate+user.getUID(),typeid+"");  
    ck.setMaxAge(30*24*60*60);
    //added by cyril on 2008-08-20 for td:9215
    session.setAttribute("treeleft_cnodeid"+isTemplate,wfid+"");
    ck = new Cookie("treeleft_cnodeid"+isTemplate+user.getUID(),wfid+"");  
    ck.setMaxAge(30*24*60*60);
    response.addCookie(ck);
  	//end by cyril on 2008-08-20 for td:9215
%>
 <form name="form2" method="post"  action="managewf.jsp">
<%if(operatelevel>0){

RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",addwf.jsp?isTemplate="+isTemplate+"&typeid="+typeid+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
if(operatelevel>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
if(operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:wfSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
//add by xhheng @ 2004/12/08 for TDID 1317
if(RecordSet.getDBType().equals("db2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:wflogdb2() ,_self} " ;
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:wflog() ,_self} " ;
}
RCMenuHeight += RCMenuHeightStep ;
}%>
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
     <table class=ViewForm>
         <COLGROUP>
  	<COL width="20%">
  	<COL width="30%">
  	<COL width="20%">
  	<COL width="30%">
      <TR>
    	  <td class=Field><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    	  <td><select class=inputstyle  name=typeid onChange="wfSearch()" >
    	  	<option value="0">&nbsp;</option>
    	  	<%
		    while(WorkTypeComInfo.next()){
		     	String checktmp = "";
		     	if(typeid == Util.getIntValue(WorkTypeComInfo.getWorkTypeid()))
		     		checktmp=" selected";
		%>
		<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=checktmp%>><%=WorkTypeComInfo.getWorkTypename()%></option>
		<%
		}
		%>
    	  </select>
          <td class=Field><%=tabletitlename%></td>
          <td><input type="text" class=inputstyle name="wfnameQuery" style="width:90%" value="<%=wfnameQuery%>"></td>
    	  </td>
    	  </TR>
     </table>
     <table class=liststyle cellspacing=1  >
      	<COLGROUP>
    <COL width="8%">
  	<COL width="20%">
  	<COL width="30%">
  	<COL width="25%">
  	<COL width="17%">

          <input type=hidden name=wfid value="<%= wfid %>">
          <input type=hidden name=typeid value="<%= typeid %>">
          <input type=hidden name=formid value="<%= formid %>">
          <input type=hidden name=wfname value="<%= wfname %>">
          <input type=hidden name=wfdes value="<%= wfdes %>">
          <input type=hidden name=isTemplate value="<%=isTemplate%>">
          <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=tabletitlename%></td>
            <td><%=memotitle%></td>
            <td><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
          </tr>
		  <TR class=Line><TD colspan="5" ></TD></TR>
          <%

	    int linecolor=0;

        if(operatelevel>-1){
        WFMainManager.setWftypeid(typeid);
	    WFMainManager.setWfnameQuery(Util.fromScreen(wfnameQuery.trim(),user.getLanguage()));
        WFMainManager.setSubCompanyId(subCompanyId);
        WFMainManager.setIsTemplate(isTemplate);
            WFMainManager.selectWf();


            while(WFMainManager.next()){
              WFInfo = WFMainManager.getWFManager();

          %>
           <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
            <td>
              <!-- add by xhheng @20050204 for TD 1534 -->
              <input type="checkbox"  name="delete_wf_id" value="<%=WFInfo.getWfid()%>" <%=(!isTemplate.equals("1") && WFInfo.getIsused()==1)?"disabled":""%>>
            </td>
            <td><a href="addwf.jsp?src=editwf&wfid=<%=WFInfo.getWfid()%>&isTemplate=<%=isTemplate%>"><%=WFInfo.getWfname()%></a></td>
            <td><%=WFInfo.getWfdes()%></td>
            <%
            String isbill = WFInfo.getIsBill();
            
            boolean isnewform = false;
            int newformlabelid = 0;
            RecordSet.executeSql("select namelabel from workflow_bill where tablename='formtable_main_"+WFInfo.getFormid()*(-1)+"' and id="+WFInfo.getFormid());
            if(RecordSet.next()){
                isnewform=true;
                newformlabelid = RecordSet.getInt("namelabel");
            }
            
            if(isbill.equals("0")&&!isnewform){
            %>
            <td><%=FormComInfo.getFormname(""+WFInfo.getFormid())%></td>
            <%}
            else if(isbill.equals("1")||isnewform){
            	int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+WFInfo.getFormid()));
            	if(isnewform) labelid = newformlabelid;
            %>
            <td><%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%></td>
            <%}else{%>
            <td></td>
            <%}%>
            <td><%=WorkTypeComInfo.getWorkTypename(""+WFInfo.getTypeid())%></td>
          </tr>
          <%
           if(linecolor==0) linecolor=1;
          else linecolor=0;
          }
            WFMainManager.closeStatement();
        }
          %>
          <tr class="Header">
            <td colspan="5" height="19">
              <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
              <%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%></td>
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
	if (confirmdel()) {
        form2.action="delwfs.jsp";
		form2.submit();
		enableAllmenu();
        parent.wfleftFrame.location="wfmanage_left2.jsp?isTemplate=<%=isTemplate%>";
    }
}

function submitClear()
{
	btnclear_onclick();
}

function wfSearch(){
	form2.action="managewf.jsp";
	form2.submit();
	enableAllmenu();
}
function wflogdb2(){
    window.location="/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+escape("where int(operateitem)=85<%=templatestr%>");
}
function wflog(){
    window.location="/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+escape("where operateitem=85<%=templatestr%>");
}
</script>
</body>
</html>