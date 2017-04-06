<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="SpecialityComInfo" class="weaver.hrm.job.SpecialityComInfo" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<HTML>
<%
 Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
 String id = request.getParameter("id");
 int hrmid = user.getUID();
 AllManagers.getAll(id);
 int isView = Util.getIntValue(request.getParameter("isView"));

 int departmentid = user.getUserDepartment();

 boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
 
 boolean ism = ResourceComInfo.isManager(hrmid,id);
 boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
 boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
 boolean isc = ResourceComInfo.isCapInfoView(hrmid,id);
// boolean iscre = ResourceComInfo.isCreaterOfResource(hrmid,id);
 boolean ishe = (hrmid == Util.getIntValue(id));
// boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));

  int scopeId = 3;
  String sql = "";
  sql = "select * from HrmResource where id = "+id;
  rs.executeSql(sql);
  rs.next();
    String probationenddate = Util.null2String(rs.getString("probationenddate"));
    String workstartdate = Util.null2String(rs.getString("startdate"));
    String workenddate = Util.null2String(rs.getString("enddate"));
    String usekind = Util.null2String(rs.getString("usekind"));
    int status = rs.getInt("status");

%>
<HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(380,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=-1;
if(detachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Util.getIntValue(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}
boolean isSelf		=	false;
boolean isManager	=	false;
if (id.equals(""+user.getUID()) ){
		isSelf = true;
	}
while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		isManager = true;
	}
}
if(!((isSelf||isManager||operatelevel>=0)&&HrmListValidate.isValidate(12))){
	response.sendRedirect("/notice/noright.jsp") ;
}
%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(status != 10&&operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(Util.dayDiff(today,probationenddate)==3||Util.dayDiff(today,workenddate)==3){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+",javascript:info(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(!isfromtab){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
}
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
<%if(!isfromtab){ %>
<TABLE class=Shadow>
<%}else{ %>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">

<FORM name=resourceworkinfo id=resourceworkinfo action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">

<TABLE class=ViewForm>

	<TBODY>
    <TR>
      <TD vAlign=top>
      <TABLE width="100%">
        <COLGROUP> <COL width=20%> <COL width=80%>
	      <TBODY>
          <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15688,user.getLanguage())%></TH>
          </TR>
		 <TR class=Spacing style="height:2px">
            <TD class=Line1 colSpan=2></TD>
          </TR>	
          <TR>
            <TD ><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></TD>
            <TD class=Field>
              <%=UseKindComInfo.getUseKindname(usekind)%>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
	      <TR>
            <TD ><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></TD>
            <TD class=Field>
              <%=workstartdate%>
            </TD>
            <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          </TR>
	      <TR>
            <TD ><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></TD>
            <TD class=Field>
              <%=probationenddate%>
              <input class=inputstyle type="hidden" name="probationenddate" value="<%=probationenddate%>">
            </TD>
          </TR>
            <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
	      <TR>
            <TD ><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></TD>
            <TD class=Field>
              <%=workenddate%>
              <input class=inputstyle type="hidden" name="enddate" value="<%=workenddate%>">
            </TD>
          </TR>
            <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>

<%
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue(id,0));
    while(cfm.next()){
        String fieldvalue = cfm.getData("field"+cfm.getId());
%>
    <tr>
      <td <%if(cfm.getHtmlType().equals("2")){%> valign=top <%}%>> <%=cfm.getLable()%> </td>
      <td class=field >
      <%
        if(cfm.getHtmlType().equals("1")||cfm.getHtmlType().equals("2")){
      %>
      <%=fieldvalue%>
      <%
        }else if(cfm.getHtmlType().equals("3")){

            String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值
			if(fieldtype.equals("152")||fieldtype.equals("16")) linkurl = "/workflow/request/ViewRequest.jsp?requestid=";


            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                sql = "";

                HashMap temRes = new HashMap();

                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else if(fieldtype.equals("152")){
					if(fieldvalue.equals("")) fieldvalue = "-1";
					else fieldvalue = "-1" + fieldvalue;
                	sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in ("+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }

                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    showid = Util.null2String(RecordSet.getString(1)) ;
                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                        temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                    else{
                        //showname += tempshowname ;
                        temRes.put(String.valueOf(showid),tempshowname);
                    }
                }
                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                String temstkvalue = "";
                while(temstk.hasMoreTokens()){
                    temstkvalue = temstk.nextToken();

                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                        showname += temRes.get(temstkvalue);
                    }
                }

            }


      %>
        <span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%></span>
       <%
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> disabled >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <%
            while(cfm.nextSelect()){
                if(cfm.getSelectValue().equals(fieldvalue)){
       %>
            <%=cfm.getSelectName()%>
       <%
                    break;
                }
            }
       %>
       <%
        }
       %>
            </td>
        </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD>
  </TR>
       <%
    }
       %>

	     </tbody>
      </table>
   </tr>
   <jsp:include page="HrmRelatedContract.jsp">
	<jsp:param name="id" value="<%=id%>"/>
   </jsp:include>
<%
  sql = "select * from HrmStatusHistory where resourceid = "+id+" order by changedate";
  rs.executeSql(sql);
%>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP>
		    <COL width=15%>
			<COL width=20%>
			<COL width=15%>
			<COL width=35%>
			<COL width=15%>
	      <TBODY>
          <TR class=header>
            <TH colSpan=6><%=SystemEnv.getHtmlLabelName(16136,user.getLanguage())%></TH>
          </TR>
            <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(16041,user.getLanguage())%> </td>
		    <td ><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> </td>
			<td ><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(16137,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></td>
		  </tr>
      
<%
  while(rs.next()){
    int type = Util.getIntValue(rs.getString("type_n"));
    String olddepid = Util.null2String(rs.getString("oldjobtitleid"));
    if(type == 4){
      olddepid = Util.null2String(rs.getString("newjobtitleid"));
    }
	String changedate = Util.null2String(rs.getString("changedate"));
	String changereason = Util.null2String(rs.getString("changereason"));
	String operator = ResourceComInfo.getLastname(""+Util.getIntValue(rs.getString("operator"), 0));
%>
	      <tr>
	        <TD class=Field>
              <%if(type == 1){%><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%><%}%>
              <%if(type == 2){%><%=SystemEnv.getHtmlLabelName(6088,user.getLanguage())%><%}%>
              <%if(type == 3){%><%=SystemEnv.getHtmlLabelName(6089,user.getLanguage())%><%}%>
              <%if(type == 4){%><%=SystemEnv.getHtmlLabelName(6090,user.getLanguage())%><%}%>
              <%if(type == 5){%><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><%}%>
              <%if(type == 6){%><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%><%}%>
              <%if(type == 7){%><%=SystemEnv.getHtmlLabelName(6093,user.getLanguage())%><%}%>
              <%if(type == 8){%><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%><%}%>
            </TD>
	        <TD class=Field>
              <%=JobTitlesComInfo.getJobTitlesname(olddepid)%>
            </TD>
	        <TD class=Field>
              <%=changedate%>
            </TD>
	        <TD class=Field>
              <%=changereason%>
            </TD>
            <TD class=Field>
              <%=operator%>
            </TD>
	      </tr>
<%
  }
%>
      </tbody>
       </table>
   </tr>
<%
  sql = "select * from HrmLanguageAbility where resourceid = "+id+" order by id";
  rs.executeSql(sql);
%>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP>
		    <COL width=30%>
			<COL width=20%>
			<COL width=50%>
	      <TBODY>
          <TR class=header>
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(815,user.getLanguage())%></TH>
          </TR>

		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(15715,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
		  </tr>
        
<%
  while(rs.next()){
    String language = Util.null2String(rs.getString("language"));
	String level = Util.null2String(rs.getString("level_n"));
	String memo = Util.null2String(rs.getString("memo"));
%>
	      <tr>
	        <TD class=Field>
              <%=language%>
            </TD>
	        <TD class=Field>
                <%if (level.equals("0")) {%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
                <%if (level.equals("1")) {%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
				<%if (level.equals("2")) {%><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%><%}%>
                <%if (level.equals("3")) {%><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%><%}%>
            </TD>
	        <TD class=Field>
              <%=memo%>
            </TD>
	      </tr>
<%
  }
%>
      </tbody>
       </table>
   </tr>

<%
  sql = "select * from HrmEducationInfo where resourceid = "+id+" order by id";
  rs.executeSql(sql);
%>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP>
		    <COL width=25%>
			<COL width=25%>
			<COL width=10%>
			<COL width=10%>
			<COL width=10%>
            <COL width=30%>
	      <TBODY>
          <TR class=header>
            <TH colSpan=6><%=SystemEnv.getHtmlLabelName(813,user.getLanguage())%></TH>
          </TR>
		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(1903,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1942,user.getLanguage())%></td>
		  </tr>
        
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("startdate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String school = Util.null2String(rs.getString("school"));
	String speciality = Util.null2String(rs.getString("speciality"));
	String educationlevel = Util.null2String(rs.getString("educationlevel"));
	String studydesc = Util.null2String(rs.getString("studydesc"));
%>
	      <tr>
	        <TD class=Field>
              <%=school%>
            </TD>
	        <TD class=Field>
              <%=SpecialityComInfo.getSpecialityname(speciality)%>
            </TD>
	        <TD class=Field>
              <%=startdate%>
            </TD>
	        <TD class=Field>
              <%=enddate%>
            </TD>
	        <TD class=Field>
<!--
	            <%if(educationlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("12")){%><%=SystemEnv.getHtmlLabelName(2122,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("13")){%><%=SystemEnv.getHtmlLabelName(2123,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("3")){%><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("4")){%><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("5")){%><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("6")){%><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("7")){%><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("8")){%><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%><%}%>
	            <%if(educationlevel.equals("9")){%>MBA<%}%>
	            <%if(educationlevel.equals("10")){%>EMBA<%}%>
	            <%if(educationlevel.equals("11")){%><%=SystemEnv.getHtmlLabelName(2119,user.getLanguage())%><%}%>
-->
	            <%=EducationLevelComInfo.getEducationLevelname(educationlevel)%>
            </TD>
	        <TD class=Field>
              <%=studydesc%>
            </TD>
	      </tr>
<%
  }
%>
      </tbody>
       </table>
   </tr>


<%
  sql = "select * from HrmWorkResume where resourceid = "+id+" order by id";
  rs.executeSql(sql);
%>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP>
		    <COL width=15%>
			<COL width=10%>
			<COL width=10%>
			<COL width=10%>
			<COL width=35%>
            <COL width=30%>
	      <TBODY>
          <TR class=header>
            <TH colSpan=6><%=SystemEnv.getHtmlLabelName(15716,user.getLanguage())%></TH>
          </TR>
		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1977,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(15676,user.getLanguage())%></td>
		  </tr>
          
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("startdate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String company = Util.null2String(rs.getString("company"));
	String jobtitle = Util.null2String(rs.getString("jobtitle"));
	String leavereason = Util.null2String(rs.getString("leavereason"));
	String workdesc = Util.null2String(rs.getString("workdesc"));
%>
	      <tr>
	        <TD class=Field>
              <%=company%>
            </TD>
	        <TD class=Field>
              <%=jobtitle%>
            </TD>
	        <TD class=Field>
              <%=startdate%>
            </TD>
	        <TD class=Field>
              <%=enddate%>
            </TD>
	        <TD class=Field>
              <%=workdesc%>
            </TD>
	        <TD class=Field>
              <%=leavereason%>
            </TD>
	      </tr>
<%
  }
%>
      </tbody>
       </table>
   </tr>


<%
  sql = "select * from HrmTrainBeforeWork where resourceid = "+id+" order by id";
  rs.executeSql(sql);
%>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP>
		    <COL width=25%>
			<COL width=10%>
			<COL width=10%>
			<COL width=20%>
			<COL width=35%>
	      <TBODY>
          <TR class=header>
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(15717,user.getLanguage())%></TH>
          </TR>

		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(15678,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1974,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
		  </tr>
         
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("trainstartdate"));
	String enddate = Util.null2String(rs.getString("trainenddate"));
	String trainname = Util.null2String(rs.getString("trainname"));
	String trainresource = Util.null2String(rs.getString("trainresource"));
	String trainmemo = Util.null2String(rs.getString("trainmemo"));
%>
	      <tr>
	        <TD class=Field>
              <%=trainname%>
            </TD>
	        <TD class=Field>
              <%=startdate%>
            </TD>
	        <TD class=Field>
              <%=enddate%>
            </TD>
            <TD class=Field>
              <%=trainresource%>
            </TD>
	        <TD class=Field>
              <%=trainmemo%>
            </TD>
	      </tr>
<%
  }
%>
      </tbody>
       </table>
   </tr>

<%
  sql = "select * from HrmCertification where resourceid = "+id+" order by id";
  rs.executeSql(sql);

%>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%" class=ListStyle cellspacing=1 >
          <COLGROUP>
		    <COL width=25%>
			<COL width=10%>
			<COL width=10%>
			<COL width=20%>
			<COL width=35%>
			</COLGROUP>
	      <TBODY>
          <TR class=header>
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%></TH>
          </TR>

		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
			<td colspan="2"><%=SystemEnv.getHtmlLabelName(15681,user.getLanguage())%></td>
		  </tr>
  
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("datefrom"));
	String enddate = Util.null2String(rs.getString("dateto"));
	String cername = Util.null2String(rs.getString("certname"));
	String cerresource = Util.null2String(rs.getString("awardfrom"));

%>
	      <tr>
	        <TD class=Field>
              <%=cername%>
            </TD>
	        <TD class=Field>
              <%=startdate%>
            </TD>
	        <TD class=Field>
              <%=enddate%>
            </TD>
            <TD class=Field colspan="2">
              <%=cerresource%>
            </TD>
	      </tr>
<%
  }
%>
      </tbody>
       </table>
   </tr>

<%
  sql = "select * from HrmRewardBeforeWork where resourceid = "+id+" order by id";
  rs.executeSql(sql);
%>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%" class=ListStyle cellspacing=1 >
        <br>
          <COLGROUP>
		    <COL width=15%>
			<COL width=10%>
			<COL width=10%>
			<COL width=10%>
			<COL width=35%>
	      <TBODY>
          <TR class=header>
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(15718,user.getLanguage())%></TH>
          </TR>

		  <tr class=Header>
		    <td ><%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%></td>
			<td colspan="3"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
		  </tr>

<%
  while(rs.next()){
    String rewarddate = Util.null2String(rs.getString("rewarddate"));
	String rewardname = Util.null2String(rs.getString("rewardname"));
	String rewardmemo = Util.null2String(rs.getString("rewardmemo"));
%>
	      <tr>
	        <TD class=Field>
              <%=rewardname%>
            </TD>
	        <TD class=Field>
              <%=rewarddate%>
            </TD>
	        <TD class=Field colspan="3">
              <%=rewardmemo%>
            </TD>
	      </tr>
<%
  }
%>
      </tbody>
       </table>
       </td>
   </tr>
    <TR>
      <TD vAlign=top>

<br>

<%----------------------------自定义明细字段 begin--------------------------------------------%>

	 <%

         RecordSet.executeSql("select id, formlabel from cus_treeform where parentid="+scopeId+" order by scopeorder");
         //System.out.println("select id from cus_treeform where parentid="+scopeId);
         int recorderindex = 0 ;
         while(RecordSet.next()){
             recorderindex = 0 ;
             int subId = RecordSet.getInt("id");
             CustomFieldManager cfm2 = new CustomFieldManager("HrmCustomFieldByInfoType",subId);
             cfm2.getCustomFields();
             CustomFieldTreeManager.getMutiCustomData("HrmCustomFieldByInfoType", subId, Util.getIntValue(id,0));
             int colcount1 = cfm2.getSize() ;
             int colwidth1 = 0 ;

             if( colcount1 != 0 ) {
                 colwidth1 = 100/colcount1 ;

     %>
	 <table Class=ListStyle  cellspacing="0" cellpadding="0">
        <tr class=header>

            <td align="left" >
            <b><%=RecordSet.getString("formlabel")%></b>
            </td>
            <td align="right"  >

            </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>
            <td colspan=2>

            <table Class=ListStyle id="oTable_<%=subId%>"  cellspacing="1" cellpadding="0">
            <COLGROUP>
            <tr class=header>
   <%

       while(cfm2.next()){
		  String fieldlable =String.valueOf(cfm2.getLable());

   %>
		 <td width="<%=colwidth1%>%" nowrap><%=fieldlable%></td>
           <%
	   }
       cfm2.beforeFirst();
%>
</tr>
<%

    boolean isttLight = false;
    while(CustomFieldTreeManager.nextMutiData()){
            isttLight = !isttLight ;
%>
            <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
        <%
        while(cfm2.next()){
            String fieldid=String.valueOf(cfm2.getId());  //字段id
            String ismand=String.valueOf(cfm2.isMand());   //字段是否必须输入
            String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
            String fieldtype=String.valueOf(cfm2.getType());
            String fieldvalue =  Util.null2String(CustomFieldTreeManager.getMutiData("field"+fieldid)) ;

%>
            <td class=field style="TEXT-VALIGN: center;table-layout:fixed; word-break: break-all; overflow:hidden;">
<%
            if(fieldhtmltype.equals("1")||fieldhtmltype.equals("2")){                          // 单行文本框
%>
                <%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>
<%
            }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                String showname = "";                                   // 新建时候默认值显示的名称
                String showid = "";                                     // 新建时候默认值

                String newdocid = Util.null2String(request.getParameter("docid"));

                if( fieldtype.equals("37") && !newdocid.equals("")) {
                    if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                    fieldvalue += newdocid ;
                }

                if(fieldtype.equals("2") ||fieldtype.equals("19")){
                    showname=fieldvalue; // 日期时间
                }else if(!fieldvalue.equals("")) {
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                    sql = "";

                    HashMap temRes = new HashMap();

                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")) {    // 多人力资源,多客户,多会议，多文档
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }

                    rs.executeSql(sql);
                    while(rs.next()){
                        showid = Util.null2String(rs.getString(1)) ;
                        String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
                        if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                            temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                        else{
                            //showname += tempshowname ;
                            temRes.put(String.valueOf(showid),tempshowname);
                        }
                    }
                    StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                    String temstkvalue = "";
                    while(temstk.hasMoreTokens()){
                        temstkvalue = temstk.nextToken();

                        if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                            showname += temRes.get(temstkvalue);
                        }
                    }

                }
%>
                    <%=showname%>
<%
            }else if(fieldhtmltype.equals("4")) {                    // check框
%>
                <input type=checkbox disabled value=1 name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" <%if(fieldvalue.equals("1")){%> checked <%}%> >
<%
            }else if(cfm2.getHtmlType().equals("5")){
                cfm2.getSelectItem(cfm2.getId());
                while(cfm2.nextSelect()){
                    if(cfm2.getSelectValue().equals(fieldvalue)){
%>
            <%=cfm2.getSelectName()%>
<%
                        break;
                    }
                }
            }
%>
            </td>
<%
        }
        cfm2.beforeFirst();
        recorderindex ++ ;
    }

%>
</tr>

        </table>
        </td>
        </tr>
</table>

<%
             }
%>
<br>
<%
         }
%>

<%----------------------------自定义明细字段 end  --------------------------------------------%>

      </td>
    </tr>
</table>
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
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
    location = "/hrm/resource/HrmResourceWorkEdit.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function info(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
         document.resourceworkinfo.operation.value="info";
	 document.resourceworkinfo.submit();
    }
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
  function viewFinanceInfo(){
    location = "/hrm/resource/HrmResourceFinanceView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewSystemInfo(){
    location = "/hrm/resource/HrmResourceSystemView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewCapitalInfo(){
    location = "/cpt/search/CptMyCapital.jsp?id=<%=id%>";
  }
</script>
</BODY>
</HTML>

