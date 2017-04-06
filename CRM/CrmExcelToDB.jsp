<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.net.URLDecoder.*"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

</head>
<% 
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18038,user.getLanguage());
String needfav ="1";
String needhelp ="";  

%>   
<BODY> 
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
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


<FORM id=cms name=cms action="CrmExcelToDBOperation.jsp" method=post enctype="multipart/form-data">

<TABLE class="viewForm">
<COLGROUP>
<COL width="40%">
<COL width="60%">
<TBODY>
<TR class=Title>
    <TH  colSpan="2"><%=SystemEnv.getHtmlLabelName(18038,user.getLanguage())%></TH>
</TR>
<TR class=Spacing style="height: 1px">
    <TD class=Line1  colSpan="2"></TD>
</TR>

<tr>
<td>
<%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%>
</td>
<td>
<input class=InputStyle  type=file size=40 name="filename" id="filename">
</td>
</tr>
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>
<tr>
<td>
<%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%>
</td>
<TD class=Field>
         
              <INPUT class=wuiBrowser _displayText="<%=user.getUsername()%>" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name=manager value="<%=user.getUID()%>"></TD>
</tr>
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>
<TR>
<TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
<TD class=Field>
<INPUT class=wuiBrowser  _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp" name="CustomerStatus" value="1"></TD>
</TR>
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>
<!--
<tr>
<td ><a href=ExcelToDB.xls><%=SystemEnv.getHtmlLabelName(18616,user.getLanguage())%></a></td>
</tr>
<TR><TD class=Line colSpan="2"></TD></TR>
-->
<tr>
<td id="msg" align="left" colspan="2"><font  size="2" color="#FF0000">
<%

String msg=Util.null2String(request.getParameter("msg"));
String msg1=Util.null2String(request.getParameter("msg1"));
String msg2=Util.null2String(request.getParameter("msg2"));
String msg3=Util.null2String(request.getParameter("msg3"));
String msg4=Util.null2String(request.getParameter("msg4"));
int    dotindex=0;
int    cellindex=0;
int    msgsize;
int    msgEmailsize;

if (Util.null2String(request.getParameter("msgsize"))==""){
	   msgsize=0;
	}else{
	msgsize=Integer.valueOf(Util.null2String(request.getParameter("msgsize"))).intValue();
	}
if (Util.null2String(request.getParameter("msgEmailsize"))==""){
	msgEmailsize=0;
	}else{
		msgEmailsize=Integer.valueOf(Util.null2String(request.getParameter("msgEmailsize"))).intValue();
	}

if (msg.equals("success")){
msg=SystemEnv.getHtmlLabelName(18619,user.getLanguage());
}else if(msg.equals("bad")){
msg=SystemEnv.getHtmlLabelName(20040,user.getLanguage());
}else{
	
	for (int i=0;i<msgsize;i++){
		dotindex=msg1.indexOf(",");
		cellindex=msg2.indexOf(",");
		out.println(SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg1.substring(0,dotindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+msg2.substring(0,cellindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18622,user.getLanguage()));

		 msg1=msg1.substring(dotindex+1,msg1.length());
	     msg2=msg2.substring(cellindex+1,msg2.length());
	}
	for (int j=0;j<msgEmailsize;j++){
		dotindex=msg3.indexOf(",");
		cellindex=msg4.indexOf(",");
		out.println("&nbsp;"+SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg3.substring(0,dotindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+msg4.substring(0,cellindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(19777,user.getLanguage()));

		 msg3=msg3.substring(dotindex+1,msg3.length());
	     msg4=msg4.substring(cellindex+1,msg4.length());
	}

}

out.println(msg);
%></font>
</td>
</tr>

<TR>
    <TD height="15" colspan="2"></TD>
</TR>
</TBODY>
</table>


<TABLE class="viewForm">
<COLGROUP>
<COL width="50%">
<COL width="50%">
<TBODY>



<TR class=Title>
    <TH  colSpan="2"><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
</TR>
<TR class=Spacing  style="height: 1px">
    <TD class=Line1  colSpan="2"></TD>
</TR>


<%if(user.getLanguage()==8){%>
<TR>
  <TD  colspan="2">
                    <p><strong>Import Step:</strong></p>

                    <ul>
					  <li><strong>Step One,</strong><a href=ExcelToDB.xls>Download excel document mould</a> first.</li>
					  <li><strong>Step Two,</strong>After downloaded,input the content.The content should be inputed has more description.Confirm the format of your excel file has the same to the mould,and hasn't been updated.</li>
					  <li><strong>Step Three,</strong>The customer manager couldn't be selected.The default customer manager is the importer.</li>
					  <li><strong>Step Four,</strong>The status of customer could be selected.If the status hasn't been selected,the customer imported are invalid customer.</li>
					  <li><strong>Step Five,</strong>Click the 'submit' of right menu,turn to import of customer.</li>
					  <li><strong>Step Six,</strong>If upwards steps and excel file are true,the page will give the note of right,else it will give the wrong of the excel file.</li>
                    </ul> 
					
  </TD>
</TR>
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>

<TR style="height: 15px">
    <TD height="15" colspan="2"></TD>
</TR>
<TR>
  <TD   colspan="2">
                    <p><strong>Notice:</strong></p>

                    <ul>
					  <li>Customer Import don't estimate whether customer repeat.If the database has the same name customers,any note couldn't been given .</li>
					  <li>If more customers into a successful client (including the success of customers), please fill out the customer must type.</li>
					  <li>Suggest importing too much customer once,less than one hundred better. </li>
                    </ul> 
					
  </TD>
</TR>
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>

<TR style="height: 15px">
    <TD height="15" colspan="2"></TD>
</TR>
<%}else if(user.getLanguage()==9){%> 
<TR>  
   <TD colspan="2"> 
                     <p><strong>導入步驟：</strong></p> 

                     <ul> 
						<li>第一步，先<a href=ExcelToDB.xls>下載Excel文檔模版</a>。 </li> 
						<li>第二步，下載後，填寫內容，注意，要填寫的內容在下邊的說明中有詳細的說明，請一定要確定你的Excel文檔的格式是模板中的格式，而沒有被修改掉。 </li> 
						<li>第三步，選擇客戶經理，默認情況下，客戶經理是客戶導入者本人。 </li> 
						<li>第四步，可以選擇被導入的客戶的狀態，如果不進行選擇，默認情況下導入的客戶是無效客戶。 </li> 
						<li>第五步，點擊右鍵的提交，進入客戶的導入。 </li> 
						<li>第六步，如果以上步驟和Excel文件正確的話，則會被正確的導入，也會出現提示。如果有問題，則會提示Excel文件的錯誤之處。 </li> 
                     </ul> 

   </TD> 
</TR> 
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR> 

<TR style="height: 15px"> 
     <TD height="15" colspan="2"></TD> 
</TR> 
<TR> 
   <TD colspan="2"> 
                     <p><strong>注意：</strong></p> 

                     <ul> 
						<li>客戶導入不會判斷客戶是否重複，如果數據庫中有相同名字的客戶，則不會給出任何提示。 </li> 
						<li>如果導入成功客戶以上的客戶(包括成功客戶),請必須填寫客戶類型。 </li> 
						<li>建議一次性導入的客戶不要太多，控制在100以內。 </li>
                     </ul> 

   </TD> 
</TR> 
<TR  style="height: 1px"><TD class=Line colSpan="2"></TD></TR> 

<TR style="height: 15px"> 
     <TD height="15" colspan="2"></TD> 
</TR> 
<%}else{%>
<TR>
  <TD  colspan="2">
                    <p><strong>导入步骤：</strong></p>

                    <ul>
					  <li>第一步，先<a href=ExcelToDB.xls>下载Excel文档模版</a>。</li>
					  <li>第二步，下载后，填写内容，注意，要填写的内容在下边的说明中有详细的说明，请一定要确定你的Excel文档的格式是模板中的格式，而没有被修改掉。</li>
					  <li>第三步，选择客户经理，默认情况下，客户经理是客户导入者本人。</li>
					  <li>第四步，可以选择被导入的客户的状态，如果不进行选择，默认情况下导入的客户是无效客户。</li>
					  <li>第五步，点击右键的提交，进入客户的导入。</li>
					  <li>第六步，如果以上步骤和Excel文件正确的话，则会被正确的导入，也会出现提示。如果有问题，则会提示Excel文件的错误之处。</li>
                    </ul> 
					
  </TD>
</TR>
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>

<TR style="height: 15px">
    <TD height="15" colspan="2"></TD>
</TR>
<TR>
  <TD   colspan="2">
                    <p><strong>注意：</strong></p>

                    <ul>
					  <li>客户导入不会判断客户是否重复，如果数据库中有相同名字的客户，则不会给出任何提示。</li>
					  <li>如果导入成功客户以上的客户(包括成功客户),请必须填写客户类型。</li>
					  <li>建议一次性导入的客户不要太多，控制在100以内。</li>
                    </ul> 
					
  </TD>
</TR>
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>

<TR style="height: 15px">
    <TD height="15" colspan="2"></TD>
</TR>

<%}%>


<TR class=Title>
    <TH  colSpan="2"><%=SystemEnv.getHtmlLabelName(18617,user.getLanguage())%></TH>
</TR>
<TR style="height: 15px">
    <TD height="15" colspan="2"></TD>
</TR>

<TR>
  <TD   style="color:#FF0000" valign="top">
                    <p><strong><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></strong></p>

                    <ul>
					  <li><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(1998,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></li>
					  <li>EMAIL</li>
					  <li><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></li>
					   <li>
<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>（
<%
String sql_type="";
if (rs.getDBType().equals("oracle")){
sql_type="select  fullname from Crm_CustomerType where rownum<=5";
}else if (rs.getDBType().equals("db2")){
sql_type="select fullname from Crm_CustomerType fetch first 5 rows only";
}else{
sql_type="select top 5 fullname from Crm_CustomerType ";
}
rs.executeSql(sql_type);
while (rs.next()){
out.print(rs.getString(1)+"，");
}
%>
.....）
					  </li>
                    </ul> 
					
  </TD>
  <TD valign="top">
                    <p><strong><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></strong></p>
                    <ul>
					  <li><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></li>
					 

					  <li><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>（
<%
String sql_desc="";
if (rs.getDBType().equals("oracle")){
sql_desc="select  fullname from Crm_CustomerDesc where rownum<=5";
}else if (rs.getDBType().equals("db2")){
    sql_desc="select  fullname from Crm_CustomerDesc fetch first 5 rows only ";
}else{
sql_desc="select top 5 fullname from Crm_CustomerDesc ";
}
rs.executeSql(sql_desc);
while (rs.next()){
out.print(rs.getString(1)+"，");
}
%>.....）
					  </li>
					  <li><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%>（
<%
String sql_size="";
if (rs.getDBType().equals("oracle")){
sql_size="select  fullname from Crm_CustomerSize where rownum<=5";
}else if (rs.getDBType().equals("db2")){
    sql_size="select  fullname from Crm_CustomerSize fetch first 5 rows only";
}else{
sql_size="select top 5 fullname from Crm_CustomerSize ";
}
rs.executeSql(sql_size);
while (rs.next()){
out.print(rs.getString(1)+"，");
}
%>.....）
					  </li>

					  <li><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(17084,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(17085,user.getLanguage())%></li>
					  <li><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())+SystemEnv.getHtmlLabelName(620,user.getLanguage())%></li>

                    </ul>  
  </TD>
</TR>

<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>

<TR style="height: 15px">
    <TD height="15" colspan="2"></TD>
</TR>
</TBODY>
</table>

<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>

</FORM>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="2"></td>
</tr>
</table>

</body>


<script language="javascript">
function onSave(obj){
	if (cms.filename.value==""){
		alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
	}else{
		var showTableDiv  =$G('_xTable');
		var message_table_Div = document.createElement("div"); 
		message_table_Div.id="message_table_Div";
		message_table_Div.className="xTable_message";
		showTableDiv.appendChild(message_table_Div);
		var message_table_Div  = document.getElementById("message_table_Div");
		message_table_Div.style.display="inline";
		message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(18623,user.getLanguage())%>....";
		var pTop= document.body.offsetHeight/2-60;
		var pLeft= document.body.offsetWidth/2-100;
		message_table_Div.style.position="absolute";
		message_table_Div.style.posTop=pTop;
		message_table_Div.style.posLeft=pLeft;
	
		cms.submit();
		obj.disabled = true;
	}
}
</script>
