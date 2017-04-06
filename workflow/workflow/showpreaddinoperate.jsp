<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="bci" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<jsp:useBean id="DMLActionBase" class="weaver.workflow.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="wsActionManager" class="weaver.workflow.action.WSActionManager" scope="page" />
<jsp:useBean id="sapActionManager" class="weaver.workflow.action.SapActionManager" scope="page" />
<jsp:useBean id="baseAction" class="weaver.workflow.action.BaseAction" scope="page" />
<SCRIPT language="javascript" src="/integration/js/hashmap.js"></script>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<STYLE TYPE="text/css">
.btn_actionList
{
	BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HEAD>
<SCRIPT LANGUAGE="JavaScript">
	var fieldurl;
	var fieldtempurl = "";
	//zzl
	var saphashmap = new HashMap();
</SCRIPT>
<%
int design = Util.getIntValue(request.getParameter("design"),0);
int wfid = Util.getIntValue(request.getParameter("wfid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
int linkid = Util.getIntValue(request.getParameter("linkid"),0);
int formid=Util.getIntValue(request.getParameter("formid"),0);
String isbill =""+Util.getIntValue(request.getParameter("isbill"),0);
int istemplate = Util.getIntValue(request.getParameter("istemplate"),0);
boolean hascon = false;


//读配置文件，获得用户可以选择的Action列表
boolean isDmlAction = GCONST.isDMLAction();
boolean isWsAction = GCONST.isWsAction();
boolean isSapAction = GCONST.isSapAction();

//td37970 start
if(design==1) {
%>
<body  id="preAddInOperateBody" onbeforeunload="designOnClose()">
<%
}
else {
%>
<body  id="preAddInOperateBody" onbeforeunload="onClose()">
<%
}
//td37970 end

String drawBackFlg = Util.null2String(request.getParameter("drawBackFlg"));

String sql="";
if(formid==0){
	sql = " select * from workflow_base where id = "+wfid;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		formid = RecordSet.getInt("formid");
		isbill = RecordSet.getString("isbill");
		istemplate = RecordSet.getInt("istemplate");
	}
}
ArrayList fieldids = new ArrayList();
fieldids.clear();
ArrayList fieldnames = new ArrayList();
fieldnames.clear();
ArrayList fieldlabels = new ArrayList();
fieldlabels.clear();
ArrayList fieldhtmltypes = new ArrayList();
fieldhtmltypes.clear();
ArrayList fieldtypes = new ArrayList();
fieldtypes.clear();
ArrayList fielddbtypes = new ArrayList();
fielddbtypes.clear();

String allOptions = "";
String op1Options = "";
String op2Options = "";
String objOptions = "";
String operOptions = "";

op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15618,user.getLanguage()) +"','0');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15619,user.getLanguage()) +"','0');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15620,user.getLanguage()) +"','0');";
operOptions += "operList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(104,user.getLanguage()) +"','0');";
operOptions += "operList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15621,user.getLanguage()) +"(+)','1');";
operOptions += "operList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15622,user.getLanguage())+"(-)','2');";
operOptions += "operList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15623,user.getLanguage())+"(*)','3');";
operOptions += "operList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15624,user.getLanguage())+"(/)','4');";

if(isbill.equals("0")){
	sql = "select workflow_formdict.fielddbtype as fielddbtype,workflow_formfield.isdetail,workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.fieldhtmltype<>7 and workflow_formfield.formid="+formid;
	//明细字段也可以做节点前附加操作 modify by myq 2007.12.28 start
	sql += " union select workflow_formdictdetail.fielddbtype as fielddbtype,workflow_formfield.isdetail,workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdictdetail.fieldhtmltype as htmltype,workflow_formdictdetail.type as type from workflow_formfield,workflow_formdictdetail,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdictdetail.id = workflow_formfield.fieldid and workflow_formfield.isdetail='1' and workflow_formfield.formid="+formid;
	//明细字段也可以做节点前附加操作 modify by myq 2007.12.28 end
	String dbType = RecordSet.getDBType();
	if(dbType.equals("oracle")) sql += " order by isdetail desc";
	else sql += " order by isdetail asc";
}else if(isbill.equals("1"))
	sql = "select fielddbtype as fielddbtype,viewtype as isdetail, id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type from workflow_billfield where fieldhtmltype<>7 and billid = "+formid + " order by viewtype,detailtable,dsporder ";
//SQL修改，增加“viewtype as isdetail,”，使明细字段在列表中会表明“明细”
//褚俊 2008.05.06
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String tmphtmltype = Util.null2String(RecordSet.getString("htmltype"));
	String tmptype = Util.null2String(RecordSet.getString("type"));
	String tmpid = Util.null2String(RecordSet.getString("id"));
	String tmplabel ="";

	int fieldlen=-1;
	String tmpfielddbtype = Util.null2String(RecordSet.getString("fielddbtype"));
	if ((tmpfielddbtype.toLowerCase()).indexOf("varchar")>-1){
		fieldlen = Util.getIntValue(tmpfielddbtype.substring(tmpfielddbtype.indexOf("(")+1,tmpfielddbtype.length()-1));
	}
    //注释过虑操作，增加浏览框的处理功能

	fieldids.add(tmpid);
	fieldnames.add(Util.null2String(RecordSet.getString("name")));
	//褚俊 2008.05.06 使明细字段在列表中会表明“明细” Start
	String isdetail = Util.null2String(RecordSet.getString("isdetail"));
	//System.out.println("isdetail = " + isdetail);
	if(isbill.equals("1")){
		tmplabel = ""+SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("label")),user.getLanguage());
		if("1".equals(isdetail)){
			tmplabel = tmplabel + "(" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + ")";
		}
		//System.out.println("tmplabel = " + tmplabel);
		fieldlabels.add(tmplabel);
	}else{
		tmplabel = Util.null2String(RecordSet.getString("label"));
		if("1".equals(isdetail)){
			tmplabel = tmplabel + "(" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + ")";
		}
		//System.out.println("tmplabel = " + tmplabel);
		
		fieldlabels.add(tmplabel);
	}
	//褚俊 2008.05.06 使明细字段在列表中会表明“明细” End
	fieldhtmltypes.add(tmphtmltype);
	fieldtypes.add(tmptype);
	fielddbtypes.add(tmpfielddbtype);

	allOptions +="<option value='"+isdetail+"_"+tmpid+"_"+tmphtmltype+"_"+tmptype+"'>"+tmplabel+"</option>";
	op1Options += "op1List.options[i++] = new Option('"+tmplabel+"','"+isdetail+"_"+tmpid+"_"+tmphtmltype+"_"+tmptype+"');";
	op2Options += "op2List.options[i++] = new Option('"+tmplabel+"','"+isdetail+"_"+tmpid+"_"+tmphtmltype+"_"+tmptype+"');";
	objOptions += "objList.options[i++] = new Option('"+tmplabel+"','"+isdetail+"_"+tmpid+"_"+tmphtmltype+"_"+tmptype+"_"+fieldlen+"');";
	%>
	<SCRIPT LANGUAGE="JavaScript">
		fieldtempurl = fieldtempurl + "<%="_"+isdetail+"_"+tmpid+"_"+tmphtmltype+"_"+tmptype%>" + ":" + "'" + "<%=tmpfielddbtype%>" + "',";
		saphashmap.put("<%=tmpid%>","?type=<%=tmpfielddbtype%>|<%=tmpid%>");
	</SCRIPT>
	<%
}

op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15625,user.getLanguage()) +"','0_-1_3_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15626,user.getLanguage()) +"','0_-2_3_19');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage()) +"1','0_-10_3_19');";
op1Options += "op1List.options[i++] = new Option('"+SystemEnv.getHtmlLabelName(15627,user.getLanguage()) +"2','0_-11_3_19');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3','0_-12_3_19');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1','0_-13_3_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2','0_-14_3_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3','0_-15_3_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1','0_-16_1_1');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2','0_-17_1_1');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3','0_-18_1_1');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1','0_-19_1_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2','0_-20_1_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3','0_-21_1_2');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1','0_-22_1_3')";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2','0_-23_1_3');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3','0_-24_1_3');";
op1Options += "op1List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15632,user.getLanguage()) +"','customervalue');";

op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"1','0_-10_3_19');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"2','0_-11_3_19');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3','0_-12_3_19');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1','0_-13_3_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2','0_-14_3_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3','0_-15_3_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1','0_-16_1_1');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2','0_-17_1_1');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3','0_-18_1_1');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1','0_-19_1_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2','0_-20_1_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3','0_-21_1_2');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1','0_-22_1_3');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2','0_-23_1_3');";
op2Options += "op2List.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3','0_-24_1_3');";

objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"1','0_-10_3_19_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"2','0_-11_3_19_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3','0_-12_3_19_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1','0_-13_3_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2','0_-14_3_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3','0_-15_3_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1','0_-16_1_1_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2','0_-17_1_1_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3','0_-18_1_1_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1','0_-19_1_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2','0_-20_1_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3','0_-21_1_2_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1','0_-22_1_3_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2','0_-23_1_3_-1');";
objOptions += "objList.options[i++] = new Option('"+ SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3','0_-24_1_3_-1');";


String tmpfieldop1id = Util.null2String(request.getParameter("fieldop1id"));
String fieldid = Util.null2String(request.getParameter("fieldid"));

String htmltype1="";
String fieldop2id = Util.null2String(request.getParameter("fieldop2id"));

String fieldop1id = "0";
if(!tmpfieldop1id.equals("customervalue") && !tmpfieldop1id.equals("otherproperty") && !tmpfieldop1id.equals("0") && !tmpfieldop1id.equals("")){
	//fieldop1id = tmpfieldop1id.substring(0,tmpfieldop1id.indexOf("_"));
    tmpfieldop1id = tmpfieldop1id.substring(tmpfieldop1id.indexOf("_")+1);
    fieldop1id = tmpfieldop1id.substring(0,tmpfieldop1id.indexOf("_"));
}
char flag =2;

if(!fieldid.equals("0") && !fieldid.equals("")){
    fieldid = fieldid.substring(fieldid.indexOf("_")+1);
  htmltype1=fieldid.substring(fieldid.indexOf("_")+1,fieldid.lastIndexOf("_"));
	fieldid = fieldid.substring(0,fieldid.indexOf("_"));
}
if(!fieldop2id.equals("0") && !fieldop2id.equals(""))
	fieldop2id = fieldop2id.substring(0,fieldop2id.indexOf("_"));

String customervalue = Util.null2String(request.getParameter("fieldop1idvalue"));
String operation = Util.null2String(request.getParameter("operation"));
String skipweekend = Util.null2String(request.getParameter("skipweekend"));
String skippubholiday = Util.null2String(request.getParameter("skippubholiday"));
String src = Util.null2String(request.getParameter("src"));

int rules =0;
if(skipweekend.equals("1")){
	rules = rules | 1;
}
if(skippubholiday.equals("1")){
	rules = rules | 2;
}

//只有'附件上传'具有其他属性设置，'附件上传'的其他设置只有'文档类型设置'，故通过htmltype直接判断出addin类型
if(htmltype1.equals("6")){
  //addin类型为1，表明是附件上传的文档类型设置
  htmltype1="1";
  customervalue = Util.null2String(request.getParameter("otherProperty6"));
}else{
  //addin类型为0，表明是普通的附加操作设置
  htmltype1="0";
}

//存入数据库
//处理dml接口数据
if(src.equals("deletedmlaction")&&istemplate!=1&&(isDmlAction || isWsAction || isSapAction))
{
	String[] checkdmlids = request.getParameterValues("dmlid");
	
	String[] dmlidnewsaps = request.getParameterValues("dmlidnewsap");
	
	if(null!=dmlidnewsaps)
	{
		for(int j=0;j<dmlidnewsaps.length;j++)
		{
			RecordSet.executeSql("delete int_BrowserbaseInfo where id='"+dmlidnewsaps[j]+"'");
			//在这里执行删除
			sapActionManager.setActionid(Util.getIntValue(dmlidnewsaps[j]));
			sapActionManager.doDeleteSapAction();
		}
		//重新检查一次
		hascon = baseAction.checkActionOnNodeOrLink(wfid,nodeid,linkid,1);
		//RecordSet.executeSql("delete int_BrowserbaseInfo where id in()");
	}
		
	if(null!=checkdmlids)
	{
		for(int i = 0;i<checkdmlids.length;i++)
		{
			int dmlid = Util.getIntValue(checkdmlids[i],0);
			if(dmlid>0)
			{
				//DMLActionBase.deleteDmlActionFieldMapByActionid(dmlid);
				//DMLActionBase.deleteDmlActionSqlSetByActionid(dmlid);
				//DMLActionBase.deleteDmlActionSetByid(dmlid);
				
				int actiontype_t = Util.getIntValue(request.getParameter("actiontype"+dmlid), -1);
				if(actiontype_t == 0){
					DMLActionBase.deleteDmlActionFieldMapByActionid(dmlid);
					DMLActionBase.deleteDmlActionSqlSetByActionid(dmlid);
					DMLActionBase.deleteDmlActionSetByid(dmlid);
				}else if(actiontype_t == 1){
					wsActionManager.setActionid(dmlid);
					wsActionManager.doDeleteWsAction();
				}else if(actiontype_t == 2){
					sapActionManager.setActionid(dmlid);
					sapActionManager.doDeleteSapAction();
				}
			}
		}
		//hascon = DMLActionBase.checkDMLActionOnNodeOrLink(wfid,nodeid,linkid,1);
		hascon = baseAction.checkActionOnNodeOrLink(wfid,nodeid,linkid,1);
	}
}
//检查是否存在DMLaction配置
if(!hascon&&istemplate!=1&&(isDmlAction || isWsAction || isSapAction))
{
	hascon = DMLActionBase.checkAddinoperateOnNodeOrLink(wfid,nodeid,linkid,1);
}
if(src.equals("delete")){
	String[] checkids = request.getParameterValues("check_node");
	if(checkids!=null){
		for(int i=0;i<checkids.length;i++){
			RecordSet.executeProc("workflow_addinoperate_Delete",""+checkids[i]);
		}

	}
}
if(src.equals("add")){
	if(nodeid!=0)
        RecordSet.executeProc("workflow_addinoperate_Insert",""+nodeid+flag+"1"+flag+wfid+flag+fieldid+flag+fieldop1id+flag+fieldop2id+flag+operation+flag+customervalue+flag+rules+flag+"0"+flag+"1");
	else if(linkid!=0)
		RecordSet.executeProc("workflow_addinoperate_Insert",""+linkid+flag+"0"+flag+wfid+flag+fieldid+flag+fieldop1id+flag+fieldop2id+flag+operation+flag+customervalue+flag+rules+flag+htmltype1+flag+"1");

}
    String customeraction="";
    if(src.equals("addInterface")){
	    customeraction = Util.null2String(request.getParameter("interface"));
        if(nodeid!=0){
			RecordSet.executeSql("delete from workflow_addinoperate where objid="+nodeid+" and isnode=1 and type=2 and ispreadd=1");
            RecordSet.executeSql("insert into workflow_addinoperate (objid,workflowid,isnode,type,ispreadd,customervalue) values ("+nodeid+","+wfid+",1,2,1,'"+customeraction+"')");
            hascon = true; //解决启用接口动作：勾选时后点击"确定"，绿色标识不显示，需刷新,TD21374
		}
        else if(linkid!=0){
			RecordSet.executeSql("delete from workflow_addinoperate where objid="+nodeid+" and isnode=0 and type=2 and ispreadd=1");
            RecordSet.executeSql("insert into workflow_addinoperate (objid,workflowid,isnode,type,ispreadd,customervalue) values ("+nodeid+","+wfid+",0,2,1,'"+customeraction+"')");
            hascon = true; //解决启用接口动作：勾选时后点击"确定"，绿色标识不显示，需刷新,TD21374
		}

    }
     if(src.equals("delInterface")){
        if(nodeid!=0)
            RecordSet.executeSql("delete from workflow_addinoperate where objid="+nodeid+" and isnode=1 and type=2 and ispreadd=1");
        else if(linkid!=0)
            RecordSet.executeSql("delete from workflow_addinoperate where objid="+nodeid+" and isnode=0 and type=2 and ispreadd=1");

    }
    
if(src.equals("DrawBackFlg")){
	RecordSet.executeSql("update workflow_flownode set drawbackflag="+drawBackFlg+" where workflowid="+wfid+" and nodeid="+nodeid);
}
String onDrawBackFlg = "0";
RecordSet.executeSql("select drawbackflag from workflow_flownode where workflowid="+wfid+" and nodeid="+nodeid);
if(RecordSet.next()){
	onDrawBackFlg = Util.null2String(RecordSet.getString("drawbackflag"));
}

	//解决启用接口动作：勾选时后点击"确定"，绿色标识不显示，需刷新,TD21374 start
	String objidsql="";
	if(nodeid!=0)
	    objidsql = "select id from workflow_addinoperate where objid="+nodeid+" and workflowid="+wfid+" and isnode=1 and type=2 and ispreadd=1";
	else if(linkid!=0)
	    objidsql = "select id from workflow_addinoperate where objid="+nodeid+" and workflowid="+wfid+" and isnode=0 and type=2 and ispreadd=1";
	
	if(!"".equals(objidsql)){
	    RecordSet2.executeSql(objidsql);
		if(RecordSet2.next()) {
		   hascon = true; 
		}
	}
	//解决启用接口动作：勾选时后点击"确定"，绿色标识不显示，需刷新,TD21374 end
	
	//zzl
	if(src.equals("refush")){
		//什么都不做,用其他的办法好像刷新会自动关闭页面
	}
	
%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
if(design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showpreaddinoperate.jsp" method="post">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=linkid%>" name="linkid">
<input type="hidden" value="<%=isbill%>" name="isbill">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" value="<%=istemplate%>" name="istemplate">

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

<table width=100% class="viewform">
<COLGROUP>
   <COL width="32%">
   <COL width="5%">
   <COL width="20%">
   <COL width="11%">
   <COL width="32%">
<TR class="Title">
    	  <TH colSpan=5><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH></TR>
<TR class="Spacing" style="height: 1px;"><TD class="Line1" colspan=5 style="padding: 0px;"></TD></TR>

<tr>

<td>
<select class=inputstyle  style="width:100%" name=fieldid id=fieldid title="<%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%>" onchange="changefieldid(this.value);changeTitle('fieldid', this.value);">
<option value=0 ><%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%></option>
</select>
</td>
<td align=center>
<img src="/images/ArrowEqual.gif" border=0>
</td>
<td>
<select class=inputstyle   name=fieldop1id id=fieldop1id style="width:100%" onchange="changefieldop1id();">
<option value=customervalue><%=SystemEnv.getHtmlLabelName(15632,user.getLanguage())%></option>
</select>

</td>
<td>
<select class=inputstyle  name=operation id=operation style="width:100%" onchange="changeoperation(this.value)">
<option value="0"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></option>
</select>
<input class=Inputstyle type=text name=fieldop1idvalue id = fieldop1idvalue size=8 style="display:none">
<span name=otherPropertyName id=otherPropertyName style="display:none"><%=SystemEnv.getHtmlLabelName(19544,user.getLanguage())%></span>
</td>
<td>
<select class=inputstyle  name=fieldop2id id=fieldop2id style="width:100%" onchange="changefieldop2id(this.value)">
<option value=0><%=SystemEnv.getHtmlLabelName(15619,user.getLanguage())%></option>
</select>
<span name=otherProperty6Value id=otherProperty6Value style="display:none">
  <select class=inputstyle name=otherProperty6 id=otherProperty6>
    <option value=0><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
    <option value=2><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
    <option value=3><%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%></option>
    <option value=4><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
    <option value=5><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
  </select>
</span>
</td>

</tr>
<tr>
<td colspan=5>
<BUTTON type='button' class=Browser onclick="showPreDBrowser(urls[curIndex],curIndex)" id = fieldBrowser style="display:none"></BUTTON>
<span id="unitspan"></span>
</td>
</tr>
<TR id=oHeightTenTr  style="display:none">
    <TD height="10" colspan="5"></TD>
</TR>
<TR class="Title"  id=oDescriptionTr style="display:none">
    	  <TH colSpan=5><%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%></TH></TR>
<TR class="Spacing"  id=oLine1Tr style="display:none;height: 1px;"><TD class="Line1" colspan=5 style="padding: 0px;"></TD></TR>
<Tr id = oDateRuleTr style="display:none">
<td colspan=3>
<input type=checkbox name="skipweekend" value=1><%=SystemEnv.getHtmlLabelName(15633,user.getLanguage())%>
</td><td colspan=2>
<input type=checkbox name="skippubholiday" value=1><%=SystemEnv.getHtmlLabelName(15634,user.getLanguage())%>
</td>
</tr>
<TR class="Spacing" style="height: 1px;"><TD class="Line" colspan=5 style="padding: 0px;"></TD></TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(21987,user.getLanguage())%>:</td>
	<td colspan=2><input type=radio id="drawBackFlg" name="drawBackFlg" value=1 <%if(onDrawBackFlg.equals("1")){%>checked<%}%> onclick="onDrawBackFlg()"><%=SystemEnv.getHtmlLabelName(21988,user.getLanguage())%></td>
	<td><input type=radio id="drawBackFlg" name="drawBackFlg" value=0 <%if(!onDrawBackFlg.equals("1")){%>checked<%}%> onclick="onDrawBackFlg()"><%=SystemEnv.getHtmlLabelName(21989,user.getLanguage())%></td>
</tr>
</table>
<br>
<table width=100% class=liststyle cellspacing=1  >
<COLGROUP>
   <COL width="5%">
   <COL width="65%">
   <COL width="30%">
<TR class="Header">
    	  <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15635,user.getLanguage())%></TH></TR>
 <TR class=header>
    	  <TH></TH>
    	  <TH><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></TH>
    	  <TH><%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%></TH>
 </TR>
 <tr class="Line"><th colspan="3"></th></tr>
<%

String operateSel="";

if(isbill.equals("0")){
    operateSel = "select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.type,c.tablename,c.columname,c.keycolumname from workflow_addinoperate a ,workflow_formdict b,workflow_browserurl c where a.fieldid=b.id and b.type=c.id and b.fieldhtmltype=3 and a.ispreadd='1' and a.workflowid="+wfid;//xwj for td3130 20051122
    if(nodeid!=0)
			operateSel= operateSel+" and a.objid="+nodeid+" and isnode =1 ";
		else if(linkid!=0)
			operateSel = operateSel+" and a.objid="+linkid+" and isnode =0 ";
    operateSel = operateSel + " union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.type,c.tablename,c.columname,c.keycolumname from workflow_addinoperate a ,workflow_formdictdetail b,workflow_browserurl c where a.fieldid=b.id and b.type=c.id and b.fieldhtmltype=3 and a.ispreadd='1' and a.workflowid="+wfid;
}else if(isbill.equals("1")){
    operateSel = "select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.type,c.tablename,c.columname,c.keycolumname from workflow_addinoperate a ,workflow_billfield b,workflow_browserurl c where a.fieldid=b.id and b.type=c.id and b.fieldhtmltype=3 and a.ispreadd='1'";//xwj for td3130 20051122
}

if(nodeid!=0)
	operateSel= operateSel+" and a.objid="+nodeid+" and isnode =1 ";
else if(linkid!=0)
	operateSel = operateSel+" and a.objid="+linkid+" and isnode =0 ";

//add by xhheng @20050311 for TD 1708,组合查询，保证workflow_formdict fieldhtmltype<>3时，数据返回正常
if(isbill.equals("0")){
    operateSel = operateSel+" union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.type,'','','' from workflow_addinoperate a ,workflow_formdict b where a.fieldid=b.id and b.fieldhtmltype<>3  and a.ispreadd='1' and a.workflowid="+wfid;//xwj for td3130 20051122
    if(nodeid!=0)
			operateSel= operateSel+" and a.objid="+nodeid+" and isnode =1 ";
		else if(linkid!=0)
			operateSel = operateSel+" and a.objid="+linkid+" and isnode =0 ";
    operateSel = operateSel+" union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.type,'','','' from workflow_addinoperate a ,workflow_formdictdetail b where a.fieldid=b.id and b.fieldhtmltype<>3  and a.ispreadd='1' and a.workflowid="+wfid;
}else if(isbill.equals("1")){
    operateSel = operateSel+"union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,b.fieldhtmltype,b.type,'','','' from workflow_addinoperate a ,workflow_billfield b where a.fieldid=b.id and b.fieldhtmltype<>3 and a.ispreadd='1'";//xwj for td3130 20051122
}

if(nodeid!=0)
	operateSel= operateSel+" and a.objid="+nodeid+" and isnode =1 ";
else if(linkid!=0)
	operateSel = operateSel+" and a.objid="+linkid+" and isnode =0 ";

//add by xhheng @20050206 for TD 1535,将附加条件查询改为union查询，添加临时变量部分查询
if(isbill.equals("0")){
    operateSel = operateSel + " union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,'0',0,'','','' from workflow_addinoperate a ";
}else if(isbill.equals("1")){
    operateSel = operateSel + " union select a.id,a.fieldid,a.fieldop1id,a.fieldop2id,a.operation,a.customervalue,a.rules,a.type as addintype,'0',0,'','','' from workflow_addinoperate a ";
}

if(nodeid!=0)
	RecordSet.executeSql(operateSel+" where a.objid="+nodeid+" and a.fieldid<0 and isnode =1 and a.ispreadd='1'");//xwj for td3130 20051122
else if(linkid!=0)
	RecordSet.executeSql(operateSel+" where a.objid="+linkid+" and a.fieldid<0 and isnode =0 and a.ispreadd='1'");//xwj for td3130 20051122

int linecolor=0;
while(RecordSet.next()){
    hascon = true;
	int tmpid = RecordSet.getInt("id");
	int tmpfieldid = RecordSet.getInt("fieldid");
	int tmpfield1id = RecordSet.getInt("fieldop1id");
	int tmpfield2id = RecordSet.getInt("fieldop2id");
	int tmpoperation = RecordSet.getInt("operation");
	String tmpcustomervalue = RecordSet.getString("customervalue");
    //System.out.println("tmpcustomervalue:"+tmpcustomervalue);
    int tmprules = RecordSet.getInt("rules");
  int addintype= RecordSet.getInt("addintype");

    int htmltype = RecordSet.getInt("fieldhtmltype");
    int type = RecordSet.getInt("type");

    String tablename = RecordSet.getString("tablename");
    String columname = RecordSet.getString("columname");
    String keycolumname = RecordSet.getString("keycolumname");

	String expression="";
	String addrules = "";

	//把数据库中的数据转换成表达式
	if(!tmpcustomervalue.equals("")){
    //普通的节点、出口附加操作
    if(addintype==0){
        if(htmltype==3&&type!=19 && type!=2&&type!=162&&type!=161&&type!=141){
        	String[] tempArray = Util.TokenizerString2(tmpcustomervalue,",");
        	for(int i=0;i<tempArray.length;i++){
        		//zzl
        	 if(htmltype==3&&(type==226||type==227)){
            		expression=tempArray[i];
            		continue;
			}
            String bsql = "select "+columname+" from "+tablename+" where "+keycolumname+" = '"+tempArray[i]+"'";
            //System.out.println("bsql = " + bsql);
            RecordSet2.executeSql(bsql);
            while(RecordSet2.next()){
                //expression += ","+RecordSet2.getString(columname);
                expression += ","+RecordSet2.getString(1);//update by fanggsh 20060804 for  浏览框类型为部门时出错
            }
          }
          	//zzl
            if(!expression.equals("")&&type!=226&&type!=227){
                expression = expression.substring(1);
            }
                }else if(htmltype==3&&type==161){
        	String tempdbtype = (String)fielddbtypes.get(fieldids.indexOf(""+tmpfieldid));
			try{
	            Browser browser=(Browser)StaticObj.getServiceByFullname(tempdbtype, Browser.class);
	            BrowserBean bb=browser.searchById(tmpcustomervalue);
				String desc=Util.null2String(bb.getDescription());
				String name=Util.null2String(bb.getName());
				expression=name;
			}catch(Exception e){
			}			
		}else if(htmltype==3&&type==162){
        	String tempdbtype = (String)fielddbtypes.get(fieldids.indexOf(""+tmpfieldid));
        	try{
	            Browser browser=(Browser)StaticObj.getServiceByFullname(tempdbtype, Browser.class);
				List l=Util.TokenizerString(tmpcustomervalue,",");
	            for(int j=0;j<l.size();j++){
				    String curid=(String)l.get(j);
		            BrowserBean bb=browser.searchById(curid);
					String desc=Util.null2String(bb.getDescription());
					String name=Util.null2String(bb.getName());
				    expression+=","+name;
				}
			}catch(Exception e){
			}        		
			expression = expression.substring(1);
        }else if(htmltype==3&&type==141){
            expression =  ResourceConditionManager.getFormShowName(tmpcustomervalue,user.getLanguage());
        }else{
            expression =  tmpcustomervalue ;
        }
    }
    //附件上传，文档属性
    if(addintype==1){
      expression = "其他属性：文档状态";
      if(tmpcustomervalue.equals("0"))
        expression += " ("+SystemEnv.getHtmlLabelName(220,user.getLanguage())+")";
      if(tmpcustomervalue.equals("2"))
        expression += " ("+SystemEnv.getHtmlLabelName(225,user.getLanguage())+")";
      if(tmpcustomervalue.equals("3"))
        expression += " ("+SystemEnv.getHtmlLabelName(360,user.getLanguage())+")";
      if(tmpcustomervalue.equals("4"))
        expression += " ("+SystemEnv.getHtmlLabelName(236,user.getLanguage())+")";
      if(tmpcustomervalue.equals("5"))
        expression += " ("+SystemEnv.getHtmlLabelName(251,user.getLanguage())+")";
    }
  }
	else {
    //公式 第一操作值
		if(tmpfield1id == -1){
			expression = SystemEnv.getHtmlLabelName(15625,user.getLanguage()) ;
		}else if(tmpfield1id == -2){
			expression =  SystemEnv.getHtmlLabelName(15626,user.getLanguage()) ;
		}else if(tmpfield1id == -3){
			expression =  SystemEnv.getHtmlLabelName(15080,user.getLanguage()) ;
		}else if(tmpfield1id == -4){
			expression =  SystemEnv.getHtmlLabelName(15576,user.getLanguage()) ;
		}else if(tmpfield1id == -5){
			expression =  SystemEnv.getHtmlLabelName(22665,user.getLanguage()) ;
		}else if(tmpfield1id == -6){
			expression =  SystemEnv.getHtmlLabelName(15081,user.getLanguage()) ;
		}else if(tmpfield1id == -7){
			expression =  SystemEnv.getHtmlLabelName(22666,user.getLanguage()) ;
		}else if(tmpfield1id == -8){
			expression =  SystemEnv.getHtmlLabelName(22667,user.getLanguage()) ;
		}else if(tmpfield1id == -9){
			expression =  SystemEnv.getHtmlLabelName(22668,user.getLanguage()) ;
		}else if(tmpfield1id == -10){
			expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"1" ;
		}else if(tmpfield1id == -11){
			expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"2" ;
		}else if(tmpfield1id == -12){
			expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3" ;
		}else if(tmpfield1id == -13){
			expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1" ;
		}else if(tmpfield1id == -14){
			expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2" ;
		}else if(tmpfield1id == -15){
			expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3" ;
		}else if(tmpfield1id == -16){
			expression =  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1" ;
		}else if(tmpfield1id == -17){
			expression =  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2" ;
		}else if(tmpfield1id == -18){
			expression =  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3" ;
		}else if(tmpfield1id == -19){
			expression =  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1" ;
		}else if(tmpfield1id == -20){
			expression =  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2" ;
		}else if(tmpfield1id == -21){
			expression =  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3" ;
		}else if(tmpfield1id == -22){
			expression =  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1" ;
		}else if(tmpfield1id == -23){
			expression =  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2" ;
		}else if(tmpfield1id == -24){
			expression =  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3" ;
		}else if(tmpfield1id == -25){
			expression =  SystemEnv.getHtmlLabelName(22692,user.getLanguage())+"" ;
		}else{
		  if(tmpfield1id == 0){//xwj for td3308 on 20051212
			expression = "" ;
		  }
		  else{
		  expression = ""+fieldlabels.get(fieldids.indexOf(""+tmpfield1id));
		  }
		}
    //公式 操作符
		if(tmpoperation!=0){
			if(tmpoperation==1){
				expression += " + ";
			}else if(tmpoperation==2){
				expression += " - ";
			}else if(tmpoperation==3){
				expression += " * ";
			}else if(tmpoperation==4){
				expression += " / ";
			}
      //公式 第二操作符
			if(tmpfield2id == -10){
				expression +=  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"1" ;
			}else if(tmpfield2id == -11){
				expression +=  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"2" ;
			}else if(tmpfield2id == -12){
				expression +=  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3" ;
			}else if(tmpfield2id == -13){
				expression +=  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1" ;
			}else if(tmpfield2id == -14){
				expression +=  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2" ;
			}else if(tmpfield2id == -15){
				expression +=  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3" ;
			}else if(tmpfield2id == -16){
				expression +=  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1" ;
			}else if(tmpfield2id == -17){
				expression +=  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2" ;
			}else if(tmpfield2id == -18){
				expression +=  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3" ;
			}else if(tmpfield2id == -19){
				expression +=  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1" ;
			}else if(tmpfield2id == -20){
				expression +=  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2" ;
			}else if(tmpfield2id == -21){
				expression +=  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3" ;
			}else if(tmpfield2id == -22){
				expression +=  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1" ;
			}else if(tmpfield2id == -23){
				expression +=  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2" ;
			}else if(tmpfield2id == -24){
				expression +=  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3" ;
			}else{
				expression += ""+fieldlabels.get(fieldids.indexOf(""+tmpfield2id));
			}
		}
	}
  //公式 目标值
	if(!expression.equals("") || (expression.equals("") && tmpfield1id == 0)){//xwj for td3308 on 20051212
		if(tmpfieldid == -10){
			expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"1 = "+expression;
		}else if(tmpfieldid == -11){
			expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"2 = "+expression;
		}else if(tmpfieldid == -12){
			expression =  SystemEnv.getHtmlLabelName(15627,user.getLanguage())+"3 = "+expression;
		}else if(tmpfieldid == -13){
			expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"1 = "+expression;
		}else if(tmpfieldid == -14){
			expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"2 = "+expression;
		}else if(tmpfieldid == -15){
			expression =  SystemEnv.getHtmlLabelName(15628,user.getLanguage())+"3 = "+expression;
		}else if(tmpfieldid == -16){
			expression =  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"1 = "+expression;
		}else if(tmpfieldid == -17){
			expression =  SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"2 = "+expression;
		}else if(tmpfieldid == -18){
			expression = SystemEnv.getHtmlLabelName(15629,user.getLanguage())+"3 = "+expression;
		}else if(tmpfieldid == -19){
			expression =  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"1 = "+expression;
		}else if(tmpfieldid == -20){
			expression = SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"2 = "+expression;
		}else if(tmpfieldid == -21){
			expression =  SystemEnv.getHtmlLabelName(15630,user.getLanguage())+"3 = "+expression;
		}else if(tmpfieldid == -22){
			expression = SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"1 = "+expression;
		}else if(tmpfieldid == -23){
			expression = SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"2 = "+expression;
		}else if(tmpfieldid == -24){
			expression =  SystemEnv.getHtmlLabelName(15631,user.getLanguage())+"3 = "+expression;
		}else{
			if(fieldids.indexOf(""+tmpfieldid)!=-1)
			  expression =""+fieldlabels.get(fieldids.indexOf(""+tmpfieldid))+" = "+expression;
		}
	}

	if((tmprules & 1) ==1)
		addrules += SystemEnv.getHtmlLabelName(15638,user.getLanguage()) ;
	if((tmprules & 2) ==2)
		addrules += SystemEnv.getHtmlLabelName(15639,user.getLanguage()) ;


%>
 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
<td><input type='checkbox' name='check_node' value="<%=tmpid%>" ></td>
<td><%=expression%></td>
<td>
<%=addrules%>
</td>

</tr>
<%
if(linecolor==0) linecolor=1;
          else linecolor=0;
}
if(nodeid!=0)
            RecordSet.executeSql("select * from workflow_addinoperate where objid="+nodeid+" and isnode=1 and type=2 and ispreadd=1");
        else if(linkid!=0)
            RecordSet.executeSql("select * from workflow_addinoperate where objid="+nodeid+" and isnode=0 and type=2 and ispreadd=1");
    if(RecordSet.next()){
		customeraction=RecordSet.getString("customervalue");
	}

    List l=StaticObj.getServiceIds(Action.class);
	if(!customeraction.equals("")||l.size()>0){
%>
<TR class="Title">
    	  <TH colSpan=5><%=SystemEnv.getHtmlLabelName(20977,user.getLanguage())%></TH></TR>
<TR class="Spacing" style="height: 1px;"><TD class="Line1" colspan=5 style="padding: 0px;"></TD></TR>
<tr>
<td nowrap>
<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>：
</td>
<td colspan="2">
<select name="interface" onchange="onSelectInterface();">
<%

    //System.out.println(l.size());
	if(!customeraction.equals("")){%>

	<option value='<%=customeraction%>' selected><%=customeraction%></option>
	<%}
	for(int i=0;i<l.size();i++){
      if(l.get(i).equals(customeraction)) continue;
%>
<option value='<%=l.get(i)%>'><%=l.get(i)%></option>
<%}%>
</select>
<input type=checkbox name=enableInterface  onclick="checkInterface()" <%if(!customeraction.equals("")){%>checked<%}%>>

</td>
</tr>
<%}%>
<tr>



<%

String type=IntegratedSapUtil.getIsOpenEcology70Sap();


	if(istemplate!=1&&(isDmlAction || isWsAction || isSapAction)){ %>
	<tr><td colspan="3">
	<table width="100%" class="liststyle" cellspacing="1"  >
		<COLGROUP>
		<COL width="5%">
		<COL width="35%">
		<COL width="35%">
		<COL width="25%">
		<TR class="Spacing" style="height: 1px;"><TD class="Line1" colspan=5 style="padding: 0px;"></TD></TR>
		<TR>
		<td colSpan="3" width="65%">
			<%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>：
			<select id="actionlist" name="actionlist">
				<%if(isDmlAction){%>
				<option value="1">DML<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
				<%}%>
				<%if(isWsAction){%>
				<option value="2">WebService<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
				<%}%>
				<%if(isSapAction){%>
				<option value="3">SAP<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
				<%}%>
			</select>
		</td>
		<TD align="right" width="35%">
			<DIV align=right>
			<BUTTON type='button' class=btn_actionList onclick=addRow();><SPAN id=addrowspan><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></SPAN></BUTTON><!-- 增加 -->
				&nbsp;&nbsp;
			<BUTTON type='button' class=btn_actionList onclick=delRow();><SPAN id=delrowspan><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></SPAN></BUTTON><!-- 删除 -->
			</DIV>
		</TD>
	</TR>
	
	<TR class="Spacing" style="height: 1px;"><TD class="Line1" colspan=5 style="padding: 0px;"></TD></TR>
	<%
	List actionList = DMLActionBase.getDMLActionByNodeOrLinkId(wfid,nodeid,linkid,"1");
	boolean islight = false;
	for(int i =0;i<actionList.size();i++)
	{
		List dmlList = (List)actionList.get(i);
		if(dmlList==null||dmlList.size()<3)
		{
			continue;
		}
		String dmlid = (String)dmlList.get(0);
		String dmlactionname = (String)dmlList.get(1);
		String dmltype = (String)dmlList.get(2);
	%>
	<tr class="<%if(islight){ %>datalight<%}else{%>datadark<%} %>">
		<td>
			<input type="checkbox" id="dmlid" name="dmlid" value="<%=dmlid%>">
			<input type="hidden" id="actiontype<%=dmlid%>" name="actiontype<%=dmlid%>" value="0">
		</td>
		<td nowrap>
			<a href="#" onclick="editAction('<%=dmlid %>', 0);"><%=dmlactionname %></a>
		</td>
		<td nowrap>
			DML<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>
		</td>
		<td>
			<%=dmltype %><%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%>
		</td>
	</tr>
	<%
		islight = islight?false:true;
	}
	
	//webservice action 列表
	wsActionManager.setActionid(0);
	ArrayList wsActionList = wsActionManager.doSelectWsAction(wfid,nodeid,linkid,1);
	for(int i =0;i<wsActionList.size();i++){
		ArrayList wsAction = (ArrayList)wsActionList.get(i);
		int actionid_t = Util.getIntValue((String)wsAction.get(0));
		String actionname_t = Util.null2String((String)wsAction.get(1));
	%>
	<tr class="<%if(islight){ %>datalight<%}else{%>datadark<%} %>">
		<td>
			<input type="checkbox" id="dmlid" name="dmlid" value="<%=actionid_t%>">
			<input type="hidden" id="actiontype<%=actionid_t%>" name="actiontype<%=actionid_t%>" value="1">
		</td>
		<td nowrap>
			<a href="#" onclick="editAction('<%=actionid_t%>', 1);"><%=actionname_t%></a>
		</td>
		<td colspan="2" nowrap>
			WebService<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>
		</td>
	</tr>
	<%
		islight = islight?false:true;
	}
	//sap action 列表
	ArrayList sapActionList = sapActionManager.getSapActionSetList(wfid,nodeid,linkid,1);
	for(int i =0;i<sapActionList.size();i++){
		ArrayList sapAction = (ArrayList)sapActionList.get(i);
		int actionid_t = Util.getIntValue((String)sapAction.get(0));
		String actionname_t = Util.null2String((String)sapAction.get(1));
	%>
	<tr class="<%if(islight){ %>datalight<%}else{%>datadark<%} %>">
		<td>
			<input type="checkbox" id="dmlid" name="dmlid" value="<%=actionid_t%>">
			<input type="hidden" id="actiontype<%=actionid_t%>" name="actiontype<%=actionid_t%>" value="2">
		</td>
		<td nowrap>
			<a href="#" onclick="editAction('<%=actionid_t%>', 2);"><%=actionname_t%></a>
		</td>
		<td colspan="2" nowrap>
			Sap<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%>
		</td>
	</tr>
	<%
		islight = islight?false:true;
	}
	
	
	%>
	
	
		<%
		//zzl
		RecordSet rs = new RecordSet();
		sql = "select * from int_BrowserbaseInfo where ";
		if(nodeid > 0){
			sql = sql + " w_fid="+wfid+" and w_nodeid="+nodeid+" and ispreoperator=1 order by id";
		}else{
			sql = sql + " w_fid="+wfid+" and nodelinkid="+linkid+" order by id";
		}
		rs.execute(sql);
		while(rs.next()){
			String baseid=rs.getString("id");
			String mark=rs.getString("mark");
			String brodesc=rs.getString("brodesc");
			String w_enable=Util.getIntValue(rs.getString("w_enable"),0)+"";
	%>
		<tr class="<%if(islight){ %>datalight<%}else{%>datadark<%} %>">
			<td>
				<input type="checkbox" id="dmlidnewsap" name="dmlidnewsap" value="<%=baseid%>">
			</td>
			<td><span onclick=seeRowEcology7('<%=mark%>') style="cursor: pointer;"><%=mark%></span></td>
			<td><%=brodesc%></td>
			<td style="text-align: center;">
				<%
				if("1".equals(w_enable))
				{
					out.println("启用");
					if(!hascon)//不是true的情况下变成true,本身是true的情况下不再变
					{
						hascon = true; //表示启动绿勾
					}
				}else
				{
					out.println("不启用");
				} 
				%>
			</td>
		</tr>
	<%
		islight = islight?false:true;
		}
		
	%>
			
	</table></td></tr>
<%
}
%>
</table>

</form>
<script language=javascript>
var urls = new Array();
var isCustomer = false;
var isOtherProperty = false;
var curIndex = 0;
var curfieldid=0;
var curisdetail=0;
<%
    String browserSql = "select * from workflow_browserurl order by id desc";
    String idStr = "";
    String urlStr = "";
    RecordSet.executeSql(browserSql);
    while(RecordSet.next()){
%>
        urls[<%=Util.getIntValue(RecordSet.getString("id"),0)%>] = "<%=RecordSet.getString("browserurl")%>";
<%
    }
%>






operList = window.document.forms[0].operation;
op2List = window.document.forms[0].fieldop2id;
op1List = window.document.forms[0].fieldop1id;
objList = window.document.forms[0].fieldid;
var tempbrowsertype = "";

function changefieldid(objvalue){
	
	var _objvalue = objvalue.substring(0,objvalue.lastIndexOf("_"));
	try{
		tempbrowsertype = eval("urlvalue._"+_objvalue);
	}catch(e){
		tempbrowsertype = "";
	}

    curisdetail=objvalue.substring(0,objvalue.indexOf("_"));
    objvalue=objvalue.substring(objvalue.indexOf("_")+1);
    curfieldid=objvalue.substring(0,objvalue.indexOf("_"));
    document.all("fieldop1idvalue").value=""
    document.all("unitspan").innerHTML="";

	if(document.all("fieldop1id").value==0){
		alert("<%=SystemEnv.getHtmlLabelName(15640,user.getLanguage())%>!");
		document.all("fieldid").value=0;
	}


    if(isCustomer){
        operList.style.display='none';
		    op2List.style.display='none';
        if((objvalue!="0") && objvalue.indexOf("_3_")!=-1 && objvalue.indexOf("_3_19")==-1 && objvalue.indexOf("_1_3")==-1){
            //alert(objvalue.substring(objvalue.lastIndexOf("_")+1,objvalue.length));
            temp = objvalue.substring(0,objvalue.lastIndexOf("_"));
            curIndex = (temp.substring(temp.lastIndexOf("_")+1,temp.length))*1;
            document.all("fieldBrowser").style.display='';
            document.all("fieldop1idvalue").style.display='none';
            //document.all("fieldop1id").style.width='100%';

        }else{
            //operList.style.display='';
            //op2List.style.display='';
            document.all("fieldBrowser").style.display='none';
            document.all("fieldop1idvalue").style.display='';
            //document.all("fieldop1id").style.width='50%';
        }
    }

  objvalue = document.all("fieldid").value;
    objvalue=objvalue.substring(objvalue.indexOf("_")+1);
    //htmltype = objvalue.substring(objvalue.indexOf("_")+1,objvalue.lastIndexOf("_"));
	//type = objvalue.substring(objvalue.lastIndexOf("_")+1,objvalue.length);
    indexFirst=objvalue.indexOf("_");
    indexSecond=objvalue.indexOf("_",indexFirst+1);
	indexThird=objvalue.indexOf("_",indexSecond+1);
    
	htmltype=objvalue.substring(indexFirst+1,indexSecond);
	type=objvalue.substring(indexSecond+1,indexThird);
  if(isOtherProperty && htmltype=="6") {
    document.all("otherPropertyName").style.display='';
    document.all("otherProperty6Value").style.display='';
  }

	for(i = op1List.length-1; i >= 0; i--) {
		if (op1List.options[i] != null){
			op1List.options[i] = null;
		}
	}
	//增加必有的自定义值选项（15632）
	op1List.options[0] = new Option('<%=SystemEnv.getHtmlLabelName(15632,user.getLanguage())%>','customervalue');
	if(htmltype==3){
		if(type==17||type==166){//多人力资源、分权多人力资源--创建人经理、创建人下属、操作人经理、操作人下属
			op1List.options[1] = new Option('<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>','0_-3_3_1');
			op1List.options[2] = new Option('<%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%>','0_-4_3_17');
			op1List.options[3] = new Option('<%=SystemEnv.getHtmlLabelName(22665,user.getLanguage())%>','0_-5_3_1');
			op1List.options[4] = new Option('<%=SystemEnv.getHtmlLabelName(22692,user.getLanguage())%>','0_-25_3_1');
		}else if(type==1||type==165){//人力资源、分权单人力资源--创建人经理、操作人经理
			op1List.options[1] = new Option('<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>','0_-3_3_1');
			op1List.options[2] = new Option('<%=SystemEnv.getHtmlLabelName(22665,user.getLanguage())%>','0_-5_3_1');
		}else if(type==4||type==167){//部门、分权单部门--创建人（操作人）本部门、上级部门
			op1List.options[1] = new Option('<%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%>','0_-6_3_1');
			op1List.options[2] = new Option('<%=SystemEnv.getHtmlLabelName(22666,user.getLanguage())%>','0_-7_3_1');
			op1List.options[3] = new Option('<%=SystemEnv.getHtmlLabelName(22667,user.getLanguage())%>','0_-8_3_1');
			op1List.options[4] = new Option('<%=SystemEnv.getHtmlLabelName(22668,user.getLanguage())%>','0_-9_3_1');
		}
	}
}

function changefieldop1id(){
	
	objvalue = document.all("fieldid").value;
    curisdetail=objvalue.substring(0,objvalue.indexOf("_"));
    objvalue=objvalue.substring(objvalue.indexOf("_")+1);
    curfieldid=objvalue.substring(0,objvalue.indexOf("_"));


	fieldop1id = document.all("fieldop1id").value;
	if(fieldop1id=="customervalue"){
        if(isCustomer){
            operList.style.display='none';
		    op2List.style.display='none';
            if((objvalue!="0") && objvalue.indexOf("_3_")!=-1 && objvalue.indexOf("_3_19")==-1 && objvalue.indexOf("_1_3")==-1){
                temp = objvalue.substring(0,objvalue.lastIndexOf("_"));
                curIndex = (temp.substring(temp.lastIndexOf("_")+1,temp.length))*1;
                document.all("fieldBrowser").style.display='';
                document.all("fieldop1idvalue").style.display='none';
            }else{
                document.all("fieldBrowser").style.display='none';
                document.all("fieldop1idvalue").style.display='';
            }
        }
	}else{
		document.all("fieldBrowser").style.display='none';
		document.all("fieldop1idvalue").style.display='none';
	}


}

var objvalue="customervalue";
    document.all("fieldop1idvalue").value=""
	document.all("fieldop1idvalue").style.display='none';
	document.all("fieldBrowser").style.display='none';
	document.all("fieldop1id").style.width='100%';
	oDateRuleTr.style.display='none';

  var i=0;
	for(i = operList.length-1; i >= 0; i--) {
		if (operList.options[i] != null){
			operList.options[i] = null;
		}
	}

	for(i = op2List.length-1; i >= 0; i--) {
		if (op2List.options[i] != null){
			op2List.options[i] = null;
		}
	}

	for(i = objList.length-1; i >= 0; i--) {
		if (objList.options[i] != null){
			objList.options[i] = null;
		}
	}
	i=0;
	<%=objOptions%>


        isCustomer = true;
        isOtherProperty=false;
        operList.style.display='none';
		    op2List.style.display='none';
        document.all("otherPropertyName").style.display='none';
        document.all("otherProperty6Value").style.display='none';
		    document.all("fieldop1idvalue").style.display='';
		    operList.options[0] = new Option('<%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%>','0');
		    op2List.options[0] = new Option('<%=SystemEnv.getHtmlLabelName(15619,user.getLanguage())%>','0');



	id = objvalue.substring(0,objvalue.indexOf("_"));
	htmltype = objvalue.substring(objvalue.indexOf("_")+1,objvalue.lastIndexOf("_"));
	type = objvalue.substring(objvalue.lastIndexOf("_")+1,objvalue.length);



	i=0;
	<%=operOptions%>

	i=0;
	<%=op2Options%>


	if((htmltype=="1" && type=="1") || htmltype=="2"){
	//	alert("文本");
		for(var i = operList.length-1; i >= 0; i--) {
			if (operList.options[i] != null){
				tmpvalue = operList.options[i].value;
				if((tmpvalue!="1")&& (tmpvalue!="0")){
					operList.options[i] = null;
				}
			}
		}
		for(var i = op2List.length-1; i >= 0 ; i--) {
			if (op2List.options[i] != null){
				tmpvalue = op2List.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_1")==-1 && tmpvalue.indexOf("_2_0")==-1){
					op2List.options[i] = null;
				}
			}
		}
		for(var i = objList.length-1; i >= 0 ; i--) {
			if (objList.options[i] != null){
				tmpvalue = objList.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_1")==-1 && tmpvalue.indexOf("_2_0")==-1){
					objList.options[i] = null;
				}
			}
		}

	}else if((htmltype=="1" && type=="2") || (htmltype=="1" && type=="3") ){
	//	alert("整数");
	//	alert("浮点数");
		for(var i = op2List.length-1; i >= 0 ; i--) {
			if (op2List.options[i] != null){
				tmpvalue = op2List.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_2")==-1 && tmpvalue.indexOf("_1_3")==-1){
					op2List.options[i] = null;
				}
			}
		}
		for(var i = objList.length-1; i >= 0 ; i--) {
			if (objList.options[i] != null){
				tmpvalue = objList.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_2")==-1 && tmpvalue.indexOf("_1_3")==-1){
					objList.options[i] = null;
				}
			}
		}

	}else if(htmltype=="3" && type=="2"){
	//	alert("日期");
		oDateRuleTr.style.display='';
		for(var i = operList.length-1; i >= 0; i--) {
			if (operList.options[i] != null){
				tmpvalue = operList.options[i].value;
				if((tmpvalue!="1")&& (tmpvalue!="0")&& (tmpvalue!="2")){
					operList.options[i] = null;
				}
			}
		}
		for(var i = op2List.length-1; i >= 0 ; i--) {
			if (op2List.options[i] != null){
				tmpvalue = op2List.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_2")==-1 && tmpvalue.indexOf("_3_2")==-1){
					op2List.options[i] = null;
				}
			}
		}
		for(var i = objList.length-1; i >= 0 ; i--) {
			if (objList.options[i] != null){
				tmpvalue = objList.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_2")==-1 && tmpvalue.indexOf("_3_2")==-1){
					objList.options[i] = null;
				}
			}
		}

	}else if(htmltype=="3" && type=="19"){
	//	alert("时间");
		for(var i = operList.length-1; i >= 0; i--) {
			if (operList.options[i] != null){
				tmpvalue = operList.options[i].value;
				if((tmpvalue!="1")&& (tmpvalue!="0")&& (tmpvalue!="2")){
					operList.options[i] = null;
				}
			}
		}
		for(var i = op2List.length-1; i >= 0 ; i--) {
			if (op2List.options[i] != null){
				tmpvalue = op2List.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_3")==-1 && tmpvalue.indexOf("_3_19")==-1){
					op2List.options[i] = null;
				}
			}
		}
		for(var i = objList.length-1; i >= 0 ; i--) {
			if (objList.options[i] != null){
				tmpvalue = objList.options[i].value;
				if((tmpvalue!="0") && tmpvalue.indexOf("_1_3")==-1 && tmpvalue.indexOf("_3_19")==-1){
					objList.options[i] = null;
				}
			}
		}
	}else if(htmltype=="6" ){
    alert("附件上传：========== objvalue ==== "+objvalue);
  }




function onSave(){
	if(objList.value=="0"){
    alert("<%=SystemEnv.getHtmlLabelName(15642,user.getLanguage())%>!");
    return;
	}else if(isCustomer&&document.all("fieldop1idvalue").value==""){
    //alert("自定义值不能为空"); //xwj for td3308 on 20051212
    //return;
  }

  //排除'文档上传'外的其他字段保存'其他属性'
  objvalue = document.all("fieldid").value;
    objvalue=objvalue.substring(objvalue.indexOf("_")+1);
    htmltype = objvalue.substring(objvalue.indexOf("_")+1,objvalue.lastIndexOf("_"));
	type = objvalue.substring(objvalue.lastIndexOf("_")+1,objvalue.length);
  if(isOtherProperty && htmltype!="6"){
    alert("<%=SystemEnv.getHtmlLabelName(19562,user.getLanguage())%>")
    return;
  }

	if(op1List.value=="customervalue"){
		tmpvalue = document.all("fieldop1idvalue").value;

		objvalue = objList.value.substring(objvalue.indexOf("_")+1);
		id = objvalue.substring(0,objvalue.indexOf("_"));
		temp = objvalue.substring(objvalue.indexOf("_")+1,objvalue.lastIndexOf("_"));
		htmltype = temp.substring(0,temp.indexOf("_"));
		type = temp.substring(temp.lastIndexOf("_")+1,temp.length);
		
		lens = objvalue.substring(objvalue.lastIndexOf("_")+1,objvalue.length);

		if(htmltype ==1 && type==1 && lens != -1){
			len1 = realLength(tmpvalue);
			if(lens<len1){
				alert("<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>"+lens+"(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)");
				return;
			}
		}else if((htmltype ==1 && type==2)){
			if(checkInt(tmpvalue)){
				alert("<%=SystemEnv.getHtmlLabelName(15643,user.getLanguage())%>!");
				return;
			}
		}else if((htmltype ==1 && type==3)){
			if(checkFloat(tmpvalue)) {
				alert("<%=SystemEnv.getHtmlLabelName(15644,user.getLanguage())%>!");
				return;
			}
		}else if((htmltype ==1 && type==5)){
			if(checkFloat(tmpvalue)) {
				alert("<%=SystemEnv.getHtmlLabelName(15644,user.getLanguage())%>!");
				return;
			}
			changeToThousands("fieldop1idvalue");
		}else if((htmltype ==3 && type==2)){
			if(checkDate(tmpvalue)) {
				alert("<%=SystemEnv.getHtmlLabelName(15645,user.getLanguage())%>!");
				return;
			}
		}else if((htmltype ==3 && type==19)){
			if(checkTime(tmpvalue)) {
				alert("<%=SystemEnv.getHtmlLabelName(15646,user.getLanguage())%>!");
				return;
			}
		}
	}
	document.all("src").value="add";
	document.SearchForm.submit();
}
function checkInt(objval)
{
	valuechar = objval.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
	return isnumber;
}
function checkFloat(objval)
{
	valuechar = objval.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=".") isnumber = true ;}
	return isnumber;
}
function checkTime(objval)
{
	valuechar = objval.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;}
	return isnumber;
}
function checkDate(objval)
{
	valuechar = objval.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!="-") isnumber = true ;}
	return isnumber;
}
function onDelete(){
	document.all("src").value="delete";
	document.SearchForm.submit();
}
function onClose(){
	//td37970 start
	if($G("src").value!=""){
		return;
	}
	//td37970 end
    <%if(hascon){%>
        window.parent.returnValue = "1"
    <%}else{%>
        window.parent.returnValue = "0"
    <%}%>
	window.parent.close();

}
//工作流图形化确定
function designOnClose() {
	//td37970 start
	if($G("src").value!=""){
		return;
	}
	//td37970 end
	//td19600
	<%
		boolean bolFlag = false;
	    bolFlag = hascon;
	%>
	window.parent.design_callback('showpreaddinoperate','<%=bolFlag%>');
	//td19600
}
function editAction(actionid, actiontype_)
{
	var addurl = "";
	if(actiontype_ == 0){
		addurl = "/systeminfo/BrowserMain.jsp?url=/workflow/dmlaction/DMLActionSettingEdit.jsp?actionid="+actionid+"&workflowId=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1";
	}else if(actiontype_ == 1){
		addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/workflow/action/WsActionEditSet.jsp?actionid="+actionid+"&operate=editws&workflowid=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1");
	}else if(actiontype_ == 2){
		addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/workflow/action/SapActionEditSet.jsp?actionid="+actionid+"&operate=editsap&workflowid=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1");
	}
	var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
}

//zzl
function addRowEcology7()
{
	var args="?workflowId=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1&workflowid=<%=wfid%>&w_type=1";
	var addurl="/integration/browse/integrationBrowerMain.jsp"+args;
	var id_t = window.showModalDialog(addurl,"","dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
	//如何刷新页面
	//if(id_t)
	//{
		$G("src").value="refush";
		document.SearchForm.submit();//新建的时候刷新节点后保存界面
	//}
}
function seeRowEcology7(mark)
{
	
	var args="?workflowId=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1&workflowid=<%=wfid%>&w_type=1&mark="+mark+"";
	var addurl="/integration/browse/integrationBrowerMain.jsp"+args;
	var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
}
function checkecology7(obj)
{
	$("#ecology70 tr td [type=checkbox][name=baseInfobox]").each(function(){
			var flag=obj.checked;
			$(this).attr('checked',flag);
	});
	
}

function addRow()
{
	var addurl = "";
	var actionlist_t = document.getElementById("actionlist").value;
	if(actionlist_t == 1){
		addurl = "/systeminfo/BrowserMain.jsp?url=/workflow/dmlaction/DMLActionSettingAdd.jsp?workflowId=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1";
	}else if(actionlist_t == 2){
		addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/workflow/action/WsActionEditSet.jsp?operate=addws&workflowid=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1");
	}else if(actionlist_t == 3){
	
	    <%
	    	if(type.equals("0")){
	    		//老版本的sap功能
	    %>
	    		addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/workflow/action/SapActionEditSet.jsp?operate=adsap&workflowid=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1");
	    <%
	    		
	    	}else{
	    		//新版本的sap功能
	    %>
	    		//zzl
				var args="?workflowId=<%=wfid%>&nodeid=<%=nodeid%>&nodelinkid=<%=linkid%>&ispreoperator=1&workflowid=<%=wfid%>&w_type=1";
			    addurl="/integration/browse/integrationBrowerMain.jsp"+args;
	    <%
	    	}
	    %>
		
	}
	var id_t = window.showModalDialog(addurl,window,"dialogWidth:1000px;dialogHeight:800px;scroll:yes;resizable:yes;")
}
function delRow()
{
	var hasselected = false;
	var dmlids = document.getElementsByName("dmlid");
	
	//zzl
	var dmlidnewsaps = document.getElementsByName("dmlidnewsap");
	
	if(dmlids&&dmlids.length>0)
	{
		for(var i = 0;i<dmlids.length;i++)
		{
			var dmlid = dmlids[i];
			if(dmlid.checked)
			{
				hasselected = true;
				break;
			}
		}
	}
	
	//zzl
	if(dmlidnewsaps&&dmlidnewsaps.length>0)
	{
		for(var i = 0;i<dmlidnewsaps.length;i++)
		{
			var dmlidnewsap = dmlidnewsaps[i];
			if(dmlidnewsap.checked)
			{
				hasselected = true;
				break;
			}
		}
	}
	
	if(!hasselected)
	{
		//请先选择需要删除的数据
		alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>!");
		return;
	}
	if (isdel())
	{
		document.all("src").value="deletedmlaction";
	    document.SearchForm.submit();
	}
}
function reloadDMLAtion()
{
	document.getElementById("src").value = "savebaseaction";
	document.SearchForm.submit();
}
</script>

<script language="javascript">
function submitData()
{
	if (confirmdel())
		form2.submit();
}

function submitClear()
{
	//TD24113:修正设置节点附加前操作时未选择数据点击删除时提示信息错误的问题 ADD BY QB START
	var isChecked = false;
	for(var i=0;i<document.getElementsByName("check_node").length;i++){
		if (document.getElementsByName("check_node")[i].checked) {
			isChecked = true;
			break;
		}
	}

	if (isChecked) {
		if (isdel()){
			onDelete();
		}
	} else {
			alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		}
	
	
	//if (isdel()){
	//		onDelete();
	//	}
	//TD24113:修正设置节点附加前操作时未选择数据点击删除时提示信息错误的问题 ADD BY QB END
}

function checkInterface(){
	if(document.all("enableInterface").checked){
     document.all("src").value="addInterface";
	  document.SearchForm.submit();
	}else{
     document.all("src").value="delInterface";
	  document.SearchForm.submit();
	}

}
function onSelectInterface(){

    if(document.all("interface").value=="none"){
     document.all("enableInterface").style.display="none";

	}else{

     document.all("enableInterface").style.display="";
	}

}
function showPreDBrowser(url,objtype){
   if(objtype == 2 || objtype == 19){
    WdatePicker({el:'unitspan',onpicked:function(dp){
			$dp.$('fieldop1idvalue').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('fieldop1idvalue').value = ''}});
   }else{
     if(objtype=="161"||objtype=="162")
		url = url + "?type="+tempbrowsertype;
	
	if(objtype=="226"||objtype=="227")
	{
		var  sapfieldid=$("#fieldid").val();
		url+=saphashmap.get(sapfieldid.split("_")[1]);
	
	}
	 if(objtype=="141"){
	 	onShowResourceConditionBrowser();
	 }else{
     	onShowBrowser(url,objtype);
	 }
   }
}
function uescape(url){
    return escape(url);
}

function onShowBrowser(url,objtype){
	if (objtype!="161" && objtype!="162") {
		url= url+"?selectedids="+$G("fieldop1idvalue").value;
	}
    if (objtype==165 || objtype==166 || objtype==167 || objtype==168) {
        temp=uescape("&fieldid="+curfieldid+"&isdetail="+curisdetail);
        myid = window.showModalDialog(url+temp);
        if (myid) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != ""){
                unitspan.innerHTML = wuiUtil.getJsonValueByIndex(myid,1);
                if (wuiUtil.getJsonValueByIndex(myid,1).substr(0,1)==",") {
                    $G("fieldop1idvalue").value =wuiUtil.getJsonValueByIndex(myid,0).substr(1);
                    unitspan.innerHTML =wuiUtil.getJsonValueByIndex(myid,1).substr(1);
                }else{
                    $G("fieldop1idvalue").value =wuiUtil.getJsonValueByIndex(myid,0);
                    unitspan.innerHTML = wuiUtil.getJsonValueByIndex(myid,1);
                }
            }else{
                unitspan.innerHTML = ""
                $G("fieldop1idvalue").value = ""
            }
        }
    }else{
        myid = window.showModalDialog(url);
        if (myid) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != "") {
                unitspan.innerHTML =wuiUtil.getJsonValueByIndex(myid,1);
                if (wuiUtil.getJsonValueByIndex(myid,0).substr(0,1)==",") {
                    $G("fieldop1idvalue").value =wuiUtil.getJsonValueByIndex(myid,0).substr(1);
                    unitspan.innerHTML =wuiUtil.getJsonValueByIndex(myid,1).substr(1);
                }else{
                    $G("fieldop1idvalue").value = wuiUtil.getJsonValueByIndex(myid,0);
                    unitspan.innerHTML = wuiUtil.getJsonValueByIndex(myid,1);
                }
            }else{
                unitspan.innerHTML = ""
                $G("fieldop1idvalue").value = ""
            }
        }
    }
}



</script>

<script language="vbscript">
sub onShowBrowser1(url,objtype)
	if objtype<>"161" and objtype<>"162"  and objtype<>"226" and objtype<>"227"  then
		url= url&"?selectedids="&document.all("fieldop1idvalue").value
	end if
    if objtype=165 or objtype=166 or objtype=167 or objtype=168 then
        temp=uescape("&fieldid="&curfieldid&"&isdetail="&curisdetail)
        myid = window.showModalDialog(url&temp)
        if (Not IsEmpty(myid)) then
            if myid(0)<> "" then
                unitspan.innerHtml = myid(1)
                'msgbox Left(myid(0),1)=","
                if Left(myid(0),1)="," then
                    document.all("fieldop1idvalue").value = Mid(myid(0),2,len(myid(0)))
                    unitspan.innerHtml = Mid(myid(1),2,len(myid(1)))
                else
                    document.all("fieldop1idvalue").value = myid(0)
                    unitspan.innerHtml = myid(1)
                end if
            else
                unitspan.innerHtml = ""
                document.all("fieldop1idvalue").value = ""
            end if
        end if
    else
        myid = window.showModalDialog(url)
        if (Not IsEmpty(myid)) then
            if myid(0)<> "" then
                unitspan.innerHtml = myid(1)
                'msgbox Left(myid(0),1)=","
                if Left(myid(0),1)="," then
                    document.all("fieldop1idvalue").value = Mid(myid(0),2,len(myid(0)))
                    unitspan.innerHtml = Mid(myid(1),2,len(myid(1)))
                else
                    document.all("fieldop1idvalue").value = myid(0)
                    unitspan.innerHtml = myid(1)
                end if
            else
                unitspan.innerHtml = ""
                document.all("fieldop1idvalue").value = ""
            end if
        end if
    end if
end sub

</script>

<script type="text/javascript">
function onShowResourceConditionBrowser() {
	var dialogId = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceConditionBrowser.jsp");
	if (dialogId) {
		if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
			var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
			var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
			var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
			var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
			var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
			var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
			var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
			var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);

			var sHtml = "";
			var fileIdValue = "";
			shareTypeValues = shareTypeValues.substr(1);
			shareTypeTexts = shareTypeTexts.substr(1);
			relatedShareIdses = relatedShareIdses.substr(1);
			relatedShareNameses = relatedShareNameses.substr(1);
			rolelevelValues = rolelevelValues.substr(1);
			rolelevelTexts = rolelevelTexts.substr(1);
			secLevelValues = secLevelValues.substr(1);
			secLevelTexts = secLevelTexts.substr(1);

			var shareTypeValueArray = shareTypeValues.split("~");
			var shareTypeTextArray = shareTypeTexts.split("~");
			var relatedShareIdseArray = relatedShareIdses.split("~");
			var relatedShareNameseArray = relatedShareNameses.split("~");
			var rolelevelValueArray = rolelevelValues.split("~");
			var rolelevelTextArray = rolelevelTexts.split("~");
			var secLevelValueArray = secLevelValues.split("~");
			var secLevelTextArray = secLevelTexts.split("~");
			for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {

				var shareTypeValue = shareTypeValueArray[_i];
				var shareTypeText = shareTypeTextArray[_i];
				var relatedShareIds = relatedShareIdseArray[_i];
				var relatedShareNames = relatedShareNameseArray[_i];
				var rolelevelValue = rolelevelValueArray[_i];
				var rolelevelText = rolelevelTextArray[_i];
				var secLevelValue = secLevelValueArray[_i];
				var secLevelText = secLevelTextArray[_i];

				fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
						+ relatedShareIds + "_" + rolelevelValue + "_"
						+ secLevelValue;

				if (shareTypeValue == "1") {
					sHtml = sHtml + "," + shareTypeText + "("
							+ relatedShareNames + ")";
				} else if (shareTypeValue == "2") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
				} else if (shareTypeValue == "3") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
				} else if (shareTypeValue == "4") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="
							+ rolelevelText
							+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
				} else {
					sHtml = sHtml
							+ ","
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
				}

			}
			
			sHtml = sHtml.substr(1);
			fileIdValue = fileIdValue.substr(1);

			$GetEle("fieldop1idvalue").value = fileIdValue;
			$GetEle("unitspan").innerHTML = sHtml;
		}
	} else {
		$GetEle("unitspan").innerHtml = "";
		$GetEle("fieldop1idvalue").value = "";
	}
}
</script>

<!--
TD8698
褚俊	2008.05.09
流程节点及出口信息附加操作设置页面建议区分主字段和明细字段
实现在select以层显示被选中的option
-->
<script Language="JavaScript">
//***********默认设置定义.*********************
var tPopWait=50;//停留tWait豪秒后显示提示。
var tPopShow=5000;//显示tShow豪秒后关闭提示
var showPopStep=20;
var popOpacity=99;
//***************内部变量定义*****************
var sPop=null;
var curShow=null;
var tFadeOut=null;
var tFadeIn=null;
var tFadeWaiting=null;
document.write("<style   type='text/css'id='defaultPopStyle'>");
document.write(".cPopText   { background-color: #F8F8F5;color:#000000; border:1px #000000 solid;font-color: font-size:12px;   padding-right:   4px;   padding-left:   4px;   height:   20px;   padding-top:   2px;   padding-bottom:   2px;   filter:   Alpha(Opacity=0)}");
document.write("</style>");
document.write("<div   id='dypopLayer' style='position:absolute;z-index:1000;display:none' class='cPopText'></div>");

function showPopupText(){
	var o=event.srcElement;

	MouseX=event.x;
	MouseY=event.y;
	if(o.alt!=null && o.alt!=""){
		o.dypop=o.alt;
		o.alt="";
	}
	if(o.title!=null && o.title!=""){
		o.dypop=o.title;
		o.title="";
	}
	if(o.dypop!=sPop){
		sPop=o.dypop;
		clearTimeout(curShow);
		clearTimeout(tFadeOut);
		clearTimeout(tFadeIn);
		clearTimeout(tFadeWaiting);
		if(sPop==null || sPop==""){
			dypopLayer.innerHTML="";
			dypopLayer.style.filter="Alpha()";
			dypopLayer.filters.Alpha.opacity=0;
		}else{
			if(o.dyclass!=null){
				popStyle=o.dyclass;
			}else{
				popStyle="cPopText";
			}
			curShow=setTimeout("showIt()",tPopWait);
		}
	}
}

function showIt(){
	dypopLayer.className=popStyle;
	dypopLayer.innerHTML=sPop;
	popWidth=dypopLayer.clientWidth;
	popHeight=dypopLayer.clientHeight;
	if(MouseX+12+popWidth>document.body.clientWidth){
		popLeftAdjust=-popWidth-24;
	}else{
		popLeftAdjust=0;
	}
	if(MouseY+12+popHeight>document.body.clientHeight){
		popTopAdjust=-popHeight-24;
	}else{
		popTopAdjust=0;
	}
	dypopLayer.style.left=MouseX+12+document.body.scrollLeft+popLeftAdjust;
	dypopLayer.style.top=MouseY+12+document.body.scrollTop+popTopAdjust;
	dypopLayer.style.filter="Alpha(Opacity=0)";
	fadeOut();
}

function fadeOut(){
	if(dypopLayer.filters.Alpha.opacity<popOpacity){
	dypopLayer.filters.Alpha.opacity+=showPopStep;
	tFadeOut=setTimeout("fadeOut()",1);
	}else{
		dypopLayer.filters.Alpha.opacity=popOpacity;
		tFadeWaiting=setTimeout("fadeIn()",tPopShow);
	}
}

function fadeIn(){
	if(dypopLayer.filters.Alpha.opacity>0){
		dypopLayer.filters.Alpha.opacity-=1;
		tFadeIn=setTimeout("fadeIn()",1);
	}
}
document.onmouseover=showPopupText;
function changeTitle(id, title){
	var s = document.getElementById(id);
	//alert(title);
	var isStr = s.options[s.selectedIndex].innerText;
//	for(var i=0;i<s.options.length;i++){
//		if(title == s.options[i].value){
//			isStr = s.options[i].innerText;
//		}
//	}
	s.title = isStr;
	//alert(s.title);
}

function onDrawBackFlg(){
	document.all("src").value="DrawBackFlg";
	document.SearchForm.submit();
}

if(fieldtempurl.length>0) fieldtempurl = fieldtempurl.substring(0,fieldtempurl.length-1);
fieldurl = " var urlvalue = {"+fieldtempurl+"}";
eval(fieldurl);

</script>
</body>
</html>
