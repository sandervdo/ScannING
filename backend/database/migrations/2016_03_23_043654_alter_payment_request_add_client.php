<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AlterPaymentRequestAddClient extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('payment_requests', function(Blueprint $table) {
            $table->unsignedInteger('client_id')->nullable()->default(null)->after('token');
            $table->foreign('client_id')->references('id')->on('clients');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('payment_requests', function(Blueprint $table) {
            $table->dropForeign('payment_requests_client_id_foreign');
            $table->dropColumn('client_id');
        });
    }
}
