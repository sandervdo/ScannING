//# sourceMappingURL=app.js.map
$(document).ready(function() {

    $('#checkout').click(function() {
        $.ajax({
            url: '/api/payment-request',
            type: 'POST',
            data: {
                "description": "Nike shoes",
                "amount": 60.00,
                "iban": "NL18INGB9771295162"
            },
            success: function(data) {
                console.log(data);
                $('#qrcode').qrcode(data.token);
                // poll();
            }
        });
    });

    function poll() {
        $.ajax({
            url: '/api/payment-request/',
            type: 'GET',
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
