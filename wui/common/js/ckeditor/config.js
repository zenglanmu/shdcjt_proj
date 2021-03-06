﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/


CKEDITOR.editorConfig = function( config )   
{   
// Define changes to default configuration here. For example:   
config.language = 'zh-cn'; //配置语言   
//config.uiColor = '#FFF'; //背景颜色   
//config.width = 500; //宽度   
//config.height = 500; //高度   
config.resize_enabled = false;
config.skin='v2';
//工具栏   
//config.toolbar =  "base" ;
config.pasteFromWordPromptCleanup = true;
config.pasteFromWordRemoveFontStyles = false;
config.extraPlugins="customimage,customflash,insertdocs,insertwf,insertcrm,insertproject,inserttask";
config.font_defaultLabel = '微软雅黑';	
config.font_names =
    'Arial;Helvetica;' +
    'Times New Roman; Times; ' +
    'Verdana;微软雅黑 ;宋体;新宋体;黑体;隶书;楷体_GB2312;仿宋_GB2312';
config.toolbar_base = 
	[   
	    ['Source','-','Bold','Italic','Underline'],  ['Link','Unlink'],      
	    ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],   
	    ['customimage','Flash','Table','-','Outdent','Indent'], 
	    ['insertdocs','insertwf','insertcrm','insertproject','inserttask'],
	    ['Font','FontSize','TextColor','BGColor'],   
	    ['Undo','Redo']
	];   

config.toolbar_simple = 
	[   
	    ['Source','-','Bold','Italic','Underline'],  ['Link','Unlink'],      
	    ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],   
	    ['Outdent','Indent'], 
	    ['insertdocs','insertwf','insertcrm','insertproject','inserttask'],
	    ['FontSize','TextColor','BGColor'],   
	    ['Undo','Redo']
	];   

config.toolbar_Full = 
	[ 
	    ['Source','-','Save','NewPage','Preview','-','Templates'], 
	    ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'], 
	    ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'], 
	    ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'], 
	    ['BidiLtr', 'BidiRtl'], 
	    '/', 
	    ['Bold','Italic','Underline','Strike','-','Subscript','Superscript'], 
	    ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'], 
	    ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'], 
	    ['Link','Unlink','Anchor'], 
	    ['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak'], 
	    '/', 
	    ['Styles','Format','Font','FontSize'], 
	    ['TextColor','BGColor'], 
	    ['Maximize', 'ShowBlocks','-','About'] 
	]; 

}; 