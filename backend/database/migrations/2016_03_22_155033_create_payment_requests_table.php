<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePaymentRequestsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('clients', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name');
            $table->unsignedInteger('account');
            $table->foreign('account')->references('id')->on('accounts');
            $table->binary('avatar');
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('payment_requests', function (Blueprint $table) {
            $table->increments('id');
            $table->string('description');
            $table->float('amount');
            $table->unsignedInteger('requester');
            $table->foreign('requester')->references('id')->on('clients');
            $table->string('token');
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('clients', function(Blueprint $table) {
            $table->dropForeign('clients_account_foreign');
        });
        Schema::table('payment_requests', function(Blueprint $table) {
            $table->dropForeign('payment_requests_requester_foreign');
        });
        Schema::drop('payment_requests');
        Schema::drop('clients');
    }
}
