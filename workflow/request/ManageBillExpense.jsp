<%@ page import="java.math.*" %>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfobill" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillExpenseOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

  <jsp:include page="WorkflowManageRequestBodyAction.jsp" flush="true">
                
	<jsp:param name="requestname" value="<%=requestname%>" />
	<jsp:param name="userid" value="<%=userid%>" />
    <jsp:param name="languageid" value="<%=languageidtemp%>" />
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestmark" value="<%=requestmark%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
	<jsp:param name="isbill" value="1" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
	<jsp:param name="topage" value="<%=topage%>" />
	 <jsp:param name="newenddate" value="<%=newenddate%>" />
	<jsp:param name="newfromdate" value="<%=newfromdate%>" />
	 <jsp:param name="docfileid" value="<%=docfileid%>" />
	<jsp:param name="newdocid" value="<%=newdocid%>" />
            </jsp:include>

    <script language=javascript>
        fieldorders = new Array() ;
        isedits = new Array() ;
        ismands = new Array() ;
    </script>
<%
    //获取明细表设置
    WFNodeDtlFieldManager.resetParameter();
    WFNodeDtlFieldManager.setNodeid(Util.getIntValue(""+nodeid));
    WFNodeDtlFieldManager.setGroupid(0);
    WFNodeDtlFieldManager.selectWfNodeDtlField();
    String dtladd = WFNodeDtlFieldManager.getIsadd();
    String dtledit = WFNodeDtlFieldManager.getIsedit();
    String dtldelete = WFNodeDtlFieldManager.getIsdelete();
    String dtldefault = WFNodeDtlFieldManager.getIsdefault();
    String dtlneed = WFNodeDtlFieldManager.getIsneed();
    
    boolean canedit = false;
    if("1".equals(dtledit)){
        canedit = true;
    }
    
    String isaffirmancebody=Util.null2String((String)session.getAttribute(user.getUID()+""+requestid+"isaffirmance"));//是否需要提交确认
    String reEditbody=Util.null2String((String)session.getAttribute(user.getUID()+""+requestid+"reEdit"));//是否需要提交确认
%>
    <table class="viewform">
        <% if(!isaffirmancebody.equals("1")|| reEditbody.equals("1")) { %>
        <tr>
            <td>
            <%if(dtladd.equals("1")){%>
            <button type=button  Class=BtnFlow type=button accessKey=A onclick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            <%}
            if(dtladd.equals("1") || dtldelete.equals("1")){%>
            <button type=button  Class=BtnFlow type=button accessKey=E onclick="deleteRow1();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            <%}%>
            </td>
        </tr>
        <%  } %>
        <TR class="Spacing" style="height:1px;">
            <TD class="Line1"></TD>
        </TR>
        <tr>
            <td>
            <%
			ArrayList fieldids=new ArrayList();             //字段队列
			ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
			ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
			ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
			ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
			ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
			ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
			ArrayList fieldvalues=new ArrayList();          //字段的值
			ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
			
            int colcount = 0 ;
            int colwidth = 0 ;
            fieldids.clear() ;
            fieldlabels.clear() ;
            fieldhtmltypes.clear() ;
            fieldtypes.clear() ;
            fieldnames.clear() ;
            fieldviewtypes.clear() ;

            RecordSet.executeProc("workflow_billfield_Select",formid+"");
            while(RecordSet.next()){
                String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
                if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示

                fieldids.add(Util.null2String(RecordSet.getString("id")));
                fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
                fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
                fieldtypes.add(Util.null2String(RecordSet.getString("type")));
                fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
                fieldviewtypes.add(theviewtype);
            }
			ArrayList isfieldids=new ArrayList();              //字段队列
			ArrayList isviews=new ArrayList();              //字段是否显示队列

			ArrayList ismands=new ArrayList();              //字段队列
			ArrayList isedits=new ArrayList();              //字段是否显示队列
			
            // 确定字段是否显示，是否可以编辑，是否必须输入
            isfieldids.clear() ;              //字段队列
            isviews.clear() ;              //字段是否显示队列
            isedits.clear() ;              //字段是否可以编辑队列
            ismands.clear() ;              //字段是否必须输入队列

            RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
            while(RecordSet.next()){
                String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                if( thefieldidindex == -1 ) continue ;
                String theisview = Util.null2String(RecordSet.getString("isview")) ;
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
                isedits.add(Util.null2String(RecordSet.getString("isedit")));
                ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
            }

            if( colcount != 0 ) colwidth = 95/colcount ;


    %>
            <table class=liststyle cellspacing=1   id="oTable">
              <COLGROUP>
              <tr class=header>
              <% if((!isaffirmancebody.equals("1")|| reEditbody.equals("1"))  ) { %>
              <td width="5%"><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
              <%}%>
   <%
            ArrayList viewfieldnames = new ArrayList() ;

            // 得到每个字段的信息并在页面显示
            int detailfieldcount = -1 ;

            for(int i=0;i<fieldids.size();i++){         // 循环开始

                String fieldid=(String)fieldids.get(i);  //字段id
                String isview="0" ;    //字段是否显示
                String isedit="0" ;    //字段是否可以编辑
                String ismand="0" ;    //字段是否必须输入

                int isfieldidindex = isfieldids.indexOf(fieldid) ;
                if( isfieldidindex != -1 ) {
                    isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
                    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
                }
                if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环

                String fieldname = "" ;                         //字段数据库表中的字段名
                String fieldlable = "" ;                        //字段显示名
                int languageid = 0 ;

                fieldname=(String)fieldnames.get(i);
                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%"><%=fieldlable%></td>
                <script language=javascript>
                    <% if (fieldname.equals("relatedate")) { detailfieldcount++ ;%>
                    fieldorders[<%=detailfieldcount%>] = 1 ;
                    <% } else if (fieldname.equals("feetypeid")) { detailfieldcount++ ;%>
                    fieldorders[<%=detailfieldcount%>] = 2 ;
                    <% } else if (fieldname.equals("detailremark")) { detailfieldcount++ ;%>
                    fieldorders[<%=detailfieldcount%>] = 3 ;
                    <% } else if (fieldname.equals("accessory")) { detailfieldcount++ ;%>
                    fieldorders[<%=detailfieldcount%>] = 4 ;
                    <% } else if (fieldname.equals("relatedcrm")) { detailfieldcount++ ;%>
                    fieldorders[<%=detailfieldcount%>] = 5 ;
                    <% } else if (fieldname.equals("relatedproject")) { detailfieldcount++ ;%>
                    fieldorders[<%=detailfieldcount%>] = 6 ;
                    <% } else if (fieldname.equals("feesum")) { detailfieldcount++ ;%>
                    fieldorders[<%=detailfieldcount%>] = 7 ;
                    <% } else if (fieldname.equals("realfeesum")) { detailfieldcount++ ;%>
                    fieldorders[<%=detailfieldcount%>] = 8 ;
                    <% } else if (fieldname.equals("invoicenum")) { detailfieldcount++ ;%>
                    fieldorders[<%=detailfieldcount%>] = 9 ;
					<% } else if (fieldname.equals("relaterequest")) { detailfieldcount++ ;%>
                      fieldorders[<%=detailfieldcount%>] = 10 ;
                    <% } %>
                    isedits[<%=detailfieldcount%>] = <%=isedit%> ;
                    ismands[<%=detailfieldcount%>] = <%=ismand%> ;
                </script>
<%          }
%>
              </tr>
<%
            BigDecimal countexpense = new BigDecimal("0") ;
            BigDecimal countrealfeefum = new BigDecimal("0") ;
            int countaccessory = 0 ;
            boolean isttLight = false;
            int recorderindex = 0 ;

            RecordSet.executeProc("Bill_ExpenseDetali_SelectByID",billid+"");
            while(RecordSet.next()) {
                isttLight = !isttLight ;
%>
              <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
                <% if( (!isaffirmancebody.equals("1")|| reEditbody.equals("1")) ) { %>
            <td>
            <input type='checkbox' name='check_node' id='check_node' value="<%=RecordSet.getString("id")%>" <%if(!dtldelete.equals("1")){%>disabled<%}%>>
            </td>
            <%}else{%>
            	&nbsp;
          	<%}%>
<%
                for(int i=0;i<fieldids.size();i++){         // 循环开始

                    String fieldid=(String)fieldids.get(i);  //字段id
                    String isview="0" ;    //字段是否显示
                    String isedit="0" ;    //字段是否可以编辑
                    String ismand="0" ;    //字段是否必须输入

                    int isfieldidindex = isfieldids.indexOf(fieldid) ;
                    if( isfieldidindex != -1 ) {
                        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                        isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
                        ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
                    }

                    String fieldname = (String)fieldnames.get(i);   //字段数据库表中的字段名
                    String fieldvalue =  Util.null2String(RecordSet.getString(fieldname)) ;

                    if( ! isview.equals("1") ) {
%>
                    <input type=hidden name="<%=fieldname%>_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
                    }
                    else {
                        if(ismand.equals("1"))  needcheck+= ","+fieldname+"_"+recorderindex;
                        //如果必须输入,加入必须输入的检查中
%>                  <td>
<%
                        String showname = "" ;
                        if( fieldname.equals("relatedate"))  {
                            showname = fieldvalue ;
                            if(isedit.equals("1") && isremark==0 &&canedit){
%>
                    <button type=button  class=Browser onclick="onShowDate(relatedatespan_<%=recorderindex%>,relatedate_<%=recorderindex%>,<%=ismand%>)"></button>
<%
                            }
%>
                    <span id="relatedatespan_<%=recorderindex%>"><%=showname%>
<%
                            if( ismand.equals("1") && fieldvalue.equals("") ){
%>
                    <img src="/images/BacoError.gif" align=absmiddle>
<%
                            }
%>
                    </span> <input type=hidden id="relatedate_<%=recorderindex%>" name="relatedate_<%=recorderindex%>"  value="<%=fieldvalue%>">
<%
	                    }                                               // 日期按钮条件结束
                        else if( fieldname.equals("feetypeid"))  {
                            showname = Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(fieldvalue),user.getLanguage()) ;
                            if( fieldvalue.equals("0") ) fieldvalue = "" ;
                            if(isedit.equals("1") && isremark==0 &&canedit){
%>
                    <button type=button  class=Browser onclick="onShowFeetype('feetypeidspan_<%=recorderindex%>','feetypeid_<%=recorderindex%>',<%=ismand%>)"></button>
<%
                            }
%>
                    <span id="feetypeidspan_<%=recorderindex%>"><%=showname%>
<%
                            if( ismand.equals("1") && fieldvalue.equals("") ){
%>
                    <img src="/images/BacoError.gif" align=absmiddle>
<%
                            }
%>
                    </span> <input type=hidden id="feetypeid_<%=recorderindex%>" name="feetypeid_<%=recorderindex%>"  value="<%=fieldvalue%>">
<%
	                    }                                               // feetypeid 按钮条件结束

                        else if( fieldname.equals("relatedcrm")) {
                            showname = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(fieldvalue),user.getLanguage()) ;
                            if( fieldvalue.equals("0") ) fieldvalue = "" ;
                            if(isedit.equals("1") && isremark==0 &&canedit){
%>
                    <button type=button  class=Browser onclick="onShowCustomer('relatedcrmspan_<%=recorderindex%>','relatedcrm_<%=recorderindex%>',<%=ismand%>)"></button>
<%
                            }
%>
                    <span id="relatedcrmspan_<%=recorderindex%>">
                    <a href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=fieldvalue%>'><%=showname%></a>
                    
<%
                    if( ismand.equals("1") && fieldvalue.equals("") ){
%>
                    <img src="/images/BacoError.gif" align=absmiddle>
<%
                            }
%>
                    </span> <input type=hidden id="relatedcrm_<%=recorderindex%>" name="relatedcrm_<%=recorderindex%>"  value="<%=fieldvalue%>">
<%
	                    }                                               // customerid 按钮条件结束

                        else if( fieldname.equals("relatedproject"))  {
                            showname =  Util.toScreen(ProjectInfoComInfo.getProjectInfoname(fieldvalue),user.getLanguage()) ;
                            if( fieldvalue.equals("0") ) fieldvalue = "" ;
                            if(isedit.equals("1") && isremark==0 &&canedit){
%>
                    <button type=button  class=Browser onclick="onShowProject('relatedprojectspan_<%=recorderindex%>','relatedproject_<%=recorderindex%>',<%=ismand%>)"></button>
<%
                            }
%>
                    <span id="relatedprojectspan_<%=recorderindex%>"> 
                    <a href='/proj/data/ViewProject.jsp?ProjID=<%=fieldvalue%>'><%=showname%></a>
<%
                            if( ismand.equals("1") && fieldvalue.equals("") ){
%>
                    <img src="/images/BacoError.gif" align=absmiddle>
<%
                            }
%>
                    </span> <input type=hidden id="relatedproject_<%=recorderindex%>" name="relatedproject_<%=recorderindex%>"  value="<%=fieldvalue%>">
<%
	                    }                                               // projectid 按钮条件结束
                else if( fieldname.equals("relaterequest"))  {
                            int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                            tempnum++;
                            session.setAttribute("resrequestid"+tempnum,fieldvalue);
                            session.setAttribute("slinkwfnum",""+tempnum);
                            session.setAttribute("haslinkworkflow","1");
                            showname =  Util.toScreen(WorkflowRequestComInfobill.getRequestName(fieldvalue),user.getLanguage()) ;
                            if( fieldvalue.equals("0") ) fieldvalue = "" ;
                            if(isedit.equals("1") && isremark==0 &&canedit){
%>
                    <button type=button  class=Browser onclick="onShowRequest('relaterequestspan_<%=recorderindex%>', 'relaterequest_<%=recorderindex%>',<%=ismand%>)"></button>
<%
                            }
%>
                    <span id="relaterequestspan_<%=recorderindex%>"> 
                    <a href='/workflow/request/ViewRequest.jsp?isrequest=1&requestid=<%=fieldvalue%>&wflinkno=<%=tempnum%>' target='_new'><%=showname%></a>
<%
                            if( ismand.equals("1") && fieldvalue.equals("") ){
%>
                    <img src="/images/BacoError.gif" align=absmiddle>
<%
                            }
%>
                    </span> <input type=hidden id="relaterequest_<%=recorderindex%>" name="relaterequest_<%=recorderindex%>"  value="<%=fieldvalue%>">
                    <input type=hidden name='slink<%=fieldid%>_<%=recorderindex%>_rq0' value="<%=tempnum%>">
<%
	                    }                                               // request 按钮条件结束

                        else if( fieldname.equals("detailremark")) {
                            if(isedit.equals("1") && isremark==0 &&canedit){
                                if(ismand.equals("1")) {
%>
                    <input type=text class=inputstyle  name="detailremark_<%=recorderindex%>" style="width:85%" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" onChange="checkinput('detailremark_<%=recorderindex%>','detailremarkspan_<%=recorderindex%>')">
                    <span id="detailremarkspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
<%

                                }else{%>
                    <input type=text class=inputstyle  name="detailremark_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:85%">
<%                              }
                            }
                            else {
%>
                    <%=Util.toScreen(fieldvalue,user.getLanguage())%>
                    <input type=hidden name="detailremark_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
<%
                            }
                        }

                        else if( fieldname.equals("feesum")) {
                            if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                            else
                                countexpense = countexpense.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
                            if(isedit.equals("1") && isremark==0 &&canedit){
                                if(ismand.equals("1")) {
%>
                    <input type=text class=inputstyle  name="feesum_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('feesum_<%=recorderindex%>','feesumspan_<%=recorderindex%>');changenumber();">
                    <span id="feesumspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
<%
                                }else{
%>
                    <input type=text class=inputstyle  name="feesum_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this);changenumber();'>
<%                               }
                            }
                            else {
%>
                    <%=fieldvalue%><input type=hidden name="feesum_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
                            }
                        }

                        else if( fieldname.equals("realfeesum")) {
                            if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                            else
                                countrealfeefum = countrealfeefum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
                            if(isedit.equals("1") && isremark==0 &&canedit){
                                if(ismand.equals("1")) {
%>
                    <input type=text class=inputstyle  name="realfeesum_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('realfeesum_<%=recorderindex%>','realfeesumspan_<%=recorderindex%>');changereal();">
                    <span id="realfeesumspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
<%
                                }else{
%>
                    <input type=text class=inputstyle  name="realfeesum_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this);changereal();'>
<%                               }
                            }
                            else {
%>
                    <%=fieldvalue%><input type=hidden name="realfeesum_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
                            }
                        }

                        else if( fieldname.equals("accessory")) {
                            if( Util.getIntValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                            else countaccessory += Util.getIntValue(fieldvalue,0) ;
                            if(isedit.equals("1") && isremark==0 &&canedit){
                                if(ismand.equals("1")) {
%>
                    <input type=text class=inputstyle  name="accessory_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('accessory_<%=recorderindex%>','accessoryspan_<%=recorderindex%>');changeaccessory();">
                    <span id="accessoryspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
<%
                                }else{
%>
                    <input type=text class=inputstyle  name="accessory_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);changeaccessory();'>
<%                               }
                            }
                            else {
%>
                    <%=fieldvalue%><input type=hidden name="accessory_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
                            }
                        }
                        else if( fieldname.equals("invoicenum")) {
                            if(isedit.equals("1") && isremark==0 &&canedit){
                                if(ismand.equals("1")) {
%>
                    <input type=text class=inputstyle  name="invoicenum_<%=recorderindex%>" style="width:85%" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" onChange="checkinput('invoicenum_<%=recorderindex%>','invoicenumspan_<%=recorderindex%>')">
                    <span id="invoicenumspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
<%

                                }else{%>
                    <input type=text class=inputstyle  name="invoicenum_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:85%">
<%                              }
                            }
                            else {
%>
                    <%=Util.toScreen(fieldvalue,user.getLanguage())%>
                    <input type=hidden name="invoicenum_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
<%
                            }
                        }
%>
                    </td>
<%
                    }
                }
                recorderindex ++ ;
%>
              </tr>
<%          }   %>
              <tr class=TOTAL style="FONT-WEIGHT: bold; COLOR: red">
                <td>合计</td>
<%          for(int i=0;i<viewfieldnames.size();i++){
                String thefieldname = (String)viewfieldnames.get(i) ;
%>
                <td <% if(thefieldname.equals("accessory")) {%> id=accessorycount
                    <% } else if(thefieldname.equals("feesum")) {%> id=expensecountspan
                    <% } else if(thefieldname.equals("realfeesum")) {%> id=realcountspan<%}%>><% if(thefieldname.equals("accessory")) {
                        String countaccessorystr = "&nbsp;" ;
                        if( countaccessory != 0 ) countaccessorystr = ""+ countaccessory ;
                    %><%=countaccessorystr%>
                    <% } else if(thefieldname.equals("feesum")) {
                        countexpense = countexpense.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP ) ;
                        String countexpensestr = "&nbsp;" ;
                        if( countexpense.doubleValue() != 0 ) countexpensestr = ""+countexpense.toString() ;
                    %><%=countexpensestr%>
                    <% } else if(thefieldname.equals("realfeesum")) {
                        countrealfeefum = countrealfeefum.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP ) ;
                        String countrealfeefumstr = "&nbsp;" ;
                        if( countrealfeefum.doubleValue() != 0 ) countrealfeefumstr = ""+countrealfeefum.toString() ;
                    %><%=countrealfeefumstr%>
                    <% } else { %>&nbsp;<%}%>
                </td>
<%          }
%>
              </tr>
            </table>
            </td>
        </tr>
    </table>
    <br>
    <%@ include file="/workflow/request/BillBudgetExpenseDetail.jsp" %>
    <br>
    <input type='hidden' id=nodesnum name=nodesnum value="<%=recorderindex%>">
    <input type='hidden' id="indexnum" name="indexnum" value="<%=recorderindex%>">
    <input type='hidden' id=rowneed name=rowneed value="<%=dtlneed %>">

    <%--@ include file="/workflow/request/WorkflowManageSign.jsp" --%>
    <jsp:include page="WorkflowManageSign1.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestmark" value="<%=requestmark%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
	<jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
    </jsp:include>
</form>

<script language=javascript>
rowindex = <%=recorderindex%> ;
insertindex=<%=recorderindex%>;
deleteindex=0;
deletearray = new Array() ;
thedeletelength=0;

function addRow()
{
	oRow = oTable.insertRow(rowindex+1);
	curindex=parseInt($GetEle('nodesnum').value);

    for(j=0; j < fieldorders.length+1; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
	    if( j == 0 ) {
            var oDiv = document.createElement("div");
            var sHtml = "<input type='checkbox' name='check_node' value='"+insertindex+"'>";
            oDiv.innerHTML = sHtml;
            oCell.appendChild(oDiv);
        } else {
            dsporder = fieldorders[j-1] ;
            isedit = isedits[j-1] ;
            ismand = ismands[j-1] ;

            if( isedit != 1 ) {
                var oDiv = document.createElement("div");
				var sHtml = "&nbsp;";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
            } else {
                switch (dsporder)  {
                    case 1 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button type=button  class=Browser onclick='onBillShowDate(relatedatespan_"+insertindex+",relatedate_"+insertindex+","+ismand+")'></button>"+"<span id='relatedatespan_"+insertindex+"'>" ;
                        if(ismand == 1) sHtml += "<img src='/images/BacoError.gif' align=absmiddle>"; sHtml += "</span><input type=hidden id='relatedate_"+insertindex+"' name='relatedate_"+insertindex+"'>" ;
				        oDiv.innerHTML = sHtml;
				        oCell.appendChild(oDiv);
                        if(ismand == 1) $GetEle("needcheck").value += ",relatedate_"+insertindex;
                        break ;
                    case 2 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button type=button  class=Browser onclick='onShowFeetype(\"feetypeidspan_"+insertindex+"\",\"feetypeid_"+insertindex+"\","+ismand+")'></button>"+"<span id='feetypeidspan_"+insertindex+"'>" ;
                        if(ismand == 1) sHtml += "<img src='/images/BacoError.gif' align=absmiddle>"; sHtml += "</span><input type=hidden id='feetypeid_"+insertindex+"' name='feetypeid_"+insertindex+"'>" ;
				        oDiv.innerHTML = sHtml;				        
				        oCell.appendChild(oDiv);
                        if(ismand == 1) $GetEle("needcheck").value += ",feetypeid_"+insertindex;
                        break ;
                    case 3 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle  style=width:85% name='detailremark_"+insertindex+"'";
                        if(ismand == 1)
                            sHtml += "onchange='checkinput1(detailremark_"+insertindex+",detailremarkspan_"+insertindex+")'";
                        sHtml += ">" ;
                        if(ismand == 1)
                            sHtml += "<span id='detailremarkspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
				        oDiv.innerHTML = sHtml;
				        oCell.appendChild(oDiv);
                        if(ismand == 1) $GetEle("needcheck").value += ",detailremark_"+insertindex;
                        break ;
	                case 4 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle  style=width:85%  id='accessory_"+insertindex+"' name='accessory_"+insertindex+"' maxlength='10' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(accessory_"+ insertindex+",accessoryspan_"+insertindex+");" ;
                        sHtml += "changeaccessory();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='accessoryspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
        				oDiv.innerHTML = sHtml;
				        oCell.appendChild(oDiv);
                        if(ismand == 1) $GetEle("needcheck").value += ",accessory_"+insertindex;
                        break ;
                    case 5 :
                        var oDiv = document.createElement("div");
				        var sHtml = "<button type=button  class=browser onclick='onShowCustomer(\"relatedcrmspan_"+insertindex+"\",\"relatedcrm_"+insertindex+"\","+ismand+")'></button>"+"<span id='relatedcrmspan_"+insertindex+"'>";
                        if(ismand == 1)
                            sHtml += "<img src='/images/BacoError.gif' align=absmiddle>" ;
                        sHtml += "</span><input type=hidden id='relatedcrm_"+insertindex+"' name='relatedcrm_"+insertindex+"'>" ;
				        oDiv.innerHTML = sHtml;
				        oCell.appendChild(oDiv);
                        if(ismand == 1) $GetEle("needcheck").value += ",relatedcrm_"+insertindex;
                        break ;
	                case 6 :
				        var oDiv = document.createElement("div");
				        var sHtml = "<button type=button  class=browser onclick='onShowProject(\"relatedprojectspan_"+insertindex+"\",\"relatedproject_"+insertindex+"\","+ismand+")'></button>"+"<span id='relatedprojectspan_"+insertindex+"'>";
                        if(ismand == 1)
                            sHtml += "<img src='/images/BacoError.gif' align=absmiddle>" ;
                        sHtml += "</span><input type=hidden id='relatedproject_"+insertindex+"' name='relatedproject_"+insertindex+"'>" ;
				        oDiv.innerHTML = sHtml;
				        oCell.appendChild(oDiv);
                        if(ismand == 1) $GetEle("needcheck").value += ",relatedproject_"+insertindex;
                        break ;
                    case 7 :
				        var oDiv = document.createElement("div");
				        var sHtml = "<input type='text'  class=inputstyle  style=width:85%  id='feesum_"+insertindex+"' name='feesum_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(feesum_"+insertindex+",feesumspan_"+insertindex+");" ;
                        sHtml += "changenumber();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='feesumspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
				        oDiv.innerHTML = sHtml;
				        oCell.appendChild(oDiv);
                        if(ismand == 1) $GetEle("needcheck").value += ",feesum_"+insertindex;
                        break ;
                    case 8 :
			            var oDiv = document.createElement("div");
				        var sHtml = "<input type='text' class=inputstyle  style=width:85%  id='realfeesum_"+insertindex+"' name='realfeesum_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(realfeesum_"+ insertindex+",realfeesumspan_"+insertindex+");" ;
                        sHtml += "'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='realfeesumspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
				        oDiv.innerHTML = sHtml;
				        oCell.appendChild(oDiv);
                        if(ismand == 1) $GetEle("needcheck").value += ",realfeesum_"+insertindex;
                        break ;
                    case 9 :
			            var oDiv = document.createElement("div");
				        var sHtml = "<input type='text' class=inputstyle  style=width:85%  id='invoicenum_"+insertindex+"' name='invoicenum_"+insertindex+"' " ;
                        if(ismand == 1)
                            sHtml += "onchange='checkinput1(invoicenum_"+insertindex+",invoicenumspan_"+insertindex+")'";
                        sHtml += ">" ;
                        if(ismand == 1)
                            sHtml += "<span id='invoicenumspan_"+insertindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>";
				        oDiv.innerHTML = sHtml;
				        oCell.appendChild(oDiv);
                        if(ismand == 1) $GetEle("needcheck").value += ",invoicenum_"+insertindex;
                        break ;

					case 10 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<button type=button  class=browser onclick='onShowRequest(\"relaterequestspan_"+insertindex+"\",\"relaterequest_"+insertindex+"\","+ismand+")'></button>"+"<span id='relaterequestspan_"+insertindex+"'>";
                        if(ismand == 1)
                            sHtml += "<img src='/images/BacoError.gif' align=absmiddle>" ;
                        sHtml += "</span><input type=hidden id='relaterequest_"+insertindex+"' name='relaterequest_"+insertindex+"'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                }
            }
		}
    }
    insertindex = insertindex*1 +1;
	rowindex = curindex*1 +1;
	$GetEle("nodesnum").value = rowindex;
	$GetEle("indexnum").value = insertindex;

}
<%
if(dtldefault.equals("1")&&recorderindex<1)
{
%>
addRow();
<%	
}
%>

function changeaccessory() {
	countaccessory = 0 ;
	for(j=0;j<insertindex;j++) {
		hasdelete = false ;
		for(k=0;k<deletearray.length;k++){
			if(j==deletearray[k])
			hasdelete=true;
		}
		if(hasdelete) continue ;
		if($GetEle("accessory_"+j) != null){
			countaccessory += eval(toInt($GetEle("accessory_"+j).value,0)) ;
		}
	}
	accessorycount.innerHTML = countaccessory ;
}

function changenumber(){

	count_total = 0 ;

	for(j=0;j<insertindex;j++) {
		hasdelete = false ;
		for(k=0;k<deletearray.length;k++){
			if(j==deletearray[k])
			hasdelete=true;
		}
		if(hasdelete) continue ;
		if($GetEle("feesum_"+j) != null){
			count_total+= eval(toFloat($GetEle("feesum_"+j).value,0)) ;
		}
	}
	expensecountspan.innerHTML = count_total.toFixed(3); 


}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}

function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return str ;
}



function deleteRow1()
{
    var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
            len = document.forms[0].elements.length;
            var i=0;
            var therowindex = 0 ;
            var rowsum1 = 0;
            rowindex=parseInt($GetEle("nodesnum").value);
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node')
                    rowsum1 += 1;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        therowindex = document.forms[0].elements[i].value ;
                        deletearray[thedeletelength] = therowindex ;
                        thedeletelength ++ ;
                        oTable.deleteRow(rowsum1);
                        rowindex--;
                    }
                    rowsum1 -=1;
                }

            }

            changeaccessory() ;
            changenumber() ;
            $GetEle("nodesnum").value = rowindex ;
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}


function changereal(){

	count_total = 0 ;

	for(j=0;j<insertindex;j++) {
		count_total+= eval(toFloat($GetEle("realfeesum_"+j).value,0)) ;
	}
	realcountspan.innerHTML = count_total ;
}

</script>

<script type="text/javascript">
function onShowCustomer(spanname,inputname,ismand) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp", "", "dialogWidth=550px;dialogHeight=550px");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			
			$GetEle(spanname).innerHTML = "<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+wuiUtil.getJsonValueByIndex(id, 0)+"'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			if (ismand == 1) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle(inputname).value = "";
		}
	}
}

function onShowFeetype(spanname,inputname,ismand) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='1'", "", "dialogWidth=550px;dialogHeight=550px");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			
			$GetEle(spanname).innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			if (ismand == 1) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle(inputname).value = "";
		}
	}
}

function onShowProject(spanname,inputname,ismand) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp", "", "dialogWidth=550px;dialogHeight=550px");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			
			$GetEle(spanname).innerHTML = "<a href='/proj/data/ViewProject.jsp?ProjID="+wuiUtil.getJsonValueByIndex(id, 0)+"'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			if (ismand == 1) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle(inputname).value = "";
		}
	}
}

function onShowRequest(spanname,inputname,ismand) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1", "", "dialogWidth=550px;dialogHeight=550px");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			
			$GetEle(spanname).innerHTML = "<a href='/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+wuiUtil.getJsonValueByIndex(id, 0)+"'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			if (ismand == 1) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
			$GetEle(inputname).value = "";
		}
	}
}

</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>