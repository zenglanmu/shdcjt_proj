<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.system.code.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%
boolean canEdit=true;
if(!HrmUserVarify.checkUserRight("CapitalCodingSet:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

%>
<html>
<%

  CodeBuild cbuild = new CodeBuild();  
  CoderBean cbean = cbuild.getCapitalCode();
  
  ArrayList coderMemberList = cbean.getMemberList();
  String isUse =  cbean.getIsuse() + "";
  String codeid = cbean.getCodeid() + "";
  String subcompanyflow =  cbean.getSubcompanyflow();
  String departmentflow =  cbean.getDepartmentflow();
  String capitalgroupflow =  cbean.getCapitalgroupflow();
  String capitaltypeflow =  cbean.getCapitaltypeflow();
  String buydateflow =  cbean.getBuydateflow();
  String Warehousingflow =  cbean.getWarehousingflow();
  String statrcodenum = cbean.getStartcodenum();
  String assetdataflow = cbean.getAssetdataflow();
  
  String buydate = "";
  String buydateselect = "";
  String Warehousing = "";
  String Warehousingselect = "";
  try{
  	buydate = Util.TokenizerString2(buydateflow,"|")[0];
  	buydateselect = Util.TokenizerString2(buydateflow,"|")[1];
  }catch(Exception e){
    new weaver.general.BaseBean().writeLog("buydateflow：" + e);
  }
  
  try{
  	Warehousing = Util.TokenizerString2(Warehousingflow,"|")[0];
  	Warehousingselect = Util.TokenizerString2(Warehousingflow,"|")[1];
  }catch(Exception e){
    new weaver.general.BaseBean().writeLog("Warehousingflow：" + e);
  }

%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(20343,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form id="frmCoder" name="frmCoder" method=post action="coderOperation.jsp" >
<input type=hidden name=codeid value="<%=codeid%>">
<input type=hidden name=postValue value="">

<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

   <table class="viewform">
   <COLGROUP>
   <COL width="30%">
   <COL width="70%">
       <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TH>
	   </TR>
       <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD>
	   </TR>
       <TR>
        <TD><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></TD>
        <TD class="Field"><input class="inputStyle" type="checkbox" name="isuse" value="1" <%if ("1".equals(isUse)) out.println("checked");%>></TD>
       </TR>
       <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

</table>


<div id="odiv">
    
<table class="viewform">
   <COLGROUP>
   <COL width="30%">
   <COL width="70%">
   <TR class="Title">
       <TH colspan=2><%=SystemEnv.getHtmlLabelName(19504,user.getLanguage())%></th><th></TH>
   </TR>

   <TR class="Spacing" style="height:1px;">
       <TD class="Line1" colSpan=4></TD>
   </TR>

</table>

  <table class=viewform cellspacing=1  id="oTable">

  <COLGROUP>
    <COL width="30%">
  	<COL width="70%">
     <TR class="Spacing">
    	  <TD colSpan=2>
    	  <TABLE class=ViewForm>
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">         
          <TBODY>

          <%for (int i=0;i<coderMemberList.size();i++){
                 String[] codeMembers = (String[])coderMemberList.get(i);
                 String codeMemberName = codeMembers[0];
                 String codeMemberValue = codeMembers[1];
                 String codeMemberType = codeMembers[2];
				 
             %>
                <TR id="TR_<%=i%>" customer1="member">
                    <TD codevalue="<%=codeMemberName%>">
                     
                     <%if (canEdit){ %>
                       <a href="javaScript:imgUpOnclick(<%=i%>)">
                       <img id="img_up_<%=i%>" <%if (i==0) {%>style="visibility:hidden;width=0"  <%}%> name="img_up" src='/images/ArrowUpGreen.gif' title='<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>' border=0></a>
                       &nbsp;
                       <a href="javaScript:imgDownOnclick(<%=i%>)">
                       <%%><img id="img_down_<%=i%>"  <%if (i==coderMemberList.size()-1) {%>style="visibility:hidden;width=0" <%}%> name ="img_down" src='/images/ArrowDownRed.gif' title='<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>' border=0></a>              
                       &nbsp;
                       <%}%>
                      <%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage()) %>
                    </TD>
                    <TD class="Field">
                      <%
                         if ("1".equals(codeMemberType)){   //1:checkbox
                           if ("1".equals(codeMemberValue)){
                             if (canEdit){
                              out.println("<input id=chk_"+i+" type=checkbox class=inputstyle checked value=1  onclick=proView()>");
                             } else {
                              out.println("<div>"+SystemEnv.getHtmlLabelName(160,user.getLanguage())+"</div>");
                             }
                           } else {
                              if (canEdit){
                                out.println("<input id=chk_"+i+" type=checkbox class=inputstyle  value=1  onclick=proView()>");
                               } else {
                                out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
                               }                              
                           }
                         } else if ("2".equals(codeMemberType)){   //2:input
                              if (canEdit){%>
                                 <input type=text name="inputt<%=i%>" <%if (codeMemberName.equals("18811")) {%> onchange='checkint("inputt<%=i%>");proView();'<%} else {%>onchange=proView()<%}%> class=inputstyle   value="<%=codeMemberValue%>" maxLength='50'>
                              <% } else {
                                  out.println("<div>"+codeMemberValue+"</div>");
                               } 
                             
                         } 
                    %>
                    </TD>                   
                </TR>  
                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
              <%}%>


            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(22298,user.getLanguage())%></TD>
					<TD class="Field"><input class="inputStyle" type="checkbox" name="subcompanyflow" value="1" <%if ("1".equals(subcompanyflow)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
					</TD>
            	</TR>
            	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(22299,user.getLanguage())%></TD>
					<TD class="Field"><input class="inputStyle" type="checkbox" name="departmentflow" value="1" <%if ("1".equals(departmentflow)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
					</TD>
            	</TR>
            	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
            	
            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(22300,user.getLanguage())%></TD>
					<TD class="Field"><input class="inputStyle" type="checkbox" name="capitalgroupflow" value="1" <%if ("1".equals(capitalgroupflow)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
					</TD>
            	</TR>
            	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(22907,user.getLanguage())%></TD>
					<TD class="Field"><input class="inputStyle" type="checkbox" name="assetdataflow" value="1" <%if ("1".equals(assetdataflow)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
					</TD>
            	</TR>
            	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
            	
            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(22301,user.getLanguage())%></TD>
					<TD class="Field"><input class="inputStyle" type="checkbox" name="capitaltypeflow" value="1" <%if ("1".equals(capitaltypeflow)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
					</TD>
            	</TR>
            	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>            	            	

            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(22302,user.getLanguage())%></TD>
					<TD class="Field">
						<input class="inputStyle" type="checkbox" name="buydate" value="1" <%if ("1".equals(buydate)) out.println("checked");%> >&nbsp;
						<input class="inputStyle" type="radio" name="buydateselect" value="1" <%if ("1".equals(buydateselect)||"".equals(buydateselect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="buydateselect" value="2" <%if ("2".equals(buydateselect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="buydateselect" value="3" <%if ("3".equals(buydateselect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>						
					</TD>
            	</TR>
            	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(22303,user.getLanguage())%></TD>
					<TD class="Field">
						<input class="inputStyle" type="checkbox" name="Warehousing" value="1" <%if ("1".equals(Warehousing)) out.println("checked");%> >&nbsp;
						<input class="inputStyle" type="radio" name="Warehousingselect" value="1" <%if ("1".equals(Warehousingselect)||"".equals(Warehousingselect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="Warehousingselect" value="2" <%if ("2".equals(Warehousingselect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="Warehousingselect" value="3" <%if ("3".equals(Warehousingselect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>						
					</TD>
            	</TR>
            	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20578,user.getLanguage())%></TD>
					<TD class="Field"><input class="inputStyle" type="checkbox" name="changecode" value="1" onclick="onchangecode(this)">
					</TD>
            	</TR>
            	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
            	<TR id="statrcodenumtr" name="statrcodenumtr" style="display:none">
            		<TD><%=SystemEnv.getHtmlLabelName(20578,user.getLanguage())%></TD>
					<TD class="Field"><input class="inputStyle" type="text" name="startcodenum" value="<%=statrcodenum%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("startcodenum")' <%if(!canEdit){%>disabled<%}%>>
					</TD>
            	</TR>
            	<TR id="statrcodenumtr" name="statrcodenumtr" style="height:1px;" style="display:none"><TD class=Line colSpan=2></TD></TR>
                 <TR>
                    <TD><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></TD>
                    <TD class="Field"> 
                      <table border="1" cellspacing="0" cellpadding="0">
                        <tr id="TR_pro"></tr>
                        
                      </table>
                    </TD>
                 </TR>
                 <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

          </TBODY>
        </td>
        </tr>
        </TABLE>
    	  
    	  </TD></TR>   	  
</table>

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

</form>
</div>


<script language="JavaScript" src="/js/addRowBg.js" ></script>
<script language=javascript>

function selectall(){
	
	window.document.frmCoder.submit();
}

function onchangecode(obj){
	if(obj.checked==true){
		document.getElementsByName("statrcodenumtr")[0].style.display="";
		document.getElementsByName("statrcodenumtr")[1].style.display="";		
	}else{
		document.getElementsByName("statrcodenumtr")[0].style.display="none";
		document.getElementsByName("statrcodenumtr")[1].style.display="none";	
	}
}

</script>

</body>

<SCRIPT LANGUAGE="JavaScript">
<!--
var colors= new Array ("#6633CC","#FF33CC","#666633","#CC00FF","#996666")  ;

function load(){  //检查Imag的状态
  var img_ups = document.getElementsByName("img_up");
  for (var index_up=0;index_up<img_ups.length;index_up++)  {
    var img_up = img_ups[index_up];
    if (index_up==0)  img_up.style.visibility ='hidden';
    else  img_up.style.visibility ='visible';
  }

  var img_downs = document.getElementsByName("img_down");
  for (var index_down=0;index_down<img_downs.length;index_down++)  {
    var img_down = img_downs[index_down];
    if (index_down==img_downs.length-1)  img_down.style.visibility ='hidden';
    else  img_down.style.visibility ='visible';
  }

  proView();
}

function proView(){
    var TR_pro = document.getElementById("TR_pro");
    var TR_proChilds = TR_pro.childNodes;    
    for (var i=TR_proChilds.length-1;i>=0;i--) jQuery(TR_proChilds[i]).remove();


    var TR_members= jQuery("TR[customer1=member]");
    for (var index=0;index< TR_members.length;index++ ){      
      var TR_member = TR_members[index];
      //if ($(TR_member).attr("customer1")!="member") continue;

	  var codeTitle = $.trim(jQuery(jQuery(TR_member).children()[0]).text());
      var codeTypeTag = jQuery(jQuery(TR_member).children()[1]).children()[0].tagName;   //checkbox input div    
      var codeValue;

      if (codeTypeTag=="INPUT") {
        codeValue= jQuery(jQuery(TR_member).children()[1]).children()[0].value; 

        if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="text") {
           codeValue = jQuery(jQuery(TR_member).children()[1]).children()[0].value;
        } else if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="checkbox"){
           codeValue = jQuery(jQuery(TR_member).children()[1]).children()[0].checked==true?"1":"0";
        }
      }
      else if (codeTypeTag=="DIV") codeValue = jQuery(jQuery(TR_member).children()[1]).children()[0].innerText;
       

        if (codeTypeTag=="INPUT"||codeTypeTag=="DIV"&&codeValue!="不使用")  { 
            if (codeTypeTag=="INPUT") {
                if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="checkbox"&&codeValue=="0") continue;
                if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="checkbox"&&codeValue=="1"){
                 var selectObjs=jQuery(TR_member).children()[1].getElementsByTagName("SELECT");                 
                  if (selectObjs.length>=1)  {
                    if(selectObjs[0].value=="0") codeValue="**";
                    else codeValue="****";
                  }
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

        newColMiddle.className="Line";
        jQuery(newColMiddle).parents("tr")[0].style.height="1px";

        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";

        if (codeValue=="1") {
          codeValue="****";
        } else if (codeValue=="0") {
          codeValue="**";
        }
        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
        tempTd.appendChild(tempTable);
        TR_pro.appendChild(tempTd);         
      }
    }
    
}

function onSave(obj){

  var TR_members= document.getElementsByTagName("TR");
  var postValueStr="";
  for (var index=0;index< TR_members.length;index++ ){      
    var TR_member = TR_members[index];
    if (TR_member.customer1!="member") continue;
    
    var codeTitle = jQuery(TR_member).children()[0].codevalue.replace(/(^\s+|\s+$)/g,"");
    var codeTypeTag = jQuery(jQuery(TR_member).children()[1]).children()[0].tagName;   //checkbox input div    
    var codeValue;
    var codeType

    if (codeTypeTag=="INPUT") {
      codeValue= jQuery(jQuery(TR_member).children()[1]).children()[0].value; 
      if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="text") {
         codeValue = jQuery(jQuery(TR_member).children()[1]).children()[0].value;
         if (codeValue=="") codeValue="[(*_*)]";
         codeType = 2
      } else if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="checkbox"){
         codeValue = jQuery(jQuery(TR_member).children()[1]).children()[0].checked==true?"1":"0";
         codeType=1      //input

         var selectObjs=jQuery(TR_member).children()[1].getElementsByTagName("SELECT");                 
         if (selectObjs.length>=1)  {
           codeType=3   //year
           codeValue=codeValue+"|"+selectObjs[0].value;
         }
      }
    }
    postValueStr += codeTitle+"\u001b"+codeValue+"\u001b"+ codeType+"\u0007";
 }
 postValueStr = postValueStr.substring(0,postValueStr.length-1);
 document.frmCoder.postValue.value=postValueStr;
 document.frmCoder.method.value="update";
 //alert(postValueStr)
 document.frmCoder.submit();
}
 
function onYearChkClick(obj,index){  
    document.getElementById("select_"+index).disabled=!obj.checked;
    proView();
}

function imgUpOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =jQuery(jQuery(obj1).children()[1]).children()[0];
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  var obj2 = jQuery(obj1).prev().prev()[0];
  var checkbox2 =jQuery(jQuery(obj2).children()[1]).children()[0];
  
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

 
  swapNode(obj1, obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  load();
}

function imgDownOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =jQuery(jQuery(obj1).children()[1]).children()[0];
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  var obj2 = jQuery(obj1).next().next()[0];
  var checkbox2 =jQuery(jQuery(obj2).children()[1]).children()[0];
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

 
  swapNode(obj1, obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  load();
 
}

proView();

function swapNode(node, node2) {
	jQuery(node2).replaceWith(jQuery("<div></div>").append(jQuery(node).clone()).html());
	jQuery(node).replaceWith(jQuery("<div></div>").append(jQuery(node2).clone()).html());
}
//-->
</SCRIPT>
</html>