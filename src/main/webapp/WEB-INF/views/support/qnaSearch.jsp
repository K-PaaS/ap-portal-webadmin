<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%--
  =================================================================
  Created by IntelliJ IDEA.
  User: YJKim
  Date: 2016-08-10
  Time: 오전 11:29
  To change this template use File | Settings | File Templates.
  =================================================================
  Date: 2022.02.25
  Deprecated
  =================================================================
--%>

<div class="content-box2 col-md-12 col-md-offset-13">
<div class="form-group col-sm-4 mr-60" style="width: 39%; margin-left: -20px">
    <label class="control-label-white col-sm-3 mt13" style="text-align:right;">게시일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </label>
    <div class="col-sm-4" style="width: 300px">
        <input type='text' class="form-control" size="20"
               style="width: 130px; background:url(/resources/images/btn_cal.png) no-repeat right; background-color:#fafafa; border-radius: 5px 5px 5px 5px;"
               id='startDateInput-qna'/>
        &nbsp;&nbsp;&nbsp;
        ~
        &nbsp;&nbsp;
        <input type='text' class="form-control" size="20"
               style="width: 130px; background:url(/resources/images/btn_cal.png) no-repeat right; background-color:#fafafa; border-radius: 5px 5px 5px 5px;"
               id='endDateInput-qna'/>
    </div>
</div>


<div class="form-group col-sm-2 mr-25" style="width: 20%;padding-left:20px">
    <label for="searchTypeColumn-qna" class="control-label-white col-sm-6 mt13 ml-10" style="text-align:right;">검색항목&nbsp;</label>
    <div class="col-sm-6">
        <select id="searchTypeColumn-qna" name="searchTypeColumn-qna" class="form-control" style="background:url(/resources/images/btn_down.png) no-repeat right; background-color:#fafafa;">
            <option value="<%= Constants.SEARCH_TYPE_ALL %>">전체</option>
            <option value="<%= Constants.SEARCH_TYPE_CLASSIFICATION %>">분류</option>
            <option value="<%= Constants.SEARCH_TYPE_TITLE %>">제목</option>
            <option value="<%= Constants.SEARCH_TYPE_USERID %>">작성자</option>
        </select>
    </div>
</div>

<div class="form-group col-sm-2 mr-25" style="width: 19%;padding-left:0px">
    <label for="searchTypeStatus" class="control-label-white col-sm-6 mt13 ml-10"
           style="text-align:right;">답변여부&nbsp;</label>
    <div class="col-sm-6">
        <select id="searchTypeStatus" name="searchTypeStatus" class="form-control" style="background:url(/resources/images/btn_down.png) no-repeat right; background-color:#fafafa;">
            <option value="<%= Constants.SEARCH_TYPE_ALL %>">전체</option>
            <option value="<%= Constants.STATUS_ANSWERED %>">답변완료</option>
            <option value="<%= Constants.STATUS_WAITING %>">미답변</option>
        </select>
    </div>
</div>

<div class="form-group col-sm-4" style="width: 29%;padding-left:0px">
    <label for="searchKeyword-qna" class="control-label-white col-sm-3 mt13 ml-10" style="text-align:right;width:28%">검색어&nbsp;&nbsp;</label>
    <div class="input-group col-sm-8 ml20">
        <input type="text" maxlength="100" id="searchKeyword-qna" class="form-control2 ml10" placeholder="검색어를 입력하세요." style="width: 97%; background-color: rgb(255, 255, 255);"  onkeypress="procCheckSearchFormKeyEventQnA(event);">
        <div class="input-group-btn">
            <button type="button" id="btnSearch-qna" class="btn" style="margin: 11px 0 0 0; color: #c4c3c3; background-color: #f7f7f9; height: 30px;">
                <span class="glyphicon glyphicon-search" style="top: -1px; left: 4px;"></span>
            </button>
        </div>

    </div>
</div>

</div>

<%-- datetimepicker library --%>
<link href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.37/css/bootstrap-datetimepicker.css" rel="stylesheet"/>
<script src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.13.0/moment.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.37/js/bootstrap-datetimepicker.min.js"></script>



<script type="text/javascript">

    $(document).ready(function(){

        /* 오늘 ~ 30일 뒤 */
//        var now = new Date();
//        var today = now.getFullYear() + "/" + (now.getMonth()+1) + "/" + now.getDate();
//        now.setDate(now.getDate()+30);
//        var next30day = now.getFullYear() + "/" + (now.getMonth()+1) + "/" + now.getDate();

//        $("#startDateInput-qna").val(today.toString());
//        $("#endDateInput-qna").val(next30day.toString());

        /* 30일 전 ~ 오늘 */
        var now = new Date();
        var today = now.getFullYear() + "/" + (now.getMonth()+1) + "/" + now.getDate();
        now.setDate(now.getDate()-30);
        var prev30day = now.getFullYear() + "/" + (now.getMonth()+1) + "/" + now.getDate();

        $("#startDateInput-qna").val(prev30day.toString());
        $("#endDateInput-qna").val(today.toString());



    });

    /******************************************************************************************************** search */

    // CHECK SEARCH FORM KEY EVENT
    var procCheckSearchFormKeyEventQnA = function(e) {
        if (event.keyCode == 13 && event.srcElement.type != 'textarea') {

            procGetSearchQnAList();
        }
    };

    // GET SEARCH LIST
    var procGetSearchQnAList = function() {
        var reqSearchTypeColumn = $('#searchTypeColumn-qna').val();
        var reqSearchStatus = $("#searchTypeStatus").val();
        var reqSearchKeyword = $('#searchKeyword-qna').val();
        var reqSearchStartDate = $('#startDateInput-qna').val();
        var reqSearchEndDate = $('#endDateInput-qna').val();

        var param = {
            searchKeyword : reqSearchKeyword,
            searchTypeColumn : reqSearchTypeColumn,
            searchTypeStatus : reqSearchStatus,
            searchStartDate : reqSearchStartDate,
            searchEndDate : reqSearchEndDate
        };


        getQnAList(param);

        procSelectTab("<%= Constants.TAB_NAME_QNA %>");



    };

    // BIND :: BUTTON EVENT
    $("#btnSearch-qna").on("click", function() {
        // TEST
        procGetSearchQnAList();
    });

    // calendar, tooltip
    $(function () {
        // Calendar setting
        $('#startDateInput-qna').datetimepicker({
            format: 'YYYY/MM/DD'

        });
        $('#endDateInput-qna').datetimepicker({
            format: 'YYYY/MM/DD',
            useCurrent: false //Important! See issue #1075

        });
        $("#startDateInput-qna").on("dp.change", function (e) {
            $('#endDateInput-qna').data("DateTimePicker").minDate(e.date);
        });
        $("#endDateInput-qna").on("dp.change", function (e) {
            $('#startDateInput-qna').data("DateTimePicker").maxDate(e.date);
        });



    });


</script>
