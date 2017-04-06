<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("cptdefinition:all", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
} 
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int maxDisplayorder = 0;
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(22366,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String sql = "select * from CptSearchDefinition where mouldid = -1";
rs.executeSql(sql);
ArrayList fieldnames = new ArrayList();
ArrayList isconditionstitles = new ArrayList();
ArrayList istitles = new ArrayList();
ArrayList isconditionss = new ArrayList();
ArrayList isseniorconditionss = new ArrayList();
ArrayList displayorders = new ArrayList();
while(rs.next()){
	String _fieldname = Util.null2String(rs.getString("fieldname"));
	String _isconditionstitle = Util.null2String(rs.getString("isconditionstitle"));
	String _istitle = Util.null2String(rs.getString("istitle"));
	String _isconditions = Util.null2String(rs.getString("isconditions"));
	String _isseniorconditions = Util.null2String(rs.getString("isseniorconditions"));
	String _displayorder = Util.null2String(rs.getString("displayorder"));

	fieldnames.add(_fieldname);
	isconditionstitles.add(_isconditionstitle);
	istitles.add(_istitle);
	isconditionss.add(_isconditions);
	isseniorconditionss.add(_isseniorconditions);
	if(!"".equals(_displayorder)){
		if(_displayorder.indexOf(".")>=0){
			String afterStr = _displayorder.substring(_displayorder.indexOf(".")+1);
			String beforeStr = _displayorder.substring(0,_displayorder.indexOf("."));
			if(Integer.parseInt(afterStr) == 0){
				_displayorder = _displayorder.substring(0,_displayorder.indexOf("."));
			}
			if(Float.parseFloat(_displayorder)>maxDisplayorder){
				maxDisplayorder = Integer.parseInt(beforeStr);
			}
		}else{
			if(Integer.parseInt(_displayorder)>maxDisplayorder){
				maxDisplayorder = Integer.parseInt(_displayorder);
			}
		}
	}
	displayorders.add(_displayorder);
}

String isconditionstitle = "0";
String istitle = "0";
String isconditions = "0";
String isseniorconditions = "0";
String displayorder = "";

int index = 0;

int rownum = 0;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:formreset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=frmMain name=frmMain action="CptSearchDefinitionOperation.jsp" method=post>

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

  <TABLE class="viewform" id="tab_dtl_list-1">
  
    <COLGROUP> <COL width="15%"> <COL width="25%"> <COL width="15%"> <COL width="15%"> <COL width="15%"><COL width="15%"><TBODY> 
    <TR class="Title"> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(22366,user.getLanguage())%></TH>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line1" colSpan=6 ></TD>
    </TR>
    <tr class=Header> 
      <td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
      <td>
        <input type="checkbox" name="IsconditionstitleAll"  
               onClick="if(this.checked==false){
                         document.getElementsByName('IstitleAll')[0].checked=false;
                         document.getElementsByName('IsconditionsAll')[0].checked=false;
                         document.getElementsByName('IsseniorconditionsAll')[0].checked=false;
                       };
                       onChangeIsconditionstitleAll(-1,this.checked)" >
        <%=SystemEnv.getHtmlLabelName(22390,user.getLanguage())%>
      </td>
      <td>
        <input type="checkbox" name="IstitleAll"  
               onClick="if(this.checked==true){
            	   document.getElementsByName('IsconditionstitleAll')[0].checked=(this.checked==true?true:false);
                        };
                        onChangeIstitleAll(-1,this.checked)">
        <%=SystemEnv.getHtmlLabelName(22391,user.getLanguage())%>
      </td>
      <td>
        <input type="checkbox" name="IsconditionsAll"  
               onClick="if(this.checked==true){
            	   document.getElementsByName('IsconditionstitleAll')[0].checked=(this.checked==true?true:false);
                        }else{
                        	document.getElementsByName('IsseniorconditionsAll')[0].checked=false;
				        };
                        onChangeIsconditionsAll(-1,this.checked)" >
        <%=SystemEnv.getHtmlLabelName(22392,user.getLanguage())%>
      </td>
	  <td>
        <input type="checkbox" name="IsseniorconditionsAll"  
               onClick="if(this.checked==true){
            	   document.getElementsByName('IsconditionstitleAll')[0].checked=(this.checked==true?true:false);
            	   document.getElementsByName('IsconditionsAll')[0].checked=(this.checked==true?true:false);
                        };
                        onChangeIsseniorconditionsAll(-1,this.checked)" >	  
	    <%=SystemEnv.getHtmlLabelName(22393,user.getLanguage())%>
	  </td>
      <td><%=SystemEnv.getHtmlLabelName(22394,user.getLanguage())%></td>
    </tr>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

<!-- 基本信息 begin-->    

    <!-- 资产或资料 -->

	<%
		index = fieldnames.indexOf("isdata");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(15361,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="isdata">
		 <input id="currentmax" type="hidden" value="<%=(maxDisplayorder) %>">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" disabled="true" checked>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" disabled="true" checked>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" disabled="true" checked>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" disabled="true">
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>
        
    <!-- 编号 -->
	<%
		index = fieldnames.indexOf("mark");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="mark">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 财务编号 -->
	<%
		index = fieldnames.indexOf("fnamark");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="fnamark">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 名称 -->
	<%
		index = fieldnames.indexOf("name");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="name">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 条形码 -->
	<%
		index = fieldnames.indexOf("barcode");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="barcode">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 生效日 -->
	<%
		index = fieldnames.indexOf("startdate");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="startdate">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 生效至 -->
	<%
		index = fieldnames.indexOf("enddate");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="enddate">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 使用部门 -->
	<%
		index = fieldnames.indexOf("departmentid");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="departmentid">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 使用人 -->
	<%
		index = fieldnames.indexOf("resourceid");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="resourceid">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 所属分部 -->
	<%
		index = fieldnames.indexOf("blongsubcompany");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="blongsubcompany">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 所属部门 -->
	<%
		index = fieldnames.indexOf("blongdepartment");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="blongdepartment">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 单独核算 -->
	<%
		index = fieldnames.indexOf("sptcount");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="sptcount">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 相关工作流 -->
	<%
		index = fieldnames.indexOf("relatewfid");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>
	<!-- 
	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="relatewfid">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>
	-->
<!-- 基本信息 end--> 


<!-- 其它信息 begin--> 

    <!-- 规格型号 -->
	<%
		index = fieldnames.indexOf("capitalspec");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="capitalspec">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>	

    <!-- 等级 -->
	<%
		index = fieldnames.indexOf("capitallevel");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="capitallevel">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 制造厂商 -->
	<%
		index = fieldnames.indexOf("manufacturer");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(1364,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="manufacturer">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 出厂日期 -->
	<%
		index = fieldnames.indexOf("manudate");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(1365,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="manudate">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 资产类型 -->
	<%
		index = fieldnames.indexOf("capitaltypeid");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="capitaltypeid">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 资产组 -->
	<%
		index = fieldnames.indexOf("capitalgroupid");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="capitalgroupid">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 供应商 -->
	<%
		index = fieldnames.indexOf("customerid");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="customerid">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 属性 -->
	<%
		index = fieldnames.indexOf("attribute");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="attribute">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 状态 -->
	<%
		index = fieldnames.indexOf("stateid");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="stateid">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 计量单位 -->
	<%
		index = fieldnames.indexOf("unitid");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="unitid">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 存放地点 -->
	<%
		index = fieldnames.indexOf("location");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="location">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 入库日期 -->
	<%
		index = fieldnames.indexOf("StockInDate");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="StockInDate">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 数量 -->
	<%
		index = fieldnames.indexOf("capitalnum");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="capitalnum">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 帐内或帐外 -->
	<%
		index = fieldnames.indexOf("isinner");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="isinner">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 替代 -->
	<%
		index = fieldnames.indexOf("replacecapitalid");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="replacecapitalid">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 版本 -->
	<%
		index = fieldnames.indexOf("version");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="version">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

<!-- 其它信息 end-->

<!-- 采购信息 begin-->

    <!-- 购置日期 -->
	<%
		index = fieldnames.indexOf("SelectDate");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="SelectDate">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 合同号 -->
	<%
		index = fieldnames.indexOf("contractno");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="contractno">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 币种 -->
	<%
		index = fieldnames.indexOf("currencyid");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="currencyid">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 价格 -->
	<%
		index = fieldnames.indexOf("startprice");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="startprice">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 发票号码 -->
	<%
		index = fieldnames.indexOf("Invoice");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="Invoice">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>
    

<!-- 采购信息 end-->

<!-- 折旧信息 begin-->

    <!-- 折旧年限 -->
	<%
		index = fieldnames.indexOf("depreyear");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(19598,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="depreyear">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 残值率 -->
	<%
		index = fieldnames.indexOf("deprerate");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="deprerate">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

    <!-- 领用日期 -->
	<%
		index = fieldnames.indexOf("deprestartdate");	
		if(index>-1){
			isconditionstitle = (String)isconditionstitles.get(index);
			istitle = (String)istitles.get(index);
			isconditions = (String)isconditionss.get(index);
			isseniorconditions = (String)isseniorconditionss.get(index);
			displayorder = (String)displayorders.get(index);	
		}else{
			isconditionstitle = "0";
			istitle = "0";
			isconditions = "0";
			isseniorconditions = "0";
			displayorder = "";
		}		
	%>

	<TR>
      <TD>
      	 <%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="deprestartdate">
      </TD>
      <td class=Field>
         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
      </td>
      <td class=Field>
      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
      </td>      
	  <TD class=Field>
         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>

<!-- 折旧信息 end-->

	<%
		boolean hasFF = true;
		RecordSet.executeProc("Base_FreeField_Select","cp");
		if(RecordSet.getCounts()<=0)
			hasFF = false;
		else
			RecordSet.first();

		if(hasFF)
		{
			for(int i=1;i<=5;i++)
			{//日期
				if(RecordSet.getString(i*2+1).equals("1"))
				{%>
					<%
						index = fieldnames.indexOf("datefield"+i);	
						if(index>-1){
							isconditionstitle = (String)isconditionstitles.get(index);
							istitle = (String)istitles.get(index);
							isconditions = (String)isconditionss.get(index);
							isseniorconditions = (String)isseniorconditionss.get(index);
							displayorder = (String)displayorders.get(index);	
						}else{
							isconditionstitle = "0";
							istitle = "0";
							isconditions = "0";
							isseniorconditions = "0";
							displayorder = "";
						}		
					%>
				
					<TR>
				      <TD>
				      	 <%=Util.toScreen(RecordSet.getString(i*2),user.getLanguage())%>
						 <input name="fieldname_<%=(rownum)%>" type=hidden value="datefield<%=i%>">
				      </TD>
				      <td class=Field>
				         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
				      </td>      
					  <TD class=Field>
				         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
				      </TD>
				    </TR>
				    <TR class="Spacing" style="height:1px;"> 
				      <TD class="Line" colSpan=6 ></TD>
				    </TR>
				<%}
			}
			for(int i=1;i<=5;i++)
			{//数字
				if(RecordSet.getString(i*2+11).equals("1"))
				{%>
					<%
						index = fieldnames.indexOf("numberfield"+i);	
						if(index>-1){
							isconditionstitle = (String)isconditionstitles.get(index);
							istitle = (String)istitles.get(index);
							isconditions = (String)isconditionss.get(index);
							isseniorconditions = (String)isseniorconditionss.get(index);
							displayorder = (String)displayorders.get(index);	
						}else{
							isconditionstitle = "0";
							istitle = "0";
							isconditions = "0";
							isseniorconditions = "0";
							displayorder = "";
						}		
					%>
				
					<TR>
				      <TD>
				      	 <%=Util.toScreen(RecordSet.getString(i*2+10),user.getLanguage())%>
						 <input name="fieldname_<%=(rownum)%>" type=hidden value="numberfield<%=i%>">
				      </TD>
				      <td class=Field>
				         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
				      </td>      
					  <TD class=Field>
				         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
				      </TD>
				    </TR>
				    <TR class="Spacing" style="height:1px;"> 
				      <TD class="Line" colSpan=6 ></TD>
				    </TR>
				<%}
			}
			for(int i=1;i<=5;i++)
			{//文本
				if(RecordSet.getString(i*2+21).equals("1"))
				{%>
					<%
						index = fieldnames.indexOf("textfield"+i);	
						if(index>-1){
							isconditionstitle = (String)isconditionstitles.get(index);
							istitle = (String)istitles.get(index);
							isconditions = (String)isconditionss.get(index);
							isseniorconditions = (String)isseniorconditionss.get(index);
							displayorder = (String)displayorders.get(index);	
						}else{
							isconditionstitle = "0";
							istitle = "0";
							isconditions = "0";
							isseniorconditions = "0";
							displayorder = "";
						}		
					%>
				
					<TR>
				      <TD>
				      	 <%=Util.toScreen(RecordSet.getString(i*2+20),user.getLanguage())%>
						 <input name="fieldname_<%=(rownum)%>" type=hidden value="textfield<%=i%>">
				      </TD>
				      <td class=Field>
				         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
				      </td>      
					  <TD class=Field>
				         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
				      </TD>
				    </TR>
				    <TR class="Spacing" style="height:1px;"> 
				      <TD class="Line" colSpan=6 ></TD>
				    </TR>
				<%}
			}
			for(int i=1;i<=5;i++)
			{//判断
				if(RecordSet.getString(i*2+31).equals("1"))
				{%>
					<%
						index = fieldnames.indexOf("tinyintfield"+i);	
						if(index>-1){
							isconditionstitle = (String)isconditionstitles.get(index);
							istitle = (String)istitles.get(index);
							isconditions = (String)isconditionss.get(index);
							isseniorconditions = (String)isseniorconditionss.get(index);
							displayorder = (String)displayorders.get(index);	
						}else{
							isconditionstitle = "0";
							istitle = "0";
							isconditions = "0";
							isseniorconditions = "0";
							displayorder = "";
						}		
					%>
				
					<TR>
				      <TD>
				      	 <%=Util.toScreen(RecordSet.getString(i*2+30),user.getLanguage())%>
						 <input name="fieldname_<%=(rownum)%>" type=hidden value="tinyintfield<%=i%>">
				      </TD>
				      <td class=Field>
				         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
				      </td>      
					  <TD class=Field>
				         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
				      </TD>
				    </TR>
				    <TR class="Spacing" style="height:1px;"> 
				      <TD class="Line" colSpan=6 ></TD>
				    </TR>
				<%}
			}
			for(int i=1;i<=5;i++)
			{//多文档
				if(RecordSet.getString(i*2+41).equals("1"))
				{%>
					<%
						index = fieldnames.indexOf("docff0"+i+"name");	
						if(index>-1){
							isconditionstitle = (String)isconditionstitles.get(index);
							istitle = (String)istitles.get(index);
							isconditions = (String)isconditionss.get(index);
							isseniorconditions = (String)isseniorconditionss.get(index);
							displayorder = (String)displayorders.get(index);	
						}else{
							isconditionstitle = "0";
							istitle = "0";
							isconditions = "0";
							isseniorconditions = "0";
							displayorder = "";
						}		
					%>
				
					<TR>
				      <TD>
				      	 <%=RecordSet.getString(i*2+40)%>
						 <input name="fieldname_<%=(rownum)%>" type=hidden value="docff0<%=i%>name">
				      </TD>
				      <td class=Field>
				         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
				      </td>      
					  <TD class=Field>
				         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
				      </TD>
				    </TR>
				    <TR class="Spacing" style="height:1px;"> 
				      <TD class="Line" colSpan=6 ></TD>
				    </TR>
				  <%}
			}
			for(int i=1;i<=5;i++)
			{//多部门
				if(RecordSet.getString(i*2+51).equals("1"))
				{%>
					<%
						index = fieldnames.indexOf("depff0"+i+"name");	
						if(index>-1){
							isconditionstitle = (String)isconditionstitles.get(index);
							istitle = (String)istitles.get(index);
							isconditions = (String)isconditionss.get(index);
							isseniorconditions = (String)isseniorconditionss.get(index);
							displayorder = (String)displayorders.get(index);	
						}else{
							isconditionstitle = "0";
							istitle = "0";
							isconditions = "0";
							isseniorconditions = "0";
							displayorder = "";
						}		
					%>
				
					<TR>
				      <TD>
				      	 <%=RecordSet.getString(i*2+50)%>
						 <input name="fieldname_<%=(rownum)%>" type=hidden value="depff0<%=i%>name">
				      </TD>
				      <td class=Field>
				         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
				      </td>      
					  <TD class=Field>
				         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
				      </TD>
				    </TR>
				    <TR class="Spacing" style="height:1px;"> 
				      <TD class="Line" colSpan=6 ></TD>
				    </TR>
				  <%}
			}
			for(int i=1;i<=5;i++)
			{//多客户
				if(RecordSet.getString(i*2+61).equals("1"))
				{%>
					<%
						index = fieldnames.indexOf("crmff0"+i+"name");	
						if(index>-1){
							isconditionstitle = (String)isconditionstitles.get(index);
							istitle = (String)istitles.get(index);
							isconditions = (String)isconditionss.get(index);
							isseniorconditions = (String)isseniorconditionss.get(index);
							displayorder = (String)displayorders.get(index);	
						}else{
							isconditionstitle = "0";
							istitle = "0";
							isconditions = "0";
							isseniorconditions = "0";
							displayorder = "";
						}		
					%>
				
					<TR>
				      <TD>
				      	 <%=RecordSet.getString(i*2+60)%>
						 <input name="fieldname_<%=(rownum)%>" type=hidden value="crmff0<%=i%>name">
				      </TD>
				      <td class=Field>
				         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
				      </td>      
					  <TD class=Field>
				         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
				      </TD>
				    </TR>
				    <TR class="Spacing" style="height:1px;"> 
				      <TD class="Line" colSpan=6 ></TD>
				    </TR>
				  <%}
			}
			for(int i=1;i<=5;i++)
			{//多请求
				if(RecordSet.getString(i*2+71).equals("1"))
				{%>
					<%
						index = fieldnames.indexOf("reqff0"+i+"name");	
						if(index>-1){
							isconditionstitle = (String)isconditionstitles.get(index);
							istitle = (String)istitles.get(index);
							isconditions = (String)isconditionss.get(index);
							isseniorconditions = (String)isseniorconditionss.get(index);
							displayorder = (String)displayorders.get(index);	
						}else{
							isconditionstitle = "0";
							istitle = "0";
							isconditions = "0";
							isseniorconditions = "0";
							displayorder = "";
						}		
					%>
				
					<TR>
				      <TD>
				      	 <%=RecordSet.getString(i*2+70)%>
						 <input name="fieldname_<%=(rownum)%>" type=hidden value="reqff0<%=i%>name">
				      </TD>
				      <td class=Field>
				         <input type="checkbox" name='isconditionstitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',1,this)" value="1" <%if(isconditionstitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
				      </td>
				      <td class=Field>
				      	 <input type="checkbox" name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
				      </td>
				      <td class=Field>
				         <input type="checkbox" name='isseniorconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',4,this)" value="1" <%if(isseniorconditions.equals("1")){%>checked<%}%>>
				      </td>      
					  <TD class=Field>
				         <input type="text" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 class=Inputstyle name="displayorder_<%=(rownum++)%>" size="6" onblur="checknumber(this.name)" value="<%=displayorder%>">
				      </TD>
				    </TR>
				    <TR class="Spacing" style="height:1px;"> 
				      <TD class="Line" colSpan=6 ></TD>
				    </TR>
				  <%}
			}
		}
	%>

    
<!-- 自定义信息 end-->


    </TBODY> 
  </TABLE>
		<input name="rownum" value="<%=rownum%>" type=hidden>  
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

 </form>

<script language="javascript">
function changecheck(rownum,flag,obj){
	if(flag==1){
		$GetEle("isconditionstitle_"+rownum).checked=obj.checked;
		$GetEle("istitle_"+rownum).checked=false;
		$GetEle("isconditions_"+rownum).checked=false;
		$GetEle("isseniorconditions_"+rownum).checked=false;
		$GetEle("displayorder_"+rownum).value="";
	}else if(flag==2){
		if(obj.checked==true){
			$GetEle("isconditionstitle_"+rownum).checked=obj.checked;
			$GetEle("istitle_"+rownum).checked=obj.checked;
			var currentmax = parseInt(document.getElementById("currentmax").value)+1;
			document.getElementById("currentmax").value = currentmax;
			$GetEle("displayorder_"+rownum).value=currentmax;		
		}else{
			$GetEle("istitle_"+rownum).checked=obj.checked;
			$GetEle("displayorder_"+rownum).value="";
		}
	}else if(flag==3){
		if(obj.checked==true){
			$GetEle("isconditionstitle_"+rownum).checked=obj.checked;
			$GetEle("isconditions_"+rownum).checked=obj.checked;			
		}else{
			$GetEle("isconditions_"+rownum).checked=false;
			$GetEle("isseniorconditions_"+rownum).checked=false;
		}
	}else if(flag==4){
		if(obj.checked==true){
			$GetEle("isconditionstitle_"+rownum).checked=obj.checked;
			$GetEle("isconditions_"+rownum).checked=obj.checked;
			$GetEle("isseniorconditions_"+rownum).checked=obj.checked;
		}else{
			$GetEle("isseniorconditions_"+rownum).checked=obj.checked;			
		}
	}
}
/**
控制是否全选‘使用该字段作为查询条件或列表标题’
*/
function onChangeIsconditionstitleAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	//alert(tab_id);
	var tab_name = document.getElementById(tab_id);
	//alert(tab_name);
	var row = jQuery(tab_name).children("tbody").children("tr").length;

	var rowArray = jQuery(tab_name).children("tbody").children("tr");
	//alert(row);
	for(var i=1; i<row; i++){
		var tmpTr = rowArray[i];
		
		//alert(tmpTr);
		if(tmpTr == undefined){
			continue;
		}
		//var tmpTd1 = jQuery(tmpTr).children()(1);
		var tmpTd1 = jQuery(tmpTr).children("td")[1];
		if(tmpTd1 == undefined){
			continue;
		}
		//var tmpName = jQuery(tmpTd1).children()[0].name;
		//alert(tmpName);
		
		if(jQuery(tmpTd1).children()[0].disabled == false){
			jQuery(tmpTd1).children()[0].checked = opt;
		}
		
		if(opt == false){
			var tmpTd2 = jQuery(tmpTr).children()[2];
			if(jQuery(tmpTd2).children()[0].disabled == false){
				jQuery(tmpTd2).children()[0].checked = opt;
			}

			var tmpTd3 = jQuery(tmpTr).children()[3];
			if(jQuery(tmpTd3).children()[0].disabled == false){
				jQuery(tmpTd3).children()[0].checked = opt;
			}
			
		    var tmpTd4 = jQuery(tmpTr).children()[4];
			if(jQuery(tmpTd4).children()[0].disabled == false){
				jQuery(tmpTd4).children()[0].checked = opt;
			}
			
		    var tmpTd5 = jQuery(tmpTr).children()[5];
			if(jQuery(tmpTd5).children()[0] && jQuery(tmpTd5).children()[0].disabled == false){
				jQuery(tmpTd5).children()[0].value = "";
			}
			
		}else{
		    var tmpTd5 = jQuery(tmpTr).children()[5];
		    
			if(jQuery(tmpTd5).children()[0] && jQuery(tmpTd5).children()[0].disabled == false){
				jQuery(tmpTd5).children()[0].value = "";
			}		
		}
	}
}
/**
控制是否全选‘列表标题 ’
*/
function onChangeIstitleAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = jQuery(tab_name).children("tbody").children("tr").length;
	var rowArray = jQuery(tab_name).children("tbody").children("tr");
	
	for(var i=1; i<row; i++){
		var tmpTr = rowArray[i];
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd2 = jQuery(tmpTr).children("td")[2];
		if(tmpTd2 == undefined){
			continue;
		}
		if(jQuery(tmpTd2).children()[0].disabled == false){
			jQuery(tmpTd2).children()[0].checked = opt;
		}
		if(opt == false){
			var tmpTd5 = jQuery(tmpTr).children("td")[5];
			if(jQuery(tmpTd5).children()[0] && jQuery(tmpTd5).children()[0].disabled == false){
				jQuery(tmpTd5).children()[0].value = "";
			}
		}else{
			var tmpTd1 = jQuery(tmpTr).children("td")[1];
			if(jQuery(tmpTd1).children()[0].disabled == false){
				jQuery(tmpTd1).children()[0].checked = opt;
			}
					
			var tmpTd5 = jQuery(tmpTr).children("td")[5];
			if(jQuery(tmpTd5).children()[0] && jQuery(tmpTd5).children()[0].disabled == false){
			    var currentmax = parseInt(document.getElementById("currentmax").value)+1;
			    document.getElementById("currentmax").value = currentmax;
			    //$GetEle("displayorder_"+rownum).value=currentmax;	
				jQuery(tmpTd5).children()[0].value = currentmax;
			}

		}
	}
}
/**
控制是否全选‘作为查询条件 ’
*/
function onChangeIsconditionsAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = jQuery(tab_name).children("tbody").children("tr").length;
	var rowArray = jQuery(tab_name).children("tbody").children("tr");
	for(var i=1; i<row; i++){
		var tmpTr = rowArray[i];
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd3 = jQuery(tmpTr).children("td")[3];
		if(tmpTd3 == undefined){
			continue;
		}
		if(jQuery(tmpTd3).children()[0].disabled == false){
			jQuery(tmpTd3).children()[0].checked = opt;
		}
		if(opt == true){
			var tmpTd1 = jQuery(tmpTr).children("td")[1];
			if(jQuery(tmpTd1).children()[0].disabled == false){
				jQuery(tmpTd1).children()[0].checked = opt;
			}
		}else{
		    var tmpTd4 = jQuery(tmpTr).children("td")[4];
			if(jQuery(tmpTd4).children()[0].disabled == false){
				jQuery(tmpTd4).children()[0].checked = opt;
			}
		}
		
	}
}
/**
控制是否全选‘作为高级查询条件 ’
*/
function onChangeIsseniorconditionsAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = jQuery(tab_name).children("tbody").children("tr").length;
	var rowArray = jQuery(tab_name).children("tbody").children("tr");
	for(var i=1; i<row; i++){
		var tmpTr = rowArray[i];
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd4 = jQuery(tmpTr).children("td")[4];
		if(tmpTd4 == undefined){
			continue;
		}
		if(jQuery(tmpTd4).children()[0].disabled == false){
			jQuery(tmpTd4).children()[0].checked = opt;
		}
		if(opt == true){
			var tmpTd1 = jQuery(tmpTr).children("td")[1];
			if(jQuery(tmpTd1).children()[0].disabled == false){
				jQuery(tmpTd1).children()[0].checked = opt;
			}
			var tmpTd3 = jQuery(tmpTr).children("td")[3];
			if(jQuery(tmpTd3).children()[0].disabled == false){
				jQuery(tmpTd3).children()[0].checked = opt;
			}
		}
		
	}
}
function choosetitle(rownum){
	$GetEle("isconditionstitle_"+rownum).checked=true;
	$GetEle("istitle_"+rownum).checked=true;	
}

function submitData(){
	$GetEle('frmMain').submit();	
}

function formreset() {
	document.getElementById('frmMain').reset();
}
</script>
</BODY></HTML>
