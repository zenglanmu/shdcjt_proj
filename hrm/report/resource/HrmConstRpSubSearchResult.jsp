<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<%
    String userid =""+user.getUID();
    /*权限判断,人力资产管理员以及其所有上级*/
    boolean canView = false;
    ArrayList allCanView = new ArrayList();
    String tempsql ="select resourceid from HrmRoleMembers where resourceid>1 and roleid in (select roleid from SystemRightRoles where rightid=22)";
    RecordSet.executeSql(tempsql);
    while(RecordSet.next()){
        String tempid = RecordSet.getString("resourceid");
        allCanView.add(tempid);
        AllManagers.getAll(tempid);
        while(AllManagers.next()){
            allCanView.add(AllManagers.getManagerID());
        }
    }// end while
    for (int i=0;i<allCanView.size();i++){
        if(userid.equals((String)allCanView.get(i))){
            canView = true;
        }
    }
    if(!canView) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
    /*权限判断结束*/

    int scopeId = Util.getIntValue(request.getParameter("scopeId"),0);
    String[] checkcons = request.getParameterValues("check_con");
    String sqlwhere = "";
    String temOwner = "tCustom";

    if(checkcons!=null){
        for(int i=0;i<checkcons.length;i++){
            String tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
            String tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
            String tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
            String tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
            String tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
            String tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
            String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));
            //生成where子句
            if((tmphtmltype.equals("1")&& tmptype.equals("1"))||tmphtmltype.equals("2")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(tmpopt.equals("1")) {
                if("oracle".equals(RecordSet.getDBType())){
                sqlwhere+=tmpvalue.equals("")?" is null":" ='"+tmpvalue +"' ";
                }else   sqlwhere+=" ='"+tmpvalue +"' ";
                }	
                if(tmpopt.equals("2")){
                if("oracle".equals(RecordSet.getDBType())){
               sqlwhere+=tmpvalue.equals("")?" is not null":"<>'"+tmpvalue +"' ";
                }else    sqlwhere+=" <>'"+tmpvalue +"' ";
                }	
                if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
                if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
            }else if(tmphtmltype.equals("1")&& !tmptype.equals("1")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                    if(!tmpvalue.equals("")){
                    if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";

                    if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }else{    //第一个日期为空
                 	if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
                    if(tmpopt.equals("5")){ 	
  	                    if("oracle".equals(RecordSet.getDBType())){
	                  		sqlwhere+=tmpvalue.equals("")?" is null":" ='"+tmpvalue +"' ";
	                	}else   sqlwhere+=" ='"+tmpvalue +"' ";
	                }	
                    if(tmpopt.equals("6"))	{ 	
	                    if("oracle".equals(RecordSet.getDBType())){
	                  		sqlwhere+=tmpvalue.equals("")?" is not null":" <>'"+tmpvalue +"' ";
	                	}else   sqlwhere+=" ='"+tmpvalue +"' ";
	                }	
                   if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }
                if(!tmpvalue1.equals("")){
                    if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
                }
            }
            else if(tmphtmltype.equals("4")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
                else sqlwhere +="='1' ";
            }
            else if(tmphtmltype.equals("5")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
          //      if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
          //      if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
              if(tmpopt.equals("1")) {
                if("oracle".equals(RecordSet.getDBType())){
                  sqlwhere+=tmpvalue.equals("")?" is null":" ='"+tmpvalue +"' ";
                }else   sqlwhere+=" ='"+tmpvalue +"' ";
                }	
                if(tmpopt.equals("2")){
                if("oracle".equals(RecordSet.getDBType())){
                  sqlwhere+=tmpvalue.equals("")?" is not null":"<>'"+tmpvalue+"' or "+temOwner+"."+tmpcolname +" is  null ";
                }else    sqlwhere+=" <>'"+tmpvalue +"' ";
                }	
            }
            else if(tmphtmltype.equals("3") && !tmptype.equals("2") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")&& !tmptype.equals("65") ){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
             //   if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
             //   if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
                 if(tmpopt.equals("1")) {
                if("oracle".equals(RecordSet.getDBType())){
                  sqlwhere+=tmpvalue.equals("")?" is null":" ='"+tmpvalue +"' ";
                }else   sqlwhere+=" ='"+tmpvalue +"' ";
                }	
                if(tmpopt.equals("2")){
                if("oracle".equals(RecordSet.getDBType())){
                  sqlwhere+=tmpvalue.equals("")?" is not null":"<>'"+tmpvalue+"' or "+temOwner+"."+tmpcolname +" is  null ";
                }else    sqlwhere+=" <>'"+tmpvalue +"' ";
                }	
                
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("2")||tmptype.equals("19"))){ // 对日期处理
            //对 日期处理 加入了 非空情况下的处理 
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("")){   //第一个日期不为空时
                    if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";
                    if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }else{    //第一个日期为空
                 	if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
                    if(tmpopt.equals("5")){ 	
  	                    if("oracle".equals(RecordSet.getDBType())){
	                  		sqlwhere+=tmpvalue.equals("")?" is null":" ='"+tmpvalue +"' ";
	                	}else   sqlwhere+=" ='"+tmpvalue +"' ";
	                }	
                    if(tmpopt.equals("6"))	{ 	
	                    if("oracle".equals(RecordSet.getDBType())){
	                  		sqlwhere+=tmpvalue.equals("")?" is not null":" <>'"+tmpvalue +"' ";
	                	}else   sqlwhere+=" ='"+tmpvalue +"' ";
	                }	
                   if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }
                if(!tmpvalue1.equals("")){ //第二个日期不为空
               	    if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
                }
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("17") || tmptype.equals("18") || tmptype.equals("37") || tmptype.equals("65") )){       // 对多人力资源，多客户，多文档的处理
                sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
                if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
                if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
            }

            sqlwhere +=") ";

        }
    }

    String selectSql = "";

    rs.executeSql("select colname,showorder from HrmRpSubDefine where scopeid="+scopeId+" and resourceid="+userid+" order by showorder");
    ArrayList allCols= new ArrayList();
    while(rs.next()){
        allCols.add(rs.getString("colname"));
    }

    if(!sqlwhere.equals("")){
        sqlwhere = sqlwhere.substring(3);   //去掉and关键字
    }

 if(scopeId == 1){
        sqlwhere = Util.StringReplace(sqlwhere,temOwner+".field",temOwner+"2.field");
        if(!sqlwhere.equals("")){
            sqlwhere = " where "+sqlwhere;
        }
        //modify by xiaofeng bug1360
        selectSql ="select "+temOwner+".*,"+temOwner+"2"+".* from HrmResource "+temOwner+" left join cus_fielddata "+temOwner+"2 " + " on "+temOwner+".id="+temOwner+"2.id and " + temOwner+"2.scope='HrmCustomFieldByInfoType' and "+ temOwner+"2.scopeid="+scopeId+sqlwhere;        
        RecordSet.executeSql(selectSql);
    }else if(scopeId == 3){
        sqlwhere = Util.StringReplace(sqlwhere,temOwner+".field",temOwner+"2.field");
        if(!sqlwhere.equals("")){
            sqlwhere = " where "+sqlwhere;
        }
        //modify by xiaofeng bug1360
        selectSql ="select "+temOwner+".*,"+temOwner+"2"+".* from HrmResource "+temOwner+" left join cus_fielddata "+temOwner+"2 " + " on "+temOwner+".id="+temOwner+"2.id and " + temOwner+"2.scope='HrmCustomFieldByInfoType' and "+ temOwner+"2.scopeid="+scopeId+sqlwhere;
        
        RecordSet.executeSql(selectSql);
    }else if(scopeId == 3){
        sqlwhere = Util.StringReplace(sqlwhere,temOwner+".field",temOwner+"2.field");
        if(!sqlwhere.equals("")){
            sqlwhere = " and "+sqlwhere;
        }
        selectSql ="select "+temOwner+".* from HrmResource "+temOwner+",cus_fielddata "+temOwner+"2 " + " where "+temOwner+".id="+temOwner+"2.id and " + temOwner+"2.scope='HrmCustomFieldByInfoType' and "+ temOwner+"2.scopeid="+scopeId+sqlwhere;
        //System.out.println("selectSql = " + selectSql);

        RecordSet.executeSql(selectSql);
    }else if(scopeId == -10){
        if(!sqlwhere.equals("")){
            sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
        }else{
            sqlwhere = " where "+temOwner+".resourceid=t1.id ";
        }
        selectSql ="select "+temOwner+".* from HrmFamilyInfo "+temOwner+", HrmResource t1 "+sqlwhere;
        RecordSet.executeSql(selectSql);
    }else if(scopeId == -11){
        if(!sqlwhere.equals("")){
            sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
        }else{
            sqlwhere = " where "+temOwner+".resourceid=t1.id ";
        }
        selectSql ="select "+temOwner+".* from HrmLanguageAbility "+temOwner+", HrmResource t1 "+sqlwhere;
        RecordSet.executeSql(selectSql);
    }else if(scopeId == -12){
        if(!sqlwhere.equals("")){
            sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
        }else{
            sqlwhere = " where "+temOwner+".resourceid=t1.id ";
        }
        selectSql ="select "+temOwner+".* from HrmEducationInfo "+temOwner+", HrmResource t1 "+sqlwhere;
        RecordSet.executeSql(selectSql);
    }else if(scopeId == -13){
        if(!sqlwhere.equals("")){
            sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
        }else{
            sqlwhere = " where "+temOwner+".resourceid=t1.id ";
        }
        selectSql ="select "+temOwner+".* from HrmWorkResume "+temOwner+", HrmResource t1 "+sqlwhere;
        RecordSet.executeSql(selectSql);
    }else if(scopeId == -14){
        if(!sqlwhere.equals("")){
            sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
        }else{
            sqlwhere = " where "+temOwner+".resourceid=t1.id ";
        }
        selectSql ="select "+temOwner+".* from HrmTrainBeforeWork "+temOwner+", HrmResource t1 "+sqlwhere;
        RecordSet.executeSql(selectSql);
    }else if(scopeId == -15){
        if(!sqlwhere.equals("")){
            sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
        }else{
            sqlwhere = " where "+temOwner+".resourceid=t1.id ";
        }
        selectSql ="select "+temOwner+".* from HrmCertification "+temOwner+", HrmResource t1 "+sqlwhere;
        RecordSet.executeSql(selectSql);
    }else if(scopeId == -16){
        if(!sqlwhere.equals("")){
            sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
        }else{
            sqlwhere = " where "+temOwner+".resourceid=t1.id ";
        }
        selectSql ="select "+temOwner+".* from HrmRewardBeforeWork "+temOwner+", HrmResource t1 "+sqlwhere;
        RecordSet.executeSql(selectSql);
    }
    System.out.println("selectSql = " + selectSql);
%>
<%@ include file="HrmConstRpDataDefine.jsp" %>
<HTML>
<HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage()) ;
    String needfav ="1";
    String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(15518,user.getLanguage())+",javascript:window.history.back(-1),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
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


<%----------------------------自定义明细字段 begin--------------------------------------------%>

<%

    int colcount1 = allCols.size() ;
    int colwidth1 = 0 ;

    if( colcount1 != 0 ) {
        colwidth1 = 90/colcount1 ;

%>
    <table Class=ListStyle id="oTable"  cellspacing="1" cellpadding="0">
        <tr class=header>
            <td width="<%=10%>%" nowrap><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
<%
        for(int j=0; j<cids.size(); j++){
            for(int i=0; i<allCols.size(); i++){
                if(allCols.get(i).equals(cNames.get(j))){
                    String fieldlable =String.valueOf(cFieldLabel.get(j));
%>
            <td width="<%=colwidth1%>%" nowrap><%=fieldlable%></td>
<%
                    break;
                }
            }
        }
%>
        </tr>
<%

        boolean isttLight = false;
        while(RecordSet.next()){
            isttLight = !isttLight ;
%>
        <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
            <td width="<%=10%>%" nowrap>
                <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("resourceid").equals("")?RecordSet.getString("id"):RecordSet.getString("resourceid")%>"><%=ResourceComInfo.getLastname(RecordSet.getString("resourceid").equals("")?RecordSet.getString("id"):RecordSet.getString("resourceid"))%></a><br>

            </td>
<%
            for(int j=0; j<cids.size(); j++){
                for(int i=0; i<allCols.size(); i++){
                    if(allCols.get(i).equals(cNames.get(j))){
                        String fieldhtmltype = cHtmlType.get(j).toString();
                        String fieldtype= cType.get(j).toString();
                        String fieldvalue =  Util.null2String(RecordSet.getString(cNames.get(j).toString())) ;

%>
            <td class=field nowrap style="TEXT-VALIGN: center">
<%
                        if(fieldhtmltype.equals("1")||fieldhtmltype.equals("2")){                          // 单行文本框
%>
                <%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>
<%
                        }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                            String showname = "";                                   // 新建时候默认值显示的名称
                            String showid = "";                                     // 新建时候默认值

                            String newdocid = Util.null2String(request.getParameter("docid"));

                            if( fieldtype.equals("37") && !newdocid.equals("")) {
                                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                                fieldvalue += newdocid ;
                            }

                            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                                showname=fieldvalue; // 日期时间
                            }else if(!fieldvalue.equals("")) {
                                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                                String sql = "";

                                HashMap temRes = new HashMap();

                                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")) {    // 多人力资源,多客户,多会议，多文档
                                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                                }
                                else {
                                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                                }

                                rs.executeSql(sql);
                                while(rs.next()){
                                    showid = Util.null2String(rs.getString(1)) ;
                                    String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
                                    temRes.put(String.valueOf(showid),tempshowname);
                                }
                                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                                String temstkvalue = "";
                                while(temstk.hasMoreTokens()){
                                    temstkvalue = temstk.nextToken();

                                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                                        showname += temRes.get(temstkvalue);
                                    }
                                }

                            }
%>
                    <%=showname%>
<%
                        }else if(fieldhtmltype.equals("4")) {                    // check框
%>
                <input type=checkbox disabled <%if(fieldvalue.equals("1")){%> checked <%}%> >
<%
                        }else if(fieldhtmltype.equals("5")){
                            String showname = "";
                            //System.out.println("fieldhtmltype = " + fieldhtmltype);
                            //System.out.println("fieldtype = " + fieldtype);
                            //System.out.println("fieldvalue = " + fieldvalue);
                            if(fieldtype.equals("1")){
                                if(fieldvalue.equals("0")){
                                    showname = SystemEnv.getHtmlLabelName(154,user.getLanguage());
                                }else if(fieldvalue.equals("1")){
                                    showname = SystemEnv.getHtmlLabelName(821,user.getLanguage());
                                }else if(fieldvalue.equals("3")){
                                    showname = SystemEnv.getHtmlLabelName(822,user.getLanguage());
                                }else if(fieldvalue.equals("4")){
                                    showname = SystemEnv.getHtmlLabelName(823,user.getLanguage());
                                }
                            }else if(fieldtype.equals("2")){
                                if(fieldvalue.equals("0")){
                                    showname = SystemEnv.getHtmlLabelName(470,user.getLanguage());
                                }else if(fieldvalue.equals("1")){
                                    showname = SystemEnv.getHtmlLabelName(471,user.getLanguage());
                                }else if(fieldvalue.equals("2")){
                                    showname = SystemEnv.getHtmlLabelName(472,user.getLanguage());
                                }
                            }else if(fieldtype.equals("3")){
                                if(fieldvalue.equals("0")){
                                    showname = SystemEnv.getHtmlLabelName(161,user.getLanguage());
                                }else if(fieldvalue.equals("1")){
                                    showname = SystemEnv.getHtmlLabelName(163,user.getLanguage());
                                }
                            }else if(fieldtype.equals("4")){
                                if(fieldvalue.equals("0")){
                                    showname = SystemEnv.getHtmlLabelName(824,user.getLanguage());
                                }else if(fieldvalue.equals("1")){
                                    showname = SystemEnv.getHtmlLabelName(821,user.getLanguage());
                                }else if(fieldvalue.equals("3")){
                                    showname = SystemEnv.getHtmlLabelName(154,user.getLanguage());
                                }else if(fieldvalue.equals("4")){
                                    showname = SystemEnv.getHtmlLabelName(825,user.getLanguage());
                                }
                            }else if(fieldtype.equals("0")){
                                CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
                                cfm.getSelectItem(Integer.parseInt(cids2.get(j)+""));
                                //cfm.getSelectItem(cfm.getId());
                                while(cfm.nextSelect()){
                                    if(cfm.getSelectValue().equals(fieldvalue)){
                                        showname = cfm.getSelectName();
                                        break;
                                    }
                                }
                            }
%>
            <%=showname%>
<%
                        }
%>
            </td>
<%
                        break;
                    }
                }
            }
        }

%>
        </tr>

        </table>
<%
    }
%>

<%----------------------------自定义明细字段 end  --------------------------------------------%>

		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</body>