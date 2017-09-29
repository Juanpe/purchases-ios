//
//  RCPurchases.h
//  Purchases
//
//  Created by Jacob Eiting on 9/29/17.
//  Copyright © 2017 RevenueCat, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKProduct, SKPaymentTransaction, RCPurchaserInfo, RCPurchases;
@protocol RCPurchasesDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 `RCPurchases` is the entry point for Purchases.framework. It should be instantiated as soon as your app has a unique user id for your user. This can be when a user logs in if you have accounts or on launch if you can generate a random user identifier.

 ```
 - (void)setupPurchases {
     self.purchases = [[Purchases alloc] initWithSharedSecret:@"myappsharedsecret"
                                                    appUserId:@"a-user-identifier"];
     self.purcahses.delegate = self;
 }
 ```
 */
@interface RCPurchases : NSObject

/**
 Initializes an `RCPurchases` object with specified shared secret and app user ID.

 @note Best practice is to use a salted hash of your unique app user ids for improved privacy.

 @warning If you don't pass a *unique* identifier per user or install every purchases shared with all users. If you do not have an account system you can use an `NSUUID` and persist it using `NSUserDefaults`.

 @param sharedSecret The shared secret generated for your app from https://www.revenuecat.com/

 @param appUserID The unique app user id for this user. This user id will allow users to share their purchases and subscriptions across devices.

 @return An instantiated `RCPurchases` object
 */
- (instancetype _Nullable)initWithSharedSecret:(NSString *)sharedSecret
                                     appUserID:(NSString *)appUserID;

/**
 Delegate for `RCPurchases` instance. Object is responsible for handling completed purchases and updated subscription information.

 @note `RCPurchases` will not listen for any `SKTransactions` until the delegate is set. This prevents `SKTransactions` from being processed before your app is ready to handle them.
 */
@property (nonatomic, weak) id<RCPurchasesDelegate> _Nullable delegate;

/**
 Fetches the `SKProducts` for your IAPs for given `productIdentifiers`.

 @note You may wish to do this soon after app initialization and store the result to speed up your in app purchase experience. Slow purchase screens lead to decreased conversions.

 @note `completion` may be called without `SKProduct`s that you are expecting. This is usually caused by iTunesConnect configuration errors. Ensure your IAPs have the "Ready to Submit" status in iTunesConnect. Also ensure that you have an active developer program subscription and you have signed the latest paid application agreements.

 @param productIdentifiers A set of product identifiers for in app purchases setup via iTunesConnect. This should be either hard coded in your application, from a file, or from a custom endpoint if you want to be able to deploy new IAPs without an app update.
 @param completion An @escaping callback that is called with the loaded products. If the fetch fails for any reason it will return an empty array.
 */
- (void)productsWithIdentifiers:(NSSet<NSString *> *)productIdentifiers
                     completion:(void (^)(NSArray<SKProduct *>* products))completion;


/**
 Fetches the latest `RCPurchaserInfo` for the `appUserID` from the server.

 You should call this whenever the app is unused for a period of time to check if the user has renewed the subscription from another device. A good time to check might be when `UIApplicationDidBecomeActiveNotification` is fired if the user's existing subscriptions are expired.

 @param completion An @escaping callback that is called when the server responds with the latest subscriber info. If there is a failure for any way `purchaserInfo` will be nil.

 */
- (void)purchaserInfoWithCompletion:(void (^)(RCPurchaserInfo * _Nullable purchaserInfo))completion;

/**
 Purchase the passed `SKProduct`.

 Call this method when a user has decided to purchase a product. Only call this in direct response to user input.

 From here `Purhases` will handle the purchase with `StoreKit` and call `purchases:completedTransaction:withUpdatedInfo:` or `purchases:failedTransaction:withReason:` on the `RCPurchases` `delegate` object.

 @note You do not need to finish the transaction yourself in the delegate, Purchases will handle this for you.

 @param product The `SKProduct` the user intends to purchase
 */
- (void)makePurchase:(SKProduct *)product;

/**
 Same as `makePurchase:` but allows you to set the quantity. Only valid for consumable products.
 */
- (void)makePurchase:(SKProduct *)product
            quantity:(NSInteger)quantity;

/**
 A KVO compliant property that is `true` when a purchase is being processed, either with Apple or the backend. Can be useful for controlling whether or not the UI is in a `purchasing` state.
 */
@property (nonatomic, readonly) BOOL purchasing;

/**
 This version of the Purchases framework
*/
+ (NSString *)frameworkVersion;

@end

/**
 Delegate for `RCPurchases` responsible for handling updating your app's state in response to completed purchases.

 @note Delegate methods can be called at any time after the `delegate` is set, not just in response to `makePurchase:` calls. Ensure your app is capable of handling completed transactions anytime `delegate` is set.
 */
@protocol RCPurchasesDelegate

/**
 Called when a transaction has been succesfully posted to the backend. This will be called in response to `makePurchase:` call but can also occur at other times, especially when dealing with subscriptions.

 @param purchases Related `RCPurchases` object
 @param transaction The transaction that was approved by `StoreKit` and verified by the backend
 @param purchaserInfo The updated purchaser info returned from the backend. The new transaction may have had an effect on expiration dates and purchased products. Use this object to up-date your app state.

 */
- (void)purchases:(RCPurchases *)purchases completedTransaction:(SKPaymentTransaction *)transaction
  withUpdatedInfo:(RCPurchaserInfo *)purchaserInfo;

/**
 Called when a `transaction` fails to complete purchase with `StoreKit` or fails to be posted to the backend. The `localizedDescription` of `failureReason` will contain a message that may be useful for displaying to the user. Be sure to dismiss any purchasing UI if this method is called. This method can also be called at any time but outside of a purchasing context there often isn't much to do.

 @param purchases Related `RCPurchases` object
 @param transaction The transaction that failed to complete
 @param failureReason `NSError` containing the reason for the failure

 */
- (void)purchases:(RCPurchases *)purchases failedTransaction:(SKPaymentTransaction *)transaction withReason:(NSError *)failureReason;

@end

NS_ASSUME_NONNULL_END