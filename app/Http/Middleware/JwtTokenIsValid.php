<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Firebase\JWT\Key;
use Firebase\JWT\JWT;
use UnexpectedValueException;
use App\Models\User;

class JwtTokenIsValid
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Illuminate\Http\Response|\Illuminate\Http\RedirectResponse)  $next
     * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        $bearerTokenHeader = $request->header('Authorization');

        if(is_null($bearerTokenHeader)) {
            header('Content-Type:application/json');
            http_response_code(401);
            echo json_encode([
                'message' => 'authentication required',
            ]);
            die;
        }

        $token = $this->getBearerToken($bearerTokenHeader);

        if(is_null($token)) {
            header('Content-Type:application/json');
            http_response_code(401);
            echo json_encode([
                'status' => false,
                'message' => 'authentication required',
                'type' => 'jwt'
            ]);
            die;
        }

        $jwtToken = $token;
        
        try {
            $tokenData = JWT::decode($jwtToken, new Key(env('APP_SECRET'), 'HS256'));
        } catch( \Firebase\JWT\ExpiredException | UnexpectedValueException $e ) {
            header('Content-Type:application/json');
            http_response_code(400);
            echo json_encode([
                'status' => false,
                'message' => $e->getMessage(),
                'type' => 'jwt'
            ]);
            die;
        }

        global $userData;
        $userData = User::where('id', $tokenData->user_id)->first();

        return $next($request);
    }

    private function getBearerToken($authHeader) 
    {
        if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
            return $matches[1];
        }
    }
}