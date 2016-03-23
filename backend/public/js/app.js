//# sourceMappingURL=app.js.map
$(document).ready(function() {

    $('#checkout').click(function() {
        $.ajax({
            url: 'http://213.187.246.84/api/payment-request',
            type: 'POST',
            dataType: 'jsonp',
            data: {
                "description": "Nike shoes",
                "amount": 60.00,
                "iban": "NL18INGB9771295162"
            },
            success: function(data) {
                $('#qrcode').qrcode(data.token);
                poll();
            }
        });
    });

    function poll() {
        $.ajax({
            url: 'http://213.187.246.84/api/payment-request/',
            type: 'GET',
            dataType : 'jsonp',
            success : function(data) {
                confirmed = data.confirmed;
                if (confirmed === null) {
                    setTimeout(poll, 1000);
                } else if (confirmed === 1) {
                    console.log("Payment received!");
                } else {
                    console.log("Something went wrong...");
                }
            }
        });
    };

});
