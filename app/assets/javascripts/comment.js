$(function(){
    $('.new_comment').each(function(){
        var $comment_form = $(this);
        var $comment_content = $comment_form.find('textarea');
        var $submit_button = $comment_form.find('input[type="submit"]');

        var contentHandler = function () {
            if($comment_content.val().length > 0)
            {
                $submit_button.removeAttr('disabled');
            }
            else
            {
                $submit_button.attr('disabled', 'disabled');
            }
        };

        $comment_content.keypress(function(){
            contentHandler();
        }).change(function () {
            contentHandler();
        });
    })
});