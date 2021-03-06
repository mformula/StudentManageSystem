<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>用户列表</title>
	<link rel="stylesheet" type="text/css" href="../easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="../easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="../easyui/css/demo.css">
	<script type="text/javascript" src="../easyui/jquery.min.js"></script>
	<script type="text/javascript" src="../easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="../easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		var table;
		
		//datagrid初始化 
	    $('#dataList').datagrid({ 
	        title:'用户列表', 
	        iconCls:'icon-more',//图标 
	        border: true, 
	        collapsible:false,//是否可折叠的 
	        fit: true,//自动大小 
	        method: "post",
	        url:"get_list?t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect:false,//是否单选 
	        pagination:true,//分页控件 
	        rownumbers:true,//行号 
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'username',title:'姓名',width:150, sortable: true},    
 		        {field:'password',title:'密码',width:150},		       
	 		]], 
	        toolbar: "#toolbar"
	    }); 
	    //设置分页控件 
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,//每页显示的记录条数，默认为10 
	        pageList: [10,20,30,50,100],//可以设置每页记录条数的列表 
	        beforePageText: '第',//页数文本框前显示的汉字 
	        afterPageText: '页    共 {pages} 页', 
	        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录', 
	    }); 
	    //设置工具类按钮
	    $("#add").click(function(){
	    	table = $("#addTable");
	    	$("#addDialog").dialog("open");
	    });
	    //修改
	    $("#edit").click(function(){
	    	table = $("#editTable");
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("消息提醒", "请选择一条数据进行操作!", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	    //删除
	    $("#delete").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	var selectLength = selectRows.length;
        	if(selectLength == 0){
            	$.messager.alert("消息提醒", "请选择数据进行删除!", "warning");
            } else{
            	var ids = [];
            	$(selectRows).each(function(i, row){
            		ids[i] = row.id;
            	});
            	var numbers = [];
            	$(selectRows).each(function(i, row){
            		numbers[i] = row.number;
            	});
            	$.messager.confirm("消息提醒", "将删除与用户相关的所有数据，确认继续？", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "TeacherServlet?method=DeleteTeacher",
							data: {ids: ids,numbers:numbers},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("消息提醒","删除成功!","info");
									//刷新表格
									$("#dataList").datagrid("reload");
									$("#dataList").datagrid("uncheckAll");
								} else{
									$.messager.alert("消息提醒","删除失败!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	    
	  	//设置添加窗口
	    $("#addDialog").dialog({
	    	title: "添加用户",
	    	width: 350,
	    	height: 250,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'添加',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							
							var data = $("#addForm").serialize();
							
							$.ajax({
								type: "post",
								url: "add",
								data: data,
								dataType:'json',
								success: function(data){
									if(data.type == "success"){
										$.messager.alert("消息提醒","添加成功!","info");
										//关闭窗口
										$("#addDialog").dialog("close");
										//清空原表格数据
										$("#add_username").textbox('setValue', "");
										$("#add_password").textbox('setValue', "");										
										//重新刷新页面数据
							  			$('#dataList').datagrid("reload");
										
									} else{
										$.messager.alert("消息提醒",data.msg,"warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'重置',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						$("#add_username").textbox('setValue', "");
						$("#add_password").textbox('setValue', "");						
					}
				},
			],
			onClose: function(){
				$("#add_username").textbox('setValue', "");
				$("#add_password").textbox('setValue', "");
			}
	    });
	  	
	  	//设置课程窗口
	    $("#chooseCourseDialog").dialog({
	    	title: "设置课程",
	    	width: 400,
	    	height: 300,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'添加',
					plain: true,
					iconCls:'icon-book-add',
					handler:function(){
			    		//添加之前先判断是否已选择该课程
						var chooseCourse = [];
						$(table).find(".chooseTr").each(function(){
							var gradeid = $(this).find("input[textboxname='gradeid']").attr("gradeId");
							var clazzid = $(this).find("input[textboxname='clazzid']").attr("clazzId");
							var courseid = $(this).find("input[textboxname='courseid']").attr("courseId");
							var course = gradeid+"_"+clazzid+"_"+courseid;
							chooseCourse.push(course);
						});
						//获取新选择的课程
			    		var gradeId = $("#add_gradeList").combobox("getValue");
			    		var clazzId = $("#add_clazzList").combobox("getValue");
			    		var courseId = $("#add_courseList").combobox("getValue");
						var newChoose = gradeId+"_"+clazzId+"_"+courseId;
						for(var i = 0;i < chooseCourse.length;i++){
							if(newChoose == chooseCourse[i]){
								$.messager.alert("消息提醒","已选择该门课程!","info");
								return;
							}
						}
						
						//添加到表格显示
						var tr = $("<tr class='chooseTr'><td>课程:</td></tr>");
						
			    		var gradeName = $("#add_gradeList").combobox("getText");
			    		var gradeTd = $("<td></td>");
			    		var gradeInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='gradeid' />").val(gradeName).attr("gradeId", gradeId);
			    		$(gradeInput).appendTo(gradeTd);
			    		$(gradeTd).appendTo(tr);
			    		
			    		var clazzName = $("#add_clazzList").combobox("getText");
			    		var clazzTd = $("<td></td>");
			    		var clazzInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='clazzid' />").val(clazzName).attr("clazzId", clazzId);
			    		$(clazzInput).appendTo(clazzTd);
			    		$(clazzTd).appendTo(tr);
			    		
			    		var courseName = $("#add_courseList").combobox("getText");
			    		var courseTd = $("<td></td>");
			    		var courseInput = $("<input style='width: 200px; height: 30px;' data-options='readonly: true' class='easyui-textbox' name='courseid' />").val(courseName).attr("courseId", courseId);
			    		$(courseInput).appendTo(courseTd);
			    		$(courseTd).appendTo(tr);
			    		
			    		var removeTd = $("<td></td>");
			    		var removeA = $("<a href='javascript:;' class='easyui-linkbutton removeBtn'></a>").attr("data-options", "iconCls:'icon-remove'");
			    		$(removeA).appendTo(removeTd);
			    		$(removeTd).appendTo(tr);
			    		
			    		$(tr).appendTo(table);
			    		
			    		//解析
			    		$.parser.parse($(table).find(".chooseTr :last"));
			    		//关闭窗口
			    		$("#chooseCourseDialog").dialog("close");
					}
				}
			]
	    });	  
	  	
	  	//编辑用户信息
	  	$("#editDialog").dialog({
	  		title: "修改用户信息",
	    	width: 850,
	    	height: 550,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'提交',
					plain: true,
					iconCls:'icon-edit',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("消息提醒","请检查你输入的数据!","warning");
							return;
						} else{
							var data = $("#editForm").serialize();							
							$.ajax({
								type: "post",
								url: "edit",
								data: data,
								dataType:'json',
								success: function(data){
									if(data.type== "success"){
										$.messager.alert("消息提醒","修改成功!","info");
										//关闭窗口
										$("#editDialog").dialog("close");
										//清空原表格数据
										$("#edit_username").textbox('setValue', "");
										$("#edit_password").textbox('setValue', "");																			
										//重新刷新页面数据
							  			$('#dataList').datagrid("reload");
							  			$('#dataList').datagrid("uncheckAll");
										
									} else{
										$.messager.alert("消息提醒",data.msg,"warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'重置',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						$("#edit_username").textbox('setValue', "");
						$("#edit_password").textbox('setValue', "");											
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//设置值
				console.log(selectRow);
				$("#edit_id").val(selectRow.id); 
				$("#edit_username").textbox('setValue', selectRow.username);
				$("#edit_password").textbox('setValue', selectRow.password);									
			},
			onClose: function(){
				$("#edit_username").textbox('setValue', "");
				$("#edit_password").textbox('setValue', "");											
			}
	    });	  
	  	
	  	$("#search-btn").click(function(){
	  		$("#dataList").datagrid('reload',{
	  			username:$("#search-username").textbox('getValue')
	  		});	  		
	  	});
	    
	});
	</script>
</head>
<body>
	<!-- 数据列表 -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	<!-- 工具栏 -->
	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div>
			<a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">删除</a>
			用户名：<input id="search-username" class="easyui-textbox">
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">搜索</a>
		</div>
		
	</div>
	
	<!-- 添加窗口 -->
	<div id="addDialog" style="padding: 10px;">  
   		<form id="addForm" method="post">
	    	<table id="addTable" cellpadding="8px">
	    		<tr>
	    			<td style="width:40px">姓名:</td>
	    			<td colspan="3">
	    				<input id="add_username"  class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="username" data-options="required:true, validType:'repeat', missingMessage:'请填写姓名'" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>密码:</td>
	    			<td colspan="4"><input id="add_password" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="password" data-options="required:true, missingMessage:'请填写密码'" /></td>
	    		</tr>	    		
	    	</table>
	    </form>
	</div>
	
	<!-- 设置课程 -->
<!-- 	<div id="chooseCourseDialog" style="padding: 10px">
	   	<table cellpadding="8" >
	   		<tr>
	   			<td>年级：</td>
	   			<td><input id="add_gradeList" style="width: 200px; height: 30px;" class="easyui-combobox" name="gradeid" /></td>
	   		</tr>
	   		<tr>
	   			<td>班级：</td>
	   			<td><input id="add_clazzList" style="width: 200px; height: 30px;" class="easyui-combobox" name="clazzid" /></td>
	   		</tr>
	   		<tr>
	   			<td>课程：</td>
	   			<td><input id="add_courseList" style="width: 200px; height: 30px;" class="easyui-combobox" name="courseid" /></td>
	   		</tr>
	   	</table>
	</div> -->
	
	<!-- 修改窗口 -->
	<div id="editDialog" style="padding: 10px">		
    	<form id="editForm" method="post">
    		<input id="edit_id" type="hidden" name="id">
	    	<table id="editTable" cellpadding="8px">
	    		<tr>
	    			<td style="width:40px">姓名:</td>
	    			<td colspan="3">
	    				<input id="edit_username"  class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="username" data-options="required:true, validType:'repeat', missingMessage:'请填写姓名'" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>密码:</td>
	    			<td colspan="4"><input id="edit_password" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="password" data-options="required:true, missingMessage:'请填写密码'" /></td>
	    		</tr>	    		
	    	</table>
	    </form>
	</div>
	
	
</body>
</html>