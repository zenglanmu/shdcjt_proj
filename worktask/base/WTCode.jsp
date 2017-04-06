<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.worktask.code.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean canEdit=true;
if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<html>
<%
	int wtid = Util.getIntValue(Util.null2String(request.getParameter("wtid")), 0);

	String sql = "select worktask_taskfield.fieldid, worktask_taskfield.crmname, worktask_fielddict.description from worktask_taskfield, worktask_fielddict where worktask_taskfield.fieldid=worktask_fielddict.id and worktask_fielddict.fieldhtmltype=1 and worktask_fielddict.type=1 and worktask_taskfield.isshow=1 and worktask_taskfield.taskid="+wtid;

	//初始值
	//CodeBuild cbuild = new CodeBuild(formid); 
	//CodeBuild cbuild = new CodeBuild(formid,isbill);
	CodeBuild cbuild = new CodeBuild(wtid);
	boolean hasHistoryCode = cbuild.hasHistoryCode(RecordSet,wtid);
	CoderBean cbean = cbuild.getTaskCBuild();
	ArrayList coderMemberList = cbean.getMemberList();
	String isUse =  cbean.getUserUse();
	String worktaskSeqAlone =  cbean.getWorktaskSeqAlone();
	String dateSeqAlone =  cbean.getDateSeqAlone();
	String dateSeqSelect =  cbean.getDateSeqSelect();
	String codefield = cbean.getCodeFieldId();
%>

<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<body>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowCodeSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.reload(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form id="frmCoder" name="frmCoder" method=post action="coderOperation.jsp" >

<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
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
       <TR class="Spacing" style="height:2px">
    	  <TD class="Line1" colSpan=2></TD>
	   </TR>
       <TR>
                    <TD><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></TD>
                    <TD  class="Field"> <input class="inputStyle" type="checkbox" name="txtUserUse" value="1" <%if ("1".equals(isUse)) out.println("checked");%>>
                    </TD>
       </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>

          <TR class="Title">
    	  <TH colspan=2><%=SystemEnv.getHtmlLabelName(19503,user.getLanguage())%></th><th>
    	  </TH></TR>

</table>


<div id="odiv">
 <table class="viewform">
   <COLGROUP>
   <COL width="30%">
   <COL width="70%">
      <TR class="Spacing" style="height:1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
  </table>

  <table class=viewform cellspacing=1  id="oTable4port">
  <COLGROUP>
    <COL width="30%">
  	<COL width="70%">
    	   <tr>
            <td><%=SystemEnv.getHtmlLabelName(19503,user.getLanguage())%></td>
            <td class=Field>
            <select name="selectField">
            <%  
			//System.out.println(sql);
			RecordSet.execute(sql);
			while (RecordSet.next()){
				int fieldid = Util.getIntValue(RecordSet.getString("fieldid"), 0);
				String description = Util.null2String(RecordSet.getString("description"));
				String crmname = Util.null2String(RecordSet.getString("crmname"));
				if("".equals(crmname)){
					crmname = description;
				}
            %>
            <option  <%if (codefield.equals(""+fieldid)) {%>selected<%}%>  value=<%=fieldid%>>
			<%=crmname%>
			</option>
            <%}%>
            </select>
             <!-- 编号字段--></td>
</tr> <TR class="Spacing" style="height:1px">
    	  <TD class="Line" colSpan=2></TD></TR>
    </table>
    
<table class="viewform">
   <COLGROUP>
   <COL width="30%">
   <COL width="70%">
<TR class="Title">
 <TH colspan=2><%=SystemEnv.getHtmlLabelName(19504,user.getLanguage())%></th><th>
 </TH></TR>

</table>	
 <table class="viewform">
   <COLGROUP>
   <COL width="30%">
   <COL width="70%">
      <TR class="Spacing" style="height:1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
  </table>

  <table class=viewform cellspacing=1  id="oTable4port">

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
<%
List hisShowNameList =new ArrayList();
hisShowNameList.add("18729");
hisShowNameList.add("445");
hisShowNameList.add("6076");
hisShowNameList.add("18811");
%>
          <%for (int i=0;i<coderMemberList.size();i++){
                 String[] codeMembers = (String[])coderMemberList.get(i);
                 String codeMemberName = codeMembers[0];
                 String codeMemberValue = codeMembers[1];
                 String codeMemberType = codeMembers[2];
				 
				 if(hasHistoryCode&&hisShowNameList.indexOf(codeMemberName)==-1){
					 continue;
				 }
             %>
                <TR id="TR_<%=i%>" customer1="member">
                    <TD codevalue="<%=codeMemberName%>">
                     <%if (canEdit){%>
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
                                 <input type=text name="inputt<%=i%>" <%if (codeMemberName.equals("18811")) {%> onchange='checkint("inputt<%=i%>");proView();'<%} else {%>onchange=proView()<%}%> class=inputstyle   value="<%=codeMemberValue%>">
                              <% } else {
                                  out.println("<div>"+codeMemberValue+"</div>");
                               } 
                             
                         }  
                    %>
                    </TD>                   
                </TR>  
                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <%}%>
<%if(!hasHistoryCode){%>

            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(22133, user.getLanguage())%></TD>
					<TD class="Field"><input class="inputStyle" type="checkbox" name="worktaskSeqAlone" value="1" <%if ("1".equals(worktaskSeqAlone)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
					</TD>
            	</TR>
            	<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>

            	<TR>
            		<TD><%=SystemEnv.getHtmlLabelName(19418,user.getLanguage())%></TD>
					<TD class="Field">
						<input class="inputStyle" type="checkbox" name="dateSeqAlone" value="1" <%if ("1".equals(dateSeqAlone)) out.println("checked");%> >&nbsp;
						<input class="inputStyle" type="radio" name="dateSeqSelect" value="1" <%if ("1".equals(dateSeqSelect)||"".equals(dateSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="dateSeqSelect" value="2" <%if ("2".equals(dateSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;&nbsp;
						<input class="inputStyle" type="radio" name="dateSeqSelect" value="3" <%if ("3".equals(dateSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
						
					</TD>
            	</TR>
            	<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<%}%>
                 <TR>
                    <TD><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></TD>
                    <TD class="Field"> 
                      <table border="1" cellspacing="0" cellpadding="0">
                        <tr id="TR_pro"></tr>
                        
                      </table>
                    </TD>
                 </TR>
                 <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
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
<tr>
	<td height="0" colspan="3"></td>
</tr>
</table>

<br>
<center>
    <INPUT TYPE="hidden" NAME="postValue">
    <INPUT TYPE="hidden" NAME="wtid" value="<%=wtid%>">
<center>
</form>
</div>

<script language="JavaScript" src="/js/addRowBg.js" >
</script>

</body>

<SCRIPT LANGUAGE="JavaScript">

var colors= new Array ("#6633CC","#FF33CC","#666633","#CC00FF","#996666")  ;

function load(){  //检查Imag的状态
  var img_ups = jQuery("img[name=img_up]");
  for (var index_up=0;index_up<img_ups.length;index_up++)  {
    var img_up = img_ups[index_up];
    if (index_up==0)  {img_up.style.visibility ='hidden';
    img_up.style.width =0;}
    else  
    {img_up.style.visibility ='visible';
    img_up.style.width =10;
    }
  }

  var img_downs = jQuery("img[name=img_down]");
  for (var index_down=0;index_down<img_downs.length;index_down++)  {
    var img_down = img_downs[index_down];
    if (index_down==img_downs.length-1)  {img_down.style.visibility ='hidden';
    img_down.style.width =0;
    }
    
    else  {img_down.style.visibility ='visible';
    img_down.style.width =10;
    }
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
      
      var codeTitle = jQuery.trim(jQuery(jQuery(TR_member).children()[0]).text());
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
 // obj.disabled=true;

  var TR_members= document.getElementsByTagName("TR");
  var postValueStr="";
  for (var index=0;index< TR_members.length;index++ ){      
    var TR_member = TR_members[index];
    if (TR_member.customer1!="member") continue;
    
    var codeTitle = TR_member.childNodes[0].codevalue.replace(/(^\s+|\s+$)/g,"");
    var codeTypeTag = TR_member.childNodes[1].firstChild.tagName;   //checkbox input div    
    var codeValue;
    var codeType

    if (codeTypeTag=="INPUT") {
      codeValue= TR_member.childNodes[1].firstChild.value; 
      if (TR_member.childNodes[1].firstChild.type=="text") {
         codeValue = TR_member.childNodes[1].firstChild.value;
         if (codeValue=="") codeValue="[(*_*)]";
         codeType = 2
      } else if (TR_member.childNodes[1].firstChild.type=="checkbox"){
         codeValue = TR_member.childNodes[1].firstChild.checked==true?"1":"0";
         codeType=1      //input

         var selectObjs=TR_member.childNodes[1].getElementsByTagName("SELECT");                 
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
 //document.frmCoder.method.value="update";
 //alert(postValueStr)
 //document.frmCoder.submit();
}
 
function onYearChkClick(obj,index){  
    document.getElementById("select_"+index).disabled=!obj.checked;
    proView();
}

function imgUpOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 = jQuery(jQuery(obj1).children()[1]).children()[0];
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  var obj2 = jQuery(obj1).prev().prev()[0];
  var checkbox2 = jQuery(jQuery(obj2).children()[1]).children()[0];
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

  swapNode(obj1,obj2);
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

	var checkbox1 = jQuery(jQuery(obj1).children()[1]).children()[0];
	if (checkbox1.type=="checkbox"){
		checkbox1Stats = checkbox1.checked;
	}

	var obj2 = jQuery(obj1).next().next()[0];
	var checkbox2 = jQuery(jQuery(obj2).children()[1]).children()[0];
	if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

	swapNode(obj1,obj2);
	if (checkbox1Stats!=0) {
		checkbox1.checked=checkbox1Stats;
	}

	if (checkbox2Stats!=0) {
		checkbox2Stats.checked=checkbox2Stats;
	}
	load();

}
function flowCodeSave(obj){
	obj.disabled=true;
	onSave(obj);
	frmCoder.submit();
}



function swapNode(node, node2) {
	jQuery(node2).replaceWith(jQuery("<div></div>").append(jQuery(node).clone()).html());
	jQuery(node).replaceWith(jQuery("<div></div>").append(jQuery(node2).clone()).html());
}
</SCRIPT>

</html>