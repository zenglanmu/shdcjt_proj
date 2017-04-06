<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.general.GCONST,
                 weaver.hrm.settings.RemindSettings" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<HTML>
<%
String id = request.getParameter("id");  
int hrmid = user.getUID();
int isView = Util.getIntValue(request.getParameter("isView"));
int departmentid = user.getUserDepartment();

boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
//get login verify mode,xiaofeng
String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
String loginid = "";
String password = "";
String systemlanguage = "";
String email = "";
String seclevel = "";
int status = 0 ;
//needed is a flag which indicate support of usb ,xiaofeng
String needed="" ;
String userUsbType="";
int needdynapass_usr=0;
int passwordstate = 1;//动态密码状态，默认为停止1。
int passwordlock = -1;
String tokenKey="";
if(mode!=null&&mode.equals("ldap"))
rs.executeSql("select account as loginid,password,systemlanguage,email,seclevel,status,needusb,tokenKey,userUsbType,needdynapass,passwordstate,passwordlock from HrmResource where id = "+id );
else
rs.executeSql("select loginid,password,systemlanguage,email,seclevel,status,needusb,tokenKey,userUsbType,needdynapass,passwordstate,passwordlock from HrmResource where id = "+id );
if(rs.next()){
    loginid = Util.null2String(rs.getString("loginid"));
    password = Util.null2String(rs.getString("password"));
    systemlanguage = Util.null2String(rs.getString("systemlanguage")); 
    email = Util.null2String(rs.getString("email")); 
    seclevel = Util.null2String(rs.getString("seclevel")); 
    status = Util.getIntValue(rs.getString("status"),0);
    needed=String.valueOf(rs.getInt("needusb"));
    userUsbType=Util.null2String(rs.getString("userUsbType"));
    needdynapass_usr=rs.getInt("needdynapass");
	passwordstate = rs.getInt("passwordstate");
	passwordlock = rs.getInt("passwordlock");
	tokenKey = Util.null2String(rs.getString("tokenKey")); 
	//System.out.println("00000000000000:"+passwordstate);
	if(passwordstate!=0&&passwordstate!=1&&passwordstate!=2) passwordstate =1;//修改passwordstate的值可实现更改默认状态。0，启动。1，停止。2，网段策略。
}
//Start 手机接口功能 by alan
String isMgmsUser = "";
rs.executeSql("SELECT userid FROM workflow_mgmsusers WHERE userid="+id);
if(rs.next()){
	isMgmsUser = "checked";
}
boolean EnableMobile = Util.null2String(Prop.getPropValue("mgms" , "mgms.on")).toUpperCase().equals("Y");
//End 手机接口功能

%>
<HEAD>
  <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(468,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
//get the settings about usb,xiaofeng
RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String openPasswordLock = settings.getOpenPasswordLock();
String passwordComplexity = settings.getPasswordComplexity();
String needusb=settings.getNeedusb();
String usbType=settings.getUsbType();
if(userUsbType.equals(""))
	userUsbType=usbType;

int needdynapass=settings.getNeeddynapass();

int detachable=0;
if(session.getAttribute("detachable")!=null){
    detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
}else{
    rs.executeSql("select detachable from SystemSet");
    if(rs.next()){
        detachable=rs.getInt("detachable");
        session.setAttribute("detachable",String.valueOf(detachable));
    }
}
int operatelevel=-1;
if(detachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Util.getIntValue(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}
//人力资源系统信息权限
int hrmoperatelevel=-1;
if(detachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
    hrmoperatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ResourcesInformationSystem:All",Util.getIntValue(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All", user))
        hrmoperatelevel=2;
}
int userid = user.getUID();
boolean isSelf		=	false;
boolean isSys = ResourceComInfo.isSysInfoView(userid,id);
if (id.equals(""+user.getUID()) ){
	isSelf = true;
}

if(!((isSelf||hrmoperatelevel>=0||isSys)&&HrmListValidate.isValidate(15))){
	response.sendRedirect("/notice/noright.jsp") ;
}

%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
if(iss || hrmoperatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(!isfromtab){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/TopTitle.jsp" %> 
<%
}
//xiaofeng
if(rs.getDBType().equals("db2")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(17591,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+89+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(17591,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+89+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
%>	

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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
<%if(!isfromtab) {%>
<TABLE class=Shadow>
<%}else{ %>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">
<FORM name=resourcesysteminfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<TABLE class=ViewForm>

	<TBODY> 
    <TR> 
      <TD vAlign=top> 
      <TABLE width="100%">
          <COLGROUP> <COL width=20%> <COL width=80%>
	      <TBODY> 
          <TR class=Title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height:2px">
            <TD class=Line1 colSpan=2></TD>
          </TR>	
          <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(16126,user.getLanguage())%></TD>
            <TD class=Field>
               <%=loginid%>           
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    	  <%
          if("1".equals(openPasswordLock))
          {
          %>
          <TR> 
            <TD >密码锁定</TD>
            <TD class=Field><input type=checkbox name=passwordlock value="<%=passwordlock %>" <%if(1==passwordlock){%>checked<%}%> disabled ></TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <%
          } 
          %>
              <%if(needusb!=null&&needusb.equals("1")){%>
    <TR>
            <TD ><%=SystemEnv.getHtmlLabelName(17593,user.getLanguage())%></TD>
            <TD class=Field>
              <input  type=checkbox name=needusb value=1 <%if(needed!=null&&needed.equals("1")){%>checked<%}%> disabled >
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <%if(needed.equals("1")){%>
    <tr id="serialtr5">
       <td>令牌类型</td>
       <td class=Field>
           <select onchange="changeshow(this);change(this)" name="userUsbType" id="userUsbType" disabled>
            <option value="1" <%if("1".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21588,user.getLanguage())%></option>
			<option value="2" <%if("2".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21589,user.getLanguage())%></option>
			<option value="3" <%if("3".equals(userUsbType)){%>selected<%}%> >动态令牌</option>
           </select>
       </td>
    </tr>
    <TR id="serialtr6" style="height:1px;"><TD class=Line colSpan=2></TD></TR>
    <%}%>
    
    <%if(needed.equals("1")&&"3".equals(userUsbType)){%>
    <TR>
            <TD >令牌序列号</TD>
            <TD class=Field>
              <%=tokenKey%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <%} %>
    <%}%> 
              <%if (needdynapass==1) {%>
              <TR>
                  <TD><%=SystemEnv.getHtmlLabelName(20286, user.getLanguage())%>
                  </TD>
                  <TD class=Field>
					<%if(passwordstate ==0){%><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%}%>         
					<%if(passwordstate ==1){%><%=SystemEnv.getHtmlLabelName(17581,user.getLanguage())%><%}%>
					<%if(passwordstate ==2){%><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%><%}%>
                  </TD>
              </TR>
              <TR style="height:1px">
                  <TD class=Line colSpan=2></TD>
              </TR>
              <%}%>
             
<!--	      <TR> 
            <TD class=Field>密码</TD>
            <TD class=Field> 
              
            </TD>
          </TR>
-->
<%if(isMultilanguageOK){%>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></TD>
            <TD class=Field>
              <%=LanguageComInfo.getLanguagename(systemlanguage)%>               
            </TD>
          </TR>	   
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<%}%>
          <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=email%>
            </TD>
          </TR>	    
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=seclevel%>
            </TD>
          </TR>	    
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <%if(EnableMobile){%>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(23996,user.getLanguage())%></td>
			<td class=Field><input type=checkbox name="isMgmsUser" value="<%=id%>" <%=isMgmsUser%> disabled></td>
		</tr>
		<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
	<%}%>
    
 	      </tbody>
       </table>
   </tr>
</table>
</form>
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
  function edit(){    
    location = "/hrm/resource/HrmResourceSystemEdit.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function viewBasicInfo(){    
    if(<%=isView%> == 0){
      //location = "/hrm/resource/HrmResourceBasicInfo.jsp?id=<%=id%>";
      location = "/hrm/employee/EmployeeManage.jsp?hrmid=<%=id%>";
    }else{
      location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
    }  
  }
  function viewPersonalInfo(){    
    location = "/hrm/resource/HrmResourcePersonalView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewWorkInfo(){    
    location = "/hrm/resource/HrmResourceWorkView.jsp?id=<%=id%>&isView=<%=isView%>";
  }  
  function viewFinanceInfo(){    
    location = "/hrm/resource/HrmResourceFinanceView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewCapitalInfo(){
    location = "/cpt/search/CptMyCapital.jsp?id=<%=id%>";
  }
</script> 

</BODY>
</HTML>
