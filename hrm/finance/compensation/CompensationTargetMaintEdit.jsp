<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CompensationTargetMaint" class="weaver.hrm.finance.compensation.CompensationTargetMaint" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
boolean hasright=true;
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
int isedit=Util.getIntValue(request.getParameter("isedit"));
String currentyear =Util.null2String(request.getParameter("CompensationYear"));
String currentmonth =Util.null2String(request.getParameter("CompensationMonth"));
//获得当前的年月
if(currentyear.trim().equals("") || currentmonth.trim().equals("")){
Calendar today = Calendar.getInstance();
currentyear = Util.add0(today.get(Calendar.YEAR), 4);
currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2);
}

String showname="";
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Maintenance",subcompanyid);
    if(operatelevel<1){
        hasright=false;
    }
    }else{
       hasright=false;
    }
}
if(!HrmUserVarify.checkUserRight("Compensation:Maintenance", user) && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
//判断是否为部门级权限
int maxlevel=0;
RecordSet.executeSql("select c.rolelevel from SystemRightDetail a, SystemRightRoles b,HrmRoleMembers c where b.roleid=c.roleid and a.rightid = b.rightid and a.rightdetail='Compensation:Maintenance' and c.resourceid="+user.getUID()+" order by c.rolelevel");
while(RecordSet.next()){
    int rolelevel=RecordSet.getInt(1);
    if(maxlevel<rolelevel) maxlevel=rolelevel;
    if(rolelevel==0){
        if(user.getUserDepartment()!=departmentid)
        hasright=false;
        else
        hasright=true;
    }
}
if(maxlevel<1 && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
ArrayList targetlist=new ArrayList();
ArrayList targetnamelist=new ArrayList();
String subcomidstr="";
if(subcompanyid>0){
    showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
    if(departmentid>0) showname+="/"+DepartmentComInfo.getDepartmentname(""+departmentid);
    String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Maintenance", 0);
    ArrayList allrightcompanyid = Util.TokenizerString(allrightcompany, ",");
    subcomidstr = SubCompanyComInfo.getRightSubCompanyStr1("" + subcompanyid, allrightcompanyid);
    CompensationTargetMaint.getDepartmentTarget(subcompanyid,departmentid,user.getUID(),"Compensation:Maintenance", 0,false);
    targetlist=CompensationTargetMaint.getTargetlist();
    targetnamelist=CompensationTargetMaint.getTargetnamelist();
}else{
    hasright=false;
}
if(user.getUID()==1){
	hasright=true;
}
int cols=4+targetlist.size();
if(departmentid<1)
cols=cols+2;
ExcelFile.init() ;
ExcelSheet es = new ExcelSheet();
ExcelRow er = es.newExcelRow () ;
ExcelStyle style = ExcelFile.newExcelStyle("Header") ;
style.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
style.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
style.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
style.setAlign(ExcelStyle.WeaverHeaderAlign) ;
er.addStringValue("ID","Header");
er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()),"Header");
er.addStringValue(SystemEnv.getHtmlLabelName(19401,user.getLanguage()),"Header");    
for(int i=0;i<targetnamelist.size();i++){
    er.addStringValue((String)targetnamelist.get(i),"Header");
}
er.addStringValue(SystemEnv.getHtmlLabelName(454,user.getLanguage()),"Header");
es.addExcelRow(er);

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdeptCompensation(deptid,xuhao){
    var ajax=ajaxinit();
    ajax.open("POST", "CompensationTargetViewAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid="+deptid+"&xuhao="+xuhao+"&isedit=1&CompensationYear=<%=currentyear%>&CompensationMonth=<%=currentmonth%>&userid=<%=user.getUID()%>&showdept=<%=departmentid%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("div"+deptid).innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
</script>
</head>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(19430,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:save(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:loadexcel(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19489,user.getLanguage())+",/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:ondelete(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location.href=\"CompensationTargetMaint.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+"\",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<div id="divmsg"><%=SystemEnv.getHtmlLabelName(19202,user.getLanguage())%></div>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=frmMain action="CompansationTargetMaintOperation.jsp" method=post enctype="multipart/form-data" >
<input type="hidden" id="option" name="option" value="">
<%for(int i=0;i<targetlist.size();i++){%>
<input type="hidden" name="targetid<%=i%>" value="<%=targetlist.get(i)%>">
<%}%>
<TABLE class=viewform width="100%">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(19464,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></TD>
          <TD class=Field><%=showname%><input class=inputstyle type="hidden"  name="subcompanyid" value="<%=subcompanyid%>">
              <input class=inputstyle type="hidden"  name="departmentid" value="<%=departmentid%>"></TD>
   </TR>
   <TR class= Spacing><TD class=Line colSpan=2></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19465,user.getLanguage())%></TD>
          <TD class=Field>
          <%
          if(isedit!=1){
          %>
              <select class=inputstyle   name="CompensationYear" >
        <%
            // 查询选择框的所有可以选择的值
            int defaultsel=Util.getIntValue(currentyear,2006);
            for(int y=defaultsel-50;y<defaultsel+50;y++){
	   %>
	    <option value="<%=y%>" <%if(defaultsel==y){%>selected<%}%>><%=y%></option>
	   <%
            }
       %>
          </select><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
              <select class=inputstyle   name="CompensationMonth" >
                  <option value="01" <%if(currentmonth.equals("01")){%>selected<%}%>>01</option>
                  <option value="02" <%if(currentmonth.equals("02")){%>selected<%}%>>02</option>
                  <option value="03" <%if(currentmonth.equals("03")){%>selected<%}%>>03</option>
                  <option value="04" <%if(currentmonth.equals("04")){%>selected<%}%>>04</option>
                  <option value="05" <%if(currentmonth.equals("05")){%>selected<%}%>>05</option>
                  <option value="06" <%if(currentmonth.equals("06")){%>selected<%}%>>06</option>
                  <option value="07" <%if(currentmonth.equals("07")){%>selected<%}%>>07</option>
                  <option value="08" <%if(currentmonth.equals("08")){%>selected<%}%>>08</option>
                  <option value="09" <%if(currentmonth.equals("09")){%>selected<%}%>>09</option>
                  <option value="10" <%if(currentmonth.equals("10")){%>selected<%}%>>10</option>
                  <option value="11" <%if(currentmonth.equals("11")){%>selected<%}%>>11</option>
                  <option value="12" <%if(currentmonth.equals("12")){%>selected<%}%>>12</option>
              </select><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
          <%
              }else{
          %>
          <%=currentyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=currentmonth%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
          <input type="hidden" name="CompensationYear" value="<%=currentyear%>">
          <input type="hidden" name="CompensationMonth" value="<%=currentmonth%>">
          <%
              }
          %>
          </TD>
   </TR>
   <TR class= Spacing><TD class=Line colSpan=2></TD></TR>
  <%if(hasright){%>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=file  name="targetfile" size=40>&nbsp;&nbsp;<button Class=AddDoc type=button onclick="loadexcel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></button></TD>
   </TR>
   <TR class= Spacing><TD class=Line colSpan=2></TD></TR>
  <%}%>    
 <tr>
<td id="msg" align="center" colspan="2"><font size="2" color="#FF0000">
<%
String msg=Util.null2String(request.getParameter("msg"));
String msg1=Util.null2String(request.getParameter("msg1"));
String msg2=Util.null2String(request.getParameter("msg2"));
String msg3=Util.null2String(request.getParameter("msg3"));
String msg4=Util.null2String(request.getParameter("msg4"));
int    dotindex=0;
int    cellindex=0;
int    msgsize;
msgsize=Util.getIntValue(request.getParameter("msgsize"),0);

if (msg.equals("success")){
    msg=SystemEnv.getHtmlLabelName(19488,user.getLanguage());
    out.println(msg);
}else{
    for (int i=0;i<msgsize;i++){
        dotindex=msg1.indexOf(",");
        cellindex=msg2.indexOf(",");
        out.println(msg1.substring(0,dotindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg2.substring(0,cellindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+SystemEnv.getHtmlLabelName(19327,user.getLanguage())+"<br>");

         msg1=msg1.substring(dotindex+1,msg1.length());
         msg2=msg2.substring(cellindex+1,msg2.length());
    }
}
if(!msg3.trim().equals("")){
    out.println("<br>"+SystemEnv.getHtmlLabelName(19401,user.getLanguage())+msg3.substring(0,msg3.length()-1)+SystemEnv.getHtmlLabelName(19327,user.getLanguage()));
}
if(!msg4.trim().equals("")){
    out.println("<br>"+SystemEnv.getHtmlLabelName(19383,user.getLanguage())+msg4.substring(0,msg4.length()-1)+SystemEnv.getHtmlLabelName(19327,user.getLanguage()));
}
%>
 </font>
 </td>
 </tr>
 <TR class= Spacing><TD class=Line1 colSpan=2></TD></TR>
 </TBODY></TABLE>

 <br>
<%
    int widthint=450;
    if(departmentid<1){
        widthint+=400;
    }
    for(int i=0;i<targetlist.size();i++){
        widthint+=100;
    }
%>
<table width="<%=widthint%>">
  <TR style="HEIGHT: 30px ;BORDER-Spacing:1pt;word-wrap:break-word; word-break:break-all;">
    <TH colSpan="<%=cols%>" style="COLOR: #003366 ;TEXT-ALIGN:left;TEXT-VALIGN:middle"><%=SystemEnv.getHtmlLabelName(19454,user.getLanguage())%></TH>
  </TR>
</table>
<TABLE class=ListStyle cellspacing=1 id="oTable" width="<%=widthint%>">
  <TR class=header style="HEIGHT: 30px ;BORDER-Spacing:1pt;word-wrap:break-word; word-break:break-all;">
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="50"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>
  <%if(departmentid<1){%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="200"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="200"><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></TH>
  <%}%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="100"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="100"><%=SystemEnv.getHtmlLabelName(19401,user.getLanguage())%></TH>
  <%for(int i=0;i<targetlist.size();i++){%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="100"><%=targetnamelist.get(i)%></TH>
  <%}%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="200"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
  </TR>
  <tr> 
       <td colspan="<%=cols%>">
  <%
  String sql="";
  int i=0;
  int tempdeptid=-100;
  int rows=0;
  if(departmentid>0){
      sql="select distinct a.departmentid,a.id,a.lastname,a.workcode,b.id as comtargetid,b.memo from hrmresource a left join HRM_CompensationTargetInfo b on a.id=b.Userid and b.CompensationYear="+currentyear+" and b.CompensationMonth="+Util.getIntValue(currentmonth)+" where a.subcompanyid1="+subcompanyid+" and a.departmentid="+departmentid+" and a.status in(0,1,2,3) order by a.id";
  }else{
      sql="select distinct a.departmentid,a.id,a.lastname,a.workcode,b.id as comtargetid,b.memo from hrmresource a left join HRM_CompensationTargetInfo b on a.id=b.Userid and b.CompensationYear="+currentyear+" and b.CompensationMonth="+Util.getIntValue(currentmonth)+" where a.subcompanyid1 in("+subcomidstr+") and a.status in(0,1,2,3) order by a.departmentid,a.id";
  }
  RecordSet.executeSql(sql);
  while(RecordSet.next()){
      int viewdeptid=RecordSet.getInt(1);
      er = es.newExcelRow() ;
      int cuserid=RecordSet.getInt("id");
      String cusername=RecordSet.getString("lastname");
      String workcode=RecordSet.getString("workcode");
      String comtargetid=RecordSet.getString("comtargetid");
      String memo=RecordSet.getString("memo");
      ArrayList templist=CompensationTargetMaint.getTarget(comtargetid,targetlist);
      er.addStringValue(""+cuserid);
      er.addStringValue(cusername);
      er.addStringValue(workcode);
      for(int j=0;j<targetlist.size();j++){
          String temp="0";
          if(isedit==1) temp=(String)templist.get(j);
          if(Util.getDoubleValue(temp)>0) er.addValue(temp);
          else er.addStringValue("");
      }
      er.addStringValue(memo);
      if(tempdeptid!=-100&&tempdeptid!=viewdeptid){
  %>
  <div id="div<%=tempdeptid%>"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
  <script>showdeptCompensation("<%=tempdeptid%>","<%=i%>");</script>
  </div>
  <%
          tempdeptid=viewdeptid;
          i+=rows;
          rows=1;
      }else{
          if(tempdeptid==-100) tempdeptid=viewdeptid;
          rows++;
      }
  }
  if(tempdeptid>0){
  %>
  <div id="div<%=tempdeptid%>"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
  <script>showdeptCompensation("<%=tempdeptid%>","<%=i%>");</script>
  </div>
  <%
      i+=rows;
      rows=0;
  }
  %>
  </td>
   </tr></TABLE>
  <%
  ExcelFile.setFilename("CompensationTarget") ;
  ExcelFile.addSheet("CompensationTarget", es) ;
  %>

<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<input type='hidden' id="rownum" name="rownum" value="<%=i%>">
<input type='hidden' id="targetsize" name="targetsize" value="<%=targetlist.size()%>">
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>
document.all("divmsg").style.display='none';    
function ondelete(obj){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
        frmMain.option.value="delete";
        obj.disabled=true;
        frmMain.submit();
    }
}
function save(obj) {
    <%if(isedit==1){%>
    frmMain.option.value="edit";
    obj.disabled=true;
    frmMain.submit();
    <%}else{%>
    obj.disabled=true;
    var ajax=ajaxinit();
    ajax.open("POST", "CompensationTargetCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&CompensationYear="+frmMain.CompensationYear.value+"&CompensationMonth="+frmMain.CompensationMonth.value);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            if(ajax.responseText!=1){
                alert("<%=SystemEnv.getHtmlLabelName(19409,user.getLanguage())%>");
                obj.disabled=false;
                return false;
            }else{
                frmMain.option.value="add";
                frmMain.submit();
            }
            }catch(e){
                return false;
            }
        }
    }
    <%}%>

}
function loadexcel(obj) {
 if (frmMain.targetfile.value=="" || frmMain.targetfile.value.toLowerCase().indexOf(".xls")<0){
     alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
     frmMain.targetfile.value="";
}else{
    <%if(isedit!=1){%>
     var ajax=ajaxinit();
    ajax.open("POST", "CompensationTargetCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&CompensationYear="+frmMain.CompensationYear.value+"&CompensationMonth="+frmMain.CompensationMonth.value);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            if(ajax.responseText!=1){
                alert("<%=SystemEnv.getHtmlLabelName(19409,user.getLanguage())%>");
                return false;
            }else{
                frmMain.option.value="loadfile";
                var showTableDiv  = document.getElementById('_xTable');
                var message_table_Div = document.createElement("div");
                message_table_Div.id="message_table_Div";
                message_table_Div.className="xTable_message";
                showTableDiv.appendChild(message_table_Div);
                var message_table_Div  = document.getElementById("message_table_Div");
                message_table_Div.style.display="inline";
                message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(19470,user.getLanguage())%>";
                var pTop= document.body.offsetHeight/2-60;
                var pLeft= document.body.offsetWidth/2-100;
                message_table_Div.style.position="absolute";
                message_table_Div.style.posTop=pTop;
                message_table_Div.style.posLeft=pLeft;
                obj.disabled=true;
                frmMain.submit();
            }
            }catch(e){
                return false;
            }
        }
    }
    <%}else{%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(19481,user.getLanguage())%>")){
    frmMain.option.value="loadfile";
    var showTableDiv  = document.getElementById('_xTable');
	var message_table_Div = document.createElement("<div>");
	message_table_Div.id="message_table_Div";
	message_table_Div.className="xTable_message";
	showTableDiv.appendChild(message_table_Div);
	var message_table_Div  = document.getElementById("message_table_Div");
	message_table_Div.style.display="inline";
	message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(19470,user.getLanguage())%>";
	var pTop= document.body.offsetHeight/2-60;
	var pLeft= document.body.offsetWidth/2-100;
	message_table_Div.style.position="absolute";
	message_table_Div.style.posTop=pTop;
	message_table_Div.style.posLeft=pLeft;
    obj.disabled=true;
    frmMain.submit();
    }
    <%}%>
 }
}
</script>
</BODY>
</HTML>