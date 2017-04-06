<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
			
			String sql1="select * from slideelement where eid="+eid;
			rs.execute(sql1);
			ArrayList iconImgList=new ArrayList();
			ArrayList iconImg_overList=new ArrayList();
			ArrayList bigImage=new ArrayList();
			String bigImageArea="";
			int i=0;
			while(rs.next()){
				iconImgList.add("'"+rs.getString("url2")+"'");
				iconImg_overList.add("'"+rs.getString("url3")+"'");
				String link = (String)rs.getString("link");
				link = link.equals("")?"void(0);":"window.open('"+link+"')";
				bigImageArea+="<div class=slideDiv index="+i+"  alt='"+rs.getString("title")+"...' "+
			"style=\"background:url('"+"') no-repeat;cursor: pointer;\"><img onclick=\"javascript:"+link+"\" src=\""+rs.getString("url1")+"\"/>"
			+"<div class='slideDiv' onclick=\"javascript:window.open('"+link+"');\" style='cursor: pointer;'></div></div>";
				i++;
			}
			String sql2=" select name,value from hpelementSetting where eid="+eid;
			rs.execute(sql2);
			String[] colNames=rs.getColumnName();
			HashMap values=new HashMap();
			if(rs.getCounts()<=0){
				
			}else{
			while(rs.next()){
					values.put(rs.getString(colNames[0]),rs.getString(colNames[1]));
			}
%>

	<STYLE TYPE="text/css">
		#slideArea_<%=eid%>{
			 height: 165px; 
			 width:auto; /*160*N*/
		}
		
		#slideArea_<%=eid%> .slideTitle{
			z-index:1001;
			<% if("1".equals(values.get("slide_t_position"))){%>
			width:150px;
			float:left;
			<%}
			if("2".equals(values.get("slide_t_position"))){
			%>
			width:150px;
			float:right;
			<%}if("3".equals(values.get("slide_t_position"))){%>
			padding-top:10px;
			height:40px;
			<%}%>
			position:relative;     /*40*150*/
		}

		#slideArea_<%=eid%> .slideTitle .slidnavtitle{
			cursor:pointer;   
			<%if("3".equals(values.get("slide_t_position"))){%>
			margin-right:5px;
			height:40px;
			width:75px;float:left;
			<%}else{%>
			height:40px;
			<%}%>
		}
		#slideArea_<%=eid%> .slideTitleFloat{
			<%if("3".equals(values.get("slide_t_position"))){%>
				height:40px;width:79px;
			<%}else{%>
			height:40px;width:165px;
			<%}%>
			
			position:absolute;display:none;   /*40*160*/
		}
		#slideArea_<%=eid%> .slideContinar{ 
			
			padding:0;  
			overflow: hidden;
			<% if("3".equals(values.get("slide_t_position"))){%>
				height:220px;
			<%}else{%>
				height:160px;
			<%}%>
			table-layout:fixed;
			width:auto;
			margin:0;
			
		}     /*N-150*/
		#slideArea_<%=eid%> .slideContinar .slideDiv { 
			<% if("3".equals(values.get("slide_t_position"))){%>
				height:220px;
			<%}else{%>
				height:160px;
			<%}%>
			width: 100%;
		}
		#slideTitleNavContainer{
			<% if("3".equals(values.get("slide_t_position"))){%>
				display:inline-block;
				_display:block;
			<%}%>
		}
	</STYLE>
<script>
$(function() {
		var iconImgList=<%=iconImgList.toString()%>;
		var iconImg_overList=<%=iconImg_overList.toString()%>;
		
		$('#slideArea_<%=eid%> .slideContinar').cycle({  //turnUp   //fade  //uncover
			fx:      '<%=values.get("slide_t_changeStyle")%>',  //blindX     * blindY    * blindZ    * cover    * curtainX    * curtainY    * fade    * fadeZoom    * growX    * growY    * none   * scrollUp    * scrollDown    * scrollLeft    * scrollRight    * scrollHorz    * scrollVert    * shuffle    * slideX    * lideY   * toss    * turnUp    * turnDown    * turnLeft    * turnRight    * uncover    * wipe    * zoom*/
			timeout:  <%=Util.getIntValue((String)values.get("slide_t_AutoChangeTime")) %>,
			pager:   '#slideTitleNavContainer',
			pagerAnchorBuilder: pagerFactory,
			before:        function(currSlideElement, nextSlideElement, options, forwardFlag) {	
				var nextIndex=$(nextSlideElement).attr("index");
				var slidnavtitleArray=$("#slideArea_<%=eid%> .slidnavtitle");
				var newTop=0;
				var newLeft=0;
				
				if(slidnavtitleArray.length==0){
					
				} else {
					var nextSlidnavtitle=$($("#slideArea_<%=eid%> .slidnavtitle")[nextIndex]);
					newTop=nextSlidnavtitle.position().top;
					newLeft=nextSlidnavtitle.position().<%=values.get("slide_t_position").equals("2")?"right":"left"%>;
				}
				
				$("#slideArea_<%=eid%> .slideTitleFloat").css({
					"display":"block",
					<%if(values.get("slide_t_position").equals("3")){%>
						top :newTop-10,
					<%}else{%>
						top :newTop,
					<%}%>					
					<%=values.get("slide_t_position").equals("2")?"right":"left"%>:newLeft,
					"background":"url('"+iconImg_overList[nextIndex]+"')"
				});
				
			}			
		}); 
		
		
		function pagerFactory(idx, slide) {
			<%if(values.get("slide_t_position").equals("3")){%>
				var s = idx > 3 ? ' style="display:true"' : '';		
			<%}else{%>
				var s = idx > 3 ? ' style="display:none"' : '';		
			<%}%>	
			return '<div '+s+' class="slidnavtitle"  style="background:url('+iconImgList[idx]+') no-repeat;">&nbsp;</div>';
			};
			<%if(values.get("slide_t_position").equals("3")){%>
			$("#slideTitleNavContainer").css({
				"margin-left":Math.round(($("#slideArea_<%=eid%> .slideTitle").width()-$("#slideTitleNavContainer").width())/2)
			});
			$(".slideTitleFloat").css({
				"left":Math.round(($("#slideArea_<%=eid%> .slideTitle").width()-$("#slideTitleNavContainer").width())/2),
				"top":10+Math.round($(".slideTitleFloat").offset().top)+"px"
			});
		<%}%>

		
	});
</script>

   <div  >
   		
     </div>
	<table style="width:100%;height:165px;" id="slideArea_<%=eid%>" border="0" cellspacing="0" cellpadding="0" >
		
		<%if("1".equals(values.get("slide_t_position"))){ %>
			<colgroup>
				<col width="150"/>
				<col width="100%"/>
			</colgroup>
			<tr>
				<td style="width:150px;">
					<div class="slideTitle">
						<div class="slideTitleFloat"></div>
						<DIV id="slideTitleNavContainer" ></DIV>				
					</div>
				</td>
				<td  width="*">
					<div  class="slideContinar" style="cursor: pointer;">
						<%=bigImageArea %>
					</div>
				</td>
			</tr>
			<%} else if("2".equals(values.get("slide_t_position"))){ %>
			<colgroup>
				<col width="100%"/>
				<col width="150"/>
				
			</colgroup>
			<tr>
				<td width="*">
					<div  class="slideContinar" style="cursor: pointer;">
						<%=bigImageArea %>
					</div>
				</td>
				<td style="width:150px;">
					<div class="slideTitle">
						<div class="slideTitleFloat"></div>
						<DIV id="slideTitleNavContainer" ></DIV>				
					</div>
				</td>
			</tr>
			<%}else{%>
			<tr>
				<td>
					<div  class="slideContinar" style="cursor: pointer;">
						<%=bigImageArea %>
					</div>
				</td>
			</tr>
			<tr>
				<td >
					<div class="slideTitle">
						<div class="slideTitleFloat"></div>
						<DIV id="slideTitleNavContainer" ></DIV>				
					</div>
				</td>
			</tr>
			<%} %>
	</table>
<%}%>