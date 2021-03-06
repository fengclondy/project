<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://www.springframework.org/security/tags"
          prefix="security" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>发货配送单</title>
    <%@include file="/include.jsp" %>
    <%@include file="/printInclude.jsp" %>
</head>
<body>
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'north',border:false">
        <div class="buttonBG" id="storage-buttons-DeliveryOutListPage"></div>
    </div>
    <div data-options="region:'center'">
        <table id="storage-table-DeliveryOutListPage"></table>
        <div id="storage-table-query-DeliveryOutListPage"
             style="padding: 2px; height: auto">
            <div>
                <form action="" id="storage-form-DeliveryOutListPage" method="post">
                    <table class="querytable">
                        <input type="hidden" name="entertype" value="${billtype}">
                        <tr>
                            <td>业务日期:</td>
                            <td class="tdinput">
                                <input type="text" id="storage-DeliveryOutListPage-businessdatestart"
                                       name="businessdatestart" style="width:100px;" class="Wdate"
                                       onfocus="WdatePicker({'dateFmt':'yyyy-MM-dd'})"/>
                                到 <input type="text" id="storage-DeliveryOutListPage-businessdateend" name="businessdateend"
                                         class="Wdate" style="width:100px;" onfocus="WdatePicker({'dateFmt':'yyyy-MM-dd'})"/>
                            </td>
                            <td>编号:</td>
                            <td class="tdinput">
                                <input type="text" id="storage-DeliveryOutListPage-id" name="id" style="width:150px;"/>
                            </td>
                            <td>单据状态:</td>
                            <td>
                                <select id="storage-DeliveryOutListPage-billtype" name="status" style="width:130px;">
                                    <option></option>
                                    <option value="2" selected="selected">保存</option>
                                    <option value="3">审核通过</option>
                                    <option value="4">关闭</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <c:if test="${billtype==1 }">
                            <td>供应商:</td>
                            <td><input id="storage-DeliveryOutListPage-supplier" type="text" name="supplierid"
                                       style="width: 225px;"/></td>
                            </c:if>
                            <c:if test="${billtype==2 }">
                            <td>客户:</td>
                            <td><input id="storage-DeliveryOutListPage-customer" type="text" name="customerid"
                                       style="width: 225px;"/></td>
                            </c:if>
                            <td>仓库编号:</td>
                            <td><input id="storage-DeliveryOutListPage-storageid" type="text" name="storageid"
                                       style="width: 225px;"/></td>
                            <!-- <td>来源类型:</td>
                                <td >
                                    <select id="storage-DeliveryOutListPage-sourcetype" name="sourcetype" style="width:165px;">
                                        <option></option>
                                        <option value="0">无来源</option>
                                        <option value="1">到货订单</option>
                                        <option value="2">客户退货</option>
                                    </select>
                                </td>
                            </tr> -->
                            <td>打印状态</td>
                            <td>
                                <select id="storage-DeliveryOutListPage-printstatus" name="printstatus"
                                        style="width:130px;">
                                    <option></option>
                                    <option value="0">未打印</option>
                                    <option value="1">已打印</option>
                                </select>
                            </td>
                        <tr>
                            <td>来源单据编号:</td>
                            <td class="tdinput">
                                <input type="text" id="storage-DeliveryOutListPage-sourceid" name="sourceid"
                                       style="width:225px;"/></td>
                            <td>客户单号:</td>
                            <td class="tdinput">
                                <input type="text" id="storage-DeliveryOutListPage-customerbill" name="customerbill"
                                       style="width:150px;"/></td>
                            <td colspan="2">
                                <a href="javaScript:void(0);" id="storage-btn-queryDeliveryOutListPage"
                                   class="button-qr">查询</a>
                                <a href="javaScript:void(0);" id="storage-btn-reloadDeliveryOutListPage"
                                   class="button-qr">重置</a>
                                <span id="storage-table-query-DeliveryOutListPage-advanced"></span>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        var initQueryJSON = $("#storage-form-DeliveryOutListPage").serializeJSON();
        var DeliveryOutListJson = $("#storage-table-DeliveryOutListPage").createGridColumnLoad({
            frozenCol: [[
                {field: 'idok', checkbox: true, isShow: true}
            ]],
            commonCol: [[
                {field: 'id', title: '编号', width: 120},
                {field: 'sourceid', title: '来源单据编号', width: 120, hidden: true},
                {field: 'businessdate', title: '业务日期', width: 70, sortable: true},
                <c:if test="${billtype==1 }">
                {field: 'supplierid', title: '供应商编号', width: 80},
                {field: 'suppliername', title: '供应商名称', width: 140},
                </c:if>
                <c:if test="${billtype==2 }">
                {field: 'customerid', title: '客户编号', width: 80},
                {field: 'customername', title: '客户名称', width: 140},
                </c:if>
                {field: 'storagename', title: '仓库名称', width: 60},
                {field: 'customerbill', title: '客户单号', width: 120},
                {
                    field: 'totalvolume', title: '总体积(M*3)', width: 80,
                    formatter: function (value, row, index) {
                        return formatterMoney(value);
                    }
                },
                {
                    field: 'totalweight', title: '总重量(KG)', width: 80,
                    formatter: function (value, row, index) {
                        return formatterMoney(value);
                    }
                },
                {
                    field: 'totalbox', title: '总箱数', width: 80,
                    formatter: function (value, row, index) {
                        return formatterMoney(value);
                    }
                },
                {
                    field: 'billtype', title: '单据类型', width: 120, hidden: true,
                    formatter: function (value, row, index) {
                        if (value == '1') {
                            return "供应商配送退货出库单";
                        } else if (value == "2") {
                            return "客户配送出库单";
                        } else
                            return "";
                    }
                },
                {
                    field: 'status', title: '状态', width: 70,
                    formatter: function (value, row, index) {
                        if (value == '0') {
                            return "新增";
                        } else if (value == "1") {
                            return "暂存";
                        } else if (value == "2") {
                            return "保存";
                        } else if (value == "3") {
                            return "审核通过";
                        } else if (value == "4") {
                            return "关闭";
                        } else if (value == "5") {
                            return "中止";
                        } else {
                            return "";
                        }
                    }
                },
                {
                    field: 'sourcetype', title: '来源类型', width: 120,
                    formatter: function (value, row, index) {
                        if (value == '0') {
                            return "无来源";
                        } else if (value == "1") {
                            return "代配送采购退单";
                        } else if (value == "2") {
                            return "代配送销售订单";
                        } else {
                            return "";
                        }
                    }
                },
                {
                    field: 'ischeck', title: '是否验收', width: 80,
                    formatter: function (value, row, index) {
                        if (value == '0') {
                            return "否";
                        } else if (value == "1") {
                            return "是";
                        } else {
                            return "";
                        }
                    }
                },
                {field: 'addusername', title: '制单人', width: 70},
                {field: 'addtime', title: '制单时间', width: 140},
                {
                    field: 'printstate', title: '打印状态', width: 80, isShow: true,
                    formatter: function (value, rowData, index) {
                        if (rowData.printtimes > 0) {
                            return "已打印";
                        } else if (rowData.printtimes == null) {
                            return "";
                        } else {
                            return "未打印";
                        }
                    }
                },
                {field: 'printtimes', title: '打印次数', width: 80},
                {field: 'remark', title: '备注', width: 100},
                {
                    field: 'isdelivery', title: '配货状态', width: 120,
                    formatter: function (value, row, index) {
                        if (value == '0') {
                            return "未配货";
                        } else if (value == "1") {
                            return "配货中";
                        } else if (value == "2") {
                            return "已配货";
                        } else if (value == "3") {
                            return "配货完毕";
                        }
                    }
                },
                /* 	{field:'adduserid',title:'制单人编号',width:120,hidden:true},
                 {field:'adddeptid',title:'制单人部门编号',width:70,hidden:true},
                 {field:'adddeptname',title:'制单人部门名称',width:100,hidden:true},
                 {field:'modifyuserid',title:'最后修改人编号',width:70,hidden:true},
                 {field:'modifyusername',title:'最后修改人名称',width:120,hidden:true},
                 {field:'modifytime',title:'最后修改时间',width:120,hidden:true},
                 {field:'audituserid',title:'审核人编号',width:120,hidden:true,hidden:true}, */
                {field: 'auditusername', title: '审核人名称', width: 120, hidden: true},
                {field: 'audittime', title: '审核时间', width: 120, hidden: true},
                /* {field:'stopuserid',title:'中止人编号',width:120,hidden:true},
                 {field:'stopusername',title:'中止人名称',width:120,hidden:true},
                 {field:'stoptime',title:'中止时间',width:120,hidden:true}, */
                <c:if test="${billtype==2}">
                {field: 'closetime', title: '关闭时间', width: 120, hidden: true},
                </c:if>
                <c:if test="${billtype==2}">
                {field: 'pcustomername', title: '总店客户', width: 120, hidden: true},
                </c:if>
                /* {field:'customersort',title:'客户分类',width:120,hidden:true},
                 {field:'deptid',title:'所属部门',width:120,hidden:true},
                 {field:'storageid',title:'仓库编号',width:120,hidden:true}, */
                {
                    field: 'totalamount', title: '总金额', width: 120, hidden: true,
                    formatter: function (value, row, index) {
                        return formatterMoney(value);
                    }
                }
                /* {field:'checkuserid',title:'验收人编号',width:120,hidden:true}, */
                <c:if test="${billtype==2}">
                ,
                {field: 'checkname', title: '验收人名称', width: 120, hidden: true},
                {field: 'checktime', title: '验收时间', width: 120, hidden: true}
                </c:if>
            ]]
        });

        $("#storage-table-DeliveryOutListPage").datagrid({
            fit: true,
            method: 'post',
            rownumbers: true,
            pagination: true,
            idField: 'id',
            singleSelect: false,
            checkOnSelect: true,
            selectOnCheck: true,
            showFooter: true,
            toolbar: '#storage-table-query-DeliveryOutListPage',
            url: "storage/deliveryout/deliveryOutListPage.do?billtype=${billtype}",
            queryParams: initQueryJSON,
            pageSize: 100,
            authority: DeliveryOutListJson,
            frozenColumns: DeliveryOutListJson.frozen,
            columns: DeliveryOutListJson.common,
            onDblClickRow: function (rowIndex, rowData) {
                var str = "";
                <c:if test="${billtype==1}">
                str = "供应商退货出库修改";
                </c:if>
                <c:if test="${billtype==2}">
                str = "客户配送出库修改";
                </c:if>
                top.addTab('storage/deliveryout/showDeliveryOutPage.do?billtype=${billtype}&type=edit&id=' + rowData.id, str);
            }
        });

        $("#storage-buttons-DeliveryOutListPage").buttonWidget({
            initButton: [
                {},
                <security:authorize url="/storage/deliveryout/showDeliveryOutAddPage.do">
                {
                    type: 'button-add',
                    handler: function () {
                        var str = "";
                        <c:if test="${billtype==1}">
                        str = "供应商退货出库新增";
                        </c:if>
                        <c:if test="${billtype==2}">
                        str = "客户配送出库新增";
                        </c:if>
                        top.addOrUpdateTab('storage/deliveryout/showDeliveryOutPage.do?billtype=${billtype}', str);
                    }
                },
                </security:authorize>
                <security:authorize url="/storage/deliveryout/editDeliveryOutPage.do">
                {
                    type: 'button-edit',
                    handler: function () {
                        var row = $("#storage-table-DeliveryOutListPage").datagrid('getSelected');
                        if (row == null) {
                            $.messager.alert("提醒", "请选择一条记录");
                            return false;
                        }
                        var str = "";
                        <c:if test="${billtype==1}">
                        str = "供应商退货出库修改";
                        </c:if>
                        <c:if test="${billtype==2}">
                        str = "客户配送出库修改";
                        </c:if>
                        top.addTab('storage/deliveryout/showDeliveryOutPage.do?billtype=${billtype}&type=edit&id=' + row.id, str);
                    }
                },
                </security:authorize>
                {
                    type: 'button-view',
                    handler: function () {
                        var row = $("#storage-table-DeliveryOutListPage").datagrid('getSelected');
                        if (row == null) {
                            $.messager.alert("提醒", "请选择一条记录");
                            return false;
                        }
                        var str = "";
                        <c:if test="${billtype==1}">
                        str = "供应商退货出库查看";
                        </c:if>
                        <c:if test="${billtype==2}">
                        str = "客户配送出库查看";
                        </c:if>
                        top.addTab('storage/deliveryout/showDeliveryOutPage.do?billtype=${billtype}&type=view&id=' + row.id, str);
                    }
                },
                <security:authorize url="/storage/deliveryout/batchdeleteOut.do">
                {
                    type: 'button-audit',
                    handler: function () {
                        var rows = $("#storage-table-DeliveryOutListPage").datagrid('getChecked');
                        if (rows.length == 0) {
                            $.messager.alert("提醒", "请至少勾选一条记录");
                            return false;
                        }
                        var ids = "";
                        for (var i = 0; i < rows.length; i++) {
                            if (ids == "") {
                                ids = rows[i].id;
                            } else {
                                ids += "," + rows[i].id;
                            }
                        }
                        $.messager.confirm("提醒", "是否确定审核选中的出库单?", function (r) {
                            if (r) {
                                loading("审核中..");
                                $.ajax({
                                    url: 'storage/deliveryout/audits.do?ids=' + ids,
                                    type: 'post',
                                    dataType: 'json',
                                    success: function (json) {
                                        loaded();
                                        if (json.flag) {
                                            $.messager.alert("提醒",json.msg);
                                            $("#storage-table-DeliveryOutListPage").datagrid('reload');
                                        } else {
                                            $.messager.alert("提醒", "审核失败");
                                        }
                                    },
                                    error: function () {
                                        loaded();
                                        $.messager.alert("错误", "审核出错");
                                    }
                                });
                            }
                        });
                    }
                },
                </security:authorize>
                <security:authorize url="/storage/deliveryout/batchdeleteOut.do">
                {
                    type: 'button-delete',
                    handler: function () {
                        var rows = $("#storage-table-DeliveryOutListPage").datagrid('getChecked');
                        if (rows.length == 0) {
                            $.messager.alert("提醒", "请至少勾选一条记录");
                            return false;
                        }
                        $.messager.confirm("提醒", "是否确定删除选中的出库单?", function (r) {
                            if (r) {
                                var ids = "";
                                for (var i = 0; i < rows.length; i++) {
                                    if (rows[i].status != '1' && rows[i].status != '2') {
                                        $.messager.alert("提醒", "抱歉，有入库单已审核,无法删除")
                                        return false;
                                    }
                                    if (ids == "") {
                                        ids = rows[i].id;
                                    } else {
                                        ids += "," + rows[i].id;

                                    }
                                }
                                loading("删除中..");
                                $.ajax({
                                    url: 'storage/deliveryout/batchdeleteOut.do?ids=' + ids,
                                    type: 'post',
                                    dataType: 'json',
                                    success: function (json) {
                                        loaded();
                                        if (json.flag) {
                                            $.messager.alert("提醒", "删除成功");
                                            $("#storage-table-DeliveryOutListPage").datagrid('reload');
                                        } else {
                                            $.messager.alert("提醒", "删除失败");
                                        }
                                    },
                                    error: function () {
                                        loaded();
                                        $.messager.alert("错误", "删除出错");
                                    }
                                });
                            }
                        });
                    }
                },
                </security:authorize>
                <security:authorize url="/print/delivery/deliveryorderPrintView.do">
                {
                    type: 'button-preview',
                    handler: function () {
                    }
                },
                </security:authorize>
                <security:authorize url="/print/delivery/deliveryorderPrint.do">
                {
                    type: 'button-print',
                    handler: function () {
                    }
                },
                </security:authorize>
                {}
            ],
            <c:if test="${billtype==2 }">
            buttons: [
                {},
                <security:authorize url="/storage/deliveryout/check.do">
                {
                    id: 'button-returnorder-check',
                    name: '批量验收',
                    iconCls: 'button-audit',
                    handler: function () {
                        var rows = $("#storage-table-DeliveryOutListPage").datagrid('getChecked');
                        if (rows.length == 0) {
                            $.messager.alert("提醒", "请选中需要验收的记录。");
                            return false;
                        }
                        for (var i = 0; i < rows.length; i++) {
                            var status = rows[i].status;
                            if (status != '3') {
                                $.messager.alert("提醒", "有单据未审核,不能验收");
                                return false;
                            }
                        }
                        $.messager.confirm("提醒", "确定验收这些配送出库单？", function (r) {
                            if (r) {
                                var failids = new Array();
                                var idarrs = new Array();
                                for (var i = 0; i < rows.length; i++) {
                                    if (rows[i].ischeck != '1') {
                                        idarrs.push(rows[i].id);
                                    } else {
                                        failids.push(rows[i].id);
                                    }
                                }
                                if (failids.length > 0) {
                                    $.messager.alert("提醒", "请选中需要验收的记录。以下为已验收编号：" + failids.join(","));
                                    return false;
                                }
                                loading("验收操作中..");
                                $.ajax({
                                    url: 'storage/deliveryout/batchcheck.do',
                                    dataType: 'json',
                                    type: 'post',
                                    data: {idarrs: idarrs.join(",")},
                                    success: function (json) {
                                        loaded();
                                        if (json.flag == true) {
                                            if (json.msg) {
                                                $.messager.alert("提醒", "验收操作成功，" + json.msg);
                                            } else {
                                                $.messager.alert("提醒", "验收操作成功");
                                            }
                                            $("#storage-table-DeliveryOutListPage").datagrid('reload');
                                        }
                                        else {
                                            if (json.msg) {
                                                $.messager.alert("提醒", "验收操作失败，" + json.msg);
                                            } else {
                                                $.messager.alert("提醒", "验收操作出错");
                                            }
                                        }
                                    },
                                    error: function () {
                                        loaded();
                                        $.messager.alert("错误", "验收操作出错");
                                    }
                                });
                            }
                        });
                    }
                },
                </security:authorize>
                {},

            ],
            </c:if>
            model: 'bill',
            type: 'list',
            datagrid: 'storage-table-DeliveryOutListPage',
            tname: 't_storage_delivery_out'
        });

        <c:if test="${billtype==1 }">
        //供应商
        $("#storage-DeliveryOutListPage-supplier").supplierWidget({
            name: 't_purchase_buyorder',
            col: 'supplierid',
            singleSelect: true,
            onlyLeafCheck: true,
            onSelect: function (data) {
            }
        });
        </c:if>

        <c:if test="${billtype==2 }">
        //客户参照窗口
        $("#storage-DeliveryOutListPage-customer").customerWidget({
            name: 't_storage_delivery_enter',
            col: 'customerid',
            singleSelect: true,
            isdatasql: false,
            onlyLeafCheck: false
        });
        </c:if>
        //仓库
        $("#storage-DeliveryOutListPage-storageid").widget({
            width: 150,
            referwid: 'RL_T_BASE_STORAGE_INFO',
            singleSelect: true,
            onlyLeafCheck: false
        });

        //回车事件
        controlQueryAndResetByKey("storage-btn-queryDeliveryOutListPage", "storage-btn-reloadDeliveryOutListPage");
        //查询
        $("#storage-btn-queryDeliveryOutListPage").click(function () {
            $("#storage-table-DeliveryOutListPage").datagrid('clearChecked');
            $("#storage-table-DeliveryOutListPage").datagrid('clearSelections');
            var queryJSON = $("#storage-form-DeliveryOutListPage").serializeJSON();
            $('#storage-table-DeliveryOutListPage').datagrid('load', queryJSON);
        });
        //重置
        $("#storage-btn-reloadDeliveryOutListPage").click(function () {
            $("#storage-DeliveryOutListPage-storageid").widget('clear');
            $("#storage-DeliveryOutListPage-supplier").supplierWidget('clear');
            $("#storage-DeliveryOutListPage-customer").customerWidget('clear');
            $("#storage-form-DeliveryOutListPage")[0].reset();
            var queryJSON = $("#storage-form-DeliveryOutListPage").serializeJSON();
            $("#storage-table-DeliveryOutListPage").datagrid('clearChecked');
            $("#storage-table-DeliveryOutListPage").datagrid('clearSelections');
            $('#storage-table-DeliveryOutListPage').datagrid('load', queryJSON);
        });
    })
</script>
<%--打印开始 --%>
<script type="text/javascript">
    $(function () {
        //打印
        AgReportPrint.init({
            id: "listPage-deliveryout-dialog-print",
            code: "storage_delivery_enter",
            tableId: "storage-table-DeliveryOutListPage",
            url_preview: "print/delivery/deliveryEnterPrintView.do",
            url_print: "print/delivery/deliveryorderPrint.do",
            btnPreview: "button-preview",
            btnPrint: "button-print",
            getData: function (tableId, printParam) {
                var data = $("#" + tableId).datagrid("getChecked");
                if (data == null || data.length == 0) {
                    $.messager.alert("提醒", "请选择至少一条记录");
                    return false;
                }
                printParam.billtype = '${billtype}';
                printParam.isenter = 'false';
                return data;
            }
        });
    });
</script>
<%--打印结束 --%>
</body>
</html>