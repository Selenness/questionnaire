$(function () {

    $('[data-answer-id]').each(function(i, answer_span)
    {
        var answer_span = $(answer_span);
        var answer_id = answer_span.data('answer-id');
        var $radio = answer_span.find('#best_' + answer_id);

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

        var $delete = answer_span.find('a:contains("Delete")');
        $delete.click(function(e){
            e.preventDefault();
            $.ajax({
                url: $delete.attr('href'),
                method: 'delete',
                success: function(){
                    answer_span.remove();
                },
                error: function(){
                    $('.error').html('We are sorry, but something went wrong!');
                }
            });
        });

        var $edit = answer_span.find('a:contains("Edit")');
        $edit.click(function(e){
            e.preventDefault();
            answer_span.hide();
            $('#answer_form' + answer_id).show();
            return false;
        });

    });
});
