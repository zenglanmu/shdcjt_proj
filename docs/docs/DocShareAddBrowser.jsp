<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>

<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>

<html>
<HEAD> 
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%    
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
	//System.out.println("categoryid:"+categoryid);
	int categorytype = Util.getIntValue(request.getParameter("categorytype"),0);
	int operationcode = Util.getIntValue(request.getParameter("operationcode"),0);
    String para = Util.null2String(request.getParameter("para")); 
   
    String[] paraArray = Util.TokenizerString2(para,"_");
    int browserType =Util.getIntValue(paraArray[0],0);   //1:表示 目录中的默认共享    2:表示文档中的默认共享
	if(browserType!=1){
		browserType=2;
	}

    int docid =Util.getIntValue(paraArray[1],0);  // browserType:1 docid用目录ID   2 docid 为文档ID

	boolean canAdd=false;
	if(browserType==1){//1:表示 目录中的默认共享
	    AclManager am = new AclManager();
        if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || am.hasPermission(docid, AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_CREATEDIR)){
	        canAdd=true;
        }
	}else if(browserType==2){//2:表示文档中的默认共享
        //3:共享
        //user info
        int userid=user.getUID();
        String logintype = user.getLogintype();
        String userSeclevel = user.getSeclevel();
        String userType = ""+user.getType();
        String userdepartment = ""+user.getUserDepartment();
        String usersubcomany = ""+user.getUserSubCompany1();
        String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
        ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);
        if (((String)PdocList.get(3)).equals("true")){ 
        	canAdd = true ;
        }
	}
    
	if(!canAdd){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
    /**TD12005 文档下载权限控制(获取禁止下载标志) 开始*/
    int noDownload = Util.getIntValue(Util.null2String(request.getParameter("noDownload")),0);
    //是否有效
    String isDownloadDisabled = "";
    if(noDownload == 1) isDownloadDisabled ="disabled";
    /**TD12005 文档下载权限控制(获取禁止下载标志) 结束*/
	//System.out.println("browserType:"+browserType);
	

	
	
    boolean blnOsp = "true".equals(request.getParameter("blnOsp"));  //用于存放共享提醒对话框的设置
	
	//System.out.println("blnOsp:"+blnOsp);
%>
<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    //RCMenu += "{返回,javascript:window.history.go(-1),_top} ";
    //RCMenuHeight += RCMenuHeightStep ;
	if(browserType==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/category/DocSecCategoryEdit.jsp?id="+docid+"&tab=1,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
	}
	if(browserType==2){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/docs/DocShare.jsp?docid="+docid+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
    //通过文档的id得到文档的类型,文档创建人类型,文档创建者所具有的条件'
    String createUserType="";
    String strSql = "select usertype from docdetail  where id="+docid;
    rs.executeSql(strSql);
    if (rs.next()){
        createUserType = Util.null2String(rs.getString("usertype"));           
    }
%>
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
                            <form name="weaver" method="post">
                              <INPUT TYPE="hidden" NAME="docid" value="<%=docid%>">           
                              <INPUT type="hidden" Name="method" value="addMutil">
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>                                    
                                    <TR class=Spacing style="height: 1px">
                                    <TD class=Line1 colSpan=2></TD></TR>
                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                            
                                            <SELECT class=InputStyle  name=sharetype onChange="onChangeSharetype()" >   
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> 
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                                                <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
                                                <option value="6"><%=SystemEnv.getHtmlLabelName(24002,user.getLanguage())%></option>												
                                                <option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
												<%if(isgoveproj==0){%>
                                                 <option value="9"><%=SystemEnv.getHtmlLabelName(18647,user.getLanguage())%></option>
												 <%}%>
                                                <%
												if(isgoveproj==0){
                                                while(CustomerTypeComInfo.next()){
                                                                String curid=CustomerTypeComInfo.getCustomerTypeid();
                                                                String curname=CustomerTypeComInfo.getCustomerTypename();
                                                                String optionvalue="-"+curid;
                                                %>
                                                <option value="<%=optionvalue%>"><%=curname%></option>
                                                <%}
												}
                                                if (browserType!=1){
                                                    if ("1".equals(createUserType)){%>
                                                    <OPTION value="80"><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></OPTION>
                                                    <OPTION value="81"><%=SystemEnv.getHtmlLabelName(18583,user.getLanguage())%></OPTION>                                                  
                                                    <OPTION value="84"><%=SystemEnv.getHtmlLabelName(18584,user.getLanguage())%></OPTION>
                                                    <OPTION value="85"><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></OPTION>
                                                   <%} else {%>
                                                    <OPTION value="-80"><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></OPTION>
                                                    <OPTION value="-81"><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></OPTION>                                                  
                                                   <%}
                                                  }%>
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            <BUTTON class=Browser type="button" style="display:''" onClick="onShowResource(relatedshareid,showrelatedsharename)" name=showresource></BUTTON> 
                                             <BUTTON class=Browser type="button" style="display:none" onClick="onShowCRM(relatedshareid,showrelatedsharename)" name=showmcrm></BUTTON> 
                                            <BUTTON class=Browser type="button" style="display:none" onClick="onShowSubcompany(showrelatedsharename,relatedshareid)" name=showsubcompany></BUTTON> 
                                            <BUTTON class=Browser type="button" style="display:none"
                                            onClick="onShowDepartment(relatedshareid,showrelatedsharename)"
                                             name=showdepartment></BUTTON> 
                                            <BUTTON class=Browser type="button" style="display:none" onClick="onShowRole(showrelatedsharename,relatedshareid)" name=showrole></BUTTON>
                                            <BUTTON class=Browser type="button" style="display:none" onClick="onShowOrgGroup(relatedshareid,showrelatedsharename)" name=showOrgGroup></BUTTON>
                                            <INPUT type=hidden name=relatedshareid  id="relatedshareid" value="">
                                            <span id=showrelatedsharename name=showrelatedsharename><IMG src='/images/BacoError.gif' align=absMiddle></span>                                            
                                        </TD>		
                                    </TR>
                                    <TR style="height: 1px">
                                        <TD class=Line colSpan=2></TD>
                                    </TR>

                                    <TR id=showrolelevel name=showrolelevel style="display:none">
                                        <TD>
                                            <%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <SELECT  name=rolelevel>
                                                    <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
                                                    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
                                                    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
                                                </SELECT>
                                        </td>
                                    </TR>
                                     <TR id=showrolelevel_line name=showrolelevel_line style="display:none;height: 1px">
                                        <TD class=Line colSpan=2  ></TD>
                                     </TR>

                                      <TR  id=showseclevel name=showseclevel style="display:none;height: 1px">
                                        <TD>
                                             <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <INPUT type=text name=seclevel class=InputStyle size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' onKeyPress="ItemCount_KeyPress()">
                                             <span id=seclevelimage></span>
                                        </td>
                                    </TR>
                                     <TR id=showseclevel_line name=showseclevel_line style="display:none;height: 1px">
                                        <TD class=Line colSpan=2 ></TD>
                                     </TR>

																		<TR>
                                     <TD>
                                        <%=SystemEnv.getHtmlLabelName(440,user.getLanguage())%>
                                    </TD>
                                    <TD class="field">
<!-- TD12005 文档下载权限控制    ONCHANGE添加 -->
                                        <SELECT class=InputStyle  name=Psharelevel onchange="onOptionChange('Psharelevel')">
                                            <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                                            <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
<%
    String sharelevel="";
	if(browserType==2){
        String userId = "" +user.getUID() ;
        String loginType = user.getLogintype() ;
        String userType = ""+user.getType();
        String userDepartment = ""+user.getUserDepartment();
        String userSubCompany  = ""+user.getUserSubCompany1();
        String userSeclevel = user.getSeclevel();
		String strSqlSharelevel=ShareManager.getSharLevel("doc",userId, loginType,userType,userDepartment,userSubCompany ,userSeclevel,""+docid);
        rs.executeSql(strSqlSharelevel);
        if (rs.next()) {
            sharelevel = ""+Util.getIntValue(rs.getString(1));            
        }
	}
    
    if(browserType==1||sharelevel.equals("3")){
%>
                                            <option value="3"><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option>
<%
	}
%>
                                        &nbsp;&nbsp;&nbsp;
<!-- TD12005 文档下载权限控制    复选框对象添加 -->
                            <input class='InputStyle' type='checkbox' name='chkPsharelevel' id='chkPsharelevel' style="display:''" <%=isDownloadDisabled%>><label for='chkPsharelevel' id='lblPsharelevel' style="display:''"><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>
                                        </SELECT>
                                    </TD>
                                    </TR>
                                    <TR style="height: 1px">
                                        <TD class=Line colSpan=2></TD>
                                   </TR>

                                    <tr>
                                        <TD  colspan=2>
                                           <TABLE  width="100%">
                                            <TR>
                                                <TD width="*"></TD>
                                                <TD width="300px"><button class="btnNew" type="button" title="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" onClick="addValue()" accesskey="a"><u>A</u>&nbsp;<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button class="btnDelete" type="button" title="<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" onClick="removeValue()" accesskey="d"><u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%></button></TD>
                                            </TR>
                                           </TABLE>
                                        </TD>
                                    </tr>
                                   <TR style="height: 1px">
                                        <TD class=Line colSpan=2></TD>
                                   </TR>
                                   <tr>
                                        <td colspan=2>
                                            <table class="listStyle" id="oTable" name="oTable">
                                                <colgroup>
                                                <col width="3%">
                                                <col width="20%">
                                                <col width="20%">
                                                <col width="17%">
                                                <col width="20%">
                                                <col width="20%">
                                                <tr class="header">
                                                    <td><input type="checkbox" name="chkAll" onClick="chkAllClick(this)"></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></td>
                                                </tr>
                                                <tr class=Line style="height: 1px" ><td colspan=6 style="padding: 0px"></td></tr>
                                            </table>
                                        </td>
                                   </tr>
                                </TBODY>
                            </TABLE>
                        </td>
                    </tr>
                </TABLE>
                </form>
            </td>
            <td></td>
        </tr>
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
        </table>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
<!--

  function onChangeSharetype(){


	var thisvalue=$GetEle("sharetype").value;
	$GetEle("relatedshareid").value="";
	$GetEle("showseclevel").style.display='';
  $GetEle("showseclevel_line").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    if(thisvalue==80||thisvalue==81||thisvalue==82||thisvalue==83||thisvalue==84||thisvalue==85||thisvalue==-80||thisvalue==-81||thisvalue==-82){
 		    $GetEle("showresource").style.display='none';
        $GetEle("showrelatedsharename").innerHTML='';

        if (thisvalue==83||thisvalue==84||thisvalue==85) {
            $GetEle("showseclevel").style.display='';
            $GetEle("showseclevel_line").style.display='';
        } else {
            $GetEle("showseclevel").style.display='none';
            $GetEle("showseclevel_line").style.display='none';
        }
	}

	if(thisvalue==1){
 		$GetEle("showresource").style.display='';
		$GetEle("showseclevel").style.display='none';
     $GetEle("showseclevel_line").style.display='none';
    $GetEle("seclevel").value=0;
	}else{
		$GetEle("showresource").style.display='none';
	}

	if(thisvalue==2){
 		$GetEle("showsubcompany").style.display='';
 		$GetEle("seclevel").value=10;
	}
	else{
		$GetEle("showsubcompany").style.display='none';
		$GetEle("seclevel").value=10;
	}
	if(thisvalue==3){
 		$GetEle("showdepartment").style.display='';
 		$GetEle("seclevel").value=10;
	}
	else{
		$GetEle("showdepartment").style.display='none';
		$GetEle("seclevel").value=10;
	}
	if(thisvalue==4){
 		$GetEle("showrole").style.display='';
		$GetEle("showrolelevel").style.display='';
    $GetEle("showrolelevel_line").style.display='';
    $GetEle("rolelevel").style.display='';
		$GetEle("seclevel").value=10;
	}
	else{
		$GetEle("showrole").style.display='none';
		$GetEle("showrolelevel").style.display='none';
    $GetEle("showrolelevel_line").style.display='none';
    $GetEle("rolelevel").style.display='none';
		$GetEle("seclevel").value=10;
    }
	if(thisvalue==5){
		showrelatedsharename.innerHTML = "";
		$GetEle("relatedshareid").value=-1;
		$GetEle("seclevel").value=10;
	}

	if(thisvalue==6){
 		$GetEle("showOrgGroup").style.display='';
 		$GetEle("seclevel").value=10;
	}
	else{
		$GetEle("showOrgGroup").style.display='none';
		$GetEle("seclevel").value=10;
	}

	if(thisvalue<0){
		showrelatedsharename.innerHTML = "";
		$GetEle("relatedshareid").value=-1;
		$GetEle("seclevel").value=10;
	}

  if(thisvalue==9){
 		$GetEle("showmcrm").style.display='';
		$GetEle("showseclevel").style.display='none';
    $GetEle("showseclevel_line").style.display='none';
    $GetEle("seclevel").value=0;
	}else{
		$GetEle("showmcrm").style.display='none';
	}
}

function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
    }
}

function addValue(){
    thisvalue=$GetEle("sharetype").value;

   var shareTypeValue = thisvalue;
   var shareTypeText = $GetEle("sharetype").options.item($GetEle("sharetype").selectedIndex).text;


    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
    var relatedShareIds="0";
    var relatedShareNames="";
    if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4||thisvalue==9||thisvalue==6) {
        if(!check_form(document.weaver,'relatedshareid')) {
            return ;
        }
        if (thisvalue==4){
            if (!check_form(document.weaver,'seclevel'))
                return;
        }
        relatedShareIds = $GetEle("relatedshareid").value;
        relatedShareNames= $GetEle("showrelatedsharename").innerHTML;
    }

    var secLevelValue="0";
    var secLevelText="";
    if (thisvalue!=1&&thisvalue!=-80&&thisvalue!=-81&&thisvalue!=-82&&thisvalue!=80&&thisvalue!=81&&thisvalue!=82) {
        secLevelValue = $GetEle("seclevel").value;
        secLevelText=secLevelValue;
    }

   var rolelevelValue=0;
   var rolelevelText="";
   if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
       rolelevelValue = $GetEle("rolelevel").value;
       rolelevelText=$GetEle("rolelevel").options.item($GetEle("rolelevel").selectedIndex).text;
   }



   var PsharelevelValue =  $GetEle("Psharelevel").value;
   var PsharelevelText = $GetEle("Psharelevel").options.item($GetEle("Psharelevel").selectedIndex).text;

   /**===TD12005 文档下载权限控制  开始====*/
    var selObj = $GetEle("Psharelevel");//选择控件对象
    var oVal = selObj.options[selObj.selectedIndex].value;//选中值
    var PdownloadlevelValue = 1;
    var PdownloadlevelText = '';
    if(oVal == 1) {
        var chkObj = $GetEle('chkPsharelevel');//复选框控件对象
        if (chkObj.checked == true) {
        	PdownloadlevelValue = 1;
        	PdownloadlevelText = '(' + '<%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%>' + ')';
        } else {
            PdownloadlevelValue = 0;
            PdownloadlevelText = '(' + '<%=SystemEnv.getHtmlLabelName(23734,user.getLanguage())%>' + ')';
        }
        PsharelevelText = PsharelevelText + PdownloadlevelText;
    }
   /**===TD12005 文档下载权限控制  结束====*/
   
   //共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限+下载权限(TD12005)
   //var totalValue=shareTypeValue+"_"+relatedShareIds+"_"+rolelevelValue+"_"+secLevelValue+"_"+PsharelevelValue
   var totalValue=shareTypeValue+"_"+relatedShareIds+"_"+rolelevelValue+"_"+secLevelValue+"_"+PsharelevelValue+"_"+PdownloadlevelValue

   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.rowIndex;

   if (oRowIndex%2==0) oRow.className="dataLight";
   else oRow.className="dataDark";

   for (var i =1; i <=6; i++) {   //生成一行中的每一列


      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
      else if (i==2) oDiv.innerHTML=shareTypeText;
      else  if (i==3) oDiv.innerHTML=relatedShareNames;
      else  if (i==4) oDiv.innerHTML=rolelevelText;
      else  if (i==5) {if (secLevelText=="0") secLevelText=""; oDiv.innerHTML=secLevelText;}
      else  if (i==6) oDiv.innerHTML=PsharelevelText;

      oCell.appendChild(oDiv);
   }
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }
}
//=====TD12005 文档下载权限控制  开始========//
function onOptionChange(selObjName) {
    var selObj = $GetEle(selObjName);//选择控件对象
    var oVal = selObj.options[selObj.selectedIndex].value;//选中值
    var chkObj = $GetEle('chk'+selObjName);//复选框控件对象
    var lblObj = $GetEle('lbl'+selObjName);//复选框控件对应标签对象

    if(oVal == 1) {//查看时显示  
        chkObj.style.display = '';
        lblObj.style.display = '';
    } else {
        chkObj.style.display = 'none';
        lblObj.style.display = 'none';
    }
}


function onShowResource(inputname,spanname){
	linkurl="/hrm/resource/HrmResource.jsp?id="
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (data){
	   
	    if(data.id!=""&&data.id!="0"){
	        resourceids = data.id
		    resourcename = data.name
		    var sHtml = "";
		    resourceids = resourceids.substring(1);
		    resourcename = resourcename.substring(1);
		    inputname.value= resourceids;
		    ids = resourceids.split(",");
		    names =resourcename.split(",");
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	        	}
	        }
		    spanname.innerHTML = sHtml
	    }else{	
		    spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		    inputname.value=""
	    }
	}
}
function onShowCRM(inputname,spanname){
	linkurl="/CRM/data/ViewCustomer.jsp?CustomerID="
	temp =inputname.value
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+temp)
	if (data){
		if (data.id.length> 500){ //'500为表结构相关客户字段的长度
			result = msgbox("您选择的相关客户数量太多，数据库将无法保存所有的相关客户，请重新选择！",48,"注意")
			spanname.innerHTML =""
			inputname.value=""
		}else if (data.id!=""){
			resourceids = data.id
		    resourcename = data.name
		    var sHtml = "";
		    resourceids = resourceids.substring(1);
		    resourcename = resourcename.substring(1);
		    inputname.value= resourceids;
		    ids = resourceids.split(",");
		    names =resourcename.split(",");
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	        	}
	        }
		    spanname.innerHTML = sHtml;
		}else{
			//'spanname.innerHTML =""
			spanname.innerHTML ="<IMG src='/images/BacoError.gif' align=absMiddle>"
			inputname.value=""
		}
	}
	
}

function onShowSubcompany(tdname,inputename){
	linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+inputename.value)
	if (data){
	    if(data.id!=""&&data.id!="0"){
	        resourceids = data.id
		    resourcename = data.name
		    var sHtml = "";
		    resourceids = resourceids.substring(1);
		    resourcename = resourcename.substring(1);
		    inputename.value= resourceids;
		    ids = resourceids.split(",");
		    names =resourcename.split(",");
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	        	}
	        }
	       
		    tdname.innerHTML = sHtml
	    }else{	
	    	tdname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		    inputename.value=""
	    }
	}
}
function onShowDepartment(inputname,spanname){
	linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+inputname.value)
	if (data){
		   
	    if(data.id!=""&&data.id!="0"){
	        resourceids = data.id
		    resourcename = data.name
		    var sHtml = "";
		    resourceids = resourceids.substring(1);
		    resourcename = resourcename.substring(1);
		    inputname.value= resourceids;
		    ids = resourceids.split(",");
		    names =resourcename.split(",");
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	        	}
	        }
		    spanname.innerHTML = sHtml
	    }else{	
	    	spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		    inputname.value=""
	    }
	}
}
function onShowOrgGroup(inputname,spanname){
	linkurl="/hrm/orggroup/HrmOrgGroupRelated.jsp?orgGroupId="
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/orggroup/HrmOrgGroupBrowser.jsp")
	if (data){
		   
	    if(data.id!=""&&data.id!="0"){
	        resourceids = data.id
		    resourcename = data.name
		    var sHtml = "";
		    resourceids = resourceids.substring(1);
		    resourcename = resourcename.substring(1);
		    inputname.value= resourceids;
		    ids = resourceids.split(",");
		    names =resourcename.split(",");
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	        	}
	        }
		    spanname.innerHTML = sHtml
	    }else{	
		    spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		    inputname.value=""
	    }
	}
}


function onShowRole(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if (data){
		   
	    if(data.id!=""&&data.id!="0"){
			tdname.innerHTML = data.name
		   	inputename.value=data.id
	    }else{
		    tdname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		    inputename.value=""
	    }
	}
}


function doSave(obj){
    obj.disabled=true
     if (<%=browserType%>==1){ 
         document.weaver.action="/docs/category/ShareOperation.jsp"
     }else{
        document.weaver.action="DocShareOperation.jsp?docid=<%=docid%>&blnOsp=<%=blnOsp%>"
     }
     document.weaver.submit();
}

//=====TD12005 文档下载权限控制  结束========//
//-->
</SCRIPT>

