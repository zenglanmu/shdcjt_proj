<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(73,user.getLanguage());
String needfav ="1";
String needhelp ="";
//modify by xhheng @20050206 for TD 1541 
String  saved=Util.null2String(request.getParameter("saved"));
%>
<script language=javascript>
function onLoad(){
    if(<%=(saved.equals("true")?"true":"false")%>){
        alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
    }
}
</script>
<BODY onload="onLoad()">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype=0;
if(logintype.equals("2"))
     usertype = 1;
     
String seclevel = user.getSeclevel();
char flag=2;
String checked="";

String selectedworkflow="";
String isuserdefault="";
String hascreatetime = "1";
String hascreater = "1";
String hasworkflowname = "1";
String hasrequestlevel = "1";
String hasrequestname = "1";
String hasreceivetime = "1";
String hasstatus = "1";
String hasreceivedpersons = "0";
String hascurrentnode = "0";
String numperpage = "10";
String noReceiveMailRemind="0";
String Showoperator="0";
String commonuse = "";
ArrayList selectArr=new ArrayList();
RecordSet.executeProc("workflow_RUserDefault_Select",""+userid);
if(RecordSet.next()){
    selectedworkflow=RecordSet.getString("selectedworkflow");
    isuserdefault=RecordSet.getString("isuserdefault");
    hascreatetime = RecordSet.getString("hascreatetime");
    hascreater = RecordSet.getString("hascreater");
    hasworkflowname = RecordSet.getString("hasworkflowname");
    hasrequestlevel = RecordSet.getString("hasrequestlevel");
    hasrequestname = RecordSet.getString("hasrequestname");
    hasreceivetime = RecordSet.getString("hasreceivetime");
    hasstatus = RecordSet.getString("hasstatus");
    hasreceivedpersons = RecordSet.getString("hasreceivedpersons");
    hascurrentnode = RecordSet.getString("hascurrentnode");
    numperpage = RecordSet.getString("numperpage");
    noReceiveMailRemind = RecordSet.getString("noReceiveMailRemind");
	Showoperator=RecordSet.getString("Showoperator");
	commonuse = RecordSet.getString("commonuse");

}else{
    RecordSet.executeProc("workflow_RUserDefault_Select","1");
    if(RecordSet.next()){
        selectedworkflow=RecordSet.getString("selectedworkflow");
        isuserdefault=RecordSet.getString("isuserdefault");
        hascreatetime = RecordSet.getString("hascreatetime");
        hascreater = RecordSet.getString("hascreater");
        hasworkflowname = RecordSet.getString("hasworkflowname");
        hasrequestlevel = RecordSet.getString("hasrequestlevel");
        hasrequestname = RecordSet.getString("hasrequestname");
        hasreceivetime = RecordSet.getString("hasreceivetime");
        hasstatus = RecordSet.getString("hasstatus");
        hasreceivedpersons = RecordSet.getString("hasreceivedpersons");
        hascurrentnode = RecordSet.getString("hascurrentnode");
        numperpage = RecordSet.getString("numperpage");
        noReceiveMailRemind = RecordSet.getString("noReceiveMailRemind");
		Showoperator=RecordSet.getString("Showoperator");
		commonuse = "1";//默认勾选常用流程
    }
}


//----------------------------
//START
//----------------------------
//定义报表显示
String wfreportnumperpage = "20";

RecordSet rs2 = new RecordSet();
rs2.executeSql("select * from workflowReportCustom where userid=" + user.getUID());
if (rs2.next()) {
	wfreportnumperpage = Util.null2String(rs2.getString("wfreportnumperpage"));
}
//----------------------------
//END
//----------------------------
List tmpArr = new ArrayList(); //ypc 2012-09-12 添加
if(!selectedworkflow.equals("")){
    selectArr=Util.TokenizerString(selectedworkflow,"|");
    tmpArr = Util.TokenizerString(selectedworkflow,"|"); //ypc 2012-09-12 添加
}
%><%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmmain action="RequestUserDefaultOperation.jsp" method=post >

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


<table class="viewform">
  <tr class=Title>
      	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></TH>
  </tr>
  <TR class=Spacing>
        <TD class=Line1 colSpan=2></TD>
  </TR>
  <!--line1-->
  <tr class=field>
  	<td width="50%">
  		<input type="checkbox" name="hascreatetime" value="1"<%if(hascreatetime.equals("1")){%> checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%>
  	</td>
  	<td width="50%">
  		<input type="checkbox" name="hascurrentnode" value="1" <%if(hascurrentnode.equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%>
  	</td>
  </tr>
  <!--line2-->
  <tr class=field>
  	<td width="50%">
  		<input type="checkbox" name="hascreater" value="1" <%if(hascreater.equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>
  	</td>
  	<td width="50%">
  		<input type="checkbox" name="hasreceivetime" value="1" <%if(hasreceivetime.equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(17994,user.getLanguage())%>
  	</td>
  </tr>
  <!--line3-->
  <tr class=field>
  	<td width="50%">
  		<input type="checkbox" name="hasworkflowname" value="1" <%if(hasworkflowname.equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>
  	</td>
  	<td width="50%">
  		<input type="checkbox" name="hasstatus" value="1" <%if(hasstatus.equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(1335,user.getLanguage())%>
  	</td>
  </tr>
  <!--line4-->
  <tr class=field>
  	<td width="50%"><input type="checkbox" name="hasrequestlevel" value="1" <%if(hasrequestlevel.equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
  	<td width="50%">
  		<input type="checkbox" name="hasreceivedpersons" value="1" <%if(hasreceivedpersons.equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>
  	</td>
  </tr>
  <!--line5-->
  <tr class=field>
  	<td width="50%">
  		<input type="checkbox" name="hasrequestname" value="1" <%if(hasrequestname.equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%>
  	</td>
  	<td width="50%">
	<input type="checkbox" name="Showoperator" value="1" <%if(Showoperator.equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(22219,user.getLanguage())%>
  	</td>
  </tr>
  <tr class=Spacing> <TD colSpan=2><br></TD></tr>
  <tr class=Title>
      	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></TH>
  </tr>
  <TR class=Spacing>
        <TD class=Line1 colSpan=2></TD>
  </TR>
  <tr class=field>
  	<td>
      <%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%>
      <input type="text" class=InputStyle name="numperpage" value="<%=numperpage%>" size="3" maxlength=2 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
      <%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>
  	</td>
  		<td>
       <input type="checkbox" name="commonuse" value="1" <%if(!commonuse.equals("0")){%>checked <%}%>>
      <%=SystemEnv.getHtmlLabelName(28184,user.getLanguage())%>
  	</td>
  </tr>
  <!-- start -->
  <tr class=field>
  	<td>
      <%=SystemEnv.getHtmlLabelName(16580,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%>
      <input type="text" class=InputStyle name="wfreportnumperpage" value="<%=wfreportnumperpage%>" size="3" maxlength=2 onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)'>
      <%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>
  	</td>
  </tr>
  <!-- end -->
  <tr class=Spacing> <TD colSpan=2><br></TD></tr>
  <tr class=Title>
      	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%></TH>
  </tr>
  <TR class=Spacing>
        <TD class=Line1 colSpan=2></TD>
  </TR>
  <tr class=field>
  	<td>
      <%=SystemEnv.getHtmlLabelName(19646,user.getLanguage())%>
      <input type="checkbox" name="noReceiveMailRemind" value="1" <%if(noReceiveMailRemind.equals("1")){%>checked <%}%>>
  	</td>
  </tr>


</table>
  <br>
<table class="viewform">
<%
ArrayList typeids=new ArrayList();
ArrayList workflowids=new ArrayList();
//获取流程新建权限体系sql条件
String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");
String sql = "select distinct workflowtype from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and " + wfcrtSqlWhere;
RecordSet.executeSql(sql);
while(RecordSet.next()){
	typeids.add(RecordSet.getString("workflowtype"));
}


//-------------------
// 优化工作流显示用 
//-------------------
//存储某类型下所有工作流的信息，一次性对所有工作流进行分类，取基本信息，
//避免每次循环类型中，再循环所有工作流，并取相关的信息进行判断是否属于此分类（此种方式效率极低）
Map workflowTInfokv = new HashMap();
//某类型下所有工作流信息
List workflowsInfoList = null;

//获取流程新建权限体系sql条件
wfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "wc");

sql = "select distinct wc.workflowid,wb.workflowname,wb.workflowtype from ShareInnerWfCreate wc LEFT JOIN workflow_base wb ON wc.workflowid=wb.id where " + wfcrtSqlWhere;
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String workflowid = (String)RecordSet.getString("workflowid");
	String workflowname = (String)RecordSet.getString("workflowname");//WorkflowComInfo.getWorkflowname(workflowid);
	String workflowtypeid = WorkflowComInfo.getWorkflowtype(workflowid);
	//使用string数组保存工作流信息		
	String[] workflowInfoArray = new String[]{workflowid, workflowname, workflowtypeid};
	//存入list
	workflowsInfoList = (List)workflowTInfokv.get(workflowtypeid);
	if (workflowsInfoList == null) {
		workflowsInfoList = new ArrayList();
	}
	workflowsInfoList.add(workflowInfoArray);
	workflowTInfokv.put(workflowtypeid, workflowsInfoList);
	workflowids.add(RecordSet.getString("workflowid"));
}

/*modify by mackjoe at 2005-09-14 增加流程代理创建权限*/
ArrayList AgentWorkflows = new ArrayList();
ArrayList Agenterids = new ArrayList();
//TD13554
if (usertype == 0) {
	//获得当前的日期和时间
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
	                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
	                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
	                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
	                     Util.add0(today.get(Calendar.SECOND), 2) ;
	String begindate="";
	String begintime="";
	String enddate="";
	String endtime="";
	int agentworkflowtype=0;
	int agentworkflow=0;
	int beagenterid=0;
	sql = "select distinct t1.workflowtype,t.workflowid,t.beagenterid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agent t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid="+userid+" order by t1.workflowtype,t.workflowid";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    boolean isvald=false;
	    begindate=Util.null2String(RecordSet.getString("begindate"));
	    begintime=Util.null2String(RecordSet.getString("begintime"));
	    enddate=Util.null2String(RecordSet.getString("enddate"));
	    endtime=Util.null2String(RecordSet.getString("endtime"));
	    agentworkflowtype=Util.getIntValue(RecordSet.getString("workflowtype"),0);
	    agentworkflow=Util.getIntValue(RecordSet.getString("workflowid"),0);
	    beagenterid=Util.getIntValue(RecordSet.getString("beagenterid"),0);
	    if(!begindate.equals("")){
	        if((begindate+" "+begintime).compareTo(currentdate+" "+currenttime)>0)
	            continue;
	    }
	    if(!enddate.equals("")){
	        if((enddate+" "+endtime).compareTo(currentdate+" "+currenttime)<0)
	            continue;
	    }
	    //String sqltemp = "select 1 from ShareInnerWfCreate wc where " + wfcrtSqlWhere + " and wc.workflowid="+agentworkflow;
	    //rs.executeSql(sqltemp);
	    boolean haswfcreateperm = shareManager.hasWfCreatePermission(beagenterid, agentworkflow);
		if(haswfcreateperm){
	        if(typeids.indexOf(agentworkflowtype+"")==-1){
	            typeids.add(agentworkflowtype+"");
	        }
	        if(workflowids.indexOf(agentworkflow+"")==-1){
	            AgentWorkflows.add(""+agentworkflow);
	            Agenterids.add(""+beagenterid);
	        }
	    }
	}
	//end
}
List inputReportFormIdList=new ArrayList();
String tempWorkflowId=null;
String tempFormId=null;
String tempIsBill=null;
for(int i=0;i<workflowids.size();i++){
	tempWorkflowId=(String)workflowids.get(i);
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

for(int i=0;i<AgentWorkflows.size();i++){
	tempWorkflowId=(String)AgentWorkflows.get(i);
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

String dataCenterWorkflowTypeId="";
RecordSet.executeSql("select currentId from sequenceindex where indexDesc='dataCenterWorkflowTypeId'");
if(RecordSet.next()){
	dataCenterWorkflowTypeId=Util.null2String(RecordSet.getString("currentId"));
}

this.rs=RecordSet;
List inputReportList=this.getAllInputReport(String.valueOf(userid));
//if(inputReportList.size()>0){
//	typeids.add(dataCenterWorkflowTypeId);
//}
if(inputReportList.size()>0&&typeids.indexOf(dataCenterWorkflowTypeId)==-1){
	typeids.add(dataCenterWorkflowTypeId);
}
ArrayList NewInputReports = new ArrayList();
Map inputReportMap=null;
String inprepId=null;
String inprepName=null;
for(int i=0;i<inputReportList.size();i++){
	

	inputReportMap=(Map)inputReportList.get(i);
	inprepId=Util.null2String((String)inputReportMap.get("inprepId"));
//	if(!inprepId.equals("")){
//		NewInputReports.add(inprepId);
//	}
	if(!inprepId.equals("")&&inputReportFormIdList.indexOf(InputReportComInfo.getbillid(inprepId))==-1){
		NewInputReports.add(inprepId);
	}
}    
%>
  <tr class="Title">
      	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH>
  </tr>
  <TR class="Spacing">
        <TD class="Line1" colSpan=2></TD>
  </TR>
  
  <%
	int typecate = typeids.size();
	int rownum = typecate/2;
	if((typecate-rownum*2)!=0)  rownum=rownum+1;
  %>
  <tr class=field>
        <td width="50%" align=left valign=top>
        <%
 	int needtd=rownum;
 	for(int i=0;i<typeids.size();i++){
 		
 		String typeid = (String)typeids.get(i);
 		String typename=WorkTypeComInfo.getWorkTypename(typeid);
 		needtd--;
 	%>
 	<table class="viewform">
		<tr class=field>
		  <td colspan=2 align=left>
		  <% if(selectArr.indexOf("T"+typeid)==-1){
		        checked="";
		     }else{
		        checked="checked";  
		        tmpArr.remove("T"+typeid);   //ypc添加 2012-09-12
		  	 }
		  %>
		  <input type="checkbox" name="t<%=typeid%>" value="T<%=typeid%>" onclick="checkMain('<%=typeid%>')" <%=checked%>>
		  
		  <b><%=typename%></b> </td></tr>	
 	<%
 	
    if(dataCenterWorkflowTypeId.equals(typeid)){
     
		for(int j=0;j<NewInputReports.size();j++){
			inprepId = (String)NewInputReports.get(j);
			inprepName=InputReportComInfo.getinprepname(inprepId);
	%>
		<tr class="field">
		  <td width="20%"></td>
		  <td>
		  <% if(selectArr.indexOf("R"+inprepId)==-1){
		        checked="";
		     }else{
		        checked="checked";
		        tmpArr.remove("R"+inprepId);  //ypc添加 2012-09-12
		  	 }
		  %>
		  <input type="checkbox" name="w<%=typeid%>" value="R<%=inprepId%>" onclick="checkSub('<%=typeid%>')" <%=checked%>>
		  <%=inprepName%></td></tr>
	<%
	
		}
		
    }     
    
 	List tempWorkflowInfoList = (List)workflowTInfokv.get(typeid);
 	if (tempWorkflowInfoList != null) {
        for(int j=0;j<tempWorkflowInfoList.size();j++){
        	String[] tempWorkflowInfo = (String[])tempWorkflowInfoList.get(j);
			String workflowid = tempWorkflowInfo[0];
			String workflowname = tempWorkflowInfo[1];
		 	String curtypeid = tempWorkflowInfo[2];
		 	
	%>
		<tr class="field">
		  <td width="20%"></td>
		  <td>
		  <% if(selectArr.indexOf("W"+workflowid)==-1){
		        checked="";
		     }else{
		        checked="checked";
		        tmpArr.remove("W"+workflowid); //ypc添加 2012-09-12
		     }        
		  %>
		  <input type="checkbox" name="w<%=typeid%>" value="W<%=workflowid%>" onclick="checkSub('<%=typeid%>')" <%=checked%>>
		  <%=workflowname%></td></tr>
	<%
		}
 	}
	%>
    <%
     //modify by mackjoe at 2005-09-14 增加代理创建流程显示
		for(int j=0;j<AgentWorkflows.size();j++){
			String workflowid = (String)AgentWorkflows.get(j);
			String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
		 	String curtypeid = WorkflowComInfo.getWorkflowtype(workflowid);
		 	if(!curtypeid.equals(typeid)) 
		 	    continue;
            String agentname="("+ResourceComInfo.getResourcename(""+Agenterids.get(j))+"->"+user.getUsername()+")";
	%>
		<tr class="field">
		  <td width="20%"></td>
		  <td>
		  <% if(selectArr.indexOf("W"+workflowid)==-1){
		        checked="";
		     }else{
		        checked="checked";
		        tmpArr.remove("W"+workflowid);    //ypc添加 2012-09-12
		  	 }
		  %>
		  <input type="checkbox" name="w<%=typeid%>" value="W<%=workflowid%>" onclick="checkSub('<%=typeid%>')" <%=checked%>>
		  <%=workflowname+agentname%></td></tr>
	<%
		}
     //end by mackjoe
	%>
	</table>
	<%
		if(needtd==0){
			needtd=typecate/2;
	%>
		</td><td align=left valign=top>
	<%
		}
	}
	%>		
  </tr>
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
	<!-- 2012-09-12 ypc 循环迭代使用 -->
	<%
	  if(tmpArr!=null){
	  	   for(int i = 0;i<tmpArr.size();i++){
		  	%>
			 <input type="hidden" name="<%=tmpArr.get(i)%>" value="<%=tmpArr.get(i)%>"/>
			<%
		   } 
		}
	%>
</form>
<script>
function checkMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("t"+id).checked ;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='w'+id) {
        	try{
            	document.frmmain.elements[i].checked= mainchecked ;
            }catch(e){
            	
            }
        } 
    } 
}
//ypc
function checkSub(id){
    len = document.frmmain.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='w'+id) {
    	if(document.frmmain.elements[i].checked){
    		document.all("t"+id).checked=true;
    		return;
    		}
    	} 
    }
    document.all("t"+id).checked=false; 
}

function submitData()
{
	if (check_form(weaver,''))
		weaver.submit();
}

function submitDel()
{
	if(isdel()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}
</script>


</body>
</html>