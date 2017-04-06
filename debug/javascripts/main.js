$(document).ready(function(){
	$("#outputTD").height($(document).height()-195);
});

/**
	设置跟踪信息
*/
function setTrackType1(obj){
	$("#tracktype").val('var');
	$(obj).children("img").attr("src", "images/radio_true.png");
	$(obj).next().children("img").attr("src","images/radio_false.png");
	updataStatus();
}

function setTrackType2(obj){
	$("#tracktype").val('all');
	$(obj).children("img").attr("src", "images/radio_true.png");
	$(obj).prev().children("img").attr("src","images/radio_false.png");
	updataStatus();
}

/**
 设置跟踪过程
*/
function setTrackSeq(obj){
	if($("#trackseq").val()=="trackseq"){
		$("#trackseq").remove();
		$(obj).children("img").attr("src","images/checkbox_false.png");
	}else{
		$("#trackseqspan").html("<input type='hidden' name='trackseq' id='trackseq' value='trackseq' />");
		$(obj).children("img").attr("src","images/checkbox_true.png");
	}
	updataStatus();
}

/**
提交跟踪设置表单
*/
function updataStatus(){
   $("#statusForm").submit();
}

/**
开始或停止调试
*/
function startOrStop(obj){
	if($("#flag").val()=="0"){
		$(obj).text("正在启动");
		/*$("#flag").val("1");
		$("#sos").attr("src", "images/stop.png");
		*/
		window.location="/debug/debug.jsp?action=start";
	}else{
		$(obj).text("正在停止");
		/*$("#flag").val("0");
		$("#sos").attr("src", "images/start.png");
		*/
		window.location="/debug/debug.jsp?action=stop";
	}
}

