$(function () {
    var $question = $('#div_question');
    var link = $question.find('>a');
    if(link.text() == 'Unsubscibe')
    {
        var url = '/notifications/' + $question.data('question-id');
        var method = 'delete';
        var data = {};
        var new_text = 'Subscribe'
    }
    else{
        var url = '/notifications/';
        var method = 'post';
        var data = {
            question_id: $question.data('question-id')
        };
        var new_text = 'Unsubscribe'
    }

    link.click(function(){
        $.ajax(
            {
                url: url,
                method: method,
                data: data,
                success: function () {
                    link.text(new_text)
                },
                error: function() {
                    alert('Something went wrong!')
                }
            }
        )
    })
});
