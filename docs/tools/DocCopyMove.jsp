<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.AclManager" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<%
boolean isoracle = RecordSet.getDBType().equals("oracle");
boolean CanCopy = HrmUserVarify.checkUserRight("DocCopyMove:Copy", user);
boolean CanMove = HrmUserVarify.checkUserRight("DocCopyMove:Move", user);
int srcsecid = Util.getIntValue(request.getParameter("srcsecid"), -1);
int srcsubid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+srcsecid), -1);
int srcmainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+srcsubid), -1);

int objsecid = Util.getIntValue(request.getParameter("objsecid"), -1);
int objsubid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+objsecid), -1);
int objmainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+objsubid), -1);

String otype=Util.null2String(request.getParameter("otype"));//操作类型 1复制、2移动

String srcpath = "";
String objpath = "";

AclManager am = new AclManager();
if(am.hasPermission(srcsecid, AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_COPYDOC)&&am.hasPermission(objsecid, AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_COPYDOC)){
    CanCopy = true;
}

if(am.hasPermission(srcsecid, AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_MOVEDOC)&&am.hasPermission(objsecid, AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_MOVEDOC)){
    CanMove = true;
}

if (srcsecid != -1) {
    srcpath = "/"+CategoryUtil.getCategoryPath(srcsecid);
}
if (objsecid != -1) {
    objpath = "/"+CategoryUtil.getCategoryPath(objsecid);
}

if (srcsecid == -1 || objsecid == -1 || srcsecid == objsecid) {
    CanMove = false;
    CanCopy = false;
}
//System.out.println("CanMove: "+CanMove+" CanCopy:"+CanCopy);
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<script type='text/javascript' src='/dwr/interface/DocDwrUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<style type="text/css">
TABLE.ListStyle TR.Selected {
	BACKGROUND-COLOR: #E5E5E5 ; HEIGHT: 22px ; BORDER-Spacing:1pt
}
</style>


</HEAD>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(77,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    if(CanCopy&&otype.equals("1")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:onCopy(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    if(CanMove&&otype.equals("2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+",javascript:onMove(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    if(HrmUserVarify.checkUserRight("DocCopyMove:Log", user)){
        if(RecordSet.getDBType().equals("db2")){
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) =9',_top} " ;
       	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/docs/DocCopyMoveLog.jsp?sqlwhere=where operatetype=11 or operatetype=12',_top} " ;
    }else{
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =9',_top} " ;
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/docs/DocCopyMoveLog.jsp?sqlwhere=where operatetype=11 or operatetype=12',_top} " ;
    }
        RCMenuHeight += RCMenuHeightStep ;
    }
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

        <FORM id=frmmain name=frmmain action="DocCopyMoveOperation.jsp" method=post >
            <input type="hidden" name="operation">
            <input type="hidden" name="docStrs">
            <input type="hidden" name="ifrepeatedname" value="yes">
            <table class=ViewForm>
                <colgroup>
                    <COL width="49%">
                    <COL width=10>
                    <COL width="49%">
                <TBODY>
                <TR class=Title>
                   <TH colSpan=2><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TH>
                </TR>
                <TR style="height:1px;">
                   <td colspan=3 class=Line1>                        
                    </td>
                </TR>
                <TR>
                  <TD>
                     <%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%>:
                     <SELECT name="otype" id="otype" onchange="oc()">                 
                        <option value="1" <%if(otype.equals("1")) out.println("selected");%> ><%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%></option>
                        <option value="2" <%if(otype.equals("2")) out.println("selected");%> ><%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%></option>
                     </SELECT>
                  </TD>
                </TR>
                <TR style="height:1px;">
                   <td  colspan=3 class=Line>
                                                 
                    </td>
                </TR>
                <TR>
                <TD height="6"  colspan=3>&nbsp;</TD>
                </TR>

<%
	//numperpage
    int numperpage = Util.getIntValue(request.getParameter("numperpage"), -1);
	if(numperpage==-1){
		UserDefaultManager.setUserid(user.getUID());
		UserDefaultManager.selectUserDefault();
		numperpage = UserDefaultManager.getNumperpage();
	}
	if(numperpage <2) numperpage=10;

  if(CanMove || CanCopy){
    //处理自定义条件 begin

    String docsubject = Util.null2String(request.getParameter("docsubject")) ;
    String ownerid=Util.null2String(request.getParameter("ownerid"));
    if(ownerid.equals("0")) ownerid="";
    String departmentid=Util.null2String(request.getParameter("departmentid"));
    if(departmentid.equals("0")) departmentid="";

    DocSearchComInfo.resetSearchInfo();
    DocSearchComInfo.setSeccategory(""+srcsecid);
    DocSearchComInfo.setDocsubject(docsubject);
    DocSearchComInfo.setOwnerid(ownerid);
    DocSearchComInfo.setDocdepartmentid(departmentid);

    String whereKeyStr="docsubject="+docsubject;
    whereKeyStr+="^,^ownerid="+ownerid;
    whereKeyStr+="^,^departmentid="+departmentid;

    String[] checkcons = request.getParameterValues("check_con");
    String sqlwhere = "";
    String sqlrightwhere = "";
    String temOwner = "";

    if(checkcons!=null){
        for(int i=0;i<checkcons.length;i++){
            String tmpid = ""+checkcons[i];
            String tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
            String tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
            String tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
            String tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
            String tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
            String tmpname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_name"));
            String tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
            String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));

            whereKeyStr+="^,^tmpid="+tmpid;
            whereKeyStr+="~@~tmpcolname="+tmpcolname;
            whereKeyStr+="~@~tmphtmltype="+tmphtmltype;
            whereKeyStr+="~@~tmptype="+tmptype;
            whereKeyStr+="~@~tmpopt="+tmpopt;
            whereKeyStr+="~@~tmpvalue="+tmpvalue;
            whereKeyStr+="~@~tmpname="+tmpname;
            whereKeyStr+="~@~tmpopt1="+tmpopt1;
            whereKeyStr+="~@~tmpvalue1="+tmpvalue1;

            //生成where子句

            temOwner = "tCustom";
			boolean haveLeftBracket=false;
            if((tmphtmltype.equals("1")&& tmptype.equals("1"))||tmphtmltype.equals("2")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                haveLeftBracket=true;
                if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
                if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
                if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
            }else if(tmphtmltype.equals("1")&& !tmptype.equals("1")){
                //sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("")){
                	sqlwhere += "and ("+temOwner+"."+tmpcolname;
				    haveLeftBracket=true;
                    if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";

                }
                if(!tmpvalue1.equals("")){
                	if(!haveLeftBracket){
						sqlwhere += " and ("+temOwner+"."+tmpcolname;
						haveLeftBracket=true;
					}else{
						sqlwhere += " and "+temOwner+"."+tmpcolname;
					}

                    if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
                }
            }
            else if(tmphtmltype.equals("4")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                haveLeftBracket=true;
                if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
                else sqlwhere +="='1' ";
            }
            else if(tmphtmltype.equals("5")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                haveLeftBracket=true;
                if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
            }
            else if(tmphtmltype.equals("3") && !tmptype.equals("2") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")&& !tmptype.equals("65") && !tmptype.equals("162") ){
            	if(!tmpvalue.equals("")){
					sqlwhere += "and ("+temOwner+"."+tmpcolname;
					haveLeftBracket=true;
					if(tmpopt.equals("1")){
						sqlwhere+=" ="+tmpvalue +" ";
					}
					if(tmpopt.equals("2")){	
						sqlwhere+=" <>"+tmpvalue +" ";
					}
				}
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("2")||tmptype.equals("19"))){ // 对日期处理
                //sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("")){
                	sqlwhere += " and ("+temOwner+"."+tmpcolname;
				    haveLeftBracket=true;
                    if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";

                }
                if(!tmpvalue1.equals("")){
                	if(!haveLeftBracket){
						sqlwhere += " and ("+temOwner+"."+tmpcolname;
						haveLeftBracket=true;
					}else{
						sqlwhere += " and "+temOwner+"."+tmpcolname;
					}
                    if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
                }
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("17") || tmptype.equals("18") || tmptype.equals("37") || tmptype.equals("65") || tmptype.equals("162"))){       // 对多人力资源，多客户，多文档的处理
                //sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
				if(isoracle){
					sqlwhere += "and (','||"+temOwner+"."+tmpcolname+"||',' ";
				}else{
					sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
				}
				haveLeftBracket=true;
                if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
                if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
            }

            if(haveLeftBracket){
                sqlwhere +=") ";
			}

        }

    }

		session.setAttribute(user.getUID()+"_"+srcsecid+"whereKeyStr",whereKeyStr);
	
    //for debug
    //System.out.println(sqlwhere);
    if(!sqlwhere.equals("")){
        //去掉sql语句前面的and
        sqlwhere = sqlwhere.trim().substring(3);
        DocSearchComInfo.setCustomSqlWhere(sqlwhere);
    }else{
        DocSearchComInfo.setCustomSqlWhere("");
    }
    //处理自定义条件 end
  }
%>
                <TR class=Title>
                   <TH colSpan=2><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></TH>
                </TR>
                <TR style="height:1px;">
                   <td colspan=3 class=Line1>                           
                    </td>
                </TR>
                <TR>
                  <TD>
                      <%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%>
                      <input type="text" class=InputStyle name="numperpage" value=<%=numperpage%> size="3" maxlength=2 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
                      <%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>
                  </TD>
                </TR>
                <TR style="height:1px;">
                   <td  colspan=3 class=Line>                       
                    </td>
                </TR>
                <TR>
                <TD height="6"  colspan=3>&nbsp;</TD>
                </TR>
                <TR>
                    <td>
                        <table class=ViewForm>
                            <tbody>                                
                                <TR class=Title>
                                    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TH>
                                </TR>
                                <TR class=Spacing style="height: 1px">
                                    <TD class=Line1 colSpan=2></TD>
                                </TR>
                                <tr><td>
                                    <BUTTON type='button'  class=Browser onClick="onSelectCategory(1)" name=selectCategory></BUTTON>：<span id=srcpath name=srcpath><%=srcpath.equals("")?"<IMG src='/images/BacoError.gif' align=absMiddle>":srcpath%></span>
                                </td></tr>
                                
                                <INPUT type=hidden name=srcmainid id="srcmainid" value="<%=srcmainid%>">
                                <INPUT type=hidden name=srcsubid id="srcsubid"  value="<%=srcsubid%>">
                                <INPUT type=hidden name=srcsecid id="srcsecid" value="<%=srcsecid%>">
                                
                            </tbody>
                        </table>
                    </td>
                    <td>
                    </td>
                    <td>
                        <table class=ViewForm>
                            <tbody>
                                <TR class=Title>
                                    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(330,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TH>
                                </TR>
                                <TR class=Spacing style="height: 1px">
                                  <TD class=Line1 colSpan=2></TD>
                                </TR>
                                <tr><td>
                                    <BUTTON type='button' class=Browser onClick="onSelectCategory(2)" name=selectCategory></BUTTON>：<span id=objpath name=objpath><%=objpath.equals("")?"<IMG src='/images/BacoError.gif' align=absMiddle>":objpath%></span>
                                </td></tr>
                                
                                <INPUT type=hidden name=objmainid id="objmainid" value="<%=objmainid%>">
                                <INPUT type=hidden name=objsubid  id="objsubid" value="<%=objsubid%>">
                                <INPUT type=hidden name=objsecid  id="objsecid" value="<%=objsecid%>">
                            </tbody>
                        </table>
                    </td>
                    <td>
                    </td>
                </tr>
                
                <TR>
                   <td valign="top">
                       <table class=ViewForm>                              
                          <TR class=Spacing style="height: 1px">
                            <TD class=Line colSpan=2></TD>
                          </TR>
                       </table>                                
                    </td>
                    <td></td>
                   <td valign="top">
                       <table class=ViewForm>                              
                          <TR class=Spacing style="height: 1px">
                            <TD class=Line colSpan=2></TD>
                          </TR>
                       </table>                                
                    </td>
                    <td></td>
                </TR>
                
                
                <TR>
                    <td valign="top">
                        <table class=ViewForm>
                            <tbody>                                
                                <TR class=Title>
                                    <TH><%=SystemEnv.getHtmlLabelName(331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17037,user.getLanguage())%></TH>
                                </TR>
                                <TR class=Spacing style="height: 1px"><TD class=Line1></TD></TR>
                                
                                <tr><td width="100%">

								<!-- <div style="overflow-y:auto;width:100%;height:100%"> -->
								<table width="100%" class=ListStyle id="SrcBrowseTable">
								<%
									int i=0;
									CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",srcsecid);
									cfm.getCustomFields();
									while(cfm.next()){
										if(i==0){
											i=1;
									%>
									<TR class=DataLight>
									<%
										} else {
											i=0;
									%>
									<TR class=DataDark>
									<% } %>
									<td width="1%"><input type="radio" name="SelectedSrcProperty" value="<%=cfm.getId()%>`<%=cfm.getLable()%>`<%=cfm.getHtmlType()%>`<%=cfm.getType()%>"></td>
                                	<td width="40%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>:
                                	<%=cfm.getLable()%>
                                	</td>
                                	<td width="35%"><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>:
								    <%if(cfm.getHtmlType().equals("1")){%>
								        <%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%>
								    <%} else if(cfm.getHtmlType().equals("2")){%>
								        <%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%>
								    <%} else if(cfm.getHtmlType().equals("3")){%>
								        <%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>
								    <%} else if(cfm.getHtmlType().equals("4")){%>
								        <%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%>
								    <%} else if(cfm.getHtmlType().equals("5")){%>
								        <%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%>
								    <%} %>
                                	</td>
                                	<td width="25%">
                                	<%if(cfm.getHtmlType().equals("1")){%>
                                		<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
								        <%if(cfm.getType() == 1){%>
								            <%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%>
								        <%} else if(cfm.getType() == 2){%>
								            <%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%>
								        <%} else if(cfm.getType() == 3){%>
								            <%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%>
								        <%} %>
								    <%}else if(cfm.getHtmlType().equals("3")){%>
								    	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
								    	<%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(String.valueOf(cfm.getType())),0),7)%>
								    <%} else if(cfm.getHtmlType().equals("5")){%>

								    <%}%>
                                	</td>
                                </tr>
                                <%}%>
                                </table>
                                <!-- </div> -->
                                </td>
                            </tr>

                            </tbody>
                        </table>
                    </td>
                    <td>
                    </td>
                    <td valign="top">
                        <table class=ViewForm>
                            <tbody>                                
                                <TR class=Title>
                                    <TH><%=SystemEnv.getHtmlLabelName(330,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17037,user.getLanguage())%></TH>
                                </TR>
                                <TR class=Spacing style="height: 1px"><TD class=Line1></TD></TR>
                                
                                <tr><td width="100%">

								<!--<div style="overflow-y:auto;width:100%;height:100%">-->
								<table width="100%" class=ListStyle id="ObjBrowseTable">
								<%
									i=0;
									cfm = new CustomFieldManager("DocCustomFieldBySecCategory",objsecid);
									cfm.getCustomFields();
									while(cfm.next()){
										if(i==0){
											i=1;
									%>
									<TR class=DataLight>
									<%
										} else {
											i=0;
									%>
									<TR class=DataDark>
									<% } %>
                                	<td width="1%"><input type="radio" name="SelectedObjProperty" value="<%=cfm.getId()%>`<%=cfm.getLable()%>`<%=cfm.getHtmlType()%>`<%=cfm.getType()%>"></td>
                                	<td width="40%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>:
                                	<%=cfm.getLable()%>
                                	</td>
                                	<td width="35%"><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>:
								    <%if(cfm.getHtmlType().equals("1")){%>
								        <%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%>
								    <%} else if(cfm.getHtmlType().equals("2")){%>
								        <%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%>
								    <%} else if(cfm.getHtmlType().equals("3")){%>
								        <%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>
								    <%} else if(cfm.getHtmlType().equals("4")){%>
								        <%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%>
								    <%} else if(cfm.getHtmlType().equals("5")){%>
								        <%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%>
								    <%} %>
                                	</td>
                                	<td width="25%">
                                	<%if(cfm.getHtmlType().equals("1")){%>
                                		<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
								        <%if(cfm.getType() == 1){%>
								            <%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%>
								        <%} else if(cfm.getType() == 2){%>
								            <%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%>
								        <%} else if(cfm.getType() == 3){%>
								            <%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%>
								        <%} %>
								    <%}else if(cfm.getHtmlType().equals("3")){%>
								    	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
								    	<%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(String.valueOf(cfm.getType())),0),7)%>
								    <%} else if(cfm.getHtmlType().equals("5")){%>

								    <%}%>
                                	</td>
                                </tr>
                                <%}%>
                                </table>
                                <!-- </div> -->
                                </td>
                            </tr>

                            </tbody>
                        </table>
                    </td>
                    <td>
                    </td>
                </tr>                
                
                <TR>
                   <td valign="top">
                       <table class=ViewForm>                              
                          <TR class=Spacing style="height: 1px">
                            <TD class=Line colSpan=2></TD>
                          </TR>
                       </table>                                
                    </td>
                    <td></td>
                   <td valign="top">
                       <table class=ViewForm>                              
                          <TR class=Spacing style="height: 1px">
                            <TD class=Line colSpan=2></TD>
                          </TR>
                       </table>                                
                    </td>
                    <td></td>
                </TR>

                <TR>
                    <td colspan="3">
                        <table class=ViewForm>
                            <tbody>                                
                                <TR class=Title>
                                    <TH><%=SystemEnv.getHtmlLabelName(23598,user.getLanguage())%></TH>
                                    <TH>
										<div align="right">
											<BUTTON Class=Btn type=button accessKey=A onclick="addPropertyMapping()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
											<BUTTON Class=Btn type=button accessKey=D onclick="delPropertyMapping()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
										</div>
                                    </TH>
                                </TR>
                                <TR class=Spacing style="height: 1px">
                                    <TD class=Line1 colSpan=2></TD>
                                </TR>
                                <tr>
                                <td colSpan=2>
                                <div id="selectedPropertyMappingDiv">
                                </div>
                                </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </TR>
                
                
                
                
                
                <TR>
                <TD height="6">&nbsp;</TD>
                </TR>
                
                <TR>
                <TD height="6"  colspan=3>&nbsp;</TD>
                </TR>
                  <%if (CanMove || CanCopy){%>
                <tr>
                    <td colspan="3" valign="top">
<jsp:include page="/docs/search/DocSearchCondition.jsp" flush="true">
	<jsp:param name="secCategoryId" value="<%=srcsecid%>" />
</jsp:include>

                          <%
String userid=user.getUID()+"" ;
String loginType = user.getLogintype() ;

int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
String sqlWhere="";
String tabletype="checkbox";
String browser="";

String tableString = "";
String tableInfo = "";
String isNew = "";

boolean isUsedCustomSearch = false;

if(DocSearchComInfo.getSeccategory()!=null&&!"".equals(DocSearchComInfo.getSeccategory())){
    isUsedCustomSearch = SecCategoryComInfo.isUsedCustomSearch(Util.getIntValue(DocSearchComInfo.getSeccategory()));
}


if(isUsedCustomSearch){
	String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	if(RecordSet.getDBType().equals("oracle"))
	{
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	}
    //backFields
	String backFields = "";
	//backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t1.docextendname");
	backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t1.docextendname,t1.doccreaterid");
    
	//from
	String  sqlFrom = "DocDetail  t1 ";
	
	String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
	if(!strCustomSql.equals("")){
	  sqlFrom += ", cus_fielddata tCustom ";
	}
	//where
	
	//String isNew
	isNew = DocSearchComInfo.getIsNew() ;
	
	String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;

	/* added by wdl 2006-08-28 不显示历史版本 */
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	/* added end */
	
	
	//用于暂时屏蔽外部用户的订阅功能
	//if (!"1".equals(loginType)){
	    tableInfo = "";
	//}
	
	
		
	sqlFrom += ",(select ljt1.id as docid,ljt2.* from DocDetail ljt1 LEFT JOIN cus_fielddata ljt2 ON ljt1.id=ljt2.id and ljt2.scope='DocCustomFieldBySecCategory' and ljt2.scopeid="+DocSearchComInfo.getSeccategory()+") tcm";
	whereclause += " and t1.id = tcm.docid ";
	
	
	
	
	
	sqlWhere = whereclause;
	//System.out.println(sqlWhere);
	//colString
	String userInfoForotherpara =loginType+"+"+userid;
	String colString ="";
	if(displayUsage==0){
		colString +="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
	}
	if(displayUsage==1){
		//colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
		colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
	}
	
	//orderBy
	//String orderBy = "doclastmoddate,doclastmodtime"; 
	String orderBy = "doclastmoddate,doclastmodtime";   
	//primarykey
	String primarykey = "t1.id";
	//pagesize
	int pagesize = numperpage;
	
	       
    SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(Util.getIntValue(DocSearchComInfo.getSeccategory()));
	RecordSet.executeSql("select * from DocSecCategoryCusSearch where secCategoryId = "+DocSearchComInfo.getSeccategory()+" order by viewindex");
	while(RecordSet.next()){
		int currId = RecordSet.getInt("id");
		int currDocPropertyId = RecordSet.getInt("docPropertyId");
		int currVisible = RecordSet.getInt("visible");
		
		int currType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType(currDocPropertyId+""));
//		if(currType==1) continue;
		
		int currIsCustom = Util.getIntValue(SecCategoryDocPropertiesComInfo.getIsCustom(currDocPropertyId+""));
		
		int currLabelId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
		String currCustomName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+""));
		
		String currName = (currCustomName.equals("")&&currLabelId>0)?SystemEnv.getHtmlLabelName(currLabelId, user.getLanguage()):currCustomName;
        
        if((currVisible==1 || currVisible==-1)&&displayUsage==0){
            if(currIsCustom==1){
                int tmpfieldid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getFieldId(currDocPropertyId+""));
                String tmpcustomName = SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+"");

			    int tempIndexId=tmpcustomName.lastIndexOf("(自定义)");
			    if(tempIndexId<=0){
				    tempIndexId=tmpcustomName.lastIndexOf("(user-defined)");
			    }
			    if(tempIndexId>0){
					tmpcustomName=tmpcustomName.substring(0,tempIndexId);
			    }

        	    backFields=getFilterBackFields(backFields,"tcm.field"+tmpfieldid);
        	    colString +="<col width=\"10%\"  text=\""+tmpcustomName+"\" column=\""+"field"+tmpfieldid+"\" orderkey=\""+"field"+tmpfieldid+"\"  transmethod=\"weaver.docs.docs.CustomFieldSptmForDoc.getFieldShowName\"   otherpara=\""+tmpfieldid+"+"+ user.getLanguage()+"\"/>";
            } else {
                if(currType==1){
						//colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(19541,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
						colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(19541,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
                } else if(currType==2){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docCode");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docCode\" orderkey=\"docCode\"/>";
                } else if(currType==3){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docpublishtype");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docpublishtype\" orderkey=\"docpublishtype\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocPublicType\" otherpara=\""+user.getLanguage()+"\"/>";
                } else if(currType==4){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docedition");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docedition\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocVersion\"/>";
                } else if(currType==5){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docstatus");
            	    //colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\" otherpara=\""+user.getLanguage()+"\"/>";
            	    colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\" otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";            	    
                } else if(currType==6){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.maincategory");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"maincategory\" orderkey=\"maincategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocMaincategory\"/>";
                } else if(currType==7){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.subcategory");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"subcategory\" orderkey=\"subcategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSubcategory\"/>";
                } else if(currType==8){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.seccategory");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"seccategory\" orderkey=\"seccategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSeccategory\"/>";
                } else if(currType==9){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docdepartmentid");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docdepartmentid\" orderkey=\"docdepartmentid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocDepartment\"/>";
                } else if(currType==10){
                    
                    
                } else if(currType==11){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doclangurage");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doclangurage\" orderkey=\"doclangurage\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocLangurage\"/>";
                } else if(currType==12){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.keyword");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"keyword\" orderkey=\"keyword\"/>";
                } else if(currType==13){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    //backFields=getFilterBackFields(backFields,"t1.doccreaterid,t1.doccreatedate,t1.doccreatetime");
            	    backFields=getFilterBackFields(backFields,"t1.doccreatedate,t1.doccreatetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
                } else if(currType==14){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doclastmoduserid,t1.doclastmoddate,t1.doclastmodtime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
                } else if(currType==15){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docapproveuserid,t1.docapprovedate,t1.docapprovetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docapprovedate\" orderkey=\"docapprovedate\"/>";
                } else if(currType==16){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docinvaluserid,t1.docinvaldate,t1.docinvaltime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docinvaldate\" orderkey=\"docinvaldate\"/>";
                } else if(currType==17){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docarchiveuserid,t1.docarchivedate,t1.docarchivetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docarchivedate\" orderkey=\"docarchivedate\"/>";
                } else if(currType==18){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doccanceluserid,t1.doccanceldate,t1.doccanceltime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doccanceldate\" orderkey=\"doccanceldate\"/>";
                } else if(currType==19){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.maindoc");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" otherpara=\"column:maindoc+"+user.getLanguage()+"\" orderkey=\"maindoc\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocMaindoc\"/>";
                } else if(currType==20){
                    
                    
                } else if(currType==21){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.ownerid");
          	        colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
                } else if(currType==22){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.invalidationdate");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"invalidationdate\" orderkey=\"invalidationdate\"/>";
                }
                
                
            }
        }
    }
	
	
	
	
	
	
	
	//  用户自定义设置
	boolean dspcreater = false ;
	boolean dspcreatedate = false ;
	boolean dspmodifydate = false ;
	boolean dspdocid = false;
	boolean dspcategory = false ;
	boolean dspaccessorynum = false ;
	boolean dspreplynum = false ;
	
	if (UserDefaultManager.getHasdocid().equals("1")) {
	    dspdocid = true;
	}

	if (UserDefaultManager.getHasreplycount().equals("1")&&displayUsage==0) {  
	    dspreplynum = true ;
	    backFields=getFilterBackFields(backFields,"t1.replaydoccount");
	    colString +="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";
	}
	if (UserDefaultManager.getHasaccessorycount().equals("1")&&displayUsage==0) {  
	    dspaccessorynum = true ;
	    backFields=getFilterBackFields(backFields,"t1.accessorycount");
	    colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";
	}
	

	backFields=getFilterBackFields(backFields,"t1.sumReadCount,t1.docstatus,t1.sumMark");
	if(displayUsage==0) {
		colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";

	}
	
	if(backFields.startsWith(",")) backFields=backFields.substring(1);
	if(backFields.endsWith(",")) backFields=backFields.substring(0,backFields.length()-1);
	
	
		
	//默认为按文档创建日期排序所以,必须要有这个字段
	if (backFields.indexOf("doclastmoddate")==-1) {
	    backFields+=",doclastmoddate";
	}
	
	//String tableString
	tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+tabletype+"\">";
	tableString+=browser;
    //tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<head>"+colString+"</head>";
    //tableString+=operateString;
    tableString+="</table>";   
      
} else {
    
     
	//backFields
	//String backFields="t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t1.docextendname,";
	String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	if(RecordSet.getDBType().equals("oracle"))
	{
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	}
	//backFields
	String backFields="t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t1.docextendname,t1.doccreaterid,";
	//from
	String  sqlFrom = "DocDetail  t1";  
	String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
	if(!strCustomSql.equals("")){
	  sqlFrom += ", cus_fielddata tCustom ";
	}
	//where
	

	String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
	
	/* added by wdl 2006-08-28 不显示历史版本 */
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	/* added end */
	
	
	//用于暂时屏蔽外部用户的订阅功能
	//if (!"1".equals(loginType)){
	    tableInfo = "";
	//}
	sqlWhere = whereclause;
	//System.out.println(sqlWhere);
	//colString
	String userInfoForotherpara =loginType+"+"+userid;
	String colString ="";
	if(displayUsage==0){
		colString +="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
	}
	//colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
	colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
	//orderBy
	String orderBy = "doclastmoddate,doclastmodtime";    
	//primarykey
	String primarykey = "t1.id";
	//pagesize
	int pagesize = numperpage;

		
	//  用户自定义设置
	boolean dspcreater = false ;
	boolean dspcreatedate = false ;
	boolean dspmodifydate = false ;
	boolean dspdocid = false;
	boolean dspcategory = false ;
	boolean dspaccessorynum = false ;
	boolean dspreplynum = false ;
	
	
	if (UserDefaultManager.getHasdocid().equals("1")) {
	    dspdocid = true;    
	}
	if (UserDefaultManager.getHascreater().equals("1")&&displayUsage==0) {
	      dspcreater = true ;
	      backFields+="ownerid,t1.usertype,";
	      colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
	}
	if (UserDefaultManager.getHascreatedate().equals("1")&&displayUsage==0) { 
	    dspcreatedate = true ;
	    backFields+="doccreatedate,";
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
	}
	if (UserDefaultManager.getHascreatetime().equals("1")&&displayUsage==0) {
	    dspmodifydate = true ;
	    backFields+="doclastmoddate,";
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
	}
	if (UserDefaultManager.getHascategory().equals("1")&&displayUsage==0) {   
	    dspcategory = true ;
	    backFields+="maincategory,";
	    colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory\" returncolumn=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
	}
	if (UserDefaultManager.getHasreplycount().equals("1")&&displayUsage==0) {  
	    dspreplynum = true ;
	    backFields+="replaydoccount,";
	    colString +="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";
	}
	if (UserDefaultManager.getHasaccessorycount().equals("1")&&displayUsage==0) {  
	    dspaccessorynum = true ;
	    backFields+="accessorycount,";
	    colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";
	}
	
	backFields+="sumReadCount,docstatus,sumMark";
	
	if(displayUsage==0) {
		colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";
		//colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" column=\"sumMark\" orderkey=\"sumMark\"/>";
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" otherpara=\""+user.getLanguage()+"\"/>";
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\"  otherpara=\""+user.getLanguage()+"\"/>";
		colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\"  otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";
	}
		
	//默认为按文档创建日期排序所以,必须要有这个字段
	if (backFields.indexOf("doclastmoddate")==-1) {
	    backFields+=",doclastmoddate";
	}
	

	//String tableString
	tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+tabletype+"\">";
	tableString+=browser;
    //tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<head>"+colString+"</head>";
    //tableString+=operateString;
    tableString+="</table>";     
       

       
}     
												 










                          %>
                          <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run"/> 
                    </td>
                </tr>
                    <%}%>
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
</body>
</html>

<script language="javascript">

function CheckAll(checked) {
    len = document.frmmain.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='checkedDoc') {
            if(document.frmmain.elements[i].disabled==false){
                document.frmmain.elements[i].checked=(checked==true?true:false);
            }
        }
    }
}

function onSelectCategory(whichcategory) {
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;

    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp?otype="+document.getElementById("otype").value
    		,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if (result != null) {
	    if (parseInt(result.tag) > 0)  {
    	    if (whichcategory == 1) {
				document.getElementById("srcsecid").value=result.id;
				delAllPropertyMapping();
				onSearch();
    	    } else {
    	    	document.getElementById("objsecid").value=result.id;
				delAllPropertyMapping();
				onSearch();
    	    }
    	} else {
    	    if (whichcategory == 1) {
    	    	document.getElementById("srcsecid").value=-1;
				delAllPropertyMapping();
				onSearch();
    	    } else {
    	    	document.getElementById("objsecid").value=-1;
				delAllPropertyMapping();
				onSearch();
    	    }
    	}
	}
}
function checkHaveSce(){
	if (document.frmmain.objsecid.value==-1 || document.frmmain.objsecid.value==''){
		alert('<%=SystemEnv.getErrorMsgName(10,user.getLanguage())%>');
		return false;
		}
	else return true;
}
function checkSelected(){
	len = document.frmmain.elements.length;
	for( i=0; i<len; i++) {
		if (document.frmmain.elements[i].name=='chkInTableTag') {
			if(document.frmmain.elements[i].checked)
			return true;
		}
	}
	alert('<%=SystemEnv.getErrorMsgName(10,user.getLanguage())%>');
	return false;
}
function onCopy(){
	if(checkHaveSce()&&checkSelected()){
        document.frmmain.docStrs.value=_xtable_CheckedCheckboxId();  
        document.frmmain.operation.value="copy";
		DocDwrUtil.ifCanRepeatName(_xtable_CheckedCheckboxId(),document.frmmain.objsecid.value,
			{callback:function(result){
				if(result=='true'){
					if(confirm("<%=SystemEnv.getHtmlLabelName(26086,user.getLanguage())%>")){
						document.frmmain.ifrepeatedname.value="yes";
					}else{
						document.frmmain.ifrepeatedname.value="no";
					}
					document.frmmain.submit();
				}else{
 					document.frmmain.submit();
				}
			  }
			}
		);
	}

}
function onMove(){
	if(checkHaveSce()&&checkSelected()){
        document.frmmain.docStrs.value=_xtable_CheckedCheckboxId();  
		document.frmmain.operation.value="move";
		DocDwrUtil.ifCanRepeatName(_xtable_CheckedCheckboxId(),document.frmmain.objsecid.value,
			{callback:function(result){
				if(result=='true'){
					if(confirm("<%=SystemEnv.getHtmlLabelName(26086,user.getLanguage())%>")){
						document.frmmain.ifrepeatedname.value="yes";
					}else{
						document.frmmain.ifrepeatedname.value="no";
					}
					document.frmmain.submit();
				}else{
 					document.frmmain.submit();
				}
			  }
			}
		);
	}
}
function oc(){
    document.frmmain.srcsecid.value="";
    document.frmmain.objsecid.value="";
    location="DocCopyMove.jsp?otype="+document.frmmain.otype.value;
}

function addPropertyMapping(){
	var srcps = document.getElementsByName("SelectedSrcProperty");
	var objps = document.getElementsByName("SelectedObjProperty");

	var count = 0;
	var srcp = null;
	for(var i=0;srcps!=null&&srcps.length>0&&i<srcps.length;i++){
		if(srcps[i].checked){
			srcp = srcps[i].value;
			count++;
		}
	}
	if(count!=1){
		alert("<%=SystemEnv.getHtmlLabelName(23598,user.getLanguage())%>");
		return;
	}
	count = 0;
	var objp = null;
	for(var i=0;objps!=null&&objps.length>0&&i<objps.length;i++){
		if(objps[i].checked){
			objp = objps[i].value;
			count++;
		}
	}
	if(count!=1){
		alert("<%=SystemEnv.getHtmlLabelName(23598,user.getLanguage())%>");
		return;
	}
	
	if(srcp!=null&&objp!=null){
		var srca = srcp.split("`");
		var obja = objp.split("`");

		var chks = document.getElementsByName("chkSelectedPropertyMapping");
		var count = 0;
		for(var i=0;chks!=null&&i<chks.length;i++){
			if(chks[i]&&!chks[i].disabled&&chks[i].value==(srca[0] + "_" + obja[0])) count++;
		}
		if(count==0) {
			if(srca[2]==obja[2]&&srca[3]==obja[3]){
				document.getElementById("selectedPropertyMappingDiv").innerHTML += "<label><input type=checkbox name='chkSelectedPropertyMapping' value='"+srca[0] + "_" + obja[0]+"'><input type=hidden name='selectedPropertyMapping' value='"+srca[0] + "_" + obja[0]+"'>"+srca[1]+" -> "+obja[1]+"&nbsp;</label>";
			} else {
				alert("<%=SystemEnv.getHtmlLabelName(23596,user.getLanguage())%>");
			}
		} else {
			alert("<%=SystemEnv.getHtmlLabelName(23597,user.getLanguage())%>");
		}
	}
}

function delPropertyMapping(){
	var chkSelectedPropertyMapping = document.getElementsByName("chkSelectedPropertyMapping");
	if(chkSelectedPropertyMapping==null||chkSelectedPropertyMapping.length==0) return;
	for(var i=0;chkSelectedPropertyMapping!=null&&i<chkSelectedPropertyMapping.length;i++){
		if(chkSelectedPropertyMapping[i]&&chkSelectedPropertyMapping[i].checked){
			chkSelectedPropertyMapping[i].disabled = true;
			jQuery(chkSelectedPropertyMapping[i]).parent().hide();
			jQuery(chkSelectedPropertyMapping[i]).parent().children(":eq(1)").attr("disabled","true");
		}
	}
}
function onSearch(){
	document.frmmain.action="/docs/tools/DocCopyMove.jsp";
    document.frmmain.submit();
}
function delAllPropertyMapping(){
	var chkSelectedPropertyMapping = document.getElementsByName("chkSelectedPropertyMapping");
	if(chkSelectedPropertyMapping==null||chkSelectedPropertyMapping.length==0) return;
	for(var i=0;chkSelectedPropertyMapping!=null&&i<chkSelectedPropertyMapping.length;i++){
		if(chkSelectedPropertyMapping[i]){
			chkSelectedPropertyMapping[i].disabled = true;
			jQuery(chkSelectedPropertyMapping[i]).parent().hide();
			jQuery(chkSelectedPropertyMapping[i]).parent().children(":eq(1)").attr("disabled","true");
		}
	}
}
</script>


<%! 
private String getFilterBackFields(String oldbf,String addedbfs){
    String[] bfs = Util.TokenizerString2(addedbfs,",");
    String bf = "";
    for(int i=0;bfs!=null&&bfs.length>0&&i<bfs.length;i++){
        bf = bfs[i];
        if(oldbf.indexOf(","+bf+",")==-1){
            if(oldbf.endsWith(",")) oldbf+=bf+",";
            else oldbf+=","+bf+",";
        }
    }
    return oldbf;
}
%>
