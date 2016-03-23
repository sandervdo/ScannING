<!DOCTYPE html>
<html>
<head>
    <title>ShoppING</title>

    <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet" type="text/css">
    <link href="https://bootswatch.com/flatly/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="{{ URL::asset('css/app.css') }}">
</head>
<body>
    <div class="navbar navbar-default navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <a href="../" class="navbar-brand">ShoppING</a>
                <button class="navbar-toggle" type="button" data-toggle="collapse" data-target="#navbar-main">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
            </div>
            <div class="navbar-collapse collapse" id="navbar-main">
                <ul class="nav navbar-nav">
                    <li><a href="#">LADIES</a></li>
                    <li><a href="#">MEN</a></li>
                    <li><a href="#">KIDS</a></li>
                    <li><a href="#">HOME</a></li>
                    <li><a href="#">SALE</a></li>
                </ul>

                <ul class="nav navbar-nav navbar-right">
                    <li><a href="#" target="_blank">SHOPPING BAG</a></li>
                    <li><a href="#" target="_blank">CONTACT</a></li>
                </ul>

            </div>
        </div>
    </div>
    <div class="container">
        <div class="page-header" id="banner">
            <div class="row">
                <div class="col-md-8">
                    <h1>Shopping Bag</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="list-group">
                        <a class="list-group-item" href="#navbar">
                            <div class="row">
                                <div class="col-sm-6">
                                    <img src="http://en.aw-lab.com/shop/media/catalog/product/cache/3/image/1024x640/5e06319eda06f020e43594a9c230972d/8/0/8016623_0/nike-lunartempo-30.jpg" alt="" width=120 />
                                </div>
                                <div class="col-sm-6">
                                    <strong>Nike LunarTempo</strong><br>
                                    Size: US 9<br>
                                    Price: €60
                                </div>

                            </div>
                        </a>
                    </div>
                    <button type="button" class="btn btn-info pull-right" id="checkout" name="button" onclick="checkoutClick()">Proceed to Checkout</button>
                </div>
                <div class="col-sm-6">
                    <div id="qrcode"></div>
                </div>
            </div>
        </div>

        @if(isset($errors) && count($errors) > 0)
            <div class="alert alert-danger">
                @foreach($errors as $error)
                @endforeach
            </div>
        @endif
    </div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
    <script type="text/javascript" src="js/jquery.qrcode.min.js"></script>
    <script src="{{ URL::asset('js/app.js') }}" type="text/javascript"></script>
</body>
</html>
