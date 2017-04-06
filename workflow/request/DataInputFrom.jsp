<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String fformid=Util.null2String(request.getParameter("formid"));
String wflid=request.getParameter("id");
String triggerfieldnameS=request.getParameter("trg");
String isbill=request.getParameter("bill");
String nodeid=request.getParameter("node");
int tableid=0;
int detailsum=Util.getIntValue(request.getParameter("detailsum"),0);
String inputchecks="";
%>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>
<script language="javascript">
window.onload = function (){
<%
ArrayList triggerfieldnameArr = Util.TokenizerString(triggerfieldnameS,",");
for(int temp=0;temp<triggerfieldnameArr.size();temp++){
	String triggerfieldname = Util.null2String((String)triggerfieldnameArr.get(temp));
	if(triggerfieldname!=null && !triggerfieldname.trim().equals("")){
		DynamicDataInput DDI = new DynamicDataInput(wflid,triggerfieldname,isbill);
		ArrayList clearjs=new ArrayList();
		clearjs=DDI.ClearMainField(wflid,triggerfieldname,isbill,nodeid);
		for(int i=0;i<clearjs.size();i++){
			String tempjs = (String)clearjs.get(i);
			tempjs = tempjs.replaceAll("window.parent.document.getElementById\\(", "getElementByDocument\\(window.parent.document, ");
%>
		//页面输出字段值初始化（主字段值清除） 
		eval("<%=tempjs%>");
<%		}	
		String sql="select id from Workflow_DataInput_entry where WorkFlowID="+wflid+" and TriggerFieldName='"+triggerfieldname+"'";
		rs.executeSql(sql);
		String entryid="";
		String datainputid="";
		Hashtable outdatahash=new Hashtable();
		while(rs.next()){
			entryid=rs.getString("id");
			rs1.executeSql("select id,IsCycle,WhereClause from Workflow_DataInput_main where entryID="+entryid+" order by orderid");
			String sql1="";
			ArrayList outfieldnamelist=new ArrayList();
			ArrayList outdatasList=new ArrayList();
			ArrayList[] templist=new ArrayList[10];
			ArrayList[] templistdetail=new ArrayList[10];
			String[] isclear=new String[10];
			String[] iscleardetail=new String[10];
		
			while(rs1.next()){
				isclear[tableid]="1";
				iscleardetail[tableid]="1";
				templist[tableid]=new ArrayList();
				templistdetail[tableid]=new ArrayList();
				datainputid=rs1.getString("id");
				
				ArrayList infieldnamelist=DDI.GetInFieldName(datainputid);
				for(int i=0;i<infieldnamelist.size();i++){
					DDI.SetInFields((String)infieldnamelist.get(i),Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i))));
				}
				ArrayList conditionfieldnameList=DDI.GetConditionFieldName(datainputid);
				for(int j=0;j<conditionfieldnameList.size();j++){
					DDI.SetConditonFields((String)conditionfieldnameList.get(j),Util.null2String(request.getParameter(datainputid+"|"+(String)conditionfieldnameList.get(j))));
				}
		        DDI.GetOutData(datainputid);
		        outfieldnamelist=DDI.GetOutFieldNameList();
		        outdatasList=DDI.GetOutDataList();
		        
		      	//主表字段更新
				if(DDI.GetIsCycle().equals("1")){
				 	for(int i=0;i<outdatasList.size();i++){
				 		outdatahash = (Hashtable)outdatasList.get(i);
				 		for(int j=0; j<outfieldnamelist.size(); j++){
				 		    String tempValue = (String)outdatahash.get(outfieldnamelist.get(j));
				 		 	tempValue = Util.toExcelData(tempValue);
				 		    tempValue = Util.StringReplace(tempValue,";","┌weaver┌");
			 				String js=DDI.ChangeMainField((String)outfieldnamelist.get(j),tempValue,isbill,nodeid,triggerfieldname);
			 				js = Util.StringReplace(js,"&quot；","\\\\\\\"");
			 				js = Util.StringReplace(js,"\''", "\'");
			 				js = js.replaceAll("window.parent.document.getElementById\\(", "getElementByDocument\\(window.parent.document, ");
%>
try{
	var mainjs="<%=js%>";
	var temp=mainjs;
	var spaninx=temp.indexOf(";");					
	mainjs="";
	var indx=0;
	if(spaninx>0){
		mainjs+=temp.substring(spaninx+1,temp.length);
		temp=temp.substring(0,spaninx);						
	}
	while(temp.length>0){
		indx=temp.indexOf("<br>");
		if(indx>=0){
			mainjs+=temp.substring(0,indx)+"\\"+"r"+"\\"+"n";
			temp=temp.substring(indx+4,temp.length);
		}else{
			mainjs+=temp;
			temp="";
		}
	}
	mainjs = mainjs.replace(/┌weaver┌/g,";");
	eval(mainjs);
}catch(e){}
<%
		        		}
	       			}
				//明细表字段更新
		       	} else {
		       		ArrayList viewfields=new ArrayList();
		       		if(outdatasList.size()>0){
		       			viewfields=DDI.ViewDetailFieldList(fformid,nodeid,tableid);
		       		}
		       		
			       	for(int i=0;i<outdatasList.size();i++){
			       		outdatahash=(Hashtable)outdatasList.get(i);
			       		String html="";
			       		if(outdatahash.size()>0 && outfieldnamelist.size()>0){
%>

try{
	var oTable=window.parent.document.getElementById('oTable<%=tableid%>');
	curindex=parseInt(window.parent.document.getElementById('nodesnum<%=tableid%>').value);
	rowindex=parseInt(window.parent.document.getElementById('indexnum<%=tableid%>').value);
	oRow = oTable.insertRow(curindex+1);
	oCell = oRow.insertCell(-1); 
	oCell.style.height=24;
	oCell.style.background= "#E7E7E7";
	var oDiv = window.parent.document.createElement("div");
	var sHtml = "<input type='checkbox' name='check_node<%=tableid%>' value='"+rowindex+"'>";
	oDiv.innerHTML = sHtml;
	oCell.appendChild(oDiv);
}catch(e){}
		        
<%
						}
					
			        	for(int j=0;j<viewfields.size();j++){
			        		int outindx=outfieldnamelist.indexOf(viewfields.get(j));
			        		if(outindx>-1){
			        			html=DDI.addcol((String)outfieldnamelist.get(outindx),(String)outdatahash.get(outfieldnamelist.get(outindx)),isbill,nodeid,triggerfieldname,i,tableid);
			        		} else {
			        			html=DDI.addcol((String)viewfields.get(j),"",isbill,nodeid,triggerfieldname,i,tableid);
			        		}
			        		
			        		if(!html.trim().equals("")){
%>

try{
	oCell = oRow.insertCell(-1); 
	oCell.style.height=24;
	oCell.style.background= "#E7E7E7";
	var oDiv = window.parent.document.createElement("div");
	var mainjs="<%=html%>";
	var temp=mainjs;
	var spaninx=temp.indexOf("<span notview");
	mainjs="";
	var indx=0;
	if(spaninx>0){
		mainjs+=temp.substring(spaninx,temp.length);
		temp=temp.substring(0,spaninx);				
	}
	while(temp.length>0){					
		indx=temp.indexOf("<br>");
		if(indx>=0){
			mainjs+=temp.substring(0,indx)+"\r\n";
			temp=temp.substring(indx+4,temp.length);							
		}else{
			mainjs+=temp;
			temp="";
		}
	}
	oDiv.innerHTML = mainjs;
	oCell.appendChild(oDiv);
}catch(e){}

<%
		        			}
		        		}
%>

try{
	rowindex = rowindex*1 +1;
	curindex = curindex*1 +1;
	window.parent.document.getElementById("nodesnum<%=tableid%>").value=curindex;
	window.parent.document.getElementById("indexnum<%=tableid%>").value=rowindex;
	window.parent.calSum(<%=tableid%>);
}catch(e){}

<%
		        	}
			       	if(outdatasList.size()>0){
			       		tableid++;
			       	}
	        	}
			}
		}
		inputchecks=DDI.GetNeedCheckStr();
	}
}
%>

try{
	window.parent.document.getElementById("inputcheck").value=window.parent.document.getElementById("inputcheck").value+"<%=inputchecks%>";
}catch(e){}
}

function delall(){
	try{
<%  for(int j=0;j<detailsum;j++){  %>
  	var oTable=window.parent.document.getElementById('oTable<%=j%>');
    len = window.parent.document.forms[0].elements.length;
    var i=0;
    var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
        if (window.parent.document.forms[0].elements[i].name=='check_node<%=j%>')
            rowsum1 += 1;
    }
    for(i=len-1; i >= 0;i--) {
        if (window.parent.document.forms[0].elements[i].name=='check_node<%=j%>'){
            oTable.deleteRow(rowsum1);
            rowsum1 -=1;
        }
    }
    window.parent.calSum(<%=j%>);
    window.parent.document.getElementById("nodesnum<%=j%>").value="0";
	window.parent.document.getElementById("indexnum<%=j%>").value="0";
<%  }  %>
  }catch(e){}
}

/**
 * 根据标识（name或者id）获取元素，主要用于解决系统中很多元素没有id属性，
 * 却在js中使用document.getElementById(name)来获取元素的问题。
 * @param identity name或者id
 * @return 元素
 */
function $GetEle(identity, _document) {
	var rtnEle = null;
	if (_document == undefined || _document == null) _document = document;
	
	rtnEle = _document.getElementById(identity);
	if (rtnEle == undefined || rtnEle == null) {
		rtnEle = _document.getElementsByName(identity);
		if (rtnEle.length > 0) rtnEle = rtnEle[0];
		else rtnEle = null;
	}
	return rtnEle;
}

function getElementByDocument(_document, identity) {
	return $GetEle(identity, _document);
}
</script>