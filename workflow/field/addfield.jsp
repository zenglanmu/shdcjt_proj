<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.general.StaticObj" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs_si" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="session"/>
<jsp:useBean id="FieldManager" class="weaver.workflow.field.FieldManager" scope="session"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="fieldCommon" class="weaver.workflow.field.FieldCommon" scope="page"/><!--xwj for td3297 20051201-->

<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<%
int rowsum=0;
String type="";
String type2="";
	String fieldname="";
	String fielddbtype="";
	String description="";//xwj for td2977 20051107
	int textheight=4;//xwj for @td2977 20051107
	String fieldhtmltype="";
	int htmltypeid=0;
    int subCompanyId2 = -1;
	String textlength="";
	int childfieldid = 0;
    String imgwidth="100";
    String imgheight="100";
	String childfieldname = "";
	int fieldid=0;
	fieldid=Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);
	int isdetail = 0;
	Hashtable selectitem_sh = new Hashtable();
	int decimaldigits = 2;
	String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
	/* -------------- xwj for td2977 20051107 begin-------------------*/
  // delete by xwj for td3297 20051201
	/* -------------- xwj for td2977 20051107 end-------------------*/

  //add by xhheng @ 20041213 for TDID 1230
  String isused="";
  isused=Util.null2String(request.getParameter("isused"));

	String message = Util.null2String(request.getParameter("message"));

	type = Util.null2String(request.getParameter("src"));
	type2 = Util.null2String(request.getParameter("srcType"));

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){
        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FieldManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FieldManage:All", user))
            operatelevel=2;
    }

    subCompanyId2 = subCompanyId ;

	if(type=="")
		type = "addfield";
	if(!type.equals("addfield"))
	{
		FieldManager.setFieldid(fieldid);
        if(type2.equals("mainfield")){
		    FieldManager.getFieldInfo();
        }else if(type2.equals("detailfield")){
		    FieldManager.getDetailFieldInfo();
        }
		fieldname=FieldManager.getFieldname();
		fielddbtype=FieldManager.getFielddbtype();
		fieldhtmltype=FieldManager.getFieldhtmltype();
		htmltypeid=FieldManager.getType();
		subCompanyId2 =FieldManager.getSubCompanyId2() ;
		description = FieldManager.getDescription();//xwj for td2977 20051107
		textheight = FieldManager.getTextheight();//xwj for @td2977 20051107
		childfieldid = FieldManager.getChildfieldid();
        imgwidth = ""+FieldManager.getImgwidth();
        imgheight = ""+FieldManager.getImgheight();
		if(fieldhtmltype.equals("1")&&htmltypeid==1){
            if(RecordSet.getDBType().equals("oracle")){
			    textlength=fielddbtype.substring(9,fielddbtype.length()-1);
            }else{
                textlength=fielddbtype.substring(8,fielddbtype.length()-1);
            }
        }else if(fieldhtmltype.equals("1") && htmltypeid==3){//浮点数字段，增加小数位数设置
        	int digitsIndex = fielddbtype.indexOf(",");
        	if(digitsIndex > -1){
        		decimaldigits = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
        	}else{
        		decimaldigits = 2;
        	}
        }
	}
	if(type2.equals("mainfield")){
		isdetail = 0;
	}else{
		isdetail = 1;
	}
//added by pony on 2006-06-13
  String maincategory = "";
  String subcategory= "";
  String seccategory= "";
  String docPath = "";
//added end.

String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

if(fieldid!=0 && childfieldid!=0){
	if(isdetail == 0){
		rs_si.execute("select fieldname, description from workflow_formdict where id="+childfieldid);
	}else{
		rs_si.execute("select fieldname, description from workflow_formdictdetail where id="+childfieldid);
	}
	if(rs_si.next()){
		childfieldname = Util.null2String(rs_si.getString("fieldname"));
		String description_tmp = Util.null2String(rs_si.getString("description")).trim();
		if(!"".equals(description_tmp)){
			childfieldname = description_tmp;
		}
	}
	
	rs_si.execute("select id, selectvalue, selectname from workflow_SelectItem where isbill=0 and fieldid="+childfieldid);
	while(rs_si.next()){
		int selectvalue_tmp = Util.getIntValue(rs_si.getString("selectvalue"), 0);
		String selectname_tmp = Util.null2String(rs_si.getString("selectname"));
		selectitem_sh.put("si_"+selectvalue_tmp, selectname_tmp);
	}
}

if(type.equals("addfield")){
    if(type2.equals("mainfield")){
        titlename+=SystemEnv.getHtmlLabelName(82,user.getLanguage())+":";
        titlename+=SystemEnv.getHtmlLabelName(6074,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }else{
        titlename+=SystemEnv.getHtmlLabelName(82,user.getLanguage())+":";
        titlename+=SystemEnv.getHtmlLabelName(17463,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }
}else{
    if(type2.equals("mainfield")){
        titlename+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+":";
        titlename+=SystemEnv.getHtmlLabelName(6074,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }else{
        titlename+=SystemEnv.getHtmlLabelName(93,user.getLanguage())+":";
        titlename+=SystemEnv.getHtmlLabelName(17463,user.getLanguage());
        titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());
    }
}

int count_fields = 0;
if(type2.equals("mainfield")){
    RecordSet.executeSql("select count(*) as fieldcount from workflow_formdict");
    if(RecordSet.next()) count_fields = Util.getIntValue(Util.null2String(RecordSet.getString("fieldcount")),0);
}else{
    RecordSet.executeSql("select count(*) as fieldcount from workflow_formdictdetail");
    if(RecordSet.next()) count_fields = Util.getIntValue(Util.null2String(RecordSet.getString("fieldcount")),0);
}
//out.println("count_fields=="+count_fields);

String texttype="htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(608,user.getLanguage())+"',1);"+"\n"+
		"htmltypelist.options[1]=new Option('"+SystemEnv.getHtmlLabelName(696,user.getLanguage())+"',2);"+"\n"+
		"htmltypelist.options[2]=new Option('"+SystemEnv.getHtmlLabelName(697,user.getLanguage())+"',3);"+"\n"+
		"htmltypelist.options[3]=new Option('"+SystemEnv.getHtmlLabelName(18004,user.getLanguage())+"',4);"+"\n"+//xwj for td3131 20051117
		"htmltypelist.options[4]=new Option('"+SystemEnv.getHtmlLabelName(22395,user.getLanguage())+"',5);"+"\n";
String specialtype="htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(21692,user.getLanguage())+"',1);"+"\n"+
		"htmltypelist.options[1]=new Option('"+SystemEnv.getHtmlLabelName(21693,user.getLanguage())+"',2);"+"\n";
String browsertype="";
String browserlabelid="";
int i=0;
while(BrowserComInfo.next()){
		if(BrowserComInfo.getBrowserurl().equals("")){ continue;}
     	 if("1".equals(IsOpetype)&&("224".equals(BrowserComInfo.getBrowserid()))||"225".equals(BrowserComInfo.getBrowserid())){
                 		 	//存在新的，就不能建老的sap
 				 		continue;
 		}
 		 if("0".equals(IsOpetype)&&("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())){
                 		 	//存在老的，就不能建新的sap
 				 		continue;
 		}
	browsertype+="htmltypelist.options["+i+"]=new Option('"+
		SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())+
		"',"+BrowserComInfo.getBrowserid()+");"+"\n";
	i++;
}
BrowserComInfo.setToFirstrow();

%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>





<% boolean tof = true;
if(operatelevel>0){ tof = false;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
%>
<%
String fieldhtmltypeForSearch = Util.null2String(request.getParameter("fieldhtmltypeForSearch"));
String temptype = Util.null2String(request.getParameter("type"));
String type1 = Util.null2String(request.getParameter("type1"));
String fieldnameForSearch = Util.null2String(request.getParameter("fieldnameForSearch"));
String fielddec = Util.null2String(request.getParameter("fielddec"));
if(detachable==1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='/workflow/field/managefield.jsp?subCompanyId="+subCompanyId2+"&srcType="+type2+"&fieldnameForSearch="+fieldnameForSearch+"&fielddec="+fielddec+"&fieldhtmltypeForSearch="+fieldhtmltypeForSearch+"&type="+temptype+"&type1="+type1+"',_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(-1),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="form1" method="post" action="field_operation.jsp" >
   <input type="hidden" value="<%=type%>" name="src">
   <input type="hidden" value="<%=type2%>" name="srcType">
   <input type="hidden" value="<%=fieldid%>" name="fieldid">
   <!-- modify by xhheng @ 20041222 for TDID 1230-->
   <input type="hidden" value="<%=isused%>" name="isused">
   <%
  if(!type.equals("addfield"))
	{
	if("2".equals(fieldhtmltype) || "4".equals(fieldhtmltype) || "5".equals(fieldhtmltype) || "7".equals(fieldhtmltype)){%>
<%if(isused.equals("true")){%>	 <input type="hidden" value="<%=htmltypeid%>" name="htmltype"> <%}%>
	<%}

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

   <table class="viewform">
   <COLGROUP>
   <COL width="10%">
   <COL width="15%">
   <COL width="25%">
   <COL width="50%">
   <TR class="Title">
    	  <TH colSpan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>
          <%
              String tmpStr = "";
if(message.equals("1")){
    tmpStr = "<font color=red>"+SystemEnv.getHtmlLabelName(15440,user.getLanguage())+"!</font>";
}else if(message.equals("2")){
    tmpStr = "<font color=red>此操作不能执行!</font>";
}
          %>
          <%=tmpStr%>
          </TH></TR>
    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=6></TD></TR>

  <tr>
    <td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
    <%if(operatelevel>0){%>
    <td class=field colspan=3>
    <%if(isused.equals("true")){%>
    <input type="hidden" value="<%=Util.toScreenToEdit(fieldname,user.getLanguage())%>" name="fieldname">
    <%=Util.toScreenToEdit(fieldname,user.getLanguage())%>
    <%}else{%>
    <input class=Inputstyle type="text" name="fieldname" size="40" maxlength="30" value="<%=Util.toScreenToEdit(fieldname,user.getLanguage())%>"	onBlur='checkinput_char_num("fieldname");checkinput("fieldname","fieldnamespan");checkSystemField("fieldname","fieldnamespan","<%=type2%>")'>
    <span id=fieldnamespan><%if(fieldname.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span><span class=fontred>&nbsp&nbsp<br>
    	<%=SystemEnv.getHtmlLabelName(15441,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(19881,user.getLanguage())%>,
    	<%if(type2.equals("detailfield")){%><%=SystemEnv.getHtmlLabelName(21764,user.getLanguage())%>
    	<%}else{%><%=SystemEnv.getHtmlLabelName(21763,user.getLanguage())%><%}%>
    </span>
    <%}%>
    </td>
    <%} else {%>
    <td class=field colspan=5><%=Util.toScreen(fieldname,user.getLanguage())%></td><%}%>
  </tr>
<tr class="Spacing" style="height:1px;">
	<td colspan="6" class="Line"></td>
</tr>

  <!--xwj for td2977 20051107 begin-->
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
    <%if(operatelevel>0){%>
    <td class=field colspan=3><input class=Inputstyle type="text" name="description" size="40" value="<%=description%>"></td>
    <%} else {%>
    <td class=field colspan=5><%=Util.toScreen(description,user.getLanguage())%></td><%}%>
  </tr>
<tr class="Spacing" style="height:1px;">
	<td colspan="6" class="Line"></td>
</tr>
<!--xwj for td2977 20051107 end-->

  <tr>
    <td><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></td>
    <td class=field>
    <%if(operatelevel>0){%>
    <!-- modify by xhheng @ 20041222 for TDID 1230-->
    <%if(isused.equals("true")){%>
      <input type="hidden" value="<%=fieldhtmltype%>" name="fieldhtmltype">
      <select class=inputstyle  size="1" name="fieldhtmltype" onChange="showType()" disabled>
    <%}else{%>
      <select class=inputstyle  size="1" name="fieldhtmltype" onChange="showType()" >
    <%}%>
    <option value="1" <%if(fieldhtmltype.equals("1")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
    <option value="2" <%if(fieldhtmltype.equals("2")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
    <option value="3" <%if(fieldhtmltype.equals("3")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
    <option value="4" <%if(fieldhtmltype.equals("4")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
    <option value="5" <%if(fieldhtmltype.equals("5")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
    <!-- add by xhheng @20050309 for 附件上传 -->
    <%if(type2.equals("mainfield")){%>
    <option value="6" <%if(fieldhtmltype.equals("6")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
    <option value="7" <%if(fieldhtmltype.equals("7")){%> selected<%}%>>
    	<%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%></option>
    <%}%>
    </select>
    </td>
    	<%if(fieldhtmltype.equals("")){ %>
    	  <td class=field>
    	    <button type=button class=btn id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()"><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
  	   		<button type=button class=btn id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()"><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
    	     <span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
    	     <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
    	     	<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
    	     	<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
    	     	<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
    	     	<option value="4"><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option><!--xwj for td3131 20051115-->
    	     	<option value="5"><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
    	     </select>
    	     <input type="text" value="<%=textheight%>" name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
    	  </td>
    	  <td class=field>
    	     <span id=lengthspan><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
			  <input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	     <input class=Inputstyle type=input size=10 maxlength=3 name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
    	     	
    	    <!-- zzl--start -->
    	    		 <button type="button" style="display:none" class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner"></span>
    	    		 <span id="showimg" style="display:none">
    	    		  	 <IMG src="/images/BacoError.gif" align=absMiddle>
    	    		 </span>
    	    		 <input type="hidden" name="showvalue" id="showvalue">
    	    <!-- zzl--end -->
    	    
			<!-- sap browser -->
			 <select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
			 <option value=""></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
    	     <span id=strlengthspan><%if(textlength.equals("")||textlength.equals("0")){%>
    	     <IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
			<span id="decimaldigitsspan" style="display:none">
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
				<select id="decimaldigits" name="decimaldigits">
					<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
					<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
					<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
					<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
				</select>
			</span>
    	     <select style="display:none" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
    	     
             <span id=showprepspan style="display:none" ><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%></span>
             <select style="display:none" class=inputstyle  name=showprep id=showprep onChange="typeChange()" >
                 <option value='1' selected><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
                 <option value='2' ><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
             </select>
              <span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
    	   	<span id=imgwidthspan style="display:none"></span>
               <span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
    	   	<span id=imgheightspan style="display:none"></span>
				<span id="childfieldNotesSpan" style="display:none"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<button type=button id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')" style="display:none"></BUTTON>
				<span id="childfieldidSpan" style="display:none"></span>
				<input type="hidden" value="" name="childfieldid" id="childfieldid">
          </td>
    	<%}
    	if(fieldhtmltype.equals("1")){ %>
    	   <td class=field>
    	     <button type=button class=btn id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()"><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
  	   		 <button type=button class=btn id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()"><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
    	     <span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
    	     <input type="text" name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
          <!-- modify by xhheng @ 20041222 for TDID 1230-->
          <!-- 单行文本框，在类型 整形、浮点型向文本的转换会出现数据库异常，故禁止转换-->
          <%if(isused.equals("true")){%>
            <input type="hidden" value="<%=htmltypeid%>" name="htmltype">
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()" disabled>
          <%}else{%>
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
          <%}%>
    	     	<option value="1" <%if(htmltypeid==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
    	     	<option value="2" <%if(htmltypeid==2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
    	     	<option value="3" <%if(htmltypeid==3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
    	     	<option value="4" <%if(htmltypeid==4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option><!--xwj for td3131 20051115-->
    	     	<option value="5" <%if(htmltypeid==5){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
    	     </select>
    	   </td>
    	  <%if(htmltypeid==1){%>
    	   <td class=field>
    	     <span id=lengthspan><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%></span>
			<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	     <input class=Inputstyle type=input size=10 maxlength=3 name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
    	     
    	    <!-- zzl--start -->
    	    		<!-- 其他按钮修改成本按钮时显示的img -->
    	    		 <button type="button" style="display:none" class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner"></span>
    	    		 <span id="showimg">
    	    		 </span>
    	    		 <input type="hidden" name="showvalue" id="showvalue">
    	    <!-- zzl--end -->
    	    
			<!-- sap browser -->
			 <select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
			 <option value=""></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
    	     <span id=strlengthspan><%if(textlength.equals("")||textlength.equals("0")){%>
    	     <IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
    	     <select style="display:none" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
			 <span id="decimaldigitsspan" style="display:none">
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
			<%if(isused.equals("true")){%>
				<input type="hidden" id="decimaldigits" name="decimaldigits" value="<%=decimaldigits%>">
				<select id="decimaldigitshidden" name="decimaldigitshidden" size="1" disabled>
			<%}else{%>
				<select id="decimaldigits" name="decimaldigits" size="1">
			<%}%>
					<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
					<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
					<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
					<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
				</select>
			</span>
    	  <%}else if(htmltypeid==3){
    		  %>
		<td class=field>
			<span id="lengthspan"></span>
			<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	     <input type=input  class=Inputstyle style=display:none size=10 maxlength=3 name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
    	    
    	     <!-- zzl--start -->
    	    		 <button type="button" style="display:none" class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner"></span>
    	    		 <span id="showimg" style="display:none">
    	    		  	 <IMG src="/images/BacoError.gif" align=absMiddle>
    	    		 </span>
    	    		 <input type="hidden" name="showvalue" id="showvalue">
    	    <!-- zzl--end -->
    	    
			<!-- sap browser -->
			 <select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
			 <option value=""></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
    	     <span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	     <IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
    	     <select style="display:none" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
    	     
			<span id="decimaldigitsspan" style="display:">
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
			<%if(isused.equals("true")){%>
				<input type="hidden" id="decimaldigits" name="decimaldigits" value="<%=decimaldigits%>">
				<select id="decimaldigitshidden" name="decimaldigitshidden" size="1" disabled>
			<%}else{%>
				<select id="decimaldigits" name="decimaldigits" size="1">
			<%}%>
					<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
					<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
					<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
					<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
				</select>
			</span>
    		  <%
    	  } else {%>
    	   <td class=field><span id=lengthspan></span>
					<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	     <input type=input  class=Inputstyle style=display:none size=10 maxlength=3 name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
    	     
    	      <!-- zzl--start -->
    	    		 <button type="button" style="display:none" class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner"></span>
    	    		 <span id="showimg" style="display:none">
    	    		  	 <IMG src="/images/BacoError.gif" align=absMiddle>
    	    		 </span>
    	    		 <input type="hidden" name="showvalue" id="showvalue">
    	    <!-- zzl--end -->
    	    
			<!-- sap browser -->
			 <select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
			 <option value=""></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
    	     <span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	     <IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
    	     <select style="display:none" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
    	     
    	   <%}%>
        <span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
    	   	<span id=imgwidthspan style="display:none"></span>
               <span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
    	   	<span id=imgheightspan style="display:none"></span>
				<span id="childfieldNotesSpan" style="display:none"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<button type=button id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')" style="display:none"></BUTTON>
				<span id="childfieldidSpan" style="display:none"></span>
				<input type="hidden" value="" name="childfieldid" id="childfieldid">
    	     <select style="display:none" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
    	      <!-- zzl--start -->
    	    		 <button type="button" <%if(htmltypeid!=226&&htmltypeid!=227){%>style="display:none"<%}%> class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner"></span>
    	    		 <span id="showimg" style="display:none">
    	    		  	 <IMG src="/images/BacoError.gif" align=absMiddle>
    	    		 </span>
    	    		 <input type="hidden" name="showvalue" id="showvalue">
    	    <!-- zzl--end -->
    	    
			<!-- sap browser -->
			 <select <%if(htmltypeid!=224&&htmltypeid!=225){%>style="display:none"<%}%> class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()"  <%if(isused.equals("true")){%>disabled<%}%>>
			 <option value=''></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
			</td>
    	<%}
    	if(fieldhtmltype.equals("3")){ %>
    	   <td class=field>
    	    <button type=button class=btn id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()"><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
  	   		<button type=button class=btn id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()"><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
    	     <span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
    	     <input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
           <!-- modify by xhheng @ 20041222 for TDID 1230 start-->
           <!-- 因为浏览按钮随类型不同而采用不同的数据类型，故已使用后，其类型也禁止转换-->
          <%String browserid="";%>
          <%if(isused.equals("true")){%>
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()" disabled>
          <%}else{%>
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
          <%}%>
    	     <%while(BrowserComInfo.next()){
    	     		 	 if("1".equals(IsOpetype)&&("224".equals(BrowserComInfo.getBrowserid()))||"225".equals(BrowserComInfo.getBrowserid())){
			                   		 	//存在新的，就不能建老的sap
				  				 		continue;
				  		}
				  		 if("0".equals(IsOpetype)&&("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())){
	                 		 	//存在老的，就不能建新的sap
	 				 			continue;
 						}
    	     %>
    	     	<option value="<%=BrowserComInfo.getBrowserid()%>" <%if(BrowserComInfo.getBrowserid().equals(htmltypeid+"")){%> selected <%}%>>
    	     		<%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
              <%if(BrowserComInfo.getBrowserid().equals(htmltypeid+"") && isused.equals("true")) {
                browserid=BrowserComInfo.getBrowserid();
              }%>
    	     <%}%>
           <%if(isused.equals("true")){%>
            <input type="hidden" value="<%=browserid%>" name="htmltype">
           <%}%>
           <!-- modify by xhheng @ 20041222 for TDID 1230 end-->
    	     </select>
    	   </td>
    	   <td class=field><span id=lengthspan></span>
			 <input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	     <input  class=Inputstyle type=input style=display:none size=10 maxlength=3 name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
    	     
    	    <!-- zzl--start -->
    	    <!-- 可编辑下的情况 -->
    	    		 <button type="button" <%if(htmltypeid!=226&&htmltypeid!=227){%>style="display:none"<%}%> class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner" ><%if(htmltypeid==226||htmltypeid==227){out.print(fielddbtype);	}%></span>
    	    		 <span id="showimg" style="display:none">
    	    		 		<%
	    	    		 		if(htmltypeid!=226&&htmltypeid!=227){
	    	    		 			out.println("<IMG src='/images/BacoError.gif' align=absMiddle>");	
	    	    				 }
    	    				%>
    	    		 </span>
    	    		 <input type="hidden"  <%if(htmltypeid!=226&&htmltypeid!=227){%>style="display:none"<%}%> name="showvalue" id="showvalue"   value="<%if(htmltypeid==226||htmltypeid==227){out.println(fielddbtype);}%>">
    	    <!-- zzl--end -->   
			<!-- sap browser -->
			 <select <%if(htmltypeid!=224&&htmltypeid!=225){%>style="display:none"<%}%> class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()"  <%if(isused.equals("true")){%>disabled<%}%>>
			 <option value=''></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
    	     <span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	     <IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
			<span id="decimaldigitsspan" style="display:none">
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
				<select id="decimaldigits" name="decimaldigits">
					<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
					<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
					<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
					<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
				</select>
			</span>
			 <select <%if(htmltypeid!=161&&htmltypeid!=162){%>style="display:none"<%}%> class=inputstyle  name=cusb id=cusb onChange="typeChange()"  <%if(isused.equals("true")){%>disabled<%}%>>
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%> <%if(fielddbtype.equals(l.get(j))){%>selected<%}%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
			 <span id=showprepspan <%if(htmltypeid!=165&&htmltypeid!=166&&htmltypeid!=167&&htmltypeid!=168){%>style="display:none"<%}%> ><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%></span>
             <select <%if(htmltypeid!=165&&htmltypeid!=166&&htmltypeid!=167&&htmltypeid!=168){%>style="display:none"<%}%> class=inputstyle  name=showprep id=showprep onChange="typeChange()" >
                 <option value='1' <%if(textheight==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
                 <option value='2' <%if(textheight==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
             </select>
             <%if(isused.equals("true")){%>
            <input type="hidden" value="<%=fielddbtype%>" name="cusb">
            <input type="hidden" value="<%=fielddbtype%>" name="sapbrowser">
            <input type="hidden" value="<%=fielddbtype%>" name="newsapbrowser">
           <%}%>
               <span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
    	   	<span id=imgwidthspan style="display:none"></span>
               <span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
    	   	<span id=imgheightspan style="display:none"></span>
				<span id="childfieldNotesSpan" style="display:none"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<button type=button id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')" style="display:none"></BUTTON>
				<span id="childfieldidSpan" style="display:none"></span>
				<input type="hidden" value="" name="childfieldid" id="childfieldid">
			 </td>
    	<%}
      if(fieldhtmltype.equals("4")){//xwj for @td2977 begin%>
      		<button type=button class=btn id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()"><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
  	   	    <button type=button class=btn id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()"><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
    	   <td class=field><span id=typespan></span>
    	   <select class=inputstyle  style=display:none size=1 name=htmltype id=selecthtmltype onChange="typeChange()"></select>
    	   </td>
    	   <td class=field><span id=lengthspan></span>
				<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	   	<input  class=Inputstyle type=input style=display:none size=10 maxlength=3 name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
    	     
    	    <!-- zzl--start -->
    	    		 <button type="button" style="display:none" class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner" style="display:none"></span>
    	    		 <span id="showimg">
    	    		  	 <IMG src="/images/BacoError.gif" align=absMiddle>
    	    		 </span>
    	    		 <input type="hidden" name="showvalue" id="showvalue">
    	    <!-- zzl--end -->  
    	    
			<!-- sap browser -->
			 <select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
			 <option value=""></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
    	   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	        <IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
			<span id="decimaldigitsspan" style="display:none">
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
				<select id="decimaldigits" name="decimaldigits">
					<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
					<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
					<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
					<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
				</select>
			</span>
               <span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
    	   	<span id=imgwidthspan style="display:none"></span>
               <span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
    	   	<span id=imgheightspan style="display:none"></span>
				<span id="childfieldNotesSpan" style="display:none"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<button type=button id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')" style="display:none"></BUTTON>
				<span id="childfieldidSpan" style="display:none"></span>
				<input type="hidden" value="" name="childfieldid" id="childfieldid">
    	     <select style="display:none" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
    	   </td>
    	   <input type="text" name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
    	<%}

    		/*-- xwj for @td2977 begin--- */
    	if(fieldhtmltype.equals("2")){ %>
    	   <td class=field>
    	   <button type=button class=btn id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()"><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
  	   		<button type=button class=btn id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()"><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
    	   <span id=typespan><%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%></span>
    	     <select class=inputstyle  size=1 name=htmltype id=selecthtmltype style="display:none" onChange="typeChange()">
			<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
			<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
			<option value="4"><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option><!--xwj for td3131 20051115-->
			<option value="5"><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
		     </select>
    	     <input type="text" value="<%=textheight%>" name="textheight" maxlength=2 size=4 onblur="checkPlusnumber1(this)" onKeyPress="ItemPlusCount_KeyPress()" class=Inputstyle>
        </td>

    	   <td class=field><span id=lengthspan><%=SystemEnv.getHtmlLabelName(222,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%></span>
    	   
    	   <%-- 由于多行文本框的html模式选中之后，就不能再对其进行编辑，故作此修改。 --%>
           <input type='checkbox' name="htmledit" <%if (htmltypeid==2) {%> checked <%}%> value="2" disabled  onclick="onfirmhtml()">
    	   	<input  class=Inputstyle type=input style=display:none size=10 maxlength=3 name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
    	    <!-- zzl--start -->
    	    		 <button type="button" style="display:none" class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner"></span>
    	    		 <span id="showimg">
    	    		  	 <IMG src="/images/BacoError.gif" align=absMiddle>
    	    		 </span>
    	    		 <input type="hidden" name="showvalue" id="showvalue">
    	    <!-- zzl--end -->  
			<!-- sap browser -->
			 <select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
			 <option value=""></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
    	   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	        <IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
			<span id="decimaldigitsspan" style="display:none">
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
				<select id="decimaldigits" name="decimaldigits">
					<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
					<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
					<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
					<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
				</select>
			</span>
               <span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
    	   	<span id=imgwidthspan style="display:none"></span>
               <span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
    	   	<span id=imgheightspan style="display:none"></span>
				<span id="childfieldNotesSpan" style="display:none"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<button type=button id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')" style="display:none"></BUTTON>
				<span id="childfieldidSpan" style="display:none"></span>
				<input type="hidden" value="" name="childfieldid" id="childfieldid">
    	     <select style="display:none" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
    	   </td>
    	<%}
    	/*-- xwj for @td2977 end--- */

    	if(fieldhtmltype.equals("5")){ %>
    	   <td class=field>
    	   <button type=button class=btn id=btnaddRow style="display:''" name=btnaddRow onclick="addRow()"><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
  	   		<button type=button class=btn id=btnsubmitClear style="display:''" name=btnsubmitClear onclick="submitClear()"><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
    	   <span id=typespan></span>
    	   <select class=inputstyle  style=display:none size=1 id=selecthtmltype name=htmltype onChange="typeChange()">
    	   <option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
			<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
			<option value="4"><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
			<option value="5"><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
    	   </select>
    	   <input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
		   </td>
    	   <td class=field><span id=lengthspan></span>
			<input type='checkbox' name="htmledit" style="display:none"  value="2">
    	   	<input   type=input class="InputStyle" style=display:none size=10 maxlength=3 name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
    	    
    	    <!-- zzl--start -->
    	    		 <button type="button" style="display:none" class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner"></span>
    	    		 <span id="showimg" style="display:none">
    	    		  	 <IMG src="/images/BacoError.gif" align=absMiddle>
    	    		 </span>
    	    		 <input type="hidden" name="showvalue" id="showvalue">
    	    <!-- zzl--end -->  
    	    
			<!-- sap browser -->
			 <select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
			 <option value=""></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
    	   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	        <IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
			<span id="decimaldigitsspan" style="display:none">
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
				<select id="decimaldigits" name="decimaldigits">
					<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
					<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
					<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
					<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
				</select>
			</span>
               <span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
    	   	<span id=imgwidthspan style="display:none"></span>
               <span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
    	   	<span id=imgheightspan style="display:none"></span>
				<span id="childfieldNotesSpan"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<button type=button id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')" ></BUTTON>
				<span id="childfieldidSpan" ><%=childfieldname%></span>
				<input type="hidden" value="<%=childfieldid%>" name="childfieldid" id="childfieldid">
    	     <select style="display:none" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
    	   </td>
    	<%}
    	if(fieldhtmltype.equals("6")){
        String displaystr="display:none";
        if(htmltypeid==2) displaystr="display:''";
        %>
    	  <td class=field>
    	   <button type=button class=btn id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()"><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
  	   		<button type=button class=btn id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()"><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
    	   <span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
           <%if(isused.equals("true")){%>
            <input type="hidden" value="<%=htmltypeid%>" name="htmltype">
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()" disabled>
          <%}else{%>
            <select class=inputstyle  size=1 name=htmltype id=selecthtmltype onChange="typeChange()">
          <%}%>
            <option value="1" <%if(htmltypeid==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
			<option value="2" <%if(htmltypeid==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
    	   </select>
    	   <input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none><!--xwj for @td2977 20051110 -->
		   </td>
    	   <td class=field><span id=lengthspan style="<%=displaystr%>"><%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%></span>
			<input type='checkbox' name="htmledit" style="display:none"  value="2" onclick="onfirmhtml()">
    	   	<input   type=input class="InputStyle" size=10 maxlength=3 name="strlength"
    	     	onKeyPress="ItemPlusCount_KeyPress()" onBlur="checkPlusnumber1(this)" value="<%=textheight%>" style="<%=displaystr%>">
    	     
    	     <!-- zzl--start -->
    	    		 <button type="button" style="display:none" class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner"></span>
    	    		 <span id="showimg"></span>
    	    		 <input type="hidden" name="showvalue" id="showvalue">
    	    <!-- zzl--end -->  
    	    
			<!-- sap browser -->
			 <select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
			 <option value=""></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
    	   	<span id=strlengthspan ></span>
			<span id="decimaldigitsspan" style="display:none">
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
				<select id="decimaldigits" name="decimaldigits">
					<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
					<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
					<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
					<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
				</select>
			</span>
            <span id=imgwidthnamespan style="<%=displaystr%>"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth"
    	     	onKeyPress="ItemPlusCount_KeyPress()" onBlur="checkPlusnumber1(this)" value="<%=imgwidth%>" style="<%=displaystr%>">
    	   	<span id=imgwidthspan style="<%=displaystr%>"></span>
               <span id=imgheightnamespan style="<%=displaystr%>"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight"
    	     	onKeyPress="ItemPlusCount_KeyPress()" onBlur="checkPlusnumber1(this)" value="<%=imgheight%>" style="<%=displaystr%>">
    	   	<span id=imgheightspan style="<%=displaystr%>"></span>
				<span id="childfieldNotesSpan" style="display:none"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<button type=button id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')" style="display:none"></BUTTON>
				<span id="childfieldidSpan" style="display:none"></span>
				<input type="hidden" value="" name="childfieldid" id="childfieldid">
    	     <select style="display:none" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
    	   </td>
    	<%}
    	if(fieldhtmltype.equals("7")){ %>
    	   <td class=field>
    	   <button type=button class=btn id=btnaddRow style="display:none" name=btnaddRow onclick="addRow()"><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
  	   		<button type=button class=btn id=btnsubmitClear style="display:none" name=btnsubmitClear onclick="submitClear()"><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
    	   <span id=typespan><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
    	   <select class=inputstyle  style=display:'' size=1 id=selecthtmltype name=htmltype onChange="typeChange()" <%if(isused.equals("true")){%>disabled<%}%>>
    	    <option value="1" <%if(htmltypeid==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
			<option value="2" <%if(htmltypeid==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
    	   </select>
    	   <input type="text"  name="textheight" maxlength=2 size=4 onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)" class=Inputstyle style=display:none>
		   </td>
    	   <td class=field><span id=lengthspan></span>
			<input type='checkbox' name="htmledit" style="display:none"  value="2">
    	   	<input   type=input class="InputStyle" style=display:none size=10 maxlength=3 name="strlength" onBlur="checkPlusnumber1(this);checklength('strlength','strlengthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=textlength%>">
    	     	
    	    <!-- zzl--start -->
    	    	
    	    		 <button type="button" style="display:none"  class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
    	    		 <span id="showinner"></span>
    	    		 <span id="showimg" style="display:none" >
    	    		  	 <IMG src="/images/BacoError.gif" align=absMiddle>
    	    		 </span>
    	    		 <input type="hidden" name="showvalue" id="showvalue">
    	    <!-- zzl--end -->
			<!-- sap browser -->
			 <select style="display:none" class=inputstyle  name=sapbrowser id=sapbrowser onChange="typeChange()" >
			 <option value=""></option>
    	     	<%

                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                 //System.out.println(AllBrowserId.size());
	             for(int j=0;j<AllBrowserId.size();j++){
                %>
                <option value=<%=AllBrowserId.get(j)%> <%if(fielddbtype.equals(AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
                 <%}%>
    	     </select>
    	   	<span id=strlengthspan style=display:none><%if(textlength.equals("")||textlength.equals("0")){%>
    	        <IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
			<span id="decimaldigitsspan" style="display:none">
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
				<select id="decimaldigits" name="decimaldigits">
					<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
					<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
					<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
					<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
				</select>
			</span>
               <span id=imgwidthnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" onBlur="checkPlusnumber1(this);checklength('imgwidth','imgwidthspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgwidth%>" style="display:none">
    	   	<span id=imgwidthspan style="display:none"></span>
               <span id=imgheightnamespan style="display:none"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%></span>
    	   	<input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" onBlur="checkPlusnumber1(this);checklength('imgheight','imgheightspan')"
    	     	onKeyPress="ItemPlusCount_KeyPress()" value="<%=imgheight%>" style="display:none">
    	   	<span id=imgheightspan style="display:none"></span>
				<span id="childfieldNotesSpan" style="display:none"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<button type=button id="showChildFieldBotton" class=Browser onClick="onShowChildField('childfieldidSpan', 'childfieldid')" style="display:none"></BUTTON>
				<span id="childfieldidSpan" style="display:none"></span>
				<input type="hidden" value="" name="childfieldid" id="childfieldid">
    	     <select style="display:none" class=inputstyle  name=cusb id=cusb onChange="typeChange()">
			 <option value=''></option>
    	     	<%

                 List l=StaticObj.getServiceIds(Browser.class);
                 //System.out.println(l.size());
	             for(int j=0;j<l.size();j++){
                %>
                <option value=<%=l.get(j)%>><%=l.get(j)%></option>
                 <%}%>
    	     </select>
    	   </td>
    	<%}
    } else {%>
	    <%if(fieldhtmltype.equals("1")){%><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%><%}%>
	    <%if(fieldhtmltype.equals("2")){%><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%><%}%>
	    <%if(fieldhtmltype.equals("3")){%><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%><%}%>
	    <%if(fieldhtmltype.equals("4")){%><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%><%}%>
	    <%if(fieldhtmltype.equals("5")){%><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%><%}%>
		<%if(fieldhtmltype.equals("6")){%><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%}%>
		<%if(fieldhtmltype.equals("7")){%><%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%><%}%>
    </td>
    <%if(fieldhtmltype.equals("5")){%>
		<TD class = field colspan = 3><span id="childfieldidSpan" ><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;<button type=button id="showChildFieldBotton" class=Browser disabled></BUTTON><%=childfieldname%></span></TD>
	<%}else{%>
		<TD class = field colspan = 3></TD>
	<%}
    }%>
  </tr>
  <tr class="Spacing" style="height:1px;">
	<td colspan=6 class="Line"></td>
</tr>
  <tr>
  	<td>&nbsp;</td>
  	<td class=field colspan=3>
  	<div id=selectdiv <%if(fieldhtmltype.equals("5")){%>style="display:''" <%} else {%>style="display:none"<%}%>>
  	  <table class="ViewForm" id="oTable" cols=6 border=0>
  	  <col width=5%><col width=25%><col width=5%><col width=5%><col width=38%><col width=22%>
  	   	<tr>
  	   		<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
  	   		<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>
  	   		<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
  	   		<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td>
  	   		<td><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td>
				<% if(fieldid!=0){%>
  	   			<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td>
  	   		<%} %>
  	   	</tr>
		<tr class="Line"  style="height:1px;"><td colspan="2" ></td></tr>
  	   	<%if(fieldid==0){%>
  	   	<tr  class=DataLight>
  	   	   	<td height="23" width=10%><input type='checkbox' name='check_select' value="<%=rowsum%>" ></td>
		   	<td>
		   	<input type=text class=Inputstyle id="field_<%=rowsum%>_name" name="field_<%=rowsum%>_name" style="width=95%" onchange="checkinput('field_<%=rowsum%>_name','field_<%=rowsum%>_span')">
		   		<!--xwj for td2977 20051107 begin-->
		   	<span id="field_<%=rowsum%>_span"><IMG src="/images/BacoError.gif" align=absMiddle></span></td>
		    <td><input class='InputStyle' type='text' size='25' name='field_count_<%=rowsum%>_name' style='width=90%' value = '0.00' onKeyPress=ItemNum_KeyPress('field_count_<%=rowsum%>_name')></td>
			<td><input type='checkbox' name='field_checked_<%=rowsum%>_name' value='1'></td>
		    <td><input type='checkbox' name='isAccordToSubCom<%=rowsum%>' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;
		      <button type=button class=Browser onClick="onShowCatalog('mypath<%=rowsum%>',<%=rowsum%>)" name=selectCategory></BUTTON>
    			<span id=mypath<%=rowsum%>><%=docPath%></span>
    			  <input type=hidden id='pathcategory<%=rowsum%>' name='pathcategory<%=rowsum%>' value="<%=docPath%>">
			      <input type=hidden id='maincategory<%=rowsum%>' name='maincategory<%=rowsum%>' value="<%=maincategory%>">
    		</td>
		 <!--xwj for td2977 20051107 end-->
			<td>
				<button type=button class="Browser" onClick="onShowChildSelectItem('childItemSpan<%=rowsum%>', 'childItem<%=rowsum%>')" id="selectChildItem<%=rowsum%>" name="selectChildItem<%=rowsum%>"></BUTTON>
				<input type="hidden" id="childItem<%=rowsum%>" name="childItem<%=rowsum%>" value="" >
				<span id="childItemSpan<%=rowsum%>" name="childItemSpan<%=rowsum%>"></span>
			</td>

		</tr>
		<%}
		else{
		int colorcount=0;
			String sql="select * from workflow_SelectItem where fieldid="+fieldid+" and isbill=0 order by selectvalue";//xwj for td2977 20051107  //"id" is added to "order by" by xwj for td3297 20051130
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				String selectname=RecordSet.getString("selectname");
				String selectvalue=RecordSet.getString("selectvalue");
				String listorder=RecordSet.getString("listorder");//xwj for td2977 20051107
				String isdefault=RecordSet.getString("isdefault");//xwj for td2977 20051107
				String selectid=RecordSet.getString("id");//xwj for td3286 20051129
				String docspath = "";
  				String docscategory = RecordSet.getString("docCategory");
  				String isAccordToSubCom = Util.null2String(RecordSet.getString("isAccordToSubCom"));
  				String childitemid = Util.null2String(RecordSet.getString("childitemid"));
					String cancel=RecordSet.getString("cancel");//td31072
					
  				if(!"".equals(docscategory) && null != docscategory)
  				//根据路径ID得到路径名称
  				{
  					List nameList = Util.TokenizerString(docscategory, ",");

  					String mainCategory = (String)nameList.get(0);
            		String subCategory = (String)nameList.get(1);
            		String secCategory = (String)nameList.get(2);

            		docspath = "/" + mainCategoryComInfo.getMainCategoryname(mainCategory) + "/" + subCategoryComInfo.getSubCategoryname(subCategory) + "/" + secCategoryComInfo.getSecCategoryname(secCategory);
  				}
  				String childitemidStr = "";
  				if(!"".equals(childitemid)){
  					String[] itemid_sz = Util.TokenizerString2(childitemid, ",");
  					for(int cx=0; cx<itemid_sz.length; cx++){
  						String itemid_tmp = itemid_sz[cx];
  						try{
	  						String[] checktmp_sz = Util.TokenizerString2(itemid_tmp, "a");
	  						String itemidStr_tmp = Util.null2String((String)selectitem_sh.get("si_"+checktmp_sz[0]));
	  						if(!"".equals(itemidStr_tmp)){
	  							childitemidStr += (itemidStr_tmp + ",");
	  						}
  						}catch(Exception e){}
  					}
  					if(!"".equals(childitemidStr)){
  						childitemidStr = childitemidStr.substring(0, childitemidStr.length()-1);
  					}
  				}

if(colorcount==0){
		colorcount=1;
%>
<TR class=DataLight>
<%
	}else{
		colorcount=0;
%>
<TR class=DataDark>
	<%
	}
	%>
			<td  height="23" width=10%>
			<input <% if(tof) out.println("disabled");%> type='checkbox' name='check_select' value="<%=selectvalue%>" <%if(fieldCommon.isOptionUsed(String.valueOf(fieldid),type2,selectvalue,0)){%> disabled = "true" <%}//xwj for td3297 20051201 %>></td>
			<td >
			<input <% if(tof) out.println("disabled");%>  class=Inputstyle type=text name="field_<%=rowsum%>_name"
			value="<%=Util.toScreen(selectname,user.getLanguage())%>" style="width=95%"
			onchange="checkinput('field_<%=rowsum%>_name','field_<%=rowsum%>_span')">
			<input type="hidden" value="<%=selectid%>" name="field_id_<%=rowsum%>_name"><!--added by xwj for td3286 20051129-->
			<!--xwj for td2977 20051107 begin-->
			<span id="field_<%=rowsum%>_span"></span></td>
			<td><input <% if(tof) out.println("disabled");%> class='InputStyle' type='text' size='25' name='field_count_<%=rowsum%>_name' style='width=90%' value = '<%=listorder%>' onKeyPress=ItemNum_KeyPress('field_count_<%=rowsum%>_name')></td>
			<td><input <% if(tof) out.println("disabled");%> type='checkbox' name='field_checked_<%=rowsum%>_name' value='1' <%if("y".equals(isdefault)){%>checked<%}%>>
		  </td>
		  <td>
              <input  type='hidden' name='selectvalue<%=rowsum%>' value='<%=selectvalue%>' >
              <input <% if(tof) out.println("disabled");%> type='checkbox' name='isAccordToSubCom<%=rowsum%>' value='1' <%if("1".equals(isAccordToSubCom)){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;
		      <button type=button <% if(tof) out.println("disabled");%> class=Browser onClick="onShowCatalog('mypath<%=rowsum%>',<%=rowsum%>)" name=selectCategory></BUTTON>
    			<span id=mypath<%=rowsum%>><%=docspath%></span>
    			  <input type=hidden id='pathcategory<%=rowsum%>' name='pathcategory<%=rowsum%>' value="<%=docspath%>">
			      <input type=hidden id='maincategory<%=rowsum%>' name='maincategory<%=rowsum%>' value="<%=docscategory%>">
    		</td>
			<td>
				<button type=button <% if(tof) out.print("disabled");%> class="Browser" onClick="onShowChildSelectItem('childItemSpan<%=rowsum%>', 'childItem<%=rowsum%>')" id="selectChildItem<%=rowsum%>" name="selectChildItem<%=rowsum%>"></BUTTON>
				<input type="hidden" id="childItem<%=rowsum%>" name="childItem<%=rowsum%>" value="<%=childitemid%>" >
				<span id="childItemSpan<%=rowsum%>" name="childItemSpan<%=rowsum%>"><%=childitemidStr%></span>
			</td>
		  <td><input <% if(tof) out.println("disabled");%> type='checkbox' name='cancel_<%=rowsum%>_name' value="<%=cancel%>" onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if("1".equals(cancel)){%>checked<%}%>>
		 <!--xwj for td2977 20051107 end-->
		</tr>
		<%	rowsum++;
			}%>

		<%}%>

	  </table>
    </div> 
<%
  String displayname = "";
  String linkaddress = "";
  String descriptivetext = "";
  String iscustomlink = "style=display:none;";
  String isdescriptive = "style=display:none;";
  
  
  if(fieldhtmltype.equals("7")){
     rs.executeSql("select * from workflow_specialfield where fieldid = " + fieldid + " and isform = 1");
     rs.next();
     displayname = rs.getString("displayname");
     linkaddress = rs.getString("linkaddress");
     descriptivetext = rs.getString("descriptivetext");
     if(htmltypeid == 1) iscustomlink = "style=display:''";
     if(htmltypeid == 2) isdescriptive = "style=display:''";
  }
%>   
   <div id="customlink" <%out.println(iscustomlink);%>><table width="100%"><tr><td width="25%"><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%>　<input class=inputstyle type=text name=displayname size=20 value="<%=displayname%>" maxlength=1000>　</td><td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>　<input class=inputstyle type=text size=50 name=linkaddress value="<%=linkaddress%>" maxlength=1000><br><%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%></td></tr></table></div>	
 
　　<div id="descriptive" <%out.println(isdescriptive);%>><table width="100%"><tr><td width="8%"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%>　</td><td><textarea class='inputstyle' style='width:60%;height:100px' name=descriptivetext><%=Util.StringReplace(descriptivetext,"<br>","\n")%></textarea></td></tr></table></div>

	</td>
  </tr>

<%
rowsum+=1;
%>
  <tr class="Spacing" style="height:1px;">
	<td colspan=6 class="Line"></td>
</tr>

  <tr>
    <td ><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
	<td colspan=5 class=field >
    <%=(type2.equals("detailfield")?SystemEnv.getHtmlLabelName(18550,user.getLanguage()):SystemEnv.getHtmlLabelName(18549,user.getLanguage()))%>
    </td>
</tr>

  <tr class="Spacing" style="height:1px;">
	<td colspan=6 class="Line"></td>
</tr>
<!--字段不分权，TD10331
<%if(detachable==1){%>
    <tr>
        <td ><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
        <td colspan=5 class=field >
            <%if(operatelevel>0){%>
                <button type=button class=Browser id=SelectSubCompany onclick="onShowSubcompany()"></BUTTON>
            <%}%>
            <SPAN id=subcompanyspan> <%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId2))%>
                <%if(String.valueOf(subCompanyId2).equals("")||String.valueOf(subCompanyId2).equals("0")){%>
                    <IMG src="/images/BacoError.gif" align=absMiddle>
                <%}%>
            </SPAN>
						<%if(String.valueOf(subCompanyId2).equals("0")) {%>
            <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="">
					  <%}else{%>
					  <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subCompanyId2%>">
					  <%}%>	
        </td>
    </tr>
    <tr  style="height:1px;" class="Spacing"><td colspan=6 class="Line"></td></tr>
<%}%>
-->
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


<input type="hidden" value="0" name="selectsnum">
<input type="hidden" value="" name="delids">
</form>
<script language="JavaScript" src="/js/addRowBg.js" >
</script>
<script>
	function OnNewChangeSapBroswerType()
	{
		var browsertype=$G("selecthtmltype").value;
		var showinner=$G("showinner");
		var mark=$G("showinner").innerHTML;
		var showimg=$G("showimg");
		var showvalue=$G("showvalue");
		var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
	    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
	    var urls = "/integration/browse/integrationBrowerMain.jsp?browsertype="+browsertype+"&mark="+mark+"&srcType=<%=type2%>";
	    var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
		var temp=window.showModalDialog(urls,"",tempstatus);
		if(temp)
		{
			showvalue.value=temp;
			showinner.innerHTML=temp;
			showimg.innerHTML="";
		}else
		{
			//showvalue.value="";
			//showinner.innerHTML="";
			//showimg.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
		}
		showimg.style.display='';
	}
	function checkSystemField(name,spanname,type){
		var fieldname = $G(name).value;
		var fieldtype = type;
		if(fieldtype=="mainfield"){
			if(fieldname=="requestid"||fieldname=="billformid"||fieldname=="billid"){
				alert("<%=SystemEnv.getHtmlLabelName(21763,user.getLanguage())%>");
				$G(name).value = "";
				$G(spanname).innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
			}
		}else if(fieldtype=="detailfield"){
			if(fieldname=="requestid"||fieldname=="id"||fieldname=="groupId"){
				alert("<%=SystemEnv.getHtmlLabelName(21764,user.getLanguage())%>");
				$G(name).value = "";
				$G(spanname).innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
			}
		}
	}
	
rowindex = "<%=rowsum%>";
delids = "";
var rowColor="" ;
function addRow() {
	var oTable = $G("oTable");
    rowColor = getRowBg();
	//ncol = oTable.cols;
	//table.rows[0].cells.length
	ncol = oTable.rows[0].cells.length;
	oRow = oTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

				<%--xwj for td2977 20051107 begin--%>
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=\"Inputstyle styled input\" type='text' size='25' id='field_"+rowindex+"_name' name='field_"+rowindex+"_name' style='width=95%'"+
							" onchange=checkinput('field_"+rowindex+"_name','field_"+rowindex+"_span')>"+
							" <span id='field_"+rowindex+"_span'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = " <input class=\"Inputstyle styled input\" type='text' size='25' value = '0.00' name='field_count_"+rowindex+"_name' style='width=90%'"+
							" onKeyPress=ItemNum_KeyPress('field_count_"+rowindex+"_name')>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = " <input type='checkbox' name='field_checked_"+rowindex+"_name' value='1'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='isAccordToSubCom"+rowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "\r\n<button type=button class=Browser onClick=\"onShowCatalog('mypath"+rowindex+"',"+rowindex+")\" name=selectCategory></BUTTON>"
							+ "\r\n<span id=mypath"+rowindex+"><%=docPath%></span>"
						    + "\r\n<input type=hidden id='pathcategory" + rowindex + "' name='pathcategory" + rowindex + "' value='<%=docPath%>'>"
						    + "\r\n<input type=hidden id='maincategory" + rowindex + "' name='maincategory" + rowindex + "' value='<%=maincategory%>'>";

				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				<%--xwj for td2977 20051107 end--%>
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<button type=button class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan"+rowindex+"', 'childItem"+rowindex+"')\" id=\"selectChildItem"+rowindex+"\" name=\"selectChildItem"+rowindex+"\"></BUTTON>"
							+ "\r\n<input type=\"hidden\" id=\"childItem"+rowindex+"\" name=\"childItem"+rowindex+"\" value=\"\" >"
							+ "\r\n<span id=\"childItemSpan"+rowindex+"\" name=\"childItemSpan"+rowindex+"\"></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	rowindex += 1;
}

function onfirmhtml()
{
if (document.form1.htmledit.checked==true)
alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');

}
function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_select')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_select'){
			if(document.forms[0].elements[i].checked==true) {
				if(document.forms[0].elements[i].value!='0')
					delids +=","+ document.forms[0].elements[i].value;
                    //alert(rowsum1);
				oTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}
</script>
<script language=javascript>
	function showType(){
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		htmltypelist = $G("htmltype");
		htmltypeedit = $G("htmledit");
		sapbrowser=$G("sapbrowser");
		//zzl
		var newsapbrowser=$G("newsapbrowser");
		var showinner=$G("showinner");
		var showimg=$G("showimg");
		
        cusb=$G("cusb");
        <!--xwj for @td2977 20051110 begin-->
		if(fieldhtmltypelist.value==4){
		  window.document.forms[0].textheight.style.display='none'
			htmltypelist.style.display='none';
			 htmltypeedit.style.display='none';
			typespan.innerHTML='';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
            window.document.forms[0].strlength.value='';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.style.display='none';
            cusb.style.display='none';
            sapbrowser.style.display='none';
            //zzl
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
            
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("childfieldidSpan").style.display='none';
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("decimaldigitsspan").style.display="none";
        }else if(fieldhtmltypelist.value==6){
		  window.document.forms[0].textheight.style.display='none'
			htmltypelist.style.display='none';
			 htmltypeedit.style.display='none';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
            for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
            htmltypelist.options[0] = new Option('<%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%>',1);
            htmltypelist.options[1] = new Option('<%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%>',2);
			htmltypelist.style.display='';
            cusb.style.display='none';
            //zzl
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
             
            sapbrowser.style.display='none';
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("childfieldidSpan").style.display='none';
            $G("decimaldigitsspan").style.display="none";
            if(htmltypelist.value==1){
                $G("imgwidthnamespan").style.display='none';
                $G("imgwidthspan").style.display='none';
                $G("imgheightnamespan").style.display='none';
                $G("imgheightspan").style.display='none';
                $G("imgwidth").style.display='none';
                $G("imgheight").style.display='none';
                lengthspan.innerHTML='';
                window.document.forms[0].strlength.style.display='none';
                window.document.forms[0].strlength.value='';
            }else{
                lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>';
                window.document.forms[0].strlength.style.display='';
                window.document.forms[0].strlength.value='5';
                $G("imgwidth").value='100';
                $G("imgheight").value='100';
                $G("imgwidthnamespan").style.display='';
                $G("imgwidthspan").style.display='';
                $G("imgheightnamespan").style.display='';
                $G("imgheightspan").style.display='';
                $G("imgwidth").style.display='';
                $G("imgheight").style.display='';
            }
        }else if(fieldhtmltypelist.value==2){
		  htmltypelist.style.display='none';
		  htmltypeedit.style.display='';
		  
          //将html格式的是否可用 与  当前是否为明细字段 保持一致
          //标识当前是否为明细字段
          var flagIsDetail = <%=(isdetail == 1)%>;
		  if(flagIsDetail){
			  htmltypeedit.disabled = true;
		  }
		  
		  typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>';
		  window.document.forms[0].textheight.style.display='';
			lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>';
			window.document.forms[0].strlength.style.display='none';
            window.document.forms[0].strlength.value='';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.style.display='none';
            cusb.style.display='none';
            sapbrowser.style.display='none';
            //zzl
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
             
             
             
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("childfieldidSpan").style.display='none';
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("decimaldigitsspan").style.display="none";
        }else if(fieldhtmltypelist.value==5){
            window.document.forms[0].textheight.style.display='none';<!--xwj for @td2977 20051110 end-->
			htmltypelist.style.display='none';
            htmltypeedit.style.display='none';
			typespan.innerHTML='';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
            window.document.forms[0].strlength.value='';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='';
			$G("btnaddRow").style.display='';
			$G("btnsubmitClear").style.display='';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.style.display='none';
            cusb.style.display='none';
            sapbrowser.style.display='none';
            //zzl
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
             
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='';
            $G("showChildFieldBotton").style.display='';
            $G("childfieldidSpan").style.display='';
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("decimaldigitsspan").style.display="none";
        }else if(fieldhtmltypelist.value==3){
		  window.document.forms[0].textheight.style.display='none';	<!--xwj for @td2977 20051110 end-->
			htmltypelist.style.display='';
            htmltypeedit.style.display='none';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
            window.document.forms[0].strlength.value='';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.style.display='';
			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=browsertype%>
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("childfieldidSpan").style.display='none';
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("decimaldigitsspan").style.display="none";
            //列表排序
            //sortOption();
		}else if(fieldhtmltypelist.value==1){
		  window.document.forms[0].textheight.style.display='none';	<!--xwj for @td2977 20051110 end-->
			htmltypelist.style.display='';
		  htmltypeedit.style.display='none';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>';
            window.document.forms[0].strlength.value='';
			window.document.forms[0].strlength.style.display='';
			if(form1.strlength.value==''||form1.strlength.value==0)
				strlengthspan.innerHTML='<IMG src="/images/BacoError.gif" align=absMiddle>';
			strlengthspan.style.display='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.selectedIndex=0;
			htmltypelist.style.display='';			
			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=texttype%>
            cusb.style.display='none';
            sapbrowser.style.display='none';
            //zzl
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
            
			$G("decimaldigitsspan").style.display="none";
            $G("customlink").style.display='none';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("childfieldidSpan").style.display='none';
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
        }else if(fieldhtmltypelist.value==7){
		  window.document.forms[0].textheight.style.display='none';<!--xwj for @td2977 20051110 end-->
			htmltypelist.style.display='none';
		    htmltypeedit.style.display='none';
			typespan.innerHTML='<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>';
			lengthspan.innerHTML='';
			window.document.forms[0].strlength.style.display='none';
            window.document.forms[0].strlength.value='';
			strlengthspan.innerHTML='';
			$G("selectdiv").style.display='none';
			$G("btnaddRow").style.display='none';
			$G("btnsubmitClear").style.display='none';
			htmltypelist = $G("selecthtmltype");
			htmltypelist.style.display='';
			for(var count = htmltypelist.options.length - 1; count >= 0; count--)
				htmltypelist.options[count] = null;
			<%=specialtype%>
            cusb.style.display='none';
            sapbrowser.style.display='none';
            //zzl
            newsapbrowser.style.display='none';
            showimg.style.display='none';
            showinner.style.display='none';
            
            $G("customlink").style.display='';
            $G("descriptive").style.display='none';
            $G("childfieldNotesSpan").style.display='none';
            $G("showChildFieldBotton").style.display='none';
            $G("childfieldidSpan").style.display='none';
            $G("imgwidthnamespan").style.display='none';
            $G("imgwidthspan").style.display='none';
            $G("imgheightnamespan").style.display='none';
            $G("imgheightspan").style.display='none';
            $G("imgwidth").style.display='none';
            $G("imgheight").style.display='none';
            $G("decimaldigitsspan").style.display="none";
        }
	}

	function typeChange(){
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		htmltypelist = $G("htmltype");
        cusb=$G("cusb");
        showprep=$G("showprep");
        sapbrowser=$G("sapbrowser");
        showprepspan_01=$G("showprepspan");
     
        //zzl
        var newsapbrowser=$G("newsapbrowser");
        var showimg=$G("showimg");
        var showinner=$G("showinner");
        var showvalue=$G("showvalue")
        
        //alert("看看"+ htmltypelist.value);
        if(fieldhtmltypelist.value==1){
			if(htmltypelist.value==1){
				lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>';
				window.document.forms[0].strlength.style.display='';
				if(form1.strlength.value==''||form1.strlength.value==0){
					strlengthspan.innerHTML='<IMG src="/images/BacoError.gif" align=absMiddle>';
				}
				strlengthspan.style.display='';
		        $G("decimaldigitsspan").style.display="none";
			}else if(htmltypelist.value==3){
				lengthspan.innerHTML='';
				cusb.style.display='none';		
				window.document.forms[0].strlength.style.display='none';
				strlengthspan.style.display='none';
				$G("decimaldigitsspan").style.display="";
			}else{
				lengthspan.innerHTML='';
				window.document.forms[0].strlength.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
				$G("decimaldigitsspan").style.display="none";
			}
		}
        if(fieldhtmltypelist.value==3){
			if(htmltypelist.value==161||htmltypelist.value==162){
				cusb.style.display='';
				if(cusb.value==''||cusb.value==0){
					strlengthspan.innerHTML='<IMG src="/images/BacoError.gif" align=absMiddle>';
				}else
                    strlengthspan.innerHTML='';
				strlengthspan.style.display='';
			}
			else{
				cusb.value=''
				cusb.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
			}
			if(htmltypelist.value==224||htmltypelist.value==225){
				sapbrowser.style.display='';
				if(sapbrowser.value==''||sapbrowser.value==0){
					strlengthspan.innerHTML='<IMG src="/images/BacoError.gif" align=absMiddle>';
				}else
                    strlengthspan.innerHTML='';
				strlengthspan.style.display='';
			}
			else{
				sapbrowser.value=''
				sapbrowser.style.display='none';
				strlengthspan.innerHTML='';
				strlengthspan.style.display='none';
			}
			//zzl
			if(htmltypelist.value==226||htmltypelist.value==227){
				newsapbrowser.style.display='';
				showinner.style.display='';
				if(showvalue.value==''){
					//新建的状态下显示的图片
					showimg.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
				}else
				{
                    showimg.innerHTML='';
                }
				showimg.style.display='';
			}
			else{
				newsapbrowser.value=''
				newsapbrowser.style.display='none';
				showimg.innerHTML='';
				//showvalue.value='';
				showimg.style.display='none';
				//showinner.innerHTML='';
				showinner.style.display='none';
			}
			
			
            if(htmltypelist.value==165||htmltypelist.value==166||htmltypelist.value==167||htmltypelist.value==168){
				showprep.style.display='';
				showprepspan_01.style.display='';
			}
			else{
				//showprep,showprepspan非集成浏览按钮引起的错误
				if(showprep){
					showprep.value='1'
					showprep.style.display='none';
				}
				if(showprepspan_01){
					showprepspan_01.style.display='none';
				}
			}
		}
        if(fieldhtmltypelist.value==6){
			if(htmltypelist.value==1){
                $G("imgwidthnamespan").style.display='none';
                $G("imgwidthspan").style.display='none';
                $G("imgheightnamespan").style.display='none';
                $G("imgheightspan").style.display='none';
                $G("imgwidth").style.display='none';
                $G("imgheight").style.display='none';
                lengthspan.innerHTML='';
                window.document.forms[0].strlength.style.display='none';
                window.document.forms[0].strlength.value='';
			}else{
                lengthspan.innerHTML='<%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>';
                window.document.forms[0].strlength.style.display='';
                window.document.forms[0].strlength.value='5';
                $G("imgwidth").value='100';
                $G("imgheight").value='100';
                $G("imgwidthnamespan").style.display='';
                $G("imgwidthspan").style.display='';
                $G("imgheightnamespan").style.display='';
                $G("imgheightspan").style.display='';
                $G("imgwidth").style.display='';
                $G("imgheight").style.display='';
			}
		}
        if(fieldhtmltypelist.value==7){
			if(htmltypelist.value==1){
               $G("customlink").style.display='';
               $G("descriptive").style.display='none';
			}
		    if(htmltypelist.value==2){
               $G("customlink").style.display='none';
               $G("descriptive").style.display='';
			}
		}
	}


	function checkKey()
	{
	var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECK,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
	//以下for oracle.update by cyril on 2008-12-08 td:9722
	keys+="ACCESS,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUDIT,BETWEEN,BY,CHAR,"; 
	keys+="CHECK,CLUSTER,COLUMN,COMMENT,COMPRESS,CONNECT,CREATE,CURRENT,";
	keys+="DATE,DECIMAL,DEFAULT,DELETE,DESC,DISTINCT,DROP,ELSE,EXCLUSIVE,";
	keys+="EXISTS,FILE,FLOAT,FOR,FROM,GRANT,GROUP,HAVING,IDENTIFIED,";
	keys+="IMMEDIATE,IN,INCREMENT,INDEX,INITIAL,INSERT,INTEGER,INTERSECT,";
	keys+="INTO,IS,LEVEL,LIKE,LOCK,LONG,MAXEXTENTS,MINUS,MLSLABEL,MODE,";
	keys+="MODIFY,NOAUDIT,NOCOMPRESS,NOT,NOWAIT,NULL,NUMBER,OF,OFFLINE,ON,";
	keys+="ONLINE,OPTION,OR,ORDER,PCTFREE,PRIOR,PRIVILEGES,PUBLIC,RAW,";
	keys+="RENAME,RESOURCE,REVOKE,ROW,ROWID,ROWNUM,ROWS,SELECT,SESSION,";
	keys+="SET,SHARE,SIZE,SMALLINT,START,SUCCESSFUL,SYNONYM,SYSDATE,TABLE,";
	keys+="THEN,TO,TRIGGER,UID,UNION,UNIQUE,UPDATE,USER,VALIDATE,VALUES,";
	keys+="VARCHAR,VARCHAR2,VIEW,WHENEVER,WHERE,WITH,";
    var fname=window.document.forms[0].fieldname.value;
	if (fname!="")
		{fname=","+fname.toUpperCase()+",";
	if (keys.indexOf(fname)>0)
		{
	    alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
		window.document.forms[0].fieldname.focus();
        return false;
	    }
		}
	return true;
	}
	function checksubmit(){
		fieldhtmltypelist = window.document.forms[0].fieldhtmltype;
		htmltypelist = $G("htmltype");
        if (!checkKey())  return false;
		if(fieldhtmltypelist.value==1){
			if(htmltypelist.value==1){
				if(form1.strlength.value==""||form1.strlength.value==0){
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
		}
		if(fieldhtmltypelist.value==3){
			if(htmltypelist.value==161||htmltypelist.value==162){
				if(form1.cusb.value==""||form1.cusb.value==0){
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
			if(htmltypelist.value==224||htmltypelist.value==225){
				if(form1.sapbrowser.value==""||form1.sapbrowser.value==0){
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
			//zzl
			if(htmltypelist.value==226||htmltypelist.value==227){
				var showvalue=document.getElementById("showvalue").value;
				if(showvalue==""){
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return false;
				}
			}
		}
		var parastr="fieldname";
		if(fieldhtmltypelist.value==5){
			for(k=0;k<rowindex;k++){
				len = document.forms[0].elements.length;
				var i=0;
				for(i=len-1; i >= 0;i--) {
					if (document.forms[0].elements[i].name=="field_"+k+"_name"){
						parastr+=",field_"+k+"_name";
						break;
					}
				}
			}
		}
		document.forms[0].selectsnum.value=rowindex;
		document.forms[0].delids.value=delids;
		return check_form(document.form1,parastr);
	}

function checklength(elementname,spanid){
    fieldhtmltype = window.document.forms[0].fieldhtmltype.value;
	htmltype = $G("htmltype").value;
    if(fieldhtmltype==6&&htmltype==2){
        $G(spanid).innerHTML='';
    }else{
	tmpvalue = $G(elementname).value;

	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if(tmpvalue!=""&&tmpvalue!=0){
		 $G(spanid).innerHTML='';
	}
	else{
	 $G(spanid).innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
	 $G(elementname).value = "";
	}
    }
}
function onChangeChildField(){
	var rownum = parseInt(rowindex);
	for(var i=0; i<rownum; i++){
		var inputObj = $G("childItem"+i);
		var spanObj = $G("childItemSpan"+i);
		try{
			if(inputObj!=null && spanObj!=null){
				inputObj.value = "";
				spanObj.innerHTML = "";
			}
		}catch(e){}
	}
}
</script>
<script language="javascript">
//<!--xwj for td2977 20051118 begin-->
function submitData()
{
	if(check_form(form1,'subcompanyid')){
		if("<%=count_fields%>">999){
		    alert("<%=SystemEnv.getHtmlLabelName(23037,user.getLanguage())%>");
		    return;
		}
		<!--xwj for td3131 20051118 begin-->
		var selectvalue = window.document.forms[0].fieldhtmltype.value;
		if (checksubmit()){
			<!--xwj for td3297 20051130 begin-->
			<%if("addfield".equals(type)){%>
				if(selectvalue == "5"){
					if(checkDefault()){
					    if (check_form(form1,'subcompanyid')){
					    	//对选择框中的欧元符号进行特殊处理
							for(var i=0; i<=rowindex; i++){
								var myObj = document.getElementById("field_"+i+"_name");
								if(myObj){
									myObj.value = dealSpecial(myObj.value);
								}
							}
					    	
						 	form1.submit();
							enableAllmenu();
					    }
					}
				} else {
			        if (check_form(form1,'subcompanyid')){
						form1.submit();
						enableAllmenu();
			        }
				}
			<%}else{%>
				var fieldhtmltype = <%=fieldhtmltype%>;
				if(fieldhtmltype==5){
					if(checkDefault()){
				        if (check_form(form1,'subcompanyid')){
				        	//对选择框中的欧元符号进行特殊处理
							for(var i=0; i<=rowindex; i++){
								var myObj = document.getElementById("field_"+i+"_name");
								if(myObj){
									myObj.value = dealSpecial(myObj.value);
								}
							}
				        	
						 	form1.submit();
							enableAllmenu();
				        }
					}
				} else {
			        if (check_form(form1,'subcompanyid')){
						form1.submit();
						enableAllmenu();
			        }
				}
			<%}%>
			<!--xwj for td3297 20051130 end-->
	
		}
		<!--xwj for td3131 20051118 end-->
	}
}

//对特殊符号进行处理
function dealSpecial(val){
	//本字符串是欧元符号的unicode码, GBK编辑中不支持欧元符号(需更改为UTF-8), 故只能使用unicode码
	var euro = "\u20AC";
	//本字符串是欧元符号在HTML中的特别表现形式
	var symbol = "&euro;";
	var reg = new RegExp(euro);
	while(val.indexOf(euro) != -1){
		val = val.replace(reg, symbol);
	}  
	return val;
}

function checkDefault(){
	var tempcount = 0;
	for(i=0;i<rowindex;i++){
		if($G("field_checked_"+i+"_name")){
			var value = $G("field_checked_"+i+"_name").checked;
			if(value){
				tempcount = tempcount + 1;
			}
		}
	}
	if(tempcount > 1){
		alert("默认选项只能选择一个!");
		return false;
	} else {
	//deleted by xwj for td3297 20051130
		return true;
	}
}
<!--xwj for td2977 20051118 end-->

function submitClear()
{
	//检查是否选中要删除的数据项
	var flag = false;
	var col = document.getElementsByName("check_select");
	for(var i = 0; i<col.length; i++){
		if(col[i] && col[i].checked){
			flag = true;
			break;
		}
	}
	if(flag){
		if (isdel()){
			deleteRow1();
		}
	} else {
		alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
		return false;
	}
}

function onShowCatalog(spanName, index) {
	var isAccordToSubCom=0;
	if($G("isAccordToSubCom"+index)!=null){
		if($G("isAccordToSubCom"+index).checked){
			isAccordToSubCom=1;
		}
	}
	if(isAccordToSubCom==1){
		onShowCatalogSubCom($G(spanName), index);
	}else{
		onShowCatalogHis($G(spanName), index);
	}
}

function onShowCatalogHis(spanName, index) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result, 0) != 0)  {
            spanName.innerHTML=wuiUtil.getJsonValueByIndex(result, 2);
            $G("pathcategory"+index).value=wuiUtil.getJsonValueByIndex(result, 2);
            $G("maincategory"+index).value=wuiUtil.getJsonValueByIndex(result, 3)+","+wuiUtil.getJsonValueByIndex(result, 4)+","+wuiUtil.getJsonValueByIndex(result, 1);
            //$G("subcategory"+index).value=result[4];
            //$G("seccategory"+index).value=result[1];
        }
         // <!--added xwj for td2048 on 2005-6-1 begin -->
        else{
            spanName.innerHTML="";
            $G("pathcategory"+index).value="";
            $G("maincategory"+index).value="";
            //$G("subcategory"+index).value="";
            //$G("seccategory"+index).value="";
            }
        //<!--added xwj for td2048 on 2005-6-1 end -->
    }
}
function onShowCatalogSubCom(spanName, index) {

	if($G("selectvalue"+index)==null){
		alert("<%=SystemEnv.getHtmlLabelName(24460,user.getLanguage())%>");
		return;
	}

	var selectvalue=$G("selectvalue"+index).value;
	url =escape("/workflow/field/SubcompanyDocCategoryBrowser.jsp?fieldId=<%=fieldid%>&isBill=0&selectValue="+selectvalue)
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);

}

//浏览按钮 下拉框选项按照字母顺序排序
function sortRule(a,b) {
	var x = a._text;
	var y = b._text;
	return x.localeCompare(y);
}
function op(){
	var _value;
	var _text;
}
function sortOption(){
	var obj = $G("selecthtmltype");
	var tmp = new Array();
	for(var i=0;i<obj.options.length;i++){
	var ops = new op();
	ops._value = obj.options[i].value;
	ops._text = obj.options[i].text;
	tmp.push(ops);
    }
	tmp.sort(sortRule);
	for(var j=0;j<tmp.length;j++){
	obj.options[j].value = tmp[j]._value;
	obj.options[j].text = tmp[j]._text;
	}
}
if("<%=fieldhtmltype%>"=="3") {
   //sortOption();
}
</script>

<script type="text/javascript">
//<!--

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
				+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
				+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}

function onShowSubcompany() {
	url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&selectedids=" + $G("subcompanyid").value;
	disModalDialog(url, $G("subcompanyspan"), $G("subcompanyid"), true);
}


function onShowChildField(spanname, inputname) {
	var url = "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5<%if(fieldid!=0){out.print(" and id<>"+fieldid+" ");}%>&isdetail=<%=isdetail%>&isbill=0");
	disModalDialog(url, $G(spanname), $G(inputname), false);
}

function onShowChildSelectItem(spanname, inputname) {
	var cfid = $G("childfieldid").value;
	var resourceids = $G(inputname).value;
	
	var url = "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/field/SelectItemBrowser.jsp?isbill=0&isdetail=<%=isdetail%>&childfieldid=" + cfid + "&resourceids=" + resourceids);
	var id = showModalDialog(url);
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			var resourceids = rid.substr(1);
			var resourcenames = rname.substr(1);
			
			$G(inputname).value = resourceids;
			$G(spanname).innerHTML = resourcenames;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}
//-->
</script>
<!-- 
<script language="VBScript">
sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&selectedids="&form1.subcompanyid.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = form1.subcompanyid.value then
		issame = true
	end if
	subcompanyspan.innerHtml = id(1)
	form1.subcompanyid.value=id(0)
	else
	subcompanyspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	form1.subcompanyid.value=""
	end if
	end if
end sub


sub onShowChildField(spanname, inputname)
	oldvalue = inputname.value
	url=escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5<%if(fieldid!=0){out.print(" and id<>"+fieldid+" ");}%>&isdetail=<%=isdetail%>&isbill=0")
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			inputname.value = id(0)
			spanname.innerHtml = id(1)
		else
			inputname.value = ""
			spanname.innerHtml = ""
		end if
	end if
	if oldvalue <> inputname.value then
		onChangeChildField
	end if
end sub

sub onShowChildSelectItem(spanname, inputname)
	cfid = form1.childfieldid.value
	resourceids = inputname.value
	url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=0&isdetail=<%=isdetail%>&childfieldid="&cfid&"&resourceids="&resourceids)
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			resourceids = id(0)
			resourcenames = id(1)
			resourceids = Mid(resourceids, 2, len(resourceids))
			resourcenames = Mid(resourcenames, 2, len(resourcenames))
			inputname.value = resourceids
			spanname.innerHtml = resourcenames
		else
			inputname.value = ""
			spanname.innerHtml = ""
		end if
	end if

end sub

</script>
 -->
</body>
</html>