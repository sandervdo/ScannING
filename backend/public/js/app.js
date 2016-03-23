//# sourceMappingURL=app.js.map
var token = null;
function poll() {
    $.ajax({
        url: '/api/payment-request/' + token,
        type: 'GET',
        success : function(data) {
            var client_id = data.client_id;
            if (client_id == null) {
                console.log('Waiting');
                setTimeout(poll, 1000);
            } else if (client_id) {
                $('#qrcode')[0].innerHTML =
                    '<div class="alert alert-warning">Awaiting approval</div>' +
                    '<div><img src="'+data.client.avatar+'"/><span>'+data.client.name+'</span></div>';
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

