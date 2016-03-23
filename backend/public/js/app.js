//# sourceMappingURL=app.js.map
var token = null;
function poll() {
    $.ajax({
        url: '/api/payment-request/' + token,
        type: 'GET',
        success : function(data) {
            // console.log(data);
            confirmed = data.client_id;
            console.log(data.client_id);
            if (confirmed == null) {
                setTimeout(poll, 1000);
            } else if (confirmed) {
                console.log("Payment received!");
            } else {
                console.log("Something went wrong...");
            }
        }
    });
}

function checkoutClick() {
    $.ajax({
        url: '/api/payment-request',
        type: 'POST',
        data: {
            "description": "Nike shoes",
            "amount": 60.00,
            "iban": "NL18INGB9771295162"
        },
        success: function (data) {
            $('#qrcode').qrcode(data.token);
            token = data.token;
            poll();
        }
    });
}

