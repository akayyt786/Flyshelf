// Copyright (c) 2026 Arman Katia. All rights reserved.
// This software is provided for personal, non-commercial use only.
// Commercial redistribution or resale is strictly prohibited.
import StoreKit
import SwiftUI

class StoreManager: ObservableObject {
    static let shared = StoreManager()
    
    @Published var products: [Product] = []
    @Published var purchasedProductIDs = Set<String>()
    
    // Pro Tier entitlement
    var isProPlusEnabled: Bool {
        purchasedProductIDs.contains("com.dropshelf.lifetime_plus")
    }
    
    func fetchProducts() async {
        do {
            let storeProducts = try await Product.products(for: ["com.dropshelf.pro"])
            self.products = storeProducts
            await updatePurchasedProducts()
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updatePurchasedProducts()
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in StoreKit.Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            if transaction.revocationDate == nil {
                purchasedProductIDs.insert(transaction.productID)
            } else {
                purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
