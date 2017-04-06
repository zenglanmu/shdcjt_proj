<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<%
if(msgid!=-1){
%>
<TR>
		<TD colspan = "3">
			<font color="red">
				<%=SystemEnv.getHtmlLabelName(msgid,user.getLanguage())%>!
			</font>
		</TD>
</TR>

<%}%>
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=frmMain action="OutterSysOperation.jsp" method=post >
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(20962,user.getLanguage())%></TH></TR>
  <TR class=Spacing>
    <TD class=Line1 colSpan=2 ></TD></TR>
  <TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field>
		    <select name="typename" onchange="onChangeTypeFun(this.value)">
			  <option value="0"><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
			  <option value="1">NC</option>
			</select>
		  </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 maxlength="30" name="sysid" onchange='checkinput("sysid","sysidimage")'>
          <SPAN id=sysidimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 maxlength="30" name="name" onchange='checkinput("name","nameimage")'>
          <SPAN id=nameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD nowrap><%=SystemEnv.getHtmlLabelName(20963,user.getLanguage())%></TD>
          <TD nowrap class=Field><input class=inputstyle type=text size=100 maxlength="200" name="iurl" onchange='checkinput("iurl","iurlimage")'>
          <SPAN id=iurlimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20964,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=100 maxlength="200" name="ourl" onchange='checkinput("ourl","ourlimage")'>
          <SPAN id=ourlimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>
		<input class=inputstyle type="hidden" name=operation value=add>
        <TR><TD class=Line colSpan=2></TD></TR>
		<TR>
          <TD nowrap><%=SystemEnv.getHtmlLabelName(20965,user.getLanguage())%></TD>
          <TD nowrap class=Field><input class=inputstyle type=text size=30 maxlength="30" name="baseparam1" value='username' onchange='checkinput("baseparam1","baseparam1image")'>
          <SPAN id=baseparam1image></SPAN>
		  <input type=radio name=basetype1 value=1><%=SystemEnv.getHtmlLabelName(20974,user.getLanguage())%>
		  <input type=radio name=basetype1 value=0 checked><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%>
		  </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR>
		<TR>
          <TD nowrap><%=SystemEnv.getHtmlLabelName(20966,user.getLanguage())%></TD>
          <TD nowrap class=Field><input class=inputstyle type=text size=30 maxlength="30" name="baseparam2"  value='password' onchange='checkinput("baseparam2","baseparam2image")'>
          <SPAN id=baseparam2image></SPAN>
		  <input type=radio name=basetype2 value=1><%=SystemEnv.getHtmlLabelName(20975,user.getLanguage())%>
		  <input type=radio name=basetype2 value=0 checked><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%>
		  </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR>
		<TR id="acc_id1" style="display:none;">
          <TD nowrap><%=SystemEnv.getHtmlLabelName(24427,user.getLanguage())%></TD>
          <TD nowrap class=Field>
		    <input class=inputstyle type=text size=30 maxlength="30" name="accountcode" onchange='checkinput("accountcode","accountcodeimage")'>
            <SPAN id=accountcodeimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>        
		  </TD>
        </TR>
        <TR id="acc_id2" style="display:none;"><TD class=Line colSpan=2></TD></TR>
		<TR>
          <TD nowrap><%=SystemEnv.getHtmlLabelName(20967,user.getLanguage())%></TD>
          <TD></TD>
        </TR>
        <TR><TD class=Line1 colSpan=2></TD></TR>
		<tr>
		<td colSpan=2>
		  <TABLE width=100%>
            				<TR>
            					<TD align=right>
            						<BUTTON Class=Btn type=button accessKey=A onClick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            						<BUTTON Class=Btn type=button accessKey=E onClick="removeRow()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            					</TD>
            				</TR>
          				</TABLE>
            		
              		
                        	<TABLE class="listStyle" id="oTable" name="oTable">
                            	<COLGROUP>
		                            <COL width="7" align="center">
		                            <COL width="20%" align="left">
		                            <COL width="20%" align="center">
		                            <COL width="60%" align="left">
		                        <TR class="header">
		                            <TD align="center"><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this)"></TD>
		                            <TD align="center"><%=SystemEnv.getHtmlLabelName(20968,user.getLanguage())%></TD>
									<TD align="center"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
		                            <TD align="center"><%=SystemEnv.getHtmlLabelName(20969,user.getLanguage())%></TD>
		                         
		                        </TR>
		                        <TR class=line>
                            		<TD ColSpan=4></TD>
                          		</TR>                      	
		                        <TR id="ncpkcode_id1" style="display:none;">
		                            <TD></TD>
		                            <TD><INPUT class="Inputstyle" type="text" name="paramnames_nc"  value="pkcorp"></TD>
									<TD><INPUT class="Inputstyle" type="text" name="labelnames_nc"  value="公司名称"></TD>
		                            <TD>
		                                <%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%>
		                                <INPUT class="Inputstyle" type="hidden" name="paramtypes_nc"  value="1">
		                            </TD>                  
		                        </TR>                    		
                        	</TABLE>
                    		
            		</TD>
          		</TR>
       		</TABLE> 
		<td>
		
		</tr>
 </TBODY>
 </TABLE>
 </form>
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

<script language=javascript>  
function submitData() {
	var checkvalue = "";
	var typenametmp = document.getElementById("typename").value;
	if(typenametmp == 1) {
		checkvalue = "sysid,name,iurl,ourl,accountcode";
	} else {
		checkvalue = "sysid,name,iurl,ourl";
	}
    if(check_form(frmMain,checkvalue)){
      frmMain.submit();
    }
}

function addRow()
    {        
        var oRow = oTable.insertRow();
        var oRowIndex = oRow.rowIndex;

        if (0 == oRowIndex % 2)
        {
            oRow.className = "dataLight";
        }
        else
        {
            oRow.className = "dataDark";
        }
		
		/*============ 选择 ============*/
        var oCell = oRow.insertCell();
        var oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>";                        
        oCell.appendChild(oDiv);
        
        oCell = oRow.insertCell();
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='Inputstyle' type='text' name='paramnames'  value='' >";                        
        oCell.appendChild(oDiv);

        oCell = oRow.insertCell();
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='Inputstyle' type='text' name='labelnames'  value='' >";                        
        oCell.appendChild(oDiv);

        oCell = oRow.insertCell();
        oDiv = document.createElement("div");
        oDiv.innerHTML="<select name=paramtypes onchange='onTypeChange(this)'><option value=0><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option><option value=1><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%></option><option value=2><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><option value=3><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></option><select><INPUT class='Inputstyle' type='text' name='paramvalues'  value='' >";                 
        //alert(oDiv.innerHTML);
        oCell.appendChild(oDiv);
        
    }
        
    function removeRow()
    {
    	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>"))
    	{
	        var chks = document.getElementsByName("paramid");
	       
	        for (var i = chks.length - 1; i >= 0; i--)
	        {
	            var chk = chks[i];
	            //alert(chk.parentElement.parentElement.parentElement.rowIndex);
	            if (chk.checked)
	            {
	                oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
	            }
	        }
	    }
    }
	function chkAllClick(obj)
    {
        var chks = document.getElementsByName("paramid");
        
        for (var i = 0; i < chks.length; i++)
        {
            var chk = chks[i];
            
            if(false == chk.disabled)
            {
            	chk.checked = obj.checked;
            }
        }
    }
	function onTypeChange(obj){
		if(obj.value==0){
			obj.nextSibling.style.display='';
			//alert(obj.nextSibling.innerHTML.tagName);
		}
	    else{
			obj.nextSibling.style.display='none';
			//alert(obj.parentElement.getElementsByTagName('input')[0].tagName);
		}
	}

	function onChangeTypeFun(obj){
		if(obj == "1") {
			document.all("baseparam1").readOnly = true;
			document.all("baseparam2").readOnly = true;
			document.getElementById("acc_id1").style.display = "";
   		    document.getElementById("acc_id2").style.display = "";
   		    document.getElementById("ncpkcode_id1").style.display = "";
		} else {
		    document.all("baseparam1").readOnly = false;
			document.all("baseparam2").readOnly = false;
			document.getElementById("acc_id1").style.display = "none";
   		    document.getElementById("acc_id2").style.display = "none";
   		    document.getElementById("ncpkcode_id1").style.display = "none";
		}
	}
</script>
</BODY>
</HTML>
