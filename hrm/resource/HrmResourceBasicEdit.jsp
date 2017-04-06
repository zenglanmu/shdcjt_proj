<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.login.Account"%>
<%@ page import="weaver.login.VerifyLogin"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page"/>
<jsp:useBean id="JobtitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />

<html>
<%
 String id = request.getParameter("id");
 String isView = request.getParameter("isView");
 boolean isHr = false;
 rs.executeProc("HrmResource_SelectByID",id);
 rs.next();
 String departmentidtmp = Util.null2String(rs.getString("departmentid"));
 if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentidtmp)){
	  isHr = true;
	}
 if(!isHr){
	 response.sendRedirect("/notice/noright.jsp") ;
		return ;
 }
%>
<head>
  <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/checkinput.js"></script>
  <SCRIPT language="javascript" src="/js/weaver.js"></script>
  <SCRIPT language="javascript" src="/js/checknumber.js"></script>
<SCRIPT language="javascript">
function showAlert(msg){
    alert(msg);
}
function showConfirm(msg){
    return confirm(msg);
}
function checkPass(){
    saveBtn.disabled = true;
    document.resourcebasicinfo.submit() ;
}
</script>
</head>

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();

boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String ifinfo = Util.null2String(request.getParameter("ifinfo"));//检查loginid参数
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe id="checkHas" style="display:none"></iframe>
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
<FORM name=resourcebasicinfo id=resourcebasicinfo action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type=hidden name=operation >
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=isView value="<%=isView%>">
<TABLE class=ViewForm width="100%">
  <TBODY>
   <%
  String sql = "";
  sql = "select * from HrmResource where id = "+Util.getIntValue(id,-1);
  String lastname = "";
  String workcode = "";
  rs.executeSql(sql);
  if(rs.next()){
    workcode = Util.null2String(rs.getString("workcode"));
    lastname = Util.null2String(rs.getString("lastname"));
    String sex = Util.null2String(rs.getString("sex"));
    String photoid = Util.null2String(rs.getString("resourceimageid"));

	String departmentid = Util.null2String(rs.getString("departmentid"));
    String costcenterid = Util.null2String(rs.getString("costcenterid"));
    String jobtitle = Util.null2String(rs.getString("jobtitle"));
    String joblevel = Util.null2String(rs.getString("joblevel"));

    String jobactivitydesc = Util.null2String(rs.getString("jobactivitydesc"));
    String managerid = Util.null2String(rs.getString("managerid"));
    String assistantid = Util.null2String(rs.getString("assistantid"));
    String status = Util.null2String(rs.getString("status"));

    String locationid = Util.null2String(rs.getString("locationid"));
    String workroom = Util.null2String(rs.getString("workroom"));
    String telephone = Util.null2String(rs.getString("telephone"));
    String mobile = Util.null2String(rs.getString("mobile"));

    String mobilecall = Util.null2String(rs.getString("mobilecall"));
    String fax = Util.null2String(rs.getString("fax"));
    String jobcall = Util.null2String(rs.getString("jobcall"));
    String accounttype = Util.null2String(rs.getString("accounttype"));
    if(accounttype.equals(""))  accounttype="0";
    int systemlanguage = Util.getIntValue(rs.getString("systemlanguage"),7);
    List accounts=new VerifyLogin().getAccountsById(Integer.parseInt(id));
	if(accounts==null)
        accounts=new ArrayList();
    String majorId="";
    if(accounttype.equals("1")){
    Iterator iter=accounts.iterator();
    while(iter.hasNext()){
    Account major=(Account)iter.next();
    if(major.getType()==0){
    majorId=""+major.getId();
    break;
}
}
}
%>
<%
      if(ifinfo.equals("y")){
      %>
      <DIV>
     <font color=red size=2>
     <%=SystemEnv.getHtmlLabelName(22160,user.getLanguage())%>
      </div>
            <%}%>
  <TABLE class=ViewForm>
    <COLGROUP>
    <COL width="49%">
    <COL width=10>
    <COL width="49%">
    <TBODY>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%><TBODY>
          <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height:2px">
            <TD class=line1 colSpan=2></TD>
          </TR>

          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type=text name=workcode value="<%=workcode%>" onchange="this.value=trim(this.value)">
            </TD>
          </TR>
              <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle maxLength=30 size=30 name="lastname" value="<%=lastname%>" onchange='checkinput("lastname","lastnamespan");this.value=trim(this.value)'>
              <SPAN id=lastnamespan>
<%
  if(lastname.equals("")) {
%>
    <IMG src="/images/BacoError.gif" align=absMiddle>
<%
  }
%>
              </SPAN>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
         
          <%if(flagaccount){%>
		 <TR>
          <TD width="31%">
                              <%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%>
                              </TD>
                              <TD class=Field>
                                  <select class=inputstyle name=accounttype onchange="if(this.options[0].selected) {belongtodata.style.display='none';belongtoline.style.display='none';}else {belongtodata.style.display='';belongtoline.style.display='';}  ">
                                      <option <%if(accounttype.equals("0")){%>selected<%}%> value="0"><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></option>
                                      <option <%if(accounttype.equals("1")){%>selected<%}%> value="1"><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage())%></option>
                                  </select>

                              </td>
                            </TR>                                                                

                        <TR  style="height:1px"><TD class=Line colSpan=2></TD></TR>
			<%}%>
          <TR id=belongtodata <%if(accounttype.equals("0")){%>style="display:none"<%}%>>
            <TD><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></TD>
            <TD class=Field>

              <INPUT class="wuiBrowser" id=belongto type=hidden name=belongto value="<%=majorId%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			  _displayTemplate="<A href='HrmResource.jsp?id=#b{id}'>#b{name}</A>"
			  _displayText="<%=ResourceComInfo.getResourcename(majorId)%>"
			  _required="yes">
            </TD>
          </TR>
          <TR style="height:1px"><TD id=belongtoline class=Line colSpan=2  <%if(accounttype.equals("0")){%>style="display:none"><%}%></TD></TR>
          <TR>
          
            <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
            <TD class=Field>
              <select class=inputstyle name=sex value="<%=sex%>">
                <option value="0"<%if(sex.equals("0")){%>selected<%}%> > <%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
                <option value="1"<%if(sex.equals("1")){%>selected<%}%> > <%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
              </select>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD height=><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
            <TD class=Field >
                	<BUTTON type="button" class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
                    <SPAN id=departmentspan><%=DepartmentComInfo.getDepartmentname(departmentid)%><%if(departmentid.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></SPAN>
                    <input class=inputstyle type=hidden name=departmentid value="<%=departmentid%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<!--
<%if(software.equals("ALL") || software.equals("CRM") || software.equals("HRM")){%>
          <TR>
            <TD height=>成本中心</TD>
            <TD class=Field >
              <BUTTON class=Browser id=SelectCostcenter onclick="onShowCostcenter()"></BUTTON>
              <SPAN id=costcenterspan>
               <%=CostcenterComInfo.getCostCentername(costcenterid)%>
              </SPAN>
	          <input type=hidden name=costcenterid value="<%=costcenterid%>">
            </TD>
          </TR>
<%}else{%>
	          <input type=hidden name=costcenterid value="<%=costcenterid%>">
<%}%>
-->
<input class=inputstyle type=hidden name=costcenterid value="<%=costcenterid%>">
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
            <TD class=Field>
			  <BUTTON class=Browser id=SelectJobTitle onclick="onShowJobtitle()" type="button"></BUTTON>
              <SPAN id=jobtitlespan>
               <%=JobtitlesComInfo.getJobTitlesname(jobtitle)%><%if(jobtitle.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
              </SPAN>
              <input class=inputstyle type=hidden name=jobtitle value="<%=jobtitle%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></TD>
            <TD class=Field>
       
              <INPUT class="wuiBrowser" type=hidden name=jobcall value="<%=jobcall%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp"
			  _displayText="<%=JobCallComInfo.getJobCallname(jobcall)%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></td>
            <td class=Field>
	          <!-- input class=inputstyle type=text name=joblevel value="<%=joblevel%>"-->
	          <input class=InputStyle maxlength=3 size=5 name=joblevel value="<%=joblevel%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")'>
            </td>
          </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type=text name=jobactivitydesc value="<%=jobactivitydesc%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
	      <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></TD>
            <TD class=Field>
            
<%
 sql = "select lastname from HrmResource where id = "+Util.getIntValue(managerid,-1);
rs2.executeSql(sql);
while(rs2.next()){
%>


<%}%>
              
              <INPUT class="wuiBrowser" id=managerid type=hidden name=managerid value="<%=managerid%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			  _displayTemplate="<A target='_blank' href='HrmResource.jsp?id=#b{id}'>#b{name}</A>"
			  _displayText="<%=rs2.getString("lastname")%>" _required="yes">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD id=lblAss><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></TD>
             <TD class=Field id=txtAss>

<%
 sql = "select lastname from HrmResource where id = "+Util.getIntValue(assistantid,-1);
rs2.executeSql(sql);
while(rs2.next()){
%>         

<%}%>
              
              <INPUT class="wuiBrowser" id=assistantid type=hidden name=assistantid value="<%=assistantid%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			  _displayTemplate="<A target='_blank' href='HrmResource.jsp?id=#b{id}'>#b{name}</A>"
			  _displaText="<%=rs2.getString("lastname")%>">
            </TD>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
            <TD class=Field>
                  <%if(status.equals("0")){%><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%><%}%>
                  <%if(status.equals("1")){%><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%><%}%>
                  <%if(status.equals("2")){%><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%><%}%>
                  <%if(status.equals("3")){%><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%><%}%>
                  <%if(status.equals("4")){%><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%><%}%>
                  <%if(status.equals("5")){%><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><%}%>
                  <%if(status.equals("6")){%><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%><%}%>
                  <%if(status.equals("7")){%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%><%}%>
                  <%if(status.equals("10")){%><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%><%}%>
            </TD>
            <input class=inputstyle type=hidden name=status value="<%=status%>">
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD id=lblLocation><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></TD>
            <TD class=Field id=txtLocation>
             
              <INPUT class="wuiBrowser" id=locationid type=hidden name=locationid value="<%=locationid%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp"
			  _displayTemplate="<A target='_blank' href='/hrm/location/HrmLocationEdit.jsp?id=#b{id}'>#b{name}</A>"
			  _displayText="<%=LocationComInfo.getLocationname(locationid)%>"
			  _required="yes">
            </TD>
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td id=lblRoom><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></td>
            <td class=Field id=txtRoom>
              <input class=inputstyle type=text name=workroom value="<%=workroom%>">
            </td>
          </tr>
                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(661,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type=text name=telephone value="<%=telephone%>">
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type=text name=mobile value="<%=mobile%>">
            </TD>
          </TR>
                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type=text name=mobilecall value="<%=mobilecall%>">
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type=text name=fax value="<%=fax%>">
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<%if(isMultilanguageOK){%>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></TD>
            <TD class=Field>
              
              <INPUT class="wuiBrowser" type=hidden name=systemlanguage value="<%=systemlanguage%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp"
			  _displayText="<%=LanguageComInfo.getLanguagename(""+systemlanguage)%>">              </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<%}%>
<%
String datefield[] = new String[5] ;
String numberfield[] = new String[5] ;
String textfield[] = new String[5] ;
String tinyintfield[] = new String[5] ;
for(int k=1 ; k<6;k++) datefield[k-1] = rs.getString("datefield"+k) ;
for(int k=1 ; k<6;k++) numberfield[k-1] = rs.getString("numberfield"+k) ;
for(int k=1 ; k<6;k++) textfield[k-1] = rs.getString("textfield"+k) ;
for(int k=1 ; k<6;k++) tinyintfield[k-1] = rs.getString("tinyintfield"+k) ;

boolean hasFF = true;
rs2.executeProc("Base_FreeField_Select","hr");
if(rs2.getCounts()<=0)
	hasFF = false;
else
	rs2.first();

if(hasFF){
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+1).equals("1"))
		{%>
              <TR>
                <TD><%=rs2.getString(i*2)%></TD>
                <TD class=Field>
                    <button class=Calendar type="button" id=selectbepartydate onClick="getRSDate(span<%=i%>,datefield<%=(i-1)%>)"></button>
                    <span id=span<%=i%> ><%=datefield[i-1]%></span>
                    <input class=inputstyle type="hidden" name="datefield<%=(i-1)%>" value="<%=datefield[i-1]%>">
                </TD>
              </TR>
            <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+11).equals("1"))
		{%>
              <TR>
                <TD><%=rs2.getString(i*2+10)%></TD>
                <TD class=Field>
                    <input class=InputStyle  name="numberfield<%=(i-1)%>" value="<%=numberfield[i-1]%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numberfield<%=(i-1)%>")'>
                </TD>
              </TR>
             <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
              <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+21).equals("1"))
		{%>
              <TR>
                <TD><%=rs2.getString(i*2+20)%></TD>
                <TD class=Field>
                    <input class=InputStyle  name="textfield<%=(i-1)%>" value="<%=textfield[i-1]%>">
                </TD>
              </TR>
            <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
              <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+31).equals("1"))
		{%>
              <TR>
                <TD><%=rs2.getString(i*2+30)%></TD>
                <TD class=Field>
                  <INPUT class=inputstyle type=checkbox  name="tinyintfield<%=(i-1)%>" value="1" <%if(tinyintfield[i-1].equals("1")){%> checked <%}%> >
                </TD>
              </TR>
       <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
              <%}
	}
}

%>
          </TBODY>
        </TABLE>
                <TD width="1%"></TD>
        <TD vAlign=top width="49%">
        <table width="100%">
          <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TH>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
<%
  if(!photoid.equals("0")&&!photoid.equals("") ){
%>
          <TR class=Spacing style="height:2px">
            <TD class=Line1></TD>
           <TR>
            <TD >
              <img border=0 width=400 src="/weaver/weaver.file.FileDownload?fileid=<%=photoid%>">
            </TD>
          </TR>
          <input class=inputstyle type=hidden name=oldresourceimage value="<%=photoid%>">
          <tr>
           <td align=right>
            <BUTTON class=btnDelete accessKey=D onClick="delpic()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%></BUTTON>
           </td>
          </tr>
<%
}else{
%>
          <TR>
            <TD> <%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type=file name=photoid value="<%=photoid%>">
            </TD>
			
			<TD class=Field>(<%=SystemEnv.getHtmlLabelName(21130,user.getLanguage())%>:400*450)
			</TD>
         </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<%
}
%>
       </table>
<%
}
%>
     </td>
    </TR>
</table>
</TR>
  </FORM>
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

<script type="text/javascript">

function onShowJobtitle(){ 
	url=encode("/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="+jQuery("input[name=departmentid]").val()+"&fromPage=add");
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	if (data!=null){
		if (data.id != 0 ){
			jQuery("#jobtitlespan").html(data.name);
			jQuery("input[name=jobtitle]").val(data.id);
		}else{
			jQuery("#jobtitlespan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name=jobtitle]").val("");
		}
	}
}
function onShowDepartment(){
    url=encode("/hrm/company/DepartmentBrowser2.jsp?isedit=1&rightStr=HrmResourceEdit:Edit&selectedids="+resourcebasicinfo.departmentid.value);
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	 issame = false;
	 if(datas){
		  if(datas.id!= 0){
			   if(datas.id == resourcebasicinfo.departmentid.value){
			    	issame = true;
			   }
			   departmentspan.innerHTML = datas.name;
			   resourcebasicinfo.departmentid.value=datas.id;
		   }else{
			   departmentspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			   resourcebasicinfo.departmentid.value="";
		  }
		  if(!issame){
			  jobtitlespan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			  resourcebasicinfo.jobtitle.value="";
		  }
	 }
}
</script>

<script language=vbs>
sub onBelongto()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?from=add&sqlwhere=((accounttype is null or accounttype=0) and id<><%=id%>)")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	belongtospan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resourcebasicinfo.belongto.value=id(0)
	else
	belongtospan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resourcebasicinfo.belongto.value=""
	end if
	end if
end sub

sub onShowCostCenter()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="&resourcebasicinfodepartmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	costcenterspan.innerHtml = id(1)
	resourcebasicinfo.costcenterid.value=id(0)
	else
	costcenterspan.innerHtml = ""
	resourcebasicinfo.costcenterid.value=""
	end if
	end if
end sub
  sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resourcebasicinfo.managerid.value=id(0)
	else
	manageridspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resourcebasicinfo.managerid.value=""
	end if
	end if
end sub
sub onShowAssistantID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assistantidspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resourcebasicinfo.assistantid.value=id(0)
	else
	assistantidspan.innerHtml = ""
	resourcebasicinfo.assistantid.value=""
	end if
	end if
end sub

sub onShowJobcall()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobcallspan.innerHtml = id(1)
	resourcebasicinfo.jobcall.value=id(0)
	else
	jobcallspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resourcebasicinfo.jobcall.value=""
	end if
	end if
end sub

sub onShowLocationID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	locationidspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resourcebasicinfo.locationid.value=id(0)
	else
	locationidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resourcebasicinfo.locationid.value=""
	end if
	end if
end sub

sub onShowLanguage()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	systemlanguagespan.innerHtml = id(1)
	resourcebasicinfo.systemlanguage.value=id(0)
	else
	systemlanguagespan.innerHtml = ""
	resourcebasicinfo.systemlanguage.value=""
	end if
	end if
end sub
</script>
 <script language=javascript>
  var saveBtn;
  function encode(str){
       return escape(str);
    }        
function dosave(obj){
    saveBtn = obj;
  if(document.resourcebasicinfo.managerid.value==""&&!confirm("<%=SystemEnv.getHtmlLabelName(16072,user.getLanguage())%>")){
  }else{
  if(<%=flagaccount%>){
	  if(document.resourcebasicinfo.accounttype.value ==0){
	     if(document.resourcebasicinfo.departmentid.value==""||
     document.resourcebasicinfo.jobtitle.value==""||
     document.resourcebasicinfo.locationid.value==""){
     alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  }else{
    if(document.resourcebasicinfo.costcenterid.value=="")
      document.resourcebasicinfo.costcenterid.value=1;
    if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      document.resourcebasicinfo.operation.value = "editbasicinfo";
      if(document.all("lastname").value!="<%=lastname%>"&&document.all("workcode").value!="<%=workcode%>"){
        checkHas.location="HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value;
      }else if(document.all("workcode").value!="<%=workcode%>"){
        checkHas.location="HrmResourceCheck.jsp?workcode="+document.all("workcode").value;
      }else if(document.all("lastname").value!="<%=lastname%>"){
        checkHas.location="HrmResourceCheck.jsp?lastname="+document.all("lastname").value;
      }else{
        saveBtn.disabled = true;
        document.resourcebasicinfo.submit() ;
      }
    }
  }
	  }else{
	     if(document.resourcebasicinfo.departmentid.value==""||
     document.resourcebasicinfo.jobtitle.value==""||
	 document.resourcebasicinfo.belongto.value==""||
     document.resourcebasicinfo.locationid.value==""){
     alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  }else{
    if(document.resourcebasicinfo.costcenterid.value=="")
      document.resourcebasicinfo.costcenterid.value=1;
    if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      document.resourcebasicinfo.operation.value = "editbasicinfo";
      if(document.all("lastname").value!="<%=lastname%>"&&document.all("workcode").value!="<%=workcode%>"){
        checkHas.location="HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value;
      }else if(document.all("workcode").value!="<%=workcode%>"){
        checkHas.location="HrmResourceCheck.jsp?workcode="+document.all("workcode").value;
      }else if(document.all("lastname").value!="<%=lastname%>"){
        checkHas.location="HrmResourceCheck.jsp?lastname="+document.all("lastname").value;
      }else{
        saveBtn.disabled = true;
        document.resourcebasicinfo.submit() ;
      }
    }
  }
	  }}else{
	  if(document.resourcebasicinfo.departmentid.value==""||
     document.resourcebasicinfo.jobtitle.value==""||
     document.resourcebasicinfo.locationid.value==""){
     alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  }else{
    if(document.resourcebasicinfo.costcenterid.value=="")
      document.resourcebasicinfo.costcenterid.value=1;
    if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      document.resourcebasicinfo.operation.value = "editbasicinfo";
      if(document.all("lastname").value!="<%=lastname%>"&&document.all("workcode").value!="<%=workcode%>"){
        checkHas.location="HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value;
      }else if(document.all("workcode").value!="<%=workcode%>"){
        checkHas.location="HrmResourceCheck.jsp?workcode="+document.all("workcode").value;
      }else if(document.all("lastname").value!="<%=lastname%>"){
        checkHas.location="HrmResourceCheck.jsp?lastname="+document.all("lastname").value;
      }else{
        saveBtn.disabled = true;
        document.resourcebasicinfo.submit() ;
      }
    }
  }
	  }

  }
  }
 function delpic(){
      if(confirm("确定要删除此图片吗？")){
	  document.resourcebasicinfo.operation.value = "delpic";
	  document.resourcebasicinfo.submit();
       }
  }
  function viewBasicInfo(){
    if(<%=isView%> == 0){
      location = "/hrm/resource/HrmResourceBasicInfo.jsp?id=<%=id%>";
    }else{
      if('<%=isfromtab%>'=='true')
      	location = "/hrm/resource/HrmResourceBase.jsp?id=<%=id%>";
      else
      	location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
    }
  }

  function check_formM(thiswins,items)
{
	thiswin = thiswins
	items = ","+items + ",";
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	if(tmpname=="locationid"){
		if(tmpvalue == 0){
			alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
			return false;
		}
	}
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
		 alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>