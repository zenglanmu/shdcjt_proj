<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.formmode.setup.CodeBuild"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ModeDataManager" class="weaver.formmode.data.ModeDataManager" scope="page"/>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ModeViewLog" class="weaver.formmode.view.ModeViewLog" scope="page"/>


<%
FileUpload fu = new FileUpload(request);
String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int formmodeid = Util.getIntValue(fu.getParameter("formmodeid"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = 1;
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
if( src.equals("") || formid == -1 || isbill == -1 || formmodeid == -1) {
	out.print("<script>wfforward('/notice/noright.jsp');</script>");
    return ;
}
//是否来自导入明细保存
int fromImportDetail = Util.getIntValue(fu.getParameter("fromImportDetail"),0);
int pageexpandid = Util.getIntValue(fu.getParameter("pageexpandid"),0);

String viewfrom = Util.null2String(request.getParameter("viewfrom"));
int opentype = Util.getIntValue(request.getParameter("opentype"),0);
int customid = Util.getIntValue(request.getParameter("customid"),0);

ModeDataManager.setSrc(src);
ModeDataManager.setIscreate(iscreate);
ModeDataManager.setFormid(formid);
ModeDataManager.setIsbill(isbill);
ModeDataManager.setBillid(billid);
ModeDataManager.setFormmodeid(formmodeid);
ModeDataManager.setPageexpandid(pageexpandid);
ModeDataManager.setRequest(fu);
ModeDataManager.setUser(user);
boolean savestatus = ModeDataManager.saveModeData();
billid = ModeDataManager.getBillid();

int isfromTab = Util.getIntValue(fu.getParameter("isfromTab"),0);

if(billid > 0 && iscreate.equals("1")){
	CodeBuild cbuild = new CodeBuild(formmodeid);
	String codeStr = cbuild.getModeCodeStr(formid,billid);//生成编号
	//System.out.println("codeStr="+codeStr);
	ModeRightInfo.editModeDataShare(user.getUID(),formmodeid,billid);//新建的时候添加共享
}else if(billid > 0){
	//编辑的时候，修改建模主字段权限
	ModeRightInfo.editModeDataShareForModeField(user.getUID(),formmodeid,billid);//新建的时候添加共享
}

//数据保存成功，执行接口
if(savestatus&&!src.equals("del")){
	ModeDataManager.doInterface(pageexpandid);
}

//保存操作日志
String operatetype = "2";//操作的类型： 1：新建 2：修改 3：删除 4：查看
String clientaddress = request.getRemoteAddr();
String operatedesc = "修改";
int operateuserid = user.getUID();
int relatedid = billid;
String relatedname = "";
if(billid > 0 && iscreate.equals("1")){
	operatetype = "1";
	operatedesc = "新建";
}
if(src.equals("del")){
	operatetype = "3";
	operatedesc = "删除";
}

ModeViewLog.resetParameter();
ModeViewLog.setClientaddress(clientaddress);
ModeViewLog.setModeid(formmodeid);
ModeViewLog.setOperatedesc(operatedesc);
ModeViewLog.setOperatetype(operatetype);
ModeViewLog.setOperateuserid(operateuserid);
ModeViewLog.setRelatedid(relatedid);
ModeViewLog.setRelatedname(relatedname);
ModeViewLog.setSysLogInfo();

String messageid = ModeDataManager.getMessageid();//保存出错的错误信息id
String messagecontent = ModeDataManager.getMessagecontent();//保存出错的错误信息内容
session.setAttribute(formmodeid+"_"+billid+"_"+messageid,messagecontent);
//返回到模块页面，返回到查看页面或者列表页面，或者继续新建，或者编辑页面，或者关闭
if(fromImportDetail == 1){//是否来自导入明细保存
	response.sendRedirect("/formmode/view/AddFormMode.jsp?isfromTab="+isfromTab+"&modeId="+formmodeid+"&formId="+formid+"&type=2&billid="+billid+"&fromSave=1");
}else if(src.equals("del")){
%>
<script language="javascript">
	if("<%=viewfrom%>"=="fromsearchlist"&"<%=opentype%>"=="1"){
		window.parent.location = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=customid%>";
	}else{
		try{
			parent.window.opener._table.reLoad();	
		}catch(e){
			
		}
		window.parent.close();
	}
</script>
<%
}else{
	%>
	<script language="javascript">
		//var url = escape("/formmode/view/ModeShare.jsp?ajax=1&modeId=<%=formmodeid%>&billid=<%=billid%>");
		//window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
		try{
			parent.window.opener._table.reLoad();	
		}catch(e){
			
		}
		
		window.location.href="/formmode/view/AddFormMode.jsp?isfromTab=<%=isfromTab%>&modeId=<%=formmodeid%>&formId=<%=formid%>&type=0&billid=<%=billid%>&iscreate=<%=iscreate%>&messageid=<%=messageid%>&viewfrom=<%=viewfrom%>&opentype=<%=opentype%>&customid=<%=customid%>";
		
	</script>
	<%
	//response.sendRedirect("/formmode/view/AddFormMode.jsp?modeId="+formmodeid+"&formId="+formid+"&type=0&billid="+billid+"&fromSave=1");
}

%>