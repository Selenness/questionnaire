
function make_votable(voting_buttons_div){
    var voting_button = voting_buttons_div;
    var like =  voting_button.find('a:contains("Like")');
    var reset = voting_button.find('a:contains("Reset")');
    var dislike = voting_button.find('a:contains("Dislike")');
    var votable_id = voting_button.data('votable-id');
    var votable_type = voting_button.data('votable-type');
    var votable_rate = $('#' + votable_type + '-' + votable_id + '-rate');

    function send_vote(pro) {
        like.hide();
        dislike.hide();
        $.ajax({
            url: '/user_votes/',
            method: 'post',
            data: {
                user_vote: {
                    votable_id: votable_id,
                    votable_type: votable_type,
                    pro: pro
                }
            },
            success: function(rate){
                reset.show();
                votable_rate.html(rate);
            }
        })
    }

    like.click(function(e){
        e.preventDefault();
        send_vote(true);
    });

    dislike.click(function (e)
    {
        e.preventDefault();
        send_vote(false);
    });

    reset.click(function(e){
        e.preventDefault();
        reset.hide();
        $.ajax({
            url: reset.attr('href'),
            method: 'delete',
            success: function(rate){
                like.show();
                dislike.show();
                votable_rate.html(rate);
            }
        });
    });
}
$(document).ready(function(){
    $('.voting_button').each(function (i, voting_buttons_div) {
        make_votable($(voting_buttons_div));
    });
});
