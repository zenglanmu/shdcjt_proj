<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page" />
<%
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String parentId = Util.null2String(request.getParameter("parentId"));

if(tabid.equals("")) tabid="0";

int uid=user.getUID();
    String rem = null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("WorkflowKeywordBrowserMulti" + uid)) {
            rem = cks[i].getValue();
            break;
        }
    }

    if (rem != null)
        rem = tabid + rem.substring(1);
    else
        rem = tabid;
    if (!nodeid.equals(""))
        rem = rem.substring(0, 1) + "|" + nodeid;

Cookie ck = new Cookie("WorkflowKeywordBrowserMulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
   nodeid=atts[1];
   parentId=nodeid.substring(nodeid.lastIndexOf("_")+1);
}


String strKeyword = Util.null2String(request.getParameter("strKeyword"));
String intKeywords = "" ;


if(!strKeyword.equals("")){

	try{
		List strKeywordList=Util.TokenizerString(strKeyword," ");
		strKeyword="";
		String tempKeyword=null;
		String tempId="0";
		boolean keywordIsExists=false;

		for(int i=0;i<strKeywordList.size();i++){
			tempKeyword=(String)strKeywordList.get(i);

			if(tempKeyword!=null&&!tempKeyword.trim().equals("")){
				keywordIsExists=false;
				WorkflowKeywordComInfo.setTofirstRow();
				while(WorkflowKeywordComInfo.next()){
					if(tempKeyword.equals(WorkflowKeywordComInfo.getKeywordName())){
						tempId=WorkflowKeywordComInfo.getId();
						strKeyword+=","+tempKeyword;
						intKeywords+=","+tempId;
						keywordIsExists=true;
						break;
					}
				}

				if(!keywordIsExists){
					strKeyword+=","+tempKeyword;
					intKeywords+=","+(-i-1);
				}
			}
		}
	
	}catch(Exception e){
		intKeywords="";
		strKeyword="";
	}
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String keyWordName = Util.null2String(request.getParameter("keyWordName"));
String keywordDesc = Util.null2String(request.getParameter("keywordDesc"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));


if(parentId.equals("0"))    parentId="";




int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;

if(ishead==0){
	ishead = 1;
	sqlwhere += " where isKeyword='1' ";
}else{
	sqlwhere += " and isKeyword='1' ";
}

if(!keyWordName.equals("")){
	sqlwhere += " and keyWordName like '%" + Util.fromScreen2(keyWordName,user.getLanguage()) +"%' ";
}
if(!keywordDesc.equals("")){
	sqlwhere += " and keywordDesc like '%" + Util.fromScreen2(keywordDesc,user.getLanguage()) +"%' ";
}

if(tabid.equals("0")&&!parentId.equals("")){
	sqlwhere += " and parentId=" + parentId;
}

String sqlstr = " select id,keywordName  from Workflow_Keyword " + sqlwhere+" order by showOrder asc"; ;

%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>

</HEAD>
<BODY>


<table width=100% border="0" cellspacing="0" cellpadding="0">

<tr>
  <td height="10" colspan="3"></td>
</tr>
<tr>
  <td align="center" valign="top" width="45%">
	
			                <select id="from" size="13" name="from" multiple="true" style="width:100%" class="InputStyle" onclick="blur1(srcList)" onkeypress="checkForEnter(from,srcList)" ondblclick="one2two(from,srcList)">
				             </select>
		      <script>
<%
                    RecordSet.executeSql(sqlstr);
					while(RecordSet.next()){
						String ids = RecordSet.getString("id");
						String tempKeywordName = Util.toScreen(RecordSet.getString("keywordName"),user.getLanguage());
%>
                          document.getElementById("from").options.add(new Option('<%=tempKeywordName%>','<%=ids%>'));
<%
					}
%>
                      </script>
		
  </td>
  
  <td align="center" width="10%">
				<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br>
				<img src="/images/arrow_left.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onClick="javascript:one2two(from,srcList);">
				<br>
				<img src="/images/arrow_right.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:two2one(from,srcList);">				
				<br>
				<img src="/images/arrow_left_all.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:removeAll(from,srcList);">
				<br>				
				<img src="/images/arrow_right_all.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:removeAll(srcList,from);">				
				<br>
				<img src="/images/arrow_d.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
  </td>
  <td align="center" valign="top" width="45%">
				<select id="srcList" size="13" name="srcList" multiple="true" style="width:100%" class="InputStyle" onclick="blur1(from)" onkeypress="checkForEnter(srcList,from)" ondblclick="two2one(from,srcList)">
					
				</select>
  </td>
		
</tr>
<tr>
<td height="10" colspan=3></td>
</tr>
<tr>
     <td align="center" valign="bottom" colspan=3>
     
    <BUTTON type='button' class=btnSearch accessKey=S <%if(!tabid.equals("2")){%>style="display:none"<%}%> id=btnsub onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
     
	<BUTTON type='button' class=btn accessKey=O  id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON type='button' class=btn accessKey=2  id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
    <!-- 2012-08-17 ypc 修改 添加 style="margin-right:0px!important;" -->
    <BUTTON type='button' class=btnReset accessKey=T style="margin-right:0px!important;" id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </td>
</tr>
</TABLE>
<!--########//Shadow Table End########-->

<script language="javascript" type="text/javascript" >
var intKeywords = "<%=intKeywords%>"
var strKeyword = "<%=strKeyword%>"

//Load
var keywordArray = new Array();
for(var i =1;i<intKeywords.split(",").length;i++){
	if(intKeywords.split(",")[i]!=0)
	keywordArray[i-1] = intKeywords.split(",")[i]+"~"+strKeyword.split(",")[i];
	//alert(keywordArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = document.getElementById("srcList");
	for(var i=0;i<keywordArray.length;i++){
		addObjectToSelect(selectObj,keywordArray[i]);
	}
	
}


function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str)
	val = str.split("~")[0];
	txt = str.split("~")[1];
	obj.options.add(new Option(txt,val));
	
}


init(document.getElementById("from"),document.getElementById("srcList"));

function upFromList(){
	var destList  = document.getElementById("srcList");
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}


function deleteFromList(){
	var destList  = document.getElementById("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}

function removeAll(from,to){
	
	var len = from.options.length;
	for(var i = 0; i < len; i++) {
	to_len=to.options.length
	txt=from.options[i].text
	val=from.options[i].value
	to.options[to_len]=new Option(txt,val)	  
	}
	
	for(var i = len; i>=0; i--) {
	from.options[i]=null	  
	}
	
	reloadResourceArray();
}
function downFromList(){
	var destList  = document.getElementById("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	keywordArray = new Array();
	var destList = document.getElementById("srcList");
	for(var i=0;i<destList.options.length;i++){
		keywordArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
	
}

//xiaofeng
function one2two(m1, m2)
{  
    // add the selected options in m1 to m2
    m1len = m1.length ;
    for ( i=0; i<m1len ; i++){
        if (m1.options[i].selected == true ) {
            m2len = m2.length;
            m2.options[m2len]= new Option(m1.options[i].text, m1.options[i].value);
        }
    }

reloadResourceArray()

	// remove all the selected options from m1 (because they have already been added to m2)	
	j = -1;
    for ( i = (m1len -1); i>=0; i--){
        if (m1.options[i].selected == true ) {
            m1.options[i] = null;
			j = i;
        }
    }
	
	if (j == -1)
		return;
		
	// move focus to the next item
	if (m1.length <= 0)
		return;
		
	if ((j < 0) || (j > m1.length))
		return;
		
	if (j == 0)
		m1.options[j].selected = true;
	else if (j == m1.length)
		m1.options[j-1].selected = true
	else
		m1.options[j].selected = true;
}

function two2one(m1, m2)
{
   one2two(m2,m1);
   reloadResourceArray();
}

function blur1(m){
	for(i=0;i<m.length;i++){
		m.options[i].selected=false
	}
}

function checkForEnter(m1, m2) {
   var charCode =  event.keyCode;
   if (charCode == 13) {
      one2two(m1, m2);
   }
   return false;
}

function init(m1,m2){
	for(i=0;i<m2.length;i++){
		ids=m2.options[i].value;

        for(j=0;j<m1.length;j++){
			if(m1.options[j].value==ids){
				m1.options[j]=null;
                break;
			}
        }
	}
}

function setResourceStr(){
	try{	
        var strKeyword1 = "";
	    for(var i=0;i<keywordArray.length;i++){
		    strKeyword1 += " "+keywordArray[i].split("~")[1].replace(/,/g,"，") ;
	    }
		if(strKeyword1!=""){
			strKeyword1=strKeyword1.substr(1);
		}
	    strKeyword=strKeyword1;
    }catch(err){}	
}

function btnclear_onclick(){
    window.parent.parent.returnValue = "";
    window.parent.parent.close();
}

function btnok_onclick(){
    setResourceStr();
    window.parent.parent.returnValue = strKeyword;
    window.parent.parent.close();
}

function btnsub_onclick(){
　　//2012-08-21 ypc 修改  需要把选中的值提交给自己
   //window.parent.frame1.document.getElementById("tabid").value = "2";
   //window.parent.frame1.document.SearchForm.submit();
    var curDoc;
		if(document.all){
			curDoc=window.parent.frames["frame1"].document
		}
		else{
			curDoc=window.parent.document.getElementById("frame1").contentDocument	
		}
		$(curDoc).find("#btnsub")[0].click();
    	
}

function btncancel_onclick(){
	
	window.parent.parent.close();
}
window.parent.parent.returnValue = undefined;
</script>

<!-- 
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = ""
     window.parent.close
End Sub


Sub btnok_onclick()
     setResourceStr()
     window.parent.returnvalue = strKeyword
     window.parent.close
End Sub

Sub btnsub_onclick()
     window.parent.frame1.SearchForm.btnsub.click()
End Sub

Sub btncancel_onclick()
     window.close()
End Sub
</SCRIPT>  -->
</BODY></HTML>