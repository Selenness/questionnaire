$(function () {

    $('[data-answer-id]').each(function(i, answer_span)
    {
        var $answer_span = $(answer_span);
        var answer_id = $answer_span.data('answer-id');
        var $radio = $answer_span.find('#best_' + answer_id);

        App.cable.subscriptions.create({ channel: 'CommentsChannel', commentable_type: 'Answer', commentable_id: answer_id }, {
            connected: function(){
                console.log('Answer comments channel connected!');
            },
            received: function(data){
                $answer_span.find('.answer_comments').append(data)
            }
        });

        $radio.change(function(e)
        {
            $.ajax({
                url: '/answers/' + answer_id + '/set_best/',
                method: 'patch',
                data: {
                    answer: {
                        best: true
                    }
                },
                success: function(message){
                    $('.notice').html(message);
                },
                error: function(){
                    $('.error').html('We are sorry, but something went wrong!');
                }
            });
        });

        var $delete = $answer_span.find('> a:contains("Delete")');
        $delete.click(function(e){
            e.preventDefault();
            $.ajax({
                url: $delete.attr('href'),
                method: 'delete',
                success: function(){
                    $answer_span.remove();
                },
                error: function(){
                    $('.error').html('We are sorry, but something went wrong!');
                }
            });
        });

        var $edit = $answer_span.find('a:contains("Edit")');
        $edit.click(function(e){
            e.preventDefault();
            $answer_span.hide();
            $('#answer_form' + answer_id).show();
            return false;
        });

        var $attachments = $answer_span.find('ul > li');
        $attachments.each(function(i, li){
            var $del = $(li).find('a:contains("Delete")');
            $del.click(delete_attachment);
        });
    });
});
