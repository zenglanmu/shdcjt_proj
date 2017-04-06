<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.docs.category.security.AclManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>

<%

	String id = Util.null2String(request.getParameter("id"));
%>
<%
	//初始值
	int codeId = 0;
	RecordSet.executeSql("select id from codemain where secCategoryId="+id);
	while(RecordSet.next()){
		codeId = RecordSet.getInt("id");
	}
	if(codeId==0){
		RecordSet.executeSql("insert into codemain(titleImg,titleName,isUse,allowStr,secCategoryId) values('/images/sales.gif','19386','0','',"+id+")");
		RecordSet.executeSql("select max(id) from codemain");
		while(RecordSet.next()){
			codeId = RecordSet.getInt(1);
		}
		RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'18807','3','',0)");
		RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'19921','4','0',1)");
		RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'19387','1','1',2)");
		RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'19388','1','1',3)");
		RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'19389','1','1',4)");
		RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'445','1','1',5)");
		RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'6076','1','1',6)");
		RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'16889','1','1',7)");
		RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'18811','2','4',8)");
	}
	
	CodeBuild cbuild = new CodeBuild(codeId); 
	CoderBean cbean = cbuild.getCBuild();

	ArrayList coderMemberList = cbean.getMemberList();
	ArrayList coderMemberList2 = cbean.getMemberList2();
	String titleImg = cbean.getImage();
	String titleName = cbean.getTitleName();
	String isUse =  cbean.getUserUse();
	String secDocCodeAlone = cbean.getSecDocCodeAlone();
	String secCategorySeqAlone = cbean.getSecCategorySeqAlone();
	String dateSeqAlone = cbean.getDateSeqAlone();
	String dateSeqSelect = cbean.getDateSeqSelect();
	String allowStr = cbean.getAllowStr();
    RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String subcategoryid=RecordSet.getString("subcategoryid");
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
	//初始值
    boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	AclManager am = new AclManager();
	hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
	hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);

    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSubManageRight || hasSecManageRight) {
		canEdit = true ;
	}
%>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
  //菜单
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM METHOD="POST" name="frmCodeRule" ACTION="DocSecCategoryCodeRuleOperation.jsp">
<INPUT TYPE="hidden" NAME="method">
<INPUT TYPE="hidden" NAME="postValue"><!--主文档传回的字符串-->
<INPUT TYPE="hidden" NAME="postValue2"><!--子文档传回的字符串-->
<INPUT TYPE="hidden" NAME="codemainid" value="<%=codeId%>">
<INPUT TYPE="hidden" NAME="id" value="<%=id%>">
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
		<table class="viewForm">
			<COLGROUP> <COL width="20%"> <COL width="80%">
			<TBODY>
			<TR class=Title>
				<TH colSpan=2><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height: 1px!important;">
            	<TD class=Line1 colSpan=2></TD>
			</TR>
			<TR>
	            <TD><%=SystemEnv.getHtmlLabelName(19415,user.getLanguage())%></TD>
	            <TD class=Field><input class="inputStyle" type="checkbox" name="useSecCodeRule" value="1" <%if ("1".equals(isUse)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>></TD>
			</TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
			<TR>
	            <TD><%=SystemEnv.getHtmlLabelName(19416,user.getLanguage())%></TD>
	            <TD class=Field><input class="inputStyle" type="checkbox" id="secDocCodeAlone" name="secDocCodeAlone" value="1" <%if ("1".equals(secDocCodeAlone)) out.println("checked");%> onclick="javascrjpt:onCheckSecDoc()" <%if(!canEdit){%>disabled<%}%>></TD>
			</TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
			</TBODY>
		</table>
		<table class="viewForm">
			<COLGROUP> <COL width="20%"> <COL width="75%">
			<COL width="*">
			<TBODY>
			<TR class=Title>
				<TH colSpan=3><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height: 1px!important;">
            	<TD class=Line1 colSpan=3></TD>
			</TR>
            <%
            String postValueNullStr = "";
            for (int i=0;i<coderMemberList.size();i++){
            	String[] codeMembers = (String[])coderMemberList.get(i);
            	String codeMemberName = codeMembers[0];
            	String codeMemberValue = codeMembers[1];
            	String codeMemberType = codeMembers[2];
            	//String str = "TR_"+i;
            	if("2".equals(codeMemberType)||"3".equals(codeMemberType)){
            		postValueNullStr += codeMemberName+"\u001b"+"[(*_*)]"+"\u001b"+ codeMemberType+"\u0007";
            	}else{
            		postValueNullStr += codeMemberName+"\u001b"+"0"+"\u001b"+ codeMemberType+"\u0007";
            	}
            %>
                <TR id="TR_<%=i%>" customer1="member" <%if(!"1".equals(secDocCodeAlone)&&"4".equals(codeMemberType)){%>style="display:none"<%}%>>
                	<TD codevalue="<%=codeMemberName%>">
                     
                     <%if (canEdit){%>
                       <a href="javaScript:imgUpOnclick(<%=i%>)"><img id="img_up_<%=i%>" name="img_up" src='/images/ArrowUpGreen.gif' title='<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>' border=0></a>
                       &nbsp;
                       <a href="javaScript:imgDownOnclick(<%=i%>)"><img id="img_down_<%=i%>"  name ="img_down" src='/images/ArrowDownRed.gif' title='<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>' border=0></a>              
                       &nbsp;
                       <%}%>
                      <%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage()) %>
                    </TD>
                    <TD class="Field" colSpan=2>
                      <%
                         if ("1".equals(codeMemberType)){   //1:checkbox
                           if ("1".equals(codeMemberValue)){
                             if (canEdit){
                              out.println("<input type=checkbox name=1chk_"+i+" id=1chk_"+i+" class=inputstyle checked value=1  onclick=proView()>");
                             } else {
                              out.println("<div>"+SystemEnv.getHtmlLabelName(160,user.getLanguage())+"</div>");
                             }
                           } else {
                              if (canEdit){
                                out.println("<input type=checkbox name=1chk_"+i+" id=1chk_"+i+" class=inputstyle  value=1  onclick=proView()>");
                               } else {
                                out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
                               }                              
                           }
                         } else if ("2".equals(codeMemberType)){   //2:input
                              if (canEdit){
                                 out.println("<input type=text name=2txt_"+i+" class=inputstyle onchange=proView() onKeyPress=ItemCount_KeyPress('2txt_"+i+"') onBlur=checknumber('2txt_"+i+"') value="+codeMemberValue+">");
                               } else {
                                  out.println("<div>"+codeMemberValue+"</div>");
                               } 
                         }  else if ("3".equals(codeMemberType)){   //3:input
                              if (canEdit){
                                 out.println("<input type=text name=3txt_"+i+" class=inputstyle onchange=proView() value="+codeMemberValue+">");
                               } else {
                                  out.println("<div>"+codeMemberValue+"</div>");
                               } 
                         }  else if ("4".equals(codeMemberType)){
                           if ("1".equals(codeMemberValue)){
                             if (canEdit){
                              String output = "<input type=checkbox name=4chk_md id=4chk_md class=inputstyle ";
        
                              output += "checked value=1 onclick=proView()>";
                              out.println(output);
                             } else {
                              out.println("<div>"+SystemEnv.getHtmlLabelName(160,user.getLanguage())+"</div>");
                             }
                           } else {
                             if (canEdit){
                              String output = "<input type=checkbox name=4chk_md id=4chk_md class=inputstyle ";

                              output += "value=1 onclick=proView()>";
                              out.println(output);
                             } else {
                                out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
                             }                              
                           }
                         }   
                    %>
                    </TD>                   
                </TR>  
            	<TR style="height: 1px!important; <%if(!"1".equals(secDocCodeAlone)&&"4".equals(codeMemberType)){%>display:none;<%}%>"><TD class=Line colSpan=3></TD></TR>
            <%}%>
            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(19417,user.getLanguage())%></TD>
					<TD class="Field" colSpan=2><input class="inputStyle" type="checkbox" name="secCategorySeqAlone" value="1" <%if ("1".equals(secCategorySeqAlone)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
					</TD>
            	</TR>
            	<TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(19418,user.getLanguage())%></TD>
					<TD class="Field" colSpan=2>
						<input class="inputStyle" type="checkbox" name="dateSeqAlone" value="1" <%if ("1".equals(dateSeqAlone)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>&nbsp;
						<input class="inputStyle" type="radio" name="dateSeqSelect" value="1" checked <%if(!canEdit){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="dateSeqSelect" value="2" <%if ("2".equals(dateSeqSelect)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="dateSeqSelect" value="3" <%if ("3".equals(dateSeqSelect)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
						
					</TD>
            	</TR>
            	<TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
				<TR id="TR_a" >
					<TD><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></TD>
					<TD> 
						<table border="1" cellspacing="0" cellpadding="0" >
							<tr id="TR_doc1"></tr>
						</table>
					</TD>
					<TD></TD>
				</TR>
				<TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
				<TR id="TR_b" height="40">
					<TD><%=SystemEnv.getHtmlLabelName(19921,user.getLanguage())%></TD>
					<TD> 
						<table border="1" cellspacing="0" cellpadding="0">
							<tr id="TR_doc2"></tr>
							
						</table>
					</TD>
					<TD>
						<input type="button" class="Btn" name="setup" value="设置" onclick="javascript:onSetUp(2)" <%if(!canEdit){%>disabled<%}%>>
						<input type="button" class="Btn" name="cancel" value="取消" onclick="javascript:onCancel(2)" <%if(!canEdit){%>disabled<%}%>>
					</TD>
				</TR>
				<TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
				<TR id="TR_c" height="40">
					<TD><%=SystemEnv.getHtmlLabelName(19922,user.getLanguage())%></TD>
					<TD> 
						<table border="1" cellspacing="0" cellpadding="0">
							<tr id="TR_doc3"></tr>
						</table>
					</TD>
					<TD>
						<input type="button" class="Btn" name="setup" value="设置" onclick="javascript:onSetUp(3)" <%if(!canEdit){%>disabled<%}%>>
						<input type="button" class="Btn" name="cancel" value="取消" onclick="javascript:onCancel(3)" <%if(!canEdit){%>disabled<%}%>>
					</TD>
				</TR>
				<TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
			</TBODY>
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
</FORM>
</BODY>
<SCRIPT LANGUAGE="JavaScript">
<!--
var colors= new Array ("#6633CC","#FF33CC","#666633","#CC00FF","#996666")  ;

jQuery(document).ready(function(){

	load();
})

function load(){  //检查Imag的状态

  var img_ups = document.getElementsByName("img_up");
  for (var index_up=0;index_up<img_ups.length;index_up++)  {
    var img_up = img_ups[index_up];
    if (index_up==0)  {
    	img_up.style.visibility ='hidden';
    	img_up.parentNode.style.visibility ='hidden';
    }
    else  {
    	img_up.style.visibility ='visible';
    	img_up.parentNode.style.visibility ='visible';
    }
  }

  var img_downs = document.getElementsByName("img_down");
  for (var index_down=0;index_down<img_downs.length;index_down++)  {
    var img_down = img_downs[index_down];
    if (index_down==img_downs.length-1)  {
   	 	img_down.style.visibility ='hidden';
   	 	img_down.parentNode.style.visibility ='hidden';
    }
    else  {
    	img_down.style.visibility ='visible';
    	img_down.parentNode.style.visibility ='visible';
    }
  }

  if("<%=secDocCodeAlone%>"=="1"){
  	onSetUp(2);

  	var TR_doc = document.getElementById("TR_doc3");
  	var postValue2Str = "";
  	<%if(coderMemberList2.size()>0){%>
	  	<%for(int i=0;i<coderMemberList2.size();i++){
	  		String[] codeMembers2 = (String[])coderMemberList2.get(i);
	
			String codeMemberName = codeMembers2[0];
			String codeMemberValue = codeMembers2[1];
			String codeMemberType = codeMembers2[2];
			
			if ("1".equals(codeMemberType)&&"0".equals(codeMemberValue)){
	        	continue;
	        }else if (("2".equals(codeMemberType) || "3".equals(codeMemberType))&&"".equals(codeMemberValue)){
	        	continue;
	        }else if("19921".equals(codeMemberName)&&"0".equals(codeMemberValue)){
	        	continue;
	        }
		%>
			var index = <%=i%>;
			var codeTitle = "<%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage())%>";
			var codeValue = "<%=codeMemberValue%>";
			var codeType = "<%=codeMemberType%>";
	
			postValue2Str += <%=codeMemberName%>+"\u001b"+codeValue+"\u001b"+ codeType+"\u0007";//子文档编码初始返回值

			var tempTd = document.createElement("TD");
	        var tempTable = document.createElement("TABLE");
	        var newRow = tempTable.insertRow();
	        var newRowMiddle = tempTable.insertRow();
	        var newRow1 = tempTable.insertRow();
	        //newRowMiddle.style.height="1px!important;";
	        newRowMiddle.style.height="1px";
	
	        var newCol = newRow.insertCell();
	        var newColMiddle=newRowMiddle.insertCell();
	        var newCol1 = newRow1.insertCell();
	
	        newColMiddle.className="Line";
	
	        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";
	
	        if (codeValue=="1") {
	          codeValue="****";
	        } else if (codeValue=="0") {
	          codeValue="**";
	        }
	        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
	        tempTd.appendChild(tempTable);
	        TR_doc.appendChild(tempTd);
	
	  	<%}%>
	  	postValue2Str = postValue2Str.substring(0,postValue2Str.length-1);

  	<%}%>
  	document.frmCodeRule.postValue2.value = postValue2Str;
  }else{

  	proView();
  }
}

function proView(){
	if(frmCodeRule.secDocCodeAlone.checked)
		return;
	
	/*document.getElementById("TR_a").style.display = '';
	document.getElementById("TR_a").nextSibling.style.display = '';
	document.getElementById("TR_b").style.display = 'none';
	document.getElementById("TR_b").nextSibling.style.display = 'none';
	document.getElementById("TR_c").style.display = 'none';
	document.getElementById("TR_c").nextSibling.style.display = 'none';*/
	jQuery("#TR_a").show();
	jQuery("#TR_a").next().show();
	jQuery("#TR_b").hide();
	jQuery("#TR_b").next().hide();
	jQuery("#TR_c").hide();
	jQuery("#TR_c").next().hide();

			
	//var TR_doc = document.getElementById("TR_doc1");
    //var TR_proChilds = TR_doc.childNodes;   

   
   
   // for (var i=TR_proChilds.length-1;i>=0;i--) TR_proChilds[i].removeNode(true);

    var TR_doc =  jQuery("#TR_doc1");
    jQuery(TR_doc).children("td").remove();

	
    jQuery("tr[customer1='member']").each(function(index,obj){
			
		  var codeTitle = $(obj).find("td::eq(0)").text()
		  codeTitle = jQuery.trim(codeTitle)
		  var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
		  
		  var codeValue;

	      if (codeTypeTag=="INPUT") {
	        codeValue= $(obj).find("td::eq(1)").children(":first").val(); 

	        if ($(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
	           codeValue = $(obj).find("td::eq(1)").children(":first").val();
	        } else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
	           codeValue = $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	        }
	      }
	      else if (codeTypeTag=="DIV") codeValue = $(obj).find("td::eq(1)").children(":first").text();
	      
	      if (codeTypeTag=="INPUT"||codeTypeTag=="DIV"&&codeValue!="不使用")  { 
	            if (codeTypeTag=="INPUT") {
	                if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"&&codeValue=="0"){ 
	                	return true;
	                }else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="text"&&codeValue==""){ 
	                	return true;
	                }else if (trim(codeTitle)=="主文档编码"&&codeValue=="1"){
	                	document.getElementById("4chk_md").checked = false;
	                	return true;
	                }
	            }

	        var tempTd = document.createElement("TD");
	        var tempTable = document.createElement("TABLE");
	        var newRow = tempTable.insertRow(-1);
	        var newRowMiddle = tempTable.insertRow(-1);
	        var newRow1 = tempTable.insertRow(-1);


	        var newCol = newRow.insertCell(-1);
	        var newColMiddle=newRowMiddle.insertCell(-1);
	        var newCol1 = newRow1.insertCell(-1);

	        jQuery(newRowMiddle).css("height","1px");
	        newColMiddle.className="Line";

	        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";

	        if (codeValue=="1") {
	          codeValue="****";
	        } else if (codeValue=="0") {
	          codeValue="**";
	        }
	        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
	        jQuery(tempTd).append(tempTable);
	        //tempTd.appendChild(tempTable);
	        jQuery(TR_doc).append(tempTd)
	        //TR_doc.appendChild(tempTd);
	      } 
    })
    
    
    
}

function onSave(obj){
	obj.disabled=true;
	if(!frmCodeRule.secDocCodeAlone.checked){//如果子文档单独编码没有启用的话，只返回主文档编码规则
		var postValueStr=getValue();
		document.frmCodeRule.postValue.value = postValueStr;
	}
	
	document.frmCodeRule.method.value="update";
	document.frmCodeRule.submit();
}
 
function onYearChkClick(obj,index){  
    document.getElementById("select_"+index).disabled=!obj.checked;
    proView();
}

jQuery.fn.swap = function(other) {
    $(this).replaceWith($(other).after($(this).clone(true)));
};

function imgUpOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =obj1.childNodes[1].firstChild;
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  //alert(jQuery(obj1).prevAll("tr[customer1='member']").filter("tr:visible"))
  var obj2 = jQuery(obj1).prevAll("tr[customer1='member']").filter("tr:visible:first");// obj1.previousSibling.previousSibling;
  
  var checkbox2 =$(obj2).find("td::eq(1)").children(":first");
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

  //swapNode(obj1,obj2);
  jQuery(obj1).swap(obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  if(!frmCodeRule.secDocCodeAlone.checked)
  	load();
}


function imgDownOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =obj1.childNodes[1].firstChild;
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  var obj2 =jQuery(obj1).nextAll("tr[customer1='member']").filter("tr:visible:first");// 
  var checkbox2 =$(obj2).find("td::eq(1)").children(":first");
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

 
  jQuery(obj1).swap(obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  if(!frmCodeRule.secDocCodeAlone.checked)
  	load();
}
function onCheckSecDoc(){
	var obj = document.getElementById("4chk_md").parentNode.parentNode;
	if(frmCodeRule.secDocCodeAlone.checked){
		obj.style.display="";
		$(obj).children(":first").children(":first").css("visibility","visible")
		//obj.firstChild.firstChild.style.visibility ='visible';
		obj = jQuery(obj).next();
		jQuery(obj).show();
		
    	document.getElementById("TR_a").style.display = 'none';
    	jQuery("#TR_a").next().hide();
    	//document.getElementById("TR_a").nextSibling.style.display = 'none';
		document.getElementById("TR_b").style.display = '';
		jQuery("#TR_b").next().show();
		//document.getElementById("TR_b").nextSibling.style.display = '';
		document.getElementById("TR_c").style.display = '';
		jQuery("#TR_c").next().show();
		//document.getElementById("TR_c").nextSibling.style.display = '';
		
		onSetUp(2);
	}else{
		obj.style.display="none";
		$(obj).children(":first").children(":first").attr("disable","true");
		//obj.firstChild.firstChild.disabled ='true';
		$(obj).children(":first").children(":first").next().next().attr("disable","true");
		//obj.firstChild.firstChild.nextSibling.nextSibling.disabled = 'true';
		obj = jQuery(obj).next();
		jQuery(obj).hide();
		
		document.getElementById("TR_a").style.display = '';
		jQuery("#TR_a").next().show();
		//document.getElementById("TR_a").nextSibling.style.display = '';
		document.getElementById("TR_b").style.display = 'none';
		jQuery("#TR_b").next().hide();
		//document.getElementById("TR_b").nextSibling.style.display = 'none';
		document.getElementById("TR_c").style.display = 'none';
		jQuery("#TR_c").next().hide();
		//document.getElementById("TR_c").nextSibling.style.display = 'none';
		
		proView();
	}
}
function getValue(){
  var TR_members= document.getElementsByTagName("TR");
  var postValueStr="";
  jQuery("tr[customer1='member']").each(function(index,obj){
	  var codeTitle = $(obj).find("td::eq(0)").attr("codevalue")
	  codeTitle = jQuery.trim(codeTitle)
	  var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
	  var codeValue;
	  var codeType;

	    if (codeTypeTag=="INPUT") {
	      codeValue= $(obj).find("td::eq(1)").children(":first").val();
	      if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
	         codeValue =  $(obj).find("td::eq(1)").children(":first").val();
	         if (codeValue=="") codeValue="[(*_*)]";
	         var name =  $(obj).find("td::eq(1)").children(":first").attr("name");
	         if(name.substring(0,1)==2)
	         	codeType = 2;
	         else if(name.substring(0,1)==3)
	         	codeType = 3;
	      } else if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
	         codeValue =  $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	         var name =  $(obj).find("td::eq(1)").children(":first").attr("name");
	         if(name.substring(0,1)==1)
	         	codeType = 1;      
	         else if(name.substring(0,1)==4)
	         	codeType = 4;
	      }
	    }
	    postValueStr += codeTitle+"\u001b"+codeValue+"\u001b"+ codeType+"\u0007";
	})
  postValueStr = postValueStr.substring(0,postValueStr.length-1);
  return postValueStr;
}
function onSetUp(docindex){
	var TR_doc;
	if(frmCodeRule.secDocCodeAlone.checked){
    	document.getElementById("TR_a").style.display = 'none';
    	jQuery("#TR_a").next().hide();
    	//document.getElementById("TR_a").nextSibling.style.display = 'none';
		document.getElementById("TR_b").style.display = '';
		jQuery("#TR_b").next().show();
		//document.getElementById("TR_b").nextSibling.style.display = '';
		document.getElementById("TR_c").style.display = '';
		jQuery("#TR_c").next().show();
		//document.getElementById("TR_c").nextSibling.style.display = '';
    	TR_doc = document.getElementById("TR_doc"+docindex);
    }else{
		document.getElementById("TR_a").style.display = '';
		jQuery("#TR_a").next().show();
		//document.getElementById("TR_a").nextSibling.style.display = '';
		document.getElementById("TR_b").style.display = 'none';
		jQuery("#TR_b").next().hide();
		//document.getElementById("TR_b").nextSibling.style.display = 'none';
		document.getElementById("TR_c").style.display = 'none';
		jQuery("#TR_c").next().hide();
		document.getElementById("TR_c").nextSibling.style.display = 'none';
    	TR_doc = document.getElementById("TR_doc1");
    }
	
    jQuery(TR_doc).find("td").remove();
	
	//return;
    jQuery("tr[customer1='member']").each(function(index,obj){

    	 var codeTitle = $(obj).find("td::eq(0)").text()
		 codeTitle = jQuery.trim(codeTitle)
		 var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
		  
		 var codeValue;
    	 if (codeTypeTag=="INPUT") {
 	        codeValue= $(obj).find("td::eq(1)").children(":first").val(); 

 	        if ($(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
 	           codeValue = $(obj).find("td::eq(1)").children(":first").val();
 	        } else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
 	           codeValue = $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
 	        }
 	      }
 	      else if (codeTypeTag=="DIV") codeValue = $(obj).find("td::eq(1)").children(":first").text();
    	 if (codeTypeTag=="INPUT"||codeTypeTag=="DIV"&&codeValue!="不使用")  { 
	            if (codeTypeTag=="INPUT") {
	                if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"&&codeValue=="0"){ 
	                	return true;
	                }else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="text"&&codeValue==""){ 
	                	return true;
	                }else if (trim(codeTitle)=="主文档编码"&&codeValue=="1"){
	                	document.getElementById("4chk_md").checked = false;
	                	return true;
	                }
	            }

	        var tempTd = document.createElement("TD");
	        var tempTable = document.createElement("TABLE");
	        var newRow = tempTable.insertRow(-1);
	        var newRowMiddle = tempTable.insertRow(-1);
	        var newRow1 = tempTable.insertRow(-1);


	        var newCol = newRow.insertCell(-1);
	        var newColMiddle=newRowMiddle.insertCell(-1);
	        var newCol1 = newRow1.insertCell(-1);

	        jQuery(newRowMiddle).css("height","1px");
	        newColMiddle.className="Line";

	        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";

	        if (codeValue=="1") {
	          codeValue="****";
	        } else if (codeValue=="0") {
	          codeValue="**";
	        }
	        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
	        jQuery(tempTd).append(tempTable);
	        //tempTd.appendChild(tempTable);
	        jQuery(TR_doc).append(tempTd)
	        //TR_doc.appendChild(tempTd);
	      }
    })
    
    if(docindex==3){//设置子文档编码传回的字符串
		var postValueStr=getValue();
		document.frmCodeRule.postValue2.value=postValueStr;
	}else{//设置主文档编码传回的字符串
		var postValueStr=getValue();
		document.frmCodeRule.postValue.value=postValueStr;
	}
}
function onCancel(docindex){
	TR_doc = document.getElementById("TR_doc"+docindex);
	var oItem = TR_doc.children;
	if (oItem!=null) {
		var length = oItem.length;
		for (i=0; i<length; i++)TR_doc.removeChild(oItem.item(0));
	}
	if(docindex==2){
		document.frmCodeRule.postValue.value = "<%=postValueNullStr%>";
	}else if(docindex==3){
		document.frmCodeRule.postValue2.value = "";
	}
}
</SCRIPT>
</HTML>