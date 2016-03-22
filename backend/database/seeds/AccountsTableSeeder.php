<?php

use Illuminate\Database\Seeder;

class AccountsTableSeeder extends Seeder
{
    /**
    * Run the database seeds.
    *
    * @return void
    */
    public function run()
    {
        // factory(App\Client::class,10)->create()->each(function($c) {
        //     $c->account()->save(factory(App\Account::class)->make);
        // });
        factory(App\Client::class,10)->create();
    }
}
