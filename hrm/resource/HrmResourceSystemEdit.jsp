            <%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
            <%@ page import="weaver.general.Util,
                             weaver.file.Prop,
                             weaver.general.GCONST,
                             weaver.hrm.settings.RemindSettings" %>
            <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
            <jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
            <jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
            <jsp:useBean id="ln" class="ln.LN" scope="page" />
            <jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
			<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
             <html>
            <%
            //xiaofeng usb setting
            RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
            String openPasswordLock = settings.getOpenPasswordLock();
        	String passwordComplexity = settings.getPasswordComplexity();
            String usb_enable=settings.getNeedusb();
            String firmcode=settings.getFirmcode();
            String usercode=settings.getUsercode();
			String usbType=settings.getUsbType();
            String needed="0";
            String userUsbType="";
            //String needdynapass="0";
			int needdynapass= 0;//是否使用动态密码
			String passwordstate= "1";//动态密码状态，默认为停止
            int dynapass_enable=settings.getNeeddynapass();
            int minpasslen=settings.getMinPasslen();  

            String id = request.getParameter("id");
            int hrmid = user.getUID();
            boolean ishe = (hrmid == Util.getIntValue(id));
            String isView = request.getParameter("isView");
            boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
            String account="";
            String loginid = "";
            String password = "qwertyuiop";
            int systemlanguage = 7;
            String email = "";
            String seclevel = "";
			String serial = "";
			String tokenKey="";
            //xiaofeng
            String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
            
            boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
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
            int hrmoperatelevel=-1;
            if(detachable==1){
                String deptid=ResourceComInfo.getDepartmentID(id);
                String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
                hrmoperatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ResourcesInformationSystem:All",Util.getIntValue(subcompanyid));
            }else{
                if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All", user))
                    hrmoperatelevel=2;
            }
            if(!(iss || hrmoperatelevel>0)){
            	response.sendRedirect("/notice/noright.jsp") ;
            }
			//Start 手机接口功能 by alan
            String isMgmsUser = "";
            rs.executeSql("SELECT userid FROM workflow_mgmsusers WHERE userid="+id);
            if(rs.next()){
            	isMgmsUser = "checked";
            }
            boolean EnableMobile = Util.null2String(Prop.getPropValue("mgms" , "mgms.on")).toUpperCase().equals("Y");
            //End 手机接口功能

			String mainDactylogramImgSrc="/images/loginmode/5.gif";
			String assistantDactylogramImgSrc="/images/loginmode/5.gif";
			String mainDactylogram = "";
			String assistantDactylogram = "";
			int passwordlock = -1;
            rs.executeSql("select account,loginid,systemlanguage,email,seclevel,needusb,needdynapass,passwordstate,passwordlock,serial,dactylogram,assistantdactylogram,tokenKey,userUsbType from HrmResource where id = "+id );


            if(rs.next()){
                account = Util.null2String(rs.getString("account"));
                loginid = Util.null2String(rs.getString("loginid"));
                systemlanguage = Util.getIntValue(rs.getString("systemlanguage"),7);
                email = Util.null2String(rs.getString("email"));
                seclevel = Util.null2String(rs.getString("seclevel"));
                needed=String.valueOf(rs.getInt("needusb"));
                userUsbType=Util.null2String(rs.getString("userUsbType"));
                if(userUsbType.equals("")){
                	userUsbType=usbType;     //将原来启用状态的用户赋值为默认usb类型	
                }
				serial = Util.null2String(rs.getString("serial"));
				tokenKey = Util.null2String(rs.getString("tokenKey"));
                //needdynapass=String.valueOf(rs.getInt("needdynapass"));
				needdynapass=rs.getInt("needdynapass");
				passwordstate=String.valueOf(rs.getInt("passwordstate"));
				passwordlock = rs.getInt("passwordlock");
				//System.out.println("-=-=-=-=-=:"+passwordstate);
				if(!passwordstate.equals("0")&&!passwordstate.equals("1")&&!passwordstate.equals("2")) passwordstate ="1";//修改passwordstate的值可实现更改默认状态,0，启动。1，停止。2，网段策略。
				
	mainDactylogram = Util.null2String(rs.getString("dactylogram"));
	assistantDactylogram = Util.null2String(rs.getString("assistantdactylogram"));
	mainDactylogramImgSrc = (mainDactylogram.equals(""))?"/images/loginmode/5.gif":"/images/loginmode/4.gif";
	assistantDactylogramImgSrc = (assistantDactylogram.equals(""))?"/images/loginmode/5.gif":"/images/loginmode/4.gif";
            }
            //xiaofeng
            if(loginid.equals(""))
            password="";//默认值

            boolean canSave = false;
            int ckHrmnum = ln.CkHrmnum();
            if(ckHrmnum < 0){//只有License检查人数小于规定人数，才能修改。防止客户直接修改数据库数据
            	canSave = true;
            }else if(ckHrmnum==0 && !loginid.trim().equals("")){
            	canSave = true;//如果正好license人数到头，而且当前的登录名是空，那么就不让修改登录名
            }
			//TD8617
			boolean isright = false;
			int userid=user.getUID();
				if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All", user)){
				isright = true;
				}
            %>

            <head>


                 <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
                <SCRIPT language="javascript" src="/js/weaver.js"></script>


            </head>
             <%
            String imagefilename = "/images/hdMaintenance.gif";
            String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(468,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
            String needfav ="1";
            String needhelp ="";

            %>
            <body>

            <script src="/js/ComboBox.js"></script>


            <%@ include file="/systeminfo/TopTitle.jsp" %>
            <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
            <%
            if(canSave&&isright){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:edit(this),_self} " ;
            RCMenuHeight += RCMenuHeightStep ;
            }
            RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewSystemInfo(),_self} " ;
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
            <TABLE class=Shadow>
            <tr>
            <td valign="top">
            <FORM name=resourcesysteminfo id=resourcesysteminfo action="HrmResourceOperation.jsp" method=post >
            <input class=inputstyle type=hidden name=operation>
            <input class=inputstyle type=hidden name=id value="<%=id%>">
            <input class=inputstyle type=hidden name=isView value="<%=isView%>">
			<input class=inputstyle type=hidden name=username value="<%=account%>" />
			<input class=inputstyle type=hidden name=isfromtab value="<%=isfromtab%>">
			<%if("1".equals(usbType)){%>
			<input class=inputstyle type=hidden name=serial />
			<%}%>
            <input class=inputstyle type=hidden name=old_needed value="<%=needed%>" >
            <%
            String errmsg = Util.null2String(request.getParameter("errmsg"));
            if(errmsg.equals("1")){
            %>
            <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(16128,user.getLanguage())%>
            </div>
            <%}%>
            <%
            if(!canSave){
            %>
            <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(16129,user.getLanguage())%>
            </div>
            <%}%>
            <TABLE class=viewForm>

            	<TBODY>
                <TR>
                  <TD vAlign=top>
                  <TABLE width="100%">
                      <COLGROUP>
                <COL width=20%>
                <COL width=80%>
            	      <TBODY>
                      <TR class=title>
                        <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%></TH>
                      </TR>
                      <TR class=spacing>
                        <TD class=Sep1 colSpan=2></TD>
                      </TR>
					  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                      <TR>
                        <TD><%=SystemEnv.getHtmlLabelName(16126,user.getLanguage())%></TD>
                        <TD id=tloginid class=Field valign="top">
            <%
               if(ishe){
            %>         <%=loginid%>
                       <input class=inputstyle type=hidden name=loginid value="<%=loginid%>">
            <%
            }else{
              if(mode==null||!mode.equals("ldap")){%>
                        <input class=inputstyle type=text name=loginid value="<%=loginid%>" <%if(!canSave){%> disabled <%}%> >
                        <input type=hidden name=account value="<%=account%>" <%if(!canSave){%> disabled <%}%> >
            <%
               }else{String filter = Util.null2String(request.getParameter("filter"));
                      weaver.ldap.LdapUtil util = weaver.ldap.LdapUtil.getInstance();
                      filter = filter.equals("") ? "*" : filter;
                      List l = util.getAccounts(filter);
                      Iterator iter = l.iterator();
            %>

                     <input type=hidden name=loginid value="<%=loginid%>" <%if(!canSave){%> disabled <%}%> >
                               <script>

                                           account=new ComboBox("account",tloginid)  ;
                                           account.className="inputstyle";

                               <% while (iter.hasNext()) {String tmp=(String)iter.next();%>
                                           account.add(new ComboBoxItem("<%=tmp%>"));
                               <%}%>
                                          document.resourcesysteminfo.accounttxt.value= "<%=account%>";


                               </script>





            <%}
            }
            %>

                        </TD>
                      </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                      <%
                      if("1".equals(openPasswordLock))
                      {
                      %>
                      <TR> 
			            <TD ><%=SystemEnv.getHtmlLabelName(24706,user.getLanguage())%></TD>
			            <TD class=Field>
			               <input type="checkbox" name="passwordlock" value="<%=passwordlock %>" <%if(1==passwordlock){%>checked<%}%> onclick="setPasswordLock(this);">        
			            </TD>
			          </TR>
			          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
			          <%
			          } 
			          %>
                      <%if(mode==null||!mode.equals("ldap")){%>

            	      <TR>
                        <TD ><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></TD>
                        <TD class=Field>
                          <input class=inputstyle type=password name=password value="<%=password%>" <%if(!canSave){%> disabled <%}%> >

                        </TD>
                      </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>

            	      <TR>
                        <TD ><%=SystemEnv.getHtmlLabelName(16127,user.getLanguage())%></TD>
                        <TD class=Field>
                          <input class=inputstyle type=password name=passwordconfirm value="<%=password%>" <%if(!canSave){%> disabled <%}%> >

                        </TD>
                      </TR>

                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                      <%}else{%>
                      <input type=hidden name=password value="<%=password%>" <%if(!canSave){%> disabled <%}%> >
                      <%}
                      if(usb_enable!=null&&usb_enable.equals("1")){%>
                      <TR>
                        <TD ><%=SystemEnv.getHtmlLabelName(17593,user.getLanguage())%></TD>
                        <TD class=Field>
                          <input type="checkbox" id="needusb" name="needusb" value="1" onclick="chooseUsb(this);" <%if(needed!=null&&needed.equals("1")){%>checked<%}%>  <%if(!canSave){%> disabled <%}%>>
                        </TD>
                      </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                      <%
                         String t_style = "none";
                         if(needed!=null&&needed.equals("1"))
                        	t_style="";
                      %>
                      <tr id="serialtr5" style="display:<%=t_style%>">
                         <td>令牌类型</td>
                         <td class=Field>
                             <select onchange="changeshow(this);change(this)" name="userUsbType" id="userUsbType" <%if(!canSave){%> disabled <%}%>>
	                             <option value="1" <%if("1".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21588,user.getLanguage())%></option>
								 <option value="2" <%if("2".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21589,user.getLanguage())%></option>
								 <option value="3" <%if("3".equals(userUsbType)){%>selected<%}%> >动态令牌</option>
                             </select>
                             <button type="button" class=btn  id="changeUsb" onclick="updateKey()" style="display:<%="0".equals(needed)||"3".equals(userUsbType)?"none":""%>;width:75px;margin-left:10px;" <%if(!canSave){%> disabled <%}%>>
                              <%=("2".equals(userUsbType)&&serial.equals(""))?"绑定令牌":"更换令牌"%>
                             </button>
                         </td>
                      </tr>
					  <TR id="serialtr6" style="height:1px;display:<%=t_style%>"><TD class=Line colSpan=2></TD></TR>
					<%
					      t_style = "none";
						  if(needed!=null&&needed.equals("1")&&userUsbType.equals("2")){
							t_style = "";
						  }else{
							  //serial = "";
						  }
						  %>
                      <TR id=serialtr1 style="display:<%=t_style%>">
                        <TD ><%=SystemEnv.getHtmlLabelName(21597,user.getLanguage())%></TD>
                        <TD class=Field>
							<input class="inputstyle" type="text" maxlength="32" size="32" id="serial" name="serial" temptitle="<%=SystemEnv.getHtmlLabelName(21597,user.getLanguage())%>" value="<%=serial%>" onchange="checkinput('serial','serialspan')" <%if(!canSave){%> disabled <%}%>>
							<span id="serialspan"><%if("".equals(serial)&&canSave){%><IMG src="/images/BacoError.gif" align="absMiddle"><%}%></span>
                        </TD>
                      </TR>
                      <TR id=serialtr2 style="display:<%=t_style%>"><TD class=Line colSpan=2></TD></TR>
					
					<%
						  t_style = "none";
						  if(needed!=null&&needed.equals("1")&&userUsbType.equals("3")){
							t_style = "";
						  }else{
							  //serial = "";
						  }
						  %>
                      <TR id=serialtr3 style="display:<%=t_style%>">
                        <TD >令牌序列号</TD>
                        <TD class=Field>
							<input class="inputstyle" type="text" id="tokenKey" name="tokenKey" temptitle="令牌串号" value="<%=tokenKey%>" onblur="checkTokenKey()" maxlength="10">
                        </TD>
                      </TR>
                      <TR id=serialtr4 style="display:<%=t_style%>;height:1px;"><TD class=Line colSpan=2></TD></TR>
					
					
                      <%}
                      if(dynapass_enable==1){%>
                      <TR>
						<TD ><%=SystemEnv.getHtmlLabelName(20286,user.getLanguage())%></TD>
                        <TD class=Field>
                          <select class=inputstyle name=passwordstate >
						  <option value=0 <%if(passwordstate.equals("0")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
						  <option value=1 <%if(passwordstate.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(17581,user.getLanguage())%></option>
						  <option value=2 <%if(passwordstate.equals("2")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></option>

						</select>
                      </TR>

                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                      <%}%>
            <%if(isMultilanguageOK){%>
            	      <TR>
                        <TD ><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></TD>
                        <TD class=Field>
                          
                          <input class="wuiBrowser" type=hidden name=systemlanguage value="<%=systemlanguage%>"
						  _url="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp"
						  _displayText="<%=LanguageComInfo.getLanguagename(""+systemlanguage)%>">
                        </TD>
                      </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
            <%}%>

                      <TR>
                        <TD ><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
                        <TD class=Field>
                        <input class=inputstyle type=text name=email value="<%=email%>" <%if(!canSave){%> disabled <%}%>>
                        </TD>
                      </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                      <TR>
                        <TD ><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
                        <TD class=Field>
            <%
               if(ishe){
            %>         <%=seclevel%>
                       <input class=inputstyle type=hidden name=seclevel value="<%=seclevel%>" >
            <%
            }else{
            %>
                        <input class=inputStyle maxlength=3  size=5 name=seclevel value="<%=seclevel%>" onblur="checkSeclevel(this)"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("seclevel");' <%if(!canSave){%> disabled <%}%>>
            <%
            }
            %>
                        </TD>
                      </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                      <%if(GCONST.getONDACTYLOGRAM()){%>
                      <TR>
                      	<td valign="top"><%=SystemEnv.getHtmlLabelName(22143,user.getLanguage())%><br><font color="red">(<%=SystemEnv.getHtmlLabelName(22144,user.getLanguage())%>)</font></td>
                      	<td class=Field>
													<table width="100%">
											  		<COLGROUP>
											  		<COL width="10%">
											  		<COL width="10%">
											 			<COL width="80%">
														<tr>
															<td valign="top"><%=SystemEnv.getHtmlLabelName(22145,user.getLanguage())%></td>
															<td valign="top"><%=SystemEnv.getHtmlLabelName(22146,user.getLanguage())%><td>
															<td></td>
														</tr>
														<tr>
															<td align="left"><a style="cursor:hand" onclick="FingerEnroll('maindactylogram')"><img width=80 height=100 src="<%=mainDactylogramImgSrc%>" align="absmiddle" border="0"></a></td>
															<td align="left"><a style="cursor:hand" onclick="FingerEnroll('assistantdactylogram')"><img width=80 height=100 src="<%=assistantDactylogramImgSrc%>" align="absmiddle" border="0"></a></td>
															<td></td>
														</tr>
														<tr>
															<td valign="top"><%if(!mainDactylogram.equals("")){%><a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="delDactylogram('maindactylogram')"><font color="red"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22145,user.getLanguage())%></font></a><%}%></td>
															<td valign="top"><%if(!assistantDactylogram.equals("")){%><a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="delDactylogram('assistantdactylogram')"><font color="red"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22146,user.getLanguage())%></font></a><%}%><td>
															<td></td>
														</tr>
															<input type="hidden" id="maindactylogram" name="maindactylogram" value="">
															<input type="hidden" id="assistantdactylogram" name="assistantdactylogram" value="">
															<input type="hidden" id="topage" name="topage" value="HrmResourceSystemEdit.jsp">
													</table>
													
												</td>
                      </TR>
                      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                      <%}%>
                      <%if(EnableMobile){%>
	                      <tr>
						  	<td><%=SystemEnv.getHtmlLabelName(23996,user.getLanguage())%></td>
						  	<td><input type=checkbox name="isMgmsUser" value="<%=id%>" <%=isMgmsUser%>></td>
						  </tr>
						  <TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
					  <%}else{ %>
							<input type=hidden name="isMgmsUser" value="<%if(isMgmsUser.equals("checked"))out.println(id);%>">
					  <%} %>
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
            <%if(GCONST.getONDACTYLOGRAM()){%>
            <object classid="clsid:1E6F2249-59F1-456B-B7E2-DD9F5AE75140" width="1" height="1" id="dtm" codebase="WellcomJZT998.ocx"></object>
            <%}%>
            <script language=vbs>
            sub onShowLanguage()
            	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp")
            	if (Not IsEmpty(id)) then
            	if id(0)<> 0 then
            	systemlanguagespan.innerHtml = id(1)
            	resourcesysteminfo.systemlanguage.value=id(0)
            	else
            	systemlanguagespan.innerHtml = ""
            	resourcesysteminfo.systemlanguage.value=""
            	end if
            	end if
            end sub


            </script>
            <script language=javascript>

function chkMail(){
if(document.resourcesysteminfo.email.value == ''){
return true;
}

var email = document.resourcesysteminfo.email.value;
var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
chkFlag = pattern.test(email);
if(chkFlag){
return true;
}
else
{
alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
document.resourcesysteminfo.email.focus();
return false;
}
}

function CheckPasswordComplexity()
{
	var ocs = "<%=password%>";
	var cs = document.resourcesysteminfo.passwordconfirm.value;
	//alert(cs);
	var checkpass = true;
	<%
	if("1".equals(passwordComplexity))
	{		
	%>
	var complexity11 = /[a-z]+/;
	var complexity12 = /[A-Z]+/;
	var complexity13 = /\d+/;
	if(cs!=""&&ocs!=cs)
	{
		if(complexity11.test(cs)&&complexity12.test(cs)&&complexity13.test(cs))
		{
			checkpass = true;
		}
		else
		{
			alert("新密码不符合要求,必须为字母大写、字母小写、数字组合！请重新输入！");
			checkpass = false;
		}
	}
	<%
	}
	else if("2".equals(passwordComplexity))
	{
	%>
	var complexity21 = /[a-zA-Z_]+/;
	var complexity22 = /\W+/;
	var complexity23 = /\d+/;
	if(cs!=""&&ocs!=cs)
	{
		if(complexity21.test(cs)&&complexity22.test(cs)&&complexity23.test(cs))
		{
			checkpass = true;
		}
		else
		{
			alert("新密码不符合要求，必须为字母、数字、特殊字符组合！请重新输入！");
			checkpass = false;
		}
	}
	<%
	}
	%>
	return checkpass;
}

function setPasswordLock(o)
{
	
	if(o.checked)
	{
		o.value = 1;
	}
	else
	{
		o.value = -1;
	}
}

var openStatus = 0;
function OpenDevice()
{
    dtm.DataType = 0;
    iRet = dtm.EnumerateDevicesSimple();
    if(iRet == 0)
    {
        devInfo = dtm.strInfo;
        devNum = devInfo.split(",")[1];
        iRet = dtm.OpenDevice(devNum);
        if(iRet == 0)
        {
            openStatus = 1;
        }
    }
}
function CloseDevice()
{
    iRet = dtm.CloseDevice();
}     	
//--------------------------------------------------------------//
// 登记指纹模板
//--------------------------------------------------------------//
function FingerEnroll(hiddenname){
	OpenDevice();
	if(openStatus==1){
		dtm.InputParam = "";
		iRet = dtm.EnrollSimple();
		if(iRet != 0){
			alert("<%=SystemEnv.getHtmlLabelName(22147,user.getLanguage())%>");
		}else{
	  	$GetEle(hiddenname).value=dtm.strInfo;
	  	document.resourcesysteminfo.operation.value=hiddenname;
	  	document.resourcesysteminfo.submit();
		}
		CloseDevice();
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(22148,user.getLanguage())%>");
	}
}
function delDactylogram(hiddenname){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
  	document.resourcesysteminfo.operation.value=hiddenname;
  	document.resourcesysteminfo.submit();
	}
}
            	
              function edit(obj){
                  
                  if("1"=="<%=usb_enable%>"&&jQuery("#needusb").attr("checked")){
                     if(!change(jQuery("#userUsbType")[0]))
                        return false;
                  }
                  var needusbcheck = false;
                  var userUsbType=jQuery("#userUsbType").val(); 
                  var mode="<%=mode%>";
				  var needpwdcheck = true;
				  if(mode!="null" && mode=="ldap")
					needpwdcheck = false;
				
				
				if("1"=="<%=usb_enable%>"&&"2"==userUsbType&&jQuery("#needusb").length>0){
				     needusbcheck = $GetEle("needusb").checked;
				}
				
				if(!chkMail()) return false;
				
				if(document.resourcesysteminfo.password.value!="qwertyuiop" && 
							document.resourcesysteminfo.password.value.length<<%=minpasslen%> && needpwdcheck){
                     alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");   
                     return ;                
                  }
              //modify by xiaofeng, for td1458
              if((mode=="null"||mode!="ldap")&&"2"!=userUsbType){ 
               
              if($GetEle("loginid").value.indexOf(" ")!=-1 || $GetEle("loginid").value.indexOf(";")!=-1 || $GetEle("loginid").value.indexOf("--")!=-1 
            		 || $GetEle("loginid").value.indexOf("'")!=-1){
            	  alert("<%=Util.toScreenForJs(SystemEnv.getHtmlLabelName(24752,user.getLanguage()))%>"); 
            	  return;
                  }
              else if(document.resourcesysteminfo.password.value!="qwertyuiop"&&document.resourcesysteminfo.password.value.length<<%=minpasslen%>){
                     alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");                   
                  }else if(document.resourcesysteminfo.password.value == document.resourcesysteminfo.passwordconfirm.value ){
						if(needusbcheck==false || (needusbcheck==true && ((userUsbType=="2"&&check_form(document.resourcesysteminfo, "serial"))) )){
							document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
		                    document.resourcesysteminfo.submit() ;
		                    obj.disabled=true;
						}
                  }else{
                    alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
                  }
                 }else if(!(mode=="null"||mode!="ldap")&&"2"!=userUsbType){
                  if(isValid(document.resourcesysteminfo.accounttxt.value)){
                    document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
						if(needusbcheck==false || (needusbcheck==true && ((userUsbType=="2"&&check_form(document.resourcesysteminfo, "serial"))) )){
		                    document.resourcesysteminfo.submit() ;
		                    obj.disabled=true;
						}
              }else{
                      alert("无效的帐号!!!请从列表中选择。")
                   }
                  }else if(!(mode=="null"||mode!="ldap")&&"2"==userUsbType){
					  if(isValid(document.resourcesysteminfo.accounttxt.value)){
					   <%if(usb_enable!=null&&usb_enable.equals("1")){%>
							if(document.resourcesysteminfo.loginid.value == null || document.resourcesysteminfo.loginid.value == '' || document.resourcesysteminfo.loginid.value == document.resourcesysteminfo.username.value || document.resourcesysteminfo.needusb.checked==false){
								if(needusbcheck==false || (needusbcheck==true && (("<%=usbType%>"=="2"&&check_form(document.resourcesysteminfo, "serial"))) )){
									document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
				                    document.resourcesysteminfo.submit() ;
				                    obj.disabled=true;
								}
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21606,user.getLanguage())%>");
							}
						<%}else{%>
						if(needusbcheck==false || (needusbcheck==true && (("<%=usbType%>"=="2"&&check_form(document.resourcesysteminfo, "serial"))) )){
								document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
			                    document.resourcesysteminfo.submit() ;
			                    obj.disabled=true;
							}
						<%}%>
						}else{
						  alert("无效的帐号!!!请从列表中选择。")
					   }
					}else{
						<%if(usb_enable!=null&&usb_enable.equals("1")){%>
						if($GetEle("loginid").value.indexOf(" ")!=-1 || $GetEle("loginid").value.indexOf(";")!=-1 || $GetEle("loginid").value.indexOf("--")!=-1 
			            		 || $GetEle("loginid").value.indexOf("'")!=-1){
			            	  alert("<%=Util.toScreenForJs(SystemEnv.getHtmlLabelName(24752,user.getLanguage()))%>"); 
			            	  return;
			                  }
						if(document.resourcesysteminfo.password.value == document.resourcesysteminfo.passwordconfirm.value){
						if(document.resourcesysteminfo.loginid.value == null || document.resourcesysteminfo.loginid.value == '' || document.resourcesysteminfo.loginid.value == document.resourcesysteminfo.username.value || document.resourcesysteminfo.needusb.checked==false){
							document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
							var checkpass = CheckPasswordComplexity();
							if(checkpass)
							{
								if(needusbcheck==false || (needusbcheck==true && ((userUsbType=="2"&&check_form(document.resourcesysteminfo, "serial"))) )){
				                    document.resourcesysteminfo.submit() ;
				                    obj.disabled=true;
								}
							}
						}else{
							alert("<%=SystemEnv.getHtmlLabelName(21606,user.getLanguage())%>");
						}
						}else{
							alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
						}
						<%}else{%>
						if($GetEle("loginid").value.indexOf(" ")!=-1 || $GetEle("loginid").value.indexOf(";")!=-1 || $GetEle("loginid").value.indexOf("--")!=-1 
			            		 || $GetEle("loginid").value.indexOf("'")!=-1){
			            	  alert("<%=Util.toScreenForJs(SystemEnv.getHtmlLabelName(24752,user.getLanguage()))%>"); 
			            	  return;
			                  }
							if(document.resourcesysteminfo.password.value == document.resourcesysteminfo.passwordconfirm.value){
								document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
								var checkpass = CheckPasswordComplexity();
								if(checkpass)
								{
									if(needusbcheck==false || (needusbcheck==true && ((userUsbType=="2"&&check_form(document.resourcesysteminfo, "serial"))) )){
					                    document.resourcesysteminfo.submit() ;
					                    obj.disabled=true;
									}
								}
							}else{
								alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
							}
							
						<%}%>
					}
              }
 
              function isValid(a){
                 for(i=0;i<account.options.length;i++){
                     if(a==account.options[i].text)
                             return true;
                 }
                  return false;
              }
              function viewSystemInfo(){
                location = "/hrm/resource/HrmResourceSystemView.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
              }
			  function changeshow(obj){
			    var needusbcheck=jQuery("#needusb").attr("checked");
				if(obj.value=="2"&&needusbcheck){
					serialtr1.style.display="";
					serialtr2.style.display="";
					
					serialtr3.style.display="none";
					serialtr4.style.display="none";
				}else if(obj.value=="3"&&needusbcheck){
					serialtr1.style.display="none";
					serialtr2.style.display="none";
					
					serialtr3.style.display="";
					serialtr4.style.display="";
				}else{
				    serialtr1.style.display="none";
					serialtr2.style.display="none";
					serialtr3.style.display="none";
					serialtr4.style.display="none";
				}
				
				if(obj.value=="0")
				   jQuery("#changeUsb").hide();
				else if(obj.value=="1"){
				   jQuery("#changeUsb").show();
				   jQuery("#changeUsb").html("更换令牌");      
				}else if(obj.value=="2"){
				   jQuery("#changeUsb").show();
				   if("<%=serial%>"=="")
				       jQuery("#changeUsb").html("绑定令牌");  
				   else
				      jQuery("#changeUsb").html("更换令牌");      
				      
				}else if(obj.value=="3"){      
				   jQuery("#changeUsb").hide();      
				}   
			  }
			  
			  function change(obj){
			    if(jQuery("#needusb").attr("checked")&&obj.value!="3"){
			      if(obj.value=="1")
			           return change1(obj);
			      else if(obj.value=="2")
			           return change2(obj);    
			    }else
			         return true;      
			  }
			  
			  function checkSeclevel(obj){
			   if(obj.value!=""&&(isNaN(obj.value)||parseInt(obj.value)<0))
			      obj.value="0";
			  }
			  
			  
			  </script>
             <%if(usb_enable!=null&&usb_enable.equals("1")){%>
			<script language=javascript>
			    
			    function updateKey(){
			        var needusb=jQuery("#userUsbType").val();
			        if(needusb=="1")
			            updateKey1();
			        else if(needusb=="2")   
			            updateKey2();
			        else if(needusb=="3")
			            bindTokenKey();    
			            
			    }
			
			
				function updateKey1(){
				  /*
				  if(!resourcesysteminfo.needusb.checked==true){
					alert('该用户不是需要加强安全性的用户')
				  return
				  }
				 */ 
              try{
                wk = new ActiveXObject("WIBUKEY.WIBUKEY")
                wk.FirmCode = <%=firmcode%>
                wk.UserCode = <%=usercode%>
                wk.UsedSubsystems = 1
                wk.AccessSubSystem()
                if(wk.LastErrorCode==17){
                  alert('<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>')
                  return
                  }
                else if(wk.LastErrorCode>0){
                  throw new Error(wk.LastErrorCode)
                  }
                wk.UsedWibuBox.MoveFirst()
                resourcesysteminfo.serial.value=wk.UsedWibuBox.SerialText
                alert(resourcesysteminfo.serial.value);
                alert('按保存之后该用户的usb令牌将被更新')
                }catch(err){
                  alert('<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>')
                  return
                }
             }

             function change1(obj){
             //if(obj.checked==true){
             try{
                wk = new ActiveXObject("WIBUKEY.WIBUKEY")
                wk.FirmCode = <%=firmcode%>
                wk.UserCode = <%=usercode%>
                wk.UsedSubsystems = 1
                wk.AccessSubSystem()
                if(wk.LastErrorCode==17){
                  alert('<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>')
                  //obj.checked=false
                  
                  return false;
                  }
                else if(wk.LastErrorCode>0){
                  throw new Error(wk.LastErrorCode)
                  }
                wk.UsedWibuBox.MoveFirst()
                resourcesysteminfo.serial.value=wk.UsedWibuBox.SerialText
                //alert('按保存之后该用户的usb令牌生效')
                }catch(err){
                  alert('<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>')
                  //obj.checked=false
                  
                  return false;
                }
                return true;
             //}else{
             //return
             //}
             }
			</script>
		<script language=javascript>
			function updateKey2(){
			   /*
				if(!resourcesysteminfo.needusb.checked==true){
					alert('该用户不是需要加强安全性的用户');
					return;
				}
			  */	
				var returnstr = getUserName();
				if(returnstr != undefined){
					resourcesysteminfo.username.value=returnstr;
					resourcesysteminfo.loginid.value=returnstr;
				}
			}

			function change2(obj){
				//if(obj.checked==true){
					var returnstr = getUserName();
					if(returnstr != undefined){
						resourcesysteminfo.username.value=returnstr;
						resourcesysteminfo.loginid.value=returnstr;
						return true;
					}else
					    return false;
				//}
			}
		</script>
		<OBJECT id=htactx name=htactx 
classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
		<script language=VBScript>
		function getUserName()
			dim hCard
			hCard = 0
			on   error   resume   next
			hCard = htactx.OpenDevice(1)'打开设备
			If Err.number<>0 or hCard = 0 then
				alert("<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>")
				Exit function
			End if
			dim UserName
			on   error   resume   next
			UserName = htactx.GetUserName(hCard)'获取用户名
			If Err.number<>0 Then
				alert("<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>")
				htactx.CloseDevice hCard
				Exit function
			End if

			getUserName = UserName
		End function
		</script>
				 <%
			 }%>
         <script type="text/javascript">
            function bindTokenKey(){
               url=encodeURIComponent("/login/bindTokenKey.jsp?requestFrom=system&userid=<%=id%>");  
               result=window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,null,"dialogWidth=620px;");
               if(result&&result.tokenKey!=""){
                  jQuery("#tokenKey").val(result.tokenKey);
               }
            }
            
            function chooseUsb(obj){
               if(jQuery(obj).attr("checked")){
                  jQuery("#serialtr5").show();
                  jQuery("#serialtr6").show();
                  change(jQuery("#userUsbType")[0]);
                  changeshow(jQuery("#userUsbType")[0]);
               }else{
                  jQuery("#serialtr5").hide();
                  jQuery("#serialtr6").hide();
                  changeshow(jQuery("#userUsbType")[0]);
               };
            }
            
            function checkTokenKey(){ 
               var tokenKey=jQuery("#tokenKey");
               if(tokenKey.val()!=""&&(!isdigit(tokenKey.val())||tokenKey.val().length!=10)){
	              alert("令牌序列号必须为10位数字！");
	              tokenKey.val("");
	              tokenKey.focus();
	           }else if(tokenKey.val()!=""){ 
	              jQuery.post("/login/LoginOperation.jsp",{'method':'checkIsUsed','userid':<%=id%>,'tokenKey':tokenKey.val()},function(data){
	                 data=eval("("+data+")");
	                 var status=data.status;
	                 if(status=="1"){
	                    alert('令牌序列号已经绑定给"'+data.lastname+'",不能重复绑定');
	                    tokenKey.val("");
	                    tokenKey.focus();
	                 }
	              });
	           }
            }
            
            function isdigit(s){
				var r,re;
				re = /\d*/i; //\d表示数字,*表示匹配多个数字
				r = s.match(re);
				return (r==s)?true:false;
		    }
         </script>
            </body>
            </html>
