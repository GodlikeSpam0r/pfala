$(document).ready(function(){
    $('.date').datepicker({
        weekStart: 1,
        todayBtn: "linked",
        todayHighlight: true,
        dateFormat: 'yy-mm-dd',
        showButtonPanel: true
    });

    $('select[name="user"]').selectpicker();
});