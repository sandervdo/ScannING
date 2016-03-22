<?php

namespace App\Http\Controllers;

use App\PaymentRequest;
use Illuminate\Http\Request;

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
            'description' => 'required',
            'amount' => 'required',
            'requester' => 'required|exists:clients,id',
        ]);

        if ($validator->fails()) {
            return view('welcome')->with('errors', $validator->errors());
        }

        $paymentRequest = PaymentRequest::create([
            'description' => $request->get('description'),
            'amount' => $request->get('amount'),
            'requester' => $request->get('requester'),
            'token' => $this->generateToken(),
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
        if($token == null) {
            return ['success'=>0];
        }
        return ['success'=>1, $token];
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
        //
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

    private function generateToken()
    {
        return $retString = "ScannING" . str_random(60);
    }
}
