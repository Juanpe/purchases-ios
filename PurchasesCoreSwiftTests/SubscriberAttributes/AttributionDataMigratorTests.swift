import XCTest
import Nimble
import StoreKit

@testable import PurchasesCoreSwift

class AttributionDataMigratorTests: XCTestCase {

    static var defaultIdfa = "00000000-0000-0000-0000-000000000000"
    static var defaultIdfv = "A9CFE78C-51F8-4808-94FD-56B4535753C6"
    static var defaultIp = "192.168.1.130"
    static var defaultGPSAdId = "e00000d0-0c0d-00b0-a000-acc0e00a0000"

    var attributionDataMigrator: AttributionDataMigrator!

    override func setUp() {
        super.setUp()
        attributionDataMigrator = AttributionDataMigrator()
    }

    func testAdjustAttributionIsConverted() {
        let adjustData = adjustData()
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: adjustData, network: AttributionNetwork.RCAttributionNetworkAdjust)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.adjustID: AttributionKey.Adjust.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.Adjust.network.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.Adjust.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.Adjust.adGroup.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.Adjust.creative.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: adjustData, expectedMapping: expectedMapping)
    }

    func testAdjustAttributionConversionGivesPreferenceToAdIdOverRCNetworkID() {
        let adjustData = adjustData(addAdId: true, addNetworkID: true)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: adjustData, network: AttributionNetwork.RCAttributionNetworkAdjust)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.adjustID: AttributionKey.Adjust.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.Adjust.network.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.Adjust.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.Adjust.adGroup.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.Adjust.creative.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: adjustData, expectedMapping: expectedMapping)
    }

    func testAdjustAttributionConversionConvertsRCNetworkIDCorrectly() {
        let adjustData = adjustData(addAdId: false, addNetworkID: true)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: adjustData, network: AttributionNetwork.RCAttributionNetworkAdjust)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.adjustID: AttributionKey.networkID.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.Adjust.network.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.Adjust.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.Adjust.adGroup.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.Adjust.creative.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: adjustData, expectedMapping: expectedMapping)
    }

    func testAdjustAttributionConversionWorksWithNullIDFA() {
        let adjustData = adjustData(withIDFA: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: adjustData, network: AttributionNetwork.RCAttributionNetworkAdjust)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfa: nil)
        let expectedMapping = [
            SpecialSubscriberAttributes.adjustID: AttributionKey.Adjust.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.Adjust.network.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.Adjust.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.Adjust.adGroup.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.Adjust.creative.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: adjustData, expectedMapping: expectedMapping)
    }

    func testAdjustAttributionConversionWorksWithNullIDFV() {
        let adjustData = adjustData(idfv: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: adjustData, network: AttributionNetwork.RCAttributionNetworkAdjust)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfv: nil)
        let expectedMapping = [
            SpecialSubscriberAttributes.adjustID: AttributionKey.Adjust.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.Adjust.network.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.Adjust.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.Adjust.adGroup.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.Adjust.creative.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: adjustData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionIsProperlyConverted() {
        let appsFlyerData = appsFlyerData()
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.AppsFlyer.channel.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.AppsFlyer.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.AppsFlyer.adSet.rawValue,
            SpecialSubscriberAttributes.ad: AttributionKey.AppsFlyer.ad.rawValue,
            SpecialSubscriberAttributes.keyword: AttributionKey.AppsFlyer.adKeywords.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.AppsFlyer.adID.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionConversionGivesPreferenceToAdIdOverRCNetworkID() {
        let appsFlyerData = appsFlyerData(addAppsFlyerId: true, addNetworkID: true)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.AppsFlyer.channel.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.AppsFlyer.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.AppsFlyer.adSet.rawValue,
            SpecialSubscriberAttributes.ad: AttributionKey.AppsFlyer.ad.rawValue,
            SpecialSubscriberAttributes.keyword: AttributionKey.AppsFlyer.adKeywords.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.AppsFlyer.adID.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionConversionConvertsRCNetworkIDCorrectly() {
        let appsFlyerData = appsFlyerData(addAppsFlyerId: false, addNetworkID: true)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.networkID.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.AppsFlyer.channel.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.AppsFlyer.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.AppsFlyer.adSet.rawValue,
            SpecialSubscriberAttributes.ad: AttributionKey.AppsFlyer.ad.rawValue,
            SpecialSubscriberAttributes.keyword: AttributionKey.AppsFlyer.adKeywords.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.AppsFlyer.adID.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionConversionWorksWithNullIDFA() {
        let appsFlyerData = appsFlyerData(withIDFA: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfa: nil)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.AppsFlyer.channel.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.AppsFlyer.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.AppsFlyer.adSet.rawValue,
            SpecialSubscriberAttributes.ad: AttributionKey.AppsFlyer.ad.rawValue,
            SpecialSubscriberAttributes.keyword: AttributionKey.AppsFlyer.adKeywords.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.AppsFlyer.adID.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionConversionWorksWithNullIDFV() {
        let appsFlyerData = appsFlyerData(idfv: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfv: nil)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.AppsFlyer.channel.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.AppsFlyer.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.AppsFlyer.adSet.rawValue,
            SpecialSubscriberAttributes.ad: AttributionKey.AppsFlyer.ad.rawValue,
            SpecialSubscriberAttributes.keyword: AttributionKey.AppsFlyer.adKeywords.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.AppsFlyer.adID.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionConvertsMediaSourceIfThereIsOnlyMediaSourceAttribution() {
        let appsFlyerData = appsFlyerData(addChannel: false, addMediaSource: true)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.AppsFlyer.mediaSource.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionConvertsMediaSourceIfThereIsChannelAndMediaSourceAttribution() {
        let appsFlyerData = appsFlyerData(addChannel: true, addMediaSource: true)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.AppsFlyer.channel.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionConvertsMediaSourceIfThereIsOnlyChannelAttribution() {
        let appsFlyerData = appsFlyerData(addChannel: true, addMediaSource: false)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.AppsFlyer.channel.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionConvertsAdIfThereIsOnlyAdGroupAttribution() {
        let appsFlyerData = appsFlyerData(addAd: false, addAdGroup: true)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.ad: AttributionKey.AppsFlyer.adGroup.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionConvertsAdIfThereIsAdAndAdGroupAttribution() {
        let appsFlyerData = appsFlyerData(addAd: true, addAdGroup: true)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.ad: AttributionKey.AppsFlyer.ad.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionConvertsAdIfThereIsOnlyAdAttribution() {
        let appsFlyerData = appsFlyerData(addAd: true, addAdGroup: false)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.ad: AttributionKey.AppsFlyer.ad.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionIsProperlyConvertedIfInsideDataKeyInDictionary() {
        var appsFlyerDataWithInnerJSON: [String: Any?]  = ["status": 1]
        let appsFlyerData: [String: Any?]  = appsFlyerData()
        var appsFlyerDataClean: [String: Any?] = [:]

        for (key, value) in appsFlyerData {
            if key.starts(with: "rc_") {
                appsFlyerDataWithInnerJSON[key] = value
            } else {
                appsFlyerDataClean[key] = value
            }
        }

        appsFlyerDataWithInnerJSON["data"] = appsFlyerDataClean

        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.AppsFlyer.id.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.AppsFlyer.channel.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.AppsFlyer.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.AppsFlyer.adSet.rawValue,
            SpecialSubscriberAttributes.ad: AttributionKey.AppsFlyer.ad.rawValue,
            SpecialSubscriberAttributes.keyword: AttributionKey.AppsFlyer.adKeywords.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.AppsFlyer.adID.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testAppsFlyerAttributionIsProperlyConvertedIfInsideDataKeyInDictionaryAndUsesRCNetworkID() {
        var appsFlyerDataWithInnerJSON: [String: Any?]  = ["status": 1]
        let appsFlyerData: [String: Any?]  = appsFlyerData(addAppsFlyerId: false, addNetworkID: true)
        var appsFlyerDataClean: [String: Any?] = [:]

        for (key, value) in appsFlyerData {
            if key.starts(with: "rc_") {
                appsFlyerDataWithInnerJSON[key] = value
            } else {
                appsFlyerDataClean[key] = value
            }
        }

        appsFlyerDataWithInnerJSON["data"] = appsFlyerDataClean

        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: appsFlyerData, network: AttributionNetwork.RCAttributionNetworkAppsFlyer)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.appsFlyerID: AttributionKey.networkID.rawValue,
            SpecialSubscriberAttributes.mediaSource: AttributionKey.AppsFlyer.channel.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.AppsFlyer.campaign.rawValue,
            SpecialSubscriberAttributes.adGroup: AttributionKey.AppsFlyer.adSet.rawValue,
            SpecialSubscriberAttributes.ad: AttributionKey.AppsFlyer.ad.rawValue,
            SpecialSubscriberAttributes.keyword: AttributionKey.AppsFlyer.adKeywords.rawValue,
            SpecialSubscriberAttributes.creative: AttributionKey.AppsFlyer.adID.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: appsFlyerData, expectedMapping: expectedMapping)
    }

    func testBranchAttributionIsConverted() {
        let branchData = branchData()
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: branchData, network: AttributionNetwork.RCAttributionNetworkBranch)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.mediaSource: AttributionKey.Branch.channel.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.Branch.campaign.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: branchData, expectedMapping: expectedMapping)
    }

    func testBranchAttributionConversionWorksWithNullIDFA() {
        let branchData = branchData(withIDFA: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: branchData, network: AttributionNetwork.RCAttributionNetworkBranch)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfa: nil)
        let expectedMapping = [
            SpecialSubscriberAttributes.mediaSource: AttributionKey.Branch.channel.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.Branch.campaign.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: branchData, expectedMapping: expectedMapping)
    }

    func testBranchAttributionConversionWorksWithNullIDFV() {
        let branchData = branchData(idfv: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: branchData, network: AttributionNetwork.RCAttributionNetworkBranch)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfv: nil)
        let expectedMapping = [
            SpecialSubscriberAttributes.mediaSource: AttributionKey.Branch.channel.rawValue,
            SpecialSubscriberAttributes.campaign: AttributionKey.Branch.campaign.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: branchData, expectedMapping: expectedMapping)
    }

    func testTenjinAttributionIsConverted() {
        let tenjinData = facebookOrTenjinData()
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: tenjinData, network: AttributionNetwork.RCAttributionNetworkTenjin)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
    }

    func testTenjinAttributionConversionWorksWithNullIDFA() {
        let tenjinData = facebookOrTenjinData(withIDFA: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: tenjinData, network: AttributionNetwork.RCAttributionNetworkTenjin)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfa: nil)
    }

    func testTenjinAttributionConversionWorksWithNullIDFV() {
        let tenjinData = facebookOrTenjinData(idfv: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: tenjinData, network: AttributionNetwork.RCAttributionNetworkTenjin)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfv: nil)
    }

    func testFacebookAttributionIsConverted() {
        let facebookData = facebookOrTenjinData()
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: facebookData, network: AttributionNetwork.RCAttributionNetworkFacebook)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
    }

    func testFacebookAttributionConversionWorksWithNullIDFA() {
        let facebookData = facebookOrTenjinData(withIDFA: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: facebookData, network: AttributionNetwork.RCAttributionNetworkFacebook)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfa: nil)
    }

    func testFacebookAttributionConversionWorksWithNullIDFV() {
        let facebookData = facebookOrTenjinData(idfv: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: facebookData, network: AttributionNetwork.RCAttributionNetworkFacebook)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfv: nil)
    }

    func testMParticleAttributionIsConverted() {
        let mparticleData = mParticleData()
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: mparticleData, network: AttributionNetwork.RCAttributionNetworkMParticle)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.mpParticleID: AttributionKey.MParticle.id.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: mparticleData, expectedMapping: expectedMapping)
    }

    func testMParticleAttributionConversionGivesPreferenceToMParticleIdOverRCNetworkID() {
        let mparticleData = mParticleData(addMParticleId: true, addNetworkID: true)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: mparticleData, network: AttributionNetwork.RCAttributionNetworkMParticle)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.mpParticleID: AttributionKey.MParticle.id.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: mparticleData, expectedMapping: expectedMapping)
    }

    func testMParticleAttributionConversionConvertsRCNetworkIDCorrectly() {
        let mparticleData = mParticleData(addMParticleId: false, addNetworkID: true)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: mparticleData, network: AttributionNetwork.RCAttributionNetworkMParticle)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted)
        let expectedMapping = [
            SpecialSubscriberAttributes.mpParticleID: AttributionKey.networkID.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: mparticleData, expectedMapping: expectedMapping)
    }

    func testMParticleAttributionConversionWorksWithNullIDFA() {
        let mparticleData = mParticleData(withIDFA: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: mparticleData, network: AttributionNetwork.RCAttributionNetworkAdjust)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfa: nil)
        let expectedMapping = [
            SpecialSubscriberAttributes.mpParticleID: AttributionKey.MParticle.id.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: mparticleData, expectedMapping: expectedMapping)
    }

    func testMParticleAttributionConversionWorksWithNullIDFV() {
        let mparticleData = mParticleData(idfv: nil)
        let converted = attributionDataMigrator.convertAttributionDataToSubscriberAttributes(
                attributionData: mparticleData, network: AttributionNetwork.RCAttributionNetworkAdjust)
        expect(converted.count) != 0
        checkCommonAttributes(in: converted, expectedIdfv: nil)
        let expectedMapping = [
            SpecialSubscriberAttributes.mpParticleID: AttributionKey.MParticle.id.rawValue
        ]
        checkConvertedAttributes(converted: converted, original: mparticleData, expectedMapping: expectedMapping)
    }
}

private extension AttributionDataMigratorTests {

    func checkConvertedAttributes(
            converted: [String: Any?],
            original: [String: Any?],
            expectedMapping: [String: String]
    ) {
        for (subscriberAttribute, attributionKey) in expectedMapping {
            expect((converted[subscriberAttribute] as! String)) == (original[attributionKey] as! String)
        }
    }

    func checkCommonAttributes(in converted: [String: Any?],
                               expectedIdfa: String? = defaultIdfa,
                               expectedIdfv: String? = defaultIdfv,
                               expectedIP: String? = defaultIp,
                               expectedGPSAdId: String? = defaultGPSAdId) {
        if expectedIdfa == nil {
            expect(converted[SpecialSubscriberAttributes.idfa]).to(beNil())
        } else {
            expect((converted[SpecialSubscriberAttributes.idfa] as! String)) == expectedIdfa
        }
        if expectedIdfv == nil {
            expect(converted[SpecialSubscriberAttributes.idfv]).to(beNil())
        } else {
            expect((converted[SpecialSubscriberAttributes.idfv] as! String)) == expectedIdfv
        }
        if expectedIP == nil {
            expect(converted[SpecialSubscriberAttributes.ip]).to(beNil())
        } else {
            expect((converted[SpecialSubscriberAttributes.ip] as! String)) == expectedIP
        }
        if expectedGPSAdId == nil {
            expect(converted[SpecialSubscriberAttributes.gpsAdId]).to(beNil())
        } else {
            expect((converted[SpecialSubscriberAttributes.gpsAdId] as! String)) == expectedGPSAdId
        }
    }

    func adjustData(withIDFA idfa: String? = defaultIdfa,
                    addAdId: Bool = true,
                    addNetworkID: Bool = false,
                    idfv: String? = defaultIdfv) -> [String: Any?] {
        var adjustData: [String: Any?] = [
            "clickLabel": "clickey",
            "trackerToken": "6abc940",
            "trackerName": "Instagram Profile::IG Spanish",
            "\(AttributionKey.Adjust.campaign.rawValue)": "IG Spanish",
            "\(AttributionKey.Adjust.adGroup.rawValue)": "an_ad_group",
            "\(AttributionKey.Adjust.creative.rawValue)": "a_creative",
            "\(AttributionKey.Adjust.network.rawValue)": "Instagram Profile",
            "\(AttributionKey.gpsAdId.rawValue)": AttributionDataMigratorTests.defaultGPSAdId,
            "\(AttributionKey.ip.rawValue)": AttributionDataMigratorTests.defaultIp,
            "\(AttributionKey.idfa.rawValue)": idfa,
            "\(AttributionKey.idfv.rawValue)": idfv
        ]
        if addAdId {
            adjustData[AttributionKey.Adjust.id.rawValue] = "20f0c0000aca0b00000fb0000c0f0f00"
        }
        if addNetworkID {
            adjustData[AttributionKey.networkID.rawValue] = "10f0c0000aca0b00000fb0000c0f0f00"
        }
        return adjustData
    }

    func appsFlyerData(withIDFA idfa: String? = defaultIdfa,
                       addAppsFlyerId: Bool = true,
                       addNetworkID: Bool = false,
                       idfv: String? = defaultIdfv,
                       addChannel: Bool = true,
                       addMediaSource: Bool = false,
                       addAd: Bool = true,
                       addAdGroup: Bool = false) -> [String: Any?] {
        var appsFlyerData: [String: Any?] = [
            "adset_id": "23847301359550211",
            "campaign_id": "23847301359200211",
            "click_time": "2021-05-04 18:08:51.000",
            "iscache": false,
            "adgroup_id": "238473013556789090",
            "is_mobile_data_terms_signed": true,
            "match_type": "srn",
            "agency": nil,
            "retargeting_conversion_type": "none",
            "install_time": "2021-05-04 18:20:45.050",
            "af_status": "Non-organic",
            "http_referrer": nil,
            "is_paid": true,
            "is_first_launch": false,
            "is_fb": true,
            "af_siteid": nil,
            "af_message": "organic install",
            "\(AttributionKey.AppsFlyer.adID.rawValue)": "23847301457860211",
            "\(AttributionKey.AppsFlyer.campaign.rawValue)": "0111 - mm - aaa - US - best creo 10 - Copy",
            "\(AttributionKey.AppsFlyer.adSet.rawValue)": "0005 - tm - aaa - US - best 8",
            "\(AttributionKey.AppsFlyer.adKeywords.rawValue)": "keywords for ad",
            "\(AttributionKey.gpsAdId.rawValue)": AttributionDataMigratorTests.defaultGPSAdId,
            "\(AttributionKey.ip.rawValue)": AttributionDataMigratorTests.defaultIp,
            "\(AttributionKey.idfa.rawValue)": idfa,
            "\(AttributionKey.idfv.rawValue)": idfv
        ]
        if addAppsFlyerId {
            appsFlyerData[AttributionKey.AppsFlyer.id.rawValue] = "110116141-131918411"
        }
        if addNetworkID {
            appsFlyerData[AttributionKey.networkID.rawValue] = "10f0c0000aca0b00000fb0000c0f0f00"
        }
        if addChannel {
            appsFlyerData[AttributionKey.AppsFlyer.channel.rawValue] = "Facebook"
        }
        if addMediaSource {
            appsFlyerData[AttributionKey.AppsFlyer.mediaSource.rawValue] = "Facebook Ads"
        }
        if addAd {
            appsFlyerData[AttributionKey.AppsFlyer.ad.rawValue] = "ad.mp4"
        }
        if addAdGroup {
            appsFlyerData[AttributionKey.AppsFlyer.adGroup.rawValue] = "1111 - tm - aaa - US - 999 v1"
        }
        return appsFlyerData
    }

    func branchData(withIDFA idfa: String? = defaultIdfa, idfv: String? = defaultIdfv) -> [String: Any?] {
        [
            "+is_first_session": false,
            "+clicked_branch_link": false,
            "\(AttributionKey.Branch.channel.rawValue)": "Facebook",
            "\(AttributionKey.Branch.campaign.rawValue)": "Facebook Ads 01293",
            "\(AttributionKey.ip.rawValue)": AttributionDataMigratorTests.defaultIp,
            "\(AttributionKey.gpsAdId.rawValue)": AttributionDataMigratorTests.defaultGPSAdId,
            "\(AttributionKey.idfa.rawValue)": idfa,
            "\(AttributionKey.idfv.rawValue)": idfv
        ]
    }

    func mParticleData(withIDFA idfa: String? = defaultIdfa,
                       idfv: String? = defaultIdfv,
                       addMParticleId: Bool = true,
                       addNetworkID: Bool = false) -> [String: Any?] {
        var mParticleData: [String: Any?] = [
            "\(AttributionKey.ip.rawValue)": AttributionDataMigratorTests.defaultIp,
            "\(AttributionKey.idfa.rawValue)": idfa,
            "\(AttributionKey.gpsAdId.rawValue)": AttributionDataMigratorTests.defaultGPSAdId,
            "\(AttributionKey.idfv.rawValue)": idfv
        ]
        if addMParticleId {
            mParticleData[AttributionKey.MParticle.id.rawValue] = "-2579252457900000000"
        }
        if addNetworkID {
            mParticleData[AttributionKey.networkID.rawValue] = "10f0c0000aca0b00000fb0000c0f0f00"
        }
        return mParticleData
    }

    func facebookOrTenjinData(withIDFA idfa: String? = defaultIdfa, idfv: String? = defaultIdfv) -> [String: Any?] {
        [
            "\(AttributionKey.ip.rawValue)": AttributionDataMigratorTests.defaultIp,
            "\(AttributionKey.gpsAdId.rawValue)": AttributionDataMigratorTests.defaultGPSAdId,
            "\(AttributionKey.idfa.rawValue)": idfa,
            "\(AttributionKey.idfv.rawValue)": idfv
        ]
    }
}