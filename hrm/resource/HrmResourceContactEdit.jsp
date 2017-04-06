<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<html>
<%
 String id = request.getParameter("id");
 String isView = request.getParameter("isView");
 int rightid = 0;
 if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)){
	   rightid = 3;
}
 if(user.getManagerid().equals("id")){
     rightid = 1;
 }  
 if(user.getUID()==Util.getIntValue(id)){
     rightid = 2;
 }
%>
<head>
  <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(621,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
 if(rightid > 1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM name=resourcebasicinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
	<%
	  String sql = "";
	  sql = "select * from HrmResource where id = "+id;  
	  rs.executeSql(sql);
	  while(rs.next()){    
	    String locationid = Util.null2String(rs.getString("locationid"));
	    String workroom = Util.null2String(rs.getString("workroom"));
	    String telephone = Util.null2String(rs.getString("telephone"));
	    String mobile = Util.null2String(rs.getString("mobile"));
	    String mobilecall = Util.null2String(rs.getString("mobilecall"));
	    String fax = Util.null2String(rs.getString("fax"));
	    String email = Util.null2String(rs.getString("email"));
	    int systemlanguage = Util.getIntValue(rs.getString("systemlanguage"));    
		String photoid = Util.null2String(rs.getString("resourceimageid"));
	%>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	</colgroup>
	<tr>
	<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td ></td>
		<td valign="top">
			<TABLE class=Shadow>
				<tr>
					<td valign="top">
						<input type=hidden name=operation>
						<input type=hidden name=id value="<%=id%>">
						<input type=hidden name=view>
					  <TABLE class=viewForm>
					    <COLGROUP> 
						    <COL width="49%"> 
						    <COL width=10> 
						    <COL width="49%"> 
						</COLGROUP>
					    <TBODY> 
						    <TR> 
						      <TD vAlign=top> 
						        <TABLE width="100%">
						          <COLGROUP> 
							          <COL width=30%> 
							          <COL width=70%>
						          </COLGROUP>
						          <TBODY> 
						          <TR class=title> 
						            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16076,user.getLanguage())%></TH>
						          </TR>
						          <TR class=spacing> 
						            <TD class=Sep1 colSpan=2></TD>
						          </TR>
						         <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
						          <TR> 
						            <TD id=lblLocation><%=SystemEnv.getHtmlLabelName(16074,user.getLanguage())%></TD>
						            <TD class=Field id=txtLocation>
						              <BUTTON class=Browser id=SelectLocationID onClick="onShowLocationID()"></BUTTON> 
						              <SPAN id=locationidspan><%if(rs.getString("locationid").equals("") || rs.getString("locationid").equals("0")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%><%=LocationComInfo.getLocationname(locationid)%></SPAN>
						              <INPUT id=locationid type=hidden name=locationid value="<%=locationid%>">   
						            </TD>
						          </TR>
						         <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
						          <tr> 
						            <td id=lblRoom><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></td>
						            <td class=Field id=txtRoom> 
						              <input type=text name=workroom value="<%=workroom%>">
						            </td>          
						          </tr>
						          <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
						          <TR>             
						            <TD><%=SystemEnv.getHtmlLabelName(661,user.getLanguage())%></TD>
						            <TD class=Field> 
						              <input type=text name=telephone value="<%=telephone%>">
						            </TD>
						          </TR>   
						          <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
						          <TR> 
						            <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
						            <TD class=Field> 
						              <input type=text name=mobile value="<%=mobile%>">
						            </TD>
						          </TR>
						        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
						          <TR> 
						            <TD><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></TD>
						            <TD class=Field> 
						              <input type=text name=mobilecall value="<%=mobilecall%>">
						            </TD>
						          </TR>
						        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
						          <TR> 
						            <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
						            <TD class=Field> 
						              <input type=text name=fax value="<%=fax%>">
						            </TD>
						          </TR>
						        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
						          <TR> 
						            <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
						            <TD class=Field> 
						              <input type=text name=email value="<%=email%>">
						            </TD>
						          </TR>
						<%if(isMultilanguageOK){%>
						          <TR> 
						            <TD><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></TD>
						            <TD class=Field> 
						              <BUTTON class=Browser onclick="onShowLanguage()"></BUTTON> 
						              <SPAN id=systemlanguagespan><%=LanguageComInfo.getLanguagename(""+systemlanguage)%> </SPAN> 
						              <INPUT type=hidden name=systemlanguage value="<%=systemlanguage%>">               
						            </TD>
						          </TR> 
						<%}
						%>
						
						<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 	
						          </TBODY> 
						        </TABLE> 
			        		  </TD>
			        		  <td>
			        		  </td>
			        		  <td valign="top">
			        		  
			        		  <table width="100%"  >
          <TR class=Title >
            <TH ><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TH>
          </TR>
    <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR>
<%
  if(!photoid.equals("0")&&!photoid.equals("") ){
%>
          <TR class=Spacing style="height:1px;">
            <TD class=Line1 colspan="3"></TD>
           <TR>
            <TD >
              <img border=0 width=400 src="/weaver/weaver.file.FileDownload?fileid=<%=photoid%>">
            </TD>
          </TR>
          <input class=inputstyle type=hidden name=oldresourceimage value="<%=photoid%>">
          <tr>
           <td align=right>
            <BUTTON class=btnDelete accessKey=D onClick="delpic()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%></BUTTON>
           </td>
          </tr>
<%
}else{
%>
          <TR>
            <TD> <%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type=file name=photoid value="<%=photoid%>">
            </TD>
			
			<TD class=Field>(<%=SystemEnv.getHtmlLabelName(21130,user.getLanguage())%>:400*450)
			</TD>
         </TR>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<%
}
%>

       </table>
			        		  
			        		  </td>
			        		</TR>
		        		</TBODY>
		        	</TABLE>         
</td>
</tr>
</TABLE>
</td>

<td valign="top">
      
</td>

</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>

</table>
<%} %>
</FORM>
<script language=vbs>  
  sub onShowLocationID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	locationidspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.locationid.value=id(0)
	else 
	locationidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.locationid.value=""
	end if
	end if
end sub

sub onShowLanguage()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	systemlanguagespan.innerHtml = id(1)
	resource.systemlanguage.value=id(0)
	else 
	systemlanguagespan.innerHtml = ""
	resource.systemlanguage.value=""
	end if
	end if
end sub

</script>
 <script language=javascript>
  function chkMail(){
if(document.resourcebasicinfo.email.value == ''){
return true;
}

var email = document.resourcebasicinfo.email.value;
var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
chkFlag = pattern.test(email);
if(chkFlag){
return true;
}
else
{
alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
document.resourcebasicinfo.email.focus();
return false;
}
}
  function dosave(){
	  if(!chkMail()) return false;
	  if(check_formM(document.resourcebasicinfo,'locationid')){
	  document.resourcebasicinfo.operation.value = "editcontactinfo";
	  document.resourcebasicinfo.submit();
	  }
  }
  function viewBasicInfo(){    
    if(<%=isView%> == 0){
      location = "/hrm/resource/HrmResourceBasicInfo.jsp?id=<%=id%>";
    }else{
   	  if('<%=isfromtab%>'=='true')
      	location = "/hrm/resource/HrmResourceBase.jsp?id=<%=id%>";
      else
      	location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
    }  
  }
  

    function check_formM(thiswins,items)
	{
		thiswin = thiswins
		items = ","+items + ",";
		for(i=1;i<=thiswin.length;i++)
		{
		tmpname = thiswin.elements[i-1].name;
		tmpvalue = thiswin.elements[i-1].value;
		if(tmpname=="locationid"){
			if(tmpvalue == 0){
				alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
				return false;
			}
		}
		if(tmpvalue==null){
			continue;
		}
		while(tmpvalue.indexOf(" ") == 0)
			tmpvalue = tmpvalue.substring(1,tmpvalue.length);
		
		if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
			 alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
			 return false;
			}

		}
		return true;
	}
    function delpic(){
        if(confirm("确定要删除此图片吗？")){
		  document.resourcebasicinfo.operation.value = "delpic";
		  document.resourcebasicinfo.view.value="contactinfo";
		  document.resourcebasicinfo.submit();
        }
    }
</script> 
</body>
</html>