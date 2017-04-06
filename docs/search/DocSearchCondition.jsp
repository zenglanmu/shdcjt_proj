<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<%


    int secCategoryId= Util.getIntValue(request.getParameter("secCategoryId"),0);

if(secCategoryId>0){
	String docsubject="";
	int ownerid = 0;
	int departmentid = 0;

    String whereKeyStr = Util.null2String((String)session.getAttribute(user.getUID()+"_"+secCategoryId+"whereKeyStr"));
    whereKeyStr =whereKeyStr.replaceAll(",","#");
    Map tmpcolnameMap=new HashMap();
	Map tmphtmltypeMap=new HashMap();
	Map tmptypeMap=new HashMap();
	Map tmpoptMap=new HashMap();
	Map tmpvalueMap=new HashMap();
	Map tmpnameMap=new HashMap();
	Map tmpopt1Map=new HashMap();
	Map tmpvalue1Map=new HashMap();

	String tmpid = null;
	String tmpcolname = null;
	String tmphtmltype = null;
	String tmptype = null;
	String tmpopt = null;
	String tmpvalue = null;
	String tmpname = null;
	String tmpopt1 = null;
	String tmpvalue1 =null;

	String whereKeyStrPart=null;
	
    ArrayList whereKeyStrList = Util.TokenizerString(whereKeyStr,"^,^");
	for(int i=0;i<whereKeyStrList.size();i++){
		whereKeyStrPart=Util.null2String((String)whereKeyStrList.get(i));
		if(whereKeyStrPart.indexOf("docsubject=")>=0){
			docsubject=whereKeyStrPart.substring("docsubject=".length());
		}else if(whereKeyStrPart.indexOf("ownerid=")>=0){
			ownerid=Util.getIntValue(whereKeyStrPart.substring("ownerid=".length()),0);
		}else if(whereKeyStrPart.indexOf("departmentid=")>=0){
			departmentid=Util.getIntValue(whereKeyStrPart.substring("departmentid=".length()),0);
		}else{
			if(whereKeyStrPart.indexOf("tmpid")!=-1){
				whereKeyStrPart = whereKeyStrPart.replaceAll("#",",");
			}
				ArrayList whereKeyStrPartList = Util.TokenizerString(whereKeyStrPart,"~@~");
				if(whereKeyStrPartList.size()>=9){
					tmpid=((String)whereKeyStrPartList.get(0)).substring("tmpid=".length());
					tmpcolname=((String)whereKeyStrPartList.get(1)).substring("tmpcolname=".length());
					tmphtmltype=((String)whereKeyStrPartList.get(2)).substring("tmphtmltype=".length());
					tmptype=((String)whereKeyStrPartList.get(3)).substring("tmptype=".length());
					tmpopt=((String)whereKeyStrPartList.get(4)).substring("tmpopt=".length());
					tmpvalue=((String)whereKeyStrPartList.get(5)).substring("tmpvalue=".length());
					tmpname=((String)whereKeyStrPartList.get(6)).substring("tmpname=".length());
					tmpopt1=((String)whereKeyStrPartList.get(7)).substring("tmpopt1=".length());
					tmpvalue1=((String)whereKeyStrPartList.get(8)).substring("tmpvalue1=".length());
	
					tmpcolnameMap.put(tmpid,tmpcolname);
					tmphtmltypeMap.put(tmpid,tmphtmltype);
					tmptypeMap.put(tmpid,tmptype);
					tmpoptMap.put(tmpid,tmpopt);
					tmpvalueMap.put(tmpid,tmpvalue);
					tmpnameMap.put(tmpid,tmpname);
					tmpopt1Map.put(tmpid,tmpopt1);
					tmpvalue1Map.put(tmpid,tmpvalue1);
				}
				
		}
	}

%>
  <table width=100% class=viewform>
    <COLGROUP> 
	<COL width="15%"> 
	<COL width="35%"> 
	<COL width="15%"> 
	<COL width="35%">
    <TR class=title>
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
    </TR>
    <TR style="height: 1px" >
      <TD class=line1 colspan=4></TD>
    </TR>

<%

    Map fieldNameMap=new HashMap();
    Map fieldLabelMap=new HashMap();
    Map fieldHtmlTypeMap=new HashMap();
    Map fieldTypeMap=new HashMap();
    Map fieldDbTypeMap=new HashMap();

    CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",secCategoryId);
    cfm.getCustomFields();
    while(cfm.next()){
        String id = String.valueOf(cfm.getId());
        String name = "field"+cfm.getId();
        String label = cfm.getLable();
        String htmltype = cfm.getHtmlType();
        String type = String.valueOf(cfm.getType());
        String fielddbtype=Util.null2String(cfm.getFieldDbType());
		
		fieldNameMap.put(id,name);
		fieldLabelMap.put(id,label);
		fieldHtmlTypeMap.put(id,htmltype);
		fieldTypeMap.put(id,type);
		fieldDbTypeMap.put(id,fielddbtype);
	}

    
    int tempSecCategoryId=0;
    int tempDocPropertyId=0;
	int tempIsCond=0;
    int tempCondColumnWidth=0;

	int j = 1;
    int tmpcount = 0;
    SecCategoryCustomSearchComInfo.setTofirstRow();
	while(SecCategoryCustomSearchComInfo.next()){

		tempSecCategoryId=Util.getIntValue(SecCategoryCustomSearchComInfo.getSecCategoryId(),0);
		if(tempSecCategoryId!=secCategoryId){
			continue;
		}

		tempIsCond=Util.getIntValue(SecCategoryCustomSearchComInfo.getIsCond(),0);
		if(tempIsCond!=1){
			continue;
		}

		tempDocPropertyId=Util.getIntValue(SecCategoryCustomSearchComInfo.getDocPropertyId(),0);
		tempCondColumnWidth=Util.getIntValue(SecCategoryCustomSearchComInfo.getCondColumnWidth(),0);

			int tempLabelId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(tempDocPropertyId+""));
			String tempCustomName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(tempDocPropertyId+""));
			
			int tempType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType(tempDocPropertyId+""));
			
			String tempName = (tempCustomName.equals("")&&tempLabelId>0)?SystemEnv.getHtmlLabelName(tempLabelId, user.getLanguage()):tempCustomName;

			int tempIndexId=tempName.lastIndexOf("(自定义)");
			if(tempIndexId<=0){
				tempIndexId=tempName.lastIndexOf("(user-defined)");
			}
			if(tempIndexId>0){
				tempName=tempName.substring(0,tempIndexId);
			}

			    String id = Util.null2String(SecCategoryDocPropertiesComInfo.getFieldId(tempDocPropertyId+""));

		if(tempCondColumnWidth>1){
			if(j==2){
	%>
			</TR>
			<TR style="height: 1px">
				<TD class=Line colSpan=4></TD>
			</TR>
	<%
			}
			j=3;
		}

	%>
			<% if(j==1||j==3){ %>
			<TR height="18">
			<% } %>

			<td>
<%
				if(tempType==0){

%>
	            <input type='checkbox' name='check_con'  value="<%=id%>" <%if(!"".equals(Util.null2String((String)tmpcolnameMap.get(id)))){%>checked<%}%>>
<%
				}else if(tempType==1){
%>
	            <input type='checkbox' name='check_con_<%=tempType%>'  value="<%=tempType%>" <%if(!"".equals(docsubject)){%>checked<%}%>>
<%
				}else if(tempType==9){//部门
%>
	            <input type='checkbox' name='check_con_<%=tempType%>'  value="<%=tempType%>" <%if(departmentid>0){%>checked<%}%>>
<%
				}else if(tempType==21){//文档所有者
%>
	            <input type='checkbox' name='check_con_<%=tempType%>'  value="<%=tempType%>" <%if(ownerid>0){%>checked<%}%>>
<%
				}
%>
	            <%=tempName%></td>
			<td class=field <%if(j==3){%>colspan="3"<%}%>>
			<%

			if(tempType==1){
%>
	            <input class=InputStyle type="text"  name="docsubject" value="<%=docsubject%>" onfocus="changeCheckConType('<%=tempType%>')">
<%
			}else if(tempType==9){//部门
%>
	            <button type='button' onfocus="changeCheckConType('<%=tempType%>')" class=Browser  onClick="onShowDept('departmentspan','departmentid')"></button>
                          <span id=departmentspan>
                          <%if(departmentid!=0){%>
                          <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid+""),user.getLanguage())%>
                          <%}%>
                          </span>
                          <input type="hidden" name="departmentid" value="<%=departmentid%>">
<%
			}else if(tempType==21){//文档所有者
%>
	            <button type='button' onfocus="changeCheckConType('<%=tempType%>')" class=Browser onClick="onShowResourceThisJsp('ownerspan','ownerid')"></button>
						  <span id=ownerspan>

                          <%=Util.toScreen(ResourceComInfo.getResourcename(ownerid+""),user.getLanguage())%>

                          </span>
                            <input type="hidden" name="ownerid" value="<%=ownerid%>">
<%
			}else if(tempType==0){


			    tmpcount ++;

			    String name = Util.null2String((String)fieldNameMap.get(id));
			    String label = Util.null2String((String)fieldLabelMap.get(id));
			    String htmltype = Util.null2String((String)fieldHtmlTypeMap.get(id));
			    String type = Util.null2String((String)fieldTypeMap.get(id));
			    String fielddbtype = Util.null2String((String)fieldDbTypeMap.get(id));

                tmpopt = Util.null2String((String)tmpoptMap.get(id));
                tmpvalue = Util.null2String((String)tmpvalueMap.get(id));
                tmpname = Util.null2String((String)tmpnameMap.get(id));
                tmpopt1 = Util.null2String((String)tmpopt1Map.get(id));
                tmpvalue1 = Util.null2String((String)tmpvalue1Map.get(id));
%>


      

      <input type=hidden name="con<%=id%>_id" value="<%=id%>">
      <input type=hidden name="con<%=id%>_colname" value="<%=name%>">

    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
    <%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        <option value="3" <%if("3".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="4" <%if("4".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>

      <input type=text class=inputstyle size=12 name="con<%=id%>_value" value="<%=tmpvalue%>" onfocus="changelevel('<%=tmpcount%>')"  >

    <%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if("3".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if("4".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if("5".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if("6".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

      <input type=text class=inputstyle size=12 name="con<%=id%>_value" value="<%=tmpvalue%>"  onfocus="changelevel('<%=tmpcount%>')" >

      <select class=inputstyle name="con<%=id%>_opt1"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if("3".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if("4".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if("5".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if("6".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

      <input type=text class=inputstyle size=12 name="con<%=id%>_value1" value="<%=tmpvalue1%>"  onfocus="changelevel('<%=tmpcount%>')"  >

    <%
}
else if(htmltype.equals("4")){
%>

      <input type=checkbox value=1 name="con<%=id%>_value" <%if("1".equals(tmpvalue)){%>checked<%}%> onfocus="changelevel('<%=tmpcount%>')" >

    <%}
else if(htmltype.equals("5")){
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>


      <select class=inputstyle name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')">
<%

    cfm.getSelectItem(Util.getIntValue(id,0));
    while(cfm.nextSelect()){
        String tmpselectvalue = cfm.getSelectValue();
        String tmpselectname = cfm.getSelectName();
%>
        <option value="<%=tmpselectvalue%>"  <%if(tmpvalue.equals(tmpselectvalue)){%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%
    }
%>
      </select>

    <%} else if(htmltype.equals("3") && !type.equals("2")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37")&& !type.equals("65")&& !type.equals("161")&& !type.equals("162")){
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

         <%
            //for test
            int sharelevel = 1;
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            if(type.equals("4") && sharelevel <2) {
                if(sharelevel == 1) browserurl = browserurl.trim() + "?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ;
                else browserurl = browserurl.trim() + "?sqlwhere=where id = " + user.getUserDepartment() ;
            }
         %>
        <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowDepartment('<%=id%>','<%=browserurl%>')"></button>
        <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
        <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
        String showname="";
        String tablename=BrowserComInfo.getBrowsertablename(type); //浏览框对应的表,比如人力资源表
        String columname=BrowserComInfo.getBrowsercolumname(type); //浏览框对应的表名称字段
        String keycolumname=BrowserComInfo.getBrowserkeycolumname(type);   //浏览框对应的表值字段
		
		String sql=null;
		if(tmpvalue.indexOf(",")!=-1){
			tmpvalue =tmpvalue.substring(1,tmpvalue.length());
			sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+tmpvalue+")";
		}else{
			if(tmpvalue.trim().equals("")){
				tmpvalue="-1";
			}
			sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+tmpvalue;
		}
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
			showname +=tempshowname+" ";
		}
%>
        <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if("3".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if("4".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if("5".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if("6".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

    <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','1')"></button>
      <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span> 

      <select class=inputstyle name="con<%=id%>_opt1"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if("3".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if("4".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if("5".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if("6".equals(tmpopt1)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

    <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','2')"></button>
      <input type=hidden name="con<%=id%>_value1" value="<%=tmpvalue1%>">
      <span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span> 
	 </td>
    <%} else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>

 <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
      <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	 String showname="";
     ArrayList tempshowidlist=Util.TokenizerString(tmpvalue,",");
	 for(int k=0;k<tempshowidlist.size();k++){
		 showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
	 }
%>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>

     <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value"value="<%=tmpvalue%>" >
      <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	 String showname="";
     ArrayList tempshowidlist=Util.TokenizerString(tmpvalue,",");
	 for(int k=0;k<tempshowidlist.size();k++){
		 showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
	 }
%>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含） %>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>

       <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
      <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	 String showname="";
     ArrayList tempshowidlist=Util.TokenizerString(tmpvalue,",");
	 for(int k=0;k<tempshowidlist.size();k++){
		 showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
	 }
%>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} else if(htmltype.equals("3") && type.equals("65")){ // 增加多角色的处理（包含，不包含） %>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
		  <button type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
      <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	 String showname="";
     ArrayList tempshowidlist=Util.TokenizerString(tmpvalue,",");
	 for(int k=0;k<tempshowidlist.size();k++){
		 showname+=RolesComInfo.getRolesRemark((String)tempshowidlist.get(k))+" ";
	 }
%>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} else if(htmltype.equals("3") && type.equals("161")){// 增加自定义多单选的处理（等于，不等于）
%>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            browserurl+="?type="+fielddbtype;
         %>
        <button class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCommon('<%=id%>','<%=browserurl%>','<%=type%>')"></button>
        <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
        <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
        String showname="";
		String showid =tmpvalue;                                     // 新建时候默认值
		try{
			Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
			BrowserBean bb=browser.searchById(showid);
			String bbdesc=Util.null2String(bb.getDescription());
			String bbname=Util.null2String(bb.getName());
			showname="<a title='"+bbdesc+"'>"+bbname+"</a>&nbsp";
		}catch(Exception e){
		}
%>
        <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%}  else if(htmltype.equals("3") && type.equals("162")){ // 增加自定义多选的处理（包含，不包含） %>

      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if("1".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if("2".equals(tmpopt)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            browserurl+="?type="+fielddbtype;
         %>
		  <button class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowserCommon('<%=id%>','<%=browserurl%>','<%=type%>')"></button>
      <input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
      <input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	 String showname="";
	 String showid =tmpvalue;                                     // 新建时候默认值
	 try{
		 Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
		 List l=Util.TokenizerString(showid,",");
		 for(int jindex=0;jindex<l.size();jindex++){
			 String curid=(String)l.get(jindex);
			 BrowserBean bb=browser.searchById(curid);
			 String bbname=Util.null2String(bb.getName());
			 String bbdesc=Util.null2String(bb.getDescription());
			 showname+="<a title='"+bbdesc+"'>"+bbname+"</a>&nbsp";
		 }
	 }catch(Exception e){
	 }
%>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=showname%></span> 
    <%} %>

<%
			}
%>
			</td>
			<% if(j==2||j==3){ %>
			</TR>
			<TR style="height: 1px">
				<TD class=Line colSpan=4></TD>
			</TR>
			<% } %>
<%
		j++;
		if(j>2) j=1;
    }
%>
	<% if(j==2){ %>
			</TR>
			<TR style="height: 1px">
				<TD class=Line colSpan=4></TD>
			</TR>
	<% } %>	
  </table>
<!-- 
<SCRIPT LANGUAGE=VBS>

sub onShowBrowser(id,url)
		id1 = window.showModalDialog(url&"?selectedids="&document.all("con"+id+"_value").value)

		if NOT isempty(id1) then
		    if id1(0)<> "" and id1(0)<> "0" then
				document.all("con"+id+"_valuespan").innerHtml = id1(1)
				document.all("con"+id+"_value").value=id1(0)
				document.all("con"+id+"_name").value=id1(1)
			else
				document.all("con"+id+"_valuespan").innerHtml = empty
				document.all("con"+id+"_value").value=""
				document.all("con"+id+"_name").value=""
			end if
		end if
end sub
sub onShowBrowser1(id,url,type1)
	if type1= 1 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("con"+id+"_valuespan").innerHtml = id1
		document.all("con"+id+"_value").value=id1
	elseif type1=2 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("con"+id+"_value1span").innerHtml = id1
		document.all("con"+id+"_value1").value=id1
	end if
end sub

sub onShowDept(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowResourceThisJsp(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
            document.getElementById(tdname).innerHtml = id(1)
            document.getElementById(inputename).value=id(0)
		else
            document.getElementById(tdname).innerHtml = empty
            document.getElementById(inputename).value=""

		end if
	end if
end sub
</script>
 -->
<script language=javascript>
function onShowBrowser1(id,url,type1){
	if(type1==1){
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
		$GetEle("con"+id+"_valuespan").innerHTML=id1;
    	$GetEle("con"+id+"_value").value=id1;
     }else if(type1==2){
    	id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
 		$GetEle("con"+id+"_value1span").innerHTML=id1;
     	$GetEle("con"+id+"_value1").value=id1;
     }
}
function onShowBrowser(id,url){
	datas = window.showModalDialog(url+"?selectedids="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
        	$GetEle("con"+id+"_valuespan").innerHTML=datas.name;
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}
function onShowDepartment(id,url){
	datas = window.showModalDialog(url+"?selectedDepartmentIds="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
            var shtml="";
            if(datas.name.indexOf(",")!=-1){
                 var namearray =datas.name.substr(1).split(",");
                 for(var i=0;i<namearray.length;i++){
                	 shtml +=namearray[i]+" ";
                 }
            }
        	$GetEle("con"+id+"_valuespan").innerHTML=shtml;
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}
function onShowResourceThisJsp(tdname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(datas){
        if( datas.id!= "" ){
			$GetEle(tdname).innerHTML= "<a href='javaScript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</a>";
			$GetEle(inputename).value=datas.id;
        }else{
        	$GetEle(tdname).innerHTML="";
        	$GetEle(inputename).value="";
		}
	}
}
function onShowDept(tdname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$GetEle(inputename).value);
	if (datas) {
        if (datas.id!=""){
        	$GetEle(tdname).innerHTML=datas.name;
        	$GetEle(inputename).value=datas.id;
        }
		else{
			$GetEle(tdname).innerHTML="";
			$GetEle(inputename).value="";
		}
	}
}
function changelevel(tmpindex) {  
    try { //如果只有一个数量的时候就会出现BUG
    	document.all("check_con")(tmpindex-1).checked = true
    } catch (ex)   {
      document.all("check_con").checked = true
    }
}

function changeCheckConType(type) {
	document.all("check_con_"+type).checked = true
}


function onShowBrowserCommon(id,url,type1){

		if(type1==162){
			tmpids = $GetEle("con"+id+"_value").value;
			url = url + "&beanids=" + tmpids;
			url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));

		}
		id1 = window.showModalDialog(url);

		if(id1){

				if(id1.id!=0 && id1.id!=""){

	               if (type1 == 162) {
				   		var ids = id1.id;
						var names =  id1.name;
						var descs =  id1.key3;
						shtml = ""
						ids = ids.substr(1);
						$GetEle("con"+id+"_value").value=ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							shtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("con"+id+"_valuespan").innerHTML=shtml;

						return;
	               }
				   if (type1 == 161) {
					   	var ids = id1.id;
					   	var names = id1.name;
						var descs =  id1.desc;
						$GetEle("con"+id+"_value").value=ids;
						shtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("con"+id+"_valuespan").innerHTML=shtml;
						return ;
				   }


				}else{
						$GetEle("con"+id+"_valuespan").innerHTML="";
						$GetEle("con"+id+"_value").value="";
						$GetEle("con"+id+"_name").value="";
				}

			}

}

</script>

<%
}
%>



