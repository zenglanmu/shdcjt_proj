<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="FormInfo" class="weaver.workflow.form.FormManager" scope="page" />
<jsp:useBean id="FormMainManager" class="weaver.workflow.form.FormMainManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%FormMainManager.resetParameter();%>
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    if(!ajax.equals("1")){
%>
<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver.js"></script>
<%
    }
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";
if(!ajax.equals("1")){
%>
<script language="javascript">
function formCheckAll(checked) {
	len = document.fromaddtab.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		//TD12654
		if (document.fromaddtab.elements[i].name=='delete_form_id'
			||document.fromaddtab.elements[i].name=='delete_newform_id') {
			if(!document.fromaddtab.elements[i].disabled){
			    document.fromaddtab.elements[i].checked=(checked==true?true:false);
			}
		} 
	} 
}


function unselectall()
{
    if(document.fromaddtab.checkall0.checked){
	document.fromaddtab.checkall0.checked =0;
    }
}
function confirmdel() {
	len=document.fromaddtab.elements.length;
	var i=0;
	for(i=0;i<len;i++){
		if (document.fromaddtab.elements[i].name=='delete_form_id'||document.fromaddtab.elements[i].name=='delete_newform_id')
			if(document.fromaddtab.elements[i].checked)
				break;
	}
	if(i==len){
		alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		return false;
	}
	return confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?") ;
}

</script>
<%}%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<br>
<%
	String formid=""+Util.getIntValue(request.getParameter("formid"),0);
	String formname=Util.null2String(request.getParameter("formname"));
	String formdes=Util.null2String(request.getParameter("formdes"));

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
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FormManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FormManage:All", user))
            operatelevel=2;
    }
    
    String formnameForSearch = "";
    String formtypeForSearch = "";
    //formnameForSearch = Util.null2String(request.getParameter("formnameForSearch"));
    formnameForSearch= Util.toScreenToEdit(request.getParameter("formnameForSearch"),user.getLanguage());
    formtypeForSearch = Util.null2String(request.getParameter("formtypeForSearch"));

%>
<form name="fromaddtab" method="post">
<input type=hidden name=formid value="<%= formid %>">
<input type=hidden name=formname value="<%= formname %>">
<input type=hidden name=formdes value="<%= formdes %>">
<input type=hidden name="ajax" value="<%=ajax%>">
<%
if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearchForm(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
if(operatelevel>0){
%>

<%
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",addDefineForm.jsp,_self}" ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:formaddtab(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}
if(operatelevel>1){
%>
<%
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitData(),_self}" ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:formnodedel(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%}
%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
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
     	<COL width=10>
     	<COL width="25%">
        <COL width="10%">
        <COL width="10%">
     	<COL width="10%">
     	<COL width="35%">
        <TR class="Header">
    	  <TH colSpan=6><%=SystemEnv.getHtmlLabelName(699,user.getLanguage())%></TH></TR>

        <%if(!ajax.equals("1")){%>
        <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></td>
            <td class=field><input type=text name=formnameForSearch class=Inputstyle value='<%=Util.toScreenToEdit(formnameForSearch.replace("&","&amp;"),user.getLanguage())%>'></td>
            <td><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%></td>
            <td class=field colspan=3>
                <select id="formtypeForSearch" name="formtypeForSearch">
                    <option value="" <%if(formtypeForSearch.equals("")){%>selected<%}%>></option>
                    <option value=0 <%if(formtypeForSearch.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
                    <option value=1 <%if(formtypeForSearch.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
                </select>
            </td>
        </tr>
        <%}%>
        
        <tr class=header>
          <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></td>
        </tr><TR class=Line><TD colspan="6"  style="padding: 0px"></TD></TR>
          <%
          if(operatelevel>-1){
              RecordSet.executeSql("SELECT DISTINCT formid FROM workflow_base where isbill='0' ");
              StringBuffer sb = new StringBuffer();
              String allRef = "";
              while(RecordSet.next()){
                  allRef += "," + RecordSet.getString(1);
              }



          int linecolor=0;
          FormMainManager.setSubCompanyId(subCompanyId);
          FormMainManager.selectForm();
          String showmodeid="";
          String printmodeid="";
          while(FormMainManager.next()&&!formtypeForSearch.equals("1")){
              FormInfo = FormMainManager.getFormManager();
              
              if(!formnameForSearch.equals("")&&FormInfo.getFormname().replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''").indexOf(formnameForSearch.replace("&","&amp;").replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''"))==-1) continue;
              
              //add by mackjoe at 2005-12-13
              int temid=FormInfo.getFormid();
              showmodeid="";
              printmodeid="";
              rs.executeSql("SELECT id,isprint FROM workflow_Formmode where isbill='0' and formid="+temid);
              while(rs.next()){
                 int isprint=Util.getIntValue(rs.getString("isprint"),-1);
                 String modeid=Util.null2String(rs.getString("id"));
                 if(isprint==0){
                    showmodeid=modeid;
                    printmodeid=modeid;
                 }else{
                     if(isprint==1){
                        printmodeid=modeid;
                     }
                 }
              }
              //end by mackjoe

          %>
          <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
            <td>
              <input type="checkbox"  id="delete_form_id" name="delete_form_id" value="<%=FormInfo.getFormid()%>" <%=allRef.indexOf(","+FormInfo.getFormid())==-1?"":"disabled"%> onClick=unselectall()>
            </td>
            <td>
            <%if(ajax.equals("1")){%>
                <a href='javascript:gotab00("/workflow/form/addform.jsp?ajax=<%=ajax%>&src=editform&formid=<%=FormInfo.getFormid()%>","<%=FormInfo.getFormid()%>")'>
            <%}else{%>
                <a href="/workflow/form/addDefineForm.jsp?isoldform=1&formid=<%=FormInfo.getFormid()%>">
            <%}%>
                <%=Util.toScreen(FormInfo.getFormname().replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''"),user.getLanguage())%></a></td>
            <td><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></td>
            <!--add by mackjoe at 2005-12-13-->
            <td><%if(operatelevel>0){%><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=temid%>&isbill=0&isprint=0&modeid=<%=showmodeid%>&ajax=<%=ajax%>')"><%}%>
            	<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%><%if(operatelevel>0){%></a><%}%></td>
            <td><%if(operatelevel>0){%><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=temid%>&isbill=0&isprint=1&modeid=<%=printmodeid%>&ajax=<%=ajax%>')"><%}%>
            	<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%if(operatelevel>0){%></a><%}%></td>
            <!--end by mackjoe-->
            <td><%=Util.toScreen(FormInfo.getFormdes(),user.getLanguage())%></td>
          </tr>
          <%
          	if(linecolor==0)	linecolor=1;
          	else	linecolor=0;
          }
            FormMainManager.closeStatement();
            
            
              RecordSet.executeSql("SELECT formid,id,isprint FROM workflow_Formmode where isbill='1'");
              ArrayList showmodelist = new ArrayList();
              ArrayList printmodelist= new ArrayList();
              ArrayList formlist=new ArrayList();
              if(RecordSet.next()){
                  formlist.add(Util.null2String(RecordSet.getString("formid")));
                  int isprint=Util.getIntValue(RecordSet.getString("isprint"),-1);
                  String modeid=Util.null2String(RecordSet.getString("id"));
                  if(isprint==0){
                    showmodelist.add(modeid);
                    if(RecordSet.next()){
                        printmodelist.add(Util.null2String(RecordSet.getString("id")));
                    }else{
                        printmodelist.add(modeid);
                    }
                  }else{
                    printmodelist.add(modeid);
                    showmodelist.add("");
                  }
              }

              if(detachable==1) RecordSet.executeSql("SELECT id ,namelabel,tablename,formdes FROM workflow_bill where subcompanyid="+subCompanyId+" and invalid is null order by id desc");
            	else RecordSet.executeSql("SELECT id ,namelabel,tablename,formdes FROM workflow_bill where invalid is null order by id desc");
              String id = "";
              int namelabel = 0;
              String showmodeid1="";
              String printmodeid1="";
              while(RecordSet.next()&&!formtypeForSearch.equals("1")){
                  id=Util.null2String(RecordSet.getString("id"));
                  String tablename = Util.null2String(RecordSet.getString("tablename"));
                  int id_integer = RecordSet.getInt("id");
                  formdes = RecordSet.getString(4);
                  formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
                  boolean flag = false;
                  if(tablename.equals("formtable_main_"+id_integer*(-1))) flag = true;
                  if(!flag) continue;
                  namelabel=Util.getIntValue(RecordSet.getString("namelabel"),0);
                  String tempformname = Util.null2String(SystemEnv.getHtmlLabelName(namelabel,user.getLanguage()));
                  tempformname = tempformname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
              
                  if(!formnameForSearch.equals("")&&tempformname.indexOf(formnameForSearch.replace("&","&amp;").replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''"))==-1) continue;
                  
                  showmodeid1="";
                  printmodeid1="";
                  rs.executeSql("SELECT id,isprint FROM workflow_Formmode where isbill='1' and formid="+id);
                  while(rs.next()){
                      int isprint=Util.getIntValue(rs.getString("isprint"),-1);
                      String modeid=Util.null2String(rs.getString("id"));
                      if(isprint==0){
                        showmodeid1=modeid;
                        printmodeid1=modeid;
                      }else{
                          if(isprint==1){
                              printmodeid1=modeid;
                          }
                      }
                  }
                  String candelete = "disabled";
                  if(flag){
                  	rs.executeSql("select * from workflow_base where formid="+id);
                  	if(!rs.next()) candelete = "";//新建表单没有被引用，则可以被删除。
                  }
                  
		          %>
		          <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		            <td>
		              <input type="checkbox"  id="delete_newform_id" name="delete_newform_id" value="<%=id%>"  <%=candelete%>>
		            </td>
		            <td>
		            	<%if(ajax.equals("1")){%>
		            		<a href='javascript:gotab00_new("/workflow/form/editform.jsp?ajax=<%=ajax%>&formid=<%=id%>","<%=id%>")'>
		            	<%}else{%>
		            		<a href="/workflow/form/addDefineForm.jsp?formid=<%=id%>">
		            	<%}%>
		            	<%=tempformname%></a>
		            </td>
            		<td><%if(flag){%><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></td><%}else{%>
            		<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></td><%}%>
		            <td><%if(operatelevel>0){%><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=id%>&isbill=1&isprint=0&modeid=<%=showmodeid1%>')"><%}%>
		            	<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%><%if(operatelevel>0){%></a><%}%></td>
		            <td><%if(operatelevel>0){%><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=id%>&isbill=1&isprint=1&modeid=<%=printmodeid1%>')"><%}%>
		            	<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%if(operatelevel>0){%></a><%}%></td>
		            <td><%=formdes%></td>
		          </tr>
		          <%
		          	if(linecolor==0)	linecolor=1;
		          	else	linecolor=0;
		          }

            if(!ajax.equals("1")){  
              if(detachable==1) RecordSet.executeSql("SELECT id ,namelabel,tablename,formdes FROM workflow_bill where subcompanyid="+subCompanyId+" and invalid is null order by id asc");
            	else RecordSet.executeSql("SELECT id ,namelabel,tablename,formdes FROM workflow_bill where invalid is null order by id asc");
              id = "";
              namelabel = 0;
              showmodeid1="";
              printmodeid1="";
              while(RecordSet.next()&&!formtypeForSearch.equals("0")){
                  id=Util.null2String(RecordSet.getString("id"));
                  String tablename = Util.null2String(RecordSet.getString("tablename"));
                  int id_integer = RecordSet.getInt("id");
                  formdes = RecordSet.getString(4);
                  boolean flag = false;
                  if(tablename.equals("formtable_main_"+id_integer*(-1))) flag = true;
                  if(flag) continue;
                  namelabel=Util.getIntValue(RecordSet.getString("namelabel"),0);
                  String tempformname = Util.null2String(SystemEnv.getHtmlLabelName(namelabel,user.getLanguage()));
                  tempformname = tempformname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");

                  if(!formnameForSearch.equals("")&&tempformname.indexOf(formnameForSearch)==-1) continue;
                  
                  showmodeid1="";
                  printmodeid1="";
                  rs.executeSql("SELECT id,isprint FROM workflow_Formmode where isbill='1' and formid="+id);
                  while(rs.next()){
                      int isprint=Util.getIntValue(rs.getString("isprint"),-1);
                      String modeid=Util.null2String(rs.getString("id"));
                      if(isprint==0){
                        showmodeid1=modeid;
                        printmodeid1=modeid;
                      }else{
                          if(isprint==1){
                              printmodeid1=modeid;
                          }
                      }
                  }
                  String candelete = "disabled";
                  if(flag){
                  	rs.executeSql("select * from workflow_base where formid="+id);
                  	if(!rs.next()) candelete = "";//新建表单没有被引用，则可以被删除。
                  }
                  
		          %>
		          <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		            <td>
		              <input type="checkbox"  disabled>
		            </td>
		            <td><%if(flag){%><a href="/workflow/form/addDefineForm.jsp?formid=<%=id%>"><%}else{%>
		            	<a href="/workflow/workflow/BillManagementDetail0.jsp?billId=<%=id%>"><%}%>
		            	<%=tempformname%></a></td>
            		<td><%if(flag){%><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></td><%}else{%>
            		<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></td><%}%>
		            <td><%if(operatelevel>0){%><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=id%>&isbill=1&isprint=0&modeid=<%=showmodeid1%>')"><%}%>
		            	<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%><%if(operatelevel>0){%></a><%}%></td>
		            <td><%if(operatelevel>0){%><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=id%>&isbill=1&isprint=1&modeid=<%=printmodeid1%>')"><%}%>
		            	<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%if(operatelevel>0){%></a><%}%></td>
		            <td><%=formdes%></td>
		          </tr>
		          <%
		          	if(linecolor==0)	linecolor=1;
		          	else	linecolor=0;
		          }
		       }
        }
          %>
          <tr class="header">
            <td colspan=6>
              <input type="checkbox" name="checkall0" onClick="formCheckAll(checkall0.checked)" value="ON">
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
<%
if(!ajax.equals("1")){
%>
   <script language="javascript">
function submitData()
{
	if (confirmdel()){
		fromaddtab.action = "/workflow/form/delforms.jsp";
		fromaddtab.submit();
	}
}

function submitClear()
{
	btnclear_onclick();
}
function openFullWindowHaveBar(url){
	if (url.indexOf("/workflow/mode/index.jsp") != -1) {
		if (<%=isIE %> != true) {
			alert("您当前使用的浏览器不支持【报表编辑器】，如需使用该功能，请使用IE浏览器！");
			return false;
		}
	}   
  var redirectUrl = url ;
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-50 ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
   var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes,toolbar=no,location=no," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function doSearchForm(){
    fromaddtab.action = "/workflow/form/manageform.jsp";
    fromaddtab.submit();
}
</script>
<%
    }
%>
</body>
</html>
