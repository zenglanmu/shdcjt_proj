<%@ page language="java" contentType="text/html; charset=gbk"
    pageEncoding="gbk"%>
<%@ page import="weaver.systeminfo.*, weaver.hrm.*" %>

<%
User user = HrmUserVarify.getUser (request , response) ;
String mandtypes = request.getParameter("mandtypes");
String groupid = request.getParameter("groupid");
String needcheck = request.getParameter("needcheck");
String dsptypes = request.getParameter("dsptypes");
String edittypes = request.getParameter("edittypes");
String newenddate = request.getParameter("newenddate");
String newfromdate = request.getParameter("newfromdate");
String totalamountsum = request.getParameter("totalamountsum");
%>

<script language="javascript">
    if ("<%=needcheck%>" != ""){
         document.all("needcheck").value += ",<%=needcheck%>";
    }
</script>

<script language=vbs>
sub onShowResourceID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	else 
		if ismand=1 then
			resourceidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		else
			resourceidspan.innerHtml = ""
		end if
	frmmain.resourceid.value="0"
	end if
	end if
end sub

sub onShowAssetType(spanname,inputname)
	ismust1 = <%=mandtypes.indexOf("1_1")!=-1%>
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp?supassortmentid="&groupid&"&fromcapital=2")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
			if ismust1 = false then
				spanname.innerHtml =  ""
			else
				spanname.innerHtml =  "<img src='/images/BacoError.gif' align=absmiddle>"
			end if
		inputname.value=""
		end if
	end if
end sub
</script>   

<script language=javascript>
var xmlHttp;
function showprice(noderowindex){
	var id = document.getElementById(noderowindex+"_capitalid").value;
	//alert(id);
	noderowindextmp = noderowindex;
	
	if(window.ActiveXObject){
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if(window.XMLHttpRequest){
        xmlHttp = new XMLHttpRequest();
    }
    xmlHttp.onreadystatechange = showstartprice;
	xmlHttp.open("get","/cpt/capital/CapitalStartPriceAjax.jsp?id="+id,true); 
	xmlHttp.send(); 
	
}
function showstartprice(){
	if(xmlHttp.readystate==4){ 
		if(xmlHttp.status==200){
			var returnTemp = xmlHttp.responseText;
			if(document.getElementById(noderowindextmp+"_unitprice").type=="hidden"){
				document.getElementById(noderowindextmp+"_unitprice").value = returnTemp;
				document.getElementById(noderowindextmp+"_unitpricespan").innerHTML = returnTemp;
			}else{
				document.getElementById(noderowindextmp+"_unitprice").value = returnTemp;
				if(document.getElementById(noderowindextmp+"_unitpricespan")){
				document.getElementById(noderowindextmp+"_unitpricespan").innerHTML = "";
				}
			}
		}
	}
}
	
	
groupid = <%=groupid%>;
rowindex = document.frmmain.nodesnum.value;
needcheck = "<%=needcheck%>";
function addRow()
{
	ncol = oTable.cols;
	dsptypes = "<%=dsptypes%>";
	edittypes = "<%=edittypes%>";
	mandtypes = "<%=mandtypes%>";
	
	oRow = oTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		if(dsptypes.indexOf(j+"_0")!=-1){
			oCell.style.display="none";
		}
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' isexist='0' value='"+rowindex+"'><input type='hidden' name='check_node_val'  value='"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("1_1")!=-1){
					sHtml = "<button class=Browser onClick='onShowAssetType(node_"+rowindex+"_cptspan,node_"+rowindex+"_cptid)'></button> " + 
        					"<span id=node_"+rowindex+"_cptspan>";
        				if(mandtypes.indexOf("1_1")!=-1){
        					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_cptid";
        				}
        				sHtml +="</span> <input type='hidden' name='node_"+rowindex+"_cptid' id='node_"+rowindex+"_cptid'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("2_1")!=-1){
					sHtml = "<button class=Browser onClick='onShowCptCapital(node_"+rowindex+"_capitalidspan,node_"+rowindex+"_capitalid,node_"+rowindex+"_capitalcount,node_"+rowindex+"_number,node_"+rowindex+"_numberspan,\"node_"+rowindex+"\")'></button> " + 
        					"<span id=node_"+rowindex+"_capitalidspan>";
        				if(mandtypes.indexOf("2_1")!=-1){
        					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_capitalid";
        				}
        				sHtml +="</span> <input type='hidden' name='node_"+rowindex+"_capitalid' id='node_"+rowindex+"_capitalid'><input type='hidden' name='node_"+rowindex+"_capitalcount' id='node_"+rowindex+"_capitalcount'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("3_1")!=-1){
					if(mandtypes.indexOf("3_1")!=-1){ 
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur=\"checkinput('node_"+rowindex+"_number','node_"+rowindex+"_numberspan');checkCount("+rowindex+");changeamountsum('node_"+rowindex+"')\"><span id='node_"+rowindex+"_numberspan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_number";
        				}else{
        					sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur='checkCount("+rowindex+");changeamountsum(\"node_"+rowindex+"\")'><span id='node_"+rowindex+"_numberspan'></span>";
        				}
	        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}else{
                    sHtml = "<input type='hidden' class=Inputstyle  name='node_"+rowindex+"_number'><span id='node_"+rowindex+"_numberspan'></span>";
	        	    oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv); 
                }
				break;
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("4_1")!=-1){
					if(mandtypes.indexOf("4_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle   name='node_"+rowindex+"_unitprice'  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_unitprice','node_"+rowindex+"_unitpricespan');changeamountsum('node_"+rowindex+"')><span id='node_"+rowindex+"_unitpricespan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_unitprice";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text'  class=Inputstyle onBlur=changeamountsum('node_"+rowindex+"') name='node_"+rowindex+"_unitprice'><span id='node_"+rowindex+"_unitpricespan'></span>";
        				}
        				
        				  
        			}else{
        				sHtml = "<input type='hidden' class=Inputstyle  name='node_"+rowindex+"_unitprice'><span id='node_"+rowindex+"_unitpricespan'></span>";	
            		}
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("5_1")!=-1){
					if(mandtypes.indexOf("5_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle   name='node_"+rowindex+"_amount'  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_amount','node_"+rowindex+"_amountspan')><span id='node_"+rowindex+"_amountspan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_amount";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text' class=Inputstyle   name='node_"+rowindex+"_amount'><span id='node_"+rowindex+"_amountspan'></span>";
        				}
        				
        			}else{
        				sHtml = "<input type='hidden' class=Inputstyle  name='node_"+rowindex+"_amount'><span id='node_"+rowindex+"_amountspan'></span>";
            		}

						oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  

				break;
			
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("6_1")!=-1){
					sHtml = "<button class=Browser onClick='onBillCPTShowDate(node_"+rowindex+"_needdatespan,node_"+rowindex+"_needdate,"+mandtypes.indexOf("6_1")+")'></button> " + 
						"<span class=Inputstyle id=node_"+rowindex+"_needdatespan> ";
					if(mandtypes.indexOf("6_1")!=-1){
        					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_needdate";
        				}
        				sHtml+="</span>"
        				sHtml += "<input type='hidden' name='node_"+rowindex+"_needdate' id='node_"+rowindex+"_needdate'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			
			case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";;
				if(edittypes.indexOf("7_1")!=-1){
					if(mandtypes.indexOf("7_1")!=-1){
						sHtml = "<input class=Inputstyle class=Inputstyle type='text' name='node_"+rowindex+"_purpose' onBlur=checkinput('node_"+rowindex+"_purpose','node_"+rowindex+"_purposespan')><span id='node_"+rowindex+"_purposespan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_purpose";
        					sHtml+="</span>"        				
        				}else{
        					sHtml = "<input type='text' class=Inputstyle name='node_"+rowindex+"_purpose'>";
        				}
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;	
			case 8: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";;
				if(edittypes.indexOf("8_1")!=-1){
					if(mandtypes.indexOf("8_1")!=-1){
						sHtml = "<input class=Inputstyle type='text' name='node_"+rowindex+"_cptdesc' onBlur=checkinput('node_"+rowindex+"_cptdesc','node_"+rowindex+"_cptdescspan')><span id='node_"+rowindex+"_cptdescspan'>";
						sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_cptdesc";
        					sHtml+="</span>"        				
        				}else{
        					sHtml = "<input type='text' class=Inputstyle name='node_"+rowindex+"_cptdesc'>";
        				}
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;	
				
		}
	}
	rowindex = rowindex*1 +1;
	document.frmmain.nodesnum.value = rowindex ;
	document.all("needcheck").value += ","+needcheck;
}

function checkCount(index){
    //var stockamount = document.all("node_"+index+"_count").value;
   // var useamount = document.all("node_"+index+"_number").value;
    //if(eval(useamount)>eval(stockamount)){
    //    alert("<%=SystemEnv.getHtmlLabelName(15313,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
    //    document.all("node_"+index+"_number").value = stockamount;
   // }
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
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node')
                    rowsum1 += 1;
            }
			var sumnum = rowsum1;
            mandtypes = "<%=mandtypes%>";
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        tmprow = document.forms[0].elements[i].value;
                        if(document.forms[0].elements[i].isexist==1){//删除已经存在的明细
                            document.getElementById("delids").value = document.getElementById("delids").value+","+tmprow;
                        }
                        for(j=0; j<7; j++) {
                            if(mandtypes.indexOf(j+"_1")!=-1){
                                if(j==1)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_cptid","");
                                if(j==2)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_capitalid","");
                                if(j==3)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_number","");
                                if(j==4)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_unitprice","");
                                if(j==5)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_amount","");
                                if(j==6)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_needdate","");
                                if(j==7)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_purpose","");
                                if(j==8)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_cptdesc","");

                            }
                        }
                        oTable.deleteRow(rowsum1);
						sumnum -=1;	
        //				rowindex = rowindex*1 - 1;
                    }
                    rowsum1 -=1;
//                    rowindex-=1;
                }
            }
			document.frmmain.nodesnum.value = sumnum ;
            amountsumcount();
}
}else{
alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
}
}	


function changetype(obj){
	groupid = obj.value;		
//	obj.disabled = true;
}

function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{  
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else 
                return true;
            }
            }
        else
        return true;
        }
}


function checktimeok(){
if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != ""){
			YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
			MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
			DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
			YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
			MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
			DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
			// window.alert(YearFrom+MonthFrom+DayFrom);
                   if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
        window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
         return false;
  			 }
  }
     return true; 
}
function toFloat(str , def) {
    if(isNaN(parseFloat(str))) return def ;
    else return str ;
}

function toInt(str , def) {
    if(isNaN(parseInt(str))) return def ;
    else return str ;
}

function amountsumcount(){
	if(document.getElementById("<%=totalamountsum%>")){
	var amountsum = 0;
	//alert(rowindex);
	for(var i=0;i<rowindex;i++){
		var amounttmp = "";
		try{
			amounttmp = eval(toFloat(document.getElementById("node_"+i+"_amount").value,0));
		}catch(e){amounttmp = "";}
		//alert(amounttmp);
		if(amounttmp==""){
			amountsum += 0;
		}else{
			amountsum += parseFloat(amounttmp);
		}
	}
	//alert(amountsum);
	//alert(document.getElementById("<%=totalamountsum%>span"));
	if(document.getElementById("<%=totalamountsum%>").type=="hidden"){
		document.getElementById("<%=totalamountsum%>span").innerHTML=amountsum.toFixed(3);
		document.getElementById("<%=totalamountsum%>").value=amountsum.toFixed(3);
	}else{
		document.getElementById("<%=totalamountsum%>").value=amountsum.toFixed(3);
		if(document.getElementById("<%=totalamountsum%>span")){
		document.getElementById("<%=totalamountsum%>span").innerHTML="";
		}
	}
	}
}

var xmlHttp;
function showprice(noderowindex){
	var id = document.getElementById(noderowindex+"_capitalid").value;
	//alert(id);
	noderowindextmp = noderowindex;
	
	if(window.ActiveXObject){
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if(window.XMLHttpRequest){
        xmlHttp = new XMLHttpRequest();
    }
    xmlHttp.onreadystatechange = showstartprice;
	xmlHttp.open("get","/cpt/capital/CapitalStartPriceAjax.jsp?id="+id,true); 
	xmlHttp.send(); 
	
}
function showstartprice(){
	if(xmlHttp.readystate==4){ 
		if(xmlHttp.status==200){
			var returnTemp = xmlHttp.responseText;
			var amountsum = document.getElementById(noderowindextmp+"_number").value*returnTemp;
			if(document.getElementById(noderowindextmp+"_unitprice").type=="hidden"){
				document.getElementById(noderowindextmp+"_unitprice").value = returnTemp;
				document.getElementById(noderowindextmp+"_unitpricespan").innerHTML = returnTemp;
			}else{
				document.getElementById(noderowindextmp+"_unitprice").value = returnTemp;
				if(document.getElementById(noderowindextmp+"_unitpricespan")){
				document.getElementById(noderowindextmp+"_unitpricespan").innerHTML = "";
				}
			}
			if(document.getElementById(noderowindextmp+"_amount").type=="hidden"){
				document.getElementById(noderowindextmp+"_amount").value = toFloat(amountsum,0).toFixed(3);
				document.getElementById(noderowindextmp+"_amountspan").innerHTML = toFloat(amountsum,0).toFixed(3);
			}else{
				document.getElementById(noderowindextmp+"_amount").value = toFloat(amountsum,0).toFixed(3);
				if(document.getElementById(noderowindextmp+"_amountspan")){
				document.getElementById(noderowindextmp+"_amountspan").innerHTML = "";
				}
			}
			amountsumcount();
		}
	}
}

function changeamountsum(noderowindex){
	//alert(noderowindex);
	var pricetmp = document.getElementById(noderowindex+"_unitprice").value;
	var numbertmp = document.getElementById(noderowindex+"_number").value;
	var amountsumtmp = pricetmp*numbertmp;
	if(document.getElementById(noderowindex+"_amount").type=="hidden"){
		document.getElementById(noderowindex+"_amount").value = toFloat(amountsumtmp,0).toFixed(3);
		document.getElementById(noderowindex+"_amountspan").innerHTML = toFloat(amountsumtmp,0).toFixed(3);
	}else{
		document.getElementById(noderowindex+"_amount").value = toFloat(amountsumtmp,0).toFixed(3);
		if(document.getElementById(noderowindex+"_amountspan")){
		document.getElementById(noderowindex+"_amountspan").innerHTML = "";
		}
	}
	amountsumcount();
}

</script>
<script language="vbs">
sub onShowCptCapital(spanname,inputname,inputnamecount,inputnamenumber,inputnamenumberspan,noderowindex)
	ismust2 = <%=mandtypes.indexOf("2_1")!=-1%>
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1&cptuse=1")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
        inputnamecount.value=id(7)
        inputnamenumber.value=id(7)
        inputnamenumberspan.innerHtml =  ""
		showprice(noderowindex)
		else
			if ismust2 = false then
				spanname.innerHtml =  ""
			else
				spanname.innerHtml =  "<img src='/images/BacoError.gif' align=absmiddle>" 
			end if
		inputname.value=""
		end if
	end if
end sub
</script>