<%@ page language="java" contentType="text/html; charset=gbk" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/Fader.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/TabPanel.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/Math.uuid.js"></script>
<link rel="stylesheet" href="/email/joyride/joyride-1.0.5.css">
<link rel="stylesheet" href="/email/joyride/demo-style.css">
<link rel="stylesheet" href="/email/joyride/mobile.css">
<script type="text/javascript" src="/email/joyride/jquery.min.js"></script>
<script type="text/javascript" src="/email/joyride/jquery.cookie.js"></script>
<script type="text/javascript" src="/email/joyride/modernizr.mq.js"></script>
<script type="text/javascript" src="/email/joyride/jquery.joyride-1.0.5.js"></script>
<%@ include file="/systeminfo/init.jsp" %>
</head>
<body>
<div class="container">
<div class="row">
<div class="twelve columns">
<h2>适用浏览器：IE8、360、FireFox、Chrome、Safari、Opera、傲游、搜狗、世界之窗.</h2>
<hr>
</div>
</div>

<br><br>

<div class="row">
<div class="six columns">
<h2 id="numero1">向导：第一步!</h2>
<p>Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Curabitur blandit tempus porttitor. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Aenean lacinia bibendum nulla sed consectetur. Cras mattis consectetur purus sit amet fermentum. Cras mattis consectetur purus sit amet fermentum.</p>
</div>
<div class="six columns">

</div>
</div>

<br><br><br><br>

<div class="row">
<div class="twelve columns">
<h3 id="numero3">向导：第三步!</h3>
<p>Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.</p>
</div>
</div>

<br><br><br><br>

<div class="row">
<div class="four columns">

</div>
<div class="eight columns">
<h3 id="numero2">向导：第二步</h3>
<p>Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Curabitur blandit tempus porttitor. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Aenean lacinia bibendum nulla sed consectetur. Cras mattis consectetur purus sit amet fermentum. Cras mattis consectetur purus sit amet fermentum.</p>
</div>
</div>

<br><br><br><br>

<div class="row">
<div class="six columns">
<h4 id="numero5">结束</h4>
<p>Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Curabitur blandit tempus porttitor. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Aenean lacinia bibendum nulla sed consectetur. Cras mattis consectetur purus sit amet fermentum. Cras mattis consectetur purus sit amet fermentum.</p>
</div>
<div class="six columns">

</div>
</div>
<br><br><br><br>

<div style="float:right">It even works <span id="numero4">向导：第四步.</span></div>
</div>
<!-- Tip Content -->
<ol id="joyRideTipContent">
<li data-id="numero1" data-text="下一步" class="custom">
<h2>Stop #1</h2>
<p>You can control all the details for you tour stop. Any valid HTML will work inside of Joyride.</p>
</li>
<li data-id="numero2" data-text="下一步" data-options="tipLocation:top;tipAnimation:fade">
<h2>Stop #2</h2>
<p>Get the details right by styling Joyride with a custom stylesheet!</p>
</li>
<li data-id="numero3" data-text="下一步" data-options="tipLocation:top left;">
<h2>Stop #3</h2>
<p>It works right aligned.</p>
</li>
<li data-id="numero4" data-text="下一步">
<h2>Stop #4</h2>
<p>It works when tips run off the viewport.</p>
</li>
<li data-id="numero5" data-text="结束">
<h2>Stop #5</h2>
<p>Now what are you waiting for? Add this to your projects and get the most out of your apps!</p>
</li>
</ol>

<!-- Run the plugin -->

<script type="text/javascript">
$(window).load(function() {
$(this).joyride();
});
</script>
<br>
<div align="center">
<table border="0" width="8%" height="39"><tr><td style="text-align: center">
<div style="text-align:center;clear:both">
<p>来源：<a href="http://www.jq-school.com/" target="_blank">jq-school</a></p>
</div></td></tr></table></div>
</body>
</html>
