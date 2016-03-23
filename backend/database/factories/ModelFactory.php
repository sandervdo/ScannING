<?php

/*
|--------------------------------------------------------------------------
| Model Factories
|--------------------------------------------------------------------------
|
| Here you may define all of your model factories. Model factories give
| you a convenient way to create models for testing and seeding your
| database. Just tell the factory how a default model should look.
|
*/

use App\Client;

$factory->define(App\Account::class, function(Faker\Generator $faker) {
  return [
      'owner' => $faker->name,
      'iban' => $faker->numerify('NL##INGB##########'),
      'balance' => $faker->randomFloat(2)
  ];
});


$factory->define(App\Client::class, function(Faker\Generator $faker) {
  return [
      'name' => $faker->name,
      'account_id' => factory(App\Account::class)->create()->id,
      'avatar' => null
  ];
});

$factory->define(App\PaymentRequest::class, function(Faker\Generator $faker) {
    return [
        'description' => $faker->sentence,
        'amount' => $faker->numberBetween(1, 5000),
        'requester_id' => Client::orderByRaw("RAND()")->first()->id,
        'token' => "ScannING" . str_random(60),
        'created_at' => $faker->dateTimeThisMonth
    ];
});

