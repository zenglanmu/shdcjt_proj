<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ include file = "/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add" , user)){
    		//response.sendRedirect("/notice/noright.jsp") ; 
    		//return ; 
	} 
%>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver.js"></script>
<SCRIPT language = "javascript" src = "/js/addRowBg.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16481,user.getLanguage()) ;
String needfav = "1" ; 
String needhelp = "" ;
String subcompanyid = Util.null2String(request.getParameter("subcompanyid") ) ;
String applyscope = Util.null2String(request.getParameter("applyscope") ) ;
String itemname = Util.null2String(request.getParameter("itemname") ) ;
String itemcode = Util.null2String(request.getParameter("itemcode") ) ;
String itemtype = Util.null2String(request.getParameter("itemtype") ) ;
if(itemtype.equals("")){
	itemtype = "4";
}
String isshow = Util.null2String(request.getParameter("isshow") ) ;
String showorder = Util.null2String(request.getParameter("showorder") ) ;
String calMode =  Util.null2String(request.getParameter("calMode")) ;

String directModify =  Util.null2String(request.getParameter("directModify")) ;
String companyPercent = Util.null2String(request.getParameter("companyPercent")) ;
String personalPercent =  Util.null2String(request.getParameter("personalPercent")) ;
String subids=SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid);



%>
<BODY>
<%@ include file = "/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String rolelevel=CheckUserRight.getRightLevel("HrmResourceComponentAdd:Add" , user);
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
<form  name = frmMain method = post action = "HrmSalaryItemOperation.jsp" method = post>
<input class=inputstyle type = "hidden" name = "subcompanyid" value = "<%=subcompanyid%>">
<input class=inputstyle type = "hidden" name = "method" value = "add">
<table class =Viewform>
    <COLGROUP>
    <COL width = "48%"> 
    <COL width = "2%"> 
    <COL width = "48%"> 
    <TBODY> 
    <TR class = Title> 
        <TH colSpan = 3><%=SystemEnv.getHtmlLabelName(1361 , user.getLanguage())%></TH>
    </TR>
    <TR class = Spacing style="height:2px"> 
        <TD class=Line1 colSpan = 3></TD>
    </TR>
    <tr>
        <TD valign = top>
            <TABLE class=ViewForm>
            <COLGROUP>
            <COL width = "20%">
            <COL width = "80%">
            <TBODY>
            <TR>
                <TD><%=SystemEnv.getHtmlLabelName(195 , user.getLanguage())%></TD>
                <TD class = Field><INPUT class = inputstyle maxLength = 50 size = 25 name = "itemname" value="<%=itemname%>" onchange = 'checkinput("itemname","nameimage")'><SPAN id = nameimage><IMG src = "/images/BacoError.gif" align = absMiddle></SPAN>
                </TD>
            </TR>
            <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
            <TR>
                <TD><%=SystemEnv.getHtmlLabelName(590 , user.getLanguage())%></TD>
                <TD class = Field><INPUT class = inputstyle maxLength = 50 size = 25 name = "itemcode" value="<%=itemcode%>" onchange = 'checkinput("itemcode","itemcodeimage")'><SPAN id = itemcodeimage><IMG src = "/images/BacoError.gif" align = absMiddle></SPAN>
                </TD>
            </TR>
                <script>
                   checkinput("itemname","nameimage");
                   checkinput("itemcode","itemcodeimage") ;
                </script>
            <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
            <TR>
                <TD><%=SystemEnv.getHtmlLabelName(63 , user.getLanguage())%></TD>
                <TD class = Field > 
                    <select name = "itemtype" style = "width:50%" onChange = "showType()">
                      <option value = "1" <%if(itemtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1804 , user.getLanguage())%></option>
                      <option value = "3" <%if(itemtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15826 , user.getLanguage())%></option>
                      <option value = "4" <%if(itemtype.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(449 , user.getLanguage())%></option>
                      <%--<option value = "5" <%if(itemtype.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16668 , user.getLanguage())%></option>
                      <option value = "6" <%if(itemtype.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16669 , user.getLanguage())%></option>
                      <option value = "7" <%if(itemtype.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16740 , user.getLanguage())%></option>--%>
                      <%--<option value = "8" <%if(itemtype.equals("8")){%>selected<%}%>>出勤杂费</option>--%>
                      <option value = "9" <%if(itemtype.equals("9")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15825 , user.getLanguage())+SystemEnv.getHtmlLabelName(449 , user.getLanguage())%></option>
                    </select>
                </TD>
            </TR>
            <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
            <TR id=tr_wel style='display:none'>
                <TD nowrap><%=SystemEnv.getHtmlLabelName(449 , user.getLanguage())+SystemEnv.getHtmlLabelName(599 , user.getLanguage())%></TD>
                <TD class = Field >
                    <select class=inputstyle name = "calMode" original=<%=calMode%> style = "display:none" onchange="changeScope();">
                      <option value = "1" <%if(calMode.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19529 , user.getLanguage())%></option>
                      <option value = "2" <%if(calMode.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19530 , user.getLanguage())%></option>
                    </select>
                </TD>
            </TR>
            <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
            <!--
            TR id = tr_welfarerate style = "display:none">
                <TD>福利费率</TD>
                <TD class = Field>
                个人<INPUT class = inputstyle maxLength = 10 size = 5 name = "personwelfarerate" onchange = 'checkinput("personwelfarerate","personwelfarerateimage")' onKeyPress = "ItemCount_KeyPress()" onBlur = 'checkcount1(this)' >%<SPAN id = personwelfarerateimage><IMG src = "/images/BacoError.gif" align = absMiddle></SPAN>&nbsp;&nbsp;
                公司<INPUT class = inputstyle maxLength = 10 size = 5 name = "companywelfarerate" onchange = 'checkinput("companywelfarerate","companywelfarerateimage")' onKeyPress = "ItemCount_KeyPress()" onBlur = 'checkcount1(this)'>%<SPAN id = companywelfarerateimage><IMG src = "/images/BacoError.gif" align = absMiddle></SPAN>
                </TD>
             </TR>
             --> 
             <TR id = tr_taxrelateitem style = "display:none">
                <TD nowrap><%=SystemEnv.getHtmlLabelName(15827 , user.getLanguage())%></TD>
                <TD class = Field>
                <button class = Browser id = SelectItemId onClick = "onShowItemId(taxrelateitemspan,taxrelateitem)"></button> 
                <span  id = taxrelateitemspan><IMG src = "/images/BacoError.gif" 
                align = absMiddle></span> 
                <input class=inputstyle id = taxrelateitem type = hidden name = taxrelateitem>
                </TD>
             </TR>  
             <%--<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
             <TR id = tr_amountecp style = "display:none">
                <TD><%=SystemEnv.getHtmlLabelName(15828 , user.getLanguage())%></TD>
                <TD class = Field>
                <INPUT class = inputstyle maxLength = 100 size = 30 name = "amountecp" onchange = 'checkinput("amountecp","amountecpimage")' ><SPAN id = amountecpimage><IMG src = "/images/BacoError.gif" align = absMiddle></SPAN> 
                </TD>
             </TR>  --%>
            </TBODY>
            </TABLE>
        </TD>
        <TD>&nbsp;</TD>
        <TD valign = top>
            <TABLE class=ViewForm>
            <COLGROUP>
            <COL width = "20%">
            <COL width = "80%">
            <TBODY>
            <TR>
                <TD><%=SystemEnv.getHtmlLabelName(15603 , user.getLanguage())%></TD>
                <TD class = Field>
                    <select class=inputstyle id = isshow 
                      name = isshow onChange = "showOrder()">
                        <option value = 1 <%if(isshow.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163 , user.getLanguage())%></option>
                        <option value = 0 <%if(isshow.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161 , user.getLanguage())%></option>
                    </select>
                </TD>
            </TR>
            <TR id = tr_showorder>
                <TD><%=SystemEnv.getHtmlLabelName(15513 , user.getLanguage())%></TD>
                <TD class = Field><INPUT class = inputstyle maxLength = 50 size = 5 name = "showorder" value="<%=showorder%>" onchange = 'checkinput("showorder","showorderimage")'><SPAN id = showorderimage><IMG src = "/images/BacoError.gif" align = absMiddle></SPAN>
                </TD>
            </TR>
                <script>
                    checkinput("showorder","showorderimage");
                    function showOrder() {
                        isshowlist = window.document.frmMain.isshow;
                        if (isshowlist.value == 1) {
                            tr_showorder.style.display = '';
                        }
                        if (isshowlist.value == 0) {
                            tr_showorder.style.display = 'none';
                        }
                    }
                    showOrder();
                </script>
            <!--
            <TR>
                <TD>是否记入历史</TD>
                <TD class = Field>
                <select class = inputstyle id = ishistory  name = ishistory>
                    <option value = 1 selected>是</option>
                    <option value = 0>否</option>
                 </select>			
                </TD> 
            </TR>
            -->
            <tr>
          <td nowrap><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></td>
          <td class = field>
          <select class=inputstyle name = "applyscope" original=<%=applyscope%> size = 1  onchange="changeScope();">
          <%if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){%>
          <option value = "0" <%if(applyscope.equals("0")){%>selected<%}%>>
          <%=SystemEnv.getHtmlLabelName(140 , user.getLanguage())%></option>
          <%}%>
          <option value = "1" <%if(applyscope.equals("1")){%>selected<%}%>>
          <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
          <option value = "2" <%if(applyscope.equals("2")){%>selected<%}%>>
          <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18921, user.getLanguage())%></option>
        </select>
        </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <tr id=tr_wel1 style='display:none'>
              <td><%=SystemEnv.getHtmlLabelName(19531,user.getLanguage())%></td>
              <td class = Field>
                  <select class=inputstyle style='display:none' name = "directModify" size = 1 >

          <option value = "0">
          <%=SystemEnv.getHtmlLabelName(161 , user.getLanguage())%></option>

          <option value = "1">
          <%=SystemEnv.getHtmlLabelName(163 , user.getLanguage())%></option>

        </select>
              </td>
          </tr>
            <TR style = "display:none">
                <TD><%=SystemEnv.getHtmlLabelName(15829 , user.getLanguage())%></TD>
                <TD class = Field></TD>
             </TR> 
            </TBODY>
            </TABLE>
        </TD>
  </tr>
</table>

<br>

<div>
<table  width = 100% border = 1 bordercolor = 'black'>
  <tbody>
  <tr>
  <td>
  <%=SystemEnv.getHtmlLabelName(15830 , user.getLanguage())%>
  </td></tr>
  </tbody>
</table>
</div>

<br>

<div id = tb_jssm style = "display:none">
<table  width = 100% border = 1 bordercolor = 'black'>
  <tbody>
  <tr>
  <td>
  <%=SystemEnv.getHtmlLabelName(16670 , user.getLanguage())%>
  </td></tr>
  </tbody>
</table>
</div>


<div id = tb_je>
<table  class=Viewform>
  <tbody>
  <TR class=Title> 
    <TH><%=SystemEnv.getHtmlLabelName(603 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right">
    <BUTTON class = btnNew accessKey = I onClick="addRowJe();"><U>I</U>-<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%></BUTTON>
    <BUTTON class = btnDelete accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Je()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
  </TH>
  </TR>
  <TR class=Spacing style="height:2px"><TD class=Line1 colSpan = 2></TD></TR>
  </tbody>
</table>
<TABLE class=ListStyle cellspacing=1  id = "oTable_je" cols = 6>
  <COLGROUP> 
  <COL width = "5%"> 
  <COL width = "20%"> 
  <COL width = "20%"> 
  <COL width = "17%">
  <COL width = "17%">
  <COL width = "20%"> 
  <TBODY>
  <TR class = Header> 
    <TD>&nbsp;</TD>
    <TD><%=SystemEnv.getHtmlLabelName(1915 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6086 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15831 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15832 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(534 , user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="8" ></TD></TR> 
  <TR bgcolor = "#efefef"> 
    <TD><input class=inputstyle type = 'checkbox' name = 'check_je' value = 1></TD>
    <TD><BUTTON class=Browser onClick="onShowJobActivity(jobactivityspan0,jobactivityid0)"></BUTTON><span class=inputstyle id=jobactivityspan0></span> 
        <INPUT class=inputstyle id=jobactivityid0 type=hidden name=jobactivityid0>
    </TD>
    <TD><BUTTON class = Browser onclick = 'onShowJobID(jobidspan0,jobid0)'></BUTTON><SPAN id = jobidspan0></SPAN>
    <input class=inputstyle type = 'hidden' name = 'jobid0' value = ''>
    </TD>
    <TD><input class=inputstyle type = 'text' name = 'joblevelfrom0' value = "" style = 'width:100%'  onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)'></TD>
    <TD><input class=inputstyle type = 'text' name = 'joblevelto0' value = "" style='width:100%'  onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)'></TD>
    <TD><input class=inputstyle type = 'text' name = 'amount0' value = "" style = 'width:100%' onKeyPress = 'ItemNum_KeyPress()' onBlur = 'checknumber1(this)'></TD>
  </TR>
  </tbody>
</table>
</div>
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
    ajax.open("POST", "HrmSalarySetAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid="+deptid+"&xuhao="+xuhao+"&userid=<%=user.getUID()%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("div"+deptid+"ajax").innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
</script>
<div id = tb_cqzf >
<br>
<table  class = Liststyle cellspacing=1>
  <COLGROUP> 
  <COL width = "15%"> 
  <COL width = "15%"> 
  <COL width = "70%"> 
  <tbody>
  <TR class = Header> 
    <TH colspan=2>个人基准设置</TH>
    <TH style = "TEXT-ALIGN: right"></TH>
  </TR>
  <TR class = Header> 
    <TD><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(714 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(534 , user.getLanguage())%></TD>
  </TR>
  </TR>
	<tr>
       <td colspan="3">
<%
	if(applyscope.equals("")){
		if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){
			RecordSet.executeSql(" select departmentid, count(id) from Hrmresource where status in (0,1,2,3) group by departmentid");
		}else{
			RecordSet.executeSql(" select departmentid, count(id) from Hrmresource where status in (0,1,2,3) and subcompanyid1="+subcompanyid+" group by departmentid") ;
		}
	}else{
		if(applyscope.equals("0")&&(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2"))){
			RecordSet.executeSql(" select departmentid, count(id) from Hrmresource where status in (0,1,2,3) group by departmentid") ;
		}else if(applyscope.equals("1")){
			RecordSet.executeSql(" select departmentid, count(id) from Hrmresource where status in (0,1,2,3) and subcompanyid1="+subcompanyid+" group by departmentid") ;
		}else if(applyscope.equals("2")) {
			subids=subcompanyid+","+subids;
			subids=subids.substring(0,subids.length()-1);
			RecordSet.executeSql(" select departmentid, count(id) from Hrmresource where status in (0,1,2,3) and subcompanyid1 in("+subids+") group by departmentid") ;
		}
	}
	int i = 0;
	String scriptStr = "";
	while(RecordSet.next()){
		int departmentid_tmp = Util.getIntValue(RecordSet.getString(1), 0);
		int count_tmp = Util.getIntValue(RecordSet.getString(2), 0);
		if(count_tmp>0){
%>
			<div id="div<%=departmentid_tmp%>ajax" style="width:100%"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
<%
			if(itemtype.equals("1")){
%>
		<script>showdeptCompensation("<%=departmentid_tmp%>","<%=i%>");</script>
<%
			}else{
				scriptStr += "showdeptCompensation(\""+departmentid_tmp+"\",\""+i+"\");\n";
			}
%>
	</div>
<%
			i+=count_tmp;
		}
	}
%>
		</td>
	</tr>
  </tbody>
</table>
</div>

<div id = tb_fl style = "display:none">
<br>
<table  class=Viewform>
  <tbody>
  <TR class=Title> 
    <TH><%=SystemEnv.getHtmlLabelName(15833 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right">
    <BUTTON class = btnNew accessKey = I onClick = "addRowFl();"><U>I</U>-<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%></BUTTON>
    <BUTTON class = btnDelete accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Fl()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
    </TH>
  </TR>
  <TR class=Spacing style="height:2px"><TD class=Line1 colSpan = 2></TD></TR>
  </tbody>
</table>
<TABLE class=ListStyle cellspacing=1  id = "oTable_fl" cols = 4>
  <COLGROUP> 
  <COL width = "5%"> 
  <COL width = "30%"> 
  <COL width = "32%"> 
  <COL width = "32%">
  <TBODY>
  <TR class = Header> 
    <TD>&nbsp;</TD>
    <TD><%=SystemEnv.getHtmlLabelName(493 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6087 , user.getLanguage())%>(%)</TD>
    <TD><%=SystemEnv.getHtmlLabelName(1851 , user.getLanguage())%>(%)</TD>
  </TR>
  <TR class=Line><TD colspan="8" ></TD></TR> 
  <TR bgcolor = "#efefef"> 
    <TD><input class=inputstyle type = 'checkbox' name = 'check_fl' value = 1></TD>
    <TD><BUTTON class = Browser onclick = 'onShowCityID(ratecityidspan0,ratecityid0)'>
        </BUTTON><SPAN id = "ratecityidspan0"></SPAN>
        <input class=inputstyle type = 'hidden' name = 'ratecityid0' value = ''>
    </TD>
    <TD><INPUT class = inputstyle maxLength = 10 size = 15 name = "personwelfarerate0" onKeyPress = "ItemNum_KeyPress()" onBlur = 'checknumber1(this)' >%
    </TD>
    <TD><INPUT class = inputstyle maxLength = 10 size=15 name = "companywelfarerate0" onKeyPress = "ItemNum_KeyPress()" onBlur = 'checknumber1(this)' >%</TD>
  </TR>
  </tbody>
</table>
</div>

<div id = tb_ss style = "display:none">
<table  class=Viewform>
  <tbody>
  <TR class=Title> 
    <TH><%=SystemEnv.getHtmlLabelName(15834 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right">
    <BUTTON class = btnNew accessKey = I onClick = "addRowSs();"><U>I</U>-<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%></BUTTON>
    <BUTTON class = btnDelete accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Ss()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
  </td>
  </TR>
  <TR class=Spacing style="height:2px"><TD class=Line1  colSpan = 2></TD></TR>
  </tbody>
</table>
<TABLE class=ListStyle cellspacing=1  id = "oTable_ss" cols = 2>
  <COLGROUP>
  <COL width = "3%">
  <COL width = "97%"> 
  <TBODY>
  <TR background = "#efefef"><TD bgcolor = "#efefef"><input class=inputstyle type = 'checkbox' name = 'check_ss' value = 1></TD>
  <TD bgcolor = "#efefef">
  <TABLE class = ListShort id = 'oTable_ssdetail0'name = 'oTable_ssdetail0' cols = 6>
    <COLGROUP>
    <COL width = '20%'>
    <COL width = '18%'> 
    <COL width = '7%'>
    <COL width = '18%'>
    <COL width = '18%'>
    <COL width = '20%'>
    <TBODY>
    <TR class = Header> 
    <TD><%=SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15835 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15837 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15838 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15834 , user.getLanguage())%>(%)</TD>
    </TR>
   <TR class=Line><TD colspan="8" ></TD></TR> 
    <TR class = DataDark> 
    <TD>
        <select name=scopetype0 onchange="changescopetype(this);">
        <option  value="0"><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>
        <option  value="1"><%=SystemEnv.getHtmlLabelName(493 , user.getLanguage())%></option>
        <option  value="2"><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
        <option  value="3"><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>
        <option  value="4"><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>
        </select>
        <BUTTON class = Browser type=button onclick = 'onShowOrganization(cityidspan0,cityid0,scopetype0)'>
        </BUTTON><SPAN id = "cityidspan0"></SPAN>
        <input class=inputstyle type = 'hidden' name = 'cityid0' value = ''></TD>
        <script type="text/javascript">
            function changescopetype(obj) {
               
            	jQuery(obj).parent().find("span").html("");
                jQuery(obj).parent().find("input").val("");
                if (obj.value == "0")
                    jQuery(obj).next().hide();
                else
                    jQuery(obj).next().show();
            }
        </script>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'taxbenchmark0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'ranknum0_0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'ranklow0_0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'rankhigh0_0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'taxrate0_0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    </TR>
    </TABLE>
    <TABLE width = 100%>
    <TR> 
    <TD align = right>
    <BUTTON class = btnNew accessKey = 1 onClick = "addRowSsD('0')";> 
    <U>1</U>-<%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%></BUTTON>
    </TD>
    </TR>
    </table>
    </TD></TR>
  </TBODY>
</TABLE>
</div>

<div id = tb_cal style = "display:none">
<table  class=Viewform>
  <tbody>
  <TR class=Title>
    <TH><%=SystemEnv.getHtmlLabelName(18125 , user.getLanguage())+SystemEnv.getHtmlLabelName(68 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right">
    <BUTTON class = btnNew type=button accessKey = I onClick = "addRowCal();"><U>I</U>-<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%></BUTTON>
    <BUTTON class = btnDelete type=button accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Cal()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
  </td>
  </TR>
  <TR class=Spacing style="height:2px"><TD class=Line1  colSpan = 2></TD></TR>
  </tbody>
</table>
<TABLE class=ListStyle cellspacing=1  id = "oTable_cal" cols = 2>
  <COLGROUP>
  <COL width = "3%">
  <COL width = "97%">
  <TBODY>
  <TR background = "#efefef"><TD bgcolor = "#efefef"><input class=inputstyle type = 'checkbox' name = 'check_cal' value = 1></TD>
  <TD bgcolor = "#efefef">
  <TABLE class = ListShort id = 'oTable_caldetail0'name = 'oTable_caldetail0' cols = 6>
    <COLGROUP>
    <COL width = '20%'>
    <COL width = '20%'>
    <COL width = '30%'>
    <COL width = '30%'>
    <TBODY>
    <TR class = Header>
    <TD><%=SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(19482 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15364 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(18125 , user.getLanguage())%></TD>
    </TR>
   <TR class=Line><TD colspan="4" ></TD></TR>
    <TR class = DataDark>
    <TD>
        <select name=scopetypecal0 onchange="changescopetype(this);">
        <option  value="0"><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>
        <option  value="2"><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
        <option  value="3"><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>
        <option  value="4"><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>
        </select>
        <BUTTON class = Browser type=button  style="display:none" onclick = 'onShowOrganization(objectidcalspan0,objectidcal0,scopetypecal0)'></BUTTON>
        <SPAN id = "objectidcalspan0"></SPAN>
        <input class=inputstyle type = 'hidden' name = 'objectidcal0' value = ''>
     </TD>

    <TD><select  name = 'timescopecal0_0'>
        <option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
        <option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
        <option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
        <option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
        </select>
    </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:''" onClick="onShowCon(concalspan0_0,concal0_0,condspcal0_0,scopetypecal0)" ></BUTTON>
              <span id="concalspan0_0" name="concalspan0_0"></span>
              <input type="hidden" name="concal0_0">
              <input type="hidden" name="condspcal0_0">
    </td>
    <TD>
        <BUTTON class=Browser type=button style="display:''" onClick="onShowFormula(formulacalspan0_0,formulacal0_0,formuladspcal0_0,scopetypecal0)" ></BUTTON>
              <span id="formulacalspan0_0" name="formulacalspan0_0"></span>
              <input type="hidden" name="formulacal0_0">
              <input type="hidden" name="formuladspcal0_0">
    </TD>
    </TR>
    </TABLE>
    <TABLE width = 100%>
    <TR>
    <TD align = right>
    <BUTTON class = btnNew type=button accessKey = 1 onClick = "addRowCalD('0')";>
    <U>1</U>-<%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%></BUTTON>
    </TD>
    </TR>
    </table>
    </TD></TR>
  </TBODY>
</TABLE>
</div>

<div id = tb_wel style = "display:none">
<table  class=Viewform>
  <tbody>
  <TR class=Title>
    <TH><%=SystemEnv.getHtmlLabelName(18125 , user.getLanguage())+SystemEnv.getHtmlLabelName(68 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right">
    <BUTTON class = btnNew accessKey = I onClick = "addRowWel();"><U>I</U>-<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%></BUTTON>
    <BUTTON class = btnDelete accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Wel()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
  </td>
  </TR>
  <TR class=Spacing style="height:2px"><TD class=Line1  colSpan = 2></TD></TR>
  </tbody>
</table>
<TABLE class=ListStyle cellspacing=1  id = "oTable_wel" cols = 2>
  <COLGROUP>
  <COL width = "3%">
  <COL width = "97%">
  <TBODY>
  <TR background = "#efefef"><TD bgcolor = "#efefef"><input class=inputstyle type = 'checkbox' name = 'check_wel' value = 1></TD>
  <TD bgcolor = "#efefef">
  <TABLE class = ListShort id = 'oTable_weldetail0'name = 'oTable_weldetail0' cols = 6>
    <COLGROUP>
    <COL width = '20%'>
    <COL width = '20%'>
    <COL width = '30%'>
    <COL width = '30%'>
    <TBODY>
    <TR class = Header>
    <TD><%=SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(19482 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15364 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(18125 , user.getLanguage())%></TD>
    </TR>
   <TR class=Line><TD colspan="4" ></TD></TR>
    <TR class = DataDark>
    <TD>
        <select name=scopetypewel0 onchange="changescopetype(this);">
        <option  value="0"><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>
        <option  value="2"><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
        <option  value="3"><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>
        <option  value="4"><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>
        </select>
        <BUTTON class = Browser type=button style="display:none" onclick = 'onShowOrganization(objectidwelspan0,objectidwel0,scopetypewel0)'></BUTTON>
        <SPAN id = "objectidwelspan0"></SPAN>
        <input class=inputstyle type = 'hidden' name = 'objectidwel0' value = ''>
     </TD>

    <TD><select  name = 'timescopewel0_0'>
        <option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
        <option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
        <option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
        <option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
        </select>
    </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:''" onClick="onShowCon(conwelspan0_0,conwel0_0,condspwel0_0,scopetypewel0)" ></BUTTON>
              <span id="conwelspan0_0" name="conwelspan0_0"></span>
              <input type="hidden" name="conwel0_0">
              <input type="hidden" name="condspwel0_0">
    </td>
    <TD>
        <BUTTON class=Browser type=button style="display:''" onClick="onShowFormula(formulawelspan0_0,formulawel0_0,formuladspwel0_0,scopetypewel0)" ></BUTTON>
              <span id="formulawelspan0_0" name="formulawelspan0_0"></span>
              <input type="hidden" name="formulawel0_0">
              <input type="hidden" name="formuladspwel0_0">
    </TD>
    </TR>
    </TABLE>
    <TABLE width = 100%>
    <TR>
    <TD align = right>
    <BUTTON class = btnNew accessKey = 1 onClick = "addRowWelD('0')";>
    <U>1</U>-<%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%></BUTTON>
    </TD>
    </TR>
    </table>
    </TD></TR>
  </TBODY>
</TABLE>
</div>

<div id = tb_wel1 style = "display:none">
<TABLE class=ListStyle cellspacing=1   cols = 2>
  <COLGROUP>
  <COL width = "3%">
  <COL width = "97%">
  <TBODY>
  <TR background = "#efefef"><TD bgcolor = "#efefef"></TD>
  <TD bgcolor = "#efefef">
  <TABLE class = ListShort cols = 2>
    <COLGROUP>
    <COL width = '50%'>
    <COL width = '50%'>

    <TBODY>
    <TR class = Header>
    <TD><%=SystemEnv.getHtmlLabelName(6087 , user.getLanguage())+SystemEnv.getHtmlLabelName(1464 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1851 , user.getLanguage())+SystemEnv.getHtmlLabelName(1464 , user.getLanguage())%></TD>
    </TR>
    <TR >
    <TD><input class=inputstyle  name = 'personalPercent'>%</TD>
    <TD><input class=inputstyle  name = 'companyPercent'>%</TD>
    </TR>
   <TR class=Line><TD colspan="4" ></TD></TR>

    </TABLE>

    </TD></TR>
  </TBODY>
</TABLE>
</div>

<div id = tb_kqkk style = "display:none">
<br>
<table  class=Viewform>
  <tbody>
  <TR class=Title>
    <TH><%=SystemEnv.getHtmlLabelName(16668 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right">
    <BUTTON class = btnNew accessKey = I onClick="addRowKq_Dec();"><U>I</U>-<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%></BUTTON>
    <BUTTON class = btnDelete accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Kq_Dec()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
  </TH>
  </TR>
  <TR class=Spacing style="height:2px"><TD class=Line1 colSpan = 2></TD></TR>
  </tbody>
</table>
<TABLE class=ListStyle cellspacing=1  id = "oTable_kqkk" cols = 2>
  <COLGROUP>
  <COL width = "5%">
  <COL width = "95%">
  <TBODY>
  <TR class = Header>
    <TD>&nbsp;</TD>
    <TD><%=SystemEnv.getHtmlLabelName(16672 , user.getLanguage())%></TD>
    </TR>
    <TR class=Line><TD colspan="2" ></TD></TR>
  <TR bgcolor = "#efefef">
    <TD><input class=inputstyle type = 'checkbox' name = 'check_kqkk' value = 1></TD>
    <TD><BUTTON class = Browser onclick = 'onShowScheduleDec(diffnamekkspan01,diffnamekk0)'></BUTTON>
    <SPAN id='diffnamekkspan01' ></SPAN>
    <input class=inputstyle type = 'hidden' name = 'diffnamekk0' value = ''>
    </TD>
    </TR>
  </tbody>
</table>
</div>

<div id = tb_kqjx style = "display:none">
<br>
<table  class=Viewform>
  <tbody>
  <TR class=Title>
    <TH><%=SystemEnv.getHtmlLabelName(16669 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right">
    <BUTTON class = btnNew accessKey = I onClick="addRowKq_Add();"><U>I</U>-<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%></BUTTON>
    <BUTTON class = btnDelete accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Kq_Add()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
  </TH>
  </TR>
  <TR class=Spacing style="height:2px"><TD class=Line1 colSpan = 2></TD></TR>
  </tbody>
</table>
<TABLE class=ListStyle cellspacing=1  id = "oTable_kqjx" cols = 2>
  <COLGROUP>
  <COL width = "5%">
  <COL width = "95%">
  <TBODY>
  <TR class = Header>
    <TD>&nbsp;</TD>
    <TD><%=SystemEnv.getHtmlLabelName(16672 , user.getLanguage())%></TD>
    </TR>
    <TR class=Line><TD colspan="2" ></TD></TR>
  <TR bgcolor = "#efefef">
    <TD><input class=inputstyle type = 'checkbox' name = 'check_kqjx' value = 1></TD>
    <TD><BUTTON class = Browser onclick = 'onShowScheduleAdd(diffnamejxspan0,diffnamejx0)'></BUTTON>
    <SPAN id = diffnamejxspan0></SPAN>
    <input class=inputstyle type = 'hidden' name = 'diffnamejx0' value = ''>
    </TD>
    </TR>
  </tbody>
</table>
</div>


<div id = tb_cqjt style = "display:none">
<br>
<table  class = Liststyle cellspacing=1>
  <COLGROUP>
  <COL width = "15%">
  <COL width = "85%">
  <tbody>
  <TR class = Header>
    <TH><%=SystemEnv.getHtmlLabelName(16740 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right"></TH>
  </TR>
  <TR class = Header>
    <TD><%=SystemEnv.getHtmlLabelName(16741 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(534 , user.getLanguage())%></TD>
  </TR>
  <TR bgcolor = "#efefef">
    <TD><%=SystemEnv.getHtmlLabelName(16254,user.getLanguage())%></TD>
    <TD><input class=inputstyle type = 'text' name = 'shift0' value = '' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'></TD>
  </TR>
  <%
     RecordSet.executeProc("HrmArrangeShift_SelectAll" , "0") ;
	 while(RecordSet.next()){
		String shiftid = Util.null2String( RecordSet.getString("id") ) ;
        String shiftname = Util.null2String( RecordSet.getString("shiftname") ) ;
  %>
  <TR bgcolor = "#efefef">
    <TD><%=shiftname%></TD>
    <TD><input class=inputstyle type = 'text' name = 'shift<%=shiftid%>' value = '' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'></TD>
  </TR>
  <% } %>
  </tbody>
</table>
</div>




<input class=inputstyle type = "hidden" name = "totalje" value = 1>
<input class=inputstyle type = "hidden" name = "totalss" value = 1>
<input class=inputstyle type = "hidden" name = "totalcal" value = 1>
<input class=inputstyle type = "hidden" name = "totalwel" value = 1>
<input class=inputstyle type = "hidden" name = "totalfl" value = 1>
<input class=inputstyle type = "hidden" name = "totalssd">
<input class=inputstyle type = "hidden" name = "totalcald">
<input class=inputstyle type = "hidden" name = "totalweld">
<input class=inputstyle type = "hidden" name = "totalkqkk" value = 1>
<input class=inputstyle type = "hidden" name = "totalkqjx" value = 1>
</form>
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

<script language = javascript>
function onShowJobID(tdname , inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp");
	if (data!=null){
		if (data.id!=null){
            tdname.innerHTML = data.name;
            inputename.value = data.id;
		}else{
            tdname.innerHTML = "";
            inputename.value = "";
		}
	}
}

function onShowCityID(tdname , inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp");
	if (data!=null){
		if (data.id!=null){
            tdname.innerHTML = data.name;
            inputename.value = data.id;
		}else{
            tdname.innerHTML = "";
            inputename.value = "";
		}
	}
}



function onShowJobActivity(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp");
	if (data!=null){
		if (data.id!=null){
			tdname.innerHTML = data.name;
			inputename.value = data.id;
		}else{
			tdname.innerHTML = "";
			inputename.value="";
		}
	}
}
</script>

<script language = javascript>
var jerowindex = 1 ;
var flrowindex = 1 ;
var ssrowindex = 1 ;
var calrowindex = 1 ;
var welrowindex = 1 ;
var kqkkrowindex = 1 ; //考勤扣款index
var kqjxrowindex = 1 ;//考勤加薪index

var ssdrowindex = new Array() ;
ssdrowindex[0] = 1 ;
var caldrowindex = new Array() ;
caldrowindex[0] = 1 ;
var weldrowindex = new Array() ;
weldrowindex[0] = 1 ;
function doSubmit(obj) {
    itemtype = document.frmMain.itemtype.value ;
    isshow = window.document.frmMain.isshow.value ;
    checkitemstr = "" ;
    if(itemtype==1) checkitemstr = "itemname,itemcode,isshow,history" ;
    else if(itemtype==2) checkitemstr = "itemname,itemcode,isshow,history,personwelfarerate,companywelfarerate" ;
    else if(itemtype==3) checkitemstr = "itemname,itemcode,isshow,history,taxrelateitem" ;
    else if(itemtype==4) checkitemstr = "itemname,itemcode,isshow,history,amountecp" ;
    else if(itemtype==5) checkitemstr = "itemname,itemcode,isshow,history,diffname" ;
    else if(itemtype==6) checkitemstr = "itemname,itemcode,isshow,history,diffname" ;
    else if(itemtype==9) checkitemstr = "itemname,itemcode,isshow,history,diffname" ;
    if(isshow==1) checkitemstr += ",showorder" ;

    if(check_form(document.frmMain , checkitemstr)){
        if( itemtype == 3){                   // 税收
            totalssd = "" ;
            for(i= 0 ; i<ssrowindex ; i++){
                temptotalss = ssdrowindex[i] ;
                if(totalssd == "") totalssd = temptotalss ;
                else totalssd += "," + temptotalss ;
            }
            document.frmMain.totalssd.value = totalssd ;
        }
        if( itemtype == 4){                   // 税收
            totalcald = "" ;
            for(i= 0 ; i<calrowindex ; i++){
                temptotalcal = caldrowindex[i] ;
                if(totalcald == "") totalcald = temptotalcal ;
                else totalcald += "," + temptotalcal ;
            }
            document.frmMain.totalcald.value = totalcald ;
        }
        if( itemtype == 9){                   //
            totalweld = "" ;
            for(i= 0 ; i<welrowindex ; i++){
                temptotalwel = weldrowindex[i] ;
                if(totalweld == "") totalweld = temptotalwel ;
                else totalweld += "," + temptotalwel ;
            }
            document.frmMain.totalweld.value = totalweld ;
        }
        obj.disabled=true;
        document.frmMain.submit() ;
    }
}
function changeScope(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(19545 , user.getLanguage())%>")){
   document.frmMain.action="HrmSalaryItemAdd.jsp"
   document.frmMain.submit() ;
       }else{
           document.frmMain.applyscope.selectedIndex=document.frmMain.applyscope.original;
           document.frmMain.calMode.selectedIndex =document.frmMain.calMode.original-1;
           return false;
   }
}
function addRowKq_Dec() {   //类型中选考勤的处理加入一行的程序代码
    ncol = oTable_kqkk.cols ;
	oRow = oTable_kqkk.insertRow() ;

	for(j=0 ; j < ncol ; j++){
		oCell = oRow.insertCell() ;
        oCell.style.height = 24 ;
		oCell.style.background = "#efefef" ;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_kqkk' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser onclick='onShowScheduleDec(diffnamekkspan" + kqkkrowindex + ",diffnamekk" + kqkkrowindex + ")'></BUTTON><SPAN id=diffnamekkspan" + kqkkrowindex + "></SPAN><input class=inputstyle type='hidden' name='diffnamekk" + kqkkrowindex + "'>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	kqkkrowindex = kqkkrowindex * 1 + 1 ;
	frmMain.totalkqkk.value = kqkkrowindex ;
}

function addRowKq_Add() {   //类型中选考勤加薪的处理加入一行的程序代码
    ncol = oTable_kqjx.cols ;
	oRow = oTable_kqjx.insertRow() ;

	for(j=0 ; j < ncol ; j++){
		oCell = oRow.insertCell() ;
        oCell.style.height = 24 ;
		oCell.style.background = "#efefef" ;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_kqjx' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser onclick='onShowScheduleAdd(diffnamejxspan" + kqjxrowindex + ",diffnamejx" + kqjxrowindex + ")'></BUTTON><SPAN id=diffnamejxspan" + kqjxrowindex + "></SPAN><input class=inputstyle type='hidden' name='diffnamejx" + kqjxrowindex + "'>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	kqjxrowindex = kqjxrowindex * 1 + 1 ;
	frmMain.totalkqjx.value = kqjxrowindex ;
}
function addRowJe(){//类型中选工资的处理加一行的代码,此处加上
	ncol = oTable_je.cols ;
	oRow = oTable_je.insertRow() ;
	for(j=0 ; j<ncol ; j++){
		oCell = oRow.insertCell() ;
        oCell.style.height = 24 ;
		oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_je' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser onClick ='onShowJobActivity(jobactivityspan"+jerowindex+",jobactivityid"+jerowindex+")'></BUTTON>"+
                "<span class=inputstyle id=jobactivityspan"+jerowindex+"></span>" +
                "<INPUT class=inputstyle id=jobactivityid"+jerowindex+" type=hidden name=jobactivityid"+jerowindex+">";
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 2:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser onclick='onShowJobID(jobidspan"+jerowindex+",jobid"+jerowindex+")'></BUTTON>"+
                            "<SPAN id=jobidspan"+jerowindex+"></SPAN><input class=inputstyle type='hidden' name='jobid"+jerowindex+"'>";
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='text' name='joblevelfrom"+jerowindex+"' style='width:100%' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 4:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='text' name='joblevelto"+jerowindex+"' style='width:100%' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
				oDiv.innerHTML = sHtml ;
                oCell.appendChild(oDiv) ;
                break ;
            case 5:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='text' name='amount"+jerowindex+"' style='width:100%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	jerowindex = jerowindex * 1 + 1 ;
	frmMain.totalje.value = jerowindex ;
}

function addRowFl(){
	ncol = oTable_fl.cols ;
	oRow = oTable_fl.insertRow() ;
	for(j=0; j<ncol ; j++) {
		oCell = oRow.insertCell() ;
        oCell.style.height=24 ;
		oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_fl' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser onclick='onShowCityID(ratecityidspan"+flrowindex+",ratecityid"+flrowindex+")'></BUTTON><SPAN id='ratecityidspan"+flrowindex+"'></SPAN><input class=inputstyle type='hidden' name='ratecityid"+flrowindex+"' value=''>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 2:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 size=15 name='personwelfarerate"+flrowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>%" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 size=15 name='companywelfarerate"+flrowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>%" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	flrowindex = flrowindex*1 +1;
	frmMain.totalfl.value = flrowindex;
}

function addRowSs(){
	ncol = oTable_ss.cols ;
	oRow = oTable_ss.insertRow() ;
    ssdrowindex[ssrowindex] = 1 ;

	for(j = 0 ; j < ncol ; j++){
		oCell = oRow.insertCell() ;
        oCell.style.height=24 ;
		oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_ss' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<TABLE class=ListShort id='oTable_ssdetail"+ssrowindex+"' " +                             "name='oTable_ssdetail"+ssrowindex+"' cols=6>"+
                            "<COLGROUP>"+
                            "<COL width='20%'>"+
                            "<COL width='18%'>"+
                            "<COL width='7%'>"+
                            "<COL width='18%'>"+
                            "<COL width='18%'>"+
                            "<COL width='20%'>"+
                            "<TBODY>"+
                            "<TR class=Header>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(19467,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(15835,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(15837,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(15838,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(15834,user.getLanguage())%>(%)</TD>"+
                            "</TR>"+
                            "<TR class=DataDark>"+
                            "<TD>"+
                            "<select name=scopetype"+ssrowindex+" onchange='changescopetype(this);'>"+
                            "<option  value=0><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>"+
                            "<option  value=1><%=SystemEnv.getHtmlLabelName(493 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>"+
                            "</select>"+
                            "<BUTTON class=Browser type=button style = 'display:none'"+
                            "onclick='onShowOrganization(cityidspan"+ssrowindex+",cityid"+ssrowindex+",scopetype"+ssrowindex+")'>"+
                            "</BUTTON><SPAN id=cityidspan"+ssrowindex+"></SPAN>"+
                            "<input class=inputstyle type='hidden' name='cityid"+ssrowindex+"'></TD>"+
                            "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='taxbenchmark"+ssrowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
                            "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='ranknum"+ssrowindex+"_0' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
                            "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='ranklow"+ssrowindex+"_0' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
                            "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='rankhigh"+ssrowindex+"_0' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
                            "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='taxrate"+ssrowindex+"_0' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
                            "</TR>"+
                            "</tbody>"+
                            "</table>"+
                            "<TABLE width=100%>"+
                            "<TR>"+
                            "<TD align=right>"+
                            "<BUTTON class=btnNew accessKey=1 onClick=addRowSsD("+ssrowindex+");>" +
                            "<U>1</U>-<%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%></BUTTON>"+
                            "</TD>"+
                            "</TR>"+
                            "</table>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	ssrowindex = ssrowindex * 1 + 1 ;
	frmMain.totalss.value = ssrowindex ;
}

function addRowSsD(tableid){
    thetable = document.all("oTable_ssdetail"+tableid) ;
    tablerowindex = ssdrowindex[tableid] ;
	ncol = thetable.cols ;
	oRow = thetable.insertRow() ;
	for(j=0 ; j<ncol ; j++){
		oCell = oRow.insertCell() ;
        oCell.style.height = 24 ;
		oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "&nbsp;" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "&nbsp;" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 2:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='ranknum"+tableid+"_"+tablerowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' >" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='ranklow"+tableid+"_"+tablerowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' >" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 4:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='rankhigh"+tableid+"_"+tablerowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' >" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 5:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='taxrate"+tableid+"_"+tablerowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' >" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	ssdrowindex[tableid] = ssdrowindex[tableid] * 1 + 1 ;
}

function addRowCal(){
	ncol = jQuery(oTable_cal).find("tr:first")[0].cells.length ;
	oRow = oTable_cal.insertRow(-1) ;
    caldrowindex[calrowindex] = 1 ;
   
    rowColor = getRowBg();
	for(j = 0 ; j < ncol ; j++){
		
		oCell = oRow.insertCell(-1) ;
        oCell.style.height=24 ;
	    oCell.style.background= rowColor;
//		oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_cal' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<TABLE class=ListShort id='oTable_caldetail"+calrowindex+"' " +                             "name='oTable_caldetail"+calrowindex+"' cols=4>"+
                            "<COLGROUP>"+
                            "<COL width='20%'>"+
                            "<COL width='20%'>"+
                            "<COL width='30%'>"+
                            "<COL width='30%'>"+
                            "<TBODY>"+
                            "<TR class=Header>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(19467,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(18125,user.getLanguage())%></TD>"+
                            "</TR>"+
                            "<TR class=DataDark>"+
                            "<TD>"+
                            "<select name=scopetypecal"+calrowindex+" onchange='changescopetype(this);'>"+
                            "<option  value=0><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>"+
                            "</select>"+
                            "<BUTTON class=Browser type=button style = 'display:none'"+
                            "onclick='onShowOrganization(objectidcalspan"+calrowindex+",objectidcal"+calrowindex+",scopetypecal"+calrowindex+")'>"+
                            "</BUTTON><SPAN id=objectidcalspan"+calrowindex+"></SPAN>"+
                            "<input class=inputstyle type='hidden' name='objectidcal"+calrowindex+"'></TD>"+
                            "<TD>"+
                            "<select name=timescopecal"+calrowindex+"_0 >"+
                            "<option  value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>"+
                            "</select></td>"+
                            "<TD><BUTTON class=Browser type=button onClick='onShowCon(concalspan"+calrowindex+"_0,concal"+calrowindex+"_0,condspcal"+calrowindex+"_0,scopetypecal"+calrowindex+")' ></BUTTON>"+
                            "<span id=concalspan"+calrowindex+"_0 name=concalspan"+calrowindex+"_0></span>"+
                            "<input type=hidden name=concal"+calrowindex+"_0>"+
                            "<input type=hidden name=condspcal"+calrowindex+"_0></TD>"+
                            "<TD><BUTTON class=Browser type=button onClick='onShowFormula(formulacalspan"+calrowindex+"_0,formulacal"+calrowindex+"_0,formuladspcal"+calrowindex+"_0,scopetypecal"+calrowindex+")' ></BUTTON>"+
                            "<span id=formulacalspan"+calrowindex+"_0 name=formulacalspan"+calrowindex+"_0></span>"+
                            "<input type=hidden name=formulacal"+calrowindex+"_0></TD>"+
                            "<input type=hidden name=formuladspcal"+calrowindex+"_0></TD>"+
                            "</TR>"+
                            "</tbody>"+
                            "</table>"+
                            "<TABLE width=100%>"+
                            "<TR>"+
                            "<TD align=right>"+
                            "<BUTTON class=btnNew type=button accessKey=1 onClick=addRowCalD("+calrowindex+");>" +
                            "<U>1</U>-<%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%></BUTTON>"+
                            "</TD>"+
                            "</TR>"+
                            "</table>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	calrowindex = calrowindex * 1 + 1 ;
	frmMain.totalcal.value = calrowindex ;
}

function addRowWel(){
	ncol = oTable_wel.cols ;
	oRow = oTable_wel.insertRow() ;
    weldrowindex[welrowindex] = 1 ;

	for(j = 0 ; j < ncol ; j++){
		oCell = oRow.insertCell() ;
        oCell.style.height=24 ;
		oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_wel' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<TABLE class=ListShort id='oTable_weldetail"+welrowindex+"' " +  "name='oTable_wldetail"+welrowindex+"' cols=4>"+
                            "<COLGROUP>"+
                            "<COL width='20%'>"+
                            "<COL width='20%'>"+
                            "<COL width='30%'>"+
                            "<COL width='30%'>"+
                            "<TBODY>"+
                            "<TR class=Header>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(19467,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TD>"+
                            "<TD><%=SystemEnv.getHtmlLabelName(18125,user.getLanguage())%></TD>"+
                            "</TR>"+
                            "<TR class=DataDark>"+
                            "<TD>"+
                            "<select name=scopetypewel"+welrowindex+" onchange='changescopetype(this);'>"+
                            "<option  value=0><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>"+
                            "</select>"+
                            "<BUTTON class=Browser type=button style = 'display:none'"+
                            "onclick='onShowOrganization(objectidwelspan"+welrowindex+",objectidwel"+welrowindex+",scopetypewel"+welrowindex+")'>"+
                            "</BUTTON><SPAN id=objectidwelspan"+welrowindex+"></SPAN>"+
                            "<input class=inputstyle type='hidden' name='objectidwel"+welrowindex+"'></TD>"+
                            "<TD>"+
                            "<select name=timescopewel"+welrowindex+"_0 >"+
                            "<option  value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>"+
                            "</select></td>"+
                            "<TD><BUTTON class=Browser type=button onClick='onShowCon(conwelspan"+welrowindex+"_0,conwel"+welrowindex+"_0,condspwel"+welrowindex+"_0,scopetypewel"+welrowindex+")' ></BUTTON>"+
                            "<span id=conwelspan"+welrowindex+"_0 name=conwelspan"+welrowindex+"_0></span>"+
                            "<input type=hidden name=conwel"+welrowindex+"_0>"+
                            "<input type=hidden name=condspwel"+welrowindex+"_0></TD>"+
                            "<TD><BUTTON class=Browser type=button onClick='onShowFormula(formulawelspan"+welrowindex+"_0,formulawel"+welrowindex+"_0,formuladspwel"+welrowindex+"_0,scopetypewel"+welrowindex+")' ></BUTTON>"+
                            "<span id=formulawelspan"+welrowindex+"_0 name=formulawelspan"+welrowindex+"_0></span>"+
                            "<input type=hidden name=formulawel"+welrowindex+"_0></TD>"+
                            "<input type=hidden name=formuladspwel"+welrowindex+"_0></TD>"+
                            "</TR>"+
                            "</tbody>"+
                            "</table>"+
                            "<TABLE width=100%>"+
                            "<TR>"+
                            "<TD align=right>"+
                            "<BUTTON class=btnNew accessKey=1 onClick=addRowWelD("+welrowindex+");>" +
                            "<U>1</U>-<%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%></BUTTON>"+
                            "</TD>"+
                            "</TR>"+
                            "</table>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	welrowindex = welrowindex * 1 + 1 ;
	frmMain.totalwel.value = welrowindex ;
}
function addRowCalD(tableid){
    thetable = jQuery("#oTable_caldetail"+tableid)[0];
    tablerowindex = caldrowindex[tableid] ;
	ncol = jQuery(thetable).find("tr:first").find("td").length; ;
	oRow = thetable.insertRow(-1) ;

	rowColor = getRowBg();
	for(j=0 ; j<ncol ; j++){
		oCell = oRow.insertCell(-1) ;
        oCell.style.height = 24 ;
		oCell.style.background = rowColor ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "&nbsp;" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
                var sHtml = "<select  name = 'timescopecal"+tableid+"_"+tablerowindex+"'>"+
                            "<option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>"+
                            "<option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>"+
                            "<option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>"+
                            "<option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>"+
                            "</select>" ;
                oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 2:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser type=button onClick='onShowCon(concalspan"+tableid+"_"+tablerowindex+",concal"+tableid+"_"+tablerowindex+",condspcal"+tableid+"_"+tablerowindex+",scopetypecal"+tableid+")' ></BUTTON>"+
                            "<span id='concalspan"+tableid+"_"+tablerowindex+"' name='concalspan"+tableid+"_"+tablerowindex+"'></span>"+
                            "<input type=hidden name='concal"+tableid+"_"+tablerowindex+"'>"+
                            "<input type=hidden name='condspcal"+tableid+"_"+tablerowindex+"'>"
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser type=button onClick='onShowFormula(formulacalspan"+tableid+"_"+tablerowindex+",formulacal"+tableid+"_"+tablerowindex+",formuladspcal"+tableid+"_"+tablerowindex+",scopetypecal"+tableid+")' ></BUTTON>"+
                            "<span id='formulacalspan"+tableid+"_"+tablerowindex+"' name='formulacalspan"+tableid+"_"+tablerowindex+"'></span>"+
                            "<input type=hidden name='formulacal"+tableid+"_"+tablerowindex+"'>"+
                            "<input type=hidden name='formuladspcal"+tableid+"_"+tablerowindex+"'>"
                oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;

		}
	}
	caldrowindex[tableid] = caldrowindex[tableid] * 1 + 1 ;
}

function addRowWelD(tableid){
    thetable = document.all("oTable_weldetail"+tableid) ;
    tablerowindex = weldrowindex[tableid] ;
	ncol = thetable.cols ;
	oRow = thetable.insertRow() ;
	for(j=0 ; j<ncol ; j++){
		oCell = oRow.insertCell() ;
        oCell.style.height = 24 ;
		oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "&nbsp;" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
                var sHtml = "<select  name = 'timescopewel"+tableid+"_"+tablerowindex+"'>"+
                            "<option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>"+
                            "<option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>"+
                            "<option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>"+
                            "<option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>"+
                            "</select>" ;
                oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 2:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser type=button onClick='onShowCon(conwelspan"+tableid+"_"+tablerowindex+",conwel"+tableid+"_"+tablerowindex+",condspwel"+tableid+"_"+tablerowindex+",scopetypewel"+tableid+")' ></BUTTON>"+
                            "<span id='conwelspan"+tableid+"_"+tablerowindex+"' name='conwelspan"+tableid+"_"+tablerowindex+"'></span>"+
                            "<input type=hidden name='conwel"+tableid+"_"+tablerowindex+"'>"+
                            "<input type=hidden name='condspwel"+tableid+"_"+tablerowindex+"'>"
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser type=button onClick='onShowFormula(formulawelspan"+tableid+"_"+tablerowindex+",formulawel"+tableid+"_"+tablerowindex+",formuladspwel"+tableid+"_"+tablerowindex+",scopetypewel"+tableid+")' ></BUTTON>"+
                            "<span id='formulawelspan"+tableid+"_"+tablerowindex+"' name='formulawelspan"+tableid+"_"+tablerowindex+"'></span>"+
                            "<input type=hidden name='formulawel"+tableid+"_"+tablerowindex+"'>"+
                            "<input type=hidden name='formuladspwel"+tableid+"_"+tablerowindex+"'>"
                oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;

		}
	}
	weldrowindex[tableid] = weldrowindex[tableid] * 1 + 1 ;
}

function deleteRow1_Kq_Dec(){//在类型中选了考勤扣款的删除程序代码
    len = document.forms[0].elements.length ;
    var i = 0 ;
    var rowsum1 = 0 ;
	for(i=len-1 ;  i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_kqkk')
			rowsum1 += 1 ;
	}

	for(i=len-1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_kqkk') {
			if(document.forms[0].elements[i].checked==true) {
				oTable_kqkk.deleteRow(rowsum1+1) ;
			}
			rowsum1 -=1 ;
		}
	}
 }
 function deleteRow1_Kq_Add(){//在类型中选了考勤加薪的删除程序代码
    len = document.forms[0].elements.length ;
    var i = 0 ;
    var rowsum1 = 0 ;
	for(i=len-1 ;  i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_kqjx')
			rowsum1 += 1 ;
	}

	for(i=len-1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_kqjx') {
			if(document.forms[0].elements[i].checked==true) {
				oTable_kqjx.deleteRow(rowsum1+1) ;
			}
			rowsum1 -=1 ;
		}
	}
 }

function deleteRow1_Je(){//在类型中选工资的删除代码
	len = document.forms[0].elements.length ;
    var i = 0 ;
    var rowsum1 = 0 ;
	for( i=len-1 ;  i>=0 ; i-- ) {
		if (document.forms[0].elements[i].name=='check_je')
			rowsum1 += 1 ;
	}
	for(i=len-1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_je') {
			if(document.forms[0].elements[i].checked==true) {
				oTable_je.deleteRow(rowsum1+1) ;
			}
			rowsum1 -= 1 ;
		}
	}
}

function deleteRow1_Fl(){
	len = document.forms[0].elements.length ;
    var i = 0 ;
    var rowsum1 = 0 ;
	for( i=len - 1 ; i>=0 ; i-- ) {
		if (document.forms[0].elements[i].name=='check_fl')
			rowsum1 += 1 ;
	}
	for(i=len - 1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_fl') {
			if(document.forms[0].elements[i].checked==true) {
				oTable_fl.deleteRow(rowsum1+1) ;
			}
			rowsum1 -= 1 ;
		}
	}
}

function deleteRow1_Ss(){
	len = document.forms[0].elements.length ;
	var i = 0 ;
    var rowsum1 = 0 ;
    for(i=len - 1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_ss')
			rowsum1+= 1 ;
	}
	for(i=len - 1; i>= 0 ; i--){
		if (document.forms[0].elements[i].name=='check_ss'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_ss.deleteRow(rowsum1-1) ;
			}
			rowsum1 -= 1 ;
		}
	}
}
function deleteRow1_Cal(){
	len = document.forms[0].elements.length ;
	var i = 0 ;
    var rowsum1 = 0 ;
    for(i=len - 1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_cal')
			rowsum1+= 1 ;
	}
	for(i=len - 1; i>= 0 ; i--){
		if (document.forms[0].elements[i].name=='check_cal'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_cal.deleteRow(rowsum1-1) ;
			}
			rowsum1 -= 1 ;
		}
	}
}
function deleteRow1_Wel(){
	len = document.forms[0].elements.length ;
	var i = 0 ;
    var rowsum1 = 0 ;
    for(i=len - 1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_wel')
			rowsum1+= 1 ;
	}
	for(i=len - 1; i>= 0 ; i--){
		if (document.forms[0].elements[i].name=='check_wel'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_wel.deleteRow(rowsum1-1) ;
			}
			rowsum1 -= 1 ;
		}
	}
}
var isfirst = false;
 function showType(){
    itemtypelist = window.document.frmMain.itemtype ;
    if(itemtypelist.value==1){
        tb_fl.style.display = 'none' ;
        tr_taxrelateitem.style.display = 'none' ;
        //tr_amountecp.style.display = 'none' ;
        tb_je.style.display = '' ;
        tb_ss.style.display = 'none' ;
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = '' ;
        tb_wel1.style.display = 'none' ;
        tr_wel.style.display='none';
        tr_wel1.style.display='none';
        document.all("calMode").style.display='none';
        document.all("directModify").style.display='none';
        if(isfirst==false){
        <%
        if(!"1".equals(itemtype)){
	        out.print(scriptStr);
        }
        %>
        }
        isfirst = true;
    }
    else if(itemtypelist.value==2){
        tb_fl.style.display = '' ;
        tr_taxrelateitem.style.display = 'none' ;
        //tr_amountecp.style.display = 'none' ;
        tb_je.style.display = '' ;
        tb_ss.style.display = 'none' ;
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = '' ;
        tb_wel1.style.display = 'none' ;
        tr_wel.style.display='none';
        tr_wel1.style.display='none';
        document.all("calMode").style.display='none';
        document.all("directModify").style.display='none';
    }
    else if(itemtypelist.value==3){
        tb_fl.style.display = 'none';
        tr_taxrelateitem.style.display = '';
        //tr_amountecp.style.display='none' ;
        tb_je.style.display = 'none' ;
        tb_ss.style.display = '' ;
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        tb_wel1.style.display = 'none' ;
        tr_wel.style.display='none';
        tr_wel1.style.display='none';
        document.all("calMode").style.display='none';
        document.all("directModify").style.display='none';
    }
    else if(itemtypelist.value==4){
        tb_fl.style.display = 'none' ;
        tr_taxrelateitem.style.display = 'none' ;
        //tr_amountecp.style.display = '' ;
        tb_je.style.display = 'none' ;
        tb_cal.style.display = '' ;
        tb_ss.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = '' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        tb_wel1.style.display = 'none' ;
        tr_wel.style.display='none';
        tr_wel1.style.display='';
        document.all("calMode").style.display='none';
        document.all("directModify").style.display='';
    }
    else if(itemtypelist.value==5){
        tb_fl.style.display = 'none' ; //福利
        tr_taxrelateitem.style.display = 'none' ; //相关税率项目
        //tr_amountecp.style.display = 'none' ; //计算公式
        tb_je.style.display = 'none' ; //工资
        tb_ss.style.display = 'none' ; //税收
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ; //计算
        tb_kqjx.style.display = 'none' ;
        tb_kqkk.style.display = '' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        tb_wel1.style.display = 'none' ;
        tr_wel.style.display='none';
        tr_wel1.style.display='none';
        document.all("calMode").style.display='none';
        document.all("directModify").style.display='none';
    }
    else if(itemtypelist.value==6){
        tb_fl.style.display = 'none' ; //福利
        tr_taxrelateitem.style.display = 'none' ; //相关税率项目
        //tr_amountecp.style.display = 'none' ; //计算公式
        tb_je.style.display = 'none' ; //工资
        tb_ss.style.display = 'none' ; //税收
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ; //计算
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = '' ;    // 考勤
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        tb_wel1.style.display = 'none' ;
        tr_wel.style.display='none';
        tr_wel1.style.display='none';
        document.all("calMode").style.display='none';
        document.all("directModify").style.display='none';
    }
    else if(itemtypelist.value==7){
        tb_fl.style.display = 'none' ; //福利
        tr_taxrelateitem.style.display = 'none' ; //相关税率项目
        //tr_amountecp.style.display = 'none' ; //计算公式
        tb_je.style.display = 'none' ; //工资
        tb_ss.style.display = 'none' ; //税收
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ; //计算
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;    // 考勤
        tb_cqjt.style.display = '' ;       // 出勤津贴
        tb_cqzf.style.display = 'none' ;
        tb_wel1.style.display = 'none' ;
        tr_wel.style.display='none';
        tr_wel1.style.display='none';
        document.all("calMode").style.display='none';
        document.all("directModify").style.display='none';
    }
    else if(itemtypelist.value==8){
        tb_fl.style.display = 'none' ; //福利
        tr_taxrelateitem.style.display = 'none' ; //相关税率项目
        //tr_amountecp.style.display = 'none' ; //计算公式
        tb_je.style.display = 'none' ; //工资
        tb_ss.style.display = 'none' ; //税收
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ; //计算
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;    // 考勤
        tb_cqjt.style.display = 'none' ;       // 出勤津贴
        tb_cqzf.style.display = '' ;
        tb_wel1.style.display = 'none' ;
        tr_wel.style.display='none';
        tr_wel1.style.display='none';
        document.all("calMode").style.display='none';
        document.all("directModify").style.display='none';
    }
    else if(itemtypelist.value==9){
        tb_fl.style.display = 'none' ; //福利
        tr_taxrelateitem.style.display = 'none' ; //相关税率项目
        //tr_amountecp.style.display = 'none' ; //计算公式
        tb_je.style.display = 'none' ; //工资
        tb_ss.style.display = 'none' ; //税收
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = '' ;
        tb_jssm.style.display = '' ; //计算
        tb_kqjx.style.display = 'none' ;
        tb_kqkk.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        if(document.all("calMode").value=='1')
        tb_wel1.style.display = '' ;
        else
        tb_wel1.style.display = 'none' ;
        tr_wel.style.display='';
        tr_wel1.style.display='';
        document.all("calMode").style.display='';
        document.all("directModify").style.display='';

    }
}

function onShowOrganization(spanname, inputname,orgtype) {
    if (orgtype.value == "4")
        return onShowHR(spanname, inputname);
    else if (orgtype.value == "3")
        return onShowDept(spanname, inputname);
    else if (orgtype.value == "2")
        return onShowSubcom(spanname, inputname);
    else if (orgtype.value == "1")
        return onShowCityID(spanname, inputname);
    else{
        return null;
        }
}
function onShowHR(spanname, inputname) {
	var arrayid,arrayname;
    if(document.all("applyscope").value=="0")
    url="/hrm/resource/MutiResourceBrowser.jsp";
    else if(document.all("applyscope").value=="1")
     url=escape("/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=where subcompanyid1=<%=subcompanyid%>");
    else if(document.all("applyscope").value=="2")
     url=escape("/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=where subcompanyid1 in(<%=subids%>)");
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    if(datas){
        if(datas.id!=""){
              arrayid=datas.id.split(",");
              arrayname=datas.name.split(",");
              sHtml = "";
              for(var i=0;i<arrayid.length;i++){
            	  if(arrayid[i]!=""){
            	      sHtml = sHtml+"<a href =javaScript:openhrm("+arrayid[i]+")  onclick='pointerXY(event);' >"+arrayname[i]+"</a>&nbsp";
            	  }
              }                   
              spanname.innerHTML = sHtml;
              inputname.value = datas.id;
        }else{
	      	   spanname.innerHTML = "";
	           inputname.value = "";
       }

    }
}

function onShowDept(spanname, inputname) {
    url=escape("/hrm/finance/salary/MutiDepartmentByRightBrowser.jsp?selectedids="+inputname.value+"&rightStr=HrmResourceComponentAdd:Add&subcompanyid=<%=subcompanyid%>&scope="+document.all("applyscope").value);
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    sHtml = "";
    if(datas){
        if(datas.id!=""){
        	arrayname=datas.name.split(",");
        	for(var i=0;i<arrayname.length;i++){
        		sHtml =sHtml+arrayname[i]+"&nbsp" ;
            }
     	    spanname.innerHTML = sHtml;
            inputname.value = datas.id;
        }else{
     	    spanname.innerHTML = "";
            inputname.value = "";
        }
        
     }

}
function onShowSubcom(spanname, inputname) {
    url=escape("/hrm/finance/salary/MutiSubCompanyByRightBrowser.jsp?selectedids="+inputname.value+"&rightStr=HrmResourceComponentAdd:Add&subcompanyid=<%=subcompanyid%>&scope="+document.all("applyscope").value);
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    sHtml = "";
    if(datas){
       if(datas.id!=""){
    	   arrayname=datas.name.split(",");
       	   for(var i=0;i<arrayname.length;i++){
       		     sHtml =sHtml+arrayname[i]+"&nbsp" ;
           }
    	   spanname.innerHTML = sHtml;
           inputname.value = datas.id;
       }else{
    	   spanname.innerHTML = "";
           inputname.value = "";
       }
       
    }
    
}
function onShowItemId(spanname , inputname){
    url=escape("/hrm/finance/salary/SalaryItemRightBrowser.jsp?subcompanyid=<%=subcompanyid%>&scope="+document.all("applyscope").value);
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)  ;
    if(datas){
        if(datas.id!=""){
        	spanname.innerHTML = datas.name;
            inputname.value = datas.id;
        }else{
        	 spanname.innerHTML = "";
             inputname.value = "";
        }
    }
}
function onShowScheduleDec(spanname , inputname){
    url=escape("/hrm/finance/salary/HrmScheduleDiffBrowser.jsp?difftype=1&subcompanyid=<%=subcompanyid%>&scope="+document.all("applyscope").value)
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
    if(datas){
        if(datas.id!=""){
        	spanname.innerHTML = datas.name;
            inputname.value = datas.id;
        }else{
        	 spanname.innerHTML = "";
             inputname.value = "";
        }
    }
}

function onShowScheduleAdd(spanname , inputname){
    url=escape("/hrm/finance/salary/HrmScheduleDiffBrowser.jsp?difftype=0&subcompanyid=<%=subcompanyid%>&scope="+document.all("applyscope").value)
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    if(datas){
        if(datas.id!=""){
        	spanname.innerHTML = datas.name;
            inputname.value = datas.id;
        }else{
        	 spanname.innerHTML = "";
             inputname.value = "";
        }
    }
}

function onShowCon(spanname , inputname,inputname1,scopetype){
    if(scopetype.value!=0&&scopetype.parentNode.getElementsByTagName("input")[0].value==""){
    alert("<%=SystemEnv.getHtmlLabelName(18214 , user.getLanguage())+SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%>")  ;
    return;
        }
    url=escape("/hrm/finance/salary/conditions.jsp?subc=<%=subcompanyid%>&scope="+document.all("applyscope").value+"&st="+scopetype.value+"&sv="+scopetype.parentNode.getElementsByTagName("input")[0].value);
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)  ;
    if(datas){
        if(datas.id!=""){
        	spanname.innerHTML = datas.name;
            inputname.value = datas.id;
            inputname1.value = datas.name;
        }else{
        	 spanname.innerHTML = "";
             inputname.value = "";
             inputname1.value = "";
        }
    }
}

function onShowFormula(spanname , inputname,inputname1,scopetype){
    if(scopetype.value!=0&&scopetype.parentNode.getElementsByTagName("input")[0].value==""){
    alert("<%=SystemEnv.getHtmlLabelName(18214 , user.getLanguage())+SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%>")  ;
        return;
        }
    if(document.all("itemtype").value=='9'&&document.all("calMode").value=='2'){
    	url=escape("/hrm/finance/salary/formula1.jsp?subc=<%=subcompanyid%>&scope="+document.all("applyscope").value+"&st="+scopetype.value+"&sv="+scopetype.parentNode.getElementsByTagName("input")[0].value);
    }else{
    	url=escape("/hrm/finance/salary/formula.jsp?subc=<%=subcompanyid%>&scope="+document.all("applyscope").value+"&st="+scopetype.value+"&sv="+scopetype.parentNode.getElementsByTagName("input")[0].value);
    }
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)  ;
    if(datas){
        if(datas.id!=""){
        	spanname.innerHTML = datas.name;
            inputname.value = datas.id;
            inputname1.value = datas.name;
        }else{
        	 spanname.innerHTML = "";
             inputname.value = "";
             inputname1.value = "";
        }
    }
}

showType();
changescopetype(document.all("scopetype0"));
changescopetype(document.all("scopetypecal0"));
</script>
</body>
</html>