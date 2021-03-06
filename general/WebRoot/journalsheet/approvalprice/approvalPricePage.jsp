<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/security/tags" prefix="security"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <title>核准金额页面</title>
    <%@include file="/include.jsp" %>
  </head>
  
  <body>
    <div class="easyui-layout" data-options="fit:true,border:false">
    	<div data-options="region:'north',border:false">
    		<div id="finance-button-approvalPrice" style="height: 26px;"></div>
    	</div>
    	<div data-options="region:'center',border:true">
    		<div id="finance-table-approvalPriceBtn">
    			<form action="" id="approvalPrice-form-ListQuery" method="post">
	    			<table>
	    				<tr>
	    					<td>供应商：</td>
	    					<td><input id="finance-widget-approvalPriceQuery" name="supplierid" type="text" style="width: 320px;"/></td>
	    					<td>
	    						<a href="javaScript:void(0);" id="approvalPrice-query-List" iconCls="icon-search">查询</a>
	    						<a href="javaScript:void(0);" id="approvalPrice-init-List" class="easyui-linkbutton" iconCls="button-add" title="供应商初始化">初始化</a>
	    					</td>
	    				</tr>
	    			</table>
	    		</form>
    		</div>
    		<table id="finance-table-approvalPrice"></table>
    	</div>
    </div>
    <div id="approvalPrice-dialog-operate"></div>
    <div id="approvalPrice-dialog-supplier"></div>
    <script type="text/javascript">
    	var approvalPrice_AjaxConn = function (Data, Action, Str) {
    		if(null != Str && "" != Str){
    			loading(Str);
    		}
		   var MyAjax = $.ajax({
		        type: 'post',
		        cache: false,
		        url: Action,
		        data: Data,
		        async: false,
		        success:function(data){
		        	loaded();
		        }
		    })
		    return MyAjax.responseText;
		}
	     
	    //判断是否加锁
		function isLockData(id,tablename){
			var flag = false;
			$.ajax({
	            url :'system/lock/isLockData.do',
	            type:'post',
	            data:{id:id,tname:tablename},
	            dataType:'json',
	            async: false,
	            success:function(json){
	            	flag = json.flag
	            }
	        });
	        return flag;
		}
	    //加锁
	    function isDoLockData(id,tablename){
	    	var flag = false;
	    	$.ajax({   
	            url :'system/lock/isDoLockData.do',
	            type:'post',
	            data:{id:id,tname:tablename},
	            dataType:'json',
	            async: false,
	            success:function(json){
	            	flag = json.flag
	            }
	        });
	        return flag;
	    }
	     function refreshLayout(title, url){
	   		$('#approvalPrice-dialog-operate').dialog({  
			    title: title,  
			    width: 500,  
			    height: 280,  
			    closed: false,  
			    cache: false,  
			    href: url,  
			    modal: true
			});
			$('#approvalPrice-dialog-operate').dialog('open');
	   	}
	   	
	   	//通用查询组建调用
		$("#approvalPrice-query-advanced").advancedQuery({
			//查询针对的表
	 		name:'finance_approvalPrice',
	 		//查询针对的表格id
	 		datagrid:'finance-table-approvalPrice'
		});
	   	
	   	$(function(){
	   		//供应商查询
		  	$("#finance-widget-approvalPriceQuery").widget({
		  		width:300,
				name:'t_finance_expensesentering',
				col:'supplierid',
				singleSelect:true
			});
			
			//科目查询
		  	$("#finance-widget-subjectidquery").widget({
		  		width:120,
				name:'t_finance_approvalPrice',
				col:'subjectid',
				singleSelect:true
			});
			
	   		$("#finance-table-approvalPrice").datagrid({ 
	  	 		fit:true,
	  	 		method:'post',
	  	 		columns:[[
					{field:'id',title:'编码',width:80,hidden:true},
					{field:'supplierid',title:'供应商编码',width:70},
					{field:'supplierName',title:'供应商名称',width:320,isShow:true},
					{field:'supplierdeptid',title:'所属部门',width:80,
						formatter:function(val,rowData,rowIndex){
							return rowData.supplierdeptName;
						}
					},
					{field:'price',title:'核准金额',resizable:true,align:'right',
						formatter:function(val,rowData,rowIndex){
							if(val != "" && val != null){
								return formatterMoney(val);
							}
							else{
								return "0.00";
							}
						}
					}
				]],
	  	 		rownumbers:true,
	  	 		pagination:true,
	  	 		idField:'id',
	  	 		singleSelect:true,
				pageSize:20,
				pageList:[10,20,30,50],
				toolbar:'#finance-table-approvalPriceBtn',
			    url:'journalsheet/approvalPrice/getApprovalPriceList.do',
			    onDblClickRow:function(rowIndex, rowData){
			    	$('#approvalPrice-dialog-operate').dialog({  
					    title: '金额修改',  
					    width: 500,  
					    height: 160,  
					    closed: false,  
					    cache: false,  
					    href: 'journalsheet/approvalPrice/apPriceEditPage.do?id='+rowData.id,  
					    modal: true
					});
					$('#approvalPrice-dialog-operate').dialog('open');
			    }
			});
	   		
	   		//回车事件
			controlQueryAndResetByKey("approvalPrice-query-List","");
	   		
	   		//查询
			$("#approvalPrice-query-List").click(function(){
				//把form表单的name序列化成JSON对象
	      		var queryJSON = $("#approvalPrice-form-ListQuery").serializeJSON();
	      		//调用datagrid本身的方法把JSON对象赋给queryParams 即可进行查询
	      		$("#finance-table-approvalPrice").datagrid("load",queryJSON);
			});
			
			//初始化按钮
			$("#approvalPrice-init-List").click(function(){
				$('#approvalPrice-dialog-supplier').dialog({  
				    title: '初始化供应商列表',  
				    width: 500,  
				    height: 280,  
				    closed: false,  
				    cache: false,  
				    href: 'journalsheet/approvalPrice/supplierListAddPage.do',  
				    modal: true
				});
				$('#approvalPrice-dialog-supplier').dialog('open');
			});
	   		$("#finance-button-approvalPrice").buttonWidget({
     			//初始默认按钮 根据type对应按钮事件
				initButton:[
					{},
					<security:authorize url="/journalsheet/approvalPrice/approvalPriceDelBtn.do">
		 			{
			 			type:'button-delete',//删除
			 			handler:function(){
			 				var approvalPrice=$("#finance-table-approvalPrice").datagrid('getSelected');
				  			if(approvalPrice==null){
				  				$.messager.alert("提醒","请选择相应的核准金额!");
				  				return false;
				  			}
				  			var flag = isLockData(approvalPrice.id,"t_finance_approvalPrice");
							if(flag){
								$.messager.alert("警告","该数据正在被其他人操作，暂不能删除！");
								return false;
							}
				  			$.messager.confirm("提醒","是否确认删除核准金额?",function(r){
				  				if(r){
				  					var ret = approvalPrice_AjaxConn({id:approvalPrice.id},'journalsheet/approvalPrice/deleteapprovalPrice.do','删除中..');
									var retJson = $.parseJSON(ret);
									if(retJson.delFlag){
					  					$.messager.alert("提醒","该信息已被其他信息引用，无法删除！");
					  					return false;
					  				}
									if(retJson.flag){
										$("#finance-table-approvalPrice").datagrid('reload');
										$("#finance-table-approvalPrice").datagrid('clearSelections');
										$.messager.alert("提醒","删除成功!");
									}
									else{
										$.messager.alert("提醒","删除失败!");
									}
				  				}
				  			});
			 			}
		 			},
		 			</security:authorize>
		 			{}
	 			],
	 			model:'base',
				type:'view',
				tname:'t_finance_approvalPrice',
				id:''
     		});
	   	});
    </script>
  </body>
</html>
