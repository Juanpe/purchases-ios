//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  CustomerInfoResponseHandler.swift
//
//  Created by Joshua Liebowitz on 11/18/21.

import Foundation

class CustomerInfoResponseHandler {

    init() { }

    func handle(customerInfoResponse response: HTTPResponse<Response>.Result,
                completion: CustomerAPI.CustomerInfoResponseHandler) {
        let result: Result<CustomerInfo, BackendError> = response
            .flatMap {
                if $0.body.errorResponse.attributeErrors.isEmpty {
                    return .success($0.body.customerInfo)
                } else {
                    return .failure(.errorResponse($0.body.errorResponse, $0.statusCode))
                }
            }
            .mapError(BackendError.networkError)

        completion(result)
    }

}

extension CustomerInfoResponseHandler {

    struct Response: HTTPResponseBody {

        let customerInfo: CustomerInfo
        let errorResponse: ErrorResponse

        static func create(with data: Data) throws -> Self {
            return .init(customerInfo: try CustomerInfo.create(with: data),
                         errorResponse: ErrorResponse.from(data))
        }

    }

}
