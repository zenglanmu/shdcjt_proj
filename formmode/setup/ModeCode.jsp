<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.formmode.setup.CodeBuild"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<html>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(19381,user.getLanguage());
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
<%
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int codeId = 0;
if(modeId > 0 && formId == 0){
	rs.executeSql("select formid from modeinfo where id="+modeId);
	if(rs.next()) {
		formId = rs.getInt(1);
	}
}
CodeBuild cbuild = new CodeBuild(modeId); 
codeId = cbuild.getCodeId();

//初始值
ArrayList coderMemberList = cbuild.getBuild();
int isUse = cbuild.getIsUse();		//是否启用
int codeFieldId = cbuild.getCodeFieldId();//编号字段

%>
<form id="frmCoder" name="frmCoder" method=post action="coderOperation.jsp" >
<INPUT TYPE="hidden" NAME="method">
<INPUT TYPE="hidden" NAME="postValue">
<INPUT TYPE="hidden" NAME="codemainid" value="<%=codeId%>">
<INPUT TYPE="hidden" NAME="modeId" value="<%=modeId%>">
<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
  <colgroup>
  <col width="10">
  <col width="">
  <col width="10">
  <tr><td height="10" colspan="3"></td></tr>
  <tr><td ></td>
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
  <TR class="Spacing" style="height: 1px"><TD class="Line1" colSpan=2></TD></TR>
  <!-- 是否启用 -->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></TD>
    <TD class="Field"> <input class="inputStyle" type="checkbox" name="txtUserUse" value="1" <%if (isUse==1) out.println("checked");%>>
    </TD>
  </TR>
  <TR class="Spacing" style="height: 1px"><TD class="Line" colSpan=2></TD></TR>
  <tr class="Title">
    <TH colspan=2><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></th><th>
  </th>
  <TR class="Spacing" style="height: 1px"><TD class="Line1" colSpan=2></TD></TR>
  <!-- 编号字段 -->
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(19503,user.getLanguage())%></td>
    <td class="Field">
      <select name="codeFieldId">
    <%
	  String sql="select id,fieldlabel from workflow_billfield where viewtype=0 and type='1' and fieldhtmltype='1' and billid="+formId;
	  rs.executeSql(sql);
	  while(rs.next()){
		  int fieldId = rs.getInt(1);
		  int fieldlabel = rs.getInt(2);
	%>
		<option  value=<%=fieldId %> <%if(codeFieldId == fieldId){%>selected<%}%>>
		 <%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		</option>
	<%
	  }
	%></select>
    </td>
  </tr>
  <TR class="Spacing" style="height: 1px"><TD class="Line" colSpan=2></TD></TR>
  <TR class="Title">
    <TH colspan=2><%=SystemEnv.getHtmlLabelName(19504,user.getLanguage())%></th>
  </TR>
  <TR style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>
  <%
  Map datamap = null;
  for (int i=0;i<coderMemberList.size();i++){
	  datamap = (Map)coderMemberList.get(i);
	  String codeMemberName = (String)datamap.get("showname");
      String codeMemberValue = (String)datamap.get("showvalue");
      String codeMemberType = (String)datamap.get("showtype");
  %>
  <TR id="TR_<%=i%>" customer1="member">
    <TD codevalue="<%=codeMemberName%>">
       <a href="javaScript:imgUpOnclick(<%=i%>)"><img id="img_up_<%=i%>" name="img_up" src='/images/ArrowUpGreen.gif' title='<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>' border=0></a>
       &nbsp;
       <a href="javaScript:imgDownOnclick(<%=i%>)"><img id="img_down_<%=i%>"  name ="img_down" src='/images/ArrowDownRed.gif' title='<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>' border=0></a>              
       &nbsp;
      <%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage()) %>
    </TD>
    <TD class="Field">
      <%
         if ("1".equals(codeMemberType)){   //1:checkbox
           	if ("1".equals(codeMemberValue)){
               	out.println("<input id=chk_"+i+" type=checkbox class=inputstyle checked value=1  onclick=proView()>");
           	} else {
               	out.println("<input id=chk_"+i+" type=checkbox class=inputstyle  value=1  onclick=proView()>");
           	}
         } else if ("2".equals(codeMemberType)){   //2:input num
              out.println("<input type=text class=inputstyle onchange=proView() maxlength='20' onKeyPress='ItemCount_KeyPress()' value="+codeMemberValue+">");
         } else if ("3".equals(codeMemberType)){  //3:input text
        	  out.println("<input type=text class=inputstyle onchange=proView() maxlength='20'  value="+codeMemberValue+">");
         }       
    %>
    </TD>                   
  </TR>  
  <tr  style="height: 1px"><td class=Line colspan=2></TD></TR>
  <%
  }%>
  <TR>
     <TD><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></TD>
     <TD> 
       <table border="1" cellspacing="0" cellpadding="0">
         <tr id="TR_pro"></tr>
       </table>
     </TD>
  </TR>
</table>  
		 </td>
		</tr>
	  </TABLE>
	</td>
  </tr>
</table>
</form>
</body>
<script type="text/javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	load();
})
jQuery.fn.swap = function(other) {
    $(this).replaceWith($(other).after($(this).clone(true)));
};


function onSave(obj){
 // obj.disabled=true;
 
  var postValueStr="";
 
  jQuery("tr[customer1='member']").each(function(index,obj){
	  var codeTitle = $(obj).find("td::eq(0)").attr("codevalue");
	  codeTitle = jQuery.trim(codeTitle)
	  var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
	  var codeValue;
	  var codeType;

	    if (codeTypeTag=="INPUT") {
	      codeValue= $(obj).find("td::eq(1)").children(":first").val();
	      if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
	         codeValue =  $(obj).find("td::eq(1)").children(":first").val();
	         if (codeValue=="") codeValue="[(*_*)]";
	         codeType = 2
	      } else if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
	         codeValue =  $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	         codeType=1
	         var selectObjs=$(obj).find("td::eq(1)").find("select");                 
	         if (selectObjs.length>=1)  {
	           codeType=3   //year
	           codeValue=codeValue+"|"+selectObjs[0].value;
	         }
	      }
	    }
	    postValueStr += codeTitle+"\u001b"+codeValue+"\u001b"+ codeType+"\u0007";
	})
 
	 postValueStr = postValueStr.substring(0,postValueStr.length-1);
	 document.frmCoder.postValue.value=postValueStr;
	 document.frmCoder.method.value="update";
	 //alert(postValueStr)
	 document.frmCoder.submit();
}

var colors= new Array ("#6633CC","#FF33CC","#666633","#CC00FF","#996666")  ;

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

  proView();
}

function proView(){
	 var TR_doc =  jQuery("#TR_pro");
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
	      else if (codeTypeTag=="DIV"){
	    	  codeValue = $(obj).find("td::eq(1)").children(":first").text();
	      }else if(codeTypeTag=="SELECT"){

			  //objSelect=TR_member.childNodes[1].firstChild;
			  codeValue= $(obj).find("td::eq(1)").children(":first").find("option:selected").text(); 
		  }
	      
	      if (codeTypeTag=="INPUT"||codeTypeTag=="DIV"&&codeValue!="不使用")  { 
	            if (codeTypeTag=="INPUT") {
	                if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"&&codeValue=="0"){ 
	                	return true;
	                }else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"&&codeValue=="1"){ 
	                	 var selectObjs=$(obj).find("td::eq(1)").find("select");                 
	                     if (selectObjs.length>=1)  {
	                       if($(selectObjs).find(":first").val()=="0") codeValue="**";
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


function imgUpOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =obj1.childNodes[1].firstChild;
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  //var obj2 = obj1.previousSibling.previousSibling;
  var obj2 = jQuery(obj1).prevAll("tr[customer1='member']").filter("tr:visible:first");
  var checkbox2 =$(obj2).find("td::eq(1)").children(":first");
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

  // obj1.swapNode(obj2);
  jQuery(obj1).swap(obj2);
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

  var checkbox1 =obj1.childNodes[1].firstChild;
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  //var obj2 = obj1.nextSibling.nextSibling;
  //var checkbox2 =obj2.childNodes[1].firstChild;
  var obj2 =jQuery(obj1).nextAll("tr[customer1='member']").filter("tr:visible:first");// 
  var checkbox2 =$(obj2).find("td::eq(1)").children(":first");
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

 
  //obj1.swapNode(obj2);
  jQuery(obj1).swap(obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  load();
 
}
</script>
</html>