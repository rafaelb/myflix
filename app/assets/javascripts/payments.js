/**
 * Created by rafael on 21/09/14.
 */
jQuery(function($) {
    $('#register-form').submit(function(event) {
        var  $form = $(this);
        $form.find('.register_submit').prop('disabled',true);
        Stripe.card.createToken($form, stripeResponseHandler);
        return false;
        });

    function stripeResponseHandler(status, response) {
        var $form = $('#register-form');

        if (response.error) {
            // Show the errors on the form
            $form.find('.payment-errors').text(response.error.message);
            $form.find('button').prop('disabled', false);
        } else {
            // response contains id and card, which contains additional card details
            var token = response.id;
            // Insert the token into the form so it gets submitted to the server
            $form.append($('<input type="hidden" name="stripeToken" />').val(token));
            // and submit
            $form.get(0).submit();
        }
    }
});