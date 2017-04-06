<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rset" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>

<%
int languagebodyid = user.getLanguage() ;
ArrayList uploadfieldids=new ArrayList();    
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息
String resourceFieldId = "";
String crmFieldId = "";
String resourceNumFieldId = "";

String newfromdate="a";
String newenddate="b";
String newfromtime="";
String newendtime="";
String Address="";
String remindBeforeStart = "";
String remindBeforeEnd = "";
String remindTimesBeforeStart = "";
String remindTimesBeforeEnd = "";
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String formid=Util.null2String(request.getParameter("formid"));
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));
String docCategory = Util.null2String(request.getParameter("docCategory"));

int userid=user.getUID();
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
String needcheck="requestname";
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5);
int uploadType = 0;
String selectedfieldid = "";
String result = RequestManager.getUpLoadTypeForSelect(Util.getIntValue(workflowid,0));
if(!result.equals("")){
	selectedfieldid = result.substring(0,result.indexOf(","));
	uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
}
boolean isCanuse = RequestManager.hasUsedType(Util.getIntValue(workflowid,0));
if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
}
int messageType = 0;
RecordSet.executeSql("select * from workflow_base where id="+workflowid);
if(RecordSet.next()){
	messageType=RecordSet.getInt("messageType");
}
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
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
<!--增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<!--增加提示信息  结束-->
<form name="frmmain" method="post" action="BillMeetingOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name ="topage" value="<%=topage%>">
<input type="hidden" name="htmlfieldids">
  <div align="center"><br>
    <font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font> <br>
    <br>
  </div>
  <table class="viewform">
    <colgroup> <col width="20%"> <col width="80%"> 
    <tr class="Spacing" style="height:1px;"> 
      <td class="Line1" colspan=2></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class=field> 
        <input type=text class=Inputstyle name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>
        value="<%=Util.toScreenToEdit(workflowname+"-"+username+"-"+currentdate,user.getLanguage())%>">
        <span id=requestnamespan></span> 
        <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
      </td>
    </tr>
    <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
	  <%
	if(messageType == 1){
  %>
  <TR>
	<TD > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
	<td class=field>
		  <span id=messageTypeSpan></span>
		  <input type=radio value="0" name="messageType" checked><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
		  <input type=radio value="1" name="messageType"><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
		  <input type=radio value="2" name="messageType"><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
		</td>
  </TR>  	   	
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
  <%}%>
    <%
ArrayList fieldids=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
ArrayList fieldnames=new ArrayList();
ArrayList isviews=new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
RecordSet.executeSql("SELECT distinct a.isview,a.isedit,a.ismandatory , b.id,b.fieldlabel,b.fieldhtmltype,b.type,b.fieldname,b.dsporder from workflow_nodeform a,workflow_billfield b where a.fieldid= b.id and  a.nodeid="+nodeid+" order by b.dsporder,b.id");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	fieldnames.add(RecordSet.getString("fieldname"));
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}

int fieldop1id=0;
String strFieldId=null;
String strCustomerValue=null;
String strManagerId=null;
String strUnderlings=null;
String preAdditionalValue = "";
boolean isSetFlag = false;
String docFlags=(String)session.getAttribute("requestAdd"+user.getUID());
ArrayList inoperatefields=new ArrayList();
ArrayList inoperatevalues=new ArrayList();

rsaddop.executeSql("select fieldid,customervalue,fieldop1id from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid);
while(rsaddop.next()){
    //inoperatefields.add(rsaddop.getString("fieldid"));
    //inoperatevalues.add(rsaddop.getString("customervalue"));
	strFieldId=Util.null2String(rsaddop.getString("fieldid"));
	strCustomerValue=Util.null2String(rsaddop.getString("customervalue"));
	fieldop1id=Util.getIntValue(rsaddop.getString("fieldop1id"),0);
	if(fieldop1id==-3){
		strManagerId="";
		rscount.executeSql("select managerId from HrmResource where id="+userid);
		if(rscount.next()){
			strManagerId=Util.null2String(rscount.getString("managerId"));
		}
		inoperatefields.add(strFieldId);
		inoperatevalues.add(strManagerId);
	}else if(fieldop1id==-4){
		strUnderlings="";
		rscount.executeSql("select id from HrmResource where managerId="+userid+" and status in(0,1,2,3)");
		while(rscount.next()){
			strUnderlings+=","+Util.null2String(rscount.getString("id"));
		}
		if(!strUnderlings.equals("")){
			strUnderlings=strUnderlings.substring(1);
		}
		inoperatefields.add(strFieldId);
		inoperatevalues.add(strUnderlings);
	}else{
		inoperatefields.add(strFieldId);
		inoperatevalues.add(strCustomerValue);
	}
}
String customervalue = "";
int preAdditionalCount1 =1;
int preAdditionalCount2=0;
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);
	String fieldid=(String)fieldids.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
    if(fieldname.equalsIgnoreCase("begindate")) newfromdate="field"+fieldid;
    if(fieldname.equalsIgnoreCase("begintime")) newfromtime="field"+fieldid;
    if(fieldname.equalsIgnoreCase("enddate")) newenddate="field"+fieldid;
    if(fieldname.equalsIgnoreCase("endtime")) newendtime="field"+fieldid;
    if(fieldname.equalsIgnoreCase("Address")) Address="field"+fieldid;
    
    if(fieldname.equalsIgnoreCase("remindBeforeStart")) remindBeforeStart="field"+fieldid;
    if(fieldname.equalsIgnoreCase("remindBeforeEnd")) remindBeforeEnd="field"+fieldid;
    if(fieldname.equalsIgnoreCase("remindTimesBeforeStart")) remindTimesBeforeStart="field"+fieldid;
    if(fieldname.equalsIgnoreCase("remindTimesBeforeEnd")) remindTimesBeforeEnd="field"+fieldid;
    
    if(fieldname.equalsIgnoreCase("resources"))
    {
        resourceFieldId = "field" + fieldid;
    }
    if(fieldname.equalsIgnoreCase("crms"))
    {
        crmFieldId = "field" + fieldid;
    }
    if(fieldname.equalsIgnoreCase("resourcenum"))
    {
        resourceNumFieldId = "field" + fieldid;
    }


	preAdditionalValue = "";
	isSetFlag = false;
	int inoperateindex=inoperatefields.indexOf(fieldid);
	if(inoperateindex>-1){
		isSetFlag = true;
		preAdditionalValue = (String)inoperatevalues.get(inoperateindex);
	}

    if( ! isview.equals("1") ) { //不显示即进行下一步循环,除了人力资源字段，应该隐藏人力资源字段，因为人力资源字段有可能作为流程下一节点的操作者
        if(fieldhtmltype.equals("3") && (fieldtype.equals("1") ||fieldtype.equals("17")||fieldtype.equals("165")||fieldtype.equals("166")) && !preAdditionalValue.equals("")){           
           out.println("<input type=hidden name=field"+fieldid+" value="+preAdditionalValue+">");
        }        
        continue ;                  
    }
    if(fieldname.equalsIgnoreCase("remindBeforeStart")||fieldname.equalsIgnoreCase("remindBeforeEnd")||fieldname.equalsIgnoreCase("remindTimesBeforeStart")||fieldname.equalsIgnoreCase("remindTimesBeforeEnd"))
	{
    	out.println("<input type=hidden name=field"+fieldid+" value='0'>");
    	continue;
	}
   if(isview.equals("1")){
%>

    <tr> 
      <%if(fieldhtmltype.equals("2")){%>
      <td valign=top><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}else{%>
      <td><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}%>
      <td class=field> 
        <%
	if(fieldhtmltype.equals("1")){
		if(fieldtype.equals("1")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" style="width:50%" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"><%if(preAdditionalValue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" style="width:50%" value="<%=preAdditionalValue%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}
		}
		else if(fieldtype.equals("2")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" style="width:50%"
		onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"><%if(preAdditionalValue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{
					RecordSet.executeSql("select customervalue from workflow_addinoperate a ,workflow_billfield b where a.fieldid =b.id and  workflowid="+workflowid+" and objid = "+nodeid+" and b.type = 17");
		rset.executeSql("select customervalue from workflow_addinoperate a ,workflow_billfield b where a.fieldid =b.id and  workflowid="+workflowid+" and objid = "+nodeid+" and b.type = 18");
		if(fieldtype.equals("2")){
		RecordSet.executeSql("select customervalue from workflow_addinoperate a ,workflow_billfield b where a.fieldid =b.id and  workflowid="+workflowid+" and objid = "+nodeid+" and b.type = 17");
		rset.executeSql("select customervalue from workflow_addinoperate a ,workflow_billfield b where a.fieldid =b.id and  workflowid="+workflowid+" and objid = "+nodeid+" and b.type = 18");
		if(rset.next()){
			customervalue = rset.getString("customervalue");
			if(customervalue != null && !"".equals(customervalue)){
			String[] customervalueArray = customervalue.split(",");
			for(int j= 0;j<customervalueArray.length;j++){
				if(null != customervalueArray && !"".equals(customervalueArray)){
					preAdditionalCount2++;
				}
			}
			}
		}
		if(RecordSet.next()){
			customervalue = RecordSet.getString("customervalue");
			preAdditionalCount1 = 0;
			if(customervalue != null && !"".equals(customervalue)){
			String[] customervalueArray = customervalue.split(",");
			for(int j= 0;j<customervalueArray.length;j++){
				if(null != customervalueArray && !"".equals(customervalueArray)){
					preAdditionalCount1++;
				}
			}
			}
		}
	}
				preAdditionalValue =String.valueOf(preAdditionalCount1+preAdditionalCount2);%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" style="width:50%" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}
		}
		else if(fieldtype.equals("3")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" style="width:50%"
		onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"><%if(preAdditionalValue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))" style="width:50%" value="<%=preAdditionalValue%>">
        <span id="field<%=fieldid%>span"></span>
        <%}
			}
		}
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	}
	else if(fieldhtmltype.equals("2")){
		if(isedit.equals("1")){
			%>
			<script>document.getElementById("htmlfieldids").value += "field<%=fieldid%>;<%=Util.toScreen(fieldlable,languagebodyid)%>,";</script>
				<%
			if(ismand.equals("1")) {%>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))"
		rows="4" cols="40" style="width:80%"><%=preAdditionalValue%></textarea>
        <span id="field<%=fieldid%>span"><%if(preAdditionalValue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span> 
        <%
				needcheck+=",field"+fieldid;
			}else{%>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" rows=4 cols=40 style="width:80%" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'))"><%=preAdditionalValue%></textarea>
        <span id="field<%=fieldid%>span"></span>
        <%}
		}
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	}
	else if(fieldhtmltype.equals("3")){
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl=BrowserComInfo.getLinkurl(fieldtype);
		String showname = "";
		String showid = "";
		int tmpid = 0;
		String reqid = Util.null2String(request.getParameter("reqid"));		
        if (fieldtype.equals("118")) {
        	showname ="<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>"+SystemEnv.getHtmlLabelName(2193,user.getLanguage())+"</a>" ;
    %>
    	<%=Util.toScreen(showname,user.getLanguage()) %>
    <%
        }
        else
        {

            if((fieldtype.equals("8") || fieldtype.equals("135")) && !prjid.equals("")){       //浏览按钮为项目,从前面的参数中获得项目默认值
                showid = "" + Util.getIntValue(prjid,0);
            }else if((fieldtype.equals("9") || fieldtype.equals("37")) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值
                showid = "" + Util.getIntValue(docid,0);
            }else if((fieldtype.equals("1") ||fieldtype.equals("17")) && !hrmid.equals("")){ //浏览按钮为人,从前面的参数中获得人默认值
                showid = "" + Util.getIntValue(hrmid,0);
            }else if((fieldtype.equals("7") || fieldtype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值
                showid = "" + Util.getIntValue(crmid,0);
            }else if((fieldtype.equals("16") || fieldtype.equals("152") || fieldtype.equals("171")) && !reqid.equals("")){ //浏览按钮为REQ,从前面的参数中获得REQ默认值
                showid = "" + Util.getIntValue(reqid,0);
			}else if(fieldtype.equals("4") && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
            }else if(fieldtype.equals("24") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
            }else if(fieldtype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
            }else if(fieldtype.equals("164") && !hrmid.equals("")){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getSubCompanyID(hrmid),0);
            }else if(fieldtype.equals("89")){//浏览按钮为会议类型，会议类型只选择审批流程是该审批工作流的类型
                url += "?approver="+workflowid;
            }
            if(fieldtype.equals("2")){ //added by xwj for td3130 20051124
                 if(!isSetFlag){
                    showname = currentdate;
                    showid = currentdate;
                }else{
                    showname=preAdditionalValue;
                    showid=preAdditionalValue;
                }
            }
				if(fieldtype.equals("19")){ //added by ben 2008-3-14 默认当前时间
                 if(!isSetFlag){
                    showname = currenttime.substring(0,5);
                    showid = currenttime.substring(0,5);
                }else{
                    showname=preAdditionalValue;
                    showid=preAdditionalValue;
                }
            }
            if(showid.equals("0")) showid = "" ;


            if(isSetFlag){
            showid = preAdditionalValue;//added by xwj for td3308 20051213
           }

            if(fieldtype.equals("2") || fieldtype.equals("19")  )	showname=showid; // 日期时间
            else if(!showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                ArrayList tempshowidlist=Util.TokenizerString(showid,",");
                if(fieldtype.equals("8") || fieldtype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("1") ||fieldtype.equals("17")){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                          	{
                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                          	}
                        	else
                            	showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("7") || fieldtype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("4") || fieldtype.equals("57")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("164")){
                    //分部
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("9") || fieldtype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        if (fieldtype.equals("9")&&docFlags.equals("1"))
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//维护正文
                         String tempDoc=""+tempshowidlist.get(k);
                       showname+="<a href='#' onlick='createDoc("+fieldid+","+tempDoc+")'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }
                        else
                        {
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
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
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else{
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
                    if(!tablename.equals("") && !columname.equals("") && !keycolumname.equals("")){
	                    String sql="";
	                    if(showid.indexOf(",")==-1){
	                        sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;
	                    }else{
	                        sql="select "+columname+" from "+tablename+" where "+keycolumname+" in("+showid+")";
	                    }

	                    RecordSet.executeSql(sql);
	                    while(RecordSet.next()) {
							if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
			            	{
			            		showname = "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>&nbsp";
			            	}
							else
								showname = "<a href='"+linkurl+showid+"'>"+RecordSet.getString(1)+"</a>&nbsp";
	                    }
                    }
                }
            }



		if(isedit.equals("1")){
			if(fieldtype.equals("160")){
                rsaddop.execute("select a.level_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldid+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+") ");
				String roleid="";
				if (rsaddop.next())
				{
				roleid=rsaddop.getString(1);
				}
%>
        <button type=button  class=Browser  onclick="onShowResourceRole('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'),'<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>"></button>
<%
			}else{
		%>
			<button type=button  class=Browser 
			<%if(fieldtype.equals("2")){%>
			onClick ="onShowFlowDate('<%=fieldid%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))"
			<%}%>
			<%if(fieldtype.equals("19")){%>
			onClick ="onShowMeetingTime(field<%=fieldid%>span,field<%=fieldid%>,field<%=fieldid%>.getAttribute('viewtype'))"
			<%}%>
			onClick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',field<%=fieldid%>.getAttribute('viewtype'))
			<% if("17".equals(fieldtype) || "18".equals(fieldtype)) { %>, countAttend() <% } %> ">
			</button>
        <%	}
        }%>
        <input type=hidden viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" value="<%=showid%>">
        <span id="field<%=fieldid%>span"> 
        <%=Util.toScreen(showname,user.getLanguage())%>
        <%if(ismand.equals("1") && showname.equals("")){%>
        <img src="/images/BacoError.gif" align=absmiddle> 
        <%	needcheck+=",field"+fieldid;	
			}%>
        </span> 
        <%}
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	}
	else if(fieldhtmltype.equals("4")){
	%>
        <input type=checkbox viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" value=1 <%if(preAdditionalValue.equals("1")){%> checked<%}%> name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> >
        <%
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
        }
    else if(fieldhtmltype.equals("5")){
    	String otherEvent= "";
    	if("remindType".equals(fieldname))
	    {
    		otherEvent = "showRemindTime(this);";
	    }
	%><select id="remindType" class=inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>" name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.getAttribute('viewtype'));" <%if(selfieldsadd.indexOf(fieldid)>=0){ %> onChange="<%=otherEvent %>changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else{%> onChange="<%=otherEvent %>"<%}%>>
	<%
	char flag=2;
	rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+"1");
	boolean checkempty = true;
	String finalvalue = "";
	while(rs.next()){
		String tmpselectvalue = rs.getString("selectvalue");
		String tmpselectname = rs.getString("selectname");
		String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());

		if("".equals(preAdditionalValue)){
			if("y".equals(isdefault)){
				checkempty = false;
				finalvalue = tmpselectvalue;
			}
		}
        else{
			if(tmpselectvalue.equals(preAdditionalValue)){
				checkempty = false;
				finalvalue = tmpselectvalue;
			}
        }

	%>
	<option value="<%=tmpselectvalue%>" <%if("".equals(preAdditionalValue)){if("y".equals(isdefault)){%>selected<%}}else{if(tmpselectvalue.equals(preAdditionalValue)){%>selected<%}}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
	<%}%>
	</select>
        <%
        if(changefieldsadd.indexOf(fieldid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
<%
    }
	    if("remindType".equals(fieldname))
	    {
    	%>
    	<!--================ 提醒时间  ================-->
    	<TR id="remindTimeLine" style="display:none"  style="height:1px;">
			<TD class="Line2" colSpan="6"></TD>
		</TR>
		<TR id="remindTime" style="display:none">
			<TD><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT id='remindBeforeStart' type="checkbox" name="remindBeforeStart" value="0">
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT id='remindDateBeforeStart' class="InputStyle" type="input" name="remindDateBeforeStart" onchange="checkint('remindDateBeforeStart')" size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT id='remindTimeBeforeStart' class="InputStyle" type="input" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				<INPUT id='remindBeforeEnd' type="checkbox" name="remindBeforeEnd" value="0">
					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT id='remindDateBeforeEnd' class="InputStyle" type="input" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT id='remindTimeBeforeEnd' class="InputStyle" type="input" name="remindTimeBeforeEnd" onchange="checkint('remindTimeBeforeEnd')"  size=5 value="0">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</TD>
		</TR>
    	<%
    	}
    }
        //add by myq @20080310 for 附件上传
       else if(fieldhtmltype.equals("6")){
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
          if(isedit.equals("1")){
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
               uploadfieldids.add(fieldid);
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
        	if (window.addEventListener) {
       	    	window.addEventListener("load", fileupload<%=fieldid%>, false);
        	} else if (window.attachEvent) {
       	    	window.attachEvent("onload", fileupload<%=fieldid%>);
            } else {
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
				 if(ismand.equals("1")){
				needcheck+=",field"+fieldid;
				%>
			   <img src='/images/BacoError.gif' align=absMiddle>
			  <%
					}
			   %>
	     </span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,user.getLanguage())%>"  viewtype="<%=ismand%>">
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
      <%
              }
       }
       else if(fieldhtmltype.equals("7")){//特殊字段
 			out.println(Util.null2String((String)specialfield.get(fieldid+"_1")));
       }
%>
      </td>
    </tr>
    <tr class="Spacing" style="height:1px;">
      <td class="Line2" colspan=2></td>
    </tr>
    <%
   }
}
%>    	  
	<tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
      <td class=field>
		<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>" value="">
        <textarea class=Inputstyle name=remark id="remark" rows=4 cols=40 style="width=80%;display:none" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"  <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%> ></textarea>
<script defer>
function funcremark_log(){
	CkeditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,CkeditorExt.NO_IMAGE,200);
	<%if(isSignMustInput.equals("1")){%>
	CkeditorExt.checkText("remarkSpan","remark");
	<%}%>
	CkeditorExt.toolbarExpand(false,"remark");
}

if (window.addEventListener) {
   	window.addEventListener("load", funcremark_log, false);
} else if (window.attachEvent) {
   	window.attachEvent("onload", funcremark_log);
} else {
   	window.onload=funcremark_log;
}

</script>
<span id="remarkSpan">
<%
	if(isSignMustInput.equals("1")){
%>
			  <img src="/images/BacoError.gif" align=absmiddle>
<%
	}
%>
              </span>
      </td>
    </tr>
    <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
    <%
         if("1".equals(isSignDoc_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids">
                <button type=button  class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"></span>
            </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids">
                <button type=button  class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"></span>
            </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
         if("1".equals(isannexupload_add)){
            int annexmainId=0;
             int annexsubId=0;
             int annexsecId=0;
             String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
             if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
                annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
                annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
                annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
              }
             int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
             if(annexmaxUploadImageSize<=0){
                annexmaxUploadImageSize = 5;
             }
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
            <td class=field>
          <%if(annexsecId<1){%>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(21418,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}else{%>
            <script>
          var oUploadannexupload;
          function fileuploadannexupload() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId":"<%=annexmainId%>",
                "subId":"<%=annexsubId%>",
                "secId":"<%=annexsecId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>"
            },
            file_size_limit :"<%=annexmaxUploadImageSize%> MB",
            file_types : "*.*",
            file_types_description : "All Files",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgressannexupload",
                cancelButtonId : "btnCancelannexupload",
                uploadfiedid:"field-annexupload"
            },
            debug: false,


            // Button settings

            button_image_url : "/js/swfupload/add.png",    // Relative to the SWF file
            button_placeholder_id : "spanButtonPlaceHolderannexupload",

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
            file_dialog_complete_handler : fileDialogComplete_2,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };


        try {
            oUploadannexupload=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileuploadannexupload);
        	
		if (window.addEventListener) {
		   	window.addEventListener("load", fileuploadannexupload, false);
		} else if (window.attachEvent) {
		   	window.attachEvent("onload", fileuploadannexupload);
		} else {
		   	window.onload=fileuploadannexupload;
		}
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolderannexupload"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUploadannexupload.cancelQueue();" id="btnCancelannexupload">
									<span><img src="/js/swfupload/delete.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span>(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field-annexupload" >
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgressannexupload">
                  </div>
                  <div id="divStatusannexupload"></div>
              </td>
          </tr>
      </TABLE>
              <input type=hidden name='annexmainId' value=<%=annexmainId%>>
              <input type=hidden name='annexsubId' value=<%=annexsubId%>>
              <input type=hidden name='annexsecId' value=<%=annexsecId%>>
          </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}}%>
  </table>
  <input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">
</form>

<script language=javascript>
	function addannexRow(accname)
  {
    $GetEle(accname+'_num').value=parseInt($GetEle(accname+'_num').value)+1;
    ncol = $GetEle(accname+'_tab').cols;
    oRow = $GetEle(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);
      oCell.style.height=24;
      switch(j) {
        case 1:
          var oDiv = document.createElement("div");
          var sHtml = "";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 0:
          var oDiv = document.createElement("div");
          <%----- Modified by xwj for td3323 20051209  ------%>
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }
	function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        //alert('<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>');
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM><%=maxUploadImageSize%>) {
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    //var  newObj = document.createElement("input");
    //newObj.name=objName;
    //newObj.className="InputStyle";
    //newObj.type="file";
    //newObj.size=70;
    //newObj.onchange=function(){accesoryChanage(this);};

    //var objParentNode = obj.parentNode;
    //var objNextNode = obj.nextSibling;
    //obj.removeNode();
    //objParentNode.insertBefore(newObj,objNextNode);
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=60 >";  
    document.getElementById(objName).outerHTML=outerHTML;       
    document.getElementById(objName).onchange=tempObjonchange;
}

function countAttend()
{
	var count = 0;	
	
	if("" != $GetEle("<%= resourceFieldId %>").value)
	{
		countArray = $GetEle("<%= resourceFieldId %>").value.split(",");
		for(var i = 0; i < countArray.length; i++)
		{
			count++;
		}
	}

	if("" != $GetEle("<%= crmFieldId %>").value)
	{
		countArray = $GetEle("<%= crmFieldId %>").value.split(",");
		for(var i = 0; i < countArray.length; i++)
		{
			count++;
		}
	}
	
	if($GetEle("<%= resourceNumFieldId %>span") != undefined)
	{
		$GetEle("<%= resourceNumFieldId %>span").innerHTML = "";
	}
	if($GetEle("<%= resourceNumFieldId %>") != undefined)
	{
		$GetEle("<%= resourceNumFieldId %>").value = count;
	}
}

function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{  
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else 
                return true;
            }
            }
        else
        return true;
        }
}


function checktimeok(){
if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && $GetEle("frmmain").<%=newenddate%>.value != ""){
			YearFrom=$GetEle("frmmain").<%=newfromdate%>.value.substring(0,4);
			MonthFrom=$GetEle("frmmain").<%=newfromdate%>.value.substring(5,7);
			DayFrom=$GetEle("frmmain").<%=newfromdate%>.value.substring(8,10);
			YearTo=$GetEle("frmmain").<%=newenddate%>.value.substring(0,4);
			MonthTo=$GetEle("frmmain").<%=newenddate%>.value.substring(5,7);
			DayTo=$GetEle("frmmain").<%=newenddate%>.value.substring(8,10);
			// window.alert(YearFrom+MonthFrom+DayFrom);
            if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
                window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                return false;
  			 }else{
                if($GetEle("frmmain").<%=newenddate%>.value==$GetEle("frmmain").<%=newfromdate%>.value && $GetEle("frmmain").<%=newendtime%>.value<$GetEle("frmmain").<%=newfromtime%>.value){
                    window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                    return false;
                }
            }
  }
     return true; 
}

function checkuse(){
    <%
    String tempbegindate="";
    String tempenddate="";
    String tempbegintime="";
    String tempendtime="";
    String tempAddress="0";
    //RecordSet.executeSql("select Address,begindate,enddate,begintime,endtime from meeting where meetingstatus=2 and isdecision<2 and (cancel is null or cancel<>'1') and begindate>='"+currentdate+"'");
    RecordSet.executeSql("select Address,begindate,enddate,begintime,endtime from meeting where meetingstatus=2 and isdecision<2 and (cancel is null or cancel<>'1') and     (begindate>='"+currentdate+"' or EndDate >= '"+currentdate+"') AND address <> 0 AND address IS NOT null");
    while(RecordSet.next()){
        tempAddress=RecordSet.getString("Address");
        tempbegindate=RecordSet.getString("begindate");
        tempenddate=RecordSet.getString("enddate");
        tempbegintime=RecordSet.getString("begintime");
        tempendtime=RecordSet.getString("endtime");
   %>
   if("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && $GetEle("frmmain").<%=newenddate%>.value != ""&&$GetEle("frmmain").<%=Address%>.value=="<%=tempAddress%>"){
       if(!($GetEle("frmmain").<%=newfromdate%>.value+" "+$GetEle("frmmain").<%=newfromtime%>.value>"<%=tempenddate+' '+tempendtime%>" || $GetEle("frmmain").<%=newenddate%>.value+" "+$GetEle("frmmain").<%=newendtime%>.value<"<%=tempbegindate+' '+tempbegintime%>")){
           return true;
       }
   }
   <%
    }
    %>
    return false;
}
function setRemindData()
{
	//判断如果提醒方式设置"短信提醒" 或 "邮件提醒" 时候, 才进行相关计算
	var remindType = $GetEle("remindType").value;
	if(remindType != "2" && remindType != "3"){
		return true;
	}
	
	var remindBeforeStart = $GetEle("remindBeforeStart");
	var remindDateBeforeStart = $GetEle("remindDateBeforeStart");
	var remindTimeBeforeStart = $GetEle("remindTimeBeforeStart");
	var remindBeforeEnd = $GetEle("remindBeforeEnd");
	var remindDateBeforeEnd = $GetEle("remindDateBeforeEnd");
	var remindTimeBeforeEnd = $GetEle("remindTimeBeforeEnd");
	//判断"开始前(提醒)" 是否勾选
	if(remindBeforeStart && remindBeforeStart.checked) {
		remindBeforeStart.value = 1;
	} else if(remindBeforeStart&&!remindBeforeStart.checked) {
		remindBeforeStart.value = 0;
		//如果"开始前(提醒)" 不勾选, 则将 开始前小时和分钟值将无意义, 故都置为0
		if(remindDateBeforeStart) {
			remindDateBeforeStart.value=0;
		}
		if(remindTimeBeforeStart) {
			remindTimeBeforeStart.value=0;
		}
	}
	//判断"结束前(提醒)" 是否勾选
	if(remindBeforeEnd && remindBeforeEnd.checked) {
		remindBeforeEnd.value = 1;
	} else if(remindBeforeEnd && !remindBeforeEnd.checked) {
		remindBeforeEnd.value = 0;
		//如果"结束前(提醒)" 不勾选, 则将 结束前小时和分钟值将无意义, 故都置为0
		if(remindDateBeforeEnd) {
			remindDateBeforeEnd.value=0;
		}
		if(remindTimeBeforeEnd) {
			remindTimeBeforeEnd.value=0;
		}
	}
<% if(!remindBeforeStart.equals("")){%>
if ($GetEle("<%=remindBeforeStart%>") && remindBeforeStart) $GetEle("<%=remindBeforeStart%>").value = remindBeforeStart.value;
<%}%>
<% if(!remindBeforeEnd.equals("")){%>
if ($GetEle("<%=remindBeforeEnd%>") && remindBeforeEnd) $GetEle("<%=remindBeforeEnd%>").value = remindBeforeEnd.value;
<%}%>
<% if(!remindTimesBeforeStart.equals("")){%>
if ($GetEle("<%=remindTimesBeforeStart%>") && remindDateBeforeStart && remindTimeBeforeStart) $GetEle("<%=remindTimesBeforeStart%>").value = parseInt(remindDateBeforeStart.value * 60) + parseInt(remindTimeBeforeStart.value);
<%}%>
<% if(!remindTimesBeforeEnd.equals("")){%>
if ($GetEle("<%=remindTimesBeforeEnd%>") && remindDateBeforeEnd && remindTimeBeforeEnd) $GetEle("<%=remindTimesBeforeEnd%>").value = parseInt(remindDateBeforeEnd.value * 60) + parseInt(remindTimeBeforeEnd.value);
<%}%>
}
function doSave(){
	parastr = $GetEle("needcheck").value+$GetEle("inputcheck").value+"<%=needcheck10404%>" ;
	if(check_form($GetEle("frmmain"),parastr)){
		$GetEle("frmmain").src.value='save';
		if(checktimeok()){
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
                            
                //增加提示信息  开始 meiYQ 2007.10.19 start
		       		  var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
		       		  showPrompt(content);
               //增加提示信息  结束 meiYQ 2007.10.19 end
            setRemindData();   
            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
    }
}
function doSubmit(obj){
	parastr = $GetEle("needcheck").value+$GetEle("inputcheck").value+"<%=needcheck10404%>";
	if(check_form($GetEle("frmmain"),parastr)){
		$GetEle("frmmain").src.value='submit';
		$GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		if(checktimeok()){
		if(checkuse()){
            if(confirm("<%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>")){
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
                
                //增加提示信息  开始 meiYQ 2007.10.19 start
		       		  var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
		       		  showPrompt(content);
               //增加提示信息  结束 meiYQ 2007.10.19 end
               
                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
        }else{
            jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
            
            //增加提示信息  开始 meiYQ 2007.10.19 start
		       	var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
		       	showPrompt(content);
            //增加提示信息  结束 meiYQ 2007.10.19 end
            setRemindData();
            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
        }
    }
}  

	function showPrompt(content)
{

     var showTableDiv  = document.getElementById('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.top=pTop;
     message_table_Div.style.left=pLeft;

     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
} 
function showRemindTime(obj)
{
	if("1" == obj.value)
	{
		$GetEle("remindTime").style.display = "none";
		$GetEle("remindTimeLine").style.display = "none";
		$GetEle("remindBeforeStart").checked = false;
		$GetEle("remindBeforeEnd").checked = false;
		$GetEle("remindTimeBeforeStart").value = 0;
		$GetEle("remindTimeBeforeEnd").value = 0;
	}
	else
	{
		$GetEle("remindTime").style.display = "";
		$GetEle("remindTimeLine").style.display = "";
		//remindBeforeStart和remindBeforeEnd值默认为选中
		$GetEle("remindBeforeStart").checked = true;
		$GetEle("remindBeforeEnd").checked = true;
		//remindTimeBeforeStart和remindTimeBeforeEnd值默认为10
		$GetEle("remindTimeBeforeStart").value = 10;
		$GetEle("remindTimeBeforeEnd").value = 10;
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

<script type="text/javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
