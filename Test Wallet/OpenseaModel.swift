//
//  OpenseaModel.swift
//  Test Wallet
//
//  Created by Shane Li on 2023/5/13.
//

import Foundation

struct Opensea {
    
    // MARK: BASIC
    
    enum ChainIdentity: String, Codable {
        // from opensea
        case arbitrum
        case avalanche
        case ethereum
        case klaytn
        case matic
        case optimism
        // customized
        case goerli
        case pomo
    }
    
    struct AssetContract: Codable {
        let address: String
        let chainIdentifier: ChainIdentity
        let name: String
        let schemaName: ERC
        let symbol: String
        
        enum CodingKeys: String, CodingKey {
            case address
            case chainIdentifier = "chain_identifier"
            case name
            case schemaName = "schema_name"
            case symbol
        }
        
        var abiData: Data? = nil
    }
    
    struct Collection: Codable {
        let primaryAssetContracts: [AssetContract]
        let ownedAssetCount: Int
        
        enum CodingKeys: String, CodingKey {
            case primaryAssetContracts = "primary_asset_contracts"
            case ownedAssetCount = "owned_asset_count"
        }
        
        var appliedChain: ChainIdentity? = nil
        var validAssetContracts: [AssetContract] {
            guard let appliedChain else { return [] }
            return primaryAssetContracts.filter { $0.chainIdentifier == appliedChain }
        }
    }
}

//let json = {
//    "primary_asset_contracts": [
//        {
//            "address": "0xb7d1cd8775fc723d7604c005124fbe4121aced8b",
//            "asset_contract_type": "non-fungible",
//            "chain_identifier": "ethereum",
//            "created_date": "2022-05-28T20:23:56.190901",
//            "name": "Neonbirds",
//            "nft_version": null,
//            "opensea_version": null,
//            "owner": 437088187,
//            "schema_name": "ERC721",
//            "symbol": "NB",
//            "total_supply": "5926",
//            "description": "6666 Birds having fun!",
//            "external_link": "https://neonbirds.netlify.app/",
//            "image_url": "https://i.seadn.io/gae/TlPU7SVkx5I0d6jIZcMjGzfQ2BbuJJUJwunSRiPKFHjMw9fcFvwestCTW5K8Z1jj3rIN86Kf2hl1IIDo7f-RCnLr2WoGA41hkUHgZQ?w=500&auto=format",
//            "default_to_fiat": false,
//            "dev_buyer_fee_basis_points": 0,
//            "dev_seller_fee_basis_points": 500,
//            "only_proxied_transfers": false,
//            "opensea_buyer_fee_basis_points": 0,
//            "opensea_seller_fee_basis_points": 250,
//            "buyer_fee_basis_points": 0,
//            "seller_fee_basis_points": 750,
//            "payout_address": "0x34e1a293b7dbe012a87a2d910458a608416d7c8a"
//        }
//    ],
//    "traits": {},
//    "stats": {
//        "one_minute_volume": 0,
//        "one_minute_change": 0,
//        "one_minute_sales": 0,
//        "one_minute_sales_change": 0,
//        "one_minute_average_price": 0,
//        "one_minute_difference": 0,
//        "five_minute_volume": 0,
//        "five_minute_change": 0,
//        "five_minute_sales": 0,
//        "five_minute_sales_change": 0,
//        "five_minute_average_price": 0,
//        "five_minute_difference": 0,
//        "fifteen_minute_volume": 0,
//        "fifteen_minute_change": 0,
//        "fifteen_minute_sales": 0,
//        "fifteen_minute_sales_change": 0,
//        "fifteen_minute_average_price": 0,
//        "fifteen_minute_difference": 0,
//        "thirty_minute_volume": 0,
//        "thirty_minute_change": 0,
//        "thirty_minute_sales": 0,
//        "thirty_minute_sales_change": 0,
//        "thirty_minute_average_price": 0,
//        "thirty_minute_difference": 0,
//        "one_hour_volume": 0,
//        "one_hour_change": 0,
//        "one_hour_sales": 0,
//        "one_hour_sales_change": 0,
//        "one_hour_average_price": 0,
//        "one_hour_difference": 0,
//        "six_hour_volume": 0,
//        "six_hour_change": 0,
//        "six_hour_sales": 0,
//        "six_hour_sales_change": 0,
//        "six_hour_average_price": 0,
//        "six_hour_difference": 0,
//        "one_day_volume": 0,
//        "one_day_change": 0,
//        "one_day_sales": 0,
//        "one_day_sales_change": 0,
//        "one_day_average_price": 0,
//        "one_day_difference": 0,
//        "seven_day_volume": 0,
//        "seven_day_change": 0,
//        "seven_day_sales": 0,
//        "seven_day_average_price": 0,
//        "seven_day_difference": 0,
//        "thirty_day_volume": 0,
//        "thirty_day_change": 0,
//        "thirty_day_sales": 0,
//        "thirty_day_average_price": 0,
//        "thirty_day_difference": 0,
//        "total_volume": 1.3770438999999974,
//        "total_sales": 396,
//        "total_supply": 5916,
//        "count": 5916,
//        "num_owners": 1684,
//        "average_price": 0.003477383585858579,
//        "num_reports": 1,
//        "market_cap": 0,
//        "floor_price": 0
//    },
//    "banner_image_url": "https://i.seadn.io/gae/ruC-Y2Ngw_31yOKRSPuo81a_i5zYAZBa-_M0upzNkV9T45Y541QRiE2tGTdVj1iMvRNqY8BtZ0lgqpMVG2arKhsmGoFYrqvJsG0MH5c?w=500&auto=format",
//    "chat_url": null,
//    "created_date": "2022-05-28T22:00:12.101453+00:00",
//    "default_to_fiat": false,
//    "description": "6666 Birds having fun!",
//    "dev_buyer_fee_basis_points": "0",
//    "dev_seller_fee_basis_points": "500",
//    "discord_url": null,
//    "display_data": {
//        "card_display_style": "contain"
//    },
//    "external_url": "https://neonbirds.netlify.app/",
//    "featured": false,
//    "featured_image_url": "https://i.seadn.io/gae/TlPU7SVkx5I0d6jIZcMjGzfQ2BbuJJUJwunSRiPKFHjMw9fcFvwestCTW5K8Z1jj3rIN86Kf2hl1IIDo7f-RCnLr2WoGA41hkUHgZQ?w=500&auto=format",
//    "hidden": false,
//    "safelist_request_status": "not_requested",
//    "image_url": "https://i.seadn.io/gae/TlPU7SVkx5I0d6jIZcMjGzfQ2BbuJJUJwunSRiPKFHjMw9fcFvwestCTW5K8Z1jj3rIN86Kf2hl1IIDo7f-RCnLr2WoGA41hkUHgZQ?w=500&auto=format",
//    "is_subject_to_whitelist": false,
//    "large_image_url": "https://i.seadn.io/gae/TlPU7SVkx5I0d6jIZcMjGzfQ2BbuJJUJwunSRiPKFHjMw9fcFvwestCTW5K8Z1jj3rIN86Kf2hl1IIDo7f-RCnLr2WoGA41hkUHgZQ?w=500&auto=format",
//    "medium_username": null,
//    "name": "Neonbirds NFT",
//    "only_proxied_transfers": false,
//    "opensea_buyer_fee_basis_points": "0",
//    "opensea_seller_fee_basis_points": 250,
//    "payout_address": "0x34e1a293b7dbe012a87a2d910458a608416d7c8a",
//    "require_email": false,
//    "short_description": null,
//    "slug": "neonbirds-nft",
//    "telegram_url": null,
//    "twitter_username": null,
//    "instagram_username": null,
//    "wiki_url": null,
//    "is_nsfw": false,
//    "fees": {
//        "seller_fees": {
//            "0x34e1a293b7dbe012a87a2d910458a608416d7c8a": 500
//        },
//        "opensea_fees": {
//            "0x0000a26b00c1f0df003000390027140000faa719": 250
//        }
//    },
//    "is_rarity_enabled": false,
//    "is_creator_fees_enforced": false,
//    "owned_asset_count": 1
//}
