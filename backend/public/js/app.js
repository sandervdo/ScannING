//# sourceMappingURL=app.js.map
var token = null;
function poll() {
    $.ajax({
        url: '/api/payment-request/' + token,
        type: 'GET',
        success : function(data) {
            console.log(data);
            console.log('client_id: ' + data.client_id + ' data.confirmed: ' + data.confirmed);
            if (data.client_id == null) {
                console.log('Waiting');
                setTimeout(poll, 1000);
            } else if (data.client_id && data.confirmed == null) {
                $('#qrcode')[0].innerHTML =
                    '<div class="alert alert-warning">Awaiting approval. Please check your device.</div>' +
                    '<div><img src="'+(data.client.avatar != null ? data.client.avatar : 'http://wiseheartdesign.com/images/articles/default-avatar.png')+'"/><br/><span>'+data.client.name+'</span></div>';
                console.log('Waiting');
                setTimeout(poll, 1000);
            } else {
                $('#qrcode')[0].innerHTML =
                    '<div class="alert alert-'+(data.confirmed == 1 ? 'success' : 'danger')+'">'+(data.confirmed == 1 ? 'Payment approved!' : 'Payment rejected!')+'</div>' +
                    '<div><img src="'+(data.client.avatar != null ? data.client.avatar : 'http://wiseheartdesign.com/images/articles/default-avatar.png')+'"/><br/><span>'+data.client.name+'</span></div>';
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
            "iban": "NL67INGB7620098993"
        },
        success: function (data) {
            $('#qrcode').qrcode(data.token);
            token = data.token;
            poll();
        }
    });
}

