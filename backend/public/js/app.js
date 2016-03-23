//# sourceMappingURL=app.js.map
var token = null;
function poll() {
    $.ajax({
        url: '/api/payment-request/' + token,
        type: 'GET',
        success : function(data) {
            console.log(data);
            confirmed = data.confirmed;
            if (confirmed === null) {
                setTimeout(poll, 500);
            } else if (confirmed === 1) {
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
            console.log(data);
            $('#qrcode').qrcode(data.token);
            token = data.token;
            console.log('Token is ' + token);
            poll();
        }
    });
}

