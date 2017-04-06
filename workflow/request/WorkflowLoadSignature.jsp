<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RequestLogIdUpdate" class="weaver.workflow.request.RequestLogIdUpdate" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int workflowRequestLogId = Util.getIntValue(request.getParameter("workflowRequestLogId"),0);
String isSignMustInput= Util.null2String(request.getParameter("isSignMustInput"));
int formSignatureWidth = Util.getIntValue(request.getParameter("formSignatureWidth"),0);
int formSignatureHeight = Util.getIntValue(request.getParameter("formSignatureHeight"),0);
String isFromWorkFlowSignUP= Util.null2String(request.getParameter("isFromWorkFlowSignUP"));
String opener="";
if(isFromWorkFlowSignUP.equals("1")){
	opener="opener.";
}

// 操作的用户信息
int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

   		boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid); 
   		String workflowPhrases[] = new String[RecordSet.getCounts()];
   		int x = 0 ;
   		if (isSuccess) {
   			while (RecordSet.next()){
   				workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
   				x ++ ;
   			}
   		}


			if(workflowRequestLogId<=0){
				int intRecordId=RequestLogIdUpdate.getRequestLogNewId();
            	boolean bSuccess=false;
            	if("oracle".equalsIgnoreCase(RecordSet.getDBType())){
            		bSuccess=RecordSet.executeSql("insert into Workflow_FormSignRemark(requestLogId,remark) values("+intRecordId+",empty_clob())");
            	}else{
            		bSuccess=RecordSet.executeSql("insert into Workflow_FormSignRemark(requestLogId,remark) values("+intRecordId+",'')");
            	}
				if(bSuccess){
					workflowRequestLogId=intRecordId;
				}
			}
%>
		   <script  language="javascript">
		   <%=opener%>document.frmmain.workflowRequestLogId.value=<%=workflowRequestLogId%>;	
			</script>

<%@ include file="/workflow/request/iWebRevisionConf.jsp" %>
<%
    String temStr = request.getRequestURI();
    temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

	String revisionServerUrl=request.getScheme()+"://"+Util.getRequestHost(request)+temStr+revisionServerName;;
	String revisionClientUrl=request.getScheme()+"://"+Util.getRequestHost(request)+temStr+revisionClientName;

	int RecordID=workflowRequestLogId;
	String UserName=username;
	String Consult_Enabled="1";

    String strInputList="";
	if(workflowPhrases.length>0){
		for (int i= 0 ; i <workflowPhrases.length;i++) {
			String workflowPhrase = workflowPhrases[i] ;
			if(workflowPhrase!=null&&!workflowPhrase.trim().equals("")){
				strInputList+=workflowPhrase+"\\r\\n";
			}
		}
		strInputList = Util.toScreenForJs(strInputList);
	}

%>

<script language=javascript>

//初始化名称为Consult的控件对象
function initializtion(){

  document.frmmain.Consult.WebUrl = "<%=revisionServerUrl%>";           //WebUrl:系统服务器路径，与服务器交互操作，如打开签章信息
  document.frmmain.Consult.RecordID = "<%=RecordID%>";           //RecordID:本文档记录编号
  document.frmmain.Consult.FieldName = "Consult";                //FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以
  document.frmmain.Consult.UserName = "<%=UserName%>";           //UserName:签名用户名称
  document.frmmain.Consult.WebSetMsgByName("USERID","<%=user.getUID()%>");          //USERID:签名用户id
  document.frmmain.Consult.Enabled = "<%=Consult_Enabled%>";     //Enabled:是否允许修改，0:不允许 1:允许  默认值:1 
  document.frmmain.Consult.PenColor = "#FF0000";                	//PenColor:笔的颜色，采用网页色彩值  默认值:#000000 
  document.frmmain.Consult.BorderStyle = "0";                    //BorderStyle:边框，0:无边框 1:有边框  默认值:1 
  document.frmmain.Consult.EditType = "0";                       //EditType:默认签章类型，0:签名 1:文字  默认值:0 
  document.frmmain.Consult.ShowPage = "0";                       //ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0 
  document.frmmain.Consult.InputText = "";                       //InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容 
  document.frmmain.Consult.PenWidth = "1";                      	//PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2 
  document.frmmain.Consult.FontSize = "14";                      //FontSize:文字大小，默认值:11
  document.frmmain.Consult.ShowMenu = "0";
  document.frmmain.Consult.SignatureType = "<%=SignatureType%>";                  //SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0}
  document.frmmain.Consult.InputList = "<%=strInputList%>"; //InputList:设置文字批注信息列表 
  document.frmmain.Consult.ShowUserListMenu = "true";			//签批用户列表是否显示，"true"为显示
  document.frmmain.Consult.CASignType = "<%=CASignType%>";//默认为不启用数字签名
  document.frmmain.Consult.SetFieldByName("DocEmptyJuggle",<%=DocEmptyJuggle%>);
}

function LoadSignature(){

	enableAllmenu();

    initializtion();                                              //js方式设置控件属性
    document.frmmain.Consult.LoadSignature();                              //调用签章数据信息
    document.frmmain.Consult.ImgWidth="<%=formSignatureWidth%>";
    document.frmmain.Consult.ImgHeight="<%=formSignatureHeight%>";

	displayAllmenu();

	return true;
}

if (window.addEventListener){
    window.addEventListener("load", LoadSignature, false);
}else if (window.attachEvent){
    window.attachEvent("onload", LoadSignature);
}else{
    window.onload=LoadSignature;
}

//作用：切换读取签章的来源方式  针对签章窗体Consult
function chgReadSignatureType(){
  if (document.frmmain.Consult.SignatureType=="1"){
    document.frmmain.Consult.SignatureType="0";
    alert("<%=SystemEnv.getHtmlLabelName(21436,user.getLanguage())%>");
  }else{
    document.frmmain.Consult.SignatureType="1";
    alert("<%=SystemEnv.getHtmlLabelName(21437,user.getLanguage())%>");
  }
}

var isDocEmpty=0;

//作用：保存签章数据信息  
//保存流程：先保存签章数据信息，成功后再提交到DocumentSave，保存表单基本信息
function SaveSignature(){

<%if(isSignMustInput.equals("1")){%>
    if(document.frmmain.Consult.DocEmpty){//判断签批区域是否为空内容
        isDocEmpty=1;
        return false;
    }
<%}%>

  if (document.frmmain.Consult.Modify){                    //判断签章数据信息是否有改动
//    if(document.frmmain.Consult.SaveAsJpgEx('iWebRevision_abcd.jpg','All', 'Remote')){
//	  <%=opener%>document.frmmain.workflowRequestLogId.value=document.frmmain.Consult.WebGetMsgByName("RECORDID");
//	  document.frmmain.Consult.RecordID=document.frmmain.Consult.WebGetMsgByName("RECORDID");
      if (!document.frmmain.Consult.SaveSignature()){        //保存签章数据信息
          return false;
      }
//	}else {
//		return false;
//	}

  }
  <%=opener%>document.frmmain.workflowRequestLogId.value=document.frmmain.Consult.WebGetMsgByName("RECORDID");
  document.frmmain.Consult.RecordID=document.frmmain.Consult.WebGetMsgByName("RECORDID");
  return true;
}

</script>
<%
String isIE = (String)session.getAttribute("browser_isie");
if ("true".equals(isIE)) {
%>
          <table border=0 width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
          <tbody >
          <tr  height='100%'>
            <td>
			  <a style='FONT-SIZE: 9pt;COLOR: #ff0000; FONT-FAMILY: "宋体";cursor:hand;TEXT-DECORATION: none' title="" onClick="if (!Consult.OpenSignature()){alert(Consult.Status);}">[<%=SystemEnv.getHtmlLabelName(21431,user.getLanguage())%>]</a>&nbsp;
			  <a style='FONT-SIZE: 9pt;COLOR: #ff0000; FONT-FAMILY: "宋体";cursor:hand;TEXT-DECORATION: none' onclick="if (Consult.EditType==0){Consult.EditType=1;}else{Consult.EditType=0;};">[<%=SystemEnv.getHtmlLabelName(21441,user.getLanguage())%>]</a>&nbsp;
			  <a style='FONT-SIZE: 9pt;COLOR: #ff0000; FONT-FAMILY: "宋体";cursor:hand;TEXT-DECORATION: none' title="" onClick="Consult.ShowSignature();">[<%=SystemEnv.getHtmlLabelName(21432,user.getLanguage())%>]</a>&nbsp;
			  <a style='FONT-SIZE: 9pt;COLOR: #ff0000; FONT-FAMILY: "宋体";cursor:hand;TEXT-DECORATION: none' onclick="Consult.Clear();">[<%=SystemEnv.getHtmlLabelName(21433,user.getLanguage())%>]</a>&nbsp;
			  <a style='FONT-SIZE: 9pt;COLOR: #ff0000; FONT-FAMILY: "宋体";cursor:hand;TEXT-DECORATION: none' onclick="Consult.ClearAll();">[<%=SystemEnv.getHtmlLabelName(21434,user.getLanguage())%>]</a>&nbsp;
			  <a style='FONT-SIZE: 9pt;COLOR: #ff0000; FONT-FAMILY: "宋体";cursor:hand;TEXT-DECORATION: none' onclick="chgReadSignatureType();">[<%=SystemEnv.getHtmlLabelName(21435,user.getLanguage())%>]</a>&nbsp;
            </td>
          </tr>
          </tbody>
          </table>

          <table border=1 width="<%=formSignatureWidth%>" height="<%=formSignatureHeight%>"  cellspacing="0" cellpadding="0" align="left">
          <tbody >
          <tr height='100%'>
            <td id="formSignatureTd" >
<script>
var str = '';
str += '<div id="DivID">';
str += '<OBJECT id="Consult" width="100%" height="100%" classid="<%=revisionClassId%>" codebase="<%=revisionClientUrl%>" >';
str += '</object>';
str += '</div>';
document.write(str);
</script>
            </td>
          </tr>
          </tbody>
          </table>
<%
} else {
%>

<table border=1 width="<%=formSignatureWidth%>" height="<%=formSignatureHeight%>"  cellspacing="0" cellpadding="0" align="left">
    <tr  height='100%'>
    	<td height="100%" width="100%" align="center" style="color:red;font-size:14px;">
			您当前使用的浏览器不支持【手写签章】，如需使用该功能，请使用IE浏览器！
        </td>
    </tr>
</table>

<%
}
%>
              <span id="remarkSpan">
<%
	if(isSignMustInput.equals("1")){
%>
			  <img src="/images/BacoError.gif" align=absmiddle>
<%
	}
%>
              </span>
          <input type=hidden name="remark" value="">
