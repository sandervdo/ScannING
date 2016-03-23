<?php

namespace App\Http\Controllers;

use App\Account;
use App\PaymentRequest;
use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Http\Requests;
use Validator;

class PaymentRequestController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return 'Nee';
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return 'Nee';
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'description'   => 'required',
            'amount'        => 'required',
            'iban'          => 'required|exists:accounts,iban',
        ]);

        if ($validator->fails()) {
            return view('welcome')->with('errors', $validator->errors());
        }

        $paymentRequest = PaymentRequest::create([
            'description'   => $request->get('description'),
            'amount'        => $request->get('amount'),
            'requester_id'  => Account::where('iban', $request->get('iban'))->first()->client->id,
            'token'         => $this->generateToken(),
        ]);

        return $paymentRequest;
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $token = PaymentRequest::where('token', $id)->first();
        if ($token == null) return ['success' => 0];

        $token->success = 1;
        return $token;
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'token'     => 'required',
            'confirm'   => 'required'
        ]);

        if ($validator->fails()) return view('welcome')->with('errors', $validator->errors());

        $payrequest = PaymentRequest::where('token', $id)->first();

        if($payrequest == null) {
            // TOOD: Update for payrequest
            return ['success' => false];
        }

        if ($request->get('confirm') == false) {
            $payrequest->confirmed = false;
            $payrequest->save();
            $this->deleteToken($id);
            return ['success' => true];
        }

        // scenario confirm == true
        $account = Account::find($payrequest->requester->account_id);

        if($this->checkBalance($payrequest, $account) == true) {
            $account->balance -= $payrequest->amount;
            $account->save();

            $payrequest->confirmed = true;
            $payrequest->save();

            $this->deleteToken($id);
            return ['success' => true];
        }

        // insuficient balance
        $payrequest->confirmed = false;
        $payrequest->save();
        return ['success' => false ];

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }

    /**
     * @param Request $request
     */
    public function payment(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'token' => 'required|exists:payment_requests,token',
            'iban'  => 'required|max:34|exists:accounts,iban'
        ]);

        if ($validator->fails()) { return view('welcome')->with('errors', $validator->errors()); }

        $pr = PaymentRequest::where('token', $request->get('token'));

        return $pr;
    }

    private function generateToken()
    {
        return $retString = "ScannING" . str_random(60);
    }

    private function deleteToken($id) {
        PaymentRequest::where('token', $id)->delete();
    }

    private function checkBalance(PaymentRequest $request, $account) {
        if($request->amount > $account->balance) {
            return false;
        }
        return true;
    }
}
