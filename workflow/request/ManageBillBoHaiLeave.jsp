<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement" %>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<%
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息
%>
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="flowDoc1" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<%
ArrayList flowDocs=flowDoc1.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段
String codeField="";
if (flowDocs!=null&&flowDocs.size()>0)
{
codeField=""+flowDocs.get(0);
}
String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));
String newTNflag=Util.null2String((String)session.getAttribute("requestAddNewNodes"+user.getUID()));
String flowDocField=Util.null2String((String)session.getAttribute("requestFlowDocField"+user.getUID()));
String bodychangattrstr="";
if (docFlags.equals("")) docFlags=Util.null2String((String)session.getAttribute("requestAdd"+user.getUID()));

String isaffirmancebody=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"isaffirmance"));//是否需要提交确认
String reEditbody=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"reEdit"));//是否需要提交确认

boolean isprint = Util.null2String(request.getParameter("isprint")).equalsIgnoreCase("true") ;
int rqMessageType=-1;
int wfMessageType=-1;
String docCategory= "";
String sqlWfMessage = "select a.messagetype,b.docCategory,b.MessageType as wfMessageType from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
RecordSet.executeSql(sqlWfMessage);
if (RecordSet.next()) {
    rqMessageType=RecordSet.getInt("messagetype");
    wfMessageType=RecordSet.getInt("wfMessageType");
	docCategory= RecordSet.getString("docCategory");
}
String beagenter=""+user.getUID();
//获得被代理人
RecordSet.executeSql("select agentorbyagentid from workflow_currentoperator where usertype=0 and isremark='0' and requestid="+requestid+" and userid="+user.getUID()+" and nodeid="+nodeid+" order by id desc");
if(RecordSet.next()){
  int tembeagenter=RecordSet.getInt(1);
  if(tembeagenter>0) beagenter=""+tembeagenter;
}
 int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
 int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5); //从缓存中取
 if(maxUploadImageSize<=0){
 maxUploadImageSize = 5;
 }
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
 selectedfieldid = result.substring(0,result.indexOf(","));
 uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
 }
 boolean isCanuse = RequestManager.hasUsedType(workflowid);
 if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
 }

  String keywordismand="0";
String keywordisedit="0";
int titleFieldId=0;
int keywordFieldId=0;
RecordSet.execute("select titleFieldId,keywordFieldId from workflow_base where id="+workflowid);
if(RecordSet.next()){
	titleFieldId=Util.getIntValue(RecordSet.getString("titleFieldId"),0);
	keywordFieldId=Util.getIntValue(RecordSet.getString("keywordFieldId"),0);
}
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(workflowid,nodeid,0);
String isSignMustInput="0";
String needcheck10404 = "";
RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
	if("1".equals(isSignMustInput)){
		needcheck10404 = ",remarkText10404";
	}
}
%>
<form name="frmmain" method="post" action="BillBoHaiLeaveOperation.jsp" enctype="multipart/form-data" >
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>
<input type="hidden" name="htmlfieldids">

<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<!--请求的标题结束 -->
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<BR>


<TABLE class="ViewForm">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">

  <%//xwj for td1834 on 2005-05-22
    String isEdit_ = "-1";
    RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -1");
    if(RecordSet.next()){
   isEdit_ = Util.null2String(RecordSet.getString("isedit"));
    }

    //获得触发字段名 mackjoe 2005-07-22
    DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
    String trrigerfield=ddi.GetEntryTriggerFieldName();

  %>

  <!--新建的第一行，包括说明和重要性 -->
  <TR class="Spacing" style="height:1px;">
    <TD class="Line1" colSpan=2></TD>
  </TR>

  <%
  boolean editflag = true;//流程的处理人可以编辑流程的优先级和是否短信提醒
  if(isremark==1||isremark==8||isremark==9) editflag = false;//被转发人或被抄送人不能编辑
  if(editflag&&"0".equals(nodetype)&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
      <TD class=field>
          <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
          <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>

          <input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
          <input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
          <input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
        </TD>
    </TR>
    <TR style="height:1px;">
      <TD class="Line2" colSpan=2></TD>
    </TR>

  <%
        if (wfMessageType==1) {
  %>
                    <TR>
                      <TD > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                      <td class=field>
                            <span id=messageTypeSpan></span>
                            <input type=radio value="0" name="messageType"   <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
                            <input type=radio value="1" name="messageType"   <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
                            <input type=radio value="2" name="messageType"   <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
                          </td>
                    </TR>
                    <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
        <%}%>
  <%}else if(editflag&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
      <TD class=field>
          <%if("1".equals(isEdit_)&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
          <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=60  maxlength=100  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
          <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
          <%}else{%>
         <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
         <input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
          <%}%>

          <input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
          <input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
          <input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
        </TD>
    </TR>
    <TR style="height:1px;">
      <TD class="Line2" colSpan=2></TD>
    </TR>

  <%
        if (wfMessageType==1) {
  %>
                    <TR>
                      <TD > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                      <td class=field>
                            <span id=messageTypeSpan></span>
                            <input type=radio value="0" name="messageType"   <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
                            <input type=radio value="1" name="messageType"   <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
                            <input type=radio value="2" name="messageType"   <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
                          </td>
                    </TR>
                    <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
        <%}%>
  <%}else{%>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class=field>
         <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
         <input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
         <input type=hidden name=requestlevel value="<%=requestlevel%>">
       <input type=hidden name=messageType value="<%=rqMessageType%>"> 
        &nbsp;&nbsp;&nbsp;&nbsp;
        <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
        &nbsp;&nbsp;&nbsp;&nbsp;
          <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
          <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
          <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
        </td>
    </tr>  	   	<tr  style="height:1px;">
      <td class="Line1" colSpan=2></td>
    </tr>
    <!--第一行结束 -->
  <%}%>

<%
  String userannualinfo = HrmAnnualManagement.getUserAannualInfo(creater+"",currentdate);
  String thisyearannual = Util.TokenizerString2(userannualinfo,"#")[0];
  String lastyearannual = Util.TokenizerString2(userannualinfo,"#")[1];
  String allannual = Util.TokenizerString2(userannualinfo,"#")[2];    
  String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(""+creater, currentdate);
  String thisyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[0], 0);
  String lastyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[1], 0);
  String allpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[2], 0);
%>
<%

//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）

List fieldids=new ArrayList();             //字段队列
List fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
List languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
List fieldlabels=new ArrayList();          //单据的字段的label队列
List fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
List fieldtypes=new ArrayList();           //单据的字段的type队列
List fieldnames=new ArrayList();           //单据的字段的表字段名队列
List fieldvalues=new ArrayList();          //字段的值
List fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList fieldimgwidths=new ArrayList();
ArrayList fieldimgheights=new ArrayList();
ArrayList fieldimgnums=new ArrayList();
int fieldlen=0;  //字段类型长度
ArrayList fieldrealtype=new ArrayList();
String fielddbtype=""; 
int languagebodyid = user.getLanguage() ;
int detailno=0;
int detailsum=0;
String textheight = "4";//xwj for @td2977 20051111

    RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("id")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
        fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
        fieldtypes.add(Util.null2String(RecordSet.getString("type")));
        fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
        fieldviewtypes.add(Util.null2String(RecordSet.getString("viewtype")));
		fieldrealtype.add(Util.null2String(RecordSet.getString("fielddbtype")));
        fieldimgwidths.add(Util.null2String(RecordSet.getString("imgwidth")));
        fieldimgheights.add(Util.null2String(RecordSet.getString("imgheight")));
        fieldimgnums.add(Util.null2String(RecordSet.getString("textheight")));
          RecordSet_nf1.executeSql("select * from workflow_nodeform where nodeid = "+nodeid+" and fieldid = " + RecordSet.getString("id"));
        if(!RecordSet_nf1.next()){
        RecordSet_nf2.executeSql("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) values("+nodeid+","+RecordSet.getString("id")+",'1','1','0')");
        }
    }


// 查询每一个字段的值

    RecordSet.executeSql("select * from Bill_BoHaiLeave where id = " + billid) ;

    RecordSet.next();
    for(int i=0;i<fieldids.size();i++){
        String fieldname=(String)fieldnames.get(i);
        fieldvalues.add(Util.null2String(RecordSet.getString(fieldname)));
    }

String resourceId=Util.null2String(RecordSet.getString("resourceId"));


// 确定字段是否显示，是否可以编辑，是否必须输入
List isfieldids=new ArrayList();              //字段队列
List isviews=new ArrayList();              //字段是否显示队列
List isedits=new ArrayList();              //字段是否可以编辑队列
List ismands=new ArrayList();              //字段是否必须输入队列

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(Util.null2String(RecordSet.getString("isview")));
    isedits.add(Util.null2String(RecordSet.getString("isedit")));
    ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
}


boolean showOtherLeaveType=false;
boolean showAnnualInfo=false;
boolean showPSLInfo=false;
String selectNameLeaveType="";
String selectNameOtherLeaveType="";
String inputNameResourceId="";
String inputNameFromDate="";
String inputNameFromTime="";
String inputNameToDate="";
String inputNameToTime="";
String inputNameLeaveDays="";
boolean canEditForLeaveDays=true;

String lastyearannualdayslabel="";
String thisyearannualdayslabel="";
String allannualdayslabel="";
String lastyearpsldayslabel = "";
String thisyearpsldayslabel = "";
String allpsldayslabel = "";
// 得到每个字段的信息并在页面显示
int checkOtherLeaveType = -1;
for(int i=0;i<fieldids.size();i++){         // 循环开始



	int tmpindex = i ;
    if(isbill.equals("0")) tmpindex = fieldorders.indexOf(""+i);     // 如果是表单, 得到表单顺序对应的 i

	String fieldid=(String)fieldids.get(tmpindex);  //字段id

    if( isbill.equals("1")) {
        String viewtype = (String)fieldviewtypes.get(tmpindex) ;   // 如果是单据的从表字段,不显示
        if( viewtype.equals("1") ) continue ;
    }

    String isview="0" ;    //字段是否显示
	String isedit="0" ;    //字段是否可以编辑
	String ismand="0" ;    //字段是否必须输入
	int fieldimgwidth=0;                            //图片字段宽度
    int fieldimgheight=0;                           //图片字段高度
    int fieldimgnum=0;                              //每行显示图片个数

    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) {
        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
    }

    String fieldname = "" ;                         //字段数据库表中的字段名
    String fieldhtmltype = "" ;                     //字段的页面类型
    String fieldtype = "" ;                         //字段的类型
    String fieldlable = "" ;                        //字段显示名
    int languageid = 0 ;

    languageid = user.getLanguage() ;
    fieldname=(String)fieldnames.get(tmpindex);
     fieldhtmltype=(String)fieldhtmltypes.get(tmpindex);
     fieldtype=(String)fieldtypes.get(tmpindex);
		fielddbtype=(String)fieldrealtype.get(tmpindex);
     fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languageid );
     fieldimgwidth=Util.getIntValue((String)fieldimgwidths.get(tmpindex),0);
		fieldimgheight=Util.getIntValue((String)fieldimgheights.get(tmpindex),0);
		fieldimgnum=Util.getIntValue((String)fieldimgnums.get(tmpindex),0);

		String fieldvalue=Util.null2String((String)fieldvalues.get(tmpindex));

	 fieldlen=0;
	if ((fielddbtype.toLowerCase()).indexOf("varchar")>-1)
	{
	   fieldlen=Util.getIntValue(fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.length()-1));

	}

	if("1".equals(ismand))
    {
		if(!"otherLeaveType".equals(fieldname))
    		needcheck+=",field"+fieldid;
		else
			checkOtherLeaveType = 1;
    }


    if(("resourceId").equals(fieldname)){
		inputNameResourceId="field"+fieldid;
    }
    if(("fromDate").equals(fieldname)){
		inputNameFromDate="field"+fieldid;
    }
    if(("fromTime").equals(fieldname)){
		inputNameFromTime="field"+fieldid;
    }
    if(("toDate").equals(fieldname)){
		inputNameToDate="field"+fieldid;
    }
    if(("toTime").equals(fieldname)){
		inputNameToTime="field"+fieldid;
    }
    if(("leaveDays").equals(fieldname)){
		inputNameLeaveDays="field"+fieldid;
    }
    if(("leaveType").equals(fieldname)){
		selectNameLeaveType="field"+fieldid;
    }
    if(("otherLeaveType").equals(fieldname)){
		selectNameOtherLeaveType="field"+fieldid;	
    }
    if(("lastyearannualdays").equals(fieldname)){
        lastyearannualdayslabel="field"+fieldid;
    }
    if(("thisyearannualdays").equals(fieldname)){
        thisyearannualdayslabel="field"+fieldid;
    }
    if(("allannualdays").equals(fieldname)){
        allannualdayslabel="field"+fieldid;
    }
	if("lastyearpsldays".equals(fieldname)){
		lastyearpsldayslabel = "field"+fieldid;
	}
	if("thisyearpsldays".equals(fieldname)){
		thisyearpsldayslabel = "field"+fieldid;
	}
	if("allpsldays".equals(fieldname)){
		allpsldayslabel = "field"+fieldid;
	}

    // 下面开始逐行显示字段
    if(fieldname.equals("manager")&&isview.equals("0")) {
    %>
        <input type=hidden name="field<%=fieldid%>" value="<%=ResourceComInfo.getManagerID(""+beagenter)%>" />
    <%
        continue;
    }
    if(isview.equals("1")){         // 字段需要显示
%>

<%if(fieldhtmltype.equals("5")&&("otherLeaveType").equals(fieldname)&&!showOtherLeaveType){
%>
    <tr id=oTrOtherLeaveType style="display:none">
<%}else if(fieldhtmltype.equals("5")&&("otherLeaveType").equals(fieldname)){%>
    <tr id=oTrOtherLeaveType> 
<%}else if(fieldname.equals("lastyearannualdays")||fieldname.equals("thisyearannualdays")||fieldname.equals("allannualdays")){
   if(showAnnualInfo){
%>
    <tr id="field<%=fieldid%>tr"  style="display:block"> 
<%}else {%>
    <tr id="field<%=fieldid%>tr"  style="display:none"> 
<%}%>
<%}else if(fieldname.equals("lastyearpsldays")||fieldname.equals("thisyearpsldays")||fieldname.equals("allpsldays")){
	if(showPSLInfo){
%>
    <tr id="field<%=fieldid%>tr"  style="display:block"> 
<%}else {%>
    <tr id="field<%=fieldid%>tr"  style="display:none"> 
<%}%>
<%}else {%>
    <tr> 
<%}%>

      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,languageid)%></td>
      <td class=field>
      <%
        if(fieldhtmltype.equals("1")){                          // 单行文本框
            if(fieldtype.equals("1")){                          // 单行文本框中的文本
                if(isedit.equals("1") && isremark==0&&!fieldid.equals(codeField) && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
					if(keywordFieldId>0&&(""+keywordFieldId).equals(fieldid)){
%>
<button type=button  class=Browser  onclick="onShowKeyword(field<%=fieldid%>.getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(21517,user.getLanguage())%>"></button>
<%
					}
                    if(ismand.equals("1")) {
      %>
        <input datatype="text" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" size=50 value="<%=Util.toScreenForWorkflow(fieldvalue)%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));checkLength('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')<%if(titleFieldId>0&&keywordFieldId>0&&(""+titleFieldId).equals(fieldid)){%>;changeKeyword()<%}%>">
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
      <%

				    }else{%>
        <input datatype="text" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));checkLength('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')<%if(titleFieldId>0&&keywordFieldId>0&&(""+titleFieldId).equals(fieldid)){%>;changeKeyword()<%}%>" type=text class=Inputstyle name="field<%=fieldid%>" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> value="<%=Util.toScreenForWorkflow(fieldvalue)%>" size=50>
        <span id="field<%=fieldid%>span"></span>
      <%            }
			    }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=Util.toScreenForWorkflow(fieldvalue)%></span>
         <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=Util.toScreenForWorkflow(fieldvalue)%>" >
      <%
                }
                if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
            }
		    else if(fieldtype.equals("2")){                     // 单行文本框中的整型
			    if(isedit.equals("1") && isremark==0&& (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
				    if(ismand.equals("1")) {
      %>
        <input datatype="int" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" size=10 value="<%=fieldvalue%>"
		onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldid%>')" <%}else{%> onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" <%}%>>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
       <%

				    }else{%>
        <input datatype="int" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()"  <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldid%>')" <%}else{%> onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}%>>
        <span id="field<%=fieldid%>span"></span>
       <%           }
       if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
                }
                else {
      %>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="int" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
                }
		    }
		    else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
			    if(isedit.equals("1") && isremark==0&&!fieldname.equals("lastyearannualdays")&&!fieldname.equals("thisyearannualdays")&&!fieldname.equals("allannualdays")&&!fieldname.equals("lastyearpsldays")&&!fieldname.equals("thisyearpsldays")&&!fieldname.equals("allpsldays")  && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
				    if(ismand.equals("1")) {
       %>
        <input datatype="float" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" size=10 value="<%=fieldvalue%>"
       onKeyPress="ItemNum_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldid%>')" <%}else{%> onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" <%}%>>
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
       <%
    				}else{%>
        <input datatype="float" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" type=text class=Inputstyle name="field<%=fieldid%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemNum_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>  onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));datainput('field<%=fieldid%>')" <%}else{%> onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%}%>>
        <span id="field<%=fieldid%>span"></span>
       <%           }
       if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
                }
                else {
					if(("leaveDays").equals(fieldname)){
						canEditForLeaveDays=false;
        %>
                <input type=hidden name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <span id="leaveDaysSpan"><%=fieldvalue%></span>
        <%
					}else if(!fieldname.equals("lastyearannualdays")&&!fieldname.equals("thisyearannualdays")&&!fieldname.equals("allannualdays")&&!fieldname.equals("lastyearpsldays")&&!fieldname.equals("thisyearpsldays")&&!fieldname.equals("allpsldays")){
      %>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
					}else{
	   %>
	    <span id="field<%=fieldid%>span"><%if(fieldname.equals("lastyearannualdays")) out.println(lastyearannual);if(fieldname.equals("thisyearannualdays")) out.println(thisyearannual);if(fieldname.equals("allannualdays")) out.println(allannual);if(fieldname.equals("lastyearpsldays")) out.println(lastyearpsldays);if(fieldname.equals("thisyearpsldays")) out.println(thisyearpsldays);if(fieldname.equals("allpsldays")) out.println(allpsldays);%></span>          
	    <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="0" >
	   <%				
					}
                }
		    }
		    /*------------- xwj for td3131 20051116 begin----------*/
    else if(fieldtype.equals("4")){     // 单行文本框中的金额转换%>
            <table cols=2 id="field<%=fieldid%>_tab">
                <tr><td>
                <%
                    if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
                    if(ismand.equals("1")) {%>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" size=60
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')"
                            <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'));
                                datainput('field_lable<%=fieldid%>')"
                            <%}else{%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'))"
                            <%}%>
                        >
                    <span id="field_lable<%=fieldid%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
                    <%}else{%>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" size=60
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')"
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'));
                                datainput('field_lable<%=fieldid%>')"
                            <%}else{%>
                                onBlur="numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',field<%=fieldid%>.getAttribute('viewtype'))"
                            <%}%>
                        >
                    <%}%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%
                if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
                }else{%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>"  disabled="true" size=60>
                    <input datatype="float" type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%}%>
                </td></tr>
                <tr><td>
                    <input type=text class=Inputstyle size=60 name="field_chinglish<%=fieldid%>" readOnly="true">
                </td></tr>
                <script language="javascript">
                    $GetEle("field_lable"+<%=fieldid%>).value  = milfloatFormat(floatFormat(<%=fieldvalue%>));
                    $GetEle("field_chinglish"+<%=fieldid%>).value = numberChangeToChinese(<%=fieldvalue%>);
                </script>
            </table>
	    <%}
		    /*------------- xwj for td3131 20051116 end ----------*/

		  }                                                       // 单行文本框条件结束
	    else if(fieldhtmltype.equals("2")){                     // 多行文本框
	    /*-----xwj for @td2977 20051111 begin-----*/
	    if(isbill.equals("0")){
			 rscount.executeSql("select textheight from workflow_formdict where id = " + fieldid);
			 if(rscount.next()){
			 textheight = rscount.getString("textheight");
			 }
			 }
			    /*-----xwj for @td2977 20051111 begin-----*/
		    if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
			    if(ismand.equals("1")) {
       %>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>"  <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%>  onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));checkLengthfortext('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"
		rows="<%=textheight%>" cols="40" style="width:80%;word-break:break-all;word-wrap:break-word" ><%=fieldtype.equals("2")?Util.encodeAnd(fieldvalue):Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldid%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
       <%
			    }else{
       %>
      <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" rows="<%=textheight%>" onchange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));checkLengthfortext('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" cols="40" <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onBlur="datainput('field<%=fieldid%>');" <%}%> style="width:80%;word-break:break-all;word-wrap:break-word"><%=fieldtype.equals("2")?Util.encodeAnd(fieldvalue):Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
      <span id="field<%=fieldid%>span"></span>
       <%       }%>
	   <script>$GetEle("htmlfieldids").value += "field<%=fieldid%>;<%=Util.toScreen(fieldlable,languagebodyid)%>,";</script>
       <%  if (fieldtype.equals("2")) {%>
		    <script>
			   function funcField<%=fieldid%>(){
			   	FCKEditorExt.initEditor('frmmain','field<%=fieldid%>',<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
				<%if(ismand.equals("1"))
					out.println("FCKEditorExt.checkText('field"+fieldid+"span');");%>
				    FCKEditorExt.toolbarExpand(false);
			   }

				if (window.addEventListener){
				    window.addEventListener("load", funcField<%=fieldid%>, false);
				}else if (window.attachEvent){
				    window.attachEvent("onload", funcField<%=fieldid%>);
				}else{
				    window.onload=funcField<%=fieldid%>;
				}							
			</script>
			
			<%}%>  
			<%
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }}else {if(fieldtype.equals("2")){%>
        <span id="field<%=fieldid%>span" style="word-wrap:break-word"><%=fieldvalue%></span>
         <textarea name="field<%=fieldid%>" style="display:none"><%=Util.encodeAnd(fieldvalue)%></textarea>
<%
				}else{
%>
        <span id="field<%=fieldid%>span" style="word-break:break-all;word-wrap:break-word"><%=fieldvalue%></span>
         <textarea name="field<%=fieldid%>" style="display:none"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
<%
				}
      %>

      <%
            }
	    }                                                         // 多行文本框条件结束
	    else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl =BrowserComInfo.getLinkurl(fieldtype);   // 浏览值点击的时候链接的url
            String showname = "";                                                   // 值显示的名称
            String showid = "";                                                     // 值
            String hiddenlinkvalue="";    

             String tablename=""; //浏览框对应的表,比如人力资源表
             String columname=""; //浏览框对应的表名称字段
             String keycolumname="";   //浏览框对应的表值字段
            // 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
            if( (fieldtype.equals("37")||(fieldtype.equals("9")&&docFlags.equals("1"))) && fieldid.equals(docfileid) && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
               if (fieldtype.equals("9")&&docFlags.equals("1"))
               fieldvalue=newdocid ;
               else
               fieldvalue += newdocid ;
            }
            
            if(fieldname.equals("manager")){
                fieldvalue = ResourceComInfo.getManagerID(""+beagenter);
                isview = "1";
                isedit = "0";
                ismand = "0";
                linkurl = "";
            }



            if(fieldtype.equals("2") ||fieldtype.equals("19")  ){
				fieldvalue = fieldvalue.trim();
				showname=fieldvalue; // 日期时间
			}else if(!fieldvalue.equals("")) {
                ArrayList tempshowidlist=Util.TokenizerString(fieldvalue,",");
                if(fieldtype.equals("8") || fieldtype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("1") ||fieldtype.equals("17")||fieldtype.equals("165")||fieldtype.equals("166")){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                          	{
                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                          	}else{
								showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
							}
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
				else if(fieldtype.equals("160")){
                    //角色人员
                    for(int k=0;k<tempshowidlist.size();k++){
                       if(!linkurl.equals("")){
                           showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
				else if(fieldtype.equals("7") || fieldtype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("4") || fieldtype.equals("57")|| fieldtype.equals("167")|| fieldtype.equals("168")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("9") || fieldtype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){

                          if (fieldtype.equals("9")&&docFlags.equals("1"))
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//????
                       String tempDoc=""+tempshowidlist.get(k);
                       String tempDocView="0";
					   if(isedit.equals("1") && isremark==0){
						   tempDocView="1";
					   }
                       showname+="<a href='javascript:createDoc("+fieldid+","+tempDoc+","+tempDocView+")' >"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp<button type=button  id='createdoc' style='display:none' class=AddDocFlow onclick=createDoc("+fieldid+","+tempDoc+","+tempDocView+")></button>";

                        }
                        else
                        {
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_blank'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldtype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("16") || fieldtype.equals("152") || fieldtype.equals("171")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                            tempnum++;
                            session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(k));
                            session.setAttribute("slinkwfnum",""+tempnum);
                            session.setAttribute("haslinkworkflow","1");
                            hiddenlinkvalue+="<input type=hidden name='slink"+fieldid+"_rq"+tempshowidlist.get(k)+"' value="+tempnum+">";
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&wflinkno="+tempnum+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
//add by fanggsh for TD4528   20060621 begin
                else if(fieldtype.equals("141")){
                    //人力资源条件
					showname+=ResourceConditionManager.getFormShowName(fieldvalue,languageid);
                }
//add by fanggsh for TD4528   20060621 end
                else{
                     tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                     columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                     keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段

                    //add by wang jinyong
                    HashMap temRes = new HashMap();

                    if(fieldvalue.indexOf(",")!=-1){
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }

                    RecordSet.executeSql(sql);
                    while(RecordSet.next()){
                        showid = Util.null2String(RecordSet.getString(1)) ;
                        String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                        if(!linkurl.equals("")){
                             showname += "<a href='"+linkurl+showid+"' target='_new'>"+tempshowname+"</a>&nbsp";
                        }else{
                            showname +=tempshowname+" ";
                        }
                    }
                }
            }

            //add by dongping
            //永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表
            if (fieldtype.equals("118")) {
            	showname ="<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>查看会议室使用情况</a>" ;
             }
            if(fieldtype.equals("161")){//自定义单选
			showname = "";                                   // 新建时候默认值显示的名称
			String showdesc="";
		    showid =fieldvalue;                                     // 新建时候默认值
			try{
            Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
            BrowserBean bb=browser.searchById(showid);
			String desc=Util.null2String(bb.getDescription());
			String name=Util.null2String(bb.getName());
			showname="<a title='"+desc+"'>"+name+"</a>&nbsp";
			}catch(Exception e){
			}
			}
			if(fieldtype.equals("162")){//自定义多选
            showname = "";                                   // 新建时候默认值显示的名称
		    showid =fieldvalue;                                     // 新建时候默认值
			try{
            Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
			List l=Util.TokenizerString(showid,",");
            for(int j=0;j<l.size();j++){
		    String curid=(String)l.get(j);
            BrowserBean bb=browser.searchById(curid);
			String name=Util.null2String(bb.getName());
			//System.out.println("showname:"+showname);
			String desc=Util.null2String(bb.getDescription());
		    showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
			}
			}catch(Exception e){
			}
			}
            if(isedit.equals("1") && isremark==0 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){
//add by fanggsh 20060621 for TD4528 begin
	            if(("fromDate").equals(fieldname)||("fromTime").equals(fieldname)||("toDate").equals(fieldname)||("toTime").equals(fieldname)){%>
		<button type=button  class=Browser  onclick="onShowLeaveTime('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
<%
				}else if(fieldtype.equals("160")){
                rsaddop.execute("select a.level_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldid+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+") ");
				String roleid="";
				if (rsaddop.next())

				{
				roleid=rsaddop.getString(1);
				}
%>
        <button type=button  class=Browser  onclick="onShowResourceRole('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'),'<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>"></button>
<%
			  }
            else if(fieldtype.equals("161")||fieldtype.equals("162")){
             url+="?type="+fielddbtype;
		    %>
		    <button type=button  class=Browser  onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))" ></button>
		    <%
            }
              else if(fieldtype.equals("141")){
%>
        <button type=button  class=Browser  onclick="onShowResourceConditionBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
<%
			  } else {
//add by fanggsh 20060621 for TD4528 end
                if( !fieldtype.equals("37") && !fieldtype.equals("9")) {    //  多文档特殊处理
	   %>
        <button type=button  class=Browser 
		<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'));datainput('field<%=fieldid%>');"		
		<%}else{%>
		onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))"
		<%}%> 
		title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
		</button>
	   			
       <%} else if(fieldtype.equals("37")){                         // 如果是多文档字段,加入新建文档按钮
       %>
        <button type=button  class=AddDocFlow onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp;<button type=button  class=AddDocFlow onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
       <% }else if(fieldtype.equals("9")&&fieldid.equals(flowDocField)){
		     if(!"1".equals(newTNflag)){
	   %>
		<button type=button  class=Browser 
		<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'));datainput('field<%=fieldid%>');"	
		<%}else{%>
		onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))"
		<%}%> 
		title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
		</button>
	   <%}
	   }else{%>
	    <button type=button  class=Browser <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
	      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>');datainput('field<%=fieldid%>','<%=ismand%>');"
	   <%}else{%>
		  onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>">
	    </button>
		<%}
	    if (fieldtype.equals("9") && fieldid.equals(flowDocField)){%>
	    <span id="CreateNewDoc">
			 <%if(docFlags.equals("1")&&fieldvalue.equals(""))  ///????????s
           {%>
           <button type=button  id="createdoc" class=AddDocFlow onclick="createDoc('<%=fieldid%>','','1')" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
           <%}
            }%></span><%
            }
            }
       %>
        <span id="field<%=fieldid%>span"><%=showname%>
       <%
            if( ismand.equals("1") && fieldvalue.equals("")){
       %>
        <img src="/images/BacoError.gif" align=absmiddle>
       <%
            }
       %>
        </span>
        <%if(fieldtype.equals("87")){%>
        <A href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193,user.getLanguage())%></A>
        <%}%>
		   <%if (fieldtype.equals("9")||fieldtype.equals("161")||fieldtype.equals("162"))  {%>
		    <input type=hidden viewtype="<%=ismand%>" name="field<%=fieldid%>" value="<%=fieldvalue%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" >
		   <%} else {%>
		   <input type=hidden viewtype="<%=ismand%>" name="field<%=fieldid%>" value="<%=fieldvalue%>"  temptitle="<%=Util.toScreen(fieldlable,languageid)%>" onpropertychange="checkLengthbrow('field<%=fieldid%>','field<%=fieldid%>span','<%=fieldlen%>','<%=Util.toScreen(fieldlable,languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>',field<%=fieldid%>.getAttribute('viewtype'))">
			 <%}%>
           <%=hiddenlinkvalue%>
       <%
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        }                                                       // 浏览按钮条件结束
	    else if(fieldhtmltype.equals("4")) {                    // check框
	   %>
        <input type=checkbox viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" value=1 name="field<%=fieldid%>" <%if(isedit.equals("0") || isremark==1 || (isaffirmancebody.equals("1") && nodetype.equals("0") && !reEditbody.equals("1"))){%> DISABLED <%}%> <%if(trrigerfield.indexOf("field"+fieldid)>=0){%> onChange="datainput('field<%=fieldid%>');" <%}%> <%if(fieldvalue.equals("1")){%> checked <%}%> >
        <%if(isedit.equals("0") || isremark==1 || (isaffirmancebody.equals("1") && nodetype.equals("0") && !reEditbody.equals("1"))){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=fieldvalue%>" >
        <%}%>
       <%
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        }                                                      // check框条件结束
        else if(fieldhtmltype.equals("5")){                     // 选择框   select
		if(("leaveType").equals(fieldname)&&fieldvalue.equals("4")){showOtherLeaveType=true;}//显示其它请假类型
        if(("otherLeaveType").equals(fieldname)&&fieldvalue.equals("2")&&showOtherLeaveType){showAnnualInfo=true;}//显示年假信息
		if(("otherLeaveType").equals(fieldname)&&fieldvalue.equals("11")&&showOtherLeaveType){showPSLInfo = true;}
        String onChangeString="";

		if(trrigerfield.indexOf("field"+fieldid)>=0){
			onChangeString+=";datainput('field"+fieldid+"')";
		}

		if(selfieldsadd.indexOf(fieldid)>=0){
			onChangeString+=";changeshowattr('"+fieldid+"_0',this.value,-1,"+workflowid+","+nodeid+")";
		}

		if(("leaveType").equals(fieldname)){
			onChangeString+=";changeDisplay(this.value)";  
		}

		if(("otherLeaveType").equals(fieldname)){
			onChangeString+=";dispalyannualinfo(this)";
		}

		if(!onChangeString.equals("")){
			onChangeString=onChangeString.substring(1);
		}

	   %>
        <select class=inputstyle  viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" name="field<%=fieldid%>" onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%if(isedit.equals("0") || isremark==1 || (isaffirmancebody.equals("1") && nodetype.equals("0") && !reEditbody.equals("1"))){%> DISABLED <%}%>
<%if(("otherLeaveType").equals(fieldname)){
%>
		  id=selectOtherLeaveType 
<%}%>			
		<%if(!onChangeString.equals("")){%> onChange="<%=onChangeString%>" <%}%>>
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
            // 查询选择框的所有可以选择的值
            //rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+isbill);
	   rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);
             boolean checkempty = true;//xwj for td3313 20051206
			      String finalvalue = "";//xwj for td3313 20051206
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                 /* -------- xwj for td3313 20051206 begin -*/
                 if(tmpselectvalue.equals(fieldvalue)){
				          checkempty = false;
				          finalvalue = tmpselectvalue;
				         }
				         /* -------- xwj for td3313 20051206 end -*/
	   %>
	    <option value="<%=tmpselectvalue%>" <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
	   <%
            }
           if(selfieldsadd.indexOf(fieldid)>=0) bodychangattrstr+="changeshowattr('"+fieldid+"_0','"+finalvalue+"',-1,"+workflowid+","+nodeid+");";
       %>
	    </select>

	    <!--xwj for td3313 20051206 begin-->
	    <span id="field<%=fieldid%>span">
	    <%
	     if(ismand.equals("1") && checkempty){
	    %>
       <img src='/images/BacoError.gif' align=absMiddle>
      <%
            }
       %>
	     </span>
	    <!--xwj for td3313 20051206 end-->

        <%if(isedit.equals("0") || isremark==1 || (isaffirmancebody.equals("1") && nodetype.equals("0") && !reEditbody.equals("1"))){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=finalvalue%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" >
        <%}%>
       <%
            if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        }else if(fieldhtmltype.equals("6")){
        %>
          <%if( isedit.equals("1") && isremark != 1 && (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody.equals("1"))){%>
          <!--modify by xhheng @20050511 for 1803-->
          <table cols=3 id="field<%=fieldid%>_tab">
            <tbody >
            <col width="50%" >
            <col width="25%" >
            <col width="25%">
          <%
          if(!fieldvalue.equals("")) {
            sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
            RecordSet.executeSql(sql);
            int linknum=-1;
            int imgnum=fieldimgnum;
            boolean isfrist=false;
            while(RecordSet.next()){
              isfrist=false;   
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);

              DocImageManager.resetParameter();
              DocImageManager.setDocid(Integer.parseInt(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }

              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              if(fieldtype.equals("2")){
              if(linknum==0){
              isfrist=true;
              %>
            <tr>
                <td colSpan=3>
                    <table cellspacing="0" cellpadding="0">
                        <tr>
              <%}
                  if(imgnum>0&&linknum>=imgnum){
                      imgnum+=fieldimgnum;
                      isfrist=true;
              %>
              </tr>
              <tr>
              <%
                  }
              %>
                  <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td <%if(!isfrist){%>style="padding-left:15"<%}%>>
                     <table cellspacing="0" cellpadding="0">
                      <tr>
                          <td colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand;margin:auto;" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>);return false;'>[<span style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>]</a>
                                    <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><b><font COLOR="#FF0033">√</font></b><span></td>

                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span  style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>]</a>
                              </td>
                      </tr>
                        </table>
                    </td>
              <%}else{%>

          <tr>
            <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0" >
            <td >
              <%=imgSrc%>

              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a  style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>',1)"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp

              <%}%>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td >
                <button type=button  class=btnFlow accessKey=1  onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>)'><u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
                </button><span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden">
                    <b><font COLOR="#FF0033">√</font></b>
                  <span>
            </td>
            <%if(accessoryCount==1){%>
            <td >
              <span id = "selectDownload">
                  <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
                  </button>
              </span>
            </td>
            <%}%>
          </tr>
             <%}}
            if(fieldtype.equals("2")&&linknum>-1){%>
            </tr></table></td></tr>
            <%}%>
            <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum+1%>>
            <input type=hidden name="field<%=fieldid%>_idnum_1" value=<%=linknum+1%>>
          <%}%>
          <tr>
            <td colspan=3>
             <%
            String mainId="";
            String subId="";
            String secId="";
          if(docCategory!=null && !docCategory.equals("")){
            mainId=docCategory.substring(0,docCategory.indexOf(','));
            subId=docCategory.substring(docCategory.indexOf(',')+1,docCategory.lastIndexOf(','));
            secId=docCategory.substring(docCategory.lastIndexOf(',')+1,docCategory.length());
          }
          String picfiletypes="*.*";
          String filetypedesc="All Files";
          if(fieldtype.equals("2")){
              picfiletypes=BaseBean.getPropValue("PicFileTypes","PicFileTypes");
              filetypedesc="Images Files";
          }
          boolean canupload=true;
                if(uploadType == 0){if("".equals(mainId) && "".equals(subId) && "".equals(secId)){
                    canupload=false;
            %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}}else if(!isCanuse){
               canupload=false;
           %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}
           if(canupload){
           %>
            <script>
          var oUpload<%=fieldid%>;
          function fileupload<%=fieldid%>() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldid%>",
                cancelButtonId : "btnCancel<%=fieldid%>",
                uploadspan : "field<%=fieldid%>span",
                uploadfiedid : "field<%=fieldid%>"
            },
            debug: false,
            button_image_url : "/js/swfupload/add.png",
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldid%>",
            button_width: 100,
            button_height: 18,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
            button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 0,
            button_text_left_padding: 18,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            // The event handler functions are defined in handlers.js
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_1,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };


        try {
            oUpload<%=fieldid%>=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileupload<%=fieldid%>);
          	if (window.addEventListener){
			    window.addEventListener("load", fileupload<%=fieldid%>, false);
			}else if (window.attachEvent){
			    window.attachEvent("onload", fileupload<%=fieldid%>);
			}else{
			    window.onload=fileupload<%=fieldid%>;
			}
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolder<%=fieldid%>"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldid%>.cancelQueue();showmustinput(oUpload<%=fieldid%>);" id="btnCancel<%=fieldid%>">
									<span><img src="/js/swfupload/delete.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span id="uploadspan">(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="field<%=fieldid%>span">
				<%
				 if(ismand.equals("1")&&fieldvalue.equals("")){
				%>
			   <img src='/images/BacoError.gif' align=absMiddle>
			  <%
					}
			   %>
	     </span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>"  viewtype="<%=ismand%>" value="<%=fieldvalue%>">
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgress<%=fieldid%>">
                  </div>
                  <div id="divStatus<%=fieldid%>"></div>
              </td>
          </tr>
      </TABLE>
            <%}%>
          <input type=hidden name='mainId' value=<%=mainId%>>
          <input type=hidden name='subId' value=<%=subId%>>
          <input type=hidden name='secId' value=<%=secId%>>
             </td>
          </tr>
      </TABLE>
          <%}else{
          if(!fieldvalue.equals("")) {
            %>
          <table cols=3 id="field<%=fieldid%>_tab">
            <tbody >
            <col width="50%" >
            <col width="25%" >
            <col width="25%">
            <%
            sql="select id,docsubject,accessorycount,SecCategory from docdetail where id in("+fieldvalue+") order by id asc";
            int linknum=-1;
            boolean isfrist=false;
            int imgnum=fieldimgnum;
            RecordSet.executeSql(sql);
            while(RecordSet.next()){
              isfrist=false;
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);
              String SecCategory=Util.null2String(RecordSet.getString(4));
              DocImageManager.resetParameter();
              DocImageManager.setDocid(Integer.parseInt(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }
              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              boolean nodownload=SecCategoryComInfo1.getNoDownload(SecCategory).equals("1")?true:false;
              if(fieldtype.equals("2")){
              if(linknum==0){
              isfrist=true;
              %>
            <tr>
                <td colSpan=3>
                    <table cellspacing="0" cellpadding="0">
                        <tr>
              <%}
                  if(imgnum>0&&linknum>=imgnum){
                      imgnum+=fieldimgnum;
                      isfrist=true;
              %>
              </tr>
              <tr>
              <%
                  }
              %>
                  <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td <%if(!isfrist){%>style="padding-left:15"<%}%>>
                     <table cellspacing="0" cellpadding="0">
                      <tr>
                          <td colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand;margin:auto;" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <%
                                  if (!nodownload) {
                              %>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span  style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>]</a>
                              </td>
                              <%}%>
                      </tr>
                        </table>
                    </td>
              <%}else{
              %>  
              <tr>
              <td colspan=3>
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>',0)"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%}%>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>> <!--xwj for td2893 20051017-->
              <%if((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload){%>
                <span id = "selectDownload">
                  <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	(<%=docImagefileSize/1000%>K)
                  </button>
                </span>
              </td>
              <%}%>
              </tr>
              <%}}
            if(fieldtype.equals("2")&&linknum>-1){%>
            </tr></table></td></tr>
            <%}%>
              <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum+1%>>
              <input type=hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
              </tbody>
              </table>
              <%
            }
          }
        }     // 选择框条件结束 所有条件判定结束
       else if(fieldhtmltype.equals("7")){//特殊字段
           if(isbill.equals("0")) out.println(Util.null2String((String)specialfield.get(fieldid+"_0")));
           else out.println(Util.null2String((String)specialfield.get(fieldid+"_1")));
       }
		
       %>
      </td>
    </tr>

<%if(fieldhtmltype.equals("5")&&("otherLeaveType").equals(fieldname)&&!showOtherLeaveType){
%>
    <tr class="Spacing"  id=oTrOtherLeaveTypeLine2  style="height:1px;" style="display:none">
      <td class="Line2" colspan=2></td>
    </tr>
<%}else if(fieldhtmltype.equals("5")&&("otherLeaveType").equals(fieldname)){%>
    <tr class="Spacing"  style="height:1px;" id=oTrOtherLeaveTypeLine2 >
      <td class="Line2" colspan=2></td>
    </tr>
<%}else if(fieldname.equals("lastyearannualdays")||fieldname.equals("thisyearannualdays")||fieldname.equals("allannualdays")){%>
    <tr class="Spacing" style="height:1px;" id="field<%=fieldid%>line"  <%if(showAnnualInfo) out.println("style='display:block'");else out.println("style='display:none'");%>>
      <td class="Line2" colspan=2></td>
    </tr>
<%}else if(fieldname.equals("lastyearpsldays")||fieldname.equals("thisyearpsldays")||fieldname.equals("allpsldays")){%>
    <tr class="Spacing" style="height:1px;" <%if(showPSLInfo) out.println("style='display:block'"); else out.println("style='display:none'");%>>
      <td class="Line2" colspan=2></td>
    </tr>
<%}else{%>
    <tr class="Spacing" style="height:1px;">
      <td class="Line2" colspan=2></td>
    </tr>
<%}%>

<%
    }else{                              // 不显示的作为 hidden 保存信息
        if (fieldhtmltype.equals("6")){   
			if (!fieldvalue.equals("")){
				ArrayList fieldvalueas=Util.TokenizerString(fieldvalue,",");
				int linknum=-1;
				for(int j=0;j<fieldvalueas.size();j++){
					linknum++;
					String showid = Util.null2String(""+fieldvalueas.get(j)) ;
%>
                    <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>

<%
				}
%>
                <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum+1%>>
          <%
			}
        }
		    if (fieldhtmltype.equals("2")&&fieldtype.equals("2")) {
%>
	            <textarea name="field<%=fieldid%>" style="display:none"><%=fieldvalue%></textarea>
<%
		    } else {
%>
	            <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
<%
		    }
    }
}       // 循环结束
%>

</table>


	<jsp:include page="/workflow/request/WorkflowManageSignForBill.jsp" flush="true">
	    <jsp:param name="requestid" value="<%=requestid%>" />
	    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
	    <jsp:param name="requestmark" value="<%=requestmark%>" />
	    <jsp:param name="creater" value="<%=creater%>" />
	    <jsp:param name="creatertype" value="<%=creatertype%>" />
	    <jsp:param name="deleted" value="<%=deleted%>" />
	    <jsp:param name="billid" value="<%=billid%>" />
	    <jsp:param name="workflowid" value="<%=workflowid%>" />
	    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
	    <jsp:param name="formid" value="<%=formid%>" />
	    <jsp:param name="nodeid" value="<%=nodeid%>" />
	    <jsp:param name="nodetype" value="<%=nodetype%>" />
	    <jsp:param name="isreopen" value="<%=isreopen%>" />
	    <jsp:param name="isreject" value="<%=isreject%>" />
	    <jsp:param name="isremark" value="<%=isremark%>" />
			<jsp:param name="currentdate" value="<%=currentdate%>" />
			<jsp:param name="docfileid" value="<%=docfileid%>" />
	    <jsp:param name="newdocid" value="<%=newdocid%>" />
	    <jsp:param name="topage" value="<%=topage%>" />
	</jsp:include>

<input type=hidden name="requestid" value=<%=requestid%>>           <!--请求id-->
<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">       <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">                     <!--当前节点类型-->
<input type=hidden name="src">                                <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="0">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">             <!--单据id-->

<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->
<input type=hidden name ="topage" value="<%=topage%>">				<!--返回的页面-->
<input type=hidden name ="needcheck" value="<%=needcheck+needcheck10404%>">
<input type=hidden name ="inputcheck" value="">

</form>


<script language="javascript">

<%=bodychangattrstr%>

function openDocExt(showid,versionid,docImagefileid,isedit){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
    
	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>");
	}
}

function openAccessory(fileId){ 
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>");
}

function onNewDoc(fieldid) {
	$GetEle("frmmain").action = "RequestOperation.jsp" ;
    $GetEle("frmmain").method.value = "docnew_"+fieldid ;
    $GetEle("frmmain").src.value='save';
    //附件上传
        StartUploadAll();
        checkuploadcomplet();
}


function doTriggerInit(){
    var tempS = "<%=trrigerfield%>";
    var tempA = tempS.split(",");
    for(var i=0;i<tempA.length;i++){
        datainput(tempA[i]);
    }
} 
function datainput(parfield){                <!--数据导入-->
      //var xmlhttp=XmlHttp.create();
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
      <%
          List Linfieldname=ddi.GetInFieldName();
          List Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          StrData+="&<%=temp%>="+$GetEle("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          StrData+="&<%=temp%>="+$GetEle("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
      %>
      //alert(StrData);
      $GetEle("datainputform").src="DataInputFrom.jsp?"+StrData;
      //xmlhttp.open("POST", "DataInputFrom.jsp", false);
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }


</script>


  <script language="javascript">
    function doSave(){          <!-- 点击保存按钮 -->
	    if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value)&&checkOtherLeaveType2()) {
            //$GetEle("frmmain").src.value='save';
            //jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
            //$GetEle("frmmain").submit();
			//checkOtherLeaveType(null,"save");
            checkleavedays(null,"save");
        }
	}

    function doSave_n(){          <!-- 点击保存按钮 -->
	    if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value)&&checkOtherLeaveType2()) {
            //$GetEle("frmmain").src.value='save';
            //jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
            //$GetEle("frmmain").submit();
			//checkOtherLeaveType(null,"save");
            checkleavedays(null,"save");
        }
	}

    function doSubmit(obj){     <!-- 点击提交 --> 
    	getRemarkText_log();
	    if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value)&&checkOtherLeaveType2()){
                    //$GetEle("frmmain").src.value='submit';
                    //jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
                    //$GetEle("frmmain").submit();
                    //obj.disabled=true;
					//checkOtherLeaveType(obj,"submit");
                    checkleavedays(obj,"submit");
	    }
    }

    function doRemark(){        <!-- 点击被转发的提交按钮 -->

            $GetEle("frmmain").isremark.value='1';
            $GetEle("frmmain").src.value='save';
            jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
            //附件上传
        StartUploadAll();
        checkuploadcomplet();

	}



	function doReject(){        <!-- 点击退回 -->

            $GetEle("frmmain").src.value='reject';
               <%--added by xwj for td2104 on 2005-8-1--%>
                <%--$GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;--%>
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
        if(onSetRejectNode()){
            //附件上传
        StartUploadAll();
        checkuploadcomplet();
        }

    }

	function doReopen(){        <!-- 点击重新激活 -->

            $GetEle("frmmain").src.value='reopen';
            $GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
            jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
            //附件上传
        StartUploadAll();
        checkuploadcomplet();

	}

	function doDelete(){        <!-- 点击删除 -->

            if(confirm("你确定删除该工作流吗？")) {
                $GetEle("frmmain").src.value='delete';
                $GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
                //附件上传
        StartUploadAll();
        checkuploadcomplet();
            }
    }
	function checkOtherLeaveType2()
	{
		<%if(checkOtherLeaveType==1){%>
		if("<%=selectNameLeaveType%>"==""||"<%=selectNameOtherLeaveType%>"==""||"<%=inputNameResourceId%>"==""||"<%=inputNameFromDate%>"==""){
			return true;
		}
		if($GetEle("<%=selectNameLeaveType%>").value=='4')
		{
			var v = $GetEle("<%=selectNameOtherLeaveType%>").value;
			if(v=="")
			{
				alert("\""+$GetEle("<%=selectNameOtherLeaveType%>").getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
				return false;
			}
		}
		<%}%>
		return true;
	}
function onAddPhrase(phrase){            <!-- 添加常用短语 -->
	if(phrase!=null && phrase!=""){
		$GetEle("remarkSpan").innerHTML = "";
		try{
			var remarkHtml = FCKEditorExt.getHtml("remark");
			var remarkText = FCKEditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				FCKEditorExt.setHtml(phrase,"remark");
			}else{
				FCKEditorExt.setHtml(remarkHtml+"<p>"+phrase+"</p>","remark");
			}
		}catch(e){}
	}
}

function changeDisplay(objval){

    //隐藏年假信息
     if($GetEle("<%=lastyearannualdayslabel%>tr")!=null){
        $GetEle("<%=lastyearannualdayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=thisyearannualdayslabel%>tr")!=null){
        $GetEle("<%=thisyearannualdayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=allannualdayslabel%>tr")!=null){
        $GetEle("<%=allannualdayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=lastyearannualdayslabel%>line")!=null){
        $GetEle("<%=lastyearannualdayslabel%>line").style.display='none';
     }
     if($GetEle("<%=thisyearannualdayslabel%>line")!=null){
        $GetEle("<%=thisyearannualdayslabel%>line").style.display='none';
     }
     if($GetEle("<%=allannualdayslabel%>line")!=null){
        $GetEle("<%=allannualdayslabel%>line").style.display='none';
     }
     if($GetEle("<%=lastyearpsldayslabel%>tr")!=null){
         $GetEle("<%=lastyearpsldayslabel%>tr").style.display='none';
      }
      if($GetEle("<%=thisyearpsldayslabel%>tr")!=null){
         $GetEle("<%=thisyearpsldayslabel%>tr").style.display='none';
      }
      if($GetEle("<%=allpsldayslabel%>tr")!=null){
         $GetEle("<%=allpsldayslabel%>tr").style.display='none';
      }
      if($GetEle("<%=lastyearpsldayslabel%>line")!=null){
         $GetEle("<%=lastyearpsldayslabel%>line").style.display='none';
      }
      if($GetEle("<%=thisyearpsldayslabel%>line")!=null){
         $GetEle("<%=thisyearpsldayslabel%>line").style.display='none';
      }
      if($GetEle("<%=allpsldayslabel%>line")!=null){
         $GetEle("<%=allpsldayslabel%>line").style.display='none';
      }

	if(objval==4){

		oTrOtherLeaveType.style.display="";
		oTrOtherLeaveTypeLine2.style.display="";		
		$GetEle("selectOtherLeaveType").style.display="";
        if($GetEle("selectOtherLeaveType").value==2){
           //显示年假信息
           if($GetEle("<%=lastyearannualdayslabel%>tr")!=null){
              $GetEle("<%=lastyearannualdayslabel%>tr").style.display='';
           }
           if($GetEle("<%=thisyearannualdayslabel%>tr")!=null){
              $GetEle("<%=thisyearannualdayslabel%>tr").style.display='';
           }
           if($GetEle("<%=allannualdayslabel%>tr")!=null){
              $GetEle("<%=allannualdayslabel%>tr").style.display='';
           }
           if($GetEle("<%=lastyearannualdayslabel%>line")!=null){
              $GetEle("<%=lastyearannualdayslabel%>line").style.display='';
           }
           if($GetEle("<%=thisyearannualdayslabel%>line")!=null){
              $GetEle("<%=thisyearannualdayslabel%>line").style.display='';
           }
           if($GetEle("<%=allannualdayslabel%>line")!=null){
              $GetEle("<%=allannualdayslabel%>line").style.display='';
           }                       
        }else if($GetEle("selectOtherLeaveType").value=="11"){
            //显示年假信息
            if($GetEle("<%=lastyearpsldayslabel%>tr")!=null){
               $GetEle("<%=lastyearpsldayslabel%>tr").style.display='';
            }
            if($GetEle("<%=thisyearpsldayslabel%>tr")!=null){
               $GetEle("<%=thisyearpsldayslabel%>tr").style.display='';
            }
            if($GetEle("<%=allpsldayslabel%>tr")!=null){
               $GetEle("<%=allpsldayslabel%>tr").style.display='';
            }
            if($GetEle("<%=lastyearpsldayslabel%>line")!=null){
               $GetEle("<%=lastyearpsldayslabel%>line").style.display='';
            }
            if($GetEle("<%=thisyearpsldayslabel%>line")!=null){
               $GetEle("<%=thisyearpsldayslabel%>line").style.display='';
            }
            if($GetEle("<%=allpsldayslabel%>line")!=null){
               $GetEle("<%=allpsldayslabel%>line").style.display='';
            }
    	}
	}else{

		oTrOtherLeaveType.style.display="none";
		oTrOtherLeaveTypeLine2.style.display="none";	
		$GetEle("selectOtherLeaveType").style.display="none";		
	}
}

function checktimeok(){
	return true;
}

function checkleavedays(obj,src){

	//安全检查
	if("<%=selectNameLeaveType%>"==""||"<%=selectNameOtherLeaveType%>"==""||"<%=inputNameResourceId%>"==""||"<%=inputNameFromDate%>"==""){
		return true;
	}

	//只有请假类型为 4:其它带薪假   其它请假类型为 2:年假  时才做判断，当年假天数为0时，不能请年假
	if($GetEle("<%=selectNameLeaveType%>").value=='4'&& $GetEle("<%=selectNameOtherLeaveType%>").value=='2'){
	    if("<%=allannual%>">0){

		   if($GetEle("<%=inputNameLeaveDays%>")!=null && parseFloat($GetEle("<%=inputNameLeaveDays%>").value) >parseFloat("<%=allannual%>")){
		     alert("<%=SystemEnv.getHtmlLabelName(21721,user.getLanguage())%>");
		   }else{
		   	$GetEle("frmmain").src.value=src;
			jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
			//附件上传
        StartUploadAll();
        checkuploadcomplet();
			return true;	    
	       }
	    }else{
	        alert("<%=SystemEnv.getHtmlLabelName(21720,user.getLanguage())%>");
	        return false;
	    } 	     
	  }else if($GetEle("<%=selectNameLeaveType%>").value=='4'&& $GetEle("<%=selectNameOtherLeaveType%>").value=='11'){
		    if(<%=allpsldays%>>0){

			   if($GetEle("<%=inputNameLeaveDays%>")!=null && parseFloat($GetEle("<%=inputNameLeaveDays%>").value) >parseFloat("<%=allpsldays%>")){
			     alert("<%=SystemEnv.getHtmlLabelName(24045,user.getLanguage())%>");
			   }else{
			   	$GetEle("frmmain").src.value=src;
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
				//附件上传
        StartUploadAll();
        checkuploadcomplet();
				return true;	    
		       }
		    }else{
		        alert("<%=SystemEnv.getHtmlLabelName(24044,user.getLanguage())%>");
		        return false;
		    } 	     
	  }else{
	  		//setEmptyLeaveType();
			$GetEle("frmmain").src.value=src;
			jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
			//附件上传
        StartUploadAll();
        checkuploadcomplet();
			return true;
	}

}
function setEmptyLeaveType()
{
	if($GetEle("<%=selectNameLeaveType%>").value=='')
  	{
  		var selectNameLeaveType = $GetEle("<%=selectNameLeaveType%>");
  		if(selectNameLeaveType.options)
  		{
  			var op = selectNameLeaveType.options[0];
  			if(op)
  			{
  				op.value = "-1";
  				op.selected = true;
  			}
  		}
  		else
  		{
  			selectNameLeaveType.value = "-1";
  		}
  	}
  	if($GetEle("<%=selectNameOtherLeaveType%>").value=='')
  	{
  		var selectNameOtherLeaveType = $GetEle("<%=selectNameOtherLeaveType%>");
  		if(selectNameOtherLeaveType.options)
  		{
  			var op = selectNameOtherLeaveType.options[0];
  			if(op)
  			{
  				op.value = "-1";
  				op.selected = true;
  			}
  		}
  		else
  		{
  			selectNameOtherLeaveType.value = "-1";
  		}
  	}
}
function ajaxInit(){
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

function checkOtherLeaveType(obj,src){

	//安全检查
	if("<%=selectNameLeaveType%>"==""||"<%=selectNameOtherLeaveType%>"==""||"<%=inputNameResourceId%>"==""||"<%=inputNameFromDate%>"==""){
		return true;
	}


	//只有请假类型为 4:其它带薪假   其它请假类型为 1:探亲假  2:年假  时才做判断
	if($GetEle("<%=selectNameLeaveType%>").value=='4'
	 &&($GetEle("<%=selectNameOtherLeaveType%>").value=='1'||$GetEle("<%=selectNameOtherLeaveType%>").value=='2'&&$GetEle("<%=inputNameResourceId%>").value!='')
	  ){
		var ajax=ajaxInit();
        ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
        ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        ajax.send("operation=checkOtherLeaveType&leaveType="+$GetEle("<%=selectNameLeaveType%>").value+"&otherLeaveType="+$GetEle("<%=selectNameOtherLeaveType%>").value+"&resourceId="+$GetEle("<%=inputNameResourceId%>").value+"&fromDate="+$GetEle("<%=inputNameFromDate%>").value+"&requestId="+$GetEle("requestid").value);
        //获取执行状态
        ajax.onreadystatechange = function() {
            //如果执行状态成功，那么就把返回信息写到指定的层里
            if (ajax.readyState == 4 && ajax.status == 200) {
                try{
					var canSubmitOrSave=trim(ajax.responseText);
					if(canSubmitOrSave.indexOf("true")>-1){
						$GetEle("frmmain").src.value=src;
						jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
						//附件上传
        StartUploadAll();
        checkuploadcomplet();
						return true;
					}else{
			            alert("<%=SystemEnv.getHtmlLabelName(20072,user.getLanguage())%>");
						return false;
					}
                }catch(e){
			
			    }

            }
        }
	}else{
						$GetEle("frmmain").src.value=src;
						jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
						//附件上传
        StartUploadAll();
        checkuploadcomplet();
						return true;
	}
}

function getLeaveDays(){
	//安全检查
	if("<%=inputNameFromDate%>"==""||"<%=inputNameFromTime%>"==""||"<%=inputNameToDate%>"==""||"<%=inputNameToTime%>"==""||"<%=inputNameLeaveDays%>"==""||"<%=inputNameResourceId%>"==""){
		if("<%=inputNameLeaveDays%>"!=""){
					if("<%=canEditForLeaveDays%>"=="false"){
						$GetEle("<%=inputNameLeaveDays%>").value="0.00";
						leaveDaysSpan.innerHTML=leaveDays;
					}else{
						$GetEle("<%=inputNameLeaveDays%>").value="0.00";
					}
		}
		return ;
	}

	//如果起始日期、结束日期和姓名都不为空的触发计算
	if($GetEle("<%=inputNameFromDate%>").value!=''&&$GetEle("<%=inputNameToDate%>").value!=''&&$GetEle("<%=inputNameResourceId%>").value!=''){
		var ajax=ajaxInit();
        ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
        ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        ajax.send("operation=getLeaveDays&fromDate="+$GetEle("<%=inputNameFromDate%>").value+"&fromTime="+$GetEle("<%=inputNameFromTime%>").value+"&toDate="+$GetEle("<%=inputNameToDate%>").value+"&toTime="+$GetEle("<%=inputNameToTime%>").value+"&resourceId="+$GetEle("<%=inputNameResourceId%>").value);
        //获取执行状态
        ajax.onreadystatechange = function() {
            //如果执行状态成功，那么就把返回信息写到指定的地方
            if (ajax.readyState == 4 && ajax.status == 200) {
                try{
					var leaveDays=trim(ajax.responseText);
					if("<%=canEditForLeaveDays%>"=="false"){
						$GetEle("<%=inputNameLeaveDays%>").value=leaveDays;
						leaveDaysSpan.innerHTML=leaveDays;
					}else{
						$GetEle("<%=inputNameLeaveDays%>").value=leaveDays;
					}
                }catch(e){
					if("<%=canEditForLeaveDays%>"=="false"){
						$GetEle("<%=inputNameLeaveDays%>").value="0.00";
						leaveDaysSpan.innerHTML=leaveDays;
					}else{
						$GetEle("<%=inputNameLeaveDays%>").value="0.00";
					}
			    }

            }
        }
	}
}

function dispalyannualinfo(obj){
  if(obj.value==2){
     if($GetEle("<%=lastyearannualdayslabel%>tr")!=null){
        $GetEle("<%=lastyearannualdayslabel%>tr").style.display='';
     }
     if($GetEle("<%=lastyearannualdayslabel%>span")!=null){
        $GetEle("<%=lastyearannualdayslabel%>span").innerHTML = "<%=lastyearannual%>";
     }
     if($GetEle("<%=thisyearannualdayslabel%>tr")!=null){
        $GetEle("<%=thisyearannualdayslabel%>tr").style.display='';
     }
     if($GetEle("<%=thisyearannualdayslabel%>span")!=null){
        $GetEle("<%=thisyearannualdayslabel%>span").innerHTML = "<%=thisyearannual%>";
     }
     if($GetEle("<%=allannualdayslabel%>tr")!=null){
        $GetEle("<%=allannualdayslabel%>tr").style.display='';
     }
     if($GetEle("<%=allannualdayslabel%>span")!=null){
        $GetEle("<%=allannualdayslabel%>span").innerHTML = "<%=allannual%>";
     }
     if($GetEle("<%=lastyearannualdayslabel%>line")!=null){
        $GetEle("<%=lastyearannualdayslabel%>line").style.display='';
     }
     if($GetEle("<%=thisyearannualdayslabel%>line")!=null){
        $GetEle("<%=thisyearannualdayslabel%>line").style.display='';
     }
     if($GetEle("<%=allannualdayslabel%>line")!=null){
        $GetEle("<%=allannualdayslabel%>line").style.display='';
     }
	 if($GetEle("<%=lastyearpsldayslabel%>tr")!=null){
        $GetEle("<%=lastyearpsldayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=thisyearpsldayslabel%>tr")!=null){
        $GetEle("<%=thisyearpsldayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=allpsldayslabel%>tr")!=null){
        $GetEle("<%=allpsldayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=lastyearpsldayslabel%>line")!=null){
        $GetEle("<%=lastyearpsldayslabel%>line").style.display='none';
     }
     if($GetEle("<%=thisyearpsldayslabel%>line")!=null){
        $GetEle("<%=thisyearpsldayslabel%>line").style.display='none';
     }
     if($GetEle("<%=allpsldayslabel%>line")!=null){
        $GetEle("<%=allpsldayslabel%>line").style.display='none';
     }
  }else if(obj.value=="11"){
     if($GetEle("<%=lastyearpsldayslabel%>tr")!=null){
        $GetEle("<%=lastyearpsldayslabel%>tr").style.display='';
     }
     if($GetEle("<%=lastyearpsldayslabel%>span")!=null){
        $GetEle("<%=lastyearpsldayslabel%>span").innerHTML = "<%=lastyearpsldays%>";
     }
     if($GetEle("<%=thisyearpsldayslabel%>tr")!=null){
        $GetEle("<%=thisyearpsldayslabel%>tr").style.display='';
     }
     if($GetEle("<%=thisyearpsldayslabel%>span")!=null){
        $GetEle("<%=thisyearpsldayslabel%>span").innerHTML = "<%=thisyearpsldays%>";
     }
     if($GetEle("<%=allpsldayslabel%>tr")!=null){
        $GetEle("<%=allpsldayslabel%>tr").style.display='';
     }
     if($GetEle("<%=allpsldayslabel%>span")!=null){
        $GetEle("<%=allpsldayslabel%>span").innerHTML = "<%=allpsldays%>";
     }
     if($GetEle("<%=lastyearpsldayslabel%>line")!=null){
        $GetEle("<%=lastyearpsldayslabel%>line").style.display='';
     }
     if($GetEle("<%=thisyearpsldayslabel%>line")!=null){
        $GetEle("<%=thisyearpsldayslabel%>line").style.display='';
     }
     if($GetEle("<%=allpsldayslabel%>line")!=null){
        $GetEle("<%=allpsldayslabel%>line").style.display='';
     }
	 if($GetEle("<%=lastyearannualdayslabel%>tr")!=null){
        $GetEle("<%=lastyearannualdayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=thisyearannualdayslabel%>tr")!=null){
        $GetEle("<%=thisyearannualdayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=allannualdayslabel%>tr")!=null){
        $GetEle("<%=allannualdayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=lastyearannualdayslabel%>line")!=null){
        $GetEle("<%=lastyearannualdayslabel%>line").style.display='none';
     }
     if($GetEle("<%=thisyearannualdayslabel%>line")!=null){
        $GetEle("<%=thisyearannualdayslabel%>line").style.display='none';
     }
     if($GetEle("<%=allannualdayslabel%>line")!=null){
        $GetEle("<%=allannualdayslabel%>line").style.display='none';
     }
  }else{
     if($GetEle("<%=lastyearannualdayslabel%>tr")!=null){
        $GetEle("<%=lastyearannualdayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=thisyearannualdayslabel%>tr")!=null){
        $GetEle("<%=thisyearannualdayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=allannualdayslabel%>tr")!=null){
        $GetEle("<%=allannualdayslabel%>tr").style.display='none';
     }
     if($GetEle("<%=lastyearannualdayslabel%>line")!=null){
        $GetEle("<%=lastyearannualdayslabel%>line").style.display='none';
     }
     if($GetEle("<%=thisyearannualdayslabel%>line")!=null){
        $GetEle("<%=thisyearannualdayslabel%>line").style.display='none';
     }
     if($GetEle("<%=allannualdayslabel%>line")!=null){
        $GetEle("<%=allannualdayslabel%>line").style.display='none';
     }
     if($GetEle("<%=lastyearpsldayslabel%>tr")!=null){
         $GetEle("<%=lastyearpsldayslabel%>tr").style.display='none';
      }
      if($GetEle("<%=thisyearpsldayslabel%>tr")!=null){
         $GetEle("<%=thisyearpsldayslabel%>tr").style.display='none';
      }
      if($GetEle("<%=allpsldayslabel%>tr")!=null){
         $GetEle("<%=allpsldayslabel%>tr").style.display='none';
      }
      if($GetEle("<%=lastyearpsldayslabel%>line")!=null){
         $GetEle("<%=lastyearpsldayslabel%>line").style.display='none';
      }
      if($GetEle("<%=thisyearpsldayslabel%>line")!=null){
         $GetEle("<%=thisyearpsldayslabel%>line").style.display='none';
      }
      if($GetEle("<%=allpsldayslabel%>line")!=null){
         $GetEle("<%=allpsldayslabel%>line").style.display='none';
      }
  }
}

function onShowLeaveTime(fieldid,url,linkurl,fieldtype,ismand){   
   spanname = "field"+fieldid+"span"
   inputname = "field"+fieldid	      
   var returnvalue;	  
   if(fieldtype==2){
     onBoHaiShowDate(spanname,inputname,ismand);
  }else{
     bohai = 1;
     onWorkFlowShowTime(spanname,inputname,ismand);
  }
}

</script>

<script type="text/javascript">
function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag) {
	var id1 = null;
	
    if (type1 == 9  && "<%=docFlags%>" == "1" ) {
        if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
        	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
        } else {
	    	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
        }
	}
	
	if (type1 == 2 || type1 == 19 ) {
	    spanname = "field" + id + "span";
	    inputname = "field" + id;
	    
		if (type1 == 2) {
			onWorkFlowShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand);
		}
	} else {
	    if (type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168) {
				id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&resourceids=" + $GetEle("field" + id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else {
		        tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
		
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""

					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + linkurl + curid + " target=_blank>" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field"+id+"span").innerHTML = sHtml;
					$GetEle("field"+id).value= resourceids;
				} else {
 					if (ismand == 0) {
 						$GetEle("field"+id+"span").innerHTML = "";
 					} else {
 						$GetEle("field"+id+"span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
 					}
 					$GetEle("field"+id).value = "";
				}

			} else {
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						sHtml = ""
						ids = ids.substr(1);
						$GetEle("field"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
					   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						$GetEle("field"+id).value = ids;
						sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("field" + id + "span").innerHTML = sHtml
						return ;
				   }
	               if (type1 == 9 && "<%=docFlags%>" == "1") {
		                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
		                $GetEle("field" + id + "span").innerHTML = "<a href='#' onclick=\"createDoc(" + id + ", " + tempid + ", 1)\">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=\"button\"  type=\"button\" id=\"createdoc\" style=\"display:none\" class=\"AddDocFlow\" onclick=\"createDoc(" + id + ", " + tempid + ",1)\"></button>";
	               } else {
	            	    if (linkurl == "") {
				        	$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
				        } else {
							if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
								$GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
							} else {
								$GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
							}
				        }
	               }
	               $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
	                if (type1 == 9 && "<%=docFlags%>" == "1") {
	                	//$GetEle("CreateNewDoc").innerHTML="";
	                	var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("");
	                }
			   } else {
					if (ismand == 0) {
						$GetEle("field"+id+"span").innerHTML = "";
					} else {
						$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>"
					}
					$GetEle("field"+id).value="";
					if (type1 == 9 && "<%=docFlags%>" == "1"){
						var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%></button>");
					}
			   }
			}
		}
	}
}

function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("field" + id).value;
	url = url + roleid + "_" + tmpids;

	id1 = window.showModalDialog(url);
	if (id1) {

		if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";

			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);

			$GetEle("field" + id).value = resourceids;

			var idArray = resourceids.split(",");
			var nameArray = resourcename.split(",");
			for ( var _i = 0; _i < idArray.length; _i++) {
				var curid = idArray[_i];
				var curname = nameArray[_i];

				sHtml = sHtml + "<a href=" + linkurl + curid
						+ " target='_new'>" + curname + "</a>&nbsp";
			}

			$GetEle("field" + id + "span").innerHTML = sHtml;

		} else {
			if (ismand == 0) {
				$GetEle("field" + id + "span").innerHTML = "";
			} else {
				$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			}
			$GetEle("field" + id).value = "";
		}
	}
}
</script>

<SCRIPT LANGUAGE=VBS>

sub onShowBrowserForThisJsp(id,url,linkurl,type1,ismand)
	if type1= 2 or type1 = 19 then
	    spanname = "field"+id+"span"
	    inputname = "field"+id
		if type1 = 2 then
		  onWorkFlowShowDate spanname,inputname,ismand
        else
	      onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		id1 = window.showModalDialog(url)

		if NOT isempty(id1) then

			   if  id1(0)<>""   and id1(0)<> "0"  then
			        if linkurl = "" then
						$GetEle("field"+id+"span").innerHtml = id1(1)
					else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							$GetEle("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							$GetEle("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
						end if
					end if
					$GetEle("field"+id).value=id1(0)
				else
					if ismand=0 then
						$GetEle("field"+id+"span").innerHtml = empty
					else
						$GetEle("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					$GetEle("field"+id).value=""
				end if
		end if
	end if
end sub
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<script type="text/javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>