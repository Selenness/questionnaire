$(function () {
    $('[data-answer-id]').each(function(i, answer_span)
    {
        var answer_span = $(answer_span);
        var question_id = answer_span.data('question-id');
        var answer_id = answer_span.data('answer-id');

        var $radio = answer_span.find('#best_answer_id_' + answer_id);

        $radio.change(function(e)
        {
            $.ajax({
                url: '/questions/' + question_id,
                method: 'patch',
                data: {
                    question: {
                        best_answer_id: answer_id
                    }
                },
                success: function(message){
                    $('.notice').html(message);
                    console.log(message);
                },
                error: function(){
                    $('.error').html('We are sorry, but something went wrong!');
                }
            });
        });

        var $delete = answer_span.find('[data-method="delete"]');
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
    });
});
