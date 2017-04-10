$(function () {
    $('.question').find('li').each(function(i, li){
        var $del = $(li).find('a:contains("Delete")');
        $del.click(delete_attachment);
    });
});