function delete_attachment(e){
    e.preventDefault();
    var $del = $(this);
    var attachment_id = $del.data('attachment-id');
    $.ajax({
        url: '/attachments/' + attachment_id,
        method: 'delete',
        success: function(){
            $del.parent().remove();
        },
        error: function(){
            $('.error').html('We are sorry, but something went wrong!');
        }
    });
}
