var $modal;
var $element;
var date;
var $blockTable = $('.block-table');

$(document).ready(function () {
    positionBlocks();
    var $td = $('.block-table > tr > td');
    $td.mousedown(function () {
        down($(this));
    });

    $td.mouseup(function () {
        up($(this));
    });

    $modal = $('#addBlockModal');

    $('#saveBlockButton').click(function () {
        saveBlock();
    });
});

function down(element) {
    $element = element;
    $('select[name="start"]').selectpicker('val', getStartTime(element));
    $('select[name="duration"]').selectpicker('val', '01:00');
    date = getDate(element);
    $modal.modal('show');
}

function up(element) {
}

function resized(event, ui) {
    var element = ui.element;
    element.draggable({
        grid: [element.outerWidth(), 18]
    });
    var h = $(element).height();
    var cellH = $('#cell-0-0').outerHeight();
    var count = 0;

    while (h > cellH) {
        h -= cellH;
        count++;
    }

    var options = {
        'duration': count
    };

    updateBlock(element, options);
}

function positionBlocks() {
    var blocks = $('.block');

    for (var i = 0, l = blocks.length; i < l; i++) {
        positionBlock(blocks[i]);
    }
}

function positionBlock(block) {
    var cell = $('#cell-' + block.dataset.date + '-0');

    var durH = parseInt(block.dataset.duration.split(':')[0]);
    var durHalf = block.dataset.duration.split(':')[1] == '30' ? 0.5 : 0;
    var height = (cell.outerHeight()) * (durH + durHalf) - 2;

    var startH = parseInt(block.dataset.start.split(':')[0]);
    var startHalf = block.dataset.start.split(':')[1] == '30' ? 0.5 : 0;

    var top = $($('.picasso-head-cell')[1]).outerHeight() + cell.outerHeight() * (startH - 5 + startHalf);
    var left = (cell.outerWidth()) * block.dataset.date;

    $(block).css({
        'top': top,
        'left': left,
        'height': height
    });

    /*$(block).resizable({
     grid: getGrid($(block)),
     containment: $blockTable,
     maxWidth: width,
     stop: function(event, ui){resized(event, ui);}
     });*/
    $(block).draggable({
        grid: [$(cell).outerWidth(), 18],
        scroll: true,
        containment: '.block-table',
        stop: function (event, ui) {
            dragged(event, ui);
        }
    });
}

function dragged(event, ui) {
    var element = ui.helper;
    var start = getStartTime(element);
    var date = getDate(element);
    var options = {
        'start': start,
        'date': date
    };
    updateBlock(element[0], options);
}

function getParent(element) {
    var pos = element.offset();
    var xpos = pos.left + element.width() / 2;
    var ypos = pos.top + element.height() / 2;
    var parent = $.touching({x: xpos, y: ypos}, 'td');
    return $(parent);
}

function getGrid(element) {
    return [element.outerWidth(), 18];
}

function getStartTime(block) {
    var $parent = getParent(block);

    var pPos = $parent.offset();
    var pos = block.offset();

    var half = pos.top > pPos.top ? ':30' : ':00';

    var id = $parent[0].id;
    var num = parseInt(id.split('-')[2]) + 5;
    return (num > 9 ? num : '0' + num) + half;
}

function getDate(block) {
    var $parent = getParent(block);
    var id = $parent[0].id;
    return parseInt(id.split('-')[1]);
}

function saveBlock() {
    var name = $('input[name="name"]').val();
    var start = $('select[name="start"]').val();
    var duration = $('select[name="duration"]').val();
    var blockType = $('select[name="block-type"]').val();

    $.ajax({
        url: '/camp/' + window.campID + '/picasso/block/add',
        type: 'post',
        data: {
            name: name,
            start: start,
            duration: duration,
            blockType: blockType,
            date: date
        }
    }).done(function (response) {
        console.log(response);
        var $new = $('<div class="resizable block small-text" style="background-color:' + response.color + '" data-date="' + date + '" data-start="' + start + '" data-duration="' + duration + '" data-id="' + response.id + '">' + name + '</div>');
        $('.picasso-div').append($new);
        positionBlock($new[0]);
    });
}

function updateBlock(block, options) {
    block = $(block);

    var id = block.data("id");

    var start = options.start || block.data("start");
    var duration = options.duration || block.data("duration");
    var date = ((options.date + 1) || (block.data("date") + 1)) - 1;

    var name = options.name || block.text();
    var blockType = options.blockType || undefined;

    block.attr("data-start", start);
    block.attr("data-duration", duration);
    block.attr("data-date", date);
    block.text(name);

    $.ajax({
        url: '/camp/' + window.campID + '/picasso/block/' + id + '/update',
        type: 'post',
        data: {
            name: name,
            start: start,
            duration: duration,
            blockType: blockType,
            date: date
        }
    }).done(function (response) {
        positionBlock(block.get(0));
    });
}