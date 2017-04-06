<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.login.Account,
				 weaver.login.VerifyLogin,
                 weaver.general.GCONST" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerVO"%>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerDAO"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<base target="_blank" />
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);    
String id = Util.null2String(request.getParameter("id"));
if(id.equals("")) id=String.valueOf(user.getUID());


//update by fanggsh TD4233 begin
HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
HrmResourceManagerVO vo = dao.getHrmResourceManagerByID(id);

//update by fanggsh TD4233 end

//get request count
int tempid=Util.getIntValue(id,0);
RelatedRequestCount.resetParameter();
RelatedRequestCount.setUserid(Util.getIntValue(id,0));
RelatedRequestCount.setUsertype(0);
RelatedRequestCount.setRelatedid(tempid);
RelatedRequestCount.setRelatedtype("hrmresource");
RelatedRequestCount.selectRelatedCount();

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();


String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/

String subcompanyid = Util.toScreen(RecordSet.getString("subcompanyid1"),user.getLanguage()) ;
if(subcompanyid==null||subcompanyid.equals("")||subcompanyid.equalsIgnoreCase("null"))
 subcompanyid="-1";
session.setAttribute("hrm_subCompanyId",subcompanyid);
String status = Util.toScreen(RecordSet.getString("status"),user.getLanguage()) ;
String email = Util.toScreen(RecordSet.getString("email"),user.getLanguage()) ;				/*电邮*/

DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");

DocSearchComInfo.setHrmresid(id);
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
DocSearchManage.getSelectResultCount(whereclause,user) ;
String doccount=""+DocSearchManage.getRecordersize();
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String crmStr = "select count(distinct t1.id) "+
"from CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid "+ 
"where t1.deleted = 0  and t1.manager =" + id +" and t1.id = t2.relateditemid";
RecordSet.execute(crmStr);
RecordSet.next();
String crmcount = RecordSet.getString(1) ;

String projString = "";
if(RecordSet.getDBType().equals("oracle")){
		projString = "select count(t1.id) "+ 
   "from Prj_ProjectInfo t1,PrjShareDetail t2  where "+
  //"where t1.id in (select id from prj_projectinfo where (concat(concat(',',members),',') like '%,"+id+",%' and isblock=1) or manager="+id+") "+
   "  t1.id = t2.prjid "+
   "and ((concat(concat(',',members),',') like '%,"+id+",%' and isblock=1) or manager="+id+") "+
	"and t2.usertype = 1 "+
    "and t2.userid ="+user.getUID();
}else if(RecordSet.getDBType().equals("db2")){
	projString = "select count(*) "+ 
    "from Prj_ProjectInfo t1,PrjShareDetail t2 "+
  "where t1.id in (select id from prj_projectinfo where (concat(concat(',',members),',') like '%,"+id+",%' and isblock=1) or manager="+id+") "+
   "and t1.id = t2.prjid "+
	"and t2.usertype = 1 "+
    "and t2.userid ="+user.getUID();
}else{
	projString = "select count(t1.id) "+ 
	"from Prj_ProjectInfo t1,PrjShareDetail t2 where "+
	//"where t1.id in (select id from prj_projectinfo where "+
	"t1.id = t2.prjid "+
	"and ((','+members+',' like '%,"+id+",%'and isblock=1 ) or manager=" +id+" ) "+
	"and t2.usertype = 1 "+
    "and t2.userid ="+user.getUID();
    
}	
RecordSet.execute(projString);
RecordSet.next();
String projectcount = RecordSet.getString(1) ;

RecordSet.executeProc("CptCapital_SCountByResourceid",id);
RecordSet.next();
String assetcount = RecordSet.getString(1) ;


/*显示权限判断*/
int userid = user.getUID();

boolean isSelf		=	false;

if (id.equals(""+user.getUID()) ){
	isSelf = true;
}


// 判定是否可以查看该人预算
boolean canviewbudget = HrmUserVarify.checkUserRight("FnaBudget:All",user, departmentid) ;
boolean caneditbudget =  HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) &&  (""+user.getUserDepartment()).equals(departmentid) ;
boolean canapprovebudget = HrmUserVarify.checkUserRight("FnaBudget:Approve",user) ;

boolean canlinkbudget = canviewbudget || caneditbudget || canapprovebudget || isSelf ;

// 判定是否可以查看该人收支
boolean canviewexpense = HrmUserVarify.checkUserRight("FnaTransaction:All",user, departmentid) ;
boolean canlinkexpense = canviewexpense || isSelf ;


%>
<BODY>



<form name=resource action=HrmResourceOperation.jsp method=post enctype="multipart/form-data">
<INPUT class=inputstyle id=BCValidate type=hidden value=0 name=BCValidate>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%



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
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}

if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
if(HrmListValidate.isValidate(19)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",javascript:sendmail(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}}

RCMenu += "{"+SystemEnv.getHtmlLabelName(16426,user.getLanguage())+",javascript:doAddWorkPlan(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//end

RCMenu += "{"+SystemEnv.getHtmlLabelName(17859,user.getLanguage())+",/cowork/AddCoWork.jsp?hrmid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<div id="divTotal">
	<table class="viewform">	
		 <COLGROUP>
	         <COL width="48%">
			 <COL width="1%">
	         <COL width="48%">
		</COLGROUP>	
	    <tr>
	       <td valign="top">
				<%if(HrmListValidate.isValidate(24)){%>                          
                 <TABLE class="ViewForm">
						<COLGROUP> <COL width="35%"> <COL width="65%">
                         <TBODY>
                          <TR class=Title>
                              <TH align=left colSpan=4><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
                            </TR>
                            <TR class=Spacing style="height:2px">
                              <TD class=Line1 colSpan=4></TD>
                            </TR>
						  <%if(isgoveproj==0){%>
		                    <%if(software.equals("ALL") || software.equals("CRM")){%>
							<TR>
								<TD>CRM</TD>
								<TD class=Field>
								 <A href="/CRM/search/SearchOperation.jsp?destination=myAccount&resourceid=<%=id%>" ><%=crmcount%></A>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
							<%}%>
							<%}%>
							<%if(software.equals("ALL")){%>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></TD>
								<TD class=Field>
								 <A href="/cpt/search/SearchOperation.jsp?resourceid=<%=id%>&isdata=2"  ><%=assetcount%></a>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
							<%}%>
							<%if(isgoveproj==0){%>
							<%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM") || canlinkbudget ){%>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
								<TD class=Field>
								<a href="/fna/report/budget/FnaBudgetResourceDetail.jsp?resourceid=<%=id%>" ><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
							<%}%>

							<%if(software.equals("ALL") || software.equals("CRM")){%>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
								<TD class=Field>
								 <a href="/proj/search/SearchOperation.jsp?member=<%=id%>" ><%=projectcount%></a>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
							<%}%>
							<%}%>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
								<TD class=Field>
								<a href="/docs/search/DocSearchTemp.jsp?hrmresid=<%=id%>&docstatus=6" ><%=doccount%></a>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                                  <%
                                      String typeids = "0";


                                      while (CoTypeComInfo.next()) {
                                          String tmptypeid = CoTypeComInfo.getCoTypeid();
                                          String typename = CoTypeComInfo.getCoTypename();
                                          String typemanager = "," + CoTypeComInfo.getCoTypemanagerid() + ",";
                                          String typemembers = "," + CoTypeComInfo.getCoTypemembers() + ",";
                                          String typedepart = CoTypeComInfo.getCoTypendepartmentid();

                                          if (typemanager.indexOf("," + id + ",") != -1 && Util.getIntValue(typedepart, 0) == 1)
                                              typeids += "," + tmptypeid;


                                      }


                                      String sqlwhere = "where  ((  t1.creater="+id+" ) or t1.typeid in ("+typeids+"))";
                                      String searchsql = "select count(t1.id) from  cowork_items t1 where id in (select  distinct t1.id from cowork_items t1 "+sqlwhere+" ) ";
                                      RecordSet.executeSql(searchsql);
                                      RecordSet.next();
                                      String c=RecordSet.getString(1);
                                  %>
                                  <TR>
								<TD><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></TD>
								<TD class=Field>
								<a href="/cowork/coworkview.jsp?uid=<%=id%>" ><%=c%></a>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
							<%if(isgoveproj==0){%>
                                    <%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM") || canlinkexpense ){ %>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%></TD>
								<TD class=Field>
								<a href="/fna/report/expense/FnaExpenseResourceDetail.jsp?resourceid=<%=id%>" ><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
							<%}%>
							<%}%>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%>)</TD>
								<TD class=Field>
								<a href="/workflow/search/WFHrmSearchResult.jsp?hrmids=<%=id%>&nodetype=0&totalcounts=<%=RelatedRequestCount.getCount0()%>" ><%=RelatedRequestCount.getCount0()%></a>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>)</TD>
								<TD class=Field>
								<a href="/workflow/search/WFHrmSearchResult.jsp?hrmids=<%=id%>&nodetype=1&totalcounts=<%=RelatedRequestCount.getCount1()%>" ><%=RelatedRequestCount.getCount1()%></a>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%>)</TD>
								<TD class=Field>
								<a href="/workflow/search/WFHrmSearchResult.jsp?hrmids=<%=id%>&nodetype=2&totalcounts=<%=RelatedRequestCount.getCount2()%>" ><%=RelatedRequestCount.getCount2()%></A>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%>)</TD>
								<TD class=Field>
								<a href="/workflow/search/WFHrmSearchResult.jsp?hrmids=<%=id%>&nodetype=3&totalcounts=<%=RelatedRequestCount.getCount3()%>" ><%=RelatedRequestCount.getCount3()%></A>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>)</TD>
								<TD class=Field>
								<a href="/workflow/search/WFHrmSearchResult.jsp?hrmids=<%=id%>&totalcounts=<%=RelatedRequestCount.getTotalcount()%>" ><%=RelatedRequestCount.getTotalcount()%></A>
								</TD>
							</TR>
							<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                                </TBODY>
                              </TABLE>
                          <%}%>

	
	                    <%if(HrmListValidate.isValidate(26)){%>
	                    <table class=ViewForm width="100%">
	                      <colgroup> <col width="100%">
	                      <tbody>
	                      <tr class=Title>
	                        <th align=left>	<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%> </th>
	                      </tr>
	                      <tr class=Spacing style="height:2px">
	                        <td class=Line1 colspan=2></td>
	                      </tr>
	                      <% RecordSet.executeProc("HrmRoleMembers_SByResourceID",id);
	                        while(RecordSet.next()) {
	                        	RecordSet1.executeSql("select rolesmark from hrmroles where id = "+RecordSet.getString("roleid"));
	                        	RecordSet1.next();
	                        %>
	                      <tr>
	                        <td class=Field><%=Util.toScreen(RecordSet1.getString(1),user.getLanguage())%>
	                          ,
	                          <% String rolelevel = RecordSet.getString("rolelevel") ;
	                           String levelname = "" ;
	                           if(rolelevel.equals("2")) levelname = SystemEnv.getHtmlLabelName(140,user.getLanguage());
	                           if(rolelevel.equals("1")) levelname = SystemEnv.getHtmlLabelName(141,user.getLanguage());
	                           if(rolelevel.equals("0")) levelname = SystemEnv.getHtmlLabelName(124,user.getLanguage());
	                        %>
	                          <%=levelname%> </td>
	                      </tr>
	                      <%}%>
	                      </tbody>
	                    </table>
	                    <%}%>	
	          </td>

			 <td>&nbsp;</td>
				
	          <td valign="top">
						<%if(isgoveproj==0){%>
	                    <%if(software.equals("ALL") || software.equals("HRM")){%>
	                    <TABLE class=ViewForm>
	                    <COLGROUP>
	                    <COL width="70%">
	                    <COL width="30%">
	                    <TBODY>
	                    <%if(HrmListValidate.isValidate(27)){%>
	                    <TR class=Title>
	                    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16068,user.getLanguage())%></TH>
	                    </TR>
	                    <TR class=Spacing style="height:2px">
	                    <TD class=Line1 colSpan=2></TD>
	                    </TR>
	
	                    <%
	                    ArrayList al = new ArrayList();
	                    al = TrainComInfo.getTrainByResource(id);
	                    for(int i = 0; i<al.size(); i++){
	                    String trainid = (String)al.get(i);
	                    %>
	                    <tr >
	                    <td class=field>
	                     <a href="/hrm/train/train/HrmTrainEdit.jsp?id=<%=trainid%>" ><%=TrainComInfo.getTrainname(trainid)%></a>
	                    </td>
	                    <td class=field>
	                    </td>
	                    </tr>
	                    <%
	                    }
	                    %>
	                    <tr>
	                    <td><br></td>
	                    </tr>
	                    <%}%>
	                
	                    <%if(HrmListValidate.isValidate(28)){%>
	                    <TR class=Title>
	                    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16069,user.getLanguage())%></TH>
	                    </TR>
	                    <TR class=Spacing style="height:2px">
	                    <TD class=Line1 colSpan=2></TD>
	                    </TR>
	                    <%
	                    String applyworkflowid = "" ;
	                    rs.executeSql("select id from workflow_base  where formid = 48 and isbill='1' and isvalid = '1' ");
	                    if( rs.next() ) applyworkflowid = Util.null2String(rs.getString("id"));
	
	                    ArrayList al = new ArrayList();
	                    al = TrainPlanComInfo.getTrainPlanByResource(id);
	                    for(int i = 0; i<al.size(); i++){
	                    String trainplanid = (String)al.get(i);
	                    %>
	                    <tr >
	                    <td class=field>
	                      <a href="/hrm/train/trainplan/HrmTrainPlanEdit.jsp?id=<%=trainplanid%>" ><%=TrainPlanComInfo.getTrainPlanname(trainplanid)%></a>
	                    </td>
	                    <td class=field align=right>
	                     <%if(user.getUID()==Util.getIntValue(id) && !applyworkflowid.equals("")){%><a href="/workflow/request/AddRequest.jsp?workflowid=<%=applyworkflowid%>&TrainPlanId=<%=trainplanid%>" ><%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%></a><%}%>
	                    </td>
	                    </tr>
	                    <%
	                    }
	                    %>
	                    <tr>
	                    <td><br></td>
	                    </tr>
	                    <%}%>
	                    
	                    <TR class=Title>
	                    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15652,user.getLanguage())%></TH>
	                    </TR>
	                    <TR class=Spacing style="height:2px">
	                    <TD class=Line1 colSpan=2></TD>
	                    </TR>
	                    <%
	                    String sql = "" ;
	                    sql = "select a.id ,b.checkname,a.resourceid" +
	                    " from HrmByCheckPeople a , HrmCheckList b "+
	                    " where a.checkid = b.id and a.checkercount="+id +" and b.enddate>='"+currentdate+"' " ;
	                    rs.executeSql(sql);
	                    while(rs.next()) {
	                    String checkpeopleid = Util.null2String(rs.getString(1)) ;
	                    String checkname = Util.null2String(rs.getString(2)) ;
	                    String resourceid = Util.null2String(rs.getString(3)) ;
	                    %>
	                    <tr >
	                    <td class=field>
	                      <a href="/hrm/actualize/HrmCheckMark.jsp?id=<%=checkpeopleid%>" ><%=checkname%></a>
	                    </td>
	                    <td class=field>
	                    <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></td>
	                    </tr>
	                    <%
	                    }
	                    %>
	
	                    </TBODY>
	                    </TABLE>
	                    <%}%>
						<%}%>
	          </td>
	</tr>
	</table>
  </div>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
</form>

<script language=javascript>
  function doedit(){

    if(<%=operatelevel%>>0){
      location = "HrmResourceBasicEdit.jsp?id=<%=id%>&isView=1";
    }else{
        if(<%=isSelf%>){
          location = "HrmResourceContactEdit.jsp?id=<%=id%>&isView=1";
        }
    }
  }
  function dodelete(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
    document.resource.operation.value="delete";
    document.resource.submit();
    }
  }


  function sendmail(){
    var tmpvalue = "<%=email%>";
    while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if (tmpvalue=="" || tmpvalue.indexOf("@") <1 || tmpvalue.indexOf(".") <1 || tmpvalue.length <5) {
        alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
        return;
    }
    window.location = "/sendmail/HrmMailMerge.jsp?id=<%=id%>&fromPage="+encodeURIComponent(window.location);
  }


function doAddWorkPlan() {
	
	location.href = "/workplan/data/WorkPlan.jsp?resourceid=<%=id%>&add=1";
	
}

</script>
</BODY>
</HTML>

