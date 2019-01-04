<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/security/tags" prefix="security"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <title>客户应收款期初列表页面</title>
    <%@include file="/include.jsp" %>   
  </head>
  <body>
    <div class="easyui-layout" data-options="fit:true,border:false">
    	<div data-options="region:'north',border:false">
    		<div class="buttonBG" id="account-buttons-beignAmountPage"></div>
    	</div>
    	<div data-options="region:'center'">
    		<table id="account-datagrid-beignAmountPage"></table>
            <div id="account-datagrid-toolbar-beignAmountPage" style="padding:2px;height:auto">
                <form action="" id="account-form-query-beignAmountPage" method="post">
                    <table class="querytable">
                        <tr>
                            <td>业务日期:</td>
                            <td><input type="text" name="businessdate1" style="width:100px;" class="Wdate" onfocus="WdatePicker({'dateFmt':'yyyy-MM-dd'})" value="${today }"/> 到 <input type="text" name="businessdate2" class="Wdate" style="width:100px;" onfocus="WdatePicker({'dateFmt':'yyyy-MM-dd'})" /></td>
                            <td>状态:</td>
                            <td><select name="status" style="width:150px;"><option></option><option value="2" selected="selected">保存</option><option value="3">审核通过</option><option value="4">关闭</option></select></td>
                            <td>抽单状态:</td>
                            <td>
                                <select name="isinvoice" style="width: 130px;">
                                    <option></option>
                                    <option value="1">已申请</option>
                                    <option value="0">未申请</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>客户:</td>
                            <td><input id="account-query-customerid" type="text" name="customerid" style="width: 225px;"/></td>
                            <td>单据编号:</td>
                            <td><input type="text" name="id" style="width: 150px;"/></td>
                            <td colspan="2">
                                <a href="javaScript:void(0);" id="account-queay-beignAmount" class="button-qr">查询</a>
                                <a href="javaScript:void(0);" id="account-reload-beignAmount" class="button-qr">重置</a>
                                <span id="account-query-advanced-beignAmount"></span>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
    	</div>
    </div>
    <div id="account-panel-beignAmount-addpage"></div>
     <script type="text/javascript">
     	var initQueryJSON = $("#account-form-query-beignAmountPage").serializeJSON();
  		var footerobject = null;
    	$(function(){
    		//按钮
			$("#account-buttons-beignAmountPage").buttonWidget({
				initButton:[
					{},
					<security:authorize url="/account/beginamount/beignAmountAddPage.do">
						{
							type: 'button-add',
							handler: function(){
								$('#account-panel-beignAmount-addpage').dialog({  
								    title: '应收款期初新增',  
								    width: 650,  
								    height: 310,  
								    collapsible:false,
								    minimizable:false,
								    maximizable:true,
								    resizable:true,
								    closed: true,  
								    cache: false,  
								    href: 'account/beginamount/beignAmountAddPage.do',  
								    modal: true,
								    onLoad:function(){
								    	$("#account-beignamount-customerid").focus();
								    }
								});
								$('#account-panel-beignAmount-addpage').dialog("open");
							}
						},
					</security:authorize>
					<security:authorize url="/account/beginamount/beignAmountEditPage.do">
						{
							type: 'button-edit',
							handler: function(){
								var con = $("#account-datagrid-beignAmountPage").datagrid('getSelected');
								if(con == null){
									$.messager.alert("提醒","请选择一条记录");
									return false;
								}	
								if(con.status=='2'){
									$('#account-panel-beignAmount-addpage').dialog({  
									    title: '应收款期初修改',  
									    width: 650,  
									    height: 310,  
									    collapsible:false,
									    minimizable:false,
									    maximizable:true,
									    resizable:true,
									    closed: true,  
									    cache: false,  
									    href: 'account/beginamount/beignAmountEditPage.do?id='+con.id,  
									    modal: true,
									    onLoad:function(){
									    	$("#account-beignAmount-customerid").focus();
									    }
									});
									$('#account-panel-beignAmount-addpage').dialog("open");
								}else{
									$('#account-panel-beignAmount-addpage').dialog({  
									    title: '应收款期初修改',  
									    width: 650,  
									    height: 310,  
									    collapsible:false,
									    minimizable:false,
									    maximizable:true,
									    resizable:true,
									    closed: true,  
									    cache: false,  
									    href: 'account/beginamount/beignAmountViewPage.do?id='+con.id,  
									    modal: true,
									    onLoad:function(){
									    	$("#account-beignAmount-customerid").focus();
									    }
									});
									$('#account-panel-beignAmount-addpage').dialog("open");
								}
							}
						},
					</security:authorize>
					<security:authorize url="/account/beginamount/deletebeignAmount.do">
						{
							type: 'button-delete',
							handler: function(){
								$.messager.confirm("提醒","是否删除当前应收款期初？",function(r){
									if(r){
										var rows = $("#account-datagrid-beignAmountPage").datagrid("getChecked");
										var ids = "";
										for(var i=0;i<rows.length;i++){
											if(ids==""){
												ids = rows[i].id;
											}else{
												ids += ","+ rows[i].id;
											}
										}
										if(ids!=""){
											loading("提交中..");
											$.ajax({   
									            url :'account/beginamount/deleteMutbeignAmount.do?ids='+ids,
									            type:'post',
									            dataType:'json',
									            success:function(json){
									            	loaded();
									            	if(json.flag){
									            		$.messager.alert("提醒", "操作成功</br>"+json.succssids+"</br>"+json.errorids);
									            		$("#account-datagrid-beignAmountPage").datagrid("reload");
									            	}else{
									            		$.messager.alert("提醒", "删除失败");
									            	}
									            },
									            error:function(){
									            	$.messager.alert("错误", "删除出错");
									            	loaded();
									            }
									        });
										}
									}
								});
							}
						},
					</security:authorize>
					<security:authorize url="/account/beginamount/auditbeignAmount.do">
						{
							type: 'button-audit',
							handler: function(){
								$.messager.confirm("提醒","是否审核选中的应收款期初？",function(r){
									if(r){
										var rows = $("#account-datagrid-beignAmountPage").datagrid("getChecked");
										var ids = "";
										for(var i=0;i<rows.length;i++){
											if(ids==""){
												ids = rows[i].id;
											}else{
												ids += ","+ rows[i].id;
											}
										}
										loading("审核中..");
										$.ajax({   
									            url :'account/beginamount/auditMutbeignAmount.do?ids='+ids,
									            type:'post',
									            dataType:'json',
									            success:function(json){
									            	loaded();
									            	if(json.flag){
									            		$.messager.alert("提醒", "操作成功</br>"+json.succssids+"</br>"+json.errorids);
									            		$("#account-datagrid-beignAmountPage").datagrid("reload");
									            	}else{
									            		$.messager.alert("提醒", "审核失败");
									            	}
									            },
									            error:function(){
									            	$.messager.alert("错误", "审核出错");
									            	loaded();
									            }
									        });
									}
								});
							}
						},
					</security:authorize>
					<security:authorize url="/account/beginamount/oppauditbeignAmount.do">
						{
				 			type:'button-oppaudit',
				 			handler:function(){
				 				$.messager.confirm("提醒","是否反审应收款期初？",function(r){
									if(r){
										var rows = $("#account-datagrid-beignAmountPage").datagrid("getChecked");
										var ids = "";
										for(var i=0;i<rows.length;i++){
											if(ids==""){
												ids = rows[i].id;
											}else{
												ids += ","+ rows[i].id;
											}
										}
										loading("反审中..");
										if(ids!=""){
											$.ajax({   
									            url :'account/beginamount/oppauditMutbeignAmount.do?ids='+ids,
									            type:'post',
									            dataType:'json',
									            success:function(json){
									            	loaded();
									            	if(json.flag){
									            		$.messager.alert("提醒", "操作成功</br>"+json.succssids+"</br>"+json.errorids);
									            		$("#account-datagrid-beignAmountPage").datagrid("reload");
									            	}else{
									            		$.messager.alert("提醒", "反审失败");
									            	}
									            },
									            error:function(){
									            	$.messager.alert("错误", "反审出错");
									            	loaded();
									            }
									        });
										}
									}
								});
				 			}
			 			},
					</security:authorize>
					<security:authorize url="/account/beginamount/beignAmountViewPage.do">
						{
							type: 'button-view',
							handler: function(){
								var con = $("#account-datagrid-beignAmountPage").datagrid('getSelected');
								if(con == null){
									$.messager.alert("提醒","请选择一条记录");
									return false;
								}	
								$('#account-panel-beignAmount-addpage').dialog({  
								    title: '应收款期初查看',  
								    width: 650,  
								    height: 310,  
								    collapsible:false,
								    minimizable:false,
								    maximizable:true,
								    resizable:true,
								    closed: true,  
								    cache: false,  
								    href: 'account/beginamount/beignAmountViewPage.do?id='+con.id,  
								    modal: true
								});
								$('#account-panel-beignAmount-addpage').dialog("open");
							}
						},
					</security:authorize>
					<security:authorize url="/account/beginamount/beignAmountImport.do">
						{
							type: 'button-import',
							attr: {
								type:'importUserdefined',
								queryForm: "#account-form-query-beignAmountPage",//需要传入的条件 放在form表单内
						 		url:'account/beginamount/importBeignAmount.do',
						 		importparam:'客户期初导入。金额，客户编号或者客户名称必填。</br>单据号，业务日期，应收日期，不填的话系统自动生成',
								onClose: function(){ //导入成功后窗口关闭时操作，
									$("#account-datagrid-beignAmountPage").datagrid("reload");
								}
							}
						},
					</security:authorize>
					<security:authorize url="/account/beginamount/exportBeignAmount.do">
						{
							type: 'button-export',
							attr: {
								queryForm: "#account-form-query-beignAmountPage", //查询条件的form表单，导出时只用通过查询的条件，将通用查询放在form表单里面。
						 		type:'exportUserdefined',
						 		name:'客户应收款期初',
						 		url:'account/beginamount/exportBeignAmount.do'
							}
						},
					</security:authorize>
                    {
                        type: 'button-commonquery',
                        attr:{
                            //查询针对的表
                            name:'t_account_begin_amount',
                            //查询针对的表格id
                            datagrid:'account-datagrid-beignAmountPage',
                            plain:true
                        }
                    },
					{}
				],
				model: 'bill',
				type: 'list',
				tname: 't_account_begin_amount'
			});
			var tableColumnListJson = $("#account-datagrid-beignAmountPage").createGridColumnLoad({
				name :'t_account_begin_amount',
				frozenCol : [[
			    			]],
				commonCol : [[
							  {field:'ck',checkbox:true},
							  {field:'id',title:'编号',width:130,sortable:true},
							  {field:'businessdate',title:'业务日期',width:80,sortable:true},
							  {field:'customerid',title:'客户编码',width:60,sortable:true},
							  {field:'customername',title:'客户名称',width:200,isShow:true},
							  {field:'amount',title:'金额',resizable:true,align:'right',sortable:true,
							  	formatter:function(value,rowData,rowIndex){
					        		return formatterMoney(value);
					        	}
							  },
							  {field:'duefromdate',title:'应收日期',width:80,sortable:true},
							  {field:'isinvoice',title:'抽单状态',width:60,sortable:true,
							  	formatter:function(value,rowData,rowIndex){
							  		if(value=="1"){
							  			return "已申请";
							  		}else if(value=="0"){
							  			return "未申请";
							  		}
					        	}
							  },
							  {field:'invoicedate',title:'抽单日期',width:80,sortable:true},
							  {field:'iswriteoff',title:'是否核销',width:60,sortable:true,
							  	formatter:function(value,rowData,rowIndex){
							  		if(value=="1"){
							  			return "已核销";
							  		}else if(value=="0"){
							  			return "未核销";
							  		}
					        	}
							  },
							  {field:'writeoffdate',title:'核销日期',width:80,sortable:true},
							  {field:'addusername',title:'制单人',width:60,sortable:true},
							  {field:'addtime',title:'制单时间',width:100,sortable:true,hidden:true},
							  {field:'auditusername',title:'审核人',width:60,sortable:true,hidden:true},
							  {field:'audittime',title:'审核时间',width:100,sortable:true,hidden:true},
							  {field:'stopusername',title:'中止人',width:60,hidden:true,hidden:true},
							  {field:'stoptime',title:'中止时间',width:80,hidden:true,sortable:true,hidden:true},
							  {field:'status',title:'状态',width:60,sortable:true,
							  	formatter:function(value,rowData,rowIndex){
					        		return getSysCodeName("status",value);
					        	}
							  },
							  {field:'remark',title:'备注',width:80,sortable:true}
				             ]]
			});
			$("#account-datagrid-beignAmountPage").datagrid({ 
		 		authority:tableColumnListJson,
		 		frozenColumns: tableColumnListJson.frozen,
				columns:tableColumnListJson.common,
		 		fit:true,
		 		method:'post',
		 		rownumbers:true,
		 		pagination:true,
		 		idField:'id',
		 		sortName:'businessdate',
		 		sortOrder:'desc',
		 		singleSelect:false,
		 		checkOnSelect:true,
		 		selectOnCheck:true,
		 		showFooter: true,
				url: 'account/beginamount/showBeignAmountList.do',
				queryParams:initQueryJSON,
				toolbar:'#account-datagrid-toolbar-beignAmountPage',
				onDblClickRow:function(rowIndex, rowData){
					if(rowData.status=='2'){
						$('#account-panel-beignAmount-addpage').dialog({  
						    title: '应收款期初修改',  
						    width: 650,  
						    height: 310,  
						    collapsible:false,
						    minimizable:false,
						    maximizable:true,
						    resizable:true,
						    closed: true,  
						    cache: false,  
						    href: 'account/beginamount/beignAmountEditPage.do?id='+rowData.id,  
						    modal: true,
						    onLoad:function(){
						    	$("#account-beignamount-customerid").focus();
						    }
						});
						$('#account-panel-beignAmount-addpage').dialog("open");
					}else{
						$('#account-panel-beignAmount-addpage').dialog({  
						    title: '应收款期初查看',  
						    width: 650,  
						    height: 310,  
						    collapsible:false,
						    minimizable:false,
						    maximizable:true,
						    resizable:true,
						    closed: true,  
						    cache: false,  
						    href: 'account/beginamount/beignAmountViewPage.do?id='+rowData.id,  
						    modal: true
						});
					$('#account-panel-beignAmount-addpage').dialog("open");
					}
				},
				onLoadSuccess: function(){
					var footerrows = $(this).datagrid('getFooterRows');
					if(null!=footerrows && footerrows.length>0){
						footerobject = footerrows[0];
						countTotalAmount();
					}
				},
				onCheckAll:function(){
					countTotalAmount();
				},
				onUncheckAll:function(){
					countTotalAmount();
				},
				onCheck:function(){
					countTotalAmount();
				},
				onUncheck:function(){
					countTotalAmount();
				}
			}).datagrid("columnMoving");
			
			$("#account-query-customerid").widget({
				name:'t_account_collection_order',
				col:'customerid',
    			singleSelect:false,
    			width:225,
    			onlyLeafCheck:false,
    			view:true
			});
			$("#account-query-bank").widget({
				name:'t_account_collection_order',
				col:'bank',
    			singleSelect:false,
    			width:180,
    			view:true
			});
			
			
			//通用查询组建调用
//			$("#account-query-advanced-beignAmount").advancedQuery({
//				//查询针对的表
//		 		name:'t_account_begin_amount',
//		 		//查询针对的表格id
//		 		datagrid:'account-datagrid-beignAmountPage',
//		 		plain:true
//			});
			
			//查询
			$("#account-queay-beignAmount").click(function(){
				//把form表单的name序列化成JSON对象
	       		var queryJSON = $("#account-form-query-beignAmountPage").serializeJSON();
	       		$("#account-datagrid-beignAmountPage").datagrid("load",queryJSON);
			});
			//重置
			$("#account-reload-beignAmount").click(function(){
				$("#account-query-customerid").widget("clear");
				$("#account-form-query-beignAmountPage")[0].reset();
				var queryJSON = $("#account-form-query-beignAmountPage").serializeJSON();
				$("#account-datagrid-beignAmountPage").datagrid("load",queryJSON);
			});
			$("#account-export-beignAmount").Excel('export',{
				queryForm: "#account-form-query-beignAmountPage", //查询条件的form表单，导出时只用通过查询的条件，将通用查询放在form表单里面。
		 		type:'exportUserdefined',
		 		name:'收款单列表',
		 		url:'account/beginamount/exportbeignAmountList.do'
			});
    	});
    	function countTotalAmount(){
    		var rows =  $("#account-datagrid-beignAmountPage").datagrid('getChecked');
    		var amount = 0;
    		var writeoffamount = 0;
    		var remainderamount = 0;
    		
    		for(var i=0;i<rows.length;i++){
    			amount = Number(amount)+Number(rows[i].amount == undefined ? 0 : rows[i].amount);
    			writeoffamount = Number(writeoffamount)+Number(rows[i].writeoffamount == undefined ? 0 : rows[i].writeoffamount);
    			remainderamount = Number(remainderamount)+Number(rows[i].remainderamount == undefined ? 0 : rows[i].remainderamount);
    		}
    		var footerrows = [{businessdate:'选中金额',amount:amount,writeoffamount:writeoffamount,remainderamount:remainderamount}];
    		if(null != footerobject){
    			footerrows.push(footerobject);
    		}
    		$("#account-datagrid-beignAmountPage").datagrid("reloadFooter",footerrows);
    	}
    </script>
  </body>
</html>