<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/security/tags" prefix="security"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>关联金税税收分类商品信息分页列表</title>
    <%@include file="/include.jsp" %>
</head>

<body>
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'north',border:false">
        <div class="buttonBG" id="htgoldtax-button-linkJsTypeCodeGoodsList"></div>
    </div>
    <div data-options="region:'center'">
        <table id="htgoldtax-table-linkJsTypeCodeGoodsList"></table>
        <div id="htgoldtax-query-linkJsTypeCodeGoodsList" style="padding:0px;height:auto">
            <form action="" id="htgoldtax-form-linkJsTypeCodeGoodsList" method="post" style="padding-top: 2px;">
                <table>
                    <tr>
                        <td>商品编码:</td>
                        <td colspan="3"><input type="text" id="htgoldtax-linkJsTypeCodeGoodsList-query-goodsid" name="goodsidlike" style="width:470px" /></td>
                    </tr>
                    <tr>
                        <td>税收分类编码:</td>
                        <td><input type="text" id="htgoldtax-jsTaxTypeCodeList-query-jstypeid" name="jstypeid" style="width:180px" /></td>
                        <td>商品名称:</td>
                        <td><input type="text" name="goodsname" style="width:180px" /></td>
                    </tr>
                    <tr>
                        <td>税收分类说明:</td>
                        <td><input type="text" name="description" style="width:180px" /></td>
                        <td>税收分类关键词:</td>
                        <td><input type="text" name="keyword" style="width:180px" /></td>
                        <td>
                            <a href="javaScript:void(0);" id="htgoldtax-query-queryLinkJsTypeCodeGoodsList" class="button-qr">查询</a>
                            <a href="javaScript:void(0);" id="htgoldtax-query-reloadLinkJsTypeCodeGoodsList" class="button-qr">重置</a>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
</div>
<div style="display:none">
    <div id="htgoldtax-dialog-link-jsTaxTypeCode">
        <form action="" id="htgoldtax-dialog-link-jsTaxTypeCode-form" method="post">
            <table>
                <tbody>
                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;">税收分类编码：</td>
                    <td>
                        <input id="htgoldtax-dialog-link-jsTaxTypeCode-form-jstypeid" name="jstypeid" type="text" />
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(function(){

        $("#htgoldtax-jsTaxTypeCodeList-query-jstypeid").widget({
            referwid:'RL_T_BASE_JSTAXTYPECODE',
            singleSelect:true,
            width:'180'
        });

        $("#htgoldtax-dialog-link-jsTaxTypeCode-form-jstypeid").widget({
            referwid:'RL_T_BASE_JSTAXTYPECODE',
            singleSelect:true,
            width:'200',
            required:true
        });

        $("#htgoldtax-linkJsTypeCodeGoodsList-query-goodsid").widget({
            referwid:'RL_T_BASE_GOODS_INFO',
            singleSelect:true,
            width:470,
            onlyLeafCheck:true
        });
        //根据初始的列与用户保存的列生成以及字段权限生成新的列
        var linkJsTypeCodeGoodsListColJson=$("#htgoldtax-table-linkJsTypeCodeGoodsList").createGridColumnLoad({
            name:'print_templet_resouce',
            frozenCol:[[
                {field:'idok',checkbox:true,isShow:true}
            ]],
            commonCol:[[
                {field:'goodsid',title:'商品编号',width:100,sortable:true},
                {field:'goodsname',title:'商品名称',width:200},
                {field:'jstypeid',title:'金税编码',width:100},
                {field:'jstypename',title:'货物和劳务名称',width:100},
                {field:'description',title:'说明',width:100,hidden:true},
                {field:'key',title:'关键字',width:200,hidden:true},
                {field:'spell',title:'助记符',width:100},
                {field:'barcode',title:'条形码',width:100},
                {field:'addusername',title:'创建人',width:100},
                {field:'addtime',title:'创建时间',width:120,
                    formatter:function(val,rowData,rowIndex){
                        if(val!=undefined){
                            return val.replace(/[tT]/," ");
                        }
                        return " ";
                    }
                },
                {field:'modifyusername',title:'修改人',width:100},
                {field:'modifytime',title:'修改时间',width:120,
                    formatter:function(val,rowData,rowIndex){
                        if(val!=undefined){
                            return val.replace(/[tT]/," ");
                        }
                        return " ";
                    }
                }
            ]]
        });

        $("#htgoldtax-table-linkJsTypeCodeGoodsList").datagrid({
            authority:linkJsTypeCodeGoodsListColJson,
            frozenColumns:linkJsTypeCodeGoodsListColJson.frozen,
            columns:linkJsTypeCodeGoodsListColJson.common,
            fit:true,
            method:'post',
            title:'',
            rownumbers:true,
            pagination:true,
            idField:'goodsid',
            sortName : 'jstypeid',
            sortOrder : 'asc',
            singleSelect:false,
            checkOnSelect:true,
            selectOnCheck:true,
            pageSize:30,
            pageList:[30,50,100,200],
            toolbar:'#htgoldtax-query-linkJsTypeCodeGoodsList',
            url:'basefiles/htgoldtax/getLinkJsTypeCodeGoodsPageListData.do',
        });

        //查询
        $("#htgoldtax-query-queryLinkJsTypeCodeGoodsList").click(function(){
            //把form表单的name序列化成JSON对象
            var queryJSON = $("#htgoldtax-form-linkJsTypeCodeGoodsList").serializeJSON();
            $("#htgoldtax-table-linkJsTypeCodeGoodsList").datagrid("load",queryJSON);
        });
        //重置
        $('#htgoldtax-query-reloadLinkJsTypeCodeGoodsList').click(function(){
            $("#htgoldtax-jsTaxTypeCodeList-query-jstypeid").widget('clear');

            $("#htgoldtax-linkJsTypeCodeGoodsList-query-goodsid").widget('clear');
            $("#htgoldtax-form-linkJsTypeCodeGoodsList")[0].reset();
            var queryJSON = $("#htgoldtax-form-linkJsTypeCodeGoodsList").serializeJSON();
            $("#htgoldtax-table-linkJsTypeCodeGoodsList").datagrid("load",queryJSON);
        });


        $("#htgoldtax-button-linkJsTypeCodeGoodsList").buttonWidget({
            //初始默认按钮 根据type对应按钮事件
            initButton:[
                {}
            ],
            buttons:[
                <security:authorize url="/basefiles/htgoldtax/jstaxtypecode/goodsLinkJsTypeCodeSelectAddBtn.do">
                {
                    id:'button-id-add',
                    name:'关联税收分类 ',
                    iconCls:'button-add',
                    handler:function(){
                        var dataRow=$("#htgoldtax-table-linkJsTypeCodeGoodsList").datagrid('getChecked');
                        if(dataRow==null || dataRow.length==0){
                            $.messager.alert("提醒","请选择相关商品!");
                            return false;
                        }
                        var goodsIdarr=[];
                        for(var i=0;i<dataRow.length;i++){
                            if(null!=dataRow[i].goodsid) {
                                goodsIdarr.push(dataRow[i].goodsid);
                            }
                        }
                        if(goodsIdarr.length==0){
                            $.messager.alert("提醒","请选择相关商品!");
                            return false;
                        }

                        $("#htgoldtax-dialog-link-jsTaxTypeCode").dialog({
                            title: '关联税收分类',
                            width: 450,
                            height: 300,
                            closed: true,
                            cache: false,
                            modal: true,
                            buttons:[
                                {
                                    text:'确定',
                                    iconCls:'button-ok',
                                    handler:function(){
                                        $("#htgoldtax-dialog-link-jsTaxTypeCode").dialog("close");
                                        var param={};
                                        var exportformflag = $("#htgoldtax-dialog-link-jsTaxTypeCode-form").form('validate');
                                        if (!exportformflag) {
                                            $.messager.alert("提醒", "抱歉，请填写相关参数");
                                            return false;
                                        }
                                        var exportformparm = $("#htgoldtax-dialog-link-jsTaxTypeCode-form").serializeJSON();
                                        exportformparm.oldFromData = "";
                                        delete exportformparm.oldFromData;
                                        param = jQuery.extend({}, exportformparm, param);
                                        param.goodsidarrs=goodsIdarr.join(",");

                                        $.messager.confirm("提醒","是否关联税收分类？",function(r){
                                            if(r){
                                                loading("关联中..");
                                                $.ajax({
                                                    url :'basefiles/htgoldtax/addLinkJsTypeCode.do',
                                                    type:'post',
                                                    dataType:'json',
                                                    data: param,
                                                    success:function(json){
                                                        loaded();
                                                        if(json.flag){
                                                            $.messager.alert("提醒","关联税收分类成功");
                                                            $("#htgoldtax-query-queryLinkJsTypeCodeGoodsList").trigger("click");
                                                        }else{
                                                            if(json.msg){
                                                                $.messager.alert("提醒","关联税收分类失败,"+json.msg);
                                                            }else{
                                                                $.messager.alert("提醒","关联税收分类失败!");
                                                            }
                                                        }
                                                    }
                                                });
                                            }
                                        });
                                    }
                                },
                                {
                                    text:'取消',
                                    iconCls:'button-cancel',
                                    handler:function(){
                                        $("#htgoldtax-dialog-link-jsTaxTypeCode").dialog("close");
                                        return false;
                                    }
                                }
                            ],
                            onClose:function(){
                                //$("#htgoldtax-dialog-link-jsTaxTypeCode").dialog("destroy");
                            }
                        });
                        $("#htgoldtax-dialog-link-jsTaxTypeCode").dialog("open");

                    }
                },
                </security:authorize>
                {}
            ],
            model:'bill',
            type:'list',
            datagrid:'htgoldtax-table-linkJsTypeCodeGoodsList',
            tname:'base_jstaxtypecode',
            id:''
        });

    });
    function resourceADMOperDialog(title, url){
        $('<div id="htgoldtax-dialogOper-linkJsTypeCodeGoodsList-content"></div>').appendTo("#htgoldtax-dialogOper-linkJsTypeCodeGoodsList");
        $('#htgoldtax-dialogOper-linkJsTypeCodeGoodsList-content').dialog({
            title: title,
            width: 350,
            height: 350,
            closed: true,
            cache: false,
            href: url,
            maximizable:true,
            resizable:true,
            modal: true,
            onLoad:function(){
            },
            onClose:function(){
                $('#htgoldtax-dialogOper-linkJsTypeCodeGoodsList-content').window("destroy");
            }
        });
        $('#htgoldtax-dialogOper-linkJsTypeCodeGoodsList-content').dialog('open');
    }
    var jsTaxTypeCode_getAjaxContent = function (param, url) { //同步ajax
        var ajax = $.ajax({
            type: 'post',
            cache: false,
            url: url,
            data: param,
            async: false
        });
        return ajax.responseText;
    }
</script>
</body>
</html>
