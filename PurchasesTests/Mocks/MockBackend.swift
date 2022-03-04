//
// Created by RevenueCat on 2/28/20.
// Copyright (c) 2020 Purchases. All rights reserved.
//

@testable import RevenueCat

// swiftlint:disable large_tuple
// swiftlint:disable force_try
// swiftlint:disable line_length
class MockBackend: Backend {

    var invokedPostReceiptData = false
    var invokedPostReceiptDataCount = 0
    var stubbedPostReceiptCustomerInfo: CustomerInfo?
    var stubbedPostReceiptPurchaserError: Error?
    var invokedPostReceiptDataParameters: (data: Data?,
                                           appUserID: String?,
                                           isRestore: Bool,
                                           productData: ProductRequestData?,
                                           offeringIdentifier: String?,
                                           observerMode: Bool,
                                           subscriberAttributesByKey: [String: SubscriberAttribute]?,
                                           completion: BackendCustomerInfoResponseHandler?)?
    var invokedPostReceiptDataParametersList = [(data: Data?,
        appUserID: String?,
        isRestore: Bool,
        productData: ProductRequestData?,
        offeringIdentifier: String?,
        observerMode: Bool,
        subscriberAttributesByKey: [String: SubscriberAttribute]?,
        completion: BackendCustomerInfoResponseHandler?)]()

    public convenience init() {
        self.init(httpClient: MockHTTPClient(systemInfo: try! MockSystemInfo(platformInfo: nil,
                                                                             finishTransactions: false,
                                                                             dangerousSettings: nil),
                                             eTagManager: MockETagManager()),
                  apiKey: "mockAPIKey")
    }

    override func post(receiptData: Data,
                       appUserID: String,
                       isRestore: Bool,
                       productData: ProductRequestData?,
                       presentedOfferingIdentifier offeringIdentifier: String?,
                       observerMode: Bool,
                       subscriberAttributes subscriberAttributesByKey: SubscriberAttributeDict?,
                       completion: @escaping BackendCustomerInfoResponseHandler) {
        invokedPostReceiptData = true
        invokedPostReceiptDataCount += 1
        invokedPostReceiptDataParameters = (receiptData,
                                            appUserID,
                                            isRestore,
                                            productData,
                                            offeringIdentifier,
                                            observerMode,
                                            subscriberAttributesByKey,
                                            completion)
        invokedPostReceiptDataParametersList.append((receiptData,
                                                     appUserID,
                                                     isRestore,
                                                     productData,
                                                     offeringIdentifier,
                                                     observerMode,
                                                     subscriberAttributesByKey,
                                                     completion))
        completion(stubbedPostReceiptCustomerInfo, stubbedPostReceiptPurchaserError)
    }

    var invokedGetSubscriberData = false
    var invokedGetSubscriberDataCount = 0
    var invokedGetSubscriberDataParameters: (appUserID: String?, completion: BackendCustomerInfoResponseHandler?)?
    var invokedGetSubscriberDataParametersList = [(appUserID: String?,
        completion: BackendCustomerInfoResponseHandler?)]()

    var stubbedGetSubscriberDataCustomerInfo: CustomerInfo?
    var stubbedGetSubscriberDataError: Error?

    override func getCustomerInfo(appUserID: String, completion: @escaping BackendCustomerInfoResponseHandler) {
        invokedGetSubscriberData = true
        invokedGetSubscriberDataCount += 1
        invokedGetSubscriberDataParameters = (appUserID, completion)
        invokedGetSubscriberDataParametersList.append((appUserID, completion))
        completion(stubbedGetSubscriberDataCustomerInfo, stubbedGetSubscriberDataError)
    }

    var invokedGetIntroEligibility = false
    var invokedGetIntroEligibilityCount = 0
    var invokedGetIntroEligibilityParameters: (appUserID: String?, receiptData: Data?, productIdentifiers: [String]?, completion: IntroEligibilityResponseHandler?)?
    var invokedGetIntroEligibilityParametersList = [(appUserID: String?,
        receiptData: Data?,
        productIdentifiers: [String]?,
        completion: IntroEligibilityResponseHandler?)]()
    var stubbedGetIntroEligibilityCompletionResult: (eligibilities: [String: IntroEligibility], error: Error?)?

    override func getIntroEligibility(appUserID: String,
                                      receiptData: Data,
                                      productIdentifiers: [String],
                                      completion: @escaping IntroEligibilityResponseHandler) {
        invokedGetIntroEligibility = true
        invokedGetIntroEligibilityCount += 1
        invokedGetIntroEligibilityParameters = (appUserID, receiptData, productIdentifiers, completion)
        invokedGetIntroEligibilityParametersList.append((appUserID, receiptData, productIdentifiers, completion))
        completion(stubbedGetIntroEligibilityCompletionResult?.eligibilities ?? [:], stubbedGetIntroEligibilityCompletionResult?.error)
    }

    var invokedGetOfferingsForAppUserID = false
    var invokedGetOfferingsForAppUserIDCount = 0
    var invokedGetOfferingsForAppUserIDParameters: (appUserID: String?, completion: OfferingsResponseHandler?)?
    var invokedGetOfferingsForAppUserIDParametersList = [(appUserID: String?, completion: OfferingsResponseHandler?)]()
    var stubbedGetOfferingsCompletionResult: (data: [String: Any]?, error: Error?)?

    override func getOfferings(appUserID: String, completion: @escaping OfferingsResponseHandler) {
        invokedGetOfferingsForAppUserID = true
        invokedGetOfferingsForAppUserIDCount += 1
        invokedGetOfferingsForAppUserIDParameters = (appUserID, completion)
        invokedGetOfferingsForAppUserIDParametersList.append((appUserID, completion))

        completion(stubbedGetOfferingsCompletionResult?.data, stubbedGetOfferingsCompletionResult?.error)
    }

    var invokedPostAttributionData = false
    var invokedPostAttributionDataCount = 0
    var invokedPostAttributionDataParameters: (data: [String: Any]?, network: AttributionNetwork, appUserID: String?)?
    var invokedPostAttributionDataParametersList = [(data: [String: Any]?,
                                                     network: AttributionNetwork,
        appUserID: String?)]()
    var stubbedPostAttributionDataCompletionResult: (Error?, Void)?

    override func post(attributionData: [String: Any],
                       network: AttributionNetwork,
                       appUserID: String,
                       completion: ((Error?) -> Void)?) {
        invokedPostAttributionData = true
        invokedPostAttributionDataCount += 1
        invokedPostAttributionDataParameters = (attributionData, network, appUserID)
        invokedPostAttributionDataParametersList.append((attributionData, network, appUserID))
        if let result = stubbedPostAttributionDataCompletionResult {
            completion?(result.0)
        }
    }

    var invokedCreateAlias = false
    var invokedCreateAliasCount = 0
    var invokedCreateAliasParameters: (appUserID: String?, newAppUserID: String?)?
    var invokedCreateAliasParametersList = [(appUserID: String?, newAppUserID: String?)]()
    var stubbedCreateAliasCompletionResult: (Error?, Void)?

    override func createAlias(appUserID: String, newAppUserID: String, completion: ((Error?) -> Void)?) {
        invokedCreateAlias = true
        invokedCreateAliasCount += 1
        invokedCreateAliasParameters = (appUserID, newAppUserID)
        invokedCreateAliasParametersList.append((appUserID, newAppUserID))
        if let result = stubbedCreateAliasCompletionResult {
            completion?(result.0)
        }
    }

    var invokedPostOffer = false
    var invokedPostOfferCount = 0
    var invokedPostOfferParameters: (offerIdentifier: String?, productIdentifier: String?, subscriptionGroup: String?, data: Data?, applicationUsername: String?, completion: OfferSigningResponseHandler?)?
    var invokedPostOfferParametersList = [(offerIdentifier: String?,
        productIdentifier: String?,
        subscriptionGroup: String?,
        data: Data?,
        applicationUsername: String?,
        completion: OfferSigningResponseHandler?)]()
    var stubbedPostOfferCompetionResult: (String?, String?, UUID?, Int?, Error?)?

    override func post(offerIdForSigning offerIdentifier: String,
                       productIdentifier: String,
                       subscriptionGroup: String?,
                       receiptData: Data,
                       appUserID: String,
                       completion: @escaping OfferSigningResponseHandler) {
        invokedPostOffer = true
        invokedPostOfferCount += 1
        invokedPostOfferParameters = (offerIdentifier,
            productIdentifier,
            subscriptionGroup,
            receiptData,
            appUserID,
            completion)
        invokedPostOfferParametersList.append((offerIdentifier,
                                                  productIdentifier,
                                                  subscriptionGroup,
                                                  receiptData,
                                                  appUserID,
                                                  completion))
        if let result = stubbedPostOfferCompetionResult {
            completion(result.0, result.1, result.2, result.3, result.4)
        } else {
            completion(nil, nil, nil, nil, nil)
        }
    }

    var invokedPostSubscriberAttributes = false
    var invokedPostSubscriberAttributesCount = 0
    var invokedPostSubscriberAttributesParameters: (subscriberAttributes: [String: SubscriberAttribute]?, appUserID: String?)?
    var invokedPostSubscriberAttributesParametersList: [InvokedPostSubscriberAttributesParams] = []
    var stubbedPostSubscriberAttributesCompletionResult: (Error?, Void)?

    override func post(subscriberAttributes: SubscriberAttributeDict,
                       appUserID: String,
                       completion: ((Error?) -> Void)?) {
        invokedPostSubscriberAttributes = true
        invokedPostSubscriberAttributesCount += 1
        invokedPostSubscriberAttributesParameters = (subscriberAttributes, appUserID)
        invokedPostSubscriberAttributesParametersList.append(
            InvokedPostSubscriberAttributesParams(subscriberAttributes: subscriberAttributes, appUserID: appUserID)
        )
        if let result = stubbedPostSubscriberAttributesCompletionResult {
            completion?(result.0)
        } else {
            completion?(nil)
        }
    }

    struct InvokedPostSubscriberAttributesParams: Equatable {
        let subscriberAttributes: [String: SubscriberAttribute]?
        let appUserID: String?
    }

    var invokedLogIn = false
    var invokedLogInCount = 0
    var invokedLogInParameters: (currentAppUserID: String, newAppUserID: String)?
    var invokedLogInParametersList = [(currentAppUserID: String, newAppUserID: String)]()
    var stubbedLogInCompletionResult: (CustomerInfo?, Bool, Error?)?

    override func logIn(currentAppUserID: String,
                        newAppUserID: String,
                        completion: @escaping (CustomerInfo?, Bool, Error?) -> Void) {
        invokedLogIn = true
        invokedLogInCount += 1
        invokedLogInParameters = (currentAppUserID, newAppUserID)
        invokedLogInParametersList.append((currentAppUserID, newAppUserID))
        if let result = stubbedLogInCompletionResult {
            completion(result.0, result.1, result.2)
        }
    }
}
