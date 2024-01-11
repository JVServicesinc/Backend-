<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Order;

class Webhook extends Controller
{
    public function stripe()
    {
        $payload = @file_get_contents('php://input');
      
        $endpoint_secret = env('STRIPE_WEBHOOK_SECRET');
        $sig_header = $_SERVER['HTTP_STRIPE_SIGNATURE'];
        $event = null;

        try {
            $event = \Stripe\Webhook::constructEvent(
                $payload,
                $sig_header,
                $endpoint_secret
            );
            
        } catch (\UnexpectedValueException $e) {
            // Invalid payload
            http_response_code(400);
            exit();
        } catch (\Stripe\Exception\SignatureVerificationException $e) {
            // Invalid signature
            http_response_code(400);
            exit();
        }

        $webookData =  $event->data->object;

        // Handle the event
        switch ($event->type) {
            case 'checkout.session.completed':
                Order::updateOrderPaymentInfo($webookData);
                break;
            default:
                echo 'Received unknown event type ' . $event->type;
        }
    }
}
