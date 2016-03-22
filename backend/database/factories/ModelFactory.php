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

$factory->define(App\User::class, function (Faker\Generator $faker) {
    return [
        'name' => $faker->name,
        'email' => $faker->safeEmail,
        'password' => bcrypt(str_random(10)),
        'remember_token' => str_random(10),
    ];
});

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
      'account' => factory(App\Account::class)->create()->id,
      'avatar' => null
  ];
});
