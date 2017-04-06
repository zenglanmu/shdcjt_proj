<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("HrmTrainTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String name=Util.null2String(request.getParameter("name"));
String description=Util.null2String(request.getParameter("description"));
String typecontent=Util.null2String(request.getParameter("typecontent"));
String typeaim=Util.null2String(request.getParameter("typeaim"));
String typeoperator=Util.null2String(request.getParameter("typeoperator"));

String usertype = user.getLogintype();

String mainid=Util.null2String(request.getParameter("mainid"));
String subid=Util.null2String(request.getParameter("subid"));

int secid=Util.getIntValue(request.getParameter("typedocurl"),0);

String categoryname="";
String subcategoryid="";
String cusertype="";

ArrayList mainids=new ArrayList();
ArrayList subids=new ArrayList();
ArrayList secids=new ArrayList();
char flag = 2;
String tempsubcategoryid="";

if(user.getType()==0)
{
    RecordSet.executeProc("DocUserCategory_SMainByUser",""+user.getUID()+flag+user.getType());
    while(RecordSet.next()){
      mainids.add(RecordSet.getString("mainid"));
    }
    RecordSet.executeProc("DocUserCategory_SSubByUser",""+user.getUID()+flag+user.getType());
    while(RecordSet.next()){
      subids.add(RecordSet.getString("subid"));
    }    

    RecordSet.executeProc("DocUserCategory_SSecByUser",""+user.getUID()+flag+user.getType());
    while(RecordSet.next()){
      secids.add(RecordSet.getString("secid"));
    }    
}else{
    String subid2="";
    RecordSet.executeProc("DocSecCategory_SByCustomerType",""+user.getType()+flag+user.getSeclevel());
    
    while(RecordSet.next()){
        secids.add(RecordSet.getString("id"));
        if(!tempsubcategoryid.equals(RecordSet.getString("subcategoryid"))){
            subids.add(RecordSet.getString("subcategoryid"));
        }
        tempsubcategoryid=RecordSet.getString("subcategoryid");
    }
    for(int m=0;m<subids.size();m++){
        if(m<subids.size()-1)
        subid2 += (String)subids.get(m)+",";
        else 
        subid2 += (String)subids.get(m);
    }

    String sql="select distinct(maincategoryid) from DocSubCategory where id in ("+subid2+")  order by maincategoryid";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        mainids.add(RecordSet.getString("maincategoryid"));
    }
}

if(secid!=0){
	RecordSet.executeProc("Doc_SecCategory_SelectByID",secid+"");
	RecordSet.next();
	 categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	 subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));	 	 	 
	 cusertype=Util.null2String(""+RecordSet.getString("cusertype"));
	 cusertype = cusertype.trim();	 
}


String testmainid=Util.null2String(request.getParameter("testmainid"));
String testsubid=Util.null2String(request.getParameter("testsubid"));
int testsecid=Util.getIntValue(request.getParameter("typetesturl"),0);

String testcategoryname="";
String testsubcategoryid="";
String testcusertype="";

ArrayList testmainids=new ArrayList();
ArrayList testsubids=new ArrayList();
ArrayList testsecids=new ArrayList();
char testflag = 2;
String testtempsubcategoryid="";

if(user.getType()==0)
{
    RecordSet.executeProc("DocUserCategory_SMainByUser",""+user.getUID()+testflag+user.getType());
    while(RecordSet.next()){
      testmainids.add(RecordSet.getString("mainid"));
    }
    RecordSet.executeProc("DocUserCategory_SSubByUser",""+user.getUID()+testflag+user.getType());
    while(RecordSet.next()){
      testsubids.add(RecordSet.getString("subid"));
    }    

    RecordSet.executeProc("DocUserCategory_SSecByUser",""+user.getUID()+testflag+user.getType());
    while(RecordSet.next()){
      testsecids.add(RecordSet.getString("secid"));
    }    
}else{
    String testsubid2="";
    RecordSet.executeProc("DocSecCategory_SByCustomerType",""+user.getType()+testflag+user.getSeclevel());
    
    while(RecordSet.next()){
        testsecids.add(RecordSet.getString("id"));
        if(!testtempsubcategoryid.equals(RecordSet.getString("subcategoryid"))){
            testsubids.add(RecordSet.getString("subcategoryid"));
        }
        testtempsubcategoryid=RecordSet.getString("subcategoryid");
    }
    for(int m=0;m<testsubids.size();m++){
        if(m<testsubids.size()-1)
        testsubid2 += (String)testsubids.get(m)+",";
        else 
        testsubid2 += (String)testsubids.get(m);
    }

    String sql="select distinct(maincategoryid) from DocSubCategory where id in ("+testsubid2+")  order by maincategoryid";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        testmainids.add(RecordSet.getString("maincategoryid"));
    }
}

if(testsecid!=0){
	RecordSet.executeProc("Doc_SecCategory_SelectByID",testsecid+"");
	RecordSet.next();
	 testcategoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	 subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));	 	 	 
	 testcusertype=Util.null2String(""+RecordSet.getString("cusertype"));
	 testcusertype = cusertype.trim();	 
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+ SystemEnv.getHtmlLabelName(6130,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainTypeAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/traintype/HrmTrainType.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
<FORM id=weaver name=frmMain action="TrainTypeOperation.jsp" method=post >
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(807,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 maxlength="50" name="name" value="<%=name%>" onchange="checkinput('name','nameimage')">
              <SPAN id=nameimage>
               <%if(name.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%>
              </SPAN>
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=60 maxlength="60" name="description" value="<%=description%>" onchange='checkinput("description","descriptionimage")'>
              <SPAN id=descriptionimage>
                <%if(description.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%>
              </SPAN>
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%> </td>
          <td class=field >
            <textarea class=inputstyle  cols=50 rows=4 name=typecontent value=<%=typecontent%>><%=typecontent%></textarea>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=field >
            <textarea class=inputstyle cols=50 rows=4 name=typeaim value=<%=typeaim%>><%=typeaim%></textarea>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--        
        <tr>
          <td>试卷文档目录 </td>
          <td>
            <input class=inputstyle type=text name=typedocurl >
          </td>
        </tr>  
        <tr>
          <td>试卷存放目录 </td>
          <td>
            <input class=inputstyle type=text name=typetesturl >
          </td>
        </tr>  
-->        
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16167,user.getLanguage())%> </td>
          <td class=Field>
	      <INPUT class=wuiBrowser id=typeoperator type=hidden name=typeoperator value="<%=typeoperator%>"
	      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" _required=yes
	      _displayTemplate="<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=#b{id}');>#b{name}</a>&nbsp;">      
	      </td>	   
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--        
<tr>
  <td>培训文档存放主目录</td>
  <td class=field>
  <select name=mainid onchange="mainchange()">
  <option value=""></option> 
  <%
    for(int j=0;j<mainids.size();j++){
	String isselect = "";
 	String curid = (String)mainids.get(j);
 	String curname=MainCategoryComInfo.getMainCategoryname(curid);
	if(mainid.equals(curid)) isselect=" selected";

  %>
  <option value="<%=curid%>" <%=isselect%>><%=curname%></option>  
  <%}%>
  </select>
  </td>
</tr>
  
  <tr>
  <td>培训文档存放分目录</td>
  <td class=field>
  <select name=subid onchange="subchange()">  
  <option value=""></option> 
  <%for(int m=0;m<subids.size();m++){  
	  	String isselect = "";
		String curid = (String)subids.get(m);
		String curname=SubCategoryComInfo.getSubCategoryname(curid);
	 	String curmainid = SubCategoryComInfo.getMainCategoryid(curid);
	 	if(!curmainid.equals(mainid)) continue;
		if(subid.equals(curid)) isselect=" selected";
  %>
  <option value="<%=curid%>" <%=isselect%>><%=curname%></option>  
  <%
  }  
  %>
  </select>
  </td>
  </tr>
  
  <tr>
  <td>培训文档存放子目录</td>
  <td class=field>
  <select name=typedocurl value="<%=secid%>">
  <option value=""></option> 
  <%for(int n=0;n<secids.size();n++){
	    String isselect = "";
   		String curid = (String)secids.get(n);
		String curname=SecCategoryComInfo.getSecCategoryname(curid);
	 	String cursubid = SecCategoryComInfo.getSubCategoryid(curid);
	 	if(!cursubid.equals(subid)) continue;
  		if(secid == Util.getIntValue(curid)) isselect=" selected";
  %>
  <option value="<%=curid%>" <%=isselect%>><%=curname%></option>  
  <%}
  
%>
  </select>
  </td>
  </tr>

 <tr>
  <td>培训试卷存放主目录</td>
  <td class=field>
  <select name=testmainid onchange="testmainchange()">
  <option value=""></option> 
  <%
    for(int j=0;j<testmainids.size();j++){
	String isselect = "";
 	String curid = (String)testmainids.get(j);
 	String curname=MainCategoryComInfo.getMainCategoryname(curid);
	if(testmainid.equals(curid)) isselect=" selected";

  %>
  <option value="<%=curid%>" <%=isselect%>><%=curname%></option>  
  <%}%>
  </select>
  </td>
</tr>
  
  <tr>
  <td>培训试卷存放分目录</td>
  <td class=field>
  <select name=testsubid onchange="testsubchange()">  
  <option value=""></option> 
  <%for(int m=0;m<testsubids.size();m++){  
	  	String isselect = "";
		String curid = (String)testsubids.get(m);
		String curname=SubCategoryComInfo.getSubCategoryname(curid);
	 	String curmainid = SubCategoryComInfo.getMainCategoryid(curid);
	 	if(!curmainid.equals(testmainid)) continue;
		if(testsubid.equals(curid)) isselect=" selected";
  %>
  <option value="<%=curid%>" <%=isselect%>><%=curname%></option>  
  <%
  }  
  %>
  </select>
  </td>
  </tr>
  
  <tr>
  <td>培训试卷存放子目录</td>
  <td class=field>
  <select name=typetesturl value="<%=secid%>">
  <option value=""></option> 
  <%for(int n=0;n<testsecids.size();n++){
	    String isselect = "";
   		String curid = (String)secids.get(n);
		String curname=SecCategoryComInfo.getSecCategoryname(curid);
	 	String cursubid = SecCategoryComInfo.getSubCategoryid(curid);
	 	if(!cursubid.equals(subid)) continue;
  		if(testsecid == Util.getIntValue(curid)) isselect=" selected";
  %>
  <option value="<%=curid%>" <%=isselect%>><%=curname%></option>  
  <%}
  
%>
  </select>
  </td>
  </tr>
-->
<input class=inputstyle type="hidden" name=operation value=add>
 </TBODY></TABLE>
 </form>
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
 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&curid&"')>"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&resourceids&"')>"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else
    	spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub
</script>
<script language=javascript>
 function mainchange(){
    document.frmMain.action="HrmTrainTypeAdd.jsp";
    document.frmMain.submit();
  }
  function subchange(){
    document.frmMain.action="HrmTrainTypeAdd.jsp";
    document.frmMain.submit();
  }
  function testmainchange(){
    document.frmMain.action="HrmTrainTypeAdd.jsp";
    document.frmMain.submit();
  }
  function testsubchange(){
    document.frmMain.action="HrmTrainTypeAdd.jsp";
    document.frmMain.submit();
  }


  function checkTextLength(textObj,maxlength){
    var len = trim(textObj.value).length
    if(len >  maxlength){
        alert("文本筐的文本长度不能超过"+maxlength);
        return false;
    }
    return true;
  }
  function submitData() {
     if(checkTextLength(document.all.frmMain.typecontent,500)&&checkTextLength(document.all.frmMain.typeaim,500)){
         if(check_formM(frmMain,'name,description,typeoperator')){
         frmMain.submit();
         }
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
	if(tmpname=="typeoperator"){
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
 /**
 * trim function ,add by Huang Yu
 */
 function trim(value) {
   var temp = value;
   var obj = /^(\s*)([\W\w]*)(\b\s*$)/;
   if (obj.test(temp)) { temp = temp.replace(obj, '$2'); }
   return temp;
}
</script>
</BODY>
</HTML>
