<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<%
String sysid = request.getParameter("id");
 rs.executeSql("select * from outter_sys where sysid='"+sysid+"'");
        
	String name = "";
	String iurl = "";
    String ourl = "";
	String baseparam1="";
	String baseparam2="";
	String typename = "";
	String accountcode = "";
	int basetype1=0;
	int basetype2=0;
 if(rs.next()){
      
	name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	iurl = Util.toScreenToEdit(rs.getString("iurl"),user.getLanguage());
    ourl = Util.toScreenToEdit(rs.getString("ourl"),user.getLanguage());
	baseparam1 = Util.toScreenToEdit(rs.getString("baseparam1"),user.getLanguage());
	baseparam2 = Util.toScreenToEdit(rs.getString("baseparam2"),user.getLanguage());
	basetype1 = Util.getIntValue(rs.getString("basetype1"),0);
	basetype2 = Util.getIntValue(rs.getString("basetype2"),0);
	typename = Util.toScreenToEdit(rs.getString("typename"),user.getLanguage());
	accountcode = Util.toScreenToEdit(rs.getString("ncaccountcode"),user.getLanguage());
	}

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/interface/outter/OutterSysAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
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
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=frmMain action="OutterSysOperation.jsp" method=post>

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
         
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=30 maxlength="30" name="name"  value="<%=name%>" onchange='checkinput("name","nameimage")'>
          <SPAN id=nameimage></SPAN><%}else{%><%=name%><%}%></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TD nowrap><%=SystemEnv.getHtmlLabelName(20963,user.getLanguage())%></TD>
          <TD nowrap class=Field><%if(canEdit){%><input class=inputstyle type=text size=100 maxlength="200" name="iurl"  value="<%=iurl%>" onchange='checkinput("iurl","iurlimage")'>
          <SPAN id=iurlimage></SPAN><%}else{%><%=iurl%><%}%></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20964,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=100 maxlength="200" name="ourl"   value="<%=ourl%>" onchange='checkinput("ourl","ourlimage")'>
          <SPAN id=ourlimage></SPAN><%}else{%><%=ourl%><%}%></TD>
        </TR>
       </TR>
       <TR><TD class=Line colSpan=2></TD></TR>
	   <TR>
          <TD nowrap><%=SystemEnv.getHtmlLabelName(20965,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=30 maxlength="30" name="baseparam1"   value="<%=baseparam1%>" onchange='checkinput("baseparam1","baseparam1image")'>
          <SPAN id=baseparam1image></SPAN><%}else{%><%=baseparam1%><%}%>
		  <input type=radio name=basetype1 value=1 <%if(basetype1==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(20974,user.getLanguage())%>
		  <input type=radio name=basetype1 value=0 <%if(basetype1==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%>
		  </TD>
        </TR>
       </TR>
       <TR><TD class=Line colSpan=2></TD></TR>   
	   <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20966,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=30 maxlength="30" name="baseparam2"   value="<%=baseparam2%>" onchange='checkinput("baseparam2","baseparam2image")'>
          <SPAN id=baseparam2image></SPAN><%}else{%><%=baseparam2%><%}%>
		  <input type=radio name=basetype2 value=1 <%if(basetype2==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(20975,user.getLanguage())%>
		  <input type=radio name=basetype2 value=0 <%if(basetype2==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%>
		  </TD>
        </TR>
       </TR>
       <TR><TD class=Line colSpan=2></TD></TR>
	   <%
	    if("1".equals(typename)){			 
	   %>
	    <TR>
          <TD nowrap><%=SystemEnv.getHtmlLabelName(24427,user.getLanguage())%></TD>
          <TD nowrap class=Field>
		   <%if(canEdit){%><input class=inputstyle type=text size=30 maxlength="30" name="accountcode"  value="<%=accountcode%>"onchange='checkinput("accountcode","accountcodeimage")'>
            <SPAN id=accountcodeimage><%}else{%><%=accountcode%><%}%><%if("".equals(accountcode)){ %><IMG src="/images/BacoError.gif" align=absMiddle><%} %></SPAN>        
		  </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR>
		<%}%>
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
		                                             		
                        	</TABLE>
                    		
            		</TD>
          		</TR>
       		</TABLE> 
		<td>
		
		</tr>
 </TBODY>
 </TABLE>
  <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=sysid value="<%=sysid%>">
 <input class=inputstyle type=hidden name=typename value="<%=typename%>">
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
 function onSave(){
	var checkvalue = "";
	var typenametmp = "<%=typename%>";
	if(typenametmp == 1) {
		checkvalue = "sysid,name,iurl,ourl,accountcode";
	} else {
		checkvalue = "sysid,name,iurl,ourl";
	}
    if(check_form(frmMain,checkvalue)){
    	document.frmMain.operation.value="edit";
		document.frmMain.submit();
    }
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
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
		
		/*============ Ñ¡Ôñ ============*/
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
function init()
{
	
<%
		rs.executeSql("SELECT * FROM outter_sysparam where sysid='"+sysid+"' order by indexid");
		
		while (rs.next()) 
		{
        int paramtype= Util.getIntValue(rs.getString("paramtype"),0);
%>
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
		
			/*============ Ñ¡Ôñ ============*/
	        var oCell = oRow.insertCell();
	        var oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='checkbox' name='paramid'  ><INPUT type='hidden' name='paramids' value=''>";                        
	        oCell.appendChild(oDiv);
	        
	        /*============ Ãû³Æ ============*/
	        oCell = oRow.insertCell();
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle' type='text' name='paramnames'  value='<%= rs.getString("paramname") %>'  ><SPAN></SPAN>";                        
	        oCell.appendChild(oDiv);
	        
			oCell = oRow.insertCell();
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle' type='text' name='labelnames'  value='<%= rs.getString("labelname") %>'  ><SPAN></SPAN>";                        
	        oCell.appendChild(oDiv);
	     
	        oCell = oRow.insertCell();
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<select name=paramtypes onchange='onTypeChange(this)'><option value=0 <%if(paramtype==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option><option value=1 <%if(paramtype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%></option><option value=2 <%if(paramtype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><option value=3 <%if(paramtype==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></option><select><INPUT <%if(paramtype!=0){%>style='display:none'<%}%> class='Inputstyle' type='text' name='paramvalues'  value='<%= rs.getString("paramvalue") %>'  ><SPAN></SPAN>";                        
	        oCell.appendChild(oDiv);
	        
	        
<%
		}

%>
}
	init();
 </script>
</BODY>
</HTML>